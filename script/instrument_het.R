# ============================================================
# Heteroskedasticity-identified instrument (Rigobon-Sack 2003 QJE).
# Builds a daily SVAR over Wed-to-Thu pairs (regime C = Copom Wed,
# regime NC = other Wed), identifies the policy impact column from
# the leading eigenvector of Sigma_C - Sigma_NC, recovers the daily
# policy shock series via Mertens-Ravn (2013) GLS projection, and
# aggregates to monthly z_het. Appends z_het to the existing
# instrumentos_mensais.csv produced by script/instrument.R without
# touching the 4 pre-existing variants.
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
source("R/identification/het_shock_extraction.R")

# ---- Config ------------------------------------------------

SAMPLE_START <- as.Date("2013-01-01")
SAMPLE_END   <- as.Date("2025-12-31")
LOAD_START   <- as.Date("2012-06-01")
TARGET_BD_3M <- 63L
TARGET_BD_2Y <- 504L
MP_VAR       <- "DI_3m"            # policy variable that pins the sign of b_1
# 3 days covers Thu, Fri-after-Thu-holiday, and Mon-after-Thu+Fri-holiday;
# rejects week-long holidays (e.g., Carnaval Wed -> Quarta-feira de Cinzas).
MAX_GAP_DAYS <- 3L

# ---- Load data ---------------------------------------------

di_panel <- load_di_panel("data/di.csv", from = LOAD_START, to = SAMPLE_END + 30)

ibov_daily <- read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ibov = as.numeric(ibov)) |>
  filter(!is.na(ibov))

brl_path <- "data/processed/brl_usd_daily.csv"
if (!file.exists(brl_path)) {
  stop("BRL/USD daily file missing. Run: Rscript R/data_download/external_factors.R")
}
brl_daily <- read_csv(brl_path, show_col_types = FALSE) |>
  transmute(date = as.Date(date), brl = as.numeric(brl)) |>
  filter(!is.na(brl))

copom_wed <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)

# ---- Build regime table over Wed-to-Thu pairs --------------

panel_dates <- sort(unique(di_panel$date))
panel_dates <- panel_dates[panel_dates >= SAMPLE_START & panel_dates <= SAMPLE_END]

regime_tbl <- build_daily_regimes(panel_dates, copom_wed, max_gap_days = MAX_GAP_DAYS)

message(sprintf(
  "Regime table: %d Wed-Thu pairs (%d C, %d NC)",
  nrow(regime_tbl),
  sum(regime_tbl$regime == "C"),
  sum(regime_tbl$regime == "NC")
))

# ---- Compute Wed-to-Thu changes for the SVAR block ---------

di_3m <- extract_di_change(di_panel, regime_tbl, target_bd = TARGET_BD_3M)
di_2y <- extract_di_change(di_panel, regime_tbl, target_bd = TARGET_BD_2Y)
r_ibov <- extract_price_change(ibov_daily, regime_tbl, transform = "log_diff") * 100
r_brl  <- extract_price_change(brl_daily,  regime_tbl, transform = "log_diff") * 100

changes <- cbind(DI_3m = di_3m, DI_2y = di_2y, IBOV = r_ibov, BRL = r_brl)

n_complete <- sum(complete.cases(changes))
message(sprintf("Daily change matrix: %d rows total, %d complete (no NA)",
                nrow(changes), n_complete))

# ---- Validate variance split (GRG Table 1) -----------------

dir.create("output", showWarnings = FALSE)

val <- validate_variance_split(changes, regime_tbl, alpha = 0.01,
                               n_boot = 1000L, seed = 42L)
write_csv(val, "output/het_variance_validation.csv")

cat("\n========== VARIANCE SPLIT VALIDATION ==========\n")
print(val)
cat("\n")

di3m_ratio <- val$ratio[val$var == MP_VAR]
di3m_ci_low <- val$ci_low[val$var == MP_VAR]
if (di3m_ratio < 1 || di3m_ci_low < 1) {
  warning(sprintf(
    "Hypothesis A1 not satisfied for %s (ratio=%.2f, ci_low=%.2f). Identification is weak.",
    MP_VAR, di3m_ratio, di3m_ci_low
  ))
}

# ---- Identify b_1 and recover daily shock series -----------

mp_idx <- which(colnames(changes) == MP_VAR)
ext <- extract_shock_rigobon_sack(changes, regime_tbl, mp_var_idx = mp_idx)

cat("========== RIGOBON-SACK IDENTIFICATION ==========\n")
cat(sprintf("  n_C = %d   n_NC = %d\n", ext$n_C, ext$n_NC))
cat("  eigenvalues of dSigma:\n")
print(setNames(round(ext$lambda_all, 4), colnames(changes)))
cat(sprintf("  rank1_share    = %.3f  (gate: > 0.6)\n", ext$rank1_share))
cat(sprintf("  eigenvalue_gap = %.3f\n", ext$eigenvalue_gap))
if (ext$rank1_share < 0.6) {
  warning(sprintf(
    "rank1_share = %.3f below 0.6 gate: dSigma is not well approximated by rank 1, identification is suspect.",
    ext$rank1_share
  ))
}

