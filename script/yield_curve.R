rm(list = ls())

library(dplyr)
library(readr)
library(ggplot2)
library(lubridate)

source("R/modeling/svensson_model.R")



di_data <- read_csv("data/di.csv", show_col_types = FALSE)


# Meses líquidos nos dois formatos de ticker da B3:
# Formato antigo (até mai/2006): DI1FEV5, DI1MAR5, ... (3 letras em português)
# Formato novo  (pós mai/2006):  DI1F07,  DI1H26,  ... (1 letra CME + 2 dígitos do ano)
meses_liquidos_antigo <- c("JAN", "FEV", "MAR", "ABR", "MAI", "JUN",
                           "JUL", "AGO", "SET", "OUT", "NOV", "DEZ")
meses_liquidos_novo   <- c("F", "G", "H", "J", "K", "M",
                           "N", "Q", "U", "V", "X", "Z")

dados_preparados <- di_data %>%
  mutate(
    ref_date = as.Date(TradeDate),
    matur_date = as.Date(ExpirationDate),
    
    # Maturidade em anos usando dias úteis (padrão DI/B3: DU/252)
    maturity_years = BDaysToExp / 252,
    
    yield_bid = SettlementRate,
    
    # Detectar formato do ticker e extrair código do mês
    ticker_suffix = substr(TickerSymbol, 4, nchar(TickerSymbol)),
    is_old_format = nchar(ticker_suffix) == 4,  # ex: "FEV5" = 4 chars
    ticker_month = ifelse(is_old_format,
                          substr(ticker_suffix, 1, 3),  # "FEV"
                          substr(ticker_suffix, 1, 1))   # "F"
  ) %>%
  filter(
    # Filtrar contratos válidos em ambos os formatos
    (is_old_format & ticker_month %in% meses_liquidos_antigo) |
      (!is_old_format & ticker_month %in% meses_liquidos_novo),
    
    # Filtrar dados válidos
    !is.na(yield_bid),
    !is.na(maturity_years),
    maturity_years > 0
  ) %>%
  select(ref_date, matur_date, maturity_years, yield_bid) %>%
  arrange(ref_date, maturity_years)


# Selecionar uma data recente com bastante dados
data_exemplo <- dados_preparados %>%
  group_by(ref_date) %>%
  summarise(n = n(), .groups = "drop") %>%
  filter(n >= 6) %>%
  arrange(desc(ref_date)) %>%
  slice(1) %>%
  pull(ref_date)



# Extrair dados para esta data
dados_data <- dados_preparados %>%
  filter(ref_date == data_exemplo) %>%
  arrange(maturity_years)



fit_result <- fit_svensson(
  maturities = dados_data$maturity_years,
  rates = dados_data$yield_bid,
  return_diagnostics = TRUE
)

# Exibir resultados
cat("\n=== PARÂMETROS ESTIMADOS ===\n")
cat(sprintf("β₀ (Nível):           %.6f\n", fit_result$params[1]))
cat(sprintf("β₁ (Inclinação):      %.6f\n", fit_result$params[2]))
cat(sprintf("β₂ (Curvatura 1):     %.6f\n", fit_result$params[3]))
cat(sprintf("β₃ (Curvatura 2):     %.6f\n", fit_result$params[4]))
cat(sprintf("τ₁ (Decaimento 1):    %.6f\n", fit_result$params[5]))
cat(sprintf("τ₂ (Decaimento 2):    %.6f\n", fit_result$params[6]))

cat("\n=== MÉTRICAS DE QUALIDADE ===\n")
cat(sprintf("RMSE:                 %.6f\n", fit_result$rmse))
cat(sprintf("MAE:                  %.6f\n", fit_result$mae))
cat(sprintf("R²:                   %.4f\n", fit_result$r_squared))
cat(sprintf("Convergência:         %d (0 = sucesso)\n", fit_result$convergence))
cat(sprintf("Iterações:            %d\n", fit_result$iterations))

cat("\n=== CARACTERÍSTICAS DA CURVA ===\n")
cat(sprintf("Nível (taxa longa):   %.4f%%\n", fit_result$level * 100))
cat(sprintf("Inclinação:           %.4f%%\n", fit_result$slope * 100))
cat(sprintf("Curvatura:            %.4f%%\n", fit_result$curvatura * 100))

