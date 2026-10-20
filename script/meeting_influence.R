# ===================================================================
# Step 3/5 of the advisor's plan of 2026-10-03, in the design of his e-mail
# of 2026-10-08 (item 3): how much each Copom meeting weighs on the
# identification, on the fixed-horizon Focus base of step 0, re-run on the
# 111-meeting base on 2026-10-20.
# Factors, factor-VAR coefficients and innovations stay at their full-sample
# estimates. A meeting is excluded by subtracting its orthogonalized surprise
# (e_di_bs) from the monthly sum that forms the instrument, so only the moment
# Gamma = (1/T) sum_t z_t eta_t and its covariance move. Every month stays:
# T = 162 and the calendar of the HAC are unchanged (MOSW's zero-padding,
# SVARIV.m:128). The other meetings keep their full-sample Bauer-Swanson
# residuals, and centering and residualization are production's.
#   A. Production, re-run and checked against the cache.
#   B. Leave-one-out over the 111 meetings. The change of each component of
#      Gamma over its full-sample standard error, maximized over the five
#      components, ranks the meetings: a diagnostic of influence, not a test.
#      For each exclusion, FX and CDS at h0, h1 and h3, xi_mp and F_rob. The
#      three meetings before the first innovation (2012-07) do not enter
#      Gamma and are not ranked.
#   C. Step 3, part 2, by the author's rule fixed before the run (commit
#      2cad8bd): a meeting is flagged when the Wed->Thu log change of the
#      S&P 500, the VIX or Brent is, in absolute value, above the 95th
#      percentile of that series' absolute changes over every trading day of
#      2012-03 to 2025-12. No meeting is selected by FX or CDS. Amended for
#      the 111 meetings (2026-10-16 and author decision of 2026-10-20): the
#      change runs from the Wednesday to the first day, on or after the end
#      of the meeting's DI window, that quotes all three series. That is the
#      Thursday, or the Friday for the 7 meetings whose Thursday is a
#      Brazilian holiday (the DI window) and for the 2 at Thanksgiving, when
#      the NYSE is closed. Those 9 changes span two days and are compared
#      with the same one-day threshold.
#   D. Exclusions together: the 5 and the 10 most influential meetings, and
#      the meetings flagged in C. Every series at the table horizons of step
#      1, AR sets at 90 and 95%, the AR p-value of a zero response, xi_mp and
#      F_rob.
# script/instrument.R, script/irf_coherence_check.R and
# script/ar_precision.R must run first.
# Outputs: output/meeting_influence/
#   ranking.csv             one row per meeting
#   extreme_thresholds.csv  the 95th percentile of each series and the
#                           meetings it flags
#   extreme_meetings.csv    one row per meeting: the window end, the three
#                           changes, the flags and the influence rank
#   joint_table.csv         production, without 5, without 10, without the
#                           extreme moves: every series at the table horizons
#   joint_fx_cds.csv        the same cells, FX and CDS, h0-h36
#   joint_strength.csv      xi_mp and F_rob of the four cells
# Notes: notas/2026-10-08_influencia_reunioes.md,
#        notas/2026-10-12_exclusao_extremos.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")
source("R/identification/factor_space_diagnostics.R")

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrument.csv"
EVENTS_PATH     <- "data/processed/copom_event_diagnostics.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
CELL_PATH       <- "output/irf/irf_coherence_cell.rds"
PRECISION_PATH  <- "output/ar_precision/table.csv"
EXTERNAL_PATH   <- "data/raw/investing/external_factors_daily.csv"
OUT_DIR         <- "output/meeting_influence"
REFERENCE_START <- as.Date("2012-03-01")
REFERENCE_END   <- as.Date("2025-12-31")
EXTREME_PROBABILITY <- 0.95
N_EVENTS    <- 111L
N_TWO_DAY   <- 9L
R_FACTORS   <- 5L
Q_DYNAMIC   <- 5L
P_LAGS      <- 4L
MP_VAR      <- "yield_6m"
SHOCK_BPS   <- 50
HORIZON     <- 48L
H_MAX       <- 36L
H_LOO       <- c(0L, 1L, 3L)
H_TABLE     <- c(0L, 1L, 3L, 6L, 12L, 24L)
CI_LEVELS   <- c(0.90, 0.95)
TOP_EXCLUDED <- c(sem_5 = 5L, sem_10 = 10L)
TARGET_VARS <- c(fx = "cambio_usd", cds = "cds_5y")

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# A. Production ------------------------------------------------------------

