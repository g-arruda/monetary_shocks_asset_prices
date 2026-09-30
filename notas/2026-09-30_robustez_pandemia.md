# Robustez à pandemia no Anexo C: sensibilidade a `q` com e sem a reescala de Lenza-Primiceri, respostas na janela pré-COVID e as oito séries das figuras do anexo

> **CURRENT — 2026-09-30.** Rodada de apêndice em `paper/paper_anpec.tex`, **sem
> reestimação da produção**. Branch `feature/robustez-pandemia`, não mergeada.
> - Produção de 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, `z_bs_purif`,
>   escala de volatilidade COVID de Lenza-Primiceri e conjuntos Anderson--Rubin de
>   80% e 90% com NW(0).
> - Fecha os dois itens do e-mail do orientador de 28-09
>   (`email/email_professor_28-09_21h15.md`): a figura de sensibilidade do fator
>   dinâmico com e sem o tratamento (Tema A) e a sugestão aberta de robustez
>   pré-COVID (Tema B).
> - Decisões do autor: duas figuras. A da reescala repete o exercício de `q` da
>   `fig:q_sensibilidade` em duas colunas, com a reescala à esquerda e sem ela à
>   direita, uma linha de painéis por série. A pré-COVID fica em oito painéis, como
>   as demais do Anexo C. No corpo, só dois ponteiros, sem número.
> - **A primeira versão da figura da reescala, do mesmo dia, comparava só as duas
>   linhas de `q = 5`** (produção contra MQO) e foi refeita por correção do autor: o
>   pedido do orientador é a sensibilidade a `q` nos dois estimadores. Os números
>   daquela comparação seguem na seção 2.3, tirados do mesmo CSV.
> - **No mesmo dia o autor trocou as oito séries de todas as figuras do Anexo C**
>   (seção 6): DI de 6 meses, DI de 2 anos, BRL/USD, CDS de 5 anos, Focus PIB, Focus
>   IPCA 12 meses, Focus Selic e DBGG. Saíram DI de 5 anos, IBC-Br, IPCA, Ibovespa e
>   DLSP. "As oito séries" nesta nota são as novas. As que saíram aparecem pelo nome.
> - Nada em `R/` mudou. Os scripts conferem a linha de produção contra
>   `output/irf/irf_coherence_h.csv` a 1e-10.

## 1. O desenho

`script/pandemic_sensitivity.R` roda nove células de `run_stage2_cell()`, todas com
`r = 5`, `p = 4`, `z_bs_purif`, +50 p.b. no `yield_6m`, até h36:

| células | janela | VAR fatorial | `q` | inferência | raiz máxima |
|---|---|---|---|---|---|
| com a reescala | 2012-03 a 2025-12 | MQP sob a escala LP | 5, 4, 3, 2 | conjuntos AR 80/90% em `q = 5`, ponto nas demais | 0,983676 |
| sem a reescala | 2012-03 a 2025-12 | MQO (`covid_volatility = NULL`) | 5, 4, 3, 2 | conjuntos AR 80/90% em `q = 5`, ponto nas demais | 0,970090 |
| pré-COVID | 2012-03 a 2019-12 | MQO, igual ao MQP porque `s_t = 1` | 5 | ponto | 0,993359 |

A raiz não depende de `q`, que só trunca o posto das inovações. A célula com a
reescala e `q = 5` é a produção. A célula sem a reescala e `q = 5` tem os próprios
conjuntos Anderson--Rubin, todos `interval` nas oito séries desenhadas (guarda do
script). A célula pré-COVID fica em ponto porque `hac_dim < T` barra a covariância AR
nessa janela em `p = 4` (135 ≥ 90). Nenhuma banda pré-COVID foi construída.

Saídas:

- `output/irf/lp_q_sensitivity.csv` (115 séries × 37 horizontes × 8 células, limites
  só nas duas linhas de `q = 5`) e `paper/fig_lp_sensibilidade.pdf`, oito linhas de
  painéis por duas colunas, com o mesmo eixo vertical nos dois painéis de cada série.
- `output/irf/precovid_sensitivity.csv` (115 × 37 × 2, limites só na produção) e
  `paper/fig_precovid_sensibilidade.pdf`.

As duas figuras seguem o desenho da Figura A3 de Alessi-Kerssenfischer, como as
demais do Anexo C: a linha de referência em preto com os conjuntos, as alternativas
tracejadas em ponto. O DI de 6 meses é a variável de normalização: vale 50 p.b. em
h0 em todas as células, e seu conjunto em h0 é o `singleton`.

