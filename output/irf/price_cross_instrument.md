# Bloco de precos atraves da escada de instrumentos

Gerado por `script/price_cross_instrument.R` em 2026-08-25.

Painel de 111 series, `(r,q,p)=(5,5,4)`, `mp_var = yield_6m`, choque +50bp, h = 0..48, duas janelas amostrais. Estimativas de **ponto** (`nboot = 0`) para os tres degraus; a celula pre-COVID de producao recebeu bootstrap de 800 replicas com semente 123.

## A escada

Tres construcoes **aninhadas**, cada uma acrescentando exatamente uma camada, a terceira sendo a producao. O que o desenho aninhado permite ler e a decomposicao entre a camada de **valores** (degrau 1 -> 2) e a de **selecao** (degrau 2 -> 3).

| degrau | rotulo | coluna | valores | mascara |
|---|---|---|---|---|
|     1 | bruta | z_bruto | delta_di | nenhuma |
|     2 | residual | z_bs_purif | e_di_bs | nenhuma |
|     3 | residual+jk | z_jk_bs_purif | e_di_bs | jk_monetary_bs |

`z_bruto_purif` e `z_jk_purif` ficam fora de proposito: usam `e_di`, a purificacao **contemporanea**, cujo lado direito pode absorver o proprio choque. Os tres degraus partem da mesma surpresa de DI em dia de Copom, de modo que a concordancia entre eles diz que o padrao **nao e produzido pela purificacao nem pelo filtro de sinal**; ela nao diz que o padrao e comum entre **esquemas** de identificacao.

## Forca por degrau

`ar_limitada` e xi_mp > 3,84 (conjunto AR de 95% limitado); `bandas_validas` e xi_mp >= 10 (referencia convencional de Staiger-Stock). `impact_mp_pre` e a resposta de `yield_6m` no impacto **antes** da normalizacao, isto e o denominador pelo qual cada IRF da celula e dividida.

| sample | degrau | rung | instrument | n_obs | xi_mp | f_robust_mp | impact_mp_pre | ar_limitada | bandas_validas |
|---|---|---|---|---|---|---|---|---|---|
| full |     1 | bruta | z_bruto |   149 | 4.255 | 5.485 | 5.705e-05 | TRUE | FALSE |
| full |     2 | residual | z_bs_purif |   149 | 3.563 | 4.169 | 5.267e-05 | FALSE | FALSE |
| full |     3 | residual+jk | z_jk_bs_purif |   149 |  5.24 | 10.06 | 0.0001013 | TRUE | FALSE |
| pre_covid |     1 | bruta | z_bruto |    80 | 6.584 | 6.662 | 6.419e-05 | TRUE | FALSE |
| pre_covid |     2 | residual | z_bs_purif |    80 | 6.396 | 6.162 | 6.573e-05 | TRUE | FALSE |
| pre_covid |     3 | residual+jk | z_jk_bs_purif |    80 | 7.478 | 11.87 | 0.0001036 | TRUE | FALSE |

## IPCA cheio em h2-h8

Onde vive a corcova. Pontos em pontos percentuais da taxa mensal.

| sample | degrau | rung | instrument | h2 | h3 | h4 | h5 | h6 | h7 | h8 |
|---|---|---|---|---|---|---|---|---|---|---|
| full |     1 | bruta | z_bruto | 0.01952 | 0.06329 | 0.083 | 0.1097 | 0.09598 | 0.08482 | 0.07771 |
| full |     2 | residual | z_bs_purif | 0.0278 | 0.0736 | 0.0943 | 0.1245 | 0.1104 | 0.09762 | 0.09016 |
| full |     3 | residual+jk | z_jk_bs_purif | 0.03328 | 0.08266 | 0.1089 | 0.1305 | 0.1212 | 0.1148 | 0.1086 |
| pre_covid |     1 | bruta | z_bruto | -0.07744 | -0.1645 | -0.1356 | -0.1078 | -0.157 | -0.1553 | -0.1616 |
| pre_covid |     2 | residual | z_bs_purif | -0.07165 | -0.1676 | -0.1418 | -0.116 | -0.163 | -0.1611 | -0.1656 |
| pre_covid |     3 | residual+jk | z_jk_bs_purif | -0.04613 | -0.1432 | -0.04728 | -0.02864 | -0.104 | -0.0944 | -0.1065 |

