# Plano de reimplementação — heterocedasticidade como identificação primária

**Data:** 2026-07-16. **Branch:** `identificacao-heterocedasticidade` (criada a partir de `reescrita-metodologia-instrumento-externo` após commit do WIP `4f39ad9`). **Status:** fase de planejamento — nenhum código de produção alterado.

## 0. Sumário executivo

O paper abandona o instrumento externo (surpresas GK/JK de DI em dias de Copom) como identificação principal e passa a identificar o choque de política monetária **integralmente por heterocedasticidade**, fiel a Rigobon (2003). O `z_het` existente não cumpre esse papel: é um híbrido em que a extração het diária apenas fabrica uma proxy consumida por um proxy-SVAR — a hipótese identificadora operante é a exclusion restriction mensal, não A1-A3. Este documento registra (a) a branch, (b) as sínteses de leitura de Rigobon (2003), Stock-Watson (2016) e Rigobon-Sack (2004), (c) o diff conceitual entre o `z_het` atual e a identificação het primária, com a arquitetura escolhida, e (d) o confronto com o pacote `svars`. A implementação de código é a fase seguinte (seção 6) e **não** foi executada.

## 1. Motivação institucional (formulação precisa para o texto)

- O Copom divulga a decisão **~18h30 BRT, após o fechamento do mercado**, no segundo dia de reunião (quarta-feira). A surpresa só é mensurável na janela quarta-fecha → quinta-fecha (~24h).
- **O que isso quebra (e o que não quebra):** não torna o instrumento externo "impossível" — torna frágil a exclusion restriction do proxy, porque a janela de 24h embute o overnight global (fechamento dos EUA, sessão asiática, notícias domésticas não-monetárias). É exatamente a crítica de Rigobon-Sack (2004) ao event-study com janelas largas, e o ponto de GRG (2025) para o Brasil.
- A identificação por heterocedasticidade requer apenas que a **variância** do choque de política salte em dias/períodos de Copom com as variâncias dos demais choques estáveis (A1-A3) — hipótese compatível com o desenho institucional brasileiro, testável (split de variância, rank tests) e mais fraca que a hipótese de janela limpa.

## 2. Referências verificadas (2026-07-16)

| Referência | Verificação |
|---|---|
| Rigobon, R. (2003), "Identification Through Heteroskedasticity", *Review of Economics and Statistics*, 85(4), 777-792 | Header do `.md` local (marker): Vol. LXXXV, November 2003, No. 4. O "Rigobon (2004)" mencionado no contexto é lapso, ou refere-se a ↓ |
| Rigobon, R. & B. Sack (2004), "The impact of monetary policy on asset prices", *Journal of Monetary Economics*, 51, 1553-1575 | Header do `.md` local. Aplicação da het-ID a política monetária; template empírico mais próximo do paper |
| Stock, J.H. & M.W. Watson (2016), "Dynamic Factor Models, Factor-Augmented Vector Autoregressions, and Structural Vector Autoregressions in Macroeconomics", *Handbook of Macroeconomics* vol. 2 (Taylor & Uhlig, eds.), cap. 8, pp. 415-525, Elsevier | Confirmado (IDEAS/RePEc + `.md` local). §4.5 = "Identification by Heteroskedasticity"; §5-7 = SDFM/FAVAR |
| Lange, A., B. Dalheimer, H. Herwartz & S. Maxand (2021), "svars: An R Package for Data-Driven Identification in Multivariate Time Series Analysis", *JSS*, 97(5) | CRAN/rdrr. `id.cv` = change in volatility com quebra exógena contígua; **`id.cvm` não é het** (independência via Cramér-von Mises) — corrigir a premissa |
| Horário Copom | Divulgação a partir de ~18h30 BRT, segundo dia (quarta), após fechamento — fontes B3/imprensa (2026) |

## 3. Notas de leitura

Extratos estruturados (8 dimensões, protocolo split-pdf-md) em:

- `artigos/rigobon - IDENTIFICATION THROUGH HETEROSKEDASTICITY/rigobon - IDENTIFICATION THROUGH HETEROSKEDASTICITY_notes.md`
- `artigos/Stock e Watson - Dynamic Factor Models,.../Stock e Watson - ..._notes.md`
- `artigos/Rigobon, Sack - The impact of monetary policy on asset prices/Rigobon, Sack - ..._notes.md`

