# Stock & Watson (2016) — "Dynamic Factor Models, Factor-Augmented Vector Autoregressions, and Structural Vector Autoregressions in Macroeconomics"

Handbook of Macroeconomics, vol. 2 (Taylor & Uhlig eds.), ch. 8, pp. 415-525, Elsevier.

**Status de leitura:** COMPLETO — 8/8 chunks lidos (batches 1-3). Extração integral com foco em §4.5 (heteroskedasticity), §4.7 (external instruments), §5-6 (SDFM/FAVAR) e §7 (aplicação).

---

## 1. Research question

Survey/user's guide com três perguntas organizadoras: (i) como estimar DFMs (paramétrico via state-space vs não-paramétrico via principal components) e usá-los para monitoring/forecasting; (ii) como identificar structural shocks em SVARs — survey autocontido das técnicas pós-2000 (short-run, long-run, direct measurement, heteroskedasticity, sign restrictions, external instruments); (iii) **como qualquer esquema de identificação SVAR se transporta para structural DFMs (SDFMs) e FAVARs** — a unificação é feita via duas normalizações: a *unit effect normalization* (SVAR) e a *named factor normalization* (DFM). Tema transversal: identificação cada vez mais crível usa variação cada vez menor dos dados → risco de **weak identification** distorcendo inferência frequentista e bayesiana.

## 2. Audience

Macroeconometristas aplicados (SVAR/DFM/FAVAR), staff de bancos centrais (monitoring/nowcasting), e pesquisadores que precisam portar identificação de choques para modelos de alta dimensão. Complementa Ramey (2016, mesmo Handbook): aqui o foco é métodos e econometria; lá, aplicações. Complementa também Bai & Ng (2008, teoria PC), Stock & Watson (2011), Banbura et al. (2013, nowcasting).

## 3. Method (dimensão dominante — survey)

### 3.1 DFM — forma dinâmica (§2.1.1)

- Eq. (1): `X_t = lambda(L) f_t + e_t`
- Eq. (2): `f_t = Psi(L) f_{t-1} + eta_t`
- `X_t` é N×1; `f_t` são q dynamic factors latentes; `lambda(L)` N×q one-sided; `eta_t` q×1 serialmente não correlacionado; `E e_t eta'_{t-k} = 0` para todo k. `lambda_i(L) f_t` = common component da série i.
- Eq. (3): idiossincrático AR: `e_it = delta_i(L) e_{it-1} + nu_it`.
- **Exact DFM**: `E e_it e_js = 0` para i≠j — correlação entre séries só via fatores. Eq. (4): `E[X_it | X_t^{-i}, f_t, ...] = lambda_i(L) f_t`. Eq. (5): forecast one-step reduz a `alpha_i^f(L) f_t + delta_i(L) X_it`.
- **Approximate DFM** (Chamberlain-Rothschild 1983): permite correlação cross-section limitada em `e_t` — é a justificativa teórica dos métodos PC.

### 3.2 DFM — forma estática/stacked (§2.1.2)

- Eq. (6): `X_t = Lambda F_t + e_t`
- Eq. (7): `F_t = Phi(L) F_{t-1} + G eta_t`, com `G = [I_q  0_{q×(r-q)}]'`
- `F_t = (f'_t, f'_{t-1}, ..., f'_{t-p})'` é r×1 (static factors), r ≥ q. Exemplo (8)-(9) com q=1, r=2.
- Quando r > q, os static factors têm **dynamic singularity**: r−q combinações lineares de F_t perfeitamente previsíveis do passado; cov matrix das inovações `G eta_t` tem rank q. "Essa restrição pode ser facilmente imposta nas aplicações deste capítulo." Em macro, r−q estimado costuma ser pequeno; algumas aplicações põem r=q, G=I.

### 3.3 Normalizações dos fatores (§2.1.3) — CRÍTICO para o projeto

Fatores identificados só até `Lambda F_t = (Lambda Q^{-1})(Q F_t)`, Q qualquer r×r invertível.

- **Principal components normalization** — eq. (11): `N^{-1} Lambda' Lambda = I_r` e `Sigma_F = E(F_t F_t')` diagonal (elementos fracamente decrescentes sob PC). (= PC1 de Bai-Ng 2013.)
- **Named factor normalization** — eq. (12): ordene as variáveis de modo que as r primeiras sejam as "naming variables"; então
  `Lambda^NF = [I_r ; Lambda^NF_{r+1:N}]`, `Sigma_F` irrestrita. (= PC3 de Bai-Ng 2013.)
  - Sob (12) os fatores são em geral contemporaneamente correlacionados.
  - Alinha fator e variável: o common component de X_1t É F_1t; uma inovação em F_1t aumenta X_1t em 1 unidade. Ex.: se X_1 = preço do petróleo, F_1 é o "oil price factor".
  - Requer que `Lambda_{1:r}` (bloco r×r das naming variables sob normalização PC) seja invertível: `Lambda^NF_{r+1:N} = Lambda_{1:r}^{-1} Lambda_{r+1:N}` — as inovações dos common components das naming variables devem gerar o espaço das inovações dos static factors. "Naming" é só normalização, sem conteúdo estrutural por si.
- **Timing normalization na forma dinâmica** (§2.1.3.3): `lambda(L) f_t = [lambda(L) q(L)^{-1}][q(L) f_t]` — resolvida escolhendo q variáveis nas quais f_t carrega só contemporaneamente (`lambda_i(L) = lambda_i0`).

### 3.4 Unit roots / low-frequency (§2.1.4) — relevante ao painel não-estacionário do projeto

O capítulo ASSUME X_t pré-processado para I(0): (i) diferenciação remove stochastic trends/drift; (ii) low-pass residual removido por filtro (na aplicação usam biweight, bandwidth 100 trimestres). Cointegração — dois tratamentos: (a) incluir diferenças de uma variável + spreads (error-correction terms) se os spreads carregam nos fatores macro (ex.: curvas de juros); (b) incluir tudo em primeiras diferenças sem spreads — induz spectral density singular em freq. zero entre as cointegradas, mas essa matriz não é estimada por PC (ex.: Brent e WTI ambas em diferenças; o spread WTI-Brent não informa fatores macro). Alternativa fora do escopo: FECM (Banerjee-Marcellino 2009; Banerjee et al. 2014, 2016) — níveis cointegrados com os fatores; a discussão de identificação do capítulo se estende ao FECM. [Nota de projeto: o BLL (Barigozzi-Lippi-Luciani) do projeto é outra rota de não-estacionariedade, não coberta aqui; mas o princípio "identificação transfere" vale.]

### 3.5 Estimação (§2.3)

