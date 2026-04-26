# ============================================================
# Instrument validity diagnostics — compares 4 instrument variants
# (bruto, bruto_purif, JK, JK_purif) on the same DFM residual.
# Also: scatterplot of residual DI vs. residual Ibov on Copom days,
# and variance F-test (Copom vs. non-Copom).
# ============================================================

suppressPackageStartupMessages({
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
})

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")

dir.create("output", showWarnings = FALSE)

# ---- 1. DFM estimation (instrument-agnostic) ---------------

raw_data <- read_csv("data/processed/data_log_deseasonalized.csv",
                     show_col_types = FALSE) |> drop_na()

dates  <- as.Date(raw_data$ref.date)
X      <- raw_data |> select(-ref.date) |> as.matrix()

message("Estimating DFM (r=8, q=8, p=6) ...")
# We need any instrument df just so estimate_dfm() builds the VAR; use the bruto.
seed_inst <- read_csv("data/processed/instrument_bruto.csv", show_col_types = FALSE)
dfm <- estimate_dfm(X, r = 8, q = 8, p = 6,
                    dates = dates, instrument = seed_inst,
                    apply_kilian = FALSE)

policy_residual <- dfm$var_residuals[, 1]
p_lag           <- dfm$p
residual_dates  <- dfm$dates[(p_lag + 1):length(dfm$dates)]

F_mat <- dfm$static_factors
T_f   <- nrow(F_mat)
r_fac <- ncol(F_mat)
RHS_lags <- matrix(NA, T_f - p_lag, r_fac * p_lag)
for (i in seq_len(p_lag)) {
  cols <- ((i - 1) * r_fac + 1):(i * r_fac)
  RHS_lags[, cols] <- F_mat[(p_lag + 1 - i):(T_f - i), ]
}
colnames(RHS_lags) <- paste0("ctrl", seq_len(ncol(RHS_lags)))

# ---- 2. Diagnostics per variant ----------------------------

variants <- list(
  "z_bruto"        = "data/processed/instrument_bruto.csv",
  "z_bruto_purif"  = "data/processed/instrument_bruto_purif.csv",
  "z_jk"           = "data/processed/instrument_jk.csv",
  "z_jk_purif"     = "data/processed/instrument_jk_purif.csv",
  "z_het"          = "data/processed/instrument_z_het.csv",
  "z_het_jk"       = "data/processed/instrument_z_het_jk.csv"
)
variants <- variants[file.exists(unlist(variants))]

fmt_p <- function(p) if (is.na(p)) "NA" else if (p < 0.001) "< 0.001" else sprintf("%.3f", p)

run_variant <- function(name, path) {
  inst_df <- read_csv(path, show_col_types = FALSE)
  align   <- sel_ext_inst_sample(dfm$dates, p_lag, inst_df)
  Z_t     <- align$inst_sel
  res_al  <- policy_residual[align$rsh_sel_ind]
  ctrl_al <- RHS_lags[align$rsh_sel_ind, , drop = FALSE]

  fs <- lm(res ~ ., data = data.frame(res = res_al, Z = Z_t, ctrl_al))
  ct <- coeftest(fs, vcov = vcovHC(fs, type = "HC0"))
  beta   <- ct["Z", "Estimate"]
  se     <- ct["Z", "Std. Error"]
  tval   <- ct["Z", "t value"]
  pval   <- ct["Z", "Pr(>|t|)"]
  f_part <- tval^2
  r2     <- summary(fs)$r.squared

  T_eff   <- length(Z_t)
  gamma   <- mean(Z_t * res_al)
  W11     <- mean((Z_t * res_al - gamma)^2)
  xi1     <- T_eff * gamma^2 / W11

  n_lags <- 6
  ex_df <- tibble(Z = Z_t)
  for (k in seq_len(n_lags)) ex_df[[paste0("lag", k)]] <- dplyr::lag(res_al, k)
  ex_df <- na.omit(ex_df)
  ex_lm <- lm(Z ~ ., data = ex_df)
  ex_vc <- vcovHC(ex_lm, type = "HC0")
  ex_wf <- waldtest(ex_lm, vcov = ex_vc)
  exog_f  <- ex_wf$F[2]
  exog_pv <- ex_wf$`Pr(>F)`[2]

  tibble(
    variant   = name,
    n         = T_eff,
    nonzero   = sum(Z_t != 0),
    beta      = beta,
    se_hc0    = se,
    t_stat    = tval,
    p_value   = pval,
    f_partial = f_part,
    xi1       = xi1,
    r2_fs     = r2,
    exog_f    = exog_f,
    exog_p    = exog_pv
  )
}