### 3.1 Rigobon (2003) — o que "fiel a Rigobon" exige

Síntese da leitura (extrato completo no `_notes.md`):

- **Prop. 1 (S=2 regimes, bivariado):** just-identification do **sistema completo** (a menos de permutação de linhas; raízes α e 1/β da quadrática eq. 5) sob choques estruturais não correlacionados + parâmetros estáveis entre regimes. Com K=0 choques comuns, dois regimes bastam para qualquer N (Prop. 2). Nota de compatibilidade: a versão **uma-coluna** usada no projeto (só σ²_policy salta, ΔΣ rank-1) é o caso particular de RS-2004/SW eq. 45 — identificação parcial sob hipóteses mais fracas (A2: demais variâncias constantes). Ambas são "Rigobon"; o paper deve declarar qual usa.
- **Condição de posto (eqs. 6-7):** falha sse Ω₂ ∝ Ω₁ (variâncias relativas constantes). **Testável** — e o Appendix recomenda a estatística de produto cruzado (7), não o determinante (melhores propriedades em amostra pequena). Near-proporcionalidade ⇒ identificação fraca (aviso qualitativo; sem teoria distributional weak-ID formal no paper — buscar em SW §4.5.3).
- **S ≥ 3 regimes ⇒ sobreidentificação:** cada regime válido funciona como um instrumento adicional ("probabilistic IV"); minimum-distance/GMM; as restrições de sobreidentificação **testam a estabilidade dos parâmetros (A3)** — destrava o J-test hoje indisponível no setup R=2 do repo (basta sub-dividir o regime NC, e.g. por tercil de volatilidade ou sub-período).
- **Prop. 2 (N endógenas, K choques comuns):** order condition S ≥ 2(N+K)(N−1)/(N²−N−2K), exigindo K < N(N−1)/2. Com K=0, S=2 basta; com K>0, sempre S>2 — **ou** purga-se o fator comum na primeira etapa (o próprio Rigobon purga o UST 10y via VAR de primeira etapa na aplicação EMBI). Implicação direta: o "cleanup global" do pipeline tem análogo Rigobon-sancionado — controles globais no estágio de resíduos, não na proxy.
- **Prop. 3 (janelas erradas, nº certo de regimes):** as covariâncias computadas são combinações convexas das verdadeiras; consistência preservada enquanto a rank condition ainda vale. Custo da misspecification = **poder, não viés** — protege regimes por calendário (Copom) contra erros moderados de janela/vazamento de anúncio.
- **Prop. 4 (sub-regimes verdadeiros dentro das janelas):** agregação consistente sob A4 (há het entre as janelas agregadas) e A6 (deltas médios não proporcionais) — protege contra sub-regimes tipo COVID dentro de C ou NC.
- **Aviso inverso crítico:** assumir **mais** regimes do que existem quebra a rank condition ⇒ inconsistência e CIs infinitos. Não multiplicar regimes sem shift real de variância (disciplina para o desenho do J-test acima).
- **Prática empírica (EMBI Arg/Bra/Mex 1994-2001):** regimes por calendário de eventos; VAR de primeira etapa para correlação serial + fator comum; GMM sobre covariâncias por janela; SEs por bootstrap de resíduos **dentro de regime** (500 reps); robustez com janelas curtas confirma Prop. 3. Omitir o choque comum quando ele existe (forçar K=0) é rejeitado massivamente (F 8-369) — **a escolha de K não é inócua** e precisa de teste no desenho brasileiro.

### 3.2 Stock-Watson (2016) — het-ID no SVAR e acoplamento ao SDFM

Síntese da leitura (extrato completo no `_notes.md`):

