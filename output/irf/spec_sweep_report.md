# Varredura de especificações IRF — Etapa 1 (ponto-estimativa)

Gerado por `script/irf_spec_sweep.R` em 2026-08-17.

Grid: 2 amostras x 5 combinações (r,q) x 8 instrumentos x 5 variáveis de política = 400 células; p = 6, h = 24, choque = 50bp.

Sem bootstrap (`nboot = 0`): apenas sinais, magnitudes e força de primeiro estágio.
A Etapa 2 (`script/irf_spec_stage2.R`) roda bootstrap completo nas células vencedoras.

## Critérios

- **Régua de força: ξ_mp** (Montiel Olea-Stock-Watson), o Wald na direção do
  impacto da mp_var, com correção Shat. Conjunto AR limitado sse ξ_mp > 3,84;
  bandas convencionais aproximadamente válidas a partir de ξ_mp ≥ 10.
  O `f_robust_mp` é o primeiro estágio HC1 na mesma direção e é reportado
  como diagnóstico complementar, sem condicionar a inferência a pré-teste.
  Na rodada corrente, a célula de produção
  (5,5) full fica abaixo da referência convencional de 10; o valor
  exato consta na tabela abaixo. Ela permanece fixada por decisão anterior ao resultado,
  sem otimização ex post do par (r,q).
- **Diagnósticos reportados que NÃO classificam** (B4, 2026-07-28): as colunas
  `yield_ordering_ok` e `magnitude_flag` são calculadas por célula e gravadas no
  CSV, mas não entram em `classify_sweep_cells`. `yield_ordering_ok` exige
  |6m| ≥ |2y| ≥ |5y| no impacto e é **FALSE na
  célula de produção**, porque o pico da curva está nos vértices longos, não no
  vértice de política normalizado em +50,0bp. Promovê-la a
  critério classificaria a própria produção como falha; ela é evidência sobre o
  *choque* (hipótese H3 de `diagnostics/diagnostico_dfm.md`), não critério de
  descarte de célula.
- **score_hard** (h=0): yield_6m +, yield_2y +, yield_5y +, asset_ibov −;
  a própria mp_var é excluída do score (impacto mecânico pela normalização).
- **score_ext** (h=24): price_ipca −, pib −, vendas_varejo −.
- **soft** (registrado, não penalizado): cambio_usd, cds_5y, embi_perc —
  depreciação + abertura de risco = canal de dominância fiscal (ver irf_section.md).
- **Taxonomia de falha** (primeira que casa): `negative_control` (juros_selic),
  `weak_xi_mp_severe` (ξ_mp < 3,84 — conjunto AR ilimitado),
  `weak_xi_mp` (ξ_mp < 10 — bandas convencionais inválidas),
  `unstable_normalization` (denominador da normalização < 10% da mediana do grupo),
  `sign_puzzle` (força ok mas sinais hard errados), `ok`.

## Top-10 células elegíveis (failure_class = ok)

| sample | r | q | instrument | mp_var | wald_mp | f_robust_mp | score_hard | n_hard_avail | score_ext | fx_channel | risk_channel | yield_ordering_ok | h0_ibov | h0_cambio |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| pre_covid |     7 |     6 | z_bruto_purif | yield_6m | 22.24 | 13.54 |     3 |     3 |     3 | apreciacao | fiscal_dominance | FALSE | -2.754 | -0.02078 |
| pre_covid |     7 |     6 | z_bruto | yield_6m | 21.76 |    13 |     3 |     3 |     3 | apreciacao | fiscal_dominance | FALSE | -2.774 | -0.02056 |
| pre_covid |     7 |     6 | z_bruto_purif | yield_3m | 21.12 | 13.73 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -3.483 | -0.02628 |
| pre_covid |     7 |     6 | z_bruto | yield_3m | 20.62 | 13.16 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -3.514 | -0.02604 |
| pre_covid |     7 |     6 | z_bs_purif | yield_6m |  19.9 | 12.18 |     3 |     3 |     3 | apreciacao | fiscal_dominance | FALSE | -2.822 | -0.02881 |
| pre_covid |     7 |     6 | z_bruto_purif | yield_1y | 19.86 | 9.579 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -2.473 | -0.01866 |
| pre_covid |     7 |     6 | z_bruto | yield_1y | 19.58 | 9.273 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -2.488 | -0.01844 |
| pre_covid |     7 |     6 | z_bs_purif | yield_3m | 19.06 | 12.41 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -3.58 | -0.03655 |
| pre_covid |     7 |     6 | z_jk_bs_purif | yield_1y | 18.43 | 12.29 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -4.411 | 0.06465 |
| pre_covid |     6 |     5 | z_bruto_purif | yield_3m | 18.07 | 11.84 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -10.6 | -0.01611 |

