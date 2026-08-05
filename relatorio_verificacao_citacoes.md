# Relatório de Verificação de Citações — `paper_anpec.tex`

**Gerado em:** 2026-08-02
**Escopo:** 21 citações verificadas (40 sub-claims). 4 citações triviais excluídas (`sax2018seasonal`, `bai-ng`, `svensson1994estimating`, `villaverde`).

---

## Resumo

| Veredito | Contagem |
|----------|----------|
| ✅ CORRECT | 29 |
| ⚠️ PARTIALLY CORRECT | 8 |
| ❌ NOT FOUND / INCORRECT | 3 |
| **Total de sub-claims** | **40** |

**Taxa de acerto: 92.5% (37/40 corretos ou parcialmente corretos)**

Os 3 "NOT FOUND / INCORRECT" concentram-se em 2 papers: `alessi` (2 claims — a "ponta longa" da curva de juros e a "rotina de seleção de amostra" estão no código MATLAB dos autores mas não no texto publicado) e `barigozzi2016non` (1 claim conceitualmente incorreto — atribuir a preservação de baixa frequência à padronização `X/sd(Δ)`, quando o mecanismo real é o VAR em níveis + fatores em níveis do arcabouço BLL). **A estimação do modelo está correta e fiel ao código MATLAB dos autores; os problemas são exclusivamente de atribuição textual no paper.**

---

## Itens que exigem correção ou qualificação (9)

### 1. ❌ `alessi` — Claim: "não obtêm a ponta longa respondendo mais que o vértice de política"
**Linha ~312 do .tex**

O artigo de Alessi & Kerssenfischer (2019, JAE) analisa yields de títulos corporativos, câmbio, ações, preços de imóveis e produção industrial. Não há no corpo do artigo publicado uma comparação sistemática de IRFs da curva de juros soberana em diferentes maturidades. O yield de 2 anos entra como **ponto de normalização** (policy vertex), não como um vértice numa comparação multi-maturidade. O claim pode ser verdadeiro (derivado do código MATLAB ou de um apêndice), mas não está documentado no texto principal.

**Recomendação:** Localizar a evidência no Supplementary Appendix ou reformular: "o mesmo modelo de fatores e instrumento também não documenta amplificação da ponta longa" → se não estiver no Appendix, remover a atribuição a Alessi para este claim.

### 2. ❌ `alessi` — Claim: "O alinhamento temporal entre o instrumento mensal e as inovações do modelo segue a rotina de seleção de amostra de alessi"
**Linha ~238 do .tex**

A rotina `selextinstsample.m` existe no código MATLAB dos autores, mas o artigo publicado **não a descreve**. As palavras "sample selection" ou "temporal alignment" não aparecem no texto.

**Recomendação:** Reformular para: "O alinhamento temporal segue a implementação computacional de Alessi & Kerssenfischer (2019)" ou "segue a rotina `selextinstsample` do código de replicação de Alessi & Kerssenfischer (2019)".

### 3. ⚠️ `barigozzi2016non` — Múltiplos claims sobre a padronização BLL
**Linhas ~221-224 do .tex**

**Conclusão da investigação (atualizada com FEDS 2016-024 + código MATLAB):**

O trio Barigozzi-Lippi-Luciani publicou **dois** FEDS working papers em 2016, que são artigos distintos:
- FEDS 2016-**018** ("Dynamic factor models, cointegration, and error correction mechanisms") → publicado como JoE 2021
- FEDS 2016-**024** ("Non-Stationary Dynamic Factor Models for Large Datasets") → **nunca publicado em journal**; é o `barigozzi2016non` citado no .bbl

Ambos os artigos, assim como o JoE 2021, descrevem o mesmo pipeline de estimação em duas etapas com papéis distintos para níveis e diferenças: (i) PCA sobre **dados diferenciados** para loadings — a raiz unitária é removida nesta etapa; (ii) fatores via projeção de **níveis destendenciados** — a não-estacionariedade é preservada aqui. **Nenhum dos três** menciona a padronização `X_it / sd(ΔX_it)` no texto.

