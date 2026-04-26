# Handoff — 2026-04-25
SESSLOG:[2026-04-25 19:20]

## Session Topic
Branch `feature/het-identified-instrument` complete. Heteroskedasticity-ID instrument `z_het_jk` + `yield_6m` reaches first-stage F=21.3 (vs 1.1 for original z_het + juros_selic). Three Blindspot validations pending before submission. Branch NOT committed.

## Active Decisions
- Recommended specification: `DEFAULT_VARIANT <- "z_het_jk"` + `mpind = which(colnames(X) == "yield_6m")`. Do NOT renormalize to juros_selic — maturity mismatch is the dominant source of attenuation.
- Wild bootstrap GK preserved (regime indicator exogenous, fixed across draws).
- Legacy GK variants (z_bruto, z_bruto_purif, z_jk, z_jk_purif) retained as benchmark — do not delete.
- Branch is on disk but uncommitted; user has not approved git commit.

## Key Files
- R/identification/het_shock_extraction.R
- script/instrument_het.R
- script/instrument_audit.R
- output/instrument_audit_report.md
- correspondence/referee2/2026-04-25_round1_report.md
- _instrucoes/Heteroscedasticidade.md

## Next Steps
- [ ] Placebo: shuffle z_het_jk; expect F≈1 → confirms grid F=21 is not data-snooping.
- [ ] Random-mask: random 42/97-day mask vs JK filter → separates "JK informative" from "sparsification helps".
- [ ] Sub-period stability: split 2013-19 / 2020-25; drop COVID 2020-03..2020-09.
- [ ] Compute cor(z_het_jk, z_jk_purif) monthly — convergence of het and timing-based identification.
- [ ] Decide on git commit + PR for the branch.

## Working Artifacts
- working-notes/2026-04-25_blindspot_het_instrument.md — full Blindspot 4-quadrant analysis with action checklist.

## Context
The branch implements identification by heteroskedasticity (Rigobon-Sack 2003) for the Brazilian DFM, replacing the failing Gertler-Karadi instrument (Copom announces after market close, invalidating the timing-window assumption). The three Blindspot must-do tests are independent of the implementation — they are statistical robustness checks on the F=21 finding.
