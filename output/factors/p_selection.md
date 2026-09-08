# Ordem de defasagens `p` em `(r,q) = (4,4)`: a varredura no impacto, com bandas

Gerado por `script/p_selection.R` em 2026-09-01.
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
|     1 |     4 |   141 | trend | 7.554 |    24 | 7.894 | 8.396 | FALSE | FALSE | 7.894 | 8.396 |     0 |     0 |
|     2 |     4 |   141 | trend | 6.591 |    40 | 7.158 | 7.995 | FALSE | TRUE | 7.158 | 7.995 | 8.882e-16 |     0 |
|     3 |     4 |   141 | trend | 6.222 |    56 | 7.016 | 8.188 | FALSE | FALSE | 7.016 | 8.188 |     0 |     0 |
|     4 |     4 |   141 | trend | 5.805 |    72 | 6.826 | 8.332 | TRUE | FALSE | 6.826 | 8.332 | 8.882e-16 |     0 |
|     5 |     4 |   141 | trend | 5.703 |    88 | 6.952 | 8.792 | FALSE | FALSE | 6.952 | 8.792 | 8.882e-16 |     0 |
|     6 |     4 |   141 | trend |  5.59 |   104 | 7.065 |  9.24 | FALSE | FALSE | 7.065 |  9.24 | 1.776e-15 | 1.776e-15 |
|     7 |     4 |   141 | trend | 5.436 |   120 | 7.138 | 9.648 | FALSE | FALSE | 7.138 | 9.648 | 2.665e-15 | 3.553e-15 |
|     8 |     4 |   141 | trend | 5.361 |   136 |  7.29 | 10.13 | FALSE | FALSE |  7.29 | 10.13 | 4.441e-15 | 3.553e-15 |
|     9 |     4 |   141 | trend | 5.314 |   152 |  7.47 | 10.65 | FALSE | FALSE |  7.47 | 10.65 | 3.553e-15 | 1.776e-15 |
|    10 |     4 |   141 | trend | 5.184 |   168 | 7.567 | 11.08 | FALSE | FALSE | 7.567 | 11.08 | 2.665e-15 | 1.776e-15 |
|    11 |     4 |   141 | trend | 5.039 |   184 | 7.649 |  11.5 | FALSE | FALSE | 7.649 |  11.5 | 3.553e-15 | 3.553e-15 |
|    12 |     4 |   141 | trend | 4.768 |   200 | 7.605 | 11.79 | FALSE | FALSE | 7.605 | 11.79 | 1.776e-15 | 1.776e-15 |

## Força e estabilidade por célula

Réguas: `ar_bounded` é ξ_mp > 3,84, abaixo do qual o conjunto de Anderson-Rubin a 95% é ilimitado; `bands_valid` é ξ_mp ≥ 10, a referência convencional para bandas.

**Duas assimetrias contra a varredura de `q`.** `n_obs_1st` é o tamanho do primeiro estágio, que `sel_ext_inst_sample()` reduz em exatamente `p` meses: ξ_mp de duas células **não está na mesma amostra**. `dim_companion` é `r·p`: a raiz máxima de duas células é o máximo de matrizes de tamanhos diferentes.

`impacto_mp_pre` é o impacto de `yield_6m` **antes** da normalização, o denominador pelo qual toda IRF da célula é dividida. `denom_ratio` é esse denominador relativo ao da produção: é o fator de escala que separa uma IRF maior de um resultado maior.

| p | dim_companion | n_obs_1st | xi_mp | f_robust_mp | ar_bounded | bands_valid | impacto_mp_pre | max_companion_root | denom_ratio |
|---|---|---|---|---|---|---|---|---|---|
|     4 |    16 |   149 | 6.384 | 14.16 | TRUE | FALSE | 0.0001141 | 0.9721 |     1 |
|     6 |    24 |   147 | 6.964 | 13.95 | TRUE | FALSE | 0.0001061 | 0.9593 | 0.9303 |
|     3 |    12 |   150 | 6.652 | 11.25 | TRUE | FALSE | 0.0001098 | 0.9696 | 0.9627 |
|     2 |     8 |   151 | 6.441 | 11.45 | TRUE | FALSE | 0.00011 | 0.9753 | 0.9637 |

