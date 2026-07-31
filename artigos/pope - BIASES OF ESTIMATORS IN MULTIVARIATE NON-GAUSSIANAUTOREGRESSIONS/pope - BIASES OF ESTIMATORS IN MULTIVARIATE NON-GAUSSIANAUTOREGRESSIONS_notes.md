# Pope (1990) — Biases of Estimators in Multivariate Non-Gaussian Autoregressions

Structured extract produced under the `split-pdf-md` Agent Isolation Protocol.
Source chunk: `pope - BIASES OF ESTIMATORS IN MULTIVARIATE NON-GAUSSIANAUTOREGRESSIONS_build/chunks_.../chunk_01_biases_of_estimators_in_multivariate_non.md` (single chunk, full paper, ~3,200 words).

---

## Bibliographic metadata

| Field | Value | Source in text |
|---|---|---|
| Title | BIASES OF ESTIMATORS IN MULTIVARIATE NON-GAUSSIAN AUTOREGRESSIONS | title line |
| Author | Alun Lloyd Pope ("By Alun Lloyd Pope") | byline |
| Affiliation | University of Newcastle, Australia | byline |
| Journal | JOURNAL OF TIME SERIES ANALYSIS | publisher footer on p. 249 |
| Volume / issue | Vol. 11, No. 3 | same footer |
| Year | 1990 (© 1990 A. L. Pope; Wiley stamp "14679892, 1990, 3") | footer + download stamp |
| Pages | **249–258 (inferred, not stated as a range)** — the footer code is `0143-9782/90/03 249-10 $02.50/0`, i.e. first page 249, 10 pages | inference, flagged |
| Received | "First version received January 1989" | header |
| ISSN | 0143-9782 (print), 1467-9892 (from the Wiley stamp) | footer / stamp |
| DOI | 10.1111/j.1467-9892.1990.tb00056.x — **from the Wiley download watermark, whose OCR renders it as `10.1111/j.14679892.1990.tb00056x`**; the dots/hyphen are OCR loss, so the DOI is reconstructed, not literally stated | flagged |
| Keywords | Autoregressive models; bias; least-squares estimation; modified Yule-Walker estimation | keyword line |
| Acknowledgement | "The author is grateful to a referee for helpful comments regarding Theorem 1." | §1 |

**Not stated anywhere in the text:** abstract-level page range, editor, funding, data availability, code availability, any e-mail/correspondence address. There is no appendix and no supplementary material.

---

## 1. Research question

Can the small-sample bias of the standard estimators of a **correctly specified multivariate autoregression of arbitrary order** be characterized **without assuming Gaussian innovations**, and with a stated asymptotic order for the approximation error?

Framing in §1 (verbatim): "Consider the problem of fitting an autoregressive model to a small number of observations from a time series when the distributional form of the innovations is unknown. Under these circumstances the maximum likelihood estimator is unavailable and we might well proceed with either the least-squares or the Yule-Walker estimator. It is well known that both these estimators have a bias which can be appreciable in small samples."

Two sub-questions:
1. What is the O(n⁻¹) bias term of the mean-corrected least-squares estimator of an m-dimensional AR(1) (hence, via companion form, of any AR(p))?
2. How does that bias relate to the modified Yule-Walker estimator of Tjøstheim–Paulsen and to the Box–Jenkins version of least squares?

Prior state of the art, per §1: Tjøstheim and Paulsen (1983) obtained the least-squares bias **assuming i.i.d. Gaussian innovations** and **did not estimate the order of the error**; Pope (1987) and Nicholls and Pope (1988) independently obtained an equivalent expression under the same Gaussian assumptions **and** estimated the asymptotic order of the error. This paper relaxes Gaussianity.

## 2. Audience

Theoretical time-series statisticians and econometricians. The paper is a self-contained mathematical-statistics note: theorem–proof throughout, no applied illustration, no simulation, no data. Practitioner relevance is stated only implicitly ("it is desirable to have estimates of the biases of these estimators available when the distribution of the observations is not Gaussian (even unknown) and the sample size is not large"). It is the theoretical source that downstream applied work — e.g. Kilian's (1998) bootstrap-after-bootstrap bias correction for VAR impulse responses — cites for the analytical bias term.

