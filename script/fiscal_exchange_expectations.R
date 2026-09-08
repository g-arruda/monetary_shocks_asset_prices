rm(list = ls())

source("R/modeling/production_spec.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")
source("R/preprocessing/experimental_extensions.R")

spec <- production_spec()
out_dir <- "output/fiscal_exchange_expectations"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

expected_dates <- seq(spec$sample[1], spec$sample[2], by = "month")
panel <- readr::read_csv(spec$data_path, show_col_types = FALSE) |>
  dplyr::mutate(ref.date = as.Date(ref.date))
focus <- readr::read_csv(
  "data/raw/focus_fiscal_expectations.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(ref.date = as.Date(ref.date))
instrument <- readr::read_csv(spec$instrument_path, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))
instrument_strength <- instrument |>
  dplyr::transmute(month, shock = .data[[spec$instrument]]) |>
  dplyr::filter(!is.na(shock))

expectation_names <- c(
  "expect_focus_fiscal_dlsp_ny",
  "expect_focus_fiscal_primary_balance_ny",
  "expect_focus_fiscal_nominal_balance_ny"
)
if (!identical(panel$ref.date, expected_dates) ||
    !identical(focus$ref.date, expected_dates) ||
    ncol(panel) - 1L != spec$n_series ||
    anyDuplicated(panel$ref.date) || anyDuplicated(focus$ref.date) ||
    any(!is.finite(as.matrix(panel[, -1]))) ||
    any(!is.finite(as.matrix(focus[, expectation_names])))) {
  stop("The baseline and Focus inputs must be complete finite 153-month samples.")
}

raw_dlsp <- suppressMessages(readxl::read_excel(
  "data/raw/DLSP/Evodlp.xlsx",
  sheet = "Fluxos mensais",
  col_names = FALSE,
  .name_repair = "minimal"
))
month_numbers <- c(
  janeiro = 1L, fevereiro = 2L, "março" = 3L, abril = 4L,
  maio = 5L, junho = 6L, julho = 7L, agosto = 8L, setembro = 9L,
  outubro = 10L, novembro = 11L, dezembro = 12L
)
headers <- tibble::tibble(
  column = seq_len(ncol(raw_dlsp)),
  year = suppressWarnings(as.integer(as.character(unlist(raw_dlsp[5, ])))),
  month_name = tolower(as.character(unlist(raw_dlsp[7, ])))
) |>
  tidyr::fill(year, .direction = "down") |>
  dplyr::mutate(month = unname(month_numbers[month_name])) |>
  dplyr::filter(!is.na(year), !is.na(month)) |>
  dplyr::mutate(ref.date = as.Date(sprintf("%04d-%02d-01", year, month)))

exchange_labels <- c(
  dlsp_exchange_adjustment = "Ajuste cambial",
  dlsp_fx_internal_indexed = "Dívida interna indexada ao câmbio",
  dlsp_fx_external_methodological = "Dívida externa - metodológico"
)
exchange_rows <- match(unname(exchange_labels), as.character(raw_dlsp[[1]]))
if (anyNA(exchange_rows) || anyDuplicated(exchange_rows)) {
  stop("The published exchange-adjustment rows are missing or ambiguous.")
}
exchange_values <- purrr::map_dfc(seq_along(exchange_labels), function(index) {
  tibble::tibble(
    !!names(exchange_labels)[index] := as.numeric(
      unlist(raw_dlsp[exchange_rows[index], headers$column])
    )
  )
})
exchange_audit <- dplyr::bind_cols(
  headers |> dplyr::select(ref.date),
  exchange_values
) |>
  dplyr::filter(ref.date >= spec$sample[1], ref.date <= spec$sample[2]) |>
  dplyr::arrange(ref.date) |>
  dplyr::mutate(
    sublines_sum = dlsp_fx_internal_indexed + dlsp_fx_external_methodological,
    rounding_difference = dlsp_exchange_adjustment - sublines_sum
  )
exchange_tolerance <- 0.1
if (!identical(exchange_audit$ref.date, expected_dates) ||
    any(!is.finite(as.matrix(exchange_audit[, -1]))) ||
    max(abs(exchange_audit$rounding_difference)) > exchange_tolerance) {
  stop("Ajuste cambial does not equal its two published sublines within rounding tolerance.")
}

