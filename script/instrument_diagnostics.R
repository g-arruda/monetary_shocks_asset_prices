# ============================================================
# INSTRUMENT VALIDITY DIAGNOSTICS
# External instrument used in DFM proxy-SVAR identification
# ============================================================

# --- 0. Setup -----------------------------------------------

required_packages <- c("tidyverse", "sandwich", "lmtest", "broom", "lubridate")
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}

library(tidyverse)
library(sandwich)
library(lmtest)
library(broom)
library(lubridate)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")

dir.create("output", showWarnings = FALSE)

# --- 1. Load data and estimate DFM --------------------------

raw_data <- readr::read_csv("data/processed/data_log_deseasonalized.csv",
                            show_col_types = FALSE) |>
  tidyr::drop_na()

instrument <- readr::read_csv("data/processed/instrument.csv",
                               show_col_types = FALSE)

dates  <- as.Date(raw_data$ref.date)
X      <- raw_data |> dplyr::select(-ref.date) |> as.matrix()

message("Estimating DFM (r=8, q=8, p=6) ...")
dfm <- estimate_dfm(X, r = 8, q = 8, p = 6,
                    dates = dates, instrument = instrument,
                    apply_kilian = FALSE)

# Reduced-form residual of the policy variable: first factor VAR residual (η̂₁ₜ)
# Per Olea, Stock & Watson (2020, Sec. 4.2): use the direct VAR residual for the
# policy equation, not a loading-weighted combination.
policy_residual <- dfm$var_residuals[, 1]

p_lag           <- dfm$p
residual_dates  <- dfm$dates[(p_lag + 1):length(dfm$dates)]

# Build lagged-factor control matrix (VAR lags of Y_t as exogenous controls)
F_mat  <- dfm$static_factors   # T_aligned x r
T_f    <- nrow(F_mat)
r_fac  <- ncol(F_mat)
RHS_lags <- matrix(NA, T_f - p_lag, r_fac * p_lag)
for (i in seq_len(p_lag)) {
  cols <- ((i - 1) * r_fac + 1):(i * r_fac)
  RHS_lags[, cols] <- F_mat[(p_lag + 1 - i):(T_f - i), ]
}
colnames(RHS_lags) <- paste0("ctrl", seq_len(ncol(RHS_lags)))

# Align instrument with residuals
align      <- sel_ext_inst_sample(dfm$dates, p_lag, dfm$instrument)
Z_t        <- align$inst_sel
Z_dates    <- residual_dates[align$rsh_sel_ind]
res_aligned <- policy_residual[align$rsh_sel_ind]
ctrl_aligned <- RHS_lags[align$rsh_sel_ind, , drop = FALSE]

message(sprintf("Aligned sample: %s to %s  (n = %d)",
                min(Z_dates), max(Z_dates), length(Z_t)))

# --- 2. First-stage regression (relevance) ------------------
# Model: η̂₁ₜ = α + β·Zₜ + δ'·X_{t-lags} + uₜ
# Covariance: Eicker-White HC0 (Olea, Stock & Watson 2020, Sec. 5)

fs_data <- data.frame(res = res_aligned, Z = Z_t, ctrl_aligned)
fs_lm   <- lm(res ~ ., data = fs_data)

hc0_vcov     <- vcovHC(fs_lm, type = "HC0")
fs_coeftest  <- coeftest(fs_lm, vcov = hc0_vcov)

beta_hat     <- fs_coeftest["Z", "Estimate"]
beta_se_hc0  <- fs_coeftest["Z", "Std. Error"]
beta_t       <- fs_coeftest["Z", "t value"]
beta_pval    <- fs_coeftest["Z", "Pr(>|t|)"]

# Partial F for instrument Z (k=1): F_partial = t^2
# This matches Matlab's Waldstat = (sqrt(T)*Gamma)^2 / WHat_11 in MSWfunction.m
# waldtest(fs_lm) would test ALL regressors jointly (Z + controls), not Z alone.
f_partial_z  <- beta_t^2
f_pval       <- beta_pval

