# Mapa de renomeações

**Para que serve.** `notas/` e `pareceres/` valem **verbatim**: uma nota datada
registra o que foi verificado naquele dia, e um parecer registra o que um revisor
externo afirmou ter checado — inclusive caminhos de arquivo e números de linha.
Reescrever um caminho dentro deles transformaria uma verificação datada numa
afirmação que ninguém fez (`.claude/rules/writing.md`). Então os caminhos antigos
**ficam lá**, e a tradução mora aqui.

**Como usar.** Ao ler qualquer documento do acervo anterior à data de um bloco
abaixo, aplique o mapa daquele bloco. Documentos vivos de `registro/` são
mantidos em lugar e já usam os caminhos correntes.

---

## 2026-09-30 — organização de `paper/`

As figuras foram para `paper/img/`, e o `.tex` as inclui como `img/fig_*.pdf`.
Os seis scripts que as desenham gravam no caminho novo. Nada foi redesenhado, e
o PDF compilado tem as mesmas 32 páginas e os mesmos avisos de antes.

| antes | agora |
|---|---|
| `paper/paper_anpec.tex` | `paper/paper.tex` |
| `paper/paper_anpec.pdf` | `paper/paper.pdf` |
| `paper/fig_*.pdf` | `paper/img/fig_*.pdf` |

Os números de linha `paper_anpec.tex:<linha>` citados nas notas valem para o
conteúdo daquela data, agora sob `paper/paper.tex`.

## 2026-09-25 — `coding-style` em `R/instrument/`

Quarta passada da skill `coding-style`, agora sobre os dois arquivos de
`R/instrument/`, que ficaram onde estavam. Nenhum número se moveu:
- `build_instrument_variants()` saiu `identical()` à antiga em `monthly`,
  `daily` e `diag`, no vértice de produção (126) e em 63;
- `build_thursday_surprises()` saiu `identical()` em 20 combinações:
  - vértice de 21 a 504;
  - `min_bd` de 10 e 30;
  - a grade de quintas do instrumento e a grade semanal do diagnóstico het.

  Isso inclui as quintas em que dois contratos empatam na distância ao
  vértice, que são 5 a 18 por vértice;
- `script/instrument.R` gera os três CSVs de `data/processed/` idênticos em
  bytes.

Os números de linha de `R/instrument/*.R` citados antes desta data valem para a
versão daquela data. O último estado antes da passada é `b654626`.

| antes | agora |
|---|---|
| `surprise_wed_to_thu()` em `R/instrument/di_surprise.R` | dentro de `build_thursday_surprises()`, seu único chamador: um join quarta×quinta pelo ticker e `slice_min()` da distância ao vértice, em vez de um `for` por quinta |
| `agg_monthly_sum()` em `R/instrument/build_variants.R` | um `summarise(.by = month)` com as três somas de Jarociński-Karadi |
| `trail_change()`, `align_pre_event()`, `drop_na_series()` e `log_ret_100()`, internas a `build_instrument_variants()` | a tabela `pre_event_inputs` (série, janela, escala) e um `pmap`; os retornos diários escritos em linha |
| defaults `path`, `from`, `to` de `load_di_panel()` e `load_copom_wednesdays()` | argumentos obrigatórios; `script/instrument.R` escreve o caminho de `copom_historico.csv` |
| defaults `target_bd = 63`, `min_bd = 10` de `build_thursday_surprises()` | argumentos obrigatórios; `build_weekly_changes()` escreve `min_bd = 10` |

Um defeito latente saiu junto. `align_pre_event()` fazia
`ifelse(idx >= 1, val[idx], NA)`. Quando um corte de quarta caía antes da
primeira observação da série, `idx` tinha zeros, `val[idx]` ficava mais curto e
o `ifelse` reciclava a coluna inteira deslocada. Isso nunca aconteceu, porque
toda série começa antes do primeiro corte. Num teste com o câmbio começando em
2012-06, o `stop` de NA dos preditores pegava o caso por acaso: a coluna
deslocada ainda carregava os NA da defasagem, 25 contra os 26 corretos. Agora o
corte sem observação vira NA na posição certa.

A regra de descarte de NA dos preditores também ficou uniforme. Cada série é
lida no próprio calendário, e não só as três do Yahoo. Nos dados isso não muda
nada: Ibovespa e câmbio já chegam filtrados, e Focus e inclinação do DI não têm
NA.

## 2026-09-25 — `coding-style` em `R/identification/`

