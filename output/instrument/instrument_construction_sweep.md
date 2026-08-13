# Robustez da construção do instrumento — vértice do DI e esquema de agregação

Gerado por `script/instrument_construction_sweep.R` em 2026-08-13.

Grid: 13 vértices × 2 esquemas de agregação × 5 variantes × 2 amostras = 260 células. Dimensão (r, q) = (7, 6), p = 6, direção de normalização = `yield_6m`. Um `estimate_dfm` por amostra.

**Incumbente:** vértice 126 du + soma JK + `z_jk_bs_purif` — ξ_mp = 7.65 full / 11.53 pré-COVID.

Protocolo anti-screening de MOSW (nota 6): a grade inteira é reportada e nada é filtrado pela estatística.

## 1. Maturidade realizada por vértice-alvo

`build_thursday_surprises` escolhe o **contrato mais próximo**, não interpola. A grade do DI é mensal até ~13 meses e trimestral depois, então vértices-alvo vizinhos podem cair no mesmo contrato. Medido nos dias de Copom.

| target_bd | n | bd_median | bd_p10 | bd_p90 | n_distinct_bd |
|---|---|---|---|---|---|
|    21 |   108 |    21 |    12 |    29 |    23 |
|    42 |   108 |    42 |    33 |    50 |    23 |
|    63 |   108 |    63 |    54 |  71.3 |    23 |
|    84 |   108 |    83 |    74 |  91.3 |    25 |
|   105 |   108 |   104 |  93.2 | 114.3 |    34 |
|   126 |   108 |   126 |   116 | 137.5 |    32 |
|   147 |   108 |   146 |   136 |   155 |    34 |
|   168 |   108 |   167 |   152 | 178.3 |    33 |
|   189 |   108 |   189 | 178.7 |   207 |    37 |
|   210 |   108 |   208 | 192.4 |   219 |    37 |
|   252 |   108 |   249 |   233 | 271.3 |    43 |
|   378 |   108 |   379 |   354 |   398 |    43 |
|   504 |   108 |   509 |   479 | 523.3 |    43 |

## 2. ξ_mp por vértice — agregação por soma (Jarociński-Karadi, produção)

### Amostra completa

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |  4.88 |  6.58 |  2.97 |  8.13 |  4.92 |  7.65 |  6.79 |  5.45 |  5.22 |  4.81 |  5.83 |  5.78 |     6 |
| z_jk_raw |  5.27 |  8.03 |  4.37 |  8.89 |  6.05 |  7.69 |  7.07 |  5.88 |  5.35 |   5.2 |  5.72 |  6.11 |  6.11 |
| z_jk_raw_purif |  4.97 |  7.35 |  4.17 |  8.75 |  5.88 |  7.65 |  7.02 |  5.81 |   5.3 |  5.18 |  5.86 |  6.31 |  6.21 |
| z_jk_purif |  4.79 |  6.77 |  2.26 |  7.52 |  4.06 |  5.31 |  6.56 |  4.15 |  4.19 |  2.53 |  4.71 |  4.27 |   3.3 |
| z_bruto |   2.7 |  6.58 |  1.81 |  7.31 |  4.42 |  6.48 |  8.13 |  4.83 |  5.23 |   3.1 |  6.21 |  4.78 |  3.91 |

### Pré-COVID

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif | 13.62 | 18.84 | 15.57 | 14.18 |  10.6 | 11.53 | 10.56 |  7.24 |  4.58 |  9.95 |  2.28 |   1.5 |   0.3 |
| z_jk_raw |  13.2 | 16.38 | 13.77 | 12.96 | 10.19 |  10.1 |   9.9 |  8.15 |   5.6 |  9.91 |  3.57 |  2.43 |  0.92 |
| z_jk_raw_purif | 13.25 | 16.78 | 14.12 | 13.63 | 10.75 | 10.74 | 11.11 |  9.21 |  6.16 | 10.63 |  4.32 |  3.03 |  1.21 |
| z_jk_purif | 14.16 |  19.8 | 16.02 | 15.25 | 13.29 | 13.89 | 14.11 | 11.96 |  9.03 | 14.01 |  5.73 |   4.7 |  2.29 |
| z_bruto |  14.6 | 20.94 | 16.35 | 16.05 |    16 | 16.86 | 16.99 | 14.91 | 11.42 | 19.04 |  8.03 |  7.02 |   3.8 |

## 3. ξ_mp por vértice — agregação Gertler-Karadi (nota 11)

Lida em **NW(1)**: o esquema GK parte cada surpresa entre `t` e `t+1`, o que induz MA(1) por construção. A coluna `wald_mp_nw0` do CSV traz a mesma célula em NW(0) para comparação na mesma convenção do painel de soma. Sob GK os meses sem reunião **deixam de ser zero**, então a propriedade que JK e BS assumem se perde.

### Amostra completa

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |   2.1 |  1.18 |  0.07 |  0.01 |  0.02 |  0.11 |  0.01 |  0.02 |     0 |  0.02 |  0.05 |  0.02 |  0.01 |
| z_jk_raw |  1.96 |  1.51 |  0.13 |   0.1 |  0.01 |   0.4 |  0.23 |  0.13 |  0.06 |  0.15 |  0.17 |  0.17 |  0.17 |
| z_jk_raw_purif |  1.75 |   1.2 |  0.11 |  0.07 |     0 |  0.33 |  0.21 |  0.11 |  0.04 |  0.11 |  0.16 |  0.15 |  0.15 |
| z_jk_purif |  0.89 |  0.16 |  0.38 |   0.1 |  0.38 |  0.04 |     0 |  0.08 |  0.15 |   0.4 |  0.03 |  0.06 |  0.17 |
| z_bruto |  1.87 |  0.65 |  0.09 |     0 |  0.07 |  0.02 |  0.11 |     0 |     0 |  0.06 |  0.09 |     0 |  0.02 |

