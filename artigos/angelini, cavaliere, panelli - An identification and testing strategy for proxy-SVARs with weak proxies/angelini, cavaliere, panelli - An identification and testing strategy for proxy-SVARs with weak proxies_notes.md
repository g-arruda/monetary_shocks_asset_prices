# Notes — Angelini, Cavaliere & Fanelli (2024, *J. Econometrics* 238(2), 105604): An identification and testing strategy for proxy-SVARs with weak proxies

## 1. Research question
When the external instrument for the *target* shock is **weak**, proxy-SVAR inference is
non-standard. Can we (i) get **frequentist, standard-asymptotics** inference on the target
IRFs anyway, and (ii) **test proxy strength** without the usual pre-testing distortions?

## 2. Audience
Frequentist proxy-SVAR practitioners facing weak instruments. Neighbors: Montiel Olea et
al. (2021, weak-IV AR), Jentsch-Lunsford (2019/2022, MBB), Caldara-Herbst (2019, Bayesian),
Giacomini et al. (2022, set-ID Bayesian), Caldara-Kamps (2017, instrument non-target).

## 3. Method (paradigm: FREQUENTIST — Minimum Distance + bootstrap)
SVAR `Y_t = Π X_t + u_t`, `u_t = B ε_t`, ε ~ (0,I). Target shocks ε_1 (k), non-target ε_2.
Parameters of interest = `B_•1` (impact of target shocks) and the IRFs `γ_•j(h)`.
- **Direct approach** (standard): instrument ε_1 with proxy `z_t` (possibly weak):
  `Σ_uz = B_•1 Φ'`.
- **Indirect identification (their contribution)**: use `A = B^{-1}`; the first-k rows
  `A_1•` satisfy the moment conditions `A_1• Σ_u A_1•' = I_k` (14) and, via **strong
  proxies `w_t` for the NON-target shocks** (`w_t = Λ ε̃_2 + ω`), `A_1• Σ_uw = 0` (15).
  Estimate `A_1•` by **Minimum Distance** (eq 17-18); recover `B_•1 = Σ_u A_1•'` (eq 2).
  **If `w_t` is STRONG for the non-target shocks, standard asymptotics apply** (Prop 2:
  MD estimator consistent + asymptotically Gaussian; delta-method or MBB bootstrap CIs) —
  the weak target proxy `z_t` is bypassed entirely. Order condition `a ≤ m`; for k>1 need
  `½k(k-1)` extra restrictions on `A_1•` (they rule out sign restrictions here, use linear
  constraints).

## 4. Data (illustrations)
Oil (Kilian 2009), n=3, monthly 1973-2004; target = oil supply shock, `z_t`=Kilian(2008)
proxy (robust F=9.4), non-target instrumented by World Steel Index + Brent futures innov.
Uncertainty (Ludvigson et al. 2021), n=3, 2008M1-2015M4 (T=88); k=2 uncertainty shocks
(impossible to instrument directly) recovered by instrumenting the single non-target
"real-activity" shock with a housing-starts innovation. Fiscal example in the supplement.

## 5. Statistical / numerical methods — the two usable tools
- **Bootstrap relevance PRE-TEST (§6, the headline tool):** the MBB-CMD estimator of proxy
  strength `θ̂*_T = (β̂*_2, λ̂*)` is asymptotically **Gaussian under strong proxies (Prop 3)**
  but **random & non-Gaussian under weak proxies à la Staiger-Stock (Prop 4)**. So test
  strength = **run a normality test (Doornik-Hansen multivariate / Lilliefors-KS
  univariate) on the N bootstrap replications** of the estimator, `N = [T^{1/2}]`. Reject
  normality ⇒ weak. **Robust to conditional heteroskedasticity AND zero-censored proxies**;
  works for any number of instrumented shocks.
- **No pre-testing bias (Prop 7, asymptotic independence):** post-test inference is
  unaffected by the test outcome — no Bonferroni needed. If not rejected → standard
  asymptotics; if rejected → weak-IV robust methods (MOSW AR or grid MBB AR), still
  unaffected by the screening. This is the property first-stage-F screening lacks
  (screening on F *worsens* coverage — their Fig. 1).
- The pre-test **applies to the target proxy `z_t` too** (remark vi; §7.1 applies DH to
  `z_t` directly, k=1). MBB block length `ℓ = 5.03 T^{1/4}`.

## 6. Findings
Oil: DH pre-test on Kilian's `z_t` gives p=0.004 → weak, endorsing MOSW AR; the indirect-MD
via strong non-target proxies yields **tighter** CIs than AR/grid-MBB-AR and matches
Kilian's recursive result (vertical short-run supply, Wald p=0.68). Uncertainty: indirect-MD
recovers both uncertainty shocks from one non-target instrument; sharper than the
volatility-regime approach.

## 7. Contributions
(a) A frequentist way to get **standard** inference on weak-target IRFs by instrumenting
the **non-target** shocks (indirect-MD). (b) A **bootstrap strength test** robust to
conditional het / zero-censoring, valid for multiple shocks, **free of pre-testing bias**.

## 8. Replication feasibility
**No public replication package (verified 2026-07-24).** MATLAB, "codes available upon
request from the authors" (footnote 17). Confirmed: Giovanni Angelini's publications page
tags the 2019 Angelini-Fanelli paper "[MATLAB code]" but lists the 2024 weak-proxies paper
**with no code link**; the Exeter/figshare record exposes only the PDF; arXiv 2210.04523 has
no code. ⇒ the bootstrap strength test + indirect-MD would have to be **coded from scratch**
(or requested from the authors), on top of the factor-space adaptation. The project already
ships `codigo_olea` for the MOSW AR piece. Supplement at doi.org/10.1016/j.jeconom.2023.105604.

## Relevance to this project (factor-space integration)
- **Directly usable NOW (k=1, single MP proxy):** run the **bootstrap relevance pre-test**
  on `z_jk_bs_purif` — its robustness to **zero-censored** proxies fits the JK-masked
  instrument (mask zeros non-monetary Copom days + no-Copom months) far better than the
  robust-F/ξ_mp, which assume no censoring. A cleaner strength verdict for the (7,6) that
  "raspa o limiar," and (Prop 7) it does not distort the downstream IRF bands.
- **Weak-IV robust bands at k=1:** MOSW Anderson-Rubin set (already in the pipeline via the
  ξ_mp/AR machinery) or grid MBB AR (Jentsch-Lunsford 2022) — both frequentist.
- **Novel route worth exploring:** the **indirect-MD** — build a *strong* proxy for a
  **non-target** factor shock (e.g. a commodity/Brent-innovation shock, a global-risk/VIX
  shock, or a fiscal-surprise shock — all plausible in the Brazil panel) and identify the
  MP IRFs *indirectly*, sidestepping the weak MP proxy entirely and recovering **standard
  asymptotics**. This is the most creative use for the project and stays fully frequentist.
- **Cost/frictions:** written for a VAR → factor-space adaptation (run on the q factor
  innovations, propagate via Λ); MATLAB, code-on-request. The indirect route needs a
  genuinely strong non-target proxy, which must be constructed and pre-tested.
