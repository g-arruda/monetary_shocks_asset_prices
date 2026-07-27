# Gouriéroux, Monfort & Renne (2017, J. Econometrics 196(1))
# "Statistical Inference for Independent Component Analysis:
#  Application to Structural VAR Models"
#
# Faithful in-repo translation of the pseudo-maximum-likelihood ICA estimator
# under SIR3 (C orthogonal), its Prop. 4 asymptotic distribution and the §2.5
# Wald test. Reference implementation: `IdSS` (Benhima & Renne),
# github.com/jrenne/IdSS, R/various_proc_ICA.R.
#
# WHY A TRANSLATION AND NOT A DEPENDENCY. The IdSS ICA path is correct only for
# n <= 3 (the dimension of the published application). Three independent defects
# bite at n >= 4, and this project runs it at q = 6:
#
#   1. `make.M` fills the upper triangle of A in column-major order of the
#      *positions*, which is not the transpose of the column-major order of the
#      lower triangle. For n >= 4 the resulting A is NOT skew-symmetric, so
#      C = (I+A)(I-A)^-1 is NOT orthogonal — SIR3 is violated and the dropped
#      |det C| = 1 term is no longer unity. `estim.SVAR.ICA` returns such a C.
#   2. `make.C` repeats the same error independently, so the objective function
#      (`pseudo.log.L` -> `func.2.minimize`) is evaluated over the same
#      non-orthogonal set.
#   3. The analytic gradient uses dvec(C)/dvec(A) = R' (x) (I + A). The Cayley
#      differential is dC = (I + C) dA R with R = (I-A)^-1, so the correct
#      Jacobian is R' (x) (I + C). Verified against numDeriv.
#
# `make.Omega`, `make.A.matrix` and `make.Asympt.Cov.delta` take C as an
# argument and never build it, so those are sound at any n and are used as
# cross-validation targets in `script/validate_gmr_ica.R`.
#
# Everything below is written against the paper, not the package. Equation
# numbers refer to the accepted manuscript in `artigos/`.

# ---------------------------------------------------------------------------
# Pseudo-densities
# ---------------------------------------------------------------------------

# A `distri` object is a list with the same field names IdSS uses, so the same
# object can be handed to both implementations in the validation harness:
#   type  : character vector, one per component
#   df    : degrees of freedom for "student" (NaN otherwise)
#   p, mu, sigma : mixture parameters for "mixt.gaussian" (NaN otherwise)

#' Log pseudo-density and its first two derivatives
#'
#' @param x Numeric vector.
#' @return List with `log_g`, `d_log_g`, `d2_log_g`, all the length of `x`.
#' @keywords internal
log_g_gaussian <- function(x, mu = 0, sigma = 1) {
  list(log_g     = -0.5 * log(2 * pi) - log(sigma) - (x - mu)^2 / (2 * sigma^2),
       d_log_g   = -(x - mu) / sigma^2,
       d2_log_g  = rep(-1 / sigma^2, length(x)))
}

#' @keywords internal
log_g_student <- function(x, nu) {
  # Standardized to unit variance: the scale factor sqrt(nu/(nu-2)) makes
  # x^2 * nu/(nu-2) / nu = x^2/(nu-2). Requires nu > 2 (nu > 4 for finite
  # kurtosis, which Prop. 4 needs).
  if (nu <= 2) stop("log_g_student: nu must exceed 2 (unit-variance scaling)")
  cst <- lgamma((nu + 1) / 2) - lgamma(nu / 2) - 0.5 * log(pi * (nu - 2))
  list(log_g    = cst - (1 + nu) / 2 * log(1 + x^2 / (nu - 2)),
       d_log_g  = -x * (1 + nu) / (nu - 2 + x^2),
       d2_log_g = -(1 + nu) * (nu - 2 - x^2) / (nu - 2 + x^2)^2)
}

#' @keywords internal
log_g_laplace <- function(x) {
  b <- 1 / sqrt(2)  # unit variance
  list(log_g    = -log(2 * b) - abs(x) / b,
       d_log_g  = -sign(x) / b,
       d2_log_g = rep(0, length(x)))
}

