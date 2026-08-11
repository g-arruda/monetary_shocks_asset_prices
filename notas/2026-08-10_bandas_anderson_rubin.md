# Bandas Anderson-Rubin: inversão do teste de Montiel Olea-Stock-Watson no DFM-IV

> **CURRENT.** Escrita em 2026-08-10 sob a produção corrente: `z_jk_bs_purif` ×
> `yield_6m`, r=7, q=6, p=6, painel de 106 séries (vintage 07-24), ξ_mp 10,43
> full / 12,22 pré-COVID. Corpo gerado em `output/irf/ar_bands.{csv,md}`,
> `ar_bands_summary.csv` e `ar_bands_overlay.pdf`. Código:
> `R/identification/weak_iv_ar.R`, `script/ar_bands.R`,
> `script/validate_mosw_ar.R`. **Nenhum script toca esta nota. Nenhum `.tex` foi
> tocado nesta rodada** — a redação no paper é item aberto separado em
> `registro/pendencias.md`.
>
> Esta nota **é o apêndice metodológico obrigatório** que a pendência exigia
> escrever junto com a implementação, não depois. As seções 1-4 são o apêndice;
> as 5-7 são a leitura dos resultados.

## 0. Veredito em cinco linhas

O conjunto AR é **limitado em todas as 31.164 células** calculadas (106 séries ×
49 horizontes × 3 níveis × 2 janelas): nenhuma semirreta, nenhum conjunto vazio,
nenhuma reta. **87 das 91 afirmações sig90 do §4 sobrevivem** à régua robusta a
IV fraco. As 4 que não sobrevivem são todas do **bloco de atividade no impacto**,
e uma delas por margem quase nula. O prêmio de IV fraco é um **fator de escala
comum de 1,164** a 90% — quase idêntico entre séries, porque a fraqueza mora no
denominador compartilhado da normalização, não no numerador de cada série. E a
banda AR é **mais estreita** que a de bootstrap (razão mediana 0,646), o que
**não** é um resultado a favor: as duas não medem a mesma coisa, e a §6 explica
por quê.

---

## 1. O método, e por que ele se aplica a um DFM

MOSW (2021, *JoE*, §4.2) partem de um SVAR-IV em observáveis, onde a IRF
identificada da variável `j` no horizonte `h` é uma **razão de duas formas
lineares** no momento `Γ = E[z_t η_t]`:

```
λ_{j,h} = scale · (e_j' C_h Γ) / (e_nvar' Γ),
```

com `C_h` os coeficientes MA do VAR (`C_0 = I`). Como `λ` é uma razão, um
intervalo de confiança honesto vem da **inversão do teste** (Fieller /
Anderson-Rubin): o conjunto dos `λ0` que o teste não rejeita,

```
S = { λ0 : T (num − λ0·den)² ≤ κ · σ̂²(λ0) },   κ = z²_{1−α/2},
```

que é uma **desigualdade quadrática em λ0** e admite quatro formas conforme o
sinal do coeficiente de `λ0²` e do discriminante: intervalo limitado, união de
duas semirretas, conjunto vazio, ou a reta toda. É `MSWfunction.m`.

**Por que carrega para o DFM.** MOSW é agnóstico à origem do VAR reduzido. Um
DFM estático é, na parte dinâmica, **um VAR nos r fatores com uma equação de
medida linear acoplada** — é exatamente assim que Alessi-Kerssenfischer tratam o
modelo em `IdentExtInstr.m`, e é a leitura padrão de Stock-Watson. A IRF que
`compute_irf_dfm` produz é

```
irf_h = diag(sy) Λ B_h K M H,     H = (Z'η)/(Z'Z),   η = u K M⁻¹,
```

com `u` os resíduos do VAR **de fatores** e `B_h` o bloco r×r superior-esquerdo
da companion elevada a h. Substituindo `H` e usando `M` diagonal
(`K M M⁻¹ K' = K K'`), e escrevendo `Γ = (1/T)Σ z_t u_t ∈ R^r`, isso é

```
λ_{j,h} = scale · (e_j' C_h Γ) / (d0' Γ),
     C_h = diag(sy) Λ B_h K K',     d0 = C_0' e_mp = K K' (sy_mp Λ_mp).
```

O fator `T/(Z'Z)` cancela na razão. **Mesma razão de duas formas lineares em Γ**,
logo mesma lógica de Fieller. A única mudança conceitual é que o denominador
deixa de ser uma **coordenada** de Γ (`e_nvar`) e passa a ser uma **combinação**
delas (`d0`).

