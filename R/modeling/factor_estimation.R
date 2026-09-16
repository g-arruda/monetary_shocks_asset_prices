# Carregar bibliotecas necessárias

#' Calculate Bai and Ng (2002) Information Criteria for Factor Model Selection
#'
#' @description
#' Implements the Bai and Ng (2002) information criteria for determining the optimal
#' number of factors in approximate factor models. The function computes three different
#' penalty versions (IC1, IC2, and IC3) of the criteria.
#'
#' @param X A numeric matrix of dimensions T × N, where T is the number of time periods
#'          and N is the number of variables/series
#' @param max_r An integer specifying the maximum number of factors to consider.
#'              Default is 15
#' @param standardize Logical indicating whether to standardize the data before
#'                   computing the criteria. Default is TRUE
#'
#' @return A list containing three components:
#' \itemize{
#'   \item r_hat: A list with the optimal number of factors according to each criterion
#'                (IC1, IC2, and IC3)
#'   \item criteria: A list containing the values of each information criterion for
#'                  r = 1 to max_r
#'   \item pca: The prcomp object from the principal components analysis
#' }
#'
#' @details
#' The function implements the three panel information criteria proposed by Bai and Ng
#' (2002) for determining the number of factors in approximate factor models. The
#' criteria differ in their penalty terms:
#' \itemize{
#'   \item IC1 uses penalty term r * (N+T)/(NT) * log((NT)/(N+T))
#'   \item IC2 uses penalty term r * (N+T)/(NT) * log(min(N,T))
#'   \item IC3 uses penalty term r * log(min(N,T))/min(N,T)
#' }
#'
#' @references
#' Bai, J., & Ng, S. (2002). Determining the Number of Factors in Approximate Factor
#' Models. Econometrica, 70(1), 191-221.
#'
#' @examples
#' # Generate random data
#' set.seed(123)
#' T <- 100 # time periods
#' N <- 20 # variables
#' X <- matrix(rnorm(T * N), nrow = T)
#'
#' # Calculate Bai-Ng criteria
#' results <- bai_ng_criteria(X, max_r = 10)
#'
#' # View optimal number of factors for each criterion
#' print(results$r_hat)
#'
#' @export
bai_ng_criteria <- function(X, max_r = 15, standardize = TRUE, apply_bll = FALSE) {
  X <- as.matrix(X)
  
  if (apply_bll) {
    # Padronização BLL (calcula a 1ª diferença padronizada)
    y <- diff(X)
    sy <- apply(y, 2, sd)
    y_centered <- sweep(y, 2, colMeans(y), "-")
    X_std <- sweep(y_centered, 2, sy, "/")
  } else if (standardize) {
    X_std <- scale(X, center = TRUE, scale = TRUE)
  } else {
    X_std <- X
  }

  T <- nrow(X_std)
  N <- ncol(X_std)

  pca <- prcomp(X_std, scale. = FALSE, center = FALSE)

  ic1 <- ic2 <- ic3 <- numeric(max_r)

  for (r in 1:max_r) {
    # Extract first r factors and loadings
    F_hat <- pca$x[, 1:r]
    Lambda_hat <- pca$rotation[, 1:r]

    # Compute residuals from r-factor approximation
    resid <- X_std - F_hat %*% t(Lambda_hat)
    V_r <- sum(resid^2) / (N * T)

    # Panel dimension adjustment term
    e <- (N + T) / (N * T)

    # Penalty terms for each IC
    p1 <- r * e * log(1 / e)
    p2 <- r * e * log(min(N, T))
    p3 <- r * log(min(N, T)) / min(N, T)

    ic1[r] <- log(V_r) + p1
    ic2[r] <- log(V_r) + p2
    ic3[r] <- log(V_r) + p3
  }

  return(list(
    r_hat = list(
      IC1 = which.min(ic1),
      IC2 = which.min(ic2),
      IC3 = which.min(ic3)
    ),
    criteria = list(IC1 = ic1, IC2 = ic2, IC3 = ic3),
    pca = pca
  ))
}





