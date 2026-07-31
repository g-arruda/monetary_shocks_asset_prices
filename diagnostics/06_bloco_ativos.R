# ===================================================================
# TAREFA 6 — Bloco de ativos
#
# A hipotese H2 do relatorio diz que o horizonte longo do bloco de ativos e
# oscilacao amortecida (raiz complexa de modulo 0.977, periodo 118 meses) mais
# banda inflada por cumsum, e nao economia. O teste decisivo e truncar em h=12
# e verificar se a incoerencia de secao cruzada (asset_imob +18.3 contra
# asset_ifix -33.3 em h=48) some. Se sumir, o sinal de longo prazo e ruido
# acumulado e nao deve ser reportado.
#
# Fonte: CELL (nboot=800, ja estimado). NENHUMA reestimacao nesta tarefa.
#
# Saida: diagnostics/output/t6_*.csv
# ===================================================================

source("diagnostics/_common.R")

cat("\n=== TAREFA 6 — bloco de ativos ===\n")

stopifnot(!is.null(CELL))

ASSETS <- grep("^asset_", CELL$var_names, value = TRUE)
P    <- CELL$irf$irf_point_matrix
lo68 <- CELL$irf$ci[["0.68"]]$lower; hi68 <- CELL$irf$ci[["0.68"]]$upper
lo90 <- CELL$irf$ci[["0.90"]]$lower; hi90 <- CELL$irf$ci[["0.90"]]$upper

# coluna j da matriz corresponde a h = j-1
hcol <- function(h) h + 1L

cat(sprintf("  %d indices de acoes: %s\n", length(ASSETS),
            paste(ASSETS, collapse = ", ")))
cat("  todos tcode 2 (retorno mensal -> cumsum x100 = % acumulado)\n")


# ===================================================================
# 6.1 — IRFs truncadas em h=12, com bandas
# ===================================================================
cat("\n[6.1] IRFs dos ativos truncadas em h=12 (teste da hipotese H2)\n")

H_TRUNC <- 12L

t61 <- lapply(ASSETS, function(v) {
  i <- match(v, CELL$var_names)
  data.frame(
    var = v, h = 0:H_TRUNC,
    point = P[i, hcol(0:H_TRUNC)],
    lo68 = lo68[i, hcol(0:H_TRUNC)], hi68 = hi68[i, hcol(0:H_TRUNC)],
    lo90 = lo90[i, hcol(0:H_TRUNC)], hi90 = hi90[i, hcol(0:H_TRUNC)],
    sig68 = lo68[i, hcol(0:H_TRUNC)] > 0 | hi68[i, hcol(0:H_TRUNC)] < 0,
    sig90 = lo90[i, hcol(0:H_TRUNC)] > 0 | hi90[i, hcol(0:H_TRUNC)] < 0,
    stringsAsFactors = FALSE
  )
}) |> bind_rows()

resumo61 <- lapply(ASSETS, function(v) {
  i <- match(v, CELL$var_names)
  w <- hcol(0:H_TRUNC)
  data.frame(
    var = v,
    h0 = P[i, hcol(0)], h6 = P[i, hcol(6)], h12 = P[i, hcol(12)],
    h24 = P[i, hcol(24)], h48 = P[i, hcol(48)],
    n_sig68_h0a12 = sum(lo68[i, w] > 0 | hi68[i, w] < 0),
    n_sig90_h0a12 = sum(lo90[i, w] > 0 | hi90[i, w] < 0),
    n_sig90_h13a48 = sum(lo90[i, hcol(13:48)] > 0 | hi90[i, hcol(13:48)] < 0),
    sinal_h0 = sign(P[i, hcol(0)]), sinal_h12 = sign(P[i, hcol(12)]),
    sinal_h48 = sign(P[i, hcol(48)]),
    stringsAsFactors = FALSE
  )
}) |> bind_rows()

cat("\n  resumo por indice (valores em % acumulado):\n")
print(as.data.frame(resumo61), row.names = FALSE, digits = 4)

