#' Download one Ipeadata series
#'
#' @param code Ipeadata series code.
#' @return Tibble with `date` and `value`.
download_ipea_series <- function(code) {
  if (length(code) != 1L || is.na(code) || !nzchar(code)) {
    stop("The Ipeadata series code must be one non-empty string.")
  }
  result <- ipeadatar::ipeadata(code, quiet = TRUE) |>
    dplyr::transmute(date = as.Date(date), value = as.numeric(value)) |>
    dplyr::filter(!is.na(date), !is.na(value)) |>
    dplyr::distinct() |>
    dplyr::arrange(date)

  if (nrow(result) == 0L || anyDuplicated(result$date) ||
      any(!is.finite(result$value))) {
    stop("ipeadatar returned an incomplete series for ", code, ".")
  }
  result
}
