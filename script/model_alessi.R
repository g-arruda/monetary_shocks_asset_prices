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
                      r = results_bai_ng$r_hat$IC2,
                      q = results_amengual_watson$q_hat, p = 6,
                      h = 50, nboot = 800, bootstrap_seed = 123,
                      mp_var = "juros_selic", shock_size_bps = 50,
                      tcode = NULL, ci_levels = c(0.90, 0.95)) {
  
  # Load and prepare data (preservar ref.date para alinhamento)
  raw_data <- readr::read_csv(data_path) |>
    tidyr::drop_na()

  dates <- as.Date(raw_data$ref.date)

  data <- raw_data |>
    dplyr::select(-ref.date) |>
    as.matrix()

  # Definir tcodes por nome de variável se não fornecido
  if (is.null(tcode)) {
    tcode <- infer_tcode_from_varnames(colnames(data))
  }

  # Definir variável de política monetária para normalização do choque
  if (is.character(mp_var)) {
    mpind <- match(mp_var, colnames(data))
    if (is.na(mpind)) {
      stop("Variavel de politica monetaria '", mp_var, "' nao encontrada nos dados")
    }
  } else if (is.numeric(mp_var) && length(mp_var) == 1) {
    mpind <- as.integer(mp_var)
    if (mpind < 1 || mpind > ncol(data)) {
      stop("Indice mp_var fora do intervalo de colunas do painel")
    }
  } else {
    stop("mp_var deve ser nome (character) ou indice (numeric) de coluna")
  }

  # 50 bps -> 0.5 (mesma normalizacao do MATLAB original)
  normalize_value <- shock_size_bps / 100

  # Load instrument
  instrument <- readr::read_csv(instrument_path)

  # Estimate SDFM com datas e instrumento para alinhamento temporal
  # apply_kilian = TRUE: computa coeficientes corrigidos para o DGP do bootstrap
  # O ponto estimado usa VAR OLS (sem Kilian), fiel ao DFMest_BLL.m
  dfm_results <- estimate_dfm(data, r, q, p, dates = dates, instrument = instrument,
                              apply_kilian = TRUE)
  
  # Validate results
  validation <- validate_dfm_results(dfm_results)
  if (length(validation$missing_components) > 0) {
    warning("Missing DFM components: ", paste(validation$missing_components, collapse = ", "))
  }
  
  # Compute IRFs with wild bootstrap (instrumento e datas já embutidos no dfm_results)
  irf_results <- compute_irf_dfm(
    dfm_results,
    h = h,
    nboot = nboot,
    bootstrap_seed = bootstrap_seed,
    mpind = mpind,
    normalize_value = normalize_value,
    tcode = tcode,
    ci_levels = ci_levels
  )

  return(list(
    model = dfm_results,
    irfs = irf_results,
    data = data,
    tcode = tcode,
    mpind = mpind,
    normalize_value = normalize_value
  ))
}

# Set global seed for reproducibility
set.seed(123)

# Execute main analysis
sdfm_results <- main_sdfm(
  r = 8,
  q = 8,
  p = 6,
  shock_size_bps = 50,
  mp_var = "juros_selic",
  ci_levels = c(0.90),
  nboot = 100
)



colnames(sdfm_results$data)


# Generate IRF plots for key economic variables
response_vars <- list(
  c("Cambio USD" = 5),
  c("yield 6m" = 8),
  c("yield 5y" = 12), 
  c("Spread Juridica" = 26),
  c("vendas varejo" = 38),
  c("vendas automoveis" = 40),
  c("pib" = 55),
  c("ipca" = 73),
  c("nucle ipca ex0" = 75)
)

# IRF plots - escolha entre cumulative = TRUE ou FALSE
irf_plot <- plot_irf(sdfm_results$irfs,
  response_vars = response_vars,
  shock = 1,
  horizon = 50,
  cumulative = FALSE,
  var_names = colnames(sdfm_results$data),
  tcode = sdfm_results$tcode,
  ci_to_plot = c(0.90)
)

print(irf_plot)
