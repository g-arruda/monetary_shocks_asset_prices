# ===================================================================
# TAREFA 1 — Exogeneidade do instrumento (DECISIVA)
#
# O placebo que falha (`commodity_metal`) falha na mesma janela h=0-4 em que
# a cadeia cambio -> risco -> precos e significativa. Duas leituras concorrem:
#   (A) um fator global de commodity/risco move as duas coisas, e o choque
#       domestico nao esta identificado;
#   (B) o instrumento e exogeno e `commodity_metal` nao e placebo valido.
#
# Todos os testes saem com Wald robusto (HC1) E p-valor por wild bootstrap,
# porque z e zero-censurado (mascara JK) e a heterocedasticidade e severa.
#
# Saida: diagnostics/output/t1_*.csv
# ===================================================================

source("diagnostics/_common.R")

set.seed(20260728)
NBOOT_P <- 2000L

cat("\n=== TAREFA 1 — exogeneidade do instrumento ===\n")


# -------------------------------------------------------------------
# Infraestrutura de teste
# -------------------------------------------------------------------

#' Wald conjunto robusto (HC1) de que TODOS os regressores (menos a constante)
#' sao zero, com p-valor assintotico e p-valor por wild bootstrap sob H0.
#'
#' O bootstrap reamostra sob a nula (y = mean(y) + residuo * Rademacher), que e
#' o desenho correto para um teste de previsibilidade e nao sofre com a
#' censura em zero de z.
robust_joint_test <- function(y, X, nboot = NBOOT_P, label = "") {
  ok <- is.finite(y) & apply(is.finite(X), 1, all)
  y <- y[ok]; X <- X[ok, , drop = FALSE]
  n <- length(y); k <- ncol(X)
  if (n <= k + 2) {
    return(data.frame(teste = label, n = n, k = k, R2 = NA_real_,
                      F_rob = NA_real_, p_asym = NA_real_, p_boot = NA_real_))
  }
  fit <- lm(y ~ X)
  R2  <- summary(fit)$r.squared
  V   <- sandwich::vcovHC(fit, type = "HC1")
  idx <- 2:(k + 1)
  b   <- coef(fit)[idx]
  keep <- is.finite(b)
  idx <- idx[keep]; b <- b[keep]
  W   <- tryCatch(drop(t(b) %*% solve(V[idx, idx, drop = FALSE], b)),
                  error = function(e) NA_real_)
  Fst <- W / length(b)
  p_a <- pf(Fst, length(b), n - k - 1, lower.tail = FALSE)

  # wild bootstrap sob H0: y* = ybar + e0 * rademacher, e0 = residuo da nula
  e0 <- y - mean(y)
  Fb <- replicate(nboot, {
    ys <- mean(y) + e0 * (1 - 2 * (runif(n) > 0.5))
    fb <- lm(ys ~ X)
    Vb <- tryCatch(sandwich::vcovHC(fb, type = "HC1"), error = function(e) NULL)
    if (is.null(Vb)) return(NA_real_)
    bb <- coef(fb)[idx]
    if (any(!is.finite(bb))) return(NA_real_)
    tryCatch(drop(t(bb) %*% solve(Vb[idx, idx, drop = FALSE], bb)) / length(bb),
             error = function(e) NA_real_)
  })
  data.frame(teste = label, n = n, k = k, R2 = R2, F_rob = Fst,
             p_asym = p_a, p_boot = mean(Fb >= Fst, na.rm = TRUE))
}


