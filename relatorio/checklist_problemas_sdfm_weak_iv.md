# Checklist de problemas econométricos e de narrativa antes da submissão
## SDFM-IV, instrumento do Copom, weak-IV e identificação do canal de risco soberano

> **VINTAGE SUPERADA EM 2026-08-18.** Este checklist foi escrito antes da
> migração para 111 séries em `(r,q,p)=(5,5,6)` e preserva resultados e tarefas
> da produção anterior. O documento continua útil como inventário de objeções,
> mas não é fonte para números ou pendências correntes. Consulte
> `output/irf/irf_section.md`, `registro/pendencias.md` e
> `paper/paper_anpec.tex` antes de reutilizar qualquer conclusão.

Este documento organiza os principais problemas que precisam ser resolvidos na versão atual do artigo **“Uncovered Interest Parity, Inverted: Risk-Premium Transmission of Monetary Policy Shocks in Brazil”**, com ênfase em dois pontos que atingem diretamente o resultado central:

1. a possibilidade de o instrumento reter **notícia fiscal doméstica** junto com o choque monetário;
2. a **força limitada do instrumento** e a ausência, na literatura localizada até aqui, de um procedimento pronto de weak-IV robust inference para um SDFM/FAVAR com fatores estimados comparável ao procedimento de Montiel Olea, Stock e Watson para proxy-SVAR.

A conclusão operacional deste documento é importante:

> **O problema do weak-IV não deve ser tratado como “preciso encontrar outro instrumento a qualquer custo”.**
>
> Dada a institucionalidade do Copom — anúncio após o fechamento do mercado — um instrumento de alta frequência limpo e muito mais forte pode simplesmente não existir com os dados disponíveis. A estratégia deve ser:  
> **(i)** extrair o máximo de credibilidade do instrumento existente;  
> **(ii)** separar diagnóstico de força de inferência;  
> **(iii)** construir exercícios auxiliares com inferência weak-IV robust em modelos onde a teoria existe;  
> **(iv)** reduzir claims quando a teoria de inferência do SDFM não permitir uma afirmação formal.

---

# 1. Resultado central que precisa ser protegido

A versão atual encontra, após uma surpresa monetária normalizada para elevar o DI de 6 meses em 50 pb:

\[
\Delta s_{BRL/USD}(0) \approx +5.55\%,
\]

\[
\Delta EMBI(0) \approx +32\text{ pb},
\]

\[
\Delta CDS_{5y}(0) \approx +43.4\text{ pb}.
\]

Além disso, a curva abre de forma crescente até aproximadamente o vértice de 5 anos.

O argumento econômico é:

\[
\text{monetary tightening}
\rightarrow
\text{sovereign-risk repricing}
\rightarrow
\text{BRL depreciation}.
\]

Esse é o núcleo publicável do paper.

O problema é que duas explicações alternativas podem gerar exatamente o mesmo padrão:

### Alternativa A — instrumento fraco

Se a correlação entre a proxy e o choque monetário estrutural é pequena, a razão usada para recuperar o vetor de impacto passa a ter distribuição não regular. Magnitudes e intervalos convencionais podem então ser pouco confiáveis.

### Alternativa B — notícia fiscal contaminando a proxy

Uma notícia fiscal ruim no mesmo intervalo pode produzir simultaneamente

\[
DI\uparrow,\qquad
Bovespa\downarrow,\qquad
BRL\downarrow,\qquad
CDS\uparrow,\qquad
EMBI\uparrow.
\]

Esse é justamente o sinal que o filtro baseado no co-movimento juros–ações tende a classificar como “monetary policy shock”.

Portanto, os dois problemas são distintos:

- **weak-IV:** “o instrumento contém pouco sinal do choque monetário”;
- **invalid-IV / confounding:** “o instrumento contém outro choque que produz o próprio resultado”.

O segundo é conceitualmente mais grave que o primeiro.

---

# 2. Problema 1 — não existe uma janela intraday trivial para o Copom

## 2.1. Restrição institucional

O Copom anuncia a decisão depois do fechamento do mercado brasileiro.

Por isso, uma estratégia análoga à janela de 30 minutos do FOMC não é imediatamente implementável com preços de fechamento.

A surpresa observada usando fechamento da quarta-feira e fechamento da quinta-feira incorpora:

\[
\text{Copom surprise}
+
\text{overnight news}
+
\text{Thursday domestic news}
+
\text{external shocks}.
\]

Logo, o instrumento possui uma janela de contaminação muito maior que os instrumentos intraday clássicos.

Isso não torna o instrumento automaticamente inválido, mas aumenta a carga de evidência necessária.

---

## 2.2. O que NÃO fazer

### Não procurar “força” otimizando a proxy sobre o resultado

Não escolher:

- tenor do DI;
- regra de sinal;
- conjunto de controles;
- número de fatores;
- janela da amostra;

com base em qual especificação maximiza \(\xi_{mp}\), o F de primeiro estágio ou a significância do BRL/CDS.

Isso seria specification search sobre o próprio diagnóstico.

### Não alegar que o filtro Jarociński–Karadi resolve toda contaminação

O filtro foi desenhado para separar monetary shocks de central-bank information shocks.

Ele não foi desenhado para separar:

\[
\text{monetary shock}
\quad\text{de}\quad
\text{Brazilian fiscal news}.
\]

Uma notícia fiscal ruim pode ter exatamente o padrão

\[
\Delta DI>0,\qquad \Delta Equity<0,
\]

e portanto sobreviver ao filtro.

---

# 3. O que fazer com a restrição do anúncio após o fechamento

## 3.1. Tratar a limitação como institucional, não como falha de execução

A versão final deve explicar claramente:

> Diferentemente do FOMC, a institucionalidade do Copom impede que uma surpresa construída exclusivamente com preços de fechamento seja medida em uma janela de minutos ao redor do anúncio.

Isso reduz a expectativa de que o paper simplesmente replique Gertler–Karadi ou Jarociński–Karadi.

---

## 3.2. Se dados intraday forem acessíveis, testar uma janela mais estreita

A prioridade seria verificar se existem dados históricos intraday suficientemente longos para:

