---
paths:
  - "diagnostics/**"
---

# Diagnostics round (2026-07-28 DFM-IV audit)

**Frozen since 2026-09-18.** The wild bootstrap and the Kilian correction left `R/`, and scripts
`01`-`05` and both `rq_*` audits still pass `apply_kilian`, `nboot` or `bootstrap_seed`, or read
`companion_corrected`, so they no longer run against the current `R/`. They stay unedited as the
record of what ran (author decision); the `R/` they ran against is `main` at `07b1cbd`.

Seven scripts (`0{1..7}_*.R`) share `_common.R`, which loads the production spec, the panel, the
instrument variants and the cached `irf_coherence_cell.rds` as globals. **A diagnostic script never
re-estimates unless it has to, and nothing here modifies estimation code or production outputs.**
Tables land in `diagnostics/output/` as `t<task>_<item>_*.csv`; the deliverable is
`diagnostics/diagnostico_dfm.md` and `00_pipeline_map.md` traces raw data → plot. Per-script catalog
in `diagnostics/README.md`.

## Two reusable methodological findings from that round

- **`sandwich::NeweyWest` on a second-stage `lm` silently uses the wrong meat for IV** — `estfun.lm`
  scores on `y − X̂b`, not `y − Xb`. `07_dominancia_fiscal.R` hand-rolls the analytic IV sandwich
  with a `stopifnot()` self-test against `sandwich::lrvar`. Reuse that, do not reach for
  `NeweyWest` on an IV second stage.
- **The asymptotic χ² over-rejects by 2.3×-5.3× on this sample** — subsample comparisons need a wild
  block bootstrap under H0, not the asymptotic critical value.

## Scope

Tasks 0-7 are covered. Task 8 (r,q sensitivity) was never requested. Task 6.3 (real-rate/NTN-B
series) is **declared non-executable** — the `rb3` cache lacks `b3-reference-rates` and the
`breakeven_*` columns in `raw_data.csv` are 100% NA. The Anderson-Rubin inversion, still open when
that round was written, was done on 2026-08-10.
