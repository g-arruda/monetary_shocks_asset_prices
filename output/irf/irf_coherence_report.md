# Coerência ponto a ponto das IRFs — especificação de produção

Gerado por `script/irf_coherence_check.R` em 2026-08-12.

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
| scored | coerente_forte |    20 |
| scored | parcial |    12 |
| scored | coerente |     6 |
| scored | incoerente |     1 |
| soft | soft_depreciacao_fiscal_dom |     2 |
| soft | soft_risco_abre_fiscal_dom |     2 |

## Violações (incoerente / placebo_viola / sinal errado significativo)

| group | var | verdict | share_correct | wrong_sig90 | h0 | h12 | h24 |
|---|---|---|---|---|---|---|---|
| risco_cambio_soft | cambio_usd | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.2281 | -0.03022 | -0.0602 |
| risco_cambio_soft | cambio_eur | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.2244 | -0.05246 | -0.0187 |
| risco_cambio_soft | embi_perc | soft_risco_abre_fiscal_dom |     0 | TRUE | 0.3204 | -0.04795 | -0.2439 |
| risco_cambio_soft | cds_5y | soft_risco_abre_fiscal_dom |     0 | TRUE | 43.44 | -1.976 | -24.64 |
| precos | price_core_ipca_ex0 | incoerente |     0 | FALSE | 0.02026 | 0.09209 | 0.04234 |

## Trajetórias por grupo (unidades nativas; tcode aplicado)

### curva_juros

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| yield_3m | 0.002625 | 0.004827 | 0.004848 | 0.001131 | -0.008443 | -0.01059 | -0.006339 |     1 | coerente_forte |
| yield_6m | 0.005 | 0.007363 | 0.006157 | 0.000865 | -0.00904 | -0.01044 | -0.005846 |     1 | coerente_forte |
| yield_1y | 0.007958 | 0.0103 | 0.007531 | 0.0003856 | -0.009335 | -0.009539 | -0.004733 |     1 | coerente_forte |
| yield_2y | 0.0108 | 0.0125 | 0.008316 | -2.564e-05 | -0.008559 | -0.007443 | -0.00297 |     1 | coerente_forte |
| yield_5y | 0.0117 | 0.01223 | 0.007737 | -0.0003102 | -0.007135 | -0.005064 | -0.001313 |     1 | coerente_forte |
| yield_10y | 0.01049 | 0.01079 | 0.006827 | -0.0003134 | -0.006268 | -0.004221 | -0.0009306 |     1 | coerente_forte |
| juros_cdi | -0.06802 | 0.115 | 0.2742 | 0.1012 | -0.8042 | -1.092 | -0.6975 | 0.7143 | parcial |
| juros_selic | -0.06633 | 0.1155 | 0.2735 |   0.1 | -0.8049 | -1.092 | -0.6971 | 0.9167 | coerente |

### acoes

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | -2.407 | -0.1612 | 5.135 | 19.16 | 31.82 | 25.49 | 13.86 | 0.5714 | parcial |
| asset_smll | -4.056 | -6.838 | -4.459 | 6.012 | 19.12 |  12.1 | -1.501 |     1 | coerente_forte |
| asset_idiv |  -2.9 | -0.5083 | 5.807 |  21.3 |  39.5 | 38.89 | 30.19 | 0.5714 | parcial |
| asset_imob | -3.787 | -3.607 | 1.537 | 15.53 | 33.97 | 36.19 | 31.35 | 0.8571 | coerente_forte |
| asset_ifix | -2.175 | -8.129 | -11.46 | -14.39 | -18.79 | -31.17 | -42.82 |     1 | coerente_forte |
| asset_mlcx | -2.478 | -0.9571 |  3.56 | 16.12 | 27.18 | 20.07 | 8.238 | 0.5714 | parcial |

### acoes_ambiguas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ifnc | -3.151 | 1.018 | 9.046 | 28.84 |  57.4 | 67.08 | 64.59 |    NA | ambigua |
| asset_imat | -0.4555 |  3.54 | 6.674 | 11.97 | 3.066 | -14.7 | -27.06 |    NA | ambigua |

### risco_cambio_soft

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| cambio_usd | 0.2281 | 0.215 | 0.1048 | -0.03022 | -0.0602 | 0.04247 | 0.07235 |     0 | soft_depreciacao_fiscal_dom |
| cambio_eur | 0.2244 | 0.1981 | 0.07586 | -0.05246 | -0.0187 | 0.1094 | 0.1181 |     0 | soft_depreciacao_fiscal_dom |
| embi_perc | 0.3204 | 0.2279 | 0.1282 | -0.04795 | -0.2439 | -0.1571 | -0.03831 |     0 | soft_risco_abre_fiscal_dom |
| cds_5y | 43.44 | 36.24 | 21.93 | -1.976 | -24.64 | -14.37 | -1.963 |     0 | soft_risco_abre_fiscal_dom |

### atividade

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| ibc_br | -0.7673 | -0.1995 | -0.2506 | -0.634 | -0.268 | -0.2908 | -0.1582 |     1 | coerente |
| pib | 0.2257 | 0.1495 | 0.07287 | -0.02234 | -0.3873 | -0.6838 | -0.4903 | 0.7273 | parcial |
| ind_transformacao | -2.305 | -1.25 | -1.894 | -3.19 | -1.364 | -0.5484 | 0.02889 |     1 | coerente_forte |
| ind_bens_duraveis | -8.524 | -4.999 | -6.44 | -10.54 | -3.631 | -1.224 | 0.2902 |     1 | coerente_forte |
| ind_bens_capital | -4.215 | -2.688 | -3.669 | -6.161 | -3.631 | -1.993 | -0.4314 |     1 | coerente_forte |
| vendas_varejo | -1.628 | -0.7251 | -0.8342 | -1.575 | -0.4743 | 0.001145 | 0.2015 |     1 | coerente_forte |
| vendas_servicos | -1.043 | -0.3488 | -0.4298 | -1.171 | -1.384 | -1.462 | -0.8091 |     1 | coerente |
| ind_automoveis | -6328 | -3124 | -5149 | -9685 | -5273 | -4508 | -2107 |     1 | coerente |
| capacidade_instalada_industria | -0.2781 | -0.1769 | -0.2914 | -0.5222 | -0.2518 | -0.0709 | 0.03583 |     1 | coerente_forte |

