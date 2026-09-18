rm(list = ls())

source("R/preprocessing/seasonality.R")
source("R/preprocessing/production_extensions.R")
source("R/modeling/production_spec.R")

spec <- production_spec()
expected_dates <- seq(spec$sample[1], spec$sample[2], by = "month")
raw_data <- readr::read_csv("data/raw/raw_data.csv", show_col_types = FALSE) |>
  dplyr::mutate(ref.date = as.Date(ref.date)) |>
  dplyr::filter(ref.date >= spec$sample[1], ref.date <= spec$sample[2])

data <- raw_data |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(
        dplyr::contains("base_"),
        dplyr::contains("credit"),
        fin_inst_reserve_req,
        pib
      ),
      .fns = log
    )
  )

season_result <- check_seasonality(data)
series_log <- setNames(
  rep("nao_sazonal", ncol(data) - 1L),
  setdiff(names(data), "ref.date")
)
adjusted_data <- data |>
  dplyr::select(dplyr::all_of(season_result$season_vars)) |>
  purrr::imap(function(values, variable) {
    series <- ts(
      values,
      start = c(
        lubridate::year(min(data$ref.date)),
        lubridate::month(min(data$ref.date))
      ),
      frequency = 12L
    )
    attempts <- list(
      ajustada_completo = function() {
        seasonal::seas(
          series,
          x11 = "",
          transform.function = "none",
          regression.aictest = c("td", "easter"),
          outlier.types = c("AO", "LS", "TC")
        ) |>
          seasonal::final() |>
          as.numeric()
      },
      ajustada_sem_calendario = function() {
        seasonal::seas(
          series,
          x11 = "",
          transform.function = "none",
          regression.aictest = NULL,
          outlier.types = c("AO", "LS", "TC")
        ) |>
          seasonal::final() |>
          as.numeric()
      },
      ajustada_minima = function() {
        seasonal::seas(
          series,
          x11 = "",
          transform.function = "none",
          outlier = NULL,
          automdl = NULL
        ) |>
          seasonal::final() |>
          as.numeric()
      }
    )

    for (status in names(attempts)) {
      adjusted <- tryCatch(attempts[[status]](), error = function(error) NULL)
      if (!is.null(adjusted) && length(adjusted) == length(values) &&
          all(is.finite(adjusted))) {
        series_log[[variable]] <<- status
        return(adjusted)
      }
    }
    stop("Every X-13 attempt failed for ", variable, ".")
  }) |>
  tibble::as_tibble()

data <- data |>
  dplyr::mutate(
    dplyr::across(
      dplyr::all_of(season_result$season_vars),
      ~ adjusted_data[[dplyr::cur_column()]]
    )
  )

extensions <- build_production_extensions(expected_dates)
data <- data |>
  dplyr::left_join(extensions$data, by = "ref.date")

base_data <- data |>
  dplyr::select(-dplyr::all_of(spec$production_series_added))

production_data <- data |>
  dplyr::select(-dplyr::all_of(spec$base_series_removed))

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
dir.create("output/panel", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(base_data, spec$base_data_path)
readr::write_csv(production_data, spec$data_path)

raw_variables <- setdiff(names(production_data), "ref.date")
logged_variables <- c(
  grep("^(base_|credit)", raw_variables, value = TRUE),
  "fin_inst_reserve_req", "pib"
)
raw_manifest <- tibble::tibble(
  variable = raw_variables,
  block = dplyr::case_when(
    variable %in% spec$production_series_added[grepl("^fiscal_|^dlsp_", spec$production_series_added)] ~ "fiscal",
    variable %in% spec$production_series_added[grepl("^expect_", spec$production_series_added)] ~ "expectativas",
    TRUE ~ "painel_historico"
  ),
  source_file = "data/raw/raw_data.csv",
  source_sheet = NA_character_,
  published_label = NA_character_,
  source_id = dplyr::case_when(
    variable == "spread_credito_pj_total" ~ "SGS 20784",
    variable == "spread_credito_pf_total" ~ "SGS 20785",
    TRUE ~ NA_character_
  ),
  unit = NA_character_,
  transformation = ifelse(variable %in% logged_variables, "log_level", "level"),
  tcode = ifelse(variable %in% logged_variables, 2L, 1L),
  n_months = length(expected_dates),
  first_month = min(expected_dates),
  last_month = max(expected_dates),
  is_seasonal = variable %in% season_result$season_vars,
  seasonal_status = unname(series_log[variable])
)
production_manifest <- raw_manifest |>
  dplyr::rows_update(
    extensions$manifest |>
      dplyr::mutate(
        source_id = published_label,
        is_seasonal = seasonal_status != "nao_sazonal"
      ) |>
      dplyr::select(dplyr::all_of(names(raw_manifest))),
    by = "variable"
  )
readr::write_csv(production_manifest, "output/panel/production_series_manifest.csv")