- **PC** (§2.3.1.1): minimiza eq. (13) `V_r(Lambda, F) = (NT)^{-1} sum_t (X_t - Lambda F_t)'(X_t - Lambda F_t)` s.a. (11); solução `F_hat_t = N^{-1} Lambda_hat' X_t`, `Lambda_hat` = autovetores de `Sigma_hat_X = T^{-1} sum X_t X_t'` dos r maiores autovalores. Bai-Ng (2006a): se N,T→∞ e N²/T→∞, fatores estimados tratáveis como dados em regressões subsequentes.
- **Generalized PC** (§2.3.1.2): eq. (14) pondera por `Sigma_e^{-1}`; feasible: Boivin-Ng (2006) two-step diagonal.
- **Restrições em Lambda** (§2.3.1.3): com `Lambda(theta)` a minimização de (13)/(14) vira least squares restrito (numérico); casos com forma fechada: DFM hierárquico e restrições lineares `vec(Lambda) = R theta`. [Usado na aplicação de petróleo, eq. (60).]
- **State-space** (§2.3.2): MLE/Bayes via Kalman; smoothing intertemporal (PC só faz smoothing contemporâneo cross-section); não robusto a misspecification.
- **Híbrido** (§2.3.3, Doz et al. 2011): PC no passo 1 → parâmetros → Kalman no passo 2; consistente e robusto, interpretação não-paramétrica.
- **Missing data** (§2.3.4): eq. (15) least squares com indicador S_it, minimização alternada; ou EM (Stock-Watson 2002b); state-space lida naturalmente (medição variável no tempo).

### 3.6 Número de fatores (§2.4)

- **r**: scree plot; Bai-Ng (2002) IC — eq. (16): `IC(r) = ln V_r(Lambda_hat, F_hat) + r g(N,T)`, penalidade usual IC_p2 `g(N,T) = [(N+T)/NT] ln[min(N,T)]`; Onatski (2010) cliff de autovalores; Ahn-Horenstein (2013) eigenvalue ratio. Métodos frequentemente discordam → usar também scree e julgamento.
- **q dado r** (§2.4.2): rank da cov das inovações de F_t (singular com rank q<r). Três métodos: **Amengual-Watson (2007)** — projeta X_t em lags de F_hat_t (PC), aplica Bai-Ng (2002) IC à cov dos resíduos; Bai-Ng (2007) — IC no rank da cov residual de um VAR nos r PCs; Hallin-Liška (2007) — frequency domain, rank da spectral density.

### 3.7 Instabilidade (§2.5)

- PC robusto a instabilidade limitada nas loadings (Bates et al. 2013: break discreto em fração O(N^{-1/2}) das séries, ou random walks independentes pequenos → consistência preservada na taxa 1/min(N,T)).
- Break disseminado em Lambda (eq. 17, dois regimes) → full sample parece ter 2r fatores; Bai-Ng (2002) superestima r (Breitung-Eickmeier 2011).
- Testes: Stock-Watson (2009) equação a equação; Breitung-Eickmeier (2011) LM; Chen et al. (2014); Han-Inoue (2015) — cuidado: alguns têm poder contra **heteroskedasticidade das inovações dos fatores** e contra breaks no VAR dos fatores, não só contra breaks em Lambda (a evidência de break em 1984/2007 nos EUA é consistente com break em Sigma_eta, não em Lambda). [Relevante ao projeto: um "break" detectado pode ser exatamente o regime de heteroskedasticidade que a identificação Rigobon explora.]

### 3.8 SVAR — framework (§4.1)

- VAR reduzido eq. (18): `Y_t = A_1 Y_{t-1} + ... + A_p Y_{t-p} + eta_t`, `A(L) Y_t = eta_t`; eta_t MDS, cov `Sigma_eta`. VMA eq. (19): `Y_t = C(L) eta_t`, `C(L) = A(L)^{-1}`.
- SVAR eq. (20): `eta_t = H eps_t`; eq. (21): `Sigma_eps` diagonal (choques mutuamente não correlacionados). Eq. (22): `A(L) Y_t = H eps_t` ou `B(L) Y_t = eps_t`, `B(L) = H^{-1} A(L)`. Eq. (23): `Y_t = D(L) eps_t`, `D(L) = C(L) H`.
- SIRF eq. (24): `SIRF_ij = {D_h,ij}`, `D_h = C_h H`; `D_0 = H` (impact). FEVD eq. (25).
- **System identification** (§4.1.1.5): requer H invertível — eq. (26): `eps_t = H^{-1} eta_t`; eq. (27): `Sigma_eta = H Sigma_eps H'` → n(n+1)/2 equações, n(n+1) parâmetros → após n normalizações de escala, faltam n(n−1)/2 restrições.
- **Single shock identification** (§4.1.1.6) — o caso do projeto: só interessa eps_1t. Eq. (28): `eta_t = [H_1 H_•](eps_1t, eta~_•t)'` com `cov(eps_1t, eta~_•t) = 0`; **não é preciso identificar os demais choques nem que as inovações os gerem**. Eq. (29): `Y_t = C(L) H_1 eps_1t + C(L) H_• eta~_•t` — SIRF do choque 1 = `C(L) H_1`. Eq. (30): `eps_1t = H^1 eta_t ∝ [1 H~^{1•}] eta_t` — conhecer H_1 (+ Sigma_eta + choques não correlacionados) determina o choque up to scale; identificação de H_1 e do choque são intercambiáveis. Construção alternativa via projeção (nota r): `eps_1t ∝ H_1' eta_t - Proj(H_1' eta_t | eps_•t)`.

### 3.9 Invertibility (§4.1.2)

MA estrutural invertível se eps_t recuperável de Y corrente e passado ("fundamental"). Três fontes de não-invertibilidade: (i) poucas variáveis no VAR (omitted variable bias); (ii) measurement error (errors-in-variables); (iii) news shocks (exemplo MA(1) `Y_t = eps_t − d eps_{t−1}`, |d|>1 → eps recuperável só do futuro). Segundo momentos NÃO distinguem invertível de não-invertível: `(d, sigma²)` e `(d^{-1}, d² sigma²)` observacionalmente equivalentes. **SDFMs mitigam measurement error, omitted variables e, em alguns casos, news, pelo uso de muitas séries (Forni et al. 2009; detalhado na §5).** [Argumento central pró-DFM do projeto.]

### 3.10 Unit effect normalization (§4.1.3) — CRÍTICO

