# Abandono das duas identificações alternativas — registro de execução

*2026-08-17. Log de sessão, descartável. O que é durável está nos dois READMEs de
`arquivo/` e em `registro/historico_decisoes.md` §0 e §1.*

Commits: `39461bd` (moves) → `c317009` (cirurgia) → `2881e13` (docs).

## Inventário do que saiu

11 arquivos `.R` (4.336 linhas), 27 artefatos de `output/`, 3 notas — todos por
`git mv`, então o histórico segue os arquivos (49 renomeações com 0 inserções).

| destino | R/identification/ | script/ | output/ | notas/ |
|---|---|---|---|---|
| `arquivo/heterocedasticidade/` | `het_primary.R`, `het_tests.R`, `het_shock_extraction.R` | `het_robustness.R` + 5 já soltos em `arquivo/script/` | `het/` (10) | 1 |
| `arquivo/nao_gaussiana/` | `nongaussian_{gmr,branch,labelling}.R` | `model_nongaussian.R`, `nongaussian_{gate,corroboration,labelling}.R`, `validate_gmr_ica.R` | `nongaussian/` (17) | 2 |

`script/` foi de 39 para 33 `.R`. `R/identification/` ficou com 5 arquivos.

## Grafo de dependências (o que tornou a limpeza barata)

Verificado antes de mover: `run_all.R` **não tem estágio** het nem nongaussian, e
nenhum script fora dos dois clusters lê `output/het/` ou `output/nongaussian/`.
Só três pontos de acoplamento no código vivo:

1. `script/model_alessi.R:17` — `source("R/identification/nongaussian_branch.R")`
2. `R/modeling/dfm_pipeline.R` — switch de 3 vias + `het_weight` + `ng_*`
3. `R/modeling/impulse_response.R` — ~30 hits: switch, guards, ramos de ponto,
   bloco de bootstrap, blocos de saída `het_point`/`het_boot`/`ng_point`/`ng_boot`

## Por que o parâmetro `identification` ficou

Seis chamadores vivos passam `identification = "proxy"` **explicitamente**:

- `script/validate_production_spec.R:119`
- `diagnostics/rq_dimension_audit/scripts/estimate_candidate_points.R:85`
- `diagnostics/rq_dimension_audit/scripts/estimate_candidate_bootstrap.R:73`
- `diagnostics/rq_block_dimension_audit/scripts/01_estimate_full_grid.R:123`
- `diagnostics/rq_block_dimension_audit/scripts/02_select_panels_and_dimensions.R:186`
- `diagnostics/rq_block_dimension_audit/scripts/03_bootstrap_finalist.R:92`

Remover o argumento quebraria os seis; cinco estão sob `diagnostics/`, que é
read-only por convenção de fronteira. Estreitar o domínio para `"proxy"` via
`match.arg` não quebra nenhum e elimina o código morto.

## Preservação do RNG no bootstrap

A estrutura antiga era `if (nongaussian) {sample.int(...)} else {rr <- runif(...)}`.
Removendo o `if` e mantendo só o `else`, a ordem de consumo do RNG no caminho
proxy fica idêntica — então **as bandas não se movem**, não só o ponto.

## Verificações

| checagem | resultado |
|---|---|
| smoke test **antes** da cirurgia | reproduz (baseline confirmado) |
| smoke test **depois** | **bit-a-bit idêntico** aos 5 valores de `CLAUDE.md` |
| `output/irf/irf_coherence_h.csv` re-gerado | **byte-idêntico** ao HEAD (`git diff` vazio) |
| `validate_production_spec.R` | `Production specification validation passed.` |
| `run_all.R --list` | 9 estágios, todos `[ok]` |
| `parse()` dos 3 arquivos tocados | OK |
| `latexmk paper_anpec.tex` | 28 pp, limpo, **sem nenhuma edição no `.tex`** |

`output/irf/irf_coherence_plots.pdf` foi revertido: mesmo byte count, só o
`CreationDate` embutido mudava.

## As três distinções que quase viraram estrago

Um grep cego por "heterocedast" ou "gaussian" teria removido produção:

1. **Inferência robusta a heterocedasticidade é produção** — wild bootstrap
   Gonçalves-Kilian (2004), HAC/NW do primeiro estágio, `F^rob`.
   `registro/metodo.md:410` e `relatorio/checklist_...:813` são disso.
2. **`goncalves2025` (IMF WP/25/48) é literatura** — `paper_anpec.tex:156,209,589`.
   Evidência alheia com que o paper dialoga. Por isso o `.tex` não foi tocado.
3. **`R/identification/validation_tests.R` fica** — a suíte T1-T8 foi escrita para
   `z_het_jk`, mas as funções são agnósticas ao instrumento.

## Convenções respeitadas

- `notas/` e `pareceres/` seguem verbatim; onde um caminho se moveu, entrou
  **nota de leitura** no topo (`2026-08-01_tier_list_robustez.md`) em vez de
  reescrita do corpo.
- `diagnostics/diagnostico_dfm.md` (l. 188, 875 citam o ramo GMR) **não foi
  modificado** — `diagnostics/` audita e não é editado.
- Nenhum arquivo novo em `notas/`.