---

## 2. Equação por equação: o que mudou em relação ao `codigos_externos/codigo_olea`

Três substituições, e nada mais. Com `Load = I` e `Inner = I` o código escrito
aqui **recai literalmente no original** — é isso que torna a validação da §4
possível sem escrever uma segunda implementação.

| MOSW (VAR em observáveis) | aqui (DFM) | onde |
|---|---|---|
| `C_h` = coeficientes MA do VAR, n×n, `C_0 = I` | `C_h = Load · B_h · Inner`, 106×7, com `Load = diag(sy)Λ` e `Inner = K K'` | `mosw_response_derivatives` |
| denominador `Γ_nvar = e_nvar' Γ` | `d0' Γ`, com `d0 = C_0' e_mp` | `mosw_ar_bounds` |
| `(Γ' ⊗ e_j') G_h` | `(γ' ⊗ a_j') G_h`, `γ = Inner·Γ`, `a_j` = linha j de `Load` | `mosw_response_derivatives` |
| `n` = dimensão do SVAR | `n_state = r = 7` no bloco de `vec(A)`; `n_out = 106` nas respostas | ambas |

A quadrática de `MSWfunction.m:105-115` generaliza termo a termo trocando
`e_nvar` por `d0` — `W2(nvar,nvar) → d0'W₂d0`, `W12(:,nvar) → W₁₂d0`,
`W2(:,nvar) → W₂d0`:

```
â = T·(d0'Γ)² − κ·d0'W₂d0
b̂ = −2T·num·(d0'Γ) + 2κ·d1·W₁₂d0 + 2κ·dΓ'·W₂d0
ĉ = T·num² − κ·[ d1 W₁ d1' + 2·d1 W₁₂ dΓ + dΓ' W₂ dΓ ]
```

com `num = scale·a_j'B_h γ`, `dΓ = scale·(a_j'B_h·Inner)'` e
`d1 = scale·(γ'⊗a_j')G_h`. Os quatro `casedummy` e o ramo cumulativo ficam
inalterados. O delta-method da §6 de `MSWfunction.m` sai de graça da mesma
derivada e é reportado junto.

**`CovAhat_Sigmahat_Gamma.m` muda em duas coisas, ambas de bookkeeping.** O `X`
passa a ser `[1, F_{t−1}, …, F_{t−p}]` — os regressores do VAR **de fatores** —
e `eta` passa a ser `u`, os resíduos desse VAR. E o bloco de `vech(Σ)` foi
omitido: `WHat`, o objeto que `MSWfunction.m` consome, o descarta na linha
seguinte, e as duas linhas do `Shat` que sobrevivem têm bloco nulo ali. Nada
mais foi alterado — nem o kernel, nem o `Shat`, nem a ordenação de `vec`.

**O que decorre e vale registrar como propriedade, não como escolha:** o
coeficiente `â` de `λ0²` é `T·(d0'Γ)² − κ·d0'W₂d0`, que é **exatamente a Wald na
direção do denominador** — o ξ_mp que o projeto reporta desde 2026-07-26 em
`output/instrument/mosw_strength_grid.csv`, porque `d0` é literalmente o `c_mp`
de `factor_space_diagnostics.R:94`. Logo **o conjunto é limitado em todos os
horizontes se e somente se ξ_mp > κ**. A coluna `ar_bounded` daquele CSV já
antecipava a resposta desta rodada; o que faltava era o intervalo.

---

## 3. Engenharia: as quatro decisões que exigiram trabalho

**(a) `G_h` nunca é materializada.** Pela fórmula de Lütkepohl que
`Gmatrices.m` implementa, `G_h = Σ_{m=0}^{h−1} P_{h−1−m} ⊗ B_m` com
`P_j = (A_c^j J')'`. O array intermediário `AJaux` do MATLAB tem dimensão
`(n·hori·n) × (n·p·n) × hori`, que com r=7, p=6, h=48 daria ≈ 265 MB. Mas só se
precisa do produto `(γ'⊗a_j')G_h`, e ele colapsa por
`(x'⊗y')(P⊗Q) = (x'P)⊗(y'Q)`:

```
d1_{j,h} = scale · Σ_{m=0}^{h−1} (γ' P_{h−1−m}) ⊗ (a_j' B_m),
```