Nenhum aviso durante os quatro bootstraps.

## A checagem da Figura A3, em número

`share_in68`/`share_in90` são a fração dos horizontes h = 0..36 em que o ponto da célula alternativa cai **dentro** da banda da produção — é o que o olho lê na figura. `share_in90_h12` repete a conta na janela curta que a pendência pede. `cor_path` mede **forma** e é imune à escala; `rel_max_abs_dev` é o desvio máximo em unidades do maior ponto da produção. `first_out90_h` é o primeiro horizonte em que a alternativa sai da banda de 90%.

| p | variable | share_in68 | share_in90 | share_in90_h12 | first_out90_h | cor_path | max_abs_dev | max_abs_dev_h | rel_max_abs_dev | sign_flip_h0 | veredito |
|---|---|---|---|---|---|---|---|---|---|---|---|
|     6 | yield_3m |     1 |     1 |     1 |    NA | 0.9858 | 0.001692 |    20 | 0.2715 | FALSE | imaterial |
|     6 | yield_6m |     1 |     1 |     1 |    NA | 0.9876 | 0.001944 |    19 | 0.2635 | FALSE | imaterial |
|     6 | yield_1y |     1 |     1 |     1 |    NA | 0.9888 | 0.002149 |    18 | 0.2494 | FALSE | imaterial |
|     6 | yield_2y |     1 |     1 |     1 |    NA | 0.9893 | 0.002168 |    15 | 0.2354 | FALSE | imaterial |
|     6 | yield_5y |     1 |     1 |     1 |    NA | 0.9896 | 0.002012 |     8 | 0.241 | FALSE | imaterial |
|     6 | yield_10y |     1 |     1 |     1 |    NA | 0.9896 | 0.001824 |     8 | 0.2535 | FALSE | imaterial |
|     6 | cambio_usd |     1 |     1 |     1 |    NA | 0.9814 | 0.05615 |     8 | 0.3587 | FALSE | imaterial |
|     6 | embi_perc |     1 |     1 |     1 |    NA | 0.9872 | 0.06468 |     7 |   0.3 | FALSE | imaterial |
|     6 | cds_5y |     1 |     1 |     1 |    NA | 0.9889 | 8.364 |     8 | 0.2881 | FALSE | imaterial |
|     6 | asset_ibov |     1 |     1 |     1 |    NA | 0.9358 | 0.6025 |     2 | 0.3602 | FALSE | parcial |
|     3 | yield_3m | 0.2973 |     1 |     1 |    NA | 0.9811 | 0.002517 |    19 | 0.4038 | FALSE | imaterial |
|     3 | yield_6m | 0.2703 |     1 |     1 |    NA | 0.9839 | 0.002858 |    18 | 0.3874 | FALSE | imaterial |
|     3 | yield_1y | 0.2973 |     1 |     1 |    NA | 0.986 | 0.003078 |    17 | 0.3572 | FALSE | imaterial |
|     3 | yield_2y | 0.3784 |     1 |     1 |    NA | 0.9873 | 0.002975 |    16 | 0.3231 | FALSE | imaterial |
|     3 | yield_5y | 0.5135 |     1 |     1 |    NA | 0.9878 | 0.002303 |    16 | 0.2758 | FALSE | imaterial |
|     3 | yield_10y | 0.7297 |     1 |     1 |    NA | 0.9877 | 0.001857 |    14 | 0.2581 | FALSE | imaterial |
|     3 | cambio_usd |     1 |     1 |     1 |    NA | 0.9846 | 0.0344 |     4 | 0.2197 | FALSE | imaterial |
|     3 | embi_perc |     1 |     1 |     1 |    NA | 0.9851 | 0.04648 |     0 | 0.2156 | FALSE | imaterial |
|     3 | cds_5y |     1 |     1 |     1 |    NA | 0.9864 | 5.467 |     3 | 0.1883 | FALSE | imaterial |
|     3 | asset_ibov |     1 |     1 |     1 |    NA | 0.8485 | 1.228 |     2 | 0.7343 | FALSE | parcial |
|     2 | yield_3m | 0.6757 |     1 |     1 |    NA | 0.9816 | 0.00202 |    10 | 0.324 | FALSE | imaterial |
|     2 | yield_6m | 0.6757 |     1 |     1 |    NA | 0.9835 | 0.002366 |    10 | 0.3207 | FALSE | imaterial |
|     2 | yield_1y | 0.7297 |     1 |     1 |    NA | 0.9848 | 0.002649 |     9 | 0.3074 | FALSE | imaterial |
|     2 | yield_2y | 0.7297 |     1 |     1 |    NA | 0.985 | 0.002752 |     7 | 0.2988 | FALSE | imaterial |
|     2 | yield_5y | 0.8649 |     1 |     1 |    NA | 0.9838 | 0.002361 |     7 | 0.2828 | FALSE | imaterial |
|     2 | yield_10y |     1 |     1 |     1 |    NA | 0.9831 | 0.001973 |     7 | 0.2742 | FALSE | imaterial |
|     2 | cambio_usd |     1 |     1 |     1 |    NA | 0.9862 | 0.03285 |     7 | 0.2099 | FALSE | imaterial |
|     2 | embi_perc |     1 |     1 |     1 |    NA | 0.9783 | 0.04854 |     2 | 0.2251 | FALSE | imaterial |
|     2 | cds_5y |     1 |     1 |     1 |    NA | 0.9798 | 6.336 |     7 | 0.2183 | FALSE | imaterial |
|     2 | asset_ibov |     1 |     1 |     1 |    NA | 0.8267 | 1.233 |     1 | 0.7375 | FALSE | parcial |

