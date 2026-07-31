# Kilian — "Small-Sample Confidence Intervals for Impulse Response Functions"

Structured extract from marker-produced markdown chunks (Agent Isolation Protocol, `split-pdf-md`).
Chunks read: `chunk_01_small_sample_confidence_intervals_for_im.md`, `chunk_02_ix_empirical_example.md` (2 of 2 — full paper including appendix and references).

---

## Bibliographic metadata

| Field | Value | Source |
|---|---|---|
| Title | SMALL-SAMPLE CONFIDENCE INTERVALS FOR IMPULSE RESPONSE FUNCTIONS | stated (chunk 01, title line) |
| Author | Lutz Kilian | stated |
| Affiliation | University of Michigan | stated (starred footnote) |
| Received / accepted | Received for publication May 3, 1995. Revision accepted for publication November 5, 1996. | stated |
| Journal | **NOT STATED as such in the chunk text.** Strong internal evidence: the Lütkepohl (1990) reference is cited as "this REVIEW 72 (Feb. 1990), 116–125", which is the *Review of Economics and Statistics* self-reference convention. The task brief's "Review of Economics and Statistics 80(2), 218-230" is therefore **consistent but not confirmable from the chunk text**. |
| Year | **NOT STATED in the chunk text** (only the 1995 submission / 1996 acceptance dates appear). Brief says 1998; not verifiable here. |
| Volume / issue / pages | **NOT STATED in the chunk text.** Brief says 80(2), 218–230; not verifiable here. |
| Acknowledgments | V. Corradi, F. X. Diebold, M. Gertler, L. E. Ohanian, C. A. Sims, R. A. Stine, J. H. Stock, and the referees | stated |

Section structure as stated in the introduction: I Introduction, II Traditional Methods, III The Bootstrap-after-Bootstrap Method (A Motivation, B Implementation, C Asymptotic Validity), IV Simulation Design, V Simulation Evidence, VI Extensions to Nonstationary Processes, VII Extensions to Models with Higher Lag Orders, VIII Further Discussion, IX Empirical Example, X Concluding Remarks, Appendix.

**OCR caveats.** The marker extraction mangles several symbols. Where the algorithm's meaning depends on a hat/tilde/bar distinction, this extract flags it explicitly (see §5). In section V the OCR renders θ as "u" and "=" as "5" (e.g. "u21" = θ₂₁, "*B*11 5 0.9" = B₁₁ = 0.9); numbers are quoted after correcting only that substitution.

---

## 1. Research question

Three questions, stated verbatim in the introduction:

> "(1) How accurate are these confidence intervals in small samples? (2) How do differences in their assumptions affect small-sample performance? (3) How can these intervals be improved upon?"

The motivating problem: macroeconomic samples for the postwar / post-Bretton-Woods eras are short, and the three standard confidence intervals for VAR impulse responses — Lütkepohl's (1990) asymptotic delta interval, Runkle's (1987) nonparametric bootstrap percentile interval, and Doan's (1990) Monte Carlo integration interval — are all only *asymptotically* valid, with unknown small-sample behavior. Kilian's claim: "bias and skewness in the small-sample distribution of the impulse response estimator can render traditional confidence intervals extremely inaccurate."

The proposed answer is a new "bootstrap-after-bootstrap" (bias-corrected bootstrap) interval, shown to be asymptotically valid in stationary VARs and evaluated by Monte Carlo.

## 2. Audience

Applied macroeconometricians doing structural VAR impulse-response analysis, and time-series econometricians working on bootstrap refinements. Framing is explicitly frequentist: Bayesian Monte Carlo integration intervals are included because "in applied work, Bayesian Monte Carlo integration intervals are often calculated based on unrestricted point estimates of vector autoregressions. I therefore include them in this study and analyze them (perhaps unfairly) from a strictly frequentist point of view." Footnote 1: "This paper does not cover Bayesian methods."

## 3. Method

**Model.** N-variate series y of length T + p from a covariance-stationary VAR(p) with intercept:

y_t = v + B₁y_{t−1} + ... + B_p y_{t−p} + u_t

Lag order p finite and **known** (footnote 14: "The lag order is assumed to be known. This assumption is common to all methods discussed in this paper. I deliberately ignore the issue of specification uncertainty."). u_t iid white noise, mean zero, unknown p.d. Σ_u, **finite moments up to eighth order**, each element of (u₁, u₁u₁′) satisfying Cramér's condition (Bose 1988).

Reduced-form responses Φ_i = Σ_j Φ_{i−j}B_j, Φ₀ = I_N, B_j = 0 for j > p. Orthogonalized responses Θ_i = Φ_i P with PP′ = Σ_u. **Exact identification of the structural VAR innovations is assumed throughout.** β = vec(v, B₁,...,B_p), σ = vech(Σ_u); the response is written θ_{kl,i}(β, σ).

