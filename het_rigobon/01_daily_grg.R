# ===================================================================
# PERGUNTA 1: a identificacao Rigobon sobre dados diarios brasileiros
# reproduz os numeros de Goncalves, Rodrigues e Genta (2025, IMF WP/25/48)?
#
# Se nao reproduz, a divergencia do artigo com eles nao e de representacao
# fatorial -- e de estimacao, e o paragrafo da secao 3.3 esta apoiado no lugar
# errado.
#
# O que se confronta sao as tabelas DELES: razoes de variancia (Tab. 1),
# coeficientes de cambio e risco (Tab. 4/5) e janelas moveis de dez anos
# (Tab. 8). O teste de identificacao nao mora aqui -- e o do pacote svars, em
# script/het_conditions.R.
#
# Escreve so em het_rigobon/output/. Nada daqui entra no artigo.
#
# Roda: Rscript het_rigobon/01_daily_grg.R
# ===================================================================

rm(list = ls())
source("het_rigobon/_common.R")
set.seed(SEED)


# ---- Config --------------------------------------------------------

# 2010-01 e o piso vinculante: BRL/USD, Ibovespa e Focus comecam ai. GRG
# comecam em 2009-09, quatro meses antes. O DI e o CDS iriam bem mais fundo
# e nao sao o que limita.
SAMPLE     <- as.Date(c("2010-01-01", "2025-12-31"))
GRG_END    <- as.Date("2024-12-31")   # fim da amostra de GRG
ROLL_YEARS <- 10L                     # janela movel da Tabela 8

# As duas primeiras sao as dependentes de GRG que este projeto consegue
# construir; as quatro seguintes NAO sao deles e entram como extras, para que
# o Ibovespa -- a celula inconveniente -- siga reportado. A expectativa de
# GRG e um breakeven de titulos; focus_ipca12m e survey, e nao substitui.
DEPENDENTES <- c("brl", "cds_5y", "ibov", "embi", "focus_ipca12m", "di_2y")
VERTICES_MP <- c("di_3m", "di_6m", "di_12m")


# ---- Painel semanal Qua->Qui ---------------------------------------

painel <- build_weekly_changes(SAMPLE[1], SAMPLE[2], DI_VERTICES,
                               precos_diarios(), PATH_COPOM, PATH_DI)

SERIES <- c(names(DI_VERTICES), "brl", "ibov", "cds_5y", "embi", "focus_ipca12m")

readr::write_csv(painel, file.path(HET_OUT, "daily_changes_rebuilt.csv"))


# ---- Tabela 1 de GRG: razoes de variancia --------------------------
#
# A condicao que os autores verificam: a variancia da surpresa de juros sobe
# no regime com reuniao, e a das dependentes nao. IC de 99%, como o deles,
# por reamostragem dentro de regime.

ratios <- purrr::map_dfr(SERIES, function(v) {
  ok <- !is.na(painel[[v]])
  x  <- painel[[v]][ok]
  gC <- painel$regime[ok] == "C"
  if (sum(gC) < MIN_N_REGIME || sum(!gC) < MIN_N_REGIME) {
    stop(sprintf("Regime pequeno demais em %s: %d C / %d NC", v, sum(gC), sum(!gC)))
  }

  boot <- vapply(seq_len(N_BOOT), function(b) {
    var(sample(x[gC], sum(gC), replace = TRUE)) /
      var(sample(x[!gC], sum(!gC), replace = TRUE))
  }, numeric(1))

  tibble::tibble(
    serie = v, n_C = sum(gC), n_NC = sum(!gC),
    var_C = var(x[gC]), var_NC = var(x[!gC]),
    ratio = var(x[gC]) / var(x[!gC]),
    ci_lo = unname(quantile(boot, 0.005)),
    ci_hi = unname(quantile(boot, 0.995))
  )
}) |>
  dplyr::left_join(
    dplyr::rename(GRG_VAR_RATIO, grg_ratio = ratio, grg_lo = ci_lo, grg_hi = ci_hi),
    by = "serie"
  ) |>
  dplyr::mutate(compativel_grg = !is.na(grg_ratio) & grg_ratio >= ci_lo & grg_ratio <= ci_hi)

readr::write_csv(ratios, file.path(HET_OUT, "grg_variance_ratios.csv"))


# ---- Tabelas 4/5 de GRG: o estimador deles -------------------------
#
# Com Sigma_C = Sigma_NC + b b' e b = (1, beta)' a menos de escala, o
# deslocamento de covariancia do subsistema (Delta i, y) da
#   beta = dSigma_12 / dSigma_11,
# que e o estimador de Rigobon-Sack, eq. (10). Conferencia de codigo pela
# forma IV com o instrumento de sinal trocado, eq. (12): w'y / w'Delta i e a
# MESMA razao por outra rota, entao as duas tem de bater a 1e-10. E checagem
# de implementacao, nao uma estimativa independente.

#' Estimador de Rigobon-Sack pelo deslocamento de covariancia
#'
#' `beta = dSigma_12 / dSigma_11` no subsistema `(Delta i, y)`, com
#' `dSigma = Sigma_C - Sigma_NC`. Eq. (10) de Rigobon e Sack (2004).
#'
#' @param dx Variacao da taxa de politica, uma entrada por semana.
#' @param dy Variacao da dependente, alinhada a `dx`.
#' @param is_C Logico, `TRUE` nas semanas com reuniao.
#'
#' @return Escalar: a resposta de `dy` por unidade de `dx`.
beta_cov <- function(dx, dy, is_C) {
  d  <- cbind(dx, dy)
  sC <- cov(d[is_C, , drop = FALSE])
  sN <- cov(d[!is_C, , drop = FALSE])
  (sC[1, 2] - sN[1, 2]) / (sC[1, 1] - sN[1, 1])
}

