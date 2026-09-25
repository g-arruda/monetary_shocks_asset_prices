# Auditoria de fidelidade: Montiel Olea–Stock–Watson (2021) e Lenza–Primiceri (2022)

> **Data:** 2026-09-24. **Natureza:** auditoria metodológica e de código, somente leitura — nenhum
> arquivo do repositório foi alterado, nenhum script com escrita foi executado. As verificações
> rodadas em memória estão listadas na §1.3 com os números medidos.
> **Artigos:** `artigos/olea, stock e watson - Inference in Structural Vector Autoregressions
> identified withan external instrument/` (daqui em diante **MOSW.md**) e `artigos/Lenza - How to
> estimate a vector autoregression after March 2020/` (**LP.md**).
> **Pergunta do autor:** o trabalho deles foi implementado corretamente e fiel à teoria? A
> adaptação metodológica ao DFM faz sentido?

---

## 0. Veredito executivo

| # | Pergunta | Resposta |
|---|---|---|
| a | O port de MOSW é fiel ao artigo e ao MATLAB dos autores? | **Sim, demonstrado.** As saídas batem com os fixtures extraídos do código oficial: conjuntos AR (não cumulativos e cumulativos), coeficientes `ahat/bhat/chat`, bandas delta-method, códigos de caso e o bloco Γ do WHat da aplicação de impostos — a ~1e-11. As estatísticas publicadas do óleo (ξ₁ = 4,4; F = 9,4) se reproduzem. |
| b | A extensão `Load`/`Inner`/`d0` que adapta MOSW ao DFM é correta? | **Sim, demonstrado.** Reduz exatamente a MOSW quando `Load = Inner = I` (desvio 0), o ponto AR confere com `ident_ext_instr` a 1e-10 em runtime, e o gradiente novo confere com jacobiano numérico central a 3e-11. A álgebra de Fieller–AR se mantém porque o estimando continua razão de funções diferenciáveis de (A, Γ), lineares em Γ. |
| c | A adaptação ao DFM é teoricamente limpa? | **Parcialmente.** É a extensão natural e é internamente consistente, mas os conjuntos **condicionam** em fatores, cargas e escalas estimados — o erro de extração fatorial e de θ̂ não entra na covariância. MOSW não cobre regressores gerados; a cobertura de 90% já foi medida abaixo do nominal (78,1%–83,4% no Monte Carlo de `2026-08-12_auditoria_anderson_rubin_dfm.md`). A propriedade é declarada no código, não silenciosa, mas continua aberta. |
| d | O Lenza–Primiceri está fiel ao Apêndice B? | **Sim.** O caminho de `s_t` é idêntico ao `invweights` dos autores; (B2), (B4) e (B5) são implementados literalmente; a regra de partida é a de `bvarGLP_covid.m`; o piso `s̄ ≥ 1` é necessário para o máximo existir. O ramo bayesiano — corpo do artigo — não foi implementado, e o artigo nunca estima pelo Apêndice B: não há número de LP contra o qual comparar θ̂. |
| e | A adaptação do tratamento ao DFM faz sentido? | **Parcialmente, e está declarada.** A *commonality assumption* passa das n observáveis para as r=5 inovações fatoriais; o PCA, as cargas e `sy` **não** são reponderados; e θ̂ **não é consistente** (s̄₀ e s̄₁ governam um mês cada), de modo que condicionar os conjuntos AR em θ̂ não é uma aproximação assintoticamente desprezível. Os três itens estão registrados nas notas e no `CLAUDE.md`. |

**Classificação:** nenhum erro de implementação encontrado; nenhuma divergência não declarada de
nenhum dos dois artigos. As lacunas são as que o próprio repositório já nomeia: inferência fatorial
gerada (§2.5) e θ̂ incidental (§3.4).

---

## 1. Escopo, material e método

### 1.1 Fontes lidas (artigo)