- Unit standard deviation normalization — eq. (31): `Sigma_eps = I` (não fixa sinal).
- **Unit effect normalization — eq. (32): `H_jj = 1`** — uma unidade de eps_jt aumenta eta_jt (e portanto Y_jt) em 1 unidade contemporaneamente. Para single shock — eq. (33): `H_1 = (1, H_{•1})'` (primeiro elemento 1).
- Três razões para preferir unit effect: (1) unidades com significado para política (efeito de 25bp, não de "1 desvio-padrão"); (2) **em amostra as duas não são intercambiáveis**: computar bandas sob unit-sd e renormalizar dividindo por `H_hat_11` introduz sampling uncertainty extra — "se H_11 estiver perto de zero, renormalização introduz problemas de inferência relacionados a weak instruments" (no bootstrap: a conversão de unidades deve ser feita **em cada draw**, o que equivale a usar unit effect desde o início); (3) unit effect permite estender identificação SVAR diretamente a SDFMs.
- Variante: normalizar choque j com efeito unitário na variável i (H_ij = 1); só importa quando dois choques distintos são normalizados na MESMA variável.

### 3.11 Resumo das hipóteses SVAR (§4.1.4)

- **(SVAR-1)** inovações geram o espaço do(s) choque(s): (a) sistema: eta_t = H eps_t, H^{-1} existe; (b) single shock: (28) vale e H^1 existe.
- **(SVAR-2)** choques estruturais não correlacionados (21).
- **(SVAR-3)** escala normalizada por (31) ou (32).
- **(SVAR-4)** eta_t = erros de previsão one-step do VAR(p) com parâmetros invariantes.
- **(SVAR-5)** A(L) invertível (variáveis transformadas a estacionárias; alternativamente níveis → SIRF vira cumulative SIRF).
- Única exceção: direct measurement do choque requer só SVAR-2.

### 3.12 Short-run restrictions (§4.2)

Sistema: Cholesky/Wold causal chain — `H = Chol(Sigma_eta) Sigma_eps^{-1/2}` com `Sigma_eps = diag({[Chol(Sigma_eta)_jj]²})` sob unit effect. Single shock, 3 exemplos: (i) variável 1 responde só ao choque 1 → `eps_1t = eta_1t` (ordenada primeiro); (ii) choque afeta só uma variável dentro do período (ordenada por último); (iii) **Slow-r-Fast** (CEE 1999; Bernanke-Boivin-Eliasz 2005) — eq. (34): bloco-recursivo (Y^s lentas, r_t, Y^f rápidas); choque de política = resíduo da regressão de eta^r_t nas eta^s_t. [É o esquema FAVAR clássico de identificação de política monetária.]

### 3.13 Long-run restrictions (§4.3) e a ponte IV/weak-IV

- Eq. (35): `Omega = A(1)^{-1} Sigma_eta A(1)^{-1'} = D(1) Sigma_eps D(1)'`; D(1) lower triangular (Blanchard-Quah 1989; Gali 1999) → eq. (36): `H = A(1) Chol[A(1)^{-1} Sigma_eta A(1)^{-1'}]`.
- **Interpretação IV** (§4.3.3, Shapiro-Watson 1988): no VAR(1) bivariado sob unit effect, eq. (37)-(38); a restrição `B(1)_12 = 0` exclui `Y_2t-1` da 1ª equação → instrumento para `Delta Y_2t`; eq. (39): `H_hat_12 = sum(Delta Y_1t Y_2t-1) / sum(Delta Y_2t Y_2t-1)`. Equation counting ≡ ter instrumento válido.
- **Digression weak IV** (§4.3.4): modelo (40) `Y_1t = beta Y_2t + u_t; Y_2t = pi' Z_t + v_t`; estimador IV eq. (41). Concentration parameter `mu² = pi' Z'Z pi / sigma_v²`; `mu²/k` = noncentrality do F do 1º estágio; **rule of thumb: problema relevante se first-stage F < 10 (Staiger-Stock 1997)**. Consequências de pi pequeno: viés, caudas pesadas, t não normal.
- §4.3.5: em long-run ID, instrumento fraco quando raiz α perto de 1 — concentration `T(alpha−1)²/(1−alpha²)`; T=100: 5.3 para α=0.9, 2.6 para α=0.95. Gospodinov (2010); Chevillon et al. (2015) constroem confidence sets robustos (mudam conclusões de Blanchard-Quah).

### 3.14 Direct measurement (§4.4)

Narrativa (Romer-Romer 1989, 2004, 2010; Ramey-Shapiro 1998) e high-frequency (Kuttner 2001 — mudança do Fed Funds futures no dia do anúncio FOMC; Cochrane-Piazzesi 2002; Gürkaynak et al. 2005; Nakamura-Steinsson 2015). Dois desafios: (i) exogeneidade (informação interna do Fed = information effect; janela larga contamina) — **sem resolução econométrica, é design**; (ii) o choque construído raramente mede o choque inteiro → errors-in-variables → viés se componente medido correlacionado com não medido — **resolvível usando a série como external instrument (§4.7)**. [Exatamente a justificativa do desenho GK/JK do projeto.]

### 3.15 Identification by Heteroskedasticity (§4.5) — EXTRAÇÃO INTEGRAL (foco do projeto)

#### §4.5.1 Regimes (Rigobon 2003; Rigobon-Sack 2003, 2004)

Premissa: **H constante no full sample**, mas dois regimes de variância dos choques estruturais, com matrizes diagonais `Sigma_eps^1` e `Sigma_eps^2`. Como `eta_t = H eps_t` nos dois regimes:

- **Eq. (42):**
  `Sigma_eta^1 = H Sigma_eps^1 H'`
  `Sigma_eta^2 = H Sigma_eps^2 H'`

**Contagem (order condition):** cada equação matricial dá n(n+1)/2 equações distintas → total n² + n. Sob **unit effect normalization (diagonal de H = 1)**, H tem n² − n incógnitas + 2n variâncias estruturais desconhecidas = n² + n incógnitas. **Número de equações = número de incógnitas** (exatamente identificado).

**Rank condition e o caso de falha proporcional:** as equações precisam trazer informação independente. **Heteroskedasticidade proporcional `Sigma_eps^2 = a Sigma_eps^1` não traz informação nenhuma**, porque então `Sigma_eta^2 = a Sigma_eta^1` e as equações do 2º regime repetem as do 1º. **Em prática é difícil checar a rank condition porque Sigma_eta^1 e Sigma_eta^2 são estimadas** — mesmo sob proporcionalidade populacional, as estimativas amostrais não serão proporcionais por variabilidade amostral. [Diretamente o teste de proporcionalidade Rigobon Prop. 1 / rank-1 LR que o projeto implementa em `het_rank_test*.csv`.]

