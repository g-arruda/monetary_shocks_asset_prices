# `script/` — o que cada arquivo faz

40 scripts, organizados por tema (não por subpasta — ver a decisão em
`registro/pendencias.md` sobre manter isto flat: mover para subpastas
quebraria dezenas de referências de caminho no `CLAUDE.md`, no `run_all.R` e
em notas). Cinco scripts que faziam parte de uma investigação já
superada (contaminação de IRF, 2026-07-15/16) foram arquivados em
`arquivo/script/` em 2026-08-01, e `diagnose_factor_space_F.R` em 2026-08-05
— ver `arquivo/README.md` se precisar deles. `fomc_coincidence.R` entrou em
2026-08-10.

**2026-08-17 — saíram seis scripts, com as duas rotas de identificação que
foram abandonadas:** `het_robustness.R` saiu do diretório ativo e seu código
foi removido do repositório em 2026-09-01, depois da preservação dos artefatos
em `arquivo/heterocedasticidade/`; `model_nongaussian.R`,
`nongaussian_{gate,corroboration,labelling}.R` e `validate_gmr_ica.R` para
`arquivo/nao_gaussiana/script/`. Cada pasta tem README com o veredito.

**2026-08-31 — downloads centralizados:** `download.R` tornou-se o único
entry point de rede. Saíram `fomc_dates.R`, `validate_candidate_downloads.R`
e `download_di.py`; o DI diário passou a ser declarado somente como entrada
externa fixa. Os módulos de fonte ficaram em `R/data_download/`, sem execução
automática nem gravação ao serem carregados.

Todo script aqui é carga viva de uma de duas coisas: reproduzir
`paper/paper_anpec.tex` ou sustentar um item da tier list de robustez
(`notas/2026-08-01_tier_list_robustez.md`). A triagem de
2026-08-05 conferiu isso arquivo a arquivo.

Ordem de leitura recomendada para quem chega agora: `run_all.R` primeiro (é
o orquestrador), depois os 4 do grupo 1 na ordem em que aparecem.

## 1. Pipeline core (orquestrado por `run_all.R`)

| script | o que faz |
|---|---|
| `run_all.R` | Orquestrador fim-a-fim: roda 4 estágios nomeados (`download`, `clean`, `instrument`, `model`), cada um como subprocesso `Rscript` via `system2`, com `--list/--dry-run/--from/--to/--only/--skip/--skip-existing/--continue-on-error`. Faz checagem de pré-condição (`requires`/`produces`) por estágio. O estágio `model` só chama `model_alessi.R` — não roda `model_var.R` nem scripts de diagnóstico/sweep. |
| `download.R` | Único ponto de entrada de downloads. Coleta SGS, Focus/Olinda, FRED, Yahoo, B3, calendário FOMC, IPEA e SIDRA; valida os insumos externos fixos usados; grava os seis artefatos diários em `data/raw/` e monta `raw_data.csv` com 113 séries completas na amostra 2012-03–2025-12, incluindo diretamente os três indicadores fiscais e as quatro expectativas Focus da produção. `di.csv`, curva e CDS Bloomberg continuam externos e nunca são sobrescritos. |
| `clean.R` | Filtra 2012-03–2025-12, aplica log e a cascata X-13 às 113 séries raw, constrói e audita o ajuste cambial da DLSP e as três expectativas fiscais Focus, grava a base histórica de 106 e monta o painel de produção de 115 removendo `juros_cdi` e `asset_mlcx`. Escreve o manifesto integral em `output/panel/production_series_manifest.csv`. |
| `instrument.R` | Constrói desde 2012-03 as 8 variantes mensais de instrumento (família GK/JK/BS), carregando antecedentes diários desde 2011-09, via `R/instrument/{di_surprise,build_variants}.R` (`TARGET_BD=126`, soma JK, variante padrão `z_jk_bs_purif`). Escreve `data/processed/instrumentos_mensais.csv`, os CSVs por variante e o legado `data/processed/instrument.csv`. |
| `model_alessi.R` | Script de produção do DFM principal. Consome `production_spec()`, grava a superfície Bai--Ng BLL completa e estima `(r=5, q=5, p=4, choque=+50bp em yield_6m)` com a inferência de produção — conjuntos Anderson--Rubin desde 2026-09-08, nenhuma réplica sorteada. Escreve `output/irf/irf_model_alessi_r5q5.pdf`. |

## 2. Estimação / benchmarks (não entram no `run_all.R`)

