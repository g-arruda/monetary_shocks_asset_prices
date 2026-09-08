# ===================================================================
# Stage 1 of the IRF specification sweep: point-estimate IRFs (no
# bootstrap) over instrument x mp_var x (r,q) x sample window.
# For each cell records xi_mp and the matching robust first-stage F in the
# policy-variable normalization direction, impact sign/magnitude and shape of
# the key responses, scores them against theory-consistent signs, and
# classifies failures. The taxonomy classifies on xi_mp (MOSW).
# DFMs are cached: one estimate_dfm per (sample, r, q) — instrument and
# mp_var only enter the cheap projection step.
# Outputs: output/irf/spec_sweep_cells.csv, spec_sweep_irf_long.csv,
#          spec_sweep_report.md
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")


# ---- Config --------------------------------------------------------

SPEC      <- production_spec()
P_LAGS    <- SPEC$p
H_SWEEP   <- 24L
SHOCK_BPS <- SPEC$shock_bps

RQ_GRID <- list(
  c(5L, 4L),   # auto-IC choice on the full panel (Bai-Ng IC2 / Amengual-Watson)
  c(SPEC$r, SPEC$q),
  c(6L, 5L),
  c(7L, 6L),   # spec where z_jk_purif crossed Stock-Yogo (F = 10.17)
  c(8L, 8L)    # historical high-dimensional benchmark
)

SAMPLES <- list(
  full = SPEC$sample,
  pre_covid = SPEC$pre_covid_sample
)

VARIANTS <- c("z_bruto", "z_bruto_purif", "z_jk", "z_jk_purif",
              "z_jk_raw_purif", "z_jk_raw", "z_bs_purif", "z_jk_bs_purif")

MP_VARS <- c("yield_3m", "yield_6m", "yield_1y", "yield_2y", "juros_selic")

DATA_PATH <- SPEC$data_path
INST_PATH <- SPEC$instrument_path
OUT_DIR   <- "output/irf"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |> tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> dplyr::select(-ref.date) |> as.matrix()
tcode    <- infer_tcode_from_varnames(colnames(data_mat))

inst_panel <- readr::read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

theory_tbl <- theory_sign_table()

failure_cell <- function(sample_name, r, q, variant, mp_var, class, msg = NA_character_) {
  data.frame(sample = sample_name, r = r, q = q, p = P_LAGS,
             instrument = variant, mp_var = mp_var,
             failure_class = class, err_msg = msg,
             stringsAsFactors = FALSE)
}


# ---- Sweep ---------------------------------------------------------

cell_rows <- list()
resp_rows <- list()
ic <- 0

for (sample_name in names(SAMPLES)) {
  win <- SAMPLES[[sample_name]]
  in_window <- dates >= win[1] & dates <= win[2]
  data_sub  <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]
  resid_dates <- dates_sub[(P_LAGS + 1):length(dates_sub)]

  for (rq in RQ_GRID) {
    r <- rq[1]; q <- rq[2]
    cat(sprintf("\n>>> [%s] estimating DFM r=%d q=%d p=%d (T=%d) ...\n",
                sample_name, r, q, P_LAGS, nrow(data_sub)))
    t0 <- Sys.time()
    dfm <- tryCatch(
      estimate_dfm(data_sub, r = r, q = q, p = P_LAGS,
                   dates = dates_sub, apply_kilian = FALSE),
      error = function(e) e
    )

    if (inherits(dfm, "error")) {
      for (v in VARIANTS) for (mp in MP_VARS) {
        ic <- ic + 1
        cell_rows[[ic]] <- failure_cell(sample_name, r, q, v, mp,
                                        "estimation_failed", conditionMessage(dfm))
      }
      next
    }
    cat(sprintf("    done in %.1fs (max eig = %.3f)\n",
                as.numeric(Sys.time() - t0, units = "secs"),
                dfm$diagnostics$max_eigenvalue))

    for (v in VARIANTS) {
      inst_df <- data.frame(month = inst_panel$month, shock = inst_panel[[v]])
      inst_df <- inst_df[!is.na(inst_df$shock), ]

      z_win <- inst_df$shock[inst_df$month %in% resid_dates]
      if (length(z_win) < 3 || sd(z_win) == 0) {
        for (mp in MP_VARS) {
          ic <- ic + 1
          cell_rows[[ic]] <- failure_cell(sample_name, r, q, v, mp,
                                          "no_variation_in_window")
        }
        next
      }

      for (mp in MP_VARS) {
        keys <- data.frame(sample = sample_name, r = r, q = q, p = P_LAGS,
                           instrument = v, stringsAsFactors = FALSE)

        res <- tryCatch(
          evaluate_sweep_cell(dfm, data_sub, dates_sub, inst_df, mp,
                              P_LAGS, H_SWEEP, SHOCK_BPS, tcode, theory_tbl),
          error = function(e) e
        )

        ic <- ic + 1
        if (inherits(res, "error")) {
          cell_rows[[ic]] <- failure_cell(sample_name, r, q, v, mp,
                                          "estimation_failed", conditionMessage(res))
          next
        }

        cell_rows[[ic]] <- cbind(
          keys, res$cell,
          data.frame(dfm_max_eig = dfm$diagnostics$max_eigenvalue,
                     failure_class = NA_character_, err_msg = NA_character_)
        )
        resp_rows[[ic]] <- cbind(
          keys[rep(1, nrow(res$responses)), , drop = FALSE],
          data.frame(mp_var = mp), res$responses,
          row.names = NULL
        )
      }
    }
  }
}

