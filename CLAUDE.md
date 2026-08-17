# CLAUDE.md

**What belongs here:** invariants, entry points and the rules that govern what may be *claimed*.
**What does not:** research findings — numbers copied here go stale, numbers in the record do not.
Area-specific detail lives in `.claude/rules/` and loads when you touch that area.

## Project

Independent paper replicating Alessi & Kerssenfischer (2019) for Brazil: large-scale non-stationary
Dynamic Factor Model, monetary shocks identified by an external instrument (Copom-day DI futures
surprises), IRFs of Brazilian asset prices. Inference: wild bootstrap (Gonçalves & Kilian 2004) with
Kilian (1998) bias correction. Canonical paper: `paper/paper_anpec.tex`.

The record, in `registro/`: `metodo.md` (the live design — instrument construction and the
identification chain), `pendencias.md` (what is open), `historico_decisoes.md` (what died and why —
**read before proposing a methodological direction**); plus `notas/`, dated and carrying vintage
banners, and `pareceres/`, what outside reviewers sent in.

## Production spec — the invariant that costs most to get wrong

**`z_jk_bs_purif` × `yield_6m` × (r=5, q=5, p=6), +50bp**, read from
`R/modeling/production_spec.R`. The production panel is the 111-series
`drop_setor_externo__eua__credito__imoveis`; the 106-series base exists only
for historical factor-grid reproduction. `r=5` is selected by BLL Bai--Ng IC2;
`q=5` is provisional. The frozen production cell has **ξ_mp = 6.27085 full /
10.99268 pre-COVID**; the pre-COVID companion is marginally unstable
(1.000202). **ξ_mp is the strength ruler of record** — the
AR set is bounded iff ξ_mp > 3.84, conventional bands approximately valid at ξ_mp ≥ 10. Legacy
first-stage F rulers still print but stopped deciding on 2026-07-26.

## Pipeline

Three ordered stages plus estimation, one `Rscript` process each, orchestrated by `script/run_all.R`:

1. **`script/download.R`** → `data/raw/raw_data.csv` (BCB, FX, yield curve, rb3 indices, EMBI/CDS/MSCI,
   EPU, inflation). Auxiliary downloaders in `R/data_download/`.
2. **`script/clean.R`** → `data/processed/data_log_deseasonalized.csv` (log + X-13).
3. **`script/instrument.R`** → 8 monthly variants via `R/instrument/build_variants.R`. Requires
   `data/raw/fomc_dates.csv` (hard).
4. **Estimation** — `script/model_alessi.R` (main DFM; the pipeline itself is `main_sdfm()` in
   `R/modeling/dfm_pipeline.R`) and `script/model_var.R` (small-VAR
   **benchmark**; it does not use the factors).

`script/irf_coherence_check.R` runs the production spec once and writes
`output/irf/irf_coherence_h.csv` — point + 68/90 bands + flags, **the source of §5** — plus
`irf_coherence_cell.rds`, the cached estimation object follow-up analyses reuse instead of
re-estimating. Catalog of the 33 scripts in `script/README.md`; repo map in `README.md`.

## Completed rounds

Cite the note, never this table. Notes are under `notas/`.

| round | script | note | verdict |
|---|---|---|---|
| Sovereign confound | `jk_sovereign_confound.R` | `2026-08-09_confound_soberano_cds` | not confirmed, both proxies |
| FOMC coincidence | `fomc_coincidence.R` | `2026-08-10_coincidencia_fomc` | confound not detected |
| ξ_mp robustness | `xi_mp_robustness.R` | `2026-07-27_robustez_xi_mp_e_construcao` | 24 of 147 LOO cells fall below 10 |
| Construction sweep | `instrument_construction_sweep.R` | idem | vertex not identified; all give same IRF |
| Factor stationarity | `factor_stationarity.R` | `2026-08-13_migracao_producao_painel_111_r5q5` | 3/5 I(1), no I(2), full-sample root 0.964858 |
| VAR benchmark | `model_var.R` | `2026-07-31_benchmark_var_vs_dfm` | stronger yes, faster equity-only |
| Equity representation | `asset_representation.R` | `2026-07-31_acoes_representacao` | null is mechanical; log-level set aside |
| DFM-IV audit (Tasks 0-7) | `diagnostics/` | `diagnostics/diagnostico_dfm.md` | H2 confirmed; state dependence split |