#' Wald conjunto robusto (HC1) de que os coeficientes de `X_test` sao zero,
#' mantendo `X_free` irrestrito, com p-valor por wild bootstrap sob H0.
#'
#' Generaliza `robust_joint_test`: la a nula e "todos os regressores sao zero" e
#' o residuo sob H0 e `y - mean(y)`; aqui a nula e restrita ao bloco `X_test` e o
#' residuo sob H0 vem da regressao restrita `y ~ X_free`. Com `X_free` vazio as
#' duas coincidem, o que o auto-teste abaixo verifica.
robust_subset_test <- function(y, X_free, X_test, nboot = NBOOT_P, label = "",
                               equacao = NA_character_) {
  X_free <- if (is.null(X_free) || ncol(X_free) == 0) NULL else as.matrix(X_free)
  X_test <- as.matrix(X_test)
  ok <- is.finite(y) & apply(is.finite(X_test), 1, all) &
    (if (is.null(X_free)) TRUE else apply(is.finite(X_free), 1, all))
  y <- y[ok]; X_test <- X_test[ok, , drop = FALSE]
  if (!is.null(X_free)) X_free <- X_free[ok, , drop = FALSE]

  n <- length(y)
  k_free <- if (is.null(X_free)) 0L else ncol(X_free)
  k_test <- ncol(X_test)
  na_row <- data.frame(teste = label, equacao = equacao, n = n, k = k_test,
                       R2 = NA_real_, F_rob = NA_real_, p_asym = NA_real_,
                       p_boot = NA_real_)
  if (n <= k_free + k_test + 2) return(na_row)

  X_all <- if (is.null(X_free)) X_test else cbind(X_free, X_test)
  idx   <- (k_free + 2):(k_free + k_test + 1)   # +1 pela constante do lm

  wald <- function(yy) {
    fit <- lm(yy ~ X_all)
    V   <- tryCatch(sandwich::vcovHC(fit, type = "HC1"), error = function(e) NULL)
    if (is.null(V)) return(NA_real_)
    b <- coef(fit)[idx]
    if (any(!is.finite(b))) return(NA_real_)
    tryCatch(drop(t(b) %*% solve(V[idx, idx, drop = FALSE], b)) / length(b),
             error = function(e) NA_real_)
  }

  Fst <- wald(y)
  if (!is.finite(Fst)) return(na_row)
  R2  <- summary(lm(y ~ X_all))$r.squared
  p_a <- pf(Fst, k_test, n - k_free - k_test - 1, lower.tail = FALSE)

  # wild bootstrap sob H0: y* = ajuste da restrita + residuo da restrita * rademacher
  fit0 <- if (is.null(X_free)) lm(y ~ 1) else lm(y ~ X_free)
  mu0  <- fitted(fit0)
  e0   <- residuals(fit0)
  Fb <- replicate(nboot, wald(mu0 + e0 * (1 - 2 * (runif(n) > 0.5))))

  data.frame(teste = label, equacao = equacao, n = n, k = k_test, R2 = R2,
             F_rob = Fst, p_asym = p_a, p_boot = mean(Fb >= Fst, na.rm = TRUE))
}


# -------------------------------------------------------------------
# Dados: instrumento alinhado ao painel
# -------------------------------------------------------------------
z_df <- inst_df(SPEC$instrument)
al   <- data.frame(month = DATES) |>
  dplyr::left_join(z_df, by = "month")
Z    <- al$shock
stopifnot(length(Z) == nrow(PANEL))
cat(sprintf("instrumento %s: %d meses, %d nao-nulos, sd = %.3f\n",
            SPEC$instrument, sum(!is.na(Z)), sum(Z != 0, na.rm = TRUE),
            sd(Z, na.rm = TRUE)))

GLOBALS <- c("sp500_vix", "msci", "commodity_metal", "epu_us", "cambio_usd")


# ===================================================================
# 1.1 — z sobre defasagens de fatores globais
# ===================================================================
cat("\n[1.1] previsibilidade por fatores globais\n")

G_lvl <- PANEL[, GLOBALS, drop = FALSE]
G_ret <- rbind(NA, diff(log(G_lvl)))          # log-retorno; EPU/VIX sao positivos
colnames(G_ret) <- GLOBALS

