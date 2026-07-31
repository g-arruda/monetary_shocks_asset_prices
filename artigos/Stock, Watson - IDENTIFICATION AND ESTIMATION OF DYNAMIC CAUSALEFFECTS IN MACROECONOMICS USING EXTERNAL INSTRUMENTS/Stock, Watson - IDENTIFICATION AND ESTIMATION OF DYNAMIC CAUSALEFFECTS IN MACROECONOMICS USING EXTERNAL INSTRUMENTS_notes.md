# Stock & Watson (2018) — Identification and Estimation of Dynamic Causal Effects in Macroeconomics Using External Instruments

Structured extraction from the marker-produced markdown (3 chunks, read in full).

---

## Bibliographic metadata

| Field | Value | Source |
|---|---|---|
| Authors | James H. Stock and Mark W. Watson | stated in text |
| Title | "Identification and Estimation of Dynamic Causal Effects in Macroeconomics Using External Instruments" | stated in text |
| Journal | *The Economic Journal* | stated in text |
| Volume | 128 | stated in text (running head: "The Economic Journal, 128 (May), 917–948") |
| Issue | **not stated in the chunk text.** The running head gives only "(May)". The issue number 610 comes from the task prompt / outside the text — flagged as external. | external |
| Pages | 917–948 | stated in text |
| Year | 2018 (copyright line "© 2018 Royal Economic Society") | stated in text |
| DOI | 10.1111/ecoj.12593 | stated in text |
| Publisher | Royal Economic Society, published by John Wiley & Sons | stated in text |
| Occasion | "presented by Stock as the Sargan Lecture to the Royal Economic Society on 11 April 2017" | stated in text |
| Affiliations | Harvard University and NBER (Stock); Woodrow Wilson School, Princeton University and NBER (Watson) | stated in text |
| Corresponding author | James H. Stock, Dept. of Economics, Harvard University, Cambridge MA 02138, james_stock@harvard.edu | stated in text |
| Supporting information | "Additional Supporting Information may be found in the online version of this article: Data S1." | stated in text |

Note: this is a lecture-derived methodological article, not a standard empirical paper. Its acknowledgements list includes Gertler, Mertens, Ramey, Ravn, Ricco, Plagborg-Møller, Montiel Olea, Jordà and Wolf.

---

## 1. Research question

How can *external* instruments — sources of as-if random variation that are external to the macroeconomic system — be used to identify and estimate **dynamic causal effects** (structural impulse response functions) in macroeconomics, and what exactly does each of the two available estimators require?

Sub-questions the paper answers:

1. What are the precise instrument-validity conditions for the one-step (single-equation) estimator, LP-IV, and for the two-step (VAR-based) estimator, SVAR-IV?
2. When can dynamic causal effects be identified **without** assuming invertibility (fundamentalness) of the structural moving average?
3. Given that SVAR-IV is efficient-but-requires-invertibility and LP-IV is inefficient-but-does-not, can the *difference* between the two be turned into a test of invertibility?
4. Does adding lagged endogenous controls to LP-IV give you a free pass out of invertibility? (Answer: no — Theorem 1, the "no free lunch" result.)

Framing sentence from the abstract: "External sources of as-if randomness — that is, external instruments — can be used to identify the dynamic causal effects of macroeconomic shocks. One method is a one-step instrumental variables regression (local projections – IV); a more efficient two-step method involves a vector autoregression."

---

## 2. Audience

- Macroeconometricians and applied macroeconomists working with SVARs, local projections, and narrative/high-frequency shock measures.
- Explicitly framed as a **unification and exposition**: "we are not aware of a unified presentation of the econometric theory of and connections between the SVAR-IV and LP-IV methods."
- Delivered as the Sargan Lecture, so the framing is deliberately pedagogical and connects the modern proxy-SVAR literature back to Sargan (1964) / Rothenberg-Leenders (1964) 3SLS and Wright (1928)'s original "external factors" terminology.
- Secondary audience: microeconometricians, via a sustained translation exercise ("the macroeconomist's shock is the microeconomists' random treatment, and impulse response functions are the causal effects of those treatments").

---

## 3. Method — identification strategy and paradigm

The paper covers **both** paradigms and is explicit that they are two estimators of the same estimand under different assumptions.

### Setup — structural moving average (SMA)

Y_t = Θ(L) ε_t   (equation 5), with Θ(L) = Θ₀ + Θ₁L + Θ₂L² + …, Y_t is n×1, ε_t is m×1 (shocks **plus measurement error**), Σ_εε = E ε_t ε_t' positive definite, shocks mutually uncorrelated, Y_t transformed to second-order stationarity. **m can exceed n.** Θ_{h,21} is the dynamic causal effect. Measurement error included in ε_t is assumed uncorrelated with the structural shocks but may be correlated across variables.

### Normalisation — unit effect (this matters for the DFM application)

**Θ_{0,11} = 1 (unit effect normalisation)**, equation (6). "if ε_{1,t} is the monetary policy shock and Y_{1,t} is the federal funds rate, (6) fixes the scale of ε_{1,t} so that a 1 percentage point monetary policy shock increases the federal funds rate by 1 percentage point."

Advantages stated over the unit-standard-deviation normalisation (var(ε_{1,t}) = 1):
- "allows for direct estimation of the dynamic causal effect in the native units relevant to policy analysis";
- "As discussed in Stock and Watson (2016), the unit effect normalisation also allows for direct extension of SVAR methods to **structural dynamic factor models**."

