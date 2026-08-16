#' Return the complete inventory proposed for the missing panel blocks
#'
#' @return Tibble with implemented, reused, excluded, and blocked series.
#'
#' @examples
#' inventory <- panel_candidate_inventory()
panel_candidate_inventory <- function() {
  candidate_dir <- "data/raw/panel_candidates"

  tibble::tribble(
    ~block, ~id, ~name, ~source, ~unit, ~source_frequency, ~status, ~file, ~producer, ~reason,
    "fiscal", "13762", "Dívida bruta do governo geral (% PIB) - Metodologia utilizada a partir de 2008", "BCB/SGS", "Percentual", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_13762.csv"), "R/data_download/bcb.R", "Série corrente; o SGS não permite reconstruir o vintage disponível em tempo real.",
    "fiscal", "4513", "Dívida Líquida do Setor Público (% PIB) - Total - Setor público consolidado", "BCB/SGS", "Percentual", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_4513.csv"), "R/data_download/bcb.R", "Série corrente; o SGS não permite reconstruir o vintage disponível em tempo real.",
    "fiscal", "4649", "NFSP sem desvalorização cambial - Fluxo mensal corrente - Resultado primário - Total - Setor público consolidado", "BCB/SGS", "Milhões de reais", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_4649.csv"), "R/data_download/bcb.R", "Muda de sinal e não admite log; série corrente sem reconstrução de vintage em tempo real.",
    "setor_externo", "23079", "Transações Correntes acumulado em 12 meses em relação ao PIB - mensal", "BCB/SGS", "Percentual", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_23079.csv"), "R/data_download/bcb.R", "Escolhida em vez do saldo mensal 22701 para manter o bloco pequeno.",
    "setor_externo", "22708", "Exportação de bens - Balanço de Pagamentos - mensal", "BCB/SGS", "Milhões de dólares americanos", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_22708.csv"), "R/data_download/bcb.R", "Total de bens no BPM6; o saldo 22707 é excluído para evitar identidade exata.",
    "setor_externo", "22709", "Importação de bens - Balanço de Pagamentos - mensal", "BCB/SGS", "Milhões de dólares americanos", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_22709.csv"), "R/data_download/bcb.R", "Total de bens no BPM6; o saldo 22707 é excluído para evitar identidade exata.",
    "setor_externo", "3546", "Reservas internacionais - Total - mensal", "BCB/SGS", "US$ (milhões)", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_3546.csv"), "R/data_download/bcb.R", "Conceito liquidez; nível mensal.",
    "expectativas", "FOCUS_IPCA12M", "Expectativa Focus para IPCA suavizado nos próximos 12 meses", "BCB/Focus Olinda", "Percentual", "diária", "novo download necessário", file.path(candidate_dir, "focus_ipca12m.csv"), "R/data_download/focus_fred.R", "Última mediana publicada dentro de cada mês; sem revisão retrospectiva.",
    "expectativas", "FOCUS_SELIC_NY", "Expectativa Focus para Selic no fim do ano seguinte", "BCB/Focus Olinda", "Percentual ao ano", "diária", "novo download necessário", file.path(candidate_dir, "focus_selic_ny.csv"), "R/data_download/focus_fred.R", "Última mediana publicada dentro de cada mês para horizonte de ano seguinte.",
    "expectativas", "FOCUS_PIB_NY", "Expectativa Focus para PIB Total no ano seguinte", "BCB/Focus Olinda", "Variação percentual anual", "diária", "novo download necessário", file.path(candidate_dir, "focus_pib_ny.csv"), "R/data_download/focus_fred.R", "Última mediana publicada dentro de cada mês para horizonte de ano seguinte.",
    "expectativas", "FOCUS_CAMBIO_NY", "Expectativa Focus para câmbio no fim do ano seguinte", "BCB/Focus Olinda", "R$/US$", "diária", "novo download necessário", file.path(candidate_dir, "focus_cambio_ny.csv"), "R/data_download/focus_fred.R", "Última mediana publicada dentro de cada mês para horizonte de ano seguinte.",
    "eua", "DGS10", "Market Yield on U.S. Treasury Securities at 10-Year Constant Maturity, Quoted on an Investment Basis", "Federal Reserve Board via FRED", "Percentual", "diária", "novo download necessário", file.path(candidate_dir, "fred_DGS10.csv"), "R/data_download/focus_fred.R", "Última observação disponível dentro de cada mês.",
    "eua", "FEDFUNDS", "Federal Funds Effective Rate", "Federal Reserve Board via FRED", "Percentual", "mensal", "novo download necessário", file.path(candidate_dir, "fred_FEDFUNDS.csv"), "R/data_download/focus_fred.R", "Média mensal de observações diárias publicada pela fonte.",
    "eua", "DTWEXBGS", "Nominal Broad U.S. Dollar Index", "Federal Reserve Board via FRED", "Índice jan/2006=100", "diária", "novo download necessário", file.path(candidate_dir, "fred_DTWEXBGS.csv"), "R/data_download/focus_fred.R", "Última observação disponível dentro de cada mês.",
    "credito", "21082", "Inadimplência da carteira de crédito - Total", "BCB/SGS", "Percentual", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_21082.csv"), "R/data_download/bcb.R", "Agregado; não abre modalidades de crédito.",
    "credito", "20714", "Taxa média de juros das operações de crédito - Total", "BCB/SGS", "Percentual ao ano", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_20714.csv"), "R/data_download/bcb.R", "Agregado; não abre modalidades de crédito.",
    "imoveis", "21340", "Índice de Valores de Garantia de Imóveis Residenciais Financiados (IVG-R)", "BCB/SGS", "Índice", "mensal", "novo download necessário", file.path(candidate_dir, "sgs_21340.csv"), "R/data_download/bcb.R", "Candidata única do bloco imobiliário.",
    "eua", "DGS2", "Market Yield on U.S. Treasury Securities at 2-Year Constant Maturity, Quoted on an Investment Basis", "Federal Reserve Board via FRED", "Percentual", "diária", "já disponível em produtor existente no repositório", "data/raw/fred_dgs2.csv", "R/data_download/focus_fred.R", "Reutilizar o arquivo diário existente; não baixar uma duplicata candidata.",
    "eua", "^GSPC", "S&P 500 Index", "Yahoo Finance", "Índice", "diária", "já disponível em produtor existente no repositório", "data/raw/investing/external_factors_daily.csv", "R/data_download/external_factors.R", "Reutilizar a coluna sp500 com cobertura integral; SP500 do FRED é proibido.",
    "eua", "T10Y2Y", "10-Year Treasury Constant Maturity Minus 2-Year Treasury Constant Maturity", "FRED", "Pontos percentuais", "diária", "deliberadamente excluída", NA_character_, NA_character_, "Diferença linear exata entre DGS10 e DGS2.",
    "eua", "SP500", "S&P 500", "FRED", "Índice", "diária", "deliberadamente excluída", NA_character_, NA_character_, "Cobertura começa em 2016-08 e truncaria 43 meses; Yahoo ^GSPC já existe.",
    "setor_externo", "22701", "Transações correntes - mensal - saldo", "BCB/SGS", "Milhões de dólares americanos", "mensal", "deliberadamente excluída", NA_character_, NA_character_, "23079 foi escolhida para representar transações correntes sem ampliar o bloco.",
    "setor_externo", "22702", "Transações correntes - mensal - receita", "BCB/SGS", "Milhões de dólares americanos", "mensal", "deliberadamente excluída", NA_character_, NA_character_, "Perna da identidade 22701 = 22702 - 22703; 23079 representa transações correntes.",
    "setor_externo", "22703", "Transações correntes - mensal - despesa", "BCB/SGS", "Milhões de dólares americanos", "mensal", "deliberadamente excluída", NA_character_, NA_character_, "Perna da identidade 22701 = 22702 - 22703; 23079 representa transações correntes.",
    "setor_externo", "22707", "Balança comercial - Balanço de Pagamentos - saldo", "BCB/SGS", "Milhões de dólares americanos", "mensal", "deliberadamente excluída", NA_character_, NA_character_, "Identidade exata 22707 = 22708 - 22709.",
    "setor_externo", "22710", "Balança comercial - mercadorias em geral - Balanço de Pagamentos - mensal - saldo", "BCB/SGS", "Milhões de dólares americanos", "mensal", "deliberadamente excluída", NA_character_, NA_character_, "Identidade exata 22710 = 22711 - 22712; a infraestrutura seleciona o total de bens 22708/22709.",
    "setor_externo", "22711/22712", "Exportações/importações de bens - mercadorias em geral", "BCB/SGS", "Milhões de dólares americanos", "mensal", "deliberadamente excluída", NA_character_, NA_character_, "Subcomponentes de mercadorias em geral; 22708/22709 são os totais de bens selecionados.",
    "setor_externo", "termos_de_troca", "Termos de troca FUNCEX", "FUNCEX", NA_character_, NA_character_, "bloqueada por ambiguidade de definição", NA_character_, NA_character_, "A nota não fixa série, unidade, endpoint nem tratamento.",
    "setor_externo", "atividade_chinesa", "Indicador de atividade chinesa", NA_character_, NA_character_, NA_character_, "bloqueada por ambiguidade de definição", NA_character_, NA_character_, "A nota não define indicador ou fonte oficial.",
    "credito", "modalidades_credito", "Taxas, captação e risco por modalidade", "BCB", NA_character_, NA_character_, "deliberadamente excluída", NA_character_, NA_character_, "Família ampla violaria o princípio de blocos pequenos e sobrepesaria crédito."
  ) |>
    dplyr::mutate(
      metadata_url = dplyr::case_when(
        source == "BCB/SGS" ~ paste0(
          "https://www3.bcb.gov.br/sgspub/consultarvalores/consultarValoresSeries.do?",
          "method=consultarGraficoPorId&hdOidSeriesSelecionadas=",
          id
        ),
        id %in% c("DGS2", "DGS10", "FEDFUNDS", "DTWEXBGS", "T10Y2Y", "SP500") ~ paste0(
          "https://fred.stlouisfed.org/series/",
          id
        ),
        id == "^GSPC" ~ "https://finance.yahoo.com/quote/%5EGSPC/history/",
        stringr::str_starts(id, "FOCUS_") ~ "https://dadosabertos.bcb.gov.br/dataset/expectativas-mercado",
        TRUE ~ NA_character_
    )
  )
}

