# Funcoes de resposta identificadas por heterocedasticidade

> Gerado por `het_rigobon/02_irf.R` em 2026-09-22. Nunca editado a mao.

> **Quarentena.** A identificacao por heterocedasticidade segue abandonada para
> o artigo (2026-08-17). Nada aqui entra como corroboracao, perna de robustez ou
> estimativa alternativa sem decisao separada do autor.

As series sao as de GRG (2025): DI, cambio BRL/USD e CDS soberano de 5 anos, nas
duas frequencias. A condicao de identificacao e o teste `Qr` do pacote `svars`,
rodado em `script/het_conditions.R`. Um sistema que nao rejeita `lambda_1 = lambda_2`
tem a resposta impressa aqui, mas ela **nao e uma estimativa**.

| Vertente | Vertice | Veredito da condicao |
|---|---|---|
| Diaria, tres observaveis de GRG | 3 meses | identificado (Qr 11.43, p 0.0033) |
| Diaria, tres observaveis de GRG | 6 meses | **SEM IDENTIFICACAO** (Qr 4.95, p 0.0844) |
| VAR mensal, as mesmas tres | 3 meses | **SEM IDENTIFICACAO** (Qr 0.02, p 0.9878) |
| VAR mensal, as mesmas tres | 6 meses | **SEM IDENTIFICACAO** (Qr 0.17, p 0.9166) |
| Cinco inovacoes fatoriais | -- | **SEM IDENTIFICACAO** (Qr 5.15, p 0.0761) |

## Impacto de um aperto de 50 pontos-base

Ponto e banda de 90% por reamostragem dentro de regime, nas escalas do artigo.

| Serie | Vertice | Diario | VAR mensal |
|---|---|---|---|
| CDS 5 anos (p.b.) | 3 meses | -4.16 [-15.31; 2.87] | -80.52 [-462.18; 577.43] |
| CDS 5 anos (p.b.) | 6 meses | -4.11 [-17.17; 2.04] | -1.10 [-188.63; 179.80] |
| Cambio BRL/USD (%) | 3 meses | -1.53 [-3.13; -0.34] | -4.02 [-34.06; 46.44] |
| Cambio BRL/USD (%) | 6 meses | -1.28 [-2.78; 0.13] | 0.93 [-13.19; 15.30] |

Na vertente fatorial, normalizada em `yield_6m` como a producao:

| Serie | Het fatorial | Proxy de producao |
|---|---|---|
| CDS 5 anos (p.b.) | 9.60 [-22.90; 35.67] | 30.49 |
| Cambio BRL/USD (%) | 1.52 [-1.93; 3.93] | 3.23 |
| Ibovespa (%) | 5.03 [-1.79; 14.14] | -1.50 |

## Guardas

- O `rawimp` construido aqui reproduz o ponto de `compute_irf_dfm()`: desvio 0.
- DFM na celula de producao: raiz maxima 0.9836766921623673.
- VAR mensal estavel em todo vertice: maior raiz 0.965220.
- Bandas por reamostragem dentro de regime, 500 replicas, forma reduzida fixa.

