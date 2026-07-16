# ===================================================================
# PRIMARY IDENTIFICATION THROUGH HETEROSKEDASTICITY (Rigobon 2003)
# Monthly Copom / non-Copom regimes on the factor-VAR innovations
# (architecture A, Stock-Watson 2016 sec. 5.1.2.3). Companion module to
# R/identification/het_shock_extraction.R (daily block, kept for
# robustness) — see _instrucoes/plano_reimplementacao_het.md.
# ===================================================================

library(dplyr)
library(lubridate)


#' Build the monthly Copom / non-Copom regime table
#'
#' A month is regime "C" when it contains at least one Copom meeting
#' (ordinary or extraordinary — both raise policy-shock variance), "NC"
#' otherwise. Over 2013-2025 this yields 104 C months and 52 NC months
#' (8 meetings per year).
#'
#' @param copom_csv Path to the Copom meetings file with an ISO-parsed
#'   meeting-date column `data_reuniao_parsed`.
#' @param month_range Length-2 Date vector bounding the monthly grid
#'   (any day within the first and last month).
#'
#' @return Tibble with columns month (first day of month, Date) and
#'   regime ("C" or "NC").
build_monthly_regimes <- function(copom_csv = "data/copom_historico.csv",
                                  month_range) {
  copom <- suppressWarnings(
    readr::read_csv(copom_csv, show_col_types = FALSE)
  )
  meeting_months <- copom$data_reuniao_parsed |>
    as.Date() |>
    na.omit() |>
    lubridate::floor_date("month") |>
    unique()

  start <- lubridate::floor_date(as.Date(month_range[1]), "month")
  end   <- lubridate::floor_date(as.Date(month_range[2]), "month")

  tibble::tibble(month = seq(start, end, by = "month")) |>
    dplyr::mutate(regime = ifelse(month %in% meeting_months, "C", "NC"))
}


#' Align monthly regime labels to the rows of the factor-VAR innovations
#'
#' The VAR residuals (and hence eta) drop the first p observations, so
#' row t of eta corresponds to dates[p + t].
#'
#' @param dates Date vector aligned with the data panel rows (length T).
#' @param p VAR lag order used in estimate_dfm.
#' @param regimes Output of build_monthly_regimes().
#'
#' @return Character vector of length T - p with values "C" / "NC".
align_regimes_to_eta <- function(dates, p, regimes) {
  residual_months <- lubridate::floor_date(
    as.Date(dates)[(p + 1):length(dates)], "month"
  )
  labels <- regimes$regime[match(residual_months, regimes$month)]
  if (anyNA(labels)) {
    stop("Regime table does not cover all residual months: ",
         paste(unique(residual_months[is.na(labels)]), collapse = ", "))
  }
  labels
}


#' Within-regime demeaned split of the innovation matrix
#'
#' @param eta Matrix T_eff x q of factor innovations.
#' @param regime_labels Character vector ("C"/"NC") aligned to eta rows.
#'
#' @return List with X_C, X_NC (demeaned within regime), Sigma_C,
#'   Sigma_NC, dSigma, n_C, n_NC.
split_by_regime <- function(eta, regime_labels) {
  eta  <- as.matrix(eta)
  is_C <- regime_labels == "C"

  X_C  <- sweep(eta[is_C, , drop = FALSE],  2, colMeans(eta[is_C, , drop = FALSE]))
  X_NC <- sweep(eta[!is_C, , drop = FALSE], 2, colMeans(eta[!is_C, , drop = FALSE]))

  Sigma_C  <- crossprod(X_C)  / (nrow(X_C)  - 1L)
  Sigma_NC <- crossprod(X_NC) / (nrow(X_NC) - 1L)

  list(
    X_C      = X_C,
    X_NC     = X_NC,
    Sigma_C  = Sigma_C,
    Sigma_NC = Sigma_NC,
    dSigma   = Sigma_C - Sigma_NC,
    n_C      = nrow(X_C),
    n_NC     = nrow(X_NC)
  )
}


#' Half-vectorization of a symmetric matrix
#'
#' @param M Symmetric numeric matrix.
#'
#' @return Numeric vector with the lower-triangular (including diagonal)
#'   elements stacked column-wise.
vech <- function(M) {
  M[lower.tri(M, diag = TRUE)]
}


