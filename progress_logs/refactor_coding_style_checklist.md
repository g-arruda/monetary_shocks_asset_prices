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
# smoke test full-precision (segundos) — script em scratchpad, ver plano
Rscript -e 'src <- readLines("script/model_alessi.R"); eval(parse(text = paste(src[1:156], collapse="\n")))
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

## Chunk 3 — duplicatas para domínio ⬜
`R/reporting/markdown_tables.R` com `md_tbl` **verbatim** (≠ `md_table`, não substituir) e o `fmt`
de 3 cópias idênticas · `on_date`/`mk_z` → `R/instrument/di_surprise.R` ·
`rq_surface_table` → `R/identification/spec_sweep.R` · apagar `fmtn` e o `md_tbl` morto de
`diagnostics/_common.R`

## Chunk 4 — namespacing `script/`, leva barata ⬜  (~250 sítios)
`irf_coherence_check`, `irf_spec_sweep`, `irf_spec_stage2`, `nongaussian_{gate,corroboration,labelling}`,
`mosw_strength_grid`, `xi_mp_robustness`, `instrument_diagnostics`, `instrument`, `fig_section5`,
`panel_composition`

## Chunk 5 — namespacing `script/`, leva média ⬜  (~400 sítios, ~10 min)
`jk_sovereign_confound`, `fomc_coincidence`, `factor_stationarity`, `het_robustness`

## Chunk 6 — namespacing `script/`, leva cara ⬜  (~300 sítios, ~50 min)
`asset_representation`, `instrument_construction_sweep`, `model_var`, `model_nongaussian`,
`model_alessi`

## Chunk 7 — `diagnostics/` de topo ⬜
`_common.R` + `01`–`07`: ~180 sítios + limpezas. **Sem reordenar** (RNG). Diff dos 58 CSVs.

## Chunk 8 — Python ⬜
`download_di.py` sai de `R/` e passa a usar `pathlib`. Pinar o release fica como recomendação.

---

## Armadilhas (reler antes de cada chunk)

1. `md_tbl` **não** é `md_table` — `round()`+vetor vs `formatC(signif())`+string. Trocar
   re-renderiza dígitos em `.md` commitados.
2. `lag()` bare em `jk_sovereign_confound.R:234` e `fomc_coincidence.R:232-233` é **`stats::lag`**
   de propósito (comentário no código). Idem cuidado com `filter`, `first`, `last`, `count`.
3. `diagnostics/01` e `07`: `set.seed()` no topo + bootstrap de 2.000. Namespacing não desloca o
   stream; **reordenar desloca**.
4. `script/fig_section5.R:32` lê `diagnostics/output/t7_2_irf_estado.csv` — artefato de diagnóstico
   virou dependência de figura do paper.
5. `main_sdfm`, `run_benchmark`, `verdict_for`, `nw_hac_stata`, `wald_by_hand` são protegidos.
6. Nunca escrever em `output/irf/irf_coherence_leitura.md`.
7. O hook do git bloqueia `git checkout -- <path>`; artefatos re-gerados sem mudança de conteúdo
   entram no commit em vez de serem descartados.
