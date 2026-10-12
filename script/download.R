# ===================================================================
# Single network entry point: downloads every reproducible raw input (BCB
# SGS, Focus/Olinda, Yahoo, B3, IPEA, SIDRA), reads the fixed external inputs
# and writes data/raw/raw_data.csv (112 monthly series) plus the four daily
# files the instrument is built from. The fixed external inputs are checked by
# the preflight of script/run_all.R.
# ===================================================================

source("R/data_download/bcb.R")
source("R/data_download/exchange.R")
source("R/data_download/external_factors.R")
source("R/data_download/focus.R")
source("R/data_download/b3.R")
source("R/data_download/ipea.R")

# Production monthly window; the daily inputs run to the end of its last month
PRODUCTION_START <- as.Date("2012-03-01")
PRODUCTION_END   <- as.Date("2025-12-01")
EXTENSION_START  <- as.Date("2010-01-01")
DAILY_START      <- as.Date("2010-01-01")
DAILY_END        <- as.Date("2025-12-31")
N_RAW_SERIES     <- 112L
CURRENCIES <- c("BRL", "EUR", "CNY", "ARS", "INR")
B3_NAMES <- c(
  IBOV = "asset_ibov",
  SMLL = "asset_smll",
  IDIV = "asset_idiv",
  IFIX = "asset_ifix",
  IFNC = "asset_ifnc",
  IMAT = "asset_imat",
  IMOB = "asset_imob",
  MLCX = "asset_mlcx"
)

# rb3 registers its download templates only when the package is attached.
rb3_cache <- file.path("data", "raw", "cache", "rb3")
dir.create(rb3_cache, showWarnings = FALSE, recursive = TRUE)
options(rb3.cachedir = rb3_cache)
suppressPackageStartupMessages(library(rb3))

focus <- download_focus_data(
  from = DAILY_START,
  to = DAILY_END,
  sample_start = EXTENSION_START,
  sample_end = PRODUCTION_END
)
external_factors <- download_external_factors(DAILY_START, DAILY_END)
brl_usd_daily <- download_brl_usd_daily(DAILY_START, DAILY_END)

# B3 indices ----

b3_daily <- download_b3_indices(names(B3_NAMES), DAILY_START, DAILY_END)
ibov_daily <- b3_daily |>
  dplyr::filter(symbol == "IBOV") |>
  dplyr::transmute(date, ibov = price)
if (anyDuplicated(ibov_daily$date) || anyNA(ibov_daily)) {
  stop("Daily IBOV data are incomplete or duplicated.")
}

# Monthly returns compounded from the daily ones
indices <- b3_daily |>
  dplyr::mutate(asset = unname(B3_NAMES[symbol])) |>
  dplyr::group_by(asset) |>
  dplyr::arrange(date, .by_group = TRUE) |>
  dplyr::mutate(return = price / dplyr::lag(price) - 1) |>
  dplyr::ungroup() |>
  dplyr::mutate(ref.date = lubridate::floor_date(date, "month")) |>
  dplyr::group_by(asset, ref.date) |>
  dplyr::summarise(
    return = prod(1 + return, na.rm = TRUE) - 1,
    .groups = "drop"
  ) |>
  tidyr::pivot_wider(names_from = asset, values_from = return) |>
  dplyr::select(
    ref.date,
    asset_ibov,
    asset_idiv,
    asset_ifix,
    asset_ifnc,
    asset_imat,
    asset_imob,
    asset_mlcx,
    asset_smll
  ) |>
  tidyr::drop_na()

if (anyDuplicated(indices$ref.date) ||
    any(!is.finite(as.matrix(indices[, -1])))) {
  stop("Monthly B3 index returns are incomplete, duplicated, or non-finite.")
}

exchange_rates <- download_cambio(CURRENCIES, end_date = DAILY_END) |>
  dplyr::rename(ref.date = date)

# Banco Central do Brasil ----

## Interest rates and the yield curve ----
interest_codes <- c(
  "selic" = 4189,
  "cdi" = 4392
)

interest_rates <- download_bcb_data(interest_codes, parallel = FALSE) |>
  dplyr::rename_with(\(name) paste0("juros_", name), -ref.date)