exchange_adjusted <- adjust_extension_seasonality(
  exchange_audit$dlsp_exchange_adjustment,
  exchange_audit$ref.date,
  "dlsp_exchange_adjustment"
)
exchange_audit <- exchange_audit |>
  dplyr::mutate(dlsp_exchange_adjustment_adjusted = exchange_adjusted$values)

added_series <- tibble::tibble(
  ref.date = expected_dates,
  dlsp_exchange_adjustment = exchange_adjusted$values
) |>
  dplyr::left_join(
    focus |> dplyr::select(ref.date, dplyr::all_of(expectation_names)),
    by = "ref.date"
  )
if (nrow(added_series) != spec$n_months || ncol(added_series) != 5L ||
    anyDuplicated(names(added_series)) ||
    any(!is.finite(as.matrix(added_series[, -1])))) {
  stop("The four-series experimental extension is incomplete, duplicated, or non-finite.")
}

manifest <- tibble::tribble(
  ~variable, ~source_file, ~source_sheet, ~published_label, ~unit, ~coverage, ~transformation, ~tcode, ~sign_convention,
  "dlsp_exchange_adjustment", "data/raw/DLSP/Evodlp.xlsx", "Fluxos mensais", "Ajuste cambial", "R$ milhões", "2013-01 a 2025-09", paste0("level; seasonal cascade: ", exchange_adjusted$status), 1L, "positivo = ajuste que eleva a DLSP",
  "expect_focus_fiscal_dlsp_ny", "data/raw/focus_fiscal_expectations.csv", NA_character_, "Dívida líquida do setor público; ano seguinte", "% do PIB", "2013-01 a 2025-09", "level", 1L, "mais alta = deterioração esperada",
  "expect_focus_fiscal_primary_balance_ny", "data/raw/focus_fiscal_expectations.csv", NA_character_, "Resultado primário; ano seguinte", "% do PIB", "2013-01 a 2025-09", "level", 1L, "mais negativo = deterioração esperada",
  "expect_focus_fiscal_nominal_balance_ny", "data/raw/focus_fiscal_expectations.csv", NA_character_, "Resultado nominal; ano seguinte", "% do PIB", "2013-01 a 2025-09", "level", 1L, "mais negativo = deterioração esperada"
)
focus_reference <- readr::read_csv(
  "output/fiscal_expectations/fiscal_expectations_audit.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(ref.date = as.Date(ref.date))
focus_vintage_audit <- focus |>
  dplyr::select(ref.date, dplyr::all_of(expectation_names)) |>
  dplyr::left_join(
    focus_reference |>
      dplyr::select(ref.date, dplyr::all_of(expectation_names)) |>
      dplyr::rename_with(~paste0(.x, "_reference"), -ref.date),
    by = "ref.date"
  )
focus_difference_names <- paste0(expectation_names, "_difference")
focus_differences <- purrr::map_dfc(expectation_names, function(variable) {
  tibble::tibble(
    !!paste0(variable, "_difference") :=
      focus_vintage_audit[[variable]] -
      focus_vintage_audit[[paste0(variable, "_reference")]]
  )
})
focus_vintage_audit <- dplyr::bind_cols(focus_vintage_audit, focus_differences)
if (!identical(focus_vintage_audit$ref.date, expected_dates) ||
    anyNA(focus_vintage_audit) ||
    any(as.matrix(focus_vintage_audit[, focus_difference_names]) != 0)) {
  stop("The fiscal expectations differ from the previously audited 114-series vintage.")
}

baseline <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
exchange <- cbind(baseline, dlsp_exchange_adjustment = added_series$dlsp_exchange_adjustment)
expectations <- cbind(baseline, as.matrix(added_series[, expectation_names]))
combined <- cbind(exchange, as.matrix(added_series[, expectation_names]))
panels <- list(
  baseline_111 = baseline,
  exchange_112 = exchange,
  expectations_114 = expectations,
  exchange_expectations_115 = combined
)
panel_tcodes <- purrr::map(panels, function(data_mat) {
  c(
    infer_tcode_from_varnames(colnames(baseline)),
    rep(1L, ncol(data_mat) - ncol(baseline))
  )
})
expected_dimensions <- c(
  baseline_111 = 111L,
  exchange_112 = 112L,
  expectations_114 = 114L,
  exchange_expectations_115 = 115L
)
if (any(purrr::imap_lgl(panels, function(data_mat, panel_name) {
  nrow(data_mat) != spec$n_months ||
    ncol(data_mat) != expected_dimensions[[panel_name]] ||
    anyDuplicated(colnames(data_mat)) ||
    any(!is.finite(data_mat))
}))) {
  stop("At least one experimental panel fails its dimension, name, or finiteness gate.")
}

samples <- list(full = spec$sample, pre_covid = spec$pre_covid_sample)
selection_objects <- purrr::imap(panels, function(data_mat, panel_name) {
  purrr::imap(samples, function(window, sample_name) {
    keep <- expected_dates >= window[1] & expected_dates <= window[2]
    list(
      panel = panel_name,
      sample = sample_name,
      n_months = sum(keep),
      n_series = ncol(data_mat),
      bai_ng = bai_ng_criteria(
        data_mat[keep, , drop = FALSE],
        max_r = 20L,
        apply_bll = TRUE
      ),
      amengual_watson = amengual_watson(
        data_mat[keep, , drop = FALSE],
        r = spec$r,
        p = spec$p,
        max_q = spec$r,
        apply_bll = TRUE
      )
    )
  })
}) |>
  purrr::flatten()

bai_ng_surface <- purrr::map_dfr(selection_objects, function(result) {
  tidyr::expand_grid(
    panel = result$panel,
    sample = result$sample,
    n_months = result$n_months,
    n_series = result$n_series,
    r = seq_len(20L),
    criterion = c("IC1", "IC2", "IC3")
  ) |>
    dplyr::mutate(
      value = dplyr::case_when(
        criterion == "IC1" ~ result$bai_ng$criteria$IC1[r],
        criterion == "IC2" ~ result$bai_ng$criteria$IC2[r],
        TRUE ~ result$bai_ng$criteria$IC3[r]
      )
    )
})
bai_ng_selection <- purrr::map_dfr(selection_objects, function(result) {
  tibble::tibble(
    panel = result$panel,
    sample = result$sample,
    n_months = result$n_months,
    n_series = result$n_series,
    criterion = c("IC1", "IC2", "IC3"),
    selected_r = unlist(result$bai_ng$r_hat, use.names = FALSE)
  )
})
amengual_watson_surface <- purrr::map_dfr(selection_objects, function(result) {
  tibble::tibble(
    panel = result$panel,
    sample = result$sample,
    n_months = result$n_months,
    n_series = result$n_series,
    fixed_r = spec$r,
    fixed_p = spec$p,
    q = seq_along(result$amengual_watson$aw),
    ic2 = result$amengual_watson$aw
  )
})
amengual_watson_selection <- purrr::map_dfr(selection_objects, function(result) {
  tibble::tibble(
    panel = result$panel,
    sample = result$sample,
    n_months = result$n_months,
    n_series = result$n_series,
    fixed_r = spec$r,
    fixed_p = spec$p,
    selected_q = result$amengual_watson$q_hat,
    production_q = spec$q
  )
})
if (nrow(bai_ng_surface) != 480L || nrow(bai_ng_selection) != 24L ||
    nrow(amengual_watson_surface) != 40L ||
    any(!is.finite(bai_ng_surface$value)) ||
    any(!is.finite(amengual_watson_surface$ic2))) {
  stop("The Bai-Ng BLL or Amengual-Watson selection surfaces are incomplete or non-finite.")
}

strength <- purrr::imap_dfr(panels, function(data_mat, panel_name) {
  purrr::imap_dfr(samples, function(window, sample_name) {
    keep <- expected_dates >= window[1] & expected_dates <= window[2]
    fit <- estimate_dfm(
      data_mat[keep, , drop = FALSE],
      r = spec$r,
      q = spec$q,
      p = spec$p,
      dates = expected_dates[keep],
      apply_kilian = FALSE
    )
    relevance <- diagnose_instrument_in_factor_space(
      fit,
      instrument_strength,
      expected_dates[keep],
      spec$p,
      match(spec$mp_var, colnames(data_mat))
    )
    tibble::tibble(
      panel = panel_name,
      sample = sample_name,
      r = spec$r,
      q = spec$q,
      p = spec$p,
      n_months = sum(keep),
      n_series = ncol(data_mat),
      n_obs_aligned = relevance$n_obs,
      xi_mp = relevance$wald_mp,
      f_robust_mp = relevance$f_robust_mp,
      max_companion_root = fit$diagnostics$max_eigenvalue,
      stable = fit$diagnostics$is_stable
    )
  })
})
baseline_strength <- strength |>
  dplyr::filter(panel == "baseline_111") |>
  dplyr::select(
    sample,
    baseline_xi_mp = xi_mp,
    baseline_f_robust_mp = f_robust_mp,
    baseline_max_companion_root = max_companion_root
  )
strength <- strength |>
  dplyr::left_join(baseline_strength, by = "sample") |>
  dplyr::mutate(
    xi_mp_change = xi_mp - baseline_xi_mp,
    xi_mp_pct_change = 100 * xi_mp_change / baseline_xi_mp,
    f_robust_mp_change = f_robust_mp - baseline_f_robust_mp,
    f_robust_mp_pct_change = 100 * f_robust_mp_change / baseline_f_robust_mp,
    max_companion_root_change = max_companion_root - baseline_max_companion_root,
    max_companion_root_pct_change = 100 * max_companion_root_change /
      baseline_max_companion_root
  )
baseline_targets <- tibble::tribble(
  ~sample, ~target_xi_mp, ~target_f_robust_mp,
  "full", 5.240158, 10.060922,
  "pre_covid", 7.478324, 11.874945
)
baseline_gate <- strength |>
  dplyr::filter(panel == "baseline_111") |>
  dplyr::left_join(baseline_targets, by = "sample") |>
  dplyr::mutate(
    xi_mp_difference = xi_mp - target_xi_mp,
    f_robust_mp_difference = f_robust_mp - target_f_robust_mp,
    pass = abs(xi_mp_difference) < 1e-6 &
      abs(f_robust_mp_difference) < 1e-6
  )
if (!all(baseline_gate$pass) || any(!strength$stable) ||
    any(!is.finite(as.matrix(strength[, c(
      "xi_mp", "f_robust_mp", "max_companion_root",
      "xi_mp_change", "xi_mp_pct_change",
      "f_robust_mp_change", "f_robust_mp_pct_change"
    )]))) ||
    !all(
      strength$n_obs_aligned[strength$panel == "baseline_111"] ==
        c(spec$n_innovations, 80L)
    )) {
  stop("The fixed-dimension strength, stability, or baseline-reproduction gate failed.")
}

point_cells <- purrr::imap(panels, function(data_mat, panel_name) {
  run_stage2_cell(
    data_mat,
    expected_dates,
    instrument,
    spec$sample,
    spec$r,
    spec$q,
    spec$p,
    spec$instrument,
    spec$mp_var,
    spec$horizon,
    0L,
    spec$bootstrap_seed,
    spec$shock_bps,
    panel_tcodes[[panel_name]],
    spec$ci_levels
  )
})
canonical <- readRDS(spec$coherence_cell_path)$irf
canonical_variables <- c(
  "yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd"
)
baseline_smoke <- tibble::tibble(
  variable = canonical_variables,
  reproduced_h0 = point_cells$baseline_111$irf$irf_point_matrix[
    match(canonical_variables, colnames(baseline)), 1
  ],
  canonical_h0 = canonical$irf_point_matrix[
    match(canonical_variables, colnames(baseline)), 1
  ]
) |>
  dplyr::mutate(
    difference = reproduced_h0 - canonical_h0,
    pass = abs(difference) < 1e-12
  )
if (!all(baseline_smoke$pass) ||
    any(purrr::map_lgl(point_cells, function(cell) {
      abs(cell$irf$irf_point_matrix[cell$mpind, 1] - spec$normalize_value) >= 1e-12
    }))) {
  stop("The canonical impact smoke test or +50bp normalization gate failed.")
}

point_irfs <- purrr::imap_dfr(point_cells, function(cell, panel_name) {
  data_mat <- panels[[panel_name]]
  purrr::map_dfr(seq_len(ncol(data_mat)), function(index) {
    tibble::tibble(
      panel = panel_name,
      variable = colnames(data_mat)[index],
      h = 0:spec$horizon,
      point = cell$irf$irf_point_matrix[index, ]
    )
  })
})

bootstrap_warnings <- character()
final_cell <- withCallingHandlers(
  run_stage2_cell(
    combined,
    expected_dates,
    instrument,
    spec$sample,
    spec$r,
    spec$q,
    spec$p,
    spec$instrument,
    spec$mp_var,
    spec$horizon,
    spec$nboot,
    spec$bootstrap_seed,
    spec$shock_bps,
    panel_tcodes$exchange_expectations_115,
    spec$ci_levels
  ),
  warning = function(warning) {
    if (grepl("^Bootstrap iteracao", conditionMessage(warning))) {
      bootstrap_warnings <<- c(bootstrap_warnings, conditionMessage(warning))
      invokeRestart("muffleWarning")
    }
  }
)
final_irf <- final_cell$irf
ordered_bands <- all(purrr::map_lgl(final_irf$ci, function(interval) {
  all(is.finite(interval$lower)) &&
    all(is.finite(interval$upper)) &&
    all(interval$lower <= interval$upper)
}))
bootstrap_gate <- tibble::tibble(
  panel = "exchange_expectations_115",
  nboot = spec$nboot,
  seed = spec$bootstrap_seed,
  bootstrap_failures = length(bootstrap_warnings),
  h0_yield_6m = final_irf$irf_point_matrix[final_cell$mpind, 1],
  finite_ordered_bands = ordered_bands,
  gate_pass = length(bootstrap_warnings) == 0L && ordered_bands &&
    abs(h0_yield_6m - spec$normalize_value) < 1e-12
)
if (!bootstrap_gate$gate_pass) {
  stop("The 800-replication bootstrap gate for the 115-series panel failed.")
}

final_irfs <- purrr::map_dfr(seq_len(ncol(combined)), function(index) {
  tibble::tibble(
    panel = "exchange_expectations_115",
    variable = colnames(combined)[index],
    h = 0:spec$horizon,
    point = final_irf$irf_point_matrix[index, ],
    lo68 = final_irf$ci[["0.68"]]$lower[index, ],
    hi68 = final_irf$ci[["0.68"]]$upper[index, ],
    lo90 = final_irf$ci[["0.90"]]$lower[index, ],
    hi90 = final_irf$ci[["0.90"]]$upper[index, ]
  )
}) |>
  dplyr::mutate(
    excludes_zero_68 = lo68 > 0 | hi68 < 0,
    excludes_zero_90 = lo90 > 0 | hi90 < 0
  )
summary_horizons <- c(0L, 6L, 12L, 24L, 36L, 48L)
irf_summary <- final_irfs |>
  dplyr::filter(h %in% summary_horizons)

added_names <- c("dlsp_exchange_adjustment", expectation_names)
mechanism_names <- c(
  "dlsp_exchange_adjustment",
  "fiscal_dlsp",
  "cambio_usd",
  "fiscal_primary_balance"
)
variable_labels <- c(
  dlsp_exchange_adjustment = "Ajuste cambial",
  expect_focus_fiscal_dlsp_ny = "Expectativa Focus: DLSP",
  expect_focus_fiscal_primary_balance_ny = "Expectativa Focus: resultado primário",
  expect_focus_fiscal_nominal_balance_ny = "Expectativa Focus: resultado nominal",
  fiscal_dlsp = "DLSP",
  cambio_usd = "Câmbio R$/US$",
  fiscal_primary_balance = "NFSP primária"
)
new_series_plot <- final_irfs |>
  dplyr::filter(variable %in% added_names) |>
  dplyr::mutate(label = factor(variable_labels[variable], levels = variable_labels[added_names])) |>
  ggplot2::ggplot(ggplot2::aes(h, point)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = lo90, ymax = hi90), fill = "grey82") +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = lo68, ymax = hi68), fill = "grey62") +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.25) +
  ggplot2::geom_line(linewidth = 0.45) +
  ggplot2::facet_wrap(~label, scales = "free_y", ncol = 2) +
  ggplot2::labs(
    title = "Respostas das quatro séries adicionadas",
    subtitle = "Choque de +50 pb em yield_6m; bandas wild bootstrap de 68% e 90%",
    x = "Horizonte (meses)",
    y = "Resposta"
  ) +
  ggplot2::theme_minimal()
