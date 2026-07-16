# ===================================================================
# IRFs consistentes por (r,q) candidato — Etapa 2 de
# _instrucoes/irf_consistentes.md.
#
# Estima a especificacao de producao (z_jk_bs_purif x yield_6m, full
# sample, wild bootstrap nboot=800, seed 123, bandas 68/90, h=48) para
# 5 candidatos (r,q) balanceados e le as IRFs de 10 variaveis-chave
# ponto-a-ponto (h=0..40) contra a tabela de coerencia teorica.
#
# Configuracao identica entre candidatos -> comparabilidade direta.
# Nenhum script/helper de producao e modificado (reusa run_stage2_cell,
# evaluate_irf_path, coherence_var_table).
#
# Saidas em output/irf/:
#   irf_rq_candidates_h.csv       (ponto-a-ponto, h=0..40, por r,q,var)
#   irf_rq_candidates_summary.csv (1 linha por r,q,var: veredito + niveis)
#   irf_rq_candidates_overlay.pdf (1 painel/variavel, 5 candidatos)
#   irf_rq_<r>q<q>.rds            (objeto de estimacao por candidato)
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


# ---- Config (producao; fixa e identica entre candidatos) -----------

CANDIDATES <- list(
  c(r = 8L, q = 4L),
  c(r = 7L, q = 7L),
  c(r = 7L, q = 6L),
  c(r = 6L, q = 6L),
  c(r = 6L, q = 5L)   # baseline de producao (ancora)
)

P_LAGS     <- 6L
INSTRUMENT <- "z_jk_bs_purif"
MP_VAR     <- "yield_6m"
HORIZON    <- 48L         # estima ate h=48 (producao); le ate READ_H
READ_H     <- 40L         # leitura ponto-a-ponto h=0..40 (pedido)
N_BOOT     <- 800L
BOOT_SEED  <- 123L
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.68, 0.90)
WINDOW     <- as.Date(c("2013-01-01", "2025-12-31"))

# 10 variaveis economicas de maior interesse (todas em coherence_var_table)
READ_VARS <- c("asset_ibov", "cambio_usd", "embi_perc",
               "credit_outstanding", "credito_pessoa_fisica",
               "spread_icc_juridica", "spread_icc_fisica",
               "ibc_br", "trab_tx_desemprego", "price_ipca")

DATA_PATH <- "data/processed/data_log_deseasonalized.csv"
INST_PATH <- "data/processed/instrumentos_mensais.csv"
OUT_DIR   <- "output/irf"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Dados ---------------------------------------------------------

raw_data  <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
dates     <- as.Date(raw_data$ref.date)
data_mat  <- raw_data |> select(-ref.date) |> as.matrix()
tcode     <- infer_tcode_from_varnames(colnames(data_mat))
var_names <- colnames(data_mat)

inst_panel <- read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

spec_tbl <- coherence_var_table()
spec_tbl <- spec_tbl[match(READ_VARS, spec_tbl$var), ]  # ordena e filtra
missing  <- setdiff(READ_VARS, var_names)
if (length(missing) > 0) {
  stop("Variaveis ausentes no painel: ", paste(missing, collapse = ", "))
}
if (any(is.na(spec_tbl$var))) {
  stop("Variaveis de leitura ausentes em coherence_var_table(): ",
       paste(READ_VARS[is.na(spec_tbl$var)], collapse = ", "))
}
mpind_global <- match(MP_VAR, var_names)


# ---- Estima cada candidato -----------------------------------------

cells     <- list()
perh_rows <- list()
summ_rows <- list()

for (cand in CANDIDATES) {
  r <- cand[["r"]]; q <- cand[["q"]]
  tag <- sprintf("r%dq%d", r, q)
  cat(sprintf("\n=== Candidato (r=%d, q=%d) | %s x %s | nboot=%d seed=%d ===\n",
              r, q, INSTRUMENT, MP_VAR, N_BOOT, BOOT_SEED))
  t0 <- Sys.time()
  cell <- run_stage2_cell(
    data_mat, dates, inst_panel,
    sample_window = WINDOW,
    r = r, q = q, p = P_LAGS,
    instrument = INSTRUMENT, mp_var = MP_VAR,
    h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED,
    shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS
  )
  y6m_impact <- cell$irf$irf_point_matrix[mpind_global, 1]
  cat(sprintf("  done in %.1f min | dfm_max_eig=%.4f | yield_6m impacto=%.6f (esperado +0.005000)\n",
              as.numeric(Sys.time() - t0, units = "mins"),
              cell$dfm_max_eig, y6m_impact))
  saveRDS(cell, file.path(OUT_DIR, sprintf("irf_rq_%s.rds", tag)))
  cells[[tag]] <- cell

  point <- cell$irf$irf_point_matrix
  ci68  <- cell$irf$ci[["0.68"]]
  ci90  <- cell$irf$ci[["0.90"]]

  for (i in seq_len(nrow(spec_tbl))) {
    spec <- spec_tbl[i, ]
    idx  <- match(spec$var, var_names)
    res  <- evaluate_irf_path(
      point[idx, ], ci68$lower[idx, ], ci68$upper[idx, ],
      ci90$lower[idx, ], ci90$upper[idx, ], spec
    )

    ph <- res$perh[res$perh$h <= READ_H, ]
    ph$r <- r; ph$q <- q
    perh_rows[[length(perh_rows) + 1]] <- ph

    sm <- res$summary
    sm$r <- r; sm$q <- q
    sm$yield6m_impact <- y6m_impact
    sm$dfm_max_eig    <- cell$dfm_max_eig
    summ_rows[[length(summ_rows) + 1]] <- sm
  }
}


