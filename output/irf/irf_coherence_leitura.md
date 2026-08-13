# Coerência das IRFs

> **CURRENT em 2026-08-12.** Leitura autoral da rodada posterior à correção do
> fechamento mensal da curva. O corpo automático está em
> `irf_coherence_report.md`, e as fontes numéricas são
> `irf_coherence_h.csv` e `irf_coherence_summary.csv`.

## Resultado da régua

| classe | número de variáveis |
|---|---:|
| coerente forte | 20 |
| coerente | 6 |
| parcial | 12 |
| incoerente | 1 |
| ambígua | 7 |
| placebo aceito | 3 |
| canal *soft* | 4 |

A curva é o bloco com maior precisão no curto prazo. Todos os seis vértices,
incluindo a normalização de 6 meses, têm sinal positivo e banda de 90% acima
de zero no impacto. A atividade setorial também cai na direção prevista, mas a
evidência posterior ao impacto passa para a banda de 68%.

O núcleo EX0 é a única variável classificada como incoerente, porque permanece
positivo em toda a janela teórica de médio prazo. A resposta nunca tem sinal
errado com banda de 90%, de modo que a classificação registra persistência do
ponto e não uma rejeição estatística da desinflação.

Os quatro canais *soft*, BRL/USD, BRL/EUR, EMBI+ e CDS, violam o sinal da
previsão convencional e excluem zero a 90% no impacto. Essa violação é o
resultado econômico do artigo, mas a régua não a usa para pontuar coerência
porque o sinal teórico depende do regime de prêmio de risco.

Os placebos passam. O primeiro exclui zero a 90% em um horizonte, enquanto
MSCI e EPU dos Estados Unidos não o fazem em nenhum. Na banda de 68%, há três
exclusões nos 147 pares das três séries.

## Limite da leitura de médio prazo

O par complexo dominante da matriz *companion* tem módulo 0,97475. Quando ele
é retirado, o denominador da normalização muda de sinal, de modo que a
comparação correta exige recolocar as trajetórias na escala comum. Nessa
escala, 13 de 14 séries mudam o sinal do vale e apenas o BRL/USD preserva a
reversão. A curva, o risco soberano e o crédito compartilham, portanto, um modo
de persistência geral do painel. A coincidência dos seus mínimos não deve ser
lida como evidência separada de um único mecanismo econômico.

## Força e inferência

O ξ_mp da célula de produção é 7,65 na amostra completa e 11,53 pré-COVID. A
primeira estatística mantém relevância acima de 3,84, mas fica abaixo da
referência convencional de 10. As bandas de 68% e 90% continuam sendo a
inferência operacional do projeto, com a ressalva explícita de instrumento
fraco na amostra completa. Nenhum resultado Anderson-Rubin é operacional.