### Pré-COVID

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |     8 | 12.63 |  6.61 |  3.78 |  3.58 |  3.16 |  3.15 |  0.77 |  0.14 |  2.26 |     0 |  0.01 |   0.4 |
| z_jk_raw |   8.4 | 12.21 |  6.75 |     5 |  4.63 |  4.61 |  4.67 |   2.4 |   1.1 |  4.55 |   0.5 |  0.23 |     0 |
| z_jk_raw_purif |   8.3 | 12.51 |  6.84 |  5.05 |  4.61 |  4.73 |  5.16 |  2.49 |  1.12 |  4.47 |  0.61 |  0.31 |     0 |
| z_jk_purif |  7.48 | 12.23 |   7.5 |  6.39 |  6.14 |  6.42 |  6.32 |   4.3 |  2.43 |  5.64 |  1.31 |  1.19 |  0.11 |
| z_bruto |     8 |  9.52 |  7.11 |   6.7 |  8.11 |  6.93 |  7.12 |  5.42 |  3.35 |  7.18 |  2.07 |  1.63 |  0.35 |

## 4. Células que batem o incumbente nas duas janelas e cruzam 10 nas duas

_Nenhuma._ O incumbente não é dominado por nenhuma célula da grade.

### Veredito da regra de decisão

A regra foi fixada **antes** de qualquer um destes números existir (plano de 2026-07-27). Uma célula substitui a construção de produção só se (i) bater o incumbente nas duas janelas, (ii) cruzar ξ_mp ≥ 10 nas duas, e (iii) vencer por margem maior que a dispersão leave-one-month-out do próprio ξ_mp do incumbente — uma vantagem menor do que o que um único mês move não é sinal.

Limiar (iii), lido de `xi_mp_robustness.csv`: **2.00** pontos (maior desvio LOO de ξ_mp = 7.65 na amostra completa).

Maior margem observada: **0.00** (nenhuma célula elegível).

**A regra NÃO dispara.** O incumbente (126 du + soma JK) permanece. Nenhuma célula vence por margem que sobreviva ao ruído amostral do próprio ξ_mp: o melhor desafiante ganha menos do que o que a remoção de um único mês move a estatística. A leitura correta não é que 126 du é o ótimo — ele **não** é o argmax em nenhuma das duas janelas —, e sim que **o vértice não é identificado com precisão suficiente para escolher entre os candidatos**, e que a escolha herdada está dentro do conjunto indistinguível do melhor.

## 5. Contagem de células por variante (agregação por soma)

| sample | instrument | n_vertices | xi_min | xi_median | xi_max | best_bd | n_ge10 | n_ge384 |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_raw |    13 | 4.367 | 6.046 | 8.893 |    84 |     0 |    13 |
| full | z_jk_raw_purif |    13 | 4.168 | 5.883 | 8.751 |    84 |     0 |    13 |
| full | z_jk_bs_purif |    13 | 2.969 |  5.78 | 8.132 |    84 |     0 |    12 |
| full | z_bruto |    13 | 1.808 | 4.832 | 8.129 |   147 |     0 |    10 |
| full | z_jk_purif |    13 | 2.259 | 4.267 | 7.516 |    84 |     0 |    10 |
| pre_covid | z_bruto |    13 | 3.804 |    16 | 20.94 |    42 |    10 |    12 |
| pre_covid | z_jk_purif |    13 | 2.285 | 13.89 |  19.8 |    42 |     9 |    12 |
| pre_covid | z_jk_raw_purif |    13 | 1.209 | 10.74 | 16.77 |    42 |     8 |    11 |
| pre_covid | z_jk_bs_purif |    13 | 0.299 | 10.56 | 18.84 |    42 |     7 |    10 |
| pre_covid | z_jk_raw |    13 | 0.922 | 9.914 | 16.38 |    42 |     6 |    10 |

## 6. Diagnóstico de construção por célula

`n_valid` são quintas-feiras válidas, `n_copom` os dias de reunião retidos, e `n_jk_bs` os classificados como monetários pela máscara predeterminada. R² das regressões BS pré-evento para referência (faixa da Tabela 3 de Bauer-Swanson: 0,12–0,20).

| target_bd | n_valid | n_copom | n_jk | n_jk_raw | n_jk_bs | r2_di_bs | r2_ibov_bs |
|---|---|---|---|---|---|---|---|
|    21 |   598 |    95 |    50 |    53 |    53 | 0.072 | 0.015 |
|    42 |   598 |    95 |    54 |    53 |    55 | 0.045 | 0.015 |
|    63 |   598 |    95 |    62 |    56 |    55 | 0.034 | 0.015 |
|    84 |   598 |    95 |    59 |    52 |    58 | 0.044 | 0.015 |
|   105 |   598 |    95 |    64 |    56 |    61 | 0.031 | 0.015 |
|   126 |   598 |    95 |    65 |    55 |    62 | 0.024 | 0.015 |
|   147 |   598 |    95 |    63 |    59 |    60 | 0.037 | 0.015 |
|   168 |   598 |    95 |    63 |    58 |    63 | 0.044 | 0.015 |
|   189 |   598 |    95 |    66 |    59 |    63 | 0.028 | 0.015 |
|   210 |   598 |    95 |    62 |    56 |    61 | 0.041 | 0.015 |
|   252 |   598 |    95 |    63 |    56 |    60 | 0.027 | 0.015 |
|   378 |   598 |    95 |    61 |    57 |    62 | 0.019 | 0.015 |
|   504 |   598 |    95 |    63 |    59 |    61 | 0.016 | 0.015 |

