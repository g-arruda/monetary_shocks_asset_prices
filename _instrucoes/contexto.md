# contexto.md

## Objetivo do projeto
Paper independente que replica a metodologia de Alessi & Kerssenfischer (2019) aplicada ao Brasil. Estima um Dynamic Factor Model (DFM) de grande escala para identificar choques de política monetária via instrumento externo e analisa a resposta de preços de ativos brasileiros.

## Metodologia
- **Modelo:** DFM não-estacionário de Alessi & Kerssenfischer (2019).
- **Identificação (atual, default):** proxy-SVAR via instrumento externo identificado por **heterocedasticidade** no espírito de Rigobon-Sack (2003 *QJE*) e Gonçalves-Rodrigues-Genta (2025), em duas variantes side-by-side. A SVAR diária Wed→Thu separa regime C (Copom) de NC (não-Copom); a coluna de impacto vem do autovetor líder de Σ_C − Σ_NC; a série diária do choque é recuperada via projeção GLS de Mertens-Ravn (2013), filtrada pelo sinal Jarociński-Karadi diário e agregada mensalmente. **Default recomendado após auditoria 2026-05-05:** `z_het_jk_3var` — SVAR 3-var (DI_3m, IBOV, BRL), F (y6m AR) = 55.98, rank-1 share = 0.987. A versão 4-var (que adiciona DI_2y) é mantida como robustez (rank-1 share = 0.840). A normalização padrão é em `yield_6m`.
- **Framing identificador (council Required 3, 2026-05-05):** `z_het_jk*` é caracterizado como **identificação híbrida** het+timing+sign — não het-ID puro. A taxa de 57% wrong-sign no ε̂_1 diário implica que A1-A3 conjuntas não isolam o choque de política; o filtro JK aplicado no nível diário é parte da identificação. A condição operativa no proxy-SVAR mensal é a *exclusion restriction* `E[z_het_jk_m · η_t^j] = 0` para j ≠ 1 (Stock-Watson 2018 §4.7) — mais fraca que A1-A3 conjuntas e compartilhada com proxy-SVARs Gertler-Karadi.
- **Identificação (legacy / robustez):** quatro variantes Gertler-Karadi (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`) baseadas em surpresas Wed→Thu na DI em torno do Copom. Mantidas como benchmark — não como pipeline principal — porque o anúncio Copom-pós-fechamento invalida a hipótese de timing intra-dia (cf. GRG 2025).
- **Normalização:** choque que eleva `yield_6m` em 50 bps (controlado por `mp_var` em `main_sdfm`; ver `_instrucoes/justificativa_uso_yield-6m.md`).
- **Inferência:** wild bootstrap recursive (Gonçalves & Kilian, 2004) + correção de viés de Kilian (1998).

## Dados
- **Painel mensal:** N = 111 séries, 2013-01 a 2025-12, Brasil.
- **Séries de juros no painel:** `juros_selic` (BCB 4189, *acumulada no mês* — fluxo, não fim-de-período), `juros_cdi` (BCB 4392), `yield_3m`, `yield_6m`, `yield_1y`, `yield_2y`, `yield_5y`, `yield_10y` (Svensson, último dia útil do mês — estoque).
- **Variável de política recomendada para o proxy-SVAR:** `yield_6m` (passa Stock-Yogo F > 10 com `z_het_jk` e F = 55.98 com `z_het_jk_3var`). `juros_selic` apresenta atenuação severa por descasamento de maturidade com o anúncio Copom. Justificativa em `_instrucoes/justificativa_uso_yield-6m.md`.
- **Dados brutos mensais:** `data/raw_data.csv`.
- **Dados processados (log + sazonalidade):** `data/processed/data_log_deseasonalized.csv`.
- **Instrumento default consumido pela DFM:** `data/processed/instrument.csv` (sobrescrito conforme `DEFAULT_VARIANT`; default atual: `z_het_jk_3var`).
- **Painel de instrumentos lado-a-lado:** `data/processed/instrumentos_mensais.csv` (4 GK + 4 het = 8 colunas).
- **Dados diários para identificação por heterocedasticidade:** `data/di.csv`, `data/yields/yields_dia.csv` (Svensson), `data/processed/ibov_daily.csv`, `data/processed/brl_usd_daily.csv`, `data/copom_historico.csv`.
- **Curva de juros (Svensson):** `data/yields/yields.csv` (mensal), `data/yields/yields_dia.csv` (diária), `data/yields/fatores.csv`.

## Estrutura do código R
- `script/model_alessi.R` — script principal (`mp_var = "yield_6m"`).
- `R/modeling/factor_estimation.R` — estimação do modelo.
- `R/modeling/impulse_responde.R` — funções de IRF.
- `R/preprocessing/` — sazonalidade e transformaçao log.
- `script/instrument.R` — construção dos 4 instrumentos por timing (Gertler-Karadi); importa as 4 variantes het no arquivo combinado.
- `script/instrument_het.R` — construção dos instrumentos `z_het`, `z_het_jk` (4-var production) e `z_het_3var`, `z_het_jk_3var` (3-var robustez) por heterocedasticidade (Rigobon-Sack 2003).
- `R/identification/het_shock_extraction.R` — primitivas (regimes Wed→Thu, eigendecomp de ΔΣ, GLS de Mertens-Ravn, agregação mensal, `validate_variance_split`, `classify_a2_verdict`, `build_het_instrument`).
- `R/identification/validation_tests.R` — primitivas para `instrument_validation.R` (T1-T6: `placebo_test`, `random_mask_test`, `subperiod_F`, `monthly_correlation`, `anti_jk_test`, `random_mask_curve`).
- `script/instrument_diagnostics.R` — diagnostics dos 8 instrumentos com **dois F lado a lado** (DFM factor 1 residual + AR(6) innovation de yield_6m); GRG Tab 1 com `a2_status`, espectro de ΔΣ, `b_1` 4-var × 3-var.
- `script/instrument_validation.R` — T1-T6 para `z_het_jk + yield_6m` (placebo, random-mask, sub-period, correlação com z_jk_purif, anti-JK, F(k_keep) curva).
- `script/instrument_audit.R` — auditoria de agregação × maturidade × filtro JK; produz `output/instrument_audit_report.md` e `output/instrument_audit_grid.csv`.
- Código Matlab original em `codigo_alessi-mark/` (referência para tradução).


## Identificação do choque

O projeto suporta oito variantes de instrumento externo para a proxy-SVAR no DFM. As quatro primeiras são surpresas Wed→Thu na DI Copom-day com diferentes filtros (paradigma Gertler-Karadi); as quatro últimas são identificadas por heterocedasticidade num bloco SVAR diário (paradigma Rigobon-Sack), independentes da hipótese de timing intra-dia.

| Variante              | Construção                                                                                          | Script             |
|-----------------------|------------------------------------------------------------------------------------------------------|--------------------|
| `z_bruto`             | ΔDI Wed→Thu Copom-day, sem filtros                                                                   | `instrument.R`     |
| `z_bruto_purif`       | Resíduo da regressão de ΔDI em SP500/VIX/Brent (purificação Bauer-Swanson)                            | `instrument.R`     |
| `z_jk`                | `z_bruto` filtrado por sinal Jarociński-Karadi (mantém dias com co-movimento ΔDI vs ΔIBOV oposto)    | `instrument.R`     |
| `z_jk_purif`          | `z_bruto_purif` com filtro JK aplicado em cima dos resíduos                                          | `instrument.R`     |
| `z_het`               | Choque Rigobon-Sack (2003) extraído de SVAR diária 4×4 (DI_3m, DI_2y, IBOV, BRL); agregado mensal    | `instrument_het.R` |
| `z_het_jk`            | `z_het` com filtro Jarociński-Karadi aplicado no nível diário (sign(ε̂_1) ≠ sign(ΔIBOV))             | `instrument_het.R` |
| `z_het_3var`          | Choque Rigobon-Sack extraído de SVAR diária 3×3 (DI_3m, IBOV, BRL); rank-1 share = 0.987             | `instrument_het.R` |
| **`z_het_jk_3var`**   | `z_het_3var` com filtro JK aplicado no nível diário — **default em `instrument.csv`**                | `instrument_het.R` |

**Recomendação após auditoria + validação (2026-05-05):** `z_het_jk_3var` com normalização em `yield_6m`. F de primeiro estágio (y6m AR) = 55.98 (vs 21.29 do `z_het_jk` 4-var, vs 1.1 para `z_het` em `juros_selic`). T5 anti-JK F = 0.19 e T6 F-curve confirmam que o filtro JK é informativo, não só esparsificação. Ver `_instrucoes/Heteroscedasticidade.md`, `output/instrument_audit_report.md`, `output/instrument_diagnostics_report.md`, `output/het_validation_report.md`.

A variante padrão escrita em `data/processed/instrument.csv` é controlada por `DEFAULT_VARIANT` em `script/instrument.R:25` (default atual: `z_het_jk_3var`).

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