#' @keywords internal
log_g_hyper_sec <- function(x) {
  # Hyperbolic secant, unit variance (Baten 1934); Table 1 of the paper.
  # log g = log(1/2) - log(cosh(pi x / 2)), written via logspace to avoid
  # overflow in the tails.
  z  <- pi * x / 2
  lc <- abs(z) + log1p(exp(-2 * abs(z))) - log(2)   # = log(cosh(z))
  list(log_g    = log(pi / 4) - lc,
       d_log_g  = -(pi / 2) * tanh(z),
       d2_log_g = -(pi^2 / 4) / cosh(z)^2)
}

#' @keywords internal
log_g_mixt_gaussian <- function(x, mu, sigma, p) {
  # Two-component Gaussian mixture. Derivatives are computed analytically from
  # f, f', f'' rather than transcribed from a CAS expansion: the IdSS form
  # multiplies sigma^5 by exponentials and overflows well inside the range the
  # optimizer visits.
  lw <- cbind(log(p)     - 0.5 * log(2 * pi) - log(sigma[1]) -
                (x - mu[1])^2 / (2 * sigma[1]^2),
              log(1 - p) - 0.5 * log(2 * pi) - log(sigma[2]) -
                (x - mu[2])^2 / (2 * sigma[2]^2))
  m     <- pmax(lw[, 1], lw[, 2])
  w     <- exp(lw - m)                       # unnormalized component weights
  f     <- rowSums(w)
  s1    <- -(x - mu[1]) / sigma[1]^2         # d log phi_k / dx
  s2    <- -(x - mu[2]) / sigma[2]^2
  h1    <- s1^2 - 1 / sigma[1]^2             # (d2 phi_k / dx2) / phi_k
  h2    <- s2^2 - 1 / sigma[2]^2
  fp    <- (w[, 1] * s1 + w[, 2] * s2)
  fpp   <- (w[, 1] * h1 + w[, 2] * h2)
  d1    <- fp / f
  list(log_g    = m + log(f),
       d_log_g  = d1,
       d2_log_g = fpp / f - d1^2)
}

#' Evaluate the pseudo-densities component by component
#'
#' Mirrors `IdSS::gICA`. The `mixt.gaussian` second component is pinned by the
#' zero-mean / unit-variance restriction, exactly as in the reference code:
#' `mu_2 = -p/(1-p) mu_1` and
#' `sigma_2 = sqrt((1 - p sigma_1^2 - p/(1-p) mu_1^2)/(1-p))`.
#'
#' @param eps `T x n` matrix of candidate structural shocks.
#' @param distri Pseudo-density specification (see file header).
#' @return List of three `T x n` matrices: `log_g`, `d_log_g`, `d2_log_g`.
gmr_log_g <- function(eps, distri) {
  eps <- as.matrix(eps)
  n   <- ncol(eps)
  if (length(distri$type) != n)
    stop("gmr_log_g: distri$type has length ", length(distri$type),
         " but eps has ", n, " columns")

  out <- lapply(seq_len(n), function(i) {
    switch(distri$type[i],
      "gaussian"      = log_g_gaussian(eps[, i]),
      "student"       = log_g_student(eps[, i], nu = distri$df[i]),
      "laplace"       = log_g_laplace(eps[, i]),
      "hyper.sec"     = log_g_hyper_sec(eps[, i]),
      "mixt.gaussian" = {
        p  <- distri$p[i]; mu1 <- distri$mu[i]; s1 <- distri$sigma[i]
        v2 <- (1 - p * s1^2 - p / (1 - p) * mu1^2) / (1 - p)
        if (v2 <= 0)
          stop("gmr_log_g: component ", i, " has sigma = ", s1,
               " which leaves no admissible second-component variance ",
               "(need p*sigma^2 + p/(1-p)*mu^2 < 1)")
        log_g_mixt_gaussian(eps[, i], mu = c(mu1, -p / (1 - p) * mu1),
                            sigma = c(s1, sqrt(v2)), p = p)
      },
      stop("gmr_log_g: unknown density type '", distri$type[i], "'")
    )
  })

  list(log_g    = do.call(cbind, lapply(out, `[[`, "log_g")),
       d_log_g  = do.call(cbind, lapply(out, `[[`, "d_log_g")),
       d2_log_g = do.call(cbind, lapply(out, `[[`, "d2_log_g")))
}

