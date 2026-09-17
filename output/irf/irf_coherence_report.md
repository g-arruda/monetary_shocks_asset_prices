# Coerência ponto a ponto das IRFs — especificação de produção

Gerado por `script/irf_coherence_check.R` em 2026-09-17.

> **Arquivo gerado — sobrescrito por inteiro a cada rodada.** Não escreva
> prosa aqui: ela se perde no próximo run. A leitura interpretativa vive em
> [`irf_coherence_leitura.md`](irf_coherence_leitura.md), que nenhum script toca.

Especificação: `z_jk_bs_purif` x `yield_6m`, r=5, q=5, p=4, full sample, choque +50bp, conjuntos Anderson--Rubin por inversão de teste, NW(0), ξ_mp = 6.8480 na direção de normalização, níveis 68/90, h=0..48.

Topologia dos conjuntos: interval 5634, singleton 1 a 68%, interval 5634, singleton 1 a 90%. O coeficiente de λ² é `T·den² − κ·d0'W₂d0`, logo o conjunto é limitado em todos os horizontes se e somente se ξ_mp > κ.

## Método

Para cada variável, cada horizonte h é checado quanto a sinal e significância
(o conjunto de confiança exclui zero, a 68% e a 90%) contra a janela teórica
[w_lo, w_hi] definida em
`R/identification/irf_coherence.R::coherence_var_table()`. Vereditos:
`coerente_forte` (≥80% da janela com sinal certo + significância CI68),
`coerente` (≥80% sem significância), `parcial` (50-80%, sem violação
significativa), `incoerente` (<50% ou sinal errado com CI90 excluindo 0),
`soft_*` (canal registrado — dominância fiscal admissível), `ambigua`
(sem prior forte), `placebo_ok/viola` (externas: CI90 deve conter 0 em ≥90% de h0-h24).

## Contagem de vereditos

| tier | verdict | n |
|---|---|---|
| ambiguous | ambigua |    14 |
| placebo | placebo_ok |     3 |
| scored | coerente_forte |    25 |
| scored | incoerente |     6 |
| scored | parcial |     6 |
| soft | soft_depreciacao_fiscal_dom |     2 |
| soft | soft_risco_abre_fiscal_dom |     2 |

## Violações (incoerente / placebo_viola / sinal errado significativo)

| group | var | verdict | share_correct | wrong_sig90 | h0 | h12 | h24 |
|---|---|---|---|---|---|---|---|
| acoes | asset_ibov | incoerente | 0.2857 | TRUE | -1.502 | 1.816 | -0.8452 |
| acoes | asset_idiv | incoerente | 0.2857 | TRUE | -1.833 | 1.527 | -0.9923 |
| acoes | asset_imob | incoerente | 0.4286 | FALSE | -2.506 | 1.481 | -1.011 |
| risco_cambio_soft | cambio_usd | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1294 | 0.005148 | -0.08027 |
| risco_cambio_soft | cambio_eur | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1083 | -0.01297 | -0.05876 |
| risco_cambio_soft | embi_perc | soft_risco_abre_fiscal_dom |     0 | TRUE | 0.2507 | 0.03264 | -0.1231 |
| risco_cambio_soft | cds_5y | soft_risco_abre_fiscal_dom |     0 | TRUE | 30.49 | 4.714 | -16.42 |
| atividade | pib | incoerente | 0.4091 | FALSE | 0.1621 | 0.0903 | -0.1655 |
| trabalho | trab_tx_desemprego | incoerente | 0.6452 | TRUE | -0.1222 | -0.09751 | 0.1319 |
| trabalho | trab_pop_ocupada | incoerente | 0.5806 | TRUE | 297.7 |   295 | -218.1 |

## Trajetórias por grupo (unidades nativas; tcode aplicado)

### curva_juros

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| yield_3m | 0.004015 | 0.006007 | 0.005517 | 0.002024 | -0.004879 | -0.007859 | -0.007416 |     1 | coerente_forte |
| yield_6m | 0.005 | 0.007403 | 0.006537 | 0.001966 | -0.006314 | -0.009688 | -0.008993 |     1 | coerente_forte |
| yield_1y | 0.006119 | 0.008841 | 0.007473 | 0.00172 | -0.007812 | -0.01145 | -0.01045 |     1 | coerente_forte |
| yield_2y | 0.007009 | 0.009654 | 0.007799 | 0.001353 | -0.008433 | -0.01194 | -0.01077 |     1 | coerente_forte |
| yield_5y | 0.00729 | 0.009222 | 0.007109 | 0.001063 | -0.007275 | -0.01012 | -0.009097 |     1 | coerente_forte |
| yield_10y | 0.006636 | 0.008222 | 0.006281 | 0.0009085 | -0.006346 | -0.00879 | -0.007905 |     1 | coerente_forte |
| juros_selic | 0.2717 | 0.4115 | 0.4051 | 0.1884 | -0.3166 | -0.5524 | -0.5335 |     1 | coerente_forte |

