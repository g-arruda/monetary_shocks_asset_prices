# Mertens & Ravn (2013) — The Dynamic Effects of Personal and Corporate Income Tax Changes in the United States

Structured extraction from marker-produced markdown (3 chunks, complete: title page through references).
Prepared for a literature review of a proxy-SVAR paper using an external high-frequency instrument.
**This is the canonical origin reference for the proxy-SVAR / external-instrument estimator** (see §7 for the priority question vs. Stock & Watson).

---

## Bibliographic metadata

| Field | Value | Source |
|---|---|---|
| Authors | Karel Mertens; Morten O. Ravn | Stated in text |
| Title | "The Dynamic Effects of Personal and Corporate Income Tax Changes in the United States" | Stated in text |
| Journal | *American Economic Review* | Stated in the self-citing dataset reference in the bibliography |
| DOI | `10.1257/aer.103.4.1212` | Stated verbatim in the title footnote † and again in the dataset self-citation |
| Volume / issue / first page | 103 / 4 / 1212 — **inferred from the DOI string** `aer.103.4.1212`, not stated as a separate "vol. 103(4), pp. …" line anywhere in the chunk text | Inferred |
| Year | 2013 | Stated in the bibliography self-citation ("Mertens, Karel, and Morten O. Ravn. 2013. … Dataset. *American Economic Review*"). Corroborated by Cloyne (2013), *AER* 103(4): 1507 appearing in the reference list — same volume/issue. |
| **Last page (1247)** | **NOT stated in the chunk text.** The task prompt supplies it; I flag it as external. | External to text |
| Affiliations | Mertens: Dept. of Economics, 404 Uris Hall, Cornell University, Ithaca NY 14853 (km426@cornell.edu). Ravn: Dept. of Economics, Drayton House, University College London, 30 Gordon Street, London WC1E 6BT, UK (m.ravn@ucl.ac.uk). | Stated |
| JEL codes | E23, E62, H24, H25, H31, H32 | Stated |
| Acknowledgments | Three referees, Andre Kurmann, **James Stock**, seminar participants; Jonas Fisher and Todd Walker for data; Andres Dallal (RA). Funding: Cornell Institute for the Social Sciences (Mertens); ESRC / Centre for Macroeconomics (Ravn). | Stated |

---

## 1. Research question

Two questions, one substantive and one methodological, and the paper's citation weight in the proxy-SVAR literature comes from the second.

**Substantive.** What are the dynamic aggregate effects of *exogenous, unanticipated* changes in US federal taxes, and — critically — does it matter *which* tax is changed? The paper rejects the field's convention of studying a single aggregate "total tax rate" or total tax revenue, and instead separates the **average personal income tax rate (APITR)** from the **average corporate income tax rate (ACITR)**. Motivation stated directly: "there is little reason to expect that the many types of taxes available to governments all have the same impact on the economy and therefore can be summarized in a single tax measure." The two categories together are more than 90 percent of total federal tax revenues.

**Methodological.** How can narrative accounts of policy interventions be used for identification in an SVAR *without* assuming they map one-to-one into the structural shocks? The stated defect of the existing narrative literature (Romer & Romer 2010) is that "the narratively identified exogenous changes in policy instruments are implicitly viewed as mapping one-to-one into the true structural shocks," whereas "historical records rarely are sufficiently unequivocal that calls of judgment can be avoided." The stated defect of the SVAR literature (Blanchard & Perotti 2002; Mountford & Uhlig 2009) is that "identification requires parameter restrictions that may be questioned." The paper's answer is to use the narrative series as a *proxy* (instrument), not as an observation of the shock.

The subordinate question, which becomes a second contribution: *how good are the narrative series?* — answered with an estimable **reliability matrix**.

---

## 2. Audience

Macro-fiscal empirical economists and applied SVAR econometricians; the framing is explicitly policy-facing. The concluding claims are addressed to "the ongoing debate on fiscal policy": tax multipliers vs. spending multipliers (citing Ramey 2011b), job creation, and revenue raising. The Romer & Bernstein (2009) quote about the ARRA is used as a direct foil in the labor-market section. Secondary audience: anyone with a narrative or auxiliary shock measure in *any* domain — the conclusion explicitly advertises the method for "government spending and monetary policy where narrative policy measures are available," and notes that "the methodology can also be used without availability of narrative measures as long as other proxies are available."

---

## 3. Method — identification strategy (proxy-SVAR / narrative instrument)

**Paradigm: proxy-SVAR (external instrument SVAR), with a narrative — not high-frequency — instrument.** This is the paper that states the estimator in general k-shock form and applies it. The paper's own name for it is "an estimator which uses narratively identified tax changes as proxies for structural tax shocks."

### 3.1 The SVAR setup (verbatim-accurate)

Let `Y_t` be `n × 1`. Structural form, eq. (1):

```
A Y_t = Σ_{j=1}^{p} α_j Y_{t-j} + ε_t
```

with `A` an `n × n` nonsingular coefficient matrix, `α_j` (`j = 1,…,p`) `n × n`, and `ε_t` an `n × 1` vector of structural shocks with `E[ε_t] = 0`, `E[ε_t ε_t'] = I`, `E[ε_t ε_s'] = 0` for `s ≠ t`. Deterministic terms and exogenous regressors are omitted for brevity.

Reduced form, eq. (2):

```
Y_t = Σ_{j=1}^{p} δ_j Y_{t-j} + B ε_t,    B = A^{-1},  δ_j = A^{-1} α_j
```

With `X_t = [Y'_{t-1}, …, Y'_{t-p}]'` the lag vector and `u_t` the reduced-form residuals, eq. (3):

```
u_t = B ε_t
```

Counting: `E[u_t u_t'] = B B'` supplies `n(n+1)/2` independent restrictions, which is **not** enough to identify even one column of `B`.

### 3.2 The proxy conditions (the exact statement of relevance and exogeneity)

Let `m_t` be a `k × 1` vector of proxy variables, correlated with `k` structural shocks of interest and orthogonal to the others. Partition `ε_t = [ε'_{1t}, ε'_{2t}]'`, where `ε_{1t}` is `k × 1` (shocks of interest) and `ε_{2t}` is `(n−k) × 1` (all other `n − k` shocks). WLOG `E[m_t] = 0`. The two conditions, eqs. (4) and (5):

```
(4)   E[m_t ε'_{1t}] = Φ        Φ an unknown NONSINGULAR k × k matrix   ← RELEVANCE
(5)   E[m_t ε'_{2t}] = 0                                                ← EXOGENEITY
```

Verbatim gloss from the paper: "The first condition states that the proxy variables are correlated with the shocks of interest. The second condition requires that the proxy variables are uncorrelated with all other shocks. These are the key identifying assumptions which translate to additional linear restrictions on the elements of **B**."

Two features worth quoting in a lit review because they are the paper's selling point:
- **No assumption on `Φ` beyond nonsingularity.** "we do not require that the proxies correlate perfectly with the true latent shocks `ε_{1t}` or that each proxy is correlated with only a single structural shock." (The second clause is what makes the `k = 2` tax application coherent.)
- Footnote 1: `m_t` and `ε_{1t}` are assumed to be the same dimension `k`; "The analysis can be extended to the case where multiple proxy variables are available, i.e., `dim(m_t) > k`" — i.e., the overidentified case is flagged but **not developed here**.

