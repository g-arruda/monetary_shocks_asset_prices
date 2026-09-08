# ===================================================================
# Stage 2 of the IRF specification sweep: full wild-bootstrap IRFs for
# the winning cells of stage 1 (script/irf_spec_sweep.R).
# Selection: eligible cells (failure_class == "ok") with mp_var fixed at
# yield_6m for comparability with the paper's normalization, ranked by
# hard-sign score, extended score and xi_mp (MOSW), capped at 2 cells
# per instrument, TOP_N total; the centralized production baseline is
# force-appended if not selected. Since the
# stage-1 taxonomy is governed by xi_mp; the matching robust first-stage F is
# reported but does not condition cell selection. The baseline
# qualifies on its own, so the force-append is a safety net, not a workaround.
# Outputs: output/irf/irf_spec_<tag>.rds/.pdf, irf_spec_stage2_overlay.pdf,
#          spec_sweep_stage2.md
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/validation_tests.R")
source("R/identification/spec_sweep.R")


# ---- Config --------------------------------------------------------

TOP_N     <- 5L
MAX_PER_INSTRUMENT <- 2L
SPEC      <- production_spec()
N_BOOT    <- SPEC$nboot
HORIZON   <- SPEC$horizon
SHOCK_BPS <- SPEC$shock_bps
P_LAGS    <- SPEC$p
BOOT_SEED <- SPEC$bootstrap_seed
CI_LEVELS <- SPEC$ci_levels
STAGE2_MP <- SPEC$mp_var

SAMPLES <- list(
  full = SPEC$sample,
  pre_covid = SPEC$pre_covid_sample
)

BASELINE <- data.frame(sample = "full", r = SPEC$r, q = SPEC$q,
                       instrument = SPEC$instrument, mp_var = SPEC$mp_var,
                       stringsAsFactors = FALSE)

# Common 3x3 response panel for stage-2 comparisons.
RESPONSE_VARS <- list(
  c("yield 6m"            = "yield_6m"),
  c("yield 2y"            = "yield_2y"),
  c("yield 5y"            = "yield_5y"),
  c("BRL/USD"             = "cambio_usd"),
  c("IBOV"                = "asset_ibov"),
  c("CDS 5y"              = "cds_5y"),
  c("EMBI"                = "embi_perc"),
  c("IPCA (realized)"     = "price_ipca"),
  c("Spread de credito PJ" = "spread_credito_pj_total")
)

PALETTE_BASE <- c("steelblue", "firebrick", "darkgreen", "goldenrod3",
                  "purple3", "grey40")

DATA_PATH <- SPEC$data_path
INST_PATH <- SPEC$instrument_path
OUT_DIR   <- "output/irf"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Select winners from stage 1 -----------------------------------

cells <- readr::read_csv(file.path(OUT_DIR, "spec_sweep_cells.csv"),
                  show_col_types = FALSE)

winners <- cells |>
  dplyr::filter(failure_class == "ok", mp_var == STAGE2_MP) |>
  dplyr::mutate(score_hard_frac = score_hard / n_hard_avail) |>
  dplyr::arrange(dplyr::desc(score_hard_frac), dplyr::desc(score_ext), dplyr::desc(wald_mp)) |>
  dplyr::group_by(instrument) |>
  dplyr::slice_head(n = MAX_PER_INSTRUMENT) |>
  dplyr::ungroup() |>
  dplyr::arrange(dplyr::desc(score_hard_frac), dplyr::desc(score_ext), dplyr::desc(wald_mp)) |>
  dplyr::slice_head(n = TOP_N) |>
  dplyr::select(sample, r, q, instrument, mp_var)

already_in <- nrow(dplyr::semi_join(BASELINE, winners,
                             by = c("sample", "r", "q", "instrument", "mp_var"))) > 0
if (!already_in) {
  cat("[!] Baseline de produção NAO foi selecionado pela etapa 1 — force-append.\n")
  winners <- dplyr::bind_rows(winners, BASELINE)
} else {
  cat("[ok] Baseline de produção selecionado pela própria etapa 1 (sem force-append).\n")
}
winners <- winners |>
  dplyr::mutate(tag = sprintf("%s_r%dq%d_%s", sample, r, q, instrument),
         is_baseline = sample == BASELINE$sample & r == BASELINE$r &
           q == BASELINE$q & instrument == BASELINE$instrument)

cat("Selected cells:\n")
print(as.data.frame(winners), row.names = FALSE)


# ---- Data ----------------------------------------------------------

raw_data <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |> tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> dplyr::select(-ref.date) |> as.matrix()
tcode    <- infer_tcode_from_varnames(colnames(data_mat))

inst_panel <- readr::read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)


# ---- Run bootstrap IRFs --------------------------------------------

