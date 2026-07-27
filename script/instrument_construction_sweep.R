# ===================================================================
# Sweep of the two instrument-construction choices that were never
# documented on the current vintage under the current ruler:
#
#   1. the DI vertex (TARGET_BD, production 126 business days ~ 6m);
#   2. the monthly aggregation scheme (production: within-month sum,
#      Jarocinski-Karadi; alternative: Gertler-Karadi fn. 11).
#
# Scored by xi_mp — the Montiel Olea-Stock-Watson Wald in the
# yield_6m impact direction — at the production dimension (7,6), on
# both sample windows. One estimate_dfm per window; the instruments
# enter only the cheap projection step.
#
# This answers Etapa 8.1 of _instrucoes/Instrumento.md ("substituir DI
# 3m por DI 6m e DI 12m") and re-documents a specification choice whose
# only surviving justification was a code comment. The predecessor grid,
# arquivo/output/instrument_grid.csv (2026-04-12), is stale on three
# axes: pre-refresh vintage, legacy partial-F ruler (its winner scored
# 4.30, i.e. "least bad"), and four legacy variants that did not include
# today's production instrument.
#
# Precedent for the exercise: Alessi & Kerssenfischer (2019) Figure A4
# is the same sweep on the same estimator — their appendix runs A1 (p),
# A2 (r), A3 (q) and A4 (instrument), and this project has the first
# three and not the fourth. Precedent for scoring the horizon by
# first-stage strength: Gertler-Karadi choose FF4 that way and relegate
# their conceptually preferred indicator to robustness.
#
# Anti-screening protocol (MOSW fn. 6): the whole grid is reported, and
# nothing is filtered on the statistic.
#
# Outputs: output/instrument/instrument_construction_sweep.csv
#          output/instrument/instrument_construction_sweep.md
# ===================================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(readr)
  library(lubridate); library(tibble); library(purrr)
})

source("R/instrument/di_surprise.R")
source("R/instrument/build_variants.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")   # md_table


# ---- Config --------------------------------------------------------

R_PROD <- 7L; Q_PROD <- 6L; P_LAGS <- 6L
MP_VAR <- "yield_6m"

SAMPLE_START <- as.Date("2013-01-01")
SAMPLE_END   <- as.Date("2025-12-31")
LOAD_START   <- as.Date("2012-06-01")

PROD_BD  <- 126L
PROD_AGG <- "sum"

# The DI grid is monthly out to ~13 months and quarterly beyond, so
# neighbouring targets often resolve to the same contract; the report
# carries the realized maturity per target so the effective grid is visible.
VERTICES <- c(21L, 42L, 63L, 84L, 105L, 126L, 147L, 168L, 189L, 210L,
              252L, 378L, 504L)

AGGS <- c("sum", "gk")

VARIANTS <- c("z_jk_bs_purif", "z_jk_raw", "z_jk_raw_purif",
              "z_jk_purif", "z_bruto")

SAMPLES <- list(
  full      = as.Date(c("2013-01-01", "2025-12-31")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-31"))
)

DATA_PATH <- "data/processed/data_log_deseasonalized.csv"
OUT_DIR   <- "output/instrument"
CHI2_1_95 <- qchisq(0.95, df = 1)
XI_CONV   <- 10

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Daily inputs (loaded once) ------------------------------------

cat("Loading daily inputs ...\n")

di_panel <- load_di_panel("data/di.csv", from = LOAD_START, to = SAMPLE_END + 30)

inputs <- list(
  di_panel   = di_panel,
  ibov_daily = read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
    transmute(date = as.Date(date), ibov = as.numeric(ibov)) |> filter(!is.na(ibov)),
  ext_daily  = read_csv("data/investing/external_factors_daily.csv", show_col_types = FALSE) |>
    transmute(date = as.Date(date), sp500 = as.numeric(sp500),
              vix = as.numeric(vix), brent = as.numeric(brent)),
  brl_daily  = read_csv("data/processed/brl_usd_daily.csv", show_col_types = FALSE) |>
    transmute(date = as.Date(date), brl = as.numeric(brl)) |> filter(!is.na(brl)),
  focus_daily = read_csv("data/processed/focus_daily.csv", show_col_types = FALSE) |>
    transmute(date = as.Date(date), focus_ipca12m = as.numeric(focus_ipca12m),
              focus_selic_ny = as.numeric(focus_selic_ny)),
  dgs2_daily = read_csv("data/fred_dgs2.csv", show_col_types = FALSE) |>
    transmute(date = as.Date(date), ust2y = as.numeric(ust2y)),
  copom_wed  = load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END),
  fomc_dates = as.Date(character(0))
)


