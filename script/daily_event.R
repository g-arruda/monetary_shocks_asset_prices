# ===================================================================
# Step 2/5 of the advisor's plan of 2026-10-03: the daily event, on the
# fixed-horizon Focus base of step 0. Reduced-form regressions of the
# Copom-day changes in the exchange rate and in the 5-year CDS on the raw
# surprise (delta_di) and on the orthogonalized one (e_di_bs), over the same
# 102 meetings, with HC1 standard errors. The effect per +50bp in the 6-month
# DI contract is the just-identified IV of the response on the contract's
# change, instrumented by the surprise, with its Anderson-Rubin set at 90 and
# 95%; for the raw surprise the first stage is the identity. The production
# DFM's impact responses under the two surprises, on the same base, close the
# comparison. Nothing here decomposes the daily-to-monthly contrast.
# Windows: DI, Wednesday close to Thursday close; PTAX, Wednesday 13h to
# Thursday 13h; CDS, Bloomberg close to close. The Copom announces after
# Wednesday's close.
# script/instrument.R, script/download_ptax.R and script/ar_precision.R must
# run first.
# Outputs: output/daily_event/
#   events.csv        one row per meeting: surprises, quotes and changes
#   regressions.csv   reduced form, first stage and AR sets, by surprise
#                     and response
#   comparison.csv    impact per +50bp: daily event and DFM, by surprise
#   fx_alignment.csv  Yahoo BRL=X against the PTAX and the Ibovespa, by
#                     European summer time: why the PTAX is used
# Note: notas/2026-10-05_evento_diario.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")

EVENTS_PATH      <- "data/processed/copom_event_diagnostics.csv"
INSTRUMENTS_PATH <- "data/processed/instrumentos_mensais.csv"
PANEL_PATH       <- "data/processed/data_log_deseasonalized.csv"
PTAX_PATH        <- "data/raw/ptax_daily.csv"
CDS_PATH         <- "data/raw/CDS 5y.xlsx"
YAHOO_BRL_PATH   <- "data/raw/brl_usd_daily.csv"
IBOV_PATH        <- "data/raw/ibov_daily.csv"
THETA_PATH       <- "output/factors/covid_volatility_theta.csv"
PRECISION_PATH   <- "output/ar_precision/table.csv"
OUT_DIR          <- "output/daily_event"
SAMPLE_WINDOW <- as.Date(c("2012-03-01", "2025-12-01"))
N_EVENTS    <- 102L
R_FACTORS   <- 5L
Q_DYNAMIC   <- 5L
P_LAGS      <- 4L
MP_VAR      <- "yield_6m"
HORIZON     <- 48L
SHOCK_BPS   <- 50
CI_LEVELS   <- c(0.90, 0.95)
SURPRISES   <- c(bruta = "delta_di", ortogonalizada = "e_di_bs")
INSTRUMENTS <- c(bruta = "z_bruto", ortogonalizada = "z_bs_purif")
# Changes of the response, Wednesday to Thursday
RESPONSES <- c(
  cambio_brl_usd = "d_fx",
  cambio_pct = "d_fx_pct",
  cds_5y = "d_cds"
)
# The DFM's counterpart of each response, in the same units
DFM_SERIES <- c(cambio_brl_usd = "cambio_usd", cds_5y = "cds_5y")

