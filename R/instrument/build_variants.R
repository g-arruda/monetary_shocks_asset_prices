# ===================================================================
# Computational core of the Copom-day DI instrument. script/instrument.R
# keeps all I/O and calls build_instrument_variants() once.
#
# The three monthly variants are the construction layers of tab:first_stage:
#   z_bruto        raw Wed->Thu DI surprise at the target vertex;
#   z_bs_purif     + Bauer-Swanson (2023, eq. 7) pre-event orthogonalization;
#   z_jk_bs_purif  + Jarocinski-Karadi (2020) sign filter on the BS
#                  residuals (production).
#
# Monthly aggregation is Jarocinski-Karadi (2020, sec. II.A): m_t adds up the
# event surprises of month t and is zero in months without a meeting, as in
# Bauer-Swanson's loadhfmpdata.m. yield_6m is an end-of-month observation, so
# a surprise anywhere in month t is fully reflected in it.
# ===================================================================


#' Build the three monthly instrument variants of tab:first_stage
#'
#' @param inputs Named list of daily inputs, all tibbles with a `date`
#'   column: `di_panel`, `ibov_daily`, `ext_daily`, `brl_daily`,
#'   `focus_daily`; plus `copom_wed` (Date vector).
#' @param target_bd DI vertex in business days.
#' @param sample_start,sample_end Sample bounds.
#'
#' @return List with `monthly` (tibble: `month`, `z_bruto`, `z_bs_purif`,
#'   `z_jk_bs_purif`), `daily` (the valid Thursday panel with residuals and
#'   the mask) and `diag` (counts and R2 of the BS regressions).
#'
#' @examples
#' built <- build_instrument_variants(inputs, 126, as.Date("2012-03-01"),
#'                                    as.Date("2025-12-31"))
build_instrument_variants <- function(inputs, target_bd, sample_start,
                                      sample_end) {
  sample_days <- seq(sample_start, sample_end, by = "day")
  all_thursdays <- sample_days[lubridate::wday(sample_days) == 5]

  di_surprises <- build_thursday_surprises(
    inputs$di_panel,
    all_thursdays,
    target_bd = target_bd,
    min_bd = 10
  )

  ibov_returns <- inputs$ibov_daily |>
    dplyr::arrange(date) |>
    dplyr::transmute(date, r_ibov = 100 * (log(ibov) - log(dplyr::lag(ibov))))

  external_changes <- inputs$ext_daily |>
    dplyr::arrange(date) |>
    dplyr::transmute(
      date,
      r_sp500 = 100 * (log(sp500) - log(dplyr::lag(sp500))),
      d_vix = vix - dplyr::lag(vix),
      r_brent = 100 * (log(brent) - log(dplyr::lag(brent)))
    )

  # Pre-event predictors (Bauer-Swanson eq. 7 analogue): financial trends over
  # the 13 weeks (65 trading days) ending at the Wednesday close, i.e. strictly
  # predetermined at the announcement; Focus median revisions over ~4 weeks
  # (20 survey days), the analogue of the Blue Chip revision cadence. The DI
  # slope is hard-wired to 504bd - 63bd, so it does not move with target_bd.
  di_slope_daily <- inputs$di_panel |>
    dplyr::summarise(
      slope = 100 * (close_rate[which.min(abs(bdays - 504))] -
                       close_rate[which.min(abs(bdays - 63))]),
      .by = date
    ) |>
    dplyr::arrange(date)

  pre_event_inputs <- tibble::tribble(
    ~predictor,        ~daily,             ~column,          ~window, ~log_scale,
    "pre_ibov",        inputs$ibov_daily,  "ibov",           65,      TRUE,
    "pre_sp500",       inputs$ext_daily,   "sp500",          65,      TRUE,
    "pre_vix",         inputs$ext_daily,   "vix",            65,      FALSE,
    "pre_brent",       inputs$ext_daily,   "brent",          65,      TRUE,
    "pre_brl",         inputs$brl_daily,   "brl",            65,      TRUE,
    "pre_slope",       di_slope_daily,     "slope",          65,      FALSE,
    "pre_focus_ipca",  inputs$focus_daily, "focus_ipca12m",  20,      FALSE,
    "pre_focus_selic", inputs$focus_daily, "focus_selic_ny", 20,      FALSE
  )

  # Wednesday: the last close before the announcement
  pre_cutoff <- all_thursdays - 1

  pre_event <- pre_event_inputs |>
    dplyr::select(-predictor) |>
    purrr::pmap(\(daily, column, window, log_scale) {
      # Each series on its own calendar (Yahoo closes have scattered gaps)
      series <- daily |>
        dplyr::filter(!is.na(.data[[column]]))
      x <- series[[column]]
      change <- if (log_scale) {
        100 * (log(x) - log(dplyr::lag(x, window)))
      } else {
        x - dplyr::lag(x, window)
      }
      # Last observation on or before the cutoff; none yet -> NA
      last_obs <- findInterval(as.numeric(pre_cutoff), as.numeric(series$date))
      change[dplyr::na_if(last_obs, 0L)]
    }) |>
    purrr::set_names(pre_event_inputs$predictor) |>
    tibble::as_tibble() |>
    dplyr::mutate(date = all_thursdays, .before = 1)

  thursday_panel <- di_surprises |>
    dplyr::left_join(ibov_returns, by = "date") |>
    dplyr::left_join(external_changes, by = "date") |>
    dplyr::left_join(pre_event, by = "date") |>
    dplyr::mutate(
      copom_day = (date - 1) %in% inputs$copom_wed,
      trend = as.numeric(date - min(date)) / 365.25
    )

  # The same-session S&P, VIX and Brent changes enter no regression; a Thursday
  # without them is still dropped, because that is what defines the sample of
  # the BS regressions below.
  valid <- thursday_panel |>
    tidyr::drop_na(delta_di, r_ibov, r_sp500, d_vix, r_brent)

  # lm() would drop an incomplete row silently and move the regression sample
  n_missing <- colSums(is.na(valid[pre_event_inputs$predictor]))
  n_missing <- n_missing[n_missing > 0]
  if (length(n_missing) > 0) {
    stop(
      "NA in pre-event predictors on the valid panel: ",
      paste(sprintf("%s=%d", names(n_missing), n_missing), collapse = ", "),
      ". Check daily input coverage or rerun script/download.R."
    )
  }

  # Bauer-Swanson (2023) eq. 7: regress the surprise on PREDETERMINED news only
  # (financial trends + survey revisions + trend) and keep the residual.
  bs_formula <- ~ trend + pre_ibov + pre_sp500 + pre_vix + pre_brent +
    pre_brl + pre_slope + pre_focus_ipca + pre_focus_selic
  lm_di_bs <- lm(update(bs_formula, delta_di ~ .), data = valid)
  lm_ibov_bs <- lm(update(bs_formula, r_ibov ~ .), data = valid)

  # Jarocinski-Karadi sign filter on the BS residuals: a monetary shock moves
  # residual DI and residual Ibovespa in opposite directions; an information
  # shock moves them together and is zeroed out.
  valid <- valid |>
    dplyr::mutate(
      e_di_bs = residuals(lm_di_bs),
      e_ibov_bs = residuals(lm_ibov_bs),
      jk_monetary_bs = copom_day & sign(e_di_bs) * sign(e_ibov_bs) == -1,
      month = lubridate::floor_date(date, "month")
    )

  monthly_shocks <- valid |>
    dplyr::filter(copom_day) |>
    dplyr::summarise(
      z_bruto = sum(delta_di),
      z_bs_purif = sum(e_di_bs),
      z_jk_bs_purif = sum(e_di_bs[jk_monetary_bs]),
      .by = month
    )

  instruments <- tibble::tibble(
    month = seq(
      lubridate::floor_date(sample_start, "month"),
      lubridate::floor_date(sample_end, "month"),
      by = "month"
    )
  ) |>
    dplyr::left_join(monthly_shocks, by = "month") |>
    dplyr::mutate(
      dplyr::across(dplyr::starts_with("z_"), \(z) tidyr::replace_na(z, 0))
    )

  list(
    monthly = instruments,
    daily = valid,
    diag = list(
      target_bd = target_bd,
      n_thursdays = nrow(thursday_panel),
      n_valid = nrow(valid),
      n_copom = sum(valid$copom_day),
      n_jk_bs = sum(valid$jk_monetary_bs),
      r2_di_bs = summary(lm_di_bs)$r.squared,
      r2_ibov_bs = summary(lm_ibov_bs)$r.squared
    )
  )
}
