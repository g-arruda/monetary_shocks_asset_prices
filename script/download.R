source("R/data_download/bcb.R")
source("R/data_download/exchange.R")
source("R/data_download/external_factors.R")
source("R/data_download/focus.R")
source("R/data_download/fred.R")
source("R/data_download/b3.R")
source("R/data_download/fomc.R")
source("R/data_download/ipea.R")

sample_start <- as.Date("2013-01-01")
sample_end <- as.Date("2025-09-01")
daily_start <- as.Date("2012-01-01")
daily_end <- as.Date("2026-02-01")
required_external_files <- c(
  "data/raw/yields/yields_dia.csv",
  "data/raw/banco_central_rep_dominicana/embi_brasil.csv",
  "data/raw/investing/cds5y.csv",
  "data/raw/investing/msci.csv",
  "data/raw/investing/sp500_vix.csv",
  "data/raw/epu/economic_policy_uncertainty.csv"
)
missing_external_files <- required_external_files[!file.exists(required_external_files)]
if (length(missing_external_files) > 0L) {
  stop(
    "Required fixed external inputs are missing: ",
    paste(missing_external_files, collapse = ", "),
    "."
  )
}

# rb3 registers its download templates only when the package is attached.
options(rb3.cachedir = file.path(tempdir(), "rb3-cache"))
suppressPackageStartupMessages(library(rb3))

arguments <- commandArgs(trailingOnly = TRUE)
if (length(arguments) > 0L) {
  stop("script/download.R does not accept arguments.")
}

focus <- download_focus_data(
  from = daily_start,
  to = as.Date("2025-12-31"),
  sample_start = sample_start,
  sample_end = sample_end
)
fred_dgs2 <- download_fred_series(
  "DGS2",
  from = daily_start,
  to = as.Date("2025-12-31")
) |>
  dplyr::rename(ust2y = value)
external_factors <- download_external_factors(daily_start, daily_end)
brl_usd_daily <- download_brl_usd_daily(daily_start, daily_end)
fomc_dates <- download_fomc_dates(daily_start, as.Date("2026-12-31"))

b3_symbols <- c("IBOV", "SMLL", "IDIV", "IFIX", "IFNC", "IMAT", "IMOB", "MLCX")
b3_names <- c(
  IBOV = "asset_ibov",
  SMLL = "asset_smll",
  IDIV = "asset_idiv",
  IFIX = "asset_ifix",
  IFNC = "asset_ifnc",
  IMAT = "asset_imat",
  IMOB = "asset_imob",
  MLCX = "asset_mlcx"
)
b3_daily <- download_b3_indices(b3_symbols, daily_start, daily_end)
ibov_daily <- b3_daily |>
  dplyr::filter(symbol == "IBOV") |>
  dplyr::transmute(date, ibov = price)
if (anyDuplicated(ibov_daily$date) || anyNA(ibov_daily)) {
  stop("Daily IBOV data are incomplete or duplicated.")
}

indices <- b3_daily |>
  dplyr::mutate(asset = unname(b3_names[symbol])) |>
  dplyr::group_by(asset) |>
  dplyr::arrange(date, .by_group = TRUE) |>
  dplyr::mutate(return = price / dplyr::lag(price) - 1) |>
  dplyr::ungroup() |>
  dplyr::mutate(ref.date = lubridate::floor_date(date, "month")) |>
  dplyr::group_by(asset, ref.date) |>
  dplyr::summarise(return = prod(1 + return, na.rm = TRUE) - 1, .groups = "drop") |>
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

if (anyDuplicated(indices$ref.date) || any(!is.finite(as.matrix(indices[, -1])))) {
  stop("Monthly B3 index returns are incomplete, duplicated, or non-finite.")
}

moedas <- c("BRL", "EUR", "CNY", "ARS", "INR")

cambio <- download_cambio(moedas, end_date = daily_end) |>
  dplyr::rename(ref.date = date)


# Dados do Banco Central do Brasil ----

