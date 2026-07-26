# Instrument Audit Report — heteroskedasticity-identified `z_het`
Date: 2026-04-25
Sample: 2013-01-01 to 2025-12-31

## Front 1.1 — aggregation convention

**Finding:** `juros_selic` is BCB series 4189 ("Selic acumulada no mês"), a flow-
type variable, ≈ monthly average. The current implementation aggregates the daily
shock by SIMPLE SUM (`R/identification/het_shock_extraction.R::aggregate_shock_to_monthly`).
**Mismatch.** Gertler-Karadi (2015) weighting (D - d + 1)/D is the correct fix
for an average/cumulative monthly target. The yield_* candidates (Svensson
end-of-month snapshot) admit simple sum; juros_selic / juros_cdi do not.

## Front 1.2 — maturity alignment

Daily anchor (sign normalization in `extract_shock_rigobon_sack`): **DI_3m**
(target_bd = 63 ≈ 3 months). Monthly DFM policy variable in CLAUDE.md and
`script/model_alessi.R`: **juros_selic** (overnight). Mismatch: the daily
extraction identifies a 3-month forward-rate shock; the monthly target is
the overnight policy rate. Fronts 2 and 3 quantify the impact.

## Front 1.3 — daily noise / rank-1 (already validated)

- Var(ΔDI_3m | C) / Var(ΔDI_3m | NC) = 5.73 (gate: > 2). **PASS**.
- Eigenvalues of dSigma: 221.88, 41.14, 0.41, -0.56
- λ₁ / |λ₂| = 5.39.
- rank-1 share = 0.840 (gate: > 0.6). **PASS**.

Daily signal is strong; the bottleneck is downstream (aggregation / maturity).

## Front 2 + Front 3 — grid: instrument variant × monthly policy candidate

Variants:
- `z_het` = simple monthly sum of daily shocks (current production).
- `z_het_gk` = Gertler-Karadi weighted sum.
- `z_het_jk` = JK filter (sign(ε̂)≠sign(ΔIBOV)) + simple sum.
- `z_het_jk_gk` = JK filter + GK weighting.

JK filter retains 42 / 97 Copom days (43.3% "pure monetary").

First stage on AR(6)-residualized monthly target. F is t² with HC0 SE.
Stock-Yogo critical value for one instrument: F > 10.

| variant       | candidate    |   n | beta   | se     | F      | R²     |
|---------------|--------------|-----|--------|--------|--------|--------|
| z_het         | juros_cdi    | 150 | 0.023 | 0.020 | 1.368 | 0.014 |
| z_het         | juros_selic  | 150 | 0.021 | 0.020 | 1.127 | 0.012 |
| z_het         | yield_1y     | 150 | 0.002 | 0.001 | 8.172 | 0.109 |
| z_het         | yield_2y     | 150 | 0.002 | 0.001 | 8.919 | 0.084 |
| z_het         | yield_3m     | 150 | 0.001 | 0.000 | 4.044 | 0.039 |
| z_het         | yield_5y     | 150 | 0.001 | 0.001 | 4.743 | 0.033 |
| z_het         | yield_6m     | 150 | 0.001 | 0.001 | 7.607 | 0.093 |
| z_het_gk      | juros_cdi    | 150 | 0.060 | 0.042 | 2.045 | 0.027 |
| z_het_gk      | juros_selic  | 150 | 0.057 | 0.043 | 1.780 | 0.024 |
| z_het_gk      | yield_1y     | 150 | 0.002 | 0.001 | 4.224 | 0.027 |
| z_het_gk      | yield_2y     | 150 | 0.002 | 0.001 | 3.254 | 0.019 |
| z_het_gk      | yield_3m     | 150 | 0.001 | 0.001 | 2.732 | 0.018 |
| z_het_gk      | yield_5y     | 150 | 0.001 | 0.001 | 1.490 | 0.010 |
| z_het_gk      | yield_6m     | 150 | 0.002 | 0.001 | 4.207 | 0.031 |
| z_het_jk      | juros_cdi    | 150 | 0.027 | 0.035 | 0.622 | 0.008 |
| z_het_jk      | juros_selic  | 150 | 0.028 | 0.035 | 0.644 | 0.009 |
| z_het_jk      | yield_1y     | 150 | 0.004 | 0.001 | 20.107 | 0.209 |
| z_het_jk      | yield_2y     | 150 | 0.004 | 0.001 | 19.508 | 0.162 |
| z_het_jk      | yield_3m     | 150 | 0.002 | 0.001 | 6.252 | 0.072 |
| z_het_jk      | yield_5y     | 150 | 0.003 | 0.001 | 11.923 | 0.076 |
| z_het_jk      | yield_6m     | 150 | 0.003 | 0.001 | 21.293 | 0.190 |
| z_het_jk_gk   | juros_cdi    | 150 | 0.071 | 0.073 | 0.949 | 0.013 |
| z_het_jk_gk   | juros_selic  | 150 | 0.072 | 0.073 | 0.987 | 0.013 |
| z_het_jk_gk   | yield_1y     | 150 | 0.005 | 0.002 | 8.944 | 0.080 |
| z_het_jk_gk   | yield_2y     | 150 | 0.005 | 0.002 | 7.023 | 0.058 |
| z_het_jk_gk   | yield_3m     | 150 | 0.003 | 0.001 | 5.317 | 0.057 |
| z_het_jk_gk   | yield_5y     | 150 | 0.004 | 0.002 | 4.238 | 0.034 |
| z_het_jk_gk   | yield_6m     | 150 | 0.005 | 0.002 | 9.153 | 0.098 |

## Top-5 specifications

| variant | candidate | F | R² |
|---|---|---|---|
| z_het_jk | yield_6m | 21.293 | 0.190 |
| z_het_jk | yield_1y | 20.107 | 0.209 |
| z_het_jk | yield_2y | 19.508 | 0.162 |
| z_het_jk | yield_5y | 11.923 | 0.076 |
| z_het_jk_gk | yield_6m | 9.153 | 0.098 |

## Diagnosis

The bottleneck of the original `z_het` is in **Front 1.1 (aggregation)** and
**Front 1.2 (maturity mismatch)**, not Front 1.3 (daily signal is strong).
The grid identifies the best combination above. The fix is twofold:
1. Align aggregation: GK-weighted sum if the monthly target is a flow
   (Selic, CDI); simple sum if EoP (yields).
2. Pick the maturity that maximizes first-stage F — typically the closest
   to the daily anchor (DI_3m on the daily side ↔ yield_3m monthly).

JK filter is a complementary purification, expected to raise F when the daily
shocks contain information shocks; orthogonal to the aggregation fix.