#' Jacobian of vech(theta theta') with respect to theta
#'
#' @param theta Numeric vector of length q.
#'
#' @return Matrix q(q+1)/2 x q.
vech_outer_jacobian <- function(theta) {
  q   <- length(theta)
  idx <- which(lower.tri(diag(q), diag = TRUE), arr.ind = TRUE)
  J   <- matrix(0, nrow(idx), q)
  for (m in seq_len(nrow(idx))) {
    i <- idx[m, 1]
    j <- idx[m, 2]
    J[m, j] <- J[m, j] + theta[i]
    J[m, i] <- J[m, i] + theta[j]
  }
  J
}


#' Minimum-distance rank-1 fit of the covariance-difference matrix
#'
#' Estimates theta (impact column, up to sign) from the moment condition
#' vech(dSigma) = vech(theta theta') implied by A1-A3 (Rigobon 2003 for
#' the single-shock case, Rigobon-Sack 2004 eq. 9). With identity weight
#' the minimizer is the leading eigenpair of dSigma (Eckart-Young), which
#' reproduces extract_shock_rigobon_sack exactly. With optimal weight the
#' moments are weighted by the inverse bootstrap covariance of
#' vech(dSigma_hat) and the minimized criterion is the overidentification
#' J statistic (df = q(q+1)/2 - q), the rank-1 analogue of Rigobon's GMM.
#'
#' @param Sigma_C Covariance matrix of eta in the Copom regime.
#' @param Sigma_NC Covariance matrix of eta in the non-Copom regime.
#' @param weight "identity" (leading eigenpair, closed form) or "optimal"
#'   (GMM with bootstrap weight; requires X_C and X_NC).
#' @param X_C Demeaned within-C observation matrix (optimal weight only).
#' @param X_NC Demeaned within-NC observation matrix (optimal weight only).
#' @param n_boot_w Bootstrap replications for the weight matrix.
#' @param n_boot_j Bootstrap replications to calibrate the J p-value under
#'   the rank-1 null (0 skips; chi-square p-value always reported).
#' @param seed Optional integer seed.
#'
#' @return List with theta, lambda_all (eigenvalues of dSigma), weight,
#'   J, df, p_chi2, p_boot (NA when n_boot_j = 0), converged.
fit_rank1_md <- function(Sigma_C, Sigma_NC,
                         weight = c("identity", "optimal"),
                         X_C = NULL, X_NC = NULL,
                         n_boot_w = 500L, n_boot_j = 0L, seed = NULL) {
  weight <- match.arg(weight)
  if (!is.null(seed)) set.seed(seed)

  dSigma <- Sigma_C - Sigma_NC
  eig    <- eigen(dSigma, symmetric = TRUE)
  theta_eigen <- sqrt(max(eig$values[1], 0)) * eig$vectors[, 1]

  if (weight == "identity") {
    return(list(
      theta      = theta_eigen,
      lambda_all = eig$values,
      weight     = weight,
      J          = NA_real_,
      df         = NA_integer_,
      p_chi2     = NA_real_,
      p_boot     = NA_real_,
      converged  = TRUE
    ))
  }

  if (is.null(X_C) || is.null(X_NC)) {
    stop("Optimal weight requires the within-regime matrices X_C and X_NC")
  }

  q  <- ncol(Sigma_C)
  df <- q * (q + 1L) / 2L - q

  boot_dsigma <- function(Xc, Xn) {
    Sc <- crossprod(Xc) / (nrow(Xc) - 1L)
    Sn <- crossprod(Xn) / (nrow(Xn) - 1L)
    vech(Sc - Sn)
  }

  draws <- matrix(NA_real_, n_boot_w, q * (q + 1L) / 2L)
  for (b in seq_len(n_boot_w)) {
    idx_C  <- sample.int(nrow(X_C),  nrow(X_C),  replace = TRUE)
    idx_NC <- sample.int(nrow(X_NC), nrow(X_NC), replace = TRUE)
    draws[b, ] <- boot_dsigma(X_C[idx_C, , drop = FALSE],
                              X_NC[idx_NC, , drop = FALSE])
  }
  W <- stats::cov(draws)
  # Ridge floor keeps W invertible when q(q+1)/2 approaches n_NC.
  W_inv <- solve(W + diag(1e-8 * mean(diag(W)), nrow(W)))

  target <- vech(dSigma)
  objective <- function(th) {
    g <- target - vech(tcrossprod(th))
    drop(t(g) %*% W_inv %*% g)
  }
  gradient <- function(th) {
    g <- target - vech(tcrossprod(th))
    drop(-2 * t(vech_outer_jacobian(th)) %*% W_inv %*% g)
  }

  fit <- stats::optim(theta_eigen, objective, gradient, method = "BFGS",
                      control = list(maxit = 500))
  theta <- fit$par
  J     <- fit$value

  p_boot <- NA_real_
  if (n_boot_j > 0L) {
    # H0 bootstrap: transform X_C so that Sigma_C = Sigma_NC + theta theta'
    # exactly (rank-1 null), then resample within regime with W held fixed.
    Sigma_C_H0 <- Sigma_NC + tcrossprod(theta)
    e_proj <- eigen(Sigma_C_H0, symmetric = TRUE)
    Sigma_C_H0 <- e_proj$vectors %*%
      diag(pmax(e_proj$values, 1e-10), length(e_proj$values)) %*%
      t(e_proj$vectors)
    T_C <- mat_sym_sqrt(Sigma_C_H0) %*% mat_sym_inv_sqrt(Sigma_C)
    X_C_H0 <- X_C %*% t(T_C)

    J_boot <- numeric(n_boot_j)
    for (b in seq_len(n_boot_j)) {
      idx_C  <- sample.int(nrow(X_C),  nrow(X_C),  replace = TRUE)
      idx_NC <- sample.int(nrow(X_NC), nrow(X_NC), replace = TRUE)
      tgt_b  <- boot_dsigma(X_C_H0[idx_C, , drop = FALSE],
                            X_NC[idx_NC, , drop = FALSE])
      obj_b <- function(th) {
        g <- tgt_b - vech(tcrossprod(th))
        drop(t(g) %*% W_inv %*% g)
      }
      grad_b <- function(th) {
        g <- tgt_b - vech(tcrossprod(th))
        drop(-2 * t(vech_outer_jacobian(th)) %*% W_inv %*% g)
      }
      dS_b <- matrix(0, q, q)
      dS_b[lower.tri(dS_b, diag = TRUE)] <- tgt_b
      dS_b <- dS_b + t(dS_b) - diag(diag(dS_b))
      eig_b <- eigen(dS_b, symmetric = TRUE)
      init_b <- sqrt(max(eig_b$values[1], 0)) * eig_b$vectors[, 1]
      J_boot[b] <- stats::optim(init_b, obj_b, grad_b, method = "BFGS",
                                control = list(maxit = 500))$value
    }
    p_boot <- (sum(J_boot >= J) + 1L) / (n_boot_j + 1L)
  }

  list(
    theta      = theta,
    lambda_all = eig$values,
    weight     = weight,
    J          = J,
    df         = df,
    p_chi2     = stats::pchisq(J, df = df, lower.tail = FALSE),
    p_boot     = p_boot,
    converged  = fit$convergence == 0L
  )
}


