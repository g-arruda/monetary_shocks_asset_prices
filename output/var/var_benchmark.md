# Benchmark VAR pequeno contra o DFM

> **Corpo gerado por `script/model_var.R`. Reescrito por inteiro a cada**
> **execução — não escrever prosa aqui.** A leitura interpretativa fica em
> `notas/2026-07-31_benchmark_var_vs_dfm.md`.

Tradução de `codigos_externos/codigo_alessi-mark/MAIN_VARloop.m`. Core `{ind_transformacao, price_ipca, yield_6m}`, `mp_var = yield_6m` (a terceira core, como em `RUN_MAIN_US.m:9`), 17 VARs de 4 variáveis, p = 6, h = 48, nboot = 800, seed = 123, bandas 68%/90%, instrumento `z_jk_bs_purif`, painel 153 x 111 (2013-01-01 a 2025-09-01).

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

**Todas as respostas** (n = 17)

- *mais forte no impacto*: **13 de 17** (razão mediana **1.85**).
- *mais forte no pico de mesmo sinal*: **13 de 17** (razão mediana **1.26**).
- *mais rápido* (pico de mesmo sinal): **7 de 17**.
- banda de 68% do DFM mais **estreita** no impacto: 0 de 17 (razão mediana **2.82**).
- mesmo sinal no impacto: 16 de 17. Células sig90: DFM **57**, VAR **282** (em h ≤ 12: 57 e 123).
- *(pico bruto, a régua contaminada: forte 15 de 17, rápido 5 de 17 — mas o pico do DFM tem sinal **oposto** ao do impacto em 1 de 17)*

**Bloco de ações (8 índices)** (n = 7)

- *mais forte no impacto*: **5 de 7** (razão mediana **3.38**).
- *mais forte no pico de mesmo sinal*: **4 de 7** (razão mediana **1.06**).
- *mais rápido* (pico de mesmo sinal): **4 de 7**.
- banda de 68% do DFM mais **estreita** no impacto: 0 de 7 (razão mediana **3.22**).
- mesmo sinal no impacto: 7 de 7. Células sig90: DFM **4**, VAR **153** (em h ≤ 12: 4 e 70).
- *(pico bruto, a régua contaminada: forte 7 de 7, rápido 0 de 7 — mas o pico do DFM tem sinal **oposto** ao do impacto em 0 de 7)*

E há uma segunda razão para desconfiar do pico bruto: a nota de 2026-07-31
sobre o espectro da companion mostra que o extremo de médio prazo do DFM *é*
a oscilação amortecida do par complexo dominante — apagar o par inverte o
vale em 12 de 14 séries. Pontuar o DFM por um pico em h = 23-48 seria
pontuá-lo justamente onde aquela análise diz não haver evidência independente.

## Comparação por resposta

