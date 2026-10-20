# ============================================================
# External instrument for proxy-SVAR: Copom-day DI surprises.
# Produces the three monthly variants of tab:first_stage
# (R/instrument/build_variants.R): z_bruto, the production z_bs_purif
# (Bauer-Swanson pre-event orthogonalization) and z_jk_bs_purif, whose
# JK mask reads the Bauer-Swanson residuals
# (notas/2026-07-14_auditoria_fidelidade_jk_bs.md). The events are the
# 111 Copom meetings, each from the Wednesday close to the first DI session
# after it; the seven on the eve of a Brazilian holiday, whose window runs to
# Friday, are left out only in the sensitivity of
# notas/2026-10-17_auditoria_janelas_copom.md:
# data/processed/instrument_no_holiday_windows.csv, with its variants and
# surprises by meeting beside it.
# Requires the daily raw inputs written by `script/download.R` and the
# macroeconomic news inputs written by `script/download_macro_news.R`.
# ============================================================

source("R/instrument/di_surprise.R")
source("R/instrument/build_variants.R")

# Copom-day window: the production months, to the end of the last one
SAMPLE_START <- as.Date("2012-03-01")
SAMPLE_END   <- as.Date("2025-12-31")
# Daily antecedents of the 65-day pre-event trends
LOAD_START   <- as.Date("2011-09-01")
TARGET_BD    <- 126 # ~6 months in business days
# The column of the single-column legacy CSV
PRODUCTION_VARIANT <- "z_bs_purif"

di_panel <- load_di_panel(
  "data/raw/di.csv",
  from = LOAD_START,
  to = SAMPLE_END
)

ibov_daily <- readr::read_csv(
  "data/raw/ibov_daily.csv",
  show_col_types = FALSE
) |>
  dplyr::transmute(date = as.Date(date), ibov = as.numeric(ibov)) |>
  dplyr::filter(!is.na(ibov))

ext_daily <- readr::read_csv(
  "data/raw/investing/external_factors_daily.csv",
  show_col_types = FALSE
) |>
  dplyr::transmute(
    date = as.Date(date),
    sp500 = as.numeric(sp500),
    vix = as.numeric(vix),
    brent = as.numeric(brent)
  )

focus_macro <- readr::read_csv(
  "data/raw/focus_macro_expectations.csv",
  show_col_types = FALSE
)

macro_released <- readr::read_csv(
  "data/raw/macro_released.csv",
  show_col_types = FALSE
)

copom_wed <- load_copom_wednesdays(
  "data/raw/copom_historico.csv",
  from = LOAD_START,
  to = SAMPLE_END
)

inputs <- list(
  di_panel = di_panel,
  ibov_daily = ibov_daily,
  ext_daily = ext_daily,
  focus_macro = focus_macro,
  macro_released = macro_released,
  copom_wed = copom_wed
)

# The meetings on the eve of a Brazilian holiday enter production with the
# window to Friday (advisor's e-mail of 2026-10-17, item 3)
built <- build_instrument_variants(
  inputs = inputs,
  target_bd = TARGET_BD,
  sample_start = SAMPLE_START,
  sample_end = SAMPLE_END,
  holiday_windows = TRUE
)

# The advisor's sensitivity: those seven longer windows left out, their
# months at zero, the BS regression refitted without them; read by
# script/copom_window_comparison.R
built_no_holiday_windows <- build_instrument_variants(
  inputs = inputs,
  target_bd = TARGET_BD,
  sample_start = SAMPLE_START,
  sample_end = SAMPLE_END,
  holiday_windows = FALSE
)

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

readr::write_csv(built$monthly, "data/processed/instrumentos_mensais.csv")

# Single-column production instrument read by main_sdfm()
built$monthly |>
  dplyr::transmute(month, shock = .data[[PRODUCTION_VARIANT]]) |>
  readr::write_csv("data/processed/instrument.csv")

built_no_holiday_windows$monthly |>
  dplyr::transmute(month, shock = .data[[PRODUCTION_VARIANT]]) |>
  readr::write_csv("data/processed/instrument_no_holiday_windows.csv")

# The sensitivity's variants and surprises by meeting, for the bridge from
# the daily event to the monthly DFM (script/daily_event.R,
# script/event_trajectory.R, script/monthly_reduced_form.R)
readr::write_csv(
  built_no_holiday_windows$monthly,
  "data/processed/instrumentos_mensais_no_holiday_windows.csv"
)
built_no_holiday_windows$daily |>
  dplyr::select(wednesday, date, long_window, delta_di, e_di_bs) |>
  readr::write_csv("data/processed/copom_event_diagnostics_no_holiday_windows.csv")

built$daily |>
  dplyr::select(
    wednesday,
    date,
    long_window,
    delta_di,
    r_ibov,
    e_di_bs,
    e_ibov_bs,
    jk_monetary_bs
  ) |>
  readr::write_csv("data/processed/copom_event_diagnostics.csv")

# Anexo D, the analogue of Bauer-Swanson (2023) Table 3: coefficients of the
# two pre-event regressions with HC1 standard errors, the HC1 joint Wald of
# all nine predictors and that of the four macroeconomic news alone (the
# constant stays in the restricted model)
built$bs_fits |>
  purrr::imap(function(fit, dependent) {
    vcov_hc1 <- sandwich::vcovHC(fit, type = "HC1")
    wald <- purrr::map(c(joint = "^(pre|news)_", macro = "^news_"), \(block) {
      predictors <- stringr::str_subset(names(coef(fit)), block)
      beta <- coef(fit)[predictors]
      f <- drop(
        t(beta) %*% solve(vcov_hc1[predictors, predictors], beta)
      ) / length(predictors)
      c(
        f = f,
        p = pf(f, length(predictors), df.residual(fit), lower.tail = FALSE)
      )
    })
    lmtest::coeftest(fit, vcov = vcov_hc1)[, ] |>
      tibble::as_tibble(rownames = "term") |>
      purrr::set_names(c("term", "estimate", "se", "t", "p")) |>
      dplyr::mutate(
        dependent = dependent,
        n = nobs(fit),
        r2 = summary(fit)$r.squared,
        joint_f = wald$joint[["f"]],
        joint_p = wald$joint[["p"]],
        macro_f = wald$macro[["f"]],
        macro_p = wald$macro[["p"]],
        .before = 1
      )
  }) |>
  purrr::list_rbind() |>
  readr::write_csv("output/instrument/bs_orthogonalization.csv")