**Comparison set (four methods).** Asymptotic/delta interval (Lütkepohl 1990; Mittnik–Zadrozny 1993); standard nonparametric bootstrap percentile interval (Runkle 1987) with endpoints [θ̂*^(α), θ̂*^(1−α)]; Monte Carlo integration (Sims 1987; Doan 1990; Sims–Zha 1995), normal-inverse-Wishart posterior, bands from posterior mean ± posterior standard errors; and the new bootstrap-after-bootstrap interval.

**Motivation for the correction (§IIIA), verbatim-critical points:**
- "the small-sample distribution of impulse response estimates can be extremely biased and skewed"; the normal approximation is poor "especially at higher time horizons".
- "none of the standard methods in the literature account for the small-sample bias of θ_{kl,i}, and only the bootstrap interval attempts to allow for skewness."
- Reading off the α and 1−α percentiles of the bootstrap distribution "amounts to assuming that θ*_{kl,i} is unbiased and its distribution scale invariant."
- Direct bias correction of θ̂* is rejected: median-bias correction "treating bias as a pure location shift problem ignores that the distribution of θ̂*_{kl,i} is not scale invariant"; Efron's BC interval "performs very erratically in Monte Carlo simulation"; BC_a's analytic/jackknife scale estimates are "not easy to implement" for θ*; percentile-t "tends to perform erratically" because the variance estimate of θ depends on the location of θ.
- Hence: "this paper proposes to **indirectly remove the bias in θ̂*_{kl,i} prior to bootstrapping the estimate**" — i.e. bias-correct β̂*, then map through the (nonlinear) impulse-response function. "Given the nonlinearity of θ̂*, this procedure will not in general produce unbiased estimates, but as long as the resulting bootstrap estimator is approximately unbiased, the implied percentile intervals are likely to be good approximations."
- **The second, separate reason for correcting β̂ itself** (this is the "prior to bootstrapping" point): "in autoregressive models the OLS estimator is systematically biased away from the population value, and the bootstrap analogy breaks down. Generating bootstrap data conditional on a biased point estimate will tend to result in even more biased bootstrap estimates. This explains the curious result, noted by Sims and Zha (1995, p. 16), that the standard bootstrap interval often tends to lie almost entirely below (or above) the initial OLS point estimate. To preserve the bootstrap analogy we need to bias-correct β̂ 'prior to bootstrapping' to obtain an approximately unbiased estimator of β." Credited to Nicholls and Pope (1988, p. 296) / Pope (1987, unpublished ANU M.Sc. thesis), "but it has been ignored in applications."

## 4. Data

**Monte Carlo DGP (§IV).** Stationary bivariate VAR(1), no intercept/trend in population:

y_t = [[B₁₁, 0], [0.5, 0.5]] y_{t−1} + u_t,  u_t ~ iid N(0, [[1, 0.3], [0.3, 1]])

with **B₁₁ ∈ {−0.9, −0.5, 0, 0.5, 0.9, 0.97, 1}**. (Footnote 10: closely resembles Griffiths–Lütkepohl 1993.) Intercept and trend coefficients normalized to zero in population. For −1 < B₁₁ < 1 the DGP can be read as stationary in levels or in first differences, or (with a trend in the regression) as deviations from trend; for B₁₁ = 1 it is cointegrated. B₁₁ = 0 makes the first equation white noise so asymptotic theory fails (some responses have zero variance, Lütkepohl 1990 p. 119); negative B₁₁ gives oscillatory IRFs. Footnote 12 reports additional evidence for VAR(1)s with complex roots, "comparable to those in section V."

**Sample sizes: 50 and 100** (defended as degrees-of-freedom-equivalent to a 4-variable VAR(4) on 30 years of quarterly data). Off-diagonal error correlation 0.3 chosen to represent "low cross correlations common in applied work (e.g., Sims (1992))"; preliminary experiments with cross correlation 0.9 "yielded virtually identical results." Residuals orthogonalized by Cholesky (footnote 13, "purely for convenience").

**Extensions.** (§VI) multivariate random walk (slope matrix = identity), cointegrated model (B₁₁ = 1), both with and without drift; drift set to 1 in population "to roughly match the ratio of the drift to the standard deviation of the innovation found in applied work." Sample size 500 also used for the nonstationary cases. (§VII) bivariate VAR(8) in levels with intercept, calibrated to an actual estimate on quarterly US M1 and industrial production, persistence m(β̂) = 0.99, sample sizes 80 and 120; and a first-differenced quarterly M1 / IP VAR(4) with m(β̂) = 0.89, same sample sizes.

