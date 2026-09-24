# A condicao de identificacao por heterocedasticidade, nas series de GRG

> Gerado por `script/het_conditions.R` em 2026-09-24. Nunca editado a mao.

Rigobon (2003) enuncia **uma** condicao de identificacao, a condicao de posto,
equacao (6), e diz que ela falha se e somente se as matrizes de covariancia dos
dois regimes forem proporcionais. Na forma multivariada isso e a distincao entre
os autovalores de `Lambda` em `Sigma_NC = B B'` e `Sigma_C = B Lambda B'`. O
estimador e o teste sao os do pacote `svars`: a rotina de maxima verossimilhanca
`IdentifyVolatility()` e o teste sequencial `Qr` de Lutkepohl, Meitz, Netsunajev
e Saikkonen (2021), `cv_ident_test()`, que e o que `id.cv()` reporta com dois
regimes.

## As series

**Sao as de GRG (2025) nos dois lados:** a variacao Qua->Qui do DI, do cambio
BRL/USD e do CDS soberano de 5 anos (Tabela 1 deles). Eles **nao** usam Ibovespa
nem o vertice de 2 anos; o que este projeto publicava como linha diaria ate
2026-09-21 usava os dois, e aquele conjunto era do projeto, nao deles.

A quarta serie de GRG, a expectativa de inflacao, e o *breakeven* entre titulos
indexados e nominais. O projeto so tem a medida do Focus, que e survey -- os
autores dizem `market-based (not survey data)` -- e cuja variacao diaria e
exatamente zero em 23% dos dias, porque o Focus sai uma vez por semana. Ela fica
fora, e a lacuna fica declarada.

O vertice do DI e a dimensao em que os proprios GRG variam. Os tres que o projeto
constroi entram como linhas nas duas frequencias.

Janela: 2012-03 a 2025-12 em todos os sistemas.

## Os sistemas

| Sistema | Vertice | n_C/n_NC | lambda_1 (EP) | lambda_2 (EP) | Qr(1,2) | g.l. | p | p Holm | det eq.(6) |
|---|---|---|---|---|---|---|---|---|---|
| Tres observaveis de GRG | 3 meses | 102/553 | 7.549 (1.151) | 1.361 (0.207) | 11.434 | 2 | 0.0033 | 0.0099 | 40.8196 |
| Tres observaveis de GRG | 6 meses | 102/553 | 4.063 (0.619) | 1.357 (0.207) | 4.945 | 2 | 0.0844 | 0.1687 | 3.9708 |
| Tres observaveis de GRG | 12 meses | 102/553 | 3.631 (0.553) | 1.401 (0.214) | 3.829 | 2 | 0.1474 | 0.1687 | 2.4322 |
| Tres observaveis de GRG (VAR) | 3 meses | 108/54 | 2.509 (0.592) | 2.359 (0.557) | 0.025 | 2 | 0.9878 | 1.0000 | -0.0261 |
| Tres observaveis de GRG (VAR) | 6 meses | 108/54 | 3.074 (0.725) | 2.588 (0.611) | 0.174 | 2 | 0.9166 | 1.0000 | 0.0573 |
| Tres observaveis de GRG (VAR) | 12 meses | 108/54 | 2.853 (0.673) | 2.440 (0.576) | 0.144 | 2 | 0.9305 | 1.0000 | 0.0298 |
| Cinco inovacoes fatoriais | -- | 107/54 | 4.034 (0.953) | 1.679 (0.396) | 5.153 | 2 | 0.0761 | 0.0761 | -- |

`lambda_1` e o maior autovalor, o do choque cuja variancia mais sobe nos periodos
com reuniao. Nomear essa coluna exige que ele seja distinto dos demais, e `Qr(1,2)`
e o teste dessa distincao: **nao rejeitar e nao identificar**. A coluna `det eq.(6)`
traz `det(Sigma_C - a Sigma_NC) / det(Sigma_NC)`, zero sob proporcionalidade exata e
invariante as unidades de cada serie. `p Holm` ajusta o p pelos tres vertices de
cada sistema.

## Razoes de variancia entre regimes

`Var_C / Var_NC` de cada serie, sobre os mesmos residuos que o teste usa: a variacao
Qua->Qui no diario, os residuos do VAR no mensal, as inovacoes padronizadas na linha
fatorial. E a estatistica de Rigobon e Sack (2004); a do DI e o `a` da coluna `det`.

