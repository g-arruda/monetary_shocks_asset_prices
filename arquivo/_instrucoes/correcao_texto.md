# contexto.md

## Objetivo do projeto
Paper independente que replica a metodologia de Alessi & Kerssenfischer (2019) aplicada ao Brasil. Estima um Dynamic Factor Model (DFM) de grande escala para identificar choques de política monetária via instrumento externo e analisa a resposta de preços de ativos brasileiros.

## Metodologia
- **Modelo:** DFM não-estacionário de Alessi & Kerssenfischer (2019).
- **Identificação (atual, default — sessão 2026-05-08; revalidada 2026-07-11):** proxy-SVAR via instrumento externo **`z_jk_purif`** — surpresa de DI Copom-day purificada por SP500/VIX/Brent (Bauer-Swanson 2023) e filtrada pelo sinal Jarociński-Karadi. Cruza Stock-Yogo `F (factor-space) ≥ 10` no full sample em (r,q) ∈ {(6,5), (7,6), (8,8)} (10.08 / 10.17 / 11.76), onde "factor-space" é a relevância do instrumento contra os q fatores dinâmicos do DFM — a métrica que governa o viés de instrumento fraco na projeção `H = (Z'η)/(Z'Z)`. *(A formulação anterior "único que cruza" era artefato do grid com r fixo em 7; a varredura 2026-07-11 mostra que `z_jk` também cruza em (8,8) e que 5 instrumentos cruzam na janela pre_covid com (6,5).)* Atenção: o auto-IC (r=5, q=4) é borderline-weak (9.20) — não usar como caso base. A normalização padrão é em `yield_6m` (decimal proportion → +0.005 = +50bp).
- **Identificação (robustez):** **`z_het_jk_3var`** — proxy-SVAR via instrumento por heterocedasticidade no espírito de Rigobon-Sack (2003 *QJE*) e Gonçalves-Rodrigues-Genta (2025). SVAR diária 3-var (DI_3m, IBOV, BRL); coluna de impacto via autovetor líder de Σ_C − Σ_NC; choque diário via projeção GLS de Mertens-Ravn (2013), filtrado por JK diário, agregado mensalmente. **Mantido como secondary spec** porque, embora forte contra a inovação AR(6) de `yield_6m` (F = 55.98), é severamente fraco no espaço dos fatores dinâmicos no full sample (F factor-space ≈ 2.7) — produz IRFs noise-dominated quando projetado pelo DFM (verificado em sessão 2026-05-08). A discrepância ilustra que F (univariado) e F (factor-space) podem divergir em ordens de magnitude. **Nuance da varredura 2026-07-11:** a fraqueza é COVID-driven, não estrutural — na janela pre_covid (2013-19) com (r=6, q=5), `z_het_jk_3var` (F = 11.1) e `z_het_3var` (F = 10.8) cruzam Stock-Yogo com sinais coerentes; `z_het_3var` pre_covid é a única célula do grid com **apreciação** cambial (canal GRG standard), sem significância (usar como robustez qualitativa, idealmente com bandas Anderson-Rubin).
- **Framing identificador (council Required 3, 2026-05-05; revisitado 2026-05-08):** `z_het_jk*` é caracterizado como **identificação híbrida** het+timing+sign — não het-ID puro. A taxa de 57% wrong-sign no ε̂_1 diário implica que A1-A3 conjuntas não isolam o choque de política; o filtro JK no nível diário é parte da identificação. A condição operativa no proxy-SVAR mensal é a *exclusion restriction* `E[z_*_m · η_t^j] = 0` para j ≠ 1 (Stock-Watson 2018 §4.7); a *relevância* operativa é F (factor-space) ≥ 10. Em ambas as variantes (z_jk_purif e z_het_jk_3var), a exclusion restriction é defendida pelos testes T1-T8 em `script/instrument_validation.R`; a relevância em factor-space é mensurada por `R/identification/factor_space_diagnostics.R::diagnose_instrument_in_factor_space` e reportada como coluna `f_factor_sp` em `script/instrument_diagnostics.R`.
- **Identificação (legacy / pré-2026-05-08):** quatro variantes Gertler-Karadi (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`) e quatro variantes het (`z_het`, `z_het_jk`, `z_het_3var`, `z_het_jk_3var`). `z_jk_purif` agora é promovido a default; as demais permanecem disponíveis em `data/processed/instrumentos_mensais.csv` para análise comparativa em `script/instrument_diagnostics.R` e `script/diagnose_factor_space_F.R`.
- **Normalização:** choque que eleva `yield_6m` em 50 bps (controlado por `mp_var` em `main_sdfm`; ver `_instrucoes/justificativa_uso_yield-6m.md`).
- **Inferência:** wild bootstrap recursive (Gonçalves & Kilian, 2004) + correção de viés de Kilian (1998).

## Dados
- **Painel mensal:** N = 111 séries, 2013-01 a 2025-12, Brasil.
- **Séries de juros no painel:** `juros_selic` (BCB 4189, *acumulada no mês* — fluxo, não fim-de-período), `juros_cdi` (BCB 4392), `yield_3m`, `yield_6m`, `yield_1y`, `yield_2y`, `yield_5y`, `yield_10y` (Svensson, último dia útil do mês — estoque).
- **Variável de política recomendada para o proxy-SVAR:** `yield_6m` (passa Stock-Yogo F (y6m AR) > 10 em todas as variantes JK; passa Stock-Yogo F (factor-space) ≥ 10 apenas em `z_jk_purif`). `juros_selic` apresenta atenuação severa por descasamento de maturidade com o anúncio Copom. Justificativa em `_instrucoes/justificativa_uso_yield-6m.md`.
- **Dados brutos mensais:** `data/raw_data.csv`.
- **Dados processados (log + sazonalidade):** `data/processed/data_log_deseasonalized.csv`.
- **Instrumento default consumido pela DFM:** `data/processed/instrument.csv` (sobrescrito conforme `DEFAULT_VARIANT`; default atual: **`z_jk_purif`**, atualizado em 2026-05-08 — ver pendencias.md CRÍTICO 2026-05-08).
- **Painel de instrumentos lado-a-lado:** `data/processed/instrumentos_mensais.csv` (6 GK + 4 het = 10 colunas; as duas GK adicionais de 2026-07-14 são o par de máscara bruta `z_jk_raw_purif`/`z_jk_raw_purif_local` — ver `relatorio/working-notes/2026-07-14_ordem_purificacao_jk.md`).
- **Dados diários para identificação por heterocedasticidade:** `data/di.csv`, `data/yields/yields_dia.csv` (Svensson), `data/processed/ibov_daily.csv`, `data/processed/brl_usd_daily.csv`, `data/copom_historico.csv`.
- **Curva de juros (Svensson):** `data/yields/yields.csv` (mensal), `data/yields/yields_dia.csv` (diária), `data/yields/fatores.csv`.

## Estrutura do código R
- `script/model_alessi.R` — script principal (`mp_var = "yield_6m"`; override explícito `r = 6, q = 5` desde 2026-07-11 — auto-IC (5,4) é borderline-weak; salva `output/irf/irf_model_alessi_r6q5.pdf`).
- `R/modeling/factor_estimation.R` — estimação do modelo.
- `R/modeling/impulse_responde.R` — funções de IRF.
- `R/preprocessing/` — sazonalidade e transformaçao log.
- `script/instrument.R` — construção dos 6 instrumentos por timing (Gertler-Karadi; inclui desde 2026-07-14 o par de máscara JK em sinais brutos `z_jk_raw_purif`/`z_jk_raw_purif_local` — ordem "JK → purificação", inversa à do `z_jk_purif`); importa as 4 variantes het no arquivo combinado.
- `script/instrument_het.R` — construção dos instrumentos `z_het`, `z_het_jk` (4-var production) e `z_het_3var`, `z_het_jk_3var` (3-var robustez) por heterocedasticidade (Rigobon-Sack 2003). Novos artefatos (2026-05-07): `output/instrument/het_rank_test{,_3var,_pre_covid,_covid_post}.csv` (testes formais de rank Gate A + Gate B), `output/instrument/het_b_2{,_3var}.csv` (segundo eigenpair loadings — descritor), `data/processed/instrument_z_het2{,_3var}.csv` (série mensal do segundo eigenpair — candidato robustez).
- `R/identification/het_shock_extraction.R` — primitivas (regimes Wed→Thu, eigendecomp de ΔΣ, GLS de Mertens-Ravn, agregação mensal, `validate_variance_split`, `classify_a2_verdict`, `build_het_instrument`).
- `R/identification/validation_tests.R` — primitivas para `instrument_validation.R` (T1-T8: `placebo_test`, `random_mask_test`, `subperiod_F`, `monthly_correlation`, `anti_jk_test`, `random_mask_curve`, `qlr_supF`).
- `script/instrument_diagnostics.R` — diagnostics dos 8 instrumentos com **três F lado a lado** (DFM factor 1 residual + AR(6) innovation de yield_6m + factor-space max-F sobre os q fatores dinâmicos); GRG Tab 1 com `a2_status`, espectro de ΔΣ, `b_1` 4-var × 3-var. Coluna `f_factor_sp` + flag `WEAK-FACT` (< 10) destacam que apenas `z_jk_purif` cruza Stock-Yogo no espaço relevante.
- `script/diagnose_factor_space_F.R` — grid (q ∈ {2,3,4,6}) × (8 variantes de instrumento) reportando F (factor-space), sinal de impact e estabilidade. Saída em `output/instrument/factor_space_F_grid.csv`.
- `R/identification/factor_space_diagnostics.R` — helper `diagnose_instrument_in_factor_space(dfm, instrument_df, dates, p, mp_var_idx)` que projeta uma variante candidata através do DFM pré-estimado e reporta F (factor-space, max sobre q regressões univariadas), impact response e sinal.
- `script/instrument_validation.R` — T1-T8 para `z_het_jk + yield_6m` (placebo, random-mask, sub-period, correlação com z_jk_purif, anti-JK, F(k_keep) curva, T2b paired benchmark z_het, T7 AR-order sensitivity, T8 Andrews QLR sup-F).
- `script/instrument_audit.R` — auditoria de agregação × maturidade × filtro JK; produz `output/instrument_audit_report.md` e `output/instrument_audit_grid.csv`.
- `script/irf_cross_instrument.R` — wrapper que chama `main_sdfm` 2× (z_het_jk_3var + z_jk_purif), nboot=800, bandas 68/90, 9-painel grid 3×3. Persiste `output/irf_{zhetjk3var,zjkpurif,comparison}.pdf` + `output/irf_results_{zhetjk3var,zjkpurif}.rds` (bundles com irf+var_names+tcode).
- `script/build_grg_benchmark.R` — converte IRFs para unidades GRG (per +50bp; cambio_usd BRL→% via baseline) e gera `output/grg_benchmark.csv` lado-a-lado com Tabs 4 e 5 de GRG (2025).
- `script/irf_spec_sweep.R` — **(2026-07-11)** Etapa 1 da varredura de especificações: 8 instrumentos × 5 mp_vars × (r,q) ∈ {(5,4),(6,5),(7,6),(8,8)} × {full, pre_covid} = 320 células ponto-estimativa (cache de 8 DFMs, `nboot=0`), com scores de coerência teórica (hard/ext/soft), F (factor-space) + F reduzido por célula e taxonomia de falhas. Saídas: `output/irf/spec_sweep_{cells,irf_long}.csv`, `spec_sweep_report.md`.
- `script/irf_spec_stage2.R` — Etapa 2: wild bootstrap (nboot=800) nas células vencedoras (mp_var fixa em yield_6m), RDS + PDFs 9-painel + overlay + `spec_sweep_stage2.md`. Consolidado interpretativo em `output/irf/spec_sweep_conclusoes.md`; helpers em `R/identification/spec_sweep.R`.
- Código Matlab original em `codigo_alessi-mark/` (referência para tradução).


## Identificação do choque

O projeto suporta oito variantes de instrumento externo para a proxy-SVAR no DFM. As quatro primeiras são surpresas Wed→Thu na DI Copom-day com diferentes filtros (paradigma Gertler-Karadi); as quatro últimas são identificadas por heterocedasticidade num bloco SVAR diário (paradigma Rigobon-Sack), independentes da hipótese de timing intra-dia.

| Variante              | Construção                                                                                          | F (y6m AR) | F (factor-sp) | Script             |
|-----------------------|------------------------------------------------------------------------------------------------------|----:|----:|--------------------|
| `z_bruto`             | ΔDI Wed→Thu Copom-day, sem filtros                                                                   |  ~5 |  4.19 | `instrument.R`     |
| `z_bruto_purif`       | Resíduo de ΔDI em SP500/VIX/Brent (purificação Bauer-Swanson)                                       |  ~5 |  5.10 | `instrument.R`     |
| `z_jk`                | `z_bruto` filtrado por sinal Jarociński-Karadi (mantém dias ΔDI×ΔIBOV opostos)                       |  ~9 |  8.41 | `instrument.R`     |
| **`z_jk_purif`**      | `z_bruto_purif` com filtro JK — **default 2026-05-08**                                              | 11.4 | **10.17** ✓ | `instrument.R`     |
| `z_het`               | Choque Rigobon-Sack (2003) extraído de SVAR diária 4×4 (DI_3m, DI_2y, IBOV, BRL)                    |  ~8 |  3.07 | `instrument_het.R` |
| `z_het_jk`            | `z_het` com filtro JK no nível diário (sign(ε̂_1) ≠ sign(ΔIBOV))                                     | 21.3 |  6.89 | `instrument_het.R` |
| `z_het_3var`          | Choque Rigobon-Sack extraído de SVAR diária 3×3 (DI_3m, IBOV, BRL); rank-1 share = 0.987            |  —  |  1.11 | `instrument_het.R` |
| `z_het_jk_3var`       | `z_het_3var` com filtro JK — **robustez secondary 2026-05-08** (era default 2026-05-05)             | 55.98 |  2.74 | `instrument_het.R` |

✓ = cruza Stock-Yogo F (factor-sp) ≥ 10 **nesta configuração (r=7, q=6, full sample)**. A coluna F (factor-sp) depende de (r, q, amostra): a varredura 2026-07-11 (`output/irf/spec_sweep_report.md`) mostra `z_jk_purif` cruzando também em (6,5) e (8,8) no full, `z_jk` em (8,8), e **cinco** instrumentos cruzando na janela pre_covid com (6,5) — incluindo `z_het_jk_3var` (11.1) e `z_het_3var` (10.8). Ver `output/instrument/factor_space_F_grid.csv` (grid antigo, r=7) e `output/irf/spec_sweep_cells.csv` (grid completo).

**Recomendação após auditoria + validação (2026-05-05/06; revisitada 2026-05-08):** `z_jk_purif` é o default em produção com normalização em `yield_6m`. **A descoberta crítica de 2026-05-08:** F (y6m AR) = 55.98 do `z_het_jk_3var` é forte, mas F (factor-space) = 2.74 — o instrumento é severamente fraco no espaço dos q fatores dinâmicos onde a proxy-SVAR realmente projeta. Após o fix de unit scaling de 2026-05-07 expor as IRFs reais, sinais teoricamente invertidos e bandas largas confirmaram weak-instrument bias. `z_jk_purif` é a única variante que cruza Stock-Yogo F (factor-sp) ≥ 10 (= 10.17), produz IRFs com sinais coerentes (curva sobe, ações caem, atividade cai, risco soberano widens). T5 anti-JK F = 0.19 e T6 F-curve continuam confirmando que o filtro JK é informativo. T7 (AR-order p ∈ {3,6,12}) confirma F estável. T8 (Andrews QLR sup-F = 6.88) **fail to reject** quebra estrutural no slope do first-stage. A3 het-ID separado pre/post-COVID: cosine(b_1) = 1.000 — direção estável; "A3 sustained" (mantido para a robustez `z_het_jk_3var`). **IRF cross-instrument (2026-05-08):** primary = `z_jk_purif`; secondary = `z_het_jk_3var`. Ver `_instrucoes/Heteroscedasticidade.md`, `output/instrument/instrument_diagnostics_report.md`, `output/instrument/factor_space_F_grid.csv`, `output/het_validation_report.md`, `output/irf_section.md`.

**Varredura de especificações (2026-07-11):** grid completo de 320 células (instrumento × mp_var × (r,q) × amostra) confirma e fecha o diagnóstico: **toda inversão de sinal é F (factor-space) < 10** — zero células `sign_puzzle` (F forte com sinais errados) e zero `unstable_normalization` em todo o grid. Com bootstrap (nboot=800), z_jk_purif entrega 3/3 variáveis hard com CI90 excluindo zero em (6,5)/(7,6)/(8,8) full e em pre_covid (6,5). Recomendações operativas: (i) caso base com **(r,q) = (6,5)** ou (7,6) — nunca o auto-IC (5,4); (ii) robustez pre_covid (6,5) cross-instrumento (5 instrumentos, 2 esquemas de ID); (iii) `juros_selic` confirmado como controle negativo (F reduzido máx 2.49). Ver `output/irf/spec_sweep_conclusoes.md` e `relatorio/working-notes/2026-07-11_varredura_irf.md`.

**Coerência ponto a ponto e fechamento interpretativo (2026-07-12):** `script/irf_coherence_check.R` pontua 52 variáveis do painel em cada h=0..48 contra janelas teóricas (objeto da estimação salvo em `output/irf/irf_coherence_cell.rds`). Quatro diagnósticos fechados nas notas `relatorio/working-notes/2026-07-12_*.md`: (i) a corcova do IPCA headline é **price puzzle amostral** (n.s. em todo h, universal nos 8 instrumentos, desaparece pre-COVID com a mesma identificação — não é erro de identificação); (ii) estoques de crédito PJ **sobem com CI90 em h0-h6 antes de contrair** (cronologia Bernanke-Gertler 1995 / Gertler-Gilchrist 1994; PF sem alta inicial; construção confirma atenuação de crédito direcionado, agro não); (iii) spreads ICC respondem em **duas fases** (compressão mecânica h0-h7; abertura CI68 h19-h30 = accelerator defasado — a janela da régua estava errada, não o prior); (iv) IRFs "dentadas" = baixa comunalidade + raízes complexas de 3-4 meses do VAR(6) — benigno, manter p=6, não suavizar ex-post.

Para a seção empírica do paper (§5), o texto é `output/irf/irf_section.md` — **reescrito por completo em 2026-07-12** (z_jk_purif primário × (6,5) full, ex1 como medida de preço primária, robustez pre-COVID cross-instrumento em §5.6.1, curva longa como prêmio fiscal, reconciliação com GRG via célula z_het_3var pre_covid). Figuras/tabelas: `output/irf/irf_model_alessi_r6q5.pdf` (produção), `output/irf/irf_spec_stage2_overlay.pdf` + `spec_sweep_report.md` (robustez cross-especificação), `output/irf/irf_coherence_report.md` (coerência h-a-h). Pré-requisito de submissão: bandas Anderson-Rubin para variantes het.

A variante padrão escrita em `data/processed/instrument.csv` é controlada por `DEFAULT_VARIANT` em `script/instrument.R:25` (default atual: **`z_jk_purif`** — 2026-05-08).

## mapa_codigo_matlab.md

### Pipeline de execução

RUN_MAIN_US.m  (ponto de entrada)
  └─► MAIN_VARloop.m        (benchmark VAR — loop por variável de ativo)
  └─► MAIN_DFM.m            (estimação DFM — pipeline principal)
        ├─► DFMest_BLL.m          (estimação pontual)
        ├─► DFMest_BLL_Boot.m     (bootstrap)
        │     └─► kiliancorr.m    (correção de viés de Kilian)
        │     └─► DFMest_BLL.m    (chamada interna em cada réplica)
        ├─► selextinstsample.m    (alinhamento da amostra com o instrumento)
        └─► IdentExtInstr.m       (identificação por instrumento externo)
  └─► MAIN_plotfigs.m       (gráficos principais — Figuras 1–4 do paper)
  └─► MAIN_plotfigs_robustness.m (gráficos de robustez — Figuras A1–A4)

Arquivos auxiliares: getind.m, plotarea.m
Equivalente para zona do euro: RUN_MAIN_EA.m (mesma estrutura)


## Extrutura do projeto.

- Pasta `artigos` estao os artigos originais para referencia, tanto o `.pdf` quanto o `.md`
- Pasta `R` estao as funçoes auxiliares
- Pasta `script` estao os scrips para execuçao.


## Convenções de código
- Idioma: inglês (variáveis e comentários).
- Comentários: mínimos, apenas em etapas técnicas não triviais.
- Gráficos: `ggplot2`, estilo do paper original (bandas sombreadas 80% e 90%).
- Não usar `Bai & Ng (2002)` para seleção de fatores, pois é necessarios dados estacionários — utilizo a padronização BLL já lida com não-estacionaridade.
