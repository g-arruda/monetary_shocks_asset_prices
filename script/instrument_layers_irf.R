# ===================================================================
# Impulse responses of the production DFM under each of the three
# construction layers of the instrument: z_bruto (raw DI surprise) and
# z_bs_purif (+ Bauer-Swanson pre-event orthogonalization, production), the
# rows of tab:first_stage, and z_jk_bs_purif (+ Jarocinski-Karadi sign filter),
# which only the footnote of section 3.3 compares. Only the instrument changes:
# (5,5,4), 2012-03..2025-12, the Lenza-Primiceri scale, +50bp on yield_6m.
# Every layer carries its 80/90% Anderson-Rubin sets (xi_mp > 3.84 in all),
# written to the CSV; the paper's Anexo C figure draws only the first two and
# bands only production, as in Figure A3 of Alessi and Kerssenfischer (2019),
# with the raw surprise in point.
# Output: output/irf/instrument_layers_irf.csv
#         paper/img/fig_instrumento_camadas.pdf
# Note: notas/2026-09-25_anexo_d_instrumento.md
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
OUT_CSV         <- "output/irf/instrument_layers_irf.csv"
PAPER_FIG       <- "paper/img/fig_instrumento_camadas.pdf"
SAMPLE_WINDOW <- as.Date(c("2012-03-01", "2025-12-01"))
R_FACTORS     <- 5L
Q_DYNAMIC     <- 5L
P_LAGS        <- 4L
MP_VAR        <- "yield_6m"
HORIZON       <- 36L
SHOCK_BPS     <- 50
CI_LEVELS     <- c(0.80, 0.90)
AR_NW_LAGS    <- 0L
LAYERS <- c("z_bs_purif", "z_bruto", "z_jk_bs_purif")
FIGURE_LAYERS <- c("z_bs_purif", "z_bruto")
LAYER_LABELS <- c(
  z_bs_purif = "Produção (ortogonalizada)",
  z_bruto = "Surpresa bruta",
  z_jk_bs_purif = "Filtro de sinal JK"
)
PRODUCTION_LABEL <- LAYER_LABELS[["z_bs_purif"]]
# Labels and scales of script/fig_section5.R
PAPER_PANELS <- tibble::tribble(
  ~variable,               ~label,                       ~scale,
  "yield_6m",              "DI 6 meses (p.b.)",          1e4,
  "yield_2y",              "DI 2 anos (p.b.)",           1e4,
  "cambio_usd",            "Câmbio BRL/USD (R$/US$)",    1,
  "cds_5y",                "CDS 5 anos (p.b.)",          1,
  "expect_focus_pib_12m",   "Focus PIB (p.p.)",           1,
  "expect_focus_ipca12m",  "Focus IPCA 12 meses (p.p.)", 1,
  "expect_focus_selic_12m", "Focus Selic (p.p.)",         1,
  "fiscal_dbgg",           "DBGG (p.p. do PIB)",         1
)
LAYER_PALETTE <- purrr::set_names(
  c("black", "steelblue"),
  LAYER_LABELS[FIGURE_LAYERS]
)
LAYER_LINETYPE <- purrr::set_names(
  c("solid", "22"),
  LAYER_LABELS[FIGURE_LAYERS]
)

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)
tcode <- infer_tcode_from_varnames(var_names)

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))

cells <- purrr::map(LAYERS, function(layer) {
  run_stage2_cell(
    data_mat,
    dates,
    inst_panel,
    sample_window = SAMPLE_WINDOW,
    r = R_FACTORS,
    q = Q_DYNAMIC,
    p = P_LAGS,
    instrument = layer,
    mp_var = MP_VAR,
    h = HORIZON,
    shock_bps = SHOCK_BPS,
    tcode = tcode,
    ci_levels = CI_LEVELS,
    inference = "ar",
    ar_nw_lags = AR_NW_LAGS,
    covid_volatility = read_covid_volatility(THETA_PATH)
  )
})

purrr::walk(cells, \(cell) {
  stop_unless_interval_sets(cell, PAPER_PANELS$variable)
})

# Every variable, horizon and layer, with the set topology beside the bounds
purrr::map2(cells, LAYERS, function(cell, layer) {
  ar_levels <- cell$irf$ar$by_level
  tibble::tibble(
    instrument = layer,
    variable = rep(var_names, times = HORIZON + 1L),
    h = rep(0:HORIZON, each = length(var_names)),
    point = c(cell$irf$irf_point_matrix),
    lo80 = c(cell$irf$ci[["0.80"]]$lower),
    hi80 = c(cell$irf$ci[["0.80"]]$upper),
    lo90 = c(cell$irf$ci[["0.90"]]$lower),
    hi90 = c(cell$irf$ci[["0.90"]]$upper),
    set_type80 = c(ar_levels[["0.80"]]$set_type),
    set_type90 = c(ar_levels[["0.90"]]$set_type)
  )
}) |>
  purrr::list_rbind() |>
  readr::write_csv(OUT_CSV)

paths <- stack_cell_paths(
  cells[match(FIGURE_LAYERS, LAYERS)],
  unname(LAYER_LABELS[FIGURE_LAYERS]),
  PRODUCTION_LABEL,
  PAPER_PANELS$variable
)
band_data <- dplyr::filter(paths, cell == PRODUCTION_LABEL)

# The production line of the annex figure must be section 4's line
stop_unless_matches_cache(
  band_data,
  COHERENCE_PATH,
  PAPER_PANELS$variable,
  HORIZON
)

paper_data <- rescale_to_paper_units(paths, PAPER_PANELS, HORIZON)

ggplot2::ggsave(
  PAPER_FIG,
  plot_dimension_overlay(
    paper_data,
    dplyr::filter(paper_data, cell == PRODUCTION_LABEL),
    PAPER_PANELS$label,
    palette = LAYER_PALETTE,
    linetypes = LAYER_LINETYPE,
    h_max = HORIZON,
    ncol = 4,
    title = NULL,
    subtitle = NULL
  ),
  width = 10.4,
  height = 5.8,
  device = cairo_pdf
)
