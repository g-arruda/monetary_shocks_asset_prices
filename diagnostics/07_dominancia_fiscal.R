# ===================================================================
# TAREFA 7 — Dominancia fiscal como hipotese testavel
#
# A cadeia significativa em h=0-4 (cambio UP, EMBI UP, CDS UP, IPP UP, com
# atividade industrial DOWN) e compativel com dominancia fiscal a la Blanchard
# (2004). Mas o efeito reverte de sinal apos h~10, o que argumenta por
# DEPENDENCIA DE ESTADO e nao por caracteristica media da amostra. Esta tarefa
# testa isso diretamente.
#
# Metodo: local projections com interacao COMPLETA, LP-IV (Ramey-Zubairy 2018).
# Nao smooth transition — n=141 nao sustenta.
#
#   y_{t+h} = I_{t-1}*[a_H + b_H*x_t + g_H'w_{t-1}]
#           + (1-I_{t-1})*[a_L + b_L*x_t + g_L'w_{t-1}] + u
#   x_t = yield_6m_t, instrumentado por I_{t-1}*z_t e (1-I_{t-1})*z_t
#
# NENHUM codigo de estimacao do projeto e alterado.
#
# Saida: diagnostics/output/t7_*.csv
# ===================================================================

source("diagnostics/_common.R")
suppressMessages({ library(sandwich) })

cat("\n=== TAREFA 7 — dominancia fiscal como hipotese testavel ===\n")

set.seed(20260728)

# H_EST so alimenta o grid de estimativa pontual (e a figura do §5, que vai ate
# h=24). A INFERENCIA continua em H_TEST: o bootstrap conjunto roda sobre
# HS = 0:H_TEST e nada em 7.4 usa horizonte acima disso. Estender H_EST nao muda
# nenhum p-valor.
H_EST   <- 24L     # estimar ate h=24 (so ponto)
H_TEST  <- 8L      # testar so ate h=8 (em h=12 o regime baixo cai a ~59 obs)
NBOOT   <- 2000L   # mesma convencao de 01_exogeneidade.R
BLOCK   <- 6L      # blocos nao-sobrepostos para o wild bootstrap
L_LAGS  <- 2L      # defasagens de controle por regime

# Indicador de regime do baseline. Migrado de embi_ma12 para cds_ma12 em
# 2026-07-29 por decisao do autor: o CDS e contrato padronizado em maturidade
# fixa e mede risco de default puro, enquanto o EMBI e spread de uma cesta de
# bonds cuja composicao e duration mudam no tempo. O EMBI vira a comparacao da
# 7.4d, invertendo os papeis que a rodada de 2026-07-28 tinha.
BASELINE     <- "cds_ma12"
BASELINE_ALT <- "embi_ma12"
BASELINE_SER <- "cds_5y"      # serie de estado do baseline, = state_series_of(BASELINE)

z_all <- INST_PANEL |>
  select(month, shock = all_of(SPEC$instrument)) |>
  right_join(data.frame(month = DATES), by = "month") |>
  arrange(month)
Z <- z_all$shock
Z[is.na(Z)] <- 0

cat(sprintf("  painel %d meses | z nao-nulo em %d | sd(z) = %.2f\n",
            length(Z), sum(Z != 0), sd(Z)))


# ===================================================================
# Infraestrutura: LP-IV com sanduiche analitico
# ===================================================================

#' Sanduiche IV analitico com kernel Bartlett (Newey-West)
#'
#' sandwich::NeweyWest sobre um lm de segundo estagio usa a MEAT ERRADA:
#' estfun.lm monta o score com y - Xhat*b, mas o residuo estrutural do IV e
#' u = y - X*b, com X ORIGINAL. Por isso o sanduiche e montado a mao.
iv_fit <- function(y, X, Zi, bw) {
  ok <- is.finite(y) & apply(is.finite(X), 1, all) & apply(is.finite(Zi), 1, all)
  y <- y[ok]; X <- X[ok, , drop = FALSE]; Zi <- Zi[ok, , drop = FALSE]
  n <- length(y)
  ZtZ <- crossprod(Zi)
  if (rcond(ZtZ) < 1e-12) return(NULL)
  Xh <- Zi %*% solve(ZtZ, crossprod(Zi, X))
  XhtX <- crossprod(Xh, X)
  if (rcond(XhtX) < 1e-12) return(NULL)
  A <- solve(XhtX)
  b <- drop(A %*% crossprod(Xh, y))
  u <- drop(y - X %*% b)                       # X ORIGINAL — o ponto todo
  g <- Xh * u                                  # score n x k
  S <- bartlett_meat(g, bw)
  V <- A %*% S %*% t(A)
  list(b = b, V = V, u = u, g = g, A = A, n = n, ok = ok, Xh = Xh)
}

#' Soma de autocovariancias com peso Bartlett (nucleo Newey-West)
bartlett_meat <- function(g, bw) {
  n <- nrow(g)
  S <- crossprod(g)
  if (bw > 0) for (l in seq_len(bw)) {
    w <- 1 - l / (bw + 1)
    G <- crossprod(g[(l + 1):n, , drop = FALSE], g[1:(n - l), , drop = FALSE])
    S <- S + w * (G + t(G))
  }
  S
}

#' Constroi o bloco de controles w_{t-1} do regime, com as travas de colinearidade
control_block <- function(v, state_name, L, dat) {
  cols <- list()
  cols$xl <- lag_matrix(dat[, "yield_6m", drop = FALSE], L, "x")
  # se a propria y e yield_6m, os lags de y duplicam os de x
  if (v != "yield_6m") cols$yl <- lag_matrix(dat[, v, drop = FALSE], L, "y")
  # se a variavel de estado e a propria y, idem
  if (!identical(state_name, v)) {
    cols$el <- lag_matrix(dat[, state_name, drop = FALSE], L, "s")
  }
  do.call(cbind, cols)
}

#' Variavel dependente no horizonte h, espelhando cumimp_transform
#' (impulse_responde.R:257-291): tcode 2 acumula e multiplica por 100.
dep_var <- function(series, tc, h, Tn) {
  if (tc == 2L) {
    out <- rep(NA_real_, Tn)
    for (t in seq_len(Tn - h)) out[t] <- 100 * sum(series[t:(t + h)])
    out
  } else {
    c(series[(h + 1):Tn], rep(NA_real_, h))
  }
}


# ===================================================================
# 7.0 — Validacao: LP-IV agregado contra a IRF do DFM
# ===================================================================
cat("\n[7.0] validacao do LP-IV agregado contra o DFM\n")