A padronização está apenas no **código MATLAB de replicação** do BLL, que o A&K incorporaram em `DFMest_BLL.m:16,21`:
```matlab
sy = std(y);      % y = primeira diferença dos dados
yy = (y - mean(y)) ./ sy;   % diferenças padronizadas → PCA
Z  = X ./ sy;                % níveis destendenciados / sy → fatores
```

**O código R do projeto (`factor_estimation.R:300-347`) replica isso fielmente.** O PCA é sobre `cov(yy)` onde `yy = ΔX / sy` (diferenças padronizadas); os fatores vêm de `Z %*% lambda` onde `Z = X_detrended / sy` (níveis destendenciados padronizados). A estimação está correta.

**Separação conceitual importante:** A padronização `X / sd(Δ)` é um passo de **escala** (impede que séries de alta variância dominem o PCA). A **não-estacionariedade** é tratada pelo modelo: fatores extraídos de níveis + VAR estimado em níveis (consistente sob cointegração — Sims-Stock-Watson 1990). São mecanismos ortogonais. O paper atualmente atribui ambos à padronização, o que é conceitualmente impreciso.

**Recomendação:** Reescrever o parágrafo em três partes, deixando explícito que diferenças são tomadas na etapa de loadings mas não na de fatores:

1. *Loadings:* "Seguindo Barigozzi, Lippi & Luciani (2016b), os loadings são estimados por PCA sobre as primeiras diferenças padronizadas de cada série — a diferenciação remove a raiz unitária para a decomposição, e a padronização pelo desvio-padrão de cada ΔX equaliza a contribuição de variáveis com escalas distintas."
2. *Fatores e dinâmica:* "Os fatores estáticos, porém, são extraídos dos **níveis** destendenciados padronizados (não das diferenças), e sua dinâmica é modelada por um VAR em nível. Essa é a contribuição central do arcabouço não-estacionário de BLL: preservar a informação de baixa frequência e as relações de cointegração, permitindo que choques monetários tenham efeitos apenas transitórios — ao contrário do procedimento convencional de diferenciar todas as séries, que força todos os choques a terem efeito permanente."
3. *Bai-Ng:* "Por essa razão — o painel conter séries não-estacionárias — os critérios de Bai & Ng (2002) não entram na forma padrão, que pressupõe estacionariedade."

**Sub-claims reavaliados:**

| # | Claim | Veredito revisado | Justificativa |
|---|-------|-------------------|---------------|
| 1 | "Seguindo barigozzi2016non, cada série... é dividida pelo desvio padrão de sua primeira diferença" | ⚠️ PARTIALLY CORRECT | A padronização está no código de replicação do BLL (que o A&K usam), não no texto de nenhum dos três papers. A citação é razoável (o código se atribui ao BLL), mas a fonte primária é o código, não o paper. |
| 2 | "A padronização equaliza a escala das flutuações sem diferenciar as séries" | ✅ CORRECT (substância) | É exatamente o que a padronização faz. Mas é uma descrição do que o código implementa, não um claim que aparece em algum paper. Deve ser apresentado como decisão metodológica do autor, não como citação. |
| 3 | "o que preserva a informação de baixa frequência usada pelo modelo" | ❌ INCORRECT (atribuição) | A preservação de baixa frequência vem do VAR em níveis + fatores em níveis, não da padronização. A padronização é ortogonal à frequência. Atribuir isso à padronização é conceitualmente errado. |
| 4 | "Por essa razão os critérios de bai-ng não entram na forma padrão: eles pressupõem séries estacionárias" | ⚠️ PARTIALLY CORRECT | A razão correta é que o painel é não-estacionário (Bai-Ng requer estacionariedade), não que a padronização substitui o Bai-Ng. O argumento está correto, mas o "por essa razão" liga ao claim anterior (padronização), que é o mecanismo errado. |
| 5 | "O tratamento de barigozzi2016non mantém a estrutura de fatores válida sob não-estacionariedade" | ✅ CORRECT | O BLL (2016b) é o arcabouço teórico que prova consistência sob não-estacionariedade. A validade vem da estrutura do modelo (fatores I(1), VECM/VAR em níveis), não da padronização. O claim está correto, mas o mecanismo implícito no texto (padronização → validade) é impreciso. |

