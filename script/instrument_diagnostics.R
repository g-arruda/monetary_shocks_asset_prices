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
source("R/identification/validation_tests.R")
source("R/identification/factor_space_diagnostics.R")

dir.create("output/instrument", showWarnings = FALSE, recursive = TRUE)

# yield_6m AR(6) innovation: alternative first-stage target. The DFM-factor F
# (used by run_variant) is the Olea-Stock-Watson partial F that governs weak-
# instrument bias inside the proxy-SVAR; the yield_6m AR-innovation F measures
# relevance for the Selic-equivalent interpretation of the shock (audit
# 2026-04-25). Reporting both, side by side, addresses pendencias.md Crit. 3.

YIELD6M_TARGET     <- "yield_6m"
YIELD6M_AR_LAGS    <- 6L
YIELD6M_SAMPLE_MIN <- as.Date("2013-01-01")
YIELD6M_SAMPLE_MAX <- as.Date("2025-12-31")

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

# Index of yield_6m in the panel — used by diagnose_instrument_in_factor_space
# to read the impact response per variant in policy-variable native units.
mp_idx_diag <- match(YIELD6M_TARGET, colnames(X))

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
  "z_jk_raw_purif" = "data/processed/instrument_jk_raw_purif.csv",
  "z_jk_raw"       = "data/processed/instrument_jk_raw.csv",
  "z_bs_purif"     = "data/processed/instrument_bs_purif.csv",
  "z_jk_bs_purif"  = "data/processed/instrument_jk_bs_purif.csv",
  "z_jk_purif_us"  = "data/processed/instrument_jk_purif_us.csv",
  "z_het"          = "data/processed/instrument_z_het.csv",
  "z_het_jk"       = "data/processed/instrument_z_het_jk.csv",
  "z_het_3var"     = "data/processed/instrument_z_het_3var.csv",
  "z_het_jk_3var"  = "data/processed/instrument_z_het_jk_3var.csv"
)
variants <- variants[file.exists(unlist(variants))]

# yield_6m AR(6) innovation: shared across variants. residualize_target keeps
# residual length equal to input via na.exclude, so positional alignment with
# the instrument (joined on month) is valid.
y6m_raw <- read_csv("data/raw_data.csv", show_col_types = FALSE) |>
  mutate(ref.date = as.Date(ref.date)) |>
  filter(ref.date >= YIELD6M_SAMPLE_MIN, ref.date <= YIELD6M_SAMPLE_MAX) |>
  arrange(ref.date)
