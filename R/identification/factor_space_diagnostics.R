# ===================================================================
# Factor-space diagnostics for proxy-SVAR identification
# Reports F (factor-space) and impact response of the policy variable
# for arbitrary (DFM, instrument) pairs without running the bootstrap.
# ===================================================================


#' Project a candidate instrument through factor space and report relevance
#'
#' Runs the proxy-SVAR identification step (`H = (Z' eta)/(Z'Z)`) on a
#' pre-estimated DFM, computes the impact response of the policy variable,
#' and reports the factor-space first-stage F. Used to score candidate
#' instruments before deciding which to feed into the full IRF pipeline.
#'
#' @param dfm_results Output of `estimate_dfm` containing `var_residuals`,
#'   `dynamic_loadings`, `dynamic_scaling`, `static_loadings`, `data_sd`.
#' @param instrument_df Data.frame with columns `month` (Date) and `shock` (numeric).
#' @param dates Date vector aligned with the data panel rows.
#' @param p VAR lag order used in `estimate_dfm`.
#' @param mp_var_idx Column index of the policy variable.
#'
#' @return List with `f_factor`, `impact_mp` (pre-normalization impact response
#'   of the policy variable), `sign_mp`, `n_obs`, and `H` (factor-space loadings).
diagnose_instrument_in_factor_space <- function(dfm_results, instrument_df,
                                                dates, p, mp_var_idx) {
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

  f_factor <- compute_factor_space_F(rsh_mean0, Z_mat)

  list(
    f_factor = f_factor,
    impact_mp = impact_mp,
    sign_mp  = sign(impact_mp),
    n_obs    = sum(sel_ind),
    H        = H
  )
}
