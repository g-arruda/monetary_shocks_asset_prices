# CLAUDE.md

**What belongs here:** invariants, entry points and the rules that govern what may be *claimed*.
**What does not:** research findings — numbers copied here go stale, numbers in the record do not.
Area-specific detail lives in `.claude/rules/` and loads when you touch that area.

## Project

Independent paper replicating Alessi & Kerssenfischer (2019) for Brazil: large-scale non-stationary
Dynamic Factor Model, monetary shocks identified by an external instrument (Copom-day DI futures
surprises), IRFs of Brazilian asset prices. Inference: Anderson–Rubin sets by test inversion
(Montiel Olea, Stock & Watson 2021) since 2026-09-08, replacing the wild bootstrap (Gonçalves &
Kilian 2004) with Kilian (1998) bias correction, which left the code on 2026-09-18. Canonical
paper: `paper/paper_anpec.tex`.

The record, in `registro/`: `metodo.md` (the live design — instrument construction and the
identification chain), `pendencias.md` (what is open), `historico_decisoes.md` (what died and why —
**read before proposing a methodological direction**); plus `notas/`, dated and carrying vintage
banners, `pareceres/`, what outside reviewers sent in, and `email/`, the running email exchange
with the advisor.

## Production spec — the invariant that costs most to get wrong

