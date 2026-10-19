---
paths:
  - "R/modeling/**"
  - "R/identification/**"
  - "script/model_*.R"
  - "script/irf_coherence_check.R"
  - "script/validation/*.R"
---

# Identification core — do not silently re-architect

Two functions in `R/modeling/impulse_response.R` are the contract between the DFM/VAR and the
instrument:

- `sel_ext_inst_sample()` — temporal alignment, equivalent to MATLAB `selextinstsample.m`.
- `ident_ext_instr()` — projects raw IRFs through `H = (Z' rsh) / (Z'Z)` and normalizes the impact
  response of the policy variable to `normalize_value` in its *native units*: `shock_bps/10000` for
  decimal-proportion yields (50bp → 0.005, production since 2026-05-07) and `shock_bps/100` for
  percent-scale `juros_selic` (0.5, the default of `IdentExtInstr.m:14`). The argument has **no
  default** since 2026-09-18: every caller passes the value explicitly, as it did before. The
  `diagnose` printout and the `var_names`/`data_dates`/`rr` arguments left with it; the
  diagnostics it printed are `script/instrument_diagnostics.R`'s CSV.

**One branch.** `compute_irf_dfm` and `main_sdfm` (`R/modeling/dfm_pipeline.R`) take
`identification = "proxy"` and nothing else. The heteroskedasticity and non-Gaussian branches were
**abandoned on 2026-08-17** and the switch was collapsed — code, artefacts and verdicts in
`arquivo/heterocedasticidade/` and `arquivo/nao_gaussiana/`, summary in
`registro/historico_decisoes.md` §0 and §1. The argument is kept (rather than dropped) because six
live callers pass `identification = "proxy"` explicitly, five of them under `diagnostics/`, whose
scripts stay unedited (only `_common.R` was repointed, on 2026-09-21). The collapse was validated by the `CLAUDE.md` smoke test reproducing **bit-identically**
— that is the guard any future change to this file must clear.

**One inference, since 2026-09-08.** `compute_irf_dfm(inference=)` takes `"ar"` or `"none"` and
has no default. `"ar"` fills `ci` from the Anderson-Rubin sets (`ar_dfm_bands()` in
`R/identification/weak_iv_ar.R`), which is the production inference; `"none"` returns
the point alone, for cells compared point by point (`q_sensitivity.R`). The AR
branch hard-stops if its re-derived point deviates from `ident_ext_instr()` by more than 1e-10 — the
two paths must agree about the identification, not merely about the bands. `irf_point_matrix` is
untouched by the switch, so the `CLAUDE.md` smoke test stays the guard it was.
Since 2026-10-05 the DFM wiring of the sets (regressor rebuild, `Load`/`Inner`, the covariance and
the derivatives) is `ar_dfm_moments()`, which `ar_dfm_bands()` calls with unchanged signature and
return. `ar_statistic()` evaluates the inverted statistic at a given λ0, with its p-value and the
scalar moment series of each cell, from `mosw_rform_cov()$influence`, whose long-run covariance is
`WHat`. The split was bit-identical: smoke test, cache and the seven validators
(`notas/2026-10-05_precisao_ar.md`).

