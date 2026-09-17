# Grade de força MOSW — ξ_mp e F robusto por (r,q) × amostra × instrumento

Gerado por `script/mosw_strength_grid.R` em 2026-09-17.

Grid: q ∈ {2..r}, com r ∈ {4..6} na amostra cheia (12 combinações) e r ∈ {4..8} na pré-COVID (25); × 3 instrumentos = 111 células; p = 4; direção de normalização = `yield_6m`. A cheia para em r = 6 porque, sob a escala de Lenza-Primiceri, o VAR dos fatores é explosivo de r = 7 em diante (raiz máxima 1,001362 em r = 7 e 1,001318 em r = 8).

Instrumentos (camadas de construção do instrumento, conforme `tab:first_stage`): `z_bruto`, `z_bs_purif`, `z_jk_bs_purif`.

As duas estatísticas usam a direção de normalização de `yield_6m`.
Todas as células passaram os gates de estabilidade, finitude e `n_obs`.

Réguas de leitura:

- **10** é uma referência convencional para ξ_mp e F robusto_mp, não um valor crítico fornecido por MOSW.
- **`ar_bounded` deixou de ser previsão em 2026-09-08**: os conjuntos Anderson--Rubin do DFM passaram a ser a inferência operacional e são construídos em `script/ar_bands.R`. A coluna continua sendo o mesmo teste `ξ_mp > 3,84` que o sinal de `ahat` implementa a 95%.
- **ξ_mp ≤ 3,84** significa conjunto AR 95% ilimitado — semirretas ou toda a reta, não intervalo.
- **F robusto_mp** é o primeiro estágio HC1 na mesma direção de normalização de ξ_mp.

## Resumo por instrumento (contagem de células por faixa de ξ_mp)

| sample | instrument | n_cells | xi_mp_ge10 | xi_mp_ge384 | xi_mp_min | xi_mp_median | xi_mp_max | best_rq | f_robust_mp_median |
|---|---|---|---|---|---|---|---|---|---|
| full | z_bruto |    12 |     0 |     9 | 2.566 | 5.318 | 7.813 | (6,6) | 7.296 |
| full | z_bs_purif |    12 |     0 |     9 | 2.328 | 4.805 | 7.249 | (6,6) | 6.138 |
| full | z_jk_bs_purif |    12 |     0 |    12 | 5.124 | 6.654 | 7.473 | (6,6) | 11.28 |
| pre_covid | z_bruto |    25 |    10 |    20 | 2.327 | 9.677 | 13.74 | (8,7) | 10.23 |
| pre_covid | z_bs_purif |    25 |    11 |    20 |  2.28 | 9.858 | 13.18 | (8,7) | 9.913 |
| pre_covid | z_jk_bs_purif |    25 |    13 |    25 |  4.78 | 10.04 | 12.82 | (7,5) | 13.81 |

## Especificação de produção (r=5, q=5, p=4)

| sample | instrument | r | q | n_obs | wald_mp | f_robust_mp | ar_bounded |
|---|---|---|---|---|---|---|---|
| full | z_bruto |     5 |     5 |   162 | 6.678 | 9.367 | TRUE |
| full | z_bs_purif |     5 |     5 |   162 |  6.16 | 7.895 | TRUE |
| full | z_jk_bs_purif |     5 |     5 |   162 | 6.848 | 11.77 | TRUE |
| pre_covid | z_bruto |     5 |     5 |    90 | 6.665 | 7.795 | TRUE |
| pre_covid | z_bs_purif |     5 |     5 |    90 | 6.321 | 6.947 | TRUE |
| pre_covid | z_jk_bs_purif |     5 |     5 |    90 | 8.643 | 13.81 | TRUE |

## Amostra full

### ξ_mp (Wald na direção de impacto de yield_6m)

| instrument | (4,2) | (4,3) | (4,4) | (5,2) | (5,3) | (5,4) | (5,5) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_bruto |  2.96 |  5.36 |  6.12 |  2.59 |  2.57 |  5.27 |  6.68 |  4.38 |  4.31 |  6.43 |  7.48 |  7.81 |
| z_bs_purif |  2.59 |   4.7 |  5.38 |  2.37 |  2.33 |  4.91 |  6.16 |  4.03 |  4.02 |   5.9 |  6.83 |  7.25 |
| z_jk_bs_purif |  5.74 |   6.9 |  7.14 |  5.12 |  5.14 |  6.46 |  6.85 |  5.99 |  5.77 |  6.87 |  7.19 |  7.47 |

