# ===================================================================
# Step 1/5 of the advisor's plan of 2026-10-03: precision of the production
# responses, on the fixed-horizon Focus base of step 0. Four parts:
#   A. Anderson-Rubin sets at 80, 90 and 95%, NW(0), every series, at the
#      horizons fixed before looking at the results, h = 0, 1, 3, 6, 12, 24.
#   B. The pre-COVID window, 2012-03..2019-12, without the COVID scale. Sets
#      at (5,5,2), where hac_dim 85 < T = 92; at production's (5,5,4),
#      hac_dim 135 >= T = 90 blocks them and only the point is computed.
#   C. Autocorrelation of the moments of the AR test, under NW(0): the moment
#      of xi_mp, the moment of each FX and CDS test at the table horizons
#      (at zero and at the point) and the 105 columns of the influence
#      function of (vec(A), Gamma).
#   D. Newey-West truncation 0-3, as asked, plus 4 (Newey-West 1994 for
#      T = 162), 8 (TaxSVARIV.m:52) and 12, fixed before running.
# Production is not touched: the cell is the one of
# script/irf_coherence_check.R, which must run first, re-run at three levels.
# Outputs: output/ar_precision/
#   table.csv             production and pre-COVID cells, table horizons
#   precovid_cells.csv    strength, root and gate of each cell
#   precovid_outside.csv  by series, h0-h36: points outside the (5,5,2) set
#   moment_acf.csv, moment_ljung_box.csv, moment_acf.pdf
#   nw_strength.csv       xi_mp and F_rob by Newey-West truncation
#   nw_sets.csv           FX and CDS sets, h0-h36, by truncation and level
#   nw_panel.csv          panel counts by truncation and level, h0-h36
# Note: notas/2026-10-05_precisao_ar.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")
source("R/identification/factor_space_diagnostics.R")

PANEL_PATH       <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH  <- "data/processed/instrument.csv"
INSTRUMENTS_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH       <- "output/factors/covid_volatility_theta.csv"
CELL_PATH        <- "output/irf/irf_coherence_cell.rds"
STRENGTH_PATH    <- "output/instrument/mosw_strength_grid.csv"
OUT_DIR          <- "output/ar_precision"
SAMPLE_START  <- as.Date("2012-03-01")
PRE_COVID_END <- as.Date("2019-12-01")
R_FACTORS   <- 5L
Q_DYNAMIC   <- 5L
P_LAGS      <- 4L
P_PRE_COVID <- 2L
INSTRUMENT  <- "z_bs_purif"
MP_VAR      <- "yield_6m"
SHOCK_BPS   <- 50
HORIZON     <- 48L
H_MAX       <- 36L
H_TABLE     <- c(0L, 1L, 3L, 6L, 12L, 24L)
CI_LEVELS   <- c(0.80, 0.90, 0.95)
NW_LAGS     <- c(0L, 1L, 2L, 3L, 4L, 8L, 12L)
ACF_LAGS    <- 12L
LJUNG_BOX_LAGS <- c(3L, 6L, 12L)
TARGET_VARS <- c("cambio_usd", "cds_5y")
TARGET_LABELS <- c(cambio_usd = "Câmbio", cds_5y = "CDS")

#' Ljung-Box tests of one series at every lag of LJUNG_BOX_LAGS
#'
#' @param x Numeric series.
#' @param series Label of the series.
#' @param block Label of the group the series belongs to.
#'
#' @return Tibble with `block`, `series`, `lag`, `statistic` and `p_value`.
#'
#' @examples
#' ljung_box(psi[, 1], "xi_mp", "teste")
ljung_box <- function(x, series, block) {
  purrr::map(LJUNG_BOX_LAGS, function(lag) {
    test <- Box.test(x, lag = lag, type = "Ljung-Box")
    tibble::tibble(
      block = block,
      series = series,
      lag = lag,
      statistic = unname(test$statistic),
      p_value = test$p.value
    )
  }) |>
    purrr::list_rbind()
}

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# A. Production ------------------------------------------------------------

