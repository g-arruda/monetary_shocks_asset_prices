# Consolidate the full grid, select one dimension per panel, and compare blocks.

source("R/data_download/panel_candidates.R")
source("R/preprocessing/panel_candidates.R")
source("R/modeling/factor_estimation.R")
source("diagnostics/rq_block_dimension_audit/scripts/scalar_dynamic_factor_compat.R")
source("R/modeling/impulse_response.R")
source("R/identification/experimental_panel.R")
source("R/identification/factor_space_diagnostics.R")

audit_dir <- "diagnostics/rq_block_dimension_audit"
out_dir <- file.path(audit_dir, "output")
shard_dir <- file.path(out_dir, "grid_shards")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

metric_files <- list.files(shard_dir, pattern = "_metrics\\.csv$", full.names = TRUE)
irf_files <- list.files(shard_dir, pattern = "_irfs\\.csv$", full.names = TRUE)
failure_files <- list.files(shard_dir, pattern = "_failures\\.csv$", full.names = TRUE)
if (length(metric_files) == 0L || length(metric_files) != length(irf_files) ||
    length(metric_files) != length(failure_files)) {
  stop("The grid shards are incomplete or mismatched.")
}

metrics <- dplyr::bind_rows(lapply(metric_files, readr::read_csv, show_col_types = FALSE)) |>
  dplyr::arrange(variant, r, q)
full_irfs <- dplyr::bind_rows(lapply(irf_files, readr::read_csv, show_col_types = FALSE)) |>
  dplyr::arrange(variant, r, q, variable, h)
failures <- dplyr::bind_rows(lapply(failure_files, readr::read_csv, show_col_types = FALSE))
if (nrow(failures) == 0L) {
  failures <- tibble::tibble(
    variant = character(),
    r = integer(),
    q = integer(),
    p = integer(),
    failure = character()
  )
}

expected_grid <- dplyr::bind_rows(lapply(1:8, function(r) {
  tibble::tibble(r = r, q = seq_len(r))
}))
expected_key <- tidyr::crossing(variant = unique(metrics$variant), expected_grid) |>
  dplyr::arrange(variant, r, q)
if (nrow(metrics) != 2304L || nrow(full_irfs) != 2304L * 5L * 7L ||
    nrow(failures) != 0L || length(unique(metrics$variant)) != 64L ||
    anyDuplicated(metrics[c("variant", "r", "q")]) ||
    anyDuplicated(full_irfs[c("variant", "r", "q", "variable", "h")]) ||
    !isTRUE(all.equal(metrics[c("variant", "r", "q")], expected_key, check.attributes = FALSE)) ||
    any(!is.finite(metrics$xi_mp)) || any(!is.finite(full_irfs$point))) {
  stop("The consolidated full grid must contain exactly 2,304 complete unique cells and 80,640 IRF points.")
}

reproduction <- metrics |>
  dplyr::filter(old_grid_reused) |>
  dplyr::select(variant, r, q, xi_mp, xi_mp_reestimated, old_grid_xi_difference)
if (nrow(reproduction) != 1152L ||
    any(reproduction$old_grid_xi_difference > 1e-10)) {
  stop("The 1,152 cells shared with the prior grid were not reproduced at 1e-10.")
}

factor_selection <- readr::read_csv(
  "output/panel_experimental/rq_grid_drop_blocks/factor_selection/factor_selection_cells.csv",
  show_col_types = FALSE
) |>
  dplyr::filter(sample == "full") |>
  dplyr::select(variant, bll_r = r_ic2, bll_q = q_aw_ic2)
if (nrow(factor_selection) != 64L || anyDuplicated(factor_selection$variant)) {
  stop("The full-sample BLL/AW input must contain one selection for each panel.")
}

