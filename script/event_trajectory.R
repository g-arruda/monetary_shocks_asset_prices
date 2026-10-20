# ===================================================================
# Bridge from the daily event to the monthly DFM, check (a) of the
# advisor's e-mail of 2026-10-12, item 2: the cumulative response of the
# exchange rate and of the 5-year CDS from the last quote before the Copom
# announcement to the 1st, 5th, 10th and 20th quote after it, on the
# orthogonalized surprise of step 2 (e_di_bs). Branch
# feature/focus-horizonte-fixo, on the fixed-horizon Focus base. Nothing in
# the instrument or in the DFM is re-estimated.
#
# Rule, fixed and committed before running:
#   Horizons: k = 1, 5, 10 and 20, the advisor's. k counts the quotes of
#     each series' own market after the announcement, k = 1 being the
#     first: the Yahoo BRL=X evening quotes (five a week, Brazilian
#     holidays included) and the rows of the CDS file.
#   Exchange rate: Yahoo BRL=X only (author decision), from yahoo_pre to
#     the quote k - 1 rows after yahoo_post, the convention's window of
#     output/copom_timing/meetings.csv. Change in R$ per US$, the DFM's own
#     unit, and in % (100 log).
#   CDS: Bloomberg PX_LAST, its close taken at 17h New York (author
#     decision; the time is inferred, not declared by the file), from
#     cds_pre_ny17 to the quote k - 1 rows after cds_post_ny17. In the 27
#     meetings where Wednesday's 17h New York close follows the
#     announcement, the window starts at the quote before Wednesday. Change
#     in bp.
#   Sample: the meetings of step 2 with every horizon in both series. The
#     Yahoo file ends on 2025-12-31, so the meeting of 2025-12-10 has no 20th
#     quote. k = 1 also runs on all the meetings, to check against step 2.
#     Since 2026-10-18, the two bases of the window audit (e-mails of
#     2026-10-17 and 2026-10-18), each with the surprise of its own
#     Bauer-Swanson regression: producao_111, the 111 meetings, a common
#     sample of 110; sem_feriados_104, without the seven on the eve of a
#     Brazilian holiday, a common sample of 103. The FX and CDS windows of
#     those seven follow each series' calendar, not the DI's.
#   Estimation: reduced form only, the change on e_di_bs with a constant,
#     HC1 standard errors, per +50bp of orthogonalized surprise; Wald
#     intervals at 90 and 95%, which with a known normalization are the
#     Anderson-Rubin sets. No normalization by the DI, hence no first stage.
#
# Reading, fixed before running. The exchange rate in R$ is the main
# response; the same rule reads the CDS, whose DFM response is a widening.
#   (i)   Positive at some k and significant at 90% there: the depreciation
#         appears in the daily trajectory within 20 quotes.
#   (ii)  Positive at some k, never significant at 90%: the trajectory
#         does not rule out the reversal, nor does it show it.
#   (iii) Negative at every k: the reversal does not appear within 20
#         quotes, and bridge (b) has to say whether it appears in the
#         passage to monthly data or only in the DFM.
#   The four horizons are read one by one, with no joint test; the windows
#   nest, so the tests are not independent. No significance is not a zero
#   response: point and interval are reported at every k. No magnitude is
#   compared with the DFM, which is normalized by +50bp of the end-of-month
#   yield_6m: only sign and horizon.
#
# script/instrument.R, script/copom_timing.R and script/daily_event.R must
# run first.
# Outputs: output/event_trajectory/
#   paths.csv        one row per base, meeting, series and k: quote dates and
#                    values, change, calendar days from the Wednesday
#   regressions.csv  one row per base, response, k and sample: reduced form
#                    per +50bp, intervals and significance
# Notes: notas/2026-10-14_ponte_trajetoria_evento.md,
#   notas/2026-10-18_conferencias_ponte.md
# ===================================================================

source("R/instrument/di_surprise.R")

