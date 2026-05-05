# ============================================================
# Heteroskedasticity-identified instrument (Rigobon-Sack 2003 QJE).
# Builds a daily SVAR over Wed-to-Thu pairs (regime C = Copom Wed,
# regime NC = other Wed), identifies the policy impact column from
# the leading eigenvector of Sigma_C - Sigma_NC, recovers the daily
# policy shock series via Mertens-Ravn (2013) GLS projection, and
# aggregates to monthly z_het.
#
# Two specifications are produced and persisted side-by-side:
#   - 4-var production block: (DI_3m, DI_2y, IBOV, BRL)  -> z_het, z_het_jk
#   - 3-var robustness block: (DI_3m,        IBOV, BRL)  -> z_het_3var, z_het_jk_3var
#
# The 3-var block exists because the variance-split CI for DI_2y can
# violate the A2 homoskedasticity assumption (council Required 1, 2026-05-05);
# dropping DI_2y removes the secondary shock that contaminates b_1.
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

di_3m  <- extract_di_change(di_panel, regime_tbl, target_bd = TARGET_BD_3M)
di_2y  <- extract_di_change(di_panel, regime_tbl, target_bd = TARGET_BD_2Y)
r_ibov <- extract_price_change(ibov_daily, regime_tbl, transform = "log_diff") * 100
r_brl  <- extract_price_change(brl_daily,  regime_tbl, transform = "log_diff") * 100

changes_4var <- cbind(DI_3m = di_3m, DI_2y = di_2y, IBOV = r_ibov, BRL = r_brl)
changes_3var <- cbind(DI_3m = di_3m,                IBOV = r_ibov, BRL = r_brl)

n_complete_4var <- sum(complete.cases(changes_4var))
n_complete_3var <- sum(complete.cases(changes_3var))
message(sprintf(
  "Daily change matrices: 4-var %d/%d complete; 3-var %d/%d complete",
  n_complete_4var, nrow(changes_4var),
  n_complete_3var, nrow(changes_3var)
))

# ---- Validate variance split (GRG Table 1) -----------------

dir.create("output", showWarnings = FALSE)

val_4var <- validate_variance_split(changes_4var, regime_tbl, alpha = 0.01,
                                    n_boot = 1000L, seed = 42L) |>
  classify_a2_verdict(mp_var = MP_VAR)
val_3var <- validate_variance_split(changes_3var, regime_tbl, alpha = 0.01,
                                    n_boot = 1000L, seed = 42L) |>
  classify_a2_verdict(mp_var = MP_VAR)

write_csv(val_4var, "output/het_variance_validation.csv")
write_csv(val_3var, "output/het_variance_validation_3var.csv")

cat("\n========== VARIANCE SPLIT VALIDATION (4-var) ==========\n")
print(val_4var)

# A1 gate (policy variable: ratio > 1 with CI excluding 1 from below)
mp_row <- val_4var |> filter(var == MP_VAR)
if (mp_row$ratio < 1 || mp_row$ci_low < 1) {
  warning(sprintf(
    "A1 violated: %s ratio=%.2f, ci_low=%.2f. Identification is weak.",
    MP_VAR, mp_row$ratio, mp_row$ci_low
  ))
}

# A2 gate per non-policy variable (CI must include 1)
violators_4var <- val_4var |> filter(a2_status == "violated")
if (nrow(violators_4var) > 0) {
  for (i in seq_len(nrow(violators_4var))) {
    r <- violators_4var[i, ]
    warning(sprintf(
      "A2 violated for %s (4-var SVAR): ratio=%.2f, CI99 = [%.2f, %.2f] (%s side). %s",
      r$var, r$ratio, r$ci_low, r$ci_high, r$a2_side,
      "Compare b_1 with the 3-var SVAR (drops DI_2y)."
    ))
  }
}

cat("\n========== VARIANCE SPLIT VALIDATION (3-var, robustness) ==========\n")
print(val_3var)
violators_3var <- val_3var |> filter(a2_status == "violated")
if (nrow(violators_3var) > 0) {
  for (i in seq_len(nrow(violators_3var))) {
    r <- violators_3var[i, ]
    warning(sprintf(
      "A2 violated for %s (3-var SVAR): ratio=%.2f, CI99 = [%.2f, %.2f] (%s side).",
      r$var, r$ratio, r$ci_low, r$ci_high, r$a2_side
    ))
  }
}

# ---- Identify b_1 and recover daily shock series -----------

