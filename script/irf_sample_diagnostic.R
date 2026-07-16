# ===================================================================
# Diagnóstico do choque contaminado: amostra (janela) × config (rotação)
# — path 3 + teste numérico do path 1 de
#   `_instrucoes/irf_consistentes.md` (frente de diagnóstico de identificação).
#
# Hipóteses testadas:
#   (path 3) a contaminação (curva invertida no h0, núcleo em price puzzle,
#            câmbio/CDS sig. errados) é dirigida pela amostra COVID? A F de
#            factor-space é fraca no full (5.1) e forte no pre-COVID (11.7).
#   (path 1) a célula (8,8) reproduz o BENCHMARK EXATO dos autores
#            (r=q=8 => K=M=1, rotação identidade) e é forte no full (ξ_mp 13.1)
#            — se ainda assim vier contaminada, a rotação espectral K/M e a
#            fraqueza de F não são a causa.
#
# Célula extra (6,5)-full com mp_var=yield_2y (convenção de normalização dos
# autores) demonstra que trocar o vértice de normalização SÓ REESCALA — não
# muda a ordenação da curva.
#
# Config de produção idêntica entre células (comparabilidade): nboot=800,
# seed=123, p=6, h=48, +50bp, bandas 68/90. Reusa run_stage2_cell; nenhum
# script de produção é alterado.
#
# Saídas em output/irf/:
#   irf_sample_diag_summary.csv   (1 linha por célula×variável)
#   irf_sample_diag_h.csv         (ponto-a-ponto h=0..40)
#   irf_sample_diag_curve_h0.csv  (resposta no impacto por vértice da curva)
#   irf_sample_diag_paths.pdf     (overlay das células por variável)
#   irf_sample_diag_curve_h0.pdf  (curva no h0: resposta × maturidade)
#   irf_sample_diag_<tag>.rds      (objeto por célula)
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

CELLS <- tibble::tribble(
  ~r, ~q, ~sample,      ~mp_var,     ~role,
  6L, 5L, "full",       "yield_6m",  "producao (contaminada)",
  6L, 5L, "pre_covid",  "yield_6m",  "path3: F forte pre-COVID",
  8L, 8L, "full",       "yield_6m",  "path1: benchmark autores K=M=1 + F forte",
  8L, 8L, "pre_covid",  "yield_6m",  "benchmark pre-COVID (flag max_eig)",
  6L, 5L, "full",       "yield_2y",  "demo: normalizacao no 2y (autores)"
)
CELLS$tag <- with(CELLS, sprintf("r%dq%d_%s_%s", r, q, sample, mp_var))

WINDOWS <- list(
  full      = as.Date(c("2013-01-01", "2025-12-31")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-31"))
)

P_LAGS     <- 6L
INSTRUMENT <- "z_jk_bs_purif"
HORIZON    <- 48L
READ_H     <- 40L
N_BOOT     <- 800L
BOOT_SEED  <- 123L
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.68, 0.90)

YIELD_VARS <- c("yield_3m", "yield_6m", "yield_1y", "yield_2y", "yield_5y", "yield_10y")
YIELD_MAT  <- c(0.25, 0.5, 1, 2, 5, 10)  # maturidade em anos, p/ o gráfico da curva
PRICE_VARS <- c("price_ipca", "price_core_ipca_ex0", "price_core_ipca_ex1", "price_core_ipca_dw")
ACT_VARS   <- c("pib", "ibc_br")
RISK_VARS  <- c("cambio_usd", "cds_5y", "embi_perc")
READ_VARS  <- unique(c(YIELD_VARS, PRICE_VARS, ACT_VARS, RISK_VARS))

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

missing <- setdiff(READ_VARS, var_names)
if (length(missing) > 0) stop("Variaveis ausentes no painel: ", paste(missing, collapse = ", "))

spec_tbl <- coherence_var_table()

# F factor-space / ξ_mp por célula: cruzar com a grade MOSW (não depende de mp_var)
grid <- read_csv("output/instrument/mosw_strength_grid.csv", show_col_types = FALSE) |>
  filter(instrument == INSTRUMENT) |>
  select(sample, r, q, f_factor, wald_mp)

n_reversals <- function(p) sum(diff(sign(diff(p))) != 0)  # mudanças de direção de tendência


# ---- Loop de estimação --------------------------------------------

cells      <- list()
curve_rows <- list()
path_rows  <- list()
summ_rows  <- list()

