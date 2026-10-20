# ===================================================================
# Bridge from the daily event to the monthly DFM, the check that comes
# first (advisor's e-mail of 2026-10-12, item 2): what "Copom day" means
# for each quote. A quote before the announcement must come from a session
# that ends before the statement is out, and the first quote after it is
# that market's next session. For each of the 111 meetings of 2012-03 to
# 2025-12 this script dates the announcement, finds the last quote before
# it and the first after it in the DI, the Yahoo BRL=X rate and the CDS,
# compares them with the dates the instrument (R/instrument/build_variants.R)
# uses, and maps the meetings to the instrument's months. The Yahoo window
# written here is the one script/daily_event.R and script/het_conditions.R
# read. Nothing is re-estimated and the instrument is not touched.
#
# Announcement: the end of the second day's last session, from each
# minute (script/download_copom_minutes.R), or the earliest release time
# the BCB announced for the period, whichever is later.
# DI: CloseRate, the last trade of the session.
# Exchange rate: Yahoo BRL=X, the rate at the London midnight that opens
#   each bar, 20h to 22h in Brasilia (load_yahoo_brl()), by the convention
#   and, since 2026-10-15, in the wide window the advisor asked for on
#   2026-10-14: the row dated the day before the Wednesday to the first row
#   after it, by the rows' dates, which contains the announcement's start
#   under the inferred time. The PTAX, the average of the four 10h-13h
#   consultations (Circular 3.506), is the 13h clock of CDS test (B) and,
#   since 2026-10-15, a diagnostic window of its own, from Wednesday's to
#   the first one after it.
# CDS: Bloomberg PX_LAST of BRAZIL CDS USD SR 5Y D14 Corp. The pricing
#   source and the closing time are not in the file. Bloomberg's CBGN is a
#   New York close snapshot of its intraday composite (CBIN), and CMA's
#   end-of-day quotes on Bloomberg are taken at 17h New York; 17h and 18h
#   New York are carried as hypotheses, and three tests infer the close
#   from the data. Since 2026-10-17 the widened CDS window is the advisor's
#   reading (e-mail of 2026-10-17, item 1): the 17h window with one more
#   change on each side; nothing reads it yet.
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
#       both, on the surprise, over the events and split by whether
#       Wednesday's 17h New York close comes before or after the
#       announcement. It decides nothing.
#
# Classification rule of each quote, fixed before running it (advisor's
# e-mail of 2026-10-17, item 2; threshold chosen by the author the same day):
#   The announcement is an interval [start, end]. Where the BCB documents a
#   release time, start = end = that time. Where only the end of the
#   session is recorded in the minutes (every meeting before 2016-07-20),
#   start is that end; end is the first G1 story of the decision for the
#   174th, 186th and 196th meetings (ANNOUNCEMENT_CEILINGS), and otherwise
#   the end of the Wednesday, the date the BCB gives the statement
#   (dataReferencia of comunicados_detalhes).
#   A quote is "pre" if it comes before start minus CLASSIFY_MARGIN, "pos"
#   if it comes after end plus CLASSIFY_MARGIN, and "ambigua" otherwise,
#   and also when its time cannot be set against the announcement. The DI
#   quote is the session's last trade, whose time is at most the session's
#   end (DI_SESSION_END); where that end is not documented by B3 it is the
#   upper bound of a secondary source. Each end of each window is
#   classified (DI, PTAX, Yahoo by the convention and wide, CDS at 17h New
#   York and widened), and a meeting's window in a series is "ambigua" if
#   either end is. Every time is taken to Brasilia in its own date's zone.
#   The widened CDS window is the 17h New York one with one more change on
#   each side, on the CDS's own calendar (Tuesday to Friday, or Monday to
#   Thursday when the narrow one runs Tuesday to Wednesday); in an
#   ambiguous meeting it contains both possible narrow windows, and it is
#   the check. It does not replace the narrow window.
#
# script/download.R (brl_usd_daily.csv), script/download_yahoo_stamps.R,
# script/instrument.R, script/download_ptax.R and
# script/download_copom_minutes.R must run first;
# script/daily_event.R and script/het_conditions.R run after it.
# Outputs: output/copom_timing/
#   meetings.csv             one row per meeting: announcement, quote dates
#                            of each series by the convention and as used,
#                            the Yahoo quote times and the month whose
#                            average each enters, instrument month,
#                            changes in the windows
#   months.csv               instrument months: meetings, events and z
#   cds_calendar.csv         test (A)
#   cds_alignment.csv        test (B)
#   cds_event.csv            test (C)
#   di_close_settlement.csv  Wednesday's DI close against its settlement
#   excluded_meetings.csv    the nine meetings with a Thursday holiday, all
#                            in the events, the 7 on the eve of a Brazilian
#                            holiday with the window to Friday, one row per
#                            meeting and window (DI, PTAX, Yahoo by the
#                            convention and wide, CDS at 17h New York and
#                            widened): the announcement interval, both ends'
#                            dates and times in Brasilia, the status of each
#                            time, the class of each end and of the window,
#                            length in days, quotes and hours, whether each
#                            market quotes on the holiday and, on a US
#                            holiday, whether that quote is a new one, the
#                            DI contract
#   excluded_meetings_advisor.csv  the same nine, the table for the
#                            advisor (e-mail of 2026-10-17, item 4), without
#                            the Yahoo window by the convention, in
#                            Portuguese, semicolon-separated
#   yahoo_rows.csv           the Yahoo rows each of the 111 meetings uses, by
#                            the convention and in the wide window: the row's
#                            date, the API's stamp in UTC and in London, and
#                            the quote's inferred time in Brasilia, kept apart
#                            (e-mail of 2026-10-18, item 1)
#   cds_round_quotes.csv     the CDS quotes of 2012-2025 that are whole
#                            numbers, as 205.0 on Thanksgiving 2013 (e-mail of
#                            2026-10-18, item 2)
# Notes: notas/2026-10-13_ponte_horarios_copom.md,
#   notas/2026-10-15_conferencia_reunioes_fora.md,
#   notas/2026-10-16_janela_ampliada_cds_bloomberg.md,
#   notas/2026-10-17_auditoria_janelas_copom.md,
#   notas/2026-10-18_conferencias_ponte.md
# ===================================================================