| Sistema | Vertice | Serie | Var_C | Var_NC | Razao |
|---|---|---|---|---|---|
| Tres observaveis de GRG | 3 meses | di_3m | 86.59 | 15.62 | 5.544 |
| Tres observaveis de GRG | 3 meses | cds_5y | 39.98 | 50.29 | 0.795 |
| Tres observaveis de GRG | 3 meses | brl | 1.035 | 0.9966 | 1.038 |
| Tres observaveis de GRG | 6 meses | di_6m | 172.2 | 60.66 | 2.839 |
| Tres observaveis de GRG | 6 meses | cds_5y | 39.02 | 50.38 | 0.775 |
| Tres observaveis de GRG | 6 meses | brl |  1.04 | 0.9999 | 1.040 |
| Tres observaveis de GRG | 12 meses | di_12m |   368 | 138.4 | 2.659 |
| Tres observaveis de GRG | 12 meses | cds_5y | 39.33 | 50.46 | 0.779 |
| Tres observaveis de GRG | 12 meses | brl | 1.043 | 0.9997 | 1.043 |
| Tres observaveis de GRG (VAR) | 3 meses | yield_3m | 6.396e-06 | 2.836e-06 | 2.256 |
| Tres observaveis de GRG (VAR) | 3 meses | cds_5y | 975.4 | 403.8 | 2.415 |
| Tres observaveis de GRG (VAR) | 3 meses | cambio_usd | 0.01801 | 0.009764 | 1.845 |
| Tres observaveis de GRG (VAR) | 6 meses | yield_6m | 1.259e-05 | 4.224e-06 | 2.982 |
| Tres observaveis de GRG (VAR) | 6 meses | cds_5y |   977 | 377.8 | 2.586 |
| Tres observaveis de GRG (VAR) | 6 meses | cambio_usd | 0.01795 | 0.009628 | 1.864 |
| Tres observaveis de GRG (VAR) | 12 meses | yield_1y | 2.441e-05 | 9.679e-06 | 2.522 |
| Tres observaveis de GRG (VAR) | 12 meses | cds_5y | 958.4 | 369.4 | 2.595 |
| Tres observaveis de GRG (VAR) | 12 meses | cambio_usd | 0.01723 | 0.009902 | 1.740 |
| Cinco inovacoes fatoriais | -- | eta1 | 3.146 | 2.423 | 1.298 |
| Cinco inovacoes fatoriais | -- | eta2 | 7.019 | 4.684 | 1.498 |
| Cinco inovacoes fatoriais | -- | eta3 | 1.806 | 1.249 | 1.446 |
| Cinco inovacoes fatoriais | -- | eta4 | 2.045 | 1.469 | 1.392 |
| Cinco inovacoes fatoriais | -- | eta5 | 2.405 |  2.67 | 0.901 |

## Autovalores de Lambda

| Sistema | Vertice | Ordem | lambda | EP |
|---|---|---|---|---|
| Tres observaveis de GRG | 3 meses | 1 | 7.549 | 1.151 |
| Tres observaveis de GRG | 3 meses | 2 | 1.361 | 0.207 |
| Tres observaveis de GRG | 3 meses | 3 | 0.676 | 0.103 |
| Tres observaveis de GRG | 6 meses | 1 | 4.063 | 0.619 |
| Tres observaveis de GRG | 6 meses | 2 | 1.357 | 0.207 |
| Tres observaveis de GRG | 6 meses | 3 | 0.650 | 0.099 |
| Tres observaveis de GRG | 12 meses | 1 | 3.631 | 0.553 |
| Tres observaveis de GRG | 12 meses | 2 | 1.401 | 0.214 |
| Tres observaveis de GRG | 12 meses | 3 | 0.668 | 0.102 |
| Tres observaveis de GRG (VAR) | 3 meses | 1 | 2.509 | 0.592 |
| Tres observaveis de GRG (VAR) | 3 meses | 2 | 2.359 | 0.557 |
| Tres observaveis de GRG (VAR) | 3 meses | 3 | 1.266 | 0.299 |
| Tres observaveis de GRG (VAR) | 6 meses | 1 | 3.074 | 0.725 |
| Tres observaveis de GRG (VAR) | 6 meses | 2 | 2.588 | 0.611 |
| Tres observaveis de GRG (VAR) | 6 meses | 3 | 1.404 | 0.331 |
| Tres observaveis de GRG (VAR) | 12 meses | 1 | 2.853 | 0.673 |
| Tres observaveis de GRG (VAR) | 12 meses | 2 | 2.440 | 0.576 |
| Tres observaveis de GRG (VAR) | 12 meses | 3 | 1.421 | 0.335 |
| Cinco inovacoes fatoriais | -- | 1 | 4.034 | 0.953 |
| Cinco inovacoes fatoriais | -- | 2 | 1.679 | 0.396 |
| Cinco inovacoes fatoriais | -- | 3 | 1.246 | 0.294 |
| Cinco inovacoes fatoriais | -- | 4 | 0.847 | 0.200 |
| Cinco inovacoes fatoriais | -- | 5 | 0.726 | 0.171 |

## O que a correcao de curtose decide

