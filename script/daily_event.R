# ===================================================================
# Step 2/5 of the advisor's plan of 2026-10-03: the daily event. Reduced-form
# regressions of the Copom-day changes in the exchange rate and in the 5-year
# CDS on the raw surprise (delta_di) and on the orthogonalized one
# (e_di_bs), with HC1 standard errors. The effect per +50bp in the 6-month DI
# contract is the just-identified IV of the response on the contract's
# change, instrumented by the surprise, with its Anderson-Rubin set at 90 and
# 95%; for the raw surprise the first stage is the identity. The DFM's
# impact responses under the two surprises, on the same base, close the
# comparison. Nothing here decomposes the daily-to-monthly contrast.
# Two bases, the conventions of the window audit (e-mails of 2026-10-17 and
# 2026-10-18):
#   producao_111      the 111 meetings, the seven on the eve of a Brazilian
#                     holiday with the DI window from Wednesday to Friday;
#   sem_feriados_104  those seven left out, the advisor's sensitivity, with
#                     the Bauer-Swanson regression refitted on the 104 and
#                     their months at z = 0 in the DFM.
# Windows, each series on its own calendar: DI, Wednesday close to the first
# DI session after the announcement; exchange rate, Yahoo BRL=X from the last
# quote before the announcement to the first after it, as
# script/copom_timing.R dates them; CDS, the Bloomberg close taken at 17h New
# York (a hypothesis), from the last before the announcement to the first
# after it, and that window widened by one change on each side (e-mail of
# 2026-10-17, item 1), the comparison the e-mail of 2026-10-18 asks for in
# item 2.
# script/instrument.R, script/copom_timing.R, script/download_ptax.R and
# script/irf_coherence_check.R must run first, and
# script/copom_window_comparison.R for the base of 104.
# Outputs: output/daily_event/
#   events.csv            one row per base and meeting: surprises, quotes and
#                         changes
#   regressions.csv       reduced form, first stage and AR sets, by base,
#                         surprise and response
#   comparison.csv        impact per +50bp: daily event and DFM, by base and
#                         surprise
#   fx_alignment.csv      Yahoo BRL=X against the PTAX and the Ibovespa, by
#                         European summer time: which session each row holds
#   fx_event_windows.csv  reduced form of the Yahoo change on the surprise,
#                         by the rows' dates and by the convention, by
#                         European summer time, on the 111: whether the
#                         Wednesday evening quote follows the announcement
# Notes: notas/2026-10-05_evento_diario.md,
#   notas/2026-10-13_cambio_yahoo_convencao.md,
#   notas/2026-10-18_conferencias_ponte.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")
source("R/instrument/di_surprise.R")