#' Test for Dynamic Factors Using Amengual and Watson (2007) Method
#'
#' @description
#' Implements the Amengual and Watson (2007) method for determining the number of
#' dynamic factors in a dynamic factor model. The procedure first estimates static
#' factors via PCA, then applies VAR filtering, and finally uses Bai and Ng (2002)
#' criteria on the residuals to determine the number of dynamic factors.
#'
#' @param X A numeric matrix of dimensions T × N, where T is the number of time periods
#'          and N is the number of variables/series
#' @param r An integer specifying the number of static factors to extract in the first
#'          step
#' @param p An integer specifying the number of lags to include in the VAR filtering.
#'          Default is 4
#' @param max_q An integer specifying the maximum number of dynamic factors to consider.
#'              If NULL (default), it is set equal to r
#' @param standardize_resid Logical: standardize the VAR residuals column by
#'   column before the second-stage Bai-Ng, as Stock-Watson's
#'   `factor_estimation_ls.m` does. `FALSE` (default) keeps every recorded
#'   `q_hat`; the per-column rescaling can move the argmin in another panel
#'   (notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md §2)
#'
#' @return A list containing two components:
#' \itemize{
#'   \item aw: A numeric vector containing the Amengual-Watson test statistics (based
#'             on IC2 criterion) for q = 1 to max_q
#'   \item q_hat: An integer indicating the estimated number of dynamic factors based
#'                on the IC2 criterion
#' }
#'
#' @details
#' The function implements the following steps:
#' \itemize{
#'   \item Extracts r static factors using principal components
#'   \item Applies VAR(p) filtering to remove dynamic dependence
#'   \item Uses Bai-Ng IC2 criterion on the residuals to determine q
#' }
#'
#' The procedure allows for the number of dynamic factors (q) to be smaller than
#' the number of static factors (r), which is often the case in empirical applications.
#'
#' @references
#' Amengual, D., & Watson, M. W. (2007). Consistent Estimation of the Number of
#' Dynamic Factors in a Large N and T Panel. Journal of Business & Economic
#' Statistics, 25(1), 91-96.
#'
#' @examples
#' # Generate random data
#' set.seed(123)
#' T <- 100 # time periods
#' N <- 20 # variables
#' X <- matrix(rnorm(T * N), nrow = T)
#'
#' # Test for dynamic factors with 3 static factors
#' results <- amengual_watson(X, r = 3, p = 2)
#'
#' # View estimated number of dynamic factors
#' print(results$q_hat)
#'
#' @export
amengual_watson <- function(X, r, p = 4, max_q = NULL, scale = TRUE, apply_bll = FALSE,
                            standardize_resid = FALSE) {
  X <- as.matrix(X)

  if (apply_bll) {
    y <- diff(X)
    sy <- apply(y, 2, sd)
    y_centered <- sweep(y, 2, colMeans(y), "-")
    X_std <- sweep(y_centered, 2, sy, "/")
  } else if (scale) {
    X_std <- scale(X, center = TRUE, scale = TRUE)
  } else {
    X_std <- X
  }

  if (is.null(max_q)) max_q <- r

  pca_X <- prcomp(X_std, scale. = FALSE, center = FALSE)
  F_hat <- pca_X$x[, 1:r, drop = FALSE]

  T <- nrow(X_std)
  lagged_factors <- stats::embed(F_hat, p + 1)
  Z <- cbind(1, lagged_factors[, -(1:r), drop = FALSE])

  resid_mat <- matrix(NA, T - p, ncol(X_std))

  for (i in 1:ncol(X_std)) {
    y <- X_std[(p + 1):T, i]
    z <- Z[1:length(y), , drop = FALSE]

    b <- solve(crossprod(z), crossprod(z, y))
    e <- y - z %*% b
    resid_mat[, i] <- e
  }

  bn <- bai_ng_criteria(resid_mat, max_r = max_q, standardize = standardize_resid)
  q_hat <- bn$r_hat$IC2

  list(
    aw = bn$criteria$IC2,
    q_hat = q_hat
  )
}



#' Extract static factors under BLL standardization
#'
#' Standardizes the level panel by the standard deviation of its first
#' differences (Barigozzi, Lippi & Luciani 2016), removes a linear trend
#' series by series, and takes the leading `r` eigenvectors of the covariance
#' of the standardized differences via SVD. SVD rather than `eigen()` and the
#' sign normalization below make the decomposition bit-reproducible.
#'
#' @param data Numeric matrix of the level panel (T x N).
#' @param r Number of static factors to extract.
#' @param standardized Retained for signature compatibility; BLL
#'   standardization is unconditional.
#' @param seed Optional integer seed.
#'
#' @return List with factors, loadings, sy, Z, eigenvalues, yy,
#'   detrended_data and diagnostics.
estimate_static_factors <- function(data, r, standardized = TRUE, seed = NULL) {
  n_obs <- nrow(data)

  # Fixar seed se fornecido para reprodutibilidade absoluta
  if (!is.null(seed)) {
    set.seed(seed)
  }
  
  # ===================================================================
  # PADRONIZAÇÃO BLL (Barigozzi, Lippi, Luciani 2016)
  # ===================================================================
  
  # 1. Calcular primeira diferença para obter desvio padrão
  y <- diff(data)  # Primeira diferença: Y(t) - Y(t-1)
  sy <- apply(y, 2, sd)  # Desvio padrão das primeiras diferenças
  
  # 2. Padronizar as primeiras diferenças (para cálculo dos autovalores)
  y_centered <- sweep(y, 2, colMeans(y), "-")  # Centrar
  yy <- sweep(y_centered, 2, sy, "/")  # Padronizar: (y - mean(y))/sd(y)
  
  # 3. Detrending dos dados em nível
  # Construir matriz de regressores: [1, t] para remoção de tendência linear
  regX <- cbind(1, 1:n_obs)  # Constante e tendência linear
  
  # Remover tendência de cada série individualmente
  beta <- solve(crossprod(regX)) %*% crossprod(regX, data)  # Coeficientes da regressão
  X <- data - regX %*% beta  # Dados destrendizados
  
  # 4. Padronização BLL final: dados destrendizados / sd das diferenças
  Z <- sweep(X, 2, sy, "/")  # Padronização BLL: X / sy
  
  # ===================================================================
  # EXTRAÇÃO DOS FATORES ESTÁTICOS USANDO SVD NA MATRIZ DE COVARIÂNCIA
  # ===================================================================
  
  # 5. Usar Decomposição SVD na matriz de covariância para garantir determinismo
  cov_yy <- cov(yy)

  # Use SVD em vez de eigen para maior estabilidade e reprodutibilidade
  svd_result <- svd(cov_yy)

  # Os autovetores são a matriz U da decomposição SVD
  eigenvals <- svd_result$d[1:r]
  lambda <- svd_result$u[, 1:r, drop = FALSE]

  # ...diagnóstico removido...

  # CRÍTICO: Normalização determinística robusta (inspirada em estimate_dynamic_factors)
  # Garante que os vetores tenham sempre a mesma orientação.
  for (i in 1:ncol(lambda)) {
    # Encontra o índice do elemento com o maior valor absoluto no vetor
    max_abs_idx <- which.max(abs(lambda[, i]))
    
    # Se esse elemento específico for negativo, inverte o sinal do VETOR INTEIRO
    if (lambda[max_abs_idx, i] < 0) {
      lambda[, i] <- -lambda[, i]
    }
  }
  
  # 7. Calcular fatores estáticos: F = Z * lambda
  F <- Z %*% lambda
  
  return(list(
    factors = F,                    # Fatores estáticos F = Z * lambda
    loadings = lambda,              # Loadings (autovetores da SVD)
    sy = sy,                        # Desvios padrão das diferenças
    Z = Z,                          # Dados padronizados BLL
    eigenvalues = eigenvals,        # Autovalores correspondentes aos valores singulares
    yy = yy,                        # Diferenças padronizadas (para diagnóstico)
    detrended_data = X,             # Dados destrendizados (para diagnóstico)
    # Diagnósticos adicionais
    diagnostics = list(
      method = "SVD_covariance",
      eigenvalues = eigenvals,
      selected_indices = 1:r  # SVD já ordena automaticamente
    )
  ))
}



