# DBGG e Focus PIB na janela pré-COVID: de onde vem a divergência

> **CURRENT — 2026-10-01.** Rodada de diagnóstico em `main`, **produção intocada, nada no `.tex`**.
> - Produção de 2026-09-26: `z_bs_purif`, `(r,q,p) = (5,5,4)`, escala COVID de Lenza-Primiceri,
>   conjuntos Anderson--Rubin de 80% e 90% com NW(0); pré-COVID 2012-03 a 2019-12 por MQO, em ponto.
> - Responde ao item 3 do e-mail do orientador de 30-09 (`email/email_professor_30-09_23h55.md`):
>   na `fig:precovid_sensibilidade`, DBGG e Focus PIB destoam da amostra completa. O autor pediu as
>   causas antes da frase. **Por decisão do autor a frase não entrou nesta rodada.**
> - Script: `script/precovid_divergence.R`. Saídas: `output/irf/precovid_divergence.csv` (respostas,
>   em unidades nativas) e `output/irf/precovid_divergence_anatomia.csv`. Nada em `R/` mudou.
> - As contagens de pontos fora do conjunto de 90% juntam esses CSVs a
>   `output/irf/irf_coherence_h.csv`, de h0 a h36.

## 1. O que a figura mostra

Da nota `2026-09-30_robustez_pandemia`, seção 3, e do cache de produção:

| série | produção h0 | pré-COVID h0 | pré-COVID fora do conjunto de 90% | produção significativa a 90% |
|---|---|---|---|---|
| DBGG (p.p. do PIB) | −0,136 | +0,343 | 22 de 37: h0–h13 e h29–h36 | negativa em h2–h6, positiva de h32 em diante |
| Focus PIB (p.p.) | −0,189 | −0,554 | 5 de 37: h0–h4 | negativa em h0–h6, positiva de h29 em diante |

A DBGG pré-COVID tem o sinal oposto nas duas pontas: positiva de h0 a h26, com pico de 0,42 em h12,
e −0,32 em h36, contra −0,43 no vale de h5 e +0,65 em h36 na produção. A Focus PIB pré-COVID tem o
mesmo sinal, o triplo do impacto, e fica positiva em h10, contra h16.

## 2. O desenho

Quatro blocos, nas oito séries do Anexo C, nas duas janelas:

1. **Anatomia** (`precovid_divergence_anatomia.csv`). Comunalidade de cada série, isto é, a fração
   da soma de quadrados das diferenças padronizadas `yy` que a projeção nos `r = 5` componentes
   explica. Participação de janeiro na soma de quadrados das diferenças das sete séries Focus. Os
   cinco meses de maior peso nas diferenças da DBGG e da Focus PIB. A participação de cada mês em
   Σz², só nos meses de resíduo do VAR (de 2012-07 em diante), que são os que `H` lê.
2. **Comovimento** de ΔDBGG com ΔDI 6m por subperíodo: correlação dentro do subperíodo, e a fração
   da covariância da amostra completa que cabe a ele.
3. **Instrumento zerado** em jan/2016 e jan/2017, em todos os janeiros, e em out/2014. O
   instrumento já vale zero nos meses sem reunião, então zerar um mês é tirar aquela reunião.
4. **Carga por subconjunto de meses.** Os fatores, o VAR e o choque da célula ficam fixos. Só a
   carga de cada série é reestimada, regredindo a sua diferença padronizada sobre as diferenças
   dos fatores (`yy Λ`) num subconjunto de meses. Sobre todos os meses essa regressão devolve
   exatamente a carga da PCA, porque as colunas de `Λ` são ortonormais. A resposta é
   `sy_i b_i' f_h`, com `f_h` a resposta dos fatores estáticos, recuperada das linhas de tcode 1.

