# Estacionariedade, cointegração e espectro da companion

> **Corpo gerado por `script/factor_stationarity.R`. Reescrito por inteiro a**
> **cada execução — não escrever prosa aqui.** A leitura interpretativa fica em
> `relatorio/working-notes/2026-07-31_estacionariedade_fatores.md`.

Spec: r = 7, q = 6, p = 6, instrumento `z_jk_bs_purif`, painel 153 x 106 (2013-01-01 a 2025-09-01).

## 1. Espectro da companion (produção: OLS, p = 6)

| ordem | modulo | complexo | periodo_meses | quarto_ciclo | meia_volta_ciclo | meia_vida_meses |
|---|---|---|---|---|---|---|
| 1 | 0.9768 | TRUE | 117.8992 | 29.4748 | 58.9496 | 29.5210 |
| 2 | 0.9768 | TRUE | 117.8992 | 29.4748 | 58.9496 | 29.5210 |
| 3 | 0.9610 | TRUE | 56.3586 | 14.0897 | 28.1793 | 17.4180 |
| 4 | 0.9610 | TRUE | 56.3586 | 14.0897 | 28.1793 | 17.4180 |
| 5 | 0.9100 | TRUE | 37.6646 | 9.4161 | 18.8323 | 7.3523 |
| 6 | 0.9100 | TRUE | 37.6646 | 9.4161 | 18.8323 | 7.3523 |
| 7 | 0.8751 | TRUE | 10.8863 | 2.7216 | 5.4431 | 5.1932 |
| 8 | 0.8751 | TRUE | 10.8863 | 2.7216 | 5.4431 | 5.1932 |

Raiz dominante: |λ| = 0.976794, **complexa**, período 117.9 meses (quarto de ciclo 29.5, meia-volta 58.9).

Raízes com |λ| > 0,97: 2. Com |λ| > 0,90: 6. Explosivas (|λ| ≥ 1): 0.

### Sensibilidade à ordem de defasagem

| matriz | p | max_mod | n_complexo | per_dominante |
|---|---|---|---|---|
| Kilian | 1 | 0.9998 | 4 | NA |
| Kilian | 4 | 0.9817 | 24 | NA |
| Kilian | 6 | 0.9834 | 40 | 147.0329 |
| OLS | 1 | 0.9824 | 4 | NA |
| OLS | 4 | 0.9656 | 26 | 94.3815 |
| OLS | 6 | 0.9768 | 40 | 117.8992 |

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
| F5 | diferenca | TRUE | TRUE | TRUE | ambiguo |
| F6 | nivel | FALSE | FALSE | TRUE | I(1) - ADF e KPSS concordam |
| F6 | diferenca | TRUE | TRUE | TRUE | ambiguo |
| F7 | nivel | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |
| F7 | diferenca | TRUE | TRUE | FALSE | I(0) - ADF e KPSS concordam |

Fatores I(1) em nível: **4 de 7**. I(0) em primeira diferença: **4 de 7**.

## 3. Phillips-Perron nas 106 séries do painel

PP rejeita a raiz unitária a 5% em **38 de 106** séries.

| veredito_adf_kpss | pp_rejeita_RU_5pct | n |
|---|---|---|
| I(0) — os dois concordam | TRUE | 20 |
| I(1) — os dois concordam | FALSE | 56 |
| ambiguo | FALSE | 12 |
| ambiguo | TRUE | 18 |

## 4. Cointegração de Johansen (n = 7)

| K | tipo | posto_5pct | posto_5pct_ra |
|---|---|---|---|
| 2 | eigen | 4 | 4 |
| 2 | trace | 4 | 4 |
| 4 | eigen | 1 | 0 |
| 4 | trace | 1 | 0 |
| 6 | eigen | 1 | 0 |
| 6 | trace | 2 | 0 |

Na defasagem de produção (K = 6), traço: posto **2** (0 com Reinsel-Ahn) — 5 tendências comuns.

| tipo | r0 | stat | cv5 | rejeita_5pct | stat_reinsel_ahn | rejeita_5pct_ra |
|---|---|---|---|---|---|---|
| eigen | 0 | 51.425 | 46.45 | TRUE | 36.732 | FALSE |
| eigen | 1 | 35.572 | 40.30 | FALSE | 25.409 | FALSE |
| eigen | 2 | 27.246 | 34.40 | FALSE | 19.461 | FALSE |
| eigen | 3 | 17.441 | 28.14 | FALSE | 12.458 | FALSE |
| eigen | 4 | 12.482 | 22.00 | FALSE | 8.916 | FALSE |
| eigen | 5 | 9.921 | 15.67 | FALSE | 7.087 | FALSE |
| eigen | 6 | 5.945 | 9.24 | FALSE | 4.246 | FALSE |
| trace | 0 | 160.031 | 131.70 | TRUE | 114.308 | FALSE |
| trace | 1 | 108.606 | 102.14 | TRUE | 77.576 | FALSE |
| trace | 2 | 73.034 | 76.07 | FALSE | 52.167 | FALSE |
| trace | 3 | 45.788 | 53.12 | FALSE | 32.706 | FALSE |
| trace | 4 | 28.348 | 34.91 | FALSE | 20.248 | FALSE |
| trace | 5 | 15.866 | 19.96 | FALSE | 11.333 | FALSE |
| trace | 6 | 5.945 | 9.24 | FALSE | 4.246 | FALSE |

## 5. Regra R1 — reversão observada contra o marco mecânico

