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
#   daily_changes.csv       the weekly panel the daily row is built on, with
#                           the Yahoo rows and the CDS dates of each week's
#                           window
#   het_conditions.csv      one row per system: Lambda, its SE, Qr
#   het_qr_tests.csv        every sequential Qr null, every system
#   het_variance_ratios.csv Var_C / Var_NC of each residual series
#   het_lambda.csv          every eigenvalue of Lambda with its SE
#   het_var_theta.csv       theta-hat of each monthly VAR, one per vertex
#   het_var_theta_multistart.csv  where every start of its multi-start ended
#
# Run: Rscript script/het_conditions.R, after script/copom_timing.R (the
# Yahoo and CDS windows of each meeting).
# ===================================================================

source("R/instrument/di_surprise.R")
source("R/identification/het_tests.R")
source("R/modeling/factor_estimation.R")

OUT_DIR     <- "output/het"
PANEL_PATH  <- "data/processed/data_log_deseasonalized.csv"
COPOM_PATH  <- "data/raw/copom_historico.csv"
DI_PATH     <- "data/raw/di.csv"
BRL_PATH    <- "data/raw/brl_usd_daily.csv"
MEETINGS_PATH <- "output/copom_timing/meetings.csv"
CDS_PATH    <- "data/raw/CDS 5y.xlsx"
THETA_PATH  <- "output/factors/covid_volatility_theta.csv"

# The production window, used in all three systems so that the contrast is
# between systems and not between samples.
SAMPLE <- as.Date(c("2012-03-01", "2025-12-31"))

TZ_BRASILIA <- "America/Sao_Paulo"
TZ_NEW_YORK <- "America/New_York"

# The CDS close is taken at 17h New York (author decision of 2026-10-14), as
# in the meeting windows of script/copom_timing.R. A week without a meeting
# takes the windows a Wednesday release at 18h Brasilia would have (author
# decision of 2026-10-23 for the CDS, the FX rule of 2026-10-13).
CDS_CLOSE_NY       <- "17:00"
NO_MEETING_RELEASE <- "18:00"

# THE SERIES ARE GRG's (2025), on both sides: the DI, the BRL/USD rate and
# the 5-year sovereign CDS (their Table 1, Wednesday to Thursday; here each
# series' own window around the announcement, below).
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

# Daily panel: one observation per week. The DI runs from Wednesday's close
# to Thursday's: the Copom announces after Wednesday's close, so the window
# covers the announcement. The exchange rate (Yahoo BRL=X, the Brazilian
# evening's quote, 20h-22h) and the CDS (17h New York, 18h-20h) run from the
# last quote before the announcement to the first after it, as
# script/copom_timing.R dates them in a meeting week. In the other weeks
# they run across an 18h Wednesday release: Tuesday's evening Yahoo quote to
# Wednesday's, and for the CDS Wednesday's close to the next when it falls
# at 18h (US summer time) -- it counts as before, as in the 72 meetings
# where it does -- and the quote before Wednesday to Wednesday's otherwise.
# Regime C = the Wednesday is a meeting day. Weeks without a quote in any
# window become NA and drop out -- never zero, which would pass "no quote"
# off as "no change"; this drops the seven meetings whose Thursday is a
# Brazilian holiday, which have no Thursday DI.
yahoo <- load_yahoo_brl(BRL_PATH)
meeting_windows <- readr::read_csv(MEETINGS_PATH, show_col_types = FALSE) |>
  dplyr::select(
    wednesday,
    yahoo_pre,
    yahoo_post,
    cds_pre = cds_pre_ny17,
    cds_post = cds_post_ny17,
    d_cds_ny17
  )
cds <- readxl::read_excel(CDS_PATH, skip = 5) |>
  purrr::set_names(c("date", "valor")) |>
  dplyr::transmute(date = as.Date(date), valor = as.numeric(valor)) |>
  dplyr::filter(!is.na(date), !is.na(valor))

weekly_changes <- build_weekly_changes(
  SAMPLE[1],
  SAMPLE[2],
  purrr::set_names(VERTICES$business_days, VERTICES$daily),
  list(),
  COPOM_PATH,
  DI_PATH
) |>
  dplyr::left_join(meeting_windows, by = c("wed_date" = "wednesday"))

# The coalesce below would hand a meeting missing from meetings.csv the
# no-meeting windows without a word
stopifnot(
  !anyNA(
    weekly_changes |>
      dplyr::filter(regime == "C") |>
      dplyr::select(yahoo_pre, yahoo_post, cds_pre, cds_post)
  )
)

daily_panel <- weekly_changes |>
  dplyr::mutate(
    no_meeting_release = lubridate::ymd_hm(
      paste(wed_date, NO_MEETING_RELEASE),
      tz = TZ_BRASILIA
    ),
    no_meeting_index = findInterval(
      as.numeric(no_meeting_release),
      as.numeric(yahoo$quote_time)
    ),
    cds_close_after_release = lubridate::ymd_hm(
      paste(wed_date, CDS_CLOSE_NY),
      tz = TZ_NEW_YORK
    ) > no_meeting_release,
    cds_before_wednesday = cds$date[
      findInterval(as.numeric(wed_date) - 1, as.numeric(cds$date))
    ],
    cds_after_wednesday = cds$date[
      findInterval(as.numeric(wed_date), as.numeric(cds$date)) + 1L
    ],
    yahoo_pre = dplyr::coalesce(yahoo_pre, yahoo$date[no_meeting_index]),
    yahoo_post = dplyr::coalesce(yahoo_post, yahoo$date[no_meeting_index + 1L]),
    cds_pre = dplyr::coalesce(
      cds_pre,
      dplyr::if_else(cds_close_after_release, cds_before_wednesday, wed_date)
    ),
    cds_post = dplyr::coalesce(
      cds_post,
      dplyr::if_else(cds_close_after_release, wed_date, cds_after_wednesday)
    ),
    brl = 100 * log(
      yahoo$brl[match(yahoo_post, yahoo$date)] /
        yahoo$brl[match(yahoo_pre, yahoo$date)]
    ),
    cds_5y = cds$valor[match(cds_post, cds$date)] -
      cds$valor[match(cds_pre, cds$date)]
  ) |>
  tidyr::drop_na(dplyr::all_of(c(VERTICES$daily, DAILY_DEPENDENTS)))

# In a meeting week the CDS change is the narrow window of Anexo E, up to
# the rounding of meetings.csv
stopifnot(
  with(
    dplyr::filter(daily_panel, regime == "C"),
    isTRUE(all.equal(cds_5y, d_cds_ny17))
  )
)

daily_panel <- daily_panel |>
  dplyr::select(
    -no_meeting_release,
    -no_meeting_index,
    -cds_close_after_release,
    -cds_before_wednesday,
    -cds_after_wednesday,
    -d_cds_ny17
  )

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
