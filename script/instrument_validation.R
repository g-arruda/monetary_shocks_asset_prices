# ============================================================
# Validation tests for the heteroskedasticity-identified instrument
# z_het_jk + yield_6m (HANDOFF.md, 2026-04-25 / 2026-05-05):
#   T1 placebo:        permute z_het_jk, expect F ≈ 1
#   T2 random-mask:    keep 42 random Copom days vs JK filter
#   T3 sub-period:     2013-2019, 2020-2025, full minus COVID acute
#   T4 correlation:    cor(z_het_jk, z_jk_purif) monthly
#   T5 anti-JK mask:   keep "informational" days (sign(shock)==sign(IBOV))
#   T6 F(k_keep) curve: random masks at k ∈ {20, 42, 60, 80}
# Writes output/het_validation_report.md and per-test CSVs.
# ============================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(lubridate)
  library(tidyr)
  library(readr)
  library(purrr)
  library(tibble)
  library(ggplot2)
})

source("R/instrument/di_surprise.R")
source("R/identification/het_shock_extraction.R")
source("R/identification/validation_tests.R")

dir.create("output", showWarnings = FALSE)

# ---- Config -----------------------------------------------

SAMPLE_START <- as.Date("2013-01-01")
SAMPLE_END   <- as.Date("2025-12-31")
LOAD_START   <- as.Date("2012-06-01")
TARGET_BD_3M <- 63L
TARGET_BD_2Y <- 504L
MP_VAR       <- "DI_3m"
MAX_GAP_DAYS <- 3L
TARGET_VAR   <- "yield_6m"
N_LAGS       <- 6L
N_PERM       <- 2000L
N_DRAWS      <- 2000L
SEED_PLACEBO <- 20260426L
SEED_MASK    <- 20260427L
SEED_FCURVE  <- 20260505L
K_KEEP_GRID  <- c(20L, 42L, 60L, 80L)

# ---- Reextract daily shock and JK mask --------------------

di_panel <- load_di_panel("data/di.csv", from = LOAD_START, to = SAMPLE_END + 30)
ibov_d   <- read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ibov = as.numeric(ibov)) |> filter(!is.na(ibov))
brl_d    <- read_csv("data/processed/brl_usd_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), brl = as.numeric(brl)) |> filter(!is.na(brl))
copom_w  <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)

panel_dates <- sort(unique(di_panel$date))
panel_dates <- panel_dates[panel_dates >= SAMPLE_START & panel_dates <= SAMPLE_END]
reg_tbl <- build_daily_regimes(panel_dates, copom_w, max_gap_days = MAX_GAP_DAYS)

di_3m  <- extract_di_change(di_panel, reg_tbl, target_bd = TARGET_BD_3M)
di_2y  <- extract_di_change(di_panel, reg_tbl, target_bd = TARGET_BD_2Y)
r_ibov <- extract_price_change(ibov_d, reg_tbl, transform = "log_diff") * 100
r_brl  <- extract_price_change(brl_d,  reg_tbl, transform = "log_diff") * 100
changes <- cbind(DI_3m = di_3m, DI_2y = di_2y, IBOV = r_ibov, BRL = r_brl)

ext <- extract_shock_rigobon_sack(
  changes, reg_tbl,
  mp_var_idx = which(colnames(changes) == MP_VAR)
)
shocks_C <- ext$shocks_C
thu_C    <- ext$shocks_C_dates

complete_idx  <- complete.cases(changes)
ibov_complete <- changes[complete_idx, "IBOV"]
reg_complete  <- reg_tbl[complete_idx, ]
ibov_C        <- ibov_complete[reg_complete$regime == "C"]

jk_mask <- sign(shocks_C) != 0 & sign(ibov_C) != 0 &
           sign(shocks_C) != sign(ibov_C)
n_jk_kept <- sum(jk_mask)
message(sprintf("JK filter: %d / %d Copom days kept (%.1f%%)",
                n_jk_kept, length(jk_mask), 100 * mean(jk_mask)))

# ---- Load monthly target and instrument -------------------

