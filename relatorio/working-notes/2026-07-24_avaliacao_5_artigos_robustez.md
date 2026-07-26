# Avaliação dos 5 artigos de identificação — dá para integrar ao framework e reforçar a robustez?

**Data:** 2026-07-24 · **Autor da nota:** revisão de leitura (skill `split-pdf-md`, notas
por artigo em `artigos/*/‹basename›_notes.md`).
**Escopo (decisão do usuário):** só avaliação e recomendação — nenhuma estimação foi
rodada no painel nesta entrega.

---

## 0. Contexto e a pergunta

Depois de corrigir a base (refresh de vintage, 106 séries, 2026-07-24), a produção migrou
para **(r,q) = (7,6)** — a única dimensão da varredura com **ξ_mp > 10 nas duas janelas
(10,43 full / 12,22 pre-COVID)**. O problema: 10,43 está *raspando* o limiar Stock-Yogo
(10) e algumas IRFs estão ambíguas. A identificação de produção continua sendo o
**proxy-SVAR** (instrumento externo `z_jk_bs_purif`) projetado nas **q inovações do VAR
de fatores** (`ident_ext_instr`: `H = (Z'η)/(Z'Z)`). O pivô para heterocedasticidade
(2026-07-16) foi reprovado empiricamente. A pergunta: qual dos 5 artigos dá para **integrar
ao framework** (SDFM frequentista + proxy-SVAR + wild bootstrap Gonçalves-Kilian) para
**reforçar a robustez**, com atenção ao receio de que **alguns são bayesianos**?

Os 5 artigos preenchem exatamente o menu de identificação que o autor já tinha em aberto
(`_instrucoes/pendencias.md` linha 26: sign restrictions, não-gaussianidade/ICA
Lanne-Meitz-Saikkonen, set-ID bayesiana).

---

## 1. Veredito em uma tabela

| # | Artigo | Paradigma | O que faz pela robustez | Papel vs. o proxy | Integrável no SDFM? | Custo | Tier |
|---|--------|-----------|--------------------------|-------------------|---------------------|-------|------|
| 1 | **Lanne-Meitz-Saikkonen 2017** (JoE) | **Frequentista** (ML) | ID por não-gaussianidade; **torna as restrições do proxy testáveis** | **Identifica independente** do proxy (proxy só rotula) | **Sim, barato** — `svars::id.ngml` nas inovações η | Baixo | **1** |
| 2 | **Gouriéroux-Monfort-Renne 2017** (JoE) | **Frequentista** (pseudo-ML/ICA) | Igual ao #1, mas robusto a erro na densidade | **Identifica independente** do proxy | **Sim, barato** — `svars::id.dc`/`id.cvm` | Baixo | **1** |
| 3 | **Braun-Brüggemann 2022/2023** (BoE/JBES) | **Bayesiano** (MCMC) | Sign restrictions **afiam** o proxy fraco / "plausivelmente exógeno"; **testa exogeneidade** via Bayes factor | **Complementa** o proxy (mesma coluna) | Sim, com plumbing (fatores + sinais em espaço de observáveis) | Médio-alto | **1b** |
| 4 | **Caldara-Herbst 2019** (AEJ:Macro) | **Bayesiano** (MCMC/SMC) | **Inferência válida mesmo com proxy fraco** (verossimilhança conjunta) | **Substitui** a maquinaria do proxy (versão bayesiana do que já se faz) | Sim, com adaptação a fatores | Médio-alto | **2** |
| 5 | **Antolín-Díaz-Rubio-Ramírez 2018** (AER) | **Bayesiano** (set-ID) | Restrições narrativas em **episódios históricos** sharpen o conjunto | **Identifica independente** (combinável com proxy) | Sim, maior esforço (sign-ID base + fatores + trabalho de episódios) | Alto | **3** |