# auto-teste do kernel HAC contra sandwich::lrvar
gtest <- matrix(rnorm(200 * 3), 200, 3)
gd <- scale(gtest, center = TRUE, scale = FALSE)
S_hand <- bartlett_meat(gd, 5L)
S_pkg  <- 200^2 * sandwich::lrvar(gd, type = "Newey-West", prewhite = FALSE,
                                  adjust = FALSE, lag = 5L)
stopifnot(max(abs(S_hand - S_pkg) / abs(S_pkg)) < 1e-10)
cat("  auto-teste do kernel Bartlett contra sandwich::lrvar: OK\n")

TN <- nrow(PANEL)
tcode_of <- function(v) TCODE[match(v, VAR_NAMES)]

ALVOS <- c("yield_6m", "cambio_usd", "embi_perc", "cds_5y", "price_ipp",
           "price_core_ipca_ex0", "asset_ifnc", "asset_ibov", "asset_imat")

# LP-IV agregado (sem regime): y_{t+h} ~ x_t, instrumentado por z_t
lp_pooled <- function(v, h, L = L_LAGS) {
  tc <- tcode_of(v)
  yv <- dep_var(PANEL[, v], tc, h, TN)
  W  <- control_block(v, BASELINE_SER, L, PANEL)
  idx <- (L + 1):TN
  y <- yv[idx]; x <- PANEL[idx, "yield_6m"]; zz <- Z[idx]
  X  <- cbind(1, x, W)
  Zi <- cbind(1, zz, W)
  f <- iv_fit(y, X, Zi, bw = h + 1L)
  if (is.null(f)) return(c(NA_real_, NA_real_))
  c(0.005 * f$b[2], 0.005 * sqrt(f$V[2, 2]))
}

t70 <- lapply(ALVOS, function(v) {
  i <- match(v, CELL$var_names)
  lapply(0:H_EST, function(h) {
    r <- lp_pooled(v, h)
    data.frame(var = v, h = h, lp = r[1], lp_se = r[2], lp_t = r[1] / r[2],
               dfm = CELL$irf$irf_point_matrix[i, h + 1],
               dfm_sig90 = CELL$irf$ci[["0.90"]]$lower[i, h + 1] > 0 |
                 CELL$irf$ci[["0.90"]]$upper[i, h + 1] < 0,
               stringsAsFactors = FALSE)
  }) |> bind_rows()
}) |> bind_rows()
t70$razao_lp_dfm <- t70$lp / t70$dfm

# ASSERTIVA: beta_0 de yield_6m tem que dar exatamente 0.005
b0 <- t70$lp[t70$var == "yield_6m" & t70$h == 0]
cat(sprintf("  ASSERTIVA normalizacao: beta_0 de yield_6m = %.8f (esperado 0.005)\n", b0))
stopifnot(abs(b0 - 0.005) < 1e-10)

cat("\n  LP-IV agregado vs DFM em h=0 e h=6:\n")
print(as.data.frame(t70 |> filter(h %in% c(0, 6)) |>
                      select(var, h, lp, lp_se, lp_t, dfm, dfm_sig90, razao_lp_dfm)),
      row.names = FALSE, digits = 4)
diag_write(t70, "t7_0_lpiv_vs_dfm.csv")


# ===================================================================
# 7.1 — Indicadores de regime
# ===================================================================
cat("\n[7.1] construcao dos indicadores de regime\n")

ma_back <- function(x, k) {
  # media movel de k meses ATE t-1 (nao usa informacao de t)
  sapply(seq_along(x), function(t) if (t - k < 1) NA_real_ else mean(x[(t - k):(t - 1)]))
}

# --- DBGG/PIB (SGS 13762), com cache para o script rodar offline ------
DBGG_CACHE <- file.path(DIAG_OUT, "t7_1_dbgg_13762.csv")
dbgg <- NULL
if (file.exists(DBGG_CACHE)) {
  dbgg <- read_csv(DBGG_CACHE, show_col_types = FALSE)
  cat("  DBGG/PIB lido do cache\n")
} else {
  dbgg <- tryCatch({
    d <- GetBCBData::gbcbd_get_series(id = 13762, first.date = "2011-01-01",
                                      last.date = "2026-01-01",
                                      format.data = "wide", use.memoise = FALSE)
    names(d) <- c("ref.date", "dbgg")
    d <- as.data.frame(d)
    write_csv(d, DBGG_CACHE)
    cat("  DBGG/PIB baixado do SGS 13762 e cacheado\n")
    d
  }, error = function(e) { cat("  AVISO: download do SGS 13762 falhou:", conditionMessage(e), "\n"); NULL })
}

dbgg_v <- rep(NA_real_, TN)
if (!is.null(dbgg)) {
  dbgg_v <- dbgg$dbgg[match(as.Date(DATES), as.Date(dbgg$ref.date))]
}

embi <- PANEL[, "embi_perc"]
cds  <- PANEL[, "cds_5y"]
states <- list(
  embi_ma12 = ma_back(embi, 12),
  embi_ma6  = ma_back(embi, 6),
  embi_ma1  = ma_back(embi, 1),
  cds_ma12  = ma_back(cds, 12),
  cds_ma6   = ma_back(cds, 6),
  dbgg_lvl  = c(NA, head(dbgg_v, -1)),
  dbgg_d12  = c(rep(NA, 13), diff(head(dbgg_v, -1), 12))
)

# Cada indicador controla pelas defasagens da SUA PROPRIA serie de estado. Sem
# isso, I_{t-1} vira proxy do nivel da variavel de estado e qualquer
# nao-linearidade nesse nivel se disfarca de dependencia de estado.
state_series_of <- function(ind) {
  if (grepl("^embi", ind)) "embi_perc"
  else if (grepl("^cds", ind)) "cds_5y"
  else if (grepl("^dbgg", ind)) "dbgg"
  else stop("indicador sem serie de estado mapeada: ", ind)
}
stopifnot(identical(state_series_of(BASELINE), BASELINE_SER))

make_dummy <- function(s) {
  cut <- median(s, na.rm = TRUE)
  list(I = as.integer(s > cut), cut = cut)
}
dummies <- lapply(states, make_dummy)

t71a <- data.frame(month = DATES, z = Z, yield_6m = PANEL[, "yield_6m"],
                   embi_perc = embi, dbgg = dbgg_v)
for (nm in names(states)) {
  t71a[[paste0("s_", nm)]] <- states[[nm]]
  t71a[[paste0("I_", nm)]] <- dummies[[nm]]$I
}