## ξ_mp por instrumento x (r,q) — régua de decisão

Ao contrário da max-F, ξ_mp **depende** da mp_var (é o Wald na direção do
impacto dela); as tabelas abaixo saem das células com mp_var = yield_6m e
por isso são comparáveis a `output/instrument/mosw_strength_grid.csv`.
Limiares MOSW: 3,84 (AR limitado) e 10 (bandas convencionais).

### Amostra full

| instrument | r5_q4 | r5_q5 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|---|
| z_bruto | 3.381 | 5.271 | 2.992 | 5.731 | 6.689 |
| z_bruto_purif | 3.239 | 5.067 | 2.692 | 5.183 | 6.185 |
| z_jk | 4.471 | 4.084 | 4.009 | 4.001 | 4.143 |
| z_jk_purif | 4.357 |  3.98 | 3.781 | 3.707 | 3.941 |
| z_jk_raw_purif | 4.608 | 6.343 | 4.858 | 8.246 | 10.73 |
| z_jk_raw | 4.964 | 6.494 | 5.068 | 8.178 | 10.49 |
| z_bs_purif | 2.865 | 4.368 | 2.123 | 4.358 | 4.804 |
| z_jk_bs_purif | 4.807 | 6.271 | 4.715 | 7.796 | 10.53 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r5_q5 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|---|
| z_bruto | 13.04 | 14.86 | 17.41 | 21.76 | 9.687 |
| z_bruto_purif | 13.25 | 15.13 | 17.92 | 22.24 | 9.568 |
| z_jk | 9.171 | 7.425 | 11.34 | 16.96 | 4.941 |
| z_jk_purif | 9.272 | 7.552 | 11.79 | 17.34 | 4.719 |
| z_jk_raw_purif |  12.5 | 11.31 | 15.01 | 17.13 | 9.584 |
| z_jk_raw | 12.26 | 11.02 | 14.49 | 16.67 | 9.303 |
| z_bs_purif | 12.22 | 13.98 | 16.69 |  19.9 | 8.145 |
| z_jk_bs_purif | 12.51 | 10.99 |  15.8 | 17.92 | 9.102 |

## F robusto por instrumento x (r,q)

Primeiro estágio HC1 de c_mp'η_t sobre o instrumento e as defasagens dos
fatores. Usa a mesma direção de normalização de ξ_mp e depende da mp_var.
As tabelas abaixo fixam mp_var = yield_6m.

### Amostra full

