# Composição do painel: dominância, redundância e sensibilidade de ξ_mp

Gerado por `script/panel_composition.R` em 2026-08-17.
Célula: r=5, q=5, p=6, `yield_6m`, instrumento `z_jk_bs_purif`.
Baseline ξ_mp: **6.27** full / **10.99** pré-COVID.

## 1. Censo e redundância interna

`n_effective` é a razão de participação dos autovalores da correlação das primeiras diferenças padronizadas: n se o bloco fosse ortogonal, 1 se fosse uma série repetida. `mp_share_pct` é a participação do bloco nos fatores, ponderada pelo peso de cada fator no choque.

| block | domain | n_series | share_pct | pc1_share | n_effective | mean_abs_cor | comm_r2_mean | mp_share_pct |
|---|---|---|---|---|---|---|---|---|
| trabalho | trabalho |   14 | 12.6 | 0.365 |    5 | 0.268 | 0.468 | 10.4 |
| industria | atividade_real |   12 | 10.8 | 0.528 | 3.21 | 0.429 | 0.491 | 9.64 |
| precos | precos |   11 | 9.91 | 0.386 | 4.93 | 0.264 | 0.363 | 3.63 |
| credito | credito_moeda |   10 | 9.01 | 0.357 | 5.24 | 0.261 | 0.349 | 9.58 |
| epu | externo_risco |    8 | 7.21 | 0.326 | 5.62 | 0.186 | 0.0561 | 0.934 |
| acoes | financeiro_domestico |    7 | 6.31 | 0.717 | 1.86 | 0.645 | 0.644 |   14 |
| monetario | credito_moeda |    7 | 6.31 | 0.534 |    3 | 0.433 | 0.435 | 4.21 |
| combustiveis | atividade_real |    6 | 5.41 | 0.397 | 4.07 | 0.247 | 0.313 | 3.13 |
| curva | financeiro_domestico |    6 | 5.41 | 0.755 | 1.64 |  0.7 | 0.703 | 14.5 |
| cambio | financeiro_domestico |    5 |  4.5 | 0.774 | 1.59 | 0.675 | 0.641 | 8.14 |
| energia | atividade_real |    4 |  3.6 | 0.579 | 2.44 | 0.426 | 0.262 | 1.68 |
| expectativas | expectativas |    4 |  3.6 | 0.407 | 3.31 | 0.204 | 0.345 | 3.52 |
| risco_externo | externo_risco |    4 |  3.6 | 0.528 | 2.57 | 0.329 | 0.415 | 5.52 |
| commodities | externo_risco |    3 |  2.7 | 0.548 | 2.47 | 0.321 | 0.286 | 2.85 |
| fiscal | fiscal |    3 |  2.7 | 0.439 | 2.85 | 0.157 | 0.356 | 3.05 |
| atividade_agregada | atividade_real |    2 |  1.8 | 0.632 | 1.87 | 0.263 | 0.439 |  1.4 |
| confianca | atividade_real |    2 |  1.8 | 0.606 | 1.91 | 0.211 | 0.346 | 1.13 |
| vendas | atividade_real |    2 |  1.8 | 0.75 |  1.6 |  0.5 | 0.587 | 1.91 |
| politica | financeiro_domestico |    1 | 0.901 |    1 |    1 |  NaN | 0.475 | 0.795 |

## 2. Participação de cada bloco em cada fator estático (%)

