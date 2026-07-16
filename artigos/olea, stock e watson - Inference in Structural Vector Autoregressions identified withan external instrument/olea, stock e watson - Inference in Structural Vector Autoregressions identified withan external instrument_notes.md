# Reading notes — Montiel Olea, Stock & Watson, "Inference in SVARs Identified With an External Instrument"

## Bibliographic metadata

- **Authors:** José L. Montiel Olea (Dept. of Economics, Columbia University); James H. Stock (Dept. of Economics, Harvard University; NBER); Mark W. Watson (Dept. of Economics and Woodrow Wilson School, Princeton University; NBER).
- **Title:** "Inference in Structural Vector Autoregressions identified with an external instrument".
- **Journal:** *Journal of Econometrics* (Elsevier).
- **DOI:** 10.1016/j.jeconom.2020.05.014 (confirmed in the chunk text and reference-hub links `S0304-4076(20)30231-1`).
- **Dates in chunk:** Received 21 April 2020; revised 21 April 2020; accepted 2 May 2020; "available online xxxx". Copyright © 2020 Elsevier B.V.
- **Year:** The chunk is the accepted/uncorrected-proof version — its running head reads "Journal of Econometrics xxx (xxxx) xxx", so **volume / issue / page numbers are NOT stated in these chunks.**
- **Published reference (from external knowledge, NOT in the chunk — flag before quoting as final):** *Journal of Econometrics*, **Vol. 225, Issue 1 (November 2021), pp. 74–87**. The commonly cited year is **2021** (online-first 2020). Verify volume/issue/pages against the publisher record before finalizing a citation.
- **Keywords:** Narrative approach; Instrumental variables; Weak identification; Impulse response functions.
- **Replication code:** MATLAB suite `SVARIV` at https://github.com/jm4474/SVARIV.

---

## 1. Research question

How should one conduct valid inference on structural impulse response functions (IRFs) in an SVAR when the identifying **external instrument may be weak** (only weakly correlated with the target structural shock)? Standard delta-method / bootstrap (GMM) inference — as in Mertens & Ravn (2013) — is unreliable under weak instruments, exactly as in microeconometric IV. The paper builds weak-instrument-**robust** confidence sets for IRF coefficients that (i) remain valid regardless of instrument strength, and (ii) asymptotically coincide with the standard confidence set when the instrument is strong (just-identified case).

---

## 2. The SVAR-IV / proxy-SVAR framework

### Model (Section 2.1)
- Stationary finite-order SVAR: `Y_t = A_1 Y_{t-1} + ... + A_p Y_{t-p} + η_t`, with `Y_t` n×1 and reduced-form innovations `η_t`.
- Structural link: `η_t = Θ_0 ε_t`, `Θ_0` nonsingular n×n (invertibility assumed). Structural shocks serially and mutually uncorrelated, `E[ε_t ε_t'] = D = diag(σ_1²,...,σ_n²)`, so `Σ = E(η_t η_t') = Θ_0 D Θ_0'`.
- Structural MA: `Y_t = Σ_k C_k(A) Θ_0 ε_{t-k}`; IRF coefficient `∂Y_{i,t+k}/∂ε_{1,t} = e_i' C_k(A) Θ_0 e_1`.
- **Target shock** ordered first (WLOG) = `ε_{1,t}`; IRFs governed by the **first column** `Θ_{0,1} = Θ_0 e_1`.
- **Scale (unit-effect) normalization:** normalize so the target shock has a one-unit contemporaneous effect on a pre-specified variable `Y_{i*}` (ordered i*=1), i.e. `Θ_{0,11} = 1`. (In the illustration: an oil-supply shock that raises oil production 1% on impact.)

### External instrument (Assumption 1, Section 2.2) — THE VALIDITY CONDITIONS
Scalar instrument (or "proxy") `z_t` satisfying:
- **(A1.1) Relevance:** `E[z_t ε_{1,t}] = α ≠ 0` — instrument is correlated with the target shock.
- **(A1.2) Exogeneity:** `E[z_t ε_{j,t}] = 0 for j ≠ 1` — instrument is uncorrelated with all other structural shocks.
This is the SVAR analogue of the standard IV definition. The paper shows it maps to the conventional IV setup: parameter of interest `Θ_{0,21}` obtained from IV regression of outcome `Y_{2,t}` on the normalizing variable `Y_{1,t}` (controlling for lags of `Y_t`), using `z_t` as instrument — valid because `z_t` correlates with the endogenous regressor `Y_{1,t}` (A1.1) and is uncorrelated with the error `ε_{2,t}` (A1.2).
- Terminology note: "external instrument" (from Stock 2008 "natural experiment approach") = "proxy variable" in some literature. Precursor: Romer & Romer (1989) narrative approach.

