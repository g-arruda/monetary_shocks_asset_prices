# Seleção BLL de fatores sob remoção fatorial de blocos

> **CURRENT, experimental, 2026-08-13.** Rodada isolada produzida por
> `script/panel_composition_factor_selection_drop_blocks.R` em
> `output/panel_experimental/rq_grid_drop_blocks/factor_selection/`. Não altera
> o painel canônico, a especificação de produção, o instrumento ou o paper.

## Desenho

Os 64 painéis da grade fatorial removem permanentemente `juros_cdi` e
`asset_mlcx`; os seis blocos candidatos são removidos em todas as combinações.
Para cada painel, Bai--Ng é calculado na padronização BLL, sobre primeiras
diferenças, para `r=1,...,20`. Reportam-se IC1, IC2 e IC3. O `r` operacional
automático é o mínimo de IC2; Amengual--Watson então usa esse `r`, a mesma
padronização BLL, `p=6` — para coincidir com a grade experimental — e seleciona
`q` pelo seu IC2 entre `1` e `r`.

## Resultado

Na amostra cheia, IC1 escolhe `r=5` em **64/64** painéis. IC2 escolhe `r=3` em
12 painéis, `r=4` em 40 e `r=5` em 12; Amengual--Watson escolhe `q=2` em 34 e
`q=3` em 30. Portanto, nenhum painel automático recomenda `(8,8)`.

Na pré-COVID, IC2 e Amengual--Watson escolhem **(2,2) em 64/64 painéis**;
IC1 escolhe `r=2` em 23 e `r=3` em 41. A evidência automática, assim, torna a
dimensão alta ainda menos defensável na amostra curta.

Nas exclusões unitárias, a amostra cheia recomenda `(r_IC2,q_AW)` igual a
`(4,2)` ao remover fiscal, setor externo, EUA, crédito ou imóveis, e `(3,2)`
ao remover expectativas. A união sem exclusões também dá `(4,2)`. O baseline
sem todos os blocos candidatos dá `(5,3)`. Na pré-COVID, todas essas células
dão `(2,2)`.

IC3 bate o limite de busca `r=20` em 128/128 células. É resultado de fronteira,
portanto não uma recomendação para aumentar a dimensão nem uma alternativa
operacional a IC2.

## Leitura delimitada

Isso não substitui a escolha de produção por uma regra mecânica: seleção de
fatores, estabilidade do VAR, relevância do instrumento e inferência respondem
a perguntas distintas. Mas elimina a justificativa de que o ξ_mp máximo em
`(8,8)` seria, por si só, evidência a favor daquela dimensão. Nenhuma célula
automática da rodada recomenda `r` ou `q` maiores que 5 e 3 na amostra cheia,
ou maiores que 2 e 2 na pré-COVID.

## Ponteiros

- `factor_selection_report.md` contém a tabela das 64 combinações por janela.
- `factor_selection_cells.csv` contém as 128 seleções.
- `bai_ng_bll_criteria.csv` e `amengual_watson_criteria.csv` preservam todas as
  funções-critério, não apenas seus mínimos.
