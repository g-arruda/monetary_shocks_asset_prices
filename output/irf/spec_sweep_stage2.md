# Varredura de especificações IRF — Etapa 2 (bootstrap nos vencedores)

Gerado por `script/irf_spec_stage2.R` em 2026-08-17.

Wild bootstrap (Gonçalves-Kilian) com nboot = 800, seed = 123, bandas 68/90.
mp_var fixada em `yield_6m` (+50bp no impacto) para comparabilidade entre células.

## Células selecionadas

| sample | r | q | instrument | mp_var | tag |
|---|---|---|---|---|---|
| pre_covid |     7 |     6 | z_bruto_purif | yield_6m | pre_covid_r7q6_z_bruto_purif |
| pre_covid |     7 |     6 | z_bruto | yield_6m | pre_covid_r7q6_z_bruto |
| pre_covid |     7 |     6 | z_bs_purif | yield_6m | pre_covid_r7q6_z_bs_purif |
| pre_covid |     7 |     6 | z_jk_bs_purif | yield_6m | pre_covid_r7q6_z_jk_bs_purif |
| pre_covid |     6 |     5 | z_bruto_purif | yield_6m | pre_covid_r6q5_z_bruto_purif |
| full |     5 |     5 | z_jk_bs_purif | yield_6m | full_r5q5_z_jk_bs_purif |

## pre_covid_r7q6_z_bruto_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.005347 | -0.00117 | 0.01009 | FALSE |
| yield_5y | 0.003654 | -0.007397 | 0.01082 | FALSE |
| cambio_usd | -0.02078 | -0.3286 | 0.1623 | FALSE |
| asset_ibov | -2.754 | -15.35 | 8.849 | FALSE |
| cds_5y | 17.72 | -40.38 | 54.27 | FALSE |
| embi_perc | 0.2301 | -0.2175 | 0.5541 | FALSE |
| price_ipca | -0.0735 | -0.6128 | 0.3284 | FALSE |
| spread_icc_juridica | -0.01082 | -0.09055 | 0.06523 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_bruto

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.005353 | -0.0009189 | 0.0101 | FALSE |
| yield_5y | 0.00365 | -0.007349 | 0.01112 | FALSE |
| cambio_usd | -0.02056 | -0.3239 | 0.1654 | FALSE |
| asset_ibov | -2.774 | -15.46 |   8.7 | FALSE |
| cds_5y |  17.7 | -40.91 | 55.68 | FALSE |
| embi_perc | 0.2306 | -0.2397 | 0.5568 | FALSE |
| price_ipca | -0.07342 | -0.632 | 0.3148 | FALSE |
| spread_icc_juridica | -0.01192 | -0.09488 | 0.06115 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_bs_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.005237 | -0.001699 | 0.01028 | FALSE |
| yield_5y | 0.00344 | -0.01028 | 0.01114 | FALSE |
| cambio_usd | -0.02881 | -0.4239 | 0.167 | FALSE |
| asset_ibov | -2.822 | -17.57 | 10.69 | FALSE |
| cds_5y |  16.7 | -52.35 | 56.62 | FALSE |
| embi_perc | 0.2243 | -0.3413 | 0.5715 | FALSE |
| price_ipca | -0.06214 | -0.6728 | 0.4168 | FALSE |
| spread_icc_juridica | -0.01165 | -0.1056 | 0.07052 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_jk_bs_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.007098 | 0.001175 | 0.01309 | TRUE |
| yield_5y | 0.006828 | -0.003215 | 0.01739 | FALSE |
| cambio_usd | 0.08013 | -0.1906 | 0.3618 | FALSE |
| asset_ibov | -5.467 | -24.01 | 8.326 | FALSE |
| cds_5y | 34.75 | -17.93 | 89.52 | FALSE |
| embi_perc | 0.3699 | -0.06084 | 0.8723 | FALSE |
| price_ipca | -0.1065 | -0.7852 | 0.3318 | FALSE |
| spread_icc_juridica | -0.01455 | -0.1271 | 0.0762 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 1 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r6q5_z_bruto_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.006047 | 0.001574 | 0.009741 | TRUE |
| yield_5y | 0.005506 | -0.001176 | 0.01253 | FALSE |
| cambio_usd | -0.01241 | -0.2116 | 0.1482 | FALSE |
| asset_ibov | -8.162 | -18.56 | 0.8434 | FALSE |
| cds_5y | 26.92 | -10.49 | 64.28 | FALSE |
| embi_perc | 0.2975 | -0.002729 | 0.6336 | FALSE |
| price_ipca | -0.1026 | -0.3783 | 0.3477 | FALSE |
| spread_icc_juridica | 0.002515 | -0.05403 | 0.06329 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 1 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## full_r5q5_z_jk_bs_purif (baseline atual)

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.00743 | 0.006076 | 0.009482 | TRUE |
| yield_5y | 0.007761 | 0.005791 | 0.01113 | TRUE |
| cambio_usd | 0.1579 | 0.09207 | 0.2493 | TRUE |
| asset_ibov | -1.723 | -6.91 | 0.7747 | FALSE |
| cds_5y | 32.54 | 22.15 | 53.84 | TRUE |
| embi_perc | 0.262 | 0.1719 | 0.473 | TRUE |
| price_ipca | -0.06179 | -0.2758 | 0.117 | FALSE |
| spread_icc_juridica | -0.01537 | -0.04917 | 0.006015 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 2 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

