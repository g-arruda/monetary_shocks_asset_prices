rm(list = ls())

# Load required libraries
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")



X <- readr::read_csv("data/processed/data_log_deseasonalized.csv") |> 
    dplyr::select(-ref.date) |>
    tidyr::drop_na()

# Aplicar bai_ng_criteria com a padronização BLL para lidar com dados não-estacionários
results_bai_ng <- bai_ng_criteria(X, max_r = 20, apply_bll = TRUE)



# Aplicar amengual_watson assumindo r = 8 e p = 6
results_amengual_watson <- amengual_watson(X, r = 8, p = 6, max_q = 15, apply_bll = TRUE)





main_sdfm <- function(data_path = "data/processed/data_log_deseasonalized.csv",
                      instrument_path = "data/processed/instrument.csv",
                      r = 8, q = 8, p = 6, h = 50, nboot = 800, bootstrap_seed = 123) {
  
  # Load and prepare data (preservar ref.date para alinhamento)
  raw_data <- readr::read_csv(data_path) |>
    tidyr::drop_na()

  dates <- as.Date(raw_data$ref.date)

  data <- raw_data |>
    dplyr::select(-ref.date) |>
    dplyr::select(
      dplyr::contains("consumo_"),
      dplyr::contains("vendas_"),
      dplyr::contains("veiculos_"),
      dplyr::contains("producao_"),
      capacidade_instalada_industria,
      dplyr::contains("trab_"),
      dplyr::contains("price_"),
      dplyr::contains("cambio_"),
      dplyr::contains("commodity_"),
      dplyr::contains("juros_"),
      dplyr::contains("titulo_"),
      # retorno_mensal,
      dplyr::contains("spread_"),
      dplyr::contains("credito_"),
      dplyr::contains("asset_")
    ) |>
    as.matrix()

  # Load instrument
  instrument <- readr::read_csv(instrument_path)

  # Estimate SDFM com datas e instrumento para alinhamento temporal
  dfm_results <- estimate_dfm(data, r, q, p, dates = dates, instrument = instrument)
  
  # Validate results
  validation <- validate_dfm_results(dfm_results)
  if (length(validation$missing_components) > 0) {
    warning("Missing DFM components: ", paste(validation$missing_components, collapse = ", "))
  }
  
  # Compute IRFs with wild bootstrap (instrumento e datas já embutidos no dfm_results)
  irf_results <- compute_irf_dfm(dfm_results, h = h, nboot = nboot, bootstrap_seed = bootstrap_seed)

  return(list(
    model = dfm_results,
    irfs = irf_results,
    data = data
  ))
}

# Set global seed for reproducibility
set.seed(123)

# Execute main analysis
sdfm_results <- main_sdfm(r = 8, q = 8, p = 6)



# Generate IRF plots for key economic variables
response_vars <- list(
  c("vnd_varejo" = 11),
  c("vnd_servi" = 12),
  c("commodity_agro" = 44), 
  c("commodity_energ" = 46),
  c("igpm" = 34),
  c("incc" = 36),
  c("inpc" = 37),
  c("cred_ind" = 61),
  c("cred_agro" = 60),
  c("cred_fisica" = 65)
)

# IRF plots - escolha entre cumulative = TRUE ou FALSE
irf_plot <- plot_irf(sdfm_results$irfs$irf_ci,
  response_vars = response_vars,
  shock = 1,
  horizon = 50,
  cumulative = FALSE
)

print(irf_plot)