Terceira passada da skill `coding-style`, agora sobre `R/identification/`, com
reagrupamento por domínio (decisão do autor). `spec_sweep.R` e
`experimental_panel.R` deixaram de existir. Nenhum número se moveu:
- o smoke test saiu bit-idêntico, e o objeto de `main_sdfm()`, `identical()`;
- cada função saiu `identical()` à antiga nos testes antigo-contra-novo,
  incluindo os casos de erro;
- nenhum `.csv` ou `.rds` rastreado mudou na re-rodada dos 17 comandos
  offline e de `het_rigobon/0{1,2,3}`;
- as 7 travas de `script/validation/` passam.

Os números de linha de `R/identification/*.R` citados antes desta data valem
para `main` em `3d2f757`. O parecer
`2026-09-24_auditoria_fidelidade_olea_lenza.md` cita `weak_iv_ar.R` e traz uma
nota de leitura.

| antes | agora |
|---|---|
| `run_stage2_cell()` em `R/identification/spec_sweep.R` | `R/modeling/dfm_pipeline.R`, junto de `main_sdfm()` |
| `norm_value_for()` em `R/identification/spec_sweep.R` | a conta escrita dentro de `run_stage2_cell()`, seu único chamador |
| `md_table()` em `R/identification/spec_sweep.R` | `R/reporting/markdown_report.R`, junto de `md_tbl()`, sem unificar |
| `plot_dimension_overlay()` em `R/identification/spec_sweep.R` | `R/reporting/figures.R` |
| `coherence_var_table()` em `R/identification/irf_coherence.R` | a tabela `theory_table` de `script/irf_coherence_check.R`, seu único chamador; a descrição dos tiers foi para `evaluate_irf_path()` |
| `base_block_taxonomy()` em `R/identification/experimental_panel.R` | código em `script/panel_pruning.R`, seu único chamador |
| `prune_correlated_series()` em `R/identification/experimental_panel.R` | `R/modeling/factor_selection.R` |
| `regime_indicator()` em `R/identification/het_tests.R` | escrito dentro de `fit_het_cv()`, com a explicação do bug de `id.cv.R:177` |
| `mat_sym_sqrt()` e `mat_sym_inv_sqrt()` em `R/identification/het_tests.R` | escritos dentro de `het_column_closed_form()`, que `fit_het_cv()` passou a chamar para a guarda de autovalores |

Uma única mensagem mudou. `ar_dfm_bands()` repetia o gate `hac_dim < T` que
`mosw_rform_cov()` já aplica, logo depois do gate `par_dim < T`. Com a
repetição removida, as células bloqueadas ((8,8) e o pré-COVID com `p = 4`)
passam a parar na mensagem do gate `par_dim`. Em (8,8) ela diz "Parameter
dimension is 300 >= T = 162". O bloqueio é o mesmo: os dois gates barram
exatamente as mesmas células.

Os `source()` de `irf_coherence_check.R`, `q_sensitivity.R`,
`factor_selection_pruned.R`, `panel_pruning.R` e `validate_amengual_watson.R`
passaram a apontar os novos arquivos. Os scripts de `arquivo/` que carregam
`spec_sweep.R` ou `experimental_panel.R` deixam de rodar; o acervo não é
mantido.

A mesma rodada devolveu `for` a `compute_irf_dfm()` (potências de `A`) e a
`compute_factor_space_wald()` (soma de Bartlett), no lugar do
`purrr::accumulate` e do `map` + `reduce` da passada anterior. O critério novo
da skill é que o laço que é passo da matemática fica laço. Uma revisão de todos
os laços de `script/` e `R/modeling/` pelo mesmo critério não achou outro passo
de matemática: o resto percorre itens independentes e fica `map`. Ficam `for`
dois laços sequenciais que não são matemática, porque a ordem importa e param
cedo: as especificações do X-13 em `clean.R` e os estágios de `run_all.R`. O
índice da recursão de `A` passou de `horizon` a `j` (`h` é o argumento do
horizonte máximo), com a citação de `DFMest_BLL.m:41-45`.

## 2026-09-25 — `coding-style` em `R/modeling/`

Segunda passada da skill `coding-style` sobre os arquivos de funções de
`R/modeling/`, com reagrupamento por domínio (decisão do autor). Nenhum número
se moveu:
- o smoke test saiu bit-idêntico, e o objeto de `main_sdfm()`, `identical()`;
- nenhum `.csv` ou `.rds` rastreado mudou na re-rodada dos 17 comandos offline
  e de `het_rigobon/02_irf.R`;
- os PDFs e `.md` só mudaram na data;
- as 7 travas de `script/validation/` passam.

Os números de linha de `R/modeling/*.R`,
`R/identification/factor_space_diagnostics.R` e `script/*.R` citados antes desta
data valem para `main` em `3d2f757`. O parecer
`2026-09-24_auditoria_fidelidade_olea_lenza.md` cita vários e traz uma nota de
leitura.