source("R/instrument/di_surprise.R")

COPOM_PATH       <- "data/raw/copom_historico.csv"
ATAS_PATH        <- "data/raw/copom_atas.csv"
DI_PATH          <- "data/raw/di.csv"
YAHOO_BRL_PATH   <- "data/raw/brl_usd_daily.csv"
YAHOO_STAMPS_PATH <- "data/raw/brl_usd_daily_stamps.csv"
PTAX_PATH        <- "data/raw/ptax_daily.csv"
CDS_PATH         <- "data/raw/CDS 5y.xlsx"
IBOV_PATH        <- "data/raw/ibov_daily.csv"
EXTERNAL_PATH    <- "data/raw/investing/external_factors_daily.csv"
YIELDS_PATH      <- "data/raw/yields/yields_dia.csv"
EVENTS_PATH      <- "data/processed/copom_event_diagnostics.csv"
INSTRUMENTS_PATH <- "data/processed/instrumentos_mensais.csv"
OUT_DIR          <- "output/copom_timing"
SAMPLE_START <- as.Date("2012-03-01")
SAMPLE_END   <- as.Date("2025-12-31")
N_MEETINGS   <- 111L
TARGET_BD    <- 126
MIN_BD       <- 10
SHOCK_BPS    <- 50
TZ_BRASILIA  <- "America/Sao_Paulo"
TZ_NEW_YORK  <- "America/New_York"
CDS_CLOSE_NY <- c(ny17 = "17:00", ny18 = "18:00")
PTAX_CLOCK   <- "13:00"
CLASSIFY_MARGIN <- lubridate::minutes(30)

# The last DI trade of the day comes at most at the session's end. B3's
# grid, archived from 2019-01-07 to 2022-01-24, closes DI1 at 18h00 with the
# extended session (16h50-18h00), and its US daylight-saving circulars leave
# DI1 unchanged (OC 094/2020-PRE); since 2022-12-12 DI1 trades continuously
# from 9h to 18h00 (B3 grid; InfoMoney, 23/11/2022). Before 2019 no B3 grid
# for DI1 was found: the BM&F segment traded until 18h15 at the latest
# (Exame, 19/10/2012; Jornal do Comercio, 14/10/2016), taken as the bound.
DI_SESSION_END <- tibble::tribble(
  ~from,        ~di_session_end, ~di_session_status,
  "2012-01-01", "18:15",         "limite superior: fim do segmento BM&F por fonte secundaria; grade do DI1 nao encontrada",
  "2019-01-01", "18:00",         "documentado: grade da B3 (sessao estendida 16h50-18h00)",
  "2022-12-12", "18:00",         "documentado: grade da B3 (negociacao continua 9h-18h)"
) |>
  dplyr::mutate(from = as.Date(from))

# The first G1 story of the decision, the end of the announcement interval
# of the three old meetings sent for the Bloomberg quote (e-mail of
# 2026-10-16)
ANNOUNCEMENT_CEILINGS <- tibble::tribble(
  ~meeting, ~announcement_ceiling,
  174L,     "20:06",
  186L,     "20:19",
  196L,     "20:25"
)

# The Thursday holiday of the nine meetings it falls on; the data must show
# Brazil's as a day without DI and the US's as a day without the S&P 500
HOLIDAYS <- tibble::tribble(
  ~holiday,     ~holiday_name,                 ~holiday_country,
  "2013-05-30", "Corpus Christi",              "Brasil",
  "2013-11-28", "Thanksgiving",                "EUA",
  "2015-06-04", "Corpus Christi",              "Brasil",
  "2015-11-26", "Thanksgiving",                "EUA",
  "2017-09-07", "Independencia",               "Brasil",
  "2019-06-20", "Corpus Christi",              "Brasil",
  "2022-06-16", "Corpus Christi",              "Brasil",
  "2023-11-02", "Finados",                     "Brasil",
  "2025-06-19", "Corpus Christi e Juneteenth", "Brasil e EUA"
) |>
  dplyr::mutate(holiday = as.Date(holiday))

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

