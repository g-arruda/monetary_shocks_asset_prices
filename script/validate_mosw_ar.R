# ===================================================================
# Validate the observable SVAR-IV path against the authors' MATLAB suite.
#
# Checks the official oil fixture for RForm_VAR, MARep,
# CovAhat_Sigmahat_Gamma, IRFSVARIV, and the 68%/95% AR sets. It also checks
# every degenerate set topology and compares the Brazilian production-cell AIC
# and BIC paths with an independent implementation and `vars::VARselect`.
# ===================================================================

source("R/modeling/production_spec.R")
source("R/modeling/var_proxy.R")
source("R/identification/weak_iv_ar.R")

TOL <- 1e-8
FIXTURE <- "output/validation/olea_oil_fixture.rds"
DATA_PATH <- "data/processed/data_log_deseasonalized.csv"

required_files <- c(FIXTURE, DATA_PATH)
missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files)) {
  stop("Missing validation inputs: ", paste(missing_files, collapse = ", "))
}


#' Literal translation of `MARep.m`
#'
#' @param AL Reduced-form coefficient matrix.
#' @param p Lag order.
#' @param h Number of positive horizons.
#'
#' @return Matrix containing the positive-horizon MA coefficients by blocks.
marep_matlab <- function(AL, p, h) {
  n <- nrow(AL)
  vecAL <- array(AL, dim = c(n, n, p))
  revT <- array(0, dim = c(n, n, h))
  for (ih in seq_len(h)) {
    if (ih >= (h - p) + 1L) revT[, , ih] <- t(vecAL[, , (h - ih) + 1L])
  }
  revT <- matrix(revT, nrow = n)
  C <- matrix(rep(vecAL[, , 1L], h), nrow = n)
  if (h >= 2L) {
    for (ih in seq_len(h - 1L)) {
      left <- cbind(diag(n), C[, seq_len(n * ih), drop = FALSE])
      keep <- (h * n - n * (ih + 1L)) + seq_len(n * (ih + 1L))
      C[, n * ih + seq_len(n)] <- left %*% t(revT[, keep, drop = FALSE])
    }
  }
  C
}


#' Relative maximum deviation on finite entries
#'
#' @param got Computed numeric object.
#' @param want Reference numeric object.
#'
#' @return Scalar relative maximum deviation.
relative_deviation <- function(got, want) {
  keep <- is.finite(got) & is.finite(want)
  if (!any(keep)) return(0)
  max(abs(got[keep] - want[keep])) / max(1, max(abs(want[keep])))
}


#' Independently compute common-sample VAR lag criteria
#'
#' @param series Data matrix.
#' @param pmax Largest candidate lag order.
#' @param deterministic Deterministic specification: `constant` or `trend`.
#'
#' @return Data frame with AIC and BIC for every order.
lag_criteria_literal <- function(series, pmax, deterministic) {
  series <- as.matrix(series)
  T_common <- nrow(series) - pmax
  n <- ncol(series)
  n_deterministic <- if (deterministic == "constant") 1L else 2L

  rows <- lapply(seq_len(pmax), function(p) {
    series_p <- series[(pmax - p + 1L):nrow(series), , drop = FALSE]
    n_total <- nrow(series_p)
    lags <- do.call(
      cbind,
      lapply(seq_len(p), function(lag) {
        series_p[(p + 1L - lag):(n_total - lag), , drop = FALSE]
      })
    )
    Y <- series_p[(p + 1L):n_total, , drop = FALSE]
    deterministic_terms <- if (deterministic == "constant") {
      matrix(1, nrow(Y), 1L)
    } else {
      cbind(1, (p + 1L):n_total)
    }
    X <- cbind(deterministic_terms, lags)
    slope <- t(Y) %*% X %*% solve(crossprod(X))
    eta <- t(Y) - slope %*% t(X)
    Sigma <- tcrossprod(eta) / T_common
    n_parameters <- n^2 * p + n * n_deterministic

    data.frame(
      p = p,
      T_common = T_common,
      aic = log(det(Sigma)) + 2 * n_parameters / T_common,
      bic = log(det(Sigma)) +
        log(T_common) * n_parameters / T_common
    )
  })

  dplyr::bind_rows(rows)
}