results <- map2_dfr(names(variants), variants, run_variant)

print(results |> mutate(across(where(is.numeric), ~ round(.x, 3))))

# ---- 3. Scatterplot of residual DI vs residual Ibov --------

diag_path <- "data/processed/copom_event_diagnostics.csv"
if (file.exists(diag_path)) {
  diag <- read_csv(diag_path, show_col_types = FALSE)
  copom_pts <- diag |> filter(copom_day)

  quad <- copom_pts |>
    mutate(quadrant = case_when(
      e_di > 0 & e_ibov > 0 ~ "I (+,+) info",
      e_di < 0 & e_ibov > 0 ~ "II (-,+) monetary",
      e_di < 0 & e_ibov < 0 ~ "III (-,-) info",
      e_di > 0 & e_ibov < 0 ~ "IV (+,-) monetary",
      TRUE ~ "zero"
    ))
  pct_wrong <- round(100 *
    sum(quad$quadrant %in% c("I (+,+) info", "III (-,-) info")) /
    nrow(quad), 1)

  p_scatter <- ggplot(quad, aes(x = e_di, y = e_ibov)) +
    geom_vline(xintercept = 0, linewidth = 0.3, colour = "grey50") +
    geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
    geom_point(aes(colour = quadrant), alpha = 0.8) +
    scale_colour_manual(values = c(
      "I (+,+) info" = "#d95f02", "II (-,+) monetary" = "#1b9e77",
      "III (-,-) info" = "#d95f02", "IV (+,-) monetary" = "#1b9e77",
      "zero" = "grey70"
    )) +
    labs(
      title    = "Purified surprises on Copom days",
      subtitle = sprintf("Wrong-signed (info) share: %.1f%%  (n = %d)", pct_wrong, nrow(quad)),
      x = "e_DI (residual, bps)",
      y = "e_Ibov (residual, log-return %)",
      colour = NULL
    ) +
    theme_minimal(base_size = 11) +
    theme(legend.position = "bottom")
  ggsave("output/scatterplot_surpresas_copom.png", p_scatter,
         width = 7, height = 6, dpi = 150)
  message(sprintf("Scatterplot saved. Wrong-signed share: %.1f%%", pct_wrong))
} else {
  pct_wrong <- NA_real_
  message("Event diagnostics file missing, skipping scatterplot.")
}

# ---- 4. Variance F-test: Copom vs. non-Copom ----------------

var_test_row <- function(x, copom_flag, label) {
  v_copom     <- var(x[copom_flag])
  v_non_copom <- var(x[!copom_flag])
  n1 <- sum(copom_flag); n2 <- sum(!copom_flag)
  F_stat <- v_copom / v_non_copom
  # two-sided p-value under F(n1-1, n2-1)
  p_val <- 2 * min(
    pf(F_stat, n1 - 1, n2 - 1),
    1 - pf(F_stat, n1 - 1, n2 - 1)
  )
  tibble(series = label,
         var_copom = v_copom, var_non_copom = v_non_copom,
         n_copom = n1, n_non_copom = n2,
         F_stat = F_stat, p_value = p_val)
}

if (exists("diag")) {
  var_tests <- bind_rows(
    var_test_row(diag$e_di,   diag$copom_day, "e_DI"),
    var_test_row(diag$e_ibov, diag$copom_day, "e_Ibov"),
    var_test_row(diag$delta_di, diag$copom_day, "delta_DI (raw)"),
    var_test_row(diag$r_ibov,   diag$copom_day, "delta_Ibov (raw)")
  )
  print(var_tests |> mutate(across(where(is.numeric), ~ signif(.x, 3))))
} else {
  var_tests <- NULL
}

# ---- 5. Heteroskedasticity-identification diagnostics -------
# Reads the artifacts produced by script/instrument_het.R. If any are missing,
# the corresponding section is skipped in the report.

het_val_path <- "output/het_variance_validation.csv"
het_eig_path <- "output/het_eigenvalues.csv"
het_b1_path  <- "output/het_b_1.csv"

het_val <- if (file.exists(het_val_path)) read_csv(het_val_path, show_col_types = FALSE) else NULL
het_eig <- if (file.exists(het_eig_path)) read_csv(het_eig_path, show_col_types = FALSE) else NULL
het_b1  <- if (file.exists(het_b1_path))  read_csv(het_b1_path,  show_col_types = FALSE) else NULL

