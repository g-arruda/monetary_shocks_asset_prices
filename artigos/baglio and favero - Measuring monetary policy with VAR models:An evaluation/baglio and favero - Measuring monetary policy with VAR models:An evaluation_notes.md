# Bagliano & Favero (1998) — "Measuring monetary policy with VAR models: An evaluation"

Structured extraction notes (from the marker-converted `.md`, 3 chunks, read in full).

---

## Bibliographic metadata

| Field | Value | Source |
|---|---|---|
| Title | Measuring monetary policy with VAR models: An evaluation | Chunk 01, header |
| Authors | Fabio C. Bagliano; Carlo A. Favero | Chunk 01 (note: the folder name spells it "baglio", the paper itself reads **Bagliano**) |
| Affiliations | Bagliano: Dipartimento di Scienze Economiche e Finanziarie "G. Prato", Università di Torino, Corso Unione Sovietica 218bis, 10134 Torino, Italy. Favero: Università "L. Bocconi", Via Sarfatti 25, 20136 Milano, Italy; and CEPR, London, UK | Chunk 01 |
| Corresponding author | Bagliano (tel. 39-11-670 6084; e-mail bagliano@econ.unito.it) | Chunk 01 |
| Journal | European Economic Review | Chunk 01, running head |
| Volume | 42 | Chunk 01 ("European Economic Review 42 (1998) 1069—1112") |
| Year | 1998 | same line |
| Pages | 1069–1112 | same line |
| Issue number | **Not stated in the chunk text.** Only "42 (1998)" appears; the parenthetical is the year, not an issue. Do not invent an issue number. | — |
| DOI | **Not present in the chunk text.** | — |
| Publisher line | "© 1998 Elsevier Science B.V. All rights reserved." (rendered as "( 1998" by the OCR) | Chunk 01 |
| JEL codes | E44; E52 | Chunk 01 |
| Keywords | Monetary transmission; VAR models | Chunk 01 |
| Venue history | Presented at ISOM; discussants Jim Stock and Stefan Gerlach; two referees. Christiano-Eichenbaum-Evans (1996b) is also cited as "Paper presented at ISOM, 1996", so the paper belongs to an ISOM conference issue — **the issue number is still not given in the text.** | Chunk 03, Acknowledgements |

**Flagged as supplied from outside the text:** nothing. Every field above is either quoted from the chunks or explicitly marked as absent.

**Internal inconsistency to be aware of when citing:** §3 states the estimation sample begins in **1966(1)**; the Conclusions (§6) refer to "the whole sample period (1965—1996)". The tables and all subsample lists use 1966:1. Cite 1966:1–1996:3.

---

## 1. Research question

The paper asks whether VAR models routinely used to measure US monetary policy are a *statistically adequate and identification-credible* device for recovering monetary policy shocks — and, crucially, whether the shocks such VARs produce are the same object that financial markets price.

Three explicitly stated questions (abstract, §1, §6), organised as "specification, identification, and the effect of the omission of the long-term interest rate":

1. **Specification.** Is the reduced-form benchmark VAR well specified (homoscedastic innovations, constant parameters) over the samples on which it is routinely estimated? "the reduced form of the system must be well specified (i.e. its residuals must be homoscedastic innovations and it must have constant parameters) to be validly used as a statistical framework for the formulation and testing of alternative structural hypotheses".
2. **Identification.** Are VAR-based monetary policy shocks similar to shocks measured *directly from financial markets*, and — if not — do they nonetheless deliver the same monetary transmission mechanism? The framing is taken from Rudebusch (1996): "(i) 'Does a VAR funds rate equation correctly model reactive Fed policy?', and (ii) 'Do its residuals plausibly represent monetary policy shocks?'. Rudebusch's answer to both questions is simply no."
3. **Omitted long rate.** What is lost by the near-universal practice of excluding a long-term interest rate from monetary VARs, and does the transmission of a policy contraction actually run through long rates?

Stated purpose (§1): "The main purpose of this paper is to assess the properties of these different measures for the United States, evaluating the implied dynamic responses of the economy to monetary policy shocks using a common benchmark VAR model."

---

## 2. Audience

- Macro-econometricians working on SVAR measurement of monetary policy — the Bernanke-Mihov / Strongin / Christiano-Eichenbaum-Evans / Leeper-Sims-Zha reserve-market identification programme, which the paper takes as its benchmark and stress-tests.
- Participants in the mid-1990s Rudebusch-vs-Sims dispute over whether VAR residuals mean anything; the paper is explicitly adjudicating that debate ("casts serious doubts on the statement that VAR-based monetary policy shocks do not make sense").
- Applied monetary economists using high-frequency / market-based policy surprises (fed funds futures, announcement-day short-rate changes, forward-rate-implied surprises) — this paper is one of the earliest systematic *comparisons* of those measures against VAR shocks.
- LSE-tradition specification testers: the whole of §3 is a Hendry/Spanos-style statistical-adequacy audit run on a mainstream US monetary VAR (software: PcFIML).
- Term-structure and transmission-mechanism researchers (§5).

---

## 3. Method — identification strategy and paradigm

### 3.1 Paradigm

Structural VAR in the Cowles-vs-VAR framing. The common structure is written as

`A [Y_t; M_t] = C(L) [Y_{t-1}; M_{t-1}] + B [v^Y_t; v^M_t]` (2.1)

