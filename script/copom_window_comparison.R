# ===================================================================
# The window audit of the advisor's e-mail of 2026-10-17, item 4: how much
# the corrected Copom windows move the central result. Three instruments, the
# production z_bs_purif of each, with the Bauer-Swanson regression refitted on
# its own events:
#   base_102           the previous base, 102 meetings: the 2 on Thanksgiving
#                      dropped by the S&P 500, VIX and Brent filter of an
#                      earlier orthogonalization, the 7 on the eve of a
#                      Brazilian holiday at zero (frozen copy of the
#                      instrument before the correction);
#   acao_de_gracas_104 the 2 on Thanksgiving back, the filter gone: production;
#   feriados_111       also the 7 on the eve of a Brazilian holiday, with the
#                      window from the Wednesday close to Friday's.
# A meeting left out has its month at zero, as in the previous base. Panel,
# factors, VAR and theta are production's; only the instrument changes. For
# each cell: xi_mp, F_rob, and the FX and CDS impacts with their 80 and 90%
# Anderson-Rubin sets.
# script/instrument.R and script/irf_coherence_check.R must run first.
# Output: output/copom_windows/comparison.csv
# Note: notas/2026-10-17_auditoria_janelas_copom.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")
source("R/identification/factor_space_diagnostics.R")

INSTRUMENT_PATHS <- c(
  base_102 = "output/copom_windows/instrument_base_102.csv",
  acao_de_gracas_104 = "data/processed/instrument.csv",
  feriados_111 = "data/processed/instrument_holiday_windows.csv"
)
CELL_PATH  <- "output/irf/irf_coherence_cell.rds"
THETA_PATH <- "output/factors/covid_volatility_theta.csv"
OUT_DIR    <- "output/copom_windows"
TARGET_VARS <- c(cambio = "cambio_usd", cds = "cds_5y")
# The months whose instrument the corrections change
THANKSGIVING_MONTHS <- as.Date(c("2013-11-01", "2015-11-01"))
HOLIDAY_MONTHS <- as.Date(c(
  "2013-05-01", "2015-06-01", "2017-09-01", "2019-06-01", "2022-06-01",
  "2023-11-01", "2025-06-01"
))
# The previous base as the branch pinned it before the correction
BASE_XI_MP <- 6.6613895553441687
BASE_FX_H0 <- 0.1448646415797471

# Each correction moves the raw surprise only in its own months
instruments <- purrr::map(INSTRUMENT_PATHS, \(path) {
  readr::read_csv(path, show_col_types = FALSE)
})
months_moved <- \(a, b) a$month[abs(a$shock - b$shock) > 0]
stopifnot(
  all(THANKSGIVING_MONTHS %in% months_moved(instruments$base_102, instruments$acao_de_gracas_104)),
  instruments$feriados_111$shock[match(HOLIDAY_MONTHS, instruments$feriados_111$month)] != 0,
  instruments$acao_de_gracas_104$shock[match(HOLIDAY_MONTHS, instruments$acao_de_gracas_104$month)] == 0,
  instruments$base_102$shock[match(c(THANKSGIVING_MONTHS, HOLIDAY_MONTHS), instruments$base_102$month)] == 0
)

cells <- purrr::map(INSTRUMENT_PATHS, \(path) {
  main_sdfm(
    instrument_path = path,
    r = 5L,
    q = 5L,
    p = 4L,
    h = 48L,
    mp_var = "yield_6m",
    shock_size_bps = 50,
    ci_levels = c(0.80, 0.90),
    inference = "ar",
    ar_nw_lags = 0L,
    covid_volatility = read_covid_volatility(THETA_PATH)
  )
})

# Production is the cell irf_coherence_check.R cached, and the previous base
# reproduces the branch's pins
cached <- readRDS(CELL_PATH)$irf
fx_row <- match("cambio_usd", colnames(cells$base_102$data))
stopifnot(
  identical(cells$acao_de_gracas_104$irfs$irf_point_matrix, cached$irf_point_matrix),
  abs(cells$base_102$irfs$ar$xi_den - BASE_XI_MP) < 1e-8,
  abs(cells$base_102$irfs$irf_point_matrix[fx_row, 1] - BASE_FX_H0) < 1e-12
)

comparison <- purrr::imap(cells, \(fit, name) {
  strength <- diagnose_instrument_in_factor_space(
    fit$model,
    fit$model$instrument,
    fit$model$dates,
    fit$model$p,
    fit$mpind
  )
  tidy_ar_sets(fit$irfs$ar, colnames(fit$data)) |>
    dplyr::filter(variable %in% TARGET_VARS, h == 0L) |>
    tidyr::pivot_wider(
      id_cols = c(variable, point),
      names_from = level,
      values_from = c(lo, hi, set_type, significant)
    ) |>
    dplyr::mutate(
      cell = name,
      xi_mp = fit$irfs$ar$xi_den,
      f_robust_mp = strength$f_robust_mp,
      .before = 1
    )
}) |>
  purrr::list_rbind() |>
  dplyr::mutate(series = names(TARGET_VARS)[match(variable, TARGET_VARS)], .after = cell)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
readr::write_csv(comparison, file.path(OUT_DIR, "comparison.csv"))
