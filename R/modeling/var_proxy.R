# ===================================================================
# Reduced-form VAR for the observable SVAR-IV benchmark.
#
# Faithful translations of:
#   codigos_externos/codigo_olea/functions/RForm/RForm_VAR.m
#   codigos_externos/codigo_olea/functions/RForm/bicaic.m
#
# The active small VAR uses these estimators directly. Identification and
# Anderson--Rubin inference live in R/identification/weak_iv_ar.R.
# ===================================================================


#' Estimate the Montiel Olea reduced-form VAR
#'
#' Translates `RForm_VAR.m` and optionally adds a linear trend after the
#' constant. All equations are estimated jointly by OLS, and the residual
#' covariance uses the authors' divisor `T`.
#'
#' @param series Data matrix with observations in rows and variables in columns.
#' @param p Positive lag order.
#' @param deterministic Deterministic specification: `constant` or `trend`.
#'
#' @return List with deterministic coefficients, `AL`, `Sigma`, `eta`, `X`,
#'   and `Y`, using the orientations of `RForm_VAR.m`. In particular, `eta` is
#'   `n x T`.
#'
#' @examples
#' fit <- olea_rform_var(matrix(stats::rnorm(200), ncol = 2), p = 1L)
olea_rform_var <- function(series, p, deterministic = c("constant", "trend")) {
  series <- as.matrix(series)
  p <- as.integer(p)
  deterministic <- match.arg(deterministic)

  if (length(p) != 1L || is.na(p) || p < 1L) {
    stop("p must be a positive integer")
  }
  if (nrow(series) <= p || ncol(series) < 1L || any(!is.finite(series))) {
    stop("series must be finite and have more rows than p")
  }

  n_total <- nrow(series)
  lags <- do.call(
    cbind,
    lapply(seq_len(p), function(lag) {
      series[(p + 1L - lag):(n_total - lag), , drop = FALSE]
    })
  )
  Y <- series[(p + 1L):n_total, , drop = FALSE]
  deterministic_terms <- if (deterministic == "constant") {
    matrix(1, nrow(Y), 1L, dimnames = list(NULL, "constant"))
  } else {
    cbind(constant = 1, trend = (p + 1L):n_total)
  }
  X <- cbind(deterministic_terms, lags)

  slope <- t(Y) %*% X %*% solve(crossprod(X))
  n_deterministic <- ncol(deterministic_terms)
  deterministic_coef <- slope[, seq_len(n_deterministic), drop = FALSE]
  AL <- slope[, -(seq_len(n_deterministic)), drop = FALSE]
  eta <- t(Y) - slope %*% t(X)
  Sigma <- tcrossprod(eta) / ncol(eta)

  list(
    deterministic = deterministic_coef,
    mu = deterministic_coef[, 1L, drop = FALSE],
    AL = AL,
    Sigma = Sigma,
    eta = eta,
    X = X,
    Y = Y
  )
}


#' Compute VAR lag-order criteria on a common sample
#'
#' For each candidate order, the input is shortened so that every VAR has
#' `T = nrow(series) - pmax` residual observations. AIC and BIC penalise all
#' coefficients, including the deterministic terms.
#'
#' @param series Data matrix with observations in rows and variables in columns.
#' @param pmax Largest candidate lag order.
#' @param deterministic Deterministic specification: `constant` or `trend`.
#'
#' @return Data frame with AIC and BIC for every candidate order.
#'
#' @examples
#' criteria <- var_lag_criteria(matrix(stats::rnorm(400), ncol = 4), 12L)
var_lag_criteria <- function(
  series,
  pmax = 12L,
  deterministic = c("constant", "trend")
) {
  series <- as.matrix(series)
  pmax <- as.integer(pmax)
  deterministic <- match.arg(deterministic)

  if (length(pmax) != 1L || is.na(pmax) || pmax < 1L) {
    stop("pmax must be a positive integer")
  }
  if (nrow(series) <= pmax || ncol(series) < 1L || any(!is.finite(series))) {
    stop("series must be finite and have more rows than pmax")
  }

  T_common <- nrow(series) - pmax
  n <- ncol(series)
  n_deterministic <- if (deterministic == "constant") 1L else 2L
  rows <- lapply(seq_len(pmax), function(p) {
    series_p <- series[(pmax - p + 1L):nrow(series), , drop = FALSE]
    fit <- olea_rform_var(series_p, p, deterministic = deterministic)
    if (ncol(fit$eta) != T_common) {
      stop("The common-sample construction failed at p = ", p)
    }

    logdet <- determinant(fit$Sigma, logarithm = TRUE)
    if (logdet$sign <= 0L) {
      stop("Residual covariance is not positive definite at p = ", p)
    }

    n_parameters <- n^2 * p + n * n_deterministic
    data.frame(
      p = p,
      n = n,
      T_common = T_common,
      deterministic = deterministic,
      logdet = as.numeric(logdet$modulus),
      n_parameters = n_parameters,
      aic = as.numeric(logdet$modulus) + 2 * n_parameters / T_common,
      bic = as.numeric(logdet$modulus) +
        log(T_common) * n_parameters / T_common
    )
  })

  out <- dplyr::bind_rows(rows)
  out$selected_aic <- out$p == out$p[which.min(out$aic)]
  out$selected_bic <- out$p == out$p[which.min(out$bic)]
  out
}
