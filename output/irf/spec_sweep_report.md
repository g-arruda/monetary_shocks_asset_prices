# Varredura de especificações IRF — Etapa 1 (ponto-estimativa)

Gerado por `script/irf_spec_sweep.R` em 2026-07-26.

Grid: 2 amostras x 4 combinações (r,q) x 8 instrumentos x 5 variáveis de política = 320 células; p = 6, h = 24, choque = 50bp.

Sem bootstrap (`nboot = 0`): apenas sinais, magnitudes e força de primeiro estágio.
A Etapa 2 (`script/irf_spec_stage2.R`) roda bootstrap completo nas células vencedoras.

## Critérios

- **Régua de força: ξ_mp** (Montiel Olea-Stock-Watson), o Wald na direção do
  impacto da mp_var, com correção Shat. Conjunto AR limitado sse ξ_mp > 3,84;
  bandas convencionais aproximadamente válidas a partir de ξ_mp ≥ 10.
  A max-F homocedástica legada (`f_factor`) continua reportada para
  continuidade com a varredura de 2026-07-11, mas **não classifica mais**
  (migração de 2026-07-26): sob ela o instrumento de produção nunca era
  elegível — em (7,6) full `z_jk_bs_purif` tem f_factor 6,31 contra ξ_mp 10,43,
  e `z_jk_purif` tem o espelho, 11,08 contra 5,77.
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

| sample | r | q | instrument | mp_var | wald_mp | f_factor | f_reduced | score_hard | n_hard_avail | score_ext | fx_channel | risk_channel | yield_ordering_ok | h0_ibov | h0_cambio |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| pre_covid |     7 |     6 | z_bruto_purif | yield_3m | 17.97 | 6.018 | 69.75 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -2.245 | -0.02025 |
| pre_covid |     7 |     6 | z_bruto_purif | yield_6m | 17.67 | 6.018 | 40.97 |     3 |     3 |     3 | apreciacao | fiscal_dominance | TRUE | -2.055 | -0.01853 |
| pre_covid |     7 |     6 | z_bruto | yield_3m | 17.27 |  5.95 | 67.35 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -2.262 | -0.02178 |
| pre_covid |     7 |     6 | z_bruto | yield_6m | 17.02 |  5.95 | 39.96 |     3 |     3 |     3 | apreciacao | fiscal_dominance | TRUE | -2.068 | -0.01991 |
| pre_covid |     7 |     6 | z_bs_purif | yield_3m | 16.76 | 5.039 | 56.35 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -2.49 | -0.03119 |
| pre_covid |     7 |     6 | z_bs_purif | yield_6m | 16.14 | 5.039 | 33.95 |     3 |     3 |     3 | apreciacao | fiscal_dominance | TRUE | -2.284 | -0.02861 |
| pre_covid |     7 |     6 | z_bruto_purif | yield_1y | 14.13 | 6.018 | 15.55 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -2.077 | -0.01873 |
| pre_covid |     7 |     6 | z_jk_purif | yield_1y | 13.94 | 7.389 | 16.59 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -7.959 | 0.05731 |
| pre_covid |     7 |     6 | z_jk_purif | yield_6m | 13.68 | 7.389 | 31.33 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -9.133 | 0.06576 |
| pre_covid |     7 |     6 | z_bruto | yield_1y | 13.68 |  5.95 |  15.5 |     4 |     4 |     3 | apreciacao | fiscal_dominance | TRUE | -2.091 | -0.02013 |

## ξ_mp por instrumento x (r,q) — régua de decisão

Ao contrário da max-F, ξ_mp **depende** da mp_var (é o Wald na direção do
impacto dela); as tabelas abaixo saem das células com mp_var = yield_6m e
por isso são comparáveis a `output/instrument/mosw_strength_grid.csv`.
Limiares MOSW: 3,84 (AR limitado) e 10 (bandas convencionais).

### Amostra full

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 3.911 | 4.611 | 7.574 | 6.756 |
| z_bruto_purif | 3.703 | 4.053 | 6.621 | 5.752 |
| z_jk |  5.52 | 5.888 | 6.302 | 5.187 |
| z_jk_purif | 5.416 | 5.525 | 5.773 | 4.702 |
| z_jk_raw_purif | 5.017 | 6.356 | 10.39 | 12.19 |
| z_jk_raw | 5.494 | 6.711 | 10.55 | 12.28 |
| z_bs_purif | 3.374 | 3.638 | 6.106 | 4.832 |
| z_jk_bs_purif | 5.445 | 6.356 | 10.43 | 12.57 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 7.948 | 10.68 | 17.02 | 12.21 |
| z_bruto_purif | 8.426 | 11.23 | 17.67 | 12.01 |
| z_jk |  10.7 | 12.16 | 12.84 | 6.695 |
| z_jk_purif |  11.2 | 12.68 | 13.68 | 6.526 |
| z_jk_raw_purif | 7.727 | 9.414 |  11.1 | 8.543 |
| z_jk_raw | 7.509 | 9.305 | 10.45 | 8.455 |
| z_bs_purif | 8.209 | 10.77 | 16.14 | 10.86 |
| z_jk_bs_purif | 7.945 |    11 | 12.22 | 8.986 |

