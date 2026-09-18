# `arquivo/` — código e documentos fora do pipeline ativo

Criado em **2026-07-26**. Nada aqui é executado pelo pipeline de produção nem
citado pelo paper. O conteúdo foi preservado — em vez de apagado — porque
documenta **resultados negativos** e decisões revertidas que custaram trabalho e
que não estão registrados em nenhum outro lugar do repositório.

**Leia antes:** [`registro/historico_decisoes.md`](../registro/historico_decisoes.md)
explica *por que* cada bloco foi arquivado. Este README só diz *o que* está aqui.

> ⚠️ Nada aqui reproduz contra o painel atual. Todo este material é anterior ao
> **refresh de vintage de 2026-07-24** (106 séries) e/ou à **correção de tcode
> dos índices B3** da mesma data. Os artefatos de instrumento anteriores a
> 2026-05-07 também estão **100× fora de escala** por causa do bug de unit
> scaling do `yield_6m`. Trate os números como história, não como referência.
> **Exceção:** os blocos arquivados em 2026-09-17 e 2026-09-18 são mais novos
> e valem o que as tabelas deles dizem, script a script. Mesmo ali, nada roda
> sem ajuste.

---

## `arquivo/script/` — scripts

### Track de heterocedasticidade (removido em 2026-09-01)

Os scripts e módulos exclusivamente dedicados à rota foram removidos depois da
reestimação final no painel de 115 séries. Os nomes e a função de cada arquivo
permanecem no histórico Git e em `arquivo/heterocedasticidade/README.md`; os
artefatos que sustentam o resultado negativo foram preservados.

### Órfãos (superados por scripts vivos)

| script | por que saiu |
|---|---|
| `instrument_grid.R` | Sweep vértice × amostra de purificação com só as 4 variantes legadas; anterior ao `z_jk_bs_purif` |

### Diagnóstico de contaminação de IRF (superado em 2026-07-24, arquivado em 2026-08-01)

Investigação de 2026-07-15/16 sobre por que um `ξ_mp > 0` ainda podia entregar
uma IRF contaminada. Ficou obsoleta com o refresh de vintage de 2026-07-24
(que resolveu o problema por uma causa não relacionada às hipóteses testadas
aqui) e não é citada em nenhum lugar do CLAUDE.md corrente. A nota-irmã já
estava marcada "superseded" em `notas/_indice.md`; dois
destes scripts citam `arquivo/_instrucoes/irf_consistentes.md`, que não existe mais.

| script | o que fazia |
|---|---|
| `irf_instrument_diag_sweep.R` | Grid de 6 instrumentos × 3 (r,q) × 2 amostras classificando contaminação de curva/núcleo/câmbio em cada célula contra a força MOSW |
| `irf_instrument_report.R` | Relatório por variável da resposta a 6 instrumentos × (r,q) × amostra, com bandas 68/90 |
| `irf_instrument_report_plots.R` | Regenerava os dois PDFs de `irf_instrument_report.R` a partir do CSV de caminhos em cache, sem re-bootstrap |
| `irf_rq_candidates.R` | Estimava 5 pares (r,q) candidatos e pontuava 10 variáveis-chave contra a tabela de coerência; recomendou (7,6), que virou produção por um motivo não relacionado (o refresh de vintage) |
| `irf_sample_diagnostic.R` | Testava se a contaminação vinha da janela COVID ou de rotação espectral, com 5 células fixas incl. o "benchmark exato dos autores" (r=q=8) |

### Régua legada `f_factor` (superada em 2026-07-26, arquivada em 2026-08-05)

| script | o que fazia | por que saiu |
|---|---|---|
| `diagnose_factor_space_F.R` | Grid do max-F univariado sobre as q inovações de fator, `r=7,p=6` fixos, `q∈{2,3,4,6}` × 8 variantes. Escrevia `factor_space_F_grid.csv` | O `f_factor` **deixou de decidir** em 2026-07-26, quando a taxonomia migrou para ξ_mp (`classify_sweep_cells`); sob a régua antiga o instrumento de produção pontuava 6,31 e nunca alcançava uma célula "elegível", enquanto `z_jk_purif` pontuava 11,08 com ξ_mp 5,77 — exatamente a inversão que motivou a troca. A triagem de 2026-08-05 confirmou que ele não é dependência nem do `paper/` nem de nenhum item da tier list de robustez |

### Auditoria de `script/` e `R/` (arquivado em 2026-09-17)

A auditoria de 2026-09-17 separou o que é carga viva do que só documenta uma
rodada fechada. Os 25 scripts abaixo saíram de `script/` porque não são produção,
não geram número do paper e não travam código. Todos estão aqui, e não apagados,
porque uma nota de `notas/` depende deles para ser reproduzida.

