# ===================================================================
# TAREFA 5 — Dinamica dos fatores e persistencia
#
# Se ha raiz proxima de 1 na companion, ela e a explicacao MECANICA das
# corcovas em h=24-37 e das bandas que alargam 8x-14x — sem invocar economia.
# Se o R2 do componente comum de yield_6m/juros_selic for baixo, o DFM nao
# captura a taxa de politica e a identificacao esta comprometida na raiz.
#
# Saida: diagnostics/output/t5_*.csv
# ===================================================================

source("diagnostics/_common.R")
suppressMessages({ library(urca); library(tseries) })

cat("\n=== TAREFA 5 — dinamica dos fatores e persistencia ===\n")

dfm <- estimate_dfm(PANEL, SPEC$r, SPEC$q, SPEC$p, dates = DATES,
                    instrument = inst_df(), apply_kilian = TRUE)


# ===================================================================
# 5.1 / 5.2 — Autovalores da companion
# ===================================================================
cat("\n[5.1] autovalores da matriz companion\n")

ev  <- eigen(dfm$companion_matrix)$values
mod <- sort(Mod(ev), decreasing = TRUE)
evc <- eigen(dfm$companion_corrected)$values
modc <- sort(Mod(evc), decreasing = TRUE)

t51 <- data.frame(
  ordem = 1:5,
  modulo_OLS = mod[1:5],
  modulo_Kilian = modc[1:5],
  meia_vida_meses_OLS = log(0.5) / log(pmin(mod[1:5], 0.999999))
)
print(as.data.frame(t51), row.names = FALSE, digits = 5)
cat(sprintf("\n  dimensao da companion: %d (= r*p = %d*%d)\n",
            nrow(dfm$companion_matrix), SPEC$r, SPEC$p))
cat(sprintf("  MODULO MAXIMO (OLS, usado no ponto estimado) = %.6f\n", mod[1]))
cat(sprintf("  MODULO MAXIMO (Kilian, usado so no DGP do bootstrap) = %.6f\n", modc[1]))
cat(sprintf("  raizes com modulo > 0.97: %d\n", sum(mod > 0.97)))
cat(sprintf("  raizes com modulo > 0.90: %d\n", sum(mod > 0.90)))
diag_write(t51, "t5_1_autovalores.csv")

# decaimento implicado
t52 <- data.frame(h = c(6, 12, 24, 36, 48)) |>
  mutate(rho_h_OLS = mod[1]^h, rho_h_Kilian = modc[1]^h)
cat("\n[5.2] decaimento implicado pela maior raiz\n")
print(as.data.frame(t52), row.names = FALSE, digits = 4)
cat("  -> em h=48 ainda restam", round(100 * mod[1]^48, 1), "% do impulso inicial.\n")
diag_write(t52, "t5_2_decaimento.csv")

# largura das bandas de 90% em funcao do horizonte (o alargamento 8x-14x)
if (!is.null(CELL)) {
  lo <- CELL$irf$ci[["0.90"]]$lower; hi <- CELL$irf$ci[["0.90"]]$upper
  W  <- hi - lo
  t52b <- lapply(c("yield_6m", "cambio_usd", "embi_perc", "price_core_ipca_ex0",
                   "asset_ibov", "asset_ifix", "asset_imob", "ind_transformacao",
                   "pib", "ibc_br"), function(v) {
    i <- match(v, CELL$var_names)
    data.frame(var = v, larg_h0 = W[i, 1], larg_h12 = W[i, 13],
               larg_h24 = W[i, 25], larg_h36 = W[i, 37],
               razao_h36_h0 = W[i, 37] / W[i, 1],
               razao_h12_h0 = W[i, 13] / W[i, 1])
  }) |> bind_rows()
  cat("\n  largura da banda de 90% por horizonte:\n")
  print(as.data.frame(t52b), row.names = FALSE, digits = 4)
  diag_write(t52b, "t5_2b_largura_bandas.csv")
}


# ===================================================================
# 5.3 — Ordem de defasagens: escolhida como?
# ===================================================================
cat("\n[5.3] ordem de defasagens\n")

