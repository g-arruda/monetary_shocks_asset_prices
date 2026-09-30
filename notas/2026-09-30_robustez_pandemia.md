# Robustez à pandemia no Anexo C: sensibilidade a `q` com e sem a reescala de Lenza-Primiceri e respostas na janela pré-COVID

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
>   direita, uma linha de painéis por série. A pré-COVID fica nos oito painéis das
>   demais figuras do Anexo C. No corpo, só dois ponteiros, sem número.
> - **A primeira versão da figura da reescala, do mesmo dia, comparava só as duas
>   linhas de `q = 5`** (produção contra MQO) e foi refeita por correção do autor: o
>   pedido do orientador é a sensibilidade a `q` nos dois estimadores. Os números
>   daquela comparação seguem na seção 2.3, tirados do mesmo CSV.
> - Nada em `R/` mudou. O script confere a linha de produção contra
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
tracejadas em ponto.

Conferências cruzadas: as raízes sem a reescala e da pré-COVID são as do registro, e
o impacto de `yield_2y` sem a reescala em `q = 5`, 0,0081785146707394098, é o ponto
sem tratamento pinado em `script/validation/validate_covid_volatility.R`.

## 2. Sensibilidade a `q` com e sem a reescala (amostra completa)

### 2.1 Pontos fora do conjunto de 90% de `q = 5`

Cada coluna é medida contra o conjunto do próprio estimador.

| | `q = 4` | `q = 3` | `q = 2` |
|---|---|---|---|
| com a reescala, oito séries (296 pontos) | 4 | 26 | 25 |
| sem a reescala, oito séries (296 pontos) | 65 | 141 | 155 |
| com a reescala, painel (4255 pontos) | 151, em 22 séries | 420, em 65 séries | 408, em 64 séries |
| sem a reescala, painel (4255 pontos) | 589, em 68 séries | 1651, em 109 séries | 1805, em 103 séries |

No conjunto de 80%, nas oito séries, saem 28, 42 e 42 pontos com a reescala e 142,
176 e 199 sem ela. No painel, 528, 760 e 752 contra 1671, 2581 e 2658.

**Sem a reescala a truncagem de `q` tira do conjunto de quatro a dezesseis vezes mais
pontos**, e isso contra um conjunto mais largo: o de 90% sem a reescala é mais largo
que o de produção em 99% dos pontos do painel com h ≥ 1, com razão mediana de 1,38
(1,20 nas oito séries, de 0,92 a 3,57).

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
| DI 2 anos | 0 | 3 | 3 | 12 | 18 | 24 |
| DI 5 anos | 0 | 4 | 4 | 14 | 26 | 27 |
| BRL/USD | 4 | 10 | 10 | 0 | 23 | 22 |
| CDS 5 anos | 0 | 5 | 5 | 4 | 26 | 26 |
| IBC-Br | 0 | 0 | 0 | 0 | 1 | 0 |
| IPCA | 0 | 0 | 0 | 14 | 14 | 17 |
| Ibovespa | 0 | 1 | 1 | 13 | 15 | 20 |
| DLSP | 0 | 3 | 2 | 8 | 18 | 19 |

Com a reescala, as saídas em `q ≤ 3` são os primeiros meses (curva h0–h3, CDS h0–h4,
câmbio h0–h9, DLSP h0–h2, Ibovespa h0). Sem a reescala, em `q ≤ 3` a curva fica fora até h25–h27,
o CDS até h25 e o câmbio até h22.

### 2.2 Magnitudes

Impacto em h0, nas unidades da figura:

| série | com, `q = 5` | com, `q = 4` | com, `q = 3` | com, `q = 2` | sem, `q = 5` | sem, `q = 4` | sem, `q = 3` | sem, `q = 2` |
|---|---|---|---|---|---|---|---|---|
| DI 2 anos (p.b.) | 72,07 | 83,25 | 105,61 | 105,62 | 81,79 | 108,18 | 168,67 | 163,30 |
| DI 5 anos (p.b.) | 77,31 | 95,41 | 139,25 | 139,06 | 94,57 | 136,49 | 249,36 | 237,79 |
| BRL/USD (R$/US$) | 0,141 | 0,216 | 0,308 | 0,314 | 0,194 | 0,364 | 0,636 | 0,523 |
| CDS 5 anos (p.b.) | 34,02 | 45,95 | 76,93 | 76,91 | 45,83 | 72,61 | 150,47 | 138,59 |
| IBC-Br (pontos) | −0,766 | −1,158 | −1,799 | −1,765 | −1,123 | −1,775 | −3,663 | −3,496 |
| IPCA (p.p. ao mês) | −0,077 | −0,097 | −0,216 | −0,244 | −0,098 | −0,157 | −0,336 | 0,089 |
| Ibovespa (%) | −2,47 | −3,00 | −12,93 | −12,78 | −4,47 | −6,71 | −27,14 | −26,23 |
| DLSP (p.p. do PIB) | −0,736 | −0,869 | −1,418 | −1,422 | −0,901 | −1,215 | −2,462 | −2,190 |

A razão entre o impacto de `q = 3` e o de `q = 5` vai de 1,47 a 5,24 com a reescala
(Ibovespa 5,24, IPCA 2,79, IBC-Br 2,35, CDS 2,26, câmbio 2,17) e de 2,06 a 6,08 sem
ela (Ibovespa 6,08, IPCA 3,44, CDS 3,28, câmbio 3,27, IBC-Br 3,26). Sem a reescala o
pico do câmbio chega a R$ 0,976 em h2 com `q = 3`, contra R$ 0,250 em `q = 5`, e o
vale do IBC-Br a −5,55 pontos em h1, contra −1,12.

