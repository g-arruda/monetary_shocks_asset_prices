# Coerência ponto a ponto das IRFs — especificação de produção

Gerado por `script/irf_coherence_check.R` em 2026-09-02.

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
| scored | coerente_forte |    25 |
| scored | incoerente |     8 |
| scored | coerente |     3 |
| scored | parcial |     1 |
| soft | soft_depreciacao_fiscal_dom |     2 |
| soft | soft_risco_abre_fiscal_dom |     2 |

## Violações (incoerente / placebo_viola / sinal errado significativo)

| group | var | verdict | share_correct | wrong_sig90 | h0 | h12 | h24 |
|---|---|---|---|---|---|---|---|
| acoes | asset_ibov | incoerente | 0.2857 | FALSE | -0.9965 | 1.822 | -0.5235 |
| acoes | asset_idiv | incoerente | 0.2857 | FALSE | -1.345 | 1.748 | -0.5995 |
| acoes | asset_imob | incoerente | 0.4286 | FALSE | -1.901 | 1.304 | -0.6954 |
| risco_cambio_soft | cambio_usd | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1342 | -0.03822 | -0.09399 |
| risco_cambio_soft | cambio_eur | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1135 | -0.06987 | -0.07925 |
| risco_cambio_soft | embi_perc | soft_risco_abre_fiscal_dom |     0 | TRUE | 0.2433 | 0.001805 | -0.1312 |
| risco_cambio_soft | cds_5y | soft_risco_abre_fiscal_dom |     0 | TRUE | 29.91 | 1.631 | -17.08 |
| atividade | pib | incoerente | 0.09091 | FALSE | 0.1413 | 0.3598 | -0.07434 |
| trabalho | trab_tx_desemprego | incoerente | 0.5161 | TRUE | -0.1164 | -0.1981 | 0.08587 |
| trabalho | trab_pop_ocupada | incoerente | 0.4516 | TRUE | 267.5 | 627.4 | -84.92 |
| credito | credit_outstanding | incoerente | 0.7097 | TRUE | 0.5142 | 0.1694 | -0.5655 |
| credito | credito_pessoa_fisica | incoerente | 0.6452 | TRUE | 0.2747 | 0.2943 | -0.4179 |

## Trajetórias por grupo (unidades nativas; tcode aplicado)

### curva_juros

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| yield_3m | 0.003988 | 0.006548 | 0.006694 | 0.004022 | -0.003839 | -0.007569 | -0.006522 |     1 | coerente_forte |
| yield_6m | 0.005 | 0.007903 | 0.00768 | 0.004023 | -0.005181 | -0.009021 | -0.007403 |     1 | coerente_forte |
| yield_1y | 0.006144 | 0.009203 | 0.008435 | 0.003653 | -0.006661 | -0.01028 | -0.007969 |     1 | coerente_forte |
| yield_2y | 0.007026 | 0.009738 | 0.00837 | 0.002859 | -0.007437 | -0.01036 | -0.007553 |     1 | coerente_forte |
| yield_5y | 0.007246 | 0.008854 | 0.00705 | 0.00177 | -0.006674 | -0.008407 | -0.005673 |     1 | coerente_forte |
| yield_10y | 0.006586 | 0.007751 | 0.006048 | 0.001327 | -0.005895 | -0.007175 | -0.004699 |     1 | coerente_forte |
| juros_selic | 0.2655 | 0.4664 |  0.52 | 0.3705 | -0.2279 | -0.5622 | -0.52 |     1 | coerente_forte |

### acoes

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | -0.9965 | 0.9121 | 1.853 | 1.822 | -0.5235 | -2.397 |  -2.5 | 0.2857 | incoerente |
| asset_smll | -1.87 | -0.03079 |  1.19 | 1.602 | -0.1827 | -1.934 | -2.193 | 0.5714 | parcial |
| asset_idiv | -1.345 | 0.6973 |  1.71 | 1.748 | -0.5995 | -2.493 | -2.599 | 0.2857 | incoerente |
| asset_imob | -1.901 | 0.08184 | 1.197 | 1.304 | -0.6954 | -2.287 | -2.301 | 0.4286 | incoerente |
| asset_ifix | -0.9053 | -0.5979 | 0.04723 | 0.5182 | 0.2382 | -0.3062 | -0.5196 | 0.8571 | coerente_forte |

