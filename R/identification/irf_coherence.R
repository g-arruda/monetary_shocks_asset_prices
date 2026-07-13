# ===================================================================
# Point-by-point theory-coherence evaluation of IRF paths
# For each variable: sign and CI68/CI90 significance at every horizon,
# scored against a theory window. Consumed by script/irf_coherence_check.R.
# ===================================================================


#' Theory table for the horizon-coherence check
#'
#' Tiers: `scored` variables receive a hard verdict against `theory_sign`
#' inside the window [w_lo, w_hi]; `soft` variables have a standard-channel
#' sign but admit the fiscal-dominance reading (channel is recorded, never
#' failed); `ambiguous` variables have no strong prior (trajectory reported
#' only); `placebo` variables are external series that the Brazilian shock
#' should NOT move (coherence = CI90 contains zero on ≥90% of the window).
#'
#' @return Data.frame with `var`, `group`, `theory_sign`, `tier`, `w_lo`, `w_hi`.
coherence_var_table <- function() {
  row <- function(var, group, sign, tier, w_lo, w_hi) {
    data.frame(var = var, group = group, theory_sign = sign, tier = tier,
               w_lo = w_lo, w_hi = w_hi, stringsAsFactors = FALSE)
  }
  rbind(
    row(c("yield_3m", "yield_1y", "yield_2y", "yield_5y", "yield_10y",
          "juros_cdi"), "curva_juros", 1, "scored", 0, 6),
    row("juros_selic", "curva_juros", 1, "scored", 1, 12),
    row(c("asset_ibov", "asset_smll", "asset_idiv", "asset_imob",
          "asset_ifix", "asset_mlcx"), "acoes", -1, "scored", 0, 6),
    row(c("asset_ifnc", "asset_imat"), "acoes_ambiguas", NA, "ambiguous", 0, 6),
    row(c("cambio_usd", "cambio_eur", "embi_perc", "cds_5y"),
        "risco_cambio_soft", -1, "soft", 0, 6),
    row(c("ibc_br", "pib", "ind_transformacao", "ind_bens_duraveis",
          "ind_bens_capital", "vendas_varejo", "vendas_servicos",
          "ind_automoveis", "capacidade_instalada_industria"),
        "atividade", -1, "scored", 3, 24),
    row("trab_tx_desemprego", "trabalho", 1, "scored", 6, 36),
    row(c("trab_pop_ocupada", "trab_hrs_trabalhadas_industria"),
        "trabalho", -1, "scored", 6, 36),
    row(c("credit_outstanding", "credito_pessoa_fisica"),
        "credito", -1, "scored", 6, 36),
    row(c("spread_icc_juridica", "spread_icc_fisica"),
        "credito", 1, "scored", 0, 12),
    row(c("credito_comercio", "credito_transporte", "credito_industria_total"),
        "credito_setorial", -1, "scored", 6, 36),
    # agro/construcao: majoritariamente credito direcionado (rural/SFH) —
    # transmissao atenuada (Bonomo-Martins 2016), sem prior forte
    row(c("credito_agro", "credito_construcao"),
        "credito_setorial", NA, "ambiguous", 6, 36),
    row(c("price_ipca", "price_ipca_difusao", "price_core_ipca_ex0",
          "price_core_ipca_ex1", "price_core_ipca_dw", "price_inpc"),
        "precos", -1, "scored", 12, 48),
    row(c("price_igp_m", "price_ipp"), "precos_ambiguos", NA, "ambiguous", 12, 48),
    row(c("sp500_vix", "msci", "commodity_metal", "epu_us"),
        "placebo_externas", 0, "placebo", 0, 24)
  )
}


#' Evaluate one IRF path point-by-point against its theory spec
#'
#' @param path Numeric vector, IRF point estimate at h = 0..H.
#' @param lo68,hi68,lo90,hi90 CI bounds, same length as `path`.
#' @param spec One row of `coherence_var_table()`.
#'
#' @return List with `perh` (data.frame h x metrics) and `summary` (one row).
evaluate_irf_path <- function(path, lo68, hi68, lo90, hi90, spec) {
  H <- length(path) - 1
  h <- 0:H
  sgn   <- sign(path)
  sig68 <- lo68 > 0 | hi68 < 0
  sig90 <- lo90 > 0 | hi90 < 0

  perh <- data.frame(
    var = spec$var, h = h, point = path,
    lo68 = lo68, hi68 = hi68, lo90 = lo90, hi90 = hi90,
    sign = sgn, sig68 = sig68, sig90 = sig90,
    stringsAsFactors = FALSE
  )

  w <- seq(spec$w_lo, min(spec$w_hi, H)) + 1
  peak_idx <- which.max(abs(path))

  share_correct   <- NA_real_
  first_correct_h <- NA_integer_
  wrong_sig90     <- NA
  right_sig68     <- NA
  right_sig90     <- NA
  contain0_share  <- NA_real_
  channel         <- NA_character_

  if (spec$tier %in% c("scored", "soft") && !is.na(spec$theory_sign)) {
    correct <- sgn[w] == spec$theory_sign
    share_correct <- mean(correct)
    if (any(correct)) first_correct_h <- (w[which(correct)[1]] - 1)
    wrong_sig90 <- any(sig90[w] & !correct)
    right_sig68 <- any(sig68[w] & correct)
    right_sig90 <- any(sig90[w] & correct)
  }
  if (spec$tier == "placebo") {
    contain0_share <- mean(!sig90[w])
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

  summary <- data.frame(
    group = spec$group, var = spec$var, tier = spec$tier,
    theory_sign = spec$theory_sign, w_lo = spec$w_lo, w_hi = spec$w_hi,
    h0 = path[1], h3 = path[4], h6 = path[7], h12 = path[13],
    h24 = path[min(25, H + 1)], h36 = path[min(37, H + 1)],
    h48 = path[min(49, H + 1)],
    peak_h = peak_idx - 1, peak_val = path[peak_idx],
    share_correct = share_correct, first_correct_h = first_correct_h,
    right_sig68 = right_sig68, right_sig90 = right_sig90,
    wrong_sig90 = wrong_sig90, contain0_share = contain0_share,
    channel = channel, verdict = verdict,
    stringsAsFactors = FALSE
  )

  list(perh = perh, summary = summary)
}
