# Refactor `coding-style` — checklist de chunks

Continuidade de sessão (descartável). Plano completo em
`~/.claude/plans/refatore-os-scripts-deste-nifty-nygaard.md`.

**Decisões do usuário:** conservador (não inlinar funções de uso único em `script/`); as três
correções estruturais autorizadas; re-rodar de verdade inclusive os 4 scripts caros; promover
helpers duplicados a arquivos de domínio.

**Fora de escopo:** `diagnostics/rq_dimension_audit/` e `diagnostics/rq_block_dimension_audit/`
(congelados, se auto-verificam a `1e-10`, citados em `registro/`/`notas/` — e já sem violação);
`codigos_externos/`; `arquivo/`; reescrita idiomática do núcleo matricial.

## Régua de verificação

```bash
# smoke test full-precision (segundos)
Rscript -e 'source("R/modeling/factor_estimation.R"); source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R"); source("R/modeling/dfm_pipeline.R")
res <- main_sdfm(r=5L, q=5L, p=6, shock_size_bps=50, mp_var="yield_6m", nboot=0)
cat(sprintf("%.17g\n", res$irfs$irf_point_matrix[match(c("yield_6m","yield_2y","yield_5y","asset_ibov","cambio_usd"), colnames(res$data)), 1]), sep="")'
```

Referência bit-a-bit (17 dígitos):
`0.0050000000000000001` · `0.0074300592008910019` · `0.0077611464176508358` ·
`-1.7226766564462794` · `0.15792806572512938`

Diff de artefato: `git status --porcelain output/` depois de re-rodar. `.csv`/`.rds` têm de ficar
byte-idênticos; `.md` só pode mover a linha `Gerado ... em <data>`; `.pdf` sempre difere por
timestamp embutido (conferir com `diff <(strings a) <(strings b)`).

---

## Chunk 1 — higiene de `R/` ✅ FEITO E VERIFICADO

Arquivos: `validation_tests.R`, `fomc_dates.R`, `external_factors.R`, `ibov_daily.R`,
`di_surprise.R`, `het_primary.R`, `anbima_breakeven.R`, `het_tests.R`, `nongaussian_gmr.R`,
`build_variants.R`, `factor_estimation.R`, `impulse_responde.R`.

- 46 chamadas bare namespaceadas (33 em `validation_tests.R`, 13 em `fomc_dates.R`)
- **`R/` agora tem ZERO `library()`** — 8 blocos removidos
- mortos apagados: `scree_analysis`, `cayley_a`; locais nunca lidos: `realized`, `N`,
  `max_eigenval`, `n_vars`/`h` em `validate_bootstrap_results`
- `bootstrap_validation <- ...` → chamada nua
- `T <- nrow(data)` → `n_obs` (desmascara `TRUE`) em `estimate_static_factors`
- **149/149 funções de `R/` com bloco roxygen** (12 blocos novos + gaps de `@param`/`@return`,
  incl. `compute_irf_dfm` com 18 params e `plot_irf` com 9)

Verificação: parse OK em todos os arquivos · smoke test **bit-idêntico** ·
`irf_coherence_h.csv`, `irf_coherence_summary.csv` e `irf_coherence_cell.rds` **byte-idênticos** ·
`.md` só a linha de data · `.pdf` só CreationDate/ModDate.

---

## Chunk 2 — três correções estruturais ✅ FEITO E VERIFICADO
- (a) `main_sdfm` → `R/modeling/dfm_pipeline.R` (novo); `script/model_alessi.R` agora é linear, sem
  `library()`, 212 → 60 linhas. Ganhou o parâmetro `spec = production_spec()` para não depender do
  global `SPEC` do chamador; todo call site já passava argumentos nomeados. Smoke test do
  `CLAUDE.md` reescrito para `source()` — **o hack `readLines()[1:156]` morreu**.
- (b) `impulse_responde.R` → `impulse_response.R`, 47 arquivos repontuados (27 `script/`, 3 `R/`,
  11 `diagnostics/`, `README.md`, `.claude/rules/{identification,instrument}.md`).
- (c) `R/data_download/fomc_dates.R` → `script/fomc_dates.R` (nunca era sourced); repontuados
  `run_all.R`, `CLAUDE.md`, `AGENTS.md`, `README.md`, `script/README.md`, `.claude/rules/data.md`,
  `R/instrument/di_surprise.R` (msg de erro) e a string de relatório de `fomc_coincidence.R`.

Verificação: parse OK · todo `source()` resolve · `run_all.R --list` e `--dry-run` passam com o
estágio `fomc` no novo caminho · smoke test **bit-idêntico** na forma que o `CLAUDE.md` documenta ·
`script/model_alessi.R` roda ponta a ponta e o PDF sai com conteúdo idêntico (só CreationDate).

⚠ **32 arquivos de `notas/`/`pareceres/`/`registro/` ainda citam `impulse_responde.R` e
`R/data_download/fomc_dates.R`** — deixados verbatim por regra (`.claude/rules/writing.md`).
Falta decidir com o usuário se entra nota de leitura com o mapa de renome.

