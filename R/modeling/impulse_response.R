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

  # One column per horizon 0..h; apply() hands each n_vars x q slice over as a
  # matrix even when q = 1
  irf_mp <- apply(rawimp, 3, \(impact) impact %*% H)

  cumimp_transform(irf_mp / irf_mp[mpind, 1] * normalize_value, tcode)
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
  cumulated <- t(apply(Imp, 1, cumsum))

  transformed <- Imp
  transformed[tcode == 2, ] <- cumulated[tcode == 2, ] * 100
  transformed[tcode == 3, ] <- t(apply(cumulated, 1, cumsum))[tcode == 3, ]
  transformed[tcode == 4, ] <- (exp(Imp[tcode == 4, ]) - 1) * 100
  transformed[tcode == 5, ] <- (exp(cumulated[tcode == 5, ]) - 1) * 100
  transformed[tcode == 6, ] <- Imp[tcode == 6, ] * 100
  transformed
}


#' Assign transformation codes from panel variable names
#'
#' Everything is a level (1) except `base_*`, `credit*`/`credito_*`,
#' `fin_inst_reserve_req` and `pib` (log-level, 4) and `asset_*` (6). The
#' `asset_*` series are monthly returns (`download.R`: `prod(1 + r) - 1`), so
#' their responses are put on the percent scale without being accumulated.
#'
#' @param var_names Character vector of panel column names.
#'
#' @return Integer vector of tcodes aligned to `var_names`.
#'
#' @examples
#' tcode <- infer_tcode_from_varnames(colnames(panel))
infer_tcode_from_varnames <- function(var_names) {
  dplyr::case_when(
    stringr::str_detect(var_names, "^asset_") ~ 6L,
    stringr::str_detect(var_names, "^(base_|credit|credito_)") ~ 4L,
    var_names %in% c("fin_inst_reserve_req", "pib") ~ 4L,
    .default = 1L
  )
}


#' Impulse responses of the DFM, identified, with Anderson-Rubin sets
#'
#' The main entry point of the identification stage. Identification is by
#' external instrument (Gertler-Karadi / Alessi-Kerssenfischer), the only
#' branch.
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
#'   Anderson-Rubin test (`ar_dfm_bands()`, the DFM's inference); `"none"`
#'   returns the point alone, with `lower = upper = point` at every level, for
#'   cells that are compared point by point.
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
  A <- dfm_results$companion_matrix
  r <- ncol(Lambda)

  if (is.data.frame(instrument)) {
    align <- sel_ext_inst_sample(dfm_results$dates, dfm_results$p, instrument)
    rsh_sel_ind <- align$rsh_sel_ind
    inst_sel <- align$inst_sel
  } else {
    rsh_sel_ind <- rep(TRUE, nrow(dfm_results$var_residuals))
    inst_sel <- instrument
  }

  # Reduced-form responses diag(sy) Lambda B_h K M, B_h the r x r block of
  # A^h, and A^h = A^(h-1) A
  powers <- vector("list", h + 1)
  powers[[1]] <- diag(nrow(A))
  for (horizon in seq_len(h)) {
    powers[[horizon + 1]] <- powers[[horizon]] %*% A
  }
  rawimp <- powers |>
    purrr::map(\(power) {
      sweep(
        Lambda %*% power[1:r, 1:r] %*% dfm_results$dynamic_loadings %*%
          dfm_results$dynamic_scaling,
        1,
        dfm_results$data_sd,
        "*"
      )
    }) |>
    simplify2array()

  eta <- extract_dynamic_innovations(dfm_results)

  # Under the COVID volatility, no centering: MOSW's Gamma (SVARIV.m:128)
  irf_point <- ident_ext_instr(
    rawimp,
    eta[rsh_sel_ind, , drop = FALSE],
    inst_sel,
    h,
    mpind,
    normalize_value,
    tcode,
    center = is.null(dfm_results$covid_volatility)
  )

  ar_sets <- NULL
  if (inference == "ar") {
    ar_sets <- ar_dfm_bands(
      dfm_results,
      rsh_sel_ind,
      inst_sel,
      mpind,
      h,
      normalize_value,
      tcode,
      ci_levels,
      nw_lags = ar_nw_lags
    )

    # The inversion re-derives the point response from its own moment vector.
    # It has to land on the production point, or the two paths disagree about
    # the identification itself.
    point_deviation <- max(abs(ar_sets$by_level[[1L]]$point - irf_point))
    if (!is.finite(point_deviation) || point_deviation > 1e-10) {
      stop(
        "The Anderson-Rubin point deviates from ident_ext_instr by ",
        format(point_deviation, digits = 3), " (tolerance 1e-10)"
      )
    }
  }

  ci <- ci_levels |>
    purrr::set_names(sprintf("%.2f", ci_levels)) |>
    purrr::imap(\(level, key) {
      list(
        level = level,
        lower = if (is.null(ar_sets)) irf_point else ar_sets$by_level[[key]]$lo,
        upper = if (is.null(ar_sets)) irf_point else ar_sets$by_level[[key]]$hi
      )
    })

  list(
    irf_point_matrix = irf_point,
    ci = ci,
    ci_levels = ci_levels,
    identification = identification,
    inference = inference,
    ar = ar_sets
  )
}
