# Reading Notes — Bauer & Swanson (2023), "An Alternative Explanation for the 'Fed Information Effect'"

## Bibliographic metadata (confirmed from chunk 01)

- **Authors:** Michael D. Bauer (Universität Hamburg, CEPR, and CESifo) and Eric T. Swanson (University of California, Irvine, and NBER)
- **Title:** "An Alternative Explanation for the 'Fed Information Effect'"
- **Journal:** *The American Economic Review* (American Economic Review)
- **Year / Month:** March 2023
- **Volume:** 113
- **Issue:** No. 3
- **Pages:** 664–700
- **DOI:** https://doi.org/10.1257/aer.20201220
- **JSTOR Stable URL:** https://www.jstor.org/stable/10.2307/27252434
- **JEL codes:** D82, E23, E27, E43, E44, E52, E58
- **Coeditor:** Mikhail Golosov
- **Replication package:** Bauer & Swanson (2023), "Replication Data for: An Alternative Explanation for the 'Fed Information Effect'", AEA / ICPSR, https://doi.org/10.3886/E181661V1
- Previously circulated as: "The Fed's Response to Economic News Explains the 'Fed Information Effect.'"
- Follow-up companion paper (frequently cited for the orthogonalization implementation): **Bauer & Swanson (forthcoming), "A Reassessment of Monetary Policy Surprises and High-Frequency Identification," *NBER Macroeconomics Annual* 37.**

**Suggested citation (BibTeX-ready):**
> Bauer, Michael D., and Eric T. Swanson. 2023. "An Alternative Explanation for the 'Fed Information Effect'." *American Economic Review* 113 (3): 664–700. https://doi.org/10.1257/aer.20201220.

---

## Research question

When the Fed surprises markets with an FOMC announcement, is that high-frequency surprise (i) an exogenous monetary policy *shock* (the assumption of the monetary-VAR literature), or (ii) a "Fed information effect" in which the surprise reveals the Fed's *superior private information* about the economy (Romer-Romer 2000; Campbell et al. 2012 = CEFJ; Nakamura-Steinsson 2018 = NS)? The paper proposes and defends a third explanation.

Formal reaction function: `i_t = f(X_t) + ε_t`. A surprise `i_t − E_{t−δ} i_t` can arise from (1) exogenous shock ε_t; (2) Fed information effect — Fed observes X_t differently from private-sector estimate X̂_{t|t−δ}; or **(3) a difference between the Fed's actual response function f and the private sector's ex ante estimate f̂_{t−δ}**. Prior studies assume f̂ = f and debate only channels 1 vs 2. Bauer-Swanson relax this and argue channel 3 drives the evidence.

## Central claim — the "Fed response to news" channel

