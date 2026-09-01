# Leitura estruturada — Kalemli-Özcan e Varela, “Five Facts about the UIP Premium”

## 1. Pergunta de pesquisa

Como medir ex ante o prêmio de risco cambial e o que explica sua variação em economias emergentes e avançadas? As autoras constroem um wedge de UIP prospectivo com expectativas de câmbio de surveys e decompõem o prêmio entre diferencial de juros e depreciação esperada. A pergunta central é se investidores esperam retornos cambiais excedentes e se esses retornos se ligam a risco global ou risco local/político. A resposta é uma assimetria de composição: em economias avançadas, o prêmio é principalmente um objeto de expectativas associado ao risco global; em emergentes, é principalmente um objeto de diferencial de juros associado ao risco local e à incerteza de política doméstica.

## 2. Público

Pesquisadores de macroeconomia e finanças internacionais, UIP/carry trade, expectativas, risco-país, política monetária em emergentes, fluxos de capitais e modelos de mercados cambiais segmentados.

## 3. Método

Estudo empírico descritivo/condicional, não uma identificação de um único mecanismo causal. O prêmio de UIP a 12 meses é `λ^e_{c,t+12}=(i_{c,t}-i^{US}_t)-(s^e_{c,t+12}-s_{c,t})`, usando expectativas médias de participantes do mercado. O artigo:

- documenta cinco fatos em painel e séries temporais;
- decompõe o prêmio em diferencial de juros (IR) e ajuste cambial esperado (ER);
- estima painéis com FE de moeda/país e covariadas locais (PRP, fluxos de capitais) e globais/dólar (VIX, convenience yield, liquidity premium);
- usa regressões “Fama-like” com expectativas e Fama tradicionais com câmbio realizado;
- executa um desenho em dois estágios que relaciona fatores de risco à dispersão de expectativas e esta aos diferenciais de juros;
- usa projeções locais para a resposta das expectativas de depreciação a um choque no diferencial de juros predito por risco local;
- faz estudos de evento para a nacionalização de fundos de pensão na Argentina (2008) e o referendo do Brexit (2016).

As autoras dizem expressamente que as regressões de dois estágios e projeções locais são “consistent with”, não prova definitiva, do canal risco político local → risco cambial.

## 4. Dados

- 34 moedas: 22 emergentes e 12 avançadas, novembro de 1996 a dezembro de 2018 (tabelas principais frequentemente terminam em outubro de 2018); somente regimes de câmbio flutuante conforme Ilzetzki–Reinhart–Rogoff.
- Brasil entra como emergente de 1996m11 a 2018m12.
- Expectativas mensais de câmbio da Consensus Economics nos horizontes 1, 3, 12 e 24 meses; análise principal em 12 meses. Em média, 17 investidores por moeda emergente e 55 por moeda avançada; grandes bancos globais aparecem nos dois grupos.
- Taxas de depósito, money market e títulos públicos da Bloomberg; câmbio spot e fluxos do IMF/IFS; inflação CPI; CDS Bloomberg e episódios de default Reinhart et al.
- VIX, convenience yield e liquidity premium do dólar; risco político/econômico/financeiro do ICRG.
- PRP de política local construído mensalmente com notícias Factiva em jornais domésticos e internacionais, adaptando Baker–Bloom–Davis e incluindo termos específicos de emergentes (capital controls, expropriation, nationalization, corruption).
- Amostra de resumo: 3.397 observações EM e 2.260 AE do prêmio UIP; média EM 4,2%, AE 0,9%; diferencial médio de 3,3 p.p.

## 5. Métodos estatísticos/numericos

- Painéis mensais com FE de moeda/país; erros-padrão duplamente agrupados por moeda e mês na maior parte das regressões.
- Regressões Fama/Fama-like no horizonte de 12 meses com 22 EM; erros two-way clustered.
- Testes de médias EM versus AE.
- `R²` parcial/incremental para decompor poder explicativo de fatores locais e globais, com loadings específicos por país e FE mensais em robustez.
- Two-stage regressions: fatores VIX/PRP predizem dispersão entre expectativas; dispersão predita explica diferencial de juros. KP F entre cerca de 10,7 e 24,5 nas especificações conjuntas/PRP; Cragg–Donald maior.
- Projeções locais com FE de moeda; intervalos de 95% e erros Driscoll–Kraay com bandwidth `h+1`.
- Robustez a outras taxas, inflação, default soberano, regimes, reclassificação de países, controles de capitais, CIP pós-2008 e erros de previsão.

## 6. Resultados