#' Build a set of distinct, asymmetric Gaussian mixtures
#'
#' Assumption A.5 requires the `g_i` to be distinct and asymmetric for the
#' global maximum of the asymptotic criterion to be attained at a single
#' element of P(C_0). The paper's application uses `sigma = c(.5, .7, 1.3)`
#' at n = 3; this spreads `n` values over the admissible range.
#'
#' @param n Number of components.
#' @param p,mu Mixture weight and location shift (paper: 0.5 and 0.1).
#' @return A `distri` list.
gmr_distri_mixtures <- function(n, p = 0.5, mu = 0.1) {
  s_max <- sqrt((1 - p / (1 - p) * mu^2) / p)          # admissibility bound
  sigma <- seq(0.40, min(1.30, 0.95 * s_max), length.out = n)
  list(type  = rep("mixt.gaussian", n),
       df    = rep(NaN, n),
       p     = rep(p, n),
       mu    = rep(mu, n),
       sigma = sigma)
}

#' Student-t pseudo-densities with distinct degrees of freedom
#' @param n Number of components.
#' @param df Degrees of freedom; recycled/spread across components.
gmr_distri_student <- function(n, df = seq(5, 10, length.out = n)) {
  list(type = rep("student", n), df = df,
       p = rep(NaN, n), mu = rep(NaN, n), sigma = rep(NaN, n))
}

#' Hyperbolic-secant pseudo-densities
#' @param n Number of components.
gmr_distri_hypersec <- function(n) {
  list(type = rep("hyper.sec", n), df = rep(NaN, n),
       p = rep(NaN, n), mu = rep(NaN, n), sigma = rep(NaN, n))
}

# ---------------------------------------------------------------------------
# Cayley parametrization of the orthogonal group
# ---------------------------------------------------------------------------

#' Duplication matrix for skew-symmetric matrices
#'
#' Returns the `n^2 x n(n-1)/2` matrix `M` with `vec(A) = M a`, where `a`
#' collects the strictly-lower-triangular entries of `A` in column-major order
#' and `A' = -A`. Equivalent in intent to `IdSS::make.M`, which mis-orders the
#' upper triangle for `n >= 4`; see the file header.
#'
#' @param n Dimension.
make_M_skew <- function(n) {
  idx <- which(lower.tri(diag(n)), arr.ind = TRUE)   # column-major (row, col)
  k   <- nrow(idx)
  M   <- matrix(0, n * n, k)
  M[cbind(idx[, "row"] + (idx[, "col"] - 1L) * n, seq_len(k))] <-  1
  M[cbind(idx[, "col"] + (idx[, "row"] - 1L) * n, seq_len(k))] <- -1
  M
}

#' Cayley transform: orthogonal matrix from the free skew-symmetric parameters
#'
#' `C(A) = (I + A)(I - A)^{-1}`, eq. (2.4). Covers every orthogonal matrix with
#' no eigenvalue equal to -1, in one-to-one correspondence with `A`.
#'
#' @param a Free parameters, length `n(n-1)/2`.
#' @param n Dimension.
#' @param M Optional precomputed `make_M_skew(n)`.
cayley_C <- function(a, n, M = NULL) {
  if (is.null(M)) M <- make_M_skew(n)
  A <- matrix(M %*% a, n, n)
  (diag(n) + A) %*% solve(diag(n) - A)
}

#' Inverse Cayley transform, eq. (2.5)
#' @param C Orthogonal matrix.
cayley_a <- function(C) {
  n <- nrow(C)
  A <- solve(C + diag(n)) %*% (C - diag(n))
  A[lower.tri(A)]
}

# ---------------------------------------------------------------------------
# Pseudo log-likelihood, eq. (2.2)-(2.6)
# ---------------------------------------------------------------------------

#' Negative pseudo log-likelihood
#'
#' `-sum_t sum_i log g_i(c_i' Y_t)` with `C = C(a)` orthogonal, so the
#' `log|det C|` Jacobian term is zero and can be dropped.
#'
#' @param a Free Cayley parameters.
#' @param Yw `T x n` prewhitened observations.
#' @param distri Pseudo-density specification.
#' @param M Optional precomputed duplication matrix.
pml_neg_loglik <- function(a, Yw, distri, M = NULL) {
  n <- ncol(Yw)
  C <- cayley_C(a, n, M)
  v <- sum(gmr_log_g(Yw %*% C, distri)$log_g)
  if (!is.finite(v)) return(.Machine$double.xmax^0.5)
  -v
}

