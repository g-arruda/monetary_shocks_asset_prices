# ===================================================================
# DFM principal: especificação de produção no painel de 115 séries, com
# r=q=5. Instrumento: data/processed/instrument.csv = z_jk_bs_purif
# (default desde 2026-07-15; máscara JK em resíduos pré-evento BS).
# Inferência: conjuntos Anderson-Rubin, a régua operacional do DFM desde
# 2026-09-08.
# Saída: output/irf/irf_model_alessi_r5q5.pdf
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/factor_selection.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")

PANEL_PATH <- "data/processed/data_log_deseasonalized.csv"
BAI_NG_OUT <- "output/factors/production_bai_ng_bll_surface.csv"
IRF_OUT    <- "output/irf/irf_model_alessi_r5q5.pdf"
R_FACTORS  <- 5L        # BLL Bai-Ng IC1 = IC2 = 5 over r = 1..20
Q_DYNAMIC  <- 5L        # q = r, operational decision
P_LAGS     <- 4L
HORIZON    <- 48L
MP_VAR     <- "yield_6m"
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.68, 0.90)

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  dplyr::select(-ref.date) |>
  as.matrix()
bai_ng <- bai_ng_criteria(panel, max_r = 20L, apply_bll = TRUE)
bai_ng_surface <- tibble::tibble(
  r = seq_len(20L),
  IC1 = bai_ng$criteria$IC1,
  IC2 = bai_ng$criteria$IC2,
  IC3 = bai_ng$criteria$IC3
)
dir.create(dirname(BAI_NG_OUT), showWarnings = FALSE, recursive = TRUE)
readr::write_csv(bai_ng_surface, BAI_NG_OUT)

sdfm_results <- main_sdfm(
  data_path = PANEL_PATH,
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_LAGS,
  h = HORIZON,
  shock_size_bps = SHOCK_BPS,
  mp_var = MP_VAR,
  ci_levels = CI_LEVELS
)

response_vars <- c(
  "ipca"              = "price_ipca",
  "ipca difusao"      = "price_ipca_difusao",
  "ipca core ex0"     = "price_core_ipca_ex0",
  "ipca core ex1"     = "price_core_ipca_ex1",
  "ipca core dw"      = "price_core_ipca_dw",
  "commodity agro"    = "commodity_agro",
  "commodity metal"   = "commodity_metal",
  "commodity energia" = "commodity_energia",
  "EMBI+"             = "embi_perc",
  "CDS 5Y"            = "cds_5y"
)

irf_plot <- plot_irf(sdfm_results$irfs,
  response_vars = response_vars,
  horizon = HORIZON,
  var_names = colnames(sdfm_results$data),
  ci_to_plot = c(0.68, 0.90)
)

ggplot2::ggsave(IRF_OUT, irf_plot,
                width = 11, height = 9, dpi = 200)
