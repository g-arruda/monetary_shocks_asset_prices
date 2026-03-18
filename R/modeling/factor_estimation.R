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
amengual_watson <- function(X, r, p = 4, max_q = NULL, scale = TRUE, apply_bll = FALSE) {
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

  bn <- bai_ng_criteria(resid_mat, max_r = max_q, standardize = FALSE)
  q_hat <- bn$r_hat$IC2

  list(
    aw = bn$criteria$IC2,
    q_hat = q_hat
  )
}


#' Generate scree plot analysis following Stock & Watson (2016)
#' @param X Matrix of standardized data
#' @param max_comp Maximum number of components to plot (default = 15)
#' @return List containing variance decomposition and plot
scree_analysis <- function(X, max_comp = 15) {
  # Get dimensions
  T <- nrow(X)
  N <- ncol(X)
  max_comp <- min(max_comp, N) # Ensure max_comp doesn't exceed N

  # Standardize data
  X_std <- scale(X)

  # Get PCA
  pca <- stats::prcomp(X_std, scale. = FALSE) # Already standardized

  # Compute R2 for each number of factors
  r2_vec <- numeric(max_comp)
  for (k in 1:max_comp) {
    F_hat <- pca$x[, 1:k, drop = FALSE]
    ssr <- 0

    # For each variable, compute SSR with k factors
    for (i in 1:N) {
      y <- X_std[, i]
      lambda <- solve(crossprod(F_hat), crossprod(F_hat, y))
      resid <- y - F_hat %*% lambda
      ssr <- ssr + sum(resid^2)
    }

    # Compute R2
    r2_vec[k] <- 1 - ssr / sum(X_std^2)
  }

  # Compute marginal R2
  marg_r2 <- c(r2_vec[1], diff(r2_vec))

  # Create data frame for ggplot
  plot_data <- data.frame(
    k = 1:max_comp,
    marginal_r2 = marg_r2
  )

  # Create plot
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = k, y = marginal_r2)) +
    ggplot2::geom_line() +
    ggplot2::geom_point(size = 4) +
    ggplot2::labs(
      x = "Number of Components",
      y = "Proportion of Variance Explained",
      title = "Scree Plot: Marginal Contribution of Each Factor"
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      text = ggplot2::element_text(size = 12),
      plot.title = ggplot2::element_text(hjust = 0.5)
    )

  # Return results
  results <- list(
    r2 = r2_vec,
    marginal_r2 = marg_r2,
    eigenvalues = pca$sdev[1:max_comp]^2,
    cumulative_r2 = cumsum(marg_r2),
    plot = p
  )

  return(invisible(results))
}