coefs <- purrr::map_dfr(VERTICES_MP, function(vx) {
  purrr::map_dfr(setdiff(DEPENDENTES, vx), function(vy) {
    ok <- !is.na(painel[[vx]]) & !is.na(painel[[vy]])
    dx <- painel[[vx]][ok]
    dy <- painel[[vy]][ok]
    gC <- painel$regime[ok] == "C"

    # Por +100 p.b.: dx esta em pontos-base, entao beta x 100.
    b_cov <- 100 * beta_cov(dx, dy, gC)

    # A forma IV, eq. (12): o instrumento e a variacao centrada no regime,
    # com o sinal trocado nas semanas sem reuniao.
    xc   <- dx - ifelse(gC, mean(dx[gC]), mean(dx[!gC]))
    yc   <- dy - ifelse(gC, mean(dy[gC]), mean(dy[!gC]))
    w    <- ifelse(gC, xc / (sum(gC) - 1L), -xc / (sum(!gC) - 1L))
    b_iv <- 100 * (sum(w * yc) / sum(w * xc))
    if (!is.finite(b_cov) || abs(b_cov - b_iv) > 1e-10) {
      stop(sprintf("Rota de covariancia e forma IV divergem em (%s, %s): %.12g vs %.12g",
                   vx, vy, b_cov, b_iv))
    }

    boot <- vapply(seq_len(N_BOOT), function(b) {
      iC <- sample.int(sum(gC),  sum(gC),  replace = TRUE)
      iN <- sample.int(sum(!gC), sum(!gC), replace = TRUE)
      100 * beta_cov(c(dx[gC][iC], dx[!gC][iN]), c(dy[gC][iC], dy[!gC][iN]),
                     rep(c(TRUE, FALSE), c(sum(gC), sum(!gC))))
    }, numeric(1))

    tibble::tibble(
      vertice = vx, dependente = vy, n = sum(ok), n_C = sum(gC),
      beta_100bp = b_cov,
      se_boot = sd(boot),
      ci_lo = unname(quantile(boot, 0.025)),
      ci_hi = unname(quantile(boot, 0.975))
    )
  })
})

grg_pub <- dplyr::bind_rows(
  dplyr::mutate(GRG_FX,  dependente = "brl"),
  dplyr::mutate(GRG_CDS, dependente = "cds_5y")
) |>
  dplyr::rename(grg_beta = beta, grg_se = se)

coefs <- coefs |>
  dplyr::left_join(grg_pub, by = c("vertice", "dependente")) |>
  dplyr::mutate(
    # Duas leituras, reportadas separadas: o sinal bate? e o ponto de GRG cai
    # no nosso IC de 95%?
    mesmo_sinal    = !is.na(grg_beta) & sign(beta_100bp) == sign(grg_beta),
    compativel_grg = !is.na(grg_beta) & grg_beta >= ci_lo & grg_beta <= ci_hi
  )

readr::write_csv(coefs, file.path(HET_OUT, "grg_coefficients.csv"))


# ---- Tabela 8 de GRG: janelas moveis de 10 anos --------------------
#
# E o que diz se esta amostra DEVERIA reproduzir os -5,10 da coluna cheia de
# GRG. Eles mostram o coeficiente cambial crescendo em modulo ao longo do
# tempo -- -2,85 em 2009:2019 e -8,79 em 2014:2024 --, entao um painel que
# comeca em 2010 nao tem por que dar o valor da amostra inteira deles.

anos <- seq(lubridate::year(SAMPLE[1]), lubridate::year(SAMPLE[2]) - ROLL_YEARS + 1L)

rolling <- purrr::map_dfr(anos, function(a0) {
  a1  <- a0 + ROLL_YEARS - 1L
  jan <- painel$wed_date >= as.Date(sprintf("%d-01-01", a0)) &
         painel$wed_date <= as.Date(sprintf("%d-12-31", a1))
  purrr::map_dfr(c("brl", "cds_5y"), function(vy) {
    ok <- jan & !is.na(painel$di_3m) & !is.na(painel[[vy]])
    gC <- painel$regime[ok] == "C"
    if (sum(gC) < MIN_N_REGIME) {
      stop(sprintf("Janela %d:%d tem so %d semanas C", a0, a1, sum(gC)))
    }
    tibble::tibble(
      janela = sprintf("%d:%d", a0, a1), dependente = vy,
      n = sum(ok), n_C = sum(gC),
      beta_100bp = 100 * beta_cov(painel$di_3m[ok], painel[[vy]][ok], gC)
    )
  })
}) |>
  dplyr::left_join(
    dplyr::transmute(GRG_ROLLING_FX, janela, dependente = "brl",
                     grg_beta = beta, grg_se = se),
    by = c("janela", "dependente")
  )

# A subamostra mais proxima da de GRG, ate o fim da deles, entra como mais
# uma janela, so no cambio.
ok_grg <- painel$wed_date <= GRG_END & !is.na(painel$di_3m) & !is.na(painel$brl)
rolling <- rolling |>
  dplyr::bind_rows(tibble::tibble(
    janela = sprintf("%d:%d", lubridate::year(SAMPLE[1]), lubridate::year(GRG_END)),
    dependente = "brl", n = sum(ok_grg), n_C = sum(painel$regime[ok_grg] == "C"),
    beta_100bp = 100 * beta_cov(painel$di_3m[ok_grg], painel$brl[ok_grg],
                                painel$regime[ok_grg] == "C")
  ))

readr::write_csv(rolling, file.path(HET_OUT, "grg_rolling.csv"))