#' Confirm FRED names, units, and source frequencies on official series pages
#'
#' @return Invisibly returns `TRUE`.
#'
#' @examples
#' verify_fred_metadata()
verify_fred_metadata <- function() {
  expected <- tibble::tribble(
    ~id, ~name, ~unit, ~frequency,
    "DGS2", "Market Yield on U.S. Treasury Securities at 2-Year Constant Maturity, Quoted on an Investment Basis", "Percent", "Daily",
    "DGS10", "Market Yield on U.S. Treasury Securities at 10-Year Constant Maturity, Quoted on an Investment Basis", "Percent", "Daily",
    "FEDFUNDS", "Federal Funds Effective Rate", "Percent", "Monthly",
    "DTWEXBGS", "Nominal Broad U.S. Dollar Index", "Index Jan 2006=100", "Daily"
  )

  purrr::pwalk(expected, function(id, name, unit, frequency) {
    text <- rvest::read_html(paste0("https://fred.stlouisfed.org/series/", id)) |>
      rvest::html_text2()
    required <- c(id, name, unit, frequency, "Board of Governors of the Federal Reserve System")
    missing <- required[!stringr::str_detect(text, stringr::fixed(required))]
    if (length(missing) > 0) {
      stop(
        "FRED metadata for ", id, " did not confirm: ",
        paste(missing, collapse = ", "),
        "."
      )
    }
  })

  invisible(TRUE)
}

