---
paths:
  - "paper/**"
  - "slides/**"
  - "notas/**"
  - "pareceres/**"
  - "registro/**"
  - "output/**/*.md"
  - "arquivo/**"
---

# Writing prose and reading the record

The canonical paper is `paper/paper_anpec.tex` (class `elsarticle`). §4 Resultados has six
subsections; §5 Robustez has `sec:exogeneidade`, `sec:confound` and `sec:fomc`; concluding remarks is
§6. `script/fig_section5.R` writes all 8 figures directly into `paper/` as bare filenames.

**The paper is split across two vintages since 2026-08-14, and that is the single most important
thing to know before editing it.** §3, §5 and `tab:lista_variaveis` were migrated to the 111-series
`(5,5)` production. §1, §2, §4 and the conclusion were **not**, by explicit scope decision, and still
carry 106 séries, `(7,6)`, ξ_mp 7,65, 5,55%, 32,0/43,4/117,0 pb and the CDI. Do not treat a number in
the untouched half as evidence that the migrated half is wrong, and do not fix one section of the
untouched half in isolation without reading the checklist in `registro/pendencias.md` Tema A.
`tab:rq_sweep` no longer exists, and Anderson-Rubin is no longer mentioned anywhere in the paper.

`arquivo/tex/main.tex` is the **previous** draft, kept because its §4/§5 are the fullest write-up of
the production run that exists — **Limitações and `sec:estado` still exist only there** (open item).
It is a prose source to draw from, **not a target to edit**.

## Generated vs hand-written — the distinction that already cost this project once

**These bodies are rewritten in full on every run. Never put prose in them:**
`output/irf/irf_coherence_report.md`, `output/irf/ar_bands.md`,
`output/factors/factor_stationarity.md`, `output/assets/asset_representation.md`,
`output/var/var_benchmark.md`.

Their hand-written counterpart is **`output/irf/irf_coherence_leitura.md`, which no script may
touch** — a previous one was silently destroyed by a re-run of the check, which is why the split
exists. `output/irf/irf_section.md` is the full reading of the production run and carries a banner
pointing at the current canonical paper.

## Vintage

**Notes carry banners — check before reusing any number.** `notas/_indice.md` gives each note a
verdict (CURRENT / superseded / contradicted) and the vintage it was written under. The
**2026-07-24 refresh** (106 series) moved magnitudes across the whole panel, and the same-date B3
tcode correction moved the asset block; anything written before it is out of scale.

`registro/pendencias.md` holds only what is open; `registro/historico_decisoes.md` holds
negative results and reversed decisions. Keep that split — a closed item moves, it does not get
duplicated.

## Where a document belongs

`notas/` is permanent, append-only and citable — one dated note per round. `pareceres/` is what
outside reviewers *sent in*; it is kept verbatim and is not a place to record project findings.
`progress_logs/` is session continuity and is disposable. Never write a session log into `notas/`,
and never leave a durable result in `progress_logs/`.

**Verbatim means verbatim, paths included.** A review body often asserts what it *checked* — "file
absent", "grep returns nothing", a line number. Rewriting a path inside it turns a dated
verification into a claim nobody made. When the tree moves under a parecer, add a **nota de leitura**
blockquote at the top with the rename map (and any file whose existence flipped), and leave the body
alone. `pareceres/council_2026-08-10.md` and `2026-07-15_auditoria_fidelidade_instrumento.md` carry
the pattern. Project-authored status banners pasted above a received review are yours and *do* get
updated — `council_2026-07-31.md` shows both halves in one file.

Machine logs with a timestamped directory name — `paper/bibcheck_<stamp>/` — follow the same rule:
they record what a tool actually grepped that day and are not repointed.

## Language

Portuguese for prose in `registro/`, `notas/`, `pareceres/` and `output/*.md`. English for code,
identifiers and `CLAUDE.md`.
