# contexto.md

## Objetivo do projeto
Paper independente que replica a metodologia de Alessi & Kerssenfischer (2019) aplicada ao Brasil. Estima um Dynamic Factor Model (DFM) de grande escala para identificar choques de política monetária via instrumento externo e analisa a resposta de preços de ativos brasileiros.

## Metodologia
- **Modelo:** DFM não-estacionário de Alessi a Kerssenfischer (2019).
- **Identificação:** instrumento externo seguindo Alessi and Kerssenfischer (2019), Gertler and karidi (2015) e Stock and Watson (2012) — surpresas de política monetária baseadas em taxas forward instantâneas (Svensson) em torno das reuniões do COPOM. Normalização: choque que eleva yield de 2 anos em 50 bps.
- **Inferência:** wild bootstrap (Gonçalves & Kilian, 2004) + correção de viés de Kilian (1998).

## Dados
- **Painel:** N = 111 séries mensais, 2013-01 a 2025-12, Brasil.
- **Séries de juros no painel:** SELIC, CDI, yield3m, yield6m, yield1y, yield2y, yield5y, yield10y.
- **Dados brutos:** `data/raw_data.csv`.
- **Dados processados (sazonalidade):** `data/processed/data_log_deseasonalized.csv`.
- **Instrumento:** `data/processed/instrument.csv`.
- **Curva de juros (Svensson):** `data/yield/yields.csv` e `data/yield/fatores.csv`.

## Estrutura do código R
- `script/model_alessi.R` — script principal.
- `R/modeling/factor_estimation.R` — estimação do modelo.
- `R/modeling/impulse_responde.R` — funções de IRF.
- `R/preprocessing/` — sazonalidade e transformaçao log.
- `script/instrument.R` — construção do instrumento.
- Código Matlab original em `codigo_alessi-mark/` (referência para tradução).


## instrumento (conceito)
Surpresa de política monetária construída como desvio entre a taxa SELIC anunciada
pelo COPOM e a expectativa de mercado derivada da curva de juros (modelo de Svensson),
seguindo Bagliano & Favero (1998, p. 1094).


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
