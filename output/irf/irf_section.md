# §5 — IRFs: the transmission of monetary policy shocks in Brazil

> **⚠ This file is no longer the canonical results text. `tex/main.tex`
> `\section{Resultados}` (§4) and `\section{Robustez}` (§5) are** (written
> 2026-07-29, rewritten 2026-07-30). This document remains the full reading of
> the production run.
>
> **The paper is now under a two-tier rule, not the 90%-only rule of
> 2026-07-29.** A 90% band excluding zero is a statistical result and is called
> *significativo*; a 68% band excluding zero enters as **direction and
> magnitude**, labelled and never called significant; anything else is a
> point-estimate trajectory. Under the intervening 90%-only rule five claims
> made below had no home in the paper: disinflation in `price_core_ipca_ex1`
> and `price_ipca_difusao`, the equity block (0 of 392 sig90), aggregate credit
> (0 sig90), every reversal past h≈17, and anything at all beyond h = 12 (92 of
> 2,597 pairs clear 90%, all at h ≤ 12).
>
> **The 2026-07-30 rewrite restored four of the five as labelled 68% material**:
> the medium-run reversal of the curve and of the Selic, the contraction of all
> seven credit cuts, the equity block at h = 0-1, and the `ex1` disinflation
> (which reaches 68% in exactly two horizons, h = 21 and h = 22). The one that
> stays out is `price_ipca_difusao`: it never reaches the 68% band anywhere in
> its decline, and the paper says so. Where this file and the `.tex` disagree,
> the `.tex` wins.

**Date:** 2026-07-26 (full rewrite; supersedes the 2026-07-12 draft, archived at
`arquivo/output/irf_section_2026-07-12.md`). The previous text ran on the
`z_jk_purif` instrument, the (r=6, q=5) grid and the pre-refresh data vintage.
Every number below is read off the production artifacts regenerated on
2026-07-24 (`irf_coherence_h.csv`, `spec_sweep_stage2.md`,
`mosw_strength_grid.csv`). **All heteroskedasticity-identified material has been
removed** — the het track was empirically rejected on 2026-07-16 and is out of
the paper by author decision.

**Specification (production).** DFM (Alessi-Kerssenfischer 2019), **r = 7**
static factors, **q = 6** dynamic shocks, VAR(**p = 6**) on the factors, panel
of **106 monthly series**, full sample 2013-01–2025-09 (147 aligned months).
Identification by external instrument **`z_jk_bs_purif`** — Copom Wed→Thu DI
futures surprises at the 126-business-day vertex, orthogonalized on
**predetermined pre-event** predictors in the Bauer-Swanson (2023) design, then
masked by the Jarociński-Karadi (2020) sign filter applied to those
predetermined residuals. Projection `H = (Z'η)/(Z'Z)` onto the q factor
innovations (Stock-Watson 2018). Shock normalized to **+50 bp on `yield_6m`** at
impact (+0.0050 in decimal proportion). Wild bootstrap (Gonçalves-Kilian 2004)
with Kilian (1998) bias correction **in the bootstrap DGP only** — the point
estimate is plain OLS — `nboot = 800`, seed 123, bands **68% / 90%**, horizons
0–48.

## Why this specification

The instrument's strength is measured by **ξ_mp**, the Montiel Olea-Stock-Watson
robust Wald statistic in the `yield_6m` impact direction (Eicker-White with the
Ŝ correction, `z` residualized on the factor-VAR lags). At (7, 6):

| sample | n | ξ_mp | AR set bounded |
|---|---|---|---|
| full 2013-01–2025-09 | 147 | **10.43** | yes |
| pre-COVID 2013-2019 | 78 | **12.22** | yes |

Among the four dimensions carried through the specification sweep, **(7, 6) is
the only one above 10 in both windows** — (5,4) 5.45 / 7.94; (6,5) 6.36 / 11.00;
(8,8) 12.57 / 8.99. On the full 14-cell MOSW grid the neighbours (7,5)
10.45 / 12.76, (7,7) 12.90 / 12.27, (8,5) 10.01 / 10.33 and (8,6) 10.03 / 10.76
also clear the bar, so **r = 7 is a robust plateau, not a knife-edge choice**.
The 95% Anderson-Rubin set is bounded (ξ_mp > 3.84) in all 28 cells of the
production instrument.

