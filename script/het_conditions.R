# ===================================================================
# THE IDENTIFICATION CONDITION FOR HETEROSKEDASTICITY, IN THE THREE
# SYSTEMS THE PAPER COMPARES
#
# Rigobon (2003) states ONE condition, the rank condition eq. (6), and says
# it fails if and only if the two regimes' covariance matrices are
# proportional. Its multivariate form is the distinctness of the eigenvalues
# of `Lambda` in `Sigma_NC = B B'`, `Sigma_C = B Lambda B'`, which is what
# the `svars` package estimates and tests. This script runs that test on the
# three systems of tab:het_frequency and puts the rank condition of the daily
# window and of the monthly panel side by side.
#
# THE ONLY MONTHLY AGGREGATION IS THE PANEL'S OWN (author decision,
# 2026-09-22): the reference month's last quotation for the DI vertices and
# for the CDS, the monthly average for the exchange rate. The object that
# summed the Wed->Thu windows inside the calendar month was removed, and no
# claim may rest on it.
#
# ON 2026-09-22 THE BATTERY WAS CUT TO THE PACKAGE'S TEST (author decision).
# The proportionality LR of Mauchly, the lambda_1-lambda_2 gap, the variance
# ratio along the leading direction, the rank-1 share and the permutation
# placebo were this project's own construction and no longer appear, here or
# in the paper.
#
# This is a DIAGNOSTIC, not an identification. Nothing here produces an
# impulse response, and heteroskedasticity identification stays abandoned for
# the paper (2026-08-17). The exploratory responses live in het_rigobon/.
#
# Outputs in output/het/:
#   daily_changes.csv       the Wed->Thu panel the daily row is built on
#   het_conditions.csv      one row per system: Lambda, its SE, Qr
#   het_qr_tests.csv        every sequential Qr null, all three systems
#   het_variance_ratios.csv Var_C / Var_NC of each residual series
#   het_lambda.csv          every eigenvalue of Lambda with its SE
#
# Run: Rscript script/het_conditions.R
# ===================================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(svars)
})
source("R/instrument/di_surprise.R")
source("R/identification/het_tests.R")
source("R/modeling/factor_estimation.R")


# ---- Config --------------------------------------------------------

OUT_DIR <- "output/het"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

PATH_PANEL <- "data/processed/data_log_deseasonalized.csv"
PATH_COPOM <- "data/raw/copom_historico.csv"
PATH_DI    <- "data/raw/di.csv"
PATH_BRL   <- "data/raw/brl_usd_daily.csv"
PATH_CDS   <- "data/raw/CDS 5y.xlsx"
PATH_THETA <- "output/factors/covid_volatility_theta.csv"

# The production window, used in all three systems so that the contrast is
# between systems and not between samples.
SAMPLE <- as.Date(c("2012-03-01", "2025-12-31"))

# AS SERIES SAO AS DE GRG (2025), nos dois lados. Eles usam a variacao de
# quarta para quinta do DI, do cambio BRL/USD e do CDS soberano de 5 anos --
# Tabela 1 deles. Nao usam Ibovespa nem o vertice de 2 anos, e o que este
# projeto publicava como "linha diaria" ate 2026-09-21 usava os dois: aquele
# conjunto era do projeto, nao deles.
#
# A quarta serie de GRG, a expectativa de inflacao, e o *breakeven* entre
# titulos indexados e nominais. O projeto so tem a medida do Focus, que e
# survey -- os proprios autores dizem "market-based (not survey data)" -- e
# cuja variacao diaria e exatamente zero em 23% dos dias, porque o Focus e
# publicado uma vez por semana. Ela fica fora, e a lacuna fica declarada.
#
# O vertice do DI e a dimensao em que GRG mesmos variam (1m, 3m, 6m, 12m).
# Os tres que o projeto consegue construir entram como linhas, nas duas
# frequencias: escolher um seria escolher a conclusao.
VERTICES <- tibble::tribble(
  ~rotulo,  ~diaria,   ~mensal,     ~bd,
  "3 meses", "di_3m",  "yield_3m",  63L,
  "6 meses", "di_6m",  "yield_6m",  126L,
  "12 meses","di_12m", "yield_1y",  252L
)
DEP_DIA <- c("cds_5y", "brl")            # as duas dependentes de GRG
DEP_MES <- c("cds_5y", "cambio_usd")     # as mesmas, no painel mensal
DI_VERTICES <- rlang::set_names(VERTICES$bd, VERTICES$diaria)

