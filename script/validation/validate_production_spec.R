# Validate the canonical 115-series production panel and the (5,5) impact gate.

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/factor_selection.R")
source("R/modeling/impulse_response.R")
source("R/modeling/var_proxy.R")
source("R/identification/factor_space_diagnostics.R")

out_dir <- "output/validation"

# This script is the canonical declaration of the production specification:
# every invariant below is written here as a literal and checked against what
# data/processed/ and output/ actually contain. The estimation scripts carry
# their own copies, which is the point — a check that read the producer's own
# values would prove nothing.
PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
BASE_PATH       <- "data/processed/data_log_deseasonalized_base_106.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
BAI_NG_PATH     <- "output/factors/production_bai_ng_bll_surface.csv"
SAMPLE           <- as.Date(c("2012-03-01", "2025-12-01"))
PRE_COVID_SAMPLE <- as.Date(c("2012-03-01", "2019-12-01"))
R_FACTORS  <- 5L
Q_DYNAMIC  <- 5L
P_LAGS     <- 4L
HORIZON    <- 48L
INSTRUMENT <- "z_bs_purif"
MP_VAR     <- "yield_6m"
NORMALIZE_VALUE <- 0.005
CI_LEVELS  <- c(0.80, 0.90)
N_SERIES      <- 115L
N_BASE_SERIES <- 106L
N_MONTHS <- 166L
N_INNOVATIONS <- 162L
# The author's design of 2026-09-14, which is how theta is obtained
COVID_START <- as.Date("2020-03-01")
THETA_LOWER <- c(s0 = 1, s1 = 1, s2 = 1, rho = 0)
THETA_UPPER <- c(s0 = Inf, s1 = Inf, s2 = Inf, rho = 1)
PRODUCTION_SERIES_ADDED <- c(
  "fiscal_dbgg",
  "fiscal_dlsp",
  "fiscal_primary_balance",
  "expect_focus_ipca12m",
  "expect_focus_selic_12m",
  "expect_focus_pib_12m",
  "expect_focus_cambio_12m",
  "dlsp_exchange_adjustment",
  "expect_focus_fiscal_dlsp_12m",
  "expect_focus_fiscal_primary_balance_12m",
  "expect_focus_fiscal_nominal_balance_12m"
)
REQUIRED_SERIES <- c(MP_VAR, PRODUCTION_SERIES_ADDED)
EXCLUDED_SERIES <- c(
  "juros_cdi", "asset_mlcx", "external_current_account_gdp",
  "external_exports", "external_imports", "external_reserves", "us_dgs2",
  "us_dgs10", "us_fedfunds", "us_dtwexbgs", "asset_sp500_yahoo",
  "credit_default_rate", "credit_average_rate", "housing_ivgr"
)
LAG_SELECTION <- list(
  deterministic = "trend",
  max_lag = 12L,
  common_sample = 154L,
  selected_aic = 4L,
  selected_bic = 2L,
  # 8.231266782137459 with the "ano seguinte" Focus series, until 2026-10-03;
  # 8.1488747303972797 with msci the MSCI Inc. share price, until 2026-10-12
  aic_at_production = 8.196535084589943
)
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE)
base <- readr::read_csv(BASE_PATH, show_col_types = FALSE)
manifest <- readr::read_csv(
  "output/panel/production_series_manifest.csv",
  show_col_types = FALSE
)
dates <- as.Date(panel$ref.date)
data_mat <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
base_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
expected_dates <- seq(SAMPLE[1], SAMPLE[2], by = "month")
if (!identical(dates, expected_dates) || nrow(data_mat) != N_MONTHS ||
    ncol(data_mat) != N_SERIES || ncol(base_mat) != N_BASE_SERIES ||
    anyDuplicated(colnames(data_mat)) || any(!is.finite(data_mat)) ||
    any(!is.finite(base_mat)) ||
    !all(REQUIRED_SERIES %in% colnames(data_mat)) ||
    any(EXCLUDED_SERIES %in% colnames(data_mat))) {
  stop("The canonical and base panels do not satisfy the production composition invariants.")
}
if (nrow(manifest) != N_SERIES || anyDuplicated(manifest$variable) ||
    !setequal(manifest$variable, colnames(data_mat)) ||
    !identical(
      manifest$source_id[match("spread_credito_pj_total", manifest$variable)],
      "SGS 20784"
    ) ||
    !identical(
      manifest$source_id[match("spread_credito_pf_total", manifest$variable)],
      "SGS 20785"
    ) ||
    !all(PRODUCTION_SERIES_ADDED %in% manifest$variable) ||
    any(c("spread_icc_juridica", "spread_icc_fisica") %in% manifest$variable) ||
    any(grepl("^SEM_AJUSTE", manifest$seasonal_status))) {
  stop("The production manifest does not identify the 115-series composition and sources.")
}

