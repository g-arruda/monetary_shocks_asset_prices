# Gonçalves & Kilian (2004) — Bootstrapping autoregressions with conditional heteroskedasticity of unknown form

Structured extract produced by the `split-pdf-md` Agent Isolation Protocol (3 chunks, read in one batch).
Source: marker-extracted `.md` chunks under
`artigos/gonçalves and kilian - Bootstrapping autoregressions with conditionalheteroskedasticity of unknown form/..._build/chunks_.../`
(`chunk_01_bootstrapping_autoregressions_with_condi.md`, `chunk_02_a_ar_1_egarch_model_engle_and_ng_1993.md`, `chunk_03_acknowledgements.md`).

---

## Bibliographic metadata

Everything below is **stated in the text** unless flagged.

- **Title:** "Bootstrapping autoregressions with conditional heteroskedasticity of unknown form" (chunk 01, running head and title block).
- **Authors:** Sílvia Gonçalves (a), Lutz Kilian (b,c).
- **Affiliations (as printed):**
  - Gonçalves — CIRANO, CIREQ and Département de Sciences Économiques, Université de Montréal, C.P. 6128, succ. Centre-Ville, Montréal, Canada QC H3C 3J7. (Corresponding author.)
  - Kilian — CEPR and Department of Economics, University of Michigan, Ann Arbor, MI 48109-1220, USA; Directorate General Research, European Central Bank, Kaiserstrasse 29, 60311 Frankfurt am Main, Germany.
- **Journal / volume / year / pages:** *Journal of Econometrics* **123** (2004) **89–120**. Printed masthead: "Journal of Econometrics 123 (2004) 89-120".
- **Accepted:** 1 August 2003. © 2003 Elsevier B.V.
- **JEL:** C15; C22. **Keywords:** Bootstrap; Wild bootstrap; Autoregressions; Conditional heteroskedasticity.
- **Funding note:** FRSC (Fonds de Recherche sur la Société et la Culture) and SSHRCC.
- **Disclaimer:** "The views expressed in this paper do not necessarily reflect the opinion of the ECB or its staff."

**Confirmation of the caller's citation:** author names, year (2004), title, journal, volume 123 and page range 89–120 are all confirmed verbatim from the text. Nothing in the caller's citation is contradicted.

**Not stated in the text (flags):**
- No DOI, no issue number, and no "issue 1" designation appears anywhere in the extracted markdown. The caller's "123(1)" is *plausible* but **not verifiable from this source**.
- No submission date (only the acceptance date).
- No explicit statement that the paper is univariate-only in title/abstract; that restriction is stated in §2 body text ("For expository purposes we focus on univariate autoregressive models").

**OCR / extraction defects to be aware of before quoting numbers:**
- The marker extraction mangles the ligature "fi" as "1" throughout the prose ("1rst-order", "1nance", "speci1c", "eMcient", "di5erences"). Harmless for meaning, fatal for copy-paste quoting.
- **Table 1 is truncated by the extractor**: only three of the six series survive (Real T-bill rate, Federal funds rate, percent change in oil price) and the column headers (the ARCH lag orders *q*) are gone. The three missing rows (industrial output growth, M1 growth, CPI inflation) are described in the body but their p-values are not recoverable from this markdown.
- Table row labels are corrupted in places: Table 2 prints `00` where `100` belongs; Table 5 prints `00` for 100, 200 and 400. Table 3 has a garbled cell (`0.99 | 0.05 | 0.54` where 0.94 is meant, given the pattern in Table 2).
- Reference list has OCR-mangled names: "HPardle" = Härdle, "MilhHj" = Milhøj, "TerPasvirta" = Teräsvirta, "Gon*calves" = Gonçalves, "LutkepohlP" = Lütkepohl, "UniversitPat" = Universität.

---

## 1. Research question

Can bootstrap inference for stationary autoregressions be made valid when the innovations are **martingale differences with conditional heteroskedasticity of unknown form** — i.e., without the researcher taking a stand on the existence or the parametric form of the ARCH/GARCH/SV process?

Three sub-questions:
1. Why exactly does the standard i.i.d.-residual recursive bootstrap fail in this environment? (Answer: it misrepresents the fourth-order cumulants of ε_t.)
2. Which easy-to-implement alternatives are **first-order asymptotically valid**, and under what assumptions?
3. How accurate are they in samples of the size actually used in applied macro and finance (n = 50–400)?

Explicitly **out of scope** (stated in §5): higher-order asymptotic refinements. "We did not attempt to address the issue of the existence of higher-order asymptotic refinements provided by the bootstrap approximation. Arguments aimed at proving asymptotic refinements require the existence of an Edgeworth expansion for the distribution of the estimator of interest. Establishing the existence of such an Edgeworth expansion is beyond the scope of this paper."

## 2. Audience

Applied macroeconometricians and empirical finance researchers who estimate autoregressions (and smooth functions of AR parameters — **impulse responses are named explicitly** in §2) on monthly, weekly or daily data, and who currently use either (a) the standard residual-based i.i.d. bootstrap, or (b) Gaussian asymptotics with robust standard errors. Also theoretical econometricians working on bootstrap validity in time series.

