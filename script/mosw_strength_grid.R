# ===================================================================
# MOSW instrument-strength grid: the Wald block of Montiel Olea,
# Stock & Watson (2021, sec. 4.2) over (r,q) x sample x instrument.
# For each cell reports xi_mp (Wald in the yield_6m-impact direction,
# analogue of the official Waldstat; AR set bounded iff > 3.84),
# the joint Wald T*G'W^-1*G ~ chi2_q with its F-form (xi/q), the
# per-factor min/max xi_k, and the legacy homoskedastic max-F for
# comparability with the 2026-07-11 spec sweep.
# One estimate_dfm per (sample, r, q); instruments enter only the
# cheap projection/diagnostic step.
# Outputs: output/instrument/mosw_strength_grid.csv
#          output/instrument/mosw_strength_grid.md
# ===================================================================

rm(list = ls())

library(readr)
library(dplyr)
library(tidyr)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")   # md_table


# ---- Config --------------------------------------------------------

P_LAGS  <- 6L
MP_VAR  <- "yield_6m"

RQ_GRID <- do.call(rbind, lapply(5:8, function(r)
  data.frame(r = r, q = 4:r)))

SAMPLES <- list(
  full      = as.Date(c("2013-01-01", "2025-12-31")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-31"))
)

VARIANTS <- c("z_bruto", "z_bruto_purif", "z_jk", "z_jk_purif",
              "z_jk_raw_purif", "z_jk_raw", "z_bs_purif", "z_jk_bs_purif")

DATA_PATH <- "data/processed/data_log_deseasonalized.csv"
INST_PATH <- "data/processed/instrumentos_mensais.csv"
OUT_DIR   <- "output/instrument"

CHI2_1_95 <- qchisq(0.95, df = 1)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> select(-ref.date) |> as.matrix()
mp_idx   <- match(MP_VAR, colnames(data_mat))
stopifnot(!is.na(mp_idx))

inst_panel <- read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)


# ---- Grid ----------------------------------------------------------

rows <- list()
ir <- 0

for (sample_name in names(SAMPLES)) {
  win <- SAMPLES[[sample_name]]
  in_window <- dates >= win[1] & dates <= win[2]
  data_sub  <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]

  for (g in seq_len(nrow(RQ_GRID))) {
    r <- RQ_GRID$r[g]; q <- RQ_GRID$q[g]
    cat(sprintf(">>> [%s] DFM r=%d q=%d p=%d (T=%d) ...\n",
                sample_name, r, q, P_LAGS, nrow(data_sub)))
    dfm <- tryCatch(
      estimate_dfm(data_sub, r = r, q = q, p = P_LAGS,
                   dates = dates_sub, apply_kilian = FALSE),
      error = function(e) e
    )
    if (inherits(dfm, "error")) {
      warning(sprintf("estimation failed at (%s, r=%d, q=%d): %s",
                      sample_name, r, q, conditionMessage(dfm)))
      next
    }

    for (v in VARIANTS) {
      inst_df <- data.frame(month = inst_panel$month, shock = inst_panel[[v]])
      inst_df <- inst_df[!is.na(inst_df$shock), ]

      diag_fs <- tryCatch(
        diagnose_instrument_in_factor_space(dfm, inst_df, dates_sub,
                                            P_LAGS, mp_idx),
        error = function(e) e
      )
      if (inherits(diag_fs, "error")) next

      ir <- ir + 1
      rows[[ir]] <- data.frame(
        sample     = sample_name,
        r          = r,
        q          = q,
        instrument = v,
        n_obs      = diag_fs$n_obs,
        f_factor   = diag_fs$f_factor,
        wald_min   = diag_fs$wald_min,
        wald_max   = diag_fs$wald_max,
        wald_joint = diag_fs$wald_joint,
        f_joint    = diag_fs$F_joint,
        p_joint    = diag_fs$p_joint,
        wald_mp    = diag_fs$wald_mp,
        ar_bounded = diag_fs$wald_mp > CHI2_1_95,
        stringsAsFactors = FALSE
      )
    }
  }
}

grid <- bind_rows(rows)
write_csv(grid, file.path(OUT_DIR, "mosw_strength_grid.csv"))
cat(sprintf("\nWrote %d cells to mosw_strength_grid.csv\n", nrow(grid)))