n_neg_h0  <- sum(resumo61$sinal_h0  < 0)
n_neg_h12 <- sum(resumo61$sinal_h12 < 0)
n_neg_h48 <- sum(resumo61$sinal_h48 < 0)
cat(sprintf("\n  indices com sinal NEGATIVO: h0 %d/8 | h12 %d/8 | h48 %d/8\n",
            n_neg_h0, n_neg_h12, n_neg_h48))
cat(sprintf("  horizontes sig90 somados: h0-h12 = %d | h13-h48 = %d\n",
            sum(resumo61$n_sig90_h0a12), sum(resumo61$n_sig90_h13a48)))

# dispersao da secao cruzada por horizonte — a medida direta de H2
disp <- lapply(c(0, 6, 12, 24, 36, 48), function(h) {
  x <- P[match(ASSETS, CELL$var_names), hcol(h)]
  data.frame(h = h, min = min(x), max = max(x), amplitude = max(x) - min(x),
             desvio_padrao = sd(x), n_negativos = sum(x < 0))
}) |> bind_rows()
cat("\n  dispersao da secao cruzada dos 8 indices por horizonte:\n")
print(as.data.frame(disp), row.names = FALSE, digits = 4)

diag_write(t61, "t6_1_ativos_h12.csv")
diag_write(resumo61, "t6_1b_ativos_resumo.csv")
diag_write(disp, "t6_1c_dispersao_secao_cruzada.csv")


# ===================================================================
# 6.2 — Largura da banda de 90% por horizonte
# ===================================================================
cat("\n[6.2] largura da banda de 90% em h=0/12/24/36 e razao h36/h0\n")

W <- hi90 - lo90
t62 <- lapply(ASSETS, function(v) {
  i <- match(v, CELL$var_names)
  data.frame(var = v, tcode = CELL$tcode[i],
             larg_h0 = W[i, hcol(0)], larg_h12 = W[i, hcol(12)],
             larg_h24 = W[i, hcol(24)], larg_h36 = W[i, hcol(36)],
             razao_h12_h0 = W[i, hcol(12)] / W[i, hcol(0)],
             razao_h24_h0 = W[i, hcol(24)] / W[i, hcol(0)],
             razao_h36_h0 = W[i, hcol(36)] / W[i, hcol(0)],
             stringsAsFactors = FALSE)
}) |> bind_rows() |> arrange(desc(razao_h36_h0))

print(as.data.frame(t62), row.names = FALSE, digits = 4)
cat(sprintf("\n  razao h36/h0: mediana %.2f | min %.2f | max %.2f\n",
            median(t62$razao_h36_h0), min(t62$razao_h36_h0), max(t62$razao_h36_h0)))
cat(sprintf("  razao h12/h0: mediana %.2f — o alargamento ja e %.0f%% do total em h12\n",
            median(t62$razao_h12_h0),
            100 * median(t62$razao_h12_h0) / median(t62$razao_h36_h0)))

# contraste com o resto do painel, por tcode
outros <- setdiff(CELL$var_names, ASSETS)
razao_all <- W[, hcol(36)] / W[, hcol(0)]
# yield_6m tem largura ZERO em h0 (a normalizacao fixa todas as reamostras em
# 0.005), entao a razao e Inf. E confirmacao mecanica da normalizacao, nao bug.
nao_finitos <- CELL$var_names[!is.finite(razao_all)]
t62b <- data.frame(var = CELL$var_names, tcode = CELL$tcode,
                   razao_h36_h0 = razao_all) |>
  filter(is.finite(razao_h36_h0)) |>
  group_by(tcode) |>
  summarise(n = n(), razao_mediana = median(razao_h36_h0),
            razao_min = min(razao_h36_h0), razao_max = max(razao_h36_h0),
            .groups = "drop")
cat("\n  contraste com o painel inteiro, por tcode:\n")
print(as.data.frame(t62b), row.names = FALSE, digits = 3)
cat(sprintf("  (excluida da mediana: %s — largura h0 = 0 por construcao da\n",
            paste(nao_finitos, collapse = ", ")))
cat("   normalizacao; a razao seria Inf. Confirma que o +50bp e exato.)\n")