Conferências cruzadas: as raízes sem a reescala e da pré-COVID são as do registro, e
o impacto de `yield_2y` sem a reescala em `q = 5`, 0,0081785146707394098, é o ponto
sem tratamento pinado em `script/validation/validate_covid_volatility.R`.

## 2. Sensibilidade a `q` com e sem a reescala (amostra completa)

### 2.1 Pontos fora do conjunto de 90% de `q = 5`

Cada coluna é medida contra o conjunto do próprio estimador.

| | `q = 4` | `q = 3` | `q = 2` |
|---|---|---|---|
| com a reescala, oito séries (296 pontos) | 4 | 26 | 26 |
| sem a reescala, oito séries (296 pontos) | 44 | 132 | 154 |
| com a reescala, painel (4255 pontos) | 151, em 22 séries | 420, em 65 séries | 408, em 64 séries |
| sem a reescala, painel (4255 pontos) | 589, em 68 séries | 1651, em 109 séries | 1805, em 103 séries |

No conjunto de 80%, nas oito séries, saem 34, 42 e 43 pontos com a reescala e 154,
189 e 208 sem ela. No painel, 528, 760 e 752 contra 1671, 2581 e 2658.

**Sem a reescala a truncagem de `q` tira do conjunto de quatro a onze vezes mais
pontos**, e isso contra um conjunto mais largo: o de 90% sem a reescala é mais largo
que o de produção em 99% dos pontos do painel com h ≥ 1, com razão mediana de 1,38
(1,33 nas oito séries, de 0,92 a 4,69).

**Com a reescala a saída se concentra no curto prazo, e sem ela atravessa o
horizonte.** Pontos fora de 90% no painel, por faixa (de 115, 690, 690, 1380 e 1380):

| | h0 | h1–h6 | h7–h12 | h13–h24 | h25–h36 |
|---|---|---|---|---|---|
| com a reescala, `q = 4` | 5 | 45 | 77 | 24 | 0 |
| com a reescala, `q = 3` | 39 | 230 | 117 | 34 | 0 |
| com a reescala, `q = 2` | 39 | 221 | 113 | 35 | 0 |
| sem a reescala, `q = 4` | 9 | 33 | 101 | 349 | 97 |
| sem a reescala, `q = 3` | 47 | 387 | 396 | 573 | 248 |
| sem a reescala, `q = 2` | 48 | 356 | 416 | 654 | 331 |

Por série, de 37 horizontes:

| série | com, `q = 4` | com, `q = 3` | com, `q = 2` | sem, `q = 4` | sem, `q = 3` | sem, `q = 2` |
|---|---|---|---|---|---|---|
| DI 6 meses | 0 | 0 | 0 | 7 | 10 | 14 |
| DI 2 anos | 0 | 3 | 3 | 12 | 18 | 24 |
| BRL/USD | 4 | 10 | 10 | 0 | 23 | 22 |
| CDS 5 anos | 0 | 5 | 5 | 4 | 26 | 26 |
| Focus PIB | 0 | 0 | 0 | 4 | 14 | 17 |
| Focus IPCA 12 meses | 0 | 0 | 0 | 13 | 12 | 17 |
| Focus Selic | 0 | 0 | 0 | 4 | 11 | 15 |
| DBGG | 0 | 8 | 8 | 0 | 18 | 19 |

Com a reescala, as saídas em `q ≤ 3` são os primeiros meses (DI de 2 anos h0–h2, CDS
h0–h4, DBGG h0–h7, câmbio h0–h9), e em `q = 4` só o câmbio, em h10–h13. Sem a
reescala, em `q ≤ 3` o câmbio fica fora até h22 e o CDS até h25, e as três
expectativas e os dois vértices da curva saem no médio prazo (DI de 6 meses em
h15–h28, Focus Selic em h17–h30, Focus PIB em h18–h31, Focus IPCA em h9–h25, todos em
`q = 2`).

Entre as séries que saíram da figura, o mesmo contraste: DI de 5 anos 0, 4 e 4 com a
reescala contra 14, 26 e 27 sem ela, IPCA 0, 0 e 0 contra 14, 14 e 17, Ibovespa 0, 1
e 1 contra 13, 15 e 20, DLSP 0, 3 e 2 contra 8, 18 e 19, e IBC-Br 0, 0 e 0 contra 0,
1 e 0.

