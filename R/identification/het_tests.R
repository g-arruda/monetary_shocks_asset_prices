# ===================================================================
# GENERIC TEST BATTERY FOR IDENTIFICATION THROUGH HETEROSKEDASTICITY
#
# Extracted 2026-08-01 from arquivo/R/identification/het_shock_extraction.R.
# These functions take a demeaned within-regime split (X_C, X_NC) or a
# changes matrix plus regime labels and know nothing about the frequency
# of the data: they serve the monthly factor-innovation design in
# het_primary.R exactly as they served the daily Wed->Thu design.
#
# What stayed archived is the DAILY EXTRACTION half of that module
# (build_daily_regimes, extract_di_change, extract_price_change,
# extract_shock_rigobon_sack, aggregate_shock_to_monthly,
# build_het_instrument). The daily object is out of scope for this round,
# and the z_het instrument built from it was empirically rejected
# (xi_mp 0.45-1.95; historico_decisoes.md §1.1).
#
# mat_sym_sqrt / mat_sym_inv_sqrt, used by rigobon_proportionality_test,
# are defined in het_primary.R, which this file assumes is sourced first.
# ===================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
})

#' Validate the variance split between C and NC regimes
#'
#' Replicates GRG (2025) Table 1: per-variable variance under each regime,
#' ratio var_C / var_NC, and a bootstrap confidence interval for the ratio.
#' Identification requires var_C / var_NC > 1 (with CI excluding 1) for the
#' policy variable, and CIs including 1 for the remaining variables.
#'
#' @param changes_matrix Numeric matrix N_pairs x k_d of Wed-to-Thu changes.
#' @param regime_table Output of build_daily_regimes() aligned to changes.
#' @param alpha Significance level for the bootstrap CI (default 0.01).
#' @param n_boot Number of bootstrap replications (default 1000).
#' @param seed Optional integer seed for reproducibility.
#'
#' @details
#' NA handling is per-column (not row-wise): n_C and n_NC may differ across
#' variables. extract_shock_rigobon_sack() instead drops rows with any NA, so
#' its sample is a subset of what the variance test sees.
#'
#' @return Tibble with one row per variable: var, n_C, n_NC, var_C, var_NC,
#'   ratio, ci_low, ci_high.
validate_variance_split <- function(changes_matrix,
                                    regime_table,
                                    alpha = 0.01,
                                    n_boot = 1000L,
                                    seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  is_C <- regime_table$regime == "C"

  vars <- colnames(changes_matrix)
  if (is.null(vars)) vars <- paste0("V", seq_len(ncol(changes_matrix)))

  purrr::map_dfr(seq_along(vars), function(j) {
    x   <- changes_matrix[, j]
    xC  <- x[is_C]
    xNC <- x[!is_C]
    xC  <- xC[!is.na(xC)]
    xNC <- xNC[!is.na(xNC)]

    v_C  <- var(xC)
    v_NC <- var(xNC)

    boot <- replicate(n_boot, {
      var(sample(xC,  replace = TRUE)) /
      var(sample(xNC, replace = TRUE))
    })
    ci <- stats::quantile(boot, probs = c(alpha / 2, 1 - alpha / 2), na.rm = TRUE)

    tibble::tibble(
      var     = vars[j],
      n_C     = length(xC),
      n_NC    = length(xNC),
      var_C   = v_C,
      var_NC  = v_NC,
      ratio   = v_C / v_NC,
      ci_low  = unname(ci[1]),
      ci_high = unname(ci[2])
    )
  })
}