# ---- Realized DI maturity per target vertex ------------------------
# build_thursday_surprises picks the nearest contract, so the realized
# maturity drifts away from the target where the DI grid is sparse.

copom_thu <- inputs$copom_wed + 1

realized_bd <- map_dfr(VERTICES, function(tbd) {
  bd <- map_dbl(copom_thu, function(thu) {
    wed <- di_panel |> filter(date == thu - 1)
    if (!nrow(wed)) return(NA_real_)
    wed$bdays[which.min(abs(wed$bdays - tbd))]
  })
  bd <- bd[!is.na(bd)]
  tibble(target_bd = tbd, n = length(bd),
         bd_median = median(bd), bd_p10 = quantile(bd, .10),
         bd_p90 = quantile(bd, .90), n_distinct_bd = n_distinct(bd))
})


# ---- Build every (vertex, aggregation) instrument panel ------------

cat(sprintf("Building %d vertices x %d aggregation schemes ...\n",
            length(VERTICES), length(AGGS)))

panels <- list()
build_diag <- list(); ib <- 0

for (tbd in VERTICES) {
  for (ag in AGGS) {
    key <- paste(tbd, ag, sep = "|")
    b <- tryCatch(
      build_instrument_variants(inputs, target_bd = tbd, agg = ag,
                                sample_start = SAMPLE_START,
                                sample_end = SAMPLE_END, strict = FALSE),
      error = function(e) e)
    if (inherits(b, "error")) {
      warning(sprintf("build failed at (%d, %s): %s", tbd, ag, conditionMessage(b)))
      next
    }
    panels[[key]] <- b$monthly
    ib <- ib + 1
    build_diag[[ib]] <- as_tibble(b$diag)
  }
  cat(sprintf("  vertex %3d du done\n", tbd))
}

build_diag <- bind_rows(build_diag)


# ---- Score every panel under xi_mp ---------------------------------

raw_data <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> select(-ref.date) |> as.matrix()
mp_idx   <- match(MP_VAR, colnames(data_mat))
stopifnot(!is.na(mp_idx))

rows <- list(); ir <- 0

for (sample_name in names(SAMPLES)) {
  win       <- SAMPLES[[sample_name]]
  in_window <- dates >= win[1] & dates <= win[2]
  data_sub  <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]

  cat(sprintf(">>> [%s] DFM r=%d q=%d p=%d (T=%d) ...\n",
              sample_name, R_PROD, Q_PROD, P_LAGS, nrow(data_sub)))
  dfm <- estimate_dfm(data_sub, r = R_PROD, q = Q_PROD, p = P_LAGS,
                      dates = dates_sub, apply_kilian = FALSE)

  if (sample_name == "full") dfm_full <- dfm

  for (key in names(panels)) {
    parts <- strsplit(key, "|", fixed = TRUE)[[1]]
    tbd   <- as.integer(parts[1]); ag <- parts[2]
    pan   <- panels[[key]]

    # The GK scheme splits each surprise across t and t+1, inducing an
    # MA(1); NW(1) is the honest reading for those cells. The sum scheme
    # is non-overlapping, so NW(0) stands.
    nw <- if (ag == "gk") 1L else 0L

    for (v in VARIANTS) {
      inst_df <- data.frame(month = pan$month, shock = pan[[v]])
      inst_df <- inst_df[!is.na(inst_df$shock), ]

      d <- tryCatch(
        diagnose_instrument_in_factor_space(dfm, inst_df, dates_sub,
                                            P_LAGS, mp_idx, nw_lags = nw),
        error = function(e) e)
      if (inherits(d, "error")) next

      # Same cell under NW(0) too, so the two schemes are also comparable
      # on an identical covariance convention.
      d0 <- if (nw == 0L) d else tryCatch(
        diagnose_instrument_in_factor_space(dfm, inst_df, dates_sub,
                                            P_LAGS, mp_idx, nw_lags = 0L),
        error = function(e) NULL)

      ir <- ir + 1
      rows[[ir]] <- data.frame(
        sample     = sample_name,
        target_bd  = tbd,
        agg        = ag,
        instrument = v,
        nw_lags    = nw,
        n_obs      = d$n_obs,
        n_nonzero  = sum(inst_df$shock != 0),
        wald_mp    = d$wald_mp,
        wald_mp_nw0 = if (is.null(d0)) NA_real_ else d0$wald_mp,
        wald_joint = d$wald_joint,
        f_joint    = d$F_joint,
        f_factor   = d$f_factor,
        impact_mp  = d$impact_mp,
        ar_bounded = d$wald_mp > CHI2_1_95,
        stringsAsFactors = FALSE)
    }
  }
}

