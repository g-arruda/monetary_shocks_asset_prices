# Validation for the isolated experimental panel-composition round.

rm(list = ls())

source("R/preprocessing/experimental_extensions.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")

EXPECTED_DATES <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
OUT_DIR <- "output/panel_experimental"
MP_VAR <- "yield_6m"
VARIANT <- "z_jk_bs_purif"

experimental_inputs <- build_experimental_inputs(EXPECTED_DATES)
if (nrow(experimental_inputs$matrix) != 153L ||
    ncol(experimental_inputs$matrix) != 19L ||
    any(!is.finite(experimental_inputs$matrix))) {
  stop("The historical experimental inputs are incomplete or non-finite.")
}

base <- readr::read_csv("data/processed/data_log_deseasonalized_base_106.csv", show_col_types = FALSE)
if (ncol(base) - 1L != 106L || !identical(as.Date(base$ref.date), EXPECTED_DATES) ||
    anyNA(base) || any(!is.finite(as.matrix(base[, -1])))) {
  stop("The experimental baseline is not the canonical complete 106-series panel.")
}
dates <- as.Date(base$ref.date)
data_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
instrument <- readr::read_csv("data/processed/instrumentos_mensais.csv", show_col_types = FALSE) |>
  dplyr::transmute(month = as.Date(month), shock = .data[[VARIANT]]) |>
  dplyr::filter(!is.na(shock))

fit <- estimate_dfm(data_mat, r = 7L, q = 6L, p = 6L, dates = dates, apply_kilian = FALSE)
diag_full <- diagnose_instrument_in_factor_space(fit, instrument, dates, 6L, match(MP_VAR, colnames(data_mat)))
pre <- dates <= as.Date("2019-12-01")
fit_pre <- estimate_dfm(data_mat[pre, , drop = FALSE], r = 7L, q = 6L, p = 6L,
                        dates = dates[pre], apply_kilian = FALSE)
diag_pre <- diagnose_instrument_in_factor_space(fit_pre, instrument, dates[pre], 6L,
                                                 match(MP_VAR, colnames(data_mat)))
if (abs(diag_full$wald_mp - 7.65) > 0.01 || abs(diag_full$f_robust_mp - 7.95) > 0.01 ||
    abs(diag_pre$wald_mp - 11.53) > 0.01 || abs(diag_pre$f_robust_mp - 6.26) > 0.01) {
  stop("Baseline MOSW reproduction failed: full=", round(diag_full$wald_mp, 4), "/",
       round(diag_full$f_robust_mp, 4), ", pre-COVID=", round(diag_pre$wald_mp, 4), "/",
       round(diag_pre$f_robust_mp, 4), ".")
}

fit_irf <- estimate_dfm(data_mat, r = 7L, q = 6L, p = 6L, dates = dates,
                        instrument = instrument, apply_kilian = TRUE)
irf <- compute_irf_dfm(
  fit_irf,
  h = 2L,
  nboot = 0L,
  mpind = match(MP_VAR, colnames(data_mat)),
  normalize_value = norm_value_for(MP_VAR, 50),
  tcode = infer_tcode_from_varnames(colnames(data_mat)),
  ci_levels = c(0.68, 0.90),
  var_names = colnames(data_mat)
)
smoke_reference <- c(yield_6m = 0.005, yield_2y = 0.01080227, yield_5y = 0.01170172,
                     asset_ibov = -2.407125, cambio_usd = 0.228100)
smoke_actual <- irf$irf_point_matrix[match(names(smoke_reference), colnames(data_mat)), 1]
names(smoke_actual) <- names(smoke_reference)
smoke_tolerance <- c(yield_6m = 1e-10, yield_2y = 1e-5, yield_5y = 1e-5,
                     asset_ibov = 1e-2, cambio_usd = 1e-4)
if (any(abs(smoke_actual - smoke_reference) > smoke_tolerance)) {
  stop("Production impact smoke test failed: ",
       paste(names(smoke_actual), round(smoke_actual, 8), collapse = "; "), ".")
}

if (dir.exists(OUT_DIR)) {
  manifest_path <- file.path(OUT_DIR, "variant_manifest.csv")
  if (file.exists(manifest_path)) {
    manifest <- readr::read_csv(manifest_path, show_col_types = FALSE)
    additions <- manifest$added[!is.na(manifest$added) & nzchar(manifest$added)] |>
      strsplit(";", fixed = TRUE) |>
      unlist(use.names = FALSE) |>
      unique()
    if (nrow(manifest) != 9L || any(manifest$dates != 153L) ||
        length(setdiff(additions, colnames(experimental_inputs$matrix))) > 0L) {
      stop("Experimental manifest fails coverage or exclusion validation.")
    }
  }
}

message(
  "Experimental panel validation passed: baseline xi/F = ",
  sprintf("%.2f/%.2f", diag_full$wald_mp, diag_full$f_robust_mp),
  " full and ", sprintf("%.2f/%.2f", diag_pre$wald_mp, diag_pre$f_robust_mp),
  " pre-COVID; production smoke test 5/5."
)
