# Volatilidade COVID: inferência AR sob WLS e a sensibilidade a `q` na amostra cheia ajustada

> **CURRENT — 2026-09-14. Itens 9.1 a 9.3 de `notas/2026-09-14_estimacao_theta_volatilidade_covid.md`.
> Sem veredito: o autor lê as IRFs a olho.**
> - Branch `feature/volatilidade-covid-lp`, sobre `815350a`; commitada em 2026-09-15, sem merge em
>   `main`.
> - **A produção não muda.** `covid_volatility = NULL` continua valendo. Estes objetos saem
>   `identical()` aos das fontes de `main`:
>   - o objeto inteiro de `main_sdfm()`;
>   - `diagnose_instrument_in_factor_space()` em `(5,5)`, em `(5,3)` e na pré-COVID com `p = 2`;
>   - `run_stage2_cell()` em `(5,5)`, com AR, e em `(5,3)`.
>
>   O smoke test do `CLAUDE.md` sai bit-idêntico.
> - Painel de produção: 115 séries, 2012-03 a 2025-12, `(r, p) = (5, 4)`. θ̂ = (6,611; 12,468;
>   1,760; 0,9439) é o de `script/covid_volatility_theta.R`.
> - **Fora do escopo:**
>   - a sensibilidade em ρ = 0 (item 9.4 da nota de θ);
>   - o bootstrap e o Kilian sob tratamento;
>   - a adoção do tratamento na produção.

## 1. O que a rodada faz

A rodada anterior estimou θ, mas sob o tratamento só o ponto rodava. `ar_dfm_bands()` e
`diagnose_instrument_in_factor_space()` davam `stop()`, e com isso ficavam bloqueados os passos 3/4
e 4/4 do e-mail do orientador de 2026-09-13. Esta rodada faz três coisas:

1. **9.1:** deriva e implementa os conjuntos Anderson-Rubin e o ξ_mp sob o VAR dos fatores por
   mínimos quadrados ponderados (§2).
2. **9.2, passo 3/4:** refaz T1 e T2 de `script/q_truncation.R` numa quarta janela-célula,
   `cheia_p4_lp`, que é a cheia com a escala de Lenza-Primiceri (§4).
3. **9.3, passo 4/4:** refaz a tabela `q = 2,…,5` das 20 variáveis da narrativa na cheia tratada.
   O script novo é `script/q_narrative_overlay_covid.R` (§5).

**O autor decidiu ler as IRFs a olho** (2026-09-14). Nenhuma regra de leitura foi fixada para a
célula tratada, e esta nota só descreve números e figuras. A leitura conjunta de 09-10
("inofensivo antes da COVID, distorce depois") vale para as três células sem tratamento e continua
"sustentada".

## 2. A inferência sob o tratamento (9.1)

### 2.1 A derivação

**O estimador.** Com `innovations = "standardized"`, a (B2) de LP é o OLS da regressão
transformada `ỹ_t = B'x̃_t + ε_t`, com `x̃_t = (1, lags_t)'/s_t` e `ỹ_t = y_t/s_t`. Dado θ, o erro de
estimação é exatamente linear: `B̂ − B = (X̃'X̃)⁻¹X̃'E`.

**O momento de Γ.** Γ̂ = Z'Ê/T, não centrado. Como `Ê = E − X̃(B̂ − B)`,

`Γ̂ − Γ = T⁻¹Σ_t (z_t ε_t − Γ) − (Q2 Q1⁻¹ ⊗ I_n) T⁻¹Σ_t (x̃_t ⊗ ε_t)`, com `Q1 = X̃'X̃/T` e `Q2 = Z'X̃/T`.

**É a fórmula de MOSW.** Isso é `CovAhat_Sigmahat_Gamma.m:72-78` ao pé da letra, com X → X̃ e η → Ê':
- a constante transformada `1/s_t` entra na primeira coluna, como a constante de `RForm_VAR.m:40`;
- `T⁻¹Σ x̃_t ⊗ ε̂_t = 0` exatamente, pelas equações normais do WLS;
- Σ̂ = Ê'Ê/T é a (B4), com o divisor de `RForm_VAR.m:65`;
- Γ não é centrado, como em `SVARIV.m:128`.

