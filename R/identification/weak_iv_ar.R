# ===================================================================
# INFERÊNCIA ROBUSTA A INSTRUMENTO FRACO (ANDERSON-RUBIN / FIELLER)
# PARA O PROXY-SVAR — Montiel Olea, Stock & Watson (2021, JoE)
#
# Tradução da metade do método que ainda não existia no repo. A metade
# do Wald pontual já era `compute_factor_space_wald` (impulse_responde.R);
# aqui entra a inversão do teste. Alvos, no código oficial dos autores
# (codigos_externos/codigo_olea/, github.com/jm4474/SVARIV):
#
#   functions/RForm/CovAhat_Sigmahat_Gamma.m  -> mosw_rform_cov
#   functions/RForm/Gmatrices.m + MARep.m     -> mosw_response_derivatives
#   functions/Inference/MSWfunction.m         -> mosw_ar_bounds
#
# O QUE MUDA EM RELAÇÃO AO ORIGINAL, E POR QUÊ. MOSW escrevem para um
# VAR em observáveis, onde a IRF identificada é
#
#     lambda_{j,h} = scale * (e_j' C_h Gamma) / (e_nvar' Gamma),
#
# com C_h os coeficientes MA do próprio VAR (C_0 = I). Num DFM estático a
# parte dinâmica é um VAR nos r fatores com uma equação de medida linear
# acoplada (Stock-Watson; é como Alessi-Kerssenfischer tratam o modelo em
# IdentExtInstr.m), e a mesma razão vira
#
#     lambda_{j,h} = scale * (e_j' C_h Gamma) / (d0' Gamma),
#     C_h = diag(sy) Lambda B_h K K',   d0 = C_0' e_mp,
#
# com B_h o bloco r x r superior-esquerdo da companion elevada a h. É a
# mesma razão de duas formas lineares em Gamma, logo a lógica de Fieller
# carrega inteira; a generalização é substituir o vetor e_nvar (que
# seleciona uma coordenada de Gamma) pelo vetor geral d0 (que combina
# todas), e o par (Gamma, e_j) dentro do Kronecker pelo par (gamma, a_j)
# com gamma = K K' Gamma e a_j = sy_j Lambda_j. Com Load = Inner = I as
# funções abaixo recaem exatamente no MOSW original — é isso que permite
# validá-las contra a aplicação do petróleo dos autores em
# script/validate_mosw_ar.R.
#
# LIMITAÇÃO DECLARADA: a covariância assintótica é a de (vec(A), Gamma).
# As matrizes da equação de medida (Lambda, K, M, sy) entram como
# conhecidas, isto é, a banda condiciona no espaço de fatores estimado.
# O bootstrap do projeto reestima o DFM por réplica e portanto mede outra
# coisa; a discussão está em
# relatorio/working-notes/2026-08-10_bandas_anderson_rubin.md.
# ===================================================================


