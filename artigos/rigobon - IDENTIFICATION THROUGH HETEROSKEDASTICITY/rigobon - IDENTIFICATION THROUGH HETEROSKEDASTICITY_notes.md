# Rigobon (2003) — "Identification Through Heteroskedasticity" — Notas de extração

**Referência:** Rigobon, R. (2003). "Identification Through Heteroskedasticity". *The Review of Economics and Statistics*, 85(4), 777–792. Recebido 2001-01-11; aceito 2002-09-20. Autor: Sloan School (MIT) e NBER.

---

## 1. Research question

Como resolver o problema de identificação em modelos de equações simultâneas quando nenhuma das restrições tradicionais (exclusion restrictions, sign restrictions, long-run constraints, covariance/variance restrictions) pode ser justificada? A proposta: usar a **heteroskedasticity dos structural shocks** — a simples existência de regimes de variância com **relative variances** distintas — como fonte de identificação. Aplicação motivadora: a relação contemporânea entre retornos de sovereign bonds de Argentina, Brasil e México, onde simultaneidade bidirecional e common shocks tornam indefensáveis todas as restrições padrão.

A intuição remonta a Philip Wright (1928): um aumento na variância dos shocks de uma equação reduz o viés de simultaneidade no OLS da outra; no limite (variância → ∞) o OLS é consistente. Rigobon generaliza para shifts **finitos** de variância com forma de heteroskedasticity **desconhecida**: se os structural shocks são não correlacionados, o sistema é identificado apenas sabendo que houve mudança na **variância relativa** dos shocks. Interpretação IV: o regime de alta variância de um shock é um "**probabilistic instrument**" — não garante que a curva correspondente se desloca (como um IV padrão), mas torna esses deslocamentos mais prováveis, "inclinando a elipse" dos resíduos na direção da outra equação.

## 2. Audience

Econometristas e macro/finance economists aplicados: usuários de SVARs, event studies e modelos de equações simultâneas; literatura de contágio financeiro internacional; literatura de identificação (Fisher 1976; Haavelmo 1947; Koopmans-Rubin-Leipnik 1950). Publicado na *REStat*. Companion papers de aplicação: Rigobon & Sack (2003, *QJE*; 2002, NBER WP 8794) para política monetária, Forbes & Rigobon (2002, *JF*) para contágio. É o paper metodológico canônico do paradigma "identification through heteroskedasticity", posteriormente estendido por Lanne-Lütkepohl (2008, *JMCB* — monetary policy shocks via changes in volatility) e a linha Markov-switching SVAR (Netšunajev, Lütkepohl).

## 3. Method — identification strategy

**Paradigma:** identificação por **momentos de segunda ordem** (covariance-based identification). Nenhum instrumento externo, nenhuma exclusion restriction. As hipóteses identificadoras são: (i) **zero correlation** entre os structural shocks (relaxável introduzindo common unobservable shocks); (ii) **parameter stability** — os coeficientes contemporâneos são estáveis através dos regimes de variância; (iii) existência de pelo menos **dois regimes** com variâncias relativas distintas. O autor enfatiza que (i) e (ii) já são impostas implicitamente na maioria das aplicações macro com VARs e identificação recursiva.

### Setup bivariado (seção II)

Modelo de demanda e oferta:

```
p_t = beta * q_t + eps_t,      (1)   [demanda]
q_t = alpha * p_t + eta_t,     (2)   [oferta]
```

com sigma_{eps,eta} = 0 (por ora). Parâmetros de interesse: alpha, beta, sigma_eps^2, sigma_eta^2. A reduced-form covariance matrix é

```
Omega_hat = 1/(1 - alpha*beta)^2 * [ beta^2*sigma_eta^2 + sigma_eps^2 ,  beta*sigma_eta^2 + alpha*sigma_eps^2 ;
                                     .                                ,  sigma_eta^2 + alpha^2*sigma_eps^2   ]
```

→ 3 momentos, 4 incógnitas: subidentificado. Soluções tradicionais listadas: (i) exclusion (alpha = 0 ou beta = 0); (ii) sign restrictions (identificação parcial, região admissível); (iii) long-run constraints (Blanchard-Quah 1989; Shapiro-Watson 1988); (iv) variance restrictions — razão sigma_eta^2/sigma_eps^2 fixada em constante ou infinito (esta última é a hipótese subjacente à maioria dos **event studies**; cf. Rigobon & Sack 2002 sobre near-identification em política monetária).