P_LAGS  <- 4L
R_FAC   <- 5L
Q_FAC   <- 5L
PRODUCAO_ROOT <- 0.9836766921623673

EXPECTED_MONTHS <- 166L
EXPECTED_SERIES <- 115L


# ---- Painel diario Qua->Qui ----------------------------------------
#
# Uma observacao por semana: quarta-feira -> quinta-feira. O Copom anuncia
# depois do fechamento de quarta, entao a janela cobre o anuncio. Regime C =
# a quarta e dia de reuniao. Semanas sem pregao na quarta ou na quinta viram
# NA e caem -- nunca zero, que faria "sem cotacao" passar por "sem variacao".

brl <- readr::read_csv(PATH_BRL, show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), valor = 100 * log(brl))
cds <- readxl::read_excel(PATH_CDS, skip = 5) |>
  rlang::set_names(c("date", "valor")) |>
  dplyr::transmute(date = as.Date(date), valor = as.numeric(valor)) |>
  dplyr::filter(!is.na(date), !is.na(valor))

painel <- build_weekly_changes(SAMPLE[1], SAMPLE[2], DI_VERTICES,
                               list(cds_5y = cds, brl = brl),
                               PATH_COPOM, PATH_DI) |>
  tidyr::drop_na(dplyr::all_of(c(VERTICES$diaria, DEP_DIA)))

readr::write_csv(painel, file.path(OUT_DIR, "daily_changes.csv"))


# ---- Painel mensal e regimes ---------------------------------------

raw_data <- readr::read_csv(PATH_PANEL, show_col_types = FALSE) |> tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> dplyr::select(-ref.date) |> as.matrix()

if (nrow(data_mat) != EXPECTED_MONTHS || ncol(data_mat) != EXPECTED_SERIES) {
  stop(sprintf("Painel e %d x %d, esperado %d x %d",
               nrow(data_mat), ncol(data_mat), EXPECTED_MONTHS, EXPECTED_SERIES))
}

regimes <- build_monthly_regimes(PATH_COPOM, month_range = range(dates))


# ---- Sistema 1: as quatro observaveis em frequencia diaria ----------
#
# Sem defasagem economica: as variacoes Qua->Qui ja sao inovacoes. O p = 1 e
# uma formalidade, porque cv_ident_test() reconstroi residuos por YLagCr e
# nao aceita p = 0; a guarda `inert_lag` exige que os residuos ainda sejam as
# proprias series.

het_dia <- purrr::map(rlang::set_names(VERTICES$diaria, VERTICES$rotulo), function(v) {
  fit_het_cv(as.matrix(painel[, c(v, DEP_DIA)]), p = 1L, type = "const",
             regime_labels = painel$regime[-1], inert_lag = TRUE)
})


# ---- Sistema 2: VAR mensal de quatro observaveis --------------------
#
# Janela, defasagem e deterministico do benchmark ibc5_fx_cds_level_trend_p4,
# para que o contraste seja de identificacao e nao de amostra.

lab_mes <- align_regimes_to_eta(dates, P_LAGS, regimes)
het_var <- purrr::map(rlang::set_names(VERTICES$mensal, VERTICES$rotulo), function(v) {
  fit_het_cv(as.matrix(raw_data[, c(v, DEP_MES)]), p = P_LAGS, type = "both",
             regime_labels = lab_mes)
})


# ---- Sistema 3: cinco inovacoes fatoriais ---------------------------

dfm <- estimate_dfm(data_mat, r = R_FAC, q = Q_FAC, p = P_LAGS, dates = dates,
                    covid_volatility = read_covid_volatility(PATH_THETA))
if (abs(dfm$diagnostics$max_eigenvalue - PRODUCAO_ROOT) > 1e-12) {
  stop(sprintf("DFM nao e a celula de producao: raiz %.16f, esperado %.16f",
               dfm$diagnostics$max_eigenvalue, PRODUCAO_ROOT))
}

eta <- extract_dynamic_innovations(dfm)
colnames(eta) <- paste0("eta", seq_len(ncol(eta)))
het_fac <- fit_het_cv(eta, p = 1L, type = "const",
                      regime_labels = lab_mes[-1], inert_lag = TRUE)


# ---- Tabelas -------------------------------------------------------

