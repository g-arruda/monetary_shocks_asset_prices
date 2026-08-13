# Varredura de especificações IRF — Etapa 1 (ponto-estimativa)

Gerado por `script/irf_spec_sweep.R` em 2026-08-13.

Grid: 2 amostras x 4 combinações (r,q) x 8 instrumentos x 5 variáveis de política = 320 células; p = 6, h = 24, choque = 50bp.

Sem bootstrap (`nboot = 0`): apenas sinais, magnitudes e força de primeiro estágio.
A Etapa 2 (`script/irf_spec_stage2.R`) roda bootstrap completo nas células vencedoras.

## Critérios

- **Régua de força: ξ_mp** (Montiel Olea-Stock-Watson), o Wald na direção do
  impacto da mp_var, com correção Shat. Conjunto AR limitado sse ξ_mp > 3,84;
  bandas convencionais aproximadamente válidas a partir de ξ_mp ≥ 10.
  O `f_robust_mp` é o primeiro estágio HC1 na mesma direção e é reportado
  como diagnóstico complementar, sem condicionar a inferência a pré-teste.
  Na rodada corrente, a célula de produção
  (7,6) full tem ξ_mp = 7,65 e, portanto, fica abaixo da referência
  convencional de 10. Ela permanece fixada por decisão anterior ao resultado,
  sem otimização ex post do par (r,q).
- **Diagnósticos reportados que NÃO classificam** (B4, 2026-07-28): as colunas
  `yield_ordering_ok` e `magnitude_flag` são calculadas por célula e gravadas no
  CSV, mas não entram em `classify_sweep_cells`. `yield_ordering_ok` exige
  |6m| ≥ |2y| ≥ |5y| no impacto e é **FALSE na
  célula de produção** e em 58 das 68 células `ok`, porque o pico da curva está em
  2-5 anos (+108,0 / +117,0bp) e não no vértice de política (+50,0bp). Promovê-la a
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
| pre_covid |     7 |     6 | z_bruto_purif | yield_6m | 17.53 | 11.15 |     3 |     3 |     3 | apreciacao | fiscal_dominance | TRUE | -2.489 | -0.01615 |
| pre_covid |     7 |     6 | z_bruto_purif | yield_3m | 17.48 | 12.47 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -2.778 | -0.01803 |
| pre_covid |     7 |     6 | z_bruto | yield_6m | 16.86 | 10.68 |     3 |     3 |     3 | apreciacao | fiscal_dominance | TRUE | -2.514 | -0.01767 |
| pre_covid |     7 |     6 | z_bruto | yield_3m | 16.77 | 11.92 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -2.809 | -0.01974 |
| pre_covid |     7 |     6 | z_bs_purif | yield_3m | 16.16 | 11.38 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -3.088 | -0.0286 |
| pre_covid |     7 |     6 | z_bs_purif | yield_6m | 15.95 | 10.02 |     3 |     3 |     3 | apreciacao | fiscal_dominance | TRUE | -2.769 | -0.02564 |
| pre_covid |     7 |     6 | z_jk_purif | yield_1y | 14.67 | 11.54 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -8.095 | 0.06136 |
| pre_covid |     7 |     6 | z_bruto_purif | yield_1y | 14.28 | 6.892 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -2.454 | -0.01593 |
| pre_covid |     7 |     6 | z_jk | yield_1y | 13.96 | 10.43 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -8.165 | 0.06282 |
| pre_covid |     7 |     6 | z_jk_purif | yield_6m | 13.89 | 11.17 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -9.602 | 0.07278 |

## ξ_mp por instrumento x (r,q) — régua de decisão

Ao contrário da max-F, ξ_mp **depende** da mp_var (é o Wald na direção do
impacto dela); as tabelas abaixo saem das células com mp_var = yield_6m e
por isso são comparáveis a `output/instrument/mosw_strength_grid.csv`.
Limiares MOSW: 3,84 (AR limitado) e 10 (bandas convencionais).

### Amostra full

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 2.969 | 3.326 | 6.481 | 8.039 |
| z_bruto_purif | 2.957 | 3.064 | 5.953 | 7.492 |
| z_jk |  5.74 | 4.963 |  5.63 | 5.137 |
| z_jk_purif | 5.718 | 4.797 | 5.312 | 4.864 |
| z_jk_raw_purif | 4.263 | 4.796 | 7.649 | 11.27 |
| z_jk_raw | 4.677 | 5.038 | 7.694 | 11.11 |
| z_bs_purif | 2.612 | 2.508 | 5.055 | 5.972 |
| z_jk_bs_purif | 4.769 | 4.761 | 7.648 | 11.62 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 8.253 |    11 | 16.86 | 13.22 |
| z_bruto_purif | 8.775 | 11.59 | 17.53 | 13.09 |
| z_jk | 10.74 |  12.5 | 13.05 | 7.607 |
| z_jk_purif | 11.31 | 13.03 | 13.89 | 7.534 |
| z_jk_raw_purif | 7.795 | 9.416 | 10.74 | 8.913 |
| z_jk_raw | 7.509 | 9.256 |  10.1 | 8.819 |
| z_bs_purif | 8.597 | 11.19 | 15.95 | 12.04 |
| z_jk_bs_purif | 7.889 | 10.94 | 11.53 | 9.508 |

