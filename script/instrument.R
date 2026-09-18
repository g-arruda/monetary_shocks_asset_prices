# ============================================================
# External instrument for proxy-SVAR: Copom-day DI surprises.
# Produces eight monthly variants:
#  - z_bruto, z_bruto_purif, z_jk, z_jk_purif (contemporaneous
#    same-window purification vs. global factors; JK sign filter
#    on residual signs);
#  - z_jk_raw_purif (JK mask on RAW signs first, purification after);
#  - z_jk_raw (2026-07-14 audit): literal JK poor-man's proxy —
#    raw-sign mask AND raw delta_di values, no purification;
#  - z_bs_purif / z_jk_bs_purif (2026-07-14 audit): BS-faithful
#    purification — regression on PRE-event predictors only
#    (13-week financial trends + 4-week Focus revisions + trend),
#    per Bauer-Swanson (2023) eq. 7 / Table 3.
# Requires the daily raw inputs written by `script/download.R`.
# ============================================================

source("R/instrument/di_surprise.R")
source("R/instrument/build_variants.R")
source("R/modeling/production_spec.R")

# ---- Config ------------------------------------------------

SPEC <- production_spec()
SAMPLE_START <- SPEC$event_sample[1]
SAMPLE_END   <- SPEC$event_sample[2]
LOAD_START   <- SPEC$instrument_load_start
TARGET_BD    <- 126                      # ~6 months in business days
AGG_SCHEME   <- "sum"                    # Jarocinski-Karadi within-month sum
DEFAULT_VARIANT <- SPEC$instrument # legacy data/processed/instrument.csv
# Vertex and aggregation were swept under xi_mp on 2026-07-27
# (output/instrument/instrument_construction_sweep.md). The default is
# z_jk_bs_purif since 2026-07-15: its JK mask reads Bauer-Swanson pre-event
# residuals, so it does not label 2020-03-19 (COVID panic) as monetary
# (notas/2026-07-14_auditoria_fidelidade_jk_bs.md; dropped and archived
# variants in registro/historico_decisoes.md sections 1 and 2).

# ---- Load data ---------------------------------------------

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

dgs2_daily <- readr::read_csv("data/raw/fred_dgs2.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), ust2y = as.numeric(ust2y))

copom_wed <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)

fomc_dates <- load_fomc_dates(from = LOAD_START, to = SAMPLE_END)

# ---- Build ------------------------------------------------
# The chain lives in R/instrument/build_variants.R so the vertex and the
# aggregation scheme can be swept without duplicating it.

built <- build_instrument_variants(
  inputs = list(di_panel    = di_panel,
                ibov_daily  = ibov_daily,
                ext_daily   = ext_daily,
                brl_daily   = brl_daily,
                focus_daily = focus_daily,
                dgs2_daily  = dgs2_daily,
                copom_wed   = copom_wed,
                fomc_dates  = fomc_dates),
  target_bd    = TARGET_BD,
  agg          = AGG_SCHEME,
  sample_start = SAMPLE_START,
  sample_end   = SAMPLE_END
)

instrumentos <- built$monthly

# ---- Write outputs -----------------------------------------

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

readr::write_csv(instrumentos, "data/processed/instrumentos_mensais.csv")

variant_files <- c(
  z_bruto        = "data/processed/instrument_bruto.csv",
  z_bruto_purif  = "data/processed/instrument_bruto_purif.csv",
  z_jk           = "data/processed/instrument_jk.csv",
  z_jk_purif     = "data/processed/instrument_jk_purif.csv",
  z_jk_raw_purif = "data/processed/instrument_jk_raw_purif.csv",
  z_jk_raw       = "data/processed/instrument_jk_raw.csv",
  z_bs_purif     = "data/processed/instrument_bs_purif.csv",
  z_jk_bs_purif  = "data/processed/instrument_jk_bs_purif.csv",
  # Legacy file consumed by model_alessi.R / model_var.R
  setNames("data/processed/instrument.csv", DEFAULT_VARIANT)
)
purrr::iwalk(variant_files, function(path, variant) {
  instrumentos |>
    dplyr::transmute(month, shock = .data[[variant]]) |>
    readr::write_csv(path)
})

# Daily diagnostics panel (for scatterplot & variance F-test)
built$daily |>
  dplyr::select(date, delta_di, r_ibov, e_di, e_ibov,
                e_di_bs, e_ibov_bs, e_di_us, e_ibov_us,
                copom_day, fomc_coincide, jk_monetary, jk_monetary_raw,
                jk_monetary_bs, jk_monetary_us) |>
  readr::write_csv("data/processed/copom_event_diagnostics.csv")