production <- main_sdfm(
  data_path = PANEL_PATH,
  instrument_path = INSTRUMENT_PATH,
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_LAGS,
  h = HORIZON,
  mp_var = MP_VAR,
  shock_size_bps = SHOCK_BPS,
  ci_levels = c(0.80, 0.90),
  inference = "ar",
  ar_nw_lags = 0L,
  covid_volatility = read_covid_volatility(THETA_PATH)
)
model <- production$model
var_names <- colnames(production$data)
mpind <- production$mpind
normalize_value <- production$normalize_value
target_rows <- match(TARGET_VARS, var_names)

# The cell is section 4's. FX and CDS are code 1, so the points of the
# moment path are already in published units.
cached <- readRDS(CELL_PATH)$irf
stopifnot(
  identical(production$irfs$irf_point_matrix, cached$irf_point_matrix),
  identical(production$irfs$ci, cached$ci),
  all(production$tcode[target_rows] == 1L)
)

# B. Meetings and their contribution to the monthly instrument --------------

innovation_months <- model$dates[(model$p + 1):length(model$dates)]

# The month of the Thursday, as R/instrument/build_variants.R aggregates
meetings <- readr::read_csv(EVENTS_PATH, show_col_types = FALSE) |>
  dplyr::transmute(
    date,
    wednesday,
    month = lubridate::floor_date(date, "month"),
    in_window = month %in% innovation_months,
    contribution = e_di_bs
  ) |>
  dplyr::mutate(meetings_in_month = dplyr::n(), .by = month)

reproduced <- model$instrument |>
  dplyr::left_join(
    dplyr::summarise(meetings, contribution = sum(contribution), .by = month),
    by = "month"
  )
stopifnot(
  nrow(meetings) == N_EVENTS,
  max(abs(reproduced$shock - dplyr::coalesce(reproduced$contribution, 0))) <
    1e-10
)

#' The production instrument without some meetings
#'
#' Subtracts each excluded meeting's orthogonalized surprise from the monthly
#' sum it enters, so a month with another meeting keeps that one and a month
#' left without meetings is zero, like every month without a meeting. No month
#' is dropped: T and the calendar stay those of production. Reads the
#' script's `model` and `meetings`.
#'
#' @param dates Thursdays of the meetings to exclude; empty for production.
#'
#' @return `model$instrument` (`month`, `shock`) with the contributions of
#'   those meetings removed.
#'
#' @examples
#' instrument_without(as.Date("2014-10-30"))
instrument_without <- function(dates) {
  removed <- meetings |>
    dplyr::filter(date %in% dates) |>
    dplyr::summarise(removed = sum(contribution), .by = month)
  model$instrument |>
    dplyr::left_join(removed, by = "month") |>
    dplyr::mutate(shock = shock - dplyr::coalesce(removed, 0)) |>
    dplyr::select(month, shock)
}

# Full-sample moment and the standard error of each of its components
aligned <- sel_ext_inst_sample(model$dates, model$p, model$instrument)
moments <- ar_dfm_moments(
  model,
  aligned$rsh_sel_ind,
  aligned$inst_sel,
  max(H_LOO)
)
gamma_full <- moments$cov$Gamma
gamma_se <- sqrt(diag(moments$cov$W2) / moments$cov$T_eff)
strength_full <- diagnose_instrument_in_factor_space(
  model,
  model$instrument,
  model$dates,
  model$p,
  mpind
)

response_names <- sprintf(
  "%s_h%d",
  rep(names(TARGET_VARS), each = length(H_LOO)),
  H_LOO
)
reference <- c(
  purrr::set_names(
    as.vector(t(production$irfs$irf_point_matrix[target_rows, H_LOO + 1L])),
    response_names
  ),
  xi_mp = production$irfs$ar$xi_den,
  f_robust_mp = strength_full$f_robust_mp
)