#' Analytic gradient of the negative pseudo log-likelihood
#'
#' `dL/dC = Yw' Psi` with `Psi[t, i] = d log g_i / de (eps[t, i])`, and the
#' Cayley differential `dC = (I + C) dA R`, `R = (I - A)^{-1}`, giving
#' `dvec(C)/dvec(A) = R' %x% (I + C)`. Chained through `M`:
#'
#'   dL/da = M' (R' %x% (I+C))' vec(G) = M' vec((I+C)' G R')
#'
#' using `(B %x% A) vec(X) = vec(A X B')`, which avoids forming the
#' `n^2 x n^2` Kronecker product — about 3x faster at n = 6 and the difference
#' grows with n. Verified against `numDeriv` in `script/validate_gmr_ica.R`.
#'
#' @inheritParams pml_neg_loglik
pml_neg_grad <- function(a, Yw, distri, M = NULL) {
  n <- ncol(Yw)
  if (is.null(M)) M <- make_M_skew(n)
  A   <- matrix(M %*% a, n, n)
  R   <- solve(diag(n) - A)
  C   <- (diag(n) + A) %*% R
  Psi <- gmr_log_g(Yw %*% C, distri)$d_log_g
  G   <- crossprod(Yw, Psi)                       # dL/dC, n x n
  as.vector(-crossprod(M, as.vector(crossprod(diag(n) + C, G %*% t(R)))))
}

#' Pseudo-ML ICA estimator with multi-start
#'
#' Optimizes eq. (2.6) over the `n(n-1)/2` free parameters. The reference code
#' runs Nelder-Mead -> BFGS -> Nelder-Mead from a single zero start; that was
#' tuned for n = 3 (3 parameters). At n = 6 there are 15 parameters and, when
#' some components are near-Gaussian, a near-flat ridge in the objective — so
#' the start is randomized and the best optimum is kept.
#'
#' @param Yw `T x n` prewhitened data (should satisfy `var(Yw) = I`).
#' @param distri Pseudo-density specification.
#' @param n_starts Number of starts; the first is always `a = 0` (`C = I`)
#'   unless `a_init` is supplied.
#' @param start_sd Scale of the random starts.
#' @param seed Optional RNG seed for reproducible starts.
#' @param maxit Nelder-Mead iteration cap.
#' @param a_init Optional warm start. Used as the first start and as the centre
#'   of the random ones. Bootstrap replications pass the point estimate here:
#'   it keeps every draw in the same basin (so the column labelling stays
#'   comparable) and cuts the cost of the search.
#' @return List with `C`, `a`, `eps`, `logLik`, `n_starts`, `converged`,
#'   `obj_by_start`, `all_C` (one aligned C per converged start), `n_at_best`,
#'   `gap_2nd` (objective distance to the best distinct optimum) and `spread`
#'   (worst column misalignment among the starts that reached the best
#'   optimum). Column-specific stability is left to the caller via `all_C`:
#'   when part of the space is near-Gaussian the full C can wander while the
#'   non-Gaussian columns stay put, and that distinction is the whole question.
estim_ica_pml <- function(Yw, distri, n_starts = 20L, start_sd = 0.5,
                          seed = NULL, maxit = 2000L, a_init = NULL) {
  Yw <- as.matrix(Yw)
  n  <- ncol(Yw)
  k  <- n * (n - 1) / 2
  M  <- make_M_skew(n)
  if (!is.null(seed)) set.seed(seed)

  centre <- if (is.null(a_init)) rep(0, k) else as.vector(a_init)
  if (length(centre) != k)
    stop("estim_ica_pml: a_init has length ", length(centre), ", expected ", k)
  starts <- vector("list", n_starts)
  starts[[1]] <- centre
  if (n_starts > 1)
    for (s in 2:n_starts) starts[[s]] <- centre + rnorm(k, 0, start_sd)

  fit_one <- function(a0) {
    for (stage in seq_len(3)) {
      res <- tryCatch(
        if (stage == 2) {
          optim(a0, pml_neg_loglik, pml_neg_grad, Yw = Yw, distri = distri,
                M = M, method = "BFGS", control = list(maxit = maxit))
        } else {
          optim(a0, pml_neg_loglik, Yw = Yw, distri = distri, M = M,
                method = "Nelder-Mead", control = list(maxit = maxit))
        },
        error = function(e) NULL)
      if (is.null(res)) return(NULL)
      a0 <- res$par
    }
    res
  }

  fits <- lapply(starts, fit_one)
  ok   <- !vapply(fits, is.null, logical(1))
  if (!any(ok)) stop("estim_ica_pml: every start failed to converge")

  obj  <- vapply(seq_along(fits), function(i)
    if (ok[i]) fits[[i]]$value else NA_real_, numeric(1))
  best <- which.min(obj)
  a    <- fits[[best]]$par
  C    <- cayley_C(a, n, M)

  # Every converged start, aligned to the winner, so the caller can ask about
  # one column instead of the whole matrix. Tolerance is relative to |obj|:
  # an absolute 1e-4 is meaningless against a log-likelihood in the thousands.
  idx   <- which(ok)
  all_C <- lapply(idx, function(i) match_columns(C, cayley_C(fits[[i]]$par, n, M))$C)
  tol   <- 1e-6 * max(1, abs(min(obj, na.rm = TRUE)))
  at_best <- which(obj[idx] - min(obj, na.rm = TRUE) <= tol)
  distinct <- sort(unique(round(obj[idx] / max(1, abs(min(obj, na.rm = TRUE))), 9)))
  gap_2nd <- if (length(distinct) < 2) NA_real_ else
    (distinct[2] - distinct[1]) * max(1, abs(min(obj, na.rm = TRUE)))

  spread <- if (length(at_best) < 2) 0 else
    max(vapply(all_C[at_best], function(Cj) max(abs(Cj - C)), numeric(1)))

  if (max(abs(crossprod(C) - diag(n))) > 1e-8)
    stop("estim_ica_pml: estimated C is not orthogonal — SIR3 violated")

  list(C = C, a = a, eps = Yw %*% C, logLik = -min(obj, na.rm = TRUE),
       n_starts = n_starts, converged = sum(ok), obj_by_start = obj[idx],
       all_C = all_C, n_at_best = length(at_best), gap_2nd = gap_2nd,
       spread = spread)
}

