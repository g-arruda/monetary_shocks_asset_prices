# ===================================================================
# Sensitivity of the production responses, (5,5,4), z_bs_purif, +50bp on
# yield_6m, to the pandemic months, in two Anexo C figures:
#   - the q = 2..5 exercise of script/q_sensitivity.R on the full window,
#     2012-03..2025-12, side by side with the Lenza-Primiceri scale in the
#     factor VAR and without it, by ordinary least squares;
#   - the pre-COVID window, 2012-03..2019-12, against production.
# The Figure A3 design of Alessi and Kerssenfischer (2019): the reference
# line carries its 80/90% Anderson-Rubin sets, the alternatives are point
# estimates only. With and without the scale the reference is q = 5, each
# with the sets of its own estimator; in the window figure it is production.
# Output: output/irf/lp_q_sensitivity.csv, paper/fig_lp_sensibilidade.pdf
#         output/irf/precovid_sensitivity.csv,
#         paper/fig_precovid_sensibilidade.pdf
# Note: notas/2026-09-30_robustez_pandemia.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/reporting/figures.R")
source("R/reporting/sensitivity.R")
source("R/identification/weak_iv_ar.R")

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
COHERENCE_PATH  <- "output/irf/irf_coherence_h.csv"
LP_CSV          <- "output/irf/lp_q_sensitivity.csv"
LP_FIG          <- "paper/fig_lp_sensibilidade.pdf"
PRE_COVID_CSV   <- "output/irf/precovid_sensitivity.csv"
PRE_COVID_FIG   <- "paper/fig_precovid_sensibilidade.pdf"
SAMPLE_START  <- as.Date("2012-03-01")
FULL_END      <- as.Date("2025-12-01")
PRE_COVID_END <- as.Date("2019-12-01")
R_FACTORS     <- 5L
Q_PRODUCTION  <- 5L
Q_VALUES      <- c(5L, 4L, 3L, 2L)
Q_LABELS      <- paste0("q=", Q_VALUES)
Q_PRODUCTION_LABEL <- paste0("q=", Q_PRODUCTION)
P_LAGS        <- 4L
INSTRUMENT    <- "z_bs_purif"
MP_VAR        <- "yield_6m"
HORIZON       <- 36L
SHOCK_BPS     <- 50
CI_LEVELS     <- c(0.80, 0.90)
AR_NW_LAGS    <- 0L
WITH_SCALE       <- "Com a reescala"
WITHOUT_SCALE    <- "Sem a reescala"
PRODUCTION_LABEL <- "Produção"
PRE_COVID_LABEL  <- "Pré-COVID"
# The pre-COVID window has no COVID month, so s_t = 1 throughout and
# estimate_dfm() rejects the scale there: ordinary least squares is the
# treated fit. Its Anderson-Rubin covariance is blocked at p = 4 (hac_dim
# 135 >= T = 90), so that cell is drawn in point only.
CELLS <- tidyr::expand_grid(
  estimator = c(WITH_SCALE, WITHOUT_SCALE),
  q = Q_VALUES,
  sample_end = FULL_END
) |>
  tibble::add_row(
    estimator = WITHOUT_SCALE,
    q = Q_PRODUCTION,
    sample_end = PRE_COVID_END
  )
# Labels and scales of script/fig_section5.R
PAPER_PANELS <- tibble::tribble(
  ~variable,               ~label,                       ~scale,
  "yield_6m",              "DI 6 meses (p.b.)",          1e4,
  "yield_2y",              "DI 2 anos (p.b.)",           1e4,
  "cambio_usd",            "Câmbio BRL/USD (R$/US$)",    1,
  "cds_5y",                "CDS 5 anos (p.b.)",          1,
  "expect_focus_pib_ny",   "Focus PIB (p.p.)",           1,
  "expect_focus_ipca12m",  "Focus IPCA 12 meses (p.p.)", 1,
  "expect_focus_selic_ny", "Focus Selic (p.p.)",         1,
  "fiscal_dbgg",           "DBGG (p.p. do PIB)",         1
)
# Colours and line types of script/q_sensitivity.R
Q_PALETTE <- c(
  "q=5" = "black",
  "q=4" = "firebrick",
  "q=3" = "darkgreen",
  "q=2" = "steelblue"
)
Q_LINETYPE <- c("q=5" = "solid", "q=4" = "42", "q=3" = "22", "q=2" = "11")

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))

covid_volatility <- read_covid_volatility(THETA_PATH)

cells <- purrr::pmap(CELLS, function(estimator, q, sample_end) {
  run_stage2_cell(
    data_mat,
    dates,
    inst_panel,
    sample_window = c(SAMPLE_START, sample_end),
    r = R_FACTORS,
    q = q,
    p = P_LAGS,
    instrument = INSTRUMENT,
    mp_var = MP_VAR,
    h = HORIZON,
    shock_bps = SHOCK_BPS,
    tcode = infer_tcode_from_varnames(var_names),
    ci_levels = CI_LEVELS,
    inference = if (q == Q_PRODUCTION && sample_end == FULL_END) {
      "ar"
    } else {
      "none"
    },
    ar_nw_lags = AR_NW_LAGS,
    covid_volatility = if (estimator == WITH_SCALE) covid_volatility else NULL
  )
})

