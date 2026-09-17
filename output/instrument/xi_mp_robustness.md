# Robustez do ξ_mp — leave-one-month-out e HAC

Gerado por `script/xi_mp_robustness.R` em 2026-09-17.

Especificação de produção: r = 5, q = 5, p = 4, direção de normalização = `yield_6m`. 5 instrumentos × 2 amostras.

O DFM entra **uma vez por amostra** e fica fixo; só o momento Γ é recomputado. `c_mp` também vem do DFM, então o exercício isola a influência que passa pelo **momento**, não pela estimação de fatores.

Régua MOSW: ξ_mp ≥ 10 sustenta bandas convencionais; 3,84 < ξ_mp < 10 é
instrumento fraco com conjunto AR limitado; ξ_mp ≤ 3,84, conjunto AR
possivelmente ilimitado.

## 1. Baseline

| sample | instrument | n_obs | xi_mp |
|---|---|---|---|
| full | z_jk_bs_purif |   162 | 6.848 |
| full | z_jk_raw |   162 | 6.666 |
| full | z_jk_raw_purif |   162 | 6.651 |
| full | z_jk_purif |   162 | 4.982 |
| full | z_bruto |   162 | 6.678 |
| pre_covid | z_jk_bs_purif |    90 | 8.643 |
| pre_covid | z_jk_raw |    90 | 8.025 |
| pre_covid | z_jk_raw_purif |    90 | 8.313 |
| pre_covid | z_jk_purif |    90 | 5.823 |
| pre_covid | z_bruto |    90 | 6.665 |

## 2. Leave-one-month-out

`swing_dn` é quanto o ξ_mp cai no pior mês descartado; `swing_up`, quanto sobe no melhor. `n_below10` conta quantos descartes individuais derrubam o ξ_mp abaixo de 10.

| scope | sample | instrument | xi_mp | xi_min | xi_median | xi_max | swing_dn | swing_up | n_below10 | n_below384 | n_drops |
|---|---|---|---|---|---|---|---|---|---|---|---|
| todos os meses | full | z_bruto | 6.678 | 5.257 | 6.686 | 7.393 | 1.421 | 0.714 |   162 |     0 |   162 |
| todos os meses | full | z_jk_bs_purif | 6.848 | 5.482 | 6.858 | 7.599 | 1.366 | 0.751 |   162 |     0 |   162 |
| todos os meses | full | z_jk_purif | 4.982 | 3.726 | 4.979 | 5.668 | 1.256 | 0.687 |   162 |     1 |   162 |
| todos os meses | full | z_jk_raw | 6.666 | 5.278 | 6.681 | 7.377 | 1.388 | 0.711 |   162 |     0 |   162 |
| todos os meses | full | z_jk_raw_purif | 6.651 | 5.263 | 6.665 | 7.354 | 1.388 | 0.702 |   162 |     0 |   162 |
| todos os meses | pre_covid | z_bruto | 6.665 | 4.236 | 6.678 | 7.927 | 2.429 | 1.262 |    90 |     0 |    90 |
| todos os meses | pre_covid | z_jk_bs_purif | 8.643 | 6.181 | 8.653 | 10.51 | 2.462 | 1.865 |    89 |     0 |    90 |
| todos os meses | pre_covid | z_jk_purif | 5.823 | 3.876 | 5.829 | 7.312 | 1.947 | 1.489 |    90 |     0 |    90 |
| todos os meses | pre_covid | z_jk_raw | 8.025 | 5.623 | 8.033 | 9.713 | 2.401 | 1.689 |    90 |     0 |    90 |
| todos os meses | pre_covid | z_jk_raw_purif | 8.313 | 5.887 | 8.321 | 9.991 | 2.426 | 1.678 |    90 |     0 |    90 |
| meses com z != 0 | full | z_bruto | 6.678 | 5.257 | 6.686 | 7.393 | 1.421 | 0.714 |    95 |     0 |    95 |
| meses com z != 0 | full | z_jk_bs_purif | 6.848 | 5.482 | 6.855 | 7.599 | 1.366 | 0.751 |    65 |     0 |    65 |
| meses com z != 0 | full | z_jk_purif | 4.982 | 3.726 | 4.979 | 5.668 | 1.256 | 0.687 |    67 |     1 |    67 |
| meses com z != 0 | full | z_jk_raw | 6.666 | 5.278 | 6.679 | 7.377 | 1.388 | 0.711 |    57 |     0 |    57 |
| meses com z != 0 | full | z_jk_raw_purif | 6.651 | 5.263 | 6.665 | 7.354 | 1.388 | 0.702 |    57 |     0 |    57 |
| meses com z != 0 | pre_covid | z_bruto | 6.665 | 4.236 | 6.666 | 7.927 | 2.429 | 1.262 |    52 |     0 |    52 |
| meses com z != 0 | pre_covid | z_jk_bs_purif | 8.643 | 6.181 | 8.602 | 10.51 | 2.462 | 1.865 |    33 |     0 |    34 |
| meses com z != 0 | pre_covid | z_jk_purif | 5.823 | 3.876 | 5.794 | 7.312 | 1.947 | 1.489 |    32 |     0 |    32 |
| meses com z != 0 | pre_covid | z_jk_raw | 8.025 | 5.623 | 8.002 | 9.713 | 2.401 | 1.689 |    28 |     0 |    28 |
| meses com z != 0 | pre_covid | z_jk_raw_purif | 8.313 | 5.887 | 8.294 | 9.991 | 2.426 | 1.678 |    28 |     0 |    28 |

