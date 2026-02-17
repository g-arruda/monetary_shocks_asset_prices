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

# # Aplicar bai_ng_criteria
# results_bai_ng <- bai_ng_criteria(X, max_r = 20)

# # Visualizar o número ótimo de fatores para cada critério
# print(results_bai_ng$r_hat)

# # Aplicar amengual_watson com 3 fatores estáticos
# results_amengual_watson <- amengual_watson(X, r = 10, p = 3)

# # Visualizar o número estimado de fatores dinâmicos
# print(results_amengual_watson$q_hat)



main_sdfm <- function(data_path = "data/processed/data_log_deseasonalized.csv",
                      r = 7, q = 5, p = 1, h = 50, nboot = 800, bootstrap_seed = 123) {
  
  # Load and prepare data
  data <- readr::read_csv(data_path) |>
    dplyr::select(-ref.date) |>
    tidyr::drop_na() |>
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

  # colnames(data)[colnames(data) == "retorno_mensal"] <- "ida"
  
  # Estimate SDFM
  dfm_results <- estimate_dfm(data, r, q, p)
  
  # Validate results
  validation <- validate_dfm_results(dfm_results)
  if (length(validation$missing_components) > 0) {
    warning("Missing DFM components: ", paste(validation$missing_components, collapse = ", "))
  }
  
  # Compute IRFs with wild bootstrap
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
sdfm_results <- main_sdfm()

# data.frame(
#   coluna = colnames(sdfm_results$data)
# )

# Generate IRF plots for key economic variables
response_vars <- list(
  c("USD/BRL" = 43),
  c("Spread-J" = 58),
  c("Spread-F" = 59), 
  c("IPCA" = 33),
  c("IPP" = 38),
  c("IBRx-100" = 66),
  c("IMob" = 71),
  # c("IDA" = 54),
  c("Yield - 1A" = 51),
  c("Yield - 10A" = 57)
)

# IRF plots - escolha entre cumulative = TRUE ou FALSE
irf_plot <- plot_irf(sdfm_results$irfs$irf_ci,
  response_vars = response_vars,
  shock = 3,
  horizon = 50,
  cumulative = FALSE       
)

print(irf_plot)

# Save plot
# ggplot2::ggsave("img/irf_monetary_shock.png", irf_plot,
#   width = 10, height = 10, dpi = 320
# )
