# Audit-local compatibility for q=1 when q<r. Frozen, and kept only for
# bit-reproducibility of this audit — see the docblock.

estimate_dynamic_factors_project <- estimate_dynamic_factors

#' Estimate dynamic factors with an explicit 1-by-1 scaling matrix
#'
#' **The defect this worked around is fixed.** `estimate_dynamic_factors()`
#' builds `M` with `diag(sqrt(eigenvals), nrow = q)` since 2026-08-17, so the
#' production module is conformable at q=1 and returns the same factors this
#' override does.
#'
#' The override survives for one reason only: it divides by `M[1, 1]` while the
#' module now post-multiplies by `solve(M)`, and `a / x` differs from
#' `a * (1 / x)` in the last bit (measured: 4.4e-16). This audit is frozen and
#' its CSVs are cited, so removing the override without re-running the grid
#' would move them at that order. Delete it the next time the audit re-runs.
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
