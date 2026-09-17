# ===================================================================
# Compare q = 4, 5, 6, 7 and 8 at fixed (r, p) = (8, 4) for the twenty
# variables that organize the paper's empirical narrative, including all
# fiscal and expectation series.
#
# This is the sibling of script/q_narrative_overlay.R (r = 5). r = 8 has
# no production cell, so every line is a point estimate and no bootstrap
# bands are drawn. Following the Figure A3 design of Alessi and
# Kerssenfischer (2019), the alternatives are overlaid point-only.
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/spec_sweep.R")

SPEC <- production_spec()
R_FIXED <- 8L
Q_VALUES <- c(8L, 7L, 6L, 5L, 4L)
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
OUT_STEM <- file.path(OUT_DIR, "q_narrative_r8p4")

Q_LABEL <- paste0("q=", Q_VALUES)
Q_PALETTE <- c("q=8" = "black", "q=7" = "firebrick", "q=6" = "darkgreen",
               "q=5" = "steelblue", "q=4" = "goldenrod3")
Q_LINETYPE <- c("q=8" = "solid", "q=7" = "42", "q=6" = "22",
                "q=5" = "11", "q=4" = "1343")

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

paths <- purrr::map_dfr(Q_VALUES, function(q) {
  cell <- run_stage2_cell(
    data_mat, dates, inst_panel,
    sample_window = SPEC$sample,
    r = R_FIXED, q = q, p = SPEC$p,
    instrument = SPEC$instrument, mp_var = SPEC$mp_var,
    h = SPEC$horizon, nboot = 0L, seed = SPEC$bootstrap_seed,
    shock_bps = SPEC$shock_bps, tcode = tcode, ci_levels = SPEC$ci_levels,
    # Closed round: stays OLS so it keeps reproducing the numbers its
    # note was written against (CLAUDE.md, completed rounds).
    covid_volatility = NULL
  )
  point <- cell$irf$irf_point_matrix

  purrr::map_dfr(VARS, function(variable) {
    i <- match(variable, var_names)
    data.frame(
      r = R_FIXED,
      q = q,
      p = SPEC$p,
      variable = variable,
      h = 0:SPEC$horizon,
      point = point[i, ],
      stringsAsFactors = FALSE
    )
  })
}) |>
  dplyr::mutate(
    lo68 = NA_real_, hi68 = NA_real_, lo90 = NA_real_, hi90 = NA_real_,
    cell = factor(paste0("q=", q), levels = Q_LABEL)
  )

summary <- paths |>
  dplyr::filter(h <= H_FIG) |>
  dplyr::group_by(variable, h) |>
  dplyr::summarise(
    min_q = min(point),
    max_q = max(point),
    gap_q = max_q - min_q,
    .groups = "drop"
  ) |>
  dplyr::group_by(variable) |>
  dplyr::summarise(
    max_gap_q = max(abs(gap_q)),
    max_gap_h = h[which.max(abs(gap_q))],
    .groups = "drop"
  ) |>
  dplyr::left_join(
    paths |>
      dplyr::filter(h %in% c(0L, 6L, 12L, 24L, 36L, 48L)) |>
      dplyr::select(variable, h, q, point) |>
      tidyr::pivot_wider(names_from = c(h, q), values_from = point,
                         names_glue = "h{h}_q{q}"),
    by = "variable"
  )

readr::write_csv(paths, paste0(OUT_STEM, "_paths.csv"))
readr::write_csv(summary, paste0(OUT_STEM, "_summary.csv"))

writeLines(c(
  "# IRFs narrativas: q = 4 a 8 com r = 8, p = 4",
  "",
  "As vinte variáveis cobrem a curva, câmbio e risco soberano, expectativas,",
  "atividade, preços, ações e todas as séries fiscais e de expectativa que",
  "estruturam a narrativa empírica do artigo. r = 8 não tem célula de produção,",
  "então todas as linhas são estimativas pontuais; não há bandas.",
  "Horizonte h = 0..48.",
  "",
  "Artefatos: `q_narrative_r8p4_paths.csv`, `q_narrative_r8p4_summary.csv`",
  "e `q_narrative_r8p4.pdf`."
), paste0(OUT_STEM, ".md"))

plot_data <- paths |>
  dplyr::filter(h <= H_FIG)
band_data <- plot_data[0, ]

title <- "Sensibilidade à dimensão dinâmica q: r = 8, p = 4"
subtitle <- paste0(
  "z_jk_bs_purif × yield_6m, choque de +50 pb; estimativas pontuais (r=8 não é produção)"
)

pdf(paste0(OUT_STEM, ".pdf"), width = 11, height = 7.5)
print(plot_dimension_overlay(
  plot_data, band_data, VARS[1:6], Q_PALETTE, Q_LINETYPE,
  H_FIG, 3, title, subtitle
))
print(plot_dimension_overlay(
  plot_data, band_data, VARS[7:10], Q_PALETTE, Q_LINETYPE,
  H_FIG, 2, "", ""
))
print(plot_dimension_overlay(
  plot_data, band_data, VARS[11:14], Q_PALETTE, Q_LINETYPE,
  H_FIG, 2, "Variáveis fiscais", ""
))
print(plot_dimension_overlay(
  plot_data, band_data, VARS[15:20], Q_PALETTE, Q_LINETYPE,
  H_FIG, 3, "Expectativas", ""
))
dev.off()
