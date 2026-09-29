# ===================================================================
# THE IDENTIFICATION CONDITION FOR HETEROSKEDASTICITY, IN THE THREE
# SYSTEMS THE PAPER COMPARES
#
# Rigobon (2003) states ONE condition, the rank condition eq. (6), and says
# it fails if and only if the two regimes' covariance matrices are
# proportional. Its multivariate form is the distinctness of the eigenvalues
# of `Lambda` in `Sigma_NC = B B'`, `Sigma_C = B Lambda B'`, which is what
# the `svars` package estimates and tests. This script runs that test on the
# systems of tab:het_frequency -- the daily window, the monthly VAR without
# and with the Lenza-Primiceri COVID scale, and the factor innovations -- and
# puts the rank condition of the daily window and of the monthly panel side
# by side.
#
# THE ONLY MONTHLY AGGREGATION IS THE PANEL'S OWN (author decision,
# 2026-09-22): the reference month's last quotation for the DI vertices and
# for the CDS, the monthly average for the exchange rate. The object that
# summed the Wed->Thu windows inside the calendar month was removed, and no
# claim may rest on it.
#
# THE BATTERY IS THE PACKAGE'S TEST ONLY (author decision, 2026-09-22). The
# proportionality LR of Mauchly, the lambda_1-lambda_2 gap, the variance
# ratio along the leading direction, the rank-1 share and the permutation
# placebo were this project's own construction and no longer appear, here or
# in the paper.
#
# This is a DIAGNOSTIC, not an identification. Nothing here produces an
# impulse response, and heteroskedasticity identification stays abandoned for
# the paper (2026-08-17). The exploratory responses live in het_rigobon/.
#
# Outputs in output/het/:
#   daily_changes.csv       the Wed->Thu panel the daily row is built on
#   het_conditions.csv      one row per system: Lambda, its SE, Qr
#   het_qr_tests.csv        every sequential Qr null, every system
#   het_variance_ratios.csv Var_C / Var_NC of each residual series
#   het_lambda.csv          every eigenvalue of Lambda with its SE
#   het_var_theta.csv       theta-hat of each monthly VAR, one per vertex
#   het_var_theta_multistart.csv  where every start of its multi-start ended
#
# Run: Rscript script/het_conditions.R
# ===================================================================

source("R/instrument/di_surprise.R")
source("R/identification/het_tests.R")
source("R/modeling/factor_estimation.R")

OUT_DIR     <- "output/het"
PANEL_PATH  <- "data/processed/data_log_deseasonalized.csv"
COPOM_PATH  <- "data/raw/copom_historico.csv"
DI_PATH     <- "data/raw/di.csv"
BRL_PATH    <- "data/raw/brl_usd_daily.csv"
CDS_PATH    <- "data/raw/CDS 5y.xlsx"
THETA_PATH  <- "output/factors/covid_volatility_theta.csv"

# The production window, used in all three systems so that the contrast is
# between systems and not between samples.
SAMPLE <- as.Date(c("2012-03-01", "2025-12-31"))

# THE SERIES ARE GRG's (2025), on both sides: the Wednesday-to-Thursday change
# in the DI, the BRL/USD rate and the 5-year sovereign CDS (their Table 1).
# They use neither the Ibovespa nor the 2-year vertex; the daily row this
# project published until 2026-09-21 used both, and that set was the
# project's, not theirs.
#
# GRG's fourth series, inflation expectations, is the breakeven between
# indexed and nominal bonds. The project only has the Focus measure, a survey
# (the authors themselves say "market-based (not survey data)"), whose daily
# change is exactly zero on 23% of days because Focus is published once a
# week. It is left out, and the gap is declared.
#
# The DI vertex is the dimension GRG themselves vary (1m, 3m, 6m, 12m). The
# three the project can build enter as rows at both frequencies: picking one
# would be picking the conclusion.
VERTICES <- tibble::tribble(
  ~label,     ~daily,   ~monthly,    ~business_days,
  "3 meses",  "di_3m",  "yield_3m",  63L,
  "6 meses",  "di_6m",  "yield_6m",  126L,
  "12 meses", "di_12m", "yield_1y",  252L
)
DAILY_DEPENDENTS   <- c("cds_5y", "brl")         # GRG's two dependents
MONTHLY_DEPENDENTS <- c("cds_5y", "cambio_usd")  # the same, in the panel