Guardas do script: o ponto e os conjuntos da produção batem com `irf_coherence_h.csv` a 1e-10. O ponto
pré-COVID bate com `precovid_sensitivity.csv`. `f_h` reproduz as linhas de tcode 1, e a carga
sobre todos os meses reproduz o ponto publicado das duas células, ambos a 1e-10. Todas as raízes
são menores que 1.

**O bloco 4 é diagnóstico, não estimador.** Mostra quanto da resposta de uma série depende de
quais meses definem a sua carga. Não reestima o modelo e não tem conjunto.

## 3. Focus PIB: a troca de ano-alvo em janeiro

### 3.1 A série

`R/data_download/focus.R:141` guarda a mediana com `reference_year == year(date) + 1`. Todo janeiro,
a série "ano seguinte" passa a mirar um ano mais à frente. Em dezembro de 2015 ela era a previsão
para 2016, −2,95%, e em janeiro de 2016 passou a ser a de 2017, +0,70%. Depois do X-13 o salto ainda
é de +3,41 p.p. (−2,62 → +0,79). O X-13 classifica a série como sazonal, com fatores estimados em
2012–2025, mas um salto que muda de sinal de um ano para outro não é sazonalidade e sobrevive ao
ajuste.

Participação de janeiro na soma de quadrados das diferenças (seria 1/12 = 0,08 sem concentração):

| série | pré-COVID | amostra completa |
|---|---|---|
| Focus PIB, ano seguinte | 0,790 | 0,750 |
| Focus Selic, ano seguinte | 0,545 | 0,580 |
| Focus DLSP, ano seguinte | 0,586 | 0,364 |
| Focus resultado primário, ano seguinte | 0,580 | 0,471 |
| Focus resultado nominal, ano seguinte | 0,506 | 0,501 |
| Focus câmbio, ano seguinte | 0,059 | 0,038 |
| Focus IPCA 12 meses (horizonte fixo) | 0,021 | 0,126 |

Só jan/2016 responde por 63% da soma de quadrados da Focus PIB na pré-COVID (51% na completa), e
jan/2017 por 13% (10%). A IPCA 12 meses, que é suavizada a horizonte fixo, é o controle: nela
janeiro não pesa. O câmbio "ano seguinte" quase não muda na troca de ano.

**Comunalidade.** A da Focus PIB é 0,523 na pré-COVID (35ª de 115) e 0,211 na amostra completa
(82ª). A da Focus Selic é 0,466 contra 0,310. Na janela curta, os cinco fatores absorvem a troca de
janeiro de 2016.

### 3.2 Duas surpresas grandes caem em janeiro

Participação em Σz² nos meses de resíduo:

| | pré-COVID (54 reuniões) | amostra completa (99) |
|---|---|---|
| out/2014 (+38,6 p.b.) | 0,180 | 0,103 |
| abr/2013 (−33,3) | 0,134 | 0,076 |
| jan/2017 (−29,7) | 0,106 | 0,061 |
| jan/2016 (−25,6) | 0,079 | 0,045 |
| cinco maiores meses | 0,556 | 0,374 |
| todos os janeiros | 0,244 | 0,151 |

Jan/2016 e jan/2017 são duas surpresas dovish, e caem nos dois meses em que a Focus PIB "ano
seguinte" sobe na troca de ano (+3,41 e +1,51 p.p. depois do X-13). A Focus Selic "ano seguinte" cai
nos mesmos meses (15,25 → 12,75 e 10,25 → 9,00). O sinal das duas coincidências é o de um aperto
que derruba a expectativa de PIB e eleva a de Selic, que é o sinal das respostas.

### 3.3 Qual canal pesa

Focus PIB, em p.p.:

