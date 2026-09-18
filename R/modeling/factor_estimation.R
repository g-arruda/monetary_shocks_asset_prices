#' Extract static factors under BLL standardization
#'
#' Standardizes the level panel by the standard deviation of its first
#' differences (Barigozzi, Lippi & Luciani 2016), removes a linear trend
#' series by series, and takes the leading `r` eigenvectors of the covariance
#' of the standardized differences. SVD rather than `eigen()`, and each
#' eigenvector signed so that its largest entry is positive, make the
#' decomposition bit-reproducible.
#'
#' @param data Numeric matrix of the level panel (T x N).
#' @param r Number of static factors.
#'
#' @return List with `factors` (T x r), `loadings` (N x r), `sy` (standard
#'   deviations of the first differences) and `yy` (the standardized first
#'   differences whose covariance the loadings decompose).
#'
#' @examples
#' static <- estimate_static_factors(panel, r = 5L)
estimate_static_factors <- function(data, r) {
  y <- diff(data)
  sy <- apply(y, 2, sd)
  yy <- sweep(sweep(y, 2, colMeans(y), "-"), 2, sy, "/")

  trend <- cbind(1, seq_len(nrow(data)))
  beta <- solve(crossprod(trend)) %*% crossprod(trend, data)
  Z <- sweep(data - trend %*% beta, 2, sy, "/")

  lambda <- svd(cov(yy))$u[, 1:r, drop = FALSE]
  flip <- lambda[cbind(apply(abs(lambda), 2, which.max), seq_len(r))] < 0
  lambda <- sweep(lambda, 2, ifelse(flip, -1, 1), "*")

  list(factors = Z %*% lambda, loadings = lambda, sy = sy, yy = yy)
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


#' Factor VAR by weighted least squares
#'
#' `F_t = c + A(L) F_{t-1} + s_t eps_t`, `eps_t ~ N(0, Sigma)`: every row,
#' constant included, is divided by `s_t`, which is (B2) of Lenza & Primiceri
#' (2022, JAE, Appendix B). With `s = 1` this is OLS, the direct equivalent of
#' `DFMest_BLL.m` lines 29-50. Nothing here chooses `s`.
#'
#' @param data Numeric matrix of factors (T x K).
#' @param p Lag order.
#' @param s Volatility scale: one positive value per residual row (length
#'   T - p) from `covid_volatility_path()`, or 1 for OLS.
#'
#' @return List with `coefficients` (lags first, constant last), `residuals`
#'   `u_t = y_t - B'x_t`, `residuals_standardized` (`u_t / s_t`), `companion`,
#'   `covariance_matrix` (of `u_t / s_t`, degrees-of-freedom divisor),
#'   `sigma_mle` (B4, divisor T - p) and `loglik` (B5, constants included).
#'
#' @examples
#' ols <- estimate_var_wls(factors, p = 4L)
#' wls <- estimate_var_wls(factors, p = 4L, s = covid_volatility_path(...))
estimate_var_wls <- function(data, p, s = 1) {
  K <- ncol(data)
  n_eff <- nrow(data) - p

  RHS <- cbind(stats::embed(data, p + 1)[, -(1:K), drop = FALSE], 1)
  LHS <- data[(p + 1):nrow(data), , drop = FALSE]

  bet <- solve(crossprod(RHS / s)) %*% crossprod(RHS / s, LHS / s)
  u <- LHS - RHS %*% bet
  e <- u / s
  sigma_mle <- crossprod(e) / n_eff

  list(
    coefficients = bet,
    residuals = u,
    residuals_standardized = e,
    companion = rbind(
      t(bet[1:(p * K), ]),
      cbind(diag((p - 1) * K), matrix(0, (p - 1) * K, K))
    ),
    covariance_matrix = crossprod(e) / (n_eff - p * K - 1),
    sigma_mle = sigma_mle,
    loglik = -n_eff * K / 2 * (1 + log(2 * pi)) - K * sum(log(s)) -
      n_eff / 2 * as.numeric(determinant(sigma_mle, logarithm = TRUE)$modulus)
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
#'
#' @examples
#' fit <- estimate_covid_theta(factors, 4L, residual_dates,
#'                             as.Date("2020-03-01"), lower, upper)
estimate_covid_theta <- function(factors, p, residual_dates, covid_start,
                                 lower, upper) {
  loglik_at <- function(theta) {
    s <- covid_volatility_path(residual_dates, covid_start, theta)
    estimate_var_wls(factors, p, s = s)$loglik
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


#' Reduce the factor-VAR innovations to q dynamic shocks
#'
#' Takes the leading `q` eigenvectors `K` of `sigma_u`, each signed so that its
#' largest entry is positive, and `M = diag(sqrt(eigenvalues))`, so the `r`
#' innovations are spanned by the `q` dynamic shocks `eta = u K M^-1`. When
#' `q == r` the reduction is the identity: `K = M = I_r` and `eta = u`.
#'
#' @param var_residuals Matrix of factor-VAR innovations (T - p x r).
#' @param q Number of dynamic factors.
#' @param sigma_u Second-moment matrix whose leading eigenvectors give `K`.
#'
#' @return List with `factors` (eta), `K` and `M`.
#'
#' @examples
#' dyn <- estimate_dynamic_factors(u, q = 3L, sigma_u = cov(u))
estimate_dynamic_factors <- function(var_residuals, q, sigma_u) {
  r <- ncol(var_residuals)
  if (q == r) {
    return(list(factors = var_residuals, K = diag(r), M = diag(r)))
  }

  svd_u <- svd(sigma_u)
  K <- svd_u$u[, 1:q, drop = FALSE]
  flip <- K[cbind(apply(abs(K), 2, which.max), seq_len(q))] < 0
  K <- sweep(K, 2, ifelse(flip, -1, 1), "*")
  # nrow = q: with q = 1, diag() would read the scalar as a dimension
  M <- diag(sqrt(svd_u$d[1:q]), nrow = q)

  list(factors = var_residuals %*% K %*% solve(M), K = K, M = M)
}


#' Estimate the structural dynamic factor model end to end
#'
#' Chains static factors (BLL standardization), the factor VAR and the
#' dynamic factors, following Alessi & Kerssenfischer over the BLL
#' methodology. With an `instrument`, the panel and the instrument are first
#' trimmed to their common months, so the residuals are aligned to the proxy.
#'
#' @param data Numeric matrix T x N (no date column).
#' @param r Number of static factors.
#' @param q Number of dynamic factors.
#' @param p Factor-VAR lag order.
#' @param dates Date vector with T elements; required with `instrument` or
#'   `covid_volatility`.
#' @param instrument Optional data.frame with columns `month` (Date) and
#'   `shock` (numeric).
#' @param covid_volatility NULL, or a list that turns on the COVID volatility
#'   scale of Lenza & Primiceri (2022) in the factor VAR: `covid_start` (Date,
#'   one of the residual months), `theta` (named `s0`, `s1`, `s2`, `rho`) and
#'   `innovations` — `"raw"`, the residuals `u_t`, or `"standardized"`,
#'   `u_t / s_t` — which decides what K, M and eta read downstream. Every
#'   field is required, because each is an author decision;
#'   `production_spec()$covid_volatility` carries the production one.
#'
#' @return List with the static factors and loadings, `data_sd`, the factor
#'   VAR (`var_coefficients`, `var_residuals` — the innovations the switch
#'   selected — and `companion_matrix`), the dynamic factors and their `K`
#'   (`dynamic_loadings`) and `M` (`dynamic_scaling`), `p`, `r`, `q`, the
#'   aligned `dates` and `instrument`, `covid_volatility`, `volatility_path`
#'   (`s_t`, or 1) and `diagnostics` (largest companion root and stability).
#'
#' @examples
#' dfm <- estimate_dfm(panel, 5L, 5L, 4L, dates = dates,
#'                     covid_volatility = production_spec()$covid_volatility)
estimate_dfm <- function(data, r, q, p, dates = NULL, instrument = NULL,
                         covid_volatility = NULL) {
  if (!is.null(instrument)) {
    keep <- dates %in% instrument$month
    data <- data[keep, , drop = FALSE]
    dates <- dates[keep]
    instrument <- instrument[instrument$month %in% dates, ]
    instrument <- instrument[order(instrument$month), ]
  }

  # Lenza-Primiceri (2022, Appendix B): every field is an author decision
  volatility_path <- 1
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
    residual_dates <- dates[(p + 1):length(dates)]
    if (!isTRUE(covid_volatility$covid_start %in% residual_dates)) {
      stop("covid_start (", format(covid_volatility$covid_start),
           ") nao e um mes dos residuos do VAR (", format(residual_dates[1]),
           " a ", format(residual_dates[length(residual_dates)]), ")")
    }
    volatility_path <- covid_volatility_path(residual_dates,
                                             covid_volatility$covid_start,
                                             covid_volatility$theta)
  }

  static <- estimate_static_factors(data, r)
  var_fit <- estimate_var_wls(static$factors, p, s = volatility_path)

  # K, M, eta and the proxy's H assume a constant variance and read these
  # innovations. Under the treatment nothing is centred: K reads the uncentred
  # second moment, which is (B4) for "standardized".
  innovations <- if (identical(covid_volatility$innovations, "standardized")) {
    var_fit$residuals_standardized
  } else {
    var_fit$residuals
  }
  sigma_u <- if (is.null(covid_volatility)) {
    cov(innovations)
  } else {
    crossprod(innovations) / nrow(innovations)
  }
  dynamic <- estimate_dynamic_factors(innovations, q, sigma_u)

  max_eigenvalue <- max(abs(eigen(var_fit$companion)$values))

  list(
    static_factors = static$factors,
    static_loadings = static$loadings,
    data_sd = static$sy,
    var_coefficients = var_fit$coefficients,
    var_residuals = innovations,
    companion_matrix = var_fit$companion,
    dynamic_factors = dynamic$factors,
    dynamic_loadings = dynamic$K,
    dynamic_scaling = dynamic$M,
    p = p,
    r = r,
    q = q,
    dates = dates,
    instrument = instrument,
    covid_volatility = covid_volatility,
    volatility_path = volatility_path,
    diagnostics = list(max_eigenvalue = max_eigenvalue,
                       is_stable = max_eigenvalue < 1)
  )
}


#' Recover the dynamic-factor innovations `eta = u K M^-1` of a fitted DFM
#'
#' @param dfm_results Fitted DFM returned by `estimate_dfm()`.
#'
#' @return Numeric matrix with one dynamic innovation per column.
#'
#' @examples
#' eta <- extract_dynamic_innovations(dfm)
extract_dynamic_innovations <- function(dfm_results) {
  dfm_results$var_residuals %*% dfm_results$dynamic_loadings %*%
    solve(dfm_results$dynamic_scaling)
}
