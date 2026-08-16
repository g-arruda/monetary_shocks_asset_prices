# Migração da produção para o painel de 111 séries e `(r,q)=(5,5)`

> **CURRENT, decisão e implementação, 2026-08-13.** Produção:
> `drop_setor_externo__eua__credito__imoveis`, `r=5`, `q=5`, `p=6`,
> `z_jk_bs_purif`, choque de +50 pb em `yield_6m`, 800 réplicas, semente 123 e
> bandas de 68%/90%. Esta nota substitui como decisão corrente tanto a produção
> de 106 séries `(7,6)` quanto a recomendação intermediária de 123 séries
> `(4,3)`. Nenhum arquivo `.tex` foi alterado.

## Decisão

O caminho canônico `data/processed/data_log_deseasonalized.csv` agora contém
111 séries e 153 meses, de 2013-01 a 2025-09. `script/clean.R` preserva o painel
anterior em `data/processed/data_log_deseasonalized_base_106.csv`, que é lido
explicitamente pelas grades fatoriais históricas. A especificação única vive
em `R/modeling/production_spec.R`; scripts de produção e diagnósticos deixam de
repetir painel, dimensões, amostra, bootstrap, instrumento e normalização.

Partindo do painel-base, saem as quase-duplicatas `juros_cdi` e `asset_mlcx`.
Dos blocos candidatos, são mantidos fiscal e expectativas e removidos setor
externo, EUA, crédito e imóveis. Permanecem no painel `yield_6m`,
`fiscal_dbgg`, `fiscal_dlsp`, `fiscal_primary_balance`,
`expect_focus_ipca12m`, `expect_focus_selic_ny`, `expect_focus_pib_ny` e
`expect_focus_cambio_ny`.

As 14 séries deliberadamente ausentes são:

- `juros_cdi`, `asset_mlcx`;
- `external_current_account_gdp`, `external_exports`, `external_imports`,
  `external_reserves`;
- `us_dgs2`, `us_dgs10`, `us_fedfunds`, `us_dtwexbgs`,
  `asset_sp500_yahoo`;
- `credit_default_rate`, `credit_average_rate`, `housing_ivgr`.

`r=5` é a decisão produzida pelo Bai--Ng IC2 padronizado para o desenho BLL.
`q=5` é um default operacional provisório: não é tratado como seleção fechada
e permanece como pendência metodológica.

## Gate anterior à migração

A célula exata foi estimada fora do caminho canônico antes da troca. O gate
exigiu 800 réplicas, semente 123, bandas finitas e ordenadas, nenhuma falha,
estabilidade na amostra completa e impacto de `yield_6m` exatamente igual a
0,005. Todos os requisitos passaram.

| janela | T | N | inovações | xi_mp | F_rob,mp | raiz máxima | estável |
|---|---:|---:|---:|---:|---:|---:|---|
| full | 153 | 111 | 147 | 6,27085 | 10,12054 | 0,9648577 | sim |
| pré-COVID | 84 | 111 | 78 | 10,99268 | 9,74746 | 1,0002017 | **não** |

A instabilidade pré-COVID é marginal, mas real sob a regra mecânica da raiz
unitária. Essa janela qualifica a relevância do instrumento; não sustenta uma
leitura dinâmica alternativa nem redefine a escolha feita na amostra cheia.

## Bootstrap e smoke test

O bootstrap canônico terminou com zero falhas. As cinco respostas obrigatórias
no impacto foram:

| variável | h=0 |
|---|---:|
| `yield_6m` | 0,0050000000 |
| `yield_2y` | 0,0074300592 |
| `yield_5y` | 0,0077611464 |
| `asset_ibov` | -1,7226766564 |
| `cambio_usd` | 0,1579280657 |

Os artefatos executáveis do gate são
`output/validation/production_spec_diagnostics.csv`,
`production_spec_bootstrap_gate.csv` e `production_spec_headline_irf.csv`.

## Robustez estrutural na nova célula

Os diagnósticos de coincidência com o FOMC e de risco soberano foram refeitos
com 800 réplicas e reproduziram os cinco impactos do gate; ambos mantêm o
veredito de confound não detectado. Na identificação por heterocedasticidade,
nenhuma das 288 células válidas da grade identifica após Holm, inclusive os
cinco desenhos de regime na célula `(5,5)` full.

O gate não gaussiano passa na amostra completa: todos os cinco componentes
rejeitam normalidade a 5%. Na pré-COVID, dois de cinco não rejeitam, acima do
máximo de um permitido pela identificação ICA. O GMR full completou 800
réplicas sem falhas. A Wald assintótica rejeita a direção do proxy
(`xi=33,368`, 4 gl), mas o bootstrap é pouco informativo: as bandas de 90% do
GMR cobrem o ponto do proxy em todas as 5.439 células e a direção varia muito
entre réplicas. O resultado fica como teste de robustez, não como estimativa
concorrente das magnitudes.

## Artefatos regenerados

Foram reestimados o modelo principal, coerência e figuras, força MOSW e suas
varreduras, benchmark VAR, representação acionária, estacionariedade e
composição, grade de especificação em dois estágios, confounds FOMC/risco
soberano, identificação por heterocedasticidade e não-gaussianidade, além dos
diagnósticos numerados `01`--`07`. As validações HAC, Kilian/MOSW, ICA e dos
insumos candidatos foram executadas separadamente.

O PDF principal passou a ser `output/irf/irf_model_alessi_r5q5.pdf`; o artefato
canônico com sufixo `r7q6` foi removido. As figuras em `paper/` foram
regeneradas a partir da célula nova, mas o manuscrito e todos os demais
arquivos `.tex` permaneceram intocados.
