# ============================================================
# External instrument for proxy-SVAR: Copom-day DI surprises.
# Produces four monthly variants: z_bruto, z_bruto_purif,
# z_JK, z_JK_purif (Jarociński-Karadi sign filter;
# Bauer-Swanson-style purification vs. global factors).
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
DEFAULT_VARIANT <- "z_bruto_purif"       # legacy data/processed/instrument.csv
# Supported variants: z_bruto, z_bruto_purif, z_jk, z_jk_purif (built here)
# and z_het, z_het_jk (heteroskedasticity-identified, built by
# script/instrument_het.R). When DEFAULT_VARIANT in {"z_het","z_het_jk"},
# run script/instrument_het.R FIRST so that instrumentos_mensais.csv carries
# the corresponding column before this script runs. The audit
# (output/instrument_audit_report.md) recommends z_het_jk paired with the
# yield_6m equation in the monthly DFM.

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

thu_panel <- tibble(date = all_thursdays) |>
  left_join(di_surprises, by = "date") |>
  left_join(ibov_d,       by = "date") |>
  left_join(ext_d,        by = "date") |>
  mutate(
    copom_day     = (date - 1) %in% copom_wed,
    fomc_coincide = copom_day & ((date - 1) %in% fomc_dates | date %in% fomc_dates)
  )

valid <- thu_panel |>
  filter(!is.na(delta_di), !is.na(r_ibov),
         !is.na(r_sp500),  !is.na(d_vix), !is.na(r_brent))

message(sprintf("Thursday panel: %d rows total, %d valid after NA filter, %d Copom days",
                nrow(thu_panel), nrow(valid), sum(valid$copom_day)))

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

instrumentos <- monthly_grid |>
  left_join(z_bruto       |> rename(z_bruto       = shock), by = "month") |>
  left_join(z_bruto_purif |> rename(z_bruto_purif = shock), by = "month") |>
  left_join(z_jk          |> rename(z_jk          = shock), by = "month") |>
  left_join(z_jk_purif    |> rename(z_jk_purif    = shock), by = "month") |>
  mutate(across(starts_with("z_"), ~ replace_na(.x, 0)))

# ---- Write outputs -----------------------------------------

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

# Pull het variants from the single-CSV outputs of script/instrument_het.R
# BEFORE writing instrumentos_mensais.csv, so the combined file carries all
# variants side-by-side regardless of which script ran last.
for (v in c("z_het", "z_het_jk")) {
  het_path <- sprintf("data/processed/instrument_%s.csv", v)
  if (file.exists(het_path)) {
    df <- read_csv(het_path, show_col_types = FALSE) |>
      transmute(month = as.Date(month), !!v := shock)
    instrumentos <- instrumentos |>
      left_join(df, by = "month") |>
      mutate(!!v := replace_na(.data[[v]], 0))
  }
}

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

# Legacy file consumed by model_alessi.R / model_var.R
het_variants <- c("z_het", "z_het_jk")
if (DEFAULT_VARIANT %in% het_variants && !DEFAULT_VARIANT %in% names(instrumentos)) {
  stop(sprintf("DEFAULT_VARIANT = '%s' but the column is not available. Run script/instrument_het.R first.",
               DEFAULT_VARIANT))
}
write_variant(DEFAULT_VARIANT, "data/processed/instrument.csv")

# Daily diagnostics panel (for scatterplot & variance F-test)
valid |>
  select(date, delta_di, r_ibov, e_di, e_ibov,
         copom_day, fomc_coincide, jk_monetary) |>
  write_csv("data/processed/copom_event_diagnostics.csv")

message(sprintf("Wrote 4 variants + combined CSV. Legacy instrument.csv = '%s'.",
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
cat(sprintf("  Monthly obs:         %d\n", nrow(instrumentos)))
for (v in c("z_bruto","z_bruto_purif","z_jk","z_jk_purif")) {
  x <- instrumentos[[v]]
  cat(sprintf("  %-14s nonzero=%3d  sd=%7.3f  range=[%7.3f, %7.3f]\n",
              v, sum(x != 0), sd(x), min(x), max(x)))
}
cat("=====================================================\n\n")
