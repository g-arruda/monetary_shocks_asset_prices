# CLAUDE.md

**What belongs here:** invariants, entry points and the rules that govern what may be *claimed*.
**What does not:** research findings — numbers copied here go stale, numbers in the record do not.
**A finished round goes into its note and `notas/_indice.md`, never here.** This file changes only
when an invariant, a rule or the list of open branches changes.
Area-specific detail lives in `.claude/rules/` and loads when you touch that area.

## Project

Independent paper replicating Alessi & Kerssenfischer (2019) for Brazil: large-scale non-stationary
Dynamic Factor Model, monetary shocks identified by an external instrument (Copom-day DI futures
surprises), IRFs of Brazilian asset prices. Inference: Anderson–Rubin sets by test inversion
(Montiel Olea, Stock & Watson 2021); the wild bootstrap and the Kilian correction left the code on
2026-09-18. Canonical paper: `paper/paper.tex`, figures in `paper/img/`
(`registro/mapa_renomeacoes.md` translates the pre-2026-09-30 paths found in notes).

The record, in `registro/`: `metodo.md` (the live design — instrument construction and the
identification chain), `pendencias.md` (what is open), `fechados.md` (what closed, not read at session start), `historico_decisoes.md` (what died and why —
**read before proposing a methodological direction**); plus `notas/`, dated, carrying vintage
banners and indexed with a verdict each in `notas/_indice.md`, `pareceres/`, what outside reviewers
sent in, and `email/`, the running email exchange with the advisor.

## Production spec — the invariant that costs most to get wrong

**`z_bs_purif` × `yield_6m` × (r=5, q=5, p=4), +50bp**, with AR sets at **80/90%**, under the
Lenza-Primiceri (2022) COVID volatility scale in the factor VAR. The JK sign filter left production on
2026-09-26 (author decision, `historico_decisoes.md` §19); the paper mentions it only in one §3.4
footnote on why it is out, and §2 cites JK as literature.

- **No spec object.** `R/modeling/production_spec.R` was deleted on 2026-09-21 (author decision,
  `historico_decisoes.md` §14): every path, dimension, window and switch is a literal in a constants
  block at the top of the script that uses it. The **canonical declaration** of the specification —
  and the check that data, panel, instrument, strength and impacts still match it — is
  `script/validation/validate_production_spec.R`; when a literal and that file disagree, that file
  is right.
- **θ̂ is an estimate, never a literal.** It is read from `output/factors/covid_volatility_theta.csv`
  by `read_covid_volatility()`; `script/covid_volatility_theta.R` is its sole producer and the only
  script that must not read it. `t*` = 2020-03, `innovations = "standardized"`.