# Persist identification diagnostics for the report in instrument_diagnostics.R.
tibble(
  rank = seq_along(ext$lambda_all),
  variable = c(colnames(changes), rep(NA_character_, length(ext$lambda_all) - ncol(changes)))[seq_along(ext$lambda_all)],
  lambda = ext$lambda_all,
  abs_share = abs(ext$lambda_all) / sum(abs(ext$lambda_all))
) |> write_csv("output/het_eigenvalues.csv")

tibble(variable = colnames(changes), b_1 = ext$b_1) |>
  write_csv("output/het_b_1.csv")
cat(sprintf("  psd_min_eig    = %.4g\n", ext$psd_min_eig))
cat("  impact column b_1:\n")
print(setNames(round(ext$b_1, 4), colnames(changes)))
cat("\n")

# ---- Jarocinski-Karadi sign filter on the daily shock ------
# Audit (script/instrument_audit.R, 2026-04-25) showed that on monthly
# yield_6m the JK-filtered series gives F = 21 vs 7.6 unfiltered. Both
# variants are persisted; downstream scripts pick which one to use.

ibov_at_C <- changes[complete.cases(changes), "IBOV"][regime_tbl[complete.cases(changes), "regime"] == "C"]
jk_mask   <- sign(ext$shocks_C) != 0 & sign(ibov_at_C) != 0 &
             sign(ext$shocks_C) != sign(ibov_at_C)

cat(sprintf("JK sign filter: %d / %d Copom days kept (%.1f%% pure monetary)\n",
            sum(jk_mask), length(jk_mask), 100 * mean(jk_mask)))

# ---- Aggregate daily shocks to monthly ---------------------

z_het <- aggregate_shock_to_monthly(
  ext$shocks_C, ext$shocks_C_dates,
  month_range = c(SAMPLE_START, SAMPLE_END)
)
z_het_jk <- aggregate_shock_to_monthly(
  ext$shocks_C * jk_mask, ext$shocks_C_dates,
  month_range = c(SAMPLE_START, SAMPLE_END)
) |> rename(z_het_jk = z_het)

# ---- Append both variants to the combined monthly file -----

combined_path <- "data/processed/instrumentos_mensais.csv"
if (file.exists(combined_path)) {
  existing <- read_csv(combined_path, show_col_types = FALSE) |>
    mutate(month = as.Date(month))
  for (drop_col in c("z_het", "z_het_jk")) {
    if (drop_col %in% names(existing)) existing[[drop_col]] <- NULL
  }
  combined <- existing |>
    left_join(z_het,    by = "month") |>
    left_join(z_het_jk, by = "month") |>
    mutate(z_het    = replace_na(z_het,    0),
           z_het_jk = replace_na(z_het_jk, 0))
} else {
  combined <- z_het |> left_join(z_het_jk, by = "month")
  warning(sprintf(
    "%s did not exist; created with z_het variants only. Run script/instrument.R for the four legacy variants.",
    combined_path
  ))
}
write_csv(combined, combined_path)

# Single-variant CSVs consumed by model_alessi.R / model_var.R when
# DEFAULT_VARIANT in script/instrument.R points at one of these.
z_het    |> transmute(month, shock = z_het)    |> write_csv("data/processed/instrument_z_het.csv")
z_het_jk |> transmute(month, shock = z_het_jk) |> write_csv("data/processed/instrument_z_het_jk.csv")

# ---- Console summary ---------------------------------------

cat("========== HETEROSKEDASTICITY INSTRUMENT SUMMARY ==========\n")
cat(sprintf("  Sample:           %s to %s\n", SAMPLE_START, SAMPLE_END))
cat(sprintf("  Daily SVAR k_d:   %d (%s)\n",
            ncol(changes), paste(colnames(changes), collapse = ", ")))
cat(sprintf("  Policy variable:  %s (mp_var_idx = %d)\n", MP_VAR, mp_idx))
cat(sprintf("  Wed-Thu pairs:    %d (C=%d, NC=%d)\n",
            nrow(regime_tbl), ext$n_C, ext$n_NC))
cat(sprintf("  Monthly obs:      %d (nonzero z_het: %d, nonzero z_het_jk: %d)\n",
            nrow(z_het), sum(z_het$z_het != 0), sum(z_het_jk$z_het_jk != 0)))
cat(sprintf("  z_het    sd:      %.3f  range: [%.3f, %.3f]\n",
            sd(z_het$z_het), min(z_het$z_het), max(z_het$z_het)))
cat(sprintf("  z_het_jk sd:      %.3f  range: [%.3f, %.3f]\n",
            sd(z_het_jk$z_het_jk), min(z_het_jk$z_het_jk), max(z_het_jk$z_het_jk)))
cat("===========================================================\n\n")
