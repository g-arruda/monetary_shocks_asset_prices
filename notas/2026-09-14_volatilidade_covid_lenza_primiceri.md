# Volatilidade COVID de Lenza-Primiceri no VAR dos fatores: implementação

> **CURRENT — 2026-09-14. Rodada de implementação: nada foi estimado.**
> - **As decisões da §7.1 saíram no mesmo dia**, e θ foi estimado na rodada seguinte
>   (`notas/2026-09-14_estimacao_theta_volatilidade_covid.md`).
> - Ela supera três passagens desta nota:
>   - a centragem (§6, item 9): sob WLS, nem H nem K são mais centrados;
>   - a §7.2, pelo mesmo motivo;
>   - a frase "centrar z no lugar das inovações": dá o mesmo numerador.
> - branch `feature/volatilidade-covid-lp`, aberta de `main` em `e1d8a89`, commits `ed316ad` e `815350a`;
> - **produção inalterada:** com `covid_volatility = NULL`, que é o que `production_spec()` traz, o objeto inteiro de `main_sdfm()` sai `identical()` ao de `main` (modelo, IRF pontual e conjuntos AR de 68% e 90%), e o smoke test do `CLAUDE.md` sai bit-idêntico;
> - nenhum θ foi escolhido e nenhuma verossimilhança foi maximizada: os números desta nota só checam código;
> - painel de produção: 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, `z_jk_bs_purif` × `yield_6m`.

## 1. Por que a rodada existe

O passo 3/4 do e-mail do orientador de 2026-09-13 (`email/email_professor_13-09_10h45.md`) pede a
correção dos outliers de 2020 na linha de Lenza e Primiceri (2022, *JAE* 37(4), 688-699). A pergunta
é se a sensibilidade a `q` da amostra completa some quando as observações da pandemia recebem o peso
certo. Hoje ela contrasta com a robustez da janela pré-COVID (`notas/2026-09-10_truncamento_q.md`):
- na cheia, T1 rejeita com p de 0,051, 0,039 e 0,015;
- na pré-COVID com `p = 2`, as 115 séries saem imateriais em `q` = 3 e 4.

O autor pediu **só a implementação**, na versão frequentista do Apêndice B do artigo:
- sem procurar valores para θ;
- sem otimizar a verossimilhança;
- toda escolha que ele ainda não fez fica como argumento sem default ou como `stop()`, inclusive nos
  passos posteriores ao VAR que supõem variância constante.

**Isto não é identificação por heterocedasticidade.** Essa rota foi abandonada em 2026-08-17
(`registro/historico_decisoes.md` §1). O que se implementou é uma reponderação da *estimação* do VAR
dos fatores: mínimos quadrados ponderados, com uma escala de volatilidade cuja data é conhecida. A
identificação continua sendo só o proxy externo.

## 2. O modelo e onde cada peça mora

LP modificam o VAR com uma escala comum a todos os choques:

`F_t = c + A_1 F_{t-1} + … + A_p F_{t-p} + s_t ε_t`, com `ε_t ~ N(0, Σ)`.

Aqui `F_t` são os `r = 5` fatores estáticos estimados, então n = r. A trajetória de `s_t` é a da
eq. (1) do artigo:
- `s_t = 1` antes de `t*`;
- `s_{t*} = s̄0`, `s_{t*+1} = s̄1` e `s_{t*+2} = s̄2`;
- `s_{t*+j} = 1 + (s̄2 − 1) ρ^{j−2}` para j ≥ 2;
- θ = (s̄0, s̄1, s̄2, ρ).

| objeto do artigo | onde está | observação |
|---|---|---|
| trajetória `s_t` (eq. 1) | `covid_volatility_path(dates, covid_start, theta)`, `R/modeling/factor_estimation.R` | mesma regra de `invweights` em `logMLVAR_formin_covid.m:35-40`; `j` em meses de calendário |
| (B2) `B̂(θ) = (x̃'x̃)⁻¹x̃'ỹ` | `estimate_var_ols(data, p, s)` | regressores e regressandos divididos por `s_t` linha a linha, **constante incluída** (`x̃_t = [lags, 1]/s_t`); o mesmo `solve(crossprod())` do OLS |
| (B3) `β̂ = vec(B̂)` | `$coefficients` | disposição do OLS do projeto: lags nas primeiras linhas, constante na última |
| resíduos | `$residuals` (`u_t = y_t − B̂'x_t`) e `$residuals_standardized` (`u_t/s_t = ε̃_t`) | `u_t` são os erros de previsão; `ε̃_t` é que tem Σ constante |
| (B4) `Σ̂_mle = ε̃'ε̃/(T−p)` | `$sigma_mle` | divisor de máxima verossimilhança |
| (B5) verossimilhança concentrada | `$loglik` | `−(T−p)n/2·(1 + log 2π) − n Σ_t log s_t − (T−p)/2·log|Σ̂_mle|` |
| condicionamento nos p valores iniciais | construção de `RHS` | igual ao OLS de produção |

