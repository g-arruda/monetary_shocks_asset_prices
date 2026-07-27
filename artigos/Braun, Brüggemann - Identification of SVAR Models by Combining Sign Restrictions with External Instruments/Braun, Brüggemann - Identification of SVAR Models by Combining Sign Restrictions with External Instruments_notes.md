# Notes — Braun & Brüggemann (2022, BoE Staff WP 961): Identification of SVARs by combining sign restrictions with external instruments

## 1. Research question
How to **combine sign restrictions with an external instrument (proxy)** in one SVAR, to
(i) sharpen a weak/finite-sample-noisy proxy identification, and (ii) formally **test**
whether the sign or IV restrictions are supported by the data (over-identification)?

## 2. Audience
Proxy-SVAR and sign-restriction practitioners; anyone whose instrument is weak or only
"plausibly exogenous." Direct methodological neighbors: Caldara-Herbst (2019), Arias et
al. (2021), Giacomini et al. (2021), Ludvigson et al. (2020), Nguyen (2019).

## 3. Method (paradigm: BAYESIAN — MCMC over an augmented B-model SVAR)
Augmented B-model SVAR (eq 2.2): stack `(y_t, m_t)`, with measurement equation
`m_t = ν_m + Φ ε_t + Σ_η^{1/2} η_t`, η_t ⟂ ε_t. IV validity = exclusion+relevance on Φ:
exogeneity `φ_1 = 0` (m uncorrelated with non-target shocks), relevance `φ_2 ≠ 0`.
**Two settings:**
- **Setting 1 — valid instrument + sign restrictions.** Sign restrictions either (a)
  identify additional orthogonal shocks the IV doesn't reach, or (b) act as EXTRA info on
  the IV-identified shock — "particularly valuable when the external variables are only
  **weakly informative**" / to sharpen finite-sample inference.
- **Setting 2 — "plausibly exogenous" proxy.** Replace exogeneity with **inequality
  bounds**: correlation threshold `ρ_1 > c_1`, variance-contribution threshold
  `ω_1* > c_2*` (where 1−c_2* = max endogeneity tolerated), or rotation-invariant
  **ranking** `ω_1 > Σ_{j≥2} ω_j` (the target shock explains more of the proxy than all
  others combined). Combine with conventional sign restrictions.

## 4. Data (applications)
- Oil market: 4-var VAR(13), monthly 1978M08–2018M11; Kilian OPEC-shortfall series as IV
  for supply + KM14 sign restrictions.
- **Monetary policy (§3.2): monthly SVAR(12)**, `y=(gdp,def,cp,tr,nbr,ffr)`, 1969M1–
  2007M12; proxy = Romer-Romer narrative shock (plausibly exogenous). Sign restrictions =
  Arias-Caldara-Rubio-Ramírez policy-rule restrictions.

## 5. Statistical / numerical methods
- Gaussian likelihood; **conjugate prior on B̃** (all restriction-satisfying B-models get
  equal prior density — no unintended identifying info); independent Minnesota prior on
  AR coefficients (allows dogmatic exclusion so instrument doesn't feed y-dynamics).
- **MCMC**: Accept-Reject Metropolis-Hastings with the **Arias et al. (2018)** efficient
  proposal, iterating p(Ã|B̃,Y) [Gaussian] and p(B̃|Ã,Y) [AR-MH]. Caveat: this proposal
  **cannot handle over-identifying exclusion restrictions** (one shock, several
  instruments) → would need the Caldara-Herbst sampler instead. Not a concern for a
  single shock + single instrument (the user's case).
- **Bayes factors (§2.5)** via **Savage-Dickey density ratio** (Φ conditionally
  matrix-normal under the conjugate prior): test IV exogeneity (`φ_1=0`) or relevance
  (`φ_2=0`) inside a sign-identified model, or test sign restrictions as over-ID. Prior
  matters in set-ID and doesn't wash out → must be defended (training-sample hyperparams).

## 6. Findings
- Oil: adding the IV makes the (otherwise prior-sensitive) supply-elasticity choice
  nearly irrelevant; FEVD of supply settles ~6–12%.
- **MP (directly relevant): the Bayes factor REJECTS Romer-Romer exogeneity (2 ln BF =
  14.49)** inside the ACR sign-identified model. Using R&R as a pure IV gives a price
  puzzle + perverse policy rule (Fed cuts on higher inflation). But keeping R&R as
  *plausibly exogenous* via the ranking `ω_1 > Σ ω_j` **sharpens the set** dramatically —
  tighter credibility sets, sensible policy rule, and clear financial responses (stocks
  fall, excess bond premium rises) that pure sign restrictions leave undetermined.

## 7. Contributions
A unified Bayesian framework to (i) sharpen a weak/plausibly-exogenous proxy with sign
restrictions and (ii) test IV/sign restrictions as over-identifying via easy Bayes
factors. Rotation-invariant variance-contribution restrictions work in partially
identified models.

## 8. Replication feasibility
BoE Staff WP → **replication code exists** (MATLAB; Robin Braun / Ralf Brüggemann
maintain proxy-SVAR + sign-restriction Bayesian code; the sampler builds on the widely
distributed Arias-Rubio-Ramírez-Waggoner 2018 toolbox). ***CONFIRM the exact repo/URL.***
Written for small VARs; no factor-model wrapper.

## Relevance to this project (factor-space integration)
- **Most directly on-point for the user's exact predicament**: a proxy that is *at best
  plausibly exogenous* (the RS-2004 Wed→Thu critique the author already flagged) **and**
  weak/at-threshold (ξ_mp ≈ 10.4). B&B is designed to (a) not need full exogeneity
  (Setting 2 bounds), and (b) sharpen finite-sample inference with sign restrictions when
  the IV is weakly informative (Setting 1b). It directly attacks BOTH problems the user
  reported.
- Turns the identification from point (proxy only) to **set** (proxy + sign), with
  credibility sets that TIGHTEN relative to sign-only — the opposite of the usual "set-ID
  is uninformative" complaint.
- Gives a Bayes-factor **test of the proxy's exogeneity** — a robustness check the current
  frequentist pipeline cannot produce.
- **Costs / frictions**: (a) fully **Bayesian** (MCMC + priors) — a second inference
  apparatus beside the wild bootstrap; user's stated concern applies. (b) Written for a
  small SVAR: to fit the DFM, run the augmented B-model on the **q factors** with `m_t=z`,
  and impose the sign restrictions on the **observable IRFs Λ·Θ_j** (curve↑, IBOV↓,
  activity↓) — i.e. sign restrictions live in observable space while the rotation is q×q.
  Feasible but non-trivial plumbing; the MATLAB package does not do the factor mapping.
- Fits the author's own open menu (`pendencias.md` line 26: "sign restrictions set-ID …
  combinável com o SDFM").
