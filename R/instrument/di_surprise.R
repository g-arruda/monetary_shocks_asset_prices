library(dplyr)
library(lubridate)

# DI file columns: TradeDate, ExpirationDate, TickerSymbol, DaysToExp, BDaysToExp, ..., CloseRate.
# CloseRate is a decimal annual rate (e.g. 0.1375 = 13.75% a.a.).
# ΔDI is returned in basis points: (r_thu - r_wed) * 10000.

load_di_panel <- function(path = "data/di.csv",
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

# Surprise on the same contract, Wed close -> Thu close, in basis points.
# Picks the Wed contract with BDaysToExp closest to target_bd (>= min_bd).
# If that contract has no Thu close, falls back to the next-nearest, and so on.
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
#' Load Copom announcement Wednesdays from data/copom_historico.csv
#'
#' Drops the leading numero_reuniao column (matches existing project pattern),
#' parses dd/mm/yyyy dates, restricts to the requested window, and keeps only
#' Wednesdays — the day on which the Copom decision is announced after market
#' close in Brazil.
#'
#' @param path CSV path. Default `"data/copom_historico.csv"`.
#' @param from Earliest meeting date kept (default 2012-06-01).
#' @param to   Latest meeting date kept (default 2025-12-31).
#'
#' @return Date vector of Copom Wednesdays, sorted and unique.
load_copom_wednesdays <- function(path = "data/copom_historico.csv",
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