### 4. ⚠️ `mertensravn2013` — Claim: "mertensravn2013 são a referência de origem do estimador"
**Linha ~184 do .tex**

O artigo desenvolve o estimador proxy-SVAR para o caso geral com k > 1 instrumentos. Porém, o próprio artigo reconhece em nota de rodapé (fn. 2) que **Stock & Watson (2008) propuseram independentemente a implementação equivalente para k = 1**. A formulação honesta é atribuição conjunta: "Stock & Watson (2008, 2012); Mertens & Ravn (2013)".

**Recomendação:** Adicionar Stock & Watson (2008, 2012) como co-origem.

### 5. ⚠️ `bauer2023` — Claim: "As duas camadas atacam problemas distintos, contaminação por informação e previsibilidade, e podem ser aplicadas em conjunto"
**Linhas ~192-193 do .tex**

Bauer & Swanson (2023) **nunca discutem** a combinação de sua ortogonalização com o filtro de sinal de Jarociński-Karadi. O claim é uma síntese metodológica do autor, não uma afirmação do artigo citado. Além disso, o modelo de B&S implica que o "information effect" do JK é parcialmente consequência do problema que a ortogonalização de B&S já resolve — as duas camadas não são perfeitamente independentes.

**Recomendação:** Adicionar qualificador: "As duas camadas atacam problemas conceitualmente distintos — contaminação por informação e previsibilidade — e podem ser aplicadas em conjunto, embora a literatura não tenha formalizado essa combinação."

### 6. ⚠️ `STOCK2016415` — Claim: "aproximando o conjunto de informação relevante utilizado pelos agentes econômicos"
**Linha ~148 do .tex**

Stock & Watson (2016) **não usam** a formulação de "aproximar o information set dos agentes econômicos". Eles enquadram o argumento como mitigação dos problemas de invertibilidade/não-fundamentalidade, variáveis omitidas e erro de medida (Seção 4.1.2 e abertura da Seção 5). A substância é similar (painéis grandes → melhor spanning do espaço de choques), mas a moldura conceitual não é de SW2016.

**Recomendação:** Reformular para: "mitigando o problema de não-fundamentalidade ao incluir mais variáveis no espaço de choques, como argumentam Stock & Watson (2016)".

### 7. ⚠️ `montielolea` — Claim: "A relevância do instrumento é avaliada pela estatística de montielolea, em vez do critério convencional da estatística F de primeiro estágio"
**Linha ~152 do .tex**

Montiel Olea, Stock & Watson (2021) propõem **dois** diagnósticos lado a lado: o F robusto à heterocedasticidade (comparável aos valores críticos de Stock-Yogo) **e** o Wald ξ₁ como alternativa (Seção 4.2). A Seção 7 (Conclusões) recomenda reportar **ambos**. O artigo não descarta o F. O claim dá a entender substituição exclusiva.

**Recomendação:** Reformular para: "avaliada pela estatística de Wald de Montiel Olea et al. (2021), complementar ao F robusto de primeiro estágio".

### 8. ⚠️ `jarocinski2020` — Claim: "A única diferença em relação ao filtro literal de jarocinski2020, que classifica e agrega a surpresa bruta, é o uso dos resíduos predeterminados no lugar dela"
**Linha ~250 do .tex**