# Primeiro vamos pegar os dados mensais
## Dados referente a juros ----
vec_juros <- c(
  "selic" = 4189,
  "cdi" = 4392
  # "cdb_rdb" = 28618 # Taxa média acumulada no mês de instituições financeiras
)

juros <- download_bcb_data(vec_juros, parallel = TRUE) |>
  dplyr::rename_with(~ paste0("juros_", .), -ref.date)

vec_fiscal <- c(
  fiscal_dbgg = 13762,
  fiscal_dlsp = 4513,
  fiscal_primary_balance = 4649
)

fiscal <- download_bcb_data(
  vec_fiscal,
  start_date = sample_start,
  end_date = sample_end,
  parallel = FALSE
)


# curva de juros ----
yield_curve <- readr::read_csv(
  "data/raw/yields/yields_dia.csv",
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(
    data = lubridate::dmy(data)
  ) |>
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

monthly_yield_curve <- yield_curve |>
  dplyr::group_by(ref.date = lubridate::floor_date(data, "month")) |>
  dplyr::slice_max(order_by = data, n = 1, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::select(-data)

if (anyDuplicated(monthly_yield_curve$ref.date)) {
  stop("Monthly yield curve contains more than one observation per month.")
}

juros <- juros |>
  dplyr::left_join(monthly_yield_curve, by = "ref.date")


## Monetary base ----
vec_base_monetaria <- c(
  "monetary_base" = 1788,
  "money_supply" = 27789,
  "demand_deposit" = 27790,
  "savings_deposit" = 1835,
  "m1" = 27791,
  "m2" = 27810,
  "m3" = 27813
)

base_monetaria <- download_bcb_data(vec_base_monetaria, parallel = TRUE) |>
  dplyr::rename_with(~ paste0("base_", .), -ref.date)



## Dados de crédito ----
vec_credito <- c(
  "credito_agro" = 22027,
  "credito_industria_total" = 22043,
  "credito_construcao" = 22030,
  # "credito_siup" = 22034,
  "credito_comercio" = 22036,
  "credito_transporte" = 22037,
  "credito_pessoa_fisica" = 22050,
  "spread_icc_juridica" = 27444,
  "spread_icc_fisica" = 27445,
  "credit_outstanding" = 20542,
  "fin_inst_reserve_req" = 17633
)

credito <- download_bcb_data(vec_credito, start_date = "2010-01-01", parallel = TRUE)


## Consumo ----

vec_consumo <- c(
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


consumo <- download_bcb_data(
  vec_consumo,
  start_date = "2010-01-01",
  parallel = TRUE)





## Atividade econômica ----

vec_ativ_economica <- c(
  "pib" = 4381,
  "ibc_br" = 24364,
  "icc" = 4393,
  "ics" = 17660
)

ativ_economica <- download_bcb_data(
  vec_ativ_economica,
  start_date = "2010-01-01",
  parallel = TRUE
)




## Industria ----

vec_industria <- c(
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

industria <- download_bcb_data(
  vec_industria,
  start_date = "2010-01-01",
  parallel = TRUE
)



## Energia ----


vec_energia <- c(
  "energia_comercial" = 1402,
  "energia_residencial" = 1403,
  "energia_industrial" = 1404,
  "energia_outros" = 1405
)

energia <- download_bcb_data(
  vec_energia,
  start_date = "2010-01-01",
  parallel = TRUE
)




## Dados sobre emprego ----

vec_emprego <- c(
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


emprego <- download_bcb_data(vec_emprego, start_date = "2012-01-01", parallel = TRUE) |>
  dplyr::rename_with(~ paste0("trab_", .), -ref.date)
 




## Dados risco ----

embi_daily <- readr::read_csv(
  "data/raw/banco_central_rep_dominicana/embi_brasil.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(data = lubridate::dmy(date))

if (anyNA(embi_daily$data)) {
  stop("data/raw/banco_central_rep_dominicana/embi_brasil.csv contains invalid dates.")
}

embi <- embi_daily |>
  dplyr::group_by(ref.date = lubridate::floor_date(data, "month")) |>
  dplyr::slice_max(order_by = data, n = 1, with_ties = FALSE) |>
  dplyr::ungroup() |>
  dplyr::select(ref.date, embi_perc)

if (anyDuplicated(embi$ref.date)) {
  stop("Monthly EMBI+ series contains more than one observation per month.")
}

# Os tres CSVs da investing.com vem no formato pt-BR ("138,19"). Sob o locale
# default do readr a virgula e lida como separador de MILHAR, e cada valor
# entra 100x inflado (13819). O erro e de escala pura, entao a padronizacao
# BLL o absorve e nenhum fator/IRF muda — mas todo numero reportado dessas
# tres series saia 100x errado. Corrigido em 2026-07-28.
locale_br <- readr::locale(decimal_mark = ",", grouping_mark = ".")

cds <- readr::read_csv(
  "data/raw/investing/cds5y.csv",
  locale = locale_br,
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(data)) |>
  dplyr::select(ref.date, cds_5y = ultimo)


msci <- readr::read_csv(
  "data/raw/investing/msci.csv",
  locale = locale_br,
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(data)) |>
  dplyr::select(ref.date, msci = ultimo)


sp500_vix <- readr::read_csv(
  "data/raw/investing/sp500_vix.csv",
  locale = locale_br,
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(data)) |>
  dplyr::select(ref.date, sp500_vix = ultimo)


risco <- embi |>
  dplyr::left_join(cds, by = "ref.date") |>
  dplyr::left_join(msci, by = "ref.date") |>
  dplyr::left_join(sp500_vix, by = "ref.date") |>
  tidyr::drop_na()




## economic_policy_uncertainty ----

epu <- readr::read_csv(
  "data/raw/epu/economic_policy_uncertainty.csv",
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(date)) |>
  dplyr::select(-date) |>
  dplyr::rename_with(~ paste0("epu_", .), -ref.date)



## Dados sobre inflacao ----

vec_inflacao <- c(
  "ipca" = 433,
  "ipca_difusao" = 21379,
  "core_ipca_ex0" = 29677,
  "core_ipca_ex1" = 29678,
  "core_ipca_dw" = 16122, 
  "igp_m" = 189,
  "ipc" = 191,
  "core_ipc" = 4467,
  "incc" = 192,
  "inpc" = 188
)

ipp <- download_ipea_series("IPP12_IPPCG12") |>
  dplyr::select(ref.date = date, ipp = value)


inflacao <- download_bcb_data(vec_inflacao, parallel = TRUE) |>
  dplyr::left_join(ipp, by = "ref.date") |>
  tidyr::drop_na() |>
  dplyr::rename_with(~ paste0("price_", .), -ref.date)



## Dados sobre commodities ----

vec_commodity <- c(
  "commodity_agro" = 27575,
  "commodity_metal" = 27576,
  "commodity_energia" = 27577
)

commodity <- download_bcb_data(vec_commodity, parallel = TRUE)



# Dados trimestrais ----
# aqui vamos ter que fazer uma interpolação dos dados para transformar para mensal

tempo_procura_trab <- sidrar::get_sidra(1616, variable = 4092, geo = "Brazil", period = "all") |>
  dplyr::select(Trimestre, `Tempo de procura de trabalho`, Valor) |>
  dplyr::filter(`Tempo de procura de trabalho` != "Total") |>
  tidyr::pivot_wider(
    names_from = `Tempo de procura de trabalho`,
    values_from = Valor
  ) |>
  janitor::clean_names() |>
  dplyr::mutate(
    trimestre = stringr::str_extract(trimestre, "\\d{1}º trimestre \\d{4}"),
    # Primeiro vamos criar o formato ano-trimestre (exemplo: 2012-Q1)
    trimestre = stringr::str_replace(trimestre, "(\\d{1})º trimestre (\\d{4})", "\\2-Q\\1"),
    # Agora convertemos para data usando yearquarter do tsibble
    trimestre = tsibble::yearquarter(trimestre)
  )


# Criar sequência mensal
dados_mensais <- tempo_procura_trab |>
  # Criar datas mensais
  dplyr::mutate(
    data_inicio = as.Date(trimestre),
    meses = purrr::map(data_inicio, ~ seq.Date(
      from = .,
      by = "month",
      length.out = 3
    ))
  ) |>
  tidyr::unnest(meses) |>
  dplyr::select(-trimestre, -data_inicio)



# Aplicar interpolação spline para cada coluna
colunas_interpoladas <- dados_mensais |>
  dplyr::mutate(
    dplyr::across(
      .cols = -meses,
      .fns = ~ stats::spline(
        x = as.numeric(meses),
        y = .,
        n = length(meses)
      )$y
    )
  )

# Formatar resultado final
resultado_mensal <- colunas_interpoladas |>
  dplyr::mutate(
    mes = lubridate::floor_date(meses, "month")
  ) |>
  dplyr::select(ref.date = mes, dplyr::everything(), -meses) |>
  dplyr::arrange(ref.date) |>
  dplyr::rename_with(~ paste0("trab_", .), -ref.date)



emprego <- emprego |>
  dplyr::left_join(resultado_mensal, by = "ref.date")

# Juntando tudo em apenas um df ----

all_dfs <- list(
  cambio = cambio,
  juros = juros,
  base_monetaria = base_monetaria,
  credito = credito,
  consumo = consumo,
  industria = industria,
  energia = energia,
  ativ_economica = ativ_economica,
  emprego = emprego,
  inflacao = inflacao,
  commodity = commodity,
  indices = indices,
  risco = risco,
  epu = epu,
  fiscal = fiscal,
  focus = focus$monthly
)




merged_df <- all_dfs |>
  purrr::reduce(dplyr::left_join, by = "ref.date") |>
  dplyr::arrange(ref.date)

expected_dates <- seq(sample_start, sample_end, by = "month")
production_sample <- merged_df |>
  dplyr::filter(ref.date >= sample_start, ref.date <= sample_end)
if (ncol(merged_df) - 1L != 113L || anyDuplicated(names(merged_df))) {
  stop("The raw monthly panel must contain exactly 113 unique useful series.")
}
if (!identical(as.Date(production_sample$ref.date), expected_dates) ||
    anyNA(production_sample) ||
    any(!is.finite(as.matrix(production_sample[, -1])))) {
  stop("The raw monthly panel must cover 2013-01 through 2025-09 without gaps or non-finite values.")
}

daily_outputs <- list(
  focus_daily = focus$daily,
  ibov_daily = ibov_daily,
  brl_usd_daily = brl_usd_daily,
  external_factors = external_factors,
  fred_dgs2 = fred_dgs2,
  fomc_dates = fomc_dates
)
invalid_daily <- names(daily_outputs)[vapply(daily_outputs, function(data) {
  date_column <- if ("date" %in% names(data)) "date" else names(data)[1]
  dates <- as.Date(data[[date_column]])
  values <- data[setdiff(names(data), date_column)]
  all_missing <- any(vapply(values, function(value) all(is.na(value)), logical(1)))
  non_finite <- any(vapply(values, function(value) {
    is.numeric(value) && any(!is.finite(value[!is.na(value)]))
  }, logical(1)))
  anyNA(dates) || anyDuplicated(dates) || nrow(data) == 0L || all_missing || non_finite
}, logical(1))]
if (length(invalid_daily) > 0L) {
  stop(
    "Downloaded daily inputs are empty, incomplete, or duplicated: ",
    paste(invalid_daily, collapse = ", "),
    "."
  )
}

dir.create("data/raw/investing", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(merged_df, "data/raw/raw_data.csv")
readr::write_csv(focus$daily, "data/raw/focus_daily.csv")
readr::write_csv(ibov_daily, "data/raw/ibov_daily.csv")
readr::write_csv(brl_usd_daily, "data/raw/brl_usd_daily.csv")
readr::write_csv(external_factors, "data/raw/investing/external_factors_daily.csv")
readr::write_csv(fred_dgs2, "data/raw/fred_dgs2.csv")
readr::write_csv(fomc_dates, "data/raw/fomc_dates.csv")