# An explosive companion would draw a response that diverges with h
max_roots <- purrr::map_dbl(cells, "dfm_max_eig")
stopifnot(all(max_roots < 1))

is_full <- CELLS$sample_end == FULL_END
is_reference <- is_full & CELLS$q == Q_PRODUCTION
is_production <- is_reference & CELLS$estimator == WITH_SCALE
purrr::walk(
  cells[is_reference],
  stop_unless_interval_sets,
  vars = PAPER_PANELS$variable
)

# Every variable of the panel, so the record can count beyond the eight drawn
q_paths <- purrr::map(c(WITH_SCALE, WITHOUT_SCALE), function(estimator) {
  in_column <- is_full & CELLS$estimator == estimator
  stack_cell_paths(
    cells[in_column],
    Q_LABELS,
    Q_PRODUCTION_LABEL,
    var_names
  ) |>
    dplyr::mutate(
      estimator = estimator,
      max_root = unique(max_roots[in_column]),
      .before = cell
    )
}) |>
  purrr::list_rbind()

window_paths <- stack_cell_paths(
  cells[is_production | !is_full],
  c(PRODUCTION_LABEL, PRE_COVID_LABEL),
  PRODUCTION_LABEL,
  var_names
) |>
  dplyr::mutate(
    max_root = max_roots[is_production | !is_full][as.integer(cell)],
    .after = cell
  )

# The production line of both annex figures must be section 4's line
stop_unless_matches_cache(
  dplyr::filter(window_paths, cell == PRODUCTION_LABEL),
  COHERENCE_PATH,
  PAPER_PANELS$variable,
  HORIZON
)

readr::write_csv(q_paths, LP_CSV)
readr::write_csv(window_paths, PRE_COVID_CSV)

# One row per series, the scale on the left and ordinary least squares on the
# right, on a common vertical axis within the row. The row strip stacks the
# name of the series, wrapped, over its unit.
row_labels <- paste(
  stringr::str_wrap(stringr::str_remove(PAPER_PANELS$label, " \\(.*$"), 12),
  stringr::str_extract(PAPER_PANELS$label, "\\(.*$"),
  sep = "\n"
)
lp_data <- rescale_to_paper_units(q_paths, PAPER_PANELS, HORIZON) |>
  dplyr::mutate(
    variable = factor(
      row_labels[match(variable, PAPER_PANELS$label)],
      levels = row_labels
    ),
    estimator = factor(estimator, levels = c(WITH_SCALE, WITHOUT_SCALE))
  )
lp_bands <- dplyr::filter(lp_data, cell == Q_PRODUCTION_LABEL)

lp_figure <- ggplot2::ggplot(lp_data, ggplot2::aes(x = h)) +
  ggplot2::geom_ribbon(
    data = lp_bands,
    ggplot2::aes(ymin = lo90, ymax = hi90),
    fill = "steelblue",
    alpha = 0.18
  ) +
  ggplot2::geom_ribbon(
    data = lp_bands,
    ggplot2::aes(ymin = lo80, ymax = hi80),
    fill = "steelblue",
    alpha = 0.36
  ) +
  ggplot2::geom_hline(
    yintercept = 0,
    linetype = "dashed",
    colour = "red",
    linewidth = 0.35
  ) +
  ggplot2::geom_line(
    ggplot2::aes(y = point, colour = cell, linetype = cell),
    linewidth = 0.7
  ) +
  ggplot2::facet_grid(variable ~ estimator, scales = "free_y", switch = "y") +
  ggplot2::scale_colour_manual(values = Q_PALETTE) +
  ggplot2::scale_linetype_manual(values = Q_LINETYPE) +
  ggplot2::scale_x_continuous(breaks = seq(0, HORIZON, 6), expand = c(0.01, 0)) +
  ggplot2::labs(x = NULL, y = NULL, colour = NULL, linetype = NULL) +
  ggplot2::theme_classic(base_size = 10) +
  ggplot2::theme(
    strip.background = ggplot2::element_blank(),
    strip.placement = "outside",
    strip.text = ggplot2::element_text(size = 10, face = "bold"),
    legend.position = "bottom"
  )

ggplot2::ggsave(
  LP_FIG,
  lp_figure,
  width = 10.4,
  height = 11.6,
  device = cairo_pdf
)

window_data <- rescale_to_paper_units(window_paths, PAPER_PANELS, HORIZON)

# Colours and line types of script/instrument_layers_irf.R
ggplot2::ggsave(
  PRE_COVID_FIG,
  plot_dimension_overlay(
    window_data,
    dplyr::filter(window_data, cell == PRODUCTION_LABEL),
    PAPER_PANELS$label,
    palette = c("Produção" = "black", "Pré-COVID" = "steelblue"),
    linetypes = c("Produção" = "solid", "Pré-COVID" = "22"),
    h_max = HORIZON,
    ncol = 4,
    title = NULL,
    subtitle = NULL
  ),
  width = 10.4,
  height = 5.8,
  device = cairo_pdf
)