Com `s = NULL`, `estimate_var_ols()` é o OLS de sempre: o código desse ramo não mudou. O θ neutro
(s̄0 = s̄1 = s̄2 = 1) dá `s_t ≡ 1` para qualquer ρ em [0,1) e qualquer `t*`, porque `1 + 0·ρ^k = 1`.

**Uma avaliação de ℓ(θ) é barata.** A extração estática não depende de θ: nem o PCA nem `sy` mudaram.
Cada avaliação é um WLS em 162 × 21, e uma futura maximização só roda o VAR de novo. O trecho abaixo é
ilustrativo e nada o chama; `t_star`, a parametrização e o otimizador são decisões do autor.

```r
residual_dates <- dates[(p + 1):length(dates)]
loglik_at <- function(theta) {
  estimate_var_ols(F_hat, p, s = covid_volatility_path(residual_dates, t_star, theta))$loglik
}
```

## 3. O que mudou, arquivo por arquivo

### `R/modeling/factor_estimation.R`
- **`covid_volatility_path()`**, nova: monta `s_t` a partir de θ, sem default e sem limites.
- **`estimate_var_ols(data, p, s = NULL)`**: com `s`, estima por (B2) e devolve (B4) e (B5).
  - `covariance_matrix` mantém o divisor do projeto, `T − p − pK − 1`, agora sobre `ε̃`.
  - Nenhum consumidor a jusante lê esse campo.
- **`estimate_dfm(..., covid_volatility = NULL)`**: uma lista com três campos obrigatórios liga o
  tratamento.
  - `covid_start`: um mês dos resíduos.
  - `theta`: vetor nomeado com `s0`, `s1`, `s2` e `rho`.
  - `innovations`: `"raw"` para `u_t` ou `"standardized"` para `u_t/s_t`.

  A escala é calculada sobre `dates[(p+1):T]`. A chave `innovations` decide o que entra em
  `var_residuals` e em `estimate_dynamic_factors()`, e portanto em K, M, η e no H do proxy.

  O objeto ganha `covid_volatility`, `volatility_path`, `var_residuals_raw`,
  `var_residuals_standardized`, `var_sigma_mle` e `var_loglik`. Com o tratamento desligado, o objeto
  é o mesmo de antes, sem campos novos.

  Paradas:
  - campo ausente;
  - `innovations` fora de {`"raw"`, `"standardized"`};
  - `covid_start` fora dos meses dos resíduos (o que cobre também `dates = NULL`);
  - `apply_kilian = TRUE`.

### `R/modeling/impulse_response.R`
`compute_irf_dfm()` para quando há tratamento e o bootstrap roda (`inference = "bootstrap"` com
`nboot > 0`). O ramo pontual não mudou.

### `R/identification/weak_iv_ar.R`
`ar_dfm_bands()` para sob tratamento. Foi decisão do autor nesta rodada: AR com `stop()` por ora.

### `R/identification/factor_space_diagnostics.R`
`diagnose_instrument_in_factor_space()` para sob tratamento.

### `R/modeling/dfm_pipeline.R`
`main_sdfm(covid_volatility = spec$covid_volatility)` repassa a lista e pede Kilian só sem
tratamento (`apply_kilian = is.null(covid_volatility)`).

### `R/modeling/production_spec.R`
Campo `covid_volatility = NULL`: desligado, e as decisões seguem pendentes.

### Arquivos novos e documentação
- **`script/validate_covid_volatility.R`**: o validador (§5).
- **`.claude/rules/identification.md`**: ganhou um parágrafo sobre o tratamento.
- **`script/README.md`**: ganhou a linha do validador.

