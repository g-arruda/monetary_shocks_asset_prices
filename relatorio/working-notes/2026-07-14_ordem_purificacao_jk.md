# Ordem purificação ↔ filtro JK: variantes de máscara bruta (2026-07-14)

## Motivação e descoberta

Pedido original: criar um instrumento "z_t → purificação → filtro JK", sob a premissa de que o `z_jk_purif` atual fosse "JK → purificação". A leitura de `script/instrument.R` mostrou que a premissa estava invertida: **o pipeline atual já purifica primeiro** — os resíduos `e_di`/`e_ibov` (regressão de `delta_di` e `r_ibov` em SP500/VIX/Brent sobre o painel completo de quintas-feiras) são calculados antes, e a classificação JK usa os **sinais dos resíduos** (`sign(e_di) != sign(e_ibov)`). A ordenação que não existia era a inversa: máscara JK decidida pelos **sinais brutos** (`delta_di` × `r_ibov`), purificação depois.

## Variantes construídas (`script/instrument.R`, 2026-07-14)

1. **`z_jk_raw_purif`** — máscara JK nos sinais brutos (`sign(delta_di) != sign(r_ibov)`, ambos ≠ 0, dias Copom); valores agregados = `e_di` da mesma regressão de purificação de painel completo. Isola o efeito da ordem: só muda *quais dias* são classificados como monetários.
2. **`z_jk_raw_purif_local`** — mesma máscara bruta; regressão de purificação re-estimada **apenas nos 55 dias Copom selecionados**; agrega os resíduos locais. Ordenação "JK → purificação" literal.

Novos artefatos: colunas em `instrumentos_mensais.csv`, CSVs individuais `instrument_jk_raw_purif{,_local}.csv`, colunas `jk_monetary_raw`/`e_di_local` em `copom_event_diagnostics.csv`.

## Sobreposição das máscaras (95 dias Copom, 2013-01–2025-12)

| máscara | monetários |
|---|---|
| residual (`z_jk_purif`) | 65 |
| bruta (`z_jk_raw_*`) | 55 |
| interseção | 51 |

14 dias saem (residual-só) e 4 entram (bruta-só). Os flips relevantes:

- **Saem da máscara bruta:** `2020-03-19` (ΔDI +15.5 bp, Ibov bruto **+2.13%** — co-movimento positivo bruto = dia de pânico/informação COVID; a purificação virou `e_ibov` para −0.23 e o classificou como monetário) e `2022-02-03` (ΔDI −19.5 bp). Vários dos demais são dias com ΔDI bruto ≈ 0–1 bp em que só o resíduo tem sinal (classificação frágil).
- **Entram na máscara bruta:** `2016-01-21` (ΔDI −28 bp — o Copom que surpreendeu ao não subir juros), `2016-04-28` (+12.5 bp), `2018-06-21`, `2019-02-07`.

Correlações mensais: cor(`z_jk_purif`, `z_jk_raw_purif`) = **0.895**; cor(`z_jk_purif`, `z_jk_raw_purif_local`) = 0.867; cor entre as duas novas = 0.957.

## Grid MOSW (ξ_mp e F conjunta; `script/mosw_strength_grid.R`, agora 10 instrumentos × 14 (r,q) × 2 amostras = 280 células)

### Especificação de produção (r=6, q=5)

| amostra | instrumento | ξ_mp | F conjunta | p | F legada (max-F) |
|---|---|---:|---:|---:|---:|
| full | **z_jk_raw_purif** | **6.61** | 1.85 | 0.10 | 5.53 |
| full | z_jk_purif | 5.20 | 2.06 | 0.07 | 10.08 |
| full | z_jk_raw_purif_local | 4.60 | 2.00 | 0.07 | 6.38 |
| pre_covid | z_jk_purif | **13.25** | 3.61 | 0.00 | 15.40 |
| pre_covid | z_jk_raw_purif | 10.80 | 2.53 | 0.03 | 11.95 |
| pre_covid | z_jk_raw_purif_local | 10.49 | 2.65 | 0.02 | 13.64 |

No full (6,5), `z_jk_raw_purif` é o **mais forte dos 10 instrumentos** em ξ_mp (6.61 > z_het_jk 6.26 > z_jk 5.47 > z_jk_purif 5.20) — ainda < 10, mas nenhum instrumento cruza 10 no full em (6,5).

### Padrão cell-by-cell (ξ_mp)

- **Full:** `z_jk_raw_purif` > `z_jk_purif` em **13/14 células**, com gap crescente em r (até +7.1 em (8,8)); cruza ξ_mp ≥ 10 em **6/14 células** ((7,7) e todo r=8), enquanto `z_jk_purif` não cruza em **nenhuma** (max 6.67). Mediana full: 9.41 vs 5.53.
- **Pre_covid:** ranking inverte — `z_jk_purif` vence em 11/14; em (6,5): 13.25 vs 10.80. Mas `z_jk_raw_purif` ainda cruza 10 nas células r=6 (12.01/10.80/10.98). r=7,8 colapsa para todos (T=84).
- **`z_jk_raw_purif_local`** é dominada por `z_jk_raw_purif` em quase todas as células (26/28) — a re-estimação local (~50 obs) só adiciona ruído. **Descartar como candidata.**

### Nota sobre a F legada

Em full (6,5) a max-F homocedástica diz o contrário (z_jk_purif 10.08 vs raw 5.53). Vale a leitura de 2026-07-14 (`mosw_strength_grid.md`): a **ξ_mp** (Eicker-White + correção Shat, validada contra `codigo_olea/`) é a régua rigorosa; a max-F legada já superestimou a força das variantes het antes.

## Veredito: tem vantagem?

**Sim, uma vantagem específica e interpretável — mas não muda o default.**

1. **Vantagem (full sample):** `z_jk_raw_purif` é sistematicamente mais forte que `z_jk_purif` na amostra completa sob a régua ξ_mp (13/14 células, único da família GK a cruzar 10 em células full). A leitura estrutural: a máscara residual classifica `2020-03-19` (pânico COVID) como choque monetário só porque a purificação vira o sinal do Ibov — a máscara bruta remove esse dia e outros flips frágeis (ΔDI ≈ 0), limpando o first stage exatamente na janela que enfraquecia `z_jk_purif`. Ou seja: **parte da fraqueza full-sample de `z_jk_purif` é má-classificação da máscara em dias COVID, não só variância do período**.
2. **Não-vantagem (pre_covid, janela-vitrine):** em (6,5) pre_covid `z_jk_purif` segue superior (13.25 vs 10.80) — o default fica.
3. **Uso recomendado:** manter `z_jk_purif` como default (`DEFAULT_VARIANT` inalterado); promover `z_jk_raw_purif` a **instrumento de robustez full-sample** — é o candidato natural quando a análise precisa da amostra completa (onde hoje nenhum instrumento cruza 10 em (6,5), e ele chega mais perto e cruza em r ≥ 7). Descartar `z_jk_raw_purif_local`.

Artefatos: `output/instrument/mosw_strength_grid.{csv,md}` (regenerados, 280 células), `data/processed/instrumentos_mensais.csv` (10 colunas z_*).