| célula | h0 | h3 | h6 | h12 | fica positiva em | fora do conjunto de 90% |
|---|---|---|---|---|---|---|
| produção | −0,189 | −0,270 | −0,224 | −0,076 | h16 | — |
| pré-COVID | −0,554 | −0,576 | −0,275 | +0,131 | h10 | 5 (h0–h4) |
| pré-COVID, z zerado em jan/16 e jan/17 | −0,380 | −0,530 | −0,199 | +0,210 | h8 | 15 (h0–h4, h11–h20) |
| pré-COVID, z zerado em todos os janeiros | −0,347 | −0,503 | −0,240 | +0,123 | h10 | 4 (h0, h2–h4) |
| pré-COVID, z zerado em out/14 | −0,496 | −0,559 | −0,248 | +0,181 | h9 | 5 (h0–h4) |
| pré-COVID, carga sem os meses de janeiro | −0,180 | −0,229 | −0,126 | +0,016 | h11 | **0** |
| produção, carga só dos meses pré-COVID | −0,385 | −0,580 | −0,528 | −0,205 | h16 | 19 (h0–h10, h29–h36) |

**É a carga, não o instrumento.** Tirar as surpresas de janeiro reduz o impacto, mas deixa a
resposta fora do conjunto até h4. Tirar os meses de janeiro da carga da Focus PIB põe toda a
resposta pré-COVID dentro do conjunto de produção. Na direção oposta, a carga estimada só com os
meses pré-COVID, aplicada aos fatores, ao VAR e ao choque de produção, reproduz o impacto pré-COVID
(−0,38 e −0,58 em h0 e h3, contra −0,55 e −0,58). A Focus PIB pré-COVID é forte porque, nessa
janela, a sua comunalidade é quase toda a troca de jan/2016, e esse mês se move com os fatores no
sentido de um afrouxamento.

A reversão mais cedo, em h10–h11 contra h16, sobrevive à carga sem janeiros. Ela acompanha a
dinâmica da janela: o DI de 2 anos cruza zero em h9 na pré-COVID e em h13 na produção.

### 3.4 ⚠ A produção também carrega a troca de ano

Na célula de produção, a carga da Focus PIB estimada sem os meses de janeiro dá −0,091 em h0,
−0,127 em h3 e +0,160 em h36, **metade da resposta publicada na §4** (−0,189, −0,270 e +0,303), e sai
do conjunto de 90% de produção em h0–h3. A Focus Selic vai de 0,471 a 0,396 no impacto. Comparadas
assim, com as duas cargas sem janeiros, a pré-COVID continua o dobro da produção no impacto (−0,180
contra −0,091). A reconstrução das cinco séries "ano seguinte" a horizonte fixo fica como decisão
do autor (`registro/pendencias.md`, Tema D).

## 4. DBGG: o comovimento entre dívida e juros muda de sinal em 2020–22

### 4.1 Os dados

ΔDBGG contra ΔDI 6m, amostra completa:

| subperíodo | correlação | fração da covariância da amostra completa |
|---|---|---|
| 2012-04 a 2014-06 | +0,077 | −0,019 |
| 2014-07 a 2016-12 | +0,156 | −0,102 |
| 2017-01 a 2020-02 | +0,119 | −0,089 |
| 2020-03 a 2022-12 | −0,399 | **+1,011** |
| 2023-01 a 2025-12 | −0,349 | +0,199 |

A fração usa as médias da amostra completa, por isso pode ter sinal diferente da correlação. Em
2020 a DBGG foi de 74,8 a 87,7% do PIB enquanto o DI 6m caía de 4,2 para 2,0%. Entre o fim de 2020 e
o fim de 2022 a DBGG caiu de 86,9 para 71,7% enquanto o DI 6m subia de 2,1 para cerca de 14%. Os meses de
maior peso em ΔDBGG na amostra completa são 2020-06, 2021-04 e 2020-08 (9%, 8% e 5% da soma de
quadrados). Na pré-COVID o maior é 2019-12 (12%).

A comunalidade da DBGG é 0,504 na pré-COVID (36ª de 115) e 0,369 na amostra completa (59ª).

### 4.2 A carga por subperíodo, na célula de produção