### A. Identification under two regimes (Proposition 1)

Com dois regimes s ∈ {1,2} de variâncias (parâmetros estáveis), cada regime dá uma matriz de covariância com a mesma estrutura (equação (3)):

```
Omega_hat_s = 1/(1 - alpha*beta)^2 * [ beta^2*sigma_{eta,s}^2 + sigma_{eps,s}^2 ,  beta*sigma_{eta,s}^2 + alpha*sigma_{eps,s}^2 ;
                                       .                                        ,  sigma_{eta,s}^2 + alpha^2*sigma_{eps,s}^2   ],  s in {1,2}
```

6 equações (duas matrizes de covariância), 6 incógnitas (alpha, beta, sigma_{eta,1}^2, sigma_{eps,1}^2, sigma_{eta,2}^2, sigma_{eps,2}^2). Resolvendo para as variâncias, alpha e beta satisfazem o sistema não linear (equação (4)):

```
beta = (omega_{12,s} - alpha*omega_{11,s}) / (omega_{22,s} - alpha*omega_{12,s}),   s in {1,2},
```

e alpha resolve a equação quadrática (equação (5)):

```
[omega_{11,1}*omega_{12,2} - omega_{12,1}*omega_{11,2}] * alpha^2
  - [omega_{11,1}*omega_{22,2} - omega_{22,1}*omega_{11,2}] * alpha
  + [omega_{12,1}*omega_{22,2} - omega_{22,1}*omega_{12,2}] = 0.
```

As duas raízes são as duas **row permutations** do modelo estrutural: se (alpha, beta) é solução, (1/beta, 1/alpha) é a outra. Ou seja, o **sistema completo** (ambas as equações, ambas as variâncias por regime) é identificado **up to row permutations** — não apenas uma coluna.

**Proposition 1 (enunciado exato).** "Let p_t and q_t be described by equations (1) and (2), where the parameters (alpha and beta) determining the law of motion are stable and where the disturbances have finite variance, are not correlated, and exhibit heteroskedasticity that can be described with two regimes. Then, if the covariance matrices satisfy

```
det | Omega_hat_2 - (omega_{11,2}/omega_{11,1}) * Omega_hat_1 | != 0,      (6)
```

the structural form is just identified: alpha and beta are consistently estimated from the two estimable covariance matrices." (Proof: Appendix.)

A condição (6) é equivalente a (equação (7)):

```
omega_{11,1}*omega_{12,2} - omega_{11,2}*omega_{12,1} != 0.      (7)
```

**Leitura da condição:** (6)/(7) é a **rank condition** (o order condition — nº de equações ≥ nº de incógnitas — já está satisfeito com S = 2). Ela **falha se e somente se as duas covariance matrices são proporcionais** (Omega_2 = a*Omega_1 para escalar a), i.e., se as variâncias relativas não mudam entre regimes ("if both variances shift by the same amount, the two ellipses are similar, and the system is not identified"). No Appendix: com Omega_2 = a*Omega_1 a quadrática (5) tem **infinitas soluções** (continuum). A prova mostra ainda que as raízes de (5) são sempre **reais** (via positive definiteness das matrizes de covariância), então proporcionalidade é o único caso patológico. Em termos estruturais, a consistência de alpha_hat requer (Appendix 1.a):

```
-sigma_{eta,1}^2*sigma_{eps,2}^2 + sigma_{eps,1}^2*sigma_{eta,2}^2 != 0
   <=>   sigma_{eta,1}^2/sigma_{eps,1}^2 != sigma_{eta,2}^2/sigma_{eps,2}^2
```

("the generalization of Philip Wright's (1928) intuition"). Não é necessário saber **qual** shock ficou mais volátil, nem que apenas um tenha mudado: basta que a razão mude.

**Teste da rank condition (nota prática do Appendix):** em vez de computar det[Omega_2 − (omega_{11,2}/omega_{11,1})Omega_1] = 0, testar diretamente

```
omega_{11,1}*omega_{12,2} - omega_{11,2}*omega_{12,1} =? 0,
```

porque "the small-sample properties of this statistic are better than those of the determinant, and in the empirical section this is the one that is used to check the rank condition". A rank condition é **testável** — logo o grau de misspecification dos regimes é detectável na aplicação.

