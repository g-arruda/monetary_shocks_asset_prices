# ===================================================================
# Varredura instrumento × (r,q) × amostra — nenhum instrumento salva as
# IRFs? E por que Wald(ξ_mp)>0 gera IRF errada?
#
# Grade: 6 instrumentos (todas as famílias) × 3 (r,q) {(6,5),(7,6),(8,8)}
#        × 2 amostras {full, pre_covid} = 36 células.
# Config de produção idêntica (nboot=800, seed=123, p=6, h=48, +50bp,
# mp_var=yield_6m) => comparabilidade. Reusa run_stage2_cell; nenhum
# script de produção é alterado. tryCatch por célula.
#
# Por célula lê ponto-a-ponto (h=0..40) e classifica:
#   - curva no h0 (6 vértices): slope = h0(5y)-h0(3m), pico em qual maturidade
#   - núcleo/IPCA/PIB/IBC/câmbio/CDS/EMBI: sinal h0, significância, share
#   - vereditos de coerência das variáveis econômicas
#   - flags de contaminação {curva_invertida, nucleo_puzzle, fx_wrong_sig}
#   - força juntada da grade MOSW (ξ_mp = wald_mp, F factor-space = f_factor)
#
# Saídas em output/irf/:
#   inst_diag_summary.csv       (1 linha por célula: força + flags + curva)
#   inst_diag_verdict.csv       (1 linha por célula×variável: veredito)
#   inst_diag_h.csv             (ponto-a-ponto, variáveis-diagnóstico)
#   inst_diag_curve_h0.csv      (resposta h0 por vértice)
#   inst_diag_curve_h0_by_rq.pdf, inst_diag_contam_vs_strength.pdf,
#   inst_diag_paths.pdf
# ===================================================================

rm(list = ls())

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/validation_tests.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")


# ---- Config -------------------------------------------------------

INSTRUMENTS <- c("z_jk_bs_purif", "z_jk_purif", "z_jk_raw_purif",
                 "z_bruto", "z_jk", "z_het_jk_3var")
RQ <- list(c(6L, 5L), c(7L, 6L), c(8L, 8L))
SAMPLES <- c("full", "pre_covid")
WINDOWS <- list(full      = as.Date(c("2013-01-01", "2025-12-31")),
                pre_covid = as.Date(c("2013-01-01", "2019-12-31")))

P_LAGS <- 6L; MP_VAR <- "yield_6m"; HORIZON <- 48L; READ_H <- 40L
N_BOOT <- 800L; BOOT_SEED <- 123L; SHOCK_BPS <- 50; CI_LEVELS <- c(0.68, 0.90)

CURVE_VARS <- c("yield_3m", "yield_6m", "yield_1y", "yield_2y", "yield_5y", "yield_10y")
CURVE_MAT  <- c(0.25, 0.5, 1, 2, 5, 10)
SCORE_VARS <- c("asset_ibov", "cambio_usd", "embi_perc", "credit_outstanding",
                "credito_pessoa_fisica", "spread_icc_juridica", "spread_icc_fisica",
                "ibc_br", "trab_tx_desemprego", "price_ipca", "price_core_ipca_ex0")
PATH_VARS  <- c("yield_3m", "yield_6m", "yield_2y", "yield_5y", "price_core_ipca_ex0",
                "price_ipca", "pib", "ibc_br", "cambio_usd", "cds_5y", "embi_perc")

OUT_DIR <- "output/irf"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Dados --------------------------------------------------------

raw_data  <- read_csv("data/processed/data_log_deseasonalized.csv", show_col_types = FALSE) |> drop_na()
dates     <- as.Date(raw_data$ref.date)
data_mat  <- raw_data |> select(-ref.date) |> as.matrix()
tcode     <- infer_tcode_from_varnames(colnames(data_mat))
var_names <- colnames(data_mat)

