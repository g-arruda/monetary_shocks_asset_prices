source("R/data_download/panel_candidates.R")
source("R/preprocessing/panel_candidates.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/experimental_panel.R")

out_dir <- "diagnostics/rq_dimension_audit/output"
panel_dir <- file.path(out_dir, "panels")
dir.create(panel_dir, recursive = TRUE, showWarnings = FALSE)

expected_dates <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
base <- readr::read_csv(
  "data/processed/data_log_deseasonalized_base_106.csv",
  show_col_types = FALSE
)
stopifnot(
  identical(as.Date(base$ref.date), expected_dates),
  nrow(base) == 153L,
  ncol(base) == 107L,
  !anyNA(base),
  all(is.finite(as.matrix(base[, -1])))
)

dates <- as.Date(base$ref.date)
base_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
experimental <- build_factorial_drop_block_panels(
  base_mat,
  expected_dates,
  "yield_6m"
)
stopifnot(nrow(experimental$variant_manifest) == 64L)

samples <- list(
  full = dates <= as.Date("2025-09-01"),
  pre_covid = dates <= as.Date("2019-12-01")
)

selection_rows <- list()
bai_ng_rows <- list()
aw_rows <- list()
eigen_rows <- list()
aw_eigen_rows <- list()
sensitivity_rows <- list()
row_index <- 0L

