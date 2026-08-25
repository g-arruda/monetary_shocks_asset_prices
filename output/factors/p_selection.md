# Ordem de defasagens `p` em `(r,q) = (5,5)`: a varredura no impacto, com bandas

Gerado por `script/p_selection.R` em 2026-08-25.
**Corpo gerado — não escrever prosa aqui.** A leitura vive na nota datada.

Amostra completa (2013-01-01 a 2025-09-01), `z_jk_bs_purif` × `yield_6m`, choque +50 pb, wild bootstrap nboot = 800, seed 123, bandas 68/90, h = 0..48. Grade `p` pré-registrada em `registro/pendencias.md`: 2, 3, 4, 6.

## A pergunta e o desenho

`p = 4` é a ordem de produção selecionada pelo AIC. Esta rodada põe a produção, o `p = 6` histórico e as alternativas `p = 3,2` lado a lado no desenho da Figura A3 de Alessi-Kerssenfischer — produção com ponto **e** bandas, alternativas em **ponto apenas** — e lê contenção contra as bandas da produção.

**Critério de leitura, pré-registrado antes de olhar as trajetórias:** *imaterial* é `share_in90 = 1` **e** `cor_path > 0,95`; *material* é `share_in90 < 1` fora de h = 0 ou inversão de sinal no impacto; o resto é *parcial*. É o mesmo `containment_vs_production()` que a rodada de `q` usa, de modo que as duas não podem divergir na regra.

A escolha usa somente o AIC; a força do instrumento e as trajetórias são diagnósticos consequentes, não critérios de seleção.

## O que os critérios de ordem selecionam

A seleção fixa todas as ordens nas últimas `T - 12 = 141` observações e inclui constante e tendência linear, como `vars::VARselect(type = "both")`. AIC e BIC são reproduzidos por `var_lag_criteria()` e pelo pacote `vars`, com desvio máximo inferior a `1e-12`. A tendência existe somente neste exercício: as células de IRF continuam estimando o VAR fatorial com intercepto apenas.

| deterministic | n_obs | p_AIC | p_BIC |
|---|---|---|---|
| trend |   141 |     4 |     2 |

Produção: `p = 4`.

| p | n | T_common | deterministic | logdet | n_parameters | aic | bic | selected_aic | selected_bic | aic_vars | bic_vars | aic_abs_diff | bic_abs_diff |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|     1 |     5 |   141 | trend |  8.59 |    35 | 9.086 | 9.818 | FALSE | FALSE | 9.086 | 9.818 | 1.776e-15 | 1.776e-15 |
|     2 |     5 |   141 | trend | 7.405 |    60 | 8.256 | 9.511 | FALSE | TRUE | 8.256 | 9.511 | 1.776e-15 | 3.553e-15 |
|     3 |     5 |   141 | trend |  7.02 |    85 | 8.225 |    10 | FALSE | FALSE | 8.225 |    10 | 1.776e-15 |     0 |
|     4 |     5 |   141 | trend | 6.513 |   110 | 8.073 | 10.37 | TRUE | FALSE | 8.073 | 10.37 |     0 | 1.776e-15 |
|     5 |     5 |   141 | trend | 6.299 |   135 | 8.214 | 11.04 | FALSE | FALSE | 8.214 | 11.04 | 1.776e-15 | 1.776e-15 |
|     6 |     5 |   141 | trend | 6.097 |   160 | 8.367 | 11.71 | FALSE | FALSE | 8.367 | 11.71 | 1.776e-15 | 3.553e-15 |
|     7 |     5 |   141 | trend | 5.767 |   185 | 8.391 | 12.26 | FALSE | FALSE | 8.391 | 12.26 | 3.553e-15 | 3.553e-15 |
|     8 |     5 |   141 | trend |  5.54 |   210 | 8.518 | 12.91 | FALSE | FALSE | 8.518 | 12.91 |     0 | 1.776e-15 |
|     9 |     5 |   141 | trend | 5.341 |   235 | 8.674 | 13.59 | FALSE | FALSE | 8.674 | 13.59 |     0 | 1.776e-15 |
|    10 |     5 |   141 | trend | 4.931 |   260 | 8.619 | 14.06 | FALSE | FALSE | 8.619 | 14.06 | 1.776e-15 | 3.553e-15 |
|    11 |     5 |   141 | trend | 4.715 |   285 | 8.758 | 14.72 | FALSE | FALSE | 8.758 | 14.72 | 1.776e-15 | 1.776e-15 |
|    12 |     5 |   141 | trend |  4.37 |   310 | 8.767 | 15.25 | FALSE | FALSE | 8.767 | 15.25 | 3.553e-15 | 3.553e-15 |

