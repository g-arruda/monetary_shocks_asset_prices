# Varredura de especificações IRF — Conclusões e diagnóstico

> **⚠️ CORPO DESATUALIZADO — banner de 2026-07-26.** Escrito em 2026-07-11/15 sob `z_jk_purif`,
> produção (6,5) e vintage pré-refresh. Os CSVs que ele consolida (`spec_sweep_cells.csv`,
> `spec_sweep_report.md`, `spec_sweep_stage2.md`) foram **regenerados em 2026-07-24** sob 106 séries
> e (7,6) — os números aqui não batem com eles. Duas afirmações caíram: "pre-COVID (6,5) é o pico do
> grid" e "sempre que F ≥ 10 os sinais saem coerentes". Leituras correntes em
> `output/irf/irf_section.md`; histórico em `_instrucoes/historico_decisoes.md` §3 e §6.
>
> **Adendo 2026-07-26 — a régua mudou.** O `spec_sweep_report.md` companheiro agora
> classifica `failure_class` por **ξ_mp** (limiares MOSW 3,84 e 10), não pela max-F
> homocedástica. Toda discussão de elegibilidade neste corpo — inclusive as células
> chamadas de "fortes" por F ≥ 10 — está na régua antiga. Sob ξ_mp são 23 células
> `ok` em `yield_6m`, e o instrumento de produção `z_jk_bs_purif` passou a ser uma
> delas em (7,6) full (ξ_mp 10,43 contra f_factor 6,31).


Consolida `spec_sweep_report.md` (Etapa 1, 320 células ponto-estimativa) e
`spec_sweep_stage2.md` (Etapa 2, bootstrap nboot = 800 nas 6 células vencedoras).
Gerado em 2026-07-11; scripts: `script/irf_spec_sweep.R`, `script/irf_spec_stage2.R`.

## 1. O que causa os sinais invertidos e magnitudes implausíveis

O diagnóstico de 2026-05-08 é confirmado e fechado pela varredura completa:
**toda falha de sinal é instrumento fraco no espaço dos fatores** — nenhuma outra
causa aparece no grid.

- 208 de 320 células falham com `weak_factor_space` (F factor-space < 10);
  64 são o controle negativo `juros_selic`; 48 são `ok`.
- **Zero células `sign_puzzle`**: sempre que F (factor-space) ≥ 10, os sinais
  hard (curva ↑, IBOV ↓) saem 100% coerentes com a teoria, em qualquer
  instrumento, mp_var, (r, q) ou amostra.
- **Zero células `unstable_normalization`**: o denominador da normalização
  (`irf_mp[mpind, 1]`) nunca chega perto de zero (denom_ratio mínimo ≈ 0.29).
  Normalização incorreta e fator mal identificado estão descartados como causas.
- `juros_selic` como mp_var: F reduzido máximo = 2.49 (mediana 0.44) em todas as
  64 células — confirma o mismatch de maturidade documentado em
  `_instrucoes/justificativa_uso_yield-6m.md`. Não é um problema do modelo, é a
  variável de política errada.
- A divergência conhecida do `z_het_jk_3var` reaparece tal e qual: F (y6m AR)
  ≈ 55 com F (factor-space) 2.4–4.1 no full sample. **Novo:** em pre_covid com
  (r=6, q=5) o mesmo instrumento cruza Stock-Yogo (F = 11.1) — a fraqueza dos
  instrumentos het no espaço dos fatores é dominada pela amostra COVID+pós,
  não é estrutural ao esquema de identificação.

## 2. Combinações teoricamente coerentes e robustas

### Núcleo robusto (não é coerência por acaso)

**pre_covid (2013–2019) com r=6, q=5** é o ponto do grid onde a identificação é
mais forte: **cinco instrumentos** cruzam F (factor-space) ≥ 10 —
z_jk_purif (15.4), z_jk (15.2), z_het_jk_3var (11.1), z_het_3var (10.8),
z_bruto_purif (10.4) — e todos entregam sinais hard e de transmissão
(IPCA ↓, PIB ↓, varejo ↓ em h=24) coerentes. Dois esquemas de identificação
independentes (timing Copom e heteroscedasticidade Rigobon-Sack) concordam,
o que descarta coincidência de uma única especificação.

