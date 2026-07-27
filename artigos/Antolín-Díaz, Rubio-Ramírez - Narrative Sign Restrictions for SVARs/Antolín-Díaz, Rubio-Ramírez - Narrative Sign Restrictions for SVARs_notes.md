# Notes — Antolín-Díaz & Rubio-Ramírez (2018, *AER* 108(10)): Narrative Sign Restrictions for SVARs

## 1. Research question
Traditional sign restrictions are set-identified and often too weak to be informative. Can
a **small number of well-documented historical episodes** ("narrative sign restrictions")
sharpen the identified set — even a *single* event?

## 2. Audience
Sign-restriction / set-identified SVAR community; anyone with strong priors about specific
historical episodes. Builds directly on Rubio-Ramírez-Waggoner-Zha (2010) and
Arias-Rubio-Ramírez-Waggoner (2018).

## 3. Method (paradigm: BAYESIAN — importance-sampling over rotations)
Standard SVAR; identification via `Q ∈ O(n)` rotation. **Two classes of narrative
restriction**, imposed *in addition to* traditional sign restrictions:
- **(A) Sign of a structural shock at a date**: e.g. `e_{MP}(t_Volcker) > 0` (a
  contractionary MP shock occurred in Oct 1979).
- **(B) Historical-decomposition restrictions**: a shock was the *most important* (Type A:
  |contribution| > any single other) or *overwhelming* (Type B: > sum of all others)
  driver of a variable's unexpected move in an episode. These proved the most effective at
  shrinking the set.
- **Key mechanism**: traditional sign restrictions truncate the **prior**; narrative sign
  restrictions truncate the **likelihood** (because they depend on the structural shocks,
  not just parameters) → the posterior is a **reweighting** of the likelihood with
  importance weights `1/ω(B,Σ,Q)`, where ω = prior prob. of satisfying the restriction
  (Algorithm 1: draw NIW + uniform-O(n), keep if traditional+narrative hold, resample by
  1/ω).

## 4. Data (applications)
Two canonical models: (i) oil market (Kilian-Murphy 3-var); narrative event = Gulf War
Aug 1990. (ii) Monetary policy (Christiano-Eichenbaum-Evans / Uhlig 2005 setup); narrative
event = Volcker reform Oct 1979. Both previously identified by traditional sign
restrictions.

## 5. Statistical / numerical methods
Importance sampler on top of the Arias-Rubio-Ramírez-Waggoner (2018) NIW-uniform draws;
the reweighting by 1/ω is essential (naive discard biases the posterior). Uniform-O(n)
prior; the prior does not wash out in set-ID (standard caveat).

## 6. Findings
Narrative restrictions are **highly informative**: a single event (Gulf War) sharply
separates oil demand vs supply; the Volcker restriction overturns Uhlig's (2005) MP result
by discarding parameters with implausible Oct-1979 implications. Historical-decomposition
(Type A/B) restrictions are the most effective.

## 7. Contributions
Formalizes and operationalizes "narrative + sign restrictions" — brings agreed-upon
historical facts into set-identified SVARs with a clean posterior algorithm.

## 8. Replication feasibility
*AER* → **replication package on the AEA/openICPSR archive** (MATLAB; the code is a widely
used extension of the Arias-Rubio-Ramírez-Waggoner 2018 / RWZ 2010 toolbox — the same
codebase Braun-Brüggemann and much of the sign-restriction literature reuse).
***CONFIRM exact handle.*** Written for small VARs.

## Relevance to this project (factor-space integration)
- **Exploits Brazil's well-documented episodes** — 2015 fiscal crisis + Dilma, 2016
  impeachment, the 2021-22 Selic tightening cycle, the 2020 COVID cut, specific Copom
  surprises. E.g. "a contractionary MP shock was the dominant driver of the yield jump in
  Copom month X," or "the 2021-22 hikes were monetary-driven." Even one credible event can
  sharpen the set (their headline).
- Independent of the instrument's strength — a robustness cross-check that does not lean on
  ξ_mp at all; and narrative restrictions can be *combined with* an external instrument
  (as Braun-Brüggemann note, plausibly-exogenous proxies are closely related to narrative
  restrictions).
- **Costs / frictions (largest of the five)**: (a) fully **Bayesian** + **set-identified**
  — the biggest departure from the current point-estimate + wild-bootstrap pipeline
  (moves to a posterior over a set). (b) Needs a **traditional sign-restricted SVAR as the
  base** (narrative only complements) → you must first stand up a sign-restricted DFM.
  (c) Requires **factor-space adaptation** AND a subtlety: narrative restrictions live on
  the structural shocks / historical decomposition of the *observables*, which in a DFM
  are Λ·(factor shocks) — so the historical decomposition must be computed in observable
  space from the q-factor rotation. (d) Real **data/judgment work** to pick and defend
  episodes. The MATLAB toolbox does none of the factor mapping.
- On the author's open menu (`pendencias.md` line 26: "bayesiana Uhlig/Arias-Rubio-
  Ramírez-Waggoner, combinável com o SDFM").