t11 <- list()
for (spec_lab in c("niveis", "retornos")) {
  Gm <- if (spec_lab == "niveis") G_lvl else G_ret
  for (L in c(6L, 3L)) {
    XL <- lag_matrix(Gm, L, "g")
    yL <- Z[(L + 1):length(Z)]
    t11[[length(t11) + 1]] <- robust_joint_test(
      yL, XL, label = sprintf("global_%s_L%d_conjunto", spec_lab, L))
    # por regressor
    for (g in GLOBALS) {
      cols <- grep(paste0("^g_", g, "_l"), colnames(XL))
      t11[[length(t11) + 1]] <- robust_joint_test(
        yL, XL[, cols, drop = FALSE],
        label = sprintf("global_%s_L%d_%s", spec_lab, L, g))
    }
  }
}
t11 <- dplyr::bind_rows(t11)
print(as.data.frame(t11), row.names = FALSE, digits = 4)
diag_write(t11, "t1_1_globais.csv")


# ===================================================================
# 1.2 — z sobre defasagens dos fatores estimados e das inovacoes eta
# ===================================================================
cat("\n[1.2] previsibilidade pelos fatores estimados (Stock-Watson / Mertens-Ravn)\n")

dfm <- estimate_dfm(PANEL, SPEC$r, SPEC$q, SPEC$p, dates = DATES,
                    instrument = NULL, apply_kilian = FALSE)
Fh  <- dfm$static_factors
colnames(Fh) <- paste0("F", seq_len(ncol(Fh)))

t12 <- list()
for (L in c(6L, 3L, 1L)) {
  XL <- lag_matrix(Fh, L, "f")
  yL <- Z[(L + 1):length(Z)]
  t12[[length(t12) + 1]] <- robust_joint_test(
    yL, XL, label = sprintf("fatores_L%d_conjunto", L))
}

# eta: inovacoes dinamicas, alinhadas via sel_ext_inst_sample
eta <- extract_dynamic_innovations(dfm)
colnames(eta) <- paste0("eta", seq_len(ncol(eta)))
z_eta <- Z[(SPEC$p + 1):length(Z)]

for (L in c(6L, 3L)) {
  XL <- lag_matrix(eta, L, "e")
  yL <- z_eta[(L + 1):length(z_eta)]
  t12[[length(t12) + 1]] <- robust_joint_test(
    yL, XL, label = sprintf("eta_defasado_L%d_conjunto", L))
}

# leads de eta: z_t nao deve prever eta FUTURO alem do canal monetario
for (L in c(3L, 6L)) {
  T2 <- nrow(eta)
  XL <- do.call(cbind, lapply(seq_len(L), function(l) {
    m <- eta[(1 + l):(T2 - L + l), , drop = FALSE]
    colnames(m) <- paste0("lead", l, "_", colnames(eta)); m
  }))
  yL <- z_eta[seq_len(nrow(XL))]
  t12[[length(t12) + 1]] <- robust_joint_test(
    yL, XL, label = sprintf("eta_LEAD_L%d_conjunto", L))
}

t12 <- dplyr::bind_rows(t12)
print(as.data.frame(t12), row.names = FALSE, digits = 4)
diag_write(t12, "t1_2_fatores.csv")


# ===================================================================
# 1.3 — autocorrelacao do proprio instrumento
# ===================================================================
cat("\n[1.3] autocorrelacao do instrumento\n")

zc <- Z[is.finite(Z)]
t13_ar <- robust_joint_test(zc[7:length(zc)],
                            lag_matrix(matrix(zc, ncol = 1), 6L, "z"),
                            label = "z_sobre_proprios_lags_L6")
lb <- lapply(c(1, 2, 3, 6, 12), function(k) {
  b <- Box.test(zc, lag = k, type = "Ljung-Box")
  data.frame(lag = k, Q = unname(b$statistic), p = b$p.value)
}) |> dplyr::bind_rows()
acf_z <- data.frame(lag = 1:12, acf = as.numeric(acf(zc, plot = FALSE, lag.max = 12)$acf)[-1])

print(as.data.frame(t13_ar), row.names = FALSE, digits = 4)
print(lb, row.names = FALSE, digits = 4)
print(acf_z, row.names = FALSE, digits = 4)
diag_write(dplyr::bind_rows(t13_ar |> dplyr::mutate(bloco = "wald"),
                     lb |> dplyr::transmute(teste = paste0("ljung_box_lag", lag),
                                     F_rob = Q, p_asym = p, bloco = "ljung_box"),
                     acf_z |> dplyr::transmute(teste = paste0("acf_lag", lag),
                                        R2 = acf, bloco = "acf")),
           "t1_3_autocorrelacao.csv")