#' Invert a matrix, falling back to the pseudo-inverse when ill-conditioned
#'
#' Replaces the `det(M) < 1e-12` guard the Kilian correction used at four
#' sites. A determinant does not measure conditioning: for the Lyapunov matrix
#' it is the product of hundreds of factors `1 - lambda_i lambda_j`, all below
#' one, so it underflows toward 0 on a perfectly well-conditioned matrix.
#' Measured on 2026-08-17: the DFM (5,5) Lyapunov has `det` 6,3e-19 against
#' `rcond` 1,7e-06 — the `ginv` branch was taken on a matrix that inverts fine.
#'
#' `rcond()` is the test that asks the right question, and it has to be a
#' *test*, not a `tryCatch` around `solve()`: LAPACK only errors on an exact
#' zero pivot, so on the small VAR's Lyapunov matrix (`rcond` 7,3e-17) `solve()`
#' returns silently and the garbage inverse propagates into NaN bands.
#'
#' The threshold `.Machine$double.eps^(2/3)` is ~3,7e-11, where `solve()` has
#' already lost about eleven of sixteen digits. Every matrix this function sees
#' in production sits orders of magnitude on one side or the other of it.
#'
#' @param M Square matrix to invert; the real part is taken.
#' @param label Name used in the warning when the fallback is reached.
#'
#' @return The inverse, or the Moore-Penrose pseudo-inverse when `M` is too
#'   ill-conditioned to invert.
solve_or_pseudo <- function(M, label) {
  M <- Re(M)
  if (rcond(M) >= .Machine$double.eps^(2 / 3)) {
    return(solve(M))
  }
  warning("Matriz mal condicionada em ", label, "; usando pseudo-inversa")
  MASS::ginv(M)
}


