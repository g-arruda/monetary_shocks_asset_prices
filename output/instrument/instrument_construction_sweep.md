# Robustez da construção do instrumento — vértice do DI e esquema de agregação

Gerado por `script/instrument_construction_sweep.R` em 2026-07-27.

Grid: 13 vértices × 2 esquemas de agregação × 5 variantes × 2 amostras = 260 células. Dimensão (r, q) = (7, 6), p = 6, direção de normalização = `yield_6m`. Um `estimate_dfm` por amostra.

**Incumbente:** vértice 126 du + soma JK + `z_jk_bs_purif` — ξ_mp = 10.43 full / 12.22 pré-COVID.

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
| z_jk_bs_purif |  6.61 |  8.34 |  5.01 | 10.63 |  6.51 | 10.43 | 10.54 |  7.21 |  6.98 |  6.58 |  7.96 |  8.03 |  8.51 |
| z_jk_raw |  7.11 | 10.15 |  6.92 | 11.59 |  7.87 | 10.55 | 10.62 |  7.67 |  7.21 |  7.01 |  7.88 |  8.35 |  8.61 |
| z_jk_raw_purif |  6.72 |  9.51 |  6.78 | 11.42 |  7.59 | 10.39 | 10.05 |  7.37 |  6.89 |  6.84 |  7.67 |  8.24 |  8.34 |
| z_jk_purif |  5.07 |  6.54 |  2.16 |  8.02 |  4.22 |  5.77 |  7.87 |  4.52 |  4.75 |  2.73 |  5.24 |  4.76 |  3.74 |
| z_bruto |  2.72 |   6.4 |  1.91 |  8.49 |  5.06 |  7.57 | 10.74 |  5.66 |  6.29 |  3.62 |  7.65 |  6.06 |  5.07 |

### Pré-COVID

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif | 13.46 | 18.44 | 15.15 | 14.24 | 10.73 | 12.22 | 11.41 |  7.85 |  5.24 | 11.23 |  2.75 |  1.94 |   0.5 |
| z_jk_raw | 13.09 | 16.03 | 13.47 | 13.01 | 10.31 | 10.45 | 10.45 |  8.55 |  6.13 | 10.66 |  4.03 |  2.87 |  1.22 |
| z_jk_raw_purif | 13.14 | 16.43 | 13.81 | 13.68 | 10.87 |  11.1 | 11.71 |  9.64 |  6.74 | 11.43 |  4.82 |  3.51 |  1.53 |
| z_jk_purif | 13.83 |  18.9 |  15.4 | 14.97 |    13 | 13.68 | 14.21 | 11.93 |  9.21 | 14.11 |  5.99 |  5.08 |  2.63 |
| z_bruto | 14.49 |  20.6 |  16.1 | 16.11 | 15.86 | 17.02 | 17.41 | 15.13 | 11.95 | 19.51 |  8.59 |   7.6 |  4.36 |

## 3. ξ_mp por vértice — agregação Gertler-Karadi (nota 11)

Lida em **NW(1)**: o esquema GK parte cada surpresa entre `t` e `t+1`, o que induz MA(1) por construção. A coluna `wald_mp_nw0` do CSV traz a mesma célula em NW(0) para comparação na mesma convenção do painel de soma. Sob GK os meses sem reunião **deixam de ser zero**, então a propriedade que JK e BS assumem se perde.

### Amostra completa

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |  2.45 |  1.94 |  0.29 |  0.31 |  0.06 |   0.3 |  0.07 |  0.17 |  0.18 |  0.15 |  0.46 |  0.54 |  0.52 |
| z_jk_raw |  2.21 |   2.4 |  0.38 |  0.52 |  0.21 |  0.66 |  0.35 |  0.33 |  0.32 |  0.33 |  0.64 |  0.88 |  0.97 |
| z_jk_raw_purif |  1.97 |  2.03 |  0.39 |  0.41 |  0.11 |  0.55 |  0.23 |  0.24 |   0.2 |  0.21 |  0.53 |  0.76 |  0.79 |
| z_jk_purif |  1.19 |  0.53 |  0.14 |     0 |  0.17 |  0.02 |     0 |  0.05 |  0.07 |  0.49 |  0.01 |  0.01 |  0.01 |
| z_bruto |  1.46 |  0.67 |  0.17 |  0.02 |  0.02 |  0.02 |  0.11 |     0 |  0.03 |  0.09 |  0.42 |  0.18 |  0.09 |

