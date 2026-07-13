suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(lubridate)
  library(rb3)
})

#' Download monthly break-even inflation from ANBIMA reference rates
#'
#' Pulls the daily nominal (PRE) and real (DIC, NTN-B implied) ANBIMA
#' reference rate curves via rb3, interpolates to fixed business-day
#' maturities (1y, 2y, 5y), and returns the monthly end-of-month
#' break-even spread (nominal - real) at each maturity.
#'
#' Break-even at horizon h is a market-implied measure of inflation
#' expectations: it is the inflation rate at which a holder is
#' indifferent between a nominal LTN and an inflation-linked NTN-B of
#' the same maturity. Used as response variable for benchmarking against
#' Goncalves-Rodrigues-Genta (2025) Tab 4 (their dependent variable is
#' break-even, not realized IPCA).
#'
#' rb3 caches files under `getOption("rb3.cachedir")`; the caller is
#' responsible for setting that option and for calling
#' `rb3::fetch_marketdata("b3-reference-rates", ...)` for each refdate
#' before this function runs. Without a populated cache, the function
#' returns an empty tibble (no error) so the rest of the pipeline can
#' proceed without break-even.
#'
#' @param from Start date (YYYY-MM-DD) for the daily fetch.
#' @param to End date (YYYY-MM-DD) for the daily fetch.
#' @param bd_targets Named integer vector of business-days-to-maturity
#'   to interpolate. Defaults to 1y / 2y / 5y at 252 / 504 / 1260 du.
#'
#' @return Tibble with columns ref.date, breakeven_1y, breakeven_2y,
#'   breakeven_5y. Rates are in decimal (0.05 = 5%); break-even spreads
#'   are in pp (=> already on the same scale).
download_breakeven_curve <- function(from = "2010-01-01",
                                     to   = "2026-12-31",
                                     bd_targets = c(`1y` = 252L, `2y` = 504L, `5y` = 1260L)) {
  yc_pre  <- tryCatch(rb3::yc_brl_get()  |> dplyr::collect(),
                      error = function(e) tibble::tibble())
  yc_real <- tryCatch(rb3::yc_ipca_get() |> dplyr::collect(),
                      error = function(e) tibble::tibble())

  if (nrow(yc_pre) == 0L || nrow(yc_real) == 0L) {
    warning("ANBIMA yield curves empty -- run rb3::fetch_marketdata('b3-reference-rates', ...) ",
            "for the desired refdates first. Returning empty break-even tibble.")
    return(tibble::tibble(
      ref.date     = as.Date(character(0)),
      breakeven_1y = numeric(0),
      breakeven_2y = numeric(0),
      breakeven_5y = numeric(0)
    ))
  }

  filter_window <- function(df) {
    df |>
      dplyr::filter(refdate >= as.Date(from), refdate <= as.Date(to)) |>
      dplyr::transmute(date = as.Date(refdate),
                       biz_days = as.integer(biz_days),
                       rate = as.numeric(r_252))
  }

  pre  <- filter_window(yc_pre)
  real <- filter_window(yc_real)

  interpolate_at_targets <- function(daily_long, bd_targets) {
    daily_long |>
      dplyr::group_by(date) |>
      dplyr::group_modify(~ {
        if (nrow(.x) < 2L) return(tibble::tibble())
        # Interpolate via cubic spline (matches Svensson protocol used
        # for DI yields in R/modeling/svensson_model.R).
        rates <- stats::spline(.x$biz_days, .x$rate, xout = unname(bd_targets))$y
        tibble::tibble(bd = unname(bd_targets), rate = rates,
                       label = names(bd_targets))
      }) |>
      dplyr::ungroup()
  }

  pre_interp  <- interpolate_at_targets(pre,  bd_targets) |>
    tidyr::pivot_wider(id_cols = date,
                       names_from = label, values_from = rate,
                       names_prefix = "pre_")
  real_interp <- interpolate_at_targets(real, bd_targets) |>
    tidyr::pivot_wider(id_cols = date,
                       names_from = label, values_from = rate,
                       names_prefix = "real_")

  daily <- dplyr::inner_join(pre_interp, real_interp, by = "date")

  daily |>
    dplyr::group_by(month = lubridate::floor_date(date, "month")) |>
    dplyr::slice_tail(n = 1L) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      ref.date     = month,
      breakeven_1y = pre_1y - real_1y,
      breakeven_2y = pre_2y - real_2y,
      breakeven_5y = pre_5y - real_5y
    )
}

#' Populate the rb3 cache with reference-rate curves over a date range
#'
#' Helper that calls `rb3::fetch_marketdata` for each business day in
#' the requested window and curve list. Idempotent; rb3 skips already
#' cached files. Use once before calling `download_breakeven_curve`.
#'
#' @param from Start date.
#' @param to End date.
#' @param curves Character vector of curve names (e.g., c("PRE", "DIC")).
#'
#' @return NULL (invoked for side effects on the rb3 cache).
fetch_anbima_reference_rates <- function(from = "2010-01-01",
                                         to   = "2026-12-31",
                                         curves = c("PRE", "DIC")) {
  cal <- bizdays::create.calendar(
    "Brazil/ANBIMA",
    start.date = as.Date(from),
    end.date   = as.Date(to),
    weekdays   = c("saturday", "sunday")
  )
  dates <- seq(as.Date(from), as.Date(to), by = "day")
  dates <- dates[bizdays::is.bizday(dates, cal)]

  for (curve in curves) {
    rb3::fetch_marketdata("b3-reference-rates",
                          refdate    = dates,
                          curve_name = curve)
  }
  invisible(NULL)
}
