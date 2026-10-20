# ===================================================================
# Bridge from the daily event to the monthly DFM, check (b) of the
# advisor's e-mail of 2026-10-12, item 2: a simple monthly regression of
# the change in the exchange rate and in the 5-year CDS on the monthly
# surprise, without the DFM's factors, over the DFM's window and with the
# DFM's own series. Nothing in the instrument, in the panel or in the DFM is
# re-estimated; the DFM cells beside the regressions are the production ones.
#
# Rule, fixed and committed before running (author decisions of
# 2026-10-14):
#   Window: the DFM's 162 factor innovations, 2012-07 to 2025-12. The
#     surprise of month t is the instrument's, the sum of the surprises of
#     the meetings whose first DI session after the announcement falls in
#     t (R/instrument/build_variants.R).
#   Surprises: z_bs_purif (orthogonalized, production) and z_bruto (raw).
#   Responses: exchange rate in R$ per US$ and in % (100 log), CDS in bp.
#   Aggregation, two per series:
#     panel: the DFM's own series. cambio_usd is the monthly mean of the
#       Yahoo BRL=X rows by the file's date; cds_5y is the Investing
#       end-of-month close.
#     alternative, built from the daily files: the exchange rate at the
#       end of the month, the last Yahoo quote of the calendar month by
#       its time in Brasilia (load_yahoo_brl()), except in the months
#       whose last session hosts a Copom meeting, where it is that
#       meeting's last quote before the announcement (yahoo_pre of
#       output/copom_timing/meetings.csv), so that the meeting falls in the
#       month of its surprise, as it does in the end-of-month yield_6m; and
#       the CDS as the monthly mean of the Bloomberg daily close.
#   Samples: (i) z = 0 in every month without a surprise, as in the DFM,
#     162 months; (ii) without the months whose meeting is left out of the
#     base; (iii) only the months with a meeting of the base.
#   Horizons: h = 0, x_t - x_{t-1}; h = 1, x_{t+1} - x_{t-1}. h = 1 loses
#     2025-12, which has no t + 1.
#   Normalization: first the reduced form, per +50bp of surprise, with
#     Wald intervals at 90 and 95%; then the effect per +50bp of the change
#     in the end-of-month yield_6m at t, the DFM's normalization, as a
#     just-identified IV with its first stage (pi, F) and its
#     Anderson-Rubin set at 90 and 95% (fit_reduced_form_iv(),
#     R/identification/weak_iv_ar.R).
#   Inference: HC1 at h = 0; at h = 1, whose windows overlap one month,
#     Newey-West with one Bartlett lag, pairing only calendar neighbours.
#   DFM beside: the production cell under z_bs_purif and under z_bruto,
#     h = 0 and 1, point, AR sets at 90 and 95% and xi_mp.
# Since 2026-10-18, the two bases of the window audit (e-mails of 2026-10-17
# and 2026-10-18), each with the instrument of its own Bauer-Swanson
# regression: producao_111, every meeting in its month, so sample (ii) is
# sample (i) and is not run, and the only z = 0 months are those without a
# meeting; sem_feriados_104, without the seven meetings on the eve of a
# Brazilian holiday, whose months are z = 0 in sample (i), as in that base's
# DFM, and are left out in sample (ii), 155 months.
#
# Reading, fixed before running. The reference row is the one that
# replicates the DFM: panel series, sample (i), orthogonalized surprise.
# For the exchange rate in R$:
#   (i)   Positive at h = 0 or 1 and significant at 90% there: the
#         depreciation appears in the monthly reduced form without factors.
#   (ii)  Positive at some h, never significant at 90%: the monthly reduced
#         form neither shows nor rules out the depreciation.
#   (iii) Negative at h = 0 and 1: the depreciation does not appear at the
#         monthly frequency without factors; it arises only in the DFM.
#   The same rule reads the CDS, whose DFM response is a widening. The
#   other aggregation, the other samples and the raw surprise are read one
#   by one by the same rule, with no joint test; their contrast with the
#   reference row is described, not tested. No significance is not a zero
#   response. The reduced form is per +50bp of the same surprise as bridge
#   (a), so its magnitude compares with (a)'s and not with the DFM's; only
#   the effect per +50bp of yield_6m compares in magnitude with the DFM,
#   with its first stage beside it.
#
# script/instrument.R, script/copom_timing.R, script/irf_coherence_check.R
# and script/daily_event.R must run first.
# Outputs: output/monthly_reduced_form/
#   months.csv       one row per base and month: surprises, meeting flags,
#                    yield_6m, the four monthly series and the time of each
#                    end-of-month exchange-rate quote
#   changes.csv      one row per month, response, aggregation and h
#   regressions.csv  one row per base, response, aggregation, sample,
#                    surprise and h: reduced form, first stage and IV with
#                    AR sets
#   comparison.csv   the effect per +50bp of yield_6m, monthly regression
#                    (sample (i)) and DFM, by base, surprise, response and h
# Notes: notas/2026-10-14_ponte_mensal_forma_reduzida.md,
#   notas/2026-10-18_conferencias_ponte.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")
source("R/instrument/di_surprise.R")