### C. Identification under more than two regimes (GMM / overidentification)

Com S regimes (equação (8), mesma estrutura de (3) para s ∈ {1,...,S}): **3S equações e 2S + 2 incógnitas** (S pares de variâncias estruturais + alpha + beta). Order condition satisfeita para todo S ≥ 2. A rank condition tem a mesma forma (6)/(7) **para cada par de regimes**; o sistema é **overidentified** se há pelo menos 3 regimes que satisfazem a rank condition "for all combinations" (pairwise). Contagem de graus: cada novo regime que satisfaz a rank condition contra todos os anteriores adiciona 3 equações e só 2 incógnitas ("each new heteroskedastic regime is a valid instrument if and only if it satisfies the rank condition with respect to all the previous regimes"); caso contrário não adiciona restrições sobre os coeficientes estruturais. Com S > 2 as **underlying assumptions — parameter stability de alpha e beta — tornam-se testáveis** via overidentifying restrictions. "The estimation has a minimum-distance interpretation where each heteroskedastic regime is equivalent to one instrument." Nota 7: as equações adicionais também admitem leitura de factor regression (variâncias estruturais como fatores não observáveis, omega_{ij,s} como observáveis), mas como os omega_{ij,s} não são independentes entre si, "proper corrections have to be considered in the estimation procedure. In this paper, I use the GMM interpretation."

### Relação com a literatura (seção II.B) — vantagens declaradas sobre ARCH/GARCH-ID

Diferenças frente a Sentana (1992), Sentana-Fiorentini (2001), Klein-Vella (2000a,b) (a Proposition 1 é caso especial da Proposition 3 de Sentana-Fiorentini): (1) requer apenas saber que houve shift nas variâncias relativas — o regime vem de **eventos econômicos** (crises, policy shifts) ou características cross-section, não de um modelo paramétrico da heteroskedasticity; (2) com S > 2 as hipóteses (parameter stability) são **testáveis** — os métodos de conditional heteroskedasticity não oferecem esse teste; (3) **robustez a misspecification**: aqui, regimes mal especificados ainda dão coeficientes consistentes; na modelagem paramétrica (ARCH/GARCH), misspecification vicia também os coeficientes contemporâneos. Se os dados têm conditional heteroskedasticity e se aplica o procedimento de regimes, os coeficientes continuam consistentes; (4) com S > 2 é possível ter **mais latent factors heteroskedásticos que variáveis endógenas** e ainda identificar — os métodos condicionais exigem nº de shocks heteroskedásticos ≤ nº de endógenas. Limitação comum a todos: o sistema deve ser **linear** (coeficientes estáveis a mudanças de volatilidade).

### Proposition 2 — sistema multivariado com common shocks (seção III)

Motivação: no caso bivariado com um common unobservable heteroskedastic shock, cada regime adiciona 3 equações **e** 3 incógnitas — heteroskedasticity sozinha não basta; common shocks equivalem a relaxar a zero correlation dos structural shocks (nota 8). Setup: N endógenas, K common unobservable shocks, S regimes; forma estrutural (equação (9)):

```
A_{NxN} x_t = Gamma_{NxK} z_t + eps_t,
```

com todos os shocks mutuamente não correlacionados em todos os leads e lags (equações (10)): E[z_i z_j] = 0 (i≠j), E[eps_i eps_j] = 0 (i≠j), E[z_i eps_j] = 0. Normalizações: diag(A) = 1 (equação (11)); primeira linha de Gamma = 1 (unit impact na primeira equação, equação (12)). Variâncias por estado: sigma_{z,k,s} (common) e sigma_{eps,n,s} (estruturais).

**Proposition 2 (enunciado exato).** "A multivariate system of N equations, with K unobservable common shocks, described by equations (9), (10), (11), and (12), is identified if and only if, for N > 1,

(i) the number of states (S) satisfies

```
S >= 2*(N + K)*(N - 1) / (N^2 - N - 2K),      (13)
```

(ii) there is a minimum number of endogenous variables (or maximum number of common shocks) that satisfies

```
N^2 - N - 2K > 0,      (14)
```

and (iii) the covariance matrices constitute a system of equations that is linearly independent." (Proof: Appendix.)

