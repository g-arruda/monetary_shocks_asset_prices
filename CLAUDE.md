# CLAUDE.md

**What belongs here:** invariants, entry points and the rules that govern what may be *claimed*.
**What does not:** research findings — numbers copied here go stale, numbers in the record do not.
Area-specific detail lives in `.claude/rules/` and loads when you touch that area.

## Project

Independent paper replicating Alessi & Kerssenfischer (2019) for Brazil: large-scale non-stationary
Dynamic Factor Model, monetary shocks identified by an external instrument (Copom-day DI futures
surprises), IRFs of Brazilian asset prices. Inference: Anderson–Rubin sets by test inversion
(Montiel Olea, Stock & Watson 2021) since 2026-09-08, replacing the wild bootstrap (Gonçalves &
Kilian 2004) with Kilian (1998) bias correction. Canonical paper: `paper/paper_anpec.tex`.

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
intercept-only. The frozen production cell has **ξ_mp = 6.057014 full /
8.643436 pre-COVID**, F_rob,mp = 9.625428 / 13.809985; both companion
matrices are stable (0.970090 / 0.993359). **ξ_mp is the strength ruler of
record** — the AR set is bounded iff ξ_mp > 3.84, conventional bands
approximately valid at ξ_mp ≥ 10. Since 2026-09-08 that boundedness is no
longer a prediction: `ar_dfm_bands()` builds the sets, its `xi_den` reproduces
6.057014 through the MOSW covariance, and all 5635 production cells come back
`interval` at 68/90/95%. Legacy first-stage F rulers still print but stopped
deciding on 2026-07-26.

**The paper is one vintage behind the code, and now behind it in inference
too.** `paper/paper_anpec.tex`, its figures and `output/irf/irf_section.md`
still describe the prior 115-series, 2013-01--2025-09 window at
`(r,q,p)=(4,4,4)` (ξ_mp=6.38 full). Production publishes Anderson–Rubin sets on
the 2012-03 window. The inference half was closed **in the methodology prose
only** on 2026-09-16: §3.5 dropped the wild bootstrap, §3.6 states the AR sets
and, in prose, that only the vectors of the identified ratio change, with a
footnote putting MOSW's equation beside the DFM's, and `sec:weak_iv` no longer
contrasts the two inferences. The two caveats this file requires alongside the
sets were cut from §3.6 by the author and are an open item for the round that
publishes AR numbers in §4.
§4 and the two *wild bootstrap* captions still describe the figures as painted.
Both gaps close in the same not-yet-scheduled editorial round; until then `script/fig_section5.R` and
`script/fig_weak_iv.R` abort without `--repaint-paper-figures`, so a stray
re-run cannot repaint the paper's figures with an inference its captions do
not announce. See `notas/_indice.md` before citing paper numbers as current.

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
reuse instead of re-estimating. `script/ar_bands.R` is the round that documents the inference
swap: it puts AR, delta-method and wild bootstrap side by side on the production cell, contrasts
`(5,2)`, and records the cells the `hac_dim < T` gate blocks. Catalog of the scripts in
`script/README.md`; repo map in `README.md`.

## Completed rounds

Cite the note, never this table. Notes are under `notas/`.

