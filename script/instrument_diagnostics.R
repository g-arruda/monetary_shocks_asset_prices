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
OUT_PATH        <- "output/instrument/instrument_diagnostics.csv"
R_FACTORS  <- 5L
Q_DYNAMIC  <- 5L
P_LAGS     <- 4L
MP_VAR     <- "yield_6m"
EXOG_LAGS  <- 6L
VARIANTS   <- c("z_bruto", "z_bs_purif", "z_jk_bs_purif")

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
X <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE)

# The instrument only trims estimate_dfm() to its months, which every variant
# covers, so any column serves.
dfm <- estimate_dfm(
  X,
  r = R_FACTORS,
  q = Q_DYNAMIC,
  p = P_LAGS,
  dates = dates,
  instrument = dplyr::transmute(inst_panel, month, shock = z_bruto),
  covid_volatility = read_covid_volatility(THETA_PATH)
)

policy_residual <- dfm$var_residuals[, 1]
mp_index <- match(MP_VAR, colnames(X))

results <- purrr::map(VARIANTS, function(variant) {
  inst_df <- dplyr::transmute(inst_panel, month, shock = .data[[variant]])
  aligned <- sel_ext_inst_sample(dfm$dates, dfm$p, inst_df)
  z <- aligned$inst_sel
  residual <- policy_residual[aligned$rsh_sel_ind]

  exog_data <- purrr::map(seq_len(EXOG_LAGS), \(k) dplyr::lag(residual, k)) |>
    purrr::set_names(paste0("lag", seq_len(EXOG_LAGS))) |>
    tibble::as_tibble() |>
    dplyr::mutate(Z = z, .before = 1) |>
    tidyr::drop_na()
  exog_fit <- lm(Z ~ ., data = exog_data)
  exog_wald <- lmtest::waldtest(
    exog_fit,
    vcov = sandwich::vcovHC(exog_fit, type = "HC0")
  )

  first_stage <- diagnose_instrument_in_factor_space(
    dfm,
    inst_df,
    dates,
    dfm$p,
    mp_index
  )

  tibble::tibble(
    variant = variant,
    n = length(z),
    nonzero = sum(z != 0),
    xi_mp = first_stage$wald_mp,
    f_robust_mp = first_stage$f_robust_mp,
    beta_mp = first_stage$first_stage_beta,
    se_mp = first_stage$first_stage_se,
    p_mp = first_stage$first_stage_p,
    exog_f = exog_wald$F[2],
    exog_p = exog_wald$`Pr(>F)`[2],
    impact_y6m = first_stage$impact_mp,
    sign_y6m = first_stage$sign_mp
  )
}) |>
  purrr::list_rbind()

dir.create(dirname(OUT_PATH), showWarnings = FALSE, recursive = TRUE)
readr::write_csv(results, OUT_PATH)