#' Reduced form, first stage and Anderson-Rubin set of one daily regression
#'
#' The effect of the 6-month DI change on the response, instrumented by the
#' surprise: a just-identified IV with one instrument, every event weighted
#' alike. With b and pi the slopes of the response and of the DI change on
#' the surprise, the Anderson-Rubin set at level kappa is
#' `{beta0 : (b - beta0 pi)^2 <= chi2_1(kappa) Var(b - beta0 pi)}`. The
#' variance comes from the joint HC1 covariance of the two slopes, so the set
#' inverts the HC1 Wald test of the slope of `y - beta0 di_change` on the
#' surprise; at `beta0 = 0` that is the reduced-form test.
#'
#' @param y Change of the response, one entry per event.
#' @param surprise Surprise, in bp.
#' @param di_change Change of the 6-month DI contract, in bp. The raw
#'   surprise is that change, and its first stage is the identity.
#' @param levels Confidence levels.
#'
#' @return One-row tibble, per bp: `n`, the reduced form (`coef`, `se`, `t`,
#'   `p_value`, `r2`), the first stage (`pi`, `se_pi`, `f_first_stage`) and,
#'   for each level, `lo`, `hi`, `set_type` and `significant`, read off the
#'   topology by `ar_excludes_zero()`.
#'
#' @examples
#' fit_event_regression(events$d_cds, events$e_di_bs, events$delta_di,
#'                      c(0.90, 0.95))
fit_event_regression <- function(y, surprise, di_change, levels) {
  n <- length(y)
  reduced_form <- lm(y ~ surprise)
  b <- coef(reduced_form)[[2]]
  if (identical(di_change, surprise)) {
    pi_hat <- 1
    first_stage_residuals <- rep(0, n)
  } else {
    first_stage <- lm(di_change ~ surprise)
    pi_hat <- coef(first_stage)[[2]]
    first_stage_residuals <- residuals(first_stage)
  }

  # Joint HC1 covariance of the two slopes, which share the regressor
  centered <- surprise - mean(surprise)
  scores <- centered * cbind(residuals(reduced_form), first_stage_residuals)
  V <- n / (n - 2) * crossprod(scores) / sum(centered^2)^2

  crit <- qchisq(levels, df = 1)
  sets <- solve_quadratic_le_zero(
    a = pi_hat^2 - crit * V[2, 2],
    b = -2 * (b * pi_hat - crit * V[1, 2]),
    c = b^2 - crit * V[1, 1]
  )
  significant <- as.vector(ar_excludes_zero(
    matrix(sets$type, nrow = 1),
    matrix(sets$lo, nrow = 1),
    matrix(sets$hi, nrow = 1)
  ))
  t_stat <- b / sqrt(V[1, 1])
  p_value <- 2 * pnorm(-abs(t_stat))

  # At every finite bound, the HC1 Wald of y - beta0 x on the surprise is
  # the critical value
  bounds <- tibble::tibble(
    crit = rep(crit, 2),
    beta0 = c(sets$lo, sets$hi)
  ) |>
    dplyr::filter(is.finite(beta0))
  wald_at_bounds <- purrr::map_dbl(bounds$beta0, \(beta0) {
    fit <- lm(y - beta0 * di_change ~ surprise)
    coef(fit)[[2]]^2 / sandwich::vcovHC(fit, type = "HC1")[2, 2]
  })
  stopifnot(max(abs(wald_at_bounds - bounds$crit)) < 1e-8)
  # The set excludes zero iff the reduced-form test rejects at its level
  stopifnot(identical(significant, p_value < 1 - levels))

  tibble::tibble(
    n = n,
    coef = b,
    se = sqrt(V[1, 1]),
    t = t_stat,
    p_value = p_value,
    r2 = summary(reduced_form)$r.squared,
    pi = pi_hat,
    se_pi = sqrt(V[2, 2]),
    f_first_stage = pi_hat^2 / V[2, 2],
    level = sprintf("%.0f", 100 * levels),
    lo = sets$lo,
    hi = sets$hi,
    set_type = sets$type,
    significant = significant
  ) |>
    tidyr::pivot_wider(
      names_from = level,
      values_from = c(lo, hi, set_type, significant)
    )
}

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# European summer time runs from the last Sunday of March to the last Sunday
# of October; lubridate::wday() counts Sunday as day 1
calendar <- tibble::tibble(
  date = seq(as.Date("2010-01-01"), as.Date("2026-12-31"), by = "day")
) |>
  dplyr::mutate(
    march_31 = lubridate::make_date(lubridate::year(date), 3, 31),
    october_31 = lubridate::make_date(lubridate::year(date), 10, 31),
    eu_summer = date >= march_31 - (lubridate::wday(march_31) - 1) &
      date < october_31 - (lubridate::wday(october_31) - 1)
  ) |>
  dplyr::select(date, eu_summer)

# Event panel --------------------------------------------------------------

ptax <- readr::read_csv(PTAX_PATH, show_col_types = FALSE)
cds <- readxl::read_excel(CDS_PATH, skip = 5) |>
  purrr::set_names(c("date", "cds")) |>
  dplyr::transmute(date = as.Date(date), cds = as.numeric(cds)) |>
  dplyr::filter(!is.na(date), !is.na(cds))

