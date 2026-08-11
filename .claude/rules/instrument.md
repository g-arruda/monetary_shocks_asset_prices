---
paths:
  - "R/instrument/**"
  - "script/instrument*.R"
  - "script/jk_sovereign_confound.R"
  - "script/fomc_coincidence.R"
  - "script/mosw_strength_grid.R"
  - "script/xi_mp_robustness.R"
  - "script/ar_bands.R"
  - "script/validate_*.R"
---

# Instrument construction and strength

**The build chain lives in `R/instrument/build_variants.R`** (helpers in `di_surprise.R`,
`event_tests.R`), parameterized by `target_bd` and `agg` (`agg_monthly_sum` / `agg_monthly_gk`).
`script/instrument.R` calls it once with production values and keeps **all** I/O. Production vertex
is `TARGET_BD = 126` ≈ 6m DI; `DEFAULT_VARIANT` controls the legacy single-column
`data/processed/instrument.csv`.

The 8 variants are GK-style futures surprises + Jarociński-Karadi sign filter + global-factor
cleanup. Monthly aggregation is JK's within-month sum, **not** GK's moving-average scheme — a
justified choice since 2026-07-27, not a deviation: GK's fn. 11 conditions its weighting on a
*monthly-average* policy indicator while `yield_6m` here is end-of-month, and the GK scheme on this
panel collapses ξ_mp from 10.43 to 0.30.

**The finding that governs variant choice: strength lives in the *mask*, not the purified values.**
Predetermined masks (raw or BS-pre-event) exclude the 2020-03-19 COVID panic day that
contemporaneous residual-sign classification mislabels as monetary. Quantified by the FOMC round:
orthogonalizing the **values** costs ~0.2 of ξ_mp; **re-deriving the mask** costs ~2.5 — twelve times
more, because the global block explains far more of the equity leg than of the DI leg, and the equity
leg is half the sign rule.

## ξ_mp is the strength ruler of record

`compute_factor_space_wald` (`R/modeling/impulse_responde.R`) — the MOSW Wald in the
`yield_6m`-impact direction, validated against the authors' official code. The 95% AR set is a
bounded interval **iff ξ_mp > 3.84**; conventional bands are approximately valid at ξ_mp ≥ 10.
`nw_lags` defaults to 0 (Eicker-White), so every published number is unchanged; the Bartlett kernel
is only needed for a GK-aggregated instrument, which induces an MA(1). The legacy first-stage F
rulers (`f_factor`, F (y6m AR)) are still computed and reported but **stopped deciding on
2026-07-26**. Grid: `output/instrument/mosw_strength_grid.{csv,md}`.

## Traps

- **Fail loud on missing inputs.** `build_variants.R` computed a `fomc_coincide` flag that was
  identically FALSE for months because `instrument.R` fell back silently to an empty date vector.
  **The defect was the `else`**: a silent fallback makes "never collected" indistinguishable from
  "returned nothing". `load_fomc_dates()` now aborts, and `run_all.R` declares `data/raw/fomc_dates.csv`
  a hard requirement of the `instrument` stage.
- **Masks built from `sign(residuals(lm))` carry a `names` attribute** that a CSV round-trip drops.
  When checking a rebuilt daily panel against `copom_event_diagnostics.csv`, compare **values**, not
  `identical()`.
- **`denom_vs_prod`**: when the normalization denominator shrinks, part of a larger magnitude is
  arithmetic, not economics — and below ξ_mp 10 a variant supports **direction, not interval**.
- **`p_boot` is seeded per cell** (`wild_coef_test(key=)`), so adding a proxy cannot move another
  cell's p. Preserve that when extending either confound script.
- **`validate_*.R` must run off a committed fixture in `output/validation/`**, never off
  `codigos_externos/` — those are gitignored, which is why `validate_olea_kilian.R` was silently
  broken for months.
