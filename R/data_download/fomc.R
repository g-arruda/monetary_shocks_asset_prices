#' Read a web page into a single string
#'
#' @param url Page URL.
#'
#' @return The complete page as one character scalar.
#'
#' @examples
#' html <- fetch_fomc_page("https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm")
fetch_fomc_page <- function(url) {
  connection <- url(url, encoding = "UTF-8")
  on.exit(close(connection))
  paste(readLines(connection, warn = FALSE), collapse = "\n")
}

#' Drop HTML tags and collapse whitespace
#'
#' @param x Character vector of raw HTML.
#'
#' @return The same vector as plain text.
#'
#' @examples
#' text <- strip_fomc_tags("<p>Meeting</p>")
strip_fomc_tags <- function(x) {
  gsub("\\s+", " ", gsub("<[^>]*>", " ", x))
}

#' Extract statement dates from one FOMC calendar page
#'
#' @param html One calendar page returned by `fetch_fomc_page()`.
#'
#' @return Tibble with `date` and `type` columns.
#'
#' @examples
#' dates <- extract_fomc_statement_dates("monetary20250129a")
extract_fomc_statement_dates <- function(html) {
  hits <- gregexpr("monetary[0-9]{8}a", html)
  if (hits[[1]][1] == -1L) {
    return(tibble::tibble(date = as.Date(character()), type = character()))
  }

  starts <- as.integer(hits[[1]])
  raw_dates <- substr(regmatches(html, hits)[[1]], 9L, 16L)
  panel_starts <- as.integer(gregexpr('<div class="panel panel-default', html)[[1]])
  panel_starts <- panel_starts[panel_starts > 0L]
  unscheduled <- vapply(starts, function(start) {
    before <- panel_starts[panel_starts < start]
    heading <- if (length(before) > 0L) {
      substr(html, max(before), min(max(before) + 600L, start))
    } else {
      ""
    }
    window <- substr(html, max(1L, start - 400L), start)
    grepl(
      "unscheduled|notation vote",
      paste(strip_fomc_tags(heading), strip_fomc_tags(window)),
      ignore.case = TRUE
    )
  }, logical(1))

  tibble::tibble(date = as.Date(raw_dates, format = "%Y%m%d"), unscheduled = unscheduled) |>
    dplyr::group_by(date) |>
    dplyr::summarise(unscheduled = any(unscheduled), .groups = "drop") |>
    dplyr::transmute(
      date,
      type = dplyr::if_else(unscheduled, "unscheduled", "scheduled")
    )
}

#' Download and validate FOMC decision dates
#'
#' @param from First decision date retained.
#' @param to Last decision date retained.
#'
#' @return Tibble with unique decision dates and scheduled status.
#'
#' @examples
#' fomc <- download_fomc_dates("2025-01-01", "2025-12-31")
download_fomc_dates <- function(from, to) {
  from <- as.Date(from)
  to <- as.Date(to)
  base_url <- "https://www.federalreserve.gov/monetarypolicy"
  index_html <- fetch_fomc_page(file.path(base_url, "fomc_historical_year.htm"))
  historical_years <- regmatches(
    index_html,
    gregexpr("fomchistorical[0-9]{4}\\.htm", index_html)
  )[[1]] |>
    substr(15L, 18L) |>
    as.integer() |>
    unique() |>
    sort()
  historical_years <- historical_years[
    historical_years >= lubridate::year(from)
  ]
  if (length(historical_years) == 0L) {
    stop("The Federal Reserve historical index returned no years in the requested window.")
  }

  pages <- c(
    file.path(base_url, sprintf("fomchistorical%d.htm", historical_years)),
    file.path(base_url, "fomccalendars.htm")
  )
  fomc <- purrr::map_dfr(
    pages,
    ~ extract_fomc_statement_dates(fetch_fomc_page(.x))
  ) |>
    dplyr::group_by(date) |>
    dplyr::summarise(
      type = dplyr::if_else(any(type == "unscheduled"), "unscheduled", "scheduled"),
      .groups = "drop"
    ) |>
    dplyr::filter(date >= from, date <= to) |>
    dplyr::arrange(date)

  if (anyNA(fomc$date) || anyDuplicated(fomc$date)) {
    stop("FOMC calendar contains invalid or duplicated decision dates.")
  }

  sample <- fomc |>
    dplyr::filter(date >= as.Date("2013-01-01"), date <= as.Date("2025-12-31"))
  scheduled_counts <- sample |>
    dplyr::filter(type == "scheduled") |>
    dplyr::count(year = lubridate::year(date))
  expected_counts <- dplyr::if_else(scheduled_counts$year == 2020L, 7L, 8L)
  if (!identical(as.integer(scheduled_counts$year), 2013:2025) ||
      any(scheduled_counts$n != expected_counts)) {
    stop("FOMC scheduled-meeting counts changed in 2013-2025.")
  }

  known_unscheduled <- as.Date(c(
    "2019-10-11",
    "2020-03-03",
    "2020-03-15",
    "2020-03-23",
    "2020-03-31",
    "2020-08-27",
    "2025-08-22"
  ))
  observed_unscheduled <- sample$date[sample$type == "unscheduled"]
  if (!identical(sort(observed_unscheduled), sort(known_unscheduled)) ||
      nrow(sample) != 110L) {
    stop("FOMC unscheduled dates or total sample count changed in 2013-2025.")
  }

  fomc
}
