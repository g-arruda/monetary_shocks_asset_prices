# Auditoria de fidelidade: filtro JK e "purificação Bauer-Swanson" (2026-07-14)

## Pergunta

O filtro Jarociński-Karadi e a purificação atribuída a Bauer-Swanson em `script/instrument.R` foram implementados fielmente aos artigos/códigos originais? A regressão de purificação — que usa apenas SP500/VIX/Brent contemporâneos — deveria ter outras variáveis? Isso impacta a força do instrumento sob a régua ξ_mp (Wald de Montiel Olea-Stock-Watson na direção do impacto em `yield_6m`)?

Fontes: notas de leitura `split-pdf-md` em `artigos/*/_notes.md` (JK 2020, BS 2023, GK 2015, MOSW 2021) + código original dos autores (`codigo_Jarocinski_e_Karadi/`, `codigo_bauer_swanson/`).

## 1. Filtro JK — fiel na regra, infiel no insumo

O "poor man's sign restriction" original (JK 2020 §"Poor Man's"; série `pmnegm_ff4sp500` em `codigo_Jarocinski_e_Karadi/data/data_var/us_ea_variables_shocks/us_shocks.csv`) é: **manter a surpresa BRUTA de juros quando o sinal bruto da surpresa de juros difere do sinal bruto da surpresa de ações; zerar caso contrário; somar dentro do mês**. Conferido diretamente no CSV dos autores: 1990-02 tem ff4 = −0.02 e sp500 = −0.167 (mesmo sinal) ⇒ `pmnegm` = 0, `pmposm` = −0.02.

| componente | JK original | projeto (default `z_jk_purif`) | veredito |
|---|---|---|---|
| regra zero-out | manter co-mov. negativo, zerar co-mov. positivo | idem | ✅ fiel |
| agregação mensal | soma das surpresas no mês; 0 sem reunião | idem (`agg_monthly`) | ✅ fiel |
| janela | 30 min em torno do anúncio | qua fechamento → qui fechamento | ⚠️ desvio documentado (dados BR; mesma janela de GRG 2025) |
| **sinais da classificação** | **brutos** | **resíduos** da purificação contemporânea | ❌ desvio |
| **valores agregados** | **brutos** | **resíduos** | ❌ desvio |

A matriz 2×2 máscara × valores agora está completa em `script/instrument.R`:

| | valores brutos | valores purificados |
|---|---|---|
| **máscara bruta** | **`z_jk_raw`** (novo — JK literal) | `z_jk_raw_purif` (2026-07-14) |
| **máscara residual** | `z_jk` | `z_jk_purif` (default) |

Nota de atribuição: a agregação por soma dentro do mês é a de **JK**; GK 2015 usam outra (cumular surpresas diárias → média mensal → primeira diferença, ver `..._notes.md` GK linha "Monthly aggregation"). `CLAUDE.md` dizia "per Gertler-Karadi" — corrigido.

## 2. "Purificação Bauer-Swanson" — o nome está errado, não o procedimento

BS 2023 (eq. 7 / Table 3; `codigo_bauer_swanson/MATLAB/{table_3.m,constructomittedvars.m}`) regridem a surpresa em **notícias PRÉ-anúncio**: surpresas de releases macro do próprio país (payrolls, desemprego, GDP, CPI core, índice BBK) + variações financeiras acumuladas nas **13 semanas anteriores** (S&P500, inclinação da curva, commodities) + constante + tendência + revisão defasada do Blue Chip. Nada contemporâneo ao anúncio.

O projeto regride `delta_di` em SP500/VIX/Brent **da mesma janela qua→qui**. São dois tratamentos diferentes para duas contaminações diferentes:

- **BS**: previsibilidade ex-ante ("Fed response to news") → viola exogeneidade (correlação com choques estruturais defasados);
- **projeto**: choques globais que entram na janela diária larga → viola a restrição-zero do HFI (com janela de 30 min isso seria desnecessário).

