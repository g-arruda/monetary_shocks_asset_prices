# ===================================================================
# Bridge from the daily event to the monthly DFM, the check that comes
# first (advisor's e-mail of 2026-10-12, item 2): what "Copom day" means
# for each quote. A quote before the announcement must come from a session
# that ends before the statement is out, and the first quote after it is
# that market's next session. For each of the 111 meetings of 2012-03 to
# 2025-12 this script dates the announcement, finds the last quote before
# it and the first after it in the DI, the PTAX and the CDS, compares them
# with the dates the instrument (R/instrument/build_variants.R) and
# script/daily_event.R use, and maps the meetings to the instrument's
# months. Nothing is re-estimated and the instrument is not touched.
#
# Announcement: the end of the second day's last session, from each
# minute (script/download_copom_minutes.R), or the earliest release time
# the BCB announced for the period, whichever is later.
# DI: CloseRate, the last trade of the session.
# PTAX: average of the four 10h-13h consultations (Circular 3.506).
# CDS: Bloomberg PX_LAST of BRAZIL CDS USD SR 5Y D14 Corp. The pricing
#   source and the closing time are not in the file. Bloomberg's CDS guide
#   gives a New York close, a 17h snapshot (CBGN) or an intraday composite
#   that closes around 18h (CBIN); both are carried as hypotheses, and
#   three tests infer the close from the data.
#
# Reading rule of the CDS tests, fixed before running them:
#   (A) Calendar. A New York close quotes on UK-only holidays and not on
#       US-only ones, a London close the reverse. Quotes on both, or on
#       days both markets close, leave the calendar uninformative.
#   (B) Alignment, every trading day of 2012-03 to 2025-12, by US daylight
#       saving time. With a New York close the change dated d spans the
#       whole Ibovespa session of d and part of the PTAX change of d+1
#       (13h of d to 13h of d+1); with a London close (16h30, 12h30 or
#       13h30 in Brasilia) it spans the afternoon of d-1 and the PTAX
#       change of d. "Nova York" if, in both regimes, |cor(Ibov d-1)| <
#       0.1, |cor(Ibov d)| is the largest of the three Ibovespa
#       correlations and |cor(PTAX d+1)| >= 0.1; "Londres" if, in both,
#       |cor(Ibov d-1)| >= |cor(Ibov d)| and |cor(PTAX d+1)| < 0.1;
#       "inconclusivo" otherwise. The test cannot tell 17h from 18h.
#   (C) Event, descriptive only. CDS change from the quote before
#       Wednesday to Wednesday's, from Wednesday's to Thursday's and across
#       both, on the surprise, over the 102 meetings and split by whether
#       Wednesday's 17h New York close comes before or after the
#       announcement. It decides nothing.
#
# script/instrument.R, script/download_ptax.R,
# script/download_copom_minutes.R and script/daily_event.R must run first.
# Outputs: output/copom_timing/
#   meetings.csv             one row per meeting: announcement, quote dates
#                            of each series by the convention and as used,
#                            instrument month, changes in the windows
#   months.csv               instrument months: meetings, events and z
#   cds_calendar.csv         test (A)
#   cds_alignment.csv        test (B)
#   cds_event.csv            test (C)
#   di_close_settlement.csv  Wednesday's DI close against its settlement
# Note: notas/2026-10-13_ponte_horarios_copom.md
# ===================================================================

source("R/instrument/di_surprise.R")

COPOM_PATH       <- "data/raw/copom_historico.csv"
ATAS_PATH        <- "data/raw/copom_atas.csv"
DI_PATH          <- "data/raw/di.csv"
PTAX_PATH        <- "data/raw/ptax_daily.csv"
CDS_PATH         <- "data/raw/CDS 5y.xlsx"
IBOV_PATH        <- "data/raw/ibov_daily.csv"
EXTERNAL_PATH    <- "data/raw/investing/external_factors_daily.csv"
YIELDS_PATH      <- "data/raw/yields/yields_dia.csv"
EVENTS_PATH      <- "data/processed/copom_event_diagnostics.csv"
INSTRUMENTS_PATH <- "data/processed/instrumentos_mensais.csv"
DAILY_EVENT_PATH <- "output/daily_event/events.csv"
OUT_DIR          <- "output/copom_timing"
SAMPLE_START <- as.Date("2012-03-01")
SAMPLE_END   <- as.Date("2025-12-31")
N_MEETINGS   <- 111L
N_EVENTS     <- 102L
TARGET_BD    <- 126
MIN_BD       <- 10
SHOCK_BPS    <- 50
TZ_BRASILIA  <- "America/Sao_Paulo"
TZ_NEW_YORK  <- "America/New_York"
CDS_CLOSE_NY <- c(ny17 = "17:00", ny18 = "18:00")