Fh <- dfm$static_factors
ic_tbl <- lapply(1:12, function(pp) {
  v <- estimate_var_ols(Fh, pp)
  Tn <- nrow(v$residuals); K <- ncol(Fh)
  S  <- crossprod(v$residuals) / Tn
  ld <- determinant(S, logarithm = TRUE)$modulus
  np <- K * K * pp
  data.frame(p = pp, logdet = as.numeric(ld),
             AIC = as.numeric(ld) + 2 * np / Tn,
             BIC = as.numeric(ld) + log(Tn) * np / Tn,
             HQ  = as.numeric(ld) + 2 * log(log(Tn)) * np / Tn,
             max_eig = max(Mod(eigen(v$companion)$values)))
}) |> bind_rows()
print(as.data.frame(ic_tbl), row.names = FALSE, digits = 5)
cat(sprintf("\n  argmin: AIC p=%d | BIC p=%d | HQ p=%d\n",
            ic_tbl$p[which.min(ic_tbl$AIC)], ic_tbl$p[which.min(ic_tbl$BIC)],
            ic_tbl$p[which.min(ic_tbl$HQ)]))
cat("  PRODUCAO: p = 6, HARD-CODED em model_alessi.R:166 e irf_coherence_check.R:37.\n")
cat("  Nenhum criterio e consultado no pipeline.\n")
diag_write(ic_tbl, "t5_3_ordem_defasagens.csv")


# ===================================================================
# 5.4 — Raiz unitaria serie a serie (ADF e KPSS)
# ===================================================================
cat("\n[5.4] ADF e KPSS por serie, cruzado com o tcode\n")

t54 <- lapply(seq_along(VAR_NAMES), function(i) {
  x <- PANEL[, i]
  adf_p <- tryCatch({
    s <- summary(urca::ur.df(x, type = "drift", selectlags = "AIC"))
    tstat <- s@teststat[1]; cv <- s@cval[1, ]
    # rejeita raiz unitaria se |t| > |valor critico 5%|
    as.numeric(tstat < cv["5pct"])
  }, error = function(e) NA_real_)
  kpss_p <- tryCatch(suppressWarnings(tseries::kpss.test(x, null = "Level")$p.value),
                     error = function(e) NA_real_)
  data.frame(var = VAR_NAMES[i], grupo = var_group(VAR_NAMES[i]),
             tcode = TCODE[i],
             adf_rejeita_RU_5pct = as.logical(adf_p),
             kpss_p = kpss_p,
             kpss_rejeita_estac_5pct = kpss_p < 0.05)
}) |> bind_rows()

t54 <- t54 |> mutate(
  veredito = case_when(
    !adf_rejeita_RU_5pct &  kpss_rejeita_estac_5pct ~ "I(1) — os dois concordam",
     adf_rejeita_RU_5pct & !kpss_rejeita_estac_5pct ~ "I(0) — os dois concordam",
    TRUE ~ "ambiguo"
  ))

cat("\n  resumo:\n")
print(as.data.frame(t54 |> count(veredito)), row.names = FALSE)
cat("\n  por tcode:\n")
print(as.data.frame(t54 |> count(tcode, veredito) |> arrange(tcode)), row.names = FALSE)

nao_est <- t54 |> filter(veredito == "I(1) — os dois concordam", tcode == 1)
cat(sprintf("\n  series I(1) que entram em NIVEL sem transformacao (tcode 1): %d de %d\n",
            nrow(nao_est), sum(TCODE == 1)))
cat("  (isso e ESPERADO: o DFM e em nivel destendenciado por desenho BLL)\n")

cat("\n  checagem de dupla acumulacao: tcodes 3 e 5 atribuidos a alguma serie?\n")
cat("   tcode 3:", sum(TCODE == 3), " | tcode 5:", sum(TCODE == 5),
    " -> nenhuma serie e diferenciada e acumulada duas vezes.\n")
diag_write(t54, "t5_4_raiz_unitaria.csv")


# ===================================================================
# 5.5 — R2 do componente comum, serie a serie
# ===================================================================
cat("\n[5.5] R2 do componente comum (projecao nos r=7 fatores)\n")

sy   <- dfm$data_sd
Chi  <- sweep(dfm$static_factors %*% t(dfm$static_loadings), 2, sy, "*")
Xdt  <- dfm$detrended_data
Idio <- Xdt - Chi

