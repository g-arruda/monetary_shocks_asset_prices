# ===================================================================
# THE IDENTIFICATION CONDITION FOR HETEROSKEDASTICITY, IN THE THREE
# SYSTEMS THE PAPER COMPARES
#
# Rigobon (2003) states ONE condition, the rank condition eq. (6), and says
# it fails if and only if the two regimes' covariance matrices are
# proportional. Its multivariate form is the distinctness of the eigenvalues
# of `Lambda` in `Sigma_NC = B B'`, `Sigma_C = B Lambda B'`, which is what
# the `svars` package estimates and tests. This script runs that test on the
# three systems of tab:het_frequency and puts the rank condition of the daily
# window and of the monthly panel side by side.
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
#   het_qr_tests.csv        every sequential Qr null, all three systems
#   het_variance_ratios.csv Var_C / Var_NC of each residual series
#   het_lambda.csv          every eigenvalue of Lambda with its SE
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
# the contrast is one of identification and not of sample.
het_monthly <- purrr::map(
  purrr::set_names(VERTICES$monthly, VERTICES$label),
  function(vertex) {
    fit_het_cv(
      as.matrix(raw_data[, c(vertex, MONTHLY_DEPENDENTS)]),
      p = P_LAGS,
      type = "both",
      regime_labels = monthly_regimes
    )
  }
)

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
      inert = FALSE
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

readr::write_csv(conditions, file.path(OUT_DIR, "het_conditions.csv"))
readr::write_csv(qr_tests, file.path(OUT_DIR, "het_qr_tests.csv"))
readr::write_csv(variance_ratios, file.path(OUT_DIR, "het_variance_ratios.csv"))
readr::write_csv(eigenvalues, file.path(OUT_DIR, "het_lambda.csv"))