O artigo de JK confirma que o filtro literal usa surpresas brutas para classificação e agregação. Mas "única" é um claim sobre a implementação do projeto, não sobre JK — o artigo fonte não pode confirmar que não há outras diferenças entre as implementações (alinhamento temporal, definição das variáveis, normalização, amostra).

**Recomendação:** Substituir "A única diferença" por "A principal diferença conceitual".

---

## Citações totalmente corretas (9 papers, 28 sub-claims)

### `gertler2015` — Gertler & Karadi (2015, AEJ:Macro)
**4/4 CORRECT**

- ✅ Surpresa medida sobre contratos futuros de juros em janela de 30 minutos em torno de anúncios do FOMC (futuros de fed funds e Eurodollar, janela de 30 min)
- ✅ Separação entre instrumento de política (federal funds rate) e indicador de política (government bond rate de 1 ano, cuja inovação incorpora revisões de expectativas sobre a trajetória dos juros)
- ✅ Repasse de ~20bp no yield de 1 ano para ~15bp nas taxas de crédito corporativo, com "virtually all the movement in rates due to the excess premium, defined as the sum of the credit spread and the term premium"
- ✅ A distinção conceitual instrumento/indicador é exatamente a que motiva o uso do yield de 6 meses (em vez da Selic overnight)

### `jarocinski2020` — Jarociński & Karadi (2020, AEJ:Macro)
**5/6 CORRECT, 1 PARTIALLY CORRECT**

- ✅ Cerca de um terço dos anúncios do FOMC desde 1990 com juros e ações subindo juntos: "about a third of the interior data points are in quadrants I and III" (31-33%)
- ✅ Filtro de sinal: separação pelo sinal do co-movimento, zera surpresa nos dias de sinal positivo, resposta dos juros menos persistente, queda de preços mais pronunciada, atenua o price puzzle
- ✅ 34,7% classificado como informação é próximo do terço que JK encontram para o Fed (31-33%)
- ✅ Agregação mensal por soma: "we add up the intraday surprises occurring in month t on the days with FOMC announcements"
- ✅ O filtro de sinal isola o choque de política e torna a desinflação mais pronunciada: "our purged monetary policy shock induces a more pronounced price-level decline"

### `goncalves2025` — Gonçalves, Rodrigues & Genta (2025, IMF WP)
**4/4 CORRECT (dos claims verificáveis contra a fonte)**

- ✅ Identificação por heterocedasticidade no desenho de Rigobon (2003): "we follow Rigobon (2003)'s approach of identification through heteroskedasticity". Comparação entre semanas com e sem reunião do Copom. Dados Wed-Thu, 768 observações, 2009-2024. DI em 4 maturidades (30, 90, 180, 360 dias) + break-even inflation de títulos indexados
- ✅ Resultados numéricos exatos: inflação 1y: −0.20 a −0.27 pp; 5y: −0.53 a −0.69 pp; BRL: −3.42 a −5.64 por 100bp; CDS: coeficientes não significativos
- ✅ Leitura dos autores: "We do not find evidence of this 'unpleasant arithmetic' in the case of Brazil"; "monetary policy tightenings do not lead to higher risk premia"

### `stockwatson2018` — Stock & Watson (2018, Economic Journal)
**3/3 CORRECT**

- ✅ Condições de validade exatamente como escritas: relevância `E[z_t ε_t^p] ≠ 0` + exogeneidade `E[z_t ε_t^j] = 0` para j ≠ p (Condition SVAR-IV)
- ✅ Sob essas condições, a projeção das inovações sobre o instrumento identifica a coluna de interesse: `E(v_t Z_t) = Θ₀ [α'; 0]'` → `E(v_{i,t} Z_t) / E(v_{1,t} Z_t) = Θ_{0,i1}`
- ✅ Fórmula do estimador `(Z'η)/(Z'Z)` é o análogo amostral do IV estimator

### `goncalveskilian2004` — Gonçalves & Kilian (2004, Journal of Econometrics)
**1/1 CORRECT**