mechanism_plot <- final_irfs |>
  dplyr::filter(variable %in% mechanism_names) |>
  dplyr::mutate(label = factor(variable_labels[variable], levels = variable_labels[mechanism_names])) |>
  ggplot2::ggplot(ggplot2::aes(h, point)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = lo90, ymax = hi90), fill = "grey82") +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = lo68, ymax = hi68), fill = "grey62") +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.25) +
  ggplot2::geom_line(linewidth = 0.45) +
  ggplot2::facet_wrap(~label, scales = "free_y", ncol = 2) +
  ggplot2::labs(
    title = "Comparação do mecanismo fiscal-cambial",
    subtitle = "Choque de +50 pb em yield_6m; bandas wild bootstrap de 68% e 90%",
    x = "Horizonte (meses)",
    y = "Resposta"
  ) +
  ggplot2::theme_minimal()

readr::write_csv(manifest, file.path(out_dir, "added_series_manifest.csv"))
readr::write_csv(added_series, file.path(out_dir, "added_series_audit.csv"))
readr::write_csv(exchange_audit, file.path(out_dir, "exchange_adjustment_audit.csv"))
readr::write_csv(focus_vintage_audit, file.path(out_dir, "focus_vintage_audit.csv"))
readr::write_csv(bai_ng_surface, file.path(out_dir, "bai_ng_bll_surface.csv"))
readr::write_csv(bai_ng_selection, file.path(out_dir, "bai_ng_bll_selection.csv"))
readr::write_csv(amengual_watson_surface, file.path(out_dir, "amengual_watson_surface.csv"))
readr::write_csv(amengual_watson_selection, file.path(out_dir, "amengual_watson_selection.csv"))
readr::write_csv(strength, file.path(out_dir, "strength_stability_comparison.csv"))
readr::write_csv(baseline_gate, file.path(out_dir, "baseline_strength_gate.csv"))
readr::write_csv(baseline_smoke, file.path(out_dir, "baseline_impact_smoke.csv"))
readr::write_csv(bootstrap_gate, file.path(out_dir, "bootstrap_gate.csv"))
readr::write_csv(point_irfs, file.path(out_dir, "point_irfs_by_panel.csv"))
readr::write_csv(final_irfs, file.path(out_dir, "irfs_full_115.csv"))
readr::write_csv(irf_summary, file.path(out_dir, "irf_summary_horizons.csv"))
saveRDS(final_cell, file.path(out_dir, "exchange_expectations_115_cell.rds"))
ggplot2::ggsave(
  file.path(out_dir, "irf_added_series.pdf"),
  new_series_plot,
  width = 9,
  height = 6
)
ggplot2::ggsave(
  file.path(out_dir, "irf_mechanism_comparison.pdf"),
  mechanism_plot,
  width = 9,
  height = 6
)

