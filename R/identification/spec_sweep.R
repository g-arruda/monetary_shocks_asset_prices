# ===================================================================
# Helpers for the IRF specification sweep
# (instrument x mp_var x (r,q) x sample window)
# Scores point-estimate IRFs against theory-consistent signs and
# classifies failures (weak factor-space F, unstable normalization,
# sign puzzles). Consumed by script/irf_spec_sweep.R.
# ===================================================================


#' Normalization value in native units of the policy variable
#'
#' Yields are stored as decimal proportion (0.05 = 5%), so +50bp = +0.005.
#' `juros_selic` is stored in percent (7.11 = 7.11%), so +50bp = +0.5.
#'
#' @param mp_var Policy variable name.
#' @param shock_bps Shock size in basis points.
#'
#' @return Scalar normalization target for `ident_ext_instr`.
norm_value_for <- function(mp_var, shock_bps) {
  if (mp_var == "juros_selic") shock_bps / 100 else shock_bps / 10000
}


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
#' Runs the factor-space diagnostic, the point-estimate IRF, and the
#' reduced-form first-stage F for the chosen policy variable. Scoring and
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

  # Reduced-form relevance: AR(6) innovation of the policy variable vs
  # the instrument, on this window (Montiel Olea-Stock-Watson partial F)
  innov <- residualize_target(data_sub[, mpind], 6L)
  z_al  <- inst_df$shock[match(dates_sub, inst_df$month)]
  fs    <- first_stage_F(z_al, innov)

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
    wald_joint      = diag_fs$wald_joint,   # T * Gamma' W^-1 Gamma ~ chi2_q
    wald_min        = diag_fs$wald_min,     # weakest per-factor xi_k
    f_factor        = diag_fs$f_factor,     # legacy max-F, kept for continuity
    f_reduced       = fs$F_partial,
    fs_beta         = fs$beta,
    fs_n            = fs$n,
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
#' valid from xi_mp >= 10. The legacy homoskedastic max-F (`f_factor`) is still
#' reported per cell but no longer classifies — under it the production
#' instrument `z_jk_bs_purif` never reached `ok` (6.31 at (7,6) full against
#' xi_mp 10.43), while `z_jk_purif` had the mirror image (11.08 / 5.77).
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


#' Run one winning cell through the full bootstrap IRF pipeline
#'
#' Production path: the instrument is passed to `estimate_dfm` (temporal
#' alignment happens there) and `compute_irf_dfm` resolves instrument and
#' dates from the DFM object, mirroring `script/irf_cross_instrument.R`.
#'
#' @param data_mat Full panel matrix (no date column).
#' @param dates Dates aligned with `data_mat` rows.
#' @param inst_panel Wide instrument data.frame (`month` + one column per variant).
#' @param sample_window Date vector `c(start, end)`.
#' @param r,q,p DFM dimensions and VAR lag order.
#' @param instrument Variant column name in `inst_panel`.
#' @param mp_var Policy variable name.
#' @param h IRF horizon.
#' @param nboot Wild-bootstrap draws.
#' @param seed Bootstrap seed.
#' @param shock_bps Shock size in basis points.
#' @param tcode Transformation codes for the full panel.
#' @param ci_levels Confidence levels for the bootstrap bands.
#'
#' @return List with `irf`, `var_names`, `tcode`, `mpind`, `normalize_value`
#'   and the cell keys.
run_stage2_cell <- function(data_mat, dates, inst_panel, sample_window,
                            r, q, p, instrument, mp_var,
                            h, nboot, seed, shock_bps, tcode, ci_levels) {
  in_window <- dates >= sample_window[1] & dates <= sample_window[2]
  data_sub  <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]

  inst_df <- data.frame(month = inst_panel$month, shock = inst_panel[[instrument]])
  inst_df <- inst_df[!is.na(inst_df$shock), ]

  mpind <- match(mp_var, colnames(data_mat))
  if (is.na(mpind)) stop("mp_var '", mp_var, "' not found in panel")

  dfm <- estimate_dfm(data_sub, r = r, q = q, p = p,
                      dates = dates_sub, instrument = inst_df,
                      apply_kilian = TRUE)

  norm_val <- norm_value_for(mp_var, shock_bps)

  irf <- compute_irf_dfm(
    dfm,
    h               = h,
    nboot           = nboot,
    bootstrap_seed  = seed,
    mpind           = mpind,
    normalize_value = norm_val,
    tcode           = tcode,
    ci_levels       = ci_levels
  )

  list(
    irf = irf, var_names = colnames(data_mat), tcode = tcode,
    mpind = mpind, normalize_value = norm_val,
    instrument = instrument, mp_var = mp_var, r = r, q = q, p = p,
    dfm_max_eig = dfm$diagnostics$max_eigenvalue
  )
}