# Quotes on the exact dates, never carried forward
events <- readr::read_csv(EVENTS_PATH, show_col_types = FALSE) |>
  dplyr::transmute(
    wednesday = as.Date(date) - 1L,
    thursday = as.Date(date),
    delta_di,
    e_di_bs
  ) |>
  dplyr::left_join(
    dplyr::rename(ptax, ptax_wed = ptax),
    by = c("wednesday" = "date")
  ) |>
  dplyr::left_join(
    dplyr::rename(ptax, ptax_thu = ptax),
    by = c("thursday" = "date")
  ) |>
  dplyr::left_join(
    dplyr::rename(cds, cds_wed = cds),
    by = c("wednesday" = "date")
  ) |>
  dplyr::left_join(
    dplyr::rename(cds, cds_thu = cds),
    by = c("thursday" = "date")
  ) |>
  dplyr::left_join(calendar, by = c("wednesday" = "date")) |>
  dplyr::mutate(
    d_fx = ptax_thu - ptax_wed,
    d_fx_pct = 100 * log(ptax_thu / ptax_wed),
    d_cds = cds_thu - cds_wed
  )

# The common sample is the 102 meetings of the Bauer-Swanson regression:
# every one has both quotes of both series
stopifnot(nrow(events) == N_EVENTS, !anyNA(events))

# The surprises are the instrument's own: their within-month sums are the
# monthly z_bruto and z_bs_purif
instruments <- readr::read_csv(INSTRUMENTS_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))
monthly_sums <- events |>
  dplyr::mutate(month = lubridate::floor_date(thursday, "month")) |>
  dplyr::summarise(
    z_bruto = sum(delta_di),
    z_bs_purif = sum(e_di_bs),
    .by = month
  ) |>
  dplyr::right_join(
    dplyr::select(instruments, month, z_bruto, z_bs_purif),
    by = "month",
    suffix = c("_events", "")
  ) |>
  dplyr::mutate(
    dplyr::across(dplyr::ends_with("_events"), \(z) tidyr::replace_na(z, 0))
  )
stopifnot(
  max(abs(monthly_sums$z_bruto_events - monthly_sums$z_bruto)) < 1e-10,
  max(abs(monthly_sums$z_bs_purif_events - monthly_sums$z_bs_purif)) < 1e-10
)

readr::write_csv(events, file.path(OUT_DIR, "events.csv"))

# Daily regressions --------------------------------------------------------

regressions <- tidyr::expand_grid(
  surprise = names(SURPRISES),
  response = names(RESPONSES)
) |>
  dplyr::mutate(
    fit = purrr::map2(surprise, response, \(surprise, response) {
      fit_event_regression(
        events[[RESPONSES[[response]]]],
        events[[SURPRISES[[surprise]]]],
        events$delta_di,
        CI_LEVELS
      )
    })
  ) |>
  tidyr::unnest(fit) |>
  dplyr::mutate(
    dplyr::across(
      c(coef, se, dplyr::starts_with("lo_"), dplyr::starts_with("hi_")),
      \(value) value * SHOCK_BPS
    )
  )

readr::write_csv(regressions, file.path(OUT_DIR, "regressions.csv"))

# DFM at impact, same base -------------------------------------------------

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)

dfm_cells <- purrr::map(INSTRUMENTS, \(instrument) {
  run_stage2_cell(
    data_mat,
    dates,
    instruments,
    sample_window = SAMPLE_WINDOW,
    r = R_FACTORS,
    q = Q_DYNAMIC,
    p = P_LAGS,
    instrument = instrument,
    mp_var = MP_VAR,
    h = HORIZON,
    shock_bps = SHOCK_BPS,
    tcode = infer_tcode_from_varnames(var_names),
    ci_levels = CI_LEVELS,
    inference = "ar",
    ar_nw_lags = 0L,
    covid_volatility = read_covid_volatility(THETA_PATH)
  )
})

dfm_impact <- purrr::imap(dfm_cells, \(cell, surprise) {
  rows <- match(DFM_SERIES, var_names)
  purrr::imap(cell$irf$ar$by_level, \(bounds, key) {
    tibble::tibble(
      surprise = surprise,
      response = names(DFM_SERIES),
      level = sprintf("%.0f", 100 * as.numeric(key)),
      point = bounds$point[rows, 1],
      lo = bounds$lo[rows, 1],
      hi = bounds$hi[rows, 1],
      set_type = bounds$set_type[rows, 1],
      significant = as.vector(ar_excludes_zero(
        bounds$set_type[rows, 1, drop = FALSE],
        bounds$lo[rows, 1, drop = FALSE],
        bounds$hi[rows, 1, drop = FALSE]
      )),
      xi_mp = cell$irf$ar$xi_den
    )
  }) |>
    purrr::list_rbind()
}) |>
  purrr::list_rbind() |>
  tidyr::pivot_wider(
    names_from = level,
    values_from = c(lo, hi, set_type, significant)
  )

