# ===================================================================
# The steps shared by the Figure A3-style sensitivity figures of the paper's
# annexes: script/q_sensitivity.R (q), script/p_sensitivity.R (p) and
# script/instrument_layers_irf.R (instrument layer). Each runs one
# run_stage2_cell() per alternative, bands only the production cell and
# checks that cell against the production cache. Also the before/after
# comparisons of a change of the panel, script/focus_fixed_horizon.R and
# script/msci_emerging_index.R, which read the old production from git.
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
#' @param panels Tibble with `variable`, `label` and `scale`, the constant
#'   that puts the response in the units of the label.
#' @param h_max Last horizon kept.
#'
#' @return `paths` restricted to `panels$variable` and `h <= h_max`, with the
#'   point and bounds rescaled and `variable` replaced by its label.
#'
#' @examples
#' paper_data <- rescale_to_paper_units(paths, PAPER_PANELS, 36L)
rescale_to_paper_units <- function(paths, panels, h_max) {
  paths |>
    dplyr::filter(h <= h_max) |>
    dplyr::inner_join(panels, by = "variable") |>
    dplyr::mutate(
      dplyr::across(c(point, lo80, hi80, lo90, hi90), \(x) x * scale),
      variable = label
    )
}


#' Copy a file as it stands at a git commit to a temporary path
#'
#' `output/` is tracked, so an earlier production is read from git rather
#' than kept as a copy beside the current one.
#'
#' @param commit Commit, as `git show` takes it.
#' @param path Path in the repository.
#'
#' @return Path of the temporary copy.
#'
#' @examples
#' old_theta <- readr::read_csv(
#'   baseline_file("d9ac7f0", "output/factors/covid_volatility_theta.csv")
#' )
baseline_file <- function(commit, path) {
  copy <- tempfile(fileext = paste0(".", tools::file_ext(path)))
  status <- system2("git", c("show", paste0(commit, ":", path)), stdout = copy)
  if (status != 0L) {
    stop("git show ", commit, ":", path, " failed.")
  }
  copy
}


#' Compare the model of the production at a commit with the current one
#'
#' Reads, old from git and new from the working tree, the outputs of
#' script/covid_volatility_theta.R, script/model_alessi.R,
#' script/instrument_diagnostics.R and
#' script/validation/validate_production_spec.R, which must have run.
#'
#' @param commit Commit of the old production.
#'
#' @return Tibble with `quantity`, `window`, `old` and `new`: theta and its
#'   log-likelihood, xi_mp, F_rob and the largest companion root in each
#'   window, the r of each Bai-Ng criterion, the p of AIC and BIC, and xi_mp
#'   and F_rob of each instrument variant.
#'
#' @examples
#' model <- compare_model("d9ac7f0")
compare_model <- function(commit) {
  model_files <- c(
    theta = "output/factors/covid_volatility_theta.csv",
    diagnostics = "output/validation/production_spec_diagnostics.csv",
    bai_ng = "output/factors/production_bai_ng_bll_surface.csv",
    lag_criteria = "output/validation/production_factor_lag_criteria.csv",
    instrument = "output/instrument/instrument_diagnostics.csv"
  )
  model_tables <- purrr::map(model_files, function(path) {
    list(
      old = readr::read_csv(baseline_file(commit, path), show_col_types = FALSE),
      new = readr::read_csv(path, show_col_types = FALSE)
    )
  })

  purrr::map(c("old", "new"), function(version) {
    theta <- model_tables$theta[[version]]
    diagnostics <- model_tables$diagnostics[[version]]
    bai_ng <- model_tables$bai_ng[[version]]
    lag_criteria <- model_tables$lag_criteria[[version]]
    instrument <- model_tables$instrument[[version]]
    dplyr::bind_rows(
      tibble::tibble(
        quantity = c("s0", "s1", "s2", "rho", "loglik"),
        window = "full",
        value = c(theta$s0, theta$s1, theta$s2, theta$rho, theta$loglik)
      ),
      tibble::tibble(
        quantity = rep(
          c("xi_mp", "f_robust_mp", "max_companion_root"),
          each = 2
        ),
        window = rep(diagnostics$sample, 3),
        value = c(
          diagnostics$xi_mp,
          diagnostics$f_robust_mp,
          diagnostics$max_companion_root
        )
      ),
      tibble::tibble(
        quantity = paste0("bai_ng_", c("IC1", "IC2", "IC3")),
        window = "full",
        value = c(
          bai_ng$r[which.min(bai_ng$IC1)],
          bai_ng$r[which.min(bai_ng$IC2)],
          bai_ng$r[which.min(bai_ng$IC3)]
        )
      ),
      tibble::tibble(
        quantity = c("p_aic", "p_bic"),
        window = "full",
        value = c(
          lag_criteria$p[which.min(lag_criteria$aic)],
          lag_criteria$p[which.min(lag_criteria$bic)]
        )
      ),
      tibble::tibble(
        quantity = c(
          paste0("xi_mp_", instrument$variant),
          paste0("f_robust_mp_", instrument$variant)
        ),
        window = "full",
        value = c(instrument$xi_mp, instrument$f_robust_mp)
      )
    ) |>
      dplyr::mutate(version = version)
  }) |>
    purrr::list_rbind() |>
    tidyr::pivot_wider(names_from = version, values_from = value)
}