| antes | agora |
|---|---|
| `compute_factor_space_wald()` em `R/modeling/impulse_response.R` | `R/identification/factor_space_diagnostics.R`, junto de `diagnose_instrument_in_factor_space()`, seu único chamador vivo |
| `compute_robust_first_stage_F()` em `R/modeling/impulse_response.R` | `R/identification/factor_space_diagnostics.R` |
| `plot_irf()` em `R/modeling/impulse_response.R` | código em linha em `script/model_alessi.R`, seu único chamador vivo |
| `panel_eigenvalues()` em `R/modeling/factor_selection.R` | a conta `svd(X)$d^2 / (NT)` escrita em `ahn_horenstein()` e `abc_criterion()` |
| três cópias da padronização BLL, em `estimate_static_factors()`, `bai_ng_criteria()` e `amengual_watson()` | `standardize_bll()` em `R/modeling/factor_estimation.R` |
| `amengual_watson(scale = )` | `amengual_watson(standardize = )`, como em `bai_ng_criteria()` |
| `var_lag_criteria()` devolvia `data.frame` | devolve tibble, com as mesmas colunas e valores |

`validate_hac_kernel.R` e `validate_olea_kilian.R` passaram a carregar
`factor_space_diagnostics.R`. Os scripts de `arquivo/` que chamam as funções
movidas carregando só `impulse_response.R`, ou que chamam `plot_irf()` ou
`panel_eigenvalues()`, deixam de rodar; o acervo não é mantido.


## 2026-09-21 — fim de `production_spec()`

`R/modeling/production_spec.R` foi **apagado** (decisão do autor: a
especificação centralizada obrigava um segundo arquivo para auditar qualquer
número). Cada argumento, caminho, dimensão e janela passou a ser um literal no
bloco de constantes do script que o usa. Nenhum número se moveu: o smoke test
saiu bit-idêntico e todo `.csv`/`.rds` de `output/` saiu byte-idêntico na
re-rodada.

| antes | agora |
|---|---|
| `production_spec()$data_path`, `$sample`, `$r`, `$q`, `$p`, `$horizon`, `$mp_var`, `$shock_bps`, `$instrument`, `$inference`, `$ci_levels`, `$ar_nw_lags`, … | literais no topo de cada script que os lê |
| `production_spec()$covid_volatility` | `read_covid_volatility("output/factors/covid_volatility_theta.csv")`, em `R/modeling/factor_estimation.R` |
| `production_spec()$covid_volatility_design` | literais em `script/covid_volatility_theta.R` e `script/validation/validate_production_spec.R` |
| `production_spec()$var_benchmark` | literais em `script/model_var.R`, `script/fig_weak_iv.R` e `script/validation/validate_mosw_ar.R` |
| `production_spec()$production_series_added`, `$base_series_removed` | literais em `script/clean.R` e `script/validation/validate_production_spec.R` |
| defaults `spec$…` de `main_sdfm()` | literais na assinatura, em `R/modeling/dfm_pipeline.R` |
| célula `ibc5_fx_cds_level_trend_p2` (VAR pequeno, 2013-01--2025-09, `p=2`) | `ibc5_fx_cds_level_trend_p4` (2012-03--2025-12, `p=4`, a janela e a ordem do DFM) |
| `script/model_var.R` escrevia `output/var/svar_iv_weak_robust.md` | não escreve mais; o `.md` fica congelado na vintage `p=4`, como registro citado, e o script só produz os três `.csv` |

`script/validation/validate_production_spec.R` deixou de validar um objeto e
passou a ser a **declaração canônica** da especificação: quando um literal de
script e esse arquivo discordarem, esse arquivo é o certo. O θ̂ é o único valor
que não é literal, porque é estimativa e não decisão — `readr` faz o
round-trip dos quatro doubles bit-idêntico, e
`script/covid_volatility_theta.R`, seu único produtor, é o único script que não
o lê.

Os 18 scripts de `arquivo/script/` e os 4 de `arquivo/nao_gaussiana/script/`
que fazem `source("R/modeling/production_spec.R")` **não** foram editados: a
maioria já não rodava, e agora nenhum roda. `diagnostics/_common.R` foi a única
exceção editada, para `06` e `07` continuarem rodando.

---

## 2026-09-18 — limpeza pós-inspeção visual e fim do Codex

Os motivos estão em `arquivo/README.md`. As saídas continuam em `output/`.