**Critical inference warning (§2.1.1), verbatim:** "We stress that the normalisation of ultimate interest — typically the unit effect normalisation — needs to be incorporated into the computation of standard errors. In general, it is incorrect to use a different normalisation (such as the unit standard deviation normalisation), compute confidence bands, then rescale the bands and point estimates to obtain the unit effect normalisation. In practice, this means the unit effect normalisation must be 'inside' the bootstrap, not 'outside'."

### (a) LP-IV — one-step / local-projections-IV

Estimating equation (7): Y_{i,t+h} = Θ_{h,i1} Y_{1,t} + u^h_{i,t+h}, with u^h_{i,t+h} = {ε_{t+h}, …, ε_{t+1}, ε_{2:n,t}, ε_{t-1}, ε_{t-2}, …}. Y_{1,t} is endogenous, so IV with Z_t.

**CONDITION LP-IV (verbatim):**
- (i) E(ε_{1,t} Z_t') = α' ≠ 0  (**relevance**);
- (ii) E(ε_{2:n,t} Z_t') = 0  (**contemporaneous exogeneity**);
- (iii) E(ε_{t+j} Z_t') = 0 for j ≠ 0  (**lead–lag exogeneity**).

Commentary, verbatim: "Condition LP-IV (iii) arises because of the dynamics. The key idea of this condition is that Y_{2,t+h} generally depends on the entire history of the shocks, so if Z_t is to identify the effect of shock ε_{1,t} alone, it must be uncorrelated with all shocks at all leads and lags. The requirement that Z_t be uncorrelated with future ε's is generally not restrictive: when Z_t contains only variables realised at date t or earlier, it follows from the definition of shocks as unanticipated structural disturbances. **In contrast, the requirement that Z_t be uncorrelated with past ε's is restrictive and strong.**"

Two refinements:
- The condition is *linear* unpredictability given past ε's, not full independence.
- **Serial correlation in Z_t is compatible with LP-IV.** Verbatim example: "suppose Z_t = δ ε_{1,t} + ζ_t where ζ_t is a serially correlated error that is independent of {ε_t}; then Z_t satisfies Condition LP-IV."

Identification (scalar Z): E(Y_{i,t+h} Z_t) / E(Y_{1,t} Z_t) = Θ_{h,i1}   (equation 8). Vector-Z version with any positive definite weight H.

**Testability of lag exogeneity, verbatim:** "The lag exogeneity Condition LP-IV(iii) is testable: Z_t should be unforecastable in a regression of Z_t on lags of Y_t."

Wald/final-form interpretation: with Y_t = Π(L) Z_t + v_t (Theil-Boot final form, eq. 9), when Z_t is serially uncorrelated and scalar, Θ_{h,i1} = Π_{h,i} / Π_{0,1}. "The older literature treated this as the causal effect of interest, but as explained in Gertler and Karadi (2015), the surprise is better thought of as an instrument for the shock."

### (b) LP-IV with controls (LP-IV⊥)

Equation (10): Y_{i,t+h} = Θ_{h,i1} Y_{1,t} + γ_h' W_t + u^{h⊥}_{i,t+h}, with x_t^⊥ = x_t − Proj(x_t | W_t).

**CONDITION LP-IV⊥ (verbatim):**
- (i) E(ε_{1,t}^⊥ Z_t^{⊥'}) = α' ≠ 0;
- (ii) E(ε_{2:n,t}^⊥ Z_t^{⊥'}) = 0;
- (iii) E(ε_{t+j}^⊥ Z_t^{⊥'}) = 0 for j ≠ 0.

Two motivations for controls: (1) restoring validity when raw Z fails LP-IV; (2) efficiency — "the relevant variance is the long-run variance of the instrument-times-error, so the aim of including additional control variables is to reduce this long-run variance." Candidate controls under LP-IV: Y_{t-1}, Y_{t-2}, … and possibly future Z_{t+k}, …, Z_{t+1}.

Two cases when LP-IV(iii) fails:
1. **Z_t correlated with past ε_{1,t} only** — e.g. the GK MA(1) construction, or a multi-period oil disruption indicator. Fix: include **lags of Z** as controls, or modify the instrument.
2. **Z_t correlated with past shocks including others than ε_{1,t}** — "instrument validity given the controls requires that the controls span the space of those shocks… without such information, the controls would need to span the space of all past shocks. This reasoning suggests using generic controls… **Another such set could be factors estimated from a dynamic factor model; using such factors would provide a factor-augmented IV estimate of the structural impulse response function.**" And immediately: "We show in subsection 2.2 that the requirement that Condition LP-IV⊥ (iii) be satisfied by generic controls, when Condition LP-IV (iii) does not hold, is quite strong."

### (c) SVAR-IV — two-step / proxy-SVAR

VAR: A(L) Y_t = v_t (eq. 16), innovation covariance non-singular; v_t are the Wold errors.
Structural link: **v_t = Θ₀ ε_t where Θ₀ is non-singular** (eq. 17). "A necessary condition for (17) to hold is that the number of variables in the VAR equal the number of shocks (n = m)."
Then Y_t = C(L) Θ₀ ε_t with C(L) = A(L)^{-1}, and C(L)Θ₀ = Θ(L).

**CONDITION SVAR-IV (verbatim) — the first two conditions of LP-IV only:**
- (i) E ε_{1t} Z_t' = α' ≠ 0  (**relevance**);
- (ii) E ε_{2:n,t} Z_t' = 0  (**exogeneity w.r.t. other current shocks**).

Moment result (eq. 19–20): E v_t Z_t = Θ₀ (α', 0)' = (Θ_{0,11}α', Θ_{0,2:n,1}α')', so with the unit-effect normalisation E(v_{i,t} Z_t)/E(v_{1,t} Z_t) = Θ_{0,i1}.

**Three-step SVAR-IV procedure (verbatim structure):**
1. Estimate Y_{i,t} = Θ_{0,i1} Y_{1,t} + γ_i(L) Y_{t-1} + {ε_{2:n,t}} (eq. 22) by 2SLS equation-by-equation using instrument Z_t, with p lags of Y as controls, plus Θ_{0,11} = 1 → first column of Θ₀.
2. Estimate a VAR(p) and invert: Ĉ(L) = Â(L)^{-1}.
3. Θ̂^{SVAR-IV}_{h,1} = Ĉ_h Θ̂^{SVAR-IV}_{0,1}   (eq. 23).

Note on efficiency of step 1: "By classic results of Zellner and Theil (1962) and Zellner (1962), this equation-by-equation estimation by two-stage least squares entails no efficiency loss — is in fact equivalent to — system estimation by three stage least squares." Also warns that plugging estimated residuals v̂_t into (21) is consistent under strong instruments but the standard errors need adjusting for the generated regressor.

---

## 4. Data — sources, unit, sample, frequency

The article has one empirical illustration, in §4, replicating and extending Gertler-Karadi (2015) / Ramey (2016).

| Item | Value |
|---|---|
| Country / unit | United States, aggregate monthly macro time series |
| Frequency | Monthly |
| Y vector | Y_t = (R_t, 100·ΔIP, 100·ΔP, EBP) — 1-year US Treasury rate; log industrial production; log CPI; Gilchrist-Zakrajšek (2012) excess bond premium. "R and EBP are measured in percentage points at the annual rate and ΔIP and ΔP are multiplied by 100 so these variables are measured in percentage point growth rates." IP and P are **first-differenced** by SW (GK used levels). |
| Instrument Z_t | FFF_t — changes in **Federal Funds futures rates around FOMC announcement dates** (Gertler-Karadi's high-frequency surprise). "the original literature treated such a measure as the shock and GK use it as an instrument, that is, Z_t = FFF_t." |
| Instrument sample | 1990m1–2012m6 |
| Macro variable sample | 1979m1–2012m6 (available); VAR estimated 1980m7–2012m6 |
| LP-IV estimation sample | 1990m1–2012m6 |
| SVAR-IV: VAR estimated over | 1980m7–2012m6 |
| SVAR-IV: Θ̂_{0,1} (IV regression) estimated over | 1990m1–2012m6 (Table 1 note says the IV regression is computed over 1990m5–2012m6) |
| Extra controls in column (3) | lags of **four factors computed from the FRED-MD data set** (McCracken and Ng, 2016) |
| VAR lag length | 12 lags of Y (column 4); LP controls use 4 lags of (z,y) or (z,y,f); SVAR-IV column (4) uses 12 lags of y and 4 lags of z |
| Horizons reported | h = 0, 6, 12, 24 |

**Unbalanced-panel point (§2.1.2), important for proxy-SVAR practice:** "in Gertler and Karadi (2015), the data on the macro variables Y_t are available for a longer period than are data on the instruments, and they estimate the VAR coefficients A(L) over the longer sample and Θ̂^{SVAR-IV}_{0,1} over the shorter sample when Z_t is available. **Using the longer sample for the VAR improves efficiency at all horizons.**" LP-IV cannot exploit this: "the moments in (8) are only available over the period of overlap"; with controls the longer sample can be used to construct Y_t^⊥ and Y_{t+h}^⊥, "but the moments in (11) must still be estimated over the period of overlap." Additional LP-IV limitation: "the number of observations available for estimation decreases with the horizon h."

---

## 5. Statistical / econometric methods

### Estimators
- **LP-IV**: horizon-by-horizon 2SLS of Y_{i,t+h} on Y_{1,t} (instrument Z_t), optionally with controls W_t. Appendix form: Θ̂^{LP-IV}_{h,1} = (Z' M_W Y_{1,0})^{-1} (Y_h' M_W Z), M_W = I − W(W'W)^{-1}W'.
- **SVAR-IV**: 2SLS for the impact column + VAR inversion (eq. 23).
- Equality at h = 0: "**For h = 0, the SVAR-IV and LP-IV estimators of Θ_{0,i1} are the same when the control variables W_t are Y_{t-1}, Y_{t-2}, …, Y_{t-p}.** For h > 0, however, the SVAR-IV and LP-IV estimators differ. In the SVAR-IV estimator, the impulse response functions are generated from the VAR dynamics. In contrast, the LP-IV estimator does not use the VAR parametric restriction."

### Inference
- SVAR-IV: √T(Γ̂ − Γ) → N(0, Σ_Γ) under strong instruments; Θ̂^{SVAR-IV}_{h,1} is a smooth function of Γ̂ so the δ-method applies; "Alternatively, and often more conveniently, confidence intervals can be computed using a parametric bootstrap. Doing so requires specifying an auxiliary process for Z_t."
- **Parametric bootstrap (Appendix A.2):** 1,000 draws from the stationary joint system [Â(L) 0; 0 ρ̂(L)] (Ỹ_t, Z̃_t)' = (ṽ_t, ẽ_t)', with (ṽ_t, ẽ_t) ~ i.i.d. N(0, [S_v̂v̂ S_v̂ê; S_êv̂ S_êê]); Â(L) from a VAR(12), ρ̂(L) from an **AR(4)** for the instrument.
- **HAC/HAR (§1.5.2):** "the multistep nature of the direct regressions in general requires an adjustment for serial correlation of the instrument × error process: the error terms in (7), (10) and (12) include future and lagged values of ε, and in general terms like Z_t ε_{t+j} and Z_{t+j} ε_t will be correlated. Inference based on standard heteroscedasticity and autocorrelation robust (HAR) covariance matrix estimators are valid at short to medium horizons."
- **When HAR is not needed (a sharp, quotable special case):** "One special case in which HAR inference is not needed is when the Ws are lagged Ys, **the VAR for Y is invertible** and the Zs are serially uncorrelated conditional on the Ws. In this case, Z_t^⊥ u^{h⊥}_{t+h} is serially uncorrelated and standard heteroscedasticity-robust standard errors can be used. If in addition the errors are homoscedastic, homoscedasticity-only standard errors can be used."
- Table 1 LP standard errors: **Newey-West with h+1 lags**. SVAR and SVAR−LP differences: parametric Gaussian bootstrap.

### Weak instruments (§1.5.5) — verbatim
"If the instruments are weak, then in general the distribution of the IV estimator in (7), (10) and (12) is **not centred at Θ_{h,i1}, and inference based on conventional IV standard errors is unreliable.** However, a suite of heteroscedasticity and autocorrelation-robust methods now exists to detect weak instruments and to conduct inference robust to weak instruments in linear IV regression. For example, see Kleibergen (2005) for a HAR version of Moreira's (2003) conditional likelihood ratio statistics, and Montiel Olea and Pflueger (2013) and Andrews (2018) for HAR alternatives to first-stage F statistics for detecting weak identification."

"As previously discussed, HAR inference is not needed in the special case that the Ws are lagged Ys, the VAR for Y is invertible and the Zs are serially uncorrelated conditional on the Ws. If in addition the errors are homoscedastic, then the suite of tools for weak identification in homoscedastic cross-section data can be applied, **including the usual first-stage F statistic for assessing instrument strength.**"

For SVAR-IV specifically (§2.1.1): "When instruments are weak, the asymptotic distribution of Θ̂^{SVAR-IV}_{h,1} is not normal; **Montiel Olea et al. (2017) discuss weak-instrument robust inference for SVARs identified by external instruments.**" (This is the MOSW reference that underlies the ξ_mp / Wald machinery.)

Open problem flagged in the conclusions: "the usual weak-instrument toolkit does not cover all the methods used here, for example, one open question is **how to robustify our test of invertibility to potentially weak instruments.**"

### Assumptions maintained throughout
- Linearity and identification through second moments ("conditional expectations are typically replaced by projections").
- **Homogeneous treatment effects** ("valid instruments all have the same estimand (i.e. the local average treatment effect equals the average treatment effect)").
- Second-order stationarity of Y_t; shocks mutually uncorrelated and serially uncorrelated.
- For the invertibility test: linear SMA, VAR lag length p finite and known, strong instruments.
- Self-flagged limitation: "The assumption of non-linearity, in particular, rules out a frequent justification for using LP methods… there is a tension between the assumption that the control variables and specification are correct in the single-equation specification, and what this must imply for the full system, and this tension is unresolved in the literature."

### Other econometric "odds and ends"
- **Cumulated IRFs (eq. 12):** Σ_{k=0}^h Y_{i,t+k} = Θ^{cum}_{h,i1} Y_{1,t} + γ^{cum'}_h W_t + u^{h,cum⊥}. "If Z_t satisfies LP-IV⊥, it is a valid instrument for IV estimation of (12)."
- **Ratio of cumulative multipliers (eq. 13)**, following Ramey-Zubairy (2017) and Fieldhouse et al. (2017).
- **Historical decomposition (eq. 14):** contribution of ε_{1,t} to Y_{i,t+h} = Θ_{h,i1} ε_{1,t}.
- **FEVD (eq. 15):** FEVD_{h,i1} = [Σ_{k=0}^{h-1} Θ²_{k,i1} σ²_{ε1}] / var(Y_{i,t+h} | ε_t, ε_{t-1}, …).
- **Key caveat:** "In general, even though Conditions LP-IV and LP-IV⊥ serve to identify the impulse response function, **they do not identify either ε_{1,t} or σ²_{ε1} without additional assumptions.** A sufficient condition for identifying ε_{1,t} and the FEVD is that the VAR for Y_t is invertible; a somewhat weaker condition for identifying ε_{1,t} (but not the FEVD) is that Y_t is **partially invertible**. Weaker yet is the '**recoverability**' condition discussed in Chahrour and Jurado (2017) and Plagborg-Møller and Wolf (2017)." Under invertibility, ε_{1,t} = λ' v_t with λ = Θ_{0,1}' Σ_vv^{-1} / (Θ_{0,1}' Σ_vv^{-1} Θ_{0,1}) and σ²_{ε1} = (Θ_{0,1}' Σ_vv^{-1} Θ_{0,1})^{-1}. Even if LP-IV uses reduced controls, "the full VAR must be used to obtain the innovations needed to compute λ and σ²_{ε1}."
- **Smoothness (§1.5.4):** LP-IV imposes no cross-horizon restrictions; VAR methods impose smoothness by construction but require invertibility. Shrinkage alternatives: Barnichon-Brownlees (2016), Plagborg-Møller (2016a), Miranda-Agrippino-Ricco (2017, smoothing LP toward SVAR).
- **News shocks (§1.5.6, §2.1.3):** when Θ_{0,11} = 0 the contemporaneous normalisation fails; use a k-period-ahead unit-effect normalisation Θ_{k,11} = 1, replacing Y_{1,t} by Y_{1,t+k} in the LP regressions, or by X_{1,t} = (Ĉ_k Y_t)_1 in the SVAR (a generated regressor → simulate the standard errors).

---

## 6. The SVAR-IV ↔ LP-IV relation, invertibility and non-fundamentalness

This is the analytical core and is the material most relevant to a proxy-SVAR-in-a-DFM paper.

### Definition of invertibility (verbatim)
"The structural moving average Θ(L) in (5) is said to be **invertible** if ε_t can be linearly determined from current and lagged values of Y_t: ε_t = Proj(ε_t | Y_t, Y_{t-1}, …)   (24)." Equivalent to Θ(L)^{-1} existing (as a square-summable limit of matrix polynomials in positive powers of L). Stated this way because it is closer to the non-linear-compatible definition ε_t = E(ε_t | Y_t, Y_{t-1}, …).

### What SVAR-IV requires that LP-IV does not
- SVAR-IV needs (17) v_t = Θ₀ε_t with Θ₀ non-singular, i.e. **the VAR innovations and the structural shocks span the same space**, which forces n = m. Invertibility (24) implies (17): shown constructively in §2.2.1, and (24) also forces rank(Θ₀) = m, n ≤ m, hence n = m.
- LP-IV requires **no** invertibility assumption, but pays for it with **lead–lag exogeneity LP-IV(iii)** and with efficiency.
- Efficiency trade-off, verbatim from the introduction: "This method [SVAR-IV] is more efficient asymptotically than LP-IV under strong-instrument asymptotics, and **it does not require lead–lag exogeneity. But to be valid, this method requires invertibility.**"

### How strong invertibility is — the forecaster reframing (verbatim)
"Invertibility is a very strong, albeit commonly made, assumption: **under invertibility, a forecaster using a VAR would find no value in augmenting her system with data on the true macroeconomic shocks, were they magically to become available.**"

Formalised as eq. (25): Proj(Y_t | Y_{t-1}, Y_{t-2}, …, ε_{t-1}, ε_{t-2}, …) = Proj(Y_t | Y_{t-1}, Y_{t-2}, …). "If instead those forecasts were improved by adding the shocks to the regression — infeasible, of course, but a thought experiment — then the VAR has omitted some variables, and that omission is an indication of the failure of the invertibility assumption."

### Invertibility as omitted variables → the DFM/FAVAR remark (directly relevant)
"In general, one solution to omitted variable problems is to include the omitted variables in the regression. In the case at hand, that is challenging, because the omitted variables are the unobserved structural shocks. Pursuing this line of reasoning suggests using **a large number of variables in the VAR, a high-dimensional dynamic factor model or a factor-augmented vector autoregression (FAVAR)**. This is a potentially useful avenue to dealing with the invertibility problem; see, for example, Forni et al. (2009) and the survey in Stock and Watson (2016)."

**Immediately followed by the caveat, verbatim:** "It is important to note that **expanding the number of variables will not necessarily result in (24) being satisfied, so that moving to large systems does not assure invertibility.**"

### THEOREM 1 — the "no free lunch" result (verbatim statement)
"Let 𝐙 denote the set of scalar stochastic processes (instruments) such that for all Z ∈ 𝐙, Z satisfies LP-IV Conditions (i), (ii) and (iii for j > 0), but not (iii for j < 0). Let W_t = {Y_{t-1}, Y_{t-2}, …}. Then LP-IV⊥ is satisfied for all Z ∈ 𝐙 **if and only if** (a) Z satisfies Condition SVAR-IV and (b) the invertibility condition (24) holds."

Interpretation, verbatim: "Although LP-IV can estimate the impulse response function without assuming invertibility, to do so requires an instrument that either satisfies LP-IV (iii) or that can be made to do so by adding control variables **that are specific to the application**. Simply including past Y's out of concern that Z_t is correlated with past shocks is in general valid if and only if the VAR with those past Y's is invertible — but if so, it is more efficient to use SVAR-IV."

Intuition given: "if the instrument depends on lagged shocks, the control variables must span the space of those shocks but the requirement that the Ys span the space of the shocks is simply the invertibility condition."

### Partial invertibility and the observed-shock case (§2.3)
- **Partial invertibility** defined: "we will say that the VAR is partially invertible if there is some λ such that ε_{1,t} = λ' v_t." Leading case λ = (1 0 … 0)' with the observed shock ordered first.
- With ε_{1,t} observed and ordered first, the population VAR (eq. 26) has no feedback to the first variable and a lower-triangular error structure, so a Cholesky IRF with the shock first is consistent for Θ₁(L) — "reached **without ever assuming that ζ_t spans the space of the remaining shocks**: the VAR can have omitted variables in the sense that the shocks are not fully observable. The reason for this result is that ε_{1,t} is strictly exogenous."
- Extension to any identified λ via the transform Ỹ_t = (λ'Y_t, λ̃'Y_t).
- **Important limitation, verbatim:** "if the IV methods identify λ such that ε_{1,t} = λ' v_t, then the additional assumption of invertibility of the SVAR can be dispensed with for the validity of SVAR-IV. This said… **identification of Θ_{0,1} is insufficient to identify λ**, and the expression for λ given there… was derived under the invertibility assumption (17). While the partial invertibility assumption… is weaker than invertibility assumption (17), **it remains to be seen whether there are empirical applications in which this weaker condition would hold but invertibility does not.**"
- Footnote 12: "without partial invertibility or recoverability, the historical and forecast error variance decompositions in (14) and (15) are not point-identified. Plagborg-Møller and Wolf (2017) derive **set identification** results for these decompositions using external instruments in the absence of invertibility or recoverability."

### The Hausman-type invertibility test (§3)
- Hypotheses (eq. 27): H₀: C_h Θ_{0,1} = Θ_{h,1} for all h vs H₁: C_h Θ_{0,1} ≠ Θ_{h,1} for some h.
- **Local non-invertibility** (eq. 28): C_{h,T} Θ_{0,1} = Θ_{h,1} + T^{-1/2} d_h + o(T^{-1/2}). Motivated by Beaudry et al. (2015) and Plagborg-Møller (2016b), who show "the non-invertible (non-fundamental) representation of a time series may be very close to its invertible representation." Constructed in Appendix A.1 via O_p(T^{-1/4}) measurement-error contamination: Y_{t,T} = S X_t + T^{-1/4} η_t, which leaves all non-zero autocovariances unchanged but breaks recoverability of X_t.
- Statistic (eq. 30): ξ = T (θ̂^{LP-IV} − θ̂^{SVAR-IV})' V̂^{-1} (θ̂^{LP-IV} − θ̂^{SVAR-IV}) → χ²_m under H₀; non-central χ² with μ² = d' V^{-1} d under the local alternative.
- **Power depends on instrument strength, verbatim:** "for a given local alternative d, the non-centrality parameter converges to zero as α → 0, and increases to a finite limit as |α| increases. Thus, **the power of the test is increasing as the strength of the instrument increases**, according to this local strong-instrument approximation."
- h = 0 carries no information: "The LP-IV and SVAR-IV estimators for the impact effect (h = 0) are identical when lagged Ys are used as controls. Thus, this test compares the LP-IV and SVAR-IV estimates of the impulse responses for h ≥ 1."
- Contrast with Forni-Gambetti (2014), which tests Granger non-causality of Z for Y: "the testable implications all stem from moments involving Z: **second moments of Y alone cannot distinguish invertible from non-invertible processes.**"

---

## 7. Findings — with numbers

### Table 1 — Estimated causal effect of monetary policy shocks (GK variables, instrument and sample)

Columns: (1) LP-IV, no controls; (2) LP-IV, 4 lags of (z,y); (3) LP-IV, 4 lags of (z,y,f) with f = 4 FRED-MD factors; (4) SVAR-IV, 12 lags of y + 4 lags of z; (5) = (4) − (2). Standard errors in parentheses (Newey-West with h+1 lags for LP; parametric Gaussian bootstrap for SVAR and for column 5).

| Var | h | (1) LP-IV no ctrl | (2) LP-IV 4 lags (z,y) | (3) LP-IV + factors | (4) SVAR-IV | (5) SVAR − LP |
|---|---|---|---|---|---|---|
| R | 0 | 1.00 (0.00) | 1.00 (0.00) | 1.00 (0.00) | 1.00 (0.00) | 0.00 (0.00) |
| R | 6 | −0.07 (1.34) | 1.12 (0.52) | 0.67 (0.57) | 0.89 (0.31) | −0.23 (1.19) |
| R | 12 | −1.05 (2.51) | 0.78 (1.02) | −0.12 (1.07) | 0.78 (0.46) | 0.00 (1.79) |
| R | 24 | −2.09 (5.66) | −0.80 (1.53) | −1.57 (1.48) | 0.40 (0.49) | 1.19 (2.57) |
| IP | 0 | −0.59 (0.71) | 0.21 (0.40) | 0.03 (0.55) | 0.16 (0.59) | −0.06 (0.35) |
| IP | 6 | −2.15 (3.42) | −3.80 (3.14) | −4.05 (3.65) | −0.81 (1.19) | 3.00 (2.32) |
| IP | 12 | −3.60 (6.23) | −6.70 (4.70) | −6.86 (5.49) | −1.87 (1.54) | 4.83 (4.00) |
| IP | 24 | −2.99 (10.21) | −9.51 (7.70) | −8.13 (7.62) | −2.16 (1.65) | 7.35 (6.40) |
| P | 0 | 0.02 (0.07) | −0.08 (0.25) | −0.04 (0.25) | 0.02 (0.23) | 0.10 (0.13) |
| P | 6 | 0.16 (0.42) | −0.39 (0.52) | −0.79 (0.83) | 0.31 (0.41) | 0.71 (0.98) |
| P | 12 | −0.26 (0.88) | −1.35 (1.03) | −1.37 (1.23) | 0.45 (0.54) | 1.80 (1.53) |
| P | 24 | −0.88 (3.08) | −2.26 (1.31) | −2.58 (1.69) | 0.50 (0.65) | 2.76 (2.60) |
| EBP | 0 | 0.51 (0.61) | 0.67 (0.40) | 0.82 (0.49) | 0.77 (0.29) | 0.09 (0.24) |
| EBP | 6 | 0.22 (0.30) | 1.33 (0.81) | 1.66 (1.04) | 0.48 (0.20) | −0.85 (0.51) |
| EBP | 12 | 0.56 (0.91) | 0.84 (0.65) | 0.91 (0.80) | 0.18 (0.13) | −0.66 (0.55) |
| EBP | 24 | −0.44 (1.29) | 0.94 (0.66) | 0.85 (0.76) | 0.06 (0.07) | −0.88 (0.62) |
| **First-stage F^Hom** | | **1.7** | **23.7** | **18.6** | **20.5** | na |
| **First-stage F^HAC** | | **1.1** | **15.5** | **12.7** | **19.2** | na |

Definitions from the table note: "F^Hom is the standard (conditional homoscedasticity, no serial correlation) first-stage F-statistic, while F^HAC is the Newey-West version using 12 lags in (1) and heteroscedasticity-robust (no lags) in (2), (3) and (4)."

### Weak-instrument headline (the numbers a proxy-SVAR paper will want to cite)

- **Without controls, the GK instrument is weak: first-stage F = 1.7 (homoscedastic), 1.1 (HAC), with first-stage R² = 0.006.** Verbatim: "the first-stage F-statistic — that is the (standard) F-statistic from the regression of R_t onto FFF_t — is small, only 1.7, raising weak instrument concerns."
- **Anatomy of the weakness, verbatim:** "Because interest rates are very persistent, only a small fraction of the variance is attributable to contemporaneous shocks, ε_t; a fraction of this contemporaneous effect is associated with the monetary policy shock ε_{1,t}; and only a fraction of ε_{1,t} can be explained by the instrument Z_t. Taken together, these effects yield a first-stage regression with R² = 0.006 and a correspondingly small F-statistic."
- **Controls fix it:** "the first-stage (partial) R² in (2) increases to R² = 0.09 with a first-stage F-statistic increasing to F = 23.7." Adding FRED-MD factors instead gives F = 18.6 / 12.7 and "results that are largely consistent with the results using lags of Z and Y."
- Column (4)'s F differs slightly from (2) "Because the VAR uses 12 lags of Y instead of the four lags used as controls in the local projections."

### The GK MA(1) instrument-construction problem (directly analogous to monthly aggregation of high-frequency surprises)

Verbatim: "as pointed out by Ramey (2016), Gertler and Karadi (2015) form their FFF instrument as a **moving average of returns from month t and month t − 1**. Thus, FFF_t will be correlated with both ε_{1,t} and ε_{1,t-1}, **violating Assumption LP-IV (iii). Because Z_t has a MA(1) structure, using lags of Z_t as controls eliminates the correlation with ε_{1,t-1}, so that Condition LP-IV⊥ (iii) is satisfied.** Despite the MA(1) structure, it is plausible that this instrument is uncorrelated with other shocks. Thus, to satisfy Condition LP-IV⊥ (iii), it would suffice to include lags of Zs as controls; including lagged Ys and additional lags of Z serves to improve precision (increase the first-stage F)."

Footnote 13 (crucial asymmetry): "The construction of Z_t is described in footnote 6 in GK. **The MA(1) structure invalidates the LP-IV regression reported in column (1), but it does not affect its validity in the SVAR-IV regression used by GK.** An additional issue is that the weights used in GK's construction of Z_t are time varying because of floating FOMC meeting dates. In principle, this could yield a time-varying MA(1) structure but we approximate the MA coefficients as constant."

### Why the SVAR standard errors are smaller (two reasons, verbatim)
"First, the local projections are estimated using regressions with error terms that include leads and lags of ε (see (31)), and these terms are absent from the IV regression used in the SVAR, because only the impact effect, Θ₀, is estimated by IV. Second, the VAR parameterisation imposes smoothness and damping on the moving average coefficients in C_h, which further reduces the standard errors. **Still, in this empirical application, the standard errors in the SVAR remain large.**"

Also noted: the error decomposition (31) Y_{i,t+h} = Θ_{h,i1} ε_{1,t+h} + {ε_{t+h},…,ε_{t+1}} + {ε_{2:n,t}} + {ε_{t-1},…} — controls remove the *lagged* ε block but "neither eliminates the variability associated with *future* ε's… The variability of this component increases with the horizon h. **When the structural moving average model is invertible, it is in effect possible to control for both lagged and future values of ε in the IV regression using VAR methods.**"

Note on measurement error and n = m: "If there are more than four shocks that affect Y_t or if some elements of Y_t are measured with error (as IP and P surely are), then the innovations to the four variables making up Y_t will not span the space of the shocks. This is not a problem for the validity of LP-IV with lagged Z_t; however, it does suggest that including additional variables that are correlated with the shocks could further reduce the regression standard error."

### Table 2 — Tests for VAR invertibility (p-values)

| Test | 1 year rate | ln(IP) | ln(CPI) | GZ EBP |
|---|---|---|---|---|
| VAR-LP difference (lags 0, 6, 12, 24) — the ξ statistic (30) | 0.95 | 0.55 | 0.75 | 0.26 |
| VAR Z-GC test (4 lags of Z jointly zero in each VAR equation) | 0.16 | 0.09 | 0.38 | 0.97 |

Verdict, verbatim: "Some of the differences between the SVAR and LP estimates are large, but so are their estimated errors, and **none of the differences are statistically significant.** Relative to the sampling uncertainty, the differences in the LP and SVAR estimates shown in Table 1 are not large enough to conclude that the SVAR suffers from misspecification associated with a lack of invertibility." And: "Despite the large differences, in economic terms, between the two estimates of the impulse responses, the table indicates that **there is no statistically significant evidence against the null of hypothesis of invertibility.**"

(Careful reading for citation purposes: the failure to reject is a *low-power* result — the paper itself shows test power is increasing in instrument strength, and the economic magnitudes differ substantially, e.g. IP at h = 24 is −9.51 under LP-IV(2) vs −2.16 under SVAR-IV.)

---

## 8. Contributions — what is new

The paper states five contributions explicitly (paraphrased from the enumerated list, key phrasing verbatim):

1. **Validity conditions for LP-IV without invertibility.** "we provide conditions for instrument validity for LP-IV, and show that under those conditions LP-IV can estimate dynamic causal effects **without assuming invertibility**… exogeneity of the instrument entails a strong 'lead–lag exogeneity' requirement that the instrument be uncorrelated with past and future shocks, at least after including control variables. This condition provides concrete guidance for the construction of instruments and choice of control variables."
2. **Recapitulation of SVAR-IV** and the statement that it is asymptotically more efficient under strong-instrument asymptotics and does not require lead–lag exogeneity, but does require invertibility.
3. **A Hausman-type test of invertibility** based on the SVAR-IV vs LP-IV difference: the statistic, its large-sample null distribution, the new concept of **local non-invertibility**, and the local asymptotic power. "The focus of this test on the impulse response function — the estimand of interest — differs from existing tests for invertibility, which examine the no-omitted-variables implication by adding variables; see, for example, Forni and Gambetti (2014)."
4. **The "no free lunch" theorem (Theorem 1).** Adding lagged Ys as generic controls to rescue an instrument correlated with past shocks is valid (for a generic instrument) **if and only if** SVAR-IV's conditions plus invertibility hold — "in which case SVAR-IV provides more efficient inference."
5. **Econometric odds and ends**: HAR standard errors, weak instruments, cumulative dynamic effects, ratios of cumulative multipliers, historical decompositions and FEVDs, news-shock normalisation, and "the pros and cons of using generic controls including factors from dynamic factor models (**factor-augmented LP-IV**)."

Framing contribution: positioning external instruments as a **third** route out of the observational-equivalence problem. Verbatim from the conclusions: "with Gaussian errors, every invertible model has multiple observationally equivalent non-invertible representations, so if one is to distinguish among them, some external information must be brought to bear. One approach is to assume that the shocks are **independent and non-Gaussian**, and to exploit higher order moment restrictions to identify the causal structure (Lanne and Saikkonen, 2013; Gospodinov and Ng, 2015; **Gourieroux et al., 2017**). A second approach is to use a priori informative priors (Plagborg-Møller, 2016b). Here, we have shown that there is a third approach, which is to use an external instrument… Under a lead–lag exogeneity condition, the external instrument identifies the structural impulse response function without assuming invertibility."

Intellectual-history contribution: tracing the idea to Blanchard and Sims's comment in the published discussion of Romer and Romer (1989) ("it seems not to have been followed up"), Beaudry and Saito (1998) as the earliest use of constructed shocks as an instrument in a SVAR, Stock (2008) for SVAR-IV, and Mertens (2015)'s unpublished lecture notes for the no-control LP-IV validity condition.

Open questions listed in the conclusions: homogeneous treatment effects; weak-instrument robustification of the invertibility test; whether LP is really robust to non-linearity ("it seems that there would be a **non-linear counterpart to our no free lunch theorem**"); and — the closing line — "In our view, the most exciting work to be done in this area is empirical. We look forward to the development of new external instruments that provide plausibly exogenous variation."

---

## 9. Replication feasibility

| Dimension | Assessment from the chunk text |
|---|---|
| Underlying data | **Public and standard.** The empirical illustration uses Gertler and Karadi's (2015) published replication data (AEJ:Macro data archives are public), plus the Gilchrist-Zakrajšek (2012) excess bond premium and the **FRED-MD** monthly database (McCracken and Ng, 2016) for the four factors in column (3). Sample periods are fully specified (Z: 1990m1–2012m6; Y: 1979m1–2012m6; VAR: 1980m7–2012m6; IV regression: 1990m5–2012m6). |
| Replication archive / code | The article lists "Additional Supporting Information… **Data S1**" in the online version. The chunk text does **not** state whether Data S1 contains code, data, or both, and gives no repository URL. Flag as unverified. |
| Specification detail | High. Lag structures (12 VAR lags; 4 lags of z,y,f as LP controls), transformations (100·Δln IP, 100·Δln P; R and EBP in annualised percentage points), standard-error definitions (Newey-West h+1 lags; F^Hom vs F^HAC with 12 NW lags in column 1), and the full bootstrap DGP (VAR(12) for Y, AR(4) for Z, joint Gaussian residual draws, **1,000 draws**) are all specified in the text and Appendix A.2. |
| Estimators | Elementary to re-implement: 2SLS by horizon (LP-IV), 2SLS + VAR inversion (SVAR-IV), a χ² Hausman statistic. No proprietary software or unusual numerical methods. |
| Practical obstacles | (i) The GK instrument's time-varying MA weights — SW themselves "approximate the MA coefficients as constant", so an exact reproduction of the MA correction requires GK's footnote-6 construction. (ii) The parametric bootstrap imposes invertibility under the null, so V̂ is model-based, not resampling-based. (iii) Not stated: random seed, FRED-MD vintage, and the exact factor-extraction procedure for the four factors in column (3). |
| Overall | **Highly replicable in principle** — all inputs are public and all specifications are stated — with the caveat that the supporting-information contents and any seeds/vintages are not described in the text. |

---

## Cross-cutting notes for a proxy-SVAR-inside-a-DFM literature review

Five items in this paper bear directly on that design and are worth quoting rather than paraphrasing:

1. **The unit-effect normalisation is the bridge to factor models.** "As discussed in Stock and Watson (2016), the unit effect normalisation also allows for direct extension of SVAR methods to structural dynamic factor models." Plus the bands-inside-the-bootstrap warning.
2. **A proxy-SVAR (SVAR-IV) needs only Conditions (i) relevance and (ii) contemporaneous exogeneity — but it buys that by assuming invertibility.** It does *not* need lead–lag exogeneity; LP-IV does. This is the cleanest available statement of what a proxy-SVAR is paying for.
3. **A large panel / DFM is the natural response to the invertibility-as-omitted-variables reading, but it is not a guarantee**: "moving to large systems does not assure invertibility."
4. **Monthly aggregation of high-frequency surprises creates an MA structure that invalidates LP-IV but not SVAR-IV** (footnote 13). Any project aggregating event-window surprises to monthly frequency inherits exactly the GK issue SW diagnose.
5. **First-stage F is the wrong ruler in general.** SW use it, report both F^Hom and F^HAC, and simultaneously say the conventional toolkit is only licensed under a narrow special case (lagged-Y controls + invertible VAR + serially uncorrelated Z conditional on W + homoscedasticity), pointing to Montiel Olea-Pflueger (2013), Andrews (2018) and **Montiel Olea, Stock and Watson (2017)** for the SVAR-IV case.