- Prêmio UIP médio: 4,2% nas EM e 0,9% nas AE; diferença 3,3 p.p. estatisticamente significativa. O prêmio EM permanece maior/mais volátil após ajustar por CDS; sua correlação com o prêmio ajustado por CDS é 83% na subamostra.
- Correlação entre prêmio UIP e diferencial de juros: 70% nas EM; nas AE, o prêmio correlaciona 93% com o ajuste cambial esperado. Esse é o núcleo da assimetria de composição.
- Fatores locais explicam 26% da variação do prêmio EM; fatores globais, 11,75% (arredondado a 12%). Com ambos, `R²` ajustado é 34,7%; heterogeneidade e FE mensais elevam para 56,2%.
- A correlação simples PRP–UIP EM é 51%; VIX–UIP EM é 68%. A correlação entre fatores globais e locais varia: Turquia 2%, Brasil 18%, Chile 47%.
- Um movimento do PRP do 25º ao 75º percentil se associa a alta de cerca de 1 p.p. no prêmio UIP.
- Risco local afeta o prêmio sobretudo pelo diferencial de juros; risco global atua nos dois componentes. Maior risco local se associa a depreciação esperada, enquanto maior VIX vem junto a apreciação futura esperada após valorização do dólar no impacto.
- Fama e Fama-like para EM produzem coeficientes positivos próximos de 0,4–0,5, implicando que aproximadamente metade do diferencial de juros reflete prêmio prospectivo e metade depreciação esperada/realizada.
- Diferenciais de juros não predizem erros de previsão nas EM (`−0,106`, EP `0,144`), mas predizem nas AE (`−1,619`, EP `0,549`); isso apoia interpretar o wedge EM como compensação por risco, não erro sistemático de expectativas.
- Choques locais de política são seguidos por expectativas persistentes de depreciação em EM por até 12 meses.
- Resultados não são explicados apenas por inflação, default soberano ou CIP; o prêmio UIP EM é uma ordem de grandeza maior que desvios CIP.

## 7. Contribuições

O artigo oferece o referencial mais diretamente aplicável para interpretar o wedge de UIP no Brasil. Ele mostra que não se deve tratar o prêmio cambial de emergentes como mera versão ampliada do prêmio em avançados: nas EM, risco doméstico e diferencial de juros são centrais. Para a narrativa do paper brasileiro, isso permite organizar a resposta conjunta de câmbio, curva de juros e risco soberano em torno de um prêmio cambial prospectivo variável, além de justificar por que risco global (VIX/Fed) e risco local podem coexistir sem serem o mesmo fator. O dado específico de correlação global–local de 18% no Brasil reforça a necessidade de separar os dois componentes.

## 8. Viabilidade de replicação

Moderada. O apêndice de dados é detalhado e informa fontes, amostras, interpolação, lista de palavras e jornais. IFS/IMF e algumas séries são acessíveis, mas Consensus Economics, Bloomberg, ICRG e Factiva são proprietários, o que impede replicação integral sem licenças. O draft de agosto de 2026 não indica repositório público de código ou pacote de replicação. A construção do PRP pode ser reproduzida metodologicamente com acesso ao Factiva, mas decisões de busca e vintage são relevantes.

## Passagens citáveis e uso narrativo

- “the premium is an *interest-rate-differential* object” — Seção 1, página marcada em torno de `page-2`, linha 44 do markdown-fonte. **Evidência descritiva:** pode entrar na interpretação conjunta de câmbio e curva brasileira, explicando por que o wedge UIP de EM se manifesta fortemente nos juros.
- “local risk tied to domestic policy uncertainty” — Seção 1, linha 44. **Evidência descritiva:** fundamenta incluir risco de política doméstica como componente potencial da transmissão, sem confundi-lo com o choque monetário identificado.
- “Local risk factors in emerging markets explain 26% of the variation” — Seção 1, página marcada em torno de `page-5`, linha 95. **Magnitude:** dá escala à relevância de fatores locais em relação ao VIX/global (12%).
- “Brazil has 18%” — nota 10, marcador `page-6-0`, linha 99. **Conexão direta com Brasil:** documenta correlação relativamente baixa, embora não nula, entre fatores globais e locais; apoia tratá-los separadamente.
- “interest rate differentials do not predict forecast errors in emerging markets” — nota 17, marcador `page-22-0`, linha 379. **Disciplina conceitual:** apoia ler a parcela não explicada pela depreciação esperada como compensação por risco, e não simplesmente erro previsional sistemático.
- “policy shocks are followed by persistent expected depreciation over a 12-month horizon” — Seção 6, marcador `page-39-0`, linha 789. **Compatibilidade dinâmica:** pode entrar ao discutir persistência do câmbio/curva após choques; não estabelece que um choque Selic específico tenha esse canal.
- “rather than the identification of a single causal mechanism” — Seção 1, marcador `page-1-0`, linha 27. **Limite explícito:** deve acompanhar qualquer uso causal da evidência.
- “*consistent with*, rather than dispositive of” — Seção 1, marcador `page-1-0`, linha 27. **Linguagem recomendada:** oferece exatamente o grau de cautela apropriado para conectar os fatos do artigo às IRFs brasileiras.

### Julgamento de uso no artigo brasileiro

É um referencial teórico-empírico muito forte para fortalecer a narrativa de câmbio/UIP e é o único dos três com evidência explícita para o Brasil na amostra. O encaixe mais defensável é na discussão do mecanismo e na agenda de decomposição do wedge: risco global, risco local, diferencial de juros e depreciação esperada devem ser distinguidos. Como o draft declara que mede regularidades condicionais, ele não valida a proxy monetária brasileira, não identifica o sinal causal política → PRP → câmbio e não autoriza chamar respostas de CDS/EMBI de canal UIP. O uso correto é “compatível com” e “oferece momentos/modelos disciplinadores”.

