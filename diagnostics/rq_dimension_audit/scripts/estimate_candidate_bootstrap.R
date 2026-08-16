source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")

arguments <- commandArgs(trailingOnly = TRUE)
if (length(arguments) != 3L) {
  stop(paste(
    "Usage: Rscript diagnostics/rq_dimension_audit/scripts/estimate_candidate_bootstrap.R",
    "<sample> <r> <q>"
  ))
}

sample_name <- arguments[1]
r <- as.integer(arguments[2])
q <- as.integer(arguments[3])
if (!(sample_name %in% c("full", "pre_covid")) || is.na(r) || is.na(q) || q > r) {
  stop("Invalid bootstrap cell: ", paste(arguments, collapse = " / "))
}

out_dir <- "diagnostics/rq_dimension_audit/output/bootstrap"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
tag <- paste(sample_name, paste0("r", r, "q", q), sep = "_")

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
in_sample <- if (sample_name == "full") {
  dates <= as.Date("2025-09-01")
} else {
  dates <= as.Date("2019-12-01")
}
data_sub <- data[in_sample, , drop = FALSE]
dates_sub <- dates[in_sample]
tcode <- infer_tcode_from_varnames(colnames(data))
mpind <- match("yield_6m", colnames(data))

message("bootstrap DFM: ", sample_name, " / (", r, ",", q, ")")
started <- Sys.time()
dfm <- estimate_dfm(
  data_sub,
  r = r,
  q = q,
  p = 6L,
  dates = dates_sub,
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
    data_dates = dates_sub,
    tcode = tcode,
    ci_levels = c(0.68, 0.90),
    var_names = colnames(data),
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

headline <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
rows <- dplyr::bind_rows(lapply(headline, function(variable) {
  index <- match(variable, colnames(data))
  tibble::tibble(
    sample = sample_name,
    r = r,
    q = q,
    p = 6L,
    variable = variable,
    h = 0:48,
    point = irf$irf_point_matrix[index, ],
    lo68 = irf$ci[["0.68"]]$lower[index, ],
    hi68 = irf$ci[["0.68"]]$upper[index, ],
    lo90 = irf$ci[["0.90"]]$lower[index, ],
    hi90 = irf$ci[["0.90"]]$upper[index, ]
  )
})) |>
  dplyr::mutate(
    sig68 = lo68 > 0 | hi68 < 0,
    sig90 = lo90 > 0 | hi90 < 0
  )

metadata <- tibble::tibble(
  sample = sample_name,
  r = r,
  q = q,
  p = 6L,
  n_series = ncol(data_sub),
  n_months = nrow(data_sub),
  max_companion_root = dfm$diagnostics$max_eigenvalue,
  stable = dfm$diagnostics$is_stable,
  nboot = 800L,
  bootstrap_seed = 123L,
  bootstrap_failures = length(bootstrap_failures),
  elapsed_minutes = elapsed_minutes
)

readr::write_csv(rows, file.path(out_dir, paste0(tag, "_irf.csv")))
readr::write_csv(metadata, file.path(out_dir, paste0(tag, "_metadata.csv")))
if (length(bootstrap_failures) > 0L) {
  writeLines(bootstrap_failures, file.path(out_dir, paste0(tag, "_failures.txt")))
}
saveRDS(
  list(
    irf = irf,
    var_names = colnames(data),
    tcode = tcode,
    mpind = mpind,
    sample = sample_name,
    r = r,
    q = q,
    p = 6L,
    dfm_max_eig = dfm$diagnostics$max_eigenvalue,
    bootstrap_failures = bootstrap_failures
  ),
  file.path(out_dir, paste0(tag, ".rds"))
)

message(
  "completed ", tag, " in ", sprintf("%.2f", elapsed_minutes),
  " minutes with ", length(bootstrap_failures), " failed draws"
)