MEETINGS_PATH   <- "output/copom_timing/meetings.csv"
YAHOO_BRL_PATH  <- "data/raw/brl_usd_daily.csv"
CDS_PATH        <- "data/raw/CDS 5y.xlsx"
STEP_TWO_PATH   <- "output/daily_event/regressions.csv"
OUT_DIR         <- "output/event_trajectory"
BASES <- tibble::tribble(
  ~base,              ~events_path,                                                    ~n_events,
  "producao_111",     "data/processed/copom_event_diagnostics.csv",                    111L,
  "sem_feriados_104", "data/processed/copom_event_diagnostics_no_holiday_windows.csv", 104L
)
HORIZONS        <- c(1L, 5L, 10L, 20L)
SHOCK_BPS       <- 50
DROPPED_MEETING <- as.Date("2025-12-10")
RESPONSES <- tibble::tribble(
  ~response,        ~series,  ~change_column,
  "cambio_brl_usd", "cambio", "change",
  "cambio_pct",     "cambio", "change_pct",
  "cds_5y",         "cds",    "change"
)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# Quotes, numbered within each series' own calendar. The Yahoo row date is
# the UTC date of the London midnight that opens the bar, so the quote's
# day in Brasilia comes from its time
yahoo <- load_yahoo_brl(YAHOO_BRL_PATH)
cds <- readxl::read_excel(CDS_PATH, skip = 5) |>
  purrr::set_names(c("date", "cds")) |>
  dplyr::transmute(date = as.Date(date), cds = as.numeric(cds)) |>
  dplyr::filter(!is.na(date), !is.na(cds))
quotes <- dplyr::bind_rows(
  dplyr::transmute(
    yahoo,
    series = "cambio",
    date,
    quote = brl,
    day_brasilia = lubridate::as_date(quote_time)
  ),
  dplyr::transmute(cds, series = "cds", date, quote = cds, day_brasilia = date)
) |>
  dplyr::arrange(series, date) |>
  dplyr::mutate(row = dplyr::row_number(), .by = series)

# Each base's surprises, from its own Bauer-Swanson regression, on the
# windows script/copom_timing.R dates
meeting_windows <- readr::read_csv(MEETINGS_PATH, show_col_types = FALSE) |>
  dplyr::select(meeting, wednesday, yahoo_pre, yahoo_post, cds_pre_ny17, cds_post_ny17, d_fx, d_cds_ny17)
meetings <- purrr::pmap(BASES, \(base, events_path, n_events) {
  readr::read_csv(events_path, show_col_types = FALSE) |>
    dplyr::transmute(base = base, wednesday = as.Date(wednesday), e_di_bs)
}) |>
  purrr::list_rbind() |>
  dplyr::left_join(meeting_windows, by = "wednesday")
stopifnot(
  all(table(meetings$base)[BASES$base] == BASES$n_events),
  !anyNA(meetings)
)

# Paths -------------------------------------------------------------------

windows <- dplyr::bind_rows(
  dplyr::transmute(
    meetings,
    base,
    meeting,
    wednesday,
    e_di_bs,
    series = "cambio",
    pre_date = yahoo_pre,
    first_post_date = yahoo_post
  ),
  dplyr::transmute(
    meetings,
    base,
    meeting,
    wednesday,
    e_di_bs,
    series = "cds",
    pre_date = cds_pre_ny17,
    first_post_date = cds_post_ny17
  )
)

paths <- windows |>
  dplyr::left_join(
    dplyr::select(quotes, series, pre_date = date, pre_row = row, pre_quote = quote),
    by = c("series", "pre_date")
  ) |>
  dplyr::left_join(
    dplyr::select(quotes, series, first_post_date = date, first_post_row = row),
    by = c("series", "first_post_date")
  ) |>
  tidyr::expand_grid(k = HORIZONS) |>
  dplyr::mutate(post_row = first_post_row + k - 1L) |>
  dplyr::left_join(
    dplyr::select(
      quotes,
      series,
      post_row = row,
      post_date = date,
      post_quote = quote,
      post_day_brasilia = day_brasilia
    ),
    by = c("series", "post_row")
  ) |>
  dplyr::mutate(
    change = post_quote - pre_quote,
    change_pct = dplyr::if_else(
      series == "cambio",
      100 * log(post_quote / pre_quote),
      NA_real_
    ),
    days = as.integer(post_day_brasilia - wednesday),
    common_sample = !anyNA(post_quote),
    .by = c(base, meeting)
  )

# The only meeting short of a horizon is the last one, in the exchange rate
dropped <- dplyr::distinct(dplyr::filter(paths, !common_sample), base, wednesday)
stopifnot(
  !anyNA(paths$pre_quote),
  !anyNA(paths$first_post_row),
  nrow(dropped) == nrow(BASES),
  dropped$wednesday == DROPPED_MEETING
)