**Onde entra o raciocínio econômico (dois lugares):**
1. Defender que **H não varia entre regimes** (invariância do mecanismo de transmissão, mesmo com variâncias mudando).
2. Quando os choques não são naturalmente associados a uma variável observável: Rigobon (2003) exemplo oferta/demanda — o aumento da variância relativa do choque de oferta identifica a inclinação da demanda, mas requer conhecimento a priori sobre QUAL variância relativa mudou. **Rigobon-Sack (2004) e Wright (2012): fato institucional de que o choque de política monetária tem variância muito maior em datas de anúncio, enquanto plausivelmente seu efeito (H_1) é o mesmo em datas de anúncio e fora delas.** Essa heteroskedasticidade em torno de anúncios é "uma variante da abordagem da Section 4.4 em que o choque é medido como mudanças em alguma taxa de mercado em torno do anúncio". [= exatamente o desenho Copom do projeto: dias de Copom = regime C.]

Referências adicionais: Lütkepohl-Netšunajev (2015), Kilian (2015).

#### §4.5.2 Conditional heteroskedasticity

- **Eq. (43):** `E(eta_t eta_t' | Y_{t-1}, ...) = H E(eps_t eps_t' | Y_{t-1}, ...) H'`, com cov condicional de eps_t diagonal.
- GARCH nos eps_t + (43) identifica H: Sentana-Fiorentini (2001), Normandin-Phaneuf (2004). Lanne et al. (2010): Markov switching (regime latente; ver Hamilton 2016).

#### §4.5.3 IV interpretation e potential weak identification — INTEGRAL

Setup ilustrativo: n=2, variância do choque 1 (política monetária) varia entre regimes, a do choque 2 NÃO varia — hipótese de Rigobon-Sack (2004) e Wright (2012) com high-frequency data (variância de eps_1t elevada em torno de anúncios FOMC; a dos demais choques não muda). Sob unit effect normalization, (42) vira:

- **Eq. (44):**
  `[Sigma^j_{eta1eta1}, Sigma^j_{eta1eta2}; Sigma^j_{eta2eta1}, Sigma^j_{eta2eta2}] = [1, H_12; H_21, 1] [sigma²_{eps1,j}, 0; 0, sigma²_{eps2}] [1, H_21; H_12, 1]`, j = 1, 2,
  onde `sigma²_{eps1}` varia entre regimes e `sigma²_{eps2}` não.

- **Eq. (45) — identificação em forma fechada:**
  `H_21 = (Sigma²_{eta1eta2} − Sigma¹_{eta1eta2}) / (Sigma²_{eta1eta1} − Sigma¹_{eta1eta1})`
  = mudança na COVARIÂNCIA entre eta_1t e eta_2t relativa à mudança na VARIÂNCIA de eta_1t.

- **Eq. (46) — estimador IV:**
  `H_hat_21 = sum_t(eta_hat_2t Z_t) / sum_t(eta_hat_1t Z_t)`,
  com **`Z_t = D_t eta_hat_1t`, onde `D_t = −1/T_1` no regime 1 e `D_t = +1/T_2` no regime 2** (T_1, T_2 = nº de observações por regime), e `eta_hat_t` são as inovações estimadas por OLS full-sample (ou WLS).
  → (46) É o estimador IV da regressão de eta_hat_2t sobre eta_hat_1t usando Z_t como instrumento. Os autores notam a analogia com (39) (long-run ID): mesma estrutura IV vinda de restrição identificadora completamente diferente.

**Weak identification (§4.5.3, parágrafos finais — prescrições):**
- Instrumento fraco ⇔ Z_t fracamente correlacionado com eta_hat_1t ⇔ **a mudança populacional na variância de eta_1t (denominador de (45)) é pequena**.
- **Staiger-Stock (1997) weak-instrument asymptotic nesting:** sob condições de momento padrão, `H_hat_21 →d z_2/z_1`, com (z_1, z_2) conjuntamente normais e **E[z_1] = T^{1/2}(Sigma²_{eta1eta1} − Sigma¹_{eta1eta1})**. Se a variabilidade de z_1 for grande relativa a essa média → **distribuição não normal, potencialmente bimodal, caudas pesadas, e "inference based on conventional bootstrap confidence intervals will be misleading"** [bootstrap convencional NÃO conserta weak-ID het].
- Dois cenários de fraqueza: (a) muitos obs em cada regime mas diferença de variâncias pequena; (b) diferença grande mas **um dos regimes com poucas observações**. Em ambos, o que importa é **a precisão da estimativa da mudança de variância de eta_1t relativa à mudança verdadeira**. [Para o projeto: nº de dias/meses Copom no regime C é o binding constraint.]
- **Inferência robusta a weak-ID em SVAR-het está em estágio inicial: Magnusson-Mavroeidis (2014)** — abordagem geral de construção de confidence sets robustos a identificação fraca; **Nakamura-Steinsson (2015)** — implementam inferência robusta a weak-ID na aplicação com heteroskedasticidade diferencial do choque de política monetária em torno de anúncios FOMC. [Prescrição direta: reportar sets robustos tipo Anderson-Rubin/S-sets, não apenas bootstrap.]

### 3.16 Sign restrictions (§4.6) — resumo

- Faust (1998), Uhlig (2005): restrições de desigualdade no SIRF → **set identification** de H (ou H_1). Algoritmo bayesiano padrão (Uhlig): unit-sd normalization, `H = Sigma_eta^{1/2} Q`, Q ortonormal; prior conjugada Normal-Wishart no reduced form + prior sobre Q; draw-and-retain (eq. 47); n=2: Q via rotação (48), θ ~ U[0,2π]; n>2: QR/Householder (Rubio-Ramírez et al. 2010).
- Problemas (exemplo analítico eqs. 49-50): (i) **Moon-Schorfheide (2012)**: posterior coverage set fica estritamente DENTRO do identified set em large samples → cobertura frequentista 0% para alguns valores verdadeiros; (ii) prior "flat" sobre Q é informativa para o SIRF (Baumeister-Hamilton 2015a) — no exemplo, posterior de D_h,21 concentra em valores altos (mediana 0.707·α₂^h dentro de [0, α₂^h]).
- §4.6.2.1: sob unit-sd normalization, a conversão a native units **tem de ser feita draw a draw** — não há estimador consistente de H no caso set-identified.
- Novas abordagens: frequentistas Moon et al. (2013), Gafarov-Montiel Olea (2015, só restrições de impacto); bayesianas Baumeister-Hamilton (2015a, prior direto no impact multiplier), Giacomini-Kitagawa (2014, robust Bayes — união de posteriors sobre a classe de priors de Q; escapa da crítica Moon-Schorfheide), Plagborg-Møller (2015, prior sobre o IRF inteiro; lida com não-invertibilidade).

### 3.17 Method of external instruments (§4.7) — o baseline atual do projeto

