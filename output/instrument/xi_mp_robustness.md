# Robustez do ξ_mp — leave-one-month-out e HAC

Gerado por `script/xi_mp_robustness.R` em 2026-08-25.

Especificação de produção: r = 5, q = 5, p = 4, direção de normalização = `yield_6m`. 5 instrumentos × 2 amostras.

O DFM entra **uma vez por amostra** e fica fixo; só o momento Γ é recomputado. `c_mp` também vem do DFM, então o exercício isola a influência que passa pelo **momento**, não pela estimação de fatores.

Régua MOSW: ξ_mp ≥ 10 sustenta bandas convencionais; 3,84 < ξ_mp < 10 é
instrumento fraco com conjunto AR limitado; ξ_mp ≤ 3,84, conjunto AR
possivelmente ilimitado.

## 1. Baseline

| sample | instrument | n_obs | xi_mp |
|---|---|---|---|
| full | z_jk_bs_purif |   149 |  5.24 |
| full | z_jk_raw |   149 | 5.384 |
| full | z_jk_raw_purif |   149 | 5.285 |
| full | z_jk_purif |   149 | 3.404 |
| full | z_bruto |   149 | 4.255 |
| pre_covid | z_jk_bs_purif |    80 | 7.478 |
| pre_covid | z_jk_raw |    80 | 7.128 |
| pre_covid | z_jk_raw_purif |    80 | 7.617 |
| pre_covid | z_jk_purif |    80 | 5.874 |
| pre_covid | z_bruto |    80 | 6.584 |

## 2. Leave-one-month-out

`swing_dn` é quanto o ξ_mp cai no pior mês descartado; `swing_up`, quanto sobe no melhor. `n_below10` conta quantos descartes individuais derrubam o ξ_mp abaixo de 10.

| scope | sample | instrument | xi_mp | xi_min | xi_median | xi_max | swing_dn | swing_up | n_below10 | n_below384 | n_drops |
|---|---|---|---|---|---|---|---|---|---|---|---|
| todos os meses | full | z_bruto | 4.255 | 3.112 | 4.253 | 4.778 | 1.144 | 0.522 |   149 |     7 |   149 |
| todos os meses | full | z_jk_bs_purif |  5.24 | 4.041 | 5.241 | 5.842 | 1.199 | 0.602 |   149 |     0 |   149 |
| todos os meses | full | z_jk_purif | 3.404 | 2.278 | 3.404 | 3.969 | 1.126 | 0.564 |   149 |   146 |   149 |
| todos os meses | full | z_jk_raw | 5.384 | 4.173 | 5.384 | 5.909 | 1.212 | 0.524 |   149 |     0 |   149 |
| todos os meses | full | z_jk_raw_purif | 5.285 | 4.086 | 5.287 | 5.793 |   1.2 | 0.507 |   149 |     0 |   149 |
| todos os meses | pre_covid | z_bruto | 6.584 | 4.233 | 6.593 | 9.785 | 2.351 | 3.201 |    80 |     0 |    80 |
| todos os meses | pre_covid | z_jk_bs_purif | 7.478 | 5.176 | 7.499 | 8.801 | 2.303 | 1.322 |    80 |     0 |    80 |
| todos os meses | pre_covid | z_jk_purif | 5.874 | 3.859 | 5.883 | 6.789 | 2.015 | 0.915 |    80 |     0 |    80 |
| todos os meses | pre_covid | z_jk_raw | 7.128 | 4.695 | 7.146 | 8.194 | 2.434 | 1.066 |    80 |     0 |    80 |
| todos os meses | pre_covid | z_jk_raw_purif | 7.617 | 5.116 | 7.641 | 8.615 | 2.501 | 0.999 |    80 |     0 |    80 |
| meses com z != 0 | full | z_bruto | 4.255 | 3.112 | 4.248 | 4.778 | 1.144 | 0.522 |    87 |     7 |    87 |
| meses com z != 0 | full | z_jk_bs_purif |  5.24 | 4.041 | 5.238 | 5.842 | 1.199 | 0.602 |    60 |     0 |    60 |
| meses com z != 0 | full | z_jk_purif | 3.404 | 2.278 | 3.404 | 3.969 | 1.126 | 0.564 |    63 |    60 |    63 |
| meses com z != 0 | full | z_jk_raw | 5.384 | 4.173 | 5.384 | 5.909 | 1.212 | 0.524 |    54 |     0 |    54 |
| meses com z != 0 | full | z_jk_raw_purif | 5.285 | 4.086 | 5.286 | 5.793 |   1.2 | 0.507 |    54 |     0 |    54 |
| meses com z != 0 | pre_covid | z_bruto | 6.584 | 4.233 | 6.568 | 9.785 | 2.351 | 3.201 |    46 |     0 |    46 |
| meses com z != 0 | pre_covid | z_jk_bs_purif | 7.478 | 5.176 | 7.514 | 8.801 | 2.303 | 1.322 |    29 |     0 |    29 |
| meses com z != 0 | pre_covid | z_jk_purif | 5.874 | 3.859 | 5.896 | 6.789 | 2.015 | 0.915 |    29 |     0 |    29 |
| meses com z != 0 | pre_covid | z_jk_raw | 7.128 | 4.695 | 7.145 | 8.194 | 2.434 | 1.066 |    25 |     0 |    25 |
| meses com z != 0 | pre_covid | z_jk_raw_purif | 7.617 | 5.116 | 7.636 | 8.615 | 2.501 | 0.999 |    25 |     0 |    25 |

