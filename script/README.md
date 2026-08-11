# `script/` — o que cada arquivo faz

28 scripts, organizados por tema (não por subpasta — ver a decisão em
`_instrucoes/pendencias.md` sobre manter isto flat: mover para subpastas
quebraria dezenas de referências de caminho no `CLAUDE.md`, no `run_all.R` e
em working-notes). Cinco scripts que faziam parte de uma investigação já
superada (contaminação de IRF, 2026-07-15/16) foram arquivados em
`arquivo/script/` em 2026-08-01, e `diagnose_factor_space_F.R` em 2026-08-05
— ver `arquivo/README.md` se precisar deles. `fomc_coincidence.R` entrou em
2026-08-10.

Todo script aqui é carga viva de uma de duas coisas: reproduzir
`texto_anpec/paper_anpec.tex` ou sustentar um item da tier list de robustez
(`relatorio/working-notes/2026-08-01_tier_list_robustez.md`). A triagem de
2026-08-05 conferiu isso arquivo a arquivo.

Ordem de leitura recomendada para quem chega agora: `run_all.R` primeiro (é
o orquestrador), depois os 5 do grupo 1 na ordem em que aparecem.

## 1. Pipeline core (orquestrado por `run_all.R`)

| script | o que faz |
|---|---|
| `run_all.R` | Orquestrador fim-a-fim: roda 9 estágios nomeados (`di`, `external_factors`, `focus_fred`, `fomc`, `ibov`, `download`, `clean`, `instrument`, `model`), cada um como subprocesso `Rscript` via `system2`, com `--list/--dry-run/--from/--to/--only/--skip/--skip-existing/--continue-on-error`. Faz checagem de pré-condição (`requires`/`produces`) por estágio. O estágio `model` só chama `model_alessi.R` — não roda `model_var.R` nem scripts de diagnóstico/sweep. |
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
| `mosw_strength_grid.R` | Grid do bloco Wald MOSW (ξ_mp, Wald conjunto, ξ_k por fator, max-F legado) sobre `(r,q) ∈ {5..8}×{4..r}` × 2 janelas amostrais × 8 variantes de instrumento — a régua de força de referência do projeto. Escreve `output/instrument/mosw_strength_grid.{csv,md}`. |
| `xi_mp_robustness.R` | Robustez leave-one-month-out + NW(0..6) de ξ_mp com o DFM fixo (só o momento Γ é recomputado). Escreve `output/instrument/xi_mp_robustness.{csv,md}`. |
| `ar_bands.R` | Inverte o teste de Anderson-Rubin de Montiel Olea-Stock-Watson sobre o DFM-IV, via `R/identification/weak_iv_ar.R`: conjunto AR + limites de delta-method para as 106 séries × 49 horizontes × {68, 90, 95}% × {full, pre_covid}, comparados às bandas de bootstrap da produção. Reestima o DFM (barato, sem bootstrap) porque `irf_coherence_cell.rds` guarda a IRF, não o DFM. Seis `stopifnot` gateiam a rodada — entre eles o ponto reproduzindo `irf_coherence_h.csv` e ξ_mp reproduzindo `mosw_strength_grid.csv`. Escreve `output/irf/ar_bands.{csv,md}`, `ar_bands_summary.csv`, `ar_bands_overlay.pdf`. |
| `instrument_construction_sweep.R` | Varre as 2 escolhas de construção não documentadas — vértice de DI (13 valores) × esquema de agregação {soma, GK} × 5 variantes × 2 janelas — pontuado por ξ_mp na especificação de produção (7,6). Escreve `output/instrument/instrument_construction_sweep.{csv,md}` + `vertex_irf_overlay.pdf`. |
| `jk_sovereign_confound.R` | Testa se o filtro de sinal JK seleciona surpresas de risco soberano em vez de choques monetários: reconstrói o painel diário de quintas-feiras, junta proxies de **CDS 5a** (`data/CDS 5y.xlsx`, Bloomberg) / EMBI+ / BRL / curva DI, roda 2 testes nas duas proxies de risco. **A** é a regressão diária por conjunto de dias mais a interação `x:1(jk_bs)`, que é a estatística que decide; **C** ortogonaliza a surpresa ao risco contemporâneo em três degraus, o último re-derivando também a **máscara** nos resíduos das duas pernas (`z_jk_bs_norisk_mask`, 2026-08-10). O veredito do EMBI é o pré-registrado e vem primeiro; o do CDS usa a **mesma** `verdict_for()`. Os testes B (três vias) e D (tabela datada) foram removidos em 2026-08-10 — ver `_instrucoes/historico_decisoes.md` §2.4. Cinco auto-testes: `copom_event_diagnostics.csv`, `mosw_strength_grid.csv`, smoke test de IRF h0, CDS diário × `cds_5y` mensal do painel, e `z_jk_bs_norisk` reproduzindo ξ_mp 10,72 (por isso sua RHS é congelada sem o CDS). Escreve `output/instrument/jk_sovereign_confound.{csv,md}` e `jk_sovereign_irf_overlay.pdf`. |
| `fomc_coincidence.R` | Testa a ameaça irmã da anterior: o filtro seleciona **spillover do FOMC** em vez de choque do Copom? Exige `data/fomc_dates.csv` (`R/data_download/fomc_dates.R`), sem o qual a flag `fomc_coincide` era sempre FALSE. Quatro seções: timing (a notícia do Fed cai antes ou dentro da janela Qua→Qui?), contabilidade da exposição, regressão de `e_di_bs` no bloco americano contemporâneo sobre 6 conjuntos de dias + 2 interações, e máscara **re-derivada** nos resíduos duplos, que separa o canal de valores do de seleção — com IRFs de bootstrap completo nas 2 variantes que o veredito lê. Regra de leitura fixada no cabeçalho antes dos números; a divisão em metades com/sem FOMC e a terceira perna da regra que ela alimentava saíram em 2026-08-10, com o registro do corte no cabeçalho. Quatro auto-testes, entre eles `copom_event_diagnostics.csv` e ξ_mp 10,43/12,22. Escreve `output/instrument/fomc_coincidence.{csv,md}`, `fomc_coincidence_days.csv`, `fomc_coincidence_irf_overlay.pdf`. |

