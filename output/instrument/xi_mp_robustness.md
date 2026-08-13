# Robustez do ξ_mp — leave-one-month-out e HAC

Gerado por `script/xi_mp_robustness.R` em 2026-08-12.

Especificação de produção: r = 7, q = 6, p = 6, direção de normalização = `yield_6m`. 5 instrumentos × 2 amostras.

O DFM entra **uma vez por amostra** e fica fixo; só o momento Γ é recomputado. `c_mp` também vem do DFM, então o exercício isola a influência que passa pelo **momento**, não pela estimação de fatores.

Régua MOSW: ξ_mp ≥ 10 sustenta bandas convencionais; 3,84 < ξ_mp < 10 é
instrumento fraco com conjunto AR limitado; ξ_mp ≤ 3,84, conjunto AR
possivelmente ilimitado.

## 1. Baseline

| sample | instrument | n_obs | xi_mp |
|---|---|---|---|
| full | z_jk_bs_purif |   147 | 7.648 |
| full | z_jk_raw |   147 | 7.694 |
| full | z_jk_raw_purif |   147 | 7.649 |
| full | z_jk_purif |   147 | 5.312 |
| full | z_bruto |   147 | 6.481 |
| pre_covid | z_jk_bs_purif |    78 | 11.54 |
| pre_covid | z_jk_raw |    78 |  10.1 |
| pre_covid | z_jk_raw_purif |    78 | 10.74 |
| pre_covid | z_jk_purif |    78 | 13.89 |
| pre_covid | z_bruto |    78 | 16.86 |

## 2. Leave-one-month-out

`swing_dn` é quanto o ξ_mp cai no pior mês descartado; `swing_up`, quanto sobe no melhor. `n_below10` conta quantos descartes individuais derrubam o ξ_mp abaixo de 10.

| scope | sample | instrument | xi_mp | xi_min | xi_median | xi_max | swing_dn | swing_up | n_below10 | n_below384 | n_drops |
|---|---|---|---|---|---|---|---|---|---|---|---|
| todos os meses | full | z_bruto | 6.481 | 4.399 | 6.471 | 8.294 | 2.082 | 1.813 |   147 |     0 |   147 |
| todos os meses | full | z_jk_bs_purif | 7.648 | 5.652 | 7.634 | 9.254 | 1.996 | 1.606 |   147 |     0 |   147 |
| todos os meses | full | z_jk_purif | 5.312 | 3.211 |  5.31 | 7.463 | 2.101 | 2.151 |   147 |     2 |   147 |
| todos os meses | full | z_jk_raw | 7.694 | 5.694 | 7.674 |  9.25 | 1.999 | 1.557 |   147 |     0 |   147 |
| todos os meses | full | z_jk_raw_purif | 7.649 | 5.622 | 7.628 |  9.13 | 2.027 | 1.482 |   147 |     0 |   147 |
| todos os meses | pre_covid | z_bruto | 16.86 | 13.07 | 16.63 | 21.69 | 3.785 | 4.832 |     0 |     0 |    78 |
| todos os meses | pre_covid | z_jk_bs_purif | 11.54 | 7.746 | 11.32 | 18.71 | 3.789 | 7.178 |     7 |     0 |    78 |
| todos os meses | pre_covid | z_jk_purif | 13.89 | 9.919 | 13.74 | 20.53 | 3.969 | 6.645 |     1 |     0 |    78 |
| todos os meses | pre_covid | z_jk_raw |  10.1 |  6.19 | 9.992 | 15.54 | 3.906 | 5.445 |    40 |     0 |    78 |
| todos os meses | pre_covid | z_jk_raw_purif | 10.74 | 6.776 | 10.65 |  16.4 | 3.964 | 5.655 |    18 |     0 |    78 |
| meses com z != 0 | full | z_bruto | 6.481 | 4.399 | 6.471 | 8.294 | 2.082 | 1.813 |    87 |     0 |    87 |
| meses com z != 0 | full | z_jk_bs_purif | 7.648 | 5.652 |  7.62 | 9.254 | 1.996 | 1.606 |    60 |     0 |    60 |
| meses com z != 0 | full | z_jk_purif | 5.312 | 3.211 | 5.294 | 7.463 | 2.101 | 2.151 |    63 |     2 |    63 |
| meses com z != 0 | full | z_jk_raw | 7.694 | 5.694 | 7.643 |  9.25 | 1.999 | 1.557 |    54 |     0 |    54 |
| meses com z != 0 | full | z_jk_raw_purif | 7.649 | 5.622 | 7.611 |  9.13 | 2.027 | 1.482 |    54 |     0 |    54 |
| meses com z != 0 | pre_covid | z_bruto | 16.86 | 13.07 |  16.5 | 21.69 | 3.785 | 4.832 |     0 |     0 |    46 |
| meses com z != 0 | pre_covid | z_jk_bs_purif | 11.54 | 7.746 | 11.03 | 18.71 | 3.789 | 7.178 |     4 |     0 |    29 |
| meses com z != 0 | pre_covid | z_jk_purif | 13.89 | 9.919 | 13.26 | 20.53 | 3.969 | 6.645 |     1 |     0 |    29 |
| meses com z != 0 | pre_covid | z_jk_raw |  10.1 |  6.19 |   9.9 | 15.54 | 3.906 | 5.445 |    15 |     0 |    25 |
| meses com z != 0 | pre_covid | z_jk_raw_purif | 10.74 | 6.776 | 10.48 |  16.4 | 3.964 | 5.655 |     8 |     0 |    25 |

