# ===================================================================
# Step 4/5 of the advisor's plan of 2026-10-03, in the design of his e-mail
# of 2026-10-08 (item 4): the external placebos at the horizons fixed before
# looking at the results, with a joint assessment, on the fixed-horizon Focus
# base of step 0.
#   A. The AR p-value of a zero response of the three placebos of the paper,
#      VIX, MSCI Emerging Markets and US EPU, at h = 0, 1, 3, 6, 12, 24, read
#      off step 1's table, where ar_statistic() computed it at lambda0 = 0
#      under NW(0). Holm's correction over the family of the 18 tests, at 10%.
#   B. Which of the three series enter the Bauer-Swanson orthogonalization of
#      the instrument, with their coefficient in the DI regression.
# Nothing is estimated. script/irf_coherence_check.R and
# script/ar_precision.R must run first; the production point and 90% sets of
# step 1's table are checked against the cache.
# Outputs: output/placebo_holm/
#   table.csv              the 18 tests: point, pointwise 90 and 95% sets,
#                          p-value and the Holm-adjusted p-value
#   orthogonalization.csv  each placebo's predictor in the BS regression of
#                          the DI surprise, if any
# Notes: notas/2026-10-09_placebos_holm.md (design),
# notas/2026-10-12_msci_emergentes.md (msci as the index)
# ===================================================================

PRECISION_PATH <- "output/ar_precision/table.csv"
CELL_PATH      <- "output/irf/irf_coherence_cell.rds"
BS_PATH        <- "output/instrument/bs_orthogonalization.csv"
OUT_DIR        <- "output/placebo_holm"
PLACEBOS <- c(
  sp500_vix = "VIX",
  msci = "MSCI emergentes",
  epu_us = "EPU dos EUA"
)
H_TABLE      <- c(0L, 1L, 3L, 6L, 12L, 24L)
FAMILY_LEVEL <- 0.10

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# A. The family of 18 tests ------------------------------------------------

tests <- readr::read_csv(PRECISION_PATH, show_col_types = FALSE) |>
  dplyr::filter(
    cell == "producao",
    variable %in% names(PLACEBOS),
    h %in% H_TABLE
  ) |>
  dplyr::mutate(
    label = PLACEBOS[variable],
    series_order = match(variable, names(PLACEBOS))
  ) |>
  dplyr::arrange(series_order, h)

# Step 1's table is the production cell of the cache, on the current base
cached <- readRDS(CELL_PATH)
cells <- cbind(match(tests$variable, cached$var_names), tests$h + 1L)
stopifnot(
  nrow(tests) == length(PLACEBOS) * length(H_TABLE),
  all(tests$set_type_90 == "interval", tests$set_type_95 == "interval"),
  max(abs(tests$point - cached$irf$irf_point_matrix[cells])) < 1e-12,
  max(abs(tests$lo_90 - cached$irf$ci[["0.90"]]$lower[cells])) < 1e-12,
  max(abs(tests$hi_90 - cached$irf$ci[["0.90"]]$upper[cells])) < 1e-12,
  all((tests$p_value_zero < 0.10) == tests$significant_90),
  all((tests$p_value_zero < 0.05) == tests$significant_95)
)

holm <- tests |>
  dplyr::mutate(
    p_holm = p.adjust(p_value_zero, method = "holm"),
    reject_pointwise_10 = p_value_zero < FAMILY_LEVEL,
    reject_holm_10 = p_holm < FAMILY_LEVEL
  )
stopifnot(all(holm$p_holm >= holm$p_value_zero))

holm |>
  dplyr::select(
    variable, label, h, point, lo_90, hi_90, lo_95, hi_95,
    p_value = p_value_zero, p_holm, reject_pointwise_10, reject_holm_10
  ) |>
  readr::write_csv(file.path(OUT_DIR, "table.csv"))

# B. The placebos in the orthogonalization ----------------------------------

# The VIX enters as its 65-trading-day change to the Wednesday close
# (R/instrument/build_variants.R); the same-session change enters no
# regression. The S&P 500 trend enters too. Neither MSCI nor EPU does.
bs_di <- readr::read_csv(BS_PATH, show_col_types = FALSE) |>
  dplyr::filter(dependent == "delta_di")
predictors <- setdiff(bs_di$term, "(Intercept)")
stopifnot(
  all(c("pre_vix", "pre_sp500") %in% predictors),
  !any(stringr::str_detect(predictors, "msci|epu"))
)

tibble::tibble(
  variable = names(PLACEBOS),
  label = PLACEBOS,
  predictor = c("pre_vix", NA, NA)
) |>
  dplyr::left_join(
    dplyr::select(bs_di, term, estimate, se, t, p),
    by = c("predictor" = "term")
  ) |>
  readr::write_csv(file.path(OUT_DIR, "orthogonalization.csv"))