# Production at impact is step 1's: same point and 90/95% sets
step_one <- readr::read_csv(PRECISION_PATH, show_col_types = FALSE) |>
  dplyr::filter(cell == "producao", h == 0L, variable %in% DFM_SERIES) |>
  dplyr::arrange(match(variable, DFM_SERIES))
production <- dplyr::filter(dfm_impact, surprise == "ortogonalizada")
stopifnot(
  max(abs(
    as.matrix(production[c("point", "lo_90", "hi_90", "lo_95", "hi_95")]) -
      as.matrix(step_one[c("point", "lo_90", "hi_90", "lo_95", "hi_95")])
  )) < 1e-10
)

comparison <- regressions |>
  dplyr::filter(response %in% names(DFM_SERIES)) |>
  dplyr::transmute(
    stage = "evento_diario",
    surprise,
    response,
    point = coef / pi,
    lo_90, hi_90, lo_95, hi_95,
    set_type_90, set_type_95,
    significant_90, significant_95,
    f_first_stage
  ) |>
  dplyr::bind_rows(
    dplyr::mutate(dfm_impact, stage = "dfm_mensal")
  ) |>
  dplyr::select(
    stage, surprise, response, point,
    lo_90, hi_90, lo_95, hi_95,
    set_type_90, set_type_95,
    significant_90, significant_95,
    f_first_stage, xi_mp
  )

readr::write_csv(comparison, file.path(OUT_DIR, "comparison.csv"))

# Why the PTAX: alignment of Yahoo BRL=X -----------------------------------

# Daily log changes in each series' own calendar, before any join
yahoo <- readr::read_csv(YAHOO_BRL_PATH, show_col_types = FALSE) |>
  dplyr::arrange(date) |>
  dplyr::transmute(date, d_yahoo = 100 * log(brl / dplyr::lag(brl)))
ptax_changes <- ptax |>
  dplyr::arrange(date) |>
  dplyr::transmute(date, d_ptax = 100 * log(ptax / dplyr::lag(ptax))) |>
  dplyr::mutate(
    d_ptax_lag = dplyr::lag(d_ptax),
    d_ptax_lead = dplyr::lead(d_ptax)
  )
ibov_changes <- readr::read_csv(IBOV_PATH, show_col_types = FALSE) |>
  dplyr::arrange(date) |>
  dplyr::transmute(date, d_ibov = 100 * log(ibov / dplyr::lag(ibov))) |>
  dplyr::mutate(
    d_ibov_lag = dplyr::lag(d_ibov),
    d_ibov_lead = dplyr::lead(d_ibov)
  )

daily_alignment <- yahoo |>
  dplyr::inner_join(ptax_changes, by = "date") |>
  dplyr::inner_join(ibov_changes, by = "date") |>
  dplyr::inner_join(calendar, by = "date") |>
  dplyr::filter(date >= SAMPLE_WINDOW[1]) |>
  tidyr::drop_na() |>
  dplyr::summarise(
    n_days = dplyr::n(),
    cor_ptax_lag = cor(d_yahoo, d_ptax_lag),
    cor_ptax = cor(d_yahoo, d_ptax),
    cor_ptax_lead = cor(d_yahoo, d_ptax_lead),
    cor_ibov_lag = cor(d_yahoo, d_ibov_lag),
    cor_ibov = cor(d_yahoo, d_ibov),
    cor_ibov_lead = cor(d_yahoo, d_ibov_lead),
    .by = eu_summer
  )

# The same comparison on the meetings: the Wed->Thu change read off the
# Yahoo dates against the PTAX one
yahoo_levels <- readr::read_csv(YAHOO_BRL_PATH, show_col_types = FALSE)
event_alignment <- events |>
  dplyr::left_join(
    dplyr::rename(yahoo_levels, yahoo_wed = brl),
    by = c("wednesday" = "date")
  ) |>
  dplyr::left_join(
    dplyr::rename(yahoo_levels, yahoo_thu = brl),
    by = c("thursday" = "date")
  ) |>
  dplyr::mutate(d_yahoo = 100 * log(yahoo_thu / yahoo_wed)) |>
  dplyr::summarise(
    n_events = dplyr::n(),
    n_events_yahoo = sum(!is.na(d_yahoo)),
    cor_events_ptax = cor(d_yahoo, d_fx_pct, use = "complete.obs"),
    .by = eu_summer
  )

daily_alignment |>
  dplyr::left_join(event_alignment, by = "eu_summer") |>
  dplyr::arrange(eu_summer) |>
  readr::write_csv(file.path(OUT_DIR, "fx_alignment.csv"))