**Atenção (Appendix, prova 2):** a proposição enuncia uma condição **necessária** ("order condition"), não suficiente — a suficiência exige (iii), a independência linear efetiva. Contagem: cada regime dá N(N+1)/2 equações; incógnitas: A tem N(N−1), Gamma tem K(N−1), mais KS variâncias comuns e NS variâncias estruturais; identificação requer S·N(N+1)/2 ≥ N(N−1) + K(N−1) + SK + SN, que rearranja para (13). A equação (14) é a "**catch-up constraint**": condição para que um regime adicional traga mais equações que incógnitas. Com N = 2, K = 1, (14) falha — nenhuma informação adicional vem da heteroskedasticity. Resolvendo (14) para K: **K < N(N−1)/2** — exatamente o nº de correlações contemporâneas possíveis entre os structural shocks (i.e., não se pode deixar todas as correlações livres). Implicações centrais: (a) **sem common shocks (K = 0), S = 2 regimes bastam para qualquer N**; (b) com K > 0 e N finito, **S > 2 sempre**.

**Estimação (equação (15)):** GMM com moment conditions

```
A * Omega_s * A' = Gamma * Omega_{z,s} * Gamma' + Omega_{eps,s},
```

onde Omega_s é estimável dos dados no regime s, e Omega_{z,s}, Omega_{eps,s} são **diagonais** (pelas hipóteses (10)). Parâmetros de interesse: A e Gamma.

### Propositions 3–4 — consistência sob misspecification da heteroskedasticity (seção IV)

Intuição geral: matrizes de covariância mal especificadas são **combinações lineares (convexas) das verdadeiras**; o sistema mal especificado é uma transformação linear do problema original. Se a transformação não reduz o rank, a mesma solução é obtida. A misspecification **reduz o poder** dos testes ao atenuar as diferenças entre regimes; no limite em que o rank cai, os estimadores são inconsistentes ("there is a continuum of them"). Análise no caso bivariado sem common shocks, sem perda de generalidade.

**(A) Misspecification of the regime windows (nº de regimes correto, timing errado).** As matrizes computadas são

```
Omega_{r1} = lambda_{r1}*Omega_1 + (1 - lambda_{r1})*Omega_2,
Omega_{r2} = (1 - lambda_{r2})*Omega_1 + lambda_{r2}*Omega_2,
```

com lambda_{r1}, lambda_{r2} ∈ pesos de acerto das janelas (= 1 quando as janelas coincidem com os regimes verdadeiros).

**Proposition 3 (enunciado exato).** "Assume the original system satisfies the rank condition (6). If the misspecified heteroskedasticity also satisfies (6), then the model is identified and its estimators are consistent." (Proof: Appendix.)

Appendix (prova 3): as variâncias implícitas são sigma_{eta,r1}^2 = lambda_{r1}*sigma_{eta,1}^2 + (1−lambda_{r1})*sigma_{eta,2}^2 etc. (A1)–(A2); Omega_{r1}, Omega_{r2} satisfazem (6) sse sigma_{eta,r1}^2*sigma_{eps,r2}^2 ≠ sigma_{eta,r2}^2*sigma_{eps,r1}^2, e a rank condition falha **se e somente se lambda_{r1} = 1 − lambda_{r2}** — janelas tão ruins que as duas matrizes computadas são idênticas (mesmos pesos sobre os regimes verdadeiros). Se o rank vale, alpha_hat resolve (equação (A3))

```
(Phi*beta/(1 - alpha*beta)^3) * [alpha_hat^2 - (1/beta + alpha)*alpha_hat + alpha/beta] = 0,
Phi = (sigma_{eta,1}^2*sigma_{eps,2}^2 - sigma_{eta,2}^2*sigma_{eps,1}^2) * (1 - lambda_{r1} - lambda_{r2}),
```

**exatamente a mesma quadrática** do modelo bem especificado (raízes alpha e 1/beta) → consistência. Corolário prático: "the estimated coefficients should be consistent for **small perturbations of the regime definitions**", e como a rank condition é testável, "the degree of misspecification can be detected in the applications".

