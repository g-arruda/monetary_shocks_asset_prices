# Coerência ponto a ponto das IRFs — especificação de produção

Gerado por `script/irf_coherence_check.R` em 2026-08-25.

> **Arquivo gerado — sobrescrito por inteiro a cada rodada.** Não escreva
> prosa aqui: ela se perde no próximo run. A leitura interpretativa vive em
> [`irf_coherence_leitura.md`](irf_coherence_leitura.md), que nenhum script toca.

Especificação: `z_jk_bs_purif` x `yield_6m`, r=5, q=5, p=4, full sample, choque +50bp, wild bootstrap nboot=800 (seed 123), bandas 68/90, h=0..48.

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
| ambiguous | ambigua |    14 |
| placebo | placebo_ok |     3 |
| scored | coerente_forte |    14 |
| scored | incoerente |    11 |
| scored | coerente |     6 |
| scored | parcial |     6 |
| soft | soft_depreciacao_fiscal_dom |     2 |
| soft | soft_risco_abre_fiscal_dom |     2 |

## Violações (incoerente / placebo_viola / sinal errado significativo)

| group | var | verdict | share_correct | wrong_sig90 | h0 | h12 | h24 |
|---|---|---|---|---|---|---|---|
| risco_cambio_soft | cambio_usd | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1539 | -0.03973 | -0.09318 |
| risco_cambio_soft | cambio_eur | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1354 | -0.08452 | -0.09586 |
| risco_cambio_soft | embi_perc | soft_risco_abre_fiscal_dom |     0 | TRUE | 0.2448 | 0.0317 | -0.09396 |
| risco_cambio_soft | cds_5y | soft_risco_abre_fiscal_dom |     0 | TRUE |  30.7 | 5.525 | -11.88 |
| atividade | pib | incoerente |     0 | FALSE | 0.1364 | 0.4521 | 0.1321 |
| atividade | vendas_servicos | incoerente | 0.3636 | FALSE | -0.3416 | 0.2681 | -0.4023 |
| trabalho | trab_tx_desemprego | incoerente | 0.3871 | TRUE | -0.1019 | -0.2763 | -0.01875 |
| trabalho | trab_pop_ocupada | incoerente | 0.2903 | TRUE | 216.8 | 818.9 | 218.3 |
| credito | credit_outstanding | incoerente | 0.5806 | TRUE | 0.555 | 0.4365 | -0.3213 |
| credito | credito_pessoa_fisica | incoerente | 0.4839 | TRUE | 0.2956 | 0.5599 | -0.1482 |
| credito | spread_icc_juridica | incoerente | 0.6154 | TRUE | -0.01672 | 0.0662 | 0.0577 |
| credito_setorial | credito_comercio | incoerente | 0.7419 | TRUE | 0.7932 | 0.1935 | -0.8182 |
| credito_setorial | credito_transporte | incoerente | 0.7419 | TRUE | 1.378 | 0.2272 | -0.9427 |
| credito_setorial | credito_industria_total | incoerente | 0.7742 | TRUE | 0.8147 | 0.06181 | -0.6126 |
| precos | price_core_ipca_ex0 | incoerente | 0.7838 | TRUE | 0.02174 | 0.07401 | -0.03481 |

## Trajetórias por grupo (unidades nativas; tcode aplicado)

### curva_juros

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| yield_3m | 0.003886 | 0.006679 | 0.007737 | 0.006047 | -0.001257 | -0.004962 | -0.003912 |     1 | coerente_forte |
| yield_6m | 0.005 | 0.008215 | 0.009067 | 0.006426 | -0.002121 | -0.005867 | -0.004316 |     1 | coerente_forte |
| yield_1y | 0.006288 | 0.009794 | 0.01024 | 0.006397 | -0.00321 | -0.006656 | -0.004502 |     1 | coerente_forte |
| yield_2y | 0.007282 | 0.01051 | 0.01036 | 0.005603 | -0.003914 | -0.006608 | -0.004098 |     1 | coerente_forte |
| yield_5y | 0.007483 | 0.009681 | 0.008868 | 0.003941 | -0.003866 | -0.005378 | -0.002969 |     1 | coerente_forte |
| yield_10y | 0.006764 | 0.008533 | 0.007691 | 0.003205 | -0.003522 | -0.004629 | -0.002453 |     1 | coerente_forte |
| juros_selic | 0.2408 | 0.4567 | 0.5766 | 0.5184 | -0.0281 | -0.3649 | -0.3189 |     1 | coerente_forte |