| var | grupo | h0_DFM | h0_VAR | razao_impacto | peak_ss_h_DFM | peak_ss_val_DFM | peak_ss_h_VAR | peak_ss_val_VAR | razao_pico_ss | razao_banda_h0 | n_sig90_DFM | n_sig90_VAR |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | acoes | -1.7227 | -0.3262 | 5.2808 | 4 | -3.2572 | 9 | -4.1354 | 0.7876 | 3.2156 | 0 | 23 |
| asset_idiv | acoes | -2.0392 | -0.3431 | 5.9441 | 4 | -4.0554 | 4 | -4.0893 | 0.9917 | 3.2468 | 0 | 9 |
| asset_ifix | acoes | -1.3106 | -0.3873 | 3.3844 | 48 | -11.7272 | 4 | -2.3436 | 5.0039 | 3.0444 | 4 | 9 |
| asset_ifnc | acoes | -2.7007 | -0.6205 | 4.3526 | 4 | -5.9123 | 4 | -3.7681 | 1.5690 | 2.9930 | 0 | 6 |
| asset_imat | acoes | -0.0691 | -0.6323 | 0.1092 | 0 | -0.0691 | 25 | -8.4730 | 0.0082 | 2.3419 | 0 | 46 |
| asset_imob | acoes | -2.5573 | -2.7179 | 0.9409 | 4 | -6.9932 | 9 | -5.8027 | 1.2052 | 3.2534 | 0 | 11 |
| asset_smll | acoes | -2.6110 | -2.0068 | 1.3011 | 4 | -7.9005 | 16 | -7.4640 | 1.0585 | 3.3315 | 0 | 49 |
| cambio_usd | cambio | 0.1579 | 0.0466 | 3.3904 | 1 | 0.1773 | 4 | 0.0955 | 1.8563 | 2.4648 | 7 | 5 |
| cds_5y | risco | 32.5417 | 13.9982 | 2.3247 | 3 | 36.7956 | 1 | 14.8560 | 2.4768 | 2.8200 | 8 | 2 |
| embi_perc | risco | 0.2620 | 0.1414 | 1.8524 | 3 | 0.2810 | 3 | 0.1695 | 1.6580 | 2.5340 | 8 | 4 |
| ibc_br | extensao | -0.4605 | -0.2835 | 1.6242 | 0 | -0.4605 | 0 | -0.2835 | 1.6242 | 2.9202 | 1 | 1 |
| price_core_ipca_ex0 | extensao | 0.0174 | 0.0304 | 0.5734 | 8 | 0.0958 | 5 | 0.0764 | 1.2536 | 2.2557 | 3 | 16 |
| price_ipp | acoes | 0.4677 | 0.1850 | 2.5283 | 1 | 0.5725 | 1 | 0.2910 | 1.9673 | 2.3513 | 4 | 21 |
| spread_icc_fisica | risco | 0.0039 | -0.0206 | 0.1879 | 0 | 0.0039 | 0 | -0.0206 | 0.1879 | 2.5870 | 0 | 15 |
| spread_icc_juridica | risco | -0.0154 | -0.0145 | 1.0587 | 1 | -0.0257 | 1 | -0.0228 | 1.1274 | 2.5383 | 0 | 25 |
| yield_10y | extensao | 0.0070 | 0.0027 | 2.5914 | 3 | 0.0097 | 6 | 0.0065 | 1.4836 | 2.6816 | 11 | 21 |
| yield_2y | extensao | 0.0074 | 0.0058 | 1.2854 | 3 | 0.0117 | 6 | 0.0093 | 1.2558 | 2.9474 | 11 | 19 |

Pico bruto (o extremo global), com a bandeira de sinal:

| var | peak_h_DFM | peak_val_DFM | peak_sinal_igual_h0_DFM | peak_h_VAR | peak_val_VAR | peak_sinal_igual_h0_VAR | razao_pico |
|---|---|---|---|---|---|---|---|
| asset_ibov | 48 | -28.8996 | TRUE | 9 | -4.1354 | TRUE | 6.9884 |
| asset_idiv | 48 | -31.0646 | TRUE | 4 | -4.0893 | TRUE | 7.5965 |
| asset_ifix | 48 | -11.7272 | TRUE | 4 | -2.3436 | TRUE | 5.0039 |
| asset_ifnc | 48 | -39.5630 | TRUE | 4 | -3.7681 | TRUE | 10.4995 |
| asset_imat | 48 | -23.8439 | TRUE | 25 | -8.4730 | TRUE | 2.8141 |
| asset_imob | 48 | -41.2534 | TRUE | 9 | -5.8027 | TRUE | 7.1093 |
| asset_smll | 48 | -32.6064 | TRUE | 16 | -7.4640 | TRUE | 4.3685 |
| cambio_usd | 1 | 0.1773 | TRUE | 4 | 0.0955 | TRUE | 1.8563 |
| cds_5y | 3 | 36.7956 | TRUE | 1 | 14.8560 | TRUE | 2.4768 |
| embi_perc | 3 | 0.2810 | TRUE | 3 | 0.1695 | TRUE | 1.6580 |
| ibc_br | 0 | -0.4605 | TRUE | 5 | 0.3265 | FALSE | 1.4105 |
| price_core_ipca_ex0 | 8 | 0.0958 | TRUE | 5 | 0.0764 | TRUE | 1.2536 |
| price_ipp | 1 | 0.5725 | TRUE | 1 | 0.2910 | TRUE | 1.9673 |
| spread_icc_fisica | 19 | 0.1295 | TRUE | 16 | 0.1775 | FALSE | 0.7297 |
| spread_icc_juridica | 20 | 0.0775 | FALSE | 25 | 0.0896 | FALSE | 0.8648 |
| yield_10y | 3 | 0.0097 | TRUE | 6 | 0.0065 | TRUE | 1.4836 |
| yield_2y | 3 | 0.0117 | TRUE | 6 | 0.0093 | TRUE | 1.2558 |

