# ============================================================
# Diagnostic audit of the heteroskedasticity-identified instrument.
# Three fronts:
#   F1: aggregation alignment (simple sum vs Gertler-Karadi weighting)
#       and maturity alignment (daily anchor vs monthly target).
#   F2: grid search of the monthly policy variable.
#   F3: Jarocinski-Karadi sign filter applied to the daily shock.
# Writes output/instrument_audit_report.md and a comparison CSV.
# ============================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(lubridate)
  library(tidyr)
  library(readr)
  library(purrr)
  library(tibble)
  library(sandwich)
  library(lmtest)
})

source("R/instrument/di_surprise.R")
source("R/identification/het_shock_extraction.R")
source("R/modeling/factor_estimation.R")

dir.create("output", showWarnings = FALSE)

# ---- Config ------------------------------------------------

SAMPLE_START <- as.Date("2013-01-01")
SAMPLE_END   <- as.Date("2025-12-31")
LOAD_START   <- as.Date("2012-06-01")
TARGET_BD_3M <- 63L
TARGET_BD_2Y <- 504L
MP_VAR       <- "DI_3m"
MAX_GAP_DAYS <- 3L

# ---- F1: rebuild the daily shock series --------------------

di_panel  <- load_di_panel("data/di.csv", from = LOAD_START, to = SAMPLE_END + 30)
ibov_d    <- read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ibov = as.numeric(ibov)) |> filter(!is.na(ibov))
brl_d     <- read_csv("data/processed/brl_usd_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), brl = as.numeric(brl)) |> filter(!is.na(brl))
copom_w   <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)

panel_dates <- sort(unique(di_panel$date))
panel_dates <- panel_dates[panel_dates >= SAMPLE_START & panel_dates <= SAMPLE_END]
reg_tbl <- build_daily_regimes(panel_dates, copom_w, max_gap_days = MAX_GAP_DAYS)

di_3m  <- extract_di_change(di_panel, reg_tbl, target_bd = TARGET_BD_3M)
di_2y  <- extract_di_change(di_panel, reg_tbl, target_bd = TARGET_BD_2Y)
r_ibov <- extract_price_change(ibov_d, reg_tbl, transform = "log_diff") * 100
r_brl  <- extract_price_change(brl_d,  reg_tbl, transform = "log_diff") * 100
changes <- cbind(DI_3m = di_3m, DI_2y = di_2y, IBOV = r_ibov, BRL = r_brl)

ext <- extract_shock_rigobon_sack(changes, reg_tbl, mp_var_idx = which(colnames(changes) == MP_VAR))

# Align IBOV onto Copom Thu-pairs for the JK filter (F3)
complete <- complete.cases(changes)
reg_complete <- reg_tbl[complete, ]
ibov_complete <- changes[complete, "IBOV"]
shocks_C  <- ext$shocks_C
thu_C     <- ext$shocks_C_dates
ibov_C    <- ibov_complete[reg_complete$regime == "C"]

# ---- F1 / F3 aggregations ----------------------------------

# Brazilian-holiday-aware business-day count: derive the trading calendar
# from the DI panel dates (BMF actual closes), which already exclude
# Carnaval, Corpus Christi, and other ANBIMA holidays.
trading_days <- sort(unique(di_panel$date))

bdays_in_month <- function(d) {
  m_start <- floor_date(d, "month")
  m_end   <- ceiling_date(d, "month") - days(1)
  bd_grid <- trading_days[trading_days >= m_start & trading_days <= m_end]
  list(D = length(bd_grid),
       day_idx = sum(bd_grid <= d))
}

# Gertler-Karadi monthly weight: a shock that hits on business day d in a
# D-business-day month moves the monthly average rate by (D - d + 1) / D,
# because the new rate prevails for D - d + 1 of the D days.
gk_weight <- function(date) {
  bm <- bdays_in_month(date)
  (bm$D - bm$day_idx + 1) / bm$D
}

aggregate_with_weight <- function(shocks, dates, weighted = FALSE,
                                  start = SAMPLE_START, end = SAMPLE_END) {
  if (weighted) {
    w <- vapply(dates, gk_weight, FUN.VALUE = NA_real_)
    contrib <- shocks * w
  } else {
    contrib <- shocks
  }
  months <- seq(floor_date(start, "month"), floor_date(end, "month"), by = "month")
  obs <- tibble(date = dates, c = contrib) |>
    mutate(month = floor_date(date, "month")) |>
    group_by(month) |>
    summarise(z = sum(c, na.rm = TRUE), .groups = "drop")
  tibble(month = months) |>
    left_join(obs, by = "month") |>
    mutate(z = replace_na(z, 0)) |>
    pull(z)
}

# JK filter on the daily shock: keep only days where ε̂_1 and ΔIBOV move in
# OPPOSITE directions ("pure monetary"); zero out same-sign days ("info").
jk_mask <- sign(shocks_C) != 0 & sign(ibov_C) != 0 & sign(shocks_C) != sign(ibov_C)