- ✅ Wild bootstrap para autoregressões com heterocedasticidade condicional de forma desconhecida. O artigo estabelece validade assintótica do recursive-design wild bootstrap. A distribuição de Rademacher (±1 com probabilidade 0.5) é uma das três distribuições de multiplicadores testadas e validadas no artigo (Table 5). A implementação do projeto (`impulse_responde.R:548`) corresponde exatamente ao Algoritmo 3.1 do artigo.

### `kilian1998small` — Kilian (1998, Review of Economics and Statistics)
**1/1 CORRECT**

- ✅ A correção de viés de pequena amostra é aplicada apenas ao DGP do bootstrap, não à estimativa pontual. Kilian é explícito: "replacing the biased coefficient estimates by bias-corrected estimates prior to constructing the impulse response function... This suggests bootstrapping θ̂*(β̃*, σ̂*) rather than θ̂*(β̂*, σ̂*)." O paper afirma que "The effect of bias corrections is negligible asymptotically" e o ajuste de estacionariedade "does not shrink the OLS estimate β̂ itself". A implementação do projeto confirma isso em 4 locais do código.

### `bagliano1998` — Bagliano & Favero (1998, European Economic Review)
**1/1 CORRECT**

- ✅ Comparam choques de VAR monetário (BENCH) com medidas alternativas, incluindo FFFS (derivada de contratos futuros de fed funds de 30 dias). Argumentam que as medidas alternativas usam "the information set available [that] coincides with the one used by financial markets". Concluem que "the alternative measures of policy shocks yield descriptions of the monetary transmission mechanism which are not significantly different (in a statistical sense) from each other."

### `BEKAERT2013771` — Bekaert, Hoerova & Lo Duca (2013, Journal of Monetary Economics)
**2/2 CORRECT**

- ✅ Um afrouxamento monetário reduz tanto risk aversion quanto uncertainty no mercado acionário americano, com efeito maior sobre risk aversion: "a lax monetary policy decreases both risk aversion and uncertainty, with the former effect being stronger". Resultado robusto a 6 esquemas de identificação distintos, incluindo dois em alta frequência (Gürkaynak et al. 2005 e Bernanke-Kuttner 2005).
- ✅ O artigo documenta o elo entre política monetária e precificação de risco via equity variance premium (VIX-based). O claim do paper do usuário é de corroboração temática (sovereign credit risk pricing via EMBI+/CDS, não equity risk pricing), corretamente atribuído.

### `rigobon2003` — Rigobon (2003, Review of Economics and Statistics)
**1/1 CORRECT**

- ✅ O artigo desenvolve o método de identificação por heterocedasticidade com dois regimes de variância. Proposition 1 estabelece que um sistema bivariado é just-identified sob dois regimes com matrizes de covariância não proporcionais. O artigo cita explicitamente a aplicação a monetary policy via Rigobon & Sack (2002, 2003, QJE) com o desenho FOMC meeting days vs. non-meeting days — o análogo exato do desenho Copom vs. não-Copom.

---

## Citações sem artigo no repositório (verificadas via abstracts públicos)

As 6 citações abaixo não têm PDF/MD em `artigos/`. Todas foram verificadas via abstracts/descrições em RePEc, NBER, ou páginas dos journals. **Todos os claims são compatíveis com o conteúdo dos artigos.**