inst_panel <- read_csv("data/processed/instrumentos_mensais.csv", show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

spec_tbl <- coherence_var_table()
grid <- read_csv("output/instrument/mosw_strength_grid.csv", show_col_types = FALSE) |>
  select(sample, r, q, instrument, f_factor, wald_mp)

n_reversals <- function(p) sum(diff(sign(diff(p))) != 0)


# ---- Loop da grade ------------------------------------------------

cell_rows <- list(); verd_rows <- list(); path_rows <- list(); curve_rows <- list()

for (inst in INSTRUMENTS) for (rq in RQ) for (smp in SAMPLES) {
  r <- rq[1]; q <- rq[2]
  tag <- sprintf("%s_r%dq%d_%s", inst, r, q, smp)
  cat(sprintf("\n=== %s ===\n", tag))
  gsel <- grid |> filter(sample == smp, r == !!r, q == !!q, instrument == inst)
  f_factor <- if (nrow(gsel)) gsel$f_factor[1] else NA_real_
  wald_mp  <- if (nrow(gsel)) gsel$wald_mp[1]  else NA_real_

  cell <- tryCatch(
    run_stage2_cell(data_mat, dates, inst_panel, sample_window = WINDOWS[[smp]],
                    r = r, q = q, p = P_LAGS, instrument = inst, mp_var = MP_VAR,
                    h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED,
                    shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS),
    error = function(e) { cat("  ERRO:", conditionMessage(e), "\n"); NULL })
  if (is.null(cell)) next

  point <- cell$irf$irf_point_matrix
  ci68  <- cell$irf$ci[["0.68"]]; ci90 <- cell$irf$ci[["0.90"]]
  mpind <- match(MP_VAR, var_names)
  mp_impact <- point[mpind, 1]
  cat(sprintf("  mpind impacto=%.6f | max_eig=%.4f | F_fs=%.2f | xi_mp=%.2f\n",
              mp_impact, cell$dfm_max_eig, f_factor, wald_mp))

  # --- curva no h0 ---
  cvals <- sapply(CURVE_VARS, function(v) point[match(v, var_names), 1])
  for (k in seq_along(CURVE_VARS))
    curve_rows[[length(curve_rows) + 1]] <- tibble::tibble(
      tag = tag, instrument = inst, r = r, q = q, sample = smp,
      var = CURVE_VARS[k], maturity = CURVE_MAT[k], h0 = cvals[k])
  curve_slope <- cvals["yield_5y"] - cvals["yield_3m"]
  argmax_mat  <- CURVE_VARS[which.max(cvals)]
  # curva "ok" = pico no short (3m/6m) e não crescente para além do 6m
  peak_short  <- argmax_mat %in% c("yield_3m", "yield_6m")
  curve_ok    <- peak_short && all(cvals[c("yield_1y","yield_2y","yield_5y","yield_10y")] <= cvals["yield_6m"] + 1e-9)

  # --- variáveis pontuadas: vereditos + flags ---
  nucleo_share <- NA_real_; nucleo_h0 <- NA_real_
  for (v in SCORE_VARS) {
    idx <- match(v, var_names); sp <- spec_tbl[spec_tbl$var == v, ]
    res <- evaluate_irf_path(point[idx, ], ci68$lower[idx, ], ci68$upper[idx, ],
                             ci90$lower[idx, ], ci90$upper[idx, ], sp)
    verd_rows[[length(verd_rows) + 1]] <- tibble::tibble(
      tag = tag, instrument = inst, r = r, q = q, sample = smp, var = v,
      theory_sign = sp$theory_sign, h0 = res$summary$h0,
      share_correct = res$summary$share_correct, verdict = res$summary$verdict)
    if (v == "price_core_ipca_ex0") { nucleo_share <- res$summary$share_correct; nucleo_h0 <- res$summary$h0 }
  }
  nucleo_puzzle <- is.na(nucleo_share) || nucleo_share < 0.5

  # câmbio h0 sig?
  ci_v <- function(v) { idx <- match(v, var_names)
    list(h0 = point[idx, 1], sig90 = ci90$lower[idx, 1] > 0 | ci90$upper[idx, 1] < 0) }
  fx <- ci_v("cambio_usd"); cds <- ci_v("cds_5y")
  fx_wrong_sig  <- fx$h0 > 0 && fx$sig90
  cds_wrong_sig <- cds$h0 > 0 && cds$sig90

  n_contam <- sum(!curve_ok, nucleo_puzzle, fx_wrong_sig)
  clean    <- !( !curve_ok | nucleo_puzzle | fx_wrong_sig )

  cell_rows[[length(cell_rows) + 1]] <- tibble::tibble(
    tag = tag, instrument = inst, r = r, q = q, sample = smp,
    f_factor = f_factor, wald_mp = wald_mp, dfm_max_eig = cell$dfm_max_eig, mp_impact = mp_impact,
    curve_slope = curve_slope, argmax_mat = argmax_mat, curve_ok = curve_ok,
    nucleo_share = nucleo_share, nucleo_h0 = nucleo_h0, nucleo_puzzle = nucleo_puzzle,
    cambio_h0 = fx$h0, fx_wrong_sig = fx_wrong_sig, cds_h0 = cds$h0, cds_wrong_sig = cds_wrong_sig,
    n_contam = n_contam, clean = clean)

  # --- trajetórias ponto-a-ponto (variáveis-diagnóstico) ---
  for (v in PATH_VARS) {
    idx <- match(v, var_names)
    path_rows[[length(path_rows) + 1]] <- tibble::tibble(
      tag = tag, instrument = inst, r = r, q = q, sample = smp, var = v,
      h = 0:READ_H, point = point[idx, 1:(READ_H + 1)],
      lo90 = ci90$lower[idx, 1:(READ_H + 1)], hi90 = ci90$upper[idx, 1:(READ_H + 1)],
      sig90 = ci90$lower[idx, 1:(READ_H + 1)] > 0 | ci90$upper[idx, 1:(READ_H + 1)] < 0)
  }
}

cell_all  <- bind_rows(cell_rows)
verd_all  <- bind_rows(verd_rows)
path_all  <- bind_rows(path_rows)
curve_all <- bind_rows(curve_rows)

write_csv(cell_all,  file.path(OUT_DIR, "inst_diag_summary.csv"))
write_csv(verd_all,  file.path(OUT_DIR, "inst_diag_verdict.csv"))
write_csv(path_all,  file.path(OUT_DIR, "inst_diag_h.csv"))
write_csv(curve_all, file.path(OUT_DIR, "inst_diag_curve_h0.csv"))


# ---- Plot 1: curva no h0 por (r,q)×amostra, uma linha por instrumento ----

pdf(file.path(OUT_DIR, "inst_diag_curve_h0_by_rq.pdf"), width = 12, height = 8)
curve_all$panel <- sprintf("r%dq%d · %s", curve_all$r, curve_all$q, curve_all$sample)
print(
  ggplot(curve_all, aes(maturity, h0, colour = instrument)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey70") +
    geom_line(linewidth = 0.7) + geom_point(size = 1) +
    scale_x_log10(breaks = CURVE_MAT, labels = c("3m","6m","1y","2y","5y","10y")) +
    facet_wrap(~ panel, scales = "free_y", ncol = 3) +
    labs(title = "Curva no IMPACTO (h0) por instrumento — choque curto limpo DECAI com a maturidade",
         x = "maturidade", y = "resposta h0") +
    theme_minimal(base_size = 10) + theme(legend.position = "bottom")
)
dev.off()


# ---- Plot 2: contaminação × força (o "porquê") -------------------

sc <- cell_all |> mutate(sample = factor(sample))
p_a <- ggplot(sc, aes(wald_mp, curve_slope, colour = sample, label = instrument)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey70") +
  geom_vline(xintercept = 10, linetype = "dotted", colour = "grey50") +
  geom_point(aes(shape = clean), size = 2.5) +
  labs(title = "Inclinação da curva no h0 (5y−3m) × força ξ_mp",
       subtitle = "slope>0 = curva invertida (contaminada). Linha pontilhada: ξ_mp=10.",
       x = "ξ_mp (MOSW Wald, direção yield_6m)", y = "h0(5y) − h0(3m)") +
  theme_minimal(base_size = 10) + theme(legend.position = "bottom")
p_b <- ggplot(sc, aes(f_factor, curve_slope, colour = sample, shape = clean)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey70") +
  geom_vline(xintercept = 10, linetype = "dotted", colour = "grey50") +
  geom_point(size = 2.5) +
  labs(title = "Inclinação da curva no h0 × F factor-space",
       x = "F factor-space (max-F entre q fatores)", y = "h0(5y) − h0(3m)") +
  theme_minimal(base_size = 10) + theme(legend.position = "bottom")
p_c <- ggplot(sc, aes(wald_mp, n_contam, colour = sample)) +
  geom_vline(xintercept = 10, linetype = "dotted", colour = "grey50") +
  geom_jitter(width = 0, height = 0.08, size = 2.5) +
  labs(title = "Nº de defeitos {curva, núcleo, câmbio} × ξ_mp",
       x = "ξ_mp", y = "contagem de contaminação (0-3)") +
  theme_minimal(base_size = 10) + theme(legend.position = "bottom")
pdf(file.path(OUT_DIR, "inst_diag_contam_vs_strength.pdf"), width = 13, height = 5)
print((p_a | p_b | p_c) + plot_annotation(
  title = "Por que Wald>0 não compra IRF limpa: contaminação independe da força"))
dev.off()


# ---- Plot 3: trajetórias por instrumento (full, (6,5) e (8,8)) ---

pdf(file.path(OUT_DIR, "inst_diag_paths.pdf"), width = 12, height = 8)
for (rqlab in c("r6q5", "r8q8")) {
  df <- path_all |> filter(sample == "full", grepl(rqlab, tag),
                           var %in% c("yield_5y","price_core_ipca_ex0","price_ipca",
                                      "pib","cambio_usd","cds_5y"))
  pl <- ggplot(df, aes(h, point, colour = instrument)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey70") +
    geom_line(linewidth = 0.6) +
    facet_wrap(~ var, scales = "free_y", ncol = 3) +
    labs(title = sprintf("Trajetórias por instrumento — full, %s", rqlab), x = "h", y = NULL) +
    theme_minimal(base_size = 10) + theme(legend.position = "bottom")
  print(pl)
}
dev.off()


# ---- Resumo no console --------------------------------------------

cat("\n===== VEREDITO POR CÉLULA (clean? nº defeitos, força) =====\n")
tab <- cell_all |>
  mutate(rq = sprintf("(%d,%d)", r, q)) |>
  select(instrument, rq, sample, wald_mp, f_factor, curve_slope, argmax_mat,
         nucleo_puzzle, fx_wrong_sig, n_contam, clean) |>
  arrange(sample, desc(wald_mp))
print(as.data.frame(tab), row.names = FALSE, digits = 3)

cat(sprintf("\nCélulas limpas: %d de %d\n", sum(cell_all$clean), nrow(cell_all)))
cat("\nCorrelação (curve_slope × ξ_mp):", round(cor(cell_all$curve_slope, cell_all$wald_mp, use = "complete.obs"), 3),
    "| (curve_slope × f_factor):", round(cor(cell_all$curve_slope, cell_all$f_factor, use = "complete.obs"), 3), "\n")
cat("Concluido.\n")