production <- main_sdfm(
  data_path = PANEL_PATH,
  instrument_path = INSTRUMENT_PATH,
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_LAGS,
  h = HORIZON,
  mp_var = MP_VAR,
  shock_size_bps = SHOCK_BPS,
  ci_levels = CI_LEVELS,
  inference = "ar",
  ar_nw_lags = 0L,
  covid_volatility = read_covid_volatility(THETA_PATH)
)
model <- production$model
var_names <- colnames(production$data)
mpind <- production$mpind
normalize_value <- production$normalize_value
n_vars <- length(var_names)

# The cell is section 4's: same point and 80/90% sets as the cache
cached <- readRDS(CELL_PATH)$irf
stopifnot(
  identical(production$irfs$irf_point_matrix, cached$irf_point_matrix),
  identical(production$irfs$ci[c("0.80", "0.90")], cached$ci)
)

# Every cell of the panel, in the variable-fastest order of the sets
cell_rows <- rep(seq_len(n_vars), times = HORIZON + 1L)
cell_horizons <- rep(0:HORIZON, each = n_vars)
aligned <- sel_ext_inst_sample(model$dates, model$p, model$instrument)

# D. Newey-West truncations, NW(0) first: production -----------------------

nw_runs <- purrr::map(NW_LAGS, function(nw_lags) {
  irf <- compute_irf_dfm(
    model,
    h = HORIZON,
    mpind = mpind,
    normalize_value = normalize_value,
    tcode = production$tcode,
    ci_levels = CI_LEVELS,
    inference = "ar",
    ar_nw_lags = nw_lags
  )
  moments <- ar_dfm_moments(
    model,
    aligned$rsh_sel_ind,
    aligned$inst_sel,
    HORIZON,
    nw_lags = nw_lags
  )
  at_zero <- ar_statistic(
    moments,
    mpind,
    normalize_value,
    cell_rows,
    cell_horizons,
    lambda0 = 0
  )
  strength <- diagnose_instrument_in_factor_space(
    model,
    model$instrument,
    model$dates,
    model$p,
    mpind,
    nw_lags = nw_lags
  )
  # The relevance ruler of record is the Wald of the AR sets' denominator
  stopifnot(abs(strength$wald_mp / irf$ar$xi_den - 1) < 1e-8)

  sets <- tidy_ar_sets(irf$ar, var_names) |>
    dplyr::mutate(
      nw_lags = nw_lags,
      p_value_zero = rep(at_zero$p_value, times = length(CI_LEVELS))
    )
  # The set at level kappa excludes zero iff AR(0) > critval. The
  # normalization point is pinned, not tested.
  tested <- dplyr::filter(sets, !(variable == MP_VAR & h == 0L))
  stopifnot(
    all((tested$p_value_zero < 1 - tested$level) == tested$significant)
  )

  list(
    sets = sets,
    strength = tibble::tibble(
      nw_lags = nw_lags,
      xi_mp = irf$ar$xi_den,
      f_robust_mp = strength$f_robust_mp,
      bounded80 = irf$ar$xi_den > qchisq(0.80, 1),
      bounded90 = irf$ar$xi_den > qchisq(0.90, 1),
      bounded95 = irf$ar$xi_den > qchisq(0.95, 1)
    )
  )
})
nw_sets <- purrr::map(nw_runs, "sets") |>
  purrr::list_rbind()
production_sets <- dplyr::filter(nw_sets, nw_lags == 0L)

# xi_mp = 6.80 > 3.84 bounds every set at 95%; the normalization is the
# singleton at h0
production_tested <- dplyr::filter(
  production_sets,
  !(variable == MP_VAR & h == 0L)
)
stopifnot(all(production_tested$set_type == "interval"))

# B. Pre-COVID window ------------------------------------------------------

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
inst_panel <- readr::read_csv(INSTRUMENTS_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))

