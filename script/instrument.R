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
source("R/instrument/build_variants.R")

# ---- Config ------------------------------------------------

SAMPLE_START <- as.Date("2013-01-01")
SAMPLE_END   <- as.Date("2025-12-31")
LOAD_START   <- as.Date("2012-06-01")   # earlier so Wed→Thu pairs at sample start work
TARGET_BD    <- 126                      # ~6 months in business days
AGG_SCHEME   <- "sum"                    # Jarocinski-Karadi within-month sum
DEFAULT_VARIANT <- "z_jk_bs_purif" # legacy data/processed/instrument.csv
#
# 2026-07-27: both construction choices above were swept on the current
# vintage under xi_mp — see script/instrument_construction_sweep.R and
# output/instrument/instrument_construction_sweep.md. The old
# "# best F in grid search" comment on TARGET_BD referred to
# arquivo/output/instrument_grid.csv (2026-04-12), which used the legacy
# partial-F ruler, the pre-refresh vintage, and only the four legacy
# variants — it predates z_jk_bs_purif entirely.
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

# ---- Build ------------------------------------------------
# The chain lives in R/instrument/build_variants.R so the vertex and the
# aggregation scheme can be swept without duplicating it.

built <- build_instrument_variants(
  inputs = list(di_panel    = di_panel,
                ibov_daily  = ibov_daily,
                ext_daily   = ext_daily,
                brl_daily   = brl_daily,
                focus_daily = focus_daily,
                dgs2_daily  = dgs2_daily,
                copom_wed   = copom_wed,
                fomc_dates  = fomc_dates),
  target_bd    = TARGET_BD,
  agg          = AGG_SCHEME,
  sample_start = SAMPLE_START,
  sample_end   = SAMPLE_END
)

valid        <- built$daily
instrumentos <- built$monthly

message(sprintf("Thursday panel: %d rows total, %d valid after NA filter, %d Copom days",
                built$diag$n_thursdays, built$diag$n_valid, built$diag$n_copom))
message(sprintf("BS pre-event regression R2: delta_di %.3f | r_ibov %.3f (BS Table 3 range: 0.12-0.20)",
                built$diag$r2_di_bs, built$diag$r2_ibov_bs))

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
