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
#          output/panel_experimental/poda_correlacao/panel_pruning.{md,pdf}
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/production_spec.R")
source("R/identification/experimental_panel.R")
source("R/identification/spec_sweep.R")

SPEC          <- production_spec()
KEEP_PRIORITY <- c(SPEC$mp_var, "yield_2y", "yield_5y", "asset_ibov", "cambio_usd",
                   "price_ipca")
PAIR_FLOOR    <- 0.80   # pairs listed in the report: below every threshold of the sweep
OUT_DIR       <- "output/panel_experimental/poda_correlacao"

CONFIGS <- tibble::tribble(
  ~config,         ~linkage,   ~threshold, ~principal,
  "completa_0.90", "complete", 0.90,       TRUE,
  "completa_0.80", "complete", 0.80,       FALSE,
  "completa_0.85", "complete", 0.85,       FALSE,
  "completa_0.95", "complete", 0.95,       FALSE,
  "simples_0.90",  "single",   0.90,       FALSE
)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data and the correlation the PCA reads --------------------------

raw <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |>
  dplyr::filter(ref.date >= SPEC$sample[1], ref.date <= SPEC$sample[2])
panel <- raw |>
  dplyr::select(-ref.date) |>
  as.matrix()
pre_covid <- raw$ref.date <= SPEC$pre_covid_sample[2]
blocks    <- base_block_taxonomy(colnames(panel))

C     <- cor(diff(panel))
C_pre <- cor(diff(panel[pre_covid, ]))

# (a) every production series has a block -- base_block_taxonomy() aborts otherwise
# (b) the correlation of `yy`, the matrix the production PCA decomposes, is C
yy    <- estimate_static_factors(panel, r = SPEC$r)$yy
dev_b <- max(abs(cor(yy) - C))
stopifnot(ncol(panel) == SPEC$n_series, dev_b < 1e-12)


# ---- Pairs above the floor -------------------------------------------

idx <- which(upper.tri(C) & abs(C) > PAIR_FLOOR, arr.ind = TRUE)
pairs <- tibble::tibble(
  serie_a = colnames(C)[idx[, 1]],
  serie_b = colnames(C)[idx[, 2]],
  bloco_a = unname(blocks[idx[, 1]]),
  bloco_b = unname(blocks[idx[, 2]]),
  rho = C[idx],
  rho_pre_covid = C_pre[idx]
) |>
  dplyr::mutate(mesmo_bloco = bloco_a == bloco_b) |>
  dplyr::arrange(dplyr::desc(abs(rho)))


# ---- The pruning, across groups and within blocks --------------------

manifest <- purrr::pmap(CONFIGS, function(config, linkage, threshold, principal) {
  within_block <- prune_correlated_series(C, blocks, threshold, KEEP_PRIORITY, linkage,
                                          within_blocks = TRUE)
  prune_correlated_series(C, blocks, threshold, KEEP_PRIORITY, linkage) |>
    dplyr::mutate(config = config, linkage = linkage, threshold = threshold,
                  principal = principal, kept_dentro_do_bloco = within_block$kept) |>
    dplyr::relocate(config, linkage, threshold, principal)
}) |>
  dplyr::bind_rows()

# The group correlations are re-read from C, independently of the clustering
groups_tbl <- manifest |>
  dplyr::filter(!is.na(group)) |>
  dplyr::group_by(config, linkage, threshold, principal, group) |>
  dplyr::summarise(
    mantida = series[kept],
    motivo = reason[kept],
    descartadas = paste(series[!kept], collapse = ", "),
    blocos = paste(unique(block), collapse = ", "),
    n_blocos = dplyr::n_distinct(block),
    min_abs_rho = min(abs(C[series, series])),
    min_abs_rho_pre_covid = min(abs(C_pre[series, series])),
    .groups = "drop"
  )

# (c) complete linkage: every pair inside a group clears the threshold
complete_groups <- dplyr::filter(groups_tbl, linkage == "complete")
slack_c <- min(complete_groups$min_abs_rho - complete_groups$threshold)
# (d) the normalization variable survives every configuration
mp_dropped <- sum(!manifest$kept[manifest$series == SPEC$mp_var])
stopifnot(slack_c >= 0, mp_dropped == 0)

config_summary <- manifest |>
  dplyr::group_by(config, linkage, threshold, principal) |>
  dplyr::summarise(
    grupos = dplyr::n_distinct(group, na.rm = TRUE),
    n_descartadas = sum(!kept),
    n_series = sum(kept),
    igual_dentro_do_bloco = all(kept == kept_dentro_do_bloco),
    descartadas = paste(series[!kept], collapse = ", "),
    .groups = "drop"
  ) |>
  dplyr::left_join(
    groups_tbl |>
      dplyr::group_by(config) |>
      dplyr::summarise(grupos_entre_blocos = sum(n_blocos > 1L)),
    by = "config"
  ) |>
  dplyr::relocate(grupos_entre_blocos, .after = grupos) |>
  dplyr::arrange(dplyr::desc(principal), linkage, threshold)

self_tests <- tibble::tribble(
  ~teste,                                                                          ~valor,     ~criterio,
  "(a) séries do painel de produção classificadas em blocos",                      ncol(panel), "= 115, nenhuma sem bloco",
  "(b) cor(yy) de estimate_static_factors() contra cor(diff(X)), desvio máximo",   dev_b,      "< 1e-12",
  "(c) folga mínima de |rho| sobre o limiar nos grupos de ligação completa",       slack_c,    ">= 0",
  "(d) configurações em que yield_6m é descartada",                               mp_dropped, "= 0"
)