# ===================================================================
# 1.4 / 1.5 — correlacoes com placebos, contemporaneas e em -6..+6
# ===================================================================
cat("\n[1.4/1.5] correlacoes cruzadas com placebos e variaveis-chave\n")

CROSS <- c(GLOBALS, "commodity_agro", "commodity_energia", "embi_perc",
           "cds_5y", "epu_brazil")
lagcor <- function(z, x, kmax = 6) {
  out <- lapply(-kmax:kmax, function(k) {
    if (k < 0) { a <- z[(1 - k):length(z)];       b <- x[1:(length(x) + k)] }
    else if (k > 0) { a <- z[1:(length(z) - k)];  b <- x[(1 + k):length(x)] }
    else { a <- z; b <- x }
    ok <- is.finite(a) & is.finite(b)
    data.frame(k = k, cor = if (sum(ok) > 5) cor(a[ok], b[ok]) else NA_real_,
               n = sum(ok))
  })
  dplyr::bind_rows(out)
}

t14 <- list()
for (v in CROSS) {
  x_lvl <- PANEL[, v]
  x_ret <- c(NA, diff(log(x_lvl)))
  for (tp in c("nivel", "retorno")) {
    cc <- lagcor(Z, if (tp == "nivel") x_lvl else x_ret)
    t14[[length(t14) + 1]] <- cc |> dplyr::mutate(var = v, transf = tp, .before = 1)
  }
}
t14 <- dplyr::bind_rows(t14)
cat("\n-- correlacao CONTEMPORANEA (k=0), em retorno --\n")
print(as.data.frame(t14 |> dplyr::filter(k == 0, transf == "retorno") |>
                      dplyr::select(var, cor, n) |> dplyr::arrange(dplyr::desc(abs(cor)))),
      row.names = FALSE, digits = 4)
cat("\n-- maior |cor| em qualquer k, por variavel (retorno) --\n")
print(as.data.frame(t14 |> dplyr::filter(transf == "retorno") |> dplyr::group_by(var) |>
        dplyr::slice_max(abs(cor), n = 1) |> dplyr::ungroup() |>
        dplyr::select(var, k, cor) |> dplyr::arrange(dplyr::desc(abs(cor)))),
      row.names = FALSE, digits = 4)
diag_write(t14, "t1_45_correlacoes_cruzadas.csv")


# ===================================================================
# 1.6 — TESTE DECISIVO: commodity em BRL vs USD
# O IC-Br do BCB e denominado em R$. Se a violacao do placebo desaparece ao
# reexpressar o indice em dolar, ela e artefato de denominacao — nao falha
# de exogeneidade do instrumento.
# ===================================================================
cat("\n[1.6] placebo commodity: BRL vs USD\n")

fx <- PANEL[, "cambio_usd"]
aug <- cbind(PANEL,
             commodity_metal_usd   = PANEL[, "commodity_metal"]   / fx,
             commodity_agro_usd    = PANEL[, "commodity_agro"]    / fx,
             commodity_energia_usd = PANEL[, "commodity_energia"] / fx)

cat("cor(dlog metal BRL, dlog cambio) =",
    round(cor(diff(log(PANEL[, "commodity_metal"])), diff(log(fx))), 4), "\n")
cat("cor(dlog metal USD, dlog cambio) =",
    round(cor(diff(log(aug[, "commodity_metal_usd"])), diff(log(fx))), 4), "\n")

tc_aug <- infer_tcode_from_varnames(colnames(aug))
cell_aug <- run_stage2_cell(
  aug, DATES, INST_PANEL, sample_window = SPEC$window,
  r = SPEC$r, q = SPEC$q, p = SPEC$p,
  instrument = SPEC$instrument, mp_var = SPEC$mp_var,
  h = 24L, nboot = 200L, seed = SPEC$seed,
  shock_bps = SPEC$shock_bps, tcode = tc_aug, ci_levels = SPEC$ci_levels
)

