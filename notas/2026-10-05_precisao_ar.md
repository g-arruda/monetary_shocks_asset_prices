# Precisão: conjuntos de 95%, janela pré-COVID e Newey-West

> **CURRENT — 2026-10-05.** Passo 1/5 do plano do orientador de 03-10
> (`email/email_professor_03-10_11h31.md`). Branch `feature/focus-horizonte-fixo`, **não mergeada**,
> sobre a base do passo 0 (nota `2026-10-03_focus_horizonte_fixo`).
> - Produção da branch: `z_bs_purif`, `(r,q,p) = (5,5,4)`, escala COVID de Lenza-Primiceri com θ̂ do
>   painel a horizonte fixo, +50 p.b. em `yield_6m`. A produção não muda: os conjuntos de 80/90% e o
>   ponto saem `identical()` ao cache `output/irf/irf_coherence_cell.rds`.
> - Decisões do autor em 10-05, tomadas antes de rodar: os horizontes h = 0, 1, 3, 6, 12 e 24, que são
>   os do e-mail; a célula `(5,5,2)` para a janela pré-COVID; e a grade de Newey-West fixa,
>   L = 0, 1, 2, 3 (o pedido), mais 4, 8 e 12.
> - Script: `script/ar_precision.R`. Saídas em `output/ar_precision/`. Nada no `.tex` nem em
>   `paper/img/`.

## 1. Câmbio e CDS a 90 e 95%

O impacto de câmbio e CDS é significante a 95%. O câmbio é significante a 95% de h0 a h3, e o CDS de
h0 a h4. A 90% valem os horizontes da nota do passo 0: câmbio de h0 a h5, CDS de h0 a h6.

A última coluna é o p-valor do teste Anderson-Rubin de que a resposta é zero, uma χ²(1). Pela
construção do conjunto, a resposta é significante a X% se e somente se esse p-valor é menor que
1 − X/100. O script confere essa equivalência em todas as 5635 células, para cada nível e cada
truncagem de Newey-West.

**Câmbio BRL/USD (R$/US$)**

| h | ponto | 90% | 95% | p-valor |
|---|---|---|---|---|
| 0 | 0,146 | [0,071; 0,278] | [0,052; 0,352] | 0,013 |
| 1 | 0,180 | [0,064; 0,356] | [0,030; 0,448] | 0,030 |
| 3 | 0,172 | [0,058; 0,311] | [0,018; 0,374] | 0,039 |
| 6 | 0,120 | [−0,002; 0,226] | [−0,057; 0,264] | 0,104 |
| 12 | 0,027 | [−0,111; 0,129] | [−0,179; 0,161] | 0,642 |
| 24 | −0,077 | [−0,238; 0,044] | [−0,316; 0,083] | 0,253 |

**CDS 5 anos (p.b.)**

| h | ponto | 90% | 95% | p-valor |
|---|---|---|---|---|
| 0 | 33,9 | [15,7; 66,0] | [11,0; 84,0] | 0,015 |
| 1 | 37,1 | [16,4; 68,8] | [10,4; 85,4] | 0,021 |
| 3 | 34,0 | [13,6; 57,0] | [6,1; 67,0] | 0,033 |
| 6 | 26,1 | [2,4; 44,0] | [−8,9; 49,8] | 0,084 |
| 12 | 9,0 | [−19,3; 27,4] | [−34,1; 32,7] | 0,457 |
| 24 | −15,0 | [−47,9; 8,9] | [−64,2; 16,4] | 0,260 |

Com ξ_mp = 6,80 > 3,84, todo conjunto de 95% é limitado. No painel inteiro, os 4254 conjuntos de h0
a h36 são `interval`, mais o `singleton` da normalização. Os pares série-horizonte significantes caem
de 2366 a 80% para 1051 a 90% e para 458 a 95%.

O DI de 6 meses, que normaliza o choque, é significante a 95% em h1 e h3 (p 0,019 e 0,040), e não em
h6 (p 0,110). `table.csv` traz as 115 séries nos seis horizontes, a 80, 90 e 95%.

## 2. A janela pré-COVID

**Em `p = 4` não há conjunto.** A janela 2012-03 a 2019-12 tem 94 meses, e restam T = 90 inovações
depois de quatro defasagens. O vetor de momentos da covariância de MOSW tem 135 entradas e o de
parâmetros 120. As duas condições barram a célula: a do projeto (`hac_dim` < T) e a dos autores
(`CovAhat_Sigmahat_Gamma.m:91-95`). Em `p = 3` a célula também fica barrada (110 e 95 contra T = 91).
`p = 2` é o maior `p` que passa nas duas (85 e 70 contra T = 92), e o BIC escolhe `p = 2` na amostra
comum `T = 154`.