### Projection / estimator for the impact vector (Section 2.2)
- `Θ_{0,1}` is identified **up to scale** by the covariance of `z_t` with reduced-form innovations:
  `Γ ≡ E(z_t η_t) = E(z_t Θ_0 ε_t) = α Θ_{0,1}` (Eq. 2.7).
- Under the normalization `Θ_{0,11}=1`, `Γ_{1,1} = α`, so **`Θ_{0,1} = Γ / Γ_{1,1} = Γ / (e_1'Γ)`** (Eq. 2.8).
- IRF: **`λ_{k,i} = e_i' C_k(A) Γ / (e_1' Γ)`** (Eq. 2.9) — a **ratio**; the denominator `e_1'Γ = α` is what drives weak-instrument problems.
- The instrument also recovers the shock itself: `Proj(z_t | η_t) = Γ' Σ^{-1} η_t = (α/σ_1²) ε_{1,t}` (Eq. 2.10). Dividing by `(Γ'Σ^{-1}Γ)^{1/2}` gives `ε_{1,t}/σ_1` up to sign. Historical decomposition (2.11) and forecast-error variance decomposition FEVD (2.12) also derived as functions of `(A, Σ, Γ)`.

### Plug-in estimator (Section 3.1)
`λ̂_{k,i}(Â_T, Γ̂_T) = e_i' C_k(Â_T) Γ̂_T / (e_1' Γ̂_T)` (Eq. 3.1), where `Â_T` = LS VAR estimator and `Γ̂_T = S_{zη̂}` = sample covariance of `z_t` with VAR residuals.

---

## 3. The weak-instrument problem and proposed inference

### Strong-instrument (standard) asymptotics — Section 3.1
When `z_t` is strong (`Γ_T = Γ ≠ 0`), Assumption 2 (joint asymptotic normality of `√T[vec(Â−A)', (Γ̂−Γ)', vech(Σ̂−Σ)']' ⇒ N(0,W)`) plus the **δ-method** give `√T(λ̂ − λ) ≈ N(0, σ²_{k,i})`. The usual Wald/χ²₁ **plug-in confidence set** `CS^{Plug-in}` (Eq. 3.2) is then valid. Standard delta-method OR bootstrap intervals are fine.

