# Conjuntos Anderson-Rubin do DFM — inversão do teste de Montiel Olea-Stock-Watson

> Corpo **gerado** por `script/ar_bands.R`; reescrito por inteiro a cada
> execução. Nunca escreva prosa aqui — a leitura interpretativa mora em
> `notas/2026-09-08_bandas_anderson_rubin_producao.md`.

Spec: `z_jk_bs_purif` × `yield_6m`, p = 4, h = 0-48, choque +50 pb, NW(0), wild bootstrap de comparação com nboot = 800 (seed 123).

## 1. Força do instrumento e limitação do conjunto

| cell | r | q | p | T_eff | hac_dim | n_par | xi_mp | max_eig | limitado_68 | limitado_90 | limitado_95 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| producao |     5 |     5 |     4 |   162 |   135 |   105 | 6.057 | 0.9701 | TRUE | TRUE | TRUE |
| r5q2 |     5 |     2 |     4 |   162 |   135 |   105 | 2.339 | 0.9701 | TRUE | FALSE | FALSE |

O coeficiente de λ² da quadrática é `T·den² − κ·d0'W₂d0`, logo o conjunto é limitado em **todos** os horizontes se e somente se ξ_mp > κ, com κ = 0,989 (68%), 2,706 (90%) e 3,841 (95%). Nenhum passo usa `W⁻¹`: a quadrática só toca `W` por formas `d'Wd`.

### Células que não rodam

| celula | r | q | p | resultado |
|---|---|---|---|---|
| r8q8/full |   8 |   8 |   4 | ar_dfm_bands: HAC moment dimension is 336 >= T = 162: WHat is singular at r = 8, p = 4. No pseudo-inverse and no fallback — reduce r or p. |
| producao/pre_covid |   5 |   5 |   4 | ar_dfm_bands: HAC moment dimension is 135 >= T = 90: WHat is singular at r = 5, p = 4. No pseudo-inverse and no fallback — reduce r or p. |

`r8q8/full` é a sugestão 4/5 do orientador; `producao/pre_covid` é a janela de robustez que o wild bootstrap cobria. As duas esbarram no mesmo gate, `hac_dim < T`, e o script não tenta pseudo-inversa, bootstrap substituto ou qualquer fallback.

## 2. Topologia dos conjuntos

| cell | level | set_type | n_celulas |
|---|---|---|---|
| producao | 0.68 | interval |    5634 |
| producao | 0.68 | singleton |       1 |
| producao | 0.90 | interval |    5634 |
| producao | 0.90 | singleton |       1 |
| producao | 0.95 | interval |    5634 |
| producao | 0.95 | singleton |       1 |
| r5q2 | 0.68 | interval |    5634 |
| r5q2 | 0.68 | singleton |       1 |
| r5q2 | 0.90 | real_line |    2205 |
| r5q2 | 0.90 | singleton |       1 |
| r5q2 | 0.90 | two_rays |    3429 |
| r5q2 | 0.95 | real_line |    4782 |
| r5q2 | 0.95 | singleton |       1 |
| r5q2 | 0.95 | two_rays |     852 |

## 3. Prêmio de instrumento fraco: quanto a inversão alarga a banda de Wald

| cell | level | xi_mp | critval | razao_mediana | razao_min | razao_max |
|---|---|---|---|---|---|---|
| producao | 0.68 | 6.057 | 0.9889 | 1.101 | 1.093 | 1.126 |
| producao | 0.90 | 6.057 | 2.706 | 1.382 | 1.344 | 1.506 |
| producao | 0.95 | 6.057 | 3.841 | 1.751 | 1.653 | 2.057 |
| r5q2 | 0.68 | 2.339 | 0.9889 | 1.409 | 1.316 | 1.641 |
| r5q2 | 0.90 | 2.339 | 2.706 | 3.969 | 0.03126 |   Inf |
| r5q2 | 0.95 | 2.339 | 3.841 |   Inf | 0.03398 |   Inf |

Razão de larguras AR / delta-method. As duas bandas compartilham derivada, `W` e condicionamento, então a razão isola a correção de instrumento fraco. Ela é quase constante entre séries porque a fraqueza mora no **denominador comum** da normalização (`d0'Γ`), não no numerador específico de cada série.

## 4. Placar das três réguas na produção (amostra cheia, 115 séries × 49 horizontes)

| level | celulas | n_boot | n_delta | n_ar | boot_no_ar | ar_no_boot | razao_ar_boot | razao_ar_dm |
|---|---|---|---|---|---|---|---|---|
| 0.68 |    5635 |    1721 |    3518 |    3474 |     157 |    1910 | 1.01918 | 1.10065 |
| 0.90 |    5635 |     563 |    1075 |     759 |     244 |     440 | 1.21655 | 1.38174 |
| 0.95 |    5635 |     310 |     565 |     166 |     207 |      63 | 1.48075 | 1.75073 |