yahoo <- load_yahoo_brl(YAHOO_BRL_PATH)
# The API's stamp of every bar. quantmod reads it in the exchange's zone and
# dates the row with as.Date() in UTC, so a London midnight under British
# summer time (23h UTC) takes the day before: every row of the file is the
# UTC date of a stamp at 00:00 in London, with the same close, and
# load_yahoo_brl() puts the quote at that instant. The API leaves the close
# of 11 bars empty, which quantmod drops.
yahoo_stamps <- readr::read_csv(YAHOO_STAMPS_PATH, show_col_types = FALSE) |>
  dplyr::filter(!is.na(close)) |>
  dplyr::mutate(
    stamp_utc = lubridate::as_datetime(timestamp, tz = "UTC"),
    date = lubridate::as_date(stamp_utc)
  )
yahoo_checked <- dplyr::inner_join(yahoo, yahoo_stamps, by = "date")
stopifnot(
  nrow(yahoo_checked) == nrow(yahoo),
  nrow(yahoo_stamps) == nrow(yahoo),
  yahoo_checked$close == yahoo_checked$brl,
  format(lubridate::with_tz(yahoo_checked$stamp_utc, "Europe/London"), "%H:%M") == "00:00",
  yahoo_checked$quote_time == yahoo_checked$stamp_utc
)
ptax <- readr::read_csv(PTAX_PATH, show_col_types = FALSE) |>
  dplyr::arrange(date)
cds <- readxl::read_excel(CDS_PATH, skip = 5) |>
  purrr::set_names(c("date", "cds")) |>
  dplyr::transmute(date = as.Date(date), cds = as.numeric(cds)) |>
  dplyr::filter(!is.na(date), !is.na(cds))
ibov <- readr::read_csv(IBOV_PATH, show_col_types = FALSE)
external <- readr::read_csv(EXTERNAL_PATH, show_col_types = FALSE)
instruments <- readr::read_csv(INSTRUMENTS_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))
events <- readr::read_csv(EVENTS_PATH, show_col_types = FALSE) |>
  dplyr::transmute(wednesday = as.Date(wednesday), event_date = as.Date(date), long_window, delta_di, e_di_bs)
stopifnot(nrow(events) == N_MEETINGS)

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
  dplyr::left_join(ANNOUNCEMENT_CEILINGS, by = "meeting") |>
  # Without a floor the statement follows the end of the session at an
  # interval nobody records: it ends at the first G1 story where one was
  # found, and otherwise with the Wednesday, the statement's date at the BCB
  dplyr::mutate(
    announcement_end = dplyr::case_when(
      release_floor != "00:00" ~ announcement,
      # case_when() parses the whole column; on 108 NA of 111 ymd_hm()
      # fails to guess the format, so the rows this branch never takes get a
      # placeholder time
      !is.na(announcement_ceiling) ~
        lubridate::ymd_hm(
          paste(wednesday, dplyr::coalesce(announcement_ceiling, "00:00")),
          tz = TZ_BRASILIA
        ),
      .default = lubridate::ymd_hm(paste(thursday, "00:00"), tz = TZ_BRASILIA)
    ),
    announcement_status = dplyr::case_when(
      release_floor != "00:00" ~ "documentado: termino da ata e horario minimo do BCB",
      !is.na(announcement_ceiling) ~ "intervalo: do termino da ata a primeira noticia do G1",
      .default = "intervalo: do termino da ata ao fim da quarta, data do comunicado no BCB"
    )
  ) |>
  dplyr::select(-from, -announcement_ceiling)

# Quote dates by the convention ---------------------------------------------

# DI: its session ends before the release (at 18h at the latest), so the
# last quote before is the Wednesday's and the first after is the next
# session. Yahoo: the last quote at or before the announcement and the first
# after it, by quote time; a quote at the minute the meeting ends precedes
# the statement. Wednesday's evening quote comes after the release in most
# meetings, and then the window runs from Tuesday's evening to Wednesday's.
yahoo_index <- findInterval(
  as.numeric(meetings$announcement),
  as.numeric(yahoo$quote_time)
)
meetings <- meetings |>
  dplyr::mutate(
    di_pre = di_sessions[findInterval(as.numeric(wednesday), as.numeric(di_sessions))],
    di_post = di_sessions[findInterval(as.numeric(wednesday), as.numeric(di_sessions)) + 1L],
    yahoo_pre = yahoo$date[yahoo_index],
    yahoo_post = yahoo$date[yahoo_index + 1L],
    yahoo_pre_brasilia = format(yahoo$quote_time[yahoo_index], "%Y-%m-%d %H:%M"),
    yahoo_post_brasilia = format(yahoo$quote_time[yahoo_index + 1L], "%Y-%m-%d %H:%M"),
    yahoo_wednesday_after = yahoo$quote_time[yahoo_index + 1L] <
      lubridate::ymd_hm(paste(thursday, "06:00"), tz = TZ_BRASILIA),
    d_fx = yahoo$brl[yahoo_index + 1L] - yahoo$brl[yahoo_index],
    d_fx_pct = 100 * log(yahoo$brl[yahoo_index + 1L] / yahoo$brl[yahoo_index]),
    # The panel's cambio_usd is the calendar-month average of the Yahoo rows
    # by their date (R/data_download/exchange.R)
    yahoo_pre_month = lubridate::floor_date(yahoo_pre, "month"),
    yahoo_post_month = lubridate::floor_date(yahoo_post, "month"),
    in_events = wednesday %in% events$wednesday,
    # The instrument's month is that of the event's DI session; the
    # convention's, that of the first DI session after the announcement
    month_instrument = lubridate::floor_date(
      events$event_date[match(wednesday, events$wednesday)],
      "month"
    ),
    month_convention = lubridate::floor_date(di_post, "month"),
    wednesday_last_session_of_month =
      lubridate::floor_date(di_post, "month") != lubridate::floor_date(wednesday, "month")
  )