with reduced form (2.2) and the residual mapping `A [u^Y; u^M] = B [v^Y; v^M]` (2.3). Y = macro non-policy variables (output, prices), M = policy-controlled variables.

Their epistemic position is explicit and unusually careful — worth quoting for a literature review:

> "VAR models and structural Cowles Commission models of the monetary transmission mechanism specify the same statistical model (i.e. reduced form) of the data generating process, and therefore, in general, also the VAR approach is subject to the Lucas and Sims critique."

> "VAR models of the transmission mechanism are not estimated to yield advice on the best monetary policy; they are rather estimated to provide empirical evidence on the response of macroeconomic variables to monetary policy impulses in order to discriminate between alternative theoretical models of the economy. Monetary policy actions should be identified using theory-free restrictions, taking into account the potential endogeneity of policy instruments."

> "The Lucas critique could be made irrelevant by estimating such models on a single policy regime."

They also answer the "central banks as random number generators" charge: "monetary policy rules are explicitly estimated in structural VAR models. However, the focus is not on rules but on deviations from rules, since only when central banks deviate from their rules it becomes possible to collect interesting information."

### 3.2 The benchmark identification (three restriction blocks)

A structural model is identified by: "(i) assuming orthogonality of the structural disturbances; (ii) imposing that macroeconomic variables do not simultaneously react to monetary variables, while the simultaneous feedback in the other direction is allowed, and (iii) imposing restrictions on the monetary block of the model reflecting the operational procedures implemented by the monetary policy maker."

Defence of (ii) and (iii): "In models estimated on monthly data, restrictions (ii) are consistent with a wide spectrum of alternative theoretical structures and imply a minimal assumption on the lag of the impact of monetary policy on macroeconomic variables, whereas restrictions (iii) are based on institutional analysis."

Reserve-market block (Bernanke-Mihov 1995), in VAR-residual form:
- `u^TR = −α u^FF + v^D` (2.4) — total reserve demand
- `u^BR = β u^FF + v^B` (2.5) — borrowed reserve demand (rendered as `u^BR = u^FF + v^B` by OCR; β appears in the A matrix)
- `u^NBR = φ^D v^D + φ^B v^B + v^S` (2.6) — Fed's nonborrowed-reserve supply; **`v^S` is the monetary policy shock to be identified**

Nesting of operating procedures (from Bernanke-Mihov 1995 / Strongin 1995):
- Funds-rate targeting: φ^D = 1, φ^B = −1 (mid-60s–1979 and **1988 onwards**)
- Nonborrowed-reserve targeting (1979–1982): φ^D = φ^B = 0
- Borrowed-reserve targeting (post-1982, per Strongin): φ^D = 1, φ^B = α/β

Under these, `v^S` is respectively the orthogonalised FF-equation residual, the orthogonalised NBR residual, or the linear combination `u^TR − u^NBR`.

Production identification for the 1988:11–1996:3 sample: φ^D = 1, φ^B = −1, which imposes **one over-identifying restriction**, `d_65 = −1`.

### 3.3 On recursive / Cholesky identification — verbatim, for the lit review

This is the material the parent task flagged. The paper is *not* a frontal attack on Cholesky; it is a defence of credible-restriction SVARs that nevertheless registers three distinct reservations.

**(a) The Sims critique applies to contemporaneous-matrix restrictions too:**
> "In fact, the criticism that structural equation restrictions are incredible could just be refereed [referred] to the contemporaneous correlation matrix restrictions generally used in the VAR literature; similarly the Lucas critique also applies to this type of models, given their backward-looking autoregressive structure."

**(b) They refuse to give the Cholesky-orthogonalised non-policy block any structural interpretation:**
> "VAR residuals from the first three equations, describing the nonpolicy part of the system, are orthogonalized simply by assuming a recursive (Choleski) structure for the corresponding block of the A matrix. This procedure yields orthogonal disturbances to which we do not attach a specific 'structural' interpretation, labelling them simply as v_i^NP (i = 1, 2, 3), where NP denotes a non-policy shock."

So the recursive ordering is a *normalisation for the block they do not care about*; the identification proper is the institutional reserve-market model, and the over-identifying restriction is **tested**, not imposed: "Estimation of Eq. (4.1) is implemented, instead of imposing the restriction d_65 = −1, by means of a Choleski factorization of the VAR residuals with the ordering shown above. The validity of the overidentifying restriction is then checked by looking at the estimated d_65 coefficient and its standard error." Result: `d_65 = −1.028 (s.e. 0.051)` — "cannot be rejected, supporting the validity of the identification scheme used."

**(c) Recursiveness fails badly once a long rate enters — their sharpest identification criticism (§5):**
> "There is one obvious reason for excluding long-term interest rates from VAR models designed to investigate the monetary transmission mechanism: identification. In fact, it is very difficult to rule out simultaneous feedbacks between long-term and short-term interest rates; hence it is hard to find a suitable set of restrictions to distinguish structural shocks to long-term rates from structural shocks to short-term rates, determined on the reserves market."

On Gordon & Leeper (1994), the one prominent VAR that does include a 10-year yield:
> "Identification is achieved by supplementing the usual assumption that goods market do not respond to current money market disturbances with the assumption that financial market as well do not respond to such disturbances. **Ruling out the simultaneous reaction of the long-term rate to current monetary policy shocks seems a questionable identifying restriction, especially if the data are observed at a monthly frequency.**"

