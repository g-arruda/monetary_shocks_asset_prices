# Robustez da construção do instrumento — vértice do DI e esquema de agregação

Gerado por `script/instrument_construction_sweep.R` em 2026-08-25.

Grid: 13 vértices × 2 esquemas de agregação × 5 variantes × 2 amostras = 260 células. Dimensão (r, q) = (5, 5), p = 4, direção de normalização = `yield_6m`. Um `estimate_dfm` por amostra.

**Incumbente:** vértice 126 du + soma JK + `z_jk_bs_purif` — ξ_mp = 5.37 full / 8.08 pré-COVID.

Protocolo anti-screening de MOSW (nota 6): a grade inteira é reportada e nada é filtrado pela estatística.

## 1. Maturidade realizada por vértice-alvo

`build_thursday_surprises` escolhe o **contrato mais próximo**, não interpola. A grade do DI é mensal até ~13 meses e trimestral depois, então vértices-alvo vizinhos podem cair no mesmo contrato. Medido nos dias de Copom.

| target_bd | n | bd_median | bd_p10 | bd_p90 | n_distinct_bd |
|---|---|---|---|---|---|
|    21 |   105 |    21 |  12.4 |    29 |    23 |
|    42 |   105 |    42 |    33 |    50 |    23 |
|    63 |   105 |    63 |    55 |  71.6 |    23 |
|    84 |   105 |    83 |    74 |  91.6 |    25 |
|   105 |   105 |   104 |  91.4 | 114.6 |    34 |
|   126 |   105 |   126 |   116 |   139 |    32 |
|   147 |   105 |   146 |   136 |   155 |    33 |
|   168 |   105 |   167 |   152 | 178.6 |    33 |
|   189 |   105 |   189 | 178.4 |   207 |    37 |
|   210 |   105 |   208 | 191.8 |   219 |    37 |
|   252 |   105 |   249 |   233 | 271.6 |    43 |
|   378 |   105 |   378 | 354.4 |   398 |    41 |
|   504 |   105 |   509 |   479 | 523.6 |    43 |

## 2. ξ_mp por vértice — agregação por soma (Jarociński-Karadi, produção)

### Amostra completa

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |  4.76 |     7 |  5.19 |  5.98 |  3.71 |  5.37 |  5.24 |  3.17 |  2.93 |  3.16 |  3.23 |  3.31 |  3.53 |
| z_jk_raw |  4.86 |  7.35 |  5.63 |  6.18 |  4.19 |  5.41 |  5.32 |  3.52 |  3.17 |  3.47 |  3.35 |  3.54 |  3.57 |
| z_jk_raw_purif |  4.64 |  7.12 |  5.58 |  6.14 |   4.1 |   5.3 |  5.24 |  3.44 |  3.09 |  3.41 |  3.34 |  3.53 |  3.51 |
| z_jk_purif |  2.62 |  5.08 |  2.84 |  4.39 |   2.6 |  3.41 |  3.86 |  2.37 |   2.2 |  1.96 |  2.29 |  2.27 |  1.91 |
| z_bruto |  2.06 |  4.94 |  2.95 |  4.88 |   3.4 |  4.28 |  4.86 |  2.89 |  2.77 |  2.54 |   3.1 |  2.89 |   2.8 |

### Pré-COVID

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |  8.39 |  9.36 |  9.23 |  9.76 |   8.1 |  8.08 |  8.23 |   6.4 |  6.18 |  7.28 |  5.56 |  4.79 |  3.87 |
| z_jk_raw |  7.84 |  8.52 |  8.35 |  8.67 |  7.24 |  7.13 |   7.6 |  5.95 |   5.4 |  6.62 |  5.19 |  4.65 |  4.19 |
| z_jk_raw_purif |  7.73 |  8.65 |  8.48 |  8.91 |  7.49 |  7.63 |  8.16 |  6.63 |  5.93 |   7.3 |   5.8 |  5.59 |  5.15 |
| z_jk_purif |  5.17 |  5.56 |  5.63 |   6.6 |  5.38 |  5.89 |  6.14 |  4.79 |  4.58 |  5.17 |  4.14 |  3.81 |  3.25 |
| z_bruto |  7.42 |   8.6 |  8.12 |  8.33 |  7.41 |  6.58 |  7.08 |  5.72 |  4.61 |  5.84 |  4.41 |  4.58 |  4.29 |

## 3. ξ_mp por vértice — agregação Gertler-Karadi (nota 11)

Lida em **NW(1)**: o esquema GK parte cada surpresa entre `t` e `t+1`, o que induz MA(1) por construção. A coluna `wald_mp_nw0` do CSV traz a mesma célula em NW(0) para comparação na mesma convenção do painel de soma. Sob GK os meses sem reunião **deixam de ser zero**, então a propriedade que JK e BS assumem se perde.

### Amostra completa

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |     1 |  0.65 |  0.01 |     0 |  0.02 |  0.12 |  0.09 |     0 |  0.01 |     0 |  0.01 |  0.14 |  0.23 |
| z_jk_raw |  1.32 |  1.63 |  0.17 |  0.27 |  0.06 |  0.66 |  0.67 |  0.17 |  0.08 |  0.16 |   0.1 |  0.01 |     0 |
| z_jk_raw_purif |  1.07 |  1.31 |  0.16 |  0.19 |  0.03 |   0.6 |  0.63 |  0.14 |  0.06 |   0.1 |  0.09 |     0 |     0 |
| z_jk_purif |  0.31 |  0.17 |  0.37 |  0.09 |  0.49 |  0.08 |  0.02 |  0.22 |  0.34 |  0.78 |  0.21 |  0.63 |  1.08 |
| z_bruto |  0.39 |  0.04 |  0.69 |  0.32 |   0.5 |  0.24 |     0 |  0.33 |  0.33 |  0.69 |  0.17 |  0.87 |   1.3 |