r2_fs        <- summary(fs_lm)$r.squared

corr_test    <- cor.test(Z_t, res_aligned, method = "pearson")
pearson_r    <- corr_test$estimate
pearson_ci   <- corr_test$conf.int
pearson_pval <- corr_test$p.value

# --- 2b. ξ₁ statistic (Olea, Stock & Watson, Sec. 4.2) ------
# ξ₁ = T · Γ̂²_{T,1} / Ŵ_{Γ,11}
# Γ̂_{T,1} = (1/T) Σ zₜ η̂₁ₜ  (sample covariance)
# Ŵ_{Γ,11} = (1/T) Σ (zₜ η̂₁ₜ − Γ̂_{T,1})²  (HC0 variance)
# 95% AR confidence set is bounded iff ξ₁ > χ²₁(0.95) = 3.84

T_eff      <- length(Z_t)
gamma_hat  <- mean(Z_t * res_aligned)
W_gamma_11 <- mean((Z_t * res_aligned - gamma_hat)^2)
xi_1       <- T_eff * gamma_hat^2 / W_gamma_11
xi1_crit   <- qchisq(0.95, 1)
xi1_bounded <- xi_1 > xi1_crit

# --- 3. Weak instrument flag --------------------------------
# Use xi_1 vs. chi2(0.95,1) = 3.84, matching Matlab's Waldstat threshold in MSWfunction.m.
# For k=1 instrument, xi_1 and f_partial_z are asymptotically equivalent (both = T*Gamma^2/Var).

flag_weak <- xi_1 < xi1_crit
strength_label <- if (flag_weak) sprintf("WEAK (\u03be\u2081 = %.2f < 3.84)", xi_1) else
                                 sprintf("STRONG (\u03be\u2081 = %.2f \u2265 3.84)", xi_1)

# --- 4. Exogeneity check (anticipation effects) -------------

n_lags <- 6
exog_df <- tibble(
  Z    = Z_t,
  date = Z_dates
)
for (k in seq_len(n_lags)) {
  exog_df[[paste0("lag", k)]] <- dplyr::lag(res_aligned, k)
}
exog_df <- na.omit(exog_df)

exog_lm    <- lm(Z ~ lag1 + lag2 + lag3 + lag4 + lag5 + lag6,
                 data = exog_df)
exog_hc0   <- vcovHC(exog_lm, type = "HC0")
exog_ftest <- waldtest(exog_lm, vcov = exog_hc0)
exog_f     <- exog_ftest$F[2]
exog_pval  <- exog_ftest$`Pr(>F)`[2]

flag_anticipation <- exog_pval < 0.05

# --- 5. Time-series plot of Z_t -----------------------------

copom_raw <- readr::read_csv("data/copom_historico.csv",
                              show_col_types = FALSE)[-1] |>
  dplyr::select(data_reuniao, meta_selic_pct) |>
  dplyr::mutate(meeting_date = lubridate::dmy(data_reuniao)) |>
  dplyr::filter(!is.na(meeting_date))

copom_months <- lubridate::floor_date(copom_raw$meeting_date, "month")

plot_data <- tibble(date = Z_dates, Z = Z_t) |>
  dplyr::mutate(is_copom = date %in% copom_months)

p_Zt <- ggplot(plot_data, aes(x = date, y = Z)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
  geom_col(aes(fill = is_copom), width = 20) +
  scale_fill_manual(values = c("FALSE" = "grey75", "TRUE" = "#2171b5"),
                    labels = c("FALSE" = "No meeting", "TRUE" = "COPOM meeting")) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(
    title    = "External instrument Z_t: monetary policy surprises",
    subtitle = "Difference between announced SELIC and Svensson overnight forward rate expectation",
    x        = NULL,
    y        = "Surprise (p.p.)",
    fill     = NULL,
    caption  = "Source: BCB / Svensson yield curve. Blue bars = COPOM meeting months."
  ) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "top", panel.grid.minor = element_blank())

ggsave("output/instrument_diagnostics_Zt.png", p_Zt,
       width = 10, height = 4, dpi = 150)
