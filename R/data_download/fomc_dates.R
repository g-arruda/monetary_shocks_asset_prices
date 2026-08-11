# ============================================================
# FOMC decision dates, from the Federal Reserve's own calendar
# pages. Feeds the `fomc_coincide` flag of
# R/instrument/build_variants.R and script/fomc_coincidence.R.
#
# Why a downloader and not a committed CSV: `data/` is gitignored,
# so a hand-written date file would not survive in version
# control. The list of dates has to live in code.
#
# Two page families, which together cover the whole sample:
#   - fomc_historical_year.htm enumerates the per-year archive
#     pages (the Fed publishes them with a five-year lag). The
#     year range is READ from that index, never hard-coded, so
#     the collection follows the calendar on its own.
#   - fomccalendars.htm carries the years the archive has not
#     reached yet.
#
# Extraction: the statement press release lives at
# /newsevents/pressreleases/monetaryYYYYMMDDa.htm, and the date
# in that URL IS the decision date. That is why the regex reads
# URLs rather than the rendered meeting dates, which appear as
# ranges ("28-29") with the month in a sibling element.
#
# Run: Rscript R/data_download/fomc_dates.R
# ============================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tibble)
})

FROM <- as.Date("2012-01-01")
TO   <- as.Date("2026-12-31")

BASE      <- "https://www.federalreserve.gov/monetarypolicy"
INDEX_URL <- file.path(BASE, "fomc_historical_year.htm")
CAL_URL   <- file.path(BASE, "fomccalendars.htm")
OUT_PATH  <- "data/raw/fomc_dates.csv"

#' Read a page into a single string.
fetch_page <- function(url) {
  con <- url(url, encoding = "UTF-8")
  on.exit(close(con))
  paste(readLines(con, warn = FALSE), collapse = "\n")
}

strip_tags <- function(x) gsub("\\s+", " ", gsub("<[^>]*>", " ", x))

#' Statement dates on one calendar page, with the scheduled/unscheduled split.
#'
#' The split needs BOTH rules, because each one alone misses a real case:
#' the enclosing panel heading catches 2020-03-15 (an unscheduled meeting
#' whose statement link sits far below the heading, past the Beige Book and
#' Tealbook links), and the local text window catches 2025-08-22 (a notation
#' vote on the current-years page, where the only panel heading is the year
#' itself). Their union classifies every known case correctly.
extract_statement_dates <- function(html) {
  hits <- gregexpr("monetary[0-9]{8}a", html)
  if (hits[[1]][1] == -1L) {
    return(tibble(date = as.Date(character(0)), type = character(0)))
  }
  starts <- as.integer(hits[[1]])
  # substr() recycles `x`, not `start`/`stop`, so slicing one long string at a
  # vector of offsets silently returns a single element. Cut the matches out.
  raw_dates <- substr(regmatches(html, hits)[[1]], 9L, 16L)

  panel_starts <- as.integer(gregexpr('<div class="panel panel-default', html)[[1]])
  panel_starts <- panel_starts[panel_starts > 0L]

  unscheduled <- vapply(starts, function(s) {
    before <- panel_starts[panel_starts < s]
    heading <- if (length(before) > 0L) {
      substr(html, max(before), min(max(before) + 600L, s))
    } else ""
    window <- substr(html, max(1L, s - 400L), s)
    grepl("unscheduled|notation vote",
          paste(strip_tags(heading), strip_tags(window)), ignore.case = TRUE)
  }, logical(1))

  tibble(date = as.Date(raw_dates, format = "%Y%m%d"), unscheduled) |>
    group_by(date) |>
    summarise(unscheduled = any(unscheduled), .groups = "drop") |>
    transmute(date, type = ifelse(unscheduled, "unscheduled", "scheduled"))
}

# ---- Collect ------------------------------------------------

message("Fetching the historical-year index...")
index_html <- fetch_page(INDEX_URL)
hist_years <- regmatches(index_html,
                         gregexpr("fomchistorical[0-9]{4}\\.htm", index_html))[[1]] |>
  substr(15, 18) |>
  as.integer() |>
  unique() |>
  sort()
hist_years <- hist_years[hist_years >= as.integer(format(FROM, "%Y"))]
stopifnot(length(hist_years) > 0)
message(sprintf("  archive pages in window: %d (%d-%d)",
                length(hist_years), min(hist_years), max(hist_years)))

pages <- c(setNames(file.path(BASE, sprintf("fomchistorical%d.htm", hist_years)),
                    as.character(hist_years)),
           "current" = CAL_URL)

fomc <- lapply(names(pages), function(nm) {
  message(sprintf("  %s", pages[[nm]]))
  extract_statement_dates(fetch_page(pages[[nm]]))
}) |>
  bind_rows() |>
  group_by(date) |>
  summarise(type = ifelse(any(type == "unscheduled"), "unscheduled", "scheduled"),
            .groups = "drop") |>
  filter(date >= FROM, date <= TO) |>
  arrange(date)

# ---- Self-tests: fail loud if the Fed's HTML changes ---------
# The whole point of this file is that a silent empty fallback hid the
# missing FOMC calendar for months (council review, 2026-08-10). A quiet
# partial scrape would hide it again.

stopifnot(!any(duplicated(fomc$date)))

sched <- fomc |>
  filter(type == "scheduled", date >= as.Date("2013-01-01"),
         date <= as.Date("2025-12-31")) |>
  count(year = as.integer(format(date, "%Y")))

# Eight scheduled meetings a year, except 2020: the 17-18 March meeting was
# cancelled and replaced by the unscheduled 15 March one, leaving seven.
expected <- ifelse(sched$year == 2020L, 7L, 8L)
if (!all(sched$n == expected)) {
  bad <- sched[sched$n != expected, ]
  stop("scheduled meetings per year off expectation: ",
       paste(sprintf("%d=%d", bad$year, bad$n), collapse = ", "))
}

KNOWN_UNSCHEDULED <- as.Date(c(
  "2019-10-11",   # 4 October unscheduled meeting, statement released 11 October
  "2020-03-03",   # 2 March unscheduled meeting (50bp intermeeting cut)
  "2020-03-15",   # 15 March unscheduled meeting (100bp cut to the ZLB)
  "2020-03-23",   # notation vote
  "2020-03-31",   # notation vote (FIMA repo facility)
  "2020-08-27",   # notation vote: Statement on Longer-Run Goals
  "2025-08-22"    # notation vote: Statement on Longer-Run Goals
))
got_unscheduled <- fomc$date[fomc$type == "unscheduled" &
                             fomc$date >= as.Date("2013-01-01") &
                             fomc$date <= as.Date("2025-12-31")]
if (!identical(sort(got_unscheduled), sort(KNOWN_UNSCHEDULED))) {
  stop("unscheduled set changed: got ",
       paste(format(sort(got_unscheduled)), collapse = ", "))
}

n_sample <- sum(fomc$date >= as.Date("2013-01-01") & fomc$date <= as.Date("2025-12-31"))
stopifnot(n_sample == 110L)

# ---- Write --------------------------------------------------

dir.create("data", showWarnings = FALSE, recursive = TRUE)
write_csv(fomc, OUT_PATH)

message(sprintf("Wrote %d FOMC dates to %s (%s to %s); %d in 2013-2025, %d unscheduled",
                nrow(fomc), OUT_PATH, min(fomc$date), max(fomc$date),
                n_sample, sum(fomc$type == "unscheduled")))