#' Rigobon (2003) Proposition 1 proportionality test
#'
#' Tests the rank condition for identification through heteroskedasticity:
#' H0: Sigma_C = a * Sigma_NC for some scalar a > 0 vs H1: not proportional.
#' Failure to reject means the two regimes' covariance matrices are similar
#' up to scale, so dSigma carries no rotation and b_1 is undefined.
#'
#' Implements Mauchly's modified LR statistic (Anderson 1984 §10.8). With
#' gamma_i = eigenvalues of Sigma_C * Sigma_NC^{-1},
#'   W  = (prod gamma_i) / (mean(gamma_i))^k
#'   LR = -n_eff * log(W),    n_eff = (n_C * n_NC) / (n_C + n_NC)
#' Asymptotically LR ~ chi^2(k(k+1)/2 - 1). With small n_C the asymptotic
#' approximation is unreliable, so the bootstrap p-value should be preferred.
#' The bootstrap imposes H0 by re-scaling X_C to have variance a_hat * Sigma_NC
#' (a_hat = geometric mean of gamma_i) before resampling within regime.
#'
#' @param X_C Numeric matrix n_C x k of demeaned within-C observations.
#' @param X_NC Numeric matrix n_NC x k of demeaned within-NC observations.
#' @param n_boot Number of bootstrap replications (default 1000).
#' @param seed Optional integer seed for reproducibility.
#'
#' @return List with statistic, df, p_chi2, p_boot, n_boot.
rigobon_proportionality_test <- function(X_C, X_NC,
                                         n_boot = 1000L, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  k    <- ncol(X_C)
  n_C  <- nrow(X_C)
  n_NC <- nrow(X_NC)
  n_eff <- (n_C * n_NC) / (n_C + n_NC)

  Sigma_C  <- crossprod(X_C)  / (n_C  - 1L)
  Sigma_NC <- crossprod(X_NC) / (n_NC - 1L)

  mauchly_stat <- function(S_C, S_NC) {
    # Generalized eigenvalues of S_C in the metric of S_NC.
    M <- solve(S_NC, S_C)
    gamma <- abs(eigen(M, only.values = TRUE)$values)
    W <- prod(gamma) / (mean(gamma))^k
    -n_eff * log(W)
  }

  stat_obs <- mauchly_stat(Sigma_C, Sigma_NC)
  df       <- k * (k + 1L) / 2L - 1L
  p_chi2   <- stats::pchisq(stat_obs, df = df, lower.tail = FALSE)

  # Bootstrap under H0: rescale X_C so its covariance equals a_hat * Sigma_NC.
  a_hat <- prod(abs(eigen(solve(Sigma_NC, Sigma_C),
                          only.values = TRUE)$values))^(1 / k)
  Sigma_C_H0 <- a_hat * Sigma_NC
  T_C <- mat_sym_sqrt(Sigma_C_H0) %*% mat_sym_inv_sqrt(Sigma_C)
  X_C_H0 <- X_C %*% t(T_C)

  stat_boot <- numeric(n_boot)
  for (b in seq_len(n_boot)) {
    idx_C  <- sample.int(n_C,  n_C,  replace = TRUE)
    idx_NC <- sample.int(n_NC, n_NC, replace = TRUE)
    Xb_C   <- X_C_H0[idx_C, , drop = FALSE]
    Xb_NC  <- X_NC  [idx_NC, , drop = FALSE]
    Sb_C   <- crossprod(Xb_C)  / (n_C  - 1L)
    Sb_NC  <- crossprod(Xb_NC) / (n_NC - 1L)
    stat_boot[b] <- mauchly_stat(Sb_C, Sb_NC)
  }

  p_boot <- (sum(stat_boot >= stat_obs) + 1L) / (n_boot + 1L)

  list(
    test       = "rigobon_prop1_proportionality",
    statistic  = stat_obs,
    df         = df,
    p_chi2     = p_chi2,
    p_boot     = p_boot,
    n_boot     = n_boot,
    a_hat      = a_hat
  )
}