- **§4.5.1 (regimes):** equações de momento Σ_η^j = H Σ_ε^j H′ (eq. 42); sob a unit-effect normalization (diag(H)=1) o sistema de dois regimes é **exatamente identificado** (n²+n equações = incógnitas), mas a rank condition **falha sob heterocedasticidade proporcional** (Σ_ε² = a·Σ_ε¹ não acrescenta informação) e é difícil de verificar porque as Σ_η^j são estimadas. Forma fechada do caso uma-coluna: `H_21 = ΔCov(η₁,η₂)/ΔVar(η₁)` (eq. 45). O desenho institucional endossado é exatamente o do projeto: variância do choque de política elevada em datas de anúncio, H constante (Rigobon-Sack 2004, Wright 2012). O raciocínio econômico entra em dois lugares: invariância de H entre regimes e conhecimento a priori de **qual** variância relativa mudou.
- **§4.5.3 (interpretação IV + weak-ID):** o estimador het é IV com instrumento **Z_t = D_t·η̂_1t, D_t = −1/T₁ (regime 1), +1/T₂ (regime 2)**, η̂ de OLS full-sample (eq. 46) — logo o novo primário tem representação IV que a maquinaria existente (`H = (Z'η)/(Z'Z)`) pode reproduzir numericamente como cross-check. Força = precisão da estimativa de ΔVar(η₁) relativa ao Δ verdadeiro; fraqueza vem de Δvar pequeno **ou de poucas observações em um dos regimes**. Sob o nesting Staiger-Stock, Ĥ_21 →d z₂/z₁: distribuição não-normal, bimodal, caudas pesadas, e — citação direta — *"inference based on conventional bootstrap confidence intervals will be misleading"*: o wild bootstrap do projeto **não conserta** weak het-ID. Remédios prescritos: conjuntos robustos de Magnusson-Mavroeidis (2014, *Econometrica*) e a implementação de Nakamura-Steinsson (2015) para heterocedasticidade em datas de anúncio. §8.1.4: a preocupação "applies equally to SVARs, FAVARs, and SDFMs"; não existe toolkit completo; F<10 (§4.3.4) segue como régua de triagem; o bootstrap paramétrico de §5.1.3 só é válido sob identificação forte.
- **§5.1.2.3 (porte para o DFM) — decisivo para a arquitetura:** citação verbatim: *"the identification schemes discussed in Section 4 carry over directly. The innovation η_t in Section 4 is now the innovation to the factors … the formulas in Section 4 carry over with the notational modification of setting A(L) to Φ(L)."* Ou seja: aplicar Rigobon aos regimes das inovações do factor-VAR mensal **é o template do próprio capítulo**. Requisitos: normalização named-factor (eqs. 12/59-60 — múltiplos vértices de DI podem nomear conjuntamente o fator de política, como os quatro preços de petróleo na eq. 60) + unit effect; para r > q, η_t = a_1t com G = [I_q; Σ_a,21·Σ_a,11⁻¹] (eq. 61) — estrutura que o código já implementa via η = u K M⁻¹.
- **§6.4:** inovações de VARs pequenos **não** spannam o espaço das inovações dos fatores — argumento a favor de identificar nas η_t do DFM, não em um sistema diário pequeno.
- **§7.5.1/§8.1.4 (caveat de spanning):** se o choque de política é fracamente spanned pelas inovações dos fatores, a normalização named-factor quebra e o SDFM puro é não confiável — a correção é um **FAVAR híbrido com a variável de política como fator observado**. Pré-cheque obrigatório: R² do componente comum de `yield_6m`.
- **§4.7 (instrumentos externos, para o contraste):** condições de relevância (eq. 51) e exogeneidade (eq. 52); H_•1 = E(η_•t Z_t)/E(η_1t Z_t) (eq. 54) — é a família de identificação que o paper abandona; a arquitetura B reduz-se a ela (o choque het diário vira apenas um Z_t melhor no pipeline existente).

### 3.3 Rigobon-Sack (2004) — template empírico

Síntese da leitura (extrato completo no `_notes.md`):

