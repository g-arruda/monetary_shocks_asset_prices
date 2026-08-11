---
paths:
  - "script/download.R"
  - "script/clean.R"
  - "script/run_all.R"
  - "R/data_download/**"
  - "R/preprocessing/**"
---

# Data layout

Inputs and intermediate files live under `data/` (gitignored). Sample: **2013-01 to 2025-09,
monthly, 106 series** (vintage refreshed 2026-07-24: the duplicated tempo-de-procura block and the
empty ANBIMA break-even columns were dropped, and `download.R` / `clean.R` now persist their outputs
via `write_csv` — the old scripts computed but never wrote).

- `data/raw_data.csv` — merged monthly panel from `download.R`.
- `data/processed/data_log_deseasonalized.csv` — input to the DFM (drop `ref.date`, `drop_na`).
  Written by `clean.R`, which log-transforms and applies X-13 via `R/preprocessing/seasonality.R`.
  (The `source()` of `R/preprocessing/stationarity.R` is commented out — **that file never existed**;
  BLL standardization happens inside `factor_estimation.R`.)
- `data/processed/instrument.csv` — single-column instrument consumed by both estimation scripts.
- `data/processed/instrumentos_mensais.csv` — the 8 GK-family variants side-by-side: `z_bruto`,
  `z_bruto_purif`, `z_jk`, `z_jk_purif`, `z_jk_raw_purif`, `z_jk_raw`, `z_bs_purif`, `z_jk_bs_purif`.
- `data/processed/focus_daily.csv`, `data/fred_dgs2.csv` — pre-event predictors from
  `R/data_download/focus_fred.R`.
- `data/di.csv`, `data/copom_historico.csv`, `data/processed/ibov_daily.csv`,
  `data/processed/brl_usd_daily.csv`, `data/investing/external_factors_daily.csv` — daily inputs to
  instrument construction.

## Three external inputs — two have no producer in this repo

- **`data/yields/yields_dia.csv`** — advisor-supplied yield curve at fixed maturities (3/6/12/24/60/
  120 months, `dd/mm/yyyy`). **There is no fitting stage and no script here writes it, none should,
  and it is not reproducible from this repository.** Treat as read-only. The in-house Svensson fit
  was deleted 2026-07-26 (`historico_decisoes.md` §4) and `R/modeling/svensson_model.R` archived —
  ~600 lines preserved, so re-implementing the curve starts from there. `run_all.R` fails preflight
  with a pointer if the file goes missing.
- **`data/CDS 5y.xlsx`** — daily 5y sovereign CDS (Bloomberg, `BRAZIL CDS USD SR 5Y D14 Corp`).
  Metadata sits in rows 1-5 and the series in columns C:D, hence the `cell_limits(c(7, 3), ...)`
  read. Consumed only by `jk_sovereign_confound.R`; the panel's monthly `cds_5y` comes from
  `download.R` and the two agree at **cor 0.9994** — which is what makes the daily test and the
  monthly IRF the same object rather than homonyms.
- **`data/fomc_dates.csv`** — FOMC decision dates with a `scheduled`/`unscheduled` column. Unlike the
  two above it **has a producer**: `R/data_download/fomc_dates.R`, which scrapes and **enumerates**
  the Fed's archive years rather than hard-coding a range. Hard requirement of `instrument.R` and of
  the `fomc` stage in `run_all.R`.

## Policy variable

Normalization is on **`yield_6m`**. `juros_selic` is overnight Selic accumulated and is the
documented **negative control** — max reduced-form F = 2.49 across the whole grid. Do not promote it
to `mp_var`.

The downloaders guard on `sys.nframe() == 0`, and the stage scripts `rm(list = ls())`, so `run_all.R`
runs one `Rscript` process per stage.