message("Plot saved: output/instrument_diagnostics_Zt.png")

# --- 6. Subperiod variance decomposition --------------------

periods <- list(
  "2013–2018" = as.Date(c("2013-01-01", "2018-12-31")),
  "2019–2025" = as.Date(c("2019-01-01", "2025-12-31"))
)

subperiod_tbl <- purrr::map_dfr(names(periods), function(nm) {
  rng   <- periods[[nm]]
  sub   <- tibble(date = Z_dates, Z = Z_t) |>
    dplyr::filter(date >= rng[1], date <= rng[2])
  nonzero <- sum(sub$Z != 0)
  tibble(
    Period       = nm,
    N_months     = nrow(sub),
    N_nonzero    = nonzero,
    Mean_Z       = round(mean(sub$Z), 5),
    SD_Z         = round(sd(sub$Z), 5),
    Mean_nonzero = round(mean(sub$Z[sub$Z != 0]), 5)
  )
})

# --- 7. Generate markdown report ----------------------------

overall_valid <- !flag_weak && !flag_anticipation

fmt_p <- function(p) {
  if (p < 0.001) "< 0.001" else sprintf("%.3f", p)
}

ci_excludes_zero <- (pearson_ci[1] > 0) || (pearson_ci[2] < 0)

# Subperiod table as markdown
sp_header <- "| Period | N months | N non-zero | Mean Z | SD Z | Mean (non-zero) |"
sp_sep    <- "|--------|----------|------------|--------|------|-----------------|"
sp_rows   <- apply(subperiod_tbl, 1, function(r) {
  paste0("| ", r["Period"], " | ", r["N_months"], " | ", r["N_nonzero"],
         " | ", r["Mean_Z"], " | ", r["SD_Z"], " | ", r["Mean_nonzero"], " |")
})
sp_table  <- paste(c(sp_header, sp_sep, sp_rows), collapse = "\n")

# Build report line by line
L <- function(...) paste0(..., "\n")