# Neither cell reaches 2020-03: s_t = 1 in every month, so the weighted fit is
# the unweighted one and covid_volatility is NULL
pre_covid_p2 <- run_stage2_cell(
  data_mat,
  dates,
  inst_panel,
  sample_window = c(SAMPLE_START, PRE_COVID_END),
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_PRE_COVID,
  instrument = INSTRUMENT,
  mp_var = MP_VAR,
  h = HORIZON,
  shock_bps = SHOCK_BPS,
  tcode = production$tcode,
  ci_levels = CI_LEVELS,
  inference = "ar",
  covid_volatility = NULL
)
# Production's p: mosw_rform_cov() stops at hac_dim 135 >= T = 90, so the
# point alone
pre_covid_p4 <- run_stage2_cell(
  data_mat,
  dates,
  inst_panel,
  sample_window = c(SAMPLE_START, PRE_COVID_END),
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_LAGS,
  instrument = INSTRUMENT,
  mp_var = MP_VAR,
  h = HORIZON,
  shock_bps = SHOCK_BPS,
  tcode = production$tcode,
  ci_levels = CI_LEVELS,
  inference = "none",
  covid_volatility = NULL
)
stopifnot(pre_covid_p2$dfm_max_eig < 1, pre_covid_p4$dfm_max_eig < 1)

pre_covid_p2_sets <- tidy_ar_sets(pre_covid_p2$irf$ar, var_names)
pre_covid_p4_point <- tibble::tibble(
  variable = rep(var_names, times = HORIZON + 1L),
  h = cell_horizons,
  point = as.vector(pre_covid_p4$irf$irf_point_matrix)
)

# T is the window's months less p. The HAC moment vector has n (1 + n p + n + k)
# entries and the authors' parameter vector n^2 p + n (n + 1)/2 + n k, as in
# mosw_rform_cov(), with n = r and k = 1
pre_covid_months <- sum(dates >= SAMPLE_START & dates <= PRE_COVID_END)
precovid_xi_p4 <- readr::read_csv(STRENGTH_PATH, show_col_types = FALSE) |>
  dplyr::filter(
    sample == "pre_covid",
    r == R_FACTORS,
    q == Q_DYNAMIC,
    instrument == INSTRUMENT
  ) |>
  dplyr::pull(wald_mp)
tibble::tibble(
  cell = c("producao", "pre_covid_p2", "pre_covid_p4"),
  window_end = c(max(model$dates), PRE_COVID_END, PRE_COVID_END),
  p = c(P_LAGS, P_PRE_COVID, P_LAGS),
  T_eff = c(
    nrow(model$var_residuals),
    pre_covid_months - P_PRE_COVID,
    pre_covid_months - P_LAGS
  ),
  hac_dim = R_FACTORS * (1L + R_FACTORS * p + R_FACTORS + 1L),
  par_dim = R_FACTORS^2 * p + R_FACTORS * (R_FACTORS + 1L) / 2 + R_FACTORS,
  ar_sets = hac_dim < T_eff,
  xi_mp = c(
    nw_runs[[1L]]$strength$xi_mp,
    pre_covid_p2$irf$ar$xi_den,
    precovid_xi_p4
  ),
  max_root = c(
    model$diagnostics$max_eigenvalue,
    pre_covid_p2$dfm_max_eig,
    pre_covid_p4$dfm_max_eig
  )
) |>
  readr::write_csv(file.path(OUT_DIR, "precovid_cells.csv"))

stopifnot(
  pre_covid_p2$irf$ar$hac_dim == R_FACTORS * (R_FACTORS * P_PRE_COVID + 7L),
  pre_covid_p2$irf$ar$T_eff == pre_covid_months - P_PRE_COVID
)

# Point against set: where a point of another cell falls outside the 90% set
# of (5,5,2). Not a test of equality between the cells.
pre_covid_p2_sets |>
  dplyr::filter(level == 0.90, h <= H_MAX) |>
  dplyr::select(variable, h, point, lo, hi, significant) |>
  dplyr::left_join(
    dplyr::rename(pre_covid_p4_point, point_p4 = point),
    by = c("variable", "h")
  ) |>
  dplyr::left_join(
    production_sets |>
      dplyr::filter(level == 0.90) |>
      dplyr::select(variable, h, point_production = point),
    by = c("variable", "h")
  ) |>
  dplyr::mutate(
    outside_p4 = point_p4 < lo | point_p4 > hi,
    outside_production = point_production < lo | point_production > hi
  ) |>
  dplyr::group_by(variable) |>
  dplyr::summarise(
    sig90_p2 = sum(significant),
    n_outside_p4 = sum(outside_p4),
    horizons_outside_p4 = paste(h[outside_p4], collapse = " "),
    n_outside_production = sum(outside_production),
    horizons_outside_production = paste(h[outside_production], collapse = " ")
  ) |>
  dplyr::arrange(dplyr::desc(n_outside_production)) |>
  readr::write_csv(file.path(OUT_DIR, "precovid_outside.csv"))

