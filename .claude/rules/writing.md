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

The canonical paper is `paper/paper.tex` (class `elsarticle`; `paper_anpec.tex` until 2026-09-30),
and every figure it includes lives in `paper/img/`. §3 Metodologia has four
subsections since 2026-09-17 — `Modelo e estimação`, `Base de dados`, `Identificação e construção
do instrumento`, `Relevância do instrumento e inferência`; §4 Resultados has eight subsections, one per figure;
§3.3 (`sec:identificacao`) opens, since 2026-09-26, with one narrative paragraph and no footnote on why the
paper does not use heteroskedasticity identification (since 2026-10-23 it carries the daily facts in full, 5% in the
three vertices, Holm only at 3 months and the kurtosis correction, and no longer closes on "adotar essa identificação
exigiria abandonar a representação fatorial", `2026-10-23_revisao_texto_enxuto`), and Anexo B carries one paragraph and one table (Anexo A is the variable list)
(`tab:het_frequency`, the three variance ratios beside the `Qr` summary since 2026-09-27, when
`tab:het_variance` was merged into it; `tab:het_sequencia` was cut on 2026-09-24; its monthly VAR
is the one under the Lenza-Primiceri rescale, typed from
`output/het/het_conditions.csv` and `het_variance_ratios.csv`). Since 2026-10-23 (branch
`feature/auditoria-janelas-copom`) the paragraph before the table describes the three panels, the daily
windows (DI Wednesday to Thursday, FX and CDS around the announcement or an 18h Wednesday release, the 7
holiday-Thursday meetings out), the Holm p and the factor row, and the caption only defines the columns
and the test, author decision (`2026-10-23_linha_diaria_anexo_b`), and its closing sentence on frequency and measured
object changing together was cut the same day (`2026-10-23_revisao_texto_enxuto`); §5 Robustez (`sec:robustez`) has,
since 2026-10-22 (branch `feature/auditoria-janelas-copom`), three subsections: 5.1 `Benchmark VAR`
(`sec:weak_iv`, the VAR benchmark unchanged), 5.2 `Placebos` (`sec:placebos`, two paragraphs since 2026-10-23: the AR test of
a zero response at h = 0, 1, 3, 6, 12, 24 with Holm over the 18 tests, read by significance level only, the
MSCI fall as a limitation, the VIX at h0 with its 46% overlap, the US EPU trend's p = 0,275 on the 111
meetings, and a one-sentence footnote saying Holm controls the 18 pointwise comparisons and does not test all horizons
of a series at once; since 2026-10-23 neither the text nor the `tab:placebos_holm` caption says the horizons were
fixed before seeing the results; Holm is named without `\cite`, author
decision, `2026-10-22_placebos_secao_5`) and 5.3 `Reuniões influentes e movimentos externos extremos`
(`sec:influencia`), whose `tab:influencia` gives ξ_mp, the FX and CDS impact and the horizons significant
at 90% for production, without the 5 and the 10 most influential meetings and without the 14 extreme
ones, typed from `output/meeting_influence/joint_strength.csv` and `joint_fx_cds.csv`; its prose reads the
table by sign and significance only, and the influence formula and the 81%/48% concentration sit in a
footnote, author decision (`2026-10-22_cds_janelas_influencia_extremos`);
`sec:het_frequency` (rebuilt on 2026-09-22 around the `svars` test) was deleted that day; the
five home-grown statistics may not come back; `sec:fomc` was deleted on 2026-09-21, and `sec:exogeneidade`,
`sec:invertibilidade` and `sec:confound` had already gone. Concluding remarks is §6.
Since 2026-10-23 (branch `feature/auditoria-janelas-copom`, the integrated version, `2026-10-23_versao_integrada`):
- the abstract (200 words), §1's third paragraph and §6's first paragraph carry the bridge without numbers;
  since the prose revision of the same day (`2026-10-23_revisao_texto_enxuto`) the item-5 reading, consistent
  with a risk-related transmission without identifying risk as the cause, is written once, at the end of
  §4.2's significance paragraph, author decision;
- the daily het facts are in full in §3.3's first paragraph and Anexo B; the abstract, §1 and §6 give the short
  version, with the vertex and the kurtosis correction, without attributing the divergence to frequency or
  identification;
- §1 describes the instrument in its two layers, without JK, and its two-sentence roadmap names §5 Robustez
  and §6;
- §4.5 ends with one paragraph on the PNAD unemployment rate and employed population, which `fig:atividade`
  does not draw;
- §6 has, after the paragraph on the other results, a five-sentence paragraph with the less favourable results
  (raw surprise, influence, Brent, placebos) that points to §5 and Anexo E; the caveats that qualify them live
  once in §5.2–5.3. "Sincronia" is gone from the paper.
Anexo C (`anexo-C`, since 2026-09-24) carries `fig:q_sensibilidade`, the `q = 2..5` figure that
§3.1's two-sentence defense of `q = r` points to, and since 2026-09-25 `fig:p_sensibilidade`
(`p = 2..6`), and since 2026-09-26 `fig:instrumento_camadas`, under the title "Sensibilidade das
respostas", and since 2026-09-30 (branch `feature/robustez-pandemia`) `fig:lp_sensibilidade`, which
a footnote on §3.1's OLS sentence points to, and `fig:precovid_sensibilidade`, which the last
sentence of §3.4's `tab:first_stage` paragraph points to; the text cites no number from any of
them, and the pre-COVID pointer claims nothing about the responses holding. Since 2026-09-30 every
Anexo C figure draws the same eight series (DI 6 meses, DI 2 anos, BRL/USD, CDS 5 anos, Focus PIB,
Focus IPCA 12 meses, Focus Selic, DBGG), the `PAPER_PANELS` block of each annex script, and the
captions no longer mention the IBC-Br. Anexo D (`anexo-D`, since 2026-09-25)
carries `tab:bs_ortogonalizacao`, in BS Table 3's layout since 2026-09-26, and since 2026-09-30
`fig:placebos` after it, whose caption calls the sets pointwise by horizon, and since 2026-10-22
`tab:placebos_holm` (series, h, p and Holm's p, typed from `output/placebo_holm/table.csv`); §3.3 ends
with the orthogonalization paragraph pointing to `tab:bs_ortogonalizacao`, and since 2026-10-22 the
placebos are read in §5.2, not in §3.3.
Anexo E (`anexo-E`, since 2026-10-20, branch `feature/auditoria-janelas-copom`), "Trajetória diária e
forma reduzida mensal", is the bridge of the e-mail of 2026-10-19 (item 2): since 2026-10-23 two opening paragraphs, one per
float (transformation, window, normalization, sample, levels, why 110 and not 111 meetings), then `fig:ponte`
and `tab:ponte`, and since 2026-10-22 a closing paragraph that reads both floats (item 1 of the e-mail) by
sign and significance level, with no number, author decision; since the same day it also says, with no
number, that the DFM under the raw surprise is significant at 90% and not at 95% in the announcement month,
and since 2026-10-23 it ends with the one sentence on the 104-meeting sensitivity. §4.2's significance
paragraph ends with the sentence that points to them and the one carrying item 5 (consistent with a
risk-related transmission, without identifying that risk causes the depreciation), its only place in the paper.
By author decision of 2026-10-20 both
floats carry **90% and 95%**, not 80/90%: the figure's intervals are Wald per +50bp of surprise, and the
table puts the monthly reduced form, as an IV per +50bp of the end-of-month 6-month DI, beside the DFM,
both as Anderson--Rubin sets, in three blocks (panel series, the alternative aggregation, DFM). Outside
Anexo E, 95% appears only as a significance level read in §5.2 (the MSCI) and in §6's paragraph of less
favourable results. Anexo F (`anexo-F`, since 2026-10-21, same branch), "Convenções
temporais e fontes", is item 4 of the same e-mail: since 2026-10-23 five paragraphs (the announcement and the
30-minute rule, the DI, the Yahoo rate, the CDS series with its US holidays, the narrow-against-widened window)
and `tab:horarios`, with the sources as URLs in three footnotes,
since the 25-key budget is full; one footnote in §3.3, on "O Copom anuncia a decisão depois do fechamento
do mercado", points to it. By author decision of 2026-10-21 the Yahoo and CDS times are written as fact,
without "hipótese", though neither provider documents them (`2026-10-21_convencoes_temporais_feriados_cds`).
Since 2026-10-22 the CDS text also carries the narrow-against-widened window comparison, as a
sensitivity to time alignment, with Wald 90% intervals per +50bp of orthogonalized surprise on the 111 and
the 104 meetings (no 95%), and one sentence on the 156 US holidays with a quote and the whole-number quote
of 2013-11-28 (`2026-10-22_cds_janelas_influencia_extremos`).
The preamble's `\usepackage[hyphens]{url}` and `\Urlmuskip` exist for those footnotes. Captions and `\autoref` should print "Figura/Tabela", but ⚠ `paper.tex` prints "Figure/Table": the
`\renewcommand`s of `bd3a52c` stayed in `paper_anpec.tex` (`2026-10-22_conferir_e_trajetoria_diaria`). The body never puts a
reference in parentheses: it goes inside the sentence or not at all.
`script/fig_section5.R` writes §4's eight figures and `fig_placebos.pdf`, none with significance markers
since 2026-10-22, `script/fig_weak_iv.R` writes
the weak-IV figure, `script/q_sensitivity.R --window=cheia` writes `fig_q_sensibilidade.pdf`,
`script/p_sensitivity.R` writes `fig_p_sensibilidade.pdf`, `script/instrument_layers_irf.R`
writes `fig_instrumento_camadas.pdf` and `script/pandemic_sensitivity.R` writes
`fig_lp_sensibilidade.pdf` and `fig_precovid_sensibilidade.pdf`, and `script/fig_bridge.R` writes
`fig_ponte.pdf`; the Anexo D table's numbers are typed from `output/instrument/bs_orthogonalization.csv`,
and `tab:ponte`'s from `output/monthly_reduced_form/comparison.csv` (production base, orthogonalized
surprise).

