# Identificação por heterocedasticidade — `z_het` e `z_het_jk`

Este documento descreve as duas variantes de instrumento por heterocedasticidade do projeto: **`z_het`** (Rigobon-Sack puro) e **`z_het_jk`** (com filtro Jarociński-Karadi diário). Ambas são construídas por `script/instrument_het.R`, salvas em `data/processed/instrument_z_het.csv` e `data/processed/instrument_z_het_jk.csv` respectivamente, e consumidas pela pipeline DFM existente (`compute_irf_dfm`, `ident_ext_instr`, wild bootstrap GK) sem qualquer modificação no código de modelagem. **Recomendação após auditoria (2026-04-25): `z_het_jk` com normalização em `yield_6m`** — ver seção final.

## Motivação

Os quatro instrumentos pré-existentes (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`) seguem Gertler-Karadi (2015): tratam a variação intra-dia da DI no anúncio do Copom como medida do choque monetário. No Brasil isso é problemático porque o Copom anuncia **após** o fechamento do mercado (cf. GRG 2025): a reação dos preços ocorre no dia útil seguinte, e a janela quarta→quinta confunde o choque com o componente de informação que o mercado processa concomitantemente. Rigobon-Sack (2004, *JME*) mostram que essa identificação por timing produz vieses sistemáticos quando a variância dos demais choques não é desprezível.

A identificação por heterocedasticidade resolve isso ao inverter a lógica: em vez de assumir que a janela é estreita o bastante para isolar o choque, exigimos apenas que **a variância do choque de política seja maior em dias de Copom do que em dias normais**, mantendo as variâncias dos demais choques estáveis.

## Setup do bloco SVAR diário

Considere o vetor diário das mudanças quarta→quinta de quatro variáveis financeiras:

```
u_t^d = (ΔDI_3m, ΔDI_2y, ΔIBOV, ΔBRL/USD)'
```

com `ΔDI` em pontos-base e `ΔIBOV`, `ΔBRL` em log-retorno × 100. Postulamos a decomposição estrutural:

```
u_t^d = B_d ε_t       com   ε_t = (ε_1, ε_2, ε_3, ε_4)' ortogonal
```

onde `ε_1` é o choque de política monetária. Defina dois regimes pelo calendário do Copom:

- **C** (Copom-week): t é uma quarta de anúncio, par formado pelo próximo dia útil (tipicamente quinta).
- **NC** (non-Copom-week): t é qualquer outra quarta no painel, par formado pelo próximo dia útil.

## Hipóteses de identificação

- **A1** (heterocedasticidade do choque de política): `Var(ε_{1,t} | C) > Var(ε_{1,t} | NC)`.
- **A2** (homocedasticidade dos demais choques): `Var(ε_{j,t} | C) = Var(ε_{j,t} | NC)` para `j = 2, 3, 4`.
- **A3** (`B_d` constante entre regimes): a estrutura de covariância contemporânea não muda; só as variâncias dos choques.

A1 é diagnosticável: o teste é a Tabela 1 do GRG, replicado pelo `validate_variance_split` (razão de variâncias com IC bootstrap 99%). A2 também: razões devem incluir 1 nos demais choques. O verdict por variável (coluna `a2_status` ∈ {`policy`, `pass`, `violated`}, com `a2_side` ∈ {`upper`, `lower`}) é produzido por `classify_a2_verdict` em `R/identification/het_shock_extraction.R` e persistido em `output/het_variance_validation.csv`. Quando A2 é violado para `DI_2y` (λ_2 ≈ 41 indica um segundo choque estrutural), o mesmo `script/instrument_het.R` produz um SVAR 3-var de robustez (DI_3m, IBOV, BRL) com diagnostics próprios em `output/het_*_3var.csv`; a comparação `b_1` 4-var × 3-var aparece em `output/instrument_diagnostics_report.md` §4.3.

## Identificação rank-1 e recuperação do choque

Sob A1–A3:

```
Sigma_C  = E[u u' | C]  = B_d D_C  B_d'    com D_C  = diag(σ²_{1,C}, σ²_2, σ²_3, σ²_4)
Sigma_NC = E[u u' | NC] = B_d D_NC B_d'    com D_NC = diag(σ²_{1,NC}, σ²_2, σ²_3, σ²_4)
ΔΣ       = Sigma_C − Sigma_NC = (σ²_{1,C} − σ²_{1,NC}) · b_1 b_1'
```

⇒ ΔΣ tem rank 1, e `b_1 = sqrt(λ_1) · v_1`, onde `(λ_1, v_1)` é o par autovalor-autovetor líder. O sinal é fixado por convenção: `b_1[DI_3m] > 0` (choque contracionário sobe DI). A força da identificação é monitorada pelo *eigenvalue gap* `λ_1/|λ_2|` e pelo *rank-1 share* `|λ_1|/Σ|λ_j|`. O código alerta quando `rank1_share < 0.6` ou quando `|λ_min|/λ_1 > 0.3` (PSD severamente violado).

A série diária do choque em dias C é recuperada pela projeção GLS de Mertens-Ravn (2013, *AER*, §II.B):

```
ε̂_{1,t} = (b_1' Σ_C^{-1} u_t^d) / (b_1' Σ_C^{-1} b_1)    para t ∈ C
```

Em dias NC não recuperamos ε_1 porque a relação sinal-ruído colapsa.

## Framing: instrumento híbrido het+timing (council Required 3, 2026-05-05)

A taxa de **57% wrong-sign** no ε̂_1 diário (sign(ε̂_1) == sign(ΔIBOV)) indica que A1-A3 sozinhos **não isolam** o choque de política — caso isolasse, o filtro JK não triplicaria F (de 7.6 para 21.3 em `z_het` → `z_het_jk`). O filtro JK aplicado no nível diário é portanto parte da identificação, não cosmético.

Caracterização correta: o instrumento mensal `z_het_jk` (e seu análogo 3-var) é uma **identificação híbrida**, com três camadas:

1. **Het-extracted** no nível diário — ε̂_{1,t} via projeção GLS de Mertens-Ravn em `b_1` (Rigobon-Sack 2003).
2. **Timing-restricted** — apenas dias C (Copom) entram na soma mensal.
3. **Sign-restricted** — Jarocinski-Karadi sign filter zera dias com sign(ε̂_{1,t}) == sign(ΔIBOV_t).

A condição identificadora **operativa** no proxy-SVAR mensal é a *exclusion restriction* mensal:

```
E[z_het_jk_m · η_t^j] = 0     para todo choque estrutural não-policy η_t^j (j ≠ 1)
```

(Stock-Watson 2018, *EJ*, §4.7). Essa condição é **mais fraca** que A1-A3 conjuntas e é compartilhada com proxy-SVARs Gertler-Karadi (`z_jk_purif`); a diferença está em **como** construímos `z_het_jk_m` — daily het-ID + JK no Brasil, vs. window de surpresas + JK no GK original.

Os testes em `script/instrument_validation.R` atestam empiricamente que o instrumento construído satisfaz a exclusion restriction:

- **T1 placebo** (p ≈ 0.0005) descarta data-snooping;
- **T2 random-mask** + **T6 curva F(k_keep)** mostram que o filtro JK é informativo (não só esparsifica);
- **T2b paired benchmark z_het puro** (placebo p ≈ 0.008): nenhum dos dois rejeita por data-snooping; o gap F obs (7.6 vs 21.3) é idiossincrático ao filtro JK no diário;
- **T5 anti-JK** quantifica o quanto o sinal está nos dias específicos selecionados pelo JK;
- **T4 correlação** com `z_jk_purif` (cor=0.93 nos meses both-nonzero) confirma que het-ID e timing-ID convergem onde ambos disparam; cor estável 0.93–0.95 por sub-período (não mascara COVID);
- **T7 AR-order sensitivity** (p ∈ {3, 6, 12}): F estável (20.7 / 21.3 / 22.4) — não é artefato de lag-order;
- **T8 Andrews (1993) QLR sup-F** = 6.88 em 2015-08, abaixo de cv5 = 8.85 ⇒ **fail to reject**. O drop F sub-period (T3) é mecânico — var(innov) cresce 3.6× pós-COVID — não quebra estrutural no β.

A leitura honesta para o paper: `z_het_jk` **não é** "het-ID puro"; é um instrumento híbrido cujo identifying assumption é a exclusion restriction mensal, **não** A1-A3.

## Agregação para mensal

Para cada mês `m`, soma simples dos choques diários extraídos:

```
z_het_m    = Σ_{t ∈ C ∩ m}            ε̂_{1,t}
z_het_jk_m = Σ_{t ∈ C ∩ m, "puro"}    ε̂_{1,t}     (filtro Jarociński-Karadi diário)
```

Meses sem Copom (ou sem nenhum dia "puro" no caso JK) recebem 0. O filtro JK classifica um dia Copom como "puro monetário" se `sign(ε̂_{1,t}) ≠ sign(ΔIBOV_t)` e como "informacional" caso contrário; informacionais entram com peso zero. **Resultado na amostra (2013-01–2025-12):** 42/97 dias retidos como puros (43% — 57% têm contaminação informacional).

## Inserção no DFM

Ambas as variantes ficam disponíveis em:
- `data/processed/instrumentos_mensais.csv` (colunas `z_het` e `z_het_jk`, lado a lado das 4 GK)
- `data/processed/instrument_z_het.csv` e `data/processed/instrument_z_het_jk.csv` (single-variant)

Para usar como instrumento principal:

```r
DEFAULT_VARIANT <- "z_het_jk"   # script/instrument.R linha 25 (recomendado)
```

Após `Rscript script/instrument.R`, o legacy `data/processed/instrument.csv` apontará para a variante escolhida e `script/model_alessi.R` (e `script/model_var.R`) o consome via `ident_ext_instr` sem nenhuma mudança de código. O wild bootstrap recursive GK (Gonçalves-Kilian 2004) permanece a inferência principal: o indicador de regime C/NC é fixo entre draws (calendário é exógeno).

**Variável de política para normalização (`mpind`):** após auditoria, recomenda-se `yield_6m` (passa Stock-Yogo F > 10). `juros_selic` apresenta atenuação severa por descasamento de maturidade.

## Diagnostics

`script/instrument_diagnostics.R` (Seção 4) lê três artefatos produzidos por `script/instrument_het.R`:

- `output/het_variance_validation.csv` — Tabela 1 do GRG.
- `output/het_eigenvalues.csv` — espectro de ΔΣ.
- `output/het_b_1.csv` — coluna de impacto.

E reporta:

- **Seção 1** — comparação first-stage F dos 8 instrumentos (4 GK + `z_het`, `z_het_jk`, `z_het_3var`, `z_het_jk_3var`) com **dois F lado a lado**: F (DFM) contra o resíduo do primeiro fator do VAR (alvo do AK 2019; governa viés de instrumento fraco no proxy-SVAR) e F (y6m AR) contra a inovação AR(6) de `yield_6m` (relevância Selic-equivalente; mesmo cálculo do `instrument_audit.R`). HC0, partial F, Olea-Stock-Watson ξ_1. As colunas `n (DFM)` e `n (y6m)` da tabela tornam explícita a diferença de amostra entre os dois.
- **Seção 4.1** — replica da Tabela 1 do GRG; gates A1 (DI_3m ratio > 1, IC 99% exclui 1) e A2 (IBOV/BRL CIs incluem 1).
- **Seção 4.2** — espectro de ΔΣ; gate `rank1_share > 0.6`. Plot em `output/het_eigenvalues.png`.
- **Seção 4.3** — `b_1` com nomes das variáveis e sinais.

Para auditoria de relevância first-stage por maturidade alvo, ver `script/instrument_audit.R` e `output/instrument_audit_report.md`. Esse script faz o grid (4 variantes het × 7 candidatos a alvo mensal) e apura o F = 21.3 do `z_het_jk` × `yield_6m`.

## Lastro na literatura

- Rigobon (2003, *RES*) — Proposições 1-4: identificação rank-1 e GMM multi-regime.
- Rigobon & Sack (2003, *QJE*) — método de extração de choques via heterocedasticidade.
- Rigobon & Sack (2004, *JME*) — aplicação a política monetária; eq. 9–11.
- Mertens & Ravn (2013, *AER*) — projeção GLS para recuperar série de choques de proxy.
- Wright (2012, *BPEA*) — choque heterocedasticidade-baseado em VAR mensal.
- Stock & Watson (2018, *EJ*) — proxy-SVAR em fatores; §4.7.
- Gonçalves, Rodrigues & Genta (2025, IMF WP) — aplicação ao Brasil; resolve a janela Wed→Thu pós-Copom.
- Alessi & Kerssenfischer (2019) — pipeline DFM com proxy-SVAR (replicado neste projeto).
- Gonçalves & Kilian (2004) — wild bootstrap recursive sob heterocedasticidade MD.

## Auditoria 2026-04-25 — Frente 1+2+3

`script/instrument_audit.R` testou três frentes de potencial atenuação:

**Frente 1 — agregação e maturidade.** A variável de política original na DFM era `juros_selic` (BCB série 4189, "Selic acumulada no mês"), uma variável **tipo fluxo**. A agregação por soma simples dos choques diários é apropriada apenas para alvos de **fim de período**; para fluxo, a ponderação Gertler-Karadi (D − d + 1)/D seria correta. Diagnóstico: tanto a soma simples quanto a ponderada GK falham contra `juros_selic` (F ≤ 2). O problema dominante é o **descasamento de maturidade**: a SVAR diária identifica um choque na DI 3m enquanto `juros_selic` é o overnight. Ponderação GK não compensa.

**Frente 2 — grid de maturidades mensais.** Testou 7 candidatos (juros_selic, juros_cdi, yield_3m a yield_5y) × 4 variantes do instrumento (z_het, z_het_gk, z_het_jk, z_het_jk_gk). Best F:

| Variante | Alvo | F | R² |
|---|---|---|---|
| z_het_jk | yield_6m | **21.3** | 0.190 |
| z_het_jk | yield_1y | 20.1 | 0.209 |
| z_het_jk | yield_2y | 19.5 | 0.162 |
| z_het    | yield_2y | 8.9 | 0.084 |
| z_het    | juros_selic | 1.1 | 0.012 |

**Frente 3 — filtro Jarociński-Karadi.** Ao zerar dias em que sign(ε̂_1) = sign(ΔIBOV) (information shocks), 42 / 97 dias de Copom são retidos como "pure monetary". O filtro JK aumenta o F em ~3× sobre yield_6m (de 7.6 para 21.3). É o ganho dominante da auditoria.

## Recomendação operacional

Usar **`z_het_jk_3var`** como instrumento e **`yield_6m`** (ou `yield_1y`) como `mp_var` para normalização do choque a 50 bps. A escolha 3-var (DI_3m, IBOV, BRL) sobre 4-var (que adiciona DI_2y) é motivada por dois números do diagnostics report (`output/instrument_diagnostics_report.md` §4.2 e §1):

- **rank-1 share = 0.987** no 3-var vs 0.840 no 4-var — espectro de ΔΣ muito mais limpo (eigenvalue gap 170× vs 5.4×);
- **F (y6m AR) = 55.98** no 3-var vs 21.29 no 4-var — instrumento materialmente mais forte na variável de política mensal.

Para normalização cosmética em `juros_selic` (replicando AK 2019), basta passar `mp_var = "juros_selic"` no `main_sdfm`, mas a relevância first-stage do instrumento já é validada via yield_6m.

Quatro variantes het ficam disponíveis em `data/processed/instrumentos_mensais.csv` e single-CSVs em `data/processed/instrument_z_het{,_jk}{,_3var}.csv`. Para usar:

```r
DEFAULT_VARIANT <- "z_het_jk_3var"   # script/instrument.R:25 (default atual)
```

Inferência: wild bootstrap recursive GK existente. Com F (y6m AR) ≈ 56 percentile bootstrap CIs são razoáveis; Anderson-Rubin não é necessário.

## Validação 2026-04-26 — Suite de robustez

`script/instrument_validation.R` (funções em `R/identification/validation_tests.R`) executa quatro testes sobre `z_het_jk + yield_6m`:

| Teste | Descrição | Resultado | Leitura |
|-------|-----------|-----------|---------|
| **T1 placebo** | permutação de `z_het_jk` mensal (n=2000) | F obs=21.29; mean F nulo=1.22; p=0.0005 | F=21 não é data-snooping |
| **T2 random-mask** | manter 42 dias Copom aleatórios (= k do JK) (n=2000) | F obs=21.29; mean F nulo=5.73; **q99=21.5**; p=0.0105 | filtro JK informativo, mas o gap é de um percentil — ver Blindspot |
| **T3 sub-period** | full / 2013-19 / 2020-25 / full−COVID-acute | 21.3 / 38.1 / 11.2 / 24.2 | identificação estável; até COVID+ passa Stock-Yogo (>10); **drop_covid > full** indica contaminação ativa do COVID acute |
| **T4 cor com z_jk_purif** | pearson/spearman em meses both-nonzero (n=36) | 0.93 / 0.94 | het-ID e timing-ID convergem; **het é subconjunto estrito de timing** (42 ⊂ 65 meses, com 36 em comum) |

**T2 framing honesto:** F obs=21.29 sits AT q99=21.5 (não acima); empirical p=0.0105 com SE binomial ≈0.0023 → CI95 ≈ [0.006, 0.015]. O sign filter JK é informativo mas o gap é de exatamente um percentil. Ao escrever paper, usar "JK F sits at the 99th percentile of random masks of equal size" em vez de "p ≈ 0.01 confirma" (otimista demais).

**Detalhe metodológico (não-trivial, confirmado por referee2 round 2):** o AR(p) de `yield_6m` é estimado **uma vez no full sample** e os resíduos são subset por janela. Refit dentro de cada janela introduz um bug em `drop_covid` (janela não-contígua: Out-2020 ficaria com lag-1 em Fev-2020). Implementado via `residualize_target()` + `first_stage_F(z, innov)` com guarda contra `z` constante.

Cross-language replication em Python (NumPy + statsmodels) bate com R a 6 decimais em todas as estatísticas determinísticas (F observado, F sub-período, correlações). Réplica em `correspondence/referee2/replication/referee2_replicate_validation.py`; relatório formal em `correspondence/referee2/2026-04-26_round2_report.md` (verdict: **Accept**).

### Validação 2026-05-06 — A3 sub-período + QLR

`script/instrument_het.R` (wrapper `run_het_window`) testa A3 (`B_d` constante) re-rodando a identificação 3-var em sub-amostras diárias 2013-2019 vs 2020-2025:

| sub-período   | n_C | rank-1 share | b_1[DI_3m] | b_1[IBOV] | b_1[BRL] |
|---------------|-----|--------------|-----------:|----------:|---------:|
| pre_covid     |  56 | 0.987        |  9.79      |  0.05     | -0.28    |
| covid_post    |  48 | 0.975        |  6.72      | -0.02     | -0.37    |

cosine(b_1_pre, b_1_post) = **1.000**; norm_ratio = **0.687**. Veredito **A3 sustained** — direção do impact column estável; magnitude no DI_3m cai 31% pós-COVID, consistente com BCB mais previsível sob arcabouço fiscal (2022+). A interpretação aceita: o choque de política tem mesma estrutura de transmissão; sua variância é menor pós-COVID. Outputs: `output/het_a3_b_1_pre_vs_post.csv`, `output/het_a3_summary.csv`, `output/het_b_1_{pre,post}_covid.csv`, `output/het_eigenvalues_*.csv`, `output/het_variance_validation_*.csv`.

`script/instrument_validation.R` (T8) executa Andrews (1993) QLR sup-F sobre o slope do first-stage:

```
innov_t = α + β·z_t + γ·D_τ + δ·(z_t · D_τ) + ε_t
```

com `D_τ = 1{t > τ}`, trim 0.15, HC0 Wald F sobre δ. **Resultado:** sup F = **6.88** em τ* = 2015-08, abaixo dos critical values Andrews (1993, Tab. 1, m=1, π_0=0.15): cv5 = 8.85, cv1 = 12.16. **Veredito: fail to reject.** Não há evidência formal de quebra estrutural no β do first-stage. O drop F do T3 (38.1 → 11.2) é melhor explicado pelo aumento mecânico de var(innov) pós-COVID (8.6e-6 → 3.1e-5, T4 var-by-window) do que por mudança de regime.

### Validação IRF cross-instrument 2026-05-06 — `z_het_jk_3var` vs `z_jk_purif`

`script/irf_cross_instrument.R` roda o DFM principal duas vezes (mesmo `r=q=8`, `p=6`, `mp_var=yield_6m`) trocando apenas o instrumento, com `nboot=800` e bandas concêntricas 68% / 90%. Painel-resposta de 9 variáveis em grid 3×3: `yield_{6m,2y,5y}`, `cambio_usd`, `asset_ibov`, `cds_5y`, `embi_perc`, `price_ipca`, `spread_icc_juridica`. Saídas: `output/irf_{zhetjk3var,zjkpurif,comparison}.pdf` + `output/irf_results_{zhetjk3var,zjkpurif}.rds`.

`script/build_grg_benchmark.R` converte os pontos h=0 para unidades GRG (per +50bp Δi(3m); `cambio_usd` BRL→% via baseline) e gera `output/grg_benchmark.csv`. Resumo dos pontos discriminantes:

| Variável         | `z_het_jk_3var` (50bp)   | `z_jk_purif` (50bp)      | GRG Δi(3m) (50bp) |
|------------------|--------------------------|--------------------------|--------------------|
| Δπ realized      | -0.102 [-0.439, +0.133]  | +0.020 [-0.323, +0.357]  | -0.13 a -0.345 (Δπᵉ break-even) |
| Δ(BRL/USD) %     | +2.17% [+0.07, +4.79]    | +5.84% [+3.04, +13.64]   | -2.55 (SE 0.375)  |
| Δ CDS_5y (raw)   | +1862 [+376, +4524]      | +5614 [+3429, +13468]    | -0.015 (n.s.)     |

**Findings discriminantes:**

1. **`z_het_jk_3var` recupera o canal de desinflação de GRG** (Δipca ≈ -0.10 pp ≈ GRG Δπᵉ 1y -0.13 pp); `z_jk_purif` produz Δipca ≈ 0 — evidência direta de que o filtro het+JK no diário extrai algo que o timing-ID puro não consegue. **Esta é a peça empírica que justifica `z_het_jk_3var` como spec principal do paper.**
2. **Sign reversal vs GRG em BRL/USD e CDS** (Real depreciation + CDS widening na contração) leitura: a agregação mensal do DFM captura GE/fiscal-dominance dynamics que o IV diário (24h window) perde por construção. Não é "GRG está errado"; são **objetos diferentes** (canal expectativas-imediato vs canal-mensal-propagado).
3. **Term-structure tight em todas as maturidades**, sem price puzzle.

Detalhamento e interpretação: `output/irf_section.md` (§5 standalone do paper). VAR overlay (Phase 2 do plano) deferido — `script/model_var.R` hard-coda `juros_selic` que falha Stock-Yogo com `z_het_jk`.

### Open questions resolvidas (Blindspot 2026-04-26)

Os 5 pontos abertos no Blindspot 04-26 estão fechados:

1. **Sensibilidade ao AR-order** ⇒ T7 (F estável p ∈ {3, 6, 12}).
2. **Anti-JK mask** ⇒ T5 (F = 0.194; JK é informativo, não esparsifica).
3. **Curva F(k_keep)** ⇒ T6 (k=80 nenhum random draw alcança JK F).
4. **Placebo + random-mask para `z_het` puro** ⇒ T2b (paired placebo: F obs 7.6 vs 21.3; ambos passam por permutação).
5. **Correlação T4 e var(innov) por sub-período** ⇒ T4 sub-período + var-by-window (cor estável; var(innov) ↑ 3.6× pós-COVID).

Pontos a destacar (não enterrar) no paper:

1. **drop_covid F > full F** como medida QUANTITATIVA de contaminação 2020-Q2/Q3 (remover meses MECANICAMENTE deveria reduzir F; sobe → contaminação ativa).
2. **Het-ID é subconjunto estrito de timing-ID**, não complementar. Os 29 meses onde só `z_jk_purif` dispara são candidatos a contaminação que `z_het_jk` rejeita.
3. **Heterogeneidade pre/post-COVID** (β +37%, SE +151%, R² estável) como achado sobre regime de comunicação BCB pós-2020, não nota de rodapé.
4. **Cross-language replication discipline** (R + Python a 6 decimais) em methods footnote.

Detalhe completo em `working-notes/2026-04-26_blindspot_validation.md`.
