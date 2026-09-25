# ===================================================================
# Point-by-point theory-coherence evaluation of IRF paths
# For each variable: sign and CI68/CI90 significance at every horizon,
# scored against a theory window. The theory table and the loop over
# variables live in script/irf_coherence_check.R.
# ===================================================================


#' Evaluate one IRF path point-by-point against its theory spec
#'
#' The tier of the spec decides the verdict. `scored` variables receive a
#' hard verdict against `theory_sign` inside the window [w_lo, w_hi]; `soft`
#' variables have a standard-channel sign but admit the fiscal-dominance
#' reading (channel is recorded, never failed); `ambiguous` variables have no
#' strong prior (trajectory reported only); `placebo` variables are external
#' series that the Brazilian shock should NOT move (coherence = CI90 contains
#' zero on >= 90% of the window).
#'
#' Significance is "the confidence set excludes zero". An Anderson-Rubin set
#' need not be an interval, so its topology decides, through
#' `ar_excludes_zero()`: a `two_rays` set excludes zero when zero sits in its
#' gap; a `real_line` set never does; an `empty` set gives `NA`.
#'
#' @param path Numeric vector, IRF point estimate at h = 0..H.
#' @param lo68,hi68,lo90,hi90 CI bounds, same length as `path`.
#' @param spec One row of the theory table, with `var`, `group`,
#'   `theory_sign`, `tier`, `w_lo` and `w_hi`.
#' @param set_type68,set_type90 Character vectors of AR set topologies.
#'
#' @return List with `perh` (tibble h x metrics) and `summary` (one row).
evaluate_irf_path <- function(path, lo68, hi68, lo90, hi90, spec,
                              set_type68, set_type90) {
  H <- length(path) - 1
  sgn <- sign(path)

  excludes_zero <- \(set_type, lo, hi) {
    drop(ar_excludes_zero(
      matrix(set_type, ncol = 1),
      matrix(lo, ncol = 1),
      matrix(hi, ncol = 1)
    ))
  }
  sig68 <- excludes_zero(set_type68, lo68, hi68)
  sig90 <- excludes_zero(set_type90, lo90, hi90)
  if (anyNA(sig68) || anyNA(sig90)) {
    stop("Empty Anderson-Rubin set in '", spec$var, "': the inversion rejects ",
         "every value of the response, which scoring cannot read as a sign. ",
         "Inspect cell$irf$ar before coercing it to a verdict.")
  }

  perh <- tibble::tibble(
    var = spec$var,
    h = 0:H,
    point = path,
    lo68 = lo68,
    hi68 = hi68,
    lo90 = lo90,
    hi90 = hi90,
    set_type68 = set_type68,
    set_type90 = set_type90,
    sign = sgn,
    sig68 = sig68,
    sig90 = sig90
  )

  window <- seq(spec$w_lo, min(spec$w_hi, H)) + 1
  peak_idx <- which.max(abs(path))

  share_correct <- NA_real_
  first_correct_h <- NA_integer_
  wrong_sig90 <- NA
  right_sig68 <- NA
  right_sig90 <- NA
  contain0_share <- NA_real_
  channel <- NA_character_

  if (spec$tier %in% c("scored", "soft") && !is.na(spec$theory_sign)) {
    correct <- sgn[window] == spec$theory_sign
    share_correct <- mean(correct)
    if (any(correct)) first_correct_h <- window[which(correct)[1]] - 1
    wrong_sig90 <- any(sig90[window] & !correct)
    right_sig68 <- any(sig68[window] & correct)
    right_sig90 <- any(sig90[window] & correct)
  }
  if (spec$tier == "placebo") {
    contain0_share <- mean(!sig90[window])
  }
  if (spec$tier == "soft") {
    # Channel read at impact: standard (appreciation / risk tightening) vs
    # fiscal dominance (depreciation / risk widening)
    channel <- if (spec$var %in% c("cambio_usd", "cambio_eur")) {
      if (path[1] > 0) "depreciacao_fiscal_dom" else "apreciacao_standard"
    } else {
      if (path[1] > 0) "risco_abre_fiscal_dom" else "risco_fecha_standard"
    }
  }

  verdict <- if (spec$tier == "ambiguous") {
    "ambigua"
  } else if (spec$tier == "placebo") {
    if (contain0_share >= 0.90) "placebo_ok" else "placebo_viola"
  } else if (spec$tier == "soft") {
    paste0("soft_", channel)
  } else if (isTRUE(wrong_sig90) || share_correct < 0.5) {
    "incoerente"
  } else if (share_correct >= 0.8 && isTRUE(right_sig68)) {
    "coerente_forte"
  } else if (share_correct >= 0.8) {
    "coerente"
  } else {
    "parcial"
  }

  summary <- tibble::tibble(
    group = spec$group,
    var = spec$var,
    tier = spec$tier,
    theory_sign = spec$theory_sign,
    w_lo = spec$w_lo,
    w_hi = spec$w_hi,
    h0 = path[1],
    h3 = path[4],
    h6 = path[7],
    h12 = path[13],
    h24 = path[min(25, H + 1)],
    h36 = path[min(37, H + 1)],
    h48 = path[min(49, H + 1)],
    peak_h = peak_idx - 1,
    peak_val = path[peak_idx],
    share_correct = share_correct,
    first_correct_h = first_correct_h,
    right_sig68 = right_sig68,
    right_sig90 = right_sig90,
    wrong_sig90 = wrong_sig90,
    contain0_share = contain0_share,
    channel = channel,
    verdict = verdict
  )

  list(perh = perh, summary = summary)
}
