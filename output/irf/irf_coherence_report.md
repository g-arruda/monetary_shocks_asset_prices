# Coerência ponto a ponto das IRFs — especificação de produção

Gerado por `script/irf_coherence_check.R` em 2026-07-28.

> **Arquivo gerado — sobrescrito por inteiro a cada rodada.** Não escreva
> prosa aqui: ela se perde no próximo run. A leitura interpretativa vive em
> [`irf_coherence_leitura.md`](irf_coherence_leitura.md), que nenhum script toca.

Especificação: `z_jk_bs_purif` x `yield_6m`, r=7, q=6, p=6, full sample, choque +50bp, wild bootstrap nboot=800 (seed 123), bandas 68/90, h=0..48.

## Método

Para cada variável, cada horizonte h é checado quanto a sinal e significância
(CI68/CI90) contra a janela teórica [w_lo, w_hi] definida em
`R/identification/irf_coherence.R::coherence_var_table()`. Vereditos:
`coerente_forte` (≥80% da janela com sinal certo + significância CI68),
`coerente` (≥80% sem significância), `parcial` (50-80%, sem violação
significativa), `incoerente` (<50% ou sinal errado com CI90 excluindo 0),
`soft_*` (canal registrado — dominância fiscal admissível), `ambigua`
(sem prior forte), `placebo_ok/viola` (externas: CI90 deve conter 0 em ≥90% de h0-h24).

## Contagem de vereditos

| tier | verdict | n |
|---|---|---|
| ambiguous | ambigua |     7 |
| placebo | placebo_ok |     3 |
| scored | coerente_forte |    22 |
| scored | parcial |    11 |
| scored | coerente |     5 |
| scored | incoerente |     1 |
| soft | soft_depreciacao_fiscal_dom |     2 |
| soft | soft_risco_abre_fiscal_dom |     2 |

## Violações (incoerente / placebo_viola / sinal errado significativo)

| group | var | verdict | share_correct | wrong_sig90 | h0 | h12 | h24 |
|---|---|---|---|---|---|---|---|
| risco_cambio_soft | cambio_usd | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1498 | -0.02064 | -0.04066 |
| risco_cambio_soft | cambio_eur | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1446 | -0.0298 | -0.004589 |
| risco_cambio_soft | embi_perc | soft_risco_abre_fiscal_dom |     0 | TRUE | 0.1995 | -0.04938 | -0.1703 |
| risco_cambio_soft | cds_5y | soft_risco_abre_fiscal_dom |     0 | TRUE | 29.07 | -2.975 | -17.5 |
| precos | price_core_ipca_ex0 | incoerente |     0 | FALSE | 0.01831 | 0.05612 | 0.02748 |

## Trajetórias por grupo (unidades nativas; tcode aplicado)

### curva_juros

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| yield_3m | 0.002792 | 0.003844 | 0.003063 | -0.000173 | -0.006592 | -0.007686 | -0.004662 |     1 | coerente_forte |
| yield_6m | 0.005 | 0.005972 | 0.004145 | -0.0003222 | -0.006842 | -0.007436 | -0.004232 |     1 | coerente_forte |
| yield_1y | 0.007352 | 0.008082 | 0.00511 | -0.0006192 | -0.006768 | -0.00658 | -0.003334 |     1 | coerente_forte |
| yield_2y | 0.009164 | 0.009398 | 0.005603 | -0.0007519 | -0.00599 | -0.005029 | -0.002085 |     1 | coerente_forte |
| yield_5y | 0.009274 | 0.008759 | 0.005127 | -0.0006037 | -0.00468 | -0.003249 | -0.000907 |     1 | coerente_forte |
| yield_10y | 0.00808 | 0.007479 | 0.004399 | -0.0005774 | -0.004105 | -0.002715 | -0.0006655 |     1 | coerente_forte |
| juros_cdi | -0.04816 | 0.04314 | 0.1161 | -0.03351 | -0.6212 | -0.7686 | -0.4928 | 0.7143 | parcial |
| juros_selic | -0.0471 | 0.04344 | 0.1156 | -0.03427 | -0.6217 | -0.7685 | -0.4926 | 0.8333 | coerente |