### 2.2 Magnitudes

Impacto em h0, nas unidades da figura. O DI de 6 meses vale 50 p.b. em todas as
células.

| série | com, `q = 5` | com, `q = 4` | com, `q = 3` | com, `q = 2` | sem, `q = 5` | sem, `q = 4` | sem, `q = 3` | sem, `q = 2` |
|---|---|---|---|---|---|---|---|---|
| DI 2 anos (p.b.) | 72,07 | 83,25 | 105,61 | 105,62 | 81,79 | 108,18 | 168,67 | 163,30 |
| BRL/USD (R$/US$) | 0,141 | 0,216 | 0,308 | 0,314 | 0,194 | 0,364 | 0,636 | 0,523 |
| CDS 5 anos (p.b.) | 34,02 | 45,95 | 76,93 | 76,91 | 45,83 | 72,61 | 150,47 | 138,59 |
| Focus PIB (p.p.) | −0,189 | −0,172 | −0,216 | −0,226 | −0,182 | −0,164 | −0,198 | −0,066 |
| Focus IPCA 12 meses (p.p.) | 0,077 | 0,074 | −0,028 | −0,029 | 0,057 | 0,052 | −0,143 | −0,071 |
| Focus Selic (p.p.) | 0,471 | 0,448 | 0,590 | 0,606 | 0,474 | 0,463 | 0,657 | 0,417 |
| DBGG (p.p. do PIB) | −0,136 | 0,045 | 0,422 | 0,417 | 0,026 | 0,447 | 1,469 | 1,435 |

A razão entre o impacto de `q = 3` e o de `q = 5` é 1,47 no DI de 2 anos, 2,17 no
câmbio e 2,26 no CDS com a reescala, e 2,06, 3,27 e 3,28 sem ela. Nas expectativas de
PIB e de Selic o impacto muda pouco com `q` (1,15 e 1,25 com a reescala). Sem a
reescala o pico do câmbio chega a R$ 0,976 em h2 com `q = 3`, contra R$ 0,250 em
`q = 5`, e o da DBGG a 2,27 p.p. em h4, contra uma resposta que fica entre −0,38 e
0,76 em `q = 5`. Entre as séries que saíram da figura, o Ibovespa de `q = 3` é 5,24
vezes o de `q = 5` com a reescala (−12,93% contra −2,47%) e 6,08 sem ela (−27,14%
contra −4,47%), e o IBC-Br 2,35 e 3,26.

A reversão é o que mais separa as colunas. Com a reescala o DI de 6 meses cruza zero
em h14 com `q = 5`, em h12 com `q ≤ 3` e em h18 com `q = 4`, e o DI de 2 anos em h13,
h13 e h18. Sem a reescala o DI de 2 anos cruza em h16 com `q = 5` e só em h28–h29
com `q < 5`, de modo que em h12 a resposta é de 121 a 158 p.b. nas três truncagens,
contra 29 p.b. em `q = 5`. O DI de 6 meses volta a subir e chega a 96, 109 e 129 p.b.
em h16–h18 com `q = 4`, 3 e 2, contra um pico de 70 p.b. em h3 com `q = 5`. As
expectativas acompanham: sem a reescala a Focus Selic de `q ≤ 3` fica negativa de h2
em diante, com vale de −0,62 a −0,89 em h5, e depois sobe a 0,90 a 1,05 em h20,
contra um pico de 0,56 em h3 em `q = 5`. A Focus PIB de `q ≤ 3` sobe a 0,36 a 0,48 em
h5 e cai a −0,38 a −0,44 em h20, contra um vale de −0,23 em h3 em `q = 5`.

⚠ **Com a reescala as respostas não são insensíveis a `q`.** Em `q ≤ 3` o câmbio sai
do conjunto de 90% de h0 a h9 e a DBGG de h0 a h7, e os impactos de câmbio e CDS são
mais que o dobro dos de `q = 5`. **Dois sinais de impacto mudam com `q`**: a DBGG,
−0,14 p.p. em `q = 5`, é +0,04 em `q = 4` e +0,42 em `q ≤ 3`, e a Focus IPCA, +0,077
em `q ≥ 4`, é −0,03 em `q ≤ 3`, dentro do conjunto. Em `q = 4` o câmbio sai em
h10–h13, quatro pontos, enquanto sem a reescala o câmbio de `q = 4` não sai em nenhum
horizonte, porque lá o conjunto é mais largo. A figura sustenta que a reescala reduz
a sensibilidade a `q`, não que a elimina, e a defesa de `q = r` na §3.1 continua
sendo Stock-Watson e Alessi-Kerssenfischer (`2026-09-24_q_sensibilidade_anexo`).

