# Truncamento `q < r`: suficiência do subespaço retido e invariância à la Alessi-Kerssenfischer

Gerado por `script/q_truncation.R` em 2026-09-14.
**Corpo gerado — não escrever prosa aqui.** A leitura vive em `notas/2026-09-10_truncamento_q.md`; a da célula `cheia_p4_lp`, em `notas/2026-09-14_inferencia_volatilidade_covid_q.md`.

## Células

Painel de produção (115 séries), `r = 5`, instrumento `z_jk_bs_purif`, choque de +50 pb em `yield_6m`. `cheia_p4`: 2012-03 a 2025-12, `p = 4`, conjuntos Anderson-Rubin 68/90. `pre_p4`: 2012-03 a 2019-12, `p = 4`, só pontual — o AR é bloqueado ali (`hac_dim` 135 >= T = 90, `output/irf/ar_bands.md`). `pre_p2`: mesma janela, `p = 2`, AR 68/90. `cheia_p4_lp`: a `cheia_p4` com a volatilidade COVID de Lenza-Primiceri (2022) no VAR dos fatores, AR 68/90 na regressão transformada (seção própria abaixo). Os conjuntos AR são construídos só na referência `q = 5`; `ar_bounded_κ` vem de ξ_mp > κ, a condição exata de limitação. `interval_68`/`interval_90`: fração dos conjuntos da referência (115 séries × 49 horizontes) que são intervalos; o único outro tipo é o singleton {0,005} da `yield_6m` em h = 0, que a normalização impõe.

| window_cell | p | q | T_eff | xi_mp | ar_bounded_68 | ar_bounded_90 | ar_bounded_95 | impact_mp_pre | max_root | hac_dim | interval_68 | interval_90 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| cheia_p4 |     4 |     5 |   162 | 6.057 | TRUE | TRUE | TRUE | 9.755e-05 | 0.9701 |   135 | 0.9998 | 0.9998 |
| cheia_p4 |     4 |     4 |   162 | 4.359 | TRUE | TRUE | TRUE | 6.147e-05 | 0.9701 |    NA |    NA |    NA |
| cheia_p4 |     4 |     3 |   162 | 2.105 | TRUE | FALSE | FALSE | 2.351e-05 | 0.9701 |    NA |    NA |    NA |
| cheia_p4 |     4 |     2 |   162 | 2.339 | TRUE | FALSE | FALSE | 2.462e-05 | 0.9701 |    NA |    NA |    NA |
| pre_p4 |     4 |     5 |    90 | 8.643 | TRUE | TRUE | TRUE | 0.0001114 | 0.9934 |    NA |    NA |    NA |
| pre_p4 |     4 |     4 |    90 | 8.803 | TRUE | TRUE | TRUE | 0.00011 | 0.9934 |    NA |    NA |    NA |
| pre_p4 |     4 |     3 |    90 | 8.819 | TRUE | TRUE | TRUE | 0.0001102 | 0.9934 |    NA |    NA |    NA |
| pre_p4 |     4 |     2 |    90 | 4.905 | TRUE | TRUE | TRUE | 6.771e-05 | 0.9934 |    NA |    NA |    NA |
| pre_p2 |     2 |     5 |    92 | 6.482 | TRUE | TRUE | TRUE | 0.0001242 | 0.9862 |    85 | 0.9998 | 0.9998 |
| pre_p2 |     2 |     4 |    92 | 6.556 | TRUE | TRUE | TRUE | 0.0001239 | 0.9862 |    NA |    NA |    NA |
| pre_p2 |     2 |     3 |    92 | 6.498 | TRUE | TRUE | TRUE | 0.0001245 | 0.9862 |    NA |    NA |    NA |
| pre_p2 |     2 |     2 |    92 | 3.958 | TRUE | TRUE | TRUE | 8.786e-05 | 0.9862 |    NA |    NA |    NA |
| cheia_p4_lp |     4 |     5 |   162 | 6.848 | TRUE | TRUE | TRUE | 8.825e-05 | 0.9837 |   135 | 0.9998 | 0.9998 |
| cheia_p4_lp |     4 |     4 |   162 | 6.459 | TRUE | TRUE | TRUE | 6.743e-05 | 0.9837 |    NA |    NA |    NA |
| cheia_p4_lp |     4 |     3 |   162 | 5.143 | TRUE | TRUE | TRUE | 3.9e-05 | 0.9837 |    NA |    NA |    NA |
| cheia_p4_lp |     4 |     2 |   162 | 5.124 | TRUE | TRUE | TRUE | 3.908e-05 | 0.9837 |    NA |    NA |    NA |