A reversão da curva é o que mais separa as colunas. Com a reescala o DI de 2 anos
cruza zero em h13 com `q = 5`, 3 e 2 e em h18 com `q = 4`. Sem a reescala cruza em
h16 com `q = 5` e só em h28–h29 com `q < 5`, de modo que em h12 a resposta é de 121 a
158 p.b. nas três truncagens, contra 29 p.b. em `q = 5`. O IPCA sem a reescala fica
positivo por 15 a 19 horizontes em `q < 5`, com máximo de 0,30 a 0,53 p.p., contra
quatro horizontes e 0,03 p.p. em `q = 5`. Com a reescala ele é positivo em h3–h10 com
`q = 4` (máximo 0,07) e em h4–h5 com `q ≤ 3` (0,03), e nunca em `q = 5`.

⚠ **Com a reescala as respostas não são insensíveis a `q`.** Em `q ≤ 3` os impactos
das oito séries são de 1,5 a 5,2 vezes os de `q = 5`, e o câmbio sai do conjunto de
90% de h0 a h9. Em `q = 4` o câmbio sai em h10–h13, quatro pontos, enquanto sem a
reescala o câmbio de `q = 4` não sai em nenhum horizonte, porque lá o conjunto é mais
largo. O IBC-Br quase não sai em nenhuma das colunas (0 e 1 ponto), embora sem a
reescala o vale de `q ≤ 3` seja de 4,6 a 4,9 vezes o de `q = 5`: o conjunto sem a
reescala vai de −5,26 a 0,32 em h1. A figura sustenta que a reescala reduz a
sensibilidade a `q`, não que a elimina, e a defesa de `q = r` na §3.1 continua sendo
Stock-Watson e Alessi-Kerssenfischer (`2026-09-24_q_sensibilidade_anexo`).

O sinal do impacto coincide com o de `q = 5` em 107, 107 e 106 das 114 séries com a
reescala (`q = 4`, 3, 2) e em 99, 99 e 93 sem ela.

### 2.3 As duas linhas de `q = 5`

**Nenhum ponto de `q = 5` sem a reescala sai do conjunto de 90% da produção**: 0 de
4255 nas 115 séries. No de 80% saem 28 pontos, em 16 séries, nenhuma delas entre as
oito da figura. O sinal do impacto coincide em 113 das 114 séries.

⚠ **Os impactos sem a reescala são maiores nas oito séries**, de 13% a 81% (colunas
de `q = 5` da tabela acima: Ibovespa 1,81, IBC-Br 1,47, câmbio 1,37, CDS 1,35, IPCA
1,26, DI de 5 anos e DLSP 1,22, DI de 2 anos 1,13). A reversão vem dois a três meses
depois: a curva cruza zero em h15–h16, contra h13 na produção, e o CDS em h16, contra
h14. Sem a reescala o IPCA fica positivo de h4 a h7 (máximo de 0,03 p.p.), enquanto
na produção ele nunca é positivo.

A reescala move os coeficientes do VAR (raiz 0,970 → 0,984) e a covariância das
inovações. Em `q = 5` o movimento cabe dentro do conjunto de 90%, e é na truncagem de
`q` que ele aparece. A frase da §3.1 afirma o deslocamento, não o seu tamanho, e a
figura não a contradiz.

## 3. Janela pré-COVID

**Curva e risco soberano ficam dentro do conjunto de 90% da produção em todos os
horizontes**: DI de 1, 2, 5 e 10 anos, CDS de 5 anos, EMBI+ e BRL/EUR, 0 de 37 cada.
O DI de 3 meses sai em h1 e h2. Os impactos quase coincidem: DI de 2 anos 70,69
contra 72,07 p.b., DI de 5 anos 73,22 contra 77,31, CDS 32,91 contra 34,02.

⚠ **O câmbio BRL/USD sai do conjunto no impacto.** A depreciação pré-COVID em h0 é
R$ 0,056/US$, 40% da de produção (R$ 0,141), abaixo do limite inferior de 90%
(R$ 0,069). De h1 em diante fica dentro, com pico de R$ 0,134 em h2 contra R$ 0,178
em h1. O sinal é o mesmo.

⚠ **A reversão de médio prazo é mais cedo e mais rasa na pré-COVID.** Curva, câmbio e
CDS cruzam zero em h9, contra h13–h14, e o vale da curva é de −56 a −59 p.b. em h23,
contra −111 a −131 p.b. em h36 na produção. Em h36 a curva pré-COVID está em −19 a
−22 p.b. Esses pontos ficam dentro do conjunto de 90%, que é largo nesses horizontes.

⚠ **Fora de curva e risco a janela importa.** No painel inteiro, 1407 dos 4255 pontos
pré-COVID (33%) saem do conjunto de 90% da produção, em 103 das 115 séries, e 2103
saem do de 80%. A saída cresce com o horizonte: 36 de 115 em h0, 172 de 690 em
h1–h6, 177 de 690 em h7–h12, 402 de 1380 em h13–h24 e 620 de 1380 em h25–h36. O
sinal do impacto coincide em 96 das 114 séries. Nas quatro séries da figura que não
são curva nem câmbio/risco:

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
  positivo, fase positiva das ações, DLSP crescente) **não se repete** na
  pré-COVID. O corpo do artigo não afirma que ela se repete: o ponteiro da §3.4 só
  aponta a figura.
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
- Nenhum número novo no corpo. O PDF compila em 32 páginas, sem referência indefinida.

Com `fig:lp_sensibilidade` o modelo sem tratamento entra no paper pela primeira vez,
como a coluna da direita de uma figura de anexo, com os conjuntos Anderson--Rubin de
`q = 5`. A decisão anterior de mantê-lo fora (`2026-09-24_q_sensibilidade_anexo`)
fica revista só nesse ponto. A coluna da esquerda repete a `fig:q_sensibilidade`.
