# Non-Gaussian identification branch for the DFM.
#
# Adapter between the GMR (2017) PML-ICA estimator in `nongaussian_gmr.R` and
# the identification contract of `compute_irf_dfm`. Same shape as
# `ident_ext_instr` (proxy) and the archived `ident_het_regimes` (het): consume
# `eta`, return a length-q impact vector plus IRFs normalized on the policy
# variable.
#
# THE MAPPING. The paper writes the reduced form as `u_t = S C eps_t` with `S`
# any square root of `Var(u_t)` and `C` orthogonal, applies the PML to the
# prewhitened residuals `S^-1 u_t`, and reads the IRF of shock j off `S c_j`
# (§3.1). Here `eta` (T x q) plays the role of `u`, so with `P` the Cholesky
# factor of `Var(eta)`:
#
#     eta_t = P C eps_t   =>   impact of shock j in eta-space is  b = P c_j
#
# and the existing machinery closes: `irf[, k] = rawimp[, , k] %*% b`.
#
# `eta` already has unit covariance by BLL construction (K'Sigma_u K = diag),
# so `P` is numerically the identity; it is computed anyway so the branch stays
# correct if the dynamic-factor normalization ever changes.
#
# IDENTIFICATION IS THE ICA'S, NOT THE PROXY'S. The instrument only *labels*
# which estimated column is the monetary one. That makes the proxy restriction
# testable rather than maintained — see `gmr_wald_column`.

if (!exists("estim_ica_pml", mode = "function"))
  source("R/identification/nongaussian_gmr.R")

#' Non-Gaussian (GMR 2017) identification of the monetary column
#'
#' @param rawimp `n_vars x q x (h+1)` reduced-form impulse array.
#' @param eta `T x q` dynamic-factor innovations.
#' @param h Horizon.
#' @param mpind Index of the policy variable used for normalization.
#' @param normalize_value Impact value imposed on the policy variable.
#' @param tcode Transformation codes for `cumimp_transform`.
#' @param z Instrument aligned to `sel` rows of `eta`; used for labelling only.
#'   Ignored when `C_ref` is supplied.
#' @param sel Logical vector selecting the rows of `eta` matching `z`.
#' @param C_ref Reference `C` from the point estimate. When supplied (bootstrap
#'   replications) the estimated columns are aligned to it and `col_mp` is taken
#'   as given, which is what keeps the label from switching across draws.
#' @param col_mp Column index to use when `C_ref` is supplied.
#' @param distri Pseudo-density specification; defaults to `q` distinct
#'   asymmetric Gaussian mixtures (Assumption A.5).
#' @param n_starts Multi-start count for the PML optimizer.
#' @param a_init Warm start for the optimizer (bootstrap: the point estimate).
#' @param diagnose Print a diagnostic block.
#' @param var_names Variable names, for the diagnostic block.
#'
#' @return List with `irf_mp` (tcode-transformed), `irf_mp_pre_tcode`, `b`
#'   (length q), `C`, `a`, `col_mp`, `impact_pre`, `eps`, `label` and `fit`.
ident_nongaussian <- function(rawimp, eta, h,
                              mpind = NULL, normalize_value = 0.5,
                              tcode = NULL, z = NULL, sel = NULL,
                              C_ref = NULL, col_mp = NULL, distri = NULL,
                              n_starts = 20L, a_init = NULL,
                              diagnose = FALSE, var_names = NULL) {
  eta <- as.matrix(eta)
  q   <- ncol(eta)
  if (is.null(distri)) distri <- gmr_distri_mixtures(q)

  eta_c <- sweep(eta, 2, colMeans(eta))
  P     <- t(chol(stats::var(eta_c)))
  Yw    <- eta_c %*% solve(t(P))

  fit <- estim_ica_pml(Yw, distri, n_starts = n_starts, a_init = a_init)
  C   <- fit$C

  # --- Labelling: align to the point estimate, or name the column by the proxy
  label <- NULL
  if (!is.null(C_ref)) {
    C <- match_columns(C_ref, C)$C
    if (is.null(col_mp))
      stop("ident_nongaussian: col_mp is required when C_ref is supplied")
  } else {
    if (is.null(z))
      stop("ident_nongaussian: either z (to label) or C_ref (to align) is required")
    rows  <- if (is.null(sel)) rep(TRUE, nrow(eta)) else sel
    label <- label_by_proxy(fit$eps[rows, , drop = FALSE], z)
    col_mp <- label$col
  }

  eps <- Yw %*% C
  b   <- drop(P %*% C[, col_mp])

  n_vars <- dim(rawimp)[1]
  irf_mp <- matrix(0, n_vars, h + 1)
  for (j in seq_len(h + 1)) {
    irf_mp[, j] <- matrix(rawimp[, , j], nrow = n_vars) %*% b
  }

  # Sign rule, applied on every call including bootstrap draws: the column of
  # an orthogonal C is identified only up to sign, so orient it so that the
  # policy variable moves up on impact. Redundant for the normalized IRFs (the
  # ratio below is sign-invariant) but it pins down the reported b and C.
  impact_pre <- if (!is.null(mpind)) irf_mp[mpind, 1] else NA_real_
  if (!is.null(mpind) && !is.na(impact_pre) && impact_pre < 0) {
    b            <- -b
    irf_mp       <- -irf_mp
    C[, col_mp]  <- -C[, col_mp]
    eps[, col_mp] <- -eps[, col_mp]
    impact_pre   <- -impact_pre
  }

  if (isTRUE(diagnose)) {
    cat("\n========== ident_nongaussian (GMR 2017) DIAGNOSTIC ==========\n")
    cat(sprintf("q = %d | T = %d | pseudo log-lik = %.3f\n", q, nrow(eta), fit$logLik))
    cat(sprintf("starts: %d converged, %d at the best optimum\n",
                fit$converged, fit$n_at_best))
    cat(sprintf("monetary column = %d\n", col_mp))
    if (!is.null(label)) {
      cat(sprintf("labelled by |cor(eps_j, z)| = %.3f (runner-up %.3f, gap %.3f)\n",
                  label$best, label$second, label$gap))
      if (!is.na(label$gap) && label$gap < 0.05) {
        cat("[!!!] WARNING: the proxy barely separates the monetary column from\n")
        cat("      the runner-up. The ICA estimate may be fine while the NAME\n")
        cat("      attached to it is fragile — check the runner-up's IRF.\n")
      }
    }
    cat(sprintf("b (impact in eta-space): %s\n",
                paste(sprintf("%.4e", b), collapse = "  ")))
    cat(sprintf("irf_mp[mpind=%s, 1] (pre-norm) = %.4e\n",
                as.character(mpind), impact_pre))
    impact_vec <- irf_mp[, 1]
    if (!is.null(var_names) && length(var_names) == length(impact_vec))
      names(impact_vec) <- var_names
    cat("Impact (raw, pre-norm) per variable:\n"); print(impact_vec)
    cat("=============================================================\n\n")
  }

  if (!is.null(mpind)) {
    irf_mp <- irf_mp / irf_mp[mpind, 1] * normalize_value
  }

  list(irf_mp           = cumimp_transform(irf_mp, tcode),
       irf_mp_pre_tcode = irf_mp,
       b                = b,
       C                = C,
       a                = fit$a,
       col_mp           = col_mp,
       impact_pre       = impact_pre,
       eps              = eps,
       label            = label,
       fit              = fit)
}
