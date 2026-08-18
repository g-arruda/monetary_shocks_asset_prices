# Mapa de literatura — política monetária, risco soberano, câmbio e dominância fiscal

> **VINTAGE SUPERADA EM 2026-08-18.** Este mapa foi escrito antes da migração
> para 111 séries em `(r,q,p)=(5,5,6)` e preserva as magnitudes da produção
> anterior. Ele organiza a literatura, mas não é fonte para números ou decisões
> correntes. Consulte `output/irf/irf_section.md`, `registro/pendencias.md` e
> `paper/paper_anpec.tex` antes de reutilizar qualquer afirmação empírica.

## 1. Objetivo deste mapa

Este arquivo organiza a literatura relevante para a narrativa do artigo sobre a resposta do câmbio, do risco soberano e da curva de juros a choques monetários no Brasil.

O fato empírico central atualmente documentado no artigo é:

\[
\text{choque monetário contracionista}
\;\Rightarrow\;
\begin{cases}
\text{depreciação do real}\\
\uparrow \text{EMBI+}\\
\uparrow \text{CDS soberano}\\
\uparrow \text{juros, com resposta crescente até maturidades longas}
\end{cases}
\]

Na versão atual, um choque de 50 pb está associado, no impacto, a depreciação de 5,55% do real, aumento de 32,0 pb do EMBI+ e aumento de 43,4 pb do CDS soberano de cinco anos. O artigo interpreta essa resposta conjunta como compatível com um canal de prêmio de risco que domina o canal convencional da UIP, sem afirmar que o desenho identifica diretamente a origem fiscal desse prêmio.

A revisão de literatura deve, portanto, sustentar quatro elos distintos:

1. **A UIP convencional pode falhar por variação endógena do prêmio de risco.**
2. **Fundamentos fiscais podem afetar o prêmio de risco cambial e o risco soberano.**
3. **Em economias emergentes, risco soberano pode transmitir-se fortemente ao câmbio.**
4. **No Brasil, existe uma literatura clássica em que juros mais altos podem elevar risco e depreciar a moeda, mas ela descreve um regime de dívida muito diferente do período 2013–2025.**

O quarto ponto é crucial para posicionar a contribuição.

---

# 2. Mapa conceitual da literatura

## Bloco A — UIP, política monetária e prêmio de risco

### Benigno, Benigno & Nisticò (2012)
**Risk, Monetary Policy, and the Exchange Rate**  
*NBER Macroeconomics Annual*, 26.

**Status:** publicado.

**Pergunta central:** como risco e política monetária interagem na determinação da taxa de câmbio?

**Mecanismo útil:**

\[
\text{monetary policy}
+
\text{time-varying risk}
\rightarrow
\text{exchange rate}
\]

O trabalho fornece uma ponte conceitual entre a literatura tradicional de política monetária/câmbio e modelos nos quais desvios da UIP refletem compensação por risco.

**Como usar no artigo:**  
Serve para evitar um salto excessivamente brusco de "UIP convencional" para "dominância fiscal". Antes de discutir a origem fiscal do prêmio de risco, é útil estabelecer que a literatura de macro-finanças internacionais já trata o prêmio de risco cambial como variável endógena e potencialmente importante para a resposta do câmbio.

**Peso sugerido:** alto como fundamento conceitual; não é evidência de canal fiscal.

**Referência:**  
https://doi.org/10.1086/663993

---

### Dalgic & Ozhan (2026)
**IMF Working Paper 2026/158**

**Status:** working paper institucional do FMI.

**Mecanismo:** a combinação de passivos em moeda estrangeira e dominant currency pricing pode tornar o prêmio de risco cambial endógeno ao choque e dominar a previsão convencional da UIP.

Esquematicamente:

\[
\text{shock}
\rightarrow
\text{balance-sheet / currency risk}
\rightarrow
\uparrow \text{FX risk premium}
\rightarrow
\text{depreciação}
\]

**Como usar no artigo:**  
É útil como evidência contemporânea de que uma resposta "invertida" do câmbio não exige necessariamente dominância fiscal. Fragilidades estruturais distintas podem produzir o mesmo padrão reduzido.

Isso é importante para manter a interpretação disciplinada:

> O sinal do câmbio e a elevação do risco soberano são compatíveis com um canal fiscal, mas não identificam por si sós dominância fiscal.