| block | F1 | F2 | F3 | F4 | F5 |
|---|---|---|---|---|---|
| acoes | 2.08 |   16 | 0.122 | 38.9 | 3.03 |
| atividade_agregada | 4.22 | 0.211 | 0.816 | 0.735 | 0.956 |
| cambio | 3.51 | 12.2 | 6.01 | 4.33 | 10.5 |
| combustiveis |  9.3 | 0.457 | 1.76 | 2.01 | 0.577 |
| commodities | 0.133 | 4.41 | 1.06 | 3.84 | 0.731 |
| confianca | 3.79 | 0.0204 | 0.131 | 0.77 | 0.156 |
| credito | 2.03 | 13.9 | 11.3 | 7.54 | 5.05 |
| curva | 0.557 | 25.6 | 6.54 | 8.13 | 4.82 |
| energia | 5.29 | 0.289 | 0.417 | 0.719 | 1.28 |
| epu | 0.338 | 0.843 | 0.403 | 2.63 | 2.36 |
| expectativas | 1.15 | 3.94 | 2.86 | 6.89 | 2.59 |
| fiscal | 0.505 | 4.59 | 3.78 | 2.06 | 0.972 |
| industria |   31 | 0.974 | 4.39 | 4.17 | 1.03 |
| monetario |  2.1 | 0.868 | 30.1 |  1.5 |  2.6 |
| politica | 0.000123 | 0.574 | 3.44 | 1.13 | 1.47 |
| precos | 0.775 | 3.42 | 3.34 | 7.42 | 56.6 |
| risco_externo | 1.77 | 9.07 | 0.285 | 4.11 | 1.67 |
| trabalho |   25 | 2.55 | 22.8 | 2.15 | 3.53 |
| vendas | 6.41 | 0.0892 | 0.528 | 0.962 | 0.0866 |

## 3. Leave-one-block-out sobre ξ_mp

| level | dropped | n_dropped | xi_full | xi_pre_covid | delta_full | delta_pre |
|---|---|---|---|---|---|---|
| bloco | curva |    5 | 4.09 | 5.84 | -2.18 | -5.15 |
| dominio | financeiro_domestico |   18 | 5.95 | 10.3 | -0.321 | -0.653 |
| bloco | politica |    1 | 6.05 | 8.83 | -0.217 | -2.16 |
| bloco | expectativas |    4 | 6.06 | 8.19 | -0.207 | -2.81 |
| dominio | expectativas |    4 | 6.06 | 8.19 | -0.207 | -2.81 |
| bloco | risco_externo |    4 |  6.1 | 10.2 | -0.168 | -0.779 |
| bloco | industria |   12 | 6.15 | 7.85 | -0.117 | -3.14 |
| bloco | atividade_agregada |    2 | 6.23 | 7.72 | -0.0402 | -3.27 |
| dominio | atividade_real |   28 | 6.25 | 7.39 | -0.0239 | -3.6 |
| bloco | vendas |    2 | 6.27 | 10.2 | -0.00553 | -0.754 |
| bloco | trabalho |   14 |  6.3 | 8.01 | 0.0326 | -2.98 |
| dominio | trabalho |   14 |  6.3 | 8.01 | 0.0326 | -2.98 |
| bloco | confianca |    2 | 6.32 |   11 | 0.0507 | 0.0245 |
| bloco | energia |    4 | 6.43 | 12.9 | 0.162 | 1.87 |
| bloco | fiscal |    3 | 6.47 | 9.09 | 0.203 | -1.9 |
| dominio | fiscal |    3 | 6.47 | 9.09 | 0.203 | -1.9 |
| bloco | combustiveis |    6 | 6.58 | 10.3 | 0.305 | -0.672 |
| bloco | precos |   11 | 6.68 |  9.9 | 0.409 | -1.09 |
| dominio | precos |   11 | 6.68 |  9.9 | 0.409 | -1.09 |
| bloco | epu |    8 |  6.7 | 10.2 | 0.426 | -0.762 |
| bloco | credito |   10 | 6.73 | 12.4 | 0.462 | 1.38 |
| bloco | commodities |    3 | 6.74 | 9.03 | 0.467 | -1.97 |
| dominio | externo_risco |   15 | 6.82 |  9.7 | 0.55 | -1.29 |
| bloco | cambio |    5 | 6.92 | 13.3 | 0.649 | 2.33 |
| bloco | monetario |    7 | 6.93 | 9.34 | 0.656 | -1.66 |
| dominio | credito_moeda |   17 |  8.2 | 12.6 | 1.93 | 1.64 |
| bloco | acoes |    7 | 8.55 | 11.4 | 2.28 | 0.456 |

## 4. Leave-one-series-out: as 15 séries mais nocivas quando removidas