A limpeza contemporânea é **defensável por si** (economia pequena: Copom não move SP500/VIX/Brent na mesma sessão — não há bad control), mas **não é** Bauer-Swanson e não trata o canal de exogeneidade que BS documentam. Resposta à pergunta "faltam variáveis?": no sentido BS, sim — faltavam preditores **pré-Copom** (inclusive domésticos, que são permitidos justamente por serem predeterminados); variáveis domésticas **contemporâneas** (BRL, EMBI, curva DI na janela) continuariam proibidas (bad control — respondem ao próprio choque).

## 3. Novas variantes e dados

Novos insumos (`R/data_download/focus_fred.R`): `data/processed/focus_daily.csv` (mediana Focus IPCA-12m suavizada + Selic fim-do-ano-seguinte, diário, 3.412 dias, 0 NA) e `data/fred_dgs2.csv` (Treasury 2y, 3.395 dias).

1. **`z_jk_raw`** — JK literal (máscara bruta + valores brutos).
2. **`z_bs_purif`** — resíduo da regressão pré-evento estilo BS: `delta_di ~ tendência + Δ65d{Ibov, SP500, VIX, Brent, BRL, inclinação DI 2y−3m} + Δ20d{Focus IPCA-12m, Focus Selic}` (tudo medido até a quarta, predeterminado), painel completo de quintas. R² = **0.024** (`r_ibov`: 0.015) — na faixa baixa esperada (BS: 0.12–0.20 com surpresas de release que não temos no diário; R² alto indicaria vazamento contemporâneo).
3. **`z_jk_bs_purif`** — máscara JK nos sinais dos resíduos pré-evento (62 dias monetários), valores = resíduos pré-evento.
4. **`z_jk_purif_us`** — purificação contemporânea + Δ(UST 2y) qua→qui (spillover FOMC nas ~32 semanas coincidentes), máscara nos resíduos (63 dias).

Correlações mensais: cor(`z_jk_raw`, `z_jk_raw_purif`) = 0.998; cor(`z_bs_purif`, `z_bruto`) = 0.994; cor(`z_jk_bs_purif`, `z_jk_raw_purif`) = 0.986; cor(`z_jk_purif_us`, `z_jk_purif`) = **0.999**.

## 4. Impacto na força (ξ_mp, grid MOSW 14 instrumentos × 14 (r,q) × 2 amostras)

### Célula de produção (r=6, q=5)

| amostra | instrumento | ξ_mp | F conjunta | p |
|---|---|---:|---:|---:|
| full | **z_jk_raw** | **7.05** | 1.87 | 0.10 |
| full | z_jk_bs_purif | 6.94 | 1.75 | 0.12 |
| full | z_jk_raw_purif | 6.61 | 1.85 | 0.10 |
| full | z_jk | 5.47 | 2.09 | 0.06 |
| full | z_jk_purif (default) | 5.20 | 2.06 | 0.07 |
| full | z_jk_purif_us | 5.06 | 2.07 | 0.07 |
| full | z_bs_purif | 4.34 | 2.04 | 0.07 |
| pre_covid | z_jk_purif_us | 13.26 | 3.52 | 0.003 |
| pre_covid | z_jk_purif (default) | 13.25 | 3.61 | 0.003 |
| pre_covid | z_jk_bs_purif | 12.49 | 2.74 | 0.018 |
| pre_covid | z_bs_purif | 11.53 | 2.61 | 0.023 |
| pre_covid | z_jk_raw_purif | 10.80 | 2.53 | 0.027 |
| pre_covid | z_jk_raw | 10.53 | 2.56 | 0.025 |

### Padrão cell-by-cell (full, 14 células)

`z_jk_bs_purif` e `z_jk_raw` andam praticamente juntos (Δ < 0.5 em toda célula) e dominam `z_jk_purif` em 14/14, cruzando ξ_mp ≥ 10 em 6/14 células (medianas 9.73 / 9.55 vs 5.53 do default, que não cruza em nenhuma). No pre_covid o ranking inverte nas células r=6 mas `z_jk_bs_purif` segue ≥ 12 na (6,5).