**Como ligar o tratamento, quando as decisões existirem.** Por enquanto só o ponto está disponível:

```r
covid_volatility <- list(
  covid_start = as.Date("AAAA-MM-01"),            # decisão do autor
  theta       = c(s0 = , s1 = , s2 = , rho = ),    # decisão do autor
  innovations = "raw"  # ou "standardized"         # decisão do autor
)
res <- main_sdfm(covid_volatility = covid_volatility,
                 inference = "bootstrap", nboot = 0)   # só ponto
res$model$var_loglik                                   # (B5) avaliada em θ
```

## 4. O que roda e o que para sob o tratamento

| etapa | sob tratamento | por quê |
|---|---|---|
| extração estática (BLL: `sy`, PCA em `cov(yy)`, remoção de tendência) | roda, **sem** tratamento | fora do escopo pedido ("no VAR dos fatores"); ver decisão 2 |
| VAR dos fatores | WLS (B2) | é o modelo |
| K, M e η (redução `q < r`) | roda sobre as inovações da chave | `cov()` supõe variância constante; a chave escolhe `u_t` ou `u_t/s_t` |
| identificação (`ident_ext_instr`) | roda, com o código intocado | H lê as inovações da chave; a centragem deixa de ser no-op (decisão 9) |
| IRF pontual | roda | companion WLS, Λ, K, M e `sy` |
| conjuntos AR (`ar_dfm_bands`) | `stop()` | o `Shat` de `mosw_rform_cov()` é a função de influência do OLS |
| ξ_mp (`diagnose_instrument_in_factor_space`) | `stop()` | a correção Shat residualiza z nos regressores do OLS |
| bootstrap selvagem | `stop()` | o DGP, o Kilian e a reestimação por réplica supõem OLS com Σ constante; a réplica chamaria `estimate_dfm()` sem tratamento |
| correção de Kilian | `stop()` em `estimate_dfm`; `main_sdfm` a pula | a fórmula de Pope usa Σ homocedástico e o OLS |
| diagnóstico impresso (`compute_irf_dfm(diagnose = TRUE)`) | roda | já era sem correção Shat; sob tratamento, lê as inovações da chave; não é estatística reportada |

Na prática, `main_sdfm()` com o tratamento e a inferência de produção (`"ar"`) aborta. O ponto sai com
`inference = "bootstrap", nboot = 0`, que já é a convenção do projeto para "sem bandas".

## 5. Validação

### 5.1 O validador

`script/validate_covid_volatility.R` roda em 3,4 s e é silencioso: só fala quando falha.

| bloco | o que checa | resultado |
|---|---|---|
| N1 | Painel de produção, θ neutro, cada um dos 162 meses de resíduo como `t*`, ρ ∈ {0; 0,5}, somando 324 células. Exige `s_t ≡ 1` e que coeficientes, resíduos, resíduos padronizados, companion e `covariance_matrix` saiam `identical()` ao OLS nos fatores de produção. | 324/324 |
| N2 | `main_sdfm()` com θ neutro em `(5,5)` e `(5,3)`, as duas chaves, `t*` no 1º, no 81º e no 162º mês de resíduo, somando 12 células. Exige `irf_point_matrix` `identical()` à produção desligada e os cinco impactos `identical()` aos literais do `CLAUDE.md`. | 12/12, literais batem |
| N3 | (B5) em θ neutro contra a log-verossimilhança gaussiana somada linha a linha, via `det()` e forma quadrática. | tolerância relativa 1e-10 |
| N4 | Cada `stop()` dispara com a própria mensagem: campo ausente, nome de θ ausente, `innovations` inválido, `t*` fora da amostra, `dates` nulo, Kilian, bootstrap, AR e ξ_mp. | 9/9 |
| S1 | VAR(2) simulado em 3 variáveis, T = 160, θ de teste (6; 11; 4; 0,7): (B2) contra `lm.wfit` com pesos `1/s_t²`. | tolerância 1e-10 |
| S2 | Mesmo VAR: (B5) contra (B1) somada linha a linha em `(B̂, Σ̂)`. Confere o jacobiano `−n log s_t` e a divisão da forma quadrática por `s_t²`. | tolerância relativa 1e-10 |
| S3 | A trajetória contra uma transcrição literal de `invweights`. | tolerância 1e-12 |
| S4 | `estimate_dfm()` num painel de 12 séries gerado pelo VAR simulado. Confere que `s_t` fica nos meses dos resíduos (depois dos p lags), que os coeficientes são (B2) sobre os fatores estáticos e que a chave leva `u_t` ou `u_t/s_t` para `var_residuals` e para η. | 6/6 |

