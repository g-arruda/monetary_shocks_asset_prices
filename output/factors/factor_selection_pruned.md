# Número de fatores no painel podado por correlação: Bai-Ng, Ahn-Horenstein, ABC e Amengual-Watson

Gerado por `script/factor_selection_pruned.R` em 2026-09-10.
**Corpo gerado — não escrever prosa aqui.** A leitura vive em `notas/2026-09-10_poda_correlacao_painel.md`.

## Painéis

Painel atual: produção `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03-01 a 2025-12-01, 115 séries. Os podados saem de `output/panel_experimental/poda_correlacao/pruning_manifest.csv` (`script/panel_pruning.R`). Todos os estimadores leem o objeto BLL da produção, primeiras diferenças padronizadas (T = 165). Grade k = 1..20. ABC: c ∈ (0, 5] com passo 0,01 e subamostras aninhadas n_j = ⌊3N/4⌋..N numa permutação fixa (seed 123). Amengual-Watson BLL com p = 4.

| config | principal | n_series | descartadas |
|---|---|---|---|
| completa_0.90 | TRUE |   106 | cambio_cny, cambio_inr, yield_3m, yield_1y, yield_10y, ind_bens_duraveis, ind_bens_nao_duraveis, asset_idiv, price_inpc |
| completa_0.80 | FALSE |    97 | cambio_eur, cambio_cny, cambio_inr, yield_3m, yield_1y, yield_10y, base_demand_deposit, ind_bens_duraveis, ind_bens_nao_duraveis, trab_employment_south, trab_employment_central_west, trab_pop_forca_trab, asset_idiv, asset_ifnc, asset_imob, embi_perc, price_ipc, price_inpc |
| completa_0.85 | FALSE |    99 | cambio_eur, cambio_cny, cambio_inr, yield_3m, yield_1y, yield_10y, base_demand_deposit, ind_bens_duraveis, ind_bens_nao_duraveis, trab_employment_south, trab_pop_forca_trab, asset_idiv, asset_ifnc, asset_imob, embi_perc, price_inpc |
| completa_0.95 | FALSE |   114 | yield_10y |
| simples_0.90 | FALSE |   103 | cambio_cny, cambio_inr, yield_3m, yield_1y, yield_2y, yield_10y, ind_bens_consumo, ind_bens_duraveis, ind_bens_nao_duraveis, asset_idiv, asset_ifnc, price_inpc |

## Auto-testes

| teste | valor | criterio |
|---|---|---|
| (a) painel atual contra factor_selection_alt_summary.csv: estatísticas iguais |    7 | = 7 de 7 |
| (b) configurações do manifesto que descrevem este painel de produção |    5 | = 5 |
| (c) log V(k) + penalidades contra bai_ng_criteria(apply_bll = TRUE), pior painel | 7.22e-16 | < 1e-10 |

## Regra de leitura pré-registrada

**R1, divergência em relação a Bai-Ng:** D = |ER − IC2| + |GR − IC2| + |ABC-IC*1 − IC2|; podado abaixo do atual → *diminui*; igual → *não muda*; acima → *aumenta*.

**R2, subestimação por correlação intra-bloco:** direção de r̂_IC2 e de q̂_AW(r = 5) do painel atual para o podado; *inalterada* se os dois ficam, *consistente* se nenhum cai e ao menos um sobe, *contrária* se nenhum sobe e ao menos um cai, *mista* no resto.

Só o painel `completa_0.90` decide; os demais são sensibilidade.

## Resultado

IC1-IC3: Bai-Ng BLL. ER, GR: Ahn-Horenstein, Teorema 1, kmax = 20. ABC1, ABC2: IC*1 e IC*2 na permutação principal. AW5: q̂ de Amengual-Watson em r = 5; AW5_std: o mesmo com os resíduos padronizados coluna a coluna (convenção do MATLAB de Stock-Watson); AWIC2: em r = r̂_IC2 do painel.

| painel | n_series | IC1 | IC2 | IC3 | ER | GR | ABC1 | ABC2 | AW5 | AW5_std | AWIC2 | D | d_r | d_q | R1 | R2 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| atual |   115 |     5 |     5 |    20 |     2 |     2 |     9 |     9 |     2 |     2 |     2 |    10 |     0 |     0 | referência | referência |
| completa_0.90 |   106 |     4 |     3 |    11 |     1 |     1 |    11 |    11 |     2 |     2 |     2 |    12 |    -2 |     0 | aumenta | contrária |
| completa_0.80 |    97 |     3 |     3 |     9 |     1 |     1 |     5 |     5 |     2 |     2 |     2 |     6 |    -2 |     0 | diminui | contrária |
| completa_0.85 |    99 |     3 |     3 |    10 |     1 |     1 |     5 |     5 |     2 |     2 |     2 |     6 |    -2 |     0 | diminui | contrária |
| completa_0.95 |   114 |     5 |     5 |    20 |     1 |     1 |     9 |     9 |     2 |     2 |     2 |    12 |     0 |     0 | aumenta | inalterada |
| simples_0.90 |   103 |     4 |     3 |    11 |     1 |     1 |     9 |     9 |     2 |     2 |     2 |    10 |    -2 |     0 | não muda | contrária |

**Vereditos no painel principal `completa_0.90` (N = 106): R1 = aumenta** (D = 12 contra 10 no atual); **R2 = contrária** (r̂_IC2 5 → 3; q̂_AW(r = 5) 2 → 2).

## Amengual-Watson: q̂ por r

`projeto` é o padrão de `amengual_watson()`; `residuos_padronizados` padroniza os resíduos do VAR coluna a coluna antes do Bai-Ng do 2º estágio, como `factor_estimation_ls.m`.

| painel | convencao | r=3 | r=4 | r=5 | r=6 | r=7 | r=8 |
|---|---|---|---|---|---|---|---|
| atual | projeto |    NA |     2 |     2 |     2 |     2 |     2 |
| completa_0.90 | projeto |     2 |     2 |     2 |     2 |     2 |     2 |
| completa_0.80 | projeto |     2 |     2 |     2 |     2 |     2 |     2 |
| completa_0.85 | projeto |     2 |     2 |     2 |     2 |     2 |     2 |
| completa_0.95 | projeto |    NA |     2 |     2 |     2 |     2 |     2 |
| simples_0.90 | projeto |     2 |     2 |     2 |     2 |     2 |     2 |
| atual | residuos_padronizados |    NA |     2 |     2 |     2 |     2 |     3 |
| completa_0.90 | residuos_padronizados |     2 |     2 |     2 |     2 |     2 |     2 |
| completa_0.80 | residuos_padronizados |     2 |     2 |     2 |     2 |     2 |     2 |
| completa_0.85 | residuos_padronizados |     2 |     2 |     2 |     2 |     2 |     2 |
| completa_0.95 | residuos_padronizados |    NA |     2 |     2 |     2 |     2 |     3 |
| simples_0.90 | residuos_padronizados |     2 |     2 |     2 |     2 |     2 |     2 |

### Critério IC2 de Amengual-Watson em r = 5, convenção do projeto

| q | atual | completa_0.90 |
|---|---|---|
|       1 | -0.391671 | -0.378081 |
|       2 | -0.451118 | -0.42563 |
|       3 | -0.450142 | -0.415065 |
|       4 | -0.443688 | -0.399854 |
|       5 | -0.43104 | -0.385017 |

## ABC: intervalos de estabilidade

Intervalo = sequência de c consecutivos com S_c = 0 e o mesmo r̂ na amostra cheia; o escolhido é o primeiro com r̂ < 20. `n_grid` é o número de pontos da grade no intervalo.

| painel | penalidade | r | c_lo | c_hi | n_grid |
|---|---|---|---|---|---|
| atual | IC*1 |    20 |  0.01 |  0.66 |    66 |
| atual | IC*1 |     9 |  0.74 |  0.75 |     2 |
| atual | IC*1 |     5 |  0.93 |  1.03 |    11 |
| atual | IC*1 |     0 |  2.57 |     5 |   244 |
| atual | IC*2 |    20 |  0.01 |  0.59 |    59 |
| atual | IC*2 |     9 |  0.66 |  0.68 |     3 |
| atual | IC*2 |     5 |  0.83 |  0.93 |    11 |
| atual | IC*2 |     0 |  2.29 |     5 |   272 |
| completa_0.90 | IC*1 |    20 |  0.01 |  0.64 |    64 |
| completa_0.90 | IC*1 |    11 |  0.68 |  0.69 |     2 |
| completa_0.90 | IC*1 |     3 |  1.09 |  1.21 |    13 |
| completa_0.90 | IC*1 |     2 |  1.42 |  1.53 |    12 |
| completa_0.90 | IC*1 |     1 |  1.68 |  2.04 |    37 |
| completa_0.90 | IC*1 |     0 |  2.38 |     5 |   263 |
| completa_0.90 | IC*2 |    20 |  0.01 |  0.57 |    57 |
| completa_0.90 | IC*2 |    11 |  0.62 |  0.62 |     1 |
| completa_0.90 | IC*2 |     3 |  0.98 |  1.09 |    12 |
| completa_0.90 | IC*2 |     2 |  1.27 |  1.39 |    13 |
| completa_0.90 | IC*2 |     1 |   1.5 |  1.85 |    36 |
| completa_0.90 | IC*2 |     0 |  2.12 |     5 |   289 |

### Sensibilidade à ordem das colunas: 100 permutações do mesmo fluxo de seed

| penalidade | r_hat | atual | completa_0.90 |
|---|---|---|---|
| IC1 |     1 |     0 |     1 |
| IC1 |     2 |     0 |     1 |
| IC1 |     3 |     7 |    15 |
| IC1 |     4 |     1 |     4 |
| IC1 |     5 |    39 |    37 |
| IC1 |     6 |     1 |     0 |
| IC1 |     7 |     4 |     7 |
| IC1 |     8 |     2 |     0 |
| IC1 |     9 |    45 |    28 |
| IC1 |    11 |     1 |     7 |
| IC2 |     1 |     0 |     1 |
| IC2 |     2 |     0 |     2 |
| IC2 |     3 |     5 |    12 |
| IC2 |     4 |     2 |     5 |
| IC2 |     5 |    39 |    37 |
| IC2 |     6 |     4 |     1 |
| IC2 |     7 |     5 |    11 |
| IC2 |     9 |    45 |    28 |
| IC2 |    11 |     0 |     3 |

## Superfícies ER, GR e IC2, k = 1..10

| k | ER_atual | ER_podado | GR_atual | GR_podado | IC2_atual | IC2_podado |
|---|---|---|---|---|---|---|
|      1 | 1.4498 | 1.6231 | 1.2612 | 1.4241 | -0.091099 | -0.086936 |
|      2 |  1.474 | 1.3036 | 1.3229 | 1.1802 | -0.14401 | -0.1222 |
|      3 | 1.3117 | 1.4299 | 1.2046 | 1.3197 | -0.16691 | -0.14104 |
|      4 | 1.1463 | 1.1467 | 1.0636 | 1.0727 | -0.17404 | -0.13781 |
|      5 | 1.3457 | 1.2225 | 1.2609 | 1.1511 | -0.17655 | -0.1299 |
|      6 | 1.0907 | 1.0801 | 1.0306 |  1.022 | -0.16405 | -0.11354 |
|      7 | 1.1226 | 1.1404 | 1.0634 |  1.082 | -0.14985 | -0.095984 |
|      8 | 1.0589 | 1.0317 | 1.0049 | 0.98033 | -0.13231 | -0.074282 |
|      9 |  1.225 | 1.1974 |  1.167 | 1.1408 | -0.11453 | -0.053593 |
|     10 | 1.0375 | 1.0291 | 0.99196 | 0.98329 | -0.089263 | -0.026539 |

Figura em `factor_selection_pruned.pdf`.