`mosw_rform_cov()` é chamada sem mudança; muda só o que entra nela. É a receita de LP (estimar em
(ỹ, x̃) "pelo método preferido") com a covariância de MOSW nesses dados.

**O que decorre disso:**
- **θ̂ entra como conhecido.** Os conjuntos condicionam em θ̂ do mesmo modo que em Λ̂, K̂ e `sy`, e a
  incerteza de θ não se propaga.
  - Com ρ < 1, os meses com `s_t > 1` são uma fração que some quando T cresce, e a distribuição
    assintótica não depende de θ̂.
  - A condicionalidade é, então, uma propriedade de amostra finita. Aqui ela não é pequena:
    cerca de 19 meses-equivalentes de 162 são reponderados.
- **`hac_dim` = 135 < 162 e `par_dim` = 120 não mudam**, e o conjunto continua limitado se e só se
  ξ_mp > κ.
- **`"raw"` não foi derivado.** Sob `"raw"`, Γ̂ lê `u_t = s_t ε_t` e a correção de B̂ entra por
  `x_t`, enquanto Â vem de `x̃_t`. A função de influência mistura as duas e segue em `stop()`; o autor
  escolheu `"standardized"`.
- **O ξ_mp** de `diagnose_instrument_in_factor_space()` residualiza z em x̃, que é a correção Shat
  da regressão transformada.
  - Como x̃ já carrega `1/s_t`, não se acrescenta constante:
    `compute_factor_space_wald(intercept = FALSE)`.
  - Uma constante a mais projetaria z também em 1, a que ε̃ não é ortogonal sob WLS, e mudaria Γ. O
    teste de mutação mostra isso (§2.3).
- **Nada é centrado**, como em `ident_ext_instr(center = FALSE)`. A guarda de ortogonalidade de
  `ar_dfm_bands()` passa a provar `X̃'Ê = 0`.

### 2.2 Código

- **`R/identification/weak_iv_ar.R`, `ar_dfm_bands()`.**
  - A parada fica só para `"raw"`.
  - Sob tratamento, `X_reg <- cbind(1, lags) / volatility_path`.
  - `u_sel` só é centrado sem tratamento.
- **`R/modeling/impulse_response.R`.**
  - `compute_factor_space_wald(..., intercept = TRUE)` e
    `compute_robust_first_stage_F(..., intercept = TRUE)`: com FALSE, a regressão usa só os
    controles.
  - Roxygen de `compute_irf_dfm()` atualizado.
- **`R/identification/factor_space_diagnostics.R`, `diagnose_instrument_in_factor_space()`.**
  - A parada fica só para `"raw"`.
  - H sai não centrado; `ctrl_sel = (1, lags)/s_t`, com `intercept = FALSE` nas duas estatísticas.
  - `moment_inputs` ganha `intercept`, que vale TRUE na produção.
- **`R/identification/spec_sweep.R`.** `run_stage2_cell(..., covid_volatility = NULL)` repassa a
  lista e pula o Kilian quando ela vem.

Os argumentos novos têm por default o comportamento de antes, e a produção sai bit-idêntica (§3).

### 2.3 Validação

**Checks novos ou alterados em `script/validate_covid_volatility.R`** (cerca de 5 s, silencioso):

