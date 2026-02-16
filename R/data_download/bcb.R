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
download_bcb_data <- function(id, start_date = "2000-01-01", end_date = "2026-01-01", parallel = FALSE) {
    if (parallel) {
        future::plan(future::multisession, workers = floor(parallelly::availableCores() / 2))
    }

    df <- GetBCBData::gbcbd_get_series(
        id = id,
        first.date = start_date,
        last.date = end_date,
        format.data = "wide",
        do.parallel = parallel,
        use.memoise = TRUE,
        cache.path = tempdir()
    )

    return(df)
}