Contagem: **27 de 30** pares (variável × `p`) saem *imateriais* e **0** saem *materiais*.

## Decomposição do gap: denominador ou coluna estimada?

⚠ **Achado pós-hoc, deliberadamente fora da regra de veredito acima** — nenhuma destas colunas entra no `case_when` que classifica os pares, justamente para que olhar para elas não possa virar um veredito fixado antes.

`ratio_h0` é o impacto da alternativa dividido pelo da produção. `resto_coluna_h0` é esse mesmo quociente **multiplicado por** `denom_ratio`, isto é, o que sobra do gap depois de remover o denominador de normalização: **1 significa que a coluna estimada não mudou e todo o gap era escala**. `share_in90_resc` repete a contenção com a trajetória inteira reescalada pelo denominador da produção.

⚠ Na linha de `yield_6m` o `resto_coluna_h0` é **tautologicamente** igual a `denom_ratio`: o impacto bruto da variável de política *é* o denominador, então `ratio_h0` vale 1 por construção em toda célula. Essa linha não é achado, é a identidade que fixa a normalização.

| p | variable | denom_ratio | ratio_h0 | resto_coluna_h0 | share_in90 | share_in90_resc |
|---|---|---|---|---|---|---|
|     6 | yield_3m | 0.9303 | 1.003 | 0.9328 |     1 |     1 |
|     6 | yield_6m | 0.9303 |     1 | 0.9303 |     1 | 0.973 |
|     6 | yield_1y | 0.9303 | 0.9961 | 0.9266 |     1 |     1 |
|     6 | yield_2y | 0.9303 | 0.9908 | 0.9217 |     1 |     1 |
|     6 | yield_5y | 0.9303 | 0.9837 | 0.9152 |     1 |     1 |
|     6 | yield_10y | 0.9303 | 0.9821 | 0.9136 |     1 |     1 |
|     6 | cambio_usd | 0.9303 | 0.9933 | 0.924 |     1 |     1 |
|     6 | embi_perc | 0.9303 | 0.9692 | 0.9017 |     1 |     1 |
|     6 | cds_5y | 0.9303 | 0.9763 | 0.9082 |     1 |     1 |
|     6 | asset_ibov | 0.9303 | 0.7402 | 0.6887 |     1 |     1 |
|     3 | yield_3m | 0.9627 | 1.009 | 0.9717 |     1 |     1 |
|     3 | yield_6m | 0.9627 |     1 | 0.9627 |     1 | 0.973 |
|     3 | yield_1y | 0.9627 | 0.9997 | 0.9624 |     1 |     1 |
|     3 | yield_2y | 0.9627 | 1.013 | 0.9757 |     1 |     1 |
|     3 | yield_5y | 0.9627 | 1.056 | 1.017 |     1 |     1 |
|     3 | yield_10y | 0.9627 | 1.077 | 1.036 |     1 |     1 |
|     3 | cambio_usd | 0.9627 | 1.136 | 1.094 |     1 |     1 |
|     3 | embi_perc | 0.9627 | 1.216 | 1.171 |     1 |     1 |
|     3 | cds_5y | 0.9627 | 1.176 | 1.132 |     1 |     1 |
|     3 | asset_ibov | 0.9627 |  0.46 | 0.4428 |     1 |     1 |
|     2 | yield_3m | 0.9637 |  1.01 | 0.9735 |     1 |     1 |
|     2 | yield_6m | 0.9637 |     1 | 0.9637 |     1 | 0.973 |
|     2 | yield_1y | 0.9637 | 0.9939 | 0.9578 |     1 |     1 |
|     2 | yield_2y | 0.9637 | 0.9949 | 0.9588 |     1 |     1 |
|     2 | yield_5y | 0.9637 | 1.012 | 0.9751 |     1 |     1 |
|     2 | yield_10y | 0.9637 | 1.023 | 0.9855 |     1 |     1 |
|     2 | cambio_usd | 0.9637 | 1.075 | 1.036 |     1 |     1 |
|     2 | embi_perc | 0.9637 | 1.094 | 1.054 |     1 |     1 |
|     2 | cds_5y | 0.9637 | 1.078 | 1.039 |     1 |     1 |
|     2 | asset_ibov | 0.9637 | 0.2927 | 0.2821 |     1 |     1 |