sign_rules <- tibble::tribble(
  ~variable, ~expected_sign,
  "yield_6m", 1,
  "yield_2y", 1,
  "yield_5y", 1,
  "asset_ibov", -1
)
sign_scores <- full_irfs |>
  dplyr::inner_join(sign_rules, by = "variable") |>
  dplyr::group_by(variant, r, q) |>
  dplyr::summarise(
    correct_signs_full = sum(sign(point) == expected_sign),
    sign_errors_full = sum(sign(point) != expected_sign),
    .groups = "drop"
  )

ranking <- metrics |>
  dplyr::left_join(factor_selection, by = "variant") |>
  dplyr::left_join(sign_scores, by = c("variant", "r", "q")) |>
  dplyr::mutate(
    bll_distance_full = abs(r - bll_r) + abs(q - bll_q),
    admissible_full = is.finite(xi_mp) & is.finite(max_companion_root) &
      stable & max_companion_root < 1 & xi_mp > 3.84
  ) |>
  dplyr::group_by(variant) |>
  dplyr::arrange(
    dplyr::desc(admissible_full),
    bll_distance_full,
    max_companion_root,
    dplyr::desc(correct_signs_full),
    r,
    q,
    .by_group = TRUE
  ) |>
  dplyr::mutate(
    admissible_rank = dplyr::if_else(
      admissible_full,
      cumsum(admissible_full),
      NA_integer_
    )
  ) |>
  dplyr::ungroup()

selected_full <- ranking |>
  dplyr::filter(admissible_rank == 1L) |>
  dplyr::arrange(variant)
if (nrow(selected_full) != 64L || anyDuplicated(selected_full$variant)) {
  stop("Every panel must have exactly one admissible selected full-sample dimension.")
}

expected_dates <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
base <- readr::read_csv(
  "data/processed/data_log_deseasonalized_base_106.csv",
  show_col_types = FALSE
)
dates <- as.Date(base$ref.date)
base_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
experimental <- build_factorial_drop_block_panels(base_mat, expected_dates, "yield_6m")
manifest <- experimental$variant_manifest
instrument <- readr::read_csv(
  "data/processed/instrumentos_mensais.csv",
  show_col_types = FALSE
) |>
  dplyr::transmute(month = as.Date(month), shock = z_jk_bs_purif) |>
  dplyr::filter(!is.na(shock))
pre_window <- dates <= as.Date("2019-12-01")
pre_dates <- dates[pre_window]
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")

#' Estimate the pre-COVID diagnostic for a panel's full-sample choice
#'
#' @param selection One selected-full row.
#'
#' @return List with one metric row and the five short IRFs.
estimate_pre_covid_choice <- function(selection) {
  variant <- selection$variant[[1]]
  r <- selection$r[[1]]
  q <- selection$q[[1]]
  panel <- experimental$panels[[variant]]$matrix[pre_window, , drop = FALSE]
  var_names <- colnames(panel)
  mpind <- match("yield_6m", var_names)
  tcodes <- infer_tcode_from_varnames(var_names)
  candidate_index <- match(names(experimental$candidate_inputs$tcodes), var_names)
  present <- !is.na(candidate_index)
  tcodes[candidate_index[present]] <- experimental$candidate_inputs$tcodes[present]

  dfm <- estimate_dfm(
    panel,
    r = r,
    q = q,
    p = 6L,
    dates = pre_dates,
    apply_kilian = FALSE
  )
  diagnostic <- diagnose_instrument_in_factor_space(
    dfm,
    instrument,
    pre_dates,
    p = 6L,
    mp_var_idx = mpind
  )
  irf <- compute_irf_dfm(
    dfm,
    instrument = instrument,
    h = 6L,
    nboot = 0L,
    bootstrap_seed = 123L,
    mpind = mpind,
    normalize_value = 0.005,
    data_dates = pre_dates,
    tcode = tcodes,
    ci_levels = c(0.68, 0.90),
    var_names = var_names,
    identification = "proxy"
  )
  metrics <- tibble::tibble(
    variant = variant,
    r = r,
    q = q,
    p = 6L,
    n_series = ncol(panel),
    n_months = nrow(panel),
    n_obs_align = diagnostic$n_obs,
    xi_mp_pre_covid = diagnostic$wald_mp,
    f_robust_mp_pre_covid = diagnostic$f_robust_mp,
    max_companion_root_pre_covid = dfm$diagnostics$max_eigenvalue,
    stable_pre_covid = dfm$diagnostics$is_stable
  )
  irfs <- dplyr::bind_rows(lapply(headline, function(variable) {
    variable_index <- match(variable, var_names)
    tibble::tibble(
      variant = variant,
      r = r,
      q = q,
      variable = variable,
      h = 0:6,
      point_pre_covid = irf$irf_point_matrix[variable_index, ]
    )
  }))
  if (any(!is.finite(as.matrix(metrics[c(
    "xi_mp_pre_covid", "f_robust_mp_pre_covid", "max_companion_root_pre_covid"
  )]))) ||
      any(!is.finite(irfs$point_pre_covid))) {
    stop("The selected pre-COVID cell is non-finite: ", variant, ".")
  }
  list(metrics = metrics, irfs = irfs)
}