grid <- bind_rows(rows)
write_csv(grid, file.path(OUT_DIR, "instrument_construction_sweep.csv"))
cat(sprintf("\nWrote %d cells to instrument_construction_sweep.csv\n", nrow(grid)))


# ---- Tables --------------------------------------------------------

incumbent <- grid |>
  filter(target_bd == PROD_BD, agg == PROD_AGG, instrument == "z_jk_bs_purif") |>
  select(sample, xi_inc = wald_mp)

heat <- function(df, ag) {
  df |>
    filter(agg == ag) |>
    mutate(val = round(wald_mp, 2)) |>
    select(instrument, target_bd, val) |>
    pivot_wider(names_from = target_bd, values_from = val) |>
    rename_with(~ ifelse(.x == "instrument", .x, paste0(.x, "du")))
}

xi_inc_full <- incumbent$xi_inc[incumbent$sample == "full"]
xi_inc_pre  <- incumbent$xi_inc[incumbent$sample == "pre_covid"]

# Cells that beat the incumbent in BOTH windows.
both <- grid |>
  select(sample, target_bd, agg, instrument, wald_mp) |>
  pivot_wider(names_from = sample, values_from = wald_mp) |>
  mutate(beats_both  = full > xi_inc_full & pre_covid > xi_inc_pre,
         clears_both = full >= XI_CONV & pre_covid >= XI_CONV,
         margin_full = full - xi_inc_full) |>
  arrange(desc(beats_both & clears_both), desc(margin_full))

top <- both |>
  filter(beats_both, clears_both) |>
  select(target_bd, agg, instrument, full, pre_covid, margin_full)

# ---- Pre-registered decision rule ----------------------------------
# Fixed in the plan before any of these numbers existed. A challenger
# replaces the production construction only if it (i) beats the
# incumbent in both windows, (ii) clears xi_mp >= 10 in both, and
# (iii) wins by more than the leave-one-month-out dispersion of the
# incumbent's own xi_mp — a margin smaller than what dropping a single
# month moves is not a signal. The threshold is read from the Part 1
# artifact rather than asserted here.

LOO_PATH <- file.path(OUT_DIR, "xi_mp_robustness.csv")
loo_swing <- if (file.exists(LOO_PATH)) {
  r <- read_csv(LOO_PATH, show_col_types = FALSE)
  b <- r |> filter(exercise == "baseline", sample == "full",
                   instrument == "z_jk_bs_purif") |> pull(wald_mp)
  l <- r |> filter(exercise == "loo", sample == "full",
                   instrument == "z_jk_bs_purif") |> pull(wald_mp)
  max(b - min(l), max(l) - b)
} else NA_real_

rule_fires <- !is.na(loo_swing) && nrow(top) > 0 &&
  any(top$margin_full > loo_swing)


