# ===================================================================
# Computational core of the Copom-day DI instrument. script/instrument.R
# keeps all I/O and calls build_instrument_variants() once.
#
# The three monthly variants are the construction layers of tab:first_stage:
#   z_bruto        raw DI surprise at the target vertex, from the Wednesday
#                  close to the first DI session after the announcement;
#   z_bs_purif     + Bauer-Swanson (2023, eq. 7) pre-event orthogonalization
#                  (production);
#   z_jk_bs_purif  + Jarocinski-Karadi (2020) sign filter on the BS
#                  residuals.
#
# The events are the Copom meetings with a measured surprise. A meeting on
# the eve of a Brazilian holiday has a window to Friday, which takes in more
# news, and enters only under holiday_windows = TRUE.
#
# The BS regressions run on the Copom events alone, with a constant and no
# trend, as their Table 3 does with the FOMC months (table_3.m). Their
# predictors are those of Table 3 that Brazil has a counterpart for
# (constructomittedvars.m): the 13-week trends in the stock market (the
# Ibovespa for the S&P 500), in the slope of the curve and in commodities
# (Brent), and the macroeconomic news with a public survey behind it -- IPCA
# and GDP surprises, the acceleration of core inflation and the expected next
# IPCA. Labor market news has no survey covering the sample and BBK no
# Brazilian analogue; both are left out. The 13-week S&P 500 and VIX trends
# are added as the external conditions a small open economy responds to.
#
# Monthly aggregation is Jarocinski-Karadi (2020, sec. II.A): m_t adds up the
# event surprises of month t and is zero in months without a meeting, as in
# Bauer-Swanson's loadhfmpdata.m. yield_6m is an end-of-month observation, so
# a surprise anywhere in month t is fully reflected in it.
# ===================================================================


