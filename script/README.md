# `script/` — o que cada arquivo faz

São 16 scripts em `script/` e 6 travas de validação em `script/validation/`,
organizados por tema. A pasta é plana, com uma exceção: desde 2026-09-17 as
travas ficam na subpasta `validation/`, que espelha `output/validation/`, onde
estão as fixtures e os relatórios delas.

**2026-09-17 — auditoria de `script/` e `R/`:**
- 25 scripts de rodadas fechadas foram para `arquivo/script/`, com as funções de
  `R/` que só eles chamavam. A lista e os motivos estão em `arquivo/README.md`.
  As saídas desses scripts continuam em `output/`, onde as notas as citam.
- `q_narrative_overlay_covid.R` e `q_narrative_overlay_precovid_p2.R` viraram um
  só script, `q_sensitivity.R --window=cheia|pre_covid`, que mantém os nomes de
  saída.

**2026-09-18 — o wild bootstrap e a correção de Kilian saíram do código.** Os
conjuntos Anderson--Rubin os substituíram como inferência do DFM em 2026-09-08.
Com eles foram para `arquivo/script/` o `ar_bands.R`, que comparava AR, delta e
bootstrap, e o `fomc_coincidence.R`, junto com `R/instrument/event_tests.R`, que
só ele chamava. As saídas dos dois continuam em `output/`.

Rodadas anteriores de limpeza:
- **2026-08-01 e 2026-08-05:** saíram cinco scripts da investigação de
  contaminação de IRF e `diagnose_factor_space_F.R`.
- **2026-08-17:** saíram os scripts das rotas de identificação abandonadas. A
  heterocedasticidade foi para `arquivo/heterocedasticidade/`, com o código
  removido em 2026-09-01, e a não gaussiana para `arquivo/nao_gaussiana/script/`.
- **2026-08-31:** `download.R` passou a ser o único ponto de entrada de rede. Os
  módulos de fonte ficaram em `R/data_download/`.

Todo script aqui cumpre ao menos uma de três funções:
- reproduzir `paper/paper_anpec.tex`;
- sustentar um item aberto de `registro/pendencias.md`;
- travar o código contra a referência dos autores.

A auditoria de 2026-09-17 conferiu isso arquivo a arquivo. Quem chega agora deve
ler primeiro `run_all.R`, que é o orquestrador, e depois os quatro scripts do
grupo 1, na ordem em que aparecem.

## 1. Pipeline core (orquestrado por `run_all.R`)

| script | o que faz |
|---|---|
| `run_all.R` | Orquestrador fim a fim. Roda 4 estágios nomeados (`download`, `clean`, `instrument`, `model`), cada um como subprocesso `Rscript` via `system2`, com `--list/--dry-run/--from/--to/--only/--skip/--skip-existing/--continue-on-error`. Confere as pré-condições de cada estágio (`requires`/`produces`). O estágio `model` só chama `model_alessi.R`: não roda `model_var.R` nem scripts de diagnóstico. |
| `download.R` | Único ponto de entrada de downloads. Coleta SGS, Focus/Olinda, FRED, Yahoo, B3, o calendário FOMC, IPEA e SIDRA, e valida os insumos externos fixos usados. Grava os seis artefatos diários em `data/raw/` e monta `raw_data.csv`: 113 séries completas na amostra 2012-03–2025-12, incluindo os três indicadores fiscais e as quatro expectativas Focus da produção. `di.csv`, a curva e o CDS Bloomberg continuam externos e nunca são sobrescritos. |
| `clean.R` | Filtra 2012-03–2025-12 e aplica log e a cascata X-13 às 113 séries raw. Constrói e audita o ajuste cambial da DLSP e as três expectativas fiscais Focus. Grava a base histórica de 106 séries e monta o painel de produção de 115, removendo `juros_cdi` e `asset_mlcx`. Escreve o manifesto integral em `output/panel/production_series_manifest.csv`. |
| `instrument.R` | Constrói, desde 2012-03, as 8 variantes mensais de instrumento (família GK/JK/BS) via `R/instrument/{di_surprise,build_variants}.R`, com antecedentes diários desde 2011-09 (`TARGET_BD=126`, soma JK, variante padrão `z_jk_bs_purif`). Escreve `data/processed/instrumentos_mensais.csv`, os CSVs por variante e o legado `data/processed/instrument.csv`. |
| `model_alessi.R` | Script de produção do DFM principal. Consome `production_spec()`, grava a superfície Bai--Ng BLL completa e estima `(r=5, q=5, p=4, choque=+50bp em yield_6m)` com a inferência de produção: conjuntos Anderson--Rubin desde 2026-09-08. Escreve `output/irf/irf_model_alessi_r5q5.pdf`. |

