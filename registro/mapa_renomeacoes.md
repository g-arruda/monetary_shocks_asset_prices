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
  **passou a existir em 2026-08-10**, produzido pelo script hoje em
  `script/fomc_dates.R`.
- **`data/raw/di.csv`** — continua existindo localmente (vintage 2026-02-09) e é
  gitignored, mas **deixou de ser reprodutível a partir do upstream**: em
  2026-08-17 o `pyield-data` já não publica `b3_di.parquet`, mudou o schema e
  poda releases antigas. Ver `script/download_di.py` e o Tema E de
  `pendencias.md`.