# ---------------------------------------------------------------------------
# Asymptotic distribution — Proposition 4 and Appendix 2
# ---------------------------------------------------------------------------

#' Index pairs (i, j), i < j, in the paper's stacking order
#'
#' Z is stacked as (Z_12, ..., Z_1n, Z_23, ..., Z_{n-1,n}), which is the
#' column-major order of the strictly-lower-triangular positions read as
#' (i = column, j = row). Same order `IdSS` selects via `which(!aux)`.
#' @keywords internal
gmr_pairs <- function(n) {
  idx <- which(lower.tri(diag(n)), arr.ind = TRUE)
  cbind(i = idx[, "col"], j = idx[, "row"])
}

#' Sample counterparts of the four moments Appendix 2 is written in
#'
#' `g1 = E[dlog g]`, `g2 = E[(dlog g)^2]`, `g3 = E[eps dlog g]`,
#' `g4 = E[d2log g]`. Mirrors `IdSS::make.g.stars`.
#' @keywords internal
gmr_g_stars <- function(eps, distri) {
  g <- gmr_log_g(eps, distri)
  list(g1 = colMeans(g$d_log_g),
       g2 = colMeans(g$d_log_g^2),
       g3 = colMeans(eps * g$d_log_g),
       g4 = colMeans(g$d2_log_g))
}