#' Kilian (1998) small-sample bias correction of the companion matrix
#'
#' Pope's (1990) analytic bias approximation, shrunk toward stationarity by the
#' `delta` loop when the corrected companion would otherwise have a root on or
#' outside the unit circle. Faithful to Lutz Kilian's original MATLAB code
#' (Pope 1990, JTSA; Kilian 1997), including the reuse of the Lyapunov solution.
#'
#' @param A Companion matrix of the factor VAR.
#' @param SIGMA Residual covariance matrix.
#' @param t Number of observations before lag truncation.
#' @param q Number of dynamic factors (VAR dimension).
#' @param p Factor-VAR lag order.
#'
#' @return List with the bias-corrected companion matrix and the shrinkage
#'   actually applied.
kilian_correction <- function(A, SIGMA, t, q, p) {

  # Seguindo exatamente o código MATLAB
  T <- t - p
  
  # Calcular SIGMAY usando a equação de Lyapunov
  # vecSIGMAY = inv(eye((q*p)^2) - kron(A,A)) * vec(SIGMA)
  I_kron <- diag((q * p)^2)
  A_kron_A <- kronecker(A, A)
  lyapunov_matrix <- I_kron - A_kron_A
  
  # A matriz é (q*p)^2 x (q*p)^2 — 400x400 na produção (5,5) com p=4. O teste
  # antigo por det() dava 6,29e-19 contra um rcond de 1,7e-06, então o ramo da
  # pseudo-inversa era tomado em toda réplica de bootstrap sem necessidade.
  #
  # Aqui NÃO cabe pseudo-inversa. SIGMAY é a covariância incondicional do
  # estado da companion; se a equação de Lyapunov é singular, ela não está
  # definida, e a `ginv` devolve um objeto que não é essa covariância. A fórmula
  # de viés de Pope alimentada com ele produz um `Abias` enorme e uma companion
  # corrigida explosiva — medido no VAR pequeno de `cds_5y` (rcond 7,3e-17),
  # onde as 800 réplicas falharam e as bandas saíram NA. Abortar é o
  # comportamento certo: `var_proxy.R:156` já cai para coeficientes não
  # corrigidos, que é a resposta honesta quando a correção não é computável.
  lyap_rcond <- rcond(Re(lyapunov_matrix))
  if (lyap_rcond < .Machine$double.eps^(2 / 3)) {
    stop("Equacao de Lyapunov numericamente singular (rcond = ",
         format(lyap_rcond, digits = 3), "): SIGMAY nao esta definida e a ",
         "correcao de Kilian fica indefinida.")
  }
  lyapunov_inv <- solve(Re(lyapunov_matrix))
  
  # vec(SIGMA) - vetorizar SIGMA por colunas (como no MATLAB)
  SIGMA_expanded <- matrix(0, q * p, q * p)
  SIGMA_expanded[1:nrow(SIGMA), 1:ncol(SIGMA)] <- SIGMA
  vec_SIGMA <- as.vector(SIGMA_expanded)
  vecSIGMAY <- lyapunov_inv %*% vec_SIGMA
  SIGMAY <- matrix(vecSIGMAY, nrow = q * p, ncol = q * p)
  
  # Matriz identidade e transposta
  I <- diag(q * p)
  B <- t(A)  # B = A' no MATLAB
  
  # Calcular autovalores de A
  peigen <- eigen(A)$values
  
  # Calcular sumeig seguindo o loop do MATLAB
  sumeig <- matrix(0, q * p, q * p)
  # ...variável não utilizada removida...
  
  for (h in 1:(q * p)) {
    # sumeig = sumeig + (peigen(h) * inv(I - peigen(h) * B))
    I_minus_peigen_B <- I - peigen[h] * B
    # solve() on complex matrix (fiel ao Matlab); skip if singular
    inv_mat <- tryCatch(solve(I_minus_peigen_B), error = function(e) NULL)
    if (!is.null(inv_mat)) {
      sumeig <- sumeig + peigen[h] * inv_mat
    }
  }
  # Resultado teórico é real (pares conjugados se cancelam); limpar ruído numérico
  sumeig <- Re(sumeig)
  
  # Calcular bias seguindo exatamente o MATLAB
  # bias = SIGMA * (inv(I-B) + B*inv(I-B^2) + sumeig) * inv(SIGMAY)
  
  I_minus_B <- I - B
  I_minus_B2 <- I - B %*% B
  
  # ...diagnóstico removido...
  
  # Verificar se as matrizes são invertíveis. Mesmo motivo do bloco de Lyapunov
  # acima: o determinante de uma q*p x q*p não mede condicionamento. Estas três
  # tomam o ramo do solve na produção (5,5) — dets 2,0e-05, 9,2e-04 e 2,9e+24 —
  # mas o teste falharia do mesmo jeito para q*p maior.
  inv_I_minus_B <- solve_or_pseudo(I_minus_B, "(I-B)")
  inv_I_minus_B2 <- solve_or_pseudo(I_minus_B2, "(I-B²)")
  inv_SIGMAY <- solve_or_pseudo(SIGMAY, "SIGMAY")
  
  # Calcular bias
  bias_term <- inv_I_minus_B + B %*% inv_I_minus_B2 + sumeig
  bias <- Re(SIGMA_expanded %*% bias_term %*% inv_SIGMAY)
  
  # ...diagnóstico removido...
  
  # Abias = -bias/T
  Abias <- -bias / T
  
  # Loop de correção seguindo exatamente o MATLAB
  bcstab <- 9  # Valor arbitrário > 1
  delta <- 1   # Fator de ajuste
  
  # ...diagnóstico removido...
  iter <- 0
  max_iter <- 100  # Proteção contra loop infinito
  
  while (bcstab >= 1 && iter < max_iter) {
    iter <- iter + 1
    
    # bcA = A - delta * Abias
    bcA <- A - delta * Abias
    
    # Verificar estabilidade
    bcmod <- abs(eigen(bcA)$values)

    if (any(bcmod >= 1)) {
      bcstab <- 1
    } else {
      bcstab <- 0
    }
    
    # delta = delta - 0.01 (exatamente como no MATLAB)
    delta <- delta - 0.01
    
    if (delta <= 0) {
      bcstab <- 0
      # ...diagnóstico removido...
    }
    
    if (iter %% 20 == 0) {
      # ...diagnóstico removido...
    }
  }
  
  if (iter >= max_iter) {
    warning("Kilian correction did not converge within maximum iterations")
  }
  
  return(bcA)
}



#' Common volatility scale of the Lenza-Primiceri (2022) COVID treatment
#'
#' Builds `s_t` of equation (1) in Lenza & Primiceri (2022, JAE): one before
#' `covid_start`, `s0`, `s1` and `s2` in its first three months, and
#' `1 + (s2 - 1) * rho^(j - 2)` from then on, `j` being calendar months since
#' `covid_start`. It is the rule of `invweights` in the authors'
#' `logMLVAR_formin_covid.m:35-40`. `theta` carries no bounds: the ones in
#' `setpriors_covid.m` belong to the authors' Bayesian optimizer, and choosing
#' `theta` is the author's decision.
#'
#' @param dates Date vector, one per residual row of the factor VAR.
#' @param covid_start First month of abnormal volatility (Date).
#' @param theta Named numeric vector with `s0`, `s1`, `s2` and `rho`.
#'
#' @return Numeric vector `s_t` aligned with `dates`.
#'
#' @examples
#' # Neutral theta: s_t = 1 at every date, whatever covid_start and rho.
#' s <- covid_volatility_path(dates, covid_start,
#'                            c(s0 = 1, s1 = 1, s2 = 1, rho = 0))
covid_volatility_path <- function(dates, covid_start, theta) {
  j <- 12L * (lubridate::year(dates) - lubridate::year(covid_start)) +
    lubridate::month(dates) - lubridate::month(covid_start)

  s <- rep(1, length(dates))
  s[j == 0] <- theta[["s0"]]
  s[j == 1] <- theta[["s1"]]
  s[j >= 2] <- 1 + (theta[["s2"]] - 1) * theta[["rho"]]^(j[j >= 2] - 2)
  s
}


