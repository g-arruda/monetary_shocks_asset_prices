# `script/` — o que cada arquivo faz

São 15 scripts em `script/` e 7 travas de validação em `script/validation/`,
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

**2026-09-18 — limpeza pós-inspeção visual.** `q_truncation.R` foi para
`arquivo/script/` (os gráficos que importam são os de `q_sensitivity.R`), com
`containment_vs_production()`. Vários scripts perderam relatórios `.md` e
figuras que ninguém lia; os que as notas citam ficam em `output/` como órfãos.
Só restam as três variantes da `tab:first_stage`: com a purificação UST/FOMC
saíram do `download.R` os downloads de `fred_dgs2.csv` e `fomc_dates.csv`, e com
eles `R/data_download/{fred,fomc}.R`, que ficaram sem chamador. O `clean.R`
passou a impor a ordem das colunas do painel e a tirar o `tcode` do manifesto de
`infer_tcode_from_varnames()`.

**2026-09-25 — segunda passada da `coding-style` nos 15 scripts de nível
superior** (`validation/` ficou de fora). Todas as saídas reproduzem a execução
dos scripts anteriores: CSV byte a byte, `.rds` por `identical()`, PDFs com os
streams descomprimidos e só a data de criação diferente, o `.md` de
`factor_selection_pruned.R` só na linha de data e o console de `run_all.R` igual.
`download.R` não foi executado; os blocos com lógica nova foram conferidos contra
o código antigo em dados offline. Nenhum script chama mais `rm(list = ls())`.
Saíram as checagens redundantes:
- `download.R`: a pré-checagem dos insumos externos fixos, que o preflight de
  `run_all.R` já faz, e a recusa de argumentos;
- `mosw_strength_grid.R`: a finitude e o `n_obs` do diagnóstico;
- `q_sensitivity.R`: a normalização em h=0, que `ident_ext_instr()` garante por
  construção;
- `fig_section5.R`: o laço que conferia o `.rds` contra `irf_coherence_h.csv`,
  que saem da mesma execução;
- `fig_weak_iv.R`: a finitude e `lo > hi`;
- `het_conditions.R`: as dimensões do painel e a raiz de produção, que
  `validate_production_spec.R` declara;
- `panel_pruning.R`: a contagem de 115 colunas.

Ficaram as travas de decisão do autor, as asserções do método, os auto-testes
pré-registrados, as checagens que impedem NA silencioso e a integridade dos
dados baixados. `model_var.R` perdeu uma chamada a `mosw_svar_iv()` cujo
resultado ninguém lia.