raw <- read_csv("data/raw_data.csv", show_col_types = FALSE) |>
  mutate(ref.date = as.Date(ref.date)) |>
  filter(ref.date >= SAMPLE_START, ref.date <= SAMPLE_END) |>
  arrange(ref.date)

target_series <- raw[[TARGET_VAR]]
target_dates  <- raw$ref.date

# Residualize once on the full contiguous sample; reused by T1, T2, T3.
innov <- residualize_target(target_series, n_lags = N_LAGS)

mensais <- read_csv("data/processed/instrumentos_mensais.csv",
                    show_col_types = FALSE) |>
  mutate(month = as.Date(month))

z_het_jk_aligned <- align_z_to_target(mensais$z_het_jk, mensais$month, target_dates)
z_jk_purif_aligned <- align_z_to_target(mensais$z_jk_purif, mensais$month, target_dates)

obs_fs <- first_stage_F(z_het_jk_aligned, innov)
message(sprintf("Observed F (z_het_jk + %s, AR(%d)): %.3f  (n=%d)",
                TARGET_VAR, N_LAGS, obs_fs$F_partial, obs_fs$n))

# ---- T1: placebo permutation ------------------------------

placebo <- placebo_test(
  z      = z_het_jk_aligned,
  innov  = innov,
  n_perm = N_PERM,
  seed   = SEED_PLACEBO
)
write_csv(placebo, "output/het_validation_placebo.csv")

placebo_summary <- tibble(
  test       = "placebo",
  n_perm     = N_PERM,
  observed_F = obs_fs$F_partial,
  mean_F     = mean(placebo$F_partial),
  median_F   = median(placebo$F_partial),
  q95_F      = quantile(placebo$F_partial, 0.95),
  q99_F      = quantile(placebo$F_partial, 0.99),
  max_F      = max(placebo$F_partial),
  pvalue     = mean(placebo$F_partial >= obs_fs$F_partial)
)

# ---- T2: random-mask --------------------------------------

mask <- random_mask_test(
  shocks_C     = shocks_C,
  shock_dates  = thu_C,
  innov        = innov,
  target_dates = target_dates,
  k_keep       = n_jk_kept,
  month_range  = c(SAMPLE_START, SAMPLE_END),
  n_draws      = N_DRAWS,
  seed         = SEED_MASK
)
write_csv(mask, "output/het_validation_random_mask.csv")

mask_summary <- tibble(
  test       = "random_mask",
  n_draws    = N_DRAWS,
  k_keep     = n_jk_kept,
  observed_F = obs_fs$F_partial,
  mean_F     = mean(mask$F_partial),
  median_F   = median(mask$F_partial),
  q95_F      = quantile(mask$F_partial, 0.95),
  q99_F      = quantile(mask$F_partial, 0.99),
  max_F      = max(mask$F_partial),
  pvalue     = mean(mask$F_partial >= obs_fs$F_partial)
)

# ---- T3: sub-period stability -----------------------------

windows <- list(
  full         = c(as.Date("2013-01-01"), as.Date("2025-12-01")),
  pre_covid    = c(as.Date("2013-01-01"), as.Date("2019-12-01")),
  covid_post   = c(as.Date("2020-01-01"), as.Date("2025-12-01")),
  drop_covid   = c(as.Date("2020-03-01"), as.Date("2020-09-01"))
)
sub_results <- subperiod_F(
  z            = z_het_jk_aligned,
  innov        = innov,
  target_dates = target_dates,
  windows      = windows
)
write_csv(sub_results, "output/het_validation_subperiod.csv")

# ---- T4: monthly correlation ------------------------------

cor_results <- monthly_correlation(
  z1 = mensais$z_het_jk,
  z2 = mensais$z_jk_purif,
  name1 = "z_het_jk",
  name2 = "z_jk_purif"
)
write_csv(cor_results, "output/het_validation_correlation.csv")

# ---- T5: anti-JK mask -------------------------------------

anti <- anti_jk_test(
  shocks_C     = shocks_C,
  ibov_C       = ibov_C,
  shock_dates  = thu_C,
  innov        = innov,
  target_dates = target_dates,
  month_range  = c(SAMPLE_START, SAMPLE_END)
)

