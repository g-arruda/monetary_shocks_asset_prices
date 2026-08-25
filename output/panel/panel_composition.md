# Composição do painel: dominância, redundância e sensibilidade de ξ_mp

Gerado por `script/panel_composition.R` em 2026-08-25.
Célula: r=5, q=5, p=4, `yield_6m`, instrumento `z_jk_bs_purif`.
Baseline ξ_mp: **5.24** full / **7.48** pré-COVID.

## 1. Censo e redundância interna

`n_effective` é a razão de participação dos autovalores da correlação das primeiras diferenças padronizadas: n se o bloco fosse ortogonal, 1 se fosse uma série repetida. `mp_share_pct` é a participação do bloco nos fatores, ponderada pelo peso de cada fator no choque.

| block | domain | n_series | share_pct | pc1_share | n_effective | mean_abs_cor | comm_r2_mean | mp_share_pct |
|---|---|---|---|---|---|---|---|---|
| trabalho | trabalho |   14 | 12.6 | 0.365 |    5 | 0.268 | 0.468 | 10.4 |
| industria | atividade_real |   12 | 10.8 | 0.528 | 3.21 | 0.429 | 0.491 | 9.79 |
| precos | precos |   11 | 9.91 | 0.386 | 4.93 | 0.264 | 0.363 | 3.74 |
| credito | credito_moeda |   10 | 9.01 | 0.357 | 5.24 | 0.261 | 0.349 | 9.41 |
| epu | externo_risco |    8 | 7.21 | 0.326 | 5.62 | 0.186 | 0.0561 | 0.974 |
| acoes | financeiro_domestico |    7 | 6.31 | 0.717 | 1.86 | 0.645 | 0.644 | 14.5 |
| monetario | credito_moeda |    7 | 6.31 | 0.534 |    3 | 0.433 | 0.435 | 4.06 |
| combustiveis | atividade_real |    6 | 5.41 | 0.397 | 4.07 | 0.247 | 0.313 | 3.18 |
| curva | financeiro_domestico |    6 | 5.41 | 0.755 | 1.64 |  0.7 | 0.703 | 14.2 |
| cambio | financeiro_domestico |    5 |  4.5 | 0.774 | 1.59 | 0.675 | 0.641 | 7.98 |
| energia | atividade_real |    4 |  3.6 | 0.579 | 2.44 | 0.426 | 0.262 |  1.7 |
| expectativas | expectativas |    4 |  3.6 | 0.407 | 3.31 | 0.204 | 0.345 | 3.58 |
| risco_externo | externo_risco |    4 |  3.6 | 0.528 | 2.57 | 0.329 | 0.415 | 5.44 |
| commodities | externo_risco |    3 |  2.7 | 0.548 | 2.47 | 0.321 | 0.286 | 2.84 |
| fiscal | fiscal |    3 |  2.7 | 0.439 | 2.85 | 0.157 | 0.356 | 2.99 |
| atividade_agregada | atividade_real |    2 |  1.8 | 0.632 | 1.87 | 0.263 | 0.439 | 1.42 |
| confianca | atividade_real |    2 |  1.8 | 0.606 | 1.91 | 0.211 | 0.346 | 1.15 |
| vendas | atividade_real |    2 |  1.8 | 0.75 |  1.6 |  0.5 | 0.587 | 1.95 |
| politica | financeiro_domestico |    1 | 0.901 |    1 |    1 |  NaN | 0.475 | 0.79 |

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
| bloco | curva |    5 | 3.63 | 2.85 | -1.61 | -4.63 |
| dominio | financeiro_domestico |   18 | 4.67 | 6.07 | -0.568 | -1.41 |
| bloco | politica |    1 | 5.04 | 5.88 | -0.202 | -1.6 |
| bloco | expectativas |    4 | 5.09 | 8.38 | -0.153 | 0.902 |
| dominio | expectativas |    4 | 5.09 | 8.38 | -0.153 | 0.902 |
| bloco | risco_externo |    4 | 5.13 | 7.27 | -0.115 | -0.209 |
| bloco | atividade_agregada |    2 | 5.19 | 5.37 | -0.0543 | -2.11 |
| bloco | trabalho |   14 |  5.2 | 6.04 | -0.0451 | -1.44 |
| dominio | trabalho |   14 |  5.2 | 6.04 | -0.0451 | -1.44 |
| bloco | monetario |    7 | 5.21 |  6.8 | -0.0318 | -0.676 |
| bloco | fiscal |    3 | 5.22 | 5.97 | -0.0241 | -1.51 |
| dominio | fiscal |    3 | 5.22 | 5.97 | -0.0241 | -1.51 |
| bloco | confianca |    2 | 5.22 | 8.23 | -0.0209 | 0.756 |
| bloco | energia |    4 | 5.25 | 7.57 | 0.0073 | 0.0877 |
| bloco | vendas |    2 | 5.27 | 7.35 | 0.0304 | -0.129 |
| bloco | combustiveis |    6 | 5.31 |  7.1 | 0.0718 | -0.375 |
| dominio | atividade_real |   28 | 5.39 | 4.24 | 0.151 | -3.23 |
| bloco | industria |   12 | 5.43 | 5.78 | 0.194 | -1.7 |
| bloco | epu |    8 | 5.44 | 7.32 | 0.198 | -0.157 |
| bloco | cambio |    5 | 5.48 | 11.9 | 0.244 | 4.47 |
| bloco | credito |   10 | 5.59 | 10.8 | 0.351 | 3.32 |
| bloco | commodities |    3 | 5.68 | 8.74 | 0.444 | 1.26 |
| dominio | externo_risco |   15 | 5.71 | 8.96 | 0.469 | 1.48 |
| dominio | credito_moeda |   17 | 5.73 | 9.14 | 0.492 | 1.66 |
| bloco | precos |   11 | 5.97 |  7.6 | 0.731 | 0.122 |
| dominio | precos |   11 | 5.97 |  7.6 | 0.731 | 0.122 |
| bloco | acoes |    7 | 6.23 |  8.2 | 0.989 | 0.72 |

