# Gafarov, Meier & Montiel Olea — "Delta-method inference for a class of set-identified SVARs"

Extraction notes (split-pdf-md, Agent Isolation Protocol). Source: 2 chunks in
`.../Gafarov, meier, olea - Delta-method inference for a class of set-identified SVARs_build/chunks_.../`
(`chunk_01_journal_of_econometrics.md`, `chunk_02_proof_see_appendix_a_5.md`).

---

## Bibliographic metadata

| Field | Value | Source in text |
|---|---|---|
| Title | Delta-method inference for a class of set-identified SVARs | header |
| Authors | Bulat Gafarov (UC Davis, Agricultural and Resource Economics), Matthias Meier (Mannheim, Economics), José Luis Montiel Olea (Columbia, Economics — corresponding) | title block |
| Journal | *Journal of Econometrics* (Elsevier) | running header |
| Received / revised / accepted / online | 4 Feb 2016 / 12 Jul 2017 / 1 Dec 2017 / **6 Jan 2018** | article history |
| Copyright | © 2017 The Author(s), Elsevier B.V., **CC BY open access** | abstract footer |
| DOI | `10.1016/j.jeconom.2017.12.004` (given in the "Appendix A. Supplementary data" line) | §Appendix A |
| JEL | C1, C32, E47 | keywords block |
| Keywords | Set-identification; sign restrictions; SVAR; directional differentiability; unconventional monetary policy | keywords block |
| Award | Recipient of the 2016 best-paper-in-applied-economics award for young researchers, 69th European Meeting of the Econometric Society | title footnote ✩ |

**FLAGGED — not stated anywhere in the chunks:**
- **Year of the issue, volume number, and page range are absent** from the extracted text. The marker output has no volume/issue/page line. The copyright line says 2017, "available online" says 6 Jan 2018 — the *issue* year is therefore ambiguous from the text alone. Do **not** cite volume/pages from these notes; verify externally (the Elsevier PII embedded in the reference back-links is `S0304-4076(17)30244-0`, which is metadata, not a stated citation).
- Abstract page numbers, editor, and received-in-final-form details are also absent.

---

## 1. Research question

How can one conduct **frequentist (prior-free) inference on impulse-response coefficients in SVARs that are only set-identified** by equality and/or inequality restrictions, without the two standard costs: (i) Bayesian posterior inference that remains prior-dependent even as T → ∞ (Poirier 1998; Gustafson 2009; Moon & Schorfheide 2012), and (ii) the heavy computational burden of existing prior-free alternatives?

Three sub-questions, mapped to the three theorems:
1. Can the **endpoints** (max and min) of the identified set for a given IRF coefficient λ_{k,i,j} be computed **without random sampling** over orthogonal matrices / unit vectors?
2. Are those endpoints **differentiable** (in what sense) as functions of the reduced-form parameter μ?
3. Does a **plug-in-estimate-of-the-identified-set ± standard-error** interval have valid large-sample properties?

---

## 2. Audience

Empirical macroeconomists estimating sign-restricted / zero-restricted SVARs (monetary policy, fiscal, labour, oil, exchange-rate applications) and econometric theorists working on partial identification and inference for directionally differentiable functionals. The paper positions itself explicitly against three named alternatives: **Granziera, Moon & Schorfheide (2017) [GMS17]** (moment-inequality/minimum-distance frequentist CI), **Giacomini & Kitagawa (2015) [GK15]** (robust-Bayes credible interval), and the authors' own **projection** approach (Gafarov, Meier & Montiel Olea 2016 [GMM16]).

---

## 3. Method

### 3.1 The model