PANEL_PATH       <- "data/processed/data_log_deseasonalized.csv"
MEETINGS_PATH    <- "output/copom_timing/meetings.csv"
YAHOO_BRL_PATH   <- "data/raw/brl_usd_daily.csv"
CDS_PATH         <- "data/raw/CDS 5y.xlsx"
THETA_PATH       <- "output/factors/covid_volatility_theta.csv"
CELL_PATH        <- "output/irf/irf_coherence_cell.rds"
DAILY_EVENT_PATH <- "output/daily_event/comparison.csv"
OUT_DIR          <- "output/monthly_reduced_form"
# Counts the rule is written for; a change in the data stops the script
BASES <- tibble::tribble(
  ~base,              ~events_path,                                                    ~instruments_path,                                           ~n_events, ~n_meeting_months, ~n_outside,
  "producao_111",     "data/processed/copom_event_diagnostics.csv",                    "data/processed/instrumentos_mensais.csv",                   111L,      108L,              0L,
  "sem_feriados_104", "data/processed/copom_event_diagnostics_no_holiday_windows.csv", "data/processed/instrumentos_mensais_no_holiday_windows.csv", 104L,      101L,              7L
)
SAMPLE_WINDOW <- as.Date(c("2012-03-01", "2025-12-01"))
R_FACTORS   <- 5L
Q_DYNAMIC   <- 5L
P_LAGS      <- 4L
MP_VAR      <- "yield_6m"
HORIZONS    <- c(0L, 1L)
SHOCK_BPS   <- 50
CI_LEVELS   <- c(0.90, 0.95)
TZ_BRASILIA <- "America/Sao_Paulo"
N_INNOVATIONS  <- 162L
N_END_OF_MONTH <- 7L
SURPRISES <- c(ortogonalizada = "z_bs_purif", bruta = "z_bruto")
SAMPLES <- c("zero", "sem_reunioes_fora", "so_reunioes")
SERIES <- tibble::tribble(
  ~response,        ~aggregation,  ~measure,       ~column,             ~log_change,
  "cambio_brl_usd", "painel",      "media_mensal", "cambio_media",      FALSE,
  "cambio_brl_usd", "alternativa", "fim_de_mes",   "cambio_fim_de_mes", FALSE,
  "cambio_pct",     "painel",      "media_mensal", "cambio_media",      TRUE,
  "cambio_pct",     "alternativa", "fim_de_mes",   "cambio_fim_de_mes", TRUE,
  "cds_5y",         "painel",      "fim_de_mes",   "cds_fim_de_mes",    FALSE,
  "cds_5y",         "alternativa", "media_mensal", "cds_media",         FALSE
)
# The DFM's counterpart of each response, in the same units
DFM_SERIES <- c(cambio_brl_usd = "cambio_usd", cds_5y = "cds_5y")

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  dplyr::mutate(ref.date = as.Date(ref.date))
meetings <- readr::read_csv(MEETINGS_PATH, show_col_types = FALSE)
yahoo <- load_yahoo_brl(YAHOO_BRL_PATH)
cds <- readxl::read_excel(CDS_PATH, skip = 5) |>
  purrr::set_names(c("date", "cds")) |>
  dplyr::transmute(date = as.Date(date), cds = as.numeric(cds)) |>
  dplyr::filter(!is.na(date), !is.na(cds))

