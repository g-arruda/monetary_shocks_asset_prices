# §5 — IRFs: the transmission of monetary policy shocks in Brazil

**Date:** 2026-07-12 (full rewrite; supersedes the 2026-05-06 draft and its
2026-05-08 status note — the old text treated `z_het_jk_3var` as primary and
ran on the legacy r=8/q=8 grid; every table below is from the current
production estimation and the 2026-07-11/12 diagnostic sessions).

**Specification (production):** DFM (Alessi-Kerssenfischer 2019),
**r = 6** static factors, **q = 5** dynamic shocks, VAR(**p = 6**) on
factors, full sample 2013-01–2025-09 (147 aligned months). Identification by
external instrument **`z_jk_purif`** (Copom Wed→Thu DI-futures surprises,
Bauer-Swanson purification, Jarociński-Karadi sign filter), projection
`H = (Z'η)/(Z'Z)` (Stock-Watson 2018). Shock normalized to **+50 bp on
`yield_6m`** at impact. Wild bootstrap (Gonçalves-Kilian 2004) with Kilian
(1998) bias correction in the bootstrap DGP, `nboot = 800`, seed 123, bands
**68% / 90%**, horizon 0–48 months.

**Why this spec.** The 320-cell specification sweep
(`output/irf/spec_sweep_conclusoes.md`) showed that every sign inversion in
the instrument × mp_var × (r,q) × sample grid is weak factor-space relevance
(F < 10) — zero `sign_puzzle` or `unstable_normalization` cells. `z_jk_purif`
at (6,5) is the only full-sample cell crossing Stock-Yogo (**F factor-space
= 10.08**) that is also the pre-COVID grid peak (**15.40**). The auto-IC
choice (5,4) is borderline-weak (9.20) and is never used as base case.
`juros_selic` as mp_var is the negative control (max reduced-form F = 2.49).

---

## 5.1 Term structure

Impact responses (decimal proportion; +0.0050 = +50 bp):

| maturity | h0 | h6 | h12 | h24 | significance |
|---|---|---|---|---|---|
| 3m | +27 bp | +20 | +1 | −13 | CI90 h0-1 |
| 6m | +50 bp | (normalization) | | | — |
| 1y | +77 bp | +62 | +14 | −19 | CI90 h0-3 |
| 2y | +105 bp | +81 | +21 | −21 | CI90 h0-3 |
| 5y | +122 bp | +88 | +25 | −22 | CI90 h0-7 |
| 10y | +112 bp | +81 | +24 | −21 | CI90 h0-7 |

Pass-through is **increasing in maturity** up to 5y — the opposite of the
US pattern (Kuttner 2001; Gürkaynak-Sack-Swanson 2005, where the long end
barely moves). This is not a defect: it is the signature of a fiscal risk
premium in an emerging market (Blanchard 2004). The same shock that raises
the expected policy path widens EMBI (+46 bp) and CDS (+56 bp) with CI90 at
h0-7 (§5.3), and the risk premium loads on the long end. The mild 5y→10y
roll-off is consistent with expected normalization dominating at very long
horizons. The whole curve crosses zero at h≈13-18 (the subsequent easing
cycle) and turns mildly negative with CI68 on the long end at h≈35-38.

`juros_cdi`/`juros_selic` respond only +2 bp (never significant): the
month-average overnight rate does not embed the 6m surprise within the
shock month — the known maturity-mismatch attenuation
(`_instrucoes/justificativa_uso_yield-6m.md`), which is why `yield_6m` is
the policy variable.

## 5.2 Equities

All eight B3 indices drop on impact with significance (CI90 in six, CI68+
in all), stay negative with CI68 at h1, and revert to ≈0 from h2 on with
**no positively significant horizon** (one exception below). This is
immediate, complete repricing — what forward-looking asset prices should
do; the price level jumps and then follows a random walk.