# C. Leave-one-out ----------------------------------------------------------

loo <- purrr::map(meetings$date, function(meeting) {
  instrument <- instrument_without(meeting)
  aligned_loo <- sel_ext_inst_sample(model$dates, model$p, instrument)
  moments_loo <- ar_dfm_moments(
    model,
    aligned_loo$rsh_sel_ind,
    aligned_loo$inst_sel,
    max(H_LOO)
  )
  bounds <- mosw_ar_bounds(
    moments_loo$deriv,
    moments_loo$cov,
    mpind,
    normalize_value,
    CI_LEVELS[1]
  )
  strength <- diagnose_instrument_in_factor_space(
    model,
    instrument,
    model$dates,
    model$p,
    mpind
  )
  stopifnot(
    sum(instrument$shock != model$instrument$shock) == 1L,
    abs(strength$wald_mp / bounds$xi_den - 1) < 1e-8
  )

  gamma_change <- abs(moments_loo$cov$Gamma - gamma_full) / gamma_se
  c(
    influence = max(gamma_change),
    influence_component = which.max(gamma_change),
    purrr::set_names(gamma_change, sprintf("gamma_f%d", seq_len(R_FACTORS))),
    purrr::set_names(
      as.vector(t(bounds$point[target_rows, H_LOO + 1L])),
      response_names
    ),
    xi_mp = bounds$xi_den,
    f_robust_mp = strength$f_robust_mp
  ) |>
    tibble::as_tibble_row()
})

ranking <- meetings |>
  dplyr::bind_cols(purrr::list_rbind(loo)) |>
  dplyr::mutate(
    dplyr::across(
      dplyr::all_of(names(reference)),
      \(value) value - reference[[dplyr::cur_column()]],
      .names = "d_{.col}"
    ),
    influence_component = dplyr::if_else(
      in_window,
      as.integer(influence_component),
      NA_integer_
    )
  ) |>
  dplyr::arrange(dplyr::desc(influence), date) |>
  dplyr::mutate(
    rank = dplyr::if_else(in_window, dplyr::row_number(), NA_integer_),
    .before = 1
  )

# A meeting outside the innovation window leaves Gamma, the responses and the
# strength exactly as they are
outside <- dplyr::filter(ranking, !in_window)
stopifnot(
  all(ranking$influence[ranking$in_window] > 0),
  all(outside$influence == 0),
  max(abs(dplyr::select(outside, dplyr::starts_with("d_")))) < 1e-10
)

ranking |>
  dplyr::select(
    rank, date, month, in_window, meetings_in_month, contribution,
    influence, influence_component, dplyr::starts_with("gamma_f"),
    dplyr::starts_with("fx_"), dplyr::starts_with("d_fx_"),
    dplyr::starts_with("cds_"), dplyr::starts_with("d_cds_"),
    xi_mp, d_xi_mp, f_robust_mp, d_f_robust_mp
  ) |>
  readr::write_csv(file.path(OUT_DIR, "ranking.csv"))

# D. Meetings with an extreme VIX, S&P 500 or Brent move --------------------

# Changes between consecutive rows, as R/instrument/build_variants.R takes
# them, with the VIX in logs instead of points. The rule is two-sided: a
# global risk shock biases FX and CDS upward whatever the sign of the
# monetary shock.
external <- readr::read_csv(EXTERNAL_PATH, show_col_types = FALSE) |>
  dplyr::arrange(date)
external_changes <- external |>
  dplyr::transmute(
    date,
    sp500 = 100 * (log(sp500) - log(dplyr::lag(sp500))),
    vix = 100 * (log(vix) - log(dplyr::lag(vix))),
    brent = 100 * (log(brent) - log(dplyr::lag(brent)))
  ) |>
  tidyr::pivot_longer(-date, names_to = "series", values_to = "change")

# The reference is every trading day whose change exists: a level missing on
# either row (Brent has gaps in 2012-2016, the S&P 500 and the VIX on three
# days the NYSE was closed) leaves that change out, as the rule says
thresholds <- external_changes |>
  dplyr::filter(
    dplyr::between(date, REFERENCE_START, REFERENCE_END),
    !is.na(change)
  ) |>
  dplyr::summarise(
    reference_days = dplyr::n(),
    threshold = quantile(abs(change), EXTREME_PROBABILITY),
    .by = series
  )