#' Overlay IRF panels for an arbitrary set of stage-2 cells
#'
#' Generalizes `plot_overlay` from `script/irf_cross_instrument.R` to any
#' number of cells with a palette keyed by cell tag.
#'
#' @param cells Named list of stage-2 results (names used as legend labels).
#' @param response_idx List of named indices (label = panel title).
#' @param horizon Horizon to plot.
#' @param palette Named color vector aligned with `names(cells)`.
#' @param subtitle Plot subtitle.
#'
#' @return Patchwork object.
plot_overlay_cells <- function(cells, response_idx, horizon, palette, subtitle) {
  key90 <- sprintf("%.2f", 0.90)
  key68 <- sprintf("%.2f", 0.68)

  panels <- purrr::map(response_idx, function(entry) {
    var_idx <- as.integer(entry)
    var_lbl <- names(entry)

    df <- purrr::imap_dfr(cells, function(s, tag) {
      tibble::tibble(
        h     = 0:horizon,
        point = s$irf$irf_point_matrix[var_idx, seq_len(horizon + 1)],
        lo90  = s$irf$ci[[key90]]$lower[var_idx, seq_len(horizon + 1)],
        hi90  = s$irf$ci[[key90]]$upper[var_idx, seq_len(horizon + 1)],
        lo68  = s$irf$ci[[key68]]$lower[var_idx, seq_len(horizon + 1)],
        hi68  = s$irf$ci[[key68]]$upper[var_idx, seq_len(horizon + 1)],
        spec  = tag
      )
    })

    ggplot2::ggplot(df, ggplot2::aes(x = h, colour = spec, fill = spec)) +
      ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
      ggplot2::geom_ribbon(ggplot2::aes(ymin = lo90, ymax = hi90),
                           alpha = 0.10, colour = NA) +
      ggplot2::geom_ribbon(ggplot2::aes(ymin = lo68, ymax = hi68),
                           alpha = 0.18, colour = NA) +
      ggplot2::geom_line(ggplot2::aes(y = point), linewidth = 0.7) +
      ggplot2::scale_colour_manual(values = palette) +
      ggplot2::scale_fill_manual(values = palette) +
      ggplot2::labs(title = var_lbl, x = NULL, y = NULL) +
      ggplot2::theme_minimal(base_size = 10) +
      ggplot2::theme(legend.position = "bottom",
                     plot.title = ggplot2::element_text(size = 11, face = "bold"))
  })

  patchwork::wrap_plots(panels, ncol = 3, guides = "collect") +
    patchwork::plot_annotation(
      title = "IRFs das especificações vencedoras da varredura",
      subtitle = subtitle
    ) &
    ggplot2::theme(legend.position = "bottom")
}


#' Render a data.frame as a GitHub-flavored markdown table
#'
#' Numeric columns are rounded to `digits` significant figures.
#'
#' @param df Data.frame to render.
#' @param digits Significant digits for numeric columns.
#'
#' @return Character scalar with the markdown table.
md_table <- function(df, digits = 4) {
  fmt <- vapply(df, function(col) {
    if (is.numeric(col)) formatC(signif(col, digits), format = "g", digits = digits)
    else as.character(col)
  }, character(nrow(df)))
  if (nrow(df) == 1) fmt <- matrix(fmt, nrow = 1, dimnames = list(NULL, names(df)))

  header <- paste0("| ", paste(names(df), collapse = " | "), " |")
  sep    <- paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|")
  body   <- apply(fmt, 1, function(row) paste0("| ", paste(row, collapse = " | "), " |"))
  paste(c(header, sep, body), collapse = "\n")
}
