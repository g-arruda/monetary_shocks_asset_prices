#' Download data from the Central Bank of Brazil
#'
#' @description
#' Downloads time series from the Central Bank of Brazil (BCB) using the BCB API.
#'
#' @param id Number(s) of the BCB time series
#' @param start_date Start date in "YYYY-MM-DD" format. Default: "2000-01-01"
#' @param end_date End date in "YYYY-MM-DD" format. Default: "2024-12-01"
#' @param parallel Boolean indicating whether to use parallel processing. Default: FALSE
#'
#' @return DataFrame containing the series data in wide format
#'
#' @details
#' - Uses the GetBCBData package for downloading
#' - In parallel mode, uses half of the available cores
#' - Temporary data cache is stored in temporary directory
#'
#' @examples
#' # Download IPCA series (code 433)
#' ipca <- download_bcb_data(433)
#'
#' # Download multiple series in parallel
#' series <- download_bcb_data(c(433, 189), parallel = TRUE)
download_bcb_data <- function(
    id,
    start_date = "2000-01-01",
    end_date = "2026-01-01",
    parallel = FALSE) {
  if (parallel) {
    previous_plan <- future::plan()
    on.exit(future::plan(previous_plan), add = TRUE)
    workers <- max(1L, floor(parallelly::availableCores() / 2))
    future::plan(future::multisession, workers = workers)
  }

  request <- function() {
    suppressMessages(GetBCBData::gbcbd_get_series(
      id = id,
      first.date = start_date,
      last.date = end_date,
      format.data = "wide",
      do.parallel = parallel,
      use.memoise = TRUE,
      cache.path = tempdir(),
      be.quiet = TRUE
    ))
  }
  if (!parallel) {
    return(request())
  }

  progress_output <- character()
  progress_connection <- textConnection(
    "progress_output",
    open = "w",
    local = TRUE
  )
  sink(progress_connection, type = "message")
  sink_open <- TRUE
  connection_open <- TRUE
  on.exit({
    if (sink_open) {
      sink(type = "message")
    }
    if (connection_open) {
      close(progress_connection)
    }
  }, add = TRUE)

  warning_store <- new.env(parent = emptyenv())
  warning_store$messages <- character()
  result <- withCallingHandlers(
    request(),
    warning = function(condition) {
      warning_store$messages <- c(
        warning_store$messages,
        conditionMessage(condition)
      )
      invokeRestart("muffleWarning")
    }
  )
  sink(type = "message")
  sink_open <- FALSE
  close(progress_connection)
  connection_open <- FALSE
  for (warning_message in warning_store$messages) {
    warning(warning_message, call. = FALSE)
  }
  result
}