### Meses mais influentes — instrumento de produção `z_jk_bs_purif`

`delta` = ξ_mp sem o mês − ξ_mp cheio. Negativo: o mês *sustenta* a força.

| sample | mes | xi_mp_sem_o_mes | delta |
|---|---|---|---|
| full | 2016-01 | 5.482 | -1.366 |
| full | 2024-12 | 5.639 | -1.209 |
| full | 2017-01 |  5.82 | -1.028 |
| full | 2018-05 |  6.07 | -0.778 |
| full | 2013-04 | 6.099 | -0.749 |
| full | 2021-03 | 6.163 | -0.685 |
| full | 2014-02 | 6.217 | -0.631 |
| full | 2017-07 |  6.35 | -0.498 |
| full | 2022-03 | 7.577 | 0.729 |
| full | 2016-12 | 7.599 | 0.751 |
| pre_covid | 2016-01 | 6.181 | -2.462 |
| pre_covid | 2017-01 | 6.436 | -2.208 |
| pre_covid | 2018-05 | 7.085 | -1.559 |
| pre_covid | 2017-07 | 7.177 | -1.466 |
| pre_covid | 2014-01 | 7.183 | -1.461 |
| pre_covid | 2014-02 | 7.636 | -1.008 |
| pre_covid | 2019-12 |  7.89 | -0.753 |
| pre_covid | 2013-08 | 7.895 | -0.749 |
| pre_covid | 2013-04 | 7.906 | -0.737 |
| pre_covid | 2016-12 | 10.51 | 1.865 |

## 3. HAC — ξ_mp por defasagem de Newey-West

NW(0) é Eicker-White, a convenção das aplicações oficiais (`OilSVARIV.m:50`). O kernel de Bartlett para NW > 0 é a transcrição de `NW_hac_STATA.m`, validada em `script/validate_hac_kernel.R` contra a aplicação oficial de impostos (`TaxSVARIV.m`, NWlags = 8, diferença relativa 2,6e-10).

| sample | instrument | NW(0) | NW(1) | NW(2) | NW(3) | NW(4) | NW(5) | NW(6) |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_bs_purif |  6.86 |  6.93 |  7.09 |  7.31 |  7.58 |  8.18 |   8.7 |
| full | z_jk_raw |  6.68 |  6.63 |  6.75 |  6.93 |  7.23 |   7.8 |  8.35 |
| full | z_jk_raw_purif |  6.66 |  6.62 |  6.73 |  6.89 |  7.17 |  7.71 |  8.25 |
| full | z_jk_purif |  4.98 |  4.92 |  4.96 |  5.12 |  5.39 |  5.88 |  6.32 |
| full | z_bruto |  6.69 |   6.8 |  6.98 |  7.23 |  7.53 |  8.07 |  8.55 |
| pre_covid | z_jk_bs_purif |  8.64 |  9.31 |  9.62 | 10.06 | 10.31 | 10.82 | 11.09 |
| pre_covid | z_jk_raw |  8.02 |  8.64 |  9.04 |  9.46 |  9.77 | 10.44 |  10.9 |
| pre_covid | z_jk_raw_purif |  8.31 |  8.86 |  9.21 |   9.6 |  9.93 | 10.61 | 11.07 |
| pre_covid | z_jk_purif |  5.82 |  6.28 |  6.54 |  6.62 |  6.81 |  7.14 |  7.06 |
| pre_covid | z_bruto |  6.66 |  6.88 |  7.14 |  7.48 |  7.69 |  8.06 |  8.09 |