soma de produtos externos entre um vetor 1×rp que **não depende de j** e um 1×r.
O resultado é um array de 12 MB.

**(b) `W` tem posto deficiente, e isso não é defeito.** Com r=7, p=6, k=1 e
T=147, a matriz de `(vec(A), Γ)` é 301×301 estimada com 147 observações. A
aplicação-carro-chefe do próprio MOSW tem o mesmo problema — o SVAR do petróleo
tem `n²p + n(n+1)/2 + nk = 398 > T = 356` — e roda: a quadrática usa **apenas
formas quadráticas `d'Wd`**, nunca `W⁻¹`. O único lugar do código oficial que
inverte `W` é a `WaldstatFull` comentada em `MSWfunction.m:389`, que aqui já era
calculada em separado por `compute_factor_space_wald`.

**(c) O `tcode` exige o ramo cumulativo, não a soma dos limites.** O painel usa
três códigos. `tcode 1` (nível) usa o ramo não-cumulativo direto; `tcode 4`
(log-nível) aplica `(exp(x)−1)·100`, monótona crescente, portanto aplicável aos
limites; **`tcode 2` (retornos mensais dos 8 índices B3) exige `Ccum`/`G_cum`**,
porque a IRF reportada é a soma dos horizontes até `h`, um funcional linear
**diferente** — acumular os limites de um AR não-cumulativo seria erro. É
precisamente para isso que MOSW carregam o ramo cumulativo, e é a peça que não
existe no MATLAB porque lá o `tcode` é externo ao método.

**(d) A célula de normalização é degenerada, e o código oficial já sabia disso.**
Em `(mp, h=0)` tem-se `d1 = 0` e `dΓ = scale·d0`, o que dá `ĉ = scale²·â` e
portanto **`Δ = 0 exatamente`**: o conjunto AR é o singleton `{scale}`. A
classificação de MOSW cai então no ramo residual (caso 4, "reta toda"), que é a
razão de `MSWfunction.m:156-158` sobrescrever os limites — não é conveniência
gráfica. Aqui os limites são sobrescritos do mesmo jeito e o **rótulo** também é
corrigido para 1, que é o que o conjunto de fato é; a validação exclui essa única
célula da comparação de `casedummy`.

---

## 4. Validação contra o código oficial

`script/validate_mosw_ar.R` roda as **mesmas três funções**, com `Load = Inner =
I`, sobre a aplicação do petróleo de Kilian (2009) dos autores — VAR(24), n=3,
T=356, `norm=1`, `scale=1`, `NWlags=0`, 21 horizontes — e compara com o que eles
salvaram:

| objeto | desvio |
|---|---|
| `WHat` vs `CovAhat_Sigmahat_Gamma.m` | 4,9e-14 (relativo) |
| `Γ = eta·z/T` | 4,4e-16 |
| `Waldstat` (alvo 4,398794076) | exato |
| `ahat`, `bhat`, `chat` (2 ramos × 2 níveis) | ≤ 1,7e-11 |
| `MSWlbound` / `MSWubound` | ≤ 9,5e-12 |
| `Dmethodlbound` / `Dmethodubound` | ≤ 9,7e-12 |
| `casedummy` | 0 células divergentes de 63, nos 4 blocos |
| `Plugin.IRF` (cum e não-cum) | ≤ 1,0e-15 |

Isso valida de uma vez a convenção de `vec`, a recorrência de `G_h`, o `Shat`, a
quadrática e os quatro casos. **O que não valida** é a generalização em si
(`Load`, `Inner`, `d0 ≠ e_nvar`), que não tem contraparte no código oficial; essa
é coberta pelos auto-testes de `script/ar_bands.R`, em especial o ponto
reproduzindo `irf_coherence_h.csv` a 2,8e-13 relativo e o ξ_mp reproduzindo
`mosw_strength_grid.csv` a 1,3e-10.

**Fixture.** `output/validation/olea_oil_fixture.rds` (232 KB), extraído uma vez
de `codigos_externos/codigo_olea/Output/Oil/Mat/IRF_SVAR_p=24_OilData_{68,95}.mat`
via `scipy.io.loadmat`, porque `codigo_olea/` é gitignorado e o `.mat` não pode
ser assumido presente. Mesmo padrão de `validate_hac_kernel.R`.

