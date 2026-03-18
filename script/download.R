# Getting auxiliary functions ----
source("R/data_download/bcb.R")
source("R/data_download/exchange.R")
source("R/modeling/svensson_model.R")


# Taxa de cambio ----

moedas <- c("BRL", "EUR", "CNY", "ARS", "INR")

cambio <- download_cambio(moedas, end_date = "2026-02-01") |> dplyr::rename(ref.date = date)


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


# curva de juros ----
yield_curve <- readr::read_csv("data/yields/yields_dia.csv") |>
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


monthly_yield_curve <- yield_curve |>
  dplyr::group_by(ref.date = lubridate::floor_date(data, "month")) |>
  dplyr::slice_tail(n = 1) |>
  dplyr::ungroup() |>
  dplyr::select(-data)


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

embi <- readr::read_csv("data/banco_central_rep_dominicana/embi_brasil.csv") |>
  dplyr::mutate(data = lubridate::dmy(date)) |>
  dplyr::group_by(ref.date = lubridate::floor_date(data, "month")) |>
  dplyr::slice_tail(n = 1) |>
  dplyr::ungroup() |>
  dplyr::select(ref.date, embi_perc)


cds <- readr::read_csv("data/investing/cds5y.csv") |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(data)) |>
  dplyr::select(ref.date, cds_5y = ultimo)


msci <- readr::read_csv("data/investing/msci.csv") |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(data)) |>
  dplyr::select(ref.date, msci = ultimo)


sp500_vix <- readr::read_csv("data/investing/sp500_vix.csv") |>
  janitor::clean_names() |>
  dplyr::mutate(ref.date = lubridate::dmy(data)) |>
  dplyr::select(ref.date, sp500_vix = ultimo)


risco <- embi |>
  dplyr::left_join(cds, by = "ref.date") |>
  dplyr::left_join(msci, by = "ref.date") |>
  dplyr::left_join(sp500_vix, by = "ref.date") |>
  tidyr::drop_na()




## economic_policy_uncertainty ----

epu <- readr::read_csv("data/epu/economic_policy_uncertainty.csv") |>
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

ipp <- ipeadatar::ipeadata("IPP12_IPPCG12") |>
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
    across(
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
  dplyr::select(ref.date = mes, everything(), -meses) |>
  dplyr::arrange(ref.date) |>
  dplyr::rename_with(~ paste0("trab_", .), -ref.date)



emprego <- emprego |>
  dplyr::left_join(resultado_mensal, by = "ref.date")

# Mercado financeiro ----

# Definir a pasta de cache
options(rb3.cachedir = "~/rb3-cache")

# Define os índices da B3 (CORRETOS)
indices_b3 <- c("IBOV", "SMLL", "IDIV", "IFIX", "IFNC", "IMAT", "IMOB", "MLCX")


library(rb3)
# Baixar dados históricos dos índices
rb3::fetch_marketdata(
  "b3-indexes-historical-data",
  index = indices_b3,
  year = 2010:2026,
  throttle = TRUE
)

# Baixar e processar dados de todos os índices
indices <- indices_b3 |>
  purrr::set_names(
    c(
      "asset_ibov", "asset_smll", "asset_idiv", "asset_ifix",
      "asset_ifnc", "asset_imat", "asset_imob", "asset_mlcx"
    )
  ) |>
  purrr::imap(~ {
    rb3::indexes_historical_data_get() |>
      dplyr::filter(
        symbol == .x,
        refdate >= "2010-01-01",
        refdate <= "2026-01-01"
      ) |>
      dplyr::collect() |>
      janitor::clean_names() |>
      dplyr::select(ref.date = refdate, ultimo = value) |>
      dplyr::rename(!!.y := ultimo)
  }) |>
  purrr::reduce(dplyr::left_join, by = "ref.date") |>
  tidyr::pivot_longer(
    cols = -ref.date,
    names_to = "asset",
    values_to = "price"
  ) |>
  dplyr::arrange(asset, ref.date) |>
  dplyr::group_by(asset) |>
  dplyr::mutate(
    return = (price / dplyr::lag(price) - 1)
  ) |>
  dplyr::ungroup() |>
  dplyr::select(-price) |>
  dplyr::mutate(
    ref.date = lubridate::floor_date(ref.date, "month")
  ) |>
  dplyr::group_by(asset, ref.date) |>
  dplyr::summarise(
    return = prod(1 + return, na.rm = TRUE) - 1,
    .groups = "drop"
  ) |>
  tidyr::pivot_wider(names_from = asset, values_from = return) |>
  tidyr::drop_na()













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
  tempo_procura = resultado_mensal,
  indices = indices,
  risco = risco,
  epu = epu
)




merged_df <- all_dfs |>
  purrr::reduce(dplyr::left_join, by = "ref.date") |>
  dplyr::arrange(ref.date)




