**(d) A quiet empirical indictment of the funds-rate-recursive convention:** in the benchmark 1988–1996 model, "the simultaneous reaction of the federal funds rate to the macroeconomic policy variables (captured by d_41, d_42 and d_43) is not strongly significant", and Fig. 6 shows "a negligible difference between VAR innovations in the federal funds rate and the structural monetary policy shocks v^S". I.e. on this sample the whole recursive apparatus buys almost nothing: the "structural" policy shock ≈ the raw FF innovation. They note this "does not support the view of endogeneity of money on the sample considered." (In the longer 1983–1996 robustness sample the reverse holds — see §6 below.)

### 3.4 The external-measure strategy — a proto-proxy-SVAR

Three (later four) measures of policy shocks built **outside** the VAR are inserted into the VAR **as contemporaneous exogenous variables** (no lags: "No lags of x_t are introduced because this variable is meant to be a direct measure of monetary policy shocks"), equation (4.10):

`D [GDP; P; Pcm; FF; TR; NBR]_t = C*(L)[...]_{t-1} + g · x_t + v_t`, with `x_t ∈ {FFFS_t, ESZ_t, IFS_t}`.

The IRFs are then computed for the shock `x_t`, and the estimated `g` vector doubles as a **test of the benchmark's identifying assumptions** (`g_GDP`, `g_P`, `g_Pcm` should be zero if policy has no contemporaneous effect on the macro block).

