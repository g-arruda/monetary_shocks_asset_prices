out_dir <- "diagnostics/rq_dimension_audit/output"
window_summary <- readr::read_csv(
  file.path(out_dir, "candidate_window_summary.csv"),
  show_col_types = FALSE
)

aggregate <- window_summary |>
  dplyr::group_by(sample, r, q) |>
  dplyr::summarise(
    correct_sign = sum(correct_sign_horizons, na.rm = TRUE),
    correct_sig68 = sum(correct_sig68_horizons, na.rm = TRUE),
    correct_sig90 = sum(correct_sig90_horizons, na.rm = TRUE),
    scored_horizons = sum(!is.na(theory_sign)) * 7L,
    cambio_positive = positive_horizons[variable == "cambio_usd"],
    cambio_sig68 = positive_sig68_horizons[variable == "cambio_usd"],
    cambio_sig90 = positive_sig90_horizons[variable == "cambio_usd"],
    .groups = "drop"
  ) |>
  dplyr::arrange(r, q, sample)

readr::write_csv(aggregate, file.path(out_dir, "candidate_band_aggregate.csv"))
print(aggregate, n = Inf, width = Inf)