**Empirical data (§IX).** Monthly, **January 1965 – December 1993, 348 observations**, four variables in this order: log industrial production, log CPI excluding shelter, log commodity prices, federal funds rate (in percent). **VAR(12) with intercept.** Model based on Bernanke and Gertler (1995). Footnote 19: "All data are from CitiBase. The series codes are IP, PRXHS, PWIMSA, and FYFF." Horizon 48 months; shock is an unanticipated 1% increase in the federal funds rate.

## 5. Statistical / numerical methods

### 5.1 The bias-corrected bootstrap ("bootstrap-after-bootstrap") algorithm — verbatim structure

Bias is estimated by **resampling**, not by Pope's analytic formula: "I estimate the mean OLS bias Ψ by resampling methods instead, adapting the general procedure outlined in Efron and Tibshirani (1993, p. 124). Bootstrapping does not improve the accuracy of the bias estimate, but it easily accommodates the inclusion of a linear time trend. Since some of the models I consider in sections V and VI include a linear time trend, I rely on resampling methods for bias estimation throughout this paper."

> **STEP 1a:** Estimate the VAR(p) in equation (1) and generate **1000 bootstrap replications β̂\*** from
>
>   y*_t = v̂ + B̂₁ y*_{t−1} + ... + B̂_p y*_{t−p} + u*_t
>
> using standard nonparametric bootstrap techniques. Then approximate the bias term **Ψ = E(β̂ − β)** by **Ψ\* = E\*(β̂\* − β̂)**. This suggests the bias estimate **Ψ̂ = β̄\* − β̂**.
>
> *(OCR note: the printed formula renders as "Ψ̂ = β̂\* − β̂"; the first term is the* mean *over the 1000 bootstrap replications — it is the sample analogue of E\*(β̂\* − β̂) defined in the immediately preceding sentence. Implement as `mean(beta_star) - beta_hat`.)*

> **STEP 1b:** Calculate the **modulus of the largest root of the companion matrix** associated with β̂. Denote this quantity by **m(β̂)**.
> - If **m(β̂) ≥ 1, set β̃ = β̂ without any adjustments** (i.e. **no bias correction at all** when the OLS estimate is already on/outside the unit circle).
> - If **m(β̂) < 1**, construct the bias-corrected estimate **β̃ = β̂ − Ψ̂**.
> - **If m(β̃) ≥ 1**, let **Ψ̂₁ = Ψ̂** and **δ₁ = 1**, and define **Ψ̂_{i+1} = δ_i Ψ̂_i** and **δ_{i+1} = δ_i − 0.01**. Set **β̃ = β̃_i** after iterating on **β̃_i = β̂ − Ψ̂_i**, i = 1, 2, ..., **until m(β̃_i) < 1**.
> - "By changing the grid for δ, one can make m(β̃) arbitrarily close to unity."
>
> Rationale, verbatim: "The purpose of this stationarity correction is to avoid pushing stationary impulse response estimates into the nonstationary region. The adjustment has no effect asymptotically and **does not restrict the parameter space of the OLS estimator, since it does not shrink the OLS estimate β̂ itself, but only its bias estimate**."

> **STEP 2a:** Substitute β̃ for β̂ in equation (2) [the bootstrap DGP of Step 1a] and generate **2000 new bootstrap replications β̂\*** using standard nonparametric bootstrap techniques. To estimate the mean bias Ψ̂\* of β̂\* "requires nesting a separate bootstrap loop inside each of the 2000 bootstrap loops. **To reduce the computational requirements, one may use the first-stage bias estimate Ψ̂ as a proxy for Ψ̂\***. This short-cut makes use of the result that the bias estimate in each bootstrap loop agrees up to O_P(T^{−3/2}) with the bias estimate for the initial point estimate, which is of order O_P(T^{−1}) itself (see appendix)."

> **STEP 2b:** Calculate β̃\* from β̂\* and Ψ̂\*, **following the instructions in step 1b with the obvious changes in notation** (i.e. the same m(·) ≥ 1 guard and the same δ-shrinkage loop are applied *inside every bootstrap replication*).

> **STEP 3:** Calculate the **α and 1 − α percentile interval endpoints of the distribution of θ̂\*_{kl,i}(β̃\*, σ̂\*)**.

**Computational accounting (footnote 8):** "Instead of (1000 + 2000 × 1000), it requires only (1000 + 2000) replications." Footnote 7: the Ψ̂-for-Ψ̂\* substitution "is accurate to first order. It amounts to assuming that the bias is constant in the neighborhood of β̂. More generally, the coefficient bias may be approximated to higher order by iterating the bias estimation procedure in step 1a."