| dropped | block | xi_mp | delta | f_robust_mp | impact_mp |
|---|---|---|---|---|---|
| yield_3m | curva | 5.59 | -0.683 | 8.07 | 7.15e-05 |
| expect_focus_pib_ny | expectativas |  5.8 | -0.475 | 9.04 | 8.13e-05 |
| yield_1y | curva | 5.86 | -0.413 | 8.88 | 6.75e-05 |
| expect_focus_selic_ny | expectativas | 5.92 | -0.354 | 9.32 | 7.74e-05 |
| cambio_ars | cambio | 6.04 | -0.232 | 9.66 | 8.35e-05 |
| price_core_ipca_ex0 | precos | 6.05 | -0.218 | 10.2 | 8.64e-05 |
| juros_selic | politica | 6.05 | -0.217 | 9.23 | 8.42e-05 |
| trab_de_1_ano_a_menos_de_2_anos | trabalho | 6.07 | -0.204 | 9.37 | 7.81e-05 |
| yield_2y | curva | 6.07 | -0.202 | 9.38 | 7.31e-05 |
| fiscal_dbgg | fiscal | 6.08 | -0.193 | 9.46 | 8.62e-05 |
| trab_menos_de_1_mes | trabalho | 6.08 | -0.191 | 9.82 | 8.44e-05 |
| ind_caminhoes | industria | 6.12 | -0.153 |  9.8 | 8.36e-05 |
| base_demand_deposit | monetario | 6.13 | -0.145 | 9.88 | 8.4e-05 |
| msci | risco_externo | 6.13 | -0.142 | 9.72 | 8.31e-05 |
| price_ipc | precos | 6.14 | -0.128 | 10.2 | 8.78e-05 |

### As 15 séries que mais elevam ξ_mp quando removidas

| dropped | block | xi_mp | delta | f_robust_mp | impact_mp |
|---|---|---|---|---|---|
| expect_focus_ipca12m | expectativas | 6.74 | 0.471 | 11.9 | 8.53e-05 |
| fiscal_dlsp | fiscal | 6.69 | 0.421 | 11.3 | 9.03e-05 |
| asset_idiv | acoes | 6.67 | 0.401 | 11.2 | 8.71e-05 |
| asset_ibov | acoes | 6.58 | 0.305 |   11 | 8.69e-05 |
| trab_de_1_mes_a_menos_de_1_ano | trabalho | 6.57 | 0.298 | 10.7 | 8.48e-05 |
| expect_focus_cambio_ny | expectativas | 6.48 | 0.205 | 10.6 | 8.43e-05 |
| commodity_agro | commodities | 6.47 | 0.203 | 10.8 | 8.41e-05 |
| base_m2 | monetario | 6.47 | 0.201 | 10.2 | 8.61e-05 |
| asset_ifnc | acoes | 6.46 | 0.193 | 10.7 | 8.52e-05 |
| commodity_energia | commodities | 6.46 | 0.187 | 10.8 | 8.19e-05 |
| credit_outstanding | credito | 6.45 | 0.178 | 10.5 | 9.27e-05 |
| trab_pop_forca_trab | trabalho | 6.45 | 0.177 | 10.7 | 8.76e-05 |
| spread_icc_fisica | credito | 6.42 | 0.153 | 10.5 | 8.5e-05 |
| epu_us | epu | 6.42 | 0.153 | 10.3 | 8.28e-05 |
| trab_pop_ocupada | trabalho | 6.41 | 0.143 | 10.5 | 8.88e-05 |

## 5. Painéis balanceados (teto de k séries por bloco)

| cap | sample | n_series | xi_mp | f_robust_mp | impact_mp | ar_bounded |
|---|---|---|---|---|---|---|
|    2 | full |   38 | 7.43 | 14.1 | 0.00014 | TRUE |
|    2 | pre_covid |   38 | 10.6 | 10.7 | 0.000112 | TRUE |
|    3 | full |   52 | 5.72 | 8.87 | 0.000109 | TRUE |
|    3 | pre_covid |   52 | 11.8 | 12.2 | 8.98e-05 | TRUE |
|    4 | full |   65 | 5.52 | 7.67 | 0.000103 | TRUE |
|    4 | pre_covid |   65 | 7.44 | 6.22 | 7.58e-05 | TRUE |
|    6 | full |   84 | 6.13 | 9.77 | 9.15e-05 | TRUE |
|    6 | pre_covid |   84 | 6.34 | 4.56 | 5.37e-05 | TRUE |
|    8 | full |   96 | 5.96 |  9.7 | 9.08e-05 | TRUE |
|    8 | pre_covid |   96 |  6.7 | 5.14 | 5.69e-05 | TRUE |