- **Modelo estrutural (eqs. 1-2):** `Δi_t = β Δs_t + γ z_t + ε_t` (função de reação permitida, β ≠ 0) e `Δs_t = α Δi_t + z_t + η_t`; choques mutuamente não correlacionados; alvo é α (resposta do preço de ativo à política).
- **Hipóteses het (eqs. 6-8):** σ_ε sobe nos policy dates (FOMC + testemunhos do Chairman); σ_η e σ_z **iguais** entre regimes; parâmetros α, β, γ estáveis. Só a importância *relativa* do choque de política precisa subir — muito mais fraco que o event-study, que exige near-identification (eqs. 4-5: σ_ε ≫ σ_z, σ_ε ≫ σ_η) e é o caso-limite do estimador het com shift infinito de variância.
- **Estimador VC (eqs. 9-11):** ΔΩ = Ω_F − Ω_{~F} é rank-1; `α̂_het = ΔΩ_12/ΔΩ_11` (baseado em i) ou `ΔΩ_22/ΔΩ_12` (baseado em s).
- **Formulação IV equivalente (eqs. 12-13):** empilha os dois regimes e usa como instrumento a própria variável de política com sinal trocado no regime tranquilo — `w_i = [Δi_F', −Δi_{~F}']'` (escalado por √T de cada regime quando T_F ≠ T_{~F}); IV padrão de Δs em Δi. **GMM two-step** usa as 3 restrições de (9) com parâmetros (α, λ) e produz J-test de sobreidentificação.
- **Regimes:** 78 policy dates 1994-2001 (5 descartados por feriado); regime tranquilo = **dia imediatamente anterior** a cada policy date (não "todos os demais dias"); dados diários close-to-close.
- **Viés do event-study:** em ações, η e z induzem correlação positiva juros-ações ⇒ ES **subestima** a queda (S&P: het-IV −6.81 vs ES −5.78 por 100bp; 25bp ⇒ −1.7% S&P); em yields, choques comuns ⇒ ES **superestima** a resposta da curva, crescente na maturidade (i30y: het-IV 0.352, GMM −0.133, ES 0.493; rejeição via GMM p ≤ 0.004). É a justificativa formal do pivô brasileiro: janela larga ⇒ viés sistemático, não só ruído.
- **Weak-ID (footnote 11, Staiger-Stock):** sem salto de variância o denominador de (10) tem massa perto de zero — ponte direta para a exigência de régua de força (G5).
- **Robustez de janela (Table 5):** janelas de 2 dias passam; 5 dias **rejeitam** a sobreidentificação — sustenta a janela estreita Wed→Thu do desenho brasileiro.
- Nota de OCR: o marker perdeu sinais negativos em Table 1/Table 5; documentado no `_notes.md`.

## 4. Diff conceitual: `z_het` atual vs Rigobon-primário

### 4.1 O que o `z_het` atual é (estado da arte no repo)

Cadeia em cinco camadas (`script/instrument_het.R` + `R/identification/het_shock_extraction.R`):

1. Sistema diário de mudanças Wed→Thu (DI_3m, [DI_2y,] IBOV, BRL); regimes C/NC pelo calendário do Copom (`build_daily_regimes`).
2. ΔΣ = Σ_C − Σ_NC; autopar líder ⇒ `b_1` (`extract_shock_rigobon_sack`) — **este passo é Rigobon**.
3. Recuperação da série diária de choque por projeção GLS Mertens-Ravn (2013) sobre `b_1` em dias C.
4. Filtro de sinal JK diário (zera dias "informacionais") — hipótese **extra**, não-Rigobon.
5. Soma mensal ⇒ `z_het*` ⇒ proxy-SVAR no DFM via `H = (Z'η)/(Z'Z)` (`ident_ext_instr`) — **identificação operante = exclusion restriction mensal** (Stock-Watson 2018 §4.7), a mesma dos proxies GK. O rótulo honesto do próprio repo: "instrumento híbrido het+timing" (`_instrucoes/Heteroscedasticidade.md`).

Consequência: o que o paper alegava como "identificação por heterocedasticidade" era, no nível onde as IRFs são calculadas, um proxy-SVAR com proxy het-fabricada. A régua de força correta era a de IV fraco (ξ_mp/MOSW), e as camadas 3-5 introduzem hipóteses (exclusion mensal, filtro JK) que Rigobon não pede.

### 4.2 Arquiteturas candidatas para o primário

