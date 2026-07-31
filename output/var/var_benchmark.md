# Benchmark VAR pequeno contra o DFM

> **Corpo gerado por `script/model_var.R`. Reescrito por inteiro a cada**
> **execução — não escrever prosa aqui.** A leitura interpretativa fica em
> `relatorio/working-notes/2026-07-31_benchmark_var_vs_dfm.md`.

Tradução de `codigo_alessi-mark/MAIN_VARloop.m`. Core `{ind_transformacao, price_ipca, yield_6m}`, `mp_var = yield_6m` (a terceira core, como em `RUN_MAIN_US.m:9`), 18 VARs de 4 variáveis, p = 6, h = 48, nboot = 800, seed = 123, bandas 68%/90%, instrumento `z_jk_bs_purif`, painel 153 x 106 (2013-01-01 a 2025-09-01).

AK reporta percentis 5/10/90/95 (bandas de 90% e 80%); aqui são 68/90, para casar com `irf_coherence_cell.rds`.

## Regra de leitura, fixada antes dos números

- *mais forte* = |IRF_DFM(pico)| > |IRF_VAR(pico)|;
- *mais rápido* = h do pico do DFM < h do pico do VAR.

**Correção da régua, aplicada depois de olhar a figura de ações e antes de
escrever o veredito.** O extremo global do DFM tem sinal **oposto** ao do
impacto nas 8 séries de ações: a IRF vira positiva por volta de h = 5 e chega
a +20 em h ≈ 24, enquanto o VAR pequeno segue negativo. Comparar |extremo|
põe uma alta de médio prazo contra uma queda e chama isso de "mais forte".
Passa a valer o **pico de mesmo sinal do impacto** — o extremo dentro do
primeiro trecho contíguo em que a resposta conserva o sinal de h = 0 — e a
**razão de impacto**, que é o mesmo objeto nos dois modelos e concorda em
sinal em 18 de 18. O pico bruto continua tabelado, com a bandeira de sinal.

Com a identificação mantida fixa, isto testa **DFM contra VAR pequeno**, não
"contra a literatura", que identifica por Cholesky.

## Placar

**Todas as respostas** (n = 18)

- *mais forte no impacto*: **16 de 18** (razão mediana **2.32**).
- *mais forte no pico de mesmo sinal*: **16 de 18** (razão mediana **1.61**).
- *mais rápido* (pico de mesmo sinal): **9 de 18**.
- banda de 68% do DFM mais **estreita** no impacto: 0 de 18 (razão mediana **4.35**).
- mesmo sinal no impacto: 18 de 18. Células sig90: DFM **37**, VAR **266** (em h ≤ 12: 37 e 129).
- *(pico bruto, a régua contaminada: forte 18 de 18, rápido 4 de 18 — mas o pico do DFM tem sinal **oposto** ao do impacto em 8 de 18)*

**Bloco de ações (8 índices)** (n = 8)

- *mais forte no impacto*: **7 de 8** (razão mediana **2.98**).
- *mais forte no pico de mesmo sinal*: **7 de 8** (razão mediana **1.31**).
- *mais rápido* (pico de mesmo sinal): **7 de 8**.
- banda de 68% do DFM mais **estreita** no impacto: 0 de 8 (razão mediana **4.71**).
- mesmo sinal no impacto: 8 de 8. Células sig90: DFM **0**, VAR **132** (em h ≤ 12: 0 e 68).
- *(pico bruto, a régua contaminada: forte 8 de 8, rápido 0 de 8 — mas o pico do DFM tem sinal **oposto** ao do impacto em 6 de 8)*

E há uma segunda razão para desconfiar do pico bruto: a nota de 2026-07-31
sobre o espectro da companion mostra que o extremo de médio prazo do DFM *é*
a oscilação amortecida do par complexo dominante — apagar o par inverte o
vale em 12 de 14 séries. Pontuar o DFM por um pico em h = 23-48 seria
pontuá-lo justamente onde aquela análise diz não haver evidência independente.

## Comparação por resposta