No mesmo dia, a passada em `R/modeling/` levou para `model_alessi.R` o código
de `plot_irf()`, que só ele chamava, e fez `validate_hac_kernel.R` e
`validate_olea_kilian.R` carregarem `R/identification/factor_space_diagnostics.R`,
para onde foram `compute_factor_space_wald()` e `compute_robust_first_stage_F()`.
A passada em `R/identification/` desmontou `spec_sweep.R` e
`experimental_panel.R`. Com isso, `irf_coherence_check.R` e `q_sensitivity.R`
passaram a carregar `R/modeling/dfm_pipeline.R` (`run_stage2_cell()`), e
`q_sensitivity.R` também `R/reporting/figures.R` (`plot_dimension_overlay()`).
`factor_selection_pruned.R` e `validate_amengual_watson.R` passaram a carregar
`R/reporting/markdown_report.R` (`md_table()`), e `panel_pruning.R` passou a
carregar `R/modeling/factor_selection.R` (`prune_correlated_series()`). Dois
scripts ganharam o que só eles usavam: `irf_coherence_check.R` recebeu a tabela
de teoria, antes `coherence_var_table()`, e `panel_pruning.R` a taxonomia de
blocos, antes `base_block_taxonomy()`. A passada em `R/instrument/` tirou os
defaults de `di_surprise.R`: `instrument.R` passou a escrever o caminho de
`copom_historico.csv`, e `R/identification/het_tests.R` passou a escrever
`min_bd = 10`. `instrument.R` gera os três CSVs idênticos em bytes.
O mapa está em `registro/mapa_renomeacoes.md`.

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
| `run_all.R` | Orquestrador fim a fim. Roda 5 estágios nomeados (`download`, `macro_news`, `clean`, `instrument`, `model`), cada um como subprocesso `Rscript` via `system2`, com `--list/--dry-run/--from/--to/--only/--skip/--skip-existing/--continue-on-error`. Confere as pré-condições de cada estágio (`requires`/`produces`). O estágio `model` só chama `model_alessi.R`: não roda `model_var.R` nem scripts de diagnóstico. |
| `download.R` | Único ponto de entrada de downloads. Coleta SGS, Focus/Olinda, Yahoo, B3, IPEA e SIDRA e lê os insumos externos fixos, cuja presença o preflight de `run_all.R` confere. Grava os quatro artefatos diários em `data/raw/` e monta `raw_data.csv`: 113 séries completas na amostra 2012-03–2025-12, incluindo os três indicadores fiscais e as quatro expectativas Focus da produção. `di.csv`, a curva e o CDS Bloomberg continuam externos e nunca são sobrescritos. |
| `download_macro_news.R` | Insumos do bloco de notícias macro da regressão pré-anúncio (Tabela 3 de Bauer-Swanson), desde 2026-09-25, num estágio de rede próprio para rodar sem re-baixar o painel de `download.R`. Coleta os painéis Focus diários do IPCA mensal e do PIB trimestral (por data e período de referência), o IPCA e o núcleo EX0 do SGS (433 e 11427) e o PIB na **primeira divulgação**, lido pelo `pdftotext` da Tabela I.1 do caderno de cada divulgação no FTP do IBGE (2011T4–2025T3), porque o SIDRA só guarda a safra revisada. Escreve `data/raw/focus_macro_expectations.csv` e `data/raw/macro_released.csv`. |
| `clean.R` | Filtra 2012-03–2025-12 e aplica log e a cascata X-13 às 113 séries raw. Constrói e audita o ajuste cambial da DLSP e as três expectativas fiscais Focus. Grava a base histórica de 106 séries e monta o painel de produção de 115, removendo `juros_cdi` e `asset_mlcx`. Impõe a ordem de colunas com que todos os outputs foram estimados (preços depois de `epu_*`, fiscais e Focus antes), porque o ABC e o arredondamento da PCA dependem dela. Escreve o manifesto integral em `output/panel/production_series_manifest.csv`, com o `tcode` de `infer_tcode_from_varnames()`. |
| `instrument.R` | Constrói, desde 2012-03, as três variantes mensais da `tab:first_stage` — `z_bruto`, `z_bs_purif` (produção desde 2026-09-26) e `z_jk_bs_purif` (produção até 2026-09-26) — via `R/instrument/{di_surprise,build_variants}.R`, com antecedentes diários desde 2011-09 (`TARGET_BD=126`, soma JK). Escreve `data/processed/instrumentos_mensais.csv`, o legado `data/processed/instrument.csv` e o painel diário `copom_event_diagnostics.csv`. Desde 2026-09-25 escreve também `output/instrument/bs_orthogonalization.csv`, os coeficientes das duas regressões pré-anúncio (DI e Ibovespa) com EP HC1, `R²`, `n`, a Wald conjunta HC1 dos nove preditores e a das quatro notícias macro (na branch `feature/bs-copom-surpresas-macro`: 102 reuniões, só constante): a `tab:bs_ortogonalizacao` do Anexo D, análoga à Tabela 3 de Bauer-Swanson. |
| `model_alessi.R` | Script de produção do DFM principal. Traz a especificação de produção nos seus próprios literais, grava a superfície Bai--Ng BLL completa e estima `(r=5, q=5, p=4, choque=+50bp em yield_6m)` com a inferência de produção: conjuntos Anderson--Rubin desde 2026-09-08. Escreve `output/irf/irf_model_alessi_r5q5.pdf`. |

## 2. Benchmark (fora do `run_all.R`)

| script | o que faz |
|---|---|
| `model_var.R` | Único driver do VAR pequeno observável. Desde 2026-09-21 roda na **janela e no `p` do DFM** (2012-03--2025-12, `p=4`, `T_eff=162`), para que o contraste entre os dois modelos não seja de amostra nem de ordem; `p=4` é decisão de comparabilidade e não do AIC, que em `T=154` escolhe `p=2`. Continua exigindo `--reestimate-current-instrument`, para impedir que a proxy BS recalculada altere o benchmark sem aviso. Estima as cinco séries em nível com constante e tendência linear, com respostas `C_h B_1` e conjuntos AR 80%/90% em NW(0) (68%/90% até 2026-09-26). Escreve só os três `.csv` de `output/var/`: desde 2026-09-21 não escreve mais o relatório `svar_iv_weak_robust.md`, que fica congelado na vintage `p=4` como registro citado. |

