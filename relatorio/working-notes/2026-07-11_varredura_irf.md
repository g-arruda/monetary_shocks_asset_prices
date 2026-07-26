# Varredura sistemática de especificações IRF — relatório didático

> **⚠️ SUPERADA — banner de 2026-07-26.** Escrita sob `z_jk_purif` × (6,5), vintage pré-refresh.
> **Sobrevive:** a taxonomia didática das três Fs de primeiro estágio (§2) e o desenho do grid.
> **Morreu:** as duas recomendações-manchete — o default foi trocado por `z_jk_bs_purif` em
> 2026-07-15 e a produção migrou para (7,6) em 2026-07-24; e todo o conteúdo het (§4.3, §5, §6.4).
> **⚠️ CONTRADITADA:** a afirmação central "sempre que F ≥ 10 os sinais hard saem coerentes" é
> contrariada por `2026-07-15_sweep_instrumentos_irf.md` (0 de 36 células limpas,
> `cor(curve_slope, ξ_mp) = −0,04`). A nota de 07-15 vence na evidência — inspeciona trajetórias
> inteiras, não só sinais no impacto. Ver `_instrucoes/historico_decisoes.md` §6.


**Data:** 2026-07-11
**Scripts novos:** `script/irf_spec_sweep.R` (Etapa 1), `script/irf_spec_stage2.R` (Etapa 2), `R/identification/spec_sweep.R` (helpers)
**Relatórios gerados:** `output/irf/spec_sweep_report.md`, `output/irf/spec_sweep_stage2.md`, `output/irf/spec_sweep_conclusoes.md`

---

## 1. O problema que motivou a varredura

As IRFs do DFM (`script/model_alessi.R`) vinham produzindo respostas inconsistentes
com a teoria em algumas configurações: instrumentos que geravam sinais invertidos
(preço de ativo subindo após choque contracionário) e magnitudes implausíveis.
A pergunta era: **existe alguma combinação instrumento × parametrização que produza
IRFs teoricamente coerentes — e de forma robusta, não por acaso de uma única
especificação?**

A sessão de 2026-05-08 já havia diagnosticado *um* caso (o `z_het_jk_3var`):
instrumento fraco no espaço dos fatores. A varredura de hoje generaliza esse
diagnóstico para **todo o espaço de especificações** e o transforma em resposta
fechada.

## 2. Conceito central: os três "F" e por que só um deles importa aqui

Para entender a varredura é preciso distinguir três estatísticas de relevância
de primeiro estágio que o projeto reporta:

