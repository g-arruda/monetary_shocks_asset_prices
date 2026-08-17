# ===================================================================
# Point-by-point theory-coherence check of the production IRFs across
# ~40 key panel variables under the centralized production specification,
# wild bootstrap nboot=800). For each variable, every horizon h = 0..48
# is checked for sign and CI68/CI90 significance against the theory
# window defined in R/identification/irf_coherence.R.
# Outputs: output/irf/irf_coherence_h.csv, irf_coherence_summary.csv,
#          irf_coherence_report.md, irf_coherence_plots.pdf,
#          irf_coherence_cell.rds
# NOT an output: output/irf/irf_coherence_leitura.md — the interpretive
# reading lives there precisely because irf_coherence_report.md is
# rewritten in full on every run (that is how ~95 lines of hand-written
# prose were lost in commit fc0ef58 on 2026-07-26). Never write prose into
# the report; write it into the sibling.
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/validation_tests.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")


# ---- Config (production spec) --------------------------------------

SPEC       <- production_spec()
R_FACTORS  <- SPEC$r
Q_DYNAMIC  <- SPEC$q
P_LAGS     <- SPEC$p
INSTRUMENT <- SPEC$instrument
MP_VAR     <- SPEC$mp_var
HORIZON    <- SPEC$horizon
N_BOOT     <- SPEC$nboot
BOOT_SEED  <- SPEC$bootstrap_seed
SHOCK_BPS  <- SPEC$shock_bps
CI_LEVELS  <- SPEC$ci_levels
WINDOW     <- SPEC$sample

DATA_PATH <- SPEC$data_path
INST_PATH <- SPEC$instrument_path
OUT_DIR   <- "output/irf"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data + estimation ---------------------------------------------

raw_data <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |> tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> dplyr::select(-ref.date) |> as.matrix()
tcode    <- infer_tcode_from_varnames(colnames(data_mat))
var_names <- colnames(data_mat)

inst_panel <- readr::read_csv(INST_PATH, show_col_types = FALSE)
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
saveRDS(cell, SPEC$coherence_cell_path)

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
perh <- dplyr::bind_rows(perh_rows)
summ <- dplyr::bind_rows(summ_rows)

readr::write_csv(perh, file.path(OUT_DIR, "irf_coherence_h.csv"))
readr::write_csv(summ, file.path(OUT_DIR, "irf_coherence_summary.csv"))
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
      patchwork::plot_annotation(
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
  tbl <- summ |> dplyr::filter(group == g) |> dplyr::select(dplyr::all_of(traj_cols))
  c(sprintf("### %s", g), "", md_table(tbl), "")
}))

violations <- summ |>
  dplyr::filter(verdict %in% c("incoerente", "placebo_viola") | wrong_sig90 %in% TRUE)

verdict_count <- summ |> dplyr::count(tier, verdict) |> dplyr::arrange(tier, dplyr::desc(n))

report <- c(
  "# Coerência ponto a ponto das IRFs — especificação de produção",
  "",
  sprintf("Gerado por `script/irf_coherence_check.R` em %s.", format(Sys.Date())),
  "",
  "> **Arquivo gerado — sobrescrito por inteiro a cada rodada.** Não escreva",
  "> prosa aqui: ela se perde no próximo run. A leitura interpretativa vive em",
  "> [`irf_coherence_leitura.md`](irf_coherence_leitura.md), que nenhum script toca.",
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
    md_table(violations |> dplyr::select(group, var, verdict, share_correct,
                                  wrong_sig90, h0, h12, h24))
  } else "*Nenhuma violação significativa.*",
  "",
  "## Trajetórias por grupo (unidades nativas; tcode aplicado)",
  "",
  group_sections,
  "",
  "## Canais soft (câmbio / risco soberano)",
  "",
  md_table(summ |> dplyr::filter(tier == "soft") |>
             dplyr::select(var, h0, h6, h12, h24, channel, right_sig90)),
  ""
)

writeLines(report, file.path(OUT_DIR, "irf_coherence_report.md"))
cat(sprintf("Wrote %s\n", file.path(OUT_DIR, "irf_coherence_report.md")))

cat("\n========== VERDICT COUNTS ==========\n")
print(as.data.frame(verdict_count), row.names = FALSE)
cat("\n========== VIOLATIONS ==========\n")
if (nrow(violations) > 0) {
  print(as.data.frame(violations |> dplyr::select(group, var, verdict, share_correct, wrong_sig90)),
        row.names = FALSE)
} else cat("none\n")