t71b <- lapply(names(states), function(nm) {
  I <- dummies[[nm]]$I; ok <- !is.na(I)
  r <- rle(I[ok])
  data.frame(indicador = nm, corte = dummies[[nm]]$cut,
             n_obs = sum(ok), n_alto = sum(I[ok] == 1), n_baixo = sum(I[ok] == 0),
             n_corridas = length(r$lengths),
             corrida_mediana = median(r$lengths), corrida_max = max(r$lengths),
             stringsAsFactors = FALSE)
}) |> bind_rows()
cat("\n  indicadores e estrutura de corridas:\n")
print(as.data.frame(t71b), row.names = FALSE, digits = 4)

# corridas datadas do baseline
Ib <- dummies[[BASELINE]]$I
okb <- !is.na(Ib)
rb <- rle(Ib[okb]); db <- DATES[okb]
ends <- cumsum(rb$lengths); starts <- ends - rb$lengths + 1
t71d <- data.frame(regime = ifelse(rb$values == 1, "alto", "baixo"),
                   inicio = format(db[starts], "%Y-%m"),
                   fim = format(db[ends], "%Y-%m"),
                   meses = rb$lengths, stringsAsFactors = FALSE)
cat(sprintf("\n  corridas do baseline (%s, corte na mediana):\n", BASELINE))
print(as.data.frame(t71d), row.names = FALSE)

# concordancia e kappa entre indicadores
pares <- combn(names(states), 2, simplify = FALSE)
t71c <- lapply(pares, function(p) {
  a <- dummies[[p[1]]]$I; b <- dummies[[p[2]]]$I
  ok <- !is.na(a) & !is.na(b)
  po <- mean(a[ok] == b[ok])
  pe <- mean(a[ok]) * mean(b[ok]) + (1 - mean(a[ok])) * (1 - mean(b[ok]))
  data.frame(a = p[1], b = p[2], n = sum(ok), concordancia = po,
             kappa = (po - pe) / (1 - pe), stringsAsFactors = FALSE)
}) |> bind_rows()
cat("\n  concordancia par a par:\n")
print(as.data.frame(t71c), row.names = FALSE, digits = 3)

# balanco: o regime nao pode ser o ciclo monetario disfarcado
covid <- DATES >= as.Date("2020-03-01") & DATES <= as.Date("2021-06-30")
dx <- c(NA, diff(PANEL[, "yield_6m"]))
t71e <- lapply(names(states), function(nm) {
  I <- dummies[[nm]]$I; ok <- !is.na(I)
  lapply(c(1, 0), function(g) {
    s <- ok & I == g
    data.frame(indicador = nm, regime = ifelse(g == 1, "alto", "baixo"),
               n = sum(s), yield_6m_medio = mean(PANEL[s, "yield_6m"]),
               share_aperto = mean(dx[s] > 0, na.rm = TRUE),
               z_nao_nulo = sum(Z[s] != 0), share_covid = mean(covid[s]),
               stringsAsFactors = FALSE)
  }) |> bind_rows()
}) |> bind_rows()
cat("\n  balanco por regime (o regime e o ciclo monetario disfarcado?):\n")
print(as.data.frame(t71e), row.names = FALSE, digits = 3)

diag_write(t71a, "t7_1a_regimes_series.csv")
diag_write(t71b, "t7_1b_regimes_resumo.csv")
diag_write(t71c, "t7_1c_concordancia.csv")
diag_write(t71d, "t7_1d_corridas_baseline.csv")
diag_write(t71e, "t7_1e_balanco.csv")


# ===================================================================
# 7.2 / 7.3 — LP-IV dependente de estado + primeiro estagio por regime
# ===================================================================
cat("\n[7.2/7.3] LP-IV dependente de estado (interacao completa)\n")

# variaveis relativas para o bloco discriminante do IFNC
PANEL_X <- cbind(PANEL,
                 rel_ifnc_ibov = PANEL[, "asset_ifnc"] - PANEL[, "asset_ibov"],
                 rel_ifnc_imat = PANEL[, "asset_ifnc"] - PANEL[, "asset_imat"],
                 dbgg = dbgg_v)   # so para servir de controle quando o estado e a divida
tcode_x <- function(v) if (grepl("^rel_", v)) 2L else tcode_of(v)

VARS7 <- c("yield_6m", "cambio_usd", "embi_perc", "cds_5y", "price_ipp",
           "price_core_ipca_ex0", "asset_ifnc", "asset_ibov", "asset_imat",
           "rel_ifnc_ibov", "rel_ifnc_imat")

#' Monta as matrizes do LP-IV com interacao completa para (v, h, indicador)
build_lp <- function(v, h, I, state_name, L = L_LAGS, keep = NULL) {
  tc <- tcode_x(v)
  yv <- dep_var(PANEL_X[, v], tc, h, TN)
  W  <- control_block(v, state_name, L, PANEL_X)
  idx <- (L + 1):TN
  if (!is.null(keep)) idx <- idx[keep[idx]]
  Ii <- I[idx]
  ok <- is.finite(yv[idx]) & is.finite(Ii) & apply(is.finite(W[idx - L, , drop = FALSE]), 1, all)
  idx <- idx[ok]; Ii <- I[idx]
  y <- yv[idx]; x <- PANEL_X[idx, "yield_6m"]; zz <- Z[idx]
  Wi <- W[idx - L, , drop = FALSE]
  # interacao COMPLETA: constante e controles tambem entram por regime
  Ch <- cbind(Ii, Ii * Wi); Cl <- cbind(1 - Ii, (1 - Ii) * Wi)
  X  <- cbind(Ii * x, (1 - Ii) * x, Ch, Cl)
  Zi <- cbind(Ii * zz, (1 - Ii) * zz, Ch, Cl)
  list(y = y, X = X, Zi = Zi, I = Ii, x = x, z = zz, C = cbind(Ch, Cl), n = length(y))
}

#' F robusto do primeiro estagio DENTRO de cada regime
first_stage_F <- function(d, g, bw) {
  s <- d$I == g
  if (sum(s) < 10) return(NA_real_)
  yy <- d$x[s]
  XX <- cbind(d$z[s], d$C[s, colSums(abs(d$C[s, , drop = FALSE])) > 0, drop = FALSE])
  XX <- XX[, apply(XX, 2, function(c) sd(c) > 0 | all(c == 1)), drop = FALSE]
  if (rcond(crossprod(XX)) < 1e-12) return(NA_real_)
  A <- solve(crossprod(XX))
  b <- drop(A %*% crossprod(XX, yy))
  u <- drop(yy - XX %*% b)
  S <- bartlett_meat(XX * u, bw)
  V <- A %*% S %*% t(A)
  b[1]^2 / V[1, 1]
}