P_LAGS    <- 4L
R_FACTORS <- 5L
Q_DYNAMIC <- 5L

# The monthly VAR under the Lenza-Primiceri (2022) scale follows the author's
# design of 2026-09-14 for the factor VAR (script/covid_volatility_theta.R),
# with a theta of its own in each VAR, one per vertex, and not the factor
# VAR's (author decision, 2026-09-24). The multi-start grid is the factor
# VAR's.
COVID_START    <- as.Date("2020-03-01")
THETA_LOWER    <- c(s0 = 1, s1 = 1, s2 = 1, rho = 0)
THETA_UPPER    <- c(s0 = Inf, s1 = Inf, s2 = Inf, rho = 1)
MULTISTART_S   <- exp(seq(0, log(40), length.out = 5))
MULTISTART_RHO <- seq(0, 1, by = 0.2)

# Daily Wed->Thu panel: one observation per week, Wednesday to Thursday. The
# Copom announces after Wednesday's close, so the window covers the
# announcement. Regime C = the Wednesday is a meeting day. Weeks without
# trading on Wednesday or Thursday become NA and drop out -- never zero, which
# would pass "no quote" off as "no change".
brl <- readr::read_csv(BRL_PATH, show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), valor = 100 * log(brl))
cds <- readxl::read_excel(CDS_PATH, skip = 5) |>
  purrr::set_names(c("date", "valor")) |>
  dplyr::transmute(date = as.Date(date), valor = as.numeric(valor)) |>
  dplyr::filter(!is.na(date), !is.na(valor))

daily_panel <- build_weekly_changes(
  SAMPLE[1],
  SAMPLE[2],
  purrr::set_names(VERTICES$business_days, VERTICES$daily),
  list(cds_5y = cds, brl = brl),
  COPOM_PATH,
  DI_PATH
) |>
  tidyr::drop_na(dplyr::all_of(c(VERTICES$daily, DAILY_DEPENDENTS)))

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
readr::write_csv(daily_panel, file.path(OUT_DIR, "daily_changes.csv"))

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()

regimes <- build_monthly_regimes(COPOM_PATH, month_range = range(dates))
monthly_regimes <- align_regimes_to_eta(dates, P_LAGS, regimes)

# System 1: the three observables at daily frequency. No economic lag: the
# Wed->Thu changes are already innovations. p = 1 is a formality, because
# cv_ident_test() rebuilds residuals through YLagCr and does not accept
# p = 0; the `inert_lag` guard requires the residuals to still be the series
# themselves.
het_daily <- purrr::map(
  purrr::set_names(VERTICES$daily, VERTICES$label),
  function(vertex) {
    fit_het_cv(
      as.matrix(daily_panel[, c(vertex, DAILY_DEPENDENTS)]),
      p = 1L,
      type = "const",
      regime_labels = daily_panel$regime[-1],
      inert_lag = TRUE
    )
  }
)

# System 2: a monthly VAR of the same three observables, with the window, lag
# and deterministic terms of the ibc5_fx_cds_level_trend_p4 benchmark, so that
# the contrast is one of identification and not of sample. Two versions: OLS,
# and WLS under the Lenza-Primiceri scale s_t, whose residuals u_t / s_t are
# what the factor VAR hands the factor row. Both reach the test the way the
# factor innovations do (p = 1, inert), so that they differ by the scale alone.
residual_dates <- dates[(P_LAGS + 1):length(dates)]
monthly_vars <- purrr::map(
  purrr::set_names(VERTICES$monthly, VERTICES$label),
  function(vertex) {
    y <- as.matrix(raw_data[, c(vertex, MONTHLY_DEPENDENTS)])
    ols <- estimate_var_wls(y, P_LAGS, type = "both")

    # theta-hat is invariant to rescaling the columns. Dividing each by its
    # residual sd only keeps the starting rule of Lenza and Primiceri, a
    # cross-series mean of absolute changes, from reading the CDS in basis
    # points alone.
    y_scaled <- sweep(y, 2, apply(ols$residuals, 2, sd), "/")
    theta_fit <- estimate_covid_theta(
      y_scaled,
      P_LAGS,
      type = "both",
      residual_dates,
      COVID_START,
      THETA_LOWER,
      THETA_UPPER
    )
    multistart <- verify_covid_theta(
      y_scaled,
      P_LAGS,
      type = "both",
      residual_dates,
      COVID_START,
      THETA_LOWER,
      THETA_UPPER,
      theta_fit,
      MULTISTART_S,
      MULTISTART_RHO
    )

    list(
      ols = ols,
      wls = estimate_var_wls(y, P_LAGS, type = "both", s = theta_fit$path),
      theta_fit = theta_fit,
      loglik_neutral = estimate_var_wls(y_scaled, P_LAGS, type = "both")$loglik,
      multistart = multistart
    )
  }
)

