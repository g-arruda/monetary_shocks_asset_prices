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

**The paper was fully synchronized on 2026-08-25**, and has since fallen
behind twice. Abstract, §1--§5, conclusion and appendix use the 111-series
`(r,q,p)=(5,5,4)` production and describe **wild-bootstrap** bands for the DFM.
`tab:rq_sweep` no longer exists. The sign-filter subsections report only
exercises that hold the production mask fixed; the rederived-mask diagnostics
remain in the generated outputs and living record.

**Two gaps are open against production, and both close in the same editorial
round.** (i) the window moved to 2012-03--2025-12; (ii) **on 2026-09-08 the
DFM's operational inference became the Anderson--Rubin sets**, so §3.7, §4,
§5 and every figure caption that says *wild bootstrap* now describes an
inference the code no longer publishes. `sec:weak_iv` is the sharpest case:
its whole contrast was bootstrap-on-the-DFM against AR-on-the-VAR, and both
sides are AR now. Until that round runs, `script/fig_section5.R` and
`script/fig_weak_iv.R` abort without `--repaint-paper-figures`. Do not quote a
paper band as current inference; quote `output/irf/irf_coherence_h.csv`, whose
`set_type68`/`set_type90` columns say what kind of set each band is.

`arquivo/tex/main.tex` is the **previous** draft. It is a historical prose
source, **not a target to edit** and not evidence for current magnitudes.

## Generated vs hand-written — the distinction that already cost this project once

**These bodies are rewritten in full on every run. Never put prose in them:**
`output/irf/irf_coherence_report.md`, `output/irf/ar_bands.md`,
`output/var/svar_iv_weak_robust.md`, `output/factors/factor_stationarity.md`,
`output/assets/asset_representation.md`, `output/var/var_benchmark.md`.

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

## Maintaining `registro/pendencias.md`

- **New item** enters as `- [ ]` inside the matching theme A-E — never loose at the end of the
  file. If it fits none of the five, that's a new theme: create `F.`, `G.`, etc., don't force it
  into "Código e higiene" as a generic drawer.
- **Closed item** flips `[ ]` to `[x]` and **moves** — out of the section's top and into that
  theme's `### Fechados (contexto)` block, compressed to **2-4 lines**: what was done, the
  verdict, the 1-3 numbers that matter most, and the pointer (`Nota:`/`output/...`) for whoever
  wants the full detail. Never leave the long narrative in the open item's place.
- **A `⚠` caveat with no other record in the repo** cannot be cut during compression — it becomes
  one of the summary's lines, not a lost note.
- **Work that surfaces only while closing an item** ("this stays open: X") becomes its **own**
  `- [ ]` in the right theme — never a loose sentence inside the closed item. That pattern is what
  hid two items during the 2026-08 reorganization.
- **Dependency between items** is declared both ways — the blocker says what it unblocks, the
  dependent says what it depends on — and shows up in the `Índice de itens abertos` table.
- **Índice de itens abertos** updates on every open/close; it's the only place meant to give, at a
  glance, the full list of what's left.
- `Especificação corrente` and `Rota metodológica decidida` are living reference: **edit in
  place** when they change (instrument swap, r/q, etc.), never duplicate a new block next to the
  old one.

## Branch convention

**`main` is the always-reproducible state** — `CLAUDE.md`'s smoke test has to pass on any commit
of it.

- **One branch per methodological bet that could be rejected.** The heteroskedasticity route is
  the example: isolated, it would have been discarded whole instead of leaving residue spread
  across six scripts.
- **Writing goes straight to `main`**, in small commits: §5 for the tex, abstract, introduction,
  conclusion, literature review. It isn't an experiment, it can't "fail", and it only touches
  `paper/` (the old `tex/` has been archived under `arquivo/tex/` since 2026-08-02 and takes no
  more writes).
- **Hygiene and diagnostic re-runs go straight to `main`** too.

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