**Peso sugerido:** alto para contextualizar a anomalia cambial; médio para sustentar a interpretação fiscal.

---

# 3. Bloco B — fundamentos fiscais e currency risk premia

## Jiang (2022)
**Fiscal Cyclicality and Currency Risk Premia**  
*The Review of Financial Studies*, 35(3), 1527–1552.

**Status:** publicado em periódico.

**Este provavelmente é o paper publicado mais importante para a narrativa fiscal moderna.**

O modelo dá papel central à restrição orçamentária intertemporal do governo na determinação do câmbio real:

\[
\text{market value of government debt}
=
PV(\text{future government surpluses})
\]

Fundamentos fiscais afetam a precificação da dívida pública e, por essa via, o prêmio de risco das moedas.

**Mecanismo relevante:**

\[
\text{fiscal fundamentals}
\rightarrow
\text{currency risk premium}
\rightarrow
\text{exchange rate}
\]

**Por que é particularmente útil para o Brasil atual:**  
O argumento não depende de uma parcela elevada da dívida pública denominada em moeda estrangeira. Portanto, é conceitualmente mais apropriado para o Brasil pós-2013 que uma aplicação literal do mecanismo brasileiro de 2002.

**Limitação:**  
Jiang não estima a cadeia específica:

\[
\text{domestic MP shock}
\rightarrow
\text{fiscal risk}
\rightarrow
\text{currency depreciation}.
\]

Logo, ele fundamenta o **elo fiscal → prêmio cambial**, e não todo o mecanismo do artigo.

**Como usar:** referência central.

**Referência:**  
https://doi.org/10.1093/rfs/hhab061

---

## Jiang (2021)
**US Fiscal Cycle and the Dollar**  
*Journal of Monetary Economics*, 124, 91–106.

**Status:** publicado em periódico.

Mostra que condições fiscais americanas estão relacionadas aos prêmios de risco do dólar e de outras moedas.

**Mecanismo:**

\[
\text{US fiscal condition}
\rightarrow
\text{financial intermediary constraint}
\rightarrow
\text{global FX risk premia}
\]

**Limitação importante:**  
O mecanismo depende do papel especial dos títulos do Tesouro dos EUA como ativos de reserva. Portanto, não deve ser transportado literalmente para o Brasil.

**Como usar:**  
Referência complementar para demonstrar que a literatura de asset pricing conecta condições fiscais e currency risk premia. Jiang (2022) é muito mais diretamente aplicável ao argumento brasileiro.

**Referência:**  
https://doi.org/10.1016/j.jmoneco.2021.10.002

---

# 4. Bloco C — risco fiscal, risco soberano e câmbio em emergentes

## Banerjee, Boctor, Mehrotra & Zampolli (2023)
**Fiscal Sources of Inflation Risk in EMDEs: The Role of the External Channel**  
BIS Working Paper No. 1110.

**Status:** working paper institucional do BIS.

**Mecanismo extremamente útil:**

\[
\uparrow \text{fiscal deficit}
\rightarrow
\uparrow \text{sovereign risk}
\rightarrow
\text{currency depreciation}
\rightarrow
\uparrow \text{inflation risk}
\]

O trabalho mostra que, em EMDEs, déficits fiscais elevam o risco de depreciação futura e que esse canal externo está associado ao risco soberano.

**Por que é importante:**  
Esse paper contém quase exatamente o elo intermediário necessário para interpretar conjuntamente CDS/EMBI e câmbio.

O seu artigo acrescenta uma origem diferente para o movimento inicial:

\[
\text{monetary tightening}
\rightarrow
\uparrow \text{sovereign risk}
\rightarrow
\text{depreciação}
\]

**Limitação:**  
O choque inicial de Banerjee et al. é fiscal, não monetário.

**Como usar:** referência importante para o elo soberano-cambial em economias emergentes.

**Referência:**  
https://www.bis.org/publ/work1110.htm

---

## Kalemli-Özcan & Unsal (2023)
**Global Transmission of Fed Hikes: The Role of Policy Credibility and Balance Sheets**  
*Brookings Papers on Economic Activity*, Fall 2023.

**Status:** publicado.

Analisa como credibilidade monetária e vulnerabilidades de balanço condicionam a transmissão de apertos do Fed para EMDEs.

