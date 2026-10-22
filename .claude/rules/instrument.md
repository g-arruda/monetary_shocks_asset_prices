---
paths:
  - "R/instrument/**"
  - "script/instrument*.R"
  - "script/mosw_strength_grid.R"
  - "script/validation/*.R"
---

# Instrument construction and strength

**The build chain lives in `R/instrument/build_variants.R`** (helpers in `di_surprise.R`),
parameterized by the DI vertex `target_bd`. `script/instrument.R` calls it once with production
values and keeps **all** I/O. Production vertex is `TARGET_BD = 126` ≈ 6m DI;
`PRODUCTION_VARIANT` in that script picks the column written to the legacy single-column
`data/processed/instrument.csv`.

**Since 2026-09-26 (the author's chosen construction, built on `feature/bs-copom-surpresas-macro` and
fast-forwarded into `main` the same day)** the BS regressions run on the 102 Copom events alone, with a constant and no
trend, as BS Table 3 does. The predictors are the Table 3 counterparts plus two external trends:
- the 65-day trends in the Ibovespa, the DI 2y−3m slope and Brent (`pre_*`);
- four macro news regressors (`news_*`): the IPCA and GDP surprises, GDP as first released; the EX0
  core acceleration; the Focus median for the next IPCA;
- the 65-day S&P 500 and VIX trends, as external conditions.

The 20-day Focus revisions (IPCA and Selic) and the BRL trend are **out**: the Focus revisions come
from BS Table 2, not Table 3. By author decision the variant with the Selic revision (production
ξ_mp 1.78) is not reported in the paper; its numbers stay in `notas/2026-09-25_bs_copom_surpresas_macro.md`.
Macro inputs come from `script/download_macro_news.R`. **Since 2026-09-26 production
is `z_bs_purif`**, the orthogonalized surprise without the JK sign filter (author decision, for
now): in this construction the filter *lowers* ξ_mp, 7.02 → 5.01 full and 6.84 → 4.73 pre-COVID.
Production ξ_mp is therefore 7.02 full / 6.84 pre-COVID, every AR set `interval` at 80 and 90%.
`notas/2026-09-26_bs_lista_tabela3_externas.md` and
`notas/2026-09-26_producao_bs_purif_bandas_80_90.md` have the numbers. **The paper migrated the same day and reports no JK layer at
all** (author decision; since 2026-09-30 one §3.4 footnote gives the strength and significance loss,
`notas/2026-09-30_nota_filtro_jk.md`): `tab:first_stage` has two rows, `tab:bs_ortogonalizacao` only the DI column,
and `fig:instrumento_camadas` only production and `z_bruto`
(`notas/2026-09-26_migracao_paper_bs_purif.md`). `z_jk_bs_purif` is still built, because the
strength grid and the diagnostics use all three layers. Since 2026-10-21 `script/instrument_layers_irf.R`
estimates it again and writes its responses to `output/irf/instrument_layers_irf.csv`, for the §3.3
footnote, while `FIGURE_LAYERS` keeps it out of the figure (`notas/2026-10-21_artigo_base_111.md`).

**Only the three variants of `tab:first_stage` exist in live code since 2026-09-18**, one per
construction layer: `z_bruto` (raw Wed→Thu surprise), `z_bs_purif` (+ Bauer-Swanson pre-event
orthogonalization; production since 2026-09-26) and `z_jk_bs_purif`
(+ Jarociński-Karadi sign filter on the BS residuals; production until 2026-09-26). The contemporaneous purification, the raw-sign mask, the UST 2y control and the FOMC
flag left with the variants and tests they fed. Monthly aggregation is JK's within-month sum,
**not** GK's moving-average scheme — a justified choice since 2026-07-27, not a deviation: GK's
fn. 11 conditions its weighting on a *monthly-average* policy indicator while `yield_6m` here is
end-of-month, and the GK scheme on this panel collapsed ξ_mp from 10.43 to 0.30 (the GK aggregator
left the code on 2026-09-18). On `main` and `feature/focus-horizonte-fixo`, the same-session
S&P/VIX/Brent filter on the Thursday panel still fixes the sample of the BS regressions, which 102 of
the 111 Copom Wednesdays enter. **Since 2026-10-17, on `feature/auditoria-janelas-copom`, that filter
is gone** (a residue of the contemporaneous purification that dropped the 2 Thanksgiving meetings).
- The events are the Copom meetings with a measured surprise, from the Wednesday close to the first DI
  session after it: all 111 in production.
