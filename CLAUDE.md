# CLAUDE.md

**What belongs here:** invariants, entry points and the rules that govern what may be *claimed*.
**What does not:** research findings — numbers copied here go stale, numbers in the record do not.
Area-specific detail lives in `.claude/rules/` and loads when you touch that area.

## Project

Independent paper replicating Alessi & Kerssenfischer (2019) for Brazil: large-scale non-stationary
Dynamic Factor Model, monetary shocks identified by an external instrument (Copom-day DI futures
surprises), IRFs of Brazilian asset prices. Inference: Anderson–Rubin sets by test inversion
(Montiel Olea, Stock & Watson 2021) since 2026-09-08, replacing the wild bootstrap (Gonçalves &
Kilian 2004) with Kilian (1998) bias correction, which left the code on 2026-09-18. Canonical
paper: `paper/paper_anpec.tex`.

The record, in `registro/`: `metodo.md` (the live design — instrument construction and the
identification chain), `pendencias.md` (what is open), `historico_decisoes.md` (what died and why —
**read before proposing a methodological direction**); plus `notas/`, dated and carrying vintage
banners, `pareceres/`, what outside reviewers sent in, and `email/`, the running email exchange
with the advisor.

## Production spec — the invariant that costs most to get wrong

**`z_jk_bs_purif` × `yield_6m` × (r=5, q=5, p=4), +50bp**, read from
`R/modeling/production_spec.R`. The production panel is the 115-series
`drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, covering
2012-03 through 2025-12 (166 months, 162 factor innovations after `p=4`);
the 106-series base exists only for historical factor-grid reproduction.
`r=5` is selected by the BLL Bai--Ng surface (`r=1,...,20`: IC1=IC2=5,
IC3=20); `q=r=5` is the operational decision. `p=4` is inherited from the
prior vintage rather than reselected — the AIC check on the extended common
sample (`T=154`, constant and trend in the selection only) still picks `p=4`
(8.231267), and BIC still picks `p=2`. The estimated factor VAR remains
intercept-only. **Since 2026-09-17 the factor VAR carries the Lenza-Primiceri
(2022) COVID volatility scale `s_t`** — `production_spec()$covid_volatility`,
θ̂ = (6.611429, 12.468338, 1.760352, 0.943926) frozen as literals, `t*` =
2020-03, `innovations = "standardized"`. The **full window** is therefore
weighted least squares; the **pre-COVID window is not, and needs not be** —
every month of it has `s_t = 1`, so the weighted fit *is* the unweighted one
(proved bit-identical by N1/N2 of `script/validation/validate_covid_volatility.R`), and
`estimate_dfm()` rejects a `covid_start` outside its residual months. Contrasts
between the two windows stay contrasts of window, not of estimator.

The production cell has **ξ_mp = 6.847997 full / 8.643436 pre-COVID**,
F_rob,mp = 11.765250 / 13.809985; both companion matrices are stable
(0.983677 / 0.993359). The treatment **raised** ξ_mp (it was 6.057014 full,
F_rob 9.625428, root 0.970090 untreated) and left the pre-COVID numbers
untouched, as it must. **ξ_mp is the strength ruler of record** — the AR set is
bounded iff ξ_mp > 3.84, conventional bands approximately valid at ξ_mp ≥ 10,
which 6.85 still is not. Since 2026-09-08 that boundedness is no longer a
prediction: `ar_dfm_bands()` builds the sets, its `xi_den` reproduces 6.847997
through the MOSW covariance, and every set in `output/irf/irf_coherence_h.csv`
comes back `interval` at 68 and 90% — 2841 of 2842 rows per level, the one
exception being the `singleton` the normalization pins at h=0. Legacy
first-stage F rulers still print but stopped deciding on 2026-07-26.

**Under the scale, `r ≥ 7` is explosive on the full window** (max root 1.001362
at r=7, 1.001318 at r=8, every q), so `script/mosw_strength_grid.R` sweeps
r=4:6 there and keeps r=4:8 pre-COVID, where everything is stable. Production
r=5 is far from that edge. The Kilian correction and the wild bootstrap, which
assume OLS with a constant Σ and never ran under the scale, were **removed from
the code on 2026-09-18**. This is reweighting of the estimation, **not**
heteroskedasticity identification.

**§3 is current; §4 onward is one vintage behind, in window and in
inference.** On **2026-09-17** §3 was reorganized into four subsections —
`Modelo e estimação`, `Base de dados`, `Identificação e construção do
instrumento`, `Relevância do instrumento e inferência` — and **fully migrated**
to the production vintage: 2012-03--2025-12, 166 observations, 162 innovations,
`(r,q,p)=(5,5,4)`, ξ_mp 6.85 full and 8.64 pre-COVID, `tab:first_stage` rebuilt
from `mosw_strength_grid.md` and `instrument_diagnostics_report.md`, 102 Copom
meetings, 67 monetary and 35 information, BS `R²` 0.022. Note:
`2026-09-17_reorganizacao_secao_3`. Its §3.1 now carries the whole estimation
chain in order, including the concentrated likelihood that estimates θ and the
WLS that follows from it.

**§4, §5 and `output/irf/irf_section.md` still describe the prior 2013-01--2025-09
window, and the two *wild bootstrap* captions describe the figures as painted.**
That gap closes in a not-yet-scheduled editorial round; until then
`script/fig_section5.R` and `script/fig_weak_iv.R` abort without
`--repaint-paper-figures`, so a stray re-run cannot repaint the paper's figures
with an inference its captions do not announce. See `notas/_indice.md` before
citing paper numbers as current.

The only active small-VAR benchmark is **`ibc5_fx_cds_level_trend_p2`**. It
uses `ibc_br`, `price_ipca`, `yield_6m`, `cambio_usd`, and `cds_5y` in levels,
with a constant and linear trend in every equation. AIC and BIC are computed
on a common 141-observation sample; production uses `p=2`, selected by AIC.
Published responses are
horizon-specific `C_h B_1` estimates with VAR-only AR/MOSW sets at 68% and 90%
under NW(0). Do not add sensitivity cells, sum responses across horizons, or
restore bootstrap inference for this benchmark.

## Pipeline

Three ordered stages plus estimation, one `Rscript` process each, orchestrated by `script/run_all.R`:

1. **`script/download.R`** → `data/raw/raw_data.csv` with 113 monthly series plus every reproducible
   daily raw input (BCB, Focus, FRED, Yahoo, B3, FOMC, IPEA, SIDRA). Auxiliary functions in
   `R/data_download/` never execute or write on source.
2. **`script/clean.R`** → `data/processed/data_log_deseasonalized.csv` (log + X-13).
3. **`script/instrument.R`** → 8 monthly variants via `R/instrument/build_variants.R`. Requires
   `data/raw/fomc_dates.csv` (hard).
4. **Estimation** — `script/model_alessi.R` (main DFM; the pipeline itself is `main_sdfm()` in
   `R/modeling/dfm_pipeline.R`) and `script/model_var.R` (small-VAR
   **benchmark**; it does not use the factors).

`script/irf_coherence_check.R` runs the production spec once and writes
`output/irf/irf_coherence_h.csv` — point + 68/90 Anderson–Rubin sets + `set_type` + flags, **the
source of §5** — plus `irf_coherence_cell.rds`, the cached estimation object follow-up analyses
reuse instead of re-estimating. The inference swap was documented by `arquivo/script/ar_bands.R`,
archived on 2026-09-18 with the bootstrap it compared against; its outputs stay in
`output/irf/ar_bands*`, including the record of the cells the `hac_dim < T` gate blocks. Catalog of
the scripts in `script/README.md`; repo map in `README.md`.

## Completed rounds

Cite the note, never this table. Notes are under `notas/`. Rounds whose script sits in
`arquivo/script/` were archived on 2026-09-17 or 2026-09-18: their outputs stay in `output/`, but
the script is not maintained and most no longer run (`arquivo/README.md`).

| round | script | note | verdict |
|---|---|---|---|
| Sovereign confound | `arquivo/script/jk_sovereign_confound.R` | `2026-08-24_migracao_dfm_p4` | daily selection not confirmed; re-derived mask lowers ξ_mp to 3.438 |
| FOMC coincidence | `arquivo/script/fomc_coincidence.R` | `2026-08-24_migracao_dfm_p4` | regressions null, but re-derived mask lowers ξ_mp to 3.671: weak contamination signal |
| ξ_mp robustness | `arquivo/script/xi_mp_robustness.R` | `2026-08-24_migracao_dfm_p4` | all 149 full-sample LOO cells remain below 10; none falls below 3.84 |
| Construction sweep | `arquivo/script/instrument_construction_sweep.R` | idem | vertex not identified; all give same IRF |
| Preços cross-instrumento | `arquivo/script/price_cross_instrument.R` | `2026-08-24_migracao_dfm_p4` | corcova comum aos 3 degraus; efeitos das camadas não são uniformes entre séries |
| Varredura de `p` | `arquivo/script/p_selection.R` | `2026-08-24_migracao_dfm_p4` | production `p=4`; historical `p=6` retained as an alternative cell |
| Factor stationarity | `arquivo/script/factor_stationarity.R` | `2026-08-24_migracao_dfm_p4` | 3/5 I(1), no I(2), full-sample root 0.968126 (real) |
| Levels VAR and weak-IV | `model_var.R` | `2026-08-22_var_niveis_aic_tendencia` | constant and trend, AIC p=2, horizon-specific responses, AR 68%/90% |
| Equity representation | `arquivo/script/asset_representation.R` | `2026-07-31_acoes_representacao` | null is mechanical; log-level set aside |
| DFM-IV audit (Tasks 0-7) | `diagnostics/` | `diagnostics/diagnostico_dfm.md` | H2 confirmed; state dependence split |
| Het at monthly frequency | (reestimation, no dedicated script) | `2026-09-01_heterocedasticidade_frequencia` | rank condition not satisfied monthly; route stays out of production |
| Fiscal Focus expectations (isolated) | `arquivo/script/fiscal_expectations.R` | `2026-09-01_teste_expectativas_fiscais` | 111→114-series experimental panel; no evidence of expected fiscal deterioration |
| DLSP accounting decomposition | `arquivo/script/fiscal_dlsp_decomposition.R` | `2026-09-01_decomposicao_contabil_dlsp` | blocked: the 7-flow identity omits the external "outros ajustes" line |
| 115-series exchange-adjustment + fiscal expectations (joint) | `arquivo/script/fiscal_exchange_expectations.R` | `2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais` | experimental panel superseded for DFM numbers; not promoted to production |
| Anderson–Rubin as the DFM's operational inference | `arquivo/script/ar_bands.R` | `2026-09-08_bandas_anderson_rubin_producao` | swap done; all 5635 production cells bounded, weak-IV premium 1.38× at 90%; `(5,2)` unbounded (untreated model); `(8,8)` and pre-COVID blocked by `hac_dim < T` |
| Lenza-Primiceri scale into production | `validation/validate_production_spec.R`, `irf_coherence_check.R`, `mosw_strength_grid.R` | `2026-09-17_volatilidade_covid_producao` | switched on: ξ_mp 6.057014 → 6.847997, F_rob 9.625428 → 11.765250, root 0.970090 → 0.983677, every §5 set still `interval` at 68/90; pre-COVID unmoved (s_t ≡ 1); `r ≥ 7` explosive on the full window |
| Alternative `r` estimators (AH ER/GR, ABC) | `arquivo/script/factor_selection_alt.R` | `2026-09-10_selecao_fatores_ah_abc` | mixed: ER = GR = 2, ABC-IC*₁ = 9 on a 2-point stability interval (5 in 39/100 column permutations); `factorselect` diverges from both papers in GR and ABC and is not used |
| Correlation pruning + `(r,q)` on the pruned panel | `panel_pruning.R`, `factor_selection_pruned.R` | `2026-09-10_poda_correlacao_painel` | complete linkage at \|ρ\| ≥ 0.90 drops 9/115 series; Bai-Ng IC2 5 → 3, AH 2 → 1, ABC 9 → 11 (unstable), AW `q = 2` at every `r`; divergence grows (D 10 → 12), underestimation hypothesis contradicted |
| `q < r` truncation: subspace sufficiency + AK invariance by window | `q_truncation.R` | `2026-09-10_truncamento_q` | harmless before COVID, distorting after: pre-COVID `p=2` 115/115 series immaterial at `q=3,4`, full sample 0/115; the proxy's covariance sits in the discarded directions (T1 p 0.051/0.039/0.015 full, ≥ 0.22 pre-COVID); rules written after an exploratory pass |
| COVID volatility (Lenza-Primiceri) in the factor VAR: θ̂ by ML, AR under WLS, steps 3/4 and 4/4 | `covid_volatility_theta.R`, `q_truncation.R` (cell `cheia_p4_lp`), `q_sensitivity.R` | `2026-09-14_inferencia_volatilidade_covid_q` | **superseded on 2026-09-17: the treatment became production.** θ̂ = (6.61, 12.47, 1.76, 0.944), with a second maximum at ρ = 0 2.6 log-points below; at `q=3` 23/115 series immaterial and 75 material, against 115/115 immaterial pre-COVID `p=2`; the sets condition on θ̂ |

## ⚠ Prohibitions

These govern what may be **said**, so they apply even when no file is open.

### What the paper may not claim

- **68% bands are never "significant".** Two-tier rule: 90% band excluding zero → *significativo*;
  68% only → **direction and magnitude**, labelled as such.
- **The 68%/90% Anderson–Rubin sets are the sole operational inference for the DFM** since
  **2026-09-08** (author decision; it reverses the 2026-08-12 withdrawal, `historico_decisoes.md`
  §7). `production_spec()$inference` is the single authority, `compute_irf_dfm(inference=)` the
  single switch (`"ar"`, or `"none"` for the point alone). The wild bootstrap and the Kilian
  correction left the code on 2026-09-18. Two things are true of the sets: the plug-in
  covariance conditions on the estimated `Λ`, `K`, `M`, `sy` and `θ̂`; and `mosw_rform_cov` needs
  `hac_dim < T`, which **blocks** `(r,q)=(8,8)` at `p=4` (336 ≥ 162) and the **whole pre-COVID
  window** at `p=4` (135 ≥ 90). No pseudo-inverse, no substitute bootstrap, no fallback — a
  blocked cell is reported blocked, in code, in `output/` and in the record. **The paper's prose
  carries neither caveat**, by author decision of 2026-09-16 and again of 2026-09-17: a reader who
  knows the treatment sits in the factor VAR infers the conditioning, and `(8,8)` is an abandoned
  cell. Nothing in the paper may therefore *contradict* them — no pre-COVID band may be published,
  and no `(8,8)` number may appear as inference. **`hac_dim < T` is this project's safeguard,
  not the authors' condition**: `CovAhat_Sigmahat_Gamma.m:91-95` states `n²p + n(n+1)/2 + nk < T`
  on the *parameter* dimension (120 in the production shape, against `hac_dim`'s 135), which is
  the necessary one since `rank(WHat) ≤ min(par_dim, T−1)`. The moment-dimension gate is
  sufficient and strictly stronger; both are checked since the 2026-09-08 fidelity audit, and
  both bar exactly the same two cells (pre-COVID 120 ≥ 90, `(8,8)` 300 ≥ 162), so no published
  number depends on which one binds.
- **Significance is "the set excludes zero", read off the topology.** An AR set need not be an
  interval: `two_rays` excludes zero only when zero falls in its gap, `real_line` never does, and
  `empty` is a misspecification signal that scoring must not read as a sign. `ar_excludes_zero()`
  is the only place that rule lives. The set is bounded at level κ **iff ξ_mp > κ**. The
  `(5,2)` example of `arquivo/script/ar_bands.R` — ξ_mp = 2.339, unbounded at 90% and 95% — is
  the **untreated** model; under the production scale `(5,2)` has ξ_mp = 5.124 and is bounded at
  68, 90 and 95% (`output/factors/q_truncation_cells.csv`, cell `cheia_p4_lp`).
  **The small-VAR benchmark keeps its own AR/MOSW sets** (`R/identification/weak_iv_ar.R`, now the
  shared module: `Load`/`Inner` default to the identity and the VAR path is bit-identical, guarded
  by `validate_mosw_ar.R`). Those sets are inference *for the VAR*, never for the DFM, and
  coincidence licenses only "the central pattern is robust to weak-IV inference in an alternative
  lower-dimensional specification" — **never** "the SVAR proves the SDFM right". Weak-IV
  robustness is **not** instrument validity: both models use the same proxy, so a contaminated
  proxy fails in both.
- **No text may credit the `cumsum` fix with recovering the asset block.** At h=0 the `cumsum` is a
  no-op and the ×100 is a positive scalar on point and both bounds, so **h=0 significance is
  invariant to tcode**. Only the panel representation recovers the block, and it was declined.
  The fix shipped on 2026-08-17 (`asset_*` moved from tcode 2 to **tcode 6**, ×100 without
  accumulating) and the prohibition is now *measured*, not merely predicted: the block got **worse**
  away from h=0 — sig90 fell from 4 cells to 2, and sig68 at h≤12 stayed at 20. What the fix did
  deliver is band behaviour: the h36/h0 width ratio fell from 27.573 to 0.920 and the false
  Ibovespa peak went from +17.71% at h=21 to +2.01% at h=8.
- **The paper has one identification: the external proxy.** Heteroskedasticity and non-Gaussian
  (GMR) identification were abandoned on 2026-08-17 and may not be cited as corroboration, as a
  robustness leg, or as an alternative estimate. The negative frequency diagnostic and its
  archived artefacts remain under `arquivo/heterocedasticidade/`, but the dedicated code was
  removed on 2026-09-01. `goncalves2025` stays cited: that is *other people's* daily
  het-identified evidence the paper argues with, not this project's route. The Lenza-Primiceri
  COVID-volatility scale in the factor VAR (2026-09-14, off in production) is no exception: it
  reweights the estimation, identifies nothing, and its treated sets condition on θ̂.
- **The VAR benchmark tests DFM-vs-small-VAR, not "vs the literature"**, which uses Cholesky.
- **ξ_mp ≥ 10 is the Staiger-Stock rule of thumb** for the homoskedastic 2SLS first-stage F, **not an
  MOSW result**. §3.6 states this correctly since 2026-08-14; the naming is deliberately generic
  ("referência convencional") because a Staiger-Stock or Montiel Olea-Pflueger entry would break the
  25-key budget. Any future rewrite must not silently re-attribute the 10 to `montielolea`.
- **The state-dependence persistence result is suggestive, not central** — marginal p, found after
  looking, needs the three specs side by side.
- **Report the inconvenient number too.** The daily GRG replication that vindicates the FX result
  gives the **wrong sign for equities** — they are unidentified in that daily system.

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
- **Heteroskedasticity and non-Gaussian (GMR) identification** — both abandoned on **2026-08-17**,
  verdicts in `historico_decisoes.md` §0 and §1. Non-Gaussian code and artefacts remain in
  `arquivo/nao_gaussiana/`; heteroskedasticity's dedicated code was removed on **2026-09-01** after a
  final monthly reestimation confirmed the rank condition still fails (`arquivo/heterocedasticidade/`
  keeps only artefacts/verdict). Het is rejected at both frequencies; GMR has no power on this
  panel because DFM aggregation destroys the non-Gaussianity. Loose ends that die with them:
  *conditional* het (GARCH-SVAR) and LMS (2017) via `svars::id.ngml`, neither attempted, `svars`
  not installed. **Heteroskedasticity-robust *inference* is untouched** — the Anderson–Rubin sets
  and the HAC first stage are heteroskedasticity-robust.
- **Do not silently re-architect the identification core** — see `.claude/rules/identification.md`.

## Common commands

```bash
# End-to-end pipeline
Rscript script/run_all.R --list              # stages, inputs/outputs, what is missing
Rscript script/run_all.R --dry-run           # preflight only, runs nothing
Rscript script/run_all.R                     # full chain, network downloads included
Rscript script/run_all.R --from=clean        # skip the network stages