Três regras valem para o bloco inteiro:
- **As saídas ficam em `output/`**, onde as notas as citam, e não vieram para
  `arquivo/`.
- **Os scripts não foram editados.** Os `source()` deles ainda apontam para
  `R/`, e várias funções que só eles chamavam vieram para `arquivo/R/` (tabela
  abaixo).
- **Estar quebrado não decidiu nada.** Vários já abortavam antes de sair; a
  coluna de estado diz como cada um estava.

O mapa `antes → agora` está em `registro/mapa_renomeacoes.md`.

**Composição do painel** (rodadas de 2026-08-13, sobre a base de 106 séries):

| script | nota | estado ao sair |
|---|---|---|
| `panel_composition.R` | `2026-08-13_composicao_do_painel` | roda, sem a escala COVID e sem autoteste |
| `panel_composition_experimental.R` | `2026-08-13_teste_experimental_composicao_painel` | aborta: exige 153 meses de 2013-01 a 2025-09, e a base tem 166 desde a migração para 2012-03 |
| `panel_composition_rq_grid.R` | `2026-08-13_grade_experimental_rq` | aborta (153 meses) |
| `panel_composition_rq_grid_drop_blocks.R` | `2026-08-13_grade_rq_fatorial_sem_duplicatas`, `2026-08-13_parecer_dimensoes_rq` | aborta (153 meses) |
| `panel_composition_factor_selection_drop_blocks.R` | `2026-08-13_selecao_fatores_blocos_fatoriais` | aborta (153 meses) |
| `validate_panel_composition_{experimental,rq_grid,rq_grid_drop_blocks}.R` | as mesmas | travas da rodada extinta; abortam pelo mesmo motivo |

**Experimentos fiscais** (2026-09-01; o painel de 115 séries entrou na produção por
`R/preprocessing/production_extensions.R`, não por estes):

| script | nota | estado ao sair |
|---|---|---|
| `fiscal_expectations.R` | `2026-09-01_teste_expectativas_fiscais` | aborta: exige o painel de 111 séries |
| `fiscal_dlsp_decomposition.R` | `2026-09-01_decomposicao_contabil_dlsp` | para por desenho quando a identidade de sete fluxos não fecha |
| `fiscal_exchange_expectations.R` | `2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais` | não verificado. O catálogo antigo dizia que ele alimentava as figuras fiscais, mas `fig_section5.R` não lê `output/fiscal_exchange_expectations/` |

**Varredura de especificação da IRF:**

| script | nota | estado ao sair |
|---|---|---|
| `irf_spec_sweep.R` | `2026-07-11_varredura_irf`, `2026-08-18_varredura_p` | `output/irf/spec_sweep_cells.csv` continua citado por `.claude/rules/data.md` |
| `irf_spec_stage2.R` | as mesmas | OLS por desenho; depende do CSV do estágio 1 |
| `p_selection.R` | `2026-08-18_varredura_p` | aborta: passa a escala COVID a células com `nboot = 800`. O AIC da §3.1 vem de `script/validation/validate_production_spec.R` |
| `q_selection.R` | `2026-08-17_selecao_q_e_fidelidade_amengual_watson`, `2026-08-18_q_checagem_figura_a3` | aborta (escala com bootstrap); `q_selection.md` ainda é `r=4`, 2013-01 |
| `q_narrative_overlay.R` | `2026-09-14_inferencia_volatilidade_covid_q`, que cita `q_narrative_r5p4.*` como a cheia sem tratamento | aborta: compara a célula OLS com o cache tratado |
| `q_narrative_overlay_r8.R` | nenhuma | `r = 8` é explosivo sob a escala; o item "avaliar `r=q=8`" de `pendencias.md` é o único consumidor possível |

**Instrumento:**

| script | nota | estado ao sair |
|---|---|---|
| `jk_sovereign_confound.R` | `2026-07-31_confound_soberano_jk`, `2026-08-09_confound_soberano_cds` | aborta: o smoke de h0 está na vintage de 111 séries e o alvo de ξ_mp é a grade tratada. Arquivar é o "marcar de vintage" da pendência |
| `instrument_construction_sweep.R` | `2026-07-27_robustez_xi_mp_e_construcao` (o vértice DI "não reabrir") | estima OLS na cheia |
| `xi_mp_robustness.R` | `2026-07-27_robustez_xi_mp_e_construcao` | roda, sincronizado em 2026-09-17; era o único consumidor vivo do ramo NW>0 que `script/validation/validate_hac_kernel.R` trava |