## Força e estabilidade por célula

Réguas: `ar_bounded` é ξ_mp > 3,84, abaixo do qual o conjunto de Anderson-Rubin a 95% é ilimitado; `bands_valid` é ξ_mp ≥ 10, a referência convencional para bandas.

**Duas assimetrias contra a varredura de `q`.** `n_obs_1st` é o tamanho do primeiro estágio, que `sel_ext_inst_sample()` reduz em exatamente `p` meses: ξ_mp de duas células **não está na mesma amostra**. `dim_companion` é `r·p`: a raiz máxima de duas células é o máximo de matrizes de tamanhos diferentes.

`impacto_mp_pre` é o impacto de `yield_6m` **antes** da normalização, o denominador pelo qual toda IRF da célula é dividida. `denom_ratio` é esse denominador relativo ao da produção: é o fator de escala que separa uma IRF maior de um resultado maior.

| p | dim_companion | n_obs_1st | xi_mp | f_robust_mp | ar_bounded | bands_valid | impacto_mp_pre | max_companion_root | denom_ratio |
|---|---|---|---|---|---|---|---|---|---|
|     4 |    20 |   149 |  5.24 | 10.06 | TRUE | FALSE | 0.0001013 | 0.9681 |     1 |
|     6 |    30 |   147 | 6.271 | 10.12 | TRUE | FALSE | 8.426e-05 | 0.9649 | 0.8316 |
|     3 |    15 |   150 | 5.767 | 8.751 | TRUE | FALSE | 9.867e-05 | 0.9759 | 0.9738 |
|     2 |    10 |   151 | 5.159 | 8.197 | TRUE | FALSE | 9.725e-05 | 0.9697 | 0.9599 |

Nenhum aviso durante os quatro bootstraps.

## A checagem da Figura A3, em número

`share_in68`/`share_in90` são a fração dos horizontes h = 0..36 em que o ponto da célula alternativa cai **dentro** da banda da produção — é o que o olho lê na figura. `share_in90_h12` repete a conta na janela curta que a pendência pede. `cor_path` mede **forma** e é imune à escala; `rel_max_abs_dev` é o desvio máximo em unidades do maior ponto da produção. `first_out90_h` é o primeiro horizonte em que a alternativa sai da banda de 90%.