#' Validate one monthly candidate series against the fixed research sample
#'
#' @param data Candidate data frame.
#' @param id Series identifier used in error messages.
#'
#' @return Invisibly returns `TRUE`.
#'
#' @examples
#' dates <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
#' validate_monthly_candidate(data.frame(ref.date = dates, value = seq_along(dates)), "example")
validate_monthly_candidate <- function(data, id) {
  required <- c("ref.date", "value")
  if (!all(required %in% names(data))) {
    stop(id, " must contain columns ref.date and value.")
  }

  expected_dates <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
  if (anyNA(data$ref.date) || anyDuplicated(data$ref.date)) {
    stop(id, " contains invalid or duplicated monthly dates.")
  }
  if (!identical(as.Date(data$ref.date), expected_dates)) {
    missing_dates <- setdiff(expected_dates, as.Date(data$ref.date))
    extra_dates <- setdiff(as.Date(data$ref.date), expected_dates)
    stop(
      id,
      " does not cover exactly 2013-01 through 2025-09. Missing: ",
      paste(missing_dates, collapse = ", "),
      "; extra: ",
      paste(extra_dates, collapse = ", "),
      "."
    )
  }
  if (anyNA(data$value) || any(!is.finite(data$value))) {
    stop(id, " contains missing or non-finite values.")
  }

  invisible(TRUE)
}