diag_write(t62, "t6_2_largura_bandas.csv")
diag_write(t62b, "t6_2b_largura_por_tcode.csv")


# ===================================================================
# 6.3 — Serie de juro real / NTN-B: NAO EXECUTAVEL
# ===================================================================
cat("\n[6.3] serie de juro real / NTN-B no painel\n")
cat("\n  *** NAO EXECUTAVEL — dependencia de dado ausente ***\n\n")
cat("  O item pede acrescentar juro real / NTN-B (IMA-B ou taxa da NTN-B longa)\n")
cat("  ao painel para testar a hipotese de duration do IFIX.\n\n")
cat("  Estado do dado:\n")
cat("   - data/raw_data.csv TEM as colunas breakeven_1y/2y/5y, mas as 193 linhas\n")
cat("     sao a string 'NA'. script/clean.R:12 descarta colunas 100% NA, e por\n")
cat("     isso o painel processado tem 106 series e nenhum breakeven.\n")
cat("   - R/data_download/anbima_breakeven.R:41-56 chama rb3::yc_brl_get() e\n")
cat("     rb3::yc_ipca_get(); sem cache populado devolve tibble vazio com warning\n")
cat("     e o pipeline segue.\n")
cat("   - O cache rb3 (~/rb3_cache, 278MB) tem b3-bvbg-086 e\n")
cat("     b3-futures-settlement-prices, mas NAO tem b3-reference-rates, que e a\n")
cat("     fonte da curva DIC/NTN-B.\n\n")
cat("  Para executar seria preciso rodar antes, com rede:\n")
cat("     rb3::fetch_marketdata('b3-reference-rates', refdate = <~3200 dias uteis>)\n")
cat("  cobrindo 2013-01 a 2025-09.\n\n")
cat("  Nenhum substituto foi improvisado (regra do prompt, linhas 74-75).\n")
cat("  Consequencia: a hipotese de duration do IFIX fica SEM TESTE nesta rodada.\n")
cat("  O item 6.4 abaixo mede um beta de juros empirico, que e um ordenamento\n")
cat("  de sensibilidade — nao substitui a curva real.\n")


# ===================================================================
# 6.4 — Secao cruzada: resposta contra caracteristicas observaveis
# ===================================================================
cat("\n[6.4] secao cruzada dos 8 indices\n")

# O prompt pede "participacao de receita em dolar, duration implicita, beta a
# juros". Nenhuma dessas tres existe como dado no repositorio. Duas tem analogo
# empirico direto, estimado no proprio painel; a terceira fica declarada como
# indisponivel.
#
#   r_i,t = a + beta_juros * d(yield_2y_t) + beta_cambio * d(cambio_usd_t) + e
#
# beta_juros  = sensibilidade a juros (o "beta a juros" do prompt, medido)
# beta_cambio = proxy de exposicao a dolar (substitui "receita em dolar")
# duration implicita: NAO DISPONIVEL (exigiria composicao dos indices)

dy2 <- diff(PANEL[, "yield_2y"])
dfx <- diff(PANEL[, "cambio_usd"])

hc1_se <- function(fit) {
  X <- model.matrix(fit); u <- residuals(fit); n <- nrow(X); k <- ncol(X)
  bread <- solve(crossprod(X))
  meat  <- crossprod(X * u)
  sqrt(diag(bread %*% meat %*% bread) * n / (n - k))
}

betas <- lapply(ASSETS, function(v) {
  ri <- PANEL[-1, v]                       # asset_* ja sao retornos mensais
  fit <- lm(ri ~ dy2 + dfx)
  se  <- hc1_se(fit)
  cf  <- coef(fit)
  data.frame(var = v,
             beta_juros = cf[["dy2"]], se_juros = se[2],
             t_juros = cf[["dy2"]] / se[2],
             beta_cambio = cf[["dfx"]], se_cambio = se[3],
             t_cambio = cf[["dfx"]] / se[3],
             R2 = summary(fit)$r.squared,
             stringsAsFactors = FALSE)
}) |> bind_rows()