BASES <- tibble::tribble(
  ~base,              ~events_path,                                                   ~instruments_path,                                         ~n_events,
  "producao_111",     "data/processed/copom_event_diagnostics.csv",                   "data/processed/instrumentos_mensais.csv",                 111L,
  "sem_feriados_104", "data/processed/copom_event_diagnostics_no_holiday_windows.csv", "data/processed/instrumentos_mensais_no_holiday_windows.csv", 104L
)
MEETINGS_PATH    <- "output/copom_timing/meetings.csv"
PANEL_PATH       <- "data/processed/data_log_deseasonalized.csv"
PTAX_PATH        <- "data/raw/ptax_daily.csv"
YAHOO_BRL_PATH   <- "data/raw/brl_usd_daily.csv"
IBOV_PATH        <- "data/raw/ibov_daily.csv"
THETA_PATH       <- "output/factors/covid_volatility_theta.csv"
CELL_PATH        <- "output/irf/irf_coherence_cell.rds"
WINDOWS_PATH     <- "output/copom_windows/comparison.csv"
OUT_DIR          <- "output/daily_event"
SAMPLE_WINDOW <- as.Date(c("2012-03-01", "2025-12-01"))
R_FACTORS   <- 5L
Q_DYNAMIC   <- 5L
P_LAGS      <- 4L
MP_VAR      <- "yield_6m"
HORIZON     <- 48L
SHOCK_BPS   <- 50
CI_LEVELS   <- c(0.90, 0.95)
SURPRISES   <- c(bruta = "delta_di", ortogonalizada = "e_di_bs")
INSTRUMENTS <- c(bruta = "z_bruto", ortogonalizada = "z_bs_purif")
# Changes of the response over its window
RESPONSES <- c(
  cambio_brl_usd = "d_fx",
  cambio_pct = "d_fx_pct",
  cds_5y = "d_cds_ny17",
  cds_5y_ampliada = "d_cds_widened"
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
windows <- readr::read_csv(MEETINGS_PATH, show_col_types = FALSE) |>
  dplyr::select(
    meeting, wednesday, long_window,
    yahoo_pre, yahoo_post, yahoo_wednesday_after, d_fx, d_fx_pct,
    cds_pre_ny17, cds_post_ny17, d_cds_ny17,
    cds_widened_pre, cds_widened_post, d_cds_widened
  )

# The quotes of every window come from script/copom_timing.R, never carried
# forward; each base keeps its own surprises
events <- purrr::pmap(BASES, \(base, events_path, instruments_path, n_events) {
  readr::read_csv(events_path, show_col_types = FALSE) |>
    dplyr::transmute(
      base = base,
      wednesday = as.Date(wednesday),
      event_date = as.Date(date),
      delta_di,
      e_di_bs
    ) |>
    dplyr::left_join(windows, by = "wednesday") |>
    dplyr::left_join(calendar, by = c("wednesday" = "date"))
}) |>
  purrr::list_rbind()

instruments <- purrr::map(
  purrr::set_names(BASES$instruments_path, BASES$base),
  \(path) dplyr::mutate(readr::read_csv(path, show_col_types = FALSE), month = as.Date(month))
)

# Every meeting of each base has every window; the seven longer DI windows
# are production's only. The surprises are the instrument's own: their
# within-month sums are each base's monthly z_bruto and z_bs_purif
monthly_sums <- events |>
  dplyr::mutate(month = lubridate::floor_date(event_date, "month")) |>
  dplyr::summarise(
    z_bruto_events = sum(delta_di),
    z_bs_purif_events = sum(e_di_bs),
    .by = c(base, month)
  ) |>
  dplyr::right_join(
    purrr::list_rbind(instruments, names_to = "base") |>
      dplyr::select(base, month, z_bruto, z_bs_purif),
    by = c("base", "month")
  ) |>
  dplyr::mutate(
    dplyr::across(dplyr::ends_with("_events"), \(z) tidyr::replace_na(z, 0))
  )
stopifnot(
  !anyNA(events),
  all(table(events$base)[BASES$base] == BASES$n_events),
  sum(events$long_window[events$base == "producao_111"]) == 7L,
  !any(events$long_window[events$base == "sem_feriados_104"]),
  max(abs(monthly_sums$z_bruto_events - monthly_sums$z_bruto)) < 1e-10,
  max(abs(monthly_sums$z_bs_purif_events - monthly_sums$z_bs_purif)) < 1e-10
)

readr::write_csv(events, file.path(OUT_DIR, "events.csv"))

# Daily regressions --------------------------------------------------------

regressions <- tidyr::expand_grid(
  base = BASES$base,
  surprise = names(SURPRISES),
  response = names(RESPONSES)
) |>
  dplyr::mutate(
    fit = purrr::pmap(list(base, surprise, response), \(base_name, surprise, response) {
      # Base subsetting: a dplyr::filter() here would not see the lambda's
      # arguments from inside mutate()'s data mask
      sample <- events[events$base == base_name, ]
      fit_reduced_form_iv(
        sample[[RESPONSES[[response]]]],
        sample[[SURPRISES[[surprise]]]],
        sample$delta_di,
        CI_LEVELS,
        nw_lags = 0L,
        period = seq_len(nrow(sample))
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

dfm_cells <- tidyr::expand_grid(base = BASES$base, surprise = names(INSTRUMENTS)) |>
  dplyr::mutate(
    cell = purrr::map2(base, surprise, \(base_name, surprise_name) {
      run_stage2_cell(
        data_mat,
        dates,
        instruments[[base_name]],
        sample_window = SAMPLE_WINDOW,
        r = R_FACTORS,
        q = Q_DYNAMIC,
        p = P_LAGS,
        instrument = INSTRUMENTS[[surprise_name]],
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
  )

rows <- match(DFM_SERIES, var_names)
dfm_impact <- dfm_cells |>
  dplyr::mutate(
    impact = purrr::map(cell, \(cell) {
      purrr::imap(cell$irf$ar$by_level, \(bounds, key) {
        tibble::tibble(
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
    })
  ) |>
  dplyr::select(base, surprise, impact) |>
  tidyr::unnest(impact) |>
  tidyr::pivot_wider(
    names_from = level,
    values_from = c(lo, hi, set_type, significant)
  )

# Production is the cell script/irf_coherence_check.R cached, and the base of
# 104 the one script/copom_window_comparison.R estimated: same point and 90%
# sets at impact
cached <- readRDS(CELL_PATH)$irf
cached_impact <- tibble::tibble(
  base = "producao_111",
  response = names(DFM_SERIES),
  point_ref = cached$irf_point_matrix[rows, 1],
  lo_ref = cached$ar$by_level[["0.90"]]$lo[rows, 1],
  hi_ref = cached$ar$by_level[["0.90"]]$hi[rows, 1]
)
windows_impact <- readr::read_csv(WINDOWS_PATH, show_col_types = FALSE) |>
  dplyr::filter(cell == "acao_de_gracas_104") |>
  dplyr::transmute(
    base = "sem_feriados_104",
    response = names(DFM_SERIES)[match(variable, DFM_SERIES)],
    point_ref = point,
    lo_ref = lo_0.9,
    hi_ref = hi_0.9
  )
checked <- dfm_impact |>
  dplyr::filter(surprise == "ortogonalizada") |>
  dplyr::inner_join(dplyr::bind_rows(cached_impact, windows_impact), by = c("base", "response"))
stopifnot(
  nrow(checked) == nrow(BASES) * length(DFM_SERIES),
  max(abs(checked$point - checked$point_ref)) < 1e-10,
  max(abs(checked$lo_90 - checked$lo_ref)) < 1e-10,
  max(abs(checked$hi_90 - checked$hi_ref)) < 1e-10
)

comparison <- regressions |>
  dplyr::filter(response %in% c(names(DFM_SERIES), "cds_5y_ampliada")) |>
  dplyr::transmute(
    stage = "evento_diario",
    base,
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
    stage, base, surprise, response, point,
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
# not. Rows on the exact dates; the convention's window is the events'. The
# summer meetings whose Wednesday quote, at 20h, comes after the
# announcement are a group of their own: in the other eight, announced after
# 20h, the rows dated Tuesday and Wednesday both precede the news.
window_changes <- events |>
  dplyr::filter(base == "producao_111") |>
  dplyr::mutate(
    thursday = wednesday + 1L,
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
  group = c("inverno_europeu", "verao_europeu", "verao_quarta_apos_anuncio", "todas"),
  surprise = names(SURPRISES)
) |>
  dplyr::mutate(
    fit = purrr::pmap(list(window, group, surprise), \(window_name, group_name, surprise_name) {
      # Base subsetting: a dplyr::filter() here would not see the lambda's
      # arguments from inside mutate()'s data mask
      in_group <- switch(
        group_name,
        inverno_europeu = !window_changes$eu_summer,
        verao_europeu = window_changes$eu_summer,
        verao_quarta_apos_anuncio = window_changes$eu_summer & window_changes$yahoo_wednesday_after,
        todas = rep(TRUE, nrow(window_changes))
      )
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
