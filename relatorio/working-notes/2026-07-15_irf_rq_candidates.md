# Seleção de (r,q): força do instrumento × coerência das IRFs

> **⚠️ SUPERADA (2026-07-15).** A recomendação de (7,6) abaixo **não se sustenta**: ao inspecionar as
> IRFs, o choque é contaminado (curva invertida no h0 com pico no 5y, price puzzle no núcleo até h40,
> câmbio/CDS significativamente errados) e o defeito é **idêntico em (7,6) e (6,5)** — varrer (r,q)
> não conserta. O problema é a montante (instrumento fraco no espaço de fatores + amostra COVID).
> Diagnóstico completo em [`2026-07-15_auditoria_identificacao_vs_alessi.md`](2026-07-15_auditoria_identificacao_vs_alessi.md).
> A tabela de força do instrumento (Etapa 1) e o pipeline continuam válidos; a **conclusão** (Etapa 3), não.

**Data:** 2026-07-15 · **Instrumento:** `z_jk_bs_purif` (default) · **Var. de política:** `yield_6m`
**Script:** `script/irf_rq_candidates.R` · **Tarefa:** `_instrucoes/irf_consistentes.md`

Configuração de produção, **idêntica entre candidatos** (comparabilidade): full sample
2013-01..2025-12 (153 meses alinhados), p=6, choque +50bp, wild bootstrap **nboot=800,
seed=123**, bandas 68/90, h=48 (lido h=0..40). Todos os candidatos passaram o *sanity*:
impacto de `yield_6m` = **+0.005000** exato (normalização OK) e `dfm_max_eig` ≈ 0.980 (<1).

O pre_covid entra **apenas** como filtro de força na Etapa 1; as IRFs são estimadas no
full sample (especificação de produção).

---

## Etapa 1 — Candidatos e força do instrumento

Fontes conferidas antes do uso: `output/instrument/mosw_strength_grid.{md,csv}` (gerado
2026-07-14; já cobre `z_jk_bs_purif` — a série existe desde o quarteto de auditoria de
07-14, então a troca de default de 07-15 não altera os números) e
`output/irf/spec_sweep_cells.csv` (2026-07-15, já sob `z_jk_bs_purif`). O grid MOSW é a
**única** fonte com q=4 (cobre (8,4)); a F reduzida contra `yield_6m` é constante em (r,q)
(depende só da amostra): **25.03 (full) / 42.09 (pre)** — o instrumento é fortemente
relevante para `yield_6m` em qualquer (r,q).

Régua prioritária = **ξ_mp** (Wald MOSW na direção de `yield_6m`; ≥10 forte, >3.84 ⇒
conjunto AR limitado). Números de `z_jk_bs_purif`:

| (r,q) | full ξ_mp | full F-fs | full Wald_j(χ²_q) | pre ξ_mp | pre F-fs | papel |
|-------|-----------|-----------|-------------------|----------|----------|-------|
| **(8,4)** | **11.96** | 8.90 | 13.64 | 6.71 | 2.73 | ξ_mp máximo no full; clareia ≥10 |
| **(7,7)** | **11.50** | 4.67 | 14.01 | 6.83 | 5.95 | forte no full; pre moderado |
| **(7,6)** | **9.67**  | 6.29 | 12.57 | 6.90 | 2.35 | quase-10 full; nomeado; está no spec_sweep |
| **(6,6)** | **8.79**  | 5.82 | 10.80 | 12.93 | 5.55 | ponta forte no pre |
| **(6,5)** | **6.94**  | 5.12 | 8.73  | 12.49 | 11.66 | **baseline de produção** (âncora) |
| ~~(7,4)~~ | 9.41 | 6.29 | 12.14 | **2.48** | 2.35 | **excluído**: pre AR ilimitado |

Ranking pela métrica primária (full ξ_mp): (8,4) > (7,7) > (7,6) > (6,6) > (6,5). Todos
com conjunto AR limitado no full; **(7,4) excluído** por ξ_mp pre = 2.48 (<3.84 ⇒ conjunto
AR ilimitado no pre-COVID). O pre-COVID inverte a ordem (r=6 domina; r≥7 colapsa em
factor-space com T=78) — por isso o critério secundário só **penaliza**, e nenhum
candidato mantido fica *fraco demais* no pre (todos ≥6.7, exceto o excluído).

**Ressalva metodológica central (registrar para o periódico):** **nenhum** candidato cruza
F de factor-space ≥ 10 no full (máx 8.90 em (8,4)). Só a ξ_mp *direcional* atinge ≥10 no
full (e só para r=8/7,7). A relevância existe (F reduzida 25/42; Wald conjunta significativa;
AR limitado), mas a inferência da submissão deve ser **robusta a instrumento fraco
(Anderson-Rubin / ξ_mp)**, não Stock-Yogo ingênua.