t64 <- betas |>
  mutate(irf_h0  = P[match(var, CELL$var_names), hcol(0)],
         irf_h12 = P[match(var, CELL$var_names), hcol(12)],
         irf_h48 = P[match(var, CELL$var_names), hcol(48)]) |>
  arrange(beta_juros)

cat("\n  ordenado por beta_juros (mais negativo = mais sensivel a alta de juros):\n")
print(as.data.frame(t64 |> select(var, beta_juros, t_juros, beta_cambio,
                                  t_cambio, R2, irf_h0, irf_h12, irf_h48)),
      row.names = FALSE, digits = 3)

cat("\n  duration implicita: NAO DISPONIVEL no repositorio (exigiria composicao\n")
cat("  dos indices). Declarado, nao improvisado.\n")

# A pergunta literal do prompt
rank_j <- setNames(rank(t64$beta_juros), t64$var)
pos_imob <- rank_j[["asset_imob"]]; pos_ifix <- rank_j[["asset_ifix"]]
cat(sprintf("\n  POSICAO NO ORDENAMENTO por beta_juros (1 = mais sensivel):\n"))
cat(sprintf("    asset_imob = %d de 8 | asset_ifix = %d de 8 | distancia = %d\n",
            pos_imob, pos_ifix, abs(pos_imob - pos_ifix)))

# correlacao da caracteristica com a resposta, por horizonte
cor_tab <- lapply(c(0, 6, 12, 24, 36, 48), function(h) {
  y <- P[match(t64$var, CELL$var_names), hcol(h)]
  data.frame(h = h,
             cor_beta_juros = cor(t64$beta_juros, y),
             cor_beta_cambio = cor(t64$beta_cambio, y),
             cor_sp_juros = cor(t64$beta_juros, y, method = "spearman"),
             cor_sp_cambio = cor(t64$beta_cambio, y, method = "spearman"))
}) |> bind_rows()
cat("\n  correlacao (n=8) entre caracteristica e resposta, por horizonte:\n")
print(as.data.frame(cor_tab), row.names = FALSE, digits = 3)
cat("\n  RESSALVA: a correlacao em h0 NAO e validacao independente — o beta e\n")
cat("  contemporaneo e a IRF em h0 tambem, entao parte da concordancia e\n")
cat("  mecanica. O informativo e a INVERSAO DE SINAL entre h0 e h24-h48:\n")
cat("  a mesma caracteristica que ordena a secao cruzada no impacto passa a\n")
cat("  ordena-la ao contrario no horizonte longo. Com n=8 as correlacoes sao\n")
cat("  imprecisas; o Spearman esta reportado ao lado do Pearson por isso.\n")

diag_write(t64, "t6_4_secao_cruzada.csv")
diag_write(cor_tab, "t6_4b_cor_caracteristica_resposta.csv")


# ===================================================================
# Veredito
# ===================================================================
cat("\n===== VEREDITO TAREFA 6 =====\n")
cat(sprintf("6.1 Sinal no impacto: %d dos 8 indices negativos em h0, %d em h12,\n",
            n_neg_h0, n_neg_h12))
cat(sprintf("    %d em h48. Significancia: %d horizontes sig90 em h0-h12 contra\n",
            n_neg_h48, sum(resumo61$n_sig90_h0a12)))
cat(sprintf("    %d em h13-h48 (35 horizontes a mais).\n",
            sum(resumo61$n_sig90_h13a48)))
cat(sprintf("    Amplitude da secao cruzada: %.1f pp em h0 -> %.1f pp em h48 (%.1fx).\n",
            disp$amplitude[disp$h == 0], disp$amplitude[disp$h == 48],
            disp$amplitude[disp$h == 48] / disp$amplitude[disp$h == 0]))
cat(sprintf("6.2 Razao h36/h0 da banda de 90%%: mediana %.2f nos ativos.\n",
            median(t62$razao_h36_h0)))
cat("6.3 NAO EXECUTAVEL — cache rb3 sem b3-reference-rates.\n")
cat(sprintf("6.4 asset_imob e asset_ifix nas posicoes %d e %d de 8 por beta_juros.\n",
            pos_imob, pos_ifix))

cat("\n=== TAREFA 6 concluida ===\n")
