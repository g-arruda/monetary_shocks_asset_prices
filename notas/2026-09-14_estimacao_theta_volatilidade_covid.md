# Volatilidade COVID: decisões de parametrização e estimação de θ por máxima verossimilhança

> **CURRENT — 2026-09-14. θ foi estimado aqui; esta nota não calcula IRF tratada.**
> - **Os itens 9.1 a 9.3 saíram no mesmo dia**, em
>   `notas/2026-09-14_inferencia_volatilidade_covid_q.md`: a inferência AR e o ξ_mp sob o
>   tratamento, o passo 3/4 (célula `cheia_p4_lp` de `q_truncation.R`) e a perna da cheia tratada
>   da tabela `q = 2,…,5`. As IRFs tratadas estão lá.
> - Branch `feature/volatilidade-covid-lp`, sobre `815350a`; commitada em 2026-09-15 junto com a
>   rodada de inferência, sem merge em `main`.
> - As decisões são as da §7.1 de `notas/2026-09-14_volatilidade_covid_lenza_primiceri.md`. O
>   autor as tomou antes de qualquer resultado do passo 3/4, e a 7.1.5 ficou de fora por decisão
>   dele.
> - **A produção não muda.** `covid_volatility = NULL` continua valendo. O objeto inteiro de
>   `main_sdfm()` sai `identical()` ao de `main`, e o smoke test do `CLAUDE.md` sai bit-idêntico.
> - Painel de produção: 115 séries, 2012-03 a 2025-12, `(r, p) = (5, 4)`, 162 meses de resíduo.
>   θ̂ não depende de `q`.

## 1. O que a rodada faz

A rodada anterior implementou a escala comum `s_t` de Lenza e Primiceri (2022, *JAE* 37(4),
688-699) no VAR dos fatores e deixou todas as escolhas de parametrização com o autor. Nesta, o
autor decidiu quatro delas: o `t*`, a forma de estimar θ, a chave `innovations` e a centragem. A
quinta, estender o tratamento à extração estática, ficou de fora. θ foi estimado pela via
frequentista do Apêndice B: maximizar a verossimilhança concentrada (B5).

LP estimam θ pela via bayesiana, maximizando a posterior dos hiperparâmetros e depois rodando MCMC
(`bvarGLP_covid.m`, `logMLVAR_formin_covid.m`). O prior deles resolve em silêncio três problemas
que a versão frequentista precisa enfrentar às claras (§3).

**Por que ainda não há IRF tratada.** `innovations` e a centragem foram decididas pela teoria, antes
de qualquer resposta tratada. Assim, a reavaliação da sensibilidade a `q` (passo 3/4) não escolheu
a especificação depois de ver o resultado. A reavaliação fica para a próxima rodada e depende da
inferência sob tratamento (§9).

## 2. As decisões

| item | decisão do autor | por quê |
|---|---|---|
| 7.1.1 `t*` | **2020-03** | É o mês de LP para os EUA. No painel, fevereiro de 2020 é normal e março não (tabela abaixo). |
| 7.1.2 θ | **Máxima verossimilhança (B5), com s̄0, s̄1, s̄2 ≥ 1 e ρ ∈ [0, 1]** | O piso é o que faz o máximo existir (§3.1). ρ = 1 admite volatilidade permanentemente mais alta, e ρ = 0 admite um pico de três meses. |
| otimizador | **L-BFGS-B (`optim`, base R), `factr = 1e3`**; início pela regra de LP (`bvarGLP_covid.m:60-68`) aplicada aos fatores, com ρ0 = 0,8 e projeção na caixa | Com o `factr` padrão, 1e7, a condição de primeira ordem de s̄0 fechava só a 1e-3 nos dados simulados; com 1e3, fecha a 1e-7 (§7). |
| 7.1.3 `innovations` | **`"standardized"`** (`u_t/s_t`) | K e M passam a ler a covariância de máxima verossimilhança de Σ. A pandemia deixa de dominar a escolha das direções quando `q < r`, e esse é o mecanismo que o passo 3/4 testa. A inferência de §9 vira MOSW na regressão transformada. |
| 7.1.4 centragem | **Nenhuma sob WLS, nem em H nem em K** | É o Γ de MOSW e segue AK no espírito (§5). |
| 7.1.5 extração estática | **Não estendida** | Decisão do autor. `sy` e a PCA continuam na amostra cheia, com os meses da pandemia pesando como os outros; a ressalva 2 da nota anterior segue valendo. |

