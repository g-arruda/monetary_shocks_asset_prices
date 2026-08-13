# Estacionariedade, cointegração e espectro da companion

> **Corpo gerado por `script/factor_stationarity.R`. Reescrito por inteiro a**
> **cada execução — não escrever prosa aqui.** A leitura interpretativa fica em
> `notas/2026-07-31_estacionariedade_fatores.md`.

Spec: r = 7, q = 6, p = 6, instrumento `z_jk_bs_purif`, painel 153 x 106 (2013-01-01 a 2025-09-01).

## 1. Espectro da companion (produção: OLS, p = 6)

| ordem | modulo | complexo | periodo_meses | quarto_ciclo | meia_volta_ciclo | meia_vida_meses |
|---|---|---|---|---|---|---|
| 1 | 0.9747 | TRUE | 119.6226 | 29.9056 | 59.8113 | 27.1021 |
| 2 | 0.9747 | TRUE | 119.6226 | 29.9056 | 59.8113 | 27.1021 |
| 3 | 0.9594 | TRUE | 54.6128 | 13.6532 | 27.3064 | 16.7244 |
| 4 | 0.9594 | TRUE | 54.6128 | 13.6532 | 27.3064 | 16.7244 |
| 5 | 0.9023 | TRUE | 42.2808 | 10.5702 | 21.1404 | 6.7413 |
| 6 | 0.9023 | TRUE | 42.2808 | 10.5702 | 21.1404 | 6.7413 |
| 7 | 0.8611 | TRUE | 2.9738 | 0.7435 | 1.4869 | 4.6365 |
| 8 | 0.8611 | TRUE | 2.9738 | 0.7435 | 1.4869 | 4.6365 |

Raiz dominante: |λ| = 0.974749, **complexa**, período 119.6 meses (quarto de ciclo 29.9, meia-volta 59.8).

Raízes com |λ| > 0,97: 2. Com |λ| > 0,90: 6. Explosivas (|λ| ≥ 1): 0.

### Sensibilidade à ordem de defasagem

| matriz | p | max_mod | n_complexo | per_dominante |
|---|---|---|---|---|
| Kilian | 1 | 0.9999 | 4 | NA |
| Kilian | 4 | 0.9897 | 24 | NA |
| Kilian | 6 | 0.9802 | 40 | 157.0029 |
| OLS | 1 | 0.9857 | 4 | NA |
| OLS | 4 | 0.9657 | 24 | 93.8299 |
| OLS | 6 | 0.9747 | 40 | 119.6226 |

## 2. Raiz unitária nos 7 fatores (ADF / PP / KPSS, 5%, spec drift-mu)

| fator | transf | ADF | PP | KPSS | veredito |
|---|---|---|---|---|---|
| F1 | nivel | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F1 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F2 | nivel | FALSE | FALSE | TRUE | I(1) - ADF e KPSS concordam |
| F2 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F3 | nivel | FALSE | FALSE | FALSE | ambiguo |
| F3 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F4 | nivel | FALSE | FALSE | TRUE | I(1) - ADF e KPSS concordam |
| F4 | diferenca | TRUE | TRUE | TRUE | ambiguo |
| F5 | nivel | FALSE | FALSE | TRUE | I(1) - ADF e KPSS concordam |
| F5 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F6 | nivel | FALSE | FALSE | TRUE | I(1) - ADF e KPSS concordam |
| F6 | diferenca | TRUE | TRUE | TRUE | ambiguo |
| F7 | nivel | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F7 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |

Fatores I(1) em nível: **4 de 7**. I(0) em primeira diferença: **5 de 7**.

## 3. Phillips-Perron nas 106 séries do painel

PP rejeita a raiz unitária a 5% em **38 de 106** séries.

| veredito_adf_kpss | pp_rejeita_RU_5pct | n |
|---|---|---|
| I(0) — os dois concordam | TRUE | 20 |
| I(1) — os dois concordam | FALSE | 57 |
| ambiguo | FALSE | 11 |
| ambiguo | TRUE | 18 |