This position is recent and data-driven: it followed the **2026-07-24 vintage
refresh**, which dropped a duplicated block of four labour-search series
(a doubled join in `download.R`) and the all-NA ANBIMA break-even columns,
taking the panel to 106 series. Removing those artifacts is what lifted ξ_mp at
(7, 6) above 10 in both windows; on the previous vintage the reading favoured
(6, 5) pre-COVID and no dimension was strong in both.

**Note on the two rulers (read before cross-checking the tables).** The
specification sweep still classifies `failure_class` by the *legacy* max-F in
factor space (`f_factor` in `spec_sweep_cells.csv`), under which
`z_jk_bs_purif` scores 6.31 at (7,6) and therefore never appears among the
"eligible" cells of `spec_sweep_report.md`. The two statistics rank the
instruments almost inversely at this dimension — `z_jk_purif` has `f_factor`
11.08 but ξ_mp 5.77, while `z_jk_bs_purif` has `f_factor` 6.31 but ξ_mp 10.43.
The statistic that governs weak-instrument bias and the width of the AR set for
the single-proxy/single-shock design is **ξ_mp**, validated end-to-end against
the numbers Montiel Olea-Stock-Watson publish for the Kilian oil application
(ξ₁ = 4.4, robust F = 9.4; `script/validate_olea_kilian.R`). MOSW's own protocol
(their footnote 6) is to *report* ξ and use AR intervals, never to screen on a
first-stage F. The sweep's taxonomy is kept for continuity of the earlier
diagnostic but is not the decision rule of this paper.

`juros_selic` is the documented negative control: max reduced-form F = 2.49
across the whole grid.

---

## 5.1 Term structure

Impact and path by maturity (decimal proportion, reported in bp; +0.0050 = +50 bp):

| maturity | h0 | h3 | h6 | h12 | h24 | CI90 | CI68 |
|---|---|---|---|---|---|---|---|
| 3m | **+27.9** | +38.4 | +30.6 | −1.7 | −65.9 | h0-3 + | h0-4, h6 +; h24-43 − |
| 6m | **+50.0** | — | — | — | — | (normalization) | — |
| 1y | **+73.5** | +80.8 | +51.1 | −6.2 | −67.7 | h0-5 + | h0-7 +; h19-40 − |
| 2y | **+91.6** | +94.0 | +56.0 | −7.5 | −59.9 | h0-6 + | h0-7 +; h18-37 − |
| 5y | **+92.7** | +87.6 | +51.3 | −6.0 | −46.8 | h0-6 + | h0-7 +; h17-34 − |
| 10y | **+80.8** | +74.8 | +44.0 | −5.8 | −41.0 | h0-6 + | h0-7 +; h17-33 − |

All five scored maturities are `coerente_forte` with a **100% correct-sign share**
in the theory window — the cleanest block of the panel together with activity.

**Pass-through is increasing in maturity up to 5y** (+92.7 bp at 5y per +50 bp at
6m) and rolls off at 10y (+80.8 bp). This is the opposite of the US pattern
(Kuttner 2001; Gürkaynak-Sack-Swanson 2005), where the long end barely moves. It
is the signature of a fiscal risk premium in an emerging market (Blanchard 2004):
the same shock that raises the expected policy path widens EMBI and CDS with CI90
at impact (§5.3), and that premium loads on the long end. The mild 5y→10y
roll-off is consistent with expected normalization dominating at very long
horizons. The curve peaks at **h1** (2y +107 bp, 5y +106 bp), crosses zero at
**h≈11-12**, and turns negative with CI68 from h17-19 through h33-40 — the
subsequent easing cycle, internally consistent with the risk premia reverting
over the same horizons.

`juros_cdi` / `juros_selic` respond **−4.8 bp at impact and are never
significant at 90%**, turning negative with CI68 only from h25. The
month-average overnight rate does not embed a 6-month surprise within the shock
month — the maturity-mismatch attenuation documented in
`_instrucoes/justificativa_uso_yield-6m.md`, and the reason `yield_6m` is the
policy variable.

## 5.2 Equities

All eight B3 indices fall on impact, in a range of **−0.3% to −2.9%**, with the
trough at h1 (−3.1% to −5.5%). **None is significant at 90% at impact.**

