# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Independent paper replicating Alessi & Kerssenfischer (2019) for Brazil. Estimates a large-scale non-stationary Dynamic Factor Model (DFM), identifies monetary policy shocks via an external instrument (Copom-day DI futures surprises), and traces IRFs of Brazilian asset prices. Inference: wild bootstrap (Gonçalves & Kilian, 2004) with Kilian (1998) bias correction.

Authoritative project context lives in `_instrucoes/Instrumento.md` (current instrument design), `_instrucoes/pendencias.md` (what is open) and `_instrucoes/historico_decisoes.md` (what was already tried and why it died — **read this before proposing a methodological direction**). The written §5 of the paper is `output/irf/irf_section.md`.

## Pipeline and entry points

The project runs as three ordered stages plus estimation, each driven by a script in `script/`:

1. **`script/download.R`** — pulls BCB series, FX, yield curve raw, asset indices (rb3), risk (EMBI/CDS/MSCI), EPU, inflation. Writes `data/raw_data.csv`. Auxiliary downloaders live in `R/data_download/` (`bcb.R`, `exchange.R`, `external_factors.R`, `ibov_daily.R`, `download_di.py`).
2. **`script/clean.R`** — log transforms nominal vars, applies X-13 seasonal adjustment via `R/preprocessing/seasonality.R`. Writes `data/processed/data_log_deseasonalized.csv`. (The `source()` of `R/preprocessing/stationarity.R` is commented out — that file never existed; BLL standardization happens later inside `factor_estimation.R`.)
3. **`script/instrument.R`** — Copom-day DI surprises → 10 monthly instrument variants. Core four (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`): GK-style futures surprises + Jarociński-Karadi sign filter + contemporaneous global-factor cleanup (SP500/VIX/Brent, same Wed→Thu window — NOT the Bauer-Swanson orthogonalization, see the 2026-07-14 fidelity audit; monthly aggregation is JK's within-month sum, not GK's moving-average scheme — **and since 2026-07-27 that is a justified choice, not a documented deviation**: GK's fn. 11 conditions its weighting on a *monthly-average* policy indicator, while `yield_6m` here is end-of-month (`download.R:49-53`), and the GK scheme measured on this panel collapses ξ_mp from 10.43 to 0.30). **The build chain lives in `R/instrument/build_variants.R`** (extracted 2026-07-27), parameterized by `target_bd` and `agg` (`agg_monthly_sum` / `agg_monthly_gk`); `instrument.R` calls it once with the production values and keeps all I/O. Reversed-ordering pair added 2026-07-14 (`z_jk_raw_purif`, `z_jk_raw_purif_local`): the standard `z_jk_purif` classifies JK on **residual** signs (purify → JK); the raw pair classifies on **raw** `delta_di` × `r_ibov` signs (JK → purify; `_local` re-estimates the purification on the ~55 selected days — dominated, discarded). Fidelity-audit quartet added 2026-07-14: `z_jk_raw` (literal JK poor-man's: raw mask + raw values), `z_bs_purif` / `z_jk_bs_purif` (BS-faithful pre-event orthogonalization: 65-trading-day financial trends + 20-day Focus revisions + trend, all predetermined at Wed close; requires `Rscript R/data_download/focus_fred.R` first), and `z_jk_purif_us` (contemporaneous + UST 2y Wed→Thu — redundant, cor 0.999 with `z_jk_purif`). Writes `data/processed/instrumentos_mensais.csv`, ten single-variant CSVs, and the legacy file `data/processed/instrument.csv` (controlled by `DEFAULT_VARIANT`, vertex `TARGET_BD = 126` ≈ 6m DI). Helpers in `R/instrument/di_surprise.R`. Ordering analysis: `relatorio/working-notes/2026-07-14_ordem_purificacao_jk.md`; fidelity audit: `relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md` (headline: instrument strength lives in the **mask**, not the purified values — predetermined masks, raw or BS-pre-event, exclude the 2020-03-19 COVID panic day that residual-sign classification mislabels as monetary. `z_jk_bs_purif` became **DEFAULT_VARIANT on 2026-07-15**. **Independently confirmed on the 2026-07-24 vintage:** at production (7,6) full sample the only three variants clearing ξ_mp ≥ 10 are exactly the three predetermined-mask ones — `z_jk_raw` 10.55, `z_jk_bs_purif` 10.43, `z_jk_raw_purif` 10.39 — against `z_jk` 6.30 and `z_jk_purif` 5.77). The 4 heteroskedasticity variants (`z_het*`) were removed from the paper (2026-07-15) and archived (2026-07-26).
3b. **Archived (2026-07-26).** The heteroskedasticity track — `script/instrument_het.R` (`z_het*`, Rigobon-Sack 2003), `script/instrument_validation.R` (T1-T8 suite), the two feasibility scripts and `R/identification/het_{shock_extraction,primary}.R` — now lives in `arquivo/`. It was empirically rejected as a primary identification (2026-07-16) and dropped from the paper as an instrument (2026-07-15). Rationale and the surviving findings: `_instrucoes/historico_decisoes.md` §1; inventory: `arquivo/README.md`.
4. **Estimation** — two heads share the same identification module:
   - `script/model_alessi.R` — main DFM (`estimate_dfm` → `compute_irf_dfm` → `plot_irf`, all in `R/modeling/`).
   - `script/model_var.R` — VAR robustness check on the same factors / instrument.

Diagnostics: `script/instrument_diagnostics.R` runs first-stage F and the variance F-test across the 10 GK-family variants on a single DFM residual, reporting **F (DFM)** (against the first-factor VAR residual) and **F (y6m AR)** (against the AR(6) innovation of monthly `yield_6m`, the Selic-equivalent relevance that feeds the normalization). Both are legacy rulers and can disagree with each other by an order of magnitude. The statistic that actually governs weak-IV bias is the **MOSW Wald block** in `compute_factor_space_wald` (`impulse_responde.R`), validated against the authors' official code (`codigo_olea/`): per-factor robust Wald ξ_k, joint Wald T·Γ̂'Ŵ⁻¹Γ̂ ~ χ²_q, and **ξ_mp** — the Wald in the `yield_6m`-impact direction, exact analogue of the official `Waldstat`; the 95% AR set is a bounded interval iff ξ_mp > 3.84, and conventional bands are approximately valid at ξ_mp ≥ 10. All use Eicker-White + the Shat correction. Audit: `output/instrument/olea_alignment_audit.md`; end-to-end validation reproducing the published Kilian-oil numbers (ξ₁ = 4.4, robust F = 9.4 — the published F is HC1, not HC0) in `script/validate_olea_kilian.R`. **`compute_factor_space_wald` takes `nw_lags` (default 0 = Eicker-White, so every published number is unchanged)**; the Bartlett kernel is transcribed from `NW_hac_STATA.m` and validated in `script/validate_hac_kernel.R` — exact against a literal transcription at lags 0-8, and end-to-end against the official tax application (`TaxSVARIV.m`, NWlags = 8) to 2.6e-10 and at no other lag. Only needed for a GK-aggregated instrument, which induces an MA(1).

**ξ_mp robustness** (`script/xi_mp_robustness.R` → `output/instrument/xi_mp_robustness.{csv,md}`, 2026-07-27): leave-one-month-out with the DFM held fixed, plus NW(0..6). Production at (7,6) full: **0 of 147 single-month drops take ξ_mp below 3.84**, so the AR set stays bounded across the whole sample neighbourhood, but **24 of 147 take it below 10** — the conventional-bands claim is the marginal one, which is why the Anderson-Rubin item is now high priority. ξ_mp is *increasing* in NW lags on the full sample, so NW(0) is conservative.

**Instrument-construction sweep** (`script/instrument_construction_sweep.R` → `instrument_construction_sweep.{csv,md}` + `vertex_irf_overlay.pdf`, 2026-07-27): 13 DI vertices × {sum, GK} × 5 variants × 2 windows. **126 bd is not the argmax in either window**, but no challenger beats it by more than the leave-one-month-out dispersion of ξ_mp itself (best margin 1.16 vs threshold 2.00, rule fixed before the numbers existed), so the vertex is not identified precisely enough to choose and production stays. **All 13 vertices give essentially the same IRF**, inside the 68% band at nearly every horizon — the Alessi-Kerssenfischer Figure A4 analogue the project lacked. Do not re-litigate the vertex without new evidence; the archived predecessor grid is `arquivo/output/instrument_grid.csv` (2026-04-12, legacy F ruler, pre-refresh, no `z_jk_bs_purif`). `script/mosw_strength_grid.R` grids the block over (r ∈ 5-8, q ∈ 4-r) × {full, pre_covid} × 10 instruments → `output/instrument/mosw_strength_grid.{md,csv}`. **Headline (2026-07-24 vintage):** at production (7,6) full sample only three variants clear ξ_mp ≥ 10 — `z_jk_raw` 10.55, **`z_jk_bs_purif` 10.43**, `z_jk_raw_purif` 10.39 — exactly the three with a **predetermined** JK mask; the contemporaneous-residual family falls short (`z_jk` 6.30, `z_jk_purif` 5.77). Pre-COVID at (7,6), 12 of 14 clear 10. This independently confirms the fidelity audit's "strength lives in the mask" finding. `script/diagnose_factor_space_F.R` still grids the legacy max-F over q × variant. Reports land in `output/instrument/`.

IRF specification sweep: `script/irf_spec_sweep.R` (stage 1, point estimates, seconds) grids 8 GK instruments × 5 mp_vars × (r,q) ∈ {(5,4),(6,5),(7,6),(8,8)} × {full, pre_covid}, caching one DFM per (r,q,sample) and scoring theory-consistent signs per cell; `script/irf_spec_stage2.R` (stage 2) runs the full wild bootstrap (nboot=800) on the winning cells, with the production baseline force-appended. Helpers in `R/identification/spec_sweep.R`. **Production is (r=7, q=6) since 2026-07-24** — the only one of the four swept dimensions with ξ_mp > 10 in **both** windows (10.43 full / 12.22 pre_covid); (6,5) is 6.36 / 11.00, (8,8) is 12.57 / 8.99, (5,4) is 5.45 / 7.94. On the full 14-cell MOSW grid, (7,5), (7,7), (8,5) and (8,6) also clear 10 in both windows, so r=7 is a plateau, not a knife-edge. The move followed the **vintage refresh** (duplicated labour-search block and empty ANBIMA columns dropped → 106 series), which is what lifted ξ_mp at (7,6). `model_alessi.R` passes an explicit `r = 7L, q = 6L` override; auto-IC (5,4) is still computed and printed as reference but is borderline-weak. **The taxonomy classifies on ξ_mp since 2026-07-26** (`failure_class` in `classify_sweep_cells`, `R/identification/spec_sweep.R`): `weak_xi_mp_severe` below 3.84 (AR set unbounded), `weak_xi_mp` below 10 (conventional bands not valid), and the stage-1/stage-2 rankings tie-break on ξ_mp. `f_factor` is still computed and reported per cell — plus its own "legacy ruler" heat table — but no longer decides. Under the old max-F rule `z_jk_bs_purif` scored 6.31 at (7,6) and never reached an "eligible" cell while `z_jk_purif` scored 11.08 with ξ_mp 5.77; the production instrument is now `ok`. **Caveat on stage 2:** all 23 eligible `yield_6m` cells tie at `score_hard_frac = 1` and `score_ext = 3`, so ξ_mp alone breaks the tie and pre-COVID cells (systematically stronger) sweep the top 5 — the production baseline still enters via the force-append, now a safety net rather than a workaround. Open item in `_instrucoes/pendencias.md`. Reports in `output/irf/spec_sweep_*.md` (`spec_sweep_conclusoes.md` carries a stale body under a banner).

IRF coherence check: `script/irf_coherence_check.R` runs the production spec once (nboot=800, seed 123, h=48) and scores **52 panel variables point-by-point at every horizon** against theory windows in `R/identification/irf_coherence.R::coherence_var_table()` (verdicts coerente_forte/coerente/parcial/incoerente/soft/ambigua/placebo). Outputs: `output/irf/irf_coherence_{h,summary}.csv`, `irf_coherence_report.md` (**generated body, rewritten in full on every run — never put prose here**), `irf_coherence_plots.pdf`, and `irf_coherence_cell.rds` (full estimation object, saved so composition analyses don't re-estimate; `irf_coherence_h.csv` carries point + 68/90 bands + significance flags and is the source of §5). Current tally under (7,6): 21 coerente_forte, 5 coerente, 11 parcial, 1 incoerente (`price_core_ipca_ex0`), 6 ambiguous, 4 soft-channel, 3 placebos passing and **1 placebo violated** (`commodity_metal`, +10.4% with CI90 at impact — a live exogeneity caveat, since metals are not among the BS pre-event predictors). **§5 (`output/irf/irf_section.md`) was fully rewritten on 2026-07-26** under `z_jk_bs_purif` × (7,6) with all het material removed; it is the canonical results text and records which earlier claims inverted (equity impact no longer CI90-significant, credit expansion is sectoral not aggregate, the price hump is now sig90 in headline/ex0/DW). The interpretive reading of the coherence run lives in `output/irf/irf_coherence_leitura.md` — hand-written, never touched by a script, rewritten under (7,6) on 2026-07-26 (the previous one was silently destroyed by a re-run of the check, which is why the split exists). It diagnoses the *ruler*: which `parcial` verdicts are mis-calibrated theory windows in `coherence_var_table()` versus real sign failures. The 2026-07-12 interpretive working-notes describe the old run and now carry vintage banners — see `relatorio/working-notes/_indice.md`.

## Identification core (do not silently re-architect)

Two functions in `R/modeling/impulse_responde.R` are the contract between the DFM/VAR and the instrument:

- `sel_ext_inst_sample()` — temporal alignment, equivalent to MATLAB `selextinstsample.m`.
- `ident_ext_instr()` — projects raw IRFs through `H = (Z' rsh) / (Z'Z)` and normalizes the impact response of the policy variable to `normalize_value` in the policy variable's *native units*: `shock_bps/10000` for decimal-proportion yields (50bp → 0.005, the production convention since 2026-05-07) and `shock_bps/100` for percent-scale `juros_selic` (the function's legacy default 0.5, kept for `model_var.R`). Equivalent to `IdentExtInstr.m`.

**Three branches.** `compute_irf_dfm` and `main_sdfm` accept `identification = c("proxy", "het", "nongaussian")`, dispatched by an explicit 3-way `switch` (the old `else` was a catch-all that would silently route an unknown value into the proxy path). The het branch is inert in production (the modules were archived on 2026-07-26 and the branch `stop()`s unless they are sourced from `arquivo/`) but the architecture is deliberately kept.

**`identification = "nongaussian"`** (added 2026-07-27, branch `identificacao-nao-gaussiana`) is Gouriéroux-Monfort-Renne (2017, *JoE* 196(1)) pseudo-ML ICA under SIR3, **translated in-repo** in `R/identification/nongaussian_gmr.R` with the adapter in `nongaussian_branch.R`. It prewhitens `eta`, estimates the orthogonal `C` by multi-start PML over the Cayley parametrization, labels the monetary column by `|cor(eps_j, z)|`, and returns `b = P c_mp` — so the instrument **labels** rather than identifies, and the proxy restriction becomes testable (`gmr_wald_column`). Three things not to re-derive:

- **Do not call `IdSS::estim.SVAR.ICA`.** Renne's own package has the ICA path broken for n ≥ 4 (`make.M` and `make.C` both mis-order the skew-symmetric fill, so `C` is not orthogonal; the gradient uses `(I+A)` where Cayley requires `(I+C)`). q = 6 here. `make.Omega` / `make.A.matrix` / `make.Asympt.Cov.delta` *are* correct at any n and are the cross-validation targets. See `_instrucoes/historico_decisoes.md` §0.1.
- **The wild bootstrap is invalid on this branch** — Rademacher multipliers zero all third moments and destroy the asymmetry Assumption A.5 needs. The branch resamples i.i.d. with replacement, as GMR's own online appendix §E does; proxy and het keep Rademacher unchanged.
- **The gate is only partly passed**: 3 of 6 factor innovations do not reject normality on the full sample, 5 of 6 pre-COVID, against a requirement of at most one. Identification is *partial* (the near-Gaussian block is unidentified, the rest is not) and **does not exist pre-COVID**. `output/nongaussian/gate.md`.

LMS (2017) via `svars::id.ngml` is still open as the parametric-ML twin. Note `svars::id.dc`/`id.cvm` are Matteson-Tsay and Herwartz-Plödt, **not** GMR — citing them as GMR would be a citation error.

Monthly-frequency heteroskedasticity identification was implemented, simulation-validated and then **empirically rejected in both variants** (calendar regimes and BPSS-style episode regimes) on this panel — see `_instrucoes/historico_decisoes.md` §1.2. The 2026-07-16 author decision to abandon proxy identification altogether was **reverted on 2026-07-24**: the vintage refresh restored instrument strength and the proxy-SVAR remains the production identification. Current robustness roadmap is frequentist — Angelini-Cavaliere-Fanelli (2024) for weak-proxy inference plus the non-Gaussian route above.

The bootstrap uses Kilian-corrected coefficients for the DGP but the **point estimate uses plain OLS** (faithful to `DFMest_BLL.m`); `apply_kilian = TRUE` only affects the bootstrap. `R/modeling/factor_estimation.R` implements the BLL standardization, Bai-Ng IC for `r`, Amengual-Watson for `q`, plus `infer_tcode_from_varnames()` and `validate_dfm_results()`.

## Common commands

```bash
# End-to-end pipeline (one Rscript process per stage — the stage scripts
# rm(list = ls()) and the downloaders guard on sys.nframe() == 0)
Rscript script/run_all.R --list              # stages, inputs/outputs, what is missing
Rscript script/run_all.R --dry-run           # preflight only, runs nothing
Rscript script/run_all.R                     # full chain, network downloads included
Rscript script/run_all.R --from=clean        # skip the network stages

# Full instrument rebuild + diagnostics
Rscript R/data_download/external_factors.R   # downloads SP500/VIX/Brent + BRL/USD daily
Rscript R/data_download/focus_fred.R         # Focus medians (BCB olinda) + FRED DGS2
Rscript script/instrument.R                  # 10 GK-family variants
Rscript script/instrument_diagnostics.R      # first-stage F + MOSW Wald block
Rscript script/mosw_strength_grid.R          # ξ_mp over (r,q) × sample × instrument
Rscript script/xi_mp_robustness.R            # leave-one-month-out + NW(0..6) on ξ_mp
Rscript script/instrument_construction_sweep.R  # DI vertex × aggregation scheme
Rscript script/validate_hac_kernel.R         # NW kernel vs the official MATLAB

# IRF specification sweep (instrument × mp_var × r/q × sample)
Rscript script/irf_spec_sweep.R              # stage 1: point estimates (~seconds)
Rscript script/irf_spec_stage2.R             # stage 2: bootstrap on winning cells (~2 min)
Rscript script/irf_coherence_check.R         # 52 vars scored point-by-point (feeds §5)

# Main DFM (long; bootstrap dominated)
Rscript script/model_alessi.R

# VAR robustness
Rscript script/model_var.R

# Non-Gaussian identification (GMR 2017 PML-ICA)
Rscript script/validate_gmr_ica.R            # translation vs IdSS + the paper's own application
Rscript script/nongaussian_gate.R            # at-most-one-Gaussian precondition on eta
Rscript script/model_nongaussian.R [nboot]   # production run + proxy comparison (~10 s/draw)
```

There is no test suite, no linter, no build step. Iterate by running the relevant script.

**Smoke test after touching the identification path** (fast, no bootstrap) — evaluate `script/model_alessi.R` up to the production call and re-run the point estimate:

```r
src <- readLines("script/model_alessi.R"); eval(parse(text = paste(src[1:153], collapse = "\n")))
res <- main_sdfm(r = 7L, q = 6L, p = 6, shock_size_bps = 50, mp_var = "yield_6m", nboot = 0)
```

Expected h0 (matches `output/irf/irf_coherence_h.csv`): `yield_6m` 0.005, `yield_2y` 0.009164, `yield_5y` 0.009274, `asset_ibov` −1.673, `cambio_usd` 0.1498.

## Repository layout

- `script/` — the ordered pipeline plus diagnostics (21 files), with `run_all.R` as the orchestrator. `R/` — reusable modules, `source()`d one level deep by `script/`; nothing in `R/` sources anything in `script/`.
- **The non-Gaussian track** lives in `R/identification/nongaussian_{gmr,branch}.R` and `script/{validate_gmr_ica,nongaussian_gate,model_nongaussian}.R`, writing to `output/nongaussian/`. `validate_gmr_ica.R` needs `remotes::install_github("jrenne/IdSS")` (commit `20c8ea6`) purely as a cross-validation target; the production path imports nothing from it.
- **The yield curve is a fixed external input — there is no fitting stage.** `data/yields/yields_dia.csv` was supplied by the advisor and is what `script/download.R` consumes; no script here writes it, none should, and it is **not reproducible from this repository**. Treat it as read-only data. `script/yield_curve.R` (an in-house Svensson fit on DI) was **deleted on 2026-07-26** — it never produced good results and its output fed no stage; see `_instrucoes/historico_decisoes.md` §4. Consequence: `R/modeling/svensson_model.R` has no consumer left (the `source()` in `download.R` was dead and was removed). `run_all.R` fails preflight with a pointer if `yields_dia.csv` goes missing.
- `output/` — **git-tracked** estimation artifacts (~3 MB). Everything currently in it is from the 2026-07-24 production run or later; anything older either does not reproduce against the 106-series panel or was archived.
- `_instrucoes/` — project docs. `pendencias.md` (open only), `historico_decisoes.md` (negative results and reversed decisions), `Instrumento.md`, `justificativa_uso_yield-6m.md`.
- `relatorio/` — `estrutura_paper_v2.md` (section-by-section paper roadmap with the artifact→section map), the instrument fidelity audit, and `working-notes/` with `_indice.md` giving each note a verdict (CURRENT / superseded / contradicted) and the vintage it was written under. **Notes carry banners; check them before reusing numbers.**
- `arquivo/` — archived code and documents, not executed and not cited by the paper: the whole heteroskedasticity track, orphan scripts, superseded het docs, and the previous §5. See `arquivo/README.md`.
- `tex/` — the paper. **§3 (Methodology) is current**: migrated to (7,6) with the MOSW `tab:rq_sweep` table (ξ_mp / joint Wald / joint-F × full and pre-COVID), the het subsection commented out, and the Cholesky-era `\section{Resultados}` removed. Still stale: **abstract, introduction, literature review and §5** — the abstract carries the Cholesky-era magnitudes (−3% equity, "apreciação de 8%", i.e. the inverted FX sign). Converting `output/irf/irf_section.md` into a new §5 is the top open item.

## Conventions

- **Language:** English for variable names and code comments; Portuguese is fine for prose in `_instrucoes/` and `output/*.md`.
- **Plots:** `ggplot2`, paper style — shaded 80% and 90% bands.
- **Factor selection:** use the BLL-standardized variants of Bai-Ng / Amengual-Watson. Plain Bai-Ng (2002) requires stationarity and is the wrong tool here — the panel is non-stationary by design.
- **Comments:** minimal, only at non-trivial technical steps.
- **Reference code:** `codigo_alessi-mark/` (Alessi-Kerssenfischer MATLAB), `codigo_Jarocinski_e_Karadi/` (JK MATLAB), `codigo_bauer_swanson/` (Bauer-Swanson), `codigo_olea/` (Montiel Olea-Stock-Watson SVARIV suite, github.com/jm4474/SVARIV). Treat these as read-only references for translation, not as project code.
- **Articles:** `artigos/` contains source PDFs and marker-extracted `.md` for every reference (Alessi-Kerssenfischer, Gertler-Karadi, Jarociński-Karadi, Bauer-Swanson, Stock-Watson, Montiel Olea-Stock-Watson, Gonçalves-Rodrigues-Genta).

## Data layout

Inputs and intermediate files live under `data/` (gitignored). Key paths the scripts hard-code:

- `data/raw_data.csv` — merged monthly panel from `download.R`.
- `data/processed/data_log_deseasonalized.csv` — input to the DFM (drop `ref.date`, `drop_na`).
- `data/processed/instrument.csv` — single-column instrument consumed by both estimation scripts; overwritten by `instrument.R` from `DEFAULT_VARIANT` (current default: `z_jk_bs_purif` since 2026-07-15 — BS-faithful pre-event orthogonalization + JK mask on predetermined residuals, ξ_mp 10.43 full / 12.22 pre_covid at production (7,6) on the 2026-07-24 vintage; replaced `z_jk_purif`, whose contemporaneous-residual mask mislabels 2020-03-19 as monetary).
- `data/processed/instrumentos_mensais.csv` — the 10 GK-family variants side-by-side, incl. the raw-mask pair `z_jk_raw_purif`/`z_jk_raw_purif_local` and the fidelity-audit quartet `z_jk_raw`, `z_bs_purif`, `z_jk_bs_purif`, `z_jk_purif_us`. (Stale `z_het*` columns may survive in an old local copy — `instrument.R` no longer writes them.)
- `data/processed/focus_daily.csv` (Focus medians: IPCA-12m smoothed + next-year-end Selic), `data/fred_dgs2.csv` (UST 2y) — pre-event predictor inputs from `R/data_download/focus_fred.R`.
- `output/irf/spec_sweep_cells.csv`, `spec_sweep_irf_long.csv`, `spec_sweep_{report,stage2,conclusoes}.md`, `irf_spec_<tag>.{rds,pdf}`, `irf_spec_stage2_overlay.pdf` — specification-sweep artifacts (`irf_spec_sweep.R` / `irf_spec_stage2.R`).
- `output/irf/irf_coherence_h.csv` — point + 68/90 bands + significance flags for 52 variables × 49 horizons; **the source of every number in `irf_section.md`**. `irf_coherence_cell.rds` holds the full estimation object so follow-up analyses never re-estimate.
- `output/instrument/mosw_strength_grid.{csv,md}` — ξ_mp / joint Wald / ξ_k over (r,q) × sample × instrument; the strength ruler of record.
- `output/nongaussian/gate.md` — the at-most-one-Gaussian precondition on `eta`, per window, plus where the proxy's impact direction sits relative to the Gaussian span and how stable the monetary column is across optimizer starts. `results.md` / `irf_comparison.{csv,pdf}` / `gmr_cell.rds` — the GMR production run, the Wald test of the proxy restriction and the GMR-vs-proxy IRF comparison.
- `data/di.csv`, `data/copom_historico.csv`, `data/processed/ibov_daily.csv`, `data/processed/brl_usd_daily.csv`, `data/investing/external_factors_daily.csv` — daily inputs to instrument construction.
- `data/yields/yields_dia.csv` — advisor-supplied yield curve at fixed maturities (3/6/12/24/60/120 months, `dd/mm/yyyy`), read by `download.R`. Fixed external input, no producer in the repo.

Sample: 2013-01 to 2025-09, monthly, **106 series** (vintage refreshed 2026-07-24; the duplicated tempo-de-procura block `.x`/`.y` and the empty ANBIMA break-even columns were dropped, and `download.R`/`clean.R` now persist their outputs via `write_csv` — the old scripts computed but never wrote). Policy variable for normalization is **`yield_6m`** (audit-validated 2026-04-25, F = 21.3 against AR(6) innov; `juros_selic` is overnight Selic accumulated and is the documented negative control — max reduced-form F = 2.49 across the whole grid); shock normalized to +50bp on impact via `mp_var = "yield_6m"` in `script/model_alessi.R`.