| round | script | note | verdict |
|---|---|---|---|
| Sovereign confound | `jk_sovereign_confound.R` | `2026-08-24_migracao_dfm_p4` | daily selection not confirmed; re-derived mask lowers ξ_mp to 3.438 |
| FOMC coincidence | `fomc_coincidence.R` | `2026-08-24_migracao_dfm_p4` | regressions null, but re-derived mask lowers ξ_mp to 3.671: weak contamination signal |
| ξ_mp robustness | `xi_mp_robustness.R` | `2026-08-24_migracao_dfm_p4` | all 149 full-sample LOO cells remain below 10; none falls below 3.84 |
| Construction sweep | `instrument_construction_sweep.R` | idem | vertex not identified; all give same IRF |
| Preços cross-instrumento | `price_cross_instrument.R` | `2026-08-24_migracao_dfm_p4` | corcova comum aos 3 degraus; efeitos das camadas não são uniformes entre séries |
| Varredura de `p` | `p_selection.R` | `2026-08-24_migracao_dfm_p4` | production `p=4`; historical `p=6` retained as an alternative cell |
| Factor stationarity | `factor_stationarity.R` | `2026-08-24_migracao_dfm_p4` | 3/5 I(1), no I(2), full-sample root 0.968126 (real) |
| Levels VAR and weak-IV | `model_var.R` | `2026-08-22_var_niveis_aic_tendencia` | constant and trend, AIC p=2, horizon-specific responses, AR 68%/90% |
| Equity representation | `asset_representation.R` | `2026-07-31_acoes_representacao` | null is mechanical; log-level set aside |
| DFM-IV audit (Tasks 0-7) | `diagnostics/` | `diagnostics/diagnostico_dfm.md` | H2 confirmed; state dependence split |
| Het at monthly frequency | (reestimation, no dedicated script) | `2026-09-01_heterocedasticidade_frequencia` | rank condition not satisfied monthly; route stays out of production |
| Fiscal Focus expectations (isolated) | `fiscal_expectations.R` | `2026-09-01_teste_expectativas_fiscais` | 111→114-series experimental panel; no evidence of expected fiscal deterioration |
| DLSP accounting decomposition | `fiscal_dlsp_decomposition.R` | `2026-09-01_decomposicao_contabil_dlsp` | blocked: the 7-flow identity omits the external "outros ajustes" line |
| 115-series exchange-adjustment + fiscal expectations (joint) | `fiscal_exchange_expectations.R` | `2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais` | experimental panel superseded for DFM numbers; not promoted to production |
| Anderson–Rubin as the DFM's operational inference | `ar_bands.R` | `2026-09-08_bandas_anderson_rubin_producao` | swap done; all 5635 production cells bounded, weak-IV premium 1.38× at 90%; `(5,2)` unbounded; `(8,8)` and pre-COVID blocked by `hac_dim < T` |
| Alternative `r` estimators (AH ER/GR, ABC) | `factor_selection_alt.R` | `2026-09-10_selecao_fatores_ah_abc` | mixed: ER = GR = 2, ABC-IC*₁ = 9 on a 2-point stability interval (5 in 39/100 column permutations); `factorselect` diverges from both papers in GR and ABC and is not used |
| Correlation pruning + `(r,q)` on the pruned panel | `panel_pruning.R`, `factor_selection_pruned.R` | `2026-09-10_poda_correlacao_painel` | complete linkage at \|ρ\| ≥ 0.90 drops 9/115 series; Bai-Ng IC2 5 → 3, AH 2 → 1, ABC 9 → 11 (unstable), AW `q = 2` at every `r`; divergence grows (D 10 → 12), underestimation hypothesis contradicted |
| `q < r` truncation: subspace sufficiency + AK invariance by window | `q_truncation.R` | `2026-09-10_truncamento_q` | harmless before COVID, distorting after: pre-COVID `p=2` 115/115 series immaterial at `q=3,4`, full sample 0/115; the proxy's covariance sits in the discarded directions (T1 p 0.051/0.039/0.015 full, ≥ 0.22 pre-COVID); rules written after an exploratory pass |

## ⚠ Prohibitions

These govern what may be **said**, so they apply even when no file is open.

### What the paper may not claim

- **68% bands are never "significant".** Two-tier rule: 90% band excluding zero → *significativo*;
  68% only → **direction and magnitude**, labelled as such.