**Mecanismo geral:**

\[
\text{monetary tightening}
\rightarrow
\text{global financial conditions / risk repricing}
\]

com heterogeneidade dependente de credibilidade e fragilidade financeira.

**Como usar:**  
Apoia a ideia geral de que a transmissão monetária em emergentes depende do estado dos fundamentos e não pode ser resumida apenas ao diferencial de juros.

**Limitação:**  
É choque monetário externo, não doméstico, e o mecanismo principal não é fiscal.

**Peso sugerido:** complementar.

**Referência:**  
https://www.brookings.edu/articles/global-transmission-of-fed-hikes/

---

# 5. Bloco D — a literatura brasileira clássica de dominância fiscal

Esse bloco deve entrar no artigo, mas com uma distinção institucional explícita entre **Brasil 2002** e **Brasil 2013–2025**.

## Blanchard (2004)
**Fiscal Dominance and Inflation Targeting: Lessons from Brazil**  
NBER Working Paper 10389; posteriormente incluído em volume publicado pela MIT Press em 2005.

**Status:** working paper NBER com versão publicada em livro; não artigo de journal.

### Mecanismo central

O benchmark é:

\[
\uparrow i
\rightarrow
\text{domestic debt more attractive}
\rightarrow
\text{appreciation}
\]

Mas, se juros maiores aumentam suficientemente a probabilidade de default:

\[
\uparrow i
\rightarrow
\uparrow \text{default/sovereign risk}
\rightarrow
\text{domestic debt less attractive}
\rightarrow
\text{depreciation}
\]

Isso é muito próximo do padrão reduzido encontrado no artigo.

### O ponto que NÃO deve ser transportado mecanicamente

Blanchard mostra que o resultado perverso se torna mais provável quando:

- o nível inicial da dívida é elevado;
- a parcela da dívida denominada/indexada em moeda estrangeira é elevada;
- o preço do risco é elevado.

A segunda condição descrevia muito melhor o Brasil de 2002 do que o Brasil da amostra atual.

Segundo o Tesouro Nacional:

- ao fim de 2002, cerca de **22% da dívida doméstica era atrelada ao câmbio**;
- ao fim de 2025, apenas **3,8% da DPF estava no indexador câmbio**.

Portanto, **não é adequado dizer que o artigo encontra simplesmente "o mecanismo de Blanchard" novamente**.

A formulação correta é:

> Blanchard estabelece que uma deterioração endógena do risco soberano pode inverter a resposta convencional do câmbio a juros. O artigo investiga se uma resposta reduzida semelhante aparece no Brasil contemporâneo, apesar de uma estrutura de dívida substancialmente diferente daquela observada em 2002.

Isso transforma a diferença institucional em parte da contribuição.

**Referência:**  
https://www.nber.org/papers/w10389

---

## Favero & Giavazzi (2004/2005)
**Inflation Targeting and Debt: Lessons from Brazil**

NBER Working Paper 10390; versão publicada no volume *Inflation Targeting, Debt, and the Brazilian Experience, 1999 to 2003*, MIT Press, 2005.

**Status:** publicado como capítulo/volume; não artigo de journal.

O paper coloca **default risk** no centro da transição entre dominância monetária e fiscal.

**Mecanismo:**

\[
\uparrow i
\rightarrow
\text{worse fiscal dynamics}
\rightarrow
\uparrow \text{default risk}
\rightarrow
\text{adverse monetary transmission}
\]

**Como usar:**  
É provavelmente a referência brasileira mais natural ao lado de Blanchard para justificar o papel do CDS/EMBI como variável econômica central, e não apenas como mais um preço de ativo.

**Cuidado:**  
Novamente, o ambiente institucional e a composição da dívida são os de 1999–2003.

**Referência:**  
https://www.nber.org/papers/w10390

---

## Zoli (2005)
**How Does Fiscal Policy Affect Monetary Policy in Emerging Market Countries?**  
BIS Working Paper No. 174.

**Status:** working paper institucional do BIS.

Este trabalho é empiricamente muito próximo da narrativa do artigo.

Para o Brasil ao redor da crise de 2002, Zoli encontra que eventos fiscais afetaram significativamente:

- sovereign spreads;
- taxa de câmbio.