## 3. Força do instrumento

| script | o que faz |
|---|---|
| `instrument_diagnostics.R` | Compara as três variantes no DFM de produção. Por variante: meses com `z ≠ 0`, ξ_mp, F_rob,mp, `β̂`, EP e `p` na direção de `yield_6m` — as colunas da `tab:first_stage` que `mosw_strength_grid.csv` não carrega — e um teste de exogeneidade *lead-lag*. Escreve `output/instrument/instrument_diagnostics.csv`. O antigo `instrument_diagnostics_report.md` e o PNG de dispersão ficam como órfãos citados. |
| `mosw_strength_grid.R` | Grade de ξ_mp e F_rob,mp dos três instrumentos da `tab:first_stage`, `p=4`, na direção de normalização de `yield_6m`. Na cheia, com a escala COVID, varre `r=4:6`, porque `r ≥ 7` é explosivo; na pré-COVID, `r=4:8`. Escreve `output/instrument/mosw_strength_grid.csv`, que carrega ξ_mp, F_rob e `n` da `tab:first_stage` nas duas janelas; o `.md` deixou de ser gerado em 2026-09-18 e fica como órfão citado. |
| `het_conditions.R` | A condição de identificação por heterocedasticidade de Rigobon (2003) nos sistemas que a tabela do Anexo B compara (`tab:het_frequency`, que desde 2026-09-27 traz também as razões de variância), e que a §3.3 resume: o painel semanal Qua→Qui reconstruído de `data/raw/`, o VAR mensal de DI, câmbio e CDS em duas versões e as cinco inovações fatoriais da célula de produção. Desde 2026-09-27 o VAR mensal roda por MQO e por MQP sob a escala COVID de Lenza-Primiceri, com θ próprio por vértice, estimado por `estimate_covid_theta()` e travado por `verify_covid_theta()`; o paper publica só a versão tratada. As duas versões vão ao teste pelos resíduos, como a linha fatorial (`p = 1`, inerte, 161 meses), e escrevem também `het_var_theta.csv` e `het_var_theta_multistart.csv` (nota `2026-09-27_het_var_escala_covid`). O estimador e o teste são os do pacote `svars` — `IdentifyVolatility()` e o `Qr` sequencial de Lütkepohl et al. (2021) —, e a bateria é só essa desde 2026-09-22: o teste de proporcionalidade de Mauchly, o gap λ₁−λ₂, `ratio_dir`, `rank1_share` e o placebo de permutação saíram. Reporta também a condição de posto em forma escalar, `det(Σ_C − aΣ_NC)/det(Σ_NC)`, **na variação Qua→Qui e no painel mensal lado a lado**, e o quanto a correção de curtose do teste custa em cada sistema. ⚠ A única agregação mensal é a do próprio painel — última cotação do mês de referência; o objeto que somava as janelas Qua→Qui dentro do mês foi retirado em 2026-09-22 por decisão do autor. Escreve `output/het/het_conditions.csv`, `het_qr_tests.csv`, `het_variance_ratios.csv` (razão de variância de Rigobon--Sack por série) e `het_lambda.csv` (todos os autovalores com EP), além do painel diário que `het_rigobon/` consome. O `het_conditions.md` deixou de ser escrito em 2026-09-24 e fica como registro citado. É **diagnóstico, não identificação**: a rota het segue abandonada desde 2026-08-17 e nenhuma IRF sai daqui. |

## 4. IRF: coerência, inferência e sensibilidade a `q`, `p` e instrumento