No **full sample**, apenas a família JK sobrevive: z_jk_purif em (6,5), (7,6),
(8,8) e z_jk em (8,8).

### Com bandas de bootstrap (Etapa 2, nboot = 800)

| célula | hard-tier CI90 ≠ 0 | observação |
|---|---|---|
| pre_covid r6q5 z_jk_purif | 3/3 | IBOV −0.14 [−0.27, −0.06]; câmbio + mas não significante |
| pre_covid r6q5 z_jk | 3/3 | praticamente idêntica à purificada |
| full r7q6 z_jk_purif (baseline) | 3/3 | depreciação +0.25 BRL significante (dominância fiscal) |
| full r8q8 z_jk_purif | 3/3 | ponto idêntico ao RDS de produção existente (verificação) |
| pre_covid r6q5 z_het_jk_3var | 0/3 | sinais coerentes no ponto, bandas largas (F ≈ 11 borderline) |
| pre_covid r6q5 z_het_3var | 0/3 | idem; única célula com **apreciação** cambial |

### Magnitudes (agora em unidades corretas)

- `cds_5y` está em escala ×100 no painel: h0 ≈ +4100 = **+41bp** — plausível.
- `cambio_usd` é nível BRL/USD (não log): +0.24 BRL no full (~+5%, significante),
  +0.07 BRL no pre_covid (~+2%, não significante).
- IBOV: −9% a −14% no impacto — grande mas dentro das bandas; reverte rápido.
- Curva: no full sample yield_2y/5y respondem ~2x o choque de 50bp em yield_6m
  (amplificação); no pre_covid a ordenação é mais amortecida; só `z_het_3var`
  entrega a ordenação livro-texto |y5y| < |y2y| < |y6m|.

## 3. Canal cambial: dominância fiscal não é universal

Das 48 células elegíveis, 44 mostram depreciação + abertura de CDS/EMBI
(canal de dominância fiscal, como já interpretado em `irf_section.md`) — mas as
4 células de **apreciação** são todas `z_het_3var` em pre_covid (6,5), com
score de transmissão completo. Ou seja: o instrumento de heteroscedasticidade
sem filtro JK, na amostra pré-COVID, recupera o canal GRG (2025) de apreciação.
Ponto não significante (bandas largas), mas é o único candidato do grid para a
narrativa "canal padrão"; merece menção como robustez qualitativa, não como
resultado principal.

## 4. Resposta à decisão em aberto do HANDOFF (r=7,q=6 vs auto r=5,q=4)

- **Evitar r=5, q=4 no full sample**: F = 9.20 (weak) para z_jk_purif — é a única
  linha da família JK-purif que falha o gate.
- No full sample, (6,5), (7,6) e (8,8) são equivalentes em coerência (todas ok,
  mesmos sinais); F cresce com a dimensão: 10.08 → 10.17 → 11.76.
- **r=6, q=5 tem o argumento mais forte**: é a única escolha que fica `ok` no
  full **e** é o pico de identificação no pre_covid (15.4), permitindo usar o
  mesmo (r, q) nas duas janelas como robustez.

## 5. Recomendações

1. Manter `z_jk_purif` + `yield_6m` como especificação primária; migrar o
   (r, q) do paper para **(6, 5)** ou manter (7, 6) — ambos passam; documentar
   que (5, 4) auto-IC fica borderline-weak e não deve ser o caso base.
2. Adicionar a janela **pre_covid (6,5)** como tabela/figura de robustez
   cross-instrumento (5 instrumentos, 2 esquemas de identificação, mesmos sinais).
