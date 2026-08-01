# `script/` — o que cada arquivo faz

25 scripts, organizados por tema (não por subpasta — ver a decisão em
`_instrucoes/pendencias.md` sobre manter isto flat: mover para subpastas
quebraria dezenas de referências de caminho no `CLAUDE.md`, no `run_all.R` e
em working-notes). Cinco scripts que faziam parte de uma investigação já
superada (contaminação de IRF, 2026-07-15/16) foram arquivados em
`arquivo/script/` em 2026-08-01 — ver `arquivo/README.md` se precisar deles.

Ordem de leitura recomendada para quem chega agora: `run_all.R` primeiro (é
o orquestrador), depois os 5 do grupo 1 na ordem em que aparecem.

## 1. Pipeline core (orquestrado por `run_all.R`)

| script | o que faz |
|---|---|
| `run_all.R` | Orquestrador fim-a-fim: roda 8 estágios nomeados (`di`, `external_factors`, `focus_fred`, `ibov`, `download`, `clean`, `instrument`, `model`), cada um como subprocesso `Rscript` via `system2`, com `--list/--dry-run/--from/--to/--only/--skip/--skip-existing/--continue-on-error`. Faz checagem de pré-condição (`requires`/`produces`) por estágio. O estágio `model` só chama `model_alessi.R` — não roda `model_var.R` nem scripts de diagnóstico/sweep. |
| `download.R` | Puxa séries do BCB (juros, crédito, consumo, atividade, indústria, emprego, inflação, commodities), câmbio, breakeven (ANBIMA via `rb3`), os 8 índices B3 (retorno mensal composto), risco (EMBI/CDS/MSCI/SP500-VIX de CSVs do investing.com), EPU, e lê a curva de juros fornecida pelo orientador (`data/yields/yields_dia.csv`, sem etapa de ajuste). Escreve `data/raw_data.csv`. |
| `clean.R` | Filtra o painel para 2013-01–2025-09, descarta colunas 100% NA, aplica log nas variáveis nominais, e ajuste sazonal X-13 (3 níveis de fallback) via `R/preprocessing/seasonality.R`. Escreve `data/processed/data_log_deseasonalized.csv`. |
| `instrument.R` | Constrói as 10 variantes mensais de instrumento (família GK/JK/BS) a partir das surpresas de DI em dia de Copom, via `R/instrument/{di_surprise,build_variants}.R` (`TARGET_BD=126`, variante padrão `z_jk_bs_purif`). Escreve `data/processed/instrumentos_mensais.csv`, os 10 CSVs por variante, e o legado `data/processed/instrument.csv`. |
| `model_alessi.R` | Script de produção do DFM principal. Define `main_sdfm()` (`estimate_dfm` → `compute_irf_dfm`) e chama na especificação de produção `(r=7, q=6, p=6, choque=+50bp em yield_6m, nboot=800)`. Escreve `output/irf/irf_model_alessi_r7q6.pdf`. |

## 2. Estimação / benchmarks (não entram no `run_all.R`)

| script | o que faz |
|---|---|
| `model_var.R` | Tradução do `codigo_alessi-mark/MAIN_VARloop.m`: o benchmark de VAR pequeno de 4 variáveis (18 VARs), testando se o DFM é "mais forte/mais rápido" que um VAR pequeno. É o único script de `script/` com guarda `sys.nframe() == 0` própria (`run_benchmark()`), então pode ser `source()`ado com segurança. Lê o lado DFM do cache `output/irf/irf_coherence_cell.rds`. Escreve `output/var/var_benchmark_*.csv`, `var_benchmark.md`, 4 PDFs. |
| `model_nongaussian.R` | Rodada de produção da identificação não-gaussiana GMR (2017, PML-ICA) vs. proxy-SVAR, no mesmo DFM. 4 blocos: ponto+bootstrap para as duas identificações; testes de restrição do proxy/esquema recursivo; robustez a má-especificação de densidade; comparação de IRF em 8 variáveis-headline. Guarda o objeto de estimação em `output/nongaussian/gmr_cell.rds`. Escreve `output/nongaussian/{results.md, irf_comparison.{csv,pdf}}`. |