### Weak-instrument asymptotics — Section 3.2 (THE PROBLEM)
- Model the weakness via Staiger–Stock (1997) drifting sequence: `E(z_t ε_{1,t}) = α_T`, with `α_T = a/√T` (α→0 allowed), `Γ_T = α_T Θ_{0,1}`.
- The plug-in estimator then converges to a **ratio of correlated normals** (Eq. 3.4):
  `λ̂_{k,i} ⇒ λ_{k,i} + δ'_{k,i} ξ / (e_1' ξ + a Θ_{0,11})`,
  the SVAR analogue of Staiger–Stock's just-identified IV representation. `(a Θ_{0,11})² / Var(e_i'ξ)` is the **concentration parameter** analogue.
- Consequences: plug-in estimator is **inconsistent**, the Wald test does **not** have correct size, and `CS^{Plug-in}` does **not** have correct coverage.
- **Bias direction:** the weak-instrument IV estimator is biased toward the probability limit of the **Cholesky decomposition** IRF with the shock of interest ordered first (i.e. toward the OLS estimator of `η̂_{j,t}=Θ_{0,1}η̂_{1,t}+u_t`). → **Caution:** near-coincidence of Cholesky and external-instrument IRF estimates is NOT evidence for the Cholesky ordering unless instrument strength is also verified.
- FEVDs and historical decompositions are ratios of **quadratic** functions of Γ, so their δ-method/bootstrap inference is **also not robust** to weak instruments (Section 3.3) — and, unlike IRFs, the AR fix does not extend to them (Γ enters quadratically, not linearly).

### Weak-instrument-robust confidence sets — Section 4 (THE SOLUTION)
- Built from **Fieller (1944)** confidence intervals for a ratio of normal means and the **Anderson–Rubin (1949)** IV confidence set. Since `λ_{k,i}=H_{T,1}/H_{T,2}` with `H_T = [e_i'C_k(A)Γ_T ; e_1'Γ_T]` (Eq. 4.1) — a ratio of two asymptotically normal quantities — testing `λ_{k,i}=λ_0` is a linear restriction `H_{T,1}-λ_0 H_{T,2}=0`.
- Wald statistic `q_T(λ_0)` (Eq. 4.2) inverted to give **`CS^{AR} = {λ : q_T(λ) ≤ χ²_{1,1-a}}`** (Eq. 4.3).
- **Proposition 1 (weak-instrument validity):** under Assumptions 1–2, `α_T→α` (may be 0), `Ω̂_T →ᵖ Ω≠0`, `CS^{AR}` has asymptotic coverage exactly `1−a` **for any instrument strength, including α=0**.
- **Proposition 2 (strong-instrument equivalence):** when `α_T→α≠0` (just-identified), `√T · d_H(CS^{AR}, CS^{Plug-in}) →ᵖ 0` (Hausdorff distance → 0), and the two tests have the **same local power**. → **No cost** to using the robust set when the instrument is strong.
- AR-set geometry (footnote 13): can be a bounded interval, the whole real line, or a union of two half-lines; if the first-stage is too weak (`μ_Y=0` not rejected) the set is the entire real line — the honest reflection of non-identification.

### First-stage F, effective F, and the ~10 threshold — Section 4.2 (DIAGNOSTICS)
- Instrument is weak if `α = E(z_t ε_{1,t})` is small relative to sampling error in `α̂_T`.
- **Recommended diagnostic:** the **heteroskedasticity-robust first-stage F statistic** from regressing the normalizing variable `Y_{1,t}` on `z_t` (with VAR lags of `Y_t` as controls). Compare to **Stock & Yogo (2005) critical values or the rule of thumb F > 10.**
- With **multiple instruments + heteroskedasticity**, use the **Montiel Olea & Pflueger (2013) effective first-stage F** (per Andrews, Stock & Sun 2018).
- Alternative diagnostic: since `α = Γ_{1,1}` under normalization, the Wald statistic `ξ_1 = T Γ̂²_{T,1}/Ŵ_{Γ,11}` measures strength; it shares the same noncentrality parameter as the robust first-stage F but tends to be **smaller in finite samples**. Key property: the `100(1−a)%` AR set is a **bounded interval iff `ξ_1 > χ²_{1,1-a}`** (e.g. > 3.84 at 5%).
- **Pre-testing caveat (footnote 6 & Section 4.2):** *screening* on the first-stage F and then pretending standard bands are correct **induces size distortions** (Andrews, Stock & Sun 2018, §4.1). The recommendation is to report F AND routinely use `CS^{AR}` — not to condition on F.

### Extensions (Section 4.3)
- **Overidentification (M>1 instruments):** AR set extends via stacked `s_T(λ)'Ŵ_T(λ)^{-1}s_T(λ) ≤ χ²_{M,1-a}`; valid under weak/strong instruments but **inefficient vs standard sets when strong**. LM and Quasi-CLR tests also applicable (Appendix A.3.2).
- **r instruments / r shocks (Appendix A.6):** r instruments + r(r+1)/2 restrictions identify; full contemporaneous-response vector via Stock–Wright (2000) S-test; a proposed AR extension (focus r=2, Mertens–Ravn zero restriction) alleviates projection conservativeness.
- Weak-robust inference for FEVDs / historical decompositions left as open research.

---

## 4. Illustrative application (Section 5) — OIL, not the monetary example

