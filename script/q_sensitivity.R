# ===================================================================
# Compare q = 2, 3, 4 and 5 at fixed r = 5 for the twenty variables that
# organize the paper's empirical narrative, including all fiscal and
# expectation series, in one of the two windows of step 4/4 of the advisor's
# 2026-09-13 e-mail. The window is a required argument:
#
#   --window=cheia      2012-03..2025-12, p = 4, with the production
#                       Lenza-Primiceri (2022) COVID volatility in the factor
#                       VAR; the sets are on the transformed regression.
#   --window=pre_covid  2012-03..2019-12, p = 2. At p = 4 the pre-COVID AR
#                       covariance is blocked (hac_dim 135 >= T = 90,
#                       output/irf/ar_bands.md); at p = 2 it is feasible
#                       (hac_dim 85 < T = 92, the `pre_p2` cell of the archived
#                       arquivo/script/q_truncation.R).
#
# q = 5 carries its 68/90% Anderson-Rubin sets; q = 2, 3 and 4 are point
# estimates only, following the Figure A3 design of Alessi and Kerssenfischer
# (2019). The script only draws: output/factors/<stem>.pdf.
# Note: notas/2026-09-14_inferencia_volatilidade_covid_q.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/spec_sweep.R")
source("R/identification/weak_iv_ar.R")

WINDOW <- sub("^--window=", "", grep("^--window=", commandArgs(trailingOnly = TRUE), value = TRUE))
if (length(WINDOW) != 1L || !WINDOW %in% c("cheia", "pre_covid")) {
  stop("Pass --window=cheia or --window=pre_covid: the two windows of step 4/4 ",
       "differ in sample, p and the COVID volatility, and neither is a default.")
}

SPEC <- production_spec()
Q_VALUES <- c(5L, 4L, 3L, 2L)
VARS <- c(
  "yield_6m", "yield_2y", "yield_5y", "cambio_usd", "embi_perc",
  "cds_5y", "expect_focus_ipca12m", "ibc_br", "price_ipca", "asset_ibov",
  "fiscal_dbgg", "fiscal_dlsp", "fiscal_primary_balance",
  "dlsp_exchange_adjustment",
  "expect_focus_selic_ny", "expect_focus_pib_ny", "expect_focus_cambio_ny",
  "expect_focus_fiscal_dlsp_ny", "expect_focus_fiscal_primary_balance_ny",
  "expect_focus_fiscal_nominal_balance_ny"
)
H_FIG <- 48L
OUT_DIR <- "output/factors"

# The pre-COVID window has no COVID month, so s_t = 1 throughout and
# estimate_dfm() rejects the scale there: OLS is the treated fit
CELL <- switch(WINDOW,
  cheia = list(
    sample = SPEC$sample,
    p = SPEC$p,
    covid_volatility = SPEC$covid_volatility,
    stem = "q_narrative_r5p4_covid",
    title = "Sensibilidade à dimensão dinâmica q: r = 5, p = 4, cheia com a volatilidade COVID (2012-03 a 2025-12)"
  ),
  pre_covid = list(
    sample = SPEC$pre_covid_sample,
    p = 2L,
    covid_volatility = NULL,
    stem = "q_narrative_r5p2_precovid",
    title = "Sensibilidade à dimensão dinâmica q: r = 5, p = 2, pré-COVID (2012-03 a 2019-12)"
  )
)
OUT_STEM <- file.path(OUT_DIR, CELL$stem)

Q_PALETTE <- c("q=5" = "black", "q=4" = "firebrick", "q=3" = "darkgreen", "q=2" = "steelblue")
Q_LINETYPE <- c("q=5" = "solid", "q=4" = "42", "q=3" = "22", "q=2" = "11")

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

raw_data <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)
tcode <- infer_tcode_from_varnames(var_names)