#' Covariância assintótica de (vec(A), Gamma) — porta de CovAhat_Sigmahat_Gamma.m
#'
#' Estima W = Avar[(vec(Ahat)', Gammahat')'] pelo estimador de
#' Montiel Olea-Stock-Watson: HAC do momento
#' [vec(eta_t Xtil_t'); vec(eta_t z_t')] pré-multiplicado pela matriz de
#' seleção `Shat`, que propaga o erro de estimação do VAR para dentro de W.
#'
#' O bloco de vech(Sigma) do original é omitido: `WHat` (o objeto que
#' `MSWfunction.m` consome) o descarta logo em seguida, e as duas linhas de
#' `Shat` que sobrevivem têm bloco nulo ali.
#'
#' O bloco Gamma-Gamma resultante é algebricamente idêntico ao W de
#' `compute_factor_space_wald(controls = defasagens)`: a linha
#' `-kron(Q2 Q1^-1, I)` do `Shat` aplicada ao momento é
#' `eta_t * (z_t - Xtil_t' Q1^-1 Q2')`, ou seja, z residualizado nos
#' regressores do VAR. `script/ar_bands.R` mede essa igualdade em vez de
#' assumi-la.
#'
#' @param X Matriz T x (m + n*p) de regressores do VAR, com os m regressores
#'   exógenos (a constante) nas PRIMEIRAS colunas e as defasagens em seguida —
#'   a ordem de `RForm_VAR.m`, de que `Shat` depende.
#' @param Z Instrumento, vetor de comprimento T ou matriz T x k.
#' @param eta Matriz T x n de resíduos do VAR.
#' @param p Ordem do VAR, usada para separar as defasagens dos exógenos.
#' @param nw_lags Truncamento de Newey-West. O default 0 é Eicker-White e
#'   reproduz `NWlags = 0` da aplicação do petróleo; valores maiores aplicam o
#'   kernel de Bartlett de `NW_hac_STATA.m`.
#'
#' @return Lista com `W1` (n^2p x n^2p), `W12` (n^2p x nk), `W2` (nk x nk),
#'   `WHat` (a matriz completa) e `T_eff`.
mosw_rform_cov <- function(X, Z, eta, p, nw_lags = 0L) {
  X   <- as.matrix(X)
  Z   <- as.matrix(Z)
  eta <- as.matrix(eta)

  T_eff <- nrow(eta)
  n     <- ncol(eta)
  d_x   <- ncol(X)
  k     <- ncol(Z)
  m     <- d_x - n * p

  if (m < 0) stop("X tem menos colunas (", d_x, ") que n*p (", n * p, ")")
  if (nrow(X) != T_eff || nrow(Z) != T_eff) {
    stop("X, Z e eta precisam ter as mesmas T linhas")
  }

  # Momento por período: vec(eta_t [Xtil_t; z_t]'), empilhado coluna a coluna.
  # O bloco j (n colunas) é eta * Wmom[, j], que é exatamente kron(Wmom_t, eta_t).
  Wmom  <- cbind(X, Z)
  G_mom <- do.call(cbind, lapply(seq_len(ncol(Wmom)), function(j) Wmom[, j] * eta))
  V     <- sweep(G_mom, 2, colMeans(G_mom))

  S <- crossprod(V) / T_eff
  nw_lags <- as.integer(nw_lags)
  if (is.na(nw_lags) || nw_lags < 0L) stop("nw_lags deve ser inteiro não-negativo")
  for (l in seq_len(nw_lags)) {
    Gl <- crossprod(V[seq_len(T_eff - l), , drop = FALSE],
                    V[(1L + l):T_eff, , drop = FALSE]) / T_eff
    S  <- S + (1 - l / (nw_lags + 1)) * (Gl + t(Gl))
  }

  Q1    <- crossprod(X) / T_eff
  Q1inv <- solve(Q1)
  Q2    <- crossprod(Z, X) / T_eff
  sel_lag <- Q1inv[(m + 1):d_x, , drop = FALSE]   # [0 I_np] Q1^-1

  I_n  <- diag(n)
  Shat <- rbind(
    cbind(kronecker(sel_lag, I_n),          matrix(0, n * n * p, n * k)),
    cbind(-kronecker(Q2 %*% Q1inv, I_n),    diag(n * k))
  )

  WHat <- Shat %*% S %*% t(Shat)

  idx_a <- seq_len(n * n * p)
  idx_g <- n * n * p + seq_len(n * k)

  list(
    W1    = WHat[idx_a, idx_a, drop = FALSE],
    W12   = WHat[idx_a, idx_g, drop = FALSE],
    W2    = WHat[idx_g, idx_g, drop = FALSE],
    WHat  = WHat,
    T_eff = T_eff
  )
}