3. Tratar as variantes het como confirmação qualitativa de sinais (e da
   apreciação em `z_het_3var`), com inferência fraca — se forem ao paper,
   usar bandas robustas a instrumento fraco (Anderson-Rubin), como já
   sugerido no HANDOFF.
4. `juros_selic` segue como controle negativo; não usar como mp_var.

## Artefatos

- `output/irf/spec_sweep_cells.csv` — 320 células × diagnóstico completo.
- `output/irf/spec_sweep_irf_long.csv` — 3200 linhas resposta × horizonte.
- `output/irf/spec_sweep_report.md` — tabelas da Etapa 1 (heat de F, taxonomia).
- `output/irf/spec_sweep_stage2.md` — impactos ± CI90 das 6 células.
- `output/irf/irf_spec_<tag>.{rds,pdf}` + `irf_spec_stage2_overlay.pdf`.

---

## Adendo 2026-07-14 — régua MOSW rigorosa (ξ_mp) sobre o mesmo grid

A auditoria contra o paper e o código oficial de Montiel Olea-Stock-Watson
(`output/instrument/olea_alignment_audit.md`) substituiu a métrica F
(factor-space) — max-F homocedástica entre as q equações, anti-conservadora —
pela **ξ_mp**: Wald robusta (Eicker-White + correção Shat) na direção do
impacto de `yield_6m`, análogo exato do `Waldstat` oficial; conjunto AR 95%
limitado sse ξ_mp > 3.84. Grade completa (r ∈ 5–8, q ∈ 4–r × full/pre_covid ×
8 instrumentos) em `output/instrument/mosw_strength_grid.md`
(`script/mosw_strength_grid.R`). Revisões às conclusões acima:

1. **O núcleo pre_covid (6,5) sobrevive para a família GK, não para a het.**
   Sob ξ_mp: z_jk_purif = 13.25, z_jk = 12.72, z_bruto_purif = 12.04,
   z_bruto = 11.62 — todos ≥ 10, AR limitado. Mas z_het_jk_3var = 9.27
   (borderline, AR limitado) e z_het_3var = 6.29 (fraco, AR limitado):
   a max-F legada (11.1 / 10.8) **superestimava** a força dos instrumentos
   het. A convergência entre esquemas de identificação continua qualitativa
   (z_het_jk_3var a 9.27), porém a célula de apreciação do z_het_3var
   (reconciliação GRG) deve ser apresentada com bandas/qualificação
   Anderson-Rubin, não como célula forte.
2. **Full sample: nenhum instrumento cruza ξ_mp ≥ 10 em (6,5)** — z_het_jk
   6.26, z_jk 5.47, z_jk_purif 5.20 (zona "usar AR"); o baseline da Etapa 2
   full r7q6 z_jk_purif tem ξ_mp = 5.00. As bandas bootstrap full-sample
   devem ser lidas com a qualificação de instrumento fraco.
3. **z_het_jk é o mais forte do full sample na régua nova** (mediana 9.41;
   ≥ 10 nas células r=8, máx 12.68 em (8,6)) apesar de ξ₁ ≈ 0 contra o fator 1
   — relevância concentrada na direção yield_6m, invisível ao max-F legado e
   ao F (DFM). Candidato natural a robustez full-sample.
4. **r ∈ {7,8} colapsa em pre_covid** para a maioria das células com q ≤ 6
   (ξ_mp entre 0 e 4.7): T = 84 meses não sustenta r alto. Reforça (6,5)/(6,6)
   como especificação pre_covid — agora por um argumento de força, não só IC.
5. **F conjunta (ξ/q) ≤ 5.8 em todo o grid**: a relevância é unidirecional,
   como esperado sob exogeneidade (Γ = α·Θ₀,₁) — o teste conservador
   "em alguma direção" não é a régua de decisão; ξ_mp é.

## Adendo 2026-07-14 (b) — par de máscara bruta no grid MOSW (ordem JK ↔ purificação)

