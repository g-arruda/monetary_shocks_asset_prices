# Varredura de especificações IRF — Etapa 2 (bootstrap nos vencedores)

Gerado por `script/irf_spec_stage2.R` em 2026-07-15.

Wild bootstrap (Gonçalves-Kilian) com nboot = 800, seed = 123, bandas 68/90.
mp_var fixada em `yield_6m` (+50bp no impacto) para comparabilidade entre células.

## Células selecionadas

| sample | r | q | instrument | mp_var | tag |
|---|---|---|---|---|---|
| pre_covid |     6 |     5 | z_jk_purif | yield_6m | pre_covid_r6q5_z_jk_purif |
| pre_covid |     6 |     5 | z_jk | yield_6m | pre_covid_r6q5_z_jk |
| pre_covid |     6 |     5 | z_jk_raw_purif | yield_6m | pre_covid_r6q5_z_jk_raw_purif |
| full |     8 |     8 | z_jk_purif | yield_6m | full_r8q8_z_jk_purif |
| pre_covid |     6 |     5 | z_jk_bs_purif | yield_6m | pre_covid_r6q5_z_jk_bs_purif |
| full |     6 |     5 | z_jk_bs_purif | yield_6m | full_r6q5_z_jk_bs_purif |

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

## pre_covid_r6q5_z_jk_raw_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.007233 | 0.001694 | 0.01316 | TRUE |
| yield_5y | 0.008137 | 0.000228 | 0.01769 | TRUE |
| cambio_usd | 0.08179 | -0.1096 | 0.2863 | FALSE |
| asset_ibov | -0.1175 | -0.2771 | -0.02014 | TRUE |
| cds_5y |  3962 | -139.8 |  8480 | FALSE |
| embi_perc | 0.3844 | 0.02215 | 0.783 | TRUE |
| price_ipca | -0.2625 | -0.8774 | 0.1512 | FALSE |
| spread_icc_juridica | -0.03438 | -0.1718 | 0.02508 | FALSE |

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

## pre_covid_r6q5_z_jk_bs_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.00732 | 0.001866 | 0.01336 | TRUE |
| yield_5y | 0.008255 | 0.0006378 | 0.0182 | TRUE |
| cambio_usd | 0.08995 | -0.08638 | 0.2914 | FALSE |
| asset_ibov | -0.1124 | -0.2794 | -0.0256 | TRUE |
| cds_5y |  4083 | 327.8 |  8535 | TRUE |
| embi_perc | 0.3905 | 0.06032 | 0.807 | TRUE |
| price_ipca | -0.2532 | -0.8541 | 0.1301 | FALSE |
| spread_icc_juridica | -0.03038 | -0.1748 | 0.02457 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 3 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## full_r6q5_z_jk_bs_purif (baseline atual)

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.008446 | 0.006708 | 0.01358 | TRUE |
| yield_5y | 0.008754 | 0.006691 | 0.0163 | TRUE |
| cambio_usd | 0.1852 | 0.1131 | 0.3966 | TRUE |
| asset_ibov | -0.01114 | -0.1019 | 0.02174 | FALSE |
| cds_5y |  3401 |  2248 |  8085 | TRUE |
| embi_perc | 0.2505 | 0.1506 | 0.6904 | TRUE |
| price_ipca | 0.09794 | -0.2257 | 0.3413 | FALSE |
| spread_icc_juridica | -0.02412 | -0.06475 | 0.009721 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 2 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