| bloco | o que checa | medido |
|---|---|---|
| N4 | As paradas de AR e ξ_mp disparam só com `"raw"`. | — |
| N5 | Painel de produção, θ neutro, `"standardized"`: conjuntos AR 68/90 de `main_sdfm()`, `set_type`, `xi_den`; `diagnose_…()` em `(5,5)` e `(5,3)`, com `wald_mp`, `f_robust_mp` e `impact_mp`, contra a produção. Tolerância relativa de 1e-10. | Limites: 9,0e-14 a 68% e 1,5e-13 a 90%. `xi_den` 6,057014271410615 contra 6,057014271410632. `diagnose`: 1,6e-15 e 1,1e-15. Conjuntos: 5634 intervalos e o singleton. |
| S9 | Linearização exata no VAR simulado, com as inovações verdadeiras: `vec(Â − A)` e Γ̂ contra as somas de influência de MOSW em (x̃, z, ε). | 1,1e-15 e 9,7e-17. Com x sem transformar, o desvio de A é de 0,070. |
| S10 | DFM simulado (q = 2 < r = 3): `ar_dfm_bands()` e `compute_irf_dfm(inference = "ar")` contra `mosw_ar_bounds(mosw_rform_cov(…))` montado à mão; o ξ_mp pelas duas rotas; o H não centrado. | Conjuntos bit-idênticos. ξ: 7,798246358208707 contra 7,798246358208716. H: 3,5e-18. |

S9 é o que prova a derivação: a identidade vale para o estimador tratado e falha com x no lugar de x̃.
S10 prova que o código alimenta MOSW com essa derivação. `validate_mosw_ar.R` já prova que
`mosw_rform_cov()` reproduz o MATLAB dos autores.

**Teste de mutação**, em cópias no scratchpad, nada commitado:

| mutante | quem pega |
|---|---|
| X no lugar de X̃ em `ar_dfm_bands()` | a guarda de ortogonalidade da própria função, dentro de S10 (máx. \|X'u\| = 19,4) |
| ε̃ centrado em `ar_dfm_bands()` | a mesma guarda, dentro de S10 (2,51) |
| `intercept` ignorado no `diagnose` | S10, `xi_two_routes` |
| constante forçada em `compute_factor_space_wald()` | S10, `xi_two_routes` |
| H centrado no `diagnose` | S10, `H_uncentered` |
| T1 com `cov()` na célula tratada | auto-teste (c) de `q_truncation.R` |
| `covid_volatility` perdido em `run_stage2_cell()` | auto-teste (b) de `q_truncation.R` (`xi_ar` contra `xi_mp`); o plano previa o (f) |

Os dois primeiros são pegos pela guarda intrínseca do código, não por um check nomeado do validador.
O validador também para nesses casos.

## 3. Regressão da produção

- **`main` × branch.** As fontes R de `main` (`e1d8a89`) foram extraídas para o scratchpad. Saem
  `identical()`:
  - o objeto inteiro de `main_sdfm(r=5, q=5, p=4, nboot=0)`, com os conjuntos AR e ξ_den =
    6,057014271410632;
  - `diagnose_instrument_in_factor_space()` em `(5,5)`, `(5,3)` e na pré-COVID `p = 2`, com
    `moment_inputs` (descontado o campo novo `intercept`, TRUE nas três);
  - `run_stage2_cell()` em `(5,5)` com AR e em `(5,3)`.
- **Smoke test do `CLAUDE.md`:** bit-idêntico.
- **`validate_production_spec.R` e `validate_mosw_ar.R`:** passam, sem mudar arquivo commitado.
- **`q_truncation.R`.** As linhas das três células antigas saem idênticas às de `HEAD` nos quatro
  CSVs.
  - O md só muda na data, nas menções à célula nova e na frase que restringe a leitura conjunta às
    células sem tratamento.
  - A leitura conjunta de 09-10 continua "sustentada".

## 4. Passo 3/4: T1 e T2 na cheia tratada (9.2)

A célula `cheia_p4_lp` é a `cheia_p4` com a escala `s_t` no VAR dos fatores:
- K e H leem `u_t/s_t` sem centragem;
- T1 lê os autovetores do segundo momento não centrado de `u_t/s_t`, que é o que K usa ali;
- o AR roda na regressão transformada.

**Auto-testes do script** (todos passam):
- (b) cruza o `xi_ar` tratado (bloco W2 do AR) com o `xi_mp` tratado (`diagnose`) a 1e-6;
- (c) reconstrói o ξ de cada `q` tratado a partir das `q` primeiras direções, a 1e-8;
- (d) exige que os conjuntos de 90% da referência tratada sejam intervalos, exceto o singleton da
  normalização: são 5634 intervalos e 1 singleton;
- (f) confere θ̂ contra `covid_volatility_theta.csv` a 1e-8 e o `var_loglik` da célula contra o ℓ
  maximizado.

**Força, T1 e raiz máxima:**

| célula | ξ_mp em `q` = 5 / 4 / 3 / 2 | p de T1 em `q` = 2 / 3 / 4 | raiz máxima |
|---|---|---|---|
| `cheia_p4` | 6,057 / 4,359 / 2,105 / 2,339 | 0,051 / 0,039 / 0,015 | 0,9701 |
| `cheia_p4_lp` | 6,848 / 6,459 / 5,143 / 5,124 | 0,203 / 0,109 / 0,068 | 0,9837 |
| `pre_p4` | 8,643 / 8,803 / 8,819 / 4,905 | 0,216 / 0,528 / 0,483 | 0,9934 |
| `pre_p2` | 6,482 / 6,556 / 6,498 / 3,958 | 0,558 / 0,954 / 0,842 | 0,9862 |

O denominador de normalização de cada `q`, relativo ao de `q = 5` (`impact_mp_pre`), em
`q` = 4 / 3 / 2:
- `cheia_p4`: 0,630 / 0,241 / 0,252;
- `cheia_p4_lp`: 0,764 / 0,442 / 0,443;
- `pre_p2`: 0,998 / 1,003 / 0,708.

**T2**, séries imateriais / parciais / materiais entre as 115, com a mediana de `cor_path` entre
parênteses:

| `q` | `pre_p2` | `cheia_p4` | `cheia_p4_lp` |
|---|---|---|---|
| 4 | 115 / 0 / 0 (0,9999) | 0 / 21 / 94 (0,629) | 57 / 35 / 23 (0,966) |
| 3 | 115 / 0 / 0 (1,000) | 0 / 0 / 115 (0,334) | 23 / 17 / 75 (0,964) |
| 2 | 100 / 10 / 5 (0,986) | 0 / 0 / 115 (0,344) | 21 / 17 / 77 (0,962) |

Duas medidas complementares, em `q` = 4 / 3 / 2:
- **Mediana da fração de horizontes dentro da banda de 90%:** 0,694 / 0,510 / 0,469 na
  `cheia_p4`, 1,000 / 0,959 / 0,959 na `cheia_p4_lp` e 1 / 1 / 1 na `pre_p2`.
- **Séries com troca de sinal em h = 0:** 13 / 18 / 24, 7 / 11 / 10 e 0 / 0 / 9, na mesma ordem.

**Impacto (h = 0)**, nas unidades de `irf_point_matrix`, `q` = 5 / 4 / 3 / 2. O Ibovespa entra
aqui, embora esteja fora do destaque do script por decisão do autor:

| série | `cheia_p4` | `cheia_p4_lp` | `pre_p2` |
|---|---|---|---|
| `cds_5y` | 29,9 / 47,2 / 126,9 / 118,9 | 30,5 / 41,1 / 75,4 / 75,4 | 31,6 / 31,9 / 31,7 / 36,8 |
| `cambio_usd` | 0,134 / 0,267 / 0,534 / 0,453 | 0,129 / 0,199 / 0,298 / 0,307 | 0,058 / 0,060 / 0,063 / 0,086 |
| `price_ipca` | −0,044 / −0,071 / −0,209 / +0,109 | −0,045 / −0,054 / −0,169 / −0,205 | −0,261 / −0,263 / −0,263 / −0,150 |
| `ibc_br` | −0,630 / −0,990 / −2,649 / −2,569 | −0,661 / −1,013 / −1,691 / −1,648 | −0,415 / −0,417 / −0,409 / −0,907 |
| `yield_2y` | 0,0070 / 0,0090 / 0,0154 / 0,0150 | 0,0070 / 0,0080 / 0,0106 / 0,0106 | 0,0069 / 0,0069 / 0,0069 / 0,0073 |
| `asset_ibov` | −1,00 / −1,19 / −24,0 / −23,4 | −1,50 / −1,73 / −12,9 / −12,8 | −4,87 / −4,84 / −4,30 / −4,88 |

**Mecanismo.** Direções da `cheia_p4_lp` em `q = 5` (`q_truncation_directions.csv`):

| direção | var_share | Wald de z | cov_mp_share | covid_ss_share | blocos |
|---|---|---|---|---|---|
| 1 | 0,434 | 5,68 | 0,48 | 0,045 | curva 0,21, ações 0,17, câmbio 0,14 |
| 2 | 0,244 | 3,59 | −0,04 | 0,053 | indústria 0,24, trabalho 0,21, preços 0,20 |
| 3 | 0,175 | 0,03 | 0,00 | 0,080 | preços 0,44, câmbio 0,13, indústria 0,13 |
| 4 | 0,091 | 3,82 | 0,32 | 0,059 | ações 0,37, curva 0,12, expectativas 0,10 |
| 5 | 0,057 | 3,32 | 0,24 | 0,044 | monetário 0,25, trabalho 0,21, curva 0,13 |

As mesmas colunas nas outras células:
- **Direções 4 e 5:** somam 56% da covariância entre z e a inovação da `yield_6m` na tratada, contra
  76% na `cheia_p4`.
- **Direção 1:** a da curva, câmbio e ações carrega 48% na tratada, contra 20% na `cheia_p4` e 53%
  na `pre_p2`.
- **Peso da COVID:** as somas de quadrados de 2020-03 a 2020-12, que são 6,2% dos meses, ficam
  entre 4,4% e 8,0% por direção, medidas em `u_t/s_t`. Na `cheia_p4`, medidas em `u_t`, as direções
  1 e 2 tiravam dali 24% e 32%.

**Figura:** `output/factors/q_truncation.pdf`, última página.

## 5. Passo 4/4: a tabela `q = 2,…,5` nas duas janelas (9.3)

`script/q_narrative_overlay_covid.R` é o irmão tratado de `q_narrative_overlay.R`.
- **Desenho:** as mesmas 20 variáveis e o mesmo desenho da Figura A3 de AK, com AR 68/90 na
  `q = 5` tratada e `q = 2, 3, 4` só pontuais.
- **Auto-testes:** θ̂ contra o CSV; conjuntos de 90% das 20 séries em `q = 5` como intervalos,
  exceto o singleton; normalização.
- **Saídas:** `output/factors/q_narrative_r5p4_covid.{md,pdf}` e
  `q_narrative_r5p4_covid_{paths,summary}.csv`.

**Séries inteiramente dentro da banda de 90% da `q = 5`** em h = 0 a 48, entre as 20 da narrativa:

| janela | `q = 4` | `q = 3` | `q = 2` | mediana da fração dentro, `q` = 4 / 3 / 2 |
|---|---|---|---|---|
| pré-COVID, `p = 2` (`q_narrative_r5p2_precovid_summary.csv`) | 20 | 20 | 20 | 1 / 1 / 1 |
| cheia sem tratamento, `p = 4` (`q_narrative_r5p4_summary.csv`) | 1 | 0 | 0 | 0,633 / 0,541 / 0,490 |
| cheia tratada, `p = 4` (`q_narrative_r5p4_covid_summary.csv`) | 16 | 5 | 4 | 1 / 0,929 / 0,939 |

Na cheia tratada em `q = 4`, quatro séries saem da banda em algum horizonte:
- `cambio_usd` (fica dentro em 0,837 dos horizontes);
- `expect_focus_fiscal_primary_balance_ny` (0,735);
- `expect_focus_fiscal_dlsp_ny` (0,959);
- `expect_focus_cambio_ny` (0,980).

**Figuras para a leitura do autor:** as quatro páginas de `q_narrative_r5p4_covid.pdf`, ao lado de
`q_narrative_r5p4.pdf` (cheia sem tratamento) e `q_narrative_r5p2_precovid.pdf` (pré-COVID).

## 6. O que não se pode dizer

- **Qualquer veredito sobre o passo 3/4 que não seja o do autor.** Esta nota não aplica a regra de
  09-10 à célula tratada, e aplicá-la agora seria escolher a regra depois de ver o resultado.
- **Que a cheia tratada reproduz a pré-COVID.** Em `q = 3`, 75 das 115 séries saem materiais na
  `cheia_p4_lp`, contra nenhuma na `pre_p2`.
- **Que T1 não rejeitar valida o instrumento.** Não rejeitar não é aceitar; o p de `q = 4` é 0,068
  e condiciona em θ̂.
- **Que os conjuntos tratados incorporam a incerteza de θ.** Eles condicionam em θ̂ (§2.1).
- **Que as duas janelas foram comparadas no mesmo `p`.** A pré-COVID com bandas está em `p = 2`; a
  cheia, tratada ou não, em `p = 4`.
- **Que `q = 2, 3, 4` têm conjuntos.** Só há pontos. Na tratada, o ξ_mp dessas células fica entre
  5,1 e 6,5, acima de 3,84, e por isso seus conjuntos de 95% seriam limitados; eles não foram
  construídos.
- **Que o tratamento está na produção.** Está desligado, e os números de produção (ξ_mp = 6,057014,
  conjuntos AR, smoke test) não mudaram.
- **Que a leitura "só pico" (ρ = 0) foi examinada.** Não foi. Uma sensibilidade em ρ = 0 decidida
  agora, depois destas figuras, deixa de ser pré-declarada e tem de ser rotulada assim.

## 7. Decisões que não estão no artigo

1. **Inferência frequentista condicional a θ̂.** LP integram θ na posterior. Aqui θ̂ entra como
   conhecido.
2. **Covariância de MOSW na regressão transformada, só com `"standardized"`.** `"raw"` segue em
   `stop()`.
3. **ξ_mp com z residualizado em x̃, sem constante adicional.**
4. **T1 lê os autovetores do segundo momento não centrado de `u_t/s_t`,** que são as direções que K
   retém sob o tratamento.
5. **Sem regra de leitura para a célula tratada.** Decisão do autor (2026-09-14): ele lê as IRFs a
   olho.
6. **θ̂ reestimado em cada script** (`q_truncation.R`, `q_narrative_overlay_covid.R`) e conferido
   contra `covid_volatility_theta.csv` a 1e-8.
7. **`p` misto entre janelas,** herdado de 09-10: a pré-COVID só tem AR em `p = 2`.
8. **A leitura conjunta de 09-10 filtra explicitamente as células sem tratamento** (`cond_i`
   passou de `!= "cheia_p4"` para `%in% c("pre_p4", "pre_p2")`). O veredito dela não muda.

## 8. Próximos passos

1. **A leitura do autor**, nas figuras de §4 e §5.
2. **Se o tratamento for adotado:**
   - ligá-lo em `production_spec()`;
   - sincronizar `CLAUDE.md` e `AGENTS.md`;
   - escrever a seção de metodologia, com a ressalva de que a pré-COVID segue por OLS e a distinção
     em relação à identificação por heterocedasticidade abandonada.
3. **Se o tratamento entrar no paper**, mesmo só como robustez: abrir no apêndice as equações que
   ele muda. É item aberto em 2026-09-14 no Tema A de `registro/pendencias.md`.
4. **O passo 1/4** (especificação principal) segue com o autor.
5. **Bootstrap e Kilian sob tratamento**, agora item próprio em `registro/pendencias.md`. É de baixa
   prioridade, porque o AR é a inferência operacional.
6. **Outros meses anormais** (2016-01, 2018-05), que o tratamento de LP não cobre (§4 da nota de θ).
7. **O merge em `main`** fica com o autor.