**Initialization (footnote 9):** "To initialize the bootstrap data-generating process, I randomly select p initial observations using the block method of Stine (1987). Sims and Zha (1995) object to this procedure and suggest to condition on the actual data. Their suggestion appears inconsistent with a frequentist point of view. Note that imposing the same initial conditions in each bootstrap sample will understate the true sampling uncertainty of the impulse response estimate. However, additional simulation experiments suggest that, at least for the example process, treating the initial conditions as fixed in repeated sampling makes essentially no difference for the bootstrap results."

**Σ is NOT bias-corrected (footnote 3, verbatim and directly relevant to implementation):** "Note that this procedure ignores the effects of coefficient bias on σ̂\*. One could have considered bias-correcting σ̂\* in addition, but such a modification would only have had second-order effects on the impulse response estimate. It also would have required us to recalculate and recenter the empirical residuals to preserve the internal consistency of the resampling algorithm. Given these complications, the small order of the effect, and the favorable performance of the bootstrap even without this correction, I chose to keep the algorithm simple by ignoring the effects of bias on σ̂\*. However, further investigation of this issue may be useful."

### 5.2 WHERE the bias correction enters — point estimate vs bootstrap DGP

This is the point the task asked to pin down. What the text actually establishes:

1. **The bias-corrected β̃ is the bootstrap data-generating process.** Step 2a: "Substitute β̃ for β̂ in equation (2) and generate 2000 new bootstrap replications." §IIIC confirms the interpretation: "the analogy continues to hold if we condition on **the bias-corrected β̃ as the bootstrap population value**." So the DGP that produces the interval is driven by bias-corrected coefficients, not by OLS.

2. **The bias correction is also applied inside each bootstrap replication, before the IRF is computed.** Step 2b/Step 3: the percentile interval is read off the distribution of θ̂*_{kl,i}(**β̃\***, σ̂*), not θ̂*(β̂*, σ̂*). §IIIA: "replacing the biased coefficient estimates β̂\* by bias-corrected estimates β̃\* prior to constructing the impulse response function will reduce the bias in θ̂\*. This suggests bootstrapping θ̂\*(β̃\*, σ̂\*) rather than θ̂\*(β̂\*, σ̂\*)."

3. **The paper never instructs replacing the reported point estimate by a bias-corrected one.** The algorithm's output (Step 3) is *the interval*. The paper's language throughout is "bias-corrected bootstrap **interval**" / "confidence interval", and §VIII attributes the Monte Carlo integration interval's shortfall to the fact that "it ignores small-sample bias in the initial OLS estimate β̂" — i.e. bias is treated as something the *interval construction* must account for. In §IX, Figure 7 "plots the responses" and then "shows the upper and lower bounds" of the four intervals: a single response path is drawn against four sets of bounds, which is only coherent if the plotted point estimate is common across the four methods (hence OLS). **Flag: the chunk text nowhere states explicitly "the point estimate remains OLS."** That reading is an inference from (a) Step 3 being the only output, (b) the single shared response path in Figure 7, and (c) §IIIC's framing of β̃ as *the bootstrap population value*. It is nonetheless the standard reading and is exactly the convention this project uses (`apply_kilian = TRUE` affecting only the bootstrap DGP).

4. **Asymptotically it does not matter:** "the effect of bias corrections is negligible asymptotically, since the OLS estimator converges at rate T^{−1/2}, while the estimated bias Ψ(β̂) is of order O_P(T^{−1})."

### 5.3 Resampling scheme — relevant caveat for a wild-bootstrap application

Kilian's algorithm is a **standard nonparametric (iid, residual-resampling) bootstrap** throughout — "using standard nonparametric bootstrap techniques" in both Step 1a and Step 2a, with residuals û_t treated "as though they were the population values" (Runkle 1987 lineage). **The wild bootstrap is never mentioned in this paper**; Gonçalves–Kilian (2004) is a later, separate contribution. The bias-correction machinery (Steps 1a–2b) is orthogonal to the multiplier scheme, but the paper offers no evidence on bias correction under a wild bootstrap, nor for factor-model settings.

### 5.4 Asymptotic validity (§IIIC)

Standard bootstrap validity follows from Bose (1988, theorem 3.9 and remark 3.10): the difference between the Edgeworth expansions for β̂* and β̂ is o(T^{−1/2}) a.s., with analogous statements for σ̂ (equations 3–4), the joint √T-asymptotic normality with block-diagonal covariance (equation 5), and continuous differentiability of θ_{kl,i}(β, σ).

