# Correção do fechamento mensal da curva e novo vintage canônico

> **SUPERSEDED como produção em 2026-08-13.** A correção de fechamento mensal
> e sua auditoria continuam válidas, mas as magnitudes da célula de 106 séries
> `(7,6)` foram substituídas pela produção de 111 séries `(5,5)`. Ver
> [`2026-08-13_migracao_producao_painel_111_r5q5`](2026-08-13_migracao_producao_painel_111_r5q5.md).

> **CURRENT em 2026-08-12.** Esta nota substitui todas as magnitudes do DFM e
> estatísticas de força calculadas no vintage de 2026-07-24. As conclusões
> metodológicas das notas anteriores continuam válidas quando não dependem de
> número reestimado. Fontes da rodada: `script/download.R`, `script/clean.R`,
> `script/instrument.R`, os produtores listados em `script/README.md` e os
> artefatos regenerados em `output/` e `diagnostics/output/`.

## O defeito e a correção

`script/download.R` agrupava a curva diária por mês e escolhia a última linha
do grupo. Como `data/raw/yields/yields_dia.csv` não está ordenado a partir de
2023, a linha escolhida não era a maior data mensal. A correção usa
`slice_max(order_by = data, n = 1, with_ties = FALSE)` na curva e no EMBI+.
`R/data_download/anbima_breakeven.R` recebeu a mesma regra, ordenada por
`date`. Os três caminhos abortam diante de datas inválidas ou de mais de uma
observação por mês depois da seleção.

O arquivo externo `data/raw/yields/yields_dia.csv` não foi modificado. Seu
SHA-256 ao fim da rodada é
`90b60178ecd8fc7a7feab687851a2c93048f2bead3ef07728532f35fa68733d6`.

## Auditoria das datas

O teste com linhas diárias deliberadamente fora de ordem selecionou a maior
data mensal nos três caminhos. No arquivo completo, 25 meses diferem da regra
anterior. A amostra do DFM contém 23 deles.

| período | meses afetados | data antiga | maior data mensal |
|---|---:|---|---|
| 2023-01 a 2023-11 | 11 | dias 8 a 12 | último dia útil do mês |
| 2024-01 a 2024-03 | 3 | dias 4 e 5 | último dia útil do mês |
| 2025-01 a 2025-09 | 9 | dias 11 e 12 | último dia útil do mês |
| 2025-10 a 2025-11 | 2 | dia 12 | último dia útil do mês |

A última linha de cada mês corrigido coincide com o máximo de `Data` dentro do
mês. Não há data inválida nem mês duplicado na saída. O painel processado
mantém janeiro de 2013 a setembro de 2025, 106 séries e 153 observações. O
VAR(6) gera 147 inovações fatoriais, que são as observações usadas nos
diagnósticos de força.

## Correção da curva e revisões remotas

O download canônico também incorporou revisões das fontes online. No arquivo
bruto, as revisões fora da curva atingiram `pib` em 104 meses e as séries
`ind_automoveis`, `ind_leves3`, `ind_caminhoes3` e `ind_onibus1` em até três
meses. O ajuste sazonal propaga essas revisões pelo painel processado. O
instrumento permanece idêntico até 2025-09.

Para separar as duas fontes, estimamos três pontos sem bootstrap. A primeira
coluna usa o vintage defeituoso, a segunda troca apenas a curva pela seleção da
maior data e a terceira usa a atualização canônica completa. A decomposição
exata está em `output/irf/month_end_correction_decomposition.csv`.

| variável | vintage defeituoso | somente curva | canônico | efeito da curva | outras revisões |
|---|---:|---:|---:|---:|---:|
| `yield_6m` | 0,005000 | 0,005000 | 0,005000 | 0 | 0 |
| `yield_2y` | 0,009164 | 0,010804 | 0,010802 | 0,001640 | -0,000002 |
| `yield_5y` | 0,009274 | 0,011679 | 0,011702 | 0,002404 | 0,000023 |
| `asset_ibov` | -1,6726 | -2,3436 | -2,4071 | -0,6710 | -0,0636 |
| `cambio_usd` | 0,1498 | 0,2279 | 0,2281 | 0,0782 | 0,0002 |

A correção da curva explica quase toda a mudança nas cinco respostas. As
revisões remotas têm efeito pequeno, exceto pela queda adicional de 0,064 ponto
percentual no Ibovespa.

## Nova rodada canônica

O ξ_mp de produção passa de 10,43 para 7,65 na amostra completa e de 12,22
para 11,53 pré-COVID. A estatística permanece acima de 3,84 nas duas janelas,
mas fica abaixo da referência convencional de 10 na amostra completa. A
especificação r = 7 e q = 6 permaneceu congelada, embora a nova grade tenha uma
única célula acima de 10 nas duas janelas, r = 7 e q = 7.

Com 800 réplicas, os impactos canônicos são 108,0 pontos-base no DI de 2 anos,
117,0 no DI de 5 anos, -2,41% no Ibovespa, 5,55% no BRL/USD, 32,0 pontos-base
no EMBI+ e 43,4 pontos-base no CDS. As bandas de 90% excluem zero para curva,
câmbio e risco soberano, mas contêm zero no Ibovespa.

Os diagnósticos de FOMC e de risco soberano preservam seus vereditos. O teste
FOMC não detecta confundimento e leva ξ_mp a 6,59 quando rederiva a máscara. O
teste soberano não detecta seleção excessiva de risco e leva ξ_mp a 8,97 na
variante que ortogonaliza os valores ao EMBI+, ao câmbio e ao CDS. Nenhuma
dessas variantes elimina a ressalva de força na amostra completa.

## Fechamento

O cache central, os sweeps, os diagnósticos, as figuras e o manuscrito foram
regenerados. `paper/paper_anpec.tex` já não carrega magnitudes do vintage
defeituoso. As pendências do `cumsum` acionário e da correção de Kilian
permanecem abertas e não foram alteradas nesta rodada.
