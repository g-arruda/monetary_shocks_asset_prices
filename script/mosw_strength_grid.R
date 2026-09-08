# ===================================================================
# MOSW instrument-strength grid of Montiel Olea, Stock & Watson
# (2021, sec. 4.2) over (r,q) x sample x instrument.
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
source("R/identification/spec_sweep.R")


# ---- Config --------------------------------------------------------

SPEC <- production_spec()
P_LAGS <- 4L
MP_VAR <- SPEC$mp_var

# The three construction layers reported in the paper's first-stage table
# (tab:first_stage): raw DI surprise, + predetermined orthogonalization,
# + signal filter (production).
INSTRUMENTS <- c("z_bruto", "z_bs_purif", "z_jk_bs_purif")

SAMPLES <- list(
  full = SPEC$sample,
  pre_covid = SPEC$pre_covid_sample
)

RQ_GRID <- tidyr::expand_grid(r = 4:8, q = 2:8) |>
  dplyr::filter(q <= r)

KEYS <- c("sample", "r", "q", "instrument")
EXPECTED_COLUMNS <- c(
  KEYS, "n_obs", "f_robust_mp", "wald_mp", "ar_bounded"
)

DATA_PATH <- SPEC$data_path
INST_PATH <- SPEC$instrument_path
OUT_DIR <- "output/instrument"
CSV_PATH <- file.path(OUT_DIR, "mosw_strength_grid.csv")
REPORT_PATH <- file.path(OUT_DIR, "mosw_strength_grid.md")

CHI2_1_95 <- qchisq(0.95, df = 1)

# Independent smoke test for the production instrument (nota 2026-09-02).
PROD_SMOKE <- list(
  full = c(wald_mp = 6.057014, f_robust_mp = 9.625428),
  pre_covid = c(wald_mp = 8.643436, f_robust_mp = 13.809985)
)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
mp_idx <- match(MP_VAR, colnames(data_mat))
if (is.na(mp_idx)) {
  stop("Policy normalization variable is missing from the production panel")
}

inst_panel <- readr::read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)


# ---- Grid ----------------------------------------------------------

rows <- vector("list", length(SAMPLES) * nrow(RQ_GRID) * length(INSTRUMENTS))
ir <- 0L

for (sample_name in names(SAMPLES)) {
  win <- SAMPLES[[sample_name]]
  in_window <- dates >= win[1] & dates <= win[2]
  data_sub <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]
  expected_n_obs <- nrow(data_sub) - P_LAGS

  for (g in seq_len(nrow(RQ_GRID))) {
    r <- RQ_GRID$r[g]
    q <- RQ_GRID$q[g]

    dfm <- tryCatch(
      estimate_dfm(
        data_sub,
        r = r,
        q = q,
        p = P_LAGS,
        dates = dates_sub,
        apply_kilian = FALSE
      ),
      error = function(error) {
        stop(
          sprintf(
            "DFM estimation failed at (%s, r=%d, q=%d, p=%d): %s",
            sample_name, r, q, P_LAGS, conditionMessage(error)
          ),
          call. = FALSE
        )
      }
    )

    if (!isTRUE(dfm$diagnostics$is_stable) ||
        !is.finite(dfm$diagnostics$max_eigenvalue)) {
      stop(sprintf("Numerically unstable DFM at (%s, r=%d, q=%d, p=%d)",
                   sample_name, r, q, P_LAGS))
    }

    for (instrument in INSTRUMENTS) {
      inst_df <- data.frame(
        month = inst_panel$month,
        shock = inst_panel[[instrument]]
      ) |>
        tidyr::drop_na(shock)

      diag_fs <- tryCatch(
        diagnose_instrument_in_factor_space(
          dfm,
          inst_df,
          dates_sub,
          P_LAGS,
          mp_idx
        ),
        error = function(error) {
          stop(
            sprintf(
              "MOSW diagnostic failed at (%s, r=%d, q=%d, p=%d, %s): %s",
              sample_name, r, q, P_LAGS, instrument, conditionMessage(error)
            ),
            call. = FALSE
          )
        }
      )

      if (!all(is.finite(c(diag_fs$wald_mp, diag_fs$f_robust_mp))) ||
          diag_fs$n_obs != expected_n_obs) {
        stop(sprintf(
          "Invalid MOSW diagnostic at (%s, r=%d, q=%d, p=%d, %s): n_obs=%d",
          sample_name, r, q, P_LAGS, instrument, diag_fs$n_obs
        ))
      }

      ir <- ir + 1L
      rows[[ir]] <- data.frame(
        sample = sample_name,
        r = r,
        q = q,
        instrument = instrument,
        n_obs = diag_fs$n_obs,
        f_robust_mp = diag_fs$f_robust_mp,
        wald_mp = diag_fs$wald_mp,
        ar_bounded = diag_fs$wald_mp > CHI2_1_95,
        stringsAsFactors = FALSE
      )
    }
  }
}

grid <- dplyr::bind_rows(rows)

