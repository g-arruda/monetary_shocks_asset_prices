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
goes into estimation. Sample: **2012-03 to 2025-12, monthly, 115 series** — the
`drop_setor_externo__eua__credito__imoveis_fiscal_expectations` panel, in production since the
2026-09-02 migration. It drops `juros_cdi` and `asset_mlcx` and adds the fiscal and
Focus-expectations blocks; the 106-series base is kept in `data_log_deseasonalized_base_106.csv`
only to reproduce historical factor grids. (Vintage refreshed
2026-07-24: the duplicated tempo-de-procura block and the empty ANBIMA break-even columns were
dropped, and `download.R` / `clean.R` now persist their outputs via `write_csv` — the old scripts
computed but never wrote.)

A missing input **aborts** with a pointer to the script that produces it. Never an `else` returning
an empty vector, `NA` or a default — that makes "the collection was never run" indistinguishable
from "the collection came back empty", and the error only surfaces months later, in a result.

- `data/raw/raw_data.csv` — merged monthly panel from `download.R`.
- `data/processed/data_log_deseasonalized.csv` — input to the DFM (drop `ref.date`, `drop_na`).
  Written by `clean.R`, which log-transforms and applies X-13 via `R/preprocessing/seasonality.R`.
  **Its column order is part of the spec**: `clean.R` imposes the order every output was estimated
  on, because the ABC selector subsamples the cross-section in column order (a permutation moved
  the pruned panel's ABC from 11 to 7 and flipped R1 of the pruning round) and the PCA rounds
  differently. Never let the order follow `download.R`.
  (The `source()` of `R/preprocessing/stationarity.R` is commented out — **that file never existed**;
  BLL standardization happens inside `factor_estimation.R`.)
- `data/processed/instrument.csv` — single-column instrument consumed by both estimation scripts.
- `data/processed/instrumentos_mensais.csv` — the 3 variants of `tab:first_stage` side-by-side:
  `z_bruto`, `z_bs_purif`, `z_jk_bs_purif`.
- `data/raw/focus_daily.csv` — Focus pre-event predictors from `R/data_download/focus.R`. Since 2026-09-26
  the instrument no longer reads it (the Focus revisions left the
  BS regression on 2026-09-26); `het_rigobon/_common.R` still does.
- `data/raw/focus_current_year.csv` — on branch `feature/focus-horizonte-fixo` (2026-10-03, not
  merged): the Focus median for the **current** year of the six annual series the panel carries as
  "ano seguinte", read on the same survey date, from `script/download_focus_current_year.R`, a
  network stage of its own so it never refreshes the panel. NA where the Focus no longer asks (FX and
  Selic in December, Selic in Nov 2012, 2013 and 2015). `clean.R` combines it with the next-year
  medians of `raw_data.csv` and `focus_fiscal_expectations.csv` into the Dovern-Fritsche-Slacalek
  fixed-horizon series (`expect_focus_*_12m`), and takes the Selic of those three Novembers from
  `copom_historico.csv`. The raw layer keeps the `_ny` names, which stay true there.
  **`data/processed/` is shared by every branch**: after this branch, run
  `Rscript script/run_all.R --only=clean` on `main` before estimating.
- `data/raw/focus_macro_expectations.csv` and `data/raw/macro_released.csv` — the macro news
  block of the BS regression, from `script/download_macro_news.R` (since 2026-09-25,
  in production since 2026-09-26). They hold:
  - the Focus panels of monthly IPCA and quarterly GDP, by survey date and reference period;
  - IPCA and EX0 core from SGS;
  - GDP as first released, read from each IBGE release PDF, because SIDRA keeps only the revised
    vintage.

  Its own network stage, so it runs without refreshing the production panel. Since 2026-10-22 on
  `feature/auditoria-janelas-copom` it also writes `data/raw/epu/us_daily_policy_uncertainty.csv`, the
  Baker-Bloom-Davis daily US EPU (code brought from `feature/placebo-epu`; the file on disk is that
  branch's download of 2026-09-29). It never enters the instrument: only `script/placebo_holm.R` reads
  it, for the EPU-trend test of §5.2.
- `data/raw/di.csv`, `data/raw/copom_historico.csv`, `data/raw/ibov_daily.csv`,
  `data/raw/investing/external_factors_daily.csv` — daily inputs to instrument construction, with
  the two macro news files above. `script/instrument.R` reads no exchange rate.
- `data/raw/brl_usd_daily.csv` — Yahoo `BRL=X`, daily, from `download.R`. **Since 2026-10-13 it is
  the only daily exchange rate of every result** (author decision): the Copom-day window of
  `script/daily_event.R`, the conference of `script/copom_timing.R` and the daily row of Anexo B in
  `script/het_conditions.R`. Read it through `load_yahoo_brl()` (`R/instrument/di_surprise.R`),
  which attaches each row's quote time. Yahoo stamps each bar at the London midnight that opens it, the
  close is the rate at that instant, and the file's date is that instant's in UTC. Under British summer
  time the rows run Sunday–Thursday and the row dated d is d's evening, 20h in Brasilia. Outside it the
  rows run Monday–Friday and the row dated d is d−1's evening, 21h or 22h. The time is **inferred, not
  declared**. Since 2026-10-18 the stamps themselves are on disk, `data/raw/brl_usd_daily_stamps.csv`
  from `script/download_yahoo_stamps.R` (network stage `yahoo_stamps`): every one is 00:00 London, and
  `copom_timing.R` checks that each file row is its stamp's UTC date with the same close (quantmod dates
  bars with `as.Date()` in UTC), writing `output/copom_timing/yahoo_rows.csv`
  (`notas/2026-10-18_conferencias_ponte.md`). Wednesday's evening quote follows the announcement in 96 of the 102 events, so the
  convention's window usually runs from Tuesday's evening quote to Wednesday's, and a Wed→Thu change
  read off the dates **misses the announcement in the 51 European-summer events**. The old "45 winter
  events precede it" reading was wrong. Never difference it by date for an event window; use the
  `yahoo_pre`/`yahoo_post` rows of `output/copom_timing/meetings.csv`
  (`notas/2026-10-13_cambio_yahoo_convencao.md`). The advisor does not take the API's time zone as
  the quote's time (e-mail of 2026-10-14), so that window may not be presented as a narrow one proven
  to straddle the announcement. The wide window he asked for, the row dated Tuesday to the row dated
  Thursday by the rows' dates, is `yahoo_wide_pre`/`yahoo_wide_post` of the same file
  (`notas/2026-10-15_conferencia_reunioes_fora.md`).
- `data/raw/msci_em.csv` — on branch `feature/focus-horizonte-fixo` (2026-10-12, not merged): the
  MSCI Emerging Markets index (MSCI code 891800, price index in USD, standard variant), end-of-month
  levels from MSCI's own index-level service, written by `script/download_msci.R`, the `msci`
  network stage of its own. **It is the panel's `msci`**: `clean.R` puts it in that column, at the
  column's place (85th of the production panel). `data/raw/investing/msci.csv`, which `download.R`
  read as `msci` until then, is the share price of **MSCI Inc.** (NYSE: MSCI), not the index
  (`notas/2026-10-09_placebos_holm.md`, section 4); on this branch `download.R` no longer reads it
  and writes 112 series. ⚠ **`data/raw/` is shared by every branch**: `main` still reads
  `investing/msci.csv` through `raw_data.csv`, so the file stays on disk, and running this branch's
  `download.R` drops `msci` from the shared `raw_data.csv`, which leaves `main`'s `clean.R` with
  114 series. The `raw_data.csv` on disk predates the change and still carries the share price,
  which this branch's `clean.R` overwrites (`notas/2026-10-12_msci_emergentes.md`).
- `data/raw/ptax_daily.csv` — on branch `feature/focus-horizonte-fixo` (2026-10-05, not merged):
  the daily PTAX (SGS 1, selling quote, average of the 10h–13h windows), from
  `script/download_ptax.R`, the `ptax` network stage of its own. It was the Copom-day exchange rate
  of `script/daily_event.R` (Wed 13h → Thu 13h) until 2026-10-13. From then until 2026-10-15 it was
  only a 13h clock, in two diagnostics: the alignment that dates the Yahoo quote (`fx_alignment.csv`)
  and CDS test (B) of `copom_timing.R`, whose rule was fixed before it ran. Since 2026-10-15, by
  author decision following the advisor's e-mail of 2026-10-14, it is also a diagnostic window beside
  the Yahoo, Wednesday's PTAX to the first one after it, described as a wider daily window that takes
  in other news: `ptax_pre`/`ptax_post` of `output/copom_timing/meetings.csv`
  (`notas/2026-10-15_conferencia_reunioes_fora.md`).
- `data/raw/copom_atas.csv` — on branch `feature/focus-horizonte-fixo` (2026-10-13, not merged): the
  Copom minutes of meetings 165 to 275 from the BCB API (`atas_detalhes`), raw text, HTML for 79 and
  `pdftotext` of the PDF for meetings 200 to 231, written by `script/download_copom_minutes.R`, the
  `copom_atas` network stage. Each minute states when every session started and ended;
  `script/copom_timing.R` reads the announcement time off it. **The Copom-day times**
  (`notas/2026-10-13_ponte_horarios_copom.md`): the statement comes after the second day's last
  session, at 19h19–20h55 until 2016-06, at 18h00–18h20 until 2020-10 and at 18h30–19h12 after,
  always after the DI close; the Yahoo quote is 20h–22h. ⚠ The CDS xlsx's `PX_LAST` closing time is unknown
  (New York by Bloomberg's documentation, not fixed by the data), so its Wed→Thu change follows the
  convention only under a London close. **Since 2026-10-14 the author fixes the close at 17h New York**
  (`cds_pre_ny17`/`cds_post_ny17` of `meetings.csv`; `notas/2026-10-14_ponte_trajetoria_evento.md`):
  bridge (a) uses it, `daily_event.R` since 2026-10-18 and the daily row of Anexo B in `het_conditions.R`
  since 2026-10-23, where the weeks without a meeting take the window of an 18h Wednesday release
  (`notas/2026-10-23_linha_diaria_anexo_b.md`). The
  daily exchange rate is always Yahoo `BRL=X`, never the PTAX (author decision, same day). ⚠ The instrument drops the 7 meetings whose Thursday is a
  Brazilian holiday and the 2 on Thanksgiving, and their months enter at z = 0. Since 2026-10-17, on
  `feature/auditoria-janelas-copom`, all 111 are events, the 7 with the window Wednesday to Friday, and
  only the sensitivity instrument leaves those 7 out. On that branch `copom_timing.R` classifies each
  quote of the 9 as pre, post or ambiguous (`excluded_meetings_advisor.csv`, where the Yahoo and CDS
  times read "not documented by the provider"); they stay hypotheses
  (`notas/2026-10-17_auditoria_janelas_copom.md`).

## Two external inputs with no producer in this repo

- **`data/raw/yields/yields_dia.csv`** — advisor-supplied yield curve at fixed maturities (3/6/12/24/60/
  120 months, `dd/mm/yyyy`). **There is no fitting stage and no script here writes it, none should,
  and it is not reproducible from this repository.** Treat as read-only. The in-house Svensson fit
  was deleted 2026-07-26 (`historico_decisoes.md` §4) and `R/modeling/svensson_model.R` archived —
  ~600 lines preserved, so re-implementing the curve starts from there. `run_all.R` fails preflight
  with a pointer if the file goes missing.
- **`data/raw/CDS 5y.xlsx`** — daily 5y sovereign CDS (Bloomberg, `BRAZIL CDS USD SR 5Y D14 Corp`).
  Metadata sits in rows 1-5 and the series in columns C:D, hence the `cell_limits(c(7, 3), ...)`
  read (`readxl::read_excel(skip = 5)` does the same). Its first consumer,
  `jk_sovereign_confound.R`, was archived to `arquivo/script/` on 2026-09-17; it is read live by
  `script/het_conditions.R` and, on branch `feature/focus-horizonte-fixo`, by
  `script/daily_event.R`. The panel's monthly `cds_5y` comes from `download.R`, and the two agree
  at **cor 0.9994** — which is what makes the daily test and the monthly IRF the same object
  rather than homonyms.
- `data/raw/fomc_dates.csv` and `data/raw/fred_dgs2.csv` are **no longer produced or read** since
  2026-09-18: their only consumer was the FOMC/UST purification that left the instrument with the
  archived FOMC test. Copies on disk are inert.

## Policy variable

Normalization is on **`yield_6m`**. `juros_selic` is overnight Selic accumulated and is the weaker
normalization target by a wide margin in the full sample — over `output/irf/spec_sweep_cells.csv` its
best cell reaches ξ_mp 5.20 and F_rob 7.03 against 10.73 and 12.67 for `yield_6m`. Do not promote it
to `mp_var`. Two cautions the old "negative control, max F = 2.49" wording hid: **pre-COVID the Selic
normalization does reach ξ_mp 21.54**, so the argument is a full-sample argument; and under the
111-series `(5,5)` production `juros_selic` is no longer inert as a *response* either, rising 23.8 bp
on impact with the 90% band excluding zero through h=11.

`run_all.R` runs one `Rscript` process per stage, so no stage sees another stage's workspace; the
stage scripts do not clear the environment themselves.