cells <- dplyr::bind_rows(cell_rows) |> classify_sweep_cells()
irf_long <- dplyr::bind_rows(resp_rows)

readr::write_csv(cells, file.path(OUT_DIR, "spec_sweep_cells.csv"))
readr::write_csv(irf_long, file.path(OUT_DIR, "spec_sweep_irf_long.csv"))
cat(sprintf("\nWrote %d cell rows and %d response rows\n",
            nrow(cells), nrow(irf_long)))


# ---- Report --------------------------------------------------------

eligible <- cells |>
  dplyr::filter(failure_class == "ok") |>
  dplyr::mutate(score_hard_frac = score_hard / n_hard_avail) |>
  dplyr::arrange(dplyr::desc(score_hard_frac), dplyr::desc(score_ext), dplyr::desc(wald_mp))

top10 <- eligible |>
  dplyr::slice_head(n = 10) |>
  dplyr::select(sample, r, q, instrument, mp_var, wald_mp, f_robust_mp,
         score_hard, n_hard_avail, score_ext, fx_channel, risk_channel,
         yield_ordering_ok, h0_ibov, h0_cambio)

heat_of <- function(s, metric) {
  cells |>
    dplyr::filter(sample == s, mp_var == "yield_6m") |>
    dplyr::mutate(rq = sprintf("r%d_q%d", r, q)) |>
    dplyr::select(instrument, rq, dplyr::all_of(metric)) |>
    tidyr::pivot_wider(names_from = rq, values_from = dplyr::all_of(metric))
}

heat_tables   <- lapply(names(SAMPLES), heat_of, metric = "wald_mp")
heat_tables_f <- lapply(names(SAMPLES), heat_of, metric = "f_robust_mp")
names(heat_tables)   <- names(SAMPLES)
names(heat_tables_f) <- names(SAMPLES)

taxonomy <- cells |>
  dplyr::count(sample, failure_class) |>
  tidyr::pivot_wider(names_from = sample, values_from = n, values_fill = 0)

neg_control <- cells |>
  dplyr::filter(mp_var == "juros_selic") |>
  dplyr::summarise(n = dplyr::n(),
            f_robust_mp_max = max(f_robust_mp, na.rm = TRUE),
            f_robust_mp_median = median(f_robust_mp, na.rm = TRUE))

channels <- eligible |>
  dplyr::count(fx_channel, risk_channel)

baseline_cmp <- cells |>
  dplyr::filter(instrument == "z_jk_bs_purif", mp_var == "yield_6m") |>
  dplyr::select(sample, r, q, wald_mp, f_robust_mp, impact_mp_pre, denom_ratio,
         score_hard, n_hard_avail, score_ext, fx_channel, failure_class) |>
  dplyr::arrange(sample, r, q)

