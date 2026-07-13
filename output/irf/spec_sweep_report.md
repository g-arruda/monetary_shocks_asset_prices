# Varredura de especificações IRF — Etapa 1 (ponto-estimativa)

Gerado por `script/irf_spec_sweep.R` em 2026-07-11.

Grid: 2 amostras x 4 combinações (r,q) x 8 instrumentos x 5 variáveis de política = 320 células; p = 6, h = 24, choque = 50bp.

Sem bootstrap (`nboot = 0`): apenas sinais, magnitudes e F de primeiro estágio.
A Etapa 2 (`script/irf_spec_stage2.R`) roda bootstrap completo nas células vencedoras.

## Critérios

- **score_hard** (h=0): yield_6m +, yield_2y +, yield_5y +, asset_ibov −;
  a própria mp_var é excluída do score (impacto mecânico pela normalização).
- **score_ext** (h=24): price_ipca −, pib −, vendas_varejo −.
- **soft** (registrado, não penalizado): cambio_usd, cds_5y, embi_perc —
  depreciação + abertura de risco = canal de dominância fiscal (ver irf_section.md).
- **Taxonomia de falha** (primeira que casa): `negative_control` (juros_selic),
  `weak_factor_space[_severe]` (F factor-space < 10 / < 5),
  `unstable_normalization` (denominador da normalização < 10% da mediana do grupo),
  `sign_puzzle` (F ok mas sinais hard errados), `ok`.

## Top-10 células elegíveis (failure_class = ok)

| sample | r | q | instrument | mp_var | f_factor | f_reduced | score_hard | n_hard_avail | score_ext | fx_channel | risk_channel | yield_ordering_ok | h0_ibov | h0_cambio |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| pre_covid |     6 |     5 | z_jk_purif | yield_3m |  15.4 |  29.3 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -0.1737 | 0.08446 |
| pre_covid |     6 |     5 | z_jk_purif | yield_6m |  15.4 | 31.33 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -0.1402 | 0.06817 |
| pre_covid |     6 |     5 | z_jk_purif | yield_1y |  15.4 | 16.59 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -0.1169 | 0.05683 |
| pre_covid |     6 |     5 | z_jk_purif | yield_2y |  15.4 | 12.95 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -0.09704 | 0.04719 |
| pre_covid |     6 |     5 | z_jk | yield_3m | 15.17 | 27.24 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -0.1768 | 0.08752 |
| pre_covid |     6 |     5 | z_jk | yield_6m | 15.17 | 30.03 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -0.1423 | 0.07044 |
| pre_covid |     6 |     5 | z_jk | yield_1y | 15.17 | 17.38 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -0.118 | 0.0584 |
| pre_covid |     6 |     5 | z_jk | yield_2y | 15.17 |    14 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -0.09736 | 0.04818 |
| full |     8 |     8 | z_jk_purif | yield_3m | 11.76 | 4.288 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -0.1598 | 0.419 |
| full |     8 |     8 | z_jk_purif | yield_6m | 11.76 | 11.33 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -0.09154 |  0.24 |

## F (factor-space) por instrumento x (r,q)

F não depende da mp_var (só das inovações fatoriais e do instrumento);
tabelas extraídas das células com mp_var = yield_6m. Limiar Stock-Yogo ~ 10.

### Amostra full

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 6.258 | 4.822 | 4.186 | 3.783 |
| z_bruto_purif | 6.855 | 6.107 | 5.102 | 4.467 |
| z_jk | 7.718 | 8.271 | 8.407 | 10.25 |
| z_jk_purif | 9.203 | 10.08 | 10.17 | 11.76 |
| z_het | 3.641 | 3.467 | 3.071 | 3.064 |
| z_het_jk | 9.331 | 5.575 | 6.891 | 3.852 |
| z_het_3var | 2.425 | 1.522 | 1.114 |  4.02 |
| z_het_jk_3var | 3.168 | 2.368 | 2.742 | 4.057 |

### Amostra pre_covid (2013-2019)

| instrument | r5_q4 | r6_q5 | r7_q6 | r8_q8 |
|---|---|---|---|---|
| z_bruto | 7.197 | 9.762 | 5.973 |  5.78 |
| z_bruto_purif | 7.702 | 10.38 | 5.789 | 5.628 |
| z_jk | 10.54 | 15.17 | 10.45 | 7.987 |
| z_jk_purif | 10.79 |  15.4 | 9.612 |  8.07 |
| z_het | 2.954 | 3.726 | 4.964 | 4.553 |
| z_het_jk | 3.164 | 4.718 | 2.844 | 4.176 |
| z_het_3var |  7.65 | 10.83 | 9.137 | 6.575 |
| z_het_jk_3var | 5.989 | 11.13 | 3.947 |  2.65 |

## Taxonomia de falhas

| failure_class | full | pre_covid |
|---|---|---|
| negative_control |    32 |    32 |
| ok |    16 |    32 |
| weak_factor_space |    44 |    56 |
| weak_factor_space_severe |    68 |    40 |

## Controle negativo (juros_selic)

`juros_selic` (Selic overnight acumulada, escala percent) é mantido como controle negativo documentado — espera-se F reduzido baixo (mismatch de maturidade, ver `_instrucoes/justificativa_uso_yield-6m.md`).

| n | f_reduced_max | f_reduced_median |
|---|---|---|
|    64 |  2.49 | 0.4411 |

## Canais cambial e de risco nas células elegíveis

| fx_channel | risk_channel | n |
|---|---|---|
| apreciacao | fiscal_dominance |     4 |
| depreciacao | fiscal_dominance |    44 |

## z_jk_purif x yield_6m através do grid (decisão r=7,q=6 vs r=5,q=4 do HANDOFF)

| sample | r | q | f_factor | f_reduced | impact_mp_pre | denom_ratio | score_hard | n_hard_avail | score_ext | fx_channel | failure_class |
|---|---|---|---|---|---|---|---|---|---|---|---|
| full |     5 |     4 | 9.203 | 11.33 | 6.568e-05 | 0.888 |     3 |     3 |     2 | depreciacao | weak_factor_space |
| full |     6 |     5 | 10.08 | 11.33 | 6.591e-05 | 0.8911 |     3 |     3 |     3 | depreciacao | ok |
| full |     7 |     6 | 10.17 | 11.33 | 6.164e-05 | 0.8334 |     3 |     3 |     3 | depreciacao | ok |
| full |     8 |     8 | 11.76 | 11.33 | 6.226e-05 | 0.8417 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     5 |     4 | 10.79 | 31.33 | 9.681e-05 | 0.9381 |     3 |     3 |     2 | depreciacao | ok |
| pre_covid |     6 |     5 |  15.4 | 31.33 | 8.272e-05 | 0.8015 |     3 |     3 |     3 | depreciacao | ok |
| pre_covid |     7 |     6 | 9.612 | 31.33 | 3.707e-05 | 0.3592 |     3 |     3 |     0 | depreciacao | weak_factor_space |
| pre_covid |     8 |     8 |  8.07 | 31.33 | 2.984e-05 | 0.2891 |     1 |     3 |     3 | apreciacao | weak_factor_space |