- The 7 on the eve of a Brazilian holiday, whose window runs to Friday, enter under the mandatory
  argument `holiday_windows = TRUE`, which production passes; `FALSE` leaves them out (104, the
  advisor's sensitivity, `data/processed/instrument_no_holiday_windows.csv`).
- A missing surprise or predictor `stop()`s; nothing is filled with zero
  (`notas/2026-10-17_auditoria_janelas_copom.md`).

**The finding that governed variant choice until 2026-09-26: strength lives in the *mask*, not the
purified values.** It does not survive the current BS construction, where the mask lowers ξ_mp
(above).
Predetermined masks (raw or BS-pre-event) exclude the 2020-03-19 COVID panic day that
contemporaneous residual-sign classification mislabels as monetary. Quantified by the FOMC round:
orthogonalizing the **values** costs ~0.2 of ξ_mp; **re-deriving the mask** costs ~2.5 — twelve times
more, because the global block explains far more of the equity leg than of the DI leg, and the equity
leg is half the sign rule.

## ξ_mp is the strength ruler of record

`compute_factor_space_wald` (`R/identification/factor_space_diagnostics.R`) — the MOSW Wald in the
`yield_6m`-impact direction, validated against the authors' official code. The 95% AR set is a
bounded interval **iff ξ_mp > 3.84**; conventional bands are approximately valid at ξ_mp ≥ 10.
Since 2026-08-18 that boundedness prediction is no longer only a flag: `mosw_ar_bounds`
(`R/identification/weak_iv_ar.R`) actually constructs the set for the **small VAR**, and its
`ahat > 0` test is the same inequality. **Since 2026-09-08 the same holds for the DFM**: the sets
are production inference, `script/irf_coherence_check.R` asserts `ahat > 0` agrees with
`xi_den > critval` on every run, and `xi_den` reproduces the grid's `wald_mp` to 7.5e-12 by an
independent route — the MOSW `W2` block instead of `compute_factor_space_wald`. What the grid does
**not** tell you is whether a cell can be estimated at all: `mosw_rform_cov` needs
`hac_dim = (1 + r*p + r + 1)*r < T`, so `(8,8)` at `p=4` (336 ≥ 162) and the pre-COVID window at
`p=4` (135 ≥ 90) carry an `ar_bounded` flag for a set that cannot be built.
`nw_lags` defaults to 0 (Eicker-White), so every published number is unchanged; the Bartlett kernel
is only needed for a GK-aggregated instrument, which induces an MA(1). The legacy first-stage F
rulers (`f_factor`, F (y6m AR)) are still computed and reported but **stopped deciding on
2026-07-26**. Grid: `output/instrument/mosw_strength_grid.csv` (the `.md` beside it stopped being
written on 2026-09-18 and stays as a cited record).

## Traps

- **Fail loud on missing inputs.** `build_variants.R` once computed a `fomc_coincide` flag that was
  identically FALSE for months because `instrument.R` fell back silently to an empty date vector.
  **The defect was the `else`**: a silent fallback makes "never collected" indistinguishable from
  "returned nothing". The flag and the FOMC-date input left the code on 2026-09-18 with the archived
  FOMC test; the lesson stands for every input.
- **Masks built from `sign(residuals(lm))` carry a `names` attribute** that a CSV round-trip drops.
  When checking a rebuilt daily panel against `copom_event_diagnostics.csv`, compare **values**, not
  `identical()`.
- **`denom_vs_prod`**: when the normalization denominator shrinks, part of a larger magnitude is
  arithmetic, not economics — and below ξ_mp 10 a variant supports **direction, not interval**.
- **The daily confound tests are archived**: `arquivo/script/jk_sovereign_confound.R` on 2026-09-17,
  `arquivo/script/fomc_coincidence.R` and its `arquivo/R/instrument/event_tests.R` on 2026-09-18.
  Their `p_boot` was seeded per cell (`wild_coef_test(key=)`), so adding a proxy could not move
  another cell's p; preserve that if they are ever revived.
- **`script/validation/*.R` must run off a committed fixture in `output/validation/`**, never off
  `codigos_externos/` — those are gitignored, which is why `validate_olea_kilian.R` was silently
  broken for months.
