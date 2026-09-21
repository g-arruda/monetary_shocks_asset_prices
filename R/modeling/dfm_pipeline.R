# ===================================================================
# PIPELINE DO SDFM: painel -> fatores -> IRFs identificadas
# Encadeia estimate_dfm() (factor_estimation.R) e compute_irf_dfm()
# (impulse_response.R) sob a especificação de produção.
# Requer: R/modeling/factor_estimation.R, R/modeling/impulse_response.R.
# ===================================================================

#' Estimate the DFM and its impulse responses
#'
#' Reads the processed panel, infers transformation codes, resolves the
#' monetary-policy column, estimates the factor model and returns the
#' identified IRFs with their Anderson-Rubin sets.
#'
#' `"proxy"` (external instrument) is the only identification branch. The
#' heteroskedasticity and non-Gaussian branches were abandoned on 2026-08-17.
#' Their negative results remain documented under `arquivo/`.
#'
#' Every default is the production value, written here: the 115-series panel of
#' 2012-03--2025-12, `(r, q, p) = (5, 5, 4)`, a +50bp shock normalized on
#' `yield_6m` and the Anderson-Rubin sets. `covid_volatility` is the exception,
#' because theta is estimated and not decided: its default reads the CSV that
#' `script/covid_volatility_theta.R` writes.
#'
#' @param data_path Processed panel CSV.
#' @param instrument_path Single-column production instrument CSV.
#' @param r Number of static factors.
#' @param q Number of dynamic shocks.
#' @param p Factor-VAR lag order.
#' @param h Maximum impulse-response horizon.
#' @param mp_var Monetary-policy normalization variable (column name).
#' @param shock_size_bps Impact normalization in basis points.
#' @param tcode Optional transformation-code vector; inferred from the column
#'   names when NULL.
#' @param ci_levels Confidence levels.
#' @param identification Identification branch; `"proxy"` is the only one.
#' @param inference `"ar"`, the production inference since 2026-09-08, or
#'   `"none"` for the point alone. See `compute_irf_dfm()`.
#' @param ar_nw_lags Newey-West truncation of the AR moment covariance.
#' @param covid_volatility COVID volatility scale of the factor VAR, passed to
#'   `estimate_dfm()`; the estimated production scale by default, which is
#'   production since 2026-09-17. NULL runs the untreated OLS factor VAR.
#'
#' @return List with the fitted DFM, IRFs, panel, transformations, and
#'   normalization.
#'
#' @examples
#' res <- main_sdfm(r = 5L, q = 5L, p = 4, shock_size_bps = 50,
#'                  mp_var = "yield_6m")
main_sdfm <- function(data_path = "data/processed/data_log_deseasonalized.csv",
                      instrument_path = "data/processed/instrument.csv",
                      r = 5L, q = 5L, p = 4L,
                      h = 48L,
                      mp_var = "yield_6m", shock_size_bps = 50,
                      tcode = NULL, ci_levels = c(0.68, 0.90),
                      identification = "proxy",
                      inference = "ar",
                      ar_nw_lags = 0L,
                      covid_volatility = read_covid_volatility(
                        "output/factors/covid_volatility_theta.csv")) {

  identification <- match.arg(identification)

  raw_data <- readr::read_csv(data_path, show_col_types = FALSE) |>
    tidyr::drop_na()
  dates <- as.Date(raw_data$ref.date)
  data <- raw_data |>
    dplyr::select(-ref.date) |>
    as.matrix()

  if (is.null(tcode)) {
    tcode <- infer_tcode_from_varnames(colnames(data))
  }

  # A misspelled name would otherwise normalize on NA and return NaN IRFs
  mpind <- match(mp_var, colnames(data))
  if (is.na(mpind)) {
    stop("Variavel de politica monetaria '", mp_var, "' nao encontrada nos dados")
  }

  # `yield_6m` is a decimal proportion (0.0975 = 9.75%): +50bp is 0.005
  # (registro/justificativa_uso_yield-6m.md)
  normalize_value <- shock_size_bps / 10000

  instrument <- readr::read_csv(instrument_path, show_col_types = FALSE)

  # The instrument trims the panel to their common months
  dfm_results <- estimate_dfm(data, r, q, p, dates = dates, instrument = instrument,
                              covid_volatility = covid_volatility)

  irf_results <- compute_irf_dfm(
    dfm_results,
    h = h,
    mpind = mpind,
    normalize_value = normalize_value,
    tcode = tcode,
    ci_levels = ci_levels,
    identification = identification,
    inference = inference,
    ar_nw_lags = ar_nw_lags
  )

  list(
    model = dfm_results,
    irfs = irf_results,
    data = data,
    tcode = tcode,
    mpind = mpind,
    normalize_value = normalize_value,
    identification = identification
  )
}