O paper também encontra evidência compatível com um equilíbrio em que aumentos da policy rate poderiam estar associados a **depreciação**, e não apreciação.

**Por que é importante:**  
É antecedente empírico direto do fato estilizado.

**Por que não elimina a contribuição:**  
A identificação, frequência, período, estrutura da dívida e desenho empírico são completamente diferentes.

Seu paper estuda o Brasil de 2013–2025 com choque monetário identificado por instrumento externo e um SDFM de grande dimensão.

**Referência:**  
https://www.bis.org/publ/work174.htm

---

# 6. Bloco E — contraponto brasileiro contemporâneo

## Gonçalves et al. (2025)

**Status:** working paper institucional do FMI.

O artigo identifica choques monetários brasileiros por heterocedasticidade em frequência diária.

Na leitura atualmente utilizada no artigo:

\[
\text{tightening}
\rightarrow
\text{BRL appreciation}
\]

e o CDS soberano de cinco anos não apresenta resposta significativa.

Isso contrasta diretamente com:

\[
\text{tightening}
\rightarrow
\begin{cases}
\text{BRL depreciation}\\
\uparrow \text{CDS}\\
\uparrow \text{EMBI}
\end{cases}
\]

encontrado no SDFM-IV.

### Papel na narrativa

Este talvez seja o **contraponto empírico mais importante** do artigo.

A contribuição deixa de ser:

> "Ninguém mostrou que juros maiores podem depreciar o real."

Essa afirmação não é sustentável devido a Blanchard, Favero-Giavazzi e Zoli.

A questão passa a ser:

> Por que uma identificação contemporânea em alta frequência encontra transmissão monetária convencional, enquanto um SDFM-IV mensal, com conjunto de informação muito mais amplo, encontra uma resposta conjunta de depreciação cambial e elevação do risco soberano?

Essa divergência é uma pergunta econômica e econométrica interessante.

---

# 7. Status de publicação — resumo

| Trabalho | Status | Veículo |
|---|---|---|
| Jiang (2022), *Fiscal Cyclicality and Currency Risk Premia* | **Publicado em journal** | Review of Financial Studies |
| Jiang (2021), *US Fiscal Cycle and the Dollar* | **Publicado em journal** | Journal of Monetary Economics |
| Benigno, Benigno & Nisticò (2012) | **Publicado** | NBER Macroeconomics Annual |
| Kalemli-Özcan & Unsal (2023) | **Publicado** | Brookings Papers on Economic Activity |
| Blanchard (2004) | WP + **versão em livro** | NBER / MIT Press |
| Favero & Giavazzi (2004) | WP + **versão em livro** | NBER / MIT Press |
| Zoli (2005) | Working paper | BIS |
| Banerjee et al. (2023) | Working paper | BIS |
| Gonçalves et al. (2025) | Working paper | IMF |
| Dalgic & Ozhan (2026) | Working paper | IMF |

## Prioridade se for desejável privilegiar literatura publicada

### Núcleo publicado
1. **Jiang (2022)** — RFS.
2. **Benigno, Benigno & Nisticò (2012)** — NBER Macro Annual.
3. **Jiang (2021)** — JME.
4. **Kalemli-Özcan & Unsal (2023)** — BPEA.

### Antecedentes brasileiros que devem entrar apesar de não serem journals
5. **Blanchard (2004/2005)**.
6. **Favero & Giavazzi (2004/2005)**.
7. **Zoli (2005)**.

### Evidência institucional recente
8. **Banerjee et al. (2023)**.
9. **Gonçalves et al. (2025)**.
10. **Dalgic & Ozhan (2026)**.

---

# 8. Como melhorar a narrativa do artigo

## 8.1. Problema da narrativa atual

A narrativa atual corre o risco de parecer:

\[
\text{UIP prevê apreciação}
\rightarrow
\text{encontro depreciação}
\rightarrow
\text{logo, dominância fiscal}.
\]

Isso é forte demais.

A IRF conjunta de câmbio + CDS + EMBI torna a hipótese fiscal plausível, mas não identifica a origem do aumento do prêmio de risco.

Além disso, Dalgic & Ozhan (2026) mostram precisamente que mecanismos não fiscais podem gerar uma inversão semelhante da UIP.

---

## 8.2. Separar três proposições

A narrativa fica mais rigorosa se o paper distinguir explicitamente:

### Proposição 1 — fato empírico

\[
\text{monetary tightening}
\rightarrow
\text{currency depreciation}
+
\uparrow \text{sovereign spreads}.
\]

Isso é o que o modelo efetivamente identifica.

### Proposição 2 — interpretação econômica

A resposta conjunta é difícil de reconciliar com uma UIP sem variação relevante de prêmio de risco e é **compatível com** uma reprecificação de risco soberano.

### Proposição 3 — hipótese fiscal

Uma possível fonte dessa reprecificação é:

\[
\uparrow i
\rightarrow
\uparrow \text{expected debt service}
\rightarrow
\text{worse perceived fiscal trajectory}
\rightarrow
\uparrow \text{sovereign risk premium}
\rightarrow
\text{depreciation}.
\]

Essa terceira seta é uma interpretação a ser corroborada, não uma variável estrutural diretamente identificada pelo desenho atual.

Essa hierarquia evita overclaiming.

---

# 9. A narrativa fiscal adequada ao Brasil contemporâneo

## 9.1. Evitar a reprodução literal de Blanchard (2004)

O mecanismo de 2002 tinha um componente de balanço muito mais forte:

\[
\text{depreciation}
\rightarrow
\uparrow \text{BRL value of FX-linked debt}
\rightarrow
\text{fiscal deterioration}
\rightarrow
\uparrow \text{risk}
\rightarrow
\text{further depreciation}.
\]

Isso era plausível porque a exposição cambial da dívida era grande.

Essa descrição não caracteriza bem a estrutura atual.

---

## 9.2. Substituir por uma narrativa de custo de carregamento e reprecificação soberana

Para 2013–2025, uma narrativa mais defensável é:

\[
\boxed{
\uparrow i_t
\rightarrow
\uparrow \text{expected government financing cost}
\rightarrow
\downarrow \text{perceived fiscal space}
\rightarrow
\uparrow \text{sovereign risk premium}
\rightarrow
\text{BRL depreciation}
}
\]

Essa narrativa não exige dívida denominada em dólar.

Ela requer que os agentes percebam a trajetória fiscal como suficientemente sensível ao custo de financiamento.

### Observação importante sobre a composição atual

Ao fim de 2025, a DPF era aproximadamente:

- 48,3% flutuante;
- 25,9% indexada a preços;
- 22,0% prefixada;
- 3,8% cambial.

Isso sugere uma questão empiricamente mais relevante que a antiga exposição cambial:

> Quanto e quão rapidamente um choque da Selic altera o custo esperado de financiamento/refinanciamento da dívida e, por essa via, o prêmio de risco soberano?

Essa é uma narrativa distinta da de 2002.

---

# 10. Um possível encadeamento para a revisão de literatura

## Parágrafo 1 — benchmark cambial

Começar com UIP e a previsão convencional:

\[
\uparrow i_t-i_t^*
\rightarrow
\text{appreciation}.
\]

Em seguida, introduzir a literatura que permite prêmio de risco cambial variável.

**Referências:** Benigno et al. (2012).

---

## Parágrafo 2 — inversões por fragilidades não fiscais

Mostrar que a falha da UIP pode ser endógena a fragilidades macrofinanceiras.

**Referência:** Dalgic & Ozhan (2026).

Função desse parágrafo:

> Uma depreciação após tightening não identifica fiscal dominance por si só.

---

## Parágrafo 3 — fundamentos fiscais e currency risk premia

Introduzir a literatura que liga posição fiscal à precificação cambial.

**Referências principais:**
- Jiang (2022);
- Jiang (2021), secundariamente.

Mensagem:

\[
\text{fiscal fundamentals}
\rightarrow
\text{FX risk premia}.
\]

---

## Parágrafo 4 — sovereign risk como canal externo em EMDEs

Mostrar que, em emergentes, deterioração fiscal pode afetar o câmbio via risco soberano.

**Referência principal:** Banerjee et al. (2023).

Mensagem:

\[
\text{fiscal deterioration}
\rightarrow
\uparrow \text{CDS/sovereign risk}
\rightarrow
\text{depreciation}.
\]

Esse parágrafo dá significado econômico à resposta conjunta CDS + EMBI + FX encontrada no artigo.

---

## Parágrafo 5 — Brasil: literatura clássica

