# Varredura de especificações IRF — Etapa 2 (bootstrap nos vencedores)

Gerado por `script/irf_spec_stage2.R` em 2026-08-12.

Wild bootstrap (Gonçalves-Kilian) com nboot = 800, seed = 123, bandas 68/90.
mp_var fixada em `yield_6m` (+50bp no impacto) para comparabilidade entre células.

## Células selecionadas

| sample | r | q | instrument | mp_var | tag |
|---|---|---|---|---|---|
| pre_covid |     7 |     6 | z_bruto_purif | yield_6m | pre_covid_r7q6_z_bruto_purif |
| pre_covid |     7 |     6 | z_bruto | yield_6m | pre_covid_r7q6_z_bruto |
| pre_covid |     7 |     6 | z_bs_purif | yield_6m | pre_covid_r7q6_z_bs_purif |
| pre_covid |     7 |     6 | z_jk_purif | yield_6m | pre_covid_r7q6_z_jk_purif |
| pre_covid |     7 |     6 | z_jk | yield_6m | pre_covid_r7q6_z_jk |
| full |     7 |     6 | z_jk_bs_purif | yield_6m | full_r7q6_z_jk_bs_purif |

## pre_covid_r7q6_z_bruto_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.00425 | -0.005352 | 0.01129 | FALSE |
| yield_5y | 0.002457 | -0.01222 | 0.01358 | FALSE |
| cambio_usd | -0.01615 | -0.3577 | 0.2655 | FALSE |
| asset_ibov | -2.489 | -18.87 | 10.61 | FALSE |
| cds_5y | 12.75 | -59.4 | 69.67 | FALSE |
| embi_perc | 0.199 | -0.4222 | 0.6875 | FALSE |
| price_ipca | -0.01459 | -0.6116 | 0.5969 | FALSE |
| spread_icc_juridica | -0.01256 | -0.1176 | 0.1154 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_bruto

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.004228 | -0.005929 | 0.01075 | FALSE |
| yield_5y | 0.002407 | -0.01406 | 0.01307 | FALSE |
| cambio_usd | -0.01767 | -0.3955 | 0.2572 | FALSE |
| asset_ibov | -2.514 | -19.37 | 12.21 | FALSE |
| cds_5y | 12.44 | -67.9 | 70.01 | FALSE |
| embi_perc | 0.1976 | -0.4302 | 0.6759 | FALSE |
| price_ipca | -0.01315 | -0.63 | 0.5791 | FALSE |
| spread_icc_juridica | -0.01428 | -0.1238 | 0.117 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_bs_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.004097 | -0.007822 | 0.01087 | FALSE |
| yield_5y | 0.002202 | -0.01727 | 0.01293 | FALSE |
| cambio_usd | -0.02564 | -0.4598 | 0.265 | FALSE |
| asset_ibov | -2.769 | -20.89 | 13.09 | FALSE |
| cds_5y |  11.6 | -82.54 | 68.61 | FALSE |
| embi_perc | 0.1941 | -0.5529 | 0.6713 | FALSE |
| price_ipca | 0.002367 | -0.6244 | 0.665 | FALSE |
| spread_icc_juridica | -0.01316 | -0.1204 | 0.137 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_jk_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.006374 | 0.0003268 | 0.01327 | TRUE |
| yield_5y | 0.006307 | -0.003591 | 0.0177 | FALSE |
| cambio_usd | 0.07278 | -0.1969 | 0.3394 | FALSE |
| asset_ibov | -9.602 | -36.04 | -0.4633 | TRUE |
| cds_5y | 32.89 | -18.53 |    86 | FALSE |
| embi_perc | 0.401 | -0.009989 | 0.907 | FALSE |
| price_ipca | 0.08929 | -0.3722 | 0.7393 | FALSE |
| spread_icc_juridica | -0.0182 | -0.155 | 0.06782 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 2 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_jk

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.006366 | 0.0001838 | 0.01345 | TRUE |
| yield_5y | 0.006286 | -0.003044 | 0.01826 | FALSE |
| cambio_usd | 0.07458 | -0.2068 | 0.3428 | FALSE |
| asset_ibov | -9.694 | -37.12 | -0.5135 | TRUE |
| cds_5y | 32.77 | -20.49 | 84.65 | FALSE |
| embi_perc | 0.4032 | -0.02793 | 0.9181 | FALSE |
| price_ipca | 0.07913 | -0.408 | 0.6871 | FALSE |
| spread_icc_juridica | -0.0188 | -0.141 | 0.06889 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 2 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## full_r7q6_z_jk_bs_purif (baseline atual)

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.0108 | 0.008739 | 0.01563 | TRUE |
| yield_5y | 0.0117 | 0.008587 | 0.01973 | TRUE |
| cambio_usd | 0.2281 | 0.116 | 0.535 | TRUE |
| asset_ibov | -2.407 | -13.08 |  4.78 | FALSE |
| cds_5y | 43.44 |  22.5 | 101.3 | TRUE |
| embi_perc | 0.3204 | 0.1205 | 0.8341 | TRUE |
| price_ipca | -0.1678 | -0.8106 | 0.2217 | FALSE |
| spread_icc_juridica | -0.01987 | -0.07526 | 0.03662 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 2 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

