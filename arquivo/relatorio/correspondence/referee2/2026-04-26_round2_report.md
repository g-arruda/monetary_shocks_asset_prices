=================================================================
                        REFEREE REPORT
   Heteroskedasticity Instrument — Validation Tests — Round 2
                    Date: 2026-04-26
=================================================================

## Summary

Round 2 audits the four pending validation tests pending from the round 1
report (`2026-04-25_round1_report.md`) and HANDOFF.md: T1 placebo
(permutation of `z_het_jk`), T2 random-mask vs JK filter, T3 sub-period
stability, T4 monthly correlation between `z_het_jk` and `z_jk_purif`. Two
new files implement these: `R/identification/validation_tests.R` (function
library) and `script/instrument_validation.R` (pipeline). Cross-language
replication in Python (NumPy + statsmodels) matches the R implementation to
six decimal places on every deterministic statistic. The instrument
specification `z_het_jk + yield_6m` is **validated**: F = 21.29 is
demonstrably not data-snooping (placebo p < 0.005), JK informativeness is
not subsumed by sparsification (random-mask p ≈ 0.01), the F is reasonably
stable across sub-periods (10–38 across windows; only the COVID-acute window
drags F down to ≈10), and z_het_jk converges to z_jk_purif on months where
both fire (correlation 0.93 in pearson, 0.94 in spearman).

**Verdict: ACCEPT.** No major concerns. Two minor observations are noted at
the end of the report.

---

## Audit 1: Code Audit

### Findings

1. **`first_stage_F` numerical guard (resolved during round-2 development).**
   The function previously had no guard against degenerate inputs (constant
   `z` or fewer than 3 effective observations). In the placebo loop, where
   `z` is permuted 2000 times, a small fraction of permutations would
   place all 42 nonzero `z_het_jk` values within the first 6 months that the
   AR(6) drops, producing a constant `z` on the effective sample and an
   `lm`/`coeftest` failure. **Resolved**: the function now returns
   `NA_real_` if `sd(z[ok]) == 0` or `sum(ok) < 3`
   (`R/identification/validation_tests.R:36-50`).

2. **Sub-period AR residualization (resolved during round-2 development).**
   The original implementation refit the AR(6) within each sub-period and
   passed `target[keep]` to `first_stage_F`. For the contiguous windows
   (full, pre_covid, covid_post) this only forfeited the first 6
   observations of each sub-period. For the **non-contiguous** `drop_covid`
   window it produced a methodological bug: subsetting `target_dates` with
   `!(date in [2020-03..2020-09])` and then calling `dplyr::lag` would lag
   October 2020 on February 2020, contaminating the residual with a 7-month
   gap as if it were a 1-period lag. **Resolved**: residualization is now
   computed once on the full contiguous sample by `residualize_target()`,
   and `subperiod_F()` subsets the residual vector by window
   (`R/identification/validation_tests.R:73-100`,
   `script/instrument_validation.R:96`). The fix is materially significant:
   F on `drop_covid` changed from 26.0 (spurious, with the false lag) to
   24.2 (correct). The qualitative conclusion (drop-COVID strengthens
   identification relative to full sample) is robust to the fix.

3. **Random-mask k_keep alignment.** The script computes `n_jk_kept` locally
   (rebuilds the daily shock and JK mask with `extract_shock_rigobon_sack`
   and the same parameters as `script/instrument_het.R`) rather than trying
   to back-out 42 from the monthly file. This is correct: the monthly
   `z_het_jk` is summed over Copom months and `n_jk_kept` cannot be derived
   from the monthly series alone. The reextraction matches the production
   constants (`MP_VAR = "DI_3m"`, `MAX_GAP_DAYS = 3L`,
   `TARGET_BD_3M/2Y = 63/504`) — verified by `n_jk_kept = 42` (matches the
   message produced by `script/instrument_het.R`). No issue.

### Missing Value Handling Assessment

`first_stage_F` excludes positions where either `innov` or `z_aligned` is
NA via `ok <- !is.na(innov) & !is.na(z_aligned)`. The AR(6) residual is NA
in the first 6 positions by construction; the instrument can be NA outside
the union of `mensais$month` and `target_dates` (no occurrence in the
working sample). NA handling is conservative and correct.

`align_z_to_target` uses `left_join` on `floor_date(.., "month")`. This
defends against month-start vs month-end conventions across the pipeline.
Verified: 156 monthly observations preserved end-to-end.

---

## Audit 2: Cross-Language Replication

### Replication Scripts Created

- `correspondence/referee2/replication/referee2_replicate_validation.py` —
  pure NumPy/statsmodels recomputation of T1 placebo, T3 sub-period, T4
  correlation. T2 random-mask omitted because it depends on the daily shock
  series cross-validated in round 1
  (`referee2_replicate_het_shock.py`).

