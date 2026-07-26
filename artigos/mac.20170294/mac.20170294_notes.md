# Notes — Caldara & Herbst (2019, *AEJ:Macro* 11(1)): Monetary Policy, Real Activity, and Credit Spreads — Evidence from Bayesian Proxy SVARs

## 1. Research question
(Methodological) How to embed an external proxy for monetary-policy shocks **inside a
single joint likelihood** with the SVAR, so that inference is coherent and **valid even
when the proxy is weak**? (Substantive) Does the systematic response of monetary policy to
credit spreads explain the dispersion of estimated MP effects in the Great Moderation?

## 2. Audience
Proxy-SVAR methodologists; monetary economists. The methodological half is the one that
matters here — it is the **Bayesian counterpart of Stock-Watson/Mertens-Ravn proxy SVARs**
(the exact framework this project uses).

## 3. Method (paradigm: BAYESIAN — joint likelihood, MCMC/SMC)
Standard SVAR `A_0 y_t = A_+ x_t + e_t`, MP shock = first shock. **Proxy measurement
equation**: `m_t = β e_{MP,t} + σ_ν ν_t`, ν_t ⟂ e_t (eq 7). Relevance
`ρ = corr(m,e_MP)² = β²/(β²+σ_ν²)` = signal-to-noise (Mertens-Ravn reliability). Augmented
system (eq 10-11) has a block-triangular Ã_0 encoding the exogeneity `E[m_t e_{NMP}]=0`.
- **Joint likelihood (eq 12)**: `p(Y|Φ,Σ) · p(M|Y,A_0,A_+,β,σ_ν)`. The second factor
  (unique to BP-SVAR) has `M|Y ~ N(β e_{MP,1:T}, σ_ν² I)`. The estimator gives more weight
  to structural parameters whose implied MP shock **looks like a scaled version of the
  proxy**. `β/σ_ν` governs identification; `β→0` ⇒ weak ID.
- The proxy identifies the **systematic component** (A_{0,1}, A_{+,1}) = the policy rule,
  and hence the shock.

## 4. Data
US monthly, 1994M1–2007M6 (T≈162). 4- and 5-equation VARs (ffr, IP, unemployment, PPI,
+Baa spread), 12 lags. Proxy: Kuttner-style high-frequency FOMC funds-futures surprises,
**30-min intraday window**, scheduled meetings only, monthly. Training sample 1990-93 for
the Minnesota prior.

## 5. Statistical / numerical methods
- Priors: Minnesota on (A_0,A_+); β ~ N(0,1); σ_ν ~ Inv-Gamma (baseline, weakly
  informative) OR **"high-relevance prior"** σ_ν = 0.5·std(M) dogmatic (forces the proxy
  to carry more signal, tighter credible sets, at the cost of fit).
- Samplers: **SMC** (robust when the posterior is irregular / proxy weak / high-relevance
  prior) and **MCMC** (baseline, faster). Section V(A) also gives a **frequentist**
  moment-based comparison — the method is not intrinsically Bayesian-only, but the paper's
  workhorse is Bayesian.
- **Four advantages over 3-stage proxy SVAR** (§I.E): (1) proxy informs BOTH reduced-form
  and structural params (3-stage wastes info); (2) **weak identification is not a problem
  per se in Bayes** (proper prior ⇒ valid inference, Poirier 1998) — vs frequentist
  needing MOSW weak-IV theory or bootstrap that "only applies to strong instruments"
  (Jentsch-Lunsford: bootstrap choice changes CIs a lot); (3) tune proxy informativeness
  via the prior; (4) suited to **large, richly parameterized models over short samples**.

## 6. Findings
Including the Baa spread flips the story: MP shock → IP −0.4%, unemployment +5bp, Baa
spread +5bp, prices fall (hump). MP rule reacts contemporaneously to spreads
(ψ_{0,cs} ≈ −1). Relevance ρ = 0.1 (baseline) → 0.4 (high-relevance, corr 0.63). Omitting
or Cholesky-restricting the spread response attenuates all IRFs ~40-100%. RR (2004) shocks
similarly contaminated by the spread response.

## 7. Contributions
The encompassing **Bayesian proxy SVAR (BP-SVAR)** — the canonical way to do proxy-SVAR
inference that is robust to weak instruments; widely adopted since.

## 8. Replication feasibility
*AEJ:Macro* → **replication package on openICPSR / AEA archive** (data + MATLAB code; the
BP-SVAR sampler is public and re-used across the literature, e.g. Braun-Brüggemann build
on the same prior family). ***CONFIRM exact openICPSR handle.*** Written for small VARs.

## Relevance to this project (factor-space integration)
- **The most on-point Bayesian answer to the user's exact complaint** ("proxy barely
  clears ξ_mp, some IRFs ambiguous"): BP-SVAR inference is **valid under weak proxies by
  construction**, so it does not need the Stock-Yogo/ξ_mp threshold at all, and it yields
  credible bands where the current wild bootstrap is on shaky ground for a near-threshold
  instrument (their own footnote: bootstrap proxy-SVAR CIs assume a strong instrument).
- Their substantive finding (MP rule reacts to **credit spreads**) is directly testable in
  the Brazil panel (ICC spreads, EMBI/CDS) and could reframe the "spread compression"
  puzzle already in the project.
- Same proxy family (Kuttner/GK surprises) as `z_jk_bs_purif` → the measurement equation
  maps cleanly onto the existing instrument.
- **Costs / frictions**: fully **Bayesian** (MCMC/SMC + Minnesota/relevance priors) —
  second inference apparatus beside the wild bootstrap; user's concern applies. Written
  for a small SVAR: adaptation = run the augmented model on the **q factor innovations**
  with `m_t=z`, then map IRFs to observables via Λ; the openICPSR MATLAB code does not do
  the factor mapping. Advantage (4) (large models / short samples) is philosophically
  congenial to a DFM but the code is a VAR, not a DFM.
