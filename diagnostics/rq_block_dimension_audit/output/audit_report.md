# Auditoria conjunta de painel e dimensões `(r,q)`

> Gerado em 2026-08-13. Rodada experimental isolada; não migra a produção nem altera o paper.

## Decisão conjunta

| final_variant | final_r | final_q | removed_blocks | closest_threshold_block | alternative_variant | n_finalists | point_selected_r | point_selected_q | accepted_r | accepted_q | bootstrap_fallback_used | accepted_rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| conjunto_completo_sem_duplicatas |     4 |     3 | none | eua | drop_eua |     4 |     4 |     3 |     4 |     3 | FALSE |     1 |

A amostra completa decide. A janela pré-COVID apenas qualifica relevância, raiz e estabilidade das cinco IRFs curtas. O câmbio permanece canal `soft` e não é contado como erro de sinal.

## Decisões dos blocos

| block | contrasts | unresolved | exclusion_wins | inclusion_wins | remove_block | distance_to_flip |
|---|---|---|---|---|---|---|
| fiscal |    32 |    28 |     3 |     1 | FALSE |    21 |
| setor_externo |    32 |    29 |     0 |     3 | FALSE |    24 |
| expectativas |    32 |    26 |     2 |     4 | FALSE |    22 |
| eua |    32 |    22 |     8 |     2 | FALSE |    16 |
| credito |    32 |    30 |     2 |     0 | FALSE |    22 |
| imoveis |    32 |    27 |     5 |     0 | FALSE |    19 |

Cada bloco tem 32 contrastes pareados. A exclusão só vence um contraste se melhora ao menos quatro dos seis critérios e piora no máximo um; um bloco só é removido com pelo menos 24 vitórias da exclusão e no máximo oito da inclusão.

## Células escolhidas por painel

