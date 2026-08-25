# ===================================================================
# WEAK-INSTRUMENT-ROBUST INFERENCE FOR THE PROXY-SVAR
# Anderson-Rubin confidence sets by test inversion
# Montiel Olea, Stock & Watson (2021, J. Econometrics)
#
# *** SCOPE: VAR IN OBSERVABLES. DO NOT APPLY TO THE DFM. ***
#
# The Anderson--Rubin path was removed from the DFM on 2026-08-12 for two
# reasons (registro/historico_decisoes.md section 7). The first remains: the
# plug-in covariance conditioned on estimated factors, loadings, and scales,
# without a theory covering those generated objects. That problem does not
# exist in a VAR of observables. There are no generated regressors, and
# (vec(A), Gamma) are the only estimated objects, exactly the pair WHat covers.
#
# This module therefore does not restore the Load/Inner/d0 generalisation from
# the removed code, which allowed it to target factor space. Its interface
# accepts a coordinate selector (`nvar`), making DFM misuse impossible by
# construction rather than convention. See CLAUDE.md, "What the paper may not
# claim".
#
# Sources in the authors' official code (codigos_externos/codigo_olea/,
# github.com/jm4474/SVARIV), read-only and gitignored:
#
#   functions/StructuralIRF/MARep.m           -> mosw_marep
#   functions/RForm/Gmatrices.m               -> mosw_response_derivatives
#   functions/RForm/CovAhat_Sigmahat_Gamma.m  -> mosw_rform_cov
#   functions/RForm/NW_hac_STATA.m            -> o kernel dentro de mosw_rform_cov
#   functions/Inference/MSWfunction.m         -> mosw_ar_bounds
#
# Difference from MATLAB: `solve_quadratic_le_zero()`. The classifier at
# MSWfunction.m:119-151 uses strict inequalities without a tolerance. Thus,
# a=0 (linear), a=b=0 (constant), and Delta=0 all fall into the residual
# "whole line" branch. The removed module had the same defect, which the
# external audit classified as an API logic error
# (pareceres/2026-08-12_auditoria_anderson_rubin_dfm.md, section 7). This
# implementation solves every branch with a tolerance relative to coefficient
# scale.
# ===================================================================