stopifnot(
  all(meetings$in_events),
  meetings$di_pre == meetings$wednesday,
  meetings$di_post == events$event_date[match(meetings$wednesday, events$wednesday)],
  meetings$month_instrument == meetings$month_convention
)

# The advisor's wider windows (e-mail of 2026-10-14). PTAX: Wednesday's, set
# before the release, to the first one after it. Yahoo: the row dated the
# day before the Wednesday to the first row dated after it, by the rows'
# dates and not by the inferred time; each series keeps its own calendar, so
# the last row is Thursday's also when Thursday is a Brazilian holiday
ptax_index <- findInterval(as.numeric(meetings$wednesday), as.numeric(ptax$date))
yahoo_wide_pre_index <- findInterval(as.numeric(meetings$wednesday) - 1, as.numeric(yahoo$date))
yahoo_wide_post_index <- findInterval(as.numeric(meetings$wednesday), as.numeric(yahoo$date)) + 1L
meetings <- meetings |>
  dplyr::mutate(
    ptax_pre = ptax$date[ptax_index],
    ptax_post = ptax$date[ptax_index + 1L],
    d_ptax = ptax$ptax[ptax_index + 1L] - ptax$ptax[ptax_index],
    d_ptax_pct = 100 * log(ptax$ptax[ptax_index + 1L] / ptax$ptax[ptax_index]),
    yahoo_wide_pre = yahoo$date[yahoo_wide_pre_index],
    yahoo_wide_post = yahoo$date[yahoo_wide_post_index],
    yahoo_wide_pre_brasilia = format(yahoo$quote_time[yahoo_wide_pre_index], "%Y-%m-%d %H:%M"),
    yahoo_wide_post_brasilia = format(yahoo$quote_time[yahoo_wide_post_index], "%Y-%m-%d %H:%M"),
    d_fx_wide = yahoo$brl[yahoo_wide_post_index] - yahoo$brl[yahoo_wide_pre_index],
    d_fx_wide_pct = 100 * log(yahoo$brl[yahoo_wide_post_index] / yahoo$brl[yahoo_wide_pre_index])
  )

# Every Wednesday has a PTAX and every Tuesday and Thursday a Yahoo row, and
# by the inferred time the wide window contains every announcement
stopifnot(
  meetings$ptax_pre == meetings$wednesday,
  meetings$yahoo_wide_pre == meetings$wednesday - 1L,
  meetings$yahoo_wide_post == meetings$thursday,
  yahoo$quote_time[yahoo_wide_pre_index] < meetings$announcement,
  yahoo$quote_time[yahoo_wide_post_index] > meetings$announcement
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
    cds_before_wednesday,
    cds_pre,
    cds_post,
    d_cds = cds_post_quote - cds_pre_quote
  )

# The advisor's widened CDS window (e-mail of 2026-10-17, item 1): the 17h New
# York window with one more change on each side, on the CDS's own calendar.
# Under either closing hypothesis it contains the narrow window, so in a
# meeting where the order of close and announcement is ambiguous it holds both
# possible narrow windows.
cds_ny17 <- dplyr::filter(cds_windows, hypothesis == "ny17")
cds_widened_pre_index <- match(cds_ny17$cds_pre, cds$date) - 1L
cds_widened_post_index <- match(cds_ny17$cds_post, cds$date) + 1L
meetings <- meetings |>
  dplyr::mutate(
    cds_widened_pre = cds$date[cds_widened_pre_index],
    cds_widened_post = cds$date[cds_widened_post_index],
    d_cds_widened = cds$cds[cds_widened_post_index] - cds$cds[cds_widened_pre_index]
  )

cds_narrow_in_widened <- cds_windows |>
  dplyr::left_join(
    dplyr::select(meetings, meeting, cds_widened_pre, cds_widened_post),
    by = "meeting"
  )
stopifnot(
  cds_ny17$meeting == meetings$meeting,
  cds_widened_post_index - cds_widened_pre_index == 3L,
  cds_narrow_in_widened$cds_pre >= cds_narrow_in_widened$cds_widened_pre,
  cds_narrow_in_widened$cds_post <= cds_narrow_in_widened$cds_widened_post
)

# Changes by the convention ---------------------------------------------------