## T1 — o instrumento é ortogonal às direções que o truncamento descarta?

Wald conjunto de z contra as direções `q+1..5` dos autovetores de `cov(u)` da célula `q = 5` (na `cheia_p4_lp`, do segundo momento não centrado de `u_t/s_t`, que é o que K lê ali), χ²(5 − q), nível 5%. Com `q` choques e instrumento válido, a ortogonalidade vale.

| window_cell | q | t1_wald | t1_df | t1_p |
|---|---|---|---|---|
| cheia_p4 |     2 |  7.78 |     3 | 0.05078 |
| cheia_p4 |     3 | 6.504 |     2 | 0.0387 |
| cheia_p4 |     4 | 5.876 |     1 | 0.01535 |
| pre_p4 |     2 | 4.459 |     3 | 0.216 |
| pre_p4 |     3 | 1.277 |     2 | 0.5281 |
| pre_p4 |     4 | 0.4916 |     1 | 0.4832 |
| pre_p2 |     2 | 2.072 |     3 | 0.5576 |
| pre_p2 |     3 | 0.09519 |     2 | 0.9535 |
| pre_p2 |     4 | 0.03971 |     1 | 0.8421 |
| cheia_p4_lp |     2 | 4.611 |     3 | 0.2026 |
| cheia_p4_lp |     3 | 4.433 |     2 | 0.109 |
| cheia_p4_lp |     4 | 3.323 |     1 | 0.06832 |

## T2 — invariância pela regra de `containment_vs_production()` (115 séries, h = 0..48)

Referência: a célula `q = 5` da mesma janela, com seus conjuntos AR de 90%. *imaterial*: dentro da banda em todo h e `cor_path` > 0,95; *material*: sai da banda ou troca o sinal em h = 0. `asset_ibov` está nas contagens; ver `q_truncation_containment.csv`.

| window_cell | q | imaterial | parcial | material | median_cor_path |
|---|---|---|---|---|---|
| pre_p2 |     4 |   115 |     0 |     0 | 0.9999 |
| pre_p2 |     3 |   115 |     0 |     0 |     1 |
| pre_p2 |     2 |   100 |    10 |     5 | 0.9861 |
| cheia_p4_lp |     4 |    57 |    35 |    23 | 0.9655 |
| cheia_p4_lp |     3 |    23 |    17 |    75 | 0.9636 |
| cheia_p4_lp |     2 |    21 |    17 |    77 | 0.962 |
| cheia_p4 |     4 |     0 |    21 |    94 | 0.6292 |
| cheia_p4 |     3 |     0 |     0 |   115 | 0.3341 |
| cheia_p4 |     2 |     0 |     0 |   115 | 0.3443 |

## Destaque: resposta pontual em h = 0, 12 e 24