### Pré-COVID

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |  3.02 |  2.69 |  2.08 |  1.78 |  1.37 |  0.78 |  1.09 |  0.37 |  0.36 |  0.62 |  0.23 |  0.01 |  0.08 |
| z_jk_raw |  3.09 |  3.04 |  2.22 |  2.36 |  1.65 |  1.82 |  2.29 |  1.14 |  1.24 |  1.86 |  1.39 |  0.72 |  0.45 |
| z_jk_raw_purif |  2.91 |  3.07 |   2.2 |  2.34 |  1.62 |  1.95 |  2.43 |  1.32 |  1.35 |  2.01 |  1.56 |  0.98 |  0.71 |
| z_jk_purif |  1.93 |  1.53 |  1.21 |  1.76 |  1.13 |  1.38 |  1.73 |  0.88 |  0.85 |  1.09 |  1.14 |  0.93 |  0.56 |
| z_bruto |  3.88 |   3.3 |  2.63 |   2.4 |   2.1 |  1.11 |   1.6 |  0.84 |  0.48 |   0.8 |  0.31 |  0.04 |  0.02 |

## 4. Células que batem o incumbente nas duas janelas e cruzam 10 nas duas

_Nenhuma._ O incumbente não é dominado por nenhuma célula da grade.

### Veredito da regra de decisão

A regra foi fixada **antes** de qualquer um destes números existir (plano de 2026-07-27). Uma célula substitui a construção de produção só se (i) bater o incumbente nas duas janelas, (ii) cruzar ξ_mp ≥ 10 nas duas, e (iii) vencer por margem maior que a dispersão leave-one-month-out do próprio ξ_mp do incumbente — uma vantagem menor do que o que um único mês move não é sinal.

Limiar (iii), lido de `xi_mp_robustness.csv`: **1.20** pontos (maior desvio LOO de ξ_mp = 5.37 na amostra completa).

Maior margem observada: **0.00** (nenhuma célula elegível).

**A regra NÃO dispara.** O incumbente (126 du + soma JK) permanece. Nenhuma célula vence por margem que sobreviva ao ruído amostral do próprio ξ_mp: o melhor desafiante ganha menos do que o que a remoção de um único mês move a estatística. A leitura correta não é que 126 du é o ótimo — ele **não** é o argmax em nenhuma das duas janelas —, e sim que **o vértice não é identificado com precisão suficiente para escolher entre os candidatos**, e que a escolha herdada está dentro do conjunto indistinguível do melhor.

## 5. Contagem de células por variante (agregação por soma)

| sample | instrument | n_vertices | xi_min | xi_median | xi_max | best_bd | n_ge10 | n_ge384 |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_raw |    13 | 3.172 | 4.191 | 7.349 |    42 |     0 |     7 |
| full | z_jk_raw_purif |    13 |  3.09 | 4.096 | 7.124 |    42 |     0 |     7 |
| full | z_jk_bs_purif |    13 | 2.932 | 3.712 | 7.002 |    42 |     0 |     6 |
| full | z_bruto |    13 | 2.059 | 2.949 | 4.943 |    42 |     0 |     4 |
| full | z_jk_purif |    13 | 1.914 |   2.6 | 5.083 |    42 |     0 |     3 |
| pre_covid | z_jk_bs_purif |    13 | 3.869 | 8.079 |  9.76 |    84 |     0 |    13 |
| pre_covid | z_jk_raw_purif |    13 | 5.154 | 7.492 | 8.913 |    84 |     0 |    13 |
| pre_covid | z_jk_raw |    13 | 4.187 | 7.128 | 8.665 |    84 |     0 |    13 |
| pre_covid | z_bruto |    13 | 4.287 | 6.584 | 8.601 |    42 |     0 |    13 |
| pre_covid | z_jk_purif |    13 | 3.248 |  5.17 | 6.596 |    84 |     0 |    11 |

## 6. Diagnóstico de construção por célula

`n_valid` são quintas-feiras válidas, `n_copom` os dias de reunião retidos, e `n_jk_bs` os classificados como monetários pela máscara predeterminada. R² das regressões BS pré-evento para referência (faixa da Tabela 3 de Bauer-Swanson: 0,12–0,20).

| target_bd | n_valid | n_copom | n_jk | n_jk_raw | n_jk_bs | r2_di_bs | r2_ibov_bs |
|---|---|---|---|---|---|---|---|
|    21 |   586 |    92 |    50 |    52 |    55 | 0.072 | 0.016 |
|    42 |   586 |    92 |    54 |    52 |    57 | 0.045 | 0.016 |
|    63 |   586 |    92 |    60 |    55 |    56 | 0.034 | 0.016 |
|    84 |   586 |    92 |    57 |    52 |    60 | 0.044 | 0.016 |
|   105 |   586 |    92 |    63 |    55 |    62 | 0.031 | 0.016 |
|   126 |   586 |    92 |    64 |    54 |    63 | 0.024 | 0.016 |
|   147 |   586 |    92 |    61 |    58 |    61 | 0.037 | 0.016 |
|   168 |   586 |    92 |    62 |    57 |    64 | 0.044 | 0.016 |
|   189 |   586 |    92 |    64 |    58 |    64 | 0.028 | 0.016 |
|   210 |   586 |    92 |    60 |    55 |    61 | 0.041 | 0.016 |
|   252 |   586 |    92 |    61 |    55 |    61 | 0.027 | 0.016 |
|   378 |   586 |    92 |    60 |    55 |    62 | 0.019 | 0.016 |
|   504 |   586 |    92 |    62 |    57 |    61 | 0.016 | 0.016 |