run_het <- function(changes_matrix, label) {
  cat(sprintf("\n========== RIGOBON-SACK IDENTIFICATION (%s) ==========\n", label))
  built <- build_het_instrument(
    changes_matrix, regime_tbl,
    mp_var = MP_VAR,
    month_range = c(SAMPLE_START, SAMPLE_END)
  )
  ext <- built$ext
  k_d <- ncol(changes_matrix)

  cat(sprintf("  n_C = %d   n_NC = %d   k_d = %d\n", ext$n_C, ext$n_NC, k_d))
  cat("  eigenvalues of dSigma:\n")
  print(setNames(round(ext$lambda_all, 4), colnames(changes_matrix)))
  cat(sprintf("  rank1_share    = %.3f  (gate: > 0.6)\n", ext$rank1_share))
  cat(sprintf("  eigenvalue_gap = %.3f\n", ext$eigenvalue_gap))
  cat(sprintf("  psd_min_eig    = %.4g\n", ext$psd_min_eig))
  if (ext$rank1_share < 0.6) {
    warning(sprintf(
      "rank1_share = %.3f below 0.6 (%s): dSigma is not well approximated by rank 1.",
      ext$rank1_share, label
    ))
  }
  cat("  impact column b_1:\n")
  print(setNames(round(ext$b_1, 4), colnames(changes_matrix)))
  cat(sprintf("  JK sign filter: %d / %d Copom days kept (%.1f%% pure monetary)\n",
              built$n_jk_kept, length(built$jk_mask), 100 * mean(built$jk_mask)))

  built
}

built_4var <- run_het(changes_4var, "4-var")
built_3var <- run_het(changes_3var, "3-var robustness")

# ---- Persist eigenvalue and b_1 diagnostics ----------------

persist_diagnostics <- function(built, changes_matrix, suffix = "") {
  vars <- colnames(changes_matrix)
  ext  <- built$ext
  k_d  <- length(vars)

  eig_path <- sprintf("output/het_eigenvalues%s.csv", suffix)
  b1_path  <- sprintf("output/het_b_1%s.csv",         suffix)

  tibble(
    rank      = seq_along(ext$lambda_all),
    variable  = c(vars, rep(NA_character_, length(ext$lambda_all) - k_d))[seq_along(ext$lambda_all)],
    lambda    = ext$lambda_all,
    abs_share = abs(ext$lambda_all) / sum(abs(ext$lambda_all))
  ) |> write_csv(eig_path)

  tibble(variable = vars, b_1 = ext$b_1) |> write_csv(b1_path)
}

persist_diagnostics(built_4var, changes_4var, suffix = "")
persist_diagnostics(built_3var, changes_3var, suffix = "_3var")

# ---- Append both blocks to the combined monthly file -------

combined_path <- "data/processed/instrumentos_mensais.csv"
new_cols <- c("z_het", "z_het_jk", "z_het_3var", "z_het_jk_3var")

block <- built_4var$z_het |>
  left_join(built_4var$z_het_jk,                          by = "month") |>
  left_join(built_3var$z_het    |> rename(z_het_3var    = z_het),    by = "month") |>
  left_join(built_3var$z_het_jk |> rename(z_het_jk_3var = z_het_jk), by = "month")

if (file.exists(combined_path)) {
  existing <- read_csv(combined_path, show_col_types = FALSE) |>
    mutate(month = as.Date(month))
  for (drop_col in new_cols) {
    if (drop_col %in% names(existing)) existing[[drop_col]] <- NULL
  }
  combined <- existing |>
    left_join(block, by = "month") |>
    mutate(across(all_of(new_cols), ~ replace_na(.x, 0)))
} else {
  combined <- block
  warning(sprintf(
    "%s did not exist; created with z_het variants only. Run script/instrument.R for the four legacy variants.",
    combined_path
  ))
}
write_csv(combined, combined_path)

# Single-variant CSVs consumed by model_alessi.R / model_var.R when
# DEFAULT_VARIANT in script/instrument.R points at one of these.
built_4var$z_het    |> transmute(month, shock = z_het)         |>
  write_csv("data/processed/instrument_z_het.csv")
built_4var$z_het_jk |> transmute(month, shock = z_het_jk)      |>
  write_csv("data/processed/instrument_z_het_jk.csv")
built_3var$z_het    |> transmute(month, shock = z_het)         |>
  write_csv("data/processed/instrument_z_het_3var.csv")
built_3var$z_het_jk |> transmute(month, shock = z_het_jk)      |>
  write_csv("data/processed/instrument_z_het_jk_3var.csv")

# ---- Console summary ---------------------------------------

cat("\n========== HETEROSKEDASTICITY INSTRUMENT SUMMARY ==========\n")
cat(sprintf("  Sample:           %s to %s\n", SAMPLE_START, SAMPLE_END))
cat(sprintf("  4-var SVAR k_d:   %d (%s)\n", ncol(changes_4var),
            paste(colnames(changes_4var), collapse = ", ")))
cat(sprintf("  3-var SVAR k_d:   %d (%s)\n", ncol(changes_3var),
            paste(colnames(changes_3var), collapse = ", ")))
cat(sprintf("  Policy variable:  %s\n", MP_VAR))
cat(sprintf("  Wed-Thu pairs:    %d (C=%d, NC=%d)\n",
            nrow(regime_tbl),
            built_4var$ext$n_C, built_4var$ext$n_NC))

print_var_summary <- function(built, label) {
  z  <- built$z_het$z_het
  zj <- built$z_het_jk$z_het_jk
  cat(sprintf(
    "  %-20s nonzero z_het=%d, z_het_jk=%d  sd(z_het)=%.3f, sd(z_het_jk)=%.3f\n",
    label, sum(z != 0), sum(zj != 0), sd(z), sd(zj)
  ))
}
print_var_summary(built_4var, "4-var (production):")
print_var_summary(built_3var, "3-var (robustness):")

cat("===========================================================\n\n")