# ---- Consolida e grava CSVs ----------------------------------------

perh_all <- bind_rows(perh_rows) |>
  select(r, q, var, h, point, lo68, hi68, lo90, hi90, sign, sig68, sig90)
summ_all <- bind_rows(summ_rows) |>
  select(r, q, group, var, tier, theory_sign, w_lo, w_hi,
         h0, h3, h6, h12, h24, h36, peak_h, peak_val,
         share_correct, first_correct_h, right_sig68, right_sig90,
         wrong_sig90, verdict, yield6m_impact, dfm_max_eig)

write_csv(perh_all, file.path(OUT_DIR, "irf_rq_candidates_h.csv"))
write_csv(summ_all, file.path(OUT_DIR, "irf_rq_candidates_summary.csv"))
cat(sprintf("\nGravado: %d linhas ponto-a-ponto, %d linhas de resumo\n",
            nrow(perh_all), nrow(summ_all)))


# ---- Overlay: 1 painel por variavel, 5 candidatos sobrepostos ------

sign_lab <- function(s) if (is.na(s)) "amb" else if (s > 0) "+" else "-"
panel_titles <- setNames(
  sprintf("%s (esp %s, h%d-%d)", spec_tbl$var,
          vapply(spec_tbl$theory_sign, sign_lab, character(1)),
          spec_tbl$w_lo, spec_tbl$w_hi),
  spec_tbl$var
)

palette <- setNames(
  c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#111111"),
  names(cells)
)
key68 <- sprintf("%.2f", 0.68); key90 <- sprintf("%.2f", 0.90)

make_panel <- function(v) {
  vi <- match(v, var_names)
  df <- purrr::imap_dfr(cells, function(s, tag) {
    tibble::tibble(
      h     = 0:READ_H,
      point = s$irf$irf_point_matrix[vi, seq_len(READ_H + 1)],
      lo90  = s$irf$ci[[key90]]$lower[vi, seq_len(READ_H + 1)],
      hi90  = s$irf$ci[[key90]]$upper[vi, seq_len(READ_H + 1)],
      lo68  = s$irf$ci[[key68]]$lower[vi, seq_len(READ_H + 1)],
      hi68  = s$irf$ci[[key68]]$upper[vi, seq_len(READ_H + 1)],
      spec  = tag
    )
  })
  ggplot(df, aes(x = h, colour = spec, fill = spec)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
    geom_ribbon(aes(ymin = lo90, ymax = hi90), alpha = 0.08, colour = NA) +
    geom_ribbon(aes(ymin = lo68, ymax = hi68), alpha = 0.15, colour = NA) +
    geom_line(aes(y = point), linewidth = 0.7) +
    scale_colour_manual(values = palette) +
    scale_fill_manual(values = palette) +
    labs(title = panel_titles[[v]], x = NULL, y = NULL) +
    theme_minimal(base_size = 10) +
    theme(legend.position = "bottom",
          plot.title = element_text(size = 10, face = "bold"))
}

pdf(file.path(OUT_DIR, "irf_rq_candidates_overlay.pdf"), width = 12, height = 9)
pages <- split(READ_VARS, ceiling(seq_along(READ_VARS) / 6))
for (pg in pages) {
  panels <- lapply(pg, make_panel)
  print(
    wrap_plots(panels, ncol = 3, guides = "collect") +
      plot_annotation(
        title = "IRFs por candidato (r,q) — choque de politica +50bp",
        subtitle = sprintf("%s x %s | full 2013-2025 | wild bootstrap nboot=%d seed=%d | bandas 68/90 | bandas 90 tenues, 68 medias",
                            INSTRUMENT, MP_VAR, N_BOOT, BOOT_SEED)
      ) & theme(legend.position = "bottom")
  )
}
dev.off()
cat("Gravado: irf_rq_candidates_overlay.pdf\n")


# ---- Resumo no console ---------------------------------------------

cat("\n===== SANITY: impacto yield_6m (deve ser +0.005000) e dfm_max_eig (<1) =====\n")
sanity <- summ_all |>
  distinct(r, q, yield6m_impact, dfm_max_eig) |>
  mutate(rq = sprintf("(%d,%d)", r, q)) |>
  select(rq, yield6m_impact, dfm_max_eig)
print(as.data.frame(sanity), row.names = FALSE)

cat("\n===== VEREDITOS: variavel x candidato (r,q) =====\n")
verdict_wide <- summ_all |>
  mutate(rq = sprintf("(%d,%d)", r, q)) |>
  select(var, theory_sign, w_lo, w_hi, rq, verdict) |>
  pivot_wider(names_from = rq, values_from = verdict)
print(as.data.frame(verdict_wide), row.names = FALSE)

cat("\nConcluido.\n")
