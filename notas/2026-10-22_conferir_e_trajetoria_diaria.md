# Os 22 marcadores `[conferir]` e a leitura da trajetória diária

> **CURRENT — 2026-10-22.** Dois itens de `registro/pendencias.md`: "Reescrever as 22 frases marcadas
> `[conferir]`" (passo 2) e "Leitura da trajetória diária na §4" (passo 3, e-mail do orientador de 19-10,
> item 1). Branch `feature/auditoria-janelas-copom`, **não mergeada, sem commit**.
> - Nada reestimado. Só `paper/paper.tex` e o registro mudam. Os números vêm do cache
>   (`output/irf/irf_coherence_cell.rds`, nas escalas de `PANELS` de `script/fig_section5.R`), de
>   `output/var/svar_iv_weak_robust.csv` (célula `production`, nível 0,9) e de
>   `output/event_trajectory/regressions.csv` (base `producao_111`, amostra `comum`, 110 reuniões).
> - Decisões do autor em 22-10, antes de escrever:
>   - a leitura da trajetória diária vai num parágrafo novo no fim do Anexo E, depois da `tab:ponte`, sem
>     números, com os níveis de 90% e 95%;
>   - a §4.2 ganha uma frase no fim do parágrafo de significância, com a leitura do item 5 do e-mail e o
>     ponteiro para a `fig:ponte` e a `tab:ponte`;
>   - o parágrafo do Anexo E fala também da `tab:ponte`, com sinais e significância, inclusive o câmbio
>     não significante na agregação alternativa;
>   - marcador do JK: só a fração; marcador da §3.4: ξ_mp com números e F_rob sem, de modo que o 10,85 fica
>     só na tabela, como decidido em 21-10; marcador da conclusão: sai a cláusula da apreciação; marcador
>     dos preços: a frase dos grupos reescrita pela magnitude;
>   - picos quase empatados vão com os dois horizontes.

## 1. Os 22 marcadores

Cada frase foi reescrita no próprio parágrafo, e nada mudou de lugar.

| # | onde | o que diz agora |
|---|---|---|
| 1 | §3.3, rodapé do JK | os pares significantes a 90% caem cerca de um quinto (1390 → 1122) |
| 2 | §3.4 | a ortogonalização reduz ξ_mp, de 7,69 para 7,28 e de 5,53 para 4,87, e reduz também F_rob nas duas janelas, sem número. A frase com 10,85 saiu |
| 3 | §4, abertura | preços ao produtor e ao consumidor sobem no impacto, IPCA positivo até h7 e negativo a partir de h8 |
| 4 | §4.1 | 3 meses a 2 anos com pico em h3. Os vértices de 5 e 10 anos chegam a 92,3 e 83,2 em h3 e a 92,3 e 83,3 em h4. Selic com pico de 42,4 em h5 |
| 5 | §4.2 | BRL/USD em R$ 0,161 em h1 e h3 (0,1609 e 0,1613), BRL/EUR com pico de 0,138 em h1 |
| 6 | §4.4 | Selic, PIB e câmbio Focus "para 12 meses" e "em 12 meses" no lugar de "do ano seguinte" (a linha do câmbio não tinha marcador) |
| 7 | §4.4 | DLSP esperada com vale de −0,185 em h7, positiva a partir de h15 |
| 8 | §4.4 | primário esperado negativo nos 36 meses, vale de −0,148 em h28 |
| 9 | §4.5 | os cinco segundos vales ficam acima do impacto em valor absoluto, em h12 (h13 nos bens de capital) |
| 10 | §4.6 | indústria, comércio e construção com pico em h3, saldo total, agropecuária e pessoa física em h4 (0,71, 1,14, 0,46) |
| 11 | §4.7 | todos os preços sobem no impacto. "Os preços ao produtor sobem mais que os ao consumidor, e essa diferença de magnitude organiza a dinâmica posterior do bloco" |
| 12 | §4.7 | IPCA positivo de h0 a h7, negativo a partir de h8 |
| 13 | §4.7 | EX1 e INPC oscilam e ficam negativos a partir de h8 e h5 |
| 14 | §4.8 | seis dos sete índices negativos no impacto, e o IMAT positivo |
| 15 | §4.8 | picos em h2. Em h3–h4 os retornos diminuem sem voltar ao campo negativo, e em h5 voltam a subir |
| 16 | §4.8 | IFIX positivo em h2, negativo em h3–h4, positivo a partir de h5 |
| 17 | §4.8 | IMAT sobe 0,20% no impacto e fica positivo até h25 |
| 18 | §5 | sinais de impacto coincidem em quatro das cinco séries, todas menos o IPCA |
| 19 | §5 | IPCA +0,020 no DFM e −0,052 no VAR |
| 20 | §5 | o IPCA sobe nos dois modelos no primeiro ano (0,045 e 0,096 em h4). Os modelos se separam a partir de h8, quando o IPCA fica negativo no DFM e permanece positivo no VAR até h13 |
| 21 | §5 | BRL/USD do DFM em R$ 0,161 em h1 e h3, CDS com pico em h1. No VAR os dois picos vêm em h1 (0,147 e 26,8) |
| 22 | conclusão | "o câmbio é significante a 90% do impacto ao sexto mês". A apreciação significante só a 80% (h26–h36) fica só na §4.2 |