---

## Etapa 2 — Leitura ponto-a-ponto das IRFs (h = 0..40)

Dados: `output/irf/irf_rq_candidates_{h,summary}.csv`; visual: `irf_rq_candidates_overlay.pdf`.
Veredito por variável × candidato (motor idêntico ao de produção — a coluna (6,5)
**reproduz exatamente** `irf_coherence_summary.csv`, validando o pipeline):

| variável (sinal esp., janela) | (8,4) | (7,7) | (7,6) | (6,6) | (6,5) |
|---|---|---|---|---|---|
| asset_ibov (−, 0-6) | incoer. | incoer. | incoer. | incoer. | incoer. |
| cambio_usd (− soft, 0-6) | soft·depr | soft·depr | soft·depr | soft·depr | soft·depr |
| embi_perc (− soft, 0-6) | soft·abre | soft·abre | soft·abre | soft·abre | soft·abre |
| credit_outstanding (−, 6-36) | **forte** | parcial | **forte** | parcial | **forte** |
| credito_pessoa_fisica (−, 6-36) | **forte** | parcial | **forte** | **incoer.** | coerente |
| spread_icc_juridica (+, 0-12) | parcial | parcial | parcial | parcial | **incoer.** |
| spread_icc_fisica (+, 0-12) | parcial | coer.forte | parcial | coerente | parcial |
| ibc_br (−, 3-24) | **forte** | coerente | coerente | coerente | **forte** |
| trab_tx_desemprego (+, 6-36) | coerente | parcial | **coer.forte** | **incoer.** | parcial |
| price_ipca (−, 12-48) | **incoer.** | parcial | parcial | parcial | parcial |

**Padrões universais (robustos a (r,q)) — a história econômica não depende da escolha:**

- **`asset_ibov` (incoerente em todos, porém n.s.):** impacto h0 **negativo** e correto
  (−0.011 a −0.022) em todo candidato, mas a resposta vira levemente positiva em h1-6 →
  `share_correct` 0.14-0.29. **Nenhum horizonte é significativo a 90% em nenhum candidato**
  (n_pos_sig90 = 0). É incoerência de *sinal médio*, não de banda — o conhecido puzzle de
  ações amostral, não artefato de normalização.
- **`cambio_usd` / `embi_perc` (soft, canal de dominância fiscal):** BRL deprecia e risco
  soberano abre no impacto (spike h0-2), revertendo por h15-30 — idêntico entre candidatos.
  Tier soft (registrado, nunca penalizado).
- **`ibc_br` (atividade — o resultado mais limpo):** contração forte já no impacto (~−0.5),
  `share_correct` = **1.00** em **todos** os candidatos; forte (CI68) em (8,4) e (6,5),
  coerente nos demais. Robusto e de livro-texto.
- **`price_ipca` (sem price puzzle significativo):** hump positivo n.s. em h3-8 e retorno a
  ~0. **n_pos_sig90 = 0 e n_neg_sig90 = 0 em todos** — a inflação nunca responde
  significativamente em nenhuma direção. Consistente com "puzzle amostral, n.s.". A
  *duração* do hump é o que separa os candidatos: pior/mais longo em (8,4) (25/41 horizontes
  positivos → classificado incoerente por `share`), mais curto em (6,6) (11/41).

**Bloco de crédito — dimensão que discrimina os candidatos:**

- `credit_outstanding` e `credito_pessoa_fisica` seguem a cronologia BG95/GG94
  (sobe h0-6 → contrai forte h15-40). Ambos **coerente_forte com significância CI68** em
  **(8,4) e (7,6)** (share 0.84-1.00); em (6,5) forte+coerente. **(6,6) degrada**
  (`credito_pessoa_fisica` incoerente, share 0.48) e **(7,7) enfraquece** (ambos parciais,
  sem CI68). No overlay, (7,6)/(8,4) atingem o vale mais profundo (~−1.2).

**Spreads ICC — ruído em todos, janela de score suspeita:**

- Padrão bifásico (compressão mecânica h0-3 → alargamento tardio h12-24 → retorno).
  **Nunca há violação significativa (any_sig90_wrong = FALSE em todos)**. `spread_icc_juridica`
  é o único ponto onde **(6,5) fica pior** (incoerente, share 0.38 — o mergulho inicial mais
  fundo); r≥7 o eleva a parcial. Lembrar que a janela 0-12 é reconhecidamente mal-especificada
  (resposta em dois estágios; ver nota 2026-07-12) — vereditos aqui são frouxos.

