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
load_di_panel <- function(path = "data/raw/di.csv",
                          from = as.Date("2012-06-01"),
                          to   = as.Date("2026-02-01")) {
  readr::read_csv(path, show_col_types = FALSE) |>
    dplyr::transmute(
      date        = as.Date(TradeDate),
      expiration  = as.Date(ExpirationDate),
      ticker      = TickerSymbol,
      bdays       = as.integer(BDaysToExp),
      close_rate  = as.numeric(CloseRate)
    ) |>
    dplyr::filter(date >= from, date <= to,
                  !is.na(close_rate), !is.na(bdays),
                  bdays > 0)
}

#' Wednesday-to-Thursday DI surprise on a single contract, in basis points
#'
#' Picks the Wednesday contract whose BDaysToExp is closest to `target_bd`
#' (and at least `min_bd`), then reads the same ticker on Thursday. Holding the
#' contract fixed across the two days is what makes the difference a rate
#' surprise rather than a maturity effect. When the chosen contract has no
#' Thursday close, falls back to the next-nearest, and so on.
#'
#' @param di_panel Tibble from `load_di_panel()`.
#' @param wed_date,thu_date The Copom Wednesday and the following Thursday.
#' @param target_bd Target maturity in business days.
#' @param min_bd Minimum maturity in business days.
#'
#' @return `(r_thu - r_wed) * 10000` in basis points, or `NA_real_` when no
#'   contract is quoted on both days.
surprise_wed_to_thu <- function(di_panel, wed_date, thu_date,
                                target_bd = 63, min_bd = 10) {
  di_wed <- di_panel |> dplyr::filter(date == wed_date, bdays >= min_bd)
  di_thu <- di_panel |> dplyr::filter(date == thu_date)
  if (nrow(di_wed) == 0 || nrow(di_thu) == 0) return(NA_real_)

  di_wed <- di_wed[order(abs(di_wed$bdays - target_bd)), ]
  for (i in seq_len(nrow(di_wed))) {
    tk  <- di_wed$ticker[i]
    r_w <- di_wed$close_rate[i]
    r_t <- di_thu$close_rate[di_thu$ticker == tk]
    if (length(r_t) == 1 && !is.na(r_t) && !is.na(r_w)) {
      return((r_t - r_w) * 10000)   # decimal -> bps
    }
  }
  NA_real_
}

# Build table of (date = Thursday, delta_di_bps) for a given target maturity.
# thursdays must be a Date vector. The paired Wednesday is assumed to be thu - 1 day;
# callers passing a non-business-day Wednesday should filter beforehand if needed.
#' Load Copom announcement Wednesdays from data/raw/copom_historico.csv
#'
#' Drops the leading numero_reuniao column (matches existing project pattern),
#' parses dd/mm/yyyy dates, restricts to the requested window, and keeps only
#' Wednesdays — the day on which the Copom decision is announced after market
#' close in Brazil.
#'
#' @param path CSV path. Default `"data/raw/copom_historico.csv"`.
#' @param from Earliest meeting date kept (default 2012-06-01).
#' @param to   Latest meeting date kept (default 2025-12-31).
#'
#' @return Date vector of Copom Wednesdays, sorted and unique.
load_copom_wednesdays <- function(path = "data/raw/copom_historico.csv",
                                  from = as.Date("2012-06-01"),
                                  to   = as.Date("2025-12-31")) {
  readr::read_csv(path, show_col_types = FALSE)[-1] |>
    dplyr::transmute(meeting_date = lubridate::dmy(data_reuniao)) |>
    dplyr::filter(!is.na(meeting_date),
                  meeting_date >= from,
                  meeting_date <= to,
                  lubridate::wday(meeting_date) == 4) |>
    dplyr::distinct(meeting_date) |>
    dplyr::arrange(meeting_date) |>
    dplyr::pull(meeting_date)
}

#' Load FOMC decision dates from data/raw/fomc_dates.csv
#'
#' Aborts when the file is missing instead of returning an empty vector. That
#' silent fallback (script/instrument.R, until 2026-08-10) kept `fomc_coincide`
#' identically FALSE from the day the flag was written until the council review
#' found it — see pareceres/council_2026-08-10.md.
#'
#' @param path CSV path with a `date` column. Default `"data/raw/fomc_dates.csv"`.
#' @param from Earliest decision date kept (default 2012-06-01).
#' @param to   Latest decision date kept (default 2025-12-31).
#'
#' @return Date vector of FOMC decision dates, sorted and unique.
load_fomc_dates <- function(path = "data/raw/fomc_dates.csv",
                            from = as.Date("2012-06-01"),
                            to   = as.Date("2025-12-31")) {
  if (!file.exists(path)) {
    stop(path, " not found. Run: Rscript R/data_download/fomc_dates.R")
  }
  readr::read_csv(path, show_col_types = FALSE) |>
    dplyr::transmute(date = as.Date(date)) |>
    dplyr::filter(!is.na(date), date >= from, date <= to) |>
    dplyr::distinct(date) |>
    dplyr::arrange(date) |>
    dplyr::pull(date)
}

#' DI surprises for a vector of Thursdays
#'
#' Maps `surprise_wed_to_thu()` over each Thursday and its preceding
#' Wednesday. Thursdays with no quotable contract come back as `NA_real_`
#' rather than 0, so a missing quote never masquerades as a zero surprise.
#'
#' @param di_panel Tibble from `load_di_panel()`.
#' @param thursdays Date vector of event Thursdays.
#' @param target_bd Target maturity in business days.
#' @param min_bd Minimum maturity in business days.
#'
#' @return Tibble with date and delta_di (basis points).
build_thursday_surprises <- function(di_panel, thursdays, target_bd = 63, min_bd = 10) {
  stopifnot(inherits(thursdays, "Date"))
  wed <- thursdays - 1L
  deltas <- purrr::map2_dbl(
    wed, thursdays,
    ~ surprise_wed_to_thu(di_panel, .x, .y,
                          target_bd = target_bd, min_bd = min_bd)
  )
  tibble::tibble(date = thursdays, delta_di = deltas)
}