| script | o que faz |
|---|---|
| `model_var.R` | Único driver do VAR pequeno observável. Seus artefatos ficam congelados na vintage 2013-01--2025-09 e o script exige `--reestimate-current-instrument` para impedir que a proxy BS recalculada altere silenciosamente o benchmark. Quando autorizado, estima as cinco séries em nível com constante e tendência linear, `p=2`, respostas `C_h B_1` e conjuntos AR 68%/90% com NW(0). |
| `var_lag_comparison.R` | Relatório histórico, desacoplado de `SPEC$p`: compara VAR(2) e VAR(6) na vintage de 147 resíduos que motivou o diagnóstico de ordem. Mantém sua nota e seus artefatos como evidência datada; não representa a produção DFM corrente nem altera o benchmark VAR observável. |

## 3. Diagnóstico de força do instrumento

| script | o que faz |
|---|---|
| `instrument_diagnostics.R` | Compara as variantes no DFM de produção compartilhado, reportando ξ_mp e o primeiro estágio robusto F_rob,mp na direção de `yield_6m`, além da dispersão Copom-dia e do teste de variância Copom vs. não-Copom. Escreve `output/instrument/instrument_diagnostics_report.md` + um PNG. |
| `mosw_strength_grid.R` | Atualização incremental da grade de ξ_mp e F_rob,mp: reestima as 25 células admissíveis `(r,q)`, com `r=4,...,8`, `q=2,...,r`, `p=4`, amostra cheia e `z_jk_bs_purif`, e preserva no CSV as linhas históricas fora desse recorte. As estatísticas usam a direção de normalização de `yield_6m`; não há bootstrap. Escreve `output/instrument/mosw_strength_grid.{csv,md}`. |
| `xi_mp_robustness.R` | Robustez leave-one-month-out + NW(0..6) de ξ_mp com o DFM fixo (só o momento Γ é recomputado). Escreve `output/instrument/xi_mp_robustness.{csv,md}`. |
| `instrument_construction_sweep.R` | Varre as 2 escolhas de construção não documentadas — vértice de DI (13 valores) × esquema de agregação {soma, GK} × 5 variantes × 2 janelas — pontuado por ξ_mp na especificação de produção. Escreve `output/instrument/instrument_construction_sweep.{csv,md}` + `vertex_irf_overlay.pdf`. |
| `jk_sovereign_confound.R` | Testa se o filtro de sinal JK seleciona surpresas de risco soberano em vez de choques monetários: reconstrói o painel diário de quintas-feiras, junta proxies de **CDS 5a** (`data/raw/CDS 5y.xlsx`, Bloomberg) / EMBI+ / BRL / curva DI, roda 2 testes nas duas proxies de risco. **A** é a regressão diária por conjunto de dias mais a interação `x:1(jk_bs)`, que é a estatística que decide; **C** ortogonaliza a surpresa ao risco contemporâneo em três degraus, o último re-derivando também a **máscara** nos resíduos das duas pernas (`z_jk_bs_norisk_mask`, 2026-08-10). O veredito do EMBI é o pré-registrado e vem primeiro; o do CDS usa a **mesma** `verdict_for()`. Os testes B (três vias) e D (tabela datada) foram removidos em 2026-08-10 — ver `registro/historico_decisoes.md` §2.4. Cinco auto-testes: `copom_event_diagnostics.csv`, concordância com `mosw_strength_grid.csv`, smoke test de IRF h0, CDS diário × `cds_5y` mensal do painel e finitude da força de `z_jk_bs_norisk`. Escreve `output/instrument/jk_sovereign_confound.{csv,md}` e `jk_sovereign_irf_overlay.pdf`. |
| `fomc_coincidence.R` | Testa a ameaça irmã da anterior: o filtro seleciona **spillover do FOMC** em vez de choque do Copom? Exige `data/raw/fomc_dates.csv` (`script/download.R`), sem o qual a flag `fomc_coincide` era sempre FALSE. Quatro seções: timing (a notícia do Fed cai antes ou dentro da janela Qua→Qui?), contabilidade da exposição, regressão de `e_di_bs` no bloco americano contemporâneo sobre 6 conjuntos de dias + 2 interações, e máscara **re-derivada** nos resíduos duplos, que separa o canal de valores do de seleção — com IRFs de bootstrap completo nas 2 variantes que o veredito lê. Regra de leitura fixada no cabeçalho antes dos números; a divisão em metades com/sem FOMC e a terceira perna da regra que ela alimentava saíram em 2026-08-10, com o registro do corte no cabeçalho. Quatro auto-testes, entre eles `copom_event_diagnostics.csv` e a concordância da força com `mosw_strength_grid.csv`. Escreve `output/instrument/fomc_coincidence.{csv,md}`, `fomc_coincidence_days.csv`, `fomc_coincidence_irf_overlay.pdf`. |

