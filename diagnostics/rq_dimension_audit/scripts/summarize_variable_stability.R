out_dir <- "diagnostics/rq_dimension_audit/output"
irf_files <- list.files(
  file.path(out_dir, "bootstrap"),
  pattern = "_irf\\.csv$",
  full.names = TRUE
)
stopifnot(length(irf_files) == 10L)

irfs <- dplyr::bind_rows(lapply(irf_files, readr::read_csv, show_col_types = FALSE))

stability <- irfs |>
  dplyr::filter(h <= 6L) |>
  dplyr::select(sample, r, q, variable, h, point) |>
  tidyr::pivot_wider(names_from = sample, values_from = point) |>
  dplyr::group_by(r, q, variable) |>
  dplyr::summarise(
    sign_agreement = mean(sign(full) == sign(pre_covid)),
    correlation = stats::cor(full, pre_covid),
    normalized_rmse = sqrt(mean((full - pre_covid)^2)) / sqrt(mean(full^2)),
    .groups = "drop"
  ) |>
  dplyr::arrange(r, q, variable)

readr::write_csv(stability, file.path(out_dir, "candidate_variable_stability.csv"))
print(stability, n = Inf, width = Inf)