expected_n_rows <- length(SAMPLES) * nrow(RQ_GRID) * length(INSTRUMENTS)
if (nrow(grid) != expected_n_rows ||
    anyDuplicated(grid[KEYS]) ||
    any(grid$q > grid$r) ||
    any(!is.finite(grid$wald_mp)) ||
    any(!is.finite(grid$f_robust_mp))) {
  stop("MOSW grid failed its coverage, uniqueness or finiteness gates")
}
if (!identical(names(grid), EXPECTED_COLUMNS)) {
  stop("MOSW grid does not have the expected schema")
}

# ---- Production smoke test -----------------------------------------

for (sample_name in names(PROD_SMOKE)) {
  cell <- grid |>
    dplyr::filter(sample == sample_name,
                  r == SPEC$r, q == SPEC$q,
                  instrument == "z_jk_bs_purif")
  if (nrow(cell) != 1L ||
      abs(cell$wald_mp - PROD_SMOKE[[sample_name]][["wald_mp"]]) > 5e-6 ||
      abs(cell$f_robust_mp - PROD_SMOKE[[sample_name]][["f_robust_mp"]]) > 5e-6) {
    stop(sprintf(
      "Production smoke test failed for sample '%s' at (r=%d,q=%d)",
      sample_name, SPEC$r, SPEC$q
    ))
  }
}

readr::write_csv(grid, CSV_PATH)


# ---- Report --------------------------------------------------------

#' Reshape a MOSW statistic into an (r,q) comparison table
#'
#' @param data MOSW grid rows for one sample or provenance block.
#' @param value_col Name of the statistic to display.
#'
#' @return Wide data frame with one row per instrument and one column per cell.
heat <- function(data, value_col) {
  data |>
    dplyr::mutate(rq = sprintf("(%d,%d)", r, q)) |>
    dplyr::select(instrument, rq, val = dplyr::all_of(value_col)) |>
    dplyr::mutate(val = round(val, 2)) |>
    tidyr::pivot_wider(names_from = rq, values_from = val)
}

summary_tbl <- grid |>
  dplyr::group_by(sample, instrument) |>
  dplyr::summarise(
    n_cells = dplyr::n(),
    xi_mp_ge10 = sum(wald_mp >= 10),
    xi_mp_ge384 = sum(wald_mp > CHI2_1_95),
    xi_mp_min = min(wald_mp),
    xi_mp_median = median(wald_mp),
    xi_mp_max = max(wald_mp),
    best_rq = sprintf("(%d,%d)", r[which.max(wald_mp)], q[which.max(wald_mp)]),
    f_robust_mp_median = median(f_robust_mp),
    .groups = "drop"
  ) |>
  dplyr::arrange(sample, match(instrument, INSTRUMENTS))

prod_tbl <- grid |>
  dplyr::filter(r == SPEC$r, q == SPEC$q) |>
  dplyr::select(sample, instrument, r, q, n_obs, wald_mp,
                f_robust_mp, ar_bounded) |>
  dplyr::arrange(sample, match(instrument, INSTRUMENTS))

sections <- c(
  "# Grade de força MOSW — ξ_mp e F robusto por (r,q) × amostra × instrumento",
  "",
  sprintf("Gerado por `script/mosw_strength_grid.R` em %s.", format(Sys.Date())),
  "",
  sprintf(paste0("Grid: r ∈ {4..8}, q ∈ {2..r} (%d combinações) × %d amostras × ",
                 "%d instrumentos = %d células; p = %d; direção de normalização = `%s`."),
          nrow(RQ_GRID), length(SAMPLES), length(INSTRUMENTS), nrow(grid),
          P_LAGS, MP_VAR),
  "",
  paste0("Instrumentos (camadas de construção do instrumento, ",
         "conforme `tab:first_stage`): ",
         paste(sprintf("`%s`", INSTRUMENTS), collapse = ", "), "."),
  "",
  "As duas estatísticas usam a direção de normalização de `yield_6m`.",
  "Todas as células passaram os gates de estabilidade, finitude e `n_obs`.",
  "",
  "Réguas de leitura:",
  "",
  "- **10** é uma referência convencional para ξ_mp e F robusto_mp, não um valor crítico fornecido por MOSW.",
  "- **3,84 < ξ_mp < 10** exige qualificação do bootstrap; a inferência Anderson--Rubin do DFM permanece adiada.",
  "- **ξ_mp ≤ 3,84** indica que um futuro conjunto AR 95% pode ser ilimitado.",
  "- **F robusto_mp** é o primeiro estágio HC1 na mesma direção de normalização de ξ_mp.",
  "",
  "## Resumo por instrumento (contagem de células por faixa de ξ_mp)",
  "",
  md_table(summary_tbl),
  "",
  sprintf("## Especificação de produção (r=%d, q=%d, p=%d)",
          SPEC$r, SPEC$q, P_LAGS),
  "",
  md_table(prod_tbl),
  ""
)

for (sample_name in names(SAMPLES)) {
  sub <- grid |> dplyr::filter(sample == sample_name)
  sections <- c(
    sections,
    sprintf("## Amostra %s", sample_name),
    "",
    "### ξ_mp (Wald na direção de impacto de yield_6m)",
    "",
    md_table(heat(sub, "wald_mp")),
    "",
    "### F robusto_mp (primeiro estágio HC1)",
    "",
    md_table(heat(sub, "f_robust_mp")),
    ""
  )
}

writeLines(sections, REPORT_PATH)
