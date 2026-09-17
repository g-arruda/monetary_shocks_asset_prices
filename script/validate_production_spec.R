# Validate the canonical 115-series production panel and the (5,5) bootstrap gate.

rm(list = ls())

source("R/modeling/production_spec.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/var_proxy.R")
source("R/identification/factor_space_diagnostics.R")

spec <- production_spec()
run_bootstrap <- "--bootstrap" %in% commandArgs(trailingOnly = TRUE)
out_dir <- "output/validation"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

panel <- readr::read_csv(spec$data_path, show_col_types = FALSE)
base <- readr::read_csv(spec$base_data_path, show_col_types = FALSE)
manifest <- readr::read_csv(
  "output/panel/production_series_manifest.csv",
  show_col_types = FALSE
)
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
    anyDuplicated(colnames(data_mat)) || any(!is.finite(data_mat)) ||
    any(!is.finite(base_mat)) ||
    !all(spec$required_series %in% colnames(data_mat)) ||
    any(spec$excluded_series %in% colnames(data_mat))) {
  stop("The canonical and base panels do not satisfy the production composition invariants.")
}
if (nrow(manifest) != spec$n_series || anyDuplicated(manifest$variable) ||
    !setequal(manifest$variable, colnames(data_mat)) ||
    !identical(
      manifest$source_id[match("spread_credito_pj_total", manifest$variable)],
      "SGS 20784"
    ) ||
    !identical(
      manifest$source_id[match("spread_credito_pf_total", manifest$variable)],
      "SGS 20785"
    ) ||
    !all(spec$production_series_added %in% manifest$variable) ||
    any(c("spread_icc_juridica", "spread_icc_fisica") %in% manifest$variable) ||
    any(grepl("^SEM_AJUSTE", manifest$seasonal_status))) {
  stop("The production manifest does not identify the 115-series composition and sources.")
}

bai_ng <- bai_ng_criteria(data_mat, max_r = 20L, apply_bll = TRUE)
bai_ng_surface <- tibble::tibble(
  r = seq_len(20L),
  IC1 = bai_ng$criteria$IC1,
  IC2 = bai_ng$criteria$IC2,
  IC3 = bai_ng$criteria$IC3
)
if (!identical(unname(unlist(bai_ng$r_hat)), c(5L, 5L, 20L)) ||
    any(!is.finite(as.matrix(bai_ng_surface[, -1])))) {
  stop("The BLL Bai-Ng surface must be finite and select IC1=5, IC2=5, IC3=20.")
}
if (file.exists(spec$bai_ng_output)) {
  saved_bai_ng <- readr::read_csv(spec$bai_ng_output, show_col_types = FALSE)
  if (!identical(names(saved_bai_ng), names(bai_ng_surface)) ||
      nrow(saved_bai_ng) != nrow(bai_ng_surface) ||
      max(abs(as.matrix(saved_bai_ng) - as.matrix(bai_ng_surface))) > 1e-12) {
    stop("The saved production BLL Bai-Ng surface does not reproduce.")
  }
}

