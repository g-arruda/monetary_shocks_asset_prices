library(dplyr)
library(lubridate)
library(tidyr)

parameters <- readr::read_csv("data/curva_juros/series_parametros_svensson.csv") |>
    dplyr::select(data,beta0, beta1, beta2, beta3, tau1, tau2)


# B&F (1998, p. 1094): "as k goes to zero the spot and the forward rate coincide at β₀ + β₁"
# The instantaneous overnight forward rate is the k→0 limit of:
# f(k) = β₀ + β₁ exp(-k/τ₁) + β₂ (k/τ₁) exp(-k/τ₁) + β₃ (k/τ₂) exp(-k/τ₂)
# As k→0: exp(-k/τ)→1 and (k/τ)exp(-k/τ)→0, so f(0) = β₀ + β₁

overnight_rate <- tibble::tibble(
    date = parameters$data,
    overnight = parameters$beta0 + parameters$beta1
)



copom <- readr::read_csv("data/copom_historico.csv")[-1] |>
    dplyr::select(data_reuniao, meta_selic_pct)






# 1) Preparar COPOM
copom2 <- copom %>%
    mutate(
        meeting_date = dmy(data_reuniao),
        announced = meta_selic_pct / 100
    ) %>%
    arrange(meeting_date) %>%
    select(meeting_date, announced)

# 2) Buscar expectativa (t-1) e calcular o choque
#    A lógica do filter(date < meeting_date) está correta para pegar o fechamento anterior.
copom_with_prev <- copom2 %>%
    rowwise() %>%
    mutate(
        prev_overnight = {
            cutoff <- meeting_date - days(1)
            r <- overnight_rate %>%
                filter(date <= cutoff) %>%
                slice_tail(n = 1) %>%
                pull(overnight)
            if (length(r) == 0) NA_real_ else r
        }
    ) %>%
    ungroup() %>%
    mutate(
        shock = announced - prev_overnight
    )


# 3) Agregar por mês
copom_monthly <- copom_with_prev %>%
    mutate(month = floor_date(meeting_date, unit = "month")) %>%
    group_by(month) %>%
    summarise(shock = last(shock), .groups = "drop")

# 4) Construir grade mensal
first_month <- floor_date(min(overnight_rate$date), unit = "month")
last_month <- floor_date(max(overnight_rate$date), unit = "month")
months_seq <- seq(from = first_month, to = last_month, by = "month")

# 5) Montar série final com zeros nos meses sem reunião
monthly_shocks <- tibble(month = months_seq) %>%
    left_join(copom_monthly, by = "month") %>%
    mutate(shock = replace_na(shock, 0)) # Zeros conforme pág. 1094 [cite: 708]


readr::write_csv(monthly_shocks, "data/processed/instrument.csv")