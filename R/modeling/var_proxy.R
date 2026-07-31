# ===================================================================
# Small-scale proxy-SVAR: the DFM's benchmark.
#
# Translation of the Alessi-Kerssenfischer VAR path:
#   codigo_alessi-mark/VARest.m       -> var_est_ols
#   codigo_alessi-mark/VARest_boot.m  -> the bootstrap block below
#   codigo_alessi-mark/MAIN_VARloop.m -> script/model_var.R (the driver)
#
# The identification is SHARED with the DFM, not re-implemented:
# `sel_ext_inst_sample` and `ident_ext_instr` from impulse_responde.R are
# the same functions the factor model calls. The only difference between
# the two paths is what gets projected on the instrument — here the
# N-dimensional reduced-form residuals of the VAR, there the
# q-dimensional dynamic-factor innovations eta = u K M^-1.
#
# Extracted from script/model_var.R on 2026-07-31, fixing on the way the
# three errors that made that file unrunnable (the caller passed
# `var_data`/`p_var`, absent from the signature; the body expected a
# vars::VAR object but got the list from var_est_ols; and the driver
# asked for a panel column that does not exist). `kilian_correction` is
# now taken from factor_estimation.R rather than duplicated — the two
# implementations were verified equal to 5.6e-17 before the local copy
# was deleted.
#
# Requires: R/modeling/factor_estimation.R (kilian_correction)
#           R/modeling/impulse_responde.R  (sel_ext_inst_sample,
#                                           ident_ext_instr)
# ===================================================================


#' Reduced-form VAR by OLS, with companion form and MA coefficients
#'
#' Faithful translation of `VARest.m`. Unchanged in the extraction.
#'
#' @param X T x N data matrix (no date column).
#' @param p Lag order.
#' @param h IRF horizon.
#'
#' @return List with `B` (N x N x h+1 reduced-form MA coefficients, the
#'   `rawimp` that `ident_ext_instr` consumes), `u` (residuals),
#'   `bet` ((N*p+1) x N coefficients, constant last) and `A` (companion).
var_est_ols <- function(X, p, h) {
  T_total <- nrow(X)
  N <- ncol(X)

  RHS <- matrix(NA, T_total - p, N * p)
  for (i in seq_len(p)) {
    RHS[, ((i - 1) * N + 1):(i * N)] <- X[(p + 1 - i):(T_total - i), ]
  }
  LHS <- X[(p + 1):T_total, ]

  design <- cbind(RHS, 1)
  bet <- solve(crossprod(design), crossprod(design, LHS))
  u <- LHS - design %*% bet

  Np <- N * p
  A <- matrix(0, Np, Np)
  A[1:N, ] <- t(bet[1:Np, ])
  if (p > 1) {
    A[(N + 1):Np, 1:((p - 1) * N)] <- diag((p - 1) * N)
  }

  Bfull <- array(0, dim = c(Np, Np, h + 1))
  Bfull[, , 1] <- diag(Np)
  Bfull[, , 2] <- A
  for (i in 3:(h + 1)) Bfull[, , i] <- Bfull[, , i - 1] %*% A

  B <- array(0, dim = c(N, N, h + 1))
  for (i in seq_len(h + 1)) B[, , i] <- Bfull[1:N, 1:N, i]

  list(B = B, u = u, bet = bet, A = A)
}