#' Identification via monthly heteroskedasticity regimes (primary scheme)
#'
#' Replaces ident_ext_instr in the het-primary pipeline: the impact
#' column in factor space comes from the rank-1 structure of
#' Sigma_C - Sigma_NC (Rigobon 2003) instead of the proxy projection
#' H = (Z' eta)/(Z'Z). Propagation, sign rule and impact normalization
#' mirror ident_ext_instr so both branches report the same shock
#' orientation: the +normalize_value impact on the policy variable.
#' The normalization is invariant to the arbitrary sign returned by the
#' eigendecomposition (numerator and denominator flip together), so every
#' bootstrap draw is oriented identically by construction; the explicit
#' sign rule below only pins down the reported b.
#'
#' @param rawimp Reduced-form IRF array (n_vars x q x h+1).
#' @param eta Factor innovations (T_eff x q), rows aligned to regime_labels.
#' @param regime_labels Character vector ("C"/"NC") aligned to eta rows.
#' @param h IRF horizon (excluding impact).
#' @param mpind Index of the policy variable in rawimp[, , 1]. NULL skips
#'   normalization (and the sign rule keeps the raw eigenvector sign).
#' @param normalize_value Target impact of the policy variable, native units.
#' @param tcode Transformation codes for cumimp_transform.
#' @param weight Weight for fit_rank1_md ("identity" inside bootstrap loops;
#'   "optimal" adds the GMM J statistic on the point estimate).
#' @param diagnose If TRUE, print the eigenvalue spectrum, b and the impact
#'   vector. Point estimate only; never inside bootstrap loops.
#' @param var_names Optional variable names for the diagnostic printout.
#'
#' @return List with irf_mp (tcode-transformed), irf_mp_raw (normalized,
#'   pre-tcode — same semantics as ident_ext_instr), b (q-vector, sign such
#'   that the mp impact is positive), lambda_all, rank1_share, impact_pre
#'   (pre-normalization mp impact after the sign rule), md_fit, n_C, n_NC.
ident_het_regimes <- function(rawimp, eta, regime_labels, h,
                              mpind = NULL, normalize_value = 0.5,
                              tcode = NULL, weight = "identity",
                              diagnose = FALSE, var_names = NULL) {
  parts <- split_by_regime(eta, regime_labels)
  md    <- fit_rank1_md(parts$Sigma_C, parts$Sigma_NC, weight = weight,
                        X_C = parts$X_C, X_NC = parts$X_NC)
  b <- md$theta

  n_vars <- dim(rawimp)[1]
  irf_mp <- matrix(0, n_vars, h + 1)
  for (j in seq_len(h + 1)) {
    irf_mp[, j] <- matrix(rawimp[, , j], nrow = n_vars) %*% b
  }

  # Same sign rule as the point estimate on every call (bootstrap included):
  # orient b so the policy-variable impact is positive. Redundant for the
  # normalized IRFs (the ratio below is sign-invariant) but pins down the
  # reported b and impact_pre.
  impact_pre <- if (!is.null(mpind)) irf_mp[mpind, 1] else NA_real_
  if (!is.null(mpind) && !is.na(impact_pre) && impact_pre < 0) {
    b          <- -b
    irf_mp     <- -irf_mp
    impact_pre <- -impact_pre
  }

  lambda_1    <- md$lambda_all[1]
  rank1_share <- abs(lambda_1) / sum(abs(md$lambda_all))

  if (isTRUE(diagnose)) {
    cat("\n========== ident_het_regimes DIAGNOSTIC ==========\n")
    cat(sprintf("regimes: n_C = %d, n_NC = %d\n", parts$n_C, parts$n_NC))
    cat(sprintf("eigenvalues of dSigma: %s\n",
                paste(sprintf("%.4f", md$lambda_all), collapse = "  ")))
    cat(sprintf("rank-1 share = %.3f\n", rank1_share))
    if (lambda_1 <= 0) {
      cat("[!!!] WARNING: leading eigenvalue <= 0 — A1 (higher policy-shock\n")
      cat("      variance in Copom months) is violated at this cell.\n")
    }
    cat(sprintf("b (impact column in factor space): %s\n",
                paste(sprintf("%.4f", b), collapse = "  ")))
    if (!is.null(mpind)) {
      cat(sprintf("impact_pre (mp var, pre-normalization) = %.4e\n", impact_pre))
    }
    if (md$weight == "optimal") {
      cat(sprintf("GMM J = %.3f (df = %d, chi2 p = %.4f)\n",
                  md$J, md$df, md$p_chi2))
    }
    impact_vec <- irf_mp[, 1]
    if (!is.null(var_names) && length(var_names) == length(impact_vec)) {
      names(impact_vec) <- var_names
    }
    cat("Impact (raw, pre-norm) per variable:\n")
    print(impact_vec)
    cat("==================================================\n\n")
  }

  if (!is.null(mpind)) {
    irf_mp <- irf_mp / irf_mp[mpind, 1] * normalize_value
  }

  list(
    irf_mp      = cumimp_transform(irf_mp, tcode),
    irf_mp_raw  = irf_mp,
    b           = b,
    lambda_all  = md$lambda_all,
    rank1_share = rank1_share,
    impact_pre  = impact_pre,
    md_fit      = md,
    n_C         = parts$n_C,
    n_NC        = parts$n_NC
  )
}