Devida a Stock (2008); usada por Stock-Watson (2012a), **Mertens-Ravn (2013)**, **Gertler-Karadi (2015)**. "Proxy VAR" = mesmo método.

**Condições sobre o instrumento Z_t (single shock eps_1t):**
- **(i) Relevance — eq. (51):** `E(eps_1t Z_t') = alpha' ≠ 0`
- **(ii) Exogeneity — eq. (52):** `E(eps_jt Z_t') = 0, j = 2, ..., n`

Com (21) (choques não correlacionados) e unit effect normalization (32):
- **Eq. (53):** `E(eta_t Z_t') = E(H eps_t Z_t') = [H_1 H_•][E(eps_1t Z_t'); E(eps_•t Z_t')] = H_1 alpha' = [alpha'; H_{1•} alpha']`
- **Eq. (54) (um instrumento):** `H_{•1} = E(eta_{•t} Z_t) / E(eta_1t Z_t)` — coeficiente da IV regression populacional de eta_jt sobre eta_1t usando Z_t como instrumento. [= o `H = (Z'eta)/(Z'Z)` normalizado do `ident_ext_instr()` do projeto.]

Ponto conceitual: medidas construídas de choques (Cochrane-Piazzesi etc.) **não são o choque, são instrumentos para o choque** — SVARs que as incluem como variável medem reduced-form IRF w.r.t. o instrumento; o método de external instruments mede o SIRF w.r.t. o choque estrutural.

**Weak IV em external instruments:** "os detalhes são suficientemente diferentes da IV regression para que os métodos de inferência sob weak identification não se apliquem diretamente; trabalho em andamento (Montiel Olea et al., 2016)" [= Montiel Olea-Stock-Watson, a referência do ξ_mp do projeto].

### 3.18 SDFM (§5.1) — A PONTE PARA O DFM (arquitetura A vs B)

**Motivação (§5 abertura):** SDFMs resolvem três deficiências de SVARs: (1) muitas variáveis → inovações geram o espaço dos choques (omitted variables); (2) choques atingem os FATORES, não os idiossincráticos → measurement error tratado; (3) SIRFs/FEVDs/decomposições históricas internamente consistentes para arbitrariamente muitas variáveis. Nº de parâmetros cresce ∝ n (DFM) vs n² (VAR grande, que exige priors).

**O modelo — eqs. (55)-(57):**
- (55): `X_t = Lambda F_t + e_t`  (n×r, r×1)
- (56): `Phi(L) F_t = G eta_t`, `Phi(L) = I − Phi_1 L − ... − Phi_p L^p`  (G é r×q, eta_t q×1)
- (57): **`eta_t = H eps_t`** com H **q×q invertível** (choques estruturais recuperáveis das inovações dos fatores), Sigma_eps diagonal, e SVAR-1 a SVAR-3 valendo.
- **Os q choques estruturais eps_t impactam os common factors mas NÃO os termos idiossincráticos.**
- **Eq. (58) — SIRF:** `X_t = Lambda Phi(L)^{-1} G H eps_t + e_t`; SIRF = `Lambda Phi(L)^{-1} G H`; para um só choque: **`SIRF_1 = Lambda Phi(L)^{-1} G H_1`**.
- SVAR = caso especial com e_t = 0, r = q = n, Lambda = I, G = I.

**Citação-chave (§5, abertura, sobre portar identificação):** "These normalizations do not identify the monetary policy shock, but **any scheme that would identify the monetary policy shock in a SVAR can now be used to identify the monetary policy shock from the factor innovations**." — a identificação é feita NO NÍVEL DAS INOVAÇÕES DO FACTOR VAR (eta_t), qualquer que seja o esquema (short-run, long-run, het, sign, external instrument). [EVIDÊNCIA ARQUITETURA A: aplicar Rigobon regime-split diretamente às eta_t mensais é exatamente o template do capítulo.]

**Encadeamento das normalizações (exemplo do próprio texto):** "a one percentage point positive monetary supply shock increases the innovation in the Fed funds factor by one percentage point, which increases the innovation to the common component of the Federal funds rate by one percentage point, which increases the Federal funds rate by one percentage point."

#### §5.1.2 Combinando unit effect + named factor

**Caso r = q:** set `G = I`. Named factor normalization (12) para Lambda + unit effect (32) para H. Estimação sem restrições extras: PC primeiro, depois transformação — **eq. (59):**
`Lambda_hat = [I_r ; Lambda_hat^PC_{r+1:n} (Lambda_hat^PC_{1:r})^{-1}]` e `F_hat_t = Lambda_hat^PC_{1:r} F_hat_t^PC`.
Impact effect de eps_1t sobre X_1t = `Lambda_1 H_1 = 1` (pois Lambda_1 = (1 0 ... 0) e H_11 = 1).

**Overidentifying restrictions em Lambda — eq. (60) (4 preços de petróleo):** as 4 séries de preço (PPI-oil, Brent, WTI, RAC, em logs/diferenças) carregam TODAS com coeficiente 1 no primeiro fator (oil price factor); estimação por restricted PC (minimização numérica de (13)/(14) sujeita às restrições). "Qualquer uma das 4 primeiras linhas é a naming normalization; as demais são restrições adicionais que tratam os outros preços como indicadores adicionais." [Análogo possível no projeto: múltiplos vértices da curva DI como indicadores do fator de política.]

**Caso r > q — eq. (61):** `G = [I_q ; G_{q+1:r}]` com `G_{q+1:r}` irrestrito (r−q)×q. Construção populacional: obtenha inovações `a_t` do factor VAR (`Phi(L) F_t = a_t`; `Sigma_a` tem rank q); particione `a_t = (a_1t', a_2t')'` com a_1t q×1; **set `eta_t = a_1t`** e `G_{q+1:r} = Sigma_{a,21} Sigma_{a,11}^{-1}`. Em amostra: `eta_hat_t = a_hat_1t` (primeiras q inovações do VAR nos F_hat) e `G_hat_{q+1:r}` = coeficientes da regressão de a_hat_2t sobre eta_hat_t. Requer bloco q×q superior de Sigma_a full rank. [No projeto: r=6, q=5 → esse passo existe e o eta_t usado na identificação het deve ser a_1t, com as naming variables definindo QUAIS inovações são as q primeiras.]

**§5.1.2.3 Estimation given an identification scheme — CITAÇÃO DECISIVA:** "With the normalization set, **the identification schemes discussed in Section 4 carry over directly. The innovation eta_t in Section 4 is now the innovation to the factors**, however, the factors (or the subset that are needed) have now been named, and the scale has been set on the structural shocks, so all that remains is to implement the identification scheme. **The formulas in Section 4 carry over with the notational modification of setting A(L) in Section 4 to Phi(L)**." [Portanto §4.5 eqs. (42)-(46) aplicam-se verbatim com eta_t = inovações do factor VAR — arquitetura A é literalmente o que o capítulo prescreve. A questão empírica remanescente é se o regime split mensal (meses com/sem Copom) gera diferença de variância forte o suficiente — o critério é o weak-ID do §4.5.3.]