## Impacto (h = 0) no bloco de 10 variáveis

A curva inteira, o câmbio e as duas medidas soberanas, que é o bloco que a pendência pede. `asset_ibov` fica na tabela por ser onde as células mais discordaram na varredura de `q`.

| variable | p=4 | p=6 | p=3 | p=2 |
|---|---|---|---|---|
| yield_3m | 0.0039204633 | 0.0039308089 | 0.003957268 | 0.003960371 |
| yield_6m |     0.005 |     0.005 |     0.005 |     0.005 |
| yield_1y | 0.0062120182 | 0.006187655 | 0.0062102427 | 0.0061739108 |
| yield_2y | 0.0070840086 | 0.0070187883 | 0.0071794121 | 0.0070479343 |
| yield_5y | 0.0070606166 | 0.0069456921 | 0.0074556111 | 0.0071443805 |
| yield_10y | 0.0062837023 | 0.0061710083 | 0.0067651011 | 0.0064260245 |
| cambio_usd | 0.13548108 | 0.13456681 | 0.15392895 | 0.14562084 |
| embi_perc | 0.21491057 | 0.20830024 | 0.2613948 | 0.23503106 |
| cds_5y | 27.606099 | 26.950571 | 32.468301 |  29.75451 |
| asset_ibov | -1.1679944 | -0.86460544 | -0.5372468 | -0.34190169 |

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
|       6 | yield_3m | 0.00393081 | 0.00499196 | 0.00688481 | 0.00694545 | 0.00592143 |      13 |      13 |
|       4 | yield_3m | 0.00392046 | 0.00473358 | 0.00595976 | 0.00623364 | 0.00489298 |      13 |      13 |
|       3 | yield_3m | 0.00395727 | 0.00455461 | 0.00507719 | 0.00501064 | 0.00283008 |      12 |      13 |
|       2 | yield_3m | 0.00396037 | 0.0048109 | 0.00492221 | 0.00448394 | 0.00291307 |      13 |      13 |
|       6 | yield_6m |   0.005 | 0.00639458 | 0.00854035 | 0.00837484 | 0.00673117 |      13 |      13 |
|       4 | yield_6m |   0.005 | 0.00608847 | 0.00730823 | 0.00732416 | 0.00531399 |      13 |      13 |
|       3 | yield_6m |   0.005 | 0.00585849 | 0.00614647 | 0.00573268 | 0.00285117 |      12 |      13 |
|       2 | yield_6m |   0.005 | 0.00604532 | 0.00596548 | 0.00518472 | 0.0030489 |      12 |      13 |
|       6 | yield_1y | 0.00618765 | 0.00790553 | 0.0102045 | 0.00970033 | 0.00724795 |      13 |      13 |
|       4 | yield_1y | 0.00621202 | 0.00756037 | 0.00861713 | 0.00822559 | 0.00540452 |      13 |      13 |
|       3 | yield_1y | 0.00621024 | 0.00732819 | 0.00713941 | 0.00627058 | 0.00262091 |      11 |      13 |
|       2 | yield_1y | 0.00617391 | 0.0073767 | 0.00697555 | 0.00573334 | 0.00294891 |      12 |      13 |
|       6 | yield_2y | 0.00701879 | 0.00884768 | 0.0110588 | 0.0102039 | 0.00703129 |      13 |      13 |
|       4 | yield_2y | 0.00708401 | 0.00849826 | 0.00920933 | 0.00837457 | 0.00493547 |      13 |      13 |
|       3 | yield_2y | 0.00717941 | 0.00838219 | 0.00750973 | 0.00627491 | 0.00214378 |      10 |      13 |
|       2 | yield_2y | 0.00704793 | 0.00824496 | 0.00745216 | 0.00578145 | 0.0025406 |      11 |      13 |
|       6 | yield_5y | 0.00694569 | 0.00843606 | 0.0101934 | 0.00910685 | 0.00562176 |      13 |      13 |
|       4 | yield_5y | 0.00706062 | 0.00815079 | 0.00834767 | 0.00716607 | 0.00366909 |      13 |      13 |
|       3 | yield_5y | 0.00745561 | 0.00838827 | 0.00669917 | 0.00538818 | 0.00144596 |       9 |      12 |
|       2 | yield_5y | 0.00714438 | 0.00804884 | 0.00688024 | 0.00497786 | 0.0017558 |      10 |      13 |
|       6 | yield_10y | 0.00617101 | 0.00737312 | 0.00882924 | 0.00781201 | 0.00462665 |      13 |      13 |
|       4 | yield_10y | 0.0062837 | 0.00714109 | 0.00719537 | 0.00605321 | 0.00293397 |      12 |      13 |
|       3 | yield_10y | 0.0067651 | 0.00750188 | 0.00576332 | 0.00458576 | 0.00113273 |       8 |      12 |
|       2 | yield_10y | 0.00642602 | 0.00714535 | 0.00600231 | 0.00423938 | 0.00136523 |      10 |      12 |
|       6 | cambio_usd | 0.134567 | 0.159048 | 0.183388 | 0.150853 | 0.0609767 |       7 |      10 |
|       4 | cambio_usd | 0.135481 | 0.156546 | 0.147339 | 0.102846 | 0.0141591 |       7 |       9 |
|       3 | cambio_usd | 0.153929 | 0.177394 | 0.121579 | 0.0720235 | -0.0135101 |       5 |       7 |
|       2 | cambio_usd | 0.145621 | 0.162394 | 0.127267 | 0.0725438 | -0.006023 |       5 |       8 |
|       6 | embi_perc |  0.2083 | 0.219135 | 0.247744 | 0.206345 | 0.0864775 |      10 |      13 |
|       4 | embi_perc | 0.214911 | 0.215587 | 0.194822 | 0.142791 | 0.0434152 |       9 |      12 |
|       3 | embi_perc | 0.261395 | 0.260889 | 0.153478 | 0.120631 | 0.01999 |       6 |       9 |
|       2 | embi_perc | 0.235031 | 0.239005 | 0.18021 | 0.109843 | 0.0157283 |       7 |      10 |
|       6 | cds_5y | 26.9506 | 29.6601 | 34.5608 | 29.6416 | 14.6974 |      11 |      13 |
|       4 | cds_5y | 27.6061 | 29.0314 | 27.6839 | 21.5805 | 8.34482 |      10 |      13 |
|       3 | cds_5y | 32.4683 | 33.6726 | 22.2166 | 17.4893 | 3.58728 |       7 |      10 |
|       2 | cds_5y | 29.7545 |  31.334 | 24.7659 | 16.0821 | 3.53765 |       8 |      11 |
|       6 | asset_ibov | -0.864605 | -1.09537 | 0.0657204 | 0.949557 | 1.87983 |       0 |       5 |
|       4 | asset_ibov | -1.16799 | -1.02223 | 0.605941 | 1.28964 | 1.67246 |       0 |       5 |
|       3 | asset_ibov | -0.537247 | -0.216548 | 1.53191 | 1.47287 | 1.44451 |       1 |      11 |
|       2 | asset_ibov | -0.341902 | 0.211162 | 1.16794 | 1.47645 | 1.18813 |       0 |      10 |

