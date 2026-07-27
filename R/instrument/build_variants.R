# ===================================================================
# Computational core of the Copom-day DI instrument, extracted from
# script/instrument.R on 2026-07-27 so the two construction choices
# that were previously hard-coded — the DI vertex and the monthly
# aggregation scheme — can be swept without duplicating the chain.
#
# script/instrument.R keeps all I/O, messages and diagnostics and
# calls build_instrument_variants() once with the production
# parameters; script/instrument_construction_sweep.R calls it many
# times in memory and writes nothing.
#
# Fidelity note. The two aggregation schemes come from different
# papers and are NOT interchangeable defaults:
#
#  - "sum" is Jarocinski-Karadi (2020, sec. II.A): "To construct m_t
#    we add up the intraday surprises occurring in month t on the
#    days with FOMC announcements. Note that m_t is zero in the
#    months with no FOMC announcements." Same convention in
#    Bauer-Swanson's own code (loadhfmpdata.m). This is production.
#
#  - "gk" is Gertler-Karadi (2015, fn. 11), second of the two
#    equivalent formulations they give: "we can first create a
#    cumulative daily surprise series by cumulating all FOMC day
#    surprises ..., then, second, we can take monthly averages of
#    these series, and, third, obtain monthly average surprises as
#    the first difference of this series."
#
#    GK state their own motivation conditionally, and the condition
#    does not hold here: "as we use monthly average rates (not end
#    of the month rates) for our monetary policy indicators, a
#    surprise that happens at the end of a month can be expected to
#    have a smaller influence on the monthly average rate than a
#    surprise coming at the beginning of the month". The policy
#    indicator of this project, yield_6m, is an END-OF-MONTH
#    observation (script/download.R:49-53 takes slice_tail(n = 1)),
#    for which a surprise anywhere in month t is already fully
#    reflected — which is what "sum" assumes. So "gk" is offered as
#    robustness, not as a candidate default.
#
#    Two consequences worth stating where the numbers are read:
#    (i) under "gk" the months with no meeting are no longer zero,
#    so the JK/BS "zero in months without an announcement" property
#    is lost; (ii) splitting each surprise between t and t+1 induces
#    an MA(1), so xi_mp for a "gk" instrument should be read with
#    nw_lags >= 1 (see compute_factor_space_wald).
# ===================================================================


# ---- Monthly aggregation schemes ------------------------------

#' Sum of event-day values within the calendar month (Jarocinski-Karadi).
#'
#' @param df Daily event panel; needs `month`, `copom_day` and `value_col`.
#' @param value_col Name of the column holding the surprise.
#' @param keep_mask Logical vector, same length as `df`: events to keep.
#' @param monthly_grid Tibble with the complete `month` column.
#' @return Tibble `month`, `shock`.
agg_monthly_sum <- function(df, value_col, keep_mask, monthly_grid) {
  df |>
    dplyr::mutate(val = ifelse(keep_mask, .data[[value_col]], 0)) |>
    dplyr::group_by(month) |>
    dplyr::summarise(shock = sum(val[copom_day], na.rm = TRUE),
                     .groups = "drop")
}

#' Position-weighted monthly aggregation (Gertler-Karadi 2015, fn. 11).
#'
#' Cumulates the kept event surprises into a daily step level over the
#' calendar, averages that level within each month, and first-differences.
#' The daily calendar is extended one month back so the difference is
#' defined for the first month of the sample.
#'
#' @inheritParams agg_monthly_sum
#' @return Tibble `month`, `shock`.
agg_monthly_gk <- function(df, value_col, keep_mask, monthly_grid) {
  ev <- df |>
    dplyr::mutate(val = ifelse(keep_mask, .data[[value_col]], 0)) |>
    dplyr::filter(copom_day) |>
    dplyr::transmute(date, val = tidyr::replace_na(val, 0))

  first_month <- min(monthly_grid$month)
  last_month  <- max(monthly_grid$month)
  cal <- tibble::tibble(
    date = seq(seq(first_month, by = "-1 month", length.out = 2)[2],
               lubridate::ceiling_date(last_month, "month") - 1,
               by = "day"))

  cal |>
    dplyr::left_join(
      ev |> dplyr::group_by(date) |>
        dplyr::summarise(val = sum(val), .groups = "drop"),
      by = "date") |>
    dplyr::mutate(val   = tidyr::replace_na(val, 0),
                  level = cumsum(val),
                  month = lubridate::floor_date(date, "month")) |>
    dplyr::group_by(month) |>
    dplyr::summarise(avg_level = mean(level), .groups = "drop") |>
    dplyr::arrange(month) |>
    dplyr::mutate(shock = avg_level - dplyr::lag(avg_level)) |>
    dplyr::filter(!is.na(shock)) |>
    dplyr::select(month, shock)
}