The modifications do not disturb validity, for three reasons: (i) bias corrections are O_P(T^{−1}) vs the O(T^{−1/2}) convergence rate; (ii) Ψ(β̂) may be substituted for Ψ(β̂*) because the two differ by O_P(T^{−3/2}); (iii) the stationarity shrinkage is asymptotically irrelevant because, by Chebychev's inequality applied to the union of events E_j = {|β̂_j − β_j| > ε} over j = 1,...,N²p, P[max_j |β̂_j − β_j| > ε] = O(T^{−1}) — "the probability of a nonstationary draw shrinks at the same rate as the mean squared error of β̂. Thus the nonstationary region of the distribution will be empty asymptotically."

**Known invalidity case (§VI, footnote 17):** bootstrapping is *not* asymptotically valid for models with an exact unit root estimated in levels (Basawa et al. 1991), because the asymptotic distribution of the OLS estimator is discontinuous at the unit circle. Remedies noted: impose the unit root (estimate in first differences) or estimate cointegrated systems in VEC form (Lütkepohl–Reimers 1992), where the ML estimator's asymptotic distribution is continuous and the bootstrap is valid — "but these results are contingent on correct identification of the order of integration and of the cointegration rank."

### 5.5 Relation to Pope (1990) — analytic bias formula

Explicitly discussed, in three places:

- **§IIIB, why the analytic route is not used:** "Explicit expressions for the asymptotic first-order mean bias in demeaned stationary VAR processes are available in Pope (1990). In this paper, I estimate the mean OLS bias Ψ by resampling methods instead... **Bootstrapping does not improve the accuracy of the bias estimate, but it easily accommodates the inclusion of a linear time trend.**" So the choice of the bootstrap bias estimator over Pope's formula is driven **entirely by the trend case**, not by accuracy. Footnote 6: "Nicholls and Pope (1988) derive the same bias estimate under the more restrictive assumption of normal innovations. Tjøstheim and Paulsen (1983) outline a procedure for bias estimation in VAR models, but they do not provide a rigorous analytical derivation of that bias nor do they estimate the order of the error."
- **§IIIC:** the O(T^{−1}) order of the bias estimate is taken from Pope (1990).
- **§X:** "Asymptotic bias corrections can further reduce the computational burden of the bias-corrected bootstrap method, but **currently exist only for VAR models without deterministic time trends**." §IIIB likewise: "the double bootstrap could be reduced to a single layer of bootstrapping whenever asymptotic bias expressions are available."
- **Appendix, the formal statement:** with β = vec(B₁,...,B_p), "From Pope (1990), E(β̂ − β) = b(β)/T + O(T^{−3/2})", β̃ = β̂ − b(β̂)/T and β̃* = β̂* − b(β̂*)/T. Assuming b continuous, smooth, with bounded first and second derivatives, a Taylor expansion of b(β̂*) about β̃ gives (1/T)[b(β̂) − b(β̂*)] = O_P(T^{−2}) + O_P(T^{−3/2}) = **O_P(T^{−3/2})**, using b(β̂) − b(β̃) = O_p(T^{−1}) from β̃ − β̂ = O_p(T^{−1}) and b(β̃) − b(β̂*) = O_p(T^{−1/2}) from β̂* − β̃ = O_p(T^{−1/2}). "Abstracting from simulation error, these results carry over to bootstrap bias estimates." This is the theorem justifying the Step-2a shortcut.

