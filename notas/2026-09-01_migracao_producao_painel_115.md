# Migração da produção para o painel de 115 séries

> **SUPERSEDED em 2026-09-02 para números do DFM.** Esta nota substituiu a rodada experimental
> `2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais.md` como registro
> da especificação de produção.

## Decisão e composição

O painel canônico passa a conter 115 séries por 153 meses (2013-01--2025-09).
As quatro promoções são `dlsp_exchange_adjustment`,
`expect_focus_fiscal_dlsp_ny`, `expect_focus_fiscal_primary_balance_ny` e
`expect_focus_fiscal_nominal_balance_ny`. `clean.R` constrói todas a partir do
workbook DLSP e do arquivo Focus raw, sem depender de artefatos experimentais.
O ajuste cambial é a linha publicada e a auditoria exige que coincida, dentro
da tolerância de arredondamento, com as duas sublinhas publicadas.

## Seleção e diagnósticos

A especificação é `(r,q,p)=(4,4,4)`. IC2 Bai--Ng BLL seleciona `r=4`; o AIC
seleciona `p=4` (6,826217) com tendência somente na seleção e o BIC seleciona
`p=2`. Amengual--Watson BLL condicionado a `r=4,p=4` seleciona `q=2` (IC2
-0,420423), mas a decisão explícita mantém `q=4`.

Na amostra completa, `xi_mp=6,383502`, `F_rob,mp=14,162509` e a maior raiz é
0,972109; na pré-COVID, são 7,188089, 12,707070 e 0,984677. As companions são
estáveis. O bootstrap wild de 800 réplicas, semente 123, não teve falhas,
produziu bandas finitas e ordenadas e preservou `yield_6m(h=0)=0,005`.

## Artefatos produtores

`script/clean.R`, `script/q_selection.R`, `script/p_selection.R`,
`script/mosw_strength_grid.R`, `script/irf_coherence_check.R`,
`script/model_alessi.R`, `script/fig_section5.R`, `script/fig_weak_iv.R` e
`script/validate_production_spec.R --bootstrap` foram executados. As figuras
fiscais e de expectativas leem apenas o cache canônico
`output/irf/irf_coherence_cell.rds`.
