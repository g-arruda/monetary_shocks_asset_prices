library(dplyr)
library(lubridate)
library(quantmod)

#' Fetch daily closing prices from Yahoo Finance for a single ticker
#'
#' Uses quantmod::Cl() to extract the Close column by name, which is robust to
#' the order of OHLCV columns returned by getSymbols.
#'
#' @param ticker Yahoo ticker (e.g., "^GSPC", "BZ=F", "BRL=X").
#' @param from Start date (YYYY-MM-DD).
#' @param to   End date (YYYY-MM-DD).
#'
#' @return Tibble with columns date, close.
fetch_yahoo_close <- function(ticker, from, to) {
  raw <- quantmod::getSymbols(ticker, auto.assign = FALSE, from = from, to = to)
  quantmod::Cl(raw) |>
    zoo::fortify.zoo() |>
    tibble::as_tibble(.name_repair = "minimal") |>
    dplyr::rename(date = 1, close = 2) |>
    dplyr::filter(!is.na(close))
}

#' Download S&P 500, VIX and Brent daily closes from Yahoo
#'
#' @param from Start date (YYYY-MM-DD).
#' @param to   End date (YYYY-MM-DD).
#'
#' @return Tibble with columns date, sp500, vix, brent.
download_external_factors <- function(from = "2012-01-01", to = "2026-02-01") {
  sp500 <- fetch_yahoo_close("^GSPC", from, to) |> dplyr::rename(sp500 = close)
  vix   <- fetch_yahoo_close("^VIX",  from, to) |> dplyr::rename(vix   = close)
  brent <- fetch_yahoo_close("BZ=F",  from, to) |> dplyr::rename(brent = close)

  sp500 |>
    dplyr::full_join(vix,   by = "date") |>
    dplyr::full_join(brent, by = "date") |>
    dplyr::arrange(date)
}

#' Download BRL/USD daily close from Yahoo
#'
#' Ticker BRL=X is quoted as BRL per 1 USD (typically 5-6 in 2024-2025).
#' Saved separately from the global external factors because it enters the
#' Brazilian daily SVAR for heteroskedasticity-based shock identification.
#'
#' @param from Start date (YYYY-MM-DD).
#' @param to   End date (YYYY-MM-DD).
#'
#' @return Tibble with columns date, brl.
download_brl_usd_daily <- function(from = "2012-01-01", to = "2026-02-01") {
  fetch_yahoo_close("BRL=X", from, to) |>
    dplyr::rename(brl = close) |>
    dplyr::arrange(date)
}

if (sys.nframe() == 0) {
  ext <- download_external_factors()
  readr::write_csv(ext, "data/investing/external_factors_daily.csv")
  message(sprintf("Saved %d rows to data/investing/external_factors_daily.csv", nrow(ext)))

  brl <- download_brl_usd_daily()
  dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
  readr::write_csv(brl, "data/processed/brl_usd_daily.csv")
  message(sprintf("Saved %d rows to data/processed/brl_usd_daily.csv", nrow(brl)))
}