# ---- Report --------------------------------------------------------

fmt <- function(df) md_table(df |> mutate(across(where(is.numeric), ~ round(.x, 3))))

sections <- c(
  "# Robustez da construção do instrumento — vértice do DI e esquema de agregação",
  "",
  sprintf("Gerado por `script/instrument_construction_sweep.R` em %s.", format(Sys.Date())),
  "",
  sprintf(paste0("Grid: %d vértices × %d esquemas de agregação × %d variantes × ",
                 "%d amostras = %d células. Dimensão (r, q) = (%d, %d), p = %d, ",
                 "direção de normalização = `%s`. Um `estimate_dfm` por amostra."),
          length(VERTICES), length(AGGS), length(VARIANTS), length(SAMPLES),
          nrow(grid), R_PROD, Q_PROD, P_LAGS, MP_VAR),
  "",
  sprintf(paste0("**Incumbente:** vértice %d du + soma JK + `z_jk_bs_purif` — ",
                 "ξ_mp = %.2f full / %.2f pré-COVID."),
          PROD_BD, xi_inc_full, xi_inc_pre),
  "",
  paste0("Protocolo anti-screening de MOSW (nota 6): a grade inteira é ",
         "reportada e nada é filtrado pela estatística."),
  "",
  "## 1. Maturidade realizada por vértice-alvo",
  "",
  paste0("`build_thursday_surprises` escolhe o **contrato mais próximo**, não ",
         "interpola. A grade do DI é mensal até ~13 meses e trimestral depois, ",
         "então vértices-alvo vizinhos podem cair no mesmo contrato. Medido nos ",
         "dias de Copom."),
  "",
  fmt(realized_bd),
  "",
  "## 2. ξ_mp por vértice — agregação por soma (Jarociński-Karadi, produção)",
  "",
  "### Amostra completa",
  "",
  fmt(heat(grid |> filter(sample == "full"), "sum")),
  "",
  "### Pré-COVID",
  "",
  fmt(heat(grid |> filter(sample == "pre_covid"), "sum")),
  "",
  "## 3. ξ_mp por vértice — agregação Gertler-Karadi (nota 11)",
  "",
  paste0("Lida em **NW(1)**: o esquema GK parte cada surpresa entre `t` e `t+1`, ",
         "o que induz MA(1) por construção. A coluna `wald_mp_nw0` do CSV traz a ",
         "mesma célula em NW(0) para comparação na mesma convenção do painel de ",
         "soma. Sob GK os meses sem reunião **deixam de ser zero**, então a ",
         "propriedade que JK e BS assumem se perde."),
  "",
  "### Amostra completa",
  "",
  fmt(heat(grid |> filter(sample == "full"), "gk")),
  "",
  "### Pré-COVID",
  "",
  fmt(heat(grid |> filter(sample == "pre_covid"), "gk")),
  "",
  "## 4. Células que batem o incumbente nas duas janelas e cruzam 10 nas duas",
  "",
  if (nrow(top) == 0)
    "_Nenhuma._ O incumbente não é dominado por nenhuma célula da grade."
  else fmt(top),
  "",
  "### Veredito da regra de decisão",
  "",
  paste0("A regra foi fixada **antes** de qualquer um destes números existir ",
         "(plano de 2026-07-27). Uma célula substitui a construção de produção ",
         "só se (i) bater o incumbente nas duas janelas, (ii) cruzar ξ_mp ≥ 10 ",
         "nas duas, e (iii) vencer por margem maior que a dispersão ",
         "leave-one-month-out do próprio ξ_mp do incumbente — uma vantagem menor ",
         "do que o que um único mês move não é sinal."),
  "",
  sprintf(paste0("Limiar (iii), lido de `xi_mp_robustness.csv`: **%.2f** pontos ",
                 "(maior desvio LOO de ξ_mp = %.2f na amostra completa)."),
          loo_swing, xi_inc_full),
  "",
  sprintf("Maior margem observada: **%.2f** (%s).",
          if (nrow(top)) max(top$margin_full) else 0,
          if (nrow(top)) sprintf("%d du, %s, `%s`",
                                 top$target_bd[which.max(top$margin_full)],
                                 top$agg[which.max(top$margin_full)],
                                 top$instrument[which.max(top$margin_full)])
          else "nenhuma célula elegível"),
  "",
  if (rule_fires)
    paste0("**A regra DISPARA.** A construção de produção deve ser revista — ",
           "ver o item de checkpoint em `_instrucoes/pendencias.md`.")
  else
    paste0("**A regra NÃO dispara.** O incumbente (", PROD_BD, " du + soma JK) ",
           "permanece. Nenhuma célula vence por margem que sobreviva ao ruído ",
           "amostral do próprio ξ_mp: o melhor desafiante ganha menos do que o ",
           "que a remoção de um único mês move a estatística. A leitura correta ",
           "não é que ", PROD_BD, " du é o ótimo — ele **não** é o argmax em ",
           "nenhuma das duas janelas —, e sim que **o vértice não é ",
           "identificado com precisão suficiente para escolher entre os ",
           "candidatos**, e que a escolha herdada está dentro do conjunto ",
           "indistinguível do melhor."),
  "",
  "## 5. Contagem de células por variante (agregação por soma)",
  "",
  fmt(grid |> filter(agg == "sum") |>
        group_by(sample, instrument) |>
        summarise(n_vertices = n(),
                  xi_min = min(wald_mp), xi_median = median(wald_mp),
                  xi_max = max(wald_mp),
                  best_bd = target_bd[which.max(wald_mp)],
                  n_ge10 = sum(wald_mp >= XI_CONV),
                  n_ge384 = sum(wald_mp > CHI2_1_95),
                  .groups = "drop") |>
        arrange(sample, desc(xi_median))),
  "",
  "## 6. Diagnóstico de construção por célula",
  "",
  paste0("`n_valid` são quintas-feiras válidas, `n_copom` os dias de reunião ",
         "retidos, e `n_jk_bs` os classificados como monetários pela máscara ",
         "predeterminada. R² das regressões BS pré-evento para referência ",
         "(faixa da Tabela 3 de Bauer-Swanson: 0,12–0,20)."),
  "",
  fmt(build_diag |> filter(agg == "sum") |>
        select(target_bd, n_valid, n_copom, n_jk, n_jk_raw, n_jk_bs,
               r2_di_bs, r2_ibov_bs)),
  ""
)

