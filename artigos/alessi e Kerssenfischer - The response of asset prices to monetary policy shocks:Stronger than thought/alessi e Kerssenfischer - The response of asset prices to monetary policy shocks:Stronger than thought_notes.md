# Reading Notes — Alessi & Kerssenfischer (2019), "The response of asset prices to monetary policy shocks: Stronger than thought"

Read as a single unit (5,349 words — one chunk; below the multi-batch threshold).
This is the **paper this project replicates for Brazil**.

## Bibliographic metadata (confirmed in the text)

- **Authors:** Lucia Alessi (European Commission, Joint Research Centre, Ispra) and Mark Kerssenfischer (Deutsche Bundesbank, Frankfurt).
- **Journal:** *Journal of Applied Econometrics*, 2019, **vol. 34, no. 5, pp. 661–672**. (Self-citation block at the end of the article states "J Appl Econ. 2019;34:661–672".)
- **DOI:** 10.1002/jae.2706. Open access (CC-BY).
- Article type: Research Article (short-format).

## 1. Research question

Why do small-scale VARs find sluggish and often insignificant asset-price
responses to monetary policy shocks when standard theory (and event-study
evidence) predicts an immediate and large repricing? The paper asks whether the
gap is caused by **identification** or by the **size of the information set**,
and answers by holding identification fixed and varying only the model.

## 2. Audience

Monetary VAR / proxy-SVAR empiricists; the dynamic-factor-model literature; the
non-fundamentalness literature; anyone comparing event-study and VAR estimates of
monetary transmission.

## 3. Method — DFM and VAR under the *same* external instrument

The design is a controlled comparison. The **same high-frequency external
instrument** identifies the shock in two models:

1. a **large-scale non-stationary DFM** (Barigozzi, Lippi & Luciani 2016a,b), and
2. a **4-variable benchmark VAR** with log industrial production, log CPI, the
   2-year sovereign yield, and one asset price at a time, with the **same lag
   length p = 6** and the **same identification scheme**.

Since only the information set changes, differences in the impulse responses are
attributable to the information set and not to the identification assumption.

**DFM specification.** With a deterministic trend, each series is the sum of a
common and an idiosyncratic component:

- `Y_t = α + β·t + χ_t + ξ_t`, `χ_t = Λ F_t` (eq. 1)
- `Φ(L) F_t = e_t`, `e_t = H ε_t` (eq. 2)

Benchmark: **p = 6, r = 8**, and the authors set **q = r** (footnote 4: given the
external-instrument scheme, results are virtually identical whether or not q < r;
Bai-Ng (2002) suggests r = 8 for both datasets). The only extra assumption
relative to a standard DFM is that the factors are I(1) and the idiosyncratic
components are I(0) or I(1) — no differencing, no cointegration estimation.

**Estimation** (Barigozzi et al. 2016b): estimate Λ by principal components on
the **first-differenced** dataset, recover factors in levels as `F̂_t = Λ̂' X_t`
on the detrended data `X_t = Y_t − α̂ − β̂·t`, then estimate eq. 2 as a
**conventional unrestricted VAR in levels** on the non-stationary static factors.
Justification: Sims, Stock & Watson (1990) show that a cointegrated VAR is
consistently estimated by an unrestricted VAR in levels, which obviates estimating
the cointegration relations; Barigozzi et al. (2016b) show the levels VAR beats a
VECM for **short-run** impulse responses because the estimator converges faster.

**Identification (§2.4) — external instrument.** Citing Gertler & Karadi (2015)
and Stock & Watson (2012). With the monetary shock ordered first,

`E(e_t Z_t) = E(H ε_t Z_t) = [H_1 H_•] [E(ε_1t Z_t); E(ε_•t Z_t)] = H_1 α` (eq. 3)

Validity conditions stated as **relevance** `E(ε_1t Z_t) = α ≠ 0` and
**exogeneity** `E(ε_•t Z_t) = 0`. Under these, `H_1` — the only column needed — is
obtained by **regressing `Z_t` on all reduced-form shocks `e_t`** and normalizing
the impact effect.

**Normalization:** a contractionary shock that raises the **2-year sovereign bond
yield by 50 basis points**, chosen because short rates were at the effective lower
bound for much of the sample (the euro-area case uses the German 2-year rate).

**Inference:** wild bootstrap of Gonçalves & Kilian (2004), which flips the sign
of the reduced-form residuals **and of the external instrument** in randomly
selected periods. Footnote 8 gives the four steps: (1) estimate Λ, F, Φ(L), e from
the actual data; (2) resample e by wild bootstrap to get artificial factors F*;
(3) use Λ to build artificial common components and add ξ to get an artificial
dataset Y*; (4) re-apply the whole estimation procedure to Y*. **Idiosyncratic
components are not bootstrapped.** The **Kilian (1998) bias correction is applied
in step 2**. Bands are **80% and 90%**.

## 4. Data

- **Euro area:** N = **88** macro series, **April 2000 – December 2017**.
- **USA:** N = **95** series, **June 1976 – December 2017**. Uses the cleansed
  McCracken & Ng (2016) FRED-MD dataset, with an analogous euro-area dataset built
  by the authors — motivated by Boivin & Ng (2006), who show a larger cross-section
  can *worsen* factor estimates when the added variables are highly collinear.
- Coverage in both: real activity, prices, employment, and many financial-sector
  variables. **All series kept in levels or log-levels** (trends and
  non-stationarity are allowed for by design).