DBGG em p.p. do PIB, com os fatores, o VAR e o choque de produção:

| carga estimada sobre | h0 | h2 | h6 | h12 | h18 | h36 | fora do conjunto de 90% |
|---|---|---|---|---|---|---|---|
| todos os meses (produção) | −0,136 | −0,355 | −0,424 | −0,255 | +0,053 | +0,654 | — |
| meses pré-COVID | +0,272 | −0,041 | −0,024 | +0,105 | +0,299 | +0,556 | 6 (h0, h2–h6) |
| sem 2020-03 a 2022-12 | +0,179 | −0,134 | −0,112 | +0,056 | +0,282 | +0,600 | 0 |
| só 2020-03 a 2022-12 | −0,291 | −0,430 | −0,546 | −0,446 | −0,166 | +0,502 | 0 |
| sem os meses de janeiro | −0,145 | −0,361 | −0,433 | −0,257 | +0,059 | +0,672 | 0 |

**O vale da produção vem de 2020–22.** Com a carga dos meses pré-COVID, a resposta de produção fica
perto de zero de h2 a h9, com mínimo de −0,056 em h5 contra −0,428. Com a carga só de 2020–22, o vale
se aprofunda. A alta de longo prazo, a parte significativa positiva da produção, aparece com
qualquer carga (+0,50 a +0,67 em h36).

A reescala de Lenza-Primiceri pondera só o VAR dos fatores (`estimate_var_wls()`). As cargas saem
da PCA de `estimate_static_factors()`, sem ponderação, então os meses de 2020–22 entram nelas com
peso cheio. No VAR a escala cai de 1,76 em maio de 2020 para cerca de 1,25 no fim de 2021 e 1,13 no
fim de 2022, de modo que o ciclo de alta de 2021–22 também pesa ali quase por inteiro.

### 4.3 Não é o instrumento

DBGG pré-COVID, p.p. do PIB:

| célula | h0 | h6 | h12 | h36 | fora do conjunto de 90% |
|---|---|---|---|---|---|
| pré-COVID | +0,343 | +0,278 | +0,421 | −0,324 | 22 |
| z zerado em jan/16 e jan/17 | +0,616 | +0,417 | +0,535 | −0,416 | 24 |
| z zerado em todos os janeiros | +0,588 | +0,401 | +0,559 | −0,308 | 23 |
| z zerado em out/14 | +0,453 | +0,369 | +0,494 | −0,385 | 24 |
| carga sem os meses de janeiro | +0,399 | +0,311 | +0,413 | −0,342 | 23 |

Nenhuma surpresa isolada sustenta o sinal positivo: sem elas a DBGG pré-COVID fica **mais**
positiva.

### 4.4 O que sobra é a dinâmica da janela

Na pré-COVID a DBGG fica entre +0,16 e +0,42 de h2 a h12. Com a carga pré-COVID nos fatores de
produção, ela fica entre −0,06 e +0,11 nesses horizontes. A diferença vem do VAR e do choque estimados
na janela curta. A ponta longa negativa (−0,32 em h36) acompanha a reversão mais cedo da curva
nessa janela. Esse trecho tem 90 inovações, raiz máxima 0,993359 e nenhum conjunto próprio.

⚠ **O impacto de produção da DBGG é frágil.** Zerar só jan/2016 e jan/2017 o leva de −0,136 a +0,009.
Ele já trocava de sinal com `q ≤ 4` e sem a reescala (`2026-09-30_robustez_pandemia`, seção 2), e o
conjunto de 90% de produção contém zero em h0 e h1.

## 5. O câmbio pré-COVID no impacto

