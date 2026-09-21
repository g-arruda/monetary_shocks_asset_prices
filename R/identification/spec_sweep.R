# ===================================================================
# Helpers for running and comparing DFM specification cells: the shared
# stage-2 path (run_stage2_cell), the normalization value, the dimension
# overlay and md_table. The sweep's scoring and failure taxonomy left for
# arquivo/R/identification/spec_sweep.R on 2026-09-17, with
# irf_spec_sweep.R; the containment rule followed on 2026-09-18, with
# q_truncation.R. Both scripts sit in arquivo/script/.
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


#' Run one winning cell through the full IRF pipeline
#'
#' Production path: the instrument is passed to `estimate_dfm` (temporal
#' alignment happens there) and `compute_irf_dfm` resolves instrument and
#' dates from the DFM object, as in the shared stage-2 production path.
#'
#' @param data_mat Full panel matrix (no date column).
#' @param dates Dates aligned with `data_mat` rows.
#' @param inst_panel Wide instrument data.frame (`month` + one column per variant).
#' @param sample_window Date vector `c(start, end)`.
#' @param r,q,p DFM dimensions and VAR lag order.
#' @param instrument Variant column name in `inst_panel`.
#' @param mp_var Policy variable name.
#' @param h IRF horizon.
#' @param shock_bps Shock size in basis points.
#' @param tcode Transformation codes for the full panel.
#' @param ci_levels Confidence levels of the sets.
#' @param inference `"ar"` or `"none"`, passed through to `compute_irf_dfm()`;
#'   no default.
#' @param ar_nw_lags Newey-West truncation of the AR moment covariance.
#' @param covid_volatility COVID volatility scale of the factor VAR, passed to
#'   `estimate_dfm()`. **Required, with no default**: since 2026-09-17 the
#'   treatment is production (`read_covid_volatility()`), and a
#'   default either way would silently decide for the caller which estimator a
#'   cell runs. A cell that publishes production numbers passes the spec field;
#'   a cell that reproduces a closed round, or that runs a pre-COVID window,
#'   passes NULL and says why. Pre-COVID cannot take it at all: every month of
#'   that window has `s_t = 1`, so the weighted fit *is* the unweighted one, and
#'   `estimate_dfm()` rejects a `covid_start` outside the residual months.
#'
#' @return List with `irf`, `var_names`, `tcode`, `mpind`, `normalize_value`
#'   and the cell keys.
run_stage2_cell <- function(data_mat, dates, inst_panel, sample_window,
                            r, q, p, instrument, mp_var,
                            h, shock_bps, tcode, ci_levels,
                            inference, ar_nw_lags = 0L,
                            covid_volatility) {
  if (missing(covid_volatility)) {
    stop("run_stage2_cell: covid_volatility has no default. Pass ",
         "read_covid_volatility(<theta csv>) for a production cell, or NULL ",
         "for a pre-COVID window or a closed round, and say why ",
         "(notas/2026-09-17_volatilidade_covid_producao.md).")
  }
  in_window <- dates >= sample_window[1] & dates <= sample_window[2]
  data_sub  <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]

  inst_df <- data.frame(month = inst_panel$month, shock = inst_panel[[instrument]])
  inst_df <- inst_df[!is.na(inst_df$shock), ]

  mpind <- match(mp_var, colnames(data_mat))
  if (is.na(mpind)) stop("mp_var '", mp_var, "' not found in panel")

  dfm <- estimate_dfm(data_sub, r = r, q = q, p = p,
                      dates = dates_sub, instrument = inst_df,
                      covid_volatility = covid_volatility)

  norm_val <- norm_value_for(mp_var, shock_bps)

  irf <- compute_irf_dfm(
    dfm,
    h               = h,
    mpind           = mpind,
    normalize_value = norm_val,
    tcode           = tcode,
    ci_levels       = ci_levels,
    inference       = inference,
    ar_nw_lags      = ar_nw_lags
  )

  list(
    irf = irf, var_names = colnames(data_mat), tcode = tcode,
    mpind = mpind, normalize_value = norm_val,
    instrument = instrument, mp_var = mp_var, r = r, q = q, p = p,
    dfm_max_eig = dfm$diagnostics$max_eigenvalue
  )
}


#' One page of the Figure A3 layout: production with bands, alternatives in point
#'
#' Production carries both ribbons and a solid line; the alternatives are
#' point-only dashed lines. A band around a cell whose strength sits below the
#' project's own ruler would suggest an inference that ruler does not license,
#' which is why only `band_df` is ribboned.
#'
#' @param df Long data.frame with `variable`, `h`, `point` and the factor `cell`
#'   used for colour and linetype.
#' @param band_df Same shape restricted to the production cell, plus `lo68`,
#'   `hi68`, `lo90`, `hi90`.
#' @param vars Variables to draw, one panel each, in this order.
#' @param palette,linetypes Named vectors keyed by the levels of `cell`.
#' @param h_max Last horizon on the x axis (breaks every 6 months).
#' @param ncol Panels per row.
#' @param title,subtitle Page annotation.
#'
#' @return Patchwork object.
plot_dimension_overlay <- function(df, band_df, vars, palette, linetypes,
                                   h_max, ncol, title, subtitle) {
  panels <- lapply(vars, function(v) {
    ggplot2::ggplot(df[df$variable == v, ], ggplot2::aes(x = h)) +
      ggplot2::geom_ribbon(data = band_df[band_df$variable == v, ],
                           ggplot2::aes(ymin = lo90, ymax = hi90),
                           fill = "steelblue", alpha = 0.18) +
      ggplot2::geom_ribbon(data = band_df[band_df$variable == v, ],
                           ggplot2::aes(ymin = lo68, ymax = hi68),
                           fill = "steelblue", alpha = 0.36) +
      ggplot2::geom_hline(yintercept = 0, linetype = "dashed",
                          colour = "red", linewidth = 0.35) +
      ggplot2::geom_line(ggplot2::aes(y = point, colour = cell, linetype = cell),
                         linewidth = 0.7) +
      ggplot2::scale_colour_manual(values = palette) +
      ggplot2::scale_linetype_manual(values = linetypes) +
      ggplot2::scale_x_continuous(breaks = seq(0, h_max, 6), expand = c(0.01, 0)) +
      ggplot2::labs(title = v, x = NULL, y = NULL, colour = NULL, linetype = NULL) +
      ggplot2::theme_classic(base_size = 10) +
      ggplot2::theme(plot.title = ggplot2::element_text(size = 10, face = "bold"))
  })

  patchwork::wrap_plots(panels, ncol = ncol, guides = "collect") +
    patchwork::plot_annotation(title = title, subtitle = subtitle) &
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