#' Covariance Omega of the asymptotic score, Appendix 2(i)
#'
#' `method = "analytic"` evaluates the closed forms of the paper, which impose
#' the independence of the sources. `method = "sample"` instead takes the
#' sample covariance of the per-observation score contributions
#' `z_t,(i,j) = eps_j,t s_i(eps_i,t) - eps_i,t s_j(eps_j,t)`, whose covariance
#' Omega *is* by definition. The two agree when the components really are
#' independent, so their gap is a specification diagnostic.
#'
#' @param eps `T x n` estimated structural shocks.
#' @param distri Pseudo-density specification.
#' @param method Closed form or sample covariance.
#' @return `n(n-1)/2 x n(n-1)/2` matrix.
gmr_omega <- function(eps, distri, method = c("analytic", "sample")) {
  method <- match.arg(method)
  eps <- as.matrix(eps)
  n   <- ncol(eps)
  P   <- gmr_pairs(n)
  np  <- nrow(P)

  if (method == "sample") {
    s <- gmr_log_g(eps, distri)$d_log_g
    Z <- vapply(seq_len(np), function(k) {
      i <- P[k, "i"]; j <- P[k, "j"]
      eps[, j] * s[, i] - eps[, i] * s[, j]
    }, numeric(nrow(eps)))
    return(stats::var(Z) * (nrow(eps) - 1) / nrow(eps))
  }

  gs <- gmr_g_stars(eps, distri)
  g1 <- gs$g1; g2 <- gs$g2; g3 <- gs$g3
  Om <- matrix(0, np, np)
  for (a in seq_len(np)) {
    i <- P[a, "i"]; j <- P[a, "j"]
    for (b in seq_len(np)) {
      k <- P[b, "i"]; l <- P[b, "j"]
      Om[a, b] <-
        if (i == k && j == l)      g2[i] + g2[j] - 2 * g3[i] * g3[j]
        else if (i == k)           g1[j] * g1[l]
        else if (j == l)           g1[i] * g1[k]
        else if (i == l)          -g1[j] * g1[k]
        else if (j == k)          -g1[i] * g1[l]
        else                       0
    }
  }
  Om
}

#' The matrix A of Proposition 4, Appendix 2(ii)
#'
#' `A = rbind(A1, A2, A3)`, square of size `n^2`. `A1` carries the expanded
#' FOC with `a'_{i,j} = {E[-d2 log g_i] + E[eps_j dlog g_j]} c_j'`; `A2` and
#' `A3` carry the first-order expansion of the orthogonality restrictions
#' `c_i' delta_j + c_j' delta_i = 0` and `c_i' delta_i = 0`.
#'
#' @param eps `T x n` estimated structural shocks.
#' @param distri Pseudo-density specification.
#' @param C Estimated orthogonal matrix.
gmr_A_matrix <- function(eps, distri, C) {
  n  <- ncol(as.matrix(eps))
  gs <- gmr_g_stars(eps, distri)
  g3 <- gs$g3; g4 <- gs$g4
  P  <- gmr_pairs(n)
  np <- nrow(P)
  blk <- function(i) ((i - 1) * n + 1):(i * n)

  A1 <- matrix(0, np, n^2)
  A2 <- matrix(0, np, n^2)
  for (a in seq_len(np)) {
    i <- P[a, "i"]; j <- P[a, "j"]
    A1[a, blk(i)] <-  (-g4[i] + g3[j]) * C[, j]
    A1[a, blk(j)] <- -(-g4[j] + g3[i]) * C[, i]
    A2[a, blk(i)] <- C[, j]
    A2[a, blk(j)] <- C[, i]
  }
  A3 <- matrix(0, n, n^2)
  for (i in seq_len(n)) A3[i, blk(i)] <- C[, i]

  rbind(A1, A2, A3)
}

#' Asymptotic covariance of vec(C_hat), Proposition 4
#'
#' `V = (1/T) A^{-1} [Omega 0; 0 0] (A')^{-1}`. Rank `n(n-1)/2`, so `V` is
#' singular by construction — the support has the dimension of the orthogonal
#' group. Do not invert it; the Wald statistic below uses `A` and `Omega`
#' directly.
#'
#' @param eps `T x n` estimated structural shocks.
#' @param distri Pseudo-density specification.
#' @param C Estimated orthogonal matrix.
#' @param omega_method Passed to `gmr_omega`.
#' @return List with `V`, `A`, `Omega`, `cond_A` (condition number of `A`,
#'   which blows up as the identified set degenerates) and `T_eff`.
gmr_asympt_cov <- function(eps, distri, C, omega_method = c("analytic", "sample")) {
  eps <- as.matrix(eps)
  n   <- ncol(eps)
  Tn  <- nrow(eps)
  A   <- gmr_A_matrix(eps, distri, C)
  Om  <- gmr_omega(eps, distri, method = match.arg(omega_method))

  Om_aug <- matrix(0, n^2, n^2)
  np <- nrow(Om)
  Om_aug[seq_len(np), seq_len(np)] <- Om

  cond_A <- tryCatch(kappa(A, exact = TRUE), error = function(e) NA_real_)
  Ainv   <- solve(A)
  list(V = Ainv %*% Om_aug %*% t(Ainv) / Tn,
       A = A, Omega = Om, cond_A = cond_A, T_eff = Tn)
}