| script | o que faz |
|---|---|
| `irf_coherence_check.R` | Roda a especificação de produção uma vez e pontua 58 variáveis do painel, ponto a ponto e em cada horizonte, contra janelas de teoria (`R/identification/irf_coherence.R`). É o script que alimenta a §5 do paper. As bandas são os conjuntos Anderson--Rubin, e significância é "o conjunto exclui zero", lida pela topologia. Escreve `output/irf/irf_coherence_{h,summary}.csv` e o cache `irf_coherence_cell.rds`, lido por scripts a jusante. O relatório `irf_coherence_report.md` e o `irf_coherence_plots.pdf` deixaram de ser gerados em 2026-09-18 e ficam como órfãos citados. |
| `q_sensitivity.R` | Passo 4/4 do e-mail de 2026-09-13: as 20 variáveis da narrativa em `q = 2..5`, com `r = 5`. `--window` é obrigatório. `--window=cheia` usa `p = 4` e a volatilidade COVID lida de `output/factors/covid_volatility_theta.csv`, com AR na regressão transformada. `--window=pre_covid` usa `p = 2`, porque em `p = 4` o AR pré-COVID é barrado. `q = 5` traz os conjuntos AR de 80/90%, e `q = 2..4` são pontuais, no desenho da Figura A3 de Alessi-Kerssenfischer. Só desenha: escreve `output/factors/q_narrative_r5p4_covid.pdf` ou `q_narrative_r5p2_precovid.pdf`, as 20 séries até h=48. Desde 2026-09-24 `--window=cheia` também escreve `paper/fig_q_sensibilidade.pdf`, a figura do Anexo C: oito séries até h=36, nos rótulos e escalas de `fig_section5.R`, com o `q = 5` conferido contra `output/irf/irf_coherence_h.csv` a 1e-10. Desde 2026-09-18 não grava `.md` nem CSV; os `_summary.csv`, citados em `notas/2026-09-14_inferencia_volatilidade_covid_q.md`, ficam como órfãos. Desde 2026-09-25 a pilha dos caminhos, a guarda de topologia e a conferência contra o cache vêm de `R/reporting/sensitivity.R`, que também serve a `p_sensitivity.R` e `instrument_layers_irf.R`. |
| `p_sensitivity.R` | Figura do Anexo C sobre a ordem do VAR fatorial: `p = 2..6` com `r = q = 5`, janela cheia, `z_bs_purif`. Cada `p` lê o seu θ̂, reestimado por `covid_volatility_theta.R` (`p = 4` lê o de produção, os demais `output/factors/theta_by_p/`). `p = 4` traz os conjuntos AR de 80/90%, e os demais são pontuais. Aborta se algum companion for explosivo. Confere `p = 4` contra `irf_coherence_h.csv` a 1e-10. Escreve `output/factors/p_sensitivity.csv` (com a raiz máxima de cada `p`) e `paper/fig_p_sensibilidade.pdf`. Nota: `2026-09-25_p_sensibilidade_anexo`. |
| `instrument_layers_irf.R` | Figura do Anexo D: as respostas da produção `(5,5,4)` sob as duas camadas do instrumento da `tab:first_stage` (a bruta e a ortogonalizada; a camada JK saiu do paper em 2026-09-26), trocando só o instrumento. As duas camadas recebem conjuntos AR de 80/90%, gravados em `output/irf/instrument_layers_irf.csv` (todas as variáveis, h ≤ 36, com `set_type80/90`), mas a figura `paper/fig_instrumento_camadas.pdf` sombreia só a produção (`z_bs_purif` desde 2026-09-26), no desenho da Figura A3 de AK. Confere a produção contra `irf_coherence_h.csv` a 1e-10. Notas: `2026-09-25_anexo_d_instrumento`, `2026-09-26_migracao_paper_bs_purif`. |
| `fig_section5.R` | Pós-processamento puro: lê o `irf_coherence_cell.rds` canônico, sem reestimar nada. Escreve as 9 figuras `paper/fig_*.pdf` até h=36; a figura de dependência de estado (LP-IV da Tarefa 7, `fig_estado.pdf`, sem consumidor no paper) saiu em 2026-09-18. Descongelado em 2026-09-24, quando a §4 migrou e as legendas passaram a dizer Anderson--Rubin; as oito figuras da §4 carregam os conjuntos de 80% e 90% (68% e 90% até 2026-09-26), e `fig_placebos.pdf` está no Anexo D desde 2026-09-30. |
| `fig_weak_iv.R` | Pós-processamento puro do CSV canônico da inferência robusta no VAR. Escreve só `paper/fig_weak_iv_main.pdf`, com ponto, zero e as faixas de 80% e 90% (68% e 90% até 2026-09-26) nas cinco respostas da produção até `h=36`, no mesmo padrão de bandas de `fig_section5.R` desde 2026-09-18. **Congelado desde 2026-09-08:** aborta sem `--repaint-paper-figures`, porque o contraste bootstrap-vs-AR que a legenda anuncia deixou de existir quando o DFM migrou para AR. |

## 5. Seleção de fatores, painel e volatilidade COVID