**`z_bs_purif` × `yield_6m` × (r=5, q=5, p=4), +50bp**, with AR sets at **80/90%**, on `main`
since **2026-09-26**, when `feature/bs-copom-surpresas-macro` was fast-forwarded into it. Until then
production was `z_jk_bs_purif` at 68/90%; the JK sign filter left production, for now, by author
decision, and the paper reports no JK layer anywhere. Code, outputs, validators, `paper/fig_*.pdf`
and the `.tex` all follow it. Notes `2026-09-26_bs_lista_tabela3_externas`,
`2026-09-26_producao_bs_purif_bandas_80_90`, `2026-09-26_migracao_paper_bs_purif`. Since **2026-09-21 there is no spec
object**: `R/modeling/production_spec.R` was deleted and every path, dimension, window and switch
is written as a literal in the script that uses it, in a constants block at its top (author
decision — a centralized spec made every number a second lookup). The one value that is not a
literal is θ̂, which is an estimate: it is read from
`output/factors/covid_volatility_theta.csv` by `read_covid_volatility()`. The **canonical
declaration** of the whole specification — and the check that data, panel, instrument, strength and
impacts still match it — is `script/validation/validate_production_spec.R`; when a literal and that
file disagree, that file is right. The production panel is the 115-series
`drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, covering
2012-03 through 2025-12 (166 months, 162 factor innovations after `p=4`);
the 106-series base exists only for historical factor-grid reproduction.
`r=5` is selected by the BLL Bai--Ng surface (`r=1,...,20`: IC1=IC2=5,
IC3=20); `q=r=5` is the operational decision. `p=4` is inherited from the
prior vintage rather than reselected — the AIC check on the extended common
sample (`T=154`, constant and trend in the selection only) still picks `p=4`
(8.231267), and BIC still picks `p=2`. The estimated factor VAR remains
intercept-only. **Since 2026-09-17 the factor VAR carries the Lenza-Primiceri
(2022) COVID volatility scale `s_t`** — θ̂ = (6.611488, 12.468194, 1.760038,
0.943951), `t*` = 2020-03, `innovations = "standardized"`. **Since 2026-09-25**
`estimate_covid_theta()` differentiates with `ndeps = 1e-6` (the default 1e-3
stopped the optimizer short of the maximum, tripping the first-order guard at
`p = 5`); θ̂ moved in the 4th--5th digit (it was 6.611429, 12.468338, 1.760352,
0.943926; loglik +5e-7), every production IRF by at most 8e-5 of its series'
scale, and no number printed in the paper changed. Since 2026-09-21 θ̂
is read from `output/factors/covid_volatility_theta.csv` through
`read_covid_volatility()` (`R/modeling/factor_estimation.R`), never typed as a
literal: `script/covid_volatility_theta.R` is its sole producer and the only
script that must not read it. `readr` round-trips the four doubles
bit-identically, which is why the treated point below did not move. The **full window** is therefore
weighted least squares; the **pre-COVID window is not, and needs not be** —
every month of it has `s_t = 1`, so the weighted fit *is* the unweighted one
(proved bit-identical by N1/N2 of `script/validation/validate_covid_volatility.R`), and
`estimate_dfm()` rejects a `covid_start` outside its residual months. Contrasts
between the two windows stay contrasts of window, not of estimator.

Under `z_jk_bs_purif` (production until 2026-09-26) the cell had **ξ_mp = 6.848035 full / 8.643436
pre-COVID**, F_rob,mp = 11.765564 / 13.809985; both companion matrices are stable
(0.983676 / 0.993359). The treatment **raised** ξ_mp (it was 6.057014 full,
F_rob 9.625428, root 0.970090 untreated) and left the pre-COVID numbers
untouched, as it must. **ξ_mp is the strength ruler of record** — the AR set is
bounded iff ξ_mp > 3.84, conventional bands approximately valid at ξ_mp ≥ 10,
which 6.85 still is not. Since 2026-09-08 that boundedness is no longer a
prediction: `ar_dfm_bands()` builds the sets, its `xi_den` reproduces 6.848035
through the MOSW covariance, and every set in `output/irf/irf_coherence_h.csv`
comes back `interval` at 68 and 90% — 2841 of 2842 rows per level, the one
exception being the `singleton` the normalization pins at h=0. Legacy
first-stage F rulers still print but stopped deciding on 2026-07-26.
**The production cell (`z_bs_purif`, since 2026-09-26)**: ξ_mp = **7.018990 full / 6.836682
pre-COVID**, F_rob,mp = 8.616330 / 8.306648 (both below 10 in both windows), same roots, and every
set is `interval` at 80 and 90% (2841 + the h=0 `singleton` per level). With the JK filter, in the
current BS construction, ξ_mp would be 5.01 / 4.73: the filter lowers it.

**Under the scale, `r ≥ 7` is explosive on the full window** (max root 1.001362
at r=7, 1.001318 at r=8, every q), so `script/mosw_strength_grid.R` sweeps
r=4:6 there and keeps r=4:8 pre-COVID, where everything is stable. Production
r=5 is far from that edge. The Kilian correction and the wild bootstrap, which
assume OLS with a constant Σ and never ran under the scale, were **removed from
the code on 2026-09-18**. This is reweighting of the estimation, **not**
heteroskedasticity identification.

**The whole paper is on the production vintage since 2026-09-24.** On **2026-09-17** §3 was reorganized into four subsections —
`Modelo e estimação`, `Base de dados`, `Identificação e construção do
instrumento`, `Relevância do instrumento e inferência` — and **fully migrated**
to the production vintage: 2012-03--2025-12, 166 observations, 162 innovations,
`(r,q,p)=(5,5,4)`, ξ_mp 6.85 full and 8.64 pre-COVID, `tab:first_stage` rebuilt
from `mosw_strength_grid.md` and `instrument_diagnostics_report.md` (since 2026-09-18 its
numbers are carried by `mosw_strength_grid.csv` and `instrument_diagnostics.csv`), 102 Copom
meetings, 67 monetary and 35 information, BS `R²` 0.022. Note:
`2026-09-17_reorganizacao_secao_3`. Its §3.1 now carries the whole estimation
chain in order, including the concentrated likelihood that estimates θ and the
WLS that follows from it. **Since 2026-09-26** §3.3 has two layers, with no JK filter and no 67/35
split, the BS regression runs on the 102 meetings (R² 0.124), and §3.4 carries ξ_mp 7.02 / 6.84
(`2026-09-26_migracao_paper_bs_purif`).

**§5 is current since 2026-09-21.**
A second pass the same day reshaped `tab:het_frequency` (pre-COVID row out) and rewrote §5.2
against `como_escrever`, cutting the paragraph that re-explained the Anderson--Rubin sets
already set out in §3.4. **On 2026-09-22 §5.1 was rebuilt on `goncalves2025`'s own three
series and the summed-window row was deleted**, so the section now reports the daily and
monthly rows side by side and **attributes the contrast to neither frequency nor window
type** — see the prohibition below, which lists what may not be written. The abstract, in
Portuguese and in English, agrees with it: it locates the divergence in the identification
condition, not in the frequency of the data.
**On 2026-09-24 §5.1 was deleted** by author decision, following the advisor's suggestion
(`email_meu_31-08_20h12.md`, pergunta 4), and the het diagnostic **moved to §3.3**
(`sec:identificacao`) as the reason the paper does not use that identification: one paragraph
plus one footnote, right after the proxy-identification paragraph. §5 Robustez kept its title and
lost its only subsection (`sec:weak_iv` now labels §5 itself); the introduction points at
`sec:identificacao`. The appendix is split into **Anexo A** (`tab:lista_variaveis`), **Anexo B** (`anexo-B`), since 2026-09-24 **Anexo C** (`anexo-C`, the `q` sensitivity figure, below, joined on 2026-09-25 by the `p` one and on 2026-09-26 by the instrument-layer one) and, since 2026-09-25, **Anexo D** (`anexo-D`, the instrument construction, below). Anexo B carries **two tables**: `tab:het_variance` (Rigobon--Sack
variance ratio per series, from `output/het/het_variance_ratios.csv`) and `tab:het_frequency` (the
`Qr(λ₁=λ₂)` summary with the DI variance ratio `a`, SEs, corrected and uncorrected statistic; the
`det` column left it the same day, and so did `tab:het_sequencia`, the full sequential table, by
author decision). The summary prints the factor row's uncorrected p 0.035, and its note prints the
inconvenient factor-row rejections of `λ₁=…=λ₄` (p 0.021) and `λ₁=…=λ₅` (p 0.013) and why that row
has 161 observations, not 162 (the formal lag the test imposes).
Holm across the three daily vertices keeps the 3-month rejection (p 0.010). The non-decomposition
sentence stays: the advisor's reading ("aggregation dilutes the variance") is exactly what the
2026-09-22 prohibition forbids, and was not written. `rigobonsack2004` entered the bib (23 of
the 25 keys; `amengual2007consistent` made it 24 on 2026-09-24).
**Since 2026-09-26 §3.3 was rewritten** by author request: the het paragraph comes **first** and is
**narrative, with no statistic and no footnote** — it says the condition was tested on three of
`goncalves2025`'s series, holds daily with the 3-month DI "embora o resultado dependa do vértice"
(the vertex sensitivity travels as that clause), fails in the monthly panel and in the factor
innovations, and points to Anexo B. The kurtosis sensitivity travels in `tab:het_frequency`'s
corrected/uncorrected columns, and the non-decomposition sentence moved into that table's note.
The same round removed `\cite{jarocinski2020}` from §3.3 (23 keys in the body), dropped the X-13
column from `tab:lista_variaveis`, set captions and `\autoref` to "Figura/Tabela", and replaced
every parenthetical "(\autoref{…})" in the body with a reference inside the sentence.
That round migrated `sec:weak_iv` to the production vintage, re-estimated
`sec:het_frequency` at `(5,5,4)` under the LP scale, repainted
`fig:weak_iv_main` with Anderson--Rubin sets on both sides, and **deleted §5.3**
(the FOMC subsection) by author decision. Note:
`2026-09-21_migracao_secao_5`.

**§4 is current since 2026-09-24**, and with it `output/irf/irf_section.md`. The round
re-estimated nothing: every number comes from `irf_coherence_cell.rds`, and the 140 numbers in
the prose were checked against it. The eight figures were repainted with Anderson--Rubin sets
and captions to match, and `script/fig_section5.R` lost its `--repaint-paper-figures` guard. §4
and §5.2 now agree (BRL/USD +3,23%, CDS +30,5 bp at impact under `z_jk_bs_purif`; +3,53% and +34,0 bp since the 2026-09-26 migration, `2026-09-26_migracao_paper_bs_purif`; the FX number
is R$ 0,141/US$ since 2026-09-27, when the division by the sample mean left figures and prose, `2026-09-27_unidades_nativas`).
**Level series (tcode 1) are reported in their own units** — FX in R$ per unit of foreign currency,
activity indices in index points — never as a percentage of the sample mean. The prose reports **points**, and
cites sets only where the previous text cited bands, under the two-tier rule. The reading changed
shape, not only magnitude: every vertex of the curve peaks at h3, IBC-Br stays negative for 36
months, and IPCA is never positive. Two inconvenient numbers are in the text: equity returns are
significant at 90% only in their **positive** phase, never at impact, and the primary NFSP turns
positive and significant from h18 to h32. Outside §4 only numbers and dates changed, in the
abstract, introduction and conclusion. The argument sentences that the new reading weakens are
an open author decision in Tema A. Note: `2026-09-24_migracao_secao_4`. See `notas/_indice.md`
before citing paper numbers as current.

**`q = r` is defended in §3.1 since 2026-09-24**, in two sentences anchored in Stock-Watson (2016,
§7.2) and AK (footnote 4), with Amengual-Watson now cited. **Anexo C** carries
`fig:q_sensibilidade`, AK's Figure A3 exercise on the production cell: `q = 5` with its AR sets,
`q = 4, 3, 2` as points, eight series to h36. `script/q_sensitivity.R --window=cheia` writes it
and checks the `q = 5` line against `irf_coherence_h.csv`. By author decision **the text cites
no number** from the exercise, and the defense is SW and AK, **not insensitivity**: at `q ≤ 3`
the FX, CDS and Ibovespa impacts grow (Ibovespa 8.6× at `q = 3`). The untreated model stays out
of the paper. Note: `2026-09-24_q_sensibilidade_anexo`.

**Since 2026-09-25 the appendix carries two more exhibits, and the body cites neither** (author
decision: "apenas coloque os anexos"). Anexo C adds `fig:p_sensibilidade`, the same design over
`p = 2..6` at `r = q = 5`, θ re-estimated at each `p` by `covid_volatility_theta.R` (the caption says
only that), written by `script/p_sensitivity.R`: every companion stable (0.976--0.990), no `p ≠ 4`
point outside the `p = 4` 90% set in the eight series to h36. **Anexo D** (`anexo-D`, "Construção do
instrumento") carries `tab:bs_ortogonalizacao`, the analogue of **Bauer-Swanson (2023) Table 3**
(the pre-event regressions of the DI surprise and of the Ibovespa return, HC1, 638 Thursdays; joint
Wald p 0.131 and 0.326), written by `script/instrument.R` into
`output/instrument/bs_orthogonalization.csv`, and `fig:instrumento_camadas`, the production
responses under the three layers of `tab:first_stage`, written by `script/instrument_layers_irf.R`:
no point of `z_bruto` or `z_bs_purif` leaves the production 90% set (0 of 4255 each), and ⚠ the
Ibovespa impact flips sign with the JK filter (+0.19/+0.27% → −1.50%), mechanically. The three
annex scripts share `R/reporting/sensitivity.R`. Notes: `2026-09-25_p_sensibilidade_anexo`,
`2026-09-25_anexo_d_instrumento`. **Since 2026-09-26** Anexo D has no JK layer:
`tab:bs_ortogonalizacao` is the DI column only, over the 102 meetings (constant only, nine
predictors, R² 0.124, joint Wald p 0.122, macro block p 0.059), and `fig:instrumento_camadas`
draws production (`z_bs_purif`) and `z_bruto` only (`2026-09-26_migracao_paper_bs_purif`).
**Later on 2026-09-26** `fig:instrumento_camadas` moved to **Anexo C**, renamed "Sensibilidade das
respostas", so Anexo D carries `tab:bs_ortogonalizacao` alone, now laid out like BS Table 3 (one
column, SE in parentheses under each coefficient, macro block before financial, each predictor
beside its BS analogue, R², both Wald p and N at the foot, a four-sentence note). The
definitions and timing of the news moved from the note into §3.3, which now ends pointing to the
table — the first body pointer to Anexo D.

The only active small-VAR benchmark is **`ibc5_fx_cds_level_trend_p4`**. It
uses `ibc_br`, `price_ipca`, `yield_6m`, `cambio_usd`, and `cds_5y` in levels,
with a constant and linear trend in every equation. **Since 2026-09-21 it runs
the DFM's own window and lag order** — 2012-03--2025-12 and `p=4` — by author
decision, so that `T_eff = 162` equals the DFM's count of factor innovations
and the contrast is between models rather than between samples or lag orders.
`p=4` is therefore a **comparability choice and not the AIC's**: on the common
`T=154` sample the AIC still picks `p=2` (−11.106 against −11.006 at `p=4`) and
the BIC `p=1`, both reported, and `validate_mosw_ar.R` pins that the departure
is deliberate. The migrated cell is stronger: ξ_var 6.797335 → **7.258325**,
max root 0.9765222 (stable), `hac_dim` 140 < 162 so the gate passes, AR sets
bounded at 90%. Published responses are
horizon-specific `C_h B_1` estimates with VAR-only AR/MOSW sets at 80% and 90%
under NW(0) since 2026-09-26 (68/90% before), ξ_var 7.189765 with `z_bs_purif`. Do not add
sensitivity cells, sum responses across horizons, or
restore bootstrap inference for this benchmark.

## Pipeline

Three ordered stages plus estimation, one `Rscript` process each, orchestrated by `script/run_all.R`:

1. **`script/download.R`** → `data/raw/raw_data.csv` with 113 monthly series plus every reproducible
   daily raw input (BCB, Focus, Yahoo, B3, IPEA, SIDRA). Auxiliary functions in
   `R/data_download/` never execute or write on source. Since 2026-09-26,
   **`script/download_macro_news.R`** (stage `macro_news`) adds
   the Focus, SGS and first-release GDP inputs of the BS macro news block, in a network stage of
   its own so that it never refreshes the panel.
2. **`script/clean.R`** → `data/processed/data_log_deseasonalized.csv` (log + X-13).
3. **`script/instrument.R`** → the 3 monthly variants of `tab:first_stage` (`z_bruto`, `z_bs_purif`,
   `z_jk_bs_purif`; production is `z_bs_purif` since 2026-09-26, `z_jk_bs_purif` before) via
   `R/instrument/build_variants.R`.
4. **Estimation** — `script/model_alessi.R` (main DFM; the pipeline itself is `main_sdfm()` in
   `R/modeling/dfm_pipeline.R`) and `script/model_var.R` (small-VAR
   **benchmark**; it does not use the factors).

`script/irf_coherence_check.R` runs the production spec once and writes
`output/irf/irf_coherence_h.csv` — point + 80/90 Anderson–Rubin sets + `set_type` + flags, **the
source of §5** — plus `irf_coherence_cell.rds`, the cached estimation object follow-up analyses
reuse instead of re-estimating. The inference swap was documented by `arquivo/script/ar_bands.R`,
archived on 2026-09-18 with the bootstrap it compared against; its outputs stay in
`output/irf/ar_bands*`, including the record of the cells the `hac_dim < T` gate blocks. Catalog of
the scripts in `script/README.md`; repo map in `README.md`.

## Completed rounds

Cite the note, never this table. Notes are under `notas/`. Rounds whose script sits in
`arquivo/script/` were archived on 2026-09-17 or 2026-09-18: their outputs stay in `output/`, but
the script is not maintained and most no longer run (`arquivo/README.md`).

| round | script | note | verdict |
|---|---|---|---|
| Sovereign confound | `arquivo/script/jk_sovereign_confound.R` | `2026-08-24_migracao_dfm_p4` | daily selection not confirmed; re-derived mask lowers ξ_mp to 3.438 |
| FOMC coincidence | `arquivo/script/fomc_coincidence.R` | `2026-08-24_migracao_dfm_p4` | regressions null, but re-derived mask lowers ξ_mp to 3.671: weak contamination signal |
| ξ_mp robustness | `arquivo/script/xi_mp_robustness.R` | `2026-08-24_migracao_dfm_p4` | all 149 full-sample LOO cells remain below 10; none falls below 3.84 |
| Construction sweep | `arquivo/script/instrument_construction_sweep.R` | idem | vertex not identified; all give same IRF |
| Preços cross-instrumento | `arquivo/script/price_cross_instrument.R` | `2026-08-24_migracao_dfm_p4` | corcova comum aos 3 degraus; efeitos das camadas não são uniformes entre séries |
| Varredura de `p` | `arquivo/script/p_selection.R` | `2026-08-24_migracao_dfm_p4` | production `p=4`; historical `p=6` retained as an alternative cell |
| Factor stationarity | `arquivo/script/factor_stationarity.R` | `2026-08-24_migracao_dfm_p4` | 3/5 I(1), no I(2), full-sample root 0.968126 (real) |
| Levels VAR and weak-IV | `model_var.R` | `2026-08-22_var_niveis_aic_tendencia` | constant and trend, AIC p=2, horizon-specific responses, AR 68%/90% |
| Equity representation | `arquivo/script/asset_representation.R` | `2026-07-31_acoes_representacao` | null is mechanical; log-level set aside |
| DFM-IV audit (Tasks 0-7) | `diagnostics/` | `diagnostics/diagnostico_dfm.md` | H2 confirmed; state dependence split |
| Het at monthly frequency | (reestimation, no dedicated script) | `2026-09-01_heterocedasticidade_frequencia` | rank condition not satisfied monthly; route stays out of production |
| Fiscal Focus expectations (isolated) | `arquivo/script/fiscal_expectations.R` | `2026-09-01_teste_expectativas_fiscais` | 111→114-series experimental panel; no evidence of expected fiscal deterioration |
| DLSP accounting decomposition | `arquivo/script/fiscal_dlsp_decomposition.R` | `2026-09-01_decomposicao_contabil_dlsp` | blocked: the 7-flow identity omits the external "outros ajustes" line |
| 115-series exchange-adjustment + fiscal expectations (joint) | `arquivo/script/fiscal_exchange_expectations.R` | `2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais` | experimental panel superseded for DFM numbers; not promoted to production |
| Anderson–Rubin as the DFM's operational inference | `arquivo/script/ar_bands.R` | `2026-09-08_bandas_anderson_rubin_producao` | swap done; all 5635 production cells bounded, weak-IV premium 1.38× at 90%; `(5,2)` unbounded (untreated model); `(8,8)` and pre-COVID blocked by `hac_dim < T` |
| Lenza-Primiceri scale into production | `validation/validate_production_spec.R`, `irf_coherence_check.R`, `mosw_strength_grid.R` | `2026-09-17_volatilidade_covid_producao` | switched on: ξ_mp 6.057014 → 6.847997, F_rob 9.625428 → 11.765250, root 0.970090 → 0.983677, every §5 set still `interval` at 68/90; pre-COVID unmoved (s_t ≡ 1); `r ≥ 7` explosive on the full window |
| Alternative `r` estimators (AH ER/GR, ABC) | `arquivo/script/factor_selection_alt.R` | `2026-09-10_selecao_fatores_ah_abc` | mixed: ER = GR = 2, ABC-IC*₁ = 9 on a 2-point stability interval (5 in 39/100 column permutations); `factorselect` diverges from both papers in GR and ABC and is not used |
| Correlation pruning + `(r,q)` on the pruned panel | `panel_pruning.R`, `factor_selection_pruned.R` | `2026-09-10_poda_correlacao_painel` | complete linkage at \|ρ\| ≥ 0.90 drops 9/115 series; Bai-Ng IC2 5 → 3, AH 2 → 1, ABC 9 → 11 (unstable), AW `q = 2` at every `r`; divergence grows (D 10 → 12), underestimation hypothesis contradicted |
| `q < r` truncation: subspace sufficiency + AK invariance by window | `arquivo/script/q_truncation.R` | `2026-09-10_truncamento_q` | harmless before COVID, distorting after: pre-COVID `p=2` 115/115 series immaterial at `q=3,4`, full sample 0/115; the proxy's covariance sits in the discarded directions (T1 p 0.051/0.039/0.015 full, ≥ 0.22 pre-COVID); rules written after an exploratory pass |
| COVID volatility (Lenza-Primiceri) in the factor VAR: θ̂ by ML, AR under WLS, steps 3/4 and 4/4 | `covid_volatility_theta.R`, `arquivo/script/q_truncation.R` (cell `cheia_p4_lp`), `q_sensitivity.R` | `2026-09-14_inferencia_volatilidade_covid_q` | **superseded on 2026-09-17: the treatment became production.** θ̂ = (6.61, 12.47, 1.76, 0.944), with a second maximum at ρ = 0 2.6 log-points below; at `q=3` 23/115 series immaterial and 75 material, against 115/115 immaterial pre-COVID `p=2`; the sets condition on θ̂ |
| §5 migrated, §5.3 deleted | `het_conditions.R`, `fig_weak_iv.R` | `2026-09-21_migracao_secao_5` | §5.2 on the production vintage, `fig:weak_iv_main` repainted in AR on both sides, §5.3 (FOMC) cut by author decision; §4 contradicted §5 until 2026-09-24 |
| Battery cut to the `svars` test; §5.1 and `tab:het_frequency` rebuilt on `goncalves2025`'s own series | `het_conditions.R`, `het_rigobon/` | `2026-09-22_condicao_het_svars` | Rigobon's single rank condition, tested by the sequential `Qr` of Lütkepohl et al. (2021) via `svars`. Both frequencies now carry **their** three series — DI, BRL/USD, 5y CDS; no Ibovespa, no 2-year DI. Daily rejects at the 3-month vertex (p 0.003, λ₁ 7.55 vs 1.36); **the same three series monthly reject at no vertex** (p 0.917--0.988, λ₁ ≈ λ₂, det 40.8 → −0.03). The two differences between the rows — frequency and announcement window against calendar variation — are **not decomposed**: the summed-window object that had separated them was deleted the same day by author decision, and the only monthly aggregation is the panel's own. Factor innovations 0.076. ⚠ the daily result depends on the vertex (0.003/0.084/0.147) and on the test's kurtosis correction (÷4.9). Five home-grown statistics retired; `svars` installed |
| Rigobon het: replicação de GRG e IRFs (quarentena) | `het_rigobon/` | `2026-09-22_condicao_het_svars` | a réplica diária **bate** com GRG (razões 3,45/0,98/0,89 contra 3,40/0,92/0,85; ponto deles no IC 95% nas 6 células de câmbio e CDS); o CDS de GRG **fecha**, não é nulo, e a unidade é inferida — §2 corrigida. Na célula diária identificada um aperto de 50 p.b. **fecha** o CDS 4,2 p.b. e **aprecia** o real 1,53%, o sinal deles nas duas séries; o VAR mensal não identifica em nenhum vértice e as inovações fatoriais dão +9,6 p.b. e +1,52% contra +30,5 e +3,23% do proxy, sem rejeitar a 5% |
| §4 migrated, eight figures repainted | `fig_section5.R` | `2026-09-24_migracao_secao_4` | nothing re-estimated; §4 and §5.2 agree; IBC-Br negative for 36 months and IPCA never positive, so the old hump and recovery prose was false; the positive equity phase and the primary NFSP at h18–h32 are significant at 90% and are in the text |
| `q = r` defended in §3.1, `q` sensitivity in Anexo C | `q_sensitivity.R` | `2026-09-24_q_sensibilidade_anexo` | two sentences on SW (2016) and AK, Amengual-Watson cited (24/25 keys); `fig:q_sensibilidade` with 8 series to h36, `q = 5` checked against `irf_coherence_h.csv`; no number in the text; at h ≤ 36, 16/5/4 of 20 series stay inside the 90% set at `q` = 4/3/2 |
| Global optimum of θ̂ | `covid_volatility_theta.R` | `2026-09-24_otimo_global_theta` | confirmed: 750 starts over the whole box, none above θ̂, θ̂ byte-identical; three local maxima — θ̂ (137 starts), ρ = 0 (−2.62) and a new ridge on the floor s̄2 = 1 where ρ is unidentified (−4.79); no start with ρ0 ≤ 0.4 reaches θ̂, so the one-start estimator relied on LP's ρ0 = 0.8; the multi-start is now a guard of the producer |
| BS Table 3 analogue and IRFs by instrument layer, Anexo D | `instrument.R`, `instrument_layers_irf.R` | `2026-09-25_anexo_d_instrumento` | Table 3 of Bauer-Swanson confirmed as the model; pre-event predictability not jointly significant (p 0.131 DI, 0.326 Ibovespa, R² 0.022/0.015); the three layers draw the same shape, 0/4255 alternative points outside the production 90% set; the JK filter widens FX/CDS/long-rate impacts 12--36% and flips the Ibovespa impact sign, mechanically |
| BS orthogonalization on the Copom events only, Table 3 counterparts plus S&P 500 and VIX (**author's chosen construction, promoted to `main` on 2026-09-26**) | `instrument.R` | `2026-09-26_bs_lista_tabela3_externas` | the 20-day Focus revisions leave the regression (they are BS Table 2, not Table 3), and so does the BRL trend; kept: 65-day Ibovespa, DI slope and Brent trends, the four macro news, plus 65-day S&P 500 and VIX. DI R² 0.124, joint Wald p 0.122; production ξ_mp 5.01 full / 4.73 pre-COVID, every AR set `interval`, 0/296 points of the eight §4 series outside main's 90% set; IPCA loses its 90% significance, the Ibovespa impact becomes significant (−8.17%), the primary balance loses h18–h32. By author decision the Selic-revision variant is not reported in the paper. ⚠ The external placebos turn significant at 90% (US EPU h1–h6, MSCI EM h2–h8, VIX h0), which they were not in main; cause not investigated. Promotion open in Theme D, paper migration in Theme A |
| JK filter out of production (`z_bs_purif`) and AR sets at 80/90% (**promoted to `main` on 2026-09-26; `.tex` the same day, next row**) | `instrument.R`, `irf_coherence_check.R`, `model_var.R`, every figure script, both validators with pins | `2026-09-26_producao_bs_purif_bandas_80_90` | in the branch's construction the JK filter lowers ξ_mp (7.02 → 5.01 full, 6.84 → 4.73 pre-COVID), so production became the orthogonalized surprise: ξ_mp 7.018990 / 6.836682, F_rob 8.62 / 8.31; the new point equals the old `z_bs_purif` layer to 0, nothing else moved; every set `interval` at 80 and 90%; BRL/USD +3.53%, CDS +34.0 bp at impact; same shapes, larger magnitudes; the VAR follows at 80/90%, ξ_var 7.19. ⚠ US EPU placebo violates at 90% in h1–h3. |
| Paper migrated to the branch's production, JK filter out of the paper entirely (**promoted to `main` on 2026-09-26**) | `paper_anpec.tex`, `instrument_layers_irf.R` | `2026-09-26_migracao_paper_bs_purif` | nothing re-estimated; §3.3 two layers (BS regression on the 102 meetings, R² 0.124), §3.4 ξ_mp 7.02 / 6.84 and F_rob 8.62 / 8.31, both below 10, `tab:first_stage` two rows, `tab:bs_ortogonalizacao` DI column only, `fig:instrumento_camadas` production and `z_bruto` only, every caption at 80/90%; 143 §4 and 20 §5 numbers checked by script against the cache; seven passages rewritten (FX peak at h1, exchange adjustment 80% set contains zero at impact, IMAT negative at impact so all seven indices fall, FX 90% set excludes zero again at h32–h36 in the conclusion); outside §4 only numbers and false sentences |
| BS orthogonalization on the Copom events only, with the macro news block (**superseded on 2026-09-26 as to the predictor list**) | `download_macro_news.R`, `instrument.R` | `2026-09-25_bs_copom_surpresas_macro` | estimated as BS Table 3 does (102 meetings, constant only, IPCA and first-release GDP surprises, core acceleration, expected IPCA; labor market and BBK left out): the Copom surprise is predictable (Wald p 0.009, R² 0.273, driven by the Focus Selic revision), and removing that component removes the strength — production ξ_mp 6.85 → 1.78 full, 8.64 → 3.22 pre-COVID, 90% AR sets unbounded; the macro block is not jointly significant (p 0.159); paper, validators and smoke test not migrated; promotion open in `pendencias.md` Theme D |
| `p` sensitivity in Anexo C; θ̂ re-estimated at a finer gradient step | `covid_volatility_theta.R`, `p_sensitivity.R` | `2026-09-25_p_sensibilidade_anexo` | the FOC guard stopped θ̂ at `p = 5` (optim's default `ndeps` 1e-3 stops short); author chose `ndeps = 1e-6` everywhere: production θ̂ moved in the 4th--5th digit, ξ_mp 6.847997 → 6.848035, IRFs ≤ 8e-5 of scale, no paper number, significance flag or set type changed; `p = 2..6` all stable and inside the `p = 4` 90% set |
| Level series in their own units; log panel refused (branch `feature/unidades-nativas`) | `fig_section5.R`, `fig_weak_iv.R`, `R/reporting/sensitivity.R`, the three annex scripts, `paper_anpec.tex` | `2026-09-27_unidades_nativas` | nothing re-estimated, annex CSVs byte-identical; FX in R$ per unit of currency (BRL/USD R$ 0,141/US$ at impact), activity indices in index points; BRL/CNY/INR/ARS out of §4.2; 31 prose numbers checked against the cache; the h36 cross-series ordering in §4.5 changed; a DFM IBC-Br mislabel in `fig:weak_iv_main` fixed. Both log panels (broad AK rule, restricted rule) were estimated and refused the same day, `historico_decisoes.md` §20. ⚠ BRL/ARS impact (R$ 0,0063/peso) exceeds its own end-of-sample level |

## ⚠ Prohibitions

These govern what may be **said**, so they apply even when no file is open.

### What the paper may not claim

- **The lower band is never "significant".** Two-tier rule: 90% band excluding zero →
  *significativo*; the lower level only → **direction and magnitude**, labelled as such. The lower
  level is **80% since 2026-09-26** (AK's levels, stricter; 68% before).
- **The 80%/90% (68/90% until 2026-09-26) Anderson–Rubin sets are the sole operational inference for the DFM** since
  **2026-09-08** (author decision; it reverses the 2026-08-12 withdrawal, `historico_decisoes.md`
  §7). `compute_irf_dfm(inference=)` is the single switch (`"ar"`, or `"none"` for the point
  alone) and has no default; every production call site writes `"ar"`. The wild bootstrap and the Kilian
  correction left the code on 2026-09-18. Two things are true of the sets: the plug-in
  covariance conditions on the estimated `Λ`, `K`, `M`, `sy` and `θ̂`; and `mosw_rform_cov` needs
  `hac_dim < T`, which **blocks** `(r,q)=(8,8)` at `p=4` (336 ≥ 162) and the **whole pre-COVID
  window** at `p=4` (135 ≥ 90). No pseudo-inverse, no substitute bootstrap, no fallback — a
  blocked cell is reported blocked, in code, in `output/` and in the record. **The paper's prose
  carries neither caveat**, by author decision of 2026-09-16 and again of 2026-09-17: a reader who
  knows the treatment sits in the factor VAR infers the conditioning, and `(8,8)` is an abandoned
  cell. Nothing in the paper may therefore *contradict* them — no pre-COVID band may be published,
  and no `(8,8)` number may appear as inference. **`hac_dim < T` is this project's safeguard,
  not the authors' condition**: `CovAhat_Sigmahat_Gamma.m:91-95` states `n²p + n(n+1)/2 + nk < T`
  on the *parameter* dimension (120 in the production shape, against `hac_dim`'s 135), which is
  the necessary one since `rank(WHat) ≤ min(par_dim, T−1)`. The moment-dimension gate is
  sufficient and strictly stronger; both are checked since the 2026-09-08 fidelity audit, and
  both bar exactly the same two cells (pre-COVID 120 ≥ 90, `(8,8)` 300 ≥ 162), so no published
  number depends on which one binds.
- **Significance is "the set excludes zero", read off the topology.** An AR set need not be an
  interval: `two_rays` excludes zero only when zero falls in its gap, `real_line` never does, and
  `empty` is a misspecification signal that scoring must not read as a sign. `ar_excludes_zero()`
  is the only place that rule lives. The set is bounded at level κ **iff ξ_mp > κ**. The
  `(5,2)` example of `arquivo/script/ar_bands.R` — ξ_mp = 2.339, unbounded at 90% and 95% — is
  the **untreated** model; under the production scale `(5,2)` has ξ_mp = 5.124 and is bounded at
  68, 90 and 95% (`output/factors/q_truncation_cells.csv`, cell `cheia_p4_lp`).
  **The small-VAR benchmark keeps its own AR/MOSW sets** (`R/identification/weak_iv_ar.R`, now the
  shared module: `Load`/`Inner` default to the identity and the VAR path is bit-identical, guarded
  by `validate_mosw_ar.R`). Those sets are inference *for the VAR*, never for the DFM, and
  coincidence licenses only "the central pattern is robust to weak-IV inference in an alternative
  lower-dimensional specification" — **never** "the SVAR proves the SDFM right". Weak-IV
  robustness is **not** instrument validity: both models use the same proxy, so a contaminated
  proxy fails in both.
- **No text may credit the `cumsum` fix with recovering the asset block.** At h=0 the `cumsum` is a
  no-op and the ×100 is a positive scalar on point and both bounds, so **h=0 significance is
  invariant to tcode**. Only the panel representation recovers the block, and it was declined.
  The fix shipped on 2026-08-17 (`asset_*` moved from tcode 2 to **tcode 6**, ×100 without
  accumulating) and the prohibition is now *measured*, not merely predicted: the block got **worse**
  away from h=0 — sig90 fell from 4 cells to 2, and sig68 at h≤12 stayed at 20. What the fix did
  deliver is band behaviour: the h36/h0 width ratio fell from 27.573 to 0.920 and the false
  Ibovespa peak went from +17.71% at h=21 to +2.01% at h=8.
- **The paper has one identification: the external proxy.** Heteroskedasticity and non-Gaussian
  (GMR) identification were abandoned on 2026-08-17 and may not be cited as corroboration, as a
  robustness leg, or as an alternative estimate. The negative frequency diagnostic and its
  archived artefacts remain under `arquivo/heterocedasticidade/`, but the dedicated code was
  removed on 2026-09-01. `goncalves2025` stays cited: that is *other people's* daily
  het-identified evidence the paper argues with, not this project's route. The Lenza-Primiceri
  COVID-volatility scale in the factor VAR (2026-09-14, off in production) is no exception: it
  reweights the estimation, identifies nothing, and its treated sets condition on θ̂.
- **The VAR benchmark tests DFM-vs-small-VAR, not "vs the literature"**, which uses Cholesky.
- **ξ_mp ≥ 10 is the Staiger-Stock rule of thumb** for the homoskedastic 2SLS first-stage F, **not an
  MOSW result**. §3.6 states this correctly since 2026-08-14; the naming is deliberately generic
  ("referência convencional") because a Staiger-Stock or Montiel Olea-Pflueger entry would break the
  25-key budget. Any future rewrite must not silently re-attribute the 10 to `montielolea`.
- **The state-dependence persistence result is suggestive, not central** — marginal p, found after
  looking, needs the three specs side by side.
- **Report the inconvenient number too.** The daily GRG replication that vindicates the FX result
  gives the **wrong sign for equities** — they are unidentified in that daily system.

### What does not reproduce — do not cite

- **Sovereign-confound tests B and D** (three-way split; dated 95-row table), cut 2026-08-10.
- **FOMC test 4** (the FOMC/non-FOMC split), cut 2026-08-10. Removing a leg that *passed* makes the
  reading rule strictly more permissive, so no verdict changed — but the numbers are gone.
- For both the record is in git, the rationale in `historico_decisoes.md` §2.4.

### Do not reopen without new evidence

- The **DI vertex** (126 bd) — settled by the construction sweep.
- The **log-level equity panel** — author decision, `historico_decisoes.md` §3.1.
- A **VECM** — the Johansen rank is not identified and the levels VAR is consistent regardless
  (Sims-Stock-Watson 1990; AK's own §2.2 defence).
- **Heteroskedasticity and non-Gaussian (GMR) identification** — both abandoned on **2026-08-17**,
  verdicts in `historico_decisoes.md` §0 and §1. Non-Gaussian code and artefacts remain in
  `arquivo/nao_gaussiana/`; heteroskedasticity's dedicated code was removed on **2026-09-01**
  (`arquivo/heterocedasticidade/` keeps only artefacts/verdict). **On 2026-09-21 the
  *diagnostic* half came back** — `R/identification/het_tests.R` and
  `script/het_conditions.R`, which §3.3 and Anexo B publish — while `ident_het_regimes()` and
  `het_shock_extraction.R` stayed deleted. The author also authorized an exploratory round
  that **does** build impulse responses from the identified column; it lives entirely in
  `het_rigobon/`, quarantined, `compute_irf_dfm()` gained no `"het"` branch, and nothing from
  that folder may be cited as corroboration, robustness or an alternative estimate without a
  separate author decision.
  **On 2026-09-22 the battery was cut to the `svars` package's test** (author decision).
  Rigobon states ONE condition, the rank condition, which fails iff the regime covariances
  are proportional; its multivariate form is the distinctness of the eigenvalues of `Λ` in
  `Σ_NC = BB'`, `Σ_C = BΛB'`, tested by the sequential `Qr` of Lütkepohl, Meitz, Netšunajev
  and Saikkonen (2021) as implemented in `svars`. **Five statistics were retired and may not
  be reported or cited again**: Mauchly's proportionality LR, the λ₁–λ₂ gap, `ratio_dir`,
  `rank1_share` and the permutation placebo. They were this project's own construction, and
  four of the five were consequences of the one condition that binds. Every number they
  produced — `p_boot` 0.0508, LR 135.1290, gap 0.7415, ratio 1.9630, the 0.20 min-gap
  criterion, the 37-cell Holm sweep — is **discontinued**, not merely superseded.
  ⚠ **`svars::id.cv()` is not called directly and must not be.** Its indicator path for a
  recurring regime is broken (`R/id.cv.R:177` subsets with `u[SB, ]`, reachable only with a
  numeric `SB`, so a 0/1 vector indexes by position); the estimate silently collapses to
  `Λ = I`. `fit_het_cv()` calls the package's estimator as `id.cv()` calls it internally and
  guards the result against the closed-form generalized eigendecomposition.
  **The series are `goncalves2025`'s own, on both sides** — the Wed→Thu change in the DI, the
  BRL/USD rate and the 5-year sovereign CDS (their Table 1). They use **no Ibovespa and no
  2-year DI**; the daily row this project published until 2026-09-21 used both, and that set
  was the project's, not theirs. Their fourth series, inflation expectations, is a bond
  breakeven this panel does not carry (the Focus measure is a survey, and its daily change is
  exactly zero on 23% of days), so it is left out and the gap is declared. The DI vertex is
  the dimension the authors themselves vary and is reported as a row.
  **What the round established, and what may be written.** Daily, the three series reject
  `λ₁ = λ₂` at the 3-month vertex (`Qr` 11.43, p 0.003, λ₁ 7.55 against 1.36). **The same
  three series in the monthly panel do not reject at any vertex** (p 0.917 to 0.988), and
  their two largest eigenvalues nearly coincide (2.51 against 2.36): the normalized rank
  determinant falls from 40.8 to −0.03, which is the proportionality Rigobon names as the
  failure mode. **The two frequencies are not decomposed, and no claim may decompose them.**
  Between the daily row and the monthly one, the observation frequency and the measured object
  change together — announcement window against calendar variation — and nothing measures
  either apart from the other. **The only monthly aggregation is the panel's own** (author
  decision, 2026-09-22): the reference month's last quotation for the DI vertices and the CDS,
  the monthly average for the exchange rate. The object that summed the Wed→Thu windows inside
  the calendar month was **removed**, and every number it produced — a = 8.735, det_ratio 74.65,
  `Qr` 6.73, p 0.0346 at the 3-month vertex, and the 6- and 12-month cells — is **discontinued**.
  Making the rule uniform does not change the verdict: with the exchange rate taken at month end
  too, the monthly p is 0.545 / 0.836 / 0.570 and the determinant stays inside ±0.34 — still no
  rejection at any vertex. The five factor innovations do not reject at 5% either (p 0.076).
  ⚠ Two sensitivities must travel with the daily claim. **The vertex matters**: from 3 to 6 and
  12 months p goes 0.003 → 0.084 → 0.147, tracking the fall in the DI variance ratio with
  maturity that `goncalves2025` report. **And the test's kurtosis correction decides the daily
  case**: with excess kurtosis 12.7 in the quiet regime it divides the statistic by 4.9, and
  without it every daily cell would reject. The corrected statistic is the valid one; both are
  in `output/het/het_conditions.csv` (`qr_12`, `qr_12_nk`).
  ⚠ **The exploratory responses are not estimates where the condition fails.** In the
  identified daily cell a 50bp tightening **narrows** the CDS 4.2bp and **appreciates** the BRL
  1.53% — `goncalves2025`'s sign on both. The monthly VAR is unidentified at every vertex and
  its point is not interpretable; the factor innovations give +9.60bp and +1.52% against the
  proxy's +30.5bp and +3.23%, but do not reject at 5% either. Responses without identification
  are printed as such and may not be read as direction and magnitude.
  **`goncalves2025`'s CDS is not null either.** Their Table 5 reports +0.01/−0.03/−0.05/−0.11
  at the 1/3/6/12-month vertices, in **percentage points** — −3/−5/−11 bp, the 12-month one
  distinct from zero (t ≈ 2.2) — which their own prose ("do not seem to affect the CDS")
  undersells. The replication lands on it (−11.96/−12.75/−10.37 bp). ⚠ Their CDS unit is
  **inferred, not declared**: fixed by two scale tests (published SE ratio 15.0 against a
  14.25 sd ratio in the rebuilt panel; basis points would give 0.14), documented in
  `het_rigobon/_common.R`. What may not be written: that GRG find no CDS response. §2 was
  corrected on 2026-09-22 and now reports the closing.
  GMR has no power on this panel because DFM aggregation destroys the non-Gaussianity. Loose
  ends that die with them: *conditional* het (GARCH-SVAR) and LMS (2017) via `svars::id.ngml`,
  neither attempted. **`svars` is installed since 2026-09-22** (with `copula` and `gsl`), for
  the identification test only. **Heteroskedasticity-robust *inference* is untouched** — the
  Anderson–Rubin sets and the HAC first stage are heteroskedasticity-robust.
- **Do not silently re-architect the identification core** — see `.claude/rules/identification.md`.
  The 2026-09-21 het round respected this: `het_rigobon/` imports `R/` read-only, builds its own
  reduced-form objects, and proves its local `rawimp` reproduces `compute_irf_dfm()` to **0
  exactly** rather than extracting the formula from the guarded file.

## Common commands

```bash
# End-to-end pipeline
Rscript script/run_all.R --list              # stages, inputs/outputs, what is missing
Rscript script/run_all.R --dry-run           # preflight only, runs nothing
Rscript script/run_all.R                     # full chain, network downloads included
Rscript script/run_all.R --from=clean        # skip the network stages

