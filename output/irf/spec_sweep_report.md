# Varredura de especificações IRF — Etapa 1 (ponto-estimativa)

Gerado por `script/irf_spec_sweep.R` em 2026-08-25.

Grid: 2 amostras x 5 combinações (r,q) x 8 instrumentos x 5 variáveis de política = 400 células; p = 4, h = 24, choque = 50bp.

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
| pre_covid |     7 |     6 | z_bruto_purif | yield_3m | 12.29 | 10.17 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -2.661 | 0.007061 |
| pre_covid |     7 |     6 | z_bruto | yield_3m | 11.83 | 9.649 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -2.527 | 0.006014 |
| pre_covid |     7 |     6 | z_bs_purif | yield_3m |  11.7 | 9.362 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -2.783 | 0.007776 |
| pre_covid |     6 |     5 | z_jk_bs_purif | yield_3m | 11.54 | 13.46 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -10.7 | 0.08506 |
| pre_covid |     6 |     5 | z_bruto_purif | yield_3m |  11.5 | 11.28 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -5.29 | -0.0272 |
| pre_covid |     6 |     5 | z_jk_bs_purif | yield_6m | 11.35 | 13.86 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -8.193 | 0.06515 |
| pre_covid |     7 |     6 | z_bruto_purif | yield_6m | 11.16 | 9.022 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -2.178 | 0.00578 |
| pre_covid |     6 |     5 | z_bruto | yield_3m | 11.06 | 10.77 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -5.163 | -0.02757 |
| pre_covid |     6 |     5 | z_bs_purif | yield_3m | 10.95 | 10.33 |     4 |     4 |     3 | apreciacao | fiscal_dominance | FALSE | -5.679 | -0.03173 |
| pre_covid |     7 |     6 | z_bruto | yield_6m | 10.78 | 8.554 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -2.074 | 0.004936 |

## ξ_mp por instrumento x (r,q) — régua de decisão

Ao contrário da max-F, ξ_mp **depende** da mp_var (é o Wald na direção do
impacto dela); as tabelas abaixo saem das células com mp_var = yield_6m e
por isso são comparáveis a `output/instrument/mosw_strength_grid.csv`.
Limiares MOSW: 3,84 (AR limitado) e 10 (bandas convencionais).

### Amostra full

| instrument | r5_q4 | r5_q5 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|---|
| z_bruto | 2.791 | 4.255 | 3.433 | 5.604 | 6.017 |
| z_bruto_purif | 2.713 | 4.105 | 3.234 | 5.211 | 5.803 |
| z_jk |  3.47 | 3.503 | 3.458 | 3.796 | 3.606 |
| z_jk_purif | 3.394 | 3.404 | 3.307 | 3.547 | 3.456 |
| z_jk_raw_purif | 4.313 | 5.285 | 4.779 | 6.564 | 7.089 |
| z_jk_raw | 4.539 | 5.384 |  4.89 | 6.557 | 6.978 |
| z_bs_purif | 2.293 | 3.563 |  2.66 | 4.739 | 5.171 |
| z_jk_bs_purif | 4.357 |  5.24 | 4.606 | 6.276 | 7.046 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r5_q5 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|---|
| z_bruto | 6.501 | 6.584 | 10.34 | 10.78 | 8.943 |
| z_bruto_purif |  6.73 | 6.843 |  10.7 | 11.16 |  9.27 |
| z_jk | 6.275 | 5.521 | 8.718 | 10.15 |   6.2 |
| z_jk_purif | 6.549 | 5.874 | 9.175 | 10.52 | 6.916 |
| z_jk_raw_purif | 8.022 | 7.617 | 10.44 | 9.994 | 9.271 |
| z_jk_raw | 7.604 | 7.128 |    10 | 9.551 | 8.655 |
| z_bs_purif | 6.248 | 6.396 |  10.1 | 10.48 | 8.808 |
| z_jk_bs_purif | 7.976 | 7.478 | 11.35 | 10.67 | 9.401 |

## F robusto por instrumento x (r,q)

Primeiro estágio HC1 de c_mp'η_t sobre o instrumento e as defasagens dos
fatores. Usa a mesma direção de normalização de ξ_mp e depende da mp_var.
As tabelas abaixo fixam mp_var = yield_6m.

### Amostra full

