# Estimate the Lenza-Primiceri (2022) COVID volatility scale of the factor VAR
# by maximum likelihood, (B5) of their Appendix B, under the author's design of
# 2026-09-14: t* = 2020-03, s0, s1, s2 >= 1 and rho in [0, 1]. theta depends on
# the static factors and on p, not on q, so one estimate serves the whole q
# table. This script is the sole producer of the production theta, which the
# estimation scripts read back through read_covid_volatility(); it is therefore
# the one place that must not read it. Production since 2026-09-17;
# nothing here computes an IRF. s_t follows from theta-hat through
# covid_volatility_path(); the profile in rho is a check and is not written.
# Output: output/factors/covid_volatility_theta.csv (theta-hat and likelihoods)
# Note: notas/2026-09-14_estimacao_theta_volatilidade_covid.md

source("R/modeling/factor_estimation.R")

PANEL_PATH <- "data/processed/data_log_deseasonalized.csv"
THETA_OUT  <- "output/factors/covid_volatility_theta.csv"
R_FACTORS  <- 5L
P_LAGS     <- 4L
# The author's design of 2026-09-14. The floor s >= 1 is what makes the
# maximum exist (notas/2026-09-14_estimacao_theta_volatilidade_covid.md).
COVID_START <- as.Date("2020-03-01")
THETA_LOWER <- c(s0 = 1, s1 = 1, s2 = 1, rho = 0)
THETA_UPPER <- c(s0 = Inf, s1 = Inf, s2 = Inf, rho = 1)

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(panel$ref.date)
data_mat <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
residual_dates <- dates[(P_LAGS + 1):length(dates)]
factors <- estimate_static_factors(data_mat, R_FACTORS)$factors

fit <- estimate_covid_theta(factors, P_LAGS, residual_dates, COVID_START,
                            THETA_LOWER, THETA_UPPER)
wls <- estimate_var_wls(factors, P_LAGS, s = fit$path)
neutral <- estimate_var_wls(factors, P_LAGS, s = rep(1, length(residual_dates)))

# Squared Mahalanobis size per dimension of the standardized WLS residuals
# against (B4). At an interior maximum the envelope condition sets it to one in
# t* and t* + 1, the months that s0 and s1 govern alone.
mahal_wls <- rowSums((wls$residuals_standardized %*% solve(wls$sigma_mle)) *
                       wls$residuals_standardized) / R_FACTORS

t_star <- match(COVID_START, residual_dates)
single_month <- c(s0 = t_star, s1 = t_star + 1L)
interior <- fit$theta[names(single_month)] > THETA_LOWER[names(single_month)]
foc_gap <- abs(mahal_wls[single_month] - 1)
if (fit$convergence != 0 || any(interior & foc_gap > 1e-4)) {
  stop("estimate_covid_theta did not reach the maximum: convergence ",
       fit$convergence, ", |m - 1| at t* and t* + 1 = ",
       paste(signif(foc_gap, 3), collapse = ", "))
}

# Profile log-likelihood in rho, (s0, s1, s2) re-maximized at each grid point.
# The free maximum has to dominate the grid, or the optimizer stopped at a
# local peak.
profile_loglik <- purrr::map_dbl(seq(0, 1, by = 0.01), function(rho) {
  optim(
    fit$theta[c("s0", "s1", "s2")],
    function(s) {
      path <- covid_volatility_path(residual_dates, COVID_START, c(s, rho = rho))
      estimate_var_wls(factors, P_LAGS, s = path)$loglik
    },
    method = "L-BFGS-B",
    lower = THETA_LOWER[c("s0", "s1", "s2")],
    upper = THETA_UPPER[c("s0", "s1", "s2")],
    control = list(fnscale = -1, factr = 1e3)
  )$value
})
if (max(profile_loglik) > fit$loglik + 1e-6 * abs(fit$loglik)) {
  stop("The rho profile reaches ", max(profile_loglik), ", above the free ",
       "maximum ", fit$loglik, ": estimate_covid_theta stopped at a local peak")
}

tibble::tibble(
  covid_start = COVID_START,
  s0 = fit$theta[["s0"]],
  s1 = fit$theta[["s1"]],
  s2 = fit$theta[["s2"]],
  rho = fit$theta[["rho"]],
  loglik = fit$loglik,
  loglik_neutral = neutral$loglik,
  lr_vs_neutral = 2 * (fit$loglik - neutral$loglik),
  downweighted_months = sum(1 - 1 / fit$path^2),
  convergence = fit$convergence,
  start_s0 = fit$start[["s0"]],
  start_s1 = fit$start[["s1"]],
  start_s2 = fit$start[["s2"]],
  start_rho = fit$start[["rho"]]
) |>
  readr::write_csv(THETA_OUT)