## 3. Method

Purely analytical. Structure of the argument:

1. **§2 — a general Taylor-series expansion (Theorem 1)** for the expectation of an estimator of the form `PQ⁻¹` with random matrices P and Q, with **explicit error bounds**. The paper states this is new: "no example of such a Taylor expansion giving precise error bounds under circumstances relevant to this problem seems to be available in the literature."
2. **§3 — application to the least-squares estimator** of the m-dimensional AR(1) (Theorem 2), the main result.
3. **§4 — application to two related estimators**: the modified Yule-Walker estimator (Theorem 3) and the Box–Jenkins least-squares estimator, obtained cheaply as O(n^{-3/2}) differences from the §3 result.

### Model and estimator (verbatim setup)

The **AR(p)-to-AR(1) reduction is explicit and is the companion-form step**:

> "The multivariate AR(p) offers no greater generality than the multivariate AR(1), since an AR(p) of dimension d can be reformulated as an AR(1) of dimension dp. Thus we consider only the m-dimensional AR(1)"

$$X_t = A X_{t-1} + Z_t \tag{5}$$

with `X_t`, `Z_t` of dimension m × 1 and `A` of dimension m × m. **So in a VAR(p) of dimension d, `A` in every formula below is the dp × dp companion matrix, `m = dp`, `G` is the (singular) companion-form innovation covariance, and `Γ(0)` is the companion-form covariance matrix.**

Stationarity: `||A|| < 1` is assumed, to guarantee the MA(∞) representation `X_t = Σ_{k≥0} A^k Z_{t−k}`. The norm is defined explicitly: "By the norm ||M|| of the real square matrix M, we mean the operator norm (equal to the square root of the largest eigenvalue of MᵀM)."

Mean correction: "We always consider what is often called the mean-corrected version of the least-squares estimator. Thus there is no loss of generality in considering only models which have mean zero, because the estimators described below are invariant under translation of the sample by a constant."

With `X̄_n` the sample mean and `U_t = X_t − X̄_n`, the least-squares estimator is

$$\hat A_n = C_n(-1) C_n(0)^{-1} \tag{6}$$
$$C_n(s) = \frac{1}{n-1}\sum_{i=1}^{n-1} U_{i-s} U_i^{\mathrm T},\qquad s\in\{0,-1\} \tag{7}$$
$$\Gamma(j) = E X_t X_{t+j}^{\mathrm T} \tag{8}$$

Mean-correction variants are explicitly reconciled: Tjøstheim–Paulsen's least-squares estimator "has a different mean correction… in expectation this makes a difference which is only O(n⁻²)"; Box–Jenkins (1976, p. 277) differ again, with the `C_n(0)` summation running from 2 to n−1.

## 4. Data

**None.** No dataset, no empirical application, no Monte Carlo experiment, no numerical table or figure anywhere in the paper. Everything is theorem and proof. (Explicitly flagging this: the paper offers *no* finite-sample simulation evidence on how good the O(n⁻¹) approximation is at realistic n — a user of the formula must look elsewhere, e.g. to the applied literature that adopted it.)

## 5. Statistical / numerical methods

### 5.1 Theorem 1 (the Taylor expansion with error bounds)

Let `Δ̂_n`, `δ_n`, `ρ_n` be random m × m matrices with

$$\hat\Delta_n = (\Delta_n + \delta_n)(I - \rho_n)^{-1}$$

`Δ_n` a deterministic sequence bounded in norm, `I` the m × m identity. Let `σ_n` be a sequence of m × m matrices such that, as n → ∞,

- (i) `E δ_n = −σ_n + O(n⁻²)`
- (ii) `E ρ_n = σ_n + O(n⁻²)`
- (iii) `E||δ_n³||` and `E||ρ_n³||` are both `O(n^{-3/2})`
- (iv) for some ε > 0, `E||Δ̂_n − Δ_n||^{1+ε} = O(1)`