**Estrutura do DFM e benchmark:**

| script | nota | estado ao sair |
|---|---|---|
| `factor_stationarity.R` | `2026-07-31_estacionariedade_fatores` | aborta: compara uma célula OLS com o cache tratado |
| `factor_selection_alt.R` | `2026-09-10_selecao_fatores_ah_abc` | `output/factors/factor_selection_alt_summary.csv` fica, porque `script/factor_selection_pruned.R` o usa como alvo de regressão |
| `asset_representation.R` | `2026-07-31_acoes_representacao` (o log-nível "não reabrir") | aborta: liga Kilian e o bootstrap sob a escala |
| `price_cross_instrument.R` | `2026-08-18_precos_cross_instrumento` | aborta: bootstrap sob a escala, e a escala passada a uma janela pré-COVID |
| `var_lag_comparison.R` | `2026-08-24_var_p2_vs_p6` | o `CLAUDE.md` proíbe células de sensibilidade no benchmark VAR |

`q_narrative_overlay_covid.R` e `q_narrative_overlay_precovid_p2.R` **não** estão
aqui. Foram fundidos em `script/q_sensitivity.R --window=cheia|pre_covid`, que
mantém os nomes de saída, e apagados.

### Remoção do wild bootstrap e da correção de Kilian (arquivado em 2026-09-18)

Os conjuntos Anderson--Rubin substituíram o wild bootstrap de Gonçalves-Kilian
como inferência do DFM em 2026-09-08. Em 2026-09-18, por decisão do autor, o
bootstrap e a correção de Kilian saíram de `R/`, e com eles os dois scripts
abaixo. As mesmas regras do bloco anterior valem aqui: as saídas ficam em
`output/` e os scripts não foram editados.

| script | nota | estado ao sair |
|---|---|---|
| `ar_bands.R` | `2026-09-08_bandas_anderson_rubin_producao` | rodava, sem a escala COVID por desenho, porque o bootstrap não roda sob ela; deixa de rodar sem o bootstrap. `output/irf/ar_bands*` continua sendo o registro das células que `hac_dim < T` barra. O `(5,2)` ilimitado dele (ξ_mp 2,339) é do modelo sem tratamento; sob a escala de produção, `(5,2)` tem ξ_mp 5,124 (`output/factors/q_truncation_cells.csv`) |
| `fomc_coincidence.R` | `2026-08-10_coincidencia_fomc`, `2026-08-24_migracao_dfm_p4`; fonte da §5.3 do paper | aborta: o smoke de h0 está na vintage de 111 séries e o alvo de ξ_mp é a grade tratada. A §5.3 usa só timing, exposição e a regressão diária; a seção de IRFs do DFM com 800 réplicas não entra no paper. Os números da §5.3 são da janela 2013-01 (62 dias) |

`R/instrument/event_tests.R` (`wild_coef_test`, `wild_wald_test`), o wild
bootstrap das regressões diárias de evento, veio junto: `fomc_coincidence.R` era
o último consumidor vivo. Desde esta data, também nenhum script arquivado que
passe `nboot`, `apply_kilian` ou `inference = "bootstrap"` roda contra `R/`.

## `arquivo/R/modeling/` — módulos

| módulo | conteúdo | por que saiu |
|---|---|---|
| `factor_estimation.R` | `map_dynamic_direction_to_static` (14 linhas), retirada de `R/modeling/factor_estimation.R` em 2026-09-17 | Só `panel_composition.R` e `panel_composition_experimental.R` a chamavam |
| `svensson_model.R` | Ajuste de curva de Svensson (1994): `svensson_rate`, `fit_svensson`, `generate_fixed_maturity_series`, `svensson_forward_rate`, `summarize_svensson_fit`, `plot_svensson_fit`, `calculate_yield_spreads` (~600 linhas) | Órfão desde a deleção de `script/yield_curve.R` em 2026-07-26 — a curva de juros é insumo externo fixo do orientador (`data/raw/yields/yields_dia.csv`), não há estágio de ajuste no repositório. Zero consumidores em `script/`, `R/` ou `diagnostics/`. **Arquivado, não apagado**, porque é código de modelagem reutilizável: se a curva algum dia voltar a ser ajustada in-house, comece daqui. Fecha a pendência E5, que pedia exatamente esta decisão |

## `arquivo/R/instrument/` — módulos