| index | h0 | trough | significance | medium-run |
|---|---|---|---|---|
| IBOV | −1.67% | −3.11 (h1) | CI90 contains zero: [−7.77, +1.76]; CI68 at h1 | +20.3% at h24, CI68 h14-26 |
| SMLL (small caps) | −2.68% | −5.36 (h1) | CI68 h0-2 | +11.4% at h23 |
| IDIV (dividends) | −2.04% | −3.57 (h1) | CI68 h0-1 | +28.6% at h32 |
| IMOB (real-estate dev.) | −2.89% | −5.49 (h1) | CI68 h0-1 | +22.9% at h33 |
| MLCX (large caps) | −1.74% | −3.29 (h1) | CI68 h1 | +17.0% at h24, CI68 h20-24 |
| IFNC (banks) | −1.97% | −3.27 (h1) | CI68 h1 | +48.1% at h37, CI68 h17-35 |
| IMAT (materials) | −0.31% | −0.31 (h0) | never significant | +5.4% at h14, then −18.0% at h48 |
| **IFIX (real-estate income)** | **−1.03%** | **−33.3 (h48)** | **CI68 h0-8** | **negative at every horizon** |

Three readings, in order of how much weight they can carry:

1. **The impact repricing is economically sensible but statistically weak.**
   The cross-section ordering survives — small caps fall more than large caps
   (Gertler-Gilchrist 1994 financial-conditions channel), real-estate developers
   most, materials/exporters least (the BRL depreciation of §5.3 cushions
   exporter revenue) — but only SMLL, IDIV, IMOB and IFIX reach CI68 at impact
   and **no index reaches CI90**. The equity block should be reported as
   *directionally consistent, individually imprecise*, not as a significant
   finding.
2. **IFIX is the one clean result.** Listed real-estate *income* funds are the
   only index negative at every horizon through h48 (−33% cumulative), with CI68
   from h0 to h8. Contracted-rent cash flows price like long fixed income, so a
   permanent shift in the discount rate is not undone by the subsequent easing
   cycle — exactly the asset where the textbook prediction should be sharpest.
3. **The medium-run positive overshoot is the honest weak point.** Six of the
   eight indices turn positive from h≈5-10 and peak between h23 and h37 at
   implausible magnitudes (IFNC +48%, IDIV +29%). These segments reach CI68
   (IBOV h14-26, MLCX h20-24, IFNC h17-35) but **never CI90**. The accumulated
   level of a monthly return series is a random walk plus estimation error, so
   the level drifts with the accumulated point estimate while the bands widen;
   the honest statement is that the model has no information about the equity
   level beyond the first year. Report the impact window and the IFIX path; treat
   h > 12 as uninformative rather than as a finding.

**A note on magnitudes, which improved.** The previous draft reported −9% on the
IBOV per +50 bp and needed a three-part caveat explaining why that exceeded
Brazilian Copom event studies (typically 1–2% per 100 bp). Under the current
instrument, dimension and vintage the impact is **−1.7%, squarely inside the
event-study range**. The tension is gone: what remains is imprecision, not
implausible size.

## 5.3 Exchange rate and sovereign risk — the fiscal-dominance channel

| var | h0 | h3 | h6 | h12 | h24 | CI90 | CI68 |
|---|---|---|---|---|---|---|---|
| BRL/USD | **+0.1498** (≈ +3.6%) | +0.133 | +0.069 | −0.021 | −0.041 | h0-4 + | h0-5 + |
| BRL/EUR | +0.1446 | +0.120 | +0.051 | −0.030 | −0.005 | h0-3 + | h0-4 + |
| EMBI | **+0.1995 pp** (≈ +20 bp) | +0.121 | +0.068 | −0.049 | −0.170 | h0-1 + | h0-4 +; h18-32 − |
| CDS 5y | **+29.1 bp** | +22.4 | +13.6 | −3.0 | −17.5 | h0-4 + | h0-6 +; h18-31 − |

(BRL/USD in level; +0.1498 on a sample mean of 4.11 ≈ +3.6%. CDS on the panel's
×100 scale: +2907 = +29.1 bp.)

