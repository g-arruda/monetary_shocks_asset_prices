# ===================================================================
# DFM principal: especificação de produção no painel de 115 séries, com
# r=q=5. Instrumento: data/processed/instrument.csv = z_jk_bs_purif
# (default desde 2026-07-15; máscara JK em resíduos pré-evento BS).
# Inferência: conjuntos Anderson-Rubin (`production_spec()$inference`), a
# régua operacional do DFM desde 2026-09-08. Nenhuma réplica é sorteada aqui.
# Saída: output/irf/irf_model_alessi_r5q5.pdf
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")

SPEC <- production_spec()

panel <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |>
  dplyr::select(-ref.date) |>
  as.matrix()
bai_ng <- bai_ng_criteria(panel, max_r = 20L, apply_bll = TRUE)
bai_ng_surface <- tibble::tibble(
  r = seq_len(20L),
  IC1 = bai_ng$criteria$IC1,
  IC2 = bai_ng$criteria$IC2,
  IC3 = bai_ng$criteria$IC3
)
if (!identical(unname(unlist(bai_ng$r_hat)), c(5L, 5L, 20L))) {
  stop("The production BLL Bai-Ng surface must select IC1=5, IC2=5, and IC3=20.")
}
dir.create(dirname(SPEC$bai_ng_output), showWarnings = FALSE, recursive = TRUE)
readr::write_csv(bai_ng_surface, SPEC$bai_ng_output)

sdfm_results <- main_sdfm(
  r = SPEC$r,
  q = SPEC$q,
  p = SPEC$p,
  shock_size_bps = SPEC$shock_bps,
  mp_var = SPEC$mp_var,
  ci_levels = SPEC$ci_levels,
  nboot = 0L
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

ggplot2::ggsave(SPEC$model_output, irf_plot,
                width = 11, height = 9, dpi = 200)
