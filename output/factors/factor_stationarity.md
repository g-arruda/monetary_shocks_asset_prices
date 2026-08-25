# Estacionariedade, cointegração e espectro da companion

> **Corpo gerado por `script/factor_stationarity.R`. Reescrito por inteiro a**
> **cada execução — não escrever prosa aqui.** A leitura interpretativa fica em
> `notas/2026-07-31_estacionariedade_fatores.md`.

Spec: r = 5, q = 5, p = 4, instrumento `z_jk_bs_purif`, painel 153 x 111 (2013-01-01 a 2025-09-01).

## 1. Espectro da companion (produção: OLS, p = 4)

| ordem | modulo | complexo | periodo_meses | quarto_ciclo | meia_volta_ciclo | meia_vida_meses |
|---|---|---|---|---|---|---|
| 1 | 0.9681 | FALSE | NA | NA | NA | 21.3982 |
| 2 | 0.9606 | TRUE | 73.3778 | 18.3444 | 36.6889 | 17.2581 |
| 3 | 0.9606 | TRUE | 73.3778 | 18.3444 | 36.6889 | 17.2581 |
| 4 | 0.8463 | FALSE | NA | NA | NA | 4.1548 |
| 5 | 0.7853 | TRUE | 26.1808 | 6.5452 | 13.0904 | 2.8679 |
| 6 | 0.7853 | TRUE | 26.1808 | 6.5452 | 13.0904 | 2.8679 |
| 7 | 0.6846 | TRUE | 3.2779 | 0.8195 | 1.6389 | 1.8295 |
| 8 | 0.6846 | TRUE | 3.2779 | 0.8195 | 1.6389 | 1.8295 |

Raiz dominante: |λ| = 0.968126, real.

Raízes com |λ| > 0,97: 0. Com |λ| > 0,90: 3. Explosivas (|λ| ≥ 1): 0.

### Sensibilidade à ordem de defasagem

| matriz | p | max_mod | n_complexo | per_dominante |
|---|---|---|---|---|
| Kilian | 1 | 0.9971 | 4 | 131.2559 |
| Kilian | 4 | 0.9998 | 16 | NA |
| Kilian | 6 | 0.9754 | 28 | 71.9503 |
| OLS | 1 | 0.9907 | 4 | 119.4659 |
| OLS | 4 | 0.9681 | 16 | NA |
| OLS | 6 | 0.9649 | 28 | 65.7502 |

## 2. Raiz unitária nos 5 fatores (ADF / PP / KPSS, 5%, spec drift-mu)

| fator | transf | ADF | PP | KPSS | veredito |
|---|---|---|---|---|---|
| F1 | nivel | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F1 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F2 | nivel | FALSE | FALSE | TRUE | I(1) - ADF e KPSS concordam |
| F2 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F3 | nivel | FALSE | FALSE | FALSE | ambiguo |
| F3 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F4 | nivel | FALSE | FALSE | TRUE | I(1) - ADF e KPSS concordam |
| F4 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F5 | nivel | FALSE | FALSE | TRUE | I(1) - ADF e KPSS concordam |
| F5 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |

Fatores I(1) em nível: **3 de 5**. I(0) em primeira diferença: **5 de 5**.

## 3. Phillips-Perron nas 111 séries do painel

PP rejeita a raiz unitária a 5% em **38 de 111** séries.

| veredito_adf_kpss | pp_rejeita_RU_5pct | n |
|---|---|---|
| I(0) — os dois concordam | TRUE | 20 |
| I(1) — os dois concordam | FALSE | 62 |
| ambiguo | FALSE | 11 |
| ambiguo | TRUE | 18 |

## 4. Cointegração de Johansen (n = 5)

| K | tipo | posto_5pct | posto_5pct_ra |
|---|---|---|---|
| 2 | eigen | 3 | 3 |
| 2 | trace | 3 | 3 |
| 4 | eigen | 0 | 0 |
| 4 | trace | 2 | 1 |
| 6 | eigen | 0 | 0 |
| 6 | trace | 1 | 0 |

Na defasagem de produção (K = 4), traço: posto **2** (1 com Reinsel-Ahn) — 3 tendências comuns.

| tipo | r0 | stat | cv5 | rejeita_5pct | stat_reinsel_ahn | rejeita_5pct_ra |
|---|---|---|---|---|---|---|
| eigen | 0 | 33.105 | 34.40 | FALSE | 28.662 | FALSE |
| eigen | 1 | 26.116 | 28.14 | FALSE | 22.611 | FALSE |
| eigen | 2 | 22.127 | 22.00 | TRUE | 19.157 | FALSE |
| eigen | 3 | 10.387 | 15.67 | FALSE | 8.993 | FALSE |
| eigen | 4 | 2.326 | 9.24 | FALSE | 2.014 | FALSE |
| trace | 0 | 94.061 | 76.07 | TRUE | 81.436 | TRUE |
| trace | 1 | 60.956 | 53.12 | TRUE | 52.774 | FALSE |
| trace | 2 | 34.840 | 34.91 | FALSE | 30.164 | FALSE |
| trace | 3 | 12.713 | 19.96 | FALSE | 11.007 | FALSE |
| trace | 4 | 2.326 | 9.24 | FALSE | 2.014 | FALSE |

## 5. Regra R1 — reversão observada contra o marco mecânico