y6m_dates <- y6m_raw$ref.date
y6m_innov <- residualize_target(y6m_raw[[YIELD6M_TARGET]],
                                n_lags = YIELD6M_AR_LAGS)

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

  # xi1 with the MOSW Shat correction (CovAhat_Sigmahat_Gamma.m): the
  # asymptotic variance of Gamma-hat propagates the VAR estimation error,
  # which algebraically amounts to residualizing Z on the VAR regressors
  # (factor lags + constant) before forming the moment products. Gamma-hat
  # itself is unchanged in-sample (residuals are orthogonal to regressors).
  Z_resid  <- as.numeric(residuals(lm(Z_t ~ ctrl_al)))
  gamma_m  <- mean(Z_resid * res_al)
  W11_m    <- mean((Z_resid * res_al - gamma_m)^2)
  xi1_mosw <- T_eff * gamma_m^2 / W11_m

  n_lags <- 6
  ex_df <- tibble(Z = Z_t)
  for (k in seq_len(n_lags)) ex_df[[paste0("lag", k)]] <- dplyr::lag(res_al, k)
  ex_df <- na.omit(ex_df)
  ex_lm <- lm(Z ~ ., data = ex_df)
  ex_vc <- vcovHC(ex_lm, type = "HC0")
  ex_wf <- waldtest(ex_lm, vcov = ex_vc)
  exog_f  <- ex_wf$F[2]
  exog_pv <- ex_wf$`Pr(>F)`[2]

  # F against AR(p) innovation of yield_6m (Selic-equivalent relevance).
  # Instrument df has columns (month, shock); align by month-start.
  z_y6m <- align_z_to_target(inst_df$shock, inst_df$month, y6m_dates)
  fs_y6m <- first_stage_F(z_y6m, y6m_innov)

  # F (factor-space) — max univariate F across the q dynamic factor innovations
  # eta = u K M^{-1}. This is the relevant weak-instrument metric for the proxy-
  # SVAR projection H = (Z' eta) / (Z'Z): if low, IRFs become noise-dominated
  # regardless of how strong the instrument is against any single reduced-form
  # variable. Distinct from f_partial (controls-residualized F on the policy-
  # equation residual) and f_y6m (F vs AR(p) innovation of yield_6m).
  diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates, p_lag,
                                                 mp_idx_diag)

  tibble(
    variant      = name,
    n            = T_eff,
    nonzero      = sum(Z_t != 0),
    beta         = beta,
    se_hc0       = se,
    t_stat       = tval,
    p_value      = pval,
    f_partial    = f_part,
    xi1          = xi1,
    xi1_mosw     = xi1_mosw,
    r2_fs        = r2,
    exog_f       = exog_f,
    exog_p       = exog_pv,
    f_y6m        = fs_y6m$F_partial,
    r2_y6m       = fs_y6m$r2,
    n_y6m        = fs_y6m$n,
    f_factor_sp  = diag_fs$f_factor,
    wald_min     = diag_fs$wald_min,
    wald_max     = diag_fs$wald_max,
    wald_joint   = diag_fs$wald_joint,
    f_joint      = diag_fs$F_joint,
    p_joint      = diag_fs$p_joint,
    wald_mp      = diag_fs$wald_mp,
    impact_y6m   = diag_fs$impact_mp,
    sign_y6m     = diag_fs$sign_mp
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
  ggsave("output/instrument/scatterplot_surpresas_copom.png", p_scatter,
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

het_val_path <- "output/instrument/het_variance_validation.csv"
het_eig_path <- "output/instrument/het_eigenvalues.csv"
het_b1_path  <- "output/instrument/het_b_1.csv"

het_val_3var_path <- "output/instrument/het_variance_validation_3var.csv"
het_b1_3var_path  <- "output/instrument/het_b_1_3var.csv"

het_b2_path       <- "output/instrument/het_b_2.csv"
het_b2_3var_path  <- "output/instrument/het_b_2_3var.csv"

het_rank_path        <- "output/instrument/het_rank_test.csv"
het_rank_3var_path   <- "output/instrument/het_rank_test_3var.csv"
het_share_path       <- "output/instrument/het_rank1_share_ci.csv"
het_share_3var_path  <- "output/instrument/het_rank1_share_ci_3var.csv"

het_val <- if (file.exists(het_val_path)) read_csv(het_val_path, show_col_types = FALSE) else NULL
het_eig <- if (file.exists(het_eig_path)) read_csv(het_eig_path, show_col_types = FALSE) else NULL
het_b1  <- if (file.exists(het_b1_path))  read_csv(het_b1_path,  show_col_types = FALSE) else NULL

het_val_3var <- if (file.exists(het_val_3var_path)) read_csv(het_val_3var_path, show_col_types = FALSE) else NULL
het_b1_3var  <- if (file.exists(het_b1_3var_path))  read_csv(het_b1_3var_path,  show_col_types = FALSE) else NULL

het_b2      <- if (file.exists(het_b2_path))      read_csv(het_b2_path,      show_col_types = FALSE) else NULL
het_b2_3var <- if (file.exists(het_b2_3var_path)) read_csv(het_b2_3var_path, show_col_types = FALSE) else NULL

het_rank      <- if (file.exists(het_rank_path))       read_csv(het_rank_path,       show_col_types = FALSE) else NULL
het_rank_3var <- if (file.exists(het_rank_3var_path))  read_csv(het_rank_3var_path,  show_col_types = FALSE) else NULL
het_share     <- if (file.exists(het_share_path))      read_csv(het_share_path,      show_col_types = FALSE) else NULL
het_share_3var<- if (file.exists(het_share_3var_path)) read_csv(het_share_3var_path, show_col_types = FALSE) else NULL

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
  ggsave("output/instrument/het_eigenvalues.png", p_eig, width = 7, height = 4, dpi = 150)
}

# ---- 6. Report ---------------------------------------------

fmt_num_or_na <- function(x, d = 3) {
  ifelse(is.na(x), "NA", sprintf(paste0("%.", d, "f"), x))
}

res_tbl <- results |>
  mutate(across(c(beta, se_hc0, t_stat, f_partial, xi1, r2_fs, exog_f,
                  f_factor_sp),
                ~ sprintf("%.3f", .x)),
         f_y6m       = fmt_num_or_na(f_y6m,  3),
         r2_y6m      = fmt_num_or_na(r2_y6m, 3),
         impact_y6m  = sprintf("%+.2e", impact_y6m),
         sign_y6m    = ifelse(sign_y6m > 0, "+",
                              ifelse(sign_y6m < 0, "-", "0")),
         p_value     = map_chr(p_value, fmt_p),
         exog_p      = map_chr(exog_p,  fmt_p),
         weak_flag   = ifelse(as.numeric(xi1) < 3.84, "WEAK", "OK"),
         fs_flag     = ifelse(as.numeric(f_factor_sp) < 10,
                              "WEAK-FACT", "OK"))

hdr <- "| Variant | n (DFM) | nonzero | β̂ | SE(HC0) | t | p | F (DFM) | ξ₁ | R² | n (y6m) | F (y6m AR) | R² y6m | F (factor-sp) | impact y6m | sign | Exog F | Exog p | Flag | FS-Flag |"
sep <- "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|"
rows <- apply(res_tbl, 1, function(r)
  sprintf("| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |",
          r["variant"], r["n"], r["nonzero"], r["beta"], r["se_hc0"],
          r["t_stat"], r["p_value"], r["f_partial"], r["xi1"], r["r2_fs"],
          r["n_y6m"],
          r["f_y6m"], r["r2_y6m"],
          r["f_factor_sp"], r["impact_y6m"], r["sign_y6m"],
          r["exog_f"], r["exog_p"], r["weak_flag"], r["fs_flag"]))
tbl_md <- paste(c(hdr, sep, rows), collapse = "\n")

# MOSW Wald block (sec. 4.2 of the paper + MSWfunction.m). Kept as a
# separate table so the legacy table above stays byte-comparable across runs.
mosw_tbl <- results |>
  transmute(
    variant,
    ar_bounded = ifelse(wald_mp > qchisq(0.95, df = 1), "yes",
                        "NO (unbounded)"),
    mosw_flag  = case_when(
      f_joint >= 10                        ~ "OK",
      wald_mp > qchisq(0.95, df = 1)       ~ "WEAK (AR bounded)",
      TRUE                                 ~ "WEAK (AR may be unbounded)"
    ),
    xi1        = sprintf("%.3f", xi1),
    xi1_mosw   = sprintf("%.3f", xi1_mosw),
    wald_min   = sprintf("%.3f", wald_min),
    wald_max   = sprintf("%.3f", wald_max),
    wald_joint = sprintf("%.3f", wald_joint),
    f_joint    = sprintf("%.3f", f_joint),
    p_joint    = map_chr(p_joint, fmt_p),
    wald_mp    = sprintf("%.3f", wald_mp)
  )
mosw_hdr <- "| Variant | ξ₁ (legado) | ξ₁ (Shat) | min ξ_k | max ξ_k | Wald conj. | F conj. (ξ/q) | p (χ²_q) | ξ_mp | AR limitado? | MOSW-Flag |"
mosw_sep <- "|---|---|---|---|---|---|---|---|---|---|---|"
mosw_rows <- apply(mosw_tbl, 1, function(r)
  sprintf("| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |",
          r["variant"], r["xi1"], r["xi1_mosw"], r["wald_min"], r["wald_max"],
          r["wald_joint"], r["f_joint"], r["p_joint"], r["wald_mp"],
          r["ar_bounded"], r["mosw_flag"]))
mosw_tbl_md <- paste(c(mosw_hdr, mosw_sep, mosw_rows), collapse = "\n")

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

format_var_split_md <- function(tbl) {
  if (is.null(tbl)) return("_(run script/instrument_het.R to populate this section)_")
  has_status <- "a2_status" %in% names(tbl)
  v <- tbl |>
    mutate(across(c(var_C, var_NC, ratio, ci_low, ci_high),
                  ~ signif(.x, 3)))
  if (has_status) {
    paste(c(
      "| Variable | n_C | n_NC | Var(C) | Var(NC) | Ratio | CI 99% low | CI 99% high | A2 verdict |",
      "|---|---|---|---|---|---|---|---|---|",
      apply(v, 1, function(r)
        sprintf("| %s | %s | %s | %s | %s | %s | %s | %s | %s |",
                r["var"], r["n_C"], r["n_NC"], r["var_C"], r["var_NC"],
                r["ratio"], r["ci_low"], r["ci_high"], r["a2_status"]))
    ), collapse = "\n")
  } else {
    paste(c(
      "| Variable | n_C | n_NC | Var(C) | Var(NC) | Ratio | CI 99% low | CI 99% high |",
      "|---|---|---|---|---|---|---|---|",
      apply(v, 1, function(r)
        sprintf("| %s | %s | %s | %s | %s | %s | %s | %s |",
                r["var"], r["n_C"], r["n_NC"], r["var_C"], r["var_NC"],
                r["ratio"], r["ci_low"], r["ci_high"]))
    ), collapse = "\n")
  }
}
het_val_md      <- format_var_split_md(het_val)
het_val_3var_md <- format_var_split_md(het_val_3var)

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
  b1_4 <- het_b1 |>
    transmute(variable, b_1_4var = signif(b_1, 4))
  b1_3 <- if (!is.null(het_b1_3var)) {
    het_b1_3var |> transmute(variable, b_1_3var = signif(b_1, 4))
  } else {
    tibble(variable = character(), b_1_3var = numeric())
  }
  joined <- b1_4 |>
    full_join(b1_3, by = "variable") |>
    mutate(across(c(b_1_4var, b_1_3var),
                  ~ ifelse(is.na(.x), "-", as.character(.x))))
  paste(c(
    "| Variable | b_1 (4-var) | b_1 (3-var, drops DI_2y) |",
    "|---|---|---|",
    apply(joined, 1, function(r)
      sprintf("| %s | %s | %s |", r["variable"], r["b_1_4var"], r["b_1_3var"]))
  ), collapse = "\n")
} else {
  "_(run script/instrument_het.R to populate this section)_"
}