### acoes_ambiguas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ifnc | -1.944 | 0.6036 | 1.835 | 1.768 | -1.104 | -3.219 | -3.177 |    NA | ambigua |
| asset_imat | 0.465 | 1.653 | 1.776 | 1.355 | -0.2321 | -1.388 | -1.419 |    NA | ambigua |

### risco_cambio_soft

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| cambio_usd | 0.1342 | 0.1306 | 0.06066 | -0.03822 | -0.09399 | -0.05615 | -0.003553 |     0 | soft_depreciacao_fiscal_dom |
| cambio_eur | 0.1135 | 0.09468 | 0.01919 | -0.06987 | -0.07925 | -0.01361 | 0.03712 |     0 | soft_depreciacao_fiscal_dom |
| embi_perc | 0.2433 | 0.2101 | 0.1349 | 0.001805 | -0.1312 | -0.1169 | -0.04845 |     0 | soft_risco_abre_fiscal_dom |
| cds_5y | 29.91 | 28.26 | 18.81 | 1.631 | -17.08 | -16.84 | -8.329 |     0 | soft_risco_abre_fiscal_dom |

### atividade

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| ibc_br | -0.6304 | -0.2082 | -0.2016 | -0.2947 | -0.4294 | -0.3864 | -0.2539 |     1 | coerente |
| pib | 0.1413 | 0.3883 | 0.4207 | 0.3598 | -0.07434 | -0.3969 | -0.4292 | 0.09091 | incoerente |
| ind_transformacao | -2.014 | -1.136 | -1.479 | -1.87 | -1.318 | -0.3317 | 0.2355 |     1 | coerente_forte |
| ind_bens_duraveis | -6.869 | -4.205 | -5.414 | -6.464 | -4.001 | -0.471 | 1.273 |     1 | coerente_forte |
| ind_bens_capital | -3.065 | -1.781 | -2.505 | -3.383 | -2.498 | -0.6257 | 0.4973 |     1 | coerente_forte |
| vendas_varejo | -1.145 | -0.7425 | -0.8634 | -1.051 | -0.7676 | -0.2145 | 0.1172 |     1 | coerente_forte |
| vendas_servicos | -0.6196 | 0.05095 | 0.02988 | -0.2474 | -0.7697 | -0.8473 | -0.6059 | 0.8182 | coerente |
| ind_automoveis | -6562 | -2430 | -3440 | -4471 | -3686 | -1873 | -588.4 |     1 | coerente |
| capacidade_instalada_industria | -0.2188 | -0.123 | -0.2038 | -0.2934 | -0.2123 | -0.04067 | 0.05928 |     1 | coerente_forte |

### trabalho

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| trab_tx_desemprego | -0.1164 | -0.2127 | -0.251 | -0.1981 | 0.08587 | 0.2617 | 0.2547 | 0.5161 | incoerente |
| trab_pop_ocupada | 267.5 | 529.6 | 674.2 | 627.4 | -84.92 | -622.1 | -679.4 | 0.4516 | incoerente |
| trab_hrs_trabalhadas_industria | -1.086 | -0.5828 | -0.7128 | -0.882 | -0.6849 | -0.2635 | 0.006553 |     1 | coerente_forte |

### credito

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | 0.5142 | 0.7025 | 0.5882 | 0.1694 | -0.5655 | -0.7472 | -0.5287 | 0.7097 | incoerente |
| credito_pessoa_fisica | 0.2747 | 0.5417 | 0.5535 | 0.2943 | -0.4179 | -0.723 | -0.601 | 0.6452 | incoerente |
| spread_credito_pj_total | 0.006272 | 0.007782 | 0.01507 | 0.02568 | 0.01983 | 0.002088 | -0.008935 | 0.9231 | coerente_forte |
| spread_credito_pf_total | -0.0008478 | 0.003044 | 0.00882 | 0.01456 | 0.007727 | -0.003877 | -0.009264 | 0.8462 | coerente_forte |

### credito_setorial

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credito_comercio | 0.683 | 0.8811 | 0.5727 | -0.1906 | -1.067 | -1.004 | -0.5268 | 0.8387 | coerente_forte |
| credito_transporte | 1.177 | 1.262 | 0.8129 | -0.09886 | -1.078 | -1.013 | -0.5046 | 0.8065 | coerente_forte |
| credito_industria_total | 0.7402 | 0.7571 | 0.4685 | -0.1197 | -0.7027 | -0.6112 | -0.2679 | 0.8387 | coerente_forte |
| credito_agro | 0.8858 | 1.041 | 0.7861 | 0.08806 | -0.9029 | -1.017 | -0.6299 |    NA | ambigua |
| credito_construcao | 0.6289 | 0.9248 | 0.8283 | 0.2642 | -0.8136 | -1.107 | -0.8006 |    NA | ambigua |