# Monthly series ------------------------------------------------------------

# The panel's exchange rate is the mean of the Yahoo rows by the file's date
yahoo_mean <- yahoo |>
  dplyr::mutate(month = lubridate::floor_date(date, "month")) |>
  dplyr::summarise(cambio_media_yahoo = mean(brl), .by = month)

# End of the month by the quote's time in Brasilia; in the months whose
# last session hosts a meeting, the last quote before its announcement
end_of_month_meetings <- meetings |>
  dplyr::filter(wednesday_last_session_of_month) |>
  dplyr::transmute(
    month = lubridate::floor_date(wednesday, "month"),
    announcement_time = lubridate::ymd_hms(
      paste(wednesday, format(announcement)),
      tz = TZ_BRASILIA
    ),
    date = yahoo_pre
  ) |>
  dplyr::left_join(dplyr::select(yahoo, date, brl, quote_time), by = "date")

calendar_end <- yahoo |>
  dplyr::mutate(
    month = lubridate::floor_date(lubridate::as_date(quote_time), "month")
  ) |>
  dplyr::slice_max(quote_time, by = month) |>
  dplyr::select(month, calendar_date = date, calendar_brl = brl,
                calendar_time = quote_time)

fx_end_of_month <- calendar_end |>
  dplyr::left_join(end_of_month_meetings, by = "month") |>
  dplyr::transmute(
    month,
    cambio_fim_de_mes = dplyr::coalesce(brl, calendar_brl),
    cambio_fim_de_mes_data = dplyr::coalesce(date, calendar_date),
    cambio_fim_de_mes_hora = format(
      dplyr::coalesce(quote_time, calendar_time),
      "%Y-%m-%d %H:%M"
    ),
    cambio_fim_de_mes_regra = dplyr::if_else(
      is.na(brl),
      "mes_civil",
      "antes_do_anuncio"
    ),
    calendar_after_announcement = calendar_time > announcement_time,
    pre_before_announcement = quote_time < announcement_time
  )

cds_mean <- cds |>
  dplyr::mutate(month = lubridate::floor_date(date, "month")) |>
  dplyr::summarise(
    cds_media = mean(cds),
    cds_media_cotacoes = dplyr::n(),
    .by = month
  )

first_innovation <- sort(panel$ref.date)[P_LAGS + 1L]
months <- panel |>
  dplyr::transmute(
    month = ref.date,
    yield_6m,
    cambio_media = cambio_usd,
    cds_fim_de_mes = cds_5y
  ) |>
  dplyr::left_join(yahoo_mean, by = "month") |>
  dplyr::left_join(fx_end_of_month, by = "month") |>
  dplyr::left_join(cds_mean, by = "month") |>
  dplyr::arrange(month) |>
  dplyr::mutate(
    period = 12L * lubridate::year(month) + lubridate::month(month),
    janela_dfm = month >= first_innovation,
    d_yield_bp = 1e4 * (yield_6m - dplyr::lag(yield_6m))
  )

