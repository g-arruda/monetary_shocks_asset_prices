# ===================================================================
# Point-by-point theory-coherence check of the production IRFs for every
# variable of coherence_var_table() under the centralized production
# specification.
# Bands are the Anderson-Rubin sets of `production_spec()$inference`, the
# inference of the DFM since 2026-09-08. For each variable, every horizon
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
source("R/modeling/production_spec.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")
source("R/identification/weak_iv_ar.R")


# ---- Config (production spec) --------------------------------------

SPEC       <- production_spec()
R_FACTORS  <- SPEC$r
Q_DYNAMIC  <- SPEC$q
P_LAGS     <- SPEC$p
INSTRUMENT <- SPEC$instrument
MP_VAR     <- SPEC$mp_var
HORIZON    <- SPEC$horizon
AR_NW_LAGS <- SPEC$ar_nw_lags
SHOCK_BPS  <- SPEC$shock_bps
CI_LEVELS  <- SPEC$ci_levels

OUT_DIR   <- "output/irf"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data + estimation ---------------------------------------------

raw_data <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |>
  tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
tcode    <- infer_tcode_from_varnames(colnames(data_mat))
var_names <- colnames(data_mat)

inst_panel <- readr::read_csv(SPEC$instrument_path, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

spec_tbl <- coherence_var_table()
missing <- setdiff(spec_tbl$var, var_names)
if (length(missing) > 0) {
  stop("Variaveis da tabela de coerencia ausentes no painel: ",
       paste(missing, collapse = ", "))
}

cell <- run_stage2_cell(
  data_mat, dates, inst_panel,
  sample_window = SPEC$sample,
  r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
  instrument = INSTRUMENT, mp_var = MP_VAR,
  h = HORIZON, shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS,
  inference = SPEC$inference, ar_nw_lags = AR_NW_LAGS,
  # This is the production cell: it carries the Lenza-Primiceri scale, as the
  # DFM of section 4 does. Section 5 is scored off this run.
  covid_volatility = SPEC$covid_volatility
)
saveRDS(cell, SPEC$coherence_cell_path)

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