## Bloco completo: corcova, ancoras e sinal de medio prazo

`hump_max` e o ponto de maior modulo em h2-h8 e `hump_max_h` o horizonte onde ele ocorre; `n_pos` conta quantos dos 7 horizontes da janela tem ponto positivo. `share_correct` e a fracao de horizontes com sinal igual ao teorico dentro da janela da regua de coerencia (h12-h48 para as seis medidas pontuadas), `NA` para as duas ambiguas.

| sample | var | degrau | rung | hump_max | hump_max_h | n_pos | h0 | h6 | h12 | h24 | share_correct |
|---|---|---|---|---|---|---|---|---|---|---|---|
| full | price_core_ipca_dw |     1 | bruta | 0.07399 |     5 |     7 | 0.006131 | 0.06882 | 0.01217 | -0.0996 | 0.973 |
| full | price_core_ipca_dw |     2 | residual | 0.07912 |     5 |     7 | 0.01133 | 0.07364 | 0.01516 | -0.1029 | 0.9459 |
| full | price_core_ipca_dw |     3 | residual+jk | 0.08169 |     5 |     7 | 0.009341 | 0.0784 | 0.03102 | -0.06593 | 0.9189 |
| full | price_core_ipca_ex0 |     1 | bruta | 0.0896 |     6 |     7 | 0.03384 | 0.0896 | 0.05924 | -0.06507 | 0.8378 |
| full | price_core_ipca_ex0 |     2 | residual | 0.09007 |     6 |     7 | 0.04108 | 0.09007 | 0.05976 | -0.0659 | 0.8378 |
| full | price_core_ipca_ex0 |     3 | residual+jk | 0.09766 |     8 |     7 | 0.02174 | 0.09653 | 0.07401 | -0.03481 | 0.7838 |
| full | price_core_ipca_ex1 |     1 | bruta | 0.05807 |     5 |     7 | -0.02565 | 0.05344 | -0.0042 | -0.116 |     1 |
| full | price_core_ipca_ex1 |     2 | residual | 0.06584 |     5 |     7 | -0.01314 | 0.06087 | -0.0002645 | -0.1205 |     1 |
| full | price_core_ipca_ex1 |     3 | residual+jk | 0.06726 |     5 |     7 | -0.02597 | 0.06479 | 0.01736 | -0.07939 | 0.9459 |
| full | price_igp_m |     1 | bruta | 0.2435 |     4 |     7 | 0.08773 | 0.1596 | -0.1519 | -0.4061 |    NA |
| full | price_igp_m |     2 | residual | 0.2882 |     4 |     7 | 0.09607 | 0.2035 | -0.1257 | -0.4224 |    NA |
| full | price_igp_m |     3 | residual+jk | 0.2479 |     4 |     7 | 0.1307 | 0.1717 | -0.0986 | -0.3083 |    NA |
| full | price_inpc |     1 | bruta | 0.08489 |     5 |     6 | -0.08999 | 0.06645 | -0.06551 | -0.254 |     1 |
| full | price_inpc |     2 | residual | 0.1042 |     5 |     7 | -0.07259 | 0.08535 | -0.05573 | -0.2656 |     1 |
| full | price_inpc |     3 | residual+jk | 0.1055 |     5 |     7 | -0.07163 | 0.09122 | -0.02009 | -0.182 |     1 |
| full | price_ipca |     1 | bruta | 0.1097 |     5 |     7 | -0.06621 | 0.09598 | -0.02172 | -0.2373 |     1 |
| full | price_ipca |     2 | residual | 0.1245 |     5 |     7 | -0.05046 | 0.1104 | -0.01428 | -0.2472 |     1 |
| full | price_ipca |     3 | residual+jk | 0.1305 |     5 |     7 | -0.0549 | 0.1212 | 0.02352 | -0.1632 | 0.973 |
| full | price_ipca_difusao |     1 | bruta | 1.295 |     5 |     7 | 0.3104 | 1.284 | 0.5045 | -1.358 | 0.9189 |
| full | price_ipca_difusao |     2 | residual |  1.34 |     5 |     7 | 0.4622 | 1.325 | 0.5381 | -1.392 | 0.9189 |
| full | price_ipca_difusao |     3 | residual+jk |  1.42 |     6 |     7 | 0.2638 |  1.42 | 0.7675 | -0.8583 | 0.8649 |
| full | price_ipp |     1 | bruta | 0.4287 |     3 |     7 | 0.3582 | 0.1852 | -0.2857 | -0.3968 |    NA |
| full | price_ipp |     2 | residual | 0.4888 |     4 |     7 | 0.3803 | 0.2484 | -0.2417 | -0.4101 |    NA |
| full | price_ipp |     3 | residual+jk | 0.408 |     3 |     6 | 0.4262 | 0.1578 | -0.2701 | -0.3451 |    NA |
| pre_covid | price_core_ipca_dw |     1 | bruta | -0.07894 |     8 |     0 | -0.06123 | -0.07037 | -0.09584 | -0.01877 | 0.4054 |
| pre_covid | price_core_ipca_dw |     2 | residual | -0.08179 |     8 |     0 | -0.05784 | -0.07385 | -0.0969 | -0.01735 | 0.4054 |
| pre_covid | price_core_ipca_dw |     3 | residual+jk | -0.05422 |     8 |     1 | -0.04789 | -0.04653 | -0.0747 | -0.0043 | 0.3514 |
| pre_covid | price_core_ipca_ex0 |     1 | bruta | 0.03093 |     2 |     2 | -0.01997 | -0.00872 | -0.04742 | -0.04397 | 0.6757 |
| pre_covid | price_core_ipca_ex0 |     2 | residual | 0.03101 |     2 |     2 | -0.0192 | -0.01164 | -0.0491 | -0.04404 | 0.6757 |
| pre_covid | price_core_ipca_ex0 |     3 | residual+jk | 0.0543 |     2 |     6 | -0.01242 | 0.001647 | -0.04387 | -0.03166 | 0.6216 |
| pre_covid | price_core_ipca_ex1 |     1 | bruta | -0.09558 |     8 |     0 | -0.0609 | -0.07676 | -0.1031 | -0.008401 | 0.3784 |
| pre_covid | price_core_ipca_ex1 |     2 | residual | -0.09883 |     8 |     0 | -0.05225 | -0.08095 | -0.104 | -0.006778 | 0.3514 |
| pre_covid | price_core_ipca_ex1 |     3 | residual+jk | -0.06639 |     8 |     2 | -0.03405 | -0.04707 | -0.07854 | 0.004626 | 0.3243 |
| pre_covid | price_igp_m |     1 | bruta | -0.3176 |     6 |     0 | -0.3275 | -0.3176 | -0.3035 | 0.043 |    NA |
| pre_covid | price_igp_m |     2 | residual | -0.328 |     6 |     0 | -0.3184 | -0.328 | -0.3041 | 0.04918 |    NA |
| pre_covid | price_igp_m |     3 | residual+jk | -0.2248 |     3 |     0 | -0.29 | -0.2085 | -0.2188 | 0.07055 |    NA |
| pre_covid | price_inpc |     1 | bruta | -0.1708 |     3 |     0 | -0.114 | -0.1504 | -0.1507 | 0.05333 | 0.2432 |
| pre_covid | price_inpc |     2 | residual | -0.1741 |     3 |     0 | -0.08613 | -0.1555 | -0.1496 | 0.05686 | 0.2432 |
| pre_covid | price_inpc |     3 | residual+jk | -0.1672 |     3 |     0 | -0.1489 | -0.09903 | -0.1089 | 0.06119 | 0.1892 |
| pre_covid | price_ipca |     1 | bruta | -0.1645 |     3 |     0 | -0.133 | -0.157 | -0.1736 | 0.01892 | 0.2973 |
| pre_covid | price_ipca |     2 | residual | -0.1676 |     3 |     0 | -0.1145 | -0.163 | -0.1737 | 0.02233 | 0.2973 |
| pre_covid | price_ipca |     3 | residual+jk | -0.1432 |     3 |     0 | -0.1491 | -0.104 | -0.1298 | 0.03567 | 0.2432 |
| pre_covid | price_ipca_difusao |     1 | bruta | 1.028 |     2 |     5 | 1.049 | 0.2343 | -1.485 | -1.608 | 0.6486 |
| pre_covid | price_ipca_difusao |     2 | residual | 1.056 |     2 |     5 |  1.19 | 0.1725 | -1.535 | -1.608 | 0.6486 |
| pre_covid | price_ipca_difusao |     3 | residual+jk | 1.018 |     2 |     5 | 1.138 | 0.1214 | -1.403 | -1.148 | 0.6216 |
| pre_covid | price_ipp |     1 | bruta | 0.2863 |     2 |     6 | 0.03074 | 0.09496 | -0.1047 | -0.1931 |    NA |
| pre_covid | price_ipp |     2 | residual | 0.2882 |     2 |     6 | 0.03875 | 0.07784 | -0.115 | -0.1966 |    NA |
| pre_covid | price_ipp |     3 | residual+jk | 0.5181 |     2 |     6 | 0.4142 | 0.1568 | -0.1022 | -0.158 |    NA |

