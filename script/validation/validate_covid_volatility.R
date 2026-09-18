# Validate the Lenza-Primiceri (2022) COVID volatility scale of the factor VAR:
# `estimate_var_ols(s =)`, `estimate_covid_theta()`,
# `estimate_dfm(covid_volatility =)`, the uncentered identification it
# triggers in `compute_irf_dfm()`, and the Anderson-Rubin sets and xi_mp on the
# transformed regression (`ar_dfm_bands()`,
# `diagnose_instrument_in_factor_space()`). The numbers check code only.
#   N1-N5  production panel, neutral theta (s0 = s1 = s2 = 1 gives s_t = 1 at
#          any rho and any covid_start): the treated factor VAR reproduces OLS
#          bit for bit; the treated point IRF, Anderson-Rubin sets and xi_mp
#          reproduce production to floating point (the treated branch does not
#          center, and OLS residuals sum to about 1e-17 rather than zero); and
#          every downstream stop() fires.
#   S1-S10 simulated VAR under an arbitrary non-neutral scale: the terms a
#          neutral theta zeroes (row division by s_t, the Jacobian) against
#          independent routes; the estimate_dfm plumbing a neutral theta
#          cannot tell apart (s_t aligned after the p lags, the innovations
#          switch, the uncentered K); the maximum-likelihood estimate of theta
#          (first-order conditions, bounds, profile, why the floor); the
#          uncentered H; the starting values against the authors' rule; the
#          influence function of the treated estimator; and the treated sets
#          and xi_mp against MOSW fed by hand.
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
  res <- suppressMessages(main_sdfm(r = spec$r, q = q, p = spec$p,
                                    inference = "none",
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
    untreated <- reference[[as.character(q)]]
    max(abs(treated - untreated)) <= 1e-12 * max(abs(untreated))
  })
if (!all(n2)) {
  stop("N2: the treated pipeline under neutral theta departs from production ",
       "beyond 1e-12 in ", sum(!n2), " of ", length(n2), " cells")
}

# The untreated reference, at full precision. These were the CLAUDE.md smoke
# constants until 2026-09-17, when the Lenza-Primiceri scale became production;
# `reference` is built with covid_volatility = NULL, so it is still exactly this
# OLS point, and pinning it is what proves the treated branch degenerates to the
# untreated one. The current production constants are the treated ones, in
# output/validation/production_spec_impact_smoke.csv.
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
untreated_h0 <- c(0.0050000000000000001, 0.0070263642339699903,
                  0.0072457194488358932, -0.99650483088005848,
                  0.13424190947918324)
if (!identical(reference[["5"]][match(headline, colnames(data_mat)), 1], untreated_h0)) {
  stop("N2: the untreated reference point moved; it must stay the pre-2026-09-17 OLS point")
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

# N4 — every stop() the treatment adds has to fire, with its own message. The
# Anderson-Rubin sets and xi_mp stop only under "raw", the one not derived.
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
  anderson_rubin = grepl("ar_dfm_bands.*raw", error_message(
    main_sdfm(inference = "ar", covid_volatility = neutral))),
  xi_mp = grepl("diagnose_instrument_in_factor_space.*raw", error_message(
    diagnose_instrument_in_factor_space(treated_dfm, instrument, dates, spec$p,
                                        match(spec$mp_var, colnames(data_mat)))))
)
if (!all(n4)) {
  stop("N4: the treatment's stop() did not fire for ",
       paste(names(n4)[!n4], collapse = ", "))
}