- ⚠ Marcador 11: a segunda metade da frase ("organiza a dinâmica posterior do bloco") veio do texto
  antigo. Com os dois grupos subindo no impacto, com pico em h1 e troca de sinal em h8 e h9, a frase vale só
  como diferença de magnitude.

## 2. A trajetória diária

**§4.2, fim do parágrafo de significância.** A depreciação e a alta do CDS em horizontes posteriores
aparecem também fora do DFM, na trajetória diária da `fig:ponte` e na forma reduzida mensal da `tab:ponte`.
A frase diz que isso é consistente com uma transmissão associada ao risco, mas não identifica que o risco
cause a depreciação.

**Anexo E, parágrafo depois da `tab:ponte`**, sem números, com as afirmações do item 1 do e-mail:

| afirmação | base em `regressions.csv` / `tab:ponte` |
|---|---|
| a apreciação na 1ª cotação é estimativa pontual imprecisa, não significante a 90% | câmbio −0,024, p 0,107 |
| na 5ª e na 10ª o câmbio não é significante a 90%, e a troca de sinal não é datada | p 0,486 e 0,387 |
| na 20ª a depreciação é significante a 95%, limite inferior perto de zero, consistente sem confirmar | +0,104, p 0,037, 95% [0,006; 0,203] |
| CDS não significante a 90% na 1ª e na 5ª, a 95% na 10ª e só a 90% na 20ª | p 0,825, 0,955, 0,009 e 0,054 |
| o CDS fica significante já na 10ª, o câmbio só na 20ª | sem leitura causal |
| forma reduzida mensal com os sinais do DFM em h0 e h1 | todos os pontos positivos |
| séries do painel: câmbio a 90% em h0 e a 95% em h1, CDS a 95% nos dois | `tab:ponte` |
| agregação alternativa: câmbio não significante a 90% em h0 nem h1, CDS a 90% em h0 e a 95% em h1 | `tab:ponte` |
| figura por +50 p.b. de surpresa, tabela por +50 p.b. no DI de 6 meses: comparação de sinais e dinâmica, não de magnitudes | e-mail de 19-10, item 2 |

O parágrafo de método do Anexo E já dizia que os intervalos valem por horizonte, sem correção para
múltiplos horizontes, e que os horizontes são cotações no calendário de cada série. Por isso a leitura não
repete essas duas coisas. O 95% continua só no Anexo E.

## 3. O que não mudou

- "Altamente sincronizada" e "in close synchrony" (conclusão e resumo), "o mercado de trabalho responde com
  defasagem" e a regra de sinal de JK na introdução: ficam para a versão integrada.
- A leitura do item 5 do e-mail está agora na §4.2. Introdução e conclusão ainda não a têm.
- O IBC-Br do VAR é significante só no impacto, mas o texto da §5 não fala de significância no VAR.
- ⚠ `\autoref` e as legendas imprimem "Figure" e "Table". Os `\renewcommand` de `\figurename`,
  `\figureautorefname` e `\tableautorefname` entraram em `paper_anpec.tex` em `bd3a52c` (2026-09-27) e não
  passaram para `paper.tex` na troca para `elsarticle`. `.claude/rules/writing.md` diz "Figura/Tabela". Não
  foi mexido nesta rodada.

## 4. Verificação

- `grep -c conferir paper/paper.tex` dá 0, e não sobra `\textcolor`.
- `pdflatex` + `bibtex` + `pdflatex` ×2 sem erro, sem overfull nem underfull. O único aviso, `TS1/aer/m/n`,
  já existia.
- O parágrafo novo do Anexo E sai na p. 34, depois da `tab:ponte`.