**A evidência para `t*`.** A tabela usa o tamanho de Mahalanobis por dimensão dos resíduos OLS do
VAR dos fatores, `u_t'Σ̂⁻¹u_t/5`, com Σ̂ = u'u/(T−p). A mediana antes de 2020-03 é 0,51.

| mês | 2020-01 | 2020-02 | **2020-03** | **2020-04** | 2020-05 | 2020-06 |
|---|---|---|---|---|---|---|
| Mahalanobis OLS | 1,80 | 1,04 | **10,90** | **10,23** | 0,83 | 0,60 |

Olhar essa tabela não usa θ: é a regra de LP, "o primeiro mês de variação anormal", aplicada aos
dados. Com `t*` = 2020-03 ficam 70 meses de `t*` em diante e 92 antes.

## 3. O problema frequentista

### 3.1 Sem piso, não há máximo

Um s̄k que tende a zero dá peso infinito ao mês que ele governa sozinho. O WLS passa então a ajustar
esse mês exatamente:
- o resíduo bruto cai como `s̄k²`;
- o resíduo padronizado cai como `s̄k`;
- Σ̂ converge para a de uma amostra sem aquele mês.

O jacobiano `−n log s̄k`, porém, cresce sem limite. Logo, **(B5) é ilimitada acima**, e o estimador
de máxima verossimilhança sem restrição não existe.

Nos dados simulados do validador (S6), ℓ sobe 13,812 entre s̄0 = 1e-3 e 1e-5, contra
`n·log 100` = 13,816. O teste de mutação reproduziu o mesmo fato do outro lado: com o piso
removido, o L-BFGS-B corre para s̄ → 0 até (B5) deixar de ser finita e aborta
("L-BFGS-B needs finite values of 'fn'").

**LP não enfrentam isso porque o prior faz o trabalho.** O Pareto(1,1) em cada s̄ tem suporte em
[1, ∞), e o otimizador deles tem `MIN.eta = 1` (`setpriors_covid.m:225`). Na versão frequentista o
piso tem de ser imposto como restrição do espaço de parâmetros. É a hipótese do modelo: a pandemia
*aumentou* a volatilidade.

### 3.2 Cada s̄ de um mês só é o tamanho daquele resíduo

Pelo teorema do envelope, a derivada de ℓ em `s_t` é `(ε̃_t'Σ̂⁻¹ε̃_t − n)/s_t`. Para s̄0 e s̄1, que
governam um mês cada, o máximo interior satisfaz:

`s̄k² = û_t'Σ̂⁻¹û_t / n` no mês correspondente.

Isto é, s̄k é o tamanho de Mahalanobis do resíduo daquele mês, medido na Σ̂ dos tempos normais. No
painel, as duas condições fecham com erro de 1,4e-5 e 3e-6 (`mahal_wls = 1` em 2020-03 e 2020-04,
em `covid_volatility_path.csv`). Com piso ativo, a condição vira `≤ n`.

### 3.3 θ não é consistente, e B̂ não precisa que seja

- **s̄0 e s̄1 dependem de uma observação cada.** A informação sobre eles não cresce com T. Com
  (B, Σ) conhecidos e erros gaussianos, `n ŝk²/s̄k² ~ χ²_n`, e com n = 5 isso dá um fator de 0,67 a
  2,09 no intervalo de 90%. Como ordem de grandeza, e não como inferência reportada: s̄0 fica entre
  4,4 e 13,8, e s̄1 entre 8,4 e 26,1.
