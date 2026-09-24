# ===================================================================
# PERGUNTA 2: identificada por heterocedasticidade, como se comporta a
# funcao de resposta?
#
# Tres vertentes, a mesma identificacao em todas: a coluna de `B` cujo
# autovalor de `Lambda` e o maior, estimada pelo pacote svars.
#
#   1. Diaria       -- quatro observaveis nas variacoes Qua->Qui, so impacto
#   2. VAR mensal   -- quatro observaveis em nivel, 2012-03--2025-12, p=4
#   3. DFM          -- cinco inovacoes fatoriais, celula de producao
#
# Bandas por reamostragem DENTRO DE REGIME, 500 replicas, que e o que
# Rigobon faz na secao empirica. Elas medem a incerteza da identificacao com
# a forma reduzida fixa -- e exatamente o escopo do bootstrap dele.
#
# A CONDICAO DE IDENTIFICACAO NAO E TESTADA AQUI. Ela e o teste Qr do pacote
# svars, em script/het_conditions.R, e um sistema que nao rejeita
# lambda_1 = lambda_2 sai com `identificado = FALSE` em todo CSV de resposta.
#
# Escreve so em het_rigobon/output/. Nada daqui entra no artigo.
#
# Roda: Rscript het_rigobon/02_irf.R   (depois de script/het_conditions.R)
# ===================================================================

rm(list = ls())
source("het_rigobon/_common.R")
set.seed(SEED)


# ---- Config --------------------------------------------------------

# AS SERIES SAO AS DE GRG (2025) nos dois lados observaveis: DI, cambio
# BRL/USD e CDS soberano de 5 anos. Eles nao usam Ibovespa nem o vertice de
# 2 anos. A quarta serie deles, a expectativa de inflacao, e um breakeven de
# titulos, que o projeto nao tem -- so a medida do Focus, que e survey.
#
# O vertice entra como celula, porque e a dimensao em que os proprios GRG
# variam e porque no diario ele decide: o teste rejeita em 3 meses e nao em
# 12. As duas vertentes observaveis rodam nos vertices de 3 e 6 meses.
VERTICES <- tibble::tribble(
  ~rotulo,   ~diaria,  ~mensal,
  "3 meses", "di_3m",  "yield_3m",
  "6 meses", "di_6m",  "yield_6m"
)
DEP_DIA <- c("cds_5y", "brl")
DEP_MES <- c("cds_5y", "cambio_usd")
MP_DFM  <- "yield_6m"   # a variavel de politica da producao, para a vertente fatorial

SCALE   <- 0.005   # +50 p.b. no vertice de politica, proporcao decimal
SCALE_D <- 50      # +50 p.b. no diario, unidades nativas (ja em p.b.)
P_LAGS  <- 4L
H       <- 36L

DETERMINISTIC <- "both"

R_FAC <- 5L
Q_FAC <- 5L
EXPECTED_MONTHS <- 166L
EXPECTED_SERIES <- 115L

# Escalas de exibicao, as mesmas de script/fig_section5.R.
ESCALAS <- tibble::tribble(
  ~var,          ~rotulo,                 ~k,
  "yield_6m",    "DI 6m (p.b.)",          1e4,
  "yield_3m",    "DI 3m (p.b.)",          1e4,
  "cds_5y",      "CDS 5 anos (p.b.)",     1,
  "asset_ibov",  "Ibovespa (%)",          1,
  "cambio_usd",  "Cambio BRL/USD (%)",    NA_real_,   # "pct": 100/media
  "price_ipca",  "IPCA (p.p. ao mes)",    1,
  "ibc_br",      "IBC-Br (%)",            NA_real_
)


# ---- Entradas ------------------------------------------------------

if (!file.exists(PATH_COND)) {
  stop("Falta output/het/het_conditions.csv. Rode antes: Rscript script/het_conditions.R")
}
condicoes <- readr::read_csv(PATH_COND, show_col_types = FALSE)

# O veredito da condicao viaja com cada resposta: sem rejeitar
# lambda_1 = lambda_2 a 5%, a trajetoria gravada nao e uma estimativa.
veredito <- rlang::set_names(condicoes$qr_12_p < 0.05,
                             paste(condicoes$sistema, condicoes$vertice))