inst_panel <- readr::read_csv(SPEC$instrument_path, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

cells <- purrr::map(Q_VALUES, function(q) {
  run_stage2_cell(
    data_mat, dates, inst_panel,
    sample_window = CELL$sample,
    r = SPEC$r, q = q, p = CELL$p,
    instrument = SPEC$instrument, mp_var = SPEC$mp_var,
    h = SPEC$horizon, shock_bps = SPEC$shock_bps, tcode = tcode,
    ci_levels = SPEC$ar_levels,
    inference = if (q == SPEC$q) "ar" else "none",
    ar_nw_lags = SPEC$ar_nw_lags,
    covid_volatility = CELL$covid_volatility
  )
})

# The bands draw [lo, hi], which is the set only for an interval and, at the
# normalization point, for the singleton {normalize_value}
set90 <- cells[[match(SPEC$q, Q_VALUES)]]$irf$ar$by_level[["0.90"]]$set_type
set90 <- set90[match(VARS, var_names), ]
at_norm <- row(set90) == match(SPEC$mp_var, VARS) & col(set90) == 1L
stopifnot(all(set90[!at_norm] == "interval"), all(set90[at_norm] == "singleton"))

paths <- purrr::map2_dfr(cells, Q_VALUES, function(cell, q) {
  ar_ref <- q == SPEC$q
  point <- cell$irf$irf_point_matrix
  ci68 <- cell$irf$ci[["0.68"]]
  ci90 <- cell$irf$ci[["0.90"]]

  purrr::map_dfr(VARS, function(variable) {
    i <- match(variable, var_names)
    data.frame(
      r = SPEC$r,
      q = q,
      p = CELL$p,
      variable = variable,
      h = 0:SPEC$horizon,
      point = point[i, ],
      lo68 = if (ar_ref) ci68$lower[i, ] else NA_real_,
      hi68 = if (ar_ref) ci68$upper[i, ] else NA_real_,
      lo90 = if (ar_ref) ci90$lower[i, ] else NA_real_,
      hi90 = if (ar_ref) ci90$upper[i, ] else NA_real_,
      stringsAsFactors = FALSE
    )
  })
})

# The AR branch's own 1e-10 point guard (R/modeling/impulse_response.R) already
# confirms the re-derived point agrees with ident_ext_instr() at q = SPEC$q;
# here we only confirm the shock stays normalized in every cell.
mp_h0 <- dplyr::filter(paths, variable == SPEC$mp_var, h == 0)$point
stopifnot(max(abs(mp_h0 - SPEC$normalize_value)) < 1e-12)

paths <- paths |>
  dplyr::mutate(cell = factor(paste0("q=", q), levels = paste0("q=", Q_VALUES)))

plot_data <- paths |>
  dplyr::filter(h <= H_FIG)
band_data <- plot_data |>
  dplyr::filter(q == SPEC$q)

pdf(paste0(OUT_STEM, ".pdf"), width = 11, height = 7.5)
print(plot_dimension_overlay(
  plot_data, band_data, VARS[1:6], palette = Q_PALETTE, linetypes = Q_LINETYPE,
  h_max = H_FIG, ncol = 3, title = CELL$title,
  subtitle = "z_jk_bs_purif × yield_6m, choque de +50 pb; bandas Anderson-Rubin 68/90% apenas para q=5"
))
print(plot_dimension_overlay(
  plot_data, band_data, VARS[7:10], palette = Q_PALETTE, linetypes = Q_LINETYPE,
  h_max = H_FIG, ncol = 2, title = "", subtitle = ""
))
print(plot_dimension_overlay(
  plot_data, band_data, VARS[11:14], palette = Q_PALETTE, linetypes = Q_LINETYPE,
  h_max = H_FIG, ncol = 2, title = "Variáveis fiscais", subtitle = ""
))
print(plot_dimension_overlay(
  plot_data, band_data, VARS[15:20], palette = Q_PALETTE, linetypes = Q_LINETYPE,
  h_max = H_FIG, ncol = 3, title = "Expectativas", subtitle = ""
))
invisible(dev.off())