## 2. Benchmark (fora do `run_all.R`)

| script | o que faz |
|---|---|
| `model_var.R` | Único driver do VAR pequeno observável. Os artefatos ficam congelados na vintage 2013-01--2025-09, e o script exige `--reestimate-current-instrument` para impedir que a proxy BS recalculada altere o benchmark sem aviso. Quando autorizado, estima as cinco séries em nível com constante e tendência linear, `p=2`, com respostas `C_h B_1` e conjuntos AR 68%/90% em NW(0). |

## 3. Força do instrumento

| script | o que faz |
|---|---|
| `instrument_diagnostics.R` | Compara as variantes no DFM de produção compartilhado. Reporta ξ_mp e o primeiro estágio robusto F_rob,mp na direção de `yield_6m`, a dispersão Copom-dia e o teste de variância Copom vs. não-Copom. Escreve `output/instrument/instrument_diagnostics_report.md` e um PNG. |
| `mosw_strength_grid.R` | Atualização incremental da grade de ξ_mp e F_rob,mp com `z_jk_bs_purif`, `p=4`, na direção de normalização de `yield_6m`. Na cheia, com a escala COVID, varre `r=4:6`, porque `r ≥ 7` é explosivo; na pré-COVID, `r=4:8`. Preserva no CSV as linhas históricas fora desse recorte. Escreve `output/instrument/mosw_strength_grid.{csv,md}`. |

## 4. IRF: coerência, inferência e sensibilidade a `q`

| script | o que faz |
|---|---|
| `irf_coherence_check.R` | Roda a especificação de produção uma vez e pontua 58 variáveis do painel, ponto a ponto e em cada horizonte, contra janelas de teoria (`R/identification/irf_coherence.R`). É o script que alimenta a §5 do paper. As bandas são os conjuntos Anderson--Rubin de `production_spec()$inference`, e significância é "o conjunto exclui zero", lida pela topologia. Escreve `output/irf/irf_coherence_{h,summary}.csv`, `irf_coherence_report.md` (reescrito por inteiro a cada rodada; nunca editar à mão), `irf_coherence_plots.pdf` e o cache `irf_coherence_cell.rds`, lido por scripts a jusante. |
| `q_truncation.R` | Testa se o truncamento `q < r` em `r = 5` descarta o choque monetário, em quatro janelas-célula: `cheia_p4` (a cheia sem tratamento), `pre_p4` só pontual, `pre_p2` com AR e `cheia_p4_lp`, a cheia com a volatilidade COVID de Lenza-Primiceri no θ̂ de `production_spec()`. A `cheia_p4_lp` é a produção desde 2026-09-17, e os autotestes (a) e (b) a conferem contra `irf_coherence_h.csv` e `mosw_strength_grid.csv`. Mede a suficiência do subespaço retido pelo Wald conjunto de z nas direções descartadas, e a invariância da Figura A3 de Alessi-Kerssenfischer por `containment_vs_production()` sobre as 115 séries. A leitura conjunta pré-registrada usa só as três células sem tratamento. Escreve `output/factors/q_truncation.{md,pdf}` e `q_truncation_{cells,directions,paths,containment}.csv`. |
| `q_sensitivity.R` | Passo 4/4 do e-mail de 2026-09-13: as 20 variáveis da narrativa em `q = 2..5`, com `r = 5`. `--window` é obrigatório. `--window=cheia` usa `p = 4` e a volatilidade COVID de `production_spec()`, com AR na regressão transformada. `--window=pre_covid` usa `p = 2`, porque em `p = 4` o AR pré-COVID é barrado. `q = 5` traz os conjuntos AR de 68/90%, e `q = 2..4` são pontuais, no desenho da Figura A3 de Alessi-Kerssenfischer. Escreve `output/factors/q_narrative_r5p4_covid.*` ou `q_narrative_r5p2_precovid.*`: `.md`, `.pdf`, `_paths.csv` e `_summary.csv`. |
| `fig_section5.R` | Pós-processamento puro: lê o `irf_coherence_cell.rds` canônico e as tabelas da Tarefa 7, sem reestimar nada. Escreve as 10 figuras `paper/fig_*.pdf` até h=36. **Congelado desde 2026-09-08:** aborta sem `--repaint-paper-figures`, porque o cache passou a carregar conjuntos AR e as legendas do paper ainda dizem *wild bootstrap*. |
| `fig_weak_iv.R` | Pós-processamento puro do CSV canônico da inferência robusta no VAR. Escreve só `paper/fig_weak_iv_main.pdf`, com ponto, zero e conjunto AR de 95% nas cinco respostas da produção até `h=36`. **Congelado desde 2026-09-08:** aborta sem `--repaint-paper-figures`, porque o contraste bootstrap-vs-AR que a legenda anuncia deixou de existir quando o DFM migrou para AR. |