# From the Wednesday close to the first DI session after the announcement, as
# the instrument builds them: the Thursday, or the Friday in the seven longer
# windows
surprises_convention <- build_event_surprises(
  di,
  meetings$wednesday,
  meetings$di_post,
  target_bd = TARGET_BD,
  min_bd = MIN_BD
) |>
  dplyr::transmute(
    wednesday = meetings$wednesday,
    delta_di_convention = delta_di,
    di_contract = ticker,
    di_contract_bdays = bdays
  )

meetings <- meetings |>
  dplyr::left_join(surprises_convention, by = "wednesday") |>
  dplyr::left_join(dplyr::select(events, -event_date), by = "wednesday")

stopifnot(
  !anyNA(meetings$delta_di_convention),
  max(abs(meetings$delta_di_convention - meetings$delta_di)) < 1e-12
)

# Months ---------------------------------------------------------------------

# A meeting on the month's last session goes to the next month. The panel's
# yield_6m is the month's last quote of the advisor's curve; for those
# meetings it must be the Wednesday's, before the announcement
yields_last_quote <- readr::read_csv(YIELDS_PATH, show_col_types = FALSE) |>
  dplyr::transmute(
    date = lubridate::dmy(Data),
    month = lubridate::floor_date(date, "month")
  ) |>
  dplyr::summarise(yield_last_quote = max(date), .by = month)
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
      .by = month_convention
    ),
    by = c("month" = "month_convention")
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
# Thursday pair of the sample enters, the Copom ones flagged; the seven
# windows to Friday have no such pair.
thursday_events <- dplyr::filter(events, !long_window)
di_rates <-readr::read_csv(DI_PATH, show_col_types = FALSE) |>
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
    copom = thursday %in% thursday_events$event_date,
    delta_close = 10000 * (close_thu - close_wed),
    delta_settlement = 10000 * (settle_thu - settle_wed),
    gap_wednesday = 10000 * (close_wed - settle_wed)
  )
