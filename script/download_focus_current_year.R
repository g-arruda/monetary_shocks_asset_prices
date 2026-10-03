# ===================================================================
# Focus medians for the CURRENT calendar year of the six annual series the
# panel carries as "ano seguinte", read on the same survey date as those
# series: the last survey of each month that has a next-year median.
# script/clean.R combines them with the next-year medians already in
# data/raw/raw_data.csv and data/raw/focus_fiscal_expectations.csv into the
# fixed-horizon approximation of Dovern, Fritsche and Slacalek (2012). A
# stage of its own so that it runs without re-downloading the production
# panel of script/download.R.
#
# The Focus stops asking for a target year once its value is settled: the
# current-year Selic disappears after the year's last Copom meeting, the
# current-year exchange rate in late December. Such months are left NA,
# never filled with an earlier survey.
# Output: data/raw/focus_current_year.csv
# ===================================================================

source("R/data_download/focus.R")

SURVEY_START <- as.Date("2012-03-01")
SURVEY_END   <- as.Date("2025-12-31")
INDICATORS <- c(
  expect_focus_selic_cy = "Selic",
  expect_focus_pib_cy = "PIB Total",
  expect_focus_cambio_cy = "Câmbio",
  expect_focus_fiscal_dlsp_cy = "Dívida líquida do setor público",
  expect_focus_fiscal_primary_balance_cy = "Resultado primário",
  expect_focus_fiscal_nominal_balance_cy = "Resultado nominal"
)

current_year <- purrr::imap(INDICATORS, function(indicator, variable) {
  medians <- fetch_focus_annual(indicator, SURVEY_START, SURVEY_END) |>
    dplyr::arrange(date)
  current_year_medians <- medians |>
    dplyr::filter(reference_year == lubridate::year(date)) |>
    dplyr::distinct(date, .keep_all = TRUE)
  medians |>
    dplyr::filter(reference_year == lubridate::year(date) + 1L) |>
    dplyr::mutate(ref.date = lubridate::floor_date(date, "month")) |>
    dplyr::group_by(ref.date) |>
    dplyr::summarise(date = max(date)) |>
    dplyr::left_join(current_year_medians, by = "date") |>
    dplyr::select(ref.date, !!variable := value)
}) |>
  purrr::reduce(dplyr::left_join, by = "ref.date")

readr::write_csv(current_year, "data/raw/focus_current_year.csv")
