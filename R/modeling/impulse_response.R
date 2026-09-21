# ===================================================================
# Impulse responses of the DFM identified by an external instrument
# (proxy SVAR), following Alessi & Kerssenfischer and Gertler & Karadi (2015).
# ===================================================================


#' Align the external instrument to the factor-VAR residuals
#'
#' Equivalent to MATLAB `selextinstsample.m`. The residuals start at `p + 1`,
#' so the instrument has to be matched against `data_dates[(p+1):T]` and not
#' against the raw panel dates — getting this offset wrong shifts the whole
#' identification by `p` months. Part of the identification contract; see
#' `.claude/rules/identification.md`.
#'
#' @param data_dates Date vector of the estimation panel.
#' @param p Factor-VAR lag order.
#' @param instrument_df Data.frame with columns `month` (Date) and `shock`.
#'
#' @return List with `rsh_sel_ind` (logical index into the residuals) and
#'   `inst_sel` (the instrument on the common months).
#'
#' @examples
#' align <- sel_ext_inst_sample(dfm$dates, 4L, instrument)
sel_ext_inst_sample <- function(data_dates, p, instrument_df) {
  inst_dates <- as.Date(instrument_df$month)
  residual_dates <- data_dates[(p + 1):length(data_dates)]

  list(
    rsh_sel_ind = residual_dates %in% inst_dates,
    inst_sel = instrument_df$shock[inst_dates %in% residual_dates]
  )
}


#' Identification via external instrument (equivalent to IdentExtInstr.m)
#'
#' Projects the reduced-form responses on `H = (Z' eta) / (Z'Z)` (Stock-Watson
#' 2018, eq. 4) and normalizes the impact response of the policy variable to
#' `normalize_value`, in its native units: 0.005 is +50bp on the
#' decimal-proportion `yield_6m`.
#'
#' @param rawimp Reduced-form IRF array (n_vars x q x h+1).
#' @param rsh_sel Dynamic-factor innovations aligned with the instrument.
#' @param Z_sel Instrument vector aligned with `rsh_sel`.
#' @param h Horizon of the IRF (excluding impact).
#' @param mpind Index of the policy variable in `rawimp[, , 1]`.
#' @param normalize_value Target value of the policy variable's impact
#'   response, in its native units.
#' @param tcode Transformation codes for `cumimp_transform()`.
#' @param center If TRUE, demean the innovations before projecting, as
#'   `IdentExtInstr.m:5` does; a no-op for OLS residuals with a constant. FALSE
#'   keeps the uncentered moment of MOSW (`SVARIV.m:128`), which is what the
#'   COVID volatility treatment uses: its WLS residuals are orthogonal to the
#'   scaled constant `1/s_t`, not to 1.
#'
#' @return Matrix (vars x horizons) of normalized, tcode-transformed IRFs.
#'
#' @examples
#' irf <- ident_ext_instr(rawimp, eta_sel, z_sel, 48L, mpind, 0.005, tcode)
ident_ext_instr <- function(rawimp, rsh_sel, Z_sel, h, mpind, normalize_value,
                            tcode, center = TRUE) {
  rsh_id <- if (center) sweep(rsh_sel, 2, colMeans(rsh_sel)) else rsh_sel

  Z_mat <- as.matrix(Z_sel)
  H <- drop(crossprod(Z_mat, rsh_id)) / drop(crossprod(Z_mat))

  n_vars <- dim(rawimp)[1]
  irf_mp <- vapply(seq_len(h + 1), function(j) {
    drop(matrix(rawimp[, , j], nrow = n_vars) %*% H)
  }, numeric(n_vars))

  cumimp_transform(irf_mp / irf_mp[mpind, 1] * normalize_value, tcode)
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
  controls <- as.matrix(controls)
  colnames(controls) <- paste0("control_", seq_len(ncol(controls)))
  regression_data <- cbind(data.frame(y = as.numeric(target_innovation),
                                      z = as.numeric(Z)),
                           controls)

  fit <- lm(if (intercept) y ~ . else y ~ 0 + ., data = regression_data)
  covariance <- if (nw_lags == 0L) {
    sandwich::vcovHC(fit, type = "HC1")
  } else {
    sandwich::NeweyWest(fit, lag = nw_lags, prewhite = FALSE, adjust = TRUE)
  }

  beta <- unname(coef(fit)["z"])
  se   <- sqrt(covariance["z", "z"])
  f_statistic <- (beta / se)^2

  list(
    f_statistic = f_statistic,
    beta        = beta,
    se          = se,
    p_value     = pf(f_statistic, df1 = 1, df2 = df.residual(fit),
                     lower.tail = FALSE),
    n_obs       = nobs(fit),
    nw_lags     = nw_lags
  )
}


