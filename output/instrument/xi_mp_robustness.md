# Robustez do ξ_mp — leave-one-month-out e HAC

Gerado por `script/xi_mp_robustness.R` em 2026-07-27.

Especificação de produção: r = 7, q = 6, p = 6, direção de normalização = `yield_6m`. 5 instrumentos × 2 amostras.

O DFM entra **uma vez por amostra** e fica fixo; só o momento Γ é recomputado. `c_mp` também vem do DFM, então o exercício isola a influência que passa pelo **momento**, não pela estimação de fatores.

Régua MOSW: ξ_mp ≥ 10 sustenta bandas convencionais; 3,84 < ξ_mp < 10 é
instrumento fraco com conjunto AR limitado; ξ_mp ≤ 3,84, conjunto AR
possivelmente ilimitado.

## 1. Baseline

| sample | instrument | n_obs | xi_mp |
|---|---|---|---|
| full | z_jk_bs_purif |   147 | 10.43 |
| full | z_jk_raw |   147 | 10.55 |
| full | z_jk_raw_purif |   147 | 10.39 |
| full | z_jk_purif |   147 | 5.773 |
| full | z_bruto |   147 | 7.574 |
| pre_covid | z_jk_bs_purif |    78 | 12.22 |
| pre_covid | z_jk_raw |    78 | 10.45 |
| pre_covid | z_jk_raw_purif |    78 |  11.1 |
| pre_covid | z_jk_purif |    78 | 13.68 |
| pre_covid | z_bruto |    78 | 17.02 |

## 2. Leave-one-month-out

`swing_dn` é quanto o ξ_mp cai no pior mês descartado; `swing_up`, quanto sobe no melhor. `n_below10` conta quantos descartes individuais derrubam o ξ_mp abaixo de 10.

| scope | sample | instrument | xi_mp | xi_min | xi_median | xi_max | swing_dn | swing_up | n_below10 | n_below384 | n_drops |
|---|---|---|---|---|---|---|---|---|---|---|---|
| todos os meses | full | z_bruto | 7.574 | 5.719 | 7.576 | 10.12 | 1.855 | 2.544 |   146 |     0 |   147 |
| todos os meses | full | z_jk_bs_purif | 10.43 | 8.426 | 10.44 | 12.21 | 2.005 | 1.782 |    24 |     0 |   147 |
| todos os meses | full | z_jk_purif | 5.773 | 3.776 | 5.768 | 8.583 | 1.997 |  2.81 |   147 |     1 |   147 |
| todos os meses | full | z_jk_raw | 10.55 | 8.615 | 10.56 | 12.36 | 1.935 | 1.809 |    20 |     0 |   147 |
| todos os meses | full | z_jk_raw_purif | 10.39 | 8.481 | 10.39 | 12.14 | 1.907 | 1.755 |    23 |     0 |   147 |
| todos os meses | pre_covid | z_bruto | 17.02 | 13.56 | 16.86 | 21.89 | 3.455 | 4.873 |     0 |     0 |    78 |
| todos os meses | pre_covid | z_jk_bs_purif | 12.22 | 8.397 | 11.96 | 18.83 | 3.826 | 6.604 |     4 |     0 |    78 |
| todos os meses | pre_covid | z_jk_purif | 13.68 | 9.861 | 13.57 | 19.45 | 3.823 | 5.768 |     1 |     0 |    78 |
| todos os meses | pre_covid | z_jk_raw | 10.45 | 6.661 | 10.34 | 15.36 | 3.787 |  4.91 |    27 |     0 |    78 |
| todos os meses | pre_covid | z_jk_raw_purif |  11.1 | 7.254 |    11 | 16.19 | 3.847 | 5.087 |    13 |     0 |    78 |
| meses com z != 0 | full | z_bruto | 7.574 | 5.719 | 7.547 | 10.12 | 1.855 | 2.544 |    86 |     0 |    87 |
| meses com z != 0 | full | z_jk_bs_purif | 10.43 | 8.426 | 10.42 | 12.21 | 2.005 | 1.782 |    15 |     0 |    60 |
| meses com z != 0 | full | z_jk_purif | 5.773 | 3.776 | 5.753 | 8.583 | 1.997 |  2.81 |    63 |     1 |    63 |
| meses com z != 0 | full | z_jk_raw | 10.55 | 8.615 | 10.54 | 12.36 | 1.935 | 1.809 |    12 |     0 |    54 |
| meses com z != 0 | full | z_jk_raw_purif | 10.39 | 8.481 | 10.38 | 12.14 | 1.907 | 1.755 |    14 |     0 |    54 |
| meses com z != 0 | pre_covid | z_bruto | 17.02 | 13.56 | 16.76 | 21.89 | 3.455 | 4.873 |     0 |     0 |    46 |
| meses com z != 0 | pre_covid | z_jk_bs_purif | 12.22 | 8.397 |  11.7 | 18.83 | 3.826 | 6.604 |     3 |     0 |    29 |
| meses com z != 0 | pre_covid | z_jk_purif | 13.68 | 9.861 |    13 | 19.45 | 3.823 | 5.768 |     1 |     0 |    29 |
| meses com z != 0 | pre_covid | z_jk_raw | 10.45 | 6.661 |  10.2 | 15.36 | 3.787 |  4.91 |    11 |     0 |    25 |
| meses com z != 0 | pre_covid | z_jk_raw_purif |  11.1 | 7.254 | 10.81 | 16.19 | 3.847 | 5.087 |     7 |     0 |    25 |

