# ===================================================================
# TAREFA 3 — Composicao do painel
#
# Blocos superrepresentados e series quase-duplicadas dominam a extracao de
# fatores por PCA. Aqui: quantificar, listar e medir o efeito de remover as
# duplicatas sobre as IRFs e sobre a forca do instrumento.
#
# Saida: diagnostics/output/t3_*.csv
# ===================================================================

source("diagnostics/_common.R")

cat("\n=== TAREFA 3 — composicao do painel ===\n")

raw_w <- PANEL_RAW |>
  dplyr::filter(ref.date >= min(DATES), ref.date <= max(DATES))


# ===================================================================
# 3.1 — juros_selic vs juros_cdi na fonte
# ===================================================================
cat("\n[3.1] juros_selic vs juros_cdi\n")

t31 <- data.frame(
  base = "raw_data.csv (bruto)",
  cor_nivel = cor(raw_w$juros_selic, raw_w$juros_cdi),
  cor_diff = cor(diff(raw_w$juros_selic), diff(raw_w$juros_cdi)),
  dif_media_abs = mean(abs(raw_w$juros_selic - raw_w$juros_cdi)),
  dif_max_abs = max(abs(raw_w$juros_selic - raw_w$juros_cdi)),
  in_production = "juros_cdi" %in% VAR_NAMES
)
print(as.data.frame(t31), row.names = FALSE, digits = 6)
cat("  Fontes: SGS 4189 (Selic acumulada no mes) e SGS 4392 (CDI acumulado no mes).\n")
cat("  Sao series DISTINTAS na fonte, mas o CDI segue a Selic por arbitragem —\n")
cat("  a diferenca media e de", round(t31$dif_media_abs[1], 3), "p.p.\n")
diag_write(t31, "t3_1_selic_cdi.csv")


# ===================================================================
# 3.2 — Todos os pares com |cor| > 0.98
# ===================================================================
cat("\n[3.2] varredura de quase-duplicidade em TODOS os pares\n")

X_lvl <- PANEL
X_dif <- diff(X_lvl)
C_lvl <- cor(X_lvl, use = "pairwise.complete.obs")
C_dif <- cor(X_dif, use = "pairwise.complete.obs")

ij <- which(upper.tri(C_lvl), arr.ind = TRUE)
pairs_df <- data.frame(
  a = VAR_NAMES[ij[, 1]], b = VAR_NAMES[ij[, 2]],
  cor_nivel = C_lvl[ij], cor_diff = C_dif[ij]
) |>
  dplyr::mutate(grupo_a = var_group(a), grupo_b = var_group(b),
         mesmo_grupo = grupo_a == grupo_b)

cat(sprintf("  pares avaliados: %d\n", nrow(pairs_df)))

t32_lvl <- pairs_df |> dplyr::filter(abs(cor_nivel) > 0.98) |> dplyr::arrange(dplyr::desc(abs(cor_nivel)))
t32_dif <- pairs_df |> dplyr::filter(abs(cor_diff)  > 0.98) |> dplyr::arrange(dplyr::desc(abs(cor_diff)))

cat(sprintf("\n  |cor| > 0.98 em NIVEL: %d pares\n", nrow(t32_lvl)))
print(as.data.frame(t32_lvl |> dplyr::select(a, b, cor_nivel, cor_diff, mesmo_grupo)),
      row.names = FALSE, digits = 5)

cat(sprintf("\n  |cor| > 0.98 em PRIMEIRA DIFERENCA (o que a BLL usa): %d pares\n",
            nrow(t32_dif)))
print(as.data.frame(t32_dif |> dplyr::select(a, b, cor_nivel, cor_diff, mesmo_grupo)),
      row.names = FALSE, digits = 5)

diag_write(dplyr::bind_rows(t32_lvl |> dplyr::mutate(criterio = "nivel"),
                     t32_dif |> dplyr::mutate(criterio = "diferenca")),
           "t3_2_pares_quase_duplicados.csv")


# ===================================================================
# 3.3 — Quantas series por grupo
# ===================================================================
cat("\n[3.3] tamanho de cada bloco\n")

t33 <- data.frame(var = VAR_NAMES, grupo = var_group(VAR_NAMES)) |>
  dplyr::count(grupo, name = "n_series") |>
  dplyr::mutate(share = n_series / length(VAR_NAMES)) |>
  dplyr::arrange(dplyr::desc(n_series))
print(as.data.frame(t33), row.names = FALSE, digits = 3)
diag_write(t33, "t3_3_blocos.csv")