O θ de teste (6; 11; 4; 0,7) e o `t*` na linha 110 do VAR simulado só conferem álgebra. Não
parametrizam nada e nunca tocaram o painel real, conforme a instrução do autor: fora do θ neutro,
só dados simulados.

### 5.2 O validador tem dentes: teste de mutação

O validador é silencioso, então era preciso mostrar que ele consegue falhar. Plantou-se um defeito por
vez numa cópia de trabalho, apontando o validador para ela. A cópia ficou no scratchpad e nada foi
commitado. Os nove mutantes foram pegos:

| mutante | quem pega |
|---|---|
| WLS dividindo por `s_t²` | S1 (desvio de 0,033 contra `lm.wfit`) |
| sinal do jacobiano trocado | S2 |
| `Σ̂_mle` sobre `u_t` em vez de `u_t/s_t` | S2 |
| trajetória com expoente `j − 1` | S3 (desvio de 0,9) |
| trajetória alinhada às datas antes dos p lags | N2 (o `t*` no último mês de resíduo sai da janela deslocada e aborta) |
| chave `innovations` ignorada | S4 |
| `stop()` do bootstrap removido | N4 |
| `stop()` do AR removido | N4 |
| `stop()` do ξ_mp removido | N4 |

Os quatro primeiros e o sexto são defeitos que o θ neutro sozinho não enxergaria.

### 5.3 Regressão da produção, com o tratamento desligado
- **`main` × branch.** As fontes R de `main` foram extraídas para o scratchpad, e a produção rodou sob
  cada versão. O objeto inteiro de `main_sdfm(r=5, q=5, p=4, nboot=0)` sai `identical()`, com ξ_den =
  6,057014271410632 nas duas: modelo com 27 campos, IRF pontual e conjuntos AR de 68% e 90%.
- **Smoke test do `CLAUDE.md`.** Bit-idêntico.
- **`script/validate_production_spec.R`.** Passa, sem mudar arquivo commitado.
- **`script/validate_mosw_ar.R`.** Passa.

### 5.4 O que não foi validado
- **O efeito sobre as IRFs do painel real.** Não foi medido, por instrução: medir exigiria escolher um θ.
- **O peso da chave `innovations` e da centragem.** As duas escolhas a jusante só fazem diferença com θ
  não neutro, então sua magnitude no painel é desconhecida. A S4 prova apenas que a chave está ligada.
- **A inferência sob tratamento.** Não existe; ver §7.

## 6. Decisões que não estão no artigo

Cada item diz o que foi feito e se é imposição do enquadramento ou decisão pendente do autor.

1. **LP aplicado a fatores estimados.** LP estimam um VAR de observáveis. Aqui os dados do VAR são os
   fatores `F̂` do PCA, então (B5) é a verossimilhança do VAR *condicional* a `F̂`, que são regressores
   gerados. O erro de estimação dos fatores não entra em ℓ(θ). *Imposição do escopo pedido.*
2. **Extração estática sem tratamento.** A padronização BLL (`sy`, desvio das primeiras diferenças), o
   PCA em `cov(yy)` e a remoção de tendência continuam usando momentos da amostra cheia, com os meses da
   pandemia pesando como qualquer outro. Em LP isso não existe. Ao fechar a §3, eles notam que modelos
   com variáveis latentes são sensíveis às volatilidades dos choques. *Escopo pedido; estender é
   decisão do autor (§7).*
3. **Divisores da covariância.** `covariance_matrix` mantém o divisor do projeto, `T − p − pK − 1`,
   agora sobre `u_t/s_t`, para que o θ neutro reproduza o OLS. (B4) e (B5) usam `T − p`, como no
   artigo. *Imposição de compatibilidade; nenhum consumidor a jusante lê `covariance_matrix`.*
4. **Constantes em (B5).** O artigo escreve (B5) a menos de proporcionalidade. O código inclui
   `−(T−p)n/2·(1 + log 2π)`, e assim o valor é a log-verossimilhança gaussiana completa em `(B̂, Σ̂)`,
   comparável entre valores de θ e com o VAR sem tratamento. O argmax não muda. *Escolha de
   implementação, reversível.*