#' Strength diagnostics for the monthly heteroskedasticity identification
#'
#' The het analogue of the first-stage F: bootstrap CI for the leading
#' eigenvalue of dSigma, the variance ratio along the estimated impact
#' direction (in-sample direction, upward-biased — inference comes from
#' the permutation placebo, which destroys the calendar structure while
#' keeping the eta distribution).
#'
#' @param eta Factor innovations (T_eff x q).
#' @param regime_labels Character vector ("C"/"NC") aligned to eta rows.
#' @param n_boot Bootstrap replications for the CIs.
#' @param n_perm Permutations for the placebo p-value.
#' @param ci_level Coverage of the reported CIs.
#' @param seed Optional integer seed.
#'
#' @return List with lambda_1, lambda_1_ci, ratio_dir, ratio_dir_ci,
#'   rank1_share, p_perm (P(lambda_1_perm >= lambda_1_obs)), n_C, n_NC.
het_strength_stats <- function(eta, regime_labels,
                               n_boot = 1000L, n_perm = 1000L,
                               ci_level = 0.95, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  eta <- as.matrix(eta)

  stats_one <- function(labels) {
    parts <- split_by_regime(eta, labels)
    eig   <- eigen(parts$dSigma, symmetric = TRUE, only.values = TRUE)
    eig$values[1]
  }

  parts  <- split_by_regime(eta, regime_labels)
  eig    <- eigen(parts$dSigma, symmetric = TRUE)
  lambda_1 <- eig$values[1]
  b_unit   <- eig$vectors[, 1]

  proj      <- eta %*% b_unit
  ratio_dir <- stats::var(proj[regime_labels == "C"]) /
               stats::var(proj[regime_labels == "NC"])

  is_C  <- regime_labels == "C"
  eta_C <- eta[is_C, , drop = FALSE]
  eta_N <- eta[!is_C, , drop = FALSE]

  boot_lambda <- numeric(n_boot)
  boot_ratio  <- numeric(n_boot)
  for (b in seq_len(n_boot)) {
    idx_C <- sample.int(nrow(eta_C), nrow(eta_C), replace = TRUE)
    idx_N <- sample.int(nrow(eta_N), nrow(eta_N), replace = TRUE)
    eta_b <- rbind(eta_C[idx_C, , drop = FALSE], eta_N[idx_N, , drop = FALSE])
    lab_b <- rep(c("C", "NC"), c(length(idx_C), length(idx_N)))
    parts_b <- split_by_regime(eta_b, lab_b)
    eig_b   <- eigen(parts_b$dSigma, symmetric = TRUE)
    boot_lambda[b] <- eig_b$values[1]
    proj_b <- eta_b %*% eig_b$vectors[, 1]
    boot_ratio[b] <- stats::var(proj_b[lab_b == "C"]) /
                     stats::var(proj_b[lab_b == "NC"])
  }

  perm_lambda <- numeric(n_perm)
  for (s in seq_len(n_perm)) {
    perm_lambda[s] <- stats_one(sample(regime_labels))
  }

  alpha <- (1 - ci_level) / 2
  list(
    lambda_1      = lambda_1,
    lambda_1_ci   = unname(stats::quantile(boot_lambda, c(alpha, 1 - alpha))),
    ratio_dir     = ratio_dir,
    ratio_dir_ci  = unname(stats::quantile(boot_ratio, c(alpha, 1 - alpha))),
    rank1_share   = abs(lambda_1) / sum(abs(eig$values)),
    p_perm        = (sum(perm_lambda >= lambda_1) + 1L) / (n_perm + 1L),
    n_C           = parts$n_C,
    n_NC          = parts$n_NC
  )
}