# Full instrument rebuild + diagnostics
Rscript script/download.R                    # all reproducible monthly and daily raw inputs
Rscript script/instrument.R                  # 8 GK-family variants
Rscript script/instrument_diagnostics.R      # first-stage F + MOSW Wald block
Rscript script/mosw_strength_grid.R          # ξ_mp over (r,q) × sample × instrument

# IRF inference, coherence and q sensitivity
Rscript script/irf_coherence_check.R         # 58 vars scored point-by-point (feeds §5)
Rscript script/q_truncation.R                # q < r truncation, four window-cells
Rscript script/q_sensitivity.R --window=cheia   # q = 2..5 narrative; --window=pre_covid for the other
Rscript script/fig_section5.R                # paper/fig_*.pdf from the cached .rds

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
source("R/modeling/production_spec.R")
source("R/identification/weak_iv_ar.R")   # main_sdfm passa inference = "ar"
source("R/modeling/dfm_pipeline.R")
res <- main_sdfm(r = 5L, q = 5L, p = 4, shock_size_bps = 50, mp_var = "yield_6m")
# note the field is `irfs`, not `irf`, and the names come from the data matrix
P <- res$irfs$irf_point_matrix; vn <- colnames(res$data)
P[match(c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd"), vn), 1]
```

Expected h0 (matches `output/validation/production_spec_impact_smoke.csv`),
**under the Lenza-Primiceri scale since 2026-09-17**:
`yield_6m` 0.005, `yield_2y` 0.00700903, `yield_5y` 0.00729005,
`asset_ibov` −1.5020158, `cambio_usd` 0.12942167. Full precision, for a
bit-identical check: `0.0050000000000000001`, `0.0070090326083686542`,
`0.0072900543327283655`, `-1.5020158375666013`,
`0.12942167379213612`. The untreated point (`covid_volatility = NULL`) is still
pinned, as the degeneracy reference, in `script/validation/validate_covid_volatility.R`.

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
- **`output/`** is git-tracked (~24 MB), most recently refreshed by the 2026-09-02 production
  migration; frozen artefacts (e.g. the VAR benchmark, archived het) carry their own vintage in
  `notas/_indice.md` and are not stale by being older.
- **`AGENTS.md` is Codex's, not mine** — Claude Code reads `CLAUDE.md` only, and the file is
  deliberately not imported. If you change an invariant, change it in both or they drift apart.

## Scoped rules

`.claude/rules/` holds the area detail, each file declaring the `paths:` that load it — the estimation
contract and its traps (`identification.md`), variant construction and ξ_mp (`instrument.md`), the
panel and its three fixed external inputs (`data.md`), the audit round (`diagnostics.md`), and
generated-vs-hand-written outputs (`writing.md`).