#' Compare two production cells response by response
#'
#' Every series and horizon up to `h_max` is paired: whether the new point
#' leaves the old 90% set, and whether each set is significant at 80 and
#' 90%. The ratio of the 90% widths leaves out the singleton of the
#' normalization, which has zero width in both cells.
#'
#' @param old_cell,new_cell `run_stage2_cell()` results computed with
#'   `inference = "ar"`, whose `var_names` line up.
#' @param labels Labels of the old and the new cell, in that order.
#' @param panels Tibble with `variable`, `label` and `scale` of the series
#'   tabulated and drawn in the units of section 4.
#' @param h_table Horizons of the table.
#' @param h_max Last horizon compared.
#'
#' @return List with `paper_paths` (the panels in paper units, both cells
#'   banded, for the figure), `table` (the panels at `h_table`, old and new
#'   side by side), `outside` (counts by series) and `by_h` (counts by
#'   horizon, every series).
#'
#' @examples
#' comparison <- compare_cells(old_cell, new_cell, c("antes", "agora"),
#'                             PAPER_PANELS, c(0L, 1L, 3L), 36L)
compare_cells <- function(old_cell, new_cell, labels, panels, h_table,
                          h_max) {
  stop_unless_interval_sets(old_cell, old_cell$var_names)
  stop_unless_interval_sets(new_cell, new_cell$var_names)

  paths <- dplyr::bind_rows(
    stack_cell_paths(list(old_cell), labels[1], labels[1], old_cell$var_names),
    stack_cell_paths(list(new_cell), labels[2], labels[2], new_cell$var_names)
  ) |>
    dplyr::filter(h <= h_max) |>
    dplyr::mutate(cell = factor(cell, levels = labels))

  paper_paths <- rescale_to_paper_units(paths, panels, h_max) |>
    dplyr::mutate(variable = factor(variable, levels = panels$label))
  table <- paper_paths |>
    dplyr::filter(h %in% h_table) |>
    dplyr::mutate(
      cell = dplyr::if_else(cell == labels[1], "old", "new"),
      sig90 = lo90 > 0 | hi90 < 0
    ) |>
    dplyr::select(variable, h, cell, point, lo80, hi80, lo90, hi90, sig90) |>
    tidyr::pivot_wider(
      names_from = cell,
      values_from = c(point, lo80, hi80, lo90, hi90, sig90)
    ) |>
    dplyr::arrange(variable, h)

  paired_paths <- paths |>
    dplyr::mutate(cell = dplyr::if_else(cell == labels[1], "old", "new")) |>
    tidyr::pivot_wider(
      names_from = cell,
      values_from = c(point, lo80, hi80, lo90, hi90)
    ) |>
    dplyr::mutate(
      outside_old90 = point_new < lo90_old | point_new > hi90_old,
      sig80_old = lo80_old > 0 | hi80_old < 0,
      sig80_new = lo80_new > 0 | hi80_new < 0,
      sig90_old = lo90_old > 0 | hi90_old < 0,
      sig90_new = lo90_new > 0 | hi90_new < 0,
      width90_ratio = dplyr::if_else(
        hi90_old > lo90_old,
        (hi90_new - lo90_new) / (hi90_old - lo90_old),
        NA_real_
      )
    )

  outside <- paired_paths |>
    dplyr::group_by(variable) |>
    dplyr::summarise(
      horizons_outside = paste(h[outside_old90], collapse = " "),
      outside_old90 = sum(outside_old90),
      sig90_old = sum(sig90_old),
      sig90_new = sum(sig90_new),
      width90_ratio = median(width90_ratio, na.rm = TRUE)
    ) |>
    dplyr::arrange(dplyr::desc(outside_old90))

  by_h <- paired_paths |>
    dplyr::group_by(h) |>
    dplyr::summarise(
      sig90_lost = sum(sig90_old & !sig90_new),
      sig90_gained = sum(!sig90_old & sig90_new),
      sig80_old = sum(sig80_old),
      sig80_new = sum(sig80_new),
      sig90_old = sum(sig90_old),
      sig90_new = sum(sig90_new),
      width90_ratio = median(width90_ratio, na.rm = TRUE)
    )

  list(
    paper_paths = paper_paths,
    table = table,
    outside = outside,
    by_h = by_h
  )
}