| var | h_inversao | meia_volta | dentro_25pct_meia_volta | h_extremo | h_extremo_mp | quarto_ciclo | dentro_25pct_quarto_mp |
|---|---|---|---|---|---|---|---|
| yield_3m | 12 | 58.95 | FALSE | 32 | 32 | 29.47 | TRUE |
| yield_6m | 12 | 58.95 | FALSE | 31 | 31 | 29.47 | TRUE |
| yield_2y | 11 | 58.95 | FALSE | 1 | 26 | 29.47 | TRUE |
| yield_10y | 11 | 58.95 | FALSE | 1 | 22 | 29.47 | FALSE |
| juros_selic | 2 | 58.95 | FALSE | 34 | 34 | 29.47 | TRUE |
| cds_5y | 11 | 58.95 | FALSE | 1 | 20 | 29.47 | FALSE |
| embi_perc | 10 | 58.95 | FALSE | 1 | 22 | 29.47 | FALSE |
| cambio_usd | 10 | 58.95 | FALSE | 1 | 17 | 29.47 | FALSE |
| credit_outstanding | 4 | 58.95 | FALSE | 29 | 29 | 29.47 | TRUE |
| credito_pessoa_fisica | 2 | 58.95 | FALSE | 32 | 32 | 29.47 | TRUE |
| credito_comercio | NA | 58.95 | FALSE | 26 | 26 | 29.47 | TRUE |
| credito_construcao | NA | 58.95 | FALSE | 29 | 29 | 29.47 | TRUE |
| credito_industria_total | 2 | 58.95 | FALSE | 25 | 25 | 29.47 | TRUE |
| credito_agro | 9 | 58.95 | FALSE | 25 | 25 | 29.47 | TRUE |

Inversão de sinal dentro de ±25% da meia-volta (58.9 meses): **0 de 14**.
Extremo **global** dentro de ±25% do quarto de ciclo (29.5 meses): **9 de 14**.
Extremo de **médio prazo** (h ≥ 13) dentro de ±25% do quarto de ciclo: **10 de 14**.

## 6. O vale de médio prazo acompanha a ordem de defasagem?

| p | dominante_complexa | quarto_ciclo | mediana_h_extremo_mp |
|---|---|---|---|
| 1 | FALSE | NA | 30.5 |
| 4 | TRUE | 23.60 | 29.5 |
| 6 | TRUE | 29.47 | 26.0 |

| var | h_mp_p1 | h_mp_p4 | h_mp_p6 |
|---|---|---|---|
| yield_3m | 35 | 33 | 32 |
| yield_6m | 34 | 32 | 31 |
| yield_2y | 30 | 29 | 26 |
| yield_10y | 28 | 26 | 22 |
| juros_selic | 36 | 34 | 34 |
| cds_5y | 26 | 26 | 20 |
| embi_perc | 25 | 26 | 22 |
| cambio_usd | 48 | 48 | 17 |
| credit_outstanding | 31 | 30 | 29 |
| credito_pessoa_fisica | 34 | 32 | 32 |
| credito_comercio | 27 | 27 | 26 |
| credito_construcao | 31 | 30 | 29 |
| credito_industria_total | 27 | 27 | 25 |
| credito_agro | 28 | 27 | 25 |

## 7. Decomposição espectral — apagar o par dominante de `B`

⚠ **Apagar modos muda o denominador da normalização.** `B₀` só é a identidade com todos os modos (`Σₖ vₖwₖ' = I`); sem o par dominante o impacto pré-normalização de `yield_6m` cai a **0.313** do original (sem o par 2, 1.034). O **sinal se preserva nos dois**, então a inversão do vale não é artefato, e o **horizonte** do extremo é invariante a escala. A **magnitude** admite duas leituras: renormalizar cada caminho a +50 pb responde *"se este modo não existisse, o que faria um choque de 50 pb?"*; pôr os dois na **escala comum** (multiplicando pela razão de denominadores) é a leitura de **decomposição**, porque a IRF é linear em `Bₕ` e os modos só somam antes da renormalização. A tabela traz a escala comum.

| var | h_mp_completo | val_mp_completo | h_mp_sem_par1 | razao_sem_par1_defl | inverte_sinal_sem_par1 | vale_sobrevive_sem_par1 |
|---|---|---|---|---|---|---|
| yield_3m | 32 | -0.008 | 13 | -0.493 | TRUE | FALSE |
| yield_6m | 31 | -0.008 | 13 | -0.475 | TRUE | FALSE |
| yield_2y | 26 | -0.006 | 13 | -0.386 | TRUE | FALSE |
| yield_10y | 22 | -0.004 | 13 | -0.317 | TRUE | FALSE |
| juros_selic | 34 | -0.778 | 13 | -0.497 | TRUE | FALSE |
| cds_5y | 20 | -18.001 | 25 | 0.327 | FALSE | FALSE |
| embi_perc | 22 | -0.172 | 13 | -0.279 | TRUE | FALSE |
| cambio_usd | 17 | -0.068 | 20 | 1.004 | FALSE | TRUE |
| credit_outstanding | 29 | -1.227 | 13 | -0.368 | TRUE | FALSE |
| credito_pessoa_fisica | 32 | -0.938 | 13 | -0.427 | TRUE | FALSE |
| credito_comercio | 26 | -2.187 | 13 | -0.257 | TRUE | FALSE |
| credito_construcao | 29 | -2.443 | 13 | -0.365 | TRUE | FALSE |
| credito_industria_total | 25 | -1.630 | 13 | -0.266 | TRUE | FALSE |
| credito_agro | 25 | -1.473 | 13 | -0.316 | TRUE | FALSE |

**Inverte de sinal** ao apagar o par dominante: **12 de 14**.
Vale sobrevive (mesmo sinal **e** > 50% da magnitude em escala comum): **1 de 14**.
Razão mediana em **escala comum**: **0.366** sem o par 1, contra **1.009** sem o par 2 (controle). Renormalizando cada caminho a +50 pb seriam 1.170 e 0.977.

