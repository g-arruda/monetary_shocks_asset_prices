# Resultados das IRFs na rodada canônica

> **CURRENT em 2026-08-12.** Esta leitura substitui a rodada de 2026-07-24,
> cuja agregação mensal da curva escolhia uma linha dependente da ordem dos
> dados. O texto canônico do artigo está em `paper/paper_anpec.tex`. Os números
> abaixo vêm de `irf_coherence_h.csv`, `irf_coherence_summary.csv` e
> `mosw_strength_grid.csv`, regenerados na mesma rodada.

## Especificação

O DFM usa 106 séries entre 2013-01 e 2025-09, com 153 observações alinhadas e
147 inovações fatoriais depois das seis defasagens do VAR. A especificação
permanece em r = 7, q = 6 e p = 6, com `z_jk_bs_purif` e normalização de 50
pontos-base em `yield_6m`. As bandas de 68% e 90% vêm de 800 réplicas do
*wild bootstrap*, com semente 123 e horizontes de 0 a 48.

A correção reduziu ξ_mp de 10,43 para 7,65 na amostra completa e de 12,22 para
11,53 na janela pré-COVID. O primeiro valor supera 3,84, mas fica abaixo da
referência convencional de 10, de modo que a leitura das bandas na amostra
completa exige cautela. A especificação não foi reotimizada depois da nova
grade.

## Impactos de manchete

| variável | ponto h0 | banda de 68% | banda de 90% | unidade |
|---|---:|---:|---:|---|
| DI 6 meses | 50,0 | [50,0; 50,0] | [50,0; 50,0] | pontos-base, normalização |
| DI 2 anos | 108,0 | [95,4; 135,1] | [87,4; 156,3] | pontos-base |
| DI 5 anos | 117,0 | [99,1; 158,9] | [85,9; 197,3] | pontos-base |
| Ibovespa | -2,41 | [-8,35; 1,28] | [-13,08; 4,78] | pontos percentuais acumulados |
| BRL/USD | 5,55 | [3,83; 8,87] | [2,82; 13,01] | percentual da média amostral |
| EMBI+ | 32,0 | [22,3; 59,1] | [12,0; 83,4] | pontos-base |
| CDS 5 anos | 43,4 | [32,8; 71,8] | [22,5; 101,3] | pontos-base |

O resultado de curto prazo é o movimento conjunto da curva, do câmbio e do
risco soberano. O BRL/USD exclui zero a 90% de h = 0 a h = 4, enquanto o
EMBI+ o faz em h = 0 e h = 1 e o CDS de h = 0 a h = 4. A resposta é compatível
com transmissão via prêmio de risco, mas o desenho não identifica diretamente
a origem fiscal desse prêmio.

## Curva e reversão

No impacto, os vértices de 3 meses, 1 ano, 2 anos, 5 anos e 10 anos sobem 26,2,
79,6, 108,0, 117,0 e 104,9 pontos-base. Todos excluem zero a 90%. A curva
reverte depois e alcança mínimos entre h = 23 e h = 33, mas
`factor_stationarity.md` mostra que essa faixa depende do modo quase unitário
do VAR dos fatores. A reversão descreve a dinâmica estimada e não fornece uma
confirmação independente do canal de prêmio de risco.

## Demais blocos

A atividade cai no impacto. A indústria de transformação, os bens duráveis,
os bens de capital, o varejo, os serviços, as horas trabalhadas e o IBC-Br
excluem zero a 90% em h = 0. Os mínimos setoriais ocorrem em h = 11 e excluem
zero apenas a 68%.

O crédito agropecuário e o de transporte sobem 1,33% e 1,04% no impacto, com
bandas de 90% positivas. Todos os sete recortes ficam negativos depois, mas a
contração ocorre na banda de 68% e na mesma faixa de persistência do VAR dos
fatores.

O índice de preços ao produtor exclui zero a 90% de h = 0 a h = 4 e atinge
1,37 ponto percentual em h = 1. O IPCA cheio não exclui zero a 90% em nenhum
horizonte. O núcleo EX1 e o índice de difusão caem no médio prazo apenas na
estimativa pontual.

Sete dos oito índices acionários não excluem zero a 90%. O IFIX é a exceção em
h = 1 e h = 2. Como as respostas acionárias ainda usam acumulação de retornos,
a interpretação de médio prazo permanece suspensa até a correção específica do
`cumsum`, que não faz parte desta rodada.

## Coerência

A classificação corrente tem 20 variáveis `coerente_forte`, 6 `coerente`, 12
`parcial`, 1 `incoerente`, 7 `ambigua`, 3 `placebo_ok` e 4 canais *soft*. O
núcleo `price_core_ipca_ex0` é a única incoerência. Os três placebos externos
passam, com uma exclusão a 90% em 147 pares de variável e horizonte.