## O que cada camada acrescenta a corcova

`delta_valores` = degrau 2 menos degrau 1 (efeito da residualizacao sobre informacao predeterminada); `delta_selecao` = degrau 3 menos degrau 2 (efeito do filtro de sinal). Ambos sobre `hump_max`.

| sample | var | d1 | d2 | d3 | delta_valores | delta_selecao | delta_total |
|---|---|---|---|---|---|---|---|
| full | price_core_ipca_dw | 0.07399 | 0.07912 | 0.08169 | 0.005137 | 0.002567 | 0.007704 |
| full | price_core_ipca_ex0 | 0.0896 | 0.09007 | 0.09766 | 0.0004638 | 0.007595 | 0.008059 |
| full | price_core_ipca_ex1 | 0.05807 | 0.06584 | 0.06726 | 0.007774 | 0.00142 | 0.009194 |
| full | price_igp_m | 0.2435 | 0.2882 | 0.2479 | 0.04476 | -0.04031 | 0.004446 |
| full | price_inpc | 0.08489 | 0.1042 | 0.1055 | 0.01932 | 0.001275 | 0.0206 |
| full | price_ipca | 0.1097 | 0.1245 | 0.1305 | 0.01488 | 0.006002 | 0.02089 |
| full | price_ipca_difusao | 1.295 |  1.34 |  1.42 | 0.04473 | 0.07973 | 0.1245 |
| full | price_ipp | 0.4287 | 0.4888 | 0.408 | 0.06016 | -0.08087 | -0.02071 |
| pre_covid | price_core_ipca_dw | -0.07894 | -0.08179 | -0.05422 | -0.002851 | 0.02757 | 0.02472 |
| pre_covid | price_core_ipca_ex0 | 0.03093 | 0.03101 | 0.0543 | 8.13e-05 | 0.02329 | 0.02337 |
| pre_covid | price_core_ipca_ex1 | -0.09558 | -0.09883 | -0.06639 | -0.003249 | 0.03244 | 0.02919 |
| pre_covid | price_igp_m | -0.3176 | -0.328 | -0.2248 | -0.01036 | 0.1032 | 0.09279 |
| pre_covid | price_inpc | -0.1708 | -0.1741 | -0.1672 | -0.003228 | 0.006901 | 0.003672 |
| pre_covid | price_ipca | -0.1645 | -0.1676 | -0.1432 | -0.003066 | 0.02443 | 0.02136 |
| pre_covid | price_ipca_difusao | 1.028 | 1.056 | 1.018 | 0.02869 | -0.03833 | -0.009645 |
| pre_covid | price_ipp | 0.2863 | 0.2882 | 0.5181 | 0.001909 | 0.2299 | 0.2318 |