readr::write_csv(manifest, file.path(OUT_DIR, "pruning_manifest.csv"))
readr::write_csv(pairs, file.path(OUT_DIR, "pairs_above_080.csv"))


# ---- Report ----------------------------------------------------------

principal_groups <- groups_tbl |>
  dplyr::filter(principal) |>
  dplyr::select(group, blocos, mantida, motivo, descartadas, min_abs_rho,
                min_abs_rho_pre_covid)

other_groups <- groups_tbl |>
  dplyr::filter(!principal) |>
  dplyr::select(config, group, blocos, mantida, descartadas, min_abs_rho,
                min_abs_rho_pre_covid)

sections <- c(
  "# Poda do painel por correlação par a par",
  "",
  sprintf("Gerado por `script/panel_pruning.R` em %s.", format(Sys.Date(), "%Y-%m-%d")),
  paste("**Corpo gerado — não escrever prosa aqui.** A leitura vive em",
        "`notas/2026-09-10_poda_correlacao_painel.md`."),
  "",
  "## Objeto e regra",
  "",
  sprintf(paste("Painel de produção `%s`, %s a %s, %d séries. Objeto: correlação das primeiras",
                "diferenças (T = %d), a mesma de `estimate_static_factors()$yy`, a matriz da qual",
                "a PCA de produção tira as cargas. A coluna pré-COVID usa %s a %s."),
          SPEC$panel_name, SPEC$sample[1], SPEC$sample[2], ncol(panel), nrow(panel) - 1,
          SPEC$pre_covid_sample[1], SPEC$pre_covid_sample[2]),
  "",
  paste("Regra fixada antes de qualquer seleção de fatores no painel podado: ligação completa",
        "sobre `1 − |ρ|` no painel inteiro, corte em `1 − 0,90`, de modo que todo par dentro de",
        "um grupo tem |ρ| ≥ 0,90. Cada grupo mantém uma série:",
        sprintf("`%s` se estiver no grupo; senão a primeira de `%s`;", SPEC$mp_var,
                paste(KEEP_PRIORITY[-1], collapse = ", ")),
        "senão a de maior |ρ| média contra o resto do seu bloco. `igual_dentro_do_bloco`",
        "compara com a mesma regra restrita a cada bloco, a versão literal do e-mail."),
  "",
  "## Auto-testes",
  "",
  md_table(as.data.frame(self_tests), digits = 3),
  "",
  "## Configurações",
  "",
  "A primeira linha é a principal; as demais são sensibilidade e não decidem nada.",
  "",
  md_table(as.data.frame(config_summary)),
  "",
  "## Grupos na configuração principal (ligação completa, 0,90)",
  "",
  md_table(as.data.frame(principal_groups), digits = 3),
  "",
  "## Grupos nas configurações de sensibilidade",
  "",
  md_table(as.data.frame(other_groups), digits = 3),
  "",
  sprintf("## Pares com |ρ| > %.2f no painel inteiro: %d pares, %d entre blocos",
          PAIR_FLOOR, nrow(pairs), sum(!pairs$mesmo_bloco)),
  "",
  md_table(as.data.frame(pairs), digits = 3),
  "",
  "Figura em `panel_pruning.pdf`."
)

writeLines(sections, file.path(OUT_DIR, "panel_pruning.md"))


# ---- Figure: within-block correlations of the blocks that lose a series ----

principal_rows <- dplyr::filter(manifest, principal)
label_of <- setNames(dplyr::if_else(principal_rows$kept, principal_rows$series,
                                    paste(principal_rows$series, "(sai)")),
                     principal_rows$series)
fig_blocks <- unique(principal_rows$block[!is.na(principal_rows$group)])

heat <- tidyr::expand_grid(serie_x = colnames(C), serie_y = colnames(C)) |>
  dplyr::mutate(bloco = unname(blocks[serie_x])) |>
  dplyr::filter(bloco == blocks[serie_y], bloco %in% fig_blocks) |>
  dplyr::mutate(
    rho = C[cbind(serie_x, serie_y)],
    rotulo_x = factor(label_of[serie_x], levels = label_of),
    rotulo_y = factor(label_of[serie_y], levels = rev(label_of)),
    acima = serie_x != serie_y & abs(rho) >= 0.90,
    texto = dplyr::if_else(serie_x != serie_y & abs(rho) >= PAIR_FLOOR,
                           sprintf("%.2f", rho), "")
  )

p_heat <- ggplot2::ggplot(heat, ggplot2::aes(rotulo_x, rotulo_y, fill = rho)) +
  ggplot2::geom_tile(colour = "white") +
  ggplot2::geom_tile(data = dplyr::filter(heat, acima), colour = "black", fill = NA,
                     linewidth = 0.7) +
  ggplot2::geom_text(ggplot2::aes(label = texto), size = 2.3) +
  ggplot2::scale_fill_gradient2(low = "#2166ac", mid = "white", high = "#b2182b",
                                limits = c(-1, 1)) +
  ggplot2::facet_wrap(~bloco, scales = "free") +
  ggplot2::labs(
    title = "Correlacao das primeiras diferencas nos blocos que perdem series na poda",
    subtitle = sprintf(paste("%s a %s; contorno preto = |rho| >= 0.90; valores impressos",
                             "para |rho| >= %.2f; '(sai)' = descartada na poda principal"),
                       SPEC$sample[1], SPEC$sample[2], PAIR_FLOOR),
    x = NULL, y = NULL, fill = "correlacao"
  ) +
  ggplot2::theme_minimal(base_size = 9) +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
                 panel.grid = ggplot2::element_blank())

ggplot2::ggsave(file.path(OUT_DIR, "panel_pruning.pdf"), p_heat, width = 13, height = 9.5)
