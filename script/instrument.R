# ============================================================
# External instrument for proxy-SVAR: Copom-day DI surprises.
# Produces the three monthly variants of tab:first_stage
# (R/instrument/build_variants.R): z_bruto, z_bs_purif and the
# production z_jk_bs_purif, whose JK mask reads Bauer-Swanson
# pre-event residuals (notas/2026-07-14_auditoria_fidelidade_jk_bs.md).
# Requires the daily raw inputs written by `script/download.R`.
# ============================================================

source("R/instrument/di_surprise.R")
source("R/instrument/build_variants.R")
source("R/modeling/production_spec.R")

SPEC <- production_spec()
SAMPLE_START <- SPEC$event_sample[1]
SAMPLE_END   <- SPEC$event_sample[2]
LOAD_START   <- as.Date("2011-09-01")   # daily antecedents of the 65-day pre-event trends
TARGET_BD    <- 126                     # ~6 months in business days

di_panel <- load_di_panel("data/raw/di.csv", from = LOAD_START, to = SAMPLE_END)

ibov_daily <- readr::read_csv("data/raw/ibov_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), ibov = as.numeric(ibov)) |>
  dplyr::filter(!is.na(ibov))

ext_daily <- readr::read_csv("data/raw/investing/external_factors_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date),
                   sp500 = as.numeric(sp500),
                   vix   = as.numeric(vix),
                   brent = as.numeric(brent))

brl_daily <- readr::read_csv("data/raw/brl_usd_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), brl = as.numeric(brl)) |>
  dplyr::filter(!is.na(brl))

focus_daily <- readr::read_csv("data/raw/focus_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date),
                   focus_ipca12m  = as.numeric(focus_ipca12m),
                   focus_selic_ny = as.numeric(focus_selic_ny))

copom_wed <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)

built <- build_instrument_variants(
  inputs = list(di_panel    = di_panel,
                ibov_daily  = ibov_daily,
                ext_daily   = ext_daily,
                brl_daily   = brl_daily,
                focus_daily = focus_daily,
                copom_wed   = copom_wed),
  target_bd    = TARGET_BD,
  sample_start = SAMPLE_START,
  sample_end   = SAMPLE_END
)

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

readr::write_csv(built$monthly, SPEC$instrument_path)

# Single-column production instrument read by main_sdfm()
built$monthly |>
  dplyr::transmute(month, shock = .data[[SPEC$instrument]]) |>
  readr::write_csv(SPEC$legacy_instrument_path)

built$daily |>
  dplyr::select(date, delta_di, r_ibov, e_di_bs, e_ibov_bs,
                copom_day, jk_monetary_bs) |>
  readr::write_csv("data/processed/copom_event_diagnostics.csv")