## 4. Sweep de especificação IRF / coerência

| script | o que faz |
|---|---|
| `irf_spec_sweep.R` | Etapa 1: sweep só de ponto (rápido) sobre instrumento × mp_var × (r,q) × janela amostral, com um `estimate_dfm` em cache por (amostra,r,q); classifica cada célula por `failure_class` no ξ_mp. Escreve `output/irf/spec_sweep_{cells,irf_long}.csv`, `spec_sweep_report.md`. |
| `irf_spec_stage2.R` | Etapa 2: bootstrap completo (nboot=800) nas células vencedoras da etapa 1, com a especificação de produção sempre incluída (force-append). Escreve `output/irf/irf_spec_<tag>.{rds,pdf}`, `irf_spec_stage2_overlay.pdf`, `spec_sweep_stage2.md`. |
| `q_selection.R` | Varredura de `q` com gate de 800 réplicas, ξ_mp, denominador de normalização, raiz máxima e trajetórias `h=0..48`. Seus artefatos correntes ainda pertencem à vintage anterior e não foram regenerados na ampliação de 2026-09-02. |
| `p_selection.R` | Compara `p=4` com 6, 3 e 2 sob a especificação carregada. Na nova vintage, `p=4` é herdado e os critérios são reportados separadamente pelo gate; os artefatos completos desta varredura ainda pertencem à vintage anterior. |
| `irf_coherence_check.R` | Roda a especificação de produção uma vez e pontua 58 variáveis do painel ponto-a-ponto em cada horizonte contra janelas de teoria (`R/identification/irf_coherence.R`). É o script que alimenta a §5 do paper. Bandas: os conjuntos Anderson--Rubin de `production_spec()$inference`; significância é "o conjunto exclui zero", lida pela topologia. Escreve `output/irf/irf_coherence_{h,summary}.csv`, `irf_coherence_report.md` (reescrito por inteiro a cada rodada — nunca editar à mão), `irf_coherence_plots.pdf`, e o cache `irf_coherence_cell.rds` (lido por muitos scripts a jusante). |
| `ar_bands.R` | A rodada que documenta a troca de inferência de 2026-09-08. Constrói os conjuntos Anderson--Rubin do DFM por inversão de teste em `(r=5,q=5,p=4)` e em `(r=5,q=2,p=4)`, a 68/90/95%, e roda o wild bootstrap na célula de produção para a comparação lado a lado. Sonda e reporta as células que o gate `hac_dim < T` barra — `(8,8)` e a janela pré-COVID. Escreve `output/irf/ar_bands.{csv,md}`, `ar_bands_summary.csv` e `ar_bands_overlay.pdf`. |
| `price_cross_instrument.R` | Compara o **bloco de preços inteiro** pela escada `z_bruto` → `z_bs_purif` → `z_jk_bs_purif` sob `(5,5,4)` nas duas janelas, com ponto e uma célula pré-COVID de 800 réplicas. Confere a produção contra coerência, força e normalização; um sweep de outra ordem é tratado como vintage histórica, não como alvo de não-regressão. Escreve `output/irf/price_cross_instrument.{csv,md}`, bandas/cache pré-COVID e PDF. |
| `fig_section5.R` | Pós-processamento puro: lê o `irf_coherence_cell.rds` canônico e as tabelas da Tarefa 7, sem reestimar nada. Escreve as 10 figuras `paper/fig_*.pdf` até h=36; as figuras fiscais e de expectativas usam exclusivamente o cache de produção de 115 séries. **Congelado desde 2026-09-08**: aborta sem `--repaint-paper-figures`, porque o cache passou a carregar conjuntos AR e as legendas do paper ainda dizem *wild bootstrap*. |
| `fig_weak_iv.R` | Pós-processamento puro do CSV canônico da inferência robusta no VAR. Escreve somente `paper/fig_weak_iv_main.pdf`, com ponto, zero e conjunto AR de 95% nas cinco respostas da produção até `h=36`, em grade 3×2. IBC-Br e câmbio entram em porcentagem da média amostral, yield e CDS em pontos-base e IPCA em pontos percentuais. Exige 185 pares variável-horizonte. **Congelado desde 2026-09-08**: aborta sem `--repaint-paper-figures`, porque o contraste bootstrap-vs-AR que a legenda anuncia deixou de existir quando o DFM migrou para AR. |

## 5. Robustez estrutural do DFM (respostas ao council review de 2026-07-31)