| var | grupo | h0_DFM | h0_VAR | razao_impacto | peak_ss_h_DFM | peak_ss_val_DFM | peak_ss_h_VAR | peak_ss_val_VAR | razao_pico_ss | razao_banda_h0 | n_sig90_DFM | n_sig90_VAR |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | acoes | -1.6726 | -0.4985 | 3.3551 | 1 | -3.1089 | 9 | -2.4640 | 1.2617 | 4.8918 | 0 | 18 |
| asset_idiv | acoes | -2.0376 | -0.4840 | 4.2096 | 1 | -3.5691 | 3 | -2.2664 | 1.5748 | 4.7430 | 0 | 3 |
| asset_ifix | acoes | -1.0345 | -0.3594 | 2.8780 | 48 | -33.3432 | 4 | -1.4772 | 22.5719 | 4.9547 | 0 | 7 |
| asset_ifnc | acoes | -1.9749 | -0.6425 | 3.0738 | 1 | -3.2662 | 3 | -2.4529 | 1.3316 | 4.4681 | 0 | 5 |
| asset_imat | acoes | -0.3149 | -0.6465 | 0.4871 | 1 | -0.4846 | 23 | -4.7013 | 0.1031 | 3.5305 | 0 | 18 |
| asset_imob | acoes | -2.8947 | -2.3258 | 1.2446 | 1 | -5.4931 | 8 | -4.2655 | 1.2878 | 4.2580 | 0 | 14 |
| asset_mlcx | acoes | -1.7357 | -0.5293 | 3.2791 | 1 | -3.2915 | 9 | -2.3952 | 1.3742 | 4.7299 | 0 | 18 |
| asset_smll | acoes | -2.6765 | -1.6267 | 1.6453 | 1 | -5.3572 | 9 | -5.0770 | 1.0552 | 4.6842 | 0 | 49 |
| cambio_usd | cambio | 0.1498 | 0.0440 | 3.4041 | 1 | 0.1937 | 3 | 0.0839 | 2.3096 | 3.7858 | 5 | 5 |
| cds_5y | risco | 29.0673 | 12.5312 | 2.3196 | 1 | 31.9081 | 1 | 13.0316 | 2.4485 | 4.1755 | 5 | 6 |
| embi_perc | risco | 0.1995 | 0.1156 | 1.7261 | 1 | 0.2019 | 3 | 0.1474 | 1.3695 | 4.0407 | 2 | 10 |
| ibc_br | extensao | -0.3930 | -0.2378 | 1.6528 | 0 | -0.3930 | 0 | -0.2378 | 1.6528 | 3.7980 | 0 | 1 |
| price_core_ipca_ex0 | extensao | 0.0183 | 0.0326 | 0.5623 | 5 | 0.1310 | 0 | 0.0326 | 4.0244 | 4.4370 | 6 | 16 |
| price_ipp | acoes | 0.5859 | 0.1440 | 4.0677 | 1 | 0.8810 | 1 | 0.1628 | 5.4114 | 3.5286 | 5 | 20 |
| spread_icc_fisica | risco | -0.0306 | -0.0082 | 3.7384 | 1 | -0.0504 | 1 | -0.0163 | 3.0970 | 3.8343 | 0 | 15 |
| spread_icc_juridica | risco | -0.0162 | -0.0118 | 1.3701 | 1 | -0.0203 | 1 | -0.0204 | 0.9974 | 3.6090 | 0 | 25 |
| yield_10y | extensao | 0.0081 | 0.0035 | 2.3234 | 1 | 0.0092 | 1 | 0.0041 | 2.2490 | 4.8049 | 7 | 19 |
| yield_2y | extensao | 0.0092 | 0.0063 | 1.4566 | 1 | 0.0107 | 0 | 0.0063 | 1.7018 | 4.6795 | 7 | 17 |

Pico bruto (o extremo global), com a bandeira de sinal:

