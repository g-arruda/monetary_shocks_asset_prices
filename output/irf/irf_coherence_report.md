# Coerência ponto a ponto das IRFs — especificação de produção

Gerado por `script/irf_coherence_check.R` em 2026-08-17.

> **Arquivo gerado — sobrescrito por inteiro a cada rodada.** Não escreva
> prosa aqui: ela se perde no próximo run. A leitura interpretativa vive em
> [`irf_coherence_leitura.md`](irf_coherence_leitura.md), que nenhum script toca.

Especificação: `z_jk_bs_purif` x `yield_6m`, r=5, q=5, p=6, full sample, choque +50bp, wild bootstrap nboot=800 (seed 123), bandas 68/90, h=0..48.

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
| scored | incoerente |     9 |
| scored | coerente |     8 |
| scored | parcial |     6 |
| soft | soft_depreciacao_fiscal_dom |     2 |
| soft | soft_risco_abre_fiscal_dom |     2 |

## Violações (incoerente / placebo_viola / sinal errado significativo)

| group | var | verdict | share_correct | wrong_sig90 | h0 | h12 | h24 |
|---|---|---|---|---|---|---|---|
| risco_cambio_soft | cambio_usd | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1579 | -0.01208 | -0.1085 |
| risco_cambio_soft | cambio_eur | soft_depreciacao_fiscal_dom |     0 | TRUE |  0.14 | -0.04786 | -0.1154 |
| risco_cambio_soft | embi_perc | soft_risco_abre_fiscal_dom |     0 | TRUE | 0.262 | 0.04412 | -0.1039 |
| risco_cambio_soft | cds_5y | soft_risco_abre_fiscal_dom |     0 | TRUE | 32.54 | 6.796 | -12.93 |
| atividade | pib | incoerente |     0 | FALSE | 0.1579 | 0.3136 | 0.2104 |
| atividade | vendas_servicos | incoerente | 0.3182 | FALSE | -0.356 | 0.1591 | -0.3189 |
| trabalho | trab_tx_desemprego | incoerente | 0.3226 | FALSE | -0.1019 | -0.2157 | -0.04827 |
| trabalho | trab_pop_ocupada | incoerente | 0.2258 | FALSE | 233.2 | 607.2 |   325 |
| credito | credit_outstanding | incoerente | 0.5806 | TRUE | 0.565 | 0.3931 | -0.3051 |
| credito | credito_pessoa_fisica | incoerente | 0.4516 | TRUE | 0.293 | 0.4557 | -0.09737 |
| credito_setorial | credito_comercio | incoerente | 0.7419 | TRUE | 0.7864 | 0.2759 | -0.8678 |
| credito_setorial | credito_transporte | incoerente | 0.7419 | TRUE | 1.424 | 0.3366 | -1.015 |
| credito_setorial | credito_industria_total | incoerente | 0.7419 | TRUE | 0.8214 | 0.1648 | -0.6767 |

## Trajetórias por grupo (unidades nativas; tcode aplicado)

### curva_juros

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| yield_3m | 0.003868 | 0.00725 | 0.007114 | 0.004997 | -0.00077 | -0.005764 | -0.005461 |     1 | coerente_forte |
| yield_6m | 0.005 | 0.008968 | 0.008518 | 0.005425 | -0.001668 | -0.006891 | -0.006047 |     1 | coerente_forte |
| yield_1y | 0.006334 | 0.01075 | 0.009895 | 0.005562 | -0.002853 | -0.007914 | -0.006333 |     1 | coerente_forte |
| yield_2y | 0.00743 | 0.0117 | 0.01037 | 0.005041 | -0.003704 | -0.00794 | -0.005776 |     1 | coerente_forte |
| yield_5y | 0.007761 | 0.01098 | 0.009414 | 0.00374 | -0.003847 | -0.006531 | -0.004177 |     1 | coerente_forte |
| yield_10y | 0.00703 | 0.009677 | 0.008326 | 0.003114 | -0.003557 | -0.005638 | -0.003445 |     1 | coerente_forte |
| juros_selic | 0.238 | 0.4881 | 0.5109 | 0.4161 | 0.02039 | -0.4162 | -0.4432 |     1 | coerente_forte |

### acoes

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | -1.723 | -0.8104 | 1.185 | 1.897 | -0.4689 | -2.15 | -2.222 | 0.5714 | parcial |
| asset_smll | -2.611 | -1.847 | 0.5398 | 1.733 | -0.3575 | -1.952 | -2.122 | 0.5714 | parcial |
| asset_idiv | -2.039 | -0.8982 |  1.01 | 1.957 | -0.3811 | -2.276 | -2.405 | 0.5714 | parcial |
| asset_imob | -2.557 | -1.687 | 0.8394 | 1.792 | -0.7943 | -2.316 | -2.252 | 0.5714 | parcial |
| asset_ifix | -1.311 | -1.306 | -0.1632 | 0.4408 | -0.04105 | -0.451 | -0.557 |     1 | coerente_forte |