#' Factor VAR by least squares, optionally under the COVID volatility scale
#'
#' With `s = NULL` this is plain OLS, the direct equivalent of `DFMest_BLL.m`
#' lines 29-50 and what the point estimate uses; `estimate_corrected_var()` is
#' only for the bootstrap DGP.
#'
#' With `s`, the VAR is `F_t = c + A(L) F_{t-1} + s_t eps_t`,
#' `eps_t ~ N(0, Sigma)`, the maximum-likelihood version of Lenza & Primiceri
#' (2022, JAE, Appendix B) conditional on `s`: coefficients by (B2), the ML
#' covariance by (B4) and the concentrated log-likelihood by (B5), constants
#' included (the paper writes it up to proportionality). Nothing here chooses
#' or optimizes `s`.
#'
#' @param data Numeric matrix of factors (T x K).
#' @param p Lag order.
#' @param s Optional volatility scale, one positive value per residual row
#'   (length T - p), from `covid_volatility_path()`. NULL is plain OLS.
#'
#' @return List with coefficients, residuals, companion matrix and the residual
#'   covariance matrix. With `s`, `residuals` stay `u_t = y_t - B'x_t`, and the
#'   list adds `residuals_standardized` (`u_t / s_t`), `sigma_mle` (B4) and
#'   `loglik` (B5); `covariance_matrix` is then computed on `u_t / s_t` with
#'   the same degrees-of-freedom divisor as the OLS branch.
estimate_var_ols <- function(data, p, s = NULL) {
  T <- nrow(data)
  K <- ncol(data)

  RHS <- matrix(NA, T - p, K * p + 1)
  for (i in 1:p) {
    start_col <- (i - 1) * K + 1
    end_col <- i * K
    RHS[, start_col:end_col] <- data[(p + 1 - i):(T - i), ]
  }
  RHS[, K * p + 1] <- 1

  LHS <- data[(p + 1):T, ]

  if (is.null(s)) {
    bet <- solve(crossprod(RHS)) %*% crossprod(RHS, LHS)
  } else {
    # (B2): least squares on every row divided by s_t, constant column included
    bet <- solve(crossprod(RHS / s)) %*% crossprod(RHS / s, LHS / s)
  }
  u <- LHS - RHS %*% bet
  u <- Re(as.matrix(u))

  coeffcompanion <- rbind(
    t(bet[1:(p * K), ]),
    cbind(diag((p - 1) * K), matrix(0, (p - 1) * K, K))
  )

  if (is.null(s)) {
    SIGMA <- crossprod(u) / (T - p - p * K - 1)

    return(list(
      coefficients = bet,
      residuals = u,
      companion = coeffcompanion,
      covariance_matrix = SIGMA
    ))
  }

  # The constant covariance Sigma belongs to u_t / s_t. (B4) and (B5) divide by
  # the T - p effective rows, the ML convention.
  e <- u / s
  n_eff <- T - p
  sigma_mle <- crossprod(e) / n_eff
  loglik <- -n_eff * K / 2 * (1 + log(2 * pi)) - K * sum(log(s)) -
    n_eff / 2 * as.numeric(determinant(sigma_mle, logarithm = TRUE)$modulus)

  list(
    coefficients = bet,
    residuals = u,
    residuals_standardized = e,
    companion = coeffcompanion,
    covariance_matrix = crossprod(e) / (T - p - p * K - 1),
    sigma_mle = sigma_mle,
    loglik = loglik
  )
}


#' Maximum-likelihood estimate of the Lenza-Primiceri COVID volatility scale
#'
#' Maximizes the concentrated log-likelihood (B5) of Lenza & Primiceri (2022,
#' JAE, Appendix B) over `theta = (s0, s1, s2, rho)` by L-BFGS-B inside the box
#' `[lower, upper]`. The floor is not cosmetic: with any scale free to approach
#' zero, the WLS fits that month exactly and (B5) grows as `-n log s`, so the
#' unrestricted maximum does not exist. The starting values are the authors'
#' rule (`bvarGLP_covid.m:60-68`) on the factors: the cross-factor mean
#' absolute change into `covid_start` and the two months after it, over the
#' same mean before `covid_start`, and `rho = 0.8`, projected on the box.
#'
#' @param factors Numeric matrix of static factors (T x K).
#' @param p Lag order of the factor VAR.
#' @param residual_dates Date vector of the T - p residual months.
#' @param covid_start First month of abnormal volatility (Date), one of
#'   `residual_dates`.
#' @param lower,upper Named vectors (`s0`, `s1`, `s2`, `rho`) bounding theta.
#'
#' @return List with `theta`, the maximized `loglik`, the `start` vector,
#'   `optim`'s `convergence` code and `message`, and the path `s_t` at `theta`.
estimate_covid_theta <- function(factors, p, residual_dates, covid_start,
                                 lower, upper) {
  loglik_at <- function(theta) {
    s <- covid_volatility_path(residual_dates, covid_start, theta)
    estimate_var_ols(factors, p, s = s)$loglik
  }

  # Row i of abs_change is the change into residual month i + 1, on the VAR's
  # left-hand side as in bvarGLP_covid.m
  abs_change <- rowMeans(abs(diff(factors[(p + 1):nrow(factors), , drop = FALSE])))
  t_star <- match(covid_start, residual_dates)
  start <- c(abs_change[t_star - 1 + 0:2] / mean(abs_change[1:(t_star - 2)]), 0.8)
  names(start) <- c("s0", "s1", "s2", "rho")
  lower <- lower[names(start)]
  upper <- upper[names(start)]
  start <- pmin(pmax(start, lower), upper)

  # factr = 1e3: the default 1e7 stops while the first-order conditions of s0
  # and s1 are still 1e-3 away from closing in simulated data
  fit <- optim(start, loglik_at, method = "L-BFGS-B", lower = lower,
               upper = upper, control = list(fnscale = -1, factr = 1e3))

  list(
    theta = fit$par,
    loglik = fit$value,
    start = start,
    convergence = fit$convergence,
    message = fit$message,
    path = covid_volatility_path(residual_dates, covid_start, fit$par)
  )
}