fiscal_codes <- c(
  fiscal_dbgg = 13762,
  fiscal_dlsp = 4513,
  fiscal_primary_balance = 4649
)

fiscal <- download_bcb_data(
  fiscal_codes,
  start_date = EXTENSION_START,
  end_date = PRODUCTION_END,
  parallel = FALSE
)

yield_curve <- readr::read_csv(
  "data/raw/yields/yields_dia.csv",
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(data = lubridate::dmy(data)) |>
  dplyr::rename(
    yield_3m = x3,
    yield_6m = x6,
    yield_1y = x12,
    yield_2y = x24,
    yield_5y = x60,
    yield_10y = x120
  )

if (anyNA(yield_curve$data)) {
  stop("data/raw/yields/yields_dia.csv contains invalid dates.")
}

# The last quotation of each month
monthly_yield_curve <- yield_curve |>
  dplyr::group_by(ref.date = lubridate::floor_date(data, "month")) |>
  dplyr::slice_max(order_by = data, n = 1, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::select(-data)

interest_rates <- interest_rates |>
  dplyr::left_join(monthly_yield_curve, by = "ref.date")

## Monetary base ----
monetary_base_codes <- c(
  "monetary_base" = 1788,
  "money_supply" = 27789,
  "demand_deposit" = 27790,
  "savings_deposit" = 1835,
  "m1" = 27791,
  "m2" = 27810,
  "m3" = 27813
)

monetary_base <- download_bcb_data(monetary_base_codes, parallel = FALSE) |>
  dplyr::rename_with(\(name) paste0("base_", name), -ref.date)

## Credit ----
credit_codes <- c(
  "credito_agro" = 22027,
  "credito_industria_total" = 22043,
  "credito_construcao" = 22030,
  "credito_comercio" = 22036,
  "credito_transporte" = 22037,
  "credito_pessoa_fisica" = 22050,
  "spread_credito_pj_total" = 20784,
  "spread_credito_pf_total" = 20785,
  "credit_outstanding" = 20542,
  "fin_inst_reserve_req" = 17633
)

credit <- download_bcb_data(
  credit_codes,
  start_date = "2010-01-01",
  parallel = FALSE
)

## Consumption ----
consumption_codes <- c(
  "consumo_gasolina" = 1393,
  "consumo_glp" = 1394,
  "consumo_oleo_combustivel" = 1395,
  "consumo_oleo_diesel" = 1396,
  "consumo_demais_derivados" = 1397,
  "consumo_alcool" = 1401,
  "capacidade_instalada_industria" = 28554,
  "vendas_varejo" = 1455,
  "vendas_servicos" = 23982
)

consumption <- download_bcb_data(
  consumption_codes,
  start_date = "2010-01-01",
  parallel = FALSE
)

## Economic activity ----
activity_codes <- c(
  "pib" = 4381,
  "ibc_br" = 24364,
  "icc" = 4393,
  "ics" = 17660
)

activity <- download_bcb_data(
  activity_codes,
  start_date = "2010-01-01",
  parallel = FALSE
)

## Industry ----
industry_codes <- c(
  "ind_automoveis" = 7384,
  "ind_leves" = 7385,
  "ind_caminhoes" = 7386,
  "ind_onibus" = 7387,
  "ind_bens_consumo" = 21865,
  "ind_bens_duraveis" = 21866,
  "ind_bens_nao_duraveis" = 21867,
  "ind_bens_capital" = 21863,
  "ind_transformacao" = 21862,
  "ind_min_extr" = 21861,
  "ind_uti_cap_instalada" = 24352
)

industry <- download_bcb_data(
  industry_codes,
  start_date = "2010-01-01",
  parallel = FALSE
)

## Energy ----
energy_codes <- c(
  "energia_comercial" = 1402,
  "energia_residencial" = 1403,
  "energia_industrial" = 1404,
  "energia_outros" = 1405
)

energy <- download_bcb_data(
  energy_codes,
  start_date = "2010-01-01",
  parallel = FALSE
)

## Labor market ----
employment_codes <- c(
  "employment_southest" = 13901,
  "employment_south" = 13564,
  "employment_northeast" = 13941,
  "employment_north" = 28152,
  "employment_central_west" = 21991,
  "min_wage" = 1619,
  "pop_forca_trab" = 24378,
  "pop_ocupada" = 28543,
  "tx_desemprego" = 24369,
  "hrs_trabalhadas_industria" = 28556
)

employment <- download_bcb_data(
  employment_codes,
  start_date = "2012-01-01",
  parallel = FALSE
) |>
  dplyr::rename_with(\(name) paste0("trab_", name), -ref.date)

# Risk ----

embi_daily <- readr::read_csv(
  "data/raw/banco_central_rep_dominicana/embi_brasil.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(data = lubridate::dmy(date))

if (anyNA(embi_daily$data)) {
  stop(
    "data/raw/banco_central_rep_dominicana/embi_brasil.csv contains invalid ",
    "dates."
  )
}

embi <- embi_daily |>
  dplyr::group_by(ref.date = lubridate::floor_date(data, "month")) |>
  dplyr::slice_max(order_by = data, n = 1, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::select(ref.date, embi_perc)

# The two investing.com CSVs come in pt-BR format ("138,19"). Under readr's
# default locale the comma is read as a THOUSANDS separator and every value
# comes in 100x inflated (13819). The error is pure scale, so BLL
# standardization absorbs it and no factor or IRF changes -- but every number
# reported from these two series would come out 100x wrong. The panel's msci,
# the MSCI Emerging Markets index, comes from script/download_msci.R and
# enters in script/clean.R.
locale_br <- readr::locale(decimal_mark = ",", grouping_mark = ".")

cds <- readr::read_csv(
  "data/raw/investing/cds5y.csv",
  locale = locale_br,
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(data)) |>
  dplyr::select(ref.date, cds_5y = ultimo)

sp500_vix <- readr::read_csv(
  "data/raw/investing/sp500_vix.csv",
  locale = locale_br,
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(data)) |>
  dplyr::select(ref.date, sp500_vix = ultimo)

risk <- embi |>
  dplyr::left_join(cds, by = "ref.date") |>
  dplyr::left_join(sp500_vix, by = "ref.date") |>
  tidyr::drop_na()

# Economic policy uncertainty ----

# The sheet ends in footnote rows whose Year is not a number
epu <- readxl::read_excel("data/raw/epu/economic_policy_uncertainty.xlsx") |>
  dplyr::transmute(
    year = suppressWarnings(as.integer(Year)),
    month = as.integer(Month),
    Brazil,
    Canada,
    Chile,
    China,
    Germany,
    India,
    Russia,
    US
  ) |>
  dplyr::filter(is.finite(year), is.finite(month)) |>
  dplyr::mutate(ref.date = as.Date(sprintf("%04d-%02d-01", year, month))) |>
  dplyr::select(-year, -month) |>
  dplyr::rename_with(\(name) paste0("epu_", tolower(name)), -ref.date)

# Prices ----

price_codes <- c(
  "ipca" = 433,
  "ipca_difusao" = 21379,
  "core_ipca_ex0" = 11427,
  "core_ipca_ex1" = 16121,
  "core_ipca_dw" = 16122,
  "igp_m" = 189,
  "ipc" = 191,
  "core_ipc" = 4467,
  "incc" = 192,
  "inpc" = 188
)

ipp <- download_ipea_series("IPP12_IPPCG12") |>
  dplyr::select(ref.date = date, ipp = value)

prices <- download_bcb_data(price_codes, parallel = FALSE) |>
  dplyr::left_join(ipp, by = "ref.date") |>
  tidyr::drop_na() |>
  dplyr::rename_with(\(name) paste0("price_", name), -ref.date)

# Commodities ----

commodity_codes <- c(
  "commodity_agro" = 27575,
  "commodity_metal" = 27576,
  "commodity_energia" = 27577
)

commodities <- download_bcb_data(commodity_codes, parallel = FALSE)

# Job-search time (quarterly) ----

# SIDRA table 1616 is quarterly: each quarter is spread over its three months
# and every series is interpolated by a cubic spline
job_search <- sidrar::get_sidra(
  1616,
  variable = 4092,
  geo = "Brazil",
  period = "all"
) |>
  dplyr::select(Trimestre, `Tempo de procura de trabalho`, Valor) |>
  dplyr::filter(`Tempo de procura de trabalho` != "Total") |>
  tidyr::pivot_wider(
    names_from = `Tempo de procura de trabalho`,
    values_from = Valor
  ) |>
  janitor::clean_names() |>
  dplyr::mutate(
    trimestre = trimestre |>
      stringr::str_extract("\\d{1}º trimestre \\d{4}") |>
      stringr::str_replace("(\\d{1})º trimestre (\\d{4})", "\\2-Q\\1") |>
      lubridate::yq(),
    month = purrr::map(trimestre, function(quarter_start) {
      seq.Date(quarter_start, by = "month", length.out = 3)
    })
  ) |>
  tidyr::unnest(month) |>
  dplyr::select(-trimestre) |>
  dplyr::mutate(
    dplyr::across(
      -month,
      \(values) spline(x = as.numeric(month), y = values, n = length(month))$y
    )
  ) |>
  dplyr::mutate(
    ref.date = lubridate::floor_date(month, "month"),
    .before = 1
  ) |>
  dplyr::select(-month) |>
  dplyr::arrange(ref.date) |>
  dplyr::rename_with(\(name) paste0("trab_", name), -ref.date)

employment <- employment |>
  dplyr::left_join(job_search, by = "ref.date")

# One monthly panel ----

raw_panel <- list(
  exchange_rates,
  interest_rates,
  monetary_base,
  credit,
  consumption,
  industry,
  energy,
  activity,
  employment,
  prices,
  commodities,
  indices,
  risk,
  epu,
  fiscal,
  focus$monthly
) |>
  purrr::reduce(dplyr::left_join, by = "ref.date") |>
  dplyr::arrange(ref.date)

expected_dates <- seq(PRODUCTION_START, PRODUCTION_END, by = "month")
production_sample <- raw_panel |>
  dplyr::filter(ref.date >= PRODUCTION_START, ref.date <= PRODUCTION_END)
if (ncol(raw_panel) - 1L != N_RAW_SERIES || anyDuplicated(names(raw_panel))) {
  stop("The raw monthly panel must contain exactly 112 unique useful series.")
}
if (!identical(as.Date(production_sample$ref.date), expected_dates) ||
    anyNA(production_sample) ||
    any(!is.finite(as.matrix(production_sample[, -1])))) {
  stop(
    "The raw monthly panel must cover 2012-03 through 2025-12 without gaps ",
    "or non-finite values."
  )
}

daily_outputs <- list(
  focus_daily = focus$daily,
  ibov_daily = ibov_daily,
  brl_usd_daily = brl_usd_daily,
  external_factors = external_factors
)
# A daily input is invalid when it is empty, when its dates are missing or
# repeated, or when one of its series is entirely missing or holds a
# non-finite number
daily_is_invalid <- purrr::map_lgl(daily_outputs, function(daily) {
  date_column <- if ("date" %in% names(daily)) "date" else names(daily)[1]
  dates <- as.Date(daily[[date_column]])
  series <- daily[setdiff(names(daily), date_column)]
  any_series_empty <- any(purrr::map_lgl(series, \(values) all(is.na(values))))
  any_non_finite <- any(purrr::map_lgl(series, function(values) {
    is.numeric(values) && any(!is.finite(values[!is.na(values)]))
  }))
  anyNA(dates) || anyDuplicated(dates) > 0 || nrow(daily) == 0L ||
    any_series_empty || any_non_finite
})
if (any(daily_is_invalid)) {
  stop(
    "Downloaded daily inputs are empty, incomplete, or duplicated: ",
    paste(names(daily_outputs)[daily_is_invalid], collapse = ", "),
    "."
  )
}

dir.create("data/raw/investing", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(raw_panel, "data/raw/raw_data.csv")
readr::write_csv(focus$daily, "data/raw/focus_daily.csv")
readr::write_csv(
  focus$fiscal_monthly,
  "data/raw/focus_fiscal_expectations.csv"
)
readr::write_csv(ibov_daily, "data/raw/ibov_daily.csv")
readr::write_csv(brl_usd_daily, "data/raw/brl_usd_daily.csv")
readr::write_csv(
  external_factors,
  "data/raw/investing/external_factors_daily.csv"
)