**The `hac_dim < T` gate is this project's safeguard, not the authors' condition.**
`mosw_rform_cov()` stops when the moment dimension `hac_dim` reaches `T`; there is no pseudo-inverse
and no fallback. `CovAhat_Sigmahat_Gamma.m:91-95` states the condition on the *parameter* dimension,
`n²p + n(n+1)/2 + nk < T` (120 in the production shape, against `hac_dim`'s 135), which is the
necessary one since `rank(WHat) ≤ min(par_dim, T−1)`. The moment gate is sufficient and strictly
stronger; both are checked since the 2026-09-08 fidelity audit, and at `p = 4` both bar the same two
cells, `(r,q) = (8,8)` and the whole pre-COVID window, so no published number depends on which binds.

**The wild bootstrap and the Kilian correction left the code on 2026-09-18** (author decision: the
AR sets replaced them). With them went `nboot`, `bootstrap_seed`, `apply_kilian`,
`kilian_correction()`, `estimate_corrected_var()` and the `*_corrected` fields of `estimate_dfm()`;
the last version that carried them is `main` at `07b1cbd`. `diagnostics/` still calls those
arguments and no longer runs against `R/`; it is the record of what ran on 2026-07-28 and stays
unedited (`diagnostics/README.md`).

**COVID volatility (Lenza-Primiceri 2022), PRODUCTION since 2026-09-17.**
`estimate_dfm(covid_volatility=)` and `main_sdfm(covid_volatility=)` put the common volatility scale
`s_t` of LP's Appendix B into the factor VAR:
- `covid_volatility_path()` builds `s_t`;
- `estimate_var_wls(type=, s=)` runs (B2) and returns (B4) and (B5); `s = 1`, its default, is OLS.
  `type` has no default: `"const"` for the factor VAR, `"both"` (constant and trend, divided by
  `s_t` like every row) for the monthly het VAR of Anexo B, since 2026-09-27;
- `estimate_covid_theta()` maximizes (B5) by L-BFGS-B inside the design's box, from one start.
  (B5) has three local maxima, and that start reaches the global one only because LP's
  `rho0 = 0.8` sits in its basin. Since 2026-09-24 θ̂ is guarded by a 750-start multi-start over
  the whole box (`output/factors/covid_volatility_multistart.csv`,
  `notas/2026-09-24_otimo_global_theta.md`). Since 2026-09-27 the three guards (first-order
  conditions, ρ profile, multi-start) are `verify_covid_theta()`, and every θ estimated with this
  function goes through it: the factor VAR's in `script/covid_volatility_theta.R`, and the three
  of the monthly het VAR in `script/het_conditions.R`, where (B5) has a single maximum
  (`notas/2026-09-27_het_var_escala_covid.md`). Since 2026-09-25 the script
  also estimates θ at `p = 2..6` for `script/p_sensitivity.R`, every guard at every `p`, into
  `output/factors/theta_by_p/`, and the optimizer differentiates with `ndeps = 1e-6`: the default
  1e-3 made the numerical gradient vanish before the true one, and the first-order guard stopped
  `p = 5` (`notas/2026-09-25_p_sensibilidade_anexo.md`).

**Since 2026-09-21 θ̂ is read, not typed.** `read_covid_volatility(path)`
(`R/modeling/factor_estimation.R`) builds the `covid_volatility` list from
`output/factors/covid_volatility_theta.csv`, the committed CSV that
`script/covid_volatility_theta.R` writes: θ̂ = (6.611488, 12.468194, 1.760038, 0.943951) since
2026-09-25 (before, 6.611429, 12.468338, 1.760352, 0.943926),
`covid_start` = 2020-03, `innovations = "standardized"` supplied by the loader, since it is a
design decision and not in the CSV. `readr` writes doubles at shortest-round-trip precision, so
the four values come back bit-identical — verified, the treated point did not move. `path` has no
default: every call site writes the file it reads, and a missing file `stop()`s with a pointer to
the producing script. `script/covid_volatility_theta.R` is the sole producer and therefore the one
script that must not read it; `script/validation/validate_production_spec.R` re-derives θ̂ from
`data/processed/` and stops if it moved. With the field set to NULL the whole `main_sdfm()` object
is `identical()` to the untreated code, which is what the N1/N2 checks still pin; the smoke test now pins the
**treated** point.

**`covid_volatility` is a required argument of `run_stage2_cell()`**, with no default: a default
either way would silently decide which
estimator a cell runs — that is how §4 and §5 would have ended up on different estimators. Cells
that publish production numbers pass `read_covid_volatility()` of the CSV; pre-COVID windows and
closed rounds pass NULL and say why at the call site. **The pre-COVID window cannot take it and
does not need it**: every month of it has `s_t = 1`, so the weighted fit *is* the unweighted one,
and window contrasts stay contrasts of window, not of estimator. Under the scale `r >= 7` is
explosive on the full window, so `mosw_strength_grid.R` sweeps r=4:6 there.

The list's three fields (`covid_start`, `theta`, `innovations`) take no default. The author's
decisions of 2026-09-14, which are how θ̂ is obtained, are written in
`script/covid_volatility_theta.R` (which applies them) and in
`script/validation/validate_production_spec.R` (which re-derives θ̂ under them):
- `t*` = 2020-03;
- s̄ ≥ 1 and ρ ∈ [0,1], the floor being what makes the maximum likelihood exist;
- `innovations = "standardized"`.

**Under the treatment nothing is centred.** `ident_ext_instr(center = FALSE)` keeps MOSW's
uncentered Γ (`SVARIV.m:128`), and K reads the uncentered second moment, which is (B4) for
`"standardized"`. AK's demeaning (`IdentExtInstr.m:5`, `cov(u)`) stays on the OLS path, where it is a
no-op.

**Inference under the treatment, since 2026-09-14.** With `"standardized"` the WLS is OLS on the
transformed regression. `ar_dfm_moments()` therefore feeds `mosw_rform_cov()` with:
- the regressors `(1, lags)/s_t`, the transformed constant first;
- the uncentered `u_t/s_t`;
- MOSW's uncentered Γ.

The sets condition on θ̂ as they do on Λ̂ and K̂. `diagnose_instrument_in_factor_space()` residualizes
z on the same transformed regressors, so it calls `compute_factor_space_wald()` and
`compute_robust_first_stage_F()` with `intercept = FALSE`. Its ξ_mp equals the `xi_den` of the AR sets.

`innovations = "raw"` still `stop()`s in the AR sets and in ξ_mp, because its influence function
is not derived. The rounds that ran untreated to compare against the bootstrap,
`arquivo/script/ar_bands.R` and `arquivo/script/irf_spec_stage2.R`, are archived.

This is reweighting of the estimation, **not** heteroskedasticity identification. Guard:
`script/validation/validate_covid_volatility.R`. Notes:
- `notas/2026-09-14_volatilidade_covid_lenza_primiceri.md` (implementation);
- `notas/2026-09-14_estimacao_theta_volatilidade_covid.md` (decisions and θ̂);
- `notas/2026-09-14_inferencia_volatilidade_covid_q.md` (inference, steps 3/4 and 4/4);
- `notas/2026-09-16_fidelidade_lenza_primiceri.md` (equation-by-equation fidelity audit);
- `notas/2026-09-17_volatilidade_covid_producao.md` (the switch to production).

**Estimation details.** The point estimate uses plain OLS (faithful to `DFMest_BLL.m`), WLS under
the COVID scale, and the AR sets read the same companion. `R/modeling/factor_estimation.R`
implements BLL standardization and the factor VAR; since 2026-09-18 every selector of the number of
factors lives in `R/modeling/factor_selection.R` — Bai-Ng IC for `r` and Amengual-Watson for `q`
beside the diagnostics below. `infer_tcode_from_varnames()` lives in `impulse_response.R`.

**Factor selection:** use the BLL-standardized Bai-Ng / Amengual-Watson variants. **Plain Bai-Ng
(2002) requires stationarity and is the wrong tool here** — the panel is non-stationary by design.
Ahn-Horenstein ER/GR and Alessi-Barigozzi-Capasso live in `R/modeling/factor_selection.R`
(`arquivo/script/factor_selection_alt.R`, archived 2026-09-17) as diagnostics on the same BLL
object; they do not set production `r`. Do not substitute the `factorselect` package for them: its GR and ABC diverge from the papers
(`notas/2026-09-10_selecao_fatores_ah_abc.md`). The correlation-pruned panels of `script/panel_pruning.R`
feed `script/factor_selection_pruned.R`, which runs the same battery plus Amengual-Watson. They are
diagnostics too and do not change the production panel (`notas/2026-09-10_poda_correlacao_painel.md`).

## Traps

- **The normalization trap.** The IRF is normalized by the column's *own* impact, so **every** column
  is worth exactly 0.005 at `yield_6m` in h=0 — any selection rule applied to the normalized IRF is
  degenerate. Selection must read the **pre-normalization** response; a `stopifnot` proves it did.
- **The scoring trap** (VAR-vs-DFM comparison). The DFM's *global* extremum has the **opposite sign
  to its impact** in the 8 equity responses, so scoring `|extremum|` compares a medium-run overshoot
  against a contraction. Use the **impact ratio** and the **same-signed peak**.
- **The scale trap** (companion-spectrum mode decomposition). Deleting modes changes the
  normalization denominator: sign and extremum horizon are immune, **magnitude is not** and must be
  read on the common scale.
- **tcode**: tcode 1 does **not** multiply by 100 (the `notransf` branch of `cumimp_transform`),
  which is why the asset block could not simply be moved back to it. Codes 1-5 are AK's `cumimp.m`;
  **code 6 is this project's** — `x * 100` with no accumulation — and the `asset_*` rows carry it
  since 2026-08-17, replacing the tcode-2 `cumsum`. The theory table of `script/irf_coherence_check.R`
  (formerly `coherence_var_table()`) still asks those rows for
  a *sustained* negative sign over h0-6, a price-level property a per-month return response does not
  have; the window was deliberately **not** retuned (author decision), and the cost is that four
  indices dropped from `coerente_forte` to `parcial`. **h = 0 is invariant to the whole change**: the
  `cumsum` is a no-op there and the ×100 is a positive scalar on point and both bounds.
- **`svars::id.cv()` is never called directly.** Its indicator path for a recurring regime is broken
  (`R/id.cv.R:177` subsets with `u[SB, ]`, reachable only with a numeric `SB`, so a 0/1 vector
  indexes by position) and the estimate silently collapses to `Λ = I`. `fit_het_cv()`
  (`R/identification/het_tests.R`) calls the package's estimator as `id.cv()` calls it internally
  and guards the result against the closed-form generalized eigendecomposition. `svars` (with
  `copula` and `gsl`) is installed for this test only (`notas/2026-09-22_condicao_het_svars.md`).

## Before touching the VAR benchmark

**Read `codigo_alessi-mark/MAIN_VARloop.m` first.** AK's core is `{activity, prices, medium-term
rate}` with the **rate as `mpind`** (`RUN_MAIN_US.m:7-9`) — AK never normalizes on an overnight rate,
which settles `juros_selic` on fidelity grounds too; `tcode` goes to the identification **subset to
the VAR** (`:28`); the `varlist` carries no curve vertices; the figure is VAR-left / DFM-right with
**`linkaxes`** (`MAIN_plotfigs.m:1-46`), the shared y axis being the whole point.
`R/modeling/var_proxy.R` is the engine, extracted from `script/model_var.R`.

The production cell, `ibc5_fx_cds_level_trend_p4`, runs the DFM's window and lag order since
2026-09-21 (author decision), so `T_eff = 162` equals the DFM's innovations. On the common `T = 154`
sample the AIC picks `p = 2` and the BIC `p = 1`; both are reported, and `validate_mosw_ar.R` pins
that `p = 4` is a deliberate departure (`historico_decisoes.md` §15). `hac_dim` 140 < 162, so the
gate passes. `R/identification/weak_iv_ar.R` is the module the DFM and the VAR share: `Load` and
`Inner` default to the identity, and `validate_mosw_ar.R` guards that the VAR path stays
bit-identical. Numbers: `notas/2026-08-22_var_niveis_aic_tendencia.md` and
`notas/2026-09-26_producao_bs_purif_bandas_80_90.md`.