## ⚠ Prohibitions

These govern what may be **said**, so they apply even when no file is open.

### What the paper may not claim

- **68% bands are never "significant".** Two-tier rule: 90% band excluding zero → *significativo*;
  68% only → **direction and magnitude**, labelled as such.
- **The 68%/90% wild bootstrap is the sole operational inference for the DFM.** The withdrawn
  Anderson–Rubin plug-in conditioned on estimated factors and loadings and lacked a theory covering
  those generated objects. Do not cite its numerical bands; any future implementation must first
  incorporate factor estimation or establish the required asymptotic justification.
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
  robustness leg, or as an alternative estimate — see `arquivo/heterocedasticidade/` and
  `arquivo/nao_gaussiana/`. `goncalves2025` stays cited: that is *other people's* daily
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
  code and artefacts in `arquivo/{heterocedasticidade,nao_gaussiana}/`, verdicts in
  `historico_decisoes.md` §0 and §1. Het is rejected at both frequencies; GMR has no power on this
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
Rscript R/data_download/external_factors.R   # SP500/VIX/Brent + BRL/USD daily
Rscript R/data_download/focus_fred.R         # Focus medians (BCB olinda) + FRED DGS2
Rscript script/fomc_dates.R         # FOMC decision dates (required by instrument.R)
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
Rscript script/irf_coherence_check.R         # 53 vars scored point-by-point (feeds §5)
Rscript script/fig_section5.R                # paper/fig_*.pdf from the cached .rds

Rscript script/model_alessi.R                # main DFM (long; bootstrap dominated)
Rscript script/model_var.R                   # small-VAR benchmark (~15 min)
Rscript script/factor_stationarity.R         # unit roots, cointegration, spectrum (~2 min)
Rscript script/asset_representation.R        # returns vs log-level vs level (~12 min)
```

There is no test suite, no linter, no build step. Iterate by running the relevant script.

**Smoke test after touching the identification path** (fast, no bootstrap):

```r
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/modeling/dfm_pipeline.R")
res <- main_sdfm(r = 5L, q = 5L, p = 6, shock_size_bps = 50, mp_var = "yield_6m", nboot = 0)
# note the field is `irfs`, not `irf`, and the names come from the data matrix
P <- res$irfs$irf_point_matrix; vn <- colnames(res$data)
P[match(c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd"), vn), 1]
```

Expected h0 (matches `output/irf/irf_coherence_h.csv`): `yield_6m` 0.005,
`yield_2y` 0.00743006, `yield_5y` 0.00776115, `asset_ibov` −1.7226767,
`cambio_usd` 0.15792807. Full precision, for a bit-identical check:
`0.0050000000000000001`, `0.0074300592008910019`, `0.0077611464176508358`,
`-1.7226766564462794`, `0.15792806572512938`.

## Conventions

- **Language:** English for code, identifiers and this file; Portuguese for prose in `registro/`,
  `notas/`, `pareceres/` and `output/*.md`.
- **Plots:** `ggplot2`, paper style — shaded 80% and 90% bands.
- **Comments:** minimal, only at non-trivial technical steps.
- **Record vs. session:** `notas/` is permanent and citable — a dated note per round, carrying a
  vintage banner, and it is what the paper pulls numbers from. `pareceres/` is what was *received*
  (`/council`, `/referee2`, `/auditor-externo`) and is kept verbatim. `progress_logs/` is session
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
- **`output/`** is git-tracked (~3 MB), all from the 2026-07-24 run or later.
- **`AGENTS.md` is Codex's, not mine** — Claude Code reads `CLAUDE.md` only, and the file is
  deliberately not imported. If you change an invariant, change it in both or they drift apart.

## Scoped rules

`.claude/rules/` holds the area detail, each file declaring the `paths:` that load it — the estimation
contract and its traps (`identification.md`), variant construction and ξ_mp (`instrument.md`), the
panel and its three fixed external inputs (`data.md`), the audit round (`diagnostics.md`), and
generated-vs-hand-written outputs (`writing.md`).
