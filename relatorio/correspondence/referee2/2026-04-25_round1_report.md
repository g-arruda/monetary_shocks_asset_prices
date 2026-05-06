=================================================================
                        REFEREE REPORT
        monetary_shocks_asset_prices — Heteroskedasticity-ID — Round 1
                       Date: 2026-04-25
=================================================================

## Summary

Audited two new artifacts on branch `feature/het-identified-instrument`:
`R/identification/het_shock_extraction.R` (primitives implementing Rigobon-Sack
2003 *QJE* identification + Mertens-Ravn 2013 GLS shock recovery) and
`script/instrument_het.R` (pipeline producing the monthly instrument `z_het`).
A pure-Python replication of the core identification on the R-built daily
change matrix matches the R output to 6+ decimal places for all key objects
(eigenvalues, impact column, monthly aggregated shock series). Two minor
methodological concerns and three small code-level concerns are filed below.

**Verdict:** Minor Revisions.

---

## Audit 1: Code Audit

### Findings

1. **Inconsistent NA handling between `validate_variance_split` and `extract_shock_rigobon_sack`.**
   `R/identification/het_shock_extraction.R:139–142` filters NAs per variable
   (`xC <- xC[!is.na(xC)]`), so the variance ratio for DI_3m uses n_C=104,
   n_NC=542. `extract_shock_rigobon_sack:178–179` filters by row-wise
   `complete.cases`, so the identification uses n_C=97, n_NC=524. The split
   is defensible (univariate vs multivariate), but the asymmetry is silent
   and the report does not flag it. **Severity: low.**

2. **Sign-flip when `b_1[mp_var_idx] == 0`.**
   `R/identification/het_shock_extraction.R:208`: `if (b_1[mp_var_idx] < 0) b_1 <- -b_1`.
   If the policy variable does not load on the leading eigenvector at all
   (theoretically possible; in practice DI_3m has the largest variance shift,
   ratio 5.7), `b_1[mp_var_idx]` is exactly zero and the sign is undefined.
   **Severity: low (edge case unlikely in this data).**

3. **`max_gap_days` rationale not explicit in the script.**
   `script/instrument_het.R:32` sets `MAX_GAP_DAYS <- 3L`. The docstring of
   `build_daily_regimes` explains why (drops Carnaval-week pairs), but the
   script-level constant is bare. **Severity: trivial.**

### Missing Value Handling Assessment

NAs arise when a Wed–Thu pair lacks a DI contract match at the requested
maturity, when an IBOV/BRL close is missing on a holiday, or when the panels
disagree on coverage. The pipeline is consistent at the identification stage
(complete-case rows). The variance validation step uses per-column NA
filtering, which preserves a slightly larger sample for DI variables that
have fewer matched contracts. Result is internally consistent; flagged only
as transparency concern (Finding 1).

---

## Audit 2: Cross-Language Replication

### Replication Scripts Created

- `code/replication/referee2_replicate_het_shock.py` — pure NumPy
  implementation of Sigma_C / Sigma_NC / dSigma, eigendecomposition, sign
  normalization, GLS shock projection, and monthly aggregation.
- `code/replication/referee2_daily_changes.csv` — R-built daily change
  matrix used as the common input.
- `code/replication/referee2_py_*.csv` — Python outputs (variance, b_1,
  eigenvalues, monthly z_het).

Stata replication was not produced (no value over the Python check given
the small system; the bottleneck is the eigendecomposition, which numpy
and base R both delegate to LAPACK).

### Comparison Table — eigenvalues of dSigma

| Position | R          | Python     | abs diff   | Match? |
|----------|-----------:|-----------:|-----------:|--------|
| lambda_1 | 221.879374 | 221.879374 | 4.85e-07   | ✓ |
| lambda_2 |  41.143179 |  41.143179 | 1.58e-07   | ✓ |
| lambda_3 |   0.407848 |   0.407848 | 2.72e-07   | ✓ |
| lambda_4 |  -0.562701 |  -0.562701 | 4.75e-07   | ✓ |

### Comparison Table — impact column b_1

| Variable | R          | Python     | abs diff   | Match? |
|----------|-----------:|-----------:|-----------:|--------|
| DI_3m    |   6.071683 |   6.071683 | 7.58e-08   | ✓ |
| DI_2y    |  13.598124 |  13.598124 | 1.34e-07   | ✓ |
| IBOV     |   0.171637 |   0.171637 | 1.46e-07   | ✓ |
| BRL      |  -0.274956 |  -0.274956 | 1.92e-07   | ✓ |

### Comparison Table — monthly z_het