# Each base's instrument, the meetings in each month and the months whose
# meeting the base leaves out
base_months <- purrr::pmap(
  BASES,
  \(base, events_path, instruments_path, n_events, n_meeting_months, n_outside) {
    events <- readr::read_csv(events_path, show_col_types = FALSE)
    event_months <- events |>
      dplyr::mutate(month = lubridate::floor_date(as.Date(date), "month")) |>
      dplyr::summarise(
        n_events = dplyr::n(),
        z_bs_purif_events = sum(e_di_bs),
        z_bruto_events = sum(delta_di),
        .by = month
      )
    outside_months <- meetings |>
      dplyr::filter(!wednesday %in% as.Date(events$wednesday)) |>
      dplyr::distinct(month = month_instrument) |>
      dplyr::mutate(reuniao_fora = TRUE)
    readr::read_csv(instruments_path, show_col_types = FALSE) |>
      dplyr::transmute(base = base, month = as.Date(month), z_bs_purif, z_bruto) |>
      dplyr::left_join(event_months, by = "month") |>
      dplyr::left_join(outside_months, by = "month") |>
      dplyr::mutate(
        reuniao = !is.na(n_events),
        reuniao_fora = !is.na(reuniao_fora)
      )
  }
) |>
  purrr::list_rbind() |>
  dplyr::inner_join(dplyr::select(months, month, period, janela_dfm, d_yield_bp), by = "month")

window <- dplyr::filter(months, janela_dfm)
end_of_month_rows <- dplyr::filter(months, cambio_fim_de_mes_regra == "antes_do_anuncio")
base_counts <- base_months |>
  dplyr::summarise(
    n_months = dplyr::n(),
    n_events = sum(n_events, na.rm = TRUE),
    n_meeting_months = sum(reuniao & janela_dfm),
    n_outside = sum(reuniao_fora & janela_dfm),
    overlap = sum(reuniao & reuniao_fora),
    .by = base
  ) |>
  dplyr::inner_join(BASES, by = "base", suffix = c("", "_rule"))
stopifnot(
  # One month per panel row, no gap, and the instrument on every month
  all(diff(months$period) == 1L),
  !anyNA(base_months$z_bs_purif),
  base_counts$n_months == nrow(months),
  # The panel's exchange rate is the Yahoo mean by date
  max(abs(months$cambio_media - months$cambio_media_yahoo)) < 1e-12,
  # The meetings' surprises add up to each base's instrument
  max(abs(dplyr::coalesce(base_months$z_bs_purif_events, 0) - base_months$z_bs_purif)) < 1e-10,
  max(abs(dplyr::coalesce(base_months$z_bruto_events, 0) - base_months$z_bruto)) < 1e-10,
  all(base_months$n_events %in% c(NA, 1L)),
  # The counts the rule is written for
  nrow(window) == N_INNOVATIONS,
  base_counts$n_events == base_counts$n_events_rule,
  base_counts$n_meeting_months == base_counts$n_meeting_months_rule,
  base_counts$n_outside == base_counts$n_outside_rule,
  base_counts$overlap == 0L,
  # The aligned end of the month departs from the calendar's only in the
  # months whose last session hosts a meeting: there the calendar quote
  # follows the announcement and the one taken precedes it
  nrow(end_of_month_rows) == N_END_OF_MONTH,
  all(end_of_month_rows$calendar_after_announcement),
  all(end_of_month_rows$pre_before_announcement),
  !anyNA(window$cds_media)
)

readr::write_csv(
  base_months |>
    dplyr::inner_join(
      dplyr::select(
        months,
        month, yield_6m, cambio_media, cambio_fim_de_mes,
        cambio_fim_de_mes_data, cambio_fim_de_mes_hora, cambio_fim_de_mes_regra,
        cds_fim_de_mes, cds_media, cds_media_cotacoes
      ),
      by = "month"
    ) |>
    dplyr::select(
      base, month, janela_dfm, reuniao, reuniao_fora, z_bs_purif, z_bruto,
      yield_6m, d_yield_bp, cambio_media, cambio_fim_de_mes,
      cambio_fim_de_mes_data, cambio_fim_de_mes_hora, cambio_fim_de_mes_regra,
      cds_fim_de_mes, cds_media, cds_media_cotacoes
    ),
  file.path(OUT_DIR, "months.csv")
)

# Changes -------------------------------------------------------------------

series_changes <- SERIES |>
  tidyr::expand_grid(h = HORIZONS) |>
  dplyr::mutate(
    data = purrr::pmap(list(column, log_change, h), \(column_name, in_log, horizon) {
      level <- months[[column_name]]
      before <- dplyr::lag(level)
      after <- dplyr::lead(level, horizon)
      tibble::tibble(
        month = months$month,
        change = if (in_log) 100 * log(after / before) else after - before
      )
    })
  ) |>
  tidyr::unnest(data) |>
  dplyr::inner_join(dplyr::select(months, month, janela_dfm), by = "month") |>
  dplyr::filter(janela_dfm, !is.na(change))