**Achado que molda tudo:** os dois métodos *feitos sob medida* para o problema exato do
usuário (proxy fraco no limiar) — **Braun-Brüggemann** e **Caldara-Herbst** — são **ambos
bayesianos**. A única rota **frequentista** de robustez é o par não-gaussiano (LMS + GMR),
que ainda por cima **transforma o proxy numa restrição sobre-identificadora testável** e é
a mais barata de acoplar (tem pacote R nativo). Ou seja: o receio bayesiano é bem fundado —
mas há uma saída frequentista forte, e ela é a mais barata.

---

## 2. O gargalo comum aos cinco: nenhum é escrito para modelo de fatores

Todos os 5 são formulados para um **SVAR pequeno**. O framework do projeto identifica o
choque nas **q inovações do VAR de fatores** η e propaga para as ~106 observáveis via os
loadings Λ (Alessi-Kerssenfischer). Portanto **cada método precisa da adaptação "identificar
no espaço dos q fatores e propagar via Λ"** — que o código **já faz** para os ramos `proxy`
e `het`:

- ponto de extensão: `compute_irf_dfm(..., identification = c("proxy","het"))` e
  `main_sdfm` (`R/modeling/impulse_responde.R:304`), com `ident_ext_instr` /
  `ident_het_regimes` mostrando o padrão de um ramo novo que consome `eta` e devolve IRFs
  no mesmo formato.