# Earliest release time the BCB announced, from the first meeting it
# applied to. Before 2016-07-20 there was none ("00:00"): the statement
# followed the meeting, whose second day started around 16h30. The floors
# of November to March in 2017-18, 2018-19 and 2019-20 were not found; the
# notes of 2019-03-12 and 2020-03-12 only say the release returns to 18h.
RELEASE_FLOORS <- tibble::tribble(
  ~from,        ~release_floor, ~floor_source,
  "2012-01-01", "00:00",        "sem horario minimo",
  "2016-07-20", "18:00",        "nota do BCB de 11/07/2016",
  "2017-02-22", "18:20",        "nota do BCB de 21/02/2017",
  "2017-04-12", "18:00",        "nota do BCB de 10/04/2017",
  "2019-03-20", "18:00",        "nota do BCB de 12/03/2019",
  "2020-03-18", "18:00",        "nota do BCB de 12/03/2020",
  "2020-12-09", "18:30",        "nota do BCB de 17/11/2020",
  "2021-01-20", "18:30",        "Resolucao BCB 61, de 13/01/2021"
) |>
  dplyr::mutate(from = as.Date(from))

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# Inputs -----------------------------------------------------------------

wednesdays <- load_copom_wednesdays(COPOM_PATH, SAMPLE_START, SAMPLE_END)
stopifnot(length(wednesdays) == N_MEETINGS)

di <- load_di_panel(DI_PATH, SAMPLE_START - 31, SAMPLE_END + 31)
di_sessions <- sort(unique(di$date))

ptax <- readr::read_csv(PTAX_PATH, show_col_types = FALSE)
cds <- readxl::read_excel(CDS_PATH, skip = 5) |>
  purrr::set_names(c("date", "cds")) |>
  dplyr::transmute(date = as.Date(date), cds = as.numeric(cds)) |>
  dplyr::filter(!is.na(date), !is.na(cds))
ibov <- readr::read_csv(IBOV_PATH, show_col_types = FALSE)
external <- readr::read_csv(EXTERNAL_PATH, show_col_types = FALSE)
instruments <- readr::read_csv(INSTRUMENTS_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))
events <- readr::read_csv(EVENTS_PATH, show_col_types = FALSE) |>
  dplyr::transmute(thursday = as.Date(date), delta_di, e_di_bs)
stopifnot(nrow(events) == N_EVENTS)

# Announcement time --------------------------------------------------------

# The session block runs from "Horario de inicio" to the list of members.
# Its last time is the end of the second day's last session, and its last
# day/month must be the Wednesday: "20h50 (7/3)" up to 2016,
# "31/7: 14h00 - 18h10" after.
announcements <- readr::read_csv(ATAS_PATH, show_col_types = FALSE) |>
  dplyr::mutate(
    session_block = text |>
      stringr::str_replace_all("<[^>]+>", " ") |>
      stringr::str_replace_all("&nbsp;", " ") |>
      stringr::str_squish() |>
      stringr::str_extract("Hor[^ ]* de in[^ ]*.*?Presentes"),
    minutes_end = session_block |>
      stringr::str_extract_all("\\d{1,2}h\\d{0,2}") |>
      purrr::map_chr(dplyr::last) |>
      stringr::str_replace("h$", "h00") |>
      stringr::str_replace("h", ":") |>
      stringr::str_pad(5, pad = "0"),
    last_day_month = session_block |>
      stringr::str_extract_all("\\d{1,2}/\\d{1,2}") |>
      purrr::map_chr(dplyr::last)
  ) |>
  dplyr::filter(meeting_date %in% wednesdays)