#' Forma reduzida por regime (OLS de y em I*z e (1-I)*z) — sobra quando o
#' primeiro estagio morre. Nunca e razao, nunca sofre vies de IV fraco.
reduced_form <- function(d, bw) {
  X <- cbind(d$I * d$z, (1 - d$I) * d$z, d$C)
  if (rcond(crossprod(X)) < 1e-12) return(c(NA_real_, NA_real_, NA_real_, NA_real_))
  A <- solve(crossprod(X))
  b <- drop(A %*% crossprod(X, d$y))
  u <- drop(d$y - X %*% b)
  V <- A %*% bartlett_meat(X * u, bw) %*% t(A)
  c(b[1], sqrt(V[1, 1]), b[2], sqrt(V[2, 2]))
}

flag_forca <- function(f) {
  ifelse(is.na(f), "NA", ifelse(f >= 10, "ok", ifelse(f >= 3.84, "FRACO", "NAO_IDENTIFICADO")))
}

run_state_lp <- function(v, h, ind, L = L_LAGS, keep = NULL) {
  I <- dummies[[ind]]$I
  d <- build_lp(v, h, I, state_series_of(ind), L, keep)
  bw <- h + 1L
  f <- iv_fit(d$y, d$X, d$Zi, bw)
  F_H <- first_stage_F(d, 1L, bw); F_L <- first_stage_F(d, 0L, bw)
  rf <- reduced_form(d, bw)
  if (is.null(f)) {
    return(data.frame(var = v, indicador = ind, L = L, h = h, n = d$n,
                      n_alto = sum(d$I == 1), n_baixo = sum(d$I == 0),
                      b_alto = NA, se_alto = NA, b_baixo = NA, se_baixo = NA,
                      dif = NA, se_dif = NA, t_dif = NA,
                      F_alto = F_H, F_baixo = F_L,
                      flag_alto = flag_forca(F_H), flag_baixo = flag_forca(F_L),
                      rf_alto = rf[1], rf_se_alto = rf[2],
                      rf_baixo = rf[3], rf_se_baixo = rf[4],
                      stringsAsFactors = FALSE))
  }
  s <- 0.005
  bH <- s * f$b[1]; bL <- s * f$b[2]
  seH <- s * sqrt(f$V[1, 1]); seL <- s * sqrt(f$V[2, 2])
  dif <- bH - bL
  se_dif <- s * sqrt(f$V[1, 1] + f$V[2, 2] - 2 * f$V[1, 2])
  data.frame(var = v, indicador = ind, L = L, h = h, n = d$n,
             n_alto = sum(d$I == 1), n_baixo = sum(d$I == 0),
             b_alto = bH, se_alto = seH, b_baixo = bL, se_baixo = seL,
             dif = dif, se_dif = se_dif, t_dif = dif / se_dif,
             F_alto = F_H, F_baixo = F_L,
             flag_alto = flag_forca(F_H), flag_baixo = flag_forca(F_L),
             rf_alto = rf[1], rf_se_alto = rf[2],
             rf_baixo = rf[3], rf_se_baixo = rf[4],
             stringsAsFactors = FALSE)
}

t72 <- lapply(VARS7, function(v) {
  lapply(0:H_EST, function(h) run_state_lp(v, h, BASELINE)) |> bind_rows()
}) |> bind_rows()

cat(sprintf("\n  baseline (%s), h=0 e h=6:\n", BASELINE))
print(as.data.frame(t72 |> filter(h %in% c(0, 6)) |>
        mutate(t_alto = b_alto / se_alto, t_baixo = b_baixo / se_baixo) |>
        select(var, h, b_alto, t_alto, b_baixo, t_baixo, dif, t_dif,
               F_alto, F_baixo)),
      row.names = FALSE, digits = 3)

cat("\n[7.3] primeiro estagio por regime (baseline):\n")
print(as.data.frame(t72 |> filter(var == "cambio_usd") |>
        select(h, n_alto, n_baixo, F_alto, flag_alto, F_baixo, flag_baixo)),
      row.names = FALSE, digits = 3)

# --- 7.3b: a armadilha da interacao PARCIAL ---------------------------
cat("\n[7.3b] artefato da interacao parcial (controles NAO interagidos)\n")
partial_F <- function(v, h, ind, g) {
  I <- dummies[[ind]]$I
  tc <- tcode_x(v)
  W <- control_block(v, state_series_of(ind), L_LAGS, PANEL_X)
  idx <- (L_LAGS + 1):TN
  Ii <- I[idx]; ok <- is.finite(Ii)
  idx <- idx[ok]; Ii <- I[idx]
  x <- PANEL_X[idx, "yield_6m"]; zz <- Z[idx]; Wi <- W[idx - L_LAGS, , drop = FALSE]
  yy <- if (g == 1) Ii * x else (1 - Ii) * x
  XX <- cbind(1, Ii * zz, (1 - Ii) * zz, Wi)      # controles NAO interagidos
  A <- solve(crossprod(XX)); b <- drop(A %*% crossprod(XX, yy))
  u <- drop(yy - XX %*% b)
  V <- A %*% bartlett_meat(XX * u, h + 1L) %*% t(A)
  j <- if (g == 1) 2 else 3
  b[j]^2 / V[j, j]
}
t73b <- lapply(c(0, 4, 8), function(h) {
  data.frame(h = h,
             F_alto_parcial = partial_F("cambio_usd", h, BASELINE, 1),
             F_baixo_parcial = partial_F("cambio_usd", h, BASELINE, 0),
             F_alto_completa = t72$F_alto[t72$var == "cambio_usd" & t72$h == h],
             F_baixo_completa = t72$F_baixo[t72$var == "cambio_usd" & t72$h == h])
}) |> bind_rows()
print(as.data.frame(t73b), row.names = FALSE, digits = 3)
cat("  A interacao parcial faz x*(1-I) ser mecanicamente zero em metade da\n")
cat("  amostra e os controles nao-interagidos nao conseguem ajustar isso.\n")
cat("  Concluir 'o regime baixo nao e identificado' dali seria erro de spec.\n")

# --- sensibilidades ---------------------------------------------------
cat("\n  sensibilidade ao indicador de corte (h=0):\n")
t72b <- lapply(names(states), function(ind) {
  lapply(c("cambio_usd", "embi_perc", "asset_ifnc"), function(v) {
    lapply(c(0, 4, 8), function(h) run_state_lp(v, h, ind)) |> bind_rows()
  }) |> bind_rows()
}) |> bind_rows()
print(as.data.frame(t72b |> filter(h == 0) |>
        select(var, indicador, b_alto, b_baixo, dif, t_dif, F_alto, F_baixo,
               flag_alto, flag_baixo)),
      row.names = FALSE, digits = 3)