| variant | removed_blocks | n_series | r | q | bll_r | bll_q | bll_distance_full | xi_mp | max_companion_root | correct_signs_full | xi_mp_pre_covid | max_companion_root_pre_covid | normalized_rmse |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| baseline | fiscal;setor_externo;expectativas;eua;credito;imoveis |   104 |     4 |     3 |     5 |     3 |     1 | 5.137 | 0.9615 |    23 | 5.863 | 0.992 | 3.713 |
| conjunto_completo_sem_duplicatas | none |   123 |     4 |     3 |     4 |     2 |     1 | 5.051 | 0.9626 |    23 | 10.78 | 0.9927 | 1.518 |
| drop_credito | credito |   121 |     4 |     1 |     4 |     2 |     1 | 4.076 | 0.9615 |    24 | 4.539 | 1.003 | 0.7517 |
| drop_credito__imoveis | credito;imoveis |   120 |     4 |     1 |     4 |     2 |     1 | 3.993 | 0.9645 |    23 |  5.09 | 1.001 | 0.7821 |
| drop_eua | eua |   118 |     4 |     3 |     4 |     2 |     1 | 5.281 | 0.9694 |    23 | 10.97 | 1.006 | 1.181 |
| drop_eua__credito | eua;credito |   116 |     4 |     3 |     4 |     3 |     0 | 5.225 | 0.9662 |    23 | 8.959 |     1 | 1.632 |
| drop_eua__credito__imoveis | eua;credito;imoveis |   115 |     4 |     3 |     4 |     3 |     0 | 5.282 | 0.9575 |    23 | 8.383 | 0.9972 | 2.254 |
| drop_eua__imoveis | eua;imoveis |   117 |     4 |     2 |     4 |     2 |     0 | 3.953 | 0.9608 |    28 | 5.673 | 0.9992 | 0.607 |
| drop_expectativas | expectativas |   119 |     3 |     2 |     3 |     2 |     0 | 3.947 | 0.9761 |    24 | 2.928 | 0.988 | 0.5599 |
| drop_expectativas__credito | expectativas;credito |   117 |     3 |     2 |     3 |     2 |     0 | 3.917 | 0.9744 |    23 | 2.709 | 0.9901 | 0.5937 |
| drop_expectativas__credito__imoveis | expectativas;credito;imoveis |   116 |     4 |     3 |     4 |     3 |     0 | 4.623 | 0.9642 |    23 | 5.985 | 0.9932 | 2.043 |
| drop_expectativas__eua | expectativas;eua |   114 |     3 |     3 |     3 |     3 |     0 | 4.949 | 0.9749 |    28 |  3.58 |  0.99 | 0.2081 |
| drop_expectativas__eua__credito | expectativas;eua;credito |   112 |     3 |     3 |     3 |     3 |     0 | 5.301 | 0.9728 |    28 | 3.409 | 0.9919 | 0.2279 |
| drop_expectativas__eua__credito__imoveis | expectativas;eua;credito;imoveis |   111 |     3 |     3 |     3 |     3 |     0 | 5.135 | 0.969 |    28 | 3.442 | 0.9923 | 0.2806 |
| drop_expectativas__eua__imoveis | expectativas;eua;imoveis |   113 |     3 |     3 |     3 |     3 |     0 | 4.787 | 0.9715 |    28 | 3.667 | 0.9909 | 0.2526 |
| drop_expectativas__imoveis | expectativas;imoveis |   118 |     4 |     3 |     4 |     2 |     1 | 4.743 | 0.9659 |    23 | 7.483 | 0.993 |  1.89 |
| drop_fiscal | fiscal |   120 |     4 |     3 |     4 |     2 |     1 | 5.357 | 0.9687 |    23 | 10.43 | 0.9784 |  1.75 |
| drop_fiscal__credito | fiscal;credito |   118 |     4 |     1 |     4 |     2 |     1 | 4.245 | 0.966 |    23 | 4.882 | 0.9978 | 0.7925 |
| drop_fiscal__credito__imoveis | fiscal;credito;imoveis |   117 |     4 |     1 |     4 |     2 |     1 | 4.096 | 0.9608 |    23 | 5.277 | 0.998 | 0.8304 |
| drop_fiscal__eua | fiscal;eua |   115 |     4 |     2 |     4 |     2 |     0 | 4.137 | 0.9764 |    28 | 4.101 | 1.028 | 0.5378 |
| drop_fiscal__eua__credito | fiscal;eua;credito |   113 |     4 |     3 |     4 |     3 |     0 | 5.664 | 0.9745 |    23 | 7.523 | 0.9928 | 2.092 |
| drop_fiscal__eua__credito__imoveis | fiscal;eua;credito;imoveis |   112 |     4 |     2 |     4 |     2 |     0 | 4.112 | 0.9672 |    28 | 5.305 | 0.9938 | 0.6361 |
| drop_fiscal__eua__imoveis | fiscal;eua;imoveis |   114 |     4 |     2 |     4 |     2 |     0 | 4.373 | 0.9702 |    28 | 5.936 | 0.9947 | 0.6404 |
| drop_fiscal__expectativas | fiscal;expectativas |   116 |     3 |     2 |     3 |     2 |     0 | 4.311 | 0.9771 |    24 | 3.008 | 0.9872 | 0.5807 |
| drop_fiscal__expectativas__credito | fiscal;expectativas;credito |   114 |     3 |     2 |     3 |     2 |     0 | 4.315 | 0.9756 |    23 | 2.718 | 0.9894 | 0.6432 |
| drop_fiscal__expectativas__credito__imoveis | fiscal;expectativas;credito;imoveis |   113 |     4 |     3 |     4 |     3 |     0 | 5.072 | 0.9625 |    23 | 5.902 | 0.9924 | 2.536 |
| drop_fiscal__expectativas__eua | fiscal;expectativas;eua |   111 |     3 |     3 |     3 |     3 |     0 | 4.869 | 0.976 |    28 | 4.563 | 0.9891 | 0.2171 |
| drop_fiscal__expectativas__eua__credito | fiscal;expectativas;eua;credito |   109 |     3 |     3 |     3 |     3 |     0 | 5.166 | 0.9742 |    28 | 4.597 | 0.991 | 0.2425 |
| drop_fiscal__expectativas__eua__credito__imoveis | fiscal;expectativas;eua;credito;imoveis |   108 |     3 |     3 |     3 |     3 |     0 | 4.997 | 0.9705 |    28 | 4.477 | 0.9909 | 0.2781 |
| drop_fiscal__expectativas__eua__imoveis | fiscal;expectativas;eua;imoveis |   110 |     3 |     3 |     3 |     3 |     0 | 4.704 | 0.9726 |    28 | 4.516 | 0.9896 | 0.2587 |
| drop_fiscal__expectativas__imoveis | fiscal;expectativas;imoveis |   115 |     4 |     1 |     4 |     2 |     1 | 3.982 | 0.9634 |    23 |  5.65 | 0.9912 | 0.8402 |
| drop_fiscal__imoveis | fiscal;imoveis |   119 |     4 |     2 |     4 |     2 |     0 | 4.029 | 0.9611 |    28 | 5.977 | 0.9976 | 0.6064 |
| drop_fiscal__setor_externo | fiscal;setor_externo |   116 |     5 |     2 |     4 |     2 |     1 | 3.885 | 0.9638 |    28 | 3.617 | 0.9904 | 0.5882 |
| drop_fiscal__setor_externo__credito | fiscal;setor_externo;credito |   114 |     4 |     3 |     4 |     3 |     0 | 5.308 | 0.9635 |    23 |  7.69 | 0.9934 | 2.948 |
| drop_fiscal__setor_externo__credito__imoveis | fiscal;setor_externo;credito;imoveis |   113 |     4 |     1 |     4 |     2 |     1 | 4.596 | 0.9636 |    23 | 5.223 | 0.9938 | 0.786 |
| drop_fiscal__setor_externo__eua | fiscal;setor_externo;eua |   111 |     4 |     3 |     4 |     3 |     0 | 5.524 | 0.9753 |    23 |  5.86 | 0.9832 | 1.951 |
| drop_fiscal__setor_externo__eua__credito | fiscal;setor_externo;eua;credito |   109 |     5 |     2 |     5 |     2 |     0 | 4.188 | 0.9726 |    28 | 5.251 | 0.9989 | 0.6244 |
| drop_fiscal__setor_externo__eua__credito__imoveis | fiscal;setor_externo;eua;credito;imoveis |   108 |     5 |     2 |     5 |     2 |     0 | 4.607 | 0.9654 |    28 | 6.802 | 0.9955 | 0.4009 |
| drop_fiscal__setor_externo__eua__imoveis | fiscal;setor_externo;eua;imoveis |   110 |     5 |     2 |     5 |     2 |     0 |  4.69 | 0.9653 |    28 | 3.435 | 0.9885 | 0.541 |
| drop_fiscal__setor_externo__expectativas | fiscal;setor_externo;expectativas |   112 |     4 |     3 |     4 |     3 |     0 |  4.87 | 0.9599 |    23 |  2.33 | 0.9911 | 2.223 |
| drop_fiscal__setor_externo__expectativas__credito | fiscal;setor_externo;expectativas;credito |   110 |     4 |     3 |     4 |     3 |     0 | 4.835 | 0.9595 |    23 | 4.539 | 0.9908 | 2.074 |
| drop_fiscal__setor_externo__expectativas__credito__imoveis | fiscal;setor_externo;expectativas;credito;imoveis |   109 |     5 |     1 |     5 |     2 |     1 | 5.506 | 0.9688 |    28 | 5.492 | 0.9923 | 0.5347 |
| drop_fiscal__setor_externo__expectativas__eua | fiscal;setor_externo;expectativas;eua |   107 |     5 |     1 |     5 |     2 |     1 | 4.671 | 0.9695 |    28 | 4.489 | 0.9913 | 0.9673 |
| drop_fiscal__setor_externo__expectativas__eua__credito | fiscal;setor_externo;expectativas;eua;credito |   105 |     5 |     4 |     5 |     3 |     1 | 4.429 | 0.9697 |    24 | 8.093 | 0.9987 | 1.603 |
| drop_fiscal__setor_externo__expectativas__eua__imoveis | fiscal;setor_externo;expectativas;eua;imoveis |   106 |     5 |     2 |     5 |     2 |     0 | 4.021 | 0.9656 |    28 | 4.034 | 0.9913 | 0.5646 |
| drop_fiscal__setor_externo__expectativas__imoveis | fiscal;setor_externo;expectativas;imoveis |   111 |     4 |     3 |     4 |     3 |     0 | 4.965 | 0.9661 |    23 | 6.455 | 0.9872 | 3.125 |
| drop_fiscal__setor_externo__imoveis | fiscal;setor_externo;imoveis |   115 |     4 |     2 |     4 |     2 |     0 | 3.954 | 0.9651 |    28 | 5.576 | 0.9921 | 0.5439 |
| drop_imoveis | imoveis |   122 |     4 |     3 |     4 |     2 |     1 | 5.118 | 0.9661 |    23 | 9.653 | 1.001 |     3 |
| drop_setor_externo | setor_externo |   119 |     4 |     1 |     4 |     2 |     1 | 4.107 | 0.9652 |    24 | 4.099 | 0.9926 | 0.7691 |
| drop_setor_externo__credito | setor_externo;credito |   117 |     4 |     3 |     4 |     3 |     0 | 4.981 | 0.9636 |    23 | 9.522 | 0.9967 | 2.117 |
| drop_setor_externo__credito__imoveis | setor_externo;credito;imoveis |   116 |     4 |     3 |     4 |     3 |     0 | 5.068 | 0.9663 |    23 | 8.813 | 0.9953 | 4.191 |
| drop_setor_externo__eua | setor_externo;eua |   114 |     4 |     3 |     4 |     3 |     0 | 5.166 | 0.9675 |    23 | 10.88 | 0.994 | 1.224 |
| drop_setor_externo__eua__credito | setor_externo;eua;credito |   112 |     4 |     3 |     4 |     3 |     0 | 5.134 | 0.9641 |    23 | 8.967 | 0.9958 | 1.798 |
| drop_setor_externo__eua__credito__imoveis | setor_externo;eua;credito;imoveis |   111 |     5 |     1 |     5 |     2 |     1 | 4.477 | 0.9649 |    27 |   6.4 |     1 | 0.5486 |
| drop_setor_externo__eua__imoveis | setor_externo;eua;imoveis |   113 |     4 |     3 |     4 |     3 |     0 | 5.213 | 0.958 |    23 | 9.172 | 0.9944 | 2.801 |
| drop_setor_externo__expectativas | setor_externo;expectativas |   115 |     4 |     3 |     4 |     3 |     0 | 4.488 | 0.9652 |    23 | 3.792 | 0.9926 | 1.473 |
| drop_setor_externo__expectativas__credito | setor_externo;expectativas;credito |   113 |     4 |     3 |     4 |     3 |     0 | 4.392 | 0.9634 |    23 | 8.086 | 0.9919 | 1.439 |
| drop_setor_externo__expectativas__credito__imoveis | setor_externo;expectativas;credito;imoveis |   112 |     4 |     3 |     4 |     3 |     0 | 4.521 | 0.9661 |    23 | 6.042 | 0.9897 | 2.259 |
| drop_setor_externo__expectativas__eua | setor_externo;expectativas;eua |   110 |     4 |     3 |     4 |     3 |     0 | 4.707 | 0.9651 |    23 | 3.738 | 0.9817 | 1.548 |
| drop_setor_externo__expectativas__eua__credito | setor_externo;expectativas;eua;credito |   108 |     5 |     1 |     5 |     2 |     1 | 4.659 | 0.9609 |    27 | 4.954 | 1.008 | 0.6808 |
| drop_setor_externo__expectativas__eua__credito__imoveis | setor_externo;expectativas;eua;credito;imoveis |   107 |     5 |     1 |     5 |     2 |     1 |  4.59 | 0.9638 |    26 | 5.112 | 1.009 | 0.6806 |
| drop_setor_externo__expectativas__eua__imoveis | setor_externo;expectativas;eua;imoveis |   109 |     5 |     1 |     5 |     2 |     1 | 4.322 | 0.9661 |    27 | 4.059 | 0.9988 | 0.7601 |
| drop_setor_externo__expectativas__imoveis | setor_externo;expectativas;imoveis |   114 |     4 |     3 |     4 |     3 |     0 | 4.597 | 0.9677 |    23 | 7.907 | 0.9886 | 2.027 |
| drop_setor_externo__imoveis | setor_externo;imoveis |   118 |     4 |     1 |     4 |     2 |     1 | 3.972 | 0.968 |    24 | 5.245 | 0.9936 | 0.7811 |