#' Solve the quadratic inequality `a x^2 + b x + c <= 0` completely
#'
#' Vectorised over `a`, `b`, `c`. Covers every degenerate branch that
#' `MSWfunction.m` sends to its residual "whole line" case: the linear case
#' (`a = 0`), the constant case (`a = b = 0`), the tangency case
#' (`Delta = 0`) and near-degeneracies, which are decided by a tolerance
#' relative to the scale of the coefficients rather than by an exact
#' comparison against zero.
#'
#' Roots use the cancellation-safe form `q = -(b + sign(b) sqrt(Delta))/2`,
#' `x1 = q/a`, `x2 = c/q`, which avoids losing precision when `b^2 >> 4ac`.
#'
#' @param a,b,c Numeric vectors of equal length (or scalars, recycled).
#' @param tol_rel Relative tolerance. `1e-12` matches the oracle the external
#'   audit used to refute the previous classifier.
#'
#' @return List with `type` (character), `lo`, `hi` and `casedummy`:
#'   `interval` [lo, hi] (1), `two_rays` (-Inf, lo] U [hi, Inf) (2),
#'   `empty` (3), `real_line` (4), `singleton` {lo} (5),
#'   `half_line_left` (-Inf, hi] (6), `half_line_right` [lo, Inf) (7).
#'   Codes 1-4 coincide with MOSW's `casedummy`; 5-7 have no MOSW
#'   counterpart because MOSW never reach those branches.
solve_quadratic_le_zero <- function(a, b, c, tol_rel = 1e-12) {
  n <- max(length(a), length(b), length(c))
  a <- rep_len(as.numeric(a), n)
  b <- rep_len(as.numeric(b), n)
  c <- rep_len(as.numeric(c), n)

  if (any(!is.finite(a)) || any(!is.finite(b)) || any(!is.finite(c))) {
    stop("solve_quadratic_le_zero: coefficients must be finite")
  }
  if (!is.finite(tol_rel) || tol_rel <= 0) {
    stop("tol_rel must be positive and finite")
  }

  coef_scale <- pmax(abs(a), abs(b), abs(c), .Machine$double.xmin)
  tol   <- tol_rel * coef_scale
  Delta <- b^2 - 4 * a * c
  delta_scale <- pmax(b^2, abs(4 * a * c), .Machine$double.xmin)
  tol_d <- tol_rel * delta_scale

  type <- character(n)
  lo   <- rep(NA_real_, n)
  hi   <- rep(NA_real_, n)

  # --- Degenerate in the quadratic term: linear or constant -------------
  deg <- abs(a) <= tol

  const <- deg & abs(b) <= tol
  type[const & c <=  tol] <- "real_line"
  type[const & c >   tol] <- "empty"

  lin_pos <- deg & b >  tol                       # b x <= -c  =>  x <= -c/b
  type[lin_pos] <- "half_line_left"
  hi[lin_pos]   <- -c[lin_pos] / b[lin_pos]

  lin_neg <- deg & b < -tol                       # b x <= -c  =>  x >= -c/b
  type[lin_neg] <- "half_line_right"
  lo[lin_neg]   <- -c[lin_neg] / b[lin_neg]

  # --- Genuine quadratic ------------------------------------------------
  quad <- !deg
  up   <- quad & a >  0                           # opens upward
  dn   <- quad & a <  0                           # opens downward

  tang <- quad & abs(Delta) <= tol_d
  type[up & tang] <- "singleton"
  lo[up & tang]   <- -b[up & tang] / (2 * a[up & tang])
  hi[up & tang]   <- lo[up & tang]
  type[dn & tang] <- "real_line"                  # complement of one point

  type[up & !tang & Delta < 0] <- "empty"
  type[dn & !tang & Delta < 0] <- "real_line"

  two <- quad & !tang & Delta > 0
  if (any(two)) {
    sq <- sqrt(Delta[two])
    bb <- b[two]
    sgn <- ifelse(bb >= 0, 1, -1)                 # sign(0) := +1
    q  <- -(bb + sgn * sq) / 2
    x1 <- q / a[two]
    x2 <- c[two] / q
    lo[two] <- pmin(x1, x2)
    hi[two] <- pmax(x1, x2)
    # Upward: inside the roots. Downward: outside them. Either way `lo` is
    # the smaller root, which is also MOSW's MSWlbound in both branches.
    type[two] <- ifelse(a[two] > 0, "interval", "two_rays")
  }

  if (any(type == "")) stop("solve_quadratic_le_zero: unclassified case")

  lo[type == "real_line"]      <- -Inf
  hi[type == "real_line"]      <-  Inf
  lo[type == "half_line_left"] <- -Inf
  hi[type == "half_line_right"] <- Inf

  code <- c(interval = 1L, two_rays = 2L, empty = 3L, real_line = 4L,
            singleton = 5L, half_line_left = 6L, half_line_right = 7L)

  list(type = type, lo = lo, hi = hi, casedummy = unname(code[type]))
}


#' MA representation of a reduced-form VAR (`MARep.m`)
#'
#' @param AL `n x (n*p)` reduced-form coefficients, blocks ordered lag 1..p.
#' @param p Lag order.
#' @param h Maximum horizon.
#'
#' @return `n x n x (h+1)` array with `C[, , 1] = I`.
mosw_marep <- function(AL, p, h) {
  AL <- as.matrix(AL)
  n  <- nrow(AL)
  if (ncol(AL) != n * p) stop("AL must be n x (n*p)")

  companion <- if (p == 1) AL else {
    rbind(AL, cbind(diag(n * (p - 1)), matrix(0, n * (p - 1), n)))
  }

  C    <- array(0, dim = c(n, n, h + 1))
  Apow <- diag(n * p)
  for (i in seq_len(h + 1)) {
    C[, , i] <- Apow[seq_len(n), seq_len(n), drop = FALSE]
    Apow     <- Apow %*% companion
  }
  C
}


#' Compute the SVAR-IV impact vector and impulse responses
#'
#' Translates the horizon-specific branch of `IRFSVARIV.m`. The single impact
#' vector is `scale * Gamma / Gamma[norm]`, and every response is `C_h B1`.
#'
#' @param AL `n x (n*p)` reduced-form coefficients.
#' @param Sigma `n x n` reduced-form covariance matrix.
#' @param Gamma Length-`n` vector `E[z_t eta_t]`.
#' @param h Maximum horizon.
#' @param scale Impact imposed on the normalisation variable.
#' @param norm Index of the normalisation variable.
#'
#' @return List with `C`, `B1`, `point`, and the normalising covariance `den`.
#'
#' @examples
#' result <- mosw_svar_iv(AL, Sigma, Gamma, h = 20L, scale = 1, norm = 1L)
mosw_svar_iv <- function(AL, Sigma, Gamma, h, scale, norm) {
  AL <- as.matrix(AL)
  Sigma <- as.matrix(Sigma)
  Gamma <- as.numeric(Gamma)
  n <- nrow(AL)
  p <- ncol(AL) / n

  if (nrow(Sigma) != n || ncol(Sigma) != n || length(Gamma) != n) {
    stop("AL, Sigma, and Gamma have incompatible dimensions")
  }
  if (p != as.integer(p) || p < 1L) stop("AL must contain complete lag blocks")
  if (norm < 1L || norm > n || !is.finite(Gamma[norm]) || Gamma[norm] == 0) {
    stop("The normalising covariance must be finite and nonzero")
  }

  C <- mosw_marep(AL, as.integer(p), h)
  B1 <- Gamma / Gamma[norm] * scale
  B1[norm] <- scale
  point <- vapply(
    seq_len(h + 1L),
    function(i) drop(C[, , i] %*% B1),
    numeric(n)
  )

  list(C = C, B1 = B1, point = point, den = Gamma[norm])
}


