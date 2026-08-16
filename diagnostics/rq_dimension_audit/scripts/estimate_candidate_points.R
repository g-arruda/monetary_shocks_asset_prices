source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")

out_dir <- "diagnostics/rq_dimension_audit/output"
panel <- readr::read_csv(
  "data/processed/data_log_deseasonalized_base_106.csv",
  show_col_types = FALSE
)
instrument <- readr::read_csv(
  "data/processed/instrumentos_mensais.csv",
  show_col_types = FALSE
) |>
  dplyr::transmute(month = as.Date(month), shock = z_jk_bs_purif) |>
  dplyr::filter(!is.na(shock))

dates <- as.Date(panel$ref.date)
data <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
stopifnot(
  nrow(data) == 153L,
  ncol(data) == 106L,
  identical(dates, seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")),
  all(is.finite(data)),
  anyDuplicated(instrument$month) == 0L,
  all(is.finite(instrument$shock))
)

candidates <- tibble::tribble(
  ~r, ~q,
  5L, 3L,
  2L, 2L,
  5L, 4L,
  7L, 6L,
  7L, 7L
)
samples <- list(
  full = dates <= as.Date("2025-09-01"),
  pre_covid = dates <= as.Date("2019-12-01")
)
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
tcode <- infer_tcode_from_varnames(colnames(data))
mpind <- match("yield_6m", colnames(data))

metric_rows <- list()
irf_rows <- list()
row_index <- 0L

for (sample_name in names(samples)) {
  in_sample <- samples[[sample_name]]
  data_sub <- data[in_sample, , drop = FALSE]
  dates_sub <- dates[in_sample]
  for (candidate_index in seq_len(nrow(candidates))) {
    r <- candidates$r[candidate_index]
    q <- candidates$q[candidate_index]
    message("point DFM: ", sample_name, " / (", r, ",", q, ")")
    dfm <- estimate_dfm(
      data_sub,
      r = r,
      q = q,
      p = 6L,
      dates = dates_sub,
      apply_kilian = FALSE
    )
    diagnostic <- diagnose_instrument_in_factor_space(
      dfm,
      instrument,
      dates_sub,
      p = 6L,
      mp_var_idx = mpind
    )
    irf <- compute_irf_dfm(
      dfm,
      instrument = instrument,
      h = 48L,
      nboot = 0L,
      bootstrap_seed = 123L,
      mpind = mpind,
      normalize_value = 0.005,
      data_dates = dates_sub,
      tcode = tcode,
      ci_levels = c(0.68, 0.90),
      var_names = colnames(data),
      identification = "proxy"
    )

    row_index <- row_index + 1L
    metric_rows[[row_index]] <- tibble::tibble(
      sample = sample_name,
      r = r,
      q = q,
      p = 6L,
      n_series = ncol(data_sub),
      n_months = nrow(data_sub),
      n_obs_align = diagnostic$n_obs,
      xi_mp = diagnostic$wald_mp,
      f_robust_mp = diagnostic$f_robust_mp,
      xi_gt_3_84 = diagnostic$wald_mp > 3.84,
      impact_mp_pre_normalization = diagnostic$impact_mp,
      max_companion_root = dfm$diagnostics$max_eigenvalue,
      stable = dfm$diagnostics$is_stable
    )

    irf_rows[[row_index]] <- dplyr::bind_rows(lapply(headline, function(variable) {
      index <- match(variable, colnames(data))
      tibble::tibble(
        sample = sample_name,
        r = r,
        q = q,
        variable = variable,
        h = 0:48,
        point = irf$irf_point_matrix[index, ]
      )
    }))
  }
}

metrics <- dplyr::bind_rows(metric_rows) |>
  dplyr::arrange(r, q, sample)
irfs <- dplyr::bind_rows(irf_rows) |>
  dplyr::arrange(r, q, sample, variable, h)
readr::write_csv(metrics, file.path(out_dir, "candidate_point_metrics.csv"))
readr::write_csv(irfs, file.path(out_dir, "candidate_point_irfs.csv"))

cached <- readRDS("output/irf/irf_coherence_cell.rds")
reproduced <- irfs |>
  dplyr::filter(sample == "full", r == 7L, q == 6L) |>
  dplyr::mutate(index = match(variable, cached$var_names))
cached_headline <- dplyr::bind_rows(lapply(seq_len(nrow(reproduced)), function(index) {
  row <- reproduced[index, ]
  tibble::tibble(
    sample = row$sample,
    r = row$r,
    q = row$q,
    variable = row$variable,
    h = row$h,
    point = cached$irf$irf_point_matrix[row$index, row$h + 1L]
  )
}))
comparison <- dplyr::inner_join(
  reproduced |>
    dplyr::select(sample, r, q, variable, h, reproduced = point),
  cached_headline |>
    dplyr::rename(cached = point),
  by = c("sample", "r", "q", "variable", "h")
) |>
  dplyr::mutate(
    absolute_difference = abs(reproduced - cached),
    tolerance = 1e-10 + 1e-9 * pmax(abs(reproduced), abs(cached)),
    passed = absolute_difference <= tolerance
  )
stopifnot(
  nrow(comparison) == 245L,
  all(comparison$passed),
  abs(metrics$max_companion_root[metrics$sample == "full" & metrics$r == 7L & metrics$q == 6L] -
      cached$dfm_max_eig) <= 1e-10 + 1e-9 * abs(cached$dfm_max_eig)
)
readr::write_csv(comparison, file.path(out_dir, "production_point_reproduction.csv"))

cat("Candidate point audit passed.\n")
print(metrics)
cat("Maximum cached (7,6) point difference:", max(comparison$absolute_difference), "\n")