### precos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_ipca | -0.04363 | -0.02762 | -0.01198 | -0.1132 | -0.2647 | -0.2242 | -0.1119 |     1 | coerente_forte |
| price_ipca_difusao | 0.3172 | 0.4417 | 0.4641 | -0.3669 | -1.767 | -1.739 | -1.003 |     1 | coerente_forte |
| price_core_ipca_ex0 | 0.03002 | 0.05177 | 0.06628 | 0.02402 | -0.09043 | -0.1244 | -0.09193 | 0.9189 | coerente_forte |
| price_core_ipca_ex1 | -0.01507 | -0.02047 | -0.007779 | -0.05912 | -0.1403 | -0.1176 | -0.05731 |     1 | coerente_forte |
| price_core_ipca_dw | 0.00899 | 0.02351 | 0.0248 | -0.02893 | -0.1166 | -0.1127 | -0.06431 |     1 | coerente_forte |
| price_inpc | -0.06268 | -0.06413 | -0.05874 | -0.1626 | -0.2752 | -0.196 | -0.07357 |     1 | coerente_forte |

### precos_ambiguos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_igp_m | 0.08417 | 0.1237 | 0.01591 | -0.2437 | -0.4345 | -0.2925 | -0.0858 |    NA | ambigua |
| price_ipp | 0.3436 | 0.2913 | 0.02326 | -0.3179 | -0.3841 | -0.1241 | 0.09393 |    NA | ambigua |

### commodity_domestica

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| commodity_metal | 6.766 | 7.839 | 4.374 | -2.963 | -9.891 | -8.128 | -3.434 |    NA | ambigua |

### fiscal

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| fiscal_dbgg | -0.1677 | -0.4981 | -0.6521 | -0.5861 | 0.1438 | 0.6723 | 0.7054 |    NA | ambigua |
| fiscal_dlsp | -0.6499 | -0.7634 | -0.6486 | -0.3074 | 0.3564 | 0.5948 | 0.4637 |    NA | ambigua |
| fiscal_primary_balance | -1475 | -4017 | -2221 | 742.4 |  4036 |  4129 |  2573 |    NA | ambigua |

### expectativas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| expect_focus_ipca12m | 0.1004 | 0.2011 | 0.1816 | 0.04018 | -0.2318 | -0.2997 | -0.214 |    NA | ambigua |
| expect_focus_selic_ny | 0.4418 | 0.7129 | 0.6818 | 0.4083 | -0.3372 | -0.7022 | -0.6153 |    NA | ambigua |
| expect_focus_pib_ny | -0.1773 | -0.2985 | -0.289 | -0.186 | 0.1194 | 0.2828 | 0.2577 |    NA | ambigua |
| expect_focus_cambio_ny | 0.07929 | 0.09013 | 0.05035 | -0.02553 | -0.09219 | -0.07464 | -0.02938 |    NA | ambigua |

### placebo_externas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| sp500_vix | 0.1914 | -0.487 | -0.7336 | -0.3173 | 0.9346 | 1.424 | 1.111 |    NA | placebo_ok |
| msci | 0.9389 | 0.3552 | 0.314 | -0.7278 | -1.649 | -1.065 | -0.1242 |    NA | placebo_ok |
| epu_us | 7.955 | 5.782 | -1.367 | -5.743 | 0.623 | 7.211 | 8.674 |    NA | placebo_ok |


## Canais soft (câmbio / risco soberano)

| var | h0 | h6 | h12 | h24 | channel | right_sig90 |
|---|---|---|---|---|---|---|
| cambio_usd | 0.1342 | 0.06066 | -0.03822 | -0.09399 | depreciacao_fiscal_dom | FALSE |
| cambio_eur | 0.1135 | 0.01919 | -0.06987 | -0.07925 | depreciacao_fiscal_dom | FALSE |
| embi_perc | 0.2433 | 0.1349 | 0.001805 | -0.1312 | risco_abre_fiscal_dom | FALSE |
| cds_5y | 29.91 | 18.81 | 1.631 | -17.08 | risco_abre_fiscal_dom | FALSE |

