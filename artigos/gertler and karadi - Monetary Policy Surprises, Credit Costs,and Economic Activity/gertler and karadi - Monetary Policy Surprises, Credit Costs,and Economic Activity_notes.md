# Reading Notes — Gertler & Karadi (2015)

## Bibliographic metadata
- **Authors:** Mark Gertler (NYU + NBER) and Peter Karadi (ECB DG-Research + CEPR).
- **Title:** "Monetary Policy Surprises, Credit Costs, and Economic Activity."
- **Journal:** *American Economic Journal: Macroeconomics* (AEJ: Macroeconomics).
- **Year:** 2015.
- **DOI:** 10.1257/mac.20130329 (http://dx.doi.org/10.1257/mac.20130329).
- **JEL codes:** E31, E32, E43, E44, E52, G01.
- **Origin:** Prepared for the NBER conference "Lessons From the Crisis for Monetary Policy," October 18–19, Boston.
- **Volume / issue / page range:** NOT stated in the chunk text (header + reference list carry only journal name + DOI). From standard catalogues the published cite is **Vol. 7, No. 1, pp. 44–76** — verify against the PDF front matter before quoting; not confirmable from these chunks.

## Research question
How does monetary policy transmit to **credit costs** (private borrowing rates), and how much of that response is consistent with the conventional frictionless New-Keynesian transmission mechanism versus attributable to **term premia and credit spreads** (financial-market imperfections)? Secondary question: how important is **forward guidance** to the overall strength of transmission?

## Method / Identification — proxy-SVAR with external (high-frequency) instruments

This is an **external-instruments / proxy-SVAR** paper. It is the canonical Stock-Watson (2012) / Mertens-Ravn (2013) external-IV VAR, using high-frequency (HFI) futures surprises as the instrument. Core mechanics:

**The SVAR object.** Structural form `A Y_t = Σ_j C_j Y_{t-j} + ε_t`; reduced form `Y_t = Σ_j B_j Y_{t-j} + u_t` with `u_t = S ε_t`, `S = A^{-1}`, `Σ = E[u_t u_t'] = S S'`. They only need the **single column `s` of `S`** that maps the policy shock `ε_t^p` into the reduced-form residuals — not the whole `S`. IRFs come from `Y_t = Σ_j B_j Y_{t-j} + s ε_t^p`.

**Two-stage / proxy projection (the identification).** Instrument `Z_t` (the HFI futures surprise) must satisfy relevance `E[Z_t ε_t^{p'}] = Φ ≠ 0` and exogeneity `E[Z_t ε_t^{q'}] = 0` (orthogonal to all non-policy structural shocks). Procedure:
1. OLS-estimate the reduced-form VAR (full 1979:7–2012:6 sample) → residuals `u_t`. Split into policy-indicator residual `u_t^p` and the rest `u_t^q`.
2. **First stage:** regress `u_t^p` on `Z_t` → fitted `û_t^p` (isolates the variation in the policy-indicator residual driven purely by the policy shock).
3. **Second stage (2SLS):** regress each `u_t^q` on `û_t^p` → consistent estimate of the response ratio `s^q / s^p` (eq. 13). Because `Z_t ⟂ ε_t^q`, `û_t^p ⟂ ξ_t`.
4. Recover the scale `s^p` from the reduced-form covariance `Σ` via the closed-form (eqs. 16–18), then back out `s^q`. With `s^p`, `s^q`, `B_j` in hand, compute IRFs.
- Crucially **no zero/timing (Cholesky) restrictions** on contemporaneous responses of output, inflation, or spreads — identification is entirely from the instrument. The paper explicitly contrasts this with a Cholesky scheme (1-yr rate ordered second-to-last, EBP last) which produces output/price/spread puzzles because the ordering wrongly assumes the Fed does not react contemporaneously to the excess bond premium.

**How the instrument is built from HFI futures surprises.**
- Surprise = change in the futures **settlement price** in a **tight 30-minute window** around the FOMC announcement: `(E_t i_{t+j})^u = f_{t+j} − f_{t+j,−1}` (eq. 19). Differencing (à la Kuttner 2001) cleanses the risk premium, assuming it is constant over the 24h around the decision.
- `j = 0` → surprise in current fed funds (Kuttner shock). `j ≥ 1` → **forward-guidance shock** (revision in expected future short-rate path), following GSS.
- Current-month FF surprise is scaled by `T/(T−t)` (Kuttner) to account for the FOMC day's position within the month, since futures settle on a monthly average.
- **Instrument set (GSS event-study menu):** FF1 (current-month fed funds future), FF4 (3-month-ahead fed funds future), and ED2, ED3, ED4 (6-, 9-, 12-month-ahead 3-month Eurodollar futures). Data courtesy of Gürkaynak; **daily surprises available 1991:1–2012:6**.
- **Monthly aggregation:** cumulate FOMC-day surprises into a daily cumulative surprise series, take monthly averages, then first-difference — so an end-of-month surprise gets less weight in the monthly-average policy rate than an early-month one.
- **Baseline instrument = FF4** (3-month-ahead fed funds future surprise). Chosen because it is the strongest first-stage instrument for the 1-year rate: first-stage F ≈ 21.5 (robust/heteroskedasticity-robust F ≈ 17.5), well above the Stock-Wright-Yogo (2002) threshold of 10; explains ≈ 8% of monthly innovation in the 1-year rate.

**Why a longer-maturity policy indicator (1-year rate) rather than the overnight funds rate.** The paper deliberately separates the **policy instrument** (the current fed funds rate) from the **policy indicator** (the VAR variable whose innovation carries the shock). They set the indicator to the **1-year government bond rate**, not the funds rate, because:
- Its monthly innovation embeds not just the current-funds-rate surprise but **revisions in expected future short rates** — i.e. it captures **forward-guidance shocks**. Via the expectations hypothesis (eq. 20–21), the 1-yr residual `i_t^{12} − E_{t-1} i_t^{12}` = average revision in expected short rates over 12 months + term-premium innovation. The conventional funds-rate-only VAR captures only current-rate shocks.
- The 1-year rate captures **more persistent** policy changes; the funds rate mixes in timing changes of rate adjustments (Kuttner) that are transitory.
- **Conceptually preferred indicator is the 2-year rate** (Swanson-Williams 2014; Hanson-Stein 2012 argue Fed forward guidance operates on ~2-yr horizon), but **the futures surprises are weak instruments for the monthly 2-year-rate VAR innovation** (no instrument combo clears F = 10 for the 2-yr; the 2-yr rate / ED4 have too much high-frequency daily noise). Hence the 1-year rate is the **baseline** for the monthly VAR (strong first stage), with the 2-year rate + full GSS set shown only as a robustness check.
- Also robust to zero-lower-bound concern: the 1-yr rate stayed positive until ~2011, so the Fed retained leverage over it.

## Data
- **Frequency / sample:** monthly, **1979:7–2012:6** (Volcker onset chosen as start; pre-Volcker excluded for regime change per Clarida-Galí-Gertler 2000). Lag coefficients + reduced-form residuals estimated on full sample; **instrument-based identification of `s` uses 1991:1–2012:6** (the window where futures surprises exist).
- **Instruments:** GSS FOMC-day futures surprises (FF1, FF4, ED2–ED4), 30-min windows, from Gürkaynak.
- **Daily HFI cross-check (Tables 1–2):** yields from Gürkaynak-Sack-Wright (2007) constant-maturity Treasuries and GSW (2010) TIPS curve; QE dates and 2008:7–2009:6 crisis excluded (188 obs; TIPS 1999–2012).
- **VAR variables.** Simple VAR (4 vars): log industrial production, log CPI, 1-yr govt bond rate (indicator), Gilchrist-Zakrajšek (2012) **excess bond premium (EBP)**. Baseline VAR (6 vars): adds mortgage spread + 3-month commercial-paper spread. Extra interest rates (funds rate, 2/5/10/30-yr, 5×5 forward, TIPS, breakevens) added one at a time to avoid multicollinearity.

## Key findings (IRF signs / magnitudes)
- A one-s.d. contractionary surprise raises the 1-yr rate ~20–25 bp on impact; **industrial production falls significantly** (trough ~18 months); **CPI falls modestly and insignificantly** (small price puzzle only under Cholesky, not under external IV).
- **Credit spreads rise significantly:** EBP +~8–10 bp on impact (persists ~half a year); mortgage spread jumps to ~7 bp above trend after two months; commercial-paper spread +~5 bp for 4–5 months. The EBP rise (default risk stripped out) signals a genuine **credit-channel** effect.
- **"Modest" short-rate moves → "large" credit-cost moves.** A ~20 bp rise in the 1-yr govt rate produces ~15 bp on corporate-bond rates and ~7 bp on mortgage rates; **virtually all of the increase is the "excess premium" = term premium + credit spread**, essentially none from the expected short-rate path (short rates revert quickly as the economy weakens). For 2/5/10-yr govt rates the rise is almost entirely **term premium**; even for the 1-yr rate ~80% is term premium.
- **Real rates move ~one-for-one with nominal rates** (breakeven inflation barely moves) — confirms price stickiness (consistent with TIPS HFI evidence of Hanson-Stein, Nakamura-Steinsson).
- **Forward guidance matters.** Replacing the 1-yr/FF4 indicator-instrument with funds-rate/FF1 (less forward-guidance content), normalized to the same funds-rate move, gives **>50% weaker output contraction** and weaker spread/long-rate responses → the transmission strength rises with the forward-guidance content of the shock (Figure 7; F = 25.16, robust F = 14.04).
- **Robustness:** 2-yr rate + full GSS instruments (Fig 8) gives similar-to-slightly-stronger responses; pre-crisis sample 1979:7–2008:6 (Fig 9) similar. **Exogeneity vs Fed private information (Romer-Romer critique):** regressing surprises on Greenbook-minus-BlueChip private-information measures explains only ~15% of FF4 variation (Table 4); a "purified" instrument (residualized on private info) gives even stronger contractionary responses (Fig 10) — but shorter Greenbook sample reintroduces weak-instrument caution.

## Contributions
1. Brings the **external-instruments (proxy-SVAR) identification** together with HFI futures surprises to trace **dynamic joint responses of real and financial variables** to monetary shocks — combining the internal-validity of HFI event studies with the dynamics of a VAR, without Cholesky timing restrictions.
2. Introduces the **policy-indicator ≠ policy-instrument** distinction, using a **longer-maturity (1-yr) rate as indicator** so the shock embeds **forward-guidance** innovations, not just current-funds-rate surprises.
3. Documents that monetary policy's effect on credit costs is **larger than the frictionless model predicts**, driven by **term premia and credit spreads** — motivating models with limited participation / limits to arbitrage (Gertler-Karadi 2013), and a role for QE.

## Relevance to this project (Brazil replication)
This is the methodological template for the project's **GK-style instrument** (`z_bruto`, `z_jk`, and purified variants): Copom-day DI-futures surprises → monthly instrument → proxy-SVAR `ident_ext_instr` projection `H = (Z' rsh)/(Z'Z)`. The GK lessons that map directly here: (i) use a **longer-vertex DI rate** (project uses `yield_6m` / `TARGET_BD = 126` ≈ 6m DI) as the normalization/policy-indicator, not the overnight Selic, to embed expectations content and get a strong first stage; (ii) **first-stage F ≥ 10** (Stock-Yogo) as the weak-instrument gate; (iii) **wild bootstrap** for inference (GK cite Mertens-Ravn wild bootstrap under heteroskedasticity — the project uses Gonçalves-Kilian wild bootstrap). The choice of `yield_6m` over `juros_selic` in the project mirrors GK's 1-yr-rate-over-funds-rate choice exactly.