| Quantity              | R         | Python    | Match? |
|-----------------------|----------:|----------:|--------|
| rows                  |       156 |       156 | ✓ |
| nonzero rows          |        97 |        97 | ✓ |
| sd                    |  0.931066 |  0.931066 | ✓ |
| max abs(R - Py)       |           |  4.94e-07 | ✓ |
| correlation(R, Py)    |           | 1.0000000 | ✓ |

### Discrepancies Diagnosed

None at 6+ decimal places. Differences are at the LAPACK rounding boundary
(~1e-7), consistent with floating-point precision and not a coding error.

The variance ratio for DI_3m differs at the second decimal between the R
report (5.73, n_C=104, n_NC=542) and the Python script (5.45, n_C=97,
n_NC=524) due to Finding 1 above (different NA handling). Both numbers
are valid under their respective sample definitions; neither is wrong.

---

## Audit 3: Directory & Replication Package

### Replication Readiness Score: 7/10

**Pass:**
- Folder structure clean (`R/identification/`, `script/`, `data/processed/`,
  `output/`).
- Relative paths used throughout.
- Naming conventions clear (`extract_shock_rigobon_sack`, `z_het`).
- No master script needed for this PR — the existing project patterns
  (per-stage scripts) are followed.

**Deficiencies:**
- No seed for the bootstrap inside `validate_variance_split` is exposed by
  default in the entry script (the function defaults to `NULL`, but
  `instrument_het.R:97` does pass `seed = 42L`). Consider documenting that
  the variance CIs are deterministic only with this seed.
- `R/data_download/external_factors.R` does not download dependencies into
  a documented `data/raw/` subtree; outputs land in `data/investing/` and
  `data/processed/`. Consistent with project history but a public
  replication package would prefer `data/raw/` for downloads.

### Dependencies

R packages used by the new code: `dplyr`, `lubridate`, `tidyr`, `readr`,
`purrr`, `tibble`, `quantmod`, `zoo`, `stats`. All standard. No version
pin.

---

## Audit 4: Output Automation

**Tables:** Automated. `output/het_*.csv` are produced by R; the markdown
tables in `instrument_diagnostics_report.md` are built programmatically
from those CSVs.

**Figures:** Automated. `output/het_eigenvalues.png` is generated by
`ggsave()`.

**In-text statistics:** N/A for this PR (no in-text values pulled into
the documentation outside the auto-generated report).

**Reproducibility:** running `Rscript script/instrument_het.R` twice
produces byte-identical CSVs (verified during development), modulo the
bootstrap CI which is seeded.

---

## Audit 5b: Time-Series / SVAR Econometrics

### Identification Strategy

Rigobon-Sack (2003, *QJE*) heteroskedasticity-based proxy: under A1
(`σ²_{1,C} > σ²_{1,NC}`) and A2 (`σ²_{j,C} = σ²_{j,NC}` for `j > 1`), the
matrix `dSigma = Σ_C - Σ_NC` is rank 1 with the policy-shock impact column
on its leading eigenvector. The shock series is recovered by Mertens-Ravn
(2013) GLS projection. The identified series is then aggregated monthly
and consumed as an external instrument (proxy SVAR) by the existing DFM
pipeline (Stock-Watson 2018, *EJ*; Alessi-Kerssenfischer 2019).

### Identification Assessment

The strategy is **credible** for Brazil given:
- Copom is announced after market close (Wed evening) — so the relevant
  reaction window is Wed close → Thu close, which is what the pipeline
  uses.
- A1 is sharply confirmed: ratio Var(ΔDI_3m | C)/Var(ΔDI_3m | NC) = 5.45,
  IC 99% [1.95, 14.08], excludes 1 (replicating GRG 2025 Tab 1).
- A2 is confirmed for IBOV (ratio 0.97, IC [0.49, 1.76]) and BRL (ratio
  1.07, IC [0.66, 1.58]).

### Specification Issues

1. **Effective rank of dSigma is 2, not 1 (Minor Concern).**
   Eigenvalues 221.9, 41.1, 0.4, -0.6. The second eigenvalue is 18% of the
   spectrum (rank1_share = 0.84). This means DI_2y also has a real variance
   shift in regime C — the policy shock affects both short and medium DI
   ends, generating a 2-dimensional subspace of variance change rather
   than a strict rank-1 column. The leading eigenvector b_1 captures the
   principal direction within that subspace; the identified `z_het` is
   therefore a projection onto the dominant policy-news direction, with a
   small residual leakage from the secondary direction (which itself is
   policy-related, not contamination from a different structural shock).
   **Implication:** the identified shock is well-defined but is an aggregate
   "policy shock + correlated DI propagation," not a single textbook shock.
   Worth disclosing in the paper text.