| módulo | conteúdo | por que saiu |
|---|---|---|
| `event_tests.R` | `wild_coef_test` e `wild_wald_test`: teste HC1 de um coeficiente e Wald HC1 de um bloco, com p-valor de wild bootstrap sob a nula restrita e semente por célula. Arquivo inteiro, arquivado em 2026-09-18 | Só `fomc_coincidence.R` e `jk_sovereign_confound.R` o chamavam, ambos arquivados |

## `arquivo/R/identification/` — módulos

Os três módulos de heterocedasticidade foram removidos em 2026-09-01. Nenhum
caminho ativo fazia `source()` deles. O núcleo DFM permanece com o ramo único
`identification = "proxy"`.

| módulo | conteúdo | por que saiu |
|---|---|---|
| `validation_tests.R` | As 12 funções da suíte de validação do instrumento (`first_stage_F`, `residualize_target`, `placebo_test`, `random_mask_test`, `subperiod_F`, `anti_jk_test`, `random_mask_curve`, `qlr_supF`, …). Arquivo inteiro, arquivado em 2026-09-17 | Nenhuma função era chamada. `irf_coherence_check.R` e `irf_spec_stage2.R` faziam `source()` dele sem usar nada. `notas/2026-07-11_varredura_irf.md` e `historico_decisoes.md` §4 citam `first_stage_F` e `residualize_target` |
| `spec_sweep.R` | `theory_sign_table`, `summarize_irf_responses`, `evaluate_sweep_cell`, `classify_sweep_cells` e `rq_surface_table`, retiradas de `R/identification/spec_sweep.R` em 2026-09-17 | Só `irf_spec_sweep.R` e os `panel_composition_rq_grid*` as chamavam. O resto de `spec_sweep.R` (`run_stage2_cell`, `containment_vs_production`, `md_table`, …) segue vivo |
| `experimental_panel.R` | `build_variant_panel`, `experimental_variant_manifest`, `build_experimental_panels` e `classify_mosw`, retiradas de `R/identification/experimental_panel.R` em 2026-09-17 | Só a família `panel_composition*` as chamava. A metade fatorial do arquivo vivo segue em uso por `diagnostics/rq_*_audit` |

## `arquivo/relatorio/` — notas e correspondência

| item | o que é |
|---|---|
| `2026-04-25_blindspot_het_instrument.md` | Ruling condicional sobre `z_het_jk`; chegou a propor reposicionar o paper em torno de identificação por variância |
| `2026-04-26_blindspot_validation.md` | Auditoria da suíte T1-T4; apontou que a F do JK fica *no* percentil 99 das máscaras aleatórias, não acima |
| `council_2026-05-05.md` | Painel de três críticos sobre o corpus `registro/` da época (*Major Revision*). Todo o veredito é sobre `z_het_jk`: falha de A2 em DI_2y, rank-1 imposto por asserção, e o F=21,3 medido contra a inovação AR(6) e não contra o primeiro estágio estrutural. As três exigências foram superadas pelos eventos — a het saiu do paper e a régua virou ξ_mp |
| `correspondence/referee2/` | Dois rounds de referee interno sobre o bloco het (round 1 *Minor Revisions*, round 2 *Accept*) + `replication/`, a réplica NumPy que batia em 6+ casas decimais |

O único achado **não-het** desse material já foi extraído para
`historico_decisoes.md` §4: janelas não-contíguas exigem residualização AR
full-sample **antes** do subset, senão outubro/2020 é regredido em
fevereiro/2020 sem que nada acuse o erro.

*Nota:* `correspondence/referee2/replication/referee2_replicate_het_shock.py`
tem um caminho quebrado desde que foi movido (`parents[2]` aponta para um
diretório inexistente). Não foi corrigido — o script não roda mais de qualquer
forma, já que os CSVs het de entrada foram apagados.

## `arquivo/output/`

| item | o que é |
|---|---|
| `irf_section_2026-07-12.md` | Versão anterior do §5, sob `z_jk_purif` × (6,5) e vintage antigo. É o único registro escrito daquela rodada. **Várias afirmações foram invertidas** pela rodada (7,6) — comparação em `historico_decisoes.md` §6 |
| `instrument_audit_report.md`, `instrument_audit_grid.csv` | Saídas históricas da auditoria de 2026-04-26, anteriores ao fix de unit scaling |
| `instrument_grid_report.md`, `instrument_grid.csv` | Saídas de `instrument_grid.R` (2026-04-26), só variantes legadas |
| `factor_space_F_grid.csv` | Saída de `diagnose_factor_space_F.R`, arquivada junto com ele em 2026-08-05. 8 variantes × q ∈ {2,3,4,6}, sendo 4 delas `z_het*` — régua legada, e metade do grid mede instrumentos que já não existem |

---

## `arquivo/tex/` — o paper (abntex2, arquivado 2026-08-02)

