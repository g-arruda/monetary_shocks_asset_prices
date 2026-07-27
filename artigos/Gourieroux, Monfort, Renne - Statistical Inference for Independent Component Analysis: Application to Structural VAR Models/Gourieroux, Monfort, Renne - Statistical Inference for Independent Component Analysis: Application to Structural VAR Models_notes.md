# Notes — Gouriéroux, Monfort & Renne (2017, *J. Econometrics* 196(1)): Statistical inference for ICA — application to SVARs

## 1. Research question
Same premise as Lanne-Meitz-Saikkonen: if structural shocks are independent and ≤1
Gaussian, the SVAR is identified by **Independent Component Analysis (ICA)**. But the
true shock densities are unknown — do **pseudo-ML (PML)** estimators (which maximize a
*misspecified* likelihood) stay **consistent**, and what is their asymptotic distribution?

## 2. Audience
Same SVAR/ID community; the ICA/signal-processing crossover. Explicitly positioned as
the **semi-parametric generalization of LMS (2015/2017)** — LMS assume the parametric
form of the true densities is known; GMR relax that.

## 3. Method (paradigm: FREQUENTIST, semi-parametric / pseudo-ML)
Model `Y = C ε` (here Y = prewhitened reduced-form residuals, so C is **orthogonal**,
SIR3). At most one ε_i Gaussian ⇒ C identified up to column permutation + sign (Comon
1994 / Eriksson-Koivunen 2004).
- **PML estimator**: `Ĉ = argmax_C Σ_t Σ_i log g_i(c_i' Y_t)` s.t. C'C=Id, with `g_i`
  chosen pseudo-densities. Orthogonal C parametrized by **Cayley transform** of a skew-
  symmetric A.
- **Prop 3**: PML is **consistent even if the g_i are misspecified** (FOC reduce to zero
  cross-moment conditions `E[c_j'Y · d log g_i/dε(c_i'Y)]=0`, i≠j — hold at the truth by
  independence). **Prop 4**: asymptotically normal, √T, closed-form covariance.
- **Prop 2**: fails if ≥2 sources Gaussian, OR if ≥2 pseudo-densities are Gaussian
  (⇒ need genuinely non-Gaussian g_i).
- **Corollary 1**: efficiency maximal when g_i = true density. **Choosing g_i "as far
  from Gaussian as possible" via 3rd/4th cumulants (skew/kurtosis) is SUBOPTIMAL**,
  especially near-Gaussian ⇒ the naive "kurtosis-max" ICA is dominated; two-step adaptive
  (nonparametric density then re-PML) recovers efficiency.

## 4. Data (application)
Small-scale VAR on **US macroeconomic data** (§3, not in this chunk); tests standard
short-run over-identification schemes. MC studies: bivariate C_0, T=200/500/5000,
Student-t + hyperbolic-secant sources.

## 5. Statistical / numerical methods
- **Global PML** vs **recursive PML** (= deflation-based FastICA): recursive estimates
  columns one at a time; **less accurate** (MC RMSE 2–3× worse) but scales to large n.
  For small q (this project q=6) prefer **global PML**.
- **Testing (§2.5)**: Wald statistic `ξ̂_j = T[vecĈ − vecC_{j,0}]' … [vecĈ − vecC_{j,0}]`
  → χ²(n(n−1)/2); `ξ̂ = min_j ξ̂_j` is asymptotically pivotal. Tests whether C equals a
  restricted (e.g. recursive / short-run) matrix — the usual SVAR restrictions are
  **over-identifying** in the non-Gaussian case and thus testable.
- Requires **prewhitening** (V(Y)=Id) so identification is on standardized residuals.
- MC: asymptotic normal approx is good **already at T=200**; misspecified pseudo-densities
  barely raise RMSE.

## 6. Findings
PML consistent under density misspecification (main theoretical result); asymptotic
distribution derived and validated in small samples; usual SVAR over-ID restrictions can
be tested. Empirically, non-Gaussian VAR identified without extra restrictions, and the
recursive scheme is testable.

## 7. Contributions
Fills the gap flagged by Ilmonen et al. — ICA as a *statistical estimator* with proper
asymptotics, not just an algorithm. Robustness of consistency to pseudo-density
misspecification is the key practical takeaway (you don't need the true density right).

## 8. Replication feasibility
*J. Econometrics* accepted manuscript; online appendix with proofs. No official archive
cited, but the estimator family is available in R: **`svars`** (`id.dc` distance-
covariance, `id.cvm` Cramér-von Mises — dependence-based ICA; and `id.ngml` for the
parametric-PML twin). Cayley/PML is also easy to code directly (FastICA is in R `fastICA`
but statistically less efficient per this paper).

## Relevance to this project (factor-space integration)
- Same integration path as LMS: run ICA/PML on the **prewhitened q factor-VAR innovations
  η**, label the monetary component by the proxy, propagate via Λ.
- **Complements LMS**: LMS = parametric ML (need a density guess); GMR = pseudo-ML
  (consistent even if the density guess is wrong). Report both ⇒ robustness of the
  non-Gaussian route to the density assumption. GMR is the safer estimator to headline
  because it does not hinge on getting the Student-t df right.
- The "kurtosis" family the user asked about lives HERE: cumulant/kurtosis-based ICA is a
  special case, and GMR shows it is **suboptimal** — so recommend dependence-based /
  adaptive PML, not raw kurtosis maximization.
- Same weak-IV robustness and "proxy becomes a testable restriction" logic as LMS.
- Precondition again: ≤1 Gaussian factor innovation; prewhiten η first.
