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
results_amengual_watson <- amengual_watson(X,
  r = results_bai_ng$r_hat$IC2, p = 12, max_q = 15, apply_bll = TRUE
)





main_sdfm <- function(data_path = "data/processed/data_log_deseasonalized.csv",
                      instrument_path = "data/processed/instrument.csv",
                      r = results_bai_ng$r_hat$IC2,
                      q = results_amengual_watson$q_hat, p = 6,
                      h = 50, nboot = 800, bootstrap_seed = 123,
                      mp_var = "yield_6m", shock_size_bps = 50,
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

  # `yield_6m` is stored in decimal proportion (0.0975 = 9.75%); a +50bp
  # shock in proportion is therefore 0.005, not 0.5. The earlier convention
  # (`/ 100`) implicitly normalized to +5000bp and was corrected on
  # 2026-05-07. See `_instrucoes/justificativa_uso_yield-6m.md`.
  normalize_value <- shock_size_bps / 10000

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
    ci_levels = ci_levels,
    var_names = colnames(data)
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
# Override explícito r=6, q=5 (2026-07-11, varredura de especificações):
# o auto-IC (r = bai_ng IC2 = 5, q = amengual_watson = 4) é borderline-weak
# para z_jk_purif no full sample (F factor-space = 9.20 < 10) e produz
# pib com sinal invertido em h24. (6,5) cruza Stock-Yogo no full (F = 10.08)
# e é o pico do pre_covid (F = 15.4) — ver output/irf/spec_sweep_conclusoes.md
# e output/irf/spec_sweep_cells.csv. A família JK também cruza em (7,6) e (8,8).
# Instrumento: data/processed/instrument.csv = z_jk_bs_purif (default desde
# 2026-07-15; máscara JK em resíduos pré-evento BS — auditoria de fidelidade).
# Sob a régua MOSW, (6,5) é forte no pre_covid (ξ_mp = 12.49) e fica na zona
# AR no full (ξ_mp = 6.94 > 3.84) — ver mosw_strength_grid.md.
sdfm_results <- main_sdfm(
  r = 8L,
  q = 8L,
  p = 3 ,
  shock_size_bps = 50,
  mp_var = "yield_6m",
  ci_levels = c(0.68, 0.90),
  nboot = 200
)



colnames(sdfm_results$data)


# Generate IRF plots for key economic variables. Os indices abaixo foram
# verificados contra colnames(data) em 2026-05-08; trocar para nome (string)
# se a ordem do painel mudar.
response_vars <- list(
  c("Cambio USD"            = "cambio_usd"),
  c("CDS 5y"                = "cds_5y"),
  c("yield 6m"              = "yield_6m"),
  c("yield 5y"              = "yield_5y"),
  c("Spread ICC juridica"   = "spread_icc_juridica"),
  c("ibov"                  = "asset_ibov"),
  c("imob"                  = "asset_imob"),
  c("ifix"                  = "asset_ifix"),
  c("pib"                   = "pib"),
  c("ipca"                  = "price_ipca")

)

# IRF plots - escolha entre cumulative = TRUE ou FALSE
irf_plot <- plot_irf(sdfm_results$irfs,
  response_vars = response_vars,
  shock = 1,
  horizon = 50,
  cumulative = FALSE,
  var_names = colnames(sdfm_results$data),
  tcode = sdfm_results$tcode,
  ci_to_plot = c(0.68, 0.90)
)

print(irf_plot)

ggplot2::ggsave("output/irf/irf_model_alessi_r6q5.pdf", irf_plot,
                width = 11, height = 9, dpi = 200)