# A meeting's window runs from its Wednesday to the first row, on or after
# the last day of its DI window, that quotes the three series
quoted <- tidyr::drop_na(external)
quoted_levels <- quoted |>
  tidyr::pivot_longer(-date, names_to = "series", values_to = "level")

meeting_moves <- meetings |>
  dplyr::transmute(
    date,
    wednesday,
    window_end = quoted$date[
      findInterval(as.numeric(date) - 1, as.numeric(quoted$date)) + 1L
    ]
  ) |>
  dplyr::left_join(
    dplyr::rename(quoted_levels, start_level = level),
    by = dplyr::join_by(wednesday == date)
  ) |>
  dplyr::left_join(
    dplyr::rename(quoted_levels, end_level = level),
    by = dplyr::join_by(window_end == date, series)
  ) |>
  dplyr::left_join(thresholds, by = "series") |>
  dplyr::mutate(
    change = 100 * (log(end_level) - log(start_level)),
    extreme = abs(change) > threshold
  )

# Away from the 7 Brazilian holidays and the 2 Thanksgivings the window is
# Wednesday to Thursday, and the change is the consecutive-row one of the
# run of 2026-10-12
one_day <- meeting_moves |>
  dplyr::filter(window_end == wednesday + 1L) |>
  dplyr::inner_join(
    dplyr::rename(external_changes, row_change = change),
    by = c("date", "series")
  )
two_day_meetings <- unique(
  meeting_moves$date[meeting_moves$window_end != meeting_moves$wednesday + 1L]
)
stopifnot(
  nrow(meeting_moves) == nrow(thresholds) * N_EVENTS,
  !anyNA(meeting_moves$change),
  length(two_day_meetings) == N_TWO_DAY,
  all(meeting_moves$window_end - meeting_moves$wednesday <= 2L),
  nrow(one_day) == nrow(thresholds) * (N_EVENTS - N_TWO_DAY),
  max(abs(one_day$change - one_day$row_change)) < 1e-12
)

extreme_meetings <- meeting_moves |>
  dplyr::select(date, window_end, series, change, extreme) |>
  tidyr::pivot_wider(names_from = series, values_from = c(change, extreme)) |>
  dplyr::mutate(excluded = extreme_sp500 | extreme_vix | extreme_brent) |>
  dplyr::left_join(
    dplyr::select(ranking, date, month, in_window, rank),
    by = "date"
  ) |>
  dplyr::relocate(rank, month, in_window, .after = date) |>
  dplyr::arrange(date)
extreme_dates <- extreme_meetings$date[extreme_meetings$excluded]

thresholds |>
  dplyr::left_join(
    dplyr::summarise(meeting_moves, flagged = sum(extreme), .by = series),
    by = "series"
  ) |>
  readr::write_csv(file.path(OUT_DIR, "extreme_thresholds.csv"))
readr::write_csv(extreme_meetings, file.path(OUT_DIR, "extreme_meetings.csv"))

# E. Meetings excluded together ----------------------------------------------

top_meetings <- ranking |>
  dplyr::filter(in_window) |>
  dplyr::slice_head(n = max(TOP_EXCLUDED)) |>
  dplyr::pull(date)
exclusions <- c(
  list(producao = as.Date(character())),
  purrr::map(TOP_EXCLUDED, \(n_top) utils::head(top_meetings, n_top)),
  list(sem_extremos = extreme_dates)
)

cell_rows <- rep(seq_along(var_names), times = HORIZON + 1L)
cell_horizons <- rep(0:HORIZON, each = length(var_names))