painel_dia <- readr::read_csv("output/het/daily_changes.csv", show_col_types = FALSE)

raw_data <- readr::read_csv(PATH_PANEL, show_col_types = FALSE) |> tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> dplyr::select(-ref.date) |> as.matrix()
if (nrow(data_mat) != EXPECTED_MONTHS || ncol(data_mat) != EXPECTED_SERIES) {
  stop(sprintf("Painel e %d x %d, esperado %d x %d",
               nrow(data_mat), ncol(data_mat), EXPECTED_MONTHS, EXPECTED_SERIES))
}

ESCALAS$k[is.na(ESCALAS$k)] <- vapply(
  ESCALAS$var[is.na(ESCALAS$k)],
  function(v) 100 / mean(raw_data[[v]], na.rm = TRUE), numeric(1)
)

regimes <- build_monthly_regimes(PATH_COPOM, month_range = range(dates))
lab_mes <- align_regimes_to_eta(dates, P_LAGS, regimes)


# ---- A identificacao e a banda, uma rotina para as tres vertentes --
#
# O ponto vem do estimador do pacote. Dentro do bootstrap a mesma solucao
# sai da decomposicao generalizada em um passo -- het_column_closed_form(),
# que fit_het_cv() verifica contra a rotina iterativa --, o que torna 500
# replicas baratas sem trocar de estimador.
#
# Regra de sinal: a coluna e orientada para impacto POSITIVO na variavel de
# politica, e depois normalizada. A normalizacao e invariante ao sinal
# arbitrario do autovetor; a regra so fixa o `b` reportado.

#' Trajetoria normalizada de um vetor de impacto
#'
#' @param b Vetor de impacto estrutural, uma entrada por coluna de `prop`.
#' @param prop Array `n x k x (H+1)` que leva o impacto a resposta de cada
#'   serie em cada horizonte.
#' @param mpind Linha da variavel de politica em `prop`.
#' @param escala Impacto da variavel de politica em h = 0 depois da
#'   normalizacao.
#'
#' @return Matriz `n x (H+1)`.
irf_de_b <- function(b, prop, mpind, escala) {
  traj <- vapply(seq_len(dim(prop)[3]),
                 function(j) drop(matrix(prop[, , j], nrow = dim(prop)[1]) %*% b),
                 numeric(dim(prop)[1]))
  traj / traj[mpind, 1] * escala
}

#' Ponto e bandas de uma vertente identificada por heterocedasticidade
#'
#' A coluna do choque e a de maior autovalor de `Lambda`, orientada para
#' impacto positivo na variavel de politica. As bandas de 68% e 90%
#' reamostram os residuos dentro de cada regime, com a forma reduzida fixa, e
#' recalculam a coluna pela forma fechada de `het_column_closed_form()`.
#'
#' @param h Saida de `fit_het_cv()`.
#' @param prop,mpind,escala Como em [irf_de_b()].
#' @param nomes Nome da serie de cada linha de `prop`.
#' @param labels Rotulos `"C"`/`"NC"` alinhados as linhas de `h$u`.
#' @param tcode Codigo de transformacao de cada linha, ou `NULL` para
#'   deixar a resposta como sai da propagacao.
#'
#' @return Tibble longo com `h`, `var`, `ponto`, `lo68`, `hi68`, `lo90` e
#'   `hi90`.
monta <- function(h, prop, mpind, escala, nomes, labels, tcode = NULL) {
  b <- h$B[, h$mp_col]
  if (drop(matrix(prop[, , 1], nrow = dim(prop)[1]) %*% b)[mpind] < 0) b <- -b
  ponto <- irf_de_b(b, prop, mpind, escala)

  is_C <- labels == "C"
  uC <- h$u[is_C, , drop = FALSE]
  uN <- h$u[!is_C, , drop = FALSE]
  draws <- vapply(seq_len(N_BOOT), function(r) {
    sC <- uC[sample.int(nrow(uC), nrow(uC), replace = TRUE), , drop = FALSE]
    sN <- uN[sample.int(nrow(uN), nrow(uN), replace = TRUE), , drop = FALSE]
    cf <- het_column_closed_form(crossprod(sC) / nrow(sC), crossprod(sN) / nrow(sN))
    irf_de_b(cf$B[, which.max(cf$Lambda)], prop, mpind, escala)
  }, matrix(0, dim(prop)[1], dim(prop)[3]))

  bd <- list(
    lo68 = apply(draws, 1:2, quantile, 0.16, na.rm = TRUE),
    hi68 = apply(draws, 1:2, quantile, 0.84, na.rm = TRUE),
    lo90 = apply(draws, 1:2, quantile, 0.05, na.rm = TRUE),
    hi90 = apply(draws, 1:2, quantile, 0.95, na.rm = TRUE)
  )

  if (!is.null(tcode)) {
    ponto <- cumimp_transform(ponto, tcode)
    bd    <- lapply(bd, cumimp_transform, tcode)
  }

  purrr::map_dfr(seq_along(nomes), function(i) {
    tibble::tibble(h = seq_len(ncol(ponto)) - 1L, var = nomes[i],
                   ponto = ponto[i, ], lo68 = bd$lo68[i, ], hi68 = bd$hi68[i, ],
                   lo90 = bd$lo90[i, ], hi90 = bd$hi90[i, ])
  })
}