het_monthly <- purrr::map(monthly_vars, function(monthly_var) {
  fit_het_cv(
    monthly_var$ols$residuals,
    p = 1L,
    type = "const",
    regime_labels = monthly_regimes[-1],
    inert_lag = TRUE
  )
})
het_monthly_covid <- purrr::map(monthly_vars, function(monthly_var) {
  fit_het_cv(
    monthly_var$wls$residuals_standardized,
    p = 1L,
    type = "const",
    regime_labels = monthly_regimes[-1],
    inert_lag = TRUE
  )
})

# System 3: the five factor innovations of the production cell.
dfm <- estimate_dfm(
  data_mat,
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_LAGS,
  dates = dates,
  covid_volatility = read_covid_volatility(THETA_PATH)
)
eta <- extract_dynamic_innovations(dfm)
colnames(eta) <- paste0("eta", seq_len(ncol(eta)))
het_factors <- fit_het_cv(
  eta,
  p = 1L,
  type = "const",
  regime_labels = monthly_regimes[-1],
  inert_lag = TRUE
)

# One entry per row of the tables; `mp_index` is the DI column the rank
# statistic reads, absent for the factor innovations.
systems <- c(
  purrr::pmap(VERTICES, function(label, daily, monthly, business_days) {
    list(
      name = "Tres observaveis de GRG",
      frequency = "Diaria",
      vertex = label,
      fit = het_daily[[label]],
      mp_index = 1L,
      series = c(daily, DAILY_DEPENDENTS),
      inert = TRUE
    )
  }),
  purrr::pmap(VERTICES, function(label, daily, monthly, business_days) {
    list(
      name = "Tres observaveis de GRG (VAR)",
      frequency = "Mensal",
      vertex = label,
      fit = het_monthly[[label]],
      mp_index = 1L,
      series = c(monthly, MONTHLY_DEPENDENTS),
      inert = TRUE
    )
  }),
  purrr::pmap(VERTICES, function(label, daily, monthly, business_days) {
    list(
      name = "Tres observaveis de GRG (VAR, escala COVID)",
      frequency = "Mensal",
      vertex = label,
      fit = het_monthly_covid[[label]],
      mp_index = 1L,
      series = c(monthly, MONTHLY_DEPENDENTS),
      inert = TRUE
    )
  }),
  list(list(
    name = "Cinco inovacoes fatoriais",
    frequency = "Mensal",
    vertex = "--",
    fit = het_factors,
    mp_index = NA_integer_,
    series = colnames(eta),
    inert = TRUE
  ))
)

conditions <- purrr::map(systems, function(system) {
  fit <- system$fit
  by_size <- order(fit$Lambda, decreasing = TRUE)
  first_pair_test <- fit$qr_test["lambda_ 1 =lambda_2", ]
  rank_stat <- if (is.na(system$mp_index)) {
    list(a = NA_real_, det_Q = NA_real_, det_ratio = NA_real_)
  } else {
    rigobon_rank_stat(fit$Sigma_C, fit$Sigma_NC, system$mp_index)
  }
  tibble::tibble(
    sistema = system$name,
    frequencia = system$frequency,
    vertice = system$vertex,
    n_C = fit$n_C,
    n_NC = fit$n_NC,
    k = length(fit$Lambda),
    lambda_1 = fit$Lambda[by_size[1]],
    lambda_1_se = fit$Lambda_SE[by_size[1]],
    lambda_2 = fit$Lambda[by_size[2]],
    lambda_2_se = fit$Lambda_SE[by_size[2]],
    lambda_min = min(fit$Lambda),
    qr_12 = first_pair_test[[1]],
    qr_12_df = first_pair_test[[2]],
    qr_12_p = first_pair_test[[3]],
    qr_12_nk = fit$qr_12_nk,
    qr_12_nk_p = fit$qr_12_nk_p,
    kappa_NC = fit$kappa[1],
    kappa_C = fit$kappa[2],
    fator_curtose = fit$kurt_factor,
    qr_min_p = max(fit$qr_test[["p-value"]]),
    a = rank_stat$a,
    det_Q = rank_stat$det_Q,
    det_ratio = rank_stat$det_ratio,
    coluna_mp = fit$mp_col,
    var_mp = system$series[fit$mp_col],
    recon_dev = fit$recon_dev,
    lambda_dev = fit$lambda_dev,
    inerte = system$inert,
    fidelidade = fit$resid_fidelity,
    iteracoes = fit$iteration
  )
}) |>
  purrr::list_rbind() |>
  # Holm across the three DI vertices of each system: the daily claim rests
  # on the one vertex that rejects, so its p has to survive the other two.
  dplyr::mutate(
    qr_12_p_holm = p.adjust(qr_12_p, method = "holm"),
    .by = sistema
  )