**Important distinction for a modern proxy-SVAR paper:** this is *not* the Stock-Watson / Mertens-Ravn external-instrument projection `H = (Z'rsh)/(Z'Z)`. The external measure enters as a regressor (an exogenous variable in the VAR), and the impulse response is the dynamic multiplier of that regressor. It is the direct ancestor of the proxy approach, and the paper articulates the instrument logic explicitly (Sims's supply-shifter argument, §6.4 below), but the estimator is a different one.

---

## 4. Data — sources, unit of observation, sample, frequency

**Frequency:** monthly throughout. **Country:** United States. **Unit of observation:** the month.

**Samples:**
- Full: **1966:1 – 1996:3** (363 months). Start justified: "Only from the mid-60s the federal funds rate begins to be a significant tool for monetary policy (the level of the federal funds rate starts to be constantly above the discount rate)."
- **Main analysis sample: 1988:11 – 1996:3** (≈89 months, "seven and a half year of monthly data"), chosen because it is the only well-specified, parameter-stable single-regime window.
- Regime subsamples considered: 1966:1–1972:12 (free reserves targeting); 1973:1–1979:10 (funds-rate targeting); 1979:11–1982:10 (nonborrowed-reserve targeting); 1982:11–1988:10 (funds-rate/borrowed-reserve, pre-Greenspan); 1988:11–1996:3 (funds-rate/borrowed-reserve, Greenspan).
- Stability-testing samples: 1966:1–1979:10 (break 1973:1), 1973:1–1982:10 (break 1979:11), 1982:11–1996:3 (break 1988:11).
- Robustness sample: **1983–1996** using the EUR$ measure.

**Benchmark VAR variables (6):**

| Symbol | Definition (verbatim) | Transform |
|---|---|---|
| GDP | "real gross domestic product, monthly seasonally adjusted series interpolated from national income and product accounts quarterly series using the Chow—Lin procedure as described in Leeper et al. (1996)" | log |
| P | "consumer price index for urban consumers, total, seasonally adjusted" | log |
| Pcm | "IMF index of world commodity price" | log |
| FF | "federal funds rate, effective rate, per cent per annum" | level |
| TR | "total bank reserves, adjusted for reserve requirements changes, seasonally adjusted" | level, normalised by a **36-month moving average of TR** (Bernanke-Mihov 1995; cf. Strongin 1995) |
| NBR | "nonborrowed bank reserves, adjusted for reserve requirements changes, seasonally adjusted" | same normalisation |

"Given the linear identification structure adopted for the reserve and federal funds rate shocks, TR and NBR cannot be transformed in logarithms."

**Seventh variable in §5:** T10 — "the yield on 10-year Treasury bonds".

**Data provenance:** "We also thank Eric Leeper for kindly providing the data used in Leeper, Sims and Zha (1996)." The EUR$ eurodollar rates: "The data source is DATASTREAM."

**Daily/high-frequency inputs for the external measures:**
- 30-day fed funds futures, "quoted on the Chicago Board of Trade since October 1988", plus the Fed's funds-rate target.
- Three-month interest rate on policy-announcement days (Skinner-Zettelmeyer announcement-date list, built "using information from central bank reports and newspapers"; extended by the authors to all FOMC meeting dates).
- Term-structure fitting inputs for IFS: "the federal fund target, 1m euro, 3m euro, 6m euro, 12m euro, 3, 5, 7, and 10-year fixed interest rate swap", observed the day before regular FOMC meetings.
- One- and two-month eurodollar deposit rates, available since 1983 (for EUR$).

**Lag length / trend treatment:** "we estimate the system with six lags and all variables in levels, with no imposition of cointegrating relations" — deliberately, "we avoid a long-run identification problem ... with no loss of information on the long-run properties of the system ... incurring some loss due to the reduced efficiency of estimation but at no cost in terms of consistency of estimators" (citing Sims-Stock-Watson 1990, Hendry 1996). Each equation carries **37 regressors**.

**Software:** "The econometric analysis is performed using PcFIML by Doornik and Hendry (1996) and the RATS procedure MALCOLM written by R. Mosconi."

---

## 5. Statistical / econometric methods

1. **Reduced-form diagnostics** (Table 1B): residual standard deviation; normality χ²(2); residual autocorrelation F(7,356); ARCH F(7,349). Run on 1966–1996 and 1988–1996.
2. **Residual correlation matrices** across regimes (Tables 1A, 2).
3. **Recursive one-step Chow tests** per equation; **recursive N-step system Chow tests**; recursive stability tests initialised on 60 observations (Figs. 4, 5).
4. **Known-break-date stability** (Table 3A): PcFIML parameter-constancy forecast tests "based on the full variance matrix of all forecast errors", plus **information criteria (Schwarz and Hannan-Quinn)** on unrestricted vs restricted models — following Sims (1996) and Sims-Stock-Watson (1990), who argue "deciding whether there is time variation in parameters by conducting Chow tests with a standard significance level is an inconsistent decision procedure".
5. **Unknown-break-date stability** (Table 3B): **maximum Chow test (χ² form)** over a ±1-year window around each candidate break, with Andrews (1993) critical values. Explicit critical-value discussion: with 37 regressors and a known break, χ² critical values ≈ 52 (5%) and 59 (1%); for unknown breaks with trimming 0.45–0.55 "the correct critical values are about 1.12 times the standard critical value of the χ² distribution (42.97 against 37.57 for 20 regressors)". Applied **only to the three reserve-market equations**, since under their identification only those should be regime-sensitive.
6. **Structural estimation** of `D u_t = v_t` by Cholesky factorisation with the stated ordering; the over-identifying restriction `d_65 = −1` left free and tested via its estimate and standard error.
7. **Static OLS comparisons** of shock measures: pairwise correlations, and regressions of BENCH on each external measure with R², σ, DW reported.
8. **Auxiliary regressions to convert reduced-form surprises into structural ones** (see §6.2).
9. **Impulse responses with 95% confidence intervals**, to a one-standard-deviation shock; the bands are computed for the benchmark VAR and the alternative-shock IRFs are overlaid on them (Figs. 9, 10, 11). **The band-construction method (analytic vs. Monte Carlo vs. bootstrap) is never stated in the chunk text** — a gap for anyone trying to replicate the inference.

---

## 6. Findings — with numbers

### 6.1 Specification: the long-sample monetary VAR is mis-specified and unstable

**Full sample 1966–1996** — normality χ²(2): GDP 8.73*, P 71.42**, Pcm 58.87**, **FF 846.64\*\***, TR 33.30**, NBR 152.97**. ARCH F(7,349): 3.72**, 15.10**, 3.61**, 12.03**, 1.71, 7.30**. Autocorrelation F(7,356): P 2.54*, FF 3.90**, TR 2.82**. Verdict: "the diagnostic tests yield overwhelming evidence of mis-specification, likely attributable to parameter instability."

**Sample 1988–1996** — normality: 0.37, 1.77, 1.06, 2.55, 3.49, 0.56 (all insignificant); autocorrelation 0.66–1.46; ARCH 0.22–1.20. "no signs of mis-specification are detected". Residual s.d. falls across the board (FF: **0.569 → 0.139**; NBR 0.0171 → 0.0090; GDP 0.0046 → 0.0029).

**Known-break parameter-constancy forecast tests:** 1973:1 break → F(492,47) = 2.03 (p = 0.002, reject); 1979:11 → F(210,58) = 3.96 (p = 0.00, reject); **1988:11 → F(528,34) = 0.79 (p = 0.85, cannot reject)**.

**Maximum Chow (χ² form), reserve-market equations** — FF / TR / NBR:
- break window 1972:7–1973:7: 79.5 / 51.8 / 72.3
- break window 1979:1–1979:12: **296.3 / 93.3 / 146.7** ("strong evidence of instability in 1979")
- break window 1988:5–1989:5: 78.8 / 92.7 / 93.9 ("some evidence of instability in 1988–1989")

**Residual correlations shift dramatically across regimes** — e.g. corr(TR, NBR) = 0.65 (1966–72), 0.48 (1973–79), **0.85** (1988–96); corr(FF, NBR) = −0.35, −0.05, −0.20.

Conclusion: "the results from the above stability analysis over the whole sample cast serious doubts on the adequacy of our benchmark VAR as a statistical model from which reliable measures of monetary policy innovations could be derived." **Only the single-regime 1988–1996 VAR survives.** This is the abstract's first headline.

### 6.2 The three market-based measures (construction detail)

**FFFS — fed funds futures (Rudebusch 1996; Brunner 1996).** Shock = "the difference between the federal funds rate at month t and the 30-day federal funds future at month t−1". Justified by the unbiasedness regression:

> `FF_t = −0.037 + 0.999 FFF_{t−1} + û_t`, s.e. (0.0436) and (0.007), **R² = 0.99, σ = 0.145, DW = 1.86**

Critically, they recognise these raw surprises are **reduced-form**, not structural — this is the passage most directly relevant to the omitted-information question:

> "This procedure produces shocks, labelled FFF, which are comparable to the reduced form innovations from the VAR and not to the structural monetary policy shocks, because **surprises relative to the information available at the end of month t−1 may reflect endogenous policy responses to news about the economy that become available in the course of month t.**"

Their fix is to purge the surprise of contemporaneous macro innovations:

> `û_t = −0.92 u^GDP_t + 27.78 u^P_t − 2.04 u^Pcm_t + FFFS_t`, **R² = 0.05, σ = 0.145, DW = 1.76**

The R² of 0.05 says the purge removes almost nothing — "the above regression does not show any strong effect of current macroeconomic variables on the federal funds rate ... this empirical evidence does not support the view of endogeneity of money on the sample considered." They connect this to Gordon-Leeper (1994)'s assumption that "within the month the Fed reacts to current money and financial market variables, but not to current innovations in the goods market variables, which are observed with a one-month lag."

**ESZ — announcement-day 3-month rate changes (Skinner & Zettelmeyer 1996).** Two steps: build an announcement-date list from central bank reports and newspapers; take the change in the 3-month rate on those days. Four stated validity conditions: "(i) short rates (e.g. the overnight rate) are affected by policy; (ii) arbitrage is effective between the overnight and the three-month interest rate; (iii) the impact of other news affecting the three-month rate on the day of the policy decision is negligible; (iv) policy actions are not endogenous responses to information that becomes available on the day when the decision is taken." Skinner-Zettelmeyer drop actions violating (iii)–(iv). Bagliano-Favero identify the resulting **selection problem** — "it can only pin down shocks associated to monetary policy decisions reflected in some action on controlled variables, whereas shocks associated with *no* action (while some action was expected by the markets) are neglected" — and fix it by extending the index to **all FOMC meeting dates**. Quantified: "the shocks associated to no action are never larger than 5 basis point in absolute value in our sample". They emphasise that "ESZ are by their nature structural shocks, directly comparable with the identified monetary policy shocks of the benchmark VAR model."

**IFS — instantaneous forward rates (Svensson 1994; Favero, Pifferi & Iacone 1996).** Fit the Svensson (extended Nelson-Siegel) spot-rate curve (4.5), derive the instantaneous forward curve (4.9), on the day **before** each FOMC meeting; the fitted instruments are the fed funds target, 1m/3m/6m/12m euro rates and 3/5/7/10-year swaps. Logic: "If the pure expectational model is valid and there is no term premium, then instantaneous forward rates at future dates can be interpreted as the expected spot interest rates ... So the curve of instantaneous forward rates can be thought of as an indicator of expected monetary policy ... Monetary policy 'surprises' can be generated 'ex-post' by computing the distance between observed overnight rates and expected overnight rates." Shock = observed target on the day after the meeting minus the expected overnight rate. "The FOMC meets eight times a year; therefore we construct a monthly measure of shocks which features four zeros each year." Because scheduled meetings only date from 1994, for **1988:11–1993:12** they apply the same procedure at the Skinner-Zettelmeyer dates.

Footnote 4 is a useful methodological detail: an earlier version used the overnight fed funds rate rather than the target and "produced different, and less interesting, results. Frederick Mishkin pointed out that the overnight federal fund rate might display noisy behaviour in response to liquidity shocks totally unrelated to monetary policy."

**EUR$ (robustness, back to 1983).** From 1- and 2-month eurodollar deposit rates, derive a 1-month forward rate and subtract it from the realised 1-month rate.

### 6.3 The headline comparison: VAR shocks vs market-based shocks (Table 5)

Sample 1988:11–1996:3.

| | BENCH | FFFS | ESZ | IFS |
|---|---|---|---|---|
| Mean | 0 | 0 | −0.005 | −0.009 |
| Std. dev. | 0.104 | 0.141 | 0.056 | 0.176 |

Correlation matrix:

| | BENCH | FFFS | ESZ | IFS |
|---|---|---|---|---|
| BENCH | 1 | | | |
| FFFS | **0.475** | 1 | | |
| ESZ | **0.327** | 0.363 | 1 | |
| IFS | **0.294** | 0.364 | 0.581 | 1 |

Static regressions of BENCH onto each measure:

| | FFFS | ESZ | IFS |
|---|---|---|---|
| Coefficient | 0.326 | 0.602 | 0.174 |
| S.E. | 0.068 | 0.186 | 0.06 |
| **R²** | **0.21** | **0.11** | **0.09** |
| σ | 0.093 | 0.099 | 0.100 |
| DW | 1.85 | 2.00 | 2.04 |

Verbatim: "the correlations between shocks range from 0.3 to 0.6 ... a maximum R² of 0.2 for the regression of BENCH on FFFS ... the R² of the regression of BENCH on ESZ is 0.1. The lowest R² of 0.09 is obtained from the regression of BENCH on IFS. The coefficients of all regressions are clearly, but not spectacularly, significant."

Their reading, against Rudebusch: "On the basis of similar evidence, Rudebusch (1996) concluded that shocks derived from VAR do not make sense as measures of monetary policy shocks. We conclude that they are **not strongly correlated with alternative measurements of the same quantity**" — and then, instead of stopping there, they ask whether the *transmission mechanism* is sensitive to the choice.

### 6.4 Low correlation, same IRFs — the paper's central result

Inserting each external measure into the VAR (Table 6):

- **`g_GDP`, `g_P`, `g_Pcm` are never significant** for any of FFFS/ESZ/IFS. E.g. IFS: g_GDP = 0.00001 (0.002), g_P = 0.0007 (0.0007), g_Pcm = −0.0074 (0.0075). "one of the crucial identifying assumptions in the benchmark VAR model is validated by the estimation based on alternative measures of policy shocks." This is an **independent test of the standard zero-impact restriction using non-VAR information** — directly relevant to any paper defending a recursive/impact restriction on the macro block.
- **`g_FF` is strongly significant in all three:** FFFS **0.654 (0.079)**, ESZ **0.829 (0.230)**, IFS **0.305 (0.078)**. "This evidence weakens the conclusion by Rudebusch (1996) that VAR-based monetary policy shocks do not make sense."
- **`g_TR`, `g_NBR`** insignificant under FFFS and ESZ, but "significant, and correctly signed, in the model with the IFS shock": **−0.0137 (0.0042)** and **−0.0110 (0.0048)**. "It seems that the inclusion of the IFS shocks in the VAR allows a better determination of the parameters determining demand and supply behaviour in the market for reserves."
- **Impulse responses:** "The plots clearly show that the alternative measures of policy shocks yield descriptions of the monetary transmission mechanism which are not significantly different (in a statistical sense) from each other." (Fig. 9, 95% bands from the benchmark VAR.)
- **σ(v^S) shrinks when a market measure absorbs the policy variation:** from **0.100** (benchmark) to **0.070** (FFFS), 0.091 (ESZ), 0.092 (IFS) — "implying that the bulk of the FF innovation variability is not related to monetary policy shocks."
- **Liquidity effect reallocated:** under FFFS/IFS "there is a relatively strong 'liquidity effect' on the reserves market" via g_TR, g_NBR (−0.014, −0.011 for IFS), while the residual v^S impacts on TR and NBR — computed as `−d_54` and `d_54 d_64 − d_65` (i.e. α + β) — are only **−0.003 and −0.008** in the IFS case. "Though the relatively high standard errors do not allow these differences ... to be statistically significant, the point estimates may support the view that the exogenous variables adequately capture monetary policy shocks."

**Why can measures disagree on the shock but agree on its effect?** This is Sims's instrument argument, and it is the passage a proxy-SVAR paper should quote:

> "Consider a simple supply and demand simultaneous equation model: identification of the structural parameters in the demand equation requires some variables which shift the supply curve while not affecting demand. There might well exist more than one such 'supply shifter', and, despite their being all valid instruments to identify demand, they might be very little correlated. **In the extreme case of orthogonal instruments, the alternative use of one of the instruments will lead to the same estimates of the demand parameters independently from the omission of the other instrument and from the lack of correlation between them.**"

And a point about estimating the instrument relation jointly rather than by static regression:

> "both the magnitude and the significance of the estimates of the contemporaneous relation between the VAR federal funds innovation and the alternative measurements of monetary policy **improves when the estimation is conducted in a multivariate framework rather than using a static regression analysis**."

(Compare g_FF = 0.654 with t ≈ 8.3 against the static BENCH-on-FFFS coefficient 0.326 with t ≈ 4.8.)

They also acknowledge the residual risk honestly: "impulse response estimates could be affected by errors-in-variables bias or, in the worst case, the additional variability might reflect endogenous factors. **While the errors-in-variables bias is not easily dismissed**, some arguments can be made to rule out the worst-case scenario."

### 6.5 Robustness on 1983–1996 with EUR$

- Regression of 1-month eurodollar shocks on fed funds future shocks, 1988–1997: coefficient **0.86, t ≈ 10, correlation 0.54**.
- Static regression of BENCH on EUR$ over 1983–1996: **0.24, t ≈ 5**; the same coefficient "raises to **0.50 with a t-ratio of about seven** when estimated within a multivariate framework."
- IRFs "not different from each other in a statistical sense, with a pattern of point estimates very similar to the one previously found over the shorter sample."
- **Sign reversal on endogeneity:** "Interestingly, we now find that innovations in the macroeconomic variables are statistically significant in explaining innovations in the federal funds rate both in the benchmark VAR and when the EUR$ is included in estimation. In particular, innovations in output and prices are significant with point estimates suggesting a **higher weight on inflation in the monetary authorities' reaction function.**" So the "no contemporaneous endogeneity of policy" reading of §4 is a 1988–1996 artefact.

### 6.6 Rudebusch's four criticisms, itemised (the information-set passage)

> "Rudebusch (1996), who criticized standard monetary VAR models under four respects: (i) the assumption of a time-invariant, linear structure, (ii) **the use of a limited information set in the policy reaction function**, (iii) the use of final revised data, and (iv) the presence of long distributed lags in the policy reaction function."

> "The alternative measures of monetary policy shocks used in the above analysis are not affected by any of Rudebusch's criticisms: no time-invariant, linear structure is required by any of our method of deriving monetary policy shocks from financial markets, **the information set available coincides with the one used by financial markets**, there is no problem of data revisions in financial data, and no specification of a lag structure is assumed in their derivation."

Then the honest caveat: "However, when we analyse the impulse response functions we use our measures of monetary policy in a VAR and at least some of the original criticism could still be valid."

Their itemised replies:
- Time-invariance → handled by the single-regime sample (§3).
- Linearity → conceded, unaddressed: "A linear structure is imposed on the system, and therefore we cannot allow for asymmetric effects of restrictive and expansionary monetary policy. This is beyond the scope of this paper, but it is an interesting area on our agenda for future research."
- Revised data → citing Bernanke-Mihov (1996) and Sims (1996): "if policy authorities make efficient use of flawed but immediately observable measures of final data, and if the resultant measurement errors do not affect the behaviour of other variables in the economy, then no bias is introduced by assuming that monetary authorities react to final revised data. **Measurement errors simply help the identification of monetary policy by adding a source of exogenous variation.**" Footnote 6 (a referee): "this point is valid only when the measurement error is correlated with preliminary, but not with final, data. When the converse is true, the VAR parameters are still inconsistently estimated."
- Long lags → Sims (1996): "even variables that display no inertia ... do not necessarily show absence of long lags in regressions on other variables", illustrated in fn. 7 with the random-walk consumption example.

Final verdict: "we believe that the evidence supports the results reported in Brunner (1996) and casts serious doubts on the statement that VAR-based monetary policy shocks do not make sense."

**Important scoping note for a DFM paper:** criticism (ii) — limited information set — is addressed *only* by importing market-based surprises. **The paper never enlarges the VAR's own information set** (no factors, no large panel), and **the words "non-fundamental", "non-fundamentalness", "invertibility" and "omitted information" do not appear anywhere in the chunk text.** The conceptual link is there (a small VAR conditions on less than markets do; using a market surprise repairs it) but the formal non-fundamentalness literature — Hansen-Sargent, Lippi-Reichlin, Forni-Gambetti, Alessi-Kerssenfischer — post-dates this paper. Cite it as the *pre-history* of the omitted-information argument, not as a statement of it.

### 6.7 The long-term interest rate (§5)

Seven-variable VAR ordered **GDP, P, Pcm, T10, FF, TR, NBR**, with IFS as the contemporaneous exogenous shock, D lower-triangular. Ordering rationale: "Ordering T10 after the block of non-policy variables allows a contemporaneous reaction of the long rate to the macroeconomy. Moreover, **the inclusion of the exogenous shocks allows to identify a simultaneous feedback between the federal funds rate and the long-term interest rate**." That is the methodological payoff: the external measure breaks the FF↔T10 simultaneity that ordinarily forces long rates out of monetary VARs.

Results (Table 7, 1988:11–1996:3):
- **`g_FF` = 0.260 (0.080)** — policy shock moves the funds rate.
- **`g_T10` = 0.005 (0.120)** — "the long rate does not react contemporaneously to policy shocks".
- `g_GDP` = 0.0002 (0.002), `g_P` = 0.0006 (0.001), `g_Pcm` = −0.140 (0.160) — the no-contemporaneous-macro-effect result is confirmed.
- **`|d_54| = 0.281 (0.090)`** — "a clearly significant contemporaneous reaction of the federal fund rate to the long-term interest rate ..., **witnessing the relevance of contemporaneous long-term interest rates in the policy maker's reaction function**."
- `g_TR` = −0.013 (0.003), `g_NBR` = −0.012 (0.005) — "a remarkable impact on the precision of the estimates of the simultaneous response of total and nonborrowed reserves to the monetary policy shock".
- σ(v^S) = 0.092 (0.010); σ(v^T10) = 0.086 (0.010).

IRFs (Figs. 10, 11), one-s.d. shock, 95% bands:
- "When the long-term rate is included, the reduction in output following a monetary restriction is **smaller in magnitude and dies out more quickly**, and also consumer prices respond less to monetary policy shocks. The response of total and nonborrowed reserves are perfectly in line with the previous results."
- **The long rate falls after a contraction:** "we note that the long-term interest rate does not increase; in fact, T10 shows a **decrease over the first six months** after the policy shock, before starting to rise back towards its initial level. Therefore, the contractionary monetary impulse does not seem to be transmitted to the real economy through increases in long-term interest rates." Corroborated by Campbell (1995) on the 1994 tightening.
- An independent T10 shock — "not related to monetary policy, and may reflect unexpected increases in default risk affecting long rates" — also depresses output and moves the funds rate in the same direction.
- "In reaction to both kinds of disturbances the price level does not appear to decline significantly."

---

## 7. Contributions — what is new

1. **A statistical-adequacy audit of the canonical US monetary VAR.** Establishes that the Bernanke-Mihov/Strongin six-variable system is mis-specified and unstable over 1966–1996, and that **only the post-1988 single-regime window is defensible**. Also notes a problem for the regime-shift explanation: "given the common procedure followed to identify monetary policy shocks, these changes in policy regime cannot explain the instability in the equation for the non-policy variables."
2. **First systematic head-to-head of VAR-identified shocks against three independent, market-based measures** (fed funds futures, announcement-day 3-month rate changes, Svensson forward-rate surprises) on a common sample and a common benchmark VAR.
3. **The "low correlation, same IRF" result** — and, with it, the reframing of Rudebusch's negative verdict. Low pairwise correlation between candidate shock measures is *not* evidence that any of them is invalid, because valid instruments for the same structural equation need not be correlated (Sims's supply-shifter argument).
4. **An external, non-VAR test of the standard identifying restriction** that policy has no contemporaneous effect on output and prices — passed by all three market measures.
5. **Extending Skinner-Zettelmeyer to all FOMC dates** to fix the "no action when action was expected" selection problem, with the 5bp bound quantifying its severity.
6. **Using an external policy-shock measure to solve the FF↔long-rate simultaneity**, thereby re-admitting a 10-year yield to a monetary VAR without the Gordon-Leeper restriction. Two substantive findings follow: policy rates respond significantly to contemporaneous long rates (reaction-function content), and the output effect of a contraction does **not** run through rising long rates.
7. **A methodological position statement** (§2.1) on when the Lucas and Sims critiques bind for VARs, and on what VARs are *for* (generating stylised facts to discriminate among theories, not producing policy advice).