#### §5.1.3 Standard errors para SIRFs — parametric bootstrap

"Aplica-se **apenas quando há strong identification**" (como outros bootstraps padrão). Passos:
1. Estimar Lambda, F_t, Phi(L), G, Sigma_eta; resíduo idiossincrático `e_hat_t = X_t − Lambda_hat F_hat_t`.
2. AR univariado em cada e_hat_it (o capítulo usa AR(4)).
3. Draw: eta~_t ~ N(0, Sigma_hat_eta), zeta_it ~ N(0, sigma_hat²); gerar e~_t, F~_t, `X~_t = Lambda_hat F~_t + e~_t`.
4. Reestimar tudo (Lambda, F, Phi(L), G, H) no draw → SIRF bootstrap. Para subset de choques, usar só as colunas relevantes de H.
5. Repetir; construir SEs/CIs/testes.
Variações: block bootstrap dos resíduos. Literatura de bootstrap em DFM: Yamamoto (2012), Corradi-Swanson (2014), Gonçalves-Perron (2015), Gonçalves et al. (forthcoming). [Nota: o projeto usa wild bootstrap Gonçalves-Kilian — mesma família de validade. E o caveat "only under strong identification" é a razão para reportar ξ_mp/AR sets junto.]

### 3.19 FAVAR (§5.2)

FAVAR = DFM com restrição de que um ou mais fatores são OBSERVADOS sem erro por variáveis observáveis. Representação 1 — eqs. (62)-(64): `(Y_t; X_t) = [1, 0_{1×r}; Lambda](F~_t; F_t) + (0; u_t)`; `F_t^+ = Phi(L) F^+_{t-1} + G eta_t`; `eta_t = H eps_t` — combina unit effect nos loadings com ausência de idiossincrático na variável que observa F~_t. Representação 2 — eqs. (65)-(67): substitui Y_t = F~_t, Y_t entra como fator diretamente; **"the SDFM identification problem becomes the SVAR identification problem, where the VAR is now in terms of (Y_t, F_t')"**. Estimação por least squares; overidentifying restrictions em Lambda via restricted LS.

Ilustração Bernanke-Boivin-Eliasz (2005) slow-R-fast — eqs. (68)-(70): bloco-recursivo em (F^s_t, r_t, F^f_t) com H com diagonal 1 (eq. 70) e zeros acima; restrições overidentifying em Lambda (eq. 68) impostas por restricted PC.

[EVIDÊNCIA ARQUITETURA B (ponte diário→mensal): o capítulo NÃO desenvolve bridging de um sistema diário para um DFM mensal. O mais próximo de B no framework do capítulo seria tratar o choque diário identificado por het como Z_t (external instrument, §4.7) e projetar as eta_t mensais nele — ou seja, B reduz-se ao método §4.7 com um Z_t mais bem construído; A é o §4.5 aplicado a eta_t com a mudança notacional A(L)→Phi(L). O capítulo dá template formal para AMBOS, mas o único desenho het que ele discute com endosso institucional (announcement dates, Rigobon-Sack 2004/Wright 2012) é de frequência alta.]

### 3.20 O DFM pode ser aproximado por um VAR pequeno? (§6.4)

Pergunta (atribuída a Chris Sims): um VAR de poucas variáveis pode substituir o DFM? Duas versões: forte (variáveis geram o espaço dos fatores) e fraca (inovações do VAR geram o espaço das inovações dos fatores). Método: canonical correlations (Bai-Ng 2006b). Resultado (Table 5): VAR-A (4 vars típicas) e VAR-B (8 vars típicas): últimas 4 canonical correlations das INOVAÇÕES < 0.40; mesmo VAR-C (8 vars escolhidas por stepwise para maximizar as correlações) tem as 3 últimas < 0.60. Painel B: as variáveis observáveis não aproximam bem os fatores (VAR-B: 3 correlações < 0.50). **Conclusão: "typical VARs... fail to span the space of the factors and their innovations fail to span the space of the factor innovations"** — o DFM produz inovações de fatores com informação que não está em VARs pequenos. [Justifica preferir identificar nas eta_t do DFM (A) a identificar num VAR diário pequeno de asset prices e importar (B) — o sistema diário pequeno pode não gerar o espaço relevante.]

### 3.21 Resultados Kilian ID (§7.5.2) e Lessons (§7.6)

- **Oil supply shock (Fig. 9):** os três modelos identificam-no da mesma forma (= one-step forecast error de oil production, difícil de prever independente do conditioning set) → choques altamente correlacionados (Table 8: SDFM-FAVAR 0.95, SDFM-SVAR 0.88) e SIRFs quase idênticos. FEVD (Table 7): oil supply explica frações pequenas de tudo (GDP 0.01-0.04; oil price 0.10-0.14; oil production 0.75-0.78).
- **Global demand shock (Fig. 10):** SDFM difere notavelmente de FAVAR/SVAR (estes dois similares entre si, correlação 0.82); **FAVAR e SVAR são ATENUADOS relativos ao SDFM**. Explicação (consistente com §5): (a) o choque de demanda global É gerado pelo espaço das inovações dos fatores (Table 6); (b) **a inovação do commodity index observado é medida ruidosa da inovação do fator global latente → proxy imperfeito → measurement error → atenuação dos IRFs**; (c) forecast errors one-step similares nos dois conditioning sets. Quantitativo: demanda global explica 44% do FEV de 6 trimestres do preço do petróleo no SDFM vs 22% no FAVAR.
- **Oil-specific demand (Fig. 11):** FAVAR/SVAR também atenuados. Sutileza: o SDFM separa DOIS choques específicos de petróleo — um comum (afeta outros macro vars; pequeno) e disturbâncias puramente idiossincráticas de cada preço (sem efeito nos demais); FAVAR/SVAR têm um único choque que MISTURA os dois (explica metade do FEV do preço do óleo mas quase nada dos macro).
- **Lessons (§7.6):** (1) quando a inovação relevante é bem gerada pelo espaço das inovações dos fatores E é difícil de prever, tanto faz SDFM/FAVAR/SVAR (caso oil-exogenous); (2) quando o choque de interesse NÃO está no espaço das inovações dos fatores (oil production), tratá-lo como fator latente produz ruído — **usar observed factor (FAVAR híbrido)**; (3) quando a variável observável mede o fator com erro (global demand), **preferir o SDFM** — FAVAR/SVAR sofrem measurement error nas inovações e portanto nos IRFs (atenuação). Substantivo: oil supply shocks explicam pouco da atividade US desde ~1980; demanda agregada domina os movimentos do preço do petróleo.