Then

$$E\hat\Delta_n = \Delta_n - (I - \Delta_n)\sigma_n + E\delta_n\rho_n + \Delta_n E\rho_n^2 + O(n^{-3/2}) \tag{1}$$

Proof technique: split on the event `S(n) = {||ρ_n|| < c}` for fixed `0 < c < 1`, geometric-series remainder `R_n`, then Hölder + Chebyshev–Markov to show both the truncated remainder and the indicator-complement term are `O(n^{-3/2})`.

### 5.2 Lemma 1 (moment bounds for the sample-covariance perturbations)

With
$$p_n = \{C_n(-1) - \Gamma(-1)\}\Gamma(0)^{-1} \tag{11}$$
$$q_n = -\{C_n(0) - \Gamma(0)\}\Gamma(0)^{-1} \tag{12}$$
so that
$$\hat A_n = (A + p_n)(I - q_n)^{-1} \tag{13}$$
and with `V_n = cov X̄_n`, `v_n = V_n Γ(0)^{-1}`, letting `w_n` denote `p_n` or `−q_n`:

- (i) `v_n = n^{-1} G (I − Aᵀ)^{-1} Γ(0)^{-1} + O(n⁻²)`  ← **see the flagged transcription problem below**
- (ii) `E w_n = −v_n + O(n⁻²)`
- (iii) `E||w_n||³ = O(n^{-3/2})`
- (iv) if `E||C_n(0)^{-1}||^{1+ε} = O(1)`, then `E||Â_n − A||^{1+ε} = O(1)`

Parts (i)–(ii) are attributed to Nicholls and Pope (1988). Part (iii) uses **Lemma 3.2 of Bhansali (1981)** to show the third-order cumulants of `C_n(−1)` and `C_n(0)` are `O(n⁻²)` — and the text is explicit that "(This relies on the fact that the sixth moments of the Z_t are finite.)" — plus **Lemma 3.3 of Bhansali (1981)** for `E||w_n||² = O(n⁻¹)`.

> **Verbatim-accuracy flag (likely OCR/typesetting loss in the source .md).** Lemma 1(i) as rendered is `v_n = n^{-1} G (I − Aᵀ)^{-1} Γ(0)^{-1} + O(n⁻²)`. This is **not** internally consistent with equation (9) via (14), and it is not `cov(X̄_n)Γ(0)^{-1}`. Univariate check (m = 1, A = a, G = σ², Γ(0) = σ²/(1−a²)): the true `cov(X̄_n)/γ₀ ≈ (1/n)(1+a)/(1−a)`, whereas the displayed expression yields `(1/n)(1+a)`. The internally consistent reading is
> `v_n = n^{-1} (I − A)^{-1} G (I − Aᵀ)^{-1} Γ(0)^{-1} + O(n⁻²)`,
> which makes `−(I − A)v_n` in (14) equal exactly the first term `−n^{-1} G (I − Aᵀ)^{-1} Γ(0)^{-1}` of `−b/n` in (9). Treat equation (9) as authoritative; treat Lemma 1(i) in this markdown rendering as missing a leading `(I − A)^{-1}`.

### 5.3 From Theorem 1 to the bias

Theorem 1 is applied with `A, p_n, q_n, v_n` in place of `Δ_n, δ_n, ρ_n, σ_n`, giving

$$B_n = -(I - A)v_n + E\{(p_n + A q_n)q_n\} + O(n^{-3/2}) \tag{14}$$

The remaining work is to compute `T = E{(p_n + A q_n)q_n}Γ(0)`, done "by an application of results of Hosoya and Taniguchi (1982)."

### 5.4 The spectral machinery (this is where non-Gaussianity would have entered)

Writing `h_{αβ}(j) = {C_n(j)}_{αβ}` and `L_{γδ}` for the γδ element of `Γ(0)^{-1}`, **Theorem 2.2 of Hosoya and Taniguchi (1982)** gives, neglecting terms O(n⁻²),

