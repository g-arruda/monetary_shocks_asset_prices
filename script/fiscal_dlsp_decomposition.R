rm(list = ls())

source("R/modeling/production_spec.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")
source("R/preprocessing/experimental_extensions.R")

spec <- production_spec()
run_bootstrap <- "--bootstrap" %in% commandArgs(trailingOnly = TRUE)
out_dir <- "output/fiscal_dlsp_decomposition"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

expected_dates <- seq(spec$sample[1], spec$sample[2], by = "month")
panel <- readr::read_csv(spec$data_path, show_col_types = FALSE) |>
  dplyr::mutate(ref.date = as.Date(ref.date))
instrument <- readr::read_csv(spec$instrument_path, show_col_types = FALSE)
instrument_strength <- instrument |>
  dplyr::transmute(month = as.Date(month), shock = .data[[spec$instrument]]) |>
  dplyr::filter(!is.na(shock))

if (!identical(panel$ref.date, expected_dates) || ncol(panel) - 1L != spec$n_series ||
    any(!is.finite(as.matrix(panel[, -1])))) {
  stop("The production panel is not the complete finite 111-series sample.")
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

flow_manifest <- tibble::tribble(
  ~variable, ~sheet_label, ~role, ~unit, ~sign_convention,
  "dlsp_monthly_change", "Dívida líquida - variação mensal", "lhs_identity", "R$ milhões", "positivo = aumento da DLSP",
  "dlsp_nfsp", "NFSP", "identity_component", "R$ milhões", "positivo = necessidade de financiamento",
  "dlsp_primary_result", "Primário", "nfsp_component", "R$ milhões", "positivo = resultado primário deficitário",
  "dlsp_nominal_interest", "Juros nominais", "nfsp_component", "R$ milhões", "positivo = juros que elevam a NFSP",
  "dlsp_exchange_adjustment", "Ajuste cambial", "identity_component", "R$ milhões", "positivo = ajuste que eleva a DLSP",
  "dlsp_debt_recognition", "Reconhecimento de dívidas", "identity_component", "R$ milhões", "positivo = reconhecimento que eleva a DLSP",
  "dlsp_privatizations", "Privatizações", "identity_component", "R$ milhões", "positivo = privatização que reduz a DLSP"
)
flow_rows <- match(flow_manifest$sheet_label, as.character(raw_dlsp[[1]]))
if (anyNA(flow_rows) || anyDuplicated(flow_rows)) {
  stop("The required consolidated-public-sector DLSP flow rows are missing or ambiguous.")
}
subline_manifest <- tibble::tribble(
  ~variable, ~sheet_label,
  "dlsp_fx_internal_indexed", "Dívida interna indexada ao câmbio",
  "dlsp_fx_external_methodological", "Dívida externa - metodológico",
  "dlsp_external_other_adjustments", "Dívida externa - outros ajustes2/"
)
subline_rows <- match(subline_manifest$sheet_label, as.character(raw_dlsp[[1]]))
if (anyNA(subline_rows) || anyDuplicated(subline_rows)) {
  stop("The DLSP exchange-adjustment sublines are missing or ambiguous.")
}

flow_values <- purrr::map_dfc(seq_len(nrow(flow_manifest)), function(index) {
  tibble::tibble(!!flow_manifest$variable[index] := as.numeric(unlist(raw_dlsp[flow_rows[index], headers$column])))
})
flows <- dplyr::bind_cols(headers |> dplyr::select(ref.date), flow_values) |>
  dplyr::filter(ref.date >= spec$sample[1], ref.date <= spec$sample[2]) |>
  dplyr::arrange(ref.date)
if (!identical(flows$ref.date, expected_dates) || any(!is.finite(as.matrix(flows[, -1])))) {
  stop("The DLSP workbook does not provide complete finite monthly flows for the research sample.")
}
subline_values <- purrr::map_dfc(seq_len(nrow(subline_manifest)), function(index) {
  tibble::tibble(!!subline_manifest$variable[index] := as.numeric(unlist(raw_dlsp[subline_rows[index], headers$column])))
})
subline_audit <- dplyr::bind_cols(headers |> dplyr::select(ref.date), subline_values) |>
  dplyr::filter(ref.date >= spec$sample[1], ref.date <= spec$sample[2]) |>
  dplyr::arrange(ref.date)
if (!identical(subline_audit$ref.date, expected_dates) || any(!is.finite(as.matrix(subline_audit[, -1])))) {
  stop("The DLSP exchange-adjustment sublines are incomplete or non-finite.")
}

identity <- flows |>
  dplyr::left_join(subline_audit |> dplyr::select(ref.date, dlsp_external_other_adjustments), by = "ref.date") |>
  dplyr::transmute(
    ref.date,
    dlsp_monthly_change,
    dlsp_nfsp,
    dlsp_exchange_adjustment,
    dlsp_debt_recognition,
    dlsp_privatizations,
    rhs = dlsp_nfsp + dlsp_exchange_adjustment + dlsp_debt_recognition + dlsp_privatizations,
    residual = dlsp_monthly_change - rhs,
    rhs_including_external_other_adjustments = rhs + dlsp_external_other_adjustments,
    residual_including_external_other_adjustments = dlsp_monthly_change - rhs_including_external_other_adjustments
  )
identity_tolerance <- 0.1

raw_primary <- readr::read_csv("data/raw/raw_data.csv", show_col_types = FALSE) |>
  dplyr::transmute(ref.date = as.Date(ref.date), sgs_4649 = fiscal_primary_balance) |>
  dplyr::filter(ref.date >= spec$sample[1], ref.date <= spec$sample[2])
primary_audit <- flows |>
  dplyr::select(ref.date, workbook_primary = dlsp_primary_result) |>
  dplyr::left_join(raw_primary, by = "ref.date") |>
  dplyr::mutate(difference = workbook_primary - sgs_4649)
if (!identical(primary_audit$ref.date, expected_dates) || anyNA(primary_audit$sgs_4649) ||
    max(abs(primary_audit$difference)) > identity_tolerance ||
    stats::cor(primary_audit$workbook_primary, primary_audit$sgs_4649) < 0.999999999) {
  stop("The workbook primary result is not numerically equivalent to SGS 4649 in coverage, unit, or sign.")
}
readr::write_csv(flows, file.path(out_dir, "dlsp_flows_raw.csv"))
readr::write_csv(subline_audit, file.path(out_dir, "exchange_adjustment_sublines_audit.csv"))
readr::write_csv(identity, file.path(out_dir, "accounting_identity_audit.csv"))
readr::write_csv(primary_audit, file.path(out_dir, "primary_sgs4649_audit.csv"))
if (max(abs(identity$residual)) > identity_tolerance) {
  stop(
    "The seven-flow accounting identity does not close: the workbook's 'Dívida externa - outros ajustes2/' is outside 'Ajuste cambial' and is required to reconcile ΔDLSP. No DFM is estimated."
  )
}

adjusted <- purrr::map(flow_manifest$variable, function(variable) {
  adjust_extension_seasonality(flows[[variable]], flows$ref.date, variable)
})
flow_panel <- purrr::map_dfc(seq_along(adjusted), function(index) {
  tibble::tibble(!!flow_manifest$variable[index] := adjusted[[index]]$values)
})
flow_treatment <- flow_manifest |>
  dplyr::mutate(
    source_file = "data/raw/DLSP/Evodlp.xlsx",
    source_sheet = "Fluxos mensais",
    coverage = "2013-01 a 2025-09",
    transformation = "level; seasonal adjustment only when detected",
    tcode = 1L,
    is_seasonal = purrr::map_lgl(adjusted, "is_seasonal"),
    seasonal_status = purrr::map_chr(adjusted, "status")
  )

baseline <- panel |> dplyr::select(-ref.date) |> as.matrix()
expanded <- cbind(baseline, as.matrix(flow_panel))
tcodes <- c(infer_tcode_from_varnames(colnames(baseline)), rep(1L, ncol(flow_panel)))
if (ncol(expanded) != 118L || anyDuplicated(colnames(expanded)) || any(!is.finite(expanded))) {
  stop("The fiscal DLSP experimental panel is not a finite 118-series matrix.")
}

selection <- purrr::imap_dfr(
  list(baseline_111 = baseline, fiscal_dlsp_118 = expanded),
  function(data_mat, panel_name) {
    bn <- bai_ng_criteria(data_mat, max_r = 20L, apply_bll = TRUE)
    aw <- amengual_watson(data_mat, r = spec$r, p = spec$p, apply_bll = TRUE)
    tibble::tibble(
      panel = panel_name,
      n_months = nrow(data_mat),
      n_series = ncol(data_mat),
      bai_ng_ic2_r = bn$r_hat$IC2,
      amengual_watson_q = aw$q_hat
    )
  }
)

fixed <- purrr::imap_dfr(
  list(baseline_111 = baseline, fiscal_dlsp_118 = expanded),
  function(data_mat, panel_name) {
    fit <- estimate_dfm(data_mat, r = spec$r, q = spec$q, p = spec$p,
                        dates = expected_dates, apply_kilian = FALSE)
    strength <- diagnose_instrument_in_factor_space(
      fit, instrument_strength, expected_dates, spec$p, match(spec$mp_var, colnames(data_mat))
    )
    tibble::tibble(
      panel = panel_name,
      r = spec$r,
      q = spec$q,
      p = spec$p,
      n_months = nrow(data_mat),
      n_series = ncol(data_mat),
      n_obs_aligned = strength$n_obs,
      xi_mp = strength$wald_mp,
      f_robust_mp = strength$f_robust_mp,
      max_companion_root = fit$diagnostics$max_eigenvalue,
      stable = fit$diagnostics$is_stable
    )
  }
)
if (any(!fixed$stable) || any(!is.finite(as.matrix(fixed[, c("xi_mp", "f_robust_mp", "max_companion_root")]))) ||
    fixed$n_obs_aligned[fixed$panel == "baseline_111"] != spec$n_innovations) {
  stop("The baseline or 118-series experiment failed its strength or stability gate.")
}

baseline_cell <- run_stage2_cell(
  baseline, expected_dates, instrument, spec$sample, spec$r, spec$q, spec$p,
  spec$instrument, spec$mp_var, spec$horizon, 0L, spec$bootstrap_seed,
  spec$shock_bps, infer_tcode_from_varnames(colnames(baseline)), spec$ci_levels
)
baseline_reference <- readRDS(spec$coherence_cell_path)$irf
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
baseline_smoke <- tibble::tibble(
  variable = headline,
  reproduced_h0 = baseline_cell$irf$irf_point_matrix[match(headline, colnames(baseline)), 1],
  canonical_h0 = baseline_reference$irf_point_matrix[match(headline, colnames(baseline)), 1]
) |>
  dplyr::mutate(difference = reproduced_h0 - canonical_h0, pass = abs(difference) < 1e-12)
if (!all(baseline_smoke$pass)) {
  stop("The baseline impact smoke test does not reproduce the canonical IRFs.")
}
experimental_smoke <- run_stage2_cell(
  expanded, expected_dates, instrument, spec$sample, spec$r, spec$q, spec$p,
  spec$instrument, spec$mp_var, spec$horizon, 0L, spec$bootstrap_seed,
  spec$shock_bps, tcodes, spec$ci_levels
)
if (!isTRUE(all.equal(
  experimental_smoke$irf$irf_point_matrix[experimental_smoke$mpind, 1],
  spec$normalize_value, tolerance = 1e-12
))) {
  stop("The experimental point estimate does not normalize yield_6m to +50bp.")
}

readr::write_csv(flow_treatment, file.path(out_dir, "extraction_manifest.csv"))
readr::write_csv(selection, file.path(out_dir, "factor_selection.csv"))
readr::write_csv(fixed, file.path(out_dir, "strength_stability_comparison.csv"))
readr::write_csv(baseline_smoke, file.path(out_dir, "baseline_impact_smoke.csv"))

if (run_bootstrap) {
  bootstrap_warnings <- character()
  experimental_cell <- withCallingHandlers(
    run_stage2_cell(
      expanded, expected_dates, instrument, spec$sample, spec$r, spec$q, spec$p,
      spec$instrument, spec$mp_var, spec$horizon, spec$nboot, spec$bootstrap_seed,
      spec$shock_bps, tcodes, spec$ci_levels
    ),
    warning = function(warning) {
      if (grepl("^Bootstrap iteracao", conditionMessage(warning))) {
        bootstrap_warnings <<- c(bootstrap_warnings, conditionMessage(warning))
        invokeRestart("muffleWarning")
      }
    }
  )
  experimental_irf <- experimental_cell$irf
  ordered_bands <- all(vapply(
    experimental_irf$ci,
    function(interval) all(is.finite(interval$lower)) && all(is.finite(interval$upper)) &&
      all(interval$lower <= interval$upper),
    logical(1)
  ))
  bootstrap_gate <- tibble::tibble(
    nboot = spec$nboot,
    seed = spec$bootstrap_seed,
    bootstrap_failures = length(bootstrap_warnings),
    h0_yield_6m = experimental_irf$irf_point_matrix[experimental_cell$mpind, 1],
    finite_ordered_bands = ordered_bands,
    gate_pass = length(bootstrap_warnings) == 0L && ordered_bands &&
      abs(experimental_irf$irf_point_matrix[experimental_cell$mpind, 1] - spec$normalize_value) < 1e-12
  )
  if (!bootstrap_gate$gate_pass) {
    stop("The 800-replication experimental bootstrap gate failed.")
  }

  report_variables <- c(headline, flow_manifest$variable)
  baseline_long <- purrr::map_dfr(report_variables[report_variables %in% colnames(baseline)], function(variable) {
    index <- match(variable, colnames(baseline))
    tibble::tibble(
      panel = "baseline_111", variable = variable, h = 0:spec$horizon,
      point = baseline_reference$irf_point_matrix[index, ],
      lo68 = baseline_reference$ci[["0.68"]]$lower[index, ], hi68 = baseline_reference$ci[["0.68"]]$upper[index, ],
      lo90 = baseline_reference$ci[["0.90"]]$lower[index, ], hi90 = baseline_reference$ci[["0.90"]]$upper[index, ]
    )
  })
  experimental_long <- purrr::map_dfr(report_variables, function(variable) {
    index <- match(variable, colnames(expanded))
    tibble::tibble(
      panel = "fiscal_dlsp_118", variable = variable, h = 0:spec$horizon,
      point = experimental_irf$irf_point_matrix[index, ],
      lo68 = experimental_irf$ci[["0.68"]]$lower[index, ], hi68 = experimental_irf$ci[["0.68"]]$upper[index, ],
      lo90 = experimental_irf$ci[["0.90"]]$lower[index, ], hi90 = experimental_irf$ci[["0.90"]]$upper[index, ]
    )
  })
  irfs <- dplyr::bind_rows(baseline_long, experimental_long)
  irf_summary <- experimental_long |>
    dplyr::filter(variable %in% flow_manifest$variable, h %in% c(0L, 6L, 12L, 24L, 36L, 48L)) |>
    dplyr::mutate(sig90 = lo90 > 0 | hi90 < 0)
  plot <- experimental_long |>
    dplyr::filter(variable %in% flow_manifest$variable) |>
    ggplot2::ggplot(ggplot2::aes(h, point)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lo90, ymax = hi90), fill = "grey80") +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lo68, ymax = hi68), fill = "grey60") +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.25) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~variable, scales = "free_y") +
    ggplot2::labs(
      title = "Decomposição contábil da DLSP",
      subtitle = "Choque monetário de +50 pb em yield_6m; bandas bootstrap 68% e 90%",
      x = "Horizonte (meses)", y = "Resposta (R$ milhões)"
    ) +
    ggplot2::theme_minimal()

  readr::write_csv(bootstrap_gate, file.path(out_dir, "bootstrap_gate.csv"))
  readr::write_csv(irfs, file.path(out_dir, "irfs.csv"))
  readr::write_csv(irf_summary, file.path(out_dir, "irf_summary.csv"))
  ggplot2::ggsave(file.path(out_dir, "irf_dlsp_flows.pdf"), plot, width = 10, height = 7)
}