### 3.22 Recomendações práticas e assessment (§8)

- **§8.1.1 Variable selection / data processing:** princípio-guia — "the factor innovations should span the space of the most important shocks that in turn affect the evolution of the variables of most interest". Pré-processar a I(0) (diferenças); os autores defendem adicionalmente a remoção de low-frequency trends via lowpass filter (períodos de década+) — incomum na literatura mas importante (trends demográficos confundem a modelagem de curto/médio prazo).
- **§8.1.2 Parametric vs nonparametric:** diferenças práticas pequenas; **nonparametric (PC / least squares) é o default apropriado** — simplicidade computacional, sem modelo dinâmico paramétrico para estimar fatores, lida com missing data/mixed frequency.
- **§8.1.3 Instabilidade:** testar sempre (testes single-equation de livro-texto sobre regressões da variável nos fatores). Sutileza: PC é robusto a variação moderada → pode ser apropriado **estimar fatores no full sample mas loadings em split sample**.
- **§8.1.4 Quatro questões para análise estrutural (síntese do capítulo):**
  1. Identificação SVAR transfere diretamente a SDFMs via unit effect normalization (32) + named factor normalization (12).
  2. **Weak identification — "This concern applies equally to SVARs, FAVARs, and SDFMs."** Todos os métodos de identificação são interpretáveis como GMM/IV → parâmetros de H podem ser fracamente identificados → "SIRFs will in general be biased and confidence intervals will be unreliable. As of this writing, some methods for identification-robust inference in SVARs have been explored but **there is not yet a comprehensive suite of tools available**."
  3. Sign-identified: priors aparentemente não informativos induzem posteriors informativos (área ativa).
  4. **Específico de SDFM: o choque identificado pode não ser gerado pelas inovações dos fatores** (escopo estreito de variáveis, ou choque sem consequência macro). Nesse caso a named factor normalization QUEBRA (não há common component da variável) e "the SDFM approach is not reliable" → solução: hybrid SDFM com o fator observado. [Checklist para o projeto: verificar R²/FEVD do common component da variável de política e da variável usada para o regime het antes de confiar no SDFM puro.]
- **§8.2.1:** poucos fatores descrevem os comovimentos: média de R² dos 8 fatores nas 207 séries = 51%; GDP 81%, employment 93%, PCE deflator 64%, term spread 10y-3m 72%, S&P500 73% (agregados NÃO usados na estimação).
- **§8.2.2:** DFMs melhoram forecasts — "nuanced yes"; melhores para atividade real.
- **§8.2.3 SDFM > SVAR?** Duas vantagens: (i) muitas variáveis geram melhor o espaço dos choques — "a method to identify shocks could fail in a SVAR because of measurement error or idiosyncratic variation, but succeed in identifying the shock in a SDFM"; (ii) SIRFs internamente consistentes para número arbitrário de variáveis — **"The SDFM separates the tasks of identifying the structural shock and estimating a SIRF for variables of interest."**

## 4. Data (aplicação §6-7)

- **207 séries trimestrais US**, 1959Q1–2014Q4 (145 disponíveis no span completo); categorias: NIPA (20), IP (11), emprego/desemprego (45), orders/inventories/sales (10), housing (8), preços (37), produtividade/salários (10), juros (18), moeda/crédito (12), internacional (9), asset prices/wealth (15), other (2), oil market (10). Estende Stock-Watson (2012a) com o índice de atividade global de Kilian (2009) e variáveis de petróleo.
- **139 séries usadas para estimar fatores** (agregados de alto nível excluídos porque seus idiossincráticos são colineares com os dos componentes desagregados — ex.: GDP, IP total, emprego total ficam fora; só os 7 setoriais de IP entram).
- Real activity dataset: 86 séries (58 desagregadas para fatores).
- **Transformações:** (1) para I(0) — growth rates para atividade real, 1ª diferença de juros, 1ª diferença da inflação para preços; guiadas por unit root tests + julgamento, uniformes dentro de categoria; spreads modelados como I(0) (error correction imposto seletivamente); (2) remoção de outliers; (3) **detrending por biweight low-pass filter, bandwidth 100 trimestres** (`w_j = c(1−(j/B)²)² para |j|≤B`; truncado e renormalizado nas pontas) — remove o slowdown demográfico de ~1pp no crescimento; racional: ignorar trends confunde IRFs de choques transitórios com trends lentos; (4) padronização a unit sd.
- Monthly → quarterly por média temporal.
- **Estimação estrutural (§7) em 1985Q1–2014Q4** por causa da evidência de break em 1984.

## 5. Statistical/numerical methods

(Ver §3 — dominante. Escolhas empíricas da aplicação:)
- **Número de fatores (full dataset):** Bai-Ng IC_p2 escolhe r=4; Ahn-Horenstein escolhe 1; marginal trace R² decai suave (0.040 no 4º, 0.024 no 8º). **Amengual-Watson escolhe q=3** dado r entre 3 e 8. Trace R² do 1º fator = 0.215 (full) vs 0.385 (real activity). **Decisão para o SDFM: r = 8** ("erramos para o lado de sobre-especificar o espaço de inovações para que gerem o espaço dos choques de interesse") **e q = r = 8, G = I**, apesar de AW sugerir q=3. [Precedente direto para o projeto usar r=6>q=5 com override manual do auto-IC.]
- **Estabilidade (§6.3.2, Table 4):** Chow 1984q4 e QLR (sup-Wald, 70% central) equação a equação usando fatores full-sample como regressores: >50% das séries rejeitam a 5% (4 fatores), ~2/3 (8 fatores); QLR rejeita mais. Magnitude: correlação entre common components sub/full sample alta para a maioria (mediana >0.9 em atividade real) mas <0.5 para 5% das séries; pior em preços, produtividade, moeda/crédito e petróleo. Interpretação: consistente com break ~1984 (Great Moderation) — motivo do sample 1985+ na parte estrutural.
- Scree plots por subsample notavelmente estáveis no real activity dataset (trace R² 1º fator: 38.5% full, 41.1% pre-84, 38.7% post-84; correlação entre fator full e subsample > 0.99).
- FEVD h-step no DFM: fração explicada = `var(Lambda sum_{i=0}^{h-1} Phi_i G eta_{t-i})` sobre o total, com `var(e_t|passado)` via AR(4).

## 6. Findings