# A. The table, every series at the table horizons --------------------------

dplyr::bind_rows(
  dplyr::mutate(production_sets, cell = "producao"),
  dplyr::mutate(pre_covid_p2_sets, cell = "pre_covid_p2"),
  tidyr::expand_grid(pre_covid_p4_point, level = CI_LEVELS) |>
    dplyr::mutate(cell = "pre_covid_p4")
) |>
  dplyr::filter(h %in% H_TABLE) |>
  dplyr::mutate(level = round(100 * level)) |>
  dplyr::select(
    cell, variable, h, point, level, lo, hi, set_type, significant,
    p_value_zero
  ) |>
  tidyr::pivot_wider(
    names_from = level,
    values_from = c(lo, hi, set_type, significant)
  ) |>
  dplyr::arrange(cell, variable, h) |>
  readr::write_csv(file.path(OUT_DIR, "table.csv"))

# C. Moments of the AR test under NW(0) -------------------------------------

moments <- ar_dfm_moments(
  model,
  aligned$rsh_sel_ind,
  aligned$inst_sel,
  HORIZON,
  nw_lags = 0L
)
targets <- tidyr::expand_grid(variable = TARGET_VARS, h = H_TABLE) |>
  dplyr::left_join(
    production_sets |>
      dplyr::filter(level == 0.90) |>
      dplyr::select(variable, h, point),
    by = c("variable", "h")
  )
target_rows <- match(targets$variable, var_names)

# The moment of xi_mp is the one of the normalization cell at zero: its
# statistic is xi_mp itself
xi_moment <- ar_statistic(moments, mpind, normalize_value, mpind, 0L, 0)
at_zero <- ar_statistic(
  moments,
  mpind,
  normalize_value,
  target_rows,
  targets$h,
  lambda0 = 0
)
# FX and CDS are code 1: published and untransformed units coincide
at_point <- ar_statistic(
  moments,
  mpind,
  normalize_value,
  target_rows,
  targets$h,
  lambda0 = targets$point
)
stopifnot(
  abs(xi_moment$statistic / nw_runs[[1L]]$strength$xi_mp - 1) < 1e-10,
  max(abs(at_point$statistic)) < 1e-10,
  max(abs(colSums(at_zero$psi^2) / nrow(at_zero$psi) / at_zero$variance - 1)) <
    1e-10
)

# The bounds of the FX and CDS sets solve AR(lambda) = critval, every level
bound_cells <- production_sets |>
  dplyr::filter(variable %in% TARGET_VARS) |>
  tidyr::pivot_longer(c(lo, hi), names_to = "bound", values_to = "lambda0")
at_bounds <- ar_statistic(
  moments,
  mpind,
  normalize_value,
  match(bound_cells$variable, var_names),
  bound_cells$h,
  lambda0 = bound_cells$lambda0
)
stopifnot(
  all(bound_cells$set_type == "interval"),
  max(abs(at_bounds$statistic / qchisq(bound_cells$level, 1) - 1)) < 1e-8
)

target_series <- paste0(TARGET_LABELS[targets$variable], " h", targets$h)
moment_series <- c(
  "Momento de xi_mp",
  paste(target_series, "(zero)"),
  paste(target_series, "(ponto)")
)
moment_matrix <- cbind(xi_moment$psi, at_zero$psi, at_point$psi)

