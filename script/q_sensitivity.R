# ===================================================================
# Compare q = 2, 3, 4 and 5 at fixed r = 5 for the twenty variables that
# organize the paper's empirical narrative, including all fiscal and
# expectation series, in one of the two windows of step 4/4 of the advisor's
# 2026-09-13 e-mail. The window is a required argument:
#
#   --window=cheia      2012-03..2025-12, p = 4, with the production
#                       Lenza-Primiceri (2022) COVID volatility in the factor
#                       VAR; the sets are on the transformed regression.
#   --window=pre_covid  2012-03..2019-12, p = 2. At p = 4 the pre-COVID AR
#                       covariance is blocked (hac_dim 135 >= T = 90,
#                       output/irf/ar_bands.md); at p = 2 it is feasible
#                       (hac_dim 85 < T = 92, the `pre_p2` cell of the archived
#                       arquivo/script/q_truncation.R).
#
# q = 5 carries its 80/90% Anderson-Rubin sets; q = 2, 3 and 4 are point
# estimates only, following the Figure A3 design of Alessi and Kerssenfischer
# (2019). The script only draws: output/factors/<stem>.pdf, the 20 variables
# to h = 48, and, for --window=cheia, paper/fig_q_sensibilidade.pdf, the
# paper's Anexo C figure: eight of them to h = 36, in the units of section 4.
# Notes: notas/2026-09-14_inferencia_volatilidade_covid_q.md,
# notas/2026-09-24_q_sensibilidade_anexo.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/reporting/figures.R")
source("R/reporting/sensitivity.R")
source("R/identification/weak_iv_ar.R")

WINDOW <- commandArgs(trailingOnly = TRUE) |>
  stringr::str_subset("^--window=") |>
  stringr::str_remove("^--window=")
if (length(WINDOW) != 1L || !WINDOW %in% c("cheia", "pre_covid")) {
  stop(
    "Pass --window=cheia or --window=pre_covid: the two windows of step 4/4 ",
    "differ in sample, p and the COVID volatility, and neither is a default."
  )
}

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
COHERENCE_PATH  <- "output/irf/irf_coherence_h.csv"
OUT_DIR         <- "output/factors"
PAPER_FIG       <- "paper/fig_q_sensibilidade.pdf"
R_FACTORS    <- 5L
Q_PRODUCTION <- 5L
Q_VALUES     <- c(5L, 4L, 3L, 2L)
Q_LABELS     <- paste0("q=", Q_VALUES)
PRODUCTION_LABEL <- paste0("q=", Q_PRODUCTION)
INSTRUMENT   <- "z_bs_purif"
MP_VAR       <- "yield_6m"
HORIZON      <- 48L
SHOCK_BPS    <- 50
CI_LEVELS    <- c(0.80, 0.90)
AR_NW_LAGS   <- 0L
H_PAPER      <- 36L
VARS <- c(
  "yield_6m", "yield_2y", "yield_5y", "cambio_usd", "embi_perc",
  "cds_5y", "expect_focus_ipca12m", "ibc_br", "price_ipca", "asset_ibov",
  "fiscal_dbgg", "fiscal_dlsp", "fiscal_primary_balance",
  "dlsp_exchange_adjustment",
  "expect_focus_selic_ny", "expect_focus_pib_ny", "expect_focus_cambio_ny",
  "expect_focus_fiscal_dlsp_ny", "expect_focus_fiscal_primary_balance_ny",
  "expect_focus_fiscal_nominal_balance_ny"
)
# Labels and scales of script/fig_section5.R
PAPER_PANELS <- tibble::tribble(
  ~variable,     ~label,                     ~scale,
  "yield_2y",    "DI 2 anos (p.b.)",         1e4,
  "yield_5y",    "DI 5 anos (p.b.)",         1e4,
  "cambio_usd",  "Câmbio BRL/USD (R$/US$)",  1,
  "cds_5y",      "CDS 5 anos (p.b.)",        1,
  "ibc_br",      "IBC-Br (pontos)",          1,
  "price_ipca",  "IPCA cheio (p.p. ao mês)", 1,
  "asset_ibov",  "Ibovespa (%)",             1,
  "fiscal_dlsp", "DLSP (p.p. do PIB)",       1
)
Q_PALETTE <- c(
  "q=5" = "black",
  "q=4" = "firebrick",
  "q=3" = "darkgreen",
  "q=2" = "steelblue"
)
Q_LINETYPE <- c("q=5" = "solid", "q=4" = "42", "q=3" = "22", "q=2" = "11")

