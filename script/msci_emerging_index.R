# ===================================================================
# The panel's msci becomes the MSCI Emerging Markets index (2026-10-12):
# how much the series changes, how much the production cell of the step-0
# base changes with it, and how much steps 1 to 4 of the advisor's plan of
# 2026-10-03 change. The baseline is the step-0 base at BASELINE_COMMIT,
# read from git, where msci was the MSCI Inc. share price. The new outputs
# are this branch's, written by script/covid_volatility_theta.R,
# script/model_alessi.R, script/irf_coherence_check.R,
# script/instrument_diagnostics.R, script/mosw_strength_grid.R,
# script/validation/validate_production_spec.R, script/ar_precision.R,
# script/daily_event.R, script/meeting_influence.R and
# script/placebo_holm.R, which must run first. Nothing is estimated here.
# Output: output/msci_emerging_index/
#   series.csv, series_summary.csv  the share price and the index
#   model.csv                       theta, roots, strength, r and p selectors
#   irf_table.csv                   eight series at the horizons below
#   irf_outside.csv                 by series: new points outside the old
#                                   90% set, horizons whose sets exclude zero
#   irf_significance_by_h.csv       the same counts by horizon, every series
#   step1_*.csv, step2_daily_dfm.csv, step3_*.csv, step4_placebos.csv
#                                   the outputs of steps 1-4, old and new;
#                                   step3_ranking.csv pairs each meeting's
#                                   rank in the two rankings
#   series.pdf, irf.pdf
# Note: notas/2026-10-12_msci_emergentes.md
# ===================================================================

source("R/reporting/figures.R")
source("R/reporting/sensitivity.R")

# Step 4 committed on the step-0 base, the last commit before the swap
BASELINE_COMMIT <- "2348852"
OUT_DIR <- "output/msci_emerging_index"
SAMPLE_START <- as.Date("2012-03-01")
SAMPLE_END <- as.Date("2025-12-01")
H_TABLE <- c(0L, 1L, 3L, 6L, 12L, 24L, 36L)
H_MAX <- 36L
OLD_LABEL <- "ação da MSCI Inc."
NEW_LABEL <- "índice MSCI emergentes"
# Labels and scales of script/fig_section5.R, the eight series of Anexo C
PAPER_PANELS <- tibble::tribble(
  ~variable,                ~label,                       ~scale,
  "yield_6m",               "DI 6 meses (p.b.)",          1e4,
  "yield_2y",               "DI 2 anos (p.b.)",           1e4,
  "cambio_usd",             "Câmbio BRL/USD (R$/US$)",    1,
  "cds_5y",                 "CDS 5 anos (p.b.)",          1,
  "expect_focus_pib_12m",   "Focus PIB (p.p.)",           1,
  "expect_focus_ipca12m",   "Focus IPCA 12 meses (p.p.)", 1,
  "expect_focus_selic_12m", "Focus Selic (p.p.)",         1,
  "fiscal_dbgg",            "DBGG (p.p. do PIB)",         1
)

#' Pair the old and the new version of an output of steps 1-4
#'
#' @param path Path of the CSV in the repository.
#' @param keys Columns that identify a row in both versions.
#'
#' @return The rows present in both versions; every other column shared by
#'   the two is suffixed `_old` and `_new`.
#'
#' @examples
#' strength <- pair_versions("output/ar_precision/nw_strength.csv", "nw_lags")
pair_versions <- function(path, keys) {
  dplyr::inner_join(
    readr::read_csv(
      baseline_file(BASELINE_COMMIT, path),
      show_col_types = FALSE
    ),
    readr::read_csv(path, show_col_types = FALSE),
    by = keys,
    suffix = c("_old", "_new")
  )
}

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# Series ----

