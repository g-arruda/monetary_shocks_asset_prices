# Estimate the Lenza-Primiceri (2022) COVID volatility scale of the factor VAR
# by maximum likelihood, (B5) of their Appendix B, under the author's design of
# 2026-09-14: t* = 2020-03, s0, s1, s2 >= 1 and rho in [0, 1]. theta depends on
# the static factors and on p, not on q, so one estimate serves the whole q
# table; it is estimated at every p of the grid of the p-sensitivity figure
# (Anexo C), p = 4 being production. This script is the sole producer of
# theta, which the estimation scripts read back through
# read_covid_volatility(); it is therefore the one place that must not read
# it. Nothing here computes an IRF. s_t follows from theta-hat through
# covid_volatility_path(); the profile in rho is a check and is not written.
# A multi-start over the whole box checks that theta-hat is the global maximum
# and writes where every start ended.
# Output: output/factors/covid_volatility_theta.csv (theta-hat and likelihoods)
#         output/factors/covid_volatility_multistart.csv (one row per start)
#         output/factors/theta_by_p/covid_volatility_{theta,multistart}_p<p>.csv
#           (the same two files at every other p of the grid)
# Notes: notas/2026-09-14_estimacao_theta_volatilidade_covid.md
#        notas/2026-09-24_otimo_global_theta.md
#        notas/2026-09-25_p_sensibilidade_anexo.md

source("R/modeling/factor_estimation.R")

PANEL_PATH     <- "data/processed/data_log_deseasonalized.csv"
THETA_OUT      <- "output/factors/covid_volatility_theta.csv"
MULTISTART_OUT <- "output/factors/covid_volatility_multistart.csv"
BY_P_DIR       <- "output/factors/theta_by_p"
R_FACTORS    <- 5L
PRODUCTION_P <- 4L
P_GRID       <- 2:6
# The author's design of 2026-09-14. The floor s >= 1 is what makes the
# maximum exist (notas/2026-09-14_estimacao_theta_volatilidade_covid.md).
COVID_START <- as.Date("2020-03-01")
THETA_LOWER <- c(s0 = 1, s1 = 1, s2 = 1, rho = 0)
THETA_UPPER <- c(s0 = Inf, s1 = Inf, s2 = Inf, rho = 1)
# Starting grid of the multi-start, 5^3 x 6 = 750 points. Any s -> Inf sends
# (B5) to -Inf, since -K log s grows while Sigma-hat stays bounded, so a top
# start of 40, three times the largest component of the production theta-hat,
# covers the box.
MULTISTART_S   <- exp(seq(0, log(40), length.out = 5))
MULTISTART_RHO <- seq(0, 1, by = 0.2)
# Finite-difference step of estimate_covid_theta(), shared by the profile and
# the multi-start so that the guards run the same optimizer as the estimate
NDEPS <- 1e-6

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(panel$ref.date)
data_mat <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
factors <- estimate_static_factors(data_mat, R_FACTORS)$factors

dir.create(BY_P_DIR, showWarnings = FALSE, recursive = TRUE)