Apresentar:

- Blanchard (2004);
- Favero & Giavazzi (2004);
- Zoli (2005).

Mas imediatamente registrar:

> Esses trabalhos estudam a crise de 2002, quando a exposição cambial e a composição da dívida pública brasileira eram substancialmente diferentes.

Isso impede que o referee descarte a narrativa como simples redescoberta de um resultado antigo.

---

## Parágrafo 6 — mudança de regime da dívida

A transformação da composição da dívida é parte importante do gap.

Em 2002:
- aproximadamente 22% da dívida doméstica era cambial;
- aproximadamente 60% era indexada à Selic.

Em 2025:
- apenas 3,8% da DPF era cambial;
- 48,3% estava em taxa flutuante;
- 25,9% em índice de preços;
- 22% prefixada.

A pergunta deixa de ser:

> O mecanismo cambial de balanço de 2002 ainda existe?

e passa a ser:

> Mesmo após a forte redução da exposição cambial da dívida, choques monetários podem produzir uma reprecificação suficientemente forte do risco soberano para inverter a resposta cambial convencional?

Essa é uma pergunta muito mais interessante.

---

## Parágrafo 7 — evidência contemporânea contraditória

Introduzir Gonçalves et al. (2025).

Eles encontram transmissão convencional em frequência diária; o seu SDFM-IV mensal encontra o oposto.

Isso gera o gap contemporâneo:

\[
\boxed{
\text{Por que estratégias de identificação diferentes produzem conclusões distintas}
\\
\text{sobre o canal monetário--soberano--cambial no Brasil moderno?}
}
\]

---

# 11. Proposta de reposicionamento da contribuição

## Evitar

> "Este é o primeiro trabalho a mostrar que um aumento de juros pode depreciar o real por meio de risco fiscal."

Blanchard e Zoli tornam essa claim difícil de defender.

## Preferir

Uma contribuição em três dimensões:

### 1. Regime histórico distinto

A literatura clássica documenta o mecanismo em torno da crise de 2002, sob estrutura de dívida fortemente exposta ao câmbio.

O artigo investiga 2013–2025, após profunda transformação da composição da dívida.

### 2. Identificação moderna

Choques monetários são identificados por instrumento externo corrigido por informação predeterminada e contaminação informacional.

### 3. Evidência multivariada conjunta

O SDFM permite observar simultaneamente:

\[
FX,\ CDS,\ EMBI,\ yield\ curve,\ credit,\ equities,\ activity,\ inflation.
\]

Assim, a contribuição não é simplesmente o sinal da IRF do câmbio.

É a documentação de um **padrão conjunto de reprecificação soberana** após um choque monetário em um regime moderno da dívida brasileira.

---

# 12. Formulação sugerida da narrativa central

Uma formulação conceitualmente disciplinada seria:

> A literatura clássica sobre o Brasil mostrou que, em ambientes de elevada fragilidade fiscal, um aperto monetário pode elevar o risco soberano o suficiente para inverter a apreciação prevista pela paridade descoberta dos juros. Esse mecanismo foi estudado principalmente durante a crise de 2002, quando a dívida pública brasileira apresentava exposição cambial muito maior que no regime atual. Paralelamente, a literatura recente de macro-finanças mostra que fundamentos fiscais e outras fragilidades estruturais podem gerar prêmios de risco cambial endógenos e desvios persistentes da UIP. Este artigo pergunta se uma resposta reduzida semelhante — depreciação acompanhada por aumento do risco soberano — permanece empiricamente relevante no Brasil pós-2013, apesar da profunda mudança na composição da dívida pública. Utilizando um SDFM identificado por instrumento externo, documentamos que um aperto monetário é seguido por depreciação do real, abertura do EMBI e do CDS soberano e forte reprecificação da curva de juros. Interpretamos esse conjunto como evidência de um canal de prêmio de risco soberano; embora compatível com uma origem fiscal, o desenho não identifica diretamente a fonte fiscal desse prêmio.

Essa formulação tem quatro vantagens:

1. reconhece explicitamente a literatura brasileira anterior;
2. transforma a mudança da estrutura da dívida em parte da contribuição;
3. não confunde evidência de risco soberano com identificação estrutural de dominância fiscal;
4. torna o contraste com Gonçalves et al. (2025) economicamente central.