#' Factor VAR with the Kilian bias-corrected companion matrix
#'
#' Same OLS fit as `estimate_var_ols()`, then `kilian_correction()` on the
#' companion. Used only to build the bootstrap DGP — never for the reported
#' point IRF.
#'
#' @param data Numeric matrix of factors (T x K).
#' @param p Lag order.
#'
#' @return List with the OLS and corrected coefficients, residuals, both
#'   companion matrices, the residual covariance and stability diagnostics.
estimate_corrected_var <- function(data, p) {
  T <- nrow(data)
  K <- ncol(data)
  
  # Construct regressor matrix
  RHS <- matrix(NA, T - p, K * p + 1)
  
  for (i in 1:p) {
    start_col <- (i - 1) * K + 1
    end_col <- i * K
    RHS[, start_col:end_col] <- data[(p + 1 - i):(T - i), ]
  }
  
  # Add constant
  RHS[, K * p + 1] <- 1
  
  
  # 2. Variável dependente
  LHS <- data[(p + 1):T, ]
  
  # 3. Estimação por OLS
  XtX <- crossprod(RHS)
  XtY <- crossprod(RHS, LHS)
  
  bet <- solve(XtX) %*% XtY
  
  # 4. Calcular resíduos
  u <- LHS - RHS %*% bet
  
  # Ensure u is numeric
  u <- Re(as.matrix(u))
  
  # 5. Construir matriz companion (excluindo constante)
  coeffcompanion <- rbind(
    t(bet[1:(p * K), ]),  # Coeficientes VAR
    cbind(diag((p - 1) * K), matrix(0, (p - 1) * K, K))  # Identidade para lags
  )
  
  # Calculate covariance matrix of residuals strictly following Matlab
  # SIGMA = zeros(p*K);
  # SIGMA(1:K,1:K) = u'*u/(T-p-p*K-1);
  SIGMA <- crossprod(u) / (T - p - p * K - 1)
  
  # Apply Kilian correction
  eigenvals_orig <- eigen(coeffcompanion)$values
  max_eigen_orig <- max(abs(eigenvals_orig))
  
  coeffcompanion_corrected <- kilian_correction(coeffcompanion, SIGMA, T, K, p)
  
  eigenvals_corr <- eigen(coeffcompanion_corrected)$values
  max_eigen_corr <- max(abs(eigenvals_corr))
  
  # ...diagnóstico removido...
  
  # Extract corrected coefficients
  beta_corrected <- t(coeffcompanion_corrected[1:K, ])
  
  # Recalculate residuals with corrected coefficients
  Y_resid <- data[(p + 1):T, ]
  X_resid <- matrix(0, T - p, K * p)
  
  for (i in 1:p) {
    X_resid[, ((i - 1) * K + 1):(i * K)] <- data[(p - i + 1):(T - i), ]
  }
  
  # Add constant to beta_corrected
  intercept <- bet[K * p + 1, ]
  beta_corrected_full <- rbind(beta_corrected, intercept)
  
  # Add constant to X_resid
  X_resid_full <- cbind(X_resid, 1)
  
  beta_corrected_full <- as.matrix(Re(beta_corrected_full))
  X_resid_full <- as.matrix(Re(X_resid_full))
  Y_resid <- as.matrix(Re(Y_resid))
  
  u_corrected <- Y_resid - X_resid_full %*% beta_corrected_full
  u_corrected <- as.matrix(Re(u_corrected))
  
  return(list(
    coefficients = beta_corrected_full,
    residuals = u_corrected,
    companion = coeffcompanion_corrected,
    residuals_original = u,
    coefficients_original = bet,
    companion_original = coeffcompanion,
    covariance_matrix = SIGMA,
    # Diagnósticos adicionais
    diagnostics = list(
      original_max_eigenval = max_eigen_orig,
      corrected_max_eigenval = max_eigen_corr,
      is_stable_original = max_eigen_orig < 1,
      is_stable_corrected = max_eigen_corr < 1,
      covariance_det = det(Re(SIGMA))
    )
  ))
}



#' Reduce the factor-VAR residuals to q dynamic shocks
#'
#' Takes the leading `q` eigenvectors of the residual covariance, so the
#' `r`-dimensional VAR innovations are spanned by `q` dynamic shocks
#' `eta = K M^{-1} u`. When `q == r` the reduction is the identity and the
#' innovations pass through unchanged.
#'
#' @param var_residuals Matrix of factor-VAR residuals (T-p x r).
#' @param q Number of dynamic factors.
#' @param r Number of static factors.
#' @param sigma_u Second-moment matrix whose leading eigenvectors give K; the
#'   residual covariance by default. `estimate_dfm()` passes the uncentered
#'   second moment under the COVID volatility treatment.
#'
#' @return List with eta, the eigenvector matrix K, the scaling matrix M, the
#'   eigenvalues and diagnostics.
estimate_dynamic_factors <- function(var_residuals, q, r,
                                     sigma_u = cov(var_residuals)) {
  if (q == r) {
    # Caso especial: q = r (fatores dinâmicos = fatores estáticos)
    K <- 1
    M <- 1
    eta <- var_residuals
    eigenvals <- rep(1, r)
  } else {
    # Caso geral: q < r
    # CRÍTICO: Usar decomposição SVD ao invés de eigen para garantir determinismo
    svd_result <- svd(sigma_u)
    eigenvals_sorted <- sort(svd_result$d, decreasing = TRUE)
    idx <- order(svd_result$d, decreasing = TRUE)[1:q]
    eigenvals <- eigenvals_sorted[1:q]
    eigenvects <- svd_result$u[, idx, drop = FALSE]
    # CRÍTICO: Normalizar autovetores de forma determinística
    for (i in 1:ncol(eigenvects)) {
      # Garantir sinal consistente: fazer o maior elemento absoluto positivo
      max_abs_idx <- which.max(abs(eigenvects[, i]))
      if (eigenvects[max_abs_idx, i] < 0) {
        eigenvects[, i] <- -eigenvects[, i]
      }
    }
    # Construir matrizes K e M
    K <- eigenvects  # Autovetores (matriz K)
    # nrow = q é obrigatório: com q = 1, diag() lê o escalar como DIMENSAO da
    # identidade, não como valor diagonal, e devolve uma matriz não conforme.
    M <- diag(sqrt(eigenvals), nrow = q)  # M = diag(sqrt(diag(MM)))
    # Calcular fatores dinâmicos: eta = u * K / M
    eta <- var_residuals %*% K %*% solve(M)
  }
  
  if (q == r) {
    diagnostics <- list(case = "q_equals_r")
  } else {
    diagnostics <- list(case = "q_less_than_r", selected_indices = idx)
  }
  return(list(
    factors = eta,    # Fatores dinâmicos eta
    K = K,           # Matriz de autovetores (ou escalar se q=r)
    M = M,           # Matriz diagonal com raiz dos autovalores (ou escalar se q=r)
    eigenvalues = eigenvals,  # Autovalores para diagnóstico
    diagnostics = diagnostics
  ))
}



