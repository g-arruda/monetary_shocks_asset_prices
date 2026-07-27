# ============================================================
# Non-Gaussianity gate for the GMR (2017) / LMS (2017) route.
#
# Both estimators identify C only if AT MOST ONE of the structural shocks is
# Gaussian (Comon 1994 / Eriksson-Koivunen 2004; GMR Prop. 2a). This script
# tests that precondition on the q dynamic-factor innovations `eta` of the
# production DFM, in both sample windows, and locates the proxy's impact
# direction relative to the Gaussian and non-Gaussian spans — because what the
# paper needs identified is the monetary column, not all of C.
#
# `_instrucoes/pendencias.md` suggested reusing `output/irf/irf_coherence_cell.rds`
# to avoid re-estimating. That file does not carry the DFM object (only irf,
# var_names, tcode, mpind, ...), so the gate re-estimates; it is cheap because
# nothing here needs the bootstrap.
#
# Run: Rscript script/nongaussian_gate.R
# Writes: output/nongaussian/gate.md
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
})

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/nongaussian_gmr.R")

R_PROD <- 7L
Q_PROD <- 6L
P_LAGS <- 6
COVID_START <- as.Date("2020-03-01")
OUT_DIR <- "output/nongaussian"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# ------------------------------------------------------------------
# Estimate the production DFM and extract eta
# ------------------------------------------------------------------
raw <- read_csv("data/processed/data_log_deseasonalized.csv",
                show_col_types = FALSE) |> drop_na()
dates <- as.Date(raw$ref.date)
data  <- raw |> select(-ref.date) |> as.matrix()
inst  <- read_csv("data/processed/instrument.csv", show_col_types = FALSE)

dfm <- estimate_dfm(data, R_PROD, Q_PROD, P_LAGS, dates = dates,
                    instrument = inst, apply_kilian = TRUE)

eta <- dfm$var_residuals %*% dfm$dynamic_loadings %*% solve(dfm$dynamic_scaling)
eta_dates <- as.Date(dfm$dates)[(P_LAGS + 1):length(dfm$dates)]
stopifnot(nrow(eta) == length(eta_dates))

# ------------------------------------------------------------------
# Normality diagnostics per component
# ------------------------------------------------------------------
moments_tbl <- function(E, label) {
  do.call(rbind, lapply(seq_len(ncol(E)), function(i) {
    x  <- E[, i]; m <- length(x)
    s  <- mean((x - mean(x))^3) / sd(x)^3
    k  <- mean((x - mean(x))^4) / sd(x)^4
    jb <- m / 6 * (s^2 + (k - 3)^2 / 4)
    data.frame(window = label, comp = sprintf("eta_%d", i), T_eff = m,
               skew = s, kurtosis = k, JB = jb,
               p_JB = pchisq(jb, 2, lower.tail = FALSE),
               p_SW = shapiro.test(x)$p.value)
  }))
}

pre <- eta_dates < COVID_START
tbl <- rbind(moments_tbl(eta, "full"),
             moments_tbl(eta[pre, , drop = FALSE], "pre_covid"))

n_gauss <- function(sub, alpha = 0.05) sum(sub$p_JB > alpha)
ng_full <- n_gauss(tbl[tbl$window == "full", ])
ng_pre  <- n_gauss(tbl[tbl$window == "pre_covid", ])

# ------------------------------------------------------------------
# Where does the proxy's impact direction live?
# ------------------------------------------------------------------
align <- sel_ext_inst_sample(as.Date(dfm$dates), P_LAGS, inst)
Zsel  <- align$inst_sel
eta_s <- eta[align$rsh_sel_ind, , drop = FALSE]
eta_s <- sweep(eta_s, 2, colMeans(eta_s))
H     <- drop(crossprod(as.matrix(Zsel), eta_s)) / drop(crossprod(as.matrix(Zsel)))
h     <- H / sqrt(sum(H^2))

p_full  <- tbl[tbl$window == "full", ]
is_nong <- p_full$p_JB < 0.05
share_nong <- sum(h[is_nong]^2)
share_gauss <- sum(h[!is_nong]^2)

# ------------------------------------------------------------------
# Conditioning of A at a PML fit on the full sample
# ------------------------------------------------------------------
distri <- gmr_distri_mixtures(Q_PROD)
P_w  <- t(chol(var(eta)))
Yw   <- eta %*% solve(t(P_w))
fit  <- estim_ica_pml(Yw, distri, n_starts = 100L, seed = 123)
cv   <- gmr_asympt_cov(fit$eps, distri, fit$C)

lb   <- label_by_proxy(fit$eps[align$rsh_sel_ind, , drop = FALSE], Zsel)
lab  <- lb$col
se_C <- matrix(sqrt(pmax(diag(cv$V), 0)), Q_PROD, Q_PROD)

