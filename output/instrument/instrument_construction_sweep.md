# Robustez da construção do instrumento — vértice do DI e esquema de agregação

Gerado por `script/instrument_construction_sweep.R` em 2026-08-13.

Grid: 13 vértices × 2 esquemas de agregação × 5 variantes × 2 amostras = 260 células. Dimensão (r, q) = (5, 5), p = 6, direção de normalização = `yield_6m`. Um `estimate_dfm` por amostra.

**Incumbente:** vértice 126 du + soma JK + `z_jk_bs_purif` — ξ_mp = 6.26 full / 10.58 pré-COVID.

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
| z_jk_bs_purif |  5.22 |  8.85 |  5.62 |  7.04 |  4.33 |  6.26 |  5.85 |  3.94 |  3.54 |  3.81 |  4.29 |  4.55 |  5.01 |
| z_jk_raw |  5.36 |  9.78 |  6.57 |  7.51 |  5.05 |  6.49 |  6.14 |  4.37 |  3.82 |  4.26 |  4.43 |  4.86 |  5.04 |
| z_jk_raw_purif |  5.12 |  9.35 |  6.47 |  7.42 |  4.91 |  6.34 |  5.96 |  4.24 |  3.68 |  4.18 |  4.41 |  4.86 |     5 |
| z_jk_purif |  2.95 |   6.4 |  2.99 |  4.91 |   3.1 |  3.98 |  4.23 |  3.05 |  2.71 |  2.56 |  3.17 |  3.41 |  3.14 |
| z_bruto |  2.04 |  6.13 |  3.02 |  5.86 |  4.29 |  5.26 |   5.8 |  3.83 |   3.5 |  3.31 |  4.46 |  4.56 |   4.9 |

### Pré-COVID

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif | 11.72 | 16.14 | 14.33 | 12.65 | 10.57 | 10.58 | 11.68 |   7.3 |  6.35 | 10.14 |  5.55 |  4.74 |  3.16 |
| z_jk_raw | 11.48 | 15.18 | 13.68 | 13.15 | 10.93 | 11.02 |  12.2 |  9.07 |  8.12 | 11.17 |  7.88 |  6.78 |  5.74 |
| z_jk_raw_purif | 11.22 | 15.02 | 13.59 | 13.31 | 11.05 | 11.32 | 12.76 |  9.82 |  8.37 | 11.95 |  8.61 |  7.97 |  7.01 |
| z_jk_purif |  6.77 |  8.28 |  7.63 |   8.2 |  6.83 |  7.56 |  8.44 |  6.23 |  5.13 |  7.04 |  4.22 |  3.86 |     3 |
| z_bruto | 11.36 | 16.17 | 14.53 | 14.94 | 14.62 | 14.86 | 16.45 | 12.67 | 11.16 | 15.62 | 10.68 | 11.88 |  9.85 |

## 3. ξ_mp por vértice — agregação Gertler-Karadi (nota 11)

Lida em **NW(1)**: o esquema GK parte cada surpresa entre `t` e `t+1`, o que induz MA(1) por construção. A coluna `wald_mp_nw0` do CSV traz a mesma célula em NW(0) para comparação na mesma convenção do painel de soma. Sob GK os meses sem reunião **deixam de ser zero**, então a propriedade que JK e BS assumem se perde.

### Amostra completa

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |  1.01 |   0.8 |  0.01 |  0.02 |     0 |  0.13 |  0.08 |  0.08 |  0.02 |  0.02 |  0.05 |     0 |     0 |
| z_jk_raw |  1.32 |  2.15 |  0.09 |  0.15 |  0.11 |  0.84 |  0.74 |  0.45 |  0.26 |  0.41 |  0.39 |  0.21 |  0.21 |
| z_jk_raw_purif |  1.11 |  1.78 |   0.1 |  0.11 |  0.07 |  0.79 |  0.66 |  0.38 |   0.2 |   0.3 |  0.37 |   0.2 |  0.21 |
| z_jk_purif |  0.38 |  0.41 |  0.41 |  0.16 |  0.35 |  0.04 |  0.03 |  0.07 |  0.15 |   0.5 |  0.02 |  0.16 |  0.35 |
| z_bruto |  0.38 |  0.03 |  1.03 |  0.51 |  0.43 |  0.28 |     0 |  0.16 |  0.19 |  0.53 |  0.03 |  0.33 |  0.48 |