| instrument | r5_q4 | r5_q5 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|---|
| z_bruto | 3.294 | 5.611 | 2.532 | 4.714 | 4.911 |
| z_bruto_purif | 3.123 | 5.278 | 2.251 |  4.18 | 4.471 |
| z_jk | 6.173 | 5.772 |  4.02 |  3.95 | 3.798 |
| z_jk_purif | 5.867 | 5.446 | 3.689 | 3.536 | 3.518 |
| z_jk_raw_purif | 6.578 | 10.99 | 4.968 | 9.581 | 12.67 |
| z_jk_raw | 7.229 | 11.27 |  5.16 | 9.287 | 11.94 |
| z_bs_purif | 2.658 | 4.322 | 1.737 | 3.424 | 3.374 |
| z_jk_bs_purif |  6.61 | 10.12 | 4.582 | 8.366 | 11.41 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r5_q5 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|---|
| z_bruto | 7.193 | 9.706 | 10.47 |    13 | 7.164 |
| z_bruto_purif | 7.395 | 9.974 | 10.87 | 13.54 | 7.016 |
| z_jk | 11.37 | 8.316 | 12.51 | 16.59 | 2.636 |
| z_jk_purif | 11.23 | 8.371 | 13.08 | 18.13 | 2.676 |
| z_jk_raw_purif | 13.14 | 11.83 | 11.85 | 13.91 |  5.29 |
| z_jk_raw | 13.02 | 11.33 | 11.66 | 12.87 | 4.887 |
| z_bs_purif | 6.738 | 9.098 | 10.24 | 12.18 | 5.759 |
| z_jk_bs_purif | 11.48 | 9.747 |  11.1 | 12.63 | 4.978 |

## Taxonomia de falhas

| failure_class | full | pre_covid |
|---|---|---|
| negative_control |    40 |    40 |
| ok |     6 |   107 |
| weak_xi_mp |   123 |    48 |
| weak_xi_mp_severe |    31 |     5 |

## Controle negativo (juros_selic)

`juros_selic` (Selic overnight acumulada, escala percent) é mantido como controle negativo documentado — espera-se F robusto baixo (mismatch de maturidade, ver `registro/justificativa_uso_yield-6m.md`).

| n | f_robust_mp_max | f_robust_mp_median |
|---|---|---|
|    80 |  16.4 | 2.736 |

## Canais cambial e de risco nas células elegíveis

| fx_channel | risk_channel | n |
|---|---|---|
| apreciacao | fiscal_dominance |    20 |
| depreciacao | fiscal_dominance |    93 |

## Instrumento de produção (z_jk_bs_purif x yield_6m) através do grid

`z_jk_bs_purif` é o `DEFAULT_VARIANT` desde 2026-07-15 e a produção é (r=5, q=5). ξ_mp e F robusto usam a mesma direção de normalização; a taxonomia permanece governada por ξ_mp.

| sample | r | q | wald_mp | f_robust_mp | impact_mp_pre | denom_ratio | score_hard | n_hard_avail | score_ext | fx_channel | failure_class |
|---|---|---|---|---|---|---|---|---|---|---|---|
| full |     5 |     4 | 4.807 |  6.61 | 5.443e-05 | 1.155 |     3 |     3 |     1 | depreciacao | weak_xi_mp |
| full |     5 |     5 | 6.271 | 10.12 | 8.426e-05 | 1.788 |     3 |     3 |     2 | depreciacao | weak_xi_mp |
| full |     6 |     5 | 4.715 | 4.582 | 4.898e-05 | 1.039 |     3 |     3 |     3 | depreciacao | weak_xi_mp |
| full |     7 |     6 | 7.796 | 8.366 | 6.899e-05 | 1.464 |     3 |     3 |     3 | depreciacao | weak_xi_mp |
| full |     8 |     8 | 10.53 | 11.41 | 7.902e-05 | 1.677 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     5 |     4 | 12.51 | 11.48 | 7.895e-05 | 1.198 |     3 |     3 |     0 | depreciacao | ok |
| pre_covid |     5 |     5 | 10.99 | 9.747 | 8.054e-05 | 1.222 |     3 |     3 |     0 | depreciacao | ok |
| pre_covid |     6 |     5 |  15.8 |  11.1 | 7.495e-05 | 1.137 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     7 |     6 | 17.92 | 12.63 | 7.272e-05 | 1.103 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     8 |     8 | 9.102 | 4.978 | 4.417e-05 | 0.6701 |     3 |     3 |     1 | depreciacao | weak_xi_mp |