### F robusto_mp (primeiro estágio HC1)

| instrument | (4,2) | (4,3) | (4,4) | (5,2) | (5,3) | (5,4) | (5,5) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_bruto |  3.26 |  7.61 |  8.57 |  2.65 |  2.63 |  6.99 |  9.37 |  4.97 |  4.84 |  9.03 | 10.63 | 11.48 |
| z_bs_purif |  2.76 |  6.15 |   6.9 |  2.37 |  2.33 |  6.12 |  7.89 |  4.42 |  4.38 |  7.64 |  8.78 |  9.62 |
| z_jk_bs_purif |   8.9 | 12.71 | 12.64 |  6.95 |  6.97 | 10.79 | 11.77 |  8.73 |  8.25 |  11.9 | 12.45 | 13.22 |

## Amostra pre_covid

### ξ_mp (Wald na direção de impacto de yield_6m)

| instrument | (4,2) | (4,3) | (4,4) | (5,2) | (5,3) | (5,4) | (5,5) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) | (7,2) | (7,3) | (7,4) | (7,5) | (7,6) | (7,7) | (8,2) | (8,3) | (8,4) | (8,5) | (8,6) | (8,7) | (8,8) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_bruto |  2.92 |  6.55 |  6.53 |  2.87 |  6.57 |  6.55 |  6.66 |  2.33 |  8.48 |  9.88 |   9.7 |  9.68 |  3.58 | 10.71 | 11.86 | 12.17 | 12.17 | 12.24 |  3.24 |  4.06 | 10.35 |    13 | 12.15 | 13.74 | 13.61 |
| z_bs_purif |   2.8 |  6.03 |  6.05 |   2.7 |  6.16 |  6.14 |  6.32 |  2.28 |  8.61 | 10.17 |  9.95 | 10.13 |  3.52 | 10.88 | 12.12 | 12.51 | 12.59 | 12.77 |  3.25 |   3.9 |  9.86 | 12.74 |  11.9 | 13.18 | 13.05 |
| z_jk_bs_purif |  4.78 |  8.44 |  8.38 |  4.91 |  8.82 |   8.8 |  8.64 |  5.25 |  9.66 |  10.8 | 10.64 | 10.04 |  6.77 | 11.92 |  12.4 | 12.82 | 12.75 | 12.32 |  6.78 |  7.87 | 10.59 |  12.6 |  10.9 | 11.02 | 10.92 |

### F robusto_mp (primeiro estágio HC1)

| instrument | (4,2) | (4,3) | (4,4) | (5,2) | (5,3) | (5,4) | (5,5) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) | (7,2) | (7,3) | (7,4) | (7,5) | (7,6) | (7,7) | (8,2) | (8,3) | (8,4) | (8,5) | (8,6) | (8,7) | (8,8) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_bruto |  2.68 |  8.14 |  8.27 |  2.42 |  7.49 |  7.47 |  7.79 |   1.8 | 10.23 | 11.98 | 11.57 | 11.97 |  2.82 |  12.6 | 14.49 | 14.51 | 14.53 | 15.37 |   2.3 |  2.96 |  8.84 | 11.51 | 11.89 |    15 | 14.76 |
| z_bs_purif |  2.58 |  7.05 |  7.19 |  2.27 |   6.6 |  6.58 |  6.95 |  1.79 |  9.91 | 11.77 | 11.33 | 12.01 |  2.82 | 12.23 | 14.03 | 14.16 | 14.33 | 15.33 |  2.32 |  2.87 |  8.44 | 11.34 | 11.63 | 14.15 |  13.9 |
| z_jk_bs_purif |  6.16 | 11.61 | 11.47 |  6.58 | 14.23 | 14.25 | 13.81 |  6.45 | 15.51 | 15.43 | 15.04 |  13.6 |   9.3 | 17.48 | 17.95 | 17.12 | 16.63 | 16.04 |  8.93 | 11.32 | 14.59 | 14.37 | 12.01 | 13.18 | 12.99 |