| p | variable | share_in68 | share_in90 | share_in90_h12 | first_out90_h | cor_path | max_abs_dev | max_abs_dev_h | rel_max_abs_dev | sign_flip_h0 | veredito |
|---|---|---|---|---|---|---|---|---|---|---|---|
|     6 | yield_3m |     1 |     1 |     1 |    NA | 0.9929 | 0.001208 |     9 | 0.1561 | FALSE | imaterial |
|     6 | yield_6m |     1 |     1 |     1 |    NA | 0.9945 | 0.00115 |     9 | 0.1269 | FALSE | imaterial |
|     6 | yield_1y | 0.9459 |     1 |     1 |    NA | 0.9961 | 0.001258 |    36 | 0.1228 | FALSE | imaterial |
|     6 | yield_2y | 0.8919 |     1 |     1 |    NA | 0.9972 | 0.001332 |    36 | 0.1226 | FALSE | imaterial |
|     6 | yield_5y | 0.8649 |     1 |     1 |    NA | 0.9983 | 0.0013 |     3 | 0.1318 | FALSE | imaterial |
|     6 | yield_10y | 0.9189 |     1 |     1 |    NA | 0.9986 | 0.001144 |     3 | 0.1319 | FALSE | imaterial |
|     6 | cambio_usd |     1 |     1 |     1 |    NA | 0.9863 | 0.04401 |     6 | 0.2698 | FALSE | imaterial |
|     6 | embi_perc |     1 |     1 |     1 |    NA | 0.9973 | 0.06089 |     5 | 0.2436 | FALSE | imaterial |
|     6 | cds_5y |     1 |     1 |     1 |    NA | 0.9982 | 6.546 |     5 | 0.2056 | FALSE | imaterial |
|     6 | asset_ibov |     1 |     1 |     1 |    NA | 0.9821 | 0.9723 |     2 | 0.506 | FALSE | imaterial |
|     3 | yield_3m | 0.2162 | 0.7027 |     1 |    15 | 0.9729 | 0.003647 |    17 | 0.4714 | FALSE | material |
|     3 | yield_6m | 0.2162 | 0.6757 |     1 |    14 | 0.9763 | 0.004064 |    16 | 0.4482 | FALSE | material |
|     3 | yield_1y | 0.1892 | 0.6757 |     1 |    13 | 0.9791 | 0.004318 |    15 | 0.4215 | FALSE | material |
|     3 | yield_2y | 0.1892 | 0.7027 | 0.9231 |    12 | 0.9813 | 0.00401 |    13 | 0.369 | FALSE | material |
|     3 | yield_5y | 0.2703 | 0.8108 | 0.9231 |    12 | 0.9827 | 0.003074 |    10 | 0.3116 | FALSE | material |
|     3 | yield_10y | 0.3514 | 0.9189 |     1 |    14 | 0.9826 | 0.002654 |     7 | 0.306 | FALSE | material |
|     3 | cambio_usd |     1 |     1 |     1 |    NA | 0.9661 | 0.04944 |     4 | 0.3031 | FALSE | imaterial |
|     3 | embi_perc |     1 |     1 |     1 |    NA | 0.9766 | 0.06619 |     4 | 0.2648 | FALSE | imaterial |
|     3 | cds_5y | 0.8919 |     1 |     1 |    NA | 0.9803 | 8.254 |     4 | 0.2593 | FALSE | imaterial |
|     3 | asset_ibov | 0.5405 |     1 |     1 |    NA | 0.904 | 1.397 |    18 | 0.727 | FALSE | parcial |
|     2 | yield_3m | 0.3243 | 0.7027 | 0.6923 |     9 | 0.9465 | 0.004521 |    11 | 0.5843 | FALSE | material |
|     2 | yield_6m | 0.3243 | 0.6486 | 0.5385 |     7 | 0.9504 | 0.005176 |    10 | 0.5708 | FALSE | material |
|     2 | yield_1y | 0.3243 | 0.6216 | 0.4615 |     6 | 0.954 | 0.005714 |     9 | 0.5578 | FALSE | material |
|     2 | yield_2y | 0.3784 | 0.6486 | 0.4615 |     6 | 0.9569 | 0.005535 |     8 | 0.5093 | FALSE | material |
|     2 | yield_5y | 0.4595 | 0.7297 | 0.5385 |     7 | 0.9597 | 0.004509 |     7 | 0.457 | FALSE | material |
|     2 | yield_10y | 0.4865 | 0.7838 | 0.5385 |     7 | 0.9603 | 0.003838 |     7 | 0.4426 | FALSE | material |
|     2 | cambio_usd |     1 |     1 |     1 |    NA | 0.9793 | 0.03758 |     4 | 0.2304 | FALSE | imaterial |
|     2 | embi_perc |     1 |     1 |     1 |    NA | 0.9688 | 0.08532 |     2 | 0.3413 | FALSE | imaterial |
|     2 | cds_5y | 0.7838 |     1 |     1 |    NA | 0.9693 | 8.722 |     7 | 0.274 | FALSE | imaterial |
|     2 | asset_ibov |     1 |     1 |     1 |    NA | 0.8402 |   1.6 |    15 | 0.8326 | FALSE | parcial |

