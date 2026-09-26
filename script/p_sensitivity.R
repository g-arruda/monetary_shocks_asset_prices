# ===================================================================
# Sensitivity of the production responses to the lag order of the factor VAR:
# p = 2, ..., 6 at r = q = 5, full window 2012-03..2025-12, z_bs_purif,
# +50bp on yield_6m. The Lenza-Primiceri theta is re-estimated at each p by
# script/covid_volatility_theta.R, and each cell reads its own. p = 4 carries
# its 80/90% Anderson-Rubin sets; the other orders are point estimates only,
# the Figure A3 design of Alessi and Kerssenfischer (2019) that
# script/q_sensitivity.R applies to q.
# Output: output/factors/p_sensitivity.csv
#         paper/fig_p_sensibilidade.pdf (Anexo C)
# Note: notas/2026-09-25_p_sensibilidade_anexo.md
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
THETA_BY_P      <- "output/factors/theta_by_p/covid_volatility_theta_p%d.csv"
COHERENCE_PATH  <- "output/irf/irf_coherence_h.csv"
OUT_CSV         <- "output/factors/p_sensitivity.csv"
PAPER_FIG       <- "paper/fig_p_sensibilidade.pdf"
SAMPLE_WINDOW <- as.Date(c("2012-03-01", "2025-12-01"))
R_FACTORS     <- 5L
Q_DYNAMIC     <- 5L
P_PRODUCTION  <- 4L
P_VALUES      <- c(4L, 2L, 3L, 5L, 6L)
P_LABELS      <- paste0("p=", P_VALUES)
PRODUCTION_LABEL <- paste0("p=", P_PRODUCTION)
INSTRUMENT    <- "z_bs_purif"
MP_VAR        <- "yield_6m"
HORIZON       <- 36L
SHOCK_BPS     <- 50
CI_LEVELS     <- c(0.80, 0.90)
AR_NW_LAGS    <- 0L
# Labels and scales of script/fig_section5.R; an NA scale is the response as
# a percentage of the sample mean
PAPER_PANELS <- tibble::tribble(
  ~variable,     ~label,                     ~scale,
  "yield_2y",    "DI 2 anos (p.b.)",         1e4,
  "yield_5y",    "DI 5 anos (p.b.)",         1e4,
  "cambio_usd",  "Câmbio BRL/USD (%)",       NA,
  "cds_5y",      "CDS 5 anos (p.b.)",        1,
  "ibc_br",      "IBC-Br (%)",               NA,
  "price_ipca",  "IPCA cheio (p.p. ao mês)", 1,
  "asset_ibov",  "Ibovespa (%)",             1,
  "fiscal_dlsp", "DLSP (p.p. do PIB)",       1
)
P_PALETTE <- purrr::set_names(
  c("black", "darkorange", "darkgreen", "firebrick", "steelblue"),
  P_LABELS
)
P_LINETYPE <- purrr::set_names(
  c("solid", "11", "22", "42", "4212"),
  P_LABELS
)

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))

cells <- purrr::map(P_VALUES, function(p) {
  run_stage2_cell(
    data_mat,
    dates,
    inst_panel,
    sample_window = SAMPLE_WINDOW,
    r = R_FACTORS,
    q = Q_DYNAMIC,
    p = p,
    instrument = INSTRUMENT,
    mp_var = MP_VAR,
    h = HORIZON,
    shock_bps = SHOCK_BPS,
    tcode = infer_tcode_from_varnames(colnames(data_mat)),
    ci_levels = CI_LEVELS,
    inference = if (p == P_PRODUCTION) "ar" else "none",
    ar_nw_lags = AR_NW_LAGS,
    covid_volatility = read_covid_volatility(
      if (p == P_PRODUCTION) THETA_PATH else sprintf(THETA_BY_P, p)
    )
  )
})

# An explosive companion would draw a response that diverges with h
max_roots <- purrr::map_dbl(cells, "dfm_max_eig")
stopifnot(all(max_roots < 1))

stop_unless_interval_sets(
  cells[[match(P_PRODUCTION, P_VALUES)]],
  PAPER_PANELS$variable
)

paths <- stack_cell_paths(
  cells,
  P_LABELS,
  PRODUCTION_LABEL,
  PAPER_PANELS$variable
)
band_data <- dplyr::filter(paths, cell == PRODUCTION_LABEL)

# The p = 4 line of the annex figure must be section 4's production line
stop_unless_matches_cache(
  band_data,
  COHERENCE_PATH,
  PAPER_PANELS$variable,
  HORIZON
)

paths |>
  dplyr::mutate(
    max_root = max_roots[match(cell, P_LABELS)],
    .after = cell
  ) |>
  readr::write_csv(OUT_CSV)

paper_data <- rescale_to_paper_units(paths, PAPER_PANELS, raw_data, HORIZON)

ggplot2::ggsave(
  PAPER_FIG,
  plot_dimension_overlay(
    paper_data,
    dplyr::filter(paper_data, cell == PRODUCTION_LABEL),
    PAPER_PANELS$label,
    palette = P_PALETTE,
    linetypes = P_LINETYPE,
    h_max = HORIZON,
    ncol = 4,
    title = NULL,
    subtitle = NULL
  ),
  width = 10.4,
  height = 5.8,
  device = cairo_pdf
)