# At k = 1 the windows are the convention's of script/copom_timing.R
first_quote <- paths |>
  dplyr::filter(k == 1L) |>
  dplyr::left_join(dplyr::select(meetings, base, meeting, d_fx, d_cds_ny17), by = c("base", "meeting")) |>
  dplyr::mutate(expected = dplyr::if_else(series == "cambio", d_fx, d_cds_ny17))
stopifnot(max(abs(first_quote$change - first_quote$expected)) < 1e-12)

# A window never reaches past the next meeting's quote before its
# announcement
next_meeting <- paths |>
  dplyr::filter(k == max(HORIZONS)) |>
  dplyr::arrange(base, series, wednesday) |>
  dplyr::mutate(next_pre_row = dplyr::lead(pre_row), .by = c(base, series)) |>
  dplyr::filter(!is.na(next_pre_row))
stopifnot(all(next_meeting$post_row <= next_meeting$next_pre_row))

readr::write_csv(
  dplyr::select(
    paths,
    base, meeting, wednesday, e_di_bs, series, k,
    pre_date, post_date, pre_quote, post_quote,
    change, change_pct, days, common_sample
  ),
  file.path(OUT_DIR, "paths.csv")
)

# Reduced form ------------------------------------------------------------

regressions <- tidyr::expand_grid(
  base = BASES$base,
  RESPONSES,
  k = HORIZONS,
  sample = c("comum", "passo_2")
) |>
  dplyr::filter(sample == "comum" | k == 1L) |>
  dplyr::mutate(
    fit = purrr::pmap(
      list(base, series, change_column, k, sample),
      \(base_name, series_name, change_name, horizon, sample_name) {
        # Base subsetting: a dplyr::filter() here would not see the lambda's
        # arguments from inside mutate()'s data mask
        cell <- paths[
          paths$base == base_name &
            paths$series == series_name &
            paths$k == horizon &
            (sample_name == "passo_2" | paths$common_sample),
        ]
        fit <- lm(cell[[change_name]] ~ cell$e_di_bs)
        slope <- coef(fit)[[2]]
        slope_se <- sqrt(sandwich::vcovHC(fit, type = "HC1")[2, 2])
        tibble::tibble(
          n = nrow(cell),
          coef = SHOCK_BPS * slope,
          se = SHOCK_BPS * slope_se,
          t = slope / slope_se,
          p_value = 2 * pnorm(-abs(slope / slope_se)),
          r2 = summary(fit)$r.squared,
          median_days = median(cell$days)
        )
      }
    )
  ) |>
  tidyr::unnest(fit) |>
  dplyr::mutate(
    lo_90 = coef - qnorm(0.95) * se,
    hi_90 = coef + qnorm(0.95) * se,
    lo_95 = coef - qnorm(0.975) * se,
    hi_95 = coef + qnorm(0.975) * se,
    significant_90 = p_value < 0.10,
    significant_95 = p_value < 0.05
  ) |>
  dplyr::select(-series, -change_column)

# On all the meetings of a base, k = 1 is step 2's orthogonalized row, in the
# exchange rate and in the CDS's 17h New York window
step_two <- readr::read_csv(STEP_TWO_PATH, show_col_types = FALSE) |>
  dplyr::filter(
    surprise == "ortogonalizada",
    response %in% RESPONSES$response
  )
replicated <- regressions |>
  dplyr::filter(sample == "passo_2") |>
  dplyr::right_join(
    dplyr::select(
      step_two,
      base,
      response,
      coef_step_two = coef,
      se_step_two = se,
      p_step_two = p_value
    ),
    by = c("base", "response")
  )
stopifnot(
  nrow(replicated) == nrow(BASES) * nrow(RESPONSES),
  replicated$n == BASES$n_events[match(replicated$base, BASES$base)],
  max(abs(replicated$coef - replicated$coef_step_two)) < 1e-10,
  max(abs(replicated$se - replicated$se_step_two)) < 1e-10,
  max(abs(replicated$p_value - replicated$p_step_two)) < 1e-10
)

readr::write_csv(regressions, file.path(OUT_DIR, "regressions.csv"))