if (!is.null(het_eig)) {
  het_eig <- het_eig |>
    mutate(label = ifelse(is.na(variable),
                          paste0("eig_", rank),
                          paste0(variable, " (#", rank, ")")))

  abs_lambda_sorted <- sort(abs(het_eig$lambda), decreasing = TRUE)
  rank1_share <- abs_lambda_sorted[1] / sum(abs_lambda_sorted)
  eig_gap     <- abs_lambda_sorted[1] / abs_lambda_sorted[2]

  p_eig <- ggplot(het_eig, aes(x = reorder(label, -rank), y = lambda)) +
    geom_col(fill = "#1f77b4") +
    geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
    coord_flip() +
    labs(title = "Eigenvalues of dSigma = Sigma_C - Sigma_NC",
         subtitle = sprintf("rank-1 share = %.2f, eigenvalue gap = %.2f",
                            rank1_share, eig_gap),
         x = NULL, y = "lambda") +
    theme_minimal(base_size = 11)
  ggsave("output/het_eigenvalues.png", p_eig, width = 7, height = 4, dpi = 150)
}

# ---- 6. Report ---------------------------------------------

res_tbl <- results |>
  mutate(across(c(beta, se_hc0, t_stat, f_partial, xi1, r2_fs, exog_f),
                ~ sprintf("%.3f", .x)),
         p_value = map_chr(p_value, fmt_p),
         exog_p  = map_chr(exog_p,  fmt_p),
         weak_flag = ifelse(as.numeric(xi1) < 3.84, "WEAK", "OK"))

hdr <- "| Variant | n | nonzero | β̂ | SE(HC0) | t | p | Partial F | ξ₁ | R² | Exog F | Exog p | Flag |"
sep <- "|---|---|---|---|---|---|---|---|---|---|---|---|---|"
rows <- apply(res_tbl, 1, function(r)
  sprintf("| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |",
          r["variant"], r["n"], r["nonzero"], r["beta"], r["se_hc0"],
          r["t_stat"], r["p_value"], r["f_partial"], r["xi1"], r["r2_fs"],
          r["exog_f"], r["exog_p"], r["weak_flag"]))
tbl_md <- paste(c(hdr, sep, rows), collapse = "\n")

var_md <- if (!is.null(var_tests)) {
  v <- var_tests |>
    mutate(across(where(is.numeric), ~ signif(.x, 3)))
  paste(c(
    "| Series | Var(Copom) | Var(non-Copom) | n_C | n_NC | F | p-value |",
    "|---|---|---|---|---|---|---|",
    apply(v, 1, function(r)
      sprintf("| %s | %s | %s | %s | %s | %s | %s |",
              r["series"], r["var_copom"], r["var_non_copom"],
              r["n_copom"], r["n_non_copom"], r["F_stat"], r["p_value"]))
  ), collapse = "\n")
} else {
  "_(event diagnostics not available)_"
}

het_val_md <- if (!is.null(het_val)) {
  v <- het_val |> mutate(across(where(is.numeric), ~ signif(.x, 3)))
  paste(c(
    "| Variable | n_C | n_NC | Var(C) | Var(NC) | Ratio | CI 99% low | CI 99% high |",
    "|---|---|---|---|---|---|---|---|",
    apply(v, 1, function(r)
      sprintf("| %s | %s | %s | %s | %s | %s | %s | %s |",
              r["var"], r["n_C"], r["n_NC"], r["var_C"], r["var_NC"],
              r["ratio"], r["ci_low"], r["ci_high"]))
  ), collapse = "\n")
} else {
  "_(run script/instrument_het.R to populate this section)_"
}

het_eig_md <- if (!is.null(het_eig)) {
  v <- het_eig |>
    mutate(lambda    = signif(lambda, 3),
           abs_share = signif(abs_share, 3))
  paste(c(
    "| Rank | Variable (heuristic) | Lambda | |Lambda|/Sum(|Lambda|) |",
    "|---|---|---|---|",
    apply(v, 1, function(r)
      sprintf("| %s | %s | %s | %s |",
              r["rank"],
              ifelse(is.na(r["variable"]), "-", r["variable"]),
              r["lambda"], r["abs_share"]))
  ), collapse = "\n")
} else {
  "_(run script/instrument_het.R to populate this section)_"
}

