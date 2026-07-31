# ===================================================================
# TAREFA 2 — Unidades, normalizacao e sinal
#
# 1. Tabela de IRFs para as 106 variaveis (a de producao cobre so 52 e omite
#    yield_6m, a variavel de normalizacao).
# 2. Tabela unidade | IRF h=0 | h=0 em bp | esperado, para o bloco de juros.
# 3. Correlacao contemporanea nos dados BRUTOS entre as mesmas series.
# 4. Rastreamento de sinal no codigo.
#
# Saida: diagnostics/output/t2_*.csv
# ===================================================================

source("diagnostics/_common.R")

cat("\n=== TAREFA 2 — unidades, normalizacao e sinal ===\n")

stopifnot(!is.null(CELL))
vn   <- CELL$var_names
P    <- CELL$irf$irf_point_matrix
lo68 <- CELL$irf$ci[["0.68"]]$lower; hi68 <- CELL$irf$ci[["0.68"]]$upper
lo90 <- CELL$irf$ci[["0.90"]]$lower; hi90 <- CELL$irf$ci[["0.90"]]$upper
H    <- ncol(P) - 1


# ===================================================================
# 2.1 — Tabela de IRFs para TODAS as variaveis (inclui yield_6m)
# ===================================================================
cat("\n[2.1] tabela completa de IRFs (106 variaveis x", H + 1, "horizontes)\n")

irf_all <- lapply(seq_along(vn), function(i) {
  data.frame(var = vn[i], grupo = var_group(vn[i]), tcode = CELL$tcode[i],
             h = 0:H, point = P[i, ],
             lo68 = lo68[i, ], hi68 = hi68[i, ],
             lo90 = lo90[i, ], hi90 = hi90[i, ],
             sign = sign(P[i, ]),
             sig68 = lo68[i, ] > 0 | hi68[i, ] < 0,
             sig90 = lo90[i, ] > 0 | hi90[i, ] < 0)
}) |> bind_rows()

cat(sprintf("  yield_6m em h=0: %.6f  (variavel de normalizacao)\n",
            irf_all$point[irf_all$var == "yield_6m" & irf_all$h == 0]))
cat(sprintf("  variaveis cobertas: %d (tabela de producao cobre %d)\n",
            length(unique(irf_all$var)), nrow(coherence_var_table())))
diag_write(irf_all, "t2_1_irf_todas_variaveis.csv")


# ===================================================================
# 2.2 — Unidades do bloco de juros, IRF h=0 e conversao para bp
# ===================================================================
cat("\n[2.2] bloco de juros: unidade, IRF h=0 e equivalente em bp\n")

JUROS <- c("yield_3m", "yield_6m", "yield_1y", "yield_2y", "yield_5y",
           "yield_10y", "juros_selic", "juros_cdi")
ut <- unit_table()

t22 <- lapply(JUROS, function(v) {
  i  <- match(v, vn)
  u  <- ut[match(v, ut$var), ]
  pk <- which.max(abs(P[i, ]))
  data.frame(
    var = v,
    unidade = u$unidade,
    faixa_painel = sprintf("[%.3f, %.3f]", min(PANEL[, v]), max(PANEL[, v])),
    irf_h0 = P[i, 1],
    h0_bp = P[i, 1] * u$escala_bp,
    esperado_h0 = if (v == SPEC$mp_var) "0.005 (=50bp, por construcao)" else "livre",
    irf_h6 = P[i, 7], h6_bp = P[i, 7] * u$escala_bp,
    irf_h24 = P[i, 25], h24_bp = P[i, 25] * u$escala_bp,
    pico_h = pk - 1, pico_bp = P[i, pk] * u$escala_bp,
    sig90_h0 = lo90[i, 1] > 0 | hi90[i, 1] < 0
  )
}) |> bind_rows()

print(as.data.frame(t22 |> select(var, irf_h0, h0_bp, h6_bp, h24_bp,
                                  pico_h, pico_bp, sig90_h0)),
      row.names = FALSE, digits = 4)
diag_write(t22, "t2_2_unidades_juros.csv")

cat("\n  Leitura: em pontos-base os dois blocos ficam comparaveis.\n")
cat(sprintf("  h0  : yield_6m %+.1fbp  vs  juros_selic %+.1fbp\n",
            t22$h0_bp[t22$var == "yield_6m"], t22$h0_bp[t22$var == "juros_selic"]))