| antes | agora |
|---|---|
| `script/q_truncation.R` | `arquivo/script/q_truncation.R` |
| `containment_vs_production`, `plot_overlay_cells` em `R/identification/spec_sweep.R` | `arquivo/R/identification/spec_sweep.R` |
| `bai_ng_criteria`, `amengual_watson` em `R/modeling/factor_estimation.R` | `R/modeling/factor_selection.R` |
| `estimate_var_ols(data, p)` | `estimate_var_wls(data, p, s = 1)`, em `R/modeling/factor_estimation.R` |
| `output/instrument/instrument_diagnostics_report.md` (colunas da `tab:first_stage`) | `output/instrument/instrument_diagnostics.csv`; o `.md` fica como registro |
| `R/preprocessing/experimental_extensions.R` | `arquivo/R/preprocessing/experimental_extensions.R` |
| `factorial_drop_block_manifest`, `build_factorial_drop_block_panels` em `R/identification/experimental_panel.R` | `arquivo/R/identification/experimental_panel.R` |
| `diagnostics/rq_{block_dimension,dimension}_audit/scripts/` | `arquivo/diagnostics/rq_{block_dimension,dimension}_audit/scripts/`; README e `output/` ficam |
| `AGENTS.md` | `arquivo/codex/AGENTS.md` |

Apagado, não movido: `R/data_download/fred.R` e `fomc.R` (a purificação UST/FOMC
do instrumento), `load_fomc_dates` e `on_date` de `R/instrument/di_surprise.R`,
`build_monthly_z` e a varredura GK de `R/instrument/build_variants.R`,
`validate_dfm_results` de `R/modeling/impulse_response.R`; e, sem citação em
nota, `paper/fig_estado.pdf` e os `q_narrative_*.md`/`*_paths.csv`. Os CSVs por
variante em `data/processed/` deixaram de ser escritos: as três variantes vivem
em `instrumentos_mensais.csv`. Números de linha de todos os arquivos de `R/` e
`script/` tocados nesta data mudaram.

## 2026-09-18 — saída do wild bootstrap e da correção de Kilian

Os motivos estão em `arquivo/README.md`. As saídas continuam em `output/`.

| antes | agora |
|---|---|
| `script/fomc_coincidence.R` | `arquivo/script/fomc_coincidence.R` |
| `script/ar_bands.R` | `arquivo/script/ar_bands.R` |
| `R/instrument/event_tests.R` | `arquivo/R/instrument/event_tests.R` |

O código do bootstrap e de Kilian foi apagado, não movido: `kilian_correction()`,
`estimate_corrected_var()` e `solve_or_pseudo()` de
`R/modeling/factor_estimation.R`, o laço de réplicas e
`validate_bootstrap_results()` de `R/modeling/impulse_response.R`. A última
versão com eles é `main` em `07b1cbd`. Números de linha desses dois arquivos,
de `dfm_pipeline.R`, `spec_sweep.R` e de `validate_production_spec.R` citados
no acervo mudaram. `compute_irf_dfm(inference=)` trocou `"bootstrap"` por
`"none"` (só o ponto) e perdeu o default.

## 2026-09-17 — auditoria de `script/` e `R/`

Os motivos estão em `arquivo/README.md`. As saídas dos scripts arquivados
**não** se moveram: continuam em `output/`, no caminho que as notas citam.

| antes | agora |
|---|---|
| `script/<x>.R`, para os 25 scripts abaixo | `arquivo/script/<x>.R` |
| `script/validate_{mosw_ar,covid_volatility,production_spec,hac_kernel,olea_kilian,amengual_watson}.R` | `script/validation/validate_<…>.R` |
| `script/q_narrative_overlay_covid.R` | `script/q_sensitivity.R --window=cheia` |
| `script/q_narrative_overlay_precovid_p2.R` | `script/q_sensitivity.R --window=pre_covid` |
| `R/identification/validation_tests.R` | `arquivo/R/identification/validation_tests.R` |
| `theory_sign_table`, `summarize_irf_responses`, `evaluate_sweep_cell`, `classify_sweep_cells`, `rq_surface_table` em `R/identification/spec_sweep.R` | `arquivo/R/identification/spec_sweep.R` |
| `build_variant_panel`, `experimental_variant_manifest`, `build_experimental_panels`, `classify_mosw` em `R/identification/experimental_panel.R` | `arquivo/R/identification/experimental_panel.R` |
| `map_dynamic_direction_to_static` em `R/modeling/factor_estimation.R` | `arquivo/R/modeling/factor_estimation.R` |

Os 25 scripts arquivados:
- **painel:** `panel_composition{,_experimental,_rq_grid,_rq_grid_drop_blocks,_factor_selection_drop_blocks}.R`
  e os três `validate_panel_composition_{experimental,rq_grid,rq_grid_drop_blocks}.R`;