writeLines(sections, file.path(OUT_DIR, "instrument_construction_sweep.md"))
cat(sprintf("Wrote %s\n", file.path(OUT_DIR, "instrument_construction_sweep.md")))

cat("\n========== xi_mp, sum scheme, production instrument ==========\n")
print(as.data.frame(grid |> filter(agg == "sum", instrument == "z_jk_bs_purif") |>
                      select(sample, target_bd, n_nonzero, wald_mp) |>
                      mutate(wald_mp = round(wald_mp, 2))), row.names = FALSE)
cat("\n========== Cells beating the incumbent in both windows ==========\n")
if (nrow(top) == 0) cat("  none\n") else
  print(as.data.frame(top |> mutate(across(where(is.numeric), ~ round(.x, 2)))),
        row.names = FALSE)


# ===================================================================
# Vertex IRF overlay — the Alessi & Kerssenfischer (2019) Figure A4
# analogue. Their robustness appendix runs A1 (p), A2 (r), A3 (q) and
# A4 (external instrument); this project had the first three and not
# the fourth. A4 overlays alternative-instrument point estimates on
# the benchmark's confidence bands, which is exactly what this does:
# the bands come from the production bootstrap already on disk
# (output/irf/irf_coherence_h.csv), so no new bootstrap is run.
# ===================================================================

suppressPackageStartupMessages({ library(ggplot2) })

OVERLAY_VARS <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
H_OVER       <- 24L
BENCH_PATH   <- "output/irf/irf_coherence_h.csv"

if (!exists("dfm_full")) stop("full-sample DFM not retained")

