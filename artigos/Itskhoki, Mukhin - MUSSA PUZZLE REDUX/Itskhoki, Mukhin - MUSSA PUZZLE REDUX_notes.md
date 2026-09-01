# Leitura estruturada — Itskhoki e Mukhin, “Mussa Puzzle Redux”

## 1. Pergunta de pesquisa

O salto conjunto da volatilidade dos câmbios nominal e real após o fim de Bretton Woods é realmente evidência de rigidez nominal? O artigo amplia o “Mussa puzzle” para incluir a estabilidade da inflação, consumo e produto e pergunta qual classe de modelos consegue explicar simultaneamente o conjunto de fatos sob câmbio fixo e flutuante. A tese é que nem modelos RBC convencionais nem New Keynesian de preços rígidos dão conta do conjunto; a resolução requer prêmio cambial/UIP endógeno ao regime monetário, gerado por segmentação financeira e limites à arbitragem.

## 2. Público

Macroeconomistas internacionais e monetários, pesquisadores de câmbio, open-economy macro, asset pricing internacional, política cambial, UIP/risk premia e modelos DSGE quantitativos.

## 3. Método

Artigo teórico-quantitativo com uma parte empírica de “experimento natural” e falsificação de classes de modelos. A quebra de Bretton Woods em 1973 é tratada como mudança descontínua e crível do regime cambial entre grandes regiões. O artigo:

1. documenta mudanças de volatilidade e comovimento antes/depois de 1973;
2. deriva a estatística suficiente `z_t = σ(c_t-c_t*) - q_t`, interpretada como desvio do compartilhamento eficiente de risco;
3. prova que, em ampla classe de modelos convencionais — IRBC, NKOE e modelos com prêmio de risco exógeno — `z_t` não deve mudar com o regime, em contradição com os dados;
4. constrói modelo de mercados financeiros segmentados no qual intermediários absorvem risco cambial e a elasticidade de oferta de moeda/carry trade cai quando a volatilidade cambial sobe;
5. calibra e compara modelos sem choques financeiros, com choques financeiros exógenos e com choques/prêmios endógenos ao regime.

O artigo também usa o peg suíço de 2011–2015 como evidência adicional para separar endogeneidade da intermediação de explicações por intervenção oficial ou choques de demanda de moeda.

## 4. Dados

- Amostra principal: peg em 1960:01–1971:07 e float em 1973:01–1989:12; o intervalo de transição 1971:08–1972:12 é excluído. Gráficos de descontinuidade usam 1973:01 e verificam 1971:08 e 1980:01 como datas alternativas.
- Dados mensais de câmbio nominal, IPC, juros e preços de ações do IMF International Financial Statistics (IFS, 2024).
- Dados trimestrais de PIB, consumo, importações e exportações da OECD (2024).
- Estados Unidos contra “resto do mundo”: França, Alemanha, Itália, Japão, Espanha e Reino Unido, ponderados pelo PIB médio; Canadá é excluído.
- Importações/exportações formam `nx_t=(X-M)/(X+M)` para evitar aumento mecânico da volatilidade decorrente da abertura comercial crescente.
- Episódio suíço: peg do franco ao euro entre 2011 e 2015, com medidas de turnover/intervenção e prêmio/risco cambial.

## 5. Métodos estatísticos/numericos

- Desvios-padrão anualizados de mudanças logarítmicas e médias móveis triangulares (janela de 18 meses para séries mensais; 10 trimestres para trimestrais), tratando 1973:01 como fronteira dos regimes; razões de volatilidade por país com intervalos de 90% baseados em erros Newey–West/HAC.
- Comparações de volatilidade e correlações: câmbio nominal/real, inflação, consumo, PIB, juros, balança comercial, Backus–Smith, Fama/UIP e Balassa–Samuelson.
- Estatística suficiente `z_t`; resultado de falsificação pouco dependente de parâmetros estruturais.
- Modelo de equilíbrio geral em duas economias com política monetária/Taylor rule; versão quantitativa inclui insumos intermediários, capital, custos de ajuste, markups Kimball, local-currency pricing, preços e salários Calvo.
- Calibração principal: `σ=2`, Frisch 1, `β=0,99` trimestral, participação de insumos 0,5, capital 0,3, depreciação 0,02, abertura 0,035 (importações/PIB dos EUA de 7%), preços ajustam em média anualmente, salários a cada seis trimestres, `φ_π=2,15`, suavização `ρ_m=0,95`; robustez para Reino Unido com importações/PIB de 20%.
- Choques AR(1), persistência 0,97; momentos-alvo sob float incluem volatilidade cambial anualizada de 10%, correlação Backus–Smith −0,2 e correlação internacional do PIB 0,3.

## 6. Resultados