| Artigo | Trechos usados |
|---|---|
| MOSW | eq. (2.1)–(2.12); Assumptions 1–2; (3.1)–(3.7); Fieller/AR (§4, eq. (4.1)–(4.3), Props. 1–2); diagnóstico (4.2); código oficial `codigos_externos/codigo_olea/` (`MSWfunction.m`, `CovAhat_Sigmahat_Gamma.m`, `Gmatrices.m`, `MARep.m`, `NW_hac_STATA.m`, `SVARIV.m`, `RForm_VAR.m`) |
| LP | eq. (1) e o display sem número da trajetória de `s_t` (`LP.md:53`); reescala `ỹ = y/s`, `X̃ = X/s` (`LP.md:57-63`); Apêndice B, (B1)–(B5) (`LP.md:261-282`); código oficial `codigos_externos/codigo_lenza_primiceri/` (`logMLVAR_formin_covid.m`, `bvarGLP_covid.m`, `setpriors_covid.m`) |

### 1.2 Código auditado

| Objeto | Arquivo |
|---|---|
| Port MOSW | `R/identification/weak_iv_ar.R` (solucionador `:77`, MA `:165`, covariância `:325`, inversão AR `:472`, fiação do DFM `:623`) |
| Identificação e IRFs | `R/modeling/impulse_response.R` (`:60`, `:97`, `:158`, `:281`) |
| Linha LP | `R/modeling/factor_estimation.R` (`:56`, `:88`, `:140`, `:275`) |
| Diagnósticos no espaço fatorial | `R/identification/factor_space_diagnostics.R:42` |
| VAR observável do benchmark | `R/modeling/var_proxy.R:29` |
| Produtor de θ̂ | `script/covid_volatility_theta.R` |
| Grades | `script/mosw_strength_grid.R` |
| Validadores | `script/validation/{validate_mosw_ar,validate_olea_kilian,validate_hac_kernel,validate_covid_volatility}.R` |

### 1.3 Verificações independentes executadas (somente leitura, em memória)

| Verificação | Resultado medido |
|---|---|
| Fixture de óleo (RForm_VAR, MARep) | desvio máx. 2,4e-12 no AL, 8,4e-11 nos resíduos |
| Conjuntos AR não cumulativos 68/95 vs MATLAB | desvio relativo máx. 1,6e-12 / 1,2e-11; `casedummy` sem nenhuma divergência |
| Conjuntos AR **cumulativos** 68/95 vs MATLAB (não cobertos pelo validador commitado) | desvio relativo máx. 8,1e-12 / 4,9e-12; `ahatcum/bhatcum/chatcum` e bandas delta-method idem |
| `validate_olea_kilian.R` | ξ₁ = 4,399 (artigo: 4,4); F = 9,438 (9,4); passou |
| `validate_hac_kernel.R` | kernel idêntico a `NW_hac_STATA.m` (0e0 até lag 8); bloco Γ do imposto bate **só** em NW(8), 2,6e-10; passou |
| Extensão DFM vs jacobiano numérico (q<r, `Load` retangular) | 3,3e-11 |
| Redução a MOSW com `Load = Inner = I` | desvio 0 nas derivadas e nas bandas |
| Produção ponta a ponta (`main_sdfm`) | h0 bit a bit: `yield_6m` 0,005; `yield_2y` 0,007009032608368654; `yield_5y` 0,007290054332728365; `asset_ibov` −1,502015837566601286; `cambio_usd` 0,129421673792136122; ξ_den 6,847996589174212; 5.634 `interval` + 1 `singleton` a 90% |
| θ̂ recomputado do CSV | loglik idêntico ao armazenado (diff 0); `s_t` ≠ 1 em 70 de 162 meses; `s` em 2020-03/04/05 = 6,6114 / 12,4683 / 1,7604 |
| Multi-start de θ | 750 partidas; máximo −1579,5909698 contra θ̂ −1579,5909702, dentro da tolerância; 131 partidas terminam em θ̂; 8 com código 52, nenhuma acima |

### 1.4 Não verificado

- MATLAB/Octave **não foi executado** (indisponível): as comparações usam os fixtures commitados em
  `output/validation/`, extraídos uma vez das saídas oficiais.
- A cobertura assintótica dos conjuntos adaptados não tem derivação nem Monte Carlo **na
  especificação atual** (5,5,4); o Monte Carlo existente é da vintage (7,6,6) de 2026-08-12.
- A otimalidade global de θ̂ vale para a grade de 750 partidas, não é um teorema.

