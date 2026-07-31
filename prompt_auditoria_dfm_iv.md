# Prompt — Auditoria do DFM-IV (v2)

> Substitui a versão anterior. Reordenado por poder de decisão: a Tarefa 1
> decide se o resto do trabalho vale o esforço.

---

## Contexto

Este repositório estima um Dynamic Factor Model para a economia brasileira com
identificação de choque de política monetária por instrumento externo
(proxy SVAR / SVAR-IV).

Especificação atual: `r=7` fatores estáticos, `q=6` choques dinâmicos,
instrumento `z_jk_bs_purif`, normalização de +50bp sobre `yield_6m`,
`nboot=800`, bandas de 68% e 90%, horizonte 48.

Já existe uma tabela de IRFs (`output/irf/irf_coherence_h.csv`) ponto a ponto com flags de significância
(`var, h, point, lo68, hi68, lo90, hi90, sign, sig68, sig90`). A leitura dela
produziu o diagnóstico abaixo, que é o ponto de partida desta auditoria.

### O que está estabelecido nos resultados atuais

**Significativo a 90%, concentrado em h=0 a h≈8:**

- Curva inteira sobe no impacto: `yield_3m` +0,0028; `yield_1y` +0,0074;
  `yield_2y` +0,0092; `yield_5y` +0,0093; `yield_10y` +0,0081 — todas sig90 em h=0.
- `cambio_usd` +0,150 (sig90 h=0–4); `embi_perc` +0,200 (sig90 h=0–1);
  `cds_5y` +2907 (sig90 h=0–4).
- `price_ipp` +0,586 → pico +0,881 (sig90 h=0–4); `price_igp_m` (sig90 h=1–4);
  `price_core_ipca_ex0` pico +0,131 em h=5 (sig90 em h=2,4,5,6,7,8; nunca troca de sinal).
- Bloco industrial cai: `ind_transformacao`, `ind_bens_duraveis`,
  `ind_bens_capital`, `vendas_varejo`, `trab_hrs_trabalhadas_industria` —
  todos negativos no impacto, sig68, alguns sig90.

**Não significativo — não tratar como resultado:**

- `pib`: pico −0,561 em h=35, **n90 = 0**, n68 = 13.
- `ibc_br`: pico −0,500 em h=11, **n90 = 0**, n68 = 1 (só h=0).
- `juros_selic` e `juros_cdi`: sobem a +0,13 em h≈7, viram negativos após h≈12,
  pico −0,778 em h=34. **n90 = 0** para ambos.
- Todos os 8 índices de ações: **n90 = 0** em todos os horizontes.

**Anomalias já identificadas, a serem confirmadas ou refutadas por esta auditoria:**

1. **Descompasso de unidade no bloco de juros.** As maturidades da curva
   respondem na casa de 0,003–0,009; `juros_selic` tem pico de 0,13 e
   `juros_cdi` idem. Fator de ~15 entre os dois blocos. Suspeita: um está em
   decimal e o outro em ponto percentual, ou o reescalonamento não é uniforme.
2. **`yield_6m` não aparece na tabela de saída.** É a variável de normalização
   e é impossível verificar se o +50bp é de fato entregue.
3. **`juros_cdi` e `juros_selic` são quase idênticos**: correlação de 0,999999
   entre os caminhos de IRF, diferença absoluta máxima de 0,001. Suspeita de
   série duplicada no painel.
4. **`commodity_metal` falha o placebo**: +10,41 no impacto, sig90 em h=0–4 e
   sig68 até h=45 — **exatamente a mesma janela** em que câmbio, EMBI, CDS e IPP
   são significativos. `msci` passa limpo (n68 = n90 = 0); `epu_us` e
   `sp500_vix` são marginais.
5. **IRFs de ativos com forma corcovada**, atingindo pico em h=24–37 e bandas de
   90% que alargam entre 8x e 14,5x de h=0 para h=36. Preço de ativo não deveria
   ter corcova de 2–3 anos. Suspeita de raiz próxima de 1 na dinâmica dos fatores.
6. **Incoerência de seção cruzada no bloco de ativos**: `asset_imob` (+18,3 em
   h=48) e `asset_ifix` (−33,3, único que nunca cruza zero) têm sinais opostos,
   apesar de ambos serem ativos domésticos de alta sensibilidade a juros.
   `asset_imat`, o mais exposto a commodity e câmbio, termina negativo (−18,0)
   com **zero** horizontes significativos.

## Regras de execução

- **Não altere o código de estimação.** Esta é uma rodada de diagnóstico.
  Todos os scripts novos vão em `diagnostics/`.
- Reporte números, não impressões. Toda afirmação qualitativa tem que estar
  ancorada em um valor de tabela.
- Se um teste não for executável por falta de dado ou dependência, diga qual e
  siga adiante em vez de improvisar substituto.
- Rodadas custosas podem usar `nboot=200`; declare isso no relatório.
- Execute as tarefas **na ordem numérica**. Se a Tarefa 1 falhar, pare e me
  avise antes de seguir para as demais.

---

## Tarefa 0 — Mapear o pipeline (pré-requisito, sem execução)

