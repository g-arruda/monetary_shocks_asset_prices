# Handoff — 2026-08-10 (Baterias de confound enxugadas; máscara re-derivada fecha o "por completo")
SESSLOG:[2026-08-10 20:30]
<!-- written by: pop-os at 2026-08-10T20:30:30-03:00 -->
*Project: monetary_shocks_asset_prices*

## Session Topic
Cortados três testes das duas baterias de confound (B e D do soberano, 4 do FOMC), fechada a
objeção do council contra o Teste C com a máscara re-derivada, §5.2 reescrita, e removido todo
vestígio dos números dos testes retirados de docs vivos e notas datadas.

## Active Decisions
- Os números dos testes B, D e 4 **não são reproduzíveis e não devem ser citados**. Git é o único registro. Razão em `_instrucoes/historico_decisoes.md` §2.4.
- `z_jk_bs_norisk_mask` (máscara re-derivada) tem ξ_mp 5,57 full: conjunto AR limitado mas abaixo de 10, então sustenta **direção, não intervalo**. `denom_vs_prod` 0,726 — parte das magnitudes maiores é aritmética.
- O ganho de `asset_ibov` (sig90 negativo naquela variante) **não pode** ser usado para consertar o bloco nulo de §4.6.
- Nada em produção foi modificado; `instrumentos_mensais.csv` e `DEFAULT_VARIANT` intocados.

## Key Files
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/script/jk_sovereign_confound.R
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/script/fomc_coincidence.R
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/texto_anpec/paper_anpec.tex (§5.2, `sec:confound`)
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/_instrucoes/historico_decisoes.md (§2.4)
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/output/instrument/jk_sovereign_confound.md

## Next Steps
- [ ] Escrever §5.3 do FOMC sobre os testes 0-3, com a ressalva de horário obrigatória (vale para a perna de taxa, não para a de ações).
- [ ] Decidir se os números removidos saem também de `relatorio/council_2026-07-31.md` e `council_2026-08-10.md` (não editados: são pareceres recebidos).
- [ ] Decidir a forma final do degrau da máscara em §5.2 para a v1 (com magnitudes, sem magnitudes, ou fora).
- [ ] Corrigir a descrição do placebo `sp500_vix` em `:501`/`:509` do paper — é só o VIX.

## Working Artifacts
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/progress_logs/2026-08-10_mascara-re-derivada-decisao-v1.md — o achado inconveniente, por que só apareceu agora, e a recomendação para a v1

## Context
Os cortes foram verificados como não-perturbativos (`max |dif| = 0` em toda linha sobrevivente,
`p_boot` inclusive) e o veredito do FOMC segue "não detectado". O paper compila em 27 páginas.
