# ===================================================================
# Systematic pruning of redundant series by pairwise correlation.
# Suggestion 2/5 of the advisor's e-mail of 2026-09-04 (item B2 of
# registro/pendencias.md): each group of series correlated above 0.9 keeps a
# single representative -- a composition rule a data section can defend, in
# place of an ad hoc removal.
#
# THE OBJECT is the correlation of the first differences over the production
# window. BLL standardization does not change a correlation, so this is
# cor(estimate_static_factors()$yy), the matrix whose leading eigenvectors are
# the production loadings -- self-test (b). In levels the panel is
# non-stationary and the correlations would be spurious.
#
# THE RULE IS PRE-REGISTERED (plan of 2026-09-10), fixed before any factor
# selection on a pruned panel was computed:
#   groups: complete linkage on 1 - |rho| over the WHOLE panel, cut at
#           1 - 0.90, so every pair inside a group has |rho| >= 0.90. Pruning
#           across groups instead of only within blocks is an author
#           decision; the advisor's within-block version runs beside it and
#           is compared (`igual_dentro_do_bloco`);
#   kept:   yield_6m, the normalization variable; else the first headline
#           series of KEEP_PRIORITY in the group; else the member most
#           correlated with the rest of its block.
# Thresholds 0.80, 0.85, 0.95 and single linkage at 0.90 are sensitivity and
# decide nothing. The group mean is not built (author decision).
#
# Outputs: output/panel_experimental/poda_correlacao/pruning_manifest.csv
#          output/panel_experimental/poda_correlacao/pairs_above_080.csv
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/factor_selection.R")

PANEL_PATH    <- "data/processed/data_log_deseasonalized.csv"
OUT_DIR       <- "output/panel_experimental/poda_correlacao"
SAMPLE        <- as.Date(c("2012-03-01", "2025-12-01"))
PRE_COVID_END <- as.Date("2019-12-01")
R_FACTORS     <- 5L
MP_VAR        <- "yield_6m"
KEEP_PRIORITY <- c(
  MP_VAR,
  "yield_2y",
  "yield_5y",
  "asset_ibov",
  "cambio_usd",
  "price_ipca"
)
# Pairs listed in pairs_above_080.csv: below every threshold of the sweep
PAIR_FLOOR    <- 0.80

CONFIGS <- tibble::tribble(
  ~config,         ~linkage,   ~threshold, ~principal,
  "completa_0.90", "complete", 0.90,       TRUE,
  "completa_0.80", "complete", 0.80,       FALSE,
  "completa_0.85", "complete", 0.85,       FALSE,
  "completa_0.95", "complete", 0.95,       FALSE,
  "simples_0.90",  "single",   0.90,       FALSE
)

raw <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  dplyr::filter(ref.date >= SAMPLE[1], ref.date <= SAMPLE[2])
panel <- raw |>
  dplyr::select(-ref.date) |>
  as.matrix()
pre_covid <- raw$ref.date <= PRE_COVID_END

# The production panel's fine block taxonomy: the 104 base series plus the
# fiscal block (fiscal_*, dlsp_exchange_adjustment) and the Focus
# expectations block (expect_focus_*)
series_names <- colnames(panel)
blocks <- dplyr::case_when(
  stringr::str_detect(series_names, "^cambio_") ~ "cambio",
  stringr::str_detect(series_names, "^juros_") ~ "politica",
  stringr::str_detect(series_names, "^yield_") ~ "curva",
  stringr::str_detect(series_names, "^base_") ~ "monetario",
  stringr::str_detect(
    series_names,
    "^credito_|^spread_|^credit_|^fin_inst_"
  ) ~ "credito_existente",
  stringr::str_detect(series_names, "^consumo_") ~ "combustiveis",
  stringr::str_detect(series_names, "^ind_|^capacidade_") ~ "industria",
  stringr::str_detect(series_names, "^energia_") ~ "energia",
  stringr::str_detect(series_names, "^vendas_") ~ "vendas",
  series_names %in% c("pib", "ibc_br") ~ "atividade_agregada",
  series_names %in% c("icc", "ics") ~ "confianca",
  stringr::str_detect(series_names, "^trab_") ~ "trabalho",
  stringr::str_detect(series_names, "^price_") ~ "precos",
  stringr::str_detect(series_names, "^commodity_") ~ "commodities",
  stringr::str_detect(series_names, "^asset_") ~ "acoes",
  series_names %in% c("embi_perc", "cds_5y", "msci", "sp500_vix") ~
    "risco_externo",
  stringr::str_detect(series_names, "^epu_") ~ "epu",
  stringr::str_detect(series_names, "^fiscal_|^dlsp_") ~ "fiscal",
  stringr::str_detect(series_names, "^expect_focus_") ~ "expectativas"
) |>
  purrr::set_names(series_names)
if (anyNA(blocks)) {
  stop("The production taxonomy does not classify: ",
       paste(series_names[is.na(blocks)], collapse = ", "), ".")
}

cor_diff <- cor(diff(panel))
cor_diff_pre_covid <- cor(diff(panel[pre_covid, ]))

# (a) every production series has a block -- the taxonomy above aborts
#     otherwise
# (b) the correlation of `yy`, the matrix the production PCA decomposes, is
#     cor_diff
yy <- estimate_static_factors(panel, r = R_FACTORS)$yy
stopifnot(max(abs(cor(yy) - cor_diff)) < 1e-12)

pair_index <- which(
  upper.tri(cor_diff) & abs(cor_diff) > PAIR_FLOOR,
  arr.ind = TRUE
)
pairs <- tibble::tibble(
  serie_a = colnames(cor_diff)[pair_index[, 1]],
  serie_b = colnames(cor_diff)[pair_index[, 2]],
  bloco_a = unname(blocks[pair_index[, 1]]),
  bloco_b = unname(blocks[pair_index[, 2]]),
  rho = cor_diff[pair_index],
  rho_pre_covid = cor_diff_pre_covid[pair_index]
) |>
  dplyr::mutate(mesmo_bloco = bloco_a == bloco_b) |>
  dplyr::arrange(dplyr::desc(abs(rho)))

# The pruning across groups, with the within-block version beside it
manifest <- purrr::pmap(
  CONFIGS,
  function(config, linkage, threshold, principal) {
    within_block <- prune_correlated_series(
      cor_diff,
      blocks,
      threshold,
      KEEP_PRIORITY,
      linkage,
      within_blocks = TRUE
    )
    prune_correlated_series(
      cor_diff,
      blocks,
      threshold,
      KEEP_PRIORITY,
      linkage
    ) |>
      dplyr::mutate(
        config = config,
        linkage = linkage,
        threshold = threshold,
        principal = principal,
        kept_dentro_do_bloco = within_block$kept
      ) |>
      dplyr::relocate(config, linkage, threshold, principal)
  }
) |>
  dplyr::bind_rows()

# (c) complete linkage: every pair inside a group clears the threshold, the
#     group correlations re-read from cor_diff independently of the
#     clustering
complete_groups <- manifest |>
  dplyr::filter(!is.na(group), linkage == "complete") |>
  dplyr::summarise(
    min_abs_rho = min(abs(cor_diff[series, series])),
    .by = c(config, threshold, group)
  )
# (d) the normalization variable survives every configuration
stopifnot(
  min(complete_groups$min_abs_rho - complete_groups$threshold) >= 0,
  all(manifest$kept[manifest$series == MP_VAR])
)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
readr::write_csv(manifest, file.path(OUT_DIR, "pruning_manifest.csv"))
readr::write_csv(pairs, file.path(OUT_DIR, "pairs_above_080.csv"))