| script | o que faz |
|---|---|
| `panel_pruning.R` | Poda o painel de produção pela correlação par a par das primeiras diferenças (sugestão 2/5 do e-mail de 2026-09-04). Usa ligação completa em \|ρ\| ≥ 0,90 e mantém uma série por grupo, por regra pré-registrada. Os limiares 0,80, 0,85 e 0,95 e a ligação simples entram como sensibilidade, e a versão restrita a cada bloco entra como comparação. Escreve o manifesto (`pruning_manifest.csv`, lido por `factor_selection_pruned.R`) e os pares acima de 0,80 em `output/panel_experimental/poda_correlacao/`; o relatório e os mapas de calor deixaram de ser gerados em 2026-09-18 e ficam como órfãos citados. Não altera a produção. |
| `factor_selection_pruned.R` | Refaz a seleção do número de fatores nos painéis podados (sugestão 3/5 do e-mail de 2026-09-04). Roda Bai--Ng BLL, ER/GR de Ahn-Horenstein, ABC e Amengual--Watson no painel atual e em cada painel do manifesto de `panel_pruning.R`, com `p=4`, grade de `r` e as convenções do projeto e do MATLAB para o 2º estágio. A regra de leitura é pré-registrada; não calcula ξ_mp nem IRF. No painel atual, reproduz `output/factors/factor_selection_alt_summary.csv`, saída do arquivado `factor_selection_alt.R`. Escreve `output/factors/factor_selection_pruned.{md,pdf}`, `factor_selection_pruned_summary.csv` e `factor_selection_pruned_aw.csv`. |
| `covid_volatility_theta.R` | Estima θ = (s̄0, s̄1, s̄2, ρ), a escala de volatilidade COVID de Lenza-Primiceri (2022), por máxima verossimilhança (B5 do Apêndice B) no VAR dos fatores de produção, com `t*` = 2020-03, s̄ ≥ 1 e ρ ∈ [0,1]. Confere as condições de primeira ordem, o perfil de ℓ em ρ e, desde 2026-09-24, um multi-start de 750 inícios na caixa inteira, as três travas em `verify_covid_theta()` (`R/modeling/factor_estimation.R`) desde 2026-09-27, quando saíram do script sem mudar um byte das saídas. Aborta se o otimizador parar num máximo local, se algum início terminar acima de θ̂ ou se algum empatar com ele a mais de 5% de distância. É o único produtor de θ̂, que os scripts de estimação leem de volta por `read_covid_volatility()` — e portanto o único que não o lê. Desde 2026-09-25 roda uma passada por `p = 2..6`, com todas as travas em cada uma: `p = 4` escreve os arquivos de produção, os demais `output/factors/theta_by_p/covid_volatility_{theta,multistart}_p<p>.csv`, lidos por `p_sensitivity.R`. Escreve `output/factors/covid_volatility_theta.csv` e, desde 2026-09-24, `covid_volatility_multistart.csv`, uma linha por início: `s_t` sai de θ̂ por `covid_volatility_path()`, e o perfil em ρ é trava, não saída. Desde 2026-09-25 o estimador, o perfil e o multi-start derivam com `ndeps = 1e-6` (o passo padrão de 1e-3 parava antes do máximo e barrou `p = 5`), o que moveu θ̂ de produção na 4ª–5ª casa. Leva uns 2 a 3 min por `p`, quase todos no multi-start. `covid_volatility_path.csv` e `covid_volatility_profile_rho.csv` ficam como órfãos citados em notas desde 2026-09-18. Nota: `2026-09-24_otimo_global_theta`. |

## 6. `validation/` — travas contra o código de referência

Um teste que passou prova o código só naquele commit. Estas travas são testes
de regressão: rode-as de novo depois de qualquer mudança em `R/modeling/` ou
`R/identification/`. Como `codigos_externos/` é gitignorado, elas rodam sobre
fixtures commitadas em `output/validation/`. Num clone limpo, são a única prova
reproduzível de fidelidade ao código dos autores. Todas rodam da raiz do
projeto: `Rscript script/validation/<arquivo>.R`.

