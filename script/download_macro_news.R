# ===================================================================
# Raw inputs of the macroeconomic news block of the Bauer-Swanson (2023,
# Table 3) pre-event regression: the Focus panels of monthly IPCA and
# quarterly GDP expectations, the released IPCA and EX0 core (SGS), and GDP
# as first released by IBGE. A stage of its own so that it runs without
# re-downloading the production panel of script/download.R.
#
# GDP comes from the release PDFs because SIDRA keeps only the revised
# vintage, and a revision made after a Copom meeting is not news the market
# had before it. The Focus quarterly median is the growth over the same
# quarter of the previous year, the rate read from Table I.1 of each release.
# ===================================================================

source("R/data_download/bcb.R")
source("R/data_download/focus.R")

# The first Copom of the sample (2012-03-07) takes the releases since the
# previous meeting; the Focus panel runs past the last one (2025-12-10) so
# that every release inside the sample has its last survey on record.
FOCUS_START  <- as.Date("2010-01-01")
FOCUS_END    <- as.Date("2026-01-31")
SGS_START    <- "2010-01-01"
SGS_END      <- "2025-12-01"
GDP_QUARTERS <- seq(as.Date("2011-10-01"), as.Date("2025-07-01"), by = "quarter")
IBGE_CNT_URL <- paste0(
  "https://ftp.ibge.gov.br/Contas_Nacionais/Contas_Nacionais_Trimestrais/",
  "Fasciculo_Indicadores_IBGE"
)

focus_ipca <- fetch_olinda(
  endpoint = "ExpectativaMercadoMensais",
  filter = sprintf(
    paste0(
      "Indicador eq 'IPCA' and baseCalculo eq 0 ",
      "and Data ge '%s' and Data le '%s'"
    ),
    FOCUS_START,
    FOCUS_END
  ),
  select = "Indicador,Data,DataReferencia,Mediana"
) |>
  dplyr::filter(Indicador == "IPCA") |>
  dplyr::transmute(
    indicator = "ipca",
    date = as.Date(Data),
    reference = lubridate::my(DataReferencia),
    median = as.numeric(Mediana)
  )

# DataReferencia is "<quarter>/<year>"; the reference is the quarter's first day
focus_gdp <- fetch_olinda(
  endpoint = "ExpectativasMercadoTrimestrais",
  filter = sprintf(
    paste0(
      "Indicador eq 'PIB Total' and baseCalculo eq 0 ",
      "and Data ge '%s' and Data le '%s'"
    ),
    FOCUS_START,
    FOCUS_END
  ),
  select = "Indicador,Data,DataReferencia,Mediana"
) |>
  dplyr::filter(Indicador == "PIB Total") |>
  dplyr::transmute(
    indicator = "gdp",
    date = as.Date(Data),
    reference = lubridate::make_date(
      as.integer(stringr::str_extract(DataReferencia, "\\d{4}$")),
      3L * as.integer(stringr::str_extract(DataReferencia, "^\\d")) - 2L,
      1L
    ),
    median = as.numeric(Mediana)
  )

# SGS 433: IPCA, monthly % change; SGS 11427: EX0 core (excludes food at home
# and administered prices), the analogue of BS's core CPI
ipca_released <- download_bcb_data(
  c(433, 11427),
  start_date = SGS_START,
  end_date = SGS_END
) |>
  dplyr::rename(ipca = `id = 433`, ipca_ex0 = `id = 11427`) |>
  tidyr::pivot_longer(
    c(ipca, ipca_ex0),
    names_to = "indicator",
    values_to = "value"
  ) |>
  dplyr::transmute(indicator, reference = ref.date, value)

# Each year's folder lists one release PDF per quarter; 2019Q4 carries a
# timestamp suffix, hence the listing rather than a fixed file name
gdp_first_release <- tibble::tibble(reference = GDP_QUARTERS) |>
  dplyr::mutate(
    year = lubridate::year(reference),
    quarter = lubridate::quarter(reference)
  ) |>
  dplyr::mutate(
    file = purrr::map2_chr(year, quarter, function(year, quarter) {
      listing <- readLines(sprintf("%s/%d/", IBGE_CNT_URL, year), warn = FALSE)
      stringr::str_extract(
        listing,
        sprintf("pib-vol-val_%d%02dcaderno[^\"]*\\.pdf", year, quarter)
      ) |>
        stats::na.omit() |>
        unique()
    }),
    # Table I.1: the row "Trimestre / mesmo trimestre do ano anterior", whose
    # last column is the quarter just released
    value = purrr::map2_dbl(year, file, function(year, file) {
      pdf_path <- tempfile(fileext = ".pdf")
      download.file(
        sprintf("%s/%d/%s", IBGE_CNT_URL, year, file),
        pdf_path,
        mode = "wb",
        quiet = TRUE
      )
      text <- system2(
        "pdftotext",
        c("-layout", "-f", "1", "-l", "10", pdf_path, "-"),
        stdout = TRUE
      )
      row <- which(stringr::str_detect(
        text,
        "Trimestre / mesmo trimestre do ano\\s*$"
      ))[1]
      stringr::str_extract(text[row + 1], "-?\\d+,\\d+\\s*$") |>
        readr::parse_number(locale = readr::locale(decimal_mark = ","))
    })
  ) |>
  dplyr::transmute(indicator = "gdp", reference, value)

dplyr::bind_rows(focus_ipca, focus_gdp) |>
  dplyr::arrange(indicator, reference, date) |>
  readr::write_csv("data/raw/focus_macro_expectations.csv")

dplyr::bind_rows(ipca_released, gdp_first_release) |>
  dplyr::arrange(indicator, reference) |>
  readr::write_csv("data/raw/macro_released.csv")