n-dimensional SVAR with p lags, i.i.d. structural shocks ε_t ~ F, unknown n×n structural matrix B:

    Y_t = A_1 Y_{t-1} + … + A_p Y_{t-p} + B ε_t,   E_F[ε_t] = 0,  E_F[ε_t ε_t'] = I_n.   (2.1)

Object of interest — the (k,i,j) IRF coefficient:

    λ_{k,i,j}(A,B) ≡ e_i' C_k(A) B_j,   B_j ≡ B e_j.   (2.2)

with C_k(A) defined recursively, C_k(A) = Σ_{m=1..k} C_{k-m}(A) A_m, A_m = 0 for m > p (Lütkepohl 1990, p. 116).

Reduced-form nuisance parameter: μ ≡ (vec(A)', vec(Σ)')' ∈ M ⊆ R^d, with A ≡ (A_1,…,A_p) and Σ ≡ BB'. (2.3)

### 3.2 THE EXACT CLASS OF SET-IDENTIFIED SVARs COVERED — *the key scope restriction*

The admissible set for the **single column of interest** B_j is

    R(μ) ≡ { B_j ∈ R^n : Z(μ)' B_j = 0_{m_z×1}  and  S(μ)' B_j ≥ 0_{m_s×1} },   (2.4)

where Z(μ) is n×m_z (equality/"zero" restrictions) and S(μ) is n×m_s (inequality/"sign" restrictions).

**Critical limitation, stated by the authors themselves in the introduction:** the delta-method interval is *only* defined for SVAR models that impose equality and inequality restrictions on a **single structural shock** (e.g. a monetary policy shock). They call this "admittedly problematic", since many popular applications restrict multiple structural innovations — Kilian & Murphy (2012) oil (demand *and* supply), Baumeister & Hamilton (2015) labour, Mountford & Uhlig (2009) fiscal (revenue *and* spending shocks while controlling for a business-cycle and a monetary shock). They defend relevance by listing single-shock applications: Uhlig (2005), Vargas-Silva (2008), Fujita (2011), An & Wang (2012), Beaudry, Nam & Wang (2011).

Restriction *types* the linear form (2.4) accommodates (§2.2 (a)–(d)):
- **(a) Sign/zero restrictions on IRFs** at horizon k of variable i: `e_i' C_k(A) B_j ≥ 0` or `= 0` (Uhlig 2005). Note this is *any* horizon, not just impact.
- **(b) Long-run restrictions**: `e_i'(I_n − A_1 − … − A_p)^{-1} B_j ≥ 0` or `= 0` (Blanchard & Quah 1989).
- **(c) Short-run restrictions on coefficients of the jth structural equation**: `e_i'(B')^{-1} e_j = e_i' Σ^{-1} B_j ≥ 0` or `= 0` (Rubio-Ramírez, Caldara & Arias 2015).
- **(d) Elasticity bounds** (Kilian & Murphy 2012): `e_i'B_j / e_{i'}'B_j ≥ b ⟺ (e_i − b e_{i'})' B_j ≥ 0`, provided `e_{i'}'B_j > 0`.

**Sign normalization** is treated as a restriction of the same family, imposed via either (i) type (c) — `e_j' B^{-1} e_j ≥ 0`, sign of the direct effect of the jth variable on the jth equation, or (ii) type (a) — sign of an arbitrary IRF coefficient. The authors insist a normalization must *always* be imposed so the IRF refers to a fixed-sign shock.

Note that Z(μ) and S(μ) are allowed to **depend on μ** — that is what makes types (a), (b), (d) admissible — and this dependence is exactly what Assumption 3 (below) disciplines.

### 3.3 The identified-set bounds (Definition 1)

    v̄_{k,i,j}(μ) ≡ sup_{B ∈ R^{n×n}} e_i' C_k(A) B e_j  s.t.  BB' = Σ  and  B e_j ∈ R(μ)   (2.5)
    v_{k,i,j}(μ) ≡ inf_{B ∈ R^{n×n}} e_i' C_k(A) B e_j  s.t.  BB' = Σ  and  B e_j ∈ R(μ)   (2.6)

These are the **value functions of a non-linear, non-convex mathematical program**, and the whole paper is built on characterizing them analytically rather than numerically.

### 3.4 Theorem 1 — closed-form algorithm for the bounds

Assumptions:
- **Assumption 1**: the choice set in (2.5) is non-empty at μ (restrictions are mutually consistent).
- **Assumption 2 (linear independence)**: for any 0 ≤ k ≤ m_s and any selection e(k) of k columns of I_{m_s}, the matrix R(μ; e(k)) ≡ [Z(μ), S(μ)e(k)] ∈ R^{n×(m_z+k)} has full rank. Two implications: (i) **at most n−1 constraints can be active at a solution** (hence m_z ≤ n−1), and (ii) the solution admits a **Karush–Kuhn–Tucker** characterization.

**Lemma 1** (Appendix A.1): letting r collect all columns of Z(μ) plus whichever columns of S(μ) are active at the solution, the value function equals **plus or minus**

    v_{k,i,j}(μ; r) = ( e_i' C_k(A) Σ^{1/2} M_{Σ^{1/2} r} Σ^{1/2} C_k(A)' e_i )^{1/2},
    M_{Σ^{1/2} r} ≡ I_n − Σ^{1/2} r (r' Σ r)^{-1} r' Σ^{1/2}   (an orthogonal projector)

with maximizers x_±^*(μ;r) ≡ ± Σ^{1/2} M_{Σ^{1/2}r} Σ^{1/2} C_k(A)' e_i / v_{k,i,j}(μ;r). The sign is **positive if x_+^* satisfies the inequality restrictions not included in r, negative otherwise** — i.e. sign is decided by *primal feasibility*, not by optimization.

**Algorithm (Theorem 1)**: enumerate R = the set of all r obtainable by taking all m_z columns of Z(μ) and k of the m_s columns of S(μ), with 0 ≤ k ≤ n − m_z − 1. For each r, evaluate the penalized objectives

    f⁺_max(μ;r) ≡  v_{k,i,j}(μ;r) − 2(1 − 1_{m_s}(x_+^*(μ;r))) c
    f⁻_max(μ;r) ≡ −v_{k,i,j}(μ;r) − 2(1 − 1_{m_s}(x_-^*(μ;r))) c

with 1_{m_s}(x) ≡ 1{S(μ)'x ≥ 0} and penalty constant c > c̄ ≡ max_{i,k}(e_i' C_k(A) Σ C_k(A)' e_i)^{1/2} (footnote 7: c̄ is the max of the *unrestricted* program (4.1)). Degenerate case v_{k,i,j}(μ;r) = 0 handled separately: set f⁺ = f⁻ = 0 if some x* ≠ 0 satisfies the equalities in r and the excluded inequalities, else f⁺ = f⁻ = −2c.

    **Theorem 1**: v̄_{k,i,j}(μ) = max_{r ∈ R} ( max{ f⁺_max(μ;r), f⁻_max(μ;r) } ).  Minimum analogous.

Lineage: inspired by **Faust (1998)** — enumerate all collections of active constraints, keep the best feasible one. No sampling from the space of structural matrices B is required, and the algorithm is **guaranteed to find a global solution in a finite number of steps** (the two alternatives named — `fmincon` and Uhlig-style random draws of a unit vector q — are not).

### 3.5 Theorem 2 — directional differentiability of the bounds

- **Assumption 3**: Z(·) and S(·) are **differentiable at μ**. The authors state they are unaware of any equality/inequality restriction in the SVAR literature violating this, and that all examples (a)–(d) in §2.2 satisfy it for every μ ∈ M.

**Lemma 2** (Appendix A.3): if Assumptions 1–3 hold **and v_{k,i,j}(μ; r(μ)) ≠ 0**, then v_{k,i,j}(μ; r(μ)) is (fully) differentiable in (vec(A)', vec(Σ)')' with

    ∂v/∂vec(A) = [∂vec(C_k(A))/∂vec(A)] (x*(μ;r(μ)) ⊗ e_i) − Σ_{k=1..l} w*_k [∂vec(r_k(μ))/∂vec(A)] x*(μ;r(μ))
    ∂v/∂vec(Σ) = λ* Σ^{-1}x*(μ;r(μ)) ⊗ Σ^{-1}x*(μ;r(μ)) − Σ_{k=1..l} w*_k [∂vec(r_k(μ))/∂vec(Σ)] x*(μ;r(μ))

with x*(μ;r) = Σ^{1/2} M_{Σ^{1/2}r} Σ^{1/2} C_k(A)' e_i / v_{k,i,j}(μ;r), λ* ≡ ½ v_{k,i,j}(μ;r(μ)), and w* ≡ [r(μ)'Σ r(μ)]^{-1} r(μ)' Σ C_k(A) e_i (the Lagrange multipliers on the active constraints). Footnote 10 gives the envelope-theorem reading: the program is max_x e_i'C_k(A)x s.t. x'Σ^{-1}x = 1 and r(μ)'x = 0, Lagrangian L(x;μ,r(μ)) = (x'⊗e_i')vec(C_k(A)) − λ((x'⊗x')vec(Σ^{-1}) − 1) − w'(r(μ)'x); λ is the multiplier on the quadratic normalization and w ∈ R^l on the l active linear restrictions.

**Definition 3 (directional differentiability)**: v is directionally differentiable at μ if for any h ∈ R^d, any t_N → ∞ and any h_N → h with μ + t_N h_N ∈ M, there is a *continuous* v̇_μ : R^d → R with t_N ( v(μ + h_N/t_N) − v(μ) ) → v̇_μ(h). (Cites Shapiro 1991, p. 172.)

    **Theorem 2**: under Assumptions 1–3 and **v̄_{k,i,j}(μ) > 0**, v̄_{k,i,j} is directionally differentiable in μ with directional derivative
        max_{x ∈ X*(μ)} [ v̇_{k,i,j}(μ; r(μ;x))' h ]   (4.2)
    where X*(μ) is the argmax set of (2.5) and r(μ;x) collects **all** elements of Z(μ) and S(μ) active at x.
    **If X*(μ) = {x*} is a singleton, v̄ is FULLY differentiable** with derivative v̇_{k,i,j}(μ; r(μ;x*)).
    Footnote 12: if v̄_{k,i,j}(μ) < 0 the directional derivative becomes max_{x ∈ X_*(μ)} [ −v̇_{k,i,j}(μ;r(μ;x))'h ].

**Why only *directional*, and why it matters:** non-differentiability arises precisely when *multiple distinct structural models* attain the maximum (or minimum) response, i.e. |X*(μ)| > 1. The theoretical machinery is the generalized envelope theorem of **Fiacco & Ishizuka (1990), Thm 4.2 p. 223** and **Bonnans & Shapiro (2000), Thm 4.24 p. 280** (sup_x ∇_μ L(x;μ)h for the max, inf_x for the min, *provided the supporting Lagrange multipliers are unique*), verified here via Lemmas 1–2 plus intermediate results from Ok (2007).

**Delta-method vs bootstrap (explicitly argued):** Fang & Santos (2015) show the **standard bootstrap is inconsistent** for directionally differentiable functionals; Kitagawa, Payne & Montiel Olea (2017) show quantile-based Bayesian credible sets for v(μ) are asymptotically equivalent to that (inconsistent) bootstrap. Hence neither routine frequentist bootstrap nor routine Bayesian quantiles are guaranteed consistent here. Hong & Li (2017)'s numerical delta method is an alternative but (i) needs a user-chosen tuning parameter and (ii) requires evaluating the value function at many resampled μ, whereas this paper's delta method evaluates only at μ̂.

### 3.6 Theorem 3 — the delta-method interval

    CS_T(1−α; λ_{k,i,j}) ≡ [ v_{k,i,j}(μ̂_T) − z_{1−α/2} σ̂_{(k,i,j),T}/√T ,  v̄_{k,i,j}(μ̂_T) + z_{1−α/2} σ̂_{(k,i,j),T}/√T ]

i.e. **plug-in estimate of the identified set, extended on each side by one standard error**. μ̂_T is the ordinary LS estimator: Â_T = (T^{-1}ΣY_t X_t')(T^{-1}ΣX_t X_t')^{-1}, Σ̂_T = (T − np − 1)^{-1} Σ η̂_t η̂_t', X_t ≡ (Y_{t-1}',…,Y_{t-p}')', η̂_t ≡ Y_t − Â_T X_t.

**The standard-error formula — the paper's practical trick:**

    σ̂_{(k,i,j),T} ≡ max_{r ∈ R(μ̂_T)} ( v̇_{k,i,j}(μ̂_T; r)' Ω̂_T v̇_{k,i,j}(μ̂_T; r) )^{1/2}   (4.3)

where R(μ̂_T) is the set of **all** possible collections of active constraints at μ̂_T. The maximization is over *all* candidate active sets, **not** over the estimated argmax/argmin. Consequently **neither the argmax nor the argmin of the program needs to be estimated** — the max over all r converges to something ≥ the max over the true optimizers, so the s.e. is deliberately conservative, "protecting against potential violations of full differentiability even when the function is differentiable at μ".

Large-sample assumptions:
- **Assumption 4**: √T(μ̂_T − μ(P)) →_d ζ(P) ~ N_d(0, Ω(P)) and Ω̂_T →_p Ω(P). Footnote 13 gives the heteroskedasticity-robust sandwich Ω̂_T ≡ T^{-1} Σ_t vec([η̂_t X_t', η̂_t η̂_t' − Σ̂_T]) vec(·)'. The authors note validity also under time-series dependence in η_t provided a **HAC** estimator of Ω is used.
- **Assumption 5 (Bernstein–von Mises)**: sup over Borel sets B of |P*_μ(√T(μ* − μ̂_T) ∈ B | Y) − P(ζ(P) ∈ B)| →_p 0, per Ghosal, Ghosh & Samanta (1995). Satisfied by a Normal-Inverse-Wishart prior (Uhlig 2005) in a Gaussian i.i.d. VAR; more generally whenever P*_μ has a continuous density at μ with polynomial majorants.

Note the paper stresses Assumption 4 is a **weaker** high-level requirement than GMS17's asymptotic normality of the reduced-form *impulse responses* (cf. Kilian 1998; Benkwitz, Neumann & Lütkepohl 2000), and holds even under unit roots and cointegration of unknown form (Sims, Stock & Watson 1990; Toda & Yamamoto 1995; Dolado & Lütkepohl 1996; Inoue & Kilian 2002; Lütkepohl 2007 Prop. 7.1).

---

## 4. Data

- **Variables (n = 4)**: CPI, Industrial Production index, 2-year Treasury Bond rate (2yTB), Federal Funds rate (FF). All sourced from the **Gertler & Karadi (2015)** dataset (footnote 6 thanks Peter Karadi).
- **Transformation**: logs of CPI and IP, then **first differences of all four**:
  Y_t ≡ (ΔlnCPI_t, ΔlnIP_t, Δ2yTB_t, ΔFF_t)'. Cointegration between short- and long-term rates is deliberately ignored "to keep exposition simple".
- **Lags**: p = 12, following Gertler & Karadi (2015).
- **Frequency / span**: monthly, **T = 342**.

**FLAGGED — internal inconsistency in the paper on the sample end date.** The Introduction says the estimation sample is *"July 1979 to December 2007 (a sample that deliberately ends a half-year before the financial crisis begins)"*, and §5 repeats "uses the data until December 2007 — one semester before the financial crisis". But §3 states *"The time span of the monthly series is July 1979 to August 2008 (T = 342)"*. July 1979 → December 2007 is exactly 342 months; July 1979 → August 2008 is 350. The stated T = 342 is consistent with **December 2007**, so the "August 2008" in §3 appears to be an error in the published text. Do not propagate it without checking the published version.

- **Out-of-sample evaluation window**: observed levels of CPI, IP, 2yTB (GS2), FF from **December 2009 to July 2011**, with the forecast/band exercise run over the **12 months August 2010 → July 2011** (chosen to end just before the September 2011 "Operation Twist" announcement, footnote 17).

---

## 5. Statistical / numerical methods

- **Identification**: partial (set) identification of a *single* column B_1 via 1 zero restriction + 3 sign restrictions (Table 1, below).
- **Estimation of the reduced form**: multivariate least squares; robust sandwich (or HAC) estimator of Ω.
- **Bound computation**: exhaustive enumeration of active-constraint sets (Theorem 1 algorithm) — analytic, finite, global.
- **Inference**: delta method with the conservative max-over-active-sets standard error (4.3); normal critical value z_{1−α/2}.
- **Monte Carlo for coverage**: instead of resampling data, they draw **10,000 μ\* directly from N_d(μ, Ω/T)** with μ, Ω fixed at their UMP estimates and T = 342, deliberately "enforcing" the asymptotic normality of Assumption 4; Ω treated as known so estimation of Ω is not a confound. Nominal level **(1−α) = .68 ⟹ z_{1−α/2} = .9945**. Coverage measured as the probability that the *estimated identified set* [v(μ̂_T), v̄(μ̂_T)] is **contained in** the interval built from each draw μ\* — this yields a **lower bound** on coverage of the identified parameter.
- **Robust-Bayes credibility check**: 10,000 draws of μ\* from the posterior under an uninformative **Normal-Inverse-Wishart** prior (Uhlig 2005); reports the share of draws for which [v(μ\*), v̄(μ\*)] ⊂ the delta-method interval built at μ̂_T.
- **Empty-identified-set handling**: under Assumptions 1–4 the probability of an empty identified set at μ̂_T → 0, but it can still occur in a finite sample; the algorithm then returns max response = −c and min response = +c, and the authors' Matlab implementation emits a warning asking the user to drop restrictions (footnote 15).
- **Joint / simultaneous inference**: not the focus, but a **Bonferroni** correction over horizons and variables is offered (footnote 18), compared against Inoue & Kilian (2013)'s joint Bayes credible set (Appendix Fig. 8, §A.7.2).

---

## 6. Findings (with numbers)

### 6.1 The empirical identification scheme (Table 1)

Restrictions on **contemporaneous** responses to the UMP shock, with B_1 the first column of B:

| Series | Acronym | Sign on UMP | Notation |
|---|---|---|---|
| Consumer Price Index | CPI | + | e_1' B_1 ≥ 0 |
| Industrial Production | IP | + | e_2' B_1 ≥ 0 |
| 2-year Treasury Bond rate | 2yTB | − | e_3' B_1 ≤ 0 |
| Fed Funds Rate | FF | 0 | e_4' B_1 = 0 |

So **m_z = 1, m_s = 3, n = 4**: the UMP shock lowers the 2-year rate on impact, leaves the fed funds rate *exactly* unchanged on impact, and cannot lower inflation or output on impact. Justification for the signs: the calibrated DSGE of Bhattarai, Eggertsson & Gafarov (2015). Related scheme: Baumeister & Benati (2013), a Bayesian "spread" shock leaving the short rate unchanged while affecting the 10y-minus-policy spread.

Because the model is only set-identified, the authors explicitly caution that the analysis "captures the effects of *any* historical economic shock that affected the economy in the same way as an UMP shock" — not necessarily a policy shock.

### 6.2 Coverage guarantee claimed — and for **which object**

**Frequentist (Theorem 3a).** Under Assumptions 1–4 at μ = μ(P), and provided the asymptotic variance of the candidate value functions is strictly positive,
min_{x ∈ X_*(μ(P)) ∪ X*(μ(P))} ‖Ω^{1/2}(P) v̇_{k,i,j}(μ(P); r(μ(P);x))‖ > 0:

    liminf_{T→∞}  inf_{λ ∈ I^R_{k,i,j}(μ(P))}  P( λ ∈ CS_T(1−α) )  ≥  1 − α.

**This is coverage of every point λ in the identified set I^R_{k,i,j}(μ(P)) — i.e. coverage of the *true structural parameter*, uniformly over the identified set, not coverage of the identified set as a whole.** The property is **point-wise consistency in level**, explicitly *not* uniform consistency: footnote 14 states that building a *uniformly* consistent-in-level delta-method CS "is beyond the scope of this paper" and refers readers wanting uniformity to the **projection** approach of Gafarov, Meier & Montiel Olea (2016), noting the delta method is faster. §5 repeats that the delta method "is not guaranteed to have this property".

**Robust Bayes (Theorem 3b).** With Q ≡ Σ^{-1/2}B, a prior P\* factorizes as (P\*_μ, P\*_{Q|μ}); RBC(Y_1,…,Y_T) ≡ inf over all priors in the class P(P\*_μ) of the posterior probability that λ(A,B) ∈ CS_T(1−α) (eq. 4.4). If in addition Assumption 5 holds **and X\*(μ(P)) and X_*(μ(P)) are both singletons** (i.e. the bounds are *fully* differentiable, not merely directionally), then for any ε > 0, P( RBC < 1 − α − ε ) → 0. So the interval has **asymptotic robust Bayesian credibility of at least the nominal level** — valid regardless of the prior on the un-identified rotation Q, given the reduced-form prior.

### 6.3 Numerical / simulation results

- **Bound computation speed**: evaluating the endpoints for all 4 variables over **36 horizons takes ≈ 0.1 s**.
- **Full delta-method interval in the running example**: ≈ **0.15 s** on a standard laptop @ 2.4 GHz Intel Core i7.
- **Uhlig-style random grid search comparison**: with **D = 10,000** draws of a unit vector, the bias (grid search systematically *under*estimates the identified set) is "negligible" in this application, but the run takes ≈ **300 s** — a ~2,000× slowdown vs the analytic algorithm.
- **Added-restriction experiment**: adding the non-contemporaneous restriction e_2'(C_0 + C_1(A))B_1 ≥ 0 (cumulative IP response non-negative one month after impact) leaves the **upper bounds of the identified sets almost overlapping** (Fig. 1) — the non-contemporaneous constraint has **little additional identification power**.
- **Monte-Carlo frequentist coverage (Fig. 2)**: at nominal 68%, simulated coverage lies **between 68% and 84%** (the exception being the contemporaneous IRF for FFR, which is zero by assumption). Over-coverage is expected and consistent with Theorem 3 because the s.e. (4.3) is deliberately conservative. Footnote 16 notes Freyberger & Horowitz (2015) ideas could yield a tighter s.e. — left for future research.
- **Robust Bayes credibility (Fig. 3)**: simulated credibility "larger or close to" the nominal 68%, consistent with Theorem 3(b). Asymptotic-normal-approximation version in Appendix B.1, Fig. 5.

### 6.4 The QE2 application (§5) — the headline empirical numbers

- Trigger: the **August 2010 FOMC** announcement that the Committee would keep securities holdings constant by reinvesting principal payments from agency debt and agency MBS into longer-term Treasuries — the prelude to QE2 (Krishnamurthy & Vissing-Jorgensen 2011, p. 244).
- **From end-July 2010 to end-August 2010 the 2-year Treasury bond rate fell by 10 basis points.**
- Design: an econometrician standing in August 2010 uses only **pre-crisis data through December 2007**, deliberately discarding two years of post-crisis data to avoid structural change / stochastic volatility. Levels of all four variables are fixed at their **July 2010** values and traced forward 12 months using the delta-method CS for the **cumulative** IRFs to a **one-standard-deviation** UMP shock. CPI and IP are assumed to follow a linear trend, and sampling uncertainty from trend estimation is ignored in the bands. CPI and IP indices are normalized to a starting value of 100 in Fig. 4.
- **Result**: the observed dynamics of CPI, IP, GS2 and FFR from **August 2010 to July 2011 fall within the bounds**. The delta-method interval "misses the observed value at most three out of 12 months, which means that our 68% confidence set covers each of these variables at least 75% of the time." Conclusion: "pre-crisis data turns out to be extremely useful to learn about the post-crisis response of macroeconomic aggregates to unconventional monetary policy."

### 6.5 Computational comparison with competing procedures (the paper's practical selling point)

| Procedure | Reported cost | Notes |
|---|---|---|
| **This paper's delta method** | **≈ 0.15 s** | endpoints for 4 vars × 36 horizons ≈ 0.1 s |
| Uhlig (2005)-style random grid search for the bounds | ≈ 300 s | D = 10,000 draws; underestimates the set |
| **Giacomini & Kitagawa (2015)** robust-Bayes credible set | **≈ 9,106 s** | 10,000 posterior draws, *using this paper's algorithm for the endpoints*; of which 1,266 s just to compute the identified set per draw, the rest to convert posterior bounds into GK robust bounds (footnote 19) |
| **Granziera, Moon & Schorfheide (2017)** 68% Bonferroni CS | **≈ 4,000 s** | single-core, 10,000 grid points; algorithm in Appendix A.7.1. GMS17 also propose a projection-based CS, a special case of the Bonferroni one; no clear theoretical ranking among their variants, so the least computationally intensive was chosen (footnote 20) |
| **GMM16 projection** (Appendix B.1, Fig. 6) | not timed here | *wider* than the delta-method bands; contains the realized value of IP, CPI, 2yTB, FF at every horizon considered |

Length comparison: in this example the **68% delta-method CS is tighter than the 68% Bonferroni CS of GMS17 for almost all horizon × series combinations**. The authors are careful: no general theoretical length ranking exists; the efficiency ordering is DGP-dependent, and one plausible explanation for GMS17's greater length is that it is *uniformly* consistent in level over the class of DGPs where reduced-form IRFs are asymptotically normal — a property the delta method does not claim.

Two properties the authors could **not** verify for the delta method but which projection (GMM16) has: (i) **uniform** consistency in level over a reasonable class of DGPs, (ii) valid **simultaneous** inference covering the whole IRF across horizons and variables (the delta method is point-wise; Bonferroni is the offered patch).

---

## 7. Contributions

Stated three-fold (Introduction and Conclusion):

1. **Algorithm (Theorem 1)** to compute the largest and smallest value an IRF coefficient can attain over its identified set — for each horizon, each variable, a fixed μ, and a given collection of equality/inequality restrictions — **without random sampling from the space of orthogonal matrices or unit vectors**. The bounds are treated as value functions of a mathematical program whose KKT points are characterized analytically up to the set of active inequality constraints. **Reusable outside the delta-method framework** — e.g. as the inner loop of Giacomini & Kitagawa's robust-Bayes procedure (which is exactly how the 9,106 s benchmark was implemented).
2. **Sufficient conditions for directional differentiability of the bounds (Theorem 2)** in the reduced-form parameters — "of interest in its own right", and usable to study the frequentist properties of the GK15 robust-Bayes procedure.
3. **A computationally convenient delta-method interval (Theorem 3)** with sufficient conditions for **point-wise consistency in level** (frequentist) and **asymptotic robust Bayes credibility**, exploiting the specific structure of the directional derivative to build a conservative standard error that avoids estimating the argmax/argmin.

Framing: an explicit **generalization of Lütkepohl (1990)**'s delta-method inference for *point*-identified VARs to the set-identified case. The interval is literally "a plug-in estimator for the identified set plus/minus standard errors". The dual frequentist / robust-Bayes reading is presented as a feature.

---

## 8. Replication feasibility

**Favorable:**
- Data are public and standard: the **Gertler & Karadi (2015)** dataset (CPI, IP, 2yTB, FF), monthly, all series available from FRED-equivalents. p = 12, first differences of logs (CPI, IP) and levels (rates), T = 342.
- The method is **fully analytic** — Lemma 1 gives closed forms for the value function, both candidate maximizers and the projector M_{Σ^{1/2}r}; Lemma 2 gives closed-form gradients w.r.t. vec(A) and vec(Σ); (4.3) gives the standard error. No tuning parameters, no initial conditions, no tolerance levels, no simulation draws are required for the point estimate or the interval. The only "tuning" is the penalty constant c, which has an explicit lower bound c̄ = max_{i,k}(e_i'C_k(A)ΣC_k(A)'e_i)^{1/2}.
- The whole procedure runs in **~0.15 s**, so replication is cheap; the Monte Carlos are 10,000 draws each from a normal / NIW posterior.
- A **Matlab implementation exists** (referenced in footnote 15, which describes its warning behavior on an empty identified set). Open-access CC BY article, DOI `10.1016/j.jeconom.2017.12.004`.

**Frictions / gaps:**
- **All proofs and several key components are in appendices not present in these chunks**: Lemma 1 (A.1), Theorem 1 proof (A.2), Lemma 2 (A.3), Theorem 2 proof (A.4), Theorem 3 proof (A.5), the GMS17 Bonferroni algorithm (A.7.1), the Bonferroni/Inoue-Kilian joint inference (A.7.2), and Appendix B.1 (Figs. 5–9). Anyone re-deriving the estimator needs the supplementary material.
- **No repository URL, no code archive link, and no replication-package statement appear in the extracted text.** Flagged as not stated.
- **The Ω̂_T formula in footnote 13 as transcribed is missing an explicit normalization/closing** in the marker extraction (the leading T^{-1} is present but the expression's parenthesization is garbled by the PDF→md conversion) — verify against the published PDF before coding it.
- The **sample-end inconsistency** (December 2007 vs August 2008, §4 above) must be resolved before a replication can match T = 342.
- Volume/issue/pages unavailable from the text (see Bibliographic metadata).
- Figures 1–4 are image references (`_page_5_Figure_2.jpeg` etc.) — **no numerical values for the identified-set bounds or the QE2 bands are given in the body text**, only the qualitative statements and the "at most 3 of 12 misses ⟹ ≥ 75% coverage" figure. Exact IRF magnitudes cannot be recovered from the text alone.

---

## Relevance flags for this project (monetary_shocks_asset_prices)

Not part of the requested extraction, recorded only because the overlap is direct:
- Montiel Olea is a shared author with the **MOSW SVARIV** suite already vendored in `codigo_olea/` and used by `compute_factor_space_wald`. This paper is the *set-identified* sibling of that *proxy/external-instrument* line — different identification, same author's delta-method-and-weak-identification agenda.
- The **Fang & Santos (2015) result that the standard bootstrap is inconsistent for directionally differentiable functionals** is the relevant warning if the project ever moves from proxy to sign-restricted identification: the wild bootstrap machinery in `R/modeling/` would not transfer.
- The **single-shock scope restriction** matches this project's setup exactly (one monetary shock, all restrictions on one column), so the class covered here is applicable in principle — but the project's DFM has q = 6 factors, and Assumption 2 caps active constraints at n − 1.