- **A — Regimes mensais sobre as inovações do factor-VAR.** Rigobon aplicado direto a η_t (q-dim, mensal): regimes = meses **com** reunião do Copom (~104 obs em 2013-2025) vs **sem** (~52 obs; 8 reuniões/ano ⇒ 4 meses sem por ano). ΔΣ_η rank-1 sob A1-A3 mensais ⇒ coluna de impacto `b` no espaço dos fatores; IRFs pela mesma maquinaria `rawimp`, com `b` no lugar de `H`. Identificação e IRFs na **mesma frequência** — sem ponte, sem proxy, sem exclusion restriction. Risco central: A1 mensal fraca (o salto de variância dilui na agregação mensal; antecipação/comunicação espalha choques para meses sem reunião).
- **A-episódio — regimes de episódio plurianual (BPSS 2021)** *(adicionada 2026-07-16 após o /btw sobre Brunnermeier et al.)*: sistema completo Σ_s = B Λ_s B′ com episódios de volatilidade (pré-2020 vs 2020+; partição fina 2013-16/17-19/20-21/22-25) e rotulagem ex-post do choque monetário.
- ~~**B — Sistema diário RS-2004 como headline + ponte explícita para o DFM.**~~ **REMOVIDA por decisão do autor (2026-07-16): o paper abandona qualquer identificação via instrumento/proxy.** O material diário RS-2004 pode, no máximo, reaparecer como evidência descritiva de alta frequência — nunca como camada de identificação do DFM.

### 4.3 Decisão de arquitetura

**Escolhida: Arquitetura A — regimes mensais (meses com/sem Copom) sobre as inovações do factor-VAR — condicionada aos gates da seção 4.5, com fallback B.**

Justificativa ancorada na leitura:

1. **SW §5.1.2.3 sanciona A verbatim:** os esquemas de identificação da §4 "carry over directly" com η_t = inovação dos fatores. Aplicar o regime-split de Rigobon às η_t mensais é o template do capítulo para SDFM estrutural — não uma improvisação do projeto.
2. **B é a família que o paper abandona.** Sem tratamento próprio no capítulo, B reduz-se a §4.7 (instrumento externo com Z_t het-fabricado): o identifying assumption headline continuaria sendo a exclusion restriction de proxy — exatamente o que motivou o pivô. B permanece como fallback e como braço de robustez (e o sistema diário à la RS-2004 continua valioso como evidência de alta frequência).
3. **Rigobon protege a definição de regime por calendário:** Prop. 3 (janela errada ⇒ perda de poder, não viés) cobre vazamentos de anúncio entre meses adjacentes; Prop. 4 cobre sub-regimes (COVID) dentro das janelas.
4. **Condições prévias (podem reverter a decisão para B ou desviar para A′):**
   - **G1** — A1 mensal: var_C/var_NC > 1 na direção de política com CI 99% excluindo 1 (104 meses C vs 52 NC);
   - **Pré-cheque de spanning** — R² do componente comum de `yield_6m`; se fracamente spanned, a normalização named-factor quebra (SW §7.5.1/§8.1.4) e a variante correta é **A′: FAVAR híbrido com `yield_6m` como fator observado**;
   - **G5** — weak-ID: com T_NC = 52, o risco "poucas observações em um regime" é real; se marginal, bandas Magnusson-Mavroeidis/Nakamura-Steinsson são obrigatórias (o wild bootstrap não conserta — SW §4.5.3).
5. **Escolha de estimador dentro de A:** GMM/minimum-distance sobre as condições de momento vech(Σ_C, Σ_NC) — a prescrição de Rigobon (2003) — com a extração por autovalores (`extract_shock_rigobon_sack`) como inicialização e descritivo, e o IV regime-signed de SW eq. 46 (Z_t = D_t·η̂_1t via `ident_ext_instr`) como cross-check numérico. Normalização: named-factor em `yield_6m` (+50bp, unidades nativas — convenção vigente); se a nomeação single-vertex for fraca, nomear conjuntamente com vértices adicionais de DI (SW eq. 60).

**Desfecho empírico (2026-07-16, fase de código):** a arquitetura A foi **reprovada pelos gates em todo o grid** (16 células): o placebo de permutação de labels não distingue o calendário Copom (p_perm 0.26–0.86; única marginal pre_covid (8,8) p=6 = 0.037) e o LR de proporcionalidade nunca rejeita Σ_C ∝ Σ_NC — A1/rank condition não existem na frequência mensal (a agregação dilui a elevação de variância de dia de anúncio; spanning do `yield_6m` é bom, 0.70–0.97, o problema é a frequência, não o span). Relatório: `output/het_primary/feasibility_report.md`. O código do ramo het está implementado e validado (`R/identification/het_primary.R`, `identification = "het"` em `compute_irf_dfm`/`main_sdfm`, harness `script/validate_het_primary_sim.R` 100%).