- Um único fator explica R² 0.73 (GDP) a 0.92 (employment) das four-quarter growth rates dos agregados US; real activity dataset: 1 fator = 38.5% do trace R², Amengual-Watson aponta 1 fator dinâmico.
- Full dataset: 4-8 fatores; fatores 2-4 explicam headline inflation, oil prices, housing, financeiras; 5-8 explicam produtividade, compensação, term spread, câmbio (Table 3).
- Higher factors: literatura (De Mol et al. 2008; SW 2012b empirical Bayes) sugere pouco ganho preditivo, mas questão aberta.
- **§6.4:** VARs pequenos não geram o espaço das inovações dos fatores (ver 3.20).
- **§7.4 (oil exogenous):** SIRFs do SDFM, FAVAR e SVAR muito próximos em h<8 (choque de preço de petróleo bem coberto pelo common component; correlação entre choques dos 3 modelos ≥ 0.72); FAVAR/SVAR levemente atenuados vs SDFM (consistente com measurement error do single price). Puzzles: choque de preço "exógeno" tem efeito ~zero em produção de petróleo e efeito POSITIVO significativo em shipping global → não é choque de oferta; motiva Kilian.
- **§7.2.2/7.5.1 (Kilian 2009):** identificação por timing — eq. (72): H triangular no bloco 3×3 com diagonal 1 (unit effect): oil production não responde a nada contemporaneamente (eps^OS = inovação de produção); global activity responde a OS e GD; oil price responde a OS, GD, OD. **Problema prático central: a inovação de oil production quase não é gerada pelo espaço das inovações dos 8 fatores (Table 6: fatores explicam só 0.06 da variância h=1 de oil production)** → "a identificação pede ao SDFM para identificar um choque a partir das inovações dos fatores macro que discutivelmente não está no espaço dessas inovações; no caso extremo, a inovação estimada do common component será apenas ruído" → **solução: hybrid FAVAR-SDFM — oil production vira fator OBSERVADO (eq. 73), demanda global e oil-specific demand continuam identificados das inovações latentes**. [Lição direta para o projeto: se a variável de política tiver commonality baixa, tratar como observed factor / FAVAR em vez de forçar o SDFM puro. Checar R² do common component de yield_6m.]
- **§7.5.2 (Kilian ID, resultados):** oil supply shock idêntico nos 3 modelos (corr 0.88-0.95) e irrelevante para os macro vars; global demand e oil-specific demand: FAVAR/SVAR **atenuados** vs SDFM porque a variável observada mede o fator com erro (proxy imperfeito); SDFM atribui 44% do FEV(6q) do preço do óleo à demanda global vs 22% no FAVAR. Ver 3.21.
- **§8.2 (assessment):** 8 fatores → R² médio 51% nas 207 séries (GDP 81%, employment 93%, PCE 64%, term spread 72%, S&P500 73%); nonparametric PC como default; SDFM separa identificação do choque da estimação do SIRF por variável.

## 7. Contributions

- Unificação SVAR/FAVAR/SDFM: mesmos esquemas de identificação, diferindo só em fatores observados vs latentes; viabilizada pelo par unit effect normalization (SVAR) + named factor normalization (DFM); formalização das eqs. (58)-(61) e da regra "A(L) → Phi(L)".
- Argumento de que DFMs mitigam o invertibility problem (measurement error, omitted variables, news) via N grande; evidência de canonical correlations de que VARs pequenos não substituem o DFM.
- Tese do weak identification como risco sistemático dos esquemas de identificação críveis modernos, com o mapeamento IV explícito para cada esquema (long-run: eq. 39; het: eq. 46; external instruments: eq. 54).
- Template completo de aplicação (oil): named factor com múltiplos indicadores (eq. 60), hybrid FAVAR-SDFM quando o choque não está no espaço dos fatores (eq. 73).

## 8. Replication feasibility

Nota de rodapé ☆ da primeira página: "Replication files and the Supplement are available on Watson's Website, which also includes links to a suite of software for estimation and inference in DFMs and structural DFMs built around the methods described in this chapter." (www.princeton.edu/~mwatson). Dados públicos (FRED/FRED-MD; Kilian 2009 global activity index). Sample estrutural 1985Q1-2014Q4; bootstrap paramétrico descrito passo a passo (§5.1.3). Alta viabilidade de replicação; o Data Appendix lista a transformação de cada série.

---

## Referências-chave para o projeto (com dados bibliográficos completos do capítulo)

**Heteroskedasticity ID:** Rigobon (2003), "Identification through heteroskedasticity", *REStat* 85, 777-792; Rigobon-Sack (2003), "Measuring the reaction of monetary policy to the stock market", *QJE* 118, 639-669; Rigobon-Sack (2004), "The impact of monetary policy on asset prices", *JME* 51, 1553-1575; Wright (2012), "What does monetary policy do to long-term interest rates at the zero lower bound?", *Econ. J.* 122, F447-F466; Sentana-Fiorentini (2001), *J. Econometrics* 102, 143-164; Lanne-Lütkepohl-Maciejowska (2010), *JEDC* 34, 121-131; Lütkepohl-Netšunajev (2015), SFB 649 DP 2015-015.

**Weak-ID robust inference:** Staiger-Stock (1997), *Econometrica* 65, 557-586; Stock-Wright (2000), *Econometrica* 68, 1055-1096; **Magnusson-Mavroeidis (2014), "Identification using stability restrictions", *Econometrica* 82, 1799-1851**; Nakamura-Steinsson (2015), "High Frequency Identification of Monetary Non-Neutrality", ms. Columbia; **Montiel Olea-Stock-Watson (2016), "Inference in structural VARs with external instruments", ms. Harvard**.

**External instruments:** Stock (2008), NBER Summer Institute lecture 7; Mertens-Ravn (2013), *AER* 103, 1212-1247; Gertler-Karadi (2015), *AEJ:Macro* 7, 44-76.

**SDFM/FAVAR:** Bernanke-Boivin-Eliasz (2005), *QJE* 120, 387-422; Stock-Watson (2005), ms. Harvard; Stock-Watson (2012a), *BPEA*; Forni-Gambetti (2010), *JME* 57, 203-216; Forni-Giannone-Lippi-Reichlin (2009), *Econ. Theory* 25, 1319-1347 (invertibility resolvida em DFMs); Bai-Ng (2013), *J. Econometrics* 176, 18-29 (normalizações PC1/PC2/PC3); Bai-Wang (2014); Amengual-Watson (2007), *JBES* 25, 91-96; Bates-Plagborg-Møller-Stock-Watson (2013), *J. Econometrics* 177, 289-304.

**Bootstrap em DFM:** Kilian (1998), *REStat* 80, 218-230; Yamamoto (2012); Gonçalves-Perron (2015), *J. Econometrics* 182, 156-173.