| index | h0 | reading |
|---|---|---|
| IBOV | −8.9% | CI90 at h0 |
| MLCX (large caps) | −8.8% | CI90 at h0 |
| SMLL (small caps) | −10.4% | small > large: financial-conditions sensitivity (Gertler-Gilchrist 1994 analogue) |
| IDIV (dividends) | −9.0% | duration-heavy cash flows |
| IFNC (banks) | **−11.2%** | largest drop; duration losses dominate on impact, later margin recovery (English-Van den Heuvel-Zakrajšek 2018) |
| IMOB (real estate dev.) | −10.9% | rate-sensitive demand |
| IFIX (real estate income) | **−3.8%** | smallest drop, only index never crossing zero (negative through h48): repricing like long fixed income |
| IMAT (materials/exporters) | −4.7% | **only index with a significant positive segment (CI68, h2-9)**: BRL depreciation (§5.3) lifts exporter revenue — the FX channel resolves the ambiguity |

**Magnitude caveat (honest).** Bernanke-Kuttner (2005) find ≈ −1% on the
S&P per +25 bp of *target* surprise. Our −9% per +50 bp is above Brazilian
Copom-day event studies (order of 1-2% per 100 bp). Three compounding
reasons, to be stated in the text: (i) the shock is a persistent *path*
shift (a 6m-rate surprise ≈ the GSS path factor, which moves equities far
more than the target factor); (ii) the response is monthly and general-
equilibrium — it embeds the +5-6% FX depreciation and +50 bp sovereign-risk
widening that amplify the discount rate, unlike 1-day event windows;
(iii) EM equity beta. Report as upper-bound magnitude with this
decomposition — not as a violation.

## 5.3 Exchange rate and sovereign risk — the fiscal-dominance channel

| var | h0 | h6 | h12 | h24 | h31-37 | significance |
|---|---|---|---|---|---|---|
| BRL/USD | +0.245 (≈ +6%) | +0.234 | +0.079 | −0.069 | ≈0 | CI90 + at impact |
| EMBI | +0.46 pp | +0.30 | +0.08 | −0.14 | negative | CI90 + h0-7; CI68 − h33-36 |
| CDS 5y | +56 bp | +38 | +12 | −13 | negative | CI90 + h0-7; CI68 − h31-37 |

A contractionary shock **depreciates** the BRL and **widens** sovereign
risk, all significant at 90% on impact — the fiscal-dominance reading
(Blanchard 2004): tightening worsens debt dynamics in the short run. The
responses decay monotonically and **cross below baseline with CI68 at
h≈31-37**, when disinflation and the easing cycle improve the premium —
internally consistent with the curve turning negative at the same horizons.

**Benchmark vs GRG (2025).** GRG's daily heteroskedasticity-IV finds BRL
**appreciation** (−2.55% per +50 bp) and no CDS response. Our full-sample
DFM finds the opposite sign. The sweep resolves this as **sample- and
horizon-driven, not method-driven**: (i) the monthly DFM aggregates GE
propagation (debt rollover, term-premium repricing) that a 24-hour window
cannot capture; (ii) on the pre-COVID window, `z_het_3var` × (6,5) — the
identification closest to GRG's — is the grid's only cell with FX
**appreciation**, disinflation, and damped curve ordering (the GRG standard
channel), with F = 10.8 but wide bands. We report that cell as qualitative
robustness (with Anderson-Rubin bands if promoted into the paper): the
fiscal-dominance reading is dominant in the 2013-25 sample but **not
universal** — it is a property of the fiscal regime, concentrated in the
COVID/post period.

## 5.4 Credit

Stocks (log-points ×100 ≈ %):

| var | h0 | h6 | h12 | h24 | trough (h) | significance |
|---|---|---|---|---|---|---|
| total outstanding | +0.43 | +0.37 | −0.08 | −0.63 | −0.88 (38) | CI90 + h0-2 |
| firms: comércio | +0.48 | +0.80 | −0.23 | −1.62 | −1.72 (29) | CI90 + h1 |
| firms: transporte | +1.97 | +1.80 | +0.22 | −1.48 | +2.37 peak (1) | CI90 + h0-6 |
| firms: indústria | +0.88 | +1.03 | +0.07 | −1.19 | −1.30 (30) | CI90 + h0-4 |
| firms: agro | +0.89 | +1.16 | −0.07 | −1.47 | −1.69 (32) | CI90 + h0-3 |
| firms: construção | +0.02 | +0.43 | −0.28 | −1.45 | −1.82 (39) | CI68 + h1 only |
| households (PF) | +0.01 | −0.01 | −0.15 | −0.29 | −0.73 (43) | never |