stopifnot(
  nrow(announcements) == N_MEETINGS,
  !anyNA(announcements$minutes_end),
  announcements$last_day_month == paste0(
    lubridate::mday(announcements$meeting_date),
    "/",
    lubridate::month(announcements$meeting_date)
  ) |
    announcements$last_day_month == format(announcements$meeting_date, "%d/%m")
)

meetings <- announcements |>
  dplyr::transmute(meeting, wednesday = meeting_date, minutes_end) |>
  dplyr::left_join(
    RELEASE_FLOORS,
    by = dplyr::join_by(closest(wednesday >= from))
  ) |>
  dplyr::mutate(
    announcement = pmax(
      lubridate::ymd_hm(paste(wednesday, minutes_end), tz = TZ_BRASILIA),
      lubridate::ymd_hm(paste(wednesday, release_floor), tz = TZ_BRASILIA)
    ),
    thursday = wednesday + 1L
  ) |>
  dplyr::select(-from)

# Quote dates by the convention ---------------------------------------------

# DI and PTAX: their sessions end before the release (the DI at 18h at the
# latest, the PTAX at 13h), so the last quote before is the Wednesday's and
# the first after is the next session of each market
meetings <- meetings |>
  dplyr::mutate(
    di_pre = di_sessions[findInterval(as.numeric(wednesday), as.numeric(di_sessions))],
    di_post = di_sessions[findInterval(as.numeric(wednesday), as.numeric(di_sessions)) + 1L],
    ptax_pre = ptax$date[findInterval(as.numeric(wednesday), as.numeric(ptax$date))],
    ptax_post = ptax$date[findInterval(as.numeric(wednesday), as.numeric(ptax$date)) + 1L],
    in_events = thursday %in% events$thursday,
    drop_reason = dplyr::case_when(
      in_events ~ NA_character_,
      !thursday %in% di_sessions ~ "quinta feriado no Brasil",
      !thursday %in% external$date ~ "quinta sem S&P 500, VIX e Brent"
    ),
    # The instrument's month is the Thursday's; the convention's, that of
    # the first DI session after the announcement
    month_instrument = dplyr::if_else(
      in_events,
      lubridate::floor_date(thursday, "month"),
      as.Date(NA)
    ),
    month_convention = lubridate::floor_date(di_post, "month"),
    wednesday_last_session_of_month =
      lubridate::floor_date(di_post, "month") != lubridate::floor_date(wednesday, "month")
  )

stopifnot(
  sum(meetings$in_events) == N_EVENTS,
  !anyNA(meetings$drop_reason[!meetings$in_events]),
  with(dplyr::filter(meetings, in_events), all(
    di_pre == wednesday & di_post == thursday &
      ptax_pre == wednesday & ptax_post == thursday &
      month_instrument == month_convention
  ))
)

# CDS: under each hypothesis, Wednesday's close falls before or after the
# announcement; if after, the window runs from the quote before Wednesday
# to Wednesday's
cds_windows <- tidyr::expand_grid(
  dplyr::select(meetings, meeting, wednesday, announcement),
  hypothesis = names(CDS_CLOSE_NY)
) |>
  dplyr::mutate(
    cds_close_brasilia = purrr::map2(wednesday, hypothesis, \(day, hypothesis) {
      lubridate::ymd_hm(paste(day, CDS_CLOSE_NY[[hypothesis]]), tz = TZ_NEW_YORK) |>
        lubridate::with_tz(TZ_BRASILIA)
    }) |>
      purrr::list_c(),
    wednesday_close_after = cds_close_brasilia > announcement,
    cds_before_wednesday = cds$date[findInterval(as.numeric(wednesday) - 1, as.numeric(cds$date))],
    cds_after_wednesday = cds$date[findInterval(as.numeric(wednesday), as.numeric(cds$date)) + 1L],
    cds_pre = dplyr::if_else(wednesday_close_after, cds_before_wednesday, wednesday),
    cds_post = dplyr::if_else(wednesday_close_after, wednesday, cds_after_wednesday)
  ) |>
  dplyr::left_join(dplyr::rename(cds, cds_pre_quote = cds), by = c("cds_pre" = "date")) |>
  dplyr::left_join(dplyr::rename(cds, cds_post_quote = cds), by = c("cds_post" = "date")) |>
  dplyr::transmute(
    meeting,
    hypothesis,
    cds_close_brasilia = format(cds_close_brasilia, "%H:%M"),
    wednesday_close_after,
    cds_pre,
    cds_post,
    d_cds = cds_post_quote - cds_pre_quote
  )

