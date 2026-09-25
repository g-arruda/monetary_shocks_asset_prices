# ===================================================================
# Rodada exploratoria de identificacao por heterocedasticidade
# (Rigobon 2003), autorizada pelo autor em 2026-09-21 e reduzida a tres
# vertentes em 2026-09-22.
#
# FRONTEIRA. Esta pasta e auto-contida: importa R/ em modo LEITURA, le o
# painel semanal que script/het_conditions.R escreve, escreve so em
# het_rigobon/output/, e nao altera nada em R/, script/, output/ ou paper/.
# Apagar a pasta desfaz a rodada.
#
# O DIAGNOSTICO NAO MORA AQUI. A condicao de identificacao e testada por
# script/het_conditions.R, que e codigo vivo porque a secao 3.3 e o Anexo B a publicam.
# O que fica nesta pasta e o que NAO entra no artigo: o confronto com os
# numeros publicados de GRG e as funcoes de resposta.
#
# A identificacao por heterocedasticidade segue ABANDONADA para o paper
# (decisao de 2026-08-17). Nada produzido aqui entra no artigo como
# corroboracao, perna de robustez ou estimativa alternativa sem decisao
# separada do autor.
#
# Carregado por todo 0X_*.R desta pasta.
# ===================================================================

suppressPackageStartupMessages({
  library(svars)
})

source("R/instrument/di_surprise.R")        # load_di_panel, build_thursday_surprises
source("R/identification/het_tests.R")      # build_weekly_changes, fit_het_cv, ...
source("R/identification/weak_iv_ar.R")     # mosw_marep
source("R/modeling/factor_estimation.R")    # estimate_dfm, read_covid_volatility
source("R/modeling/impulse_response.R")     # compute_irf_dfm, cumimp_transform, tcode

HET_OUT <- "het_rigobon/output"
dir.create(HET_OUT, showWarnings = FALSE, recursive = TRUE)


# ---- Caminhos de entrada -------------------------------------------

PATH_DI        <- "data/raw/di.csv"
PATH_COPOM     <- "data/raw/copom_historico.csv"
PATH_BRL       <- "data/raw/brl_usd_daily.csv"
PATH_IBOV      <- "data/raw/ibov_daily.csv"
PATH_CDS_XLSX  <- "data/raw/CDS 5y.xlsx"
PATH_EMBI      <- "data/raw/banco_central_rep_dominicana/embi_brasil.csv"
PATH_FOCUS     <- "data/raw/focus_daily.csv"
PATH_PANEL     <- "data/processed/data_log_deseasonalized.csv"
PATH_THETA     <- "output/factors/covid_volatility_theta.csv"
PATH_PROXY_IRF <- "output/irf/irf_coherence_h.csv"
PATH_COND      <- "output/het/het_conditions.csv"


# ---- Constantes compartilhadas -------------------------------------

SEED   <- 123L
N_BOOT <- 500L   # a contagem de Rigobon: reamostragem dentro de regime

# Vertices DI em dias uteis. 63/126/252 sao 3m/6m/12m, tres das quatro
# colunas de GRG (90d, 180d, 360d); 504 e o de 2 anos. O vertice de 30 dias
# de GRG fica de fora: abaixo do min_bd = 10 de build_thursday_surprises() a
# escolha de contrato fica instavel perto do vencimento.
DI_VERTICES <- c(di_3m = 63L, di_6m = 126L, di_12m = 252L, di_2y = 504L)

MIN_N_REGIME <- 30L


# ---- Numeros publicados que esta rodada confronta ------------------
#
# GRG (2025), IMF WP/25/48. Coeficientes por +100 p.b. de surpresa,
# amostra 2009-09 a 2024-12, N = 768. Tabela 1 (razoes de variancia),
# Tabela 5 (cambio e risco) e Tabela 8 (janelas moveis de 10 anos).
# Transcritos do markdown em artigos/, conferidos contra paper_anpec.tex:184.

GRG_VAR_RATIO <- tibble::tribble(
  ~serie,   ~ratio, ~ci_lo, ~ci_hi,
  "di_12m",   2.33,   1.65,   3.42,
  "di_6m",    3.40,   2.42,   4.99,
  "di_3m",    4.53,   3.21,   6.65,
  "brl",      0.92,   0.65,   1.35,
  "cds_5y",   0.85,   0.60,   1.24
)

