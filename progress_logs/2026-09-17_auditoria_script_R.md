# Auditoria de `script/` e `R/` — o que manter, fundir, arquivar ou excluir

**2026-09-17.** Rodada somente de leitura. Nada foi apagado, movido ou editado. Evidência por
`grep` de `source(`, dos nomes das funções definidas em `R/` e dos caminhos de saída em
`script/`, `R/`, `diagnostics/`, `paper/paper_anpec.tex`, `notas/`, `registro/`, `CLAUDE.md`,
`AGENTS.md`, `.claude/rules/`, `script/README.md` e `email/`, mais a leitura do cabeçalho e das
chamadas de cada arquivo. **"Aborta" significa leitura estática do código contra os artefatos
correntes, não execução**: nenhum script foi rodado nesta rodada.

### Regra de decisão aplicada

- **excluir**: os cinco critérios do pedido valem ao mesmo tempo.
- **arquivar**: fora da produção, nenhum número do paper, não é trava, mas uma nota em
  `notas/` (ou o registro) depende do arquivo para ser reproduzida.
- **manter**: falha o critério 1, 2 ou 4; **ou** um item aberto de `registro/pendencias.md`
  depende do script (regra acrescentada por mim: `arquivo/` "não reproduz contra o painel
  atual", e item aberto ainda pode exigir reexecução); **ou**, em `R/`, alguma função é chamada
  por arquivo que fica — `diagnostics/` conta como "fica", porque está fora do escopo.
- **fundir**: variantes que diferem só por parâmetro e que ficam vivas.
- Estar quebrado **não** muda o veredicto: script que não roda mas que uma nota cita é
  arquivado, não excluído.

## 1. Resumo

| pasta | veredicto | arquivos | linhas |
|---|---|---|---|
| `script/` | manter | 23 `.R` + `README.md` | 7 494 (+113) |
| `script/` | fundir | 2 → 1 | 418 → ~230 (economia ~190) |
| `script/` | arquivar | 25 | 9 625 |
| `script/` | excluir | 0 | 0 |
| `R/` | manter | 26 | 6 437, dos quais **353 linhas em 10 funções** saem para `arquivo/` com os scripts que as usavam |
| `R/` | arquivar | 1 (`validation_tests.R`) | 430 |
| `R/` | fundir | 0 arquivos (opcional: mover `md_table()` para `R/reporting/`) | — |
| `R/` | excluir | 0 | 0 |

**Saem do caminho ativo, se o plano for executado: 26 arquivos e ~10 400 linhas** (9 625 + 430
+ 353), mais ~190 linhas da fusão. **Nenhum arquivo é excluível** pelos cinco critérios: quase
todo script tem nota que o cita. O único candidato limpo, `q_narrative_overlay_r8.R`, foi
rebaixado para "arquivar" por dúvida (ver §4).

### Achados que independem do plano

1. **Nove scripts abortam contra os artefatos correntes desde a virada de 2026-09-17**, na
   leitura do código. O 17-09 trocou os sítios de chamada, mas não os executou.
   - `q_selection.R`, `p_selection.R`, `asset_representation.R` e `price_cross_instrument.R`
     passam `SPEC$covid_volatility` a células com `nboot = 800`, que `compute_irf_dfm()` recusa
     sob a escala (`impulse_response.R:478`). `asset_representation.R:255-260` ainda liga
     Kilian sob a escala (`factor_estimation.R:930`).
   - `price_cross_instrument.R:198-209` passa a escala a uma janela **pré-COVID**, que não
     contém 2020-03. O comentário do sítio diz "Full window".
   - `factor_stationarity.R:226`, `q_truncation.R` (autotestes a e b) e `q_narrative_overlay.R`
     (l.97-101) comparam uma célula OLS com o cache tratado a 1e-6 ou 1e-10.
   - `jk_sovereign_confound.R` e `fomc_coincidence.R` também abortam. Desde a migração de
     2012-03, o smoke h0 está fixado na vintage de 111 séries (`cambio_usd` 0,1539). Desde 09-17,
     o ξ_mp OLS é conferido contra a `mosw_strength_grid.csv` tratada.
2. **Sete arquivos abortam desde a migração para 2012-03.** São os quatro geradores
   `panel_composition_{experimental,rq_grid,rq_grid_drop_blocks,factor_selection_drop_blocks}`
   e os três `validate_panel_composition_*`, que exigem 153 meses de 2013-01 a 2025-09. A base
   de 106 séries tem hoje 166 meses. `fiscal_expectations.R` também aborta, porque exige 111
   séries.
3. **`fomc_coincidence.R` é fonte da §5.3 do paper e não roda.** Os números publicados vêm de
   `output/instrument/fomc_coincidence.md`, commit `08ccff3` de 2026-08-25, na vintage de 62
   dias.
4. **`R/identification/validation_tests.R` é código morto dentro da produção.**
   `irf_coherence_check.R:26` e `irf_spec_stage2.R:22` fazem `source()` dele, e nenhuma das 12
   funções é chamada em lugar algum.

## 2. Tabelas

### 2.1 `script/`

| arquivo | veredicto | evidência | confiança |
|---|---|---|---|
| `run_all.R` | manter | orquestrador; estágios download/clean/instrument/model | alta |
| `download.R` | manter | estágio `download`; único `source()` de `R/data_download/*` | alta |
| `clean.R` | manter | estágio `clean`; escreve `data_log_deseasonalized{,_base_106}.csv` e o manifesto | alta |
| `instrument.R` | manter | estágio `instrument`; R² BS 0,022 e 102/67/35 reuniões da §3.3 (`notas/2026-09-17_reorganizacao_secao_3` §3) | alta |
| `model_alessi.R` | manter | estágio `model`; `main_sdfm()`; superfície Bai–Ng (r=5 da §3.1) | alta |
| `irf_coherence_check.R` | manter | `irf_coherence_h.csv` (fonte da §5) e `irf_coherence_cell.rds` (lido por `fig_section5.R`); ⚠ `source()` morto de `validation_tests.R` | alta |
| `model_var.R` | manter | benchmark VAR; `output/var/svar_iv_weak_robust.csv` → `fig_weak_iv.R`, §5.2 | alta |
| `fig_section5.R` | manter | 8 figuras da §4 (`fig_curva` … `fig_acoes`); congelado atrás de `--repaint-paper-figures` | alta |
| `fig_weak_iv.R` | manter | `paper/fig_weak_iv_main.pdf` | alta |
| `mosw_strength_grid.R` | manter | `tab:first_stage`: ξ_mp e F_rob por camada nas duas janelas (nota 09-17 reorg §3); régua de registro | alta |
| `instrument_diagnostics.R` | manter | `tab:first_stage`: meses z≠0, β̂, EP, p (`instrument_diagnostics_report.md`) | alta |
| `covid_volatility_theta.R` | manter | θ̂ da §3.1 e proveniência dos literais de `production_spec()` (l.35); pendência aberta "ótimo global de θ̂" (`pendencias.md:157`) | alta |
| `validate_production_spec.R` | manter | AIC p=4 (8,231267, T=154) da §3.1 via `production_factor_lag_criteria.csv`; trava (§2.3) | alta |
| `factor_selection_pruned.R` | manter | §3.1 "Amengual–Watson com r=5, p=4 seleciona q=2" (`factor_selection_pruned_aw.csv`, painel `atual`; `notas/2026-09-10_poda_correlacao_painel` l.92); pendência passo 2/4 (`pendencias.md:370`) | alta |
| `fomc_coincidence.R` | manter | §5.3 inteira (24/62 dias, 35,5%, p 0,458/0,466/0,511, R² 0,005/0,108); ⚠ aborta (achado 1), reexecução já é a pendência de `pendencias.md:161` | alta |
| `validate_mosw_ar.R` | manter | trava (§2.3) | alta |
| `validate_covid_volatility.R` | manter | trava (§2.3) | alta |
| `validate_hac_kernel.R` | manter | trava (§2.3) | alta |
| `validate_olea_kilian.R` | manter | trava (§2.3) | alta |
| `validate_amengual_watson.R` | manter | trava (§2.3) | alta |
| `ar_bands.R` | manter | único lugar em `output/` que registra as células barradas por `hac_dim < T` ((8,8), pré-COVID p=4) e o (5,2) ilimitado — proibições do `CLAUDE.md` ("reported blocked, in code, in output/ and in the record"); o autoteste 5 trava (8,8) barrada; OLS por desenho (nota 09-17 §3, `identification.md:90`); roda | alta |
| `q_truncation.R` | manter | nota `2026-09-10_truncamento_q` CURRENT e célula `cheia_p4_lp` (nota 09-14); defesa de q=r contra AW q=2, que sustenta os itens abertos do Tema B (`pendencias.md:331`, `:361`); ⚠ aborta (achado 1) | média |
| `panel_pruning.R` | manter | produz `pruning_manifest.csv`, lido por `factor_selection_pruned.R`; pendência passo 2/4 | alta |
| `q_narrative_overlay_covid.R` | fundir | pendência passo 4/4 (`pendencias.md:375`), `CLAUDE.md:141`; ver §2.4 | média |
| `q_narrative_overlay_precovid_p2.R` | fundir | mesma pendência (`q_narrative_r5p2_precovid.*`); ver §2.4 | média |
| `asset_representation.R` | arquivar | nota `2026-07-31_acoes_representacao` (sustenta "log-level … do not reopen", `CLAUDE.md:130`); fora do paper; ⚠ aborta | alta |
| `factor_selection_alt.R` | arquivar | nota `2026-09-10_selecao_fatores_ah_abc`; fora do paper; `factor_selection_alt_summary.csv` é alvo de regressão de `factor_selection_pruned.R:88` — **o CSV fica em `output/`** | média |
| `factor_stationarity.R` | arquivar | nota `2026-07-31_estacionariedade_fatores` HISTÓRICA; `CLAUDE.md:128`; ⚠ aborta | alta |
| `fiscal_expectations.R` | arquivar | nota `2026-09-01_teste_expectativas_fiscais`; superado por `R/preprocessing/production_extensions.R`; ⚠ exige 111 séries | alta |
| `fiscal_dlsp_decomposition.R` | arquivar | nota `2026-09-01_decomposicao_contabil_dlsp` (bloqueada na identidade de 7 fluxos) | alta |
| `fiscal_exchange_expectations.R` | arquivar | nota `2026-09-01_painel_115_…` (superada para o DFM); o README diz que alimenta as figuras fiscais, mas `fig_section5.R` não lê `output/fiscal_exchange_expectations/` e as legendas dizem "painel canônico"; execução não verificada | alta |
| `instrument_construction_sweep.R` | arquivar | nota `2026-07-27_robustez_xi_mp_e_construcao` (sustenta "DI vertex: do not reopen"); o R² 0,024 que alimentava a §3 foi trocado pelo de `instrument.R`; estima OLS na cheia | média |
| `irf_spec_sweep.R` | arquivar | notas 07-11 (contraditada), 07-15, `08-18_varredura_p`; `metodo.md:158`; `spec_sweep_cells.csv` é citado por `.claude/rules/data.md:61` — **fica em `output/`** | média |
| `irf_spec_stage2.R` | arquivar | mesmas notas; OLS por desenho; depende do CSV do estágio 1; `source()` morto de `validation_tests.R` | média |
| `jk_sovereign_confound.R` | arquivar | notas 07-31 e 08-09 CURRENT; fora do paper corrente (a única menção, l.253, está comentada); ⚠ aborta; está na pendência "reexecutar … ou marcar de vintage" — arquivar é marcar de vintage | média |
| `panel_composition.R` | arquivar | nota `2026-08-13_composicao_do_painel` (106 séries, (7,6)); hoje roda sem escala e sem autoteste | alta |
| `panel_composition_experimental.R` | arquivar | nota `2026-08-13_teste_experimental_…` (SUPERSEDED); ⚠ exige 153 meses | alta |
| `panel_composition_rq_grid.R` | arquivar | nota `2026-08-13_grade_experimental_rq` (HISTÓRICA); ⚠ 153 meses | alta |
| `panel_composition_rq_grid_drop_blocks.R` | arquivar | notas `2026-08-13_grade_rq_fatorial_…` e `_parecer_dimensoes_rq`; ⚠ 153 meses | alta |
| `panel_composition_factor_selection_drop_blocks.R` | arquivar | notas `2026-08-13_selecao_fatores_blocos_fatoriais` e `_parecer`; ⚠ 153 meses | alta |
| `validate_panel_composition_experimental.R` | arquivar | trava de rodada extinta (§2.3); ⚠ 153 meses | alta |
| `validate_panel_composition_rq_grid.R` | arquivar | idem | alta |
| `validate_panel_composition_rq_grid_drop_blocks.R` | arquivar | idem | alta |
| `p_selection.R` | arquivar | nota `2026-08-18_varredura_p`; `CLAUDE.md:127`; o AIC da §3.1 vem de `validate_production_spec.R`, não daqui; ⚠ aborta | média |
| `q_selection.R` | arquivar | notas 08-17 e 08-18 (HISTÓRICAS, p=6); `q_selection.md` ainda é r=4, 2013-01; superado por `q_truncation.R` e `q_narrative_*`; ⚠ aborta | alta |
| `price_cross_instrument.R` | arquivar | nota `2026-08-18_precos_cross_instrumento` (HISTÓRICA para magnitudes); ⚠ aborta | alta |
| `var_lag_comparison.R` | arquivar | nota `2026-08-24_var_p2_vs_p6`; o `CLAUDE.md` proíbe células de sensibilidade no benchmark VAR | alta |
| `xi_mp_robustness.R` | arquivar | nota 07-27 CURRENT; `CLAUDE.md:124` (o "149" é da vintage antiga); fora do paper; roda e foi sincronizado em 09-17 → §4 | média |
| `q_narrative_overlay.R` | arquivar | `q_narrative_r5p4.*` é citado pela nota `2026-09-14_inferencia_volatilidade_covid_q` como a cheia sem tratamento; ⚠ aborta | alta |
| `q_narrative_overlay_r8.R` | arquivar | zero referências em notas, registro, `CLAUDE.md`, README e e-mails (idem para `q_narrative_r8p4.*`); r=8 é explosivo sob a escala → §4 | baixa |
| `README.md` | manter | catálogo; precisa de atualização (§3) — já está defasado ("46 scripts"; `q_narrative_overlay.R` e `_r8` fora da tabela) | alta |

### 2.2 `R/`

| arquivo | veredicto | evidência | confiança |
|---|---|---|---|
| `data_download/b3.R` | manter | `download.R` | alta |
| `data_download/bcb.R` | manter | `download.R` | alta |
| `data_download/exchange.R` | manter | `download.R` | alta |
| `data_download/external_factors.R` | manter | `download.R`; `fetch_yahoo_close` é auxiliar interno | alta |
| `data_download/focus.R` | manter | `download.R`; `fetch_olinda` e `last_focus_value_in_month` são internos | alta |
| `data_download/fomc.R` | manter | `download.R`; três auxiliares internos | alta |
| `data_download/fred.R` | manter | `download.R` | alta |
| `data_download/ipea.R` | manter | `download.R` | alta |
| `identification/experimental_panel.R` | manter | `base_block_taxonomy` (q_truncation, panel_pruning), `prune_correlated_series` (panel_pruning), `build_factorial_drop_block_panels` + `factorial_drop_block_manifest` (5 scripts de `diagnostics/rq_*_audit`). **Morrem com a família panel_composition:** `build_experimental_panels`, `build_variant_panel`, `experimental_variant_manifest`, `classify_mosw` (93 linhas) → arquivar junto | média |
| `identification/factor_space_diagnostics.R` | manter | `diagnose_instrument_in_factor_space` na produção | alta |
| `identification/irf_coherence.R` | manter | `irf_coherence_check.R`, `diagnostics/_common.R` | alta |
| `identification/spec_sweep.R` | manter | `run_stage2_cell` (irf_coherence_check), `norm_value_for`, `containment_vs_production`, `plot_dimension_overlay`, `plot_overlay_cells` (fomc), `md_table`. **Morrem:** `theory_sign_table`, `summarize_irf_responses`, `evaluate_sweep_cell`, `classify_sweep_cells` (só `irf_spec_sweep.R`) e `rq_surface_table` (só `panel_composition_rq_grid*`) — 246 linhas → arquivar junto | alta |
| `identification/validation_tests.R` | arquivar | 12 funções, zero chamadas (o `first_stage_F` de `diagnostics/07_dominancia_fiscal.R:331` é definição local); `source()` morto em `irf_coherence_check.R:26` e `irf_spec_stage2.R:22`; `notas/2026-07-11_varredura_irf.md:78` e `historico_decisoes.md:404` citam `first_stage_F`/`residualize_target` → arquivar, não excluir | alta |
| `identification/weak_iv_ar.R` | manter | conjuntos AR do DFM e do VAR | alta |
| `instrument/build_variants.R` | manter | `instrument.R`; agregadores internos | alta |
| `instrument/di_surprise.R` | manter | `instrument.R` | alta |
| `instrument/event_tests.R` | manter | `wild_coef_test`/`wild_wald_test` só em `fomc_coincidence.R` (morre se ele sair) | alta |
| `modeling/dfm_pipeline.R` | manter | `main_sdfm()` | alta |
| `modeling/factor_estimation.R` | manter | núcleo. **Morre:** `map_dynamic_direction_to_static` (14 linhas, só `panel_composition*.R`) → arquivar junto | alta |
| `modeling/factor_selection.R` | manter | `ahn_horenstein`/`abc_criterion` via `factor_selection_pruned.R` | alta |
| `modeling/impulse_response.R` | manter | núcleo | alta |
| `modeling/production_spec.R` | manter | núcleo | alta |
| `modeling/var_proxy.R` | manter | `model_var.R`, `validate_mosw_ar.R`, `weak_iv_ar.R` | alta |
| `preprocessing/experimental_extensions.R` | manter | só vive por `build_experimental_inputs` ← `build_factorial_drop_block_panels` ← `diagnostics/rq_*_audit`, que também exigem 153 meses → §4 | baixa |
| `preprocessing/production_extensions.R` | manter | `clean.R` | alta |
| `preprocessing/seasonality.R` | manter | `clean.R` | alta |
| `reporting/markdown_report.R` | manter | `md_tbl`/`fmt` (model_var, ar_bands, fomc …); fusão opcional em §2.4 | alta |

### 2.3 Travas `validate_*.R` — o que protegem e se o invariante existe

| script | protege | invariante vivo? |
|---|---|---|
| `validate_mosw_ar.R` | caminho VAR bit-idêntico com `Load`/`Inner` = I em `weak_iv_ar.R`; fixture MOSW oil (AL, η, Σ, Γ, WHat, conjuntos 68/95); 10 casos degenerados; AIC p=2 / BIC p=1 | sim: benchmark VAR ativo e módulo compartilhado com o DFM |
| `validate_covid_volatility.R` | θ neutro ⇒ WLS `identical()` ao OLS (ponto sem tratamento fixado); pipeline tratado = produção a 1e-12; (B5); `stop()`s; VAR simulado; AR/ξ tratados contra MOSW alimentado à mão | sim: a escala é produção desde 09-17 |
| `validate_production_spec.R` | composição 115/106, 166 datas, SGS 20784/20785, contrato do instrumento, Bai–Ng BLL, AIC (8,231267), força e raízes, 5 impactos, θ̂ re-derivado | sim |
| `validate_hac_kernel.R` | ramo NW de `compute_factor_space_wald` = `NW_hac_STATA.m` (lags 0–8) e fixture TaxSVARIV (NWlags=8); equivalência da residualização Shat (`impulse_response.R:197`) | sim para a residualização (entra em todo ξ_mp). O ramo NW>0 perde o único consumidor vivo se `xi_mp_robustness.R` sair (produção usa NW(0)) |
| `validate_olea_kilian.R` | `compute_robust_first_stage_F` e `compute_factor_space_wald` reproduzem ξ=4,4 e F=9,4 de MOSW | sim: são as réguas de `tab:first_stage` |
| `validate_amengual_watson.R` | `amengual_watson()` contra o MATLAB de Stock–Watson; gap `log(n/(n−1))` | sim: AW q=2 está na §3.1 |
| `validate_panel_composition_experimental.R` | 19 entradas experimentais, ξ/F nas duas janelas, smoke 5/5 da rodada (7,6,6) | não: painel 106/153 meses superado; aborta |
| `validate_panel_composition_rq_grid.R` | 324 células finitas, 18 tabelas, célula de referência | não; aborta |
| `validate_panel_composition_rq_grid_drop_blocks.R` | 2 304 células, 64 painéis sem duplicatas, reprodução da grade anterior | não; aborta |

### 2.4 Fusão

- **`q_narrative_overlay*` (4 arquivos) → fundir só os dois vivos.** Contra o irmão sem
  tratamento, `_covid` e `_precovid_p2` diferem por janela (`sample` / `pre_covid_sample`),
  `p` (4 / 2), `covid_volatility` (tratado / `NULL`) e rótulos. O único bloco extra de `_covid`
  re-estima θ̂ e confere contra `covid_volatility_theta.csv` a 1e-8. Desde 09-17 esse bloco
  vira `SPEC$covid_volatility`, que é o mesmo θ̂, travado por `validate_production_spec.R`.
  Portanto a diferença é de parâmetro: um script linear com `--window=cheia|pre_covid` lido no
  topo, como `--repaint-paper-figures`. Os nomes de saída atuais ficam, para as notas seguirem
  válidas. Nome novo: não reutilizar `q_narrative_overlay.R`, que a nota de 09-14 cita.
  `q_narrative_overlay.R` e `_r8` não entram na fusão: o primeiro é o irmão OLS quebrado, o
  segundo não tem bandas nem o bloco de contenção (é lógica removida, não parâmetro).
- **`panel_composition*` + `validate_panel_composition_*` → não fundir.** `panel_composition.R`
  (censo/LOBO/LOSO), `_experimental` (IRF e bootstrap) e `_factor_selection_drop_blocks`
  (BN/AW, sem ξ) diferem por lógica. `_rq_grid` e `_rq_grid_drop_blocks` diferem sobretudo pelo
  construtor do painel (54 linhas de 160 no miolo), ou seja, quase por parâmetro. Mas os sete
  saem juntos, quebrados, e as notas de 08-13 citam os nomes: fundir custaria trabalho em código
  morto e quebraria a proveniência.
- **`irf_spec_sweep.R` / `irf_spec_stage2.R` → não fundir.** A lógica difere (sweep pontual
  com taxonomia versus bootstrap nas vencedoras), o estágio 2 depende do CSV do 1 e os dois são
  arquivados.
- **`fiscal_*` → não fundir.** Lógicas distintas: Focus 114 séries, identidade DLSP 118,
  conjunto 111/112/114/115. Arquivam juntos.
- **Outras famílias → não fundir.** `validate_olea_kilian` / `_hac_kernel` / `_mosw_ar`
  compartilham fixtures, mas testam funções diferentes. `p_selection` / `q_selection` diferem
  por parâmetro, mas ambos saem. `factor_selection_alt` ⊂ `factor_selection_pruned` só em
  parte: a auditoria do pacote `factorselect` só existe no primeiro.
- **`R/` (opcional).** `md_table()` é utilitário de relatório dentro do domínio de
  identificação (`spec_sweep.R`), e vários scripts só fazem `source()` de `spec_sweep.R` por ela
  (comentários `# md_table`). A proposta é **mover** a função, sem unificar, para
  `R/reporting/markdown_report.R`. O cabeçalho desse arquivo avisa que `md_table` e `md_tbl`
  renderizam dígitos diferentes. Confiança média.

**Destino sugerido do arquivamento**, pelo precedente de 2026-08-01:
- os scripts vão para `arquivo/script/`;
- as funções mortas vão para `arquivo/R/<domínio>/`;
- cada bloco ganha uma seção em `arquivo/README.md`;
- **as saídas ficam em `output/`**, porque as notas citam esses caminhos.

## 3. Referências por nome a atualizar se o plano for executado

- **`run_all.R`**: nenhuma. Não chama nenhum arquivo afetado.
- **`script/README.md`**: as linhas das 25 entradas arquivadas (48, 56–58, 65–67, 69–70, 73,
  81–82, 84–92, 106–108), a linha 69 da fusão e a contagem "46 scripts".
- **`CLAUDE.md`**:
  - tabela de rodadas concluídas, l.122 (jk), 124 (xi), 125 (construction), 126 (price),
    127 (p), 128 (stationarity), 130 (asset), 133–135 (fiscal), 138 (alt) e 141 (nome
    fundido);
  - *Common commands*, l.246, 247, 251, 255, 256, 265 e 266.
- **`AGENTS.md`**: nenhuma referência por nome aos afetados; só manter a paridade se a tabela
  de rodadas mudar.
- **`.claude/rules/`**:
  - `identification.md`: `paths:` l.6–8 (`factor_stationarity`, `asset_representation`,
    `irf_spec_*`), l.90 e l.109;
  - `instrument.md`: `paths:` l.5 (jk) e l.8 (xi), e já hoje aponta para
    `script/model_var_weak_iv.R`, **que não existe**;
  - `data.md`: l.50 (jk); l.61 cita `spec_sweep_cells.csv`, que fica.
- **Registro**:
  - `pendencias.md`, l.161–166 (o item "reexecutar ou marcar de vintage" fecha em parte com o
    arquivamento) e l.378 (nome fundido);
  - `metodo.md`, l.137, 158, 208, 210, 367 e 461;
  - `historico_decisoes.md`, l.91–97, 107, 128, 175, 242 e 404 (`validation_tests.R`);
  - `estrutura_paper_v2.md:291` é roteiro histórico e fica como está.
- **Comentários e `source()` em arquivos que ficam**:
  - `instrument.R:32` e `:48`, `fomc_coincidence.R:56`, `q_truncation.R:52`,
    `factor_selection_pruned.R:13` e `:88`, `q_narrative_overlay_covid.R:9-10`;
  - `R/identification/spec_sweep.R:6`, `R/modeling/production_spec.R:75`,
    `R/instrument/build_variants.R:9` e `:321`, `R/instrument/event_tests.R:4`;
  - `irf_coherence_check.R:26`, o `source()` de `validation_tests.R`.
- **Outros**:
  - `README.md` da raiz, l.161;
  - `notas/_indice.md` ganha uma linha-banner com o mapa de caminhos, como no precedente
    `tex/` → `arquivo/tex/` de 2026-08-02; as notas em si são append-only e não mudam;
  - `diagnostics/diagnostico_dfm.md` l.418, 773 e 1429 são entregável de auditoria fechada:
    no máximo uma nota de leitura.

## 4. Dúvidas

- **`q_narrative_overlay_r8.R`** (arquivar ou excluir). Cumpre os cinco critérios de exclusão,
  mas o item aberto "avaliar r=q=8" (`pendencias.md:331`) é seu único consumidor possível.
  Fica "arquivar" até esse item fechar sem citá-lo. `q_narrative_r8p4.*` está igualmente órfão.
- **`xi_mp_robustness.R`** (arquivar ou manter). Pelos critérios, arquivar. Mas roda, o autor
  o sincronizou em 09-17, e ele é o único consumidor vivo do ramo NW>0 que
  `validate_hac_kernel.R` trava. Se o autor o quer como checagem viva da régua, manter.
- **`q_truncation.R`** (manter ou arquivar). Mantido pelo Tema B aberto, mas aborta. Precisa
  de decisão: reancorar os autotestes (a) e (b) em `cheia_p4_lp`, ou marcar `cheia_p4` de
  vintage.
- **`jk_sovereign_confound.R` e `fomc_coincidence.R`**. A pendência de `pendencias.md:161`
  pede reexecutar ou marcar de vintage. Para jk, arquivar é marcar de vintage. fomc fica pelo
  paper, mas a §5.3 é da vintage de 62 dias, e reexecutar exige atualizar o smoke e o alvo de ξ.
- **`experimental_extensions.R` e a metade fatorial de `experimental_panel.R`**. Só vivem por
  `diagnostics/rq_dimension_audit/` e `diagnostics/rq_block_dimension_audit/`, fora do escopo e
  também presos a 153 meses. Se o autor arquivar essas duas pastas, +253 linhas e ~80 linhas de
  `R/` viram código morto.
- **`fiscal_exchange_expectations.R`**. O README afirma que alimenta "o complemento
  experimental das figuras fiscais", o que o código de `fig_section5.R` desmente. Execução
  corrente não verificada.
- **Fora do escopo, só para registro**:
  - `output/factors/q_narrative_r4p4.*` não tem produtor nem citação;
  - `.claude/rules/writing.md` descreve `sec:exogeneidade`, `sec:invertibilidade` e
    `sec:confound`, que não existem no paper corrente.