final_strength <- strength |>
  dplyr::filter(panel == "exchange_expectations_115", sample == "full")
final_pre_strength <- strength |>
  dplyr::filter(panel == "exchange_expectations_115", sample == "pre_covid")
final_ic2 <- bai_ng_selection |>
  dplyr::filter(
    panel == "exchange_expectations_115",
    sample == "full",
    criterion == "IC2"
  ) |>
  dplyr::pull(selected_r)
final_ic2_pre <- bai_ng_selection |>
  dplyr::filter(
    panel == "exchange_expectations_115",
    sample == "pre_covid",
    criterion == "IC2"
  ) |>
  dplyr::pull(selected_r)
final_aw <- amengual_watson_selection |>
  dplyr::filter(
    panel == "exchange_expectations_115",
    sample == "full"
  ) |>
  dplyr::pull(selected_q)
final_aw_pre <- amengual_watson_selection |>
  dplyr::filter(
    panel == "exchange_expectations_115",
    sample == "pre_covid"
  ) |>
  dplyr::pull(selected_q)
strength_summary <- strength |>
  dplyr::mutate(
    line = sprintf(
      "| `%s` | %s | %.6f | %+.2f%% | %.6f | %+.2f%% | %.6f | %s |",
      panel, sample, xi_mp, xi_mp_pct_change, f_robust_mp,
      f_robust_mp_pct_change, max_companion_root,
      ifelse(stable, "sim", "não")
    )
  ) |>
  dplyr::pull(line)