The dominant pattern — **significant expansion at h0-h6, zero-crossing at
h≈10-14, contraction troughing at h≈29-43** — is the classic credit-channel
chronology: Bernanke-Gertler (1995) document that total credit *rises* in
the first quarters after a tightening; Gertler-Gilchrist (1994) show firms
draw pre-approved credit lines to finance working capital and involuntary
inventories as cash flow tightens; the contraction arrives as lines mature
and banks reprice. The cross-section confirms the mechanism: **households —
who have no credit lines to draw — show no initial expansion** and decline
from h6. Earmarked credit gives a mixed verdict on Bonomo-Martins (2016):
**construção fully confirms attenuation** (slowest zero-crossing, latest
trough, no significant response in either direction — SFH funding at
regulated rates insulates the sector), while **agro does not** (responds
like free credit — plausibly because equalized rural rates still reference
the Selic and the free share of agro funding grew over 2013-25).

**Bank spreads (ICC)** respond in **two phases**: significant *compression*
at h0-h7 (juridica CI90 h0-4; the ICC is the average rate on the
*outstanding stock*, which reprices slower than funding costs when the
Selic rises — mechanical), then **widening with CI68 at h19-h30** (juridica
peak +0.08 at h25; fisica +0.13) — the financial accelerator
(Bernanke-Gertler 1995; Gilchrist-Zakrajšek 2012; Gertler-Karadi 2015)
arriving with the lag at which the stock has repriced and cycle
delinquencies bind. A new-concessions spread would be expected to widen
already in the short run — a desirable (non-blocking) addition.

## 5.5 Activity, labor, and prices

**Activity: the demand channel is complete and significant.** All nine
activity variables (IBC-Br, PIB, industrial transformation, durables,
capital goods, retail, services, autos, capacity utilization) are negative
from h=3 with CI68+ significance and 100% sign-share in the h3-24 window.
Unemployment rises from h≥6; industrial hours fall (both significant).

**Prices: report honestly, with the sample decomposition.** The headline
IPCA shows a positive hump at h0-h12 that is **never significant at 90%**
(CI68 only at h4-h8, peak +0.21) and crosses zero at h≈21. Three facts
close the diagnosis (`relatorio/working-notes/2026-07-12_price_puzzle_ipca.md`):
(i) the hump appears with **all 8 instruments** at (6,5) full-sample —
including the heteroskedasticity-identified ones that share nothing with
Copom-day timing — and the JK sign filter does not shrink it, ruling out
information-shock contamination; (ii) with the **same identification, the
pre-COVID window shows disinflation at every horizon** (h9 −0.21, h24
−0.15, n.s.), precisely where the instrument is strongest (F = 15.4);
(iii) the transitory price puzzle is the most documented anomaly in
monetary VARs (Sims 1992; Ramey 2016 — CPI flat-to-positive for 12-24
months even in Gertler-Karadi external-instrument designs; for Brazil,
Minella 2003). The full-sample hump is the 2021-22 composition (Selic
2%→13.75% while supply/commodity/fiscal shocks pushed IPCA up), not an
identification failure.

**The paper's primary price measure is the core `ex1`** — coherent-strong
(84% correct-sign share in h12-48, disinflation significant at CI68 from
h≈15), corroborated by the IPCA diffusion index (92% share). Cores ex0 and
DW concentrate the weak-disinflation limitation of `z_jk_purif` and are
reported with that reading.

## 5.6 Robustness

1. **Pre-COVID cross-instrument (headline robustness).** On 2013-2019 with
   (r=6, q=5), **five instruments cross Stock-Yogo** (z_jk_purif 15.4, z_jk
   15.2, z_het_jk_3var 11.1, z_het_3var 10.8, z_bruto_purif 10.4) spanning
   **two independent identification schemes** (Copom-day timing and
   Rigobon-Sack heteroskedasticity) and agree on the hard signs and the
   transmission signs — including IPCA negative at every horizon for all
   eight instruments. Table/figure: `output/irf/spec_sweep_report.md`,
   `irf_spec_stage2_overlay.pdf`.