A contractionary shock **depreciates** the BRL and **widens** sovereign risk,
all four series significant at 90% at impact. This is the fiscal-dominance
reading (Blanchard 2004): when the debt path is the binding constraint,
tightening worsens debt dynamics in the short run, and the currency and the
sovereign spread price that deterioration rather than the higher carry. The four
series are scored `soft_*_fiscal_dom` precisely because the textbook prior points
the other way — and they are significant *against* that prior, which is the
finding, not an anomaly.

The channel is internally consistent across blocks: the responses decay
monotonically, cross zero at h≈9-11, and reach their most negative point with
CI68 at **h18-32** — the same horizons at which the yield curve turns negative
(§5.1) and disinflation arrives (§5.5). One shock, one premium, three markets
telling the same story with the same timing.

Magnitudes are ~40% smaller than the previous draft reported (BRL +0.150 vs
+0.245; EMBI +20 vs +46 bp; CDS +29 vs +56 bp). The sign, the significance and
the timing are unchanged.

**Benchmark vs GRG (2025).** Gonçalves-Rodrigues-Genta's daily
heteroskedasticity-IV finds BRL *appreciation* (−2.55% per +50 bp) and no CDS
response; our monthly DFM finds the opposite sign for the currency and a
significant widening of risk. The previous draft reconciled this through a
`z_het_3var` pre-COVID cell, which is no longer available — the het track is out
of the paper. The disagreement must therefore be discussed on its own terms, and
three differences are candidates:
(i) **frequency and object** — a 24-hour window prices the announcement, a
monthly DFM prices the general-equilibrium propagation (debt rollover,
term-premium repricing) that the daily window cannot reach;
(ii) **sample window** — our sample is 2013-2025 and the fiscal-dominance
reading is concentrated in the post-2020 regime;
(iii) **fiscal regime** — the sign is a property of the debt regime, not of the
method, so it is not expected to be universal across samples.
Discriminating among these is an open item, not something this section settles.

## 5.4 Credit

**Aggregates contract monotonically; the initial expansion is a sectoral
phenomenon.** This is a genuine change from the previous draft, which reported a
significant aggregate expansion at h0-h6.

| var | h0 | h6 | h12 | h24 | trough (h) | significance |
|---|---|---|---|---|---|---|
| total outstanding | −0.057 | −0.047 | −0.427 | −1.171 | −1.23 (29) | CI68 − h17-39 |
| households (PF) | −0.072 | +0.066 | −0.207 | −0.818 | −0.94 (32) | CI68 − h22-42 |
| firms: comércio | −0.263 | −0.491 | −1.172 | −2.176 | −2.19 (26) | CI68 − h15-37 |
| firms: construção | −0.318 | −0.303 | −0.876 | −2.319 | −2.44 (29) | CI68 − h19-41 |
| firms: indústria | **+0.188** | −0.208 | −0.767 | −1.625 | −1.63 (25) | CI68 + h0; CI68 − h16-38 |
| firms: transporte | **+0.751** | +0.104 | −0.924 | −1.967 | −1.97 (24) | **CI90 + h0-1**; CI68 − h15-35 |
| firms: agro | **+1.009** | +0.530 | −0.500 | −1.469 | −1.47 (25) | **CI90 + h0-3**; CI68 − h16-37 |

(log-points ×100 ≈ %; `credit_outstanding` and `credito_pessoa_fisica` are
`coerente_forte` with 100% and 90% correct-sign share.)

The Bernanke-Gertler (1995) / Gertler-Gilchrist (1994) chronology — firms draw
pre-approved credit lines to finance working capital and involuntary inventories
as cash flow tightens, and the contraction arrives only as lines mature and banks
reprice — **holds for the sectoral cross-section but not for the aggregate**.
Transporte and agro expand with CI90 at impact, indústria with CI68; comércio and
construção never expand; and the aggregate stock, which mixes them with
households, contracts from the start. The cross-section still supports the
mechanism in the way that matters most: **households, who have no lines to draw,
show no initial expansion**, while the three sectors with the heaviest working-
capital cycles do. But the aggregate claim from the earlier draft has to be
withdrawn.

Earmarked credit gives a mixed verdict on Bonomo-Martins (2016): **construção
confirms attenuation** (no expansion, latest trough at h29, CI68 only from h19 —
SFH funding at regulated rates insulates the sector), while **agro does not** —
it has the *largest* initial expansion in the panel, plausibly because equalized
rural rates still reference the Selic and the free share of agro funding grew
over 2013-25.

