# ===================================================================
# Copom calendar and the Wednesday-to-Thursday DI futures surprise.
# Shared by the instrument (build_variants.R) and the heteroskedasticity
# diagnostic (R/identification/het_tests.R).
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


#' Wednesday-to-Thursday DI surprises for a vector of Thursdays
#'
#' For each Thursday, takes the Wednesday contract whose maturity is closest
#' to `target_bd` (and at least `min_bd`) among those that also close on
#' Thursday, and differences the two closes. Holding the contract fixed across
#' the two days is what makes the difference a rate surprise rather than a
#' maturity effect. Among equally distant contracts the first in panel order
#' wins. Thursdays with no contract quoted on both days come back as
#' `NA_real_` rather than 0, so a missing quote never masquerades as a zero
#' surprise.
#'
#' @param di_panel Tibble from `load_di_panel()`.
#' @param thursdays Date vector of event Thursdays.
#' @param target_bd Target maturity in business days.
#' @param min_bd Minimum maturity in business days.
#'
#' @return Tibble with date and delta_di (basis points).
build_thursday_surprises <- function(di_panel, thursdays, target_bd, min_bd) {
  wednesday_closes <- di_panel |>
    dplyr::filter(date %in% (thursdays - 1L), bdays >= min_bd) |>
    dplyr::transmute(date = date + 1L, ticker, bdays, rate_wed = close_rate)

  thursday_closes <- di_panel |>
    dplyr::filter(date %in% thursdays) |>
    dplyr::select(date, ticker, rate_thu = close_rate)

  surprises <- wednesday_closes |>
    dplyr::inner_join(thursday_closes, by = c("date", "ticker")) |>
    dplyr::slice_min(
      abs(bdays - target_bd),
      n = 1,
      with_ties = FALSE,
      by = date
    ) |>
    # decimal rate -> basis points
    dplyr::transmute(date, delta_di = (rate_thu - rate_wed) * 10000)

  tibble::tibble(date = thursdays) |>
    dplyr::left_join(surprises, by = "date")
}