# N5 — neutral theta with "standardized": the Anderson-Rubin sets and xi_mp on
# the transformed regression reproduce production to floating point. The
# transformed regressors are the OLS ones; only the centering and K's divisor
# differ.
neutral_std <- modifyList(neutral, list(
  covid_start = spec$covid_volatility_design$covid_start,
  innovations = "standardized"
))
ar_at <- function(covid_volatility) {
  suppressMessages(main_sdfm(inference = "ar",
                             covid_volatility = covid_volatility))$irfs$ar
}
ar_production <- ar_at(NULL)
ar_neutral <- ar_at(neutral_std)
relative_gap <- function(got, want) max(abs(got - want)) / max(abs(want))
mp_idx <- match(spec$mp_var, colnames(data_mat))
diag_gap <- purrr::map_dbl(c(5L, 3L), function(q) {
  diag_at <- function(covid_volatility) {
    dfm <- estimate_dfm(data_mat, spec$r, q, spec$p, dates = dates,
                        covid_volatility = covid_volatility)
    diag <- diagnose_instrument_in_factor_space(dfm, instrument, dates, spec$p, mp_idx)
    unlist(diag[c("wald_mp", "f_robust_mp", "impact_mp")])
  }
  max(abs(diag_at(neutral_std) / diag_at(NULL) - 1))
})
n5 <- c(
  set_type = identical(purrr::map(ar_neutral$by_level, "set_type"),
                       purrr::map(ar_production$by_level, "set_type")),
  bounds = max(purrr::map2_dbl(ar_neutral$by_level, ar_production$by_level,
                               function(a, b) max(relative_gap(a$lo, b$lo),
                                                  relative_gap(a$hi, b$hi)))) < 1e-10,
  xi_den = abs(ar_neutral$xi_den / ar_production$xi_den - 1) < 1e-10,
  xi_mp = all(diag_gap < 1e-10)
)
if (!all(n5)) {
  stop("N5: under neutral theta the treated inference departs from production at ",
       paste(names(n5)[!n5], collapse = ", "))
}

# S — simulated VAR(2) in three variables. theta_sim is a test value for the
# algebra, not a parametrization of anything.
set.seed(20260914)
n_sim <- 3L
p_sim <- 2L
T_sim <- 160L
sim_dates <- seq(as.Date("2001-01-01"), by = "month", length.out = T_sim)
sim_residual_dates <- sim_dates[(p_sim + 1):T_sim]
covid_sim <- sim_dates[110]
theta_sim <- c(s0 = 6, s1 = 11, s2 = 4, rho = 0.7)
s_all <- covid_volatility_path(sim_dates, covid_sim, theta_sim)
A1 <- matrix(c(0.5, 0.1, 0, 0.2, 0.4, 0.1, 0, 0.1, 0.3), n_sim)
A2 <- diag(0.15, n_sim)
intercept <- c(0.2, -0.1, 0.3)
Y <- matrix(0, T_sim, n_sim)
eps_sim <- matrix(0, T_sim, n_sim)
for (t in (p_sim + 1):T_sim) {
  eps_sim[t, ] <- rnorm(n_sim)
  Y[t, ] <- intercept + A1 %*% Y[t - 1, ] + A2 %*% Y[t - 2, ] + s_all[t] * eps_sim[t, ]
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
# on the residual months, the coefficients are (B2) on the static factors,
# `innovations` routes the chosen residuals into var_residuals and into K, M,
# eta, and K reads the uncentered second moment, (B4) for "standardized"
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
    estimate_dynamic_factors(wls_sim$residuals_standardized, 2L, n_sim,
                             sigma_u = wls_sim$sigma_mle)$factors
  )
)
if (!all(s4)) {
  stop("S4: estimate_dfm plumbing fails at ", paste(names(s4)[!s4], collapse = ", "))
}

# S5 — estimate_covid_theta reaches the maximum of (B5): the envelope condition
# m_t = 1 in the two months s0 and s1 govern alone, a maximum above the true
# theta and above a rho profile, and a lower bound that binds when set above
# the optimum
lower_sim <- c(s0 = 1, s1 = 1, s2 = 1, rho = 0)
upper_sim <- c(s0 = Inf, s1 = Inf, s2 = Inf, rho = 1)
fit_theta <- estimate_covid_theta(Y, p_sim, sim_residual_dates, covid_sim,
                                  lower_sim, upper_sim)
loglik_sim <- function(theta) {
  path <- covid_volatility_path(sim_residual_dates, covid_sim, theta)
  estimate_var_ols(Y, p_sim, s = path)$loglik
}
at_hat <- estimate_var_ols(Y, p_sim, s = fit_theta$path)
e_hat <- at_hat$residuals_standardized
m_hat <- rowSums((e_hat %*% solve(at_hat$sigma_mle)) * e_hat) / n_sim
t_sim <- match(covid_sim, sim_residual_dates)
profile_sim <- purrr::map_dbl(seq(0, 1, by = 0.05), function(rho) {
  optim(fit_theta$theta[c("s0", "s1", "s2")],
        function(s) loglik_sim(c(s, rho = rho)),
        method = "L-BFGS-B", lower = lower_sim[1:3], upper = upper_sim[1:3],
        control = list(fnscale = -1, factr = 1e3))$value
})
bound_fit <- estimate_covid_theta(Y, p_sim, sim_residual_dates, covid_sim,
                                  replace(lower_sim, "s0", 20), upper_sim)
