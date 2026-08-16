# Resultados das IRFs na rodada canônica

> **CURRENT em 2026-08-13.** Esta leitura substitui a produção de 106 séries
> em `(r,q)=(7,6)`. O texto canônico do artigo continua em
> `paper/paper_anpec.tex`, que não foi alterado nesta migração. Os números abaixo
> vêm de `irf_coherence_h.csv`, `irf_coherence_summary.csv` e dos diagnósticos
> de força regenerados na mesma rodada.

## Especificação

O DFM usa o painel `drop_setor_externo__eua__credito__imoveis`, com 111 séries,
153 observações mensais entre 2013-01 e 2025-09 e 147 inovações fatoriais após
o VAR(6). Saem `juros_cdi`, `asset_mlcx` e os blocos candidatos de setor
externo, EUA, crédito e imóveis; entram as três séries fiscais e as quatro de
expectativas. O painel-base de 106 séries fica preservado em arquivo separado
apenas para reproduzir as grades fatoriais históricas.

A produção usa `r=5`, selecionado pelo Bai--Ng IC2 padronizado para o desenho
BLL, e `q=5` como default operacional provisório; a fundamentação metodológica
de `q` permanece aberta. Os demais parâmetros são `p=6`, instrumento
`z_jk_bs_purif`, normalização de +50 pontos-base em `yield_6m`, horizontes 0--48
e bandas de 68%/90% com 800 réplicas do *wild bootstrap* e semente 123.

Na amostra completa, `xi_mp=6,27085`, `F_rob,mp=10,12054` e a maior raiz da
companion é 0,964858. Na janela pré-COVID, `xi_mp=10,99268`,
`F_rob,mp=9,74746` e a maior raiz é 1,000202: essa janela é marginalmente
instável e não deve ser usada como evidência dinâmica. O bootstrap canônico
teve zero falhas, bandas finitas e ordenadas e normalização exata em 0,005.

## Impactos de manchete

| variável | ponto h0 | banda de 68% | banda de 90% | unidade |
|---|---:|---:|---:|---|
| DI 6 meses | 50,0 | [50,0; 50,0] | [50,0; 50,0] | pontos-base, normalização |
| DI 2 anos | 74,3 | [65,5; 85,9] | [60,8; 94,8] | pontos-base |
| DI 5 anos | 77,6 | [66,3; 96,2] | [57,9; 111,0] | pontos-base |
| Ibovespa | -1,72 | [-5,04; -0,63] | [-6,91; 0,78] | pontos percentuais acumulados |
| BRL/USD | 3,84 | [2,73; 4,94] | [2,24; 6,06] | percentual da média amostral |
| EMBI+ | 26,2 | [20,7; 37,9] | [17,2; 47,3] | pontos-base |
| CDS 5 anos | 32,5 | [26,3; 44,4] | [22,2; 53,8] | pontos-base |

O resultado de curto prazo continua sendo o movimento conjunto da curva, do
câmbio e do risco soberano. BRL/USD exclui zero a 90% de h=0 a h=6; EMBI+ de
h=0 a h=7; e CDS de h=0 a h=7. A resposta é compatível com transmissão via
prêmio de risco, mas o desenho não identifica diretamente a origem fiscal
desse prêmio.

## Curva e reversão

No impacto, os vértices de 3 meses, 1 ano, 2 anos, 5 anos e 10 anos sobem 38,7,
63,3, 74,3, 77,6 e 70,3 pontos-base. Todos excluem zero a 90%. A maior raiz da
companion é 0,964858; a decomposição espectral reproduz a IRF de produção com
erro máximo de `9,66e-13` e mostra que apagar o par dominante não elimina os
vales de 13 das 14 respostas examinadas. A reversão é uma descrição da dinâmica
estimada, não uma confirmação independente do canal econômico.

## Demais blocos

Na atividade, indústria de transformação, bens duráveis, horas trabalhadas e
IBC-Br caem no impacto com banda de 90% abaixo de zero; PIB e serviços não
apresentam a mesma resposta. No crédito, várias respostas sobem no curto prazo
e revertem depois, o que gera cinco classificações incoerentes no bloco e
reforça a cautela com a interpretação de médio prazo.

O índice de preços ao produtor exclui zero a 90% de h=0 a h=3. O IPCA cheio
não exclui zero a 90% em nenhum horizonte. No bloco acionário, os sete índices
caem no impacto; apenas o IFIX exclui zero a 90%, em quatro horizontes. As
bandas de 68% não são interpretadas como significância.

## Coerência

A classificação corrente tem 18 variáveis `coerente_forte`, 8 `coerente`, 2
`parcial`, 9 `incoerente`, 14 `ambigua`, 3 `placebo_ok` e 4 canais *soft*. Os
três placebos externos passam. As três séries fiscais e as quatro de
expectativas são mantidas no painel e tratadas como ambíguas, sem impor uma
restrição de sinal ex ante.