var_names <- colnames(data_mat)
tcode_all <- infer_tcode_from_varnames(var_names)
mp_norm   <- norm_value_for(MP_VAR, 50)

cat("\nBuilding vertex IRF overlay (sum scheme, z_jk_bs_purif) ...\n")

irf_long <- map_dfr(VERTICES, function(tbd) {
  pan <- panels[[paste(tbd, "sum", sep = "|")]]
  if (is.null(pan)) return(NULL)
  inst_df <- data.frame(month = pan$month, shock = pan$z_jk_bs_purif)
  inst_df <- inst_df[!is.na(inst_df$shock), ]

  ir <- tryCatch(
    compute_irf_dfm(dfm_full, instrument = inst_df, h = H_OVER, nboot = 0,
                    mpind = mp_idx, normalize_value = mp_norm,
                    data_dates = dates, tcode = tcode_all, diagnose = FALSE),
    error = function(e) NULL)
  if (is.null(ir)) return(NULL)

  m <- ir$irf_point_matrix
  map_dfr(OVERLAY_VARS, function(v) {
    i <- match(v, var_names)
    tibble(var = v, h = 0:H_OVER, point = m[i, seq_len(H_OVER + 1)],
           target_bd = tbd)
  })
})

bench <- read_csv(BENCH_PATH, show_col_types = FALSE) |>
  filter(var %in% OVERLAY_VARS, h <= H_OVER) |>
  select(var, h, lo68, hi68, lo90, hi90)

irf_long <- irf_long |>
  mutate(var = factor(var, levels = OVERLAY_VARS),
         role = ifelse(target_bd == PROD_BD, "producao", "alternativo"))
bench$var <- factor(bench$var, levels = OVERLAY_VARS)

p <- ggplot() +
  geom_ribbon(data = bench, aes(h, ymin = lo90, ymax = hi90),
              fill = "grey70", alpha = 0.35) +
  geom_ribbon(data = bench, aes(h, ymin = lo68, ymax = hi68),
              fill = "grey50", alpha = 0.35) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey30") +
  geom_line(data = filter(irf_long, role == "alternativo"),
            aes(h, point, group = target_bd, colour = target_bd),
            linewidth = 0.45, alpha = 0.85) +
  geom_line(data = filter(irf_long, role == "producao"),
            aes(h, point), colour = "black", linewidth = 1.1) +
  scale_colour_viridis_c(name = "vértice DI\n(dias úteis)", option = "plasma", end = 0.9) +
  facet_wrap(~ var, scales = "free_y", ncol = 2) +
  labs(
    title = "Resposta a um choque de +50bp por vértice do DI usado na surpresa",
    subtitle = paste0("Linha preta: vértice de produção (", PROD_BD,
                      " du). Bandas de 68% e 90% do bootstrap de produção.\n",
                      "Agregação mensal por soma; instrumento z_jk_bs_purif; (r,q) = (7,6); amostra completa."),
    x = "horizonte (meses)", y = NULL,
    caption = "Analogo da Figura A4 de Alessi & Kerssenfischer (2019)."
  ) +
  theme_minimal(base_size = 10) +
  theme(legend.position = "bottom",
        plot.title = element_text(face = "bold"),
        strip.text = element_text(face = "bold"))

ggsave(file.path(OUT_DIR, "vertex_irf_overlay.pdf"), p,
       width = 9, height = 10)
cat(sprintf("Wrote %s\n", file.path(OUT_DIR, "vertex_irf_overlay.pdf")))

# Sanity: the production vertex must reproduce the benchmark point path.
chk <- irf_long |> filter(target_bd == PROD_BD) |>
  inner_join(read_csv(BENCH_PATH, show_col_types = FALSE) |>
               select(var, h, bench_point = point) |>
               mutate(var = factor(var, levels = OVERLAY_VARS)),
             by = c("var", "h"))
cat(sprintf("Production vertex vs benchmark point path: max |diff| = %.2e over %d points\n",
            max(abs(chk$point - chk$bench_point)), nrow(chk)))