**Bank spreads (ICC) respond in two phases**, and the pattern is now cleaner than
in the previous draft: mechanical *compression* at impact (juridica −0.016,
fisica −0.031), then **widening peaking at h11** (juridica +0.072, fisica +0.134)
with CI68 at h14-19 and h8-16 respectively. The ICC is the average rate on the
*outstanding stock*, which reprices more slowly than funding costs when the Selic
rises, so the short-run compression is a measurement property; the delayed
widening is the financial accelerator (Bernanke-Gertler 1995;
Gilchrist-Zakrajšek 2012; Gertler-Karadi 2015) arriving at the lag at which the
stock has repriced and cyclical delinquencies bind. A new-concessions spread
should widen already in the short run and would be a desirable, non-blocking
addition.

## 5.5 Activity, labour, and prices

**Activity: the demand channel is the strongest block in the panel.** Six of the
nine activity variables are `coerente_forte` with a 100% correct-sign share, and
four are significant at **90%** at impact: industrial transformation (−1.41),
durable goods (−5.47), capital goods (−2.60, also CI90 at h11-12) and retail
sales (−1.04, also CI90 at h11). IBC-Br (−0.39), services (−0.45), autos and
capacity utilization are negative with CI68. The trough for the industrial block
is at **h11-12**, the textbook lag.

`pib` is the one activity series positive at impact (+0.163, not significant); it
turns negative from h≈10 and reaches −0.56 at h35 with CI68 from h31 — the
quarterly-interpolated series carries the least monthly information, and its
verdict is `coerente` (82% share) rather than strong.

**Labour** confirms the channel with the expected delay: unemployment is flat for
a year, then rises to +0.33 pp at h35 with CI68 from h27; employed population
rises at first (CI68 at h0) and falls with CI68 from h36; industrial hours worked
fall **−0.98 with CI90 at impact**, tracking the industrial block exactly.

**Prices — the section that must be reported most carefully.**

| measure | h0 | hump peak | disinflation | verdict |
|---|---|---|---|---|
| headline IPCA | −0.070 | **+0.181 at h5, CI90** | h9-33, min −0.077 (h12), n.s. | `parcial` (59%) |
| IPCA diffusion | +0.070 | +0.827 at h5, CI68 | h9-45, min −1.006 (h23), n.s. | `coerente` (100%) |
| core ex0 | +0.018 | +0.131 at h5, **CI90 h2, h4-8** | never negative | **`incoerente` (0%)** |
| **core ex1** | −0.055 | +0.071 at h5, CI68 | h9-45, min −0.063 (h21), **CI68 h21-22** | **`coerente_forte` (92%)** |
| core DW | +0.001 | +0.085 at h5, **CI90 h4-5, h7** | h11-34, n.s. | `parcial` (62%) |
| INPC | −0.113 | +0.142 at h5, CI68 | h9-38, min −0.133 (h12), CI68 h12 | `parcial` (73%) |

Two things changed relative to the previous draft and both cut against it:
**the short-run price hump is now significant at 90%** in headline (h5), ex0
(h2, h4-8) and DW (h4-5, h7) — the earlier text could say "never significant at
90%" and no longer can — and **core ex0 is now `incoerente`**, positive at every
horizon in the window.

What survives, and should carry the section:

- **Core ex1 is the primary price measure**: 92% correct-sign share, negative
  from h9 through h45, with CI68 disinflation at h21-22. It is the only measure
  that is `coerente_forte`.
- **The diffusion index corroborates it** with a 100% share: the *breadth* of
  price increases falls from h9 and troughs at h23, which is the disinflation
  signal least contaminated by the composition of the basket.
- **The hump is concentrated at h2-h8 and dies by h9** in every measure except
  ex0, and its timing (peak uniformly at h5) is common across measures — the
  signature of a common component, not of six independent puzzles.
- The transitory price puzzle is the most documented anomaly in monetary VARs
  (Sims 1992; Ramey 2016 — CPI flat-to-positive for 12-24 months even in
  Gertler-Karadi external-instrument designs; for Brazil, Minella 2003).

