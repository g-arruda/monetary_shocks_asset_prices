# Reading Notes — Jarociński & Karadi (2020), "Deconstructing Monetary Policy Surprises: The Role of Information Shocks"

## Bibliographic metadata

- **Authors:** Marek Jarociński and Peter Karadi (both Directorate General Research, European Central Bank; Karadi also CEPR).
- **Title:** "Deconstructing Monetary Policy Surprises—The Role of Information Shocks."
- **Journal:** *American Economic Journal: Macroeconomics* (confirmed via DOI prefix `mac`).
- **DOI:** https://doi.org/10.1257/mac.20180090 (stated in the chunk text, note †).
- **JEL codes:** D83, E43, E44, E52, E58, G14 (stated in abstract).
- **Year / volume / issue / pages:** The chunk text does NOT state year, volume, issue, or page numbers explicitly. Coeditor was Simon Gilchrist. Earlier working-paper title: "Central Bank Information Shocks." From external knowledge (NOT in chunk text): AEJ: Macroeconomics, **Vol. 12, No. 2 (April 2020), pp. 1–43**. Treat volume/issue/pages/year as unconfirmed-from-text.

---

## 1. Research question

Do surprises in the central bank's *assessment of the economic outlook* — "central bank information shocks" — released jointly with policy announcements have a sizable macroeconomic impact, and does ignoring them bias the measured effects (non-neutrality) of monetary policy? Central bank announcements simultaneously convey (a) news about the policy stance and (b) news about the central bank's view of the economy; the paper's goal is to disentangle the two and trace their separate dynamic effects.

Classic motivating example: On **March 20, 2001**, the FOMC delivered a larger-than-expected 50-bp funds-rate **cut**, yet the S&P 500 **fell** within 30 minutes (opposite to textbook prediction), because the accompanying statement flagged "substantial risks that demand and production could remain soft." Roughly **one-third of FOMC announcements since 1990** show this "wrong-signed" positive co-movement.

## 2. Central idea — surprises mix two shocks