- DI futuro;
- BRL;
- Ibovespa ou futuro de Ibovespa.

A pergunta não é necessariamente medir preços **depois do anúncio na própria quarta-feira**, já que o mercado está fechado.

A pergunta é se é possível reduzir a janela de quinta-feira, por exemplo usando:

\[
\text{close}_{Wed}
\rightarrow
\text{early trading}_{Thu},
\]

ou comparar:

\[
\text{overnight/early-Thursday move}
\]

com

\[
\text{rest-of-Thursday move}.
\]

Se o resultado monetário estiver concentrado na abertura/início da sessão e a parte fiscal aparecer mais tarde, isso seria evidência útil.

**Mas essa possibilidade depende totalmente da disponibilidade de dados históricos intraday.**

Não deve ser apresentada como condição necessária para o paper enquanto a disponibilidade não for confirmada.

---

## 3.3. Se intraday não existir: triangulação, não “instrumento perfeito”

Nesse caso, a estratégia deve combinar evidências:

1. surpresa bruta;
2. surpresa ortogonalizada à informação predeterminada;
3. surpresa com filtro de sinal;
4. variantes sem filtro de sinal;
5. diferentes tenores do DI escolhidos **ex ante por justificativa econômica**, não por força;
6. event studies nas reuniões mais influentes;
7. controles/notícias fiscais observáveis;
8. modelos alternativos com o mesmo instrumento.

A pergunta passa a ser:

> O sinal BRL↓ + CDS↑ + EMBI↑ depende de uma transformação específica da proxy?

Se desaparecer ao remover uma etapa específica, a narrativa fica mais frágil.

Se sobreviver a diferentes proxies economicamente defensáveis, aumenta a credibilidade.

---

# 4. Problema 2 — notícia fiscal doméstica pode ser o verdadeiro choque

Esse é o problema de identificação mais importante.

## 4.1. Por que os placebos globais não resolvem

Se uma notícia fiscal brasileira ocorre junto do Copom, ela provavelmente não move:

- VIX;
- MSCI Emerging Markets;
- EPU dos EUA.

Logo,

\[
\text{global placebo}=0
\]

é compatível tanto com:

\[
\text{Brazilian monetary shock}
\]

quanto com:

\[
\text{Brazilian fiscal shock}.
\]

Os placebos globais descartam um confundidor externo amplo, mas não um confundidor doméstico.

---

# 5. Exercícios prioritários para fiscal-news confounding

## 5.1. Auditoria reunião por reunião

Construir uma tabela com as 95 reuniões:

| data | DI surprise | equity surprise | filtro | BRL | CDS/EMBI | notícias fiscais relevantes |
|---|---:|---:|---|---:|---:|---|

Objetivos:

1. detectar se poucas reuniões extremas dirigem os resultados;
2. identificar episódios conhecidos de anúncio fiscal;
3. verificar se esses episódios são justamente os retidos pelo filtro.

Depois executar:

### Leave-one-out

Reestimar retirando uma reunião por vez.

Para cada \(j\):

\[
IRF^{(-j)}.
\]

Plotar as distribuições de:

- impacto BRL;
- impacto CDS;
- impacto EMBI;
- \(\xi_{mp}\).

Se 2015, 2020, 2021, 2022 ou outro episódio específico determinar o resultado, isso precisa aparecer.

---

## 5.2. Leave-cluster-out

Além de reunião individual, retirar blocos:

- crise fiscal/política;
- COVID;
- episódios eleitorais;
- transições de governo;
- episódios de mudança de arcabouço fiscal.

Isso é mais informativo que apenas “pré-COVID vs full sample”.

---

## 5.3. Controle explícito por fiscal news

Se for possível construir um indicador diário/de evento de notícia fiscal, incluir essa informação no estágio de limpeza da surpresa.

Possibilidades conceituais:

- mudanças de expectativas fiscais;
- medidas de fiscal-news obtidas de notícias;
- revisões de expectativas de resultado primário/dívida;
- movimentos de ativos soberanos anteriores ao Copom;
- datas de anúncios fiscais relevantes.

A regra principal é:

> apenas informação determinada antes da surpresa monetária pode entrar diretamente como controle predeterminado sem criar post-treatment bias.

Notícia que ocorre **depois** do Copom na quinta-feira não pode simplesmente ser “controlada” como se fosse predeterminada; nesse caso a solução é estreitar janela, excluir evento ou fazer análise narrativa.

---

# 6. Weak-IV: qual é exatamente o problema no paper?

Na especificação principal, o diagnóstico está aproximadamente na região:

\[
\xi_{mp}\approx 6.3,
\qquad
F^{rob}_{mp}\approx 10.
\]

Isso é evidência mista, não uma situação de instrumento obviamente irrelevante.

O ponto correto não é:

> “o instrumento é definitivamente fraco.”

O ponto correto é:

> “a força não é suficientemente confortável para que a inferência convencional possa ser usada sem discussão.”

Montiel Olea, Stock e Watson mostram para proxy-SVAR que, sob weak proxy, a distribuição das IRFs identificadas via razão de covariâncias é não regular e confidence intervals convencionais podem falhar.

---

# 7. Por que Montiel Olea–Stock–Watson não pode ser transplantado automaticamente para o SDFM

## 7.1. No proxy-SVAR

Em um SVAR observável, a dinâmica reduzida é estimada diretamente sobre:

\[
Y_t.
\]

O instrumento identifica a coluna estrutural relevante a partir da covariância entre a proxy e as inovações reduzidas.

A teoria weak-IV robust é derivada para esse objeto.

---

## 7.2. No SDFM

No paper, temos esquematicamente:

\[
X_t=\Lambda F_t+e_t,
\]

\[
\Phi(L)F_t=G\eta_t,
\]

\[
\eta_t=H\varepsilon_t.
\]

O instrumento identifica uma direção em \(H\) através das inovações fatoriais estimadas.

A IRF observável depende de:

\[
IRF_X(h)
=
\Lambda\,
\Psi_h\,
G\,
H_{\cdot p}.
\]

Logo existem três blocos de parâmetros estimados:

1. \(\widehat{\Lambda}\);
2. dinâmica dos fatores \(\widehat{\Psi}_h,\widehat{G}\);
3. direção de impacto identificada pela proxy \(\widehat H_{\cdot p}\).

O weak-IV afeta diretamente o terceiro bloco.

Mas os fatores são **generated regressors**:

\[
\widehat F_t\neq F_t.
\]

Portanto, para afirmar validade formal de uma confidence set weak-IV robust para \(IRF_X(h)\), seria necessário demonstrar como o erro de estimação dos fatores e das loadings interage com a weak identification asymptotics.

Não é correto simplesmente afirmar:

> “aplico MOSW às inovações fatoriais e está resolvido.”

Isso pode ser um **diagnóstico oracle/conditional-on-factors**, mas não automaticamente um intervalo formal para o SDFM completo.

---

# 8. O que a literatura encontrada fornece — e o que não fornece

## 8.1. Alessi & Kerssenfischer

Alessi e Kerssenfischer combinam:

- Dynamic Factor Model;
- external instrument;
- wild bootstrap.

Isso é muito próximo da arquitetura do paper.

Mas o trabalho não é, até onde foi localizado, uma teoria de weak-IV robust inference para fatores estimados.

Ele fornece precedente para:

\[
DFM + external\ instrument,
\]

não resolve:

\[
DFM + weak\ external\ instrument.
\]

---

## 8.2. Brignone, Franconi & Mazzali — Proxy DFM

O preprint “Robust Impulse Responses using External Instruments: the Role of Information” propõe explicitamente um **Proxy DFM**.

O foco é:

- missing information;
- non-invertibility/fundamentalness;
- measurement error;
- comparação Proxy VAR vs Proxy DFM.

Isso é extremamente relevante para justificar o uso do DFM.

Contudo, na busca realizada para este documento, **não foi localizado um resultado equivalente às weak-IV robust confidence sets de Montiel Olea–Stock–Watson para o Proxy DFM**.

Portanto:

> não devemos citar esse paper como se ele resolvesse weak identification no SDFM.

---

## 8.3. Angelini, Cavaliere & Fanelli

O trabalho de 2024 em *Journal of Econometrics* trata identificação e testes com weak proxies no contexto de **proxy-SVAR**.

É útil para mostrar que a literatura de weak-proxy inference continua sendo desenvolvida.

Mas novamente:

\[
proxy\text{-}SVAR\neq proxy\text{-}DFM.
\]

---

# 9. Estratégia recomendada para weak-IV no paper

A estratégia deve ter níveis.

---

# 10. Nível 1 — não esconder o problema

Reportar sempre:

- \(\xi_{mp}\);
- \(F^{rob}_{mp}\);
- número de observações não nulas da proxy;
- primeira-stage coefficient;
- erro padrão;
- variantes do instrumento.

A interpretação deve ser:

> “The relevance diagnostics are mixed and do not justify treating the proxy as unequivocally strong.”

Evitar:

> “The instrument passes the usual F>10 rule.”

Especialmente porque o limiar 10 não é um critical value universal para a estatística robusta usada.

---

# 11. Nível 2 — separar point estimate de inferência

É possível continuar reportando a estimativa pontual do SDFM:

\[
\widehat{IRF}(h),
\]

mas distinguir:

### estimativa pontual

“Esta é a dinâmica estimada sob a identificação adotada.”

### significância convencional

“Estas bandas dependem de aproximação forte-instrumento e devem ser interpretadas com cautela.”

Isso é melhor do que chamar diretamente todos os resultados de “statistically significant” sem qualificação.

---

# 12. Nível 3 — weak-IV robust proxy-SVAR como benchmark auxiliar

Este é provavelmente o exercício adicional mais importante e factível.

Selecionar um VAR pequeno contendo, por exemplo:

\[
[DI_{6m}, BRL, CDS/EMBI, \pi, atividade]
\]

ou especificações separadas com CDS e EMBI.

Usar **exatamente a mesma proxy**.

Aplicar a inferência weak-IV robust disponível para proxy-SVAR, por exemplo confidence sets por inversão de Anderson–Rubin/MOSW.

Objetivo:

> não substituir o SDFM pelo VAR.

O objetivo é perguntar:

\[
\text{O resultado central de impacto sobre BRL e sovereign risk}
\]

sobrevive quando usamos uma estrutura para a qual a teoria weak-IV robust está estabelecida?

### Interpretação possível

Se:

\[
SDFM:\ BRL\downarrow,\ CDS\uparrow
\]

e

\[
SVAR\text{-}IV_{\text{weak robust}}:\ BRL\downarrow,\ CDS\uparrow
\]

com confidence sets que excluem zero, isso fortalece muito a conclusão.

Se o weak-IV robust SVAR não rejeitar zero, não significa automaticamente que o SDFM está errado — o VAR pode sofrer missing-information/non-fundamentalness — mas significa que a claim de precisão precisa ser reduzida.

---

# 13. Nível 4 — FAVAR/proxy-VAR como ponte

Uma alternativa ao VAR muito pequeno é construir um FAVAR:

\[
Y_t=
[\text{key observables},\widehat F_t].
\]

Isso aproxima o information set amplo do SDFM.

Mas existe o mesmo problema teórico:

\[
\widehat F_t
\]

é estimado.

Portanto, aplicar MOSW mecanicamente continua não sendo uma solução formal completa.

Ainda assim, como **robustness exercise**, pode ser mais informativo que um VAR minúsculo.

A linguagem correta seria:

> “weak-IV robust inference conditional on the estimated factors”.

Não:

> “formal weak-IV robust inference for the full factor model”.

---

# 14. Nível 5 — Local Projection IV com inferência weak-IV robust

Essa é outra rota potencialmente importante.

Para cada horizonte \(h\), estimar algo do tipo:

\[
y_{t+h}
=
\alpha_h+\beta_h x_t+\Gamma_h'W_{t-1}+u_{t+h},
\]

instrumentando \(x_t\) pela proxy \(z_t\).

A inferência de IV linear possui ferramentas weak-IV robust clássicas como:

- Anderson–Rubin;
- conditional likelihood ratio, dependendo da configuração.