## 5. Seleção de fatores, painel e volatilidade COVID

| script | o que faz |
|---|---|
| `panel_pruning.R` | Poda o painel de produção pela correlação par a par das primeiras diferenças (sugestão 2/5 do e-mail de 2026-09-04). Usa ligação completa em \|ρ\| ≥ 0,90 e mantém uma série por grupo, por regra pré-registrada. Os limiares 0,80, 0,85 e 0,95 e a ligação simples entram como sensibilidade, e a versão restrita a cada bloco entra como comparação. Escreve o manifesto, os pares acima de 0,80, o relatório e os mapas de calor em `output/panel_experimental/poda_correlacao/`. Não altera a produção. |
| `factor_selection_pruned.R` | Refaz a seleção do número de fatores nos painéis podados (sugestão 3/5 do e-mail de 2026-09-04). Roda Bai--Ng BLL, ER/GR de Ahn-Horenstein, ABC e Amengual--Watson no painel atual e em cada painel do manifesto de `panel_pruning.R`, com `p=4`, grade de `r` e as convenções do projeto e do MATLAB para o 2º estágio. A regra de leitura é pré-registrada; não calcula ξ_mp nem IRF. No painel atual, reproduz `output/factors/factor_selection_alt_summary.csv`, saída do arquivado `factor_selection_alt.R`. Escreve `output/factors/factor_selection_pruned.{md,pdf}`, `factor_selection_pruned_summary.csv` e `factor_selection_pruned_aw.csv`. |
| `covid_volatility_theta.R` | Estima θ = (s̄0, s̄1, s̄2, ρ), a escala de volatilidade COVID de Lenza-Primiceri (2022), por máxima verossimilhança (B5 do Apêndice B) no VAR dos fatores de produção, com `t*` = 2020-03, s̄ ≥ 1 e ρ ∈ [0,1]. Confere as condições de primeira ordem e o perfil de ℓ em ρ, e aborta se o otimizador parar num máximo local. É a proveniência dos literais de `production_spec()$covid_volatility`. Escreve `output/factors/covid_volatility_{theta,path,profile_rho}.csv`. |

## 6. `validation/` — travas contra o código de referência

Um teste que passou prova o código só naquele commit. Estas travas são testes
de regressão: rode-as de novo depois de qualquer mudança em `R/modeling/` ou
`R/identification/`. Como `codigos_externos/` é gitignorado, elas rodam sobre
fixtures commitadas em `output/validation/`. Num clone limpo, são a única prova
reproduzível de fidelidade ao código dos autores. Todas rodam da raiz do
projeto: `Rscript script/validation/<arquivo>.R`.