| instrument | r5_q4 | r5_q5 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|---|
| z_bruto | 3.224 | 5.485 | 4.083 | 6.587 | 7.249 |
| z_bruto_purif | 3.097 | 5.172 | 3.747 | 5.924 | 6.764 |
| z_jk | 5.172 | 5.431 | 4.871 | 5.276 | 5.027 |
| z_jk_purif | 4.925 | 5.085 | 4.437 | 4.642 | 4.551 |
| z_jk_raw_purif | 7.586 | 11.02 | 8.446 | 12.03 | 15.01 |
| z_jk_raw | 8.119 | 11.28 | 8.698 | 11.85 | 14.32 |
| z_bs_purif | 2.477 | 4.169 | 2.894 |  5.11 | 5.635 |
| z_jk_bs_purif | 7.298 | 10.06 | 7.525 | 10.56 | 13.36 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r5_q5 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|---|
| z_bruto | 6.123 | 6.662 | 9.759 | 8.554 | 9.269 |
| z_bruto_purif | 6.351 | 6.938 | 10.18 | 9.022 | 9.734 |
| z_jk | 10.78 | 8.828 | 12.63 | 11.51 | 3.732 |
| z_jk_purif | 11.05 | 9.358 | 13.63 | 12.77 | 4.316 |
| z_jk_raw_purif | 15.48 | 14.61 | 14.32 | 11.48 | 6.272 |
| z_jk_raw | 14.67 | 13.46 | 13.73 | 10.84 | 5.732 |
| z_bs_purif | 5.647 | 6.162 | 9.312 | 8.222 | 9.126 |
| z_jk_bs_purif | 13.14 | 11.87 | 13.86 | 10.86 | 5.834 |

## Taxonomia de falhas

| failure_class | full | pre_covid |
|---|---|---|
| negative_control |    40 |    40 |
| weak_xi_mp |   112 |   128 |
| weak_xi_mp_severe |    48 |     4 |
| ok |     0 |    26 |
| sign_puzzle |     0 |     2 |

## Controle negativo (juros_selic)

`juros_selic` (Selic overnight acumulada, escala percent) é mantido como controle negativo documentado — espera-se F robusto baixo (mismatch de maturidade, ver `registro/justificativa_uso_yield-6m.md`).

| n | f_robust_mp_max | f_robust_mp_median |
|---|---|---|
|    80 | 18.98 | 5.308 |

## Canais cambial e de risco nas células elegíveis

| fx_channel | risk_channel | n |
|---|---|---|
| apreciacao | fiscal_dominance |     6 |
| depreciacao | fiscal_dominance |    20 |

## Instrumento de produção (z_jk_bs_purif x yield_6m) através do grid

`z_jk_bs_purif` é o `DEFAULT_VARIANT` desde 2026-07-15 e a produção é (r=5, q=5). ξ_mp e F robusto usam a mesma direção de normalização; a taxonomia permanece governada por ξ_mp.

| sample | r | q | wald_mp | f_robust_mp | impact_mp_pre | denom_ratio | score_hard | n_hard_avail | score_ext | fx_channel | failure_class |
|---|---|---|---|---|---|---|---|---|---|---|---|
| full |     5 |     4 | 4.357 | 7.298 | 6.977e-05 | 0.9928 |     3 |     3 |     1 | depreciacao | weak_xi_mp |
| full |     5 |     5 |  5.24 | 10.06 | 0.0001013 | 1.442 |     3 |     3 |     2 | depreciacao | weak_xi_mp |
| full |     6 |     5 | 4.606 | 7.525 | 7.517e-05 |  1.07 |     2 |     3 |     3 | depreciacao | weak_xi_mp |
| full |     7 |     6 | 6.276 | 10.56 | 0.0001052 | 1.497 |     3 |     3 |     3 | depreciacao | weak_xi_mp |
| full |     8 |     8 | 7.046 | 13.36 | 0.0001219 | 1.735 |     3 |     3 |     3 | depreciacao | weak_xi_mp |
| pre_covid |     5 |     4 | 7.976 | 13.14 | 0.0001049 | 1.359 |     3 |     3 |     1 | depreciacao | weak_xi_mp |
| pre_covid |     5 |     5 | 7.478 | 11.87 | 0.0001036 | 1.342 |     3 |     3 |     1 | depreciacao | weak_xi_mp |
| pre_covid |     6 |     5 | 11.35 | 13.86 | 0.0001008 | 1.306 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     7 |     6 | 10.67 | 10.86 | 8.572e-05 |  1.11 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     8 |     8 | 9.401 | 5.834 | 6.652e-05 | 0.8614 |     3 |     3 |     3 | depreciacao | weak_xi_mp |

