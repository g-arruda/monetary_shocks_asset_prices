# ===================================================================
# DFM principal: especificação de produção no painel de 111 séries, com
# r decidido pelo Bai--Ng IC2 e q=5 mantido como escolha operacional
# provisória. Instrumento: data/processed/instrument.csv = z_jk_bs_purif
# (default desde 2026-07-15; máscara JK em resíduos pré-evento BS).
# Bootstrap wild nboot=800 (Gonçalves-Kilian), correção de viés Kilian só
# no DGP do bootstrap.
# Saída: output/irf/irf_model_alessi_r5q5.pdf
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/nongaussian_branch.R")

SPEC <- production_spec()

set.seed(SPEC$bootstrap_seed)

sdfm_results <- main_sdfm(
  r = SPEC$r,
  q = SPEC$q,
  p = SPEC$p,
  shock_size_bps = SPEC$shock_bps,
  mp_var = SPEC$mp_var,
  ci_levels = SPEC$ci_levels,
  nboot = SPEC$nboot
)

# Generate IRF plots for key economic variables. Os indices abaixo foram
# verificados contra colnames(data) em 2026-05-08; trocar para nome (string)
# se a ordem do painel mudar.
response_vars <- list(
  c("ipca"              = "price_ipca"),
  c("ipca difusao"      = "price_ipca_difusao"),
  c("ipca core ex0"     = "price_core_ipca_ex0"),
  c("ipca core ex1"     = "price_core_ipca_ex1"),
  c("ipca core dw"      = "price_core_ipca_dw"),
  c("commodity agro"    = "commodity_agro"),
  c("commodity metal"   = "commodity_metal"),
  c("commodity energia" = "commodity_energia"),
  c("EMBI+"             = "embi_perc"),
  c("CDS 5Y"            = "cds_5y")
)

irf_plot <- plot_irf(sdfm_results$irfs,
  response_vars = response_vars,
  shock = 1,
  horizon = SPEC$horizon,
  cumulative = FALSE,
  var_names = colnames(sdfm_results$data),
  tcode = sdfm_results$tcode,
  ci_to_plot = c(0.68, 0.90)
)

print(irf_plot)

ggplot2::ggsave(SPEC$model_output, irf_plot,
                width = 11, height = 9, dpi = 200)
