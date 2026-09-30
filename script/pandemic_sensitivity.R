# ===================================================================
# Sensitivity of the production responses to the pandemic months, in two
# contrasts against the production cell, (5,5,4), z_bs_purif, +50bp on
# yield_6m, 2012-03..2025-12 under the Lenza-Primiceri scale:
#   - the same window by ordinary least squares, without the scale;
#   - the pre-COVID window, 2012-03..2019-12.
# Production carries its 80/90% Anderson-Rubin sets; the two alternatives are
# point estimates only, the Figure A3 design of Alessi and Kerssenfischer
# (2019) that script/q_sensitivity.R applies to q.
# Output: output/irf/pandemic_sensitivity.csv
#         paper/fig_lp_sensibilidade.pdf, paper/fig_precovid_sensibilidade.pdf
#         (Anexo C)
# Note: notas/2026-09-30_robustez_pandemia.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/reporting/figures.R")
source("R/reporting/sensitivity.R")
source("R/identification/weak_iv_ar.R")

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
COHERENCE_PATH  <- "output/irf/irf_coherence_h.csv"
OUT_CSV         <- "output/irf/pandemic_sensitivity.csv"
SAMPLE_START  <- as.Date("2012-03-01")
R_FACTORS     <- 5L
Q_DYNAMIC     <- 5L
P_LAGS        <- 4L
INSTRUMENT    <- "z_bs_purif"
MP_VAR        <- "yield_6m"
HORIZON       <- 36L
SHOCK_BPS     <- 50
CI_LEVELS     <- c(0.80, 0.90)
AR_NW_LAGS    <- 0L
PRODUCTION_LABEL <- "Produção"
OLS_LABEL        <- "Mínimos quadrados ordinários"
PRE_COVID_LABEL  <- "Pré-COVID"
# The ordinary least squares cell is the untreated model, the object of the
# comparison. The pre-COVID window has no COVID month, so s_t = 1 throughout
# and estimate_dfm() rejects the scale there; its Anderson-Rubin covariance
# is blocked at p = 4 (hac_dim 135 >= T = 90), so it is drawn in point only.
CELLS <- tibble::tibble(
  label = c(PRODUCTION_LABEL, OLS_LABEL, PRE_COVID_LABEL),
  sample_end = as.Date(c("2025-12-01", "2025-12-01", "2019-12-01")),
  covid_volatility = list(read_covid_volatility(THETA_PATH), NULL, NULL),
  inference = c("ar", "none", "none")
)
# One Anexo C figure per alternative, each against production
PAPER_FIGS <- c(
  "paper/fig_lp_sensibilidade.pdf",
  "paper/fig_precovid_sensibilidade.pdf"
) |>
  purrr::set_names(c(OLS_LABEL, PRE_COVID_LABEL))
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

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))

cells <- purrr::pmap(
  dplyr::select(CELLS, -label),
  function(sample_end, covid_volatility, inference) {
    run_stage2_cell(
      data_mat,
      dates,
      inst_panel,
      sample_window = c(SAMPLE_START, sample_end),
      r = R_FACTORS,
      q = Q_DYNAMIC,
      p = P_LAGS,
      instrument = INSTRUMENT,
      mp_var = MP_VAR,
      h = HORIZON,
      shock_bps = SHOCK_BPS,
      tcode = infer_tcode_from_varnames(var_names),
      ci_levels = CI_LEVELS,
      inference = inference,
      ar_nw_lags = AR_NW_LAGS,
      covid_volatility = covid_volatility
    )
  }
)

# An explosive companion would draw a response that diverges with h
max_roots <- purrr::map_dbl(cells, "dfm_max_eig")
stopifnot(all(max_roots < 1))

stop_unless_interval_sets(cells[[1]], PAPER_PANELS$variable)

# Every variable of the panel, so the record can count beyond the eight drawn
paths <- stack_cell_paths(cells, CELLS$label, PRODUCTION_LABEL, var_names)

# The production line of the annex figures must be section 4's line
stop_unless_matches_cache(
  dplyr::filter(paths, cell == PRODUCTION_LABEL),
  COHERENCE_PATH,
  PAPER_PANELS$variable,
  HORIZON
)

paths |>
  dplyr::mutate(
    max_root = max_roots[match(cell, CELLS$label)],
    .after = cell
  ) |>
  readr::write_csv(OUT_CSV)

paper_data <- rescale_to_paper_units(paths, PAPER_PANELS, HORIZON)

# Colours and line types of script/instrument_layers_irf.R
purrr::iwalk(PAPER_FIGS, function(paper_fig, alternative_label) {
  drawn_labels <- c(PRODUCTION_LABEL, alternative_label)
  ggplot2::ggsave(
    paper_fig,
    plot_dimension_overlay(
      dplyr::filter(paper_data, cell %in% drawn_labels),
      dplyr::filter(paper_data, cell == PRODUCTION_LABEL),
      PAPER_PANELS$label,
      palette = purrr::set_names(c("black", "steelblue"), drawn_labels),
      linetypes = purrr::set_names(c("solid", "22"), drawn_labels),
      h_max = HORIZON,
      ncol = 4,
      title = NULL,
      subtitle = NULL
    ),
    width = 10.4,
    height = 5.8,
    device = cairo_pdf
  )
})
