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

A1 é diagnosticável: o teste é a Tabela 1 do GRG, replicado pelo `validate_variance_split` (razão de variâncias com IC bootstrap 99%). A2 também: razões devem incluir 1 nos demais choques.

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

- **Seção 1** — comparação first-stage F dos 6 instrumentos contra o **primeiro fator dinâmico do DFM** (HC0, partial F, Olea-Stock-Watson ξ_1). NB: este alvo é o do AK 2019; a relevância first-stage para a interpretação Selic-equivalente vem do `script/instrument_audit.R` que regride contra inovações AR(6) de candidatos a variável de política mensal.
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

Usar **`z_het_jk`** como instrumento e **`yield_6m`** (ou `yield_1y`) como `mpind` para normalização do choque a 50 bps. Para normalização cosmética em `juros_selic` (replicando AK 2019), basta passar `mpind = which(colnames(X) == "juros_selic")` no `compute_irf_dfm`, mas a relevância first-stage do instrumento já é validada via yield_6m.

Tanto `z_het` (sem filtro, soma simples) quanto `z_het_jk` (com filtro JK) ficam disponíveis em `data/processed/instrumentos_mensais.csv` e em `data/processed/instrument_z_het{,_jk}.csv`. Para usar:

```r
DEFAULT_VARIANT <- "z_het_jk"   # script/instrument.R:25
```

Inferência: wild bootstrap recursive GK existente. Para o caso `yield_6m` com F = 21, percentile bootstrap CIs são razoáveis; Anderson-Rubin não é necessário.
