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

if (!"--repaint-paper-figures" %in% commandArgs(trailingOnly = TRUE)) {
  stop(
    "fig_weak_iv_main.pdf is frozen at the wild-bootstrap vintage of the DFM. ",
    "Its caption contrasts bootstrap bands against AR sets, and both sides are ",
    "AR now. Use --repaint-paper-figures only in the editorial round that ",
    "rewrites the caption."
  )
}

# The only active small-VAR benchmark cell: the DFM's window and lag order
# since 2026-09-21
VAR_CELL     <- "ibc5_fx_cds_level_trend_p4"
VAR_SAMPLE   <- as.Date(c("2012-03-01", "2025-12-01"))
H_MAX        <- 36L
LEVELS       <- c(0.68, 0.90)

dfm <- readr::read_csv("output/irf/irf_coherence_h.csv", show_col_types = FALSE)
var <- readr::read_csv("output/var/svar_iv_weak_robust.csv", show_col_types = FALSE)
panel <- readr::read_csv("data/processed/data_log_deseasonalized.csv",
                         show_col_types = FALSE) |>
  dplyr::filter(
    ref.date >= VAR_SAMPLE[1L],
    ref.date <= VAR_SAMPLE[2L]
  )

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

dfm_bands <- dfm |>
  dplyr::filter(var %in% series$var, h >= 0L, h <= H_MAX) |>
  dplyr::select(var, h, point, lo68, hi68, lo90, hi90) |>
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
    model = "DFM"
  )

var_bands <- var |>
  dplyr::filter(
    cell == VAR_CELL,
    var %in% series$var,
    h >= 0L,
    h <= H_MAX,
    level %in% LEVELS
  ) |>
  dplyr::left_join(series, by = "var") |>
  dplyr::mutate(
    dplyr::across(c(point, lo, hi), ~ .x * var_scale),
    model = "VAR observável"
  )

# A disconnected or unbounded set would be drawn as the band [lo, hi]
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
    model = factor(model, levels = c("DFM", "VAR observável"))
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
#' @return A ggplot object with the point response and the 68%/90% bands,
#'   drawn as in `script/fig_section5.R`.
response_panel <- function(variable, model_name, y_label) {
  band90 <- dplyr::filter(bands, var == variable, model == model_name, level == 0.90)
  band68 <- dplyr::filter(bands, var == variable, model == model_name, level == 0.68)
  limits <- dplyr::filter(y_ranges, var == variable)

  ggplot2::ggplot(band90, ggplot2::aes(x = h)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lo, ymax = hi), fill = "steelblue", alpha = 0.18) +
    ggplot2::geom_ribbon(data = band68, ggplot2::aes(ymin = lo, ymax = hi),
                         fill = "steelblue", alpha = 0.36) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "red", linewidth = 0.35) +
    ggplot2::geom_line(ggplot2::aes(y = point), colour = "black", linewidth = 0.8) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, H_MAX, 6),
      limits = c(0, H_MAX),
      expand = c(0.01, 0)
    ) +
    ggplot2::scale_y_continuous(
      limits = c(limits$y_min - limits$padding, limits$y_max + limits$padding)
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

figure <- patchwork::wrap_plots(plots, ncol = 2L, byrow = TRUE)

ggplot2::ggsave(
  "paper/fig_weak_iv_main.pdf",
  figure,
  width = 8.2,
  height = 10.8,
  device = pdf,
  version = "1.4"
)