### Leitura mecânica

1. **A força vem da máscara, não dos valores.** `z_jk_raw` ≈ `z_jk_raw_purif` ≈ `z_jk_bs_purif` em toda parte: purificar (contemporâneo ou pré-evento) quase não altera os valores agregados (cor ≥ 0.986). O que muda ξ_mp é *quais dias* entram.
2. **A regressão contemporânea contamina a máscara.** A purificação por SP500/VIX/Brent vira o sinal de `e_ibov` em dias de pânico global — `2020-03-19` (Ibov bruto +2.13%, co-movimento positivo = dia informacional/pânico) é classificado como *monetário* pela máscara residual. As máscaras bruta e BS-pré-evento o excluem (confirmado em `copom_event_diagnostics.csv`). É exatamente o mecanismo diagnosticado na nota de 2026-07-14 sobre ordenação — agora generalizado: **qualquer máscara que não dependa de resíduos contemporâneos limpa o first stage full-sample**.
3. **O controle UST 2y é inócuo** (cor 0.999 com o default; ξ_mp 5.20 → 5.06 full, 13.25 → 13.26 pre_covid): SP500/VIX já absorvem o spillover FOMC na mesma sessão. E ele **não** corrige a má-classificação de 2020-03-19 (máscara `us` também o marca monetário).
4. **A purificação pré-evento sem JK (`z_bs_purif`) é a mais fraca** — consistente com BS: a ortogonalização serve à exogeneidade, não à relevância; sem o filtro de sinal o instrumento continua diluído pelos dias informacionais (31.6% wrong-signed).

## 5. Veredito

- **(a) JK fiel?** Regra e agregação sim; insumo não — o default classifica e agrega resíduos, o original usa brutos. O JK literal (`z_jk_raw`) agora existe e é o mais forte da família na amostra completa em (6,5).
- **(b) BS fiel?** Não — o que o projeto chama de "purificação Bauer-Swanson" é uma limpeza de fator global contemporâneo (válida, mas outra coisa). A versão fiel (pré-evento) foi construída (`z_bs_purif`/`z_jk_bs_purif`).
- **(c) Faltavam variáveis?** No sentido BS, sim — preditores pré-Copom (financeiros 65d + Focus). No sentido contemporâneo, não — o único candidato exógeno adicional (UST 2y) é redundante, e domésticos contemporâneos seriam bad control.
- **(d) Impacta ξ_mp?** Sim, mas pelo canal da **máscara**: trocar a classificação residual-contemporânea por qualquer classificação predeterminada (bruta ou BS-pré-evento) tira o default de ξ_mp ≈ 5.2 para ≈ 6.9–7.0 no full (6,5) e destrava 6/14 células ≥ 10; os valores purificados em si movem < 0.5. No pre_covid o default continua o mais forte (13.25), com `z_jk_bs_purif` logo atrás (12.49).

**Recomendação (não aplicada — decisão de default é do autor):** `z_jk_bs_purif` é o candidato metodologicamente mais limpo — é o único que (i) implementa a ortogonalização de BS como descrita no artigo, (ii) mantém a máscara livre de resíduos contemporâneos (≈ máscara bruta), (iii) fica a Δ0.1 do máximo full-sample e ≥ 12 no pre_covid. Se a prioridade for fidelidade literal a JK sem camada de purificação, `z_jk_raw` empata em força. `z_jk_purif_us` pode ser descartada (redundante); `z_bs_purif` fica como descritor (mostra que ortogonalização sem filtro de sinal não dá relevância).

Artefatos: `output/instrument/mosw_strength_grid.{csv,md}` (392 células), `output/instrument/instrument_diagnostics_report.md` (13 variantes), `data/processed/instrumentos_mensais.csv` (14 colunas z_*), `data/processed/copom_event_diagnostics.csv` (máscaras bs/us adicionadas), `R/data_download/focus_fred.R` (novo).