### Comparison Tables

**Observed first-stage F (`z_het_jk + yield_6m`, AR(6) residualization):**

| metric    | R                | Python           | Match? |
|-----------|------------------|------------------|--------|
| F_partial | 21.292873        | 21.292873        | ✓      |
| beta      | 0.0032088        | 0.0032088        | ✓      |
| se        | 0.0006954        | 0.0006954        | ✓      |
| n_eff     | 150              | 150              | ✓      |
| r²        | 0.190153         | 0.190153         | ✓      |

**T3 Sub-period F:**

| window       | n_months | F (R)      | F (Python) | Match? |
|--------------|----------|-----------|-----------|--------|
| full         | 156      | 21.292873 | 21.292873 | ✓      |
| pre_covid    | 84       | 38.096592 | 38.096592 | ✓      |
| covid_post   | 72       | 11.239871 | 11.239871 | ✓      |
| drop_covid   | 149      | 24.231269 | 24.231269 | ✓      |

**T4 Correlation:**

| subset         | n   | pearson (R) | pearson (Py) | spearman (R) | spearman (Py) | Match? |
|----------------|-----|-------------|--------------|--------------|---------------|--------|
| all            | 156 | 0.744570    | 0.744570     | 0.715500     | 0.715500      | ✓      |
| union_nonzero  | 71  | 0.744589    | 0.744589     | 0.740392     | 0.740392      | ✓      |
| both_nonzero   | 36  | 0.932747    | 0.932747     | 0.937194     | 0.937194      | ✓      |

**T1 Placebo (stochastic, expected to differ within MC noise):**

| metric        | R       | Python  | Δ     | Diagnosis                |
|---------------|---------|---------|-------|--------------------------|
| mean F        | 1.2200  | 1.2716  | +0.05 | PRNG difference          |
| median F      | 0.5440  | ~0.55   | ~0    | PRNG difference          |
| empirical p   | 0.0005  | 0.0015  | +1e-3 | PRNG difference          |
| n_perm        | 2000    | 2000    | —     | —                        |

### Discrepancies Diagnosed

- **Deterministic statistics:** Six-decimal agreement on all observed F's,
  sub-period F's, correlations, and OLS coefficients. No coding bugs in the
  R implementation are flagged by Python replication.
- **Placebo p-value (0.0005 vs 0.0015):** Different by 1/2000 of the sample.
  Source: R `set.seed(20260426L); sample(z)` and NumPy
  `np.random.default_rng(20260426).permutation(z)` produce uncorrelated
  random streams. Both p-values are decisively below any conventional
  threshold (0.01) and the mean F under the null is ≈1 in both — consistent
  with the asymptotic F(1, df) under H0.

The deterministic match across all observed statistics rules out the
hypothesis of orthogonal hallucination errors in either implementation.

---

## Audit 3: Directory & Replication Package

### Replication Readiness Score: 8/10

✓ `R/identification/` for primitives, `R/instrument/` for I/O, `script/`
for pipeline scripts.
✓ All paths relative to project root.
✓ Naming reflects content (`validation_tests.R` vs `instrument_validation.R`).
✓ Seeds set explicitly (`SEED_PLACEBO = 20260426L`, `SEED_MASK = 20260427L`).
✓ Required packages declared at top of each script.
✓ Data files documented in `CLAUDE.md`.

✗ No master `run_all.R` that ties `download.R → clean.R → instrument*.R →
  validation.R → model_*.R` together. Documented in `CLAUDE.md` but not
  scripted.
✗ Package versions not pinned (no `renv.lock` or sessionInfo capture).

### Deficiencies

1. Master script: would simplify replication for an external referee.
2. Version pinning: not strictly required for academic replication but
   recommended.

---

## Audit 4: Output Automation

- **Tables**: Automated. All numeric tables in
  `output/het_validation_report.md` are rendered by `sprintf` from the
  in-memory tibbles; no manual entry. ✓
- **Figures**: Automated. Both histograms (`het_validation_placebo.png`,
  `het_validation_random_mask.png`) saved by `ggsave` at fixed dimensions
  and DPI. ✓
- **In-text statistics**: Automated. `fmt()` helper interpolates results
  into report strings. No hardcoded numbers found. ✓
- **Reproducibility**: Re-running the script produces byte-identical
  outputs (seeds set; deterministic R OLS routines). ✓

No deductions.

---

## Audit 5: Econometrics

### Identification Assessment