pre_results <- lapply(seq_len(nrow(selected_full)), function(index) {
  selection <- selected_full[index, ]
  message(
    "pre-COVID selected cell ", index, "/64: ", selection$variant,
    " (", selection$r, ",", selection$q, ")"
  )
  estimate_pre_covid_choice(selection)
})
pre_metrics <- dplyr::bind_rows(lapply(pre_results, `[[`, "metrics"))
pre_irfs <- dplyr::bind_rows(lapply(pre_results, `[[`, "irfs"))
if (nrow(pre_metrics) != 64L || nrow(pre_irfs) != 64L * 5L * 7L ||
    anyDuplicated(pre_metrics$variant) ||
    anyDuplicated(pre_irfs[c("variant", "variable", "h")])) {
  stop("The pre-COVID diagnostic must contain exactly 64 selected cells.")
}

selected_irfs <- full_irfs |>
  dplyr::inner_join(
    selected_full |>
      dplyr::select(variant, r, q),
    by = c("variant", "r", "q")
  ) |>
  dplyr::inner_join(pre_irfs, by = c("variant", "r", "q", "variable", "h"))
variable_stability <- selected_irfs |>
  dplyr::group_by(variant, r, q, variable) |>
  dplyr::summarise(
    rmse = sqrt(mean((point - point_pre_covid)^2)),
    full_rms = sqrt(mean(point^2)),
    normalized_rmse = rmse / full_rms,
    sign_agreement = mean(sign(point) == sign(point_pre_covid)),
    .groups = "drop"
  )
if (any(!is.finite(variable_stability$normalized_rmse))) {
  stop("Normalized RMSE is undefined for one or more selected IRFs.")
}
stability <- variable_stability |>
  dplyr::group_by(variant, r, q) |>
  dplyr::summarise(
    normalized_rmse = mean(normalized_rmse),
    sign_agreement = mean(sign_agreement),
    .groups = "drop"
  )

panel_decisions <- selected_full |>
  dplyr::left_join(
    pre_metrics,
    by = c("variant", "r", "q", "p", "n_series"),
    suffix = c("_full", "_pre_covid")
  ) |>
  dplyr::left_join(stability, by = c("variant", "r", "q")) |>
  dplyr::left_join(
    manifest |>
      dplyr::select(variant, removed_blocks, n_blocks_removed),
    by = "variant"
  ) |>
  dplyr::mutate(
    xi_gt_3_84_pre_covid = xi_mp_pre_covid > 3.84,
    parsimony = r + q
  ) |>
  dplyr::arrange(variant)

