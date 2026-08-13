# Handoff, 2026-08-13 (rodada mensal e relevância MOSW commitadas)
SESSLOG:[2026-08-13 01:04]
<!-- written by: pop-os at 2026-08-13T01:04:40-03:00 -->
*Project: monetary_shocks_asset_prices*

## Session topic
Reconstrução após correção de fechamento mensal e migração dos diagnósticos para ξ_mp/F_rob,mp.

## Active decisions
- Produção preservada em (r,q)=(7,6); (7,7) é apenas candidato de robustez.
- A inferência operacional é o wild bootstrap; Anderson--Rubin plug-in foi retirado.
- Relevância ativa: ξ_mp e F_rob,mp na direção de `yield_6m`.

## Key files
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/R/modeling/impulse_responde.R
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/R/identification/factor_space_diagnostics.R
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/paper/paper_anpec.tex
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/registro/pendencias.md

## Next steps
- [ ] Rodar (7,7) com 800 réplicas somente se a escolha de dimensão for formalmente reaberta.
- [ ] Resolver as pendências editoriais em `registro/pendencias.md` antes de nova submissão.

## Context
Commits: `cf109f1` (rodada de pesquisa) e `a8e8e47` (regras e handoff). Worktree limpo; produção (7,6): ξ_mp/F_rob,mp = 7,65/7,95 full e 11,53/6,26 pré-COVID.
