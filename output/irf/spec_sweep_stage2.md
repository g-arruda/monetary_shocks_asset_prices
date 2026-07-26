# Varredura de especificações IRF — Etapa 2 (bootstrap nos vencedores)

Gerado por `script/irf_spec_stage2.R` em 2026-07-24.

Wild bootstrap (Gonçalves-Kilian) com nboot = 800, seed = 123, bandas 68/90.
mp_var fixada em `yield_6m` (+50bp no impacto) para comparabilidade entre células.

## Células selecionadas

| sample | r | q | instrument | mp_var | tag |
|---|---|---|---|---|---|
| full |     6 |     5 | z_jk_purif | yield_6m | full_r6q5_z_jk_purif |
| full |     7 |     6 | z_jk_purif | yield_6m | full_r7q6_z_jk_purif |
| full |     6 |     5 | z_jk | yield_6m | full_r6q5_z_jk |
| full |     7 |     6 | z_jk_bs_purif | yield_6m | full_r7q6_z_jk_bs_purif |

## full_r6q5_z_jk_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.01082 | 0.008359 | 0.0186 | TRUE |
| yield_5y | 0.01253 | 0.009564 | 0.02538 | TRUE |
| cambio_usd | 0.2321 | 0.1504 | 0.558 | TRUE |
| asset_ibov | -8.923 | -24.94 | -6.177 | TRUE |
| cds_5y |  5495 |  3979 | 1.388e+04 | TRUE |
| embi_perc | 0.4501 | 0.3101 | 1.242 | TRUE |
| price_ipca | 0.1255 | -0.183 | 0.388 | FALSE |
| spread_icc_juridica | -0.0206 | -0.07086 | 0.01185 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 3 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## full_r7q6_z_jk_purif

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.01086 | 0.008252 | 0.01817 | TRUE |
| yield_5y | 0.01266 | 0.009323 | 0.02354 | TRUE |
| cambio_usd | 0.2481 | 0.1468 | 0.5539 | TRUE |
| asset_ibov | -8.702 | -22.65 | -4.854 | TRUE |
| cds_5y |  5597 |  3586 | 1.264e+04 | TRUE |
| embi_perc | 0.4515 | 0.2747 | 1.134 | TRUE |
| price_ipca | 0.01601 | -0.2856 | 0.3066 | FALSE |
| spread_icc_juridica | -0.01412 | -0.05377 | 0.02446 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 3 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

## full_r6q5_z_jk

| resposta | h0 | lo90 | hi90 | ci90_exclui_zero |
|---|---|---|---|---|
| yield_6m | 0.005 | 0.005 | 0.005 | TRUE |
| yield_2y | 0.0105 | 0.008115 | 0.01757 | TRUE |
| yield_5y | 0.01192 | 0.009067 | 0.02292 | TRUE |
| cambio_usd | 0.2223 | 0.1465 | 0.4925 | TRUE |
| asset_ibov | -7.541 | -21.18 | -5.118 | TRUE |
| cds_5y |  5041 |  3617 | 1.23e+04 | TRUE |
| embi_perc | 0.4036 | 0.277 | 1.078 | TRUE |
| price_ipca | 0.1146 | -0.1874 | 0.3684 | FALSE |
| spread_icc_juridica | -0.01763 | -0.06555 | 0.01568 | FALSE |

Variáveis hard-tier com CI90 excluindo zero no impacto: 3 de 3 (yield_2y, yield_5y, asset_ibov; yield_6m é mecânica pela normalização).

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

