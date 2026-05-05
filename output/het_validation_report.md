# Heteroskedasticity instrument — validation report
Date: 2026-05-05
Specification: z_het_jk + yield_6m, AR(6) residualization
Sample: 2013-01-01 to 2025-12-31 (156 months)

## T1 — Placebo (permutation of z_het_jk)

Under random permutation of the monthly instrument the first-stage F
should concentrate near 1; a small empirical p-value confirms the
observed F = 21.293 result is not data-snooping.

- observed F = 21.293
- placebo: n_perm = 2000, mean F = 1.224, median F = 0.544, q95 = 4.732, q99 = 8.078, max = 34.519
- p-value (P(F_perm ≥ observed)) = 0.0005

Histogram: `output/het_validation_placebo.png`

## T2 — Random-mask vs JK filter

Random subsets of 42 Copom days (matching JK count) are kept; the
remaining days are zeroed before monthly aggregation. If the JK F merely
reflects sparsification, the JK F would lie inside the random-mask
distribution. If JK is genuinely informative (sign filter separates
monetary from information shocks), JK F sits in the upper tail.

- JK observed F = 21.293 (k_keep = 42 / 97)
- random mask: n_draws = 2000, mean F = 5.733, median F = 4.207, q95 = 15.108, q99 = 21.463, max = 41.131
- p-value (P(F_mask ≥ JK)) = 0.0105

Histogram: `output/het_validation_random_mask.png`

## T3 — Sub-period stability

Sub-windows defined in HANDOFF.md: pre-COVID (2013-2019), COVID + post
(2020-2025), and full sample with the COVID acute window (2020-03 to
2020-09) excluded. The AR(p) residualization is estimated **once** on the
full contiguous sample and the residuals are subset by window — refitting
AR within `drop_covid` would lag October 2020 on February 2020 (the
non-contiguous window introduces a spurious lag jump).

| window      |  n  | F      | beta   | se     | R²     | n_eff |
|-------------|-----|--------|--------|--------|--------|-------|
| full        | 156 | 21.293 | 0.003 | 0.001 | 0.190 | 150 |
| pre_covid   |  84 | 38.097 | 0.003 | 0.000 | 0.254 |  78 |
| covid_post  |  72 | 11.240 | 0.004 | 0.001 | 0.171 |  72 |
| drop_covid  | 149 | 24.231 | 0.003 | 0.001 | 0.213 | 143 |

## T4 — Correlation with z_jk_purif

Convergence of heteroskedasticity-based and timing-based identification.
If both instruments capture the same monetary shock, the correlation on
the both-nonzero subset should be high.

| subset        |  n  | pearson | spearman |
|---------------|-----|---------|----------|
| all           | 156 | 0.745 | 0.715 |
| union_nonzero | 71  | 0.745 | 0.740 |
| both_nonzero  | 36  | 0.933 | 0.937 |

## T5 — Anti-JK mask

Complement of the JK filter: keep Copom days where sign(daily shock)
matches sign(IBOV change) — the days JK classifies as information shocks
and zeros out — and zero the days JK keeps as pure monetary. Aggregate
monthly and recompute F. Reading: F(anti-JK) close to the random-mask
mean indicates that JK selects the right subset of Copom days; F(anti-JK)
comparable to the JK F would imply that JK only sparsifies and the sign
criterion is not informative.

- F(anti-JK) = 0.194, beta = 0.000, SE = 0.000, R² = 0.001
- days kept (sign-equal, info) = 55 / 97 Copom days; 0 zero-sign excluded
- comparison: JK F = 21.293 (k=42), random-mask mean F = 5.733 (k=42)

## T6 — F(k_keep) curve

Random masks at varying k_keep separate two explanations for the JK F:
(i) JK selects the k_JK ≈ 42 right days — F is high at k = k_JK and lower
at other k; (ii) JK only sparsifies — F grows monotonically with sparsity
for any random mask. The JK F observed (= F(z_het_jk + yield_6m)) is
the dashed reference line in the plot.

| k_keep | n_draws | mean | median | q95 | q99 | max | p(F_random ≥ JK) |
|--------|---------|------|--------|-----|-----|-----|------------------|
|  20 | 2000 | 5.537 | 3.274 | 18.073 | 32.430 | 86.296 | 0.0340 |
|  42 | 2000 | 5.612 | 4.414 | 14.347 | 20.826 | 33.740 | 0.0095 |
|  60 | 2000 | 6.238 | 5.078 | 14.494 | 19.292 | 34.179 | 0.0060 |
|  80 | 2000 | 6.886 | 6.289 | 13.402 | 16.669 | 20.485 | 0.0000 |

Boxplot: `output/het_validation_f_curve.png`

## Files

- `output/het_validation_placebo.csv` — F across permutations
- `output/het_validation_random_mask.csv` — F across random masks (k = JK)
- `output/het_validation_subperiod.csv` — sub-period F table
- `output/het_validation_correlation.csv` — Pearson / Spearman
- `output/het_validation_anti_jk.csv` — single-row T5 summary
- `output/het_validation_f_curve.csv` — per-draw F across k_keep grid
- `output/het_validation_f_curve_summary.csv` — summary by k_keep
- PNG: `het_validation_placebo.png`, `het_validation_random_mask.png`,
  `het_validation_f_curve.png`
