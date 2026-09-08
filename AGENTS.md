# Repository Guidelines

## Project and authoritative context

This project adapts Alessi and Kerssenfischer's large-dimensional DFM identification strategy to Brazilian monetary shocks and asset prices. Before proposing methodology or interpreting results, read `README.md`, `registro/metodo.md`, `registro/pendencias.md`, and `registro/historico_decisoes.md`. The decision history is mandatory: do not revive rejected specifications or re-derive closed questions without new evidence. Use the dated working notes and generated reports as provenance, and heed banners marking an analysis as superseded. `notas/_indice.md` names the current DFM production note and flags which artifacts still belong to an older vintage. `registro/pendencias.md` was zeroed on 2026-09-08 by author decision (scope reset, not a verdict on any item); its cut items remain recoverable via `git log -p -- registro/pendencias.md`. `email/` holds the running, verbatim email exchange with the advisor, one file per message.

The current paper is `paper/paper_anpec.tex`. `arquivo/tex/` is an archived prose source, not an active manuscript. The written results source is `output/irf/irf_section.md`; confirm numerical claims against the underlying CSV/RDS artifacts. As of 2026-09-08, the paper and `irf_section.md` still describe the prior 115-series, 2013-01--2025-09 production window at `(r,q,p)=(4,4,4)` — one vintage behind the code (see below); do not treat their numbers as current without checking `notas/_indice.md` first.

## Pipeline

Run from the repository root. The main order is:

1. `script/download.R` writes `data/raw/raw_data.csv`.
2. `script/clean.R` writes `data/processed/data_log_deseasonalized.csv`.
3. `script/instrument.R` builds the eight monthly instrument variants through `R/instrument/build_variants.R`.
4. `script/model_alessi.R` estimates the DFM; `script/model_var.R` is the small-VAR benchmark.
5. `script/run_all.R` orchestrates declared stages and prerequisites.

Read `script/README.md` before selecting diagnostics or validation scripts. Run only the relevant stage for local changes; expensive production/bootstrap runs require deliberate scope. There is no conventional unit-test suite, linter, or package build. Validation scripts and their committed fixtures are the executable checks. Preserve their fail-loud behavior and inspect `git diff --check` plus explicit `git status --short` paths before committing.

## Identification and model invariants