2. **First-stage F (on monthly DFM residual) is weak (Major Concern).**
   `script/instrument_diagnostics.R` reports OSW F = 1.54 for `z_het`,
   versus F = 4.91 for `z_bruto_purif`. Below the Stock-Yogo 10 threshold
   *and* below the manual ξ_1 = 3.84 threshold. This is acknowledged in
   `_instrucoes/Heteroscedasticidade.md` ("Limitação conhecida"). For
   inference, Anderson-Rubin robust intervals are required; the standard
   percentile bootstrap CIs reported by the existing pipeline could be
   misleading. **Recommendation:** either flag z_het as a robustness
   instrument (not primary), or add an Anderson-Rubin path in the
   diagnostics report.

3. **Bootstrap does not propagate daily-stage extraction uncertainty
   (Minor Concern).**
   The wild bootstrap in `compute_irf_dfm` resamples the factor VAR
   residuals and re-multiplies the instrument by Rademacher draws, but
   `z_het` itself comes from a fixed daily-stage eigendecomposition. The
   uncertainty in `b_1` (and hence in the recovered shock series) is not
   propagated. A nested bootstrap (resample daily Wed-Thu pairs within C
   and NC, re-extract b_1, re-compute z_het, then run the monthly
   bootstrap) would be more honest. Likely material given how low F is.

4. **Lag selection / residual diagnostics:** N/A here — the daily
   identification is contemporaneous (no lags); the upstream factor VAR
   has its own diagnostics handled elsewhere.

5. **Real-time vs. revised data:** all daily data are revised closing
   prices. Acceptable for an event-study-style identification (no real-time
   counterfactual is being constructed).

---

## Major Concerns

1. **Weak monthly first-stage F (z_het OSW F = 1.54).**
   The Rigobon-Sack identification is sharp at the daily level (n_C=97
   Wed-Thu pairs with strong variance ratio for DI_3m), but the GLS
   projection + monthly aggregation produces a series whose first-stage F
   on the monthly DFM residual is weak. Inference using percentile
   bootstrap CIs may be misleading. Either (a) restrict use of z_het to
   robustness checks, or (b) implement Anderson-Rubin robust intervals,
   or (c) consider richer monthly aggregation (e.g., absolute-value sum,
   shock×|shock| weighting) that preserves more variance.

## Minor Concerns

1. **Effective rank of dSigma is 2, not 1.** The leading eigenvalue is
   84% of the spectrum but the second eigenvalue (DI_2y direction) is
   non-trivial (16%). The identified b_1 is the principal direction of a
   2-dim variance-shift subspace, not a strict rank-1 impact column.
   Disclose in the paper.

2. **Bootstrap does not propagate daily-stage extraction uncertainty.**
   Nested bootstrap recommended given the weak first-stage F.

3. **`validate_variance_split` uses per-column NA filtering while
   `extract_shock_rigobon_sack` uses row-wise complete cases.** Document
   the asymmetry or align them.

4. **Sign-flip edge case** when `b_1[mp_var_idx] == 0`: undefined sign.
   Add a guard or document the precondition.

5. **MAX_GAP_DAYS = 3 chosen ad hoc.** Document the rationale at the
   script level (Carnaval-week filter); currently only the function
   docstring explains it.

## Questions for Authors

1. Is `z_het` intended as the primary instrument (then F = 1.54 is a
   problem) or as a robustness check (then it is fine and the paper
   should phrase it that way)?

2. Was a nested bootstrap considered for the daily-stage extraction
   uncertainty? If not, is there an a priori reason it would be
   superfluous?

3. The second eigenvalue (DI_2y direction) suggests propagation of the
   policy shock along the DI curve. Have you considered using the
   *projection* of dSigma onto a 2-dim subspace and reporting the IRF
   along the principal axis explicitly, rather than only b_1?

---

## Verdict

[X] Minor Revisions

**Justification:** The mathematical implementation is correct (verified by
cross-language replication to 6+ decimal places). The identification
strategy is well-founded in the literature (Rigobon-Sack 2003, GRG 2025).
The remaining issues are (a) the weak monthly first-stage F, which
constrains how `z_het` should be used in the published paper, and (b) a
short list of code-level transparency improvements. None require
re-architecting the pipeline.

---

## Recommendations (prioritized)

1. **Decide z_het's role:** primary instrument (then implement Anderson-
   Rubin or nested bootstrap) vs. robustness check (then label it as such
   in the paper and diagnostics).
2. **Disclose the rank-2 finding** in `_instrucoes/Heteroscedasticidade.md`
   and the published methodology section.
3. **Align NA handling** between `validate_variance_split` and the
   identification step, or document the asymmetry.
4. **Add the sign-flip edge guard** (one line of code).
5. **Promote `MAX_GAP_DAYS` rationale** to a comment at the script level.
6. (Optional) Add a Stata replication if the paper goes for an explicit
   tri-language verification standard.

=================================================================
                      END OF REFEREE REPORT
=================================================================
