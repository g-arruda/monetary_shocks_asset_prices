# ===================================================================
# SDFM pipeline: panel -> factors -> identified IRFs. Chains estimate_dfm()
# (factor_estimation.R) and compute_irf_dfm() (impulse_response.R): under the
# production specification from the files (main_sdfm), or for one cell of a
# given window, dimension and instrument variant (run_stage2_cell). The
# Anderson-Rubin sets need R/identification/weak_iv_ar.R sourced as well.
# ===================================================================

#' Estimate the DFM and its impulse responses
#'
#' Reads the processed panel, infers transformation codes, resolves the
#' monetary-policy column, estimates the factor model and returns the
#' identified IRFs with their Anderson-Rubin sets. `"proxy"` (external
#' instrument) is the only identification branch.
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
#' @param inference `"ar"`, the production inference, or `"none"` for the point
#'   alone. See `compute_irf_dfm()`.
#' @param ar_nw_lags Newey-West truncation of the AR moment covariance.
#' @param covid_volatility COVID volatility scale of the factor VAR, passed to
#'   `estimate_dfm()`; the estimated production scale by default. NULL runs the
#'   untreated OLS factor VAR.
#'
#' @return List with the fitted DFM, IRFs, panel, transformations, and
#'   normalization.
#'
#' @examples
#' res <- main_sdfm(r = 5L, q = 5L, p = 4, shock_size_bps = 50,
#'                  mp_var = "yield_6m")
main_sdfm <- function(data_path = "data/processed/data_log_deseasonalized.csv",
                      instrument_path = "data/processed/instrument.csv",
                      r = 5L,
                      q = 5L,
                      p = 4L,
                      h = 48L,
                      mp_var = "yield_6m",
                      shock_size_bps = 50,
                      tcode = NULL,
                      ci_levels = c(0.68, 0.90),
                      identification = "proxy",
                      inference = "ar",
                      ar_nw_lags = 0L,
                      covid_volatility = read_covid_volatility(
                        "output/factors/covid_volatility_theta.csv"
                      )) {
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
    stop(
      "Variavel de politica monetaria '", mp_var,
      "' nao encontrada nos dados"
    )
  }

  # `yield_6m` is a decimal proportion (0.0975 = 9.75%): +50bp is 0.005
  # (registro/justificativa_uso_yield-6m.md)
  normalize_value <- shock_size_bps / 10000

  instrument <- readr::read_csv(instrument_path, show_col_types = FALSE)

  # The instrument trims the panel to their common months
  dfm_results <- estimate_dfm(
    data,
    r,
    q,
    p,
    dates = dates,
    instrument = instrument,
    covid_volatility = covid_volatility
  )

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


#' Run one DFM cell through the full IRF pipeline
#'
#' The instrument is passed to `estimate_dfm()`, where the temporal alignment
#' happens, and `compute_irf_dfm()` resolves instrument and dates from the DFM
#' object, as `main_sdfm()` does.
#'
#' @param data_mat Full panel matrix (no date column).
#' @param dates Dates aligned with `data_mat` rows.
#' @param inst_panel Wide instrument data.frame (`month` + one column per
#'   variant).
#' @param sample_window Date vector `c(start, end)`.
#' @param r,q,p DFM dimensions and VAR lag order.
#' @param instrument Variant column name in `inst_panel`.
#' @param mp_var Policy variable name.
#' @param h IRF horizon.
#' @param shock_bps Shock size in basis points.
#' @param tcode Transformation codes for the full panel.
#' @param ci_levels Confidence levels of the sets.
#' @param inference `"ar"` or `"none"`, passed through to `compute_irf_dfm()`;
#'   no default.
#' @param ar_nw_lags Newey-West truncation of the AR moment covariance.
#' @param covid_volatility COVID volatility scale of the factor VAR, passed to
#'   `estimate_dfm()`. **Required, with no default**: the treatment is
#'   production (`read_covid_volatility()`), and a default either way would
#'   silently decide for the caller which estimator a cell runs. A cell that
#'   publishes production numbers passes the production scale; a cell that
#'   reproduces a closed round, or that runs a pre-COVID window, passes NULL
#'   and says why. Pre-COVID cannot take it at all: every month of that
#'   window has `s_t = 1`, so the weighted fit *is* the unweighted one, and
#'   `estimate_dfm()` rejects a `covid_start` outside the residual months.
#'
#' @return List with `irf`, `var_names`, `tcode`, `mpind`, `normalize_value`,
#'   the cell keys and `dfm_max_eig`.
run_stage2_cell <- function(data_mat, dates, inst_panel, sample_window,
                            r, q, p, instrument, mp_var,
                            h, shock_bps, tcode, ci_levels,
                            inference, ar_nw_lags = 0L,
                            covid_volatility) {
  if (missing(covid_volatility)) {
    stop("run_stage2_cell: covid_volatility has no default. Pass ",
         "read_covid_volatility(<theta csv>) for a production cell, or NULL ",
         "for a pre-COVID window or a closed round, and say why ",
         "(notas/2026-09-17_volatilidade_covid_producao.md).")
  }
  in_window <- dates >= sample_window[1] & dates <= sample_window[2]

  # A data.frame trimmed by base subsetting: its row names travel into the
  # DFM object, and from there into the saved cell
  inst_df <- data.frame(
    month = inst_panel$month,
    shock = inst_panel[[instrument]]
  )
  inst_df <- inst_df[!is.na(inst_df$shock), ]

  # A misspelled name would otherwise normalize on NA and return NaN IRFs
  mpind <- match(mp_var, colnames(data_mat))
  if (is.na(mpind)) stop("mp_var '", mp_var, "' not found in panel")

  dfm <- estimate_dfm(
    data_mat[in_window, , drop = FALSE],
    r = r,
    q = q,
    p = p,
    dates = dates[in_window],
    instrument = inst_df,
    covid_volatility = covid_volatility
  )

  # Native units of the policy variable: yields are decimal proportions
  # (+50bp = 0.005), juros_selic is in percent (+50bp = 0.5)
  normalize_value <- if (mp_var == "juros_selic") {
    shock_bps / 100
  } else {
    shock_bps / 10000
  }

  irf <- compute_irf_dfm(
    dfm,
    h = h,
    mpind = mpind,
    normalize_value = normalize_value,
    tcode = tcode,
    ci_levels = ci_levels,
    inference = inference,
    ar_nw_lags = ar_nw_lags
  )

  list(
    irf = irf,
    var_names = colnames(data_mat),
    tcode = tcode,
    mpind = mpind,
    normalize_value = normalize_value,
    instrument = instrument,
    mp_var = mp_var,
    r = r,
    q = q,
    p = p,
    dfm_max_eig = dfm$diagnostics$max_eigenvalue
  )
}
