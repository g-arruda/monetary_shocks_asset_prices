---
paths:
  - "R/modeling/**"
  - "R/identification/**"
  - "script/model_*.R"
  - "script/nongaussian_*.R"
  - "script/factor_stationarity.R"
  - "script/asset_representation.R"
  - "script/irf_spec_*.R"
  - "script/irf_coherence_check.R"
---

# Identification core — do not silently re-architect

Two functions in `R/modeling/impulse_response.R` are the contract between the DFM/VAR and the
instrument:

- `sel_ext_inst_sample()` — temporal alignment, equivalent to MATLAB `selextinstsample.m`.
- `ident_ext_instr()` — projects raw IRFs through `H = (Z' rsh) / (Z'Z)` and normalizes the impact
  response of the policy variable to `normalize_value` in its *native units*: `shock_bps/10000` for
  decimal-proportion yields (50bp → 0.005, production since 2026-05-07) and `shock_bps/100` for
  percent-scale `juros_selic` (the legacy default 0.5, mirroring `IdentExtInstr.m:14`). **That
  default has no consumer** — every caller passes the value explicitly.

**Three branches.** `compute_irf_dfm` and `main_sdfm` (`R/modeling/dfm_pipeline.R`) accept
`identification = c("proxy", "het", "nongaussian")`, dispatched by an explicit 3-way `switch` (the
old `else` was a catch-all that would silently route an unknown value into the proxy path). The het
branch is inert in production (modules archived 2026-07-26; the branch `stop()`s unless sourced from
`arquivo/`) but the architecture is deliberately kept.

**Estimation details.** The bootstrap uses Kilian-corrected coefficients for the DGP but the **point
estimate uses plain OLS** (faithful to `DFMest_BLL.m`); `apply_kilian = TRUE` only affects the
bootstrap. `R/modeling/factor_estimation.R` implements BLL standardization, Bai-Ng IC for `r`,
Amengual-Watson for `q`, plus `infer_tcode_from_varnames()` and `validate_dfm_results()`.

**Factor selection:** use the BLL-standardized Bai-Ng / Amengual-Watson variants. **Plain Bai-Ng
(2002) requires stationarity and is the wrong tool here** — the panel is non-stationary by design.

## Non-Gaussian branch (GMR 2017)

`identification = "nongaussian"` is Gouriéroux-Monfort-Renne (2017, *JoE* 196(1)) pseudo-ML ICA under
SIR3, **translated in-repo** in `R/identification/nongaussian_gmr.R` with the adapter in
`nongaussian_branch.R`. It prewhitens `eta`, estimates the orthogonal `C` by multi-start PML over the
Cayley parametrization, labels the monetary column by `|cor(eps_j, z)|`, and returns `b = P c_mp` —
so the instrument **labels** rather than identifies, and the proxy restriction becomes testable
(`gmr_wald_column`).

- **The gate passes on the full sample and fails pre-COVID**: under the 111-series `(5,5)`
  production, **0 of 5** factor innovations fail to reject normality in the full sample against a
  requirement of at most one, while **2 of 5** fail pre-COVID. Identification therefore exists only
  in the full window (`output/nongaussian/gate.md`). The 3-of-6 / 5-of-6 reading came from the
  106-series `(7,6)` vintage and is dead.
- **`NG_STARTS = 200`** — 60 starts do not reach the optimum.
- **Do not call `IdSS::estim.SVAR.ICA`** — Renne's ICA path is broken for n ≥ 4 (`make.M`/`make.C`
  mis-order the skew-symmetric fill; the gradient uses `(I+A)` where Cayley requires `(I+C)`). q = 5
  here. `make.Omega` / `make.A.matrix` / `make.Asympt.Cov.delta` *are* correct and are the
  cross-validation targets. `registro/historico_decisoes.md` §0.1.
- **The wild bootstrap is invalid on this branch** — Rademacher multipliers zero all third moments
  and destroy the asymmetry Assumption A.5 needs. It resamples i.i.d. with replacement (as GMR's
  appendix §E does); proxy and het keep Rademacher.
- `R/identification/nongaussian_labelling.R` is **diagnostic-only** — sourced by
  `script/nongaussian_{corroboration,labelling}.R` and by nothing on the production path.

LMS (2017) via `svars::id.ngml` is still open as the parametric-ML twin.

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
  since 2026-08-17, replacing the tcode-2 `cumsum`. `coherence_var_table()` still asks those rows for
  a *sustained* negative sign over h0-6, a price-level property a per-month return response does not
  have; the window was deliberately **not** retuned (author decision), and the cost is that four
  indices dropped from `coerente_forte` to `parcial`. **h = 0 is invariant to the whole change**: the
  `cumsum` is a no-op there and the ×100 is a positive scalar on point and both bounds.

## Before touching the VAR benchmark

**Read `codigo_alessi-mark/MAIN_VARloop.m` first.** AK's core is `{activity, prices, medium-term
rate}` with the **rate as `mpind`** (`RUN_MAIN_US.m:7-9`) — AK never normalizes on an overnight rate,
which settles `juros_selic` on fidelity grounds too; `tcode` goes to the identification **subset to
the VAR** (`:28`); the `varlist` carries no curve vertices; the figure is VAR-left / DFM-right with
**`linkaxes`** (`MAIN_plotfigs.m:1-46`), the shared y axis being the whole point.
`R/modeling/var_proxy.R` is the engine, extracted from `script/model_var.R`.