het_b1_md <- if (!is.null(het_b1)) {
  v <- het_b1 |> mutate(b_1 = signif(b_1, 4))
  paste(c(
    "| Variable | Impact (b_1) |",
    "|---|---|",
    apply(v, 1, function(r) sprintf("| %s | %s |", r["variable"], r["b_1"]))
  ), collapse = "\n")
} else {
  "_(run script/instrument_het.R to populate this section)_"
}

report <- paste(
  "# Instrument Validity Diagnostics Report",
  "",
  sprintf("**Date generated:** %s  ", Sys.Date()),
  sprintf("**DFM sample:** %s to %s  ", min(dfm$dates), max(dfm$dates)),
  "**Identification:** proxy-SVAR with external instrument (Olea, Stock & Watson 2020).",
  "**Instrument variants:** raw Copom-day ΔDI (3m), purified by global factors (SP500, VIX, Brent),",
  "Jarociński-Karadi sign filter, and JK + purified.",
  "",
  "---",
  "",
  "## 1. First-stage comparison across variants",
  "",
  "First-stage model: `η̂₁ₜ = α + β·Zₜ + δ'·lags(F) + uₜ` with HC0 SE.  ",
  "Partial F for Z = t². ξ₁ follows Olea, Stock & Watson (Sec. 4.2); threshold = 3.84.",
  "",
  tbl_md,
  "",
  "---",
  "",
  "## 2. Scatterplot — purified surprises on Copom days",
  "",
  if (!is.na(pct_wrong)) sprintf("Wrong-signed (information) share: **%.1f%%**.", pct_wrong) else "_(not computed)_",
  "",
  "![scatter](scatterplot_surpresas_copom.png)",
  "",
  "Quadrants II & IV (green, negative co-movement) are classified as monetary shocks and kept in z_JK / z_JK_purif.  ",
  "Quadrants I & III (orange, positive co-movement) are classified as information shocks and zeroed out.",
  "",
  "---",
  "",
  "## 3. Variance F-test: Copom vs. non-Copom Thursdays",
  "",
  "H0: equal variance.  Expect rejection for `e_DI` (news shock on Copom days), ideally NOT for `e_Ibov`.",
  "",
  var_md,
  "",
  "---",
  "",
  "## 4. Heteroskedasticity-identification (z_het)",
  "",
  "### 4.1 GRG (2025) Table 1 — variance split between Copom (C) and non-Copom (NC) Wed→Thu pairs",
  "",
  "Hypothesis A1 (policy shock variance shifts) requires the ratio for the policy variable to exclude 1 from above.  ",
  "Hypothesis A2 (other shock variances stable) requires the remaining variables' CIs to include 1.",
  "",
  het_val_md,
  "",
  "### 4.2 Eigenvalue spectrum of dSigma = Sigma_C - Sigma_NC",
  "",
  "Under the rank-1 hypothesis (Rigobon-Sack 2003 §III), only one eigenvalue is non-zero.  ",
  "Gate: leading eigenvalue should account for > 60% of |sum| of eigenvalues.",
  "",
  het_eig_md,
  "",
  if (file.exists("output/het_eigenvalues.png")) "![eigenvalues](het_eigenvalues.png)" else "_(plot not generated)_",
  "",
  "### 4.3 Impact column b_1 (sign normalized so b_1[DI_3m] > 0)",
  "",
  het_b1_md,
  "",
  "---",
  "",
  "## 5. Interpretation",
  "",
  "- **F > 10 / ξ₁ > 10**: inference standard OK.  ",
  "- **F ∈ [5, 10]**: use Anderson-Rubin robust intervals.  ",
  "- **ξ₁ < 3.84**: instrument flagged as weak; AR CIs possibly unbounded.  ",
  "- Compare z_bruto vs. z_JK to assess whether the JK filter changes identification, and vs. their `_purif` counterparts for the role of global-factor contamination.",
  "- **z_het** is identified by heteroskedasticity (Rigobon-Sack 2003 QJE) on the daily SVAR and is independent of the timing assumption that underlies the four GK-style variants. Convergence of `z_het` results with `z_jk_purif` is the central robustness check.",
  sep = "\n"
)

writeLines(report, "output/instrument_diagnostics_report.md")
message("Report written to output/instrument_diagnostics_report.md")

cat("\n========== VARIANT COMPARISON ==========\n")
print(results |> mutate(across(where(is.numeric), ~ round(.x, 3))))
cat("========================================\n\n")