### Meses mais influentes — instrumento de produção `z_jk_bs_purif`

`delta` = ξ_mp sem o mês − ξ_mp cheio. Negativo: o mês *sustenta* a força.

| sample | mes | xi_mp_sem_o_mes | delta |
|---|---|---|---|
| full | 2021-03 | 4.041 | -1.199 |
| full | 2024-12 | 4.054 | -1.187 |
| full | 2016-01 | 4.165 | -1.075 |
| full | 2017-01 |  4.54 |  -0.7 |
| full | 2018-05 | 4.591 | -0.649 |
| full | 2020-12 | 4.676 | -0.564 |
| full | 2020-05 | 4.714 | -0.526 |
| full | 2024-09 | 4.778 | -0.462 |
| full | 2016-12 | 5.732 | 0.492 |
| full | 2022-03 | 5.842 | 0.602 |
| pre_covid | 2016-01 | 5.176 | -2.303 |
| pre_covid | 2017-01 | 5.206 | -2.273 |
| pre_covid | 2017-07 | 5.883 | -1.595 |
| pre_covid | 2014-01 | 5.913 | -1.566 |
| pre_covid | 2014-02 | 5.979 | -1.499 |
| pre_covid | 2018-05 | 6.169 | -1.309 |
| pre_covid | 2016-05 | 6.509 | -0.969 |
| pre_covid | 2013-05 |   8.4 | 0.922 |
| pre_covid | 2016-12 | 8.422 | 0.944 |
| pre_covid | 2019-10 | 8.801 | 1.322 |

## 3. HAC — ξ_mp por defasagem de Newey-West

NW(0) é Eicker-White, a convenção das aplicações oficiais (`OilSVARIV.m:50`). O kernel de Bartlett para NW > 0 é a transcrição de `NW_hac_STATA.m`, validada em `script/validate_hac_kernel.R` contra a aplicação oficial de impostos (`TaxSVARIV.m`, NWlags = 8, diferença relativa 2,6e-10).

| sample | instrument | NW(0) | NW(1) | NW(2) | NW(3) | NW(4) | NW(5) | NW(6) |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_bs_purif |  5.24 |   5.2 |  5.34 |  5.53 |  5.82 |  6.36 |  6.85 |
| full | z_jk_raw |  5.38 |  5.26 |   5.4 |  5.58 |  5.85 |  6.36 |  6.85 |
| full | z_jk_raw_purif |  5.29 |  5.17 |   5.3 |  5.46 |  5.71 |  6.19 |  6.66 |
| full | z_jk_purif |   3.4 |  3.33 |  3.41 |  3.51 |  3.67 |  3.96 |  4.23 |
| full | z_bruto |  4.26 |  4.24 |  4.34 |  4.49 |  4.72 |  5.09 |  5.42 |
| pre_covid | z_jk_bs_purif |  7.48 |  7.44 |  7.73 |  7.92 |  8.25 |  8.85 |  8.98 |
| pre_covid | z_jk_raw |  7.13 |  7.16 |  7.37 |  7.54 |  7.85 |   8.4 |  8.56 |
| pre_covid | z_jk_raw_purif |  7.62 |  7.55 |  7.74 |  7.89 |  8.21 |  8.81 |  8.99 |
| pre_covid | z_jk_purif |  5.87 |  5.98 |  6.28 |  6.14 |  6.25 |  6.47 |  6.29 |
| pre_covid | z_bruto |  6.58 |  6.28 |  6.56 |  6.67 |     7 |  7.65 |  7.73 |