# The investing.com file download.R read until 2026-10-12, in pt-BR format
share_price <- readr::read_csv(
  "data/raw/investing/msci.csv",
  locale = readr::locale(decimal_mark = ",", grouping_mark = "."),
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::transmute(ref.date = lubridate::dmy(data), share_price = ultimo)

series <- readr::read_csv("data/raw/msci_em.csv", show_col_types = FALSE) |>
  dplyr::rename(index = msci_em) |>
  dplyr::inner_join(share_price, by = "ref.date") |>
  dplyr::filter(ref.date >= SAMPLE_START, ref.date <= SAMPLE_END) |>
  dplyr::arrange(ref.date)
readr::write_csv(series, file.path(OUT_DIR, "series.csv"))

manifest_status <- dplyr::bind_rows(
  old = readr::read_csv(
    baseline_file(
      BASELINE_COMMIT,
      "output/panel/production_series_manifest.csv"
    ),
    show_col_types = FALSE
  ),
  new = readr::read_csv(
    "output/panel/production_series_manifest.csv",
    show_col_types = FALSE
  ),
  .id = "version"
) |>
  dplyr::filter(variable == "msci")

tibble::tibble(
  n_months = nrow(series),
  cor_level = cor(series$share_price, series$index),
  cor_change = cor(diff(series$share_price), diff(series$index)),
  seasonal_status_old = manifest_status$seasonal_status[
    manifest_status$version == "old"
  ],
  seasonal_status_new = manifest_status$seasonal_status[
    manifest_status$version == "new"
  ]
) |>
  readr::write_csv(file.path(OUT_DIR, "series_summary.csv"))

series_plot <- series |>
  tidyr::pivot_longer(
    c(share_price, index),
    names_to = "series",
    values_to = "value"
  ) |>
  dplyr::mutate(
    series = factor(
      dplyr::if_else(
        series == "share_price",
        "Ação da MSCI Inc. (US$)",
        "Índice MSCI emergentes (pontos)"
      ),
      levels = c("Ação da MSCI Inc. (US$)", "Índice MSCI emergentes (pontos)")
    )
  ) |>
  ggplot2::ggplot(ggplot2::aes(x = ref.date, y = value)) +
  ggplot2::geom_line(linewidth = 0.5) +
  ggplot2::facet_wrap(ggplot2::vars(series), ncol = 2, scales = "free_y") +
  ggplot2::labs(x = NULL, y = NULL) +
  ggplot2::theme_classic(base_size = 10) +
  ggplot2::theme(
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(face = "bold")
  )
ggplot2::ggsave(
  file.path(OUT_DIR, "series.pdf"),
  series_plot,
  width = 8,
  height = 3,
  device = cairo_pdf
)

# Model ----

readr::write_csv(
  compare_model(BASELINE_COMMIT),
  file.path(OUT_DIR, "model.csv")
)

# Impulse responses ----

# The msci rows of the two cells are different series, the share price in
# dollars and the index in points, so their comparison counts nothing
comparison <- compare_cells(
  readRDS(baseline_file(BASELINE_COMMIT, "output/irf/irf_coherence_cell.rds")),
  readRDS("output/irf/irf_coherence_cell.rds"),
  c(OLD_LABEL, NEW_LABEL),
  PAPER_PANELS,
  H_TABLE,
  H_MAX
)
readr::write_csv(comparison$table, file.path(OUT_DIR, "irf_table.csv"))
readr::write_csv(comparison$outside, file.path(OUT_DIR, "irf_outside.csv"))
readr::write_csv(
  comparison$by_h,
  file.path(OUT_DIR, "irf_significance_by_h.csv")
)

ggplot2::ggsave(
  file.path(OUT_DIR, "irf.pdf"),
  plot_dimension_overlay(
    comparison$paper_paths,
    dplyr::filter(comparison$paper_paths, cell == OLD_LABEL),
    PAPER_PANELS$label,
    palette = setNames(c("black", "firebrick"), c(OLD_LABEL, NEW_LABEL)),
    linetypes = setNames(c("solid", "42"), c(OLD_LABEL, NEW_LABEL)),
    h_max = H_MAX,
    ncol = 4,
    title = NULL,
    subtitle = NULL
  ),
  width = 10.4,
  height = 5.8,
  device = cairo_pdf
)

# Steps 1-4 ----

precision <- pair_versions(
  "output/ar_precision/table.csv",
  c("cell", "variable", "h")
)
precision |>
  dplyr::filter(variable %in% c("cambio_usd", "cds_5y")) |>
  dplyr::select(
    cell, variable, h,
    dplyr::starts_with(c("point", "lo_90", "hi_90", "lo_95", "hi_95")),
    dplyr::starts_with(c("p_value_zero", "significant_90", "significant_95"))
  ) |>
  readr::write_csv(file.path(OUT_DIR, "step1_fx_cds.csv"))
precision |>
  dplyr::group_by(cell) |>
  dplyr::summarise(
    pairs = dplyr::n(),
    dplyr::across(
      dplyr::starts_with(c("significant_90", "significant_95")),
      \(significant) sum(significant, na.rm = TRUE)
    )
  ) |>
  readr::write_csv(file.path(OUT_DIR, "step1_significance_counts.csv"))
pair_versions("output/ar_precision/precovid_cells.csv", "cell") |>
  readr::write_csv(file.path(OUT_DIR, "step1_precovid_cells.csv"))
pair_versions("output/ar_precision/nw_strength.csv", "nw_lags") |>
  readr::write_csv(file.path(OUT_DIR, "step1_nw_strength.csv"))

pair_versions(
  "output/daily_event/comparison.csv",
  c("stage", "surprise", "response")
) |>
  dplyr::filter(stage == "dfm_mensal") |>
  readr::write_csv(file.path(OUT_DIR, "step2_daily_dfm.csv"))

pair_versions(
  "output/meeting_influence/joint_strength.csv",
  c("cell", "n_excluded")
) |>
  readr::write_csv(file.path(OUT_DIR, "step3_strength.csv"))
pair_versions("output/meeting_influence/ranking.csv", "date") |>
  dplyr::select(date, rank_old, rank_new, influence_old, influence_new) |>
  dplyr::arrange(rank_new) |>
  readr::write_csv(file.path(OUT_DIR, "step3_ranking.csv"))
pair_versions(
  "output/meeting_influence/joint_fx_cds.csv",
  c("cell", "variable", "level", "h")
) |>
  readr::write_csv(file.path(OUT_DIR, "step3_fx_cds.csv"))

pair_versions("output/placebo_holm/table.csv", c("variable", "h")) |>
  dplyr::select(-p_holm_without_msci) |>
  readr::write_csv(file.path(OUT_DIR, "step4_placebos.csv"))