- **Panel:** the 115-series `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03
  through 2025-12 (166 months, 162 factor innovations after `p=4`). The 106-series base exists only
  for historical factor-grid reproduction.
- **Dimensions:** `r=5` from the BLL Bai–Ng surface (IC1 = IC2 = 5); `q=r` is the operational
  decision; `p=4` is inherited from the prior vintage rather than reselected (the AIC still picks 4,
  the BIC 2). The factor VAR is intercept-only.
- **Two windows, one estimator.** The full window is weighted least squares; every month of the
  pre-COVID window has `s_t = 1`, so its weighted fit *is* the unweighted one (N1/N2 of
  `script/validation/validate_covid_volatility.R`), and `estimate_dfm()` rejects a `covid_start`
  outside its residual months. Contrasts between the two windows are contrasts of window, not of
  estimator.
- **Under the scale `r ≥ 7` is explosive on the full window**, so the strength grid sweeps r=4:6
  there and r=4:8 pre-COVID. The scale is reweighting of the estimation, **not** heteroskedasticity
  identification.
- **ξ_mp is the strength ruler of record.** The AR set at level κ is bounded iff ξ_mp > κ; 10 is the
  conventional reference for approximately valid conventional bands, and production is below it in
  both windows. Legacy first-stage F rulers still print but stopped deciding on 2026-07-26. The
  values are pinned by `validate_production_spec.R`.

**Open branches.** Each pins its own values in the validators and in
`output/validation/production_spec_impact_smoke.csv`; `main` is an ancestor of the first two.

- `feature/focus-horizonte-fixo` — the six Focus annual series at the Dovern-Fritsche-Slacalek (2012)
  fixed 12-month horizon (`_ny` → `_12m`), and `msci` as the MSCI Emerging Markets index instead of
  the MSCI Inc. share price; steps 0–4 of the advisor's 03-10 plan and the bridge. Notes
  `2026-10-03_focus_horizonte_fixo` through `2026-10-15_conferencia_reunioes_fora`.
- `feature/auditoria-janelas-copom` (contains the previous one) — the instrument on all 111 Copom
  meetings (`holiday_windows = TRUE`, the S&P 500/VIX/Brent filter removed), the 104 without the seven
  holiday windows as the sensitivity. ⚠ Part of the downstream outputs is still on the 102
  (`registro/pendencias.md`, Theme B). Notes `2026-10-17_auditoria_janelas_copom`,
  `2026-10-18_conferencias_ponte`.
- `feature/placebo-epu` — the US EPU as an orthogonalization control. It diverged from `main`, carries
  the control in production code and cannot be merged as is. Note `2026-09-29_placebo_epu`, only on
  that branch.

`data/processed/` is shared by every branch and not versioned: after a branch run, run
`Rscript script/run_all.R --only=clean` on `main` before estimating (and `--only=instrument` when
moving between the two branches).

**Small-VAR benchmark.** The only active one is **`ibc5_fx_cds_level_trend_p4`**: `ibc_br`,
`price_ipca`, `yield_6m`, `cambio_usd` and `cds_5y` in levels, constant and linear trend in every
equation, on the DFM's window and `p=4` so that the contrast is between models rather than between
samples or lag orders. `p=4` is a **comparability choice and not the AIC's**. Its responses are
horizon-specific `C_h B_1` estimates with VAR-only AR/MOSW sets at 80/90% under NW(0). Do not add
sensitivity cells, sum responses across horizons, or restore bootstrap inference for it. Detail in
`.claude/rules/identification.md`.

## Pipeline

Three ordered stages plus estimation, one `Rscript` process each, orchestrated by `script/run_all.R`:

1. **`script/download.R`** → `data/raw/raw_data.csv` with 113 monthly series plus every reproducible
   daily raw input (BCB, Focus, Yahoo, B3, IPEA, SIDRA). Auxiliary functions in
   `R/data_download/` never execute or write on source. **`script/download_macro_news.R`** (stage
   `macro_news`) adds the inputs of the BS macro news block in a network stage of its own, so that it
   never refreshes the panel.
2. **`script/clean.R`** → `data/processed/data_log_deseasonalized.csv` (log + X-13).
3. **`script/instrument.R`** → the monthly instrument via `R/instrument/build_variants.R`:
   `z_bruto` and `z_bs_purif` (production), the two rows of `tab:first_stage`, plus `z_jk_bs_purif`,
   still built but out of the paper.
4. **Estimation** — `script/model_alessi.R` (main DFM; the pipeline itself is `main_sdfm()` in
   `R/modeling/dfm_pipeline.R`) and `script/model_var.R` (small-VAR **benchmark**; it does not use the
   factors).

`script/irf_coherence_check.R` runs the production spec once and writes
`output/irf/irf_coherence_h.csv` — point + 80/90 Anderson–Rubin sets + `set_type` + flags, **the
source of §4's inference** — plus `irf_coherence_cell.rds`, the cached estimation object follow-up
analyses reuse instead of re-estimating. The cells the `hac_dim < T` gate blocks are recorded in
`output/irf/ar_bands*`, written by the archived `arquivo/script/ar_bands.R`. Catalog of the scripts
in `script/README.md`; repo map in `README.md`.

## Rounds

Every finished round has a dated note, and `notas/_indice.md` gives each one its verdict (CURRENT,
superseded, contradicted) and the vintage it was written under. Cite the note, never a summary of
it. Rounds whose script sits in `arquivo/script/` were archived on 2026-09-17 or 2026-09-18: their
outputs stay in `output/`, but the script is not maintained and most no longer run
(`arquivo/README.md`).

## ⚠ Prohibitions

These govern what may be **said**, so they apply even when no file is open.

### What the paper may not claim

- **The lower band is never "significant".** Two-tier rule: 90% band excluding zero →
  *significativo*; the 80% level only → **direction and magnitude**, labelled as such.
- **The 80/90% Anderson–Rubin sets are the sole operational inference for the DFM** since
  **2026-09-08** (author decision; it reverses the 2026-08-12 withdrawal, `historico_decisoes.md`
  §7). `compute_irf_dfm(inference=)` is the single switch (`"ar"`, or `"none"` for the point alone)
  and has no default; every production call site writes `"ar"`. Two things are true of the sets:
  the plug-in covariance conditions on the estimated `Λ`, `K`, `M`, `sy` and θ̂; and
  `mosw_rform_cov` needs `hac_dim < T`, which **blocks** `(r,q)=(8,8)` at `p=4` and the **whole
  pre-COVID window** at `p=4`. No pseudo-inverse, no substitute bootstrap, no fallback — a blocked
  cell is reported blocked, in code, in `output/` and in the record. **The paper's prose carries
  neither caveat** (author decision of 2026-09-16 and 2026-09-17), so nothing in it may
  *contradict* them: no pre-COVID band may be published, and no `(8,8)` number may appear as
  inference. How the gate relates to MOSW's own condition is in `.claude/rules/identification.md`.
- **Significance is "the set excludes zero", read off the topology.** An AR set need not be an
  interval: `two_rays` excludes zero only when zero falls in its gap, `real_line` never does, and
  `empty` is a misspecification signal that scoring must not read as a sign. `ar_excludes_zero()`
  is the only place that rule lives. The set is bounded at level κ **iff ξ_mp > κ**. The unbounded
  `(5,2)` example of `arquivo/script/ar_bands.R` is the **untreated** model; under the production
  scale that cell is bounded.
- **The small-VAR benchmark's AR/MOSW sets are inference *for the VAR*, never for the DFM.**
  Coincidence licenses only "the central pattern is robust to weak-IV inference in an alternative
  lower-dimensional specification" — **never** "the SVAR proves the SDFM right". Weak-IV robustness
  is **not** instrument validity: both models use the same proxy, so a contaminated proxy fails in
  both.
- **No text may credit the `cumsum` fix with recovering the asset block.** At h=0 the `cumsum` is a
  no-op and the ×100 is a positive scalar on point and both bounds, so **h=0 significance is
  invariant to tcode**. Only the panel representation recovers the block, and it was declined. The
  2026-08-17 fix (`asset_*` from tcode 2 to tcode 6, ×100 without accumulating) made the block's
  significance worse away from h=0; what it delivered is band behaviour (`historico_decisoes.md`
  §3.1).
- **The paper has one identification: the external proxy.** Heteroskedasticity and non-Gaussian
  (GMR) identification were abandoned on 2026-08-17 and may not be cited as corroboration, as a
  robustness leg, or as an alternative estimate. `goncalves2025` stays cited: that is *other
  people's* daily het-identified evidence the paper argues with, not this project's route. The
  Lenza-Primiceri scale in the factor VAR (production since 2026-09-17) is no exception: it
  reweights the estimation, identifies nothing, and its sets condition on θ̂.
- **The VAR benchmark tests DFM-vs-small-VAR, not "vs the literature"**, which uses Cholesky.
- **ξ_mp ≥ 10 is the Staiger-Stock rule of thumb** for the homoskedastic 2SLS first-stage F, **not an
  MOSW result**. §3.4 names it generically ("referência convencional") because a Staiger-Stock entry
  would be a 26th key in a 25-key budget. Any rewrite must not silently re-attribute the 10 to
  `montielolea`.
- **The state-dependence persistence result is suggestive, not central** — marginal p, found after
  looking, needs the three specs side by side.
- **Report the inconvenient number too.** The daily GRG replication that vindicates the FX result
  gives the **wrong sign for equities** — they are unidentified in that daily system.
- **Level series (tcode 1) are reported in their own units** — FX in R$ per unit of foreign
  currency, activity indices in index points — never as a percentage of the sample mean
  (2026-09-27; the log panel was refused, `historico_decisoes.md` §20).
- **`q = r` is defended by Stock-Watson (2016, §7.2) and AK (footnote 4), not by insensitivity.** At
  `q ≤ 3` impacts grow and leave the `q = 5` set even under the scale, which shows *less* sensitivity
  to `q` than OLS, not insensitivity. The body cites no number from the `q` exercise, nor from any
  Anexo C figure. The untreated (OLS) model appears in the paper only as the right-hand column of
  `fig:lp_sensibilidade`.
- **A pre-COVID point inside the full-window set is not a test of equality.** Nothing may be
  written as "the results hold pre-COVID" beyond the impact direction and magnitude of the curve
  and sovereign risk.

### What does not reproduce — do not cite

- **Sovereign-confound tests B and D** (three-way split; dated 95-row table), cut 2026-08-10.
- **FOMC test 4** (the FOMC/non-FOMC split), cut 2026-08-10. Removing a leg that *passed* makes the
  reading rule strictly more permissive, so no verdict changed — but the numbers are gone.
- For both the record is in git, the rationale in `historico_decisoes.md` §2.4.

### Do not reopen without new evidence

- The **DI vertex** (126 bd) — settled by the construction sweep.
- The **log-level equity panel** — author decision, `historico_decisoes.md` §3.1.
- A **VECM** — the Johansen rank is not identified and the levels VAR is consistent regardless
  (Sims-Stock-Watson 1990; AK's own §2.2 defence).
- **Heteroskedasticity and non-Gaussian (GMR) identification** — both abandoned on **2026-08-17**
  (`historico_decisoes.md` §0, §1; artefacts in `arquivo/heterocedasticidade/` and
  `arquivo/nao_gaussiana/`). GMR has no power on this panel because DFM aggregation destroys the
  non-Gaussianity; conditional het (GARCH-SVAR) and LMS (2017) die with them, never attempted.
  Since 2026-09-21 the **diagnostic** half is live — `R/identification/het_tests.R` and
  `script/het_conditions.R`, which §3.3 and Anexo B publish — while `ident_het_regimes()` and
  `het_shock_extraction.R` stay deleted. `het_rigobon/` builds exploratory responses from the
  identified column and is **quarantined**: `compute_irf_dfm()` has no `"het"` branch, and nothing
  from that folder may be cited as corroboration, robustness or an alternative estimate without a
  separate author decision. Heteroskedasticity-robust *inference* is untouched — the AR sets and the
  HAC first stage are heteroskedasticity-robust.
  - **One test** (2026-09-22, `historico_decisoes.md` §18): Rigobon's rank condition, the
    distinctness of the eigenvalues of `Λ` in `Σ_NC = BB'`, `Σ_C = BΛB'`, by the sequential `Qr` of
    Lütkepohl, Meitz, Netšunajev and Saikkonen (2021) via `svars`. Five home-grown statistics —
    Mauchly's proportionality LR, the λ₁–λ₂ gap, `ratio_dir`, `rank1_share` and the permutation
    placebo — are retired, and every number they produced is **discontinued** and may not be
    reported or cited. `svars::id.cv()` is never called directly (`.claude/rules/identification.md`).
  - **The series are `goncalves2025`'s own, on both sides** — the Wed→Thu change in the DI, BRL/USD
    and the 5-year sovereign CDS; no Ibovespa and no 2-year DI. Their fourth series, a breakeven
    inflation expectation, is not in this panel, and the gap is declared. The DI vertex is reported
    as a row.
  - **The two frequencies are not decomposed, and no claim may decompose them.** Between the daily
    row, which rejects, and the monthly one, which does not (by OLS or under the scale), the
    observation frequency and the measured object — announcement window against calendar variation —
    change together. The only monthly aggregation is the panel's own; the summed-window object and
    every number it produced are discontinued. The advisor's reading "aggregation dilutes the
    variance" is such a decomposition and was not written.
  - **Two sensitivities travel with the daily claim**: the vertex (p rises with maturity, as the DI
    variance ratio falls) and the test's kurtosis correction, without which every daily cell would
    reject. Both statistics are in `output/het/het_conditions.csv` (`qr_12`, `qr_12_nk`).
  - **Responses without identification are not estimates.** Where the condition fails (the monthly
    VAR, the factor innovations) they are printed as such and may not be read as direction and
    magnitude.
  - **`goncalves2025`'s CDS is not null**: their Table 5 shows it closing, in percentage points (the
    unit is inferred, `het_rigobon/_common.R`). Do not write that GRG find no CDS response.
- **Do not silently re-architect the identification core** — see `.claude/rules/identification.md`.
  A het-side round imports `R/` read-only and proves its local pieces reproduce `compute_irf_dfm()`
  exactly, rather than extracting formulas from the guarded file.

## Common commands

```bash
# End-to-end pipeline
Rscript script/run_all.R --list              # stages, inputs/outputs, what is missing
Rscript script/run_all.R --dry-run           # preflight only, runs nothing
Rscript script/run_all.R                     # full chain, network downloads included
Rscript script/run_all.R --from=clean        # skip the network stages