### trabalho

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| trab_tx_desemprego | 0.008335 | -0.06408 | -0.1356 | -0.08058 | 0.2969 | 0.4486 |   0.3 | 0.7097 | parcial |
| trab_pop_ocupada | 88.15 | 319.9 | 579.1 | 542.2 | -281.3 | -838.8 | -665.7 | 0.5161 | parcial |
| trab_hrs_trabalhadas_industria | -1.512 | -0.8078 | -0.9385 | -1.642 | -0.7661 | -0.4816 | -0.1442 |     1 | coerente_forte |

### credito

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | 0.04628 | 0.1553 | 0.1537 | -0.3699 | -1.514 | -1.531 | -0.8199 | 0.9032 | coerente_forte |
| credito_pessoa_fisica | -0.08942 | 0.1486 | 0.2355 | -0.1108 | -1.059 | -1.269 | -0.7581 | 0.8387 | coerente_forte |
| spread_icc_juridica | -0.01987 | 0.0009221 | 0.05139 | 0.09965 | 0.06673 | -0.01034 | -0.03768 | 0.7692 | parcial |
| spread_icc_fisica | -0.0344 | -0.00741 | 0.09804 | 0.1884 | 0.06732 | -0.07116 | -0.09664 | 0.6923 | parcial |

### credito_setorial

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credito_comercio | -0.1916 | -0.1261 | -0.312 | -1.273 | -2.833 | -2.452 | -1.159 |     1 | coerente_forte |
| credito_transporte | 1.044 | 0.937 | 0.3916 | -0.9805 | -2.563 | -1.945 | -0.7398 | 0.9355 | coerente_forte |
| credito_industria_total | 0.3291 | 0.191 | -0.07407 | -0.8254 | -2.076 | -1.687 | -0.7355 |     1 | coerente_forte |
| credito_agro | 1.328 | 1.453 | 0.9298 | -0.4224 | -1.873 | -1.474 | -0.5533 |    NA | ambigua |
| credito_construcao | -0.3993 | -0.2004 | -0.0888 | -0.8007 | -2.948 | -3.019 | -1.66 |    NA | ambigua |

### precos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_ipca | -0.1678 | 0.07952 | 0.1247 | -0.06429 | -0.05449 | 0.03728 | 0.07533 | 0.5405 | parcial |
| price_ipca_difusao | 0.1084 | 0.905 | 0.8578 | -0.4199 | -1.397 | -1.084 | -0.3445 |     1 | coerente |
| price_core_ipca_ex0 | 0.02026 | 0.1339 | 0.1521 | 0.09209 | 0.04234 | 0.03384 | 0.02316 |     0 | incoerente |
| price_core_ipca_ex1 | -0.1117 | 0.0001795 | 0.03958 | -0.04849 | -0.07339 | -0.03268 | 0.007181 | 0.9189 | coerente |
| price_core_ipca_dw | -0.008019 | 0.08808 | 0.0859 | -0.005629 | -0.02877 | 0.00346 | 0.02327 | 0.6216 | parcial |
| price_inpc | -0.2284 | 0.004487 | 0.05898 | -0.1359 | -0.1122 | 0.003799 | 0.0657 | 0.6486 | parcial |

### precos_ambiguos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_igp_m | 0.2554 | 0.5157 | 0.3142 | -0.1188 | -0.002682 | 0.2826 | 0.3004 |    NA | ambigua |
| price_ipp | 0.9357 | 0.9862 | 0.5239 | -0.1104 | 0.2298 | 0.6939 | 0.6089 |    NA | ambigua |

### commodity_domestica

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| commodity_metal |  17.2 | 20.26 | 10.46 | -2.501 | -0.732 | 7.804 | 8.646 |    NA | ambigua |

### placebo_externas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| sp500_vix | -0.3717 | -1.995 | -1.157 | -0.3272 | -0.1013 | -0.7499 | -0.7454 |    NA | placebo_ok |
| msci | 0.08579 | -1.044 | -3.301 | -4.907 | -6.23 | -1.612 | 1.067 |    NA | placebo_ok |
| epu_us | -39.89 | -24.35 | -0.2443 | 4.028 | -14.38 | -18.16 | -12.44 |    NA | placebo_ok |


## Canais soft (câmbio / risco soberano)

| var | h0 | h6 | h12 | h24 | channel | right_sig90 |
|---|---|---|---|---|---|---|
| cambio_usd | 0.2281 | 0.1048 | -0.03022 | -0.0602 | depreciacao_fiscal_dom | FALSE |
| cambio_eur | 0.2244 | 0.07586 | -0.05246 | -0.0187 | depreciacao_fiscal_dom | FALSE |
| embi_perc | 0.3204 | 0.1282 | -0.04795 | -0.2439 | risco_abre_fiscal_dom | FALSE |
| cds_5y | 43.44 | 21.93 | -1.976 | -24.64 | risco_abre_fiscal_dom | FALSE |

