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

**`z_jk_bs_purif` × `yield_6m` × (r=7, q=6, p=6), +50bp**, via `mp_var = "yield_6m"` in
`script/model_alessi.R` (explicit `r = 7L, q = 6L` override; auto-IC gives (5,4) and is
borderline-weak). Chosen as the only swept cell with **ξ_mp > 10 in both windows** (10.43 full /
12.22 pre-COVID); r=7 is a plateau, not a knife-edge. **ξ_mp is the strength ruler of record** — the
AR set is bounded iff ξ_mp > 3.84, conventional bands approximately valid at ξ_mp ≥ 10. Legacy
first-stage F rulers still print but stopped deciding on 2026-07-26.

## Pipeline

Three ordered stages plus estimation, one `Rscript` process each, orchestrated by `script/run_all.R`:

1. **`script/download.R`** → `data/raw/raw_data.csv` (BCB, FX, yield curve, rb3 indices, EMBI/CDS/MSCI,
   EPU, inflation). Auxiliary downloaders in `R/data_download/`.
2. **`script/clean.R`** → `data/processed/data_log_deseasonalized.csv` (log + X-13).
3. **`script/instrument.R`** → 8 monthly variants via `R/instrument/build_variants.R`. Requires
   `data/raw/fomc_dates.csv` (hard).
4. **Estimation** — `script/model_alessi.R` (main DFM) and `script/model_var.R` (small-VAR
   **benchmark**; it does not use the factors).

`script/irf_coherence_check.R` runs the production spec once and writes
`output/irf/irf_coherence_h.csv` — point + 68/90 bands + flags, **the source of §5** — plus
`irf_coherence_cell.rds`, the cached estimation object follow-up analyses reuse instead of
re-estimating. Catalog of all 28 scripts in `script/README.md`; repo map in `README.md`.

## Completed rounds

Cite the note, never this table. Notes are under `notas/`.

| round | script | note | verdict |
|---|---|---|---|
| Anderson-Rubin bands | `ar_bands.R` | `2026-08-10_bandas_anderson_rubin` | 87 of 91 sig90 survive |
| Sovereign confound | `jk_sovereign_confound.R` | `2026-08-09_confound_soberano_cds` | not confirmed, both proxies |
| FOMC coincidence | `fomc_coincidence.R` | `2026-08-10_coincidencia_fomc` | confound not detected |
| ξ_mp robustness | `xi_mp_robustness.R` | `2026-07-27_robustez_xi_mp_e_construcao` | AR set stays bounded |
| Construction sweep | `instrument_construction_sweep.R` | idem | vertex not identified; all give same IRF |
| Factor stationarity | `factor_stationarity.R` | `2026-07-31_estacionariedade_fatores` | 4/7 I(1), Johansen rank not identified |
| VAR benchmark | `model_var.R` | `2026-07-31_benchmark_var_vs_dfm` | stronger yes, faster equity-only |
| Equity representation | `asset_representation.R` | `2026-07-31_acoes_representacao` | null is mechanical; log-level set aside |
| Non-Gaussian corroboration | `nongaussian_corroboration.R` | `2026-08-01_robustez_identificacao` | agreement fails the null |
| Rigobon on monthly DFM | `het_robustness.R` | `2026-08-01_robustez_heterocedasticidade` | zero cells identify |
| DFM-IV audit (Tasks 0-7) | `diagnostics/` | `diagnostics/diagnostico_dfm.md` | H2 confirmed; state dependence split |

## ⚠ Prohibitions

These govern what may be **said**, so they apply even when no file is open.

### What the paper may not claim

- **68% bands are never "significant".** Two-tier rule: 90% band excluding zero → *significativo*;
  68% only → **direction and magnitude**, labelled as such.
- **AR bands do not "confirm" or "tighten" the bootstrap** — they are narrower only because they
  condition on `Λ̂, K̂, M̂, ŝy` while the bootstrap re-estimates the DFM per replication. The clean
  comparison is **AR against delta-method**. **Bootstrap remains the ruler of record in §4/§5.**
- **The medium-run reversal may not be cited as evidence separate from the dynamics that produce
  it** — it and the near-unit persistence of the factor VAR are the same object. `cambio_usd` is the
  one exception, so §4's exchange-rate persistence claim is untouched.
- **No text may credit the `cumsum` fix with recovering the asset block.** At h=0 the `cumsum` is a
  no-op and the ×100 is a positive scalar on point and both bounds, so **h=0 significance is
  invariant to tcode**. Only the panel representation recovers the block, and it was declined.