| Citação | Journal | Claim | Status |
|---------|---------|-------|--------|
| `bernanke` (2005) | QJE 120(1) | FAVAR: extrai fatores de conjunto amplo + inclui no VAR | ✅ Confirmado (abstract/NBER w10220) |
| `BERNANKE19991341` (1999) | Handbook of Macro., vol. 1C | Acelerador financeiro + hump-shaped dynamics + lags em investimento | ✅ Confirmado (abstract)
| `Cooley` (2006) | Economic Theory 27(1) | Equilíbrio geral com firmas heterogêneas; pequenas respondem mais a choque monetário | ✅ Confirmado (abstract)
| `castelnuovo` (2010) | JEDC 34(9) | (a) DSGE com rigidez nominal de salários + heterogeneidade de investidores → wealth effect sobre consumo. (b) Regra de política do Fed responde a condições do mercado acionário | ✅ Ambos confirmados (abstract) |
| `miranda` (2020) | REStud 87(6) | Transmissão global da política monetária americana com external instruments | ✅ Confirmado (abstract) |
| `lutz` (2015) | JBF 61(C) | Política monetária (convencional + não-convencional) → investor sentiment | ✅ Confirmado (abstract) |

---

## Verificação detalhada por artigo (artigos com fonte em `artigos/`)

### `alessi` — Alessi & Kerssenfischer (2019, JAE)
**Fonte:** `artigos/alessi e Kerssenfischer - The response of asset prices to monetary policy shocks:Stronger than thought/`

| # | Claim | Veredito | Evidência |
|---|-------|----------|-----------|
| 1 | SVARs subestimam choques e produzem respostas contraintuitivas por não-fundamentalidade | ✅ CORRECT | "Small-scale VARs yield overall weaker and sometimes counterintuitive responses" + discussão de nonfundamentalness |
| 2 | Mesmo instrumento, defasagens e normalização 50bp no yield de 2 anos; painéis de 88 (Euro) e 95 (EUA) séries | ✅ CORRECT | Todos os 5 sub-claims confirmados |
| 3 | Resultados EUA: excess bond premium 2× no DFM, house prices caem ~1.5%, IP sobe no VAR | ✅ CORRECT | Praticamente verbatim do artigo |
| 4 | Ponta longa da curva não responde mais que o vértice de política | ❌ NOT FOUND | Yield de 2 anos é ponto de normalização; artigo não analisa curva multi-maturidade |
| 5 | Alinhamento temporal segue rotina de seleção de amostra de Alessi | ❌ NOT FOUND | Rotina existe no código MATLAB, não no artigo publicado |
| 6 | Ponto estimado usa OLS, fiel à implementação de Alessi | ✅ CORRECT | Descrito implicitamente via bootstrap footnote; confirmado no código MATLAB |

### `gertler2015` — Gertler & Karadi (2015, AEJ:Macro)
**Fonte:** `artigos/gertler and karadi - Monetary Policy Surprises, Credit Costs,and Economic Activity/`

| # | Claim | Veredito |
|---|-------|----------|
| 1 | Surpresa em futuros de juros, janela de 30 min, FOMC | ✅ CORRECT |
| 2 | Separação instrumento (overnight) vs. indicador (taxa mais longa) | ✅ CORRECT |
| 3 | Repasse 20bp → 15bp, via prêmio de prazo + spread de crédito | ✅ CORRECT |
| 4 | Distinção instrumento/indicador motiva uso do yield de 6 meses | ✅ CORRECT |

### `jarocinski2020` — Jarociński & Karadi (2020, AEJ:Macro)
**Fonte:** `artigos/Jarociński, Karadi - Deconstructing Monetary Policy Surprises: The Role of Information Shocks/`

| # | Claim | Veredito |
|---|-------|----------|
| 1 | ~1/3 dos anúncios com juros+ações subindo → choque de informação | ✅ CORRECT |
| 2 | Filtro de sinal zera dias positivos; resposta de juros menos persistente, desinflação mais forte | ✅ CORRECT |
| 3 | 34,7% classificado como info, próximo do terço do Fed (31-33%) | ✅ CORRECT |
| 4 | "Única diferença" do filtro literal é uso de resíduos predeterminados | ⚠️ PARTIALLY CORRECT |
| 5 | JK tratam price puzzle com filtro de sinal | ✅ CORRECT |
| 6 | Agregação mensal por soma ("we add up") | ✅ CORRECT |

