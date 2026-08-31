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
  skip <- 0L

  repeat {
    request_url <- sprintf(
      "%s/%s?$format=json&$filter=%s&$select=%s&$orderby=Data&$top=%d&$skip=%d",
      base_url,
      endpoint,
      filter,
      select,
      page_size,
      skip
    )
    page <- jsonlite::fromJSON(URLencode(request_url))$value
    if (length(page) == 0L || nrow(page) == 0L) {
      break
    }

    pages[[length(pages) + 1L]] <- page
    if (nrow(page) < page_size) {
      break
    }
    skip <- skip + page_size
  }

  if (length(pages) == 0L) {
    stop("BCB Olinda returned no observations for endpoint ", endpoint, ".")
  }

  dplyr::bind_rows(pages) |>
    tibble::as_tibble()
}

#' Select the last published Focus value in each month
#'
#' @param data Daily data with `date` and `value` columns.
#' @param from First monthly reference date.
#' @param to Last monthly reference date.
#'
#' @return Tibble with one observation per month.
#'
#' @examples
#' monthly <- last_focus_value_in_month(
#'   tibble::tibble(date = as.Date("2025-01-31"), value = 1),
#'   as.Date("2025-01-01"),
#'   as.Date("2025-01-01")
#' )
last_focus_value_in_month <- function(data, from, to) {
  data |>
    dplyr::mutate(ref.date = lubridate::floor_date(date, "month")) |>
    dplyr::filter(ref.date >= from, ref.date <= to) |>
    dplyr::group_by(ref.date) |>
    dplyr::slice_max(date, n = 1L, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::select(ref.date, value) |>
    dplyr::arrange(ref.date)
}

#' Download the Focus series used by production and instrument construction
#'
#' @param from First publication date.
#' @param to Last publication date.
#' @param sample_start First month included in the production panel.
#' @param sample_end Last month included in the production panel.
#'
#' @return List with daily instrument predictors and four monthly production series.
#'
#' @examples
#' focus <- download_focus_data(
#'   "2025-01-01",
#'   "2025-12-31",
#'   "2025-01-01",
#'   "2025-09-01"
#' )
download_focus_data <- function(from, to, sample_start, sample_end) {
  from <- as.Date(from)
  to <- as.Date(to)
  sample_start <- as.Date(sample_start)
  sample_end <- as.Date(sample_end)

  ipca <- fetch_olinda(
    endpoint = "ExpectativasMercadoInflacao12Meses",
    filter = sprintf(
      paste0(
        "Indicador eq 'IPCA' and Suavizada eq 'S' and baseCalculo eq 0 ",
        "and Data ge '%s' and Data le '%s'"
      ),
      from,
      to
    ),
    select = "Indicador,Data,Mediana"
  ) |>
    dplyr::filter(Indicador == "IPCA") |>
    dplyr::transmute(date = as.Date(Data), value = as.numeric(Mediana)) |>
    dplyr::arrange(date) |>
    dplyr::distinct(date, .keep_all = TRUE)

  annual_indicators <- c(
    focus_selic_ny = "Selic",
    focus_pib_ny = "PIB Total",
    focus_cambio_ny = "Câmbio"
  )
  annual <- purrr::map(annual_indicators, function(indicator) {
    fetch_olinda(
      endpoint = "ExpectativasMercadoAnuais",
      filter = sprintf(
        paste0(
          "Indicador eq '%s' and baseCalculo eq 0 ",
          "and Data ge '%s' and Data le '%s'"
        ),
        indicator,
        from,
        to
      ),
      select = "Indicador,Data,DataReferencia,Mediana"
    ) |>
      dplyr::filter(Indicador == indicator) |>
      dplyr::transmute(
        date = as.Date(Data),
        reference_year = as.integer(DataReferencia),
        value = as.numeric(Mediana)
      ) |>
      dplyr::filter(reference_year == lubridate::year(date) + 1L) |>
      dplyr::arrange(date) |>
      dplyr::distinct(date, .keep_all = TRUE)
  })

  daily <- dplyr::full_join(
    ipca |>
      dplyr::rename(focus_ipca12m = value),
    annual$focus_selic_ny |>
      dplyr::select(date, focus_selic_ny = value),
    by = "date"
  ) |>
    dplyr::arrange(date)
  if (anyNA(daily) || anyDuplicated(daily$date)) {
    stop("Daily Focus inputs are incomplete or duplicated after joining.")
  }

  monthly <- list(
    expect_focus_ipca12m = ipca,
    expect_focus_selic_ny = annual$focus_selic_ny,
    expect_focus_pib_ny = annual$focus_pib_ny,
    expect_focus_cambio_ny = annual$focus_cambio_ny
  ) |>
    purrr::imap(function(data, variable) {
      last_focus_value_in_month(data, sample_start, sample_end) |>
        dplyr::rename(!!variable := value)
    }) |>
    purrr::reduce(dplyr::left_join, by = "ref.date") |>
    dplyr::arrange(ref.date)

  if (anyNA(monthly) || anyDuplicated(monthly$ref.date)) {
    stop("Monthly Focus production series are incomplete or duplicated.")
  }

  list(daily = daily, monthly = monthly)
}