Leia o código e escreva em prosa a cadeia completa do dado bruto ao gráfico:

- Que transformação cada série sofre (log, diferença, taxa de crescimento,
  nada) e em que arquivo/linha isso está codificado.
- Onde ocorre a padronização e onde ocorre a desestandardização de volta às
  unidades originais.
- Em que unidade **cada** série de juros entra no painel: p.p. (10.5 = 10,5%)
  ou decimal (0.105 = 10,5%). Verifique série por série, não assuma consistência.
- Onde o escalonamento de +50bp é aplicado e sobre qual objeto.
- Se há `cumsum` de IRFs, e se ele é aplicado apenas às séries efetivamente
  diferenciadas.

Aponte qualquer ponto em que uma série de juros e uma série real possam estar
recebendo o mesmo tratamento indevidamente.

---

## Tarefa 1 — Exogeneidade do instrumento (DECISIVA)

O placebo que falha (`commodity_metal`) falha na mesma janela h=0–4 em que toda
a cadeia câmbio → risco → preços é significativa. A hipótese concorrente é que
um fator global de commodities/risco está movendo as duas coisas, e não o
choque doméstico. Este teste decide entre as duas leituras.

1. Regrida `z_jk_bs_purif` sobre defasagens 1 a 6 de: VIX, MSCI, índice de
   commodities metálicas, EPU US, e DXY/dólar se disponível. Reporte R²,
   F conjunto e p-valor — global e por regressor.
2. Regrida o instrumento sobre defasagens 1 a 6 dos próprios fatores estimados
   (teste de previsibilidade padrão de Stock-Watson / Mertens-Ravn).
3. Regrida o instrumento sobre suas próprias defasagens. Reporte Ljung-Box.
4. Reporte correlação do instrumento com cada série de placebo, contemporânea
   e em defasagens −6 a +6.
5. Reporte também a correlação **contemporânea** do instrumento com o retorno de
   commodities metálicas e com a variação do câmbio. Se for alta, o instrumento
   está capturando o fator global no próprio período, não só em defasagem.

**Critério de parada:** se houver previsibilidade significativa a 5% em (1) ou
(2), pare e reporte. A identificação não se sustenta e as tarefas seguintes são
prematuras.

---

## Tarefa 2 — Unidades, normalização e sinal

1. Adicione `yield_6m` à tabela de saída de IRFs. Reporte seu valor em h=0.
   Deve ser exatamente **0.50** se as taxas estão em p.p., ou **0.005** se em
   decimal.
2. Produza a tabela `variável | unidade no painel | IRF h=0 | valor esperado`
   para: `yield_6m`, `yield_3m`, `yield_1y`, `yield_2y`, `yield_5y`,
   `yield_10y`, `juros_selic`, `juros_cdi`.
3. Reporte a **correlação contemporânea nos dados brutos** entre essas mesmas
   séries. Se for ~0,95+ nos dados mas as IRFs divergem em ordem de grandeza,
   o erro está no pipeline e não na economia.
4. Rastreie o sinal: liste todo ponto do código com multiplicação por `-1`,
   ordenação de autovetores, ou convenção de sinal de coluna de loadings.
   PCA dá sinal arbitrário — confirme que existe normalização de sinal
   explícita e determinística.

**Saída:** veredito sobre se existe (a) mistura de unidades entre blocos,
(b) inversão de sinal, (c) escalonamento não uniforme.

---

## Tarefa 3 — Composição do painel

1. Confirme se `juros_cdi` e `juros_selic` são séries distintas na fonte.
   Reporte a correlação nos **dados brutos** e a diferença média.
2. Faça a mesma checagem de quase-duplicidade para **todos** os pares do painel.
   Liste todos os pares com correlação bruta acima de 0,98.
3. Reporte quantas séries pertencem a cada grupo (juros, atividade, preços,
   crédito, ativos, externo). Blocos superrepresentados dominam a extração de
   fatores por PCA.
4. Reestime os fatores removendo as duplicatas identificadas e reporte quanto
   as IRFs de `yield_6m`, `juros_selic`, `price_core_ipca_ex0` e `cambio_usd`
   se deslocam.

---

## Tarefa 4 — Inferência robusta a instrumento fraco

O resultado inteiro depende de 4 a 6 horizontes significativos a 90% numa
janela curta. Bandas bootstrap percentil não são válidas sob instrumento fraco.

1. Localize no código como o Wald = 12 é calculado. Confirme se corresponde à
   estatística de Montiel Olea, Stock & Watson (2021) ou a um F de primeiro
   estágio convencional — não são a mesma coisa. Reporte a fórmula usada.
2. Reporte a estatística ao lado dos valores críticos apropriados de MOSW para
   distorção de cobertura de 10%, 15% e 20%, e diga em qual faixa o 12 cai.
3. Implemente conjuntos de confiança de Anderson-Rubin para as IRFs de
   `yield_6m`, `cambio_usd`, `embi_perc`, `cds_5y`, `price_ipp`,
   `price_core_ipca_ex0`, `ind_transformacao` e `asset_ifix`, nos horizontes
   0 a 12.