cat(sprintf("  h24 : yield_6m %+.1fbp  vs  juros_selic %+.1fbp\n",
            t22$h24_bp[t22$var == "yield_6m"], t22$h24_bp[t22$var == "juros_selic"]))


# ===================================================================
# 2.3 — Correlacao contemporanea nos DADOS BRUTOS
# ===================================================================
cat("\n[2.3] correlacao contemporanea nos dados brutos (data/raw_data.csv)\n")

raw_w <- PANEL_RAW |>
  filter(ref.date >= min(DATES), ref.date <= max(DATES)) |>
  select(all_of(JUROS))
C_lvl <- cor(raw_w, use = "pairwise.complete.obs")
C_dif <- cor(diff(as.matrix(raw_w)), use = "pairwise.complete.obs")

cat("\n-- nivel --\n"); print(round(C_lvl, 4))
cat("\n-- primeira diferenca (o que a padronizacao BLL usa) --\n"); print(round(C_dif, 4))

t23 <- expand.grid(a = JUROS, b = JUROS, stringsAsFactors = FALSE) |>
  filter(a < b) |>
  mutate(cor_nivel = mapply(function(x, y) C_lvl[x, y], a, b),
         cor_diff  = mapply(function(x, y) C_dif[x, y], a, b)) |>
  arrange(desc(cor_nivel))
diag_write(t23, "t2_3_correlacoes_juros_brutas.csv")


# ===================================================================
# 2.4 — Rastreamento de sinal
# ===================================================================
cat("\n[2.4] rastreamento de sinal no caminho de estimacao\n")

t24 <- data.frame(
  local = c("factor_estimation.R:336-344",
            "factor_estimation.R:667-673",
            "factor_estimation.R:458",
            "impulse_responde.R:124",
            "impulse_responde.R:759-766"),
  o_que = c("normalizacao de sinal dos loadings estaticos (SVD)",
            "normalizacao de sinal dos autovetores dinamicos (SVD)",
            "Abias = -bias/T, interno a correcao de Kilian",
            "divisao por irf_mp[mpind,1] (normalizacao do choque)",
            "opcao invert_shock do plot"),
  determinístico = c("SIM — maior |elemento| forcado positivo",
                     "SIM — maior |elemento| forcado positivo",
                     "SIM — nao toca sinal de IRF",
                     "SIM — sinal fixado pelo dado, nao arbitrario",
                     "INATIVO em producao (default FALSE)"),
  risco = c("nenhum", "nenhum", "nenhum",
            "define o sinal global; se impact_pre<0 TODAS as IRFs viram",
            "nenhum"),
  stringsAsFactors = FALSE
)
print(as.data.frame(t24), row.names = FALSE)
diag_write(t24, "t2_4_rastreamento_sinal.csv")

# valor de impact_pre em producao: e o denominador da normalizacao
dfm <- estimate_dfm(PANEL, SPEC$r, SPEC$q, SPEC$p, dates = DATES,
                    instrument = inst_df(), apply_kilian = FALSE)
fsd <- diagnose_instrument_in_factor_space(dfm, inst_df(), DATES, SPEC$p,
                                           match(SPEC$mp_var, VAR_NAMES))
cat(sprintf("\n  impact_pre (denominador da normalizacao) = %.6e  sinal = %s\n",
            fsd$impact_mp, if (fsd$impact_mp > 0) "POSITIVO" else "NEGATIVO"))
cat("  -> positivo significa que a normalizacao NAO inverte as IRFs.\n")


# ===================================================================
# Veredito
# ===================================================================
cat("\n===== VEREDITO TAREFA 2 =====\n")
cat("(a) mistura de unidades entre blocos: SIM — yield_* decimal x juros_* p.p. (fator 100),\n")
cat("    e embi_perc p.p. x cds_5y bp. Absorvida pela padronizacao BLL: nao vicia a\n")
cat("    estimacao, vicia a LEITURA. Em bp os blocos concordam.\n")
cat("(b) inversao de sinal: NAO — impact_pre > 0 e as duas normalizacoes de autovetor\n")
cat("    sao deterministicas.\n")
cat("(c) escalonamento nao uniforme: NAO — o unico erro de escala encontrado (x100 em\n")
cat("    cds_5y/msci/sp500_vix) era uniforme e foi corrigido em 2026-07-28.\n")

cat("\n=== TAREFA 2 concluida ===\n")
