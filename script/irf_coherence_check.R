# ===================================================================
# Point-by-point theory-coherence check of the production IRFs for every
# variable of coherence_var_table() under the production specification, which
# is written out below.
# Bands are the Anderson-Rubin sets, the inference of the DFM since
# 2026-09-08. For each variable, every horizon
# h = 0..48 is checked for sign and for exclusion of zero at 68% and 90%
# against the theory window defined in R/identification/irf_coherence.R.
# Outputs: output/irf/irf_coherence_h.csv, irf_coherence_summary.csv,
#          irf_coherence_cell.rds
# The interpretive reading lives in output/irf/irf_coherence_leitura.md,
# which no script touches.
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")
source("R/identification/weak_iv_ar.R")


# ---- Config: the production specification --------------------------

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
CELL_PATH       <- "output/irf/irf_coherence_cell.rds"
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

OUT_DIR   <- "output/irf"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data + estimation ---------------------------------------------

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
tcode    <- infer_tcode_from_varnames(colnames(data_mat))
var_names <- colnames(data_mat)

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

spec_tbl <- coherence_var_table()
missing <- setdiff(spec_tbl$var, var_names)
if (length(missing) > 0) {
  stop("Variaveis da tabela de coerencia ausentes no painel: ",
       paste(missing, collapse = ", "))
}

cell <- run_stage2_cell(
  data_mat, dates, inst_panel,
  sample_window = SAMPLE,
  r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
  instrument = INSTRUMENT, mp_var = MP_VAR,
  h = HORIZON, shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS,
  inference = INFERENCE, ar_nw_lags = AR_NW_LAGS,
  # This is the production cell: it carries the Lenza-Primiceri scale, as the
  # DFM of section 4 does. Section 5 is scored off this run.
  covid_volatility = read_covid_volatility(THETA_PATH)
)
saveRDS(cell, CELL_PATH)

point <- cell$irf$irf_point_matrix
ci68  <- cell$irf$ci[["0.68"]]
ci90  <- cell$irf$ci[["0.90"]]
ar    <- cell$irf$ar

for (lvl in CI_LEVELS) {
  b <- ar$by_level[[sprintf("%.2f", lvl)]]
  if ((b$ahat[1L, 1L] > 0) != (ar$xi_den > b$critval)) {
    stop("Set boundedness disagrees with xi_mp > critval at level ", lvl)
  }
}


# ---- Evaluate every variable ---------------------------------------

evaluations <- purrr::map(seq_len(nrow(spec_tbl)), function(i) {
  spec <- spec_tbl[i, ]
  idx  <- match(spec$var, var_names)
  evaluate_irf_path(
    point[idx, ], ci68$lower[idx, ], ci68$upper[idx, ],
    ci90$lower[idx, ], ci90$upper[idx, ], spec,
    set_type68 = ar$by_level[["0.68"]]$set_type[idx, ],
    set_type90 = ar$by_level[["0.90"]]$set_type[idx, ]
  )
})
perh <- dplyr::bind_rows(purrr::map(evaluations, "perh"))
summ <- dplyr::bind_rows(purrr::map(evaluations, "summary"))

readr::write_csv(perh, file.path(OUT_DIR, "irf_coherence_h.csv"))
readr::write_csv(summ, file.path(OUT_DIR, "irf_coherence_summary.csv"))