blocks <- unique(unname(experimental$candidate_inputs$blocks))
block_state <- tidyr::crossing(variant = manifest$variant, block = blocks) |>
  dplyr::left_join(manifest[c("variant", "removed_blocks")], by = "variant") |>
  dplyr::mutate(
    excluded = vapply(
      seq_len(dplyr::n()),
      function(index) {
        removed <- strsplit(removed_blocks[index], ";", fixed = TRUE)[[1]]
        block[index] %in% removed
      },
      logical(1)
    ),
    other_blocks = vapply(
      seq_len(dplyr::n()),
      function(index) {
        removed <- strsplit(removed_blocks[index], ";", fixed = TRUE)[[1]]
        paste(sort(setdiff(removed[removed != "none"], block[index])), collapse = ";")
      },
      character(1)
    )
  )

paired_states <- block_state |>
  dplyr::select(variant, block, excluded, other_blocks) |>
  tidyr::pivot_wider(names_from = excluded, values_from = variant, names_prefix = "excluded_") |>
  dplyr::rename(included_variant = excluded_FALSE, excluded_variant = excluded_TRUE)
if (nrow(paired_states) != 192L || anyNA(paired_states)) {
  stop("Each of the six blocks must have exactly 32 matched panel contrasts.")
}

comparison_data <- panel_decisions |>
  dplyr::select(
    variant,
    bll_distance_full,
    max_companion_root,
    xi_gt_3_84_pre_covid,
    normalized_rmse,
    sign_errors_full,
    parsimony
  )
contrasts <- paired_states |>
  dplyr::left_join(comparison_data, by = c("included_variant" = "variant")) |>
  dplyr::left_join(
    comparison_data,
    by = c("excluded_variant" = "variant"),
    suffix = c("_included", "_excluded")
  )

# Root differences below 0.001 and relative RMSE differences below 5% are ties.
contrasts <- contrasts |>
  dplyr::mutate(
    distance_cmp = sign(bll_distance_full_included - bll_distance_full_excluded),
    root_cmp = dplyr::if_else(
      abs(max_companion_root_included - max_companion_root_excluded) < 0.001,
      0,
      sign(max_companion_root_included - max_companion_root_excluded)
    ),
    pre_relevance_cmp = sign(
      as.integer(xi_gt_3_84_pre_covid_excluded) -
        as.integer(xi_gt_3_84_pre_covid_included)
    ),
    rmse_cmp = dplyr::if_else(
      abs(normalized_rmse_included - normalized_rmse_excluded) /
        pmin(normalized_rmse_included, normalized_rmse_excluded) < 0.05,
      0,
      sign(normalized_rmse_included - normalized_rmse_excluded)
    ),
    sign_errors_cmp = sign(sign_errors_full_included - sign_errors_full_excluded),
    parsimony_cmp = sign(parsimony_included - parsimony_excluded),
    exclusion_improvements = rowSums(dplyr::across(dplyr::ends_with("_cmp")) > 0),
    exclusion_worsenings = rowSums(dplyr::across(dplyr::ends_with("_cmp")) < 0),
    exclusion_wins = exclusion_improvements >= 4L & exclusion_worsenings <= 1L,
    inclusion_wins = exclusion_worsenings >= 4L & exclusion_improvements <= 1L
  ) |>
  dplyr::arrange(block, other_blocks)

block_decisions <- contrasts |>
  dplyr::group_by(block) |>
  dplyr::summarise(
    contrasts = dplyr::n(),
    unresolved = sum(!exclusion_wins & !inclusion_wins),
    exclusion_wins = sum(exclusion_wins),
    inclusion_wins = sum(inclusion_wins),
    remove_block = exclusion_wins >= 24L & inclusion_wins <= 8L,
    .groups = "drop"
  ) |>
  dplyr::mutate(
    distance_to_flip = dplyr::if_else(
      remove_block,
      pmin(exclusion_wins - 23L, 9L - inclusion_wins),
      pmax(24L - exclusion_wins, inclusion_wins - 8L)
    )
  ) |>
  dplyr::arrange(match(block, blocks))

