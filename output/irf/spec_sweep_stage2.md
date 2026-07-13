# Varredura de especificações IRF — Etapa 2 (bootstrap nos vencedores)

Gerado por `script/irf_spec_stage2.R` em 2026-07-11.

Wild bootstrap (Gonçalves-Kilian) com nboot = 800, seed = 123, bandas 68/90.
mp_var fixada em `yield_6m` (+50bp no impacto) para comparabilidade entre células.

## Células selecionadas

| sample | r | q | instrument | mp_var | tag |
|---|---|---|---|---|---|
| pre_covid |     6 |     5 | z_jk_purif | yield_6m | pre_covid_r6q5_z_jk_purif |
| pre_covid |     6 |     5 | z_jk | yield_6m | pre_covid_r6q5_z_jk |
| full |     8 |     8 | z_jk_purif | yield_6m | full_r8q8_z_jk_purif |
| pre_covid |     6 |     5 | z_het_jk_3var | yield_6m | pre_covid_r6q5_z_het_jk_3var |
| pre_covid |     6 |     5 | z_het_3var | yield_6m | pre_covid_r6q5_z_het_3var |
| full |     7 |     6 | z_jk_purif | yield_6m | full_r7q6_z_jk_purif |

## pre_covid_r6q5_z_jk_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.007224 | 0.003068 | 0.01145 | TRUE |
| yield_5y | 0.008492 | 0.002943 | 0.01626 | TRUE |
| cambio_usd | 0.06817 | -0.0827 | 0.2221 | FALSE |
| asset_ibov | -0.1402 | -0.2667 | -0.06388 | TRUE |
| cds_5y |  4106 |  1107 |  7215 | TRUE |
| embi_perc | 0.4178 | 0.1462 | 0.7284 | TRUE |
| price_ipca | -0.08957 | -0.4305 | 0.2905 | FALSE |
| spread_icc_juridica | -0.03222 | -0.1342 | 0.01126 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 3 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r6q5_z_jk

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.00731 | 0.003257 | 0.01178 | TRUE |
| yield_5y | 0.008648 | 0.00307 | 0.01646 | TRUE |
| cambio_usd | 0.07044 | -0.07826 | 0.223 | FALSE |
| asset_ibov | -0.1423 | -0.272 | -0.06395 | TRUE |
| cds_5y |  4149 |  1266 |  7376 | TRUE |
| embi_perc | 0.4211 | 0.1484 | 0.7542 | TRUE |
| price_ipca | -0.09407 | -0.4366 | 0.2883 | FALSE |
| spread_icc_juridica | -0.03401 | -0.1326 | 0.009137 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 3 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## full_r8q8_z_jk_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.01024 | 0.00756 | 0.01716 | TRUE |
| yield_5y | 0.01202 | 0.008412 | 0.02318 | TRUE |
| cambio_usd |  0.24 | 0.1252 | 0.5608 | TRUE |
| asset_ibov | -0.09154 | -0.2592 | -0.04636 | TRUE |
| cds_5y |  5614 |  3429 | 1.347e+04 | TRUE |
| embi_perc | 0.4615 | 0.262 | 1.232 | TRUE |
| price_ipca | 0.01999 | -0.3228 | 0.3572 | FALSE |
| spread_icc_juridica | -0.01083 | -0.05515 | 0.03551 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 3 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r6q5_z_het_jk_3var

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.006531 | -0.001682 | 0.01292 | FALSE |
| yield_5y | 0.006968 | -0.004472 | 0.0177 | FALSE |
| cambio_usd | 0.05569 | -0.1771 | 0.2866 | FALSE |
| asset_ibov | -0.09863 | -0.2556 | 0.02368 | FALSE |
| cds_5y |  3284 | -2703 |  8191 | FALSE |
| embi_perc | 0.3147 | -0.141 | 0.6887 | FALSE |
| price_ipca | -0.3785 | -1.135 | 0.1144 | FALSE |
| spread_icc_juridica | -0.02797 | -0.1968 | 0.03815 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r6q5_z_het_3var

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.003318 | -0.01214 | 0.01086 | FALSE |
| yield_5y | 0.001693 | -0.02138 | 0.01493 | FALSE |
| cambio_usd | -0.08613 | -0.7045 | 0.3232 | FALSE |
| asset_ibov | -0.07629 | -0.3246 | 0.09651 | FALSE |
| cds_5y | 687.1 | -1.155e+04 |  6716 | FALSE |
| embi_perc | 0.1222 | -0.8703 | 0.672 | FALSE |
| price_ipca | -0.4752 | -1.534 | 0.3075 | FALSE |
| spread_icc_juridica | -0.01449 | -0.2513 | 0.08325 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## full_r7q6_z_jk_purif (baseline atual)

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.01067 | 0.008133 | 0.01833 | TRUE |
| yield_5y | 0.01253 | 0.009049 | 0.02418 | TRUE |
| cambio_usd | 0.2506 | 0.1409 | 0.5891 | TRUE |
| asset_ibov | -0.09636 | -0.2695 | -0.04988 | TRUE |
| cds_5y |  5720 |  3546 | 1.394e+04 | TRUE |
| embi_perc | 0.4691 | 0.2628 | 1.244 | TRUE |
| price_ipca | 0.005943 | -0.3401 | 0.3256 | FALSE |
| spread_icc_juridica | -0.02264 | -0.06881 | 0.0147 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 3 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