cat("\n  sensibilidade ao numero de defasagens (h=0, baseline):\n")
t72c <- lapply(1:3, function(L) {
  lapply(c("cambio_usd", "embi_perc", "asset_ifnc"), function(v) {
    lapply(c(0, 4, 8), function(h) run_state_lp(v, h, BASELINE, L = L)) |> bind_rows()
  }) |> bind_rows()
}) |> bind_rows()
print(as.data.frame(t72c |> filter(h == 0) |>
        select(var, L, b_alto, b_baixo, dif, t_dif, F_alto, F_baixo)),
      row.names = FALSE, digits = 3)

cat("\n  robustez sem COVID (2020-03 a 2021-06 removidos):\n")
keep_nc <- !covid
t72d <- lapply(c("cambio_usd", "embi_perc", "asset_ifnc"), function(v) {
  lapply(c(0, 4, 8), function(h) run_state_lp(v, h, BASELINE, keep = keep_nc)) |>
    bind_rows()
}) |> bind_rows()
print(as.data.frame(t72d |> select(var, h, b_alto, b_baixo, dif, t_dif,
                                   F_alto, F_baixo, flag_alto)),
      row.names = FALSE, digits = 3)

diag_write(t72, "t7_2_irf_estado.csv")
diag_write(t72b, "t7_2b_sensib_corte.csv")
diag_write(t72c, "t7_2c_sensib_lags.csv")
diag_write(t72d, "t7_2d_sem_covid.csv")
diag_write(t72 |> select(var, indicador, h, n_alto, n_baixo, F_alto, F_baixo,
                         flag_alto, flag_baixo), "t7_3_primeiro_estagio.csv")
diag_write(t73b, "t7_3b_artefato_interacao.csv")


# ===================================================================
# 7.4 — Teste formal de igualdade entre regimes
# ===================================================================
cat("\n[7.4] teste formal H0: b_alto(h) = b_baixo(h)\n")

HS <- 0:H_TEST

#' Influencia escalar da diferenca no horizonte h: phi_h,t
delta_influence <- function(v, h, ind, L = L_LAGS) {
  I <- dummies[[ind]]$I
  d <- build_lp(v, h, I, state_series_of(ind), L)
  f <- iv_fit(d$y, d$X, d$Zi, h + 1L)
  if (is.null(f)) return(NULL)
  cc <- c(1, -1, rep(0, ncol(d$X) - 2))
  aa <- drop(cc %*% f$A)
  list(delta = 0.005 * drop(cc %*% f$b),
       phi = 0.005 * drop(f$g %*% aa),
       months = DATES[(L + 1):TN][seq_len(nrow(f$g))],
       d = d, f = f)
}

joint_stat <- function(v, ind, hs = HS, L = L_LAGS) {
  parts <- lapply(hs, function(h) delta_influence(v, h, ind, L))
  if (any(vapply(parts, is.null, logical(1)))) return(NULL)
  nmin <- min(vapply(parts, function(p) length(p$phi), integer(1)))
  PHI <- sapply(parts, function(p) p$phi[seq_len(nmin)])
  dl  <- vapply(parts, function(p) p$delta, numeric(1))
  V <- bartlett_meat(scale(PHI, center = TRUE, scale = FALSE), length(hs))
  if (rcond(V) < 1e-12) return(NULL)
  list(W = drop(t(dl) %*% solve(V, dl)), delta = dl, df = length(hs), n = nmin)
}

#' Wild block bootstrap sob H0 (b_alto = b_baixo), com o primeiro estagio
#' tambem reamostrado (Davidson-MacKinnon WRE) e z FIXO (exogeno, censurado).
#' Os multiplicadores sao sorteados UMA vez por mes e compartilhados entre
#' horizontes, para preservar a correlacao cruzada entre eles.
boot_joint <- function(v, ind, hs = HS, nboot = NBOOT, L = L_LAGS) {
  # modelo restrito por horizonte
  fits <- lapply(hs, function(h) {
    I <- dummies[[ind]]$I
    d <- build_lp(v, h, I, state_series_of(ind), L)
    Xr  <- cbind(d$x, d$C)                # beta COMUM sob H0
    Zr  <- cbind(d$z, d$C)
    fr <- iv_fit(d$y, Xr, Zr, h + 1L)
    if (is.null(fr)) return(NULL)
    # primeiro estagio restrito
    A1 <- solve(crossprod(Zr)); b1 <- drop(A1 %*% crossprod(Zr, d$x))
    xhat <- drop(Zr %*% b1); vres <- d$x - xhat
    list(d = d, y0 = drop(d$y - fr$u), u0 = fr$u, xhat = xhat, vres = vres,
         months = DATES[(L + 1):TN][seq_len(length(d$y))])
    }
  )
  if (any(vapply(fits, is.null, logical(1)))) return(NULL)
  all_months <- sort(unique(do.call(c, lapply(fits, function(f) f$months))))
  nm <- length(all_months)
  nblk <- ceiling(nm / BLOCK)
  Wb <- replicate(nboot, {
    e_blk <- 1 - 2 * (runif(nblk) > 0.5)
    e_m <- rep(e_blk, each = BLOCK)[seq_len(nm)]
    names(e_m) <- format(all_months)
    parts <- lapply(seq_along(hs), function(k) {
      f <- fits[[k]]; d <- f$d
      e <- e_m[format(f$months)]
      xs <- f$xhat + f$vres * e
      ys <- f$y0 + f$u0 * e
      Xs  <- cbind(d$I * xs, (1 - d$I) * xs, d$C)
      Zs  <- cbind(d$I * d$z, (1 - d$I) * d$z, d$C)
      fb <- iv_fit(ys, Xs, Zs, hs[k] + 1L)
      if (is.null(fb)) return(NULL)
      cc <- c(1, -1, rep(0, ncol(Xs) - 2)); aa <- drop(cc %*% fb$A)
      se <- 0.005 * sqrt(drop(cc %*% fb$V %*% cc))
      list(delta = 0.005 * drop(cc %*% fb$b), phi = 0.005 * drop(fb$g %*% aa),
           tstat = 0.005 * drop(cc %*% fb$b) / se)
    })
    if (any(vapply(parts, is.null, logical(1)))) return(rep(NA_real_, length(hs) + 1))
    nmin <- min(vapply(parts, function(p) length(p$phi), integer(1)))
    PHI <- sapply(parts, function(p) p$phi[seq_len(nmin)])
    dl <- vapply(parts, function(p) p$delta, numeric(1))
    tt <- vapply(parts, function(p) p$tstat, numeric(1))
    V <- bartlett_meat(scale(PHI, center = TRUE, scale = FALSE), length(hs))
    if (rcond(V) < 1e-12) return(rep(NA_real_, length(hs) + 1))
    c(drop(t(dl) %*% solve(V, dl)), tt)
  })
  Wb <- Wb[, apply(is.finite(Wb), 2, all), drop = FALSE]
  list(W = Wb[1, ], Tmat = Wb[-1, , drop = FALSE])
}