**(B) Underspecified number of regimes (S\* regimes verdadeiros, 2 usados).** Parametrização: sigma_{eta,s}^2 = (1 + delta_{eta,s})*sigma_{eta,0}^2, sigma_{eps,s}^2 = (1 + delta_{eps,s})*sigma_{eps,0}^2 (mudanças relativas ao regime s = 0). Com a primeira janela cobrindo os primeiros s_hat < S\* regimes e a segunda os S\* − s_hat restantes, os deltas efetivos são médias dentro de cada janela (equações (16)–(17)):

```
delta_{eta,r1} = (1/s_hat) * sum_{s<s_hat} delta_{eta,s};   delta_{eta,r2} = (1/(S*-s_hat)) * sum_{s>s_hat} delta_{eta,s};
delta_{eps,r1}, delta_{eps,r2} análogos.
```

**Proposition 4 (enunciado exato).** "Assume the true heteroskedasticity is described by S\* regimes and that those covariance matrices satisfy the rank condition (6). Assume that only two regimes have been used in the estimation. Then, if the following conditions are satisfied, the system is identified and its estimates are consistent: 1. The misspecified covariance matrices have to exhibit heteroskedasticity: delta_{r1} != delta_{r2}. 2. The misspecified covariance matrices satisfy the rank condition (6)." (Proof: Appendix.)

Appendix (prova 4): condição de ordem (A4): delta_{eta,r1} ≠ delta_{eta,r2} **ou** delta_{eps,r1} ≠ delta_{eps,r2}; alpha_hat resolve (A5), mesma quadrática, com

```
Phi = (1 + delta_{eps,r1})*(1 + delta_{eta,r2}) - (1 + delta_{eps,r2})*(1 + delta_{eta,r1}),
```

e Phi ≠ 0 exige (A4) mais a rank condition (A6):

```
delta_{eta,r1}/delta_{eta,r2} != delta_{eps,r1}/delta_{eps,r2}     (A6)
```

— a mudança de variâncias entre os regimes agregados não pode ser proporcional. "Even though the assumed form of the heteroskedasticity implies a smaller number of regimes than those exhibited in the data, the system is identified and its estimates are consistent if and only if the order and rank conditions are satisfied by the misspecified matrices."

**Caso oposto — overspecified regimes (aviso crítico):** "if the number of true regimes is **smaller** than the number of regimes used in the estimation, then the system of equations does not satisfy the rank condition ... the estimates are **inconsistent, and the confidence intervals are infinitely large**." As duas formas analisadas não são exaustivas; a consistência deve ser explorada caso a caso conforme a aplicação.

## 4. Data — aplicação empírica (seção V)

- **Fonte:** J.P. Morgan **EMBI (Emerging Markets Bond Index Plus)** — stripped yields diários de dívida externa soberana (principalmente Brady bonds), computados relativos a US bonds de duration similar; índices ponderados por risco, market cap, liquidez e colateral.
- **Unidade / países:** Argentina, Brasil, México. Yields em basis points; Brasil excluído de 1994 (menos da metade das observações).
- **Período / frequência:** janeiro/1994 a dezembro/2001, diário.
- **Variável de controle:** retorno do US 10-year government bond (contemporâneo e defasado) no VAR de primeira etapa.
- **Motivação de identificação:** propagação bidirecional (se choques mexicanos afetam a Argentina, o inverso também vale) + bonds negociados no mesmo mercado → common shocks a market participants → preços determinados simultaneamente com common unobservable shocks. Nenhuma das quatro restrições padrão é defensável (nem exclusão, nem sinal, nem long-run, nem variance ratio conhecida). Correlações anuais simples (Tabela 1): 78–99% em 1994–1999, colapsando depois (Arg–Mex: 12.2% em 2000, −37.0% em 2001) — motivo da literatura de contágio; nota 11: correlações são viesadas sob heteroskedasticity e os ajustes padrão (Ronn 1998; Forbes-Rigobon 2002) não se aplicam sob simultaneidade.
- **Regimes (Tabela 2, "Tranquil and crisis windows")** — definidos por **calendário de eventos** (crises internacionais como "natural framework", associadas a aumentos grandes e persistentes de volatilidade): Mexican crisis 1994-12-19 → 1995-03-01; Asian crises 1997-06-01 → 1998-01-31; Russian crisis 1998-08-01 → 1998-10-31; Brazilian devaluation 1999-01-13 → 1999-02-28; Mexico's upgrade (investment grade) 2000-03-01 → 2000-05-31 (tratado como "crise" embora boa notícia — o que importa é o shift de volatilidade: variâncias de Bra/Mex caem a ~1/5); Argentinean crisis 2000-10-01 → 2001-12-31. Seis janelas tranquilas complementares (1994-05-01→1994-12-18; 1995-03-02→1997-05-31; 1998-01-01→1998-06-30; 1998-11-01→1999-01-12; 1999-03-01→2000-02-28; 2000-06-01→2000-09-30). Magnitudes (Tabela 3, razão crise/tranquilo precedente): Mexican crisis V(Mex) ×34.8; Russian crisis todas as variâncias ×15–35; Argentinean crisis V(Arg) ×1937.6, C(Arg,Bra) ×585.8 mas V(Mex) ×1.4 — forte evidência de shifts **não proporcionais** (rank condition).
- Nota 10: os dados exibem tanto conditional quanto unconditional heteroskedasticity (Edwards 1998; Edwards-Susmel 2000); os argumentos são desenvolvidos sob unconditional, mas estendem-se ao caso condicional.

