# Varredura de especificações IRF — Conclusões e diagnóstico

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