**Note the parameter-vector discrepancy (flag):** §II defines β = vec(v, B₁,...,B_p) (intercept included); the Appendix defines β = vec(B₁,...,B_p) (slopes only, matching Pope's demeaned setting). The text does not reconcile the two; the m(·) companion-matrix guard obviously concerns only the slope block.

### 5.6 Monte Carlo protocol

**1000 replications for bootstrap bias estimation; 2000 replications for interval construction; 500 Monte Carlo trials per design point** ("which implies a Monte Carlo standard error of approximately 0.01 for the coverage estimate"). Criteria: **effective coverage rate of the nominal 95% interval** ("the relative frequency at which the confidence interval covers the true, but in practice unknown impulse response value in repeated trials") and **average length**. **68 implied impulse response coefficients** per draw; plots show horizons up to **16 periods**.

## 6. Findings (with numbers)

### 6.1 Stationary bivariate VAR(1), no time trend (§V, figures 2–3)

Baseline B₁₁ = 0.9, T = 50, response θ₂₁ (variable 2 to a shock in variable 1):
- Standard bootstrap: coverage "quickly drop[s] off to **about 50%**".
- Asymptotic/delta: also **about 50%**.
- Monte Carlo integration: **fluctuates between about 80 and 96%** depending on horizon.
- **Bootstrap-after-bootstrap: about 90 to 95% at all time horizons.**
Similar for θ₁₁. For θ₁₂ and θ₂₂ "the differences between the four intervals are only minor" — all close to nominal, with the asymptotic and MC-integration intervals tending to **over**cover at higher horizons. (Footnote 15: coverage for θ₁₂ at horizon zero is 100% for every method — "an artifact of the orthogonalization by Cholesky decomposition.")

Raising persistence, T = 50, θ₂₁, no trend:
| B₁₁ | standard bootstrap | asymptotic | MC integration |
|---|---|---|---|
| 0.97 | **22%** | **41%** | **72%** |
| 1 | **12%** | **33%** | **62%** |

Lowering B₁₁ to 0.5 improves coverage. **Why the responses differ:** "In the process considered here, θ₁₁ and θ₂₁ are primarily functions of the OLS estimate of B₁₁, whereas θ₁₂ or θ₂₂ are not, which explains why the latter are hardly affected by bias in B₁₁." General lesson, verbatim: "in VAR applications standard methods will sometimes coincide with the bootstrap-after-bootstrap interval and sometimes imply drastically different results, but **only the bias-corrected bootstrap interval is likely to have accurate coverage all the time**."

Results for B₁₁ = 0.5, −0.5, −0.9 are not displayed but "the bias-corrected bootstrap continues to perform well, even when bias is virtually nonexistent and therefore difficult to estimate, as might be the case for difference-stationary processes. **In all cases considered, the bootstrap-after-bootstrap interval performs at least as well as the other methods**, and its effective coverage is typically close to nominal coverage." The asymptotic interval is "erratic and often poor for B₁₁ = 0, when the asymptotic variance may not be well defined."

**T = 100:** qualitatively the same; BaB close to nominal except the limiting B₁₁ = 1 case; "In relative terms the bootstrap-after-bootstrap interval continues to dominate the other methods, often by a wide margin." Headline number: **if B₁₁ = 0.9, "for the asymptotic interval to attain the same coverage accuracy as the bootstrap-after-bootstrap interval for sample size 50, the sample size has to increase to about 400 periods."**

### 6.2 With a linear time trend in the regression (§V, figures 2 right panels, 4)

Coverage of standard methods "deteriorates dramatically". Reported floors:
- Figure 2 (T = 50, B₁₁ = 0.9): as low as **13%** (standard bootstrap), **28%** (asymptotic), **67%** (MC integration).
- Figure 4, as B₁₁ increases, T = 50: as low as **1%**, **8%**, and **32%** respectively.
- **T = 100: BaB coverage is 84% or higher** except the limiting B₁₁ = 1 case, "compare[d] to rates as low as **7%** for the standard bootstrap, **34%** for the asymptotics, and **54%** for Monte Carlo integration."

### 6.3 Interval length (§V, figure 5)

"It is perhaps surprising that this increase in probability content does not necessarily come at the expense of wider intervals. Figure 5 shows that **for sample size 50 the bias-corrected bootstrap interval both has higher coverage and is shorter on average than the Monte Carlo integration interval.** For sample size 100, the coverage of the bias-corrected interval continues to be much higher at a fairly small additional cost in terms of length." BaB is longer than the asymptotic and standard bootstrap intervals in small samples for highly persistent processes, but "those intervals have much lower coverage." Footnote 16 explains the MC-integration length pathology: it assumes β̂ is normal in small samples, raising the probability of explosive draws when the estimated root is near unity; explosive outliers inflate the simulated standard error, and imposing symmetry then yields "ever wider intervals with increasing coverage, as the time horizon grows."

### 6.4 Nonstationary processes (§VI, figure 6)

- Cointegrated model without drift (B₁₁ = 1): "the bias-corrected bootstrap interval clearly outperforms its competitors."
- Multivariate random walk (slope matrix = I): similar ranking, but "effective coverage rates may be much lower and are less consistent across impulse response functions."
- Performance **improves with sample size**: "the coverage rates of the bias-corrected bootstrap interval for θ₂₁ in the cointegration model **approach 90% for sample size 500, compared to rates as low as 70% for the other two methods**."
- **With drift** (drift = 1): for the cointegrated model with drift, "both the bootstrap-after-bootstrap and the Monte Carlo integration intervals have excellent coverage properties. In fact, even the asymptotic interval performs quite well" — "strikingly different from the model without drift." At T = 50 BaB is slightly shorter than MC integration at higher horizons. For the random walk with drift, results resemble the no-drift case and BaB continues to dominate. As the *second* root of the cointegrated process approaches unity, methods diverge again and "the bootstrap-after-bootstrap interval enjoys clear advantages."
- Adding a time trend to a nonstationary regression "considerably worsens the performance of all intervals"; in the trend-with-drift model MC integration often has higher coverage but is "on average ... much longer." Conclusion: "falsely including a time trend in the regression model can seriously impair the coverage content of confidence intervals if the true process has a unit root."

### 6.5 Higher lag orders (§VII)

- Bivariate VAR(8) in levels, m(β̂) = 0.99, T ∈ {80, 120}: BaB results "similar to the results for the VAR(1) model with comparable persistence." MC integration "performed about as well as the bootstrap-after-bootstrap interval for sample size 80, but had slightly lower coverage for sample size 120. It also tended to become very wide at high time horizons in some cases."
- First-differenced VAR(4), m(β̂) = 0.89, T ∈ {80, 120}: "As expected for processes with lower persistence, the coverage rates of the bootstrap-after-bootstrap interval and the Monte Carlo integration interval were similar, although **in some cases the bias-corrected intervals were wider without improving coverage**." (This is the paper's own statement of the cost of bias-correcting a low-persistence system.)
- In both: asymptotic and standard bootstrap "much worse."

### 6.6 Acknowledged weaknesses (§VIII)

- BaB coverage "tends to fall short of the nominal coverage probability, as the true process becomes highly persistent, especially if a linear time trend is included in the regression. **This tendency becomes very visible for B₁₁ > 0.97.**" Conjectured cause: "the rapid increase in bias, as the root approaches unity, calls for **higher order bias corrections**", obtainable "by iterating on the bias estimation bootstrap loop, if computational costs are not a concern."
- On near-unit-root asymptotics (Stock 1995; Phillips 1995 p. 7): Phillips shows φ̂_{kl,i} is asymptotically normal in the local-to-unity model when the horizon is fixed w.r.t. T — "This normality result does not seem consistent with the observed shape of the small-sample distribution of the impulse response." Local-to-unity asymptotics for θ̂_{kl,i} "are not available so far."
- On Sims–Zha's (1995, p. 14) proposal to replace the symmetric MC-integration band with a percentile band: it raises coverage, curbs explosive length, stabilizes coverage across horizons, "but it does not alter the ranking of the methods in sections V, VI, and VII... the Monte Carlo integration interval **may still undercover by up to 20 percentage points** relative to the bootstrap-after-bootstrap interval, especially if a time trend is included in the regression. Its lower coverage ... mainly results from the fact that **it ignores small-sample bias in the initial OLS estimate β̂**."
- Why the same fix cannot rescue the competitors: "Bayesian inference is exact conditional on the sample path, and one would be hard pressed to justify such bias corrections"; and a bias-corrected delta method "would be unlikely to perform as well ... given the skewness of the small-sample distribution."

### 6.7 Empirical example (§IX, figure 7) — the substantive payoff

VAR(12), 4 variables, 348 monthly observations, 1965:1–1993:12, response to an unanticipated **1% increase in the federal funds rate**, horizon 48 months, nominal 95%.

- **Output:** "all methods suggest a significant if temporary decline in output in response to the interest rate increase. Differences in the duration of that decline may be as large as **7 months**, but the basic pattern is robust."
- **Prices — the headline result:** "While the **bias-corrected interval includes zero for all time horizons**, all other intervals suggest a significant negative response of the price level **at horizons higher than about 36 months**." I.e. the standard "monetary tightening is followed by a sustained decline in output *and in the price level*" fact survives only in its first half under BaB. "This example clearly illustrates that using the bias-corrected bootstrap interval can change the way we interpret economic data, **even for fairly large samples**."
- **Federal funds rate:** under BaB "this response is no longer significant after **11 months**. However, the Monte Carlo integration interval and the delta method interval show another significant spike at **14 through 16 months**. Moreover, about three years after the shock, the standard bootstrap interval falls below zero for **9 months**, and the delta method interval turns negative after **48 months**."
- Balanced framing: "The differences between intervals need not always be as spectacular as in the middle panel, and they are rarely so unanimous"; the method "need not invalidate the usefulness of VAR analysis in general."

## 7. Contributions

1. **Diagnosis:** documents that the small-sample distribution of impulse response estimates is severely biased *and* skewed, that the standard intervals ignore the bias entirely, and that the standard bootstrap percentile interval implicitly assumes unbiasedness and scale invariance of θ̂*.
2. **Method:** the bootstrap-after-bootstrap interval — a two-stage procedure that bias-corrects the autoregressive coefficients (i) before generating bootstrap data and (ii) inside each bootstrap replication before mapping to impulse responses, with an explicit stationarity-preserving shrinkage of the *bias estimate* (never of the OLS estimate), at a cost of (1000 + 2000) rather than (1000 + 2000 × 1000) replications.
3. **Theory:** asymptotic validity in stationary VARs (§IIIC), plus the appendix result that the bootstrap-world bias estimate agrees with the sample bias estimate up to O_P(T^{−3/2}), which licenses the computational shortcut.
4. **Evidence:** a broad Monte Carlo showing BaB is "the only method to achieve effective coverage rates close to nominal coverage in nearly all circumstances", robust "to changes in sample size, persistence, lag length, and the shape of the impulse response function", for levels, trend-deviation and first-difference specifications, and for random-walk and cointegrated processes estimated in levels — usually without a length penalty, and sometimes shorter than MC integration.
5. **Applied demonstration** that the correction can overturn a canonical empirical claim (the price-level response in a Bernanke–Gertler-style monetary VAR).

Explicitly *open* per §X: larger systems ("further simulation evidence for much larger VAR systems containing four to eight variables would be useful. **Currently nothing is known about the small-sample performance of confidence intervals in such large systems.** While the simulation results in this paper are suggestive, they are limited to bivariate systems"); higher-order bias corrections; lag-order uncertainty; parametric vs nonparametric resampling; theory explaining why bias-corrected bootstraps work so well in small samples.

## 8. Replication feasibility

**High for the algorithm, moderate for the numbers.**

*Reproducible from the text alone:* the full Step 1a–Step 3 algorithm including the δ-shrinkage rule with its **0.01 grid**; replication counts (1000 bias / 2000 interval / 500 trials); the exact Monte Carlo DGP (equation 8 with all seven B₁₁ values, Σ_u, T ∈ {50, 100}); the Cholesky orthogonalization; nominal level 95%; horizons to 16; 68 impulse response coefficients; Stine (1987) block initialization. The empirical example is fully specified: model, four CitiBase series codes (IP, PRXHS, PWIMSA, FYFF), 12 lags plus intercept, 1965:1–1993:12, 348 observations, 48-month horizon, 1% funds-rate shock.

*Frictions:* (a) no random seeds, so Monte Carlo numbers reproduce only up to ~0.01 simulation error; (b) no code or data archive is mentioned; (c) figures 1–7 are image references in the marker output, so most reported numbers are the ones quoted in prose — the full coverage curves are not recoverable from this text; (d) footnote 18, "An alternative set of figures 2 through 6 is available upon request," is a dead channel; (e) the M1/IP-calibrated VAR(8) and VAR(4) coefficient matrices of §VII are not printed, only their persistence (0.99 and 0.89), so §VII is *not* replicable; (f) CitiBase is defunct — the series must be re-sourced (FRED equivalents) and the vintage will differ; (g) OCR ambiguity on Ψ̂ = β̄* − β̂ (see §5.1) and on the β with/without intercept (see §5.5).

*Computational scale, as of the paper:* "constructing the intervals for a standard quarterly VAR(4) system with linear time trend like the one considered by Runkle (1987) takes about **30 minutes on a Pentium 100**." Trivial today.

---

## Notes for this project (DFM + wild bootstrap + Kilian correction)

These are cross-references, not claims from the paper:

- **The correction is a bootstrap-DGP device, not a point-estimate device**, on the reading argued in §5.2 above. That matches the project convention recorded in `CLAUDE.md` ("The bootstrap uses Kilian-corrected coefficients for the DGP but the point estimate uses plain OLS ... `apply_kilian = TRUE` only affects the bootstrap"), and matches `DFMest_BLL.m`. The paper itself never states the point-estimate side explicitly — worth citing carefully.
- **Two guards, not one.** (i) If the *uncorrected* OLS companion matrix already has m(β̂) ≥ 1, Kilian applies **no** bias correction. (ii) Only if correction pushes m(β̃) ≥ 1 does the δ-loop shrink Ψ̂ by 0.01 per iteration. An implementation that only has guard (ii) deviates from the paper.
- **The correction is applied twice**: once to β̂ (Step 1b, defining the bootstrap population) and once to every β̂* (Step 2b, before the IRF map). Both use the same m(·) guard.
- **σ̂\* is deliberately left uncorrected** (footnote 3).
- **The paper's bootstrap is iid nonparametric, never wild.** Kilian's own wild-bootstrap contribution (Gonçalves–Kilian 2004) is outside this paper; nothing here validates bias correction under Rademacher multipliers, and nothing here covers factor models or systems beyond bivariate — §X says explicitly that nothing was known about 4–8-variable systems.
- **Bias correction is not free when persistence is low:** §VII reports cases where "the bias-corrected intervals were wider without improving coverage" for m(β̂) = 0.89.
