# ===================================================================
# Weak-instrument-robust inference for the proxy-SVAR: Anderson-Rubin
# confidence sets by test inversion (Montiel Olea, Stock & Watson 2021,
# J. Econometrics), for the observable VAR and for the DFM.
#
# In a static DFM the dynamics are a VAR in the r factors with a linear
# measurement equation attached, and the identified response is again a
# ratio of two linear forms in Gamma:
#
#     lambda_{j,h} = scale * (e_j' C_h Gamma) / (d0' Gamma),
#     C_h = diag(sy) Lambda B_h K K',   d0 = C_0' e_mp,
#
# with B_h the upper-left r x r block of the companion raised to h.
# Fieller's logic carries over whole: the coordinate vector e_nvar (which
# picks one entry of Gamma) becomes the general vector d0 (which combines
# all of them), and the pair (Gamma, e_j) inside the Kronecker becomes
# (Inner %*% Gamma, sy_j Lambda_j). With Load = Inner = I every function
# below falls back exactly on the original MOSW, which is what keeps
# script/validation/validate_mosw_ar.R valid against the authors' oil
# application. In the DFM the plug-in covariance conditions on the
# estimated factors, loadings and scales.
#
# Sources in the authors' official code (codigos_externos/codigo_olea/,
# github.com/jm4474/SVARIV), read-only and gitignored:
#
#   functions/StructuralIRF/MARep.m           -> mosw_marep
#   functions/RForm/Gmatrices.m               -> mosw_response_derivatives
#   functions/RForm/CovAhat_Sigmahat_Gamma.m  -> mosw_rform_cov
#   functions/RForm/NW_hac_STATA.m            -> the kernel in mosw_rform_cov
#   functions/Inference/MSWfunction.m         -> mosw_ar_bounds
#
# Difference from MATLAB: solve_quadratic_le_zero(). The classifier at
# MSWfunction.m:119-151 uses strict inequalities without a tolerance, so
# a = 0 (linear), a = b = 0 (constant) and Delta = 0 all fall into its
# residual "whole line" branch, which the external audit classified as an
# API logic error (pareceres/2026-08-12_auditoria_anderson_rubin_dfm.md,
# section 7). This implementation solves every branch with a tolerance
# relative to the scale of the coefficients.
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
  # An infinite coefficient passes every tolerance test and would come back
  # classified, silently, as the real line
  if (any(!is.finite(a)) || any(!is.finite(b)) || any(!is.finite(c))) {
    stop("solve_quadratic_le_zero: coefficients must be finite")
  }

  coef_scale <- pmax(abs(a), abs(b), abs(c), .Machine$double.xmin)
  tol <- tol_rel * coef_scale
  Delta <- b^2 - 4 * a * c
  delta_scale <- pmax(b^2, abs(4 * a * c), .Machine$double.xmin)
  tol_delta <- tol_rel * delta_scale

  type <- character(n)
  lo <- rep(NA_real_, n)
  hi <- rep(NA_real_, n)

  # Degenerate in the quadratic term: constant, or linear b x <= -c
  degenerate <- abs(a) <= tol
  constant <- degenerate & abs(b) <= tol
  type[constant & c <= tol] <- "real_line"
  type[constant & c > tol] <- "empty"

  rising <- degenerate & b > tol                  # x <= -c/b
  type[rising] <- "half_line_left"
  hi[rising] <- -c[rising] / b[rising]

  falling <- degenerate & b < -tol                # x >= -c/b
  type[falling] <- "half_line_right"
  lo[falling] <- -c[falling] / b[falling]

  # Genuine quadratic
  quadratic <- !degenerate
  opens_up <- quadratic & a > 0
  opens_down <- quadratic & a < 0

  tangent <- quadratic & abs(Delta) <= tol_delta
  type[opens_up & tangent] <- "singleton"
  lo[opens_up & tangent] <- -b[opens_up & tangent] /
    (2 * a[opens_up & tangent])
  hi[opens_up & tangent] <- lo[opens_up & tangent]
  type[opens_down & tangent] <- "real_line"       # complement of one point

  type[opens_up & !tangent & Delta < 0] <- "empty"
  type[opens_down & !tangent & Delta < 0] <- "real_line"

  two_roots <- quadratic & !tangent & Delta > 0
  b_two <- b[two_roots]
  sign_b <- dplyr::if_else(b_two >= 0, 1, -1)     # sign(0) := +1
  q <- -(b_two + sign_b * sqrt(Delta[two_roots])) / 2
  x1 <- q / a[two_roots]
  x2 <- c[two_roots] / q
  lo[two_roots] <- pmin(x1, x2)
  hi[two_roots] <- pmax(x1, x2)
  # Upward: inside the roots. Downward: outside them. Either way `lo` is the
  # smaller root, which is also MOSW's MSWlbound in both branches.
  type[two_roots] <- dplyr::if_else(
    a[two_roots] > 0,
    "interval",
    "two_rays"
  )

  lo[type == "real_line"] <- -Inf
  hi[type == "real_line"] <- Inf
  lo[type == "half_line_left"] <- -Inf
  hi[type == "half_line_right"] <- Inf

  casedummy <- c(
    interval = 1L, two_rays = 2L, empty = 3L, real_line = 4L,
    singleton = 5L, half_line_left = 6L, half_line_right = 7L
  )
  list(type = type, lo = lo, hi = hi, casedummy = unname(casedummy[type]))
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
  n <- nrow(AL)
  companion <- if (p == 1) {
    AL
  } else {
    rbind(AL, cbind(diag(n * (p - 1)), matrix(0, n * (p - 1), n)))
  }

  # C_h is the upper-left n x n block of companion^h, and
  # companion^h = companion^(h-1) companion
  C <- array(0, dim = c(n, n, h + 1))
  companion_power <- diag(n * p)
  for (horizon in 0:h) {
    C[, , horizon + 1] <- companion_power[seq_len(n), seq_len(n), drop = FALSE]
    companion_power <- companion_power %*% companion
  }
  C
}


