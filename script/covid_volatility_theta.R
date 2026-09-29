# Estimate the Lenza-Primiceri (2022) COVID volatility scale of the factor VAR
# by maximum likelihood, (B5) of their Appendix B, under the author's design of
# 2026-09-14: t* = 2020-03, s0, s1, s2 >= 1 and rho in [0, 1]. theta depends on
# the static factors and on p, not on q, so one estimate serves the whole q
# table; it is estimated at every p of the grid of the p-sensitivity figure
# (Anexo C), p = 4 being production. This script is the sole producer of
# theta, which the estimation scripts read back through
# read_covid_volatility(); it is therefore the one place that must not read
# it. Nothing here computes an IRF. s_t follows from theta-hat through
# covid_volatility_path(). verify_covid_theta() checks at every p that
# theta-hat is the global maximum -- first-order conditions, a profile in rho
# that is not written, and a multi-start over the whole box whose end points
# are.
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

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(panel$ref.date)
data_mat <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
factors <- estimate_static_factors(data_mat, R_FACTORS)$factors

dir.create(BY_P_DIR, showWarnings = FALSE, recursive = TRUE)

# One independent pass per p, every guard of verify_covid_theta() at each
purrr::walk(P_GRID, function(p) {
  residual_dates <- dates[(p + 1):length(dates)]

  fit <- estimate_covid_theta(
    factors,
    p,
    type = "const",
    residual_dates,
    COVID_START,
    THETA_LOWER,
    THETA_UPPER
  )
  multistart <- verify_covid_theta(
    factors,
    p,
    type = "const",
    residual_dates,
    COVID_START,
    THETA_LOWER,
    THETA_UPPER,
    fit,
    MULTISTART_S,
    MULTISTART_RHO
  )
  neutral <- estimate_var_wls(
    factors,
    p,
    type = "const",
    s = rep(1, length(residual_dates))
  )

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
