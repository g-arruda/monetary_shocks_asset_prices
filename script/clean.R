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
  "expect_focus_selic_12m",
  "expect_focus_pib_12m",
  "expect_focus_cambio_12m",
  "dlsp_exchange_adjustment",
  "expect_focus_fiscal_dlsp_12m",
  "expect_focus_fiscal_primary_balance_12m",
  "expect_focus_fiscal_nominal_balance_12m"
)
# Focus annual series: the raw files hold the next-year (_ny) and
# current-year (_cy) medians, the panel their fixed-horizon combination (_12m)
FOCUS_PANEL_SERIES <- c(
  "expect_focus_selic",
  "expect_focus_pib",
  "expect_focus_cambio"
)
FOCUS_FISCAL_SERIES <- c(
  "expect_focus_fiscal_dlsp",
  "expect_focus_fiscal_primary_balance",
  "expect_focus_fiscal_nominal_balance"
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

# Fixed-horizon approximation of Dovern, Fritsche and Slacalek (2012, eq. 1):
# at the last survey of calendar month m of year y, (12 - m)/12 of the
# current-year median plus m/12 of the next-year one, so December is the
# next-year median alone. The Focus survey closes month m, leaving 12 - m
# months of year y; DFS count the survey month (k = 13 - m) because Consensus
# polls in the first half of it. Where the Focus no longer asks for the
# current-year Selic, the year's last Copom meeting has already set it.
year_end_selic <- readr::read_csv(
  "data/raw/copom_historico.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(year = lubridate::year(data_reuniao_parsed)) |>
  dplyr::group_by(year) |>
  dplyr::slice_max(data_reuniao_parsed, n = 1L) |>
  dplyr::ungroup() |>
  dplyr::select(year, year_end_selic = meta_selic_pct)

focus_next_year <- raw_data |>
  dplyr::select(ref.date, dplyr::all_of(paste0(FOCUS_PANEL_SERIES, "_ny"))) |>
  dplyr::left_join(
    readr::read_csv(
      "data/raw/focus_fiscal_expectations.csv",
      show_col_types = FALSE
    ),
    by = "ref.date"
  ) |>
  tidyr::pivot_longer(
    -ref.date,
    names_to = "series",
    names_pattern = "(.*)_ny",
    values_to = "next_year"
  )
focus_current_year <- readr::read_csv(
  "data/raw/focus_current_year.csv",
  show_col_types = FALSE
) |>
  tidyr::pivot_longer(
    -ref.date,
    names_to = "series",
    names_pattern = "(.*)_cy",
    values_to = "current_year"
  )

focus_fixed_horizon <- focus_next_year |>
  dplyr::left_join(focus_current_year, by = c("ref.date", "series")) |>
  dplyr::mutate(
    year = lubridate::year(ref.date),
    month = lubridate::month(ref.date)
  ) |>
  dplyr::left_join(year_end_selic, by = "year") |>
  dplyr::mutate(
    current_year = dplyr::if_else(
      series == "expect_focus_selic" & month == 11L & is.na(current_year),
      year_end_selic,
      current_year
    ),
    value = dplyr::if_else(
      month == 12L,
      next_year,
      (12 - month) / 12 * current_year + month / 12 * next_year
    )
  )
if (anyNA(focus_fixed_horizon$value)) {
  stop(
    "A current-year Focus median is missing outside December and the ",
    "settled Selic Novembers; re-run script/download_focus_current_year.R."
  )
}
focus_fixed_horizon <- focus_fixed_horizon |>
  dplyr::select(ref.date, series, value) |>
  tidyr::pivot_wider(
    names_from = series,
    values_from = value,
    names_glue = "{series}_12m"
  )

raw_data <- raw_data |>
  dplyr::rename_with(
    \(name) stringr::str_replace(name, "_ny$", "_12m"),
    dplyr::all_of(paste0(FOCUS_PANEL_SERIES, "_ny"))
  ) |>
  dplyr::rows_update(
    focus_fixed_horizon |>
      dplyr::select(ref.date, dplyr::all_of(paste0(FOCUS_PANEL_SERIES, "_12m"))),
    by = "ref.date"
  )

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

extensions <- build_production_extensions(
  expected_dates,
  focus_fixed_horizon |>
    dplyr::select(ref.date, dplyr::all_of(paste0(FOCUS_FISCAL_SERIES, "_12m")))
)
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
  source_file = dplyr::if_else(
    variable %in% paste0(FOCUS_PANEL_SERIES, "_12m"),
    "data/raw/raw_data.csv + data/raw/focus_current_year.csv",
    "data/raw/raw_data.csv"
  ),
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