**Desfecho A-episódio (2026-07-16, mesma sessão):** também **reprovada** (`script/het_episode_feasibility.R` → `output/het_primary/episode_feasibility_report.md`): a volatilidade mensal se move como escala comum (proporcionalidade nunca rejeitada em S2 nem em 0/6 pares S4; placebo circular p 0.20–0.88), os autovalores generalizados são indistinguíveis (min gap 0.04–0.19) e a coluna que carrega em `yield_6m` tem λ ≈ 1 — a direção monetária é justamente a que não muda de variância relativa. Contraste com BPSS: lá as variâncias relativas mudam entre episódios; aqui não.

**Decisões do autor (2026-07-16):** (i) **abandonar qualquer identificação via instrumento/proxy** — B removida do plano; (ii) com het mensal reprovada nas duas variantes, o menu restante na frequência mensal é: **sign restrictions** (set-ID, frequentista — Gafarov-Meier-Montiel Olea — ou bayesiana à la Uhlig; combinável com o DFM), ordenação recursiva, não-gaussianidade/ICA (Lanne-Meitz-Saikkonen 2017), het condicional GARCH (Sentana-Fiorentini — não testada, T=147 curto). Escolha da nova identificação primária pendente.

### 4.4 Mapa de reuso / novo / aposentado

**Reaproveitado sem mudança conceitual:**

- `extract_shock_rigobon_sack` (`R/identification/het_shock_extraction.R`) — agnóstica à matriz de entrada; funciona sobre η mensal (arquitetura A) ou sobre o bloco diário (B).
- `validate_variance_split` + `classify_a2_verdict` — teste A1/A2 por variável com CI bootstrap; roda igualmente sobre η mensal.
- `formal_rank_test_battery` (Rigobon Prop 1 proporcionalidade + Lanne-Lütkepohl rank-1 + CI do rank-1 share, bootstrap-calibrados).
- Maquinaria de propagação de `compute_irf_dfm` (`rawimp`, transformação tcode, normalização +50bp em `yield_6m` em unidades nativas, `plot_irf`).
- Wild bootstrap GK (Gonçalves-Kilian 2004): o multiplicador Rademacher preserva segundos momentos por observação, logo a estrutura de covariância por regime é preservada entre draws com labels fixos (calendário exógeno) — o desenho atual já mantém o indicador C/NC fixo.

**Novo (fase de código, seção 6):**

- `ident_het_regimes()` em `R/modeling/impulse_responde.R` (ou módulo novo `R/identification/het_primary.R`): recebe `rawimp`, η, tabela de regimes; calcula ΔΣ_η, autopar líder, `b` normalizado; substitui `H = (Z'η)/(Z'Z)`. No loop de bootstrap: recomputa Σ_C/Σ_NC sobre `eta_boot` com os **mesmos labels**, sem instrumento (`inst_boot` desaparece no primário).
- Tabela de regimes mensal (`build_monthly_regimes()`): meses com/sem Copom a partir de `data/copom_historico.csv`.
- Régua de força het substituindo ξ_mp como headline: CI bootstrap de λ₁(ΔΣ_η), razão de variâncias na direção de política, e inferência robusta a weak-ID (SW §4.5.3 — Magnusson-Mavroeidis / Nakamura-Steinsson) para as bandas quando a força for marginal.
- Alinhamento temporal simples η↔regimes (substitui `sel_ext_inst_sample` no primário).
- Purga Rigobon-sancionada de fator comum (se G6 acusar K>0): controles globais em VAR/regressão de primeira etapa **antes** das covariâncias por regime — substitui conceitualmente a "purificação" da proxy GK, agora no lugar onde Rigobon a coloca.
- Estatística de produto cruzado (Rigobon eq. 7) na bateria de rank; J-test multi-regime (S≥3) como teste formal de A3.