- **No het-vs-proxy sign comparison may be claimed** — the Rigobon round produces no IRF *on
  purpose*, since without a separable column any IRF is a number with no identification behind it.
- **GMR sign agreement is not evidence of corroboration** — the metric saturates against the null.
  Never write "GMR corroborates". What survives are non-discrimination claims: the proxy point lies
  inside the GMR CI90 in 100% of cells, and the recursive scheme is rejected.
- **The VAR benchmark tests DFM-vs-small-VAR, not "vs the literature"**, which uses Cholesky.
- **ξ_mp ≥ 10 is the Staiger-Stock rule of thumb** for the homoskedastic 2SLS first-stage F, **not an
  MOSW result**. The paper's attribution of it to MOSW is an open item.
- **The state-dependence persistence result is suggestive, not central** — marginal p, found after
  looking, needs the three specs side by side.
- **Report the inconvenient number too.** The daily GRG replication that vindicates the FX result
  gives the **wrong sign for equities** — they are unidentified in that daily system.

### What does not reproduce — do not cite

- **Sovereign-confound tests B and D** (three-way split; dated 95-row table), cut 2026-08-10.
- **FOMC test 4** (the FOMC/non-FOMC split), cut 2026-08-10. Removing a leg that *passed* makes the
  reading rule strictly more permissive, so no verdict changed — but the numbers are gone.
- **The 21 raw-level Rigobon cells** that pass both conditions: 17 are at the grid's smallest `q`,
  none survives even a lenient correction.
- For all three the record is in git, the rationale in `historico_decisoes.md` §2.4.
- **`svars::id.dc` / `id.cvm` are Matteson-Tsay and Herwartz-Plödt, not GMR.** Citing them as GMR
  would be a citation error.

### Do not reopen without new evidence

- The **DI vertex** (126 bd) — settled by the construction sweep.
- The **log-level equity panel** — author decision, `historico_decisoes.md` §3.1.
- A **VECM** — the Johansen rank is not identified and the levels VAR is consistent regardless
  (Sims-Stock-Watson 1990; AK's own §2.2 defence).
- **Heteroskedasticity as primary identification** — rejected at both frequencies
  (`historico_decisoes.md` §1, §1.2). The 2026-07-16 decision to abandon the proxy was **reverted on
  2026-07-24**. Declared loose end, not attempted: *conditional* het (GARCH-SVAR), which needs no
  regime dates; `svars` is not installed.
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
Rscript R/data_download/fomc_dates.R         # FOMC decision dates (required by instrument.R)
Rscript script/instrument.R                  # 8 GK-family variants
Rscript script/instrument_diagnostics.R      # first-stage F + MOSW Wald block
Rscript script/mosw_strength_grid.R          # ξ_mp over (r,q) × sample × instrument
Rscript script/xi_mp_robustness.R            # leave-one-month-out + NW(0..6) on ξ_mp
Rscript script/ar_bands.R                    # Anderson-Rubin inversion (~1 min, no bootstrap)
Rscript script/validate_mosw_ar.R            # AR bounds vs the official MSWfunction.m
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
Rscript script/het_robustness.R              # Rigobon gate, 252 cells, no IRF stage (~2 min)

# Non-Gaussian identification (GMR 2017 PML-ICA)
Rscript script/validate_gmr_ica.R            # translation vs IdSS + the paper's own application
Rscript script/nongaussian_gate.R            # at-most-one-Gaussian precondition on eta
Rscript script/model_nongaussian.R [nboot]   # production run + proxy comparison (~23 min)
Rscript script/nongaussian_corroboration.R   # GMR vs proxy on all 106 series (seconds)
Rscript script/nongaussian_labelling.R       # labelling rules without z + random-direction null
```

There is no test suite, no linter, no build step. Iterate by running the relevant script.

**Smoke test after touching the identification path** (fast, no bootstrap):

```r
src <- readLines("script/model_alessi.R"); eval(parse(text = paste(src[1:153], collapse = "\n")))
res <- main_sdfm(r = 7L, q = 6L, p = 6, shock_size_bps = 50, mp_var = "yield_6m", nboot = 0)
# note the field is `irfs`, not `irf`, and the names come from the data matrix
P <- res$irfs$irf_point_matrix; vn <- colnames(res$data)
P[match(c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd"), vn), 1]
```

Expected h0 (matches `output/irf/irf_coherence_h.csv`): `yield_6m` 0.005, `yield_2y` 0.009164,
`yield_5y` 0.009274, `asset_ibov` −1.673, `cambio_usd` 0.1498.

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