cat("A. Degenerate Anderson--Rubin sets\n\n")

degenerate <- data.frame(
  a = c(1, -1, 0, 0, 0, 1, -1, 0, 1, 1e-14),
  b = c(0, 0, 2, -2, 0, -2, 2, 0, 0, 2),
  c = c(-1, 1, -4, -4, 3, 1, -1, -3, 1, -4),
  expected = c(
    "interval", "two_rays", "half_line_left", "half_line_right", "empty",
    "singleton", "real_line", "real_line", "empty", "half_line_left"
  ),
  stringsAsFactors = FALSE
)
degenerate_result <- solve_quadratic_le_zero(
  degenerate$a,
  degenerate$b,
  degenerate$c
)
degenerate$actual <- degenerate_result$type
degenerate$lo <- degenerate_result$lo
degenerate$hi <- degenerate_result$hi
print(degenerate, row.names = FALSE)
stopifnot(identical(degenerate$actual, degenerate$expected))

serialization_path <- tempfile(fileext = ".csv")
serialization <- degenerate |>
  dplyr::select(set_type = actual, lo, hi)
readr::write_csv(serialization, serialization_path)
serialization_roundtrip <- readr::read_csv(
  serialization_path,
  show_col_types = FALSE
)
unlink(serialization_path)
finite_lo <- is.finite(serialization$lo)
finite_hi <- is.finite(serialization$hi)
stopifnot(
  identical(serialization_roundtrip$set_type, serialization$set_type),
  identical(is.na(serialization_roundtrip$lo), is.na(serialization$lo)),
  identical(is.na(serialization_roundtrip$hi), is.na(serialization$hi)),
  identical(is.infinite(serialization_roundtrip$lo), is.infinite(serialization$lo)),
  identical(is.infinite(serialization_roundtrip$hi), is.infinite(serialization$hi)),
  all(serialization_roundtrip$lo[finite_lo] == serialization$lo[finite_lo]),
  all(serialization_roundtrip$hi[finite_hi] == serialization$hi[finite_hi]),
  all(
    sign(serialization_roundtrip$lo[is.infinite(serialization$lo)]) ==
      sign(serialization$lo[is.infinite(serialization$lo)])
  ),
  all(
    sign(serialization_roundtrip$hi[is.infinite(serialization$hi)]) ==
      sign(serialization$hi[is.infinite(serialization$hi)])
  )
)


cat("\nB. Official oil fixture\n\n")

fixture <- readRDS(FIXTURE)
p <- fixture$p
n <- fixture$n
h <- fixture$horizons

lag_blocks <- matrix(fixture$X[1L, -1L], ncol = n, byrow = TRUE)
series <- rbind(lag_blocks[nrow(lag_blocks):1L, , drop = FALSE], fixture$Y)
fit <- olea_rform_var(series, p)

dev_rform <- c(
  X = max(abs(fit$X - fixture$X)),
  Y = max(abs(fit$Y - fixture$Y)),
  AL = max(abs(fit$AL - fixture$AL)),
  eta = max(abs(fit$eta - fixture$eta)),
  Sigma = max(abs(fit$Sigma - fixture$Sigma))
)
print(dev_rform)

C_literal <- array(
  cbind(diag(n), marep_matlab(fit$AL, p, h)),
  dim = c(n, n, h + 1L)
)
C <- mosw_marep(fit$AL, p, h)
dev_ma <- max(abs(C - C_literal))

covariance <- mosw_rform_cov(
  fit$X,
  fixture$z,
  fit$eta,
  p,
  nw_lags = fixture$nw_lags
)
dev_gamma <- max(abs(covariance$Gamma - as.numeric(fixture$Gamma)))
dev_what <- relative_deviation(covariance$WHat, fixture$WHat)
wald <- covariance$T_eff * covariance$Gamma[fixture$norm]^2 /
  covariance$W2[fixture$norm, fixture$norm]