**Achado lateral, corrigido na mesma rodada:** `script/validate_olea_kilian.R`
apontava para `codigo_olea/Data/Oil/Data.xls` e estava **quebrado desde que o
código de referência migrou para `codigos_externos/`** — não rodava, e ninguém
notou porque nada o chama. Foi repontado para o fixture (roda em clone limpo) e
ganhou uma checagem extra: o VAR reestimado aqui bate com o `RForm` dos autores a
8,4e-11 em `eta` e 2,4e-12 em `AL`. Mesma correção textual aplicada às demais
menções a `codigo_olea/`, `codigo_alessi-mark/` etc. nos arquivos `.R`.

---

## 5. Resultado 1: o conjunto é limitado em toda parte

| janela | T | ξ_mp | limitado a 68% (κ=0,99) | a 90% (κ=2,71) | a 95% (κ=3,84) |
|---|---|---|---|---|---|
| full | 147 | 10,431 | sim | sim | sim |
| pre-COVID | 78 | 12,223 | sim | sim | sim |

**31.164 de 31.164 células no caso 1.** Isto era previsível — é `â > 0 ⟺ ξ_mp >
κ`, e o leave-one-month-out de 2026-07-27 já mostrava que nenhum dos 147
descartes derruba ξ_mp abaixo de 3,84 —, mas previsível não é o mesmo que
verificado, e a pendência pedia o intervalo, não a condição.

## 6. Resultado 2: o prêmio de IV fraco é um fator de escala comum

Razão de larguras **AR / delta-method**. As duas bandas compartilham derivada,
`W` e condicionamento; diferem **só** por o AR não dividir pelo denominador
estimado. É a comparação limpa.

| janela | ξ_mp | 68% | 90% | 95% |
|---|---|---|---|---|
| full | 10,431 | 1,052 | **1,164** | 1,263 |
| pre-COVID | 12,223 | 1,043 | 1,134 | 1,209 |

Duas leituras, ambas na direção certa e nenhuma delas imposta: o prêmio **cresce
com o nível de confiança** (κ maior aproxima `â` de zero) e **cai quando o
instrumento é mais forte** (pré-COVID, ξ_mp 12,22, paga menos que full). E é
**quase constante entre séries** — no full a 90% a razão vai de 1,162 a 1,200 nas
106 séries. Isso não é acaso: a fraqueza está no **denominador comum** `d0'Γ`, que
é o mesmo para toda série, e não no numerador específico de cada uma.

Consequência prática, e é a frase que o paper pode usar: **corrigir por IV fraco
alarga as bandas de 90% em cerca de 16%**, uniformemente.

## 7. Resultado 3: o que sobrevive, e o que não

Placar na amostra cheia, 53 séries × 49 horizontes (as mesmas de
`irf_coherence_h.csv`), excluída a célula de normalização:

| nível | células | sig bootstrap | sig delta | sig AR | boot sig que o AR derruba |
|---|---|---|---|---|---|
| 68% | 2.596 | 706 | 1.767 | 1.735 | 17 |
| 90% | 2.596 | 91 | 1.091 | 940 | **4** |

**87 das 91 afirmações sig90 sobrevivem.** As quatro que não:

| série | h | ponto | AR 90% |
|---|---|---|---|
| `ind_bens_duraveis` | 0 | −5,47 | [−12,70; **+0,034**] |
| `ind_bens_capital` | 0 | −2,60 | [−6,17; +0,158] |
| `ind_transformacao` | 0 | −1,41 | [−3,57; +0,312] |
| `cambio_eur` | 3 | +0,12 | [−0,011; +0,249] |

⚠ **A variável inconveniente é o padrão, não a exceção individual.** Três das
quatro perdas são o **impacto do bloco de atividade em h=0** — exatamente as
respostas que a §4.3 usa para dizer que a produção industrial cai no impacto. Sob
a régua robusta a IV fraco, **essa é a afirmação mais frágil do paper**, e
`ind_bens_duraveis` erra por 0,034 num intervalo de largura 12,7. As respostas de
curva, câmbio e risco soberano — que são o resultado central — não perdem
nenhuma célula.

**A assimetria, que é o conteúdo que a banda de Wald não tem.** Definindo
`(hi − ponto)/(ponto − lo)`, uma banda simétrica vale 1. A mediana das 2.596
células é **0,911** (q10 0,814, q90 1,199): o conjunto AR tipicamente se estende
mais **para baixo** que para cima. No impacto: `cambio_usd` **1,410**
(assimetria para cima), `price_ipca` **0,644** (para baixo). O bootstrap tem a
mesma mediana de assimetria (0,952) e concorda em direção com o AR, mas a
correlação entre os dois logs é só **0,279** — os dois capturam assimetrias
diferentes, e não é caso de um confirmar o outro.