### Meses mais influentes — instrumento de produção `z_jk_bs_purif`

`delta` = ξ_mp sem o mês − ξ_mp cheio. Negativo: o mês *sustenta* a força.

| sample | mes | xi_mp_sem_o_mes | delta |
|---|---|---|---|
| full | 2024-12 | 8.426 | -2.005 |
| full | 2023-05 | 8.532 | -1.899 |
| full | 2022-05 | 8.832 | -1.599 |
| full | 2017-01 | 8.846 | -1.584 |
| full | 2023-01 | 9.092 | -1.339 |
| full | 2016-01 | 9.178 | -1.253 |
| full | 2018-05 | 9.233 | -1.198 |
| full | 2018-10 | 11.66 | 1.233 |
| full | 2020-10 |  11.7 | 1.269 |
| full | 2025-03 | 12.21 | 1.782 |
| pre_covid | 2014-01 | 8.397 | -3.826 |
| pre_covid | 2017-11 | 9.719 | -2.504 |
| pre_covid | 2017-01 | 9.768 | -2.455 |
| pre_covid | 2018-05 | 9.818 | -2.405 |
| pre_covid | 2015-12 | 10.11 | -2.113 |
| pre_covid | 2018-01 | 10.31 | -1.91 |
| pre_covid | 2013-07 | 10.62 | -1.608 |
| pre_covid | 2016-05 | 10.74 | -1.484 |
| pre_covid | 2019-10 | 16.98 | 4.762 |
| pre_covid | 2016-12 | 18.83 | 6.604 |

## 3. HAC — ξ_mp por defasagem de Newey-West

NW(0) é Eicker-White, a convenção das aplicações oficiais (`OilSVARIV.m:50`). O kernel de Bartlett para NW > 0 é a transcrição de `NW_hac_STATA.m`, validada em `script/validate_hac_kernel.R` contra a aplicação oficial de impostos (`TaxSVARIV.m`, NWlags = 8, diferença relativa 2,6e-10).

| sample | instrument | NW(0) | NW(1) | NW(2) | NW(3) | NW(4) | NW(5) | NW(6) |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_bs_purif | 10.43 | 10.13 | 10.61 | 11.73 | 12.97 | 14.54 | 15.64 |
| full | z_jk_raw | 10.55 |  9.98 | 10.42 | 11.47 | 12.47 | 13.91 | 15.04 |
| full | z_jk_raw_purif | 10.39 |  9.75 | 10.12 |  11.1 | 12.02 | 13.34 | 14.36 |
| full | z_jk_purif |  5.77 |   5.5 |  5.68 |  6.01 |  6.26 |  6.56 |  6.67 |
| full | z_bruto |  7.57 |  7.28 |  7.49 |  7.98 |  8.31 |  8.71 |  8.86 |
| pre_covid | z_jk_bs_purif | 12.22 | 12.98 | 13.92 | 14.07 | 14.19 | 14.45 | 13.14 |
| pre_covid | z_jk_raw | 10.45 | 10.94 | 11.53 | 11.55 | 11.65 | 11.78 | 10.98 |
| pre_covid | z_jk_raw_purif |  11.1 | 11.57 |  12.2 | 12.21 | 12.27 | 12.38 | 11.53 |
| pre_covid | z_jk_purif | 13.68 | 14.77 | 14.09 | 12.35 | 11.33 | 10.97 |  10.3 |
| pre_covid | z_bruto | 17.02 | 18.15 | 18.49 | 17.38 | 17.11 | 17.98 | 17.09 |