# Changes by the convention, the nine meetings out included ------------------

# The first DI session after the announcement plays the Thursday, so that
# build_thursday_surprises() differences the Wednesday close against it; on
# the 102 that session is the Thursday and nothing moves
post_sessions <- dplyr::filter(meetings, di_post != thursday)
di_convention <- di |>
  dplyr::mutate(
    date = dplyr::coalesce(
      post_sessions$thursday[match(date, post_sessions$di_post)],
      date
    )
  )
surprises_convention <- build_thursday_surprises(
  di_convention,
  meetings$thursday,
  target_bd = TARGET_BD,
  min_bd = MIN_BD
) |>
  dplyr::rename(thursday = date, delta_di_convention = delta_di)

meetings <- meetings |>
  dplyr::left_join(surprises_convention, by = "thursday") |>
  dplyr::left_join(events, by = "thursday") |>
  dplyr::left_join(dplyr::rename(ptax, ptax_pre_quote = ptax), by = c("ptax_pre" = "date")) |>
  dplyr::left_join(dplyr::rename(ptax, ptax_post_quote = ptax), by = c("ptax_post" = "date")) |>
  dplyr::mutate(
    d_ptax = ptax_post_quote - ptax_pre_quote,
    d_ptax_pct = 100 * log(ptax_post_quote / ptax_pre_quote)
  ) |>
  dplyr::select(-ptax_pre_quote, -ptax_post_quote)

stopifnot(
  !anyNA(meetings$delta_di_convention),
  with(dplyr::filter(meetings, in_events), max(abs(delta_di_convention - delta_di)) < 1e-12)
)

# The 102 of script/daily_event.R are these: same dates, same surprises, and
# its CDS window is Wednesday to Thursday
daily_event <- readr::read_csv(DAILY_EVENT_PATH, show_col_types = FALSE)
stopifnot(
  identical(sort(daily_event$thursday), sort(events$thursday)),
  max(abs(daily_event$delta_di - meetings$delta_di[match(daily_event$thursday, meetings$thursday)])) < 1e-12
)

# Months ---------------------------------------------------------------------

# A meeting on the month's last session goes to the next month. The panel's
# yield_6m is the month's last quote of the advisor's curve; for those
# meetings it must be the Wednesday's, before the announcement
yields_last_quote <- readr::read_csv(YIELDS_PATH, show_col_types = FALSE) |>
  dplyr::transmute(date = lubridate::dmy(Data)) |>
  dplyr::summarise(
    yield_last_quote = max(date),
    .by = c(month = lubridate::floor_date(date, "month"))
  )
meetings <- meetings |>
  dplyr::mutate(wednesday_month = lubridate::floor_date(wednesday, "month")) |>
  dplyr::left_join(yields_last_quote, by = c("wednesday_month" = "month")) |>
  dplyr::select(-wednesday_month)
stopifnot(with(
  dplyr::filter(meetings, wednesday_last_session_of_month),
  all(yield_last_quote == wednesday)
))

months <- instruments |>
  dplyr::filter(month >= SAMPLE_START, month <= SAMPLE_END) |>
  dplyr::select(month, z_bruto, z_bs_purif) |>
  dplyr::left_join(
    dplyr::summarise(
      meetings,
      n_meetings = dplyr::n(),
      n_events = sum(in_events),
      sum_delta_di = sum(delta_di, na.rm = TRUE),
      sum_e_di_bs = sum(e_di_bs, na.rm = TRUE),
      .by = c(month = month_convention)
    ),
    by = "month"
  ) |>
  dplyr::mutate(
    dplyr::across(c(n_meetings, n_events, sum_delta_di, sum_e_di_bs), \(x) tidyr::replace_na(x, 0)),
    decision_with_zero_z = n_meetings > n_events
  )
