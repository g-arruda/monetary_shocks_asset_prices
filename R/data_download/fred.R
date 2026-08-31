#' Download a FRED series through the public graph endpoint
#'
#' @param id FRED series identifier.
#' @param from First observation date.
#' @param to Last observation date.
#'
#' @return Tibble with columns `date` and `value`; source missing values removed.
#'
#' @examples
#' dgs2 <- download_fred_series("DGS2", "2025-01-01", "2025-12-31")
download_fred_series <- function(id, from, to) {
  request_url <- sprintf(
    "https://fred.stlouisfed.org/graph/fredgraph.csv?id=%s&cosd=%s&coed=%s",
    id,
    as.Date(from),
    as.Date(to)
  )
  series <- readr::read_csv(
    request_url,
    show_col_types = FALSE,
    na = c(".", "")
  )

  if (!all(c("observation_date", id) %in% names(series))) {
    stop("FRED response does not contain the declared series ", id, ".")
  }

  series |>
    dplyr::transmute(
      date = as.Date(observation_date),
      value = as.numeric(.data[[id]])
    ) |>
    dplyr::filter(!is.na(value)) |>
    dplyr::arrange(date)
}
