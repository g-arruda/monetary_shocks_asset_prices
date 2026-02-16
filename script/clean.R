rm(list = ls())

source("R/preprocessing/seasonality.R")
source("R/preprocessing/stationarity.R")


# loading data ----
raw_data <- readr::read_csv("data/raw_data.csv") |> dplyr::filter(ref.date >= "2013-01-01" & ref.date <= "2025-09-01")

raw_data <- raw_data |>
  dplyr::mutate(
    dplyr::across(
      -ref.date,
      ~ zoo::na.approx(.x, method = "linear")
    )
  )


# Apply log transformation in nominal variables ----

data <- raw_data |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(
        dplyr::contains("credito"),
        dplyr::contains("consumo"),
        dplyr::contains("veiculos"),
        dplyr::contains("caged"),
        dplyr::contains("pop"),
        dplyr::contains("trab"),
        -c(trab_tx_desemprego, trab_razao_vagas_desempregados)
      ),
      .fns = ~ log(.x)
    )
  )





# Treating data seasonality ----

season_result <- check_seasonality(data)


data_no_season <- data |>
  dplyr::select(dplyr::matches(season_result$season_vars)) |>
  purrr::map(
    ~ ts(
      .x,
      start = c(
        lubridate::year(min(data$ref.date)),
        1
      ),
      frequency = 12
    ) |>
      seasonal::seas(
        x11 = "",
        transform.function = "auto",
        regression.aictest = NULL,
        outlier = NULL
      ) |>
      seasonal::final()
  ) |>
  purrr::map_dfc(~ as.numeric(.x))


# Apply seasonal adjustment to identified variables
data <- data |>
  dplyr::mutate(
    dplyr::across(
      dplyr::all_of(season_result$season_vars),
      ~ data_no_season[[dplyr::cur_column()]]
    )
  )

# Check for unit roots and apply transformations
unity_root_test <- adf_test(data)
final_data <- remove_unit_root(data, max_diff = 5)

# Save processed data
# readr::write_csv(final_data$data, "data/processed/final_data.csv")
# readr::write_csv(data, "data/processed/data_log_deseasonalized.csv")