dev_wald <- abs(wald - fixture$Waldstat)

svar_iv <- mosw_svar_iv(
  fit$AL,
  fit$Sigma,
  covariance$Gamma,
  h,
  fixture$scale,
  fixture$norm
)
dev_point <- max(abs(svar_iv$point - fixture$plugin_irf))
dev_impact_path <- max(vapply(
  seq_len(h + 1L),
  function(i) max(abs(svar_iv$point[, i] - C[, , i] %*% svar_iv$B1)),
  numeric(1)
))

derivatives <- mosw_response_derivatives(fit$AL, p, h, covariance$Gamma)
blocks <- list(
  list(level = 0.68, suffix = "_68"),
  list(level = 0.95, suffix = "_95")
)

worst_ar <- 0
case_mismatches <- 0L
normalisation_ok <- TRUE
for (block in blocks) {
  ar <- mosw_ar_bounds(
    derivatives,
    covariance,
    nvar = fixture$norm,
    scale = fixture$scale,
    confidence = block$level
  )
  ref_ahat <- fixture[[paste0("ahat", block$suffix)]]
  ref_bhat <- fixture[[paste0("bhat", block$suffix)]]
  ref_chat <- fixture[[paste0("chat", block$suffix)]]
  ref_lo <- fixture[[paste0("MSWlbound", block$suffix)]]
  ref_hi <- fixture[[paste0("MSWubound", block$suffix)]]
  ref_dm_lo <- fixture[[paste0("Dmethodlbound", block$suffix)]]
  ref_dm_hi <- fixture[[paste0("Dmethodubound", block$suffix)]]
  ref_cases <- fixture[[paste0("casedummy", block$suffix)]]

  deviations <- c(
    a = relative_deviation(ar$ahat, ref_ahat),
    b = relative_deviation(ar$bhat, ref_bhat),
    c = relative_deviation(ar$chat, ref_chat),
    lo = relative_deviation(ar$lo, ref_lo),
    hi = relative_deviation(ar$hi, ref_hi),
    dm_lo = relative_deviation(ar$dm_lo, ref_dm_lo),
    dm_hi = relative_deviation(ar$dm_hi, ref_dm_hi),
    point = relative_deviation(ar$point, fixture$plugin_irf),
    se = relative_deviation(ar$dm_se, fixture$plugin_se)
  )
  worst_ar <- max(worst_ar, deviations)

  compare <- matrix(TRUE, nrow = nrow(ar$casedummy), ncol = ncol(ar$casedummy))
  compare[fixture$norm, 1L] <- FALSE
  case_mismatches <- case_mismatches + sum(
    ar$casedummy[compare] != ref_cases[compare]
  )
  normalisation_ok <- normalisation_ok &&
    ar$set_type[fixture$norm, 1L] == "singleton" &&
    abs(ar$lo[fixture$norm, 1L] - fixture$scale) < TOL &&
    abs(ar$hi[fixture$norm, 1L] - fixture$scale) < TOL

  cat(sprintf("  %.0f%%: max deviation %.2e\n", 100 * block$level, max(deviations)))
}

cat(sprintf(
  paste0(
    "  MA %.2e | Gamma %.2e | WHat %.2e | Wald %.2e | ",
    "SVAR-IV %.2e | C_h B1 %.2e\n"
  ),
  dev_ma,
  dev_gamma,
  dev_what,
  dev_wald,
  dev_point,
  dev_impact_path
))

stopifnot(
  max(dev_rform) < 1e-10,
  dev_ma < 1e-10,
  dev_gamma < TOL,
  dev_what < TOL,
  dev_wald < 1e-9,
  dev_point < TOL,
  dev_impact_path < 1e-12,
  worst_ar < TOL,
  case_mismatches == 0L,
  normalisation_ok
)


cat("\nC. AIC and BIC in the Brazilian production cell\n\n")