#' Confirm declared SGS metadata against the BCB open-data catalog
#'
#' @param inventory Candidate inventory.
#'
#' @return Invisibly returns `TRUE` after exact code, name, unit, and frequency checks.
#'
#' @examples
#' verify_sgs_metadata(panel_candidate_inventory())
verify_sgs_metadata <- function(inventory) {
  declared <- inventory |>
    dplyr::filter(source == "BCB/SGS", status == "novo download necessário")

  purrr::pwalk(
    declared,
    function(block, id, name, source, unit, source_frequency, status, file,
             producer, reason, metadata_url) {
      if (id == "3546") {
        tables <- rvest::read_html(metadata_url) |>
          rvest::html_table(fill = TRUE)
        table <- tables[purrr::map_lgl(
          tables,
          ~ any(as.matrix(.x) == id, na.rm = TRUE)
        )]
        if (length(table) != 1) {
          stop("BCB SGS metadata page did not confirm code 3546.")
        }
        values <- as.character(unlist(table[[1]], use.names = FALSE))
        if (!all(c(
          "3546",
          "International reserves - Total - monthly",
          "US$ (million)",
          "M"
        ) %in% values)) {
          stop("BCB SGS metadata for 3546 does not match code, name, unit, and monthly frequency.")
        }
        return(invisible(NULL))
      }

      catalog_url <- paste0(
        "https://dadosabertos.bcb.gov.br/api/3/action/package_search?q=",
        id
      )
      results <- jsonlite::fromJSON(catalog_url)$result$results |>
        tibble::as_tibble() |>
        dplyr::filter(codigo_sgs == .env$id)

      if (nrow(results) != 1) {
        stop("BCB open-data catalog returned ", nrow(results), " exact matches for SGS ", id, ".")
      }
      if (results$title != name || results$unidade_medida != unit ||
          tolower(results$periodicidade) != "mensal") {
        stop(
          "BCB metadata mismatch for SGS ", id, ": expected '", name, "', '",
          unit, "', monthly."
        )
      }
    }
  )

  invisible(TRUE)
}