### acoes_ambiguas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ifnc | -2.701 | -1.308 |  1.09 | 2.351 | -0.4698 | -2.767 | -2.93 |    NA | ambigua |
| asset_imat | -0.06907 | 0.5772 | 1.441 | 1.046 | -1.017 | -1.619 | -1.215 |    NA | ambigua |

### risco_cambio_soft

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| cambio_usd | 0.1579 | 0.1729 | 0.1203 | -0.01208 | -0.1085 | -0.05606 | 0.01348 |     0 | soft_depreciacao_fiscal_dom |
| cambio_eur |  0.14 | 0.1373 | 0.07973 | -0.04786 | -0.1154 | -0.0254 | 0.04963 |     0 | soft_depreciacao_fiscal_dom |
| embi_perc | 0.262 | 0.281 | 0.2323 | 0.04412 | -0.1039 | -0.09951 | -0.02917 |     0 | soft_risco_abre_fiscal_dom |
| cds_5y | 32.54 |  36.8 | 29.83 | 6.796 | -12.93 | -14.02 | -5.413 |     0 | soft_risco_abre_fiscal_dom |

### atividade

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| ibc_br | -0.4605 | 0.01452 | -0.2468 | -0.02162 | -0.1732 | -0.3334 | -0.2463 | 0.8182 | coerente |
| pib | 0.1579 | 0.4491 | 0.2441 | 0.3136 | 0.2104 | -0.2167 | -0.3451 |     0 | incoerente |
| ind_transformacao | -1.414 | -0.4457 | -1.449 | -1.044 | -1.042 | -0.3566 | 0.2632 |     1 | coerente_forte |
| ind_bens_duraveis | -4.855 | -1.743 | -5.528 | -3.896 | -3.068 | -0.584 | 1.303 |     1 | coerente_forte |
| ind_bens_capital |  -1.9 | -0.2254 | -2.118 | -1.902 | -2.197 | -0.7818 | 0.5539 |     1 | coerente_forte |
| vendas_varejo | -0.7974 | -0.2181 | -0.6756 | -0.5204 | -0.7119 | -0.3678 | 0.04978 |     1 | coerente_forte |
| vendas_servicos | -0.356 | 0.4357 | 0.02065 | 0.1591 | -0.3189 | -0.7067 | -0.539 | 0.3182 | incoerente |
| ind_automoveis | -4231 |   160 | -3897 | -1806 | -1811 | -1907 | -836.8 | 0.9545 | coerente |
| capacidade_instalada_industria | -0.1237 | 0.004724 | -0.1671 | -0.1798 | -0.2066 | -0.05721 | 0.07092 | 0.9545 | coerente_forte |

### trabalho

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| trab_tx_desemprego | -0.1019 | -0.2238 | -0.235 | -0.2157 | -0.04827 | 0.1884 | 0.2247 | 0.3226 | incoerente |
| trab_pop_ocupada | 233.2 | 542.3 | 538.7 | 607.2 |   325 | -392.6 | -602.9 | 0.2258 | incoerente |
| trab_hrs_trabalhadas_industria | -0.7714 | -0.1565 | -0.712 | -0.4534 | -0.5011 | -0.2931 | 0.00492 |     1 | coerente_forte |

### credito

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | 0.565 | 0.9137 | 0.8104 | 0.3931 | -0.3051 | -0.6352 | -0.4585 | 0.5806 | incoerente |
| credito_pessoa_fisica | 0.293 | 0.6611 | 0.6245 | 0.4557 | -0.09737 | -0.5724 | -0.5306 | 0.4516 | incoerente |
| spread_icc_juridica | -0.01537 | -0.00994 | 0.000529 | 0.04346 | 0.06945 | 0.008149 | -0.03484 | 0.5385 | parcial |
| spread_icc_fisica | 0.003862 | 0.001663 | 0.03122 | 0.08418 | 0.114 | 0.009804 | -0.06072 | 0.8462 | coerente |

