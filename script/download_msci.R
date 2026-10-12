# ===================================================================
# The MSCI Emerging Markets index (MSCI code 891800, price index in USD,
# standard variant), end-of-month levels, from MSCI's own index-level
# service. It is the panel's msci, one of the three external placebos. The
# investing.com file script/download.R used to read as msci held the share
# price of MSCI Inc. (NYSE: MSCI), not the index (notas/
# 2026-10-09_placebos_holm.md, section 4). A stage of its own so that it runs
# without re-downloading the production panel of script/download.R.
# Output: data/raw/msci_em.csv
# ===================================================================

MSCI_URL <- paste0(
  "https://app2.msci.com/products/service/index/indexmaster/",
  "getLevelDataForGraph?currency_symbol=USD&index_variant=STRD",
  "&start_date=20100101&end_date=20251231",
  "&data_frequency=END_OF_MONTH&index_codes=891800"
)

msci_em <- jsonlite::fromJSON(MSCI_URL)$indexes$INDEX_LEVELS |>
  tibble::as_tibble() |>
  dplyr::transmute(
    ref.date = lubridate::floor_date(
      lubridate::ymd(calc_date),
      "month"
    ),
    msci_em = level_eod
  )

readr::write_csv(msci_em, "data/raw/msci_em.csv")