readr::write_csv(
  dplyr::select(series_changes, month, response, aggregation, measure, h, change),
  file.path(OUT_DIR, "changes.csv")
)

changes <- series_changes |>
  dplyr::select(-janela_dfm) |>
  dplyr::inner_join(base_months, by = "month", relationship = "many-to-many")

# Regressions ---------------------------------------------------------------

regressions <- tidyr::expand_grid(
  BASES |>
    dplyr::select(base, n_meeting_months, n_outside),
  dplyr::distinct(SERIES, response, aggregation, measure),
  sample = SAMPLES,
  surprise = names(SURPRISES),
  h = HORIZONS
) |>
  # Without a meeting left out, sample (ii) is sample (i)
  dplyr::filter(sample != "sem_reunioes_fora" | n_outside > 0L) |>
  dplyr::mutate(
    fit = purrr::pmap(
      list(base, response, aggregation, sample, surprise, h),
      \(base_name, response_name, aggregation_name, sample_name, surprise_name, horizon) {
        # Base subsetting: a dplyr::filter() here would not see the lambda's
        # arguments from inside mutate()'s data mask
        in_sample <- switch(
          sample_name,
          zero = rep(TRUE, nrow(changes)),
          sem_reunioes_fora = !changes$reuniao_fora,
          so_reunioes = changes$reuniao
        )
        cell <- changes[
          changes$base == base_name &
            changes$response == response_name &
            changes$aggregation == aggregation_name &
            changes$h == horizon &
            in_sample,
        ]
        fit_reduced_form_iv(
          cell$change,
          cell[[SURPRISES[[surprise_name]]]],
          cell$d_yield_bp,
          CI_LEVELS,
          nw_lags = horizon,
          period = cell$period
        )
      }
    )
  ) |>
  tidyr::unnest(fit) |>
  dplyr::mutate(
    expected_n = dplyr::case_when(
      sample == "zero" ~ N_INNOVATIONS,
      sample == "sem_reunioes_fora" ~ N_INNOVATIONS - n_outside,
      sample == "so_reunioes" ~ n_meeting_months
    ),
    nw_lags = h,
    coef = SHOCK_BPS * coef,
    se = SHOCK_BPS * se,
    rf_lo_90 = coef - qnorm(0.95) * se,
    rf_hi_90 = coef + qnorm(0.95) * se,
    rf_lo_95 = coef - qnorm(0.975) * se,
    rf_hi_95 = coef + qnorm(0.975) * se,
    iv_point = coef / pi,
    dplyr::across(
      c(dplyr::starts_with("lo_"), dplyr::starts_with("hi_")),
      \(value) SHOCK_BPS * value
    )
  ) |>
  dplyr::rename_with(
    \(name) paste0("iv_", name),
    c(dplyr::matches("^(lo|hi|set_type)_"))
  )

# h = 1 loses 2025-12, which hosts a meeting
stopifnot(all(regressions$n == regressions$expected_n - regressions$h))

regressions <- dplyr::select(
  regressions,
  base, response, aggregation, measure, sample, surprise, h, n, nw_lags,
  coef, se, t, p_value, r2,
  rf_lo_90, rf_hi_90, rf_lo_95, rf_hi_95,
  significant_90, significant_95,
  pi, se_pi, f_first_stage,
  iv_point, iv_lo_90, iv_hi_90, iv_lo_95, iv_hi_95,
  iv_set_type_90, iv_set_type_95
)

readr::write_csv(regressions, file.path(OUT_DIR, "regressions.csv"))

# DFM, same base ------------------------------------------------------------

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)