- **s̄2 e ρ dependem dos meses em que `s_t` fica visivelmente acima de 1**, uns `1/(1−ρ)`, um número
  que também não cresce com T.

Por isso a rodada **não reporta erro-padrão por Hessiana**: a teoria assintótica que o justificaria
não se aplica. Uma consequência tranquiliza. Com o evento fixo no tempo e T → ∞, os meses da pandemia
viram uma fração que some, e o WLS com *qualquer* peso é consistente para B. O erro em θ custa
eficiência, não consistência. O argumento de LP é de amostra finita, e a pergunta do passo 3/4
também. A jusante, θ̂ entra como conhecido, do mesmo modo que Λ̂, K̂, M̂ e `sy`.

### 3.4 ρ, Davies e o LR

- **ρ só é identificado com s̄2 > 1.** Aqui ŝ2 = 1,76, então ρ é identificado.
- **O perfil de ℓ em ρ tem dois máximos** (§4): o global em ρ ≈ 0,944 e um local na fronteira ρ = 0,
  2,62 log-pontos abaixo. Os dados admitem duas leituras:
  - volatilidade excedente persistente, com meia-vida de 12 meses;
  - um pico em março, abril e maio, e mais nada.

  A persistente vence por 2,62 log-pontos. Nenhuma distribuição de referência foi calculada para essa
  diferença.
- **O LR contra o θ neutro é 2·(ℓ̂ − ℓ₀) = 223,9.** Ele não tem distribuição padrão, por dois
  motivos:
  - sob a nula, ρ não é identificado (problema de Davies);
  - com s̄ ≥ 1, a nula fica na fronteira.

  O número fica como descritivo. O teste formal é o item 9 da nota anterior.

### 3.5 O que o prior de LP fazia e o frequentista não faz

A moda a posteriori de LP soma à verossimilhança marginal três termos
(`logMLVAR_formin_covid.m:163-164`):
- `−2 log s̄`, para cada s̄;
- o log de uma Beta com moda 0,8 e desvio-padrão 0,2, para ρ.

O primeiro termo puxa os s̄ para baixo. O segundo regulariza ρ quando s̄2 ≈ 1 e pesa contra os extremos
ρ = 0 e ρ = 1. A versão frequentista não tem nenhum desses puxões. O que ela tem é o piso, o perfil
e o aviso de Davies. Para comparação, a posterior de LP para ρ nos EUA fica "logo abaixo de 0,8".

## 4. A estimativa

`Rscript script/covid_volatility_theta.R` roda em cerca de 4 segundos e escreve
`output/factors/covid_volatility_{theta,path,profile_rho}.csv`.

| | s̄0 (2020-03) | s̄1 (2020-04) | s̄2 (2020-05) | ρ |
|---|---|---|---|---|
| **θ̂** | **6,611** | **12,468** | **1,760** | **0,9439** |
| início (regra de LP nos fatores) | 5,777 | 7,923 | 3,923 | 0,8 |

- **Verossimilhança:** ℓ(θ̂) = −1579,591 contra ℓ(neutro) = −1691,542, o que dá LR = 223,9 (§3.4).
  O código de convergência é 0.
- **Meses-equivalentes que perdem peso:** `Σ(1 − 1/s_t²)` = 19,1. Março e abril de 2020 respondem
  por 1,97 disso; a cauda de ρ responde pelo resto.
  - A amostra tratada **não** é a cheia menos três meses. Ela repondera 2020-2022 inteiro.
  - `s_t` fica acima de 1,5 em 10 meses e acima de 1,05 em 50.
  - A meia-vida de `s_t − 1` é de 12,0 meses.

