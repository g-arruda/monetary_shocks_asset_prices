# `arquivo/` — código e documentos fora do pipeline ativo

Criado em **2026-07-26**. Nada aqui é executado pelo pipeline de produção nem
citado pelo paper. O conteúdo foi preservado — em vez de apagado — porque
documenta **resultados negativos** e decisões revertidas que custaram trabalho e
que não estão registrados em nenhum outro lugar do repositório.

**Leia antes:** [`_instrucoes/historico_decisoes.md`](../_instrucoes/historico_decisoes.md)
explica *por que* cada bloco foi arquivado. Este README só diz *o que* está aqui.

> ⚠️ Nada aqui reproduz contra o painel atual. Todo este material é anterior ao
> **refresh de vintage de 2026-07-24** (106 séries) e/ou à **correção de tcode
> dos índices B3** da mesma data. Os artefatos de instrumento anteriores a
> 2026-05-07 também estão **100× fora de escala** por causa do bug de unit
> scaling do `yield_6m`. Trate os números como história, não como referência.

---

## `arquivo/script/` — scripts

### Track de heterocedasticidade (abandonado em 2026-07-16)

| script | o que fazia |
|---|---|
| `instrument_het.R` | Instrumento `z_het` (Rigobon-Sack 2003): SVAR diário sobre pares Qua→Qui, regimes Copom/não-Copom, projeção GLS Mertens-Ravn, agregação mensal. Produzia as 4 variantes + o bloco de robustez 3-var + a checagem A3 pré/pós-COVID |
| `instrument_validation.R` | Suíte T1-T8 (placebo, máscara aleatória, sub-período, correlação, anti-JK, curva F(k), sensibilidade AR, QLR de Andrews) para `z_het_jk` |
| `het_primary_feasibility.R` | Gates G1-G6 de viabilidade da het como identificação **primária** com regimes de calendário — 16 células, **todas reprovadas** |
| `het_episode_feasibility.R` | Idem com regimes de **episódio** (BPSS 2021, pré/pós-2020) — **reprovado** |
| `validate_het_primary_sim.R` | Harness de simulação (T1-T6) do módulo `het_primary.R`. Passava 100% — o método está correto; o que falhou foi o **dado mensal**, não o código |

### Órfãos (superados por scripts vivos)

| script | por que saiu |
|---|---|
| `instrument_audit.R` | Auditoria ancorada no instrumento het; as frentes GK foram absorvidas por `instrument_diagnostics.R` |
| `irf_cross_instrument.R` | Overlay primário × robustez de 2026-05-08 (`z_jk_purif` vs `z_het_jk_3var`). Substituído por `irf_spec_stage2.R` e `irf_instrument_report.R` |
| `build_grg_benchmark.R` | Benchmark GRG lido de bundles RDS het de 2026-05-08, já apagados |
| `instrument_grid.R` | Sweep vértice × amostra de purificação com só as 4 variantes legadas; anterior ao `z_jk_bs_purif` |

## `arquivo/R/identification/` — módulos

| módulo | conteúdo |
|---|---|
| `het_shock_extraction.R` | Bloco diário Rigobon-Sack: `extract_shock_rigobon_sack`, `validate_variance_split`, `rigobon_proportionality_test`, `rank1_lr_test`, `bootstrap_rank1_share_ci`, `classify_a2_verdict`, `build_het_instrument` |
| `het_primary.R` | Identificação primária por regimes mensais (Rigobon 2003; SW 2016 §5.1.2.3): `build_monthly_regimes`, `fit_rank1_md`, `ident_het_regimes`, `het_strength_stats`, `fit_two_regime_system`, `fieller_ratio_ci` |

**O ramo `identification = c("proxy", "het")` continua vivo** em
`R/modeling/impulse_responde.R::compute_irf_dfm` e em `main_sdfm`. Não foi
removido de propósito: é o molde do próximo ramo a ser escrito
(`identification = "nongaussian"`, LMS/GMR via `svars`), que consome `eta` e
devolve IRFs no mesmo formato. Para revivê-lo, basta `source()` dos dois módulos
acima antes de chamar `compute_irf_dfm(..., identification = "het")`.

## `arquivo/relatorio/` — notas e correspondência

| item | o que é |
|---|---|
| `2026-04-25_blindspot_het_instrument.md` | Ruling condicional sobre `z_het_jk`; chegou a propor reposicionar o paper em torno de identificação por variância |
| `2026-04-26_blindspot_validation.md` | Auditoria da suíte T1-T4; apontou que a F do JK fica *no* percentil 99 das máscaras aleatórias, não acima |
| `council_2026-05-05.md` | Painel de três críticos sobre o corpus `_instrucoes/` da época (*Major Revision*). Todo o veredito é sobre `z_het_jk`: falha de A2 em DI_2y, rank-1 imposto por asserção, e o F=21,3 medido contra a inovação AR(6) e não contra o primeiro estágio estrutural. As três exigências foram superadas pelos eventos — a het saiu do paper e a régua virou ξ_mp |
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
| `instrument_audit_report.md`, `instrument_audit_grid.csv` | Saídas de `instrument_audit.R` (2026-04-26), anteriores ao fix de unit scaling |
| `instrument_grid_report.md`, `instrument_grid.csv` | Saídas de `instrument_grid.R` (2026-04-26), só variantes legadas |

---

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

Os arquivos de `data/` (`instrument_z_het*.csv`, colunas `z_het*` em
`instrumentos_mensais.csv`) **foram mantidos**: `data/` é gitignored, não polui
o repositório, e regenerá-los exigiria rodar um script arquivado.
