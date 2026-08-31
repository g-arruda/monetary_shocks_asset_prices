#' Return the experimental series used by the historical panel diagnostics
#'
#' The seven production additions are read from the processed production panel.
#' The remaining twelve series are optional experimental extensions and require
#' local files; the production download does not create them.
#'
#' @return Tibble with transformation and local-input metadata for 19 series.
#'
#' @examples
#' manifest <- experimental_series_manifest()
experimental_series_manifest <- function() {
  extension_dir <- "data/raw/experimental_extensions"
  tibble::tribble(
    ~id, ~variable, ~block, ~transform, ~tcode, ~origin, ~file,
    "13762", "fiscal_dbgg", "fiscal", "level", 1L, "production", NA_character_,
    "4513", "fiscal_dlsp", "fiscal", "level", 1L, "production", NA_character_,
    "4649", "fiscal_primary_balance", "fiscal", "level", 1L, "production", NA_character_,
    "23079", "external_current_account_gdp", "setor_externo", "level", 1L, "extension", file.path(extension_dir, "sgs_23079.csv"),
    "22708", "external_exports", "setor_externo", "log_level", 4L, "extension", file.path(extension_dir, "sgs_22708.csv"),
    "22709", "external_imports", "setor_externo", "log_level", 4L, "extension", file.path(extension_dir, "sgs_22709.csv"),
    "3546", "external_reserves", "setor_externo", "log_level", 4L, "extension", file.path(extension_dir, "sgs_3546.csv"),
    "FOCUS_IPCA12M", "expect_focus_ipca12m", "expectativas", "level", 1L, "production", NA_character_,
    "FOCUS_SELIC_NY", "expect_focus_selic_ny", "expectativas", "level", 1L, "production", NA_character_,
    "FOCUS_PIB_NY", "expect_focus_pib_ny", "expectativas", "level", 1L, "production", NA_character_,
    "FOCUS_CAMBIO_NY", "expect_focus_cambio_ny", "expectativas", "level", 1L, "production", NA_character_,
    "DGS2", "us_dgs2", "eua", "level", 1L, "extension", "data/raw/fred_dgs2.csv",
    "DGS10", "us_dgs10", "eua", "level", 1L, "extension", file.path(extension_dir, "fred_DGS10.csv"),
    "FEDFUNDS", "us_fedfunds", "eua", "level", 1L, "extension", file.path(extension_dir, "fred_FEDFUNDS.csv"),
    "DTWEXBGS", "us_dtwexbgs", "eua", "level", 1L, "extension", file.path(extension_dir, "fred_DTWEXBGS.csv"),
    "^GSPC", "asset_sp500_yahoo", "eua", "log_return", 2L, "extension", "data/raw/investing/external_factors_daily.csv",
    "21082", "credit_default_rate", "credito", "level", 1L, "extension", file.path(extension_dir, "sgs_21082.csv"),
    "20714", "credit_average_rate", "credito", "level", 1L, "extension", file.path(extension_dir, "sgs_20714.csv"),
    "21340", "housing_ivgr", "imoveis", "level", 1L, "extension", file.path(extension_dir, "sgs_21340.csv")
  )
}

#' Validate one complete monthly experimental series
#'
#' @param data Data frame with `ref.date` and `value` columns.
#' @param id Series identifier used in error messages.
#' @param expected_dates Fixed research-sample dates.
#'
#' @return Invisibly returns `TRUE`.
#'
#' @examples
#' dates <- seq(as.Date("2025-01-01"), as.Date("2025-03-01"), by = "month")
#' validate_experimental_series(
#'   tibble::tibble(ref.date = dates, value = 1:3),
#'   "example",
#'   dates
#' )
validate_experimental_series <- function(data, id, expected_dates) {
  if (!all(c("ref.date", "value") %in% names(data))) {
    stop(id, " must contain ref.date and value columns.")
  }
  if (!identical(as.Date(data$ref.date), expected_dates) ||
      anyDuplicated(data$ref.date) || anyNA(data$value) ||
      any(!is.finite(data$value))) {
    stop(id, " must cover the complete fixed monthly sample with finite values.")
  }
  invisible(TRUE)
}

#' Apply the project seasonal-adjustment cascade to an experimental extension
#'
#' @param values Complete numeric monthly vector.
#' @param dates Monthly dates aligned with `values`.
#' @param series_name Series name used in errors.
#'
#' @return List with adjusted values and treatment metadata.
#'
#' @examples
#' adjusted <- adjust_extension_seasonality(rep(1, 24),
#'   seq(as.Date("2024-01-01"), by = "month", length.out = 24), "example")
adjust_extension_seasonality <- function(values, dates, series_name) {
  if (length(values) != length(dates) || anyNA(values) || any(!is.finite(values))) {
    stop("Experimental series ", series_name, " is incomplete or non-finite.")
  }
  seasonal <- isTRUE(seastests::isSeasonal(values, freq = 12L))
  if (!seasonal) {
    return(list(values = values, is_seasonal = FALSE, status = "nao_sazonal"))
  }

  series <- ts(values, start = c(lubridate::year(min(dates)), 1L), frequency = 12L)
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
      seasonal::seas(series, x11 = "", transform.function = "none", outlier = NULL) |>
        seasonal::final() |>
        as.numeric()
    }
  )
  for (status in names(attempts)) {
    adjusted <- tryCatch(attempts[[status]](), error = function(error) NULL)
    if (!is.null(adjusted) && length(adjusted) == length(values) &&
        all(is.finite(adjusted))) {
      return(list(values = adjusted, is_seasonal = TRUE, status = status))
    }
  }
  stop("All X-13 attempts failed for experimental series ", series_name, ".")
}

