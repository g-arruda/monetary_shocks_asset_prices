# ===================================================================
# Bridge from the daily event to the monthly DFM, check (b) of the
# advisor's e-mail of 2026-10-12, item 2: a simple monthly regression of
# the change in the exchange rate and in the 5-year CDS on the monthly
# surprise, without the DFM's factors, over the DFM's window and with the
# DFM's own series. Branch feature/focus-horizonte-fixo, on the
# fixed-horizon Focus base. Nothing in the instrument, in the panel or in
# the DFM is re-estimated; the DFM cells beside the regressions are the
# production ones.
#
# Rule, fixed and committed before running (author decisions of
# 2026-10-14):
#   Window: the DFM's 162 factor innovations, 2012-07 to 2025-12. The
#     surprise of month t is the instrument's, the sum of the surprises of
#     the meetings whose first DI session after the announcement falls in
#     t (R/instrument/build_variants.R).
#   Surprises: z_bs_purif (orthogonalized, production) and z_bruto (raw),
#     data/processed/instrumentos_mensais.csv.
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
#     162 months; (ii) without the 9 months whose meeting is outside the
#     102 events (Brazilian-holiday and Thanksgiving Thursdays), 153 months;
#     (iii) only the 99 months with a meeting among the 102.
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
# script/instrument.R, script/copom_timing.R, script/ar_precision.R and
# script/daily_event.R must run first.
# Outputs: output/monthly_reduced_form/
#   months.csv       one row per month: surprises, meeting flags and
#                    samples, yield_6m, the four monthly series and the time
#                    of each end-of-month exchange-rate quote
#   changes.csv      one row per month, response, aggregation and h
#   regressions.csv  one row per response, aggregation, sample, surprise
#                    and h: reduced form, first stage and IV with AR sets
#   comparison.csv   the effect per +50bp of yield_6m, monthly regression
#                    (sample (i)) and DFM, by surprise, response and h
# Note: notas/2026-10-14_ponte_mensal_forma_reduzida.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/identification/weak_iv_ar.R")
source("R/instrument/di_surprise.R")

PANEL_PATH       <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENTS_PATH <- "data/processed/instrumentos_mensais.csv"
MEETINGS_PATH    <- "output/copom_timing/meetings.csv"
YAHOO_BRL_PATH   <- "data/raw/brl_usd_daily.csv"
CDS_PATH         <- "data/raw/CDS 5y.xlsx"
THETA_PATH       <- "output/factors/covid_volatility_theta.csv"
PRECISION_PATH   <- "output/ar_precision/table.csv"
DAILY_EVENT_PATH <- "output/daily_event/comparison.csv"
OUT_DIR          <- "output/monthly_reduced_form"
SAMPLE_WINDOW <- as.Date(c("2012-03-01", "2025-12-01"))
R_FACTORS   <- 5L
Q_DYNAMIC   <- 5L
P_LAGS      <- 4L
MP_VAR      <- "yield_6m"
HORIZONS    <- c(0L, 1L)
SHOCK_BPS   <- 50
CI_LEVELS   <- c(0.90, 0.95)
TZ_BRASILIA <- "America/Sao_Paulo"
# Counts the rule is written for; a change in the data stops the script
N_INNOVATIONS    <- 162L
N_EVENTS         <- 102L
N_MEETING_MONTHS <- 99L
N_OUTSIDE        <- 9L
N_END_OF_MONTH   <- 7L
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
instruments <- readr::read_csv(INSTRUMENTS_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))
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

# Meetings by instrument month: the 102 events, and the 9 left out by the
# month the convention would give them
event_months <- meetings |>
  dplyr::filter(in_events) |>
  dplyr::summarise(
    n_events = dplyr::n(),
    z_bs_purif_events = sum(e_di_bs),
    z_bruto_events = sum(delta_di),
    .by = month_instrument
  ) |>
  dplyr::rename(month = month_instrument)
