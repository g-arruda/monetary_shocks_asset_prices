# ===================================================================
# PERGUNTA 3 (diagnostico): quanto do sinal de heterocedasticidade
# sobrevive a agregacao mensal?
#
# NAO E UMA VERTENTE DE IRF. Nao produz resposta nenhuma; mede a
# aritmetica que separa a variacao Qua->Qui da variacao mensal do
# painel, nas mesmas series de GRG, e nada aqui entra no artigo.
#
# A pergunta que ele responde e estreita: se o unico excesso de
# variancia no mes do Copom fosse o dia do anuncio, e se as variacoes
# diarias fossem independentes dentro do mes, a razao de variancia
# mensal seria 1 + (r_d - 1)/n, com n ~ 21 dias uteis. O diagnostico
# poe essa previsao de pura diluicao ao lado da razao mensal observada
# e do resultado do mesmo estimador sobre a variacao mensal.
#
# O que ele NAO faz, por decisao de 2026-09-22: separar diluicao
# temporal de variacao de calendario. O excesso observado mistura as
# duas coisas e a dinamica intra-mes, e nenhuma afirmacao do paper ou
# do registro pode atribuir a queda da condicao a uma delas.
#
# As series diarias sao as de GRG (Tab. 1): DI, cambio BRL/USD e CDS
# soberano de 5 anos. A mensal e a do proprio painel: ultima cotacao
# do mes de referencia nos vertices do DI e no CDS, media mensal no
# cambio.
#
# Escreve so em het_rigobon/output/.
#
# Roda: Rscript het_rigobon/03_atenuacao.R   (depois de script/het_conditions.R)
# ===================================================================

rm(list = ls())
source("het_rigobon/_common.R")

SAMPLE <- as.Date(c("2012-03-01", "2025-12-31"))
P_LAGS <- 4L


# ---- O par de series nas duas frequencias ---------------------------

PARES <- tibble::tribble(
  ~rotulo,          ~diaria,  ~mensal,
  "DI 3 meses",     "di_3m",  "yield_3m",
  "DI 6 meses",     "di_6m",  "yield_6m",
  "DI 12 meses",    "di_12m", "yield_1y",
  "CDS 5 anos",     "cds_5y", "cds_5y",
  "Cambio BRL/USD", "brl",    "cambio_usd"
)

#' Razao de variancia entre os regimes
#'
#' @param x Serie numerica.
#' @param g Logico alinhado a `x`, `TRUE` no regime com reuniao.
#'
#' @return Escalar `Var_C / Var_NC`.
razao_var <- function(x, g) var(x[g]) / var(x[!g])


# ---- Dias uteis por mes ---------------------------------------------
#
# n e o numero medio de dias uteis do mes na janela; e o peso que o
# choque de um dia tem na variacao do mes.

dias <- load_di_panel(PATH_DI, from = SAMPLE[1], to = SAMPLE[2])
n_bd <- dias |>
  dplyr::mutate(mes = lubridate::floor_date(date, "month")) |>
  dplyr::distinct(mes, date) |>
  dplyr::count(mes) |>
  dplyr::pull(n) |>
  mean()


# ---- Razao diaria, Qua->Qui -----------------------------------------

painel <- build_weekly_changes(SAMPLE[1], SAMPLE[2], DI_VERTICES,
                               precos_diarios()[c("cds_5y", "brl")],
                               PATH_COPOM, PATH_DI)

diaria <- purrr::map_dfr(seq_len(nrow(PARES)), function(i) {
  v  <- PARES$diaria[i]
  ok <- !is.na(painel[[v]])
  g  <- painel$regime[ok] == "C"
  if (sum(g) < MIN_N_REGIME || sum(!g) < MIN_N_REGIME) {
    stop(sprintf("Regime pequeno demais em %s: %d C / %d NC", v, sum(g), sum(!g)))
  }
  tibble::tibble(rotulo = PARES$rotulo[i], n_C_dia = sum(g), n_NC_dia = sum(!g),
                 razao_diaria = razao_var(painel[[v]][ok], g))
})


# ---- Razao mensal, a agregacao do painel ----------------------------

raw_data <- readr::read_csv(PATH_PANEL, show_col_types = FALSE) |> tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
regimes  <- build_monthly_regimes(PATH_COPOM, month_range = range(dates))
lab      <- regimes$regime[match(dates, regimes$month)]

mensal <- purrr::map_dfr(seq_len(nrow(PARES)), function(i) {
  v <- PARES$mensal[i]
  d <- diff(raw_data[[v]])
  g <- lab[-1] == "C"
  tibble::tibble(rotulo = PARES$rotulo[i], n_C_mes = sum(g), n_NC_mes = sum(!g),
                 razao_mensal = razao_var(d, g))
})

# Residuos do VAR(4) mensal de [yield_3m, cds_5y, cambio_usd]: a mesma
# serie de yield_3m que o DI 3m, mais as duas dependentes. Os vertices de
# 6 e 12 meses nao entram nesse VAR e ficam sem a coluna.
V3    <- c("yield_3m", "cds_5y", "cambio_usd")
u_mes <- resid(vars::VAR(as.matrix(raw_data[, V3]), p = P_LAGS, type = "both"))
residuos <- tibble::tibble(
  rotulo = PARES$rotulo[match(V3, PARES$mensal)],
  razao_resid_var4 = vapply(V3, function(v) razao_var(u_mes[, v], lab[-(1:P_LAGS)] == "C"),
                            numeric(1))
)

tabela <- diaria |>
  dplyr::left_join(mensal, by = "rotulo") |>
  dplyr::mutate(diluicao = 1 + (razao_diaria - 1) / n_bd,
                excesso  = razao_mensal - diluicao) |>
  dplyr::left_join(residuos, by = "rotulo")


# ---- Mesmo estimador, objeto mensal ---------------------------------
#
# O Qr da linha diaria de 3 meses esta em het_conditions.csv. A celula
# mensal e fit_het_cv sobre a variacao mensal das mesmas tres series,
# p=1: a defasagem NAO e formalidade no mensal (as variacoes nao sao
# brancas), entao o filtro difere do diario e a comparacao e entre
# objetos, nao so entre frequencias.

d3    <- diff(as.matrix(raw_data[, V3]))
h_mes <- fit_het_cv(d3, p = 1L, type = "const", regime_labels = lab[-(1:2)])
qr_mes <- h_mes$qr_test["lambda_ 1 =lambda_2", ]
lam    <- sort(h_mes$Lambda, decreasing = TRUE)

qr_mensal <- tibble::tibble(
  objeto = "variacao mensal, p = 1", n_C = h_mes$n_C, n_NC = h_mes$n_NC,
  qr_12 = qr_mes[[1]], gl = qr_mes[[2]], p = qr_mes[[3]],
  lambda_1 = lam[1], lambda_2 = lam[2], lambda_3 = lam[3]
)


# ---- Saidas ----------------------------------------------------------

readr::write_csv(tabela,    file.path(HET_OUT, "03_atenuacao.csv"))
readr::write_csv(qr_mensal, file.path(HET_OUT, "03_atenuacao_qr.csv"))