#' Response matrices and the derivative of the IRF numerator wrt vec(A)
#'
#' `G_h = d vec(C_h) / d vec(A)'` is never materialised. By the Lutkepohl
#' formula that `Gmatrices.m` implements, `G_h = sum_{m=0}^{h-1} P_{h-1-m} %x% C_m`
#' with `P_j = (A_c^j J')'`, and the product actually needed collapses through
#' `(x' %x% y')(P %x% Q) = (x'P) %x% (y'Q)`:
#'
#'   `d1_{j,h} = sum_{m=0}^{h-1} (Gamma' P_{h-1-m}) %x% (e_j' C_m)`
#'
#' which avoids the `AJaux` array of the MATLAB (hundreds of MB here).
#'
#' @param AL `n x (n*p)` reduced-form coefficients.
#' @param p Lag order.
#' @param h Maximum horizon.
#' @param Gamma Length-`n` vector `E[z_t eta_t]`.
#'
#' @return List with `C` (`n x n x (h+1)`) and `D1`
#'   (`n x (n^2*p) x (h+1)`). `D1[, , 1] = 0`: at impact `C_0 = I` does not
#'   depend on `A`.
mosw_response_derivatives <- function(AL, p, h, Gamma) {
  AL <- as.matrix(AL)
  n  <- nrow(AL)
  if (ncol(AL) != n * p) stop("AL must be n x (n*p)")
  if (length(Gamma) != n) stop("Gamma must have length ", n)

  companion <- if (p == 1) AL else {
    rbind(AL, cbind(diag(n * (p - 1)), matrix(0, n * (p - 1), n)))
  }

  C    <- array(0, dim = c(n, n, h + 1))
  P    <- vector("list", h + 1)
  Apow <- diag(n * p)
  for (i in seq_len(h + 1)) {
    C[, , i] <- Apow[seq_len(n), seq_len(n), drop = FALSE]
    P[[i]]   <- t(Apow[, seq_len(n), drop = FALSE])   # n x (n*p)
    Apow     <- Apow %*% companion
  }

  gP <- lapply(P, function(Pj) matrix(drop(crossprod(Gamma, Pj)), nrow = 1))

  D1 <- array(0, dim = c(n, n * n * p, h + 1))
  for (i in seq_len(h + 1)) {
    for (m in seq_len(i - 1)) {
      D1[, , i] <- D1[, , i] + kronecker(gP[[i - m]], C[, , m, drop = TRUE])
    }
  }

  list(C = C, D1 = D1)
}


