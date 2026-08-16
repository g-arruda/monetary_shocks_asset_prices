rm(list = ls())

source("R/preprocessing/seasonality.R")
source("R/data_download/panel_candidates.R")
source("R/preprocessing/panel_candidates.R")
source("R/modeling/production_spec.R")
# source("R/preprocessing/stationarity.R")  # arquivo inexistente, chamada morta (padronização BLL ocorre em factor_estimation.R)

spec <- production_spec()

# loading data ----
raw_data <- readr::read_csv("data/raw/raw_data.csv") |>
  dplyr::filter(ref.date >= spec$sample[1], ref.date <= spec$sample[2])

# Descarta colunas totalmente vazias na janela (ex.: break-even ANBIMA sem cache rb3),
# que quebrariam o teste de sazonalidade e o drop_na do DFM.
raw_data <- raw_data |> dplyr::select(dplyr::where(~ !all(is.na(.))))

# Verificar NAs
colSums(is.na(raw_data))





# Apply log transformation in nominal variables ----

data <- raw_data |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(
        dplyr::contains("base_"), # M1, M2, M3, base monetária
        dplyr::contains("credit"), # volumes de crédito
        fin_inst_reserve_req, # reservas bancárias
        pib # PIB acumulado no ano
      ),
      .fns = ~ log(.x)
    )
  )





# Treating data seasonality ----

season_result <- check_seasonality(data)


series_log <- list() # registra status de cada variável

data_no_season <- data |>
  dplyr::select(dplyr::matches(season_result$season_vars)) |>
  purrr::imap(
    ~ {
      serie <- ts(
        .x,
        start = c(lubridate::year(min(data$ref.date)), 1),
        frequency = 12
      )

      # Tentativa 1: completa
      result <- tryCatch(
        {
          out <- seasonal::seas(serie,
            x11 = "", transform.function = "none",
            regression.aictest = c("td", "easter"),
            outlier.types = c("AO", "LS", "TC")
          ) |>
            seasonal::final() |>
            as.numeric()
          series_log[[.y]] <<- "ajustada_completo"
          out
        },
        error = function(e1) {
          # Tentativa 2: sem calendário
          tryCatch(
            {
              out <- seasonal::seas(serie,
                x11 = "", transform.function = "none",
                regression.aictest = NULL,
                outlier.types = c("AO", "LS", "TC")
              ) |>
                seasonal::final() |>
                as.numeric()
              series_log[[.y]] <<- "ajustada_sem_calendario"
              out
            },
            error = function(e2) {
              # Tentativa 3: mínima
              tryCatch(
                {
                  out <- seasonal::seas(serie,
                    x11 = "", transform.function = "none",
                    outlier = NULL
                  ) |>
                    seasonal::final() |>
                    as.numeric()
                  series_log[[.y]] <<- "ajustada_minima"
                  out
                },
                error = function(e3) {
                  series_log[[.y]] <<- paste0("SEM_AJUSTE: ", conditionMessage(e3))
                  as.numeric(serie)
                }
              )
            }
          )
        }
      )
    }
  ) |>
  purrr::map_dfc(~.x)

# Relatório final
status_df <- tibble::tibble(
  variavel = names(series_log),
  status   = unlist(series_log)
)






# Apply seasonal adjustment to identified variables
data <- data |>
  dplyr::mutate(
    dplyr::across(
      dplyr::all_of(season_result$season_vars),
      ~ data_no_season[[dplyr::cur_column()]]
    )
  )


# Persist processed panels ----

expected_dates <- seq(spec$sample[1], spec$sample[2], by = "month")
if (!identical(as.Date(data$ref.date), expected_dates) || ncol(data) - 1L != 106L ||
    any(!is.finite(as.matrix(data[, -1])))) {
  stop("The processed base panel must contain 106 finite series over the fixed 153 months.")
}
readr::write_csv(data, spec$base_data_path)

candidate_inputs <- build_candidate_inputs(expected_dates)
candidate_keep <- names(candidate_inputs$blocks)[
  candidate_inputs$blocks %in% spec$candidate_blocks_kept
]
base_keep <- setdiff(names(data), c("ref.date", spec$base_series_removed))
production_matrix <- cbind(
  as.matrix(data[, base_keep]),
  candidate_inputs$matrix[, candidate_keep, drop = FALSE]
)
if (nrow(production_matrix) != spec$n_months || ncol(production_matrix) != spec$n_series ||
    any(!is.finite(production_matrix)) || anyDuplicated(colnames(production_matrix)) ||
    !all(spec$required_series %in% colnames(production_matrix)) ||
    any(spec$excluded_series %in% colnames(production_matrix))) {
  stop("The canonical production panel does not match the centralized 111-series specification.")
}

production_data <- tibble::as_tibble(production_matrix) |>
  dplyr::mutate(ref.date = expected_dates, .before = 1)
readr::write_csv(production_data, spec$data_path)

dir.create("output/panel", showWarnings = FALSE, recursive = TRUE)
panel_manifest <- candidate_inputs$treatments |>
  dplyr::mutate(in_production = variable %in% candidate_keep) |>
  dplyr::arrange(dplyr::desc(in_production), block, variable)
readr::write_csv(panel_manifest, "output/panel/production_candidate_manifest.csv")