## 4. Cointegração de Johansen (n = 7)

| K | tipo | posto_5pct | posto_5pct_ra |
|---|---|---|---|
| 2 | eigen | 4 | 4 |
| 2 | trace | 4 | 4 |
| 4 | eigen | 1 | 1 |
| 4 | trace | 1 | 0 |
| 6 | eigen | 1 | 0 |
| 6 | trace | 2 | 0 |

Na defasagem de produção (K = 6), traço: posto **2** (0 com Reinsel-Ahn) — 5 tendências comuns.

| tipo | r0 | stat | cv5 | rejeita_5pct | stat_reinsel_ahn | rejeita_5pct_ra |
|---|---|---|---|---|---|---|
| eigen | 0 | 58.257 | 46.45 | TRUE | 41.612 | FALSE |
| eigen | 1 | 33.193 | 40.30 | FALSE | 23.709 | FALSE |
| eigen | 2 | 27.329 | 34.40 | FALSE | 19.521 | FALSE |
| eigen | 3 | 16.621 | 28.14 | FALSE | 11.872 | FALSE |
| eigen | 4 | 11.290 | 22.00 | FALSE | 8.064 | FALSE |
| eigen | 5 | 9.698 | 15.67 | FALSE | 6.927 | FALSE |
| eigen | 6 | 4.931 | 9.24 | FALSE | 3.522 | FALSE |
| trace | 0 | 161.319 | 131.70 | TRUE | 115.228 | FALSE |
| trace | 1 | 103.062 | 102.14 | TRUE | 73.616 | FALSE |
| trace | 2 | 69.869 | 76.07 | FALSE | 49.906 | FALSE |
| trace | 3 | 42.540 | 53.12 | FALSE | 30.386 | FALSE |
| trace | 4 | 25.919 | 34.91 | FALSE | 18.514 | FALSE |
| trace | 5 | 14.629 | 19.96 | FALSE | 10.449 | FALSE |
| trace | 6 | 4.931 | 9.24 | FALSE | 3.522 | FALSE |

## 5. Regra R1 — reversão observada contra o marco mecânico

| var | h_inversao | meia_volta | dentro_25pct_meia_volta | h_extremo | h_extremo_mp | quarto_ciclo | dentro_25pct_quarto_mp |
|---|---|---|---|---|---|---|---|
| yield_3m | 14 | 59.81 | FALSE | 33 | 33 | 29.91 | TRUE |
| yield_6m | 13 | 59.81 | FALSE | 32 | 32 | 29.91 | TRUE |
| yield_2y | 12 | 59.81 | FALSE | 1 | 26 | 29.91 | TRUE |
| yield_10y | 12 | 59.81 | FALSE | 1 | 23 | 29.91 | TRUE |
| juros_selic | 2 | 59.81 | FALSE | 34 | 34 | 29.91 | TRUE |
| cds_5y | 12 | 59.81 | FALSE | 1 | 23 | 29.91 | TRUE |
| embi_perc | 11 | 59.81 | FALSE | 1 | 23 | 29.91 | TRUE |
| cambio_usd | 11 | 59.81 | FALSE | 1 | 17 | 29.91 | FALSE |
| credit_outstanding | 9 | 59.81 | FALSE | 30 | 30 | 29.91 | TRUE |
| credito_pessoa_fisica | 2 | 59.81 | FALSE | 33 | 33 | 29.91 | TRUE |
| credito_comercio | 4 | 59.81 | FALSE | 27 | 27 | 29.91 | TRUE |
| credito_construcao | 4 | 59.81 | FALSE | 30 | 30 | 29.91 | TRUE |
| credito_industria_total | 6 | 59.81 | FALSE | 26 | 26 | 29.91 | TRUE |
| credito_agro | 11 | 59.81 | FALSE | 26 | 26 | 29.91 | TRUE |

Inversão de sinal dentro de ±25% da meia-volta (59.8 meses): **0 de 14**.
Extremo **global** dentro de ±25% do quarto de ciclo (29.9 meses): **9 de 14**.
Extremo de **médio prazo** (h ≥ 13) dentro de ±25% do quarto de ciclo: **13 de 14**.