## Concordancia entre degraus

Numero de degraus (de 3) com `hump_max` positivo em cada janela.

| var | full_positivos | pre_covid_positivos |
|---|---|---|
| price_core_ipca_dw |     3 |     0 |
| price_core_ipca_ex0 |     3 |     3 |
| price_core_ipca_ex1 |     3 |     0 |
| price_igp_m |     3 |     0 |
| price_inpc |     3 |     0 |
| price_ipca |     3 |     0 |
| price_ipca_difusao |     3 |     3 |
| price_ipp |     3 |     3 |

## Celula pre-COVID de producao, com bandas

`z_jk_bs_purif` x `(5,5)` na janela pre-COVID, wild bootstrap de 800 replicas. Raiz maxima da companion = 0.992483: a janela e marginalmente instavel, entao a leitura fica em h <= 12 e as bandas longas nao sao confiaveis.

Nenhum aviso durante o bootstrap desta celula.

| var | h | point | lo68 | hi68 | lo90 | hi90 | sig68 | sig90 |
|---|---|---|---|---|---|---|---|---|
| price_ipca |     0 | -0.1491 | -0.1935 | -0.008769 | -0.2891 | 0.05127 | TRUE | FALSE |
| price_ipca |     2 | -0.04613 | -0.1481 | 0.0286 | -0.2126 | 0.08503 | FALSE | FALSE |
| price_ipca |     3 | -0.1432 | -0.2358 | -0.05253 | -0.3155 | 0.001403 | TRUE | FALSE |
| price_ipca |     4 | -0.04728 | -0.1576 | 0.03363 | -0.2344 | 0.08215 | FALSE | FALSE |
| price_ipca |     5 | -0.02864 | -0.1478 | 0.02338 | -0.229 | 0.08218 | FALSE | FALSE |
| price_ipca |     6 | -0.104 | -0.1985 | -0.03306 | -0.2718 | 0.01866 | TRUE | FALSE |
| price_ipca |     7 | -0.0944 | -0.1862 | -0.009824 | -0.2738 | 0.03795 | TRUE | FALSE |
| price_ipca |     8 | -0.1065 | -0.1916 | -0.0265 | -0.2769 | 0.01422 | TRUE | FALSE |
| price_ipca |    12 | -0.1298 | -0.2018 | -0.04533 | -0.293 | -0.0009834 | TRUE | TRUE |
| price_ipca |    24 | 0.03567 | -0.05985 | 0.09095 | -0.1388 | 0.1684 | FALSE | FALSE |
| price_ipca_difusao |     0 | 1.138 | -0.06854 | 2.228 | -0.9437 |  3.11 | FALSE | FALSE |
| price_ipca_difusao |     2 | 1.018 | -0.208 |   1.6 | -0.8605 | 2.223 | FALSE | FALSE |
| price_ipca_difusao |     3 | 0.8703 | -0.4971 | 1.635 | -1.28 | 2.482 | FALSE | FALSE |
| price_ipca_difusao |     4 | 0.9581 | -0.2619 |   1.7 | -0.9908 | 2.415 | FALSE | FALSE |
| price_ipca_difusao |     5 | 0.6824 | -0.4364 | 1.349 | -1.232 | 1.994 | FALSE | FALSE |
| price_ipca_difusao |     6 | 0.1214 | -0.9092 | 0.9527 | -1.667 | 1.684 | FALSE | FALSE |
| price_ipca_difusao |     7 | -0.2424 | -1.048 | 0.8036 | -2.069 | 1.451 | FALSE | FALSE |
| price_ipca_difusao |     8 | -0.5773 | -1.382 | 0.5083 | -2.327 | 1.206 | FALSE | FALSE |
| price_ipca_difusao |    12 | -1.403 | -2.22 | -0.1568 | -3.337 | 0.5629 | TRUE | FALSE |
| price_ipca_difusao |    24 | -1.148 | -2.393 | -0.3501 | -3.652 | 0.2251 | TRUE | FALSE |
| price_core_ipca_ex0 |     0 | -0.01242 | -0.07619 | 0.04573 | -0.1253 | 0.08779 | FALSE | FALSE |
| price_core_ipca_ex0 |     2 | 0.0543 | -0.01376 | 0.07139 | -0.04695 | 0.103 | FALSE | FALSE |
| price_core_ipca_ex0 |     3 | 0.007176 | -0.06076 | 0.03805 | -0.09724 | 0.07916 | FALSE | FALSE |
| price_core_ipca_ex0 |     4 | 0.02641 | -0.03711 | 0.05128 | -0.07064 | 0.08789 | FALSE | FALSE |
| price_core_ipca_ex0 |     5 | 0.05125 | -0.01722 | 0.06528 | -0.04864 | 0.09914 | FALSE | FALSE |
| price_core_ipca_ex0 |     6 | 0.001647 | -0.05855 | 0.02928 | -0.09341 | 0.06438 | FALSE | FALSE |
| price_core_ipca_ex0 |     7 | 0.002551 | -0.05105 | 0.03338 | -0.08743 | 0.06023 | FALSE | FALSE |
| price_core_ipca_ex0 |     8 | -4.794e-05 | -0.05079 | 0.02818 | -0.08543 | 0.05745 | FALSE | FALSE |
| price_core_ipca_ex0 |    12 | -0.04387 | -0.08152 | -0.008315 | -0.1177 | 0.0147 | TRUE | FALSE |
| price_core_ipca_ex0 |    24 | -0.03166 | -0.08921 | 0.002156 | -0.1364 | 0.03263 | FALSE | FALSE |
| price_core_ipca_ex1 |     0 | -0.03405 | -0.09885 | 0.0654 | -0.1569 | 0.114 | FALSE | FALSE |
| price_core_ipca_ex1 |     2 | 0.01343 | -0.06062 | 0.05074 | -0.0976 | 0.09256 | FALSE | FALSE |
| price_core_ipca_ex1 |     3 | -0.03034 | -0.1078 | 0.02926 | -0.1636 | 0.07427 | FALSE | FALSE |
| price_core_ipca_ex1 |     4 | 0.003716 | -0.08164 | 0.04769 | -0.1224 | 0.09486 | FALSE | FALSE |
| price_core_ipca_ex1 |     5 | -0.01383 | -0.1005 | 0.01688 | -0.1411 | 0.05861 | FALSE | FALSE |
| price_core_ipca_ex1 |     6 | -0.04707 | -0.1269 | -0.00287 | -0.1699 | 0.03268 | TRUE | FALSE |
| price_core_ipca_ex1 |     7 | -0.0502 | -0.1297 | -0.006452 | -0.1696 | 0.03458 | TRUE | FALSE |
| price_core_ipca_ex1 |     8 | -0.06639 | -0.1355 | -0.02372 | -0.1828 | 0.008394 | TRUE | FALSE |
| price_core_ipca_ex1 |    12 | -0.07854 | -0.1397 | -0.03641 | -0.1932 | -0.007573 | TRUE | TRUE |
| price_core_ipca_ex1 |    24 | 0.004626 | -0.06766 | 0.05754 | -0.1143 | 0.1068 | FALSE | FALSE |
| price_core_ipca_dw |     0 | -0.04789 | -0.07472 | 0.01056 | -0.1118 | 0.03942 | FALSE | FALSE |
| price_core_ipca_dw |     2 | 0.01338 | -0.03446 | 0.03742 | -0.05849 | 0.06099 | FALSE | FALSE |
| price_core_ipca_dw |     3 | -0.03457 | -0.07679 | 0.006449 | -0.1131 | 0.03313 | FALSE | FALSE |
| price_core_ipca_dw |     4 | -0.0104 | -0.05942 | 0.02284 | -0.09013 | 0.05125 | FALSE | FALSE |
| price_core_ipca_dw |     5 | -0.00815 | -0.06215 | 0.01433 | -0.09529 | 0.04203 | FALSE | FALSE |
| price_core_ipca_dw |     6 | -0.04653 | -0.09342 | -0.01224 | -0.1282 | 0.01439 | TRUE | FALSE |
| price_core_ipca_dw |     7 | -0.04611 | -0.09408 | -0.00996 | -0.13 | 0.0157 | TRUE | FALSE |
| price_core_ipca_dw |     8 | -0.05422 | -0.09789 | -0.0171 | -0.1376 | 0.005748 | TRUE | FALSE |
| price_core_ipca_dw |    12 | -0.0747 | -0.1184 | -0.03394 | -0.1628 | -0.01196 | TRUE | TRUE |
| price_core_ipca_dw |    24 | -0.0043 | -0.06274 | 0.02636 | -0.1119 | 0.06536 | FALSE | FALSE |
| price_inpc |     0 | -0.1489 | -0.2068 | 0.02325 | -0.3056 | 0.1125 | FALSE | FALSE |
| price_inpc |     2 | -0.0882 | -0.1979 | 0.01292 | -0.2772 | 0.08402 | FALSE | FALSE |
| price_inpc |     3 | -0.1672 | -0.2625 | -0.05794 | -0.3657 | 0.006148 | TRUE | FALSE |
| price_inpc |     4 | -0.04789 | -0.1713 | 0.0397 | -0.2628 | 0.1028 | FALSE | FALSE |
| price_inpc |     5 | -0.03873 | -0.1723 | 0.0173 | -0.262 | 0.07902 | FALSE | FALSE |
| price_inpc |     6 | -0.09903 | -0.2043 | -0.0297 | -0.2908 | 0.02421 | TRUE | FALSE |
| price_inpc |     7 | -0.0896 | -0.1907 | -0.00572 | -0.2836 | 0.04565 | TRUE | FALSE |
| price_inpc |     8 | -0.1043 | -0.1984 | -0.0265 | -0.2792 | 0.01751 | TRUE | FALSE |
| price_inpc |    12 | -0.1089 | -0.1957 | -0.03007 | -0.2949 | 0.018 | TRUE | FALSE |
| price_inpc |    24 | 0.06119 | -0.03226 | 0.1153 | -0.1094 | 0.2035 | FALSE | FALSE |
| price_igp_m |     0 | -0.29 | -0.3816 | -0.05285 | -0.5181 | 0.06268 | TRUE | FALSE |
| price_igp_m |     2 | -0.03432 | -0.1984 | 0.07909 | -0.3185 | 0.1985 | FALSE | FALSE |
| price_igp_m |     3 | -0.2248 | -0.3678 | -0.05654 | -0.5256 | 0.05341 | TRUE | FALSE |
| price_igp_m |     4 | -0.1146 | -0.2811 | 0.04189 | -0.4502 | 0.1416 | FALSE | FALSE |
| price_igp_m |     5 | -0.08566 | -0.2727 | 0.04131 | -0.4593 | 0.1286 | FALSE | FALSE |
| price_igp_m |     6 | -0.2085 | -0.368 | -0.05813 | -0.5252 | 0.02481 | TRUE | FALSE |
| price_igp_m |     7 | -0.1812 | -0.3445 | -0.03169 | -0.4894 | 0.05318 | TRUE | FALSE |
| price_igp_m |     8 | -0.1932 | -0.3594 | -0.04495 | -0.4932 | 0.02807 | TRUE | FALSE |
| price_igp_m |    12 | -0.2188 | -0.3741 | -0.06904 | -0.5425 | 0.008009 | TRUE | FALSE |
| price_igp_m |    24 | 0.07055 | -0.1208 | 0.1845 | -0.3059 | 0.3525 | FALSE | FALSE |
| price_ipp |     0 | 0.4142 | 0.08484 | 0.5984 | -0.1057 | 0.797 | TRUE | FALSE |
| price_ipp |     2 | 0.5181 | 0.1243 | 0.6482 | -0.05265 |   0.9 | TRUE | FALSE |
| price_ipp |     3 | 0.4599 | 0.02428 | 0.6306 | -0.1815 | 0.8727 | TRUE | FALSE |
| price_ipp |     4 | 0.4221 | 0.008653 | 0.6149 | -0.2151 | 0.856 | TRUE | FALSE |
| price_ipp |     5 | 0.2235 | -0.1923 | 0.4378 | -0.4188 | 0.6529 | FALSE | FALSE |
| price_ipp |     6 | 0.1568 | -0.2304 | 0.3622 | -0.4295 | 0.591 | FALSE | FALSE |
| price_ipp |     7 | 0.09432 | -0.2537 | 0.2921 | -0.4575 | 0.4999 | FALSE | FALSE |
| price_ipp |     8 | -0.01042 | -0.3319 | 0.2023 | -0.5366 | 0.4084 | FALSE | FALSE |
| price_ipp |    12 | -0.1022 | -0.3646 | 0.08835 | -0.559 | 0.261 | FALSE | FALSE |
| price_ipp |    24 | -0.158 | -0.3847 | 0.04219 | -0.6385 | 0.1983 | FALSE | FALSE |