The instrument design (`z_het_jk` extracted from heteroskedasticity-ID
daily SVAR + JK sign filter) is justified and documented in
`_instrucoes/Heteroscedasticidade.md`. The validation suite addresses the
exact concerns flagged by Bauer-Swanson (2023) and Jarociński-Karadi (2020)
for monetary policy instruments:

- **Data-snooping (T1):** Permutation-based, controls the family-wise
  rejection rate non-parametrically. Asymptotic F(1, 142) under H0
  has mean 142/140 ≈ 1.014; observed null mean of 1.22 is consistent.
- **Spurious sparsification (T2):** Random-mask null isolates the JK
  sign criterion from the mere effect of zeroing 55/97 days. JK F = 21.29
  sits in the upper tail of the random-mask distribution (q99 = 21.5);
  empirical p ≈ 0.01 confirms genuine informativeness.
- **Sub-period stability (T3):** Three windows. Pre-COVID strongest
  (F = 38.10), COVID+post weakest (F = 11.24), full-sample minus the
  acute COVID window (March–September 2020) intermediate (F = 24.23).
  Even the worst window passes the Stock-Yogo F > 10 threshold.
- **Convergence with timing-based ID (T4):** Pearson 0.93 / Spearman 0.94
  on months where both `z_het_jk` and `z_jk_purif` fire. Different
  identification logics agree on direction and magnitude — a strong piece
  of evidence that the heteroskedasticity-ID is recovering the same
  monetary shock as the timing-window ID, not a different latent factor.

### Time-Series Sub-Audit (5b)

- **Stationarity:** Daily SVAR uses Wed→Thu CHANGES in DI futures (already
  in basis points), log-returns of IBOV and BRL/USD. All four series are
  stationary by construction. Monthly target `yield_6m` enters AR(6)
  residualization, which is the standard MOSW partial-F preprocessing.
- **Lag selection:** AR order n = 6 is hard-coded. **Minor concern**: the
  scripts do not report sensitivity to AR order. The standard practice
  (Stock-Watson 2018) is to report F at p ∈ {3, 6, 12}.
- **SVAR identification:** Heteroskedasticity-based (Rigobon 2003) with
  Mertens-Ravn (2013) GLS shock recovery. Documented and replicated in
  round 1 (`referee2_replicate_het_shock.py`).
- **Standard errors:** HC0 robust on the first-stage regression. Stock-Yogo
  critical value F > 10 referenced. ✓
- **Bootstrap bands:** The validation tests are themselves the bootstrap
  procedures (placebo permutation, random-mask resampling). The downstream
  IRF inference uses Gonçalves-Kilian wild bootstrap, audited in round 1.

### Specification Issues

None requiring revision. Minor concerns are listed below.

---

## Major Concerns

None.

---

## Minor Concerns

1. **AR-order sensitivity not reported.** The pipeline hard-codes `N_LAGS =
   6L`. Recommendation: produce a small auxiliary table reporting observed
   F and placebo p-value for p ∈ {3, 6, 12} as a footnote in the validation
   report.

2. **T3 covid_post n_eff vs n_months mismatch.** Window has 72 months but
   `n_eff = 72` in the post-fix output, identical. This is correct (full-
   sample residualization → no AR observations are lost INSIDE the window
   because the residuals at 2020-01..2020-06 were computed using the
   2019-07..2019-12 lags). This is not a concern; flagging only because the
   round-1 (pre-fix) value of 66 might be confusing if compared without
   context. The fix is correct; the change in `n_eff` is the intended
   effect.

---

## Questions for Authors

None. The implementation is complete, tested, and replicated across
languages.

---

## Verdict

[X] **Accept**
[ ] Minor Revisions
[ ] Major Revisions
[ ] Reject

**Justification:** All four validation tests deliver coherent, statistically
clear conclusions. The R implementation is correct (verified by Python
replication to six decimals on every deterministic statistic and by mean-F
≈ 1 under the placebo null in both). The bug introduced by sub-period AR
refitting was caught and corrected during round 2 development; the final
implementation residualizes once on the full contiguous sample and then
subsets, which is the methodologically defensible approach. No changes are
required before incorporating these results in the final paper.

---

## Recommendations

1. (Optional) Add a one-line table to
   `output/het_validation_report.md` reporting F and placebo p-value for
   AR(3) and AR(12) as a sensitivity check on the lag-order assumption.
2. (Optional) Add a master script `script/run_all.R` orchestrating the
   pipeline end-to-end.
3. Pre-emptive note for paper writeup: explicitly cite that the
   non-contiguous `drop_covid` window required full-sample residualization
   (not within-window) — this is a non-obvious methodological choice that
   reviewers will ask about.

=================================================================
                      END OF REFEREE REPORT
=================================================================