| script | o que faz |
|---|---|
| `validate_hac_kernel.R` | Valida a opção Newey-West de `compute_factor_space_wald` de duas formas: (A) transcrição literal de `NW_hac_STATA.m` vs. o kernel embutido, nos lags 0-8 em dado sintético; (B) fim a fim contra o fixture oficial `TaxSVARIV.m` (NWlags=8), o que também mede a equivalência da residualização Shat que entra em todo ξ_mp. O ramo NW>0 ficou sem consumidor vivo quando `xi_mp_robustness.R` foi arquivado, porque a produção usa NW(0). Só console, com `stopifnot`; falha se faltar fixture. |
| `validate_mosw_ar.R` | Valida o caminho inteiro do VAR observável. Contra `olea_oil_fixture.rds`, reproduz `AL`, `eta`, `Sigma`, `Gamma`, `WHat`, MA, os pontos SVAR-IV e os conjuntos AR de 68%/95%. Exige os dez casos degenerados do oráculo e compara AIC/BIC da célula brasileira com uma implementação independente e com `vars::VARselect(type="both")` (em `T=154`: AIC `p=2`, BIC `p=1`) e fixa que o `p=4` da produção **se afasta** do AIC de propósito. Checa também que a generalização `Load`/`Inner`, por onde passa o DFM, colapsa **exatamente** no MOSW original quando as duas são a identidade. Falha se faltar fixture ou dado. |
| `validate_olea_kilian.R` | Reproduz os números publicados de Montiel Olea-Stock-Watson (2021) no caso Kilian-oil (ξ₁=4.4, F robusto=9.4) a partir de `output/validation/olea_oil_fixture.rds`, e confere que o VAR reestimado bate com o `RForm` dos autores. Só console, com `stopifnot`; falha se faltar fixture. |
| `validate_amengual_watson.R` | Valida a tradução de `amengual_watson()` contra `amengual_watson.m`, `factor_estimation_ls.m` e `bai_ng.m` de Stock-Watson, transcritos literalmente, sobre a fixture commitada `output/validation/amengual_watson_fixture.csv`. Não há MATLAB/Octave aqui, então a transcrição *é* o instrumento. Mede em separado o que `apply_bll = TRUE` faz. Escreve `output/validation/amengual_watson_validation.md` e falha alto se `q_hat` divergir ou se o gap deixar de ser a constante `log(n/(n-1))`. |
| `validate_production_spec.R` | Valida a composição 115/base 106, as 166 datas, o manifesto SGS 20784/20785, o contrato do instrumento, a superfície Bai--Ng BLL, os critérios de defasagem, a força e as raízes full/pré-COVID e os cinco impactos obrigatórios. É a declaração canônica da especificação de produção — cada invariante escrito aqui como literal — e re-deriva o θ̂ do CSV a partir do painel. Também produz números: escreve `production_factor_lag_criteria.csv` (o AIC p=4 da §3.1), `production_spec_diagnostics.csv` e `production_spec_impact_smoke.csv`. |
| `validate_covid_volatility.R` | Valida a escala de volatilidade COVID de Lenza-Primiceri (2022, Apêndice B) no VAR dos fatores. **No painel de produção, com θ neutro (`s_t ≡ 1`):** o WLS sai `identical()` ao OLS com cada um dos 162 meses de resíduo como `t*`; o pipeline pontual tratado bate com a produção a 1e-12; (B5) confere com a verossimilhança gaussiana calculada por força bruta; e cada `stop()` a jusante dispara. **Em VAR simulado com θ arbitrário:** checa (B2), (B5), `s_t`, o encanamento de `estimate_dfm`, `estimate_covid_theta`, o H não centrado, os valores iniciais contra `bvarGLP_covid.m`, a função de influência do estimador tratado e os conjuntos AR e o ξ_mp tratados contra MOSW alimentado à mão. Silencioso; para no primeiro erro. |
| `validate_het_cv.R` | Valida o `fit_het_cv()` contra o próprio `svars::id.cv()`, que tem de ser contornado quando o regime se repete (o ramo público do indicador 0/1 está quebrado e colapsa para `Λ = I`). Num caso em que o caminho público **funciona** — quebra contígua em 2020-03, dados padronizados, `p=4` — exige `Λ`, a tabela `Qr` e `BB'` idênticos aos do `id.cv()`; fixa que nas unidades cruas o `id.cv()` colapsa (o motivo da padronização interna); e exige `Qr_nk / fator_curtose = Qr` a `1e-10`, que é a identidade que prova que o `qr_without_kurtosis()` carrega a fórmula de curtose do pacote, convenção `TB` incluída. Silencioso; para no primeiro erro. |

## Notas cruzadas

- **Um processo por script**: nenhum entry point limpa o ambiente. Todos são pensados para rodar em processo `Rscript` próprio, não para ser `source()`ados numa sessão existente.
- Nenhum script daqui é chamado por outro script daqui, exceto através de `run_all.R` (estágios) ou de `source()` de módulos em `R/`.