A high-frequency policy surprise is not a pure monetary policy shock. It is a linear combination of:
1. a **pure monetary policy shock** (news about the policy stance), and
2. a **central bank information shock** (news about the central bank's assessment of the outlook, moving private expectations independently of the rate decision).

Both hit within the narrow announcement window. Failing to separate them biases standard high-frequency identification (HFI) of monetary policy.

## 3. IDENTIFYING LOGIC — the sign of interest-rate × stock-price co-movement

The core identifying assumption uses the **sign of the high-frequency co-movement between the interest-rate surprise and the S&P 500 stock-price surprise** in a 30-minute window around the announcement:

- **Negative co-movement** (interest rate **up**, stocks **down**; or rate down, stocks up) → **PURE MONETARY POLICY SHOCK.** Standard theory unambiguously predicts a policy tightening lowers stock valuations: the present value of future dividends falls because (i) the discount rate rises and (ii) expected dividends fall with the policy-induced downturn. (Quadrants II and IV of the scatterplot.)
- **Positive co-movement** (interest rate **up** AND stocks **up**; or both down) → **CENTRAL BANK INFORMATION SHOCK.** This co-movement is inconsistent with a pure monetary policy shock, so it must reflect something else in the announcement — the CB revealing (favorable) information about the outlook that lifts stocks even as rates rise. (Quadrants I and III — the "wrong-signed" points.)

The information content is not otherwise available to the econometrician; the market price co-movement is used to read the signal in the announcement. Two possible readings of wrong-signed points are considered — (a) random stock-market noise vs (b) a systematic non-monetary shock — and the evidence favors (b).

## 4. Implementation — baseline sign restrictions in a Bayesian structural VAR

**Model.** A Bayesian structural VAR combining HFI with sign restrictions. Let `m_t` = vector of high-frequency announcement surprises, `y_t` = monthly macro/financial variables. Intraday surprises are summed within each month (zero in months with no FOMC meeting). VAR restriction: `m_t` does not depend on lags of `m_t` or `y_t` and has zero mean (surprises unpredictable). Litterman (1979/1986) prior; Gibbs sampler handles missing pre-1990 surprises; 12 lags; 2,000 retained draws.

**Two identifying assumptions (Table 1):**
1. **HFI (zero restrictions):** the surprises `m_t` are affected only by the two announcement shocks and by no other shocks (justified by the narrow window).
2. **Sign restrictions:**
   - Monetary policy (negative co-movement) shock: **interest rate +, stock index −.**
   - CB information (positive co-movement) shock: the orthogonal complement — **interest rate +, stock index +.**
   - "Other" shocks: **0** on both high-frequency surprises. No sign restrictions imposed on any low-frequency `y_t`.

**Mechanics of the rotation.** For each posterior draw of Σ, take lower-triangular Choleski `C`; the HFI zeros imply a block-Choleski structure with the two announcement shocks in the first block. Post-multiply the 2×2 sub-block by an orthogonal `Q*` (from QR of a 2×2 standard-normal matrix, Rubio-Ramírez–Waggoner–Zha 2010) and keep draws satisfying the sign restrictions; uniform prior over admissible rotations. This is **set identification** — uncertainty bands integrate over admissible rotations.

**Baseline VAR variables (7 total):** `m_t` = 3-month fed funds futures surprise + S&P 500 surprise; `y_t` = 1-year constant-maturity Treasury yield, S&P 500 (log level), real GDP (interpolated), GDP deflator (interpolated), and the excess bond premium (Gilchrist–Zakrajšek 2012). Monthly, **Feb 1984 – Dec 2016**; the two `m_t` variables start Feb 1990.

**Relation to proxy-VAR / HFI.** Closely related to proxy-SVARs (Stock–Watson; Mertens–Ravn 2013) and Gertler–Karadi (2015). The contribution is using sign restrictions on **multiple** high-frequency surprises to separate **multiple** contemporaneous shocks, rather than treating the whole funds-rate surprise as the monetary instrument. Standard HFI = Choleski with the fed-funds surprise ordered first; it implicitly attributes the entire surprise (ignoring the stock reaction) to monetary policy — `cov(m_ff, ε_MP)>0`, `cov(m_ff, ε_i)=0` otherwise — and thus mixes the two shocks.

## 5. The simple "sign filter" reading — Poor Man's Sign Restrictions

A simpler, stronger-assumption version that matches the sign-restriction results closely:
- In months where the stock surprise has the **OPPOSITE** sign to the fed-funds surprise (negative co-movement), use the fed-funds surprise as the **monetary policy** proxy; set it to **zero** otherwise.
- In months where the stock surprise has the **SAME** sign (positive co-movement), use the fed-funds surprise as the **CB information** proxy; zero otherwise.
- Implicit assumption: each month is classified as *either* a pure monetary policy month *or* a pure information month (whereas sign restrictions let each month be a nonzero mix of both).
- Implemented by placing the two zero-masked proxies first and using a Choleski decomposition.

**This is exactly the "zero-out the positive-co-movement days" sign filter** relevant to building a clean monetary-policy instrument: to construct a purified monetary-policy proxy, keep the interest-rate surprise only on **negative-co-movement** (rate-up/stocks-down) announcement days and **set it to zero on positive-co-movement (rate-up AND stocks-up) days**, because those days are information-contaminated. Correlations with the sign-restriction shocks: **88%** for the monetary policy shock, **54%** for the information shock — different shocks, but "strikingly similar" impulse responses.

## 6. Data — surprise measures, sample, frequency

- **Interest-rate surprise:** change in the **3-month fed funds future** (reflects the expected funds rate after the *next* meeting; captures rate-setting + near-term forward guidance; insensitive to timing surprises). Traded on CBOT; tick data from Genesis Financial Technologies.
- **Stock surprise:** change in the **S&P 500** index.
- **Window:** 30 minutes — from **10 min before to 20 min after** the announcement (Gürkaynak–Sack–Swanson 2005a convention; narrow window avoids the Lucca–Moench pre-FOMC drift).
- **US sample:** **240 FOMC announcements, 1990–2016**, updated GSS (2005a) dataset provided by Refet Gürkaynak. Pre-1994 surprises measured around the next-day open-market operation (no press release before 1994).
- **Monthly aggregation** of intraday surprises into `m_t` for the VAR (Feb 1984–Dec 2016 macro sample).
- **Stylized fact:** ~1/3 of interior FOMC points are wrong-signed (33% of all interior points; 31% for points >2 s.d. from the axes). Robust across alternative surprise measures/principal components.
- **Euro area (Section IV):** newly constructed dataset, **280 ECB announcements, 1999–2016**; 3-month EONIA swap + EURO STOXX 50; 30-min window around 13:45 press statement + 90-min window around 14:30 press conference. **>40% (47% all interior / 42% at >2 s.d.)** wrong-signed — more than the US, consistent with the ECB's more transparent communication.

## 7. Findings — what changes when information shocks are purged

**Monetary policy shock (negative co-movement).** Impact: 3-min-window 3–6 bp rise in 3-month fed funds futures, 23–52 bp **drop** in S&P 500. Low-frequency: 1-year yield up ~5 bp (reverts within ~1 year), stock prices −~1%, excess bond premium **+~5 bp** (tightening financial conditions), real GDP **−~10 bp**, price level **−~5 bp**, both persistent. Key novelty vs standard HFI: **less-persistent interest-rate response and a more pronounced (vigorous) price-level decline** → the purged shock alleviates the **price puzzle**.

**CB information shock (positive co-movement).** Impact: up to +5 bp fed funds futures, +3 to +45 bp **rise** in S&P 500. 1-year yield up ~10 bp, reverts slowly (>2 years); EBP **falls ~3 bp** (financial conditions improve); **output up ~5 bp and price level up ~3 bp** (both persistent). Many `y_t` responses are the **opposite** of the monetary policy shock — despite rates rising in both. Interpretation: the CB reveals good news about (financial) demand conditions and tightens per its reaction function to partly offset it. Growth and inflation expectations (Consensus; 5-year break-even) rise together → demand-type information.

**Bias in standard HFI.** Standard HFI mixes the two: because information shocks push output/prices/EBP the opposite way, they **attenuate** the estimated monetary-policy responses of output, prices, and EBP, and inflate/prolong the interest-rate response. **Standard HFI underestimates the effectiveness of monetary policy.**

**Euro area.** Standard HFI produces theory-inconsistent results (stock prices rise, spreads fall after a tightening); the sign-restriction / poor-man's identification **removes the puzzle** — tightening then contracts output, lowers prices, and financial conditions no longer perversely improve. Confirms results are not US-specific.

**Refinement (Section IIIF) — CB information about supply.** Adds a third high-frequency variable (2-year break-even inflation surprise on announcement day) and a third shock (Table 3). Demand vs supply information distinguished by stock-price × inflation-expectation co-movement: positive → demand; negative → supply. Finding: the supply-information shock explains almost nothing; the break-even variable adds little; baseline conclusions robust.

**Structural interpretation (Section V / Appendix A).** New Keynesian model with nominal rigidities + financial frictions (Gertler–Karadi 2011). IRF matching: standard-HFI responses imply implausibly high price stickiness (Calvo ≈ 0.94, prices reset ~every 4 years) and near-zero financial frictions; the **purged** monetary-policy shock implies more moderate price stickiness (Calvo ≈ 0.87, no indexation) and **an order-of-magnitude larger role for financial frictions** (portfolio-adjustment cost κ: 0.0019 → 0.0452). The CB information shock is best matched by news about a **two-quarters-ahead capital-quality (asset-valuation) shock**.

## 8. Contributions

1. Uses **multiple** high-frequency surprises (interest rate + stock price) with sign restrictions to separate a pure monetary policy shock from a concurrent central bank information shock — a novel identification.
2. Shows the **direction of the 30-minute stock-market response is informative** about the economy's response over subsequent months.
3. Documents that standard HFI is **biased** by information shocks (attenuated macro responses, inflated/persistent rate response, price puzzle) — purging them yields theory-consistent, stronger monetary transmission.
4. Provides indirect evidence for **central bank private-information revelation** (information shocks predict outcomes that materialize).
5. Extends the identification to the **euro area**, where standard HFI is theory-inconsistent and the new identification resolves the puzzle.
6. Structural reassessment: purified shocks **raise the importance of financial frictions relative to nominal frictions** in monetary transmission.

## Related literature (positioning)

Builds on HFI/announcement-surprise work (Kuttner 2001; GSS 2005a; Bernanke–Kuttner 2005; Gertler–Karadi 2015; Nakamura–Steinsson 2018). On CB private information: Romer–Romer 2000; Barakchian–Crowe 2013; Campbell et al. 2017. Most closely related: **Andrade–Ferroni (2016)** and **Kerssenfischer (2019)** (euro-area sign-restriction information/policy separations) and **Cieslak–Schrimpf (2019)** (classifies monetary vs non-monetary shocks by the same interest-rate/stock co-movement). Distinct from Nakamura–Steinsson (2018)/Melosi (2017) by modeling communication as an independent channel and allowing the policy/information mix to vary over time.
