# Varredura de especificações IRF — Etapa 1 (ponto-estimativa)

Gerado por `script/irf_spec_sweep.R` em 2026-07-24.

Grid: 2 amostras x 4 combinações (r,q) x 12 instrumentos x 5 variáveis de política = 480 células; p = 6, h = 24, choque = 50bp.

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
| full |     6 |     5 | z_jk_purif | yield_3m | 12.84 | 4.288 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -17.3 | 0.4501 |
| full |     6 |     5 | z_jk_purif | yield_6m | 12.84 | 11.33 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -8.923 | 0.2321 |
| full |     6 |     5 | z_jk_purif | yield_1y | 12.84 | 11.32 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -5.609 | 0.1459 |
| full |     6 |     5 | z_jk_purif | yield_2y | 12.84 | 14.48 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -4.122 | 0.1072 |
| full |     7 |     6 | z_jk_purif | yield_3m | 11.08 | 4.288 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -16.83 | 0.4799 |
| full |     7 |     6 | z_jk_purif | yield_6m | 11.08 | 11.33 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -8.702 | 0.2481 |
| full |     7 |     6 | z_jk_purif | yield_1y | 11.08 | 11.32 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -5.486 | 0.1564 |
| full |     7 |     6 | z_jk_purif | yield_2y | 11.08 | 14.48 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -4.007 | 0.1143 |
| full |     6 |     5 | z_jk | yield_3m |  10.9 | 5.219 |     4 |     4 |     3 | depreciacao | fiscal_dominance | FALSE | -14.31 | 0.4218 |
| full |     6 |     5 | z_jk | yield_6m |  10.9 | 13.36 |     3 |     3 |     3 | depreciacao | fiscal_dominance | FALSE | -7.541 | 0.2223 |

## F (factor-space) por instrumento x (r,q)

F não depende da mp_var (só das inovações fatoriais e do instrumento);
tabelas extraídas das células com mp_var = yield_6m. Limiar Stock-Yogo ~ 10.

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
| z_het | 3.864 | 2.855 | 2.709 | 2.567 |
| z_het_jk | 6.145 | 8.903 | 6.159 | 3.129 |
| z_het_3var | 2.358 | 1.574 | 1.348 | 3.677 |
| z_het_jk_3var | 2.131 | 4.547 | 2.899 | 4.069 |

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
| z_het | 2.712 | 1.051 | 4.933 | 4.954 |
| z_het_jk | 4.081 | 1.375 | 4.194 | 1.557 |
| z_het_3var | 6.141 | 3.555 | 10.36 | 5.918 |
| z_het_jk_3var | 6.186 | 2.947 | 4.328 | 2.428 |

## Taxonomia de falhas

| failure_class | full | pre_covid |
|---|---|---|
| negative_control |    48 |    48 |
| ok |    16 |     0 |
| weak_factor_space |    92 |    64 |
| weak_factor_space_severe |    84 |   124 |
| sign_puzzle |     0 |     4 |

## Controle negativo (juros_selic)

`juros_selic` (Selic overnight acumulada, escala percent) é mantido como controle negativo documentado — espera-se F reduzido baixo (mismatch de maturidade, ver `_instrucoes/justificativa_uso_yield-6m.md`).

| n | f_reduced_max | f_reduced_median |
|---|---|---|
|    96 |  2.49 | 0.4411 |

## Canais cambial e de risco nas células elegíveis

| fx_channel | risk_channel | n |
|---|---|---|
| depreciacao | fiscal_dominance |    16 |

## z_jk_purif x yield_6m através do grid (decisão r=7,q=6 vs r=5,q=4 do HANDOFF)

| sample | r | q | f_factor | f_reduced | impact_mp_pre | denom_ratio | score_hard | n_hard_avail | score_ext | fx_channel | failure_class |
|---|---|---|---|---|---|---|---|---|---|---|---|
| full |     5 |     4 | 11.67 | 11.33 | 5.484e-05 | 0.7668 |     3 |     3 |     1 | depreciacao | ok |
| full |     6 |     5 | 12.84 | 11.33 | 7.088e-05 | 0.9911 |     3 |     3 |     3 | depreciacao | ok |
| full |     7 |     6 | 11.08 | 11.33 | 6.48e-05 | 0.9061 |     3 |     3 |     3 | depreciacao | ok |
| full |     8 |     8 |  9.95 | 11.33 | 5.841e-05 | 0.8168 |     3 |     3 |     3 | depreciacao | weak_factor_space |
| pre_covid |     5 |     4 |  7.64 | 31.33 | 7.697e-05 | 1.422 |     3 |     3 |     3 | depreciacao | weak_factor_space |
| pre_covid |     6 |     5 | 6.678 | 31.33 | 6.805e-05 | 1.258 |     3 |     3 |     3 | depreciacao | weak_factor_space |
| pre_covid |     7 |     6 | 7.389 | 31.33 | 6.797e-05 | 1.256 |     3 |     3 |     3 | depreciacao | weak_factor_space |
| pre_covid |     8 |     8 | 4.207 | 31.33 | 2.993e-05 | 0.553 |     3 |     3 |     0 | depreciacao | weak_factor_space_severe |