**For the parent project specifically:** this is a 1998 precursor of the external-instrument proxy-SVAR literature. It uses market-based high-frequency-ish surprises to inform the identification of a monetary VAR, articulates the instrument logic, and validates the impact restrictions with outside information — but it (a) inserts the measure as an exogenous regressor rather than projecting IRFs through a proxy, (b) never addresses instrument strength/weak-IV inference, (c) never enlarges the VAR information set with factors, and (d) has no formal treatment of non-fundamentalness. Those four gaps are exactly the space Gertler-Karadi, Stock-Watson/Montiel Olea-Stock-Watson, and Alessi-Kerssenfischer later occupy.

---

## 8. Replication feasibility

**Moderate for §3, low-to-moderate for §4–§5. No replication package; a 1998 paper with no data or code archive mentioned anywhere in the text.**

*Favourable:*
- The benchmark VAR is fully specified: six named series, transformations stated, 6 lags, levels, no cointegration, exact subsample dates, the D matrix written out, and the estimation device (Cholesky with a stated ordering, `d_65` left free) described. Point estimates and standard errors are tabulated for every structural coefficient in Tables 4, 6, 7.
- GDP, CPI, FF, TR, NBR are standard FRED/Board series; the reserve normalisation (36-month MA of TR) and the reserve-requirement adjustment are stated.
- The specification tests are all standard and available in current software; the Andrews (1993) critical-value adjustment is spelled out numerically.
- The FFFS construction is fully reproducible in principle: `FF_t − FFF_{t−1}`, plus a 3-regressor projection on VAR macro innovations, with both regressions reported in full.

