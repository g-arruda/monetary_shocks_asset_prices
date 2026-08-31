#' Download one Ipeadata series
#'
#' @param code Ipeadata series code.
#' @param attempts Maximum number of requests before failing.
#' @param timeout_seconds Timeout for each request.
#'
#' @return Tibble with `date` and `value`.
download_ipea_series <- function(code, attempts = 2L, timeout_seconds = 120L) {
  if (length(code) != 1L || is.na(code) || !nzchar(code)) {
    stop("The Ipeadata series code must be one non-empty string.")
  }
  if (attempts < 1L || timeout_seconds < 1L) {
    stop("Ipeadata attempts and timeout must be positive integers.")
  }

  previous_timeout <- getOption("timeout")
  on.exit(options(timeout = previous_timeout), add = TRUE)
  options(timeout = timeout_seconds)

  url <- sprintf(
    "https://www.ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO='%s')",
    code
  )
  last_error <- NULL

  for (attempt in seq_len(attempts)) {
    request <- tryCatch(
      list(
        response = jsonlite::fromJSON(url, flatten = TRUE)$value,
        error = NULL
      ),
      error = function(error) {
        list(response = NULL, error = conditionMessage(error))
      }
    )
    response <- request$response
    last_error <- request$error
    required_columns <- c("VALDATA", "VALVALOR")
    if (!is.null(response) && all(required_columns %in% names(response))) {
      result <- response |>
        dplyr::transmute(
          date = as.Date(substr(VALDATA, 1L, 10L)),
          value = as.numeric(VALVALOR)
        ) |>
        dplyr::filter(!is.na(date), !is.na(value)) |>
        dplyr::distinct() |>
        dplyr::arrange(date)

      if (nrow(result) > 0L && !anyDuplicated(result$date) &&
          all(is.finite(result$value))) {
        return(result)
      }
      last_error <- "the response was empty, duplicated, or non-finite"
    } else if (is.null(last_error)) {
      last_error <- "the response did not contain VALDATA and VALVALOR"
    }
  }

  stop(
    "Ipeadata download failed after ",
    attempts,
    " attempts for ",
    code,
    ": ",
    last_error,
    "."
  )
}