estimate_static_factors <- function(data, r, standardized = TRUE, seed = NULL) {
  # Dimensões
  T <- nrow(data)
  N <- ncol(data)
  
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
  regX <- cbind(1, 1:T)  # Constante e tendência linear
  
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



kilian_correction <- function(A, SIGMA, t, q, p) {
  # ===================================================================
  # CORREÇÃO DE VIÉS DE KILIAN (1998) - BASEADA NO CÓDIGO MATLAB ORIGINAL
  # Fonte: Pope (1990), JTSA; Kilian (1997)
  # Implementação fiel ao código MATLAB original de Lutz Kilian
  # ===================================================================
  
  # Seguindo exatamente o código MATLAB
  T <- t - p
  
  # Calcular SIGMAY usando a equação de Lyapunov
  # vecSIGMAY = inv(eye((q*p)^2) - kron(A,A)) * vec(SIGMA)
  I_kron <- diag((q * p)^2)
  A_kron_A <- kronecker(A, A)
  lyapunov_matrix <- I_kron - A_kron_A
  
  # Verificar se a matriz é invertível
  if (Mod(det(Re(lyapunov_matrix))) < 1e-12) {
    lyapunov_inv <- MASS::ginv(Re(lyapunov_matrix))
  } else {
    lyapunov_inv <- solve(Re(lyapunov_matrix))
  }
  
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
    # Verificar se a matriz é invertível
    if (Mod(det(Re(I_minus_peigen_B))) > 1e-12) {
      term <- peigen[h] * solve(Re(I_minus_peigen_B))
      sumeig <- sumeig + term
      # variável removida
    }
  }
  
  # Calcular bias seguindo exatamente o MATLAB
  # bias = SIGMA * (inv(I-B) + B*inv(I-B^2) + sumeig) * inv(SIGMAY)
  
  I_minus_B <- I - B
  I_minus_B2 <- I - B %*% B
  
  # ...diagnóstico removido...
  
  # Verificar se as matrizes são invertíveis
  if (Mod(det(Re(I_minus_B))) < 1e-12) {
    cat("- AVISO: Usando pseudo-inversa para (I-B)\n")
    inv_I_minus_B <- MASS::ginv(Re(I_minus_B))
  } else {
    inv_I_minus_B <- solve(Re(I_minus_B))
  }
  
  if (abs(det(Re(I_minus_B2))) < 1e-12) {
    cat("- AVISO: Usando pseudo-inversa para (I-B²)\n")
    inv_I_minus_B2 <- MASS::ginv(Re(I_minus_B2))
  } else {
    inv_I_minus_B2 <- solve(Re(I_minus_B2))
  }
  
  if (abs(det(Re(SIGMAY))) < 1e-12) {
    cat("- AVISO: Usando pseudo-inversa para SIGMAY\n")
    inv_SIGMAY <- MASS::ginv(Re(SIGMAY))
  } else {
    inv_SIGMAY <- solve(Re(SIGMAY))
  }
  
  # Calcular bias
  bias_term <- inv_I_minus_B + B %*% inv_I_minus_B2 + sumeig
  bias <- SIGMA %*% bias_term %*% inv_SIGMAY
  
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
    max_eigenval <- max(bcmod)
    
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
  
  # Calculate covariance matrix of residuals
  SIGMA <- cov(u)
  
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



estimate_dynamic_factors <- function(var_residuals, q, r) {
  # ===================================================================
  # ESTIMAÇÃO DOS FATORES DINÂMICOS
  # ===================================================================
  
  
  if (q == r) {
    # Caso especial: q = r (fatores dinâmicos = fatores estáticos)
    K <- 1
    M <- 1
    eta <- var_residuals
    eigenvals <- rep(1, r)
  } else {
    # Caso geral: q < r
    # Calcular matriz de covariância dos resíduos VAR
    sigma_u <- cov(var_residuals)
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
    M <- diag(sqrt(eigenvals))  # M = diag(sqrt(diag(MM)))
    # Calcular fatores dinâmicos: eta = u * K / M
    if (q == 1) {
      # Caso especial para q=1: M é escalar
      eta <- var_residuals %*% K / as.numeric(M)
    } else {
      eta <- var_residuals %*% K %*% solve(M)
    }
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



estimate_dfm <- function(data, r, q, p, dates = NULL, instrument = NULL) {
  # ===================================================================
  # ESTIMAÇÃO COMPLETA DO MODELO DE FATORES DINÂMICOS ESTRUTURAIS (SDFM)
  # Implementação baseada em Alessi & Kerssenfischer com metodologia BLL
  #

  # @param data      Matriz T x N de dados (sem coluna de datas)
  # @param r         Número de fatores estáticos
  # @param q         Número de fatores dinâmicos
  # @param p         Ordem do VAR
  # @param dates     Vetor de datas (Date) com T elementos, correspondendo às linhas de data.
  #                  Usado para alinhar temporalmente dados e instrumento.

  # @param instrument Data.frame com colunas 'month' (Date) e 'shock' (numeric).
  #                   Se fornecido junto com dates, o alinhamento temporal é feito
  #                   automaticamente via inner join por data.
  # ===================================================================

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

      # Inner join: manter apenas datas comuns entre dados e instrumento
      common_dates <- as.Date(intersect(as.character(dates), as.character(instrument$month)))
      if (length(common_dates) == 0) {
        stop("Nenhuma data em comum entre dados e instrumento")
      }

      # Filtrar dados para datas comuns
      data_idx <- dates %in% common_dates
      data <- data[data_idx, , drop = FALSE]
      dates <- dates[data_idx]

      # Filtrar e ordenar instrumento para datas comuns
      instrument <- instrument[instrument$month %in% common_dates, ]
      instrument <- instrument[order(instrument$month), ]

      message(sprintf("Alinhamento temporal: %d datas em comum (de %d dados e %d instrumento)",
                      length(common_dates), T_orig, n_inst_orig))
    }
  }

  # --- Estimação ---
  static_result <- estimate_static_factors(data, r)

  var_result <- estimate_corrected_var(static_result$factors, p)

  dynamic_result <- estimate_dynamic_factors(var_result$residuals, q, r)
  
  max_eigenval <- max(abs(eigen(var_result$companion)$values))
  is_stable <- max_eigenval < 1

  return(list(
    # Static factors
    static_factors = static_result$factors,
    static_loadings = static_result$loadings,
    static_eigenvalues = static_result$eigenvalues,

    # VAR on static factors
    var_coefficients = var_result$coefficients,
    var_residuals = var_result$residuals,
    companion_matrix = var_result$companion,
    var_covariance = var_result$covariance_matrix,

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
    loadings_lambda = static_result$loadings,  # λ
    scaling_matrix_K = dynamic_result$K,       # K
    scaling_matrix_M = dynamic_result$M,       # M

    # Parâmetros do modelo
    p = p,  # Ordem do VAR
    r = r,  # Número de fatores estáticos
    q = q,  # Número de fatores dinâmicos

    # Datas e instrumento (para alinhamento temporal no IRF)
    dates = dates,                # Vetor de datas alinhadas (T observações)
    instrument = instrument,      # Data.frame do instrumento (já filtrado)

    # Diagnósticos consolidados
    diagnostics = list(
      max_eigenvalue = max_eigenval,
      is_stable = is_stable
    )
  ))
}
