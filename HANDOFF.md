# Handoff — 2026-07-13
SESSLOG:[2026-07-13 12:26]
<!-- written by: pop-os at 2026-07-13T12:26:10-0300 -->
*Project: Monetary Shocks Asset Prices*

## Session Topic
Mapeado tex/main.tex vs estado atual; nova estrutura de Metodologia/Resultados/Apêndices escrita em `relatorio/estrutura_paper_v2.md`.

## Active Decisions
- `relatorio/estrutura_paper_v2.md` é a fonte única para o rewrite do tex — seguir seção a seção.
- Metodologia: +§3.3 IV externo (mata Cholesky), +§3.4 instrumento em camadas (z_jk_purif primário), +§3.6 três Fs (factor-space governa weak-IV).
- Resultados: espelhar `output/irf/irf_section.md`; ex1 primário; figuras dos blocos lisos, sem suavização; §5.7 findings → Intro/Conclusão.
- Apêndices A–E com mapa artefato→seção; itens "não enterrar" dos blindspots posicionados (drop-COVID F>full; het⊂timing; heterogeneidade pre/post; R↔Python 6 decimais).

## Key Files
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/relatorio/estrutura_paper_v2.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/tex/main.tex
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/output/irf/irf_section.md

## Next Steps
- [ ] Reescrever tex (Metodologia → Resultados → Apêndices) seguindo estrutura_paper_v2.md.
- [ ] Rewrite abstract/intro/conclusão — abstract tem câmbio com sinal INVERTIDO (era Cholesky).
- [ ] Literatura: acrescentar eixo de identificação (SW18/GK15/JK20/BS23/RS03/MR13/GRG25).
- [ ] Pré-submissão: Anderson-Rubin bands (se het promovido); placebo commodity_metal.

## Context
Nada precisa ser re-estimado: todos os artefatos existem em output/. O tex atual usa Cholesky/r=7/q=4/VAR(1)/71 vars — duas gerações atrás da produção (z_jk_purif, r=6/q=5, p=6, 111 séries, 2013–2025-09).