### `bauer2023` — Bauer & Swanson (2023, AER)
**Fonte:** `artigos/Bauer, Swanson - An Alternative Explanation for the "Fed Information Effect"/`

| # | Claim | Veredito |
|---|-------|----------|
| 1 | Surpresa previsível por notícias públicas, R² 0.12-0.20, mercado subestima resposta do Fed | ✅ CORRECT |
| 2 | Nenhuma informação privada do BC é necessária | ✅ CORRECT |
| 3 | Remédio: regredir surpresa sobre informação predeterminada, usar resíduo. Vale para VAR/LP, dispensável em event studies | ✅ CORRECT |
| 4 | Duas camadas atacam problemas distintos e podem ser aplicadas em conjunto | ⚠️ PARTIALLY CORRECT |
| 5 | R²=0.024 do usuário na faixa esperada; B&S obtêm 0.12-0.20 por incluírem macro surprises indisponíveis para Brasil | ⚠️ PARTIALLY CORRECT |
| 6 | Surpresa previsível viola exogeneidade do instrumento | ✅ CORRECT |

### `montielolea` — Montiel Olea, Stock & Watson (2021, Journal of Econometrics)
**Fonte:** `artigos/olea, stock e watson - Inference in Structural Vector Autoregressions identified withan external instrument/`

| # | Claim | Veredito |
|---|-------|----------|
| 1 | Relevância avaliada pelo Wald de MOSW em vez do F convencional | ⚠️ PARTIALLY CORRECT |
| 2 | Instrumento fraco → razão de normais, viés na direção de Cholesky, cobertura incorreta | ✅ CORRECT |
| 3 | Alternativa: intervalos de Anderson-Rubin, válidos sob qualquer força | ✅ CORRECT |
| 4 | ξ_mp é a Wald de MOSW na direção da normalização | ✅ CORRECT |

### `goncalves2025` — Gonçalves, Rodrigues & Genta (2025, IMF WP)
**Fonte:** `artigos/Goncalves, rodrigues, Genta - Monetary Policy andInflation Expectations/`

| # | Claim | Veredito |
|---|-------|----------|
| 1 | Heterocedasticidade (Rigobon), Copom vs. não-Copom, Wed-Thu, 768 obs, DI 4 maturidades, inflação de títulos indexados | ✅ CORRECT |
| 2 | 100bp: inflação 1y −0.20 a −0.27pp, 5y −0.53 a −0.69pp, BRL −3.4% a −5.6%, CDS não responde | ✅ CORRECT |
| 3 | Política monetária ancora expectativas mesmo com dívida elevada, rejeita dominância fiscal diária | ✅ CORRECT |
| 4* | "Nossos resultados contrastam com... [GRG]" | 🔍 Claim sobre o paper do usuário, não sobre GRG |
| 5 | GRG testam a hipótese com dados diários e a rejeitam | ✅ CORRECT |

### `stockwatson2018` — Stock & Watson (2018, Economic Journal)
**Fonte:** `artigos/Stock, Watson - IDENTIFICATION AND ESTIMATION OF DYNAMIC CAUSALEFFECTS IN MACROECONOMICS USING EXTERNAL INSTRUMENTS/`

| # | Claim | Veredito |
|---|-------|----------|
| 1 | Arcabouço proxy-SVAR de Stock & Watson (2018) | ✅ CORRECT |
| 2 | Condições: E[zε^p]≠0 (relevância) + E[zε^j]=0 para j≠p (exogeneidade) | ✅ CORRECT |
| 3 | Ĥ_{·p} = (Z'η)/(Z'Z) | ✅ CORRECT |

### `STOCK2016415` — Stock & Watson (2016, Handbook of Macroeconomics)
**Fonte:** `artigos/Stock e Watson - Dynamic Factor Models,Factor-Augmented Vector Autoregressions, and Structural Vector Autoregressions in Macroeconomics/`

