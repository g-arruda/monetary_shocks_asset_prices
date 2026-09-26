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

if (!"--repaint-paper-figures" %in% commandArgs(trailingOnly = TRUE)) {
  stop(
    "fig_weak_iv_main.pdf is frozen at the wild-bootstrap vintage of the DFM. ",
    "Its caption contrasts bootstrap bands against AR sets, and both sides are ",
    "AR now. Use --repaint-paper-figures only in the editorial round that ",
    "rewrites the caption."
  )
}

DFM_PATH   <- "output/irf/irf_coherence_h.csv"
VAR_PATH   <- "output/var/svar_iv_weak_robust.csv"
PANEL_PATH <- "data/processed/data_log_deseasonalized.csv"
OUT_PATH   <- "paper/fig_weak_iv_main.pdf"
# The only active small-VAR benchmark cell, on the DFM's window and lag order
VAR_CELL   <- "ibc5_fx_cds_level_trend_p4"
VAR_SAMPLE <- as.Date(c("2012-03-01", "2025-12-01"))
H_MAX      <- 36L
LEVELS     <- c(0.80, 0.90)
MODELS     <- c("DFM", "VAR observável")

dfm <- readr::read_csv(DFM_PATH, show_col_types = FALSE)
var <- readr::read_csv(VAR_PATH, show_col_types = FALSE)
panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
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
  var_scale = c(
    100 / mean(panel$ibc_br),
    1,
    1e4,
    100 / mean(panel$cambio_usd),
    1
  )
)

dfm_bands <- dfm |>
  dplyr::filter(var %in% series$var, h >= 0L, h <= H_MAX) |>
  dplyr::select(var, h, point, lo80, hi80, lo90, hi90) |>
  tidyr::pivot_longer(
    cols = c(lo80, hi80, lo90, hi90),
    names_to = c("bound", "level"),
    names_pattern = "(lo|hi)(80|90)",
    values_to = "value"
  ) |>
  tidyr::pivot_wider(names_from = bound, values_from = value) |>
  dplyr::mutate(level = as.numeric(level) / 100) |>
  dplyr::left_join(series, by = "var") |>
  dplyr::mutate(
    dplyr::across(c(point, lo, hi), \(x) x * dfm_scale),
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
    dplyr::across(c(point, lo, hi), \(x) x * var_scale),
    model = "VAR observável"
  )

# A disconnected or unbounded set would be drawn as the band [lo, hi]
if (any(!var_bands$set_type %in% c("interval", "singleton"))) {
  stop("The VAR contains an unbounded or disconnected AR/MOSW set")
}

bands <- dplyr::bind_rows(dfm_bands, var_bands) |>
  dplyr::mutate(
    var = factor(var, levels = series$var),
    model = factor(model, levels = MODELS)
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
#' The two models of a row share the vertical axis, and only the first row
#' carries the model title and only the last the horizon label.
#'
#' @param variable Variable name.
#' @param model_name Model, one of `MODELS`.
#' @param y_label Vertical-axis label, or `NULL` for none.
#'
#' @return A ggplot object with the point response and the 80%/90% bands,
#'   drawn as in `script/fig_section5.R`.
response_panel <- function(variable, model_name, y_label) {
  model_bands <- dplyr::filter(bands, var == variable, model == model_name)
  band90 <- dplyr::filter(model_bands, level == 0.90)
  band80 <- dplyr::filter(model_bands, level == 0.80)
  limits <- dplyr::filter(y_ranges, var == variable)

  ggplot2::ggplot(band90, ggplot2::aes(x = h)) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = lo, ymax = hi),
      fill = "steelblue",
      alpha = 0.18
    ) +
    ggplot2::geom_ribbon(
      data = band80,
      ggplot2::aes(ymin = lo, ymax = hi),
      fill = "steelblue",
      alpha = 0.36
    ) +
    ggplot2::geom_hline(
      yintercept = 0,
      linetype = "dashed",
      colour = "red",
      linewidth = 0.35
    ) +
    ggplot2::geom_line(
      ggplot2::aes(y = point),
      colour = "black",
      linewidth = 0.8
    ) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, H_MAX, 6),
      limits = c(0, H_MAX),
      expand = c(0.01, 0)
    ) +
    ggplot2::scale_y_continuous(
      limits = c(limits$y_min - limits$padding, limits$y_max + limits$padding)
    ) +
    ggplot2::labs(
      title = if (variable == dplyr::first(series$var)) model_name,
      x = if (variable == dplyr::last(series$var)) "Horizonte (meses)",
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

# DFM on the left, observable VAR on the right, one row per series
plots <- purrr::map2(series$var, series$label, function(variable, label) {
  list(
    response_panel(variable, "DFM", label),
    response_panel(variable, "VAR observável", NULL)
  )
}) |>
  purrr::list_flatten()

ggplot2::ggsave(
  OUT_PATH,
  patchwork::wrap_plots(plots, ncol = 2L, byrow = TRUE),
  width = 8.2,
  height = 10.8,
  device = pdf,
  version = "1.4"
)