# ---------------------------------------------------------------------------
# Testing — §2.5
# ---------------------------------------------------------------------------

#' Wald statistic for H0: C belongs to P(C_null), eq. (2.15)-(2.17)
#'
#' `xi = T d' A' [Omega^{-1} 0; 0 0] A d` with `d = vec(C_hat) - vec(C_0T)` and
#' `C_0T` the element of `P(C_null)` closest to `C_hat` — the paper's second
#' testing method, which needs a single statistic. Asymptotically
#' `chi^2(n(n-1)/2)` under H0.
#'
#' Because `V` from `gmr_asympt_cov` is singular, this must be built from `A`
#' and `Omega`, never as `d' V^{-1} d`.
#'
#' @param C_hat Estimated orthogonal matrix.
#' @param C_null Matrix whose permutation/sign class is the null (e.g. `diag(n)`
#'   for the recursive/Cholesky scheme).
#' @param A,Omega From `gmr_asympt_cov`.
#' @param T_eff Sample size used in estimation.
#' @return List with `xi`, `df`, `p_value` and the matched `C_0T`.
gmr_wald <- function(C_hat, C_null, A, Omega, T_eff) {
  n  <- nrow(C_hat)
  df <- n * (n - 1) / 2
  C0 <- match_columns(C_hat, C_null)$C          # closest element of P(C_null)
  d  <- as.vector(C_hat) - as.vector(C0)

  W <- matrix(0, n^2, n^2)
  W[seq_len(df), seq_len(df)] <- solve(Omega)
  xi <- T_eff * drop(crossprod(d, crossprod(A, W %*% (A %*% d))))

  list(xi = xi, df = df, p_value = stats::pchisq(xi, df, lower.tail = FALSE),
       C_0T = C0)
}

#' Wald statistic for a single column direction
#'
#' Tests `H0: c_j = h` for a given unit vector `h` — used to test whether the
#' external instrument's impact direction coincides with the ICA column labelled
#' as monetary policy. This is an adaptation of §2.5, not a statistic stated in
#' the paper: the restriction touches one column only, so the quadratic form is
#' taken on the corresponding block of `V` with a Moore-Penrose inverse, and the
#' degrees of freedom are `n - 1` (a unit vector on the sphere has `n - 1` free
#' coordinates).
#'
#' @param C_hat Estimated orthogonal matrix.
#' @param j Index of the column under test.
#' @param h Hypothesized unit-norm direction, length `n`.
#' @param V Asymptotic covariance of `vec(C_hat)` from `gmr_asympt_cov`.
#' @param tol Relative tolerance for the pseudo-inverse rank cut.
gmr_wald_column <- function(C_hat, j, h, V, tol = 1e-8) {
  n  <- nrow(C_hat)
  h  <- h / sqrt(sum(h^2))
  if (sum((C_hat[, j] - h)^2) > sum((C_hat[, j] + h)^2)) h <- -h  # sign is free
  blk <- ((j - 1) * n + 1):(j * n)
  Vj  <- V[blk, blk, drop = FALSE]
  d   <- C_hat[, j] - h

  e   <- eigen((Vj + t(Vj)) / 2, symmetric = TRUE)
  keep <- e$values > tol * max(e$values)
  Vinv <- if (!any(keep)) matrix(0, n, n) else
    e$vectors[, keep, drop = FALSE] %*%
    diag(1 / e$values[keep], sum(keep)) %*%
    t(e$vectors[, keep, drop = FALSE])

  xi <- drop(crossprod(d, Vinv %*% d))
  df <- min(sum(keep), n - 1)
  list(xi = xi, df = df, p_value = stats::pchisq(xi, df, lower.tail = FALSE),
       rank_used = sum(keep), h = h)
}

# ---------------------------------------------------------------------------
# Labelling: permutation and sign
# ---------------------------------------------------------------------------