2. **`z_het_3var` pre-COVID appreciation cell** as qualitative
   reconciliation with GRG (§5.3), with Anderson-Rubin bands if promoted.
3. **Specification grid.** 320 cells; every failure is weak factor-space F;
   whenever F ≥ 10, hard signs are correct in any combination.
4. **Point-by-point coherence.** 52 panel variables scored at every h
   against theory windows (`output/irf/irf_coherence_report.md`): the
   verdicts and the localized anomalies (ICC window, headline hump) are all
   traced to measurement or sample composition, none to identification.
5. **Jaggedness (footnote-level).** Short-horizon wiggles in low-
   commonality series (equities, headline IPCA) trace to 3-4-month complex
   roots of the factor VAR(6) (modulus 0.82) and are inside the bands at
   every h; roughness correlates −0.50 (Spearman) with commonality
   (`relatorio/working-notes/2026-07-12_irf_dentadas.md`). No ex-post
   smoothing.

## 5.7 Paper-worthy findings (summary)

1. **Transmission under fiscal fragility** (the pitch): the long curve
   amplifies (+122 bp at 5y per +50 bp at 6m — opposite of the US), the
   BRL depreciates and sovereign risk widens, all CI90 at impact; the
   medium run reverses (CI68) as disinflation arrives. Three faces of one
   fiscal-premium channel, internally consistent.
2. **Complete, significant demand channel**: 9/9 activity variables, labor,
   and credit stocks respond with textbook signs and CI68+ significance.
3. **Credit-channel chronology matches BG95/GG94** including the
   firms-vs-households cross-section and the two-phase spread response;
   earmarked-credit attenuation confirmed for construção, not agro.
4. **Prices**: disinflation lives in core ex1 and diffusion (CI68); the
   headline hump is n.s., sample-driven, and vanishes pre-COVID under the
   same identification — a price-puzzle decomposition, not a puzzle claim.
5. **Two identification paradigms agree** where both are strong (pre-COVID
   grid), and the lone GRG-style appreciation cell shows the
   fiscal-dominance reading is regime-dependent — an empirical statement
   about the fiscal regime, not a methodological artifact.

## Files

- Production IRFs: `output/irf/irf_model_alessi_r6q5.pdf` (from
  `script/model_alessi.R`, r=6/q=5 override).
- Coherence: `output/irf/irf_coherence_{h,summary}.csv`,
  `irf_coherence_report.md`, `irf_coherence_plots.pdf`,
  `irf_coherence_cell.rds`.
- Sweep: `output/irf/spec_sweep_{cells,irf_long}.csv`,
  `spec_sweep_{report,stage2,conclusoes}.md`, `irf_spec_<tag>.{rds,pdf}`,
  `irf_spec_stage2_overlay.pdf`.
- Working notes (2026-07-12): `price_puzzle_ipca`,
  `irf_credito_ativos_financeiros`, `irf_dentadas` under
  `relatorio/working-notes/`.

## Caveats

- **Units**: yields in decimal proportion (+0.005 = 50 bp); equities in
  log-points (≈ %); `cambio_usd` in BRL/USD level (+0.245 ≈ +6% at the
  sample mean ≈ 4.1); `cds_5y` on the panel ×100 scale (+5604 = +56 bp);
  credit stocks in log-points ×100 (tcode 4).
- **Weak-IV margin**: full-sample F factor-space = 10.08 sits at the
  Stock-Yogo threshold; the strong window (pre-COVID, F = 15.4) has n = 78.
  Anderson-Rubin bands are the pre-submission to-do, mandatory for any het
  variant promoted beyond qualitative robustness.
- **Headline disinflation is not claimed**: the h21-40 negative segment of
  headline IPCA is n.s.; the disinflation claim rests on ex1/diffusion at
  CI68 and on the pre-COVID window.
- **nboot = 800** (paper-quality); 2000 draws would marginally tighten
  tails only.