#' Select the last observation published inside each month
#'
#' @param data Data frame with source dates and values.
#' @param date_column Name of the source-date column.
#'
#' @return Monthly tibble with `ref.date`, `source_date`, and `value`.
#'
#' @examples
#' monthly <- last_observation_in_month(data.frame(date = as.Date("2025-01-31"), value = 1))
last_observation_in_month <- function(data, date_column = "date") {
  data |>
    dplyr::mutate(
      source_date = as.Date(.data[[date_column]]),
      ref.date = as.Date(format(source_date, "%Y-%m-01"))
    ) |>
    dplyr::filter(
      ref.date >= as.Date("2013-01-01"),
      ref.date <= as.Date("2025-09-01")
    ) |>
    dplyr::group_by(ref.date) |>
    dplyr::slice_max(source_date, n = 1, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::select(ref.date, source_date, value) |>
    dplyr::arrange(ref.date)
}

#' Download and write all selected SGS candidates
#'
#' @param inventory Candidate inventory.
#'
#' @return Invisibly returns the written paths.
#'
#' @examples
#' download_sgs_candidates(panel_candidate_inventory())
download_sgs_candidates <- function(inventory) {
  declared <- inventory |>
    dplyr::filter(source == "BCB/SGS", status == "novo download necessário")
  series_names <- paste0("sgs_", declared$id)
  ids <- stats::setNames(as.integer(declared$id), series_names)
  downloaded <- download_bcb_data(
    ids,
    start_date = "2013-01-01",
    end_date = "2025-09-01",
    parallel = FALSE
  )

  purrr::pwalk(
    list(id = declared$id, column = series_names, file = declared$file),
    function(id, column, file) {
      series <- downloaded |>
        dplyr::transmute(ref.date, value = .data[[column]])
      validate_monthly_candidate(series, paste0("SGS ", id))
      readr::write_csv(series, file)
    }
  )

  invisible(declared$file)
}

#' Download and write the four monthly Focus candidate series
#'
#' @param inventory Candidate inventory.
#'
#' @return Invisibly returns the written paths.
#'
#' @examples
#' download_focus_candidates(panel_candidate_inventory())
download_focus_candidates <- function(inventory) {
  ipca <- fetch_olinda(
    endpoint = "ExpectativasMercadoInflacao12Meses",
    filter = paste0(
      "Indicador eq 'IPCA' and Suavizada eq 'S' and baseCalculo eq 0 ",
      "and Data ge '2012-01-01' and Data le '2025-09-30'"
    ),
    select = "Indicador,Data,Mediana"
  ) |>
    dplyr::filter(Indicador == "IPCA") |>
    dplyr::transmute(date = as.Date(Data), value = as.numeric(Mediana)) |>
    dplyr::distinct(date, .keep_all = TRUE) |>
    last_observation_in_month()

  annual_ids <- c(
    "Selic" = "FOCUS_SELIC_NY",
    "PIB Total" = "FOCUS_PIB_NY",
    "Câmbio" = "FOCUS_CAMBIO_NY"
  )
  annual <- purrr::imap(
    annual_ids,
    function(id, indicator) {
      fetch_olinda(
        endpoint = "ExpectativasMercadoAnuais",
        filter = sprintf(
          paste0(
            "Indicador eq '%s' and baseCalculo eq 0 ",
            "and Data ge '2012-01-01' and Data le '2025-09-30'"
          ),
          indicator
        ),
        select = "Indicador,Data,DataReferencia,Mediana"
      ) |>
        dplyr::filter(Indicador == indicator) |>
        dplyr::transmute(
          date = as.Date(Data),
          reference_year = as.integer(DataReferencia),
          value = as.numeric(Mediana)
        ) |>
        dplyr::filter(reference_year == as.integer(format(date, "%Y")) + 1L) |>
        dplyr::arrange(date) |>
        dplyr::distinct(date, .keep_all = TRUE) |>
        last_observation_in_month() |>
        dplyr::mutate(reference_year = as.integer(format(ref.date, "%Y")) + 1L) |>
        dplyr::select(ref.date, source_date, reference_year, value)
    }
  )
  names(annual) <- unname(annual_ids)

  series <- c(list(FOCUS_IPCA12M = ipca), annual)
  purrr::iwalk(series, function(data, id) {
    file <- inventory$file[inventory$id == id]
    validate_monthly_candidate(data, id)
    readr::write_csv(data, file)
  })

  invisible(inventory$file[inventory$id %in% names(series)])
}

#' Download and write the selected monthly FRED candidates
#'
#' @param inventory Candidate inventory.
#'
#' @return Invisibly returns the written paths.
#'
#' @examples
#' download_fred_candidates(panel_candidate_inventory())
download_fred_candidates <- function(inventory) {
  ids <- c("DGS10", "FEDFUNDS", "DTWEXBGS")

  purrr::walk(ids, function(id) {
    series <- download_fred_series(
      id,
      from = "2012-01-01",
      to = "2025-09-30"
    ) |>
      last_observation_in_month()
    file <- inventory$file[inventory$id == id]
    validate_monthly_candidate(series, paste0("FRED ", id))
    readr::write_csv(series, file)
  })

  invisible(inventory$file[inventory$id %in% ids])
}

#' Confirm coverage of candidate inputs already produced in the repository
#'
#' @return Invisibly returns `TRUE`.
#'
#' @examples
#' validate_reused_candidate_inputs()
validate_reused_candidate_inputs <- function() {
  required <- c(
    "data/raw/fred_dgs2.csv",
    "data/raw/investing/external_factors_daily.csv"
  )
  missing <- required[!file.exists(required)]
  if (length(missing) > 0) {
    stop(
      "Existing candidate inputs are missing: ",
      paste(missing, collapse = ", "),
      ". Run their declared producers; no fallback source is allowed."
    )
  }

  dgs2 <- readr::read_csv(required[1], show_col_types = FALSE) |>
    dplyr::transmute(date = as.Date(date), value = as.numeric(ust2y)) |>
    last_observation_in_month()
  validate_monthly_candidate(dgs2, "existing FRED DGS2")

  sp500 <- readr::read_csv(required[2], show_col_types = FALSE) |>
    dplyr::transmute(date = as.Date(date), value = as.numeric(sp500)) |>
    dplyr::filter(!is.na(value)) |>
    last_observation_in_month()
  validate_monthly_candidate(sp500, "existing Yahoo ^GSPC")

  invisible(TRUE)
}

#' Write the candidate inventory and provenance report
#'
#' @param inventory Candidate inventory.
#'
#' @return Invisibly returns the report paths.
#'
#' @examples
#' write_candidate_provenance(panel_candidate_inventory())
write_candidate_provenance <- function(inventory) {
  dir.create("output/download", showWarnings = FALSE, recursive = TRUE)
  inventory_path <- "output/download/panel_candidate_inventory.csv"
  report_path <- "output/download/panel_candidate_download_report.md"
  readr::write_csv(inventory, inventory_path)

  implemented <- inventory |>
    dplyr::filter(status == "novo download necessário")
  reused <- inventory |>
    dplyr::filter(status == "já disponível em produtor existente no repositório")
  omitted <- inventory |>
    dplyr::filter(status %in% c("deliberadamente excluída", "bloqueada por ambiguidade de definição"))

  implemented_rows <- paste0(
    "| ", implemented$block, " | ", implemented$id, " | ", implemented$name, " | ",
    implemented$source, " | ", implemented$unit, " | ", implemented$source_frequency, " | ",
    implemented$file, " | ", implemented$producer, " | ", implemented$reason, " |"
  )
  reused_rows <- paste0(
    "| ", reused$block, " | ", reused$id, " | ", reused$name, " | ",
    reused$source, " | ", reused$unit, " | ", reused$source_frequency, " | ",
    reused$file, " | ", reused$producer, " | ", reused$reason, " |"
  )

  report <- c(
    "# Infraestrutura de download das candidatas ao painel",
    "",
    paste0("> Gerado por `Rscript script/download.R --candidates-only` em ", Sys.Date(), "."),
    "> Estes arquivos não integram `data/raw/raw_data.csv` e não alteram o painel de produção.",
    "",
    "## Séries coletadas",
    "",
    "| bloco | código/ID | nome oficial | fonte | unidade | frequência na fonte | arquivo | produtor | ressalva |",
    "|---|---|---|---|---|---|---|---|---|",
    implemented_rows,
    "",
    "## Insumos existentes reutilizados",
    "",
    "| bloco | código/ID | nome oficial | fonte | unidade | frequência na fonte | arquivo | produtor | ressalva |",
    "|---|---|---|---|---|---|---|---|---|",
    reused_rows,
    "",
    "## Exclusões e bloqueios",
    "",
    "| bloco | código/ID | nome | status | motivo |",
    "|---|---|---|---|---|",
    paste0(
      "| ", omitted$block, " | ", omitted$id, " | ", omitted$name, " | ",
      omitted$status, " | ", omitted$reason, " |"
    ),
    "",
    "## Limitação de vintage fiscal",
    "",
    "Os arquivos SGS fiscais contêm a vintage corrente recuperada na data de execução. O produtor público",
    "consultado não fornece a sequência de vintages disponível em tempo real para cada mês de referência;",
    "portanto, esta infraestrutura não autoriza interpretar essas séries como informação conhecida no mês.",
    "",
    "## Validações embutidas",
    "",
    "Antes de gravar, o subestágio confirma os metadados SGS na fonte oficial, exige exatamente 153 meses",
    "de 2013-01 a 2025-09, datas únicas, valores finitos e ausência de lacunas. Focus usa a última publicação",
    "dentro de cada mês. A validação independente é `Rscript script/validate_candidate_downloads.R`."
  )
  writeLines(report, report_path, useBytes = TRUE)

  invisible(c(inventory_path, report_path))
}

#' Run the isolated download substage for proposed panel candidates
#'
#' @return Invisibly returns the complete inventory.
#'
#' @examples
#' download_panel_candidates()
download_panel_candidates <- function() {
  inventory <- panel_candidate_inventory()
  dir.create("data/raw/panel_candidates", showWarnings = FALSE, recursive = TRUE)

  verify_sgs_metadata(inventory)
  verify_fred_metadata()
  download_sgs_candidates(inventory)
  download_focus_candidates(inventory)
  download_fred_candidates(inventory)
  validate_reused_candidate_inputs()
  write_candidate_provenance(inventory)

  message("Candidate downloads validated without changing data/raw/raw_data.csv.")
  invisible(inventory)
}

#' Validate all written candidate files and optionally reconfirm SGS metadata
#'
#' @param verify_metadata Whether to query authoritative BCB metadata again.
#'
#' @return Invisibly returns `TRUE`.
#'
#' @examples
#' validate_panel_candidate_outputs(verify_metadata = FALSE)
validate_panel_candidate_outputs <- function(verify_metadata = TRUE) {
  inventory <- panel_candidate_inventory()
  implemented <- inventory |>
    dplyr::filter(status == "novo download necessário")
  missing <- implemented$file[!file.exists(implemented$file)]

  if (length(missing) > 0) {
    stop("Candidate outputs are missing: ", paste(missing, collapse = ", "), ".")
  }
  if (verify_metadata) {
    verify_sgs_metadata(inventory)
    verify_fred_metadata()
  }

  purrr::pwalk(
    list(id = implemented$id, file = implemented$file),
    function(id, file) {
      data <- readr::read_csv(file, show_col_types = FALSE)
      validate_monthly_candidate(data, id)
    }
  )
  validate_reused_candidate_inputs()

  message(sprintf(
    "Validated %d candidate series and 2 reused inputs over 2013-01 to 2025-09.",
    nrow(implemented)
  ))
  invisible(TRUE)
}