stopifnot(
  sum(months$n_meetings) == N_MEETINGS,
  max(abs(months$sum_delta_di - months$z_bruto)) < 1e-10,
  max(abs(months$sum_e_di_bs - months$z_bs_purif)) < 1e-10
)

readr::write_csv(
  dplyr::select(months, -sum_delta_di, -sum_e_di_bs),
  file.path(OUT_DIR, "months.csv")
)

# DI: Wednesday's close against its settlement --------------------------------

# The instrument's contract, re-selected to read its settlement too: the
# settlement comes from the regular session's closing window, before the
# release, and the close is the session's last trade. Every Wednesday ->
# Thursday pair of the sample enters, the Copom ones flagged.
di_rates <- readr::read_csv(DI_PATH, show_col_types = FALSE) |>
  dplyr::transmute(
    date = as.Date(TradeDate),
    ticker = TickerSymbol,
    bdays = as.integer(BDaysToExp),
    close_rate = as.numeric(CloseRate),
    settlement_rate = as.numeric(SettlementRate)
  ) |>
  dplyr::filter(date >= SAMPLE_START, date <= SAMPLE_END, bdays > 0, !is.na(close_rate))
sample_days <- seq(SAMPLE_START, SAMPLE_END, by = "day")
all_thursdays <- sample_days[lubridate::wday(sample_days) == 5]
di_pairs <- di_rates |>
  dplyr::filter(date %in% (all_thursdays - 1L), bdays >= MIN_BD) |>
  dplyr::transmute(thursday = date + 1L, ticker, bdays, close_wed = close_rate, settle_wed = settlement_rate) |>
  dplyr::inner_join(
    dplyr::transmute(di_rates, thursday = date, ticker, close_thu = close_rate, settle_thu = settlement_rate),
    by = c("thursday", "ticker")
  ) |>
  dplyr::slice_min(abs(bdays - TARGET_BD), n = 1, with_ties = FALSE, by = thursday) |>
  dplyr::transmute(
    thursday,
    copom = thursday %in% events$thursday,
    delta_close = 10000 * (close_thu - close_wed),
    delta_settlement = 10000 * (settle_thu - settle_wed),
    gap_wednesday = 10000 * (close_wed - settle_wed)
  )
copom_pairs <- dplyr::filter(di_pairs, copom)
stopifnot(
  nrow(copom_pairs) == N_EVENTS,
  max(abs(copom_pairs$delta_close - events$delta_di[match(copom_pairs$thursday, events$thursday)])) < 1e-9
)

# If trades after the release entered Wednesday's close, the gap would move
# with the news the settlement-to-settlement change carries. The gap and
# that change share minus the Wednesday settlement, a small mechanical
# positive term.
gap_fit <- lm(gap_wednesday ~ delta_settlement, data = copom_pairs)
gap_se <- sqrt(sandwich::vcovHC(gap_fit, type = "HC1")[2, 2])
di_close_settlement <- tibble::tibble(
  n_copom = nrow(copom_pairs),
  cor_close_settlement_surprise = cor(copom_pairs$delta_close, copom_pairs$delta_settlement),
  gap_on_settlement_surprise = coef(gap_fit)[[2]],
  gap_on_settlement_surprise_se = gap_se,
  gap_on_settlement_surprise_p = 2 * pnorm(-abs(coef(gap_fit)[[2]] / gap_se)),
  median_abs_gap_copom = median(abs(copom_pairs$gap_wednesday)),
  median_abs_gap_other = median(abs(di_pairs$gap_wednesday[!di_pairs$copom])),
  n_other = sum(!di_pairs$copom),
  largest_gap_copom = copom_pairs$gap_wednesday[which.max(abs(copom_pairs$gap_wednesday))],
  largest_gap_copom_thursday = copom_pairs$thursday[which.max(abs(copom_pairs$gap_wednesday))]
)
readr::write_csv(di_close_settlement, file.path(OUT_DIR, "di_close_settlement.csv"))

meetings <- meetings |>
  dplyr::left_join(
    dplyr::select(copom_pairs, thursday, di_gap_wednesday = gap_wednesday),
    by = "thursday"
  )

# CDS test (A): calendar -------------------------------------------------------