report <- c(
  "# Varredura de especificações IRF — Etapa 1 (ponto-estimativa)",
  "",
  sprintf("Gerado por `script/irf_spec_sweep.R` em %s.", format(Sys.Date())),
  "",
  sprintf(paste0("Grid: %d amostras x %d combinações (r,q) x %d instrumentos x ",
                 "%d variáveis de política = %d células; p = %d, h = %d, choque = %dbp."),
          length(SAMPLES), length(RQ_GRID), length(VARIANTS), length(MP_VARS),
          nrow(cells), P_LAGS, H_SWEEP, SHOCK_BPS),
  "",
  "Sem bootstrap (`nboot = 0`): apenas sinais, magnitudes e força de primeiro estágio.",
  "A Etapa 2 (`script/irf_spec_stage2.R`) roda bootstrap completo nas células vencedoras.",
  "",
  "## Critérios",
  "",
  "- **Régua de força: ξ_mp** (Montiel Olea-Stock-Watson), o Wald na direção do",
  "  impacto da mp_var, com correção Shat. Conjunto AR limitado sse ξ_mp > 3,84;",
  "  bandas convencionais aproximadamente válidas a partir de ξ_mp ≥ 10.",
  "  O `f_robust_mp` é o primeiro estágio HC1 na mesma direção e é reportado",
  "  como diagnóstico complementar, sem condicionar a inferência a pré-teste.",
  "  Na rodada corrente, a célula de produção",
  sprintf("  (%d,%d) full fica abaixo da referência convencional de 10; o valor",
          SPEC$r, SPEC$q),
  "  exato consta na tabela abaixo. Ela permanece fixada por decisão anterior ao resultado,",
  "  sem otimização ex post do par (r,q).",
  "- **Diagnósticos reportados que NÃO classificam** (B4, 2026-07-28): as colunas",
  "  `yield_ordering_ok` e `magnitude_flag` são calculadas por célula e gravadas no",
  "  CSV, mas não entram em `classify_sweep_cells`. `yield_ordering_ok` exige",
  "  |6m| ≥ |2y| ≥ |5y| no impacto e é **FALSE na",
  "  célula de produção**, porque o pico da curva está nos vértices longos, não no",
  "  vértice de política normalizado em +50,0bp. Promovê-la a",
  "  critério classificaria a própria produção como falha; ela é evidência sobre o",
  "  *choque* (hipótese H3 de `diagnostics/diagnostico_dfm.md`), não critério de",
  "  descarte de célula.",
  "- **score_hard** (h=0): yield_6m +, yield_2y +, yield_5y +, asset_ibov −;",
  "  a própria mp_var é excluída do score (impacto mecânico pela normalização).",
  "- **score_ext** (h=24): price_ipca −, pib −, vendas_varejo −.",
  "- **soft** (registrado, não penalizado): cambio_usd, cds_5y, embi_perc —",
  "  depreciação + abertura de risco = canal de dominância fiscal (ver irf_section.md).",
  "- **Taxonomia de falha** (primeira que casa): `negative_control` (juros_selic),",
  "  `weak_xi_mp_severe` (ξ_mp < 3,84 — conjunto AR ilimitado),",
  "  `weak_xi_mp` (ξ_mp < 10 — bandas convencionais inválidas),",
  "  `unstable_normalization` (denominador da normalização < 10% da mediana do grupo),",
  "  `sign_puzzle` (força ok mas sinais hard errados), `ok`.",
  "",
  "## Top-10 células elegíveis (failure_class = ok)",
  "",
  if (nrow(top10) > 0) md_table(top10) else "*Nenhuma célula elegível.*",
  "",
  "## ξ_mp por instrumento x (r,q) — régua de decisão",
  "",
  "Ao contrário da max-F, ξ_mp **depende** da mp_var (é o Wald na direção do",
  "impacto dela); as tabelas abaixo saem das células com mp_var = yield_6m e",
  "por isso são comparáveis a `output/instrument/mosw_strength_grid.csv`.",
  "Limiares MOSW: 3,84 (AR limitado) e 10 (bandas convencionais).",
  "",
  "### Amostra full",
  "",
  md_table(heat_tables$full),
  "",
  "### Amostra pre_covid (2013-2019)",
  "",
  md_table(heat_tables$pre_covid),
  "",
  "## F robusto por instrumento x (r,q)",
  "",
  "Primeiro estágio HC1 de c_mp'η_t sobre o instrumento e as defasagens dos",
  "fatores. Usa a mesma direção de normalização de ξ_mp e depende da mp_var.",
  "As tabelas abaixo fixam mp_var = yield_6m.",
  "",
  "### Amostra full",
  "",
  md_table(heat_tables_f$full),
  "",
  "### Amostra pre_covid (2013-2019)",
  "",
  md_table(heat_tables_f$pre_covid),
  "",
  "## Taxonomia de falhas",
  "",
  md_table(taxonomy),
  "",
  "## Controle negativo (juros_selic)",
  "",
  paste0("`juros_selic` (Selic overnight acumulada, escala percent) é mantido como ",
         "controle negativo documentado — espera-se F robusto baixo (mismatch de ",
         "maturidade, ver `registro/justificativa_uso_yield-6m.md`)."),
  "",
  md_table(neg_control),
  "",
  "## Canais cambial e de risco nas células elegíveis",
  "",
  if (nrow(channels) > 0) md_table(channels) else "*Nenhuma célula elegível.*",
  "",
  "## Instrumento de produção (z_jk_bs_purif x yield_6m) através do grid",
  "",
  paste0("`z_jk_bs_purif` é o `DEFAULT_VARIANT` desde 2026-07-15 e a produção é ",
         sprintf("(r=%d, q=%d). ξ_mp e F robusto usam a mesma direção ",
                 SPEC$r, SPEC$q),
         "de normalização; a taxonomia permanece governada por ξ_mp."),
  "",
  md_table(baseline_cmp),
  ""
)

writeLines(report, file.path(OUT_DIR, "spec_sweep_report.md"))
cat(sprintf("Wrote %s\n", file.path(OUT_DIR, "spec_sweep_report.md")))


# ---- Console summary ----------------------------------------------

cat("\n========== TOP ELIGIBLE CELLS ==========\n")
print(as.data.frame(top10), row.names = FALSE)
cat("\n========== FAILURE TAXONOMY ==========\n")
print(as.data.frame(taxonomy), row.names = FALSE)