for (i in seq_len(nrow(CELLS))) {
  cc  <- CELLS[i, ]
  win <- WINDOWS[[cc$sample]]
  cat(sprintf("\n=== %s | %s | nboot=%d seed=%d ===\n", cc$tag, cc$role, N_BOOT, BOOT_SEED))
  t0 <- Sys.time()
  cell <- run_stage2_cell(
    data_mat, dates, inst_panel, sample_window = win,
    r = cc$r, q = cc$q, p = P_LAGS,
    instrument = INSTRUMENT, mp_var = cc$mp_var,
    h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED,
    shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS
  )
  mpind      <- match(cc$mp_var, var_names)
  mp_impact  <- cell$irf$irf_point_matrix[mpind, 1]
  gsel       <- grid |> filter(sample == cc$sample, r == cc$r, q == cc$q)
  f_factor   <- if (nrow(gsel)) gsel$f_factor[1] else NA_real_
  wald_mp    <- if (nrow(gsel)) gsel$wald_mp[1]  else NA_real_
  cat(sprintf("  %.1f min | mpind(%s) impacto=%.6f | max_eig=%.4f | F_fs=%.2f | xi_mp=%.2f%s\n",
              as.numeric(Sys.time() - t0, units = "mins"), cc$mp_var, mp_impact,
              cell$dfm_max_eig, f_factor, wald_mp,
              if (cell$dfm_max_eig >= 1) "  [!! max_eig>=1 EXPLOSIVO]" else ""))
  saveRDS(cell, file.path(OUT_DIR, sprintf("irf_sample_diag_%s.rds", cc$tag)))
  cells[[cc$tag]] <- cell

  point <- cell$irf$irf_point_matrix
  ci68  <- cell$irf$ci[["0.68"]]
  ci90  <- cell$irf$ci[["0.90"]]

  # (1) curva no impacto (h0) por vértice
  for (k in seq_along(YIELD_VARS)) {
    v <- YIELD_VARS[k]; idx <- match(v, var_names)
    curve_rows[[length(curve_rows) + 1]] <- tibble::tibble(
      tag = cc$tag, r = cc$r, q = cc$q, sample = cc$sample, mp_var = cc$mp_var,
      var = v, maturity = YIELD_MAT[k], h0 = point[idx, 1],
      sig90 = ci90$lower[idx, 1] > 0 | ci90$upper[idx, 1] < 0
    )
  }

  # (2) trajetória ponto-a-ponto + resumo por variável
  for (v in READ_VARS) {
    idx <- match(v, var_names)
    p   <- point[idx, 1:(READ_H + 1)]
    lo68 <- ci68$lower[idx, 1:(READ_H + 1)]; hi68 <- ci68$upper[idx, 1:(READ_H + 1)]
    lo90 <- ci90$lower[idx, 1:(READ_H + 1)]; hi90 <- ci90$upper[idx, 1:(READ_H + 1)]
    sig90 <- lo90 > 0 | hi90 < 0
    path_rows[[length(path_rows) + 1]] <- tibble::tibble(
      tag = cc$tag, r = cc$r, q = cc$q, sample = cc$sample, mp_var = cc$mp_var,
      var = v, h = 0:READ_H, point = p, lo68 = lo68, hi68 = hi68,
      lo90 = lo90, hi90 = hi90, sign = sign(p), sig68 = lo68 > 0 | hi68 < 0, sig90 = sig90
    )

    # verdict de coerência (quando a variável está na tabela)
    sp <- spec_tbl[spec_tbl$var == v, ]
    verdict <- NA_character_; share_correct <- NA_real_; th_sign <- NA_real_
    if (nrow(sp) == 1) {
      full_len <- ncol(point)
      res <- evaluate_irf_path(point[idx, ], ci68$lower[idx, ], ci68$upper[idx, ],
                               ci90$lower[idx, ], ci90$upper[idx, ], sp)
      verdict <- res$summary$verdict; share_correct <- res$summary$share_correct
      th_sign <- sp$theory_sign
    }
    # 1o horizonte em que o sinal inverte relativo ao h0
    sflip <- which(sign(p) != sign(p[1]))
    ext_i <- if (!is.na(th_sign) && th_sign < 0) which.min(p) else which.max(abs(p))
    summ_rows[[length(summ_rows) + 1]] <- tibble::tibble(
      tag = cc$tag, r = cc$r, q = cc$q, sample = cc$sample, mp_var = cc$mp_var,
      f_factor = f_factor, wald_mp = wald_mp, dfm_max_eig = cell$dfm_max_eig,
      mp_impact = mp_impact, var = v, theory_sign = th_sign,
      h0 = p[1], sig90_h0 = sig90[1],
      h_first_signflip = if (length(sflip)) sflip[1] - 1 else NA_integer_,
      extreme_h = ext_i - 1, extreme_val = p[ext_i],
      n_reversals = n_reversals(p),
      share_correct = share_correct, verdict = verdict
    )
  }
}