outside_months <- meetings |>
  dplyr::filter(!in_events) |>
  dplyr::distinct(month = month_convention) |>
  dplyr::mutate(reuniao_fora = TRUE)

first_innovation <- sort(panel$ref.date)[P_LAGS + 1L]
months <- panel |>
  dplyr::transmute(
    month = ref.date,
    yield_6m,
    cambio_media = cambio_usd,
    cds_fim_de_mes = cds_5y
  ) |>
  dplyr::left_join(instruments, by = "month") |>
  dplyr::left_join(event_months, by = "month") |>
  dplyr::left_join(outside_months, by = "month") |>
  dplyr::left_join(yahoo_mean, by = "month") |>
  dplyr::left_join(fx_end_of_month, by = "month") |>
  dplyr::left_join(cds_mean, by = "month") |>
  dplyr::arrange(month) |>
  dplyr::mutate(
    period = 12L * lubridate::year(month) + lubridate::month(month),
    janela_dfm = month >= first_innovation,
    reuniao = !is.na(n_events),
    reuniao_fora = !is.na(reuniao_fora),
    d_yield_bp = 1e4 * (yield_6m - dplyr::lag(yield_6m))
  )

window <- dplyr::filter(months, janela_dfm)
end_of_month_rows <- dplyr::filter(months, cambio_fim_de_mes_regra == "antes_do_anuncio")
stopifnot(
  # One month per panel row, no gap, and the instrument on every month
  all(diff(months$period) == 1L),
  !anyNA(months$z_bs_purif),
  # The panel's exchange rate is the Yahoo mean by date
  max(abs(months$cambio_media - months$cambio_media_yahoo)) < 1e-12,
  # The meetings' surprises add up to the instrument
  max(abs(dplyr::coalesce(months$z_bs_purif_events, 0) - months$z_bs_purif)) < 1e-10,
  max(abs(dplyr::coalesce(months$z_bruto_events, 0) - months$z_bruto)) < 1e-10,
  all(months$n_events %in% c(NA, 1L)),
  sum(months$reuniao) == N_EVENTS,
  # The counts the rule is written for
  nrow(window) == N_INNOVATIONS,
  sum(window$reuniao) == N_MEETING_MONTHS,
  sum(window$reuniao_fora) == N_OUTSIDE,
  !any(window$reuniao & window$reuniao_fora),
  # The aligned end of the month departs from the calendar's only in the
  # months whose last session hosts a meeting: there the calendar quote
  # follows the announcement and the one taken precedes it
  nrow(end_of_month_rows) == N_END_OF_MONTH,
  all(end_of_month_rows$calendar_after_announcement),
  all(end_of_month_rows$pre_before_announcement),
  !anyNA(window$cds_media)
)

readr::write_csv(
  dplyr::select(
    months,
    month, janela_dfm, reuniao, reuniao_fora, z_bs_purif, z_bruto,
    yield_6m, d_yield_bp, cambio_media, cambio_fim_de_mes,
    cambio_fim_de_mes_data, cambio_fim_de_mes_hora, cambio_fim_de_mes_regra,
    cds_fim_de_mes, cds_media, cds_media_cotacoes
  ),
  file.path(OUT_DIR, "months.csv")
)

# Changes -------------------------------------------------------------------

changes <- SERIES |>
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
  dplyr::left_join(
    dplyr::select(
      months,
      month, period, janela_dfm, reuniao, reuniao_fora,
      z_bs_purif, z_bruto, d_yield_bp
    ),
    by = "month"
  ) |>
  dplyr::filter(janela_dfm, !is.na(change))

readr::write_csv(
  dplyr::select(changes, month, response, aggregation, measure, h, change),
  file.path(OUT_DIR, "changes.csv")
)

# Regressions ---------------------------------------------------------------