s5 <- c(
  converged = fit_theta$convergence == 0,
  foc_s0 = abs(m_hat[t_sim] - 1) < 1e-4,
  foc_s1 = abs(m_hat[t_sim + 1] - 1) < 1e-4,
  above_truth = fit_theta$loglik >= loglik_sim(theta_sim),
  above_profile = max(profile_sim) <= fit_theta$loglik + 1e-6 * abs(fit_theta$loglik),
  bound_binds = bound_fit$theta[["s0"]] == 20
)
if (!all(s5)) {
  stop("S5: estimate_covid_theta fails at ", paste(names(s5)[!s5], collapse = ", "))
}

# S6 — why the floor: with s0 free to approach zero the WLS fits month t*
# exactly and (B5) climbs as -n log s0, so the unrestricted maximum does not
# exist. From s0 = 1e-3 to 1e-5 the gain is n log 100 up to O(s0^2).
floor_gain <- loglik_sim(replace(fit_theta$theta, "s0", 1e-5)) -
  loglik_sim(replace(fit_theta$theta, "s0", 1e-3))
if (abs(floor_gain / (n_sim * log(100)) - 1) > 1e-3) {
  stop("S6: (B5) gains ", floor_gain, " from s0 = 1e-3 to 1e-5, against ",
       "n log 100 = ", n_sim * log(100))
}

# S7 — under the treatment compute_irf_dfm projects on the uncentered moment,
# MOSW's Gamma (SVARIV.m:128): its point IRF is diag(sy) Lambda B_h K M H with
# H = Z'eta / Z'Z, rebuilt here by hand, and centering would have moved it
dfm_sim <- treated_sim$standardized
eta_sim <- dfm_sim$var_residuals %*% dfm_sim$dynamic_loadings %*%
  solve(dfm_sim$dynamic_scaling)
z_sim <- eta_sim[, 1] + rnorm(nrow(eta_sim), mean = 1)
h_sim <- 3L
irf_sim <- suppressMessages(compute_irf_dfm(dfm_sim, instrument = z_sim, h = h_sim,
                                            mpind = 1L, normalize_value = 1,
                                            inference = "none"))$irf_point_matrix
powers <- Reduce(function(B, i) B %*% dfm_sim$companion_matrix, seq_len(h_sim),
                 accumulate = TRUE, init = diag(nrow(dfm_sim$companion_matrix)))
manual_irf <- function(eta) {
  H <- drop(crossprod(z_sim, eta)) / sum(z_sim^2)
  irf <- sapply(powers, function(B) {
    dfm_sim$data_sd * (dfm_sim$static_loadings %*% B[1:n_sim, 1:n_sim] %*%
                         dfm_sim$dynamic_loadings %*% dfm_sim$dynamic_scaling %*% H)
  })
  irf / irf[1, 1]
}
uncentered <- manual_irf(eta_sim)
centered <- manual_irf(sweep(eta_sim, 2, colMeans(eta_sim)))
s7 <- c(
  uncentered = max(abs(irf_sim - uncentered)) < 1e-10 * max(abs(uncentered)),
  centering_matters = max(abs(uncentered - centered)) > 1e-6 * max(abs(uncentered))
)
if (!all(s7)) {
  stop("S7: the treated identification fails at ", paste(names(s7)[!s7], collapse = ", "))
}

# S8 — the starting values against a literal transcription of
# bvarGLP_covid.m:60-68, y and Tcovid taken after dropping the p initial rows
y_lp <- Y[(p_sim + 1):T_sim, ]
Tcovid_lp <- match(covid_sim, sim_dates) - p_sim
aux <- rowMeans(abs(y_lp[Tcovid_lp:(Tcovid_lp + 2), ] -
                      y_lp[(Tcovid_lp - 1):(Tcovid_lp + 1), ])) /
  mean(abs(y_lp[2:(Tcovid_lp - 1), ] - y_lp[1:(Tcovid_lp - 2), ]))
if (max(abs(unname(fit_theta$start) - c(aux, 0.8))) > 1e-12) {
  stop("S8: the starting values depart from bvarGLP_covid.m by ",
       max(abs(unname(fit_theta$start) - c(aux, 0.8))))
}