# quanto de cada bloco e explicado pelo 1o componente do proprio bloco:
# mede colinearidade interna (bloco redundante domina o PCA global)
t33b <- lapply(unique(var_group(VAR_NAMES)), function(g) {
  vs <- VAR_NAMES[var_group(VAR_NAMES) == g]
  if (length(vs) < 2) return(NULL)
  Zg <- scale(diff(PANEL[, vs, drop = FALSE]))
  ev <- svd(cov(Zg))$d
  data.frame(grupo = g, n = length(vs),
             pc1_share = ev[1] / sum(ev),
             pc2_share = ev[2] / sum(ev))
}) |> dplyr::bind_rows() |> dplyr::arrange(dplyr::desc(pc1_share))
cat("\n  colinearidade interna (share do 1o PC do proprio bloco, em diferenca):\n")
print(as.data.frame(t33b), row.names = FALSE, digits = 3)
diag_write(t33b, "t3_3b_colinearidade_interna.csv")


# ===================================================================
# 3.4 — Reestimar sem duplicatas
# ===================================================================
cat("\n[3.4] reestimacao sem as duplicatas\n")

# Criterio: para cada par com |cor_diff| > 0.98, remover a segunda serie.
# juros_cdi sai (juros_selic e a taxa de politica de referencia).
drop_set <- unique(t32_dif$b)
drop_set <- setdiff(drop_set, SPEC$mp_var)     # nunca remover a variavel de politica
cat("  series removidas:", if (length(drop_set)) paste(drop_set, collapse = ", ") else "(nenhuma)", "\n")

keep <- setdiff(VAR_NAMES, drop_set)
PANEL_TRIM <- PANEL[, keep, drop = FALSE]
tc_trim <- infer_tcode_from_varnames(keep)

FOCUS <- c("yield_6m", "juros_selic", "price_core_ipca_ex0", "cambio_usd",
           "asset_ibov", "embi_perc", "commodity_metal")

run_and_extract <- function(M, tc, lab) {
  cell <- run_stage2_cell(M, DATES, INST_PANEL, sample_window = SPEC$window,
                          r = SPEC$r, q = SPEC$q, p = SPEC$p,
                          instrument = SPEC$instrument, mp_var = SPEC$mp_var,
                          h = 24L, nboot = 200L, seed = SPEC$seed,
                          shock_bps = SPEC$shock_bps, tcode = tc,
                          ci_levels = SPEC$ci_levels)
  d  <- estimate_dfm(M, SPEC$r, SPEC$q, SPEC$p, dates = DATES,
                     instrument = inst_df(), apply_kilian = FALSE)
  fs <- diagnose_instrument_in_factor_space(d, inst_df(), DATES, SPEC$p,
                                            match(SPEC$mp_var, colnames(M)))
  P <- cell$irf$irf_point_matrix
  vn <- colnames(M)
  list(
    irf = lapply(intersect(FOCUS, vn), function(v) {
      i <- match(v, vn)
      data.frame(painel = lab, var = v, h0 = P[i, 1], h6 = P[i, 7], h12 = P[i, 13],
                 h24 = P[i, 25])
    }) |> dplyr::bind_rows(),
    forca = data.frame(painel = lab, n_series = ncol(M),
                       max_eig = d$diagnostics$max_eigenvalue,
                       xi_mp = fs$wald_mp, f_robust_mp = fs$f_robust_mp)
  )
}

r_full <- run_and_extract(PANEL, TCODE, sprintf("producao_%d", ncol(PANEL)))
r_trim <- run_and_extract(PANEL_TRIM, tc_trim, sprintf("podado_%d", ncol(PANEL_TRIM)))

t34_forca <- dplyr::bind_rows(r_full$forca, r_trim$forca)
cat("\n-- forca e persistencia --\n")
print(as.data.frame(t34_forca), row.names = FALSE, digits = 5)

t34 <- dplyr::bind_rows(r_full$irf, r_trim$irf) |>
  tidyr::pivot_longer(c(h0, h6, h12, h24), names_to = "h", values_to = "irf") |>
  tidyr::pivot_wider(names_from = painel, values_from = irf)
names(t34)[3:4] <- c("producao", "podado")
t34 <- t34 |> dplyr::mutate(dif = podado - producao,
                     dif_rel = ifelse(producao != 0, dif / abs(producao), NA))
cat("\n-- deslocamento das IRFs --\n")
print(as.data.frame(t34), row.names = FALSE, digits = 4)

diag_write(t34, "t3_4_deslocamento_irf.csv")
diag_write(t34_forca, "t3_4_forca.csv")

cat("\n=== TAREFA 3 concluida ===\n")