O `Qr` divide pela curtose media dos residuos em cada regime. E o ponto do teste:
sem a correcao a aproximacao qui-quadrado nao vale sob nao-normalidade e o teste
rejeita demais.

| Sistema | Vertice | Curtose NC | C | Fator | Qr corrigido | p | Qr sem correcao | p |
|---|---|---|---|---|---|---|---|---|
| Tres observaveis de GRG | 3 meses | 12.64 | 2.29 | 4.9x | 11.434 | 0.0033 | 55.768 | 0.0000 |
| Tres observaveis de GRG | 6 meses | 16.14 | 1.70 | 4.9x | 4.945 | 0.0844 | 24.288 | 0.0000 |
| Tres observaveis de GRG | 12 meses | 12.79 | 2.22 | 4.8x | 3.829 | 0.1474 | 18.509 | 0.0001 |
| Tres observaveis de GRG (VAR) | 3 meses | 0.06 | 0.99 | 1.4x | 0.025 | 0.9878 | 0.034 | 0.9831 |
| Tres observaveis de GRG (VAR) | 6 meses | 0.09 | 1.34 | 1.5x | 0.174 | 0.9166 | 0.265 | 0.8759 |
| Tres observaveis de GRG (VAR) | 12 meses | 0.17 | 1.17 | 1.5x | 0.144 | 0.9305 | 0.219 | 0.8964 |
| Cinco inovacoes fatoriais | -- | 0.05 | 0.80 | 1.3x | 5.153 | 0.0761 | 6.724 | 0.0347 |

A corrigida e a valida. A sem correcao esta aqui porque so as duas juntas
distinguem um sistema sem rotacao de covariancia de um cujas caudas custaram
potencia ao teste.

## Condicao de posto antes e depois da agregacao para mensal

A agregacao e a do proprio painel: a ultima cotacao do mes de referencia nos
vertices do DI e no CDS, a media mensal no cambio. E a unica que existe aqui --
o objeto que somava as janelas Qua->Qui dentro do mes de calendario foi retirado
em 2026-09-22 por decisao do autor, e nenhuma afirmacao se apoia nele.

| Vertice | Objeto | n_C/n_NC | a | det eq.(6) bruto | det normalizado | Qr(1,2) | p |
|---|---|---|---|---|---|---|---|
| 3 meses | Variacao Qua->Qui | 102/553 | 5.544 | 2.005e+04 | 40.8196 | 11.434 | 0.0033 |
| 3 meses | Painel mensal (ultimo valor do mes) | 108/54 | 2.256 | -1.93e-07 | -0.0261 | 0.025 | 0.9878 |
| 6 meses | Variacao Qua->Qui | 102/553 | 2.839 |  7486 | 3.9708 | 4.945 | 0.0844 |
| 6 meses | Painel mensal (ultimo valor do mes) | 108/54 | 2.982 | 5.504e-07 | 0.0573 | 0.174 | 0.9166 |
| 12 meses | Variacao Qua->Qui | 102/553 | 2.659 | 1.05e+04 | 2.4322 | 3.829 | 0.1474 |
| 12 meses | Painel mensal (ultimo valor do mes) | 108/54 | 2.522 | 5.787e-07 | 0.0298 | 0.144 | 0.9305 |

O determinante bruto nao e comparavel entre as linhas, porque as duas frequencias
medem em unidades diferentes; o normalizado por `det(Sigma_NC)` e, e e o que muda de
ordem de grandeza.

## Todas as hipoteses sequenciais

