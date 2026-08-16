# Estacionariedade, cointegração e espectro da companion

> **Corpo gerado por `script/factor_stationarity.R`. Reescrito por inteiro a**
> **cada execução — não escrever prosa aqui.** A leitura interpretativa fica em
> `notas/2026-07-31_estacionariedade_fatores.md`.

Spec: r = 5, q = 5, p = 6, instrumento `z_jk_bs_purif`, painel 153 x 111 (2013-01-01 a 2025-09-01).

## 1. Espectro da companion (produção: OLS, p = 6)

| ordem | modulo | complexo | periodo_meses | quarto_ciclo | meia_volta_ciclo | meia_vida_meses |
|---|---|---|---|---|---|---|
| 1 | 0.9649 | TRUE | 65.7502 | 16.4375 | 32.8751 | 19.3754 |
| 2 | 0.9649 | TRUE | 65.7502 | 16.4375 | 32.8751 | 19.3754 |
| 3 | 0.9553 | TRUE | 125.6989 | 31.4247 | 62.8494 | 15.1448 |
| 4 | 0.9553 | TRUE | 125.6989 | 31.4247 | 62.8494 | 15.1448 |
| 5 | 0.8143 | TRUE | 27.0830 | 6.7707 | 13.5415 | 3.3734 |
| 6 | 0.8143 | TRUE | 27.0830 | 6.7707 | 13.5415 | 3.3734 |
| 7 | 0.7957 | TRUE | 5.4602 | 1.3651 | 2.7301 | 3.0335 |
| 8 | 0.7957 | TRUE | 5.4602 | 1.3651 | 2.7301 | 3.0335 |

Raiz dominante: |λ| = 0.964858, **complexa**, período 65.8 meses (quarto de ciclo 16.4, meia-volta 32.9).

Raízes com |λ| > 0,97: 0. Com |λ| > 0,90: 4. Explosivas (|λ| ≥ 1): 0.

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

Na defasagem de produção (K = 6), traço: posto **1** (0 com Reinsel-Ahn) — 4 tendências comuns.

| tipo | r0 | stat | cv5 | rejeita_5pct | stat_reinsel_ahn | rejeita_5pct_ra |
|---|---|---|---|---|---|---|
| eigen | 0 | 30.064 | 34.40 | FALSE | 23.928 | FALSE |
| eigen | 1 | 18.715 | 28.14 | FALSE | 14.896 | FALSE |
| eigen | 2 | 17.671 | 22.00 | FALSE | 14.064 | FALSE |
| eigen | 3 | 11.545 | 15.67 | FALSE | 9.189 | FALSE |
| eigen | 4 | 3.928 | 9.24 | FALSE | 3.127 | FALSE |
| trace | 0 | 81.923 | 76.07 | TRUE | 65.204 | FALSE |
| trace | 1 | 51.859 | 53.12 | FALSE | 41.276 | FALSE |
| trace | 2 | 33.144 | 34.91 | FALSE | 26.380 | FALSE |
| trace | 3 | 15.473 | 19.96 | FALSE | 12.315 | FALSE |
| trace | 4 | 3.928 | 9.24 | FALSE | 3.127 | FALSE |

## 5. Regra R1 — reversão observada contra o marco mecânico

| var | h_inversao | meia_volta | dentro_25pct_meia_volta | h_extremo | h_extremo_mp | quarto_ciclo | dentro_25pct_quarto_mp |
|---|---|---|---|---|---|---|---|
| yield_3m | 23 | 32.88 | FALSE | 3 | 41 | 16.44 | FALSE |
| yield_6m | 22 | 32.88 | FALSE | 3 | 40 | 16.44 | FALSE |
| yield_2y | 19 | 32.88 | FALSE | 3 | 37 | 16.44 | FALSE |
| yield_10y | 17 | 32.88 | FALSE | 3 | 35 | 16.44 | FALSE |
| juros_selic | 25 | 32.88 | TRUE | 5 | 43 | 16.44 | FALSE |
| cds_5y | 15 | 32.88 | FALSE | 3 | 31 | 16.44 | FALSE |
| embi_perc | 15 | 32.88 | FALSE | 3 | 29 | 16.44 | FALSE |
| cambio_usd | 12 | 32.88 | FALSE | 1 | 23 | 16.44 | FALSE |
| credit_outstanding | 19 | 32.88 | FALSE | 3 | 37 | 16.44 | FALSE |
| credito_pessoa_fisica | 23 | 32.88 | FALSE | 3 | 41 | 16.44 | FALSE |
| credito_comercio | 14 | 32.88 | FALSE | 3 | 31 | 16.44 | FALSE |
| credito_construcao | 18 | 32.88 | FALSE | 5 | 37 | 16.44 | FALSE |
| credito_industria_total | 14 | 32.88 | FALSE | 3 | 29 | 16.44 | FALSE |
| credito_agro | 16 | 32.88 | FALSE | 3 | 34 | 16.44 | FALSE |