$$\operatorname{cov}\{h_{\alpha\beta}(j), h_{\gamma\lambda}(0)\} = \frac{2\pi}{n}\int_{-\pi}^{\pi}\{\overline{f_{\alpha\gamma}(\omega)}f_{\beta\lambda}(\omega) + \overline{f_{\alpha\lambda}(\omega)}f_{\beta\gamma}(\omega)\}\exp(-ij\omega)\,d\omega$$
$$+ \frac{2\pi}{n}\int\!\!\int \sum_{\beta_1\beta_2\beta_3\beta_4} \exp(-ij\omega_1)\, k_{\beta\beta_1}(\omega_1)k_{\alpha\beta_2}(-\omega_1)k_{\lambda\beta_3}(\omega_2)k_{\gamma\beta_4}(-\omega_2)\left(\tfrac{1}{2\pi}\right)^3 K(\beta_1,\beta_2,\beta_3,\beta_4)\,d\omega_1 d\omega_2 \tag{16}$$

with
$$k(\omega) = \{I - A\exp(i\omega)\}^{-1} \tag{17}$$
$$f(\omega) = \frac{1}{2\pi}k(\omega)Gk(\omega)^{*} \tag{18}$$

the asterisk denoting conjugation followed by transposition, and — **this is the non-Gaussianity carrier** — `K(β₁, β₂, β₃, β₄)` is "the fourth cumulant of the joint distribution of Z_{β₁}(t), …, Z_{β₄}(t)."

The first line of (16) is the Gaussian-type (second-order/spectral) term; the second line is the fourth-cumulant term, identically zero under Gaussianity. The paper notes that "The neglected terms in (16) arise from the mean correction, which is not employed by Hosoya and Taniguchi (1982)."

Notation `⟨⟨M⟩⟩ = M + (tr M)I` (19) is introduced to collapse summations into matrix products, giving `T_{μλ}` as a single integral plus a double integral (20).

**Evaluation of the single (spectral) integral** — the algebra in (21), with `B = Aᵀ`, yields
$$\frac{-G}{n}B^{-1}\sum_{\alpha\ge 0}B^{\alpha}\langle\langle B^{\alpha}\rangle\rangle$$
and then the matrix identity, for any `M` with `||M|| < 1`,
$$\sum_{\alpha\ge 0} M^{\alpha}\langle\langle M^{\alpha}\rangle\rangle = M^{2}(I - M^{2})^{-1} + \sum_{\lambda}\lambda M(I - \lambda M)^{-1}$$
(sum over the eigenvalues λ of M weighted by multiplicities) delivers the second and third terms of `b`.

**Evaluation of the double (fourth-cumulant) integral — it vanishes.** "Thus the proof will be complete when it is shown that the double integral in (20) reduces to zero." The chain of displays that follows reduces it to a factor
$$\int_{-\pi}^{\pi}\exp\{i(\alpha+1)\omega_1\}\,d\omega_1$$
summed over `α ≥ 0`, which is zero for every `α ≥ 0` (since `α + 1 ≥ 1 ≠ 0`). **The fourth-cumulant contribution therefore cancels exactly at order n⁻¹, for any innovation distribution satisfying the moment conditions.**

## 6. Findings

### 6.1 MAIN RESULT — Theorem 2 (the bias formula to record verbatim)

> **THEOREM 2.** Let `Â_n` be the least-squares estimator (6) of A in the m-dimensional AR(1) of (5), based on a sample of size n. Suppose that, for some ε > 0, `E||C_n(0)^{-1}||^{1+ε}` is bounded as n → ∞ and that the innovations `Z_t` in (5) are a martingale difference sequence such that all moments of `Z_t`, up to and including the sixth, conditional on the past, are finite and have values independent of t. Let G denote the conditional variance of `Z_t`, and suppose that `||A|| < 1`. Then, as n → ∞, the bias `B_n = E Â_n − A` is of the form

$$B_n = -\frac{b}{n} + \mathcal O(n^{-3/2})$$