#' Montiel Olea-Stock-Watson Wald statistic for instrument relevance in factor space
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
  Z   <- as.numeric(Z)
  T_eff <- length(Z)

  regressors <- if (intercept) cbind(1, as.matrix(controls)) else as.matrix(controls)
  Z_use <- as.numeric(qr.resid(qr(regressors), Z))

  G_mat <- Z_use * eta                       # T x q, rows z_t * eta_t'
  Gamma <- colMeans(G_mat)
  V     <- sweep(G_mat, 2, Gamma)
  W     <- crossprod(V) / T_eff              # Eicker-White (NW lags = 0)

  # Bartlett accumulation, transcribed from NW_hac_STATA.m: weight
  # 1 - n/(lags+1), divisor T (no degrees-of-freedom correction), and
  # lags = 0 collapses exactly to the Eicker-White W above.
  for (l in seq_len(nw_lags)) {
    Gl <- crossprod(V[seq_len(T_eff - l), , drop = FALSE],
                    V[(1L + l):T_eff, , drop = FALSE]) / T_eff
    W  <- W + (1 - l / (nw_lags + 1)) * (Gl + t(Gl))
  }

  list(
    wald_k     = T_eff * Gamma^2 / diag(W),
    wald_joint = T_eff * drop(t(Gamma) %*% solve(W, Gamma)),
    q          = ncol(eta),
    T_eff      = T_eff,
    nw_lags    = nw_lags
  )
}


#' Put raw IRFs into economic units according to tcode
#'
#' Codes 1-5 are `cumimp.m`: 1 = level, 2 = first difference, 3 = second
#' difference, 4 = log-level, 5 = first log-difference. Code **6 has no
#' counterpart in AK** and is this project's: a monthly return put on the
#' percent scale (`x * 100`) **without** accumulating, for the asset block.
#' Note that **tcode 1 does not multiply by 100** — a trap documented in
#' `.claude/rules/identification.md`.
#'
#' @param Imp Matrix of raw IRFs (vars x horizons).
#' @param tcode Integer vector of transformation codes, one per variable.
#'
#' @return Matrix of the same shape, in economic units.
#'
#' @examples
#' irf <- cumimp_transform(irf_raw, infer_tcode_from_varnames(var_names))
cumimp_transform <- function(Imp, tcode) {
  cum <- t(apply(Imp, 1, cumsum))

  CC <- Imp
  CC[tcode == 2, ] <- cum[tcode == 2, ] * 100
  CC[tcode == 3, ] <- t(apply(cum, 1, cumsum))[tcode == 3, ]
  CC[tcode == 4, ] <- (exp(Imp[tcode == 4, ]) - 1) * 100
  CC[tcode == 5, ] <- (exp(cum[tcode == 5, ]) - 1) * 100
  CC[tcode == 6, ] <- Imp[tcode == 6, ] * 100
  CC
}


