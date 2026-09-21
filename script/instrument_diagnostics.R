# ============================================================
# Relevance of the three instrument variants of tab:first_stage on the
# production DFM: months with z != 0, xi_mp, robust first-stage F, beta, SE
# and p in the yield_6m direction, plus a lead-lag exogeneity check of z on
# six lags of the first factor-VAR residual.
# Output: output/instrument/instrument_diagnostics.csv
# ============================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")

source("R/identification/factor_space_diagnostics.R")

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
R_FACTORS <- 5L
Q_DYNAMIC <- 5L
P_LAGS    <- 4L
MP_VAR    <- "yield_6m"
VARIANTS <- c("z_bruto", "z_bs_purif", "z_jk_bs_purif")

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()

dates  <- as.Date(raw_data$ref.date)
X      <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE)

# The instrument only trims estimate_dfm() to its months, which every variant
# covers, so any column serves.
dfm <- estimate_dfm(X, r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
                    dates = dates,
                    instrument = dplyr::transmute(inst_panel, month, shock = z_bruto),
                    covid_volatility = read_covid_volatility(THETA_PATH))

policy_residual <- dfm$var_residuals[, 1]
p_lag           <- dfm$p
mp_idx_diag     <- match(MP_VAR, colnames(X))

results <- purrr::map_dfr(VARIANTS, function(name) {
  inst_df <- dplyr::transmute(inst_panel, month, shock = .data[[name]])
  align   <- sel_ext_inst_sample(dfm$dates, p_lag, inst_df)
  Z_t     <- align$inst_sel
  res_al  <- policy_residual[align$rsh_sel_ind]

  n_lags <- 6
  ex_df <- tibble::tibble(Z = Z_t)
  for (k in seq_len(n_lags)) ex_df[[paste0("lag", k)]] <- dplyr::lag(res_al, k)
  ex_df <- na.omit(ex_df)
  ex_lm <- lm(Z ~ ., data = ex_df)
  ex_wf <- lmtest::waldtest(ex_lm, vcov = sandwich::vcovHC(ex_lm, type = "HC0"))

  diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates, p_lag,
                                                 mp_idx_diag)

  tibble::tibble(
    variant      = name,
    n            = length(Z_t),
    nonzero      = sum(Z_t != 0),
    xi_mp        = diag_fs$wald_mp,
    f_robust_mp  = diag_fs$f_robust_mp,
    beta_mp      = diag_fs$first_stage_beta,
    se_mp        = diag_fs$first_stage_se,
    p_mp         = diag_fs$first_stage_p,
    exog_f       = ex_wf$F[2],
    exog_p       = ex_wf$`Pr(>F)`[2],
    impact_y6m   = diag_fs$impact_mp,
    sign_y6m     = diag_fs$sign_mp
  )
})

dir.create("output/instrument", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(results, "output/instrument/instrument_diagnostics.csv")
