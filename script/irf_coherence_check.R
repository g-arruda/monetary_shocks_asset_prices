# ===================================================================
# Point-by-point theory-coherence check of the production IRFs for every
# variable of coherence_var_table() under the production specification, which
# is written out below.
# Bands are the Anderson-Rubin sets. For each variable, every horizon
# h = 0..48 is checked for sign and for exclusion of zero at 68% and 90%
# against the theory window defined in R/identification/irf_coherence.R.
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

spec_tbl <- coherence_var_table()
missing_vars <- setdiff(spec_tbl$var, var_names)
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

evaluations <- purrr::map(seq_len(nrow(spec_tbl)), function(i) {
  spec <- spec_tbl[i, ]
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
