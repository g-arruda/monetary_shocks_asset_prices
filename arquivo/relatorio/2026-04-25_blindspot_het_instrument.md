# Blindspot Report — Heteroskedasticity Instrument Audit
**Source:** /done from session 2026-04-25, monetary_shocks_asset_prices
**Output audited:** output/instrument_audit_report.md + grid (4 variants × 7 targets) + daily identification (eigenvalues, rank-1 share)
**Usage:** Three CONDITIONAL items must be addressed before submitting the paper. Use as a checklist.

---

## Headline ruling: CONDITIONAL

`z_het_jk + yield_6m → F=21.3, R²=0.19` is sound, but three validations are missing and three secondary findings are being undersold.

---

## Vice 1: Unexplained Features

15 features listed. Three resolved, one flagged.

- ✓ DONE — GK weighting REDUCES F on yield targets: yields are EoP (stock), not flow; GK weighting (D-d+1)/D incorrectly attenuates late-month shocks for stock targets.
- ✓ DONE — JK filter triples F on yields but reduces F on Selic/CDI: filter cuts 55% of days; gain only when monetary signal dominates noise. For maturity-mismatched targets (Selic overnight vs DI 3m daily), variance loss without signal gain.
- ✓ DONE — R²(yield_1y)=0.209 > R²(yield_6m)=0.190 but F(yield_1y)=20.1 < F(yield_6m)=21.3: F is HC0-robust (t² with robust SE); yield_1y has more residual heteroscedasticity → larger SE → smaller HC0 F.
- ⚠ FLAG — yield_6m beats yield_3m even though daily anchor is DI_3m. Plausible but unproved that 6m is "implementation-lag horizon" vs short-end carry/risk-premium noise. Sub-sample bootstrap would confirm.

## Vice 2: Convenient Absences

Eight missing items, four critical:

- ⚠ **Placebo test** — shuffle z_het_jk randomly; expected F≈1 under H0. Without this, F=21 might be data-snooping artifact (4×7=28 specs grid-searched).
- ⚠ **Random-mask vs JK** — generate random masks retaining 42/97 days; compare F. Separates "JK is informative" from "any sparsification helps". Most damaging absence.
- ⚠ **Sub-period stability** — split 2013-19 / 2020-25; drop COVID 2020-03 to 2020-09. F=21 may be driven by Dilma 2015-16 or COVID outliers.
- Sensitivity to daily SVAR variable set (drop DI_2y, add NTN-B/longer DI).
- Cross-validation: cor(z_het_jk, z_jk_purif) at monthly level.
- Exclude FOMC-coincident weeks (32 dates) — legacy variants do this; het variants do not.
- Formal rank-1 test (Brown-Forsythe / bootstrap of eigenvalue gap), not just descriptive 0.84.
- Confirm n=150 vs 156 = 6 lost to AR(6) lags. Already confirmed in conversation.

## Virtue 1: Unasked Questions

Five secondary findings being underexploited:

- λ_2 = 41 (DI_2y direction, 16% of |sum|) is NOT noise. Likely a "forward guidance" shock affecting curve longs. Identifying v_2 → second instrument z_het² could be a paper of its own.
- Wrong-signed in GK = 31.6%; info-share in het+JK = 57%. Heteroskedasticity ID detects MORE info contamination than timing-based JK. Why? Hypothesis: het identification picks up correlated communication noise that timing window misses.
- R²=0.19 in HF→monthly first stage matches Gertler-Karadi 2015 (US, ~0.15-0.20). Brazil emerging-market parity is itself a finding.
- 57% info-share has POLICY implications: BCB Copom communication is as substantive as the rate decision. Crosses paper boundaries.
- yield_6m as "sweet spot" of curve — possible BCB implementation-cycle window. Investigate via Svensson β decomposition.

## Virtue 2: Unexploited Strengths

Five undersold aspects:

- rank1_share = 0.84 is EMPIRICAL EVIDENCE of Rigobon's rank-1 hypothesis. Most papers ASSUME it. Plot eigenvalue spectrum, compare with Rigobon-Sack 2003 FOMC (~0.85).
- Daily 4×4 system is effectively 2×2 (DI_3m + DI_2y) with IBOV/BRL as homoscedastic controls. Replicates GRG 2025 Tab 1 cleanly. Independent validation in longer sample.
- JK filter on heteroscedasticity-identified shocks is METHODOLOGICALLY NEW. Literature applies JK to raw or Bauer-Swanson-purified surprises, not to Mertens-Ravn GLS-projected shocks. Minor methodological contribution.
- script/instrument_audit.R is reusable diagnostic for any HF-monetary project. Could be released as appendix or standalone tool.
- Paper positioning: instead of "Brazilian DFM with Rigobon-Sack", reposition as "**Institutional heterogeneity (Copom-after-close + periodic fiscal dominance) requires variance-shift identification, and reveals 57% of communications are information shocks.**" Comparative angle vs Bauer-Swanson 2023, Nakamura-Steinsson 2018.

---

## Action items before submission

**MUST-DO:**
1. Placebo: shuffle z_het_jk → re-run grid → confirm F ≈ 1.
2. Random-mask: 42/97 random days → compare F vs JK-filtered F.
3. Sub-period: rerun for 2013-19, 2020-25, drop COVID.

**SHOULD-DO:**
4. Compute cor(z_het_jk, z_jk_purif) monthly.
5. Identify v_2 explicitly and report its loadings.
6. Add formal rank-1 test (eigenvalue-gap bootstrap).
7. Reposition paper around institutional heterogeneity + info-share finding.
