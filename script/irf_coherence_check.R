# ===================================================================
# Point-by-point theory-coherence check of the production IRFs across
# ~40 key panel variables (z_jk_purif x yield_6m x r=6 q=5, full sample,
# wild bootstrap nboot=800). For each variable, every horizon h = 0..48
# is checked for sign and CI68/CI90 significance against the theory
# window defined in R/identification/irf_coherence.R.
# Outputs: output/irf/irf_coherence_h.csv, irf_coherence_summary.csv,
#          irf_coherence_report.md, irf_coherence_plots.pdf
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


# ---- Config (production spec) --------------------------------------

R_FACTORS  <- 6L
Q_DYNAMIC  <- 5L
P_LAGS     <- 6L
INSTRUMENT <- "z_jk_purif"
MP_VAR     <- "yield_6m"
HORIZON    <- 48L
N_BOOT     <- 800L
BOOT_SEED  <- 123L
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.68, 0.90)
WINDOW     <- as.Date(c("2013-01-01", "2025-12-31"))

DATA_PATH <- "data/processed/data_log_deseasonalized.csv"
INST_PATH <- "data/processed/instrumentos_mensais.csv"
OUT_DIR   <- "output/irf"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data + estimation ---------------------------------------------

raw_data <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> select(-ref.date) |> as.matrix()
tcode    <- infer_tcode_from_varnames(colnames(data_mat))
var_names <- colnames(data_mat)

inst_panel <- read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

spec_tbl <- coherence_var_table()
missing <- setdiff(spec_tbl$var, var_names)
if (length(missing) > 0) {
  stop("Variaveis da tabela de coerencia ausentes no painel: ",
       paste(missing, collapse = ", "))
}

cat(sprintf("Estimating production spec: %s x %s, r=%d q=%d p=%d, nboot=%d\n",
            INSTRUMENT, MP_VAR, R_FACTORS, Q_DYNAMIC, P_LAGS, N_BOOT))
t0 <- Sys.time()
cell <- run_stage2_cell(
  data_mat, dates, inst_panel,
  sample_window = WINDOW,
  r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
  instrument = INSTRUMENT, mp_var = MP_VAR,
  h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED,
  shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS
)
cat(sprintf("  done in %.1f min\n", as.numeric(Sys.time() - t0, units = "mins")))
saveRDS(cell, file.path(OUT_DIR, "irf_coherence_cell.rds"))

point <- cell$irf$irf_point_matrix
ci68  <- cell$irf$ci[["0.68"]]
ci90  <- cell$irf$ci[["0.90"]]


# ---- Evaluate every variable ---------------------------------------

perh_rows <- list()
summ_rows <- list()
for (i in seq_len(nrow(spec_tbl))) {
  spec <- spec_tbl[i, ]
  idx  <- match(spec$var, var_names)
  res  <- evaluate_irf_path(
    point[idx, ], ci68$lower[idx, ], ci68$upper[idx, ],
    ci90$lower[idx, ], ci90$upper[idx, ], spec
  )
  perh_rows[[i]] <- res$perh
  summ_rows[[i]] <- res$summary
}
perh <- bind_rows(perh_rows)
summ <- bind_rows(summ_rows)

write_csv(perh, file.path(OUT_DIR, "irf_coherence_h.csv"))
write_csv(summ, file.path(OUT_DIR, "irf_coherence_summary.csv"))
cat(sprintf("Wrote %d per-horizon rows, %d summary rows\n",
            nrow(perh), nrow(summ)))


# ---- Plots (6 panels per page, grouped) ----------------------------