#' Align the columns of one orthogonal matrix to a reference
#'
#' `C` is identified only up to `P(C)` — permutation and sign of its columns
#' (Comon 1994 / Eriksson-Koivunen 2004). Every comparison across estimates
#' (bootstrap replications, multi-start optima, a null matrix) therefore has to
#' pick the element of `P(C_new)` closest to the reference first.
#'
#' `IdSS::find.permut` enumerates all `n! 2^n` candidates — 46,080 at n = 6, per
#' call. Since `C_ref` and `C_new` are both orthogonal, maximizing
#' `sum_j |c_ref,j' c_new,perm(j)|` is a linear assignment problem on
#' `|C_ref' C_new|`; it is solved here greedily on the largest remaining entry,
#' which is exact whenever the matching is unambiguous and degrades gracefully
#' when it is not. Cross-checked against `find.permut` at n = 3 in
#' `script/validate_gmr_ica.R`.
#'
#' @param C_ref Reference orthogonal matrix.
#' @param C_new Matrix to be permuted and sign-flipped.
#' @return List with the aligned `C`, the `perm` applied (`C = C_new[, perm]`
#'   up to sign) and the `signs`.
match_columns <- function(C_ref, C_new) {
  n  <- ncol(C_ref)
  S  <- crossprod(C_ref, C_new)      # S[j, k] = <c_ref_j, c_new_k>
  A  <- abs(S)
  perm  <- integer(n)
  signs <- numeric(n)
  for (step in seq_len(n)) {
    pos <- which.max(A)
    j   <- ((pos - 1L) %% n) + 1L    # reference column
    k   <- ((pos - 1L) %/% n) + 1L   # new column
    perm[j]  <- k
    signs[j] <- if (S[j, k] >= 0) 1 else -1
    A[j, ] <- -Inf
    A[, k] <- -Inf
  }
  list(C = C_new[, perm, drop = FALSE] * rep(signs, each = n),
       perm = perm, signs = signs)
}

#' Cosine alignment between two impact directions
#'
#' Sign-invariant, so it measures label switching rather than orientation.
#' @param b1,b2 Numeric vectors.
cos_align <- function(b1, b2) {
  d <- sqrt(sum(b1^2) * sum(b2^2))
  if (d == 0) return(NA_real_)
  abs(sum(b1 * b2)) / d
}

#' Stability of one column across a set of aligned estimates
#'
#' When some sources are near-Gaussian the objective has a near-flat ridge and
#' different starts land on different matrices. The identified content may
#' still include the column of interest, so stability has to be asked per
#' column, not of `C` as a whole.
#'
#' @param all_C List of orthogonal matrices, already column-aligned to a common
#'   reference (as returned by `estim_ica_pml`).
#' @param j Column index.
#' @param ref Reference matrix; defaults to the first element of `all_C`.
#' @return List with `max_dev` (worst sup-norm deviation of column `j`),
#'   `min_cos` (worst cosine alignment) and `n`.
column_stability <- function(all_C, j, ref = NULL) {
  if (length(all_C) == 0) return(list(max_dev = NA_real_, min_cos = NA_real_, n = 0))
  if (is.null(ref)) ref <- all_C[[1]]
  devs <- vapply(all_C, function(Cj) max(abs(Cj[, j] - ref[, j])), numeric(1))
  coss <- vapply(all_C, function(Cj) cos_align(Cj[, j], ref[, j]), numeric(1))
  list(max_dev = max(devs), min_cos = min(coss), n = length(all_C))
}

#' Label the monetary column by correlation with an external proxy
#'
#' The proxy does not identify here — it only names a column that ICA has
#' already pinned down. Returns the ranking so the caller can report how sharp
#' the labelling is: a small gap between the best and second-best correlation
#' means the name, not the estimate, is fragile.
#'
#' @param eps `T x n` estimated structural shocks (rows aligned to `z`).
#' @param z Instrument vector of the same length.
#' @return List with `col`, `cor_abs` (all components), `best`, `second` and
#'   `gap`.
label_by_proxy <- function(eps, z) {
  cr <- abs(as.vector(stats::cor(eps, z)))
  o  <- order(cr, decreasing = TRUE)
  list(col = o[1], cor_abs = cr, best = cr[o[1]],
       second = if (length(cr) > 1) cr[o[2]] else NA_real_,
       gap = if (length(cr) > 1) cr[o[1]] - cr[o[2]] else NA_real_)
}