---

## 8. A limitação declarada, e por que a banda AR sai mais estreita

A razão **AR / bootstrap** é 0,646 na mediana e ultrapassa 1 em **6 de 2.596**
células. Ler isso como "a inferência robusta a IV fraco é mais permissiva que a
publicada" seria erro, e a nota registra por quê.

**A banda AR condiciona no espaço de fatores estimado.** A covariância
assintótica de MOSW é a de `(vec(A), Γ)`; `Λ`, `K`, `M` e `sy` entram como
**conhecidas**. O wild bootstrap do projeto faz o oposto: **reestima o DFM
inteiro dentro de cada réplica** (`impulse_responde.R:568`), então a banda de
bootstrap carrega a variabilidade amostral de `Λ̂` que nenhuma das duas bandas
assintóticas carrega. As duas não medem a mesma coisa, e é por isso que os
limites de delta-method entram no exercício: **AR contra delta** isola a correção
de IV fraco (§6); **delta contra bootstrap** isola assintótico-vs-reamostragem e
a incerteza de `Λ̂`.

A justificativa para o condicionamento é a padrão em DFM e é a mesma de que
Alessi-Kerssenfischer dependem: com `n = 106` e `T = 147`, `√T/n = 0,114`, e os
fatores estimados podem ser tratados como observados. **Mas ela é uma
justificativa assintótica, não uma medição**, e o número acima diz que na prática
o que ela ignora vale ~35% da largura da banda. A afirmação defensável é estreita:
*a correção de IV fraco custa 16% de largura, e essa correção é ortogonal à
incerteza de estimação dos fatores, que o bootstrap já cobre e que continua a ser
a régua reportada no paper.*

**Ponta solta declarada.** Um AR **por bootstrap** (`GasydistbootsAR.m` do mesmo
suite, grid de nulos × réplicas) seria a banda que junta as duas fontes. Não foi
implementado: exige decidir o grid de `λ0` e custa 800 draws × grid × 106 séries.
Fica registrado como opção, não como pendência aberta — o exercício desta rodada
responde à pergunta que foi feita.

---

## 9. O que pode e o que não pode ser escrito

**Pode:**

- O conjunto AR de 95% é um **intervalo limitado em todos os 49 horizontes e nas
  duas janelas**, porque ξ_mp = 10,43 (12,22 pré-COVID) excede 3,84 — e o
  coeficiente de `λ0²` da quadrática **é** essa estatística.
- Corrigir por IV fraco alarga as bandas de 90% em **~16%** (1,164), e o alarga-
  mento é praticamente o mesmo em todas as séries.
- **87 das 91** afirmações sig90 do §4 sobrevivem à régua robusta a IV fraco.
- O intervalo AR é **assimétrico** em torno do ponto, coisa que uma banda de Wald
  não pode ser; `cambio_usd` no impacto é [0,081; 0,246] contra um ponto de
  0,1498.
- A implementação é validada contra o código dos próprios autores nos limites,
  nos coeficientes da quadrática e na classificação dos casos.

**Não pode:**

- ⚠ **Não escrever que a banda AR "confirma" ou "estreita" o resultado.** Ela é
  mais estreita que a de bootstrap por **condicionar em `Λ̂`**, não por o
  resultado ser mais forte. Comparar AR com bootstrap sem dizer isso é comparar
  objetos diferentes.
- ⚠ **Não omitir as quatro perdas**, e menos ainda o padrão delas: são o
  **impacto do bloco de atividade**, que é uma afirmação do §4.3. `ind_bens_
  duraveis` deixa de ser sig90 por 0,034.
- **Não trocar a régua reportada no paper.** As bandas do §4/§5 continuam sendo
  as de bootstrap; o AR é robustez, não substituição.
- Não citar "ξ_mp ≥ 10 sustenta bandas convencionais" como resultado de MOSW —
  é a regra de bolso Staiger-Stock para o F homoscedástico de primeiro estágio do
  2SLS, e a atribuição errada em `paper/paper_anpec.tex:266` é item aberto
  próprio em `pendencias.md`.