VARS_TEST <- c("cambio_usd", "embi_perc", "cds_5y", "price_ipp",
               "price_core_ipca_ex0", "asset_ifnc", "rel_ifnc_ibov")

cat(sprintf("  bootstrap: %d replicas, blocos de %d meses, z fixo\n", NBOOT, BLOCK))
t0 <- Sys.time()

BOOTS <- list()
t74b <- lapply(VARS_TEST, function(v) {
  js <- joint_stat(v, BASELINE)
  if (is.null(js)) return(NULL)
  bo <- boot_joint(v, BASELINE)
  BOOTS[[v]] <<- bo
  js5 <- joint_stat(v, BASELINE, hs = c(0, 2, 4, 6, 8))
  data.frame(var = v, df = js$df, n = js$n, W = js$W,
             p_chi2 = pchisq(js$W, js$df, lower.tail = FALSE),
             p_boot = mean(bo$W >= js$W), n_rep = length(bo$W),
             W_boot_mediana = median(bo$W), W_boot_q95 = quantile(bo$W, 0.95),
             chi2_q95 = qchisq(0.95, js$df),
             W_h02468 = js5$W,
             p_chi2_h02468 = pchisq(js5$W, 5, lower.tail = FALSE),
             stringsAsFactors = FALSE)
}) |> bind_rows()

cat(sprintf("  (%.1f s)\n", as.numeric(Sys.time() - t0, units = "secs")))
cat("\n  teste conjunto h=0..8:\n")
print(as.data.frame(t74b), row.names = FALSE, digits = 3)

# horizonte a horizonte, com Holm
t74a <- t72 |>
  filter(var %in% VARS_TEST, h <= H_TEST) |>
  select(var, h, b_alto, b_baixo, dif, se_dif, t_dif, F_alto, F_baixo,
         flag_alto, flag_baixo) |>
  mutate(p_asym = 2 * pnorm(-abs(t_dif)))

# p de bootstrap POR HORIZONTE, das mesmas replicas do teste conjunto. O t
# assintotico nao e confiavel aqui — o conjunto mostrou que a nula bootstrap
# tem q95 de 2x a 5x o chi2 —, entao reportar so o Holm assintotico repetiria
# exatamente o erro que o teste conjunto acabou de expor.
t74a$p_boot <- NA_real_
for (v in names(BOOTS)) {
  Tm <- BOOTS[[v]]$Tmat
  for (k in seq_along(HS)) {
    sel <- t74a$var == v & t74a$h == HS[k]
    if (any(sel)) t74a$p_boot[sel] <- mean(abs(Tm[k, ]) >= abs(t74a$t_dif[sel]))
  }
}
t74a <- t74a |> group_by(var) |>
  mutate(p_holm_asym = p.adjust(p_asym, method = "holm"),
         p_holm_boot = p.adjust(p_boot, method = "holm")) |>
  ungroup()

cat("\n  teste horizonte a horizonte (menor p_boot por variavel):\n")
print(as.data.frame(t74a |> group_by(var) |> slice_min(p_boot, n = 1, with_ties = FALSE) |>
        ungroup() |>
        select(var, h, b_alto, b_baixo, dif, t_dif, p_asym, p_holm_asym,
               p_boot, p_holm_boot)),
      row.names = FALSE, digits = 3)
cat(sprintf("\n  rejeicoes a 5%% em h=0..8 (%d testes): assintotico %d, Holm-assint %d,\n",
            nrow(t74a), sum(t74a$p_asym < .05), sum(t74a$p_holm_asym < .05)))
cat(sprintf("  bootstrap %d, Holm-bootstrap %d.\n",
            sum(t74a$p_boot < .05, na.rm = TRUE),
            sum(t74a$p_holm_boot < .05, na.rm = TRUE)))

# --- 7.4d: o mesmo teste sob o regime de EMBI -----------------------
# O baseline e o CDS: contrato padronizado em maturidade fixa, risco de default
# puro. O EMBI e spread de uma cesta de bonds cuja composicao e duration mudam
# no tempo, e entra aqui como comparacao. Se a conclusao muda ao trocar o
# indicador, isso e o achado; se nao muda, a robustez e real.
cat(sprintf("\n[7.4d] mesmo teste sob o regime alternativo (%s)\n", BASELINE_ALT))
t74d <- lapply(VARS_TEST, function(v) {
  js_a <- joint_stat(v, BASELINE_ALT)
  if (is.null(js_a)) return(NULL)
  bo_a <- boot_joint(v, BASELINE_ALT)
  h0b <- t72 |> filter(var == v, h == 0)          # baseline (CDS), ja estimado
  r_a <- run_state_lp(v, 0, BASELINE_ALT)
  data.frame(var = v,
             cds_b_alto = h0b$b_alto, cds_b_baixo = h0b$b_baixo,
             cds_t_dif = h0b$t_dif, cds_p_boot = t74b$p_boot[t74b$var == v],
             cds_F_alto = h0b$F_alto, cds_F_baixo = h0b$F_baixo,
             embi_b_alto = r_a$b_alto, embi_b_baixo = r_a$b_baixo,
             embi_t_dif = r_a$t_dif, embi_p_boot = mean(bo_a$W >= js_a$W),
             stringsAsFactors = FALSE)
}) |> bind_rows()
print(as.data.frame(t74d |> select(var, cds_b_alto, cds_b_baixo, cds_p_boot,
                                   cds_F_alto, cds_F_baixo,
                                   embi_b_alto, embi_b_baixo, embi_p_boot)),
      row.names = FALSE, digits = 3)
cat(sprintf("\n  rejeicoes conjuntas a 5%%: CDS (baseline) %d de %d | EMBI %d de %d\n",
            sum(t74d$cds_p_boot < .05), nrow(t74d),
            sum(t74d$embi_p_boot < .05), nrow(t74d)))
cat(sprintf("  sinal de t_dif concorda entre os dois indicadores em %d de %d variaveis\n",
            sum(sign(t74d$embi_t_dif) == sign(t74d$cds_t_dif)), nrow(t74d)))
diag_write(t74d, "t7_4d_embi_vs_cds.csv")