# US-only: NYSE closed, London open (Memorial Day is left out, since it
# usually falls on the UK spring bank holiday). UK-only: London closed, NYSE
# open (Easter Monday left out). Both: 1 January and 25 December on a weekday.
holidays <- tibble::tibble(date = sample_days) |>
  dplyr::mutate(
    year = lubridate::year(date),
    month = lubridate::month(date),
    day = lubridate::mday(date),
    weekday = lubridate::wday(date, week_start = 1),
    nth = ceiling(day / 7),
    last_of_month = day + 7 > lubridate::days_in_month(date),
    group = dplyr::case_when(
      weekday > 5 ~ NA_character_,
      (month == 1 & day == 1) | (month == 12 & day == 25) ~ "fechados_eua_e_reino_unido",
      month %in% 1:2 & weekday == 1 & nth == 3 ~ "so_eua",
      month == 6 & year >= 2022 & ((day == 19) | (day == 20 & weekday == 1)) ~ "so_eua",
      month == 7 & ((day == 4) | (day == 3 & weekday == 5) | (day == 5 & weekday == 1)) ~ "so_eua",
      month == 9 & weekday == 1 & nth == 1 ~ "so_eua",
      month == 11 & weekday == 4 & nth == 4 ~ "so_eua",
      month == 5 & weekday == 1 & nth == 1 & year != 2020 ~ "so_reino_unido",
      date == as.Date("2020-05-08") ~ "so_reino_unido",
      month == 8 & weekday == 1 & last_of_month ~ "so_reino_unido",
      month == 12 & day == 26 & weekday %in% 2:5 ~ "so_reino_unido"
    )
  ) |>
  dplyr::filter(!is.na(group))

cds_calendar <- holidays |>
  dplyr::summarise(
    n_days = dplyr::n(),
    n_with_cds = sum(date %in% cds$date),
    share_with_cds = n_with_cds / n_days,
    .by = group
  )
readr::write_csv(cds_calendar, file.path(OUT_DIR, "cds_calendar.csv"))

# CDS test (B): daily alignment ------------------------------------------------

# Changes in each series' own calendar, before any join
cds_changes <- cds |>
  dplyr::arrange(date) |>
  dplyr::transmute(date, d_cds = cds - dplyr::lag(cds))
ibov_changes <- ibov |>
  dplyr::arrange(date) |>
  dplyr::transmute(date, d_ibov = 100 * log(ibov / dplyr::lag(ibov))) |>
  dplyr::mutate(d_ibov_lag = dplyr::lag(d_ibov), d_ibov_lead = dplyr::lead(d_ibov))
ptax_changes <- ptax |>
  dplyr::arrange(date) |>
  dplyr::transmute(date, d_ptax = 100 * log(ptax / dplyr::lag(ptax))) |>
  dplyr::mutate(d_ptax_lag = dplyr::lag(d_ptax), d_ptax_lead = dplyr::lead(d_ptax))
sp500_changes <- external |>
  dplyr::filter(!is.na(sp500)) |>
  dplyr::arrange(date) |>
  dplyr::transmute(date, d_sp500 = 100 * log(sp500 / dplyr::lag(sp500))) |>
  dplyr::mutate(d_sp500_lag = dplyr::lag(d_sp500), d_sp500_lead = dplyr::lead(d_sp500))

cds_alignment <- cds_changes |>
  dplyr::inner_join(ibov_changes, by = "date") |>
  dplyr::inner_join(ptax_changes, by = "date") |>
  dplyr::inner_join(sp500_changes, by = "date") |>
  dplyr::filter(date >= SAMPLE_START, date <= SAMPLE_END) |>
  tidyr::drop_na() |>
  dplyr::mutate(
    us_dst = lubridate::dst(lubridate::ymd_hm(paste(date, "12:00"), tz = TZ_NEW_YORK))
  ) |>
  dplyr::summarise(
    n_days = dplyr::n(),
    cor_ibov_lag = cor(d_cds, d_ibov_lag),
    cor_ibov = cor(d_cds, d_ibov),
    cor_ibov_lead = cor(d_cds, d_ibov_lead),
    cor_ptax_lag = cor(d_cds, d_ptax_lag),
    cor_ptax = cor(d_cds, d_ptax),
    cor_ptax_lead = cor(d_cds, d_ptax_lead),
    cor_sp500_lag = cor(d_cds, d_sp500_lag),
    cor_sp500 = cor(d_cds, d_sp500),
    cor_sp500_lead = cor(d_cds, d_sp500_lead),
    .by = us_dst
  ) |>
  dplyr::arrange(us_dst) |>
  dplyr::mutate(
    new_york = abs(cor_ibov_lag) < 0.1 &
      abs(cor_ibov) > pmax(abs(cor_ibov_lag), abs(cor_ibov_lead)) &
      abs(cor_ptax_lead) >= 0.1,
    london = abs(cor_ibov_lag) >= abs(cor_ibov) & abs(cor_ptax_lead) < 0.1,
    verdict = dplyr::case_when(
      all(new_york) ~ "Nova York",
      all(london) ~ "Londres",
      .default = "inconclusivo"
    )
  )
