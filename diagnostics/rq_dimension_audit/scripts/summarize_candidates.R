out_dir <- "diagnostics/rq_dimension_audit/output"
bootstrap_dir <- file.path(out_dir, "bootstrap")
irf_files <- list.files(bootstrap_dir, pattern = "_irf\\.csv$", full.names = TRUE)
metadata_files <- list.files(bootstrap_dir, pattern = "_metadata\\.csv$", full.names = TRUE)
stopifnot(length(irf_files) == 10L, length(metadata_files) == 10L)

irfs <- dplyr::bind_rows(lapply(irf_files, readr::read_csv, show_col_types = FALSE))
metadata <- dplyr::bind_rows(lapply(metadata_files, readr::read_csv, show_col_types = FALSE))
metrics <- readr::read_csv(file.path(out_dir, "candidate_point_metrics.csv"), show_col_types = FALSE)
stopifnot(
  nrow(irfs) == 10L * 5L * 49L,
  nrow(metadata) == 10L,
  sum(metadata$bootstrap_failures) == 0L,
  all(metadata$stable)
)

theory <- tibble::tribble(
  ~variable, ~window_lo, ~window_hi, ~theory_sign, ~interpretation,
  "yield_6m", 0L, 6L, 1, "positive",
  "yield_2y", 0L, 6L, 1, "positive",
  "yield_5y", 0L, 6L, 1, "positive",
  "asset_ibov", 0L, 6L, -1, "negative",
  "cambio_usd", 0L, 6L, NA, "soft_channel"
)

window_summary <- irfs |>
  dplyr::left_join(theory, by = "variable") |>
  dplyr::filter(h >= window_lo, h <= window_hi) |>
  dplyr::group_by(sample, r, q, variable, theory_sign, interpretation) |>
  dplyr::summarise(
    h0 = point[h == 0L],
    h0_lo68 = lo68[h == 0L],
    h0_hi68 = hi68[h == 0L],
    h0_lo90 = lo90[h == 0L],
    h0_hi90 = hi90[h == 0L],
    positive_horizons = sum(point > 0),
    negative_horizons = sum(point < 0),
    correct_sign_horizons = if (all(is.na(theory_sign))) {
      NA_integer_
    } else {
      sum(sign(point) == dplyr::first(theory_sign))
    },
    correct_sig68_horizons = if (all(is.na(theory_sign))) {
      NA_integer_
    } else {
      sum(sign(point) == dplyr::first(theory_sign) & sig68)
    },
    correct_sig90_horizons = if (all(is.na(theory_sign))) {
      NA_integer_
    } else {
      sum(sign(point) == dplyr::first(theory_sign) & sig90)
    },
    positive_sig68_horizons = sum(point > 0 & sig68),
    positive_sig90_horizons = sum(point > 0 & sig90),
    negative_sig68_horizons = sum(point < 0 & sig68),
    negative_sig90_horizons = sum(point < 0 & sig90),
    peak_abs_h = h[which.max(abs(point))],
    peak_abs_value = point[which.max(abs(point))],
    .groups = "drop"
  ) |>
  dplyr::arrange(r, q, sample, variable)

sample_stability <- irfs |>
  dplyr::filter(h <= 12L) |>
  dplyr::select(sample, r, q, variable, h, point) |>
  tidyr::pivot_wider(names_from = sample, values_from = point) |>
  dplyr::group_by(r, q) |>
  dplyr::summarise(
    sign_agreement_h0_12 = mean(sign(full) == sign(pre_covid)),
    correlation_h0_12 = cor(full, pre_covid),
    normalized_rmse_h0_12 = sqrt(mean((full - pre_covid)^2)) /
      sqrt(mean(full^2)),
    .groups = "drop"
  )

candidate_summary <- metrics |>
  dplyr::select(sample, r, q, xi_mp, f_robust_mp, xi_gt_3_84) |>
  tidyr::pivot_wider(
    names_from = sample,
    values_from = c(xi_mp, f_robust_mp, xi_gt_3_84),
    names_glue = "{.value}_{sample}"
  ) |>
  dplyr::left_join(
    metadata |>
      dplyr::select(sample, r, q, max_companion_root, bootstrap_failures) |>
      tidyr::pivot_wider(
        names_from = sample,
        values_from = c(max_companion_root, bootstrap_failures),
        names_glue = "{.value}_{sample}"
      ),
    by = c("r", "q")
  ) |>
  dplyr::left_join(sample_stability, by = c("r", "q")) |>
  dplyr::mutate(
    admissible_relevance_full = xi_gt_3_84_full,
    bll_distance_full = abs(r - 5L) + abs(q - 3L),
    bll_distance_pre_covid_diagnostic = abs(r - 2L) + abs(q - 2L)
  ) |>
  dplyr::arrange(r, q)

readr::write_csv(window_summary, file.path(out_dir, "candidate_window_summary.csv"))
readr::write_csv(sample_stability, file.path(out_dir, "candidate_sample_stability.csv"))
readr::write_csv(candidate_summary, file.path(out_dir, "candidate_comparison_summary.csv"))

cat("Candidate bootstrap summary passed.\n")
print(candidate_summary, width = Inf)
print(window_summary, n = Inf, width = Inf)
