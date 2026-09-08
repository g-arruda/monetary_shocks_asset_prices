# ===================================================================
# Compare q = 2, 3, 4 and 5 at fixed (r, p) = (5, 4) for the twenty
# variables that organize the paper's empirical narrative, including all
# fiscal and expectation series.
#
# q = 5 is the production cell and carries its canonical 68/90% wild-
# bootstrap bands. The q = 2, 3 and 4 cells are point estimates only,
# following the Figure A3 design of Alessi and Kerssenfischer (2019).
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/spec_sweep.R")

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
OUT_STEM <- file.path(OUT_DIR, "q_narrative_r5p4")

Q_LABEL <- paste0("q=", Q_VALUES)
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

paths <- purrr::map_dfr(Q_VALUES, function(q) {
  cell <- run_stage2_cell(
    data_mat, dates, inst_panel,
    sample_window = SPEC$sample,
    r = SPEC$r, q = q, p = SPEC$p,
    instrument = SPEC$instrument, mp_var = SPEC$mp_var,
    h = SPEC$horizon, nboot = 0L, seed = SPEC$bootstrap_seed,
    shock_bps = SPEC$shock_bps, tcode = tcode, ci_levels = SPEC$ci_levels
  )
  point <- cell$irf$irf_point_matrix

  purrr::map_dfr(VARS, function(variable) {
    i <- match(variable, var_names)
    data.frame(
      r = SPEC$r,
      q = q,
      p = SPEC$p,
      variable = variable,
      h = 0:SPEC$horizon,
      point = point[i, ],
      stringsAsFactors = FALSE
    )
  })
})

coherence_cell <- readRDS(SPEC$coherence_cell_path)
coh_point <- coherence_cell$irf$irf_point_matrix
coh_ci68 <- coherence_cell$irf$ci[["0.68"]]
coh_ci90 <- coherence_cell$irf$ci[["0.90"]]

coherence <- purrr::map_dfr(VARS, function(variable) {
  i <- match(variable, coherence_cell$var_names)
  data.frame(
    var = variable,
    h = 0:SPEC$horizon,
    lo68 = coh_ci68$lower[i, ],
    hi68 = coh_ci68$upper[i, ],
    lo90 = coh_ci90$lower[i, ],
    hi90 = coh_ci90$upper[i, ],
    point_production = coh_point[i, ],
    stringsAsFactors = FALSE
  )
})

production_check <- paths |>
  dplyr::filter(q == SPEC$q) |>
  dplyr::inner_join(coherence, by = c("variable" = "var", "h"))
stopifnot(nrow(production_check) == length(VARS) * (SPEC$horizon + 1))
stopifnot(max(abs(production_check$point - production_check$point_production)) < 1e-10)

paths <- paths |>
  dplyr::left_join(
    coherence |>
      dplyr::select(var, h, lo68, hi68, lo90, hi90),
    by = c("variable" = "var", "h")
  ) |>
  dplyr::mutate(
    lo68 = dplyr::if_else(q == SPEC$q, lo68, NA_real_),
    hi68 = dplyr::if_else(q == SPEC$q, hi68, NA_real_),
    lo90 = dplyr::if_else(q == SPEC$q, lo90, NA_real_),
    hi90 = dplyr::if_else(q == SPEC$q, hi90, NA_real_),
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

containment <- paths |>
  dplyr::filter(q != SPEC$q, h <= H_FIG) |>
  dplyr::select(-lo68, -hi68, -lo90, -hi90) |>
  dplyr::inner_join(
    paths |>
      dplyr::filter(q == SPEC$q) |>
      dplyr::select(variable, h, lo90, hi90),
    by = c("variable", "h")
  ) |>
  dplyr::group_by(variable, q) |>
  dplyr::summarise(
    share_in_q5_band90 = mean(point >= lo90 & point <= hi90),
    .groups = "drop"
  ) |>
  tidyr::pivot_wider(
    names_from = q,
    values_from = share_in_q5_band90,
    names_glue = "share_q{q}_in_q5_band90"
  )

summary <- summary |>
  dplyr::left_join(containment, by = "variable")

readr::write_csv(paths, paste0(OUT_STEM, "_paths.csv"))
readr::write_csv(summary, paste0(OUT_STEM, "_summary.csv"))

writeLines(c(
  "# IRFs narrativas: q = 2 a 5 com r = 5, p = 4",
  "",
  "As vinte variáveis cobrem a curva, câmbio e risco soberano, expectativas,",
  "atividade, preços, ações e todas as séries fiscais e de expectativa que",
  "estruturam a narrativa empírica do artigo. A linha q=5 é a produção.",
  "Somente ela traz bandas wild-bootstrap de 68% e 90% (800 réplicas);",
  "q=2, q=3 e q=4 são sobreposições pontuais. Horizonte h = 0..48.",
  "",
  "Artefatos: `q_narrative_r5p4_paths.csv`, `q_narrative_r5p4_summary.csv`",
  "e `q_narrative_r5p4.pdf`."
), paste0(OUT_STEM, ".md"))

plot_data <- paths |>
  dplyr::filter(h <= H_FIG)
band_data <- plot_data |>
  dplyr::filter(q == SPEC$q)

title <- "Sensibilidade à dimensão dinâmica q: r = 5, p = 4"
subtitle <- paste0(
  "z_jk_bs_purif × yield_6m, choque de +50 pb; bandas 68/90% apenas para q=5 (nboot=800)"
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
