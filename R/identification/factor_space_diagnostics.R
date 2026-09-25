# ===================================================================
# Factor-space diagnostics for proxy-SVAR identification
# Reports MOSW relevance and impact response of the policy variable
# for arbitrary (DFM, instrument) pairs without building the IRF sets.
# Also holds the two relevance statistics: the MOSW Wald (xi) and the
# robust first-stage F.
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
#'   Under `covid_volatility` with `innovations = "standardized"`, H is the
#'   uncentered moment and z is residualized on the transformed regressors
#'   `(1, lags) / s_t`, as in `ar_dfm_bands()`; `"raw"` aborts.
#' @param instrument_df Data.frame with columns `month` (Date) and `shock` (numeric).
#' @param dates Date vector aligned with the data panel rows.
#' @param p VAR lag order used in `estimate_dfm`.
#' @param mp_var_idx Column index of the policy variable.
#' @param nw_lags Newey-West truncation lag passed to
#'   `compute_factor_space_wald`. Default 0 (Eicker-White) reproduces every
#'   published number in this project.
#' @param return_moment_inputs If TRUE, also return the aligned triple
#'   (`eta_sel`, `Z_sel`, `ctrl_sel`), the direction `c_mp`, the aligned
#'   month dates and `intercept`, so a caller can recompute the Gamma moment
#'   on a subsample without re-estimating the DFM (leave-one-month-out).
#'   `intercept` is FALSE when `ctrl_sel` already carries the transformed
#'   constant of the COVID volatility treatment, and goes on to
#'   `compute_factor_space_wald()`. Off by default because these are large and
#'   grid callers keep hundreds of cells in memory.
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
  covid <- dfm_results$covid_volatility
  if (!is.null(covid) && covid$innovations != "standardized") {
    stop("diagnose_instrument_in_factor_space: under covid_volatility with ",
         "innovations = \"raw\" the Shat correction mixes the transformed and ",
         "the raw regressors and is not derived ",
         "(notas/2026-09-14_inferencia_volatilidade_covid_q.md).")
  }
  align     <- sel_ext_inst_sample(dates, p, instrument_df)
  inst_sel  <- align$inst_sel
  sel_ind   <- align$rsh_sel_ind

  K      <- dfm_results$dynamic_loadings
  M      <- dfm_results$dynamic_scaling
  Lambda <- dfm_results$static_loadings
  sy     <- dfm_results$data_sd

  eta <- extract_dynamic_innovations(dfm_results)

  eta_sel <- eta[sel_ind, , drop = FALSE]
  # Centered as ident_ext_instr() centers: not under the COVID volatility
  rsh_id <- eta_sel
  if (is.null(covid)) {
    rsh_id <- sweep(eta_sel, 2, colMeans(eta_sel))
  }
  Z_mat <- as.matrix(inst_sel)

  H <- drop(crossprod(Z_mat, rsh_id)) / drop(crossprod(Z_mat))

  # Impact response (h=0): rawimp[, , 1] = Lambda %*% K %*% M, scaled by sy
  rawimp_0 <- sweep(Lambda %*% K %*% M, 1, sy, "*")
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
  # Under the COVID volatility the estimating equation divides every row,
  # constant included, by s_t: z is residualized on (1, lags) / s_t, which
  # already carries the deterministic column
  intercept <- is.null(covid)
  if (!intercept) {
    ctrl_sel <- (cbind(1, ctrl) / dfm_results$volatility_path)[sel_ind, , drop = FALSE]
  }

  # Both MOSW diagnostics use the factor-implied innovation of the variable
  # that normalizes the structural shock.
  c_mp   <- as.numeric(rawimp_0[mp_var_idx, ])
  eta_mp <- as.numeric(eta_sel %*% c_mp)
  wald_mp <- compute_factor_space_wald(eta_mp, Z_mat,
                                       controls = ctrl_sel,
                                       nw_lags = nw_lags,
                                       intercept = intercept)$wald_joint
  first_stage <- compute_robust_first_stage_F(
    eta_mp,
    Z_mat,
    controls = ctrl_sel,
    nw_lags = nw_lags,
    intercept = intercept
  )

  moment_inputs <- if (isTRUE(return_moment_inputs)) {
    list(eta_sel   = eta_sel,
         Z_sel     = Z_mat,
         ctrl_sel  = ctrl_sel,
         c_mp      = c_mp,
         months    = dates[(p + 1):length(dates)][sel_ind],
         intercept = intercept)
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


#' Montiel Olea-Stock-Watson Wald statistic for instrument relevance
#'
#' Implements the relevance diagnostics of Montiel Olea, Stock & Watson
#' (2021, J. Econometrics, sec. 4.2) against the q factor innovations, with
#' `Gamma = (1/T) sum_t z_t eta_t` and `W` the Eicker-White covariance of the
#' moment `z_t eta_t` (Newey-West with 0 lags, `NWlags = 0` in the authors'
#' applications). z is residualized on the factor-VAR regressors first, which
#' reproduces the Shat correction of `CovAhat_Sigmahat_Gamma.m`. Called with
#' the scalar innovation of the policy variable, `wald_joint` is `xi_mp`.
#'
#' @param eta Matrix of factor innovations (T x q).
#' @param Z Instrument vector or column matrix (T x 1), aligned to eta.
#' @param controls Matrix of factor-VAR regressors aligned to eta.
#' @param nw_lags Newey-West truncation lag for W. The default 0 is the
#'   Eicker-White estimator and reproduces `NWlags = 0` of the oil application
#'   (`codigos_externos/codigo_olea/OilSVARIV.m:50`), which every published
#'   number assumes. Values > 0 apply the Bartlett kernel of
#'   `codigos_externos/codigo_olea/functions/RForm/NW_hac_STATA.m`, needed only
#'   when the moment is serially correlated; the tax application uses
#'   `NWlags = 8` (`TaxSVARIV.m:52`).
#' @param intercept Add a constant to `controls` before residualizing z, as
#'   the OLS factor VAR carries one. FALSE when `controls` already hold the
#'   deterministic column: under the COVID volatility treatment the regressors
#'   are divided by `s_t` and the constant becomes `1/s_t`.
#'
#' @return List with `wald_k` (length-q vector), `wald_joint`, `q`, `T_eff`,
#'   and `nw_lags`.
#'
#' @examples
#' xi_mp <- compute_factor_space_wald(eta_mp, z, controls = X_lags)$wald_joint
compute_factor_space_wald <- function(eta, Z, controls, nw_lags = 0L,
                                      intercept = TRUE) {
  eta <- as.matrix(eta)
  Z <- as.numeric(Z)
  T_eff <- length(Z)

  regressors <- if (intercept) {
    cbind(1, as.matrix(controls))
  } else {
    as.matrix(controls)
  }
  z_residual <- as.numeric(qr.resid(qr(regressors), Z))

  # T x q, row t is z_t eta_t'
  moments <- z_residual * eta
  Gamma <- colMeans(moments)
  moments_centered <- sweep(moments, 2, Gamma)

  # Bartlett accumulation, transcribed from NW_hac_STATA.m: weight
  # 1 - l/(lags+1), divisor T (no degrees-of-freedom correction). With
  # nw_lags = 0 nothing is added and W is the Eicker-White estimator.
  weighted_autocovariances <- purrr::map(seq_len(nw_lags), \(l) {
    autocovariance <- crossprod(
      moments_centered[seq_len(T_eff - l), , drop = FALSE],
      moments_centered[(1L + l):T_eff, , drop = FALSE]
    ) / T_eff
    (1 - l / (nw_lags + 1)) * (autocovariance + t(autocovariance))
  })
  W <- purrr::reduce(
    weighted_autocovariances,
    `+`,
    .init = crossprod(moments_centered) / T_eff
  )

  list(
    wald_k = T_eff * Gamma^2 / diag(W),
    wald_joint = T_eff * drop(t(Gamma) %*% solve(W, Gamma)),
    q = ncol(eta),
    T_eff = T_eff,
    nw_lags = nw_lags
  )
}


#' Robust first-stage F in the policy-variable normalization direction
#'
#' Regresses the factor-implied innovation of the policy variable on the
#' external instrument and the factor-VAR controls. The statistic is the
#' squared robust t-statistic on the instrument. HC1 reproduces the finite-
#' sample convention behind the first-stage F reported by Montiel Olea, Stock
#' and Watson; positive `nw_lags` use a Bartlett Newey-West covariance.
#'
#' @param target_innovation Numeric vector `c_mp' eta_t` aligned with `Z`.
#' @param Z Instrument vector or one-column matrix.
#' @param controls Matrix of factor-VAR regressors aligned with `Z`.
#' @param nw_lags Newey-West truncation lag. Zero uses HC1.
#' @param intercept Include an intercept. FALSE when `controls` already carry
#'   the deterministic column, as the regressors of the COVID volatility
#'   treatment do (divided by `s_t`, the constant becomes `1/s_t`).
#'
#' @return List with `f_statistic`, `beta`, `se`, `p_value`, `n_obs`, and
#'   `nw_lags`.
#'
#' @examples
#' fs <- compute_robust_first_stage_F(eta_mp, z, controls = X_lags)
compute_robust_first_stage_F <- function(target_innovation, Z, controls,
                                         nw_lags = 0L, intercept = TRUE) {
  y <- as.numeric(target_innovation)
  z <- as.numeric(Z)
  controls <- as.matrix(controls)

  fit <- if (intercept) lm(y ~ z + controls) else lm(y ~ 0 + z + controls)
  covariance <- if (nw_lags == 0L) {
    sandwich::vcovHC(fit, type = "HC1")
  } else {
    sandwich::NeweyWest(fit, lag = nw_lags, prewhite = FALSE, adjust = TRUE)
  }

  beta <- unname(coef(fit)["z"])
  se <- sqrt(covariance["z", "z"])
  f_statistic <- (beta / se)^2

  list(
    f_statistic = f_statistic,
    beta = beta,
    se = se,
    p_value = pf(
      f_statistic,
      df1 = 1,
      df2 = df.residual(fit),
      lower.tail = FALSE
    ),
    n_obs = nobs(fit),
    nw_lags = nw_lags
  )
}