#' Select the last daily observation in each research-sample month
#'
#' @param data Daily data with `date` and `value` columns.
#' @param expected_dates Fixed research-sample dates.
#'
#' @return Monthly tibble with `ref.date` and `value`.
#'
#' @examples
#' monthly <- last_extension_observation_in_month(
#'   tibble::tibble(date = as.Date("2025-01-31"), value = 1),
#'   as.Date("2025-01-01")
#' )
last_extension_observation_in_month <- function(data, expected_dates) {
  data |>
    dplyr::mutate(ref.date = lubridate::floor_date(date, "month")) |>
    dplyr::filter(ref.date >= min(expected_dates), ref.date <= max(expected_dates)) |>
    dplyr::group_by(ref.date) |>
    dplyr::slice_max(date, n = 1L, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::select(ref.date, value) |>
    dplyr::arrange(ref.date)
}

#' Build the 19-series input used by historical experimental panel diagnostics
#'
#' @param expected_dates Fixed monthly dates for the research sample.
#'
#' @return List with matrix, treatments, block labels, and tcodes.
#'
#' @examples
#' inputs <- build_experimental_inputs(
#'   seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
#' )
build_experimental_inputs <- function(expected_dates) {
  manifest <- experimental_series_manifest()
  production <- readr::read_csv(
    "data/processed/data_log_deseasonalized.csv",
    show_col_types = FALSE
  ) |>
    dplyr::mutate(ref.date = as.Date(ref.date))
  if (!identical(production$ref.date, expected_dates)) {
    stop("The processed production panel does not match the experimental sample.")
  }

  missing_extensions <- manifest |>
    dplyr::filter(origin == "extension", !file.exists(file)) |>
    dplyr::pull(file)
  if (length(missing_extensions) > 0L) {
    stop(
      "Required local experimental extensions are missing: ",
      paste(missing_extensions, collapse = ", "),
      ". The production downloader does not create rejected extensions."
    )
  }

  values <- vector("list", nrow(manifest))
  treatments <- vector("list", nrow(manifest))
  for (index in seq_len(nrow(manifest))) {
    specification <- manifest[index, ]
    if (specification$origin == "production") {
      if (!(specification$variable %in% names(production))) {
        stop("Production series is missing: ", specification$variable, ".")
      }
      values[[index]] <- production[[specification$variable]]
      treatments[[index]] <- dplyr::bind_cols(
        specification,
        tibble::tibble(is_seasonal = NA, seasonal_status = "production_processed")
      )
      next
    }

    if (specification$id == "DGS2") {
      raw <- readr::read_csv(specification$file, show_col_types = FALSE) |>
        dplyr::transmute(date = as.Date(date), value = as.numeric(ust2y)) |>
        last_extension_observation_in_month(expected_dates)
    } else if (specification$id == "^GSPC") {
      raw <- readr::read_csv(specification$file, show_col_types = FALSE) |>
        dplyr::transmute(date = as.Date(date), value = as.numeric(sp500)) |>
        dplyr::filter(!is.na(value), date >= min(expected_dates) - 31L) |>
        dplyr::mutate(ref.date = lubridate::floor_date(date, "month")) |>
        dplyr::group_by(ref.date) |>
        dplyr::slice_max(date, n = 1L, with_ties = FALSE) |>
        dplyr::ungroup() |>
        dplyr::arrange(ref.date) |>
        dplyr::mutate(value = c(NA_real_, diff(log(value)))) |>
        dplyr::filter(ref.date >= min(expected_dates), ref.date <= max(expected_dates)) |>
        dplyr::select(ref.date, value)
    } else {
      raw <- readr::read_csv(specification$file, show_col_types = FALSE) |>
        dplyr::transmute(ref.date = as.Date(ref.date), value = as.numeric(value)) |>
        dplyr::arrange(ref.date)
    }
    validate_experimental_series(raw, specification$id, expected_dates)

    transformed <- raw$value
    if (specification$transform == "log_level") {
      if (any(transformed <= 0)) {
        stop("Cannot log non-positive extension ", specification$variable, ".")
      }
      transformed <- log(transformed)
    }
    adjusted <- adjust_extension_seasonality(
      transformed,
      raw$ref.date,
      specification$variable
    )
    values[[index]] <- adjusted$values
    treatments[[index]] <- dplyr::bind_cols(
      specification,
      tibble::tibble(
        is_seasonal = adjusted$is_seasonal,
        seasonal_status = adjusted$status
      )
    )
  }

  matrix <- do.call(cbind, values)
  colnames(matrix) <- manifest$variable
  if (nrow(matrix) != length(expected_dates) || any(!is.finite(matrix)) ||
      anyDuplicated(colnames(matrix))) {
    stop("The historical experimental input matrix is invalid.")
  }

  list(
    matrix = matrix,
    treatments = dplyr::bind_rows(treatments),
    blocks = stats::setNames(manifest$block, manifest$variable),
    tcodes = stats::setNames(manifest$tcode, manifest$variable)
  )
}
