# Seleção BLL de fatores na grade fatorial de remoção de blocos

> Gerado por `script/panel_composition_factor_selection_drop_blocks.R` em 2026-08-17. Rodada experimental isolada; não estima ξ_mp, bootstrap ou IRFs.

## Regra aplicada

Para cada um dos 64 painéis sem `juros_cdi` e `asset_mlcx`, nas duas amostras, Bai--Ng é calculado na padronização BLL sobre primeiras diferenças, com `r ∈ {1,...,20}`. Reportam-se IC1, IC2 e IC3; por convenção do pipeline, `r_ic2` alimenta Amengual--Watson. Amengual--Watson usa o mesmo BLL, VAR com `p=6` e minimiza IC2 sobre `q ∈ {1,...,r_ic2}`. Logo o par automático reportado é `(r_ic2, q_aw_ic2)` e sempre respeita `q ≤ r`.

IC3 é exibido, mas não é usado para selecionar porque bate no limite superior `r=20` em todas as células; esse é um resultado de fronteira, não uma recomendação de 20 fatores.

## Cobertura

| sample | panels | r_ic1_min | r_ic1_max | r_ic2_min | r_ic2_max | r_ic3_at_upper_bound | q_aw_min | q_aw_max |
|---|---|---|---|---|---|---|---|---|
| full |    64 |     5 |     5 |     3 |     5 |    64 |     2 |     3 |
| pre_covid |    64 |     2 |     3 |     2 |     2 |    64 |     2 |     2 |

## Exclusões isoladas e extremos

| variant | removed_blocks | n_blocks_removed | sample | n_series | n_months | r_ic1 | r_ic2 | r_ic3 | r_ic3_at_upper_bound | q_aw_ic2 | p_aw |
|---|---|---|---|---|---|---|---|---|---|---|---|
| conjunto_completo_sem_duplicatas | none |     0 | full |   123 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_credito | credito |     1 | full |   121 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_eua | eua |     1 | full |   118 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_expectativas | expectativas |     1 | full |   119 |   153 |     5 |     3 |    20 | TRUE |     2 |     6 |
| drop_fiscal | fiscal |     1 | full |   120 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_imoveis | imoveis |     1 | full |   122 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_setor_externo | setor_externo |     1 | full |   119 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| baseline | fiscal;setor_externo;expectativas;eua;credito;imoveis |     6 | full |   104 |   153 |     5 |     5 |    20 | TRUE |     3 |     6 |
| conjunto_completo_sem_duplicatas | none |     0 | pre_covid |   123 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_credito | credito |     1 | pre_covid |   121 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_eua | eua |     1 | pre_covid |   118 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas | expectativas |     1 | pre_covid |   119 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal | fiscal |     1 | pre_covid |   120 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_imoveis | imoveis |     1 | pre_covid |   122 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo | setor_externo |     1 | pre_covid |   119 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| baseline | fiscal;setor_externo;expectativas;eua;credito;imoveis |     6 | pre_covid |   104 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |

## Todas as combinações

### Amostra cheia

| variant | sample | n_series | n_months | r_ic1 | r_ic2 | r_ic3 | r_ic3_at_upper_bound | q_aw_ic2 | p_aw |
|---|---|---|---|---|---|---|---|---|---|
| baseline | full |   104 |   153 |     5 |     5 |    20 | TRUE |     3 |     6 |
| conjunto_completo_sem_duplicatas | full |   123 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_credito | full |   121 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_credito__imoveis | full |   120 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_eua | full |   118 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_eua__credito | full |   116 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_eua__credito__imoveis | full |   115 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_eua__imoveis | full |   117 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_expectativas | full |   119 |   153 |     5 |     3 |    20 | TRUE |     2 |     6 |
| drop_expectativas__credito | full |   117 |   153 |     5 |     3 |    20 | TRUE |     2 |     6 |
| drop_expectativas__credito__imoveis | full |   116 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_expectativas__eua | full |   114 |   153 |     5 |     3 |    20 | TRUE |     3 |     6 |
| drop_expectativas__eua__credito | full |   112 |   153 |     5 |     3 |    20 | TRUE |     3 |     6 |
| drop_expectativas__eua__credito__imoveis | full |   111 |   153 |     5 |     3 |    20 | TRUE |     3 |     6 |
| drop_expectativas__eua__imoveis | full |   113 |   153 |     5 |     3 |    20 | TRUE |     3 |     6 |
| drop_expectativas__imoveis | full |   118 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal | full |   120 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__credito | full |   118 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__credito__imoveis | full |   117 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__eua | full |   115 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__eua__credito | full |   113 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_fiscal__eua__credito__imoveis | full |   112 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__eua__imoveis | full |   114 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas | full |   116 |   153 |     5 |     3 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__credito | full |   114 |   153 |     5 |     3 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__credito__imoveis | full |   113 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_fiscal__expectativas__eua | full |   111 |   153 |     5 |     3 |    20 | TRUE |     3 |     6 |
| drop_fiscal__expectativas__eua__credito | full |   109 |   153 |     5 |     3 |    20 | TRUE |     3 |     6 |
| drop_fiscal__expectativas__eua__credito__imoveis | full |   108 |   153 |     5 |     3 |    20 | TRUE |     3 |     6 |
| drop_fiscal__expectativas__eua__imoveis | full |   110 |   153 |     5 |     3 |    20 | TRUE |     3 |     6 |
| drop_fiscal__expectativas__imoveis | full |   115 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__imoveis | full |   119 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo | full |   116 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__credito | full |   114 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_fiscal__setor_externo__credito__imoveis | full |   113 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__eua | full |   111 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_fiscal__setor_externo__eua__credito | full |   109 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__eua__credito__imoveis | full |   108 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__eua__imoveis | full |   110 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas | full |   112 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_fiscal__setor_externo__expectativas__credito | full |   110 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_fiscal__setor_externo__expectativas__credito__imoveis | full |   109 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__eua | full |   107 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__eua__credito | full |   105 |   153 |     5 |     5 |    20 | TRUE |     3 |     6 |
| drop_fiscal__setor_externo__expectativas__eua__imoveis | full |   106 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__imoveis | full |   111 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_fiscal__setor_externo__imoveis | full |   115 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_imoveis | full |   122 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_setor_externo | full |   119 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__credito | full |   117 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__credito__imoveis | full |   116 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__eua | full |   114 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__eua__credito | full |   112 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__eua__credito__imoveis | full |   111 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__eua__imoveis | full |   113 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__expectativas | full |   115 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__expectativas__credito | full |   113 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__expectativas__credito__imoveis | full |   112 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__expectativas__eua | full |   110 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__expectativas__eua__credito | full |   108 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__eua__credito__imoveis | full |   107 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__eua__imoveis | full |   109 |   153 |     5 |     5 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__imoveis | full |   114 |   153 |     5 |     4 |    20 | TRUE |     3 |     6 |
| drop_setor_externo__imoveis | full |   118 |   153 |     5 |     4 |    20 | TRUE |     2 |     6 |

