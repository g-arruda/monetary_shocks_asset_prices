#' Download daily B3 index levels
#'
#' @param symbols B3 index symbols.
#' @param from First observation date.
#' @param to Last observation date.
#'
#' @return Long tibble with `date`, `symbol`, and `price`.
#'
#' @examples
#' indices <- download_b3_indices("IBOV", "2025-01-01", "2025-12-31")
download_b3_indices <- function(symbols, from, to) {
  from <- as.Date(from)
  to <- as.Date(to)
  years <- seq(lubridate::year(from), lubridate::year(to))

  rb3::fetch_marketdata(
    "b3-indexes-historical-data",
    index = symbols,
    year = years,
    throttle = TRUE
  )

  indices <- rb3::indexes_historical_data_get() |>
    dplyr::filter(symbol %in% symbols, refdate >= from, refdate <= to) |>
    dplyr::collect() |>
    dplyr::transmute(
      date = as.Date(refdate),
      symbol = as.character(symbol),
      price = as.numeric(value)
    ) |>
    dplyr::arrange(symbol, date)

  missing <- setdiff(symbols, unique(indices$symbol))
  duplicated_rows <- duplicated(indices[c("symbol", "date")])
  if (length(missing) > 0L || anyNA(indices) || any(indices$price <= 0) ||
      any(duplicated_rows)) {
    stop(
      "B3 index download is incomplete or invalid. Missing symbols: ",
      paste(missing, collapse = ", "),
      "."
    )
  }

  indices
}