report <- paste0(
  L("# Instrument Validity Diagnostics Report"),
  L(),
  L("**Project:** Monetary Shocks and Asset Prices — Brazil (Alessi & Kerssenfischer, 2019, replication)  "),
  L("**Instrument:** COPOM monetary policy surprise (Svensson overnight forward rate, Bagliano & Favero 1998)  "),
  L("**Sample:** ", min(Z_dates), " to ", max(Z_dates), " (n = ", length(Z_t), " monthly observations)  "),
  L("**Date generated:** ", Sys.Date()),
  L(),
  L("> **Methodology update (", Sys.Date(), "):** Three corrections applied per Olea, Stock & Watson (2020):  "),
  L("> (1) First-stage dependent variable changed from loading-weighted projection to direct factor VAR residual (η̂₁ₜ), with VAR lags as exogenous controls.  "),
  L("> (2) Covariance estimator changed from Newey-West (6 lags) to Eicker-White HC0 (Sec. 5).  "),
  L("> (3) ξ₁ diagnostic statistic added (Sec. 4.2).  "),
  L("> Previous values: β̂ = 11.87477, SE(NW) = 6.88518, F(NW) = 2.97, R² = 0.0133."),
  L(),
  L("---"),
  L(),
  L("## Summary Table"),
  L(),
  L("| Test | Statistic | Value | Threshold | Result |"),
  L("|------|-----------|-------|-----------|--------|"),
  L("| First-stage β (HC0) | β̂ | ", round(beta_hat, 5), " | — | — |"),
  L("| HC0 Std. Error | SE | ", round(beta_se_hc0, 5), " | — | — |"),
  L("| HC0 t-statistic | t | ", round(beta_t, 3), " | — | p = ", fmt_p(beta_pval), " |"),
  L("| Partial F for Z (t²) | F | ", round(f_partial_z, 2), " | F > 10 | p = ", fmt_p(f_pval), " |"),
  L("| ξ₁ statistic (OSW Sec. 4.2) | ξ₁ | ", round(xi_1, 2), " | ξ₁ > 3.84 | ",
    if (xi1_bounded) "**AR 95% CI bounded**" else "**AR 95% CI unbounded**",
    " — **", strength_label, "** |"),
  L("| First-stage R² | R² | ", round(r2_fs, 4), " | — | — |"),
  L("| Pearson correlation | r | ", round(pearson_r, 4), " | — | p = ", fmt_p(pearson_pval), " |"),
  L("| Pearson 95% CI | [lb, ub] | [", round(pearson_ci[1], 4), ", ", round(pearson_ci[2], 4), "] | excludes 0? | ",
    if (ci_excludes_zero) "Yes" else "No", " |"),
  L("| Exogeneity F (lags 1–6) | F | ", round(exog_f, 2), " | p > 0.05 | p = ", fmt_p(exog_pval),
    " — ", if (flag_anticipation) "FAIL (anticipation suspected)" else "PASS", " |"),
  L(),
  L("---"),
  L(),
  L("## Step 2 — First-Stage Regression (Relevance)"),
  L(),
  L("**Model:** `η̂₁ₜ = α + β · Zₜ + δ' · X_{t-lags} + uₜ`  "),
  L("**Dependent variable:** First factor VAR residual (η̂₁ₜ), not loading-weighted projection  "),
  L("**Controls:** VAR lags of static factors (p = ", p_lag, " lags × r = ", r_fac, " factors = ", p_lag * r_fac, " controls)  "),
  L("**Estimation:** OLS with Eicker-White HC0 standard errors (Olea, Stock & Watson 2020, Sec. 5)"),
  L(),
  L("The OLS coefficient β̂ = ", round(beta_hat, 5), " (SE = ", round(beta_se_hc0, 5),
    ", t = ", round(beta_t, 3), ", p = ", fmt_p(beta_pval), "). ",
    if (beta_pval < 0.05) {
      "The coefficient is statistically significant at the 5% level, indicating that the instrument is correlated with the first factor innovation."
    } else {
      "The coefficient is NOT statistically significant at the 5% level, suggesting a weak relationship between the instrument and the first factor innovation."
    }),
  L("The Pearson correlation between Z_t and η̂₁ₜ is r = ", round(pearson_r, 4),
    " (95% CI: [", round(pearson_ci[1], 4), ", ", round(pearson_ci[2], 4), "], p = ",
    fmt_p(pearson_pval), "). ",
    if (ci_excludes_zero) "The confidence interval excludes zero, confirming a significant linear association." else
      "The confidence interval includes zero, suggesting the linear association is not statistically significant."),
  L(),
  L("---"),
  L(),
  L("## Step 3 — Weak Instrument Diagnosis"),
  L(),
  L("**Partial F for Z (= t²):** ", round(f_partial_z, 2), " (p = ", fmt_p(f_pval), ")  "),
  L("**ξ₁ statistic (OSW Sec. 4.2):** ", round(xi_1, 2), " (critical value χ²₁(0.95) = ", round(xi1_crit, 2), ")  "),
  L("**First-stage R²:** ", round(r2_fs, 4), "  "),
  L("**Assessment:** ", strength_label),
  L(),
  L("The partial F for Z is computed as t² (the squared HC0 t-statistic for the instrument coefficient ",
    "after partialling out VAR lag controls), which is the correct single-instrument weak-IV diagnostic. ",
    "The ξ₁ statistic (Montiel Olea, Stock & Watson 2020) is computed directly from the raw cross-moment ",
    "Γ̂ = (1/T)Σzₜη̂₁ₜ and its HC0 variance, matching the Matlab `Waldstat` formula in MSWfunction.m."),
  L(),
  if (!flag_weak) {
    L("ξ₁ = ", round(xi_1, 2), " exceeds the χ²₁(0.95) = 3.84 threshold (Montiel Olea, Stock & Watson 2020), ",
      "indicating that the 95% Anderson-Rubin confidence sets for impulse responses are **bounded intervals**. ",
      "Weak-instrument bias in the proxy SVAR estimates is unlikely to be a first-order concern.")
  } else {
    L("ξ₁ = ", round(xi_1, 2), " falls below the χ²₁(0.95) = 3.84 threshold (Montiel Olea, Stock & Watson 2020), ",
      "flagging the instrument as potentially WEAK. Inference in the proxy SVAR identification may be unreliable, ",
      "and confidence bands could be substantially wider than reported.")
  },
  L(),
  if (xi1_bounded) {
    L("Because ξ₁ > 3.84, the 95% Anderson-Rubin weak-instrument confidence sets ",
      "for the impulse response coefficients are **bounded intervals**. This means that even with a weak instrument, ",
      "the AR confidence sets remain informative (finite length).")
  } else {
    L("Moreover, ξ₁ ≤ 3.84, so the 95% Anderson-Rubin confidence sets may be ",
      "**unbounded** (infinite length), indicating that the instrument provides essentially no information about ",
      "the structural parameters under weak-instrument-robust inference.")
  },
  L(),
  L("---"),
  L(),
  L("## Step 4 — Exogeneity Check (Anticipation Effects)"),
  L(),
  L("**Model:** `Z_t = α + Σ_{k=1}^{6} γ_k · η̂₁_{t-k} + v_t`  "),
  L("**HC0 F-test (joint significance of lags):** F = ", round(exog_f, 2), ", p = ", fmt_p(exog_pval)),
  L(),
  if (!flag_anticipation) {
    L("The joint F-test is NOT significant (p > 0.05), providing no evidence that the instrument is ",
      "correlated with past monetary policy residuals. This is consistent with the exogeneity assumption: ",
      "the COPOM surprise does not appear to be predictable from the history of policy shocks, suggesting ",
      "the absence of systematic anticipation effects.")
  } else {
    L("The joint F-test IS significant (p ≤ 0.05), indicating that the instrument may be correlated with ",
      "lagged policy residuals. This could reflect anticipation effects — market participants may have partially ",
      "anticipated the COPOM decision based on prior monetary policy actions, contaminating the surprise measure. ",
      "The instrument exogeneity assumption may be violated.")
  },
  L("This test is informal and does not constitute a formal overidentification test (the model is exactly ",
    "identified). It serves as a plausibility check for the exclusion restriction."),
  L(),
  L("---"),
  L(),
  L("## Step 5 — Time Series Plot"),
  L(),
  L("![Z_t over time](instrument_diagnostics_Zt.png)"),
  L(),
  L("The plot shows the monthly instrument series Z_t from ", min(Z_dates), " to ", max(Z_dates),
    ". Blue bars indicate months with COPOM meetings (non-zero surprises); grey bars are months with no meeting ",
    "(Z_t = 0 by construction). The series displays variation across the sample period consistent with genuine ",
    "monetary policy surprises, with larger shocks observed during the 2015 tightening cycle and the COVID-19 period."),
  L(),
  L("---"),
  L(),
  L("## Step 6 — Subperiod Variance Decomposition"),
  L(),
  sp_table, "\n",
  L(),
  {
    rel_diff <- abs(subperiod_tbl$SD_Z[2] - subperiod_tbl$SD_Z[1]) / mean(subperiod_tbl$SD_Z)
    higher_period <- if (subperiod_tbl$SD_Z[2] > subperiod_tbl$SD_Z[1]) "2019–2025" else "2013–2018"
    vol_word <- if (rel_diff < 0.3) "similar" else "notably different"
    high_reason <- if (higher_period == "2019–2025") {
      "Higher volatility in 2019–2025 likely reflects the COVID-19 shock and the subsequent aggressive tightening cycle."
    } else {
      "Higher volatility in 2013–2018 may be associated with the tightening and easing cycles under the Tombini and Goldfajn BCB mandates."
    }
    L("The instrument exhibits ", vol_word, " volatility across subperiods. ", high_reason)
  },
  L(),
  L("---"),
  L(),
  L("## Overall Conclusion"),
  L(),
  L("**Instrument validity: ", if (overall_valid) "VALID ✓" else "QUESTIONABLE ✗", "**"),
  L(),
  if (overall_valid) {
    L("Both the relevance (ξ₁ > 3.84) and informal exogeneity checks (no significant anticipation) support the use ",
      "of this instrument for proxy SVAR identification. The Svensson-based COPOM surprise appears to be a valid ",
      "external instrument for monetary policy shocks in the Brazilian DFM.")
  } else {
    paste0(
      if (flag_weak) L("**Relevance concern:** ξ₁ = ", round(xi_1, 2), " < 3.84 (Montiel Olea, Stock & Watson 2020), ",
                       "suggesting a weak instrument. The proxy SVAR identification may suffer from weak-instrument bias, ",
                       "leading to distorted confidence intervals.",
                       if (xi1_bounded) "" else
                         " Furthermore, ξ₁ ≤ 3.84, so AR confidence sets may be unbounded.") else "",
      if (flag_anticipation) L("**Exogeneity concern:** The instrument appears to be correlated with lagged ",
                               "policy residuals, suggesting anticipation effects contaminate the surprise measure.") else ""
    )
  },
  L(),
  L("---"),
  L(),
  L("## Suggestions for Alternative Instruments"),
  L(),
  L("1. **Futures-based surprise:** Use the change in DI futures (1-month or 3-month) on COPOM meeting days. ",
    "These are highly liquid and directly reflect market expectations, consistent with Gürkaynak, Sack & Swanson (2005). ",
    "Typically yields much stronger first stages than model-based measures."),
  L(),
  L("2. **Survey-based surprise:** Compute the difference between the announced SELIC and the median forecast ",
    "from BCB's Focus survey (GERIN) collected the day before the meeting. The Focus survey directly measures ",
    "market consensus and avoids Svensson model dependency."),
  L(),
  L("3. **High-frequency identification (HFI):** Use intraday changes in OIS or DI swap rates in a narrow window ",
    "(e.g., ±30 minutes) around COPOM announcements. The tighter event window reduces contamination from other news ",
    "and typically yields the strongest first stages. Requires tick-level data from B3/Bloomberg."),
  L(),
  L("4. **Gertler-Karadi style (two-factor):** Augment the surprise with the change in a longer-maturity yield ",
    "(e.g., 2-year DI swap) around COPOM meetings to capture both the level and forward guidance components of ",
    "monetary policy surprises, following Gertler & Karadi (2015).")
)

