# ===================================================================
# Daily PTAX, the BCB's official BRL/USD rate (SGS 1, selling quote), for the
# Copom-day exchange-rate change of script/daily_event.R. The PTAX of a day
# is the average of four consultation windows between 10h and 13h
# (Circular 3.506), so the Wednesday quote precedes the announcement, made
# after the close, and the Thursday quote follows it. The Yahoo BRL=X file of
# script/download.R cannot serve here: it stamps its bars at London midnight,
# and in the European winter its row dated d moves with session d-1
# (output/daily_event/fx_alignment.csv). A stage of its own so that it runs
# without re-downloading the production panel of script/download.R.
# Output: data/raw/ptax_daily.csv
# ===================================================================

source("R/data_download/bcb.R")

ptax <- download_bcb_data(1, start_date = "2012-01-01", end_date = "2025-12-31") |>
  dplyr::transmute(date = ref.date, ptax = `id = 1`)

readr::write_csv(ptax, "data/raw/ptax_daily.csv")