## 5. Statistical/numerical methods

**Modelo empírico (equação (18)):**

```
A * [Arg_t; Bra_t; Mex_t] = c + phi(L)*[Arg_t; Bra_t; Mex_t] + phi*US_t + Phi(L)*US_t + [xi_{Arg,t}; xi_{Bra,t}; xi_{Mex,t}] + Gamma*z_t,
```

shocks contemporânea e serialmente não correlacionados, com covariâncias Omega_s^xi e Omega_s^z no regime s. Reduced-form residuals nu_t satisfazem A*nu_t = xi_t + Gamma*z_t (equação (19)) — mesma relação contemporânea dos retornos, mapeando no framework (9)–(12).

**Procedimento de estimação em três passos:**
1. **VAR de primeira etapa** no log dos yields (com US 10y contemporâneo e defasado) para remover serial correlation e variação de juros internacionais → resíduos nu_t.
2. Definidas as janelas, computar a **covariance matrix dos resíduos em cada subsample/regime**.
3. **GMM** sobre as moment conditions (15) usando essas matrizes → coeficientes contemporâneos A e Gamma.

**Inferência:** standard errors por **bootstrap dos resíduos dentro de cada regime** (distribuição de covariance matrices), **500 replications**. Testes de estabilidade de parâmetros: **F-tests calculados numericamente** no bootstrap, mantendo os **common draws** entre subsamples que compartilham observações (e.g., MAR compartilha amostra com MA).

**Contagem de identificação da aplicação:** N = 3, K = 1 → catch-up (14): 9 − 3 − 2 = 4 > 0 OK; (13): S ≥ 2·(4·2)/4 = **4 regimes no mínimo**. Sistema just identified com 2 crises + 2 períodos tranquilos; crises adicionais → overidentified. Subsamples encaixados: **MA** (Mexican + Asian, just identified, grupo de controle), **MAR** (+ Russian), **MARB** (+ Brazilian devaluation), **MARBU** (+ upgrade), **MARBUA** (amostra completa). Hipótese mantida: coeficientes constantes entre subsamples; overidentifying restrictions testam isso.

**Estatísticas-chave do paradigma:** rank-condition statistic omega_{11,1}·omega_{12,2} − omega_{11,2}·omega_{12,1} = 0 (preferida ao determinante por small-sample properties); overidentification/stability F-tests via bootstrap; a estimação por dois regimes no caso bivariado tem solução fechada (quadrática (5)); com S > 2 ou common shocks, GMM/minimum distance sobre (15).

## 6. Findings

**Tabela 4 (janelas originais; ponto / bootstrap SD / t):** destaques —
- Equação da Argentina: coeficiente do **México sempre significativo** (MA: 0.4071, SD 0.0895, t 4.55; MAR: 0.4105, t 6.35; MARBUA: 0.3117, t 4.10); coeficiente do Brasil nunca significativo, mas sobe de ~0 para ~30% nas amostras que incluem a desvalorização brasileira (MA: 0.0513, t 0.27 → MARBUA: 0.3609, t 1.90). A queda do coeficiente mexicano no fim da amostra é consistente com o "descolamento" pós-upgrade.
- Equação do Brasil: Argentina e México com efeitos parecidos (Arg: 17%–39%; Mex: 15%–24%), poucos significativos (só em MAR e MARBUA).
- Equação do México: Argentina e Brasil com efeito pequeno; um único coeficiente significativo (MAR: Arg 0.3623, t 3.56).
- **Common shock** (normalização: coeficiente da Argentina = 1): coeficientes Bra e Mex significativos em quase todos os subsamples (MA: Bra 1.0273 t 3.00, Mex 1.8795 t 2.88); sinais negativos em parte dos coeficientes documentam "**flight to quality**" (nota 12) — choques comuns negativos à Argentina associados a choques positivos em Bra/Mex.

