# Bandas Anderson-Rubin — inversão do teste de Montiel Olea-Stock-Watson

> Corpo **gerado** por `script/ar_bands.R`; reescrito por inteiro a cada
> execução. Nunca escreva prosa aqui — a leitura interpretativa mora em
> `relatorio/working-notes/2026-08-10_bandas_anderson_rubin.md`.

Spec: `z_jk_bs_purif` × `yield_6m`, r = 7, q = 6, p = 6, h = 0-48, choque +50 pb, NW(0).

## 1. Força do instrumento e limitação do conjunto

| janela | T_eff | xi_mp | dim_W | limitado_68 | limitado_90 | limitado_95 |
|---|---|---|---|---|---|---|
| full | 147 | 10.431 | 301 | TRUE | TRUE | TRUE |
| pre_covid |  78 | 12.223 | 301 | TRUE | TRUE | TRUE |

O coeficiente de λ² da quadrática é `T·den² − κ·d0'W₂d0`, logo o conjunto é limitado em **todos** os horizontes se e somente se ξ_mp > κ. `W` é 301 × 301 estimada com T = 147: posto deficiente, como na própria aplicação do petróleo de MOSW (398 > 356). A quadrática só usa formas quadráticas `d'Wd`, nunca `W⁻¹`.

## 2. Prêmio de IV fraco: quanto a inversão alarga a banda de Wald

| sample | level | xi_mp | critval | razao_mediana | razao_min | razao_max |
|---|---|---|---|---|---|---|
| full | 0.680 | 10.431 | 0.989 | 1.052 | 1.051 | 1.061 |
| full | 0.900 | 10.431 | 2.706 | 1.164 | 1.162 | 1.200 |
| full | 0.950 | 10.431 | 3.841 | 1.263 | 1.258 | 1.326 |
| pre_covid | 0.680 | 12.223 | 0.989 | 1.043 | 1.043 | 1.052 |
| pre_covid | 0.900 | 12.223 | 2.706 | 1.134 | 1.133 | 1.164 |
| pre_covid | 0.950 | 12.223 | 3.841 | 1.209 | 1.206 | 1.260 |

Razão de larguras AR / delta-method sobre as 106 séries × 49 horizontes. As duas bandas compartilham derivada, `W` e condicionamento, então a razão isola a correção de IV fraco. Ela é quase constante entre séries porque a fraqueza mora no **denominador comum** da normalização (`d0'Γ`), não no numerador específico de cada série.

## 3. Placar das três réguas (amostra cheia, 53 séries × 49 horizontes)

| level | celulas | n_boot | n_delta | n_ar | boot_no_ar | delta_no_ar | razao_ar_boot | razao_ar_dm |
|---|---|---|---|---|---|---|---|---|
| 0.680 | 2597 | 706 | 1767 | 1735 | 17 |  36 | 0.661 | 1.052 |
| 0.900 | 2597 |  92 | 1091 |  941 |  4 | 150 | 0.646 | 1.165 |

A comparação **limpa** é `razao_ar_dm`: AR e delta-method partem da mesma derivada, da mesma `W` e do mesmo condicionamento no espaço de fatores, e diferem **só** por o AR não dividir pelo denominador estimado. `razao_ar_boot` mistura duas coisas — a correção de IV fraco e o fato de o bootstrap reestimar o DFM a cada réplica, incerteza que nenhuma das duas bandas assintóticas carrega.

## 4. Manchetes no impacto (h = 0, 90%)

