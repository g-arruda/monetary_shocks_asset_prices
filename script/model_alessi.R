# ===================================================================
# Main DFM: the production specification on the 115-series panel, r = q = 5.
# Instrument: data/processed/instrument.csv = z_bs_purif (Bauer-Swanson
# pre-event orthogonalization). Inference: Anderson-Rubin sets.
# Outputs: output/factors/production_bai_ng_bll_surface.csv
#          output/irf/irf_model_alessi_r5q5.pdf
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/factor_selection.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")

PANEL_PATH <- "data/processed/data_log_deseasonalized.csv"
BAI_NG_OUT <- "output/factors/production_bai_ng_bll_surface.csv"
IRF_OUT    <- "output/irf/irf_model_alessi_r5q5.pdf"
MAX_R      <- 20L
R_FACTORS  <- 5L        # BLL Bai-Ng IC1 = IC2 = 5 over r = 1..20
Q_DYNAMIC  <- 5L        # q = r, operational decision
P_LAGS     <- 4L
HORIZON    <- 48L
MP_VAR     <- "yield_6m"
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.80, 0.90)
RESPONSE_VARS <- c(
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

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  dplyr::select(-ref.date) |>
  as.matrix()
bai_ng <- bai_ng_criteria(panel, max_r = MAX_R, apply_bll = TRUE)
dir.create(dirname(BAI_NG_OUT), showWarnings = FALSE, recursive = TRUE)
tibble::tibble(
  r = seq_len(MAX_R),
  IC1 = bai_ng$criteria$IC1,
  IC2 = bai_ng$criteria$IC2,
  IC3 = bai_ng$criteria$IC3
) |>
  readr::write_csv(BAI_NG_OUT)

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

irfs <- sdfm_results$irfs
var_names <- colnames(sdfm_results$data)
horizons <- 0:HORIZON
# Widest set first, so the narrower one is drawn on top of it
bands <- tibble::tibble(
  key = sprintf("%.2f", sort(CI_LEVELS, decreasing = TRUE)),
  fill = c("grey90", "grey80"),
  alpha = c(0.5, 0.45)
)

panels <- purrr::imap(RESPONSE_VARS, \(variable, label) {
  response_row <- match(variable, var_names)
  ribbons <- purrr::pmap(bands, \(key, fill, alpha) {
    ggplot2::geom_ribbon(
      data = tibble::tibble(
        horizon = horizons,
        lower = irfs$ci[[key]]$lower[response_row, horizons + 1],
        upper = irfs$ci[[key]]$upper[response_row, horizons + 1]
      ),
      ggplot2::aes(ymin = lower, ymax = upper),
      fill = fill,
      alpha = alpha
    )
  })

  tibble::tibble(
    horizon = horizons,
    point = irfs$irf_point_matrix[response_row, horizons + 1]
  ) |>
    ggplot2::ggplot(ggplot2::aes(x = horizon)) +
    ribbons +
    ggplot2::geom_line(
      ggplot2::aes(y = point),
      color = "black",
      linewidth = 1
    ) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    ggplot2::theme_classic() +
    ggplot2::labs(y = label) +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_text(size = ggplot2::rel(1.4)),
      axis.text = ggplot2::element_text(size = ggplot2::rel(1.2)),
      plot.title = ggplot2::element_blank()
    )
})

ggplot2::ggsave(
  IRF_OUT,
  patchwork::wrap_plots(panels, ncol = 2),
  width = 11,
  height = 9,
  dpi = 200
)