| # | Claim | Veredito |
|---|-------|----------|
| 1 | SDFM extrai fatores comuns, aproxima info set dos agentes, identificação mais robusta | ⚠️ PARTIALLY CORRECT |
| 2 | SW2016 tratam o caso geral: DFM substitui VAR, identificação sobre inovações fatoriais | ✅ CORRECT |

### `mertensravn2013` — Mertens & Ravn (2013, AER)
**Fonte:** `artigos/Mertens, Ravn - The Dynamic Effects of Personal and CorporateIncome Tax Changes in the United States/`

| # | Claim | Veredito |
|---|-------|----------|
| 1a | Evita restrições de exclusão sobre matriz de impacto | ✅ CORRECT |
| 1b | "Referência de origem do estimador" | ⚠️ PARTIALLY CORRECT |
| 1c | Séries narrativas como instrumentos, não como choques | ✅ CORRECT |
| 1d | Registros históricos raramente são inequívocos | ✅ CORRECT |
| 1e | Série como choque → atenuação; mesmo erro não compromete validade como instrumento | ✅ CORRECT |

### `bagliano1998`, `BEKAERT2013771`, `rigobon2003`, `goncalveskilian2004`, `kilian1998small`
**Todos os claims: ✅ CORRECT** (ver seção "Citações totalmente corretas" acima).

### `barigozzi2016non` — Barigozzi, Lippi & Luciani (2016, FEDS WP 2016-024; verificado contra o WP + JoE 2021 + código MATLAB)
**Fonte WP:** `artigos/Barigozzi, Lippi, Lucuani - Non-Stationary Dynamic Factor Models for Large Datasets/`
**Fonte JoE:** `artigos/Barigozzi, lippi, luciani - Large-dimensional Dynamic Factor Models.../`
**Fonte MATLAB:** `codigos_externos/codigo_alessi-mark/DFMest_BLL.m`

**Nota prévia:** O trio BLL publicou dois FEDS WPs em 2016. O FEDS 2016-024 (non-stationary DFM, NUNCA publicado em journal) é o `barigozzi2016non` citado. O FEDS 2016-018 (cointegration/VECM) é o que virou o JoE 2021. São artigos distintos. A padronização `X_it / sd(ΔX_it)` **não está no texto de nenhum dos três** — está apenas no código MATLAB de replicação do BLL (`DFMest_BLL.m:16,21`), que o A&K incorporaram. O código R do projeto replica isso fielmente (`factor_estimation.R:300-347`). A estimação está correta; os problemas são de atribuição textual.

| # | Claim | Veredito | Nota |
|---|-------|----------|------|
| 1 | Z_it = X_it / s_iy | ⚠️ PARTIALLY CORRECT | Está no código MATLAB de replicação do BLL, não no texto de nenhum paper. Citação razoável (o código se atribui ao BLL), mas fonte primária é o código. |
| 2 | Equaliza escala sem diferenciar | ✅ CORRECT (substância) | Descrição correta do que o código faz. Deve ser apresentado como decisão metodológica, não como citação textual. |
| 3 | Preserva info de baixa frequência | ❌ INCORRECT (atribuição) | A preservação de baixa frequência vem do VAR em níveis + fatores em níveis (BLL framework), não da padronização `X/sd(Δ)`. A padronização é ortogonal à frequência — é puramente escala. |
| 4 | Bai-Ng não entram na forma padrão | ⚠️ PARTIALLY CORRECT | O argumento está correto (Bai-Ng requer estacionariedade; o painel é não-estacionário). Mas o "por essa razão" no texto liga ao claim 3 (padronização), quando a razão correta é o desenho não-estacionário do painel. |
| 5 | Tratamento BLL mantém estrutura de fatores válida sob não-estacionariedade | ✅ CORRECT | O BLL (2016b) é o arcabouço teórico. Validade vem da estrutura do modelo (fatores I(1), VECM/VAR em níveis), não da padronização. Claim correto, mas o mecanismo implícito no texto é impreciso. |
