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
#'
#' @return List with `monthly` (tibble: `month`, `z_bruto`, `z_bs_purif`,
#'   `z_jk_bs_purif`), `daily` (the valid post-Copom Thursdays, the sample of
#'   the BS regressions, with residuals and the mask), `bs_fits` (the two BS
#'   `lm` fits, `delta_di` and `r_ibov`) and `diag` (counts and R2 of the BS
#'   regressions).
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

  # Wednesday: the last close before the announcement
  pre_cutoff <- all_thursdays - 1

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
    dplyr::mutate(copom_day = (date - 1) %in% inputs$copom_wed)

  # The same-session S&P, VIX and Brent changes enter no regression; a Thursday
  # without them is still dropped, because that is what fixes the 102 events
  # of the BS regressions below.
  valid <- thursday_panel |>
    tidyr::drop_na(delta_di, r_ibov, r_sp500, d_vix, r_brent)

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

  events <- valid |>
    dplyr::filter(copom_day) |>
    dplyr::mutate(wednesday = date - 1) |>
    dplyr::left_join(release_news, by = "wednesday") |>
    dplyr::left_join(ipca_expected, by = "wednesday") |>
    dplyr::mutate(meeting_month = lubridate::floor_date(wednesday, "month")) |>
    dplyr::left_join(core_acceleration, by = "meeting_month")

  # lm() would drop an incomplete row silently and move the regression sample
  n_missing <- events |>
    dplyr::select(dplyr::starts_with(c("pre_", "news_"))) |>
    is.na() |>
    colSums()
  n_missing <- n_missing[n_missing > 0]
  if (length(n_missing) > 0) {
    stop(
      "NA in pre-event predictors on the Copom events: ",
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
      n_thursdays = nrow(thursday_panel),
      n_valid = nrow(valid),
      n_copom = nrow(events),
      n_jk_bs = sum(events$jk_monetary_bs),
      r2_di_bs = summary(lm_di_bs)$r.squared,
      r2_ibov_bs = summary(lm_ibov_bs)$r.squared
    )
  )
}