The paper's own targeting recommendation (§5): **"The recursive-design WB seems best suited for applications in empirical macroeconomics."** The pairwise bootstrap is recommended for finance-type applications with large n where asymmetric GARCH is a concern.

## 3. Method

Univariate AR(p) with **finite and known** lag order:

    φ(L) y_t = ε_t,   φ(L) = 1 − φ₁L − … − φ_p L^p,  φ_p ≠ 0,
    all roots outside the unit circle; φ = (φ₁,…,φ_p)' estimated by OLS on t = 1,…,n
    with Y_{t−1} = (y_{t−1},…,y_{t−p})'.

Data observed: {y_{−p+1},…,y_0,y_1,…,y_n}. Parameter of interest: φ and smooth functions thereof.

### 3.0 The precise class of conditional heteroskedasticity covered — Assumption A (verbatim)

{ε_t, t ∈ ℤ} is a martingale difference sequence on (Ω, 𝓕, P), ε_t measurable w.r.t. 𝓕_t.

- **(i)** E(ε_t | 𝓕_{t−1}) = 0 almost surely, where 𝓕_{t−1} = σ(ε_{t−1}, ε_{t−2}, …).
- **(ii)** E(ε_t²) = σ² < ∞.
- **(iii)** lim_{n→∞} n^{−1} Σ_{t=1}^n E(ε_t² | 𝓕_{t−1}) = σ² > 0 in probability.
- **(iv)** τ_{r,s} ≡ σ^{−4} E(ε_t² ε_{t−r} ε_{t−s}) is uniformly bounded for all t, r ≥ 1, s ≥ 1; τ_{r,r} > 0.
- **(v)** lim_{n→∞} n^{−1} Σ_{t=1}^n ε_{t−r} ε_{t−s} E(ε_t² | 𝓕_{t−1}) = σ⁴ τ_{r,s} in probability for any r ≥ 1, s ≥ 1.
- **(vi)** E|ε_t|^{4r} is uniformly bounded, for some **r > 1** (i.e. slightly more than four moments).

Paper's own gloss, verbatim: *"Assumption A replaces the usual i.i.d. assumption on the errors {ε_t} by the less restrictive martingale difference sequence assumption. In particular, Assumption A allows for dependent, but uncorrelated errors. It does not impose conditional homoskedasticity on the sequence {ε_t}, although it requires {ε_t} to be covariance stationary. Assumption A covers a variety of conditionally heteroskedastic models such as ARCH, GARCH, EGARCH and stochastic volatility models (see, e.g. Deo (2000) …). Assumptions (iv) and (v) restrict the fourth-order cumulants of ε_t."*

**Under Assumption A alone:** valid = **fixed-design WB** and **pairwise bootstrap**. Covered DGPs include ARCH, GARCH, **EGARCH, AGARCH, GJR-GARCH** (the asymmetric family) and stochastic volatility.

### 3.0b The strengthening — Assumption A′ (required only for the recursive-design WB)

- **(iv′)** E(ε_t² ε_{t−r} ε_{t−s}) = 0 for all r ≠ s, all t, r ≥ 1, s ≥ 1. Equivalently τ_{r,s} = 0 for r ≠ s.
- **(vi′)** E|ε_t|^{4r} is uniformly bounded for some **r ≥ 2** and for all t — i.e. **at least eight moments**, versus "4r moments for some r > 1" in A(vi).

What A′(iv′) buys and costs, stated in the paper:
- Satisfied by ARCH(p) with **symmetrically distributed** innovations (Milhøj, 1985); extended to GARCH(p,q) by Bollerslev (1986) and He & Teräsvirta (1999); satisfied by certain stochastic volatility models (Deo, 2000).
- **"Assumption A′(iv′) excludes some non-symmetric parametric models such as asymmetric EGARCH."** By extension this is where AGARCH and GJR-GARCH lose theoretical coverage for the recursive design.
- Mechanism: without A′(iv′), an **asymptotic bias term** appears in the estimation of B ≡ σ⁴ Σ_i Σ_j b_i b_j′ τ_{i,j}, equal to **−σ⁴ Σ_{i≠j} b_i b_j′ τ_{i,j}**. The recursive WB variance B*_rwb converges to B̃ ≡ Σ_j b_j b_j′ σ⁴ τ_{jj} — the diagonal-only object — so it consistently estimates B only when the off-diagonal τ's vanish.

### 3.1 Recursive-design wild bootstrap — the exact algorithm

Generate the pseudo series recursively:

    y*_t = Y*_{t−1}′ φ̂ + ε̂*_t,   t = 1,…,n
    ε̂*_t = ε̂_t · η_t,   with ε̂_t = φ̂(L) y_t   (in the AR(1) simulations: ε̂_t = y_t − φ̂₀ − φ̂₁ y_{t−1})
    Y*_{t−1} = (y*_{t−1},…,y*_{t−p})′,  given appropriate initial conditions
    y*_t = 0 for all t ≤ 0   (theory)

η_t: **i.i.d. sequence with mean zero and variance one such that E*|η_t|⁴ ≤ Δ < ∞** (fourth-moment bound).