## 4. Leave-one-series-out: as 15 séries mais nocivas quando removidas

| dropped | block | xi_mp | delta | f_robust_mp | impact_mp |
|---|---|---|---|---|---|
| yield_3m | curva | 4.75 | -0.492 | 8.54 | 9.03e-05 |
| yield_1y | curva | 4.92 | -0.319 | 9.15 | 8.25e-05 |
| expect_focus_pib_ny | expectativas | 4.94 | -0.299 | 9.16 | 9.75e-05 |
| expect_focus_selic_ny | expectativas | 4.99 | -0.253 | 9.39 | 9.44e-05 |
| fiscal_dbgg | fiscal |    5 | -0.241 | 9.22 | 0.000103 |
| juros_selic | politica | 5.04 | -0.202 | 9.39 | 0.000103 |
| yield_2y | curva |  5.1 | -0.137 | 9.65 | 8.94e-05 |
| trab_tx_desemprego | trabalho |  5.1 | -0.136 | 9.69 | 0.000108 |
| asset_ifix | acoes | 5.14 | -0.102 |  9.7 | 0.0001 |
| credito_comercio | credito | 5.14 | -0.0959 | 9.68 | 0.000107 |
| msci | risco_externo | 5.15 | -0.0872 | 9.81 | 0.0001 |
| cambio_ars | cambio | 5.16 | -0.0813 | 9.87 | 0.000101 |
| credito_construcao | credito | 5.16 | -0.0766 | 9.82 | 0.000108 |
| trab_min_wage | trabalho | 5.17 | -0.074 | 9.85 | 0.0001 |
| price_ipca_difusao | precos | 5.17 | -0.0703 | 9.81 | 0.0001 |

### As 15 séries que mais elevam ξ_mp quando removidas

| dropped | block | xi_mp | delta | f_robust_mp | impact_mp |
|---|---|---|---|---|---|
| expect_focus_ipca12m | expectativas | 5.65 | 0.406 | 11.5 | 0.000101 |
| price_core_ipca_dw | precos | 5.51 | 0.272 | 10.8 | 0.000102 |
| asset_idiv | acoes | 5.49 | 0.248 | 10.8 | 0.000104 |
| fiscal_dlsp | fiscal | 5.49 | 0.247 | 10.9 | 0.000107 |
| price_ipca | precos | 5.45 | 0.208 | 10.8 | 0.0001 |
| trab_de_1_mes_a_menos_de_1_ano | trabalho | 5.44 | 0.203 | 10.5 | 0.000102 |
| asset_imob | acoes | 5.44 | 0.196 | 10.7 | 0.000105 |
| asset_ibov | acoes | 5.42 | 0.18 | 10.7 | 0.000105 |
| commodity_agro | commodities | 5.39 | 0.147 | 10.6 | 0.000101 |
| asset_smll | acoes | 5.39 | 0.147 | 10.5 | 0.000105 |
| commodity_energia | commodities | 5.39 | 0.147 | 10.6 | 9.78e-05 |
| credit_outstanding | credito | 5.38 | 0.142 | 10.5 | 0.00011 |
| asset_ifnc | acoes | 5.38 | 0.141 | 10.6 | 0.000103 |
| commodity_metal | commodities | 5.37 | 0.132 | 10.5 | 9.94e-05 |
| trab_pop_forca_trab | trabalho | 5.36 | 0.117 | 10.4 | 0.000104 |

## 5. Painéis balanceados (teto de k séries por bloco)

| cap | sample | n_series | xi_mp | f_robust_mp | impact_mp | ar_bounded |
|---|---|---|---|---|---|---|
|    2 | full |   38 | 7.07 | 15.6 | 0.000162 | TRUE |
|    2 | pre_covid |   38 | 10.7 | 18.1 | 0.000161 | TRUE |
|    3 | full |   52 | 5.12 | 10.1 | 0.000141 | TRUE |
|    3 | pre_covid |   52 | 8.92 | 14.3 | 0.000126 | TRUE |
|    4 | full |   65 | 5.03 | 8.82 | 0.000131 | TRUE |
|    4 | pre_covid |   65 | 7.38 | 9.77 | 0.000104 | TRUE |
|    6 | full |   84 | 5.25 | 9.99 | 0.000112 | TRUE |
|    6 | pre_covid |   84 |  6.2 | 7.67 | 8.48e-05 | TRUE |
|    8 | full |   96 | 5.28 | 10.1 | 0.000112 | TRUE |
|    8 | pre_covid |   96 | 5.69 | 7.32 | 7.87e-05 | TRUE |