GRG_FX <- tibble::tribble(
  ~vertice,  ~beta,  ~se,
  "di_3m",   -5.10, 0.75,
  "di_6m",   -3.93, 0.63,
  "di_12m",  -3.42, 0.69
)

# Tabela 5, linha do CDS. GRG NAO declaram a unidade do CDS; o resto do
# artigo (Delta i, Delta pi^e) esta em ponto percentual, e dois testes de
# escala confirmam que o CDS tambem esta: (i) a razao entre os erros-padrao
# publicados de cambio e CDS no vertice de 3m e 0,75/0,05 = 15,0, e a razao
# entre os desvios-padrao das nossas series Qua->Qui e 0,978% / 0,0686 p.p.
# = 14,25 -- se o CDS deles estivesse em p.b. a razao seria ~0,14; (ii) o
# coeficiente de 12m assim convertido, -11 p.b., cai sobre o nosso -10,37.
# Guardamos a linha em PONTOS-BASE, a unidade do nosso cds_5y.
GRG_CDS <- tibble::tribble(
  ~vertice,  ~beta,   ~se,
  "di_3m",    -3.0,   5.0,
  "di_6m",    -5.0,   4.0,
  "di_12m",  -11.0,   5.0
)

# Tabela 8: o cambio por Delta i(3m) em janelas moveis de 10 anos. E o que
# diz se uma amostra que comeca em 2010 DEVERIA reproduzir os -5,10 da
# coluna cheia -- GRG mostram o coeficiente crescendo em modulo ao longo do
# tempo, entao a resposta e nao.
GRG_ROLLING_FX <- tibble::tribble(
  ~janela,      ~beta,  ~se,
  "2009:2019",  -2.85, 0.73,
  "2010:2020",  -3.67, 0.73,
  "2011:2021",  -5.50, 0.97,
  "2012:2022",  -5.90, 1.06,
  "2013:2023",  -7.70, 1.25,
  "2014:2024",  -8.79, 1.40
)

# Raiz maxima da celula de producao, para provar que o DFM estimado aqui e
# o mesmo de output/irf/irf_coherence_cell.rds.
PRODUCAO_ROOT <- 0.9836766921623673


# ---- Series diarias de preco, nas unidades das tabelas de GRG ------

#' Series diarias de preco nas unidades das tabelas de GRG
#'
#' Cambio e Ibovespa em 100 x log, para que a diferenca Qua->Qui saia em
#' variacao percentual; CDS e EMBI em nivel de pontos-base; Focus em ponto
#' percentual. Formato que `build_weekly_changes()` espera em `prices`.
#'
#' @return Lista nomeada (`brl`, `ibov`, `cds_5y`, `embi`, `focus_ipca12m`)
#'   de tibbles com `date` e `valor`.
precos_diarios <- function() {
  list(
    brl = readr::read_csv(PATH_BRL, show_col_types = FALSE) |>
      dplyr::transmute(date = as.Date(date), valor = 100 * log(brl)),
    ibov = readr::read_csv(PATH_IBOV, show_col_types = FALSE) |>
      dplyr::transmute(date = as.Date(date), valor = 100 * log(ibov)),
    cds_5y = readxl::read_excel(PATH_CDS_XLSX, skip = 5) |>
      rlang::set_names(c("date", "valor")) |>
      dplyr::transmute(date = as.Date(date), valor = as.numeric(valor)) |>
      dplyr::filter(!is.na(date), !is.na(valor)),
    embi = readr::read_csv(PATH_EMBI, show_col_types = FALSE) |>
      dplyr::transmute(date = lubridate::dmy(date), valor = 100 * embi_perc) |>
      dplyr::filter(!is.na(date), !is.na(valor)),
    focus_ipca12m = readr::read_csv(PATH_FOCUS, show_col_types = FALSE) |>
      dplyr::transmute(date = as.Date(date), valor = focus_ipca12m) |>
      dplyr::filter(!is.na(date), !is.na(valor))
  )
}