5. **Alinhamento de `t*`.** `j` conta meses de calendário desde `covid_start` sobre os meses dos
   resíduos (`dates[(p+1):T]`, de 2012-07 a 2025-12), e `covid_start` precisa ser um desses meses.
   *O `Tcovid − lags` do MATLAB faz o mesmo.* Duas consequências:
   - a janela pré-COVID não aceita o tratamento, então a comparação "cheia ajustada × pré-COVID" será
     sempre a cheia tratada contra a pré-COVID por OLS;
   - um `t*` nos quatro primeiros meses do painel aborta.
6. **θ sem limites e sem checagem de `s_t > 0`.**
   - Os limites de `setpriors_covid.m` (s̄ ∈ [1, 500], ρ ∈ [0,005; 0,995]) pertencem ao otimizador
     bayesiano dos autores e não aparecem no Apêndice B.
   - Uma checagem de `s_t > 0` chegou a ser escrita e foi retirada pela convenção de código do projeto.
     Um `s_t` não positivo já falha alto: `log(s_t)` dá NaN em (B5), e `s_t = 0` quebra a divisão.
   - Atenção: (B2) só depende de `s_t²`, então um s̄ negativo daria os mesmos coeficientes que |s̄|, e
     só a verossimilhança acusaria.

   *Restringir θ é decisão do autor.*
7. **Só a parametrização de LP.** O artigo admite parametrizações alternativas. Como
   `estimate_var_ols(s=)` aceita qualquer trajetória positiva, outra parametrização pede só uma nova
   função de trajetória, sem mexer no VAR. *Implementada a do artigo.*
8. **Uma chave `innovations` para K, M e H.** Foi resposta do autor nesta rodada. Sob a hipótese de
   escala comum de LP, as duas opções miram o mesmo objeto na população:
   - os autovetores de `s_t²Σ` são os de Σ;
   - `E[z_t u_t]` e `E[z_t ε̃_t]` apontam na direção do choque;
   - a normalização pelo impacto em `yield_6m` descarta a escala, e M se cancela.

   Em amostra, muda o peso. Com `"raw"`, os meses da pandemia pesam ∝ `s_t²` em `cov(u)` e crescem com
   `s_t` em `Z'u`; quanto crescem depende de como o instrumento escala com o choque na pandemia. Com
   `"standardized"`, pesam como os outros meses. Combinações mistas, com K de uma chave e H da outra,
   não foram implementadas. *Qual usar é decisão do autor.*
9. **Centragem de `ident_ext_instr()` mantida.** Foi resposta do autor nesta rodada: manter e registrar.
   - Sob OLS com constante, os resíduos somam zero e a centragem é no-op.
   - Sob WLS, as equações normais dão `Σ_t u_t/s_t² = 0`, isto é, `Σ_t ε̃_t/s_t = 0`, e nem `u_t` nem
     `ε̃_t` somam zero. A centragem passa a atuar: `H = (Z'η − (Σ_t z_t) η̄)/Z'Z`.
   - O tamanho do efeito depende de θ e da soma do instrumento.

   *Decisão pendente.*
10. **Paradas a jusante.** AR, ξ_mp com correção Shat, bootstrap e Kilian dão `stop()` sob
    tratamento, e `main_sdfm()` não pede Kilian. O AR foi escolha do autor nesta rodada; os outros
    seguem a instrução geral. *Pendente de derivação (§7).*
11. **θ tratado como conhecido.** Tudo o que roda sob tratamento condiciona em θ. Se θ vier de (B5), o
    ponto condicionará em θ̂, como já condiciona em Λ̂, K̂, M̂ e `sy`. Nenhuma incerteza de θ se propaga.
    *Propriedade declarada.*
12. **Valores de teste.** No painel real, o θ neutro foi testado em todo `t*` e em ρ ∈ {0; 0,5}, o que
    mostra que `t*` e ρ não pesam sob neutralidade. Nenhum desses valores é escolha.

## 7. Próximos passos e o que falta

### 7.1 Decisões do autor, antes de qualquer número
1. **`t*` no painel brasileiro**: o primeiro mês de volatilidade anormal. LP usam março de 2020 para
   os EUA.