> where b is given by

$$b = G\left[(I - A^{\mathsf T})^{-1} + A^{\mathsf T}\{I - (A^{\mathsf T})^{2}\}^{-1} + \sum \lambda (I - \lambda A^{\mathsf T})^{-1}\right]\Gamma(0)^{-1} \tag{9}$$

> "The sum is over the eigenvalues λ of A, weighted by their multiplicities."

**Every term, spelled out.** Three terms inside the bracket, pre-multiplied by `G` and post-multiplied by `Γ(0)^{-1}`:

| Term | Expression | Origin |
|---|---|---|
| 1 | `(I − Aᵀ)^{-1}` | the mean-correction / sample-mean term `−(I − A)v_n` in (14) |
| 2 | `Aᵀ{I − (Aᵀ)²}^{-1}` | the `M²(I − M²)^{-1}` piece of the (21) identity with `M = B = Aᵀ`, after the leading `B^{-1}` |
| 3 | `Σ_λ λ(I − λAᵀ)^{-1}` | the `Σ λM(I − λM)^{-1}` piece, after the leading `B^{-1}`; **λ ranges over the eigenvalues of A (which are also those of Aᵀ), counted with multiplicity — for a real VAR these are generally complex, and the sum is real because complex eigenvalues appear in conjugate pairs** |

Note the transposes: **the bracket is a function of `Aᵀ` only**, `G` sits on the left, `Γ(0)^{-1}` on the right. `Γ(0) = E X_t X_tᵀ` is the (companion-form) contemporaneous covariance, which also satisfies `Γ(j) = Σ_{k=-∞}^{∞} A(k) G A(k+j)ᵀ` (10) with `A(k) = A^k` for `k ≥ 0` and zero otherwise — i.e. `Γ(0)` is the solution of the discrete Lyapunov equation `Γ(0) = AΓ(0)Aᵀ + G`.