#' Rigobon (2003, eq. 7) pairwise cross-product rank statistic
#'
#' Tests the non-proportionality rank condition pair by pair, anchored on
#' the policy direction: d_k = Var_C(s) Cov_NC(s, eta_k) -
#' Var_NC(s) Cov_C(s, eta_k), with s = eta %*% direction. Under
#' proportional covariance matrices every d_k = 0. Recommended by
#' Rigobon's Appendix over the determinant for small samples; complements
#' the proportionality LR of formal_rank_test_battery.
#'
#' @param eta Factor innovations (T_eff x q).
#' @param regime_labels Character vector ("C"/"NC") aligned to eta rows.
#' @param direction Numeric q-vector anchoring the policy direction
#'   (e.g., the estimated b or the mp row of the impact matrix).
#' @param n_boot Bootstrap replications for the CIs.
#' @param ci_level Coverage of the reported CIs.
#' @param seed Optional integer seed.
#'
#' @return Tibble with one row per eta component: d (statistic), ci_low,
#'   ci_high, rejects_zero.
rigobon_crossprod_test <- function(eta, regime_labels, direction,
                                   n_boot = 1000L, ci_level = 0.95,
                                   seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  eta <- as.matrix(eta)
  s   <- drop(eta %*% (direction / sqrt(sum(direction^2))))

  cross_stat <- function(s_vec, E, labels) {
    is_C <- labels == "C"
    v_C  <- stats::var(s_vec[is_C])
    v_N  <- stats::var(s_vec[!is_C])
    sapply(seq_len(ncol(E)), function(k) {
      c_C <- stats::cov(s_vec[is_C],  E[is_C, k])
      c_N <- stats::cov(s_vec[!is_C], E[!is_C, k])
      v_C * c_N - v_N * c_C
    })
  }

  d_obs <- cross_stat(s, eta, regime_labels)

  is_C  <- regime_labels == "C"
  idxs_C <- which(is_C)
  idxs_N <- which(!is_C)
  boot <- matrix(NA_real_, n_boot, ncol(eta))
  for (b in seq_len(n_boot)) {
    take <- c(sample(idxs_C, length(idxs_C), replace = TRUE),
              sample(idxs_N, length(idxs_N), replace = TRUE))
    lab  <- rep(c("C", "NC"), c(length(idxs_C), length(idxs_N)))
    boot[b, ] <- cross_stat(s[take], eta[take, , drop = FALSE], lab)
  }

  alpha <- (1 - ci_level) / 2
  ci <- apply(boot, 2, stats::quantile, probs = c(alpha, 1 - alpha))

  tibble::tibble(
    component    = seq_len(ncol(eta)),
    d            = d_obs,
    ci_low       = ci[1, ],
    ci_high      = ci[2, ],
    rejects_zero = ci[1, ] > 0 | ci[2, ] < 0
  )
}