qr_tests <- purrr::map(systems, function(system) {
  tibble::as_tibble(system$fit$qr_test, rownames = "hipotese") |>
    dplyr::mutate(
      sistema = system$name,
      vertice = system$vertex,
      .before = 1
    ) |>
    dplyr::rename(estatistica = `Test statistic`, gl = dof, p = `p-value`)
}) |>
  purrr::list_rbind()

# The variance ratio of Rigobon and Sack (2004), series by series, on the same
# residuals the test uses: for the DI it is the `a` of rigobon_rank_stat().
variance_ratios <- purrr::map(systems, function(system) {
  tibble::tibble(
    sistema = system$name,
    frequencia = system$frequency,
    vertice = system$vertex,
    serie = system$series,
    var_C = diag(system$fit$Sigma_C),
    var_NC = diag(system$fit$Sigma_NC),
    razao = var_C / var_NC
  )
}) |>
  purrr::list_rbind()

eigenvalues <- purrr::map(systems, function(system) {
  by_size <- order(system$fit$Lambda, decreasing = TRUE)
  tibble::tibble(
    sistema = system$name,
    frequencia = system$frequency,
    vertice = system$vertex,
    ordem = seq_along(by_size),
    lambda = system$fit$Lambda[by_size],
    lambda_se = system$fit$Lambda_SE[by_size]
  )
}) |>
  purrr::list_rbind()

# theta-hat of each monthly VAR. The likelihood ratio against the neutral
# scale is invariant to the rescaling theta was estimated on; the log-
# likelihoods themselves are not, and stay out.
var_theta <- purrr::imap(monthly_vars, function(monthly_var, label) {
  theta_fit <- monthly_var$theta_fit
  tibble::tibble(
    vertice = label,
    covid_start = COVID_START,
    s0 = theta_fit$theta[["s0"]],
    s1 = theta_fit$theta[["s1"]],
    s2 = theta_fit$theta[["s2"]],
    rho = theta_fit$theta[["rho"]],
    lr_vs_neutral = 2 * (theta_fit$loglik - monthly_var$loglik_neutral),
    downweighted_months = sum(1 - 1 / theta_fit$path^2),
    convergence = theta_fit$convergence,
    start_s0 = theta_fit$start[["s0"]],
    start_s1 = theta_fit$start[["s1"]],
    start_s2 = theta_fit$start[["s2"]],
    start_rho = theta_fit$start[["rho"]]
  )
}) |>
  purrr::list_rbind()

var_multistart <- purrr::imap(monthly_vars, function(monthly_var, label) {
  dplyr::mutate(monthly_var$multistart, vertice = label, .before = 1)
}) |>
  purrr::list_rbind() |>
  dplyr::select(-loglik)

readr::write_csv(conditions, file.path(OUT_DIR, "het_conditions.csv"))
readr::write_csv(qr_tests, file.path(OUT_DIR, "het_qr_tests.csv"))
readr::write_csv(variance_ratios, file.path(OUT_DIR, "het_variance_ratios.csv"))
readr::write_csv(eigenvalues, file.path(OUT_DIR, "het_lambda.csv"))
readr::write_csv(var_theta, file.path(OUT_DIR, "het_var_theta.csv"))
readr::write_csv(
  var_multistart,
  file.path(OUT_DIR, "het_var_theta_multistart.csv")
)
