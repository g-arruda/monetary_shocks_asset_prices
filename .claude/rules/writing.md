---
paths:
  - "texto_anpec/**"
  - "relatorio/**"
  - "_instrucoes/**"
  - "output/**/*.md"
  - "arquivo/**"
---

# Writing prose and reading the record

The canonical paper is `texto_anpec/paper_anpec.tex` (class `elsarticle`). §4 Resultados has six
subsections; §5 Robustez currently has `sec:exogeneidade` and `sec:confound`; concluding remarks is
§6. `script/fig_section5.R` writes all 8 figures directly into `texto_anpec/` as bare filenames.

`arquivo/tex/main.tex` is the **previous** draft, kept because its §4/§5 are the fullest write-up of
the production run that exists — **Limitações and `sec:estado` still exist only there** (open item).
It is a prose source to draw from, **not a target to edit**.

## Generated vs hand-written — the distinction that already cost this project once

**These bodies are rewritten in full on every run. Never put prose in them:**
`output/irf/irf_coherence_report.md`, `output/irf/ar_bands.md`, `output/het/het_robustness.md`,
`output/factors/factor_stationarity.md`, `output/assets/asset_representation.md`,
`output/var/var_benchmark.md`.

Their hand-written counterpart is **`output/irf/irf_coherence_leitura.md`, which no script may
touch** — a previous one was silently destroyed by a re-run of the check, which is why the split
exists. `output/irf/irf_section.md` is the full reading of the production run and carries a banner
pointing at the current canonical paper.

## Vintage

**Working notes carry banners — check before reusing any number.** `relatorio/working-notes/
_indice.md` gives each note a verdict (CURRENT / superseded / contradicted) and the vintage it was
written under. The **2026-07-24 refresh** (106 series) moved magnitudes across the whole panel, and
the same-date B3 tcode correction moved the asset block; anything written before it is out of scale.

`_instrucoes/pendencias.md` holds only what is open; `_instrucoes/historico_decisoes.md` holds
negative results and reversed decisions. Keep that split — a closed item moves, it does not get
duplicated.

## Language

Portuguese for prose in `_instrucoes/`, `relatorio/` and `output/*.md`. English for code, identifiers
and `CLAUDE.md`.