## 5. Onde AR e bootstrap divergem, por faixa de horizonte (90%)

| faixa | celulas | razao_ar_boot | n_boot | n_ar | ponto_fora_do_boot |
|---|---|---|---|---|---|
| 0 |     114 | 1.40374 |      66 |      54 |       0 |
| 1-6 |     690 | 1.24121 |     191 |     158 |       0 |
| 7-12 |     690 | 1.10037 |     136 |     107 |       0 |
| 13-24 |    1380 | 1.17245 |     169 |     260 |       0 |
| 25-36 |    1380 | 1.23392 |       0 |     171 |       0 |
| 37-48 |    1380 | 1.31576 |       0 |       8 |       0 |

`ponto_fora_do_boot` conta as células em que a estimativa pontual cai fora da própria banda de bootstrap. O conjunto AR contém o ponto por construção; a banda percentil do bootstrap não.

## 6. Manchetes no impacto (h = 0, 90%, produção)

| var | ponto | AR | delta | bootstrap | assimetria |
|---|---|---|---|---|---|
| cambio_usd | 0.1342 | [0.073; 0.262] | [0.068; 0.200] | [0.084; 0.186] | 2.079 |
| yield_6m | 0.005 | {0.005} | [0.005; 0.005] | [0.005; 0.005] |   NaN |
| yield_2y | 0.007026 | [0.006; 0.009] | [0.006; 0.008] | [0.006; 0.008] | 1.375 |
| yield_5y | 0.007246 | [0.005; 0.011] | [0.005; 0.010] | [0.005; 0.009] | 1.662 |
| asset_ibov | -0.9965 | [-7.902; 4.263] | [-5.479; 3.486] | [-4.169; 1.304] | 0.7617 |
| embi_perc | 0.2433 | [0.096; 0.527] | [0.091; 0.395] | [0.160; 0.363] | 1.932 |
| cds_5y | 29.91 | [14.674; 60.763] | [13.781; 46.036] | [20.395; 41.883] | 2.025 |
| price_ipca | -0.04363 | [-0.387; 0.104] | [-0.211; 0.124] | [-0.181; 0.076] | 0.4309 |

`assimetria` = (limite superior − ponto) / (ponto − limite inferior). Uma banda de Wald vale 1 por construção; o afastamento de 1 é o que a inversão acrescenta.

## 7. Produção contra (r=5, q=2) no impacto (h = 0, 90%)

| var | producao | r5q2 |
|---|---|---|
| cambio_usd | [0.073; 0.262] | (-Inf; -2.701] U [0.258; Inf) |
| yield_6m | {0.005} | {0.005} |
| yield_2y | [0.006; 0.009] | (-Inf; -0.043] U [0.011; Inf) |
| yield_5y | [0.005; 0.011] | (-Inf; -0.095] U [0.014; Inf) |
| asset_ibov | [-7.902; 4.263] | (-Inf; -15.647] U [102.453; Inf) |
| embi_perc | [0.096; 0.527] | (-Inf; -7.233] U [0.572; Inf) |
| cds_5y | [14.674; 60.763] | (-Inf; -760.425] U [64.654; Inf) |
| price_ipca | [-0.387; 0.104] | (-Inf; 0.163] U [0.984; Inf) |

## 8. Onde a correção de instrumento fraco morde mais (produção, 90%, razão AR/delta)

| var | n_limitado | n_boot_sig | n_dm_sig | n_ar_sig | razao_ar_dm | razao_ar_boot |
|---|---|---|---|---|---|---|
| price_inpc |   49 |    0 |   12 |   13 | 1.41 | 1.47 |
| price_ipc |   49 |    0 |   13 |   15 | 1.41 | 1.47 |
| price_core_ipca_ex1 |   49 |    0 |    7 |    9 | 1.41 |  1.4 |
| price_ipca |   49 |    0 |    5 |    7 | 1.41 | 1.51 |
| sp500_vix |   49 |    0 |    1 |    0 | 1.41 | 1.04 |
| trab_min_wage |   49 |    0 |    0 |    0 | 1.41 | 0.734 |
| price_core_ipca_dw |   49 |    0 |    0 |    1 |  1.4 | 1.56 |
| price_ipca_difusao |   49 |    0 |    3 |    1 |  1.4 | 1.54 |
| price_incc |   49 |    0 |   10 |   11 |  1.4 | 1.16 |
| price_core_ipca_ex0 |   49 |    0 |    6 |    0 |  1.4 | 1.36 |
| expect_focus_ipca12m |   49 |    9 |    7 |    2 |  1.4 |  1.5 |
| commodity_energia |   49 |    8 |    8 |    4 |  1.4 |  1.4 |
| price_core_ipc |   49 |    0 |    0 |    0 |  1.4 | 1.51 |
| asset_imob |   49 |    0 |    5 |    0 |  1.4 | 0.801 |
| ind_min_extr |   49 |    0 |   13 |    9 |  1.4 | 1.43 |