*Obstacles:*
- **GDP is not an observed series.** It is a Chow-Lin interpolation of quarterly NIPA GDP, "as described in Leeper et al. (1996)", and the actual series was obtained privately ("We also thank Eric Leeper for kindly providing the data used in Leeper, Sims and Zha (1996)"). Reproducing it requires re-implementing their interpolation and choosing indicator variables the text does not list.
- **Vintage problem.** All series are final revised data as of ~1996–97; today's FRED vintages differ (and the CPI, commodity index and reserve series have been revised and redefined). Exact numerical replication of Tables 1–3 is unlikely.
- **IMF world commodity price index** — the specific IMF series is not identified beyond that phrase.
- **The IFS measure is the hardest.** It needs daily 1m/3m/6m/12m euro rates and 3/5/7/10-year swap quotes on the day before each FOMC meeting, 1988–1996 — proprietary, and the source is not named. The Svensson fitting procedure (starting values, objective function — price-fitting vs yield-fitting, weighting) is not documented beyond equations (4.5) and (4.9). And the pre-1994 portion depends on the Skinner-Zettelmeyer date list.
- **ESZ depends on an unpublished date list** from Skinner & Zettelmeyer (1996), an MIT mimeo, itself built from "central bank reports and newspapers". Modern FOMC-date reconstructions exist but would not reproduce their pre-1994 non-meeting action dates.
- **30-day fed funds futures** from the CBOT since October 1988 — obtainable today (e.g. via the CME/Chicago Fed), but the specific settlement convention used for "the 30-day federal funds future at month t−1" is not pinned down (which trading day of the month?).
- **EUR$** comes from DATASTREAM (licensed).
- **Inference method for the 95% IRF bands is never stated** — analytic delta-method, Monte Carlo from the posterior, or bootstrap. Any replication must guess, and the paper's key claim ("not significantly different in a statistical sense") rests on those bands.
- **Software** (PcFIML 1996, RATS/MALCOLM) is legacy; the parameter-constancy forecast test "based on the full variance matrix of all forecast errors" is a PcFIML-specific statistic that would need re-derivation.
- OCR damage in the marker output: minus signs render as `!`, `TR` renders as `¹R`, and Table 6's coefficient/S.E. cells are transposed in places. Anyone quoting Table 6 numbers should verify against the PDF — I cross-checked the numbers quoted above against the surrounding prose where possible (e.g. `g_TR`, `g_NBR` = −0.0137/−0.0110 for IFS confirmed by the §4.3 text "−0.014 and −0.011").

*Practical verdict:* §3 (specification/stability) is replicable up to data-vintage differences with public series plus a re-built Chow-Lin GDP. §4's FFFS branch is replicable with commercial futures data. **ESZ and IFS are effectively not replicable without the authors' inputs**, which matters because IFS is the measure that carries §5.
