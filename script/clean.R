source("R/preprocessing/seasonality.R")
source("R/preprocessing/production_extensions.R")
source("R/modeling/impulse_response.R")

SAMPLE_START <- as.Date("2012-03-01")
SAMPLE_END   <- as.Date("2025-12-01")
BASE_PATH       <- "data/processed/data_log_deseasonalized_base_106.csv"
PRODUCTION_PATH <- "data/processed/data_log_deseasonalized.csv"
MANIFEST_PATH   <- "output/panel/production_series_manifest.csv"
# The 115-series production panel is the 106-series base minus these two and
# plus the fiscal and Focus-expectations extensions
BASE_SERIES_REMOVED <- c("juros_cdi", "asset_mlcx")
PRODUCTION_SERIES_ADDED <- c(
  "fiscal_dbgg",
  "fiscal_dlsp",
  "fiscal_primary_balance",
  "expect_focus_ipca12m",
  "expect_focus_selic_ny",
  "expect_focus_pib_ny",
  "expect_focus_cambio_ny",
  "dlsp_exchange_adjustment",
  "expect_focus_fiscal_dlsp_ny",
  "expect_focus_fiscal_primary_balance_ny",
  "expect_focus_fiscal_nominal_balance_ny"
)
# Column order of the panel every output was estimated on. The ABC selector
# subsamples the cross-section in column order and the PCA rounds differently
# under a permutation, so download.R's current order (prices after trab_*,
# fiscal and Focus after epu_*) would move results
PRICE_ORDER <- c(
  "price_ipp", "price_ipca", "price_ipca_difusao", "price_core_ipca_dw",
  "price_igp_m", "price_ipc", "price_core_ipc", "price_incc", "price_inpc",
  "price_core_ipca_ex0", "price_core_ipca_ex1"
)
# X-13 specifications, tried in this order until one returns a full, finite
# series; the manifest records which one worked
X13_SPECS <- list(
  ajustada_completo = list(
    regression.aictest = c("td", "easter"),
    outlier.types = c("AO", "LS", "TC")
  ),
  ajustada_sem_calendario = list(
    regression.aictest = NULL,
    outlier.types = c("AO", "LS", "TC")
  ),
  ajustada_minima = list(outlier = NULL, automdl = NULL)
)

expected_dates <- seq(SAMPLE_START, SAMPLE_END, by = "month")

raw_data <- readr::read_csv("data/raw/raw_data.csv", show_col_types = FALSE) |>
  dplyr::mutate(ref.date = as.Date(ref.date)) |>
  dplyr::filter(ref.date >= SAMPLE_START, ref.date <= SAMPLE_END) |>
  dplyr::relocate(
    dplyr::starts_with(c("fiscal_", "expect_")),
    .before = epu_brazil
  ) |>
  dplyr::relocate(dplyr::all_of(PRICE_ORDER), .after = epu_us)

data <- raw_data |>
  dplyr::mutate(
    dplyr::across(
      c(
        dplyr::contains("base_"),
        dplyr::contains("credit"),
        fin_inst_reserve_req,
        pib
      ),
      log
    )
  )

season_result <- check_seasonality(data)
first_month <- min(data$ref.date)

x13_results <- data |>
  dplyr::select(dplyr::all_of(season_result$season_vars)) |>
  purrr::imap(function(values, variable) {
    series <- ts(
      values,
      start = c(lubridate::year(first_month), lubridate::month(first_month)),
      frequency = 12L
    )
    for (status in names(X13_SPECS)) {
      adjusted <- tryCatch(
        seasonal::seas(
          series,
          x11 = "",
          transform.function = "none",
          list = X13_SPECS[[status]]
        ) |>
          seasonal::final() |>
          as.numeric(),
        error = function(error) NULL
      )
      if (length(adjusted) == length(values) && all(is.finite(adjusted))) {
        return(list(status = status, adjusted = adjusted))
      }
    }
    stop("Every X-13 attempt failed for ", variable, ".")
  })

status_by_series <- purrr::set_names(
  rep("nao_sazonal", ncol(data) - 1L),
  setdiff(names(data), "ref.date")
)
status_by_series[names(x13_results)] <- purrr::map_chr(x13_results, "status")

data <- data |>
  dplyr::mutate(
    dplyr::across(
      dplyr::all_of(season_result$season_vars),
      \(values) x13_results[[dplyr::cur_column()]]$adjusted
    )
  )

extensions <- build_production_extensions(expected_dates)
data <- data |>
  dplyr::left_join(extensions$data, by = "ref.date")

base_data <- data |>
  dplyr::select(-dplyr::all_of(PRODUCTION_SERIES_ADDED))

production_data <- data |>
  dplyr::select(-dplyr::all_of(BASE_SERIES_REMOVED))

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
dir.create(dirname(MANIFEST_PATH), showWarnings = FALSE, recursive = TRUE)
readr::write_csv(base_data, BASE_PATH)
readr::write_csv(production_data, PRODUCTION_PATH)

raw_variables <- setdiff(names(production_data), "ref.date")
logged_variables <- c(
  stringr::str_subset(raw_variables, "^(base_|credit)"),
  "fin_inst_reserve_req",
  "pib"
)
fiscal_variables <- stringr::str_subset(
  PRODUCTION_SERIES_ADDED,
  "^fiscal_|^dlsp_"
)
expectation_variables <- stringr::str_subset(
  PRODUCTION_SERIES_ADDED,
  "^expect_"
)

raw_manifest <- tibble::tibble(
  variable = raw_variables,
  block = dplyr::case_when(
    variable %in% fiscal_variables ~ "fiscal",
    variable %in% expectation_variables ~ "expectativas",
    .default = "painel_historico"
  ),
  source_file = "data/raw/raw_data.csv",
  source_sheet = NA_character_,
  published_label = NA_character_,
  source_id = dplyr::case_when(
    variable == "spread_credito_pj_total" ~ "SGS 20784",
    variable == "spread_credito_pf_total" ~ "SGS 20785",
    .default = NA_character_
  ),
  unit = NA_character_,
  transformation = dplyr::if_else(
    variable %in% logged_variables,
    "log_level",
    "level"
  ),
  tcode = infer_tcode_from_varnames(variable),
  n_months = length(expected_dates),
  first_month = min(expected_dates),
  last_month = max(expected_dates),
  is_seasonal = variable %in% season_result$season_vars,
  seasonal_status = unname(status_by_series[variable])
)

extension_manifest <- extensions$manifest |>
  dplyr::mutate(
    source_id = published_label,
    is_seasonal = seasonal_status != "nao_sazonal"
  ) |>
  dplyr::select(dplyr::all_of(names(raw_manifest)))

raw_manifest |>
  dplyr::rows_update(extension_manifest, by = "variable") |>
  readr::write_csv(MANIFEST_PATH)
