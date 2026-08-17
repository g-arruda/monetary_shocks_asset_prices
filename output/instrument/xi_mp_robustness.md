# Robustez do ξ_mp — leave-one-month-out e HAC

Gerado por `script/xi_mp_robustness.R` em 2026-08-17.

Especificação de produção: r = 5, q = 5, p = 6, direção de normalização = `yield_6m`. 5 instrumentos × 2 amostras.

O DFM entra **uma vez por amostra** e fica fixo; só o momento Γ é recomputado. `c_mp` também vem do DFM, então o exercício isola a influência que passa pelo **momento**, não pela estimação de fatores.

Régua MOSW: ξ_mp ≥ 10 sustenta bandas convencionais; 3,84 < ξ_mp < 10 é
instrumento fraco com conjunto AR limitado; ξ_mp ≤ 3,84, conjunto AR
possivelmente ilimitado.

## 1. Baseline

| sample | instrument | n_obs | xi_mp |
|---|---|---|---|
| full | z_jk_bs_purif |   147 | 6.271 |
| full | z_jk_raw |   147 | 6.494 |
| full | z_jk_raw_purif |   147 | 6.343 |
| full | z_jk_purif |   147 |  3.98 |
| full | z_bruto |   147 | 5.271 |
| pre_covid | z_jk_bs_purif |    78 | 10.99 |
| pre_covid | z_jk_raw |    78 | 11.02 |
| pre_covid | z_jk_raw_purif |    78 | 11.31 |
| pre_covid | z_jk_purif |    78 | 7.552 |
| pre_covid | z_bruto |    78 | 14.86 |

## 2. Leave-one-month-out

`swing_dn` é quanto o ξ_mp cai no pior mês descartado; `swing_up`, quanto sobe no melhor. `n_below10` conta quantos descartes individuais derrubam o ξ_mp abaixo de 10.

| scope | sample | instrument | xi_mp | xi_min | xi_median | xi_max | swing_dn | swing_up | n_below10 | n_below384 | n_drops |
|---|---|---|---|---|---|---|---|---|---|---|---|
| todos os meses | full | z_bruto | 5.271 | 3.907 | 5.267 | 6.039 | 1.364 | 0.768 |   147 |     0 |   147 |
| todos os meses | full | z_jk_bs_purif | 6.271 | 4.888 | 6.271 | 6.964 | 1.383 | 0.693 |   147 |     0 |   147 |
| todos os meses | full | z_jk_purif |  3.98 | 2.569 | 3.975 | 4.584 | 1.411 | 0.604 |   147 |    20 |   147 |
| todos os meses | full | z_jk_raw | 6.494 | 5.109 | 6.494 | 7.117 | 1.386 | 0.623 |   147 |     0 |   147 |
| todos os meses | full | z_jk_raw_purif | 6.343 | 4.961 | 6.343 | 6.982 | 1.382 | 0.638 |   147 |     0 |   147 |
| todos os meses | pre_covid | z_bruto | 14.86 | 10.33 | 14.75 |  16.7 | 4.531 | 1.837 |     0 |     0 |    78 |
| todos os meses | pre_covid | z_jk_bs_purif | 10.99 | 7.812 | 10.99 | 14.72 | 3.181 | 3.726 |    14 |     0 |    78 |
| todos os meses | pre_covid | z_jk_purif | 7.552 | 5.142 | 7.526 | 9.942 |  2.41 |  2.39 |    78 |     0 |    78 |
| todos os meses | pre_covid | z_jk_raw | 11.02 | 7.189 | 10.96 | 14.07 | 3.836 | 3.045 |    10 |     0 |    78 |
| todos os meses | pre_covid | z_jk_raw_purif | 11.31 | 7.313 | 11.24 | 14.13 | 3.998 | 2.818 |     8 |     0 |    78 |
| meses com z != 0 | full | z_bruto | 5.271 | 3.907 | 5.263 | 6.039 | 1.364 | 0.768 |    87 |     0 |    87 |
| meses com z != 0 | full | z_jk_bs_purif | 6.271 | 4.888 |  6.26 | 6.964 | 1.383 | 0.693 |    60 |     0 |    60 |
| meses com z != 0 | full | z_jk_purif |  3.98 | 2.569 | 3.974 | 4.584 | 1.411 | 0.604 |    63 |    15 |    63 |
| meses com z != 0 | full | z_jk_raw | 6.494 | 5.109 | 6.489 | 7.062 | 1.386 | 0.568 |    54 |     0 |    54 |
| meses com z != 0 | full | z_jk_raw_purif | 6.343 | 4.961 | 6.333 | 6.925 | 1.382 | 0.582 |    54 |     0 |    54 |
| meses com z != 0 | pre_covid | z_bruto | 14.86 | 10.33 | 14.64 |  16.7 | 4.531 | 1.837 |     0 |     0 |    46 |
| meses com z != 0 | pre_covid | z_jk_bs_purif | 10.99 | 7.812 |    11 | 14.72 | 3.181 | 3.726 |     8 |     0 |    29 |
| meses com z != 0 | pre_covid | z_jk_purif | 7.552 | 5.142 | 7.461 | 9.109 |  2.41 | 1.557 |    29 |     0 |    29 |
| meses com z != 0 | pre_covid | z_jk_raw | 11.02 | 7.189 | 10.74 | 14.07 | 3.836 | 3.045 |     7 |     0 |    25 |
| meses com z != 0 | pre_covid | z_jk_raw_purif | 11.31 | 7.313 | 11.04 | 14.13 | 3.998 | 2.818 |     6 |     0 |    25 |