# One independent pass per p, with every guard below applied at each
purrr::walk(P_GRID, function(p) {
  residual_dates <- dates[(p + 1):length(dates)]

  fit <- estimate_covid_theta(
    factors,
    p,
    residual_dates,
    COVID_START,
    THETA_LOWER,
    THETA_UPPER
  )
  wls <- estimate_var_wls(factors, p, s = fit$path)
  neutral <- estimate_var_wls(
    factors,
    p,
    s = rep(1, length(residual_dates))
  )

  # Squared Mahalanobis size per dimension of the standardized WLS residuals
  # against (B4). At an interior maximum the envelope condition sets it to one
  # in t* and t* + 1, the months that s0 and s1 govern alone.
  standardized <- wls$residuals_standardized
  mahalanobis_per_dim <- rowSums(
    (standardized %*% solve(wls$sigma_mle)) * standardized
  ) / R_FACTORS

  t_star <- match(COVID_START, residual_dates)
  single_month <- c(s0 = t_star, s1 = t_star + 1L)
  interior <- fit$theta[names(single_month)] >
    THETA_LOWER[names(single_month)]
  foc_gap <- abs(mahalanobis_per_dim[single_month] - 1)
  if (fit$convergence != 0 || any(interior & foc_gap > 1e-4)) {
    stop(
      "estimate_covid_theta did not reach the maximum: convergence ",
      fit$convergence,
      ", |m - 1| at t* and t* + 1 = ",
      paste(signif(foc_gap, 3), collapse = ", ")
    )
  }

  loglik_tol <- 1e-6 * abs(fit$loglik)

  # Profile log-likelihood in rho, (s0, s1, s2) re-maximized at each grid point.
  # The free maximum has to dominate the grid, or the optimizer stopped at a
  # local peak.
  profile_loglik <- purrr::map_dbl(seq(0, 1, by = 0.01), function(rho) {
    optim(
      fit$theta[c("s0", "s1", "s2")],
      function(s) {
        path <- covid_volatility_path(
          residual_dates,
          COVID_START,
          c(s, rho = rho)
        )
        estimate_var_wls(factors, p, s = path)$loglik
      },
      method = "L-BFGS-B",
      lower = THETA_LOWER[c("s0", "s1", "s2")],
      upper = THETA_UPPER[c("s0", "s1", "s2")],
      control = list(fnscale = -1, factr = 1e3, ndeps = rep(NDEPS, 3))
    )$value
  })
  if (max(profile_loglik) > fit$loglik + loglik_tol) {
    stop(
      "The rho profile reaches ", max(profile_loglik), ", above the free ",
      "maximum ", fit$loglik, ": estimate_covid_theta stopped at a local peak"
    )
  }

  # Multi-start over the whole box, with the optimizer settings of
  # estimate_covid_theta(). No start may end above the free maximum, and none
  # may end level with it away from theta-hat, or theta-hat is not the unique
  # global maximum. distance_to_hat is the largest relative gap across the four
  # components.
  multistart <- tidyr::expand_grid(
    start_s0 = MULTISTART_S,
    start_s1 = MULTISTART_S,
    start_s2 = MULTISTART_S,
    start_rho = MULTISTART_RHO
  ) |>
    purrr::pmap(function(start_s0, start_s1, start_s2, start_rho) {
      end <- optim(
        c(s0 = start_s0, s1 = start_s1, s2 = start_s2, rho = start_rho),
        function(theta) {
          path <- covid_volatility_path(residual_dates, COVID_START, theta)
          estimate_var_wls(factors, p, s = path)$loglik
        },
        method = "L-BFGS-B",
        lower = THETA_LOWER,
        upper = THETA_UPPER,
        control = list(fnscale = -1, factr = 1e3, ndeps = rep(NDEPS, 4))
      )
      tibble::tibble(
        start_s0,
        start_s1,
        start_s2,
        start_rho,
        s0 = end$par[["s0"]],
        s1 = end$par[["s1"]],
        s2 = end$par[["s2"]],
        rho = end$par[["rho"]],
        loglik = end$value,
        convergence = end$convergence
      )
    }) |>
    purrr::list_rbind() |>
    dplyr::mutate(
      loglik_gap = loglik - fit$loglik,
      distance_to_hat = pmax(
        abs(s0 / fit$theta[["s0"]] - 1),
        abs(s1 / fit$theta[["s1"]] - 1),
        abs(s2 / fit$theta[["s2"]] - 1),
        abs(rho / fit$theta[["rho"]] - 1)
      )
    )

  best_start <- dplyr::slice_max(multistart, loglik, n = 1, with_ties = FALSE)
  if (best_start$loglik > fit$loglik + loglik_tol) {
    stop(
      "A multi-start ends at ", best_start$loglik, ", above the free maximum ",
      fit$loglik, ", at (s0, s1, s2, rho) = (",
      paste(
        signif(unlist(best_start[c("s0", "s1", "s2", "rho")]), 7),
        collapse = ", "
      ),
      "): theta-hat is not the global maximum"
    )
  }
  level_elsewhere <- multistart$loglik >= fit$loglik - loglik_tol &
    multistart$distance_to_hat > 0.05
  if (any(level_elsewhere)) {
    stop(
      sum(level_elsewhere), " multi-starts end level with the free maximum ",
      "more than 5% away from theta-hat: the maximum is not unique"
    )
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
    readr::write_csv(
      if (p == PRODUCTION_P) {
        THETA_OUT
      } else {
        file.path(BY_P_DIR, sprintf("covid_volatility_theta_p%d.csv", p))
      }
    )

  readr::write_csv(
    multistart,
    if (p == PRODUCTION_P) {
      MULTISTART_OUT
    } else {
      file.path(BY_P_DIR, sprintf("covid_volatility_multistart_p%d.csv", p))
    }
  )
})