Bootstrap estimator: φ̂*_rwb = (n^{−1} Σ Y*_{t−1} Y*_{t−1}′)^{−1} n^{−1} Σ Y*_{t−1} y*_t.

Start-up values in the simulations (deviating from the theory's zero initialization): *"For the recursive-design bootstrap methods, we generate the start-up values by randomly drawing observations with replacement from the original data set (see, e.g. Berkowitz and Kilian, 2000)."*

**Theorem 3.2.** Under Assumption A strengthened by A′(iv′) and (vi′):
sup_{x∈ℝ^p} | P*(√n(φ̂*_rwb − φ̂) ≤ x) − P(√n(φ̂ − φ) ≤ x) | →^P 0.

Attribution: Kreiss (1997) proposed this scheme ("modified wild bootstrap") for AR models with i.i.d. errors but **did not establish its consistency under conditional heteroskedasticity**; the consistency proof under m.d.s. errors is this paper's contribution.

### 3.2 Fixed-design wild bootstrap — the exact algorithm

    y*_t = Y_{t−1}′ φ̂ + ε̂*_t,   t = 1,…,n            (eq. 3.2)
    ε̂*_t = ε̂_t · η_t,  ε̂_t = φ̂(L) y_t

Note **Y_{t−1}, not Y*_{t−1}**: the regressors are held at their original-sample values (conditional fixed-design regression). Corollary 3.1 makes this explicit: "we implicitly set Y*_{t−1} = Y_{t−1} for the fixed-design WB."

η_t: **i.i.d., mean zero, variance one, with E*|η_t|^{2r} ≤ Δ < ∞ for some r > 1** — a *weaker* moment requirement on the multiplier than the recursive design's fourth-moment bound.

Estimator: φ̂*_fwb = (n^{−1} Σ Y_{t−1} Y_{t−1}′)^{−1} n^{−1} Σ Y_{t−1} y*_t.

**Theorem 3.3.** Under Assumption A (no strengthening): sup_x |P*(√n(φ̂*_fwb − φ̂) ≤ x) − P(√n(φ̂ − φ) ≤ x)| →^P 0.

Why it needs no strengthening: the fixed-design bootstrap variance is
B*_fwb ≡ Var*(n^{−1/2} Σ Y_{t−1} ε̂*_t) = n^{−1} Σ Y_{t−1} Y_{t−1}′ ε̂_t²
— i.e. **exactly the Eicker–White sandwich meat**, which converges to B under Assumption A, and A*_fwb = n^{−1} Σ Y_{t−1}Y_{t−1}′ → A. So A*^{−1}B*A*^{−1} →^P C.

Antecedents: fixed-design WB originally suggested by Kreiss (1997), whose Theorem 4.2 proved validity only for the restricted DGP y_t = Σφ_i y_{t−i} + σ(y_{t−1}) v_t with v_t i.i.d. (0,1) and finite fourth moment — an assumption "violated if for instance the conditional moments of v_t depend on past observations." A similar "fixed-regressor bootstrap" is in Hansen (2000).

### 3.3 Pairwise bootstrap — the exact algorithm

Resample **with replacement from the set of tuples** (y_t, Y_{t−1}′) = (y_t, y_{t−1},…,y_{t−p}), t = 1,…,n, i.i.d. Estimator
φ̂*_pb = (n^{−1} Σ Y*_{t−1} Y*_{t−1}′)^{−1} n^{−1} Σ Y*_{t−1} y*_t.
The bootstrap analogue of φ is φ̂, since φ̂ minimizes E*[(y*_t − Y*_{t−1}′φ)²].

**Theorem 3.4.** Under Assumption A: sup_x |P*(√n(φ̂*_pb − φ̂) ≤ x) − P(√n(φ̂ − φ) ≤ x)| →^P 0.

Extension of Freedman (1981) from cross-sections to the AR context.

### 3.4 Studentized (percentile-t) version

Bootstrap t-statistic t_{φ̂*_j} = √n(φ̂*_j − φ̂_j)/√(Ĉ*_jj), analogue of t_{φ̂_j} = √n(φ̂_j − φ_j)/√(Ĉ_jj), with the **heteroskedasticity-consistent** variance estimator on both original and bootstrap data:

    Ĉ* = Â*^{−1} B̂* Â*^{−1},  Â* = n^{−1} Σ Y*_{t−1} Y*_{t−1}′,  B̂* = n^{−1} Σ Y*_{t−1} Y*_{t−1}′ ε̃*_t²,
    ε̃*_t = y*_t − φ̂*′ Y*_{t−1}   (bootstrap residuals)

**Corollary 3.1.** Under Assumption A the percentile-t bootstrap is valid for the **fixed-design WB and the pairwise bootstrap**; under Assumption A strengthened by A′(iv′) and (vi′), also for the **recursive-design WB**.

### 3.5 Why the standard i.i.d. residual bootstrap is INVALID (the paper's own derivation)

Let ε̂*_t be resampled **with replacement from the centered residuals**, and y*_t = Y*_{t−1}′φ̂ + ε̂*_t. Because ε̂*_t is i.i.d.(0, σ̂²) with σ̂² = n^{−1}Σ(ε̂_t − ε̄)², ε̂*_t and Y*_{t−1} are conditionally independent, hence

    B*_riid = n^{−1} Σ E*(Y*_{t−1}Y*_{t−1}′ ε̂*_t²) = n^{−1} Σ E*(Y*_{t−1}Y*_{t−1}′) E*(ε̂*_t²) = σ̂² A*_riid

so C*_riid ≡ A*^{−1}_riid B*_riid A*^{−1}_riid = σ̂² A*^{−1}_riid →^P **σ² A^{−1}**, i.e. the limiting distribution of the recursive i.i.d. bootstrap is N(0, σ²A^{−1}).

But Theorem 3.1 gives the true limit as **N(0, C) with C = A^{−1}BA^{−1}**, A = σ² Σ_j b_j b_j′, B = σ⁴ Σ_i Σ_j b_i b_j′ τ_{i,j}. σ²A^{−1} is correct **only** under conditional homoskedasticity (where τ_{i,i}=1 ∀i and τ_{i,j}=0 for i≠j, so B = σ²A).

The exact failure mechanism, verbatim: *"The standard residual-based bootstrap method fails to do so by not correctly mimicking the behavior of the fourth-order cumulants of ε_t in the conditionally heteroskedastic case."* Concretely, *"The recursive-design i.i.d. bootstrap implies E*(ε̂*_{t−i} ε̂*_{t−j} ε̂*_t²) = σ̂⁴ when i = j and zero otherwise, and thus implicitly sets τ_{i,j} = 1 for i = j and τ_{i,j} = 0 for i ≠ j."*

**Correction to the caller's framing.** The paper shows exactly **one** method to be invalid — the **i.i.d. residual (recursive) bootstrap**. The **pairwise bootstrap is proved VALID** (Theorem 3.4), not invalid. The **block bootstrap of autoregressive residuals is neither proved valid nor proved invalid** here: it is raised as "a third proposal … (see, e.g., Berkowitz et al., 2000)" and then **declined**, on two stated grounds:
1. *"in the context of a well-specified parametric model this proposal involves a loss of efficiency relative to the WB because it allows for serial correlation in the error term in addition to conditional heteroskedasticity"*;
2. it *"requires the choice of an additional tuning parameter in the form of the block size. In practice, results may be sensitive to the choice of block size. Although there are data-dependent rules for block size selection, these procedures are very computationally intensive and little is known about their accuracy in small samples."*
The paper also states flatly: **"No formal theoretical results exist that would justify such a bootstrap proposal."**

Other methods flagged as relying on assumptions violated here (but not analyzed): the **grid bootstrap of Hansen (1999)** ("based on the assumption of an autoregression with i.i.d. errors") and **Lütkepohl (1990)** closed-form asymptotic impulse-response distributions ("based on the assumption of conditional homoskedasticity and hence will be inconsistent in the presence of conditional heteroskedasticity"). Making a robust version of the grid bootstrap is listed as future work.

## 4. Data

Two distinct data usages.

**(a) Motivating empirical evidence (Table 1, §2).** Six U.S. monthly series from **FRED**, sample **1959.1–2001.8**: growth rate of industrial output, M1 growth, CPI inflation, the real 3-month T-Bill rate, the nominal Federal Funds rate, the percent change in the price of oil. Each is filtered by a univariate AR whose lag order is selected by **AIC subject to an upper bound of 12 lags**. Engle (1982) LM tests of the No-ARCH(q) null; p-values approximated with **20,000 bootstrap replications under the i.i.d. error null**. Results "strongly reject the assumption of conditional homoskedasticity"; "Similar results are obtained for a fixed number of 12 lags or of 24 lags." Surviving extracted p-values (in percent, four ARCH-lag columns whose headers the extractor lost):
- Real T-bill rate: 0.08, 0.18, 0.29, 0.37
- Federal funds rate: 3.37, 0.45, 0.71, 0.94
- Percent change in oil price: 2.39, 3.77, 5.25, 4.60

**(b) Monte Carlo DGPs (§4).** All simulated. AR(1): y_t = φ₁ y_{t−1} + ε_t with **φ₁ ∈ {0, 0.9}**; all fitted models include an intercept.
- **GARCH(1,1):** ε_t = √h_t v_t, h_t = ω + α ε²_{t−1} + β h_{t−1}; unconditional variance normalized to one; v_t i.i.d. N(0,1) ("N-GARCH") **or** normalized t₅ ("t₅-GARCH"). Persistence grid **α+β ∈ {0, 0.5, 0.95, 0.99}**, with (α,β) pairs (0,0), (0.5,0), (0.3,0.65), (0.2,0.79), (0.05,0.94). β=0 ⇒ ARCH(1); α=β=0 ⇒ i.i.d. errors.
- **EGARCH** (Engle & Ng, 1993): ln(h_t) = −0.23 + 0.9 ln(h_{t−1}) + 0.25[|v²_{t−1}| − 0.3 v_{t−1}], v_t ~ N(0,1).
- **AGARCH** (Engle, 1990): h_t = 0.0216 + 0.6896 h_{t−1} + 0.3174[ε_{t−1} − 0.1108]², v_t ~ N(0,1).
- **GJR-GARCH** (Glosten, Jaganathan & Runkle, 1993): h_t = 0.005 + 0.7 h_{t−1} + 0.28[|ε_{t−1}| − 0.23 ε_{t−1}]², v_t ~ N(0,1).
- **Stochastic volatility** (Shephard, 1996 fits to real exchange rate data, following Deo, 2000): ε_t = v_t exp(h_t), h_t = λ h_{t−1} + 0.5 u_t, |λ|<1, (u_t,v_t) independent bivariate normal, mean zero, covariance diag(σ_u², 1). Parameter pairs **(λ, σ_u) = (0.936, 0.424)** and **(0.951, 0.314)**. "This model is a m.d.s. model and satisfies Assumption A."

Sample sizes **n ∈ {50, 100, 200, 400}**; **10,000 Monte Carlo trials**, **999 bootstrap replications** each.

## 5. Statistical / numerical methods

- **Target of inference in the simulations:** nominal **90% symmetric percentile-t** confidence intervals for the slope φ₁, of the form
  ( φ̂₁ − t*_{0.9} n^{−1/2} √Ĉ₁₁ , φ̂₁ + t*_{0.9} n^{−1/2} √Ĉ₁₁ ), where Pr(|t_{φ̂*₁}| ≤ t*_{0.9}) = 0.9.
  Equal-tailed percentile-t was also computed but symmetric intervals "virtually always were slightly more accurate."
- **Standard error used inside the t-statistic:** the heteroskedasticity-robust estimator of Nicholls & Pagan (1983), based on Eicker (1963) and White (1980): **(X′X)^{−1} X′ diag(ε̂_t²) X (X′X)^{−1}**. Modified robust estimators (MacKinnon & White 1985; Chesher & Jewitt 1987; Davidson & Flachaire 2001) were tried and **"none of these estimators performed better than the basic estimator."** WB bootstrap standard errors gave "virtually identical results" but require a nested bootstrap loop and are **"not recommended for computational reasons."**
- **Benchmarks:** (i) recursive-design i.i.d. residual bootstrap; (ii) Gaussian large-sample approximation with Nicholls–Pagan robust standard errors.
- **Asymptotic theory tools (Appendix):** martingale-difference-array CLT (White 1999 p.133, with Lindeberg replaced by the stronger **Lyapunov** condition); Andrews' (1988) LLN for uniformly integrable L₁-mixingales; Brockwell–Davis Proposition 6.3.9 (truncation argument); Davidson (1994) Thm 24.3; Polya's theorem; Bühlmann (1995) Lemma 2.2 for uniform summability of the estimated ψ̂_j. Lemma A.1 generalizes Kuersteiner (2001) Lemma A.1 under weaker conditions (Kuersteiner assumes strict stationarity + ergodicity + a fourth-cumulant summability condition).
- **Theorem 3.1** (own contribution): under Assumption A, √n(φ̂ − φ) ⇒ N(0, C), C = A^{−1}BA^{−1}, A = σ² Σ_{j≥1} b_j b_j′, B = σ⁴ Σ_i Σ_j b_i b_j′ τ_{i,j}, where φ^{−1}(L) = Σ_j ψ_j L^j and b_j = (ψ_{j−1},…,ψ_{j−p})′. Under conditional homoskedasticity B = σ²A, and in the AR(1) case C reduces to **1 − φ₁²**.

### 5.x The multiplier distributions η_t — verbatim record (load-bearing for this project)

**Requirements imposed by the theorems** (this is all the paper requires):
- Recursive-design WB: η_t **i.i.d., E(η_t) = 0, Var(η_t) = 1, E*|η_t|⁴ ≤ Δ < ∞.**
- Fixed-design WB: η_t **i.i.d., E(η_t) = 0, Var(η_t) = 1, E*|η_t|^{2r} ≤ Δ < ∞ for some r > 1.**

**The three distributions actually used** (§4 baseline + Table 5 sensitivity analysis):
1. **Standard normal** — *"In the baseline simulations we use η_t ~ N(0,1)."* This is the paper's **baseline/default**.
2. **Mammen (1993) two-point:** η_t = **−(√5 − 1)/2** with probability **p = (√5 + 1)/(2√5)**, and η_t = **(√5 + 1)/2** with probability **1 − p**. [Numerically: −0.6180 w.p. ≈ 0.7236; +1.6180 w.p. ≈ 0.2764.]
3. **Liu (1988) two-point:** η_t = **1 with probability 0.5** and η_t = **−1 with probability 0.5**. *(This is the Rademacher distribution. **Flag: the paper never uses the word "Rademacher."** It attributes the ±1 scheme to Liu (1988) only.)*

**What the paper says about choosing among them — verbatim, all of it:**
- *"In practice, there are several choices for η_t that satisfy these conditions. In the baseline simulations we use η_t ∼ N(0,1). Our results are robust to alternative choices, as will be shown at the end of this section."*
- Table 5 discussion: *"Table 5 shows that the coverage results are remarkably robust to the choice of η_t. Moreover, **none of the three WB resampling schemes clearly dominates the others**."*
- §5, concluding remarks: *"preliminary simulation evidence indicates that wild bootstrap methods based on **two-point distributions, which may be expected to yield asymptotic refinements in our context, do not perform systematically better** than the first-order accurate methods studied in this paper."*
- Sensitivity analysis was run on the **recursive-design WB only**, and on **N-GARCH DGPs as in Table 2** ("To conserve space, we focus on the recursive-design WB only").

**Higher moments of the multiplier — what the paper does and does not say (direct answer to the caller's question):**
- **The paper never discusses the third moment of η_t.** There is no statement anywhere in the three chunks that E(η³) = 1, or that matching the third moment matters, or any skewness condition on η_t. The only distributional requirements stated are **mean 0, variance 1, and a bounded fourth (or 2r-th) absolute moment.** The Mammen distribution's defining property (that it matches the third moment) is **not mentioned** — Mammen is cited only as the source of the two-point scheme.
- **The fourth moment does appear explicitly, in the proofs.** In Lemma A.2(i): E*(z*_t²) = ε̂_t⁴ E*(η_t⁴ − 2η_t² + 1) = **ε̂_t⁴ (E*(η_t⁴) − 1)**, bounded via E*(η_t⁴) ≤ Δ < ∞. In Lemma A.2(iii) the key bootstrap moment is **E*[(η_{t−i} η_{t−j} η_t² − 1(i=j))²]**, again bounded using E*|η_t|⁴ < Δ. In Lemma A.3 the Lyapunov condition uses E*|η_t|^{2r} with r = 2, i.e. fourth moments. So the multiplier's **fourth** moment is what the asymptotics actually lean on; the third is never invoked.
- The only oblique reference to refinements-from-higher-moments is the §5 sentence quoted above about two-point distributions "which may be expected to yield asymptotic refinements in our context" — and the finding is that they **do not** deliver systematically better finite-sample coverage. **Flag: the paper offers no theoretical statement of which moments a refinement would require, because it declines to build the Edgeworth expansion.**
- **Direct implication for a method that needs third moments preserved:** Gonçalves–Kilian give no cover either way. The Rademacher/Liu choice is *permitted* by their assumptions (E η = 0, E η² = 1, E η⁴ = 1 < ∞) and performs indistinguishably from N(0,1) and Mammen in their Table 5. Nothing here endorses Rademacher over the alternatives; conversely nothing here warns that Rademacher's **E(η³) = 0** annihilates third moments — that consequence is arithmetic, not something this paper flags. Since the paper is silent on third moments, **any argument that the wild bootstrap must be replaced when third moments matter cannot be sourced to this paper**; it has to be sourced to the third-moment-dependent method's own requirements. Note also, for the record, that the multipliers' own third moments are: N(0,1) → 0; Liu/Rademacher (±1 w.p. ½) → 0; Mammen two-point → 1. *(The last two values are arithmetic, **not stated in the paper**.)*

## 6. Findings (with numbers)

All coverage figures are for **nominal 90% symmetric percentile-t intervals for φ₁**, 10,000 trials × 999 bootstrap replications.

### 6.1 The i.i.d. residual bootstrap breaks badly, and gets WORSE as n grows

Table 2 (N-GARCH), φ₁ = 0, ARCH(1) case α+β = 0.5 (α=0.5, β=0), recursive i.i.d. column:
| n | 50 | 100 | 200 | 400 |
|---|---|---|---|---|
| Recursive i.i.d. | **77.5** | **73.6** | **70.7** | **68.5** |
| Recursive WB | 88.9 | 89.3 | 89.3 | 90.0 |
| Fixed WB | 87.9 | 88.5 | 88.5 | 89.4 |
| Pairwise | 89.5 | 89.3 | 89.4 | 89.9 |
| Robust SE Gaussian | 84.8 | 86.1 | 87.2 | 88.3 |

Paper's wording: *"the accuracy of the standard recursive-design bootstrap procedure based on i.i.d. resampling of the residuals is high when the model errors are truly i.i.d., but can be very poor in the presence of N-GARCH. In the latter case, **accuracy tends to deteriorate for large n**."*

Same pattern at α+β = 0.95 (0.3, 0.65), φ₁ = 0: 81.4 → 77.2 → 72.9 → **68.6**. At α+β = 0.99 (0.2, 0.79): 84.1 → 80.6 → 76.4 → 72.2. At the near-IGARCH but low-α setting (0.05, 0.94) the i.i.d. bootstrap is nearly fine (88.6 → 88.7 → 87.9 → 87.4), i.e. the damage is driven by α, not by α+β.

**t₅-GARCH is worse** (Table 3): φ₁ = 0, α+β = 0.5, n = 400 → recursive i.i.d. **61.2** (vs rWB 89.3, fWB 87.7, pairwise 90.5, robust-SE Gaussian 85.9). At α+β = 0.95, n = 400: **64.6**. Paper: "the accuracy of the recursive-design i.i.d. bootstrap tends to be even lower than for N-GARCH processes."

**Asymmetric GARCH (Table 4), φ₁ = 0, n = 400, recursive i.i.d.:** EGARCH **63.8**, AGARCH **62.0**, GJR-GARCH **64.1**, SV(0.936, 0.424) **69.3** — against robust WB/pairwise values of 89–90 in every one of those cells.

### 6.2 The three robust methods all work, with a clear ranking

Representative full rows.

*Table 2, N-GARCH, n = 50, φ₁ = 0, i.i.d. errors (α=β=0):* rec. i.i.d. 89.1 | **rec. WB 90.1** | fixed WB 89.0 | pairwise 88.9 | robust-SE Gaussian 86.0.
→ The recursive WB **costs nothing** when the errors really are i.i.d.

*Table 2, n = 50, φ₁ = 0.9, i.i.d. errors:* rec. i.i.d. 83.9 | rec. WB 83.2 | fixed WB 78.7 | pairwise 79.7 | robust SE **76.0**.
*Table 2, n = 50, φ₁ = 0.9, α+β = 0.5:* rec. i.i.d. 80.4 | **rec. WB 84.4** | fixed WB 80.5 | pairwise 82.0 | robust SE 76.6.
→ Persistence (φ₁ = 0.9) plus small n is where **everything** undercovers; the recursive WB degrades least. At n = 400, φ₁ = 0.9, α+β = 0.95: rec. i.i.d. 76.2 | rec. WB 89.5 | fixed WB 88.8 | pairwise 89.5 | robust SE 88.2.

*Table 4(a) EGARCH, φ₁ = 0.9:* n = 50 → rec. i.i.d. 79.5, rec. WB 84.6, fixed WB 81.2, pairwise 82.3, robust 77.4; n = 400 → 74.5 / 89.3 / 88.3 / 89.4 / 88.2.
*Table 4(d) SV (0.936, 0.424), φ₁ = 0.9, n = 400:* 76.4 / 89.7 / 89.0 / 89.4 / 88.8.

**Summary ranking as the paper states it:**
1. Under conditional heteroskedasticity, all three robust methods beat both the i.i.d. bootstrap and the Gaussian robust-SE approximation.
2. **For persistent processes the recursive WB beats the pairwise bootstrap**; the gap vanishes for large n, where they are "about equally accurate."
3. **The fixed-design WB is typically the least accurate of the three**, "although the discrepancies diminish for large n"; "Even for moderate sample sizes the accuracy of the pairwise bootstrap is slightly higher than that of the fixed-design bootstrap."
4. For n ≥ 100, the robust-SE Gaussian approximation beats the recursive i.i.d. bootstrap under N-GARCH but is worse under truly i.i.d. errors; "In either case, the coverage rates may be substantially below the nominal level."
5. The recursive WB is accurate for **EGARCH, AGARCH and GJR-GARCH even though A′(iv′) fails for them**: *"The high accuracy of the recursive-design WB even for EGARCH, AGARCH and GJR-GARCH error processes is **surprising, given its lack of theoretical support** for these DGPs. Apparently, the failure of the sufficient conditions for the asymptotic validity of the recursive-design WB method has little effect on its performance in small samples."*

### 6.3 Multiplier-distribution sensitivity (Table 5, recursive WB, N-GARCH)

Selected cells, format N(0,1) / Mammen / Liu:
| n | φ₁ | α+β (α, β) | N(0,1) | Mammen | Liu |
|---|---|---|---|---|---|
| 50 | 0 | 0 (0,0) | 90.1 | 89.2 | 88.9 |
| 50 | 0 | 0.5 (0.5,0) | 88.9 | 88.9 | 88.6 |
| 50 | 0.9 | 0 (0,0) | 83.2 | 83.8 | **84.3** |
| 50 | 0.9 | 0.5 (0.5,0) | 84.4 | 85.2 | **85.4** |
| 100 | 0.9 | 0.5 (0.5,0) | 87.8 | 87.9 | 88.1 |
| 200 | 0.9 | 0.5 (0.5,0) | 88.6 | 89.5 | **89.7** |
| 400 | 0 | 0 (0,0) | **90.8** | 90.4 | 90.1 |
| 400 | 0.9 | 0.5 (0.5,0) | 89.3 | **90.2** | **90.2** |

Spread across the three multipliers is at most ≈ 1.2 percentage points in any cell. Where there *is* a tilt: at φ₁ = 0 the normal is marginally best; at φ₁ = 0.9 (the persistent, empirically relevant case) **Liu/Rademacher and Mammen are marginally better than N(0,1)** at almost every n. Paper's own verdict is that none dominates.

## 7. Contributions

Stated and demonstrated:
1. **Theorem 3.1** — asymptotic normality of the OLS AR estimator under Assumption A, a **weaker** condition than Kuersteiner (2001) (no strict stationarity/ergodicity, no fourth-cumulant summability).
2. **Theorem 3.3** — first-order validity of Kreiss's (1997) **fixed-design WB** generalized from Kreiss's specific σ(y_{t−1})v_t heteroskedasticity to **m.d.s. errors with conditional heteroskedasticity of unknown form**, covering N-GARCH, t-GARCH, asymmetric GARCH and stochastic volatility.
3. **Theorem 3.2** — first-order validity of the **recursive-design WB** (Kreiss's "modified wild bootstrap"), which Kreiss proposed but never proved consistent under conditional heteroskedasticity. Requires the strengthened A′.
4. **Theorem 3.4** — first-order validity of the **pairwise bootstrap** (Freedman, 1981) extended from cross-sections to autoregressions.
5. **Corollary 3.1** — validity of the studentized/percentile-t versions of all three.
6. **A constructive diagnosis of why the i.i.d. residual bootstrap fails** (fourth-order cumulants; it implicitly imposes τ_{i,i}=1, τ_{i,j}=0).
7. **Monte Carlo evidence** that the robust bootstraps beat both the i.i.d. bootstrap and Gaussian robust-SE asymptotics in samples of applied size.
8. Empirical documentation (Table 1) that **monthly U.S. macro** series — not just finance data — reject no-ARCH in AR residuals.

Differences from prior WB literature, as the paper itself lists them: prior work (Wu 1986; Liu 1988; Mammen 1993; Davidson & Flachaire 2001) was (a) about the **classical static linear regression model**, (b) about **unconditional heteroskedasticity in cross-sections** rather than **conditional heteroskedasticity in time series**, and (c) largely about models **restricted under a null hypothesis**, whereas this paper builds **confidence intervals from unrestricted regressions**.

Bottom-line recommendation (abstract + §5): *"in many empirical applications the proposed robust bootstrap procedures should routinely replace conventional bootstrap procedures for autoregressions based on the i.i.d. error assumption"*; and *"no single bootstrap method … will be optimal in all cases. The recursive-design WB seems best suited for applications in empirical macroeconomics … When the sample size is at least moderately large and asymmetric forms of GARCH are a practical concern, the pairwise bootstrap method provides a suitable alternative. The fixed-design WB has the same theoretical justification as the pairwise bootstrap for parametric models, but appears to be less accurate in practice."*

Extensions flagged as future work: AR(∞) / infinite-order (already done in Gonçalves & Kilian, 2003, CIRANO WP 2003-s28); recursive WB for **I(1)** autoregressions written in zero-mean stationary regressors, generalizing Inoue & Kilian (2002); a robust version of Hansen's (1999) grid bootstrap.

## 8. Replication feasibility

**High for the simulations; the empirical table is partially under-specified.**

Sufficient to replicate:
- All three bootstrap algorithms are given in closed form (y*_t recursions, ε̂*_t = ε̂_t η_t, the pairwise tuple resampling, the estimators).
- All DGP parameter values are printed: GARCH grids (α, β), the exact EGARCH / AGARCH / GJR coefficients, the two SV (λ, σ_u) pairs, φ₁ ∈ {0, 0.9}, n ∈ {50,100,200,400}, 10,000 trials, 999 bootstrap replications.
- The variance estimator is named and written out (Nicholls–Pagan / Eicker–White).
- The interval construction (symmetric percentile-t at 90%) is written out.
- Multiplier distributions are fully specified, including Mammen's probability p.
- Start-up value handling for the recursive designs is specified (resample from the original data).

Gaps / friction:
- **No random seeds, no software, no code availability statement** anywhere in the paper.
- ω in the GARCH(1,1) is not printed directly; it is pinned only implicitly by "We normalize the unconditional variance of ε_t to one" (⇒ ω = 1 − α − β), which is unambiguous but requires the reader to derive it.
- The t₅ innovations are "suitably normalized to have unit variance" — again derivable (divide by √(5/3)) but not printed.
- The lag order p is assumed **finite and known** throughout; the empirical Table 1 instead selects lags by AIC — a mismatch between theory and the motivating exercise that the paper does not reconcile.
- Table 1 cannot be fully reproduced from this extraction (missing rows and column headers, see the OCR flags above), though it could be reproduced from FRED given the stated series/sample/AIC rule.
- The appendix proofs are complete enough to check; several rely on external results (Andrews 1988; Brockwell–Davis Prop. 6.3.9; White 1999 p.133; Bühlmann 1995 Lemma 2.2).

**Transfer caveats for a proxy-SVAR-inside-a-DFM application.** Stated in the paper, and load-bearing:
- Everything proved here is for a **univariate, stationary, finite-and-known-order AR(p)** estimated by OLS. *"For expository purposes we focus on univariate autoregressive models. **Analogous results for the multivariate case are possible at the cost of additional notation.**"* — an assertion, **not a theorem**.
- Validity is proved for **φ and for the studentized φ_j**. Impulse responses are covered only via the intro's parenthetical "(and smooth functions thereof)"; there is **no separate impulse-response theorem**, and no result for an **external-instrument/proxy** identification step, which is outside the paper entirely.
- **Stationarity is required** (all roots outside the unit circle; ε_t covariance stationary). The I(1) case is explicitly listed as *unresolved future work*. A non-stationary factor panel is outside the proved envelope.
- If the recursive-design WB is what is being used (the standard choice in SVAR practice), the binding extra conditions are **A′(iv′)** (symmetric-type conditional heteroskedasticity, τ_{r,s} = 0 for r≠s — asymmetric EGARCH-type dynamics excluded) and **A′(vi′)** (**eight moments**). The Monte Carlo suggests the A′(iv′) failure is benign in finite samples, but that is simulation evidence, not theory.