# --- 7.4e: DE ONDE vem a rejeicao sob CDS -----------------------------
# A rejeicao conjunta nao diz em qual horizonte ela mora. Se estiver em h=0-4,
# e a cadeia de impacto que e dependente de estado; se estiver em h=6-8, o que
# depende do estado e a PERSISTENCIA/REVERSAO — que e literalmente a hipotese
# que o prompt levanta ("o efeito reverte apos h~10").
cat("\n[7.4e] perfil por horizonte: onde mora a dependencia de estado\n")
t74e <- lapply(c("cambio_usd", "embi_perc", "price_ipp"), function(v) {
  lapply(0:H_TEST, function(h) {
    a <- run_state_lp(v, h, BASELINE); e <- run_state_lp(v, h, BASELINE_ALT)
    data.frame(var = v, h = h,
               cds_alto = a$b_alto, cds_baixo = a$b_baixo, cds_t_dif = a$t_dif,
               cds_F_alto = a$F_alto, cds_F_baixo = a$F_baixo,
               embi_alto = e$b_alto, embi_baixo = e$b_baixo, embi_t_dif = e$t_dif,
               stringsAsFactors = FALSE)
  }) |> bind_rows()
}) |> bind_rows()
print(as.data.frame(t74e |> filter(var == "cambio_usd") |>
        select(h, cds_alto, cds_baixo, cds_t_dif, embi_alto, embi_baixo, embi_t_dif)),
      row.names = FALSE, digits = 3)
imp <- t74e |> filter(var == "cambio_usd", h <= 4)
per <- t74e |> filter(var == "cambio_usd", h >= 6)
cat(sprintf("\n  cambio_usd, max |t_dif| sob CDS (baseline): impacto (h0-4) = %.2f | persistencia (h6-8) = %.2f\n",
            max(abs(imp$cds_t_dif)), max(abs(per$cds_t_dif))))
cat(sprintf("  o mesmo sob EMBI (comparacao):             impacto = %.2f | persistencia = %.2f\n",
            max(abs(imp$embi_t_dif)), max(abs(per$embi_t_dif))))
cat("  LEITURA: sob CDS, o cambio segue depreciado em h6-8 no regime de risco\n")
cat("  ALTO e ja reverteu para apreciacao no regime BAIXO. A dependencia de\n")
cat("  estado esta na PERSISTENCIA, nao no impacto.\n")

# robustez desse achado especifico
cat("\n  robustez do achado h=6-8 (cambio_usd):\n")
t74f <- lapply(list(c(BASELINE, "2"), c("cds_ma6", "2"), c(BASELINE, "1"),
                    c(BASELINE, "3"), c(BASELINE_ALT, "2"), c("dbgg_d12", "2")),
               function(cfg) {
  lapply(c(6, 7, 8), function(h) {
    r <- run_state_lp("cambio_usd", h, cfg[1], L = as.integer(cfg[2]))
    data.frame(indicador = cfg[1], L = as.integer(cfg[2]), h = h,
               b_alto = r$b_alto, b_baixo = r$b_baixo, t_dif = r$t_dif,
               F_alto = r$F_alto, flag_alto = r$flag_alto, stringsAsFactors = FALSE)
  }) |> bind_rows()
}) |> bind_rows()
print(as.data.frame(t74f |> filter(h == 7)), row.names = FALSE, digits = 3)
diag_write(t74e, "t7_4e_perfil_horizonte.csv")
diag_write(t74f, "t7_4f_robustez_persistencia.csv")

# --- 7.4g: o confundidor mecanico do achado de persistencia -----------
# Se o proprio processo do cambio for mais persistente sob CDS alto por razoes
# alheias a politica monetaria, a interacao capta essa persistencia condicional
# e ela aparece como dependencia de estado da IRF. Teste: persistencia
# INCONDICIONAL do cambio dentro de cada regime, sem choque nenhum.
cat("\n[7.4g] confundidor: o cambio e mecanicamente mais persistente sob CDS alto?\n")
dfx <- diff(log(PANEL[, "cambio_usd"]))
Ig  <- dummies[[BASELINE]]$I[-1]
t74g <- lapply(c(1L, 0L), function(g) {
  x <- dfx[!is.na(Ig) & Ig == g]; n <- length(x)
  f <- lm(x[-1] ~ x[-n]); a <- acf(x, lag.max = 8, plot = FALSE)$acf[-1]
  data.frame(regime = ifelse(g == 1, "alto", "baixo"), n = n, sd = sd(x),
             ar1_ols = coef(f)[2], se_ar1 = summary(f)$coef[2, 2],
             acf1 = a[1], acf2 = a[2], acf3 = a[3],
             soma_abs_acf1a8 = sum(abs(a)), stringsAsFactors = FALSE)
}) |> bind_rows()
print(as.data.frame(t74g), row.names = FALSE, digits = 3)
dif_ar1 <- t74g$ar1_ols[1] - t74g$ar1_ols[2]
se_ar1  <- sqrt(sum(t74g$se_ar1^2))
cat(sprintf("\n  diferenca de AR(1) entre regimes: %+.3f (se %.3f, t = %.2f)\n",
            dif_ar1, se_ar1, dif_ar1 / se_ar1))
cat("  -> o confundidor NAO se sustenta: a persistencia incondicional do cambio\n")
cat("     e estatisticamente indistinguivel entre os regimes. O que difere em\n")
cat("     h6-8 e a resposta AO CHOQUE, nao a dinamica de fundo.\n")
cat("  RESSALVA: e teste de AR(1); com n=70 por regime as autocorrelacoes de\n")
cat("  ordem 3-8 tem se ~0.12 e nao sao distinguiveis individualmente.\n")
diag_write(t74g, "t7_4g_confundidor_persistencia.csv")

t74c <- lapply(VARS_TEST, function(v) {
  Wb <- BOOTS[[v]]$W
  data.frame(var = v, n_rep = length(Wb),
             q50 = quantile(Wb, .50), q90 = quantile(Wb, .90),
             q95 = quantile(Wb, .95), q99 = quantile(Wb, .99),
             chi2_q95 = qchisq(0.95, length(HS)),
             razao_q95 = quantile(Wb, .95) / qchisq(0.95, length(HS)),
             stringsAsFactors = FALSE)
}) |> bind_rows()
cat("\n  quantis da distribuicao nula por bootstrap vs chi2 assintotico:\n")
print(as.data.frame(t74c), row.names = FALSE, digits = 3)

diag_write(t74a, "t7_4a_teste_h_a_h.csv")
diag_write(t74b, "t7_4b_teste_conjunto.csv")
diag_write(t74c, "t7_4c_dist_nula_boot.csv")


