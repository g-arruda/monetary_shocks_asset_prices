# GRG (2025) — Structured Extract for Item MÉDIO 7 Benchmark

**Citation:** Goncalves, C.; Rodrigues, M.; Genta, F. (2025). "Monetary Policy and Inflation Expectations: High-Frequency Evidence from Brazil." IMF Working Paper.

## 1. Research question
Does monetary policy successfully anchor inflation expectations in Brazil despite high public debt and elevated risk premia (the "fiscal dominance" / unpleasant arithmetic concern)? Tests via high-frequency identification.

## 2. Audience
Emerging-market monetary economics; FTPL / fiscal dominance debate; HFI-of-MP-shocks literature (Gertler-Karadi, Bauer-Swanson, Nakamura-Steinsson) extended to non-US contexts.

## 3. Method
**Identification through heteroskedasticity** (Rigobon 2003; Rigobon-Sack 2004 *JME*). Two regimes:
- C = weeks containing a Copom meeting (treatment-week SVAR block);
- NC = weeks without Copom meeting (control-week SVAR block).
Variance ratio Var(Δi | C) / Var(Δi | NC) > 1 (Tab 1) is the relevance condition; equal variance for the dependent variables (Δπᵉ, ΔE, ΔCDS) is the exclusion-restriction analog.
**Estimator:** IV via heteroskedasticity (Rigobon 2003 §III); equivalent to GMM with regime indicator as instrument.

## 4. Data
- **Sample period:** September 2009 to December 2024 (Tab 3 notes); Tab 1 truncates at August 2024.
- **Frequency:** daily; observations are Wed-to-Thu changes.
- **N (Tab 4 IV):** 768.
- **Δi (interest rate surprises):** changes in DI (interbank deposit rate, BM&FBOVESPA Swap DI×Pré). Maturities: 1m, 3m, 6m, 12m.
- **Δπᵉ (inflation expectations):** **break-even inflation** from inflation-linked vs non-inflation-linked Brazilian government bonds (NTNB vs LTN; ANBIMA). Maturities: 1y, 2y, 3y, 5y. Daily.
- **ΔE (FX):** percentage change in BRL/USD nominal exchange rate (BCB SGS daily). Negative β = Real appreciation per 100bp tightening.
- **ΔCDS:** 5-year Brazil CDS sovereign (Bloomberg). Robustness with 1y CDS available on request.
- **Robustness measure (Tab 6):** Focus survey 12m-ahead inflation expectations (BCB) — weekly frequency.

## 5. Statistical / numerical methods
- **Identification:** Rigobon (2003) heteroskedasticity-based IV. Newey-West SE for OLS comparisons (Tab 3).
- **Variance test (Tab 1):** bootstrapped 99% CI on Var_C / Var_NC ratio.
- **Normalization:** coefficients are response **per 100bp surprise**. Δπᵉ in percentage points. ΔE in percent.

## 6. Findings (Tabs 4 + 5 — KEY BENCHMARKS)

### Table 4: IV — effect on inflation expectations
Coefficients per 100bp Δi surprise; *** = p < 0.01, ** = p < 0.05, * = p < 0.10. SE in parentheses.

| Δi maturity | Δπᵉ 1y          | Δπᵉ 2y          | Δπᵉ 3y          | Δπᵉ 5y          |
|-------------|-----------------|-----------------|-----------------|-----------------|
| 1m          | -0.27*** (0.07) | -0.64*** (0.07) | -0.69*** (0.08) | -0.67*** (0.07) |
| 3m          | -0.26*** (0.07) | -0.60*** (0.06) | -0.69*** (0.07) | -0.69*** (0.07) |
| 6m          | -0.21*** (0.05) | -0.45*** (0.05) | -0.53*** (0.06) | -0.67*** (0.08) |
| 12m         | -0.20*** (0.06) | -0.43*** (0.07) | -0.50*** (0.07) | -0.53*** (0.06) |

Reading: a 100bp tightening lowers 1y expected inflation by 0.20-0.27 pp, and 5y by 0.53-0.69 pp.

### Table 5: IV — FX and CDS
| Δi maturity | ΔE (BRL/USD) | ΔCDS_5y |
|-------------|--------------|---------|
| 1m          | -5.64*** (0.91) | +0.01 (0.06) |
| 3m          | -5.10*** (0.75) | -0.03 (0.05) |
| 6m          | -3.93*** (0.63) | -0.05 (0.04) |
| 12m         | -3.42*** (0.69) | -0.11* (0.05) |

Reading: 100bp tightening → Real appreciates ~3-6% against USD. CDS does not respond significantly (only 12m maturity is borderline).

### Sub-sample stability (Tab 8)
3m surprise → Δπᵉ 1y: -0.13 to -0.25 across 10y rolling windows starting 2009-2014; Δπᵉ 5y: -0.56 to -0.91; ΔE: -2.85 to -8.79. Effectiveness **increases over time**.

### FOMC-overlap robustness (Tab 9)
Dropping 32 days when Copom coincides with FOMC — coefficients similar magnitudes; main message robust.

## 7. Contributions
1. First HFI-via-heteroskedasticity identification of MP shocks for an emerging economy with elevated debt (Brazil).
2. Direct test of unpleasant-arithmetic / FTPL: monetary policy still anchors expectations and appreciates currency, even with high debt.
3. CDS does not respond to MP — pure-fiscal-dominance channel via default risk is rejected.

## 8. Replication feasibility
Public data sources cited (Bloomberg [proprietary], BCB SGS [public], BM&FBOVESPA [public], ANBIMA [public]). No public replication archive linked. Code not on GitHub. Methodology fully described — reproducible from data.

---

## Implications for our Item MÉDIO 7 benchmark

- **Direct comparison points (Tab 5):** `cambio_usd`, `cds_5y` exist in our `data_log_deseasonalized.csv`. **Clean side-by-side.**
- **No direct comparison for Tab 4:** our panel does **not** have inflation expectations (only realized `price_ipca` and core variants). Two options:
  1. Skip Δπᵉ comparison (clean but loses GRG's main result);
  2. Add a "narrative" comparison: GRG finds large negative response in expectations; our model produces an IRF for realized IPCA (different object, likely smaller and slower). Document caveat.
  Decision: **option 2** with explicit caveat in the report.
- **Sample overlap:** 2013-01 to 2024-12 (we go to 2025-12; GRG to 2024-12). Substantial overlap.
- **Policy variable mapping:** our `z_het_jk_3var` uses DI **3m** as the impact column. Closest GRG row: **Δi(3m)**. Use that line for benchmark.
- **Normalization scaling:** GRG reports per 100bp; our DFM normalizes to +50bp. Convert GRG coefficients × 0.5 in the benchmark CSV (or scale ours × 2). Document choice.

## Per-50bp benchmark line (z_het_jk_3var | Δi 3m row of GRG, divided by 2)

| Variable    | GRG point (per 50bp) | GRG SE (per 50bp) | Our DFM source |
|-------------|---------------------:|------------------:|----------------|
| Δπᵉ 1y      | -0.13                | 0.035             | `price_ipca` (caveat: realized vs expected) |
| Δπᵉ 2y      | -0.30                | 0.030             | `price_ipca` (caveat) |
| Δπᵉ 5y      | -0.345               | 0.035             | `price_ipca` (caveat) |
| ΔE (BRL/USD)| -2.55 (%)            | 0.375             | `cambio_usd` |
| ΔCDS_5y     | -0.015 (ns)          | 0.025             | `cds_5y` |