**Tabela 5 — F-tests de estabilidade (F / p-value), specification original:** MA–MAR 1.42 / 18.59% (não rejeita); MA–MARB 2.82 / 0.45%; MA–MARBU 2.49 / 1.18%; MA–MARBUA **8.17 / 0.00%** (rejeição forte). Interpretação: estabilidade **não** é rejeitada na parte inicial da amostra (inclusão da crise russa), mas **é rejeitada quando a parte final entra** — consistente com a mudança estrutural narrada pelo mercado (inflation targeting no Brasil/México após 1999-Q1; upgrade do México a investment grade em março/2000). O fato de rejeitar no fim e não no começo indica que o teste tem poder.

**Robustez 1 — short windows (Tabelas 6–7):** janelas de crise encurtadas (e.g., Mexican crisis até 1995-01-31; Asian = só colapso de Hong Kong 1997-10-01→1997-11-01; Russian 1998-08-01→1998-08-31 excluindo LTCM e ataque ao Brasil; Argentinean 2001-04-01→2001-05-15; resto dos dados **descartado**). Point estimates muito próximos — impossível rejeitar igualdade com a Tabela 4 sample a sample (maior F = 0.32, MARBUA vs MARBUA); precisão menor; F-tests de estabilidade com muito menos poder (coluna 2 da Tabela 5: só MA–MARBUA rejeita, 33.04 / 0.00%; demais F ≤ 1.26). **Confirmação empírica da Proposition 3**: pequenas perturbações nas janelas → estimativas consistentes, ao custo de poder.

**Robustez 2 — no common shock (Tabela 8):** modelo re-estimado com K = 0, mesmas janelas. Coeficientes maiores e "mais precisos", mas o modelo é **rejeitado**: igualdade com a Tabela 4 rejeitada em 3 de 5 subsamples (MA: F 3.64; MAR: 2.37; MARBUA: 2.28) e as overidentifying restrictions rejeitam sempre (coluna "No Common Shock" da Tabela 5: MA–MAR 64.23, MA–MARB 17.89, MA–MARBU 8.14, MA–MARBUA 368.64; todos p = 0.00%). Lição: **omitir o common shock heteroskedástico força os coeficientes estruturais a "explicar" as rotações dos resíduos** → rejeição espúria de estabilidade. A especificação do K importa muito.

**Robustez 3 (não tabulada):** excluir US rate do VAR (common shock fica mais preciso e positivo; coeficientes contemporâneos quase iguais); períodos tranquilos agregados vs separados (estimativas quase idênticas, menos combinações para overid tests); primeira etapa em levels/differences/logs/returns (conclusões similares; em levels quase tudo significativo).

## 7. Contributions

1. **Framework geral de identificação por heteroskedasticity** com regimes discretos e forma da heteroskedasticity desconhecida — generaliza P. Wright (1928) de shifts infinitos para finitos; sistema completo identificado up to row permutations (Proposition 1), com rank condition explícita e **testável** (6)/(7).
2. **Order/rank conditions para o caso multivariado com common unobservable shocks** (Proposition 2): fórmula do nº mínimo de regimes (13), catch-up constraint (14), K < N(N−1)/2; K = 0 → 2 regimes bastam ∀N.
3. **Resultados de robustez a misspecification** (Propositions 3–4): janelas erradas ou nº de regimes subestimado preservam consistência desde que as matrizes computadas mantenham heteroskedasticity e rank; a única perda é poder. Overspecificar regimes (mais regimes assumidos que verdadeiros) → inconsistência e CIs infinitos.
4. **Interpretações operacionais:** probabilistic IV (cada regime válido = um instrumento; minimum-distance/GMM), leitura de factor regression, ponte com event studies (caso limite de variance ratio → ∞).
5. **Aplicação a contágio soberano latino-americano** onde nenhuma identificação padrão se sustenta: linkages fortes entre Arg/Bra/Mex mesmo controlando por common shocks; estabilidade paramétrica rejeitada só após 1999 (inflation targeting + upgrade do México); demonstração empírica de que omitir common shocks distorce tudo.
6. Vantagens documentadas sobre a linha ARCH/GARCH-ID: regimes por eventos econômicos, testabilidade das hipóteses, robustez a misspecification, possibilidade de mais fatores heteroskedásticos que endógenas (com S > 2).