⚠ **`script/fomc_coincidence.R` teve a string de relatório repontuada**, então
`output/instrument/fomc_coincidence.md` fica stale até o chunk 5 re-rodar o script.

📌 **Custo real medido:** `model_alessi.R` roda em **13 s** com nboot=800, não "long" como o
`CLAUDE.md` diz. A estimativa de custo dos chunks 5-6 provavelmente está superestimada.

## Chunk 3 — duplicatas para domínio ✅
`R/reporting/markdown_report.R` novo, com `md_tbl` verbatim (≠ `md_table`) e o `fmt` das 3 cópias
idênticas · `rq_surface_table` → `R/identification/spec_sweep.R` · apagados `fmtn` e o `md_tbl` morto
de `_common.R`. `on_date`/`mk_z` ficaram para o chunk 5 (fechavam sobre estado do script).

## Chunk 4 — namespacing `script/`, leva barata ✅  (12 arquivos)
Zero `.csv`/`.rds` alterado; 8 `paper/fig_*.pdf` comparados por renderização (pdftoppm+sha256).
Removido o laço de `install.packages()` de `instrument_diagnostics.R` (mudança de comportamento
deliberada, anunciada no commit).

## Chunk 5 — namespacing `script/`, leva média ✅  (4 arquivos) + on_date/mk_z
`on_date` → `R/instrument/di_surprise.R`; `mk_z` → `build_monthly_z()` em `build_variants.R`,
com `valid`/`monthly_grid` explícitos.

## Chunk 6 — namespacing `script/`, leva cara ✅  (5 arquivos)
+ chunk 6b: `library()` redundante removido das famílias `panel_composition_*` e `validate_*`.

## Chunk 7 — `diagnostics/` de topo ✅
Os **58 CSVs saíram byte-idênticos**, inclusive `t7_2_irf_estado.csv` e todos os p-valores de
bootstrap semeado — prova de que o stream do RNG não se moveu.

## Chunk 8 — Python ✅
`download_di.py` → `script/`, com `pathlib`. `R/` agora só tem `.R`.

## Chunk 9 — `download.R` ✅
Últimos 2 sítios bare + `options()` duplicado. **Único arquivo não verificado rodando** (rede).

---

## Estado final

- **0 chamadas bare** de pacote anexado em todo o `R/`, `script/` e `diagnostics/` (73 arquivos)
- **149/149 funções de `R/` com roxygen**
- **4 `library()` restantes, todos justificados e comentados**: `urca` em
  `factor_stationarity.R` e `05_persistencia_fatores.R` (despacho S4 de `summary.ur.df`),
  `patchwork` em `model_var.R` (operador `|`), `rb3` em `download.R` (não verificável sem rede)

## As três armadilhas que o diff pegou — reler antes de mexer em namespacing de novo

1. **`urca` precisa estar anexado.** `ur.df` é S4; `summary()` só despacha com o pacote no search
   path. Sem isso o objeto sai sem `@teststat`, o `tryCatch` de `run_ur()` vira NA, e o ADF inteiro
   virou "ambiguo" em `factor_unit_root.csv` **sem erro nenhum**. Só o diff pegou.
2. **`patchwork` precisa estar anexado** onde a composição usa o operador `|` (`model_var.R:431,475`);
   `+` com `wrap_plots`/`plot_annotation` namespaceados funciona só com o pacote carregado.
3. O comentário "never `dplyr::lag()`" nos dois scripts de confound avisa contra usar lag para a
   busca Qua→Qui, **não** contra o `dplyr::lag`. Os `lag()` reais ali são dplyr.

## Achados pré-existentes, não causados pelo refactor

- `output/assets/asset_guards.csv` e `asset_representation.md` estavam **stale**: rótulos "53 series
  escoradas"/"45 nao-acionarias" contra 58/51 que o código de HEAD produz. Nenhum número mudou, só
  os rótulos de tamanho de conjunto. Nenhum dos dois é citado em `notas/`, `registro/` ou `paper/`.
- `output/var/var_benchmark.md` dizia "**Bloco de ações (8 índices)**" com `n = 7` na mesma linha;
  o código produz "(7 índices)". Coerente com `asset_mlcx` ter saído na migração para 111 séries.
- `CLAUDE.md` chama `model_alessi.R` de "long; bootstrap dominated" — roda em **13 s** com nboot=800.
  Vários outros custos documentados também estão superestimados (`factor_stationarity` ~2 s, não
  ~2 min).

## Pendências para decidir com o usuário

- **32 arquivos de `notas/`/`pareceres/`/`registro/` ainda citam `impulse_responde.R` e
  `R/data_download/fomc_dates.R`.** Deixados verbatim por `.claude/rules/writing.md`. Falta decidir
  se entra nota de leitura com o mapa de renome, e onde.
- **`script/download_di.py` aponta para `releases/latest`** (alvo móvel) e **não valida nada do que
  baixou**. É decisão de pesquisa, não de estilo — não mexi.
- `md_table()` continua morando em `R/identification/spec_sweep.R`, que não é o domínio dele.
  Mover custa 6 scripts de risco e não muda número nenhum; fica como dívida.