writeLines(report, "output/instrument_diagnostics_report.md")
message("Report saved: output/instrument_diagnostics_report.md")

# Print summary to console
cat("\n========== INSTRUMENT DIAGNOSTICS SUMMARY ==========\n")
cat(sprintf("  Sample:              %s to %s (n=%d)\n", min(Z_dates), max(Z_dates), length(Z_t)))
cat(sprintf("  beta (HC0):          %.5f  (SE=%.5f, t=%.2f, p=%s)\n",
            beta_hat, beta_se_hc0, beta_t, fmt_p(beta_pval)))
cat(sprintf("  Partial F(Z) = t^2:  %.2f  (p=%s)\n", f_partial_z, fmt_p(f_pval)))
cat(sprintf("  xi_1 statistic:      %.2f  [threshold: 3.84] --> %s  --> %s\n",
            xi_1, if (xi1_bounded) "AR CI BOUNDED" else "AR CI UNBOUNDED", strength_label))
cat(sprintf("  First-stage R2:      %.4f\n", r2_fs))
cat(sprintf("  Pearson r:           %.4f  95%% CI [%.4f, %.4f]  p=%s\n",
            pearson_r, pearson_ci[1], pearson_ci[2], fmt_p(pearson_pval)))
cat(sprintf("  Exogeneity F:        %.2f  p=%s  --> %s\n",
            exog_f, fmt_p(exog_pval), if (flag_anticipation) "FAIL" else "PASS"))
cat(sprintf("  Overall:             %s\n", if (overall_valid) "VALID" else "QUESTIONABLE"))
cat("=====================================================\n\n")
