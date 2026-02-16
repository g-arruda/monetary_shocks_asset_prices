# Getting auxiliary functions ----
source("R/data_download/bcb.R")
source("R/data_download/exchange.R")
source("R/modeling/svensson_model.R")


# Taxa de cambio ----

moedas <- c("BRL", "EUR", "CNY", "ARS", "INR")

cambio <- download_cambio(moedas, end_date = "2026-02-01") |> dplyr::rename(ref.date = date)

dplyr::glimpse(cambio)
tail(cambio)

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


dplyr::glimpse(juros)
tail(juros)


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
  "spread_icc_fisica" = 27445
)

credito <- download_bcb_data(vec_credito, start_date = "2010-01-01", parallel = TRUE)

dplyr::glimpse(credito)
tail(credito)

## Dados sobre atividade economica ----

vec_ativ_economica <- c(
  "veiculos_automoveis" = 7384,
  "veiculos_leves" = 7385,
  "veiculos_caminhoes" = 7386,
  "veiculos_onibus" = 7387,
  "consumo_gasolina" = 1393,
  "consumo_glp" = 1394,
  "consumo_oleo_combustivel" = 1395,
  "consumo_oleo_diesel" = 1396,
  "consumo_demais_derivados" = 1397,
  "consumo_alcool" = 1401,
  "consumo_eletricidade_comecial" = 1402,
  "consumo_eletricidade_residencial" = 1403,
  "consumo_eletricidade_industrial" = 1404,
  "consumo_eletricidade_outros" = 1405,
  "producao_bens_consumo" = 21865,
  "producao_bens_duraveis" = 21866,
  "producao_bens_nao_duraveis" = 21867,
  "producao_bens_capital" = 21863,
  "producao_transformacao" = 21862,
  "capacidade_instalada_industria" = 28554,
  "vendas_varejo" = 1455,
  "vendas_servicos" = 23982
)


ativ_economica <- download_bcb_data(
  vec_ativ_economica,
  start_date = "2010-01-01",
  parallel = TRUE)

dplyr::glimpse(ativ_economica)
tail(ativ_economica)

## Dados sobre emprego ----

vec_emprego <- c(
  "caged" = 28763,
  "pop_forca_trab" = 24378,
  "pop_ocupada" = 28543,
  "tx_desemprego" = 24369,
  "hrs_trabalhadas_industria" = 28556
)


emprego <- download_bcb_data(vec_emprego, start_date = "2012-01-01", parallel = TRUE) |>
  dplyr::mutate(
    razao_vagas_desempregados = caged / ((tx_desemprego / 100) * (pop_forca_trab * 1000))
  ) |>
  tidyr::drop_na() |>
  dplyr::rename_with(~ paste0("trab_", .), -ref.date)
 

dplyr::glimpse(emprego)
tail(emprego)

## Dados sobre inflacao ----

vec_inflacao <- c(
  "ipca" = 433,
  # "ipa" = 255,
  "igp_m" = 189,
  "ipc" = 191,
  "incc" = 192,
  "inpc" = 188
)

ipp <- ipeadatar::ipeadata("IPP12_IPPCG12") |>
  dplyr::select(ref.date = date, ipp = value)


inflacao <- download_bcb_data(vec_inflacao, parallel = TRUE) |>
  dplyr::left_join(ipp, by = "ref.date") |>
  tidyr::drop_na() |>
  dplyr::rename_with(~ paste0("price_", .), -ref.date)


dplyr::glimpse(inflacao)
tail(inflacao)

## Dados sobre commodities ----

vec_commodity <- c(
  "indice_commodity_agro" = 27575,
  "indice_commodity_metal" = 27576,
  "indice_commodity_energia" = 27577
)

commodity <- download_bcb_data(vec_commodity, parallel = TRUE)

dplyr::glimpse(commodity)
tail(commodity)


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


dplyr::glimpse(resultado_mensal)
tail(resultado_mensal)

# Dados da B3 ----

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



dplyr::glimpse(indices)
tail(indices)


# Série dos titulos de maturidade Fixa ----

# curva de juros ----
yield_curve <- readr::read_csv("data/curva_juros/series_maturidades_fixas.csv") |>
  janitor::clean_names() |> 
  dplyr::select(data, dplyr::starts_with("titulo"))



# ida <- readr::read_csv("data/raw/mp_index/IDADI-HISTORICO - Historico.csv") |>
#   janitor::clean_names() |>
#   dplyr::select(ref.date = data_de_referencia, ida = variacao_diaria_percent) |>
#   dplyr::mutate(ref.date = lubridate::dmy(ref.date))

# ida_mensal <- ida |>
#   # Criar colunas de ano e mês para agrupamento
#   dplyr::mutate(
#     ref.date = lubridate::floor_date(ref.date, "month")
#   ) |>
#   # Agrupar por mês
#   dplyr::group_by(ref.date) |>
#   # Calcular retorno mensal
#   dplyr::summarise(
#     retorno_mensal = (prod(1 + ida / 100) - 1)
#   ) |>
#   # Ordenar por data
#   dplyr::arrange(ref.date)




monthly_yield_curve <- yield_curve |>
  dplyr::group_by(ref.date = lubridate::floor_date(data, "month")) |>
  dplyr::slice_tail(n = 1) |>
  dplyr::ungroup() |>
  dplyr::select(-data)
  # dplyr::left_join(ida_mensal, by = "ref.date")

dplyr::glimpse(monthly_yield_curve)
tail(monthly_yield_curve) |> t()

# Juntando tudo em apenas um df ----

all_dfs <- list(
  cambio = cambio,
  juros = juros,
  credito = credito,
  ativ_economica = ativ_economica,
  emprego = emprego,
  inflacao = inflacao,
  commodity = commodity,
  tempo_procura = resultado_mensal,
  indices = indices,
  fixed_maturity_yield = monthly_yield_curve
)

dplyr::glimpse(all_dfs)

merged_df <- all_dfs |>
  purrr::reduce(dplyr::left_join, by = "ref.date") |>
  dplyr::arrange(ref.date)


nrow(merged_df)
ncol(merged_df)

# readr::write_csv(merged_df, "data/raw_data.csv")







####################################################################
####################################################################
####################################################################
####################################################################
####################################################################
####################################################################





