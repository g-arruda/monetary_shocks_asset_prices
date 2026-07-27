# Instrumento.md — Construção do Instrumento Externo para o Proxy-SVAR/DFM

## Status (2026-07-15, troca de default + het fora do paper)

> **`DEFAULT_VARIANT = z_jk_bs_purif`** (decisão do autor, fechando a questão aberta na auditoria de 2026-07-14 abaixo): ortogonalização Bauer-Swanson fiel (preditores pré-evento predeterminados) + filtro JK nos sinais dos resíduos pré-evento. ξ_mp na produção (7,6): 10.43 full / 12.22 pre-COVID, ≥ 10 nas duas janelas (bandas padrão) — vintage 2026-07-24; a produção migrou de (6,5) → (7,6) nessa data (em (6,5) caiu para 6.36 full / 11.00 pre-COVID). Os corpos dos relatórios stage-2/coerência estão stale até re-rodar. Cadeia re-estimada na mesma data (sweep 480 células com as 4 variantes da auditoria, stage 2 com baseline (6,5) full, `model_alessi.R`, coerência nboot=800): história qualitativa preservada (curva ↑, BRL deprecia, EMBI/CDS abrem, corcova n.s. do IPCA), magnitudes ~30–45% menores que na rodada `z_jk_purif` (Ibov h0 −1.1% vs −8.9%; BRL +0.185 vs +0.245; EMBI +25bp vs +46bp); crédito e juros_cdi/selic melhoram de veredito na coerência. **Decisão editorial: o instrumento het (z_het\*) fica fora do paper** — pipeline mantido como diagnóstico interno; `relatorio/estrutura_paper_v2.md` atualizado. Pendências novas: bandas AR para o full, rewrite do §5/`irf_section.md` sob o novo primário.

## Status (2026-07-14, auditoria de fidelidade JK/BS)

> Auditoria contra os artigos e códigos originais (`relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md`) concluiu:
> 1. **JK**: regra zero-out e agregação por soma mensal fiéis; mas o poor man's original classifica e agrega valores **brutos** — o default `z_jk_purif` usa resíduos em ambos. Adicionada a variante literal **`z_jk_raw`** (máscara bruta + valores brutos), completando a matriz 2×2 máscara × valores.
> 2. **"Purificação Bauer-Swanson"**: o nome está impreciso — BS (2023, eq. 7/Table 3) regridem a surpresa em notícias **pré-anúncio** (releases macro + tendências financeiras de 13 semanas + trend), não em variações contemporâneas da janela. A regressão contemporânea SP500/VIX/Brent do projeto é uma limpeza de fator global (válida por exogeneidade de economia pequena, mas outro procedimento). Versão fiel adicionada: **`z_bs_purif`** / **`z_jk_bs_purif`** (preditores pré-evento: Δ65d de Ibov/SP500/VIX/Brent/BRL/inclinação DI + Δ20d Focus IPCA-12m e Selic + tendência; novos dados via `R/data_download/focus_fred.R`). Também testado **`z_jk_purif_us`** (contemporânea + UST 2y) — **inócuo** (cor 0.999 com o default).
> 3. **Força (ξ_mp, grid 392 células)**: a força vem da **máscara**, não dos valores purificados (cor ≥ 0.986 entre variantes de mesma máscara). Máscaras predeterminadas (bruta ou BS-pré-evento) excluem `2020-03-19` e dominam o default na amostra full em 14/14 células — full (6,5): `z_jk_raw` 7.05, `z_jk_bs_purif` 6.94 vs `z_jk_purif` 5.20; ambas cruzam ξ_mp ≥ 10 em 6/14 células full (default: 0). No pre_covid (6,5) o default segue líder (13.25; `z_jk_bs_purif` 12.49). **Default inalterado**; `z_jk_bs_purif` é o candidato metodologicamente mais limpo (BS fiel + máscara predeterminada + força competitiva nas duas amostras) — decisão de troca em aberto. *(Fechada em 2026-07-15: default trocado para `z_jk_bs_purif`, ver status acima.)*

