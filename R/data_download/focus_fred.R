# Pre-event predictors for the BS-faithful purification.

#' Fetch paginated data from a BCB Olinda expectations endpoint
#'
#' @param endpoint Entity set name.
#' @param filter OData filter expression, without URL encoding.
#' @param select Comma-separated list of columns.
#' @param page_size Maximum number of rows requested per page.
#'
#' @return Tibble with all requested pages.
#'
#' @examples
#' fetch_olinda(
#'   endpoint = "ExpectativasMercadoInflacao12Meses",
#'   filter = "Indicador eq 'IPCA'",
#'   select = "Data,Mediana"
#' )
fetch_olinda <- function(endpoint, filter, select, page_size = 10000) {
  base_url <- "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata"
  pages <- list()
  skip <- 0

  repeat {
    url <- sprintf(
      "%s/%s?$format=json&$filter=%s&$select=%s&$orderby=Data&$top=%d&$skip=%d",
      base_url,
      endpoint,
      filter,
      select,
      page_size,
      skip
    )
    page <- jsonlite::fromJSON(URLencode(url))$value

    if (length(page) == 0 || nrow(page) == 0) {
      break
    }

    pages[[length(pages) + 1]] <- page

    if (nrow(page) < page_size) {
      break
    }

    skip <- skip + page_size
  }

  if (length(pages) == 0) {
    stop("BCB Olinda returned no observations for endpoint ", endpoint, ".")
  }

  dplyr::bind_rows(pages) |>
    tibble::as_tibble()
}

#' Download the daily Focus inputs used by the instrument stage
#'
#' @param from First publication date.
#' @param to Last publication date.
#'
#' @return Tibble with daily IPCA 12-month and next-year Selic medians.
#'
#' @examples
#' focus <- download_focus_daily("2025-01-01", "2025-12-31")
download_focus_daily <- function(from = "2012-06-01", to = "2025-12-31") {
  from <- as.Date(from)
  to <- as.Date(to)

  ipca12 <- fetch_olinda(
    endpoint = "ExpectativasMercadoInflacao12Meses",
    filter = sprintf(
      paste0(
        "Indicador eq 'IPCA' and Suavizada eq 'S' and baseCalculo eq 0 ",
        "and Data ge '%s' and Data le '%s'"
      ),
      from,
      to
    ),
    select = "Data,Mediana"
  ) |>
    dplyr::transmute(
      date = as.Date(Data),
      focus_ipca12m = as.numeric(Mediana)
    ) |>
    dplyr::arrange(date) |>
    dplyr::distinct(date, .keep_all = TRUE)

  selic <- fetch_olinda(
    endpoint = "ExpectativasMercadoAnuais",
    filter = sprintf(
      paste0(
        "Indicador eq 'Selic' and baseCalculo eq 0 ",
        "and Data ge '%s' and Data le '%s'"
      ),
      from,
      to
    ),
    select = "Data,DataReferencia,Mediana"
  ) |>
    dplyr::transmute(
      date = as.Date(Data),
      reference_year = as.integer(DataReferencia),
      value = as.numeric(Mediana)
    ) |>
    dplyr::filter(reference_year == lubridate::year(date) + 1L) |>
    dplyr::arrange(date) |>
    dplyr::distinct(date, .keep_all = TRUE) |>
    dplyr::transmute(date, focus_selic_ny = value)

  focus <- dplyr::full_join(ipca12, selic, by = "date") |>
    dplyr::arrange(date)

  if (anyNA(focus)) {
    stop("Daily Focus inputs contain missing observations after joining.")
  }

  focus
}

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
download_fred_series <- function(id, from = "2012-06-01", to = "2025-12-31") {
  url <- sprintf(
    "https://fred.stlouisfed.org/graph/fredgraph.csv?id=%s&cosd=%s&coed=%s",
    id,
    as.Date(from),
    as.Date(to)
  )

  series <- readr::read_csv(
    url,
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

#' Write the legacy Focus and DGS2 inputs used by instrument construction
#'
#' @param from First observation date.
#' @param to Last observation date.
#'
#' @return Invisibly returns the paths written.
#'
#' @examples
#' write_focus_fred_inputs("2025-01-01", "2025-12-31")
write_focus_fred_inputs <- function(from = "2012-06-01", to = "2025-12-31") {
  focus <- download_focus_daily(from, to)
  dgs2 <- download_fred_series("DGS2", from, to) |>
    dplyr::rename(ust2y = value)

  dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
  dir.create("data/raw", showWarnings = FALSE, recursive = TRUE)
  readr::write_csv(focus, "data/processed/focus_daily.csv")
  readr::write_csv(dgs2, "data/raw/fred_dgs2.csv")

  message(sprintf(
    "Focus daily: %d rows (%s to %s).",
    nrow(focus),
    min(focus$date),
    max(focus$date)
  ))
  message(sprintf(
    "FRED DGS2: %d rows (%s to %s).",
    nrow(dgs2),
    min(dgs2$date),
    max(dgs2$date)
  ))

  invisible(c("data/processed/focus_daily.csv", "data/raw/fred_dgs2.csv"))
}

if (sys.nframe() == 0) {
  write_focus_fred_inputs()
}
