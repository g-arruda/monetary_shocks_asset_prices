# Wild bootstrap for one deduplicated finalist in the joint audit.

arguments <- commandArgs(trailingOnly = TRUE)
if (length(arguments) != 3L) {
  stop(paste(
    "Usage: Rscript diagnostics/rq_block_dimension_audit/scripts/03_bootstrap_finalist.R",
    "<variant> <r> <q>"
  ))
}
variant <- arguments[1]
r <- as.integer(arguments[2])
q <- as.integer(arguments[3])
if (is.na(r) || is.na(q) || r < 1L || r > 8L || q < 1L || q > r) {
  stop("Invalid finalist dimension.")
}

source("R/preprocessing/experimental_extensions.R")
source("R/modeling/factor_estimation.R")
source("diagnostics/rq_block_dimension_audit/scripts/scalar_dynamic_factor_compat.R")
source("R/modeling/impulse_response.R")
source("R/identification/experimental_panel.R")

out_dir <- "diagnostics/rq_block_dimension_audit/output/bootstrap"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
expected_dates <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")

finalists <- readr::read_csv(
  "diagnostics/rq_block_dimension_audit/output/bootstrap_finalists.csv",
  show_col_types = FALSE
)
if (sum(finalists$variant == variant & finalists$r == r & finalists$q == q) != 1L) {
  stop("The requested cell is not a declared deduplicated finalist.")
}

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
  stop("The canonical input must contain 106 finite series over 153 fixed months.")
}
experimental <- build_factorial_drop_block_panels(base_mat, expected_dates, "yield_6m")
if (!(variant %in% names(experimental$panels))) {
  stop("Unknown finalist panel: ", variant, ".")
}
panel <- experimental$panels[[variant]]$matrix
var_names <- colnames(panel)
mpind <- match("yield_6m", var_names)
tcodes <- infer_tcode_from_varnames(var_names)
experimental_index <- match(names(experimental$experimental_inputs$tcodes), var_names)
present <- !is.na(experimental_index)
tcodes[experimental_index[present]] <- experimental$experimental_inputs$tcodes[present]

instrument <- readr::read_csv(
  "data/processed/instrumentos_mensais.csv",
  show_col_types = FALSE
) |>
  dplyr::transmute(month = as.Date(month), shock = z_jk_bs_purif) |>
  dplyr::filter(!is.na(shock))

message("Bootstrap finalist: ", variant, " / (", r, ",", q, ")")
started <- Sys.time()
dfm <- estimate_dfm(
  panel,
  r = r,
  q = q,
  p = 6L,
  dates = dates,
  apply_kilian = TRUE
)
bootstrap_failures <- character()
irf <- withCallingHandlers(
  compute_irf_dfm(
    dfm,
    instrument = instrument,
    h = 48L,
    nboot = 800L,
    bootstrap_seed = 123L,
    mpind = mpind,
    normalize_value = 0.005,
    data_dates = dates,
    tcode = tcodes,
    ci_levels = c(0.68, 0.90),
    var_names = var_names,
    identification = "proxy"
  ),
  warning = function(warning) {
    if (grepl("^Bootstrap iteracao", conditionMessage(warning))) {
      bootstrap_failures <<- c(bootstrap_failures, conditionMessage(warning))
      invokeRestart("muffleWarning")
    }
  }
)
elapsed_minutes <- as.numeric(difftime(Sys.time(), started, units = "mins"))

rows <- dplyr::bind_rows(lapply(headline, function(variable) {
  variable_index <- match(variable, var_names)
  tibble::tibble(
    variant = variant,
    r = r,
    q = q,
    p = 6L,
    variable = variable,
    h = 0:48,
    point = irf$irf_point_matrix[variable_index, ],
    lo68 = irf$ci[["0.68"]]$lower[variable_index, ],
    hi68 = irf$ci[["0.68"]]$upper[variable_index, ],
    lo90 = irf$ci[["0.90"]]$lower[variable_index, ],
    hi90 = irf$ci[["0.90"]]$upper[variable_index, ]
  )
}))
metadata <- tibble::tibble(
  variant = variant,
  r = r,
  q = q,
  p = 6L,
  n_series = ncol(panel),
  n_months = nrow(panel),
  max_companion_root = dfm$diagnostics$max_eigenvalue,
  stable = dfm$diagnostics$is_stable,
  nboot = 800L,
  bootstrap_seed = 123L,
  bootstrap_failures = length(bootstrap_failures),
  elapsed_minutes = elapsed_minutes
)
if (any(!is.finite(as.matrix(rows[c("point", "lo68", "hi68", "lo90", "hi90")]))) ||
    any(rows$lo68 > rows$hi68) || any(rows$lo90 > rows$hi90)) {
  stop("The finalist bootstrap produced invalid confidence bands.")
}

tag <- paste0(variant, "_r", r, "q", q)
readr::write_csv(rows, file.path(out_dir, paste0(tag, "_irf.csv")))
readr::write_csv(metadata, file.path(out_dir, paste0(tag, "_metadata.csv")))
if (length(bootstrap_failures) > 0L) {
  writeLines(bootstrap_failures, file.path(out_dir, paste0(tag, "_failures.txt")))
}
saveRDS(
  list(
    irf = irf,
    var_names = var_names,
    tcode = tcodes,
    mpind = mpind,
    variant = variant,
    r = r,
    q = q,
    p = 6L,
    max_companion_root = dfm$diagnostics$max_eigenvalue,
    bootstrap_failures = bootstrap_failures
  ),
  file.path(out_dir, paste0(tag, ".rds"))
)
message(
  "Completed ", tag, " in ", sprintf("%.2f", elapsed_minutes),
  " minutes with ", length(bootstrap_failures), " failed draws."
)