| célula | T | `hac_dim` | ξ_mp | raiz máxima | conjuntos |
|---|---|---|---|---|---|
| produção, 2012-03 a 2025-12, `p = 4` | 162 | 135 | 6,80 | 0,9855 | 80/90/95 |
| pré-COVID, `p = 2` | 92 | 85 | 5,64 | 0,9885 | 80/90/95 |
| pré-COVID, `p = 4` | 90 | 135 | 5,50 | 0,9945 | bloqueados |

A célula `p = 2` usa o mesmo instrumento e o mesmo `(r,q) = (5,5)`, e roda sem a escala COVID, porque
nenhum mês da janela chega a 2020-03. Com ξ_mp 5,64 > 3,84, os conjuntos são limitados nos três
níveis, todos `interval`.

**Câmbio (R$/US$), pré-COVID**

| h | ponto `p = 2` | 90% `p = 2` | 95% `p = 2` | ponto `p = 4` |
|---|---|---|---|---|
| 0 | 0,112 | [0,040; 0,203] | [0,010; 0,259] | 0,121 |
| 1 | 0,208 | [0,112; 0,323] | [0,069; 0,393] | 0,205 |
| 3 | 0,205 | [0,081; 0,359] | [0,027; 0,453] | 0,206 |
| 6 | 0,145 | [0,047; 0,294] | [0,010; 0,397] | 0,132 |
| 12 | 0,072 | [0,010; 0,204] | [−0,006; 0,313] | −0,016 |
| 24 | −0,055 | [−0,122; 0,046] | [−0,147; 0,116] | −0,108 |

**CDS (p.b.), pré-COVID**

| h | ponto `p = 2` | 90% `p = 2` | 95% `p = 2` | ponto `p = 4` |
|---|---|---|---|---|
| 0 | 39,9 | [16,2; 63,3] | [3,7; 75,4] | 45,0 |
| 1 | 56,5 | [32,6; 82,6] | [20,9; 97,1] | 57,0 |
| 3 | 50,3 | [20,6; 86,5] | [7,3; 108,3] | 55,8 |
| 6 | 36,1 | [12,6; 72,3] | [4,0; 97,6] | 32,6 |
| 12 | 19,4 | [4,0; 52,6] | [−0,1; 80,2] | −1,9 |
| 24 | −12,2 | [−28,7; 13,2] | [−34,7; 30,9] | −26,2 |

Em `p = 2`, câmbio e CDS são significantes a 95% de h0 a h11. A 90%, o câmbio é significante de h0 a
h13 e de h30 a h36, e o CDS de h0 a h13 e de h31 a h36. No painel, 1968 pares são significantes a 90%
e 723 a 95%, contra 1051 e 458 da produção.

**`p = 2` não substitui `p = 4` depois de h9.** O ponto de `p = 4` cai dentro do conjunto de 90% de
`p = 2` de h0 a h9 e sai dele de h10 a h21 no câmbio e de h10 a h22 no CDS. Com a curva (DI de 3 meses
a 10 anos) e o EMBI acontece o mesmo, de h9 ou h10 até h20 a h22. A célula `p = 2` reverte mais devagar:
em h12, o câmbio está em 0,072 com `p = 2` e em −0,016 com `p = 4`. No painel, 659 dos 4255 pontos de
`p = 4` saem do conjunto de `p = 2`, em 65 das 115 séries. O conjunto de `p = 2` vale como intervalo
pré-COVID para o impacto e os primeiros meses, não para a reversão.

**Produção contra o conjunto pré-COVID.** O ponto de produção fica dentro do conjunto de 90% de
`p = 2` em todos os horizontes de h0 a h36 no câmbio, no CDS, no DI de 5 e 10 anos e nas Focus de
câmbio e PIB. Sai no DI de 3 meses a 2 anos de h17 ou h18 até h36, no IPCA em h6–h9 e h20–h36 e na
DBGG em h5–h20 e h36. No painel, 1595 dos 4255 pontos saem, em 93 das 115 séries. Ponto contra
conjunto não é teste de igualdade entre as janelas.

⚠ **O impacto pré-COVID do câmbio mudou com o passo 0.** Na base de `main`, o ponto pré-COVID em
`p = 4` era R$ 0,056 (nota `2026-09-30_robustez_pandemia`). Na base a horizonte fixo, é R$ 0,121,
contra 0,146 da produção. A nota `2026-10-01_precovid_dbgg_focus_pib` tinha levado o 0,056 a 0,141
zerando as surpresas de janeiro. Esta rodada não testa se as duas coisas se ligam. `fig:precovid_sensibilidade`
e `precovid_sensitivity.csv` seguem na base antiga.