- **The 68%/90% Anderson–Rubin sets are the sole operational inference for the DFM** since
  **2026-09-08** (author decision; it reverses the 2026-08-12 withdrawal, `historico_decisoes.md`
  §7). `production_spec()$inference` is the single authority, `compute_irf_dfm(inference=)` the
  single switch. The wild bootstrap is still computable and still the object `ar_bands.R` compares
  against, but it no longer decides significance. Two things must be said with the sets, not
  around them: the plug-in covariance conditions on the estimated `Λ`, `K`, `M` and `sy`; and
  `mosw_rform_cov` needs `hac_dim < T`, which **blocks** `(r,q)=(8,8)` at `p=4` (336 ≥ 162) and
  the **whole pre-COVID window** at `p=4` (135 ≥ 90). No pseudo-inverse, no substitute bootstrap,
  no fallback — a blocked cell is reported blocked. **`hac_dim < T` is this project's safeguard,
  not the authors' condition**: `CovAhat_Sigmahat_Gamma.m:91-95` states `n²p + n(n+1)/2 + nk < T`
  on the *parameter* dimension (120 in the production shape, against `hac_dim`'s 135), which is
  the necessary one since `rank(WHat) ≤ min(par_dim, T−1)`. The moment-dimension gate is
  sufficient and strictly stronger; both are checked since the 2026-09-08 fidelity audit, and
  both bar exactly the same two cells (pre-COVID 120 ≥ 90, `(8,8)` 300 ≥ 162), so no published
  number depends on which one binds.
- **Significance is "the set excludes zero", read off the topology.** An AR set need not be an
  interval: `two_rays` excludes zero only when zero falls in its gap, `real_line` never does, and
  `empty` is a misspecification signal that scoring must not read as a sign. `ar_excludes_zero()`
  is the only place that rule lives. The set is bounded at level κ **iff ξ_mp > κ**, which is why
  `(5,2)` — ξ_mp = 2.339 — is unbounded at 90% and 95% and bounded only at 68%.
  **The small-VAR benchmark keeps its own AR/MOSW sets** (`R/identification/weak_iv_ar.R`, now the
  shared module: `Load`/`Inner` default to the identity and the VAR path is bit-identical, guarded
  by `validate_mosw_ar.R`). Those sets are inference *for the VAR*, never for the DFM, and
  coincidence licenses only "the central pattern is robust to weak-IV inference in an alternative
  lower-dimensional specification" — **never** "the SVAR proves the SDFM right". Weak-IV
  robustness is **not** instrument validity: both models use the same proxy, so a contaminated
  proxy fails in both.
- **The medium-run reversal may not be cited as evidence separate from the dynamics that produce
  it** — it and the near-unit persistence of the factor VAR are the same object. `cambio_usd` is the
  one exception, so §4's exchange-rate persistence claim is untouched.
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
  het-identified evidence the paper argues with, not this project's route.
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
  not installed. **Heteroskedasticity-robust *inference* is untouched** — the Gonçalves-Kilian wild
  bootstrap and the HAC first stage are production.
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
Rscript script/xi_mp_robustness.R            # leave-one-month-out + NW(0..6) on ξ_mp
Rscript script/instrument_construction_sweep.R  # DI vertex × aggregation scheme
Rscript script/validate_hac_kernel.R         # NW kernel vs the official MATLAB

# Confound tests on the JK mask (~3 min each)
Rscript script/jk_sovereign_confound.R       # sovereign risk: EMBI+ and 5y CDS
Rscript script/fomc_coincidence.R            # FOMC spillover: US block + re-derived mask

# IRF specification sweep
Rscript script/irf_spec_sweep.R              # stage 1: point estimates (~seconds)
Rscript script/irf_spec_stage2.R             # stage 2: bootstrap on winning cells (~2 min)
Rscript script/ar_bands.R                    # AR vs delta vs bootstrap; (5,2); células barradas
Rscript script/irf_coherence_check.R         # 58 vars scored point-by-point (feeds §5)
Rscript script/fig_section5.R                # paper/fig_*.pdf from the cached .rds

Rscript script/model_alessi.R                # main DFM (long; bootstrap dominated)
Rscript script/model_var.R                   # Olea small-VAR points, AR sets and diagnostics
Rscript script/validate_mosw_ar.R            # AR module vs the authors' fixture + degenerate cases
Rscript script/fig_weak_iv.R                  # canonical small-VAR AR figure
Rscript script/factor_stationarity.R         # unit roots, cointegration, spectrum (~2 min)
Rscript script/asset_representation.R        # returns vs log-level vs level (~12 min)
```

There is no test suite, no linter, no build step. Iterate by running the relevant script.

**Smoke test after touching the identification path** (fast, no bootstrap):

```r
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/weak_iv_ar.R")   # main_sdfm passa inference = "ar"
source("R/modeling/dfm_pipeline.R")
res <- main_sdfm(r = 5L, q = 5L, p = 4, shock_size_bps = 50, mp_var = "yield_6m", nboot = 0)
# note the field is `irfs`, not `irf`, and the names come from the data matrix
P <- res$irfs$irf_point_matrix; vn <- colnames(res$data)
P[match(c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd"), vn), 1]
```

Expected h0 (matches `output/validation/production_spec_impact_smoke.csv`):
`yield_6m` 0.005, `yield_2y` 0.00702636, `yield_5y` 0.00724572,
`asset_ibov` −0.9965048, `cambio_usd` 0.13424191. Full precision, for a
bit-identical check: `0.0050000000000000001`, `0.0070263642339699903`,
`0.0072457194488358932`, `-0.99650483088005848`,
`0.13424190947918324`.

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
  `validate_*.R` runs off a committed fixture in `output/validation/`, never off those directories.
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