#' Asymptotic covariance of (vec(A), Gamma) — `CovAhat_Sigmahat_Gamma.m`
#'
#' Implements the complete moment vector and selector matrix in
#' `CovAhat_Sigmahat_Gamma.m`, including the intermediate `vech(Sigma)` block.
#' The returned `WHat` retains the `(vec(A), Gamma)` rows and columns consumed
#' by `MSWfunction.m`.
#'
#' @param X `T x (m + n*p)` VAR regressors with the `m` deterministic columns
#'   first and the lags after, as returned by `olea_rform_var()`.
#' @param Z Instrument, length-`T` vector or `T x k` matrix.
#' @param eta `n x T` VAR residuals, as returned by `olea_rform_var()`.
#' @param p Lag order.
#' @param nw_lags Newey-West truncation. `0` is Eicker-White and reproduces
#'   `NWlags = 0` of the oil application.
#'
#' @return List with `W1`, `W12`, `W2`, `WHataux`, `WHat`, `Gamma`, `T_eff`,
#'   and `hac_dim`.
mosw_rform_cov <- function(X, Z, eta, p, nw_lags = 0L) {
  X <- as.matrix(X)
  Z <- as.matrix(Z)
  eta <- as.matrix(eta)

  T_eff <- ncol(eta)
  n <- nrow(eta)
  d_x <- ncol(X)
  k <- ncol(Z)
  m <- d_x - n * p

  if (m < 0) stop("X has fewer columns (", d_x, ") than n*p (", n * p, ")")
  if (nrow(X) != T_eff || nrow(Z) != T_eff) {
    stop("X and Z must have the same T observations as eta")
  }
  nw_lags <- as.integer(nw_lags)
  if (is.na(nw_lags) || nw_lags < 0L || nw_lags >= T_eff) {
    stop("nw_lags must be an integer in [0, T)")
  }

  eta_t <- t(eta)
  moment_data <- cbind(X, eta_t, Z)
  G_mom <- do.call(
    cbind,
    lapply(seq_len(ncol(moment_data)), function(j) moment_data[, j] * eta_t)
  )

  hac_dim <- ncol(G_mom)
  if (hac_dim >= T_eff) {
    stop("HAC moment dimension is ", hac_dim, " >= T = ", T_eff,
         ": WHat is singular. Reduce p or n.")
  }

  V <- sweep(G_mom, 2, colMeans(G_mom))

  # Bartlett HAC sum, NW_hac_STATA.m: weight 1 - l/(lags+1), divisor T.
  S <- crossprod(V) / T_eff
  for (l in seq_len(nw_lags)) {
    Gl <- crossprod(V[seq_len(T_eff - l), , drop = FALSE],
                    V[(1L + l):T_eff, , drop = FALSE]) / T_eff
    S  <- S + (1 - l / (nw_lags + 1)) * (Gl + t(Gl))
  }

  Q1 <- crossprod(X) / T_eff
  Q1inv <- solve(Q1)
  Q2 <- crossprod(Z, X) / T_eff
  sel_lag <- Q1inv[(m + 1):d_x, , drop = FALSE]   # [0 I_np] Q1^-1

  I_n <- diag(n)
  V_select <- do.call(
    rbind,
    lapply(seq_len(n), function(i) {
      kronecker(I_n[i, , drop = FALSE], I_n[i:n, , drop = FALSE])
    })
  )
  n_a <- n^2 * p
  n_s <- n * (n + 1L) / 2L
  n_g <- n * k
  raw_ax <- n * d_x
  raw_s <- n^2

  Shat <- rbind(
    cbind(
      kronecker(sel_lag, I_n),
      matrix(0, nrow = n_a, ncol = raw_s + n_g)
    ),
    cbind(
      matrix(0, nrow = n_s, ncol = raw_ax),
      V_select,
      matrix(0, nrow = n_s, ncol = n_g)
    ),
    cbind(
      -kronecker(Q2 %*% Q1inv, I_n),
      matrix(0, nrow = n_g, ncol = raw_s),
      diag(n_g)
    )
  )

  WHataux <- Shat %*% S %*% t(Shat)

  idx_a <- seq_len(n_a)
  idx_g <- n_a + n_s + seq_len(n_g)
  WHat <- rbind(
    cbind(WHataux[idx_a, idx_a, drop = FALSE],
          WHataux[idx_a, idx_g, drop = FALSE]),
    cbind(WHataux[idx_g, idx_a, drop = FALSE],
          WHataux[idx_g, idx_g, drop = FALSE])
  )
  idx_g_what <- n_a + seq_len(n_g)

  list(W1      = WHat[idx_a, idx_a, drop = FALSE],
       W12     = WHat[idx_a, idx_g_what, drop = FALSE],
       W2      = WHat[idx_g_what, idx_g_what, drop = FALSE],
       WHataux = WHataux,
       WHat    = WHat,
       Gamma   = drop(eta %*% Z / T_eff),
       T_eff   = T_eff,
       hac_dim = hac_dim)
}