## 3. Diagnóstico de força do instrumento

| script | o que faz |
|---|---|
| `instrument_diagnostics.R` | Compara as variantes de instrumento em **um único resíduo de DFM** compartilhado (r=8,q=8,p=6): F parcial vs. resíduo do DFM, F vs. inovação AR(6) de `yield_6m`, bloco Wald MOSW por variante, dispersão Copom-dia, e teste F de variância Copom vs. não-Copom. Escreve `output/instrument/instrument_diagnostics_report.md` + um PNG. |
| `mosw_strength_grid.R` | Grid do bloco Wald MOSW (ξ_mp, Wald conjunto, ξ_k por fator, max-F legado) sobre `(r,q) ∈ {5..8}×{4..r}` × 2 janelas amostrais × 10 variantes de instrumento — a régua de força de referência do projeto. Escreve `output/instrument/mosw_strength_grid.{csv,md}`. |
| `xi_mp_robustness.R` | Robustez leave-one-month-out + NW(0..6) de ξ_mp com o DFM fixo (só o momento Γ é recomputado). Escreve `output/instrument/xi_mp_robustness.{csv,md}`. |
| `instrument_construction_sweep.R` | Varre as 2 escolhas de construção não documentadas — vértice de DI (13 valores) × esquema de agregação {soma, GK} × 5 variantes × 2 janelas — pontuado por ξ_mp na especificação de produção (7,6). Escreve `output/instrument/instrument_construction_sweep.{csv,md}` + `vertex_irf_overlay.pdf`. |
| `diagnose_factor_space_F.R` | Diagnóstico de grid legado: max-F univariado através de q inovações de fator, `r=7,p=6` fixos, `q∈{2,3,4,6}` × 8 variantes de instrumento. Superado como régua decisória pelo ξ_mp de `mosw_strength_grid.R`, mas mantido executável. Escreve `output/instrument/factor_space_F_grid.csv`. |
| `jk_sovereign_confound.R` | Testa se o filtro de sinal JK seleciona surpresas de risco soberano em vez de choques monetários: reconstrói o painel diário de quintas-feiras, junta proxies de EMBI+/BRL/curva DI, roda 4 testes. Auto-testes contra `copom_event_diagnostics.csv`, `mosw_strength_grid.csv`, e um smoke test de IRF h0. Escreve `output/instrument/jk_sovereign_confound.{csv,md}`, `jk_sovereign_days.csv`, `jk_sovereign_irf_overlay.pdf`. |

## 4. Sweep de especificação IRF / coerência

| script | o que faz |
|---|---|
| `irf_spec_sweep.R` | Etapa 1: sweep só de ponto (rápido) sobre instrumento × mp_var × (r,q) × janela amostral, com um `estimate_dfm` em cache por (amostra,r,q); classifica cada célula por `failure_class` no ξ_mp. Escreve `output/irf/spec_sweep_{cells,irf_long}.csv`, `spec_sweep_report.md`. |
| `irf_spec_stage2.R` | Etapa 2: bootstrap completo (nboot=800) nas células vencedoras da etapa 1, com a especificação de produção sempre incluída (force-append). Escreve `output/irf/irf_spec_<tag>.{rds,pdf}`, `irf_spec_stage2_overlay.pdf`, `spec_sweep_stage2.md`. |
| `irf_coherence_check.R` | Roda a especificação de produção uma vez e pontua 53 variáveis do painel ponto-a-ponto em cada horizonte contra janelas de teoria (`R/identification/irf_coherence.R`). É o script que alimenta a §5 do paper. Escreve `output/irf/irf_coherence_{h,summary}.csv`, `irf_coherence_report.md` (reescrito por inteiro a cada rodada — nunca editar à mão), `irf_coherence_plots.pdf`, e o cache `irf_coherence_cell.rds` (lido por muitos scripts a jusante). |
| `fig_section5.R` | Pós-processamento puro: lê o `irf_coherence_cell.rds` em cache + as tabelas da Tarefa 7, não reestima nada, escreve as 8 figuras `tex/img/fig_*.pdf` do paper (todas até h=36). |