| script | o que faz |
|---|---|
| `factor_stationarity.R` | Testa se os fatores estáticos de produção são I(1)/cointegrados e se a reversão de médio prazo vem do par de autovalores complexos dominante. ADF/PP/Johansen + reconstrução espectral por deleção de modos. Escreve `output/factors/factor_{companion_spectrum,unit_root,cointegration,lag_sensitivity_irf,irf_mode_decomposition}.csv` + `factor_stationarity.md`. |
| `factor_selection_alt.R` | Estimadores alternativos do número de fatores estáticos na mesma base BLL da superfície Bai--Ng de produção (`k=1..20`): ER/GR de Ahn-Horenstein (2013) e o critério de Alessi-Barigozzi-Capasso (2010), reimplementados dos papers em `R/modeling/factor_selection.R`. Roda o pacote `factorselect` @ `f0f08d5` apenas como comparador auditado, porque o GR e o ABC do pacote divergem dos papers. Seis auto-testes ligam o objeto à superfície de produção. Escreve `output/factors/factor_selection_alt.{csv,md,pdf}`, `factor_selection_alt_abc.csv` e `factor_selection_alt_summary.csv`. |
| `asset_representation.R` | Testa se o resultado nulo do bloco de 8 índices de ações é mecânico — os índices B3 entram como retorno mensal (tcode 2) enquanto o resto do painel entra em nível. Constrói 4 variantes de painel em memória (`prod`, `prod_nocum`, `loglevel`, `level`); nada em produção é modificado. Escreve `output/assets/*.csv`, `asset_representation.md`, `asset_irf_overlay.pdf`. |
| `fiscal_expectations.R` | Experimento isolado que acrescenta três expectativas fiscais Focus anuais (DLSP, resultado primário e nominal para o ano seguinte) ao painel de 111 séries, formando um painel de 114. Reproduz a baseline, compara seleção, força e a grade `(r,q)`, e com `--bootstrap` roda 800 réplicas apenas no painel aumentado. Escreve somente em `output/fiscal_expectations/`; não altera a produção nem o paper. |
| `fiscal_dlsp_decomposition.R` | Experimento isolado para os fluxos mensais da DLSP em `data/raw/DLSP/Evodlp.xlsx`. Audita a identidade contábil e a equivalência do primário com SGS 4649 antes de formar o painel de 118 séries. Interrompe sem estimar quando a identidade de sete fluxos não fecha; a fonte corrente exige a linha externa “outros ajustes” para reconciliar a DLSP. Escreve somente em `output/fiscal_dlsp_decomposition/`; não altera a produção nem o paper. |
| `fiscal_exchange_expectations.R` | Driver linear do experimento conjunto de 115 séries. Extrai somente a linha publicada “Ajuste cambial”, exclui “outros ajustes”, reaproveita as três expectativas Focus auditadas e reestima os painéis 111/112/114/115 nas amostras cheia e pré-COVID. Grava superfícies Bai--Ng BLL/Amengual--Watson, força, estabilidade e pontos dos quatro painéis; roda 800 réplicas somente no painel 115 e escreve em `output/fiscal_exchange_expectations/`. Não altera a produção; suas IRFs finais alimentam o complemento experimental das figuras fiscais e de expectativas. |
| `panel_composition.R` | Mede a composição do painel de produção de 111 séries em cinco etapas, sem bootstrap: censo e dimensão efetiva por bloco, atribuição dos fatores e do choque, leave-one-block/domain-out, leave-one-series-out e painéis balanceados. Escreve `output/panel/panel_composition.md` + os cinco CSVs associados. |
| `panel_composition_experimental.R` | Reproduz a rodada histórica de composição em nove variantes, combinando a base de 106 séries com 19 entradas experimentais, em duas janelas e sob `(7,6,6)`. Mantém tudo isolado de produção e escreve somente em `output/panel_experimental/`, incluindo pontos, bandas, composição e tratamentos. |
| `panel_composition_rq_grid.R` | Varre os nove painéis experimentais em duas janelas e nos 18 pares admissíveis de `(r,q)`, com `p=6`; produz 324 células de ponto, tabelas de ξ_mp, manifesto e relatório em `output/panel_experimental/rq_grid/`. |
| `panel_composition_rq_grid_drop_blocks.R` | Grade fatorial isolada de composição: remove `juros_cdi` e `asset_mlcx` de todos os painéis e varre as 64 combinações de remoção dos seis blocos experimentais, nas duas janelas e nos 18 pares `(r,q)` admissíveis (`p=6`, `z_jk_bs_purif`, direção `yield_6m`). Estima somente DFM de ponto e ξ_mp; escreve 2.304 células, manifesto, falhas e 128 superfícies em `output/panel_experimental/rq_grid_drop_blocks/`. `validate_panel_composition_rq_grid_drop_blocks.R` exige cobertura, finitude, exclusão das duplicatas, N por variante e reproduções independentes. |
| `panel_composition_factor_selection_drop_blocks.R` | Aplica os critérios BLL de Bai--Ng (`r=1,...,20`) e Amengual--Watson (IC2, `p=6`, `q≤r_IC2`) aos mesmos 64 painéis fatoriais e duas janelas, sem estimação de ξ_mp ou IRFs. Escreve as seleções, superfícies dos critérios e relatório em `output/panel_experimental/rq_grid_drop_blocks/factor_selection/`. |