spec <- production_spec()
var_spec <- spec$var_benchmark
panel <- read.csv(DATA_PATH, check.names = FALSE)
panel$ref.date <- as.Date(panel$ref.date)
panel <- panel[
  panel$ref.date >= var_spec$sample[1L] &
    panel$ref.date <= var_spec$sample[2L],
  c("ref.date", var_spec$vars)
]
if (nrow(panel) != var_spec$n_months || anyNA(panel)) {
  stop("The production panel is incomplete for the BIC validation")
}

levels <- as.matrix(panel[, var_spec$vars])
translated <- var_lag_criteria(
  levels,
  var_spec$max_lag,
  deterministic = var_spec$deterministic
)
literal <- lag_criteria_literal(
  levels,
  var_spec$max_lag,
  deterministic = var_spec$deterministic
)
literal_deviation <- max(
  abs(translated$aic - literal$aic),
  abs(translated$bic - literal$bic)
)

if (!requireNamespace("vars", quietly = TRUE)) {
  stop("Missing package: vars")
}
vars_criteria <- vars::VARselect(
  levels,
  lag.max = var_spec$max_lag,
  type = "both"
)$criteria
vars_deviation <- max(
  abs(translated$aic - vars_criteria["AIC(n)", ]),
  abs(translated$bic - vars_criteria["SC(n)", ])
)
aic_selected <- translated$p[which.min(translated$aic)]
bic_selected <- translated$p[which.min(translated$bic)]

cat(sprintf(
  "  literal %.2e | vars %.2e | AIC p = %d | BIC p = %d\n",
  literal_deviation,
  vars_deviation,
  aic_selected,
  bic_selected
))

stopifnot(
  literal_deviation < 1e-12,
  vars_deviation < 1e-12,
  aic_selected == var_spec$p,
  nrow(levels) - var_spec$max_lag == 141L
)


cat("\nD. Load/Inner generalisation collapses onto MOSW\n\n")

# The DFM path reaches `mosw_ar_bounds()` through `Load` and `Inner`. What keeps
# section B a valid guard over that path is that the generalisation is the
# identity map when `Load = Inner = I`: same code, same numbers, to the bit.
deriv_explicit <- mosw_response_derivatives(fit$AL, p, h, covariance$Gamma,
                                            Load = diag(n), Inner = diag(n))
deviation_deriv <- max(abs(derivatives$C  - deriv_explicit$C),
                       abs(derivatives$D1 - deriv_explicit$D1))

ar_default <- mosw_ar_bounds(derivatives, covariance, fixture$norm,
                             fixture$scale, 0.95)
ar_explicit <- mosw_ar_bounds(deriv_explicit, covariance, fixture$norm,
                              fixture$scale, 0.95)
deviation_bounds <- max(
  abs(ar_default$lo - ar_explicit$lo),
  abs(ar_default$hi - ar_explicit$hi),
  abs(ar_default$dm_se - ar_explicit$dm_se),
  abs(ar_default$xi_den - ar_explicit$xi_den)
)

# `d0` is read off the impact slice. In a VAR of observables `C_0 = I`, so it
# has to come back as the coordinate vector that MOSW hard-code.
d0_gen <- derivatives$C[fixture$norm, , 1]
e_norm <- numeric(n)
e_norm[fixture$norm] <- 1
deviation_d0 <- max(abs(d0_gen - e_norm))

# The cumulative branch, which the transformation codes that accumulate need,
# has to be the running sum of the per-horizon one.
deviation_cum <- max(abs(derivatives$Ccum -
                           aperm(apply(derivatives$C, c(1, 2), cumsum),
                                 c(2, 3, 1))))

cat(sprintf("  derivatives %.2e | bounds %.2e | d0 vs e_norm %.2e | cumulative %.2e\n",
            deviation_deriv, deviation_bounds, deviation_d0, deviation_cum))

stopifnot(
  deviation_deriv == 0,
  deviation_bounds == 0,
  deviation_d0 == 0,
  deviation_cum == 0
)

cat("\nVALIDATION PASSED: Olea reduced form, SVAR-IV, AR sets, AIC, BIC,\n")
cat("and the Load/Inner reduction that the DFM path goes through.\n")