for (variant in experimental$variant_manifest$variant) {
  panel <- experimental$panels[[variant]]$matrix
  readr::write_csv(
    tibble::as_tibble(panel) |>
      dplyr::mutate(ref.date = dates, .before = 1),
    file.path(panel_dir, paste0(variant, ".csv.gz"))
  )

  for (sample_name in names(samples)) {
    message("factor selection: ", variant, " / ", sample_name)
    data_sub <- panel[samples[[sample_name]], , drop = FALSE]
    diff_std <- diff(data_sub)
    diff_sd <- apply(diff_std, 2, sd)
    stopifnot(
      nrow(data_sub) %in% c(153L, 84L),
      all(is.finite(data_sub)),
      all(is.finite(diff_sd)),
      all(diff_sd > 0)
    )

    bai_ng <- bai_ng_criteria(data_sub, max_r = 20L, apply_bll = TRUE)
    r_ic2 <- bai_ng$r_hat$IC2
    aw <- amengual_watson(
      data_sub,
      r = r_ic2,
      p = 6L,
      max_q = r_ic2,
      apply_bll = TRUE
    )

    row_index <- row_index + 1L
    selection_rows[[row_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      n_series = ncol(data_sub),
      n_months = nrow(data_sub),
      r_ic1 = bai_ng$r_hat$IC1,
      r_ic2 = r_ic2,
      r_ic3 = bai_ng$r_hat$IC3,
      q_aw_ic2 = aw$q_hat
    )
    bai_ng_rows[[row_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      r = seq_len(20L),
      ic1 = bai_ng$criteria$IC1,
      ic2 = bai_ng$criteria$IC2,
      ic3 = bai_ng$criteria$IC3
    )
    eigen_rows[[row_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      component = seq_len(20L),
      eigenvalue = bai_ng$pca$sdev[seq_len(20L)]^2
    )
    aw_rows[[row_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      q = seq_len(r_ic2),
      aw_ic2 = aw$aw
    )

    x_std <- sweep(
      sweep(diff(data_sub), 2, colMeans(diff(data_sub)), "-"),
      2,
      apply(diff(data_sub), 2, sd),
      "/"
    )
    factor_scores <- prcomp(x_std, scale. = FALSE, center = FALSE)$x[, seq_len(r_ic2), drop = FALSE]
    lagged_factors <- stats::embed(factor_scores, 7L)
    design <- cbind(1, lagged_factors[, -seq_len(r_ic2), drop = FALSE])
    residuals <- x_std[7:nrow(x_std), , drop = FALSE] -
      design %*% solve(crossprod(design), crossprod(design, x_std[7:nrow(x_std), , drop = FALSE]))
    residual_pca <- prcomp(residuals, scale. = FALSE, center = FALSE)
    aw_eigen_rows[[row_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      component = seq_len(r_ic2),
      eigenvalue = residual_pca$sdev[seq_len(r_ic2)]^2
    )

    conventions <- list(
      p6_cap_r = c(p = 6L, max_q = r_ic2),
      p6_max15 = c(p = 6L, max_q = 15L),
      p12_cap_r = c(p = 12L, max_q = r_ic2),
      p12_max15 = c(p = 12L, max_q = 15L)
    )
    sensitivity_rows[[row_index]] <- dplyr::bind_rows(lapply(
      names(conventions),
      function(convention) {
        setting <- conventions[[convention]]
        result <- tryCatch(
          amengual_watson(
            data_sub,
            r = r_ic2,
            p = setting[["p"]],
            max_q = setting[["max_q"]],
            apply_bll = TRUE
          ),
          error = function(error) error
        )
        if (inherits(result, "error")) {
          return(tibble::tibble(
            variant = variant,
            sample = sample_name,
            r_ic2 = r_ic2,
            convention = convention,
            p = setting[["p"]],
            max_q = setting[["max_q"]],
            q_hat = NA_integer_,
            q_gt_r = NA,
            failure = conditionMessage(result)
          ))
        }
        tibble::tibble(
          variant = variant,
          sample = sample_name,
          r_ic2 = r_ic2,
          convention = convention,
          p = setting[["p"]],
          max_q = setting[["max_q"]],
          q_hat = result$q_hat,
          q_gt_r = result$q_hat > r_ic2,
          failure = NA_character_
        )
      }
    ))
  }
}

selection <- dplyr::bind_rows(selection_rows) |>
  dplyr::arrange(variant, sample)
bai_ng_grid <- dplyr::bind_rows(bai_ng_rows) |>
  dplyr::arrange(variant, sample, r)
aw_grid <- dplyr::bind_rows(aw_rows) |>
  dplyr::arrange(variant, sample, q)
eigen_grid <- dplyr::bind_rows(eigen_rows) |>
  dplyr::arrange(variant, sample, component)
aw_eigen_grid <- dplyr::bind_rows(aw_eigen_rows) |>
  dplyr::arrange(variant, sample, component)
sensitivity <- dplyr::bind_rows(sensitivity_rows) |>
  dplyr::arrange(variant, sample, convention)

saved_selection <- readr::read_csv(
  "output/panel_experimental/rq_grid_drop_blocks/factor_selection/factor_selection_cells.csv",
  show_col_types = FALSE
) |>
  dplyr::select(-r_ic3_at_upper_bound, -p_aw)
saved_bai_ng <- readr::read_csv(
  "output/panel_experimental/rq_grid_drop_blocks/factor_selection/bai_ng_bll_criteria.csv",
  show_col_types = FALSE
)
saved_aw <- readr::read_csv(
  "output/panel_experimental/rq_grid_drop_blocks/factor_selection/amengual_watson_criteria.csv",
  show_col_types = FALSE
) |>
  dplyr::select(-r_ic2)

stopifnot(
  isTRUE(all.equal(selection, saved_selection, tolerance = 0, check.attributes = FALSE)),
  isTRUE(all.equal(bai_ng_grid, saved_bai_ng, tolerance = 1e-13, check.attributes = FALSE)),
  isTRUE(all.equal(aw_grid, saved_aw, tolerance = 1e-13, check.attributes = FALSE))
)

readr::write_csv(selection, file.path(out_dir, "r_selection.csv"))
readr::write_csv(bai_ng_grid, file.path(out_dir, "r_bai_ng_criteria.csv"))
readr::write_csv(aw_grid, file.path(out_dir, "r_aw_criteria.csv"))
readr::write_csv(eigen_grid, file.path(out_dir, "r_bai_ng_eigenvalues.csv"))
readr::write_csv(aw_eigen_grid, file.path(out_dir, "r_aw_eigenvalues.csv"))
readr::write_csv(sensitivity, file.path(out_dir, "aw_convention_sensitivity.csv"))

canonical_rows <- list()
test_rows <- list()
canonical_index <- 0L
test_index <- 0L
for (sample_name in names(samples)) {
  data_sub <- base_mat[samples[[sample_name]], , drop = FALSE]
  bai_ng <- bai_ng_criteria(data_sub, max_r = 20L, apply_bll = TRUE)
  r_ic2 <- bai_ng$r_hat$IC2
  for (p_lags in c(6L, 12L)) {
    for (max_q in c(r_ic2, 15L)) {
      aw <- amengual_watson(
        data_sub,
        r = r_ic2,
        p = p_lags,
        max_q = max_q,
        apply_bll = TRUE
      )
      canonical_index <- canonical_index + 1L
      canonical_rows[[canonical_index]] <- tibble::tibble(
        sample = sample_name,
        n_series = ncol(data_sub),
        n_months = nrow(data_sub),
        r_ic1 = bai_ng$r_hat$IC1,
        r_ic2 = r_ic2,
        r_ic3 = bai_ng$r_hat$IC3,
        p_aw = p_lags,
        max_q = max_q,
        q_aw_ic2 = aw$q_hat,
        q_gt_r = aw$q_hat > r_ic2
      )
    }
  }

  diff_std <- diff(data_sub)
  diff_std <- sweep(diff_std, 2, colMeans(diff_std), "-")
  diff_std <- sweep(diff_std, 2, apply(diff_std, 2, sd), "/")
  for (variable in colnames(diff_std)) {
    adf <- tseries::adf.test(diff_std[, variable], alternative = "stationary")
    pp <- tseries::pp.test(diff_std[, variable], alternative = "stationary")
    test_index <- test_index + 1L
    test_rows[[test_index]] <- tibble::tibble(
      sample = sample_name,
      variable = variable,
      adf_statistic = unname(adf$statistic),
      adf_p_value = adf$p.value,
      adf_reject_5pct = adf$p.value < 0.05,
      pp_statistic = unname(pp$statistic),
      pp_p_value = pp$p.value,
      pp_reject_5pct = pp$p.value < 0.05
    )
  }
}

canonical <- dplyr::bind_rows(canonical_rows)
stationarity <- dplyr::bind_rows(test_rows)
readr::write_csv(canonical, file.path(out_dir, "canonical_selection.csv"))
readr::write_csv(stationarity, file.path(out_dir, "canonical_difference_stationarity.csv"))

cat("R factor-selection audit passed.\n")
print(canonical)
print(
  sensitivity |>
    dplyr::group_by(sample, convention) |>
    dplyr::summarise(
      failures = sum(!is.na(failure)),
      q_gt_r = sum(q_gt_r, na.rm = TRUE),
      q_min = min(q_hat, na.rm = TRUE),
      q_max = max(q_hat, na.rm = TRUE),
      .groups = "drop"
    )
)
print(
  stationarity |>
    dplyr::group_by(sample) |>
    dplyr::summarise(
      n_series = dplyr::n(),
      adf_reject_5pct = sum(adf_reject_5pct),
      pp_reject_5pct = sum(pp_reject_5pct),
      both_reject_5pct = sum(adf_reject_5pct & pp_reject_5pct),
      neither_reject_5pct = sum(!adf_reject_5pct & !pp_reject_5pct),
      .groups = "drop"
    )
)