## 4. Sweep de especificação IRF / coerência

| script | o que faz |
|---|---|
| `irf_spec_sweep.R` | Etapa 1: sweep só de ponto (rápido) sobre instrumento × mp_var × (r,q) × janela amostral, com um `estimate_dfm` em cache por (amostra,r,q); classifica cada célula por `failure_class` no ξ_mp. Escreve `output/irf/spec_sweep_{cells,irf_long}.csv`, `spec_sweep_report.md`. |
| `irf_spec_stage2.R` | Etapa 2: bootstrap completo (nboot=800) nas células vencedoras da etapa 1, com a especificação de produção sempre incluída (force-append). Escreve `output/irf/irf_spec_<tag>.{rds,pdf}`, `irf_spec_stage2_overlay.pdf`, `spec_sweep_stage2.md`. |
| `irf_coherence_check.R` | Roda a especificação de produção uma vez e pontua 53 variáveis do painel ponto-a-ponto em cada horizonte contra janelas de teoria (`R/identification/irf_coherence.R`). É o script que alimenta a §5 do paper. Escreve `output/irf/irf_coherence_{h,summary}.csv`, `irf_coherence_report.md` (reescrito por inteiro a cada rodada — nunca editar à mão), `irf_coherence_plots.pdf`, e o cache `irf_coherence_cell.rds` (lido por muitos scripts a jusante). |
| `fig_section5.R` | Pós-processamento puro: lê o `irf_coherence_cell.rds` em cache + as tabelas da Tarefa 7, não reestima nada, escreve as 8 figuras `texto_anpec/fig_*.pdf` (todas até h=36), que é de onde `paper_anpec.tex` as inclui. Repontado em 2026-08-05: antes escrevia em `arquivo/tex/img/`, de modo que regenerar as figuras nunca alcançava o paper canônico. |

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

## 7. Identificação por heterocedasticidade (track Rigobon 2003)

| script | o que faz |
|---|---|
| `het_robustness.R` | Roda a identificação de Rigobon (2003) sobre o **DFM mensal** — o mesmo objeto do paper — para testar se ela aponta na mesma direção do proxy. Grade de `p ∈ {5..8} × q ∈ {5..8} × r ∈ {7,8}` (com `q ≤ r`) × `{full, pre_covid}` = 56 células, com um DFM em cache por célula reusado por 5 desenhos de regime: `calendario` e `episodio_s2` (os dois reprovados em 2026-07-16, reproduzidos) mais `intensidade_z`, `volatilidade_juros` e `quebra_livre` (novos). Gate = placebo (permutação para desenhos dispersos, **rotação** para contíguos) + teste de proporcionalidade de Rigobon Prop. 1, com **Holm sobre a família inteira** e exigência de replicar na outra janela. Escreve `output/het/het_{gate_grid,verdict,distribution}.csv`, `het_robustness.md`, `het_gate_surface.pdf`. Nada em produção é modificado. |

## 8. Validações de fidelidade contra código de referência

| script | o que faz |
|---|---|
| `validate_hac_kernel.R` | Valida a opção Newey-West de `compute_factor_space_wald` de duas formas: (A) transcrição literal de `NW_hac_STATA.m` vs. o kernel embutido nos lags 0-8 em dado sintético; (B) fim-a-fim contra o fixture oficial `TaxSVARIV.m` (NWlags=8). Só console, com `stopifnot`; degrada com "SKIPPED" se o fixture faltar. |
| `validate_olea_kilian.R` | Reproduz os números publicados de Montiel Olea-Stock-Watson (2021) no caso Kilian-oil (ξ₁=4.4, F robusto=9.4) a partir do fixture `output/validation/olea_oil_fixture.rds`. Confere de quebra que o VAR reestimado aqui bate com o `RForm` dos autores. Apontava para `codigo_olea/Data/Oil/` e estava **quebrado** desde a migração do código de referência para `codigos_externos/` (repontado em 2026-08-10). Só console, com `stopifnot`. |
| `validate_mosw_ar.R` | Valida `R/identification/weak_iv_ar.R` contra a aplicação do petróleo dos próprios autores: com `Load = Inner = I` as três funções recaem no MOSW original, então compara `WHat`, os coeficientes da quadrática, `MSWlbound/ubound`, os limites de delta-method e `casedummy` nos ramos cumulativo e não-cumulativo, a 68% e 95%. Fixture `output/validation/olea_oil_fixture.rds`; degrada com "SKIPPED" se faltar. |

## Notas cruzadas

- **`rm(list=ls())`**: presente em 22 dos 28 arquivos. Ausente em `download.R`, `instrument.R`, `instrument_diagnostics.R`, `validate_hac_kernel.R`, `validate_olea_kilian.R` e `validate_mosw_ar.R` — os seis são pensados para rodar em processo `Rscript` próprio, não para ser `source()`ados numa sessão existente.
- **Guarda `sys.nframe() == 0`**: só `model_var.R` (via `run_benchmark()`).
- Nenhum script deste diretório é chamado por outro script deste diretório, exceto através de `run_all.R` (estágios) ou de `source()` de módulos em `R/`.