O draft abntex2 (`main.tex`, "Choques monetários nos preços dos ativos") que
foi o paper canônico até 2026-08-02, quando o autor decidiu que o rascunho
ANPEC (`paper/paper_anpec.tex`, classe `elsarticle`) passa a ser o
documento corrente. **Não superado por vintage ou por bug** — o conteúdo era
o corrente: §3 (Metodologia) em (7,6) e §4/§5 (Resultados/Robustez)
reescritas em 2026-07-30 sob a regra de leitura em duas camadas (90% =
*significativo*, 68% = direção e magnitude). Preservado porque **`§5
Robustez` não tem contrapartida ainda em `paper/`** — é a fonte de
prosa a reaproveitar até essa seção ser escrita no rascunho corrente, não um
alvo de edição ativo. `img/` guarda as 8 figuras citadas pelo texto, agora
como **registro histórico congelado**: em 2026-08-05 `script/fig_section5.R`
foi repontado para `paper/`, de modo que **nenhum código vivo escreve
mais dentro de `arquivo/`** — a invariante que o resto deste README já exigia
para `source()` agora vale também para escrita. Ver a entrada `arquivo/tex/`
em `CLAUDE.md` para o que cada seção chegou a cobrir.

## O que foi apagado (recuperável pelo git)

Não está aqui porque é **regenerável** pelos scripts acima ou porque não
reproduz mais no painel atual. Tudo estava versionado; use
`git log --diff-filter=D -- <caminho>` para achar o commit e `git show` para
recuperar.

- `output/validation/` (18 arquivos, suíte T1-T8 het)
- `output/het_primary/` (7 arquivos, gates de viabilidade)
- `output/instrument/het_*` (24 CSVs + `het_eigenvalues.png`)
- `output/benchmark/grg_benchmark.csv` (construído de bundles het)
- `output/irf/` do vintage antigo: bundles de 2026-05-08, `inst_diag_*`,
  `inst_report_*`, `irf_sample_diag_*`, `irf_rq_*`, `irf_spec_*` de julho/11 e
  julho/15, `irf_model_alessi_r6q5.pdf` — ~12 MB que não reproduzem contra as
  106 séries.
- Em 2026-09-01, os nove arquivos sob
  `arquivo/heterocedasticidade/{R/identification,script}/` e os três órfãos
  `arquivo/script/{instrument_audit,irf_cross_instrument,build_grg_benchmark}.R`.
  Todos eram exclusivos da rota `z_het*` ou dependiam de bundles dessa rota já
  apagados; nenhum tinha consumidor no pipeline ativo.

- Em 2026-09-18, o wild bootstrap do DFM e a correção de Kilian: o laço de
  réplicas de `compute_irf_dfm()` e `validate_bootstrap_results()`
  (`R/modeling/impulse_response.R`), `kilian_correction()`,
  `estimate_corrected_var()` e `solve_or_pseudo()`
  (`R/modeling/factor_estimation.R`), os argumentos `nboot`, `bootstrap_seed` e
  `apply_kilian`, os campos `*_corrected` e `var_residuals_original` de
  `estimate_dfm()`, os campos `nboot` e `bootstrap_seed` de `production_spec()`
  e o modo `--bootstrap` de `script/validation/validate_production_spec.R`. A
  última versão com tudo isso é `main` em `07b1cbd`. As saídas daquele modo,
  `output/validation/production_spec_{bootstrap_gate,headline_irf}.csv`, ficam
  onde estão.

- `paper/img/` (6 PDFs, 2026-08-05): duplicata byte-idêntica das figuras
  na raiz de `paper/`. O `paper_anpec.fls` mostra que o compile sempre
  leu da raiz; só linhas `\includegraphics` comentadas apontavam para `img/`.
  Regenerável por `script/fig_section5.R` ⇒ apagada, não arquivada.

Os arquivos `data/processed/instrument_z_het*.csv` (6) tinham sido **mantidos**
em 2026-07-26 sob o argumento de que `data/` é gitignored e regenerá-los
exigiria rodar um script arquivado. **Foram apagados em 2026-08-05**: eram os
últimos vestígios vivos das variantes `z_het`, e o argumento de conveniência não
supera o de higiene — o registro do que eram e por que morreram está em
`historico_decisoes.md` §1.1, que é onde ele tem de estar. Na mesma passagem
saíram `instrument_jk_raw_purif_local.csv` e `instrument_jk_purif_us.csv`, órfãos
depois do corte de 10 → 8 variantes. As colunas `z_het*` já não existiam em
`instrumentos_mensais.csv`.
