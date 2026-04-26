# contexto.md

## Objetivo do projeto
Paper independente que replica a metodologia de Alessi & Kerssenfischer (2019) aplicada ao Brasil. Estima um Dynamic Factor Model (DFM) de grande escala para identificar choques de política monetária via instrumento externo e analisa a resposta de preços de ativos brasileiros.

## Metodologia
- **Modelo:** DFM não-estacionário de Alessi & Kerssenfischer (2019).
- **Identificação (atual):** proxy-SVAR via instrumento externo identificado por **heterocedasticidade** no espírito de Rigobon-Sack (2003 *QJE*) e Gonçalves-Rodrigues-Genta (2025). A SVAR diária 4×4 (DI_3m, DI_2y, IBOV, BRL) Wed→Thu separa regime C (Copom) de NC (não-Copom); a coluna de impacto vem do autovetor líder de Σ_C − Σ_NC; a série diária do choque é recuperada via projeção GLS de Mertens-Ravn (2013) e agregada mensalmente. **Variante recomendada após auditoria:** `z_het_jk` (filtro Jarociński-Karadi sobre o choque diário) com normalização em `yield_6m` (F = 21.3, R² = 0.19; ver `output/instrument_audit_report.md`).
- **Identificação (legacy / robustez):** quatro variantes Gertler-Karadi (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`) baseadas em surpresas Wed→Thu na DI em torno do Copom. Mantidas como benchmark — não como pipeline principal — porque o anúncio Copom-pós-fechamento invalida a hipótese de timing intra-dia (cf. GRG 2025).
- **Normalização:** choque que eleva `yield_6m` em 50 bps (controlado por `mpind` em `compute_irf_dfm`).
- **Inferência:** wild bootstrap recursive (Gonçalves & Kilian, 2004) + correção de viés de Kilian (1998).

## Dados
- **Painel mensal:** N = 111 séries, 2013-01 a 2025-12, Brasil.
- **Séries de juros no painel:** `juros_selic` (BCB 4189, *acumulada no mês* — fluxo, não fim-de-período), `juros_cdi` (BCB 4392), `yield_3m`, `yield_6m`, `yield_1y`, `yield_2y`, `yield_5y`, `yield_10y` (Svensson, último dia útil do mês — estoque).
- **Variável de política recomendada para o proxy-SVAR:** `yield_6m` (passa Stock-Yogo F > 10 com `z_het_jk`). `juros_selic` apresenta atenuação severa por descasamento de maturidade com o anúncio Copom.
- **Dados brutos mensais:** `data/raw_data.csv`.
- **Dados processados (log + sazonalidade):** `data/processed/data_log_deseasonalized.csv`.
- **Instrumento default consumido pela DFM:** `data/processed/instrument.csv` (sobrescrito conforme `DEFAULT_VARIANT`).
- **Painel de instrumentos lado-a-lado:** `data/processed/instrumentos_mensais.csv` (6 colunas).
- **Dados diários para identificação por heterocedasticidade:** `data/di.csv`, `data/yields/yields_dia.csv` (Svensson), `data/processed/ibov_daily.csv`, `data/processed/brl_usd_daily.csv`, `data/copom_historico.csv`.
- **Curva de juros (Svensson):** `data/yields/yields.csv` (mensal), `data/yields/yields_dia.csv` (diária), `data/yields/fatores.csv`.

## Estrutura do código R
- `script/model_alessi.R` — script principal.
- `R/modeling/factor_estimation.R` — estimação do modelo.
- `R/modeling/impulse_responde.R` — funções de IRF.
- `R/preprocessing/` — sazonalidade e transformaçao log.
- `script/instrument.R` — construção dos 4 instrumentos por timing (Gertler-Karadi); inclui também os 2 instrumentos por heterocedasticidade no arquivo combinado.
- `script/instrument_het.R` — construção dos instrumentos `z_het` e `z_het_jk` por heterocedasticidade (Rigobon-Sack 2003).
- `R/identification/het_shock_extraction.R` — primitivas (regimes Wed→Thu, eigendecomp de ΔΣ, GLS de Mertens-Ravn, agregação mensal).
- `script/instrument_diagnostics.R` — diagnostics dos 6 instrumentos (first-stage F, GRG Tab 1, espectro de ΔΣ, b_1).
- `script/instrument_audit.R` — auditoria de agregação × maturidade × filtro JK; produz `output/instrument_audit_report.md` e `output/instrument_audit_grid.csv`.
- Código Matlab original em `codigo_alessi-mark/` (referência para tradução).


## Identificação do choque

O projeto suporta seis variantes de instrumento externo para a proxy-SVAR no DFM. As quatro primeiras são surpresas Wed→Thu na DI Copom-day com diferentes filtros (paradigma Gertler-Karadi); as duas últimas são identificadas por heterocedasticidade num bloco SVAR diário (paradigma Rigobon-Sack), independentes da hipótese de timing intra-dia.

| Variante         | Construção                                                                                          | Script             |
|------------------|------------------------------------------------------------------------------------------------------|--------------------|
| `z_bruto`        | ΔDI Wed→Thu Copom-day, sem filtros                                                                   | `instrument.R`     |
| `z_bruto_purif`  | Resíduo da regressão de ΔDI em SP500/VIX/Brent (purificação Bauer-Swanson)                            | `instrument.R`     |
| `z_jk`           | `z_bruto` filtrado por sinal Jarociński-Karadi (mantém dias com co-movimento ΔDI vs ΔIBOV oposto)    | `instrument.R`     |
| `z_jk_purif`     | `z_bruto_purif` com filtro JK aplicado em cima dos resíduos                                          | `instrument.R`     |
| `z_het`          | Choque Rigobon-Sack (2003) extraído de SVAR diária 4×4 (DI_3m, DI_2y, IBOV, BRL); agregado mensal    | `instrument_het.R` |
| **`z_het_jk`**   | `z_het` com filtro Jarociński-Karadi aplicado no nível diário (sign(ε̂_1) ≠ sign(ΔIBOV))             | `instrument_het.R` |

**Recomendação após auditoria (2026-04-25):** `z_het_jk` com normalização em `yield_6m`. F de primeiro estágio = 21.3 (vs 1.1 para `z_het` em `juros_selic`). Ver `_instrucoes/Heteroscedasticidade.md` e `output/instrument_audit_report.md`.

A variante padrão escrita em `data/processed/instrument.csv` é controlada por `DEFAULT_VARIANT` em `script/instrument.R`.

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