vn <- colnames(aug)
P  <- cell_aug$irf$irf_point_matrix
lo90 <- cell_aug$irf$ci[["0.90"]]$lower
hi90 <- cell_aug$irf$ci[["0.90"]]$upper
means <- colMeans(aug)

t16 <- lapply(c("commodity_metal", "commodity_metal_usd",
                "commodity_agro", "commodity_agro_usd",
                "commodity_energia", "commodity_energia_usd",
                "cambio_usd", "msci", "sp500_vix", "epu_us"), function(v) {
  i <- match(v, vn)
  data.frame(var = v,
             h0 = P[i, 1], h0_pct_media = 100 * P[i, 1] / means[i],
             lo90_h0 = lo90[i, 1], hi90_h0 = hi90[i, 1],
             sig90_h0 = lo90[i, 1] > 0 | hi90[i, 1] < 0,
             n_sig90_h0a4 = sum(lo90[i, 1:5] > 0 | hi90[i, 1:5] < 0),
             n_sig90_h0a24 = sum(lo90[i, ] > 0 | hi90[i, ] < 0))
}) |> dplyr::bind_rows()

cat("\n-- IRF de impacto, painel aumentado (nboot=200) --\n")
print(as.data.frame(t16), row.names = FALSE, digits = 4)
# run_stage2_cell nao devolve o bloco de forca; recomputa-lo aqui e barato e
# permite comparar o espaco de fatores dos dois paineis lado a lado.
fs_cmp <- lapply(list(producao = PANEL, aumentado = aug), function(M) {
  d  <- estimate_dfm(M, SPEC$r, SPEC$q, SPEC$p, dates = DATES,
                     instrument = z_df, apply_kilian = FALSE)
  fs <- diagnose_instrument_in_factor_space(d, z_df, DATES, SPEC$p,
                                            match(SPEC$mp_var, colnames(M)))
  data.frame(n_series = ncol(M), max_eig = d$diagnostics$max_eigenvalue,
             xi_mp = fs$wald_mp, f_robust_mp = fs$f_robust_mp)
}) |> dplyr::bind_rows(.id = "painel")
cat("\n-- espaco de fatores: producao vs aumentado --\n")
print(as.data.frame(fs_cmp), row.names = FALSE, digits = 5)
diag_write(fs_cmp, "t1_6_espaco_fatores.csv")
diag_write(t16, "t1_6_placebo_brl_vs_usd.csv")


# ===================================================================
# 1.7 — INVERTIBILIDADE: z Granger-causa os fatores?
#
# ATENCAO: este bloco NAO testa exogeneidade. O estimador de producao e o
# SVAR-IV, e a Condicao SVAR-IV de Stock-Watson (2018, secao 2.1) exige apenas
# relevancia e exogeneidade CONTEMPORANEA -- os autores dizem explicitamente que
# o SVAR-IV "does not require lead-lag exogeneity. But to be valid, this method
# requires invertibility". A condicao lead-lag e da LP-IV (Condicao LP-IV, item
# iii), e a troca esta no Theorem 1 deles: as duas rotas gastam o mesmo orcamento
# de hipoteses.
#
# O que se testa aqui e a hipotese que o proxy-DFM de fato assume e que nada no
# repositorio interroga: a invertibilidade. Sob invertibilidade o passado dos
# fatores ja contem a informacao do instrumento, logo defasagens de z nao podem
# ajudar a prever os fatores. E o teste que SW rodam na Tabela 2 deles como
# "VAR Z-GC test", devido a Forni-Gambetti (2014): F conjunto de que os
# coeficientes das defasagens de z sao nulos em CADA equacao do VAR.
#
# Regra de veredito, fixada antes dos numeros:
#   - L = p = 6 decide (casa com a ordem do proprio VAR de fatores); L = 3 e
#     sensibilidade;
#   - p por wild bootstrap sob H0, nao assintotico, porque z e censurado em zero;
#   - Holm sobre as r equacoes, dentro de cada L; rejeita se algum p ajustado
#     ficar abaixo de 0,05.
# Nao-rejeicao e teste de condicao NECESSARIA: nao estabelece invertibilidade.
# ===================================================================
cat("\n[1.7] invertibilidade: z Granger-causa os fatores? (SW Tabela 2)\n")