#' Matrizes de resposta C_h e a derivada do numerador em vec(A)
#'
#' Devolve, para h = 0..`h`, as matrizes `C_h = Load B_h Inner` e as linhas
#' `d1_{j,h} = scale * (gamma' kron a_j') G_h` que a quadrática de Anderson-Rubin
#' consome, com `B_h` o bloco superior-esquerdo da companion elevada a h,
#' `gamma = Inner Gamma` e `a_j` a j-ésima linha de `Load`.
#'
#' `G_h = d vec(B_h) / d vec(A)'` nunca é materializada. Pela fórmula de
#' Lütkepohl que `Gmatrices.m` implementa,
#' `G_h = sum_{m=0}^{h-1} P_{h-1-m} kron B_m` com `P_j = (A_c^j J')'`, e o produto
#' que se precisa colapsa por `(x' kron y')(P kron Q) = (x'P) kron (y'Q)`:
#'
#'   d1_{j,h} = scale * sum_{m=0}^{h-1} (gamma' P_{h-1-m}) kron (a_j' B_m).
#'
#' Isso evita o array `AJaux` do MATLAB, que aqui teria ~265 MB.
#'
#' @param AL Coeficientes do VAR, n_state x (n_state * p).
#' @param p Ordem do VAR.
#' @param h Horizonte máximo (o objeto devolvido tem h+1 páginas).
#' @param Load Matriz n_out x n_state da equação de medida. Identidade num VAR
#'   em observáveis; `diag(sy) Lambda` no DFM.
#' @param Inner Matriz n_state x n_inn que leva Gamma às inovações do estado.
#'   Identidade num VAR em observáveis; `K K'` no DFM.
#' @param Gamma Vetor de comprimento n_inn com o momento E[z_t eta_t].
#'
#' @return Lista com `C` e `Ccum` (arrays n_out x n_inn x (h+1)) e `D1`, `D1cum`
#'   (arrays n_out x (n_state^2 * p) x (h+1)). A escala do choque não entra aqui;
#'   `mosw_ar_bounds` a aplica aos dois de uma vez.
mosw_response_derivatives <- function(AL, p, h, Load, Inner, Gamma) {
  AL    <- as.matrix(AL)
  Load  <- as.matrix(Load)
  Inner <- as.matrix(Inner)

  n_st  <- nrow(AL)
  n_out <- nrow(Load)
  n_inn <- ncol(Inner)
  n_a   <- n_st * n_st * p

  if (ncol(AL) != n_st * p) stop("AL deve ser n_state x (n_state * p)")
  if (ncol(Load) != n_st || nrow(Inner) != n_st) {
    stop("Load precisa ser n_out x n_state e Inner, n_state x n_inn")
  }
  if (length(Gamma) != n_inn) stop("Gamma deve ter comprimento ", n_inn)

  companion <- if (p == 1) AL else {
    rbind(AL, cbind(diag(n_st * (p - 1)), matrix(0, n_st * (p - 1), n_st)))
  }

  # B[[m+1]] = bloco r x r de A_c^m; P[[j+1]] = (A_c^j J')', r x rp.
  Apow <- diag(n_st * p)
  B <- vector("list", h + 1)
  P <- vector("list", h + 1)
  for (i in seq_len(h + 1)) {
    B[[i]] <- Apow[seq_len(n_st), seq_len(n_st), drop = FALSE]
    P[[i]] <- t(Apow[, seq_len(n_st), drop = FALSE])
    Apow   <- Apow %*% companion
  }

  gamma_st <- drop(Inner %*% Gamma)
  gP       <- lapply(P, function(Pj) drop(crossprod(gamma_st, Pj)))  # 1 x rp
  LB       <- lapply(B, function(Bm) Load %*% Bm)                    # n_out x r

  C  <- array(0, dim = c(n_out, n_inn, h + 1))
  D1 <- array(0, dim = c(n_out, n_a,   h + 1))
  for (i in seq_len(h + 1)) {
    C[, , i] <- LB[[i]] %*% Inner
    # G_0 = 0: no horizonte de impacto B_0 = I não depende de A.
    for (m in seq_len(i - 1)) {
      D1[, , i] <- D1[, , i] + kronecker(matrix(gP[[i - m]], nrow = 1), LB[[m]])
    }
  }

  list(C     = C,
       Ccum  = aperm(apply(C,  c(1, 2), cumsum), c(2, 3, 1)),
       D1    = D1,
       D1cum = aperm(apply(D1, c(1, 2), cumsum), c(2, 3, 1)))
}