# Stability has to be asked (a) per column and (b) conditional on the start
# having actually reached a near-optimal value. Pooling every converged start
# mixes non-identification with plain optimizer failure: a start 10 log-lik
# units short of the maximum is not evidence about the identified set.
obj_sorted <- sort(fit$obj_by_start)
gap_2nd    <- obj_sorted[2] - obj_sorted[1]
tols <- c(0.5, 2, 5, 10)
stab_profile <- do.call(rbind, lapply(tols, function(tol) {
  keep <- which(fit$obj_by_start - obj_sorted[1] <= tol)
  st   <- column_stability(fit$all_C[keep], lab, ref = fit$C)
  data.frame(tol = tol, n = length(keep), max_dev = st$max_dev, min_cos = st$min_cos)
}))
stab_near <- stab_profile[stab_profile$tol == 2, ]

near <- which(fit$obj_by_start - obj_sorted[1] <= 2)
stab_cols <- vapply(seq_len(Q_PROD), function(j)
  column_stability(fit$all_C[near], j, ref = fit$C)$max_dev, numeric(1))

# ------------------------------------------------------------------
# Report
# ------------------------------------------------------------------
fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)

md <- c(
  "# Gate de não-gaussianidade — inovações fatoriais η",
  "",
  sprintf("Gerado por `script/nongaussian_gate.R` em %s.", Sys.Date()),
  sprintf("Especificação: r = %d, q = %d, p = %d; painel %s a %s.",
          R_PROD, Q_PROD, P_LAGS, min(eta_dates), max(eta_dates)),
  "",
  "GMR (2017) e LMS (2017) identificam `C` apenas se **no máximo uma** das q",
  "inovações estruturais for gaussiana (Comon 1994; Eriksson-Koivunen 2004;",
  "GMR Prop. 2a). Este é o pré-requisito da rota inteira.",
  "",
  "## Momentos e testes de normalidade",
  "",
  "| janela | componente | T | assimetria | curtose | JB | p (JB) | p (Shapiro-Wilk) |",
  "|---|---|---:|---:|---:|---:|---:|---:|",
  apply(tbl, 1, function(r) sprintf("| %s | %s | %s | %s | %s | %s | %s | %s |",
        r[["window"]], r[["comp"]], r[["T_eff"]],
        fmt(as.numeric(r[["skew"]])), fmt(as.numeric(r[["kurtosis"]])),
        fmt(as.numeric(r[["JB"]]), 2), fmt(as.numeric(r[["p_JB"]]), 4),
        fmt(as.numeric(r[["p_SW"]]), 4))),
  "",
  "## Veredito",
  "",
  sprintf("- **Full sample:** %d de %d componentes **não** rejeitam normalidade a 5%%.",
          ng_full, Q_PROD),
  sprintf("- **Pré-COVID:** %d de %d componentes não rejeitam normalidade a 5%%.",
          ng_pre, Q_PROD),
  "",
  if (ng_full <= 1)
    "O painel completo **passa** o gate (no máximo um gaussiano)."
  else paste0(
    "O painel completo **falha** o gate em sentido estrito: com ", ng_full,
    " componentes indistinguíveis de gaussianos, `C` fica identificada apenas ",
    "a menos de uma rotação arbitrária dentro desse subespaço de dimensão ",
    ng_full, ". Os demais componentes seguem identificados — a não-identificação ",
    "é **parcial**, confinada ao bloco gaussiano."),
  "",
  if (ng_pre > 1) paste0(
    "Na janela **pré-COVID** a situação é qualitativamente pior (", ng_pre,
    " de ", Q_PROD, " gaussianos): a rota não-gaussiana **não existe** ali. ",
    "A não-gaussianidade do painel é dirigida pela COVID. É justamente a janela ",
    "em que o proxy é mais forte (ξ_mp 12,22), então as duas identificações ",
    "não podem ser comparadas nessa amostra.") else "",
  "",
  "## Onde vive a direção monetária do proxy",
  "",
  "O que o paper precisa identificado é a **coluna monetária**, não `C` inteira.",
  "Decomposição da direção de impacto do proxy `H = (Z'η)/(Z'Z)`, normalizada:",
  "",
  "| componente | h_j | h_j² | rejeita normalidade (full) |",
  "|---|---:|---:|---|",
  sapply(seq_len(Q_PROD), function(i) sprintf("| eta_%d | %s | %s | %s |",
         i, fmt(h[i]), fmt(h[i]^2), if (is_nong[i]) "sim" else "**não**")),
  "",
  sprintf("- Massa no span **não-gaussiano**: **%s**", fmt(share_nong)),
  sprintf("- Massa no span **quase-gaussiano**: **%s**", fmt(share_gauss)),
  "",
  if (share_nong > 0.5) paste0(
    "A direção monetária está majoritariamente no subespaço identificado, o que ",
    "sustenta estimá-la por ICA apesar da não-identificação parcial de `C`. ",
    "A evidência que fecha o argumento é o erro-padrão da coluna e sua ",
    "estabilidade entre partidas do otimizador, abaixo.") else paste0(
    "A direção monetária está majoritariamente no subespaço **não** identificado. ",
    "A rota não sustenta uma estimativa da coluna monetária."),
  "",
  "## Ajuste PML no full sample (diagnóstico de identificação)",
  "",
  sprintf("- Pseudo-densidades: %d misturas de gaussianas distintas e assimétricas (A.5), sigma = %s",
          Q_PROD, paste(fmt(distri$sigma, 2), collapse = ", ")),
  sprintf("- Log-verossimilhança pseudo: %s", fmt(fit$logLik, 2)),
  sprintf("- Partidas: %d; convergiram: %d; **no melhor ótimo: %d**", fit$n_starts,
          fit$converged, fit$n_at_best),
  sprintf("- Distância do melhor ao segundo ótimo: **%s** unidades de log-lik (T = %d)",
          fmt(gap_2nd, 4), nrow(eta)),
  sprintf("- **cond(A) = %s** — cresce sem limite conforme o conjunto identificado degenera",
          formatC(cv$cond_A, format = "e", digits = 3)),
  "",
  "### Estabilidade da coluna monetária entre partidas",
  "",
  "O objetivo tem muitos ótimos locais, então estabilidade só significa algo",
  "**condicionada a a partida ter chegado perto do máximo**: uma partida a 10",
  "unidades de log-verossimilhança do ótimo é falha do otimizador, não evidência",
  "sobre o conjunto identificado. Cada `C` é alinhada à vencedora antes de comparar.",
  "",
  "| tolerância em log-lik | partidas | max\\|ΔC[,mp]\\| | cosseno mínimo |",
  "|---:|---:|---:|---:|",
  apply(stab_profile, 1, function(r) sprintf("| %s | %d | %s | %s |",
        fmt(as.numeric(r[["tol"]]), 1), as.integer(r[["n"]]),
        fmt(as.numeric(r[["max_dev"]]), 4), fmt(as.numeric(r[["min_cos"]]), 4))),
  "",
  "Estabilidade por coluna entre as partidas a menos de 2 unidades do ótimo:",
  "",
  "| coluna | max\\|ΔC[,j]\\| | rejeita normalidade |",
  "|---|---:|---|",
  sapply(seq_len(Q_PROD), function(j) sprintf("| %d%s | %s | %s |", j,
         if (j == lab) " (monetária)" else "", fmt(stab_cols[j], 4),
         if (is_nong[j]) "sim" else "**não**")),
  "",
  "Rotulagem pelo proxy — o `z` **não** identifica aqui, só nomeia:",
  "",
  sprintf("- Coluna escolhida: **%d**; |cor(ε_j, z)| = %s", lab, fmt(lb$best, 3)),
  sprintf("- Segunda colocada: %s; folga = **%s**", fmt(lb$second, 3), fmt(lb$gap, 3)),
  sprintf("- Correlações completas: %s",
          paste(sprintf("%.3f", lb$cor_abs), collapse = ", ")),
  "",
  "Erro-padrão assintótico (Prop. 4) da coluna monetária, elemento a elemento:",
  "",
  "| elemento | estimativa | erro-padrão | t |",
  "|---|---:|---:|---:|",
  sapply(seq_len(Q_PROD), function(i) sprintf("| c[%d,%d] | %s | %s | %s |",
         i, lab, fmt(fit$C[i, lab]), fmt(se_C[i, lab]),
         fmt(fit$C[i, lab] / se_C[i, lab], 2))),
  "",
  "> Se a coluna monetária tem erros-padrão apertados e dispersão desprezível",
  "> entre partidas, ela está identificada mesmo com `C` não estando por inteiro,",
  "> e a identificação não-gaussiana pode ser reportada como resultado de primeira",
  "> ordem. Caso contrário, o vale plano do bloco gaussiano contaminou a coluna e",
  "> a rota só serve como checagem qualitativa de sinal.",
  ""
)

writeLines(unlist(md), file.path(OUT_DIR, "gate.md"))

cat("\n== Gate de não-gaussianidade ==\n")
print(tbl, row.names = FALSE, digits = 4)
cat(sprintf("\nfull: %d/%d gaussianos | pre-COVID: %d/%d gaussianos\n",
            ng_full, Q_PROD, ng_pre, Q_PROD))
cat(sprintf("massa da direcao do proxy: nao-gaussiana %.3f | quase-gaussiana %.3f\n",
            share_nong, share_gauss))
cat(sprintf("cond(A) = %.3e | starts no melhor otimo = %d/%d | coluna monetaria = %d\n",
            cv$cond_A, fit$n_at_best, fit$converged, lab))
cat(sprintf("gap best->2nd = %.4f log-lik | coluna monetaria a <=2 do otimo: max|dC| = %.4f, cos min = %.4f (%d partidas)\n",
            gap_2nd, stab_near$max_dev, stab_near$min_cos, stab_near$n))
cat(sprintf("rotulagem: |cor| = %.3f vs segunda %.3f (folga %.3f)\n",
            lb$best, lb$second, lb$gap))
cat(sprintf("\nEscrito: %s\n", file.path(OUT_DIR, "gate.md")))