# ---- Report --------------------------------------------------------

heat <- function(df, value_col) {
  df |>
    mutate(rq = sprintf("(%d,%d)", r, q)) |>
    select(instrument, rq, val = all_of(value_col)) |>
    mutate(val = round(val, 2)) |>
    pivot_wider(names_from = rq, values_from = val)
}

summary_tbl <- grid |>
  group_by(sample, instrument) |>
  summarise(
    n_cells        = n(),
    xi_mp_ge10     = sum(wald_mp >= 10),
    xi_mp_ge384    = sum(wald_mp > CHI2_1_95),
    xi_mp_min      = min(wald_mp),
    xi_mp_median   = median(wald_mp),
    xi_mp_max      = max(wald_mp),
    best_rq        = sprintf("(%d,%d)", r[which.max(wald_mp)],
                             q[which.max(wald_mp)]),
    f_joint_median = median(f_joint),
    .groups = "drop"
  ) |>
  arrange(sample, desc(xi_mp_median))

prod_tbl <- grid |>
  filter(r == 7, q == 6) |>
  select(sample, instrument, f_factor, wald_min, wald_max,
         wald_joint, f_joint, p_joint, wald_mp, ar_bounded) |>
  arrange(sample, desc(wald_mp))

sections <- c(
  "# Grade de força MOSW — ξ_mp, Wald conjunta e F conjunta por (r,q) × amostra × instrumento",
  "",
  sprintf("Gerado por `script/mosw_strength_grid.R` em %s.", format(Sys.Date())),
  "",
  sprintf(paste0("Grid: r ∈ {5..8}, q ∈ {4..r} (%d combinações) × %d amostras × ",
                 "%d instrumentos = %d células; p = %d; direção de normalização = `%s`."),
          nrow(RQ_GRID), length(SAMPLES), length(VARIANTS), nrow(grid),
          P_LAGS, MP_VAR),
  "",
  "Estatísticas definidas em `output/instrument/olea_alignment_audit.md` e",
  "validadas contra o código oficial (`codigo_olea/`) e os números publicados",
  "(Kilian oil: ξ₁ = 4.4, F robusta = 9.4 — `script/validate_olea_kilian.R`).",
  "Régua de leitura:",
  "",
  "- **ξ_mp ≥ 10** — força adequada na direção da normalização (análogo do",
  "  `Waldstat` oficial); bandas padrão aproximadamente válidas.",
  "- **3.84 < ξ_mp < 10** — instrumento fraco; conjunto AR 95% limitado, usar",
  "  intervalos Anderson-Rubin.",
  "- **ξ_mp ≤ 3.84** — conjunto AR 95% potencialmente ilimitado.",
  "- **F conjunta (ξ/q)** — relevância conservadora \"em alguma direção\" do",
  "  espaço de fatores; dilui a não-centralidade por q graus de liberdade,",
  "  então valores baixos com ξ_mp alto indicam relevância concentrada na",
  "  direção certa (o esperado sob exogeneidade).",
  "",
  "## Resumo por instrumento (contagem de células por faixa de ξ_mp)",
  "",
  md_table(summary_tbl),
  "",
  "## Especificação de produção (r=7, q=6)",
  "",
  md_table(prod_tbl),
  ""
)

for (s in names(SAMPLES)) {
  sub <- grid |> filter(sample == s)
  sections <- c(
    sections,
    sprintf("## Amostra %s", s),
    "",
    "### ξ_mp (Wald na direção de impacto de yield_6m)",
    "",
    md_table(heat(sub, "wald_mp")),
    "",
    "### F conjunta (T·Γ̂'Ŵ⁻¹Γ̂ / q)",
    "",
    md_table(heat(sub, "f_joint")),
    "",
    "### F (factor-space) legada — max-F homocedástica, comparável ao spec sweep",
    "",
    md_table(heat(sub, "f_factor")),
    ""
  )
}

writeLines(sections, file.path(OUT_DIR, "mosw_strength_grid.md"))
cat(sprintf("Wrote %s\n", file.path(OUT_DIR, "mosw_strength_grid.md")))

cat("\n========== SUMMARY (xi_mp across the grid) ==========\n")
print(as.data.frame(summary_tbl), row.names = FALSE)