## Status (2026-07-11, pós-varredura de especificações)

> A varredura sistemática (320 células: 8 instrumentos × 5 mp_vars × 4 grids (r,q) × 2 amostras; `script/irf_spec_sweep.R` + `script/irf_spec_stage2.R`) **confirma `z_jk_purif` como default** e refina três pontos do status 2026-05-08 abaixo:
> 1. "Único que cruza Stock-Yogo" era artefato do grid antigo (r fixo = 7): `z_jk_purif` cruza F (factor-sp) ≥ 10 no full em (6,5)/(7,6)/(8,8) — 10.08/10.17/11.76 — e `z_jk` cruza em (8,8). Na janela **pre_covid (2013-19) com (r=6, q=5), cinco instrumentos cruzam** (z_jk_purif 15.4, z_jk 15.2, z_het_jk_3var 11.1, z_het_3var 10.8, z_bruto_purif 10.4).
> 2. O auto-IC (r=5, q=4) usado por `model_alessi.R` é **borderline-weak** (9.20) — pendência aberta para migrar o caso base para (6,5) ou (7,6).
> 3. Zero células `sign_puzzle` no grid inteiro: F (factor-sp) ≥ 10 ⇒ sinais teoricamente coerentes, sem exceção. O diagnóstico de sinais invertidos está **fechado** — é weak-IV no espaço dos fatores, e nada mais.
>
> Detalhes: `output/irf/spec_sweep_conclusoes.md`, `relatorio/working-notes/2026-07-11_varredura_irf.md`.

## Status (2026-05-08, pós-investigação F factor-space)

