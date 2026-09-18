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


#' Sum of event-day values within the calendar month (Jarocinski-Karadi)
#'
#' @param df Daily event panel; needs `month`, `copom_day` and `value_col`.
#' @param value_col Name of the column holding the surprise.
#' @param keep_mask Logical vector, one per row of `df`: events to keep.
#'
#' @return Tibble `month`, `shock`.
agg_monthly_sum <- function(df, value_col, keep_mask) {
  df |>
    dplyr::mutate(val = ifelse(keep_mask, .data[[value_col]], 0)) |>
    dplyr::group_by(month) |>
    dplyr::summarise(shock = sum(val[copom_day], na.rm = TRUE),
                     .groups = "drop")
}


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
build_instrument_variants <- function(inputs, target_bd, sample_start, sample_end) {
  di_panel    <- inputs$di_panel
  ibov_daily  <- inputs$ibov_daily
  ext_daily   <- inputs$ext_daily
  brl_daily   <- inputs$brl_daily
  focus_daily <- inputs$focus_daily
  copom_wed   <- inputs$copom_wed

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

  # The pre-event DI slope is hard-wired to 504bd - 63bd, so it does not move
  # with target_bd.
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
    dplyr::left_join(pre_event,    by = "date") |>
    dplyr::mutate(
      copom_day = (date - 1) %in% copom_wed,
      trend     = as.numeric(date - min(date)) / 365.25
    )

  # The same-session S&P, VIX and Brent changes enter no regression; a Thursday
  # without them is still dropped, because that is what defines the sample of
  # the BS regressions below.
  valid <- thu_panel |>
    dplyr::filter(!is.na(delta_di), !is.na(r_ibov),
                  !is.na(r_sp500),  !is.na(d_vix), !is.na(r_brent))

  # lm() would drop an incomplete row silently and move the regression sample
  pre_cols <- c("pre_ibov", "pre_sp500", "pre_vix", "pre_brent", "pre_brl",
                "pre_slope", "pre_focus_ipca", "pre_focus_selic")
  n_na_pre <- colSums(is.na(valid[pre_cols]))
  if (any(n_na_pre > 0)) {
    stop("NA in pre-event predictors on the valid panel: ",
         paste(sprintf("%s=%d", names(n_na_pre[n_na_pre > 0]),
                       n_na_pre[n_na_pre > 0]), collapse = ", "),
         ". Check daily input coverage or rerun script/download.R.")
  }

  # ---- Bauer-Swanson pre-event purification -------------------
  # Bauer-Swanson (2023) eq. 7: regress the surprise on PREDETERMINED news only
  # (financial trends + survey revisions + trend) and keep the residual.

  bs_formula <- ~ trend + pre_ibov + pre_sp500 + pre_vix + pre_brent + pre_brl +
                  pre_slope + pre_focus_ipca + pre_focus_selic
  lm_di_bs   <- lm(update(bs_formula, delta_di ~ .), data = valid)
  lm_ibov_bs <- lm(update(bs_formula, r_ibov ~ .),   data = valid)

  valid$e_di_bs   <- residuals(lm_di_bs)
  valid$e_ibov_bs <- residuals(lm_ibov_bs)

  # ---- Jarocinski-Karadi sign filter on the BS residuals ------
  # Monetary shock: residual DI and residual Ibov move in opposite directions.
  # Information shock: same direction -> zero out.

  valid <- valid |>
    dplyr::mutate(
      jk_monetary_bs = copom_day &
                       sign(e_di_bs) != 0 & sign(e_ibov_bs) != 0 &
                       sign(e_di_bs) != sign(e_ibov_bs),
      month = lubridate::floor_date(date, "month")
    )

  # ---- Monthly aggregation -----------------------------------

  monthly_grid <- tibble::tibble(
    month = seq(lubridate::floor_date(sample_start, "month"),
                lubridate::floor_date(sample_end,   "month"), by = "month"))

  keep_all <- rep(TRUE, nrow(valid))
  z_bruto       <- agg_monthly_sum(valid, "delta_di", keep_all)
  z_bs_purif    <- agg_monthly_sum(valid, "e_di_bs",  keep_all)
  z_jk_bs_purif <- agg_monthly_sum(valid, "e_di_bs",  valid$jk_monetary_bs)

  instrumentos <- monthly_grid |>
    dplyr::left_join(dplyr::rename(z_bruto,       z_bruto       = shock), by = "month") |>
    dplyr::left_join(dplyr::rename(z_bs_purif,    z_bs_purif    = shock), by = "month") |>
    dplyr::left_join(dplyr::rename(z_jk_bs_purif, z_jk_bs_purif = shock), by = "month") |>
    dplyr::mutate(dplyr::across(dplyr::starts_with("z_"), ~ tidyr::replace_na(.x, 0)))

  copom_days <- valid |> dplyr::filter(copom_day)

  list(
    monthly = instrumentos,
    daily   = valid,
    diag    = list(
      target_bd   = target_bd,
      n_thursdays = nrow(thu_panel),
      n_valid     = nrow(valid),
      n_copom     = nrow(copom_days),
      n_jk_bs     = sum(copom_days$jk_monetary_bs),
      r2_di_bs    = summary(lm_di_bs)$r.squared,
      r2_ibov_bs  = summary(lm_ibov_bs)$r.squared
    )
  )
}