#' Assign transformation codes from panel variable names
#'
#' Everything is a level (1) except `base_*`, `credit*`/`credito_*`,
#' `fin_inst_reserve_req` and `pib` (log-level, 4) and `asset_*` (6). The
#' `asset_*` series are monthly returns (`download.R`: `prod(1 + r) - 1`); the
#' `cumsum` of code 2, used until 2026-08-17, integrated the sampling error
#' with the signal. h = 0 is invariant to that change.
#'
#' @param var_names Character vector of panel column names.
#'
#' @return Integer vector of tcodes aligned to `var_names`.
#'
#' @examples
#' tcode <- infer_tcode_from_varnames(colnames(panel))
infer_tcode_from_varnames <- function(var_names) {
  tcode <- rep(1L, length(var_names))
  tcode[grepl("^(base_|credit|credito_)", var_names) |
          var_names %in% c("fin_inst_reserve_req", "pib")] <- 4L
  tcode[grepl("^asset_", var_names)] <- 6L
  tcode
}


#' Impulse responses of the DFM, identified, with Anderson-Rubin sets
#'
#' The main entry point of the identification stage. Identification is by
#' external instrument (Gertler-Karadi / Alessi-Kerssenfischer) — the single
#' branch since the heteroskedasticity and non-Gaussian routes were abandoned on
#' 2026-08-17.
#'
#' @param dfm_results List returned by `estimate_dfm()`. When it carries
#'   `covid_volatility`, the point projects on the uncentered moment and the
#'   Anderson-Rubin sets run on the transformed regression
#'   (`ar_dfm_bands()`).
#' @param instrument Data.frame with `month` and `shock`, aligned through
#'   `dfm_results$dates`, or a numeric vector already aligned with the
#'   residuals. Defaults to the one `estimate_dfm()` embedded.
#' @param h Maximum horizon.
#' @param mpind Column index of the monetary-policy variable used for
#'   normalization.
#' @param normalize_value Impact response imposed on the policy variable, in its
#'   native units (0.005 for a +50bp shock on a decimal-proportion yield).
#' @param tcode Integer vector of transformation codes, one per variable.
#' @param ci_levels Confidence levels of the sets.
#' @param identification Identification branch; `"proxy"` is the only one.
#' @param inference What fills `ci`, with no default: `"ar"` inverts the
#'   Anderson-Rubin test (`ar_dfm_bands()`, the inference of the DFM since
#'   2026-09-08); `"none"` returns the point alone,
#'   with `lower = upper = point` at every level, for cells that are compared
#'   point by point.
#' @param ar_nw_lags Newey-West truncation of the AR moment covariance.
#'
#' @return List with `irf_point_matrix` (vars x horizons), `ci` (one entry per
#'   level, each with `level`, `lower` and `upper`), `ci_levels`,
#'   `identification`, `inference`, and `ar` — the full `ar_dfm_bands()` result
#'   with set topologies, or NULL under `"none"`.
#'
#' @examples
#' irf <- compute_irf_dfm(dfm, h = 48L, mpind = mp_idx, normalize_value = 0.005,
#'                        tcode = tcode, ci_levels = c(0.68, 0.90),
#'                        inference = "ar")
compute_irf_dfm <- function(dfm_results, instrument = dfm_results$instrument,
                            h = 24, mpind, normalize_value,
                            tcode = rep(1L, nrow(dfm_results$static_loadings)),
                            ci_levels = c(0.90, 0.95),
                            identification = "proxy",
                            inference, ar_nw_lags = 0L) {
  identification <- match.arg(identification)
  inference <- match.arg(inference, c("ar", "none"))

  Lambda <- dfm_results$static_loadings
  A      <- dfm_results$companion_matrix
  r      <- ncol(Lambda)

  if (is.data.frame(instrument)) {
    align       <- sel_ext_inst_sample(dfm_results$dates, dfm_results$p, instrument)
    rsh_sel_ind <- align$rsh_sel_ind
    inst_sel    <- align$inst_sel
  } else {
    rsh_sel_ind <- rep(TRUE, nrow(dfm_results$var_residuals))
    inst_sel    <- instrument
  }

  # Reduced-form responses diag(sy) Lambda B_h K M, B_h the r x r block of A^h
  powers <- Reduce(function(B, i) B %*% A, seq_len(h), accumulate = TRUE,
                   init = diag(nrow(A)))
  rawimp <- simplify2array(lapply(powers, function(B) {
    sweep(Lambda %*% B[1:r, 1:r] %*% dfm_results$dynamic_loadings %*%
            dfm_results$dynamic_scaling, 1, dfm_results$data_sd, "*")
  }))

  eta <- extract_dynamic_innovations(dfm_results)

  # Under the COVID volatility, no centering: MOSW's Gamma (SVARIV.m:128)
  irf_point <- ident_ext_instr(rawimp, eta[rsh_sel_ind, , drop = FALSE], inst_sel,
                               h, mpind, normalize_value, tcode,
                               center = is.null(dfm_results$covid_volatility))

  ar <- NULL
  if (inference == "ar") {
    ar <- ar_dfm_bands(dfm_results, rsh_sel_ind, inst_sel, mpind, h,
                       normalize_value, tcode, ci_levels, nw_lags = ar_nw_lags)

    # The inversion re-derives the point response from its own moment vector.
    # It has to land on the production point, or the two paths disagree about
    # the identification itself.
    dev_point <- max(abs(ar$by_level[[1L]]$point - irf_point))
    if (!is.finite(dev_point) || dev_point > 1e-10) {
      stop("The Anderson-Rubin point deviates from ident_ext_instr by ",
           format(dev_point, digits = 3), " (tolerance 1e-10)")
    }
  }

  level_keys <- sprintf("%.2f", ci_levels)
  ci <- purrr::map2(ci_levels, level_keys, function(lvl, key) {
    list(level = lvl,
         lower = if (is.null(ar)) irf_point else ar$by_level[[key]]$lo,
         upper = if (is.null(ar)) irf_point else ar$by_level[[key]]$hi)
  })
  names(ci) <- level_keys

  list(
    irf_point_matrix = irf_point,
    ci = ci,
    ci_levels = ci_levels,
    identification = identification,
    inference = inference,
    ar = ar
  )
}