### Pré-COVID

| instrument | 21du | 42du | 63du | 84du | 105du | 126du | 147du | 168du | 189du | 210du | 252du | 378du | 504du |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_jk_bs_purif |  4.68 |  7.19 |  4.51 |  2.11 |  2.15 |  0.98 |  0.98 |  0.01 |  0.04 |  0.24 |     0 |  0.29 |  0.89 |
| z_jk_raw |  5.08 |  8.45 |  5.65 |  4.99 |  4.56 |  5.34 |  5.55 |  2.29 |  2.35 |  4.68 |   1.8 |  0.72 |  0.15 |
| z_jk_raw_purif |  4.64 |  7.85 |  5.17 |  4.47 |  3.96 |  5.08 |  5.34 |  2.28 |  2.04 |  4.39 |  1.83 |  0.98 |  0.33 |
| z_jk_purif |  1.79 |  2.14 |   1.3 |  1.28 |  0.93 |  1.19 |  1.15 |  0.34 |  0.23 |  0.39 |  0.16 |  0.01 |  0.11 |
| z_bruto |  5.52 |  6.71 |  6.14 |  4.87 |  5.91 |  3.49 |  4.39 |  2.45 |   1.7 |   2.6 |  1.51 |  1.04 |  0.19 |

## 4. Células que batem o incumbente nas duas janelas e cruzam 10 nas duas

_Nenhuma._ O incumbente não é dominado por nenhuma célula da grade.

### Veredito da regra de decisão

A regra foi fixada **antes** de qualquer um destes números existir (plano de 2026-07-27). Uma célula substitui a construção de produção só se (i) bater o incumbente nas duas janelas, (ii) cruzar ξ_mp ≥ 10 nas duas, e (iii) vencer por margem maior que a dispersão leave-one-month-out do próprio ξ_mp do incumbente — uma vantagem menor do que o que um único mês move não é sinal.

Limiar (iii), lido de `xi_mp_robustness.csv`: **1.38** pontos (maior desvio LOO de ξ_mp = 6.26 na amostra completa).

Maior margem observada: **0.00** (nenhuma célula elegível).

**A regra NÃO dispara.** O incumbente (126 du + soma JK) permanece. Nenhuma célula vence por margem que sobreviva ao ruído amostral do próprio ξ_mp: o melhor desafiante ganha menos do que o que a remoção de um único mês move a estatística. A leitura correta não é que 126 du é o ótimo — ele **não** é o argmax em nenhuma das duas janelas —, e sim que **o vértice não é identificado com precisão suficiente para escolher entre os candidatos**, e que a escolha herdada está dentro do conjunto indistinguível do melhor.

## 5. Contagem de células por variante (agregação por soma)

| sample | instrument | n_vertices | xi_min | xi_median | xi_max | best_bd | n_ge10 | n_ge384 |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_raw |    13 | 3.818 |  5.05 | 9.781 |    42 |     0 |    12 |
| full | z_jk_bs_purif |    13 | 3.542 | 5.006 | 8.847 |    42 |     0 |    11 |
| full | z_jk_raw_purif |    13 | 3.678 | 5.001 | 9.351 |    42 |     0 |    12 |
| full | z_bruto |    13 | 2.045 | 4.461 | 6.134 |    42 |     0 |     8 |
| full | z_jk_purif |    13 | 2.563 | 3.138 | 6.401 |    42 |     0 |     4 |
| pre_covid | z_bruto |    13 | 9.847 | 14.53 | 16.44 |   147 |    12 |    13 |
| pre_covid | z_jk_raw_purif |    13 | 7.008 | 11.22 | 15.02 |    42 |     8 |    13 |
| pre_covid | z_jk_raw |    13 | 5.744 | 11.02 | 15.18 |    42 |     8 |    13 |
| pre_covid | z_jk_bs_purif |    13 |  3.16 | 10.57 | 16.14 |    42 |     8 |    12 |
| pre_covid | z_jk_purif |    13 | 3.003 | 6.831 | 8.444 |   147 |     0 |    12 |

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