## 6. Validações de fidelidade contra código de referência

| script | o que faz |
|---|---|
| `validate_hac_kernel.R` | Valida a opção Newey-West de `compute_factor_space_wald` de duas formas: (A) transcrição literal de `NW_hac_STATA.m` vs. o kernel embutido nos lags 0-8 em dado sintético; (B) fim-a-fim contra o fixture oficial `TaxSVARIV.m` (NWlags=8). Só console, com `stopifnot`; degrada com "SKIPPED" se o fixture faltar. |
| `validate_mosw_ar.R` | Valida o caminho inteiro do VAR observável. Contra `olea_oil_fixture.rds`, reproduz `AL`, `eta`, `Sigma`, `Gamma`, `WHat`, MA, pontos SVAR-IV e conjuntos AR de 68%/95%. Em separado, exige os dez casos degenerados do oráculo; compara AIC/BIC da célula brasileira com uma implementação independente e `vars::VARselect(type="both")` (AIC `p=2`, BIC `p=1`); e checa que a generalização `Load`/`Inner`, por onde passa o DFM, colapsa **exatamente** no MOSW original quando as duas são a identidade. Falha se qualquer fixture ou dado exigido faltar. |
| `validate_olea_kilian.R` | Reproduz os números publicados de Montiel Olea-Stock-Watson (2021) no caso Kilian-oil (ξ₁=4.4, F robusto=9.4) a partir do fixture `output/validation/olea_oil_fixture.rds`. Confere de quebra que o VAR reestimado aqui bate com o `RForm` dos autores. Apontava para `codigo_olea/Data/Oil/` e estava **quebrado** desde a migração do código de referência para `codigos_externos/` (repontado em 2026-08-10). Só console, com `stopifnot`. |
| `validate_amengual_watson.R` | Valida a tradução de `amengual_watson()` contra `amengual_watson.m`, `factor_estimation_ls.m` e `bai_ng.m` de Stock-Watson, transcritos literalmente (não há MATLAB/Octave aqui — a transcrição *é* o instrumento), contra a fixture commitada `output/validation/amengual_watson_fixture.csv`. Mede em separado o que `apply_bll = TRUE` faz: é o espaço fatorial da produção diferenciado, não uma variante rival. Escreve `output/validation/amengual_watson_validation.md` e falha alto se `q_hat` divergir ou se o gap deixar de ser a constante `log(n/(n-1))`. |
| `validate_production_spec.R` | Valida composição 115/base 106, 166 datas, manifesto SGS 20784/20785, contrato do instrumento, superfície Bai--Ng BLL, critérios de defasagem reportados, força e raízes full/pré-COVID e os cinco impactos obrigatórios. Com `--bootstrap`, reestima o gate canônico de 800 réplicas e exige zero falhas, bandas finitas/ordenadas e normalização exata. |
| `validate_panel_composition_experimental.R` | Confere as 19 entradas experimentais, reproduz ξ_mp/F robusto nas duas janelas e executa o smoke test de impacto 5/5, sem alterar a produção. |
| `validate_panel_composition_rq_grid.R` | Exige as 324 células completas e finitas da grade experimental, as 18 tabelas por variante/amostra e a reprodução das células de referência. |
| `validate_panel_composition_rq_grid_drop_blocks.R` | Exige 2.304 células, 64 painéis sem as duplicatas, contagens coerentes por variante e reprodução exata da grade anterior. |

## Notas cruzadas

- **`rm(list=ls())`**: a maioria dos entry points limpa o ambiente; os scripts que não o fazem são pensados para rodar em processo `Rscript` próprio, não para ser `source()`ados numa sessão existente.
- Nenhum script deste diretório é chamado por outro script deste diretório, exceto através de `run_all.R` (estágios) ou de `source()` de módulos em `R/`.