dfm <- tidyr::expand_grid(
  BASES |>
    dplyr::select(base, instruments_path),
  surprise = names(SURPRISES)
) |>
  dplyr::mutate(
    sets = purrr::pmap(list(instruments_path, surprise), \(path, surprise_name) {
      instruments <- readr::read_csv(path, show_col_types = FALSE) |>
        dplyr::mutate(month = as.Date(month))
      cell <- run_stage2_cell(
        data_mat,
        dates,
        instruments,
        sample_window = SAMPLE_WINDOW,
        r = R_FACTORS,
        q = Q_DYNAMIC,
        p = P_LAGS,
        instrument = SURPRISES[[surprise_name]],
        mp_var = MP_VAR,
        h = max(HORIZONS),
        shock_bps = SHOCK_BPS,
        tcode = infer_tcode_from_varnames(var_names),
        ci_levels = CI_LEVELS,
        inference = "ar",
        ar_nw_lags = 0L,
        covid_volatility = read_covid_volatility(THETA_PATH)
      )
      tidy_ar_sets(cell$irf$ar, var_names) |>
        dplyr::filter(variable %in% DFM_SERIES) |>
        dplyr::mutate(
          response = names(DFM_SERIES)[match(variable, DFM_SERIES)],
          xi_mp = cell$irf$ar$xi_den
        )
    })
  ) |>
  dplyr::select(base, surprise, sets) |>
  tidyr::unnest(sets) |>
  dplyr::mutate(level = sprintf("%.0f", 100 * level)) |>
  tidyr::pivot_wider(
    names_from = level,
    values_from = c(lo, hi, set_type, significant)
  )

# At impact every cell is step 2's, and production at h = 1 is the cell
# script/irf_coherence_check.R cached
step_two <- readr::read_csv(DAILY_EVENT_PATH, show_col_types = FALSE) |>
  dplyr::filter(stage == "dfm_mensal") |>
  dplyr::inner_join(
    dplyr::filter(dfm, h == 0L),
    by = c("base", "surprise", "response"),
    suffix = c("_step_two", "")
  )
rows <- match(DFM_SERIES, var_names)
cached <- readRDS(CELL_PATH)$irf
production_h1 <- dplyr::filter(dfm, base == "producao_111", surprise == "ortogonalizada", h == 1L)
bound_columns <- c("point", "lo_90", "hi_90", "lo_95", "hi_95")
stopifnot(
  nrow(step_two) == nrow(BASES) * length(DFM_SERIES) * length(SURPRISES),
  max(abs(
    as.matrix(step_two[c(bound_columns, "xi_mp")]) -
      as.matrix(step_two[paste0(c(bound_columns, "xi_mp"), "_step_two")])
  )) < 1e-10,
  production_h1$variable == DFM_SERIES,
  max(abs(production_h1$point - cached$irf_point_matrix[rows, 2])) < 1e-10,
  max(abs(production_h1$lo_90 - cached$ar$by_level[["0.90"]]$lo[rows, 2])) < 1e-10,
  max(abs(production_h1$hi_90 - cached$ar$by_level[["0.90"]]$hi[rows, 2])) < 1e-10
)

comparison <- regressions |>
  dplyr::filter(sample == "zero", response %in% names(DFM_SERIES)) |>
  dplyr::transmute(
    stage = paste0("mensal_", aggregation),
    base,
    measure,
    surprise,
    response,
    h,
    point = iv_point,
    lo_90 = iv_lo_90,
    hi_90 = iv_hi_90,
    lo_95 = iv_lo_95,
    hi_95 = iv_hi_95,
    set_type_90 = iv_set_type_90,
    set_type_95 = iv_set_type_95,
    significant_90,
    significant_95,
    f_first_stage
  ) |>
  dplyr::bind_rows(
    dplyr::transmute(
      dfm,
      stage = "dfm",
      base,
      surprise,
      response,
      h,
      point,
      lo_90, hi_90, lo_95, hi_95,
      set_type_90, set_type_95,
      significant_90, significant_95,
      xi_mp
    )
  ) |>
  dplyr::arrange(base, response, surprise, h, stage)

readr::write_csv(comparison, file.path(OUT_DIR, "comparison.csv"))
