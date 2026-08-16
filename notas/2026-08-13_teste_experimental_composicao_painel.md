# Teste experimental de composição do painel e dependência da curva

> **SUPERSEDED como decisão em 2026-08-13 pela
> [`decisão conjunta de painel e dimensões`](2026-08-13_decisao_conjunta_painel_dimensoes.md).**
> As estimações abaixo permanecem válidas como proveniência da rodada isolada,
> gerada por
> `script/panel_composition_experimental.R` em `output/panel_experimental/`.
> Mantém o painel canônico de 106 séries, o instrumento `z_jk_bs_purif`, a
> identificação e os artefatos canônicos intactos. A validação independente é
> `Rscript script/validate_panel_composition_experimental.R`.

## Desenho e fontes

A rodada monta os painéis apenas em memória e conserva 153 meses completos,
de 2013-01 a 2025-09, em todas as células. A célula é fixa em
`(r,q,p)=(7,6,6)`, normaliza um choque de +50 pb em `yield_6m`, estima as IRFs
até h=48 e usa 800 réplicas wild-bootstrap com seed 123 para bandas de 68% e
90%. Foram estimadas as nove variantes pré-especificadas nas amostras cheia e
pré-COVID: baseline, retirada de `juros_cdi` e `asset_mlcx`, os seis blocos
isolados e a união exata dos blocos.

O bloco fiscal contém DBGG, DLSP e resultado primário, todos em nível, sendo o
resultado primário explicitamente mantido sem log. O externo inclui transações
correntes/PIB em nível e exportações, importações e reservas em log-nível. As
quatro expectativas Focus usam a última publicação dentro do mês. O bloco dos
EUA usa DGS2, DGS10, FEDFUNDS e DTWEXBGS em nível e o S&P 500 do Yahoo como
retorno log mensal. Crédito acrescenta inadimplência e taxa média de juros em
nível, e imóveis acrescenta IVG-R em nível. O ajuste sazonal repete a cascata
X-13 de `script/clean.R` e seu resultado por série está em
`output/panel_experimental/candidate_treatments.csv`.

As identidades e candidatos excluídos permaneceram fora dos painéis:
`T10Y2Y`, o SP500 do FRED, 22711/22712 e os saldos de transações correntes e
balança comercial. O validador confirmou a cobertura, unicidade e finitude de
todas as entradas, reproduziu o baseline MOSW de 7,65/7,95 na amostra cheia e
11,53/6,26 na pré-COVID, e passou o smoke test canônico nos cinco impactos.

## Resultados de força

| variante | xi_mp / F_rob,mp cheia | xi_mp / F_rob,mp pré-COVID |
|---|---:|---:|
| baseline | 7,65 / 7,95 | 11,53 / 6,26 |
| sem quase-duplicatas | 7,94 / 8,02 | 9,69 / 5,81 |
| fiscal | 6,39 / 6,40 | 13,73 / 7,50 |
| setor externo | 7,38 / 7,55 | 11,75 / 6,63 |
| expectativas | 8,36 / 9,30 | 16,34 / 9,10 |
| EUA | 5,96 / 5,92 | 15,35 / 7,42 |
| crédito | 7,62 / 8,15 | 7,21 / 3,41 |
| imóveis | 7,37 / 7,60 | 12,32 / 6,87 |
| conjunta | 4,67 / 4,66 | 16,14 / 9,58 |

Na amostra cheia, todas as variantes permanecem entre 3,84 e 10, de modo que
o conjunto AR seria limitado, mas as bandas convencionais continuam fora da
zona aproximada de validade. A união dos seis blocos reduz `xi_mp` de 7,65
para 4,67, enquanto a amostra pré-COVID a eleva para 16,14. Essa assimetria
mostra que adicionar blocos altera a ponderação e a rotação dos fatores, sem
produzir uma hierarquia estável de candidatos.

No impacto da amostra cheia, os dois vértices longos da curva permanecem
positivos com banda de 90% que exclui zero em todas as nove variantes, e o
câmbio permanece depreciando com a mesma propriedade. O Ibovespa tem ponto
negativo em todas elas, mas sua banda de 90% inclui zero. Na pré-COVID, as
bandas de impacto são substancialmente mais largas: incluem zero para Ibovespa
e câmbio em todas as variantes, para `yield_5y` em todas, e para `yield_2y` em
sete das nove. Portanto, a rodada preserva direções pontuais conhecidas, mas
não fornece estabilidade inferencial conjunta que autorize promover um bloco.

As tabelas `block_composition.csv` e `block_squared_loadings.csv` registram,
por variante e amostra, dimensão efetiva, sobrepeso, comunalidade média, cargas
quadráticas por fator e participação de cada bloco no choque. As 18 células
completas, as 4.410 observações de IRF longa e as 16 comparações em PDF estão
em `output/panel_experimental/`.

## Limites e regra de decisão

A retirada de `juros_cdi` e `asset_mlcx` é diagnóstico de ponderação, não uma
regra de exclusão. Séries fiscais são vintage corrente do SGS, e não uma
reconstrução da informação fiscal disponível em tempo real; por isso, a rodada
não testa estritamente informação fiscal contemporânea. Nenhuma candidata será
promovida pelo maior `xi_mp`: a evidência deve ser lida pela estabilidade
conjunta de força, direção das cinco IRFs e bandas. Nesta rodada essa condição
não é satisfeita, de modo que o painel de produção permanece em 106 séries.

## Ponteiros

- Resultados e objetos completos: `output/panel_experimental/`.
- Infraestrutura e proveniência das candidatas:
  `output/download/panel_candidate_download_report.md`.
- Diagnóstico do painel canônico:
  `notas/2026-08-13_composicao_do_painel.md`.
