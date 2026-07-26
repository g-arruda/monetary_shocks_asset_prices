# Notes — Lanne, Meitz & Saikkonen (2017, *J. Econometrics* 196(2)): Identification and estimation of non-Gaussian SVARs

## 1. Research question
Can a SVAR be identified **without** economic restrictions (short-run/long-run/sign) by
exploiting **non-Gaussianity + independence** of the structural shocks? And can the usual
economic restrictions then be **tested** rather than assumed?

## 2. Audience
SVAR econometricians; anyone doing structural identification who is uneasy about
untestable Cholesky/sign restrictions. Direct competitors: Hyvärinen et al. (2010),
Moneta et al. (2013) (both impose recursiveness), Lanne-Lütkepohl (2010) (Gaussian
mixture), heteroskedasticity ID (Rigobon 2003 — explicitly NOT covered).

## 3. Method (paradigm: FREQUENTIST, maximum likelihood)
SVAR (1): `y_t = ν + A_1 y_{t-1} + … + A_p y_{t-p} + B ε_t`, B nonsingular.
- **Assumption 1**: ε_t i.i.d.; components **mutually independent**, **at most one Gaussian**.
- **Prop 1** (statistical ID up to perm+scale): under non-Gaussianity+independence, the
  MA representation is unique except columns of B permuted/scaled (`B*=BDP`). Enough for
  IRFs once you fix labels/sign/scale.
- **Prop 2 + "Identification Scheme"** (adapted from Ilmonen-Paindaveine 2011): a
  normalization (unit-norm columns → permutation so |c_ii|>|c_ij| → diag=1) picks a
  UNIQUE representative B ⇒ **complete identification**, needed for standard ML asymptotics.
- Identification is **"statistical, not economic"**: the q shocks carry no labels; you
  attach labels from OUTSIDE (sign restrictions, inspection of IRFs, or an external
  instrument/proxy). ← this is exactly the hook for the user's proxy.

## 4. Data (empirical application)
US quarterly, 4-var SVAR: output gap, inflation (GDP deflator), Kansas City Financial
Conditions Index (KCFCI), fed funds rate. Sample **1990Q1–2008Q2, only T=74 obs**.
Errors: independent Student-t (own df λ_i per equation). Source: FRED + KC Fed.

## 5. Statistical / numerical methods
- **ML estimator** (Assumption 2: pick a parametric non-Gaussian density per component,
  e.g. Student-t; Theorem 1: consistent + asymptotically normal, standard sandwich covariance).
- **Three-step estimator (§4.5)** for "computationally demanding / short T / high
  dimension n": (1) LS for AR params, (2) ML for error/B params on LS residuals, (3)
  re-ML for AR. **Asymptotically efficient under a Symmetry Condition**, block-diagonal
  info matrix. ← the practical estimator for a q-factor block with modest T.
- **§4.6 Testing** (the headline feature): because B is completely identified with
  standard asymptotics, economic restrictions that are exactly-/under-identifying in the
  Gaussian case become **TESTABLE** by ordinary Wald/LR/LM (χ²_r). Covers: recursive
  (Cholesky, r=n(n-1)/2), non-recursive short-run zero restrictions, long-run
  Blanchard-Quah. Sign restrictions still can't be tested (Fry-Pagan). Caveat: null must
  keep B inside the identified set 𝓑, and the permutation is fixed by the scheme — so
  label shocks (via IRF inspection/signs) BEFORE testing.
- Covers **conditional** heteroskedasticity (weaker Assumption 1*), NOT **unconditional**
  het (Rigobon 2003) — i.e. exactly the approach that already failed for this project.

## 6. Findings
Reduced-form VAR(2) selected; multivariate Jarque-Bera **soundly rejects normality at
1%**, residuals leptokurtic ⇒ identification premise holds. MP shock (labeled as the only
shock with significant + impact on the interest rate) → significant **negative immediate
impact on financial conditions**, ~1 year; negative on inflation/output. **Recursive
identification rejected** (LR p=0.071, Wald p=0.025). 68% Hall bootstrap bands, 1000 reps.

## 7. Contributions
General non-Gaussian ID that nests recursive as a special case (doesn't impose it);
complete-ID + standard ML asymptotics ⇒ makes conventional restrictions **testable** — a
sharp break from traditional ID where the maintained restrictions can't be checked.

## 8. Replication feasibility
Open-access article (CC BY-NC-ND). No official code archive in the paper, but the method
is implemented off-the-shelf in the **R package `svars`** (`id.ngml` = non-Gaussian ML;
Lange, Dalheimer, Herwartz, Maxand, *JSS* 2021). T=74 empirical shows it works at short
samples. Student-t density + three-step is straightforward to code directly.

## Relevance to this project (factor-space integration)
- Runs on the **q factor-VAR innovations η** (treat η as the "reduced-form errors"),
  identify the q independent non-Gaussian components, then **label the monetary column by
  the proxy** (max |corr| with z_jk_bs_purif). Propagate via Λ exactly like the existing
  proxy/het branches.
- **Robust to weak IV**: identification does NOT use the instrument — the proxy is only a
  labeler. So an ambiguous/at-threshold ξ_mp does not degrade the ID.
- **Turns the proxy into a testable over-identifying restriction**: with B completely
  identified, you can test whether the non-Gaussian MP column ≈ proxy-implied column (LR/Wald).
- Precondition: factor innovations must be non-Gaussian with ≤1 Gaussian component
  (leptokurtosis from Brazil + COVID is plausible; would need a JB/kurtosis check on η).
- Cost: new `identification = "nongaussian"` branch; `svars::id.ngml` or a direct
  three-step ML in R. Same language as the project.