## 5. Robustez estrutural do DFM (respostas ao council review de 2026-07-31)

| script | o que faz |
|---|---|
| `factor_stationarity.R` | Testa se os 7 fatores estáticos são I(1)/cointegrados, e se a reversão de médio prazo na IRF é economia ou artefato mecânico do par de autovalores complexos dominante da companion matrix. ADF/PP/Johansen + reconstrução espectral por deleção de modos. Escreve `output/factors/factor_{companion_spectrum,unit_root,cointegration,lag_sensitivity_irf,irf_mode_decomposition}.csv` + `factor_stationarity.md`. |
| `asset_representation.R` | Testa se o resultado nulo do bloco de 8 índices de ações é mecânico — os índices B3 entram como retorno mensal (tcode 2) enquanto o resto do painel entra em nível. Constrói 4 variantes de painel em memória (`prod`, `prod_nocum`, `loglevel`, `level`); nada em produção é modificado. Escreve `output/assets/*.csv`, `asset_representation.md`, `asset_irf_overlay.pdf`. |

## 6. Identificação não-gaussiana (track GMR 2017)

| script | o que faz |
|---|---|
| `validate_gmr_ica.R` | Valida a tradução em repositório do PML-ICA de GMR (`R/identification/nongaussian_gmr.R`) contra `IdSS::estim.SVAR.ICA` e a aplicação do próprio paper original; documenta defeitos específicos do pacote `IdSS` para n≥4. Não escreve nada em disco — só console, com `stopifnot`. |
| `nongaussian_gate.R` | Testa a precondição "no máximo um gaussiano" (Comon 1994) nas q inovações de fator dinâmico do DFM de produção, nas duas janelas amostrais. Escreve `output/nongaussian/gate.md`. |
| `nongaussian_corroboration.R` | Pós-processamento sobre `gmr_cell.rds`: o GMR corrobora o proxy nas 106 séries do painel (não só nas 8 headline), condicional em significância do proxy e contra um nulo de direção aleatória. Escreve `output/nongaussian/corroboration_*.csv` + `corroboration_overlay.pdf`. |
| `nongaussian_labelling.R` | Rotula a coluna monetária do GMR sem usar o instrumento (4 regras fixadas antes de medir) e testa se a métrica de corroboração discrimina, contra um nulo de 2.000 direções aleatórias. Escreve `output/nongaussian/labelling_*.csv` + `labelling_overlay.pdf`. |

## 7. Validações de fidelidade contra código de referência

| script | o que faz |
|---|---|
| `validate_hac_kernel.R` | Valida a opção Newey-West de `compute_factor_space_wald` de duas formas: (A) transcrição literal de `NW_hac_STATA.m` vs. o kernel embutido nos lags 0-8 em dado sintético; (B) fim-a-fim contra o fixture oficial `TaxSVARIV.m` (NWlags=8). Só console, com `stopifnot`; degrada com "SKIPPED" se o fixture faltar. |
| `validate_olea_kilian.R` | Reproduz os números publicados de Montiel Olea-Stock-Watson (2021) no caso Kilian-oil (ξ₁=4.4, F robusto=9.4) a partir de `codigo_olea/Data/Oil/`. Só console, com `stopifnot`. |

## Notas cruzadas

- **`rm(list=ls())`**: presente em 20 dos 25 arquivos. Ausente em `download.R`, `instrument.R`, `instrument_diagnostics.R`, `validate_hac_kernel.R`, `validate_olea_kilian.R` — os cinco são pensados para rodar em processo `Rscript` próprio, não para ser `source()`ados numa sessão existente.
- **Guarda `sys.nframe() == 0`**: só `model_var.R` (via `run_benchmark()`).
- Nenhum script deste diretório é chamado por outro script deste diretório, exceto através de `run_all.R` (estágios) ou de `source()` de módulos em `R/`.
