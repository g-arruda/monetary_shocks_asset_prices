# Grade experimental de fatores `(r,q)` sobre a composição do painel

> **CURRENT, experimental, 2026-08-13.** Rodada isolada produzida por
> `script/panel_composition_rq_grid.R` em
> `output/panel_experimental/rq_grid/`. Reutiliza os nove painéis e as duas
> janelas da rodada de composição, sem alterar o painel canônico de 106
> séries, o instrumento, a identificação, o paper ou os artefatos de
> produção. A validação independente é
> `Rscript script/validate_panel_composition_rq_grid.R`.

## Desenho fixado

Para cada uma das nove variantes de painel — baseline, retirada das duas
quase-duplicatas, os seis blocos isolados e sua união — a rodada estima DFM de
ponto nas amostras cheia (2013-01--2025-09) e pré-COVID (2013-01--2019-12).
Mantém `p=6`, `z_jk_bs_purif` e a direção de normalização em `yield_6m`; varia
somente `r ∈ {5,6,7,8}` e `q ∈ {3,4,5,6,7,8}`, impondo `q ≤ r`.

São 18 pares admissíveis por variante e amostra, portanto 324 células. Não há
bootstrap, IRF, figura ou RDS por célula: o único objeto é a sensibilidade de
`xi_mp` à dimensão fatorial. A rotina é a MOSW já usada no projeto, aplicada
à inovação de `yield_6m` implícita no espaço dos fatores.

## Cobertura e validação

As 324 células foram concluídas, são finitas e têm chave única
`(variante, amostra, r, q)`; não há par com `q > r` nem falha de estimação. A
amostra cheia tem N entre 104 e 125, T=153 e 147 observações alinhadas da
inovação; a pré-COVID tem T=84 e 78 observações alinhadas.

A célula de referência da rodada anterior foi reproduzida exatamente no
baseline: `(r,q,p)=(7,6,6)` entrega `xi_mp = 7,6478` na amostra cheia e
`11,5349` na pré-COVID, isto é, 7,65 e 11,53 nas casas reportadas. O
validador reestima independentemente essas duas células a partir do painel
canônico e exige a mesma reprodução.

## Resultados descritivos

No conjunto das 162 células da amostra cheia, `xi_mp` varia de 1,23 a 11,62;
24 células ficam em `xi_mp ≤ 3,84` e 13 em `xi_mp ≥ 10`. Nas 162 células
pré-COVID, a faixa é 1,46--17,86; 13 ficam em `xi_mp ≤ 3,84` e 63 em
`xi_mp ≥ 10`. As superfícies completas por variante e amostra estão nos 18
arquivos `tables/xi_mp_<variante>_<amostra>.md`.

No painel baseline, a amostra cheia atinge 11,62 em `(8,8)` e 10,92 em
`(7,7)`, enquanto a referência `(7,6)` é 7,65. Na pré-COVID, o máximo do
baseline é 12,20 em `(7,4)` e `(7,6)` permanece em 11,53. Esses números são
descrições de sensibilidade, não uma regra de escolha.

## Regra de leitura

Nenhuma especificação é selecionada pelo maior `xi_mp`. A grade não muda a
composição canônica, o instrumento ou a interpretação das bandas: para isso
seria necessária evidência adicional sobre estabilidade das respostas e
inferência, que deliberadamente está fora do escopo desta rodada.

## Ponteiros

- `output/panel_experimental/rq_grid/rq_grid_cells.csv`: tabela longa das 324
  células, com variante, amostra, `(r,q,p)`, N, T alinhado, `xi_mp` e
  classificação MOSW.
- `output/panel_experimental/rq_grid/rq_grid_report.md`: cobertura, baseline
  e falhas.
- `output/panel_experimental/rq_grid/rq_grid_failures.csv`: arquivo vazio de
  falhas nesta rodada.
- `script/panel_composition_rq_grid.R` e
  `script/validate_panel_composition_rq_grid.R`: produção e validação.