| var | ponto | AR | delta | bootstrap | assimetria |
|---|---|---|---|---|---|
| cambio_usd | 0.1498 | [0.081, 0.246] | [0.080, 0.220] | [0.079, 0.297] | 1.4104 |
| yield_6m | 0.0050 | [0.005, 0.005] | [0.005, 0.005] | [0.005, 0.005] |   NaN |
| yield_2y | 0.0092 | [0.008, 0.010] | [0.008, 0.010] | [0.007, 0.013] | 1.1752 |
| yield_5y | 0.0093 | [0.007, 0.012] | [0.007, 0.011] | [0.007, 0.015] | 1.1583 |
| price_ipca | -0.0703 | [-0.381, 0.130] | [-0.285, 0.145] | [-0.371, 0.143] | 0.6443 |
| asset_ibov | -1.6726 | [-5.981, 3.469] | [-5.723, 2.378] | [-7.771, 1.759] | 1.1932 |
| embi_perc | 0.1995 | [0.049, 0.358] | [0.066, 0.333] | [0.078, 0.509] | 1.0504 |
| cds_5y | 29.0673 | [13.647, 46.516] | [14.951, 43.184] | [16.524, 62.509] | 1.1316 |

`assimetria` = (limite superior − ponto) / (ponto − limite inferior). Uma banda de Wald vale 1 por construção; o afastamento de 1 é o que a inversão acrescenta.

## 5. Onde a correção de IV fraco morde mais (90%, razão AR/delta)

| var | n_bounded | n_boot_sig | n_dm_sig | n_ar_sig | razao_ar_dm | razao_ar_boot |
|---|---|---|---|---|---|---|
| asset_ifnc | 49 | 0 | 37 | 37 | 1.170 | 0.555 |
| asset_imob | 49 | 0 | 29 | 26 | 1.169 | 0.489 |
| asset_idiv | 49 | 0 | 35 | 34 | 1.169 | 0.521 |
| asset_ibov | 49 | 0 | 28 | 26 | 1.167 | 0.511 |
| trab_de_1_ano_a_menos_de_2_anos | 49 | 0 | 35 | 31 | 1.167 |   NA |
| yield_6m | 49 | 4 | 35 | 31 | 1.167 | 0.668 |
| yield_3m | 49 | 4 | 34 | 28 | 1.167 | 0.654 |
| asset_ifix | 49 | 0 | 48 | 48 | 1.167 | 0.608 |
| trab_x2_anos_ou_mais | 49 | 0 | 28 | 25 | 1.167 |   NA |
| juros_selic | 49 | 0 | 27 | 25 | 1.167 | 0.625 |
| juros_cdi | 49 | 0 | 27 | 25 | 1.167 | 0.623 |
| yield_1y | 49 | 6 | 33 | 30 | 1.167 | 0.677 |
| asset_mlcx | 49 | 0 | 22 | 19 | 1.167 | 0.499 |
| trab_tx_desemprego | 49 | 0 | 26 | 23 | 1.167 | 0.747 |
| price_core_ipc | 49 | 0 | 24 | 21 | 1.166 |   NA |

## 6. Células sig90 que não sobrevivem ao AR

Contra o bootstrap:

| var | h | ponto | AR |
|---|---|---|---|
| cambio_eur | 3.0000 | 0.1202 | [-0.011, 0.249] |
| ind_bens_capital | 0.0000 | -2.6006 | [-6.170, 0.158] |
| ind_bens_duraveis | 0.0000 | -5.4734 | [-12.695, 0.034] |
| ind_transformacao | 0.0000 | -1.4109 | [-3.566, 0.312] |

Contra o delta-method (a comparação que isola a correção de IV fraco):

| var | celulas_perdidas |
|---|---|
| spread_icc_juridica | 10 |
| trab_pop_forca_trab |  8 |
| commodity_agro |  7 |
| commodity_energia |  7 |
| sp500_vix |  7 |
| cambio_eur |  6 |
| ind_bens_consumo |  6 |
| price_igp_m |  6 |
| trab_hrs_trabalhadas_industria |  6 |
| yield_3m |  6 |
| cambio_inr |  5 |
| consumo_gasolina |  5 |
| epu_india |  5 |
| ind_bens_duraveis |  5 |
| ind_bens_nao_duraveis |  5 |
| base_m2 |  4 |
| cambio_ars |  4 |
| consumo_oleo_combustivel |  4 |
| epu_canada |  4 |
| epu_germany |  4 |

