# Independent boundary validation for the joint panel and dimension audit.

source("R/preprocessing/experimental_extensions.R")
source("R/modeling/impulse_response.R")
source("R/identification/experimental_panel.R")

out_dir <- "diagnostics/rq_block_dimension_audit/output"
required <- c(
  "full_grid_cells.csv",
  "full_grid_irfs.csv",
  "full_grid_failures.csv",
  "panel_manifest.csv",
  "prior_grid_reproduction.csv",
  "panel_dimension_ranking.csv",
  "panel_dimension_decisions.csv",
  "selected_pre_covid_cells.csv",
  "selected_pre_covid_irfs.csv",
  "block_contrasts.csv",
  "block_decisions.csv",
  "bootstrap_finalists.csv",
  "bootstrap_irfs.csv",
  "bootstrap_metadata.csv",
  "bootstrap_gate.csv",
  "final_decision.csv",
  "audit_report.md"
)
if (!all(file.exists(file.path(out_dir, required)))) {
  stop("The joint audit outputs are incomplete.")
}

cells <- readr::read_csv(file.path(out_dir, "full_grid_cells.csv"), show_col_types = FALSE)
irfs <- readr::read_csv(file.path(out_dir, "full_grid_irfs.csv"), show_col_types = FALSE)
failures <- readr::read_csv(file.path(out_dir, "full_grid_failures.csv"), show_col_types = FALSE)
manifest <- readr::read_csv(file.path(out_dir, "panel_manifest.csv"), show_col_types = FALSE)
reproduction <- readr::read_csv(file.path(out_dir, "prior_grid_reproduction.csv"), show_col_types = FALSE)
ranking <- readr::read_csv(file.path(out_dir, "panel_dimension_ranking.csv"), show_col_types = FALSE)
decisions <- readr::read_csv(file.path(out_dir, "panel_dimension_decisions.csv"), show_col_types = FALSE)
pre_cells <- readr::read_csv(file.path(out_dir, "selected_pre_covid_cells.csv"), show_col_types = FALSE)
pre_irfs <- readr::read_csv(file.path(out_dir, "selected_pre_covid_irfs.csv"), show_col_types = FALSE)
contrasts <- readr::read_csv(file.path(out_dir, "block_contrasts.csv"), show_col_types = FALSE)
blocks <- readr::read_csv(file.path(out_dir, "block_decisions.csv"), show_col_types = FALSE)
finalists <- readr::read_csv(file.path(out_dir, "bootstrap_finalists.csv"), show_col_types = FALSE)
bootstrap_irfs <- readr::read_csv(file.path(out_dir, "bootstrap_irfs.csv"), show_col_types = FALSE)
bootstrap_metadata <- readr::read_csv(file.path(out_dir, "bootstrap_metadata.csv"), show_col_types = FALSE)
bootstrap_gate <- readr::read_csv(file.path(out_dir, "bootstrap_gate.csv"), show_col_types = FALSE)
final <- readr::read_csv(file.path(out_dir, "final_decision.csv"), show_col_types = FALSE)

expected_grid <- dplyr::bind_rows(lapply(1:8, function(r) {
  tibble::tibble(r = r, q = seq_len(r))
}))
expected_key <- tidyr::crossing(variant = sort(unique(cells$variant)), expected_grid) |>
  dplyr::arrange(variant, r, q)