Contagem: **16 de 30** pares (variável × `p`) saem *imateriais* e **12** saem *materiais*.

## Decomposição do gap: denominador ou coluna estimada?

⚠ **Achado pós-hoc, deliberadamente fora da regra de veredito acima** — nenhuma destas colunas entra no `case_when` que classifica os pares, justamente para que olhar para elas não possa virar um veredito fixado antes.

`ratio_h0` é o impacto da alternativa dividido pelo da produção. `resto_coluna_h0` é esse mesmo quociente **multiplicado por** `denom_ratio`, isto é, o que sobra do gap depois de remover o denominador de normalização: **1 significa que a coluna estimada não mudou e todo o gap era escala**. `share_in90_resc` repete a contenção com a trajetória inteira reescalada pelo denominador da produção.

⚠ Na linha de `yield_6m` o `resto_coluna_h0` é **tautologicamente** igual a `denom_ratio`: o impacto bruto da variável de política *é* o denominador, então `ratio_h0` vale 1 por construção em toda célula. Essa linha não é achado, é a identidade que fixa a normalização.

| p | variable | denom_ratio | ratio_h0 | resto_coluna_h0 | share_in90 | share_in90_resc |
|---|---|---|---|---|---|---|
|     6 | yield_3m | 0.8316 | 0.9954 | 0.8278 |     1 | 0.973 |
|     6 | yield_6m | 0.8316 |     1 | 0.8316 |     1 | 0.973 |
|     6 | yield_1y | 0.8316 | 1.007 | 0.8378 |     1 | 0.973 |
|     6 | yield_2y | 0.8316 |  1.02 | 0.8486 |     1 |     1 |
|     6 | yield_5y | 0.8316 | 1.037 | 0.8626 |     1 |     1 |
|     6 | yield_10y | 0.8316 | 1.039 | 0.8644 |     1 |     1 |
|     6 | cambio_usd | 0.8316 | 1.026 | 0.8537 |     1 |     1 |
|     6 | embi_perc | 0.8316 |  1.07 | 0.8897 |     1 |     1 |
|     6 | cds_5y | 0.8316 |  1.06 | 0.8814 |     1 |     1 |
|     6 | asset_ibov | 0.8316 |  1.78 |  1.48 |     1 |     1 |
|     3 | yield_3m | 0.9738 | 1.012 | 0.9851 | 0.7027 | 0.7027 |
|     3 | yield_6m | 0.9738 |     1 | 0.9738 | 0.6757 | 0.6486 |
|     3 | yield_1y | 0.9738 | 0.9987 | 0.9726 | 0.6757 | 0.6757 |
|     3 | yield_2y | 0.9738 | 1.014 | 0.9875 | 0.7027 | 0.7027 |
|     3 | yield_5y | 0.9738 | 1.056 | 1.028 | 0.8108 | 0.8378 |
|     3 | yield_10y | 0.9738 | 1.073 | 1.045 | 0.9189 | 0.973 |
|     3 | cambio_usd | 0.9738 | 1.098 | 1.069 |     1 |     1 |
|     3 | embi_perc | 0.9738 | 1.195 | 1.164 |     1 |     1 |
|     3 | cds_5y | 0.9738 | 1.162 | 1.132 |     1 |     1 |
|     3 | asset_ibov | 0.9738 | 0.7639 | 0.7439 |     1 |     1 |
|     2 | yield_3m | 0.9599 | 1.012 | 0.9718 | 0.7027 | 0.6757 |
|     2 | yield_6m | 0.9599 |     1 | 0.9599 | 0.6486 | 0.6216 |
|     2 | yield_1y | 0.9599 | 0.9943 | 0.9543 | 0.6216 | 0.6216 |
|     2 | yield_2y | 0.9599 | 0.9988 | 0.9587 | 0.6486 | 0.6486 |
|     2 | yield_5y | 0.9599 | 1.023 | 0.9817 | 0.7297 | 0.7568 |
|     2 | yield_10y | 0.9599 | 1.035 | 0.9937 | 0.7838 | 0.7838 |
|     2 | cambio_usd | 0.9599 | 1.063 |  1.02 |     1 |     1 |
|     2 | embi_perc | 0.9599 | 1.116 | 1.072 |     1 |     1 |
|     2 | cds_5y | 0.9599 | 1.095 | 1.051 |     1 |     1 |
|     2 | asset_ibov | 0.9599 | 0.3471 | 0.3332 |     1 |     1 |