**Lead–lag orthogonality is *not* required but is used.** "It is also not necessary that `E[m_t X_t'] = 0`, i.e., that the proxy variables are orthogonal to the history of `Y_t`. However, this condition is testable and when a candidate narrative measure `m̃_t` is correlated with `X_t`, then `m_t` can be the error from projecting `m̃_t` on `X_t`. Since in this case `m_t` is more informative for `ε_{1t}` than `m̃_t`, we henceforth also assume that the proxy variables are orthogonal to `X_t`."

### 3.3 The algebra recovering the columns of the impact matrix `B`

Partition `B` (dimensions as printed):

```
B = [ β_1  β_2 ],     β_1 : n × k,   β_2 : n × (n−k)
β_1 = [ β_11' β_21' ]',   β_11 : k × k,   β_21 : (n−k) × k
β_2 = [ β_12' β_22' ]',   β_12 : k × (n−k), β_22 : (n−k) × (n−k)
```

with `β_11` and `β_22` nonsingular. Conditions (3)–(5) imply eq. (6):

```
(6)   Φ β_1' = Σ_{mu'}          where  Σ_{x1 x2} ≡ E[x_{1t} x_{2t}]
```

**Restriction counting — the key step.** System (6) is `n × k` but also contains the `k²` unknown elements of `Φ`. "Because we do not wish to make any assumptions on `Φ` other than nonsingularity, equation (6) provides really only **(n − k)k** new identification restrictions."

Partitioning `Σ_{mu'} = [ Σ_{mu_1'}  Σ_{mu_2'} ]` with `Σ_{mu_1'}` of size `k × k` and `Σ_{mu_2'}` of size `k × (n−k)`, the usable restrictions collapse to eq. (7):

```
(7)   β_21 = ( Σ_{mu_1'}^{-1} Σ_{mu_2'} )' β_11
```

`Σ_{mu_1'}^{-1} Σ_{mu_2'}` is directly estimable, so (7) "constitutes a set of covariance restrictions of the type discussed in Hausman and Taylor (1983)."

**The three-stage estimator, verbatim:**
- **First Stage:** Estimate the reduced form VAR by least squares.
- **Second Stage:** Estimate `Σ_{mu_1'}^{-1} Σ_{mu_2'}` from regressions of the VAR residuals on `m_t`.
- **Final Stage:** Impose the restrictions in (7) and estimate the objects of interest, if necessary in combination with further identifying assumptions.

**The IV interpretation (this is the sentence the whole subsequent literature leans on):** "the estimate of `Σ_{mu_1'}^{-1} Σ_{mu_2'}` corresponds to the two-stage least squares (2SLS) estimator in a regression from `u_{2t}` on `u_{1t}` using `m_t` as instruments for `u_{1t}`. Conditions (4)–(5) can therefore also be viewed as the instrument validity conditions for this regression."

**Whether (7) suffices depends on `k`:**
- `k = 1` (single shock): **no further assumptions required**; `ε_{1t}` is identified up to a sign convention. In Appendix A: with `k = 1` "the first column of **B** is determined (up to a signing convention) since `S_1 S_1'` is a scalar."
- `k > 1`: (7) "need[s] to be complemented with additional restrictions that may vary with the particular application."
- Traditional short- or long-run restrictions can additionally be layered on (7) to identify the remaining `ε_{2t}` for which no proxies exist.
- Hausman & Taylor (1983) supply the necessary and sufficient conditions for identification under general linear restrictions of the form (7).

### 3.4 The TWO-proxy / TWO-shock case (`k = 2`) — the extra restrictions needed

This is the part the prompt asks to record precisely, and it is where the paper is most instructive for anyone contemplating a multi-shock proxy-SVAR.

**Why one proxy per shock is not enough.** If the two proxies could each be treated as uncorrelated with the *other* tax shock, each could be used in isolation to derive `n − 1` restrictions, `2(n − 1)` total, and (with the residual covariance restrictions) each set of `n − 1` would suffice for its own IRF. But **if the zero cross-correlations cannot be imposed**, "the identifying assumptions on the combined proxy series yield only `2(n − 2)` restrictions, which is insufficient to disentangle the causal effects of shocks to both types of taxes."

**Why they cannot be imposed here — the empirical fact.** "Conditional on a tax change taking place, the correlation between the PI and CI narrative tax changes in our sample is **0.42**." Rationale offered: legislation adjusting both taxes at once typically moves them the same direction (shared long-run growth or debt-reduction objectives), and "the fixed costs of passing legislation naturally imply a temporal correlation of the changes in different types of taxes."

**The parametrization used to close the system.** With `u_{1t}`, `ε_{1t}` the `2 × 1` tax-rate reduced-form and structural innovations and `u_{2t}`, `ε_{2t}` the `(n−2) × 1` remainder, eqs. (15)–(16):

```
(15)  u_{1t} = η  u_{2t} + S_1 ε_{1t}
(16)  u_{2t} = ζ  u_{1t} + S_2 ε_{2t}
```

`S_1` is `2 × 2` nonsingular and **not necessarily diagonal**, "capturing the potential contemporaneous interdependence of the tax instruments." The object of interest, eq. (17):

```
(17)  β_1 = [  I + η (I − ζη)^{-1} ζ  ]  S_1
            [      (I − ζη)^{-1} ζ    ]
```

**What the covariance restrictions do and do not deliver.** The linear restrictions in (7) identify `β_1 S_1^{-1}` and `S_1 S_1'` (the covariance of `S_1 ε_{1t}`), **but not `S_1` itself**. The intuition given: `ζ` is estimable by 2SLS using `m_t` as instruments; given `ζ`, use `u_{2t} − ζ u_{1t}` as instruments to estimate `η`; then the covariance of `u_{1t} − η u_{2t}` gives `S_1 S_1'`. Recovering `S_1` "requires arbitrary assumptions on how personal income taxes respond contemporaneously to unanticipated changes in corporate taxes (beyond the indirect contemporaneous endogenous effects through `u_{2t}`), and vice versa."

**The extra restriction actually imposed: a Cholesky factorization of `S_1 S_1'`.** "We report responses that result from a Choleski decomposition of `S_1 S_1'`, imposing that `S_1` is lower triangular." Appendix A confirms: "With multiple proxies `k > 1`, the identification of the structural impulse responses is completed by a Choleski decomposition of `S_1 S_1'`." Note carefully that the recursive assumption is imposed only *within the 2 × 2 block of tax shocks*, not on the full system.

**Interpretation of the ordering.** With APITR ordered before ACITR, "the response to a negative 1 percentage point ACITR shock is the response to an exogenous tax change that lowers the ACITR by 1 percentage point but leaves the APITR unchanged in 'cyclically adjusted' terms, i.e., after allowing for contemporaneous feedback from `u_{2t}`." A shock to the APITR moves the ACITR both through `u_{2t}` feedback and directly via the identified correlation. If `S_1 S_1'` is diagonal, the orderings coincide exactly.