SISTEMAS <- c(
  purrr::pmap(VERTICES, function(rotulo, diaria, mensal, bd) list(
    nome = "Tres observaveis de GRG", freq = "Diaria", vertice = rotulo,
    h = het_dia[[rotulo]], mp = 1L, vars = c(diaria, DEP_DIA), inerte = TRUE)),
  purrr::pmap(VERTICES, function(rotulo, diaria, mensal, bd) list(
    nome = "Tres observaveis de GRG (VAR)", freq = "Mensal", vertice = rotulo,
    h = het_var[[rotulo]], mp = 1L, vars = c(mensal, DEP_MES), inerte = FALSE)),
  list(list(nome = "Cinco inovacoes fatoriais", freq = "Mensal", vertice = "--",
            h = het_fac, mp = NA_integer_, vars = colnames(eta), inerte = TRUE))
)

condicoes <- purrr::map_dfr(SISTEMAS, function(s) {
  h  <- s$h
  o  <- order(h$Lambda, decreasing = TRUE)
  qr <- h$qr_test["lambda_ 1 =lambda_2", ]
  rk <- if (is.na(s$mp)) list(a = NA_real_, det_Q = NA_real_, det_ratio = NA_real_)
        else rigobon_rank_stat(h$Sigma_C, h$Sigma_NC, s$mp)
  tibble::tibble(
    sistema = s$nome, frequencia = s$freq, vertice = s$vertice,
    n_C = h$n_C, n_NC = h$n_NC, k = length(h$Lambda),
    lambda_1 = h$Lambda[o[1]], lambda_1_se = h$Lambda_SE[o[1]],
    lambda_2 = h$Lambda[o[2]], lambda_2_se = h$Lambda_SE[o[2]],
    lambda_min = min(h$Lambda),
    qr_12 = qr[[1]], qr_12_df = qr[[2]], qr_12_p = qr[[3]],
    qr_12_nk = h$qr_12_nk, qr_12_nk_p = h$qr_12_nk_p,
    kappa_NC = h$kappa[1], kappa_C = h$kappa[2], fator_curtose = h$kurt_factor,
    qr_min_p = max(h$qr_test[["p-value"]]),
    a = rk$a, det_Q = rk$det_Q, det_ratio = rk$det_ratio,
    coluna_mp = h$mp_col, var_mp = s$vars[h$mp_col],
    recon_dev = h$recon_dev, lambda_dev = h$lambda_dev,
    inerte = s$inerte, fidelidade = h$resid_fidelity, iteracoes = h$iteration
  )
})

# Holm across the three DI vertices of each system: the daily claim rests on
# the one vertex that rejects, so its p has to survive the other two.
condicoes <- condicoes |>
  dplyr::group_by(sistema) |>
  dplyr::mutate(qr_12_p_holm = p.adjust(qr_12_p, method = "holm")) |>
  dplyr::ungroup()

qr_todos <- purrr::map_dfr(SISTEMAS, function(s) {
  tibble::as_tibble(s$h$qr_test, rownames = "hipotese") |>
    dplyr::mutate(sistema = s$nome, vertice = s$vertice, .before = 1) |>
    dplyr::rename(estatistica = `Test statistic`, gl = dof, p = `p-value`)
})

# The variance ratio of Rigobon and Sack (2004), series by series, on the same
# residuals the test uses: for the DI it is the `a` of rigobon_rank_stat().
razoes <- purrr::map_dfr(SISTEMAS, function(s) {
  tibble::tibble(
    sistema = s$nome, frequencia = s$freq, vertice = s$vertice, serie = s$vars,
    var_C = diag(s$h$Sigma_C), var_NC = diag(s$h$Sigma_NC), razao = var_C / var_NC
  )
})

autovalores <- purrr::map_dfr(SISTEMAS, function(s) {
  o <- order(s$h$Lambda, decreasing = TRUE)
  tibble::tibble(
    sistema = s$nome, frequencia = s$freq, vertice = s$vertice, ordem = seq_along(o),
    lambda = s$h$Lambda[o], lambda_se = s$h$Lambda_SE[o]
  )
})

readr::write_csv(condicoes,   file.path(OUT_DIR, "het_conditions.csv"))
readr::write_csv(qr_todos,    file.path(OUT_DIR, "het_qr_tests.csv"))
readr::write_csv(razoes,      file.path(OUT_DIR, "het_variance_ratios.csv"))
readr::write_csv(autovalores, file.path(OUT_DIR, "het_lambda.csv"))