- **NB for the parent process:** the *empirical illustration in the main text is Kilian's (2009) 3-variable OIL-market SVAR, not Gertler–Karadi monetary.** Gertler & Karadi (2015) appears only in the **reference list** as a canonical external-instrument application (Amer. Econ. J.: Macroecon. 7, 44–76) — it is cited as motivation, not estimated here. A second illustration (tax cuts → GDP, Mertens–Montiel Olea style) is in Appendix A.7.
- **Model/data:** Kilian's (2009) SVAR in (percent change in global crude oil production, real oil price, global real-activity index); monthly 1973:M1–2007:M12, instrument (Kilian 2008 "exogenous oil supply shocks" = OPEC production shortfalls from wars/civil unrest) available 1973:M1–2004:M9; common sample used. **p = 24 lags** + constant; W via Eicker–White (Newey–West HAC, 0 lags). δ-method and a normal-resampling bootstrap both implemented (MATLAB suite).
- **Weak-instrument diagnostics in the application:** `ξ_1 = 4.4` and robust **first-stage F = 9.4** — **both below the Staiger–Stock value of 10 → instrument judged weak.** But `ξ_1 = 4.4 > 3.84`, so the **95% AR sets are bounded intervals.**

### Findings (Section 5–6)
- **68%** weak-robust `CS^{AR}` intervals **essentially coincide** with the strong-instrument `CS^{Plug-in}`; but the **95% `CS^{AR}` show substantially more uncertainty** than the plug-in sets — the weak-instrument correction bites in the tails.
- Economics: external-instrument-identified oil-supply shock → oil price falls 0.14% on impact, max −0.22% at 4 months, vs Cholesky's −0.03% impact / −0.07% max. External-IV effects are **larger** than Cholesky, but both are **small in absolute terms** — Kilian's "small price effects" conclusion survives even under weak-robust inference.
- **Monte Carlo (Section 6):** DGP calibrated to Kilian, T=356, `Θ_{0,1} ∝ b/√(b'Σ^{-1}b)` with b=(1,1,−1)'; instrument `z_t = μ_Z + α ε_{1,t} + σ_Z ν_t`; concentration parameter set to **3.7** and **10.09**. Results: nominal-95% `CS^{Plug-in}` coverage falls as low as **85%** at some horizons when the concentration parameter is small; `CS^{AR}` coverage is **never below 90%** (small distortion from large-sample critical values). Plug-in coverage improves as concentration parameter rises; at T=1500 `CS^{AR}` coverage ≈ nominal. Bootstrap AR gives only a slight further improvement — **the gain comes from choosing a weak-robust procedure, not from the bootstrap critical values.**

---

## 5. Contributions / conclusions (Section 7)

1. Formalizes SVAR-IV identification (IRFs, shock series, historical & variance decompositions) as smooth functions of reduced-form parameters `(A, Σ, Γ)`, and shows their large-sample distribution **depends on instrument strength**.
2. Shows standard (Wald / δ-method / bootstrap) inference is **valid only when the instrument is strong**; under weak instruments the plug-in IRF estimator is biased **toward the Cholesky (shock-ordered-first) IRF** and Wald sets under-cover.
3. Proposes **Fieller/Anderson–Rubin weak-instrument-robust confidence sets for IRF coefficients** that are valid for any instrument strength and **asymptotically equal the standard set when the instrument is strong and the model is just-identified** (Propositions 1 & 2) — so they "should routinely be used".
4. **Practitioner recommendation:** always report either the Wald statistic for instrument irrelevance (`ξ_1`) or the **heteroskedasticity-robust first-stage F** (Section 4.2); large values (**e.g. above 10**) suggest standard 95% intervals are approximately valid — but pair this with the robust `CS^{AR}` rather than pre-screening on F.
5. Extends to overidentified and r-shock/r-instrument cases (Appendices A.3.2, A.6); provides open MATLAB implementation.

---

## Quick-reference equations
- Relevance/exogeneity: (A1.1) `E[z_t ε_{1,t}]=α≠0`; (A1.2) `E[z_t ε_{j,t}]=0, j≠1`.
- Instrument–innovation covariance: `Γ = E(z_t η_t) = α Θ_{0,1}` (2.7); impact vector `Θ_{0,1}=Γ/(e_1'Γ)` (2.8).
- IRF: `λ_{k,i}=e_i'C_k(A)Γ/(e_1'Γ)` (2.9); plug-in (3.1).
- Weak-IV limit: `λ̂ ⇒ λ + δ'ξ/(e_1'ξ + aΘ_{0,11})` (3.4).
- AR set: `CS^{AR}={λ: q_T(λ) ≤ χ²_{1,1-a}}` (4.3); bounded iff `ξ_1 > χ²_{1,1-a}`.
- Diagnostic: het-robust first-stage F (rule of thumb F>10, Stock–Yogo); effective F (Montiel Olea–Pflueger 2013) with multiple instruments.