| var | peak_h_DFM | peak_val_DFM | peak_sinal_igual_h0_DFM | peak_h_VAR | peak_val_VAR | peak_sinal_igual_h0_VAR | razao_pico |
|---|---|---|---|---|---|---|---|
| asset_ibov | 24 | 20.2624 | FALSE | 9 | -2.4640 | TRUE | 8.2233 |
| asset_idiv | 32 | 28.6111 | FALSE | 3 | -2.2664 | TRUE | 12.6242 |
| asset_ifix | 48 | -33.3432 | TRUE | 4 | -1.4772 | TRUE | 22.5719 |
| asset_ifnc | 37 | 48.0807 | FALSE | 3 | -2.4529 | TRUE | 19.6014 |
| asset_imat | 48 | -18.0373 | TRUE | 23 | -4.7013 | TRUE | 3.8367 |
| asset_imob | 33 | 22.8811 | FALSE | 8 | -4.2655 | TRUE | 5.3642 |
| asset_mlcx | 24 | 16.9909 | FALSE | 9 | -2.3952 | TRUE | 7.0936 |
| asset_smll | 23 | 11.4117 | FALSE | 9 | -5.0770 | TRUE | 2.2477 |
| cambio_usd | 1 | 0.1937 | TRUE | 3 | 0.0839 | TRUE | 2.3096 |
| cds_5y | 1 | 31.9081 | TRUE | 1 | 13.0316 | TRUE | 2.4485 |
| embi_perc | 1 | 0.2019 | TRUE | 3 | 0.1474 | TRUE | 1.3695 |
| ibc_br | 11 | -0.5000 | TRUE | 0 | -0.2378 | TRUE | 2.1027 |
| price_core_ipca_ex0 | 5 | 0.1310 | TRUE | 5 | 0.0511 | TRUE | 2.5629 |
| price_ipp | 1 | 0.8810 | TRUE | 1 | 0.1628 | TRUE | 5.4114 |
| spread_icc_fisica | 11 | 0.1344 | FALSE | 17 | 0.1151 | FALSE | 1.1682 |
| spread_icc_juridica | 11 | 0.0724 | FALSE | 26 | 0.0606 | FALSE | 1.1960 |
| yield_10y | 1 | 0.0092 | TRUE | 1 | 0.0041 | TRUE | 2.2490 |
| yield_2y | 1 | 0.0107 | TRUE | 0 | 0.0063 | TRUE | 1.7018 |

## Estabilidade das respostas core entre os VARs

Se o VAR pequeno fosse instável, a mesma variável core teria respostas muito diferentes conforme a quarta variável. Amplitude entre os 18 VARs:

| core | h | min | mediana | max | amplitude |
|---|---|---|---|---|---|
| ind_transformacao | 0 | -1.1849 | -0.7459 | -0.2325 | 0.9524 |
| ind_transformacao | 6 | -0.4105 | 0.0066 | 0.5082 | 0.9187 |
| ind_transformacao | 12 | -0.5276 | -0.3730 | 0.0248 | 0.5524 |
| ind_transformacao | 24 | -0.1859 | -0.0726 | 0.0352 | 0.2211 |
| price_ipca | 0 | -0.0632 | -0.0318 | 0.0254 | 0.0886 |
| price_ipca | 6 | 0.0208 | 0.0465 | 0.0597 | 0.0389 |
| price_ipca | 12 | -0.0228 | -0.0131 | -0.0045 | 0.0183 |
| price_ipca | 24 | -0.0266 | -0.0243 | -0.0175 | 0.0091 |
| yield_6m | 0 | 0.0050 | 0.0050 | 0.0050 | 0.0000 |
| yield_6m | 6 | 0.0051 | 0.0075 | 0.0080 | 0.0030 |
| yield_6m | 12 | 0.0038 | 0.0076 | 0.0086 | 0.0048 |
| yield_6m | 24 | -0.0001 | 0.0028 | 0.0035 | 0.0036 |

## Diagnóstico da estimação

| var | max_eig | explosivo | n_inst | replicas_falhas |
|---|---|---|---|---|
| embi_perc | 0.9567 | FALSE | 147 | 0 |
| cds_5y | 0.9611 | FALSE | 147 | 0 |
| spread_icc_fisica | 0.9808 | FALSE | 147 | 0 |
| spread_icc_juridica | 0.9800 | FALSE | 147 | 0 |
| cambio_usd | 0.9666 | FALSE | 147 | 0 |
| asset_ibov | 0.9611 | FALSE | 147 | 0 |
| asset_idiv | 0.9583 | FALSE | 147 | 0 |
| asset_ifix | 0.9548 | FALSE | 147 | 0 |
| asset_ifnc | 0.9626 | FALSE | 147 | 0 |
| asset_imat | 0.9576 | FALSE | 147 | 0 |
| asset_imob | 0.9594 | FALSE | 147 | 0 |
| asset_mlcx | 0.9613 | FALSE | 147 | 0 |
| asset_smll | 0.9585 | FALSE | 147 | 0 |
| price_ipp | 0.9597 | FALSE | 147 | 0 |
| yield_2y | 0.9485 | FALSE | 147 | 0 |
| yield_10y | 0.9550 | FALSE | 147 | 0 |
| ibc_br | 1.0076 | TRUE | 147 | 0 |
| price_core_ipca_ex0 | 0.9599 | FALSE | 147 | 0 |

⚠ **1 VAR(s) com companion explosiva** (max |λ| ≥ 1): `ibc_br` (1.008). São 4 variáveis × 6 defasagens = 25 parâmetros por equação em 147 observações; a correção de Kilian não encontra `delta` que estabilize e emite aviso. É o custo de dimensionalidade do VAR pequeno, medido.