# ---- Vertentes 1 e 2: as tres series de GRG, nas duas frequencias ---
#
# Diaria: sem dinamica, a resposta e o vetor de impacto. Mensal: VAR(4) em
# nivel com constante e tendencia, a janela e a defasagem do benchmark
# ibc5_fx_cds_level_trend_p4, propagado por mosw_marep sobre a GLS do proprio
# estimador. `AL` sai em unidades padronizadas, por isso a propagacao e
# reescalonada de volta.

k3 <- length(DEP_DIA) + 1L

irf_dia <- purrr::pmap_dfr(VERTICES, function(rotulo, diaria, mensal) {
  V <- c(diaria, DEP_DIA)
  h <- fit_het_cv(as.matrix(painel_dia[, V]), p = 1L, type = "const",
                  regime_labels = painel_dia$regime[-1], inert_lag = TRUE)
  monta(h, array(diag(k3), c(k3, k3, 1L)), 1L, SCALE_D, V,
        painel_dia$regime[-1]) |>
    dplyr::mutate(vertice = rotulo, .before = 1,
                  identificado = veredito[[paste("Tres observaveis de GRG", rotulo)]])
})

var_fits <- purrr::pmap(VERTICES, function(rotulo, diaria, mensal) {
  fit_het_cv(as.matrix(raw_data[, c(mensal, DEP_MES)]), p = P_LAGS,
             type = DETERMINISTIC, regime_labels = lab_mes)
})
names(var_fits) <- VERTICES$rotulo

irf_var <- purrr::pmap_dfr(VERTICES, function(rotulo, diaria, mensal) {
  V <- c(mensal, DEP_MES)
  h <- var_fits[[rotulo]]
  C <- mosw_marep(h$AL, P_LAGS, H)
  comp <- rbind(h$AL, cbind(diag(k3 * (P_LAGS - 1L)),
                            matrix(0, k3 * (P_LAGS - 1L), k3)))
  raiz <- max(abs(eigen(comp)$values))
  if (raiz >= 1) stop(sprintf("VAR mensal explosivo no vertice %s: raiz %.6f", rotulo, raiz))

  # diag(scale) C_j diag(1/scale) em cada horizonte: devolve a propagacao as
  # unidades originais.
  prop <- sweep(sweep(C, 1, h$scale, "*"), 2, 1 / h$scale, "*")
  monta(h, prop, 1L, SCALE, V, lab_mes, infer_tcode_from_varnames(V)) |>
    dplyr::mutate(vertice = rotulo, .before = 1,
                  identificado = veredito[[paste("Tres observaveis de GRG (VAR)", rotulo)]])
})


# ---- Vertente 3: cinco inovacoes fatoriais --------------------------

dfm <- estimate_dfm(data_mat, r = R_FAC, q = Q_FAC, p = P_LAGS, dates = dates,
                    covid_volatility = read_covid_volatility(PATH_THETA))
if (abs(dfm$diagnostics$max_eigenvalue - PRODUCAO_ROOT) > 1e-12) {
  stop(sprintf("DFM nao e a celula de producao: raiz %.16f, esperado %.16f",
               dfm$diagnostics$max_eigenvalue, PRODUCAO_ROOT))
}