**Aposentado / re-escopado:**

- `sel_ext_inst_sample` + `ident_ext_instr`: saem do caminho primário; permanecem para os braços de robustez proxy (GK e z_het-como-instrumento).
- ξ_mp/MOSW e `compute_factor_space_F`: deixam de ser a régua primária; viram diagnóstico dos braços-robustez.
- Filtro JK diário: **fora do primário** (decisão do autor, 2026-07-16); a variante filtrada vira robustez com hipótese extra declarada.
- Dimensão "instrumento" (12 variantes) do spec sweep: colapsa; vira dimensão "definição de regime × bloco de variáveis × (r,q) × amostra".
- `script/instrument_diagnostics.R`: re-escopado — a Seção 4 (het) promove-se a relatório principal; a Seção 1 (F de IV) desce para apêndice de robustez.

### 4.5 Diagnósticos de viabilidade (gates, a rodar no início da fase de código)

Reportar **inclusive resultados inconvenientes** — F fraco / curva desordenada é diagnóstico, não rodapé (memória do projeto).

- **G1 (A1 mensal, decide A vs B empiricamente):** `validate_variance_split` sobre η_t do factor-VAR de produção, regimes = meses com/sem Copom (104 vs 52 em 2013-2025, conferido em `data/copom_historico.csv`). Se a razão var_C/var_NC na direção de política não excluir 1 (CI 99%), a arquitetura A é inviável e B assume.
- **G2 (rank):** `formal_rank_test_battery` sobre (Σ_C, Σ_NC) de η mensal (A) ou do bloco diário (B); **adicionar a estatística de produto cruzado de Rigobon (2003, eq. 7)** — recomendada no Appendix sobre o determinante por small-sample properties — ao lado da LR de proporcionalidade já implementada.
- **G3 (A2 por variável):** `classify_a2_verdict`; violações ⇒ bloco reduzido (análogo ao 3-var atual).
- **G4 (A3):** estabilidade de `b` pre/post-COVID (wrapper `run_het_window` generalizado). Complemento novo: **J-test de sobreidentificação via S ≥ 3 regimes** (sub-dividir NC, e.g. por sub-período ou tercil de volatilidade) — as restrições de sobreidentificação testam exatamente a estabilidade dos parâmetros (Rigobon 2003, seção multi-regime), destravando o teste hoje indisponível com R=2. Disciplina: só sub-dividir onde houver shift real de variância — regimes espúrios quebram a rank condition e produzem inconsistência/CIs infinitos (aviso inverso de Rigobon).
- **G5 (weak-ID):** distribuição bootstrap de λ₁ e da razão de variâncias; se marginal, bandas robustas a weak-ID em vez de percentil ingênuo.
- **G6 (choques comuns, K=0 vs K>0):** testar se fatores globais (SP500/VIX/Brent/UST) carregam nas covariâncias Wed→Thu (ou nos η mensais). Se K>0, ou sobem-se os regimes (S>2, Prop. 2) ou purga-se o fator comum em **VAR de primeira etapa** — a solução do próprio Rigobon na aplicação EMBI. Na aplicação dele, forçar K=0 quando o choque comum existe é rejeitado massivamente (F 8-369); o teste não é opcional.

### 4.6 Propagação

`script/model_alessi.R` (troca da chamada de identificação), `script/irf_spec_sweep.R`/`irf_spec_stage2.R` (novo grid), `script/irf_coherence_check.R` (re-run sob o novo primário; re-apensar leituras manuais), `script/instrument_validation.R` (re-mapear T1-T8: T1 vira permutação de labels de regime, T2/T5/T6 caem com o filtro JK, T8 QLR mantém-se), `CLAUDE.md`, `_instrucoes/` (Instrumento.md e Heteroscedasticidade.md ganham nota de status), `tex/main.tex` + `tex/references.bib` (§ metodologia — fase posterior à validação empírica).

## 5. Confronto svars (produto d)