### credito_setorial

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credito_comercio | 0.7864 | 1.259 | 1.081 | 0.2759 | -0.8678 | -0.9567 | -0.4429 | 0.7419 | incoerente |
| credito_transporte | 1.424 | 1.861 | 1.558 | 0.3366 | -1.015 | -1.054 | -0.4263 | 0.7419 | incoerente |
| credito_industria_total | 0.8214 |  1.04 | 0.9179 | 0.1648 | -0.6767 | -0.6269 | -0.2148 | 0.7419 | incoerente |
| credito_agro | 1.277 | 1.786 | 1.565 | 0.547 | -0.7676 |  -1.1 | -0.6331 |    NA | ambigua |
| credito_construcao | 0.6536 | 1.163 | 1.195 | 0.6241 | -0.5206 | -1.027 | -0.7435 |    NA | ambigua |

### precos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_ipca | -0.06179 | 0.009289 | 0.08857 | 0.03091 | -0.1692 | -0.1887 | -0.09399 | 0.9459 | coerente |
| price_ipca_difusao | 0.266 | 0.8526 | 1.254 | 0.6793 | -0.8347 | -1.438 | -0.9717 | 0.8378 | coerente |
| price_core_ipca_ex0 | 0.01743 | 0.05427 | 0.09013 | 0.06456 | -0.0316 | -0.09111 | -0.07641 | 0.7838 | parcial |
| price_core_ipca_ex1 | -0.02814 | 0.002918 | 0.05003 | 0.01947 | -0.08199 | -0.09507 | -0.04903 | 0.9189 | coerente |
| price_core_ipca_dw | 0.006785 | 0.04631 | 0.06825 | 0.03116 | -0.06701 | -0.09136 | -0.05395 | 0.8919 | coerente |
| price_inpc | -0.07657 | -0.01525 | 0.05923 | -0.003604 | -0.1924 | -0.175 | -0.06482 |     1 | coerente |

### precos_ambiguos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_igp_m | 0.1279 | 0.2298 | 0.1889 | -0.04032 | -0.3395 | -0.2378 | -0.03358 |    NA | ambigua |
| price_ipp | 0.4677 | 0.5245 | 0.2493 | -0.1738 | -0.394 | -0.1198 | 0.1439 |    NA | ambigua |

### commodity_domestica

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| commodity_metal | 7.456 | 10.56 | 8.575 | 0.4023 | -9.19 | -7.377 | -1.799 |    NA | ambigua |

### fiscal

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| fiscal_dbgg | -0.1129 | -0.437 | -0.5122 | -0.5894 | -0.2159 | 0.4571 | 0.6157 |    NA | ambigua |
| fiscal_dlsp | -0.6904 | -0.9402 | -0.7944 | -0.4107 | 0.09956 | 0.4606 | 0.395 |    NA | ambigua |
| fiscal_primary_balance | -3319 | -6769 | -2496 | -1602 | -376.7 |  2230 |  2294 |    NA | ambigua |

### expectativas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| expect_focus_ipca12m | 0.1088 | 0.2439 | 0.2311 | 0.1283 | -0.116 | -0.2336 | -0.1703 |    NA | ambigua |
| expect_focus_selic_ny | 0.4735 | 0.8212 | 0.6844 | 0.4301 | -0.09561 | -0.524 | -0.474 |    NA | ambigua |
| expect_focus_pib_ny | -0.191 | -0.3387 | -0.277 | -0.1918 | 0.008165 | 0.2071 | 0.2058 |    NA | ambigua |
| expect_focus_cambio_ny | 0.09098 | 0.115 | 0.09505 | 0.006078 | -0.08891 | -0.06764 | -0.01362 |    NA | ambigua |

### placebo_externas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| sp500_vix | 0.5305 | 0.02614 | -0.8654 | -0.5865 | 1.119 | 1.435 | 0.9064 |    NA | placebo_ok |
| msci | 0.4969 | 0.03955 |  3.06 | 0.03314 | -4.878 | -3.155 | -0.4377 |    NA | placebo_ok |
| epu_us | 10.46 | 7.957 |  2.08 | -5.84 | -5.554 | 3.392 | 7.289 |    NA | placebo_ok |


## Canais soft (câmbio / risco soberano)

| var | h0 | h6 | h12 | h24 | channel | right_sig90 |
|---|---|---|---|---|---|---|
| cambio_usd | 0.1579 | 0.1203 | -0.01208 | -0.1085 | depreciacao_fiscal_dom | FALSE |
| cambio_eur |  0.14 | 0.07973 | -0.04786 | -0.1154 | depreciacao_fiscal_dom | FALSE |
| embi_perc | 0.262 | 0.2323 | 0.04412 | -0.1039 | risco_abre_fiscal_dom | FALSE |
| cds_5y | 32.54 | 29.83 | 6.796 | -12.93 | risco_abre_fiscal_dom | FALSE |