regressions <- tidyr::expand_grid(
  dplyr::distinct(SERIES, response, aggregation, measure),
  sample = SAMPLES,
  surprise = names(SURPRISES),
  h = HORIZONS
) |>
  dplyr::mutate(
    fit = purrr::pmap(
      list(response, aggregation, sample, surprise, h),
      \(response_name, aggregation_name, sample_name, surprise_name, horizon) {
        # Base subsetting: a dplyr::filter() here would not see the lambda's
        # arguments from inside mutate()'s data mask
        in_sample <- switch(
          sample_name,
          zero = rep(TRUE, nrow(changes)),
          sem_reunioes_fora = !changes$reuniao_fora,
          so_reunioes = changes$reuniao
        )
        cell <- changes[
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
  ) |>
  dplyr::select(
    response, aggregation, measure, sample, surprise, h, n, nw_lags,
    coef, se, t, p_value, r2,
    rf_lo_90, rf_hi_90, rf_lo_95, rf_hi_95,
    significant_90, significant_95,
    pi, se_pi, f_first_stage,
    iv_point, iv_lo_90, iv_hi_90, iv_lo_95, iv_hi_95,
    iv_set_type_90, iv_set_type_95
  )

expected_n <- c(
  zero = N_INNOVATIONS,
  sem_reunioes_fora = N_INNOVATIONS - N_OUTSIDE,
  so_reunioes = N_MEETING_MONTHS
)
# h = 1 loses 2025-12, which hosts a meeting
stopifnot(
  all(regressions$n == expected_n[regressions$sample] - regressions$h)
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

dfm <- purrr::imap(SURPRISES, \(instrument, surprise_name) {
  cell <- run_stage2_cell(
    data_mat,
    dates,
    instruments,
    sample_window = SAMPLE_WINDOW,
    r = R_FACTORS,
    q = Q_DYNAMIC,
    p = P_LAGS,
    instrument = instrument,
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
      surprise = surprise_name,
      response = names(DFM_SERIES)[match(variable, DFM_SERIES)],
      xi_mp = cell$irf$ar$xi_den
    )
}) |>
  purrr::list_rbind() |>
  dplyr::mutate(level = sprintf("%.0f", 100 * level)) |>
  tidyr::pivot_wider(
    names_from = level,
    values_from = c(lo, hi, set_type, significant)
  )

# Production is step 1's at h = 0 and 1, and the raw cell is step 2's at
# impact
step_one <- readr::read_csv(PRECISION_PATH, show_col_types = FALSE) |>
  dplyr::filter(cell == "producao", h %in% HORIZONS, variable %in% DFM_SERIES) |>
  dplyr::inner_join(
    dplyr::filter(dfm, surprise == "ortogonalizada"),
    by = c("variable", "h"),
    suffix = c("_step_one", "")
  )
step_two <- readr::read_csv(DAILY_EVENT_PATH, show_col_types = FALSE) |>
  dplyr::filter(stage == "dfm_mensal") |>
  dplyr::inner_join(
    dplyr::filter(dfm, h == 0L),
    by = c("surprise", "response"),
    suffix = c("_step_two", "")
  )
bound_columns <- c("point", "lo_90", "hi_90", "lo_95", "hi_95")
stopifnot(
  nrow(step_one) == length(DFM_SERIES) * length(HORIZONS),
  max(abs(
    as.matrix(step_one[bound_columns]) -
      as.matrix(step_one[paste0(bound_columns, "_step_one")])
  )) < 1e-10,
  nrow(step_two) == length(DFM_SERIES) * length(SURPRISES),
  max(abs(
    as.matrix(step_two[c(bound_columns, "xi_mp")]) -
      as.matrix(step_two[paste0(c(bound_columns, "xi_mp"), "_step_two")])
  )) < 1e-10
)

comparison <- regressions |>
  dplyr::filter(sample == "zero", response %in% names(DFM_SERIES)) |>
  dplyr::transmute(
    stage = paste0("mensal_", aggregation),
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
  dplyr::arrange(response, surprise, h, stage)

readr::write_csv(comparison, file.path(OUT_DIR, "comparison.csv"))