#' Plot IRFs with shaded confidence bands
#'
#' @param irf_results List returned by `compute_irf_dfm()`.
#' @param response_vars Named character vector: panel variables to draw, named
#'   by their panel label.
#' @param horizon Maximum horizon on the x axis.
#' @param var_names Character vector of panel column names.
#' @param ci_to_plot Confidence levels to shade.
#'
#' @return A patchwork of ggplot2 panels, two per row.
#'
#' @examples
#' p <- plot_irf(res$irfs, c(ipca = "price_ipca"), 48L, colnames(res$data),
#'               c(0.68, 0.90))
plot_irf <- function(irf_results, response_vars, horizon, var_names, ci_to_plot) {
  h <- 0:horizon
  keys <- sprintf("%.2f", sort(ci_to_plot, decreasing = TRUE))
  fills <- c("grey90", "grey80", "grey70", "grey60")
  alphas <- c(0.5, 0.45, 0.4, 0.35)

  panels <- purrr::imap(response_vars, function(variable, label) {
    i <- match(variable, var_names)
    bands <- purrr::map(seq_along(keys), function(k) {
      ci <- irf_results$ci[[keys[k]]]
      ggplot2::geom_ribbon(
        data = data.frame(tempo = h, lower = ci$lower[i, h + 1], upper = ci$upper[i, h + 1]),
        ggplot2::aes(ymin = lower, ymax = upper),
        fill = fills[k], alpha = alphas[k]
      )
    })

    ggplot2::ggplot(data.frame(tempo = h, irf = irf_results$irf_point_matrix[i, h + 1]),
                    ggplot2::aes(x = tempo)) +
      bands +
      ggplot2::geom_line(ggplot2::aes(y = irf), color = "black", linewidth = 1) +
      ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      ggplot2::theme_classic() +
      ggplot2::labs(y = label) +
      ggplot2::theme(
        axis.title.x = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_text(size = ggplot2::rel(1.4)),
        axis.text = ggplot2::element_text(size = ggplot2::rel(1.2)),
        plot.title = ggplot2::element_blank()
      )
  })

  patchwork::wrap_plots(panels, ncol = 2)
}