# The 105 columns of the influence function: vec(A), equation fastest within
# each regressor (lag, factor), then Gamma, one entry per factor innovation
n_lag_columns <- R_FACTORS * P_LAGS
influence_labels <- c(
  sprintf(
    "A eq%d lag%d f%d",
    rep(seq_len(R_FACTORS), times = n_lag_columns),
    rep((seq_len(n_lag_columns) - 1L) %/% R_FACTORS + 1L, each = R_FACTORS),
    rep((seq_len(n_lag_columns) - 1L) %% R_FACTORS + 1L, each = R_FACTORS)
  ),
  sprintf("Gamma f%d", seq_len(R_FACTORS))
)
stopifnot(length(influence_labels) == ncol(moments$cov$influence))

acf_band <- qnorm(0.975) / sqrt(nrow(moment_matrix))
moment_acf <- purrr::map(seq_along(moment_series), function(j) {
  tibble::tibble(
    series = moment_series[j],
    lag = seq_len(ACF_LAGS),
    acf = drop(acf(moment_matrix[, j], lag.max = ACF_LAGS, plot = FALSE)$acf)[-1],
    band = acf_band
  )
}) |>
  purrr::list_rbind()
readr::write_csv(moment_acf, file.path(OUT_DIR, "moment_acf.csv"))

dplyr::bind_rows(
  purrr::map(seq_along(moment_series), \(j) {
    ljung_box(moment_matrix[, j], moment_series[j], "teste")
  }),
  purrr::map(seq_along(influence_labels), \(j) {
    ljung_box(moments$cov$influence[, j], influence_labels[j], "influencia")
  })
) |>
  readr::write_csv(file.path(OUT_DIR, "moment_ljung_box.csv"))

moment_plot <- moment_acf |>
  dplyr::filter(!grepl("ponto", series)) |>
  dplyr::mutate(series = factor(series, levels = moment_series)) |>
  ggplot2::ggplot(ggplot2::aes(x = lag, y = acf)) +
  ggplot2::geom_col(fill = "steelblue", width = 0.6) +
  ggplot2::geom_hline(
    yintercept = c(-acf_band, acf_band),
    linetype = "dashed",
    colour = "red",
    linewidth = 0.35
  ) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
  ggplot2::facet_wrap(~series, ncol = 4) +
  ggplot2::scale_x_continuous(breaks = c(1, 3, 6, 9, 12)) +
  ggplot2::labs(x = "Defasagem (meses)", y = "Autocorrelação") +
  ggplot2::theme_classic(base_size = 10)
ggplot2::ggsave(
  file.path(OUT_DIR, "moment_acf.pdf"),
  moment_plot,
  width = 10.4,
  height = 7.2,
  device = cairo_pdf
)

# D. Newey-West: outputs -----------------------------------------------------

purrr::map(nw_runs, "strength") |>
  purrr::list_rbind() |>
  readr::write_csv(file.path(OUT_DIR, "nw_strength.csv"))

nw_sets |>
  dplyr::filter(variable %in% TARGET_VARS, h <= H_MAX) |>
  dplyr::select(
    variable, nw_lags, level, h, point, lo, hi, set_type, significant,
    p_value_zero
  ) |>
  dplyr::arrange(variable, nw_lags, level, h) |>
  readr::write_csv(file.path(OUT_DIR, "nw_sets.csv"))

# Width and significance against NW(0), cell by cell; the normalization
# singleton has zero width under every truncation
nw_sets |>
  dplyr::filter(h <= H_MAX) |>
  dplyr::left_join(
    production_sets |>
      dplyr::select(
        variable, h, level,
        lo0 = lo, hi0 = hi, significant0 = significant
      ),
    by = c("variable", "h", "level")
  ) |>
  dplyr::mutate(
    width_ratio = dplyr::if_else(
      set_type == "interval" & hi0 > lo0,
      (hi - lo) / (hi0 - lo0),
      NA_real_
    )
  ) |>
  dplyr::group_by(nw_lags, level) |>
  dplyr::summarise(
    n_significant = sum(significant),
    lost = sum(significant0 & !significant),
    gained = sum(!significant0 & significant),
    interval = sum(set_type == "interval"),
    singleton = sum(set_type == "singleton"),
    other_type = sum(!set_type %in% c("interval", "singleton")),
    width_ratio_median = median(width_ratio, na.rm = TRUE),
    .groups = "drop"
  ) |>
  readr::write_csv(file.path(OUT_DIR, "nw_panel.csv"))
