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
#   C. The BS regression of the DI surprise with the pre-event trend of the
#      daily US EPU added, as on branch feature/placebo-epu: the t test of
#      its coefficient (the p = 0.54 of the 102 meetings, e-mail of 03-10).
#   D. How much of the month of the VIX's h0 response falls inside the
#      window of its pre-event trend in the orthogonalization.
# The IRFs are not re-estimated. script/irf_coherence_check.R,
# script/ar_precision.R and script/instrument.R must run first; the
# production point and 90% sets of step 1's table are checked against the
# cache, and the BS regression against bs_orthogonalization.csv.
# Outputs: output/placebo_holm/
#   table.csv              the 18 tests: point, pointwise 90 and 95% sets,
#                          p-value and the Holm-adjusted p-value
#   orthogonalization.csv  each placebo's predictor in the BS regression of
#                          the DI surprise, if any
#   epu_predictive.csv     the EPU trend's coefficient, HC1 t test, R2 with
#                          and without it
#   vix_h0_overlap.csv     by meeting, the share of the instrument month's
#                          calendar days up to the Wednesday close
# Notes: notas/2026-10-09_placebos_holm.md (design),
# notas/2026-10-12_msci_emergentes.md (msci as the index),
# notas/2026-10-22_placebos_secao_5.md (C and D on the 111 meetings)
# ===================================================================

PRECISION_PATH <- "output/ar_precision/table.csv"
CELL_PATH      <- "output/irf/irf_coherence_cell.rds"
BS_PATH        <- "output/instrument/bs_orthogonalization.csv"
EVENTS_PATH    <- "data/processed/copom_event_diagnostics.csv"
EPU_PATH       <- "data/raw/epu/us_daily_policy_uncertainty.csv"
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

# C. The US EPU trend in the BS regression -----------------------------------

# The index counts newspaper articles, so a single day is noise: the trend
# compares the mean over the 91 calendar days (~65 trading days) ending on
# the Wednesday with the mean over the 91 days before them
epu_daily <- readr::read_csv(EPU_PATH, show_col_types = FALSE) |>
  dplyr::arrange(date)
stopifnot(all(diff(epu_daily$date) == 1))

epu_trend <- epu_daily |>
  dplyr::mutate(
    mean_91d = (cumsum(epu) - dplyr::lag(cumsum(epu), 91)) / 91,
    pre_epu = 100 * (log(mean_91d) - log(dplyr::lag(mean_91d, 91)))
  ) |>
  dplyr::select(wednesday = date, pre_epu)

events <- readr::read_csv(EVENTS_PATH, show_col_types = FALSE) |>
  dplyr::left_join(epu_trend, by = "wednesday")

# The regression without the EPU must be production's, sample included
fit_bs <- lm(
  reformulate(predictors, "delta_di"),
  data = events,
  na.action = na.fail
)
fit_epu <- lm(
  reformulate(c(predictors, "pre_epu"), "delta_di"),
  data = events,
  na.action = na.fail
)
stopifnot(max(abs(coef(fit_bs)[bs_di$term] - bs_di$estimate)) < 1e-10)

lmtest::coeftest(fit_epu, vcov = sandwich::vcovHC(fit_epu, type = "HC1"))[, ] |>
  tibble::as_tibble(rownames = "term") |>
  purrr::set_names(c("term", "estimate", "se", "t", "p")) |>
  dplyr::filter(term == "pre_epu") |>
  dplyr::mutate(
    n = nobs(fit_epu),
    r2 = summary(fit_epu)$r.squared,
    r2_without = summary(fit_bs)$r.squared
  ) |>
  readr::write_csv(file.path(OUT_DIR, "epu_predictive.csv"))

# D. The VIX at h0 against the window of pre_vix ----------------------------

# The panel's VIX is the month-end close, so its h0 response covers the month
# of the instrument. That month's days up to the Wednesday close fall inside
# the 65-trading-day window of pre_vix; a Wednesday in the month before
# overlaps nothing.
events |>
  dplyr::transmute(
    wednesday,
    date,
    month = lubridate::floor_date(date, "month"),
    overlap = dplyr::if_else(
      lubridate::floor_date(wednesday, "month") == month,
      lubridate::day(wednesday) / unname(lubridate::days_in_month(date)),
      0
    )
  ) |>
  readr::write_csv(file.path(OUT_DIR, "vix_h0_overlap.csv"))