removed_final <- block_decisions$block[block_decisions$remove_block]
final_variant <- manifest$variant[vapply(
  strsplit(manifest$removed_blocks, ";", fixed = TRUE),
  function(removed) setequal(removed[removed != "none"], removed_final),
  logical(1)
)]
if (length(final_variant) != 1L) {
  stop("The six block decisions do not map uniquely to a factorial panel.")
}
closest_block <- block_decisions |>
  dplyr::arrange(distance_to_flip, match(block, blocks)) |>
  dplyr::slice(1) |>
  dplyr::pull(block)
alternative_removed <- if (closest_block %in% removed_final) {
  setdiff(removed_final, closest_block)
} else {
  c(removed_final, closest_block)
}
alternative_variant <- manifest$variant[vapply(
  strsplit(manifest$removed_blocks, ";", fixed = TRUE),
  function(removed) setequal(removed[removed != "none"], alternative_removed),
  logical(1)
)]
if (length(alternative_variant) != 1L) {
  stop("The closest-threshold block inversion does not map uniquely to a panel.")
}

final_ranking <- ranking |>
  dplyr::filter(variant == final_variant, admissible_full) |>
  dplyr::arrange(admissible_rank)
alternative_choice <- selected_full |>
  dplyr::filter(variant == alternative_variant)
finalists <- dplyr::bind_rows(
  final_ranking |>
    dplyr::filter(admissible_rank == 1L) |>
    dplyr::transmute(role = "final_panel_selected_dimension", variant, r, q),
  final_ranking |>
    dplyr::filter(admissible_rank == 2L) |>
    dplyr::transmute(role = "final_panel_second_dimension", variant, r, q),
  tibble::tibble(role = "final_panel_r7q6", variant = final_variant, r = 7L, q = 6L),
  alternative_choice |>
    dplyr::transmute(role = "closest_block_inversion", variant, r, q)
) |>
  dplyr::group_by(variant, r, q) |>
  dplyr::summarise(role = paste(role, collapse = ";"), .groups = "drop") |>
  dplyr::arrange(variant, r, q)
if (nrow(finalists) < 2L || nrow(finalists) > 4L) {
  stop("The deduplicated finalist set must contain between two and four cells.")
}

joint_decision <- tibble::tibble(
  final_variant = final_variant,
  final_r = final_ranking$r[1],
  final_q = final_ranking$q[1],
  removed_blocks = if (length(removed_final) == 0L) "none" else paste(removed_final, collapse = ";"),
  closest_threshold_block = closest_block,
  alternative_variant = alternative_variant,
  n_finalists = nrow(finalists)
)

readr::write_csv(metrics, file.path(out_dir, "full_grid_cells.csv"))
readr::write_csv(full_irfs, file.path(out_dir, "full_grid_irfs.csv"))
readr::write_csv(failures, file.path(out_dir, "full_grid_failures.csv"))
readr::write_csv(manifest, file.path(out_dir, "panel_manifest.csv"))
readr::write_csv(reproduction, file.path(out_dir, "prior_grid_reproduction.csv"))
readr::write_csv(ranking, file.path(out_dir, "panel_dimension_ranking.csv"))
readr::write_csv(panel_decisions, file.path(out_dir, "panel_dimension_decisions.csv"))
readr::write_csv(pre_metrics, file.path(out_dir, "selected_pre_covid_cells.csv"))
readr::write_csv(pre_irfs, file.path(out_dir, "selected_pre_covid_irfs.csv"))
readr::write_csv(variable_stability, file.path(out_dir, "selected_irf_stability_by_variable.csv"))
readr::write_csv(contrasts, file.path(out_dir, "block_contrasts.csv"))
readr::write_csv(block_decisions, file.path(out_dir, "block_decisions.csv"))
readr::write_csv(finalists, file.path(out_dir, "bootstrap_finalists.csv"))
readr::write_csv(joint_decision, file.path(out_dir, "joint_decision.csv"))

message(
  "Joint point decision: ", final_variant, " (", final_ranking$r[1], ",",
  final_ranking$q[1], "); closest block = ", closest_block, "."
)
