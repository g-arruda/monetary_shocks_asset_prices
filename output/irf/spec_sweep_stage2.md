# Varredura de especificações IRF — Etapa 2 (bootstrap nos vencedores)

Gerado por `script/irf_spec_stage2.R` em 2026-07-26.

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
| yield_2y | 0.003975 | -0.005867 | 0.01038 | FALSE |
| yield_5y | 0.002051 | -0.01304 | 0.01185 | FALSE |
| cambio_usd | -0.01853 | -0.3945 | 0.2352 | FALSE |
| asset_ibov | -2.055 | -19.46 | 11.44 | FALSE |
| cds_5y |  1122 | -6360 |  6681 | FALSE |
| embi_perc | 0.1816 | -0.4122 | 0.694 | FALSE |
| price_ipca | -0.01397 | -0.6276 | 0.7114 | FALSE |
| spread_icc_juridica | -0.01059 | -0.1222 | 0.1077 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_bruto

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.003957 | -0.007683 | 0.01007 | FALSE |
| yield_5y | 0.002006 | -0.01529 | 0.01143 | FALSE |
| cambio_usd | -0.01991 | -0.541 | 0.2189 | FALSE |
| asset_ibov | -2.068 | -20.3 | 12.65 | FALSE |
| cds_5y |  1095 | -8136 |  6271 | FALSE |
| embi_perc | 0.1803 | -0.5089 | 0.6382 | FALSE |
| price_ipca | -0.01254 | -0.655 | 0.6864 | FALSE |
| spread_icc_juridica | -0.0122 | -0.1232 | 0.1185 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_bs_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.003795 | -0.008606 | 0.01076 | FALSE |
| yield_5y | 0.001753 | -0.01694 | 0.01238 | FALSE |
| cambio_usd | -0.02861 | -0.4682 | 0.2528 | FALSE |
| asset_ibov | -2.284 | -20.38 | 13.78 | FALSE |
| cds_5y | 986.8 | -7892 |  6666 | FALSE |
| embi_perc | 0.1749 | -0.5521 | 0.6816 | FALSE |
| price_ipca | 0.001788 | -0.7015 | 0.8128 | FALSE |
| spread_icc_juridica | -0.01104 | -0.1286 | 0.1433 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 0 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_jk_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.005945 | -0.001028 | 0.01251 | FALSE |
| yield_5y | 0.005701 | -0.005199 | 0.01619 | FALSE |
| cambio_usd | 0.06576 | -0.212 | 0.3109 | FALSE |
| asset_ibov | -9.133 | -36.17 | -0.0691 | TRUE |
| cds_5y |  3030 | -2398 |  7876 | FALSE |
| embi_perc | 0.3743 | -0.114 | 0.8951 | FALSE |
| price_ipca | 0.0828 | -0.3565 | 0.7708 | FALSE |
| spread_icc_juridica | -0.0164 | -0.1641 | 0.06839 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 1 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## pre_covid_r7q6_z_jk

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.005939 | -0.0009677 | 0.01264 | FALSE |
| yield_5y | 0.005684 | -0.004096 | 0.01678 | FALSE |
| cambio_usd | 0.0678 | -0.2116 | 0.3047 | FALSE |
| asset_ibov | -9.214 | -36.89 | -0.325 | TRUE |
| cds_5y |  3024 | -2450 |  8222 | FALSE |
| embi_perc | 0.3763 | -0.0877 | 0.9692 | FALSE |
| price_ipca | 0.07263 | -0.3874 | 0.7189 | FALSE |
| spread_icc_juridica | -0.01682 | -0.1612 | 0.06863 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 1 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## full_r7q6_z_jk_bs_purif (baseline atual)

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.009164 | 0.00713 | 0.01312 | TRUE |
| yield_5y | 0.009274 | 0.006864 | 0.01499 | TRUE |
| cambio_usd | 0.1498 | 0.07881 | 0.2971 | TRUE |
| asset_ibov | -1.673 | -7.771 | 1.759 | FALSE |
| cds_5y |  2907 |  1652 |  6251 | TRUE |
| embi_perc | 0.1995 | 0.07767 | 0.5089 | TRUE |
| price_ipca | -0.07025 | -0.3708 | 0.1428 | FALSE |
| spread_icc_juridica | -0.01618 | -0.04707 | 0.01648 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 2 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