#' Estimate the structural dynamic factor model end to end
#'
#' Chains static factors (BLL standardization), the factor VAR, and the
#' dynamic factors, following Alessi & Kerssenfischer over BLL methodology.
#' When both `dates` and `instrument` are supplied the panel and the
#' instrument are trimmed to their common months before estimation, so the
#' returned residuals are already aligned to the proxy.
#'
#' @param data Numeric matrix T x N (no date column).
#' @param r Number of static factors.
#' @param q Number of dynamic factors.
#' @param p Factor-VAR lag order.
#' @param dates Optional Date vector with T elements.
#' @param instrument Optional data.frame with columns `month` (Date) and
#'   `shock` (numeric).
#' @param apply_kilian When TRUE, also computes the Kilian (1998) bias-corrected
#'   coefficients for the bootstrap DGP. The point estimate ALWAYS uses plain
#'   OLS, faithful to `DFMest_BLL.m`.
#' @param covid_volatility NULL (production) or a list that turns on the COVID
#'   volatility scale of Lenza & Primiceri (2022) in the factor VAR:
#'   `covid_start` (Date, one of the residual months), `theta` (named `s0`,
#'   `s1`, `s2`, `rho`) and `innovations` — `"raw"`, the residuals
#'   `u_t = y_t - B'x_t`, or `"standardized"`, `u_t / s_t` — which decides what
#'   K, M and eta read downstream. Every field is required, because each is an
#'   author decision; `production_spec()$covid_volatility_design` records the
#'   ones taken, and `estimate_covid_theta()` estimates `theta`. Under it
#'   nothing is centered: K comes from the uncentered second moment of the
#'   selected innovations, (B4) for `"standardized"`. Requires `dates`;
#'   incompatible with `apply_kilian`.
#'
#' @return List with the static factors, the factor VAR, the dynamic factors,
#'   the aligned dates and instrument, and diagnostics. Under
#'   `covid_volatility`, `var_residuals` holds the innovations the switch
#'   selected, and the list adds `covid_volatility`, `volatility_path`,
#'   `var_residuals_raw`, `var_residuals_standardized`, `var_sigma_mle` and
#'   `var_loglik`.
estimate_dfm <- function(data, r, q, p, dates = NULL, instrument = NULL,
                         apply_kilian = FALSE, covid_volatility = NULL) {
  T_orig <- nrow(data)

  # --- Validação e alinhamento temporal via datas ---
  if (!is.null(dates)) {
    dates <- as.Date(dates)
    if (length(dates) != T_orig) {
      stop("Vetor de dates (", length(dates), ") deve ter o mesmo comprimento ",
           "que nrow(data) (", T_orig, ")")
    }
  }

  if (!is.null(instrument)) {
    if (!is.data.frame(instrument) || !all(c("month", "shock") %in% names(instrument))) {
      stop("instrument deve ser um data.frame com colunas 'month' e 'shock'")
    }
    instrument$month <- as.Date(instrument$month)

    if (!is.null(dates)) {
      n_inst_orig <- nrow(instrument)

      common_dates <- as.Date(intersect(as.character(dates), as.character(instrument$month)))
      if (length(common_dates) == 0) {
        stop("Nenhuma data em comum entre dados e instrumento")
      }

      data_idx <- dates %in% common_dates
      data <- data[data_idx, , drop = FALSE]
      dates <- dates[data_idx]

      instrument <- instrument[instrument$month %in% common_dates, ]
      instrument <- instrument[order(instrument$month), ]

      message(sprintf("Alinhamento temporal: %d datas em comum (de %d dados e %d instrumento)",
                      length(common_dates), T_orig, n_inst_orig))
    }
  }

  # --- Volatilidade COVID (Lenza-Primiceri 2022, Apêndice B) ---
  # Todo campo é decisão do autor: nenhum tem default.
  volatility_path <- NULL
  if (!is.null(covid_volatility)) {
    missing_fields <- c(
      setdiff(c("covid_start", "theta", "innovations"), names(covid_volatility)),
      setdiff(c("s0", "s1", "s2", "rho"), names(covid_volatility$theta))
    )
    if (length(missing_fields) > 0) {
      stop("covid_volatility sem ", paste(missing_fields, collapse = ", "),
           ": escolhas do autor, sem default ",
           "(notas/2026-09-14_volatilidade_covid_lenza_primiceri.md)")
    }
    if (!isTRUE(covid_volatility$innovations %in% c("raw", "standardized"))) {
      stop("covid_volatility$innovations deve ser 'raw' (u_t) ou ",
           "'standardized' (u_t/s_t)")
    }
    if (apply_kilian) {
      stop("A correcao de Kilian supoe OLS com Sigma constante e nao esta ",
           "definida sob covid_volatility")
    }
    covid_start <- as.Date(covid_volatility$covid_start)
    residual_dates <- dates[(p + 1):length(dates)]
    if (!isTRUE(covid_start %in% residual_dates)) {
      stop("covid_start (", format(covid_start), ") nao e um mes dos residuos ",
           "do VAR (", format(residual_dates[1]), " a ",
           format(residual_dates[length(residual_dates)]), ")")
    }
    volatility_path <- covid_volatility_path(residual_dates, covid_start,
                                             covid_volatility$theta)
  }

  # --- Estimação ---
  static_result <- estimate_static_factors(data, r)

  # Ponto estimado: SEMPRE VAR OLS (sem Kilian), fiel ao DFMest_BLL.m. Sob
  # covid_volatility, mínimos quadrados nas linhas divididas por s_t (B2).
  var_result <- estimate_var_ols(static_result$factors, p, s = volatility_path)

  # O que os passos seguintes, que supõem variância constante, leem como
  # inovação: K, M e eta, e daí o H do proxy.
  innovations <- var_result$residuals
  if (!is.null(covid_volatility) && covid_volatility$innovations == "standardized") {
    innovations <- var_result$residuals_standardized
  }

  # Sob WLS nada é centrado: K lê o segundo momento não centrado das inovações,
  # que com "standardized" é a (B4). Sem tratamento, o cov() de sempre.
  if (is.null(covid_volatility)) {
    dynamic_result <- estimate_dynamic_factors(innovations, q, r)
  } else {
    dynamic_result <- estimate_dynamic_factors(
      innovations, q, r, sigma_u = crossprod(innovations) / nrow(innovations)
    )
  }

  max_eigenval <- max(abs(eigen(var_result$companion)$values))
  is_stable <- max_eigenval < 1

  # Kilian correction: apenas para o DGP do bootstrap (DFMest_BLL_Boot.m)
  kilian_result <- NULL
  if (apply_kilian) {
    kilian_result <- estimate_corrected_var(static_result$factors, p)
  }

  out <- list(
    # Static factors
    static_factors = static_result$factors,
    static_loadings = static_result$loadings,
    static_eigenvalues = static_result$eigenvalues,

    # VAR on static factors (OLS, sem Kilian — para ponto estimado)
    var_coefficients = var_result$coefficients,
    var_residuals = innovations,
    companion_matrix = var_result$companion,
    var_covariance = var_result$covariance_matrix,

    # Kilian-corrected (apenas para DGP do bootstrap)
    var_coefficients_corrected = if (!is.null(kilian_result)) kilian_result$coefficients else NULL,
    companion_corrected = if (!is.null(kilian_result)) kilian_result$companion else NULL,
    var_residuals_original = var_result$residuals,  # resíduos OLS para bootstrap

    # Dynamic factors
    dynamic_factors = dynamic_result$factors,
    dynamic_loadings = dynamic_result$K,
    dynamic_scaling = dynamic_result$M,
    dynamic_eigenvalues = dynamic_result$eigenvalues,

    # Dados transformados e auxiliares
    data_sd = static_result$sy,
    Z = static_result$Z,
    yy = static_result$yy,
    detrended_data = static_result$detrended_data,

    # Componentes para IRF
    loadings_lambda = static_result$loadings,
    scaling_matrix_K = dynamic_result$K,
    scaling_matrix_M = dynamic_result$M,

    # Parâmetros do modelo
    p = p,
    r = r,
    q = q,

    # Datas e instrumento
    dates = dates,
    instrument = instrument,

    # Diagnósticos
    diagnostics = list(
      max_eigenvalue = max_eigenval,
      is_stable = is_stable
    )
  )

  if (!is.null(covid_volatility)) {
    out <- c(out, list(
      covid_volatility = covid_volatility,
      volatility_path = volatility_path,
      var_residuals_raw = var_result$residuals,
      var_residuals_standardized = var_result$residuals_standardized,
      var_sigma_mle = var_result$sigma_mle,
      var_loglik = var_result$loglik
    ))
  }

  out
}
#' Recover the dynamic-factor innovations from a fitted DFM
#'
#' When `q == r`, the estimator stores scalar identity placeholders for the
#' dynamic loading and scaling matrices. In that case the factor-VAR residuals
#' already are the dynamic innovations.
#'
#' @param dfm_results Fitted DFM returned by `estimate_dfm()`.
#'
#' @return Numeric matrix with one dynamic innovation per column.
extract_dynamic_innovations <- function(dfm_results) {
  K <- dfm_results$dynamic_loadings
  M <- dfm_results$dynamic_scaling
  u <- dfm_results$var_residuals
  if (!is.matrix(K) && !is.matrix(M)) {
    return(u)
  }
  u %*% K %*% solve(M)
}


#' Map a dynamic-shock direction into the static-factor space
#'
#' @param dfm_results Fitted DFM returned by `estimate_dfm()`.
#' @param direction Numeric direction in the dynamic innovation space.
#'
#' @return Numeric vector in the static-factor space.
map_dynamic_direction_to_static <- function(dfm_results, direction) {
  K <- dfm_results$dynamic_loadings
  M <- dfm_results$dynamic_scaling
  if (!is.matrix(K) && !is.matrix(M)) {
    return(as.numeric(direction))
  }
  drop(K %*% M %*% direction)
}
