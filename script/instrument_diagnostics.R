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
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")

dir.create("output/instrument", showWarnings = FALSE, recursive = TRUE)

SPEC <- production_spec()
YIELD6M_TARGET <- SPEC$mp_var

# ---- 1. DFM estimation (instrument-agnostic) ---------------

raw_data <- read_csv(SPEC$data_path,
                     show_col_types = FALSE) |> drop_na()

dates  <- as.Date(raw_data$ref.date)
X      <- raw_data |> select(-ref.date) |> as.matrix()

message(sprintf("Estimating production DFM (r=%d, q=%d, p=%d) ...",
                SPEC$r, SPEC$q, SPEC$p))
# We need any instrument df just so estimate_dfm() builds the VAR; use the bruto.
seed_inst <- read_csv("data/processed/instrument_bruto.csv", show_col_types = FALSE)
dfm <- estimate_dfm(X, r = SPEC$r, q = SPEC$q, p = SPEC$p,
                    dates = dates, instrument = seed_inst,
                    apply_kilian = FALSE)

policy_residual <- dfm$var_residuals[, 1]
p_lag           <- dfm$p
residual_dates  <- dfm$dates[(p_lag + 1):length(dfm$dates)]

# Index of yield_6m in the panel — used by diagnose_instrument_in_factor_space
# to read the impact response per variant in policy-variable native units.
mp_idx_diag <- match(YIELD6M_TARGET, colnames(X))

# ---- 2. Diagnostics per variant ----------------------------

variants <- list(
  "z_bruto"        = "data/processed/instrument_bruto.csv",
  "z_bruto_purif"  = "data/processed/instrument_bruto_purif.csv",
  "z_jk"           = "data/processed/instrument_jk.csv",
  "z_jk_purif"     = "data/processed/instrument_jk_purif.csv",
  "z_jk_raw_purif" = "data/processed/instrument_jk_raw_purif.csv",
  "z_jk_raw"       = "data/processed/instrument_jk_raw.csv",
  "z_bs_purif"     = "data/processed/instrument_bs_purif.csv",
  "z_jk_bs_purif"  = "data/processed/instrument_jk_bs_purif.csv"
)
variants <- variants[file.exists(unlist(variants))]

fmt_p <- function(p) if (is.na(p)) "NA" else if (p < 0.001) "< 0.001" else sprintf("%.3f", p)

run_variant <- function(name, path) {
  inst_df <- read_csv(path, show_col_types = FALSE)
  align   <- sel_ext_inst_sample(dfm$dates, p_lag, inst_df)
  Z_t     <- align$inst_sel
  res_al  <- policy_residual[align$rsh_sel_ind]
  T_eff   <- length(Z_t)

  n_lags <- 6
  ex_df <- tibble(Z = Z_t)
  for (k in seq_len(n_lags)) ex_df[[paste0("lag", k)]] <- dplyr::lag(res_al, k)
  ex_df <- na.omit(ex_df)
  ex_lm <- lm(Z ~ ., data = ex_df)
  ex_vc <- vcovHC(ex_lm, type = "HC0")
  ex_wf <- waldtest(ex_lm, vcov = ex_vc)
  exog_f  <- ex_wf$F[2]
  exog_pv <- ex_wf$`Pr(>F)`[2]

  diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates, p_lag,
                                                 mp_idx_diag)

  tibble(
    variant      = name,
    n            = T_eff,
    nonzero      = sum(Z_t != 0),
    xi_mp        = diag_fs$wald_mp,
    f_robust_mp  = diag_fs$f_robust_mp,
    beta_mp      = diag_fs$first_stage_beta,
    se_mp        = diag_fs$first_stage_se,
    p_mp         = diag_fs$first_stage_p,
    exog_f       = exog_f,
    exog_p       = exog_pv,
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

# ---- 5. Report ---------------------------------------------

res_tbl <- results |>
  mutate(across(c(xi_mp, f_robust_mp, exog_f),
                ~ sprintf("%.3f", .x)),
         beta_mp     = sprintf("%+.2e", beta_mp),
         se_mp       = sprintf("%.2e", se_mp),
         impact_y6m  = sprintf("%+.2e", impact_y6m),
         sign_y6m    = ifelse(sign_y6m > 0, "+",
                              ifelse(sign_y6m < 0, "-", "0")),
         p_mp        = map_chr(p_mp, fmt_p),
         exog_p      = map_chr(exog_p, fmt_p))

hdr <- "| Variant | n | nonzero | ξ_mp | F robusto_mp | β̂_mp | SE(HC1) | p_mp | impacto y6m | sinal | Exog F | Exog p |"
sep <- "|---|---|---|---|---|---|---|---|---|---|---|---|"
rows <- apply(res_tbl, 1, function(r)
  sprintf("| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |",
          r["variant"], r["n"], r["nonzero"], r["xi_mp"],
          r["f_robust_mp"], r["beta_mp"], r["se_mp"], r["p_mp"],
          r["impact_y6m"], r["sign_y6m"], r["exog_f"], r["exog_p"]))
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

report <- paste(
  "# Instrument Validity Diagnostics Report",
  "",
  sprintf("**Date generated:** %s", Sys.Date()),
  sprintf("**DFM sample:** %s to %s  ", min(dfm$dates), max(dfm$dates)),
  "**Identification:** proxy-SVAR with external instrument (Montiel Olea, Stock & Watson 2021).",
  "**Instrument variants:** raw Copom-day ΔDI (3m), purified by global factors (SP500, VIX, Brent),",
  "Jarociński-Karadi sign filter, and JK + purified.",
  "",
  "---",
  "",
  "## 1. Força do instrumento por variante",
  "",
  "As duas estatísticas seguem a §4.2 de Montiel Olea-Stock-Watson (2021).",
  "**ξ_mp** é a Wald na direção c'Γ̂ com c = linha de `yield_6m` na matriz de",
  "  impacto Λ·K·M: é o análogo exato do `Waldstat` oficial (Γ̂ da variável",
  "normalizadora). **F robusto_mp** é o t² HC1 do instrumento na regressão",
  "de c_mp'η_t sobre o instrumento e as defasagens dos fatores. Ambos usam a",
  "mesma direção; o código reproduz ξ₁=4,4 e F=9,4 da aplicação dos autores.",
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
  "## 4. Interpretation",
  "",
  "- O valor 10 é uma referência convencional, não um valor crítico fornecido por MOSW.",
  "- Se ξ_mp e F robusto_mp divergirem, a evidência de força é mista.",
  "- Abaixo de 10, qualificar o bootstrap; a inferência AR do DFM está adiada.",
  "- **ξ_mp abaixo de 3,84**: um futuro conjunto AR de 95% pode ser ilimitado.",
  "- MOSW (§4.2, footnote 6)",
  "  advertem ainda contra *screening* no F: reportar F/ξ e usar rotineiramente",
  "  os conjuntos AR robustos, não condicionar a inferência no pré-teste.  ",
  "- Compare z_bruto vs. z_JK to assess whether the JK filter changes identification, and vs. their `_purif` counterparts for the role of global-factor contamination.",
  sep = "\n"
)

writeLines(report, "output/instrument/instrument_diagnostics_report.md")
message("Report written to output/instrument/instrument_diagnostics_report.md")

cat("\n========== VARIANT COMPARISON ==========\n")
print(results |> mutate(across(where(is.numeric), ~ round(.x, 3))))
cat("========================================\n\n")