het_b2_md <- if (!is.null(het_b2)) {
  b2_4 <- het_b2 |>
    transmute(variable, b_2_4var = signif(b_2, 4))
  b2_3 <- if (!is.null(het_b2_3var)) {
    het_b2_3var |> transmute(variable, b_2_3var = signif(b_2, 4))
  } else {
    tibble(variable = character(), b_2_3var = numeric())
  }
  joined <- b2_4 |>
    full_join(b2_3, by = "variable") |>
    mutate(across(c(b_2_4var, b_2_3var),
                  ~ ifelse(is.na(.x), "-", as.character(.x))))
  paste(c(
    "| Variable | b_2 (4-var) | b_2 (3-var, drops DI_2y) |",
    "|---|---|---|",
    apply(joined, 1, function(r)
      sprintf("| %s | %s | %s |", r["variable"], r["b_2_4var"], r["b_2_3var"]))
  ), collapse = "\n")
} else {
  "_(run script/instrument_het.R to populate this section)_"
}

format_rank_md <- function(rank_tbl, share_tbl, label) {
  if (is.null(rank_tbl)) return(sprintf("_%s: rank-test artifact missing — run script/instrument_het.R._", label))
  pieces <- character(0)
  pieces <- c(pieces, sprintf("**%s**", label))
  for (i in seq_len(nrow(rank_tbl))) {
    r <- rank_tbl[i, ]
    pieces <- c(pieces, sprintf(
      "- `%s`: LR = %.2f (df = %d), p_chi2 = %s, p_boot = %s, n_boot = %d",
      r$test, r$statistic, r$df, fmt_p(r$p_chi2), fmt_p(r$p_boot), r$n_boot
    ))
  }
  if (!is.null(share_tbl) && nrow(share_tbl) > 0) {
    s <- share_tbl[1, ]
    pieces <- c(pieces, sprintf(
      "- Bootstrap rank-1 share %g%% CI: [%.3f, %.3f] (point %.3f, n_boot = %d)",
      100 * s$ci_level, s$share_lo, s$share_hi, s$share_point, s$n_boot
    ))
  }
  paste(pieces, collapse = "\n")
}

