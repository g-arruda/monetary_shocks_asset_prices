#' Return the single production specification
#'
#' @return List with canonical paths, panel composition, model dimensions,
#'   identification settings, sample windows, bootstrap, and horizons.
#'
#' @examples
#' spec <- production_spec()
production_spec <- function() {
  list(
    panel_name = "drop_setor_externo__eua__credito__imoveis_fiscal_expectations",
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
    factor_var_lag_selection = list(
      decision = "inherited_from_2013-01_2025-09_vintage",
      criterion = "reported_but_not_automatic",
      deterministic = "trend",
      max_lag = 12L,
      common_sample = 154L,
      selected_aic = 4L,
      selected_bic = 2L,
      aic_at_production = 8.231266782137459
    ),
    var_benchmark = list(
      label = "ibc5_fx_cds_level_trend_p2",
      status = "frozen_2013-01_2025-09_vintage",
      vars = c("ibc_br", "price_ipca", "yield_6m", "cambio_usd", "cds_5y"),
      deterministic = "trend",
      lag_criterion = "aic",
      p = 2L,
      max_lag = 12L,
      ar_levels = c(0.68, 0.90),
      ar_horizon = 36L,
      nw_lags = 0L,
      sample = as.Date(c("2013-01-01", "2025-09-01")),
      n_months = 153L
    ),
    instrument = "z_jk_bs_purif",
    mp_var = "yield_6m",
    shock_bps = 50,
    normalize_value = 0.005,
    # Operational inference of the DFM since 2026-09-08: Anderson-Rubin sets by
    # test inversion, in place of the wild bootstrap. `nboot` and
    # `bootstrap_seed` below stay in the spec because the bootstrap remains a
    # computable comparison object (script/ar_bands.R, irf_spec_stage2.R).
    inference = "ar",
    ar_levels = c(0.68, 0.90),
    ar_nw_lags = 0L,
    ar_bands_path = "output/irf/ar_bands.csv",
    sample = as.Date(c("2012-03-01", "2025-12-01")),
    pre_covid_sample = as.Date(c("2012-03-01", "2019-12-01")),
    event_sample = as.Date(c("2012-03-01", "2025-12-31")),
    instrument_load_start = as.Date("2011-09-01"),
    n_months = 166L,
    n_series = 115L,
    n_innovations = 162L,
    nboot = 800L,
    bootstrap_seed = 123L,
    ci_levels = c(0.68, 0.90),
    horizon = 48L,
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
    required_series = c(
      "yield_6m", "fiscal_dbgg", "fiscal_dlsp", "fiscal_primary_balance",
      "expect_focus_ipca12m", "expect_focus_selic_ny", "expect_focus_pib_ny",
      "expect_focus_cambio_ny", "dlsp_exchange_adjustment",
      "expect_focus_fiscal_dlsp_ny", "expect_focus_fiscal_primary_balance_ny",
      "expect_focus_fiscal_nominal_balance_ny"
    ),
    excluded_series = c(
      "juros_cdi", "asset_mlcx", "external_current_account_gdp",
      "external_exports", "external_imports", "external_reserves", "us_dgs2",
      "us_dgs10", "us_fedfunds", "us_dtwexbgs", "asset_sp500_yahoo",
      "credit_default_rate", "credit_average_rate", "housing_ivgr"
    )
  )
}
