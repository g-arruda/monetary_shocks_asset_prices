# Instrument Validity Diagnostics Report

**Date generated:** 2026-05-08  
**DFM sample:** 2013-01-01 to 2025-09-01  
**Identification:** proxy-SVAR with external instrument (Olea, Stock & Watson 2020).
**Instrument variants:** raw Copom-day ΔDI (3m), purified by global factors (SP500, VIX, Brent),
Jarociński-Karadi sign filter, and JK + purified.

---

## 1. First-stage comparison across variants

Three first-stage statistics are reported side by side:

- **F (DFM)** — partial F (= t²) of the instrument in the regression of the
  first-factor VAR residual on Z plus lagged factors, HC0 SE. This is the
  Olea-Stock-Watson statistic that governs weak-instrument bias inside the
  Alessi-Kerssenfischer proxy-SVAR; the relevant target is the DFM residual,
  not the policy rate.
- **F (y6m AR)** — partial F of the instrument against the AR(6) innovation
  of monthly `yield_6m` (univariate, HC0 SE). This is the audit statistic
  (`output/instrument/instrument_audit_report.md`, 2026-04-25): it measures relevance
  for the Selic-equivalent interpretation of the shock and feeds the
  normalization in `model_alessi.R` (`mp_var = yield_6m`).
- **F (factor-sp)** — max univariate F across the q dynamic factor
  innovations η = u K M⁻¹. This is the relevant weak-instrument metric
  for the proxy-SVAR projection H = (Z'η)/(Z'Z): if it is small, the
  IRFs become noise-dominated regardless of how strong Z is against any
  single reduced-form variable. **FS-Flag = WEAK-FACT when F (factor-sp) < 10.**
  Disagreement between F (factor-sp) and F (y6m AR) was the root cause
  of the 2026-05-08 IRF investigation: `z_het_jk_3var` had F (y6m AR) ≈ 56
  but F (factor-sp) ≈ 2.7, producing weak-instrument-driven sign reversals.

The three answers can disagree: e.g. `z_het` was reported with F (DFM) ≈ 1.5
and F (y6m AR) ≈ 7.6 in earlier runs. ξ₁ uses the Olea-Stock-Watson
convention; threshold = 3.84.

| Variant | n (DFM) | nonzero | β̂ | SE(HC0) | t | p | F (DFM) | ξ₁ | R² | n (y6m) | F (y6m AR) | R² y6m | F (factor-sp) | impact y6m | sign | Exog F | Exog p | Flag | FS-Flag |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_bruto | 147 | 87 | -0.053 | 0.026 | -2.036 | 0.044 | 4.147 | 4.118 | 0.029 | 150 | 20.362 | 0.163 | 3.783 | +5.44e-05 | + | 0.998 | 0.430 | OK | WEAK-FACT |
| z_bruto_purif | 147 | 90 | -0.058 | 0.026 | -2.217 | 0.029 | 4.913 | 4.849 | 0.036 | 150 | 17.052 | 0.150 | 4.467 | +5.27e-05 | + | 1.019 | 0.416 | OK | WEAK-FACT |
| z_jk | 147 | 61 | -0.055 | 0.034 | -1.636 | 0.105 | 2.677 | 2.983 | 0.022 | 150 | 13.397 | 0.130 | 10.250 | +6.33e-05 | + | 1.912 | 0.083 | WEAK | OK |
| z_jk_purif | 147 | 63 | -0.059 | 0.034 | -1.742 | 0.085 | 3.035 | 3.300 | 0.025 | 150 | 11.402 | 0.122 | 11.765 | +6.23e-05 | + | 1.902 | 0.085 | WEAK | OK |
| z_het | 147 | 93 | -0.348 | 0.280 | -1.241 | 0.218 | 1.540 | 1.430 | 0.011 | 150 | 7.607 | 0.093 | 3.064 | +4.29e-04 | + | 0.865 | 0.523 | WEAK | WEAK-FACT |
| z_het_jk | 147 | 40 | -0.070 | 0.394 | -0.177 | 0.859 | 0.032 | 0.037 | 0.000 | 150 | 21.293 | 0.190 | 3.852 | +1.39e-03 | + | 2.860 | 0.012 | WEAK | WEAK-FACT |
| z_het_3var | 147 | 93 | -0.522 | 0.307 | -1.701 | 0.092 | 2.894 | 3.043 | 0.021 | 150 | 21.667 | 0.078 | 4.020 | +3.44e-04 | + | 0.692 | 0.656 | WEAK | WEAK-FACT |
| z_het_jk_3var | 147 | 44 | -0.536 | 0.394 | -1.360 | 0.177 | 1.850 | 2.084 | 0.011 | 150 | 55.981 | 0.112 | 4.057 | +1.01e-03 | + | 1.727 | 0.119 | WEAK | WEAK-FACT |