# Full instrument rebuild + diagnostics
Rscript script/download.R                    # all reproducible monthly and daily raw inputs
Rscript script/instrument.R                  # the 3 variants of tab:first_stage
Rscript script/instrument_diagnostics.R      # tab:first_stage columns per variant (CSV)
Rscript script/mosw_strength_grid.R          # ξ_mp over (r,q) × sample × instrument

# IRF inference, coherence and q sensitivity
Rscript script/irf_coherence_check.R         # 58 vars scored point-by-point (feeds §5)
Rscript script/q_sensitivity.R --window=cheia   # q = 2..5 narrative + paper/fig_q_sensibilidade.pdf; --window=pre_covid for the other
Rscript script/fig_section5.R                # paper/fig_*.pdf from the cached .rds

Rscript script/model_alessi.R                # main DFM: Bai-Ng surface + IRF figure
Rscript script/model_var.R                   # Olea small-VAR points, AR sets and diagnostics
Rscript script/fig_weak_iv.R                  # canonical small-VAR AR figure

# Regression checks against the reference code (MOSW, Stock-Watson, Lenza-Primiceri)
for f in script/validation/*.R; do Rscript "$f" || break; done
```

There is no formal test suite, linter or build step. `script/validation/` holds the regression
checks against the authors' code: rerun them after touching `R/modeling/` or `R/identification/`.
Otherwise iterate by running the relevant script.

**Smoke test after touching the identification path** (fast):

```r
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/weak_iv_ar.R")   # main_sdfm passa inference = "ar"
source("R/modeling/dfm_pipeline.R")
# every other argument is the production default, written in main_sdfm()'s
# signature; covid_volatility defaults to read_covid_volatility() of the CSV
res <- main_sdfm(r = 5L, q = 5L, p = 4, shock_size_bps = 50, mp_var = "yield_6m")
# note the field is `irfs`, not `irf`, and the names come from the data matrix
P <- res$irfs$irf_point_matrix; vn <- colnames(res$data)
P[match(c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd"), vn), 1]
```

Expected h0 (matches `output/validation/production_spec_impact_smoke.csv`),
**under the Lenza-Primiceri scale, with θ̂ as re-estimated on 2026-09-25 and `z_bs_purif` in
`data/processed/instrument.csv`** (production since 2026-09-26):
`yield_6m` 0.005, `yield_2y` 0.00720694, `yield_5y` 0.00773054,
`asset_ibov` −2.4654264, `cambio_usd` 0.14142146. Full precision, for a
bit-identical check: `0.0050000000000000001`, `0.0072069426647632393`,
`0.00773053809800818`, `-2.4654264316584382`, `0.14142146175048584`. Under `z_jk_bs_purif`
(production until 2026-09-26) they were `0.0070090429740256857`, `0.0072900596216797665`,
`-1.5019377453868872` and `0.12942378112688835`. The untreated point (`covid_volatility = NULL`)
is still pinned, as the degeneracy reference, in `script/validation/validate_covid_volatility.R`.

## Conventions

- **Language:** English for code, identifiers and this file; Portuguese for prose in `registro/`,
  `notas/`, `pareceres/`, `email/` and `output/*.md`.
- **Plots:** `ggplot2`, paper style — shaded 80% and 90% bands.
- **Comments:** minimal, only at non-trivial technical steps.
- **Record vs. session:** `notas/` is permanent and citable — a dated note per round, carrying a
  vintage banner, and it is what the paper pulls numbers from. `pareceres/` is what was *received*
  (`/council`, `/referee2`, `/auditor-externo`) and is kept verbatim. `email/` is the running
  email exchange with the advisor about the project, one file per message
  (`email_{meu,professor}_DD-MM_HHhMM.md`), kept verbatim like `pareceres/` but ongoing rather than
  a single delivered document. `progress_logs/` is session
  continuity and is disposable. Nothing durable goes into `progress_logs/`, and no session log goes
  into `notas/`.
- **Fail loud:** a missing input aborts with a pointer to the script that produces it. Never a
  silent fallback that makes "the collection was never run" indistinguishable from "the collection
  came back empty".
- **Boundaries:** `R/` holds reusable modules and **never sources anything in `script/`**; function
  files carry no run logic. **No live path sources from `arquivo/`, and no live code writes into
  it.** `diagnostics/` audits and **never modifies estimation code**.
- **Reference code:** `codigos_externos/` (Alessi-Kerssenfischer, JK, Bauer-Swanson, Montiel
  Olea-Stock-Watson) is **gitignored** — read-only for translation. Because of that, every
  `script/validation/validate_*.R` runs off a committed fixture in `output/validation/`, never off
  those directories.
- **`output/`** is git-tracked (~24 MB), most recently refreshed by the 2026-09-02 production
  migration; frozen artefacts (e.g. the VAR benchmark, archived het) carry their own vintage in
  `notas/_indice.md` and are not stale by being older.

## Scoped rules

`.claude/rules/` holds the area detail, each file declaring the `paths:` that load it — the estimation
contract and its traps (`identification.md`), variant construction and ξ_mp (`instrument.md`), the
panel and its two fixed external inputs (`data.md`), the audit round (`diagnostics.md`), and
generated-vs-hand-written outputs (`writing.md`).