#' Lanne-Lütkepohl (2008) LR rank test on dSigma
#'
#' Tests H0: rank(dSigma) <= r0 vs H1: rank(dSigma) > r0. The Wilks LR
#' statistic for the generalized eigenproblem (Sigma_C, Sigma_NC) follows
#' from concentrated multivariate-normal log-likelihood: under H0 the
#' smallest k - r0 generalized eigenvalues lambda_i = eigvals(Sigma_C,
#' Sigma_NC) are equal to 1 (the corresponding shocks have the same
#' variance in both regimes). The deviation
#'   LR = ((n_C + n_NC) / 2) * sum_{i > r0} (log lambda_i + 1 / lambda_i - 1)
#' vanishes at the null and grows monotonically with rank > r0. This is
#' the form derived in Lanne-Lütkepohl (2008, JMCB) and equivalent to the
#' Wilks LR for proportionality of two MV-normal covariance matrices on
#' the lower (k - r0)-dimensional subspace. Asymptotically chi^2 with
#' df = (k - r0)(k - r0 + 1) / 2; bootstrap-calibrated under H0 by
#' simulating dSigma from the leading r0 eigenpairs.
#'
#' @param X_C Numeric matrix n_C x k of demeaned within-C observations.
#' @param X_NC Numeric matrix n_NC x k of demeaned within-NC observations.
#' @param r0 Hypothesized rank under H0 (default 1).
#' @param n_boot Number of bootstrap replications (default 1000).
#' @param seed Optional integer seed for reproducibility.
#'
#' @return List with statistic, df, p_chi2, p_boot, n_boot, r0.
rank1_lr_test <- function(X_C, X_NC, r0 = 1L,
                          n_boot = 1000L, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  k    <- ncol(X_C)
  n_C  <- nrow(X_C)
  n_NC <- nrow(X_NC)
  n_eff <- n_C + n_NC

  Sigma_C  <- crossprod(X_C)  / (n_C  - 1L)
  Sigma_NC <- crossprod(X_NC) / (n_NC - 1L)
  dSigma   <- Sigma_C - Sigma_NC

  gen_eig <- function(dS, S_NC) {
    # Eigenvalues of S_NC^{-1/2} dS S_NC^{-1/2}: same spectrum as the
    # generalized problem (dS, S_NC) but symmetric so eigen() is stable.
    # gamma here = lambda(Sigma_C, Sigma_NC) - 1.
    M <- mat_sym_inv_sqrt(S_NC) %*% dS %*% mat_sym_inv_sqrt(S_NC)
    eigen(M, symmetric = TRUE, only.values = TRUE)$values
  }

  rank_stat <- function(gamma_vec, r0) {
    # Order eigenvalues of (Sigma_C, Sigma_NC) by deviation from 1, keep
    # the (k - r0) closest to 1 -- those are constrained to equal 1
    # under H0. lambda > 0 always since both Sigma matrices are PD.
    lambda <- 1 + gamma_vec
    lambda <- pmax(lambda, 1e-10)
    ord    <- order(abs(log(lambda)), decreasing = TRUE)
    null_lambda <- lambda[ord[(r0 + 1L):length(lambda)]]
    (n_eff / 2) * sum(log(null_lambda) + 1 / null_lambda - 1)
  }

  gamma_obs <- gen_eig(dSigma, Sigma_NC)
  stat_obs  <- rank_stat(gamma_obs, r0)
  df        <- (k - r0) * (k - r0 + 1L) / 2L
  p_chi2    <- stats::pchisq(stat_obs, df = df, lower.tail = FALSE)

  # H0 bootstrap: build dSigma under rank = r0 from the top-r0 eigenpairs.
  M_obs   <- mat_sym_inv_sqrt(Sigma_NC) %*% dSigma %*% mat_sym_inv_sqrt(Sigma_NC)
  e_obs   <- eigen(M_obs, symmetric = TRUE)
  ord     <- order(abs(e_obs$values), decreasing = TRUE)
  gam_top <- e_obs$values [ord[seq_len(r0)]]
  vec_top <- e_obs$vectors[, ord[seq_len(r0)], drop = FALSE]
  M_H0    <- vec_top %*% diag(gam_top, nrow = r0) %*% t(vec_top)
  S_NC_sqrt <- mat_sym_sqrt(Sigma_NC)
  dSigma_H0 <- S_NC_sqrt %*% M_H0 %*% S_NC_sqrt
  Sigma_C_H0 <- Sigma_NC + dSigma_H0
  # Project onto PSD cone if numerical noise pushed eigenvalues negative.
  e_proj <- eigen(Sigma_C_H0, symmetric = TRUE)
  Sigma_C_H0 <- e_proj$vectors %*%
                diag(pmax(e_proj$values, 1e-10), nrow = length(e_proj$values)) %*%
                t(e_proj$vectors)

  T_C <- mat_sym_sqrt(Sigma_C_H0) %*% mat_sym_inv_sqrt(Sigma_C)
  X_C_H0 <- X_C %*% t(T_C)

  stat_boot <- numeric(n_boot)
  for (b in seq_len(n_boot)) {
    idx_C  <- sample.int(n_C,  n_C,  replace = TRUE)
    idx_NC <- sample.int(n_NC, n_NC, replace = TRUE)
    Xb_C   <- X_C_H0[idx_C, , drop = FALSE]
    Xb_NC  <- X_NC  [idx_NC, , drop = FALSE]
    Sb_C   <- crossprod(Xb_C)  / (n_C  - 1L)
    Sb_NC  <- crossprod(Xb_NC) / (n_NC - 1L)
    gamma_b <- gen_eig(Sb_C - Sb_NC, Sb_NC)
    stat_boot[b] <- rank_stat(gamma_b, r0)
  }

  p_boot <- (sum(stat_boot >= stat_obs) + 1L) / (n_boot + 1L)

  list(
    test       = "lanne_lutkepohl_rank1",
    r0         = r0,
    statistic  = stat_obs,
    df         = df,
    p_chi2     = p_chi2,
    p_boot     = p_boot,
    n_boot     = n_boot
  )
}