## Reversão de médio prazo por célula

`h_flip` é o primeiro horizonte em que a trajetória cruza de volta o sinal do próprio impacto; `h_ext_medio` e `val_ext_medio` são o extremo em h ≥ 12. ⚠ Esta tabela descreve a **dinâmica conjunta** do VAR dos fatores sob cada `p` — ela não constitui evidência separada da dinâmica que a produz, e é nessa qualidade que a §4 já a lê.

| variable | p | h_flip | h_ext_medio | val_ext_medio |
|---|---|---|---|---|
| yield_3m |       6 |      28 |      12 | 0.00592143 |
| yield_3m |       4 |      25 |      12 | 0.00489298 |
| yield_3m |       3 |      19 |      37 | -0.00389332 |
| yield_3m |       2 |      22 |      12 | 0.00291307 |
| yield_6m |       6 |      27 |      12 | 0.00673117 |
| yield_6m |       4 |      24 |      12 | 0.00531399 |
| yield_6m |       3 |      18 |      36 | -0.00463471 |
| yield_6m |       2 |      21 |      41 | -0.00330186 |
| yield_1y |       6 |      26 |      12 | 0.00724795 |
| yield_1y |       4 |      22 |      12 | 0.00540452 |
| yield_1y |       3 |      17 |      34 | -0.00530258 |
| yield_1y |       2 |      19 |      39 | -0.00377975 |
| yield_2y |       6 |      24 |      12 | 0.00703129 |
| yield_2y |       4 |      21 |      12 | 0.00493547 |
| yield_2y |       3 |      16 |      33 | -0.00548374 |
| yield_2y |       2 |      18 |      37 | -0.00391656 |
| yield_5y |       6 |      22 |      12 | 0.00562176 |
| yield_5y |       4 |      19 |      35 | -0.00373426 |
| yield_5y |       3 |      15 |      31 | -0.00471479 |
| yield_5y |       2 |      17 |      35 | -0.00338644 |
| yield_10y |       6 |      22 |      12 | 0.00462665 |
| yield_10y |       4 |      19 |      34 | -0.00320861 |
| yield_10y |       3 |      15 |      31 | -0.00398252 |
| yield_10y |       2 |      16 |      35 | -0.00287142 |
| cambio_usd |       6 |      16 |      31 | -0.0973618 |
| cambio_usd |       4 |      14 |      28 | -0.0858791 |
| cambio_usd |       3 |      11 |      26 | -0.0900164 |
| cambio_usd |       2 |      12 |      28 | -0.070451 |
| embi_perc |       6 |      18 |      33 | -0.0976046 |
| embi_perc |       4 |      16 |      30 | -0.084977 |
| embi_perc |       3 |      14 |      28 | -0.089646 |
| embi_perc |       2 |      14 |      30 | -0.0689102 |
| cds_5y |       6 |      19 |      12 | 14.6974 |
| cds_5y |       4 |      17 |      32 | -12.0845 |
| cds_5y |       3 |      14 |      29 | -13.7716 |
| cds_5y |       2 |      15 |      32 | -10.2327 |
| asset_ibov |       6 |       2 |      14 | 1.91904 |
| asset_ibov |       4 |       2 |      12 | 1.67246 |
| asset_ibov |       3 |       2 |      12 | 1.44451 |
| asset_ibov |       2 |       1 |      12 | 1.18813 |

Figura em `p_selection_paths.pdf`.
