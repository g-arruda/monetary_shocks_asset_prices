# Handoff — 2026-08-01 (organização de script/, diagnostics/ e novo README de navegação)
SESSLOG:[2026-08-01 17:05]
<!-- written by: pop-os at 2026-08-01T17:05:00 -->
*Project: monetary_shocks_asset_prices*

## Session Topic
Reorganizar `_instrucoes/pendencias.md` por tema (Temas A-E), organizar `script/` e `diagnostics/`, e criar um índice de navegação do projeto inteiro.

## Active Decisions
- `pendencias.md` reescrito em 5 temas (A-E), abertos no topo + `### Fechados (contexto)` comprimido, nova seção "Convenção de manutenção deste arquivo" (exigida pelo autor) e "Índice de itens abertos". 1195 → 823 linhas, verificado sem perda de ressalva `⚠`.
- `script/` (30→25 ativos): reorg **leve** escolhida pelo autor — sem subpastas. Os 5 scripts superados de 2026-07-15/16 (`irf_instrument_diag_sweep.R`, `irf_instrument_report.R`, `irf_instrument_report_plots.R`, `irf_rq_candidates.R`, `irf_sample_diagnostic.R`) foram `git mv`ados para `arquivo/script/`.
- `diagnostics/output/` (57 CSVs) **fica flat** — sem subpastas `t1/`..`t7/` — decisão do autor.
- Os 2 arquivos deletados não commitados (`prompt_auditoria_dfm_iv.md`, `correspondence/auditor-externo/2026-07-31_rodada1_rationale.md`) **não foram tocados** — trabalho em progresso de outra sessão, fora de escopo.
- Novo `README.md` na raiz (começou como `INDEX.md`, renomeado a pedido do autor) aponta para `script/README.md`/`diagnostics/README.md` em vez de duplicar conteúdo.
- **Nada foi commitado ainda.**

## Key Files
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/README.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/script/README.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/diagnostics/README.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/_instrucoes/pendencias.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/arquivo/README.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/CLAUDE.md

## Next Steps
- [ ] Revisar e commitar as mudanças (nada commitado ainda: `pendencias.md`, `CLAUDE.md`, `arquivo/README.md`, os 5 `git mv`, e os 3 arquivos novos)
- [ ] Avaliar se `relatorio/estrutura_paper_v2.md` ou outro doc-âncora deveria apontar para o novo `README.md`
- [ ] Retomar os 2 arquivos deletados não commitados quando a sessão de origem voltar

## Context
Sessão de organização/documentação pura, sem mudança em código de estimação. Todas as decisões de agressividade da reorg (leve em `script/`, flat em `diagnostics/output/`, não mexer nos deletados) foram confirmadas com o autor via `AskUserQuestion` em modo de planejamento antes de qualquer execução.
