# Robustez à pandemia no Anexo C: respostas sem a reescala de Lenza-Primiceri e na janela pré-COVID

> **CURRENT — 2026-09-30.** Rodada de apêndice em `paper/paper_anpec.tex`, **sem
> reestimação da produção**. Branch `feature/robustez-pandemia`, não mergeada.
> - Produção de 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, `z_bs_purif`,
>   escala de volatilidade COVID de Lenza-Primiceri e conjuntos Anderson--Rubin de
>   80% e 90% com NW(0).
> - Fecha os dois itens do e-mail do orientador de 28-09
>   (`email/email_professor_28-09_21h15.md`): a figura com e sem o tratamento
>   (Tema A) e a sugestão aberta de robustez pré-COVID (Tema B).
> - Decisões do autor: duas figuras, nos oito painéis das demais figuras do Anexo C.
>   No corpo, só dois ponteiros, sem número.
> - Nada em `R/` mudou. O script novo confere a linha de produção contra
>   `output/irf/irf_coherence_h.csv` a 1e-10.

## 1. O desenho

`script/pandemic_sensitivity.R` roda três células de `run_stage2_cell()`, todas em
`(5,5,4)`, `z_bs_purif`, +50 p.b. no `yield_6m`, até h36:

| célula | janela | VAR fatorial | inferência | raiz máxima |
|---|---|---|---|---|
| produção | 2012-03 a 2025-12 | MQP sob a escala LP | conjuntos AR 80/90% | 0,983676 |
| MQO | 2012-03 a 2025-12 | MQO (`covid_volatility = NULL`) | ponto | 0,970090 |
| pré-COVID | 2012-03 a 2019-12 | MQO, igual ao MQP porque `s_t = 1` | ponto | 0,993359 |

A célula pré-COVID fica em ponto porque `hac_dim < T` barra a covariância AR nessa
janela em `p = 4` (135 ≥ 90). Nenhuma banda pré-COVID foi construída. Os dois
contrastes são contra a mesma linha de produção: o primeiro troca só o estimador, o
segundo troca só a janela.

Saídas: `output/irf/pandemic_sensitivity.csv` (115 séries × 37 horizontes × 3
células, limites só nas linhas da produção), `paper/fig_lp_sensibilidade.pdf` e
`paper/fig_precovid_sensibilidade.pdf`. As figuras seguem o desenho da Figura A3 de
Alessi-Kerssenfischer, como as demais do Anexo C: produção em preto com os conjuntos,
alternativa tracejada em ponto.

Conferências cruzadas: as raízes de MQO e da pré-COVID são as do registro, e o
impacto de `yield_2y` sob MQO, 0,0081785146707394098, é o ponto sem tratamento
pinado em `script/validation/validate_covid_volatility.R`.

## 2. Com e sem a reescala (amostra completa)

**Nenhum ponto de MQO sai do conjunto de 90% da produção**: 0 de 4255 nas 115 séries.
No conjunto de 80% saem 28 pontos, em 16 séries, nenhuma delas entre as oito da
figura. O sinal do impacto coincide em 113 das 114 séries (o `yield_6m` é a
normalização).

⚠ **Os impactos sob MQO são maiores nas oito séries da figura**, de 13% a 81%:

| série | produção h0 | MQO h0 | razão | produção h12 | MQO h12 | produção h36 | MQO h36 |
|---|---|---|---|---|---|---|---|
| DI 2 anos (p.b.) | 72,07 | 81,79 | 1,13 | 5,31 | 29,30 | −131,23 | −126,70 |
| DI 5 anos (p.b.) | 77,31 | 94,57 | 1,22 | 3,91 | 23,98 | −111,16 | −103,75 |
| BRL/USD (R$/US$) | 0,141 | 0,194 | 1,37 | 0,000 | 0,017 | −0,115 | −0,077 |
| CDS 5 anos (p.b.) | 34,02 | 45,83 | 1,35 | 3,51 | 7,73 | −25,90 | −21,07 |
| IBC-Br (pontos) | −0,766 | −1,123 | 1,47 | −0,651 | −0,475 | −0,347 | −0,543 |
| IPCA (p.p. ao mês) | −0,077 | −0,098 | 1,26 | −0,166 | −0,109 | −0,322 | −0,304 |
| Ibovespa (%) | −2,47 | −4,47 | 1,81 | 1,71 | 1,76 | −3,14 | −2,71 |
| DLSP (p.p. do PIB) | −0,736 | −0,901 | 1,22 | −0,175 | −0,310 | 0,728 | 0,705 |

Sob MQO a reversão vem dois a três meses depois: a curva cruza zero em h15–h16, contra
h13 na produção, e o CDS em h16, contra h14. A forma é a mesma, com uma exceção de
sinal: sob MQO o IPCA fica positivo de h4 a h7 (máximo de 0,03 p.p.), enquanto na
produção ele nunca é positivo.

O que a figura sustenta é que a reescala move os coeficientes do VAR (raiz 0,970 →
0,984) e as respostas, e que o movimento cabe dentro do conjunto de 90%. A frase da
§3.1 afirma o deslocamento, não o seu tamanho, e a figura não a contradiz.

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

- A comparação é de pontos contra o conjunto da amostra completa. **Ficar dentro não
  é teste de igualdade** entre as janelas, e sair não é rejeição: o ponto pré-COVID
  tem incerteza própria, que não foi medida porque a célula é barrada.
- A direção e a magnitude de impacto da curva e do risco soberano se repetem na
  pré-COVID. A do câmbio se repete em sinal, com 40% da magnitude no impacto.
- A leitura de médio prazo da §4 (atividade negativa por 36 meses, IPCA nunca
  positivo, fase positiva das ações, DLSP crescente) **não se repete** na
  pré-COVID. O corpo do artigo não afirma que ela se repete: o ponteiro da §3.4 só
  aponta a figura.
- A janela pré-COVID tem 90 inovações e ξ_mp 6,84, abaixo de 10 como a cheia.

## 5. O que mudou no paper

- **Anexo C**: `fig:lp_sensibilidade` ("Sensibilidade à reescala de volatilidade") e
  `fig:precovid_sensibilidade` ("Respostas na janela pré-COVID"), depois de
  `fig:instrumento_camadas`. São as Figuras 13 e 14, e a de placebos passa a 15.
- **§3.1**: rodapé na frase de MQO, apontando `fig:lp_sensibilidade`.
- **§3.4**: uma frase no fim do parágrafo da `tab:first_stage`, apontando
  `fig:precovid_sensibilidade`.
- Nenhum número novo no corpo. O PDF compila em 32 páginas, sem referência indefinida.

Com `fig:lp_sensibilidade` o modelo sem tratamento entra no paper pela primeira vez,
como linha pontual de uma figura de anexo. A decisão anterior de mantê-lo fora
(`2026-09-24_q_sensibilidade_anexo`) fica revista só nesse ponto.
