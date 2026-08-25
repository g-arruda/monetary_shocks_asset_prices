# Validate the canonical 111-series production panel and the (5,5) bootstrap gate.

rm(list = ls())

source("R/modeling/production_spec.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")

spec <- production_spec()
run_bootstrap <- "--bootstrap" %in% commandArgs(trailingOnly = TRUE)
out_dir <- "output/validation"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

panel <- readr::read_csv(spec$data_path, show_col_types = FALSE)
base <- readr::read_csv(spec$base_data_path, show_col_types = FALSE)
dates <- as.Date(panel$ref.date)
data_mat <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
base_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
expected_dates <- seq(spec$sample[1], spec$sample[2], by = "month")
if (!identical(dates, expected_dates) || nrow(data_mat) != spec$n_months ||
    ncol(data_mat) != spec$n_series || ncol(base_mat) != 106L ||
    any(!is.finite(data_mat)) || any(!is.finite(base_mat)) ||
    !all(spec$required_series %in% colnames(data_mat)) ||
    any(spec$excluded_series %in% colnames(data_mat))) {
  stop("The canonical and base panels do not satisfy the production composition invariants.")
}

bai_ng <- bai_ng_criteria(data_mat, max_r = 20L, apply_bll = TRUE)
if (bai_ng$r_hat$IC2 != spec$r) {
  stop("Bai-Ng IC2 did not select the production r.")
}

instrument <- readr::read_csv(spec$instrument_path, show_col_types = FALSE) |>
  dplyr::transmute(month = as.Date(month), shock = .data[[spec$instrument]]) |>
  dplyr::filter(!is.na(shock))
mpind <- match(spec$mp_var, colnames(data_mat))
samples <- list(full = spec$sample, pre_covid = spec$pre_covid_sample)
expected <- tibble::tibble(
  sample = c("full", "pre_covid"),
  n_innovations = c(149L, 80L),
  xi_mp = c(5.240158304905, 7.478324275893),
  f_robust_mp = c(10.060921519349, 11.874945340585),
  max_companion_root = c(0.968126200394, 0.992482650750),
  stable = c(TRUE, TRUE)
)

diagnostics <- lapply(names(samples), function(sample_name) {
  window <- samples[[sample_name]]
  keep <- dates >= window[1] & dates <= window[2]
  dfm <- estimate_dfm(
    data_mat[keep, , drop = FALSE],
    r = spec$r,
    q = spec$q,
    p = spec$p,
    dates = dates[keep],
    apply_kilian = FALSE
  )
  strength <- diagnose_instrument_in_factor_space(
    dfm,
    instrument,
    dates[keep],
    p = spec$p,
    mp_var_idx = mpind
  )
  tibble::tibble(
    sample = sample_name,
    n_series = ncol(data_mat),
    n_months = sum(keep),
    n_innovations = strength$n_obs,
    xi_mp = strength$wald_mp,
    f_robust_mp = strength$f_robust_mp,
    max_companion_root = dfm$diagnostics$max_eigenvalue,
    stable = dfm$diagnostics$is_stable,
    bai_ng_ic2_r = bai_ng$r_hat$IC2
  )
}) |>
  dplyr::bind_rows()

comparison <- diagnostics |>
  dplyr::left_join(expected, by = "sample", suffix = c("", "_expected"))
if (any(comparison$n_innovations != comparison$n_innovations_expected) ||
    any(abs(comparison$xi_mp - comparison$xi_mp_expected) > 1e-8) ||
    any(abs(comparison$f_robust_mp - comparison$f_robust_mp_expected) > 1e-8) ||
    any(abs(comparison$max_companion_root - comparison$max_companion_root_expected) > 1e-10) ||
    any(comparison$stable != comparison$stable_expected) ||
    diagnostics$n_innovations[diagnostics$sample == "full"] != spec$n_innovations) {
  stop("The canonical production diagnostics do not reproduce the migration gate.")
}
readr::write_csv(diagnostics, file.path(out_dir, "production_spec_diagnostics.csv"))

if (run_bootstrap) {
  tcodes <- infer_tcode_from_varnames(colnames(data_mat))
  dfm <- estimate_dfm(
    data_mat,
    r = spec$r,
    q = spec$q,
    p = spec$p,
    dates = dates,
    apply_kilian = TRUE
  )
  bootstrap_failures <- character()
  started <- Sys.time()
  irf <- withCallingHandlers(
    compute_irf_dfm(
      dfm,
      instrument = instrument,
      h = spec$horizon,
      nboot = spec$nboot,
      bootstrap_seed = spec$bootstrap_seed,
      mpind = mpind,
      normalize_value = spec$normalize_value,
      data_dates = dates,
      tcode = tcodes,
      ci_levels = spec$ci_levels,
      var_names = colnames(data_mat),
      identification = "proxy"
    ),
    warning = function(warning) {
      if (grepl("^Bootstrap iteracao", conditionMessage(warning))) {
        bootstrap_failures <<- c(bootstrap_failures, conditionMessage(warning))
        invokeRestart("muffleWarning")
      }
    }
  )
  ordered_bands <- all(vapply(
    irf$ci,
    function(interval) all(is.finite(interval$lower)) && all(is.finite(interval$upper)) &&
      all(interval$lower <= interval$upper),
    logical(1)
  ))
  normalization <- irf$irf_point_matrix[mpind, 1]
  failure_count <- length(bootstrap_failures)
  gate <- tibble::tibble(
    panel = spec$panel_name,
    r = spec$r,
    q = spec$q,
    p = spec$p,
    n_series = ncol(data_mat),
    n_months = nrow(data_mat),
    n_innovations = diagnostics$n_innovations[diagnostics$sample == "full"],
    nboot = spec$nboot,
    seed = spec$bootstrap_seed,
    bootstrap_failures = failure_count,
    max_companion_root = dfm$diagnostics$max_eigenvalue,
    stable = dfm$diagnostics$is_stable,
    h0_yield_6m = normalization,
    finite_ordered_bands = ordered_bands,
    elapsed_minutes = as.numeric(difftime(Sys.time(), started, units = "mins")),
    gate_pass = failure_count == 0L && dfm$diagnostics$is_stable &&
      abs(normalization - spec$normalize_value) < 1e-12 && ordered_bands
  )
  print(gate, width = Inf)
  if (!gate$gate_pass) {
    stop("The canonical production bootstrap gate failed.")
  }
  headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
  headline_rows <- dplyr::bind_rows(lapply(headline, function(variable) {
    index <- match(variable, colnames(data_mat))
    tibble::tibble(
      variable = variable,
      h = 0:spec$horizon,
      point = irf$irf_point_matrix[index, ],
      lo68 = irf$ci[["0.68"]]$lower[index, ],
      hi68 = irf$ci[["0.68"]]$upper[index, ],
      lo90 = irf$ci[["0.90"]]$lower[index, ],
      hi90 = irf$ci[["0.90"]]$upper[index, ]
    )
  }))
  readr::write_csv(gate, file.path(out_dir, "production_spec_bootstrap_gate.csv"))
  readr::write_csv(headline_rows, file.path(out_dir, "production_spec_headline_irf.csv"))
}

message("Production specification validation passed.")