### Meses mais influentes — instrumento de produção `z_jk_bs_purif`

`delta` = ξ_mp sem o mês − ξ_mp cheio. Negativo: o mês *sustenta* a força.

| sample | mes | xi_mp_sem_o_mes | delta |
|---|---|---|---|
| full | 2021-10 | 5.652 | -1.996 |
| full | 2024-12 | 5.803 | -1.845 |
| full | 2017-01 | 6.199 | -1.449 |
| full | 2022-05 | 6.268 | -1.38 |
| full | 2021-04 | 6.326 | -1.322 |
| full | 2021-03 | 6.425 | -1.223 |
| full | 2018-05 | 6.526 | -1.121 |
| full | 2025-03 | 8.941 | 1.293 |
| full | 2020-10 | 9.154 | 1.506 |
| full | 2021-06 | 9.254 | 1.606 |
| pre_covid | 2014-01 | 7.746 | -3.789 |
| pre_covid | 2017-01 | 9.168 | -2.367 |
| pre_covid | 2017-11 | 9.207 | -2.328 |
| pre_covid | 2015-12 | 9.325 | -2.21 |
| pre_covid | 2018-05 | 9.414 | -2.121 |
| pre_covid | 2018-01 | 9.651 | -1.884 |
| pre_covid | 2013-07 | 9.665 | -1.87 |
| pre_covid | 2017-05 | 10.14 |  -1.4 |
| pre_covid | 2019-10 | 16.13 | 4.596 |
| pre_covid | 2016-12 | 18.71 | 7.178 |

## 3. HAC — ξ_mp por defasagem de Newey-West

NW(0) é Eicker-White, a convenção das aplicações oficiais (`OilSVARIV.m:50`). O kernel de Bartlett para NW > 0 é a transcrição de `NW_hac_STATA.m`, validada em `script/validate_hac_kernel.R` contra a aplicação oficial de impostos (`TaxSVARIV.m`, NWlags = 8, diferença relativa 2,6e-10).

| sample | instrument | NW(0) | NW(1) | NW(2) | NW(3) | NW(4) | NW(5) | NW(6) |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_bs_purif |  7.65 |  7.24 |  7.27 |   7.9 |  8.81 |  9.47 |  9.72 |
| full | z_jk_raw |  7.69 |   7.1 |  7.12 |  7.75 |  8.62 |  9.32 |  9.71 |
| full | z_jk_raw_purif |  7.65 |  7.04 |  7.04 |  7.64 |  8.46 |  9.12 |  9.48 |
| full | z_jk_purif |  5.31 |  5.07 |  4.96 |   5.2 |  5.51 |   5.7 |  5.72 |
| full | z_bruto |  6.48 |  6.19 |     6 |  6.23 |  6.56 |  6.67 |  6.66 |
| pre_covid | z_jk_bs_purif | 11.53 | 12.49 | 13.44 | 13.62 | 13.68 | 13.93 |  12.6 |
| pre_covid | z_jk_raw |  10.1 | 10.74 | 11.36 | 11.41 | 11.47 | 11.58 | 10.72 |
| pre_covid | z_jk_raw_purif | 10.74 | 11.37 | 12.03 | 12.06 | 12.07 | 12.16 | 11.24 |
| pre_covid | z_jk_purif | 13.89 | 15.36 | 14.67 | 12.85 | 11.75 | 11.35 | 10.59 |
| pre_covid | z_bruto | 16.86 | 18.14 | 18.51 | 17.55 | 17.37 | 18.43 |  17.5 |

