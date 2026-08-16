---
paths:
  - "script/download.R"
  - "script/clean.R"
  - "script/run_all.R"
  - "R/data_download/**"
  - "R/preprocessing/**"
---

# Data layout

Inputs and intermediate files live under `data/` (gitignored), in two levels: **`data/raw/`** is
what comes out of the downloads, untreated and never hand-edited; **`data/processed/`** is what
goes into estimation. Sample: **2013-01 to 2025-09, monthly, 111 series** — the
`drop_setor_externo__eua__credito__imoveis` panel, migrated 2026-08-13. It drops `juros_cdi` and
`asset_mlcx` and adds the fiscal and Focus-expectations blocks; the 106-series base is kept in
`data_log_deseasonalized_base_106.csv` only to reproduce historical factor grids. (Vintage refreshed
2026-07-24: the duplicated tempo-de-procura block and the empty ANBIMA break-even columns were
dropped, and `download.R` / `clean.R` now persist their outputs via `write_csv` — the old scripts
computed but never wrote.)

A missing input **aborts** with a pointer to the script that produces it. Never an `else` returning
an empty vector, `NA` or a default — that makes "the collection was never run" indistinguishable
from "the collection came back empty", and the error only surfaces months later, in a result.

- `data/raw/raw_data.csv` — merged monthly panel from `download.R`.
- `data/processed/data_log_deseasonalized.csv` — input to the DFM (drop `ref.date`, `drop_na`).
  Written by `clean.R`, which log-transforms and applies X-13 via `R/preprocessing/seasonality.R`.
  (The `source()` of `R/preprocessing/stationarity.R` is commented out — **that file never existed**;
  BLL standardization happens inside `factor_estimation.R`.)
- `data/processed/instrument.csv` — single-column instrument consumed by both estimation scripts.
- `data/processed/instrumentos_mensais.csv` — the 8 GK-family variants side-by-side: `z_bruto`,
  `z_bruto_purif`, `z_jk`, `z_jk_purif`, `z_jk_raw_purif`, `z_jk_raw`, `z_bs_purif`, `z_jk_bs_purif`.
- `data/processed/focus_daily.csv`, `data/raw/fred_dgs2.csv` — pre-event predictors from
  `R/data_download/focus_fred.R`.
- `data/raw/di.csv`, `data/raw/copom_historico.csv`, `data/processed/ibov_daily.csv`,
  `data/processed/brl_usd_daily.csv`, `data/raw/investing/external_factors_daily.csv` — daily inputs to
  instrument construction.

## Three external inputs — two have no producer in this repo

- **`data/raw/yields/yields_dia.csv`** — advisor-supplied yield curve at fixed maturities (3/6/12/24/60/
  120 months, `dd/mm/yyyy`). **There is no fitting stage and no script here writes it, none should,
  and it is not reproducible from this repository.** Treat as read-only. The in-house Svensson fit
  was deleted 2026-07-26 (`historico_decisoes.md` §4) and `R/modeling/svensson_model.R` archived —
  ~600 lines preserved, so re-implementing the curve starts from there. `run_all.R` fails preflight
  with a pointer if the file goes missing.
- **`data/raw/CDS 5y.xlsx`** — daily 5y sovereign CDS (Bloomberg, `BRAZIL CDS USD SR 5Y D14 Corp`).
  Metadata sits in rows 1-5 and the series in columns C:D, hence the `cell_limits(c(7, 3), ...)`
  read. Consumed only by `jk_sovereign_confound.R`; the panel's monthly `cds_5y` comes from
  `download.R` and the two agree at **cor 0.9994** — which is what makes the daily test and the
  monthly IRF the same object rather than homonyms.
- **`data/raw/fomc_dates.csv`** — FOMC decision dates with a `scheduled`/`unscheduled` column. Unlike the
  two above it **has a producer**: `R/data_download/fomc_dates.R`, which scrapes and **enumerates**
  the Fed's archive years rather than hard-coding a range. Hard requirement of `instrument.R` and of
  the `fomc` stage in `run_all.R`.

## Policy variable

Normalization is on **`yield_6m`**. `juros_selic` is overnight Selic accumulated and is the weaker
normalization target by a wide margin in the full sample — over `output/irf/spec_sweep_cells.csv` its
best cell reaches ξ_mp 5.20 and F_rob 7.03 against 10.73 and 12.67 for `yield_6m`. Do not promote it
to `mp_var`. Two cautions the old "negative control, max F = 2.49" wording hid: **pre-COVID the Selic
normalization does reach ξ_mp 21.54**, so the argument is a full-sample argument; and under the
111-series `(5,5)` production `juros_selic` is no longer inert as a *response* either, rising 23.8 bp
on impact with the 90% band excluding zero through h=11.

The downloaders guard on `sys.nframe() == 0`, and the stage scripts `rm(list = ls())`, so `run_all.R`
runs one `Rscript` process per stage.