### acoes

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | -1.673 | -0.7756 |  2.36 | 11.52 | 20.26 | 16.37 | 7.916 | 0.7143 | parcial |
| asset_smll | -2.677 | -4.915 | -3.705 | 3.263 | 11.41 | 5.882 | -4.438 |     1 | coerente_forte |
| asset_idiv | -2.038 | -1.179 | 2.526 | 12.65 |  26.4 | 28.18 | 22.92 | 0.7143 | parcial |
| asset_imob | -2.895 | -4.337 | -1.587 | 7.745 | 20.95 | 22.64 | 18.34 |     1 | coerente_forte |
| asset_ifix | -1.034 | -4.309 | -6.679 | -8.89 | -13.91 | -24.34 | -33.34 |     1 | coerente_forte |
| asset_mlcx | -1.736 | -1.363 | 1.207 | 9.359 | 16.99 | 12.57 | 4.059 | 0.7143 | parcial |

### acoes_ambiguas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ifnc | -1.975 | 0.9156 | 6.535 | 20.47 | 41.02 | 48.02 | 45.05 |    NA | ambigua |
| asset_imat | -0.3149 | 1.688 | 2.829 | 5.105 | -0.7057 | -10.91 | -18.04 |    NA | ambigua |

### risco_cambio_soft

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| cambio_usd | 0.1498 | 0.1331 | 0.0691 | -0.02064 | -0.04066 | 0.02928 | 0.04902 |     0 | soft_depreciacao_fiscal_dom |
| cambio_eur | 0.1446 | 0.1202 | 0.05143 | -0.0298 | -0.004589 | 0.08059 | 0.08425 |     0 | soft_depreciacao_fiscal_dom |
| embi_perc | 0.1995 | 0.1212 | 0.06773 | -0.04938 | -0.1703 | -0.1029 | -0.02318 |     0 | soft_risco_abre_fiscal_dom |
| cds_5y | 29.07 |  22.4 | 13.62 | -2.975 | -17.5 | -9.857 | -1.496 |     0 | soft_risco_abre_fiscal_dom |

### atividade

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| ibc_br | -0.393 | 0.01879 | -0.1592 | -0.497 | -0.2279 | -0.2369 | -0.1223 | 0.9545 | coerente |
| pib | 0.1633 | 0.2234 | 0.05182 | -0.1085 | -0.3996 | -0.5603 | -0.3762 | 0.8182 | coerente |
| ind_transformacao | -1.411 | -0.5992 | -1.321 | -2.331 | -1.008 | -0.409 | 0.06388 |     1 | coerente_forte |
| ind_bens_duraveis | -5.473 | -2.624 | -4.523 | -7.727 | -2.707 | -0.9245 | 0.3625 |     1 | coerente_forte |
| ind_bens_capital | -2.601 | -1.388 | -2.539 | -4.613 | -2.889 |  -1.6 | -0.2789 |     1 | coerente_forte |
| vendas_varejo | -1.042 | -0.4526 | -0.6311 | -1.189 | -0.3086 | 0.05196 | 0.2021 |     1 | coerente_forte |
| vendas_servicos | -0.4488 | 0.04587 | -0.2757 | -0.9742 | -1.119 | -1.099 | -0.5814 | 0.9545 | coerente |
| ind_automoveis | -3647 | -1046 | -3918 | -7166 | -3412 | -2730 | -1086 |     1 | coerente_forte |
| capacidade_instalada_industria | -0.1897 | -0.1097 | -0.2126 | -0.3824 | -0.1852 | -0.05369 | 0.03238 |     1 | coerente_forte |

### trabalho

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| trab_tx_desemprego | -0.001235 | -0.04594 | -0.07331 | -0.01497 | 0.2437 | 0.3302 | 0.2214 | 0.7742 | parcial |
| trab_pop_ocupada |  91.9 | 275.4 | 382.3 | 305.7 | -253.1 | -608.6 | -492.5 | 0.5806 | parcial |
| trab_hrs_trabalhadas_industria | -0.9801 | -0.448 | -0.6847 | -1.239 | -0.5603 | -0.3269 | -0.06378 |     1 | coerente_forte |