The previous draft closed this diagnosis by showing the hump was universal
across instruments and vanished pre-COVID under the same identification
(`relatorio/working-notes/2026-07-12_price_puzzle_ipca.md`). That evidence was
built on the old vintage and the old instrument; **the note's conclusion is
plausible but its numbers no longer reproduce**, and re-running the
cross-instrument IPCA comparison under (7,6) is an open item before this framing
can be used in the paper. Until then §5.5 should claim disinflation on ex1 and
diffusion, report the ex0 failure openly, and not assert that the hump is
sample-driven.

## 5.6 Robustness

1. **Instrument strength at the production dimension is a mask property.** At
   (7, 6) full sample, exactly three of the fourteen instrument variants clear
   ξ_mp ≥ 10: **`z_jk_raw` 10.55, `z_jk_bs_purif` 10.43, `z_jk_raw_purif`
   10.39** — precisely the three whose JK sign mask is built on **predetermined**
   information. Every variant whose mask is classified on contemporaneous
   residuals falls short (`z_jk` 6.30, `z_jk_purif` 5.77, `z_jk_purif_us` 5.44),
   as do the raw un-masked surprises (`z_bruto` 7.57, `z_bruto_purif` 6.62). This
   is the independent confirmation of the 2026-07-14 fidelity audit's finding
   that instrument strength lives in the mask rather than in the purified values:
   a contemporaneous mask classifies 2020-03-19 (the COVID liquidity panic) as a
   monetary day, and that single misclassification is enough to halve ξ_mp.
2. **Pre-COVID cross-instrument agreement.** On 2013-2019 at (7, 6), **twelve of
   the fourteen variants clear ξ_mp ≥ 10** (`z_bruto_purif` 17.67, `z_bruto`
   17.02, `z_bs_purif` 16.14, `z_jk_purif` 13.68, `z_jk` 12.84,
   **`z_jk_bs_purif` 12.22**, `z_jk_raw_purif` 11.10, `z_jk_raw` 10.45, …) —
   masks and values built by four distinct recipes (raw or orthogonalized ×
   with or without the sign filter) deliver the same answer where identification
   is strong. Figure: `output/irf/irf_spec_stage2_overlay.pdf`.
3. **Specification sweep, 480 cells** (12 instruments × 5 policy variables ×
   4 (r,q) × 2 windows): zero `sign_puzzle` and zero `unstable_normalization`
   cells in the full sample — every sign inversion in the grid traces to weak
   relevance, none to an unstable normalization or a genuine puzzle. See the
   ruler caveat in "Why this specification" before comparing the sweep's
   eligibility flags with ξ_mp.
4. **Point-by-point coherence, 53 variables × 49 horizons** scored against theory
   windows (`output/irf/irf_coherence_report.md`), tally as of the B2/B3 fixes of
   2026-07-28: **22 `coerente_forte`, 5 `coerente`, 11 `parcial`,
   1 `incoerente`** (core ex0), 7 ambiguous, 4 soft-channel (FX/risk) and
   **3 placebos, all passing — there is no placebo violation any more**
   (§Caveats). `yield_6m` was added to the table as an audit row for the
   normalization, which is what takes the count from 52 to 53.
5. **Jaggedness (footnote-level).** Short-horizon wiggles in low-commonality
   series (equities, headline IPCA) trace to 3-4-month complex roots of the
   factor VAR(6) and lie inside the bands at every horizon; roughness correlates
   −0.50 (Spearman) with commonality
   (`relatorio/working-notes/2026-07-12_irf_dentadas.md` — mechanism is
   instrument- and dimension-independent, so the diagnosis carries over even
   though its magnitudes are from the old vintage). **No ex-post smoothing.**

## 5.7 Paper-worthy findings (summary)

1. **Transmission under fiscal fragility** (the pitch): the long curve amplifies
   (+92.7 bp at 5y per +50 bp at 6m — the opposite of the US pattern), the BRL
   depreciates ≈3.6% and sovereign risk widens (EMBI +20 bp, CDS +29 bp), all
   with CI90 at impact; all three revert with CI68 over h17-32 as disinflation
   arrives. Three faces of one fiscal-premium channel, with matching timing.
2. **A complete and significant demand channel**: 8 of 9 activity variables
   negative at impact (all nine by h12), four with CI90 at impact, industrial
   trough at h11-12; industrial hours −0.98 with CI90; unemployment +0.33 pp
   with CI68 from h27.