## F robusto por instrumento x (r,q)

Primeiro estágio HC1 de c_mp'η_t sobre o instrumento e as defasagens dos
fatores. Usa a mesma direção de normalização de ξ_mp e depende da mp_var.
As tabelas abaixo fixam mp_var = yield_6m.

### Amostra full

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 2.772 | 2.816 | 5.071 | 5.986 |
| z_bruto_purif | 2.762 | 2.571 | 4.605 | 5.487 |
| z_jk | 8.752 | 5.642 | 5.975 | 4.888 |
| z_jk_purif | 8.637 | 5.285 | 5.425 | 4.461 |
| z_jk_raw_purif |  6.04 | 5.315 | 8.269 | 13.29 |
| z_jk_raw | 6.783 | 5.565 | 8.211 |  12.8 |
| z_bs_purif | 2.369 | 2.076 | 3.886 | 4.285 |
| z_jk_bs_purif | 6.854 |  5.13 | 7.955 | 12.44 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 5.162 | 6.065 | 10.68 |  11.5 |
| z_bruto_purif | 5.497 | 6.399 | 11.15 | 11.46 |
| z_jk | 14.04 | 11.64 | 9.992 |   4.2 |
| z_jk_purif | 14.68 | 11.95 | 11.17 | 4.389 |
| z_jk_raw_purif | 7.262 | 6.496 | 6.545 | 3.928 |
| z_jk_raw | 7.048 | 6.587 | 6.122 | 3.787 |
| z_bs_purif | 5.473 | 6.093 | 10.02 | 10.25 |
| z_jk_bs_purif | 6.963 | 6.827 | 6.264 | 4.104 |

## Taxonomia de falhas

| failure_class | full | pre_covid |
|---|---|---|
| negative_control |    32 |    32 |
| ok |     9 |    53 |
| weak_xi_mp |    95 |    71 |
| weak_xi_mp_severe |    24 |     4 |

## Controle negativo (juros_selic)

`juros_selic` (Selic overnight acumulada, escala percent) é mantido como controle negativo documentado — espera-se F robusto baixo (mismatch de maturidade, ver `registro/justificativa_uso_yield-6m.md`).

| n | f_robust_mp_max | f_robust_mp_median |
|---|---|---|
|    64 | 12.04 | 2.717 |

## Canais cambial e de risco nas células elegíveis

| fx_channel | risk_channel | n |
|---|---|---|
| apreciacao | fiscal_dominance |     9 |
| depreciacao | fiscal_dominance |    53 |

## Instrumento de produção (z_jk_bs_purif x yield_6m) através do grid

`z_jk_bs_purif` é o `DEFAULT_VARIANT` desde 2026-07-15 e a produção é (r=7, q=6) desde 2026-07-24. ξ_mp e F robusto usam a mesma direção de normalização; a taxonomia permanece governada por ξ_mp.

| sample | r | q | wald_mp | f_robust_mp | impact_mp_pre | denom_ratio | score_hard | n_hard_avail | score_ext | fx_channel | failure_class |
|---|---|---|---|---|---|---|---|---|---|---|---|
| full |     5 |     4 | 4.769 | 6.854 | 4.004e-05 | 0.9806 |     3 |     3 |     1 | depreciacao | weak_xi_mp |
| full |     6 |     5 | 4.761 |  5.13 | 4.762e-05 | 1.166 |     3 |     3 |     3 | depreciacao | weak_xi_mp |
| full |     7 |     6 | 7.648 | 7.955 | 5.33e-05 | 1.305 |     3 |     3 |     3 | depreciacao | weak_xi_mp |
| full |     8 |     8 | 11.62 | 12.44 | 7.1e-05 | 1.739 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     5 |     4 | 7.889 | 6.963 | 5.588e-05 | 1.176 |     3 |     3 |     1 | depreciacao | weak_xi_mp |
| pre_covid |     6 |     5 | 10.94 | 6.827 | 5.274e-05 |  1.11 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     7 |     6 | 11.53 | 6.264 | 5.056e-05 | 1.064 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     8 |     8 | 9.508 | 4.104 | 3.42e-05 | 0.7197 |     3 |     3 |     2 | depreciacao | weak_xi_mp |