### Veredito da regua sobre a celula pre-COVID

| var | tier | theory_sign | h0 | h6 | h12 | h24 | share_correct | first_correct_h | right_sig90 | wrong_sig90 | verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|
| price_ipca | scored |    -1 | -0.1491 | -0.104 | -0.1298 | 0.03567 | 0.2432 |    12 | TRUE | FALSE | incoerente |
| price_ipca_difusao | scored |    -1 | 1.138 | 0.1214 | -1.403 | -1.148 | 0.6216 |    12 | FALSE | FALSE | parcial |
| price_core_ipca_ex0 | scored |    -1 | -0.01242 | 0.001647 | -0.04387 | -0.03166 | 0.6216 |    12 | FALSE | FALSE | parcial |
| price_core_ipca_ex1 | scored |    -1 | -0.03405 | -0.04707 | -0.07854 | 0.004626 | 0.3243 |    12 | TRUE | FALSE | incoerente |
| price_core_ipca_dw | scored |    -1 | -0.04789 | -0.04653 | -0.0747 | -0.0043 | 0.3514 |    12 | TRUE | FALSE | incoerente |
| price_inpc | scored |    -1 | -0.1489 | -0.09903 | -0.1089 | 0.06119 | 0.1892 |    12 | FALSE | FALSE | incoerente |
| price_igp_m | ambiguous |    NA | -0.29 | -0.2085 | -0.2188 | 0.07055 |    NA |    NA | NA | NA | ambigua |
| price_ipp | ambiguous |    NA | 0.4142 | 0.1568 | -0.1022 | -0.158 |    NA |    NA | NA | NA | ambigua |

Trajetorias completas em `price_cross_instrument.csv`; figura em
`price_cross_instrument_paths.pdf`.
