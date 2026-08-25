# Ordem sugerida para os itens abertos de `pendencias.md`

> **NOTA DE PLANEJAMENTO — nenhuma estimação, nenhum `.tex` tocado.** Escrita em
> 2026-08-18 sobre os **18 itens abertos** de `registro/pendencias.md` naquela
> data, logo após o julgamento de `relatorio/checklist_problemas_sdfm_weak_iv.md`.
> É um instantâneo: à medida que itens fecham, a ordem envelhece. A lista viva é
> o `Índice de itens abertos` do próprio `pendencias.md`, não esta nota.

**A regra que organiza tudo:** decisões que mexem na produção vêm **antes** do
congelamento do texto. Migrar o resumo agora e depois mudar `q`, `p` ou o painel
custa a reescrita duas vezes.

---

## Fase 0 — fechar as decisões de produção (Tema E, Tema B)

1. **Decidir `q`.** A evidência está completa e o item é uma *decisão*, não uma
   rodada: manter `q=5` e declarar a discordância — que é o que a §3.5 já diz —
   ou migrar para `(5,2)`, assumindo ξ_mp 3,809 e conjunto AR ilimitado. Mais
   barato de todos e destrava a fase seguinte.
2. **Varredura de `p`.** `p=6` não é o argmin de AIC, BIC nem HQ. Se só a
   reversão de médio prazo se mover, fecha corroborando a §4; se o impacto se
   mover, muda tudo o que vem depois.
3. **S&P 500 no painel.** Leva a produção de 111 para 112 séries e obriga
   re-rodar. Se for entrar, entra aqui — nunca depois da migração do texto.

## Fase 1 — barato, e destrava a escrita

4. **`paper_numbers.tex`.** Precede a migração por construção: é o que impede a
   doença de duas vintages de voltar.
5. **Tabela cross-instrumento do bloco-manchete.** Quase pós-processamento — os
   pontos das 8 variantes já estão em `spec_sweep_irf_long.csv`.
6. **Decomposição do wedge de UIP.** Só pós-processamento sobre os 800 draws
   salvos, e é quem decide o título do paper.

## Fase 2 — texto

7. **Reescrever resumo, §1, §2 e conclusão** para 111 `(5,5)`, incluindo a
   decisão sobre o título. O paper está internamente contraditório desde
   2026-08-14; isto é o conserto.

## Fase 3 — a agenda do checklist (identificação e weak-IV)

8. **SVAR-IV weak-robust com a mesma proxy.** Maior valor isolado: é onde a
   teoria de fato se aplica.
9. **Leave-one-out e leave-cluster-out sobre a IRF**, com a tabela
   reunião-a-reunião.
10. **Preditor fiscal predeterminado na RHS de Bauer-Swanson.**

> 8 responde ao referee que diz “a proxy é fraca”; 9 e 10 ao que diz “a proxy é
> fiscal”. Nenhum substitui o outro.

## Fase 4 — leitura de mecanismo

11. **Curva: expectativa contra prêmio** (diário vs. mensal). O bloqueador do
    Tema E citado no índice — a seleção de fim de mês — fechou em 2026-08-12.
12. **A amplificação 5a/6m é do choque ou de Λ?** Teste discriminante do item 11.

## Fase 5 — higiene, sem consumidor esperando

13. Documentar o bootstrap e devolver a contagem de falhas.
14. Padronização do 2º estágio em `amengual_watson()`.
15. `irfs_required_long.csv` sob o tcode antigo.
16. Remover o shim `scalar_dynamic_factor_compat.R`.
17. Dois artefatos que ainda documentam `asset_*` em tcode 2.
18. O estágio `di` não reproduz mais a vintage do repo.

⚠ **O 18 é higiene na ordem, não na consequência.** `data/raw/di.csv` é hoje
insumo insubstituível e *gitignored*, e dele saem as 8 variantes do instrumento.
Fazer cópia fora do repo não espera fase nenhuma.