---

## 2. Montiel Olea, Stock & Watson (2021)

### 2.1 Mapa artigo → código

| MOSW | Código |
|---|---|
| `C_k(A)` (2.5) | `mosw_marep()` `weak_iv_ar.R:165` e `B_h` dentro de `mosw_response_derivatives()` `:258` |
| `Γ = E(z η)` (2.7) | `Gamma = eta %*% Z / T` `:434` (não centrado, como `SVARIV.m:128`) |
| λ = `e_i'C_kΓ / e_1'Γ` (2.9) | caso geral `scale·(Load B_h Inner Γ)/(d0'Γ)`; `d0 = deriv$C[nvar,,1]` `:494` |
| `H_T` e `Ω = G W G'` (4.1)–(4.2) | `ahat/bhat/chat` `:513-517`; gradiente `D1` `:288-299` |
| `q_T(λ) ≤ χ²` e CS^AR (4.3) | `solve_quadratic_le_zero()` `:77`; `ar_excludes_zero()` `:568` |
| `W` (Assumption 2) | `mosw_rform_cov()` `:325`, port linha a linha de `CovAhat_Sigmahat_Gamma.m` |
| ξ₁ (4.2) | `xi_den = T·den²/(d0'W2d0)` `:549` |
| δ-method (3.2) | `dm_lo/dm_hi/dm_se` `:528-546` |

### 2.2 O que a verificação mostrou

1. **Fidelidade numérica ao MATLAB.** Os conjuntos AR dos fixtures de óleo batem nos quatro blocos
   (coeficientes, bandas AR, bandas delta, códigos de caso) e a aplicação de impostos bate no bloco
   Γ do WHat exatamente em NW(8), o que também valida a opção de kernel.
2. **A adaptação avaliada no benchmark observável.** `validate_mosw_ar.R` §D prova que a
   generalização com `Load`/`Inner` explícitos é o mapa identidade, e §E prova contra jacobiano
   numérico que `D1` é a derivada de `diag(sy) Λ B_h K K' Γ` — confirmei ambos.
3. **Um caso degenerado a mais.** O solucionador do projeto resolve tangência, termo linear puro e
   constante com tolerância relativa; `MSWfunction.m:119-151` manda todos para "reta inteira". É uma
   correção documentada da fragilidade dos autores, não um desvio de resultado (nenhuma célula de
   produção cai nesses ramos).

### 2.3 O que a adaptação ao DFM é, em uma linha

Em MOSW o estimando é `e_i'C_k(A)Γ / e_1'Γ`. No DFM ele vira

    λ_{j,h} = sy_j Λ_j' B_h K K' Γ_u / (sy_mp Λ_mp' K K' Γ_u),

com `Load = diag(sy)Λ`, `Inner = K K'`, `d0 = Load·Inner` lido do impacto (`weak_iv_ar.R:651-652`).
Numerador e denominador continuam funções diferenciáveis de (A, Γ), lineares em Γ, o que é a única
estrutura que Fieller/AR exige; a normalização generaliza de `e_1` (coordenada de uma observável)
para `d0` (direção de carga da variável de política). O critério de limitação vira a Wald na direção
`d0` — ξ_mp dos diagnósticos —, e o código confere ξ_mp pelas duas rotas (S10, `xi_two_routes`). A
condição "conjunto limitado sse ξ_mp > quantil χ²₁" segue valendo célula a célula.

### 2.4 O que a extensão não muda

- Identificação continua a mesma: um instrumento externo, sem centragem sob o tratamento
  (`compute_irf_dfm(..., center = is.null(covid))`, `impulse_response.R:316`), alinhado às inovações
  fatoriais por `sel_ext_inst_sample()` `:24`. Nada aqui é identificação por heterocedasticidade.
- O ponto do caminho AR e o ponto do caminho da identificação são obrigados a coincidir dentro de
  1e-10 em runtime (`impulse_response.R:326-330`).

### 2.5 Caveats reais (declarados, não corrigidos)