| mês | `s_t` | peso `1/s_t²` | Mahalanobis OLS | Mahalanobis WLS em θ̂ |
|---|---|---|---|---|
| 2020-02 | 1,000 | 1,000 | 1,04 | 1,61 |
| 2020-03 | 6,611 | 0,023 | 10,90 | 1,00 |
| 2020-04 | 12,468 | 0,006 | 10,23 | 1,00 |
| 2020-05 | 1,760 | 0,323 | 0,83 | 1,36 |
| 2020-12 | 1,508 | 0,440 | 3,34 | 1,42 |
| 2021-01 | 1,479 | 0,457 | 2,89 | 2,06 |
| 2022-01 | 1,240 | 0,651 | 1,72 | 1,53 |
| 2023-01 | 1,120 | 0,797 | 0,63 | 1,14 |
| 2025-12 | 1,016 | 0,969 | 0,78 | 0,63 |

**Perfil de ℓ em ρ.** Para cada ρ, (s̄0, s̄1, s̄2) são re-maximizados. A tabela mostra a distância ao
máximo livre.

| ρ | 0 | 0,1 | 0,3 | 0,5 | 0,6 | 0,8 | 0,9 | **0,94** | 0,95 | 0,97 | 0,99 | 1 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ℓ − ℓ̂ | −2,62 | −3,42 | −4,44 | −5,19 | −5,11 | −3,32 | −0,93 | **−0,01** | −0,03 | −0,76 | −2,65 | −3,78 |
| ŝ2 | 4,64 | 4,06 | 3,65 | 3,64 | 4,04 | 3,29 | 2,30 | 1,81 | 1,68 | 1,42 | 1,19 | 1,10 |

- ŝ0 e ŝ1 quase não se movem ao longo do perfil: de 6,22 a 6,61 e de 11,8 a 12,7.
- ρ só troca o peso de s̄2 contra a cauda.
- **A convergência tem um ponto a registrar.** No ponto ρ = 0,28 o L-BFGS-B devolveu o código 52
  (`ABNORMAL_TERMINATION_IN_LNSRCH`). O valor coincide até 1e-8 com o do Nelder-Mead, então o ponto
  está no máximo; o CSV guarda o código. Os outros 100 pontos convergem.

**Ficam de fora outros meses anormais.** Sob θ̂, os maiores resíduos padronizados já não são da
pandemia. LP tratam só o episódio COVID, e esses meses seguem com peso cheio:

| mês | Mahalanobis WLS | Mahalanobis OLS | observação |
|---|---|---|---|
| 2016-01 | 8,01 | 4,66 | |
| 2018-05 | 5,67 | 3,39 | coincide com a greve dos caminhoneiros |
| 2015-04 | 3,82 | 3,44 | |
| 2021-10 | 3,65 | 4,51 | aqui `s_t` = 1,29 |

## 5. Centragem: por que nada é centrado sob WLS

O autor pediu identificação e IRF o mais fiéis possível a MOSW e a Alessi-Kerssenfischer. O que os
códigos-fonte dizem:
- **AK, `IdentExtInstr.m:5-6`:** `rsh_mean0 = rsh - mean(rsh); H = (Z\rsh_mean0)'`. Centra η e não
  centra z. O K também centra: `eigs(cov(u))`, em `DFMest_BLL.m:57`.
- **MOSW, `SVARIV.m:128`:** `Gamma = eta*Z/T`, sem centrar nada.
- **Hoje as três fórmulas coincidem bit a bit.** O VAR de AK, o de MOSW e o do projeto têm constante
  (`DFMest_BLL.m:35`, `RForm_VAR.m`), e os resíduos OLS somam zero.
- **A centragem de AK tem uma função que não se aplica aqui.** Quando o instrumento cobre só uma
  subamostra, os resíduos selecionados não somam zero. Neste painel o instrumento cobre os 162 meses.

**Sob WLS as fórmulas se separam.** As equações normais incluem a constante transformada `1/s_t`, e
então `Σ_t ε̃_t/s_t = 0` exatamente. A média simples de ε̃ fica igual a
`T⁻¹ Σ_t ε̃_t (1 − 1/s_t)`, e só os meses com `s_t > 1` entram nela. Centrar devolveria ao numerador
de H o termo `z̄ · Σ_t ε̃_t (1 − 1/s_t)`, feito só de meses da pandemia; em K, o mesmo termo de posto
um.