### Vantagem

A inferência weak-IV não depende da teoria específica do DFM.

### Desvantagem

LP-IV possui condições de validade diferentes e pode exigir lead-lag exogeneity mais forte, especialmente sem invertibilidade.

Stock & Watson (2018) são essenciais aqui.

### Como usar

Não substituir a estimação principal por LP-IV automaticamente.

Usar LP-IV weak-robust para as três variáveis centrais:

- BRL;
- CDS;
- EMBI.

Se a resposta de impacto/curto prazo tiver o mesmo sinal, isso é uma triangulação poderosa.

---

# 15. Uma possibilidade especialmente interessante: inferência AR para razões de impacto

O resultado central está muito concentrado em \(h=0\).

Isso abre uma rota mais simples conceitualmente.

Considere duas respostas de impacto, a variável de interesse \(y\) e a variável de normalização \(x\).

Sob a proxy válida:

\[
E[z_t u_{y,t}]
\]

e

\[
E[z_t u_{x,t}]
\]

são proporcionais às respectivas respostas ao choque estrutural.

O parâmetro normalizado pode ser escrito como uma razão:

\[
\theta
=
\frac{E[z_t u_{y,t}]}
     {E[z_t u_{x,t}]}.
\]

O problema weak-IV vem justamente do denominador pequeno.

Em vez de estimar a razão e tratá-la como normal, testar diretamente:

\[
H_0:\theta=\theta_0
\]

através da condição de momento

\[
E\left[
z_t
\left(
u_{y,t}-\theta_0 u_{x,t}
\right)
\right]
=0.
\]

Essa é a lógica de Anderson–Rubin/test inversion.

### Por que isso é promissor

Para o resultado de impacto, talvez seja possível construir um exercício weak-IV robust que dependa menos de toda a dinâmica do SDFM.

### Por que ainda não deve ser vendido como resultado formal pronto

No SDFM, \(u_y\) e \(u_x\) são objetos reconstruídos a partir de fatores/loadings estimados.

Ainda seria necessário tratar a incerteza de estimação desses objetos.

Mas como **diagnóstico de impacto conditional-on-factor-estimates**, isso pode ser extremamente útil.

---

# 16. Possível agenda metodológica: adaptar MOSW ao SDFM

Se o paper quiser avançar metodologicamente — algo que poderia elevar bastante o teto de journal — existe uma agenda clara.

## Passo 1 — problema oracle

Assumir inicialmente que:

\[
F_t,\Lambda
\]

são conhecidos.

Nesse caso o sistema fatorial é essencialmente um VAR de dimensão \(r\) ou \(q\).

Aplicar weak-IV robust inference ao sistema dos fatores.

## Passo 2 — mapear a confidence set para observáveis

Para cada vetor de impacto admissível:

\[
H_{\cdot p}\in\mathcal C_H,
\]

mapear:

\[
IRF_X(h)
=
\Lambda\Psi_hGH_{\cdot p}.
\]

Isso produz uma confidence region induzida para as IRFs observáveis.

## Passo 3 — incorporar factor-estimation error

A etapa difícil é demonstrar que:

\[
\widehat F_t-F_t
\]

e

\[
\widehat\Lambda-\Lambda
\]

são assintoticamente negligenciáveis na escala relevante da weak-IV asymptotics, ou derivar uma distribuição conjunta que os incorpore.

Em approximate factor models tradicionais, fatores têm taxas dependentes de \(N\) e \(T\).

Sob weak identification, a proxy-target correlation é local à zero, tipicamente na ordem:

\[
T^{-1/2}.
\]

A questão teórica é comparar a ordem do erro de factor estimation com essa escala.

### Essa não é uma correção trivial.

Se você não quer transformar o artigo em um paper de econometria teórica, provavelmente não vale tentar provar isso agora.

---

# 17. Recomendação pragmática sobre weak-IV

## Para a versão atual

### Manter SDFM como estimador principal.

Porque o information set amplo é parte importante da contribuição.

### Acrescentar um benchmark SVAR-IV weak-robust.

Idealmente para:

- BRL;
- CDS;
- EMBI;
- DI 6m;
- eventualmente inflação e atividade.

### Acrescentar LP-IV weak-robust para as variáveis centrais, se a validade puder ser defendida.

### Reportar resultados SDFM conditional-on-strong-instrument asymptotics com linguagem cautelosa.

### Não afirmar que o wild bootstrap resolve weak-IV.

Wild bootstrap trata heterocedasticidade/resampling da dinâmica sob o procedimento implementado.

Ele não transforma automaticamente uma razão weakly identified em um estimador regular.

---

# 18. Instrumento: tentar melhorar sem data mining

Não é necessário abandonar a proxy.

Mas vale testar melhorias economicamente motivadas.

## 18.1. Diferentes tenores do DI

Comparar:

- 3m;
- 6m;
- 1y;
- eventualmente combinação de tenores.

A escolha principal deve ser motivada por:

- liquidez;
- correspondência com o horizonte de policy expectations;
- menor sensibilidade a term premium;
- tradição na literatura brasileira.

Não por qual tenor maximiza o resultado.

---

## 18.2. Fatores de surpresa ao longo da curva

Se houver várias maturidades líquidas, construir fatores de surpresa:

\[
\Delta y_t(\tau)
=
\lambda_{\tau,1}f_{1t}
+
\lambda_{\tau,2}f_{2t}
+\cdots
\]

Conceitualmente, pode surgir algo análogo a:

- target factor;
- path factor.

Isso pode permitir separar:

\[
\text{current-policy news}
\]

de

\[
\text{future-path/forward-guidance news}.
\]

Mas essa decomposição precisa ser determinada pela estrutura das surpresas, não pelas IRFs finais.

---

# 19. O filtro de sinal deve deixar de ser “the instrument”

A versão final ficaria mais convincente se tratasse:

### Instrumento A
surpresa bruta.

### Instrumento B
surpresa residualizada por informação predeterminada.

### Instrumento C
surpresa residualizada + sign filter.

E mostrasse o resultado principal nos três.

O filtro pode ser a preferred specification, mas a conclusão não deve depender exclusivamente dele.