---

## 2. Scatterplot — purified surprises on Copom days

Wrong-signed (information) share: **31.6%**.

![scatter](scatterplot_surpresas_copom.png)

Quadrants II & IV (green, negative co-movement) are classified as monetary shocks and kept in z_JK / z_JK_purif.  
Quadrants I & III (orange, positive co-movement) are classified as information shocks and zeroed out.

---

## 3. Variance F-test: Copom vs. non-Copom Thursdays

H0: equal variance.  Expect rejection for `e_DI` (news shock on Copom days), ideally NOT for `e_Ibov`.

| Series | Var(Copom) | Var(non-Copom) | n_C | n_NC | F | p-value |
|---|---|---|---|---|---|---|
| e_DI | 174.00 | 61.50 | 95 | 503 | 2.830 | 2.45e-13 |
| e_Ibov |   1.91 |  1.70 | 95 | 503 | 1.120 | 4.34e-01 |
| delta_DI (raw) | 175.00 | 61.80 | 95 | 503 | 2.830 | 2.34e-13 |
| delta_Ibov (raw) |   2.25 |  2.32 | 95 | 503 | 0.968 | 8.70e-01 |

---

## 4. Heteroskedasticity-identification (z_het)

### 4.1 GRG (2025) Table 1 — variance split between Copom (C) and non-Copom (NC) Wed→Thu pairs

Hypothesis A1 (policy shock variance shifts) requires the ratio for the policy variable to exclude 1 from above.  
Hypothesis A2 (other shock variances stable) requires the remaining variables' CIs to include 1.  
`a2_status` is `policy` for the policy variable, `pass` if the 99% CI includes 1, and `violated` otherwise (CI excludes 1 by either side).

**4-var production block (DI_3m, DI_2y, IBOV, BRL):**

| Variable | n_C | n_NC | Var(C) | Var(NC) | Ratio | CI 99% low | CI 99% high | A2 verdict |
|---|---|---|---|---|---|---|---|---|
| DI_3m | 104 | 542 |  89.90 |  15.70 | 5.730 | 2.340 | 13.80 | policy |
| DI_2y | 104 | 542 | 420.00 | 230.00 | 1.830 | 0.770 |  3.53 | pass |
| IBOV | 104 | 542 |   2.30 |   2.32 | 0.989 | 0.477 |  1.74 | pass |
| BRL |  97 | 524 |   1.12 |   1.05 | 1.070 | 0.699 |  1.62 | pass |

**3-var robustness block (DI_3m, IBOV, BRL):** drops DI_2y to test whether
the second eigenvalue of dSigma was driven by a separate shock (council Required 1).
Compare b_1 with the 4-var block in §4.3.

| Variable | n_C | n_NC | Var(C) | Var(NC) | Ratio | CI 99% low | CI 99% high | A2 verdict |
|---|---|---|---|---|---|---|---|---|
| DI_3m | 104 | 542 | 89.90 | 15.70 | 5.730 | 2.340 | 13.80 | policy |
| IBOV | 104 | 542 |  2.30 |  2.32 | 0.989 | 0.492 |  1.88 | pass |
| BRL |  97 | 524 |  1.12 |  1.05 | 1.070 | 0.644 |  1.68 | pass |

### 4.2 Eigenvalue spectrum of dSigma = Sigma_C - Sigma_NC

Under the rank-1 hypothesis (Rigobon-Sack 2003 §III), only one eigenvalue is non-zero.  
Informal gate: leading eigenvalue should account for > 60% of |sum| of eigenvalues.

| Rank | Variable (heuristic) | Lambda | |Lambda|/Sum(|Lambda|) |
|---|---|---|---|
| 1 | DI_3m | 222.000 | 0.84000 |
| 2 | DI_2y |  41.100 | 0.15600 |
| 3 | IBOV |   0.408 | 0.00154 |
| 4 | BRL |  -0.563 | 0.00213 |

![eigenvalues](het_eigenvalues.png)