if (nrow(cells) != 2304L || length(unique(cells$variant)) != 64L ||
    anyDuplicated(cells[c("variant", "r", "q")]) ||
    !isTRUE(all.equal(cells[c("variant", "r", "q")], expected_key, check.attributes = FALSE)) ||
    any(cells$n_series < 104L) || any(cells$n_series > 123L) ||
    any(cells$n_months != 153L) || any(cells$p != 6L) ||
    any(!is.finite(as.matrix(cells[c("xi_mp", "f_robust_mp", "max_companion_root")]))) ||
    nrow(irfs) != 2304L * 5L * 7L || any(!is.finite(irfs$point)) ||
    nrow(failures) != 0L || nrow(manifest) != 64L || anyDuplicated(manifest$variant) ||
    any(manifest$expected_n_series < 104L) || any(manifest$expected_n_series > 123L)) {
  stop("The full grid coverage or finite-value invariants failed.")
}
if (nrow(reproduction) != 1152L || any(reproduction$old_grid_xi_difference > 1e-10)) {
  stop("Prior-grid reproduction failed.")
}
if (nrow(decisions) != 64L || anyDuplicated(decisions$variant) ||
    nrow(pre_cells) != 64L || anyDuplicated(pre_cells$variant) ||
    nrow(pre_irfs) != 64L * 5L * 7L ||
    sum(ranking$admissible_rank == 1L, na.rm = TRUE) != 64L) {
  stop("The per-panel full choice or pre-COVID diagnostic is incomplete.")
}
if (nrow(blocks) != 6L || any(blocks$contrasts != 32L) ||
    nrow(contrasts) != 192L ||
    any(table(contrasts$block) != 32L) ||
    any(contrasts$exclusion_wins & contrasts$inclusion_wins)) {
  stop("The six block decisions do not each contain 32 valid matched contrasts.")
}

expected_dates <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
base <- readr::read_csv(
  "data/processed/data_log_deseasonalized_base_106.csv",
  show_col_types = FALSE
)
base_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
experimental <- build_factorial_drop_block_panels(base_mat, expected_dates, "yield_6m")
if (nrow(experimental$variant_manifest) != 64L) {
  stop("The in-memory factorial design no longer contains 64 panels.")
}
for (variant in names(experimental$panels)) {
  names_in_panel <- colnames(experimental$panels[[variant]]$matrix)
  if (length(names_in_panel) < 104L || length(names_in_panel) > 123L ||
      any(c("juros_cdi", "asset_mlcx") %in% names_in_panel) ||
      !("yield_6m" %in% names_in_panel)) {
    stop("Invalid in-memory panel composition: ", variant, ".")
  }
}

if (nrow(bootstrap_metadata) != nrow(finalists) ||
    nrow(bootstrap_irfs) != nrow(finalists) * 5L * 49L ||
    nrow(bootstrap_gate) != nrow(finalists) ||
    any(bootstrap_metadata$bootstrap_failures != 0L) ||
    any(bootstrap_metadata$nboot != 800L) ||
    any(bootstrap_metadata$bootstrap_seed != 123L) ||
    any(!bootstrap_metadata$stable) ||
    any(bootstrap_metadata$max_companion_root >= 1) ||
    !all(bootstrap_gate$bootstrap_gate_pass)) {
  stop("One or more finalist bootstrap checks failed.")
}
point_reproduction <- bootstrap_irfs |>
  dplyr::filter(h <= 6L) |>
  dplyr::inner_join(
    irfs |>
      dplyr::rename(grid_point = point),
    by = c("variant", "r", "q", "variable", "h")
  ) |>
  dplyr::mutate(absolute_difference = abs(point - grid_point))
root_reproduction <- bootstrap_metadata |>
  dplyr::inner_join(
    cells |>
      dplyr::select(variant, r, q, grid_root = max_companion_root),
    by = c("variant", "r", "q")
  ) |>
  dplyr::mutate(absolute_difference = abs(max_companion_root - grid_root))
if (nrow(point_reproduction) != nrow(finalists) * 5L * 7L ||
    max(point_reproduction$absolute_difference) > 1e-10 ||
    nrow(root_reproduction) != nrow(finalists) ||
    max(root_reproduction$absolute_difference) > 1e-10) {
  stop("The finalist point IRFs or roots do not reproduce the full grid at 1e-10.")
}
normalization <- bootstrap_irfs |>
  dplyr::filter(variable == "yield_6m", h == 0L)
if (nrow(normalization) != nrow(finalists) ||
    any(abs(as.matrix(normalization[c("point", "lo68", "hi68", "lo90", "hi90")]) - 0.005) > 1e-12)) {
  stop("The +50 bp normalization is not exact across finalist bands.")
}
if (nrow(final) != 1L || final$accepted_rank > 2L || final$n_finalists != nrow(finalists)) {
  stop("The final decision is not uniquely supported by the declared finalists.")
}

message(
  "Joint audit validation passed: 64 panels, 2,304 full cells, 64 selected pre-COVID cells, ",
  "192 contrasts, and ", nrow(finalists),
  " zero-failure finalist bootstraps with exact point reproduction."
)