#' Full-system identification from two volatility regimes
#'
#' Episode-regime (BPSS-style) identification: with Sigma_1 = B B' and
#' Sigma_2 = B Lambda B' (Lambda diagonal), B is recovered from the
#' generalized eigendecomposition of (Sigma_2, Sigma_1):
#' B = Sigma_1^{1/2} V with V the orthonormal eigenvectors of
#' Sigma_1^{-1/2} Sigma_2 Sigma_1^{-1/2} and Lambda the eigenvalues
#' (relative shock variances in regime 2). Point-identified up to column
#' sign/permutation iff the eigenvalues are distinct (Rigobon 2003;
#' Lanne-Lutkepohl 2008). Columns are returned sorted by decreasing
#' lambda; distinctness is summarized by the minimum relative gap.
#'
#' Requires mat_sym_sqrt / mat_sym_inv_sqrt from
#' R/identification/het_shock_extraction.R.
#'
#' @param Sigma_1 Covariance of eta in the reference regime.
#' @param Sigma_2 Covariance of eta in the comparison regime.
#'
#' @return List with B (q x q, columns = structural impact vectors in
#'   eta space, normalized so Lambda_1 = I), lambda (sorted decreasing),
#'   min_rel_gap (min over adjacent pairs of (l_i - l_{i+1}) / l_i).
fit_two_regime_system <- function(Sigma_1, Sigma_2) {
  S1_half     <- mat_sym_sqrt(Sigma_1)
  S1_inv_half <- mat_sym_inv_sqrt(Sigma_1)

  W   <- S1_inv_half %*% Sigma_2 %*% S1_inv_half
  eig <- eigen(W, symmetric = TRUE)

  B      <- S1_half %*% eig$vectors
  lambda <- eig$values

  gaps <- (lambda[-length(lambda)] - lambda[-1]) /
    pmax(abs(lambda[-length(lambda)]), 1e-12)

  list(B = B, lambda = lambda, min_rel_gap = min(gaps))
}