eta <- extract_dynamic_innovations(dfm)
colnames(eta) <- paste0("eta", seq_len(ncol(eta)))

# IRFs de forma reduzida: diag(sy) Lambda B_h K M, a mesma expressao inline
# de compute_irf_dfm(). Construida aqui porque a pasta nao edita codigo vivo
# -- e VERIFICADA logo abaixo contra o ponto do proxy, que e guarda mais
# forte do que a extracao teria sido.
powers <- Reduce(function(B, i) B %*% dfm$companion_matrix, seq_len(H),
                 accumulate = TRUE, init = diag(nrow(dfm$companion_matrix)))
rawimp <- simplify2array(lapply(powers, function(B) {
  sweep(dfm$static_loadings %*% B[1:R_FAC, 1:R_FAC] %*% dfm$dynamic_loadings %*%
          dfm$dynamic_scaling, 1, dfm$data_sd, "*")
}))

var_names <- colnames(data_mat)
tcode_fac <- infer_tcode_from_varnames(var_names)
mpind_fac <- match(MP_DFM, var_names)

dfm_proxy <- estimate_dfm(
  data_mat, r = R_FAC, q = Q_FAC, p = P_LAGS, dates = dates,
  instrument = readr::read_csv("data/processed/instrument.csv", show_col_types = FALSE),
  covid_volatility = read_covid_volatility(PATH_THETA)
)
irf_proxy <- compute_irf_dfm(dfm_proxy, h = H, mpind = mpind_fac,
                             normalize_value = SCALE, tcode = tcode_fac,
                             inference = "none")$irf_point_matrix

align     <- sel_ext_inst_sample(dfm_proxy$dates, P_LAGS, dfm_proxy$instrument)
eta_px    <- extract_dynamic_innovations(dfm_proxy)
powers_px <- Reduce(function(B, i) B %*% dfm_proxy$companion_matrix, seq_len(H),
                    accumulate = TRUE, init = diag(nrow(dfm_proxy$companion_matrix)))
rawimp_px <- simplify2array(lapply(powers_px, function(B) {
  sweep(dfm_proxy$static_loadings %*% B[1:R_FAC, 1:R_FAC] %*%
          dfm_proxy$dynamic_loadings %*% dfm_proxy$dynamic_scaling,
        1, dfm_proxy$data_sd, "*")
}))
dev_raw <- max(abs(
  ident_ext_instr(rawimp_px, eta_px[align$rsh_sel_ind, , drop = FALSE],
                  align$inst_sel, H, mpind_fac, SCALE, tcode_fac, center = FALSE) -
  irf_proxy))
if (!is.finite(dev_raw) || dev_raw > 1e-10) {
  stop(sprintf("O rawimp local nao reproduz o ponto do proxy: desvio %.3g", dev_raw))
}

het_fac <- fit_het_cv(eta, p = 1L, type = "const", regime_labels = lab_mes[-1],
                      inert_lag = TRUE)

# O `b` vive no espaco fatorial e viaja pelo rawimp; a banda so reamostra as
# inovacoes, com a forma reduzida fixa.
SERIES_FAC <- c("yield_6m", "yield_3m", "cds_5y", "cambio_usd",
                "asset_ibov", "price_ipca", "ibc_br")
sel_fac  <- match(SERIES_FAC, var_names)
prop_fac <- rawimp[sel_fac, , , drop = FALSE]

irf_fac <- monta(het_fac, prop_fac, match(MP_DFM, SERIES_FAC), SCALE, SERIES_FAC,
                 lab_mes[-1], tcode_fac[sel_fac]) |>
  dplyr::mutate(identificado = veredito[["Cinco inovacoes fatoriais --"]])


# ---- Saidas --------------------------------------------------------

readr::write_csv(irf_dia, file.path(HET_OUT, "irf_daily.csv"))
readr::write_csv(irf_var, file.path(HET_OUT, "irf_var.csv"))
readr::write_csv(irf_fac, file.path(HET_OUT, "irf_factors.csv"))

#' Fator de exibicao de cada serie, o mesmo de script/fig_section5.R
#'
#' @param v Vetor de nomes de serie.
#'
#' @return Vetor numerico, `1` para serie fora de `ESCALAS`.
k_de <- function(v) {
  i <- match(v, ESCALAS$var)
  ifelse(is.na(i), 1, ESCALAS$k[i])
}