results <- list()
for (i in seq_len(nrow(winners))) {
  w <- winners[i, ]
  cat(sprintf("\n>>> [%d/%d] %s (nboot = %d) ...\n",
              i, nrow(winners), w$tag, N_BOOT))
  t0 <- Sys.time()

  res <- run_stage2_cell(
    data_mat, dates, inst_panel,
    sample_window = SAMPLES[[w$sample]],
    r = w$r, q = w$q, p = P_LAGS,
    instrument = w$instrument, mp_var = w$mp_var,
    h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED,
    shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS
  )
  res$sample <- w$sample
  res$tag    <- w$tag
  cat(sprintf("    done in %.1f min\n",
              as.numeric(Sys.time() - t0, units = "mins")))

  saveRDS(
    list(irf = res$irf, var_names = res$var_names, tcode = res$tcode,
         label = w$tag, mp_var = w$mp_var, sample = w$sample,
         r = w$r, q = w$q, p = P_LAGS,
         shock_size_bps = SHOCK_BPS, normalize_value = res$normalize_value),
    file.path(OUT_DIR, sprintf("irf_spec_%s.rds", w$tag))
  )
  results[[w$tag]] <- res
}


# ---- Plots ---------------------------------------------------------

var_names <- colnames(data_mat)
response_idx <- lapply(RESPONSE_VARS, function(entry) {
  idx <- match(as.character(entry), var_names)
  setNames(idx, names(entry))
})

for (tag in names(results)) {
  p <- plot_irf(
    results[[tag]]$irf,
    response_vars = response_idx,
    horizon = HORIZON,
    var_names = var_names,
    tcode = tcode,
    ci_to_plot = CI_LEVELS
  ) + patchwork::plot_annotation(
    title = sprintf("IRFs - %s", tag),
    subtitle = sprintf("Choque = +%dbp em %s | wild bootstrap nboot = %d | bandas 68/90",
                       SHOCK_BPS, STAGE2_MP, N_BOOT)
  )
  ggplot2::ggsave(file.path(OUT_DIR, sprintf("irf_spec_%s.pdf", tag)), p,
         width = 11, height = 9, dpi = 200)
}

palette <- setNames(PALETTE_BASE[seq_along(results)], names(results))
overlay <- plot_overlay_cells(
  results, response_idx, HORIZON, palette,
  subtitle = sprintf("Choque = +%dbp em %s | nboot = %d | bandas 68 (escura) / 90 (clara)",
                     SHOCK_BPS, STAGE2_MP, N_BOOT)
)
ggplot2::ggsave(file.path(OUT_DIR, "irf_spec_stage2_overlay.pdf"), overlay,
       width = 12, height = 10, dpi = 200)


# ---- Report --------------------------------------------------------

HARD_VARS <- c("yield_2y", "yield_5y", "asset_ibov")

cell_tables <- lapply(names(results), function(tag) {
  s <- results[[tag]]
  key90 <- sprintf("%.2f", 0.90)
  rows <- lapply(response_idx, function(entry) {
    var_idx <- as.integer(entry)
    data.frame(
      resposta = var_names[var_idx],
      h0    = s$irf$irf_point_matrix[var_idx, 1],
      lo90  = s$irf$ci[[key90]]$lower[var_idx, 1],
      hi90  = s$irf$ci[[key90]]$upper[var_idx, 1],
      stringsAsFactors = FALSE
    )
  })
  tbl <- do.call(rbind, rows)
  tbl$ci90_exclui_zero <- tbl$lo90 > 0 | tbl$hi90 < 0
  row.names(tbl) <- NULL
  tbl
})
names(cell_tables) <- names(results)

report <- c(
  "# Varredura de especificações IRF — Etapa 2 (bootstrap nos vencedores)",
  "",
  sprintf("Gerado por `script/irf_spec_stage2.R` em %s.", format(Sys.Date())),
  "",
  sprintf("Wild bootstrap (Gonçalves-Kilian) com nboot = %d, seed = %d, bandas 68/90.",
          N_BOOT, BOOT_SEED),
  sprintf("mp_var fixada em `%s` (+%dbp no impacto) para comparabilidade entre células.",
          STAGE2_MP, SHOCK_BPS),
  "",
  "## Células selecionadas",
  "",
  md_table(winners |> dplyr::select(-is_baseline)),
  ""
)

for (tag in names(results)) {
  tbl <- cell_tables[[tag]]
  hard_ok <- tbl |>
    dplyr::filter(resposta %in% HARD_VARS) |>
    dplyr::summarise(corroboradas = sum(ci90_exclui_zero), total = dplyr::n())
  report <- c(
    report,
    sprintf("## %s%s", tag,
            if (winners$is_baseline[match(tag, winners$tag)]) " (baseline atual)" else ""),
    "",
    md_table(tbl),
    "",
    sprintf(paste0("Variáveis hard-tier com CI90 excluindo zero no impacto: %d de %d ",
                   "(yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização)."),
            hard_ok$corroboradas, hard_ok$total),
    ""
  )
}

writeLines(report, file.path(OUT_DIR, "spec_sweep_stage2.md"))
cat(sprintf("\nWrote %s\n", file.path(OUT_DIR, "spec_sweep_stage2.md")))