4. Produza gráfico comparando conjunto AR contra a banda bootstrap de 90% atual,
   para essas séries.

**A pergunta a responder explicitamente:** o conjunto AR cobre zero em h=0–4?
Se cobrir, a cadeia câmbio → risco → preços perde base empírica e a narrativa
de dominância fiscal cai junto.

---

## Tarefa 5 — Dinâmica dos fatores e persistência

1. Calcule os autovalores da matriz companion do VAR dos fatores. Reporte o
   módulo máximo e os cinco maiores.
2. Se houver raiz acima de ~0,97, sinalize: é a explicação mecânica para as
   corcovas em h=24–37 e para as bandas que alargam 8x–14x.
3. Reporte ordem de defasagens escolhida e critério usado.
4. Liste as séries com raiz unitária não rejeitada (ADF e KPSS) que entram em
   nível no painel. Verifique se alguma é diferenciada e depois acumulada duas vezes.
5. Reporte a fração da variância explicada pelo componente comum (R² da projeção
   nos 7 fatores) para **cada** série, e a média por grupo. Destaque
   especificamente `juros_selic`, `juros_cdi`, `yield_6m`, `pib`, `ibc_br`.

**Interpretar:** se o R² comum de `juros_selic` ou `yield_6m` for baixo (< 0,5),
o DFM não captura a taxa de política e a identificação está comprometida na raiz.
Se o R² de `pib` e `ibc_br` for baixo, isso explica a ausência de significância
nesses agregados sem que haja contradição com o bloco industrial.

---

## Tarefa 6 — Bloco de ativos

1. Reestime e reporte as IRFs de ativos **truncadas em h=12**, com bandas.
   É a janela em que os sinais são coerentes (todos negativos no impacto).
2. Para cada índice, reporte a largura da banda de 90% em h=0, h=12, h=24, h=36
   e a razão h36/h0.
3. Adicione ao painel uma série de **juro real / NTN-B** (IMA-B ou taxa da
   NTN-B longa). Sem ela não é possível testar a hipótese de duration para o
   IFIX, que é a única leitura economicamente sólida do bloco.
4. Monte a seção cruzada: para cada um dos 8 índices, tabule a resposta de
   impacto contra características observáveis (participação de receita em dólar,
   duration implícita, beta a juros). Verifique se `asset_imob` e `asset_ifix`
   caem em pontos opostos do ordenamento — se caírem, é evidência de que o sinal
   de longo prazo é ruído.

---

## Tarefa 7 — Dominância fiscal como hipótese testável

A cadeia significativa (câmbio ↑, EMBI ↑, CDS ↑, IPP ↑, núcleo ↑ com atividade
industrial ↓) é compatível com dominância fiscal à la Blanchard (2004). Mas o
efeito reverte de sinal após h≈10, o que argumenta por dependência de estado e
não por característica média da amostra.

1. Construa um indicador de regime: dívida bruta/PIB, nível do EMBI, ou um
   índice de estresse fiscal. Justifique a escolha e o ponto de corte.
2. Estime IRFs dependentes de estado (smooth transition ou local projections com
   interação) para `cambio_usd`, `embi_perc`, `price_ipp`,
   `price_core_ipca_ex0` e `asset_ifnc`.
3. Reporte se a resposta perversa aparece apenas no regime de alto risco.
4. Teste formal de igualdade das IRFs entre regimes nos horizontes 0 a 8.

**Nota discriminante:** `asset_ifnc` (bancos) é o maior positivo do painel.
Sob dominância fiscal, com CDS subindo, bancos carregando título público
deveriam apanhar. Reporte a resposta do IFNC separadamente por regime — é o
teste que separa dominância fiscal de simples beta positivo a juros.

---

## Tarefa 8 — Sensibilidade a (r, q)

1. Recalcule as IRFs de `yield_6m`, `juros_selic`, `cambio_usd`, `price_ipp`,
   `price_core_ipca_ex0` e `ind_transformacao` na grade `r ∈ {4..9}` × `q ∈ {2..6}`.
2. Produza painel de gráficos sobrepostos.
3. Reporte quais combinações produzem sinal coerente no bloco de política
   (`yield_6m` e `juros_selic` subindo juntos no impacto) e quais não.
4. Reporte o que Bai-Ng (IC1/IC2/IC3) e Hallin-Liška sugerem para `r` e `q`
   neste painel, e se a especificação atual (7,6) está entre as recomendadas.

---

## Entrega

Escreva `diagnostics/diagnostico_dfm.md` contendo:

- **Veredito de uma linha por tarefa:** PASSA / FALHA / INCONCLUSIVO.
- As tabelas numéricas pedidas, na íntegra.
- Seção **"Causa raiz mais provável"**: no máximo três hipóteses ordenadas por
  peso de evidência, cada uma com o teste específico que a confirmaria ou
  descartaria.
- Seção **"Correções recomendadas"** em ordem de prioridade, separando
  claramente **bug de código** de **escolha de especificação**.
- Seção **"O que pode ser reportado no paper hoje"**: lista dos resultados que
  sobrevivem à auditoria, com o horizonte e o nível de confiança em que
  sobrevivem.