#' Proxy-SVAR IRFs for a small reduced-form VAR, with wild bootstrap
#'
#' Encapsulates `VARest.m` + `VARest_boot.m` + `IdentExtInstr.m` as
#' `MAIN_VARloop.m` chains them. The bootstrap is Gonçalves-Kilian wild:
#' the SAME Rademacher draw multiplies the residuals and the instrument
#' (`sel_ext_inst_sample(..., rr = rr)`), the DGP uses Kilian-corrected
#' coefficients while the point estimate uses plain OLS, and every
#' replica re-estimates the VAR. That is the DFM's scheme too, which is
#' what makes the two IRF sets comparable.
#'
#' @param X_mat T x N panel matrix for this VAR, columns in the order the
#'   IRFs should come out.
#' @param p Lag order.
#' @param instrument Data.frame with `month` (Date) and `shock`.
#' @param data_dates Dates aligned with the rows of `X_mat`.
#' @param h IRF horizon.
#' @param mpind Column index of the policy variable, used for the impact
#'   normalization. `IdentExtInstr.m` resolves it by name against the
#'   SUBSET of names in this VAR; here the caller passes the index.
#' @param normalize_value Impact response of the policy variable in its
#'   native units (`shock_bps/10000` for decimal yields — see
#'   `norm_value_for` in R/identification/spec_sweep.R).
#' @param tcode Transformation codes for the N columns of `X_mat`, in the
#'   same order. Passed through to `ident_ext_instr`, which applies
#'   `cumimp_transform` inside both the point estimate and each replica —
#'   as `MAIN_VARloop.m:28` does with `X.tcode(varselind)`. Leaving this
#'   NULL silently returns cumulative-return series uncumulated and makes
#'   the IRFs incomparable with the DFM.
#' @param nboot Wild-bootstrap replications.
#' @param ci_levels Confidence levels for the bands.
#' @param seed Optional seed, set before the bootstrap loop.
#'
#' @return List with `irf_point` (N x h+1), `ci` (named list per level,
#'   each with `lower`/`upper`), `H`, `n_failed` and `n_inst`.
compute_irf_var_proxy <- function(X_mat, p, instrument, data_dates,
                                  h = 48, mpind = 1L,
                                  normalize_value = 50 / 10000,
                                  tcode = NULL, nboot = 800,
                                  ci_levels = c(0.68, 0.90), seed = NULL) {

  X_mat <- as.matrix(X_mat)
  N <- ncol(X_mat)
  T_total <- nrow(X_mat)
  T_eff <- T_total - p
  Np <- N * p

  if (!is.null(tcode) && length(tcode) != N) {
    stop("tcode tem ", length(tcode), " elementos para um VAR de ", N,
         " variaveis")
  }

  # --- Reduced form: one call gives rawimp, residuals, coefficients ---
  m <- var_est_ols(X_mat, p, h)
  rawimp <- m$B
  u <- m$u
  A <- m$A
  bet <- m$bet

  # --- Instrument alignment (selextinstsample.m) ---
  align <- sel_ext_inst_sample(data_dates, p, instrument)
  rsh_sel <- u[align$rsh_sel_ind, , drop = FALSE]
  inst_sel <- align$inst_sel
  if (length(inst_sel) == 0 || nrow(rsh_sel) == 0) {
    stop("Nenhuma data comum entre instrumento e residuos do VAR")
  }

  # --- Point estimate (IdentExtInstr.m) ---
  point_result <- ident_ext_instr(rawimp, rsh_sel, inst_sel, h,
                                  mpind, normalize_value, tcode)
  irf_point <- point_result$irf_mp

  ci <- NULL
  n_failed <- 0L

  if (nboot > 0) {
    if (!is.null(seed)) set.seed(seed)

    # Kilian (1998) bias correction — DGP of the bootstrap only
    SIGMA <- matrix(0, Np, Np)
    SIGMA[1:N, 1:N] <- crossprod(u) / (T_eff - p * N - 1)
    betbiasc <- bet
    tryCatch({
      biascorr <- kilian_correction(A, SIGMA, T_total, N, p)
      betbiasc <- rbind(t(biascorr[1:N, ]), bet[Np + 1, ])
    }, error = function(e) {
      warning("Kilian correction failed, using uncorrected coefficients: ",
              e$message)
    })

    res <- sweep(u, 2, colMeans(u))
    irf_boot <- array(NA_real_, dim = c(N, h + 1, nboot))

    for (b in seq_len(nboot)) {
      ok <- tryCatch({
        rr <- 1 - 2 * (runif(T_eff) > 0.5)
        resb <- res * rr

        X_boot <- matrix(0, T_total, N)
        X_boot[1:p, ] <- X_mat[1:p, ]
        for (t_idx in (p + 1):T_total) {
          lvars <- as.vector(t(X_boot[(t_idx - 1):(t_idx - p), , drop = FALSE]))
          X_boot[t_idx, ] <- lvars %*% betbiasc[1:Np, ] +
            betbiasc[Np + 1, ] + resb[t_idx - p, ]
        }

        boot_var <- var_est_ols(X_boot, p, h)
        align_b <- sel_ext_inst_sample(data_dates, p, instrument, rr = rr)
        boot_result <- ident_ext_instr(
          boot_var$B,
          boot_var$u[align_b$rsh_sel_ind, , drop = FALSE],
          align_b$inst_sel, h, mpind, normalize_value, tcode)
        irf_boot[, , b] <- boot_result$irf_mp
        TRUE
      }, error = function(e) FALSE)
      # Failed replicas fall back to the point estimate, which narrows the
      # bands mechanically. Counted and returned rather than swallowed.
      if (!ok) {
        irf_boot[, , b] <- irf_point
        n_failed <- n_failed + 1L
      }
    }

    ci <- lapply(ci_levels, function(L) {
      a <- (1 - L) / 2
      list(level = L,
           lower = apply(irf_boot, c(1, 2), quantile, probs = a, na.rm = TRUE),
           upper = apply(irf_boot, c(1, 2), quantile, probs = 1 - a,
                         na.rm = TRUE))
    })
    # Same key format the DFM cell uses ("0.68", "0.90"), so callers can
    # index both objects with the same string.
    names(ci) <- sprintf("%.2f", ci_levels)
  }

  list(irf_point = irf_point, ci = ci, ci_levels = ci_levels,
       H = point_result$H, n_failed = n_failed, n_inst = length(inst_sel),
       max_eig = max(Mod(eigen(A)$values)))
}