The apparent Fed information effect is instead a **"Fed response to news"**: both the Fed AND professional (Blue Chip) forecasters respond to the *same publicly available economic news* released between the beginning-of-month Blue Chip survey and the (mid-month, ~17th day) FOMC announcement. The Fed has historically responded to that public news *more strongly than markets expected* (i.e., the public underestimated the Fed's responsiveness, `â_t < a`), which mechanically produces a procyclical correlation between Blue Chip forecast revisions and monetary policy surprises — the "puzzling" positive slope in NS's Figure II. No informational asymmetry is needed.

**Key point for our project:** high-frequency monetary policy surprises are **predictable / correlated ex post with publicly available macro and financial data observed BEFORE the FOMC announcement**, even though they are unpredictable ex ante (`E[mps_t | x_t, H_{t−1}] = 0` in their model). This is a violation of the exogeneity condition required for using surprises as external instruments in SVARs / local projections. (Predictability echoes Miranda-Agrippino 2017; Cieslak 2018; Karnaukh-Vokata 2022; Sastry 2021. Their preferred explanation is a violation of Full-Information Rational Expectations — markets underestimated Fed responsiveness — not time-varying risk premia.)

## The predictors ("news_t" vector) — EXACT LIST

The regression establishing predictability is **equation (7): `mps_t = α + β' news_t + ε_t`** (Table 3), where `mps_t` is the 30-minute-window surprise (GSS **target** factor, GSS **path** factor, or **NS** first-principal-component surprise). Same `news_t` vector is used in the Blue Chip regressions (Table 2) and the controlled regressions (Table 4). Every predictor is known/dated **before** the FOMC announcement.

**Macroeconomic news (data releases, surprise = released value − Money Market Services survey market expectation just prior):**
1. **Unemployment-rate surprise** (from the beginning-of-month employment report, month t)
2. **Nonfarm payrolls surprise** (same employment report; in thousands, ÷1,000 to rescale)
3. **GDP surprise** (advance GDP release from end of month t−1 — "old news")
4. **BBK index** — Brave, Butters & Kelley (2019) "big data" business-cycle activity index (month t−1); summarizes all major macro releases. (Results robust to dropping it.)
5. **Change in core CPI inflation from 6 months previous** — `((log CPIX_{t−2} − log CPIX_{t−8}) − (log CPIX_{t−8} − log CPIX_{t−14})) * 200` ("old news" / lagged inflation)
6. **Expectation of core CPI release** (Money Market Services survey — lagged indicator)
7. **Core CPI surprise** (second-week-of-month t core CPI release; core is a better predictor than headline)

**Financial-market news (measured from 13 weeks before the FOMC announcement to the day before it):**
8. **Δ log S&P500** — change in the natural log of the S&P 500 stock price index (one of the strongest predictors)
9. **Δ yield-curve slope** — change in (10-year constant-maturity Treasury yield − 3-month constant-maturity Treasury yield), in pp
10. **Δ log pcommodity** — change in log commodity price index, defined as `Δlog(Bloomberg total commodity index BCOM) − 0.4 × Δlog(Bloomberg agricultural commodity index BCOMAG)` (i.e., a commodity/energy-tilted composite; the paper uses a broad commodity index, not oil per se)

Each regression also includes a **constant, a time trend** (matters for inflation), and **one lag of the Blue Chip forecast revision** (Coibion-Gorodnichenko informational-rigidity control). Standard errors bootstrapped, 50,000 replications.

**Evidence of predictability (Table 3, full sample 1990:01–2019:06, N=217):** R² = 0.12 (target), 0.15 (path), 0.20 (NS surprise). "The stock market and commodity prices are especially strong predictors of upcoming monetary policy surprises, while the yield curve slope, nonfarm payrolls release, and GDP release are also important." Signs intuitive: news of higher output/inflation predicts a tighter monetary-policy surprise. Magnitudes: +1 pp GDP surprise → ~1.5 bp surprise tightening in path factor; +10% stock market → ~1.5 bp surprise tightening in each column. Corroborating: forecast errors for the fed funds rate from the Blue Chip Financial Forecasts survey are predictable with the same RHS variables (R² > 20% at all horizons; online Appendix C) — direct evidence of FIRE violations.

## Recommended remedy — orthogonalization / "purification" (KEY FOR METHODOLOGY)

Because the exogeneity (uncorrelated-with-other-structural-shocks) condition for a valid external instrument is violated by the news correlation, the fix is:

> "To eliminate this correlation, an econometrician can project it out by **regressing the high-frequency monetary policy surprise data `mps_t` on macroeconomic and financial variables and taking the residuals.** These residuals are then free of the 'Fed response to news' effects documented above and can be used as an external instrument for identification of the VAR or local projection, since the relevance and exogeneity conditions are then both likely to be satisfied."

- **Procedure:** run `mps_t = α + β' news_t + ε_t` (the Table 3 / eq. 7 regression) and keep the **residual** `ε̂_t` as the clean, exogenous monetary-policy surprise. Use the residual as the external instrument.
- Conceptually the same as Miranda-Agrippino & Ricco (2021), who project surprises on the Fed's confidential **Greenbook** forecasts; the difference here is that Bauer-Swanson project out **publicly available macro + financial news** (available in real time, no five-year confidentiality lag). Bauer-Swanson (forthcoming) show public Blue Chip forecasts give very similar results to Greenbook.
- **Important scope caveat (do not over-orthogonalize):** for **high-frequency event-study asset-price regressions** (yield curve, stock market — eq. 15), the RAW surprise `mps_t` can be used *without* correction; orthogonalizing is unnecessary there and actually *reduces efficiency*, because asset prices respond to the full surprise, not just ε_t. Orthogonalization is needed **only** for **VAR / local-projection identification** where exogeneity matters. In Bauer & Swanson (forthcoming) they implement the orthogonalization and find it *substantially increases* the estimated effects of monetary policy shocks in a structural VAR.

## Data

- **Blue Chip Economic Indicators** survey: ~50 professional forecasting firms (52 in the panel), monthly (first 2–3 business days), consensus (mean) forecasts of real GDP growth, unemployment rate, CPI inflation (also 3m T-bill, 10y Treasury, IP, net exports). Focus: change in average of 1-, 2-, 3-quarter-ahead consensus.
- **Monetary policy surprises**, 30-minute windows around FOMC announcements, high-frequency futures from 1990:01 (GSS): GSS **target factor** (fed funds target surprise) + **path factor** (forward-guidance surprise); and **NS surprise** = first principal component of five short-rate futures changes, scaled to move 1-year Treasury yield by 1 pp.
- **Macro release expectations:** Money Market Services survey. **BBK** activity index. **Financial data:** S&P 500, Treasury yields (10y, 3m constant maturity), Bloomberg BCOM/BCOMAG commodity indices.
- **Own survey:** all 52 Blue Chip firms contacted July–Aug 2019; **36 responses (~70%)**.
- **Greenbook (GB) forecasts** vs Blue Chip, 1990–2013 (192 obs; GB released with 5-year lag).
- **Sample:** full 1990:01–2019:06 (N=217 FOMC-month obs; 206 excluding unscheduled). Replications: CEFJ 1990:01–2007:06 (N=129); NS 1995:01–2014:03 excl. unscheduled & 2008:07–2009:06 (N=120).

## Findings

1. **Table 1 (replication):** Standard Fed-information-effect regressions have "wrong" signs but are *fragile* — low significance, very low R² (0–6%), not robust across sample period or forecast variable (GDP vs unemployment vs inflation). Inconsistent with a constant information effect.
2. **Table 2:** Economic news strongly predicts Blue Chip forecast revisions (R² 0.31–0.64).
3. **Table 3:** Economic news predicts high-frequency MP surprises (R² 0.12–0.20) — the omitted-variable that biases the naive regressions. (The core new empirical fact for instrument construction.)
4. **Table 4:** Adding `news_t` controls to the Fed-information regressions (eq. 4/5) **flips the sign of the MP-surprise coefficient back to standard theory** (tightening → higher unemployment forecast, lower GDP forecast, lower/flat inflation forecast) and raises R² to 0.31–0.65. Omitted-variable bias fully explains the "information effect."
5. **Own survey (Table 5):** Of 36 firms, most either don't revise forecasts after FOMC announcements or revise in the *conventional* direction; **none** revise GDP *upward* after a hawkish surprise (contradicts NS). 24 of 34 ignore the SEP; 13 ignore all FOMC components. Of 23 who do revise, 18 revise conventionally.
6. **Stock/FX (Tables 6–7):** The 10 most "information-effect-influential" FOMC dates show stock/FX responses *just as negative* as the rest of the sample (9/10 stock responses opposite-signed to the surprise) — no muted/positive response that an information effect predicts. Consistent with Fed-response-to-news (surprise co-moves with the BBK business-cycle indicator in 9/10 cases).
7. **Greenbook vs Blue Chip accuracy (Table 8):** RMSEs and encompassing regressions show the Fed's internal forecasts are **not superior** to Blue Chip's — undercuts the "superior information" premise of the information effect. (Romer-Romer's earlier finding was driven by the 1980s Volcker disinflation.)
8. **Model (Section V):** Simple imperfect-information model — private sector doesn't know the Fed's reaction-function slope `a` (holds belief `â_t`). Surprise `mps_t = (a − â_t) x_t + ε_t`. If `â_t < a`, surprises correlate positively with pre-announcement state `x_t` ex post while remaining unpredictable ex ante. Delivers all three empirical implications: (i) surprises correlated with pre-announcement data; (ii) ε_t and mps_t have identical effects on asset prices (⇒ raw surprises fine for event studies); (iii) surprises may be invalid VAR instruments (⇒ orthogonalize).

## Contributions

- Provides a unified alternative ("Fed response to news") that explains the Delphic-forward-guidance / NS information-effect evidence without any Fed informational advantage.
- Documents that high-frequency MP surprises are **predictable from pre-announcement public macro/financial news** — the omitted variable driving the puzzle.
- Delivers a clean, implementable **remedy for instrument contamination**: orthogonalize surprises on public news, use residuals as the external instrument (relevant + exogenous). Clarifies that this is needed for VAR/LP identification but NOT for asset-price event studies.
- Original survey of Blue Chip forecasters + Greenbook-vs-Blue-Chip accuracy comparison as independent corroboration.
