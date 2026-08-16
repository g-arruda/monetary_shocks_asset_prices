# Handoff — 2026-08-14 (exogeneidade lead-lag: procedência resolvida, invertibilidade testada)
SESSLOG:[2026-08-14 19:00]
<!-- written by: pop-os at 2026-08-14T19:00:41-03:00 -->
*Project: monetary_shocks_asset_prices*

## Session Topic
A condição lead-lag é de Stock-Watson, não de Braun-Brüggemann — e não é exigida pelo SVAR-IV, que paga em invertibilidade. Teste de Granger implementado; não rejeita.

## Active Decisions
- **Lead-lag = SW (2018), Condição LP-IV (iii).** BB é bayesiano e não é a fonte. Nunca atribuir a condição a BB.
- **A perna de leads testa invertibilidade, não exogeneidade.** O SVAR-IV exige só relevância + exogeneidade contemporânea; a §5.1 já rotula isso.
- **O teste de Granger fica fora de `t1_gate.csv`.** A trava de parada continua sendo de exogeneidade.
- **Ressalvas obrigatórias em qualquer texto:** condição só necessária; potência baixa (30 livres, 6 testados, n=147); nenhuma simulação de tamanho; `cambio_usd` defasado em `p_boot` 0,064.
- Regra de veredito (fixada antes dos números): L = p = 6 decide, L = 3 sensibilidade, Holm sobre as 5 equações.

## Key Files
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/notas/2026-08-14_exogeneidade_lead_lag_e_invertibilidade.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/diagnostics/01_exogeneidade.R
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/diagnostics/output/t1_7_invertibilidade_granger.csv
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/paper/paper_anpec.tex
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/registro/pendencias.md

## Next Steps
- [ ] Correlações canônicas VAR pequeno × espaço de fatores (`hom_var_approx.m`) — sustenta `paper_anpec.tex:238` diretamente
- [ ] `script/validate_amengual_watson.R` com fixture em `output/validation/`, caminho `apply_bll = FALSE`
- [ ] Decidir se a invertibilidade vira subseção própria da §5
- [ ] LP-IV (Tema B): pré-condição satisfeita, destrava o Hausman LP-IV × SVAR-IV
- [ ] Pré-teste de relevância de Angelini-Cavaliere-Fanelli (exige 26ª chave — decisão do autor)

## Working Artifacts
- progress_logs/2026-08-14_inventario_testes_instrumento.md — inventário do que já foi testado no instrumento + o que há (e não há) em `codigos_externos/codigo_sw`

## Context
Granger não rejeita: menor `p_boot` 0,324 em L=6, todos Holm 1,000. As tabelas `t1_*` antigas saíram idênticas ao pré-run; paper compila limpo com 25 chaves. A metade não migrada do `.tex` (§1, §2, §4, conclusão) continua na vintage de 106 séries — esta rodada não a tocou.