**O que se escolheu.** Não centrar é, ao pé da letra, o Γ de MOSW aplicado aos dados transformados
de LP, que é a receita deles: estimar com (ỹ, x̃) "pelo método preferido". Também é o que a linha de
AK faz no caso dela. Centrar é projetar os resíduos no termo determinístico da regressão; na
regressão transformada esse termo é `1/s_t`, e ε̃ já é ortogonal a ele. A projeção de AK vira no-op,
como no OLS.

O que se perde é a identidade literal com uma linha de AK que, neste painel, não faz nada. Nas duas
opções a diferença some assintoticamente, porque com o decaimento ρ só um número finito de meses tem
`s_t > 1`. A forma da IRF de AK, `rawimp × H` normalizada no impacto, não muda.

**Correção à nota anterior (§7.2).** Ela chamava "centrar z no lugar das inovações" de alternativa
assintoticamente equivalente. Na verdade é **numericamente idêntico**:
`Z'(η − 1η̄') = Z'η − (1'Z)η̄' = (Z − 1z̄)'η`. As duas escolhas reais são centrar e não centrar.

## 6. O que mudou no código

- **`R/modeling/factor_estimation.R`**
  - `estimate_covid_theta(factors, p, residual_dates, covid_start, lower, upper)`, nova. Os limites
    não têm default.
  - `estimate_dynamic_factors(..., sigma_u = cov(var_residuals))`. O default é a expressão de antes.
  - `estimate_dfm` passa, sob tratamento, `sigma_u = crossprod(innovations)/nrow(innovations)`. Com
    `"standardized"`, isso é a (B4).
- **`R/modeling/impulse_response.R`**
  - `ident_ext_instr(..., center = TRUE)`. O ramo TRUE fica byte a byte o de antes.
  - `compute_irf_dfm` passa `center = is.null(dfm_results$covid_volatility)`.
  - `ar_dfm_bands()` continua parado sob tratamento. Quando for derivado, terá de espelhar
    `center = FALSE`.
- **`R/modeling/production_spec.R`.** `covid_volatility` continua NULL. Entra
  `covid_volatility_design`, com `covid_start`, `theta_lower`, `theta_upper` e `innovations`.
- **Arquivo novo:** `script/covid_volatility_theta.R`, linear e silencioso. Ele para em dois casos:
  - a condição de primeira ordem de s̄0 ou s̄1 não fecha a 1e-4 no interior;
  - o perfil em ρ passa do máximo livre.
- **Validador e documentação:** `script/validate_covid_volatility.R`, `script/README.md` e
  `.claude/rules/identification.md`.

## 7. Validação

**Checks novos ou alterados em `script/validate_covid_volatility.R`** (4,5 s, silencioso):

| bloco | o que checa |
|---|---|
| N2 | Com θ neutro, a IRF pontual tratada bate com a produção com tolerância relativa de 1e-12, e não mais `identical()`, porque o ramo tratado não centra. Desvio medido: 1,7e-15 em `q = 5` e 5,8e-16 em `q = 3`. O ponto de produção continua `identical()` aos literais do `CLAUDE.md`. |
| S4 | K do ramo `"standardized"` sai de `sigma_mle`, a (B4). |
| S5 | `estimate_covid_theta` no VAR simulado. Exige: convergência; condição de primeira ordem de s̄0 e s̄1 a 1e-4; ℓ(θ̂) ≥ ℓ(θ verdadeiro); ℓ(θ̂) acima do perfil em ρ numa grade de 0,05; e que um piso s̄0 ≥ 20, posto acima do ótimo, prenda exatamente. |
| S6 | ℓ(s̄0 = 1e-5) − ℓ(s̄0 = 1e-3) = `n·log 100`, a 1e-3. É a razão do piso. |
| S7 | Com instrumento simulado de média 1, a IRF pontual tratada de `compute_irf_dfm` é igual a `diag(sy) Λ B_h K M H`, montada à mão com H não centrado. A versão centrada seria diferente. |
| S8 | O início bate a 1e-12 com uma transcrição literal de `bvarGLP_covid.m:60-68`. |

