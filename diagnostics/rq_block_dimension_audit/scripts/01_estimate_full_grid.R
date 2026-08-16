# Full-sample point grid for the joint panel and factor-dimension audit.

arguments <- commandArgs(trailingOnly = TRUE)
if (length(arguments) != 2L) {
  stop(paste(
    "Usage: Rscript diagnostics/rq_block_dimension_audit/scripts/01_estimate_full_grid.R",
    "<shard_index> <shard_count>"
  ))
}
shard_index <- as.integer(arguments[1])
shard_count <- as.integer(arguments[2])
if (is.na(shard_index) || is.na(shard_count) || shard_count < 1L ||
    shard_index < 1L || shard_index > shard_count) {
  stop("Invalid shard specification.")
}

source("R/data_download/panel_candidates.R")
source("R/preprocessing/panel_candidates.R")
source("R/modeling/factor_estimation.R")
source("diagnostics/rq_block_dimension_audit/scripts/scalar_dynamic_factor_compat.R")
source("R/modeling/impulse_responde.R")
source("R/identification/experimental_panel.R")
source("R/identification/factor_space_diagnostics.R")

out_dir <- "diagnostics/rq_block_dimension_audit/output/grid_shards"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

expected_dates <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
grid <- dplyr::bind_rows(lapply(1:8, function(r) {
  tibble::tibble(r = r, q = seq_len(r))
}))

base <- readr::read_csv(
  "data/processed/data_log_deseasonalized_base_106.csv",
  show_col_types = FALSE
)
dates <- as.Date(base$ref.date)
base_mat <- base |>
  dplyr::select(-ref.date) |>
  as.matrix()
if (!identical(dates, expected_dates) || ncol(base_mat) != 106L ||
    any(!is.finite(base_mat))) {
  stop("The canonical input must contain 106 finite series over the fixed 153-month sample.")
}

instrument <- readr::read_csv(
  "data/processed/instrumentos_mensais.csv",
  show_col_types = FALSE
) |>
  dplyr::transmute(month = as.Date(month), shock = z_jk_bs_purif) |>
  dplyr::filter(!is.na(shock))
if (anyDuplicated(instrument$month) || any(!is.finite(instrument$shock))) {
  stop("The production instrument has invalid monthly observations.")
}

experimental <- build_factorial_drop_block_panels(base_mat, expected_dates, "yield_6m")
manifest <- experimental$variant_manifest
if (nrow(manifest) != 64L) {
  stop("The factorial design must contain exactly 64 panels.")
}

old_grid <- readr::read_csv(
  "output/panel_experimental/rq_grid_drop_blocks/rq_grid_drop_blocks_cells.csv",
  show_col_types = FALSE
) |>
  dplyr::filter(sample == "full") |>
  dplyr::select(variant, r, q, old_xi_mp = xi_mp)
if (nrow(old_grid) != 1152L || anyDuplicated(old_grid[c("variant", "r", "q")])) {
  stop("The prior full-sample grid must contain 1,152 unique reusable cells.")
}

tasks <- tidyr::crossing(variant = manifest$variant, grid) |>
  dplyr::arrange(variant, r, q) |>
  dplyr::mutate(task_id = dplyr::row_number()) |>
  dplyr::filter((task_id - 1L) %% shard_count + 1L == shard_index)