O sinal do impacto coincide com o de `q = 5` em 107, 107 e 106 das 114 séries do
painel com a reescala (`q = 4`, 3, 2) e em 99, 99 e 93 sem ela.

### 2.3 As duas linhas de `q = 5`

**Nenhum ponto de `q = 5` sem a reescala sai do conjunto de 90% da produção**: 0 de
4255 nas 115 séries. No de 80% saem 28 pontos, em 16 séries, nenhuma delas entre as
oito da figura nem entre as cinco que saíram dela. O sinal do impacto coincide em 113
das 114 séries.

⚠ **Os impactos sem a reescala são maiores nos preços de ativos e na atividade.**
Nas oito séries: DI de 2 anos 1,13 vez, câmbio 1,37, CDS 1,35, com Focus PIB (0,97) e
Focus Selic (1,01) quase iguais e Focus IPCA menor (0,057 contra 0,077 p.p.). Nas que
saíram da figura: Ibovespa 1,81, IBC-Br 1,47, IPCA 1,26, DI de 5 anos e DLSP 1,22.
⚠ **O impacto da DBGG troca de sinal**: +0,03 p.p. sem a reescala contra −0,14 na
produção. A reversão vem de um a quatro meses depois: o DI de 6 meses cruza zero em
h17 contra h14, o de 2 anos em h16 contra h13, o CDS em h16 contra h14, a Focus Selic
em h19 contra h15, e a Focus PIB fica positiva em h20 contra h16. Sem a reescala o
IPCA fica positivo de h4 a h7 (máximo de 0,03 p.p.), enquanto na produção ele nunca é
positivo.

A reescala move os coeficientes do VAR (raiz 0,970 → 0,984) e a covariância das
inovações. Em `q = 5` o movimento cabe dentro do conjunto de 90%, e é na truncagem de
`q` que ele aparece. A frase da §3.1 afirma o deslocamento, não o seu tamanho, e a
figura não a contradiz.

## 3. Janela pré-COVID

**Curva e risco soberano ficam dentro do conjunto de 90% da produção em todos os
horizontes**: DI de 6 meses, 1, 2, 5 e 10 anos, CDS de 5 anos, EMBI+ e BRL/EUR, 0 de
37 cada. O DI de 3 meses sai em h1 e h2. Os impactos quase coincidem: DI de 2 anos
70,69 contra 72,07 p.b., DI de 5 anos 73,22 contra 77,31, CDS 32,91 contra 34,02.

Nas oito séries da figura, 35 dos 296 pontos pré-COVID saem do conjunto de 90% da
produção e 76 do de 80%:

| série | fora de 90% | horizontes | produção h0 | pré-COVID h0 | produção h36 | pré-COVID h36 |
|---|---|---|---|---|---|---|
| DI 6 meses (p.b.) | 0 | | 50,00 | 50,00 | −106,77 | −13,55 |
| DI 2 anos (p.b.) | 0 | | 72,07 | 70,69 | −131,23 | −19,26 |
| BRL/USD (R$/US$) | 1 | h0 | 0,141 | 0,056 | −0,115 | −0,037 |
| CDS 5 anos (p.b.) | 0 | | 34,02 | 32,91 | −25,90 | −12,05 |
| Focus PIB (p.p.) | 5 | h0–h4 | −0,189 | −0,554 | 0,303 | 0,122 |
| Focus IPCA 12 meses (p.p.) | 6 | h31–h36 | 0,077 | 0,039 | −0,381 | 0,027 |
| Focus Selic (p.p.) | 1 | h0 | 0,471 | 0,675 | −0,776 | −0,118 |
| DBGG (p.p. do PIB) | 22 | h0–h13 e h29–h36 | −0,136 | 0,343 | 0,654 | −0,324 |

⚠ **O câmbio BRL/USD sai do conjunto no impacto.** A depreciação pré-COVID em h0 é
R$ 0,056/US$, 40% da de produção (R$ 0,141), abaixo do limite inferior de 90%
(R$ 0,069). De h1 em diante fica dentro, com pico de R$ 0,134 em h2 contra R$ 0,178
em h1. O sinal é o mesmo.