# Full instrument rebuild + diagnostics
Rscript script/download.R                    # all reproducible monthly and daily raw inputs
Rscript script/instrument.R                  # the monthly instrument variants
Rscript script/instrument_diagnostics.R      # tab:first_stage columns per variant (CSV)
Rscript script/mosw_strength_grid.R          # ξ_mp over (r,q) × sample × instrument

# IRF inference, coherence and q sensitivity
Rscript script/irf_coherence_check.R         # 58 vars scored point-by-point (feeds §4)
Rscript script/q_sensitivity.R --window=cheia   # q = 2..5 narrative + paper/img/fig_q_sensibilidade.pdf; --window=pre_covid for the other
Rscript script/pandemic_sensitivity.R        # q = 2..5 with and without the LP scale, pre-COVID against production + the two Anexo C figures
Rscript script/fig_section5.R                # paper/img/fig_*.pdf from the cached .rds

Rscript script/model_alessi.R                # main DFM: Bai-Ng surface + IRF figure
Rscript script/model_var.R                   # Olea small-VAR points, AR sets and diagnostics
Rscript script/fig_weak_iv.R                  # canonical small-VAR AR figure

# Regression checks against the reference code (MOSW, Stock-Watson, Lenza-Primiceri)
for f in script/validation/*.R; do Rscript "$f" || break; done
```

There is no formal test suite, linter or build step. `script/validation/` holds the regression
checks against the authors' code: rerun them after touching `R/modeling/` or `R/identification/`.
Otherwise iterate by running the relevant script.

**Smoke test after touching the identification path** (fast):

```r
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/weak_iv_ar.R")   # main_sdfm passa inference = "ar"
source("R/modeling/dfm_pipeline.R")
# every other argument is the production default, written in main_sdfm()'s
# signature; covid_volatility defaults to read_covid_volatility() of the CSV
res <- main_sdfm(r = 5L, q = 5L, p = 4, shock_size_bps = 50, mp_var = "yield_6m")
# note the field is `irfs`, not `irf`, and the names come from the data matrix
P <- res$irfs$irf_point_matrix; vn <- colnames(res$data)
P[match(c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd"), vn), 1]
```

The expected h0 values, at full precision for a bit-identical check, are the `expected` column of
`output/validation/production_spec_impact_smoke.csv`, committed per branch: compare against the
branch you are on, with `data/processed/` rebuilt for it. The untreated point
(`covid_volatility = NULL`) is pinned, as the degeneracy reference, in
`script/validation/validate_covid_volatility.R`.

## Conventions

- **Language:** English for code, identifiers and this file; Portuguese for prose in `registro/`,
  `notas/`, `pareceres/`, `email/` and `output/*.md`.
- **Plots:** `ggplot2`, paper style — shaded 80% and 90% bands.
- **Comments:** minimal, only at non-trivial technical steps.
- **Record vs. session:** `notas/` is permanent and citable — a dated note per round, carrying a
  vintage banner, and it is what the paper pulls numbers from. `pareceres/` is what was *received*
  (`/council`, `/referee2`, `/auditor-externo`) and is kept verbatim. `email/` is the running
  email exchange with the advisor about the project, one file per message
  (`email_{meu,professor}_DD-MM_HHhMM.md`), kept verbatim like `pareceres/` but ongoing rather than
  a single delivered document. `progress_logs/` is session
  continuity and is disposable. Nothing durable goes into `progress_logs/`, and no session log goes
  into `notas/`.
- **Fail loud:** a missing input aborts with a pointer to the script that produces it. Never a
  silent fallback that makes "the collection was never run" indistinguishable from "the collection
  came back empty".
- **Boundaries:** `R/` holds reusable modules and **never sources anything in `script/`**; function
  files carry no run logic. **No live path sources from `arquivo/`, and no live code writes into
  it.** `diagnostics/` audits and **never modifies estimation code**.
- **Reference code:** `codigos_externos/` (Alessi-Kerssenfischer, JK, Bauer-Swanson, Montiel
  Olea-Stock-Watson) is **gitignored** — read-only for translation. Because of that, every
  `script/validation/validate_*.R` runs off a committed fixture in `output/validation/`, never off
  those directories.
- **`output/`** is git-tracked; frozen artefacts (e.g. the VAR benchmark, archived het) carry their
  own vintage in `notas/_indice.md` and are not stale by being older.

## Scoped rules

`.claude/rules/` holds the area detail, each file declaring the `paths:` that load it — the estimation
contract and its traps (`identification.md`), variant construction and ξ_mp (`instrument.md`), the
panel and its two fixed external inputs (`data.md`), the audit round (`diagnostics.md`), and
generated-vs-hand-written outputs and the paper's map (`writing.md`).