### Amostra pré-COVID

| variant | sample | n_series | n_months | r_ic1 | r_ic2 | r_ic3 | r_ic3_at_upper_bound | q_aw_ic2 | p_aw |
|---|---|---|---|---|---|---|---|---|---|
| baseline | pre_covid |   104 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| conjunto_completo_sem_duplicatas | pre_covid |   123 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_credito | pre_covid |   121 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_credito__imoveis | pre_covid |   120 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_eua | pre_covid |   118 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_eua__credito | pre_covid |   116 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_eua__credito__imoveis | pre_covid |   115 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_eua__imoveis | pre_covid |   117 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas | pre_covid |   119 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas__credito | pre_covid |   117 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas__credito__imoveis | pre_covid |   116 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas__eua | pre_covid |   114 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas__eua__credito | pre_covid |   112 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas__eua__credito__imoveis | pre_covid |   111 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas__eua__imoveis | pre_covid |   113 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_expectativas__imoveis | pre_covid |   118 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal | pre_covid |   120 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__credito | pre_covid |   118 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__credito__imoveis | pre_covid |   117 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__eua | pre_covid |   115 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__eua__credito | pre_covid |   113 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__eua__credito__imoveis | pre_covid |   112 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__eua__imoveis | pre_covid |   114 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas | pre_covid |   116 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__credito | pre_covid |   114 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__credito__imoveis | pre_covid |   113 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__eua | pre_covid |   111 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__eua__credito | pre_covid |   109 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__eua__credito__imoveis | pre_covid |   108 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__eua__imoveis | pre_covid |   110 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__expectativas__imoveis | pre_covid |   115 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__imoveis | pre_covid |   119 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo | pre_covid |   116 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__credito | pre_covid |   114 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__credito__imoveis | pre_covid |   113 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__eua | pre_covid |   111 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__eua__credito | pre_covid |   109 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__eua__credito__imoveis | pre_covid |   108 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__eua__imoveis | pre_covid |   110 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas | pre_covid |   112 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__credito | pre_covid |   110 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__credito__imoveis | pre_covid |   109 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__eua | pre_covid |   107 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__eua__credito | pre_covid |   105 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__eua__imoveis | pre_covid |   106 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__expectativas__imoveis | pre_covid |   111 |    84 |     2 |     2 |    20 | TRUE |     2 |     6 |
| drop_fiscal__setor_externo__imoveis | pre_covid |   115 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_imoveis | pre_covid |   122 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo | pre_covid |   119 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__credito | pre_covid |   117 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__credito__imoveis | pre_covid |   116 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__eua | pre_covid |   114 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__eua__credito | pre_covid |   112 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__eua__credito__imoveis | pre_covid |   111 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__eua__imoveis | pre_covid |   113 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas | pre_covid |   115 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__credito | pre_covid |   113 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__credito__imoveis | pre_covid |   112 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__eua | pre_covid |   110 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__eua__credito | pre_covid |   108 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__eua__credito__imoveis | pre_covid |   107 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__eua__imoveis | pre_covid |   109 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__expectativas__imoveis | pre_covid |   114 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |
| drop_setor_externo__imoveis | pre_covid |   118 |    84 |     3 |     2 |    20 | TRUE |     2 |     6 |

## Leitura delimitada

Os critérios descrevem a dimensão estatística que melhor equilibra ajuste e penalidade dentro de cada painel. Não escolhem a especificação de produção sozinhos: a escolha também precisa respeitar a estabilidade do VAR, a identificação proxy e a inferência. Em particular, não se deve substituir uma seleção BLL por uma célula de ξ_mp máximo.

## Arquivos

- `factor_selection_cells.csv`: uma seleção por painel e amostra.
- `bai_ng_bll_criteria.csv`: as três superfícies Bai--Ng completas, `r=1,...,20`.
- `amengual_watson_criteria.csv`: o IC2 de Amengual--Watson para cada `q` admissível.
- `single_block_exclusions.csv`: recorte da união sem exclusões, das seis exclusões unitárias e do baseline.