- **Asset prices studied:** stock prices (S&P 500 / Euro STOXX), house prices
  (Shiller for the US; ECB, cubic-spline interpolated from quarterly, for the euro
  area), corporate bond yields (AAA, BAA) and an excess bond premium
  (Gilchrist-Zakrajšek 2012 for the US; Gilchrist-Mojon 2016 for the euro area),
  and exchange rates against GBP, CAD, CHF and each other.

**Instruments.**
- **Euro area:** movement in the **German Bobl future** (5-year underlying; one of
  the most liquid euro-area bond futures) from **10 minutes before the press
  release to 20 minutes after the end of the press conference** on Governing
  Council days. Series from Kerssenfischer (2019a), available from **March 2002**,
  covering **179 Governing Council meetings**. The percentage price change is
  divided by the modified duration of the cheapest-to-deliver underlying.
- **USA:** follows Gertler & Karadi (2015) — change in the **3-month-ahead federal
  funds future**, 10 minutes before to 20 minutes after FOMC announcements.

## 5. Findings

- **Corporate bonds.** The DFM finds larger effects across the board. On US data
  the response of bond yields and of the excess bond premium is **twice as large on
  impact in the DFM as in the VAR**. In the euro area the DFM's excess-bond-premium
  response is insignificant, while the small VAR produces a **counterintuitive
  decline**.
- **Exchange rates.** US: similar VAR and DFM responses against GBP and CAD, but
  the CAD appreciation is **almost twice as large** in the DFM; the VAR shows an
  implausible **delayed** response for EUR and CHF. Euro area: both models give an
  immediate and universal euro appreciation, larger in the factor model.
- **Stock and house prices.** US: both find a sizable significant drop in stocks,
  larger and more immediate in the DFM. Euro area: the VAR response of stocks is
  puzzlingly small; the DFM is larger but still insignificant. US house prices
  **rise** after a contractionary shock in the VAR (counterintuitive) but fall
  about **1.5% over two years** in the DFM. Euro-area house prices are the one
  reversal — plausible and significant in the VAR, insignificant in the DFM.
- **Core variables (Figure 4).** On US data, the DFM has output and prices both
  declining after a tightening, in line with theory, while **most VAR
  specifications find expansionary effects on industrial production and a muted
  price response**. The puzzle is worst when the VAR's fourth variable is an
  exchange rate. Euro-area VARs are equally counterintuitive; the factor model
  attenuates but does not fully solve this.
- **Not a persistence artifact** (footnote 12): 2-year yields and money-market
  rates revert slowly in the VARs and quickly in the factor models, so the stronger
  asset-price responses cannot be explained by the DFM capturing a more persistent
  shock.
- **Residual US/euro-area differences are attributed to central bank information
  effects.** The instrument treats *any* announcement that raises yields as
  contractionary; an announcement can also raise yields by signalling a
  better-than-expected outlook. In either case the domestic currency appreciates,
  but the effects on stock prices and bond premia are opposite. If information
  effects matter more for the ECB (as Jarociński & Karadi argue), that explains the
  stronger euro-area FX response and the more muted stock/premium responses.

## 6. Contributions

1. Holds identification fixed and varies only the information set, isolating the
   information set as the explanation for sluggish VAR asset-price responses.
2. Applies the **non-stationary** DFM of Barigozzi-Lippi-Luciani with an external
   instrument, avoiding the differencing that forces all common shocks to have
   permanent effects.
3. Shows the result holds in **two regions** (euro area and US), so it is not a
   feature of one sample or one central bank.
4. Reframes the "puzzling VAR results" literature as an informational problem
   (non-fundamentalness) rather than an identification problem: even with a valid
   high-frequency instrument, a small VAR still produces puzzles.

## 7. Replication feasibility

Open-access article. Supporting Information appendix lists all variables and
transformations for both datasets and contains the robustness figures. US data is
public (FRED-MD, McCracken-Ng 2016; Gilchrist-Zakrajšek EBP; Shiller house
prices). The euro-area instrument comes from Kerssenfischer (2019a) and the
euro-area dataset was constructed by the authors. No public code repository is
mentioned in the article text.

## 8. Robustness appendix (relevant as a template)

Figures A1–A4 vary one dimension each against the benchmark (p = 6, r = 8, q = 8):
- **A1** lag length: p = 3, 4, 9
- **A2** static factors: r = 7, 9, 10
- **A3** dynamic factors: q = 5, 6, 7
- **A4** the external instrument itself: for the US, 3-month Eurodollar futures 3,
  6 and 9 months ahead; for the euro area, the 2-year and 10-year Bund futures and
  the first principal component of all three futures changes.

## Relevance to this project

This is the design being replicated for Brazil, with three deliberate departures
documented elsewhere in the repo: (i) the identification is projected through
`H = (Z'η)/(Z'Z)` on the factor innovations rather than a regression of Z on all
reduced-form shocks, but the object is the same single column; (ii) the policy
variable is the **6-month** DI-implied yield rather than a 2-year sovereign yield,
with the same +50 bp normalization; (iii) q < r is used here (r = 7, q = 6),
whereas Alessi-Kerssenfischer set q = r after finding it immaterial under external
-instrument identification. The bootstrap (Gonçalves-Kilian wild, Kilian 1998 bias
correction confined to the bootstrap DGP) and the p = 6 factor VAR follow the
paper directly. **Figure A4 is the analogue of this project's
`vertex_irf_overlay.pdf`** (13 DI vertices giving essentially the same IRF).