| window_cell | variable | h | q=5 | q=4 | q=3 | q=2 |
|---|---|---|---|---|---|---|
| cheia_p4 | yield_6m |     0 | 0.005 | 0.005 | 0.005 | 0.005 |
| cheia_p4 | yield_6m |    12 | 0.004023 | 0.01002 | 0.007117 | 0.008887 |
| cheia_p4 | yield_6m |    24 | -0.005181 | 0.005763 | 0.007989 | 0.009401 |
| cheia_p4 | yield_2y |     0 | 0.007026 | 0.008974 | 0.01538 | 0.01504 |
| cheia_p4 | yield_2y |    12 | 0.002859 | 0.01195 | 0.01363 | 0.01548 |
| cheia_p4 | yield_2y |    24 | -0.007437 | 0.004912 | 0.007227 | 0.008759 |
| cheia_p4 | cambio_usd |     0 | 0.1342 | 0.2671 | 0.5342 | 0.4529 |
| cheia_p4 | cambio_usd |    12 | -0.03822 | 0.1066 | 0.3897 | 0.388 |
| cheia_p4 | cambio_usd |    24 | -0.09399 | -0.03096 | 0.006912 | 0.01007 |
| cheia_p4 | cds_5y |     0 | 29.91 | 47.19 | 126.9 | 118.9 |
| cheia_p4 | cds_5y |    12 | 1.631 | 25.13 | 57.49 | 59.28 |
| cheia_p4 | cds_5y |    24 | -17.08 | 3.161 | 13.37 | 15.08 |
| cheia_p4 | price_ipca |     0 | -0.04363 | -0.07057 | -0.2092 | 0.1085 |
| cheia_p4 | price_ipca |    12 | -0.1132 | 0.1918 | 0.288 | 0.3346 |
| cheia_p4 | price_ipca |    24 | -0.2647 | -0.03162 | -0.1492 | -0.1127 |
| cheia_p4 | ibc_br |     0 | -0.6304 | -0.9902 | -2.649 | -2.569 |
| cheia_p4 | ibc_br |    12 | -0.2947 | 0.1193 | -0.6362 | -0.5306 |
| cheia_p4 | ibc_br |    24 | -0.4294 | -0.05741 | -0.5916 | -0.5041 |
| pre_p4 | yield_6m |     0 | 0.005 | 0.005 | 0.005 | 0.005 |
| pre_p4 | yield_6m |    12 | -0.002025 | -0.002515 | -0.001926 | -0.002396 |
| pre_p4 | yield_6m |    24 | -0.004272 | -0.004303 | -0.004013 | -0.006513 |
| pre_p4 | yield_2y |     0 | 0.007324 | 0.007357 | 0.007431 | 0.008793 |
| pre_p4 | yield_2y |    12 | -0.00385 | -0.004656 | -0.003629 | -0.00415 |
| pre_p4 | yield_2y |    24 | -0.00672 | -0.006742 | -0.006305 | -0.01022 |
| pre_p4 | cambio_usd |     0 | 0.07747 | 0.08039 | 0.09464 | 0.1657 |
| pre_p4 | cambio_usd |    12 | -0.06444 | -0.0792 | -0.05918 | -0.04016 |
| pre_p4 | cambio_usd |    24 | -0.1003 | -0.1026 | -0.09365 | -0.1457 |
| pre_p4 | cds_5y |     0 | 36.63 | 37.51 | 37.87 | 53.27 |
| pre_p4 | cds_5y |    12 | -14.1 | -18.12 | -13.12 | -9.996 |
| pre_p4 | cds_5y |    24 | -29.71 | -30.49 | -27.79 | -43.49 |
| pre_p4 | price_ipca |     0 | -0.1957 | -0.2044 | -0.2086 | 0.01719 |
| pre_p4 | price_ipca |    12 | -0.1349 | -0.1267 | -0.1244 | -0.1593 |
| pre_p4 | price_ipca |    24 | 0.06915 | 0.08483 | 0.0649 | 0.08261 |
| pre_p4 | ibc_br |     0 | -0.4673 | -0.4792 | -0.4623 | -1.008 |
| pre_p4 | ibc_br |    12 | -0.4488 | -0.4282 | -0.4254 | -0.7301 |
| pre_p4 | ibc_br |    24 | 0.002816 | 0.05992 | -0.001049 | -0.1088 |
| pre_p2 | yield_6m |     0 | 0.005 | 0.005 | 0.005 | 0.005 |
| pre_p2 | yield_6m |    12 | 0.0003742 | 0.0003223 | 0.0003943 | -0.0004029 |
| pre_p2 | yield_6m |    24 | -0.002587 | -0.002609 | -0.002609 | -0.004272 |
| pre_p2 | yield_2y |     0 | 0.006853 | 0.006866 | 0.006876 | 0.007265 |
| pre_p2 | yield_2y |    12 | 0.000472 | 0.000393 | 0.0005059 | -0.0006727 |
| pre_p2 | yield_2y |    24 | -0.004022 | -0.004055 | -0.004057 | -0.0066 |
| pre_p2 | cambio_usd |     0 | 0.05803 | 0.0595 | 0.06276 | 0.08647 |
| pre_p2 | cambio_usd |    12 | 0.02702 | 0.02597 | 0.02791 | 0.02634 |
| pre_p2 | cambio_usd |    24 | -0.04295 | -0.04357 | -0.04322 | -0.07498 |
| pre_p2 | cds_5y |     0 | 31.62 | 31.85 |  31.7 | 36.84 |
| pre_p2 | cds_5y |    12 | 8.291 |  7.96 | 8.525 | 6.998 |
| pre_p2 | cds_5y |    24 | -13.5 | -13.7 | -13.59 | -23.7 |
| pre_p2 | price_ipca |     0 | -0.2611 | -0.2631 | -0.2628 | -0.1498 |
| pre_p2 | price_ipca |    12 | -0.1222 | -0.1212 | -0.1234 | -0.1526 |
| pre_p2 | price_ipca |    24 | -0.01463 | -0.01305 | -0.01524 | 0.008225 |
| pre_p2 | ibc_br |     0 | -0.4153 | -0.417 | -0.4086 | -0.9068 |
| pre_p2 | ibc_br |    12 | -0.4783 | -0.4787 | -0.4835 | -0.7164 |
| pre_p2 | ibc_br |    24 | -0.2819 | -0.2775 | -0.2865 | -0.3383 |
| cheia_p4_lp | yield_6m |     0 | 0.005 | 0.005 | 0.005 | 0.005 |
| cheia_p4_lp | yield_6m |    12 | 0.001966 | 0.003775 | 0.0004352 | 0.0005235 |
| cheia_p4_lp | yield_6m |    24 | -0.006314 | -0.002334 | -0.007514 | -0.007198 |
| cheia_p4_lp | yield_2y |     0 | 0.007009 | 0.008045 | 0.01057 | 0.01058 |
| cheia_p4_lp | yield_2y |    12 | 0.001353 | 0.004964 | 0.001045 | 0.001165 |
| cheia_p4_lp | yield_2y |    24 | -0.008433 | -0.003096 | -0.009373 | -0.008975 |
| cheia_p4_lp | cambio_usd |     0 | 0.1294 | 0.1991 | 0.2983 | 0.3068 |
| cheia_p4_lp | cambio_usd |    12 | 0.005148 | 0.09997 | 0.08688 | 0.08732 |
| cheia_p4_lp | cambio_usd |    24 | -0.08027 | -0.003779 | -0.04927 | -0.04587 |
| cheia_p4_lp | cds_5y |     0 | 30.49 |  41.1 | 75.44 | 75.41 |
| cheia_p4_lp | cds_5y |    12 | 4.714 |  18.4 |  14.1 | 14.16 |
| cheia_p4_lp | cds_5y |    24 | -16.42 | -1.967 | -12.95 | -12.21 |
| cheia_p4_lp | price_ipca |     0 | -0.04513 | -0.05433 | -0.1692 | -0.2052 |
| cheia_p4_lp | price_ipca |    12 | -0.1379 | -0.005856 | -0.135 | -0.1277 |
| cheia_p4_lp | price_ipca |    24 | -0.2964 | -0.1882 | -0.3587 | -0.3467 |
| cheia_p4_lp | ibc_br |     0 | -0.6611 | -1.013 | -1.691 | -1.648 |
| cheia_p4_lp | ibc_br |    12 | -0.5848 | -0.6022 | -0.992 | -0.9672 |
| cheia_p4_lp | ibc_br |    24 | -0.5448 | -0.6035 | -0.8701 | -0.8505 |