1. **Influência fatorial omitida.** A covariância de MOSW é aplicada sobre os regressores,
   resíduos e instrumento reconstruídos (`ar_dfm_bands()`, `:663-718`), mas Λ̂, K̂, M̂, sy e a
   extração fatorial não têm função de influência no bloco. O roxygen declara: "the plug-in
   covariance conditions on the estimated Λ, K, M, sy and θ̂" (`:603-607`). MOSW valida a etapa
   reduzida *observada*; a Prop. 1 não cobre fatores gerados. O parecer de 2026-08-12 mediu a
   consequência em Monte Carlo: cobertura de impacto de 78,1%–83,4% com fatores estimados contra
   86,7%–88,3% com fatores observados.
2. **`q < r` usa `Inner = K K'`.** Assume que a direção do choque proxied vive no espaço dinâmico de
   topo (colunas de G em AK). É a hipótese do modelo, não teorema, e está no comentário.
3. **A leitura de borda.** `ξ_mp = 6,848` garante limitação a 68/90/95%, mas não os "≈ 10" da regra
   convencional; o projeto não trata 3,84 como teste de força (correto, `CLAUDE.md`).

---

## 3. Lenza & Primiceri (2022)

### 3.1 Mapa artigo → código

| LP | Código |
|---|---|
| Trajetória de `s_t` (`LP.md:53`) | `covid_volatility_path()` `factor_estimation.R:56` |
| Reescala `ỹ = y/s`, `X̃ = X/s` (`:57-63`) | `estimate_var_wls()` `:88` (`RHS/s`, `LHS/s`) |
| (B2)(B3) | `bet <- solve(crossprod(RHS/s)) %*% crossprod(RHS/s, LHS/s)` `:95` |
| (B4) | `sigma_mle <- crossprod(e)/n_eff`, `n_eff = T - p` `:98` |
| (B5) | `loglik` `:110-111` (com a constante gaussiana adicionada, inócua para o argmax) |
| "numerically maximizing (B5)" (`:282`) | `estimate_covid_theta()` `:140`, L-BFGS-B em caixa |
| Valores iniciais | regra de `bvarGLP_covid.m:59-66`, `:149-152` |
| Piso `s̄ ≥ 1` | caixa `script/covid_volatility_theta.R:27`; justificativa: sem ele a verossimilhança é ilimitada (`−n log s`), demonstrado no check S6 |

### 3.2 Verificações

- Caminho `s_t` idêntico a `invweights` (check S3; e o check de degeneração N1/N2 prova que θ neutro
  reproduz OLS bit a bit).
- (B1) confere com a soma linha a linha da gaussiana (N3/S2); (B2) confere com `lm.wfit(w = 1/s²)`
  (S1); início confere com a transcrição literal dos autores (S8); FOCs do envelope `m = 1` em t* e
  t*+1 (S5); loglik de θ̂ recomputado por mim do CSV, idêntico.
- A inferência tratada está provada por linearização exata (S9: `vec(Â−A)` e Γ̂ iguais às somas de
  influência de MOSW sobre `(x̃, z, ε)`; com `x` no lugar de `x̃`, o desvio de A é 0,070) e por
  montagem manual de MOSW (S10: conjuntos bit-idênticos, ξ pelas duas rotas).

### 3.3 Desvios declarados do artigo (todos em `2026-09-16_fidelidade_lenza_primiceri.md`)

1. **Ramo implementado é o Apêndice B, não o corpo bayesiano.** Sem prior, sem integração sobre θ;
   θ̂ pontual. O artigo **nunca estima pelo Apêndice B** — os 17/65/20 e ρ ≈ 0,8 são modos de
   posterior dos EUA (7 séries, 1988:12–2021:5), não comparáveis.
2. **Caixa de θ:** `s̄ ≥ 1` vem do `MIN.eta` dos autores (código bayesiano, ausente do Apêndice B);
   teto ∞ contra 500 e ρ fechado em [0,1] contra (0,005; 0,995) são escolhas do projeto.
3. **Assimetria estimada:** aqui s̄₂ = 1,76 (maio já quase normal) e ρ = 0,944 (meia-vida de 12
   meses), contra um pico de maio em LP. Os dados admitem também o máximo local em ρ = 0 (2,6
   log-pontos abaixo); reportado, não escondido.