**Empirically the ordering barely matters:** the correlation between the cyclically adjusted tax rate innovations `S_1 ε_{1t}` is **−0.07, 95% CI [−0.41, 0.50]** — "a robust finding in sufficiently large VAR systems, in particular when they include government debt."

**Closed forms (Appendix A), in terms of the observable moments `Σ_{uu'}`, `Σ_{mu'}`, `Σ_{mm'}`.** Identifying restrictions are `Σ_{uu'} = B B'` plus (7):

```
(A1)  β_11 S_1^{-1} = ( I − β_12 β_22^{-1} β_21 β_11^{-1} )^{-1}
(A2)  β_21 S_1^{-1} = β_21 β_11^{-1} ( I − β_12 β_22^{-1} β_21 β_11^{-1} )^{-1}
(A3)  S_1 S_1'      = ( I − β_12 β_22^{-1} β_21 β_11^{-1} ) β_11 β_11' ( I − β_12 β_22^{-1} β_21 β_11^{-1} )'
```

with the auxiliary blocks (`Σ_ij` = partitions of `Σ_{uu'}`):

```
β_21 β_11^{-1} = ( Σ_{mu_1'}^{-1} Σ_{mu_2'} )'
β_12 β_22^{-1} = ( β_12 β_12' (β_21 β_11^{-1})' + (Σ_21 − β_21 β_11^{-1} Σ_11)' ) ( β_22 β_22'^{-1} )
β_12 β_12'     = (Σ_21 − β_21 β_11^{-1} Σ_11)' Z^{-1} (Σ_21 − β_21 β_11^{-1} Σ_11)
β_22 β_22'     = Σ_22 + β_21 β_11^{-1} ( β_12 β_12' − Σ_11 ) (β_21 β_11^{-1})'
β_11 β_11'     = Σ_11 − β_12 β_12'
Z              = β_21 β_11^{-1} Σ_11 (β_21 β_11^{-1})' − ( Σ_21 (β_21 β_11^{-1})' + β_21 β_11^{-1} Σ_21' ) + Σ_22
```

### 3.5 What the estimator replaces

Explicitly contrasted with: Blanchard & Perotti (2002), which uses institutional features of the US tax system and policy reaction lags to impose coefficient restrictions on `B`; and Mountford & Uhlig (2009), which imposes sign restrictions on the IRFs from (2). "Our procedure avoids direct assumptions on the elements of **B** … The key requirement is the availability of proxies that satisfy (4)–(5)."

---

## 4. Data

### 4.1 The narrative instrument — source and construction (Romer–Romer lineage)

**Yes, Romer–Romer style, and directly derived from the Romer–Romer series.** The instrument is *not* high-frequency market data; it is a hand-built narrative series. Construction chain:

1. **Base source:** Romer & Romer (2009a), "A Narrative Analysis of Postwar Tax Changes" — the account of changes in federal US tax liabilities, describing "almost 50 legislative changes in the tax code over the sample period, many containing multiple changes in tax liabilities implemented at different points in time."
2. **New disaggregation (this paper's own data contribution):** the RR total tax liability changes are decomposed into four subcomponents — **corporate income tax liabilities (CI)**, **individual income tax liabilities (II)**, **employment taxes (EM)**, and **a residual category of other revenue-changing measures (OT)**. OT is discarded "because it is very heterogeneous" (per fn. 6 it is mostly excise taxes targeted at specific industries/goods plus gift and estate taxes). Decomposition uses "the same sources as Romer and Romer (2009a) supplemented with additional information from sources such as congressional records, the *Economic Report of the President*, CBO reports, etc." Detail in the online data Appendix. Per fn. 6: II and EM changes include marginal-rate adjustments, deductions and tax credits; CI changes are a few marginal-rate adjustments and "otherwise mainly changes in depreciation allowances and investment tax credits."
3. **Exogeneity filter (to satisfy condition (5)):** retain only tax liability changes "unrelated to the current state of the economy," using Romer & Romer's (2009a) own exogenous classification — motivation classified as *ideological* or *arising from inherited deficit concerns*.
4. **Anticipation filter (following Mertens & Ravn 2012a):** drop any change whose **implementation lag exceeds one quarter** (i.e., legislated more than ~90 days before implementation). About half of the RR exogenous changes were legislated at least 90 days ahead, and Mertens & Ravn (2012a) show pre-implementation aggregate effects, so anticipated changes are a distinct shock and are removed.
5. **Resulting counts:** **13** observations of individual income tax liability changes, **2** employment tax liability changes, **16** corporate income tax liability changes, "deriving from **21** separate legislative changes to the federal tax code." "The vast majority of these changes were legislated as permanent changes to the tax code." EM is merged into II to form a personal income (PI) category because there are too few EM observations; "All our results are very similar if we omit the employment taxes."
6. **Conversion from liabilities to average tax rate changes:**

```
ΔT_t^{PI,narr} = ( II tax liability change_t + EM tax liability change_t ) / Personal Taxable Income_{t−1}
ΔT_t^{CI,narr} = ( CI tax liability change_t ) / Corporate Profits_{t−1}
```

where personal taxable income = personal income − government transfers + contributions for government social insurance. Scaling by *previous-quarter* taxable income; "our results are nearly identical if we instead scale by the contemporaneous or previous year taxable income."
7. **Final proxies:** `m_t` = the two narrative series **after subtracting the mean of the nonzero observations** (demeaned on the uncensored subsample). No projection on `X_t` was needed in the benchmark because Granger causality was not rejected (see §5.4).

Two largest PI events: the **Revenue Act of 1964** and the **Jobs and Growth Tax Relief Reconciliation Act of 2003** — "Each of these two pieces of legislation cut average personal income tax rates by more than 1 percentage point according to the narrative measure." Largest CI event: the **repeal of the investment tax credit in the Tax Reform Act of 1986**.

### 4.2 The VAR panel

- **Unit of observation:** the US federal government / US aggregate economy, quarterly.
- **Frequency:** quarterly (benchmark); an **annual** VAR with 2 lags is also estimated for the marginal- vs. average-rate comparison.
- **Sample:** **1950:I–2006:IV** (228 quarterly observations, arithmetic; the paper does not print the T).
- **Effective instrument sample:** censored — only 13 + 2 PI-relevant and 16 CI quarters are nonzero out of the full sample. The paper repeatedly refers to "the subsample of observations for which at least one of the two proxies takes on a nonzero value."
- **Benchmark VAR, n = 7:** `Y_t = [ APITR_t, ACITR_t, ln(B_t^{PI}), ln(B_t^{CI}), ln(G_t), ln(GDP_t), ln(DEBT_t) ]` — the two average tax rates, the two tax bases (real per capita), federal government purchases of final goods, GDP, and federal government debt, all real per capita, all fiscal variables federal.
- **Lag length:** `p = 4`, chosen by the **Akaike information criterion**. Estimated **in log levels** (robustness in first differences and with a linear-quadratic trend).
- **Horizon:** 20 quarters.

**Tax rate definitions (NIPA-based):**
```
APITR_t = ( Personal Current Taxes_t + Contributions for Govt. Social Insurance_t ) / Personal Taxable Income_t
ACITR_t = Taxes on Corporate Profits_t / Corporate Profits_t          (federal level)
```

**Sample facts:** personal income tax revenues (incl. social insurance contributions) average **74.2%** of total federal tax revenues; corporate income taxes **16.4%**. Total federal tax revenues stay near **18% of GDP**, but the APITR rises from ~10% at the start of the sample to ~18% by end-2006, and the ACITR falls from **over 50%** in the early 1950s to **just above 20%** by the end.

### 4.3 Alternative VAR systems

- **+ monetary variables:** effective federal funds rate, log nonborrowed reserves, log PCE price index — added while *dropping the two tax bases* to economize on parameters (the online Appendix reports the version that adds all three to the original seven; "very similar point estimates but with somewhat larger confidence bands").
- **Baseline five for the wider-effects section:** two average tax rates, output, public debt, government spending, plus a rotating block.
- **+ labor market:** log total employment per capita, log hours per worker, log labor force / population (business + government incl. military + nonprofit); the unemployment rate is derived.
- **+ consumption:** nondurables and services consumption, durable goods purchases, personal taxable income.
- **+ investment:** nonresidential investment, residential investment, corporate profits.
- **Annual system:** benchmark variables minus corporate rate and base; tax rate is alternately the APITR and the Barro–Redlick AMTR (state taxes removed for comparability); identification uses the time-aggregated `ΔT_t^{PI,narr}`.

### 4.4 Data sources (Appendix B, verbatim-level detail)

Population: total population over 16 from Francis & Ramey (2009) (`nipop16`). Output: Real GDP, NIPA Table 1.1.3 line 1, per capita. Government spending: Real Federal Government Consumption Expenditures and Gross Investment, NIPA Table 1.1.3 line 22, per capita. PI tax base: NIPA personal income (Table 2.1 line 1) − government transfers (Table 2.1 line 17) + contributions for government social insurance (Table 3.2 line 11). CI tax base: NIPA corporate profits (Table 1.12 line 13) − Federal Reserve Bank profits (Tables 6.16 B-C-D). Bases deflated by the GDP deflator (Table 1.1.9 line 1) and by population. APITR numerator: federal personal current taxes (Table 3.2 line 3) + social insurance contributions. ACITR numerator: federal taxes on corporate income excl. Federal Reserve banks (Table 3.2 line 9). Debt: Federal Debt Held by the Public from Favero & Giavazzi (2012) (`DEBTHP`), deflated and per capita. PCE price index: Table 1.1.9 line 2. Federal funds rate: from Romer & Romer (2010), extended back to 1950:I by them. Nonborrowed reserves: FRED `BOGNONBR`, extended to 1950:I as total reserve balances (`RESBALNS`) − borrowed reserves (`BORROW`), adjusted for reserve-requirement changes via the St. Louis Fed reserve adjustment magnitude. Employment and hours: Francis & Ramey (2009). Labor force: employment + FRED `UNEMPLOY`. Consumption of nondurables and services: chain-aggregated from NIPA Tables 1.1.5 and 1.1.9. Durables, nonresidential and residential investment: NIPA Table 1.1.3 lines 4, 9, 12.

---

## 5. Statistical / econometric methods

### 5.1 Estimator

Three-stage as in §3.3: OLS reduced-form VAR → regression of VAR residuals on `m_t` to get `Σ_{mu_1'}^{-1} Σ_{mu_2'}` (numerically the 2SLS coefficient of `u_{2t}` on `u_{1t}` instrumented by `m_t`) → impose (7) plus, for `k = 2`, the Cholesky factorization of `S_1 S_1'`. Closed forms (A1)–(A3).

### 5.2 The measurement-error model and the reliability correction

This is the paper's second methodological contribution and is what the prompt's "reliability/attenuation correction" refers to.

**Robustness claim first.** "As long as conditions (4)–(5) hold, the precise nature of the measurement error does not affect the identification of the impulse responses." The measurement-error structure below is *additional* and is imposed only to (a) make the bias in naïve narrative regressions explicit, and (b) recover a reliability statistic.

**Sources of measurement error listed:** contradictory historical records and unavoidable calls of judgment; neglect of minor policy interventions; "many observations that are censored to zero"; and, specific to taxes, difficulty in measuring "the full implications of new tax legislation on effective tax rates."

**Measurement equation (8):**
```
(8)   m_t = D_t ( Γ ε_{1t} + υ_t )
```
- `Γ` is `k × k` nonsingular (**arbitrary scale** — important because "available estimates of changes in tax liabilities typically assume that the tax base remains invariant after legislative changes to the tax code").
- `υ_t` is `k × 1` measurement error with `E[υ_t] = 0`, `E[υ_t ε'_{1t}] = 0`, `E[υ_t υ'_t] = Σ_{υυ'}`, `E[υ_t υ'_s] = 0` for `s ≠ t` — i.e. **additive, serially uncorrelated, but contemporaneously correlated across proxies**.
- `D_t` is a `k × k` diagonal matrix of random (0,1) indicators tracking zero observations — the **censoring** process. Assumed: diagonal elements perfectly correlated (for `k > 1` "the proxy variables are identically censored"), and `E[D_t υ_t ε'_{1t}] = 0`. **`D_t` is NOT required to be independent of `ε_{1t}`** — so "larger realizations (in absolute value) of `ε_{1t}` are more likely to be measured" is permitted.

So (8) accommodates: (i) censoring, possibly selective on shock size; (ii) additive correlated measurement error; (iii) arbitrary scale.

**The latent-variable / attenuation algebra (Bollen 1989 framing).** Rewrite (9) `Y_t = θ' X*_t + w_t` with `X*_t = [Y'_{t−1},…,Y'_{t−p}, ε'_{1t}]'`, `θ = [δ', β_1]'`, `w_t = β_2 ε_{2t}`; then the observable system (10)–(11) `Y_t = γ' X̄_t + z_t`, `X̄_t = Ω X*_t + Υ_t` with `X̄_t = [Y'_{t−1},…,Y'_{t−p}, m'_t]'` and

```
θ = Ω' γ ,   w_t = z_t + γ' Υ_t ,   Ω = [ I 0 ; 0 Γ ] ,
Υ_t = [ 0 ; D_t υ_t + (D_t − I_k) Γ ε_{1t} ]
```

"Note that because of censoring, `E[X*_t Υ'_t] ≠ 0` and `Υ_t` is therefore **not classical measurement error**." From `Σ_{X̄ w'} = 0`:

```
(12)  θ = Ω' Λ_X̄^{-1} Σ_{X̄X̄'}^{-1} Σ_{X̄Y}
(13)  Λ_X̄ = [ I  0 ; 0  Σ_{mm'}^{-1} Φ Γ' ]      ← the reliability matrix of the uncensored X̄_t
```

**The indictment of the naïve narrative estimator, verbatim:** "Most existing narrative studies estimate a version of (10) (often also including lags of `m_t`) but unless there is no measurement error, the resulting naïve estimator `Σ_{X̄X̄'}^{-1} Σ_{X̄Y}` is generally biased because of **scaling** (`Ω' ≠ I`) and **measurement error** (`Λ_X̄^{-1} ≠ I`)."

The proxy estimator instead recovers
```
δ = Σ_{XX'}^{-1} Σ_{XY'},     β_1' = Φ^{-1} Σ_{mY'}
```
and since `Σ_{mY'} = Σ_{mu'}`, "the three-stage procedure described in the previous section is equivalent to estimating a measurement error model in which `Y_t` has perfect reliability and `m_t` is measured with error."

**The reliability statistic.** Under the *additional* assumption of **independent random censoring**, the `k × k` reliability matrix of `m_t` is

```
(14)  Λ = Σ_{mm'}^{-1} E[D_t] Γ Γ'
```

Interpretation, verbatim: "When `k = 1`, `Λ` is the fraction of the variance in the uncensored measurements that is explained by the variance of the latent variable or equivalently **the squared correlation between the narrative measure and the true structural shock of interest**. Since `0 ≤ Λ ≤ 1`, measurement error bias manifests itself in this case as shrinkage toward zero. **When `k > 1`, the bias can go in either direction.** The eigenvalues of `Λ` can be interpreted as the scalar reliabilities of the principal components of the uncensored observations in `m_t`."

Estimable forms (Appendix A), with `d` the fraction of uncensored observations of `m_t`:
```
(A4)  Λ = (1/d) Σ_{mm'}^{-1} Σ_{mu_1'} ( β_11 β_11'^{-1} Σ_{mu_1'}' )
(A5)  Λ = ( Γ² Σ_t D_t ε²_{1t} + Σ_t D_t (m_t − Γ ε_{1t})² )^{-1} Γ² Σ_t D_t ε²_{1t},
      with Γ = ( Σ_t D_t m_t u_{1t} / Σ_t D_t ) / β_11
```
"The advantage of (A5) over (A4) is that it always lies in the unit interval. We therefore prefer this estimator when `k = 1`."

Caveat, fn. 4: "If `k > 1`, the proxy variables are not identically censored and if the off-diagonal elements of `Γ` are nonzero, (13) needs to be further decomposed into a reliability matrix and yet another bias term that is due to censoring."

Framing sentence worth citing: "SVAR shocks are sometimes criticized for being at odds with historical events or descriptive records, see for instance Rudebusch (1998). The reliability of proxies constructed from the historical record of policy changes quantifies the extent to which this criticism applies."

### 5.3 Inference — bootstrap

**Recursive wild bootstrap, 10,000 replications, Gonçalves & Kilian (2004). 95% percentile confidence intervals** (labor-market and expenditure figures show both 90 and 95 percent bands). Procedure, verbatim:

> "We generate bootstrap draws `Y_t^b` recursively using `δ̂_j`, `j = 1,…,p` and `û_t e_t^b`, where the `δ̂_j`s and `û_t` denote the estimates for the VAR in (2) and `e_t^b` is the realization of a random variable taking on values of −1 or 1 with probability 0.5. **We also generate a draw for the proxy variables `m_t^b = m_t e_t^b`**, reestimate the VAR for `Y_t^b` and apply the covariance restrictions implied by `m_t^b`. The percentile intervals are for the resulting distribution of impulse response coefficients."

Three points the paper stresses about it:
- Rademacher multipliers, **the same `e_t^b` applied to both `û_t` and `m_t`** — so identification and measurement uncertainty propagate into the bands.
- "This procedure requires **symmetric distributions** for `u_t` and `m_t` but is **robust to conditional heteroscedasticity**."
- **Why not an i.i.d. residual bootstrap:** "The standard residual bootstrap is problematic given that `m_t` contains many zero observations, which means that drawing with replacement from `m_t` yields zero vectors with positive probability." (This is a direct, citable justification for wild-bootstrap-over-pairs-bootstrap in any censored-instrument proxy-SVAR.)
- Contrast drawn with the literature: "This contrasts with the typical application of coefficient restrictions in SVARs as well as narrative specifications, which often treat `m_t` as deterministic."

The reliability confidence intervals in Table 1 are also "computed using 10,000 bootstrap replications."

### 5.4 Weak instruments / first stage — what the paper does and does NOT report

**Important for a lit review that discusses weak-IV in proxy-SVARs: this paper reports no first-stage F statistic, no concentration parameter, and no weak-instrument-robust inference anywhere in the text.** The vocabulary "weak instrument," "Stock-Yogo," "Montiel Olea," "Anderson-Rubin" does not appear. The instrument-strength diagnostics it *does* report, both in Table 1, are:

1. **Reliability eigenvalues** with bootstrap 95% intervals — the paper's own strength metric. "Low values of these reliability statistics indicate that the proxies may not contain much information useful for identification."
2. **`R²` of the reduced-form tax-rate residuals `u_{1t}` regressed on `m_t`**, computed on the censored subsample. Per fn. 10: "We regressed each of the elements of `u_{1t}` on both proxies `m_t` in the subsample of observations for which at least one of the two proxies takes on a nonzero value." Benchmark values 0.22 (APITR) and 0.38 (ACITR), described as indicating "the narrative shocks explain a sizable fraction [of] the prediction error variance of the average tax rates."

This is the historically important gap: the MOSW / Olea-Stock-Watson weak-proxy machinery that later papers use post-dates this paper, which handles proxy weakness through the *reliability* channel instead.

### 5.5 Tests of the exogeneity / predetermination conditions

- **Granger causality of the narrative measures.** "We checked whether lagged macro variables Granger cause the narrative shocks but we found no such evidence." Fn. 7 gives the p-values: the null that the average tax rate, GDP, government spending, and the tax base do not Granger-cause the narrative measure has **p = 0.70 (PI)** and **p = 0.76 (CI)**; for the benchmark system's variables, **p = 0.87 and 0.57**. Tests run in first differences "as the test is problematic when the data is nonstationary." Also tested municipal bond spreads and government debt; **smallest p-value found anywhere was 0.23**, for debt-to-GDP not Granger-causing the CI narrative measure.
- **Predictability regressions** on the uncensored observations against lagged key variables: no statistical significance.
- **Note the logical point they make about predictability:** "As long as the proxies correlate contemporaneously with unanticipated tax shocks and are otherwise orthogonal to other contemporaneous shocks, predictability of the proxies does not violate the identifying assumptions." They nonetheless ran the benchmark with proxies replaced by residuals from regressing nonzero narrative observations on lags of implicit expected tax rates and debt-to-GDP: "The point estimates … remain similar to the benchmark specification and none of them lead to marked improvements in the reliability estimates."

### 5.6 Robustness battery (§II.E)

- **Trend specification:** benchmark in log levels; verified in first differences and with a deterministic linear-quadratic trend. "The key features of the short and medium run effects of tax shocks, our primary focus, are insensitive to these alternatives," but long-horizon responses and the permanent-vs-transitory reading of tax changes do depend on the trend assumption.
- **Tax foresight / anticipation:** conditioning on **municipal bond spread**-implied expected future taxes (Leeper, Walker & Yang 2011; 1-year and 5-year maturities) — no sensitivity. Conditioning on future-spending news: **Fisher & Peters (2010)** accumulated excess returns of large US military contractors and **Ramey's (2011a)** defense-spending news variable — "These extensions did not lead to notable changes in the output responses."
- **Timing error:** simulation experiments in the style of Ramey (2011a). "The estimated output responses remain fairly stable when we assume that up to **50 percent** of the measured tax change is randomly mistimed by one quarter, either as a lead or a lag." And the identification-level point: "unless *all* of the narrative tax changes misdate the true tax shocks, none of our identifying assumptions are violated. Our approach is therefore already robust to this type of timing error, which merely results in a loss in precision and lower reliability statistics."
- **Single-proxy alternative** (Figure 5): assuming each proxy correlates with only one tax shock, valid "only if the correlation is due to chance or correlated measurement errors." Result: "When the correlation is ignored we find substantially larger effects of corporate income tax cuts than in the benchmark specification, while the opposite pattern is evident for the personal income tax cut." The distortion is much greater when both average tax rates are in `Y_t`; in small systems with only the relevant rate and base, single-proxy IRFs are close to benchmark.

---

## 6. Findings — with numbers

### 6.1 Headline output effects (benchmark, 1 percentage point *cut*)

| | Impact | Peak | Timing of peak |
|---|---|---|---|
| **APITR cut, real GDP per capita** | **+1.4%** | **+1.8%** | 3 quarters |
| **ACITR cut, real GDP per capita** | **+0.4%** | **+0.6%** | ~1 year (4 quarters) |

APITR: "The confidence intervals indicate a significant increase (at the 95 percent level) in economic activity within a two year window after the tax cut." The APITR itself stays significantly below its pre-shock expected path during the first year, then converges.

### 6.2 Tax bases and revenues

- **APITR cut:** PI tax base rises ~**0.6%** initially, peaking at **1.3%** one year out. Combining rate and base, **personal income tax revenues drop 5.4% on impact**, stay low for several years but "recover substantially from the initial drop during the first year." Verdict: "cuts in personal income taxes unambiguously lower personal tax revenues."
- **ACITR cut:** CI tax base rises **up to 3.8% in the first six months** — "The increase in the tax base is sufficiently large such that there is only a very small decline in corporate income tax revenues in the first quarter and a surplus thereafter. The response of corporate tax revenues is however **insignificant at every horizon**. Hence, cuts in corporate income taxes appear to be **approximately self-financing**."
- Revenue IRF construction, fn. 9: `tr̂_t = T̂_t^i / T̄^i + b̂_t^i`, where `T̄^i` is the sample-mean average tax rate for `i = PI, CI`, hats denote IRFs, and lowercase denotes logs.

### 6.3 Multipliers

Multiplier defined as "the dollar change in GDP per effective dollar loss in revenues," obtained "by rescaling the output response such that the implied drop in tax revenues is normalized to 1 percent of GDP."

- **Personal income tax multiplier: 2.0 on impact, maximum 2.5 in the third quarter.**
- **Corporate income tax multiplier: not well defined** — "The same calculation for the corporate income tax instead makes little sense given that the estimated impact on revenues is approximately zero."

### 6.4 Reliability estimates (Table 1) — the instrument-quality result

Benchmark reliability matrix eigenvalues: **0.30 [0.16, 0.48]** and **0.69 [0.47, 0.97]**, implying correlations between the principal components of the narrative tax changes and the true tax shocks of **0.55** and **0.83**. "The former number is also the smallest correlation of any linear combination of the proxy variables." Reading, verbatim: "These statistics indicate that the proxies contain valuable information for the identification of the structural tax shocks … At the same time, the fact that the reliability matrix has eigenvalues substantially below unity indicates that **measurement error is a serious concern in practice**."

Full Table 1:

| Specification | Reliabilities (eigenvalues) | | R²(u₁ₜ on mₜ), APITR | R², ACITR |
|---|---|---|---|---|
| Benchmark (Figs. 2, 3) | 0.30 [0.16, 0.48] | 0.69 [0.47, 0.97] | 0.22 | 0.38 |
| With monetary variables (Fig. 4) | 0.54 [0.30, 0.69] | 0.66 [0.52, 1.00] | 0.23 | 0.39 |
| Using single tax proxy (Fig. 5) | 0.38 [0.21, 0.56] | 0.64 [0.55, 0.69] | 0.24 | 0.16 |
| Annual with average tax rate (Fig. 8) | 0.54 [0.25, 0.70] | — | 0.37 | — |
| Annual with marginal tax rate (Fig. 8) | 0.60 [0.40, 0.70] | — | 0.34 | — |
| With labor market variables (Fig. 9) | 0.46 [0.25, 0.57] | 0.51 [0.42, 0.81] | 0.21 | 0.17 |
| With consumption variables (Fig. 10) | 0.27 [0.13, 0.44] | 0.50 [0.33, 0.77] | 0.17 | 0.29 |
| With investment variables (Fig. 10) | 0.30 [0.15, 0.49] | 0.69 [0.46, 0.95] | 0.17 | 0.32 |

Brackets are 95% bands from 10,000 bootstrap replications.

### 6.5 Fiscal and monetary controls

- **Government spending:** no significant response to either tax shock at any horizon (95%), consistent with Romer & Romer (2009b). Framed as reassurance "that the responses to tax shocks are confounded with changes in government spending" is refuted.
- **Cross-tax responses:** "cuts in one average tax rate lead to increases in the other average tax rate, although neither of these increases is significant."
- **Government debt:** rises significantly (95%) in the short run after an APITR cut — significant in the first two quarters in the specification with monetary variables — and does not change significantly after an ACITR cut.
- **Inflation:** APITR cut is "mildly disinflationary on impact and briefly inflationary in the third quarter," none significant. ACITR cut produces a **stronger, persistent, 95%-significant decline in inflation in the first two quarters**, robust to the GDP deflator and BLS CPI. Read as "a fall in marginal costs and dominating supply side effects."
- **Interest rates:** "no strong evidence that changes in either of the two tax rates impact significantly on the short term nominal interest rate," federal funds or 3-month T-bill. Fn. 13: "The absence of a strong impact on the interest rate does of course not preclude adjustments in the money supply."

### 6.6 Labor market (Figure 9)

**APITR cut of 1pp:** employment per capita **+0.3% on impact, statistically significant**, peaking at **~0.8% five quarters** out. Hours per worker **+0.4% on impact**, significantly positive through the first year. Labor force participation: **no significant effect at any horizon**. Implied unemployment rate **−0.3 pp on impact**, maximum decline "slightly more than 0.5 percentage points in the fifth quarter." Fn. 18: interpreting the shock as a marginal labor-tax cut with no wealth effects or impact change in the pre-tax real wage, the labor response implies **a wage elasticity of aggregate labor supply of around 0.5**.

**ACITR cut of 1pp:** "no evidence that a cut in corporate taxes is associated with any significant impact on employment, despite the considerable and significant immediate increase in output." Maximum employment increase **0.3%**, never significant. No significant effect on hours per worker at any horizon. Participation unaffected. Unemployment falls gradually but never significantly.

**Sectoral split (online Appendix):** the total employment rise after an APITR cut = a more strongly positive *private* sector response plus a *temporary drop in public sector employment*. After an ACITR cut, private-sector employment tracks total; public-sector employment drops marginally for two quarters.

### 6.7 Private expenditure components (Figure 10)

**APITR cut:** nondurables and services consumption **+0.1% on impact**, rising gradually to a peak "just above 0.4 percent" around two years out; described as consistent with permanent-income predictions ("more muted and smoother relative to the response of personal income"). Durable goods purchases **+3.6% on impact**, remaining higher at **5% for two years**. Nonresidential investment **+2.1% in the quarter of the cut**, maximum **4% after one year**. Residential investment positive but not significant.

> **Internal inconsistency to flag if quoting:** the chunk text says of the nondurables response first that "the response is imprecisely estimated and not statistically significant," and two sentences later that "The positive response of nondurable purchases is significant at the 95 percent level for more than a year after the cut in the APITR." One of these almost certainly refers to *durable* purchases (context suggests the second sentence should read "durable"). Do not quote either sentence without checking the published PDF.

**ACITR cut:** nondurables and services consumption **declines**, "marginally statistically significant at the 90 percent level on impact, but not thereafter." Durables decline slightly, insignificantly. Read as "substitution effects dominating income effects" since a corporate tax cut raises the return on saving. Nonresidential investment **+0.5% on impact, peak +2.3% after six quarters**, significant for multiple quarters. Residential investment responds positively and **significantly** (unlike the APITR case). The personal savings rate rises after both types of cut.

Summary: "Changes in either type of taxes boost investment, but only personal income tax cuts have short run positive effects on consumption expenditures … We emphasize though that the estimates for consumption are relatively imprecise." Relative to output, the investment response is *stronger* for the ACITR than the APITR.

### 6.8 The method matters — comparison with naïve narrative specifications (Figure 6)

Two comparison specifications, both estimated on the same narrative series:
```
(18)  Δln(GDP_t) = Σ_{j=1}^{K} μ_j ΔT_{t−j+1}^{i,narr} + e_t          [Romer & Romer 2010 style, K = 12]
(19)  Y_t = Σ_{j=1}^{p} ν_j Y_{t−j} + ξ ΔT_t^{i,narr} + e_t           [narrative as exogenous VAR regressor, Favero & Giavazzi 2012 style]
```
Result: "The models in (18)–(19) imply **substantially smaller output effects** than our benchmark model. This is particularly evident for the corporate income tax cut where the output responses derived from (18) and (19) are **close to zero at all forecast horizons**." For PI, (19) is smaller at all horizons and significantly so in the first three quarters.

**Two stated reasons for the gap:**
1. **Scaling.** "we scale the tax shocks by their impact on effective average tax rates while the Romer and Romer (2010) multiplier estimates are based on projected tax liability calculations which typically assume that output (and other determinants of tax revenue) does not respond to changes in taxes."
2. **Attenuation from measurement error.** Fn. 14 is precise about the direction: "In the context of our measurement equation assumptions, specification (19) **necessarily suffers from attenuation bias**. One should not jump to the conclusion that all narrative results in the literature are downward biased because of measurement error. When lagged or multiple narrative measures are included, measurement error can lead to attenuation **or expansion** bias. Some studies, such as Ramey (2011a), rescale impulse responses according to the impact on one of the observables, which can substantially mitigate the problem."

Corroborating evidence cited: Perotti (2012) re-measures the RR series and likewise finds larger multipliers.

### 6.9 Comparison to the existing literature (all numbers as reported by Mertens & Ravn)

| Study | Object | Reported magnitude |
|---|---|---|
| **This paper** | APITR (federal, average, personal) | GDP +1.4% impact, +1.8% peak; multiplier 2.0 → 2.5 |
| **This paper** | ACITR | GDP +0.4% impact, +0.6% peak; multiplier undefined (revenue-neutral) |
| Barro & Redlick (2011) | AMTR, annual, IV using year-aggregated RR (2009a) total liabilities | 1pp AMTR cut → next-year GDP +0.5%, multiplier ≈ 1.1 |
| Blanchard & Perotti (2002) | Total tax revenues, quarterly, 1947–1997 | Impact multiplier 0.69, peak 0.78 |
| Mountford & Uhlig (2009) | Aggregate tax revenues, sign restrictions, deficit-financed cut | 0.29 impact, 0.93 at one year, up to 3.41 at 12 quarters |
| Romer & Romer (2010) | Aggregate legislated tax liabilities | <0.5% on impact, rising steadily to ~3% at 10 quarters |

On Blanchard-Perotti specifically, fn. 16: "Blanchard and Perotti (2002) calibrate the output elasticity of tax revenues to **2.08** while in Mertens and Ravn (2012b) we estimate a larger elasticity of **3.13** based on the narrative data. **The discrepancy explains the entire difference between tax multiplier estimates.**"

### 6.10 Average vs. marginal rates (annual VAR, Figures 7–8)

APITR and the Barro–Redlick AMTR (state taxes removed) are correlated **0.90 in levels and 0.62 in first differences**. Annual reliability of the PI proxy as a measure of *marginal* rate shocks: **0.60**; the proxy "explains 34 percent of the marginal tax rate prediction error variance in the subsample of nonzero observations." Result: "The output response to a marginal rate cut is highly significant and very similar in size to our benchmark estimates. The output response to the average rate cut is somewhat larger in the annual data." Differences: the marginal-rate decline is more persistent, and the confidence intervals are much narrower with the marginal rate. Fn. 15: without removing state taxes, the marginal-rate first-year output response is **0.7%, rising to 1.7% in the third year** — closer to Barro & Redlick. Proposed explanation for the residual gap: Barro-Redlick include preannounced tax changes, which biases downward because "forward looking agents and intertemporal substitution motives generate a tendency for preannounced cuts in income taxes to lower output prior to implementation" (Yang 2005; Mertens & Ravn 2011, 2012a,b; Leeper, Walker & Yang 2011).

---

## 7. Contributions — what is new

1. **The proxy-SVAR / external-instrument estimator, stated in general form.** Conditions (4)–(5), the counting result that (6) yields only `(n−k)k` usable restrictions, restriction (7), the three-stage procedure, the Hausman–Taylor covariance-restriction framing, and the 2SLS equivalence. This is what the later literature cites as the origin.

2. **The priority footnote — cite this carefully.** Footnote 2, verbatim: "**After submitting this paper, we became aware of Stock and Watson (2008) who suggest the equivalent implementation of the identification strategy through IV regressions for the case where `k = 1`.** More recently, Stock and Watson (2012) apply the same approach in a dynamic factor model to disentangle the causes of the 2007–2009 recession. Our methodology is also related to Nevo and Rosen (2012) who use weaker covariance restrictions to achieve partial identification, and Evans and Marshall (2009) who identify shocks in VARs with the aid of auxiliary shock measures derived from economic models." **So: independent and contemporaneous with Stock & Watson (2008), whose statement was for `k = 1` only; the general `k > 1` treatment and the two-proxy identification are Mertens–Ravn's.** The Stock & Watson (2008) reference is an NBER Summer Institute minicourse lecture, not a published article. Stock & Watson (2012) is NBER WP 18094 (the proxy-DFM paper) — directly relevant to a DFM-based proxy application.

3. **Robustness of IRF identification to measurement error in the narrative series** — a formal statement that under (4)–(5) "the precise nature of the measurement error does not affect the identification of the impulse responses," which extends the narrative approach "to cases in which the narrative shock series is measured with error."

4. **The reliability statistic** (eqs. 13, 14, A4, A5) — an estimable, bootstrappable measure of the squared correlation between narrative measure and latent shock, permitting a quantitative verdict on narrative-series quality. Explicitly offered as "of independent interest."

5. **A new narrative dataset:** the decomposition of Romer & Romer (2009a) federal tax liability changes into personal (individual + employment) and corporate income tax components, filtered for exogeneity and for implementation lag ≤ 1 quarter, converted into average-tax-rate changes.

6. **The two-proxy identification result**: with correlated proxies, the covariance restrictions deliver `β_1 S_1^{-1}` and `S_1 S_1'` but not `S_1`; a within-block Cholesky completes identification; and the practical demonstration (Figure 5) that ignoring the cross-correlation materially distorts both IRFs.

7. **Substantive:** disaggregating taxes matters — personal and corporate income tax changes have different signs and magnitudes for employment, hours, consumption and revenue; short-run tax multipliers are large and likely exceed federal spending multipliers; corporate tax changes are approximately revenue-neutral.

8. **Advertised extensions (conclusion):** apply to other countries where narratives are becoming available (Cloyne 2013 for the UK, IMF 2010 for a broad selection); confront with structural models; time-varying effects à la Auerbach & Gorodnichenko (2012); and — the sentence most relevant to a monetary-policy proxy-SVAR — "our methodology lends itself to applications to **government spending and monetary policy** where narrative policy measures are available. The methodology can also be used without availability of narrative measures as long as other proxies are available."

---

## 8. Replication feasibility

**Assessment: high, for the data; unclear from the chunk text, for the code.**

- **Formal replication archive: yes.** The bibliography contains the AER dataset self-citation: "Mertens, Karel, and Morten O. Ravn. 2013. 'The Dynamic Effects of Personal and Corporate Income Tax Changes in the United States: **Dataset**.' *American Economic Review*. http://dx.doi.org/10.1257/aer.103.4.1212." This is the standard AEA data-deposit citation, so the archive exists at the article DOI.
- **Online Appendix: yes**, and it carries substantive load — "To view additional materials and author disclosure statement(s), visit the article page at http://dx.doi.org/10.1257/aer.103.4.1212." The online *data* Appendix "describes the construction of the data and the historical sources in detail" for the narrative decomposition, and the online Appendix also holds the robustness figures, the sectoral employment split, and the alternative 10-variable monetary specification.
- **Source data: essentially all public.** NIPA tables from BEA (specific table and line numbers given in Appendix B), FRED series named explicitly (`BOGNONBR`, `BORROW`, `RESBALNS`, `UNEMPLOY`), and the BEA/FRED access URLs with accession date January 23, 2012 appear as formal references.
- **Non-public / third-party inputs, all from published or shared sources:** Francis & Ramey (2009) population, employment and hours; Favero & Giavazzi (2012) `DEBTHP` debt series; Romer & Romer (2010) extended federal funds rate; Barro & Redlick (2011) AMTR; Leeper, Walker & Yang (2011) municipal-bond-implied expected tax rates; Fisher & Peters (2010) military-contractor excess returns; Ramey (2011a) defense news. The acknowledgments thank "Jonas Fisher and Todd Walker for sharing their data," implying at least those two inputs were obtained by private correspondence at the time.
- **The narrative series itself** is the paper's own construction and its precise composition (13 II + 2 EM + 16 CI observations from 21 legislative acts) is documented in the online Appendix; the underlying Romer & Romer (2009a) narrative was unpublished at the time ("Unpublished" in the reference list) but is publicly circulated.
- **Code: not mentioned anywhere in the chunk text.** No software, no replication-code statement, no repository. The AEA data-availability policy of the period generally required programs alongside data, so code is very likely in the AER archive, but **that is an inference from outside the text, not something the paper states.**
- **Computational burden:** trivial by modern standards — a 7-variable, 4-lag quarterly VAR with 10,000 wild-bootstrap replications.
- **Practical replication frictions:** (i) NIPA vintages have been revised repeatedly since the January 2012 accession date, so exact numerical reproduction requires the archived vintage rather than current BEA downloads; (ii) the Cholesky ordering within `S_1 S_1'` must be replicated as *lower triangular on the 2×2 tax block only*; (iii) the wild bootstrap must apply the **same** Rademacher draw `e_t^b` to `û_t` and to `m_t`, a detail easy to get wrong.

---

## Notes for the citing paper (proxy-SVAR with a high-frequency instrument)

- Cite this as the origin of the **general-`k` proxy-SVAR**, but represent footnote 2 accurately: Stock & Watson (2008) independently proposed the equivalent IV implementation **for `k = 1`**, and Mertens & Ravn became aware of it only after submission. The usual joint attribution "Stock and Watson (2008, 2012); Mertens and Ravn (2013)" is the honest one.
- The relevance/exogeneity conditions to quote are eqs. (4)–(5), with the gloss that **no restriction on `Φ` beyond nonsingularity** is imposed — this is exactly what allows a high-frequency surprise, which is a noisy and rescaled measure of the shock, to serve as a proxy.
- **`E[m_t X_t'] = 0` is not required, only convenient**, and the paper's own remedy — projecting the candidate proxy on the VAR lag history and using the residual — is the direct ancestor of the Bauer–Swanson-style predetermined-predictor cleanups.
- The **wild bootstrap with `m_t^b = m_t e_t^b`** originates here as the inference procedure for proxy-SVARs, along with the explicit argument for why an i.i.d. residual bootstrap fails when the instrument is heavily censored. Any project resampling a sparse instrument can cite this paragraph verbatim.
- **There is no first-stage F, no weak-instrument test, and no weak-IV-robust inference in this paper.** Instrument strength is assessed through the reliability eigenvalues and the residual `R²` only. This is precisely the gap that Montiel Olea, Stock & Watson later fill, and is the honest way to position a modern weak-proxy diagnostic as an advance on the original estimator rather than a departure from it.
- The **`k = 2` machinery** (eqs. 15–17, `β_1 S_1^{-1}` and `S_1 S_1'` identified but `S_1` not, completed by a Cholesky on the shock block) is the reference for any application identifying more than one shock with more than one correlated proxy.
- The **attenuation result** (fn. 14 and §6.8) is the cleanest available citation for why regressing outcomes directly on a noisy narrative or high-frequency surprise understates the response relative to the proxy-SVAR.