## F (factor-space) por instrumento x (r,q) — régua legada

Max-F homocedástica entre as q regressões fatoriais. Mantida só para
comparabilidade com a varredura de 2026-07-11; **não classifica**. F não
depende da mp_var, então uma tabela por amostra basta.

### Amostra full

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 6.609 | 6.054 | 4.348 | 2.564 |
| z_bruto_purif | 8.079 | 6.588 | 5.487 | 3.126 |
| z_jk |  9.91 |  10.9 | 9.217 | 8.558 |
| z_jk_purif | 11.67 | 12.84 | 11.08 |  9.95 |
| z_jk_raw_purif | 5.305 | 9.359 | 6.585 | 4.023 |
| z_jk_raw | 5.855 | 9.395 | 6.506 | 3.885 |
| z_bs_purif | 6.969 | 5.466 | 4.548 | 2.804 |
| z_jk_bs_purif |  5.52 | 8.648 | 6.313 | 3.995 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 4.331 | 5.292 |  5.95 | 4.934 |
| z_bruto_purif | 4.471 | 5.656 | 6.018 | 4.704 |
| z_jk | 7.684 | 6.738 | 7.197 | 4.386 |
| z_jk_purif |  7.64 | 6.678 | 7.389 | 4.207 |
| z_jk_raw_purif | 3.703 | 3.241 | 3.218 | 3.208 |
| z_jk_raw | 3.725 | 3.525 |  3.24 | 2.978 |
| z_bs_purif | 4.933 | 5.416 | 5.039 | 5.099 |
| z_jk_bs_purif | 3.826 | 3.742 | 3.093 | 2.075 |

## Taxonomia de falhas

| failure_class | full | pre_covid |
|---|---|---|
| negative_control |    32 |    32 |
| ok |    21 |    47 |
| weak_xi_mp |    94 |    68 |
| weak_xi_mp_severe |    13 |    11 |
| sign_puzzle |     0 |     2 |

## Controle negativo (juros_selic)

`juros_selic` (Selic overnight acumulada, escala percent) é mantido como controle negativo documentado — espera-se F reduzido baixo (mismatch de maturidade, ver `_instrucoes/justificativa_uso_yield-6m.md`).

| n | f_reduced_max | f_reduced_median |
|---|---|---|
|    64 | 2.296 | 0.903 |

## Canais cambial e de risco nas células elegíveis

| fx_channel | risk_channel | n |
|---|---|---|
| apreciacao | fiscal_dominance |    10 |
| depreciacao | fiscal_dominance |    58 |

## Instrumento de produção (z_jk_bs_purif x yield_6m) através do grid

`z_jk_bs_purif` é o `DEFAULT_VARIANT` desde 2026-07-15 e a produção é (r=7, q=6) desde 2026-07-24. As duas colunas de força mostram por que a régua importa: as células são elegíveis por ξ_mp, não por f_factor.

| sample | r | q | wald_mp | f_factor | f_reduced | impact_mp_pre | denom_ratio | score_hard | n_hard_avail | score_ext | fx_channel | failure_class |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| full |     5 |     4 | 5.445 |  5.52 | 25.03 | 5.961e-05 | 1.041 |     3 |     3 |     1 | depreciacao | weak_xi_mp |
| full |     6 |     5 | 6.356 | 8.648 | 25.03 | 7.938e-05 | 1.386 |     3 |     3 |     3 | depreciacao | weak_xi_mp |
| full |     7 |     6 | 10.43 | 6.313 | 25.03 | 8.636e-05 | 1.508 |     3 |     3 |     3 | depreciacao | ok |
| full |     8 |     8 | 12.57 | 3.995 | 25.03 | 9.376e-05 | 1.637 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     5 |     4 | 7.945 | 3.826 | 42.09 | 5.531e-05 | 1.147 |     3 |     3 |     3 | depreciacao | weak_xi_mp |
| pre_covid |     6 |     5 |    11 | 3.742 | 42.09 | 5.15e-05 | 1.068 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     7 |     6 | 12.22 | 3.093 | 42.09 | 5.221e-05 | 1.083 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     8 |     8 | 8.986 | 2.075 | 42.09 | 3.22e-05 | 0.6677 |     3 |     3 |     2 | depreciacao | weak_xi_mp |