Isso é particularmente importante porque a crítica fiscal incide especificamente na etapa de seleção do filtro.

---

# 20. Problema 3 — seleção de \(q\)

A versão atual fixa:

\[
q=5
\]

sem critério próprio suficientemente estabelecido.

Isso precisa ser resolvido.

Executar uma grade:

\[
q\in\{2,3,4,5,\ldots\}
\]

compatível com \(r\).

Reportar para cada \(q\):

- estabilidade;
- \(\xi_{mp}\);
- impacto BRL;
- impacto CDS;
- impacto EMBI;
- impacto curva.

Não escolher \(q\) com base na força da proxy.

A mensagem desejada é:

> “The central impact responses are insensitive to the dynamic-factor dimension.”

---

# 21. Problema 4 — número de lags \(p=6\)

Com cerca de 147 inovações fatoriais e 5 fatores, VAR(6) implica muitos parâmetros dinâmicos.

O near-unit-root mode torna as IRFs de médio prazo particularmente frágeis.

Executar:

\[
p=2,3,4,6.
\]

Concentrar a avaliação em:

\[
h=0,\ldots,12.
\]

Se o resultado central for estável no curto prazo e apenas a reversão de médio prazo depender de \(p=6\), isso é bom:

> corte a interpretação da reversão e preserve o resultado de impacto.

---

# 22. Problema 5 — bootstrap com fatores estimados

Documentar precisamente o algoritmo.

É necessário saber se, a cada réplica:

1. resíduos são reamostrados;
2. pseudo-dados \(X_t^*\) são reconstruídos;
3. fatores \(\widehat F_t^*\) são reestimados por PCA;
4. loadings \(\widehat\Lambda^*\) são reestimados;
5. VAR dos fatores é reestimado;
6. proxy identification é refeita;
7. normalização é refeita.

Se fatores/loadings são mantidos fixos, as bandas são **conditional-on-estimated-factors**.

Isso deve ser explicitado.

Idealmente, produzir também um **full re-estimation bootstrap**.

Isso não resolve weak-IV, mas resolve uma fonte distinta de incerteza.

---

# 23. Problema 6 — “UIP inverted” é uma claim mais forte do que a evidência atual

Uma resposta contemporânea:

\[
BRL\downarrow
\]

após uma surpresa monetária não é, por si só, uma violação direta da condição UIP.

A UIP envolve:

\[
i_t-i_t^*
=
E_t[\Delta s_{t+1}]
+
rp_t.
\]

Para chamar o mecanismo de “risk-premium transmission” de forma mais forte, seria ideal obter alguma medida/decomposição de:

\[
rp_t^{FX}.
\]

Possibilidades:

- expected exchange-rate changes de surveys;
- forward rates;
- excess currency returns;
- decomposição de expected depreciation versus risk premium.

Se isso não for possível, a linguagem deve ser:

> “an exchange-rate response opposite to the conventional interest-differential channel, accompanied by sovereign-risk repricing.”

Isso é forte e defensável sem overclaim.

---

# 24. Problema 7 — narrativa fiscal precisa de evidência fiscal adicional

Hoje o artigo mostra:

\[
MP\uparrow
\rightarrow
CDS\uparrow,\ EMBI\uparrow,\ BRL\downarrow.
\]

Isso identifica **sovereign-risk repricing**, não necessariamente sua origem fiscal.

Para fortalecer a interpretação:

## 24.1. State dependence

Estimar se o efeito depende de fiscal stress predeterminado.

Por exemplo:

\[
IRF^{HighFiscalRisk}
\]

versus

\[
IRF^{LowFiscalRisk}.
\]

Se:

\[
BRL:\quad
IRF^{High}>0,
\qquad
IRF^{Low}\le0,
\]

e o mesmo ocorrer para CDS/EMBI, a narrativa fica muito mais forte.

---

## 24.2. Interação com estrutura/custo da dívida

Testar proxies predeterminadas de:

- dívida/PIB;
- parcela pós-fixada/Selic;
- custo médio;
- maturidade;
- necessidade de refinanciamento;
- resultado primário esperado.

O mecanismo moderno proposto é:

\[
\uparrow i
\rightarrow
\uparrow \text{expected debt-service burden}
\rightarrow
\uparrow \text{sovereign risk}
\rightarrow
BRL\downarrow.
\]

É necessário mostrar alguma evidência de que a primeira seta é relevante no regime 2013–2025.

---

# 25. Problema 8 — contraste com Gonçalves et al.

Hoje temos:

\[
\text{daily heteroskedasticity ID}
\Rightarrow
BRL\uparrow,\quad CDS\approx0,
\]

contra:

\[
\text{monthly SDFM-IV}
\Rightarrow
BRL\downarrow,\quad CDS\uparrow.
\]

Existem duas mudanças simultâneas:

1. frequência;
2. identificação/modelo.

Portanto não é possível dizer qual gera a divergência.

### Exercício muito valioso

Tentar aproximar um desenho do outro.

Exemplos:

- usar sua proxy em um VAR/LP diário quando possível;
- agregar o choque de Gonçalves à frequência mensal;
- usar sua proxy em pequeno SVAR para comparar com SDFM;
- replicar o resultado deles sobre amostra comum.

A pergunta:

> “frequency or identification?”

pode virar uma contribuição adicional.

---

# 26. Problema 9 — magnitudes grandes de atividade

As respostas de impacto de alguns setores são muito grandes relativamente a um choque de 50 pb.

Isso pode refletir:

- verdadeira sensibilidade;
- normalização amplificada por primeiro estágio fraco;
- fator comum;
- transformação/escala.

Executar auditoria de escala.

Para cada variável importante:

\[
IRF_{economic\ units}
=
\text{loading/dynamic response}
\times
\text{normalization}.
\]

Verificar mecanicamente cada conversão.

Enquanto weak-IV não estiver resolvido, evitar vender essas magnitudes como precisão estrutural.

---

# 27. Problema 10 — price puzzle

O aperto produz:

\[
PPI\uparrow,\quad
IGP\uparrow,\quad
\text{alguns núcleos}\uparrow.
\]

Existem duas histórias:

### História econômica

\[
MP\uparrow
\rightarrow
BRL\downarrow
\rightarrow
imported\ inflation\uparrow.
\]

### História de identificação

O instrumento ainda contém informação/choques não monetários.

Para diferenciar:

1. mostrar timing entre BRL, PPI e CPI;
2. verificar robustez sem sign filter;
3. verificar robustez com outras proxies;
4. verificar se inflação sobe especialmente nos episódios de maior depreciação;
5. comparar com LP/SVAR alternativos.

---

# 28. Problema 11 — inconsistências documentais

Antes de submissão:

- padronizar 106 vs 111 séries;
- padronizar \(\xi_{mp}=6.27\) vs 7.65;
- remover pendência do `cumsum`;
- verificar todas as magnitudes no abstract;
- garantir que tabelas, texto e arquivos de produção apontem para a mesma run.

## Recomendação

Criar um arquivo automático:

`paper_numbers.json`

ou

`paper_numbers.tex`

gerado diretamente pela pipeline.

Exemplo:

```tex
\newcommand{\ImpactBRL}{5.55}
\newcommand{\ImpactCDS}{43.4}
\newcommand{\ImpactEMBI}{32.0}
\newcommand{\XiMain}{6.27}
\newcommand{\NSeries}{111}
```

O texto nunca deve conter números digitados manualmente quando eles vêm da estimação.

---

# 29. Ordem de prioridade

## Prioridade 0 — antes de qualquer submissão

1. resolver inconsistências numéricas;
2. resolver `cumsum`;
3. documentar bootstrap;
4. justificar/variar \(q\);
5. variar \(p\).

---

## Prioridade 1 — identificação

1. auditoria reunião por reunião;
2. leave-one-out;
3. fiscal-news confounding;
4. variantes da proxy;
5. testar concentração do resultado em episódios específicos.

---

## Prioridade 2 — weak-IV

1. manter diagnósticos de relevância;
2. implementar proxy-SVAR weak-IV robust para BRL/CDS/EMBI;
3. considerar LP-IV com AR/weak-IV robust inference;
4. tratar MOSW sobre fatores estimados apenas como exercício conditional/oracle, salvo desenvolvimento teórico adicional;
5. não dizer que wild bootstrap resolve weak identification.

---

## Prioridade 3 — mecanismo fiscal

1. state dependence;
2. medidas predeterminadas de fiscal stress;
3. estrutura e custo da dívida;
4. currency risk premium, se possível.

---

# 30. O que considero suficiente para uma versão forte sem criar nova teoria econométrica

Não é necessário resolver formalmente “weak-IV inference in Proxy DFM” para tornar o paper publicável.

Uma estratégia empiricamente convincente poderia ser:

### Main model
SDFM-IV com amplo information set.

### Identification robustness
- proxy bruta;
- residualizada;
- residualizada + filtro;
- leave-one-out;
- auditoria fiscal dos eventos.

### Weak-IV robustness
- SVAR-IV com MOSW/AR confidence sets para os resultados centrais;
- LP-IV weak-robust para BRL/CDS/EMBI, quando a hipótese de validade for defensável.

### Model robustness
- diferentes \(p\);
- diferentes \(q\);
- full factor re-estimation bootstrap.

### Economic mechanism
- fiscal-state dependence.

Se o mesmo padrão surgir em todos:

\[
BRL\downarrow,
\qquad
CDS\uparrow,
\qquad
EMBI\uparrow,
\]

fica muito difícil para um referee atribuir tudo a um artefato específico do SDFM.

---

# 31. O que seria necessário para transformar o problema weak-IV em contribuição metodológica

Se houver interesse em elevar o paper para uma contribuição econométrica, o problema poderia ser formulado como:

> **Weak-proxy robust inference in structural dynamic factor models with estimated factors.**

A contribuição exigiria:

1. weak-proxy asymptotics no sistema fatorial;
2. tratamento do erro de factor estimation;
3. confidence sets para vetor de impacto;
4. mapeamento das confidence sets para observáveis;
5. bootstrap/test inversion válido;
6. Monte Carlo calibrado para \(N\approx 111,T\approx153\).

Isso é praticamente outro paper.

Para o artigo substantivo sobre Brasil, minha recomendação é **não transformar a pesquisa nisso**.

---

# 32. Decisão recomendada

## Não abandonar o instrumento apenas porque \(\xi_{mp}\) está abaixo de uma referência confortável.

O problema institucional do Copom torna a busca por uma proxy muito superior potencialmente inviável.

## Não ignorar weak-IV.

A significância convencional deve ser tratada com cautela.

## Não transplantar automaticamente MOSW para o DFM.

Sem teoria adicional, isso seria vulnerável.

## Usar modelos auxiliares onde a inferência weak-IV robust já existe.

Isso permite responder à crítica de maneira honesta e tecnicamente defensável.

## Concentrar a claim no padrão conjunto de impacto.

O paper é muito mais forte em:

\[
h=0,\ldots,4
\]

que nas reversões de 20–40 meses.

---

# 33. Literatura metodológica prioritária

### Montiel Olea, Stock & Watson
**Inference in Structural Vector Autoregressions Identified with an External Instrument.**  
*Journal of Econometrics*, 2021.

Base para weak-IV robust inference em proxy-SVAR.

### Stock & Watson
**Identification and Estimation of Dynamic Causal Effects in Macroeconomics Using External Instruments.**  
*The Economic Journal*, 2018.

Fundamental para:

- SVAR-IV vs LP-IV;
- invertibilidade;
- lead-lag exogeneity;
- instrumentos fracos.

### Alessi & Kerssenfischer
**The Response of Asset Prices to Monetary Policy Shocks: Stronger than Thought.**  
*Journal of Applied Econometrics*, 2019.

Precedente direto de:

\[
DFM + external\ instrument.
\]

### Brignone, Franconi & Mazzali
**Robust Impulse Responses using External Instruments: the Role of Information.**  
Preprint, 2023.

Propõe explicitamente Proxy DFM e discute informação, measurement error e non-invertibility.

Não deve ser citado como solução pronta para weak-IV robust inference no DFM.