3. **The credit channel is sectoral, not aggregate**: transporte, agro and
   indústria expand at impact (two with CI90) while households and the aggregate
   stock contract from the start — the Gertler-Gilchrist credit-line mechanism
   shows up exactly where working-capital cycles are heaviest. ICC spreads
   compress mechanically then widen at h11 (financial accelerator).
   Earmarked-credit attenuation is confirmed for construção, rejected for agro.
4. **Disinflation lives in core ex1 and in the diffusion index**, not in the
   headline: ex1 is the only `coerente_forte` price measure (92% share, CI68 at
   h21-22) and diffusion corroborates at 100%. The h2-h8 hump is significant at
   90% in headline, ex0 and DW and is reported as an open limitation.
5. **Instrument strength is a property of the sign mask.** Only predetermined-
   mask variants clear the MOSW threshold at the production dimension — a
   methodological result that is useful independently of the Brazilian
   application, and that follows from a fidelity audit rather than from a
   specification search.

## Files

- Production IRFs: `output/irf/irf_model_alessi_r7q6.pdf` (from
  `script/model_alessi.R`, explicit `r = 7L, q = 6L` override).
- Coherence: `output/irf/irf_coherence_{h,summary}.csv`,
  `irf_coherence_report.md`, `irf_coherence_plots.pdf`, `irf_coherence_cell.rds`
  (full estimation object — reuse it instead of re-estimating).
- Sweep: `output/irf/spec_sweep_{cells,irf_long}.csv`,
  `spec_sweep_{report,stage2}.md`, `irf_spec_full_r7q6_z_jk_bs_purif.{rds,pdf}`,
  `irf_spec_stage2_overlay.pdf`.
- Instrument strength: `output/instrument/mosw_strength_grid.{csv,md}`,
  `olea_alignment_audit.md`, `instrument_diagnostics_report.md`.

## Caveats

- **Units.** Yields in decimal proportion (+0.005 = 50 bp); equity indices are
  monthly returns cumulated to a price level (tcode 2), in log-points ≈ %;
  `cambio_usd` in BRL/USD level (sample mean 4.11, so +0.1498 ≈ +3.6%);
  `cds_5y` on the panel's ×100 scale (+2907 = +29.1 bp); `embi_perc` in
  percentage points; credit stocks in log-points ×100 (tcode 4).
- ~~**Placebo violated: `commodity_metal`.**~~ **Retracted 2026-07-28 (fix B3),
  and a unit error corrected 2026-07-29.** Two things were wrong. First the
  unit: the metals index responds **+10.41 index points**, which on a sample
  mean of 303.3 is **+3.43%**, not "+10.4%" as this caveat originally read.
  Second, and decisive, the response is not an exogeneity failure at all. The
  BCB IC-Br is **denominated in BRL**, so it is a domestic price that
  mechanically inherits the FX response. In an augmented panel (nboot = 200,
  `diagnostics/01_exogeneidade.R` §1.6) the three BRL-denominated indices violate
  (metals +3.98%, CI90 [+1.79%, +6.09%], sig90 in 4 of the first 5 horizons)
  while the three USD-denominated ones pass clean (metals +0.59%,
  CI90 [−2.03%, +2.65%], **0 of 25** horizons). A global commodity factor would
  move the USD index, and it does not. `commodity_metal` was retiered to
  `ambiguous`; the `placebo` tier now holds only `sp500_vix`, `msci` and
  `epu_us`, and **all three pass**. This is no longer an exogeneity caveat.
- **Weak-IV margin.** ξ_mp = 10.43 (full) sits just above the Stock-Yogo
  threshold; the AR set is bounded in both windows, so conventional bands are
  approximately valid and Anderson-Rubin intervals are **optional robustness**
  rather than mandatory. Following MOSW's protocol, ξ is reported rather than
  used as a screening filter.
- **Core ex0 is incoherent** (positive at every horizon, CI90 at h2 and h4-8) and
  the short-run hump is significant at 90% in the headline and DW cores. The
  disinflation claim rests on ex1 and the diffusion index; it is not claimed for
  the headline.
- **Equities are directionally consistent but individually imprecise**: no index
  reaches CI90 at impact, and the medium-run positive overshoot (CI68 only)
  should be treated as uninformative rather than as a finding. IFIX is the
  exception worth reporting.
- **`nboot = 800`** (paper quality); 2000 draws would tighten tails only
  marginally.
