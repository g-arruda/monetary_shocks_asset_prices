# Validate the Lenza-Primiceri (2022) COVID volatility scale of the factor VAR
# (`estimate_var_ols(s =)`, `estimate_dfm(covid_volatility =)`). The numbers
# check code only: no theta is chosen and nothing is estimated for the paper.
#   N1-N4  production panel, neutral theta (s0 = s1 = s2 = 1 gives s_t = 1 at
#          any rho and any covid_start): the treated path reproduces the
#          untreated one bit for bit, and every downstream stop() fires.
#   S1-S4  simulated VAR under an arbitrary non-neutral scale: the terms a
#          neutral theta zeroes (row division by s_t, the Jacobian) against
#          independent routes, and the estimate_dfm plumbing a neutral theta
#          cannot tell apart (s_t aligned after the p lags, the innovations
#          switch).
# Silent on success; stops at the first failed check.

rm(list = ls())

source("R/modeling/production_spec.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/weak_iv_ar.R")
source("R/identification/factor_space_diagnostics.R")
source("R/modeling/dfm_pipeline.R")

spec <- production_spec()
panel <- readr::read_csv(spec$data_path, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(panel$ref.date)
data_mat <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
residual_dates <- dates[(spec$p + 1):length(dates)]

# N1 — factor VAR: every residual month as covid_start, rho in {0, 0.5}
factors <- estimate_static_factors(data_mat, spec$r)$factors
ols <- estimate_var_ols(factors, spec$p)
n1 <- tidyr::expand_grid(covid_start = residual_dates, rho = c(0, 0.5)) |>
  purrr::pmap_lgl(function(covid_start, rho) {
    s <- covid_volatility_path(residual_dates, covid_start,
                               c(s0 = 1, s1 = 1, s2 = 1, rho = rho))
    wls <- estimate_var_ols(factors, spec$p, s = s)
    identical(s, rep(1, length(residual_dates))) &&
      identical(wls$coefficients, ols$coefficients) &&
      identical(wls$residuals, ols$residuals) &&
      identical(wls$residuals_standardized, ols$residuals) &&
      identical(wls$companion, ols$companion) &&
      identical(wls$covariance_matrix, ols$covariance_matrix)
  })
if (!all(n1)) {
  stop("N1: neutral theta does not reproduce OLS in ", sum(!n1), " of ",
       length(n1), " (covid_start, rho) cells")
}

# N2 — point pipeline through main_sdfm: q = r and q < r, both innovation
# switches, covid_start at the first, middle and last residual month
point_irf <- function(q, covid_volatility) {
  res <- suppressMessages(main_sdfm(r = spec$r, q = q, p = spec$p, nboot = 0L,
                                    inference = "bootstrap",
                                    covid_volatility = covid_volatility))
  res$irfs$irf_point_matrix
}
reference <- list(`5` = point_irf(5L, NULL), `3` = point_irf(3L, NULL))
n2 <- tidyr::expand_grid(
  q = c(5L, 3L),
  innovations = c("raw", "standardized"),
  covid_start = residual_dates[c(1L, length(residual_dates) %/% 2L,
                                 length(residual_dates))]
) |>
  purrr::pmap_lgl(function(q, innovations, covid_start) {
    treated <- point_irf(q, list(covid_start = covid_start,
                                 theta = c(s0 = 1, s1 = 1, s2 = 1, rho = 0.5),
                                 innovations = innovations))
    identical(treated, reference[[as.character(q)]])
  })
if (!all(n2)) {
  stop("N2: the treated pipeline under neutral theta departs from production in ",
       sum(!n2), " of ", length(n2), " cells")
}

# The impacts the CLAUDE.md smoke test pins, at full precision
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
smoke_h0 <- c(0.0050000000000000001, 0.0070263642339699903,
              0.0072457194488358932, -0.99650483088005848,
              0.13424190947918324)
if (!identical(reference[["5"]][match(headline, colnames(data_mat)), 1], smoke_h0)) {
  stop("N2: the production point no longer matches the CLAUDE.md smoke test")
}

# N3 — (B5) at neutral theta against the Gaussian log-likelihood summed row by row
wls <- estimate_var_ols(factors, spec$p, s = rep(1, length(residual_dates)))
u <- wls$residuals
sigma <- crossprod(u) / nrow(u)
brute <- sum(-ncol(u) / 2 * log(2 * pi) - log(det(sigma)) / 2 -
               rowSums((u %*% solve(sigma)) * u) / 2)
if (abs(wls$loglik - brute) > 1e-10 * abs(brute)) {
  stop("N3: (B5) at neutral theta is ", wls$loglik, " against ", brute)
}

# N4 — every stop() the treatment adds has to fire, with its own message
neutral <- list(covid_start = residual_dates[1],
                theta = c(s0 = 1, s1 = 1, s2 = 1, rho = 0.5),
                innovations = "raw")
error_message <- function(expr) {
  tryCatch(suppressMessages({
    expr
    ""
  }), error = conditionMessage)
}
treated_dfm <- estimate_dfm(data_mat, spec$r, spec$q, spec$p, dates = dates,
                            covid_volatility = neutral)
instrument <- readr::read_csv(spec$legacy_instrument_path, show_col_types = FALSE)
n4 <- c(
  missing_field = grepl("sem innovations", error_message(
    estimate_dfm(data_mat, spec$r, spec$q, spec$p, dates = dates,
                 covid_volatility = neutral[c("covid_start", "theta")]))),
  missing_theta = grepl("sem rho", error_message(
    estimate_dfm(data_mat, spec$r, spec$q, spec$p, dates = dates,
                 covid_volatility = modifyList(neutral, list(theta = c(s0 = 1, s1 = 1, s2 = 1)))))),
  invalid_innovations = grepl("innovations deve ser", error_message(
    estimate_dfm(data_mat, spec$r, spec$q, spec$p, dates = dates,
                 covid_volatility = modifyList(neutral, list(innovations = "standarized"))))),
  start_outside = grepl("nao e um mes", error_message(
    estimate_dfm(data_mat, spec$r, spec$q, spec$p, dates = dates,
                 covid_volatility = modifyList(neutral, list(covid_start = dates[1]))))),
  no_dates = grepl("nao e um mes", error_message(
    estimate_dfm(data_mat, spec$r, spec$q, spec$p, covid_volatility = neutral))),
  kilian = grepl("Kilian", error_message(
    estimate_dfm(data_mat, spec$r, spec$q, spec$p, dates = dates,
                 apply_kilian = TRUE, covid_volatility = neutral))),
  bootstrap = grepl("Bootstrap indisponivel", error_message(
    main_sdfm(nboot = 2L, inference = "bootstrap", covid_volatility = neutral))),
  anderson_rubin = grepl("ar_dfm_bands", error_message(
    main_sdfm(nboot = 0L, inference = "ar", covid_volatility = neutral))),
  xi_mp = grepl("diagnose_instrument_in_factor_space", error_message(
    diagnose_instrument_in_factor_space(treated_dfm, instrument, dates, spec$p,
                                        match(spec$mp_var, colnames(data_mat)))))
)
if (!all(n4)) {
  stop("N4: the treatment's stop() did not fire for ",
       paste(names(n4)[!n4], collapse = ", "))
}

# S — simulated VAR(2) in three variables. theta_sim is a test value for the
# algebra, not a parametrization of anything.
set.seed(20260914)
n_sim <- 3L
p_sim <- 2L
T_sim <- 160L
sim_dates <- seq(as.Date("2001-01-01"), by = "month", length.out = T_sim)
covid_sim <- sim_dates[110]
theta_sim <- c(s0 = 6, s1 = 11, s2 = 4, rho = 0.7)
s_all <- covid_volatility_path(sim_dates, covid_sim, theta_sim)
A1 <- matrix(c(0.5, 0.1, 0, 0.2, 0.4, 0.1, 0, 0.1, 0.3), n_sim)
A2 <- diag(0.15, n_sim)
intercept <- c(0.2, -0.1, 0.3)
Y <- matrix(0, T_sim, n_sim)
for (t in (p_sim + 1):T_sim) {
  Y[t, ] <- intercept + A1 %*% Y[t - 1, ] + A2 %*% Y[t - 2, ] + s_all[t] * rnorm(n_sim)
}
s_sim <- s_all[(p_sim + 1):T_sim]
fit <- estimate_var_ols(Y, p_sim, s = s_sim)

# S1 — (B2) against weighted least squares by lm.wfit, weights 1/s_t^2
RHS <- cbind(Y[p_sim:(T_sim - 1), ], Y[(p_sim - 1):(T_sim - 2), ], 1)
LHS <- Y[(p_sim + 1):T_sim, ]
wfit <- lm.wfit(RHS, LHS, w = 1 / s_sim^2)
if (max(abs(unname(wfit$coefficients) - fit$coefficients)) > 1e-10) {
  stop("S1: (B2) departs from lm.wfit by ",
       max(abs(unname(wfit$coefficients) - fit$coefficients)))
}

# S2 — (B5) against (B1) summed row by row at (B-hat, Sigma-hat): the Jacobian
# -n log s_t and the division of the quadratic form by s_t^2
u_sim <- fit$residuals
b1 <- sum(-n_sim / 2 * log(2 * pi) - n_sim * log(s_sim) -
            log(det(fit$sigma_mle)) / 2 -
            rowSums((u_sim %*% solve(fit$sigma_mle)) * u_sim) / (2 * s_sim^2))
if (abs(fit$loglik - b1) > 1e-10 * abs(b1)) {
  stop("S2: (B5) is ", fit$loglik, " against (B1) ", b1)
}

# S3 — the path against a literal transcription of `invweights` in
# logMLVAR_formin_covid.m:35-40, Tcovid being the row of covid_start
Tcovid <- match(covid_sim, sim_dates)
invweights <- rep(1, T_sim)
invweights[Tcovid] <- theta_sim[["s0"]]
invweights[Tcovid + 1] <- theta_sim[["s1"]]
invweights[(Tcovid + 2):T_sim] <- 1 + (theta_sim[["s2"]] - 1) *
  theta_sim[["rho"]]^(0:(T_sim - Tcovid - 2))
if (max(abs(s_all - invweights)) > 1e-12) {
  stop("S3: covid_volatility_path departs from invweights by ",
       max(abs(s_all - invweights)))
}

# S4 — estimate_dfm on a 12-series panel driven by the simulated VAR: s_t sits
# on the residual months, the coefficients are (B2) on the static factors, and
# `innovations` routes the chosen residuals into var_residuals and into K, M, eta
loadings_sim <- matrix(rnorm(12L * n_sim), 12L, n_sim)
X_sim <- Y %*% t(loadings_sim) + matrix(rnorm(T_sim * 12L, sd = 0.5), T_sim, 12L)
treated_sim <- lapply(c(raw = "raw", standardized = "standardized"), function(innovations) {
  estimate_dfm(X_sim, r = n_sim, q = 2L, p = p_sim, dates = sim_dates,
               covid_volatility = list(covid_start = covid_sim, theta = theta_sim,
                                       innovations = innovations))
})
wls_sim <- estimate_var_ols(treated_sim$raw$static_factors, p_sim, s = s_sim)
s4 <- c(
  path_aligned = identical(treated_sim$raw$volatility_path, s_sim),
  coefficients = identical(treated_sim$raw$var_coefficients, wls_sim$coefficients),
  raw_routed = identical(treated_sim$raw$var_residuals, wls_sim$residuals),
  standardized_routed = identical(treated_sim$standardized$var_residuals,
                                  wls_sim$residuals_standardized),
  switch_matters = !isTRUE(all.equal(wls_sim$residuals, wls_sim$residuals_standardized)),
  dynamic_from_switch = identical(
    treated_sim$standardized$dynamic_factors,
    estimate_dynamic_factors(wls_sim$residuals_standardized, 2L, n_sim)$factors
  )
)
if (!all(s4)) {
  stop("S4: estimate_dfm plumbing fails at ", paste(names(s4)[!s4], collapse = ", "))
}