instrument_wide <- readr::read_csv(spec$instrument_path, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))
if (!identical(instrument_wide$month, expected_dates) ||
    nrow(instrument_wide) != spec$n_months ||
    anyDuplicated(instrument_wide$month) ||
    any(!is.finite(as.matrix(instrument_wide[, -1])))) {
  stop("The eight instrument variants must cover all 166 production months.")
}
first_instrument <- c(
  -22.017543058626288, 0, -3.96538127126775, 0,
  0, 7.955274952337614, 0, -2.465187498734114
)
if (max(abs(instrument_wide[[spec$instrument]][seq_along(first_instrument)] -
    first_instrument)) > 1e-12) {
  stop("The recalculated initial production-instrument values changed.")
}
event_diagnostics <- readr::read_csv(
  "data/processed/copom_event_diagnostics.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(month = lubridate::floor_date(as.Date(date), "month")) |>
  dplyr::group_by(month) |>
  dplyr::summarise(kept_events = sum(copom_day & jk_monetary_bs), .groups = "drop")
zero_contract <- tibble::tibble(month = expected_dates) |>
  dplyr::left_join(event_diagnostics, by = "month") |>
  dplyr::mutate(kept_events = tidyr::replace_na(kept_events, 0L))
if (sum(instrument_wide[[spec$instrument]] == 0) != 99L ||
    !identical(
      instrument_wide[[spec$instrument]] == 0,
      zero_contract$kept_events == 0
    )) {
  stop("The JK monthly zeros do not match months without retained events.")
}
instrument <- instrument_wide |>
  dplyr::transmute(month = as.Date(month), shock = .data[[spec$instrument]]) |>
  dplyr::filter(!is.na(shock))

factors <- estimate_static_factors(data_mat, spec$r)$factors
lag_criteria <- var_lag_criteria(
  factors,
  pmax = spec$factor_var_lag_selection$max_lag,
  deterministic = spec$factor_var_lag_selection$deterministic
)
if (unique(lag_criteria$T_common) != spec$factor_var_lag_selection$common_sample ||
    lag_criteria$p[which.min(lag_criteria$aic)] !=
      spec$factor_var_lag_selection$selected_aic ||
    lag_criteria$p[which.min(lag_criteria$bic)] !=
      spec$factor_var_lag_selection$selected_bic ||
    abs(lag_criteria$aic[lag_criteria$p == spec$p] -
      spec$factor_var_lag_selection$aic_at_production) > 1e-12) {
  stop("The reported factor-lag criteria do not reproduce on the expanded sample.")
}
readr::write_csv(
  lag_criteria,
  file.path(out_dir, "production_factor_lag_criteria.csv")
)
# The production theta lives as literals in production_spec(), because that
# function reads no artefact. Re-derive it here from data/processed/ and stop if
# it moved: a panel, r or p change silently invalidates a frozen theta.
theta_refit <- estimate_covid_theta(
  factors, spec$p, dates[(spec$p + 1):length(dates)],
  spec$covid_volatility_design$covid_start,
  spec$covid_volatility_design$theta_lower,
  spec$covid_volatility_design$theta_upper
)
theta_spec <- spec$covid_volatility$theta
if (!setequal(names(theta_refit$theta), names(theta_spec)) ||
    max(abs(theta_refit$theta / theta_spec[names(theta_refit$theta)] - 1)) > 1e-8) {
  stop("The frozen production theta does not reproduce from the panel: refit is (",
       paste(sprintf("%s = %.15g", names(theta_refit$theta), theta_refit$theta),
             collapse = ", "), "). Re-run script/covid_volatility_theta.R and ",
       "update production_spec()$covid_volatility$theta.")
}

mpind <- match(spec$mp_var, colnames(data_mat))
samples <- list(full = spec$sample, pre_covid = spec$pre_covid_sample)
# The full window runs the production Lenza-Primiceri scale since 2026-09-17;
# the pre-COVID window has s_t = 1 in every month, so its numbers are the same
# treated or not, and they did not move when the treatment was switched on.
expected <- tibble::tibble(
  sample = c("full", "pre_covid"),
  n_innovations = c(162L, 90L),
  xi_mp = c(6.847996589177567, 8.643436347247281),
  f_robust_mp = c(11.76524968812349, 13.809985106266108),
  max_companion_root = c(0.9836766921623673, 0.9933587954932864),
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
    apply_kilian = FALSE,
    covid_volatility = if (sample_name == "full") spec$covid_volatility else NULL
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

point_dfm <- estimate_dfm(
  data_mat,
  r = spec$r,
  q = spec$q,
  p = spec$p,
  dates = dates,
  apply_kilian = FALSE,
  covid_volatility = spec$covid_volatility
)
point_irf <- compute_irf_dfm(
  point_dfm,
  instrument = instrument,
  h = spec$horizon,
  nboot = 0L,
  mpind = mpind,
  normalize_value = spec$normalize_value,
  data_dates = dates,
  tcode = infer_tcode_from_varnames(colnames(data_mat)),
  ci_levels = spec$ci_levels,
  var_names = colnames(data_mat),
  identification = "proxy"
)
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
# Under the production Lenza-Primiceri scale since 2026-09-17. The previous,
# untreated values were 0.007026364233969990, 0.007245719448835893,
# -0.9965048308800585 and 0.1342419094791832.
expected_impacts <- c(
  0.005,
  0.007009032608368654,
  0.007290054332728366,
  -1.502015837566601,
  0.1294216737921361
)
impact_smoke <- tibble::tibble(
  variable = headline,
  impact = point_irf$irf_point_matrix[match(headline, colnames(data_mat)), 1],
  expected = expected_impacts
)
if (max(abs(impact_smoke$impact - impact_smoke$expected)) > 1e-12 ||
    abs(impact_smoke$impact[impact_smoke$variable == spec$mp_var] -
      spec$normalize_value) > 1e-12) {
  stop("The five required impact responses do not reproduce the expanded-sample gate.")
}
readr::write_csv(
  impact_smoke,
  file.path(out_dir, "production_spec_impact_smoke.csv")
)

if (run_bootstrap) {
  if (!is.null(spec$covid_volatility)) {
    stop("--bootstrap is unavailable while the Lenza-Primiceri scale is ",
         "production: the bootstrap DGP and the Kilian correction assume OLS ",
         "with constant Sigma. Production inference is the Anderson-Rubin sets ",
         "(production_spec()$inference).")
  }
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