## Impacto (h = 0) no bloco de 10 variáveis

A curva inteira, o câmbio e as duas medidas soberanas, que é o bloco que a pendência pede. `asset_ibov` fica na tabela por ser onde as células mais discordaram na varredura de `q`.

| variable | p=4 | p=6 | p=3 | p=2 |
|---|---|---|---|---|
| yield_3m | 0.0038861315 | 0.0038682613 | 0.0039311102 | 0.0039344619 |
| yield_6m |     0.005 |     0.005 |     0.005 |     0.005 |
| yield_1y | 0.0062875271 | 0.0063341237 | 0.0062794791 | 0.006251376 |
| yield_2y | 0.0072818769 | 0.0074300592 | 0.0073838714 | 0.0072730294 |
| yield_5y | 0.0074830927 | 0.0077611464 | 0.0079022665 | 0.0076533969 |
| yield_10y | 0.0067638597 | 0.0070301409 | 0.0072585366 | 0.0070023134 |
| cambio_usd | 0.15385505 | 0.15792807 | 0.16890653 | 0.16348323 |
| embi_perc | 0.24484924 | 0.26195163 | 0.29270819 | 0.2733347 |
| cds_5y | 30.704019 | 32.541729 | 35.679705 | 33.630141 |
| asset_ibov | -0.96798489 | -1.7226767 | -0.73942928 | -0.33602333 |

### Exclui zero a 90% no impacto

| variable | p=4 | p=6 | p=3 | p=2 |
|---|---|---|---|---|
| yield_3m | sim | sim | sim | sim |
| yield_6m | sim | sim | sim | sim |
| yield_1y | sim | sim | sim | sim |
| yield_2y | sim | sim | sim | sim |
| yield_5y | sim | sim | sim | sim |
| yield_10y | sim | sim | sim | sim |
| cambio_usd | sim | sim | sim | sim |
| embi_perc | sim | sim | sim | sim |
| cds_5y | sim | sim | sim | sim |
| asset_ibov | nao | nao | nao | nao |

## A entrega: `h = 0..12` por célula

Âncoras em h = 0, 1, 3, 6, 12. `n_sig90` e `n_sig68` contam quantos dos 13 horizontes da janela têm banda excluindo zero. Trajetórias completas até h = 48, com as quatro bandas, em `p_selection_paths.csv`.