copom_pairs <- dplyr::filter(di_pairs, copom)
stopifnot(
  nrow(copom_pairs) == nrow(thursday_events),
  max(abs(copom_pairs$delta_close - thursday_events$delta_di[match(copom_pairs$thursday, thursday_events$event_date)])) < 1e-9
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

# Changes in each series' own calendar, before any join
cds_changes <- cds |>
  dplyr::arrange(date) |>
  dplyr::transmute(date, d_cds = cds - dplyr::lag(cds))

# Descriptive, outside the rule: a quote carried over a closed market would
# not move
cds_calendar <- holidays |>
  dplyr::left_join(cds_changes, by = "date") |>
  dplyr::bind_rows(
    cds_changes |>
      dplyr::filter(date >= SAMPLE_START, date <= SAMPLE_END) |>
      dplyr::mutate(group = "todos_os_dias_com_cds")
  ) |>
  dplyr::summarise(
    n_days = dplyr::n(),
    n_with_cds = sum(!is.na(d_cds)),
    share_with_cds = n_with_cds / n_days,
    n_zero_change = sum(d_cds == 0, na.rm = TRUE),
    median_abs_change = median(abs(d_cds), na.rm = TRUE),
    .by = group
  )
readr::write_csv(cds_calendar, file.path(OUT_DIR, "cds_calendar.csv"))

# CDS test (B): daily alignment ------------------------------------------------

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

event_cds <- meetings |>
  dplyr::select(meeting, wednesday, thursday, delta_di, e_di_bs) |>
  dplyr::left_join(
    dplyr::select(
      cds_ny17,
      meeting,
      cds_before_wednesday,
      wednesday_close_after_ny17 = wednesday_close_after
    ),
    by = "meeting"
  ) |>
  dplyr::left_join(dplyr::rename(cds, cds_before = cds), by = c("cds_before_wednesday" = "date")) |>
  dplyr::left_join(dplyr::rename(cds, cds_wed = cds), by = c("wednesday" = "date")) |>
  dplyr::left_join(dplyr::rename(cds, cds_thu = cds), by = c("thursday" = "date")) |>
  dplyr::mutate(
    anterior_quarta = cds_wed - cds_before,
    quarta_quinta = cds_thu - cds_wed,
    anterior_quinta = cds_thu - cds_before
  )
stopifnot(nrow(event_cds) == N_MEETINGS, !anyNA(event_cds$anterior_quinta))

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
        p_value = 2 * pnorm(-abs(coef(fit)[[2]] / se)),
        coef = SHOCK_BPS * coef(fit)[[2]],
        se = SHOCK_BPS * se
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
  dplyr::select(-cds_before_wednesday) |>
  # The CDS window script/daily_event.R uses on the events: Wednesday to
  # Thursday
  dplyr::mutate(
    d_cds_used = cds$cds[match(thursday, cds$date)] - cds$cds[match(wednesday, cds$date)],
    announcement = format(announcement, "%H:%M"),
    announcement_end = format(announcement_end, "%Y-%m-%d %H:%M")
  ) |>
  readr::write_csv(file.path(OUT_DIR, "meetings.csv"))

# The row's date, the stamp and the quote's time, kept apart (e-mail of
# 2026-10-18, item 1). The time in Brasilia is the stamp's instant, which is
# the hypothesis of load_yahoo_brl(): Yahoo documents no quote time
tidyr::expand_grid(
  dplyr::select(meetings, meeting, wednesday, yahoo_pre, yahoo_post, yahoo_wide_pre, yahoo_wide_post),
  window = c("convencao", "larga"),
  end = c("pre", "pos")
) |>
  dplyr::mutate(
    row_date = dplyr::case_when(
      window == "convencao" & end == "pre" ~ yahoo_pre,
      window == "convencao" & end == "pos" ~ yahoo_post,
      window == "larga" & end == "pre" ~ yahoo_wide_pre,
      window == "larga" & end == "pos" ~ yahoo_wide_post
    )
  ) |>
  dplyr::left_join(dplyr::select(yahoo_checked, date, timestamp, stamp_utc), by = c("row_date" = "date")) |>
  dplyr::transmute(
    meeting,
    wednesday,
    window,
    end,
    row_date,
    timestamp,
    stamp_london = format(lubridate::with_tz(stamp_utc, "Europe/London"), "%Y-%m-%d %H:%M %Z"),
    british_summer_time = lubridate::dst(lubridate::with_tz(stamp_utc, "Europe/London")),
    quote_time_brasilia = format(lubridate::with_tz(stamp_utc, TZ_BRASILIA), "%Y-%m-%d %H:%M"),
    quote_time_status = "hipotese: o instante do carimbo; o Yahoo nao documenta o horario da cotacao",
    stamp_utc = format(stamp_utc, "%Y-%m-%d %H:%M")
  ) |>
  dplyr::relocate(stamp_utc, .after = timestamp) |>
  readr::write_csv(file.path(OUT_DIR, "yahoo_rows.csv"))

# The CDS quotes of the sample that are whole numbers (e-mail of 2026-10-18,
# item 2), Thanksgiving 2013 (205.0) and the Monday after it (214.0) among them
cds |>
  dplyr::filter(date >= SAMPLE_START, date <= SAMPLE_END, cds == round(cds)) |>
  readr::write_csv(file.path(OUT_DIR, "cds_round_quotes.csv"))

# Each quote against the announcement, the 111 meetings --------------------

# One row per meeting and window, with the time of each end in Brasilia, in
# its own date's zone. DI: the last trade, at most at the session's end. PTAX:
# the last of its four consultations. Yahoo: the inferred London midnight of
# load_yahoo_brl(). CDS: the author's 17h New York.
cds_time <- \(day) {
  lubridate::ymd_hm(paste(day, CDS_CLOSE_NY[["ny17"]]), tz = TZ_NEW_YORK) |>
    lubridate::with_tz(TZ_BRASILIA)
}
di_session <- meetings |>
  dplyr::select(meeting, di_pre, di_post) |>
  dplyr::left_join(
    dplyr::rename(DI_SESSION_END, di_pre_end = di_session_end, di_status = di_session_status),
    by = dplyr::join_by(closest(di_pre >= from))
  ) |>
  dplyr::select(-from) |>
  dplyr::left_join(
    dplyr::select(DI_SESSION_END, from, di_post_end = di_session_end),
    by = dplyr::join_by(closest(di_post >= from))
  ) |>
  dplyr::select(-from)
meetings <- dplyr::left_join(meetings, di_session, by = c("meeting", "di_pre", "di_post"))

quote_windows <- dplyr::bind_rows(
  dplyr::transmute(
    meetings,
    meeting,
    series = "di",
    window = "convencao",
    pre = di_pre,
    post = di_post,
    pre_time = lubridate::ymd_hm(paste(di_pre, di_pre_end), tz = TZ_BRASILIA),
    post_time = lubridate::ymd_hm(paste(di_post, di_post_end), tz = TZ_BRASILIA),
    time_status = paste("ultimo negocio (CloseRate), no maximo ao fim do pregao;", di_status),
    change = delta_di_convention,
    change_unit = "p.b.",
    di_contract,
    di_contract_bdays
  ),
  dplyr::transmute(
    meetings,
    meeting,
    series = "ptax",
    window = "convencao",
    pre = ptax_pre,
    post = ptax_post,
    pre_time = lubridate::ymd_hm(paste(ptax_pre, PTAX_CLOCK), tz = TZ_BRASILIA),
    post_time = lubridate::ymd_hm(paste(ptax_post, PTAX_CLOCK), tz = TZ_BRASILIA),
    time_status = "documentado: media das consultas das 10h as 13h (Circular 3.506)",
    change = d_ptax,
    change_unit = "R$/US$",
    change_pct = d_ptax_pct
  ),
  dplyr::transmute(
    meetings,
    meeting,
    series = "yahoo",
    window = "convencao",
    pre = yahoo_pre,
    post = yahoo_post,
    pre_time = yahoo$quote_time[match(yahoo_pre, yahoo$date)],
    post_time = yahoo$quote_time[match(yahoo_post, yahoo$date)],
    change = d_fx,
    change_unit = "R$/US$",
    change_pct = d_fx_pct
  ),
  dplyr::transmute(
    meetings,
    meeting,
    series = "yahoo",
    window = "larga",
    pre = yahoo_wide_pre,
    post = yahoo_wide_post,
    pre_time = yahoo$quote_time[match(yahoo_wide_pre, yahoo$date)],
    post_time = yahoo$quote_time[match(yahoo_wide_post, yahoo$date)],
    change = d_fx_wide,
    change_unit = "R$/US$",
    change_pct = d_fx_wide_pct
  ),
  dplyr::left_join(meetings, dplyr::select(cds_ny17, meeting, cds_pre, cds_post, d_cds), by = "meeting") |>
    dplyr::transmute(
      meeting,
      series = "cds",
      window = "ny17",
      pre = cds_pre,
      post = cds_post,
      pre_time = cds_time(cds_pre),
      post_time = cds_time(cds_post),
      change = d_cds,
      change_unit = "p.b."
    ),
  dplyr::transmute(
    meetings,
    meeting,
    series = "cds",
    window = "ampliada",
    pre = cds_widened_pre,
    post = cds_widened_post,
    pre_time = cds_time(cds_widened_pre),
    post_time = cds_time(cds_widened_post),
    change = d_cds_widened,
    change_unit = "p.b."
  )
) |>
  dplyr::mutate(
    time_status = dplyr::case_when(
      series == "yahoo" ~ "hipotese: meia-noite de Londres, inferida dos dados; o Yahoo nao documenta o horario",
      series == "cds" ~ "hipotese: 17h de Nova York, decisao do autor; o arquivo da Bloomberg nao traz a fonte nem o horario",
      .default = time_status
    )
  ) |>
  dplyr::left_join(
    dplyr::select(meetings, meeting, wednesday, in_events, announcement, announcement_end, announcement_status),
    by = "meeting"
  )

# The rule of the header: pre before the interval's start minus the margin,
# pos after its end plus the margin, ambiguous otherwise
quote_classification <- quote_windows |>
  dplyr::mutate(
    pre_class = dplyr::case_when(
      pre_time < announcement - CLASSIFY_MARGIN ~ "pre",
      pre_time > announcement_end + CLASSIFY_MARGIN ~ "pos",
      .default = "ambigua"
    ),
    post_class = dplyr::case_when(
      post_time < announcement - CLASSIFY_MARGIN ~ "pre",
      post_time > announcement_end + CLASSIFY_MARGIN ~ "pos",
      .default = "ambigua"
    ),
    window_class = dplyr::case_when(
      pre_class == "ambigua" | post_class == "ambigua" ~ "ambigua",
      pre_class == "pre" & post_class == "pos" ~ "contem o anuncio",
      .default = "nao contem o anuncio"
    )
  )
stopifnot(
  nrow(quote_classification) == 6L * N_MEETINGS,
  !anyNA(quote_classification$pre_time),
  !anyNA(quote_classification$post_time)
)

# The advisor's own conversions of 17h New York (e-mail of 2026-10-17)
advisor_check <- quote_classification |>
  dplyr::filter(series == "cds", window == "ny17", meeting %in% c(179L, 195L, 209L, 223L))
wednesday_cds_time <- dplyr::if_else(
  advisor_check$pre == advisor_check$wednesday,
  advisor_check$pre_time,
  advisor_check$post_time
)
stopifnot(
  format(wednesday_cds_time, "%Y-%m-%d %H:%M") ==
    paste(advisor_check$wednesday, c("20:00", "20:00", "18:00", "18:00")),
  advisor_check$window_class == "ambigua"
)

# The nine meetings with a Thursday holiday -----------------------------------

sp500_days <- external$date[!is.na(external$sp500)]
affected <- meetings |>
  dplyr::inner_join(HOLIDAYS, by = c("thursday" = "holiday"), keep = TRUE) |>
  dplyr::mutate(
    sample_status = dplyr::if_else(
      long_window,
      "amostra principal, janela de quarta a sexta (sai na sensibilidade)",
      "amostra principal, janela de quarta a quinta"
    )
  )

# From Tuesday to Friday, the days with Brazil closed (no DI) or the US closed
# (no S&P 500) are exactly the Thursday holidays named above
closures <- tidyr::expand_grid(
  dplyr::select(affected, meeting, wednesday),
  offset = -1:2
) |>
  dplyr::mutate(
    day = wednesday + offset,
    brazil_closed = !day %in% di_sessions,
    us_closed = !day %in% sp500_days
  ) |>
  dplyr::filter(brazil_closed | us_closed) |>
  dplyr::mutate(
    country = dplyr::case_when(
      brazil_closed & us_closed ~ "Brasil e EUA",
      brazil_closed ~ "Brasil",
      us_closed ~ "EUA"
    )
  )
stopifnot(
  nrow(affected) == nrow(HOLIDAYS),
  affected$long_window == stringr::str_detect(affected$holiday_country, "Brasil"),
  nrow(closures) == nrow(affected),
  closures$day == affected$holiday,
  closures$country == affected$holiday_country
)

# A window's quotes are counted in its own market's calendar; whether a market
# quotes on the holiday is read in Brasilia, where a Yahoo row of the European
# winter carries the evening before its date. On a US holiday, a quote that
# repeats the one before it would be no observation of its own.
market_quotes <- list(di = di_sessions, ptax = ptax$date, yahoo = yahoo$date, cds = cds$date)
market_days <- list(
  di = di_sessions,
  ptax = ptax$date,
  yahoo = as.Date(yahoo$quote_time, tz = TZ_BRASILIA),
  cds = cds$date
)
series_quotes <- list(
  yahoo = dplyr::transmute(yahoo, date = as.Date(quote_time, tz = TZ_BRASILIA), value = brl),
  cds = dplyr::transmute(cds, date, value = cds)
)
us_holiday_quotes <- tidyr::expand_grid(
  affected |>
    dplyr::filter(stringr::str_detect(holiday_country, "EUA")) |>
    dplyr::select(meeting, holiday),
  series = names(series_quotes)
) |>
  dplyr::mutate(
    holiday_quote_new = purrr::map2_lgl(series, holiday, \(series, holiday) {
      quotes <- series_quotes[[series]]
      i <- match(holiday, quotes$date)
      quotes$value[i] != quotes$value[i - 1L]
    })
  ) |>
  dplyr::select(-holiday)

affected_table <- quote_classification |>
  dplyr::inner_join(
    dplyr::select(affected, meeting, sample_status, holiday, holiday_name, holiday_country),
    by = "meeting"
  ) |>
  dplyr::mutate(
    calendar_days = as.integer(post - pre),
    quotes = purrr::pmap_int(list(series, pre, post), \(series, pre, post) {
      sum(market_quotes[[series]] > pre & market_quotes[[series]] <= post)
    }),
    hours = as.numeric(difftime(post_time, pre_time, units = "hours")),
    quotes_on_holiday = purrr::map2_lgl(series, holiday, \(series, holiday) {
      holiday %in% market_days[[series]]
    }),
    dplyr::across(c(pre_time, post_time, announcement, announcement_end), \(x) format(x, "%Y-%m-%d %H:%M"))
  ) |>
  dplyr::left_join(us_holiday_quotes, by = c("meeting", "series")) |>
  dplyr::arrange(meeting) |>
  dplyr::select(
    meeting, wednesday, sample_status, holiday, holiday_name, holiday_country,
    announcement, announcement_end, announcement_status, series, window, pre,
    post, pre_time, post_time, time_status, pre_class, post_class,
    window_class, calendar_days, quotes, hours, change, change_unit,
    change_pct, quotes_on_holiday, holiday_quote_new, di_contract,
    di_contract_bdays
  )

# The CDS and the Yahoo quote on every US holiday with a quote of their own,
# so no Friday quote stands in for one (e-mail of 2026-10-17, item 3)
stopifnot(
  with(dplyr::filter(affected_table, !is.na(holiday_quote_new)), all(holiday_quote_new & quotes_on_holiday))
)
readr::write_csv(affected_table, file.path(OUT_DIR, "excluded_meetings.csv"))

# The table for the advisor (e-mail of 2026-10-17, item 4): the nine meetings,
# their window, the announcement interval and, per market and window, the
# times of both ends, whether each time is documented, and the class of each
# end. The author's wording of 2026-10-17: the e-mail, not the table, says
# that the Yahoo and CDS times are hypotheses. In Portuguese, for a Brazilian
# spreadsheet
email_markets <- tibble::tribble(
  ~series, ~window,     ~mercado, ~janela,
  "di",    "convencao", "DI",     "fechamento de quarta ao primeiro pregao seguinte",
  "ptax",  "convencao", "PTAX",   "a de quarta a primeira seguinte",
  "yahoo", "larga",    "Yahoo",  "linha de terca a linha de quinta",
  "cds",   "ny17",      "CDS",    "estreita, 17h de Nova York",
  "cds",   "ampliada",  "CDS",    "estreita com uma variacao a mais de cada lado"
)
affected_table |>
  dplyr::inner_join(email_markets, by = c("series", "window")) |>
  dplyr::transmute(
    reuniao = meeting,
    quarta = wednesday,
    amostra = stringr::str_remove(sample_status, "^amostra principal, "),
    feriado = holiday_name,
    anuncio_inicio = announcement,
    anuncio_fim = announcement_end,
    horario_anuncio = announcement_status,
    mercado,
    janela,
    horario_pre = pre_time,
    horario_pos = post_time,
    status_horario = dplyr::case_when(
      series == "di" & stringr::str_detect(time_status, "limite superior") ~
        "limite superior: fim do segmento BM&F",
      series == "di" ~ "documentado: grade da B3",
      series == "ptax" ~ "documentado: Circular 3.506",
      series == "yahoo" ~ "nao documentado pelo Yahoo",
      series == "cds" ~ "nao documentado pela Bloomberg"
    ),
    classificacao_pre = pre_class,
    classificacao_pos = post_class,
    classificacao = window_class,
    dias = calendar_days
  ) |>
  readr::write_excel_csv2(file.path(OUT_DIR, "excluded_meetings_advisor.csv"))