## 6. O vale de médio prazo acompanha a ordem de defasagem?

| p | dominante_complexa | quarto_ciclo | mediana_h_extremo_mp |
|---|---|---|---|
| 1 | FALSE | NA | 31.5 |
| 4 | TRUE | 23.46 | 29.5 |
| 6 | TRUE | 29.91 | 26.5 |

| var | h_mp_p1 | h_mp_p4 | h_mp_p6 |
|---|---|---|---|
| yield_3m | 35 | 33 | 33 |
| yield_6m | 34 | 32 | 32 |
| yield_2y | 31 | 29 | 26 |
| yield_10y | 28 | 27 | 23 |
| juros_selic | 36 | 34 | 34 |
| cds_5y | 27 | 26 | 23 |
| embi_perc | 26 | 26 | 23 |
| cambio_usd | 48 | 48 | 17 |
| credit_outstanding | 32 | 30 | 30 |
| credito_pessoa_fisica | 35 | 32 | 33 |
| credito_comercio | 28 | 28 | 27 |
| credito_construcao | 32 | 30 | 30 |
| credito_industria_total | 27 | 28 | 26 |
| credito_agro | 29 | 28 | 26 |

## 7. Decomposição espectral — apagar o par dominante de `B`

⚠ **Apagar modos muda o denominador da normalização.** `B₀` só é a identidade com todos os modos (`Σₖ vₖwₖ' = I`); sem o par dominante o impacto pré-normalização de `yield_6m` passa a **-0.087** do original (sem o par 2, 1.172). Como o denominador pode trocar de sinal, magnitude e sinal são comparados na **escala comum** (multiplicando pela razão de denominadores), antes da renormalização específica de cada caminho. O **horizonte** do extremo é invariante a essa escala. Renormalizar cada caminho a +50 pb responde a outra pergunta — *"se este modo não existisse, o que faria um choque de 50 pb?"* — e não é uma decomposição aditiva. A tabela traz a escala comum.

| var | h_mp_completo | val_mp_completo | h_mp_sem_par1 | razao_sem_par1_defl | inverte_sinal_sem_par1 | vale_sobrevive_sem_par1 |
|---|---|---|---|---|---|---|
| yield_3m | 33 | -0.011 | 13 | -0.592 | TRUE | FALSE |
| yield_6m | 32 | -0.011 | 13 | -0.576 | TRUE | FALSE |
| yield_2y | 26 | -0.009 | 13 | -0.497 | TRUE | FALSE |
| yield_10y | 23 | -0.006 | 13 | -0.423 | TRUE | FALSE |
| juros_selic | 34 | -1.101 | 13 | -0.592 | TRUE | FALSE |
| cds_5y | 23 | -24.955 | 13 | -0.389 | TRUE | FALSE |
| embi_perc | 23 | -0.245 | 13 | -0.372 | TRUE | FALSE |
| cambio_usd | 17 | -0.097 | 20 | 0.988 | FALSE | TRUE |
| credit_outstanding | 30 | -1.656 | 13 | -0.445 | TRUE | FALSE |
| credito_pessoa_fisica | 33 | -1.302 | 13 | -0.502 | TRUE | FALSE |
| credito_comercio | 27 | -2.898 | 13 | -0.329 | TRUE | FALSE |
| credito_construcao | 30 | -3.243 | 13 | -0.419 | TRUE | FALSE |
| credito_industria_total | 26 | -2.102 | 13 | -0.334 | TRUE | FALSE |
| credito_agro | 26 | -1.900 | 13 | -0.403 | TRUE | FALSE |

**Inverte de sinal** ao apagar o par dominante: **13 de 14**.
Vale sobrevive (mesmo sinal **e** > 50% da magnitude em escala comum): **1 de 14**.
Razão mediana em **escala comum**: **0.434** sem o par 1, contra **0.980** sem o par 2 (controle). Renormalizando cada caminho a +50 pb seriam 4.965 e 0.836.