---

# 13. O que ainda vale investigar antes de fechar a narrativa

## Prioridade alta

### A. Sensibilidade efetiva do serviço da dívida à Selic

Não basta saber que a dívida é "interna".

É necessário medir:

- participação Selic/pós-fixada;
- maturidade média;
- necessidade anual de refinanciamento;
- duration;
- custo médio da DPF;
- velocidade com que uma alta de Selic entra no custo efetivo da dívida.

Essa evidência determina se:

\[
\uparrow i
\rightarrow
\uparrow \text{expected debt service}
\]

é quantitativamente plausível na amostra.

### B. Relação entre surpresa monetária e medidas fiscais de mercado

Além de CDS e EMBI, procurar eventualmente:

- slope/term premium da curva nominal;
- NTN-B / juros reais longos;
- breakeven inflation;
- fiscal risk measures;
- survey de dívida/resultado primário, se houver frequência utilizável.

### C. Heterogeneidade temporal

Testar se o resultado é mais forte em períodos de maior estresse fiscal.

Por exemplo, interações/state dependence com alguma medida ex ante de:

- dívida/PIB;
- resultado primário esperado;
- CDS;
- fiscal uncertainty;
- percepção de risco fiscal.

Se a resposta

\[
\text{MP shock}\rightarrow \text{depreciation}
\]

for mais forte justamente quando a posição fiscal é percebida como pior, isso seria evidência muito mais direta a favor da narrativa.

---

# 14. Hierarquia de claims

## Claim forte — suportada diretamente pelo desenho

> Um choque monetário contracionista identificado externamente é seguido por depreciação do real e aumento do risco soberano.

## Claim intermediária — interpretação bem sustentada

> O padrão conjunto é compatível com um canal de prêmio de risco soberano que domina o efeito convencional do diferencial de juros.

## Claim forte demais sem exercício adicional

> O aperto monetário deteriora as contas públicas e causa dominância fiscal.

Para fazer a terceira afirmação de maneira convincente seria desejável identificar explicitamente um elo fiscal intermediário ou mostrar forte state dependence em relação a condições fiscais predeterminadas.

---

# 15. Referências e fontes institucionais úteis

- Blanchard, O. (2004). *Fiscal Dominance and Inflation Targeting: Lessons from Brazil*. NBER Working Paper 10389.  
  https://www.nber.org/papers/w10389

- Favero, C. A., & Giavazzi, F. (2004). *Inflation Targeting and Debt: Lessons from Brazil*. NBER Working Paper 10390.  
  https://www.nber.org/papers/w10390

- Zoli, E. (2005). *How does fiscal policy affect monetary policy in emerging market countries?* BIS Working Paper 174.  
  https://www.bis.org/publ/work174.htm

- Jiang, Z. (2022). *Fiscal Cyclicality and Currency Risk Premia*. Review of Financial Studies, 35(3), 1527–1552.  
  https://doi.org/10.1093/rfs/hhab061

- Jiang, Z. (2021). *US Fiscal Cycle and the Dollar*. Journal of Monetary Economics, 124, 91–106.  
  https://doi.org/10.1016/j.jmoneco.2021.10.002

- Benigno, G., Benigno, P., & Nisticò, S. (2012). *Risk, Monetary Policy, and the Exchange Rate*. NBER Macroeconomics Annual, 26.  
  https://doi.org/10.1086/663993

- Banerjee, R. N., Boctor, V., Mehrotra, A., & Zampolli, F. (2023). *Fiscal Sources of Inflation Risk in EMDEs: The Role of the External Channel*. BIS Working Paper 1110.  
  https://www.bis.org/publ/work1110.htm

- Kalemli-Özcan, Ş., & Unsal, F. (2023). *Global Transmission of Fed Hikes: The Role of Policy Credibility and Balance Sheets*. Brookings Papers on Economic Activity.  
  https://www.brookings.edu/articles/global-transmission-of-fed-hikes/

- Tesouro Nacional. *Gestão da Dívida — evolução da composição da DPF*.  
  https://www.gov.br/tesouronacional/

- Tesouro Nacional (2026). *Dívida Pública encerra 2025 em R$ 8,635 trilhões*. Dados de composição da DPF ao fim de 2025.  
  https://www.gov.br/tesouronacional/