# S9 — the influence function of the treated estimator. Given theta, (B2) is
# OLS on the rows divided by s_t, so its estimation error is exactly linear in
# the true innovations: vec(A-hat - A) and Gamma-hat equal the moment means
# that the Shat of CovAhat_Sigmahat_Gamma.m maps, built on (x_t / s_t, z_t,
# eps_t) with the constant first. Built on the untransformed x_t they do not.
eps_true <- eps_sim[(p_sim + 1):T_sim, ]
z_lin <- eps_true[, 1] + rnorm(T_sim - p_sim)
X_raw <- cbind(1, Y[p_sim:(T_sim - 1), ], Y[(p_sim - 1):(T_sim - 2), ])
A_error <- as.vector(t(fit$coefficients[1:(n_sim * p_sim), ]) - cbind(A1, A2))
gamma_hat <- colMeans(z_lin * fit$residuals_standardized)
influence_means <- function(X) {
  Q1inv <- solve(crossprod(X) / nrow(X))
  Q2 <- crossprod(z_lin, X) / nrow(X)
  x_eps <- as.vector(crossprod(eps_true, X) / nrow(X))   # mean of vec(eps_t x_t')
  list(A = drop(kronecker(Q1inv[-1, , drop = FALSE], diag(n_sim)) %*% x_eps),
       Gamma = colMeans(z_lin * eps_true) -
         drop(kronecker(Q2 %*% Q1inv, diag(n_sim)) %*% x_eps))
}
transformed <- influence_means(X_raw / s_sim)
untransformed <- influence_means(X_raw)
s9 <- c(
  A = max(abs(A_error - transformed$A)) < 1e-10,
  Gamma = max(abs(gamma_hat - transformed$Gamma)) < 1e-10,
  transformation_matters = max(abs(A_error - untransformed$A)) > 1e-6
)
if (!all(s9)) {
  stop("S9: the treated influence function fails at ",
       paste(names(s9)[!s9], collapse = ", "))
}

# S10 — the treated sets and xi_mp on the simulated DFM. ar_dfm_bands() and
# compute_irf_dfm(inference = "ar") equal mosw_ar_bounds() on a
# mosw_rform_cov() fed by hand with (1, lags) / s_t, z and the uncentered
# u_t / s_t; the xi_mp of diagnose_instrument_in_factor_space(), which
# residualizes z on the transformed regressors, equals the xi_den of the W2
# block; and its H is the uncentered moment
F_sim <- dfm_sim$static_factors
X_tilde <- cbind(1, F_sim[p_sim:(T_sim - 1), ], F_sim[(p_sim - 1):(T_sim - 2), ]) /
  dfm_sim$volatility_path
cov_hand <- mosw_rform_cov(X_tilde, z_sim, t(dfm_sim$var_residuals), p_sim)
deriv_hand <- mosw_response_derivatives(
  dfm_sim$companion_matrix[1:n_sim, ], p_sim, h_sim, cov_hand$Gamma,
  Load = dfm_sim$data_sd * dfm_sim$static_loadings,
  Inner = tcrossprod(dfm_sim$dynamic_loadings)
)
sets_hand <- mosw_ar_bounds(deriv_hand, cov_hand, 1L, 1, 0.9)
sets_sim <- ar_dfm_bands(dfm_sim, rep(TRUE, length(z_sim)), z_sim, 1L, h_sim,
                         1, rep(1L, ncol(X_sim)), 0.9)$by_level[["0.90"]]
irf_ar_sim <- suppressMessages(compute_irf_dfm(dfm_sim, instrument = z_sim, h = h_sim,
                                               mpind = 1L, normalize_value = 1,
                                               ci_levels = 0.9,
                                               inference = "ar"))$ci[["0.90"]]
diag_sim <- diagnose_instrument_in_factor_space(
  dfm_sim, data.frame(month = sim_residual_dates, shock = z_sim), sim_dates, p_sim, 1L
)
s10 <- c(
  sets = identical(sets_sim$set_type, sets_hand$set_type) &&
    isTRUE(max(abs(c(sets_sim$lo - sets_hand$lo, sets_sim$hi - sets_hand$hi))) < 1e-12),
  compute_irf = isTRUE(max(abs(c(irf_ar_sim$lower - sets_hand$lo,
                                 irf_ar_sim$upper - sets_hand$hi))) < 1e-12),
  xi_two_routes = abs(diag_sim$wald_mp / sets_sim$xi_den - 1) < 1e-8,
  H_uncentered = max(abs(diag_sim$H - drop(crossprod(z_sim, eta_sim)) / sum(z_sim^2))) < 1e-12
)
if (!all(s10)) {
  stop("S10: the treated inference fails at ", paste(names(s10)[!s10], collapse = ", "))
}