### acoes

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | -0.968 | -0.1006 | 1.191 | 1.889 | -0.4361 | -1.922 | -1.634 | 0.5714 | parcial |
| asset_smll | -1.79 | -0.861 | 0.6529 | 1.713 | -0.3205 | -1.758 | -1.556 | 0.5714 | parcial |
| asset_idiv | -1.301 | -0.1378 |  1.27 | 2.046 | -0.4094 | -2.021 | -1.746 | 0.5714 | parcial |
| asset_imob | -1.659 | -0.6425 | 0.8555 | 1.667 | -0.6977 | -2.049 | -1.648 | 0.5714 | parcial |
| asset_ifix | -1.041 | -0.7605 | -0.1237 | 0.4302 | -0.01935 | -0.4201 | -0.4104 |     1 | coerente_forte |

### acoes_ambiguas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ifnc | -1.781 | -0.3191 | 1.446 | 2.456 | -0.5034 | -2.455 | -2.123 |    NA | ambigua |
| asset_imat | 0.4326 | 0.7312 | 1.079 | 0.795 | -0.866 | -1.397 | -0.9062 |    NA | ambigua |

### risco_cambio_soft

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| cambio_usd | 0.1539 | 0.1376 | 0.07626 | -0.03973 | -0.09318 | -0.04095 | 0.009418 |     0 | soft_depreciacao_fiscal_dom |
| cambio_eur | 0.1354 | 0.1043 | 0.03141 | -0.08452 | -0.09586 | -0.01343 | 0.03573 |     0 | soft_depreciacao_fiscal_dom |
| embi_perc | 0.2448 | 0.235 | 0.176 | 0.0317 | -0.09396 | -0.07974 | -0.02276 |     0 | soft_risco_abre_fiscal_dom |
| cds_5y |  30.7 | 30.58 | 23.53 | 5.525 | -11.88 | -11.33 | -4.08 |     0 | soft_risco_abre_fiscal_dom |

### atividade

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| ibc_br | -0.4432 | 0.05441 | 0.1228 | 0.03591 | -0.2247 | -0.2479 | -0.1382 |   0.5 | parcial |
| pib | 0.1364 | 0.3332 | 0.4087 | 0.4521 | 0.1321 | -0.1974 | -0.2436 |     0 | incoerente |
| ind_transformacao | -1.378 | -0.3458 | -0.613 | -1.205 | -1.031 | -0.1398 | 0.3113 |     1 | coerente_forte |
| ind_bens_duraveis | -4.888 | -1.504 | -2.524 | -4.338 | -3.096 | 0.05761 | 1.362 |     1 | coerente_forte |
| ind_bens_capital | -1.885 | -0.1358 | -0.8128 | -2.268 | -2.126 | -0.3527 | 0.6121 |     1 | coerente_forte |
| vendas_varejo | -0.7708 | -0.09928 | -0.2065 | -0.6135 | -0.6995 | -0.2147 | 0.1074 |     1 | coerente_forte |
| vendas_servicos | -0.3416 | 0.4363 | 0.5271 | 0.2681 | -0.4023 | -0.5508 | -0.3338 | 0.3636 | incoerente |
| ind_automoveis | -4291 |    58 | -210.7 | -1483 | -2242 | -1183 | -182.2 | 0.8636 | coerente |
| capacidade_instalada_industria | -0.1262 | 0.004779 | -0.07238 | -0.2197 | -0.1955 | -0.02063 | 0.0687 | 0.9091 | coerente_forte |

### trabalho

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| trab_tx_desemprego | -0.1019 | -0.2067 | -0.2768 | -0.2763 | -0.01875 | 0.1682 | 0.1621 | 0.3871 | incoerente |
| trab_pop_ocupada | 216.8 | 472.6 | 692.5 | 818.9 | 218.3 | -367.1 | -437.3 | 0.2903 | incoerente |
| trab_hrs_trabalhadas_industria | -0.7698 | -0.09435 | -0.1779 | -0.479 | -0.5272 | -0.1628 | 0.07425 |     1 | coerente_forte |

### credito

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | 0.555 | 0.8267 | 0.8179 | 0.4365 | -0.3213 | -0.5276 | -0.3242 | 0.5806 | incoerente |
| credito_pessoa_fisica | 0.2956 | 0.6198 | 0.7291 | 0.5599 | -0.1482 | -0.4876 | -0.3753 | 0.4839 | incoerente |
| spread_icc_juridica | -0.01672 | -0.01174 | 0.01641 | 0.0662 | 0.0577 | 0.001282 | -0.02636 | 0.6154 | incoerente |
| spread_icc_fisica | 0.001705 | -0.003442 | 0.04206 | 0.1202 | 0.09651 | -0.002302 | -0.04736 | 0.7692 | parcial |

