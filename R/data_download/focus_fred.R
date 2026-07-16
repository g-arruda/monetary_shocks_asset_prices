# ============================================================
# Pre-event predictors for the BS-faithful purification:
#  - Focus (BCB olinda API): daily median expectations
#      * IPCA 12 months ahead, smoothed (fixed horizon)
#      * Selic end of NEXT calendar year (fixed-event, horizon 12-24m;
#        next-year avoids the mechanical resolution of the current-year
#        median in December)
#  - FRED DGS2: 2-year US Treasury constant-maturity yield (daily)
# Outputs: data/processed/focus_daily.csv, data/fred_dgs2.csv
# Run: Rscript R/data_download/focus_fred.R
# ============================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(lubridate)
  library(readr)
  library(jsonlite)
})

FROM <- as.Date("2012-06-01")
TO   <- as.Date("2025-12-31")

OLINDA <- "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata"

#' Paginated fetch from an olinda Expectativas endpoint
#'
#' @param endpoint Entity set name (e.g., "ExpectativasMercadoInflacao12Meses").
#' @param filter   OData $filter expression (unencoded).
#' @param select   OData $select column list (unencoded).
#' @return Tibble with the selected columns, all pages bound.
fetch_olinda <- function(endpoint, filter, select, page_size = 10000) {
  out <- list()
  skip <- 0
  repeat {
    url <- sprintf(
      "%s/%s?$format=json&$filter=%s&$select=%s&$orderby=Data&$top=%d&$skip=%d",
      OLINDA, endpoint, filter, select, page_size, skip
    )
    page <- fromJSON(URLencode(url))$value
    if (length(page) == 0 || nrow(page) == 0) break
    out[[length(out) + 1]] <- page
    if (nrow(page) < page_size) break
    skip <- skip + page_size
  }
  bind_rows(out) |> as_tibble()
}

# ---- Focus: IPCA 12m ahead, smoothed, median -----------------

message("Fetching Focus IPCA 12m (smoothed, baseCalculo 0)...")
ipca12 <- fetch_olinda(
  "ExpectativasMercadoInflacao12Meses",
  sprintf("Indicador eq 'IPCA' and Suavizada eq 'S' and baseCalculo eq 0 and Data ge '%s' and Data le '%s'",
          FROM, TO),
  "Data,Mediana"
) |>
  transmute(date = as.Date(Data), focus_ipca12m = as.numeric(Mediana)) |>
  arrange(date) |>
  distinct(date, .keep_all = TRUE)

# ---- Focus: Selic end of next calendar year, median ----------

message("Fetching Focus Selic year-end (baseCalculo 0)...")
selic_raw <- fetch_olinda(
  "ExpectativasMercadoAnuais",
  sprintf("Indicador eq 'Selic' and baseCalculo eq 0 and Data ge '%s' and Data le '%s'",
          FROM, TO),
  "Data,DataReferencia,Mediana"
) |>
  transmute(date = as.Date(Data),
            ref_year = as.integer(DataReferencia),
            mediana = as.numeric(Mediana))

selic_ny <- selic_raw |>
  filter(ref_year == year(date) + 1L) |>
  arrange(date) |>
  distinct(date, .keep_all = TRUE) |>
  transmute(date, focus_selic_ny = mediana)

focus_daily <- full_join(ipca12, selic_ny, by = "date") |> arrange(date)

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
write_csv(focus_daily, "data/processed/focus_daily.csv")
message(sprintf("Focus daily: %d rows (%s to %s), NA ipca=%d, NA selic=%d",
                nrow(focus_daily), min(focus_daily$date), max(focus_daily$date),
                sum(is.na(focus_daily$focus_ipca12m)), sum(is.na(focus_daily$focus_selic_ny))))

# ---- FRED: DGS2 ----------------------------------------------

message("Fetching FRED DGS2...")
fred_url <- sprintf(
  "https://fred.stlouisfed.org/graph/fredgraph.csv?id=DGS2&cosd=%s&coed=%s", FROM, TO
)
dgs2 <- read_csv(fred_url, show_col_types = FALSE, na = c(".", "")) |>
  transmute(date = as.Date(observation_date), ust2y = as.numeric(DGS2)) |>
  filter(!is.na(ust2y))

write_csv(dgs2, "data/fred_dgs2.csv")
message(sprintf("FRED DGS2: %d rows (%s to %s)",
                nrow(dgs2), min(dgs2$date), max(dgs2$date)))