readr::write_csv(cds_alignment, file.path(OUT_DIR, "cds_alignment.csv"))

# CDS test (C): event windows, descriptive -------------------------------------

ny17 <- dplyr::filter(cds_windows, hypothesis == "ny17")
event_cds <- meetings |>
  dplyr::filter(in_events) |>
  dplyr::select(meeting, wednesday, thursday, delta_di, e_di_bs) |>
  dplyr::left_join(
    dplyr::select(ny17, meeting, wednesday_close_after_ny17 = wednesday_close_after),
    by = "meeting"
  ) |>
  dplyr::mutate(
    before_wednesday = cds$date[findInterval(as.numeric(wednesday) - 1, as.numeric(cds$date))]
  ) |>
  dplyr::left_join(dplyr::rename(cds, cds_before = cds), by = c("before_wednesday" = "date")) |>
  dplyr::left_join(dplyr::rename(cds, cds_wed = cds), by = c("wednesday" = "date")) |>
  dplyr::left_join(dplyr::rename(cds, cds_thu = cds), by = c("thursday" = "date")) |>
  dplyr::mutate(
    anterior_quarta = cds_wed - cds_before,
    quarta_quinta = cds_thu - cds_wed,
    anterior_quinta = cds_thu - cds_before
  )
stopifnot(nrow(event_cds) == N_EVENTS, !anyNA(event_cds$anterior_quinta))

surprise_columns <- c(bruta = "delta_di", ortogonalizada = "e_di_bs")
cds_event <- tidyr::expand_grid(
  window = c("anterior_quarta", "quarta_quinta", "anterior_quinta"),
  surprise = names(surprise_columns),
  group = c("todas", "quarta_antes_ny17", "quarta_depois_ny17")
) |>
  dplyr::mutate(
    fit = purrr::pmap(list(window, surprise, group), \(window, surprise, group) {
      sample <- switch(
        group,
        todas = event_cds,
        quarta_antes_ny17 = dplyr::filter(event_cds, !wednesday_close_after_ny17),
        quarta_depois_ny17 = dplyr::filter(event_cds, wednesday_close_after_ny17)
      )
      fit <- lm(sample[[window]] ~ sample[[surprise_columns[[surprise]]]])
      se <- sqrt(sandwich::vcovHC(fit, type = "HC1")[2, 2])
      tibble::tibble(
        n = nrow(sample),
        coef = SHOCK_BPS * coef(fit)[[2]],
        se = SHOCK_BPS * se,
        p_value = 2 * pnorm(-abs(coef(fit)[[2]] / se))
      )
    })
  ) |>
  tidyr::unnest(fit)
readr::write_csv(cds_event, file.path(OUT_DIR, "cds_event.csv"))

# Meetings table ---------------------------------------------------------------

meetings |>
  dplyr::left_join(
    tidyr::pivot_wider(
      cds_windows,
      names_from = hypothesis,
      values_from = c(cds_close_brasilia, wednesday_close_after, cds_pre, cds_post, d_cds)
    ),
    by = "meeting"
  ) |>
  dplyr::left_join(
    dplyr::select(daily_event, thursday, d_cds_used = d_cds),
    by = "thursday"
  ) |>
  dplyr::mutate(announcement = format(announcement, "%H:%M")) |>
  readr::write_csv(file.path(OUT_DIR, "meetings.csv"))
