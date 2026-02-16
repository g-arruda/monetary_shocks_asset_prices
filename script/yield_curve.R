library(tidyverse)
library(lubridate)

source("R/modeling/svensson_model.R")

# Ler dados
di_data <- read_csv("data/di.csv", show_col_types = FALSE)

# Preparar dados
meses_liquidos_antigo <- c("JAN", "FEV", "MAR", "ABR", "MAI", "JUN",
                           "JUL", "AGO", "SET", "OUT", "NOV", "DEZ")
meses_liquidos_novo <- c("F", "G", "H", "J", "K", "M", 
                         "N", "Q", "U", "V", "X", "Z")

pattern_antigo <- paste0("^DI1(", paste(meses_liquidos_antigo, collapse = "|"), ")\\d{2}$")
pattern_novo <- paste0("^DI1[", paste(meses_liquidos_novo, collapse = ""), "]\\d{2}$")

dados_preparados <- di_data |>
  mutate(
    ref_date = as.Date(TradeDate),
    matur_date = as.Date(ExpirationDate),
    maturity_years = BDaysToExp / 252,
    yield_bid = SettlementRate,
    year = year(ref_date)
  ) |>
  filter(
    str_detect(TickerSymbol, pattern_antigo) | str_detect(TickerSymbol, pattern_novo),
    maturity_years > 0,
    year >= 2010
  ) |>
  select(ref_date, matur_date, maturity_years, yield_bid) |>
  arrange(ref_date, maturity_years)

# Definir vértices de maturidade (em anos)
vertices <- c(0.25, 0.5, 1, 2, 3, 4, 5, 7, 10)

# Função para processar cada data
processar_data_completo <- function(maturities, rates, target_maturities) {
  fit_result <- fit_svensson(maturities, rates, return_diagnostics = TRUE)
  
  fitted_rates <- svensson_rate(
    target_maturities,
    fit_result$params[1], fit_result$params[2], fit_result$params[3],
    fit_result$params[4], fit_result$params[5], fit_result$params[6]
  )
  
  list(
    rates = fitted_rates,
    beta0 = fit_result$params[1],
    beta1 = fit_result$params[2],
    beta2 = fit_result$params[3],
    beta3 = fit_result$params[4],
    tau1 = fit_result$params[5],
    tau2 = fit_result$params[6],
    n_obs = length(maturities),
    rmse = fit_result$rmse,
    r_squared = fit_result$r_squared,
    convergence = fit_result$convergence
  )
}

# Processar todas as datas
resultados <- dados_preparados |>
  group_by(ref_date) |>
  filter(n() >= 6) |>
  summarise(
    resultado = list(processar_data_completo(maturity_years, yield_bid, vertices)),
    .groups = "drop"
  )

# Extrair séries de maturidades
col_names <- paste0("titulo_", gsub("\\.", "_", as.character(vertices)), "ano")
rates_matrix <- map(resultados$resultado, ~ .x$rates) |> reduce(rbind)

series_maturidades <- tibble(data = resultados$ref_date) |>
  bind_cols(as_tibble(rates_matrix, .name_repair = ~col_names)) |>
  mutate(
    n_obs = map_dbl(resultados$resultado, ~ .x$n_obs),
    rmse = map_dbl(resultados$resultado, ~ .x$rmse),
    r_squared = map_dbl(resultados$resultado, ~ .x$r_squared),
    convergence = map_dbl(resultados$resultado, ~ .x$convergence)
  )

# Extrair séries de parâmetros
series_parametros <- tibble(
  data = resultados$ref_date,
  beta0 = map_dbl(resultados$resultado, ~ .x$beta0),
  beta1 = map_dbl(resultados$resultado, ~ .x$beta1),
  beta2 = map_dbl(resultados$resultado, ~ .x$beta2),
  beta3 = map_dbl(resultados$resultado, ~ .x$beta3),
  tau1 = map_dbl(resultados$resultado, ~ .x$tau1),
  tau2 = map_dbl(resultados$resultado, ~ .x$tau2),
  n_obs = map_dbl(resultados$resultado, ~ .x$n_obs),
  rmse = map_dbl(resultados$resultado, ~ .x$rmse),
  r_squared = map_dbl(resultados$resultado, ~ .x$r_squared),
  convergence = map_dbl(resultados$resultado, ~ .x$convergence)
)

# Salvar resultados
dir.create("data/curva_juros", showWarnings = FALSE, recursive = TRUE)

readr::write_csv(series_maturidades, "data/curva_juros/series_maturidades_fixas.csv")
readr::write_csv(series_parametros, "data/curva_juros/series_parametros_svensson.csv")





