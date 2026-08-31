rm(list = ls())

source("R/preprocessing/seasonality.R")
source("R/modeling/production_spec.R")

spec <- production_spec()
expected_dates <- seq(spec$sample[1], spec$sample[2], by = "month")
raw_data <- readr::read_csv("data/raw/raw_data.csv", show_col_types = FALSE) |>
  dplyr::mutate(ref.date = as.Date(ref.date)) |>
  dplyr::filter(ref.date >= spec$sample[1], ref.date <= spec$sample[2])

if (!identical(raw_data$ref.date, expected_dates) || ncol(raw_data) - 1L != 113L ||
    anyDuplicated(names(raw_data)) || anyNA(raw_data) ||
    any(!is.finite(as.matrix(raw_data[, -1])))) {
  stop("The raw input must contain 113 unique finite series over the fixed 153 months.")
}
if (!all(spec$production_series_added %in% names(raw_data))) {
  stop("The raw input does not contain all seven series added to production.")
}

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
if (any(!is.finite(as.matrix(data[, -1])))) {
  stop("Log transformations produced non-finite values.")
}

season_result <- check_seasonality(data)
series_log <- stats::setNames(
  rep("nao_sazonal", ncol(data) - 1L),
  setdiff(names(data), "ref.date")
)
adjusted_data <- data |>
  dplyr::select(dplyr::all_of(season_result$season_vars)) |>
  purrr::imap(function(values, variable) {
    series <- ts(
      values,
      start = c(lubridate::year(min(data$ref.date)), 1L),
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
          outlier = NULL
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
    series_log[[variable]] <<- "SEM_AJUSTE: todas_as_tentativas_X13_falharam"
    as.numeric(series)
  }) |>
  tibble::as_tibble()

data <- data |>
  dplyr::mutate(
    dplyr::across(
      dplyr::all_of(season_result$season_vars),
      ~ adjusted_data[[dplyr::cur_column()]]
    )
  )

base_data <- data |>
  dplyr::select(-dplyr::all_of(spec$production_series_added))
if (ncol(base_data) - 1L != 106L || any(!is.finite(as.matrix(base_data[, -1])))) {
  stop("The processed historical base must contain 106 finite series.")
}

production_data <- data |>
  dplyr::select(-dplyr::all_of(spec$base_series_removed))
if (ncol(production_data) - 1L != spec$n_series ||
    anyDuplicated(names(production_data)) ||
    !all(spec$required_series %in% names(production_data)) ||
    any(spec$excluded_series %in% names(production_data)) ||
    any(!is.finite(as.matrix(production_data[, -1])))) {
  stop("The processed production panel does not match the 111-series specification.")
}

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
dir.create("output/panel", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(base_data, spec$base_data_path)
readr::write_csv(production_data, spec$data_path)

production_manifest <- tibble::tibble(
  variable = spec$production_series_added,
  block = c(rep("fiscal", 3L), rep("expectativas", 4L)),
  transformation = "level",
  tcode = 1L,
  n_months = length(expected_dates),
  first_month = min(expected_dates),
  last_month = max(expected_dates),
  is_seasonal = spec$production_series_added %in% season_result$season_vars,
  seasonal_status = unname(series_log[spec$production_series_added])
)
readr::write_csv(production_manifest, "output/panel/production_series_manifest.csv")