⚠ **A DBGG pré-COVID tem o sinal oposto ao da produção nas duas pontas.** Sobe 0,34
p.p. no impacto, acima do limite superior de 90% (0,27), fica positiva de h0 a h26 com
pico de 0,42 em h12, e termina em −0,32 em h36. A da produção cai 0,14 no impacto, é
negativa até h16 e termina em +0,65. Sai do conjunto em 22 dos 37 horizontes.

⚠ **Nas expectativas, o impacto pré-COVID é mais forte e a reversão mais cedo.** A
Focus PIB cai 0,55 p.p. no impacto, o triplo da produção e abaixo do limite inferior
de 90% (−0,29), e fica positiva de h10 em diante, contra h16. A Focus Selic sobe
0,68, acima do limite superior (0,67), e fica negativa de h10 em diante, contra h15.
A Focus IPCA sobe menos e volta a ser positiva em h34–h36, onde a da produção está em
−0,38.

⚠ **A reversão de médio prazo é mais cedo e mais rasa na pré-COVID.** Curva, câmbio e
CDS cruzam zero em h9, contra h13–h14, e o vale da curva é de −35 p.b. no DI de 6
meses em h24 e de −56 a −59 p.b. nos de 2 e 5 anos em h23, contra −107 a −131 p.b. em
h36 na produção. Em h36 a curva pré-COVID está em −14 a −22 p.b. Esses pontos ficam
dentro do conjunto de 90%, que é largo nesses horizontes.

⚠ **Fora de curva e risco a janela importa.** No painel inteiro, 1407 dos 4255 pontos
pré-COVID (33%) saem do conjunto de 90% da produção, em 103 das 115 séries, e 2103
saem do de 80%. A saída cresce com o horizonte: 36 de 115 em h0, 172 de 690 em
h1–h6, 177 de 690 em h7–h12, 402 de 1380 em h13–h24 e 620 de 1380 em h25–h36. O
sinal do impacto coincide em 96 das 114 séries.

⚠ **Quatro séries da leitura da §4 que a figura não desenha mais** (estavam na
primeira versão e saíram com a troca da seção 6):

| série | pontos fora de 90% | horizontes | produção h0 | pré-COVID h0 | produção h36 | pré-COVID h36 |
|---|---|---|---|---|---|---|
| IBC-Br (pontos) | 12 | h25–h36 | −0,766 | −0,283 | −0,347 | 0,323 |
| IPCA (p.p. ao mês) | 17 | h20–h36 | −0,077 | −0,221 | −0,322 | 0,114 |
| Ibovespa (%) | 21 | h1–h12 e h28–h36 | −2,47 | −6,52 | −3,14 | 0,70 |
| DLSP (p.p. do PIB) | 13 | h0, h6–h14 e h34–h36 | −0,736 | −0,391 | 0,728 | −0,066 |

Na pré-COVID o IBC-Br fica positivo de h25 em diante e o IPCA de h21 em diante. O
Ibovespa cai 6,5% no impacto e segue negativo até h18, onde a produção tem a fase
positiva (h2–h19), e fica positivo de h19 a h36. A DLSP sobe mais cedo (pico de
0,73 p.p. em h16) e volta a zero em h36.

## 4. O que pode e o que não pode ser dito

- A figura da reescala compara pontos de `q < 5` com o conjunto de `q = 5` do mesmo
  estimador. Contar pontos fora não é teste, e os dois conjuntos têm larguras
  diferentes. O que ela mostra é que a truncagem de `q` desloca mais as respostas
  quando o VAR é estimado por MQO.
- Com a reescala as respostas ainda se movem com `q`, sobretudo no impacto. O texto
  não pode apresentar a figura como insensibilidade a `q`.
- Na janela pré-COVID a comparação é de pontos contra o conjunto da amostra completa.
  **Ficar dentro não é teste de igualdade** entre as janelas, e sair não é rejeição:
  o ponto pré-COVID tem incerteza própria, que não foi medida porque a célula é
  barrada.
- A direção e a magnitude de impacto da curva e do risco soberano se repetem na
  pré-COVID. A do câmbio se repete em sinal, com 40% da magnitude no impacto.
- A leitura de médio prazo da §4 (atividade negativa por 36 meses, IPCA nunca
  positivo, fase positiva das ações, dívida crescente) **não se repete** na
  pré-COVID, e a DBGG tem o sinal oposto. O corpo do artigo não afirma que ela se
  repete: o ponteiro da §3.4 só aponta a figura.