### Angelini, Cavaliere & Fanelli
**An Identification and Testing Strategy for Proxy-SVARs with Weak Proxies.**  
*Journal of Econometrics*, 2024.

Desenvolvimento recente de identificação/testes para weak proxies no proxy-SVAR.

---

# 34. Perguntas que o paper precisa conseguir responder antes da submissão

1. **Por que o instrumento é monetário e não fiscal?**
2. **O resultado depende do sign filter?**
3. **Uma única reunião determina BRL/CDS/EMBI?**
4. **O sinal sobrevive a diferentes \(p\) e \(q\)?**
5. **Qual é exatamente a força da proxy na especificação final?**
6. **Qual inferência continua válida se a proxy for weak?**
7. **Os resultados centrais aparecem em um SVAR-IV com weak-IV robust CI?**
8. **Os resultados aparecem em LP-IV?**
9. **O bootstrap reestima os fatores?**
10. **A interpretação fiscal muda com o estado fiscal ex ante?**
11. **O paper está mostrando sovereign-risk repricing ou realmente currency risk premium?**
12. **Por que o resultado difere de Gonçalves et al.?**
13. **Os números do texto são produzidos automaticamente pela última estimação?**

Se essas perguntas forem respondidas de maneira convincente, a qualidade do artigo muda substancialmente.

---

# 35. Diagnóstico final

O problema atual não é:

> “o instrumento não presta”.

É:

> **a combinação de uma proxy apenas moderadamente relevante com uma janela institucionalmente larga torna a identificação mais vulnerável justamente porque o resultado encontrado — depreciação e abertura do risco soberano — também é o padrão de uma notícia fiscal doméstica.**

E o problema econométrico não é:

> “faltou aplicar o método weak-IV padrão”.

É:

> **a teoria weak-IV robust consolidada é para proxy-SVAR/IV, enquanto o estimador principal é um SDFM com fatores estimados. Uma aplicação mecânica não tem, até onde a literatura localizada neste levantamento mostra, garantia formal equivalente.**

A resposta correta é triangulação:

\[
\boxed{
SDFM
+
event\ diagnostics
+
alternative\ proxies
+
weak\text{-}robust\ SVAR/LP
+
fiscal\ state\ dependence
}
\]

em vez de procurar uma única correção milagrosa.


# 36. Como interpretar corretamente a robustez SVAR/LP weak-IV

Esta seção explicita o papel dos modelos auxiliares com inferência robusta a instrumento fraco.

A lógica NÃO é:

\[
\text{SDFM encontra um resultado}
\quad\Rightarrow\quad
\text{SVAR confirma que o SDFM está correto}.
\]

A lógica correta é:

\[
\text{SDFM-IV}
\Rightarrow
BRL\downarrow,\ CDS\uparrow,\ EMBI\uparrow,
\]

mas as bandas convencionais do SDFM podem ser pouco confiáveis quando a proxy é apenas moderadamente relevante.

Então estimamos, com **a mesma proxy**, um modelo para o qual existe teoria formal de weak-IV robust inference:

\[
\text{SVAR-IV}
\]

e, como exercício adicional,

\[
\text{LP-IV}.
\]

A pergunta passa a ser:

> **O resultado qualitativo central sobre câmbio e risco soberano sobrevive quando a inferência é feita em um ambiente no qual weak identification pode ser tratada formalmente?**

---

## 36.1. Por que isso é uma robustez informativa

Os modelos têm vulnerabilidades diferentes.

### SDFM-IV

Vantagem:

\[
\text{information-rich system}
\]

com amplo conjunto de informação e menor vulnerabilidade ao problema de missing information/non-fundamentalness.

Limitação:

\[
\text{weak-IV robust inference no DFM com fatores estimados}
\]

não está formalmente estabelecida na mesma forma que no proxy-SVAR.

### SVAR-IV

Vantagem:

\[
\text{weak-IV robust inference disponível}.
\]

Limitação:

\[
\text{information set pequeno}.
\]

Portanto:

\[
\boxed{
\text{SDFM: informação ampla, inferência weak-IV incompleta}
}
\]

\[
\boxed{
\text{SVAR: inferência weak-IV formal, informação limitada}
}
\]

Se ambos apontam na mesma direção, o resultado ganha credibilidade por **triangulação**.

---

## 36.2. Como escrever a conclusão se os resultados coincidirem

Suponha:

\[
IRF^{SDFM}_{BRL}(0)>0,
\]

\[
IRF^{SDFM}_{CDS}(0)>0,
\]

\[
IRF^{SDFM}_{EMBI}(0)>0.
\]

E, no SVAR-IV com confidence sets robustos a weak identification:

\[
CI^{weak}_{BRL}(0)\subset(0,\infty),
\]

\[
CI^{weak}_{CDS}(0)\subset(0,\infty),
\]

\[
CI^{weak}_{EMBI}(0)\subset(0,\infty).
\]

A conclusão apropriada é:

> **The central qualitative result is robust to weak-instrument inference in an alternative lower-dimensional specification.**

Ou:

> **The joint depreciation of the BRL and widening of sovereign spreads is not an artifact of conventional strong-instrument inference in the SDFM.**

Evitar:

> “The SVAR proves that the SDFM estimates are correct.”

O SVAR não valida toda a dinâmica do SDFM; ele fornece evidência independente sobre o mesmo fato empírico.

---

## 36.3. O cenário ideal

Uma tabela de robustez poderia ter a forma:

| Modelo | BRL | CDS | EMBI |
|---|---|---|---|
| SDFM-IV | deprecia | sobe | sobe |
| SVAR-IV convencional | deprecia | sobe | sobe |
| SVAR-IV weak-robust | rejeita \(BRL\leq0\) | rejeita \(CDS\leq0\) | rejeita \(EMBI\leq0\) |
| LP-IV weak-robust | mesmo sinal | mesmo sinal | mesmo sinal |

Esse resultado seria particularmente convincente porque:

1. o SDFM usa information set amplo;
2. o SVAR trata formalmente weak identification;
3. o LP reduz dependência da especificação dinâmica do VAR;
4. todos apontam para o mesmo padrão de impacto.