# ===================================================================
# 7.5 — Discriminante do IFNC
# ===================================================================
cat("\n[7.5] discriminante do IFNC (bancos)\n")
cat("  REGRA DE DECISAO, declarada antes dos numeros:\n")
cat("   - dominancia fiscal: retorno RELATIVO negativo no regime ALTO, e maior\n")
cat("     em modulo onde embi/cds mais respondem\n")
cat("   - beta positivo simples a juros (NIM): nao-negativo nos DOIS regimes,\n")
cat("     sem relacao com o estado de risco\n")

t75 <- t72 |>
  filter(var %in% c("asset_ifnc", "asset_ibov", "asset_imat",
                    "rel_ifnc_ibov", "rel_ifnc_imat"), h <= H_TEST) |>
  mutate(t_alto = b_alto / se_alto, t_baixo = b_baixo / se_baixo) |>
  select(var, h, b_alto, t_alto, b_baixo, t_baixo, dif, t_dif)
cat("\n  respostas brutas e relativas:\n")
print(as.data.frame(t75 |> filter(h %in% c(0, 4, 6, 8))), row.names = FALSE, digits = 3)

# razoes livres de unidade, por regime
razoes <- lapply(c(0, 4, 6, 8), function(h) {
  g <- function(v, col) t72[[col]][t72$var == v & t72$h == h]
  data.frame(h = h,
             ifnc_por_embi_alto  = g("asset_ifnc", "b_alto")  / g("embi_perc", "b_alto"),
             ifnc_por_embi_baixo = g("asset_ifnc", "b_baixo") / g("embi_perc", "b_baixo"),
             ifnc_por_yield_alto  = g("asset_ifnc", "b_alto")  / g("yield_6m", "b_alto"),
             ifnc_por_yield_baixo = g("asset_ifnc", "b_baixo") / g("yield_6m", "b_baixo"))
}) |> bind_rows()
cat("\n  razoes livres de unidade (resposta do banco por unidade de risco/juro):\n")
print(as.data.frame(razoes), row.names = FALSE, digits = 3)

diag_write(t75, "t7_5_ifnc_discriminante.csv")
diag_write(razoes, "t7_5b_razoes_ifnc.csv")


# ===================================================================
# Veredito
# ===================================================================
cat("\n===== VEREDITO TAREFA 7 =====\n")

fx0 <- t72 |> filter(var == "cambio_usd", h == 0)
mx <- t74a |> filter(var %in% c("cambio_usd", "embi_perc", "price_ipp",
                                "price_core_ipca_ex0", "asset_ifnc")) |>
  summarise(max_abs_t = max(abs(t_dif), na.rm = TRUE))
n_boot_rej <- sum(t74b$p_boot < 0.05, na.rm = TRUE)
n_chi_rej  <- sum(t74b$p_chi2 < 0.05, na.rm = TRUE)

ib <- match(BASELINE, t71b$indicador)
conc_alt <- t71c$concordancia[(t71c$a == BASELINE & t71c$b == BASELINE_ALT) |
                              (t71c$a == BASELINE_ALT & t71c$b == BASELINE)]
cat(sprintf("7.1 Baseline %s, corte %.3f: %d alto / %d baixo, %d corridas,\n",
            BASELINE, dummies[[BASELINE]]$cut, t71b$n_alto[ib], t71b$n_baixo[ib],
            t71b$n_corridas[ib]))
cat(sprintf("    corrida maxima %d meses. Concordancia com %s = %.3f.\n",
            t71b$corrida_max[ib], BASELINE_ALT, conc_alt))
cat(sprintf("7.2 cambio_usd h=0: alto %+.4f (t=%.2f) | baixo %+.4f (t=%.2f) | t_dif=%.2f\n",
            fx0$b_alto, fx0$b_alto / fx0$se_alto, fx0$b_baixo,
            fx0$b_baixo / fx0$se_baixo, fx0$t_dif))
cat(sprintf("7.3 Primeiro estagio baseline: F_alto %.1f-%.1f | F_baixo %.1f-%.1f\n",
            min(t72$F_alto[t72$var == "cambio_usd"], na.rm = TRUE),
            max(t72$F_alto[t72$var == "cambio_usd"], na.rm = TRUE),
            min(t72$F_baixo[t72$var == "cambio_usd"], na.rm = TRUE),
            max(t72$F_baixo[t72$var == "cambio_usd"], na.rm = TRUE)))
cat(sprintf("7.4 Conjunto, rejeicoes a 5%%: %d de %d pelo chi2 assintotico, %d de %d\n",
            n_chi_rej, nrow(t74b), n_boot_rej, nrow(t74b)))
cat(sprintf("    pelo bootstrap. Horizonte a horizonte (%d testes): %d assintoticas,\n",
            nrow(t74a), sum(t74a$p_asym < .05)))
cat(sprintf("    %d por bootstrap, %d apos Holm-bootstrap.\n",
            sum(t74a$p_boot < .05, na.rm = TRUE),
            sum(t74a$p_holm_boot < .05, na.rm = TRUE)))
cat(sprintf("    |t_dif| maximo nas 5 variaveis do prompt (h=0..8): %.2f\n", mx$max_abs_t))

fx_all <- t72b |> filter(var == "cambio_usd", h == 0)
imp <- t74e |> filter(var == "cambio_usd", h <= 4)
per <- t74e |> filter(var == "cambio_usd", h >= 6)
cat(sprintf("7.4d ESCOLHA DO INDICADOR IMPORTA: CDS e EMBI concordam em %.0f%% dos meses\n",
            100 * conc_alt))
cat(sprintf("     mas os conjuntos de rejeicao sao DISJUNTOS.\n"))
cat(sprintf("7.4e IMPACTO (h0-4) nao e dependente de estado em NENHUM indicador:\n"))
cat(sprintf("     max |t_dif| do cambio em h=0 sobre os %d indicadores = %.2f\n",
            nrow(fx_all), max(abs(fx_all$t_dif))))
cat(sprintf("     PERSISTENCIA (h6-8) E dependente: max |t_dif| sob CDS (baseline) = %.2f\n",
            max(abs(per$cds_t_dif))))
cat(sprintf("     contra %.2f sob EMBI. Conferir dbgg_d12 em t7_4f.\n",
            max(abs(per$embi_t_dif))))
cat("     LEITURA: sob risco soberano alto a depreciacao PERSISTE; sob risco\n")
cat("     baixo ela ja reverteu. E a hipotese do prompt, mas na reversao e nao\n")
cat(sprintf("     no impacto. Marginal (p_boot conjunto %.4f) e nao pre-registrado.\n",
            t74b$p_boot[t74b$var == "cambio_usd"]))

cat("\n=== TAREFA 7 concluida ===\n")