## Mecanismo: direções de `cov(u)` na célula `q = 5`

`var_share`: participação na variância das inovações. `wald_z`: Wald de z na direção. `cov_mp_share` e `var_mp_share`: participação em cov(z, inovação da `yield_6m`) e em sua variância. `covid_ss_share`: fração da soma de quadrados vinda de 2020-03 a 2020-12 (10 de 162 meses na cheia). `curva_share` e `top_blocks`: pegada da direção no painel padronizado. Na `cheia_p4_lp`, direções e somas de quadrados são as de `u_t/s_t`.

| window_cell | direction | var_share | wald_z | cov_mp_share | var_mp_share | covid_ss_share | curva_share | top_blocks |
|---|---|---|---|---|---|---|---|---|
| cheia_p4 |     1 | 0.3761 | 6.068 | 0.2036 | 0.1055 | 0.2436 | 0.1005 | acoes 0.14, cambio 0.12, industria 0.12 |
| cheia_p4 |     2 | 0.327 | 0.122 | 0.04884 | 0.3671 | 0.3197 | 0.08939 | industria 0.23, trabalho 0.19, curva 0.09 |
| cheia_p4 |     3 | 0.1486 | 0.773 | -0.01144 | 0.006301 | 0.07381 | 0.00298 | precos 0.64, cambio 0.10, monetario 0.04 |
| cheia_p4 |     4 | 0.08604 | 4.224 | 0.3892 | 0.2913 | 0.1753 | 0.1307 | acoes 0.34, curva 0.13, expectativas 0.11 |
| cheia_p4 |     5 | 0.06227 | 5.876 | 0.3699 | 0.2298 | 0.09437 | 0.1344 | monetario 0.25, trabalho 0.23, curva 0.13 |
| pre_p4 |     1 | 0.4231 | 4.928 | 0.5777 | 0.6003 |    NA | 0.1948 | curva 0.19, cambio 0.16, acoes 0.11 |
| pre_p4 |     2 | 0.2474 | 1.889 | 0.03024 | 0.008355 |    NA | 0.01044 | industria 0.32, trabalho 0.12, combustiveis 0.11 |
| pre_p4 |     3 | 0.1892 | 3.335 | 0.3818 | 0.3834 |    NA | 0.1036 | precos 0.29, expectativas 0.22, curva 0.10 |
| pre_p4 |     4 | 0.08467 | 0.7142 | -0.002039 | 8.384e-05 |    NA | 0.001534 | acoes 0.42, cambio 0.13, expectativas 0.08 |
| pre_p4 |     5 | 0.05566 | 0.4916 | 0.01231 | 0.007847 |    NA | 0.007234 | credito_existente 0.31, monetario 0.25, trabalho 0.15 |
| pre_p2 |     1 | 0.4326 |  3.19 | 0.528 | 0.6295 |    NA | 0.2058 | curva 0.21, cambio 0.16, acoes 0.10 |
| pre_p2 |     2 | 0.2296 |  4.34 | 0.1796 | 0.08125 |    NA | 0.01963 | industria 0.24, precos 0.19, trabalho 0.11 |
| pre_p2 |     3 | 0.1947 | 1.983 | 0.2949 | 0.2834 |    NA | 0.08604 | precos 0.19, expectativas 0.18, industria 0.14 |
| pre_p2 |     4 | 0.07598 | 0.07284 | -0.004315 | 0.002971 |    NA | 0.004448 | acoes 0.42, fiscal 0.08, cambio 0.08 |
| pre_p2 |     5 | 0.06716 | 0.03971 | 0.001793 | 0.002936 |    NA | 0.001755 | credito_existente 0.25, monetario 0.24, trabalho 0.12 |
| cheia_p4_lp |     1 | 0.4335 | 5.684 | 0.4815 | 0.5704 | 0.04516 | 0.2066 | curva 0.21, acoes 0.17, cambio 0.14 |
| cheia_p4_lp |     2 | 0.2435 | 3.593 | -0.03866 | 0.006608 | 0.05262 | 0.002796 | industria 0.24, trabalho 0.21, precos 0.20 |
| cheia_p4_lp |     3 | 0.1751 | 0.03395 | -0.000925 | 0.0006371 | 0.08036 | 0.0004016 | precos 0.44, cambio 0.13, industria 0.13 |
| cheia_p4_lp |     4 | 0.09053 |  3.82 | 0.3222 | 0.2469 | 0.05935 | 0.1187 | acoes 0.37, curva 0.12, expectativas 0.10 |
| cheia_p4_lp |     5 | 0.05733 | 3.323 | 0.2359 | 0.1755 | 0.04439 | 0.1294 | monetario 0.25, trabalho 0.21, curva 0.13 |

## Passo 3/4: a cheia com a volatilidade COVID (`cheia_p4_lp`)

As linhas `cheia_p4_lp` das tabelas acima são a `cheia_p4` com a escala `s_t` de Lenza-Primiceri (2022) no VAR dos fatores: mínimos quadrados ponderados, K e H lidos sobre `u_t/s_t` sem centragem, T1 nas direções do segundo momento não centrado e AR na regressão transformada, com θ̂ tratado como conhecido. θ̂ = (s̄0 6,611; s̄1 12,468; s̄2 1,760; ρ 0,9439) por máxima verossimilhança, o de `script/covid_volatility_theta.R`. Sem regra de leitura: o autor lê as IRFs a olho (última página do PDF).

## Leitura conjunta

Só as três células sem tratamento entram nesta leitura.

- (i) T1 não rejeita em nenhum `q` nas duas células pré-COVID e rejeita em algum `q` na cheia: **cumprida**.
- (ii) em `q` = 3 e 4, a maioria das 115 séries sai *imaterial* em `pre_p2` e não em `cheia_p4`: **cumprida**.

**"O truncamento é inofensivo antes da COVID e distorce depois": sustentada.**

As regras foram escritas depois da passada exploratória do mesmo dia; a nota registra isso.
