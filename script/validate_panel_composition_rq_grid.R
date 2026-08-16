# Validation for the isolated experimental panel-composition r-q grid.

rm(list = ls())

library(readr)
library(dplyr)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")

OUT_DIR <- "output/panel_experimental/rq_grid"
EXPECTED_DATES <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
EXPECTED_GRID <- dplyr::bind_rows(lapply(5:8, function(r) {
  tibble::tibble(r = r, q = 3:r)
}))
EXPECTED_VARIANTS <- c(
  "baseline", "drop_near_duplicates", "add_fiscal", "add_setor_externo",
  "add_expectativas", "add_eua", "add_credito", "add_imoveis", "add_conjunto"
)
EXPECTED_SAMPLES <- c("full", "pre_covid")
P_LAGS <- 6L
MP_VAR <- "yield_6m"
VARIANT <- "z_jk_bs_purif"

cells_path <- file.path(OUT_DIR, "rq_grid_cells.csv")
failures_path <- file.path(OUT_DIR, "rq_grid_failures.csv")
report_path <- file.path(OUT_DIR, "rq_grid_report.md")
if (!all(file.exists(c(cells_path, failures_path, report_path)))) {
  stop("The r-q grid outputs are incomplete. Run script/panel_composition_rq_grid.R first.")
}

cells <- readr::read_csv(cells_path, show_col_types = FALSE)
failures <- readr::read_csv(failures_path, show_col_types = FALSE)
expected_cells <- length(EXPECTED_VARIANTS) * length(EXPECTED_SAMPLES) * nrow(EXPECTED_GRID)
key <- cells |>
  dplyr::select(variant, sample, r, q)
expected_key <- tidyr::crossing(
  variant = EXPECTED_VARIANTS,
  sample = EXPECTED_SAMPLES,
  EXPECTED_GRID
) |>
  dplyr::arrange(variant, sample, r, q)

if (nrow(cells) != expected_cells || anyNA(cells) ||
    any(!is.finite(cells$n_series)) || any(!is.finite(cells$n_months)) ||
    any(!is.finite(cells$n_obs_align)) || any(!is.finite(cells$xi_mp)) ||
    anyDuplicated(key) || any(cells$q > cells$r) || any(cells$p != P_LAGS) ||
    !isTRUE(all.equal(dplyr::arrange(key, variant, sample, r, q), expected_key,
                      check.attributes = FALSE)) ||
    nrow(failures) != 0L) {
  stop("The r-q grid does not contain exactly 324 unique, finite, admissible completed cells.")
}

expected_tables <- as.vector(outer(
  EXPECTED_VARIANTS, EXPECTED_SAMPLES,
  function(variant, sample) file.path(OUT_DIR, "tables", paste0("xi_mp_", variant, "_", sample, ".md"))
))
if (length(expected_tables) != 18L || !all(file.exists(expected_tables))) {
  stop("The r-q grid is missing one or more per-variant/sample markdown tables.")
}

reference <- cells |>
  dplyr::filter(variant == "baseline", r == 7L, q == 6L) |>
  dplyr::arrange(sample)
if (nrow(reference) != 2L ||
    abs(reference$xi_mp[reference$sample == "full"] - 7.65) > 0.01 ||
    abs(reference$xi_mp[reference$sample == "pre_covid"] - 11.53) > 0.01) {
  stop("The saved baseline reference cell does not reproduce xi_mp = 7.65 / 11.53.")
}

base <- readr::read_csv("data/processed/data_log_deseasonalized_base_106.csv", show_col_types = FALSE)
if (!identical(as.Date(base$ref.date), EXPECTED_DATES) || ncol(base) - 1L != 106L ||
    anyNA(base) || any(!is.finite(as.matrix(base[, -1])))) {
  stop("The canonical 106-series panel does not have the fixed complete sample.")
}
dates <- as.Date(base$ref.date)
data_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
instrument <- readr::read_csv("data/processed/instrumentos_mensais.csv", show_col_types = FALSE) |>
  dplyr::transmute(month = as.Date(month), shock = .data[[VARIANT]]) |>
  dplyr::filter(!is.na(shock))
mpind <- match(MP_VAR, colnames(data_mat))

reproduced <- lapply(
  list(full = dates <= as.Date("2025-09-01"), pre_covid = dates <= as.Date("2019-12-01")),
  function(in_window) {
    fit <- estimate_dfm(
      data_mat[in_window, , drop = FALSE], r = 7L, q = 6L, p = P_LAGS,
      dates = dates[in_window], apply_kilian = FALSE
    )
    diagnose_instrument_in_factor_space(
      fit, instrument, dates[in_window], P_LAGS, mpind
    )$wald_mp
  }
)
if (abs(reproduced$full - 7.65) > 0.01 || abs(reproduced$pre_covid - 11.53) > 0.01 ||
    abs(reproduced$full - reference$xi_mp[reference$sample == "full"]) > 1e-10 ||
    abs(reproduced$pre_covid - reference$xi_mp[reference$sample == "pre_covid"]) > 1e-10) {
  stop("Independent baseline reproduction failed for the r-q grid.")
}

message(
  "Experimental r-q grid validation passed: ", expected_cells,
  " complete cells, 18 admissible pairs, and baseline xi_mp = ",
  sprintf("%.2f/%.2f", reproduced$full, reproduced$pre_covid), "."
)