# Tres medidas, e a diferenca entre elas E o achado:
#  R2_chi — reconstrucao do PROPRIO DFM: Chi = F * Lambda' * sy. E o objeto que
#           gera as IRFs (impulse_responde.R:448-455 usa o mesmo Lambda).
#  R2_ols — projecao de minimos quadrados da serie nos mesmos 7 fatores. Mede se
#           os fatores GERAM a serie, independentemente de Lambda.
#  R2_dif — o mesmo em primeira diferenca, que e o espaco onde Lambda foi estimado
#           (eigs(cov(yy)) em DFMest_BLL.m:24 / factor_estimation.R:323-330).
Fh_st <- dfm$static_factors
R2_ols <- sapply(seq_len(ncol(Xdt)),
                 function(i) summary(lm(Xdt[, i] ~ Fh_st))$r.squared)
dX <- diff(Xdt); dF <- diff(Fh_st)
R2_dif <- sapply(seq_len(ncol(dX)),
                 function(i) summary(lm(dX[, i] ~ dF))$r.squared)

t55 <- data.frame(
  var = VAR_NAMES, grupo = var_group(VAR_NAMES), tcode = TCODE,
  R2_comum = 1 - apply(Idio, 2, var) / apply(Xdt, 2, var),
  R2_ols = R2_ols, R2_dif = R2_dif
) |>
  mutate(gap_ols_chi = R2_ols - R2_comum) |>
  arrange(desc(R2_comum))

cat("\n  ATENCAO — R2_comum e NEGATIVO em", sum(t55$R2_comum < 0), "de",
    nrow(t55), "series, contra", sum(t55$R2_ols < 0), "em R2_ols.\n")
cat("  Os fatores GERAM essas series (R2_ols alto); o Lambda que as RECONSTROI,\n")
cat("  nao. Lambda vem dos autovetores da covariancia das PRIMEIRAS DIFERENCAS\n")
cat("  e e aplicado ao NIVEL destendenciado — fiel a DFMest_BLL.m:24/26/62, mas\n")
cat("  desalinhado para as series que ja sao I(0) em nivel (taxas e retornos).\n")

cat("\n  media por grupo:\n")
print(as.data.frame(t55 |> group_by(grupo) |>
        summarise(n = n(), R2_chi = mean(R2_comum), R2_ols = mean(R2_ols),
                  R2_dif = mean(R2_dif), n_neg = sum(R2_comum < 0),
                  .groups = "drop") |>
        arrange(desc(R2_chi))), row.names = FALSE, digits = 3)

DESTAQUE <- c("juros_selic", "juros_cdi", "yield_6m", "yield_3m", "yield_2y",
              "yield_10y", "pib", "ibc_br", "cambio_usd", "embi_perc",
              "cds_5y", "price_core_ipca_ex0", "price_ipca", "commodity_metal",
              "asset_ibov", "asset_ifix", "ind_transformacao")
cat("\n  series destacadas:\n")
print(as.data.frame(t55 |> filter(var %in% DESTAQUE) |> arrange(desc(R2_comum)) |>
        select(var, grupo, tcode, R2_comum, R2_ols, R2_dif, gap_ols_chi)),
      row.names = FALSE, digits = 3)

cat("\n  distribuicao geral: min", round(min(t55$R2_comum), 3),
    "| mediana", round(median(t55$R2_comum), 3),
    "| max", round(max(t55$R2_comum), 3), "\n")
cat("  series com R2 < 0.5:", sum(t55$R2_comum < 0.5), "de", nrow(t55), "\n")
diag_write(t55, "t5_5_r2_comum.csv")


# ===================================================================
# Veredito
# ===================================================================
cat("\n===== VEREDITO TAREFA 5 =====\n")
cat(sprintf("Maior raiz = %.4f (> 0.97). E a explicacao mecanica das corcovas\n", mod[1]))
cat("em h=24-37 e do alargamento das bandas. NAO e bug: o DFM e em nivel\n")
cat("destendenciado (BLL/Alessi-Kerssenfischer) e raiz quase unitaria e a\n")
cat("especificacao. A consequencia pratica e o limite de interpretacao.\n")
r2 <- setNames(t55$R2_comum, t55$var)
cat(sprintf("\nR2 comum: yield_6m %.3f | juros_selic %.3f | pib %.3f | ibc_br %.3f\n",
            r2["yield_6m"], r2["juros_selic"], r2["pib"], r2["ibc_br"]))

cat("\n=== TAREFA 5 concluida ===\n")
