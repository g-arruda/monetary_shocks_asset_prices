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
  deterministic <- match.arg(deterministic)

  n_total <- nrow(series)
  lags <- do.call(cbind, purrr::map(seq_len(p), \(lag_order) {
    series[(p + 1L - lag_order):(n_total - lag_order), , drop = FALSE]
  }))
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
#' @return Tibble with the log determinant, AIC and BIC of every candidate
#'   order, and which order each criterion selects.
#'
#' @examples
#' criteria <- var_lag_criteria(matrix(stats::rnorm(400), ncol = 4), 12L)
var_lag_criteria <- function(series, pmax = 12L,
                             deterministic = c("constant", "trend")) {
  series <- as.matrix(series)
  deterministic <- match.arg(deterministic)

  T_common <- nrow(series) - pmax
  n <- ncol(series)
  n_deterministic <- if (deterministic == "constant") 1L else 2L

  seq_len(pmax) |>
    purrr::map(\(p) {
      fit <- olea_rform_var(
        series[(pmax - p + 1L):nrow(series), , drop = FALSE],
        p,
        deterministic = deterministic
      )
      logdet <- as.numeric(determinant(fit$Sigma, logarithm = TRUE)$modulus)
      n_parameters <- n^2 * p + n * n_deterministic

      tibble::tibble(
        p = p,
        n = n,
        T_common = T_common,
        deterministic = deterministic,
        logdet = logdet,
        n_parameters = n_parameters,
        aic = logdet + 2 * n_parameters / T_common,
        bic = logdet + log(T_common) * n_parameters / T_common
      )
    }) |>
    purrr::list_rbind() |>
    dplyr::mutate(
      selected_aic = p == p[which.min(aic)],
      selected_bic = p == p[which.min(bic)]
    )
}