- Após Bretton Woods, a volatilidade do câmbio nominal cresce em média oito vezes (de cerca de 2% para 10–12%) e a do câmbio real cerca de seis vezes; inflação, consumo e produto mudam tipicamente dentro de ±10% e não exibem quebra comparável. A volatilidade do diferencial de juros aproximadamente dobra.
- Esse conjunto falsifica modelos de preços flexíveis convencionais (não mudam o câmbio real) e modelos sticky-price convencionais (deslocam volatilidade excessiva para inflação/atividade sob o peg).
- Choques financeiros exógenos podem gerar o “exchange-rate disconnect” sob float, mas não explicam conjuntamente os dois regimes: o prêmio/UIP precisa responder endogenamente à regra monetária.
- Com mercado financeiro segmentado, maior volatilidade nominal sob float reduz intermediação, baixa a elasticidade da oferta de moeda/carry trade e amplia os desvios de UIP; sob peg crível, risco e prêmio cambial caem endogenamente.
- O modelo segmentado reproduz a queda descontínua do câmbio real sob peg enquanto a volatilidade de inflação, consumo e PIB muda apenas cerca de 10%; também gera diferença de juros cerca de duas vezes mais volátil sob float.
- Mais de 80% da volatilidade do câmbio real sob float vem de choques financeiros na decomposição do modelo; o peg elimina endogenamente grande parte do risco de carry trade.
- Rigidez nominal melhora o ajuste quantitativo da especificação preferida, mas não é necessária nem suficiente para explicar o puzzle; a não neutralidade relevante nasce no mercado financeiro.

## 7. Contribuições

O artigo reinterpreta uma evidência clássica de não neutralidade: volatilidade cambial real não permite inferir automaticamente rigidez de preços. Sua contribuição mais útil para a narrativa brasileira é disciplinar a passagem “resposta forte do câmbio/ativos → mecanismo”: preços de ativos e câmbio podem reagir por um canal de prêmio de risco financeiro endógeno à política, mesmo sem grande resposta contemporânea de inflação ou atividade. Também oferece base teórica explícita para um wedge de UIP variável no tempo e uma falsificação: se o mecanismo proposto for macroeconômico convencional, ele deve ser coerente com o comportamento conjunto de consumo, produto e inflação, não apenas com o câmbio.

## 8. Viabilidade de replicação

Alta para os fatos e resultados publicados: o pacote de replicação está no Zenodo, DOI `10.5281/zenodo.13834227`, e a *Econometrica* declara ter verificado dados e códigos. IFS/OECD e fontes auxiliares FRED, SECO, GFD e CEIC podem impor licenças ou decisões de vintage. Reproduzir/extender o modelo continua tecnicamente exigente, mas o arquivo oficial reduz substancialmente a barreira.

## Passagens citáveis e uso narrativo

- “monetary transmission via the risk premium channel” — Resumo, página marcada `page-0-0`, linha 13 do markdown-fonte. **Disciplina teórica:** pode aparecer na motivação da resposta conjunta de câmbio, curva e risco soberano como alternativa a uma narrativa puramente real/nominal-rigidity.
- “there was no comparable change in the properties of other macro variables” — Seção 1, página marcada `page-1-0`, linha 33. **Evidência:** justifica dizer que uma grande resposta cambial não implica automaticamente grande transmissão imediata para inflação e atividade.
- “Models with exogenous UIP shocks are inconsistent with Mussa facts” — Seção 1, página marcada `page-4-0`, linha 67. **Disciplina teórica:** fortalece a agenda de decompor o wedge de UIP; o prêmio deve responder endogenamente à política/regime, em vez de ser apenas um choque residual imposto.
- “Greater nominal exchange rate volatility discourages intermediation” — Seção 1, página marcada `page-4-0`, linha 69. **Mecanismo do modelo:** oferece a cadeia risco cambial → menor elasticidade de intermediação/oferta de moeda → maiores desvios de UIP.
- “nominal rigidities are neither necessary nor sufficient to explain the Mussa puzzle” — Seção 6.2, página marcada `page-31-0`, linha 525. **Limite interpretativo:** impede inferir rigidez nominal ou canal tradicional apenas a partir de respostas fortes do câmbio real/nominal.
- “This result should, however, be extrapolated with caution” — Remark 7, página marcada em torno de `page-32-0`, linha 537. **Limite externo:** os autores alertam que o resultado do peg crível pode não valer para economias modernas menores, mais abertas e com múltiplos instrumentos; por extensão, o paper brasileiro deve usar o mecanismo, não transportar a calibração.
- “more ubiquitous types of monetary shocks” — Seção 7, página marcada `page-34-0`, linha 565. **Limite e agenda:** os próprios autores dizem que aplicar o mecanismo a choques monetários usuais é objeto de pesquisa; logo a compatibilidade com IRFs monetárias brasileiras não equivale a validação causal.
- “one conventional via demand in the product market and the other unconventional via risk premia” — Seção 7, página marcada `page-34-0`, linha 565. **Organização narrativa:** permite apresentar dois canais concorrentes/complementares e perguntar qual conjunto de respostas do DFM é mais consistente com cada um.

### Julgamento de uso no artigo brasileiro

É um referencial teórico forte para a seção de mecanismo cambial/UIP e para conter sobreinterpretação. Sua contribuição não é evidência direta para Brasil nem uma identificação de choques monetários de alta frequência: o experimento é a troca de regime de Bretton Woods. O uso defensável é (i) motivar prêmios de risco endógenos como canal de transmissão; (ii) mostrar por que câmbio forte com inflação/atividade mais contidas não é paradoxal; e (iii) apresentar a decomposição do wedge de UIP como teste discriminante. Não deve ser citado como prova de que intermediários financeiros geram as IRFs brasileiras.