**Independent sanity check (mine, not the paper's).** Univariate specialization m = 1, A = a, G = σ², Γ(0) = σ²/(1−a²):
`b = σ²[1/(1−a) + a/(1−a²) + a/(1−a²)]·(1−a²)/σ² = (1+a) + a + a = 1 + 3a`, so `B_n = −(1+3a)/n`, the classical Marriott–Pope/Kendall mean-corrected AR(1) bias. Equation (9) as transcribed is therefore correct.

### 6.2 Order of the approximation

- **The bias itself is `O(n⁻¹)`**: §1, "it is shown below that under quite mild conditions these biases are O(n⁻¹) as the sample size n → ∞."
- **The error of the approximation `−b/n` is `O(n^{-3/2})`**, not merely `o(n⁻¹)`: abstract, "The errors in the expressions are shown to be O(n^{-3/2}), as the sample size n → ∞, under some moment conditions"; and §1, "Approximations to the biases are given with an error which is O(n^{-3/2})."
- Establishing this rate is itself a contribution: Tjøstheim and Paulsen (1983) did not estimate the order of the error.

### 6.3 Assumptions required (complete list)

1. **Correct specification** — the AR order is known and correct ("a correctly specified multivariate autoregression of arbitrary order"). No allowance for order misspecification.
2. **Stationarity via `||A|| < 1`** in the operator norm (√ of the largest eigenvalue of `MᵀM`). Note this is **stronger than the spectral-radius condition** ρ(A) < 1: it requires the largest singular value of A to be below 1. It guarantees the causal MA(∞) representation.
3. **Innovations `Z_t` form a martingale difference sequence** (Hall and Heyde, 1980, p. 182) **with constant variance matrix G** — *not* i.i.d., *not* Gaussian. This is the central relaxation.
4. **Conditional moments up to and including the sixth are finite and time-invariant**: "all moments of `Z_t`, up to and including the sixth, conditional on the past, are finite and have values independent of t." The abstract phrases this as "stationary up to sixth order and which has finite sixth moments." `G` is the *conditional* variance of `Z_t`.
5. **A uniform-integrability condition on the inverse sample second-moment matrix**: for some ε > 0, `E||C_n(0)^{-1}||^{1+ε}` is bounded as n → ∞.
6. **Mean-corrected estimator** (or, with obvious changes, known-mean); the specific mean correction (6)–(7) matters only at O(n⁻²) relative to Tjøstheim–Paulsen's.

On assumption 5 the paper is candid about the gap: "The condition that `E||C_n(0)^{-1}||^{1+ε}` be bounded as n → ∞ seems to be the weakest of its type that will work here… For the case of Gaussian innovations, Fuller and Hasza (1981) have established that the estimator is integrable for sufficiently large n. However, other integrability results do not appear to be available at the moment, and indeed it is difficult to see what would constitute natural alternative conditions which could be put on the distribution of the innovations to guarantee integrability and the stronger property of boundedness of the sequence of integrals." **So under non-Gaussianity this condition is assumed, not verified — it is the one primitive-level loose end in the paper.**

### 6.4 THE NON-GAUSSIAN RESULT (the headline for a bias-correction user)

**The bias expression does not depend on non-Gaussianity at order n⁻¹.** Three statements from the paper, verbatim:

- Abstract: "**The expressions obtained are the same in the Gaussian and non-Gaussian cases.**"
- §1: "In this paper these results are extended by relaxing considerably the restriction to Gaussian innovations. For both estimators the expression obtained for the bias is **the same for non-Gaussian innovations as for Gaussian innovations**."
- §4, on Theorem 3: "This agrees with the expression obtained by Tjøstheim and Paulsen (1983, Equation (4.4)). Their derivation, however, applies only to the case of Gaussian innovations, while the result above holds more generally, and in addition the error has been shown to be O(n^{-3/2})."

**Dependence on third and fourth moments, precisely:**

- **Fourth moments/cumulants: they appear in the derivation and then cancel exactly.** The fourth cumulant `K(β₁,β₂,β₃,β₄)` of the joint distribution of the innovation components enters the covariance of sample autocovariances through the second term of Hosoya–Taniguchi's (16), and propagates into the double integral of (20). The paper then shows that "the double integral in (20) reduces to zero", because the `ω₁` integral is `∫_{-π}^{π} exp{i(α+1)ω₁}dω₁ = 0` for every `α ≥ 0`. **Consequence: the O(1/n) bias term `b` is functionally independent of the fourth cumulants of the innovations — it depends on the innovation distribution only through the second moment `G`.** No excess-kurtosis correction is needed.
- **Third moments/skewness: they never enter the O(1/n) term at all.** No third-order cumulant of `Z_t` appears anywhere in `b`, in (16), or in (20). Third-order *cumulants of the sample autocovariances* `C_n(−1)`, `C_n(0)` do appear, but only inside Lemma 1(iii), where they are shown (via Bhansali 1981, Lemma 3.2) to be `O(n⁻²)`; they serve solely to verify hypothesis (iii) of Theorem 1, i.e. to bound the **remainder** at `O(n^{-3/2})`. They do not perturb the leading term.
- **Where the higher moments do bite: only in the remainder.** Finite **sixth** conditional moments are what buys the `O(n^{-3/2})` error rate ("This relies on the fact that the sixth moments of the `Z_t` are finite"). So non-Gaussianity affects the *quality of the approximation's error bound and its verifiability*, never the *form of the leading bias term*.
- **Net reading for practice:** the analytical bias `b` depends on `(A, G, Γ(0), eig(A))` alone. Skewness and kurtosis of the innovations are irrelevant to it to order n⁻¹. Applying Pope's formula to non-Gaussian macro/financial innovations is therefore *licensed by this paper*, provided the moment and stationarity conditions hold.

### 6.5 Multivariate vs. univariate

- The paper is written **directly in the m-dimensional case**; it does not derive a univariate result and then generalize, and it makes no claim that the multivariate bias behaves qualitatively differently from the univariate one. The result is the multivariate generalization of the classical univariate bias (which it reproduces on specialization, see §6.1 check).
- The one explicit statement relating dimensions and orders is the companion-form remark: "**The multivariate AR(p) offers no greater generality than the multivariate AR(1), since an AR(p) of dimension d can be reformulated as an AR(1) of dimension dp.** Thus we consider only the m-dimensional AR(1)." Formula (9) is thus stated for an AR(1) and is *intended* to be read in companion form for a VAR(p), with `m = dp`.
- **Caveat worth flagging for companion-form use:** the paper does not discuss the fact that in companion form `G` is singular (zero blocks below the first `d` rows) or that `Γ(0)` for the companion vector is the stacked autocovariance matrix; nor does it say anything about extracting the bias of the original `d × dp` coefficient block from `b`. Those are implementation details left to the reader. Likewise, nothing is said about deterministic terms beyond the mean (no trend case), and nothing about what to do when the bias-corrected `Â` leaves the stationary region — the stationarity-preserving adjustment that applied users associate with this formula is **not** in Pope.
- Also absent: any statement about the bias of estimated **impulse responses** or other nonlinear functions of `A`. Pope gives the bias of the coefficient matrix only.

### 6.6 Secondary results (§4)

**Modified Yule-Walker (Tjøstheim–Paulsen).** Defined by reducing a d-dimensional AR(p) to a dp-dimensional AR(1) and then applying the usual Yule-Walker procedure — which, as they observe, gives a different estimator from solving the Yule-Walker equations directly. It is

$$A_n^{Y} = (A + p_n)(I - q_n')^{-1},\qquad q_n' = q_n - \frac{1}{n-1}U_n U_n^{\mathrm T}\Gamma(0)^{-1} \tag{22}$$

Theorem 1 applies with `A_n^Y ← Δ̂_n`, `A − (n−1)^{-1}I ← Δ_n`, `q_n' ← ρ_n`, `v_n − (n−1)^{-1}I ← σ_n`, `p_n + (n−1)^{-1}I ← δ_n`, giving

$$E(\hat A_n - A_n^{Y}) = \frac{1}{n-1}A + O(n^{-3/2})$$

**THEOREM 3.** Under the other conditions of Theorem 2, `B_n^Y = E A_n^Y − A = −b^Y/n + O(n^{-3/2})` with `b^Y` depending on A and G but independent of n:

$$b^{Y} = A + G\left[(I - A^{\mathsf T})^{-1} + A^{\mathsf T}\{I - (A^{\mathsf T})^{2}\}^{-1} + \sum \lambda (I - \lambda A^{\mathsf T})^{-1}\right]\Gamma(0)^{-1}$$

i.e. **`b^Y = A + b`** — the modified Yule-Walker estimator is *more* biased than least squares by exactly `A/n` to this order. Sum again over eigenvalues λ of A with multiplicities.

**Box–Jenkins least squares** (Box and Jenkins 1976, p. 277), `A_n^{BJ} = (A + p_n)(I − q_n^{BJ})^{-1}` with `q_n^{BJ} = q_n + (n−1)^{-1}U_1U_1^{\mathrm T}\Gamma(0)^{-1}`:

$$E(\hat A_n - A_n^{BJ}) = \frac{1}{n-1}(-A) + O(n^{-3/2})$$

so `b^{BJ} = b − A`, symmetric to the Yule-Walker case in the opposite direction. (The final display of §3's proof and this §4 material are the only places the three estimators are compared; no numerical comparison is offered.)

## 7. Contributions

1. **Removes the Gaussianity assumption** from the known bias expressions for both the least-squares and the modified Yule-Walker estimator of a multivariate AR of arbitrary order, replacing i.i.d. Gaussian innovations by a martingale difference sequence stationary to sixth order with finite sixth moments — and shows the resulting expression is *unchanged*. This is the paper's identity.
2. **Establishes the order of the approximation error as `O(n^{-3/2})`**, which Tjøstheim–Paulsen (1983) did not do.
3. **Provides a general Taylor-series expansion (Theorem 1) for `E[PQ^{-1}]` with explicit error bounds** under conditions tailored to autoregressive sample moments — stated as filling a gap in the literature, and reusable (it is applied three times in the paper).
4. **Reconciles competing mean-correction conventions**: Tjøstheim–Paulsen's LS differs at O(n⁻²) (negligible), while the modified Yule-Walker and Box–Jenkins estimators differ at O(n⁻¹), by `∓A/(n−1)`.
5. Because MDS innovations are permitted, the result covers **conditionally heteroskedastic innovations** (e.g. ARCH-type, provided the conditional moments to order six are finite and time-invariant) — the paper does not advertise this, but it follows from the stated assumption.

## 8. Replication feasibility

**As a mathematical paper:** fully self-contained and verifiable by hand. All proofs are printed; the external inputs are three cited results — Bhansali (1981) Lemmas 3.2 and 3.3, Hosoya and Taniguchi (1982) Theorem 2.2 (and their eq. 3.2), and Nicholls and Pope (1988) for Lemma 1(i)–(ii). There is no code, no data, no simulation to reproduce.

**As a formula to implement (the practically relevant sense):**

- Inputs needed: `Â` (companion matrix), `Ĝ` (innovation covariance, companion form), `Γ̂(0)`, `eig(Â)`, and `n`. Everything is available from a fitted VAR.
- `Γ(0)` should be obtained from the discrete Lyapunov equation `Γ(0) = AΓ(0)Aᵀ + G` (equivalently the series (10)); the paper gives (10) but never names Lyapunov.
- Correction: `Ã = Â + b̂/n` with `b̂` from (9) evaluated at the estimates (the paper stops at the bias expression and does **not** propose or analyze a bias-corrected estimator — the plug-in step, its own O(n⁻¹) error, and any stationarity safeguard are all outside this paper).
- Verification target for a numerical implementation: the univariate specialization must return `b = 1 + 3a` (see §6.1).
- Watch-outs, all flagged above: (a) operator-norm condition `||A|| < 1` is stronger than `ρ(A) < 1` and can fail for a stationary VAR with large off-diagonals — the theorem's stated hypothesis is the singular-value condition; (b) eigenvalues of A are generally complex and the third term must be summed with multiplicity over the complex spectrum; (c) the transpose placement (`Aᵀ` inside, `G` left, `Γ(0)^{-1}` right) is not symmetric and is easy to get wrong; (d) in companion form `G` is singular — (9) needs no inverse of `G`, only of `Γ(0)`, so this is fine, but `Γ(0)` for a companion vector must be full-rank (it is, under stationarity with nonsingular innovation covariance in the top block); (e) **Lemma 1(i) as it appears in this markdown rendering is inconsistent and should not be implemented — use (9)**.
- No finite-sample guidance: the paper offers no evidence on the n at which the `O(n^{-3/2})` remainder becomes negligible, and no guidance for near-unit-root A, where the expansion's constants blow up (`(I − Aᵀ)^{-1}` and `{I − (Aᵀ)²}^{-1}` both explode as eigenvalues approach 1). This is the main gap for macro applications with persistent series.

---

## Notes on this transcription

- Two OCR-damaged passages in the source markdown were not usable verbatim and are described rather than quoted: the closing paragraph of the proof of Theorem 1 (lines around "the Chebyshev-Markov inequality… O(r~-~p)") and the tail of §4's Yule-Walker discussion where the author's surname is mangled ("Tjastheim"/"Tj0stheim"). The mathematical content of both is recoverable and is reported above.
- The proof of Theorem 2 is truncated in the rendering just after the final display of the double-integral reduction (§3 ends without a QED marker before §4's heading); the conclusion "the double integral in (20) reduces to zero" is nonetheless stated explicitly *before* that computation, so the non-Gaussian claim is unambiguous.
- Equations (9), (14), (16)–(19), (21), (22), Theorems 1–3 and Lemma 1 were transcribed directly from the source and cross-checked against each other; the only detected internal inconsistency is Lemma 1(i), flagged in §5.2.