### Meses mais influentes — instrumento de produção `z_jk_bs_purif`

`delta` = ξ_mp sem o mês − ξ_mp cheio. Negativo: o mês *sustenta* a força.

| sample | mes | xi_mp_sem_o_mes | delta |
|---|---|---|---|
| full | 2024-12 | 4.888 | -1.383 |
| full | 2021-03 | 5.078 | -1.192 |
| full | 2016-01 |  5.13 | -1.141 |
| full | 2017-01 | 5.373 | -0.898 |
| full | 2021-10 | 5.499 | -0.772 |
| full | 2021-04 |   5.5 | -0.771 |
| full | 2018-05 | 5.576 | -0.695 |
| full | 2016-12 | 6.871 |   0.6 |
| full | 2018-10 | 6.872 | 0.601 |
| full | 2020-10 | 6.964 | 0.693 |
| pre_covid | 2016-01 | 7.812 | -3.181 |
| pre_covid | 2017-01 | 8.055 | -2.937 |
| pre_covid | 2018-05 | 8.844 | -2.149 |
| pre_covid | 2014-01 | 8.853 | -2.14 |
| pre_covid | 2014-02 | 8.923 | -2.069 |
| pre_covid | 2017-07 | 9.265 | -1.728 |
| pre_covid | 2015-11 | 9.455 | -1.537 |
| pre_covid | 2016-05 | 9.658 | -1.335 |
| pre_covid | 2016-12 | 12.74 | 1.744 |
| pre_covid | 2019-10 | 14.72 | 3.726 |

## 3. HAC — ξ_mp por defasagem de Newey-West

NW(0) é Eicker-White, a convenção das aplicações oficiais (`OilSVARIV.m:50`). O kernel de Bartlett para NW > 0 é a transcrição de `NW_hac_STATA.m`, validada em `script/validate_hac_kernel.R` contra a aplicação oficial de impostos (`TaxSVARIV.m`, NWlags = 8, diferença relativa 2,6e-10).

| sample | instrument | NW(0) | NW(1) | NW(2) | NW(3) | NW(4) | NW(5) | NW(6) |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_bs_purif |  6.27 |  6.29 |  6.54 |  6.96 |  7.45 |  7.92 |  8.05 |
| full | z_jk_raw |  6.49 |  6.33 |  6.57 |  6.99 |  7.47 |  7.93 |  8.09 |
| full | z_jk_raw_purif |  6.34 |  6.19 |   6.4 |  6.79 |  7.22 |  7.63 |  7.79 |
| full | z_jk_purif |  3.98 |  3.95 |  4.09 |  4.31 |  4.59 |  4.81 |  4.87 |
| full | z_bruto |  5.27 |  5.18 |  5.27 |  5.57 |  5.99 |  6.35 |  6.48 |
| pre_covid | z_jk_bs_purif | 10.99 |  9.98 |  9.92 |  9.89 |  9.79 |  9.87 |   9.6 |
| pre_covid | z_jk_raw | 11.02 | 10.18 | 10.02 |  9.87 |  9.74 |  9.74 |  9.47 |
| pre_covid | z_jk_raw_purif | 11.31 | 10.27 |    10 |  9.82 |  9.63 |  9.61 |  9.33 |
| pre_covid | z_jk_purif |  7.55 |  7.49 |   8.3 |  8.16 |  7.91 |  7.75 |  7.23 |
| pre_covid | z_bruto | 14.86 | 13.81 | 14.96 | 14.83 | 14.45 | 14.38 | 13.62 |