# Impactos lado a lado em +50 p.b., nas escalas de exibicao do artigo. O
# diario ja sai em unidades nativas; os mensais entram pela escala.
MAPA <- c(yield_3m = "di_3m", yield_6m = "di_6m",
          cds_5y = "cds_5y", cambio_usd = "brl")

impacto <- purrr::pmap_dfr(VERTICES, function(rotulo, diaria, mensal) {
  d <- irf_dia |> dplyr::filter(vertice == rotulo, h == 0) |>
    dplyr::transmute(var = names(MAPA)[match(var, MAPA)], het_diario = ponto,
                     identificado_diario = identificado)
  m <- irf_var |> dplyr::filter(vertice == rotulo, h == 0) |>
    dplyr::transmute(var, het_mensal = ponto * k_de(var),
                     identificado_mensal = identificado)
  dplyr::full_join(d, m, by = "var") |> dplyr::mutate(vertice = rotulo, .before = 1)
})

proxy <- readr::read_csv(PATH_PROXY_IRF, show_col_types = FALSE) |>
  dplyr::filter(h == 0, var %in% SERIES_FAC) |>
  dplyr::transmute(var, proxy = point * k_de(var))

fatorial <- irf_fac |> dplyr::filter(h == 0) |>
  dplyr::transmute(var, het_fatorial = ponto * k_de(var), identificado) |>
  dplyr::left_join(proxy, by = "var")

readr::write_csv(impacto,  file.path(HET_OUT, "irf_impact_comparison.csv"))
readr::write_csv(fatorial, file.path(HET_OUT, "irf_impact_factors.csv"))


# ---- Figura --------------------------------------------------------
#
# O vertice de 3 meses, o unico em que o diario identifica, contra o proxy.

#' Rotulo de exibicao de cada serie
#'
#' @param v Vetor de nomes de serie.
#'
#' @return Vetor de caracteres, o proprio nome para serie fora de `ESCALAS`.
rotulo <- function(v) {
  i <- match(v, ESCALAS$var)
  ifelse(is.na(i), v, ESCALAS$rotulo[i])
}
SERIES_FIG <- c("yield_3m", "cds_5y", "cambio_usd")

fig_df <- dplyr::bind_rows(
  irf_var |> dplyr::filter(vertice == "3 meses") |> dplyr::mutate(sistema = "Het: VAR mensal"),
  irf_fac |> dplyr::filter(var %in% SERIES_FIG) |>
    dplyr::mutate(vertice = "3 meses", sistema = "Het: inovacoes fatoriais")
) |>
  dplyr::mutate(dplyr::across(c(ponto, lo68, hi68, lo90, hi90), ~ .x * k_de(var)),
                painel = factor(rotulo(var), levels = rotulo(SERIES_FIG)))

proxy_df <- readr::read_csv(PATH_PROXY_IRF, show_col_types = FALSE) |>
  dplyr::filter(var %in% SERIES_FIG, h <= H) |>
  dplyr::transmute(h, var, ponto = point * k_de(var),
                   painel = factor(rotulo(var), levels = rotulo(SERIES_FIG)))

fig <- ggplot2::ggplot(fig_df, ggplot2::aes(h, ponto)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey40") +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = lo90, ymax = hi90, fill = sistema),
                       alpha = 0.15, colour = NA) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = lo68, ymax = hi68, fill = sistema),
                       alpha = 0.30, colour = NA) +
  ggplot2::geom_line(ggplot2::aes(colour = sistema), linewidth = 0.6) +
  ggplot2::geom_line(data = proxy_df, ggplot2::aes(h, ponto),
                     colour = "black", linetype = "dashed", linewidth = 0.6) +
  ggplot2::facet_wrap(~ painel, scales = "free_y") +
  ggplot2::labs(x = "Meses", y = NULL, colour = NULL, fill = NULL,
                caption = "Series de GRG (2025), vertice de 3 meses. Tracejado preto: proxy externo de producao. Bandas de 68% e 90% por reamostragem dentro de regime.") +
  ggplot2::theme_minimal(base_size = 10) +
  ggplot2::theme(legend.position = "bottom")

ggplot2::ggsave(file.path(HET_OUT, "irf_comparison.pdf"), fig, width = 9, height = 4)