**Teste de mutação**, feito em cópias no scratchpad, nada commitado:

| mutante | quem pega |
|---|---|
| `center` ignorado (TRUE sob tratamento) | S7 |
| K por `cov()` sob tratamento | S4 |
| início deslocado um mês | S8 (desvio de 4,08) |
| piso removido (`lower = 0`) | S5: o `optim` aborta com (B5) não finita, que é a própria ilimitação |

**Regressão da produção:**
- **Smoke test do `CLAUDE.md`:** bit-idêntico.
- **`main` × branch:** o objeto inteiro de `main_sdfm(r=5, q=5, p=4, nboot=0)`, com os conjuntos AR,
  sai `identical()` com as fontes de `main`.
- **`validate_production_spec.R` e `validate_mosw_ar.R`:** passam.

## 8. Decisões que não estão no artigo

1. **`t*` por calendário, com uma olhada descritiva nos resíduos OLS.** LP fixam `t*` pela narrativa.
2. **O espaço de θ é [1, ∞)³ × [0, 1].** A caixa do otimizador de LP, [1, 500]³ × [0,005; 0,995]
   com transformação logística, vem do prior. Aqui ρ = 0 e ρ = 1 são admitidos, e não há teto em s̄.
3. **O otimizador é o L-BFGS-B com `factr = 1e3`,** no lugar do `csminwel` de LP. O início segue a
   regra deles aplicada aos fatores, que são o `y` deste VAR. A projeção na caixa não existe no código
   deles; ali, um `aux < 1` daria NaN no logit.
4. **Não há erro-padrão para θ** (§3.3). O perfil em ρ é reportado, e o LR contra o neutro é só
   descritivo.
5. **`innovations = "standardized"`.**
6. **Sob WLS nada é centrado, em H e em K** (§5). No OLS, a centragem de AK fica, como no-op.
7. **A extração estática não foi estendida.**
8. **θ̂ depende de `(r, p, janela)` e não de `q`,** então é um só para a tabela `q = 2,…,5`. θ̂ entra
   a jusante como conhecido.
9. **O ponto ρ = 0,28 do perfil saiu com código 52,** com o valor conferido pelo Nelder-Mead (§4).

## 9. Próximos passos

1. **Inferência sob tratamento**, o item aberto em `registro/pendencias.md`, agora desbloqueado.
   - O alvo é `CovAhat_Sigmahat_Gamma.m` sobre `(x̃_t, z_t, ε̃_t)`, com Γ não centrado e
     `ar_dfm_bands()` espelhando `center = FALSE`.
   - Validação em θ neutro contra o AR de produção. Deve bater a menos de ponto flutuante, e não bit a
     bit, pela centragem.
   - O `hac_dim` não muda.
   - O ξ_mp de `diagnose_instrument_in_factor_space()` segue a mesma derivação.
2. **Passo 3/4:** refazer T1 e T2 de `script/q_truncation.R` na amostra cheia tratada, com θ̂. Ter
   em mente que a amostra tratada repondera cerca de 19 meses-equivalentes, e não três.
3. **Passo 4/4:** a tabela `q = 2,…,5` nas duas janelas.
4. **Sensibilidade ao máximo local ρ = 0?** O perfil admite a leitura "só pico". Rodar o passo 3/4
   também nela seria uma sensibilidade declarada, e não uma escolha. A decisão é do autor, e só vale
   se tomada antes de ver o resultado.
5. **Outros meses anormais** (2016-01, 2018-05). O tratamento de LP não os cobre. Se a sensibilidade
   a `q` sobreviver ao tratamento, são os próximos suspeitos.
6. **Teste de volatilidade constante:** um bootstrap paramétrico do LR sob a nula resolveria Davies e
   a fronteira de uma vez. É opcional.
7. **Paper e commit.** O texto de metodologia só entra se o tratamento for adotado. Commit e merge
   ficam com o autor.
