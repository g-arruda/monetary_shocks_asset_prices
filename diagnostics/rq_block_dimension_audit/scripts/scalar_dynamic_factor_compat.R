# Audit-local compatibility for q=1 when q<r.

estimate_dynamic_factors_project <- estimate_dynamic_factors

#' Estimate dynamic factors with an explicit 1-by-1 scaling matrix
#'
#' The production helper uses `diag(x)` for the scalar q=1 case. R interprets
#' a scalar `x` as a requested matrix dimension, not as a diagonal value. This
#' audit-local override leaves every existing q>1 and q=r path untouched and
#' makes the newly required q=1, q<r cells conformable without changing the
#' production module.
#'
#' @param var_residuals Static-factor VAR residual matrix.
#' @param q Number of dynamic factors.
#' @param r Number of static factors.
#'
#' @return Dynamic factors, loadings, scaling, eigenvalue, and diagnostics.
estimate_dynamic_factors <- function(var_residuals, q, r) {
  if (q != 1L || q == r) {
    return(estimate_dynamic_factors_project(var_residuals, q, r))
  }

  decomposition <- svd(cov(var_residuals))
  eigenvalue <- decomposition$d[1]
  loading <- decomposition$u[, 1, drop = FALSE]
  largest <- which.max(abs(loading[, 1]))
  if (loading[largest, 1] < 0) {
    loading <- -loading
  }
  scaling <- matrix(sqrt(eigenvalue), nrow = 1L, ncol = 1L)

  list(
    factors = var_residuals %*% loading / scaling[1, 1],
    K = loading,
    M = scaling,
    eigenvalues = eigenvalue,
    diagnostics = list(case = "q_less_than_r", selected_indices = 1L)
  )
}