> **Default revertido para `z_jk_purif` (GK timing-ID + Bauer-Swanson + JK).** A auditoria de 2026-04-25 (`output/instrument_audit_report.md`) recomendou `z_het_jk_3var` por F (y6m AR) = 55.98. A sessão 2026-05-08 reabriu a decisão: após o fix de unit scaling em `yield_6m` (LEVE 2026-05-07) expor as IRFs reais, ficou claro que F (y6m AR) **não** é a métrica relevante para proxy-SVAR sobre o DFM. A métrica relevante é F (factor-space) — max univariada sobre os q fatores dinâmicos `η = u K M⁻¹`, onde a projeção `H = (Z'η)/(Z'Z)` ocorre. Grid em `script/diagnose_factor_space_F.R` (q ∈ {2,3,4,6}) × (8 variantes) mostra: **`z_jk_purif` é o único variante que cruza Stock-Yogo F (factor-sp) ≥ 10 (= 10.17)**; `z_het_jk_3var` tem F (factor-sp) ≈ 2.7 — severamente fraco. **Default 2026-05-08:** `z_jk_purif` (em `script/instrument.R:25`) com `yield_6m` para normalização. `z_het_jk_3var` permanece como secondary spec em `script/irf_cross_instrument.R`. Documentação completa: `_instrucoes/Heteroscedasticidade.md` (rebaixamento para robustez), `_instrucoes/pendencias.md` (CRÍTICO 2026-05-08).
>
> **Validação completa (T1-T8, 2026-05-06):** `script/instrument_validation.R` executa oito robustezes:
> - **T1 placebo** (n=2000): F=21.3 não é data-snooping (p=0.0005);
> - **T2 random-mask k=42** (n=2000): JK F sits at q99 (p=0.0105 — gap de um percentil);
> - **T2b paired benchmark z_het puro**: F=7.61 (placebo p=0.008); ambos passam, gap reflete identificação no diário, não data-snooping;
> - **T3 sub-period**: F estável (10–38) em pre-COVID / COVID+post / drop_covid;
> - **T4 correlação com z_jk_purif** (n=36 both-nonzero): pearson 0.93, spearman 0.94 — het-ID e timing-ID convergem; cor estável 0.93–0.95 por sub-período (não mascara COVID);
> - **T5 anti-JK mask**: F = **0.194** sobre os 55 dias sign-equal "informacionais" — evidência direta de que JK não é só esparsificação;
> - **T6 F(k_keep) curva** k ∈ {20, 42, 60, 80}: p(F_random ≥ JK) = {0.034, 0.0095, 0.006, 0.000}; em k=80 nenhum random draw alcança JK F;
> - **T7 AR-order sensitivity** p ∈ {3, 6, 12}: F (full) = 20.7 / 21.3 / 22.4 — estável; AR(3) sub-residualiza no pre_covid;
> - **T8 Andrews (1993) QLR sup-F**: sup F = 6.88 em 2015-08, **fail to reject** vs cv5=8.85 — o drop F sub-period é mecânico (var(innov) cresce 3.6× pós-COVID), não quebra estrutural.
>
> Replicação cross-language R↔Python (T1-T4) bate a 6 decimais. Relatório referee2 round 2: **Accept**. Os 6 itens CRÍTICOS de `_instrucoes/pendencias.md` foram fechados nos commits `4e2192f` (críticos 1-3) e `a3af0e4` (críticos 4-6 + DEFAULT_VARIANT).
>
> **Validação IRF (2026-05-06 tarde, commit `26d9dce`):** `script/irf_cross_instrument.R` roda `main_sdfm` 2× (z_het_jk_3var, z_jk_purif), nboot=800, bandas 68/90, 9-painel grid 3×3. Findings discriminantes: (i) `z_het_jk_3var` recupera Δπ desinflação de GRG (-0.10 pp ≈ GRG -0.13); `z_jk_purif` falha. (ii) BRL e CDS divergem em sinal vs GRG — fiscal-dominance leitura no mensal vs daily IV. Detalhamento: `output/irf_section.md` + `output/grg_benchmark.csv`. **Item 7 de pendências fechado — toda a seção MÉDIO está completa.**
>
> **Framing operativo (council Required 3):** o instrumento `z_het_jk_3var` é uma **identificação híbrida** het+timing+sign — não het-ID puro. A condição operativa no proxy-SVAR mensal é a *exclusion restriction* `E[z_het_jk_m · η_t^j] = 0` (Stock-Watson 2018 §4.7), não A1-A3 conjuntas (que falham pelos 57% wrong-sign no diário).
>
> Este documento permanece como referência para as 4 variantes GK legacy (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`), que continuam sendo construídas por `script/instrument.R` e usadas como benchmark na comparação cross-instrument do diagnostics.

## Objetivo

Construir um instrumento externo baseado em surpresas de DI futuro nos dias pós-Copom para identificação de choques monetários no proxy-SVAR do DFM. O pipeline de estimação (painel → fatores → VAR nos fatores → identificação por instrumento externo → IRFs) **já existe e não deve ser alterado**. Este documento trata exclusivamente da construção do instrumento $z_t$ que alimenta o primeiro estágio.

O produto desta linha são **seis variantes** do instrumento mensal, mantidas como benchmark:

1. **$z^{bruto}_t$** — surpresa de DI pós-Copom agregada mensalmente (sem filtro)
2. **$z^{purif}_t$** — surpresa de DI purificada por SP500/VIX/Brent (Bauer-Swanson)
3. **$z^{JK}_t$** — surpresa de DI apenas nos dias com co-movimento negativo DI×Ibovespa (filtro Jarociński-Karadi)
4. **$z^{JK,purif}_t$** — combinação dos dois filtros (a classificação JK usa os sinais dos *resíduos* — ordem "purificação → JK")
5. **`z_jk_raw_purif`** *(2026-07-14)* — máscara JK nos sinais **brutos** (`delta_di` × `r_ibov`), valores purificados — ordem inversa "JK → purificação"
6. **`z_jk_raw_purif_local`** *(2026-07-14)* — idem, com a regressão de purificação re-estimada só nos dias selecionados (dominada pela 5; mantida como descritor)
7. **`z_jk_raw`** *(2026-07-14, auditoria)* — JK **literal**: máscara bruta + valores brutos, sem purificação
8. **`z_bs_purif`** *(2026-07-14, auditoria)* — resíduo da regressão pré-evento fiel a BS (sem filtro JK)
9. **`z_jk_bs_purif`** *(2026-07-14, auditoria)* — máscara JK nos sinais dos resíduos pré-evento + valores pré-evento
10. **`z_jk_purif_us`** *(2026-07-14, auditoria)* — purificação contemporânea com Δ(UST 2y) adicionado (redundante; descartável)

---

## Etapa 1 — Coleta de Dados

### 1.1 Surpresas de alta frequência (diário, preço de fechamento)

- **DI futuro — vértice curto (~3 meses):** Swap DI×Pré 90 dias da B3.
  - `data/di.csv` (verificar se é o mesmo)
  - Unidade: taxa em % a.a. (252 d.u.)

- **Ibovespa (IBOV):** índice de fechamento diário.
  - Esta dentro da base: `data/raw_data.csv`, verificar se teve transformaçao em: `script/download.R`
  - Unidade necessaria: retorno percentual diário

### 1.2 Calendário do Copom

- `data/copom_historico.csv`
- Extrair todas as datas de decisão do Copom (quarta-feira)
- Janela de evento: **quarta (fechamento) → quinta (fechamento)**
- Criar dummy: `copom_day = 1` para as quintas-feiras pós-Copom

### 1.3 Fatores externos (para purificação)

Séries diárias, mesmo período, variação quarta → quinta:

- **S&P 500:** Yahoo Finance (`^GSPC`)
- **VIX:** Yahoo Finance (`^VIX`)
- **Petróleo Brent:** Yahoo Finance (`BZ=F`)

### 1.4 Datas FOMC

- Coletar datas de decisão do FOMC no período
- Criar dummy `fomc_coincide = 1` para semanas com Copom e FOMC simultâneos (~32 ocorrências)

---

## Etapa 2 — Surpresas Brutas

Para **toda quinta-feira** da amostra:

```
ΔDI_t   = DI_fecha(quinta) - DI_fecha(quarta)                          [pontos-base]
ΔIbov_t = 100 × [ln(Ibov_fecha(quinta)) - ln(Ibov_fecha(quarta))]      [log-retorno %]
```

Salvar dataframe: `date`, `delta_di`, `delta_ibov`, `copom_day`, `fomc_coincide`.

---

## Etapa 3 — Purificação por Fatores Externos

Estimar na **amostra completa** (todas as quintas-feiras):

```
ΔDI_t   = a0 + a1·ΔSP500_t + a2·ΔVIX_t + a3·ΔBrent_t + e_DI_t
ΔIbov_t = b0 + b1·ΔSP500_t + b2·ΔVIX_t + b3·ΔBrent_t + e_Ibov_t
```

Produto: resíduos `e_DI_t` e `e_Ibov_t` — surpresas purificadas.

> **2026-07-14 (auditoria):** esta regressão usa variações **contemporâneas** da mesma janela qua→qui — é uma limpeza de fator global (justificada pela exogeneidade de economia pequena), **não** a ortogonalização de Bauer-Swanson, que usa apenas preditores **pré-anúncio**. A versão fiel a BS (Δ65d financeiro + Δ20d Focus + tendência, tudo predeterminado na quarta) está implementada em `script/instrument.R` como `e_di_bs`/`e_ibov_bs` (variantes `z_bs_purif`, `z_jk_bs_purif`; insumos de `R/data_download/focus_fred.R`). Nunca incluir variáveis domésticas contemporâneas (BRL, EMBI, curva DI da janela) — bad control.

---

## Etapa 4 — Diagnóstico

### 4.1 Scatterplot

Plotar `e_DI_t` (eixo x) vs. `e_Ibov_t` (eixo y) **apenas nos dias Copom**.

Quadrantes:
- **II e IV** (co-movimento negativo): consistente com choque monetário puro
- **I e III** (co-movimento positivo, "wrong-signed"): evidência de choque informacional do BCB

Reportar proporção de wrong-signed:
- \>25%: filtro JK fortemente motivado
- 15-25%: filtro JK defensável
- <10%: filtro JK provavelmente desnecessário, usar surpresa bruta

**Resultado observado (2013-01–2025-12):** ~31.6% wrong-signed nos resíduos purificados — filtro JK fortemente motivado. Isso explica em parte o ganho dramático ao aplicar JK também sobre o instrumento por heterocedasticidade (`z_het_jk` triplica o F sobre `yield_6m` vs `z_het` puro).

Salvar figura: `output/scatterplot_surpresas_copom.png`

### 4.2 Testes de variância

Testar (teste F, razão de variâncias, IC 99%):

| Variável | H0 | Esperado |
|---|---|---|
| `e_DI` | Var(Copom) = Var(não-Copom) | **Rejeitar** — variância maior em dias Copom |
| `e_Ibov` | Var(Copom) = Var(não-Copom) | Idealmente não rejeitar |

Formato de reporte: replicar Tabela 1 de Gonçalves, Rodrigues & Genta (2025).

---

## Etapa 5 — Construção dos Instrumentos

### 5.1 Instrumento bruto (sem filtro JK)

Para cada mês $t$:

```
z_bruto_t = Σ ΔDI_τ     para todo τ ∈ {dias Copom do mês t}
z_bruto_t = 0            se não houve Copom no mês t
```

Variante purificada: usar `e_DI_τ` em vez de `ΔDI_τ`.

### 5.2 Instrumento JK (com filtro por co-movimento)

Classificar cada dia Copom:

```
Se (e_DI > 0 e e_Ibov < 0) ou (e_DI < 0 e e_Ibov > 0):
    → classificar como "choque monetário"
    → manter e_DI_τ

Se (e_DI > 0 e e_Ibov > 0) ou (e_DI < 0 e e_Ibov < 0):
    → classificar como "choque informacional"
    → zerar: e_DI_τ = 0
```

Agregar mensalmente:

```
z_JK_t = Σ e_DI_τ     para todo τ ∈ {dias Copom monetários do mês t}
z_JK_t = 0            se não houve Copom monetário no mês t
```

### 5.2b Por que soma, e não a ponderação de Gertler-Karadi (2026-07-27)

A soma dentro do mês é o esquema de **Jarociński-Karadi** (2020, §II.A: "*To
construct m_t we add up the intraday surprises occurring in month t on the days
with FOMC announcements*"), e é também o que o código do **Bauer-Swanson** faz.
O **Gertler-Karadi** (2015, nota 11) usa outro: cumular as surpresas num nível
diário → média mensal → primeira diferença, o que pondera por posição no mês.

O GK enuncia a própria motivação **de forma condicional**: a ponderação existe
porque o indicador de política deles é uma **média mensal** ("*as we use monthly
average rates (not end of the month rates) for our monetary policy
indicators…*"). Aqui `yield_6m` é observação de **fim de mês**
(`script/download.R:49-53`, `slice_tail(n = 1)`), caso em que uma surpresa em
qualquer dia de `t` já está integralmente refletida no valor de `t` — que é
exatamente o que a soma assume.

Medido em 2026-07-27 (`script/instrument_construction_sweep.R`): sob GK o ξ_mp
cai de **10,43 para 0,30** no vértice de produção e não cruza 3,84 em nenhum
vértice na amostra completa. Além disso, sob GK os meses sem reunião **deixam de
ser zero** (a propriedade que JK e BS assumem) e o esquema induz **MA(1)**, o que
invalidaria `NWlags = 0` no bloco Wald. **A soma fica.**

### 5.3 Output final

Salvar `data/processed/instrumentos_mensais.csv` com colunas (incluindo as duas variantes por heterocedasticidade adicionadas posteriormente):

| month | z_bruto | z_bruto_purif | z_jk | z_jk_purif | z_het | z_het_jk |
|---|---|---|---|---|---|---|

As primeiras quatro são produzidas por `script/instrument.R`; `z_het` e `z_het_jk` por `script/instrument_het.R` (ver `_instrucoes/Heteroscedasticidade.md`). Qualquer variante pode ser plugada no proxy-SVAR existente via `DEFAULT_VARIANT` em `script/instrument.R`.

> **2026-07-14 — ordem purificação ↔ JK:** constatou-se que o pipeline acima já é "purificação → JK" (a classificação da §5.2 usa os sinais dos *resíduos*). Duas variantes com a ordem inversa (máscara JK nos **sinais brutos** `delta_di` × `r_ibov`, purificação depois) foram adicionadas a `script/instrument.R`: `z_jk_raw_purif` (valores = `e_di` da regressão de painel completo) e `z_jk_raw_purif_local` (regressão re-estimada só nos dias selecionados). No grid MOSW, `z_jk_raw_purif` domina `z_jk_purif` em ξ_mp na amostra **full** (13/14 células; único GK a cruzar 10 em células full) — a máscara bruta exclui `2020-03-19` (pânico COVID classificado como monetário pela máscara residual) — mas perde no pre_covid (6,5) (10.80 vs 13.25); default inalterado, `z_jk_raw_purif` vira robustez full-sample e a `_local` foi descartada (dominada). Detalhes: `relatorio/working-notes/2026-07-14_ordem_purificacao_jk.md`.

---

## Etapa 6 — Teste de Força do Instrumento

Para cada variante de $z_t$:

- Plugar no proxy-SVAR/DFM existente como instrumento externo
- Computar estatística F efetiva de Montiel Olea, Stock & Watson (2021)
- Implementação: `script/instrument_diagnostics.R` (regride contra `dfm$var_residuals[, 1]`) e `script/instrument_audit.R` (regride contra a inovação AR(6) de cada candidato a variável de política mensal — útil quando o alvo de normalização não é o primeiro fator).

**Critérios:**
- **F > 10:** inferência padrão válida
- **F ∈ [5, 10]:** usar intervalos Anderson-Rubin (robustos a instrumento fraco)
- **F < 5:** instrumento fraco

> **2026-05-08:** três F são reportados em `script/instrument_diagnostics.R` lado-a-lado: F (DFM) (resíduo do primeiro fator, OSW), F (y6m AR) (relevância univariada Selic-equivalente) e **F (factor-sp)** (max sobre os q fatores dinâmicos — métrica que governa o viés na projeção do proxy-SVAR `H = (Z'η)/(Z'Z)`). **F (factor-sp) é o relevante** para validar uma variante como instrumento do DFM. F (y6m AR) e F (factor-sp) podem divergir em 20× (ex: `z_het_jk_3var` tem F (y6m AR) = 56 e F (factor-sp) = 2.7).

**Resultados observados na amostra 2013-01–2025-12 (sessão 2026-05-08):**

| Variante         | F (y6m AR) | F (factor-sp) | Veredito |
|------------------|-----------:|--------------:|----------|
| z_bruto          |     ~5     |   4.19        | fraco em ambos |
| z_bruto_purif    |     ~5     |   5.10        | fraco em ambos |
| z_jk             |     ~9     |   8.41        | limite em ambos |
| **z_jk_purif**   |  **11.4**  | **10.17** ✓   | **forte em ambos — default 2026-05-08** |
| z_het            |     ~8     |   3.07        | forte em y6m AR, fraco em factor-sp |
| z_het_jk         |    21.3    |   6.89        | forte em y6m AR, limite em factor-sp |
| z_het_3var       |     —      |   1.11        | severamente fraco em factor-sp |
| z_het_jk_3var    |   55.98    |   2.74        | forte em y6m AR, **severamente fraco em factor-sp** (era default 2026-05-05) |

✓ = único cruzando Stock-Yogo F (factor-sp) ≥ 10. Grid completo (q ∈ {2,3,4,6}) × (8 variantes) em `output/instrument/factor_space_F_grid.csv`. Tabela detalhada (F (DFM) + F (y6m AR) + F (factor-sp) + flag WEAK-FACT por variante) em `output/instrument/instrument_diagnostics_report.md` §1.

Tabela legacy (4 variantes het × 7 candidatos a alvo, contra inovação AR(6) de cada candidato) permanece em `output/instrument_audit_grid.csv`.

---

## Etapa 7 — Comparação de IRFs

Estimar IRFs no DFM usando cada variante do instrumento. A comparação central é:

1. **$z^{bruto}_t$** vs. **$z^{JK}_t$**: o filtro JK muda as IRFs? Se sim, a decomposição importa — essa é a contribuição empírica principal.
2. **Sem purificação** vs. **com purificação por fatores externos**: a limpeza do componente global importa?

Variáveis de resposta: taxa de câmbio (BRL/USD), Ibovespa, spreads corporativos, CDS Brasil, curva de juros (DI longo), break-even inflation.

Horizonte: 0 a 24 meses. Bandas: 68% e 90%.

---

## Etapa 8 — Robustez

1. ~~**Vértice do DI:** substituir DI 3m por DI 6m e DI 12m~~ — **feito em
   2026-07-27**, e mais amplo do que o prescrito: 13 vértices de 21 a 504 du ×
   2 esquemas de agregação × 5 variantes × 2 janelas, sob **ξ_mp** (a régua
   corrente; o item foi escrito na era em que o baseline era 3m e a régua era o
   F legado). `script/instrument_construction_sweep.R` →
   `output/instrument/instrument_construction_sweep.{csv,md}`.
   **Resultado:** 126 du (produção) **não** é o argmax em nenhuma janela, mas
   nenhum desafiante vence por margem maior que a dispersão leave-one-month-out
   do próprio ξ_mp (maior margem 1,16 contra limiar 2,00), então o vértice **não
   é identificado com precisão suficiente para escolher** e a produção fica.
   E, o que importa mais: **os 13 vértices dão essencialmente a mesma IRF**,
   dentro da banda de 68% em quase todo horizonte
   (`output/instrument/vertex_irf_overlay.pdf`, análogo da Figura A4 de
   Alessi-Kerssenfischer). Ver a §5.2b acima para o eixo de agregação.
2. **Excluir datas FOMC coincidentes** (dropar observações com `fomc_coincide = 1`)
3. **Subamostras temporais:** janelas móveis de 10 anos (2009-2019, ..., 2014-2024)
4. **Threshold de classificação:** excluir dias Copom com surpresas próximas de zero (dentro de ±1 d.p. de um dia não-Copom típico) para reduzir ruído na classificação JK

---

## Escreva um relatório em .md

---

## Referências para implementação

- **Instrumento base (surpresas de DI):** Gertler & Karadi (2015, AEJ:Macro) — lógica do proxy-SVAR com surpresas de futuros
- **Filtro JK:** Jarociński & Karadi (2020, AEJ:Macro) — classificação por co-movimento, restrições de sinal
- **Purificação:** Bauer & Swanson (2023, AER) — controle por fatores pré-anúncio
- **Identificação por heterocedasticidade (estratégia atual):** Rigobon (2003, *RES*); Rigobon & Sack (2003 *QJE*; 2004 *JME*); Stock & Watson (2018, *EJ*) §4.7
- **Recuperação do choque por GLS:** Mertens & Ravn (2013, *AER*) §II.B
- **Contexto brasileiro:** Gonçalves, Rodrigues & Genta (2025, IMF WP/25/48) — janela Wed→Thu, dados de DI, testes de Rigobon
- **Teste de instrumento fraco:** Montiel Olea, Stock & Watson (2021, *JoE*) — estatística F robusta
- **DFM + proxy-SVAR:** Alessi & Kerssenfischer (2019) — "The Response of Asset Prices to Monetary Policy Shocks: Stronger than Thought" — pipeline de estimação replicado neste projeto
- **Wild bootstrap sob heterocedasticidade MD:** Gonçalves & Kilian (2004)

---

## Informaçoes importantes:

- Todos os artigos de referencia podem ser encontrados em: `artigos/`
- o trabalho de JK ja tem o script original dos autores, mas em matlab em: `codigo_Jarocinski_e_Karadi`
- Os testes do artigo de Montiel Olea, Stock & Watson, ja foram implementados em: `script/instrument_diagnostics.R`
- Código original dos autores Bauer & Swanson em: `codigo_bauer_swanson/`

