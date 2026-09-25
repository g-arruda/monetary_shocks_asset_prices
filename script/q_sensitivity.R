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
# (2019). The script only draws: output/factors/<stem>.pdf, the 20 variables
# to h = 48, and, for --window=cheia, paper/fig_q_sensibilidade.pdf, the
# paper's Anexo C figure: eight of them to h = 36, in the units of section 4.
# Notes: notas/2026-09-14_inferencia_volatilidade_covid_q.md,
# notas/2026-09-24_q_sensibilidade_anexo.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/spec_sweep.R")
source("R/identification/weak_iv_ar.R")

WINDOW <- sub("^--window=", "", grep("^--window=", commandArgs(trailingOnly = TRUE), value = TRUE))
if (length(WINDOW) != 1L || !WINDOW %in% c("cheia", "pre_covid")) {
  stop("Pass --window=cheia or --window=pre_covid: the two windows of step 4/4 ",
       "differ in sample, p and the COVID volatility, and neither is a default.")
}

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
R_FACTORS  <- 5L
Q_PRODUCTION <- 5L
INSTRUMENT <- "z_jk_bs_purif"
MP_VAR     <- "yield_6m"
HORIZON    <- 48L
SHOCK_BPS  <- 50
NORMALIZE_VALUE <- 0.005      # +50bp on yield_6m, a decimal proportion
CI_LEVELS  <- c(0.68, 0.90)
AR_NW_LAGS <- 0L

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

COHERENCE_PATH <- "output/irf/irf_coherence_h.csv"
PAPER_FIG <- "paper/fig_q_sensibilidade.pdf"
H_PAPER <- 36L
# Labels and scales of script/fig_section5.R; an NA scale is its "pct", the
# response as a percentage of the sample mean
PAPER_PANELS <- tibble::tribble(
  ~variable,     ~label,                     ~scale,
  "yield_2y",    "DI 2 anos (p.b.)",         1e4,
  "yield_5y",    "DI 5 anos (p.b.)",         1e4,
  "cambio_usd",  "Câmbio BRL/USD (%)",       NA,
  "cds_5y",      "CDS 5 anos (p.b.)",        1,
  "ibc_br",      "IBC-Br (%)",               NA,
  "price_ipca",  "IPCA cheio (p.p. ao mês)", 1,
  "asset_ibov",  "Ibovespa (%)",             1,
  "fiscal_dlsp", "DLSP (p.p. do PIB)",       1
)

# The pre-COVID window has no COVID month, so s_t = 1 throughout and
# estimate_dfm() rejects the scale there: OLS is the treated fit
CELL <- switch(WINDOW,
  cheia = list(
    sample = as.Date(c("2012-03-01", "2025-12-01")),
    p = 4L,
    covid_volatility = read_covid_volatility(THETA_PATH),
    stem = "q_narrative_r5p4_covid",
    title = "Sensibilidade à dimensão dinâmica q: r = 5, p = 4, cheia com a volatilidade COVID (2012-03 a 2025-12)"
  ),
  pre_covid = list(
    sample = as.Date(c("2012-03-01", "2019-12-01")),
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

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)
tcode <- infer_tcode_from_varnames(var_names)

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

cells <- purrr::map(Q_VALUES, function(q) {
  run_stage2_cell(
    data_mat, dates, inst_panel,
    sample_window = CELL$sample,
    r = R_FACTORS, q = q, p = CELL$p,
    instrument = INSTRUMENT, mp_var = MP_VAR,
    h = HORIZON, shock_bps = SHOCK_BPS, tcode = tcode,
    ci_levels = CI_LEVELS,
    inference = if (q == Q_PRODUCTION) "ar" else "none",
    ar_nw_lags = AR_NW_LAGS,
    covid_volatility = CELL$covid_volatility
  )
})

# The bands draw [lo, hi], which is the set only for an interval and, at the
# normalization point, for the singleton {normalize_value}
set90 <- cells[[match(Q_PRODUCTION, Q_VALUES)]]$irf$ar$by_level[["0.90"]]$set_type
set90 <- set90[match(VARS, var_names), ]
at_norm <- row(set90) == match(MP_VAR, VARS) & col(set90) == 1L
stopifnot(all(set90[!at_norm] == "interval"), all(set90[at_norm] == "singleton"))

paths <- purrr::map2_dfr(cells, Q_VALUES, function(cell, q) {
  ar_ref <- q == Q_PRODUCTION
  point <- cell$irf$irf_point_matrix
  ci68 <- cell$irf$ci[["0.68"]]
  ci90 <- cell$irf$ci[["0.90"]]

  purrr::map_dfr(VARS, function(variable) {
    i <- match(variable, var_names)
    data.frame(
      r = R_FACTORS,
      q = q,
      p = CELL$p,
      variable = variable,
      h = 0:HORIZON,
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
# confirms the re-derived point agrees with ident_ext_instr() at the production q;
# here we only confirm the shock stays normalized in every cell.
mp_h0 <- dplyr::filter(paths, variable == MP_VAR, h == 0)$point
stopifnot(max(abs(mp_h0 - NORMALIZE_VALUE)) < 1e-12)

paths <- paths |>
  dplyr::mutate(cell = factor(paste0("q=", q), levels = paste0("q=", Q_VALUES)))

plot_data <- paths |>
  dplyr::filter(h <= H_FIG)
band_data <- plot_data |>
  dplyr::filter(q == Q_PRODUCTION)

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

if (WINDOW == "cheia") {
  # The q = 5 line of the annex figure must be section 4's production line
  production <- paths |>
    dplyr::filter(q == Q_PRODUCTION, variable %in% PAPER_PANELS$variable, h <= H_PAPER) |>
    dplyr::inner_join(
      readr::read_csv(COHERENCE_PATH, show_col_types = FALSE),
      by = c("variable" = "var", "h"),
      suffix = c("", "_cache")
    )
  stopifnot(
    nrow(production) == nrow(PAPER_PANELS) * (H_PAPER + 1L),
    max(abs(production$point - production$point_cache)) < 1e-10,
    max(abs(production$lo68 - production$lo68_cache)) < 1e-10,
    max(abs(production$hi68 - production$hi68_cache)) < 1e-10,
    max(abs(production$lo90 - production$lo90_cache)) < 1e-10,
    max(abs(production$hi90 - production$hi90_cache)) < 1e-10
  )

  paper_panels <- PAPER_PANELS |>
    dplyr::mutate(
      scale = dplyr::coalesce(scale, 100 / colMeans(raw_data[variable]))
    )
  paper_data <- paths |>
    dplyr::filter(h <= H_PAPER) |>
    dplyr::inner_join(paper_panels, by = "variable") |>
    dplyr::mutate(
      dplyr::across(c(point, lo68, hi68, lo90, hi90), \(x) x * scale),
      variable = label
    )

  ggplot2::ggsave(
    PAPER_FIG,
    plot_dimension_overlay(
      paper_data, dplyr::filter(paper_data, q == Q_PRODUCTION), paper_panels$label,
      palette = Q_PALETTE, linetypes = Q_LINETYPE,
      h_max = H_PAPER, ncol = 4, title = NULL, subtitle = NULL
    ),
    width = 10.4, height = 5.8, device = cairo_pdf
  )
}