anti_summary <- tibble(
  test          = "anti_jk",
  n_total       = anti$n_total,
  n_kept_info   = anti$n_kept,
  n_zero        = anti$n_zero,
  n_jk_monetary = n_jk_kept,
  observed_F    = anti$F_partial,
  beta          = anti$beta,
  se            = anti$se,
  r2            = anti$r2,
  jk_F          = obs_fs$F_partial,
  random_mean_F = mask_summary$mean_F
)
write_csv(anti_summary, "output/het_validation_anti_jk.csv")

# ---- T6: F(k_keep) curve ----------------------------------

curve <- random_mask_curve(
  shocks_C     = shocks_C,
  shock_dates  = thu_C,
  innov        = innov,
  target_dates = target_dates,
  k_keep_grid  = K_KEEP_GRID,
  month_range  = c(SAMPLE_START, SAMPLE_END),
  n_draws      = N_DRAWS,
  seed         = SEED_FCURVE
)
write_csv(curve, "output/het_validation_f_curve.csv")

curve_summary <- random_mask_curve_summary(curve, observed_F = obs_fs$F_partial)
write_csv(curve_summary, "output/het_validation_f_curve_summary.csv")

# ---- Plots ------------------------------------------------

placebo_plot <- ggplot(placebo, aes(F_partial)) +
  geom_histogram(bins = 60, fill = "grey80", colour = "grey40") +
  geom_vline(xintercept = obs_fs$F_partial, colour = "firebrick", linewidth = 0.7) +
  annotate("text", x = obs_fs$F_partial, y = Inf,
           label = sprintf(" observed F = %.2f", obs_fs$F_partial),
           vjust = 2, hjust = 0, colour = "firebrick") +
  labs(title = "T1 placebo — F under permuted z_het_jk",
       x = "first-stage F",
       y = "count") +
  theme_minimal(base_size = 11)
ggsave("output/het_validation_placebo.png", placebo_plot,
       width = 7, height = 4, dpi = 150)

mask_plot <- ggplot(mask, aes(F_partial)) +
  geom_histogram(bins = 60, fill = "grey80", colour = "grey40") +
  geom_vline(xintercept = obs_fs$F_partial, colour = "firebrick", linewidth = 0.7) +
  annotate("text", x = obs_fs$F_partial, y = Inf,
           label = sprintf(" JK F = %.2f", obs_fs$F_partial),
           vjust = 2, hjust = 0, colour = "firebrick") +
  labs(title = sprintf("T2 random mask — F under random %d/%d Copom-day masks",
                       n_jk_kept, length(jk_mask)),
       x = "first-stage F",
       y = "count") +
  theme_minimal(base_size = 11)
ggsave("output/het_validation_random_mask.png", mask_plot,
       width = 7, height = 4, dpi = 150)

# Position the JK reference label over the k=42 box (or whichever k matches
# n_jk_kept), so it visually aligns with the boxplot whose distribution the
# JK F is being compared against.
jk_x <- match(n_jk_kept, K_KEEP_GRID)
if (is.na(jk_x)) jk_x <- which.min(abs(K_KEEP_GRID - n_jk_kept))

curve_plot <- ggplot(curve, aes(x = factor(k_keep), y = F_partial)) +
  geom_boxplot(outlier.alpha = 0.15, fill = "grey85", colour = "grey30") +
  geom_hline(yintercept = obs_fs$F_partial, colour = "firebrick",
             linewidth = 0.7, linetype = "dashed") +
  annotate("text", x = jk_x, y = obs_fs$F_partial,
           label = sprintf(" JK F = %.2f (k = %d)", obs_fs$F_partial, n_jk_kept),
           vjust = -0.5, hjust = 0, colour = "firebrick") +
  labs(title = "T6 — F under random masks across k_keep",
       x = "k_keep (Copom days retained)",
       y = "first-stage F") +
  theme_minimal(base_size = 11)
ggsave("output/het_validation_f_curve.png", curve_plot,
       width = 7, height = 4, dpi = 150)

# ---- Report -----------------------------------------------