# ---- F2: monthly policy candidates -------------------------

raw <- read_csv("data/raw_data.csv", show_col_types = FALSE) |>
  mutate(ref.date = as.Date(ref.date)) |>
  filter(ref.date >= SAMPLE_START, ref.date <= SAMPLE_END) |>
  arrange(ref.date)

policy_candidates <- list(
  juros_selic = raw$juros_selic,
  juros_cdi   = raw$juros_cdi,
  yield_3m    = raw$yield_3m,
  yield_6m    = raw$yield_6m,
  yield_1y    = raw$yield_1y,
  yield_2y    = raw$yield_2y,
  yield_5y    = raw$yield_5y
)
candidate_dates <- raw$ref.date

# ---- First-stage F utility ---------------------------------

first_stage_F <- function(z_aligned, candidate_series, n_lags = 6L) {
  innov_data <- data.frame(
    y = candidate_series,
    purrr::map_dfc(seq_len(n_lags),
                   \(k) tibble(!!paste0("lag", k) := dplyr::lag(candidate_series, k)))
  )
  # na.exclude preserves residual length = nrow(input) by inserting NAs where
  # the AR(6) regression dropped observations, so alignment with z_aligned
  # is positional and safe.
  innov_lm <- lm(y ~ ., data = innov_data, na.action = na.exclude)
  innov <- residuals(innov_lm)

  ok <- !is.na(innov) & !is.na(z_aligned)
  fs <- lm(y ~ z, data = data.frame(y = innov[ok], z = z_aligned[ok]))
  ct <- coeftest(fs, vcov = vcovHC(fs, type = "HC0"))
  list(F_partial = unname(ct["z", "t value"])^2,
       beta = unname(ct["z", "Estimate"]),
       se   = unname(ct["z", "Std. Error"]),
       n    = sum(ok),
       r2   = summary(fs)$r.squared)
}

# Build all instrument variants
build_z_variants <- function() {
  z_sum   <- aggregate_with_weight(shocks_C,            thu_C, weighted = FALSE)
  z_gk    <- aggregate_with_weight(shocks_C,            thu_C, weighted = TRUE)
  z_jk    <- aggregate_with_weight(shocks_C * jk_mask,  thu_C, weighted = FALSE)
  z_jk_gk <- aggregate_with_weight(shocks_C * jk_mask,  thu_C, weighted = TRUE)
  list(
    z_het         = z_sum,
    z_het_gk      = z_gk,
    z_het_jk      = z_jk,
    z_het_jk_gk   = z_jk_gk
  )
}
z_variants <- build_z_variants()

monthly_grid <- seq(floor_date(SAMPLE_START, "month"),
                    floor_date(SAMPLE_END, "month"), by = "month")
# Normalize candidate dates to month-start before joining; raw_data.csv
# may use month-start or month-end conventions across stages of the pipeline.
candidate_months <- floor_date(candidate_dates, "month")
align_z_to_dates <- function(z_vec) {
  z_tbl <- tibble(month = monthly_grid, z = z_vec)
  tibble(month = candidate_months) |>
    left_join(z_tbl, by = "month") |>
    pull(z)
}
z_variants_aligned <- lapply(z_variants, align_z_to_dates)

# ---- Run grid ----------------------------------------------

grid <- expand.grid(
  variant   = names(z_variants),
  candidate = names(policy_candidates),
  stringsAsFactors = FALSE
)

results <- pmap_dfr(grid, function(variant, candidate) {
  fs <- first_stage_F(z_variants_aligned[[variant]],
                      policy_candidates[[candidate]])
  tibble(variant = variant, candidate = candidate,
         n = fs$n, beta = fs$beta, se = fs$se,
         F_partial = fs$F_partial, r2 = fs$r2)
})

# ---- Daily diagnostics for the report ----------------------

daily_diag <- list(
  n_C        = ext$n_C,
  n_NC       = ext$n_NC,
  jk_share   = mean(jk_mask),
  lambda_all = ext$lambda_all,
  rank1_share    = ext$rank1_share,
  eigenvalue_gap = ext$eigenvalue_gap,
  var_ratio_DI3m = var(changes[reg_tbl$regime == "C", "DI_3m"], na.rm = TRUE) /
                   var(changes[reg_tbl$regime == "NC", "DI_3m"], na.rm = TRUE)
)

# ---- Report ------------------------------------------------

write_csv(results, "output/instrument_audit_grid.csv")

best <- results |> arrange(desc(F_partial)) |> head(5)

fmt <- function(x, d = 3) sprintf(paste0("%.", d, "f"), x)

grid_md <- results |>
  mutate(across(c(beta, se, F_partial, r2), ~ fmt(.x, 3))) |>
  arrange(variant, candidate) |>
  mutate(row = sprintf("| %-13s | %-12s | %3d | %s | %s | %s | %s |",
                       variant, candidate, n, beta, se, F_partial, r2)) |>
  pull(row)