P_LAG <- SPEC$p
Zm <- matrix(Z, ncol = 1, dimnames = list(NULL, "z"))
F_lags <- lag_matrix(Fh, P_LAG, "f")             # defasagens 1..p dos r fatores
Z_lags <- lag_matrix(Zm, P_LAG, "inst")          # defasagens 1..p de z
y_all  <- Fh[(P_LAG + 1):nrow(Fh), , drop = FALSE]
stopifnot(nrow(F_lags) == nrow(Z_lags), nrow(F_lags) == nrow(y_all))

# auto-teste: com X_free vazio, robust_subset_test tem de reproduzir
# robust_joint_test na mesma amostra (mesma Wald, mesmo R2)
.chk_y <- y_all[, 1]
.chk_a <- robust_joint_test(.chk_y, F_lags, nboot = 1L, label = "chk")
.chk_b <- robust_subset_test(.chk_y, NULL, F_lags, nboot = 1L, label = "chk")
stopifnot(isTRUE(all.equal(.chk_a$F_rob, .chk_b$F_rob)),
          isTRUE(all.equal(.chk_a$R2,    .chk_b$R2)))
cat("  auto-teste robust_subset_test == robust_joint_test (X_free vazio): OK\n")

t17 <- lapply(c(6L, 3L), function(L) {
  cols <- paste0("inst_z_l", seq_len(L))
  out <- lapply(seq_len(ncol(Fh)), function(i) {
    robust_subset_test(y_all[, i], F_lags, Z_lags[, cols, drop = FALSE],
                       label = sprintf("granger_z_para_fator_L%d", L),
                       equacao = colnames(Fh)[i])
  }) |> dplyr::bind_rows()
  out |> dplyr::mutate(L = L, p_holm = p.adjust(p_boot, "holm"), .before = 1)
}) |> dplyr::bind_rows()

print(as.data.frame(t17), row.names = FALSE, digits = 4)
diag_write(t17, "t1_7_invertibilidade_granger.csv")

gc_dec <- t17 |> dplyr::filter(L == P_LAG)
cat(sprintf("\nVEREDITO (invertibilidade, L = %d, Holm sobre %d equacoes): %s\n",
            P_LAG, nrow(gc_dec),
            if (all(gc_dec$p_holm >= 0.05, na.rm = TRUE))
              "nao-causalidade de Granger NAO rejeitada — condicao necessaria de invertibilidade sobrevive"
            else paste0("REJEITADA em: ",
                        paste(gc_dec$equacao[gc_dec$p_holm < 0.05], collapse = ", "))))
cat("  (nao-rejeicao nao estabelece invertibilidade; e teste de condicao necessaria)\n")


# ===================================================================
# Veredito da trava de parada
# ===================================================================
cat("\n===== TRAVA DE PARADA (previsibilidade significativa a 5%) =====\n")
gate <- dplyr::bind_rows(
  t11 |> dplyr::filter(grepl("retornos_L6_conjunto|retornos_L3_conjunto", teste)),
  t12 |> dplyr::filter(grepl("^fatores_L", teste))
) |> dplyr::select(teste, n, k, R2, F_rob, p_asym, p_boot)
print(as.data.frame(gate), row.names = FALSE, digits = 4)
fail <- gate |> dplyr::filter(p_boot < 0.05)
cat(if (nrow(fail) == 0)
      "\nVEREDITO: nenhuma previsibilidade significativa a 5% (p bootstrap). PROSSEGUIR.\n"
    else paste0("\nVEREDITO: PARAR — previsibilidade em: ",
                paste(fail$teste, collapse = ", "), "\n"))
diag_write(gate, "t1_gate.csv")

cat("\n=== TAREFA 1 concluida ===\n")
