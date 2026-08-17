---
paths:
  - "R/modeling/**"
  - "R/identification/**"
  - "script/model_*.R"
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

**One branch.** `compute_irf_dfm` and `main_sdfm` (`R/modeling/dfm_pipeline.R`) take
`identification = "proxy"` and nothing else. The heteroskedasticity and non-Gaussian branches were
**abandoned on 2026-08-17** and the switch was collapsed — code, artefacts and verdicts in
`arquivo/heterocedasticidade/` and `arquivo/nao_gaussiana/`, summary in
`registro/historico_decisoes.md` §0 and §1. The argument is kept (rather than dropped) because six
live callers pass `identification = "proxy"` explicitly, five of them under `diagnostics/`, which is
not editable. The collapse was validated by the `CLAUDE.md` smoke test reproducing **bit-identically**
— that is the guard any future change to this file must clear.

**Estimation details.** The bootstrap uses Kilian-corrected coefficients for the DGP but the **point
estimate uses plain OLS** (faithful to `DFMest_BLL.m`); `apply_kilian = TRUE` only affects the
bootstrap. `R/modeling/factor_estimation.R` implements BLL standardization, Bai-Ng IC for `r`,
Amengual-Watson for `q`, plus `infer_tcode_from_varnames()` and `validate_dfm_results()`.

**Factor selection:** use the BLL-standardized Bai-Ng / Amengual-Watson variants. **Plain Bai-Ng
(2002) requires stationarity and is the wrong tool here** — the panel is non-stationary by design.

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
