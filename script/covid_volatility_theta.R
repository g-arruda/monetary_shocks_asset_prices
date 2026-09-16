# Estimate the Lenza-Primiceri (2022) COVID volatility scale of the factor VAR
# by maximum likelihood, (B5) of their Appendix B, under the author's design of
# 2026-09-14 (production_spec()$covid_volatility_design): t* = 2020-03,
# s0, s1, s2 >= 1 and rho in [0, 1]. theta depends on the static factors and
# on p, not on q, so one estimate serves the whole q table. Production keeps
# the treatment off; nothing here computes an IRF.
#   output/factors/covid_volatility_theta.csv        theta-hat and likelihoods
#   output/factors/covid_volatility_path.csv         s_t and residual sizes by month
#   output/factors/covid_volatility_profile_rho.csv  profile log-likelihood in rho
# Note: notas/2026-09-14_estimacao_theta_volatilidade_covid.md

source("R/modeling/production_spec.R")
source("R/modeling/factor_estimation.R")

spec <- production_spec()
design <- spec$covid_volatility_design
panel <- readr::read_csv(spec$data_path, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(panel$ref.date)
data_mat <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
residual_dates <- dates[(spec$p + 1):length(dates)]
factors <- estimate_static_factors(data_mat, spec$r)$factors

fit <- estimate_covid_theta(factors, spec$p, residual_dates, design$covid_start,
                            design$theta_lower, design$theta_upper)
wls <- estimate_var_ols(factors, spec$p, s = fit$path)
ols <- estimate_var_ols(factors, spec$p)
neutral <- estimate_var_ols(factors, spec$p, s = rep(1, length(residual_dates)))

# Squared Mahalanobis size per dimension: OLS residuals against their ML
# covariance, standardized WLS residuals against (B4). At an interior maximum
# the envelope condition sets it to one in t* and t* + 1, the months that s0
# and s1 govern alone.
ols_sigma <- crossprod(ols$residuals) / nrow(ols$residuals)
mahal_ols <- rowSums((ols$residuals %*% solve(ols_sigma)) * ols$residuals) / spec$r
mahal_wls <- rowSums((wls$residuals_standardized %*% solve(wls$sigma_mle)) *
                       wls$residuals_standardized) / spec$r

t_star <- match(design$covid_start, residual_dates)
single_month <- c(s0 = t_star, s1 = t_star + 1L)
interior <- fit$theta[names(single_month)] > design$theta_lower[names(single_month)]
foc_gap <- abs(mahal_wls[single_month] - 1)
if (fit$convergence != 0 || any(interior & foc_gap > 1e-4)) {
  stop("estimate_covid_theta did not reach the maximum: convergence ",
       fit$convergence, ", |m - 1| at t* and t* + 1 = ",
       paste(signif(foc_gap, 3), collapse = ", "))
}

# Profile log-likelihood in rho, (s0, s1, s2) re-maximized at each grid point.
# The free maximum has to dominate the grid, or the optimizer stopped at a
# local peak.
profile <- purrr::map_dfr(seq(0, 1, by = 0.01), function(rho) {
  prof <- optim(
    fit$theta[c("s0", "s1", "s2")],
    function(s) {
      path <- covid_volatility_path(residual_dates, design$covid_start, c(s, rho = rho))
      estimate_var_ols(factors, spec$p, s = path)$loglik
    },
    method = "L-BFGS-B",
    lower = design$theta_lower[c("s0", "s1", "s2")],
    upper = design$theta_upper[c("s0", "s1", "s2")],
    control = list(fnscale = -1, factr = 1e3)
  )
  tibble::tibble(rho = rho, loglik = prof$value, s0 = prof$par[["s0"]],
                 s1 = prof$par[["s1"]], s2 = prof$par[["s2"]],
                 convergence = prof$convergence)
})
if (max(profile$loglik) > fit$loglik + 1e-6 * abs(fit$loglik)) {
  stop("The rho profile reaches ", max(profile$loglik), ", above the free ",
       "maximum ", fit$loglik, ": estimate_covid_theta stopped at a local peak")
}

tibble::tibble(
  covid_start = design$covid_start,
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
  readr::write_csv("output/factors/covid_volatility_theta.csv")

tibble::tibble(
  month = residual_dates,
  s = fit$path,
  weight = 1 / fit$path^2,
  mahal_ols = mahal_ols,
  mahal_wls = mahal_wls
) |>
  readr::write_csv("output/factors/covid_volatility_path.csv")

readr::write_csv(profile, "output/factors/covid_volatility_profile_rho.csv")
