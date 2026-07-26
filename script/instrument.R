# ============================================================
# External instrument for proxy-SVAR: Copom-day DI surprises.
# Produces ten monthly variants:
#  - z_bruto, z_bruto_purif, z_jk, z_jk_purif (contemporaneous
#    same-window purification vs. global factors; JK sign filter
#    on residual signs);
#  - z_jk_raw_purif / z_jk_raw_purif_local (JK mask on RAW signs
#    first, purification after; the _local variant re-estimates
#    the purification regression on the selected Copom days only);
#  - z_jk_raw (2026-07-14 audit): literal JK poor-man's proxy —
#    raw-sign mask AND raw delta_di values, no purification;
#  - z_bs_purif / z_jk_bs_purif (2026-07-14 audit): BS-faithful
#    purification — regression on PRE-event predictors only
#    (13-week financial trends + 4-week Focus revisions + trend),
#    per Bauer-Swanson (2023) eq. 7 / Table 3;
#  - z_jk_purif_us (2026-07-14 audit): contemporaneous
#    purification with the Wed->Thu UST 2y change added (FOMC
#    spillover control on coincident weeks).
# Requires: Rscript R/data_download/focus_fred.R (focus_daily.csv
# and fred_dgs2.csv feed the three audit variants).
# ============================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(lubridate)
  library(tidyr)
  library(readr)
  library(purrr)
  library(tibble)
})

source("R/instrument/di_surprise.R")

# ---- Config ------------------------------------------------

SAMPLE_START <- as.Date("2013-01-01")
SAMPLE_END   <- as.Date("2025-12-31")
LOAD_START   <- as.Date("2012-06-01")   # earlier so Wed→Thu pairs at sample start work
TARGET_BD    <- 126                      # ~6 months in business days (best F in grid search)
DEFAULT_VARIANT <- "z_jk_bs_purif" # legacy data/processed/instrument.csv
# Supported variants: the 10 GK-family instruments built by this script.
# The 4 heteroskedasticity-identified variants (z_het*) were archived on
# 2026-07-26 together with script/instrument_het.R — see
# _instrucoes/historico_decisoes.md section 1.
#
# 2026-07-15 update: DEFAULT_VARIANT switched from z_jk_purif to z_jk_bs_purif.
# Reason: the fidelity audit (working-note 2026-07-14_auditoria_fidelidade_jk_bs.md)
# showed the old default classifies JK on contemporaneous-purification residual
# signs, which mislabels 2020-03-19 (COVID panic) as monetary; z_jk_bs_purif
# uses the Bauer-Swanson-faithful pre-event orthogonalization (predetermined
# predictors only), so its JK mask is free of contemporaneous residuals.
# xi_mp at (6,5): 6.94 vs 5.20 full-sample, 12.49 vs 13.25 pre-covid; 6/14
# full cells >= 10 vs 0/14. See mosw_strength_grid.md and the audit note.

# ---- Load data ---------------------------------------------

di_panel <- load_di_panel("data/di.csv", from = LOAD_START, to = SAMPLE_END + 30)

ibov_daily <- read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ibov = as.numeric(ibov)) |>
  filter(!is.na(ibov))

ext_daily <- read_csv("data/investing/external_factors_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date),
            sp500 = as.numeric(sp500),
            vix   = as.numeric(vix),
            brent = as.numeric(brent))