Inversão de sinal dentro de ±25% da meia-volta (32.9 meses): **1 de 14**.
Extremo **global** dentro de ±25% do quarto de ciclo (16.4 meses): **0 de 14**.
Extremo de **médio prazo** (h ≥ 13) dentro de ±25% do quarto de ciclo: **0 de 14**.

## 6. O vale de médio prazo acompanha a ordem de defasagem?

| p | dominante_complexa | quarto_ciclo | mediana_h_extremo_mp |
|---|---|---|---|
| 1 | TRUE | 29.87 | 42.5 |
| 4 | FALSE | NA | 29.0 |
| 6 | TRUE | 16.44 | 36.0 |

| var | h_mp_p1 | h_mp_p4 | h_mp_p6 |
|---|---|---|---|
| yield_3m | 48 | 13 | 41 |
| yield_6m | 47 | 37 | 40 |
| yield_2y | 44 | 35 | 37 |
| yield_10y | 41 | 32 | 35 |
| juros_selic | 48 | 13 | 43 |
| cds_5y | 36 | 29 | 31 |
| embi_perc | 33 | 28 | 29 |
| cambio_usd | 13 | 21 | 23 |
| credit_outstanding | 44 | 34 | 37 |
| credito_pessoa_fisica | 48 | 13 | 41 |
| credito_comercio | 37 | 29 | 31 |
| credito_construcao | 44 | 34 | 37 |
| credito_industria_total | 34 | 27 | 29 |
| credito_agro | 40 | 32 | 34 |

## 7. Decomposição espectral — apagar o par dominante de `B`

⚠ **Apagar modos muda o denominador da normalização.** `B₀` só é a identidade com todos os modos (`Σₖ vₖwₖ' = I`); sem o par dominante o impacto pré-normalização de `yield_6m` passa a **1.174** do original (sem o par 2, -0.456). Como o denominador pode trocar de sinal, magnitude e sinal são comparados na **escala comum** (multiplicando pela razão de denominadores), antes da renormalização específica de cada caminho. O **horizonte** do extremo é invariante a essa escala. Renormalizar cada caminho a +50 pb responde a outra pergunta — *"se este modo não existisse, o que faria um choque de 50 pb?"* — e não é uma decomposição aditiva. A tabela traz a escala comum.

| var | h_mp_completo | val_mp_completo | h_mp_sem_par1 | razao_sem_par1_defl | inverte_sinal_sem_par1 | vale_sobrevive_sem_par1 |
|---|---|---|---|---|---|---|
| yield_3m | 41 | -0.006 | 22 | 1.103 | FALSE | TRUE |
| yield_6m | 40 | -0.007 | 21 | 1.106 | FALSE | TRUE |
| yield_2y | 37 | -0.008 | 20 | 1.081 | FALSE | TRUE |
| yield_10y | 35 | -0.006 | 19 | 1.002 | FALSE | TRUE |
| juros_selic | 43 | -0.485 | 23 | 1.088 | FALSE | TRUE |
| cds_5y | 31 | -15.353 | 17 | 0.761 | FALSE | TRUE |
| embi_perc | 29 | -0.116 | 17 | 0.650 | FALSE | TRUE |
| cambio_usd | 23 | -0.109 | 14 | 0.356 | FALSE | FALSE |
| credit_outstanding | 37 | -0.638 | 20 | 1.085 | FALSE | TRUE |
| credito_pessoa_fisica | 41 | -0.617 | 21 | 1.130 | FALSE | TRUE |
| credito_comercio | 31 | -1.025 | 18 | 0.928 | FALSE | TRUE |
| credito_construcao | 37 | -1.030 | 20 | 1.084 | FALSE | TRUE |
| credito_industria_total | 29 | -0.732 | 18 | 0.751 | FALSE | TRUE |
| credito_agro | 34 | -1.113 | 19 | 0.983 | FALSE | TRUE |

**Inverte de sinal** ao apagar o par dominante: **0 de 14**.
Vale sobrevive (mesmo sinal **e** > 50% da magnitude em escala comum): **13 de 14**.
Razão mediana em **escala comum**: **1.041** sem o par 1, contra **1.326** sem o par 2 (controle). Renormalizando cada caminho a +50 pb seriam 0.887 e 2.906.

