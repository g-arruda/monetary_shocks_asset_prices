# Functions removed from R/identification/spec_sweep.R on 2026-09-17, in the
# audit of script/ and R/. Their only callers were irf_spec_sweep.R and the
# panel_composition_rq_grid* scripts, now in arquivo/script/. Kept as written;
# they do not reproduce against the current panel.


#' Theory-consistent sign table for a contractionary monetary shock
#'
#' Tiers: `hard` signs must hold at h = 0 for a cell to be theory-consistent;
#' `ext` signs are scored at h = 24 (transmission channel); `soft` signs are
#' recorded but never penalized — cambio_usd / cds_5y / embi_perc admit the
#' fiscal-dominance channel (depreciation + risk widening) documented in
#' output/irf/irf_section.md.
#'
#' @return Data.frame with columns `response_var`, `theory_sign`, `score_h`, `tier`.
theory_sign_table <- function() {
  data.frame(
    response_var = c("yield_6m", "yield_2y", "yield_5y", "asset_ibov",
                     "price_ipca", "pib", "vendas_varejo",
                     "cambio_usd", "cds_5y", "embi_perc"),
    theory_sign  = c(1, 1, 1, -1,
                     -1, -1, -1,
                     -1, -1, -1),
    score_h      = c(0, 0, 0, 0,
                     24, 24, 24,
                     0, 0, 0),
    tier         = c("hard", "hard", "hard", "hard",
                     "ext", "ext", "ext",
                     "soft", "soft", "soft"),
    stringsAsFactors = FALSE
  )
}


