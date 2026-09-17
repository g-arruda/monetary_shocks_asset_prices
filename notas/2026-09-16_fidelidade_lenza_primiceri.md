# Fidelidade a Lenza-Primiceri (2022): o que o artigo autoriza, o que foi estendido aqui

> **Destino: `notas/`, registro citável — arquivo novo, não extensão das três de 09-14.**
> As três notas daquela rodada têm, cada uma, uma seção "Decisões que não estão no artigo"
> (`…lenza_primiceri…:206`, `…estimacao_theta…:268`, `…inferencia…:271`), e a §2 da primeira
> (`:35-70`) já mapeia eq. (1) e (B2)-(B5) para funções do repo. Nenhuma serve de casa para esta:
> a tabela abaixo **cruza as três** — eq. (1) mora na primeira, (B2)-(B5) na segunda, a covariância
> de MOSW na terceira — e a §2 da primeira foi escrita **antes de θ existir** ("nenhum θ foi
> escolhido e nenhuma verossimilhança foi maximizada", `:12`). Esta nota **não supersede nenhuma
> das três** e não computa número novo: cita-as, e cita os CSVs.
>
> **CURRENT — 2026-09-16. Rodada documental: nada foi estimado, nada foi rodado.**
> - Auditoria de fidelidade da rodada de 2026-09-14, sob o painel de produção de 115 séries,
>   2012-03 a 2025-12, `(r, p) = (5, 4)`, 162 meses de resíduo.
> - Artigo: Lenza & Primiceri (2022), *JAE* 37(4), 688-699, em
>   `artigos/Lenza - How to estimate a vector autoregression after March 2020/`. Daqui em diante
>   **`LP.md:<linha>`** referencia o `.md` único dessa pasta.
> - **A produção não muda.** `covid_volatility = NULL` (`R/modeling/production_spec.R:36`) e o
>   tratamento segue desligado, sem veredito — o autor lê as IRFs a olho.
> - **Fora do escopo:** prosa de paper, `registro/pendencias.md`, e qualquer proposta de mudança
>   de produção. Esta nota reporta; não defende e não recomenda.

## 0. As caixas

Quatro, como pedido, mais uma declarada:

| caixa | significado |
|---|---|
| **(a) FIEL** | faz o que o artigo faz, adaptado só de notação |
| **(a★)** | **fiel ao código MATLAB dos autores, ausente no Apêndice B** — o `.m` deles implementa o ramo bayesiano (§2/Apêndice A), e o ramo implementado aqui é o frequentista |
| **(b) EXTRAPOLAÇÃO** | o artigo não cobre este caso e a escolha foi feita aqui |
| **(c) ENGENHARIA** | implementação sem conteúdo metodológico |
| **(d) DIVERGÊNCIA** | sai do artigo e **não há justificativa registrada** |

Regra de desempate usada: nada que altere estimador, amostra efetiva ou distribuição de inferência
entra em (c); na dúvida entre (b) e (c), vai para (b), com a dúvida dita.

## 1. O que o artigo propõe

**Correção factual antes de tudo: o artigo não tem equação (3).** A numeração do corpo para em (2)
(`LP.md:81`), e retoma só no Apêndice B, em (B1)-(B5) (`:265`, `:271`, `:273`, `:275`, `:280`). As
fórmulas centrais da reescala — as que este projeto de fato implementa — são **displays sem
número** (`:57`, `:61`). Elas são citadas por linha nesta nota.

**Eq. (1)** (`LP.md:48`, `:50`, tag em `:51`) modifica um VAR padrão com um escalar de volatilidade:

```
y_t = C + B_1 y_{t-1} + … + B_p y_{t-p} + s_t ε_t ,    ε_t ~ N(0, Σ)
```

`y_t` é `n × 1`; `s_t` "is used to scale up the residual covariance matrix during the period of the
pandemic" (`:53`). A estrutura implícita é **Var(s_t ε_t) = s_t² Σ**, explicitada só em (B1)
(`:263`, como `|s_t² Σ|`).

**A trajetória de `s_t`** (display sem número, `:53`): `s_t = 1` antes do início da epidemia, `t*`;
depois `s_{t*} = s̄0`, `s_{t*+1} = s̄1`, `s_{t*+2} = s̄2`, e `s_{t*+j} = 1 + (s̄2 − 1)ρ^{j−2}`, com
`θ ≡ [s̄0, s̄1, s̄2, ρ]`. Três níveis livres e um decaimento geométrico **para 1**, não para 0. Em
`j = 2` a fórmula devolve `s̄2` exatamente (ρ⁰ = 1): o ramo de decaimento é contínuo em maio, e o
primeiro valor efetivamente decaído é junho de 2020. A parametrização é "particularly suitable for
monthly and quarterly time series" (`:53`), e os autores registram que "alternative
parameterizations are possible" (`:53`).

**A *commonality assumption*** (`:30`, única ocorrência da palavra no artigo) é a condição que torna
tudo isso barato: os três `s̄` podem ser estimados "provided that this re-scaling is **common to all
shocks**. This commonality assumption is the same assumption underlying the stochastic volatility
model of Carriero et al. (2016), and it should of course only be interpreted as an approximation."
O contraste está em `:40`: Carriero et al. (2021) permitem fatores de escala **por variável**; LP
não, e trocam isso por autocorrelação ao longo da pandemia.

**A reescala** (`:57`, `:59`, `:61`, `:63`), que é o mecanismo inteiro. Com `X_t ≡ I_n ⊗ x_t'`,
`x_t ≡ [1, y'_{t−1}, …, y'_{t−p}]` e `β ≡ vec([C, B_1, …, B_p]')`, escreve-se `y_t = X_t β + s_t ε_t`;
dividindo por `s_t`, `ỹ_t = X̃_t β + ε_t` com `ỹ_t ≡ y_t/s_t` e `X̃_t ≡ X_t/s_t`. E então a licença
que este projeto usa (`:63`): "the parameters β and Σ can be estimated using the transformed data
ỹ_t and X̃_t, and the researcher's preferred approach to inference, **such as ordinary least
squares, maximum likelihood, or Bayesian estimation**."

**O corpo é bayesiano.** Prior conjugado Normal-Inverse-Wishart (`:67`, `:69`), hiperparâmetros `γ`
como em Giannone, Lenza & Primiceri (2015), e **eq. (2)** (`:80-81`): `p(γ,θ|y) ∝ p(y|γ,θ)·p(γ,θ)`,
com o primeiro fator a marginal likelihood, analítica (`:85-87`). `θ` entra **no bloco de
hiperparâmetros**: hiperprior Pareto(1,1) em cada `s̄` e Beta(moda 0,8; dp 0,2) em ρ (`:87`). O
Apêndice A (`:220-257`) amostra `(γ, θ)` por Metropolis e sorteia `(β, Σ)` de uma NIW a cada draw —
ou seja, **o artigo integra sobre θ**, e a Figura 1 (`:99`, `:103`) *é* o posterior de θ. As
estimativas publicadas: `s̄0, s̄1, s̄2` com picos "around 17, 65, and 20" e ρ "centered just below
0.8" (`:107`).

**O Apêndice B (`:259-282`) é o ramo frequentista, e é o implementado aqui.** (B1) (`:263`, `:265`)
é a verossimilhança, já fatorada como `(∏ s_t^{-n}) · |Σ|^{-(T-p)/2} · exp{…}`, onde `∏ s_t^{-n}` é
o jacobiano da transformação `ỹ_t = y_t/s_t` (nomeado assim em `:246`). Dado θ:

```
(B2)  B̂_mle(θ) = (x̃'x̃)^{-1} x̃'ỹ            LP.md:271
(B3)  β̂_mle(θ) = vec[B̂_mle(θ)]              LP.md:273
(B4)  Σ̂_mle(θ) = ε̂'_mle ε̂_mle / (T − p)     LP.md:275
```

com `ε̂_mle ≡ ỹ − x̃ B̂_mle(θ)` (`:277`). (B2) é **MQO nos dados reescalados** — sem `Ω^{-1}`, ao
contrário do `B̂` bayesiano do Apêndice A (`:252`) — e (B4) divide por `T − p`, não por `T − p + d`.
Substituindo em (B1) sai a concentrada, **(B5)** (`:279`, tag em `:280`):

```
p(y | β̂(θ), Σ̂(θ), θ)  ∝  ∏_{t=p+1}^{T} s_t^{-n} · | ε̂'ε̂/(T−p) |^{-(T−p)/2}
```

Dois termos e só dois: a penalidade de jacobiano `−n Σ log s_t`, que pune `s_t` grande, e o
log-determinante da covariância reescalada, que o recompensa nos meses extremos. A frase final do
artigo (`:282`): "The parameters θ can then be estimated by **numerically maximizing** (B5), and
the estimates of β and Σ can be obtained using (B2)-(B4)." **Nada mais.** Nenhum algoritmo, nenhum
valor inicial, nenhuma restrição sobre `s̄` ou ρ, nenhum erro-padrão, nenhum perfil.

## 2. Tabela de mapeamento

Uma linha por equação do artigo efetivamente tocada. `LP.md` é o artigo; os demais caminhos são do
repositório.

| eq. | o que afirma | onde vive | o que muda aqui | caixa |
|---|---|---|---|---|
| **(1)** `LP.md:48,50,51` | `y_t = C + ΣB_i y_{t-i} + s_t ε_t`, `ε_t ~ N(0,Σ)` | `estimate_var_ols()` `factor_estimation.R:550-606`; chamada em `estimate_dfm:950` | `y_t` são os **fatores estimados** `F̂_t`, não observáveis; o VAR é só-intercepto | **(b)** |
| trajetória de `s_t` `LP.md:53` | `s=1` antes de `t*`; `s̄0,s̄1,s̄2`; `1+(s̄2−1)ρ^{j−2}` | `covid_volatility_path()` `factor_estimation.R:515-524` | `j` conta meses de **calendário** (`:516-517`), não índice de linha como `logMLVAR_formin_covid.m:36-38` | **(a)** + **(c)** |
| display `LP.md:57,59` | `y_t = X_t β + s_t ε_t`, `x_t ≡ [1, y'_{t-1},…]` | `RHS` em `factor_estimation.R:554-560` | constante na **última** coluna (`:560`); o bloco de inferência a repõe na **primeira** (`weak_iv_ar.R:661`) | **(c)** |
| display `LP.md:61,63` | `ỹ_t = X̃_t β + ε_t`, `ỹ=y/s`, `X̃=X/s` | `factor_estimation.R:568`; `weak_iv_ar.R:664-666` | nada | **(a)** |
| **(2)** `LP.md:80,81` | `p(γ,θ\|y) ∝ p(y\|γ,θ)·p(γ,θ)` | **não implementado** | ramo bayesiano não tomado | contraste |
| NIW `LP.md:67,69` | `Σ~IW(Ψ,d)`, `β\|Σ~N(b,Σ⊗Ω)` | **não implementado**: `bet` (`:568`) não tem `Ω^{-1}` | sem prior e sem encolhimento — como o próprio Apêndice B | contraste |
| **(B1)** `LP.md:263,265` | verossimilhança; fator `∏ s_t^{-n}` | conferida contra a (B5) do código em `validate_covid_volatility.R:224-232` (S2) | nada | **(a)** |
| **(B2)** `LP.md:271` | `B̂(θ) = (x̃'x̃)^{-1} x̃'ỹ` | `factor_estimation.R:568` | nada; rota independente por `lm.wfit(w=1/s²)` em `validate_covid_volatility.R:215-222` (S1) | **(a)** |
| **(B3)** `LP.md:273` | `β̂ = vec[B̂]` | nunca vetorizado: `bet` fica matricial em `factor_estimation.R:582` e `:598` | puramente notacional | **(c)** |
| **(B4)** `LP.md:275` | `Σ̂(θ) = ε̂'ε̂/(T−p)` | `sigma_mle` em `factor_estimation.R:593`, `n_eff = T−p` em `:592`; alimenta K em `:964-966` | coexiste um divisor `T−p−pK−1` (`:602`) que **não é** a (B4) — e não tem consumidor | **(a)** + **(c)** |
| **(B5)** `LP.md:279,280` | `∏ s_t^{-n} · \|ε̂'ε̂/(T−p)\|^{-(T−p)/2}` | `loglik` em `factor_estimation.R:594-595` | soma a constante gaussiana `−(T−p)K/2·(1+log 2π)` (`:594`), que o artigo omite por proporcionalidade | **(a)** + **(c)** |
| `LP.md:282` | "θ … estimated by numerically maximizing (B5)" — e nada mais | `estimate_covid_theta()` `factor_estimation.R:629-659` | L-BFGS-B (`:648-649`), `factr=1e3`, caixa (`:642-644`), início pela regra dos autores (`:638-641`) | piso **(a★)**, início **(a★)**, resto da caixa **(b)**, otimizador **(c)** |

Duas equivalências da tabela merecem a demonstração, porque não são óbvias:

**A trajetória cobre `s_{t*+2}` sem caso especial.** O código atribui `s[j >= 2] <- 1 + (s2-1)*rho^(j-2)`
(`factor_estimation.R:522`), sem uma linha para `j == 2`. Em `j = 2` isso vale `1 + (s̄2 − 1)·ρ⁰ = s̄2`,
que é exatamente `s_{t*+2} = s̄2` de `LP.md:53`. Medido: `covid_volatility_path.csv` dá
`2020-05-01, s = 1.760352430309222`, idêntico ao `s2` de `covid_volatility_theta.csv`.

**A constante gaussiana não move o argmax.** O código calcula
`-n_eff*K/2*(1+log(2*pi)) - K*sum(log(s)) - n_eff/2*log|sigma_mle|` (`:594-595`). Substituindo
`Σ = Σ̂ = ε̂'ε̂/(T−p)` em (B1), o traço `tr(Σ̂^{-1} ε̂'ε̂)` vale `(T−p)n`, e o log de (B1) fica
exatamente essa expressão. Ou seja, `loglik` é a log-verossimilhança gaussiana **completa** em
`(B̂, Σ̂)`, e (B5) é ela menos `−(T−p)K/2·(1+log 2π)` = **−1149,3402118958** com `T−p = 162` e
`K = 5`. Constante em θ: o argmax é o mesmo e **diferenças** de log-verossimilhança — inclusive os
2,6 log-pontos da §3.6 — são invariantes à escolha.

## 3. Os eixos de divergência

### 3.1 BVAR conjugado (§2) contra verossimilhança concentrada (Apêndice B)

**Implementado: o Apêndice B, exclusivamente.** Três marcas, cada uma verificável:

1. `bet <- solve(crossprod(RHS/s)) %*% crossprod(RHS/s, LHS/s)` (`factor_estimation.R:568`) **não
   tem `Ω^{-1}`**. O `B̂` do Apêndice A (`LP.md:252`) é `(x̃'x̃ + Ω^{-1})^{-1}(x̃'ỹ + Ω^{-1}b̂)`. O do
   código é a (B2) pura.
2. `sigma_mle <- crossprod(e)/n_eff` com `n_eff <- T - p` (`:592-593`) é a (B4). O Σ do Apêndice A
   é IW com escala `Ψ + ε̂'ε̂ + (B̂−b̂)'Ω^{-1}(B̂−b̂)` e `T−p+d` graus de liberdade (`LP.md:256`).
3. Não existe objeto de prior em lugar algum do caminho: nenhum `Ψ`, `d`, `b`, `Ω`, nenhum `γ`.

**θ̂ sai da (B5) — do objetivo, exatamente; do problema, não.** O objetivo é a (B5) a menos da
constante aditiva demonstrada na §2, logo `argmax` idêntico. O que **não** vem do artigo é o
*conjunto viável*: a maximização roda dentro da caixa `[1,∞)³ × [0,1]`
(`production_spec.R:39-40`), e o Apêndice B não fixa limite nenhum — o que é a §3.3.

**Consequência que precisa ser dita ao citar o artigo:** LP **nunca estimam nada pelo Apêndice B**.
Os 17/65/20 e o ρ "just below 0.8" da Figura 1 (`LP.md:107`) são **modos de posterior do ramo
bayesiano**, sobre sete séries mensais dos EUA, 1988:12-2021:5, 13 defasagens, prior Minnesota
(`:97`). Não há, no artigo, um único número produzido pelo ramo que este projeto implementa.
Comparar θ̂ daqui com aqueles é comparar estimador frequentista contra moda de posterior, em país,
painel e objeto diferentes. Isso vai para a §5.

### 3.2 VAR em observáveis contra VAR em fatores estimados

**A escala entra só no VAR dos fatores. O PCA recebe a matriz original.** A prova são três linhas
consecutivas de `estimate_dfm()`:

```r
# factor_estimation.R:941-942   s_t é construído
volatility_path <- covid_volatility_path(residual_dates, covid_start, covid_volatility$theta)
# factor_estimation.R:946       PCA recebe `data`, NÃO `data/s`
static_result <- estimate_static_factors(data, r)
# factor_estimation.R:950       s_t entra aqui, e só aqui
var_result <- estimate_var_ols(static_result$factors, p, s = volatility_path)
```

`estimate_static_factors()` tem assinatura `(data, r, standardized = TRUE, seed = NULL)`
(`:235`) — nenhum argumento de escala. A padronização BLL (`sy`, desvio das primeiras diferenças) e
os autovetores saem da amostra cheia, com março e abril de 2020 pesando como qualquer mês.

**Regressores gerados.** A (B5) avaliada aqui é a verossimilhança do VAR **condicional a `F̂`**. O
erro de estimação dos fatores não entra em `ℓ(θ)`, e nada o corrige. Registrado em
`…lenza_primiceri…:211-213`.

**O que isso custa, sem inflar.** A IRF publicada é `diag(sy)·Λ·B_h·K·M·H`: **só o componente
comum**. O bloco idiossincrático nunca entra no objeto reportado, então deixá-lo sem tratamento não
contamina número nenhum. O que **sobrevive em cada número** é outra coisa:

```r
# weak_iv_ar.R:653
Load <- sweep(Lambda, 1, sy, "*")
```

`Λ̂` e `sy` vêm do PCA sobre o painel original (`factor_estimation.R:946`), e multiplicam toda
resposta. Ou seja: **o tratamento repondera a dinâmica (B, Σ) e não repondera as cargas.** Uma
metade do modelo vê a pandemia com peso 1/s_t², a outra com peso 1.

**A *commonality assumption* muda de objeto.** Em LP ela é "common to all shocks" (`LP.md:30`) das
`n` observáveis. Aqui passa a valer sobre as `r = 5` inovações do VAR dos fatores. São proposições
diferentes, e a segunda não se deduz da primeira: que a pandemia multiplique a covariância das
inovações de fator por um escalar comum é uma hipótese sobre uma rotação do componente comum, não
sobre os dados. O artigo não dá apoio nem contrário — ele não tem modelo de fatores (grep por
*factor* no `LP.md` dá 7 ocorrências, todas "scaling factor", "the factor s_t" ou "driven by two
factors"; nenhuma é fator latente).

**O artigo antecipa exatamente essa lacuna e o projeto não a fecha.** `LP.md:155`: "the estimation
of models with **latent variables** cannot be easily dealt with by simply dropping all the
observations related to the pandemic … these models require filtering and smoothing techniques that
are generally sensitive to the value of shock volatilities. Therefore, not properly accounting for
the drastic increase of such volatilities since February 2020 might lead to misleading results, not
only in terms of inference about the latent variables of these models but also about other objects
of interest." Coerente com isso, na aplicação de previsão condicional os autores rodam o filtro de
Kalman **com a covariância variando no tempo** (`:133`). Aqui, a extração dos fatores — que é
precisamente o passo de variável latente — roda sem `s_t`. Registrado como escolha de escopo em
`…lenza_primiceri…:214-218` e `…estimacao_theta…:280`. **(b)**

### 3.3 Parametrização de θ: datas, frequência, decaimento

**O que segue o artigo.** `t*` = 2020-03 (`production_spec.R:38`), fixado por calendário mais uma
olhada descritiva nos resíduos de Mahalanobis do OLS (`…estimacao_theta…:39`, `:46-54`) — LP fixam
`t*` pela narrativa (`LP.md:30`). Frequência mensal, que é a que o artigo endossa explicitamente
(`:53`, `:95`). Três níveis livres mais decaimento geométrico, sem alteração no número ou na
alocação dos meses. **(a)**

**O que não segue: a caixa.** O Apêndice B não fixa limite algum. A caixa usada é
`[1,∞)³ × [0,1]` (`production_spec.R:39-40`), contra `[1,500]³ × [0,005; 0,995]` dos autores
(`setpriors_covid.m:225-228`), que ali é imposta por **transformação logística**
(`logMLVAR_formin_covid.m:33`) e portanto é **aberta**.

- **O piso `s̄ ≥ 1` é idêntico ao `MIN.eta(1:3) = [1;1;1]` deles** → **(a★)**. Mas a *razão* é do
  projeto, não deles: nos autores o piso vem do prior; aqui ele é o que faz o máximo existir, porque
  com `s` livre para tender a zero o WLS ajusta aquele mês exatamente e (B5) cresce como `−n log s`
  (`factor_estimation.R:613-615`, demonstrado no check S6, `validate_covid_volatility.R:312-320`).
- **Teto ∞ contra 500, e ρ ∈ [0,1] fechado contra (0,005; 0,995) aberto** → **(b)**. O fechamento em
  ρ = 0 é o que torna o segundo máximo da §3.6 um ponto admissível; sob a caixa dos autores o
  análogo cairia em 0,005.

**O que o artigo não prevê: a forma estimada é qualitativamente outra.** De
`output/factors/covid_volatility_theta.csv`:

| | s̄0 | s̄1 | s̄2 | ρ |
|---|---|---|---|---|
| **θ̂ aqui** | 6,611428527060552 | 12,468337921789994 | 1,760352430309222 | 0,9439261800636236 |
| LP, modas de posterior (`LP.md:107`) | ≈ 17 | ≈ 65 | ≈ 20 | "just below 0.8" |

Em LP, maio ainda é um mês extremo (≈ 20) e a volatilidade cai "by one fifth each month" (`:107`).
Aqui, **maio já é quase normal** (1,76) e o decaimento é lentíssimo: meia-vida de `s_t − 1` de
**12,011426641601938 meses**, contra ~3,1 meses implicados por ρ = 0,8. A consequência prática é que
"os três meses da pandemia" descreve mal o que o tratamento faz neste painel:

- `s_t ≠ 1` em **70** dos 162 meses de resíduo — de 2020-03 a 2025-12, e **nunca volta a 1**: em
  2025-12 ainda vale 1,0159170672623792 (`covid_volatility_path.csv`);
- 10 meses com `s_t > 1,5` e 50 com `s_t > 1,05`;
- em meses-equivalentes, `Σ(1 − 1/s_t²) = 19,06549159762942` — dos quais só **1,9706899111662564**
  vêm de 2020-03 e 2020-04 juntos. Dezenove meses de 162 perdem peso, não três.

**E o que a parametrização não cobre.** Depois do tratamento, os dois maiores resíduos de
Mahalanobis não são meses de pandemia: **2016-01 (8,0055)** e **2018-05 (5,6675)**, contra
2020-03 (1,0000135644954433) e 2020-04 (0,999996841675076), que o WLS zera por construção. A
parametrização de LP não tem onde acomodá-los; registrado como suspeito seguinte em
`…estimacao_theta…:297-299` e `…inferencia…:295`. **(b)**

### 3.4 O que a reponderação NÃO faz

**(i) Não identifica nada.** A identificação continua sendo o proxy externo, e o tratamento não a
toca em ponto algum:

- `identification = "proxy"` é o único ramo (`.claude/rules/identification.md:24-31`);
- o instrumento `z` **não é reescalado em lugar nenhum** — `s_t` divide apenas `RHS`/`LHS`
  (`factor_estimation.R:568`) e `X_reg` (`weak_iv_ar.R:665`);
- `H = (Z'η)/(Z'Z)` segue a mesma fórmula, chamada em `impulse_response.R:580-584`.

O que muda é a centragem: `ident_ext_instr(..., center = is.null(dfm_results$covid_volatility))`
(`impulse_response.R:584`). Sob OLS com constante a centragem de AK é no-op; sob WLS as equações
normais dão `Σ_t u_t/s_t² = 0` e nem `u_t` nem `ε̃_t` somam zero, então centrar **moveria** o ponto —
por isso nada é centrado, alinhado ao Γ não centrado de MOSW (`SVARIV.m:128`). Derivado em
`…estimacao_theta…:187-217`, medido no check S7 (`validate_covid_volatility.R:322-351`).
`CLAUDE.md` já carrega a proibição correspondente: isto **não** é identificação por
heterocedasticidade, que foi abandonada em 2026-08-17.

**(ii) Está desligado em produção.** `covid_volatility = NULL` (`production_spec.R:36`). Com NULL, o
objeto inteiro de `main_sdfm()` sai `identical()` ao código sem tratamento
(`.claude/rules/identification.md:50-51`), e os checks N1-N2 do validador amarram isso — inclusive
com as constantes do smoke test do `CLAUDE.md` **hard-coded** em
`validate_covid_volatility.R:89-96`. O switch é derivado, não duplicado: `apply_kilian =
is.null(covid_volatility)` em `dfm_pipeline.R:108` e `spec_sweep.R:304`. A única célula que o liga é
`cheia_p4_lp` (`q_truncation.R:80-86`, `:133`), mais `q_narrative_overlay_covid.R:82`.

**(iii) Os conjuntos AR condicionam em θ̂.** Está dito no código (`weak_iv_ar.R:605-606`: "The sets
condition on the estimated scale as they do on the loadings") e materializa-se em duas linhas e uma
ausência:

- `X_reg <- X_reg / dfm_results$volatility_path` (`weak_iv_ar.R:665`) — `s_t` entra como dado;
- `if (is.null(covid)) u_sel <- sweep(u_sel, 2, colMeans(u_sel))` (`:683-685`) — sem centragem;
- **nenhuma correção de covariância por erro em θ̂ em lugar nenhum.** Verificado por grep: fora de
  `factor_estimation.R`, os únicos usos de `theta` em `R/` estão em `production_spec.R:33-40`
  (os limites). Não há derivada, jacobiano ou delta-method em θ̂.

O Apêndice B é coerente com isso — (B2)-(B4) são plug-in em θ̂ e o artigo não menciona erro-padrão
(grep: zero para *standard error* e *confidence*). Mas o artigo também não constrói inferência
alguma em cima, o que é a §3.5.

### 3.5 Inferência AR/MOSW e WLS sobre dados reescalados

**O artigo não cobre nada disto.** Sobre o `LP.md` inteiro, contagem zero para: *instrument*
(incluindo *instrumental*), *proxy*, *weak*, *Anderson*, *Rubin*, *external*, *SVAR*, *generated
regressor*, *standard error*, *confidence*, *asymptot* (fora de uma referência). E a identificação
estrutural aparece só para ser **negada**: as IRFs do artigo são Cholesky e "do not have any
structural interpretation … we use them only as summary statistics of the estimated dynamics"
(`LP.md:34`, repetido em `:113`).

**Tudo nesta subseção é (b).** A fidelidade da derivação está ancorada em **MOSW, não em LP**: dado
θ, a (B2) é MQO nas linhas divididas por `s_t`, logo a função de influência é a de
`CovAhat_Sigmahat_Gamma.m` sobre `(x̃_t, z_t, ε̃_t)` com Γ não centrado
(`weak_iv_ar.R:600-608`; derivação em `…inferencia…:41-79`; checks S9 e S10,
`validate_covid_volatility.R:365-430`). Internamente é coerente, e há guardas de verdade: a
ortogonalidade `max|X'u| ≤ 1e-8·escala` (`weak_iv_ar.R:703-709`) é a prova barata de que o bloco de
regressores reconstruído é a mesma equação estimadora que produziu `u` — sob WLS ela verifica
`Σ_t x_t u_t/s_t² = 0`, que são as equações normais de (B2). `"raw"` não foi derivado e **para**
(`:632-637`), assim como bootstrap (`impulse_response.R:478-482`) e Kilian
(`factor_estimation.R:930-933`).

**O ponto que mais pesa, e que precisa ser dito por inteiro.** O argumento padrão para ignorar um
plug-in — "o erro de θ̂ é de ordem menor" — está **indisponível pela própria análise do projeto**:
`…estimacao_theta…:90-104` (§3.3, "θ não é consistente, e B̂ não precisa que seja") registra que cada
`s̄` é o tamanho de **um** resíduo e não melhora quando `T → ∞`. Isso é consistente com `B̂` —
mínimos quadrados ponderados com pesos errados mas fixos continuam consistentes para β, só perdem
eficiência. Mas a inferência é outra história: os conjuntos tratam `s_t` como dado não aleatório,
e a aleatoriedade de θ̂ **não desaparece com a amostra**. A nota de inferência já dimensiona o
problema em amostra finita (`…inferencia…:61-66`): "A condicionalidade é, então, uma propriedade de
amostra finita. Aqui ela não é pequena: cerca de 19 meses-equivalentes de 162 são reponderados."

**O que faltaria para justificar**, sem que nada disso seja recomendação:

1. uma teoria limite para o estatístico AR com θ de dimensão incidental (um `s̄` por mês tratado),
   que é o regime em que θ̂ não converge; ou
2. um conjunto AR **conjunto** em `(β, θ)`, projetado depois sobre β — que dispensa consistência de
   θ̂ porque não a usa; ou
3. a rota dos próprios autores: **integrar θ**, como o corpo do artigo faz (`LP.md:80-81`,
   Apêndice A) — o que exige o ramo bayesiano, e portanto um prior, que este projeto não tem.

Nenhuma das três foi tentada, e isso está registrado como propriedade declarada, não como lacuna
escondida (`…lenza_primiceri…:263-265`, `…inferencia…:258-260`, `CLAUDE.md`).

### 3.6 O segundo máximo em ρ = 0

**O artigo não discute o perfil da verossimilhança.** *profile* aparece 2 vezes no `LP.md`, nenhuma
no Apêndice B e nenhuma sobre verossimilhança (`:32`, "profile of volatility dynamics"; `:167`,
"fit this profile"). *maxima*, *multiple*, *local max*: zero. O Apêndice B diz "numerically
maximizing (B5)" (`:282`) e para aí. No ramo bayesiano a multimodalidade apareceria como forma de
posterior, e a Figura 1 (`:103`) não a exibe.

**O tratamento dado aqui é computar e reportar** — `script/covid_volatility_theta.R:54-69` perfila ρ
numa grade de 101 pontos (`seq(0, 1, by = 0.01)`), reotimizando `(s̄0,s̄1,s̄2)` em cada ponto, com
guarda para o caso de o perfil superar o máximo livre (`:70-73`). De
`output/factors/covid_volatility_profile_rho.csv`, há **exatamente dois máximos locais**:

| | ρ | ℓ |
|---|---|---|
| interior (grade) | 0,94 | −1579,603309807503 |
| **máximo livre** (otimizador) | 0,9439261800636236 | **−1579,5909701725416** |
| fronteira | 0 | −1582,2120997645773 |
| fronteira | 1 | −1583,3672202193582 |
| vale | 0,5 | −1584,779233595434 |

**A diferença de "2,6 log-pontos" tem duas leituras, e vale nomear a referência**, porque as duas
circulam no repositório e nenhuma está errada:

- contra o **máximo livre**: **2,621129592035686** — é o "2,62" de `…estimacao_theta…:109,113`;
- contra o **máximo da grade** em ρ = 0,94: **2,608789957074350**.

`CLAUDE.md` e `notas/_indice.md:65` dizem "2,6", que é correto nas duas. A distância entre as duas
leituras é 0,012339634961335832 log-ponto — irrelevante para qualquer conclusão, mas quem recalcular
precisa saber qual referência usar. **Não é divergência entre nota e CSV: é diferença de
referência**, e as notas usam a referência que declaram.

Classificação: computar e reportar o perfil é **(b)** — o artigo não faz isso, e a escolha foi feita
aqui. O tratamento é conservador e está registrado: a leitura "só pico" (ρ = 0) **não foi
examinada**, e há regra explícita de que examiná-la agora, depois das figuras, deixa de ser
pré-declarada e tem de ser rotulada assim (`…inferencia…:268-269`, `…estimacao_theta…:297-299`).
Um ponto da grade, ρ = 0,28, sai com `convergence = 52` e teve o valor conferido por Nelder-Mead
(`…estimacao_theta…:283`); é o único dos 101.

## 4. Quadro-resumo

| caixa | contagem |
|---|---|
| (a) FIEL | 8 |
| (a★) fiel ao código, ausente no Apêndice B | 2 |
| (b) EXTRAPOLAÇÃO | 12 |
| (c) ENGENHARIA | 8 |
| **(d) DIVERGÊNCIA** | **0** |

**(a), nominalmente:** a regra da trajetória de `s_t`; a reescala `ỹ = y/s`, `X̃ = X/s`; (B1);
(B2); (B4) na forma `sigma_mle`; o objetivo da (B5); `t*` fixado por narrativa e a frequência
mensal; e o número e a alocação dos meses — três níveis livres mais decaimento geométrico.

**(c), nominalmente:** `j` por calendário em vez de índice de linha; a constante na última coluna da
estimação e na primeira da inferência; a (B3) nunca vetorizada; a constante gaussiana somada à (B5);
o divisor `T − p − pK − 1` de `factor_estimation.R:602`, sem consumidor; L-BFGS-B com `factr = 1e3`
no lugar do `csminwel` dos autores; a grade de 101 pontos do perfil em ρ
(`covid_volatility_theta.R:54`); e θ̂ reestimado dentro de cada script e conferido contra
`covid_volatility_theta.csv` a 1e-8 (`q_truncation.R:307-315`, `q_narrative_overlay_covid.R:66-67`).

**(a★), nominalmente** — os dois itens em que a regra veio do `.m` dos autores, que implementa o
ramo bayesiano, e não do Apêndice B, que é o ramo aqui:

1. **piso `s̄ ≥ 1`**, idêntico a `MIN.eta(1:3)` de `setpriors_covid.m:225-226`; ausente no Apêndice B,
   e com justificativa própria (sem ele a verossimilhança é ilimitada);
2. **valores iniciais** de `estimate_covid_theta()` (`factor_estimation.R:638-641`), transcrição da
   regra de `bvarGLP_covid.m:59-66` aplicada aos fatores, com ρ₀ = 0,8 — que também é a moda do
   hiperprior Beta do artigo (`LP.md:87`).

**(b), nominalmente:**

1. LP aplicado a **fatores estimados**: `ℓ(θ)` é condicional a `F̂`, que são regressores gerados.
2. **Extração estática não tratada**: `Λ̂` e `sy` saem do painel original (`factor_estimation.R:946`)
   e multiplicam toda IRF (`weak_iv_ar.R:653`).
3. A ***commonality*** passa a valer sobre `r = 5` inovações de fator, não sobre `n` observáveis.
4. **Teto de `s̄` = ∞** e **ρ ∈ [0,1] fechado**, contra `[1,500]` e `(0,005; 0,995)` aberto dos autores.
5. **Inferência AR/MOSW sob WLS**: o artigo não cobre weak-IV; a âncora é MOSW.
6. **θ̂ como conhecido na inferência**, sem correção, e sem o argumento de ordem menor disponível,
   porque θ̂ não é consistente.
7. **Perfil em ρ** computado e reportado — o artigo não o faz.
8. **A janela pré-COVID não aceita o tratamento** (`t*` tem de ser um mês dos resíduos,
   `factor_estimation.R:936-940`): toda comparação "cheia tratada × pré-COVID" é WLS contra OLS.
9. **`p` misto entre janelas**: a pré-COVID só tem AR em `p = 2`, herdado de 09-10.
10. A chave **`innovations`** (`"raw"` / `"standardized"`), que decide o que K, M e η leem — não
    existe no artigo, porque o artigo não tem esse passo.
11. **Nada é centrado sob WLS**, em H e em K — o artigo não discute centragem.
12. **`downweighted_months` = `Σ(1 − 1/s_t²)`**, régua própria do projeto. *Dúvida declarada:* não
    altera estimador, amostra nem distribuição, o que a qualificaria para (c); fica em (b) porque
    carrega peso interpretativo — é com ela que `…inferencia…:61-66` dimensiona o condicionamento em
    θ̂ ("cerca de 19 meses-equivalentes de 162"), e não há contraparte no artigo.

**Nenhum item em (d).** Cada desvio acima tem justificativa registrada — nas três notas de
2026-09-14, em `.claude/rules/identification.md:42-81`, ou em `registro/pendencias.md:150-168`.
Duas ressalvas sobre essa contagem, que é o único ponto em que ela pode enganar:

- **"Zero (d)" afirma que a justificativa existe e está escrita, não que ela esteja certa.** O item
  (b)6 é o exemplo: a propriedade está declarada em quatro lugares, e continua sendo uma lacuna
  aberta de teoria.
- O candidato mais forte a (d) foi testado e **caiu**: o divisor `T − p − pK − 1` de
  `factor_estimation.R:602` não é a (B4) e opera sobre os resíduos padronizados. Mas
  `$var_covariance` e `$var_sigma_mle` **não têm consumidor algum no repositório** — grep por ambos
  em todo o repo volta vazio. A alegação de `…lenza_primiceri…:218-220` ("nenhum consumidor a
  jusante lê `covariance_matrix`") se sustenta, e o objeto é peso morto, não estimador paralelo.

## 5. Não verificado

1. **Não há número de LP contra o que conferir θ̂.** Os autores nunca estimam pelo Apêndice B; a
   Figura 1 é posterior bayesiano sobre dados dos EUA (§3.1). Não é lacuna de execução: é ausência
   na fonte.
2. **O MATLAB dos autores não foi executado.** Os checks S3 e S8 transcrevem `invweights` e `eta0`
   **inline, em R**, dentro de `validate_covid_volatility.R:234-245` e `:353-363`. Conferi que as
   transcrições correspondem a `logMLVAR_formin_covid.m:35-39` e `bvarGLP_covid.m:59-66` lendo os
   dois arquivos — mas sem MATLAB ou Octave nesta máquina não há checagem bit a bit, e
   `codigos_externos/` é gitignored. Registro factual correlato: **não existe fixture COVID em
   `output/validation/`**, ao contrário de `amengual_watson_fixture.csv`; os checks N rodam sobre o
   painel de produção e os S sobre um VAR simulado.
3. **Otimalidade global de θ̂ não confirmada.** O perfil varre **só ρ**; não há multi-start nem
   varredura em `(s̄0, s̄1, s̄2)`. Os dois máximos locais conhecidos são os da grade em ρ. Um terceiro,
   fora dessa fatia, não está excluído por nada que eu tenha lido.
4. **O ponto ρ = 0,28 (`convergence = 52`)** teve o valor conferido por Nelder-Mead segundo
   `…estimacao_theta…:283`; não reexecutei essa checagem.
5. **Cobertura dos conjuntos AR sob θ̂ não consistente:** sem derivação e sem simulação no
   repositório, não dá para confirmar nem refutar o tamanho do custo. É o item (b)6.
6. **Quanto `Λ̂` e `sy` se moveriam sob extração tratada** (§3.2): exigiria reestimar, e esta rodada
   é documental por desenho.

**Duas ressalvas de precisão**, achadas na verificação e ambas factuais:

- **O segundo momento não centrado é inerte na forma de produção.**
  `factor_estimation.R:964-966` passa `sigma_u = crossprod(innovations)/nrow(innovations)` — que com
  inovações padronizadas é exatamente a (B4). Mas `estimate_dynamic_factors()` retorna cedo em
  `q == r`, com `K <- 1`, `M <- 1`, `eta <- var_residuals`, **sem tocar `sigma_u`** (`:791-796`; o
  default é preguiçoso e só é usado em `:800`). Em `q = r = 5`, que é a produção e a célula de
  referência `cheia_p4_lp`, a escolha não morde: ela só age nas células `q = 2, 3, 4` de
  `q_truncation.R` e `q_narrative_overlay_covid.R`. O comentário adjacente (`:959-960`) descreve um
  ramo que a célula de referência não executa.
- **Os banners das três notas de 09-14 estão desatualizados quanto à proveniência.**
  `…estimacao_theta…:8-9` e `…inferencia…:5-6` dizem "sem merge em `main`", e as três linhas da
  tabela de vintage de `notas/_indice.md:173-175` dizem "escrita sob … branch
  `feature/volatilidade-covid-lp`". O merge é `f858fe5`, de 2026-09-16. Não afeta número nenhum;
  afeta onde se procura o código.