bai_ng <- bai_ng_criteria(data_mat, max_r = 20L, apply_bll = TRUE)
bai_ng_surface <- tibble::tibble(
  r = seq_len(20L),
  IC1 = bai_ng$criteria$IC1,
  IC2 = bai_ng$criteria$IC2,
  IC3 = bai_ng$criteria$IC3
)
# IC3 selected 20 with the "ano seguinte" Focus series, until 2026-10-03
if (!identical(unname(unlist(bai_ng$r_hat)), c(5L, 5L, 18L)) ||
    any(!is.finite(as.matrix(bai_ng_surface[, -1])))) {
  stop("The BLL Bai-Ng surface must be finite and select IC1=5, IC2=5, IC3=18.")
}
saved_bai_ng <- readr::read_csv(BAI_NG_PATH, show_col_types = FALSE)
if (!identical(names(saved_bai_ng), names(bai_ng_surface)) ||
    nrow(saved_bai_ng) != nrow(bai_ng_surface) ||
    max(abs(as.matrix(saved_bai_ng) - as.matrix(bai_ng_surface))) > 1e-12) {
  stop("The saved production BLL Bai-Ng surface does not reproduce.")
}

instrument_wide <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))
if (!identical(instrument_wide$month, expected_dates) ||
    nrow(instrument_wide) != N_MONTHS ||
    anyDuplicated(instrument_wide$month) ||
    any(!is.finite(as.matrix(instrument_wide[, -1])))) {
  stop("The instrument variants must cover all 166 production months.")
}
first_instrument <- c(
  -22.022780871483423, -19.657534015830727, -5.2528948250458516, 0,
  7.2624960719803342, 6.4545813094945652, 0, -4.4561851757103943
)
if (max(abs(instrument_wide[[INSTRUMENT]][seq_along(first_instrument)] -
    first_instrument)) > 1e-12) {
  stop("The recalculated initial production-instrument values changed.")
}
event_diagnostics <- readr::read_csv(
  "data/processed/copom_event_diagnostics.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(month = lubridate::floor_date(as.Date(date), "month")) |>
  dplyr::group_by(month) |>
  dplyr::summarise(copom_events = dplyr::n(), .groups = "drop")
zero_contract <- tibble::tibble(month = expected_dates) |>
  dplyr::left_join(event_diagnostics, by = "month") |>
  dplyr::mutate(copom_events = tidyr::replace_na(copom_events, 0L))
if (sum(instrument_wide[[INSTRUMENT]] == 0) != 64L ||
    !identical(
      instrument_wide[[INSTRUMENT]] == 0,
      zero_contract$copom_events == 0
    )) {
  stop("The monthly zeros do not match months without a Copom meeting.")
}
instrument <- instrument_wide |>
  dplyr::transmute(month = as.Date(month), shock = .data[[INSTRUMENT]]) |>
  dplyr::filter(!is.na(shock))

factors <- estimate_static_factors(data_mat, R_FACTORS)$factors
lag_criteria <- var_lag_criteria(
  factors,
  pmax = LAG_SELECTION$max_lag,
  deterministic = LAG_SELECTION$deterministic
)
if (unique(lag_criteria$T_common) != LAG_SELECTION$common_sample ||
    lag_criteria$p[which.min(lag_criteria$aic)] != LAG_SELECTION$selected_aic ||
    lag_criteria$p[which.min(lag_criteria$bic)] != LAG_SELECTION$selected_bic ||
    abs(lag_criteria$aic[lag_criteria$p == P_LAGS] -
      LAG_SELECTION$aic_at_production) > 1e-12) {
  stop("The reported factor-lag criteria do not reproduce on the expanded sample.")
}
readr::write_csv(
  lag_criteria,
  file.path(out_dir, "production_factor_lag_criteria.csv")
)
# Every estimation script reads theta from THETA_PATH. Re-derive it here from
# data/processed/ and stop if it moved: a panel, r or p change silently
# invalidates the stored theta.
covid_volatility <- read_covid_volatility(THETA_PATH)
theta_refit <- estimate_covid_theta(
  factors, P_LAGS, type = "const", dates[(P_LAGS + 1):length(dates)],
  COVID_START, THETA_LOWER, THETA_UPPER
)
theta_stored <- covid_volatility$theta
if (!identical(covid_volatility$covid_start, COVID_START) ||
    !setequal(names(theta_refit$theta), names(theta_stored)) ||
    max(abs(theta_refit$theta / theta_stored[names(theta_refit$theta)] - 1)) > 1e-8) {
  stop("The stored production theta does not reproduce from the panel: refit is (",
       paste(sprintf("%s = %.15g", names(theta_refit$theta), theta_refit$theta),
             collapse = ", "), "). Re-run script/covid_volatility_theta.R, which ",
       "writes ", THETA_PATH, ".")
}

mpind <- match(MP_VAR, colnames(data_mat))
samples <- list(full = SAMPLE, pre_covid = PRE_COVID_SAMPLE)
# The full window runs the production Lenza-Primiceri scale since 2026-09-17;
# the pre-COVID window has s_t = 1 in every month, so its numbers are the same
# treated or not, and they did not move when the treatment was switched on.
# xi_mp and F_rob are those of z_bs_purif since 2026-09-26, equal to its (5,5)
# rows of output/instrument/mosw_strength_grid.csv; the companion roots do not
# depend on the instrument. Since 2026-10-03 the six Focus annual series are
# at a fixed 12-month horizon; with the "ano seguinte" series xi_mp was
# 7.0189895200649515 / 6.8366817810330156, F_rob 8.6163300983816562 /
# 8.3066479428861566 and the roots 0.9836760960674927 / 0.9933587954932864.
# Since 2026-10-12 msci is the MSCI Emerging Markets index; with the MSCI Inc.
# share price xi_mp was 6.8019636546454532 / 5.5043620711622054, F_rob
# 8.2830468753569697 / 5.3359788636967229 and the roots 0.9855005224958937 /
# 0.9944736338672295.
expected <- tibble::tibble(
  sample = c("full", "pre_covid"),
  n_innovations = c(162L, 90L),
  xi_mp = c(6.6613895553441687, 5.5974534965709433),
  f_robust_mp = c(8.0676674199604381, 5.1610891060133097),
  max_companion_root = c(0.9887383856792471, 0.99101457123904813),
  stable = c(TRUE, TRUE)
)

diagnostics <- lapply(names(samples), function(sample_name) {
  window <- samples[[sample_name]]
  keep <- dates >= window[1] & dates <= window[2]
  dfm <- estimate_dfm(
    data_mat[keep, , drop = FALSE],
    r = R_FACTORS,
    q = Q_DYNAMIC,
    p = P_LAGS,
    dates = dates[keep],
    covid_volatility = if (sample_name == "full") covid_volatility else NULL
  )
  strength <- diagnose_instrument_in_factor_space(
    dfm,
    instrument,
    dates[keep],
    p = P_LAGS,
    mp_var_idx = mpind
  )
  tibble::tibble(
    sample = sample_name,
    n_series = ncol(data_mat),
    n_months = sum(keep),
    n_innovations = strength$n_obs,
    xi_mp = strength$wald_mp,
    f_robust_mp = strength$f_robust_mp,
    max_companion_root = dfm$diagnostics$max_eigenvalue,
    stable = dfm$diagnostics$is_stable,
    bai_ng_ic2_r = bai_ng$r_hat$IC2
  )
}) |>
  dplyr::bind_rows()

comparison <- diagnostics |>
  dplyr::left_join(expected, by = "sample", suffix = c("", "_expected"))
if (any(comparison$n_innovations != comparison$n_innovations_expected) ||
    any(abs(comparison$xi_mp - comparison$xi_mp_expected) > 1e-8) ||
    any(abs(comparison$f_robust_mp - comparison$f_robust_mp_expected) > 1e-8) ||
    any(abs(comparison$max_companion_root - comparison$max_companion_root_expected) > 1e-10) ||
    any(comparison$stable != comparison$stable_expected) ||
    diagnostics$n_innovations[diagnostics$sample == "full"] != N_INNOVATIONS) {
  stop("The canonical production diagnostics do not reproduce the migration gate.")
}
readr::write_csv(diagnostics, file.path(out_dir, "production_spec_diagnostics.csv"))

point_dfm <- estimate_dfm(
  data_mat,
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_LAGS,
  dates = dates,
  covid_volatility = covid_volatility
)
point_irf <- compute_irf_dfm(
  point_dfm,
  instrument = instrument,
  h = HORIZON,
  mpind = mpind,
  normalize_value = NORMALIZE_VALUE,
  tcode = infer_tcode_from_varnames(colnames(data_mat)),
  ci_levels = CI_LEVELS,
  identification = "proxy",
  inference = "none"
)
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
# Under the production Lenza-Primiceri scale since 2026-09-17, z_bs_purif since
# 2026-09-26, and the Focus annual series at a fixed 12-month horizon, with
# theta-hat re-estimated on them, since 2026-10-03, and msci the MSCI
# Emerging Markets index, theta-hat re-estimated again, since 2026-10-12.
# With msci the MSCI Inc. share price the values were 0.0071747739108540751,
# 0.0077302048927632531, -1.6546048858122004 and 0.14584857519843694; with
# the "ano seguinte" series, 0.0072069426647632393, 0.00773053809800818,
# -2.4654264316584382 and 0.14142146175048584; under z_jk_bs_purif,
# 0.0070090429740256857, 0.0072900596216797665, -1.5019377453868872 and
# 0.12942378112688835.
expected_impacts <- c(
  0.005,
  0.0071060083672732288,
  0.0076213733592213331,
  -1.4253687768521437,
  0.1448646415797471
)
impact_smoke <- tibble::tibble(
  variable = headline,
  impact = point_irf$irf_point_matrix[match(headline, colnames(data_mat)), 1],
  expected = expected_impacts
)
if (max(abs(impact_smoke$impact - impact_smoke$expected)) > 1e-12 ||
    abs(impact_smoke$impact[impact_smoke$variable == MP_VAR] -
      NORMALIZE_VALUE) > 1e-12) {
  stop("The five required impact responses do not reproduce the expanded-sample gate.")
}
readr::write_csv(
  impact_smoke,
  file.path(out_dir, "production_spec_impact_smoke.csv")
)
