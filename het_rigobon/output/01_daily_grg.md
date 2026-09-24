# A replicacao diaria contra Goncalves, Rodrigues e Genta (2025)

> Gerado por `het_rigobon/01_daily_grg.R` em 2026-09-22. Nunca editado a mao.

> **Quarentena.** A identificacao por heterocedasticidade segue abandonada para
> o artigo (2026-08-17). Nada aqui entra como corroboracao, perna de robustez ou
> estimativa alternativa sem decisao separada do autor.

Painel reconstruido de `data/raw/`: 834 semanas Qua->Qui entre 2010-01-06 e 2025-12-25, 128 com reuniao do Copom.
GRG usam 768 semanas entre 2009-09 e 2024-12. O piso desta amostra e 2010-01-01, quando comecam BRL/USD, Ibovespa e Focus.

## Tabela 1: razoes de variancia

| Serie | n_C/n_NC | Var_C/Var_NC | IC 99% | GRG | GRG no nosso IC |
|---|---|---|---|---|---|
| di_3m | 120/643 | 6.53 | [2.83; 15.02] | 4.53 | sim |
| di_6m | 120/643 | 3.45 | [1.26; 8.11] | 3.40 | sim |
| di_12m | 120/643 | 2.83 | [1.14; 7.18] | 2.33 | sim |
| di_2y | 120/643 | 1.89 | [0.84; 4.02] | -- | -- |
| brl | 127/701 | 0.98 | [0.66; 1.46] | 0.92 | sim |
| ibov | 120/645 | 0.94 | [0.52; 1.61] | -- | -- |
| cds_5y | 128/706 | 0.89 | [0.25; 2.83] | 0.85 | sim |
| embi | 124/673 | 0.82 | [0.42; 1.45] | -- | -- |
| focus_ipca12m | 120/658 | 1.47 | [0.51; 3.51] | -- | -- |

## Tabelas 4 e 5: coeficientes por +100 p.b.

| Vertice | Dependente | Coeficiente | EP | IC 95% | GRG | Mesmo sinal | GRG no nosso IC |
|---|---|---|---|---|---|---|---|
| di_3m | brl | -3.08 | 1.60 | [-7.32; -1.02] | -5.10 | sim | sim |
| di_6m | brl | -2.85 | 2.58 | [-9.33; -0.32] | -3.93 | sim | sim |
| di_12m | brl | -1.71 | 3.02 | [-10.30; 0.48] | -3.42 | sim | sim |
| di_3m | cds_5y | -11.96 | 12.73 | [-44.79; 2.42] | -3.00 | sim | sim |
| di_6m | cds_5y | -12.75 | 57.35 | [-62.79; 3.63] | -5.00 | sim | sim |
| di_12m | cds_5y | -10.37 | 33.36 | [-67.72; 2.68] | -11.00 | sim | sim |

O cambio sai menor em modulo que o deles (-3.08% contra -5.10% por 100 p.b. no vertice de 3 meses).
Na subamostra mais proxima da deles, ate 2024-12-31, da -2.95%.

## Tabela 8: janelas moveis de dez anos

| Janela | Cambio | GRG | CDS |
|---|---|---|---|
| 2010:2019 | -2.38 | -- | -5.74 |
| 2011:2020 | -2.73 | -- | -17.09 |
| 2012:2021 | -2.95 | -- | -19.52 |
| 2013:2022 | -2.77 | -- | -22.04 |
| 2014:2023 | -3.67 | -- | -21.38 |
| 2015:2024 | -6.09 | -- | -29.19 |
| 2016:2025 | -5.75 | -- | -25.02 |

O coeficiente cambial cresce em modulo ao longo do tempo nos dois paineis, que e
o que explica a diferenca de nivel: uma amostra que comeca em 2010 nao deveria
reproduzir a coluna cheia de GRG.

## O CDS de GRG nao e nulo

A Tabela 5 deles traz o CDS em -0,03 / -0,05 / -0,11 nos vertices de 3, 6 e 12
meses, **em ponto percentual** -- isto e, -3 / -5 / -11 p.b. por 100 p.b., o de
12 meses com uma estrela (t = 2,2). A prosa do artigo diz que o CDS "nao parece
ser afetado", mas a tabela traz um fechamento, e no vertice longo ele e distinto
de zero.

A replica da -11.96 p.b. em 3 meses e -10.37 em 12, contra os -11 deles.

A unidade do CDS em GRG e **inferida, nao declarada**. O artigo nao diz em que
unidade o mede; todo o resto dele esta em ponto percentual, e dois testes de
escala fixam a leitura: a razao entre os erros-padrao publicados de cambio e CDS
em 3 meses e 0,75/0,05 = 15,0, contra 14,25 nas mesmas series do painel
reconstruido -- se o CDS deles estivesse em pontos-base a razao seria 0,14.
`het_rigobon/_common.R` guarda a linha ja convertida e documenta os dois testes.

## Guardas

- Rota de covariancia e forma IV de Rigobon-Sack batem a 1e-10 nas 18 celulas.
- A grade semanal nao perde nenhuma reuniao do Copom da janela.
- Piso de 30 observacoes por regime em toda celula.
- Erros-padrao por reamostragem dentro de regime, 500 replicas (a contagem de Rigobon).