fmt <- function(x, d = 3) sprintf(paste0("%.", d, "f"), x)

placebo_md <- sprintf(
  paste0(
    "- observed F = %s\n",
    "- placebo: n_perm = %d, mean F = %s, median F = %s, q95 = %s, q99 = %s, max = %s\n",
    "- p-value (P(F_perm ≥ observed)) = %s"
  ),
  fmt(placebo_summary$observed_F),
  placebo_summary$n_perm,
  fmt(placebo_summary$mean_F), fmt(placebo_summary$median_F),
  fmt(placebo_summary$q95_F), fmt(placebo_summary$q99_F),
  fmt(placebo_summary$max_F),
  fmt(placebo_summary$pvalue, 4)
)

mask_md <- sprintf(
  paste0(
    "- JK observed F = %s (k_keep = %d / %d)\n",
    "- random mask: n_draws = %d, mean F = %s, median F = %s, q95 = %s, q99 = %s, max = %s\n",
    "- p-value (P(F_mask ≥ JK)) = %s"
  ),
  fmt(mask_summary$observed_F),
  n_jk_kept, length(jk_mask),
  mask_summary$n_draws,
  fmt(mask_summary$mean_F), fmt(mask_summary$median_F),
  fmt(mask_summary$q95_F), fmt(mask_summary$q99_F),
  fmt(mask_summary$max_F),
  fmt(mask_summary$pvalue, 4)
)

sub_md <- sub_results |>
  mutate(row = sprintf("| %-11s | %3d | %s | %s | %s | %s | %3d |",
                       window, n_months,
                       fmt(F_partial), fmt(beta), fmt(se), fmt(r2), n_eff)) |>
  pull(row) |>
  paste(collapse = "\n")

cor_md <- cor_results |>
  mutate(row = sprintf("| %-13s | %-3d | %s | %s |",
                       subset, n, fmt(pearson), fmt(spearman))) |>
  pull(row) |>
  paste(collapse = "\n")

anti_md <- sprintf(
  paste0(
    "- F(anti-JK) = %s, beta = %s, SE = %s, R² = %s\n",
    "- days kept (sign-equal, info) = %d / %d Copom days; %d zero-sign excluded\n",
    "- comparison: JK F = %s (k=%d), random-mask mean F = %s (k=%d)"
  ),
  fmt(anti_summary$observed_F),
  fmt(anti_summary$beta),
  fmt(anti_summary$se),
  fmt(anti_summary$r2),
  anti_summary$n_kept_info, anti_summary$n_total, anti_summary$n_zero,
  fmt(anti_summary$jk_F), n_jk_kept,
  fmt(anti_summary$random_mean_F), n_jk_kept
)

curve_md <- curve_summary |>
  mutate(row = sprintf("| %3d | %4d | %s | %s | %s | %s | %s | %s |",
                       k_keep, n_draws,
                       fmt(mean), fmt(median), fmt(q95), fmt(q99), fmt(max),
                       fmt(pvalue, 4))) |>
  pull(row) |>
  paste(collapse = "\n")

