# Grade experimental de fatores (r,q)

> Gerado por `script/panel_composition_rq_grid.R` em 2026-08-16. Esta rodada só estima DFM de ponto e ξ_mp; não roda bootstrap, IRFs, figuras ou RDS de células.

## Desenho fixado

Nove variantes de painel da rodada de composição, amostras cheia e pré-COVID, `r ∈ {5,6,7,8}`, `q ∈ {3,4,5,6,7,8}` com `q ≤ r` (18 pares), `p=6`, instrumento `z_jk_bs_purif` e direção de normalização `yield_6m`.

## Cobertura

| variants | samples | rq_pairs | expected_cells | completed_cells | failed_cells |
|---|---|---|---|---|---|
|     9 |     2 |    18 |   324 |   324 |     0 |

## Referência baseline (r=7, q=6, p=6)

| sample | xi_mp | mosw_class |
|---|---|---|
| full | 7.648 | xi_mp_3.84_10 |
| pre_covid | 11.53 | xi_mp_ge_10 |

## Falhas

Nenhuma.

## Leitura delimitada

A grade descreve a sensibilidade de ξ_mp à dimensão fatorial sob painéis e janelas já pré-especificados. Ela não seleciona uma especificação pelo maior ξ_mp e não altera painel canônico, instrumento, identificação ou inferência por bandas.

## Arquivos

- `rq_grid_cells.csv`: tabela longa com todas as células completas.
- `rq_grid_failures.csv`: falhas explícitas por variante, amostra e par (r,q).
- `tables/xi_mp_<variante>_<amostra>.md`: superfícies ξ_mp e classificação MOSW.
- `variant_manifest.csv`: composição e cobertura dos nove painéis.
