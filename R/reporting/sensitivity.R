# ===================================================================
# The steps shared by the Figure A3-style sensitivity figures of the paper's
# annexes: script/q_sensitivity.R (q), script/p_sensitivity.R (p) and
# script/instrument_layers_irf.R (instrument layer). Each runs one
# run_stage2_cell() per alternative, bands only the production cell and
# checks that cell against the production cache.
# ===================================================================


#' Stack the responses of several cells in long form
#'
#' @param cells List of `run_stage2_cell()` results, one per alternative.
#' @param labels Label of each cell, in the order of `cells`; becomes the
#'   factor `cell`, with the levels in this order.
#' @param band_label The label whose 80/90% bounds are kept. The other cells
#'   get NA bounds, as they are drawn in point only.
#' @param vars Variables to keep, by panel name.
#'
#' @return Tibble with `cell`, `variable`, `h`, `point`, `lo80`, `hi80`,
#'   `lo90`, `hi90`.
#'
#' @examples
#' paths <- stack_cell_paths(cells, c("q=5", "q=4"), "q=5", "yield_2y")
stack_cell_paths <- function(cells, labels, band_label, vars) {
  purrr::map2(cells, labels, function(cell, label) {
    with_bands <- label == band_label
    rows <- match(vars, cell$var_names)
    point <- cell$irf$irf_point_matrix
    ci80 <- cell$irf$ci[["0.80"]]
    ci90 <- cell$irf$ci[["0.90"]]

    purrr::map2(vars, rows, function(variable, row) {
      tibble::tibble(
        cell = label,
        variable = variable,
        h = seq_len(ncol(point)) - 1L,
        point = point[row, ],
        lo80 = if (with_bands) ci80$lower[row, ] else NA_real_,
        hi80 = if (with_bands) ci80$upper[row, ] else NA_real_,
        lo90 = if (with_bands) ci90$lower[row, ] else NA_real_,
        hi90 = if (with_bands) ci90$upper[row, ] else NA_real_
      )
    }) |>
      purrr::list_rbind()
  }) |>
    purrr::list_rbind() |>
    dplyr::mutate(cell = factor(cell, levels = labels))
}


#' Stop unless every 90% Anderson-Rubin set of a cell is an interval
#'
#' The bands draw `[lo, hi]`, which is the set only for an interval and, at
#' the normalization point, for the singleton `{normalize_value}`; any other
#' topology would be drawn as something it is not.
#'
#' @param cell A `run_stage2_cell()` result computed with `inference = "ar"`.
#' @param vars Variables whose sets are drawn.
#'
#' @return `cell`, invisibly.
#'
#' @examples
#' stop_unless_interval_sets(production_cell, c("yield_6m", "cds_5y"))
stop_unless_interval_sets <- function(cell, vars) {
  set_type90 <- cell$irf$ar$by_level[["0.90"]]$set_type
  set_type90 <- set_type90[match(vars, cell$var_names), , drop = FALSE]
  at_normalization <- vars[row(set_type90)] == cell$mp_var &
    col(set_type90) == 1L
  stopifnot(
    all(set_type90[!at_normalization] == "interval"),
    all(set_type90[at_normalization] == "singleton")
  )
  invisible(cell)
}


#' Stop unless the banded cell reproduces the production cache
#'
#' The production line of an annex figure must be section 4's line: its point
#' and 80/90% bounds are compared with `output/irf/irf_coherence_h.csv` to
#' 1e-10 at every variable and horizon drawn.
#'
#' @param band_paths Rows of `stack_cell_paths()` for the banded cell.
#' @param coherence_path Path of `irf_coherence_h.csv`.
#' @param vars Variables drawn.
#' @param h_max Last horizon drawn.
#'
#' @return `band_paths`, invisibly.
#'
#' @examples
#' stop_unless_matches_cache(band_paths, "output/irf/irf_coherence_h.csv",
#'                           "cds_5y", 36L)
stop_unless_matches_cache <- function(band_paths, coherence_path, vars,
                                      h_max) {
  band_columns <- c("point", "lo80", "hi80", "lo90", "hi90")
  production <- band_paths |>
    dplyr::filter(variable %in% vars, h <= h_max) |>
    dplyr::inner_join(
      readr::read_csv(coherence_path, show_col_types = FALSE),
      by = c("variable" = "var", "h"),
      suffix = c("", "_cache")
    )
  deviation <- abs(
    as.matrix(production[band_columns]) -
      as.matrix(production[paste0(band_columns, "_cache")])
  )
  stopifnot(
    nrow(production) == length(vars) * (h_max + 1L),
    max(deviation) < 1e-10
  )
  invisible(band_paths)
}


#' Put stacked responses in the units and labels of section 4
#'
#' @param paths Output of `stack_cell_paths()`.
#' @param panels Tibble with `variable`, `label` and `scale`; an NA scale is
#'   the response as a percentage of the variable's sample mean in `panel`.
#' @param panel Data frame of the panel in levels, one column per variable.
#' @param h_max Last horizon kept.
#'
#' @return `paths` restricted to `panels$variable` and `h <= h_max`, with the
#'   point and bounds rescaled and `variable` replaced by its label.
#'
#' @examples
#' paper_data <- rescale_to_paper_units(paths, PAPER_PANELS, raw_data, 36L)
rescale_to_paper_units <- function(paths, panels, panel, h_max) {
  panels <- panels |>
    dplyr::mutate(
      scale = dplyr::coalesce(scale, 100 / colMeans(panel[variable]))
    )
  paths |>
    dplyr::filter(h <= h_max) |>
    dplyr::inner_join(panels, by = "variable") |>
    dplyr::mutate(
      dplyr::across(c(point, lo80, hi80, lo90, hi90), \(x) x * scale),
      variable = label
    )
}