brl_daily <- read_csv("data/processed/brl_usd_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), brl = as.numeric(brl)) |>
  filter(!is.na(brl))

focus_daily <- read_csv("data/processed/focus_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date),
            focus_ipca12m  = as.numeric(focus_ipca12m),
            focus_selic_ny = as.numeric(focus_selic_ny))

dgs2_daily <- read_csv("data/fred_dgs2.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ust2y = as.numeric(ust2y))

copom_wed <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)

fomc_path <- "data/fomc_dates.csv"
fomc_dates <- if (file.exists(fomc_path)) {
  read_csv(fomc_path, show_col_types = FALSE) |>
    transmute(date = as.Date(date)) |> pull(date)
} else {
  as.Date(character(0))
}

# ---- Build Thursday panel ----------------------------------

all_thursdays <- seq(SAMPLE_START, SAMPLE_END, by = "day")
all_thursdays <- all_thursdays[wday(all_thursdays) == 5]   # Thu = 5

di_surprises <- build_thursday_surprises(di_panel, all_thursdays,
                                         target_bd = TARGET_BD, min_bd = 10)

log_ret_100 <- function(x) 100 * (log(x) - log(dplyr::lag(x)))

ibov_d <- ibov_daily |>
  arrange(date) |>
  mutate(r_ibov = log_ret_100(ibov)) |>
  select(date, r_ibov)

ext_d <- ext_daily |>
  arrange(date) |>
  mutate(
    r_sp500 = log_ret_100(sp500),
    d_vix   = vix - dplyr::lag(vix),
    r_brent = log_ret_100(brent)
  ) |>
  select(date, r_sp500, d_vix, r_brent)

# For each Thursday we want the SAME-session change: Thu close vs. Wed close.
# For Ibov/external factors, daily log-return uses the immediately-prior available
# trading day, which in normal weeks is Wed. If Wed is a holiday for that market,
# the row stays (using previous available close) and the downstream Wed→Thu DI
# would be NA via the contract matcher, so the whole Thursday gets dropped together.

# Contemporaneous UST 2y change (bps) on the Treasury trading calendar; a
# US-holiday Thursday has no session, so the same-window US-rate news is 0.
ust2_d <- dgs2_daily |>
  arrange(date) |>
  mutate(d_ust2 = 100 * (ust2y - dplyr::lag(ust2y))) |>
  select(date, d_ust2)

# ---- Pre-event predictors (Bauer-Swanson eq. 7 analogue) ----
# Financial trends over the 13 weeks (65 trading days) ending at the Wednesday
# close, i.e. strictly predetermined at the announcement; Focus median revisions
# over ~4 weeks (20 survey days), the analogue of the Blue Chip revision cadence.

PRE_BD_FIN   <- 65
PRE_BD_FOCUS <- 20

trail_change <- function(df, col, k, log_scale = TRUE) {
  x <- df[[col]]
  v <- if (log_scale) 100 * (log(x) - log(dplyr::lag(x, k))) else x - dplyr::lag(x, k)
  tibble(date = df$date, val = v)
}

# last available value of a daily series at date <= cutoff
align_pre_event <- function(cutoffs, daily) {
  idx <- findInterval(as.numeric(cutoffs), as.numeric(daily$date))
  ifelse(idx >= 1, daily$val[idx], NA_real_)
}

di_slope_daily <- di_panel |>
  group_by(date) |>
  summarise(
    slope = 100 * (close_rate[which.min(abs(bdays - 504))] -
                   close_rate[which.min(abs(bdays - 63))]),
    .groups = "drop"
  ) |>
  arrange(date)

pre_cutoff <- all_thursdays - 1   # Wednesday: last close before the announcement

# per-series non-NA calendars (Yahoo series have scattered missing closes)
drop_na_series <- function(df, col) df[!is.na(df[[col]]), c("date", col)]

pre_event <- tibble(
  date            = all_thursdays,
  pre_ibov        = align_pre_event(pre_cutoff, trail_change(ibov_daily, "ibov", PRE_BD_FIN)),
  pre_sp500       = align_pre_event(pre_cutoff, trail_change(drop_na_series(ext_daily, "sp500"), "sp500", PRE_BD_FIN)),
  pre_vix         = align_pre_event(pre_cutoff, trail_change(drop_na_series(ext_daily, "vix"), "vix", PRE_BD_FIN, log_scale = FALSE)),
  pre_brent       = align_pre_event(pre_cutoff, trail_change(drop_na_series(ext_daily, "brent"), "brent", PRE_BD_FIN)),
  pre_brl         = align_pre_event(pre_cutoff, trail_change(brl_daily, "brl", PRE_BD_FIN)),
  pre_slope       = align_pre_event(pre_cutoff, trail_change(di_slope_daily, "slope", PRE_BD_FIN, log_scale = FALSE)),
  pre_focus_ipca  = align_pre_event(pre_cutoff, trail_change(focus_daily, "focus_ipca12m", PRE_BD_FOCUS, log_scale = FALSE)),
  pre_focus_selic = align_pre_event(pre_cutoff, trail_change(focus_daily, "focus_selic_ny", PRE_BD_FOCUS, log_scale = FALSE))
)

thu_panel <- tibble(date = all_thursdays) |>
  left_join(di_surprises, by = "date") |>
  left_join(ibov_d,       by = "date") |>
  left_join(ext_d,        by = "date") |>
  left_join(ust2_d,       by = "date") |>
  left_join(pre_event,    by = "date") |>
  mutate(
    d_ust2        = replace_na(d_ust2, 0),   # US-holiday Thursday: no session
    copom_day     = (date - 1) %in% copom_wed,
    fomc_coincide = copom_day & ((date - 1) %in% fomc_dates | date %in% fomc_dates),
    trend         = as.numeric(date - min(date)) / 365.25
  )

valid <- thu_panel |>
  filter(!is.na(delta_di), !is.na(r_ibov),
         !is.na(r_sp500),  !is.na(d_vix), !is.na(r_brent))

message(sprintf("Thursday panel: %d rows total, %d valid after NA filter, %d Copom days",
                nrow(thu_panel), nrow(valid), sum(valid$copom_day)))

# Pre-event predictors must be complete on the valid panel so the audit
# variants share exactly the same rows as the legacy ones.
pre_cols <- c("pre_ibov", "pre_sp500", "pre_vix", "pre_brent", "pre_brl",
              "pre_slope", "pre_focus_ipca", "pre_focus_selic")
n_na_pre <- colSums(is.na(valid[pre_cols]))
if (any(n_na_pre > 0)) {
  stop("NA in pre-event predictors on the valid panel: ",
       paste(sprintf("%s=%d", names(n_na_pre[n_na_pre > 0]), n_na_pre[n_na_pre > 0]),
             collapse = ", "),
       ". Check daily input coverage / run R/data_download/focus_fred.R.")
}

# ---- Purification regressions (full panel) -----------------

lm_di   <- lm(delta_di ~ r_sp500 + d_vix + r_brent, data = valid)
lm_ibov <- lm(r_ibov   ~ r_sp500 + d_vix + r_brent, data = valid)

valid$e_di   <- residuals(lm_di)
valid$e_ibov <- residuals(lm_ibov)

# ---- JK sign classification (on residuals) -----------------
# Monetary shock: residual DI and residual Ibov move in opposite directions.
# Information shock: same direction -> zero out.

valid <- valid |>
  mutate(
    jk_monetary = copom_day &
                  sign(e_di) != 0 & sign(e_ibov) != 0 &
                  sign(e_di) != sign(e_ibov)
  )

# Reversed ordering (JK filter -> purification): mask decided on RAW
# co-movement, before any global-factor cleanup.

valid <- valid |>
  mutate(
    jk_monetary_raw = copom_day &
                      sign(delta_di) != 0 & sign(r_ibov) != 0 &
                      sign(delta_di) != sign(r_ibov)
  )

# Local purification for the literal "JK -> purify" ordering: regression
# re-estimated on the raw-mask-selected Copom days only (~50 obs).
sel_raw <- valid$jk_monetary_raw
lm_di_local <- lm(delta_di ~ r_sp500 + d_vix + r_brent, data = valid[sel_raw, ])
valid$e_di_local <- 0
valid$e_di_local[sel_raw] <- residuals(lm_di_local)

# ---- BS-faithful pre-event purification (audit 2026-07-14) --
# Bauer-Swanson (2023) eq. 7: regress the surprise on PREDETERMINED news only
# (financial trends + survey revisions + trend), keep the residual. Unlike the
# contemporaneous regression above, nothing on the RHS can absorb the shock.

bs_formula <- ~ trend + pre_ibov + pre_sp500 + pre_vix + pre_brent + pre_brl +
                pre_slope + pre_focus_ipca + pre_focus_selic
lm_di_bs   <- lm(update(bs_formula, delta_di ~ .), data = valid)
lm_ibov_bs <- lm(update(bs_formula, r_ibov ~ .),   data = valid)

valid$e_di_bs   <- residuals(lm_di_bs)
valid$e_ibov_bs <- residuals(lm_ibov_bs)

message(sprintf("BS pre-event regression R2: delta_di %.3f | r_ibov %.3f (BS Table 3 range: 0.12-0.20)",
                summary(lm_di_bs)$r.squared, summary(lm_ibov_bs)$r.squared))

valid <- valid |>
  mutate(
    jk_monetary_bs = copom_day &
                     sign(e_di_bs) != 0 & sign(e_ibov_bs) != 0 &
                     sign(e_di_bs) != sign(e_ibov_bs)
  )

# ---- Contemporaneous purification + UST 2y control ----------
# Same-window global cleanup with the Wed->Thu 2y Treasury change added,
# covering Fed spillovers on the ~32 FOMC-coincident Copom weeks.

lm_di_us   <- lm(delta_di ~ r_sp500 + d_vix + r_brent + d_ust2, data = valid)
lm_ibov_us <- lm(r_ibov   ~ r_sp500 + d_vix + r_brent + d_ust2, data = valid)

valid$e_di_us   <- residuals(lm_di_us)
valid$e_ibov_us <- residuals(lm_ibov_us)

valid <- valid |>
  mutate(
    jk_monetary_us = copom_day &
                     sign(e_di_us) != 0 & sign(e_ibov_us) != 0 &
                     sign(e_di_us) != sign(e_ibov_us)
  )

# ---- Monthly aggregation -----------------------------------

valid <- valid |> mutate(month = floor_date(date, "month"))

monthly_grid <- tibble(month = seq(floor_date(SAMPLE_START, "month"),
                                   floor_date(SAMPLE_END,   "month"), by = "month"))

agg_monthly <- function(df, value_col, keep_mask) {
  df |>
    mutate(val = ifelse(keep_mask, .data[[value_col]], 0)) |>
    group_by(month) |>
    summarise(shock = sum(val[copom_day], na.rm = TRUE), .groups = "drop")
}

z_bruto        <- agg_monthly(valid, "delta_di", rep(TRUE, nrow(valid)))
z_bruto_purif  <- agg_monthly(valid, "e_di",    rep(TRUE, nrow(valid)))
z_jk           <- agg_monthly(valid, "delta_di", valid$jk_monetary)
z_jk_purif     <- agg_monthly(valid, "e_di",    valid$jk_monetary)
z_jk_raw_purif       <- agg_monthly(valid, "e_di",       valid$jk_monetary_raw)
z_jk_raw_purif_local <- agg_monthly(valid, "e_di_local", valid$jk_monetary_raw)
z_jk_raw       <- agg_monthly(valid, "delta_di", valid$jk_monetary_raw)
z_bs_purif     <- agg_monthly(valid, "e_di_bs", rep(TRUE, nrow(valid)))
z_jk_bs_purif  <- agg_monthly(valid, "e_di_bs", valid$jk_monetary_bs)
z_jk_purif_us  <- agg_monthly(valid, "e_di_us", valid$jk_monetary_us)

instrumentos <- monthly_grid |>
  left_join(z_bruto       |> rename(z_bruto       = shock), by = "month") |>
  left_join(z_bruto_purif |> rename(z_bruto_purif = shock), by = "month") |>
  left_join(z_jk          |> rename(z_jk          = shock), by = "month") |>
  left_join(z_jk_purif    |> rename(z_jk_purif    = shock), by = "month") |>
  left_join(z_jk_raw_purif       |> rename(z_jk_raw_purif       = shock), by = "month") |>
  left_join(z_jk_raw_purif_local |> rename(z_jk_raw_purif_local = shock), by = "month") |>
  left_join(z_jk_raw      |> rename(z_jk_raw      = shock), by = "month") |>
  left_join(z_bs_purif    |> rename(z_bs_purif    = shock), by = "month") |>
  left_join(z_jk_bs_purif |> rename(z_jk_bs_purif = shock), by = "month") |>
  left_join(z_jk_purif_us |> rename(z_jk_purif_us = shock), by = "month") |>
  mutate(across(starts_with("z_"), ~ replace_na(.x, 0)))

# ---- Write outputs -----------------------------------------

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

write_csv(instrumentos, "data/processed/instrumentos_mensais.csv")

write_variant <- function(colname, filename) {
  instrumentos |>
    transmute(month, shock = .data[[colname]]) |>
    write_csv(filename)
}
write_variant("z_bruto",       "data/processed/instrument_bruto.csv")
write_variant("z_bruto_purif", "data/processed/instrument_bruto_purif.csv")
write_variant("z_jk",          "data/processed/instrument_jk.csv")
write_variant("z_jk_purif",    "data/processed/instrument_jk_purif.csv")
write_variant("z_jk_raw_purif",       "data/processed/instrument_jk_raw_purif.csv")
write_variant("z_jk_raw_purif_local", "data/processed/instrument_jk_raw_purif_local.csv")
write_variant("z_jk_raw",      "data/processed/instrument_jk_raw.csv")
write_variant("z_bs_purif",    "data/processed/instrument_bs_purif.csv")
write_variant("z_jk_bs_purif", "data/processed/instrument_jk_bs_purif.csv")
write_variant("z_jk_purif_us", "data/processed/instrument_jk_purif_us.csv")

# Legacy file consumed by model_alessi.R / model_var.R
write_variant(DEFAULT_VARIANT, "data/processed/instrument.csv")

# Daily diagnostics panel (for scatterplot & variance F-test)
valid |>
  select(date, delta_di, r_ibov, e_di, e_ibov, e_di_local,
         e_di_bs, e_ibov_bs, e_di_us, e_ibov_us,
         copom_day, fomc_coincide, jk_monetary, jk_monetary_raw,
         jk_monetary_bs, jk_monetary_us) |>
  write_csv("data/processed/copom_event_diagnostics.csv")

message(sprintf("Wrote 10 variants + combined CSV. Legacy instrument.csv = '%s'.",
                DEFAULT_VARIANT))

# ---- Console summary ---------------------------------------

copom_days <- valid |> filter(copom_day)
wrong_signed <- copom_days |>
  summarise(
    n = n(),
    wrong_signed = sum(sign(e_di) == sign(e_ibov) &
                       sign(e_di) != 0 & sign(e_ibov) != 0),
    pct = round(100 * wrong_signed / n, 1)
  )

cat("\n========== INSTRUMENT CONSTRUCTION SUMMARY ==========\n")
cat(sprintf("  Sample:              %s to %s\n", SAMPLE_START, SAMPLE_END))
cat(sprintf("  Valid Thursdays:     %d\n", nrow(valid)))
cat(sprintf("  Copom event days:    %d (wrong-signed: %d / %.1f%%)\n",
            wrong_signed$n, wrong_signed$wrong_signed, wrong_signed$pct))
cat(sprintf("  JK mask (resid):     %d monetary | JK mask (raw): %d monetary | agree: %d\n",
            sum(copom_days$jk_monetary), sum(copom_days$jk_monetary_raw),
            sum(copom_days$jk_monetary & copom_days$jk_monetary_raw)))
cat(sprintf("  JK mask (BS-resid):  %d monetary | JK mask (US-resid): %d monetary\n",
            sum(copom_days$jk_monetary_bs), sum(copom_days$jk_monetary_us)))
cat(sprintf("  Monthly obs:         %d\n", nrow(instrumentos)))
for (v in c("z_bruto","z_bruto_purif","z_jk","z_jk_purif",
            "z_jk_raw_purif","z_jk_raw_purif_local",
            "z_jk_raw","z_bs_purif","z_jk_bs_purif","z_jk_purif_us")) {
  x <- instrumentos[[v]]
  cat(sprintf("  %-14s nonzero=%3d  sd=%7.3f  range=[%7.3f, %7.3f]\n",
              v, sum(x != 0), sd(x), min(x), max(x)))
}
cat("=====================================================\n\n")