### Pré-COVID

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |  8.29 | 12.83 |  6.77 |  4.04 |  3.79 |  3.44 |   3.3 |  0.92 |  0.21 |   2.5 |  0.01 |     0 |  0.28 |
| z_jk_raw |  8.63 |  12.3 |  6.89 |  5.26 |  4.83 |  4.83 |  4.76 |  2.61 |  1.27 |  4.73 |  0.63 |  0.32 |     0 |
| z_jk_raw_purif |  8.54 | 12.61 |  6.99 |  5.32 |  4.84 |  4.97 |  5.27 |  2.73 |  1.31 |  4.69 |  0.77 |  0.42 |     0 |
| z_jk_purif |  7.78 | 12.31 |  7.49 |  6.41 |  6.17 |  6.37 |  6.16 |  4.37 |  2.52 |  5.56 |  1.45 |  1.29 |  0.17 |
| z_bruto |  8.08 |   9.5 |  7.14 |   6.8 |   8.1 |  7.06 |  7.14 |  5.58 |  3.58 |  7.28 |  2.31 |   1.8 |  0.45 |

## 4. Células que batem o incumbente nas duas janelas e cruzam 10 nas duas

| target_bd | agg | instrument | full | pre_covid | margin_full |
|---|---|---|---|---|---|
|    84 | sum | z_jk_raw | 11.59 | 13.01 | 1.161 |
|    84 | sum | z_jk_raw_purif | 11.42 | 13.68 | 0.992 |
|   147 | sum | z_bruto | 10.74 |  17.4 | 0.309 |
|    84 | sum | z_jk_bs_purif | 10.63 | 14.24 | 0.196 |

### Veredito da regra de decisão

A regra foi fixada **antes** de qualquer um destes números existir (plano de 2026-07-27). Uma célula substitui a construção de produção só se (i) bater o incumbente nas duas janelas, (ii) cruzar ξ_mp ≥ 10 nas duas, e (iii) vencer por margem maior que a dispersão leave-one-month-out do próprio ξ_mp do incumbente — uma vantagem menor do que o que um único mês move não é sinal.

Limiar (iii), lido de `xi_mp_robustness.csv`: **2.00** pontos (maior desvio LOO de ξ_mp = 10.43 na amostra completa).

Maior margem observada: **1.16** (84 du, sum, `z_jk_raw`).

**A regra NÃO dispara.** O incumbente (126 du + soma JK) permanece. Nenhuma célula vence por margem que sobreviva ao ruído amostral do próprio ξ_mp: o melhor desafiante ganha menos do que o que a remoção de um único mês move a estatística. A leitura correta não é que 126 du é o ótimo — ele **não** é o argmax em nenhuma das duas janelas —, e sim que **o vértice não é identificado com precisão suficiente para escolher entre os candidatos**, e que a escolha herdada está dentro do conjunto indistinguível do melhor.

## 5. Contagem de células por variante (agregação por soma)

| sample | instrument | n_vertices | xi_min | xi_median | xi_max | best_bd | n_ge10 | n_ge384 |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_bs_purif |    13 |  5.01 | 7.964 | 10.63 |    84 |     3 |    13 |
| full | z_jk_raw |    13 | 6.921 | 7.882 | 11.59 |    84 |     4 |    13 |
| full | z_jk_raw_purif |    13 |  6.72 | 7.672 | 11.42 |    84 |     3 |    13 |
| full | z_bruto |    13 | 1.915 | 6.059 | 10.74 |   147 |     1 |    10 |
| full | z_jk_purif |    13 | 2.156 | 4.759 | 8.023 |    84 |     0 |    10 |
| pre_covid | z_bruto |    13 | 4.361 | 15.86 |  20.6 |    42 |    10 |    13 |
| pre_covid | z_jk_purif |    13 |  2.63 | 13.68 |  18.9 |    42 |     9 |    12 |
| pre_covid | z_jk_bs_purif |    13 | 0.499 | 11.23 | 18.43 |    42 |     8 |    10 |
| pre_covid | z_jk_raw_purif |    13 |  1.53 |  11.1 | 16.43 |    42 |     8 |    11 |
| pre_covid | z_jk_raw |    13 | 1.215 | 10.45 | 16.03 |    42 |     8 |    11 |

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

