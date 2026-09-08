# ===================================================================
# DFM and observable-SVAR impulse responses under weak instruments.
#
# Pure post-processing: DFM bands and VAR AR/MOSW sets.
# Output: paper/fig_weak_iv_main.pdf
#
# FROZEN since 2026-09-08. The whole point of this figure was that the two
# models carried different inference — wild bootstrap on the left, AR/MOSW on
# the right — and the caption in paper_anpec.tex says so. Since the DFM moved
# to Anderson-Rubin, output/irf/irf_coherence_h.csv no longer holds bootstrap
# bands and the contrast the caption announces no longer exists. Repainting is
# an editorial decision, not a re-run.
# ===================================================================

rm(list = ls())

source("R/modeling/production_spec.R")

if (!"--repaint-paper-figures" %in% commandArgs(trailingOnly = TRUE)) {
  stop(
    "fig_weak_iv_main.pdf is frozen at the wild-bootstrap vintage of the DFM. ",
    "Its caption contrasts bootstrap bands against AR sets, and both sides are ",
    "AR now. Use --repaint-paper-figures only in the editorial round that ",
    "rewrites the caption."
  )
}

SPEC <- production_spec()
VAR_SPEC <- SPEC$var_benchmark
DFM_PATH <- "output/irf/irf_coherence_h.csv"
VAR_PATH <- "output/var/svar_iv_weak_robust.csv"
DATA_PATH <- SPEC$data_path
H_MAX <- 36L
LEVELS <- c(0.68, 0.90)

required_packages <- c("dplyr", "ggplot2", "patchwork", "readr", "tidyr")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing packages: ", paste(missing_packages, collapse = ", "))
}

required_files <- c(DFM_PATH, VAR_PATH, DATA_PATH)
missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files)) {
  stop("Missing figure inputs: ", paste(missing_files, collapse = ", "))
}

dfm <- readr::read_csv(DFM_PATH, show_col_types = FALSE)
var <- readr::read_csv(VAR_PATH, show_col_types = FALSE)
panel <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |>
  dplyr::filter(
    ref.date >= VAR_SPEC$sample[1L],
    ref.date <= VAR_SPEC$sample[2L]
  )

dfm_columns <- c("var", "h", "point", "lo68", "hi68", "lo90", "hi90")
var_columns <- c("cell", "var", "h", "level", "point", "lo", "hi", "set_type")
if (!all(dfm_columns %in% names(dfm))) {
  stop("The DFM file is missing required columns")
}
if (!all(var_columns %in% names(var))) {
  stop("The VAR file is missing required columns")
}

series <- tibble::tibble(
  var = c("ibc_br", "price_ipca", "yield_6m", "cambio_usd", "cds_5y"),
  label = c(
    "IBC-Br (% da média)",
    "IPCA cheio (p.p. ao mês)",
    "DI 6 meses (p.b.)",
    "Câmbio BRL/USD (% da média)",
    "CDS 5 anos (p.b.)"
  ),
  dfm_scale = c(1, 1, 1e4, 100 / mean(panel$cambio_usd), 1),
  var_scale = c(100 / mean(panel$ibc_br), 1, 1e4, 100 / mean(panel$cambio_usd), 1)
)
if (
  nrow(panel) != VAR_SPEC$n_months ||
    !identical(series$var, VAR_SPEC$vars) ||
    !identical(H_MAX, VAR_SPEC$ar_horizon) ||
    !setequal(LEVELS, VAR_SPEC$ar_levels) ||
    any(!is.finite(c(series$dfm_scale, series$var_scale)))
) {
  stop("Unexpected sample, variables, horizon, confidence levels, or scales")
}

dfm_bands <- dfm |>
  dplyr::filter(var %in% series$var, h >= 0L, h <= H_MAX) |>
  dplyr::select(dplyr::all_of(dfm_columns)) |>
  tidyr::pivot_longer(
    cols = c(lo68, hi68, lo90, hi90),
    names_to = c("bound", "level"),
    names_pattern = "(lo|hi)(68|90)",
    values_to = "value"
  ) |>
  tidyr::pivot_wider(names_from = bound, values_from = value) |>
  dplyr::mutate(level = as.numeric(level) / 100) |>
  dplyr::left_join(series, by = "var") |>
  dplyr::mutate(
    dplyr::across(c(point, lo, hi), ~ .x * dfm_scale),
    model = "DFM",
    level_label = paste0(round(100 * level), "%")
  )

var_bands <- var |>
  dplyr::filter(
    cell == VAR_SPEC$label,
    var %in% series$var,
    h >= 0L,
    h <= H_MAX,
    level %in% LEVELS
  ) |>
  dplyr::left_join(series, by = "var") |>
  dplyr::mutate(
    dplyr::across(c(point, lo, hi), ~ .x * var_scale),
    model = "VAR observável",
    level_label = paste0(round(100 * level), "%")
  )