| p | variable | h0 | h1 | h3 | h6 | h12 | n_sig90 | n_sig68 |
|---|---|---|---|---|---|---|---|---|
|       6 | yield_3m | 0.00386826 | 0.00505475 | 0.00724981 | 0.0071137 | 0.00499672 |      12 |      13 |
|       4 | yield_3m | 0.00388613 | 0.00469769 | 0.00667931 | 0.00773697 | 0.00604665 |      13 |      13 |
|       3 | yield_3m | 0.00393111 | 0.00467868 | 0.00588467 | 0.00601112 | 0.00282531 |      11 |      13 |
|       2 | yield_3m | 0.00393446 | 0.00489227 | 0.00502524 | 0.00416454 | 0.00157068 |       9 |      13 |
|       6 | yield_6m |   0.005 | 0.00654099 | 0.00896786 | 0.00851826 | 0.00542497 |      12 |      13 |
|       4 | yield_6m |   0.005 | 0.00610629 | 0.00821513 | 0.00906728 | 0.00642563 |      13 |      13 |
|       3 | yield_6m |   0.005 | 0.00608741 | 0.00711676 | 0.00677586 | 0.00266308 |      10 |      13 |
|       2 | yield_6m |   0.005 | 0.00627701 | 0.00609861 | 0.00473533 | 0.0014001 |       9 |      13 |
|       6 | yield_1y | 0.00633412 | 0.00821704 | 0.0107529 | 0.00989453 | 0.00556214 |      12 |      13 |
|       4 | yield_1y | 0.00628753 | 0.00770894 | 0.00979415 | 0.0102427 | 0.00639693 |      13 |      13 |
|       3 | yield_1y | 0.00627948 | 0.00774868 | 0.00831117 | 0.00733772 | 0.00221433 |      10 |      13 |
|       2 | yield_1y | 0.00625138 | 0.00786396 | 0.00720971 | 0.00520414 | 0.00104422 |       9 |      12 |
|       6 | yield_2y | 0.00743006 | 0.00937215 | 0.0116963 | 0.0103736 | 0.00504077 |      11 |      13 |
|       4 | yield_2y | 0.00728188 | 0.00880091 | 0.0105121 | 0.010358 | 0.00560347 |      13 |      13 |
|       3 | yield_2y | 0.00738387 | 0.00903542 | 0.0087318 | 0.00721992 | 0.00161053 |       9 |      12 |
|       2 | yield_2y | 0.00727303 | 0.00901125 | 0.00776986 | 0.00524189 | 0.000642452 |       9 |      12 |
|       6 | yield_5y | 0.00776115 | 0.00928153 | 0.0109814 | 0.00941388 | 0.00373977 |      11 |      13 |
|       4 | yield_5y | 0.00748309 | 0.00870836 | 0.00968121 | 0.00886775 | 0.00394122 |      13 |      13 |
|       3 | yield_5y | 0.00790227 | 0.00933317 | 0.00784459 | 0.00613738 | 0.000978494 |       8 |      11 |
|       2 | yield_5y | 0.0076534 | 0.00912402 | 0.00737301 | 0.00467436 | 0.000304022 |       8 |      11 |
|       6 | yield_10y | 0.00703014 | 0.00828141 | 0.00967741 | 0.00832611 | 0.00311409 |      11 |      13 |
|       4 | yield_10y | 0.00676386 | 0.0077863 | 0.00853333 | 0.00769134 | 0.00320459 |      13 |      13 |
|       3 | yield_10y | 0.00725854 | 0.00847225 | 0.00686704 | 0.00530883 | 0.000744406 |       8 |      10 |
|       2 | yield_10y | 0.00700231 | 0.00824529 | 0.00659638 | 0.00412698 | 0.000197002 |       8 |      11 |
|       6 | cambio_usd | 0.157928 | 0.177345 | 0.172879 | 0.12027 | -0.0120842 |       7 |       8 |
|       4 | cambio_usd | 0.153855 | 0.163101 | 0.13763 | 0.0762595 | -0.0397256 |       5 |       8 |
|       3 | cambio_usd | 0.168907 | 0.190119 | 0.110248 | 0.03755 | -0.0440139 |       4 |       5 |
|       2 | cambio_usd | 0.163483 | 0.182269 | 0.116141 | 0.0463555 | -0.0318527 |       5 |       6 |
|       6 | embi_perc | 0.261952 | 0.267723 | 0.28104 | 0.232277 | 0.0441186 |       8 |      11 |
|       4 | embi_perc | 0.244849 | 0.24998 | 0.235007 | 0.175991 | 0.0316963 |       9 |      13 |
|       3 | embi_perc | 0.292708 | 0.307539 | 0.179745 | 0.132853 | 0.016822 |       5 |       9 |
|       2 | embi_perc | 0.273335 | 0.289416 | 0.208853 | 0.122635 | 0.00667036 |       7 |       9 |
|       6 | cds_5y | 32.5417 | 34.3547 | 36.7956 | 29.8286 | 6.79606 |       8 |      12 |
|       4 | cds_5y |  30.704 | 31.8363 | 30.5845 | 23.5335 | 5.52533 |      11 |      13 |
|       3 | cds_5y | 35.6797 | 38.1305 | 24.0787 | 17.5323 | 2.37057 |       6 |       9 |
|       2 | cds_5y | 33.6301 | 36.2774 | 26.3974 | 15.6069 | 0.924841 |       7 |      10 |
|       6 | asset_ibov | -1.72268 | -1.50513 | -0.810357 | 1.18489 | 1.89731 |       0 |       3 |
|       4 | asset_ibov | -0.967985 | -1.3782 | -0.100561 | 1.19063 |  1.8888 |       0 |       1 |
|       3 | asset_ibov | -0.739429 | -1.23956 | 0.882912 | 0.912415 | 0.718172 |       1 |       2 |
|       2 | asset_ibov | -0.336023 | -0.617289 | 0.72092 | 1.05835 | 0.364364 |       0 |       1 |

