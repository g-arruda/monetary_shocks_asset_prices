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
subsections; §5 Robustez includes `sec:exogeneidade`, `sec:invertibilidade`, `sec:weak_iv`,
`sec:confound` and `sec:fomc`; concluding remarks is §6. `script/fig_section5.R` writes the
general robustness figures, while `script/fig_weak_iv.R` writes the weak-IV figure.

**The paper was fully synchronized on 2026-08-25.** Abstract, §1--§5,
conclusion and appendix use the 111-series `(r,q,p)=(5,5,4)` production.
`tab:rq_sweep` no longer exists. Anderson--Rubin is reported only for the
observable VAR in `sec:weak_iv`, never as inference for the DFM. Its current
source is `notas/2026-08-22_var_niveis_aic_tendencia.md`. The sign-filter
subsections report only exercises that hold the production mask fixed; the
rederived-mask diagnostics remain in the generated outputs and living record.

`arquivo/tex/main.tex` is the **previous** draft. It is a historical prose
source, **not a target to edit** and not evidence for current magnitudes.

## Generated vs hand-written — the distinction that already cost this project once

**These bodies are rewritten in full on every run. Never put prose in them:**
`output/irf/irf_coherence_report.md`, `output/var/svar_iv_weak_robust.md`,
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
