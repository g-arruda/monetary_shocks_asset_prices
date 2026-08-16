# Grade fatorial `(r,q)` removendo blocos, sem quase-duplicatas

> **CURRENT, experimental, 2026-08-13.** Rodada isolada produzida por
> `script/panel_composition_rq_grid_drop_blocks.R` em
> `output/panel_experimental/rq_grid_drop_blocks/`. Não altera o painel
> canônico de 106 séries, o instrumento, a identificação, o paper ou os
> artefatos de produção. A validação independente é
> `Rscript script/validate_panel_composition_rq_grid_drop_blocks.R`.

## Desenho fixado

Todos os painéis excluem permanentemente `juros_cdi` e `asset_mlcx`. A união
completa das 19 candidatas tem, portanto, 123 séries. Sobre ela, a rodada remove
todas as combinações dos blocos fiscal, setor externo, expectativas, EUA,
crédito e imóveis: 64 painéis, do
`conjunto_completo_sem_duplicatas` (N=123) ao `baseline` (N=104).

Para cada painel, as janelas cheia (2013-01--2025-09) e pré-COVID
(2013-01--2019-12) são estimadas nos 18 pares admissíveis de
`r ∈ {5,6,7,8}` e `q ∈ {3,4,5,6,7,8}`, com `q ≤ r`. A especificação mantém
`p=6`, `z_jk_bs_purif` e a direção `yield_6m`. São 2.304 DFM de ponto: não há
bootstrap, IRF, figura ou RDS por célula.

## Validação e referências

As 2.304 células foram concluídas, são finitas e têm chave única
`(variant, sample, r, q)`; há 18 pares distintos, `q ≤ r` em todas as células e
zero falhas. O manifesto confirma N entre 104 e 123 segundo
`123 − Σ(séries dos blocos removidos)` e a ausência de ambas as
quase-duplicatas nos 64 painéis.

A célula `baseline`, `(r,q,p)=(7,6,6)`, reproduz exatamente a variante
`drop_near_duplicates` da grade anterior: ξ_mp = 7,9418 na amostra cheia e
9,6900 na pré-COVID. A validação também remonta em memória o
`conjunto_completo_sem_duplicatas` e reproduz suas células de referência:
ξ_mp = 4,7408 na cheia e 17,5887 na pré-COVID.

## Leitura delimitada

A grade mede somente a sensibilidade de ξ_mp à dimensão fatorial e à remoção
de blocos previamente definidos. Não seleciona especificação pelo maior valor,
não muda a produção e não autoriza interpretar ξ_mp como inferência de IRF.

## Ponteiros

- `output/panel_experimental/rq_grid_drop_blocks/rq_grid_drop_blocks_cells.csv`
  contém a tabela longa das 2.304 células.
- `output/panel_experimental/rq_grid_drop_blocks/variant_manifest.csv` registra
  blocos e séries removidos, N e a exclusão explícita das quase-duplicatas.
- `output/panel_experimental/rq_grid_drop_blocks/rq_grid_drop_blocks_report.md`
  registra cobertura, manifesto e falhas; `tables/` contém as 128 superfícies.
