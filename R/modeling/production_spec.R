#' Return the single production specification
#'
#' @return List with canonical paths, panel composition, model dimensions,
#'   identification settings, sample windows, bootstrap, and horizons.
#'
#' @examples
#' spec <- production_spec()
production_spec <- function() {
  list(
    panel_name = "drop_setor_externo__eua__credito__imoveis",
    data_path = "data/processed/data_log_deseasonalized.csv",
    base_data_path = "data/processed/data_log_deseasonalized_base_106.csv",
    instrument_path = "data/processed/instrumentos_mensais.csv",
    legacy_instrument_path = "data/processed/instrument.csv",
    model_output = "output/irf/irf_model_alessi_r5q5.pdf",
    coherence_cell_path = "output/irf/irf_coherence_cell.rds",
    r = 5L,
    q = 5L,
    p = 4L,
    factor_var_lag_selection = list(
      criterion = "aic",
      deterministic = "trend",
      max_lag = 12L,
      common_sample = 141L,
      selected_aic = 4L,
      selected_bic = 2L,
      aic_at_selected = 8.07320689732586
    ),
    var_benchmark = list(
      label = "ibc5_fx_cds_level_trend_p2",
      vars = c("ibc_br", "price_ipca", "yield_6m", "cambio_usd", "cds_5y"),
      deterministic = "trend",
      lag_criterion = "aic",
      p = 2L,
      max_lag = 12L,
      ar_levels = c(0.68, 0.90),
      ar_horizon = 36L,
      nw_lags = 0L
    ),
    instrument = "z_jk_bs_purif",
    mp_var = "yield_6m",
    shock_bps = 50,
    normalize_value = 0.005,
    sample = as.Date(c("2013-01-01", "2025-09-01")),
    pre_covid_sample = as.Date(c("2013-01-01", "2019-12-01")),
    event_sample = as.Date(c("2013-01-01", "2025-12-31")),
    n_months = 153L,
    n_series = 111L,
    n_innovations = 149L,
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
      "expect_focus_cambio_ny"
    ),
    required_series = c(
      "yield_6m", "fiscal_dbgg", "fiscal_dlsp", "fiscal_primary_balance",
      "expect_focus_ipca12m", "expect_focus_selic_ny", "expect_focus_pib_ny",
      "expect_focus_cambio_ny"
    ),
    excluded_series = c(
      "juros_cdi", "asset_mlcx", "external_current_account_gdp",
      "external_exports", "external_imports", "external_reserves", "us_dgs2",
      "us_dgs10", "us_fedfunds", "us_dtwexbgs", "asset_sp500_yahoo",
      "credit_default_rate", "credit_average_rate", "housing_ivgr"
    )
  )
}