### 3.4 Adaptação ao DFM e o acoplamento com a inferência AR

1. **A *commonality* muda de objeto.** LP: um escalar multiplicando as n covariâncias das inovações
   observáveis. Aqui: um escalar nas r = 5 inovações fatoriais — hipótese sobre uma rotação do
   componente comum, que não se deduz do artigo.
2. **A extração fica sem tratamento.** O PCA, Λ̂ e `sy` veem o painel original
   (`estimate_dfm()` `:312`; a escala entra só no `estimate_var_wls` `:313`). O próprio LP avisa
   (`LP.md:155`) que modelos com latentes pedem filtro sensível à volatilidade. O texto do paper
   declara que a reescala não alcança a extração — é honesto, mas é uma extensão.
3. **θ̂ não é consistente.** s̄₀ e s̄₁ dependem de uma observação cada (`n ŝ_k²/s̄_k² ~ χ²_n` com
   n = 5 no exercício da nota). Como o estimador não concentra, a incerteza de θ̂ não desaparece com
   T, e os conjuntos AR que a tratam como conhecida **não herdam** a cobertura de MOSW. Nenhuma
   correção de covariância por θ̂ existe no código (grep vazio). É o ponto teoricamente mais frágil
   de toda a adaptação, e está registrado como item (b)6 na nota de fidelidade e como propriedade
   declarada no `CLAUDE.md`; as três saídas possíveis (conjunto conjunto em (β, θ), integração
   bayesiana, teoria incidental) não foram tentadas.
4. **A inferência AR sob WLS é construção do projeto.** Combina o estimador de LP com a covariância
   de MOSW sobre a regressão transformada, sem centragem e com Γ não centrado; `"raw"` aborta porque
   misturaria regressores transformados e não transformados. Internamente coerente e provado por
   S9/S10, mas nenhum dos dois artigos cobre esse objeto.

---

## 4. Achados menores

| # | Achado | Impacto |
|---|---|---|
| 1 | `covariance_matrix` de `estimate_var_wls` usa divisor `T−p−pK−1`, que não é a (B4), e não tem consumidor | Nenhum — peso morto; declarado como o candidato mais forte a (d) que caiu |
| 2 | O guard do multi-start (`covid_volatility_theta.R:132-145`) confere `loglik`, não `convergence` | 8/750 partidas terminam com código 52, nenhuma acima de θ̂; registrar o código fecharia o flanco |
| 3 | `plot_irf()` sombreia o intervalo `[lo, hi]`; um conjunto `two_rays` teria o **gap** sombreado | Nenhuma célula de produção é `two_rays` (todas `interval`/`singleton`); a leitura de significância em `irf_coherence_h.csv` usa `ar_excludes_zero()`, que respeita a topologia |
| 4 | A prosa do paper não carrega os dois caveats (fatores/θ̂ condicionados; θ̂ não consistente) | Decisão do autor (2026-09-16/17); risco de leitura excessiva dos conjuntos como "robustos a instrumento fraco" no sentido pleno |

---

## 5. Conclusão

A pergunta era dupla. **Implementação:** correta e fiel — sustentada por regressão contra a saída
dos próprios autores em duas aplicações, por jacobiano numérico na extensão, por linearização exata
no caminho tratado e pela reprodução bit a bit da produção. **Adaptação:** faz sentido enquanto
extensão estrutural; o estimando e o teste preservam a álgebra de Fieller–AR, e as limitações estão
nomeadas no código e nas notas em vez de escondidas. O que um referee atacaria não é o código: é a
cobertura incondicional dos conjuntos AR quando fatores, cargas e θ̂ são estimados — um problema que
o repositório já documenta desde 2026-08-12 e que nenhuma das duas literaturas resolve.

**Achado novo desta rodada:** o ramo cumulativo da inversão (`mosw_ar_bounds(cumulative = TRUE)`),
que os códigos de transformação 2 e 5 usam em produção, não era coberto pelo `validate_mosw_ar.R`
contra o fixture MATLAB. Verifiquei-o aqui: bate a ~8e-12, e não há divergência de classificação.
Sugestão de baixo custo: acrescentar esse bloco ao validador, para que a cobertura fique commitada.