---

## 36.4. Cenário intermediário

Pode ocorrer:

\[
\widehat{IRF}^{SDFM}_{BRL}(0)=+5.55\%,
\]

mas:

\[
CI^{weak}_{SVAR,BRL}(0)
=
[-4\%,+12\%].
\]

Nesse caso, o resultado do SVAR é compatível com depreciação, mas não rejeita apreciação.

A conclusão deve ser enfraquecida:

> **The SDFM point estimate indicates depreciation, but weak-IV robust inference in a lower-dimensional model is too imprecise to reject the conventional response.**

Isso não invalida automaticamente o SDFM, pois o pequeno SVAR pode sofrer de missing information.

Mas impede afirmar que a evidência sobre o sinal do câmbio é robusta à weak identification.

---

## 36.5. Cenário particularmente informativo

Pode ocorrer que os confidence sets weak-IV robustos sejam informativos para:

\[
BRL,\ CDS,\ EMBI,
\]

mas muito largos para:

\[
atividade,\ inflação,\ crédito.
\]

Isso seria um bom resultado para o artigo.

Nesse caso, a contribuição deve ser deliberadamente concentrada no bloco financeiro de curto prazo:

\[
\boxed{
FX + sovereign risk + yield curve
}
\]

e as respostas macroeconômicas de médio prazo devem ser apresentadas como secundárias.

Isso seria coerente com a própria evidência atual do SDFM, que é muito mais precisa no impacto do que em horizontes longos.

---

# 37. Ordem recomendada dos modelos de robustez

## 37.1. Modelo principal

\[
\boxed{\text{SDFM-IV}}
\]

Deve permanecer como especificação principal porque o amplo conjunto de informação é parte importante da motivação do artigo.

---

## 37.2. Primeira robustez: SVAR-IV weak-robust

Começar por um pequeno SVAR.

Por exemplo:

\[
Y_t
=
[
DI_{6m,t},
FX_t,
CDS_t,
\pi_t,
y_t
]'.
\]

E uma especificação paralela substituindo CDS por EMBI.

Possivelmente também uma versão:

\[
[
DI_{6m,t},
FX_t,
CDS_t,
EMBI_t,
y_t
]'.
\]

O objetivo não é reproduzir as 111 séries do SDFM.

O objetivo é testar formalmente:

\[
H_0:
IRF_{FX}(h)\le0,
\]

\[
H_0:
IRF_{CDS}(h)\le0,
\]

\[
H_0:
IRF_{EMBI}(h)\le0,
\]

sob inferência robusta à força da proxy.

O foco deve ser:

\[
h=0,\ldots,4,
\]

ou no máximo o curto prazo.

---

## 37.3. Segunda robustez: LP-IV weak-robust

O LP-IV é útil porque não depende da dinâmica estimada de um VAR.

Mas ele possui requisitos diferentes de validade instrumental.

Em particular, a condição lead-lag pode ser mais restritiva.

Logo, deve entrar como:

> **additional robustness exercise**

e não necessariamente como substituto do SVAR-IV.

Se os três métodos produzirem:

\[
BRL\downarrow,\quad CDS\uparrow,\quad EMBI\uparrow,
\]

a triangulação fica muito forte.

---

# 38. A mesma proxy deve ser usada nos modelos auxiliares

Esse ponto é essencial.

O objetivo da robustez NÃO é encontrar um instrumento novo que funcione melhor no SVAR.

O objetivo é manter fixo:

\[
z_t
\]

e alterar apenas o ambiente econométrico de inferência.

Assim:

\[
\text{same proxy}
+
\text{different estimator/inference}.
\]

Se a proxy for diferente, não será possível saber se a diferença vem:

1. do modelo;
2. da inferência;
3. do instrumento.

A comparação limpa requer usar a mesma medida de surpresa monetária.

---

# 39. O que esse exercício resolve e o que ele NÃO resolve

## Resolve parcialmente

### Weak-IV inference

Se o SVAR/LP weak-robust produz confidence sets informativos, ele mostra que o resultado qualitativo não depende exclusivamente da aproximação strong-IV usada nas bandas do SDFM.

### Model dependence

Se SVAR, LP e SDFM apontam na mesma direção, o resultado não parece depender de uma única especificação dinâmica.

---

## NÃO resolve

### Fiscal-news contamination

Se a proxy contém notícia fiscal:

\[
z_t
=
\text{monetary shock}
+
\text{fiscal news},
\]

SVAR, LP e SDFM podem todos produzir:

\[
BRL\downarrow,\quad CDS\uparrow,\quad EMBI\uparrow
\]

porque todos usam a mesma proxy contaminada.

Portanto:

\[
\boxed{
\text{weak-IV robustness}
\neq
\text{instrument validity}
}
\]

Os exercícios de fiscal-news confounding continuam indispensáveis.

---

# 40. Estratégia final de identificação em duas frentes

A versão forte do artigo precisa responder a dois referees diferentes.

## Referee A — “a proxy é fraca”

Resposta:

1. reportar força;
2. manter SDFM;
3. estimar SVAR-IV weak-robust;
4. estimar LP-IV weak-robust;
5. mostrar que o padrão central sobrevive.

---

## Referee B — “a proxy é fiscal, não monetária”

Resposta:

1. auditoria reunião por reunião;
2. leave-one-out;
3. exclusão de eventos fiscais;
4. variantes sem sign filter;
5. controles predeterminados;
6. event-study/narrative evidence;
7. mostrar que o resultado não depende de reuniões com fiscal news.

As duas respostas são complementares.

---

# 41. Claim correta após a triangulação

Se os resultados forem favoráveis, a conclusão mais forte defensável seria:

> **A contractionary monetary-policy surprise is followed by BRL depreciation and widening sovereign spreads in the information-rich SDFM. The same qualitative pattern is recovered in lower-dimensional SVAR/LP specifications using inference robust to weak instruments. This indicates that the central result is not driven solely by strong-instrument asymptotics in the factor model.**

Ainda assim, a validade da interpretação monetária depende dos exercícios separados sobre fiscal-news contamination.

Essa distinção deve permanecer explícita ao longo do paper.