#' Conjunto de confiança Anderson-Rubin para a IRF, por inversão de teste
#'
#' Porta generalizada das seções 4-7 de `MSWfunction.m`. Para cada par
#' (variável j, horizonte h) resolve em lambda a desigualdade quadrática
#'
#'   T (num - lambda * den)^2 <= critval * sigma^2(lambda),
#'
#' com `num = scale * e_j' C_h Gamma`, `den = d0' Gamma` e sigma^2 a variância
#' assintótica da forma linear, e classifica o resultado nos quatro casos de
#' MOSW: 1 = intervalo limitado, 2 = união de duas semirretas (`lo` é o topo da
#' primeira, abuso de notação dos autores), 3 = conjunto vazio, 4 = reta toda.
#' Devolve também os limites de delta-method da seção 6, que usam a mesma
#' derivada e servem de termo de comparação assintótico.
#'
#' O coeficiente de lambda^2 é `T*den^2 - critval*d0'W2 d0`, logo é positivo se
#' e somente se a Wald na direção do denominador (o xi_mp do projeto) excede o
#' valor crítico — que é a condição de conjunto limitado que
#' `output/instrument/mosw_strength_grid.csv` já reporta.
#'
#' @param C Array n_out x n_inn x (h+1) de `mosw_response_derivatives`.
#' @param D1 Array n_out x n_a x (h+1) de `mosw_response_derivatives`.
#' @param Gamma Vetor de comprimento n_inn.
#' @param cov Lista de `mosw_rform_cov` (usa `W1`, `W12`, `W2`, `WHat`, `T_eff`).
#' @param nvar Índice da variável de normalização em `C`.
#' @param scale Valor da resposta normalizada de `nvar` no impacto.
#' @param confidence Nível de confiança (ex.: 0.90).
#'
#' @return Lista de matrizes n_out x (h+1): `point`, `ahat`, `bhat`, `chat`,
#'   `Delta`, `case`, `lo`, `hi`, `dm_lo`, `dm_hi`, `dm_se`, mais `critval` e
#'   `den`.
mosw_ar_bounds <- function(C, D1, Gamma, cov, nvar, scale, confidence) {
  n_out <- dim(C)[1]
  n_inn <- dim(C)[2]
  n_h   <- dim(C)[3]
  n_a   <- dim(D1)[2]

  critval <- qnorm(1 - (1 - confidence) / 2)^2
  T_eff   <- cov$T_eff

  d0  <- C[nvar, , 1]
  den <- sum(d0 * Gamma)

  # Empilha as n_out*(h+1) células como linhas para fazer as formas
  # quadráticas de uma vez.
  Dg  <- scale * matrix(aperm(C,  c(1, 3, 2)), nrow = n_out * n_h, ncol = n_inn)
  Da  <- scale * matrix(aperm(D1, c(1, 3, 2)), nrow = n_out * n_h, ncol = n_a)

  num <- drop(Dg %*% Gamma)

  W2d0  <- drop(cov$W2  %*% d0)
  W12d0 <- drop(cov$W12 %*% d0)
  w_den <- sum(d0 * W2d0)

  q_aa <- rowSums((Da %*% cov$W1)  * Da)
  q_ag <- rowSums((Da %*% cov$W12) * Dg)
  q_gg <- rowSums((Dg %*% cov$W2)  * Dg)

  ahat <- rep(T_eff * den^2 - critval * w_den, length(num))
  bhat <- -2 * T_eff * num * den +
    2 * critval * drop(Da %*% W12d0) +
    2 * critval * drop(Dg %*% W2d0)
  chat <- T_eff * num^2 - critval * (q_aa + 2 * q_ag + q_gg)

  Delta <- bhat^2 - 4 * ahat * chat
  root  <- sqrt(pmax(Delta, 0))

  case <- ifelse(ahat > 0 & Delta > 0, 1L,
          ifelse(ahat < 0 & Delta > 0, 2L,
          ifelse(ahat > 0 & Delta < 0, 3L, 4L)))

  lo <- hi <- rep(NA_real_, length(num))
  i1 <- case == 1L
  lo[i1] <- (-bhat[i1] - root[i1]) / (2 * ahat[i1])
  hi[i1] <- (-bhat[i1] + root[i1]) / (2 * ahat[i1])
  i2 <- case == 2L
  lo[i2] <- (-bhat[i2] + root[i2]) / (2 * ahat[i2])
  hi[i2] <- (-bhat[i2] - root[i2]) / (2 * ahat[i2])
  lo[case == 4L] <- -Inf
  hi[case == 4L] <-  Inf

  point <- num / den

  # Delta-method (MSWfunction.m seção 6): d = [d1, dGamma - lambda*d0].
  Dd     <- cbind(Da, Dg - outer(point, d0))
  dm_var <- rowSums((Dd %*% cov$WHat) * Dd)
  dm_se  <- sqrt(pmax(dm_var, 0)) / (sqrt(T_eff) * abs(den))
  dm_lo  <- point - sqrt(critval) * dm_se
  dm_hi  <- point + sqrt(critval) * dm_se

  as_mat <- function(v) matrix(v, nrow = n_out, ncol = n_h)
  out <- list(point = as_mat(point), ahat = as_mat(ahat), bhat = as_mat(bhat),
              chat = as_mat(chat), Delta = as_mat(Delta), case = as_mat(case),
              lo = as_mat(lo), hi = as_mat(hi), dm_lo = as_mat(dm_lo),
              dm_hi = as_mat(dm_hi), dm_se = as_mat(dm_se))

  # A célula (nvar, h = 0) não testa nada: lambda ali é a normalização, fixa em
  # `scale`. Algebricamente d1 = 0 e dGamma = scale*d0, o que dá chat = scale^2*ahat
  # e Delta = 0 exatamente — o conjunto AR é o singleton {scale}. A classificação
  # de MOSW cai então no ramo residual (caso 4, "reta toda"), e é por isso que
  # `MSWfunction.m:156-158` sobrescreve os limites. Aqui o rótulo também é
  # corrigido para 1 (limitado), que é o que o conjunto de fato é; a validação
  # contra o fixture oficial exclui esta única célula da comparação de casedummy.
  out$lo[nvar, 1]   <- scale
  out$hi[nvar, 1]   <- scale
  out$case[nvar, 1] <- 1L

  out$critval <- critval
  out$den     <- den
  out
}