## 8. Replication feasibility

**Alta.** Dados: EMBI stripped yields (J.P. Morgan) diários 1994–2001 para Arg/Bra/Mex + US 10y — proprietários mas amplamente disponíveis em provedores (Bloomberg/Datastream); janelas de regime totalmente especificadas nas Tabelas 2 e 6 (datas exatas). Algoritmo completamente descrito: (1) VAR em log yields com US 10y; (2) covariance matrices dos resíduos por janela; (3) GMM sobre A·Omega_s·A' = Gamma·Omega_{z,s}·Gamma' + Omega_{eps,s} com normalizações diag(A) = 1 e Gamma(1,·) = 1; (4) bootstrap por regime, 500 reps, F-tests numéricos com common draws preservados. Casos de teste embutidos: caso bivariado tem solução fechada (quadrática (5)) para validação; contagem de identificação verificável (N=3, K=1 → S ≥ 4); rank-condition statistic explícito. Pontos não totalmente especificados: nº de lags do VAR de primeira etapa; detalhes do weighting matrix do GMM; tratamento exato de dias faltantes/feriados. Sem código ou apêndice de dados publicado (padrão da época).

---

## Apêndice de leitura — mapa para uso no projeto (het-ID como identificação primária)

*(Notas de aplicação, não conteúdo do paper.)*

- O esquema Copom-day vs non-Copom-day do projeto é o caso **S = 2, calendário-definido** — exatamente o desenho de Rigobon-Sack (2003, QJE), citado aqui como aplicação de regime switches. Sob S = 2 e K = 0 (sem common shock heteroskedástico no par de regimes), Proposition 1 diz que o **sistema diário completo** é identificado (up to permutations), não só a coluna de política — mas a hipótese de zero correlation entre todos os structural shocks diários é forte; o projeto atual usa só b_1 (leading eigenpair), o que corresponde a explorar uma direção da diferença de covariância.
- **Rank condition ↔ near-proportionality:** Sigma_C − Sigma_NC quase proporcional a Sigma_NC ⇒ identificação fraca (continuum no limite). O statistic recomendado é o de (7) (produto cruzado normalizado), não o determinante. O projeto já computa o LR de proporcionalidade (Rigobon Prop. 1) em `het_rank_test*.csv`.
- **Proposition 3 protege o calendário Copom:** erros moderados nas janelas Wed→Thu (e.g., decisões fora de calendário, vazamentos) não viciam o estimador desde que as matrizes computadas mantenham o rank — só custam poder. O caso letal é lambda_{r1} = 1 − lambda_{r2} (janelas informativamente idênticas).
- **Proposition 4 protege contra sub-regimes** (COVID, crises fiscais dentro da amostra): agregar S\* > 2 regimes verdadeiros em 2 janelas preserva consistência sse os deltas médios não forem proporcionais entre janelas (A6). Mas **sobre-especificar** regimes (dividir onde não há shift real) gera inconsistência e CIs infinitos — cautela ao multiplicar regimes (e.g., separar Copom "hawkish"/"dovish" sem shift real de variância).
- **Proposition 2 disciplina o K:** com common shocks heteroskedásticos (fatores globais: VIX/SP500/UST), S = 2 **não basta** — para N = 4 endógenas (DI_3m, DI_2y, IBOV, BRL) e K = 1, (13) exige S ≥ 2·5·3/(16−4−2) = 3 regimes; K = 2 → S ≥ 2·6·3/8 = 4.5 → 5 regimes. Alternativa prática do projeto: purgar os fatores globais antes (primeira etapa), como Rigobon purga o US 10y via VAR.
- A aplicação empírica valida a prática de **regimes por calendário/eventos** (vs estimados dos dados) e mostra o trade-off janelas curtas = mais pureza, menos poder.
