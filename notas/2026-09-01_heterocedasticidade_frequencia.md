# Identificação por heterocedasticidade e frequência dos dados

> **CURRENT — diagnóstico negativo reestimado em 2026-09-01.** Painel mensal de
> produção com 115 séries, `(r,q,p)=(4,4,4)`. Este exercício não altera a
> identificação de produção por `z_jk_bs_purif` nem gera IRFs alternativas.

## Orientação e pergunta

O professor recomendou registrar no artigo a tentativa de identificação por
heterocedasticidade à la Rigobon como resultado informativo, e não ocultá-la nem
promovê-la a especificação de produção. A comparação relevante é entre a
descontinuidade de variância preservada nos dados financeiros diários ao redor
das reuniões do Copom e sua versão diluída depois da agregação mensal.

## Implementação verificável

O diagnóstico testa a proporcionalidade das matrizes de covariância,
`H0: Sigma_C = a Sigma_NC`, entre regimes Copom (`C`) e não Copom (`NC`). No
painel diário de quatro variáveis financeiras, a estatística LR e seu p-valor
bootstrap vêm da fixture externa preservada. No exercício mensal, o mesmo tipo
de teste é aplicado às inovações do VAR dos fatores do DFM. A reestimação usa o
painel corrente de 115 séries e inclui `(r,q,p)=(4,4,4)`.

A grade mensal cobre dez pares `(r,q)`, cinco defasagens (`p=4,...,8`), duas
janelas e cinco desenhos de regime: 500 linhas, das quais 450 são válidas. A
subgrade de calendário contém 100 células. Os p-valores da grade são ajustados
por Holm. A fixture diária usa 200 réplicas bootstrap; a grade mensal usa 500.

## Resultado

| Frequência e amostra | `n_C` | `n_NC` | LR | `p_boot` | Condição de posto |
|---|---:|---:|---:|---:|:---:|
| Diária, sistema financeiro | 97 | 524 | 135,10 | 0,005 | Sim |
| Mensal, produção, amostra completa | 99 | 50 | 38,36 | 0,056 | Não |
| Mensal, produção, pré-COVID | 53 | 27 | 13,34 | 0,275 | Não |

Nenhuma das 100 células mensais do desenho de calendário satisfaz a condição
de posto depois da correção de Holm. Portanto, a descontinuidade diária de
variância não sobrevive de modo suficiente na frequência mensal para identificar
o sistema. O exercício mensal não produz choque estrutural nem IRFs válidas.

Os objetos diários e mensais não são idênticos: o primeiro usa observáveis
financeiros, enquanto o segundo usa inovações dos fatores estimados. A
comparação documenta a perda de informação associada à frequência e à
agregação, mas não isola causalmente cada componente dessa perda.

## Decisão editorial e de código

O paper passa a apresentar o diagnóstico em uma subseção de robustez e uma
tabela no apêndice. A identificação por proxy externo permanece como única
estratégia de produção. Os scripts exclusivos da rota por
heterocedasticidade foram removidos; os artefatos, esta nota e os relatórios
externos foram preservados como evidência auditável.

## Fontes

- `email/resposta1.md` e `email/resposta_prof1.md`: orientação editorial.
- `arquivo/heterocedasticidade/output/het/het_robustness.md`: relatório da
  reestimação mensal.
- `arquivo/heterocedasticidade/output/het/het_regime_designs.csv`: classificação
  mensal dos cinco desenhos de regime.
- `arquivo/heterocedasticidade/output/het/het_gate_grid.csv`: grade de
  calendário e correção de Holm.
- `arquivo/heterocedasticidade/output/het/het_verdict.csv`: veredito agregado.
- `arquivo/relatorio/correspondence/referee2/replication/hetero_results.json`:
  fixture diária preservada.
- `paper/paper_anpec.tex`: texto e tabela publicados.