#' Compute the SVAR-IV impact vector and impulse responses
#'
#' Translates the horizon-specific branch of `IRFSVARIV.m`. The single impact
#' vector is `scale * Gamma / Gamma[norm]`, and every response is `C_h B1`.
#'
#' @param AL `n x (n*p)` reduced-form coefficients.
#' @param Sigma `n x n` reduced-form covariance matrix. The point estimate
#'   does not use it; it stays so the call mirrors `IRFSVARIV.m`.
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
  Gamma <- as.numeric(Gamma)
  # A zero normalising covariance would divide into Inf without an error
  if (!is.finite(Gamma[norm]) || Gamma[norm] == 0) {
    stop("The normalising covariance must be finite and nonzero")
  }

  C <- mosw_marep(AL, ncol(AL) / nrow(AL), h)
  B1 <- Gamma / Gamma[norm] * scale
  B1[norm] <- scale
  point <- apply(C, 3, \(C_h) C_h %*% B1)

  list(C = C, B1 = B1, point = point, den = Gamma[norm])
}


#' Response matrices and the derivative of the IRF numerator wrt vec(A)
#'
#' `G_h = d vec(C_h) / d vec(A)'` is never materialised. By the Lutkepohl
#' formula that `Gmatrices.m` implements,
#' `G_h = sum_{m=0}^{h-1} P_{h-1-m} %x% C_m` with `P_j = (A_c^j J')'`, and
#' the product actually needed collapses through
#' `(x' %x% y')(P %x% Q) = (x'P) %x% (y'Q)`:
#'
#'   `d1_{j,h} = sum_{m=0}^{h-1} (gamma' P_{h-1-m}) %x% (a_j' B_m)`
#'
#' which avoids the `AJaux` array of the MATLAB (hundreds of MB here). Here
#' `gamma = Inner %*% Gamma` and `a_j` is row `j` of `Load`; with
#' `Load = Inner = I` this is MOSW's own expression with `a_j' B_m = e_j' C_m`.
#'
#' `Load` and `Inner` are what lets the same inversion target a DFM: the
#' identified response of observable `j` is `sy_j Lambda_j' B_h K K' Gamma`, so
#' `Load = diag(sy) Lambda` carries the measurement equation and `Inner = K K'`
#' the projection onto the dynamic-shock space. When `q = r`, `K K' = I` and
#' `Inner` drops out.
#'
#' @param AL `n x (n*p)` reduced-form coefficients of the *state* VAR.
#' @param p Lag order.
#' @param h Maximum horizon.
#' @param Gamma Length-`n_inn` vector `E[z_t eta_t]`.
#' @param Load `n_out x n` measurement matrix; `diag(n)` by default (VAR case).
#' @param Inner `n x n_inn` projection; `diag(n)` by default (VAR case).
#'
#' @return List with `C` (`n_out x n_inn x (h+1)`), `D1`
#'   (`n_out x (n^2*p) x (h+1)`) and their horizon-cumulated twins `Ccum` and
#'   `D1cum`, needed by transformation codes that accumulate. `D1[, , 1] = 0`:
#'   at impact `B_0 = I` does not depend on `A`.
mosw_response_derivatives <- function(AL, p, h, Gamma, Load = NULL,
                                      Inner = NULL) {
  AL <- as.matrix(AL)
  n <- nrow(AL)
  Load <- if (is.null(Load)) diag(n) else as.matrix(Load)
  Inner <- if (is.null(Inner)) diag(n) else as.matrix(Inner)
  n_out <- nrow(Load)
  n_inn <- ncol(Inner)

  companion <- if (p == 1) {
    AL
  } else {
    rbind(AL, cbind(diag(n * (p - 1)), matrix(0, n * (p - 1), n)))
  }

  # B_h is the upper-left n x n block of companion^h and P_h, n x (n*p), its
  # first n columns transposed; companion^h = companion^(h-1) companion
  B <- vector("list", h + 1)
  P <- vector("list", h + 1)
  companion_power <- diag(n * p)
  for (horizon in 0:h) {
    B[[horizon + 1]] <- companion_power[seq_len(n), seq_len(n), drop = FALSE]
    P[[horizon + 1]] <- t(companion_power[, seq_len(n), drop = FALSE])
    companion_power <- companion_power %*% companion
  }

  gamma_st <- drop(Inner %*% Gamma)
  gP <- purrr::map(P, \(P_j) matrix(drop(crossprod(gamma_st, P_j)), nrow = 1))
  LB <- purrr::map(B, \(B_m) Load %*% B_m)                 # n_out x n

  C <- array(0, dim = c(n_out, n_inn, h + 1))
  D1 <- array(0, dim = c(n_out, n * n * p, h + 1))
  for (horizon in 0:h) {
    C[, , horizon + 1] <- LB[[horizon + 1]] %*% Inner
    # d1_{j,h} = sum_{m=0}^{h-1} (gamma' P_{h-1-m}) %x% (a_j' B_m)
    for (m in seq_len(horizon) - 1) {
      D1[, , horizon + 1] <- D1[, , horizon + 1] +
        kronecker(gP[[horizon - m]], LB[[m + 1]])
    }
  }

  list(
    C = C,
    D1 = D1,
    Ccum = aperm(apply(C, c(1, 2), cumsum), c(2, 3, 1)),
    D1cum = aperm(apply(D1, c(1, 2), cumsum), c(2, 3, 1))
  )
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

  # Row t is vec(eta_t w_t')' with w_t = (x_t', eta_t', z_t')'
  eta_t <- t(eta)
  moment_data <- cbind(X, eta_t, Z)
  moments <- do.call(
    cbind,
    purrr::map(seq_len(ncol(moment_data)), \(j) moment_data[, j] * eta_t)
  )

  # Two conditions, and they do not coincide. The authors' one
  # (CovAhat_Sigmahat_Gamma.m:91-95) is on the *parameter* dimension and is the
  # necessary one, because rank(WHat) <= min(par_dim, T-1). The moment-dimension
  # one is sufficient and strictly stronger — 135 against 120 in the production
  # shape — and is this project's safeguard, not a result of the paper. Blocking
  # on the stronger one is deliberate; both bar the same two cells.
  par_dim <- n^2 * p + n * (n + 1L) / 2L + n * k
  if (par_dim >= T_eff) {
    stop("Parameter dimension is ", par_dim, " >= T = ", T_eff,
         " (the authors' condition, CovAhat_Sigmahat_Gamma.m:91-95): ",
         "WHat is singular. Reduce p or n.")
  }

  hac_dim <- ncol(moments)
  if (hac_dim >= T_eff) {
    stop("HAC moment dimension is ", hac_dim, " >= T = ", T_eff,
         " (this project's safeguard, stricter than the authors' ",
         par_dim, " < T): the HAC sum is rank-deficient. Reduce p or n.")
  }

  moments_centered <- sweep(moments, 2, colMeans(moments))

  # Bartlett HAC of NW_hac_STATA.m, divisor T:
  # S = G_0 + sum_{l=1}^{L} (1 - l/(L+1)) (G_l + G_l')
  S <- crossprod(moments_centered) / T_eff
  for (l in seq_len(nw_lags)) {
    autocovariance <- crossprod(
      moments_centered[seq_len(T_eff - l), , drop = FALSE],
      moments_centered[(1L + l):T_eff, , drop = FALSE]
    ) / T_eff
    S <- S + (1 - l / (nw_lags + 1)) * (autocovariance + t(autocovariance))
  }

  Q1 <- crossprod(X) / T_eff
  Q1inv <- solve(Q1)
  Q2 <- crossprod(Z, X) / T_eff
  sel_lag <- Q1inv[(m + 1):d_x, , drop = FALSE]   # [0 I_np] Q1^-1

  # vech(Sigma) = V_select vec(Sigma)
  I_n <- diag(n)
  V_select <- do.call(
    rbind,
    purrr::map(seq_len(n), \(i) {
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
    cbind(
      WHataux[idx_a, idx_a, drop = FALSE],
      WHataux[idx_a, idx_g, drop = FALSE]
    ),
    cbind(
      WHataux[idx_g, idx_a, drop = FALSE],
      WHataux[idx_g, idx_g, drop = FALSE]
    )
  )
  idx_g_what <- n_a + seq_len(n_g)

  list(
    W1 = WHat[idx_a, idx_a, drop = FALSE],
    W12 = WHat[idx_a, idx_g_what, drop = FALSE],
    W2 = WHat[idx_g_what, idx_g_what, drop = FALSE],
    WHataux = WHataux,
    WHat = WHat,
    Gamma = drop(eta %*% Z / T_eff),
    T_eff = T_eff,
    hac_dim = hac_dim
  )
}


#' Anderson-Rubin confidence set for the proxy-SVAR IRF, by test inversion
#'
#' Port of `MSWfunction.m` sections 4-7. For every (variable j, horizon h) it
#' solves in lambda the quadratic inequality
#' `ahat lambda^2 + bhat lambda + chat <= 0`, which is the inverted AR test of
#' `H0: IRF_{j,h} = lambda`, and classifies the solution with
#' `solve_quadratic_le_zero()` — not with MOSW's strict-inequality cascade,
#' which mishandles every degenerate branch.
#'
#' `ahat = T den^2 - critval d0' W2 d0` does not vary across cells, so the
#' set is bounded **iff** the Wald in the normalisation direction (the
#' project's xi_mp) exceeds `critval`. That is the `ar_bounded` flag already
#' tabulated in `output/instrument/mosw_strength_grid.csv`.
#'
#' The normalisation direction is read off the impact slice,
#' `d0 = deriv$C[nvar, , 1]`. In a VAR of observables `C_0 = I` and this is
#' exactly the coordinate vector `e_nvar` of MOSW; in a DFM it is the loadings
#' row of the policy variable, projected onto the dynamic-shock space. No
#' argument distinguishes the two cases.
#'
#' @param deriv List returned by `mosw_response_derivatives()`.
#' @param cov List returned by `mosw_rform_cov()`.
#' @param nvar Row index of the normalisation variable in `deriv$C`.
#' @param scale Impact response imposed on `nvar`, in its native units.
#' @param confidence Confidence level, e.g. 0.95.
#' @param cumulative Invert the test on the horizon-cumulated response
#'   (`deriv$Ccum` / `deriv$D1cum`) instead of the per-horizon one. Required by
#'   transformation codes that accumulate; accumulating the bounds of a
#'   non-cumulative set afterwards would be wrong.
#'
#' @return List of `n_out x (h+1)` matrices `point`, `ahat`, `bhat`, `chat`,
#'   `Delta`, `casedummy`, `set_type`, `lo`, `hi`, `dm_lo`, `dm_hi`, `dm_se`,
#'   plus scalars `critval`, `den`, `xi_den`.
mosw_ar_bounds <- function(deriv, cov, nvar, scale, confidence,
                           cumulative = FALSE) {
  C <- if (cumulative) deriv$Ccum else deriv$C
  D1 <- if (cumulative) deriv$D1cum else deriv$D1

  n_out <- dim(C)[1]
  n_inn <- dim(C)[2]
  n_h <- dim(C)[3]
  n_a <- dim(D1)[2]

  Gamma <- cov$Gamma
  T_eff <- cov$T_eff
  critval <- qnorm(1 - (1 - confidence) / 2)^2

  # Normalisation direction: the impact row of the policy variable. `C_0 = I`
  # in the VAR case makes this the coordinate vector `e_nvar`.
  d0 <- deriv$C[nvar, , 1]
  den <- sum(d0 * Gamma)
  w_den <- drop(t(d0) %*% cov$W2 %*% d0)
  # A zero normalising covariance would divide into Inf without an error
  if (!is.finite(den) || den == 0) {
    stop("The normalising covariance d0'Gamma must be finite and nonzero")
  }

  # Stack the n_out*(h+1) cells as rows so every quadratic form is one pass.
  Dg <- scale * matrix(aperm(C, c(1, 3, 2)), nrow = n_out * n_h, ncol = n_inn)
  Da <- scale * matrix(aperm(D1, c(1, 3, 2)), nrow = n_out * n_h, ncol = n_a)

  num <- drop(Dg %*% Gamma)
  W2d0 <- drop(cov$W2 %*% d0)
  W12d0 <- drop(cov$W12 %*% d0)

  q_aa <- rowSums((Da %*% cov$W1) * Da)
  q_ag <- rowSums((Da %*% cov$W12) * Dg)
  q_gg <- rowSums((Dg %*% cov$W2) * Dg)

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

  # Delta method (MSWfunction.m section 6): d = [d1, dGamma - lambda*d0].
  Dd <- cbind(Da, Dg - outer(point, d0))
  dm_var <- rowSums((Dd %*% cov$WHat) * Dd)
  dm_se <- sqrt(pmax(dm_var, 0)) / (sqrt(T_eff) * abs(den))

  as_matrix <- \(values) matrix(values, nrow = n_out, ncol = n_h)

  list(
    point = as_matrix(point),
    ahat = as_matrix(ahat),
    bhat = as_matrix(bhat),
    chat = as_matrix(chat),
    Delta = as_matrix(bhat^2 - 4 * ahat * chat),
    casedummy = as_matrix(sol$casedummy),
    set_type = as_matrix(sol$type),
    lo = as_matrix(sol$lo),
    hi = as_matrix(sol$hi),
    dm_lo = as_matrix(point - sqrt(critval) * dm_se),
    dm_hi = as_matrix(point + sqrt(critval) * dm_se),
    dm_se = as_matrix(dm_se),
    critval = critval,
    den = den,
    xi_den = T_eff * den^2 / w_den
  )
}


#' Does the AR set exclude zero?
#'
#' The significance reading of an inverted test: `H0: IRF = 0` is rejected
#' exactly when `0` is outside the confidence set. Unlike a Wald band, the set
#' need not be an interval, so the answer is read off the topology and not
#' off `lo`/`hi` alone. Note that `two_rays` — `(-Inf, lo] U [hi, Inf)` — CAN
#' exclude zero, when zero falls in the open gap `(lo, hi)`; and `real_line`
#' never can. An `empty` set rejects every value of lambda including zero,
#' which is a misspecification signal rather than evidence of a response, and
#' is reported as `NA`.
#'
#' @param set_type Character matrix from `mosw_ar_bounds()`.
#' @param lo,hi Bound matrices from `mosw_ar_bounds()`.
#'
#' @return Logical matrix of the same shape, `NA` where the set is empty.
ar_excludes_zero <- function(set_type, lo, hi) {
  excludes <- rep(FALSE, length(set_type))
  bounded <- set_type %in% c("interval", "singleton")
  excludes[bounded] <- lo[bounded] > 0 | hi[bounded] < 0
  rays <- set_type == "two_rays"
  excludes[rays] <- lo[rays] < 0 & hi[rays] > 0
  left <- set_type == "half_line_left"
  excludes[left] <- hi[left] < 0
  right <- set_type == "half_line_right"
  excludes[right] <- lo[right] > 0
  excludes[set_type == "empty"] <- NA
  matrix(excludes, nrow = nrow(set_type), ncol = ncol(set_type))
}


#' Anderson-Rubin confidence sets for the DFM, in published units
#'
#' The whole DFM wiring in one place: it rebuilds the factor-VAR regressor
#' block, assembles `Load = diag(sy) Lambda` and `Inner = K K'`, and returns
#' one `mosw_ar_bounds()` result per confidence level with the transformation
#' codes already applied to the bounds. The proxy arrives already aligned to
#' the factor innovations — `compute_irf_dfm()` owns that alignment, through
#' `sel_ext_inst_sample()`, and is the only caller.
#'
#' **Transformation codes.** `cumimp_transform()` is monotone increasing in
#' every code it implements, so set bounds map through it endpoint by
#' endpoint: code 1 is the identity, code 6 is `x*100`, code 4 is
#' `(exp(x)-1)*100`. Codes 2 and 5 accumulate, and those take the
#' **cumulative** inversion (`cumulative = TRUE`); accumulating the bounds of a
#' per-horizon set would be wrong. Code 3 accumulates twice and has no branch
#' here — it aborts.
#'
#' **COVID volatility** (Lenza-Primiceri 2022). With `innovations =
#' "standardized"` the weighted least squares of (B2) is OLS on the rows
#' divided by `s_t`. Given the scale, its influence function is therefore
#' `CovAhat_Sigmahat_Gamma.m` itself on the transformed regressors `x_t / s_t`
#' (the constant becoming `1/s_t`), the innovations `u_t / s_t` and MOSW's
#' uncentered Gamma (`SVARIV.m:128`). The sets condition on the estimated
#' scale as they do on the loadings. `"raw"` mixes the transformed regressors
#' (in A) with the raw ones (in Gamma), is not derived, and aborts
#' (notas/2026-09-14_inferencia_volatilidade_covid_q.md).
#'
#' @param dfm_results List returned by `estimate_dfm()`.
#' @param rsh_sel_ind Logical index into the factor innovations, from
#'   `sel_ext_inst_sample()`.
#' @param inst_sel Instrument values aligned with `rsh_sel_ind`.
#' @param mpind Column index of the policy variable.
#' @param h Maximum horizon.
#' @param scale Impact response imposed on the policy variable, native units.
#' @param tcode Integer vector of transformation codes, one per variable.
#' @param levels Confidence levels.
#' @param nw_lags Newey-West truncation for the moment covariance.
#'
#' @return List with `by_level` (named by `sprintf("%.2f", levels)`, each a
#'   `mosw_ar_bounds()` result in published units), plus `Gamma`, `d0`,
#'   `xi_den`, `T_eff`, `hac_dim` and `n_par`.
ar_dfm_bands <- function(dfm_results, rsh_sel_ind, inst_sel, mpind, h,
                         scale, tcode, levels, nw_lags = 0L) {
  unmapped_codes <- setdiff(tcode, c(1L, 2L, 4L, 5L, 6L))
  if (length(unmapped_codes) > 0) {
    stop("ar_dfm_bands: transformation codes ",
         paste(sort(unmapped_codes), collapse = ", "),
         " have no monotone bound map here (code 3 accumulates twice)")
  }
  covid <- dfm_results$covid_volatility
  if (!is.null(covid) && covid$innovations != "standardized") {
    stop("ar_dfm_bands: under covid_volatility with innovations = \"raw\" the ",
         "influence function mixes the transformed regressors (in A) with the ",
         "raw ones (in Gamma) and is not derived; only \"standardized\" is ",
         "(notas/2026-09-14_inferencia_volatilidade_covid_q.md).")
  }

  p <- dfm_results$p
  r <- dfm_results$r
  Lambda <- dfm_results$static_loadings
  K <- dfm_results$dynamic_loadings
  sy <- dfm_results$data_sd
  u <- dfm_results$var_residuals
  AL <- dfm_results$companion_matrix[seq_len(r), , drop = FALSE]

  # The project's response is `diag(sy) Lambda B_h K M H` with
  # `H = M^-1 K' Gamma_eta`, so `M` cancels and the projection is `K K'`. When
  # q = r that projection is the identity, and estimate_dynamic_factors()
  # returns K = M = I_r anyway.
  Inner <- if (dfm_results$q < r) K %*% t(K) else diag(r)
  Load <- sweep(Lambda, 1, sy, "*")

  # Factor-VAR regressors, deterministic column FIRST: that is the order of
  # RForm_VAR.m, which the Shat of CovAhat_Sigmahat_Gamma.m depends on. The
  # factor VAR of this project is intercept-only.
  X_reg <- cbind(
    1,
    embed(dfm_results$static_factors, p + 1)[, -seq_len(r), drop = FALSE]
  )
  # Under the COVID volatility the estimating equation is (B2): every row,
  # constant included, divided by s_t
  if (!is.null(covid)) {
    X_reg <- X_reg / dfm_results$volatility_path
  }

  z <- as.numeric(inst_sel)
  X_sel <- X_reg[rsh_sel_ind, , drop = FALSE]
  T_eff <- length(z)

  # Demeaned exactly as ident_ext_instr() does, so Gamma points in the same
  # direction as the production impact vector H. With a constant in the VAR
  # and the full innovation sample selected, this is a no-op. Under the COVID
  # volatility nothing is centered, as in ident_ext_instr(center = FALSE):
  # the residuals are orthogonal to 1/s_t, not to 1.
  u_sel <- u[rsh_sel_ind, , drop = FALSE]
  if (is.null(covid)) {
    u_sel <- sweep(u_sel, 2, colMeans(u_sel))
  }

  # MOSW run the covariance on the full VAR sample with `z` zero-padded
  # outside the instrument's window (SVARIV.m:128, 166), which fixes T at the
  # total number of innovations. Selecting rows instead moves T, and so Gamma
  # and W. In production the two coincide because the instrument covers every
  # month.
  if (T_eff != nrow(u)) {
    stop("ar_dfm_bands: the instrument covers ", T_eff, " of ", nrow(u),
         " factor innovations. MOSW use the full sample with z zero-padded ",
         "(SVARIV.m:128) and this path subsamples, ",
         "which moves T, Gamma and W. ",
         "Settle the convention before publishing the cell.")
  }

  # The regressor block above has to be the same estimating equation that
  # produced `u`. estimate_var_wls() puts the constant last and this block
  # puts it first, the order CovAhat_Sigmahat_Gamma.m:76 requires; OLS
  # residuals are invariant to that, but only if the columns are otherwise
  # the same ones. In-sample orthogonality is the cheap proof of it.
  orth <- max(abs(crossprod(X_sel, u_sel)))
  orth_scale <- max(abs(X_sel)) * max(abs(u_sel)) * T_eff
  if (!is.finite(orth) || orth > 1e-8 * max(orth_scale, 1)) {
    stop("ar_dfm_bands: the rebuilt regressors are not orthogonal to the ",
         "factor-VAR residuals (max |X'u| = ", format(orth, digits = 3),
         "). The X_reg rebuild diverged from estimate_var_wls().")
  }

  cov <- mosw_rform_cov(X_sel, z, t(u_sel), p, nw_lags = nw_lags)
  deriv <- mosw_response_derivatives(
    AL,
    p,
    h,
    cov$Gamma,
    Load = Load,
    Inner = Inner
  )

  cumulative_rows <- tcode %in% c(2L, 5L)
  exp_rows <- tcode %in% c(4L, 5L)
  percent_rows <- tcode %in% c(2L, 4L, 5L, 6L)
  bound_fields <- c("point", "lo", "hi", "dm_lo", "dm_hi")
  spliced_fields <- c(
    bound_fields,
    "set_type", "casedummy", "ahat", "bhat", "chat", "Delta"
  )

  by_level <- purrr::map(levels, \(level) {
    bounds <- mosw_ar_bounds(deriv, cov, mpind, scale, level)
    # Accumulating codes take bounds and topology from the cumulative inversion
    if (any(cumulative_rows)) {
      cumulative <- mosw_ar_bounds(
        deriv,
        cov,
        mpind,
        scale,
        level,
        cumulative = TRUE
      )
      bounds[spliced_fields] <- purrr::map2(
        bounds[spliced_fields],
        cumulative[spliced_fields],
        \(per_horizon, accumulated) {
          per_horizon[cumulative_rows, ] <-
            accumulated[cumulative_rows, , drop = FALSE]
          per_horizon
        }
      )
    }
    purrr::modify_at(bounds, bound_fields, \(values) {
      values[exp_rows, ] <- exp(values[exp_rows, , drop = FALSE]) - 1
      values[percent_rows, ] <- values[percent_rows, , drop = FALSE] * 100
      values
    })
  }) |>
    purrr::set_names(sprintf("%.2f", levels))

  d0 <- deriv$C[mpind, , 1]
  list(
    by_level = by_level,
    Gamma = cov$Gamma,
    d0 = d0,
    den = sum(d0 * cov$Gamma),
    xi_den = by_level[[1L]]$xi_den,
    T_eff = T_eff,
    hac_dim = cov$hac_dim,
    n_par = ncol(cov$WHat)
  )
}
