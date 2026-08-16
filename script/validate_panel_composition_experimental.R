# Validation for the isolated experimental panel-composition round.

rm(list = ls())

library(readr)
library(dplyr)

source("R/data_download/panel_candidates.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")

EXPECTED_DATES <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
OUT_DIR <- "output/panel_experimental"
MP_VAR <- "yield_6m"
VARIANT <- "z_jk_bs_purif"


#' Assert complete, unique, finite coverage for one monthly series
#'
#' @param data Data frame with monthly date and numeric value columns.
#' @param id Identifier used in validation messages.
#'
#' @return Invisibly TRUE.
assert_complete_monthly <- function(data, id) {
  if (!all(c("ref.date", "value") %in% names(data))) {
    stop(id, " must contain ref.date and value.")
  }
  dates <- as.Date(data$ref.date)
  if (!identical(dates, EXPECTED_DATES) || anyDuplicated(dates) || anyNA(dates) ||
      anyNA(data$value) || any(!is.finite(data$value))) {
    stop(id, " does not have exactly 153 unique finite monthly observations.")
  }
  invisible(TRUE)
}


inventory <- panel_candidate_inventory()
selected_ids <- c(
  "13762", "4513", "4649", "23079", "22708", "22709", "3546",
  "FOCUS_IPCA12M", "FOCUS_SELIC_NY", "FOCUS_PIB_NY", "FOCUS_CAMBIO_NY",
  "DGS10", "FEDFUNDS", "DTWEXBGS", "21082", "20714", "21340"
)
for (id in selected_ids) {
  path <- inventory$file[inventory$id == id]
  if (length(path) != 1 || !file.exists(path)) {
    stop("Missing candidate input for ", id, ".")
  }
  data <- readr::read_csv(path, show_col_types = FALSE) |>
    dplyr::transmute(ref.date = as.Date(ref.date), value = as.numeric(value)) |>
    dplyr::arrange(ref.date)
  assert_complete_monthly(data, id)
}

dgs2 <- readr::read_csv("data/raw/fred_dgs2.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), value = as.numeric(ust2y)) |>
  last_observation_in_month() |>
  dplyr::select(ref.date, value)
assert_complete_monthly(dgs2, "DGS2")

sp500 <- readr::read_csv("data/raw/investing/external_factors_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), value = as.numeric(sp500)) |>
  dplyr::filter(!is.na(value), date >= as.Date("2012-12-01")) |>
  dplyr::mutate(ref.date = as.Date(format(date, "%Y-%m-01"))) |>
  dplyr::group_by(ref.date) |>
  dplyr::slice_max(date, n = 1, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::arrange(ref.date) |>
  dplyr::mutate(value = c(NA_real_, diff(log(value)))) |>
  dplyr::filter(ref.date >= min(EXPECTED_DATES), ref.date <= max(EXPECTED_DATES)) |>
  dplyr::select(ref.date, value)
assert_complete_monthly(sp500, "Yahoo ^GSPC monthly log return")

forbidden <- c("SP500", "T10Y2Y", "22711", "22712", "22701", "22702", "22703", "22707", "22710")
if (any(inventory$id[inventory$status == "novo download necessário"] %in% forbidden)) {
  stop("An excluded identity or insufficient-coverage series entered the candidate inventory.")
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
    if (nrow(manifest) != 9L || any(manifest$dates != 153L) ||
        any(grepl(paste(forbidden, collapse = "|"), manifest$added))) {
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