#' Anderson-Rubin confidence set for the proxy-SVAR IRF, by test inversion
#'
#' Port of `MSWfunction.m` sections 4-7. For every (variable j, horizon h) it
#' solves in lambda the quadratic inequality `ahat lambda^2 + bhat lambda + chat <= 0`,
#' which is the inverted AR test of `H0: IRF_{j,h} = lambda`, and classifies the
#' solution with `solve_quadratic_le_zero()` — not with MOSW's strict-inequality
#' cascade, which mishandles every degenerate branch.
#'
#' `ahat = T den^2 - critval W2[nvar, nvar]` does not vary across cells, so the
#' set is bounded **iff** the Wald in the normalisation direction (the project's
#' xi_mp) exceeds `critval`. That is the `ar_bounded` flag already tabulated in
#' `output/instrument/mosw_strength_grid.csv`.
#'
#' @param deriv List returned by `mosw_response_derivatives()`.
#' @param cov List returned by `mosw_rform_cov()`.
#' @param nvar Index of the normalisation variable.
#' @param scale Impact response imposed on `nvar`, in its native units.
#' @param confidence Confidence level, e.g. 0.95.
#'
#' @return List of `n x (h+1)` matrices `point`, `ahat`, `bhat`, `chat`,
#'   `Delta`, `casedummy`, `set_type`, `lo`, `hi`, `dm_lo`, `dm_hi`, `dm_se`,
#'   plus scalars `critval`, `den`, `xi_den`.
mosw_ar_bounds <- function(deriv, cov, nvar, scale, confidence) {
  C <- deriv$C
  D1 <- deriv$D1

  n_out <- dim(C)[1]
  n_h   <- dim(C)[3]
  n_a   <- dim(D1)[2]

  Gamma   <- cov$Gamma
  T_eff   <- cov$T_eff
  critval <- qnorm(1 - (1 - confidence) / 2)^2

  if (nvar < 1L || nvar > n_out) stop("nvar is out of range")

  den   <- Gamma[nvar]
  w_den <- cov$W2[nvar, nvar]

  # Stack the n_out*(h+1) cells as rows so every quadratic form is one pass.
  Dg <- scale * matrix(aperm(C,  c(1, 3, 2)), nrow = n_out * n_h, ncol = n_out)
  Da <- scale * matrix(aperm(D1, c(1, 3, 2)), nrow = n_out * n_h, ncol = n_a)

  num   <- drop(Dg %*% Gamma)
  W2d0  <- cov$W2[, nvar]
  W12d0 <- cov$W12[, nvar]

  q_aa <- rowSums((Da %*% cov$W1)  * Da)
  q_ag <- rowSums((Da %*% cov$W12) * Dg)
  q_gg <- rowSums((Dg %*% cov$W2)  * Dg)

  ahat <- rep(T_eff * den^2 - critval * w_den, length(num))
  bhat <- -2 * T_eff * num * den +
    2 * critval * drop(Da %*% W12d0) +
    2 * critval * drop(Dg %*% W2d0)
  chat <- T_eff * num^2 - critval * (q_aa + 2 * q_ag + q_gg)

  sol <- solve_quadratic_le_zero(ahat, bhat, chat)

  point <- num / den
  point[nvar] <- scale
  sol$type[nvar] <- "singleton"
  sol$lo[nvar] <- scale
  sol$hi[nvar] <- scale
  sol$casedummy[nvar] <- 5L

  # Delta method (MSWfunction.m section 6): d = [d1, dGamma - lambda*e_nvar].
  e_nvar <- numeric(n_out)
  e_nvar[nvar] <- 1
  Dd     <- cbind(Da, Dg - outer(point, e_nvar))
  dm_var <- rowSums((Dd %*% cov$WHat) * Dd)
  dm_se  <- sqrt(pmax(dm_var, 0)) / (sqrt(T_eff) * abs(den))

  as_mat <- function(v) matrix(v, nrow = n_out, ncol = n_h)

  list(point     = as_mat(point),
       ahat      = as_mat(ahat),
       bhat      = as_mat(bhat),
       chat      = as_mat(chat),
       Delta     = as_mat(bhat^2 - 4 * ahat * chat),
       casedummy = as_mat(sol$casedummy),
       set_type  = matrix(sol$type, nrow = n_out, ncol = n_h),
       lo        = as_mat(sol$lo),
       hi        = as_mat(sol$hi),
       dm_lo     = as_mat(point - sqrt(critval) * dm_se),
       dm_hi     = as_mat(point + sqrt(critval) * dm_se),
       dm_se     = as_mat(dm_se),
       critval   = critval,
       den       = den,
       xi_den    = T_eff * den^2 / w_den)
}


#' Does the AR set reject `H0: IRF <= 0`?
#'
#' One-sided reading of the two-sided set: `H0` is rejected when the whole set
#' lies in the open positive half-line. Sets that contain `-Inf` — `two_rays`,
#' `real_line`, `half_line_left` — never reject, by construction. An `empty`
#' set rejects every value of lambda, including the positive ones, so it is
#' NOT evidence for a positive response and is reported as `NA`.
#'
#' @param set_type Character matrix from `mosw_ar_bounds()`.
#' @param lo Lower-bound matrix from `mosw_ar_bounds()`.
#'
#' @return Logical matrix of the same shape, `NA` where the set is empty.
ar_rejects_le_zero <- function(set_type, lo) {
  out <- set_type %in% c("interval", "singleton", "half_line_right") & lo > 0
  out[set_type == "empty"] <- NA
  matrix(out, nrow = nrow(set_type), ncol = ncol(set_type))
}