het_rank_md      <- format_rank_md(het_rank,      het_share,      "4-var production block")
het_rank_3var_md <- format_rank_md(het_rank_3var, het_share_3var, "3-var robustness block")

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
  "Three first-stage statistics are reported side by side:",
  "",
  "- **F (DFM)** — partial F (= t²) of the instrument in the regression of the",
  "  first-factor VAR residual on Z plus lagged factors, HC0 SE. This is the",
  "  Olea-Stock-Watson statistic that governs weak-instrument bias inside the",
  "  Alessi-Kerssenfischer proxy-SVAR; the relevant target is the DFM residual,",
  "  not the policy rate.",
  "- **F (y6m AR)** — partial F of the instrument against the AR(6) innovation",
  "  of monthly `yield_6m` (univariate, HC0 SE). This is the audit statistic",
  "  (`output/instrument/instrument_audit_report.md`, 2026-04-25): it measures relevance",
  "  for the Selic-equivalent interpretation of the shock and feeds the",
  "  normalization in `model_alessi.R` (`mp_var = yield_6m`).",
  "- **F (factor-sp)** — max univariate F across the q dynamic factor",
  "  innovations η = u K M⁻¹. This is the relevant weak-instrument metric",
  "  for the proxy-SVAR projection H = (Z'η)/(Z'Z): if it is small, the",
  "  IRFs become noise-dominated regardless of how strong Z is against any",
  "  single reduced-form variable. **FS-Flag = WEAK-FACT when F (factor-sp) < 10.**",
  "  Disagreement between F (factor-sp) and F (y6m AR) was the root cause",
  "  of the 2026-05-08 IRF investigation: `z_het_jk_3var` had F (y6m AR) ≈ 56",
  "  but F (factor-sp) ≈ 2.7, producing weak-instrument-driven sign reversals.",
  "",
  "The three answers can disagree: e.g. `z_het` was reported with F (DFM) ≈ 1.5",
  "and F (y6m AR) ≈ 7.6 in earlier runs. ξ₁ uses the Olea-Stock-Watson",
  "convention; threshold = 3.84.",
  "",
  tbl_md,
  "",
  "### 1.1 Bloco Wald MOSW (leitura conservadora)",
  "",
  "Estatísticas de Wald de Montiel Olea-Stock-Watson (2021, §4.2), validadas",
  "contra o código oficial dos autores (`codigo_olea/`, MSWfunction.m e",
  "CovAhat_Sigmahat_Gamma.m). Todas usam Eicker-White (Newey-West 0 lags) e",
  "residualizam Z nos regressores do VAR de fatores (correção Shat), exceto a",
  "coluna legada ξ₁:",
  "",
  "- **ξ₁ (legado)** — T·Γ̂₁²/Ŵ₁₁ contra o resíduo do 1º fator, sem correção",
  "  Shat (coluna mantida por comparabilidade).",
  "- **ξ₁ (Shat)** — mesma estatística com Z residualizado em lags + constante,",
  "  exatamente como `CovAhat_Sigmahat_Gamma.m` propaga o erro de estimação do VAR.",
  "- **min/max ξ_k** — Wald robusta por inovação de fator, k = 1..q. O mínimo",
  "  é a leitura conservadora por equação; o máximo compara com a coluna",
  "  legada F (factor-sp), que é homocedástica e não robusta.",
  "- **Wald conjunta** — ξ = T·Γ̂'Ŵ⁻¹Γ̂ ~ χ²_q sob irrelevância (o `WaldstatFull`",
  "  dos autores, MSWfunction.m:389). Não faz cherry-pick da equação mais forte.",
  "  **F conjunta = ξ/q** é a forma-F para leitura na régua Stock-Yogo.",
  "- **ξ_mp** — Wald na direção c'Γ̂ com c = linha de `yield_6m` na matriz de",
  "  impacto Λ·K·M: é o análogo exato do `Waldstat` oficial (Γ̂ da variável",
  "  normalizadora) na nossa parametrização, e governa o denominador da",
  "  normalização. **O conjunto AR 95% é intervalo limitado sse ξ_mp > 3.84**",
  "  (Fieller/Anderson-Rubin, footnote 13 do paper).",
  "",
  mosw_tbl_md,
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
  "Hypothesis A2 (other shock variances stable) requires the remaining variables' CIs to include 1.  ",
  "`a2_status` is `policy` for the policy variable, `pass` if the 99% CI includes 1, and `violated` otherwise (CI excludes 1 by either side).",
  "",
  "**4-var production block (DI_3m, DI_2y, IBOV, BRL):**",
  "",
  het_val_md,
  "",
  "**3-var robustness block (DI_3m, IBOV, BRL):** drops DI_2y to test whether",
  "the second eigenvalue of dSigma was driven by a separate shock (council Required 1).",
  "Compare b_1 with the 4-var block in §4.3.",
  "",
  het_val_3var_md,
  "",
  "### 4.2 Eigenvalue spectrum of dSigma = Sigma_C - Sigma_NC",
  "",
  "Under the rank-1 hypothesis (Rigobon-Sack 2003 §III), only one eigenvalue is non-zero.  ",
  "Informal gate: leading eigenvalue should account for > 60% of |sum| of eigenvalues.",
  "",
  het_eig_md,
  "",
  if (file.exists("output/instrument/het_eigenvalues.png")) "![eigenvalues](het_eigenvalues.png)" else "_(plot not generated)_",
  "",
  "**Formal rank tests** (replace the informal `rank1_share > 0.6` gate):",
  "",
  "- _Rigobon (2003) Proposition 1 proportionality test_ — H0: Σ_C = a · Σ_NC.",
  "  Failure to reject means the regimes' covariance matrices are similar up to",
  "  scale, so dSigma carries no rotation and b_1 is undefined. Mauchly LR with",
  "  wild-bootstrap-calibrated p-value (n_C ≈ 50 makes χ² unreliable).",
  "- _Lanne-Lütkepohl (2008) LR rank-1 test_ — H0: rank(dSigma) = 1.",
  "  Failure to reject means a rank-1 approximation is adequate (the leading",
  "  eigenpair captures the entire shift), justifying b_1 = sqrt(λ_1) v_1.",
  "- _Bootstrap rank-1 share CI_ — non-parametric bootstrap quantiles of",
  "  λ_1 / sum |λ_j|, descriptor alongside the LR tests.",
  "",
  "Hansen J overidentification test is unavailable in our R = 2 setup",
  "(Rigobon 2003, Proposition 2: df = 0); to unlock it the NC regime would",
  "have to be sub-split into ≥ 3 windows.",
  "",
  het_rank_md,
  "",
  het_rank_3var_md,
  "",
  "### 4.3 Impact column b_1 (sign normalized so b_1[DI_3m] > 0)",
  "",
  "Side-by-side comparison of the 4-var production block and the 3-var",
  "robustness block. If A2 is violated by DI_2y, the 4-var b_1 conflates the",
  "policy shock with a second structural shock; the 3-var b_1 is the cleaner",
  "estimate. Compare the magnitude and (especially) the relative weights on",
  "DI_3m, IBOV, BRL across columns.",
  "",
  het_b1_md,
  "",
  "### 4.4 Second eigenpair b_2 (descriptor only — arbitrary under A1-A3)",
  "",
  "Under the rank-1 identifying restrictions A1-A3 (Rigobon-Sack 2003 §III),",
  "the second eigenvector of dSigma lies in the rank-1 nullspace and is",
  "arbitrary. When A2 fails for some non-policy variable (e.g., DI_2y in the",
  "4-var SVAR with λ_2 ≈ 41), v_2 carries structural information consistent",
  "with a second policy-adjacent shock — most likely a forward-guidance /",
  "belly-of-curve shock. Treat as a descriptor: do not use as a second",
  "identified instrument under A1-A3 alone.",
  "",
  het_b2_md,
  "",
  "Daily ε̂_2 series is persisted to `data/processed/instrument_z_het2{,_3var}.csv`.",
  "",
  "---",
  "",
  "## 5. Interpretation",
  "",
  "- **F > 10 / ξ₁ > 10**: inference standard OK.  ",
  "- **F ∈ [5, 10]**: use Anderson-Rubin robust intervals.  ",
  "- **ξ₁ < 3.84**: instrument flagged as weak; AR CIs possibly unbounded.  ",
  "- **Leitura conservadora (§1.1)**: a decisão de força do instrumento deve",
  "  usar a **F conjunta (ξ/q)** e a **ξ_mp**, não o máximo por equação. A regra",
  "  F > 10 aplicada ao máximo de q regressões é anti-conservadora (viés de",
  "  seleção da equação mais forte); a coluna F (factor-sp) permanece apenas",
  "  por comparabilidade com o spec sweep de 2026-07-11. MOSW (§4.2, footnote 6)",
  "  advertem ainda contra *screening* no F: reportar F/ξ e usar rotineiramente",
  "  os conjuntos AR robustos, não condicionar a inferência no pré-teste.  ",
  "- Compare z_bruto vs. z_JK to assess whether the JK filter changes identification, and vs. their `_purif` counterparts for the role of global-factor contamination.",
  "- **z_het** is identified by heteroskedasticity (Rigobon-Sack 2003 QJE) on the daily SVAR and is independent of the timing assumption that underlies the four GK-style variants. Convergence of `z_het` results with `z_jk_purif` is the central robustness check.",
  sep = "\n"
)

writeLines(report, "output/instrument/instrument_diagnostics_report.md")
message("Report written to output/instrument/instrument_diagnostics_report.md")

cat("\n========== VARIANT COMPARISON ==========\n")
print(results |> mutate(across(where(is.numeric), ~ round(.x, 3))))
cat("========================================\n\n")
