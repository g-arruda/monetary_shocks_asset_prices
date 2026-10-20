# ===================================================================
# The Yahoo BRL=X daily bars with the stamp the API gives each one, from the
# chart endpoint quantmod::getSymbols() reads (query2, v8/finance/chart).
# script/download.R keeps only the date quantmod derives from that stamp,
# as.Date() in UTC of a time quantmod reads in the exchange's zone, so the
# stamp itself was never saved. The advisor asked for the row's date, the
# stamp and the quote's time to be documented apart (e-mail of 2026-10-18,
# item 1); script/copom_timing.R sets this file against brl_usd_daily.csv.
# A stage of its own, so that it never refreshes the production files.
# Output: data/raw/brl_usd_daily_stamps.csv (timestamp in UNIX seconds,
#   close, exchange_timezone as the API declares it)
# Note: notas/2026-10-18_conferencias_ponte.md
# ===================================================================

# 2010-01-01 to 2026-01-01, 00:00 UTC: brl_usd_daily.csv's span
YAHOO_URL <- paste0(
  "https://query2.finance.yahoo.com/v8/finance/chart/BRL=X",
  "?period1=1262304000&period2=1767225600&interval=1d"
)

handle <- curl::new_handle()
curl::handle_setheaders(handle, `User-Agent` = "Mozilla/5.0")
chart <- curl::curl_fetch_memory(YAHOO_URL, handle = handle)$content |>
  rawToChar() |>
  jsonlite::fromJSON()

stamps <- tibble::tibble(
  timestamp = chart$chart$result$timestamp[[1]],
  close = chart$chart$result$indicators$quote[[1]]$close[[1]],
  exchange_timezone = chart$chart$result$meta$exchangeTimezoneName
)

readr::write_csv(stamps, "data/raw/brl_usd_daily_stamps.csv")
