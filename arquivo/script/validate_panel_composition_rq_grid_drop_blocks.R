# Validation for the factorial experimental panel-composition r-q grid.

rm(list = ls())

source("R/preprocessing/experimental_extensions.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/experimental_panel.R")
source("R/identification/factor_space_diagnostics.R")

OUT_DIR <- "output/panel_experimental/rq_grid_drop_blocks"
PREVIOUS_OUT_DIR <- "output/panel_experimental/rq_grid"
EXPECTED_DATES <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
EXPECTED_GRID <- dplyr::bind_rows(lapply(5:8, function(r) {
  tibble::tibble(r = r, q = 3:r)
}))
EXPECTED_SAMPLES <- c("full", "pre_covid")
P_LAGS <- 6L
MP_VAR <- "yield_6m"
VARIANT <- "z_jk_bs_purif"

cells_path <- file.path(OUT_DIR, "rq_grid_drop_blocks_cells.csv")
failures_path <- file.path(OUT_DIR, "rq_grid_drop_blocks_failures.csv")
manifest_path <- file.path(OUT_DIR, "variant_manifest.csv")
report_path <- file.path(OUT_DIR, "rq_grid_drop_blocks_report.md")
previous_cells_path <- file.path(PREVIOUS_OUT_DIR, "rq_grid_cells.csv")
if (!all(file.exists(c(cells_path, failures_path, manifest_path, report_path, previous_cells_path)))) {
  stop("The factorial r-q grid outputs are incomplete. Run script/panel_composition_rq_grid_drop_blocks.R first.")
}

base <- readr::read_csv("data/processed/data_log_deseasonalized_base_106.csv", show_col_types = FALSE)
if (!identical(as.Date(base$ref.date), EXPECTED_DATES) || ncol(base) - 1L != 106L ||
    anyNA(base) || any(!is.finite(as.matrix(base[, -1])))) {
  stop("The canonical 106-series panel does not have the fixed complete sample.")
}
dates <- as.Date(base$ref.date)
base_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
experimental <- build_factorial_drop_block_panels(base_mat, EXPECTED_DATES, MP_VAR)
expected_manifest <- experimental$variant_manifest
expected_variants <- expected_manifest$variant

cells <- readr::read_csv(cells_path, show_col_types = FALSE)
failures <- readr::read_csv(failures_path, show_col_types = FALSE)
manifest <- readr::read_csv(manifest_path, show_col_types = FALSE)
expected_cells <- length(expected_variants) * length(EXPECTED_SAMPLES) * nrow(EXPECTED_GRID)
key <- cells |>
  dplyr::select(variant, sample, r, q)
expected_key <- tidyr::crossing(
  variant = expected_variants,
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
  stop("The factorial r-q grid does not contain exactly 2,304 unique, finite, admissible completed cells.")
}

if (nrow(manifest) != 64L || anyDuplicated(manifest$variant) ||
    !setequal(manifest$variant, expected_variants) ||
    any(manifest$near_duplicates_absent != TRUE) ||
    any(manifest$near_duplicates_in_panel != "none") ||
    any(manifest$n_series != manifest$expected_n_series) ||
    any(manifest$n_series != 123L - vapply(
      strsplit(manifest$removed_candidate_series, ";", fixed = TRUE),
      function(series) if (identical(series, "none")) 0L else length(series),
      integer(1)
    )) ||
    any(manifest$n_series < 104L) || any(manifest$n_series > 123L)) {
  stop("The factorial manifest has invalid series counts or does not exclude both near-duplicates everywhere.")
}

for (variant in expected_variants) {
  panel_names <- colnames(experimental$panels[[variant]]$matrix)
  if (any(c("juros_cdi", "asset_mlcx") %in% panel_names)) {
    stop("The in-memory factorial panel retains a near-duplicate: ", variant, ".")
  }
}

expected_tables <- as.vector(outer(
  expected_variants, EXPECTED_SAMPLES,
  function(variant, sample) file.path(OUT_DIR, "tables", paste0("xi_mp_", variant, "_", sample, ".md"))
))
if (length(expected_tables) != 128L || !all(file.exists(expected_tables))) {
  stop("The factorial r-q grid is missing one or more per-variant/sample markdown tables.")
}

previous_cells <- readr::read_csv(previous_cells_path, show_col_types = FALSE) |>
  dplyr::filter(variant == "drop_near_duplicates", r == 7L, q == 6L) |>
  dplyr::select(sample, previous_xi_mp = xi_mp)
baseline <- cells |>
  dplyr::filter(variant == "baseline", r == 7L, q == 6L) |>
  dplyr::select(sample, xi_mp)
baseline_comparison <- dplyr::inner_join(baseline, previous_cells, by = "sample")
if (nrow(baseline_comparison) != 2L ||
    any(abs(baseline_comparison$xi_mp - baseline_comparison$previous_xi_mp) > 1e-10)) {
  stop("The factorial baseline does not reproduce the previous drop_near_duplicates (7,6,6) cells.")
}

instrument <- readr::read_csv("data/processed/instrumentos_mensais.csv", show_col_types = FALSE) |>
  dplyr::transmute(month = as.Date(month), shock = .data[[VARIANT]]) |>
  dplyr::filter(!is.na(shock))
complete_panel <- experimental$panels[["conjunto_completo_sem_duplicatas"]]$matrix
mpind <- match(MP_VAR, colnames(complete_panel))
reproduced_complete <- lapply(
  list(full = dates <= as.Date("2025-09-01"), pre_covid = dates <= as.Date("2019-12-01")),
  function(in_window) {
    fit <- estimate_dfm(
      complete_panel[in_window, , drop = FALSE], r = 7L, q = 6L, p = P_LAGS,
      dates = dates[in_window], apply_kilian = FALSE
    )
    diagnose_instrument_in_factor_space(
      fit, instrument, dates[in_window], P_LAGS, mpind
    )$wald_mp
  }
)
saved_complete <- cells |>
  dplyr::filter(variant == "conjunto_completo_sem_duplicatas", r == 7L, q == 6L) |>
  dplyr::arrange(sample)
if (nrow(saved_complete) != 2L ||
    abs(reproduced_complete$full - saved_complete$xi_mp[saved_complete$sample == "full"]) > 1e-10 ||
    abs(reproduced_complete$pre_covid - saved_complete$xi_mp[saved_complete$sample == "pre_covid"]) > 1e-10) {
  stop("Independent in-memory reproduction failed for the complete non-duplicate panel.")
}

message(
  "Factorial experimental r-q grid validation passed: ", expected_cells,
  " complete cells, 64 panels without near-duplicates, and exact reproduction of the previous baseline."
)
