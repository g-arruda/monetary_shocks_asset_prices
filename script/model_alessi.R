rm(list = ls())

# Load required libraries
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
# The het identification branch was archived on 2026-07-26 (empirically rejected
# 2026-07-16). Production runs identification = "proxy"; to revive the het branch
# source arquivo/R/identification/het_{shock_extraction,primary}.R first.



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
                      tcode = NULL, ci_levels = c(0.90, 0.95),
                      identification = c("proxy", "het"),
                      het_weight = "optimal") {

  # Ramo het (Rigobon 2003, regimes mensais Copom/nao-Copom sobre as
  # inovacoes do factor-VAR): implementado e validado, mas REPROVADO
  # pelos gates de viabilidade em todo o grid (2026-07-16) — o placebo
  # de permutacao nao distingue os labels do calendario (p_perm
  # 0.26-0.86) e a proporcionalidade Sigma_C ~ Sigma_NC nunca e
  # rejeitada, e o mesmo para regimes de episodio (BPSS 2021). Codigo e
  # artefatos arquivados em 2026-07-26; ver _instrucoes/historico_decisoes.md
  # secao 1.2. Producao segue "proxy" (z_jk_bs_purif).
  identification <- match.arg(identification)

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

  # Instrumento so no ramo proxy; no ramo het o painel fica integral
  # (sem trimming de alinhamento) e a identificacao vem dos regimes.
  instrument <- NULL
  if (identification == "proxy") {
    instrument <- readr::read_csv(instrument_path)
  }

  # Estimate SDFM com datas e instrumento para alinhamento temporal
  # apply_kilian = TRUE: computa coeficientes corrigidos para o DGP do bootstrap
  # O ponto estimado usa VAR OLS (sem Kilian), fiel ao DFMest_BLL.m
  dfm_results <- estimate_dfm(data, r, q, p, dates = dates, instrument = instrument,
                              apply_kilian = TRUE)

  regime_labels <- NULL
  if (identification == "het") {
    regimes <- build_monthly_regimes(month_range = range(dates))
    regime_labels <- align_regimes_to_eta(dfm_results$dates, p, regimes)
  }
  
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
    var_names = colnames(data),
    identification = identification,
    regime_labels = regime_labels,
    het_weight = het_weight
  )

  return(list(
    model = dfm_results,
    irfs = irf_results,
    data = data,
    tcode = tcode,
    mpind = mpind,
    normalize_value = normalize_value,
    identification = identification
  ))
}

# Set global seed for reproducibility
set.seed(123)

# Execute main analysis
# Especificação de produção r=7, q=6, p=6 (movida de (6,5) em 2026-07-24 após o
# refresh de vintage). Sob a régua MOSW, (7,6) é a única dimensão da varredura com
# ξ_mp > 10 nas duas janelas (10.43 full / 12.22 pre_covid), enquanto (6,5) caiu
# para a zona AR no full (6.36) — ver output/instrument/mosw_strength_grid.md.
# Instrumento: data/processed/instrument.csv = z_jk_bs_purif (default desde
# 2026-07-15; máscara JK em resíduos pré-evento BS). Bootstrap wild nboot=800
# (Gonçalves-Kilian), correção de viés Kilian só no DGP do bootstrap.
sdfm_results <- main_sdfm(
  r = 7L,
  q = 6L,
  p = 6,
  shock_size_bps = 50,
  mp_var = "yield_6m",
  ci_levels = c(0.68, 0.90),
  nboot = 800
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

ggplot2::ggsave("output/irf/irf_model_alessi_r7q6.pdf", irf_plot,
                width = 11, height = 9, dpi = 200)