**Formal rank tests** (replace the informal `rank1_share > 0.6` gate):

- _Rigobon (2003) Proposition 1 proportionality test_ — H0: Σ_C = a · Σ_NC.
  Failure to reject means the regimes' covariance matrices are similar up to
  scale, so dSigma carries no rotation and b_1 is undefined. Mauchly LR with
  wild-bootstrap-calibrated p-value (n_C ≈ 50 makes χ² unreliable).
- _Lanne-Lütkepohl (2008) LR rank-1 test_ — H0: rank(dSigma) = 1.
  Failure to reject means a rank-1 approximation is adequate (the leading
  eigenpair captures the entire shift), justifying b_1 = sqrt(λ_1) v_1.
- _Bootstrap rank-1 share CI_ — non-parametric bootstrap quantiles of
  λ_1 / sum |λ_j|, descriptor alongside the LR tests.

Hansen J overidentification test is unavailable in our R = 2 setup
(Rigobon 2003, Proposition 2: df = 0); to unlock it the NC regime would
have to be sub-split into ≥ 3 windows.

**4-var production block**
- `rigobon_prop1_proportionality`: LR = 135.13 (df = 9), p_chi2 = < 0.001, p_boot = < 0.001, n_boot = 1000
- `lanne_lutkepohl_rank1`: LR = 102.60 (df = 6), p_chi2 = < 0.001, p_boot = 0.137, n_boot = 1000
- Bootstrap rank-1 share 95% CI: [0.666, 0.930] (point 0.840, n_boot = 1000)

**3-var robustness block**
- `rigobon_prop1_proportionality`: LR = 106.54 (df = 5), p_chi2 = < 0.001, p_boot = < 0.001, n_boot = 1000
- `lanne_lutkepohl_rank1`: LR = 28.42 (df = 3), p_chi2 = < 0.001, p_boot = 0.298, n_boot = 1000
- Bootstrap rank-1 share 95% CI: [0.948, 0.995] (point 0.987, n_boot = 1000)

### 4.3 Impact column b_1 (sign normalized so b_1[DI_3m] > 0)

Side-by-side comparison of the 4-var production block and the 3-var
robustness block. If A2 is violated by DI_2y, the 4-var b_1 conflates the
policy shock with a second structural shock; the 3-var b_1 is the cleaner
estimate. Compare the magnitude and (especially) the relative weights on
DI_3m, IBOV, BRL across columns.

| Variable | b_1 (4-var) | b_1 (3-var, drops DI_2y) |
|---|---|---|
| DI_3m | 6.072 | 8.433 |
| DI_2y | 13.6 | - |
| IBOV | 0.1716 | 0.0246 |
| BRL | -0.275 | -0.3155 |

### 4.4 Second eigenpair b_2 (descriptor only — arbitrary under A1-A3)

Under the rank-1 identifying restrictions A1-A3 (Rigobon-Sack 2003 §III),
the second eigenvector of dSigma lies in the rank-1 nullspace and is
arbitrary. When A2 fails for some non-policy variable (e.g., DI_2y in the
4-var SVAR with λ_2 ≈ 41), v_2 carries structural information consistent
with a second policy-adjacent shock — most likely a forward-guidance /
belly-of-curve shock. Treat as a descriptor: do not use as a second
identified instrument under A1-A3 alone.

| Variable | b_2 (4-var) | b_2 (3-var, drops DI_2y) |
|---|---|---|
| DI_3m | 5.853 | 0.01618 |
| DI_2y | -2.615 | - |
| IBOV | -0.1419 | 0.4467 |
| BRL | -0.1709 | 0.4672 |

Daily ε̂_2 series is persisted to `data/processed/instrument_z_het2{,_3var}.csv`.

---

## 5. Interpretation

- **F > 10 / ξ₁ > 10**: inference standard OK.  
- **F ∈ [5, 10]**: use Anderson-Rubin robust intervals.  
- **ξ₁ < 3.84**: instrument flagged as weak; AR CIs possibly unbounded.  
- Compare z_bruto vs. z_JK to assess whether the JK filter changes identification, and vs. their `_purif` counterparts for the role of global-factor contamination.
- **z_het** is identified by heteroskedasticity (Rigobon-Sack 2003 QJE) on the daily SVAR and is independent of the timing assumption that underlies the four GK-style variants. Convergence of `z_het` results with `z_jk_purif` is the central robustness check.