A nota de 09-30 marcou o impacto pré-COVID do BRL/USD, R$ 0,056/US$, abaixo do conjunto de 90% de
produção. Com o instrumento zerado em jan/2016 e jan/2017 ele vai a 0,107, e em todos os janeiros a
0,141, e sai do conjunto em 0 de 37 horizontes nos dois casos. A comparação justa zera os mesmos
meses nas duas janelas. Na produção o mesmo corte leva o câmbio a 0,174, então a razão
pré-COVID/produção sobe de 0,40 para 0,81, e não para 1. Aqui o canal é o instrumento, não a carga:
a carga sem janeiros deixa o câmbio em 0,065, ainda fora em h0.

⚠ Na produção, zerar jan/2016 e jan/2017 também move os impactos de preço: câmbio 0,141 → 0,174, CDS
34,0 → 43,5 p.b., DI de 2 anos 72,1 → 80,3 p.b. Nenhum ponto das oito séries sai do conjunto de 90%,
em nenhuma das três variantes.

## 6. Leitura econômica: hipóteses, não resultados

- **DBGG.** Os canais diretos de um aperto sobre a razão dívida/PIB empurram para cima: o custo
  das LFTs e das compromissadas, que entram na DBGG pela metodologia do BCB, e o PIB nominal menor no
  denominador. É o sinal pré-COVID e o de longo prazo da produção. O vale inicial da produção
  coincide com um episódio em que dívida e juros andaram em sentidos opostos por motivos que não são
  choques de política: o pacote fiscal de 2020 com juros mínimos, e depois a inflação de 2021–22, que
  elevou o PIB nominal enquanto o BC subia os juros em resposta a ela. Com cinco fatores, a carga da
  DBGG na amostra completa registra esse comovimento. Nada aqui separa os canais. O bloco 4 mostra
  só de que meses a resposta depende.
- **Focus PIB.** A troca de ano-alvo é mecânica, e a correção padrão para previsões de evento fixo
  é a aproximação a horizonte fixo de Dovern, Fritsche e Slacalek (2012): a média do ano corrente e
  do seguinte ponderada pelos meses que faltam. O episódio de 2014–16 soma uma razão econômica: os
  apertos de 2013–15 coincidiram com o colapso das expectativas de PIB, de 4% para −3%, numa recessão
  com causas fiscais, políticas e externas.

## 7. O que pode e o que não pode ser dito

- Pode: a DBGG pré-COVID tem o sinal oposto ao da produção até h13 e no fim do horizonte, e a Focus
  PIB pré-COVID é mais forte no impacto e reverte antes. Pode também, como fato dos dados: a Focus
  PIB "ano seguinte" troca de ano-alvo em janeiro, e na pré-COVID um único mês, jan/2016, concentra a
  maior parte da sua variação. E o comovimento da DBGG com os juros muda de sinal em 2020–22.
- Não pode: que a DBGG pré-COVID seja a resposta "certa", ou que o vale da produção seja espúrio.
  São hipóteses da seção 6. Também não pode tratar a carga sem janeiros ou sem 2020–22 como
  estimativa alternativa: ela não tem conjunto e não reestima o modelo.
- A regra de `CLAUDE.md` segue valendo: nada além da direção e da magnitude de impacto da curva e do
  risco soberano pode ser escrito como "os resultados valem pré-COVID". Ponto contra conjunto da
  amostra completa não é teste de igualdade.
- ⚠ A resposta da Focus PIB na §4 carrega a troca de ano (seção 3.4). Enquanto o autor não decidir
  a reconstrução, o número publicado continua o da produção, e esta nota é o registro.

## 8. O que mudou

- `script/precovid_divergence.R`, script novo de diagnóstico. Lê `data/processed/` e os CSVs de
  produção, e não escreve nada fora de `output/irf/precovid_divergence*.csv`.
- `registro/pendencias.md`: o item do Tema A sobre DBGG e Focus PIB aponta para esta nota e segue
  aberto. Entraram dois itens: o ponteiro quebrado da §3.4 (Tema A) e a troca de ano das Focus
  "ano seguinte" (Tema D).
- Nada em `R/`, em `paper/` ou na produção. O smoke test não é afetado.