- **A figura pré-COVID não desenha mais atividade, preços nem ações.** Quem a lê vê a
  divergência na DBGG e nas expectativas, não no IBC-Br, no IPCA e no Ibovespa, que
  saem do conjunto em 12 a 21 dos 37 horizontes. Esses números ficam só nesta nota.
- A janela pré-COVID tem 90 inovações e ξ_mp 6,84, abaixo de 10 como a cheia.

## 5. O que mudou no paper

- **Anexo C**: `fig:lp_sensibilidade` ("Sensibilidade à reescala de volatilidade"),
  em página inteira, e `fig:precovid_sensibilidade` ("Respostas na janela
  pré-COVID"), depois de `fig:instrumento_camadas`. São as Figuras 13 e 14, e a de
  placebos passa a 15.
- **§3.1**: rodapé na frase de MQO, apontando `fig:lp_sensibilidade` como a
  sensibilidade das respostas a `q` com e sem a reescala.
- **§3.4**: uma frase no fim do parágrafo da `tab:first_stage`, apontando
  `fig:precovid_sensibilidade`.
- As cinco legendas do Anexo C perderam a menção ao IBC-Br, que não é mais desenhado.
- Nenhum número novo no corpo. O PDF compila em 32 páginas, sem referência indefinida.

Com `fig:lp_sensibilidade` o modelo sem tratamento entra no paper pela primeira vez,
como a coluna da direita de uma figura de anexo, com os conjuntos Anderson--Rubin de
`q = 5`. A decisão anterior de mantê-lo fora (`2026-09-24_q_sensibilidade_anexo`)
fica revista só nesse ponto. A coluna da esquerda repete a `fig:q_sensibilidade`.

## 6. As oito séries das figuras do Anexo C

Por decisão do autor, as cinco figuras do Anexo C passam a desenhar as mesmas oito
séries, nos rótulos e escalas de `script/fig_section5.R`:

| antes | depois |
|---|---|
| DI 2 anos, DI 5 anos, BRL/USD, CDS 5 anos, IBC-Br, IPCA, Ibovespa, DLSP | DI 6 meses, DI 2 anos, BRL/USD, CDS 5 anos, Focus PIB (ano seguinte), Focus IPCA 12 meses, Focus Selic (ano seguinte), DBGG |

A troca é do bloco `PAPER_PANELS` de `script/q_sensitivity.R`,
`script/p_sensitivity.R`, `script/instrument_layers_irf.R` e
`script/pandemic_sensitivity.R`. Nada foi reestimado: `lp_q_sensitivity.csv`,
`precovid_sensitivity.csv` e `instrument_layers_irf.csv` saem byte-idênticos, e
`output/factors/p_sensitivity.csv`, que só guarda as séries desenhadas, passa a
trazer as novas. A `fig:placebos`, no Anexo D, desenha as três séries externas e não
mudou.

O que cada figura mostra nas oito séries novas:

- **`fig:q_sensibilidade`**: é a coluna da esquerda da seção 2. De `q = 4`, 3 e 2
  saem do conjunto de 90% de `q = 5` 4, 26 e 26 dos 296 pontos. ⚠ O impacto da DBGG
  troca de sinal em `q ≤ 4` e o da Focus IPCA em `q ≤ 3`.
- **`fig:p_sensibilidade`**: nenhum ponto de `p = 2`, 3, 5 ou 6 sai do conjunto de
  `p = 4`, nem do de 90% nem do de 80% (0 de 296 em cada `p`). Raízes de 0,976 a
  0,990, como antes.
- **`fig:instrumento_camadas`**: nenhum ponto da surpresa bruta sai do conjunto da
  produção, nem do de 90% nem do de 80% (0 de 296). Com a surpresa bruta os impactos
  do DI de 2 anos, do câmbio e do CDS são 0,87, 0,68 e 0,70 dos de produção, e o da
  DBGG é 2,13 vezes (−0,29 contra −0,14 p.p.).
- **`fig:lp_sensibilidade`** e **`fig:precovid_sensibilidade`**: seções 2 e 3.

As notas das rodadas anteriores (`2026-09-24_q_sensibilidade_anexo`,
`2026-09-25_p_sensibilidade_anexo`, `2026-09-25_anexo_d_instrumento`,
`2026-09-26_migracao_paper_bs_purif`) descrevem as figuras com as oito séries antigas.