## 3. Autocorrelação dos momentos do teste

Cada conjunto inverte o teste AR(λ) = T(num − λ·den)² / v(λ). A variância v(λ) é a de longo prazo de
uma série escalar ψ_t(λ): a função de influência de (vec(A), Γ), dada pelo campo `influence` de
`mosw_rform_cov()`, combinada com as derivadas daquela célula. A série que decide a significância é
ψ_t(0). O script também lê ψ_t no ponto estimado, o centro do conjunto. O momento de ξ_mp é o da
normalização, e a estatística AR dele é o próprio ξ_mp; o script confere isso a 1e-10.

Abaixo, T = 162 e a faixa de ±1,96/√T é ±0,154 (`moment_acf.pdf`, `moment_acf.csv`,
`moment_ljung_box.csv`).

- **Momento de ξ_mp.** Não há autocorrelação. O Ljung-Box dá p 0,99, 0,82 e 0,95 em 3, 6 e 12
  defasagens, e nenhuma autocorrelação passa de 0,12 em módulo.
- **Câmbio e CDS, ψ_t(0), de h0 a h12.** O menor p-valor de Ljung-Box, em 3, 6 e 12 defasagens, é
  0,149 (CDS em h6).
- **Em h24.** O câmbio rejeita em 3 defasagens (p 0,040), e o CDS fica em p 0,057. Em 12 defasagens
  os p-valores são 0,12 e 0,14. Em todos os ψ_t(0), a única autocorrelação fora da faixa é a do
  câmbio em h24 na defasagem 12 (−0,156).
- **No ponto, ψ_t(λ̂).** Aparece dependência. No câmbio em h0, o Ljung-Box de 12 defasagens dá
  p 0,0001, com −0,24 nas defasagens 5 e 7 e +0,26 na 12. No câmbio em h3 dá p 0,006 em 6 defasagens,
  e no CDS em h3, p 0,022. A causa não foi investigada.
- **As 105 colunas da função de influência.** No bloco dos coeficientes do VAR, 16%, 14% e 21% das
  100 colunas rejeitam a 5% em 3, 6 e 12 defasagens, contra 5% nominais. No bloco Γ, só a coluna do
  quinto fator rejeita, em 6 e 12 defasagens (p 0,014 e 0,009).

As autocorrelações dos momentos que decidem a significância são pequenas, e 69% delas são negativas.
Por isso a variância de longo prazo com Newey-West sai menor que a de NW(0).

## 4. Newey-West

Tudo roda sobre o mesmo DFM, sem reestimar. A grade foi fixada antes de rodar: L = 1 a 3, como no
pedido; L = 4, pela regra de Newey e West (1994) para T = 162; L = 8, a de MOSW na aplicação fiscal
(`TaxSVARIV.m:52`); e L = 12. Para cada L, o script confere que o Wald de
`diagnose_instrument_in_factor_space()` iguala o ξ_mp dos conjuntos.

| L | ξ_mp | F_rob | pares significantes a 80% | a 90% | a 95% | perdidos a 90% | largura mediana a 90%, razão a L = 0 |
|---|---|---|---|---|---|---|---|
| 0 | 6,80 | 8,28 | 2366 | 1051 | 458 | 0 | 1,000 |
| 1 | 6,94 | 8,05 | 2391 | 1330 | 648 | 5 | 1,006 |
| 2 | 7,04 | 7,83 | 2471 | 1610 | 796 | 3 | 0,998 |
| 3 | 7,16 | 7,81 | 2554 | 1768 | 911 | 5 | 0,984 |
| 4 | 7,41 | 8,06 | 2639 | 1929 | 1174 | 7 | 0,955 |
| 8 | 9,18 | 10,30 | 2898 | 2342 | 1731 | 5 | 0,811 |
| 12 | 10,01 | 11,96 | 2965 | 2455 | 1888 | 5 | 0,755 |

Os pares contam as 115 séries de h0 a h36 (4255). Os "perdidos" são pares significantes a 90% em
L = 0 que deixam de ser em L. Em toda truncagem e em todo nível, os conjuntos seguem `interval`.

p-valor AR da resposta zero, por truncagem:

| série | h | L = 0 | 1 | 2 | 3 | 4 | 8 | 12 |
|---|---|---|---|---|---|---|---|---|
| câmbio | 0 | 0,013 | 0,016 | 0,016 | 0,016 | 0,016 | 0,014 | 0,011 |
| câmbio | 1 | 0,030 | 0,025 | 0,022 | 0,020 | 0,017 | 0,010 | 0,007 |
| câmbio | 3 | 0,039 | 0,028 | 0,022 | 0,018 | 0,015 | 0,003 | 0,001 |
| câmbio | 6 | 0,104 | 0,078 | 0,074 | 0,067 | 0,061 | 0,029 | 0,016 |
| câmbio | 12 | 0,642 | 0,642 | 0,649 | 0,642 | 0,633 | 0,574 | 0,528 |
| câmbio | 24 | 0,253 | 0,279 | 0,267 | 0,245 | 0,220 | 0,144 | 0,128 |
| CDS | 0 | 0,015 | 0,014 | 0,014 | 0,012 | 0,011 | 0,007 | 0,007 |
| CDS | 1 | 0,021 | 0,013 | 0,011 | 0,009 | 0,007 | 0,003 | 0,001 |
| CDS | 3 | 0,033 | 0,023 | 0,019 | 0,016 | 0,012 | 0,003 | 0,001 |
| CDS | 6 | 0,084 | 0,063 | 0,063 | 0,056 | 0,049 | 0,024 | 0,014 |
| CDS | 12 | 0,457 | 0,448 | 0,460 | 0,451 | 0,440 | 0,371 | 0,314 |
| CDS | 24 | 0,260 | 0,285 | 0,277 | 0,256 | 0,231 | 0,152 | 0,133 |

**De 1 a 3 defasagens** nenhum resultado de impacto muda. Câmbio e CDS continuam significantes a 95%
no impacto, com p-valor entre 0,012 e 0,016, e passam a ser significantes a 95% até h4 (o CDS até h5
em L = 3). A 90%, o câmbio vai até h6 em L = 1 e 2 e até h7 em L = 3 (p 0,078 em h6 com L = 1), e o
CDS até h7 nos três. A ponta longa volta em parte a 90%: o CDS em h35–h36 com L = 2 e em h32–h36 com
L = 3, e o câmbio em h33–h36 com L = 3. A largura mediana fica a 2% da de NW(0).

**De 4 a 12 defasagens** os conjuntos encolhem de 4,5% a 24,5%, em mediana, e ξ_mp sobe a 10,01 em
L = 12. A significância nunca cai em bloco: no máximo 7 pares perdem os 90%. De h0 a h6, NW(0) é a
truncagem com o maior p-valor, exceto no impacto do câmbio, onde L = 1 a 4 dão 0,016 contra 0,013. Em
h12 e h24 a ordem não é monotônica.

## 5. O que pode e o que não pode ser dito

- Pode: no impacto, um aperto de 50 p.b. deprecia o real em R$ 0,146 por dólar e eleva o CDS em 34
  p.b., e as duas respostas são significantes a 95% (p 0,013 e 0,015). O câmbio é significante a 95%
  até h3, e o CDS até h4.
- Pode: com Newey-West de 1 a 3 defasagens, e também com 4, 8 e 12, o impacto de câmbio e CDS continua
  significante a 95%.
- Pode: na janela pré-COVID, com `p = 2`, câmbio e CDS são significantes a 95% de h0 a h11, com
  ξ_mp 5,64.
- Não pode: um intervalo pré-COVID na especificação de produção. Em `p = 4` o conjunto não existe,
  porque as duas condições de dimensão o barram.
- Não pode: ler o conjunto de `p = 2` como o de `p = 4` além de h9. O ponto de `p = 4` sai dele em
  h10–h21 no câmbio e h10–h22 no CDS.
- Não pode: que o instrumento fica forte com Newey-West longo. ξ_mp = 10,01 em L = 12 sai de
  autocovariâncias pequenas e negativas, que o Ljung-Box não distingue de zero no momento de ξ_mp. A
  régua do registro continua NW(0), 6,80.
- Não pode: ler o ponto de produção dentro do conjunto pré-COVID como igualdade entre as janelas.

## 6. O que mudou

- `R/identification/weak_iv_ar.R`:
  - `mosw_rform_cov()` devolve também `influence`, cuja variância de longo prazo é `WHat`;
  - a montagem de `ar_dfm_bands()` passou a `ar_dfm_moments()`, que devolve `cov` e `deriv`;
  - `ar_statistic()` dá a estatística AR, o p-valor e a série ψ_t de cada célula a um λ0 dado.
- `ar_dfm_bands()` manteve assinatura e retorno. Os testes:
  - o smoke test sai bit-idêntico ao da branch;
  - `irf_coherence_check.R` reescreve `output/irf/` sem diferença de byte;
  - os sete validadores passam. `validate_covid_volatility.R` procura agora a mensagem de
    `ar_dfm_moments`, onde o `stop()` de `innovations = "raw"` foi parar.
- `script/ar_precision.R` escreve `output/ar_precision/`.
- O passo 4 (placebos com Holm ou Bonferroni) pode tirar os p-valores de `ar_statistic()`.
