library(dplyr)
library(lubridate)
library(rb3)

download_ibov_daily <- function(from = "2012-01-01", to = "2026-02-01") {
  options(rb3.cachedir = "~/rb3-cache")
  years <- seq(lubridate::year(as.Date(from)), lubridate::year(as.Date(to)))

  rb3::fetch_marketdata(
    "b3-indexes-historical-data",
    index = "IBOV",
    year = years,
    throttle = TRUE
  )

  rb3::indexes_historical_data_get() |>
    dplyr::filter(symbol == "IBOV",
                  refdate >= as.Date(from),
                  refdate <= as.Date(to)) |>
    dplyr::collect() |>
    dplyr::transmute(date = as.Date(refdate), ibov = value) |>
    dplyr::arrange(date) |>
    dplyr::distinct(date, .keep_all = TRUE)
}

if (sys.nframe() == 0) {
  out <- download_ibov_daily()
  dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
  readr::write_csv(out, "data/processed/ibov_daily.csv")
  message(sprintf("Saved %d rows to data/processed/ibov_daily.csv", nrow(out)))
}