#' Summarize point-estimate IRFs for the scored response variables
#'
#' Extracts h = 0/6/12/24 values, peak horizon and sign consistency for each
#' response in the theory table. The row where `response_var == mp_var` is
#' flagged `mechanical` (its impact equals the normalization target by
#' construction) and must be excluded from scoring by the caller.
#'
#' @param irf_matrix n_vars x (h+1) matrix from `compute_irf_dfm(...)$irf_point_matrix`.
#' @param var_names Panel column names aligned with `irf_matrix` rows.
#' @param theory_tbl Output of `theory_sign_table()`.
#' @param mp_var Policy variable of the cell.
#'
#' @return Data.frame with one row per response variable.
summarize_irf_responses <- function(irf_matrix, var_names, theory_tbl, mp_var) {
  max_h <- ncol(irf_matrix) - 1

  rows <- lapply(seq_len(nrow(theory_tbl)), function(i) {
    spec <- theory_tbl[i, ]
    idx  <- match(spec$response_var, var_names)
    if (is.na(idx)) {
      return(NULL)
    }

    path     <- irf_matrix[idx, ]
    peak_idx <- which.max(abs(path))
    at_score <- path[min(spec$score_h, max_h) + 1]

    data.frame(
      response_var    = spec$response_var,
      theory_sign     = spec$theory_sign,
      tier            = spec$tier,
      score_h         = spec$score_h,
      h0              = path[1],
      h6              = path[min(6, max_h) + 1],
      h12             = path[min(12, max_h) + 1],
      h24             = path[min(24, max_h) + 1],
      peak_h          = peak_idx - 1,
      peak_val        = path[peak_idx],
      sign_at_score_h = sign(at_score),
      consistent      = sign(at_score) == spec$theory_sign,
      mechanical      = spec$response_var == mp_var,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}


#' Evaluate one sweep cell (DFM x instrument x mp_var) without bootstrap
#'
#' Runs the factor-space diagnostic and the point-estimate IRF for the chosen
#' policy variable. Scoring and
#' failure classification happen downstream, on the bound results.
#'
#' @param dfm Output of `estimate_dfm` on the window (no instrument passed).
#' @param data_sub Panel matrix restricted to the window.
#' @param dates_sub Dates aligned with `data_sub` rows.
#' @param inst_df Data.frame `month`/`shock` (NA-filtered).
#' @param mp_var Policy variable name.
#' @param p VAR lag order.
#' @param h Sweep horizon.
#' @param shock_bps Shock size in basis points.
#' @param tcode Transformation codes for the full panel.
#' @param theory_tbl Output of `theory_sign_table()`.
#'
#' @return List with `cell` (one-row data.frame) and `responses` (long data.frame).
evaluate_sweep_cell <- function(dfm, data_sub, dates_sub, inst_df,
                                mp_var, p, h, shock_bps, tcode, theory_tbl) {
  var_names <- colnames(data_sub)
  mpind     <- match(mp_var, var_names)
  if (is.na(mpind)) stop("mp_var '", mp_var, "' not found in panel")

  diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates_sub, p, mpind)

  irf <- compute_irf_dfm(
    dfm,
    instrument      = inst_df,
    h               = h,
    nboot           = 0,
    mpind           = mpind,
    normalize_value = norm_value_for(mp_var, shock_bps),
    data_dates      = dates_sub,
    tcode           = tcode,
    diagnose        = FALSE
  )

  responses <- summarize_irf_responses(irf$irf_point_matrix, var_names,
                                       theory_tbl, mp_var)

  hard <- responses[responses$tier == "hard" & !responses$mechanical, ]
  ext  <- responses[responses$tier == "ext", ]

  h0_of <- function(v) {
    val <- responses$h0[responses$response_var == v]
    if (length(val) == 0) NA_real_ else val
  }

  fx_channel <- if (is.na(h0_of("cambio_usd"))) {
    NA_character_
  } else if (h0_of("cambio_usd") < 0) "apreciacao" else "depreciacao"

  risk_signs <- sign(c(h0_of("cds_5y"), h0_of("embi_perc")))
  risk_channel <- if (any(is.na(risk_signs))) {
    NA_character_
  } else if (all(risk_signs < 0)) {
    "standard"
  } else if (all(risk_signs > 0)) {
    "fiscal_dominance"
  } else {
    "mixed"
  }

  yield_ordering_ok <- abs(h0_of("yield_2y")) <= abs(h0_of("yield_6m")) &&
    abs(h0_of("yield_5y")) <= abs(h0_of("yield_2y"))

  # A yield responding > 250bp to a 50bp shock flags implausible magnitude
  # regardless of the mp_var scale (yields are decimal-proportion, tcode 1)
  yield_h0_max  <- max(abs(c(h0_of("yield_6m"), h0_of("yield_2y"),
                             h0_of("yield_5y"))), na.rm = TRUE)
  magnitude_flag <- yield_h0_max > 5 * shock_bps / 10000

  cell <- data.frame(
    mp_var          = mp_var,
    n_obs_align     = diag_fs$n_obs,
    wald_mp         = diag_fs$wald_mp,      # xi_mp — MOSW decision ruler
    f_robust_mp     = diag_fs$f_robust_mp,
    fs_beta         = diag_fs$first_stage_beta,
    fs_se           = diag_fs$first_stage_se,
    fs_p            = diag_fs$first_stage_p,
    impact_mp_pre   = diag_fs$impact_mp,
    sign_mp         = diag_fs$sign_mp,
    score_hard      = sum(hard$consistent),
    n_hard_avail    = nrow(hard),
    score_ext       = sum(ext$consistent),
    n_ext_avail     = nrow(ext),
    fx_channel      = fx_channel,
    risk_channel    = risk_channel,
    yield_ordering_ok = yield_ordering_ok,
    magnitude_flag  = magnitude_flag,
    h0_yield6m      = h0_of("yield_6m"),
    h0_yield2y      = h0_of("yield_2y"),
    h0_yield5y      = h0_of("yield_5y"),
    h0_ibov         = h0_of("asset_ibov"),
    h0_cambio       = h0_of("cambio_usd"),
    stringsAsFactors = FALSE
  )

  list(cell = cell, responses = responses)
}


#' Classify sweep cells into a failure taxonomy
#'
#' The ruler is `wald_mp` — the Montiel Olea-Stock-Watson Wald in the
#' mp-variable impact direction (xi_mp), computed with the Shat correction in
#' `diagnose_instrument_in_factor_space`. Thresholds are MOSW's, not
#' Stock-Yogo's: the 95% Anderson-Rubin set is a bounded interval iff
#' xi_mp > 3.84 = `qchisq(0.95, 1)`, and conventional bands are approximately
#' valid from xi_mp >= 10. The matching `f_robust_mp` is reported alongside
#' xi_mp but does not enter the classification, avoiding a pre-test rule.
#'
#' Mutually exclusive classes, first match wins:
#' `estimation_failed` / `no_variation_in_window` (set upstream) →
#' `negative_control` (juros_selic, documented F < 2) →
#' `weak_xi_mp_severe` (xi_mp < 3.84; AR set unbounded) →
#' `weak_xi_mp` (xi_mp < 10; conventional bands not valid) →
#' `unstable_normalization` (strength ok but |impact_mp_pre| under 10% of the
#' sample x mp_var group median → denominator of the impact normalization
#' near zero → exploding magnitudes) →
#' `sign_puzzle` (strength ok, denominator ok, hard signs still wrong) → `ok`.
#'
#' Note that `evaluate_sweep_cell` calls the diagnostic with the cell's own
#' `mpind`, so `wald_mp` is the Wald in *that cell's* normalization direction.
#' It therefore matches `output/instrument/mosw_strength_grid.csv` only on the
#' `mp_var == "yield_6m"` rows, where the grid fixes MP_VAR.
#'
#' @param cells Data.frame of bound cell rows (must have `failure_class`
#'   pre-filled for mechanical failures, NA otherwise).
#'
#' @return `cells` with `denom_ratio` and final `failure_class` columns.
classify_sweep_cells <- function(cells) {
  cells <- cells |>
    dplyr::group_by(sample, mp_var) |>
    dplyr::mutate(
      denom_ratio = abs(impact_mp_pre) /
        stats::median(abs(impact_mp_pre), na.rm = TRUE)
    ) |>
    dplyr::ungroup()

  cells |>
    dplyr::mutate(
      failure_class = dplyr::case_when(
        !is.na(failure_class)            ~ failure_class,
        mp_var == "juros_selic"          ~ "negative_control",
        is.na(wald_mp)                   ~ "estimation_failed",
        wald_mp < 3.84                   ~ "weak_xi_mp_severe",
        wald_mp < 10                     ~ "weak_xi_mp",
        denom_ratio < 0.10               ~ "unstable_normalization",
        score_hard < n_hard_avail        ~ "sign_puzzle",
        TRUE                             ~ "ok"
      )
    )
}


#' Render one xi_mp surface with r in rows and q in columns
#'
#' @param cells Long result table for one variant and sample.
#'
#' @return Character vector containing a GitHub-flavored markdown table.
rq_surface_table <- function(cells) {
  surface <- tidyr::complete(cells, r = 5:8, q = 3:8) |>
    dplyr::mutate(
      xi_mp = dplyr::if_else(is.na(xi_mp), NA_character_, sprintf("%.2f", xi_mp)),
      mosw_class = dplyr::if_else(is.na(mosw_class), NA_character_, mosw_class)
    ) |>
    dplyr::select(r, q, xi_mp, mosw_class) |>
    tidyr::pivot_wider(
      names_from = q,
      values_from = c(xi_mp, mosw_class),
      names_glue = "{.value}_q{q}"
    ) |>
    dplyr::arrange(r)
  md_table(surface, digits = 4)
}