### credito

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | -0.05727 | -0.05018 | -0.04714 | -0.4265 | -1.171 | -1.103 | -0.5851 |     1 | coerente_forte |
| credito_pessoa_fisica | -0.07205 | 0.04761 | 0.06565 | -0.2071 | -0.8175 | -0.9045 | -0.54 | 0.9032 | coerente_forte |
| spread_icc_juridica | -0.01618 | 0.006954 | 0.0388 | 0.07056 | 0.04669 | -0.00697 | -0.02846 | 0.7692 | parcial |
| spread_icc_fisica | -0.03061 | -0.001226 | 0.06974 | 0.1263 | 0.03547 | -0.05711 | -0.07524 | 0.6923 | parcial |

### credito_setorial

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credito_comercio | -0.2634 | -0.3806 | -0.4912 | -1.172 | -2.176 | -1.771 | -0.8103 |     1 | coerente_forte |
| credito_transporte | 0.7506 | 0.4923 | 0.1035 | -0.9238 | -1.967 | -1.426 | -0.5309 | 0.9677 | coerente_forte |
| credito_industria_total | 0.1882 | -0.03604 | -0.2075 | -0.7674 | -1.625 | -1.259 | -0.5363 |     1 | coerente_forte |
| credito_agro | 1.009 | 0.9306 | 0.5304 | -0.4996 | -1.469 | -1.131 | -0.4458 |    NA | ambigua |
| credito_construcao | -0.318 | -0.3392 | -0.3034 | -0.876 | -2.319 | -2.21 | -1.191 |    NA | ambigua |

### precos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_ipca | -0.07025 | 0.0522 | 0.09863 | -0.07706 | -0.05241 | 0.01196 | 0.04469 | 0.5946 | parcial |
| price_ipca_difusao | 0.06956 | 0.3761 | 0.4844 | -0.5047 | -0.999 | -0.7776 | -0.2747 |     1 | coerente |
| price_core_ipca_ex0 | 0.01831 | 0.08256 | 0.1077 | 0.05612 | 0.02748 | 0.01887 | 0.009118 |     0 | incoerente |
| price_core_ipca_ex1 | -0.05509 | -0.006672 | 0.02753 | -0.05486 | -0.05761 | -0.02577 | 0.004506 | 0.9189 | coerente_forte |
| price_core_ipca_dw | 0.001044 | 0.04933 | 0.05769 | -0.0152 | -0.01852 | 0.003454 | 0.0152 | 0.6216 | parcial |
| price_inpc | -0.113 | -0.0008442 | 0.05269 | -0.1329 | -0.1017 | -0.01676 | 0.03783 | 0.7297 | parcial |

### precos_ambiguos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_igp_m | 0.1832 | 0.3229 | 0.2303 | -0.09664 | -0.004383 | 0.179 | 0.1932 |    NA | ambigua |
| price_ipp | 0.5859 | 0.6141 | 0.3666 | -0.04444 | 0.2311 | 0.5187 | 0.4331 |    NA | ambigua |

### commodity_domestica

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| commodity_metal | 10.41 | 11.27 | 6.283 | -1.243 | 2.158 | 7.378 |  6.77 |    NA | ambigua |

### placebo_externas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| sp500_vix | -0.6554 | -1.376 | -0.8515 | -0.3024 | -0.3779 | -0.7555 | -0.6092 |    NA | placebo_ok |
| msci | 4.103 | 1.243 | -1.609 | -3.511 | -3.754 | -0.2627 | 1.575 |    NA | placebo_ok |
| epu_us | -32.08 | -21.45 | -2.539 | -3.485 | -20.33 | -18.67 | -11.11 |    NA | placebo_ok |


## Canais soft (câmbio / risco soberano)

| var | h0 | h6 | h12 | h24 | channel | right_sig90 |
|---|---|---|---|---|---|---|
| cambio_usd | 0.1498 | 0.0691 | -0.02064 | -0.04066 | depreciacao_fiscal_dom | FALSE |
| cambio_eur | 0.1446 | 0.05143 | -0.0298 | -0.004589 | depreciacao_fiscal_dom | FALSE |
| embi_perc | 0.1995 | 0.06773 | -0.04938 | -0.1703 | risco_abre_fiscal_dom | FALSE |
| cds_5y | 29.07 | 13.62 | -2.975 | -17.5 | risco_abre_fiscal_dom | FALSE |

