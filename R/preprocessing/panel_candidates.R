# Reusable preparation of the pre-specified monthly candidate series.

#' Apply the project's seasonal-adjustment cascade to one candidate series
#'
#' @param values Numeric vector with complete monthly coverage.
#' @param dates Monthly Date vector aligned with `values`.
#' @param series_name Candidate name used in diagnostics.
#'
#' @return List with adjusted values, seasonal-test result, and treatment status.
adjust_candidate_seasonality <- function(values, dates, series_name) {
  if (length(values) != length(dates) || anyNA(values) || any(!is.finite(values))) {
    stop("Candidate ", series_name, " is not a complete finite monthly series.")
  }

  seasonal <- isTRUE(seastests::isSeasonal(values, freq = 12))
  if (!seasonal) {
    return(list(values = values, is_seasonal = FALSE, status = "nao_sazonal"))
  }

  series <- stats::ts(values, start = c(lubridate::year(min(dates)), 1), frequency = 12)
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
    adjusted <- tryCatch(attempts[[status]](), error = function(e) NULL)
    if (!is.null(adjusted) && length(adjusted) == length(values) &&
        all(is.finite(adjusted))) {
      return(list(values = adjusted, is_seasonal = TRUE, status = status))
    }
  }

  list(
    values = values,
    is_seasonal = TRUE,
    status = "SEM_AJUSTE: todas_as_tentativas_X13_falharam"
  )
}


#' Read one complete monthly candidate input
#'
#' @param path CSV path.
#' @param id Candidate identifier used in error messages.
#'
#' @return Tibble with exactly `ref.date` and `value`.
read_monthly_candidate <- function(path, id) {
  if (!file.exists(path)) {
    stop("Required candidate input is missing: ", path, ".")
  }
  data <- readr::read_csv(path, show_col_types = FALSE) |>
    dplyr::transmute(ref.date = as.Date(ref.date), value = as.numeric(value)) |>
    dplyr::arrange(ref.date)
  validate_monthly_candidate(data, id)
  data
}


#' Build the candidate matrix and transformation manifest
#'
#' @param expected_dates Fixed monthly dates for the research sample.
#'
#' @return List with candidate matrix, treatment table, block labels, and tcodes.
build_candidate_inputs <- function(expected_dates) {
  inventory <- panel_candidate_inventory()
  selected_ids <- c(
    "13762", "4513", "4649", "23079", "22708", "22709", "3546",
    "FOCUS_IPCA12M", "FOCUS_SELIC_NY", "FOCUS_PIB_NY", "FOCUS_CAMBIO_NY",
    "DGS2", "DGS10", "FEDFUNDS", "DTWEXBGS", "^GSPC", "21082", "20714", "21340"
  )
  selected <- inventory |>
    dplyr::filter(id %in% selected_ids, !is.na(file))
  if (nrow(selected) != length(selected_ids)) {
    stop("The candidate inventory does not contain every pre-specified input.")
  }

  specs <- tibble::tribble(
    ~id, ~variable, ~block, ~transform, ~tcode,
    "13762", "fiscal_dbgg", "fiscal", "level", 1L,
    "4513", "fiscal_dlsp", "fiscal", "level", 1L,
    "4649", "fiscal_primary_balance", "fiscal", "level_no_log", 1L,
    "23079", "external_current_account_gdp", "setor_externo", "level", 1L,
    "22708", "external_exports", "setor_externo", "log_level", 4L,
    "22709", "external_imports", "setor_externo", "log_level", 4L,
    "3546", "external_reserves", "setor_externo", "log_level", 4L,
    "FOCUS_IPCA12M", "expect_focus_ipca12m", "expectativas", "level", 1L,
    "FOCUS_SELIC_NY", "expect_focus_selic_ny", "expectativas", "level", 1L,
    "FOCUS_PIB_NY", "expect_focus_pib_ny", "expectativas", "level", 1L,
    "FOCUS_CAMBIO_NY", "expect_focus_cambio_ny", "expectativas", "level", 1L,
    "DGS2", "us_dgs2", "eua", "level", 1L,
    "DGS10", "us_dgs10", "eua", "level", 1L,
    "FEDFUNDS", "us_fedfunds", "eua", "level", 1L,
    "DTWEXBGS", "us_dtwexbgs", "eua", "level", 1L,
    "^GSPC", "asset_sp500_yahoo", "eua", "log_return", 2L,
    "21082", "credit_default_rate", "credito", "level", 1L,
    "20714", "credit_average_rate", "credito", "level", 1L,
    "21340", "housing_ivgr", "imoveis", "level", 1L
  )

  values <- vector("list", nrow(specs))
  treatments <- vector("list", nrow(specs))
  for (i in seq_len(nrow(specs))) {
    spec <- specs[i, ]
    source <- selected |>
      dplyr::filter(id == spec$id)
    if (nrow(source) != 1) {
      stop("Expected one inventory row for ", spec$id, ".")
    }

    if (spec$id == "DGS2") {
      raw <- readr::read_csv(source$file, show_col_types = FALSE) |>
        dplyr::transmute(date = as.Date(date), value = as.numeric(ust2y)) |>
        last_observation_in_month() |>
        dplyr::select(ref.date, value)
      validate_monthly_candidate(raw, "DGS2")
    } else if (spec$id == "^GSPC") {
      raw <- readr::read_csv(source$file, show_col_types = FALSE) |>
        dplyr::transmute(date = as.Date(date), value = as.numeric(sp500)) |>
        dplyr::filter(!is.na(value), date >= as.Date("2012-12-01")) |>
        dplyr::mutate(ref.date = as.Date(format(date, "%Y-%m-01"))) |>
        dplyr::group_by(ref.date) |>
        dplyr::slice_max(date, n = 1, with_ties = FALSE) |>
        dplyr::ungroup() |>
        dplyr::arrange(ref.date) |>
        dplyr::mutate(value = c(NA_real_, diff(log(value)))) |>
        dplyr::filter(ref.date >= min(expected_dates), ref.date <= max(expected_dates)) |>
        dplyr::select(ref.date, value)
      validate_monthly_candidate(raw, "Yahoo ^GSPC monthly log return")
    } else {
      raw <- read_monthly_candidate(source$file, spec$id)
    }

    transformed <- raw$value
    if (spec$transform == "log_level") {
      if (any(transformed <= 0)) {
        stop("Cannot log non-positive candidate ", spec$variable, ".")
      }
      transformed <- log(transformed)
    }
    adjusted <- adjust_candidate_seasonality(transformed, raw$ref.date, spec$variable)
    values[[i]] <- adjusted$values
    treatments[[i]] <- dplyr::bind_cols(
      spec,
      source |>
        dplyr::select(name, source, unit, source_frequency, file, producer, reason),
      tibble::tibble(
        n_months = length(raw$ref.date),
        first_month = min(raw$ref.date),
        last_month = max(raw$ref.date),
        is_seasonal = adjusted$is_seasonal,
        seasonal_status = adjusted$status
      )
    )
  }

  candidate_mat <- do.call(cbind, values)
  colnames(candidate_mat) <- specs$variable
  if (nrow(candidate_mat) != length(expected_dates) || any(!is.finite(candidate_mat))) {
    stop("Candidate matrix has an invalid research sample.")
  }

  list(
    matrix = candidate_mat,
    treatments = dplyr::bind_rows(treatments),
    blocks = stats::setNames(specs$block, specs$variable),
    tcodes = stats::setNames(specs$tcode, specs$variable)
  )
}
