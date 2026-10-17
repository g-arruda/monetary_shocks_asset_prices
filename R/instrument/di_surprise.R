# ===================================================================
# Copom calendar, the Wednesday-to-Thursday DI futures surprise and the time
# of each Yahoo BRL=X quote. Shared by the instrument (build_variants.R), the
# heteroskedasticity diagnostic (R/identification/het_tests.R,
# script/het_conditions.R) and the Copom-day scripts (script/copom_timing.R,
# script/daily_event.R).
# ===================================================================


#' Read the daily DI futures panel
#'
#' The DI file carries TradeDate, ExpirationDate, TickerSymbol, DaysToExp,
#' BDaysToExp and CloseRate, where CloseRate is a decimal annual rate
#' (0.1375 = 13.75% a.a.). Contracts already expired (`bdays <= 0`) and rows
#' with missing rate or maturity are dropped here rather than downstream.
#'
#' @param path Path to the raw DI CSV.
#' @param from,to Date bounds on TradeDate.
#'
#' @return Tibble with date, expiration, ticker, bdays and close_rate.
load_di_panel <- function(path, from, to) {
  readr::read_csv(path, show_col_types = FALSE) |>
    dplyr::transmute(
      date = as.Date(TradeDate),
      expiration = as.Date(ExpirationDate),
      ticker = TickerSymbol,
      bdays = as.integer(BDaysToExp),
      close_rate = as.numeric(CloseRate)
    ) |>
    dplyr::filter(
      date >= from,
      date <= to,
      !is.na(close_rate),
      bdays > 0
    )
}


#' Load the Copom announcement Wednesdays
#'
#' Parses the dd/mm/yyyy meeting dates, restricts them to the requested
#' window and keeps only Wednesdays — the day on which the Copom decision is
#' announced after market close in Brazil.
#'
#' @param path Path to `copom_historico.csv`.
#' @param from,to Earliest and latest meeting date kept.
#'
#' @return Date vector of Copom Wednesdays, sorted and unique.
load_copom_wednesdays <- function(path, from, to) {
  readr::read_csv(path, show_col_types = FALSE) |>
    dplyr::transmute(meeting_date = lubridate::dmy(data_reuniao)) |>
    dplyr::filter(
      meeting_date >= from,
      meeting_date <= to,
      lubridate::wday(meeting_date) == 4
    ) |>
    dplyr::distinct(meeting_date) |>
    dplyr::arrange(meeting_date) |>
    dplyr::pull(meeting_date)
}


#' DI surprises from one close to a later one, the contract held fixed
#'
#' For each pair of dates, takes the contract whose maturity on the first
#' date is closest to `target_bd` (and at least `min_bd`) among those that
#' also close on the second, and differences the two closes. Holding the
#' contract fixed across the two days is what makes the difference a rate
#' surprise rather than a maturity effect. Among equally distant contracts
#' the first in panel order wins. The usual pair is a Wednesday and the
#' Thursday after it; when Thursday is a Brazilian holiday, the second date
#' is the next DI session. Pairs with no contract quoted on both dates come
#' back as `NA_real_` rather than 0, so a missing quote never masquerades as
#' a zero surprise.
#'
#' @param di_panel Tibble from `load_di_panel()`.
#' @param pre_dates Date vector of the closes before the event.
#' @param post_dates Date vector of the closes after it, one per `pre_dates`.
#' @param target_bd Target maturity in business days.
#' @param min_bd Minimum maturity in business days.
#'
#' @return Tibble in the order of the pairs, with pre_date, post_date,
#'   delta_di (basis points), and the contract used: ticker and bdays, its
#'   business days to expiry on `pre_date`.
build_event_surprises <- function(di_panel, pre_dates, post_dates, target_bd,
                                  min_bd) {
  pairs <- tibble::tibble(pre_date = pre_dates, post_date = post_dates)

  pre_closes <- di_panel |>
    dplyr::filter(bdays >= min_bd) |>
    dplyr::inner_join(pairs, by = c("date" = "pre_date"), keep = TRUE) |>
    dplyr::select(pre_date, post_date, ticker, bdays, rate_pre = close_rate)

  post_closes <- di_panel |>
    dplyr::select(post_date = date, ticker, rate_post = close_rate)

  surprises <- pre_closes |>
    dplyr::inner_join(post_closes, by = c("post_date", "ticker")) |>
    dplyr::slice_min(
      abs(bdays - target_bd),
      n = 1,
      with_ties = FALSE,
      by = c(pre_date, post_date)
    ) |>
    # decimal rate -> basis points
    dplyr::transmute(
      pre_date,
      post_date,
      delta_di = (rate_post - rate_pre) * 10000,
      ticker,
      bdays
    )

  pairs |>
    dplyr::left_join(surprises, by = c("pre_date", "post_date"))
}


#' Read the daily Yahoo BRL=X rate with the time of each quote
#'
#' Yahoo stamps each FX bar at the London midnight that opens the bar's
#' day, and its close is the rate at that instant, so a row carries the
#' rate of the Brazilian evening before (20h, 21h or 22h in Brasilia). The
#' date written in the file is that instant's in UTC: under British summer
#' time the midnight falls at 23h UTC of the day before, so the rows run
#' Sunday to Thursday, and Monday to Friday outside it. The time is inferred
#' from that stamping and from the daily alignment with the PTAX and the
#' Ibovespa (script/daily_event.R, fx_alignment.csv); Yahoo does not declare
#' it.
#'
#' @param path Path to `brl_usd_daily.csv` (columns date, brl).
#'
#' @return Tibble with date (the file's), brl (R$ per US$) and quote_time
#'   (POSIXct, America/Sao_Paulo), sorted by date.
load_yahoo_brl <- function(path) {
  readr::read_csv(path, show_col_types = FALSE) |>
    dplyr::transmute(date = as.Date(date), brl) |>
    dplyr::arrange(date) |>
    dplyr::mutate(
      next_midnight = lubridate::ymd_hm(paste(date + 1L, "00:00"), tz = "Europe/London"),
      quote_time = dplyr::if_else(
        lubridate::dst(next_midnight),
        next_midnight,
        lubridate::ymd_hm(paste(date, "00:00"), tz = "Europe/London")
      ) |>
        lubridate::with_tz("America/Sao_Paulo")
    ) |>
    dplyr::select(-next_midnight)
}