## Estabilidade das respostas core entre os VARs

Se o VAR pequeno fosse instável, a mesma variável core teria respostas muito diferentes conforme a quarta variável. Amplitude entre os 17 VARs:

| core | h | min | mediana | max | amplitude |
|---|---|---|---|---|---|
| ind_transformacao | 0 | -1.4069 | -0.9080 | -0.2409 | 1.1659 |
| ind_transformacao | 6 | -0.4676 | 0.0245 | 0.7379 | 1.2054 |
| ind_transformacao | 12 | -0.6998 | -0.4572 | -0.0514 | 0.6484 |
| ind_transformacao | 24 | -0.2509 | -0.1311 | 0.0814 | 0.3323 |
| price_ipca | 0 | -0.0773 | -0.0411 | 0.0164 | 0.0938 |
| price_ipca | 6 | 0.0343 | 0.0840 | 0.0905 | 0.0562 |
| price_ipca | 12 | -0.0332 | -0.0095 | -0.0002 | 0.0330 |
| price_ipca | 24 | -0.0436 | -0.0348 | -0.0248 | 0.0187 |
| yield_6m | 0 | 0.0050 | 0.0050 | 0.0050 | 0.0000 |
| yield_6m | 6 | 0.0079 | 0.0115 | 0.0120 | 0.0041 |
| yield_6m | 12 | 0.0059 | 0.0126 | 0.0138 | 0.0079 |
| yield_6m | 24 | -0.0002 | 0.0058 | 0.0068 | 0.0070 |

## Diagnóstico da estimação

| var | max_eig | explosivo | n_inst | replicas_falhas |
|---|---|---|---|---|
| embi_perc | 0.9603 | FALSE | 147 | 0 |
| cds_5y | 0.9621 | FALSE | 147 | 0 |
| spread_icc_fisica | 0.9777 | FALSE | 147 | 0 |
| spread_icc_juridica | 0.9798 | FALSE | 147 | 0 |
| cambio_usd | 0.9669 | FALSE | 147 | 0 |
| asset_ibov | 0.9638 | FALSE | 147 | 0 |
| asset_idiv | 0.9609 | FALSE | 147 | 0 |
| asset_ifix | 0.9544 | FALSE | 147 | 0 |
| asset_ifnc | 0.9647 | FALSE | 147 | 0 |
| asset_imat | 0.9555 | FALSE | 147 | 0 |
| asset_imob | 0.9615 | FALSE | 147 | 0 |
| asset_smll | 0.9604 | FALSE | 147 | 0 |
| price_ipp | 0.9638 | FALSE | 147 | 0 |
| yield_2y | 0.9531 | FALSE | 147 | 0 |
| yield_10y | 0.9549 | FALSE | 147 | 0 |
| ibc_br | 1.0082 | TRUE | 147 | 0 |
| price_core_ipca_ex0 | 0.9629 | FALSE | 147 | 0 |

⚠ **1 VAR(s) com companion explosiva** (max |λ| ≥ 1): `ibc_br` (1.008). São 4 variáveis × 6 defasagens = 25 parâmetros por equação em 147 observações; a correção de Kilian não encontra `delta` que estabilize e emite aviso. É o custo de dimensionalidade do VAR pequeno, medido.
