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

The canonical paper is `paper/paper_anpec.tex` (class `elsarticle`). §3 Metodologia has four
subsections since 2026-09-17 — `Modelo e estimação`, `Base de dados`, `Identificação e construção
do instrumento`, `Relevância do instrumento e inferência`; §4 Resultados has eight subsections, one per figure;
§3.3 (`sec:identificacao`) carries, since 2026-09-24, one paragraph and one footnote on why the
paper does not use heteroskedasticity identification, and Anexo B carries its two tables (Anexo A is the variable list)
(`tab:het_variance`, `tab:het_frequency`; `tab:het_sequencia` was cut the same day); §5 Robustez has **no**
subsection, only the VAR benchmark, labelled both `sec:robustez` and `sec:weak_iv`;
`sec:het_frequency` (rebuilt on 2026-09-22 around the `svars` test) was deleted that day; the
five home-grown statistics may not come back; `sec:fomc` was deleted on 2026-09-21, and `sec:exogeneidade`,
`sec:invertibilidade` and `sec:confound` had already gone. Concluding remarks is §6.
Anexo C (`anexo-C`, since 2026-09-24) carries `fig:q_sensibilidade`, the `q = 2..5` figure that
§3.1's two-sentence defense of `q = r` points to, and since 2026-09-25 `fig:p_sensibilidade`
(`p = 2..6`); the text cites no number from either. Anexo D (`anexo-D`, since 2026-09-25) carries
`tab:bs_ortogonalizacao` (the Bauer-Swanson Table 3 analogue) and `fig:instrumento_camadas`; no
body sentence points to it, by author decision.
`script/fig_section5.R` writes §4's eight figures, `script/fig_weak_iv.R` writes
the weak-IV figure, `script/q_sensitivity.R --window=cheia` writes `fig_q_sensibilidade.pdf`,
`script/p_sensitivity.R` writes `fig_p_sensibilidade.pdf` and `script/instrument_layers_irf.R`
writes `fig_instrumento_camadas.pdf`; the table's numbers are typed from
`output/instrument/bs_orthogonalization.csv`.

**The paper is on the production vintage again since 2026-09-24.** It was fully
synchronized on 2026-08-25 and then fell behind twice, in (i) the window, which
moved to 2012-03--2025-12, and (ii) the operational inference, which became the
Anderson--Rubin sets on **2026-09-08**. §3 caught up on 2026-09-17
(`2026-09-17_reorganizacao_secao_3`), §5 on 2026-09-21, and its het subsection
on 2026-09-22 before moving to §3.3 as one paragraph on 2026-09-24. §4, its eight
figures and captions, and the numbers and dates in the abstract, §1 and the
conclusion caught up on 2026-09-24 (`2026-09-24_migracao_secao_4`). *Wild
bootstrap* is now uncited in the body, captions included.
`tab:rq_sweep` no longer exists. The sign-filter subsections report only
exercises that hold the production mask fixed; the rederived-mask diagnostics
remain in the generated outputs and living record.

§4's prose reports **points**, by author decision of 2026-09-24. It cites the
Anderson--Rubin sets only where the earlier text cited bands, under the two-tier
rule. Its numbers come from `irf_coherence_cell.rds` at the figures' scales
(`irf_panel()` in `script/fig_section5.R`), and its horizons stop at 36, as §3.1
says. When a paper number and the cache disagree, the cache is right. Quote
`output/irf/irf_coherence_h.csv` for inference; its `set_type68`/`set_type90`
columns say what kind of set each band is.

**Engineering a reader of the field would deduce gets no comment at all, and an
extension of a published method gets no appendix.** The 2026-09-16 decision on
the AR-to-DFM mapping was narrowed by the author on **2026-09-17**. The test is
now whether a reader who knows DFM impulse responses would picture the step
unaided. If yes, it gets neither body prose nor footnote: the `c_j' = sy_j·Λ_j'`
swap, the footnote putting MOSW's equation beside the DFM's, and the footnote
mapping Lenza-Primiceri's `y_t` to `F_t` were all cut on that basis. If no, the
body carries the mapped equation in the paper's own notation, and a footnote may
put the authors' equation beside it. A self-contained appendix is for what is
genuinely new.

**The prose reports, it does not defend.** Same decision. A sentence whose work
is to justify a design choice against an objection nobody raised comes out, even
when the justification is correct. Caveats are not written around a result to
pre-empt a referee. The replication test governs what stays: keep what a reader
needs to re-run the estimator, cut what only argues it was the right one.

`arquivo/tex/main.tex` is the **previous** draft. It is a historical prose
source, **not a target to edit** and not evidence for current magnitudes.

## Generated vs hand-written — the distinction that already cost this project once

**These bodies are rewritten in full on every run. Never put prose in them:**
`output/irf/irf_coherence_report.md`, `output/irf/ar_bands.md`,
`output/var/svar_iv_weak_robust.md`, `output/factors/factor_stationarity.md`,
`output/assets/asset_representation.md`, `output/var/var_benchmark.md`. Several of their
generators are archived or no longer write them (`irf_coherence_report.md` since 2026-09-18,
`svar_iv_weak_robust.md` since 2026-09-21, `output/het/het_conditions.md` and
`het_rigobon/output/0{1,2,3}_*.md` since 2026-09-24, when their scripts lost the md reports and
the numbers moved to the CSVs beside them); the files stay as cited records and still take no
prose. `svar_iv_weak_robust.md` is frozen at the 2012-03--2025-12 `p=4` vintage of the three
CSVs beside it, which are `script/model_var.R`'s only outputs now.

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