pdf(file.path(OUT_DIR, "irf_coherence_plots.pdf"), width = 11, height = 8)
for (g in unique(spec_tbl$group)) {
  vars_g <- spec_tbl$var[spec_tbl$group == g]
  pages <- split(vars_g, ceiling(seq_along(vars_g) / 6))
  for (pg in pages) {
    response_idx <- lapply(pg, function(v) setNames(match(v, var_names), v))
    p <- plot_irf(cell$irf, response_vars = response_idx, horizon = HORIZON,
                  var_names = var_names, tcode = tcode, ci_to_plot = CI_LEVELS) +
      plot_annotation(
        title = sprintf("Coerência IRF — grupo: %s", g),
        subtitle = sprintf("%s x %s | r=%d q=%d | +%dbp | nboot=%d | bandas 68/90",
                           INSTRUMENT, MP_VAR, R_FACTORS, Q_DYNAMIC, SHOCK_BPS, N_BOOT)
      )
    print(p)
  }
}
dev.off()


# ---- Report --------------------------------------------------------

traj_cols <- c("var", "h0", "h3", "h6", "h12", "h24", "h36", "h48",
               "share_correct", "verdict")

group_sections <- unlist(lapply(unique(spec_tbl$group), function(g) {
  tbl <- summ |> filter(group == g) |> select(all_of(traj_cols))
  c(sprintf("### %s", g), "", md_table(tbl), "")
}))

violations <- summ |>
  filter(verdict %in% c("incoerente", "placebo_viola") | wrong_sig90 %in% TRUE)

verdict_count <- summ |> count(tier, verdict) |> arrange(tier, desc(n))

report <- c(
  "# Coerência ponto a ponto das IRFs — especificação de produção",
  "",
  sprintf("Gerado por `script/irf_coherence_check.R` em %s.", format(Sys.Date())),
  "",
  sprintf(paste0("Especificação: `%s` x `%s`, r=%d, q=%d, p=%d, full sample, ",
                 "choque +%dbp, wild bootstrap nboot=%d (seed %d), bandas 68/90, h=0..%d."),
          INSTRUMENT, MP_VAR, R_FACTORS, Q_DYNAMIC, P_LAGS,
          SHOCK_BPS, N_BOOT, BOOT_SEED, HORIZON),
  "",
  "## Método",
  "",
  "Para cada variável, cada horizonte h é checado quanto a sinal e significância",
  "(CI68/CI90) contra a janela teórica [w_lo, w_hi] definida em",
  "`R/identification/irf_coherence.R::coherence_var_table()`. Vereditos:",
  "`coerente_forte` (≥80% da janela com sinal certo + significância CI68),",
  "`coerente` (≥80% sem significância), `parcial` (50-80%, sem violação",
  "significativa), `incoerente` (<50% ou sinal errado com CI90 excluindo 0),",
  "`soft_*` (canal registrado — dominância fiscal admissível), `ambigua`",
  "(sem prior forte), `placebo_ok/viola` (externas: CI90 deve conter 0 em ≥90% de h0-h24).",
  "",
  "## Contagem de vereditos",
  "",
  md_table(verdict_count),
  "",
  "## Violações (incoerente / placebo_viola / sinal errado significativo)",
  "",
  if (nrow(violations) > 0) {
    md_table(violations |> select(group, var, verdict, share_correct,
                                  wrong_sig90, h0, h12, h24))
  } else "*Nenhuma violação significativa.*",
  "",
  "## Trajetórias por grupo (unidades nativas; tcode aplicado)",
  "",
  group_sections,
  "",
  "## Canais soft (câmbio / risco soberano)",
  "",
  md_table(summ |> filter(tier == "soft") |>
             select(var, h0, h6, h12, h24, channel, right_sig90)),
  ""
)

writeLines(report, file.path(OUT_DIR, "irf_coherence_report.md"))
cat(sprintf("Wrote %s\n", file.path(OUT_DIR, "irf_coherence_report.md")))

cat("\n========== VERDICT COUNTS ==========\n")
print(as.data.frame(verdict_count), row.names = FALSE)
cat("\n========== VIOLATIONS ==========\n")
if (nrow(violations) > 0) {
  print(as.data.frame(violations |> select(group, var, verdict, share_correct, wrong_sig90)),
        row.names = FALSE)
} else cat("none\n")