- The production instrument is `z_jk_bs_purif`, selected by `DEFAULT_VARIANT`. The eight surviving variants and their exact construction are defined in the current instrument documentation and builder; do not reconstruct them from prose or archived code.
- `data/raw/fomc_dates.csv` is a hard input to the instrument stage and is produced by `script/download.R` through `R/data_download/fomc.R`. Missing event-date data must abort, never become an empty silent fallback.
- `data/raw/yields/yields_dia.csv` and `data/raw/CDS 5y.xlsx` are fixed external inputs with no repository producer. Treat them as read-only. Do not claim the yield curve is reproducible from this repository.
- The production monthly sample is 2012-03 through 2025-12 (166 months, 162 factor innovations after `p=4`) with 115 series (`drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, read from `R/modeling/production_spec.R`); the 106-series base is retained only for historical factor-grid reproduction. Production uses `(r,q,p)=(5,5,4)`, with `r=5` selected by the BLL Bai–Ng surface (`r=1,...,20`: IC1=IC2=5, IC3=20), `q=r=5` as the operational decision, and `p=4` inherited from the prior vintage (an AIC check on the extended common sample, `T=154`, still picks `p=4` at 8.231267; BIC still picks `p=2`). The estimated factor VAR remains intercept-only. The policy normalization variable is `yield_6m`, with a +50 bp impact shock. The frozen cell has ξ_mp = 6.057014 full / 8.643436 pre-COVID, F_rob,mp = 9.625428 / 13.809985, both companions stable (0.970090 / 0.993359).
- The only active small-VAR benchmark is `ibc5_fx_cds_level_trend_p2`. It uses `ibc_br`, `price_ipca`, `yield_6m`, `cambio_usd`, and `cds_5y` in levels, with a constant and linear trend in every equation. AIC and BIC use a common 141-observation sample; production uses `p=2`, selected by AIC. Its published responses are horizon-specific `C_h B_1` estimates with VAR-only Anderson--Rubin/MOSW sets at 68% and 90% under NW(0). Do not add sensitivity cells, sum responses across horizons, or restore bootstrap inference for this benchmark.
- Use `res$irfs`, not `res$irf`, and recover variable names from the estimation data. Preserve the documented factor-space dimensions and normalization when comparing IRFs.
- Factor selection uses the BLL-standardized Bai–Ng/Amengual–Watson variants. Plain Bai–Ng (2002) is inappropriate because the panel is non-stationary by design.
- Weak-IV conclusions are governed by the factor-space MOSW statistics, not by legacy first-stage rulers alone. The operational DFM inference uses the 68%/90% wild-bootstrap bands; Anderson–Rubin inference **for the DFM** is deferred until it has a theoretical basis or a procedure that incorporates factor estimation. The small-VAR benchmark is a different object: it carries AR/MOSW confidence sets by test inversion (`R/identification/weak_iv_ar.R`, VAR-only by construction), because a VAR of observables has no generated regressors. Those sets are inference for the VAR, never for the DFM, and weak-IV robustness is not instrument validity — both models use the same proxy. Do not change confidence-band interpretation or attribution without checking the current reports and pending-items file.

For changes to the estimation core, reproduce the current impact smoke test documented in the source guidance or current validation scripts before accepting results. Compare at least `yield_6m`, `yield_2y`, `yield_5y`, `asset_ibov`, and `cambio_usd`; do not update expected values merely to make a changed implementation pass.

## Repository boundaries

- `R/` contains reusable modules; nothing there should source a file from `script/`.
- `script/` contains entry points and diagnostics. Keep orchestration out of reusable modules.
- `diagnostics/` audits the production artifacts and must not mutate estimation code or production outputs.
- `codigos_externos/` is gitignored, read-only reference code. Production and validation paths must use project-owned implementations or committed fixtures.
- `arquivo/` is preserved historical material. No live path may source from it or write into it.
- `data/` is gitignored, in two levels: `data/raw/` is untreated download output and is never hand-edited; `data/processed/` is what goes into estimation. `output/` contains tracked estimation artifacts (except `output/logs/`); regenerate only those owned by the stage you ran and record the producing script.
- The record splits three ways and the three never mix. `registro/` is the living memory, edited in place: `metodo.md` (the design), `pendencias.md` (what is open), `historico_decisoes.md` (what died and why). `notas/` is the evidentiary record: one dated, append-only note per round, carrying a vintage banner — this is what the paper pulls numbers from. `pareceres/` is what outside reviewers sent in, kept verbatim. `email/` is the running email exchange with the advisor, one file per message (`email_{meu,professor}_DD-MM_HHhMM.md`), kept verbatim like `pareceres/` but ongoing rather than a single delivered document. `progress_logs/` is session continuity and is disposable. Never write a session log into `notas/`, and never leave a durable result in `progress_logs/`.

## Coding, figures, and prose

Use English for code, identifiers, and code comments; Portuguese is appropriate in `registro/`, `notas/`, `pareceres/`, `email/`, reports, and the paper. Keep comments limited to non-obvious methodological choices. Use `ggplot2` for paper figures and preserve the established shaded 80% and 90% band style. Fail clearly on missing inputs, dimension mismatches, and invalid numerical states. Never fabricate fallback data or silently substitute a different estimator.

When results change, distinguish a specification change from an implementation bug, update the relevant authoritative note/report, and keep generated prose synchronized with source tables. Do not describe 68% bands as statistical significance where the project's two-tier reading rule reserves “significativo” for the 90% band.

## Git hygiene

The worktree often contains active research changes and regenerated artifacts. Preserve unrelated modifications, stage explicit paths only, and never use broad staging. Commit messages should describe the research, identification, code, or result change. Do not add AI attribution.