#' Bootstrap confidence interval for the rank-1 share of dSigma
#'
#' Resamples within-regime rows (no H0 imposed) and returns quantiles of
#' rank1_share = |lambda_1| / sum(|lambda_j|) of the bootstrap dSigma.
#' Descriptor statistic to sit alongside the formal LR tests.
#'
#' @param X_C Numeric matrix n_C x k of demeaned within-C observations.
#' @param X_NC Numeric matrix n_NC x k of demeaned within-NC observations.
#' @param n_boot Number of bootstrap replications (default 1000).
#' @param ci_level Coverage of the returned CI (default 0.95).
#' @param seed Optional integer seed for reproducibility.
#'
#' @return List with share_point, share_lo, share_hi, ci_level, n_boot.
bootstrap_rank1_share_ci <- function(X_C, X_NC,
                                     n_boot = 1000L, ci_level = 0.95,
                                     seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  n_C  <- nrow(X_C)
  n_NC <- nrow(X_NC)

  share_one <- function(Xc, Xn) {
    Sc <- crossprod(Xc) / (nrow(Xc) - 1L)
    Sn <- crossprod(Xn) / (nrow(Xn) - 1L)
    lam <- eigen(Sc - Sn, symmetric = TRUE, only.values = TRUE)$values
    abs(lam[1]) / sum(abs(lam))
  }

  share_obs <- share_one(X_C, X_NC)

  share_boot <- numeric(n_boot)
  for (b in seq_len(n_boot)) {
    idx_C  <- sample.int(n_C,  n_C,  replace = TRUE)
    idx_NC <- sample.int(n_NC, n_NC, replace = TRUE)
    share_boot[b] <- share_one(X_C[idx_C, , drop = FALSE],
                               X_NC[idx_NC, , drop = FALSE])
  }

  alpha <- (1 - ci_level) / 2
  q     <- stats::quantile(share_boot, probs = c(alpha, 1 - alpha), na.rm = TRUE)

  list(
    share_point = share_obs,
    share_lo    = unname(q[1]),
    share_hi    = unname(q[2]),
    ci_level    = ci_level,
    n_boot      = n_boot
  )
}

#' Run the full formal rank-test battery on (Sigma_C, Sigma_NC)
#'
#' Convenience wrapper that combines Rigobon (2003) Proposition 1 (Gate A:
#' rejection means dSigma is not the zero matrix scaled by a constant), the
#' Lanne-Lütkepohl (2008) rank-1 LR test (Gate B: failure to reject means a
#' rank-1 approximation is adequate), and a bootstrap CI on the rank-1 share.
#' Sharing seeds and bootstrap replications across all three keeps the report
#' table reproducible from a single call.
#'
#' Hansen J overidentification test is unavailable in the R = 2, K = 0 setup
#' (Rigobon 2003 Proposition 2: df = 0); to unlock it the NC regime would
#' have to be sub-split into >= 3 windows.
#'
#' @param X_C Numeric matrix n_C x k of demeaned within-C observations.
#' @param X_NC Numeric matrix n_NC x k of demeaned within-NC observations.
#' @param n_boot Number of bootstrap replications (default 1000).
#' @param seed Optional integer seed for reproducibility.
#'
#' @return List with three components: prop_test, rank1_test, share_ci.
formal_rank_test_battery <- function(X_C, X_NC,
                                     n_boot = 1000L, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  prop_seed  <- if (is.null(seed)) NULL else seed
  rank_seed  <- if (is.null(seed)) NULL else seed + 1L
  share_seed <- if (is.null(seed)) NULL else seed + 2L

  list(
    prop_test  = rigobon_proportionality_test(X_C, X_NC,
                                              n_boot = n_boot, seed = prop_seed),
    rank1_test = rank1_lr_test(X_C, X_NC,
                               r0 = 1L, n_boot = n_boot, seed = rank_seed),
    share_ci   = bootstrap_rank1_share_ci(X_C, X_NC,
                                          n_boot = n_boot, seed = share_seed)
  )
}


#' Classify A2 (non-policy homoskedasticity) verdict from a variance-split table
#'
#' Adds an `a2_status` column to the output of `validate_variance_split`:
#' "policy"   for the policy variable (A1, not A2);
#' "violated" if the bootstrap CI for var_C / var_NC excludes 1 from either side;
#' "pass"     otherwise.
#'
#' Identification by heteroskedasticity (Rigobon-Sack 2003) requires CIs that
#' include 1 for every non-policy variable. Violation by the high side ("upper")
#' indicates that some non-policy shock has higher variance on Copom days too,
#' so the leading eigenvector of dSigma is contaminated by a second shock.
#'
#' @param val_tbl Tibble returned by `validate_variance_split`.
#' @param mp_var  Name of the policy variable (matched against val_tbl$var).
#'
#' @return val_tbl with two extra columns: a2_status, a2_side
#'   (a2_side: NA for policy/pass; "upper" if ci_low > 1; "lower" if ci_high < 1).
classify_a2_verdict <- function(val_tbl, mp_var) {
  val_tbl |>
    dplyr::mutate(
      a2_status = dplyr::case_when(
        var == mp_var            ~ "policy",
        ci_low > 1 | ci_high < 1 ~ "violated",
        TRUE                     ~ "pass"
      ),
      a2_side = dplyr::case_when(
        a2_status != "violated" ~ NA_character_,
        ci_low > 1              ~ "upper",
        ci_high < 1             ~ "lower"
      )
    )
}
