# Labelling the monetary column of the GMR ICA without the instrument.
#
# The production branch names the monetary column by |cor(eps_j, z)|
# (`label_by_proxy`, nongaussian_gmr.R:661). That works, but it leaves the
# "identification that does not use the instrument" still depending on the
# instrument to know WHICH shock is the monetary one — and on this panel the
# winner beats the runner-up by only 0.046. This module supplies the pieces to
# select the column by criteria internal to the model instead.
#
# It is a DIAGNOSTIC module: sourced by script/nongaussian_{labelling,
# corroboration}.R and by nothing on the production path. It does not modify
# `ident_nongaussian`.
#
# THE TRAP THIS MODULE EXISTS TO AVOID. The reported IRF is normalized by
# `irf / irf[mpind, 1] * normalize_value` — it divides by the column's OWN
# impact on the policy variable. After that every column is worth exactly
# `normalize_value` at `mpind` in h = 0, so any selection rule applied to the
# normalized IRF is degenerate and picks arbitrarily. Selection must read the
# PRE-normalization response; normalization comes after the column is chosen.

if (!exists("cumimp_transform", mode = "function"))
  source("R/modeling/impulse_responde.R")

#' Rebuild the reduced-form impulse array from a fitted DFM
#'
#' Same construction as `compute_irf_dfm` (`impulse_responde.R:437-455`), using
#' the OLS companion (no Kilian correction), which is what the point estimate
#' uses. Exists because `rawimp` is not stored in the cached cell object and
#' any analysis of a column other than the labelled one needs it.
#'
#' @param dfm Result of `estimate_dfm`.
#' @param h Maximum horizon.
#' @return `n_vars x q x (h+1)` array.
ng_rawimp_from_dfm <- function(dfm, h) {
  Lambda <- dfm$static_loadings
  A      <- dfm$companion_matrix
  K      <- dfm$dynamic_loadings
  M      <- dfm$dynamic_scaling
  sy     <- dfm$data_sd
  r      <- ncol(Lambda); rp <- nrow(A); n_vars <- nrow(Lambda)
  q      <- dfm$q

  Bfull <- array(0, dim = c(rp, rp, h + 1))
  Bfull[, , 1] <- diag(rp)
  Bfull[, , 2] <- A
  for (i in 3:(h + 1)) Bfull[, , i] <- Bfull[, , i - 1] %*% A

  rawimp <- array(0, dim = c(n_vars, q, h + 1))
  for (i in seq_len(h + 1)) {
    temp <- if (!is.matrix(K) && !is.matrix(M)) {
      Re(Lambda %*% Bfull[1:r, 1:r, i] * K * M)
    } else {
      Re(Lambda %*% Bfull[1:r, 1:r, i] %*% K %*% M)
    }
    rawimp[, , i] <- sweep(temp, 1, sy, "*")
  }
  rawimp
}

#' Pre-normalization IRF of an arbitrary impact direction
#'
#' @param rawimp Array from `ng_rawimp_from_dfm`.
#' @param b Length-q impact vector in eta-space (`b = P c_j`).
#' @return `n_vars x (h+1)` matrix, raw units, no normalization, no tcode.
ng_irf_raw <- function(rawimp, b) {
  n_vars <- dim(rawimp)[1]; hp1 <- dim(rawimp)[3]
  out <- matrix(0, n_vars, hp1)
  for (j in seq_len(hp1))
    out[, j] <- matrix(rawimp[, , j], nrow = n_vars) %*% b
  out
}

#' IRF of an arbitrary direction, normalized and tcode-transformed
#'
#' Applies the same sign rule as `ident_nongaussian` (`nongaussian_branch.R:98-105`):
#' a column of an orthogonal C is identified only up to sign, so it is oriented
#' to move the policy variable up on impact. The normalization is applied after
#' the orientation, and both after any selection has already happened.
#'
#' @param orient If TRUE apply the sign rule. FALSE only for reproducing an
#'   already-oriented vector such as the cached `b_point`.
#' @return List with `irf` (transformed), `irf_pre_tcode`, `b` (possibly
#'   sign-flipped) and `impact_pre` (pre-normalization response at `mpind`).
ng_irf_for_b <- function(rawimp, b, mpind, normalize_value = 0.005,
                         tcode = NULL, orient = TRUE) {
  m <- ng_irf_raw(rawimp, b)
  impact_pre <- m[mpind, 1]
  if (orient && !is.na(impact_pre) && impact_pre < 0) {
    b <- -b; m <- -m; impact_pre <- -impact_pre
  }
  m <- m / m[mpind, 1] * normalize_value
  list(irf = cumimp_transform(m, tcode), irf_pre_tcode = m,
       b = b, impact_pre = impact_pre)
}

#' Forecast-error variance shares by structural column
#'
#' Computed on the PRE-normalization responses (see the module header). With
#' `eps` orthogonal and unit-variance — which holds by construction, since the
#' PML runs on prewhitened `eta` and `C` is orthogonal — the forecast error
#' variance of variable `i` through horizon `h_max` decomposes as
#' `sum_k sum_j (rawimp[i, , k] %*% b_j)^2`.
#'
#' Shares are computed per variable and then averaged across `vars_idx`, rather
#' than pooling numerators and denominators: pooling would let a single
#' large-scale series decide the answer for the whole block.
#'
#' @param C Orthogonal q x q matrix from the ICA.
#' @param P Cholesky factor of `Var(eta)`; `b_j = P C[, j]`.
#' @param vars_idx Row indices of `rawimp` to aggregate over.
#' @param h_max Horizon through which the variance is accumulated.
#' @return List with `share` (length q, averaged) and `by_var` (length(vars_idx) x q).
ng_fevd_share <- function(rawimp, C, P, vars_idx, h_max) {
  q   <- ncol(C)
  hs  <- seq_len(min(h_max + 1L, dim(rawimp)[3]))
  num <- matrix(0, length(vars_idx), q)
  for (j in seq_len(q)) {
    m <- ng_irf_raw(rawimp, drop(P %*% C[, j]))
    num[, j] <- rowSums(m[vars_idx, hs, drop = FALSE]^2)
  }
  by_var <- num / rowSums(num)
  list(share = colMeans(by_var), by_var = by_var)
}