### credito_setorial

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credito_comercio | 0.7932 | 1.177 | 1.015 | 0.1935 | -0.8182 | -0.7602 | -0.3006 | 0.7419 | incoerente |
| credito_transporte | 1.378 | 1.651 |  1.33 | 0.2272 | -0.9427 | -0.8379 | -0.2973 | 0.7419 | incoerente |
| credito_industria_total | 0.8147 | 0.9362 | 0.7349 | 0.06181 | -0.6126 | -0.4964 | -0.1512 | 0.7742 | incoerente |
| credito_agro | 1.234 | 1.606 | 1.443 | 0.5406 | -0.7484 | -0.8973 | -0.4476 |    NA | ambigua |
| credito_construcao | 0.6794 | 1.129 | 1.198 | 0.6703 | -0.532 | -0.8561 | -0.5273 |    NA | ambigua |

### precos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_ipca | -0.0549 | 0.08266 | 0.1212 | 0.02352 | -0.1632 | -0.1478 | -0.05966 | 0.973 | coerente |
| price_ipca_difusao | 0.2638 |  1.14 |  1.42 | 0.7675 | -0.8583 | -1.174 | -0.6648 | 0.8649 | coerente |
| price_core_ipca_ex0 | 0.02174 | 0.06941 | 0.09653 | 0.07401 | -0.03481 | -0.07729 | -0.05431 | 0.7838 | incoerente |
| price_core_ipca_ex1 | -0.02597 | 0.04249 | 0.06479 | 0.01736 | -0.07939 | -0.07489 | -0.03152 | 0.9459 | coerente |
| price_core_ipca_dw | 0.009341 | 0.06539 | 0.0784 | 0.03102 | -0.06593 | -0.07335 | -0.03617 | 0.9189 | coerente |
| price_inpc | -0.07163 | 0.06412 | 0.09122 | -0.02009 | -0.182 | -0.1332 | -0.03747 |     1 | coerente |

### precos_ambiguos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_igp_m | 0.1307 | 0.2435 | 0.1717 | -0.0986 | -0.3083 | -0.1762 | -0.01433 |    NA | ambigua |
| price_ipp | 0.4262 | 0.408 | 0.1578 | -0.2701 | -0.3451 | -0.06693 | 0.1114 |    NA | ambigua |

### commodity_domestica

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| commodity_metal | 7.449 | 9.772 | 7.211 | -1.109 | -8.341 | -5.655 | -1.128 |    NA | ambigua |

### fiscal

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| fiscal_dbgg | -0.1338 | -0.4137 | -0.6522 | -0.7632 | -0.129 | 0.4172 | 0.4454 |    NA | ambigua |
| fiscal_dlsp | -0.6555 | -0.789 | -0.7614 | -0.484 | 0.1303 | 0.3951 | 0.2881 |    NA | ambigua |
| fiscal_primary_balance | -2784 | -4884 | -4184 | -2571 | 242.3 |  1807 |  1512 |    NA | ambigua |

### expectativas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| expect_focus_ipca12m | 0.1144 | 0.2378 | 0.2557 | 0.1425 | -0.1223 | -0.1928 | -0.1184 |    NA | ambigua |
| expect_focus_selic_ny | 0.4639 | 0.7067 |  0.74 | 0.5192 | -0.1394 | -0.4467 | -0.3381 |    NA | ambigua |
| expect_focus_pib_ny | -0.1874 | -0.2852 | -0.3063 | -0.2367 | 0.03085 | 0.179 | 0.1475 |    NA | ambigua |
| expect_focus_cambio_ny | 0.09195 | 0.1015 | 0.07148 | -0.0115 | -0.07885 | -0.05228 | -0.009216 |    NA | ambigua |

### placebo_externas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| sp500_vix | 0.2164 | -0.4109 | -0.7923 | -0.4073 | 1.007 | 1.188 | 0.641 |    NA | placebo_ok |
| msci | 1.077 | 1.447 | 1.418 | -1.229 | -4.09 | -2.475 | -0.3266 |    NA | placebo_ok |
| epu_us | 10.14 | 4.146 | -2.542 | -8.981 | -3.95 | 3.283 | 5.078 |    NA | placebo_ok |


## Canais soft (câmbio / risco soberano)

| var | h0 | h6 | h12 | h24 | channel | right_sig90 |
|---|---|---|---|---|---|---|
| cambio_usd | 0.1539 | 0.07626 | -0.03973 | -0.09318 | depreciacao_fiscal_dom | FALSE |
| cambio_eur | 0.1354 | 0.03141 | -0.08452 | -0.09586 | depreciacao_fiscal_dom | FALSE |
| embi_perc | 0.2448 | 0.176 | 0.0317 | -0.09396 | risco_abre_fiscal_dom | FALSE |
| cds_5y |  30.7 | 23.53 | 5.525 | -11.88 | risco_abre_fiscal_dom | FALSE |

