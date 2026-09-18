#' Return the production specification
#'
#' Carries only what two or more scripts read: canonical paths, model
#' dimensions, identification and inference settings, sample windows and the
#' panel composition. A value read by a single script lives in that script.
#'
#' @return Named list.
#'
#' @examples
#' spec <- production_spec()
production_spec <- function() {
  list(
    data_path = "data/processed/data_log_deseasonalized.csv",
    base_data_path = "data/processed/data_log_deseasonalized_base_106.csv",
    instrument_path = "data/processed/instrumentos_mensais.csv",
    legacy_instrument_path = "data/processed/instrument.csv",
    model_output = "output/irf/irf_model_alessi_r5q5.pdf",
    bai_ng_output = "output/factors/production_bai_ng_bll_surface.csv",
    coherence_cell_path = "output/irf/irf_coherence_cell.rds",
    r = 5L,
    q = 5L,
    p = 4L,
    horizon = 48L,
    instrument = "z_jk_bs_purif",
    mp_var = "yield_6m",
    shock_bps = 50,
    normalize_value = 0.005,
    # Lenza-Primiceri (2022) COVID volatility in the factor VAR, production since
    # 2026-09-17. theta is the maximizer of (B5) at (r, p) = (5, 4), carried as
    # literals because output/ does not ship with the replication package;
    # script/covid_volatility_theta.R produced them and
    # script/validation/validate_production_spec.R re-derives them.
    covid_volatility = list(
      covid_start = as.Date("2020-03-01"),
      theta = c(s0 = 6.611428527060552, s1 = 12.468337921789994,
                s2 = 1.760352430309222, rho = 0.9439261800636236),
      innovations = "standardized"
    ),
    # The author's decisions of 2026-09-14 that obtain theta; the floor s >= 1
    # is what makes the maximum exist
    # (notas/2026-09-14_estimacao_theta_volatilidade_covid.md).
    covid_volatility_design = list(
      covid_start = as.Date("2020-03-01"),
      theta_lower = c(s0 = 1, s1 = 1, s2 = 1, rho = 0),
      theta_upper = c(s0 = Inf, s1 = Inf, s2 = Inf, rho = 1),
      innovations = "standardized"
    ),
    # Inference of the DFM since 2026-09-08: Anderson-Rubin sets by test
    # inversion.
    inference = "ar",
    ci_levels = c(0.68, 0.90),
    ar_nw_lags = 0L,
    sample = as.Date(c("2012-03-01", "2025-12-01")),
    pre_covid_sample = as.Date(c("2012-03-01", "2019-12-01")),
    event_sample = as.Date(c("2012-03-01", "2025-12-31")),
    n_series = 115L,
    base_series_removed = c("juros_cdi", "asset_mlcx"),
    production_series_added = c(
      "fiscal_dbgg",
      "fiscal_dlsp",
      "fiscal_primary_balance",
      "expect_focus_ipca12m",
      "expect_focus_selic_ny",
      "expect_focus_pib_ny",
      "expect_focus_cambio_ny",
      "dlsp_exchange_adjustment",
      "expect_focus_fiscal_dlsp_ny",
      "expect_focus_fiscal_primary_balance_ny",
      "expect_focus_fiscal_nominal_balance_ny"
    ),
    var_benchmark = list(
      label = "ibc5_fx_cds_level_trend_p2",
      vars = c("ibc_br", "price_ipca", "yield_6m", "cambio_usd", "cds_5y"),
      deterministic = "trend",
      p = 2L,
      max_lag = 12L,
      ar_levels = c(0.68, 0.90),
      ar_horizon = 36L,
      nw_lags = 0L,
      sample = as.Date(c("2013-01-01", "2025-09-01"))
    )
  )
}