#' Build the three monthly instrument variants of tab:first_stage
#'
#' @param inputs Named list of daily inputs, all tibbles with a `date`
#'   column: `di_panel`, `ibov_daily`, `ext_daily`, `focus_macro` (Focus
#'   medians by `indicator`, survey `date` and `reference` period); plus
#'   `macro_released` (released values
#'   by `indicator` and `reference`, GDP as first released) and `copom_wed`
#'   (Date vector, starting before the sample so that its first meeting has a
#'   predecessor).
#' @param target_bd DI vertex in business days.
#' @param sample_start,sample_end Sample bounds.
#' @param holiday_windows TRUE to take in the meetings whose Thursday is a
#'   Brazilian holiday, with the window to the next DI session (the
#'   sensitivity of the advisor's e-mail of 2026-10-17); FALSE leaves them
#'   out, and their months at zero. No default: production passes FALSE.
#'
#' @return List with `monthly` (tibble: `month`, `z_bruto`, `z_bs_purif`,
#'   `z_jk_bs_purif`), `daily` (the Copom events, the sample of the BS
#'   regressions: `wednesday`, `date` the first DI session after the
#'   announcement, `long_window`, the surprises, residuals and the mask),
#'   `bs_fits` (the two BS `lm` fits, `delta_di` and `r_ibov`) and `diag`
#'   (counts and R2 of the BS regressions).
#'
#' @examples
#' built <- build_instrument_variants(inputs, 126, as.Date("2012-03-01"),
#'                                    as.Date("2025-12-31"),
#'                                    holiday_windows = FALSE)
build_instrument_variants <- function(inputs, target_bd, sample_start,
                                      sample_end, holiday_windows) {
  # The event's window runs from the Wednesday close, the last before the
  # announcement, to the first DI session after it: the Thursday, or the
  # Friday when Thursday is a Brazilian holiday. Those longer windows take in
  # more news and enter only when asked for.
  di_sessions <- sort(unique(inputs$di_panel$date))
  events <- tibble::tibble(wednesday = inputs$copom_wed) |>
    dplyr::filter(wednesday >= sample_start, wednesday <= sample_end) |>
    dplyr::mutate(
      date = di_sessions[findInterval(as.numeric(wednesday), as.numeric(di_sessions)) + 1L],
      long_window = date != wednesday + 1L
    ) |>
    dplyr::filter(holiday_windows | !long_window)

  di_surprises <- build_event_surprises(
    inputs$di_panel,
    events$wednesday,
    events$date,
    target_bd = target_bd,
    min_bd = 10
  )

  # The Ibovespa leg of the JK mask over the same window as the DI
  ibov_close <- \(day) inputs$ibov_daily$ibov[match(day, inputs$ibov_daily$date)]

  # Pre-event predictors: financial trends over the 13 weeks (65 trading days)
  # ending at the Wednesday close, BS's 3-month changes (sp5003mchg in
  # constructomittedvars.m), strictly predetermined at the announcement. The
  # DI slope is hard-wired to 504bd - 63bd, so it does not move with
  # target_bd.
  di_slope_daily <- inputs$di_panel |>
    dplyr::summarise(
      slope = 100 * (close_rate[which.min(abs(bdays - 504))] -
                       close_rate[which.min(abs(bdays - 63))]),
      .by = date
    ) |>
    dplyr::arrange(date)

  pre_event_inputs <- tibble::tribble(
    ~predictor,  ~daily,            ~column, ~log_scale,
    "pre_ibov",  inputs$ibov_daily, "ibov",  TRUE,
    "pre_sp500", inputs$ext_daily,  "sp500", TRUE,
    "pre_vix",   inputs$ext_daily,  "vix",   FALSE,
    "pre_brent", inputs$ext_daily,  "brent", TRUE,
    "pre_slope", di_slope_daily,    "slope", FALSE
  )

  pre_event <- pre_event_inputs |>
    dplyr::select(-predictor) |>
    purrr::pmap(\(daily, column, log_scale) {
      # Each series on its own calendar (Yahoo closes have scattered gaps)
      series <- daily |>
        dplyr::filter(!is.na(.data[[column]]))
      x <- series[[column]]
      change <- if (log_scale) {
        100 * (log(x) - log(dplyr::lag(x, 65)))
      } else {
        x - dplyr::lag(x, 65)
      }
      # Last observation on or before the Wednesday close; none yet -> NA
      last_obs <- findInterval(as.numeric(events$wednesday), as.numeric(series$date))
      change[dplyr::na_if(last_obs, 0L)]
    }) |>
    purrr::set_names(pre_event_inputs$predictor) |>
    tibble::as_tibble()

  events <- events |>
    dplyr::mutate(
      delta_di = di_surprises$delta_di,
      r_ibov = 100 * (log(ibov_close(date)) - log(ibov_close(wednesday)))
    ) |>
    dplyr::bind_cols(pre_event)

  # Macroeconomic news of BS Table 3, predetermined at the Wednesday close. The
  # Focus panel stops surveying a reference period the day before its release,
  # so a release is out by Wednesday W iff its last survey is before W (BS
  # count a release on the FOMC day itself, mmsdy <= mpdy). A release is news
  # for the first meeting after it: last survey in [W_{k-1}, W_k). The
  # surprise is the release minus the median of that last survey.
  meetings <- tibble::tibble(
    wednesday = inputs$copom_wed,
    previous_wednesday = dplyr::lag(inputs$copom_wed)
  )

  survey_ends <- inputs$focus_macro |>
    dplyr::slice_max(date, n = 1, by = c(indicator, reference)) |>
    dplyr::select(indicator, reference, last_survey = date, expected = median)

  # Two releases between meetings add up; a meeting with no GDP release since
  # the previous one has zero GDP news, as in BS
  release_news <- survey_ends |>
    dplyr::inner_join(
      inputs$macro_released,
      by = c("indicator", "reference")
    ) |>
    dplyr::inner_join(
      meetings,
      by = dplyr::join_by(
        between(last_survey, previous_wednesday, wednesday, bounds = "[)")
      )
    ) |>
    dplyr::summarise(
      surprise = sum(value - expected),
      .by = c(indicator, wednesday)
    ) |>
    tidyr::pivot_wider(
      names_from = indicator,
      names_prefix = "news_",
      values_from = surprise,
      values_fill = 0
    )

  # Focus median, as of the Wednesday, for the next IPCA still to be released
  ipca_expected <- survey_ends |>
    dplyr::filter(indicator == "ipca") |>
    dplyr::inner_join(
      meetings,
      by = dplyr::join_by(last_survey >= wednesday)
    ) |>
    dplyr::slice_min(reference, n = 1, by = wednesday) |>
    dplyr::inner_join(
      inputs$focus_macro,
      by = dplyr::join_by(indicator, reference, closest(wednesday >= date))
    ) |>
    dplyr::select(wednesday, news_ipca_expected = median)

  # BS's acceleration of core inflation, t the month of the meeting:
  # ((c_{t-2} - c_{t-8}) - (c_{t-8} - c_{t-14})) x 200, c the log EX0 index
  core_acceleration <- inputs$macro_released |>
    dplyr::filter(indicator == "ipca_ex0") |>
    dplyr::arrange(reference) |>
    dplyr::mutate(log_core = cumsum(log1p(value / 100))) |>
    dplyr::transmute(
      meeting_month = reference,
      news_core_accel = 200 * (
        (dplyr::lag(log_core, 2) - dplyr::lag(log_core, 8)) -
          (dplyr::lag(log_core, 8) - dplyr::lag(log_core, 14))
      )
    )

  events <- events |>
    dplyr::left_join(release_news, by = "wednesday") |>
    dplyr::left_join(ipca_expected, by = "wednesday") |>
    dplyr::mutate(meeting_month = lubridate::floor_date(wednesday, "month")) |>
    dplyr::left_join(core_acceleration, by = "meeting_month")

  # lm() would drop an incomplete row silently and move the regression sample;
  # a meeting without a measured surprise is missing, never zero
  n_missing <- events |>
    dplyr::select(delta_di, r_ibov, dplyr::starts_with(c("pre_", "news_"))) |>
    is.na() |>
    colSums()
  n_missing <- n_missing[n_missing > 0]
  if (length(n_missing) > 0) {
    stop(
      "NA in the surprises or pre-event predictors on the Copom events: ",
      paste(sprintf("%s=%d", names(n_missing), n_missing), collapse = ", "),
      ". Check input coverage or rerun script/download.R and ",
      "script/download_macro_news.R."
    )
  }

  # Bauer-Swanson (2023) Table 3: regress the surprise on PREDETERMINED news
  # only (financial trends and macroeconomic news) and keep the residual.
  bs_formula <- ~ pre_ibov + pre_sp500 + pre_vix + pre_brent + pre_slope +
    news_ipca + news_gdp + news_core_accel + news_ipca_expected
  lm_di_bs <- lm(update(bs_formula, delta_di ~ .), data = events)
  lm_ibov_bs <- lm(update(bs_formula, r_ibov ~ .), data = events)

  # Jarocinski-Karadi sign filter on the BS residuals: a monetary shock moves
  # residual DI and residual Ibovespa in opposite directions; an information
  # shock moves them together and is zeroed out.
  events <- events |>
    dplyr::mutate(
      e_di_bs = residuals(lm_di_bs),
      e_ibov_bs = residuals(lm_ibov_bs),
      jk_monetary_bs = sign(e_di_bs) * sign(e_ibov_bs) == -1,
      month = lubridate::floor_date(date, "month")
    )

  monthly_shocks <- events |>
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
    daily = events,
    bs_fits = list(delta_di = lm_di_bs, r_ibov = lm_ibov_bs),
    diag = list(
      target_bd = target_bd,
      n_copom = nrow(events),
      n_long_window = sum(events$long_window),
      n_jk_bs = sum(events$jk_monetary_bs),
      r2_di_bs = summary(lm_di_bs)$r.squared,
      r2_ibov_bs = summary(lm_ibov_bs)$r.squared
    )
  )
}
