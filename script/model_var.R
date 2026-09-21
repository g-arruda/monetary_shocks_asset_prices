# ===================================================================
# Observable SVAR-IV benchmark by the Montiel Olea et al. method.
#
# Linear path: levels -> common-sample AIC/BIC with linear trend -> RForm_VAR ->
# external-instrument impact -> AR test inversion.
#
# Outputs:
#   output/var/var_benchmark_lag_criteria.csv
#   output/var/svar_iv_weak_robust.csv
#   output/var/svar_iv_weak_robust_diag.csv
# ===================================================================

rm(list = ls())

source("R/modeling/var_proxy.R")
source("R/identification/weak_iv_ar.R")

if (!"--reestimate-current-instrument" %in% commandArgs(trailingOnly = TRUE)) {
  stop(
    "The observable VAR outputs are frozen at the 2012-03--2025-12 p=4 vintage. ",
    "Use --reestimate-current-instrument only in its dedicated re-estimation round."
  )
}
OUT_DIR <- "output/var"
PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
INSTRUMENT      <- "z_jk_bs_purif"

# The only active small-VAR benchmark cell: five series in levels, constant
# and linear trend in every equation. Since 2026-09-21 it runs the DFM's own
# window and lag order (author decision): 2012-03--2025-12 and p = 4, which
# gives T_eff = 162, the DFM's own count of factor innovations. The contrast is
# then between models, not between samples or lag orders. p = 4 is therefore a
# comparability choice, NOT the AIC's: on the common T = 154 sample the AIC
# still picks p = 2 and the BIC p = 1, and both are reported.
CELL_LABEL    <- "ibc5_fx_cds_level_trend_p4"
VAR_VARS      <- c("ibc_br", "price_ipca", "yield_6m", "cambio_usd", "cds_5y")
DETERMINISTIC <- "trend"
VAR_SAMPLE    <- as.Date(c("2012-03-01", "2025-12-01"))
MAX_LAG   <- 12L
P         <- 4L
H         <- 36L
AR_LEVELS <- c(0.68, 0.90)
NW_LAGS   <- 0L
MP_VAR <- "yield_6m"
SCALE  <- 0.005     # +50bp on yield_6m, a decimal proportion


# 1. Load levels ---------------------------------------------------

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  dplyr::filter(
    ref.date >= VAR_SAMPLE[1L],
    ref.date <= VAR_SAMPLE[2L]
  ) |>
  dplyr::select(ref.date, dplyr::all_of(VAR_VARS))

levels <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
dates_level <- as.Date(panel$ref.date)

instrument <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::transmute(
    month = as.Date(month),
    shock = .data[[INSTRUMENT]]
  )


# 2. Lag-order criteria --------------------------------------------

lag_criteria <- var_lag_criteria(
  levels,
  pmax = MAX_LAG,
  deterministic = DETERMINISTIC
) |>
  dplyr::mutate(cell_id = "production", cell = CELL_LABEL) |>
  dplyr::select(cell_id, cell, dplyr::everything())

aic_selected <- lag_criteria$p[which.min(lag_criteria$aic)]
bic_selected <- lag_criteria$p[which.min(lag_criteria$bic)]


# 3. Reduced form, SVAR-IV point, and AR sets ----------------------

n_vars <- length(VAR_VARS)
mp_index <- match(MP_VAR, VAR_VARS)
fit <- olea_rform_var(
  levels,
  P,
  deterministic = DETERMINISTIC
)

residual_dates <- dates_level[(P + 1L):length(dates_level)]
instrument_index <- match(residual_dates, instrument$month)
if (anyNA(instrument_index)) {
  stop("The instrument does not cover every residual month in ", CELL_LABEL)
}
z <- instrument$shock[instrument_index]

covariance <- mosw_rform_cov(
  fit$X,
  z,
  fit$eta,
  P,
  nw_lags = NW_LAGS
)
svar_iv <- mosw_svar_iv(
  fit$AL,
  fit$Sigma,
  covariance$Gamma,
  H,
  SCALE,
  mp_index
)
derivatives <- mosw_response_derivatives(
  fit$AL,
  P,
  H,
  covariance$Gamma
)

companion <- if (P == 1L) fit$AL else {
  rbind(
    fit$AL,
    cbind(diag(n_vars * (P - 1L)),
          matrix(0, n_vars * (P - 1L), n_vars))
  )
}
max_root <- max(Mod(eigen(companion)$values))

cell_ar <- lapply(AR_LEVELS, function(level) {
  mosw_ar_bounds(
    derivatives,
    covariance,
    nvar = mp_index,
    scale = SCALE,
    confidence = level
  )
})
names(cell_ar) <- sprintf("%.2f", AR_LEVELS)

sets <- purrr::imap(cell_ar, function(ar, level_key) {
  data.frame(
    cell_id = "production",
    cell = CELL_LABEL,
    var = rep(VAR_VARS, times = H + 1L),
    h = rep(0:H, each = n_vars),
    level = as.numeric(level_key),
    point = as.vector(ar$point),
    lo = as.vector(ar$lo),
    hi = as.vector(ar$hi),
    set_type = as.vector(ar$set_type),
    casedummy = as.vector(ar$casedummy),
    ahat = as.vector(ar$ahat),
    bhat = as.vector(ar$bhat),
    chat = as.vector(ar$chat),
    delta = as.vector(ar$Delta),
    stringsAsFactors = FALSE
  )
}) |>
  dplyr::bind_rows()

ar90 <- cell_ar[["0.90"]]
diagnostics <- data.frame(
  cell_id = "production",
  cell = CELL_LABEL,
  n = n_vars,
  p = P,
  T_eff = covariance$T_eff,
  hac_dim = covariance$hac_dim,
  lag_common_T = unique(lag_criteria$T_common),
  aic_selected = aic_selected,
  bic_selected = bic_selected,
  xi_var = ar90$xi_den,
  ar_bounded_90 = ar90$ahat[1L, 1L] > 0,
  max_eig = max_root,
  gamma_yield = covariance$Gamma[mp_index],
  n_inst = length(z),
  n_inst_nonzero = sum(z != 0),
  stringsAsFactors = FALSE
)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
readr::write_csv(lag_criteria, file.path(OUT_DIR, "var_benchmark_lag_criteria.csv"))
readr::write_csv(sets, file.path(OUT_DIR, "svar_iv_weak_robust.csv"))
readr::write_csv(diagnostics, file.path(OUT_DIR, "svar_iv_weak_robust_diag.csv"))