added_summary <- irf_summary |>
  dplyr::filter(variable %in% added_names) |>
  dplyr::mutate(
    line = sprintf(
      "| `%s` | %d | %.6f | [%.6f; %.6f] | [%.6f; %.6f] | %s |",
      variable, h, point, lo68, hi68, lo90, hi90,
      ifelse(excludes_zero_90, "sim", "não")
    )
  ) |>
  dplyr::pull(line)
report <- c(
  "# Painel experimental de 115 séries",
  "",
  "> **EXPERIMENTAL — 2026-09-01.** A produção de 111 séries, o manuscrito e os artefatos canônicos permanecem inalterados.",
  "",
  "## Desenho e auditoria",
  "",
  "O exercício compara `baseline_111`, `exchange_112`, `expectations_114` e `exchange_expectations_115`, sempre com `(r,q,p)=(5,5,4)`, `z_jk_bs_purif`, choque de +50 pb em `yield_6m` e horizonte 0--48. Somente o painel final recebeu 800 réplicas wild bootstrap (semente 123).",
  "",
  sprintf("A linha literal \"Ajuste cambial\" cobre 153 meses em R$ milhões e coincide com a soma das duas sublinhas publicadas; a diferença máxima é %.3e. A linha externa \"outros ajustes\" não entra no painel nem na interpretação.", max(abs(exchange_audit$rounding_difference))),
  sprintf("A cascata sazonal classificou o ajuste cambial como `%s`. As três expectativas são bit-idênticas à vintage auditada no experimento de 114 séries.", exchange_adjusted$status),
  "",
  "## Seleção, força e estabilidade",
  "",
  sprintf("No painel 115, o Bai--Ng IC2 BLL seleciona **r=%d** na amostra cheia e **r=%d** no pré-COVID. A estimação comparativa permanece fixada em `r=5`.", final_ic2, final_ic2_pre),
  sprintf("O Amengual--Watson, condicionado a `r=5` e `p=4`, seleciona **q=%d** na amostra cheia e **q=%d** no pré-COVID; o resultado é reportado separadamente e não altera o `q=5` fixo.", final_aw, final_aw_pre),
  sprintf("Amostra cheia: **xi_mp=%.6f**, **F_rob,mp=%.6f**, raiz máxima **%.6f** e estabilidade `%s`.", final_strength$xi_mp, final_strength$f_robust_mp, final_strength$max_companion_root, final_strength$stable),
  sprintf("Pré-COVID: **xi_mp=%.6f**, **F_rob,mp=%.6f**, raiz máxima **%.6f** e estabilidade `%s`.", final_pre_strength$xi_mp, final_pre_strength$f_robust_mp, final_pre_strength$max_companion_root, final_pre_strength$stable),
  "",
  "| painel | amostra | xi_mp | var. xi | F_rob,mp | var. F | raiz | estável |",
  "|---|---|---:|---:|---:|---:|---:|:---:|",
  strength_summary,
  "",
  "## Gate e respostas das séries adicionadas",
  "",
  sprintf("O gate concluiu %d réplicas, com %d falhas, bandas finitas e ordenadas e `yield_6m(h=0)=%.6f`.", bootstrap_gate$nboot, bootstrap_gate$bootstrap_failures, bootstrap_gate$h0_yield_6m),
  "",
  "| série | h | ponto | banda 68% | banda 90% | exclui zero a 90% |",
  "|---|---:|---:|---:|---:|:---:|",
  added_summary,
  "",
  "Uma resposta negativa do ajuste cambial junto à queda da DLSP é compatível com o canal mecânico cambial, mas não constitui decomposição completa da variação da DLSP. Apenas exclusão de zero pela banda de 90% é descrita como significativa; a banda de 68% fornece evidência sugestiva.",
  "",
  "As superfícies completas de seleção, a comparação dos quatro painéis, as IRFs e os gates estão nos CSVs desta pasta."
)
writeLines(report, file.path(out_dir, "report.md"))