2. **θ: fixar ou estimar por (B5).** Se estimar, é preciso escolher o otimizador, a parametrização ou
   os limites e os valores iniciais.
   - Para referência, o código bayesiano de LP inicializa s̄0, s̄1 e s̄2 pela variação absoluta média
     entre as variáveis em cada um dos três primeiros meses desde `t*`, relativa à média anterior a
     `t*` (`bvarGLP_covid.m:60-68`), e ρ em 0,8.
   - Com `t*` em 2020-03, a amostra traz 70 meses de `t*` em diante, então ρ é identificado.
3. **A chave `innovations`**: `"raw"` ou `"standardized"`.
4. **A centragem** de `ident_ext_instr()` sob WLS.
5. **Estender ou não o tratamento à extração estática**, com `sy` e PCA ponderados por `s_t`. Nesse
   caso θ passa a mover os fatores, e ℓ(θ) deixa de ser só a do VAR.

### 7.2 O que falta implementar, conforme as decisões
6. **Inferência sob tratamento.** É o bloqueio principal do passo 3/4: derivar e validar o `Shat` de
   MOSW para o VAR por WLS. Esboço:
   - Com `innovations = "standardized"`, a regressão transformada `(x̃_t, ε̃_t)` é homocedástica e o
     estimador é o OLS dela. O candidato natural é `mosw_rform_cov(x̃, z, ε̃)`, com os momentos
     `x̃_t ⊗ ε̃_t`, `Q1 = x̃'x̃/T` e `Q2 = Z'x̃/T`.
   - A centragem precisa ser reconciliada: `ar_dfm_bands()` centra as inovações e testa `X'u = 0`, o
     que falha sob WLS. Centrar z no lugar das inovações é assintoticamente equivalente, porque
     `E[ε_t] = 0`.
   - Com `"raw"`, a função de influência mistura `Q̃1` de x̃ (para Â) com `Q2 = Z'X` (para Γ), e a
     derivação é nova.
   - Nos dois casos, validar em θ neutro contra o AR de produção, que deve bater a menos de ponto
     flutuante, e documentar que θ entra como conhecido.
7. **ξ_mp sob tratamento.** A mesma questão do `Shat`, em `diagnose_instrument_in_factor_space()`.
8. **Bootstrap e Kilian sob tratamento.** É menos urgente, porque o AR é a inferência operacional.
   - O wild bootstrap de Rademacher sobre `u_t` preserva o padrão de `s_t`, mas cada réplica teria de
     ser reestimada com o mesmo θ, ou reestimar θ.
   - A fórmula de Pope/Kilian supõe Σ homocedástico.
9. **Teste de volatilidade constante contra volatilidade COVID.** Um LR `2[ℓ(θ̂) − ℓ(θ neutro)]` não
   tem distribuição padrão. Sob a nula (s̄0 = s̄1 = s̄2 = 1), ρ não é identificado: é o problema de
   Davies. E se s̄ ≥ 1 for imposto, a nula fica na fronteira.

### 7.3 O passo 3/4 propriamente dito, e o 4/4
10. **Refazer T1 e T2 de `script/q_truncation.R` na amostra cheia tratada.** Hoje o script não aceita o
    tratamento sem mudanças, por três motivos:
    - a força vem de `diagnose_instrument_in_factor_space()`, que está barrada;
    - a referência `q = 5` de T2 usa bandas AR, também barradas;
    - T1 chama `compute_factor_space_wald()` com os lags dos fatores como controles, a mesma correção
      do OLS.

    Uma comparação só de pontos já é possível, com as ressalvas acima. As bandas dependem do item 6.
11. **Refazer a tabela `q = 2,…,5`, com `r = 5`, nas duas janelas.** É o passo 4/4 e vem depois do
    anterior.
12. **Paper.** Se o tratamento for adotado, o texto precisa de três coisas:
    - a seção de metodologia com a escala `s_t` no VAR dos fatores;
    - a ressalva de que a janela pré-COVID segue por OLS;
    - a distinção explícita em relação à identificação por heterocedasticidade abandonada.

### 7.4 Código e higiene
13. **A branch está sem commit.** Falta decidir commit e merge. `main` precisa continuar passando no
    smoke test, e passa.
14. **`AGENTS.md` não foi tocado**, porque a mudança não altera nenhum invariante. Se o tratamento
    entrar na produção, sincronizar `CLAUDE.md` e `AGENTS.md`.