#' Relative variance profile of fixed structural shocks across episodes
#'
#' Holds B fixed (from fit_two_regime_system) and reports the diagonal of
#' B^{-1} Sigma_s B^{-1}' per episode — the BPSS-style variance path of
#' each structural shock. Off-diagonal mass is summarized per episode as
#' a check on the constancy of B (should be ~0 if the two-regime B also
#' diagonalizes the finer episodes).
#'
#' @param eta Factor innovations (T_eff x q).
#' @param episode_labels Character vector of episode names, aligned to eta.
#' @param B Structural impact matrix from fit_two_regime_system.
#'
#' @return Tibble with one row per (episode, shock): n_obs, rel_var,
#'   offdiag_share (episode-level, repeated across shocks).
episode_variance_profile <- function(eta, episode_labels, B) {
  B_inv <- solve(B)
  purrr::map_dfr(unique(episode_labels), function(ep) {
    rows <- episode_labels == ep
    X    <- sweep(eta[rows, , drop = FALSE], 2,
                  colMeans(eta[rows, , drop = FALSE]))
    Sig  <- crossprod(X) / (nrow(X) - 1L)
    Lam  <- B_inv %*% Sig %*% t(B_inv)
    tibble::tibble(
      episode       = ep,
      shock         = seq_len(ncol(B)),
      n_obs         = sum(rows),
      rel_var       = diag(Lam),
      offdiag_share = sum(abs(Lam[lower.tri(Lam)])) /
        (sum(abs(Lam[lower.tri(Lam)])) + sum(abs(diag(Lam))))
    )
  })
}


#' Fieller confidence interval for a ratio from bootstrap draws
#'
#' Weak-identification-robust interval for rho = E[num]/E[den] built from
#' the joint bootstrap distribution of numerator and denominator
#' (Fieller 1954). Unlike the delta method or the percentile interval of
#' the ratio, the set is allowed to be unbounded when the denominator is
#' weakly separated from zero — the honest outcome under weak
#' heteroskedasticity (Stock-Watson 2016 sec. 4.5.3).
#'
#' @param num_draws Bootstrap draws of the numerator.
#' @param den_draws Bootstrap draws of the denominator (paired).
#' @param level Confidence level.
#'
#' @return List with lower, upper, bounded (FALSE when the set is the
#'   complement of an interval or the whole line; lower/upper then carry
#'   the excluded interval or -Inf/Inf).
fieller_ratio_ci <- function(num_draws, den_draws, level = 0.90) {
  z  <- stats::qnorm(1 - (1 - level) / 2)
  mu_n <- mean(num_draws)
  mu_d <- mean(den_draws)
  v_nn <- stats::var(num_draws)
  v_dd <- stats::var(den_draws)
  v_nd <- stats::cov(num_draws, den_draws)

  a <- mu_d^2 - z^2 * v_dd
  b <- -2 * (mu_n * mu_d - z^2 * v_nd)
  c <- mu_n^2 - z^2 * v_nn
  disc <- b^2 - 4 * a * c

  if (a > 0 && disc >= 0) {
    roots <- sort((-b + c(-1, 1) * sqrt(disc)) / (2 * a))
    list(lower = roots[1], upper = roots[2], bounded = TRUE)
  } else if (a < 0 && disc >= 0) {
    roots <- sort((-b + c(-1, 1) * sqrt(disc)) / (2 * a))
    list(lower = roots[1], upper = roots[2], bounded = FALSE)
  } else {
    list(lower = -Inf, upper = Inf, bounded = FALSE)
  }
}
