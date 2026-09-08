#' Build the four fiscal and expectations series promoted to production
#'
#' Reads the fixed DLSP workbook and the audited Focus fiscal expectations,
#' verifies the published exchange-adjustment accounting identity, and applies
#' the production seasonal-adjustment cascade to the exchange adjustment.
#'
#' @param expected_dates Complete monthly production sample.
#' @param focus_data Optional current-vintage fiscal Focus data with the three
#'   required expectation columns. When `NULL`, reads the production raw input.
#'
#' @return List with the four-series data frame and its manifest.
#'
#' @examples
#' extensions <- build_production_extensions(
#'   seq(as.Date("2012-03-01"), as.Date("2025-12-01"), by = "month")
#' )
build_production_extensions <- function(expected_dates, focus_data = NULL) {
  focus_names <- c(
    "expect_focus_fiscal_dlsp_ny",
    "expect_focus_fiscal_primary_balance_ny",
    "expect_focus_fiscal_nominal_balance_ny"
  )
  focus <- if (is.null(focus_data)) {
    readr::read_csv(
      "data/raw/focus_fiscal_expectations.csv",
      show_col_types = FALSE
    )
  } else {
    focus_data
  } |>
    dplyr::mutate(ref.date = as.Date(ref.date)) |>
    dplyr::select(ref.date, dplyr::all_of(focus_names))

  raw_dlsp <- suppressMessages(readxl::read_excel(
    "data/raw/DLSP/Evodlp.xlsx",
    sheet = "Fluxos mensais",
    col_names = FALSE,
    .name_repair = "minimal"
  ))
  month_numbers <- c(
    janeiro = 1L, fevereiro = 2L, "março" = 3L, abril = 4L,
    maio = 5L, junho = 6L, julho = 7L, agosto = 8L, setembro = 9L,
    outubro = 10L, novembro = 11L, dezembro = 12L
  )
  headers <- tibble::tibble(
    column = seq_len(ncol(raw_dlsp)),
    year = suppressWarnings(as.integer(as.character(unlist(raw_dlsp[5, ])))),
    month_name = tolower(as.character(unlist(raw_dlsp[7, ])))
  ) |>
    tidyr::fill(year, .direction = "down") |>
    dplyr::mutate(month = unname(month_numbers[month_name])) |>
    dplyr::filter(!is.na(year), !is.na(month)) |>
    dplyr::mutate(ref.date = as.Date(sprintf("%04d-%02d-01", year, month)))
  labels <- c(
    dlsp_exchange_adjustment = "Ajuste cambial",
    dlsp_fx_internal_indexed = "Dívida interna indexada ao câmbio",
    dlsp_fx_external_methodological = "Dívida externa - metodológico"
  )
  rows <- match(unname(labels), as.character(raw_dlsp[[1]]))
  if (anyNA(rows) || anyDuplicated(rows)) {
    stop("The published exchange-adjustment rows are missing or ambiguous.")
  }
  values <- purrr::map_dfc(seq_along(labels), function(index) {
    tibble::tibble(
      !!names(labels)[index] := as.numeric(unlist(raw_dlsp[rows[index], headers$column]))
    )
  })
  exchange <- dplyr::bind_cols(headers |> dplyr::select(ref.date), values) |>
    dplyr::filter(ref.date >= min(expected_dates), ref.date <= max(expected_dates)) |>
    dplyr::arrange(ref.date) |>
    dplyr::mutate(
      rounding_difference = dlsp_exchange_adjustment -
        dlsp_fx_internal_indexed - dlsp_fx_external_methodological
    )
  if (!identical(exchange$ref.date, expected_dates) ||
      any(!is.finite(as.matrix(exchange[, -1]))) ||
      max(abs(exchange$rounding_difference)) > 0.1) {
    stop("Ajuste cambial does not equal its two published sublines within rounding tolerance.")
  }

  seasonal <- isTRUE(seastests::isSeasonal(exchange$dlsp_exchange_adjustment, freq = 12L))
  adjustment_status <- "nao_sazonal"
  adjusted_exchange <- exchange$dlsp_exchange_adjustment
  if (seasonal) {
    series <- ts(
      adjusted_exchange,
      start = c(
        lubridate::year(min(expected_dates)),
        lubridate::month(min(expected_dates))
      ),
      frequency = 12L
    )
    attempts <- list(
      ajustada_completo = function() seasonal::seas(
        series, x11 = "", transform.function = "none",
        regression.aictest = c("td", "easter"), outlier.types = c("AO", "LS", "TC")
      ) |> seasonal::final() |> as.numeric(),
      ajustada_sem_calendario = function() seasonal::seas(
        series, x11 = "", transform.function = "none",
        regression.aictest = NULL, outlier.types = c("AO", "LS", "TC")
      ) |> seasonal::final() |> as.numeric(),
      ajustada_minima = function() seasonal::seas(
        series, x11 = "", transform.function = "none", outlier = NULL
      ) |> seasonal::final() |> as.numeric()
    )
    for (status in names(attempts)) {
      candidate <- tryCatch(attempts[[status]](), error = function(error) NULL)
      if (!is.null(candidate) && length(candidate) == length(series) &&
          all(is.finite(candidate))) {
        adjusted_exchange <- candidate
        adjustment_status <- status
        break
      }
    }
    if (adjustment_status == "nao_sazonal") {
      stop("All X-13 attempts failed for dlsp_exchange_adjustment.")
    }
  }
  data <- tibble::tibble(
    ref.date = expected_dates,
    dlsp_exchange_adjustment = adjusted_exchange
  ) |>
    dplyr::left_join(focus, by = "ref.date")
  if (anyDuplicated(names(data)) || anyNA(data) || any(!is.finite(as.matrix(data[, -1])))) {
    stop("The four promoted production series are incomplete, duplicated, or non-finite.")
  }
  manifest <- tibble::tribble(
    ~variable, ~block, ~source_file, ~source_sheet, ~published_label, ~unit, ~transformation, ~tcode, ~seasonal_status,
    "dlsp_exchange_adjustment", "fiscal", "data/raw/DLSP/Evodlp.xlsx", "Fluxos mensais", "Ajuste cambial", "R$ milhões", "level", 1L, adjustment_status,
    "expect_focus_fiscal_dlsp_ny", "expectativas", "data/raw/focus_fiscal_expectations.csv", NA_character_, "Dívida líquida do setor público; ano seguinte", "% do PIB", "level", 1L, "nao_sazonal",
    "expect_focus_fiscal_primary_balance_ny", "expectativas", "data/raw/focus_fiscal_expectations.csv", NA_character_, "Resultado primário; ano seguinte", "% do PIB", "level", 1L, "nao_sazonal",
    "expect_focus_fiscal_nominal_balance_ny", "expectativas", "data/raw/focus_fiscal_expectations.csv", NA_character_, "Resultado nominal; ano seguinte", "% do PIB", "level", 1L, "nao_sazonal"
  ) |>
    dplyr::mutate(
      n_months = length(expected_dates),
      first_month = min(expected_dates),
      last_month = max(expected_dates)
    )
  list(data = data, manifest = manifest)
}