# The pre-COVID window has no COVID month, so s_t = 1 throughout and
# estimate_dfm() rejects the scale there: OLS is the treated fit
CELL <- switch(WINDOW,
  cheia = list(
    sample = as.Date(c("2012-03-01", "2025-12-01")),
    p = 4L,
    covid_volatility = read_covid_volatility(THETA_PATH),
    stem = "q_narrative_r5p4_covid",
    title = paste(
      "Sensibilidade à dimensão dinâmica q: r = 5, p = 4, cheia com a",
      "volatilidade COVID (2012-03 a 2025-12)"
    )
  ),
  pre_covid = list(
    sample = as.Date(c("2012-03-01", "2019-12-01")),
    p = 2L,
    covid_volatility = NULL,
    stem = "q_narrative_r5p2_precovid",
    title = paste(
      "Sensibilidade à dimensão dinâmica q: r = 5, p = 2, pré-COVID",
      "(2012-03 a 2019-12)"
    )
  )
)
# One page of the narrative PDF per row
PAGES <- tibble::tibble(
  variables = list(VARS[1:6], VARS[7:10], VARS[11:14], VARS[15:20]),
  ncol = c(3, 2, 2, 3),
  title = c(CELL$title, "", "Variáveis fiscais", "Expectativas"),
  subtitle = c(
    paste(
      "z_bs_purif × yield_6m, choque de +50 pb; bandas Anderson-Rubin",
      "80/90% apenas para q=5"
    ),
    "",
    "",
    ""
  )
)

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
tcode <- infer_tcode_from_varnames(colnames(data_mat))

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))

cells <- purrr::map(Q_VALUES, function(q) {
  run_stage2_cell(
    data_mat,
    dates,
    inst_panel,
    sample_window = CELL$sample,
    r = R_FACTORS,
    q = q,
    p = CELL$p,
    instrument = INSTRUMENT,
    mp_var = MP_VAR,
    h = HORIZON,
    shock_bps = SHOCK_BPS,
    tcode = tcode,
    ci_levels = CI_LEVELS,
    inference = if (q == Q_PRODUCTION) "ar" else "none",
    ar_nw_lags = AR_NW_LAGS,
    covid_volatility = CELL$covid_volatility
  )
})

production_cell <- cells[[match(Q_PRODUCTION, Q_VALUES)]]
stop_unless_interval_sets(production_cell, VARS)

paths <- stack_cell_paths(cells, Q_LABELS, PRODUCTION_LABEL, VARS)
band_data <- dplyr::filter(paths, cell == PRODUCTION_LABEL)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
pdf(file.path(OUT_DIR, paste0(CELL$stem, ".pdf")), width = 11, height = 7.5)
purrr::pwalk(PAGES, function(variables, ncol, title, subtitle) {
  print(plot_dimension_overlay(
    paths,
    band_data,
    variables,
    palette = Q_PALETTE,
    linetypes = Q_LINETYPE,
    h_max = HORIZON,
    ncol = ncol,
    title = title,
    subtitle = subtitle
  ))
})
invisible(dev.off())

if (WINDOW == "cheia") {
  # The q = 5 line of the annex figure must be section 4's production line
  stop_unless_matches_cache(
    band_data,
    COHERENCE_PATH,
    PAPER_PANELS$variable,
    H_PAPER
  )
  paper_data <- rescale_to_paper_units(paths, PAPER_PANELS, H_PAPER)

  ggplot2::ggsave(
    PAPER_FIG,
    plot_dimension_overlay(
      paper_data,
      dplyr::filter(paper_data, cell == PRODUCTION_LABEL),
      PAPER_PANELS$label,
      palette = Q_PALETTE,
      linetypes = Q_LINETYPE,
      h_max = H_PAPER,
      ncol = 4,
      title = NULL,
      subtitle = NULL
    ),
    width = 10.4,
    height = 5.8,
    device = cairo_pdf
  )
}
