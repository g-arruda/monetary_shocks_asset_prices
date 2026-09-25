# ===================================================================
# Point-by-point theory-coherence check of the production IRFs for every
# variable of the theory table below, under the production specification,
# which is also written out below.
# Bands are the Anderson-Rubin sets. For each variable, every horizon
# h = 0..48 is checked for sign and for exclusion of zero at 68% and 90%
# against its theory window, by evaluate_irf_path()
# (R/identification/irf_coherence.R).
# Outputs: output/irf/irf_coherence_h.csv, irf_coherence_summary.csv,
#          irf_coherence_cell.rds
# The interpretive reading lives in output/irf/irf_coherence_leitura.md,
# which no script touches.
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")
source("R/identification/weak_iv_ar.R")

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
OUT_DIR         <- "output/irf"
CELL_PATH       <- file.path(OUT_DIR, "irf_coherence_cell.rds")
SAMPLE     <- as.Date(c("2012-03-01", "2025-12-01"))
R_FACTORS  <- 5L
Q_DYNAMIC  <- 5L
P_LAGS     <- 4L
INSTRUMENT <- "z_jk_bs_purif"
MP_VAR     <- "yield_6m"
HORIZON    <- 48L
INFERENCE  <- "ar"
AR_NW_LAGS <- 0L          # Eicker-White
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.68, 0.90)

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

# Theory table: one row per group of variables sharing a sign, a tier and a
# window [w_lo, w_hi]; evaluate_irf_path() documents what each tier means.
theory_table <- tibble::tribble(
  ~var, ~group, ~theory_sign, ~tier, ~w_lo, ~w_hi,
  # yield_6m is the normalization variable: its h0 is MECHANICAL
  # (= shock_bps/10000 by ident_ext_instr()), so 1 of the 7 points in the
  # window is free and h1..h6 are what inform the verdict. It stays so the
  # delivered +50bp is auditable in the output table.
  c("yield_3m", "yield_6m", "yield_1y", "yield_2y", "yield_5y", "yield_10y"),
  "curva_juros", 1, "scored", 0, 6,
  "juros_selic", "curva_juros", 1, "scored", 1, 12,
  c("asset_ibov", "asset_smll", "asset_idiv", "asset_imob", "asset_ifix"),
  "acoes", -1, "scored", 0, 6,
  c("asset_ifnc", "asset_imat"), "acoes_ambiguas", NA, "ambiguous", 0, 6,
  c("cambio_usd", "cambio_eur", "embi_perc", "cds_5y"),
  "risco_cambio_soft", -1, "soft", 0, 6,
  c("ibc_br", "pib", "ind_transformacao", "ind_bens_duraveis",
    "ind_bens_capital", "vendas_varejo", "vendas_servicos", "ind_automoveis",
    "capacidade_instalada_industria"),
  "atividade", -1, "scored", 3, 24,
  "trab_tx_desemprego", "trabalho", 1, "scored", 6, 36,
  c("trab_pop_ocupada", "trab_hrs_trabalhadas_industria"),
  "trabalho", -1, "scored", 6, 36,
  c("credit_outstanding", "credito_pessoa_fisica"),
  "credito", -1, "scored", 6, 36,
  c("spread_credito_pj_total", "spread_credito_pf_total"),
  "credito", 1, "scored", 0, 12,
  c("credito_comercio", "credito_transporte", "credito_industria_total"),
  "credito_setorial", -1, "scored", 6, 36,
  # Agriculture and construction credit is mostly earmarked (rural, SFH):
  # attenuated transmission (Bonomo-Martins 2016), no strong prior
  c("credito_agro", "credito_construcao"),
  "credito_setorial", NA, "ambiguous", 6, 36,
  c("price_ipca", "price_ipca_difusao", "price_core_ipca_ex0",
    "price_core_ipca_ex1", "price_core_ipca_dw", "price_inpc"),
  "precos", -1, "scored", 12, 48,
  c("price_igp_m", "price_ipp"), "precos_ambiguos", NA, "ambiguous", 12, 48,
  # commodity_metal is the BCB IC-Br, denominated in BRL: a DOMESTIC price
  # that mechanically inherits the FX response, not an external placebo. In
  # diagnostics/01_exogeneidade.R sec 1.6 the BRL index violates (+12.07,
  # sig90 in 4 of h0-h4) while index/cambio_usd passes 25/25 horizons
  # (+0.42, CI90 [-1.44, 1.88]): the violation is denomination, not the
  # instrument's.
  "commodity_metal", "commodity_domestica", NA, "ambiguous", 0, 24,
  c("fiscal_dbgg", "fiscal_dlsp", "fiscal_primary_balance"),
  "fiscal", NA, "ambiguous", 0, 48,
  c("expect_focus_ipca12m", "expect_focus_selic_ny", "expect_focus_pib_ny",
    "expect_focus_cambio_ny"),
  "expectativas", NA, "ambiguous", 0, 48,
  c("sp500_vix", "msci", "epu_us"), "placebo_externas", 0, "placebo", 0, 24
) |>
  tidyr::unnest(var)
missing_vars <- setdiff(theory_table$var, var_names)
if (length(missing_vars) > 0) {
  stop(
    "Variaveis da tabela de coerencia ausentes no painel: ",
    paste(missing_vars, collapse = ", ")
  )
}

cell <- run_stage2_cell(
  data_mat,
  dates,
  inst_panel,
  sample_window = SAMPLE,
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_LAGS,
  instrument = INSTRUMENT,
  mp_var = MP_VAR,
  h = HORIZON,
  shock_bps = SHOCK_BPS,
  tcode = tcode,
  ci_levels = CI_LEVELS,
  inference = INFERENCE,
  ar_nw_lags = AR_NW_LAGS,
  # The production cell carries the Lenza-Primiceri scale, as the DFM of
  # section 4 does. Section 5 is scored off this run.
  covid_volatility = read_covid_volatility(THETA_PATH)
)
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
saveRDS(cell, CELL_PATH)

point <- cell$irf$irf_point_matrix
ci68 <- cell$irf$ci[["0.68"]]
ci90 <- cell$irf$ci[["0.90"]]
ar <- cell$irf$ar

# The AR set is bounded at level kappa iff xi_mp exceeds the critical value
bounded_as_predicted <- purrr::map_lgl(CI_LEVELS, function(level) {
  by_level <- ar$by_level[[sprintf("%.2f", level)]]
  (by_level$ahat[1L, 1L] > 0) == (ar$xi_den > by_level$critval)
})
stopifnot(
  "Set boundedness disagrees with xi_mp > critval" = all(bounded_as_predicted)
)

evaluations <- purrr::map(seq_len(nrow(theory_table)), function(i) {
  spec <- theory_table[i, ]
  row <- match(spec$var, var_names)
  evaluate_irf_path(
    point[row, ],
    ci68$lower[row, ],
    ci68$upper[row, ],
    ci90$lower[row, ],
    ci90$upper[row, ],
    spec,
    set_type68 = ar$by_level[["0.68"]]$set_type[row, ],
    set_type90 = ar$by_level[["0.90"]]$set_type[row, ]
  )
})

evaluations |>
  purrr::map("perh") |>
  dplyr::bind_rows() |>
  readr::write_csv(file.path(OUT_DIR, "irf_coherence_h.csv"))

evaluations |>
  purrr::map("summary") |>
  dplyr::bind_rows() |>
  readr::write_csv(file.path(OUT_DIR, "irf_coherence_summary.csv"))