| script | o que faz |
|---|---|
| `validate_hac_kernel.R` | Valida a opção Newey-West de `compute_factor_space_wald` de duas formas: (A) transcrição literal de `NW_hac_STATA.m` vs. o kernel embutido, nos lags 0-8 em dado sintético; (B) fim a fim contra o fixture oficial `TaxSVARIV.m` (NWlags=8), o que também mede a equivalência da residualização Shat que entra em todo ξ_mp. O ramo NW>0 ficou sem consumidor vivo quando `xi_mp_robustness.R` foi arquivado, porque a produção usa NW(0). Só console, com `stopifnot`; imprime "SKIPPED" se o fixture faltar. |
| `validate_mosw_ar.R` | Valida o caminho inteiro do VAR observável. Contra `olea_oil_fixture.rds`, reproduz `AL`, `eta`, `Sigma`, `Gamma`, `WHat`, MA, os pontos SVAR-IV e os conjuntos AR de 68%/95%. Exige os dez casos degenerados do oráculo e compara AIC/BIC da célula brasileira com uma implementação independente e com `vars::VARselect(type="both")` (AIC `p=2`, BIC `p=1`). Checa também que a generalização `Load`/`Inner`, por onde passa o DFM, colapsa **exatamente** no MOSW original quando as duas são a identidade. Falha se faltar fixture ou dado. |
| `validate_olea_kilian.R` | Reproduz os números publicados de Montiel Olea-Stock-Watson (2021) no caso Kilian-oil (ξ₁=4.4, F robusto=9.4) a partir de `output/validation/olea_oil_fixture.rds`, e confere que o VAR reestimado bate com o `RForm` dos autores. Só console, com `stopifnot`. |
| `validate_amengual_watson.R` | Valida a tradução de `amengual_watson()` contra `amengual_watson.m`, `factor_estimation_ls.m` e `bai_ng.m` de Stock-Watson, transcritos literalmente, sobre a fixture commitada `output/validation/amengual_watson_fixture.csv`. Não há MATLAB/Octave aqui, então a transcrição *é* o instrumento. Mede em separado o que `apply_bll = TRUE` faz. Escreve `output/validation/amengual_watson_validation.md` e falha alto se `q_hat` divergir ou se o gap deixar de ser a constante `log(n/(n-1))`. |
| `validate_production_spec.R` | Valida a composição 115/base 106, as 166 datas, o manifesto SGS 20784/20785, o contrato do instrumento, a superfície Bai--Ng BLL, os critérios de defasagem, a força e as raízes full/pré-COVID e os cinco impactos obrigatórios. Re-deriva o θ̂ de `production_spec()`. Também produz números: escreve `production_factor_lag_criteria.csv` (o AIC p=4 da §3.1) e `production_spec_impact_smoke.csv`. |
| `validate_covid_volatility.R` | Valida a escala de volatilidade COVID de Lenza-Primiceri (2022, Apêndice B) no VAR dos fatores. **No painel de produção, com θ neutro (`s_t ≡ 1`):** o WLS sai `identical()` ao OLS com cada um dos 162 meses de resíduo como `t*`; o pipeline pontual tratado bate com a produção a 1e-12; (B5) confere com a verossimilhança gaussiana calculada por força bruta; e cada `stop()` a jusante dispara. **Em VAR simulado com θ arbitrário:** checa (B2), (B5), `s_t`, o encanamento de `estimate_dfm`, `estimate_covid_theta`, o H não centrado, os valores iniciais contra `bvarGLP_covid.m`, a função de influência do estimador tratado e os conjuntos AR e o ξ_mp tratados contra MOSW alimentado à mão. Silencioso; para no primeiro erro. |

## Notas cruzadas

- **`rm(list=ls())`**: a maioria dos entry points limpa o ambiente; os que não o fazem são pensados para rodar em processo `Rscript` próprio, não para ser `source()`ados numa sessão existente.
- Nenhum script daqui é chamado por outro script daqui, exceto através de `run_all.R` (estágios) ou de `source()` de módulos em `R/`.