expected_rows <- nrow(series) * (H_MAX + 1L) * length(LEVELS)
if (
  nrow(dfm_bands) != expected_rows ||
    nrow(var_bands) != expected_rows ||
    anyDuplicated(dfm_bands[c("var", "h", "level")]) ||
    anyDuplicated(var_bands[c("var", "h", "level")]) ||
    !setequal(dfm_bands$h, 0:H_MAX) ||
    !setequal(var_bands$h, 0:H_MAX) ||
    !setequal(dfm_bands$level, LEVELS) ||
    !setequal(var_bands$level, LEVELS)
) {
  stop("The figure requires complete 0--36 responses at 68% and 90%")
}
if (any(!var_bands$set_type %in% c("interval", "singleton"))) {
  stop("The VAR contains an unbounded or disconnected AR/MOSW set")
}
if (
  any(!is.finite(as.matrix(dfm_bands[, c("point", "lo", "hi")]))) ||
    any(!is.finite(as.matrix(var_bands[, c("point", "lo", "hi")]))) ||
    any(dfm_bands$lo > dfm_bands$hi) ||
    any(var_bands$lo > var_bands$hi)
) {
  stop("The figure contains invalid numerical values or confidence bounds")
}

bands <- dplyr::bind_rows(dfm_bands, var_bands) |>
  dplyr::mutate(
    var = factor(var, levels = series$var),
    model = factor(model, levels = c("DFM", "VAR observável")),
    level_label = factor(level_label, levels = c("90%", "68%"))
  )

y_ranges <- bands |>
  dplyr::group_by(var) |>
  dplyr::summarise(
    y_min = min(lo, 0),
    y_max = max(hi, 0),
    .groups = "drop"
  ) |>
  dplyr::mutate(padding = pmax((y_max - y_min) * 0.04, .Machine$double.eps))

#' Build one DFM or observable-VAR response panel
#'
#' @param variable Variable name.
#' @param model_name Model column.
#' @param y_label Vertical-axis label.
#'
#' @return A ggplot object with the point response and 68%/90% bands.
response_panel <- function(variable, model_name, y_label) {
  plot_data <- bands |>
    dplyr::filter(var == variable, model == model_name) |>
    dplyr::arrange(level)
  limits <- dplyr::filter(y_ranges, var == variable)

  ggplot2::ggplot(plot_data, ggplot2::aes(x = h, y = point)) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = lo, ymax = hi, fill = level_label),
      alpha = 0.65
    ) +
    ggplot2::geom_hline(
      yintercept = 0,
      linetype = "dashed",
      colour = "#B22222",
      linewidth = 0.3
    ) +
    ggplot2::geom_line(colour = "black", linewidth = 0.65) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, H_MAX, 6),
      limits = c(0, H_MAX),
      expand = c(0.01, 0)
    ) +
    ggplot2::scale_y_continuous(
      limits = c(limits$y_min - limits$padding, limits$y_max + limits$padding)
    ) +
    ggplot2::scale_fill_manual(
      name = "Faixas",
      values = c("90%" = "#9ecae1", "68%" = "#2171b5")
    ) +
    ggplot2::labs(
      title = if (variable == series$var[1L]) model_name else NULL,
      x = if (variable == series$var[nrow(series)]) "Horizonte (meses)" else NULL,
      y = y_label
    ) +
    ggplot2::theme_classic(base_size = 9) +
    ggplot2::theme(
      axis.title = ggplot2::element_text(size = ggplot2::rel(0.9)),
      axis.text = ggplot2::element_text(size = ggplot2::rel(0.82)),
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold", size = 10),
      plot.margin = ggplot2::margin(1, 4, 1, 2)
    )
}

plots <- unlist(lapply(seq_len(nrow(series)), function(i) {
  list(
    response_panel(series$var[i], "DFM", series$label[i]),
    response_panel(series$var[i], "VAR observável", NULL)
  )
}), recursive = FALSE)

figure <- patchwork::wrap_plots(plots, ncol = 2L, byrow = TRUE) +
  patchwork::plot_layout(guides = "collect") &
  ggplot2::theme(legend.position = "bottom")

output_path <- "paper/fig_weak_iv_main.pdf"
ggplot2::ggsave(
  output_path,
  figure,
  width = 8.2,
  height = 10.8,
  device = grDevices::pdf,
  version = "1.4"
)
message("-> ", output_path, " (DFM wild bootstrap; VAR AR/MOSW; 68%/90%)")