#' Estimate one point cell and preserve all ranking inputs
#'
#' @param task One row of the shard task table.
#'
#' @return List with cell metrics, five short IRFs, and any explicit failure.
estimate_point_cell <- function(task) {
  variant <- task$variant[[1]]
  r <- task$r[[1]]
  q <- task$q[[1]]
  panel <- experimental$panels[[variant]]$matrix
  var_names <- colnames(panel)
  mpind <- match("yield_6m", var_names)
  tcodes <- infer_tcode_from_varnames(var_names)
  candidate_index <- match(names(experimental$candidate_inputs$tcodes), var_names)
  present <- !is.na(candidate_index)
  tcodes[candidate_index[present]] <- experimental$candidate_inputs$tcodes[present]

  result <- tryCatch({
    dfm <- estimate_dfm(
      panel,
      r = r,
      q = q,
      p = 6L,
      dates = dates,
      apply_kilian = FALSE
    )
    diagnostic <- diagnose_instrument_in_factor_space(
      dfm,
      instrument,
      dates,
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
      data_dates = dates,
      tcode = tcodes,
      ci_levels = c(0.68, 0.90),
      var_names = var_names,
      identification = "proxy"
    )
    old_xi <- old_grid$old_xi_mp[
      old_grid$variant == variant & old_grid$r == r & old_grid$q == q
    ]
    if (length(old_xi) > 1L) {
      stop("The prior-grid lookup is not unique.")
    }
    xi_difference <- if (length(old_xi) == 1L) {
      abs(diagnostic$wald_mp - old_xi)
    } else {
      NA_real_
    }
    if (length(old_xi) == 1L && xi_difference > 1e-10) {
      stop("Prior xi_mp reproduction differs by ", format(xi_difference, scientific = TRUE), ".")
    }

    metrics <- tibble::tibble(
      variant = variant,
      r = r,
      q = q,
      p = 6L,
      n_series = ncol(panel),
      n_months = nrow(panel),
      n_obs_align = diagnostic$n_obs,
      xi_mp = if (length(old_xi) == 1L) old_xi else diagnostic$wald_mp,
      xi_mp_reestimated = diagnostic$wald_mp,
      old_grid_reused = length(old_xi) == 1L,
      old_grid_xi_difference = xi_difference,
      f_robust_mp = diagnostic$f_robust_mp,
      max_companion_root = dfm$diagnostics$max_eigenvalue,
      stable = dfm$diagnostics$is_stable
    )
    irfs <- dplyr::bind_rows(lapply(headline, function(variable) {
      variable_index <- match(variable, var_names)
      tibble::tibble(
        variant = variant,
        r = r,
        q = q,
        variable = variable,
        h = 0:6,
        point = irf$irf_point_matrix[variable_index, ]
      )
    }))
    if (any(!is.finite(as.matrix(metrics[c(
      "xi_mp", "f_robust_mp", "max_companion_root"
    )]))) ||
        any(!is.finite(irfs$point))) {
      stop("The point cell contains a non-finite result.")
    }
    list(metrics = metrics, irfs = irfs, failure = NULL)
  }, error = function(error) {
    list(
      metrics = NULL,
      irfs = NULL,
      failure = tibble::tibble(
        variant = variant,
        r = r,
        q = q,
        p = 6L,
        failure = conditionMessage(error)
      )
    )
  })
  result
}

results <- lapply(seq_len(nrow(tasks)), function(index) {
  task <- tasks[index, ]
  message(
    "[shard ", shard_index, "/", shard_count, "] ", task$task_id,
    "/2304: ", task$variant, " (", task$r, ",", task$q, ")"
  )
  estimate_point_cell(task)
})

metrics <- dplyr::bind_rows(lapply(results, `[[`, "metrics"))
irfs <- dplyr::bind_rows(lapply(results, `[[`, "irfs"))
failures <- dplyr::bind_rows(lapply(results, `[[`, "failure"))

tag <- sprintf("shard_%02d_of_%02d", shard_index, shard_count)
readr::write_csv(metrics, file.path(out_dir, paste0(tag, "_metrics.csv")))
readr::write_csv(irfs, file.path(out_dir, paste0(tag, "_irfs.csv")))
readr::write_csv(
  failures,
  file.path(out_dir, paste0(tag, "_failures.csv"))
)

if (nrow(failures) > 0L) {
  stop("Shard ", shard_index, " has ", nrow(failures), " failed cells.")
}
message("Completed ", tag, " with ", nrow(metrics), " point cells.")
