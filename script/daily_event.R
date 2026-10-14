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
# Windows: DI, Wednesday close to Thursday close; exchange rate, Yahoo
# BRL=X from the last quote before the announcement to the first after it,
# as script/copom_timing.R dates them; CDS, Bloomberg close to close. The
# Copom announces after Wednesday's DI close, and Yahoo's Wednesday evening
# quote (20h-22h in Brasilia) comes after the announcement in most meetings.
# script/instrument.R, script/copom_timing.R, script/download_ptax.R and
# script/ar_precision.R must run first.
# Outputs: output/daily_event/
#   events.csv            one row per meeting: surprises, quotes and changes
#   regressions.csv       reduced form, first stage and AR sets, by surprise
#                         and response
#   comparison.csv        impact per +50bp: daily event and DFM, by surprise
#   fx_alignment.csv      Yahoo BRL=X against the PTAX and the Ibovespa, by
#                         European summer time: which session each row holds
#   fx_event_windows.csv  reduced form of the Yahoo change on the surprise,
#                         by the rows' dates and by the convention, by
#                         European summer time: whether the Wednesday
#                         evening quote follows the announcement
# Notes: notas/2026-10-05_evento_diario.md,
#   notas/2026-10-13_cambio_yahoo_convencao.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")
source("R/instrument/di_surprise.R")

EVENTS_PATH      <- "data/processed/copom_event_diagnostics.csv"
MEETINGS_PATH    <- "output/copom_timing/meetings.csv"
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

yahoo <- load_yahoo_brl(YAHOO_BRL_PATH)
cds <- readxl::read_excel(CDS_PATH, skip = 5) |>
  purrr::set_names(c("date", "cds")) |>
  dplyr::transmute(date = as.Date(date), cds = as.numeric(cds)) |>
  dplyr::filter(!is.na(date), !is.na(cds))
fx_windows <- readr::read_csv(MEETINGS_PATH, show_col_types = FALSE) |>
  dplyr::filter(in_events) |>
  dplyr::select(thursday, yahoo_pre, yahoo_post)

# DI and CDS quotes on the exact dates, never carried forward; the Yahoo
# quotes are the last before the announcement and the first after it
events <- readr::read_csv(EVENTS_PATH, show_col_types = FALSE) |>
  dplyr::transmute(
    wednesday = as.Date(date) - 1L,
    thursday = as.Date(date),
    delta_di,
    e_di_bs
  ) |>
  dplyr::left_join(fx_windows, by = "thursday") |>
  dplyr::left_join(
    dplyr::select(yahoo, date, fx_pre = brl),
    by = c("yahoo_pre" = "date")
  ) |>
  dplyr::left_join(
    dplyr::select(yahoo, date, fx_post = brl),
    by = c("yahoo_post" = "date")
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
    d_fx = fx_post - fx_pre,
    d_fx_pct = 100 * log(fx_post / fx_pre),
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
      fit_reduced_form_iv(
        events[[RESPONSES[[response]]]],
        events[[SURPRISES[[surprise]]]],
        events$delta_di,
        CI_LEVELS,
        nw_lags = 0L,
        period = seq_len(nrow(events))
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

# Time of the Yahoo BRL=X quote ---------------------------------------------

# Daily log changes in each series' own calendar, before any join. The PTAX
# (13h) and the Ibovespa session are the clocks: which session's moves does
# the row dated d carry?
yahoo_changes <- yahoo |>
  dplyr::transmute(date, d_yahoo = 100 * log(brl / dplyr::lag(brl)))
ptax_changes <- readr::read_csv(PTAX_PATH, show_col_types = FALSE) |>
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

daily_alignment <- yahoo_changes |>
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
  ) |>
  dplyr::arrange(eu_summer)

readr::write_csv(daily_alignment, file.path(OUT_DIR, "fx_alignment.csv"))

# On the meetings: if Wednesday's evening quote follows the announcement,
# the change between the rows dated Tuesday and Wednesday carries the news
# in the European summer, and the one between Wednesday and Thursday does
# not. Rows on the exact dates; the convention's window is the events'.
window_changes <- events |>
  dplyr::mutate(
    linhas_terca_quarta = 100 * log(
      yahoo$brl[match(wednesday, yahoo$date)] /
        yahoo$brl[match(wednesday - 1L, yahoo$date)]
    ),
    linhas_quarta_quinta = 100 * log(
      yahoo$brl[match(thursday, yahoo$date)] /
        yahoo$brl[match(wednesday, yahoo$date)]
    ),
    convencao = d_fx_pct
  )

fx_event_windows <- tidyr::expand_grid(
  window = c("linhas_terca_quarta", "linhas_quarta_quinta", "convencao"),
  group = c("inverno_europeu", "verao_europeu", "todas"),
  surprise = names(SURPRISES)
) |>
  dplyr::mutate(
    fit = purrr::pmap(list(window, group, surprise), \(window_name, group_name, surprise_name) {
      # Base subsetting: a dplyr::filter() here would not see the lambda's
      # arguments from inside mutate()'s data mask
      in_group <- group_name == "todas" |
        window_changes$eu_summer == (group_name == "verao_europeu")
      sample <- window_changes[in_group & !is.na(window_changes[[window_name]]), ]
      fit_reduced_form_iv(
        sample[[window_name]],
        sample[[SURPRISES[[surprise_name]]]],
        sample$delta_di,
        CI_LEVELS,
        nw_lags = 0L,
        period = seq_len(nrow(sample))
      ) |>
        dplyr::transmute(
          n,
          coef_pct = SHOCK_BPS * coef,
          se_pct = SHOCK_BPS * se,
          p_value
        )
    })
  ) |>
  tidyr::unnest(fit)

readr::write_csv(fx_event_windows, file.path(OUT_DIR, "fx_event_windows.csv"))
