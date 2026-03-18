rm(list = ls())

source("R/preprocessing/seasonality.R")
source("R/preprocessing/stationarity.R")


# loading data ----
raw_data <- readr::read_csv("data/raw_data.csv") |> dplyr::filter(ref.date >= "2013-01-01" & ref.date <= "2025-09-01")

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




