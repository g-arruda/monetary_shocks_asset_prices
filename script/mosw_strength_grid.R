# ===================================================================
# MOSW instrument-strength grid of Montiel Olea,
# Stock & Watson (2021, sec. 4.2) over (r,q) x sample x instrument.
# For each cell reports xi_mp and the robust first-stage F in the same
# yield_6m-impact direction.
# One estimate_dfm per (sample, r, q); instruments enter only the
# cheap projection/diagnostic step.
# Outputs: output/instrument/mosw_strength_grid.csv
#          output/instrument/mosw_strength_grid.md
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")   # md_table


# ---- Config --------------------------------------------------------

SPEC <- production_spec()
P_LAGS  <- SPEC$p
MP_VAR  <- SPEC$mp_var

RQ_GRID <- do.call(rbind, lapply(5:8, function(r)
  data.frame(r = r, q = 4:r)))

SAMPLES <- list(
  full = SPEC$sample,
  pre_covid = SPEC$pre_covid_sample
)

VARIANTS <- c("z_bruto", "z_bruto_purif", "z_jk", "z_jk_purif",
              "z_jk_raw_purif", "z_jk_raw", "z_bs_purif", "z_jk_bs_purif")

DATA_PATH <- SPEC$data_path
INST_PATH <- SPEC$instrument_path
OUT_DIR   <- "output/instrument"

CHI2_1_95 <- qchisq(0.95, df = 1)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |> tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> dplyr::select(-ref.date) |> as.matrix()
mp_idx   <- match(MP_VAR, colnames(data_mat))
stopifnot(!is.na(mp_idx))

inst_panel <- readr::read_csv(INST_PATH, show_col_types = FALSE)
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
        f_robust_mp = diag_fs$f_robust_mp,
        wald_mp    = diag_fs$wald_mp,
        ar_bounded = diag_fs$wald_mp > CHI2_1_95,
        stringsAsFactors = FALSE
      )
    }
  }
}

grid <- dplyr::bind_rows(rows)
readr::write_csv(grid, file.path(OUT_DIR, "mosw_strength_grid.csv"))
cat(sprintf("\nWrote %d cells to mosw_strength_grid.csv\n", nrow(grid)))


# ---- Report --------------------------------------------------------

heat <- function(df, value_col) {
  df |>
    dplyr::mutate(rq = sprintf("(%d,%d)", r, q)) |>
    dplyr::select(instrument, rq, val = dplyr::all_of(value_col)) |>
    dplyr::mutate(val = round(val, 2)) |>
    tidyr::pivot_wider(names_from = rq, values_from = val)
}

summary_tbl <- grid |>
  dplyr::group_by(sample, instrument) |>
  dplyr::summarise(
    n_cells        = dplyr::n(),
    xi_mp_ge10     = sum(wald_mp >= 10),
    xi_mp_ge384    = sum(wald_mp > CHI2_1_95),
    xi_mp_min      = min(wald_mp),
    xi_mp_median   = median(wald_mp),
    xi_mp_max      = max(wald_mp),
    best_rq        = sprintf("(%d,%d)", r[which.max(wald_mp)],
                             q[which.max(wald_mp)]),
    f_robust_mp_median = median(f_robust_mp),
    .groups = "drop"
  ) |>
  dplyr::arrange(sample, dplyr::desc(xi_mp_median))

prod_tbl <- grid |>
  dplyr::filter(r == SPEC$r, q == SPEC$q) |>
  dplyr::select(sample, instrument, wald_mp, f_robust_mp, ar_bounded) |>
  dplyr::arrange(sample, dplyr::desc(wald_mp))

sections <- c(
  "# Grade de força MOSW — ξ_mp e F robusto por (r,q) × amostra × instrumento",
  "",
  sprintf("Gerado por `script/mosw_strength_grid.R` em %s.", format(Sys.Date())),
  "",
  sprintf(paste0("Grid: r ∈ {5..8}, q ∈ {4..r} (%d combinações) × %d amostras × ",
                 "%d instrumentos = %d células; p = %d; direção de normalização = `%s`."),
          nrow(RQ_GRID), length(SAMPLES), length(VARIANTS), nrow(grid),
          P_LAGS, MP_VAR),
  "",
  "Estatísticas definidas em `output/instrument/olea_alignment_audit.md` e",
  "validadas contra o código oficial (`codigos_externos/codigo_olea/`) e os números publicados",
  "(Kilian oil: ξ₁ = 4.4, F robusta = 9.4 — `script/validate_olea_kilian.R`).",
  "Régua de leitura:",
  "",
  "- **10** é uma referência convencional para ξ_mp e F robusto_mp, não um",
  "  valor crítico fornecido por MOSW.",
  "- Valores divergentes das duas estatísticas constituem evidência mista;",
  "  nenhuma delas é usada como pré-teste para selecionar as IRFs.",
  "- **3.84 < ξ_mp < 10** — qualificar o bootstrap; a inferência",
  "  Anderson-Rubin do DFM está adiada.",
  "- **ξ_mp ≤ 3.84** — um futuro conjunto AR 95% pode ser ilimitado.",
  "- **F robusto_mp** — primeiro estágio HC1 de c_mp'η_t sobre o instrumento",
  "  e as defasagens dos fatores; usa a mesma direção de normalização de ξ_mp.",
  "",
  "## Resumo por instrumento (contagem de células por faixa de ξ_mp)",
  "",
  md_table(summary_tbl),
  "",
  sprintf("## Especificação de produção (r=%d, q=%d)", SPEC$r, SPEC$q),
  "",
  md_table(prod_tbl),
  ""
)

for (s in names(SAMPLES)) {
  sub <- grid |> dplyr::filter(sample == s)
  sections <- c(
    sections,
    sprintf("## Amostra %s", s),
    "",
    "### ξ_mp (Wald na direção de impacto de yield_6m)",
    "",
    md_table(heat(sub, "wald_mp")),
    "",
    "### F robusto na direção de impacto de yield_6m",
    "",
    md_table(heat(sub, "f_robust_mp")),
    ""
  )
}

writeLines(sections, file.path(OUT_DIR, "mosw_strength_grid.md"))
cat(sprintf("Wrote %s\n", file.path(OUT_DIR, "mosw_strength_grid.md")))

cat("\n========== SUMMARY (xi_mp across the grid) ==========\n")
print(as.data.frame(summary_tbl), row.names = FALSE)