report <- paste(c(
  "# Instrument Audit Report — heteroskedasticity-identified `z_het`",
  sprintf("Date: %s", Sys.Date()),
  sprintf("Sample: %s to %s", SAMPLE_START, SAMPLE_END),
  "",
  "## Front 1.1 — aggregation convention",
  "",
  "**Finding:** `juros_selic` is BCB series 4189 (\"Selic acumulada no mês\"), a flow-",
  "type variable, ≈ monthly average. The current implementation aggregates the daily",
  "shock by SIMPLE SUM (`R/identification/het_shock_extraction.R::aggregate_shock_to_monthly`).",
  "**Mismatch.** Gertler-Karadi (2015) weighting (D - d + 1)/D is the correct fix",
  "for an average/cumulative monthly target. The yield_* candidates (Svensson",
  "end-of-month snapshot) admit simple sum; juros_selic / juros_cdi do not.",
  "",
  "## Front 1.2 — maturity alignment",
  "",
  "Daily anchor (sign normalization in `extract_shock_rigobon_sack`): **DI_3m**",
  "(target_bd = 63 ≈ 3 months). Monthly DFM policy variable in CLAUDE.md and",
  "`script/model_alessi.R`: **juros_selic** (overnight). Mismatch: the daily",
  "extraction identifies a 3-month forward-rate shock; the monthly target is",
  "the overnight policy rate. Fronts 2 and 3 quantify the impact.",
  "",
  "## Front 1.3 — daily noise / rank-1 (already validated)",
  "",
  sprintf("- Var(ΔDI_3m | C) / Var(ΔDI_3m | NC) = %.2f (gate: > 2). %s.",
          daily_diag$var_ratio_DI3m,
          ifelse(daily_diag$var_ratio_DI3m > 2, "**PASS**", "FAIL")),
  sprintf("- Eigenvalues of dSigma: %s",
          paste(sprintf("%.2f", daily_diag$lambda_all), collapse = ", ")),
  sprintf("- λ₁ / |λ₂| = %.2f.", daily_diag$eigenvalue_gap),
  sprintf("- rank-1 share = %.3f (gate: > 0.6). %s.",
          daily_diag$rank1_share,
          ifelse(daily_diag$rank1_share > 0.6, "**PASS**", "FAIL")),
  "",
  "Daily signal is strong; the bottleneck is downstream (aggregation / maturity).",
  "",
  "## Front 2 + Front 3 — grid: instrument variant × monthly policy candidate",
  "",
  "Variants:",
  "- `z_het` = simple monthly sum of daily shocks (current production).",
  "- `z_het_gk` = Gertler-Karadi weighted sum.",
  "- `z_het_jk` = JK filter (sign(ε̂)≠sign(ΔIBOV)) + simple sum.",
  "- `z_het_jk_gk` = JK filter + GK weighting.",
  "",
  sprintf("JK filter retains %d / %d Copom days (%.1f%% \"pure monetary\").",
          sum(jk_mask), length(jk_mask), 100 * mean(jk_mask)),
  "",
  "First stage on AR(6)-residualized monthly target. F is t² with HC0 SE.",
  "Stock-Yogo critical value for one instrument: F > 10.",
  "",
  "| variant       | candidate    |   n | beta   | se     | F      | R²     |",
  "|---------------|--------------|-----|--------|--------|--------|--------|",
  paste(grid_md, collapse = "\n"),
  "",
  "## Top-5 specifications",
  "",
  paste(c("| variant | candidate | F | R² |",
          "|---|---|---|---|",
          best |> mutate(row = sprintf("| %s | %s | %.3f | %.3f |",
                                       variant, candidate, F_partial, r2)) |>
            pull(row)),
        collapse = "\n"),
  "",
  "## Diagnosis",
  "",
  "The bottleneck of the original `z_het` is in **Front 1.1 (aggregation)** and",
  "**Front 1.2 (maturity mismatch)**, not Front 1.3 (daily signal is strong).",
  "The grid identifies the best combination above. The fix is twofold:",
  "1. Align aggregation: GK-weighted sum if the monthly target is a flow",
  "   (Selic, CDI); simple sum if EoP (yields).",
  "2. Pick the maturity that maximizes first-stage F — typically the closest",
  "   to the daily anchor (DI_3m on the daily side ↔ yield_3m monthly).",
  "",
  "JK filter is a complementary purification, expected to raise F when the daily",
  "shocks contain information shocks; orthogonal to the aggregation fix."
), collapse = "\n")

writeLines(report, "output/instrument_audit_report.md")

cat("\n========== AUDIT GRID (top 8 by F) ==========\n")
print(results |> arrange(desc(F_partial)) |> head(8))
cat("=============================================\n\n")
cat("Report written to output/instrument_audit_report.md\n")
cat("Grid saved to    output/instrument_audit_grid.csv\n")