1. **F (y6m AR)** — regressão da inovação AR(6) do `yield_6m` mensal no
   instrumento. Mede relevância *univariada* ("o instrumento move a taxa de 6
   meses?"). É o F que motivou a escolha original do `z_het_jk_3var` (F ≈ 56).
2. **F (DFM)** — contra o resíduo do primeiro fator do VAR.
3. **F (factor-space)** — o máximo do F sobre as **q regressões das inovações
   fatoriais** `η = u K M⁻¹` no instrumento (`compute_factor_space_F`,
   `R/modeling/impulse_responde.R:135`).

A identificação proxy-SVAR do DFM projeta o instrumento pelas inovações
fatoriais: `H = (Z'η)/(Z'Z)` (`ident_ext_instr`). Portanto **o viés de
instrumento fraco é governado exclusivamente pelo F (factor-space)** — o
instrumento pode "mover o yield_6m" com F = 56 e ainda assim ser quase ruído
no espaço onde a projeção acontece. Quando isso ocorre, o vetor `H` é
dominado por ruído amostral, e a normalização (dividir todas as IRFs pelo
impacto da variável de política, `irf_mp / irf_mp[mpind,1] * 0.005`) amplifica
e eventualmente **inverte** todos os sinais de uma vez. Essa é a mecânica dos
"sinais invertidos".

## 3. Desenho da varredura

### 3.1 Dimensões (320 células)

| dimensão | valores | racional |
|---|---|---|
| instrumento | 8 colunas de `instrumentos_mensais.csv` (z_bruto, z_bruto_purif, z_jk, z_jk_purif, z_het, z_het_jk, z_het_3var, z_het_jk_3var) | todas as variantes do projeto |
| mp_var | yield_3m, yield_6m, yield_1y, yield_2y, juros_selic | vizinhança plausível do vértice de 6m; juros_selic como controle negativo documentado |
| (r, q) | (5,4) auto-IC, (6,5), (7,6), (8,8) | em torno da escolha Bai-Ng IC2 / Amengual-Watson (5,4) até a spec de produção (8,8); p = 6 fixo |
| amostra | full (2013-01–2025-09) e pre_covid (2013-01–2019-12) | janelas **contíguas apenas** — máscara com buraco COVID quebraria a estrutura de lags do VAR (bug já documentado no repo) |

### 3.2 O truque de custo: cache de DFM + `nboot = 0`

A observação-chave é que `estimate_dfm` depende só de (painel, r, q, p) — **não**
do instrumento nem da mp_var. Então a Etapa 1 estima apenas
**8 DFMs** (4 grids × 2 amostras) e avalia as 320 células por cima com operações
baratas:

- `diagnose_instrument_in_factor_space()` → F (factor-space), impacto
  pré-normalização da mp_var (o denominador da normalização), sinal;
- `compute_irf_dfm(nboot = 0)` → IRF ponto-estimativa até h = 24 (o `nboot = 0`
  curto-circuita o bootstrap, que é o único passo caro);
- `first_stage_F(residualize_target(mp_var, 6), z)` → F reduzido HC0 por
  mp_var e janela.

A Etapa 1 inteira roda em segundos. O bootstrap completo (Etapa 2) só é gasto
nas células vencedoras.

### 3.3 Sistema de pontuação de coerência teórica

Cada célula recebe scores contra os sinais esperados de um choque
contracionário de +50bp:

- **hard** (h = 0): yield_6m ↑, yield_2y ↑, yield_5y ↑, asset_ibov ↓.
  A própria mp_var da célula é **excluída do score** — seu impacto é
  mecanicamente igual a +50bp pela normalização, então contá-lo inflaria o
  score.
- **ext** (h = 24, canal de transmissão): price_ipca ↓, pib ↓, vendas_varejo ↓.
- **soft** (registrado, nunca penalizado): cambio_usd, cds_5y, embi_perc.
  Motivo: o projeto já documentou (irf_section.md) que a depreciação + abertura
  de risco na contração é interpretável como canal de **dominância fiscal** —
  penalizar esse sinal pré-julgaria a questão econômica. A varredura registra o
  *canal* (apreciação/depreciação, standard/fiscal_dominance) como dado.

### 3.4 Taxonomia de falhas (mutuamente exclusiva, primeira que casa)

1. `estimation_failed` / `no_variation_in_window` — mecânicas;
2. `negative_control` — mp_var = juros_selic (mismatch de maturidade conhecido);
3. `weak_factor_space` (F < 10; `_severe` se F < 5) — a classe do weak-IV;
4. `unstable_normalization` — F ok mas |denominador da normalização| < 10% da
   mediana do grupo (dividir por ≈ 0 explodiria as magnitudes);
5. `sign_puzzle` — F ok, denominador ok, e ainda assim sinais hard errados
   (seria a classe "interessante": problema não-explicado);
6. `ok` — elegível para ranking.

## 4. Etapa 1 — resultados

### 4.1 Validação contra números conhecidos (a varredura reproduz o passado)

| número esperado | fonte | obtido |
|---|---|---|
| F factor-sp = 10.17 (full, r=7, q=6, z_jk_purif) | `factor_space_F_grid.csv` | 10.17 ✓ |
| F factor-sp = 9.20 (full, r=5, q=4, z_jk_purif) | HANDOFF 2026-05-08 | 9.20 ✓ |
| F(y6m) ≈ 56 com F factor-sp ≈ 2.7 (z_het_jk_3var full) | pendencias CRÍTICO | 55.1 / 2.74 ✓ |
| juros_selic F < ~2 | justificativa_uso_yield-6m.md | máx 2.49, mediana 0.44 ✓ |
| ponto idêntico ao RDS de produção (full r8q8 z_jk_purif, seed 123) | `irf_results_zjkpurif.rds` | cds 5614.141, cambio 0.2400041 — **idênticos** ✓ |

### 4.2 O resultado que fecha o diagnóstico

Das 320 células: **208 `weak_factor_space`** (65%), **64 `negative_control`**,
**48 `ok`** — e **zero** `sign_puzzle`, **zero** `unstable_normalization`.

Leitura didática: *toda vez* que o instrumento é forte no espaço dos fatores
(F ≥ 10), os sinais hard saem corretos — em qualquer instrumento, mp_var,
(r, q) e amostra. Não existe célula em que a identificação é forte e os sinais
falham. Logo:

- sinais invertidos = instrumento fraco no espaço dos fatores (mecânico);
- normalização incorreta: **descartada** (denominador nunca chegou perto de 0;
  razão mínima ≈ 0.29 da mediana);
- "fator mal identificado": **descartado** como causa independente — o mesmo
  DFM produz sinais certos ou errados dependendo só do instrumento.

### 4.3 O mapa de força (F factor-space, mp-invariante)

**Full sample** — só a família JK cruza o limiar:

| instrumento | r5q4 | r6q5 | r7q6 | r8q8 |
|---|---|---|---|---|
| z_jk_purif | 9.20 | **10.08** | **10.17** | **11.76** |
| z_jk | 7.72 | 8.27 | 8.41 | **10.25** |
| demais (bruto/het) | 2.4–9.3 | — | — | — |

**Pre_covid (2013-2019)** — (r=6, q=5) é o pico do grid inteiro:

| instrumento | r5q4 | r6q5 | r7q6 | r8q8 |
|---|---|---|---|---|
| z_jk_purif | 10.79 | **15.40** | 9.61 | 8.07 |
| z_jk | 10.54 | **15.17** | 10.45 | 7.99 |
| z_het_jk_3var | 5.99 | **11.13** | 3.95 | 2.65 |
| z_het_3var | 7.65 | **10.83** | 9.14 | 6.58 |
| z_bruto_purif | 7.70 | **10.38** | 5.79 | 5.63 |

Dois achados novos aqui:

1. **A fraqueza dos instrumentos het não é estrutural** ao esquema de
   identificação Rigobon-Sack: em pre_covid (6,5) eles cruzam Stock-Yogo.
   É a amostra COVID+pós que os destrói (consistente com o T4 do projeto:
   var(innov) cresce 3.6× pós-COVID).
2. **z_jk_purif deixa de ser "o único"**: a família JK cruza em três grids no
   full sample, e cinco instrumentos cruzam em pre_covid (6,5). A frase "único
   que cruza Stock-Yogo" era um artefato do grid antigo (r fixo em 7).

### 4.4 Resposta à decisão aberta do HANDOFF (r=7,q=6 vs auto r=5,q=4)

- (5,4) auto-IC fica **weak no full sample** (9.20) — não deve ser o caso base;
- (6,5), (7,6) e (8,8) são equivalentes em coerência no full; F cresce com a
  dimensão (10.08 / 10.17 / 11.76);
- **(6,5) tem o argumento decisivo**: é a única escolha `ok` no full que também
  é o máximo do pre_covid (15.4) — permite usar o mesmo (r,q) nas duas janelas.

## 5. Etapa 2 — bootstrap nos vencedores

Seleção: células `ok` com mp_var = yield_6m (fixada para comparabilidade),
ranqueadas por score e F, máx. 2 por instrumento, top-5 + baseline atual
(full, r=7, q=6, z_jk_purif) — 6 células, nboot = 800, seed 123, bandas 68/90.

| célula | hard CI90 ≠ 0 | destaque |
|---|---|---|
| pre_covid r6q5 z_jk_purif | **3/3** | IBOV −0.14 [−0.27, −0.06]; câmbio +0.07 n.s. |
| pre_covid r6q5 z_jk | **3/3** | quase idêntica — purificação pouco muda pre-COVID |
| full r8q8 z_jk_purif | **3/3** | ponto = RDS de produção (verificação) |
| full r7q6 z_jk_purif (baseline) | **3/3** | depreciação +0.25 BRL **significante** |
| pre_covid r6q5 z_het_jk_3var | 0/3 | sinais certos no ponto; bandas largas (F ≈ 11) |
| pre_covid r6q5 z_het_3var | 0/3 | **única célula com apreciação cambial** |

### 5.1 Magnitudes — o "implausível" era em parte unidade

- `cds_5y` está no painel em escala ×100 (range 9 911–48 899): o impacto de
  ≈ +4 100 lê-se **+41bp** — plausível.
- `cambio_usd` é **nível** BRL/USD (range 1.97–6.10), não log: +0.24 no full
  ≈ **+5%** de depreciação (grande, significante); +0.07 no pre_covid ≈ +2%
  (não significante).
- IBOV: −9% a −14% no impacto, com reversão rápida — dentro das bandas.
- Curva: no full, yield_2y/5y respondem ~2× o choque de 50bp (amplificação —
  `yield_ordering_ok = FALSE`); só `z_het_3var` pre_covid entrega a ordenação
  amortecida livro-texto |y5y| < |y2y| < |y6m|.

### 5.2 Canal cambial: dominância fiscal não é universal

44 das 48 células elegíveis mostram depreciação + CDS/EMBI abrindo (canal de
dominância fiscal). As **4 exceções são todas `z_het_3var` pre_covid (6,5)** —
apreciação, desinflação e ordenação amortecida, i.e. o canal "standard" de
GRG (2025). Sem significância (bandas largas), mas é o único candidato do grid
para essa narrativa e merece menção como robustez qualitativa.

## 6. Conclusões operacionais

1. **Manter `z_jk_purif` + `yield_6m` como primária.** A varredura confirma a
   decisão de 2026-05-08 e a torna mais forte: agora com bandas 3/3 em três
   grids no full sample.
2. **Migrar o caso base para (r, q) = (6, 5)** (ou manter (7,6)); documentar
   que o auto-IC (5,4) é borderline-weak. Isso fecha o item aberto do HANDOFF.
3. **Adicionar a janela pre_covid (6,5) como robustez cross-instrumento** —
   5 instrumentos, 2 esquemas de identificação independentes, mesmos sinais.
4. **Het variants**: úteis como confirmação qualitativa (e como único canal de
   apreciação); se entrarem no paper, com bandas Anderson-Rubin (weak-IV
   robust), como o HANDOFF já sugeria.
5. **juros_selic** segue vetado como mp_var (controle negativo confirmado).

## 7. Arquivos criados nesta sessão

**Código** (nada da arquitetura de identificação foi alterado):
- `R/identification/spec_sweep.R` — helpers: `norm_value_for`,
  `theory_sign_table`, `summarize_irf_responses`, `evaluate_sweep_cell`,
  `classify_sweep_cells`, `run_stage2_cell`, `plot_overlay_cells`, `md_table`.
- `script/irf_spec_sweep.R` — Etapa 1 (320 células, ~segundos).
- `script/irf_spec_stage2.R` — Etapa 2 (6 células × nboot 800, ~2 min).

**Saídas** (`output/irf/`):
- `spec_sweep_cells.csv` (320 × diagnóstico completo), `spec_sweep_irf_long.csv`
  (3 200 linhas resposta × horizonte);
- `spec_sweep_report.md` (Etapa 1), `spec_sweep_stage2.md` (Etapa 2),
  `spec_sweep_conclusoes.md` (consolidado);
- `irf_spec_<tag>.{rds,pdf}` × 6 + `irf_spec_stage2_overlay.pdf`.

**Reprodução:**
```bash
Rscript script/irf_spec_sweep.R     # Etapa 1 — grid ponto-estimativa
Rscript script/irf_spec_stage2.R    # Etapa 2 — bootstrap nos vencedores
```

**Nota:** a skill `gemini-review` não rodou (CLI com `IneligibleTierError` —
tier gratuito do Gemini Code Assist descontinuado). A validação do código foi
feita por reprodução exata dos números de referência (§4.1).