curve_all <- bind_rows(curve_rows)
path_all  <- bind_rows(path_rows)
summ_all  <- bind_rows(summ_rows)

write_csv(curve_all, file.path(OUT_DIR, "irf_sample_diag_curve_h0.csv"))
write_csv(path_all,  file.path(OUT_DIR, "irf_sample_diag_h.csv"))
write_csv(summ_all,  file.path(OUT_DIR, "irf_sample_diag_summary.csv"))


# ---- Overlay das trajetórias (células principais, exclui demo 2y) --

main_tags <- CELLS$tag[CELLS$mp_var == "yield_6m"]
pal <- setNames(c("#111111", "#1b9e77", "#d95f02", "#7570b3"), main_tags)
plot_vars <- c("yield_3m","yield_2y","yield_5y","price_core_ipca_ex0",
               "price_ipca","pib","ibc_br","cambio_usd","cds_5y","embi_perc")

make_panel <- function(v) {
  df <- path_all |> filter(tag %in% main_tags, var == v)
  ggplot(df, aes(h, colour = tag, fill = tag)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
    geom_ribbon(aes(ymin = lo90, ymax = hi90), alpha = 0.06, colour = NA) +
    geom_line(aes(y = point), linewidth = 0.7) +
    scale_colour_manual(values = pal) + scale_fill_manual(values = pal) +
    labs(title = v, x = NULL, y = NULL) +
    theme_minimal(base_size = 9) +
    theme(legend.position = "bottom", plot.title = element_text(size = 9, face = "bold"))
}
pdf(file.path(OUT_DIR, "irf_sample_diag_paths.pdf"), width = 12, height = 9)
for (pg in split(plot_vars, ceiling(seq_along(plot_vars) / 6))) {
  print(wrap_plots(lapply(pg, make_panel), ncol = 3, guides = "collect") +
          plot_annotation(title = "Choque +50bp por amostra × config (z_jk_bs_purif, yield_6m)",
                          subtitle = "preto=(6,5)full  verde=(6,5)pre  laranja=(8,8)full  roxo=(8,8)pre | bandas 90") &
          theme(legend.position = "bottom"))
}
dev.off()


# ---- Gráfico da CURVA no impacto (resposta × maturidade) ----------

pdf(file.path(OUT_DIR, "irf_sample_diag_curve_h0.pdf"), width = 9, height = 6)
print(
  ggplot(curve_all, aes(maturity, h0, colour = tag)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey70") +
    geom_line(linewidth = 0.8) + geom_point(size = 1.6) +
    scale_x_log10(breaks = YIELD_MAT, labels = c("3m","6m","1y","2y","5y","10y")) +
    labs(title = "Resposta da curva no IMPACTO (h0) por maturidade",
         subtitle = "choque curto limpo deveria DECAIR com a maturidade",
         x = "maturidade", y = "resposta h0") +
    theme_minimal(base_size = 11) + theme(legend.position = "bottom")
)
dev.off()


# ---- Resumo no console --------------------------------------------

cat("\n===== SANITY por célula =====\n")
print(as.data.frame(summ_all |> distinct(tag, mp_impact, dfm_max_eig, f_factor, wald_mp)), row.names = FALSE)

cat("\n===== CURVA NO IMPACTO (h0) — decai com a maturidade? =====\n")
cw <- curve_all |>
  mutate(lab = sub("yield_", "", var)) |>
  select(tag, lab, h0) |>
  pivot_wider(names_from = lab, values_from = h0) |>
  select(tag, `3m`, `6m`, `1y`, `2y`, `5y`, `10y`)
cw$argmax_mat <- curve_all |> group_by(tag) |>
  summarise(m = var[which.max(h0)], .groups = "drop") |> pull(m)
print(as.data.frame(cw), row.names = FALSE)

cat("\n===== NÚCLEO / IPCA / PIB — sinal h0, 1a inversão, extremo, dentes =====\n")
key <- summ_all |> filter(var %in% c("price_ipca","price_core_ipca_ex0","price_core_ipca_ex1","pib","ibc_br")) |>
  select(tag, var, h0, h_first_signflip, extreme_h, extreme_val, n_reversals, verdict)
print(as.data.frame(key), row.names = FALSE)

cat("\n===== CÂMBIO / RISCO — sinal h0 e significância 90% =====\n")
rk <- summ_all |> filter(var %in% RISK_VARS) |>
  select(tag, var, h0, sig90_h0, verdict)
print(as.data.frame(rk), row.names = FALSE)

cat("\nConcluido.\n")