report <- paste(c(
  "# Heteroskedasticity instrument — validation report",
  sprintf("Date: %s", Sys.Date()),
  sprintf("Specification: z_het_jk + %s, AR(%d) residualization",
          TARGET_VAR, N_LAGS),
  sprintf("Sample: %s to %s (%d months)", SAMPLE_START, SAMPLE_END, length(target_series)),
  "",
  "## T1 — Placebo (permutation of z_het_jk)",
  "",
  "Under random permutation of the monthly instrument the first-stage F",
  "should concentrate near 1; a small empirical p-value confirms the",
  sprintf("observed F = %s result is not data-snooping.",
          fmt(obs_fs$F_partial)),
  "",
  placebo_md,
  "",
  "Histogram: `output/het_validation_placebo.png`",
  "",
  "## T2 — Random-mask vs JK filter",
  "",
  sprintf("Random subsets of %d Copom days (matching JK count) are kept; the",
          n_jk_kept),
  "remaining days are zeroed before monthly aggregation. If the JK F merely",
  "reflects sparsification, the JK F would lie inside the random-mask",
  "distribution. If JK is genuinely informative (sign filter separates",
  "monetary from information shocks), JK F sits in the upper tail.",
  "",
  mask_md,
  "",
  "Histogram: `output/het_validation_random_mask.png`",
  "",
  "## T3 — Sub-period stability",
  "",
  "Sub-windows defined in HANDOFF.md: pre-COVID (2013-2019), COVID + post",
  "(2020-2025), and full sample with the COVID acute window (2020-03 to",
  "2020-09) excluded. The AR(p) residualization is estimated **once** on the",
  "full contiguous sample and the residuals are subset by window — refitting",
  "AR within `drop_covid` would lag October 2020 on February 2020 (the",
  "non-contiguous window introduces a spurious lag jump).",
  "",
  "| window      |  n  | F      | beta   | se     | R²     | n_eff |",
  "|-------------|-----|--------|--------|--------|--------|-------|",
  sub_md,
  "",
  "## T4 — Correlation with z_jk_purif",
  "",
  "Convergence of heteroskedasticity-based and timing-based identification.",
  "If both instruments capture the same monetary shock, the correlation on",
  "the both-nonzero subset should be high.",
  "",
  "| subset        |  n  | pearson | spearman |",
  "|---------------|-----|---------|----------|",
  cor_md,
  "",
  "## T5 — Anti-JK mask",
  "",
  "Complement of the JK filter: keep Copom days where sign(daily shock)",
  "matches sign(IBOV change) — the days JK classifies as information shocks",
  "and zeros out — and zero the days JK keeps as pure monetary. Aggregate",
  "monthly and recompute F. Reading: F(anti-JK) close to the random-mask",
  "mean indicates that JK selects the right subset of Copom days; F(anti-JK)",
  "comparable to the JK F would imply that JK only sparsifies and the sign",
  "criterion is not informative.",
  "",
  anti_md,
  "",
  "## T6 — F(k_keep) curve",
  "",
  "Random masks at varying k_keep separate two explanations for the JK F:",
  "(i) JK selects the k_JK ≈ 42 right days — F is high at k = k_JK and lower",
  "at other k; (ii) JK only sparsifies — F grows monotonically with sparsity",
  "for any random mask. The JK F observed (= F(z_het_jk + yield_6m)) is",
  "the dashed reference line in the plot.",
  "",
  "| k_keep | n_draws | mean | median | q95 | q99 | max | p(F_random ≥ JK) |",
  "|--------|---------|------|--------|-----|-----|-----|------------------|",
  curve_md,
  "",
  "Boxplot: `output/het_validation_f_curve.png`",
  "",
  "## Files",
  "",
  "- `output/het_validation_placebo.csv` — F across permutations",
  "- `output/het_validation_random_mask.csv` — F across random masks (k = JK)",
  "- `output/het_validation_subperiod.csv` — sub-period F table",
  "- `output/het_validation_correlation.csv` — Pearson / Spearman",
  "- `output/het_validation_anti_jk.csv` — single-row T5 summary",
  "- `output/het_validation_f_curve.csv` — per-draw F across k_keep grid",
  "- `output/het_validation_f_curve_summary.csv` — summary by k_keep",
  "- PNG: `het_validation_placebo.png`, `het_validation_random_mask.png`,",
  "  `het_validation_f_curve.png`"
), collapse = "\n")

writeLines(report, "output/het_validation_report.md")

# ---- Console summary --------------------------------------

cat("\n========== VALIDATION SUMMARY ==========\n")
cat(sprintf("Observed F (z_het_jk + %s): %.3f\n",
            TARGET_VAR, obs_fs$F_partial))
cat("\nT1 placebo:\n"); print(placebo_summary)
cat("\nT2 random mask:\n"); print(mask_summary)
cat("\nT3 sub-period:\n"); print(sub_results)
cat("\nT4 correlation:\n"); print(cor_results)
cat("\nT5 anti-JK:\n"); print(anti_summary)
cat("\nT6 F(k_keep) curve:\n"); print(curve_summary)
cat("\nReport: output/het_validation_report.md\n")
cat("========================================\n\n")
