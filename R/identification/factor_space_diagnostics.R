# ===================================================================
# Factor-space diagnostics for proxy-SVAR identification
# Reports MOSW relevance and impact response of the policy variable
# for arbitrary (DFM, instrument) pairs without running the bootstrap.
# ===================================================================


#' Project a candidate instrument through factor space and report relevance
#'
#' Runs the proxy-SVAR identification step (`H = (Z' eta)/(Z'Z)`) on a
#' pre-estimated DFM, computes the impact response of the policy variable,
#' and reports the relevance statistics in the normalization direction. Used to
#' score candidate instruments before deciding which to feed into the full IRF
#' pipeline.
#'
#' @param dfm_results Output of `estimate_dfm` containing `var_residuals`,
#'   `dynamic_loadings`, `dynamic_scaling`, `static_loadings`, `data_sd`.
#' @param instrument_df Data.frame with columns `month` (Date) and `shock` (numeric).
#' @param dates Date vector aligned with the data panel rows.
#' @param p VAR lag order used in `estimate_dfm`.
#' @param mp_var_idx Column index of the policy variable.
#' @param nw_lags Newey-West truncation lag passed to
#'   `compute_factor_space_wald`. Default 0 (Eicker-White) reproduces every
#'   published number in this project.
#' @param return_moment_inputs If TRUE, also return the aligned triple
#'   (`eta_sel`, `Z_sel`, `ctrl_sel`), the direction `c_mp` and the aligned
#'   month dates, so a caller can recompute the Gamma moment on a subsample
#'   without re-estimating the DFM (leave-one-month-out). Off by default
#'   because these are large and grid callers keep hundreds of cells in memory.
#'
#' @return List with `f_robust_mp`, `wald_mp`, `impact_mp`
#'   (pre-normalization impact response of the policy variable), `sign_mp`,
#'   `n_obs`, `H` (factor-space loadings), and the aligned moment inputs when
#'   requested. `f_robust_mp` and
#'   `wald_mp` use the same factor-implied innovation of the policy variable.
diagnose_instrument_in_factor_space <- function(dfm_results, instrument_df,
                                                dates, p, mp_var_idx,
                                                nw_lags = 0L,
                                                return_moment_inputs = FALSE) {
  align     <- sel_ext_inst_sample(dates, p, instrument_df)
  inst_sel  <- align$inst_sel
  sel_ind   <- align$rsh_sel_ind

  K      <- dfm_results$dynamic_loadings
  M      <- dfm_results$dynamic_scaling
  Lambda <- dfm_results$static_loadings
  u      <- dfm_results$var_residuals
  sy     <- dfm_results$data_sd

  if (!is.matrix(K) && !is.matrix(M)) {
    eta <- u
  } else {
    eta <- u %*% K %*% solve(M)
  }

  eta_sel   <- eta[sel_ind, , drop = FALSE]
  rsh_mean0 <- sweep(eta_sel, 2, colMeans(eta_sel))
  Z_mat     <- as.matrix(inst_sel)

  H <- drop(crossprod(Z_mat, rsh_mean0)) / drop(crossprod(Z_mat))

  # Impact response (h=0): rawimp[, , 1] = Lambda %*% K %*% M, scaled by sy
  if (!is.matrix(K) && !is.matrix(M)) {
    rawimp_0 <- Lambda * K * M
  } else {
    rawimp_0 <- Lambda %*% K %*% M
  }
  rawimp_0 <- sweep(rawimp_0, 1, sy, "*")
  impact_full <- as.numeric(rawimp_0 %*% H)
  impact_mp   <- impact_full[mp_var_idx]

  # MOSW Wald block: residualize Z on the factor-VAR regressors (lags of the
  # static factors + constant) — the Shat correction of
  # CovAhat_Sigmahat_Gamma.m applied in the factor space.
  F_stat <- dfm_results$static_factors
  T_f    <- nrow(F_stat)
  r_fac  <- ncol(F_stat)
  ctrl   <- matrix(NA_real_, T_f - p, r_fac * p)
  for (i in seq_len(p)) {
    ctrl[, ((i - 1) * r_fac + 1):(i * r_fac)] <-
      F_stat[(p + 1 - i):(T_f - i), , drop = FALSE]
  }
  ctrl_sel <- ctrl[sel_ind, , drop = FALSE]

  # Both MOSW diagnostics use the factor-implied innovation of the variable
  # that normalizes the structural shock.
  c_mp   <- as.numeric(rawimp_0[mp_var_idx, ])
  eta_mp <- as.numeric(eta_sel %*% c_mp)
  wald_mp <- compute_factor_space_wald(eta_mp, Z_mat,
                                       controls = ctrl_sel,
                                       nw_lags = nw_lags)$wald_joint
  first_stage <- compute_robust_first_stage_F(
    eta_mp,
    Z_mat,
    controls = ctrl_sel,
    nw_lags = nw_lags
  )

  moment_inputs <- if (isTRUE(return_moment_inputs)) {
    list(eta_sel  = eta_sel,
         Z_sel    = Z_mat,
         ctrl_sel = ctrl_sel,
         c_mp     = c_mp,
         months   = dates[(p + 1):length(dates)][sel_ind])
  } else NULL

  list(
    f_robust_mp = first_stage$f_statistic,
    first_stage_beta = first_stage$beta,
    first_stage_se = first_stage$se,
    first_stage_p = first_stage$p_value,
    impact_mp  = impact_mp,
    sign_mp    = sign(impact_mp),
    n_obs      = sum(sel_ind),
    H          = H,
    wald_mp    = wald_mp,
    nw_lags    = nw_lags,
    moment_inputs = moment_inputs
  )
}