#' Dispatch an aggregation scheme by name.
make_aggregator <- function(scheme = c("sum", "gk")) {
  scheme <- match.arg(scheme)
  switch(scheme, sum = agg_monthly_sum, gk = agg_monthly_gk)
}


# ---- The build chain ------------------------------------------

#' Build the ten monthly GK-family instrument variants.
#'
#' @param inputs Named list of daily inputs, all tibbles with a `date`
#'   column: `di_panel`, `ibov_daily`, `ext_daily`, `brl_daily`,
#'   `focus_daily`, `dgs2_daily`; plus `copom_wed` and `fomc_dates`
#'   (Date vectors).
#' @param target_bd DI vertex in business days. Production: 126 (~6m).
#' @param agg Aggregation scheme, "sum" (Jarocinski-Karadi, production)
#'   or "gk" (Gertler-Karadi fn. 11). See the header note.
#' @param sample_start,sample_end Sample bounds.
#' @param strict If TRUE (production), abort when a pre-event predictor
#'   is NA on the valid panel. The sweep sets FALSE so a vertex whose
#'   surprise coverage differs cannot kill the whole grid; the returned
#'   diagnostics report it instead.
#'
#' @return List with `monthly` (tibble: `month` + the ten `z_*` columns),
#'   `daily` (the valid Thursday panel with residuals and masks) and
#'   `diag` (counts, R2 of the BS regressions, realized DI maturities).
build_instrument_variants <- function(inputs,
                                      target_bd    = 126,
                                      agg          = "sum",
                                      sample_start = as.Date("2013-01-01"),
                                      sample_end   = as.Date("2025-12-31"),
                                      strict       = TRUE) {

  di_panel    <- inputs$di_panel
  ibov_daily  <- inputs$ibov_daily
  ext_daily   <- inputs$ext_daily
  brl_daily   <- inputs$brl_daily
  focus_daily <- inputs$focus_daily
  dgs2_daily  <- inputs$dgs2_daily
  copom_wed   <- inputs$copom_wed
  fomc_dates  <- inputs$fomc_dates %||% as.Date(character(0))

  agg_fn <- make_aggregator(agg)

  # ---- Thursday panel ----------------------------------------

  all_thursdays <- seq(sample_start, sample_end, by = "day")
  all_thursdays <- all_thursdays[lubridate::wday(all_thursdays) == 5]   # Thu = 5

  di_surprises <- build_thursday_surprises(di_panel, all_thursdays,
                                           target_bd = target_bd, min_bd = 10)

  log_ret_100 <- function(x) 100 * (log(x) - log(dplyr::lag(x)))

  ibov_d <- ibov_daily |>
    dplyr::arrange(date) |>
    dplyr::mutate(r_ibov = log_ret_100(ibov)) |>
    dplyr::select(date, r_ibov)

  ext_d <- ext_daily |>
    dplyr::arrange(date) |>
    dplyr::mutate(
      r_sp500 = log_ret_100(sp500),
      d_vix   = vix - dplyr::lag(vix),
      r_brent = log_ret_100(brent)
    ) |>
    dplyr::select(date, r_sp500, d_vix, r_brent)

  # For each Thursday we want the SAME-session change: Thu close vs. Wed close.
  # For Ibov/external factors, daily log-return uses the immediately-prior available
  # trading day, which in normal weeks is Wed. If Wed is a holiday for that market,
  # the row stays (using previous available close) and the downstream Wed->Thu DI
  # would be NA via the contract matcher, so the whole Thursday gets dropped together.

  # Contemporaneous UST 2y change (bps) on the Treasury trading calendar; a
  # US-holiday Thursday has no session, so the same-window US-rate news is 0.
  ust2_d <- dgs2_daily |>
    dplyr::arrange(date) |>
    dplyr::mutate(d_ust2 = 100 * (ust2y - dplyr::lag(ust2y))) |>
    dplyr::select(date, d_ust2)

  # ---- Pre-event predictors (Bauer-Swanson eq. 7 analogue) ----
  # Financial trends over the 13 weeks (65 trading days) ending at the Wednesday
  # close, i.e. strictly predetermined at the announcement; Focus median revisions
  # over ~4 weeks (20 survey days), the analogue of the Blue Chip revision cadence.

  PRE_BD_FIN   <- 65
  PRE_BD_FOCUS <- 20

  trail_change <- function(df, col, k, log_scale = TRUE) {
    x <- df[[col]]
    v <- if (log_scale) 100 * (log(x) - log(dplyr::lag(x, k))) else x - dplyr::lag(x, k)
    tibble::tibble(date = df$date, val = v)
  }

  # last available value of a daily series at date <= cutoff
  align_pre_event <- function(cutoffs, daily) {
    idx <- findInterval(as.numeric(cutoffs), as.numeric(daily$date))
    ifelse(idx >= 1, daily$val[idx], NA_real_)
  }

  # The pre-event DI slope is hard-wired to 504bd - 63bd and is therefore
  # invariant to target_bd: it stays a valid predetermined predictor across
  # the whole vertex sweep, with no circularity even near 63 or 504.
  di_slope_daily <- di_panel |>
    dplyr::group_by(date) |>
    dplyr::summarise(
      slope = 100 * (close_rate[which.min(abs(bdays - 504))] -
                     close_rate[which.min(abs(bdays - 63))]),
      .groups = "drop"
    ) |>
    dplyr::arrange(date)

  pre_cutoff <- all_thursdays - 1   # Wednesday: last close before the announcement

  # per-series non-NA calendars (Yahoo series have scattered missing closes)
  drop_na_series <- function(df, col) df[!is.na(df[[col]]), c("date", col)]

  pre_event <- tibble::tibble(
    date            = all_thursdays,
    pre_ibov        = align_pre_event(pre_cutoff, trail_change(ibov_daily, "ibov", PRE_BD_FIN)),
    pre_sp500       = align_pre_event(pre_cutoff, trail_change(drop_na_series(ext_daily, "sp500"), "sp500", PRE_BD_FIN)),
    pre_vix         = align_pre_event(pre_cutoff, trail_change(drop_na_series(ext_daily, "vix"), "vix", PRE_BD_FIN, log_scale = FALSE)),
    pre_brent       = align_pre_event(pre_cutoff, trail_change(drop_na_series(ext_daily, "brent"), "brent", PRE_BD_FIN)),
    pre_brl         = align_pre_event(pre_cutoff, trail_change(brl_daily, "brl", PRE_BD_FIN)),
    pre_slope       = align_pre_event(pre_cutoff, trail_change(di_slope_daily, "slope", PRE_BD_FIN, log_scale = FALSE)),
    pre_focus_ipca  = align_pre_event(pre_cutoff, trail_change(focus_daily, "focus_ipca12m", PRE_BD_FOCUS, log_scale = FALSE)),
    pre_focus_selic = align_pre_event(pre_cutoff, trail_change(focus_daily, "focus_selic_ny", PRE_BD_FOCUS, log_scale = FALSE))
  )

  thu_panel <- tibble::tibble(date = all_thursdays) |>
    dplyr::left_join(di_surprises, by = "date") |>
    dplyr::left_join(ibov_d,       by = "date") |>
    dplyr::left_join(ext_d,        by = "date") |>
    dplyr::left_join(ust2_d,       by = "date") |>
    dplyr::left_join(pre_event,    by = "date") |>
    dplyr::mutate(
      d_ust2        = tidyr::replace_na(d_ust2, 0),   # US-holiday Thursday: no session
      copom_day     = (date - 1) %in% copom_wed,
      fomc_coincide = copom_day & ((date - 1) %in% fomc_dates | date %in% fomc_dates),
      trend         = as.numeric(date - min(date)) / 365.25
    )

  valid <- thu_panel |>
    dplyr::filter(!is.na(delta_di), !is.na(r_ibov),
                  !is.na(r_sp500),  !is.na(d_vix), !is.na(r_brent))

  # Pre-event predictors must be complete on the valid panel so the audit
  # variants share exactly the same rows as the legacy ones.
  pre_cols <- c("pre_ibov", "pre_sp500", "pre_vix", "pre_brent", "pre_brl",
                "pre_slope", "pre_focus_ipca", "pre_focus_selic")
  n_na_pre <- colSums(is.na(valid[pre_cols]))
  if (any(n_na_pre > 0)) {
    msg <- paste0("NA in pre-event predictors on the valid panel: ",
                  paste(sprintf("%s=%d", names(n_na_pre[n_na_pre > 0]),
                                n_na_pre[n_na_pre > 0]), collapse = ", "))
    if (strict) {
      stop(msg, ". Check daily input coverage / run R/data_download/focus_fred.R.")
    }
    valid <- valid |> tidyr::drop_na(dplyr::all_of(pre_cols))
  }

  # ---- Purification regressions (full panel) -----------------

  lm_di   <- lm(delta_di ~ r_sp500 + d_vix + r_brent, data = valid)
  lm_ibov <- lm(r_ibov   ~ r_sp500 + d_vix + r_brent, data = valid)

  valid$e_di   <- residuals(lm_di)
  valid$e_ibov <- residuals(lm_ibov)

  # ---- JK sign classification (on residuals) -----------------
  # Monetary shock: residual DI and residual Ibov move in opposite directions.
  # Information shock: same direction -> zero out.

  valid <- valid |>
    dplyr::mutate(
      jk_monetary = copom_day &
                    sign(e_di) != 0 & sign(e_ibov) != 0 &
                    sign(e_di) != sign(e_ibov)
    )

  # Reversed ordering (JK filter -> purification): mask decided on RAW
  # co-movement, before any global-factor cleanup.

  valid <- valid |>
    dplyr::mutate(
      jk_monetary_raw = copom_day &
                        sign(delta_di) != 0 & sign(r_ibov) != 0 &
                        sign(delta_di) != sign(r_ibov)
    )

  # Local purification for the literal "JK -> purify" ordering: regression
  # re-estimated on the raw-mask-selected Copom days only (~50 obs).
  sel_raw <- valid$jk_monetary_raw
  lm_di_local <- lm(delta_di ~ r_sp500 + d_vix + r_brent, data = valid[sel_raw, ])
  valid$e_di_local <- 0
  valid$e_di_local[sel_raw] <- residuals(lm_di_local)

  # ---- BS-faithful pre-event purification (audit 2026-07-14) --
  # Bauer-Swanson (2023) eq. 7: regress the surprise on PREDETERMINED news only
  # (financial trends + survey revisions + trend), keep the residual. Unlike the
  # contemporaneous regression above, nothing on the RHS can absorb the shock.

  bs_formula <- ~ trend + pre_ibov + pre_sp500 + pre_vix + pre_brent + pre_brl +
                  pre_slope + pre_focus_ipca + pre_focus_selic
  lm_di_bs   <- lm(update(bs_formula, delta_di ~ .), data = valid)
  lm_ibov_bs <- lm(update(bs_formula, r_ibov ~ .),   data = valid)

  valid$e_di_bs   <- residuals(lm_di_bs)
  valid$e_ibov_bs <- residuals(lm_ibov_bs)

  valid <- valid |>
    dplyr::mutate(
      jk_monetary_bs = copom_day &
                       sign(e_di_bs) != 0 & sign(e_ibov_bs) != 0 &
                       sign(e_di_bs) != sign(e_ibov_bs)
    )

  # ---- Contemporaneous purification + UST 2y control ----------
  # Same-window global cleanup with the Wed->Thu 2y Treasury change added,
  # covering Fed spillovers on the ~32 FOMC-coincident Copom weeks.

  lm_di_us   <- lm(delta_di ~ r_sp500 + d_vix + r_brent + d_ust2, data = valid)
  lm_ibov_us <- lm(r_ibov   ~ r_sp500 + d_vix + r_brent + d_ust2, data = valid)

  valid$e_di_us   <- residuals(lm_di_us)
  valid$e_ibov_us <- residuals(lm_ibov_us)

  valid <- valid |>
    dplyr::mutate(
      jk_monetary_us = copom_day &
                       sign(e_di_us) != 0 & sign(e_ibov_us) != 0 &
                       sign(e_di_us) != sign(e_ibov_us)
    )

  # ---- Monthly aggregation -----------------------------------

  valid <- valid |> dplyr::mutate(month = lubridate::floor_date(date, "month"))

  monthly_grid <- tibble::tibble(
    month = seq(lubridate::floor_date(sample_start, "month"),
                lubridate::floor_date(sample_end,   "month"), by = "month"))

  ag <- function(value_col, keep_mask) agg_fn(valid, value_col, keep_mask, monthly_grid)

  z_bruto        <- ag("delta_di", rep(TRUE, nrow(valid)))
  z_bruto_purif  <- ag("e_di",    rep(TRUE, nrow(valid)))
  z_jk           <- ag("delta_di", valid$jk_monetary)
  z_jk_purif     <- ag("e_di",    valid$jk_monetary)
  z_jk_raw_purif       <- ag("e_di",       valid$jk_monetary_raw)
  z_jk_raw_purif_local <- ag("e_di_local", valid$jk_monetary_raw)
  z_jk_raw       <- ag("delta_di", valid$jk_monetary_raw)
  z_bs_purif     <- ag("e_di_bs", rep(TRUE, nrow(valid)))
  z_jk_bs_purif  <- ag("e_di_bs", valid$jk_monetary_bs)
  z_jk_purif_us  <- ag("e_di_us", valid$jk_monetary_us)

  instrumentos <- monthly_grid |>
    dplyr::left_join(z_bruto       |> dplyr::rename(z_bruto       = shock), by = "month") |>
    dplyr::left_join(z_bruto_purif |> dplyr::rename(z_bruto_purif = shock), by = "month") |>
    dplyr::left_join(z_jk          |> dplyr::rename(z_jk          = shock), by = "month") |>
    dplyr::left_join(z_jk_purif    |> dplyr::rename(z_jk_purif    = shock), by = "month") |>
    dplyr::left_join(z_jk_raw_purif       |> dplyr::rename(z_jk_raw_purif       = shock), by = "month") |>
    dplyr::left_join(z_jk_raw_purif_local |> dplyr::rename(z_jk_raw_purif_local = shock), by = "month") |>
    dplyr::left_join(z_jk_raw      |> dplyr::rename(z_jk_raw      = shock), by = "month") |>
    dplyr::left_join(z_bs_purif    |> dplyr::rename(z_bs_purif    = shock), by = "month") |>
    dplyr::left_join(z_jk_bs_purif |> dplyr::rename(z_jk_bs_purif = shock), by = "month") |>
    dplyr::left_join(z_jk_purif_us |> dplyr::rename(z_jk_purif_us = shock), by = "month") |>
    dplyr::mutate(dplyr::across(dplyr::starts_with("z_"), ~ tidyr::replace_na(.x, 0)))

  # ---- Diagnostics -------------------------------------------

  copom_days <- valid |> dplyr::filter(copom_day)
  realized   <- if ("bdays_used" %in% names(valid)) copom_days$bdays_used else NA_real_

  list(
    monthly = instrumentos,
    daily   = valid,
    diag    = list(
      target_bd     = target_bd,
      agg           = agg,
      n_thursdays   = nrow(thu_panel),
      n_valid       = nrow(valid),
      n_copom       = nrow(copom_days),
      n_jk          = sum(copom_days$jk_monetary),
      n_jk_raw      = sum(copom_days$jk_monetary_raw),
      n_jk_bs       = sum(copom_days$jk_monetary_bs),
      n_jk_us       = sum(copom_days$jk_monetary_us),
      r2_di_bs      = summary(lm_di_bs)$r.squared,
      r2_ibov_bs    = summary(lm_ibov_bs)$r.squared,
      n_na_pre      = sum(n_na_pre)
    )
  )
}

`%||%` <- function(x, y) if (is.null(x)) y else x