### acoes

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | -1.502 | 0.8818 | 1.936 | 1.816 | -0.8452 | -2.799 | -3.262 | 0.2857 | incoerente |
| asset_smll | -2.394 | -0.1323 | 1.206 | 1.596 | -0.5108 | -2.245 | -2.72 | 0.5714 | parcial |
| asset_idiv | -1.833 | 0.4889 | 1.577 | 1.527 | -0.9923 | -2.789 | -3.139 | 0.2857 | incoerente |
| asset_imob | -2.506 | 0.05436 | 1.365 | 1.481 | -1.011 | -2.861 | -3.26 | 0.4286 | incoerente |
| asset_ifix | -1.022 | -0.6073 | 0.01236 | 0.4833 | 0.1204 | -0.321 | -0.5017 | 0.8571 | coerente_forte |

### acoes_ambiguas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ifnc | -2.564 | 0.3055 | 1.648 | 1.507 | -1.609 | -3.693 | -3.976 |    NA | ambigua |
| asset_imat | 0.09126 | 1.922 |  2.25 |  1.76 | -0.257 | -1.813 | -2.334 |    NA | ambigua |

### risco_cambio_soft

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| cambio_usd | 0.1294 | 0.1615 | 0.1054 | 0.005148 | -0.08027 | -0.1046 | -0.09579 |     0 | soft_depreciacao_fiscal_dom |
| cambio_eur | 0.1083 | 0.1291 | 0.0721 | -0.01297 | -0.05876 | -0.06311 | -0.05429 |     0 | soft_depreciacao_fiscal_dom |
| embi_perc | 0.2507 | 0.2553 | 0.1796 | 0.03264 | -0.1231 | -0.1723 | -0.1589 |     0 | soft_risco_abre_fiscal_dom |
| cds_5y | 30.49 | 33.14 | 23.75 | 4.714 | -16.42 | -23.55 | -21.91 |     0 | soft_risco_abre_fiscal_dom |

### atividade

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| ibc_br | -0.6611 | -0.5178 | -0.5145 | -0.5848 | -0.5448 | -0.3299 | -0.08662 |     1 | coerente_forte |
| pib | 0.1621 | 0.242 | 0.2108 | 0.0903 | -0.1655 | -0.2736 | -0.2444 | 0.4091 | incoerente |
| ind_transformacao | -2.143 | -1.859 | -2.039 | -2.225 | -1.45 | -0.3972 | 0.3785 |     1 | coerente_forte |
| ind_bens_duraveis | -7.185 | -6.769 | -7.489 | -7.839 | -4.421 | -0.4101 | 2.258 |     1 | coerente_forte |
| ind_bens_capital | -3.254 | -2.901 | -3.347 | -3.882 | -2.687 | -0.8651 | 0.5173 |     1 | coerente_forte |
| vendas_varejo | -1.204 | -1.114 | -1.165 | -1.243 | -0.852 | -0.2772 | 0.1643 |     1 | coerente_forte |
| vendas_servicos | -0.6593 | -0.3792 | -0.4259 | -0.7075 | -0.9616 | -0.797 | -0.4458 |     1 | coerente_forte |
| ind_automoveis | -6906 | -5659 | -6351 | -6913 | -4452 | -1146 |  1367 |     1 | coerente_forte |
| capacidade_instalada_industria | -0.2338 | -0.2071 | -0.261 | -0.3214 | -0.2213 | -0.06723 | 0.04674 |     1 | coerente_forte |

### trabalho

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| trab_tx_desemprego | -0.1222 | -0.1797 | -0.1845 | -0.09751 | 0.1319 | 0.2432 | 0.2377 | 0.6452 | incoerente |
| trab_pop_ocupada | 297.7 | 403.8 | 439.9 |   295 | -218.1 | -493.1 | -500.8 | 0.5806 | incoerente |
| trab_hrs_trabalhadas_industria | -1.13 | -1.034 | -1.117 | -1.199 | -0.7957 | -0.2245 | 0.2104 |     1 | coerente_forte |

### credito

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | 0.5128 | 0.7004 | 0.5541 | 0.07046 | -0.6339 | -0.8729 | -0.7788 | 0.7742 | parcial |
| credito_pessoa_fisica | 0.275 | 0.4587 | 0.4127 | 0.08498 | -0.5239 | -0.7514 | -0.6728 | 0.7419 | parcial |
| spread_credito_pj_total | 0.00782 | 0.00614 | 0.01033 | 0.01847 | 0.01817 | 0.01114 | 0.004476 |     1 | coerente_forte |
| spread_credito_pf_total | -0.0002104 | 0.0002573 | 0.003856 | 0.008072 | 0.00552 | 0.001354 | -0.000992 | 0.7692 | parcial |