Consequência prática dessa camada:
- **Métodos não-gaussianos (#1, #2)**: identificam a matriz de mistura das η diretamente —
  encaixe limpo (η são exatamente os "resíduos de forma reduzida" que a ICA pede).
- **Sign/narrative (#3, #5)**: a rotação é q×q, mas as **restrições de sinal vivem no
  espaço das observáveis** (curva ↑, IBOV ↓, atividade ↓ em h=24), que são Λ·(IRF de
  fator). É preciso impor os sinais nas IRFs propagadas — factível, mas é plumbing que os
  pacotes MATLAB não fazem.
- **Proxy bayesiano (#4)**: roda o sistema aumentado nas q inovações com `m_t = z`, depois
  mapeia para observáveis por Λ.

Nenhum dos pacotes de replicação (MATLAB) faz esse mapeamento de fatores — ele é sempre
trabalho do projeto, em qualquer dos cinco.

---

## 3. Fichas por artigo

### #1 — Lanne, Meitz & Saikkonen (2017, *J. Econometrics*) — SVAR não-gaussiano por ML
- **Ideia:** se as q inovações estruturais são **mutuamente independentes e não-gaussianas
  (no máximo uma gaussiana)**, o SVAR é identificado **sem restrição econômica nenhuma**
  (Prop. 1: até permutação/escala; Prop. 2 + Identification Scheme: identificação
  completa). Estimação por **ML** (densidade paramétrica por componente, ex. Student-t com
  ν próprio), consistente e assintoticamente normal. **Estimador em três passos** feito
  exatamente para T curto / dimensão alta.
- **Por que serve à robustez:** a identificação **não usa o instrumento** — o proxy entra
  só para **rotular** a coluna monetária (maior |corr| com `z_jk_bs_purif`). Se a coluna
  identificada por não-gaussianidade **bater** com a do proxy, é corroboração forte e
  **robusta a IV fraco**. E como B fica completamente identificado com assintótica padrão,
  a restrição implícita do proxy vira **testável** (Wald/LR) — algo que o pipeline
  frequentista atual não produz.
- **Pré-requisito:** inovações fatoriais não-gaussianas com ≤ 1 gaussiana. Plausível
  (Brasil + COVID → caudas pesadas), mas **precisa de um teste barato (JB/curtose) em η**
  antes de investir. A aplicação do próprio paper roda com **T=74** — o projeto tem T=147.
- **Não cobre** heterocedasticidade **incondicional** (Rigobon 2003) — ou seja, é ortogonal
  ao que já foi reprovado no pivô het; cobre het *condicional*.
- **Código:** `svars::id.ngml` (R nativo, CRAN/GitHub). Menor custo dos cinco.
- **Veredito:** **integrável, frequentista, alto valor. Tier 1.**

### #2 — Gouriéroux, Monfort & Renne (2017, *J. Econometrics*) — ICA por pseudo-ML
- **Ideia:** a versão **semi-paramétrica** do #1. Mesma identificação por não-gaussianidade,
  mas estimação por **pseudo-ML** que é **consistente mesmo com a densidade errada**
  (Prop. 3) — não exige acertar a Student-t. Assintoticamente normal (Prop. 4). Testes de
  Wald para as restrições usuais (sobre-identificadoras no caso não-gaussiano).
- **A "curtose" que o usuário mencionou mora aqui:** ICA por cumulantes de 3ª/4ª ordem
  (skew/curtose) é um caso particular — e o paper mostra que é **subótimo** (Corolário 1),
  especialmente perto da gaussiana. Ou seja: **não** maximizar curtose cru; usar ICA
  baseada em dependência (distance covariance / Cramér-von Mises) ou pseudo-ML adaptativo.
- **Papel:** idêntico ao #1 (identifica independente, rotula pelo proxy). É o **par de
  robustez** de #1: LMS = ML paramétrico (chuta densidade); GMR = pseudo-ML (imune ao chute).
  Reportar os dois blinda a rota não-gaussiana contra a hipótese distribucional.
- **Código:** `svars::id.dc` / `id.cvm` (R nativo). MC do paper mostra boa aproximação já
  em T=200 (o projeto tem 147, na mesma ordem).
- **Veredito:** **integrável, frequentista, mesmo papel de robustez que #1. Tier 1.**

### #3 — Braun & Brüggemann (2022 BoE WP 961 / 2023 *JBES*) — sign restrictions + instrumento
- **Ideia:** SVAR B-model **aumentado** com equação de medida `m_t = Φ ε_t + Σ_η^{1/2} η_t`.
  Dois cenários: **(1)** instrumento válido + sign restrictions para "**pin down mais
  precisamente em amostras finitas**" (útil quando o IV é **fracamente informativo**);
  **(2)** proxy só "**plausivelmente exógeno**" → substitui exogeneidade por **desigualdades**
  (limiar de correlação, contribuição de variância `ω_1 > Σ ω_j`) + sign restrictions.
- **Por que é o mais on-point:** ataca **os dois** problemas do usuário de uma vez —
  (a) o proxy é, na melhor hipótese, *plausivelmente* exógeno (a crítica RS-2004 à janela
  Qua→Qui que o próprio autor levantou no pivô), e (b) está fraco/no limiar. A aplicação de
  MP do paper é o espelho do caso do usuário: o Bayes factor **rejeita a exogeneidade** do
  choque narrativo (Romer-Romer) mas, mantendo-o como *plausivelmente exógeno* via
  `ω_1 > Σ ω_j`, o conjunto **encolhe** e as respostas financeiras ficam claras — o oposto
  do "set-ID é largo demais".
- **Bônus:** dá um **teste de exogeneidade do proxy** (Bayes factor / Savage-Dickey) que o
  pipeline atual não tem.
- **Custo:** **bayesiano** (MCMC, prior conjugada B-model + Minnesota); é um segundo aparato
  de inferência ao lado do wild bootstrap. Adaptação a fatores + sinais em espaço de
  observáveis. O sampler (proposta Arias et al. 2018) não trata exclusão sobre-identificada
  (um choque, vários instrumentos) — **irrelevante aqui** (um choque, um instrumento).
- **Código:** replicação MATLAB (JBES 2023; a maquinaria reusa o toolbox Arias-Rubio-
  Ramírez-Waggoner 2018). *Confirmar o repositório exato.* Não faz o mapeamento de fatores.
- **Veredito:** **o mais sob medida para o problema, porém bayesiano. Tier 1b.**

### #4 — Caldara & Herbst (2019, *AEJ:Macro*) — Bayesian Proxy SVAR (BP-SVAR)
- **Ideia:** põe o proxy **dentro de uma verossimilhança conjunta** com o SVAR
  (`m_t = β e_MP,t + σ_ν ν_t`; relevância ρ = β²/(β²+σ_ν²) = razão sinal-ruído). A
  verossimilhança fatoriza em `p(Y|Φ,Σ)·p(M|Y,·)`; o estimador dá mais peso a parâmetros
  cujo choque implícito **se parece com uma versão escalada do proxy**.
- **Por que é a resposta de manual ao problema do usuário:** vantagem nº 1 do paper —
  "**inferência válida mesmo se o conteúdo do proxy é fraco**". Em bayesiano, weak-ID não é
  problema *per se* (prior próprio ⇒ inferência válida; Poirier 1998), enquanto o
  frequentista precisa de teoria weak-IV (MOSW) **ou** de um bootstrap com boa cobertura —
  e os próprios autores notam que bootstraps de proxy-SVAR "**só valem para instrumento
  forte**" (Jentsch-Lunsford). É exatamente a fragilidade do ξ_mp = 10,43 raspando o limiar
  com wild bootstrap. Prior de "alta relevância" permite apertar as bandas se você confia no
  proxy; sampler SMC é robusto justamente quando o posterior é irregular (proxy fraco).
- **Bônus temático:** o achado substantivo (a regra de política reage a **spreads de
  crédito**) é diretamente testável no painel do Brasil (spreads ICC, EMBI/CDS) e conversa
  com o "puzzle de compressão de spread" já documentado no projeto.
- **Custo:** **bayesiano** (MCMC/SMC + Minnesota/relevance prior). Escrito para VAR pequeno;
  adaptação a fatores. Segundo aparato de inferência.
- **Código:** pacote de replicação AEA/openICPSR (MATLAB, sampler BP-SVAR público, reusado
  pela literatura). *Confirmar handle.*
- **Veredito:** **melhor endereçamento direto do weak-IV, mas bayesiano; ideal como apêndice
  de robustez. Tier 2.**

### #5 — Antolín-Díaz & Rubio-Ramírez (2018, *AER*) — narrative sign restrictions
- **Ideia:** restrições de sinal sobre **episódios históricos documentados** — (A) sinal do
  choque numa data ("houve choque monetário contracionista no mês X"); (B) restrições na
  **decomposição histórica** (um choque foi o driver "mais importante"/"dominante" do
  movimento inesperado de uma variável num episódio). Tradicionais truncam o **prior**;
  narrativas truncam a **verossimilhança** (reponderação por importance sampling sobre o
  toolbox ARRW 2018).
- **Por que serve:** **explora os episódios bem documentados do Brasil** — crise fiscal 2015
  + Dilma, impeachment 2016, ciclo de alta da Selic 2021-22, corte COVID 2020, surpresas de
  Copom específicas. O headline do paper: **um único evento** já pode sharpen (ou virar) a
  inferência. Independe da força do instrumento e é **combinável com o proxy**
  (Braun-Brüggemann nota que proxy "plausivelmente exógeno" é primo de restrição narrativa).
- **Custo (o maior dos cinco):** **bayesiano + set-ID** — a maior ruptura com o pipeline
  ponto + wild bootstrap (passa a um posterior sobre um conjunto). Exige um **SVAR com sign
  restrictions tradicionais como base** (narrativa só complementa) → primeiro é preciso
  montar um DFM sign-identified. Adaptação a fatores com decomposição histórica em espaço de
  observáveis. E **trabalho de dados/julgamento** para escolher e defender os episódios.
- **Código:** replicação AER/openICPSR (MATLAB, extensão do toolbox ARRW/RWZ). *Confirmar.*
- **Veredito:** **valioso e distintivo (usa a história do Brasil), mas maior esforço e
  paradigma mais distante. Tier 3.**

---

## 4. O receio bayesiano — leitura honesta

**Sim, 3 dos 5 são bayesianos**, e — inconvenientemente — os dois que melhor resolvem
"proxy fraco no limiar" (Braun-Brüggemann, Caldara-Herbst) estão entre eles. Mas *bayesiano
não é desqualificante*; é uma **troca**:

- **Custo real:** um **segundo aparato de inferência** (MCMC/SMC + priors) ao lado do wild
  bootstrap Gonçalves-Kilian. Priors precisam ser declarados e defendidos (em set-ID o
  prior não some na amostra grande). Reescrita de bandas: passam a ser **credible sets**, e
  em set-ID o objeto é um posterior sobre um **conjunto**, não um ponto.
- **Contraponto favorável:** um **apêndice de robustez bayesiano** é padrão e defensável na
  literatura — e no caso weak-IV é *exatamente onde a Bayes tem vantagem teórica* (inferência
  válida sem depender do ξ_mp cruzar 10, sem depender da cobertura do bootstrap para
  instrumento fraco, que a própria literatura diz valer só para instrumento forte).
- **A saída frequentista existe e é a mais barata:** a rota **não-gaussiana (LMS + GMR)**
  preserva o paradigma do paper (ponto por OLS + wild bootstrap para as bandas do choque
  rotulado), roda em **R nativo** e ainda **testa o proxy** como restrição sobre-
  identificadora. É a que melhor casa com o receio.

**Regra prática:** manter o **primário frequentista** (proxy-SVAR atual) e adicionar
robustez em duas camadas — (i) uma **frequentista barata** (não-gaussianidade) que
corrobora sem depender do IV; (ii) opcionalmente **uma** rodada bayesiana (Caldara-Herbst
ou Braun-Brüggemann) como apêndice que blinda contra a crítica weak-IV. Não é preciso
"virar bayesiano" — é preciso um apêndice.

---

## 5. Disponibilidade de código (a observação do usuário) — e o que ela realmente compra

| Artigo | Pacote público | Linguagem | Faz o mapeamento de fatores? |
|--------|----------------|-----------|------------------------------|
| LMS 2017 / GMR 2017 | **`svars`** (`id.ngml`, `id.dc`, `id.cvm`) — CRAN + github.com/alexanderlange53/svars | **R (nativo!)** | Não — mas roda sobre um objeto VAR (`vars`/`tsDyn`), então basta alimentar o VAR de fatores |
| Braun-Brüggemann | replicação JBES 2023 / BoE (toolbox ARRW 2018) | MATLAB | Não |
| Caldara-Herbst | AEA/openICPSR (sampler BP-SVAR) | MATLAB | Não |
| Antolín-Díaz-RR | AEA/openICPSR (toolbox ARRW/RWZ) | MATLAB | Não |

**O que o replication package pronto compra e o que não compra:** ele economiza a
implementação do *estimador* — real e valioso, sobretudo para os três bayesianos, cujo
sampler é a parte cara. Mas **em todos os cinco** ainda sobra (a) a **adaptação ao espaço de
fatores** (alimentar η/z e propagar por Λ), que nenhum pacote faz, e (b) para os bayesianos
o **porte MATLAB→R**. Por isso a rota **LMS/GMR domina em custo**: `svars` é **R**, a mesma
linguagem do projeto, e opera sobre um objeto VAR — basta passar o VAR de fatores e um passo
de rotulagem pelo proxy (correlação com `z`), que é trivial e não está no pacote.

---

## 6. Ranking de robustez e recomendação

**Ordem de prioridade para reforçar o (7,6) que raspa o limiar:**

1. **Tier 1 — rota não-gaussiana (LMS 2017 + GMR 2017), frequentista, barata.**
   Identificar as q inovações fatoriais por não-gaussianidade (`svars::id.ngml` +
   `id.dc`/`id.cvm`), **rotular a coluna monetária pelo proxy** e comparar com a coluna do
   proxy-SVAR de produção. Se baterem, é corroboração **independente do instrumento** →
   ataca diretamente a fragilidade do ξ_mp no limiar. Bônus: **testa a restrição do proxy**
   (Wald/LR). É a recomendação principal porque preserva o paradigma, é R nativo e está no
   menu do próprio autor.
   - **Gate barato antes de investir (próximo passo, fora do escopo desta entrega):** testar
     não-gaussianidade/curtose de η (Jarque-Bera, curtose por fator, ≤ 1 gaussiana). Se η for
     quase gaussiano, esta rota perde poder e cai para Tier 2 — decisão condicionada ao gate.

2. **Tier 1b — Braun-Brüggemann (proxy + sign, bayesiano).** Se quiser **um único framework**
   que (a) trata o proxy como *plausivelmente* exógeno (endereça a crítica RS-2004), (b)
   **afia** o instrumento fraco com sign restrictions, e (c) **testa a exogeneidade** do
   proxy. É o mais sob medida; o preço é ir bayesiano num bloco e montar o plumbing de sinais
   em espaço de observáveis.

3. **Tier 2 — Caldara-Herbst (BP-SVAR, bayesiano).** A resposta de manual para "meu proxy é
   fraco": inferência válida sem depender do limiar. Melhor como **apêndice de robustez ao
   weak-IV**. Bônus temático: a regra de política reagir a spreads de crédito é testável no
   painel do Brasil.

4. **Tier 3 — Antolín-Díaz-Rubio-Ramírez (narrativa, bayesiano set-ID).** Distintivo por
   usar os episódios bem documentados do Brasil, mas é o maior esforço (set-ID + base
   sign-restricted + curadoria de episódios) e o paradigma mais distante. Candidato a
   robustez "de assinatura" se o paper quiser um ângulo narrativo, não a primeira escolha.

**Recomendação em uma frase:** implementar a **rota não-gaussiana (Tier 1)** como robustez
primária frequentista — barata, em R, corrobora o choque sem depender do IV fraco e ainda
torna o proxy testável — e, se quiser blindar explicitamente contra a crítica weak-IV,
acrescentar **uma** rodada bayesiana como apêndice, preferindo **Caldara-Herbst** (endereço
mais direto do weak-IV) ou **Braun-Brüggemann** (se quiser também testar a exogeneidade do
proxy). Antolín-Díaz fica para depois. **Não é preciso virar bayesiano; é preciso um
apêndice.**

---

## 7. Próximos passos concretos (quando/se autorizado)

1. **Gate de não-gaussianidade** em η do DFM (7,6): JB + curtose por fator; decide a
   viabilidade do Tier 1. (Barato, reusa o objeto estimado.)
2. Se o gate passar: ramo `identification = "nongaussian"` em `compute_irf_dfm` chamando
   `svars::id.ngml`/`id.dc` nas inovações fatoriais + rotulagem por `corr(coluna, z)` +
   propagação por Λ; teste LR/Wald da restrição do proxy.
3. Opcional (apêndice bayesiano): prototipar Caldara-Herbst BP-SVAR nas q inovações com
   `m_t = z` (SMC, prior de relevância), reportando credible sets vs. bandas wild-bootstrap.
4. Confirmar handles exatos dos replication packages (openICPSR para CH e ADRR; repo JBES
   para BB) antes de citar no paper.

---

*Notas de leitura completas por artigo:*
`artigos/1-s2.0-S0304407616301828-main/…_notes.md` (LMS),
`artigos/j.jeconom.2016.09.007/…_notes.md` (GMR),
`artigos/identification-of-svar-models-…/…_notes.md` (Braun-Brüggemann),
`artigos/mac.20170294/…_notes.md` (Caldara-Herbst),
`artigos/AntolnDaz-NarrativeSignRestrictions-2018/…_notes.md` (Antolín-Díaz-Rubio-Ramírez).

---

## Adendo 2026-07-24 — pergunta do usuário: weak-proxy frequentista + portar a ideia de B&B

### (a) Angelini, Cavaliere & Fanelli (2024, *J. Econometrics* 238(2)) — proxy-SVAR com proxy fraco, **frequentista**
arXiv 2210.04523 / ScienceDirect S0304407623003202. **É a peça que faltava do lado
frequentista** e trata exatamente o problema do (7,6) raspando o limiar, sem prior:
- **Pré-teste de relevância por bootstrap**, robusto a **heterocedasticidade condicional e
  a proxies zero-censored** — casa com `z_jk_bs_purif` (máscara JK zera dias não-monetários
  e meses sem Copom). Mais adequado ao instrumento do projeto do que o F/ξ_mp sozinho.
- **Conjuntos de confiança robustos a IV fraco** (inversão de teste) para as IRFs — bandas
  válidas com ξ_mp no limiar, sem depender da cobertura do wild bootstrap (que, por
  Caldara-Herbst / Jentsch-Lunsford, só vale para instrumento forte).
- Truque de **Minimum Distance** que recupera assintótica padrão **se houver proxies fortes
  para os choques não-alvo** — NÃO se aplica aqui (só há o proxy monetário); os dois itens
  acima, sim.
- **Conexão com o pipeline:** o bloco MOSW já dá o AR-set robusto para o caso
  um-proxy-um-choque ("intervalo limitado sse ξ_mp > 3,84"); ACF (2024) é a
  generalização/complemento, com pré-teste de relevância mais apto ao instrumento
  zero-censored. Ressalva: escrito para VAR, precisa da adaptação a fatores.
- **Posição:** promove-se a **Tier 1 frequentista** junto com LMS/GMR — é a rota que
  endereça o weak-IV *dentro* do paradigma do paper.

### (b) A matriz B e a portabilidade da ideia de Braun-Brüggemann ao frequentista
- **B (B-model):** matriz de impacto contemporâneo; coluna *j* = resposta no impacto de
  todas as variáveis ao choque *j*; `Σ = BB'`. Identificar = fixar a rotação Q em `B = P·Q`.
  Sign restrictions restringem sinais de B (ou de `Θ_h = Ξ_h B`) → recortam um **conjunto**
  de Q (set-ID). No DFM o análogo é a matriz de impacto das q inovações fatoriais; os sinais
  vivem em **`Λ·B`** (espaço das observáveis: curva ↑, IBOV ↓, atividade ↓).
- **Portar só a ideia (sim, em princípio):** set-ID por sign restrictions **não é
  intrinsecamente bayesiano** — o bayesiano em B&B é só *como resumem* o conjunto (prior
  uniforme sobre rotações + MCMC + Bayes factors). Há literatura frequentista de set-ID por
  sinais (via desigualdades de momento), e os limites "plausivelmente exógeno" (`ρ_1 > c`,
  `ω_1 > Σ ω_j`) são desigualdades de momento — a versão frequentista dessa ideia é
  Ludvigson-Ma-Ng (2021), "external inequality constraints".
- **O que NÃO porta de graça:** (i) o teste de exogeneidade do proxy por Savage-Dickey Bayes
  factor é bayesiano por construção; troca-se pelo análogo frequentista (sobre-ID/Hausman
  ou o teste por heterocedasticidade de **Bertsche-Braun 2020**, citado no próprio B&B);
  (ii) a **combinação proxy + sinais num único objeto** — o momento do proxy
  (`Σ_uz = B_•1 Φ'`) liga B à covariância do instrumento e **não** é uma restrição de
  sinal/zero sobre uma coluna `B_j`, então não se funde de graça no frequentista. Ou você
  mantém proxy e sinais como **identificações separadas** (comparadas como cross-check), ou
  usa a **rota indireta de ACF** (instrumentar um choque não-alvo).
- **Receita frequentista concreta:** (1) mantém proxy point-ID da coluna monetária;
  (2) robustez a IV fraco por **ACF (2024)** (pré-teste de força + bandas robustas) / AR-set
  MOSW no lugar do (ou junto ao) wild bootstrap; (3) corroboração independente do choque
  pela rota **não-gaussiana (LMS/GMR)**.
- **Conclusão:** para o objetivo (seguir frequentista e blindar o proxy fraco), **não vale
  portar a maquinaria bayesiana de B&B** — o núcleo frequentista utilizável é **ACF (2024)**
  (força/robustez weak-IV) + a rota **não-gaussiana (LMS/GMR)** como corroboração
  independente. A combinação proxy+sinais integrada do B&B permanece especificamente
  bayesiana.

---

## Adendo 2 (2026-07-24) — leitura profunda de ACF (2024)

Lido a fundo com `split-pdf-md` (notas em `artigos/angelini…/…_notes.md`). Confirma e afina o
Adendo 1. (Decisão do autor 2026-07-24: a rota de sign-restriction set-ID frequentista foi
retirada do escopo — o núcleo frequentista fica **ACF + não-gaussianidade**.)

### ACF (2024) — três ferramentas, duas usáveis já no caso do projeto
1. **Pré-teste de força por bootstrap (usável AGORA, k=1):** o estimador MBB-CMD da força
   do proxy é **gaussiano se o proxy é forte / não-gaussiano-aleatório se é fraco** (Staiger-
   Stock). O teste é um **teste de normalidade (Doornik-Hansen / KS) nas N réplicas
   bootstrap**, `N=[T^{1/2}]`, **robusto a heterocedasticidade condicional e a proxies
   zero-censored** — exatamente o `z_jk_bs_purif` (máscara JK zera dias/meses). E, por
   **independência assintótica (Prop 7), não distorce a inferência a jusante** (sem
   Bonferroni) — o que o screening por F de 1º estágio não garante (screening por F *piora*
   a cobertura). ⇒ é um veredito de força mais limpo do que ξ_mp/F para o (7,6) no limiar.
2. **Bandas robustas a IV fraco (k=1):** conjunto Anderson-Rubin de MOSW (já no pipeline) ou
   grid MBB AR (Jentsch-Lunsford 2022).
3. **Rota indireta-MD (novidade, vale explorar):** identificar o choque MP **instrumentando
   um choque NÃO-alvo** com um proxy *forte* (ex.: choque de commodity via inovação do
   Brent, choque de risco global via VIX, ou choque fiscal) — recupera as IRFs do MP por
   `B_•1 = Σ_u A_1•'` com **assintótica padrão**, driblando o proxy monetário fraco. É a
   ideia mais criativa e permanece 100% frequentista. Exige construir e pré-testar um proxy
   forte para o choque não-alvo.

**Disponibilidade de código (verificado 2026-07-24):** **não há replication package público**
do ACF (2024). Evidência: na página de publicações de Giovanni Angelini o paper de 2019
(Angelini-Fanelli) traz tag "[MATLAB code]", mas o de 2024 (weak proxies) **não tem** link de
código; o registro da Exeter (figshare) só expõe o PDF; e a nota de rodapé 17 do artigo diz
"codes available upon request from the authors". ⇒ a implementação (pré-teste bootstrap +
indirect-MD) teria de ser **codificada do zero** (ou pedida aos autores), além da adaptação a
fatores. Isso rebaixa a conveniência do ACF frente à rota não-gaussiana (`svars`, R, pronta).

### Toolkit frequentista consolidado para o (7,6) no limiar
| Necessidade | Ferramenta frequentista |
|---|---|
| Diagnóstico de força do proxy (zero-censored) | **ACF (2024)** pré-teste bootstrap (sem viés de pré-teste) — *sem código público* |
| Bandas robustas a IV fraco (k=1) | MOSW AR (já no pipeline) / grid MBB AR |
| Driblar o proxy fraco de vez | **ACF (2024)** indirect-MD via choque não-alvo forte — *sem código público* |
| Corroboração independente do choque | **LMS/GMR** ICA não-gaussiana (`svars`, R — pronto) |

Nenhum exige virar bayesiano. Todos precisam da mesma adaptação a espaço de fatores
(identificar nas q inovações, propagar via Λ) que os ramos `proxy`/`het` já implementam.
