# Resultados das IRFs na rodada canônica

> **CURRENT em 2026-08-25.** Esta leitura substitui a produção DFM com `p=6`.
> O texto canônico do artigo está sincronizado em `paper/paper_anpec.tex`. Os números abaixo
> vêm de `irf_coherence_h.csv`, `irf_coherence_summary.csv` e dos diagnósticos
> de força regenerados na mesma rodada.

## Especificação

O DFM usa o painel `drop_setor_externo__eua__credito__imoveis`, com 111 séries,
153 observações mensais entre 2013-01 e 2025-09 e 149 inovações fatoriais após
o VAR(4). Saem `juros_cdi`, `asset_mlcx` e os blocos candidatos de setor
externo, EUA, crédito e imóveis; entram as três séries fiscais e as quatro de
expectativas. O painel-base de 106 séries fica preservado em arquivo separado
apenas para reproduzir as grades fatoriais históricas.

A produção usa `r=5`, selecionado pelo Bai--Ng IC2 padronizado para o desenho
BLL, e `q=5` como default operacional provisório; a fundamentação metodológica
de `q` permanece aberta. A ordem `p=4` minimiza o AIC (8,073207) em amostra
comum de 141 observações, com constante e tendência linear; o BIC seleciona
`p=2`. A tendência pertence somente à seleção: o VAR fatorial estimado mantém
intercepto apenas. Os demais parâmetros são instrumento
`z_jk_bs_purif`, normalização de +50 pontos-base em `yield_6m`, horizontes 0--48
e bandas de 68%/90% com 800 réplicas do *wild bootstrap* e semente 123.

Na amostra completa, `xi_mp=5,24016`, `F_rob,mp=10,06092` e a maior raiz da
companion é 0,968126. Na janela pré-COVID, `xi_mp=7,47832`,
`F_rob,mp=11,87495` e a maior raiz é 0,992483. As duas janelas são estáveis,
mas a cautela de instrumento fraco permanece porque `xi_mp<10`. O bootstrap canônico
teve zero falhas, bandas finitas e ordenadas e normalização exata em 0,005.

## Impactos de manchete

| variável | ponto h0 | banda de 68% | banda de 90% | unidade |
|---|---:|---:|---:|---|
| DI 6 meses | 50,0 | [50,0; 50,0] | [50,0; 50,0] | pontos-base, normalização |
| Selic | 24,1 | [20,1; 28,5] | [17,6; 34,4] | pontos-base |
| DI 2 anos | 72,8 | [63,6; 80,7] | [57,9; 87,0] | pontos-base |
| DI 5 anos | 74,8 | [60,8; 88,0] | [53,5; 99,1] | pontos-base |
| Ibovespa | -0,97 | [-3,41; 0,31] | [-5,03; 1,56] | pontos percentuais do retorno mensal |
| BRL/USD | 3,74 | [2,76; 4,57] | [2,31; 5,27] | percentual da média amostral |
| EMBI+ | 24,5 | [18,9; 32,6] | [14,5; 39,2] | pontos-base |
| CDS 5 anos | 30,7 | [24,1; 38,7] | [19,2; 46,2] | pontos-base |

O resultado de curto prazo continua sendo o movimento conjunto da curva, do
câmbio e do risco soberano. BRL/USD exclui zero a 90% de h=0 a h=4; EMBI+ de
h=0 a h=8; e CDS de h=0 a h=10. A resposta é compatível com transmissão via
prêmio de risco, mas o desenho não identifica diretamente a origem fiscal
desse prêmio.

## Curva e reversão

No impacto, os vértices de 3 meses, 1 ano, 2 anos, 5 anos e 10 anos sobem 38,9,
62,9, 72,8, 74,8 e 67,6 pontos-base. Todos excluem zero a 90%. A maior raiz da
companion é 0,968126 e é real. O antigo exercício de apagar o par complexo
dominante não se aplica a esta ordem; seus CSVs vivos ficam vazios para impedir
que a decomposição de `p=6` seja confundida com produção corrente. A reversão é
descrição da dinâmica estimada, não confirmação independente do canal econômico.

## Demais blocos

Na atividade, o IBC-Br cai 0,44%, a indústria de transformação 1,38%, os bens
duráveis 4,89%, os bens de capital 1,88%, o varejo 0,77% e as horas trabalhadas
na indústria 0,77% no impacto. As vendas de serviços caem 0,34% e a utilização
da capacidade 0,13 ponto percentual, mas suas bandas de 90% contêm zero. No
crédito, o saldo total sobe 0,56%, e as altas variam de 0,30% para pessoas
físicas a 1,38% no transporte. Várias respostas revertem depois, o que gera
cinco classificações incoerentes no bloco e restringe a interpretação de médio
prazo.

O índice de preços ao produtor sobe 0,426 ponto percentual no impacto e exclui
zero a 90% de h=0 a h=3. O IPCA cheio cai 0,055 ponto percentual no impacto e
sobe 0,121 em h=6, mas não exclui zero a 90% em nenhum horizonte. No bloco
acionário, seis dos sete índices caem no impacto e o IMAT sobe. O Ibovespa cai
0,97%, e apenas o IFIX exclui zero a 90% no impacto. As bandas de 68% não são
interpretadas como significância.

## Robustez e alcance da inferência

Os cinco testes mensais de previsibilidade não rejeitam a imprevisibilidade do
instrumento, com valores-p de *wild bootstrap* entre 0,199 e 0,749. Os testes de
invertibilidade também não rejeitam a condição necessária: as regressões sobre
inovações futuras produzem 0,771 e 0,550, e o menor valor-p entre as cinco
equações do teste de Granger com quatro defasagens é 0,268. Essas não rejeições
não estabelecem invertibilidade, que continua como hipótese mantida.

O DFM de produção permanece em `p=4` e usa somente as bandas do *wild
bootstrap*. O benchmark separado usa cinco observáveis em nível, constante e
tendência linear, `p=2` pelo AIC, respostas `C_h B_1` e conjuntos
Anderson--Rubin/MOSW de 68% e 90% com NW(0). A cobertura desses conjuntos
pertence ao VAR observável e não se transfere ao DFM nem testa a validade da
proxy.

No exercício soberano, ortogonalizar apenas os valores leva `xi_mp` de 5,24 a
5,80 e a 6,49 quando o CDS entra. Rederivar a máscara sobre os mesmos resíduos
reduz a estatística a 3,44. No exercício FOMC, retirar o bloco global dos
valores leva `xi_mp` de 5,24 a 5,33, enquanto rederivar a máscara reduz a
estatística a 3,67. Os sinais de impacto sobrevivem aos dois exercícios, mas a
perda de relevância sob reclassificação mantém o veredito de sinal fraco de
contaminação FOMC e impede tratar os testes diários como absolvição do
instrumento.

## Coerência

A classificação corrente tem 14 variáveis `coerente_forte`, 6 `coerente`, 6
`parcial`, 11 `incoerente`, 14 `ambigua`, 3 `placebo_ok` e 4 canais *soft*. Os
três placebos externos passam. As três séries fiscais e as quatro de
expectativas são mantidas no painel e tratadas como ambíguas, sem impor uma
restrição de sinal ex ante.