**The paper is on the production vintage again since 2026-09-24.** It was fully
synchronized on 2026-08-25 and then fell behind twice, in (i) the window, which
moved to 2012-03--2025-12, and (ii) the operational inference, which became the
Anderson--Rubin sets on **2026-09-08**. §3 caught up on 2026-09-17
(`2026-09-17_reorganizacao_secao_3`), §5 on 2026-09-21, and its het subsection
on 2026-09-22 before moving to §3.3 as one paragraph on 2026-09-24. §4, its eight
figures and captions, and the numbers and dates in the abstract, §1 and the
conclusion caught up on 2026-09-24 (`2026-09-24_migracao_secao_4`). *Wild
bootstrap* is now uncited in the body, captions included.
**Since 2026-09-26 the whole `.tex` follows the current production**
(`2026-09-26_migracao_paper_bs_purif`, migrated on `feature/bs-copom-surpresas-macro` and
fast-forwarded into `main` the same day): `z_bs_purif`, AR sets at 80/90% in every
caption and in §3.4, and **no JK sign filter in the instrument**: since 2026-09-30 (branch
`feature/robustez-pandemia`) the filter appears only in one §3.4 footnote on why it is out, and §2
cites JK as literature. The abstracts and §1 describe the instrument without it. §3.3 has two layers,
`tab:first_stage` two rows, `tab:bs_ortogonalizacao` one DI column (coefficient and SE) over the
111 meetings since 2026-10-21 (102 before), and `fig:instrumento_camadas` only production and the raw
surprise. Since 2026-10-21 (branch `feature/auditoria-janelas-copom`) §3.3 carries two footnotes on the
sample, the 7 Wednesday-to-Friday windows and the 104-meeting sensitivity with z = 0 in the moments, and
§3.4 has three paragraphs, relevance, strength (with ξ_mp's equation in a footnote) and the boundedness of
the sets; the 10 stays uncited (`2026-10-21_artigo_base_111`). The 22 sentences whose claim flipped on the
111 base were rewritten in place on 2026-10-22, by author decision, and no `[conferir]` marker is left
(`2026-10-22_conferir_e_trajetoria_diaria`).
`tab:rq_sweep` no longer exists.

§4's prose reports **points**, by author decision of 2026-09-24. It cites the
Anderson--Rubin sets only where the earlier text cited bands, under the two-tier
rule. Its numbers come from `irf_coherence_cell.rds` at the figures' scales
(`irf_panel()` in `script/fig_section5.R`), and its horizons stop at 36, as §3.1
says. Since 2026-09-27 the level series (tcode 1) keep their own units in every figure and
sentence — FX in R$ per unit of currency, activity indices in index points — and nothing is
divided by the sample mean (`2026-09-27_unidades_nativas`). A comparison of magnitudes across
series must be re-checked in those units, because the ordering does not survive the change of scale. When a paper number and the cache disagree, the cache is right. Quote
`output/irf/irf_coherence_h.csv` for inference; its `set_type80`/`set_type90` columns (the
lower level is 80% since 2026-09-26, 68% before) say what kind of set each band is.

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

**Each fact and each caveat is written in full once** (author decision of 2026-10-23,
`2026-10-23_revisao_texto_enxuto`), in its own section of the body or annexes. The
abstract, the introduction and the conclusion may repeat it in short form to hold
the reader, and the abstract and conclusion are written to sell the result. A
caveat the advisor asked for stays, once, compressed.

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

`registro/pendencias.md` holds only what is open; `registro/fechados.md` holds the closed items;
`registro/historico_decisoes.md` holds negative results and reversed decisions. Keep that split — a
closed item moves, it does not get duplicated.

## Maintaining `registro/pendencias.md`

It is read at the start of a session, so every line costs. It carries **no** production spec (that is
`CLAUDE.md` and `validate_production_spec.R`), **no** changelog of its own reorganizations (that is the
commit message), **no** preamble narrating an e-mail or a plan once its items are closed, and **no**
number or advisor wording copied from a note or an e-mail — the item points to them.

- **New item** enters as `- [ ]` inside the matching theme — never loose at the end of the file. If
  it fits none, open a new theme rather than forcing it into a generic drawer. A theme with no open
  item leaves the file.
- **An open item says only**: what to do, the source (`e-mail de DD-MM, item N` or the note), what
  it depends on and unblocks, the author decision it waits on, and any `⚠` recorded nowhere else.
  Three to six lines; history of which e-mail reinforced it does not stay.
- **Closed item** flips `[ ]` to `[x]` and **moves** out of `pendencias.md` to the top of its theme
  in `registro/fechados.md`, compressed to **2-4 lines**: what was done, the verdict, the 1-3
  numbers that matter most, and the pointer (`Nota:`/`output/...`) for whoever wants the full
  detail. `fechados.md` is not read at session start.
- **A `⚠` caveat with no other record in the repo** cannot be cut during compression — it becomes
  one of the summary's lines, not a lost note.
- **Work that surfaces only while closing an item** ("this stays open: X") becomes its **own**
  `- [ ]` in the right theme — never a loose sentence inside the closed item. That pattern is what
  hid two items during the 2026-08 reorganization.
- **Dependency between items** is declared both ways — the blocker says what it unblocks, the
  dependent says what it depends on — and shows up in the `Índice` table.
- **Índice** updates on every open/close; its table is the only place meant to give, at a glance,
  the full list of what's left, in execution order, with the pending author decisions.

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
- **Exception: a whole-version rewrite stays on its branch until it is done.** When the paper's
  numbers, figures and text all change together for a new version, the writing and the re-runs stay
  on the branch that carries the new base, and that branch is fast-forwarded into `main` once, as the
  last step. Until then `main` keeps the previous version, coherent (paper, figures and outputs on
  one base), and takes no commits, so the promotion stays a fast-forward. Case in point
  (2026-10-20): the 111-meeting base and the integrated version due 2026-10-28, on
  `feature/auditoria-janelas-copom` (`registro/pendencias.md`, last step).

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

## Significance wording

Never write "exclui zero a X%", "o conjunto exclui zero", "excludes zero" or any variant, in the paper,
in notes, in reports or in chat summaries. Say **"significante a X%"** or **"não é significante a X%"**
(e.g. "o efeito é significante a 90%", "não é significante a 80%"). The operational test is still that
the Anderson–Rubin set excludes zero (`ar_excludes_zero()`, see `CLAUDE.md`); that rule stays in code
and in the record's method sections, but prose that reports a result uses the wording above.

## Language

Portuguese for prose in `registro/`, `notas/`, `pareceres/` and `output/*.md`. English for code,
identifiers and `CLAUDE.md`.