| Sistema | Vertice | Hipotese | Estatistica | g.l. | p |
|---|---|---|---|---|---|
| Tres observaveis de GRG | 3 meses | lambda_ 1 =lambda_2 | 11.434 | 2 | 0.0033 |
| Tres observaveis de GRG | 3 meses | lambda_ 1 =lambda_2=lambda_3 | 26.859 | 5 | 0.0001 |
| Tres observaveis de GRG | 3 meses | lambda_ 2 =lambda_3 | 2.082 | 2 | 0.3532 |
| Tres observaveis de GRG | 6 meses | lambda_ 1 =lambda_2 | 4.945 | 2 | 0.0844 |
| Tres observaveis de GRG | 6 meses | lambda_ 1 =lambda_2=lambda_3 | 14.443 | 5 | 0.0130 |
| Tres observaveis de GRG | 6 meses | lambda_ 2 =lambda_3 | 2.281 | 2 | 0.3196 |
| Tres observaveis de GRG | 12 meses | lambda_ 1 =lambda_2 | 3.829 | 2 | 0.1474 |
| Tres observaveis de GRG | 12 meses | lambda_ 1 =lambda_2=lambda_3 | 12.299 | 5 | 0.0309 |
| Tres observaveis de GRG | 12 meses | lambda_ 2 =lambda_3 | 2.349 | 2 | 0.3090 |
| Tres observaveis de GRG (VAR) | 3 meses | lambda_ 1 =lambda_2 | 0.025 | 2 | 0.9878 |
| Tres observaveis de GRG (VAR) | 3 meses | lambda_ 1 =lambda_2=lambda_3 | 3.410 | 5 | 0.6371 |
| Tres observaveis de GRG (VAR) | 3 meses | lambda_ 2 =lambda_3 | 2.467 | 2 | 0.2912 |
| Tres observaveis de GRG (VAR) | 6 meses | lambda_ 1 =lambda_2 | 0.174 | 2 | 0.9166 |
| Tres observaveis de GRG (VAR) | 6 meses | lambda_ 1 =lambda_2=lambda_3 | 3.694 | 5 | 0.5942 |
| Tres observaveis de GRG (VAR) | 6 meses | lambda_ 2 =lambda_3 | 2.169 | 2 | 0.3381 |
| Tres observaveis de GRG (VAR) | 12 meses | lambda_ 1 =lambda_2 | 0.144 | 2 | 0.9305 |
| Tres observaveis de GRG (VAR) | 12 meses | lambda_ 1 =lambda_2=lambda_3 | 2.951 | 5 | 0.7076 |
| Tres observaveis de GRG (VAR) | 12 meses | lambda_ 2 =lambda_3 | 1.704 | 2 | 0.4265 |
| Cinco inovacoes fatoriais | -- | lambda_ 1 =lambda_2 | 5.153 | 2 | 0.0761 |
| Cinco inovacoes fatoriais | -- | lambda_ 1 =lambda_2=lambda_3 | 10.831 | 5 | 0.0548 |
| Cinco inovacoes fatoriais | -- | lambda_ 1 =lambda_2=lambda_3=lambda_4 | 19.571 | 9 | 0.0208 |
| Cinco inovacoes fatoriais | -- | lambda_ 1 =lambda_2=lambda_3=lambda_4=lambda_5 | 28.362 | 14 | 0.0127 |
| Cinco inovacoes fatoriais | -- | lambda_ 2 =lambda_3 | 0.614 | 2 | 0.7356 |
| Cinco inovacoes fatoriais | -- | lambda_ 2 =lambda_3=lambda_4 | 3.175 | 5 | 0.6731 |
| Cinco inovacoes fatoriais | -- | lambda_ 2 =lambda_3=lambda_4=lambda_5 | 6.013 | 9 | 0.7386 |
| Cinco inovacoes fatoriais | -- | lambda_ 3 =lambda_4 | 1.020 | 2 | 0.6004 |
| Cinco inovacoes fatoriais | -- | lambda_ 3 =lambda_4=lambda_5 | 2.199 | 5 | 0.8209 |
| Cinco inovacoes fatoriais | -- | lambda_ 4 =lambda_5 | 0.165 | 2 | 0.9208 |

## Leitura

**As mesmas tres series identificam no diario e nao identificam no mensal.** No vertice de 3 meses, o de maior razao de variancia em GRG, o sistema diario rejeita `lambda_1 = lambda_2` com p 0.0033, e `lambda_1` e 7.55 contra 1.36 do segundo autovalor. O VAR mensal nas mesmas tres series, no mesmo vertice, nao rejeita (p 0.9878), e os dois maiores autovalores praticamente coincidem, 2.51 contra 2.36.

**O que separa as duas linhas nao esta separado aqui.** Do diario para o mensal mudam duas coisas ao mesmo tempo: a frequencia e o tipo de variacao, de janela de anuncio para variacao de calendario. A tabela mede o resultado conjunto -- o determinante normalizado cai de 40.8 para -0.03 no vertice de 3 meses -- e nao atribui a queda a uma das duas.

**O vertice importa no diario.** Passando de 3 para 6 e 12 meses, p vai de 0.0033 a 0.0844 e 0.1474: a razao de variancia do DI cai com a maturidade em GRG (4,53 / 3,40 / 2,33) e o teste perde com ela. No mensal nenhum vertice chega perto de rejeitar (p de 0.9166 a 0.9878).

**As cinco inovacoes fatoriais nao rejeitam ao nivel de 5%** (p 0.0761).

## Guardas

- `Lambda` reproduz os autovalores generalizados de `(Sigma_C, Sigma_NC)`: desvio relativo maximo 6.08e-06.
- `B B'` e `B Lambda B'` reproduzem as covariancias por regime: desvio relativo maximo 2.60e-05.
- Nos 4 sistemas ja branqueados -- os diarios e o fatorial -- a defasagem e formalidade: menor correlacao entre residuo e serie 0.9897, contra o piso de 0,98 que `fit_het_cv()` exige. Nos VAR mensais a defasagem faz trabalho e a guarda nao se aplica.
- DFM na celula de producao: raiz maxima 0.9836766921623673.