joint <- purrr::imap(exclusions, function(excluded, cell) {
  instrument <- instrument_without(excluded)
  irf <- compute_irf_dfm(
    model,
    instrument = instrument,
    h = HORIZON,
    mpind = mpind,
    normalize_value = normalize_value,
    tcode = production$tcode,
    ci_levels = CI_LEVELS,
    inference = "ar",
    ar_nw_lags = 0L
  )
  aligned_joint <- sel_ext_inst_sample(model$dates, model$p, instrument)
  at_zero <- ar_statistic(
    ar_dfm_moments(
      model,
      aligned_joint$rsh_sel_ind,
      aligned_joint$inst_sel,
      HORIZON
    ),
    mpind,
    normalize_value,
    cell_rows,
    cell_horizons,
    lambda0 = 0
  )
  strength <- diagnose_instrument_in_factor_space(
    model,
    instrument,
    model$dates,
    model$p,
    mpind
  )
  stopifnot(abs(strength$wald_mp / irf$ar$xi_den - 1) < 1e-8)

  sets <- tidy_ar_sets(irf$ar, var_names) |>
    dplyr::mutate(
      cell = cell,
      p_value_zero = rep(at_zero$p_value, times = length(CI_LEVELS))
    )
  # The set at level kappa excludes zero iff AR(0) > critval, whatever its
  # topology; an empty set is counted, never read as a sign. The
  # normalization point is pinned, not tested.
  tested <- dplyr::filter(
    sets,
    !(variable == MP_VAR & h == 0L),
    !is.na(significant)
  )
  stopifnot(
    all((tested$p_value_zero < 1 - tested$level) == tested$significant)
  )

  list(
    irf = irf,
    sets = sets,
    strength = tibble::tibble(
      cell = cell,
      n_excluded = length(excluded),
      excluded = paste(format(excluded), collapse = " "),
      xi_mp = irf$ar$xi_den,
      f_robust_mp = strength$f_robust_mp,
      # xi_mp = T den^2 / Var: the normalizing moment d0'Gamma and the
      # instrument's sum of squares say which side of the ratio moved
      den = irf$ar$den,
      instrument_ss = sum(aligned_joint$inst_sel^2),
      bounded90 = irf$ar$xi_den > qchisq(0.90, 1),
      bounded95 = irf$ar$xi_den > qchisq(0.95, 1),
      empty_sets = sum(is.na(sets$significant))
    )
  )
})

# Excluding nothing is production, and its 95% FX and CDS sets are step 1's
step1_sets <- readr::read_csv(PRECISION_PATH, show_col_types = FALSE) |>
  dplyr::filter(cell == "producao", variable %in% TARGET_VARS) |>
  dplyr::select(variable, h, lo_95, hi_95) |>
  dplyr::inner_join(
    joint$producao$sets |>
      dplyr::filter(level == 0.95) |>
      dplyr::select(variable, h, lo, hi),
    by = c("variable", "h")
  )
stopifnot(
  identical(
    joint$producao$irf$irf_point_matrix,
    production$irfs$irf_point_matrix
  ),
  identical(joint$producao$irf$ci[["0.90"]], production$irfs$ci[["0.90"]]),
  nrow(step1_sets) == length(TARGET_VARS) * length(H_TABLE),
  max(
    abs(step1_sets$lo_95 - step1_sets$lo),
    abs(step1_sets$hi_95 - step1_sets$hi)
  ) < 1e-12
)

joint_sets <- purrr::map(joint, "sets") |>
  purrr::list_rbind() |>
  dplyr::mutate(cell_order = match(cell, names(exclusions)))

joint_sets |>
  dplyr::filter(h %in% H_TABLE) |>
  dplyr::mutate(level = round(100 * level)) |>
  dplyr::arrange(cell_order, variable, h) |>
  dplyr::select(
    cell, variable, h, point, level, lo, hi, set_type, significant,
    p_value_zero
  ) |>
  tidyr::pivot_wider(
    names_from = level,
    values_from = c(lo, hi, set_type, significant)
  ) |>
  readr::write_csv(file.path(OUT_DIR, "joint_table.csv"))

joint_sets |>
  dplyr::filter(variable %in% TARGET_VARS, h <= H_MAX) |>
  dplyr::arrange(cell_order, variable, level, h) |>
  dplyr::select(
    cell, variable, level, h, point, lo, hi, set_type, significant,
    p_value_zero
  ) |>
  readr::write_csv(file.path(OUT_DIR, "joint_fx_cds.csv"))

purrr::map(joint, "strength") |>
  purrr::list_rbind() |>
  readr::write_csv(file.path(OUT_DIR, "joint_strength.csv"))
