# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Independent paper replicating Alessi & Kerssenfischer (2019) for Brazil. Estimates a large-scale non-stationary Dynamic Factor Model (DFM), identifies monetary policy shocks via an external instrument (Copom-day DI futures surprises), and traces IRFs of Brazilian asset prices. Inference: wild bootstrap (Gonçalves & Kilian, 2004) with Kilian (1998) bias correction.

Authoritative project context lives in `_instrucoes/contexto.md` (overview) and `_instrucoes/Instrumento.md` (current instrument design). Read these before changing methodology.

## Pipeline and entry points

The project runs as four ordered stages, each driven by a script in `script/`:

1. **`script/download.R`** — pulls BCB series, FX, yield curve raw, asset indices (rb3), risk (EMBI/CDS/MSCI), EPU, inflation. Writes `data/raw_data.csv`. Auxiliary downloaders live in `R/data_download/` (`bcb.R`, `exchange.R`, `external_factors.R`, `ibov_daily.R`, `download_di.py`).
2. **`script/yield_curve.R`** — fits Svensson (`R/modeling/svensson_model.R`) on DI contracts to produce yields at fixed maturities. Output under `data/yields/`.
3. **`script/clean.R`** — log transforms nominal vars, applies X-13 seasonal adjustment via `R/preprocessing/seasonality.R`. Writes `data/processed/data_log_deseasonalized.csv`. (Note: it `source()`s `R/preprocessing/stationarity.R` which does not exist — the call is dead, BLL standardization happens later inside `factor_estimation.R`.)
4. **`script/instrument.R`** — Copom-day DI surprises → 4 monthly instrument variants (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`) per Gertler-Karadi + Jarociński-Karadi sign filter + Bauer-Swanson purification. Writes `data/processed/instrumentos_mensais.csv`, four single-variant CSVs, and the legacy file `data/processed/instrument.csv` (controlled by `DEFAULT_VARIANT`, vertex `TARGET_BD = 126` ≈ 6m DI). Helpers in `R/instrument/di_surprise.R`.
4b. **`script/instrument_het.R`** — heteroskedasticity-identified instrument `z_het` (Rigobon-Sack 2003 *QJE*): daily SVAR over Wed→Thu pairs (DI_3m, DI_2y, IBOV, BRL); regimes C = Copom Wed, NC = others; `b_1 = sqrt(λ_1) v_1` from leading eigenpair of `Sigma_C - Sigma_NC`; daily shock recovered via Mertens-Ravn (2013) GLS projection; aggregated monthly. Writes `data/processed/instrument_z_het.csv` and appends `z_het` column to `instrumentos_mensais.csv`. Primitives in `R/identification/het_shock_extraction.R` (`extract_shock_rigobon_sack`, `validate_variance_split`, `classify_a2_verdict`, `build_het_instrument`). Now also produces a 3-var robustness block (drops DI_2y) — same script writes `instrument_z_het_3var.csv`, `instrument_z_het_jk_3var.csv`, `het_variance_validation_3var.csv`, `het_b_1_3var.csv`. A2 verdict (homoskedasticity of non-policy shocks under 99% bootstrap CI) is reported per variable (column `a2_status` ∈ {`policy`, `pass`, `violated`}) and a warning fires when violated. Methodology detailed in `_instrucoes/Heteroscedasticidade.md`.
4c. **`script/instrument_validation.R`** — robustness suite for the recommended specification `z_het_jk + yield_6m`. Runs (T1) placebo permutation of the monthly instrument, (T2) random-mask vs JK sign filter, (T3) sub-period F across pre-COVID / COVID+post / full-minus-COVID-acute, (T4) monthly correlation with `z_jk_purif`. Reuses `first_stage_F` from `R/identification/validation_tests.R` with full-sample AR(p) residualization (refit-per-window introduces a lag-jump bug on the non-contiguous `drop_covid` window). Writes `output/het_validation_report.md` and per-test CSVs/PNGs. Cross-language replication in `correspondence/referee2/replication/referee2_replicate_validation.py`.
5. **Estimation** — two heads share the same identification module:
   - `script/model_alessi.R` — main DFM (`estimate_dfm` → `compute_irf_dfm` → `plot_irf`, all in `R/modeling/`).
   - `script/model_var.R` — VAR robustness check on the same factors / instrument.

Diagnostics: `script/instrument_diagnostics.R` runs first-stage F (Montiel Olea–Stock–Watson) and the variance F-test across all instrument variants (4 GK + `z_het` 4-var + `z_het_3var` robustness) on a single DFM residual. Reports **two** F-statistics per variant: F (DFM) against the first-factor VAR residual (governs weak-instrument bias inside the proxy-SVAR) and F (y6m AR) against the AR(6) innovation of monthly `yield_6m` (Selic-equivalent relevance — feeds the normalization in `model_alessi.R`); the two can disagree (e.g. `z_het` had F (DFM) ≈ 1.5 vs F (y6m AR) ≈ 7.6). Section 4 of the report shows GRG (2025) Table 1 with `a2_status` column for both 4-var and 3-var blocks, the `dSigma` eigenvalue spectrum, and a side-by-side `b_1` (4-var vs 3-var) — all reading artifacts produced by `instrument_het.R` (`output/het_*.csv`). `script/instrument_grid.R` sweeps DI vertex × purification sample × variant. Reports land in `output/`.

## Identification core (do not silently re-architect)

Two functions in `R/modeling/impulse_responde.R` are the contract between the DFM/VAR and the instrument:

- `sel_ext_inst_sample()` — temporal alignment, equivalent to MATLAB `selextinstsample.m`.
- `ident_ext_instr()` — projects raw IRFs through `H = (Z' rsh) / (Z'Z)` and normalizes the impact response of the policy variable to `shock_size_bps/100` (default 50bp → 0.5). Equivalent to `IdentExtInstr.m`.

The same `ident_ext_instr` consumes `z_het` without any change: only the *origin* of the instrument differs (heteroskedasticity-extracted vs Copom-day timing).

The bootstrap uses Kilian-corrected coefficients for the DGP but the **point estimate uses plain OLS** (faithful to `DFMest_BLL.m`); `apply_kilian = TRUE` only affects the bootstrap. `R/modeling/factor_estimation.R` implements the BLL standardization, Bai-Ng IC for `r`, Amengual-Watson for `q`, plus `infer_tcode_from_varnames()` and `validate_dfm_results()`.

## Common commands

```bash
# Full instrument rebuild + diagnostics (5 variants)
Rscript R/data_download/external_factors.R   # downloads SP500/VIX/Brent + BRL/USD daily
Rscript script/instrument.R                  # 4 GK-style variants
Rscript script/instrument_het.R              # z_het (heteroskedasticity, Rigobon-Sack)
Rscript script/instrument_diagnostics.R      # combined report on all 5
Rscript script/instrument_grid.R             # vertex × purif sweep
Rscript script/instrument_validation.R       # placebo / random-mask / subperiod / correlation
python correspondence/referee2/replication/referee2_replicate_validation.py  # cross-language audit

# Main DFM (long; bootstrap dominated)
Rscript script/model_alessi.R

# VAR robustness
Rscript script/model_var.R
```

There is no test suite, no linter, no build step. Iterate by running the relevant script.

## Conventions

- **Language:** English for variable names and code comments; Portuguese is fine for prose in `_instrucoes/` and `output/*.md`.
- **Plots:** `ggplot2`, paper style — shaded 80% and 90% bands.
- **Factor selection:** use the BLL-standardized variants of Bai-Ng / Amengual-Watson. Plain Bai-Ng (2002) requires stationarity and is the wrong tool here — the panel is non-stationary by design.
- **Comments:** minimal, only at non-trivial technical steps.
- **Reference code:** `codigo_alessi-mark/` (Alessi-Kerssenfischer MATLAB), `codigo_Jarocinski_e_Karadi/` (JK MATLAB), `codigo_bauer_swanson/` (Bauer-Swanson). Treat these as read-only references for translation, not as project code.
- **Articles:** `artigos/` contains source PDFs and marker-extracted `.md` for every reference (Alessi-Kerssenfischer, Gertler-Karadi, Jarociński-Karadi, Bauer-Swanson, Stock-Watson, Montiel Olea-Stock-Watson, Gonçalves-Rodrigues-Genta).

## Data layout

Inputs and intermediate files live under `data/` (gitignored). Key paths the scripts hard-code:

- `data/raw_data.csv` — merged monthly panel from `download.R`.
- `data/processed/data_log_deseasonalized.csv` — input to the DFM (drop `ref.date`, `drop_na`).
- `data/processed/instrument.csv` — single-column instrument consumed by both estimation scripts; overwritten by `instrument.R` from `DEFAULT_VARIANT` (current default: `z_het_jk_3var`, F (y6m AR) = 55.98).
- `data/processed/instrumentos_mensais.csv` — all variants (4 GK + 4 het: `z_het`, `z_het_jk`, `z_het_3var`, `z_het_jk_3var`) side-by-side.
- `data/processed/instrument_z_het{,_jk}{,_3var}.csv` — single-column het instruments (4 files).
- `output/het_variance_validation{,_3var}.csv`, `output/het_eigenvalues{,_3var}.csv`, `output/het_b_1{,_3var}.csv` — diagnostic artifacts produced by `instrument_het.R` and consumed by `instrument_diagnostics.R`. The variance-validation CSVs include `a2_status` and `a2_side` columns.
- `data/di.csv`, `data/yields/`, `data/copom_historico.csv`, `data/processed/ibov_daily.csv`, `data/processed/brl_usd_daily.csv`, `data/investing/external_factors_daily.csv` — daily inputs to instrument construction.

Sample: 2013-01 to 2025-12, monthly, N ≈ 111 series. Policy variable for normalization is **`yield_6m`** (audit-validated 2026-04-25, F = 21.3 against AR(6) innov; `juros_selic` is overnight Selic accumulated and fails Stock-Yogo against `z_het_jk`); shock normalized to +50bp on impact via `mp_var = "yield_6m"` in `script/model_alessi.R`.
