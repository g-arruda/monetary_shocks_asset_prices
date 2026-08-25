# SVAR-IV de observáveis pelo método de Montiel Olea et al.

> Gerado por `script/model_var.R`; reescrito a cada execução.

A célula de produção usa `{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}` em nível, o instrumento externo `z_jk_bs_purif` e normalização de +50 pb no impacto em `yield_6m`. Cada equação inclui constante e tendência linear. As respostas são os valores `C_h B_1` de cada horizonte.

## AIC, BIC e diagnósticos numéricos

| cell_id | cell | p | n | T_common | deterministic | logdet | n_parameters | aic | bic | selected_aic | selected_bic |
|---|---|---|---|---|---|---|---|---|---|---|---|
| production | ibc5_fx_cds_level_trend_p2 | 1 | 5 | 141 | trend | -11.06988 | 35 | -10.57342 | -9.84146 | FALSE | TRUE |
| production | ibc5_fx_cds_level_trend_p2 | 2 | 5 | 141 | trend | -11.69393 | 60 | -10.84286 | -9.58807 | TRUE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 3 | 5 | 141 | trend | -11.92968 | 85 | -10.72400 | -8.94638 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 4 | 5 | 141 | trend | -12.26993 | 110 | -10.70965 | -8.40920 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 5 | 5 | 141 | trend | -12.62359 | 135 | -10.70870 | -7.88542 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 6 | 5 | 141 | trend | -12.93835 | 160 | -10.66885 | -7.32273 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 7 | 5 | 141 | trend | -13.19021 | 185 | -10.56609 | -6.69715 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 8 | 5 | 141 | trend | -13.37142 | 210 | -10.39270 | -6.00093 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 9 | 5 | 141 | trend | -13.60407 | 235 | -10.27074 | -5.35614 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 10 | 5 | 141 | trend | -14.25480 | 260 | -10.56686 | -5.12943 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 11 | 5 | 141 | trend | -14.63094 | 285 | -10.58839 | -4.62813 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p2 | 12 | 5 | 141 | trend | -14.92588 | 310 | -10.52872 | -4.04563 | FALSE | FALSE |


| cell_id | cell | n | p | T_eff | hac_dim | lag_common_T | aic_selected | bic_selected | xi_var | ar_bounded_90 | max_eig | gamma_yield | n_inst | n_inst_nonzero |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| production | ibc5_fx_cds_level_trend_p2 | 5 | 2 | 151 | 90 | 141 | 2 | 1 | 6.79734 | TRUE | 0.96542 | 0.01238 | 151 | 61 |


AIC e BIC usam as mesmas T = 141 observações para p = 1,...,12. O AIC seleciona p = 2 e o BIC seleciona p = 1. A produção segue o AIC. `NWlags = 0`.

## Topologias dos conjuntos Anderson--Rubin

| level | set_type | n_sets |
|---|---|---|
| 0.68 | interval | 184 |
| 0.68 | singleton | 1 |
| 0.90 | interval | 184 |
| 0.90 | singleton | 1 |


O CSV preserva intervalos, conjuntos vazios, singletons, semirretas, duas semirretas e a reta inteira sem substituir limites infinitos.

## Respostas de manchete até h = 4, AR 90%

| cell_id | cell | var | h | point | ar_set |
|---|---|---|---|---|---|
| production | ibc5_fx_cds_level_trend_p2 | cambio_usd | 0 | 0.0805 | [0.0289; 0.1626] |
| production | ibc5_fx_cds_level_trend_p2 | cds_5y | 0 | 18.8585 | [8.2727; 38.5309] |
| production | ibc5_fx_cds_level_trend_p2 | cambio_usd | 1 | 0.1187 | [0.0400; 0.2414] |
| production | ibc5_fx_cds_level_trend_p2 | cds_5y | 1 | 21.9656 | [9.1997; 44.0700] |
| production | ibc5_fx_cds_level_trend_p2 | cambio_usd | 2 | 0.1068 | [0.0221; 0.2266] |
| production | ibc5_fx_cds_level_trend_p2 | cds_5y | 2 | 21.1440 | [7.5060; 42.4869] |
| production | ibc5_fx_cds_level_trend_p2 | cambio_usd | 3 | 0.0900 | [0.0077; 0.1989] |
| production | ibc5_fx_cds_level_trend_p2 | cds_5y | 3 | 19.1729 | [5.9450; 38.4400] |
| production | ibc5_fx_cds_level_trend_p2 | cambio_usd | 4 | 0.0735 | [-0.0032; 0.1712] |
| production | ibc5_fx_cds_level_trend_p2 | cds_5y | 4 | 17.4427 | [4.8234; 34.8246] |


A fonte canônica dos pontos e conjuntos AR é `output/var/svar_iv_weak_robust.csv`.