## Reversão de médio prazo por célula

`h_flip` é o primeiro horizonte em que a trajetória cruza de volta o sinal do próprio impacto; `h_ext_medio` e `val_ext_medio` são o extremo em h ≥ 12. ⚠ Esta tabela descreve a **dinâmica conjunta** do VAR dos fatores sob cada `p` — ela não constitui evidência separada da dinâmica que a produz, e é nessa qualidade que a §4 já a lê.

| variable | p | h_flip | h_ext_medio | val_ext_medio |
|---|---|---|---|---|
| yield_3m |       6 |      23 |      41 | -0.00628471 |
| yield_3m |       4 |      22 |      12 | 0.00604665 |
| yield_3m |       3 |      17 |      35 | -0.00631517 |
| yield_3m |       2 |      16 |      38 | -0.00484935 |
| yield_6m |       6 |      22 |      40 | -0.00726133 |
| yield_6m |       4 |      21 |      12 | 0.00642563 |
| yield_6m |       3 |      16 |      34 | -0.00736021 |
| yield_6m |       2 |      15 |      37 | -0.00566718 |
| yield_1y |       6 |      20 |      39 | -0.00809126 |
| yield_1y |       4 |      20 |      36 | -0.00665625 |
| yield_1y |       3 |      15 |      33 | -0.00824476 |
| yield_1y |       2 |      14 |      35 | -0.00637762 |
| yield_2y |       6 |      19 |      37 | -0.00797789 |
| yield_2y |       4 |      19 |      35 | -0.00664529 |
| yield_2y |       3 |      14 |      32 | -0.00809665 |
| yield_2y |       2 |      13 |      34 | -0.00630776 |
| yield_5y |       6 |      17 |      35 | -0.00653141 |
| yield_5y |       4 |      17 |      33 | -0.00552957 |
| yield_5y |       3 |      14 |      30 | -0.00649958 |
| yield_5y |       2 |      13 |      32 | -0.0051269 |
| yield_10y |       6 |      17 |      35 | -0.00565883 |
| yield_10y |       4 |      17 |      32 | -0.00480596 |
| yield_10y |       3 |      14 |      30 | -0.00557768 |
| yield_10y |       2 |      13 |      32 | -0.00442442 |
| cambio_usd |       6 |      12 |      23 | -0.108723 |
| cambio_usd |       4 |      10 |      21 | -0.0958272 |
| cambio_usd |       3 |       9 |      20 | -0.0738408 |
| cambio_usd |       2 |       9 |      22 | -0.0650893 |
| embi_perc |       6 |      15 |      29 | -0.115892 |
| embi_perc |       4 |      14 |      28 | -0.0998166 |
| embi_perc |       3 |      14 |      27 | -0.09088 |
| embi_perc |       2 |      13 |      27 | -0.0795403 |
| cds_5y |       6 |      15 |      31 | -15.3525 |
| cds_5y |       4 |      15 |      29 | -13.2339 |
| cds_5y |       3 |      14 |      28 | -13.0327 |
| cds_5y |       2 |      13 |      28 | -11.0471 |
| asset_ibov |       6 |       2 |      42 | -2.41122 |
| asset_ibov |       4 |       2 |      39 | -1.98489 |
| asset_ibov |       3 |       2 |      36 | -2.62838 |
| asset_ibov |       2 |       2 |      38 | -2.03601 |

Figura em `p_selection_paths.pdf`.