**Desemprego:** sobe corretamente (correto por h15-40). Melhor em **(7,6) (coer.forte)** e
(8,4); **(6,6) incoerente** (mergulho negativo espúrio em h5-12, share 0.35); (7,7)/(6,5)
parciais.

---

## Etapa 3 — Síntese comparativa e recomendação

Contagem no tier *scored* (8 variáveis; "good" = coerente_forte+coerente):

| (r,q) | forte | good | parcial | incoer. | mean share | full ξ_mp | veredito |
|-------|-------|------|---------|---------|-----------|-----------|----------|
| **(8,4)** | 3 | 4 | 2 | 2 | **0.748** | **11.96** | ξ_mp máx + IRFs co-limpas; único senão: IPCA incoer. (n.s.) |
| **(7,6)** | 3 | 4 | 3 | **1** | 0.733 | 9.67 | **IRFs mais limpas** (só IBOV univ.); parcimonioso; no spec_sweep |
| (6,5) | 2 | 3 | 3 | 2 | 0.654 | 6.94 | incumbente; forte no pre, mais fraco no full; 2 incoer. |
| (7,7) | 1 | 2 | 5 | 1 | 0.689 | 11.50 | **dominado**: ξ_mp forte mas crédito fraco, muito parcial |
| (6,6) | 0 | 2 | 3 | 3 | 0.632 | 8.79 | **dominado**: 3 incoerências (crédito PF, desemprego) |

Os dois que satisfazem **ambos** os critérios (força primária + IRFs limpas) são **(8,4)** e
**(7,6)**. (7,7) e (6,6) são dominados; (6,5) é o incumbente robusto no pre mas o mais fraco
no full e com duas incoerências.

**(8,4) vs (7,6)** (variam só no essencial): crédito idêntico (ambos forte/forte);
(7,6) **melhor** em desemprego (coer.forte vs coerente) e IPCA (parcial vs incoerente) e é
**mais parcimonioso** (r=7); (8,4) só ganha em ξ_mp bruto (11.96 vs 9.67) e marginalmente em
`ibc_br` (forte vs coerente). **Concordam em toda conclusão econômica** (crédito, atividade,
câmbio/risco, ações, inflação n.s.) → a narrativa do paper é robusta à escolha entre os dois.

### Recomendação para o Encontro

**Especificação de trabalho: (r,q) = (7,6).** Melhor trade-off: (i) instrumento adequado e
**AR-limitado nas duas amostras** (full ξ_mp 9.67 ≈ Stock-Yogo, Wald conjunta 12.57
significativa; pre 6.90); (ii) **conjunto de IRFs mais limpo** — única incoerência é o IBOV
universal e n.s., IPCA sem puzzle significativo, crédito+atividade+desemprego coerentes/fortes;
(iii) parcimônia (r=7,q=6); (iv) já coberto pelo `spec_sweep` (diagnóstico stage-1 completo).

**Robustez a reportar junto: (8,4)** — a especificação **ξ_mp-máxima** no full (11.96,
clareia ≥10). Se o parecerista priorizar força bruta de primeiro estágio acima de tudo, é a
escolha; as conclusões econômicas são idênticas às de (7,6), com IPCA levemente pior (hump
n.s. mais longo). Manter **(6,5)** citado como baseline de produção anterior (mais forte no
pre-COVID, útil como robustez de subamostra).

### Ressalvas para a versão de periódico (pendências)

1. **Factor-space F < 10 no full em todos os candidatos** (máx 8.90). A inferência precisa ser
   explicitamente **robusta a instrumento fraco (Anderson-Rubin / ξ_mp de MOSW)** — não apoiar
   em Stock-Yogo sobre a F de factor-space. É o item metodológico #1.
2. **`asset_ibov` incoerente é universal e nunca significativo** — documentar como puzzle de
   ações amostral (não de normalização); some pré-COVID sob a mesma identificação (ver notas
   2026-07-12).
3. **Sem price puzzle significativo** em nenhum candidato (bandas contêm zero em todo h) —
   sustentar a leitura de que o hump de IPCA é amostral e n.s.
4. **Janela de score dos spreads ICC (0-12) é mal-especificada** (resposta bifásica) — revisar
   a janela antes de reportar vereditos de spread; hoje são frouxos por construção.
5. **Fragilidade pre-COVID para r≥7** (factor-space F ~2.3-2.7): a recomendação (7,6) apoia-se
   no full sample. Se a robustez de subamostra for exigida pelo referee, (6,5)/(6,6) são mais
   fortes no pre, ao custo de IRFs mais sujas.
6. Atualizar `model_alessi.R` (hoje força r=6,q=5) para (7,6) **somente** após decisão final —
   registrar como alteração pendente, não aplicada nesta rodada.
