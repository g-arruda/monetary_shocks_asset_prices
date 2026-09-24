# A agregacao mensal e o sinal de heterocedasticidade

> Gerado por `het_rigobon/03_atenuacao.R` em 2026-09-22. Nunca editado a mao.

> **Quarentena.** A identificacao por heterocedasticidade segue abandonada para
> o artigo (2026-08-17). Nada aqui entra como corroboracao, perna de robustez ou
> estimativa alternativa sem decisao separada do autor.

## O que a diluicao temporal preveria

Se o unico excesso de variancia do mes com reuniao fosse o dia do anuncio, e se as
variacoes diarias fossem independentes dentro do mes, a razao de variancia mensal
seria `1 + (razao diaria - 1)/n`: o choque de um dia entra com peso `1/n` na
variacao do mes. Aqui `n` = 20.64 dias uteis por mes, na janela de producao.

| Serie | n_C/n_NC (dia) | razao Qua->Qui | diluicao prevista | razao mensal | excesso |
|---|---|---|---|---|---|
| DI 3 meses | 104/554 | 5.545 | 1.220 | 1.381 | 0.161 |
| DI 6 meses | 104/554 | 2.891 | 1.092 | 2.068 | 0.977 |
| DI 12 meses | 104/554 | 2.650 | 1.080 | 2.686 | 1.606 |
| CDS 5 anos | 111/610 | 0.928 | 0.997 | 2.274 | 1.278 |
| Cambio BRL/USD | 110/606 | 1.026 | 1.001 | 1.485 | 0.484 |

A mensal e a do proprio painel: ultima cotacao do mes de referencia nos vertices
do DI e no CDS, media mensal no cambio. Meses: 110 com reuniao e 55 sem.

Residuos do VAR(4) mensal com constante e tendencia de `yield_3m`, `cds_5y` e
`cambio_usd`: razoes de variancia C/NC de 1.990, 1.989, 1.586.

## O mesmo estimador, dois objetos

| Celula | Objeto | Qr(1,2) | p |
|---|---|---|---|
| Diaria, DI 3 meses | variacao Qua->Qui | 11.434 | 0.0033 |
| Mensal, p=1 | variacao mensal das mesmas tres series | 1.336 | 0.5128 |
| Mensal, p=4 | VAR em nivel, constante e tendencia | 0.025 | 0.9878 |

No mensal p=1 os autovalores saem em 2.70, 1.72, 1.02.
A defasagem nao e formalidade no mensal, entao essa linha e um filtro diferente
da diaria; a comparacao e entre objetos, nao so entre frequencias.

## Leitura

A diluicao de pura frequencia preveria razoes mensais proximas de 1 em todas as
series: o anuncio de um dia pesa cerca de 1/20.6 na variacao do mes. O painel mensal
observado fica acima disso em todas elas, e no CDS a direcao e outra: a razao
diaria e abaixo de 1 e a mensal acima de 2. Meses com reuniao sao meses de
volatilidade alta em todas as series, nao so no dia do anuncio.

O excesso observado mistura a contaminacao do regime mensal, a dinamica intra-mes
e a propria construcao da serie (ultima cotacao contra media mensal). **Nada aqui
separa a diluicao temporal da variacao de calendario** -- e a decisao de 2026-09-22
proibe que o paper ou o registro atribuam a queda da condicao a uma das duas.
O diagnostico existe para medir o tamanho do problema, nao para escolher a causa.

## Guardas

- Grade semanal sem perder reuniao do Copom; piso de 30 observacoes por regime.
- `n` calculado dos dias uteis do proprio DI: 20.64 por mes.
- A agregacao mensal e a unica do painel; nenhuma outra e construida aqui.