### credito_setorial

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credito_comercio | 0.651 | 0.9477 | 0.6601 | -0.1492 | -1.111 | -1.345 | -1.136 | 0.8387 | coerente_forte |
| credito_transporte | 1.167 | 1.434 | 1.009 | 0.02571 | -1.08 | -1.397 | -1.232 | 0.7742 | parcial |
| credito_industria_total | 0.7215 | 0.9103 | 0.6537 | 0.03058 | -0.6858 | -0.9041 | -0.8107 | 0.7742 | parcial |
| credito_agro | 0.8868 | 1.115 | 0.8356 | 0.0552 | -0.9623 | -1.277 | -1.128 |    NA | ambigua |
| credito_construcao | 0.6081 | 0.936 | 0.798 | 0.1455 | -0.9193 | -1.314 | -1.196 |    NA | ambigua |

### precos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_ipca | -0.04513 | -0.03785 | -0.03419 | -0.1379 | -0.2964 | -0.2967 | -0.2142 |     1 | coerente_forte |
| price_ipca_difusao | 0.3311 | 0.4345 | 0.3458 | -0.5652 | -1.983 | -2.212 | -1.737 |     1 | coerente_forte |
| price_core_ipca_ex0 | 0.02936 | 0.05127 | 0.05602 | 0.004596 | -0.1074 | -0.1469 | -0.1298 | 0.973 | coerente_forte |
| price_core_ipca_ex1 | -0.01309 | -0.02143 | -0.01795 | -0.07166 | -0.1572 | -0.1572 | -0.1132 |     1 | coerente_forte |
| price_core_ipca_dw | 0.007842 | 0.0212 | 0.01717 | -0.04046 | -0.1305 | -0.1446 | -0.1131 |     1 | coerente_forte |
| price_inpc | -0.06356 | -0.0719 | -0.07437 | -0.1752 | -0.3015 | -0.2758 | -0.1838 |     1 | coerente_forte |

### precos_ambiguos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_igp_m | 0.06627 | 0.1436 | 0.05749 | -0.1958 | -0.4426 | -0.4454 | -0.3321 |    NA | ambigua |
| price_ipp | 0.3421 | 0.3564 | 0.1336 | -0.1967 | -0.3385 | -0.2797 | -0.1803 |    NA | ambigua |

### commodity_domestica

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| commodity_metal | 6.433 | 8.945 | 5.931 | -1.663 | -9.927 | -11.74 | -9.842 |    NA | ambigua |

### fiscal

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| fiscal_dbgg | -0.1679 | -0.3785 | -0.4476 | -0.2956 | 0.276 | 0.5891 | 0.5988 |    NA | ambigua |
| fiscal_dlsp | -0.6687 | -0.7881 | -0.6308 | -0.2136 | 0.4045 | 0.6595 | 0.6318 |    NA | ambigua |
| fiscal_primary_balance | -1473 | -2627 | -807.3 |  2365 |  4557 |  4170 |  2699 |    NA | ambigua |

### expectativas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| expect_focus_ipca12m | 0.09288 | 0.1818 | 0.1517 | -0.009191 | -0.2666 | -0.3477 | -0.3004 |    NA | ambigua |
| expect_focus_selic_ny | 0.4479 | 0.6438 | 0.5554 | 0.2003 | -0.4314 | -0.7032 | -0.6649 |    NA | ambigua |
| expect_focus_pib_ny | -0.1792 | -0.2655 | -0.2322 | -0.0949 | 0.1588 | 0.2743 | 0.2644 |    NA | ambigua |
| expect_focus_cambio_ny | 0.074 | 0.107 | 0.07478 | -0.003204 | -0.08901 | -0.1139 | -0.1009 |    NA | ambigua |

### placebo_externas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| sp500_vix | 0.3957 | -0.5576 | -0.8573 | -0.4076 | 1.077 | 1.857 |  1.85 |    NA | placebo_ok |
| msci | 0.6108 | 1.619 | 1.887 | 0.9322 | -1.387 | -2.668 | -2.879 |    NA | placebo_ok |
| epu_us | 7.222 | 9.079 | 4.385 | 0.9289 | 3.636 | 4.496 |  3.16 |    NA | placebo_ok |


## Canais soft (câmbio / risco soberano)

| var | h0 | h6 | h12 | h24 | channel | right_sig90 |
|---|---|---|---|---|---|---|
| cambio_usd | 0.1294 | 0.1054 | 0.005148 | -0.08027 | depreciacao_fiscal_dom | FALSE |
| cambio_eur | 0.1083 | 0.0721 | -0.01297 | -0.05876 | depreciacao_fiscal_dom | FALSE |
| embi_perc | 0.2507 | 0.1796 | 0.03264 | -0.1231 | risco_abre_fiscal_dom | FALSE |
| cds_5y | 30.49 | 23.75 | 4.714 | -16.42 | risco_abre_fiscal_dom | FALSE |