- **fiscais:** `fiscal_expectations.R`, `fiscal_dlsp_decomposition.R` e
  `fiscal_exchange_expectations.R`;
- **varredura IRF:** `irf_spec_sweep.R`, `irf_spec_stage2.R`, `p_selection.R`,
  `q_selection.R`, `q_narrative_overlay.R` e `q_narrative_overlay_r8.R`;
- **instrumento:** `jk_sovereign_confound.R`, `instrument_construction_sweep.R` e
  `xi_mp_robustness.R`;
- **DFM e benchmark:** `factor_stationarity.R`, `factor_selection_alt.R`,
  `asset_representation.R`, `price_cross_instrument.R` e `var_lag_comparison.R`.

Números de linha citados no acervo mudaram:
- em `spec_sweep.R`, `experimental_panel.R` e `factor_estimation.R`, depois das
  funções que saíram;
- em `script/q_truncation.R`, que perdeu o bloco de θ̂ por máxima verossimilhança
  (l.112-124) e o autoteste (f).


## 2026-08-17 — refactor de convenções (`coding-style`)

| antes | agora |
|---|---|
| `R/modeling/impulse_responde.R` | `R/modeling/impulse_response.R` |
| `R/data_download/fomc_dates.R` | `script/fomc_dates.R` |

O primeiro corrige um erro de grafia que sobreviveu desde o início do projeto; o
segundo move para `script/` um arquivo que nunca foi `source()`-ado por ninguém e
que, portanto, nunca foi módulo. **47 arquivos vivos** de código e documentação
foram repontuados na mesma passada. O acervo não foi tocado de propósito:

- **12 arquivos de `notas/`** citam `impulse_responde.R` ou
  `R/data_download/fomc_dates.R`;
- **4 arquivos de `pareceres/`** idem;
- **14 arquivos de `arquivo/`**, que é histórico e não se mexe.

⚠ **Números de linha do arquivo renomeado também envelheceram.** O refactor
moveu `main_sdfm` para `R/modeling/dfm_pipeline.R` e reordenou blocos, então uma
citação `impulse_responde.R:<linha>` do acervo aponta para o arquivo certo pelo
mapa acima, mas **não** necessariamente para a linha certa. Conferir antes de
reusar como referência.

## 2026-08-11 — adoção do esqueleto `/newproject`

Este mapa já existia dentro do blockquote de leitura de
`pareceres/council_2026-08-10.md`; fica aqui também para o acervo ter um lugar
único.

| antes | agora |
|---|---|
| `_instrucoes/` | `registro/` |
| `_instrucoes/Instrumento.md` | `registro/metodo.md` |
| `relatorio/working-notes/` | `notas/` |
| `relatorio/council_*` | `pareceres/` |
| `texto_anpec/` | `paper/` |
| `data/<x>` | `data/raw/<x>` (exceto `data/processed/`) |

## 2026-08-02 — arquivamento do draft

| antes | agora |
|---|---|
| `tex/main.tex` | `arquivo/tex/main.tex` |

O paper canônico passou a ser `paper/paper_anpec.tex`. As referências
`tex/main.tex:<linha>` nas notas continuam apontando para o mesmo conteúdo, só
que sob `arquivo/`.

## 2026-08-05 — módulo sem consumidor

| antes | agora |
|---|---|
| `R/modeling/svensson_model.R` | `arquivo/R/modeling/svensson_model.R` |

`script/yield_curve.R` foi apagado em 2026-07-26 e a curva do painel passou a ser
insumo externo fixo (`data/raw/yields/yields_dia.csv`).

---

## Arquivos cuja existência mudou

Casos em que o acervo afirma que um arquivo **não existia** e isso deixou de ser
verdade, ou o contrário. Não são renomes, e por isso não entram nas tabelas
acima.

- **`data/raw/fomc_dates.csv`** — o council de 2026-08-10 verificou que o arquivo
  **não existia**, e essa verificação está correta para a árvore daquele dia. Ele
  **passou a existir em 2026-08-10**. O download foi para `R/data_download/fomc.R`
  e saiu do código em 2026-09-18 com a purificação UST/FOMC; a cópia local
  continua em `data/raw/`, sem leitor.
- **`data/raw/di.csv`** — continua existindo localmente (vintage 2026-02-09) e é
  gitignored, mas **deixou de ser reprodutível a partir do upstream**: em
  2026-08-17 o `pyield-data` já não publica `b3_di.parquet`, mudou o schema e
  poda releases antigas. Ver `script/download_di.py` e o Tema E de
  `pendencias.md`.