Duas variantes novas entraram no grid MOSW (agora 10 instrumentos × 14 (r,q) ×
2 amostras = 280 células): `z_jk_raw_purif` e `z_jk_raw_purif_local` — máscara
JK decidida nos sinais **brutos** (`delta_di` × `r_ibov`) em vez dos sinais dos
resíduos (ordem "JK → purificação", inversa à do `z_jk_purif`; a `_local`
re-estima a purificação só nos ~55 dias selecionados). Construção em
`script/instrument.R`; análise completa em
`relatorio/working-notes/2026-07-14_ordem_purificacao_jk.md`. Revisões aos
pontos do adendo anterior:

1. **O ponto 3 acima ("z_het_jk é o mais forte do full sample") fica
   empatado/superado**: `z_jk_raw_purif` tem a mesma mediana full (9.41),
   cruza ξ_mp ≥ 10 em 6/14 células full (vs 5 do z_het_jk; (7,7) e todo r=8,
   máx 12.40 em (8,8)) e é o mais forte em (6,5) full (6.61 > z_het_jk 6.26 >
   z_jk_purif 5.20). Supera `z_jk_purif` em 13/14 células full — leitura
   estrutural: a máscara residual classifica 2020-03-19 (pânico COVID,
   Ibov bruto +2.1%) como monetário só porque a purificação vira o sinal do
   Ibov; a máscara bruta o exclui, limpando o first stage na janela COVID.
   `z_jk_raw_purif` passa a ser o candidato natural a robustez full-sample
   **dentro da família GK** (mesma identificação por timing do default).
2. **O ponto 1 (núcleo pre_covid) não muda**: em (6,5) pre_covid o ranking
   inverte — z_jk_purif 13.25 > z_jk_raw_purif 10.80 > z_jk_raw_purif_local
   10.49, todos ≥ 10 com AR limitado. Default `z_jk_purif` inalterado.
3. **`z_jk_raw_purif_local` é dominada** por `z_jk_raw_purif` em 26/28
   células (regressão local com ~55 obs só adiciona ruído) — descartada
   como candidata; mantida no painel apenas como descritor.
4. As variantes novas ainda **não** entraram na varredura IRF
   (`irf_spec_sweep.R` segue com 8 instrumentos); se `z_jk_raw_purif` for
   promovida a robustez no paper, rodar a Etapa 1 para checar coerência de
   sinais nas células fortes.

## Adendo 2026-07-15 — varredura re-rodada com as variantes da auditoria; default trocado para `z_jk_bs_purif`

A Etapa 1 foi re-rodada com 12 instrumentos (as 4 variantes da auditoria de
fidelidade entraram: `z_jk_raw_purif`, `z_jk_raw`, `z_bs_purif`,
`z_jk_bs_purif`), totalizando **480 células**. Resultados:

1. **Zero `sign_puzzle` e zero `unstable_normalization` também nas 160
   células novas** — a conclusão central da varredura (inversão de sinal ⇔
   instrumento fraco no espaço dos fatores) se estende às variantes da
   auditoria. As 320 células antigas reproduzem os valores de 2026-07-11
   sem alteração (DFM cacheado idêntico).
2. As 4 variantes novas ficam `ok` nas células pre_covid (6,5) com
   `yield_6m` (F factor-space 10.65–11.95), o mesmo ponto forte do grid.
3. **`DEFAULT_VARIANT` trocado para `z_jk_bs_purif`** (decisão do autor,
   2026-07-15) e a cadeia de produção re-rodada nessa data: Etapa 2 com
   baseline (6,5) full, `model_alessi.R` e coerência (nboot=800, seed 123).
   História qualitativa preservada; magnitudes ~30–45% menores que na
   rodada `z_jk_purif` (ver `irf_coherence_report.md`, nota de 2026-07-15).
   O item 4 do adendo (b) acima está fechado.
4. Decisão editorial da mesma data: **o instrumento het fica fora do
   paper** (as células het permanecem no grid como diagnóstico interno).