## Bootstrap finalista

| variant | r | q | p | n_series | n_months | max_companion_root | stable | nboot | bootstrap_seed | bootstrap_failures | elapsed_minutes | wrong_direction_90 | bootstrap_gate_pass |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| conjunto_completo_sem_duplicatas |     3 |     2 |     6 |   123 |   153 | 0.9764 | TRUE |   800 |   123 |     0 | 0.5682 |     0 | TRUE |
| conjunto_completo_sem_duplicatas |     4 |     3 |     6 |   123 |   153 | 0.9626 | TRUE |   800 |   123 |     0 | 0.4846 |     0 | TRUE |
| conjunto_completo_sem_duplicatas |     7 |     6 |     6 |   123 |   153 | 0.9732 | TRUE |   800 |   123 |     0 | 0.6926 |     0 | TRUE |
| drop_eua |     4 |     3 |     6 |   118 |   153 | 0.9694 | TRUE |   800 |   123 |     0 | 0.5651 |     0 | TRUE |

Os finalistas usam 800 réplicas, semente 123 e bandas de 68%/90%. O gate exige zero falhas, raiz menor que um, normalização exata em +50 pb e nenhuma banda de 90% inteiramente no sentido oposto ao previsto para as três taxas e o Ibovespa em `h=0,...,6`.

## Cobertura

- 64 painéis; 2.304 células full; 64 diagnósticos pré-COVID selecionados; 192 contrastes pareados.
- 4 finalistas distintos, todos com 800 réplicas e zero falhas.
- As 1.152 células na interseção com a grade anterior reproduzem `xi_mp` a `1e-10`.
- Nenhum arquivo de produção ou do paper é produzido por estes scripts.