1. **Regimes contíguos vs intercalados.** `id.cv` define regimes por data(s) de quebra exógena (`SB`, opcional `SB2`) — pré/pós-quebra contíguos. Os regimes Copom/não-Copom são intercalados pelo calendário ⇒ `id.cv` é **inaplicável diretamente**. Escolha do projeto: estimador próprio de momentos/autovalores sobre (Σ_C, Σ_NC) com labels arbitrários — consistente com a formulação GMM de Rigobon (2003), que não exige contiguidade.
2. **B completo vs uma coluna.** `id.cv` estima o B inteiro sob Σ₁ = BB′, Σ₂ = BΛB′ com Λ diagonal — exige que **todas** as variâncias mudem com razões distintas para identificação ponto-a-ponto de todas as colunas. O projeto precisa de **uma coluna** (choque de política) sob A1-A2 — identificação parcial, exatamente a versão de RS-2004 / SW (2016) eq. 45. Seguir os artigos: eigen-decomposição de ΔΣ, não ML de sistema completo.
3. **`id.cvm` não é heterocedasticidade.** É identificação por independência/não-gaussianidade (distância Cramér-von Mises, Herwartz-Plödt) — excluída da comparação como candidata; a menção original à dupla `id.cv`/`id.cvm` fica corrigida aqui.
4. **Uso legítimo do svars:** harness de validação de código — simular DGP com quebra única e B conhecido, verificar que `extract_shock_rigobon_sack` e `id.cv` recuperam a mesma coluna (a menos de sinal/escala). Teste de implementação, não fonte de verdade metodológica.
5. **Inferência.** `id.cv` reporta Wald sequencial sobre autovalores iguais (teste de identificação); o projeto mantém a bateria bootstrap-calibrada (Prop 1 + Lanne-Lütkepohl) — mais adequada a n_C pequeno — e acrescenta o tratamento weak-ID de SW §4.5.3, ausente no pacote.

## 6. Sequência de implementação (fase seguinte — NÃO executada)

1. Rodar gates G1-G6 + pré-cheque de spanning de `yield_6m` (script novo `script/het_primary_feasibility.R`); confirmar A, desviar para A′ (FAVAR híbrido) ou cair para B conforme 4.3; fixar bloco de variáveis.
2. Implementar `build_monthly_regimes()` + `ident_het_regimes()` (ponto: GMM sobre vech(Σ_C, Σ_NC) com init por autovalores) + ramo `identification = "het"` em `compute_irf_dfm` (ramo proxy intacto para robustez); cross-check numérico via IV regime-signed (SW eq. 46, Z_t = D_t·η̂_1t) reutilizando `ident_ext_instr`.
3. Harness de validação vs `svars::id.cv` em DGP simulado de quebra única (e vs a forma fechada eq. 45 em N=2).
4. Adaptar `model_alessi.R`; re-rodar produção (nboot = 800) e coherence check; re-apensar leituras manuais do relatório de coerência. Bandas weak-ID-robustas se G5 marginal.
5. Re-escopar spec sweep (regime × bloco × (r,q) × amostra) e validação (T1 permutação de labels; J-test S≥3; QLR; A3).
6. Atualizar documentação (`CLAUDE.md`, `_instrucoes/`) e, por último, `tex/`.

## 7. Riscos e falhas previsíveis

- **A1 mensal fraca (G1 falha):** cai para arquitetura B com ponte explícita — o paper perde a elegância "tudo em uma frequência", mas mantém honestidade sobre a mecânica.
- **`yield_6m` fracamente spanned pelas inovações dos fatores:** a normalização named-factor quebra (SW §7.5.1/§8.1.4) ⇒ desvio para A′ (FAVAR híbrido com `yield_6m` observado), não insistir no SDFM puro.
- **Weak-ID (SW §4.5.3):** distribuição de b̂ bimodal/caudas pesadas quando Δvar é pequeno **ou T_NC = 52 é insuficiente**; bandas percentílicas/wild-bootstrap enganosas ⇒ G5 e bandas robustas (Magnusson-Mavroeidis/Nakamura-Steinsson) obrigatórias, não opcionais.
- **A2 violada em bloco amplo:** repetir a solução 3-var (bloco reduzido) já validada no diário.
- **Perda do canal de desinflação:** o resultado discriminante de 2026-05-06 (Δipca ≈ −0.10 com `z_het_jk_3var`) usava o filtro JK; sem ele o efeito pode diluir — reportar como está, sem cherry-picking.
