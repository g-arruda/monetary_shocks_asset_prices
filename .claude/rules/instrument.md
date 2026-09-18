---
paths:
  - "R/instrument/**"
  - "script/instrument*.R"
  - "script/mosw_strength_grid.R"
  - "script/validation/*.R"
---

# Instrument construction and strength

**The build chain lives in `R/instrument/build_variants.R`** (helpers in `di_surprise.R`),
parameterized by the DI vertex `target_bd`. `script/instrument.R` calls it once with production
values and keeps **all** I/O. Production vertex is `TARGET_BD = 126` ≈ 6m DI;
`production_spec()$instrument` picks the column written to the legacy single-column
`data/processed/instrument.csv`.

**Only the three variants of `tab:first_stage` exist in live code since 2026-09-18**, one per
construction layer: `z_bruto` (raw Wed→Thu surprise), `z_bs_purif` (+ Bauer-Swanson pre-event
orthogonalization) and `z_jk_bs_purif` (+ Jarociński-Karadi sign filter on the BS residuals,
production). The contemporaneous purification, the raw-sign mask, the UST 2y control and the FOMC
flag left with the variants and tests they fed. Monthly aggregation is JK's within-month sum,
**not** GK's moving-average scheme — a justified choice since 2026-07-27, not a deviation: GK's
fn. 11 conditions its weighting on a *monthly-average* policy indicator while `yield_6m` here is
end-of-month, and the GK scheme on this panel collapsed ξ_mp from 10.43 to 0.30 (the GK aggregator
left the code on 2026-09-18). **The same-session S&P/VIX/Brent filter on the Thursday panel stays**:
those changes enter no regression any more, but dropping a Thursday without them is what defines
the sample of the BS regressions.

**The finding that governs variant choice: strength lives in the *mask*, not the purified values.**
Predetermined masks (raw or BS-pre-event) exclude the 2020-03-19 COVID panic day that
contemporaneous residual-sign classification mislabels as monetary. Quantified by the FOMC round:
orthogonalizing the **values** costs ~0.2 of ξ_mp; **re-deriving the mask** costs ~2.5 — twelve times
more, because the global block explains far more of the equity leg than of the DI leg, and the equity
leg is half the sign rule.

## ξ_mp is the strength ruler of record

`compute_factor_space_wald` (`R/modeling/impulse_response.R`) — the MOSW Wald in the
`yield_6m`-impact direction, validated against the authors' official code. The 95% AR set is a
bounded interval **iff ξ_mp > 3.84**; conventional bands are approximately valid at ξ_mp ≥ 10.
Since 2026-08-18 that boundedness prediction is no longer only a flag: `mosw_ar_bounds`
(`R/identification/weak_iv_ar.R`) actually constructs the set for the **small VAR**, and its
`ahat > 0` test is the same inequality. **Since 2026-09-08 the same holds for the DFM**: the sets
are production inference, `script/irf_coherence_check.R` asserts `ahat > 0` agrees with
`xi_den > critval` on every run, and `xi_den` reproduces the grid's `wald_mp` to 7.5e-12 by an
independent route — the MOSW `W2` block instead of `compute_factor_space_wald`. What the grid does
**not** tell you is whether a cell can be estimated at all: `mosw_rform_cov` needs
`hac_dim = (1 + r*p + r + 1)*r < T`, so `(8,8)` at `p=4` (336 ≥ 162) and the pre-COVID window at
`p=4` (135 ≥ 90) carry an `ar_bounded` flag for a set that cannot be built.
`nw_lags` defaults to 0 (Eicker-White), so every published number is unchanged; the Bartlett kernel
is only needed for a GK-aggregated instrument, which induces an MA(1). The legacy first-stage F
rulers (`f_factor`, F (y6m AR)) are still computed and reported but **stopped deciding on
2026-07-26**. Grid: `output/instrument/mosw_strength_grid.csv` (the `.md` beside it stopped being
written on 2026-09-18 and stays as a cited record).

## Traps

- **Fail loud on missing inputs.** `build_variants.R` once computed a `fomc_coincide` flag that was
  identically FALSE for months because `instrument.R` fell back silently to an empty date vector.
  **The defect was the `else`**: a silent fallback makes "never collected" indistinguishable from
  "returned nothing". The flag and the FOMC-date input left the code on 2026-09-18 with the archived
  FOMC test; the lesson stands for every input.
- **Masks built from `sign(residuals(lm))` carry a `names` attribute** that a CSV round-trip drops.
  When checking a rebuilt daily panel against `copom_event_diagnostics.csv`, compare **values**, not
  `identical()`.
- **`denom_vs_prod`**: when the normalization denominator shrinks, part of a larger magnitude is
  arithmetic, not economics — and below ξ_mp 10 a variant supports **direction, not interval**.
- **The daily confound tests are archived**: `arquivo/script/jk_sovereign_confound.R` on 2026-09-17,
  `arquivo/script/fomc_coincidence.R` and its `arquivo/R/instrument/event_tests.R` on 2026-09-18.
  Their `p_boot` was seeded per cell (`wild_coef_test(key=)`), so adding a proxy could not move
  another cell's p; preserve that if they are ever revived.
- **`script/validation/*.R` must run off a committed fixture in `output/validation/`**, never off
  `codigos_externos/` — those are gitignored, which is why `validate_olea_kilian.R` was silently
  broken for months.
