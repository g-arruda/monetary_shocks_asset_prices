# SVAR-IV de observáveis pelo método de Montiel Olea et al.

> Gerado por `script/model_var.R`; reescrito a cada execução.

A célula de produção usa `{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}` em nível, o instrumento externo `z_jk_bs_purif` e normalização de +50 pb no impacto em `yield_6m`. Cada equação inclui constante e tendência linear. As respostas são os valores `C_h B_1` de cada horizonte.

## AIC, BIC e diagnósticos numéricos

| cell_id | cell | p | n | T_common | deterministic | logdet | n_parameters | aic | bic | selected_aic | selected_bic |
|---|---|---|---|---|---|---|---|---|---|---|---|
| production | ibc5_fx_cds_level_trend_p4 | 1 | 5 | 154 | trend | -11.29305 | 35 | -10.83851 | -10.14829 | FALSE | TRUE |
| production | ibc5_fx_cds_level_trend_p4 | 2 | 5 | 154 | trend | -11.88566 | 60 | -11.10644 | -9.92321 | TRUE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 3 | 5 | 154 | trend | -12.12055 | 85 | -11.01665 | -9.34041 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 4 | 5 | 154 | trend | -12.43478 | 110 | -11.00621 | -8.83695 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 5 | 5 | 154 | trend | -12.78182 | 135 | -11.02858 | -8.36631 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 6 | 5 | 154 | trend | -13.08690 | 160 | -11.00898 | -7.85370 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 7 | 5 | 154 | trend | -13.31437 | 185 | -10.91177 | -7.26349 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 8 | 5 | 154 | trend | -13.48375 | 210 | -10.75648 | -6.61518 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 9 | 5 | 154 | trend | -13.68341 | 235 | -10.63146 | -5.99715 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 10 | 5 | 154 | trend | -14.22590 | 260 | -10.84928 | -5.72195 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 11 | 5 | 154 | trend | -14.56145 | 285 | -10.86015 | -5.23981 | FALSE | FALSE |
| production | ibc5_fx_cds_level_trend_p4 | 12 | 5 | 154 | trend | -14.81271 | 310 | -10.78674 | -4.67339 | FALSE | FALSE |


| cell_id | cell | n | p | T_eff | hac_dim | lag_common_T | aic_selected | bic_selected | xi_var | ar_bounded_90 | max_eig | gamma_yield | n_inst | n_inst_nonzero |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| production | ibc5_fx_cds_level_trend_p4 | 5 | 4 | 162 | 140 | 154 | 2 | 1 | 7.25832 | TRUE | 0.97652 | 0.01117 | 162 | 65 |


AIC e BIC usam as mesmas T = 154 observações para p = 1,...,12. O AIC seleciona p = 2 e o BIC seleciona p = 1. A produção usa p = 4, o mesmo do DFM, para que o contraste entre os dois modelos não seja de ordem nem de amostra; não é a escolha do AIC. `NWlags = 0`.

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
| production | ibc5_fx_cds_level_trend_p4 | cambio_usd | 0 | 0.0810 | [0.0306; 0.1612] |
| production | ibc5_fx_cds_level_trend_p4 | cds_5y | 0 | 15.6812 | [4.1056; 33.5354] |
| production | ibc5_fx_cds_level_trend_p4 | cambio_usd | 1 | 0.1141 | [0.0294; 0.2430] |
| production | ibc5_fx_cds_level_trend_p4 | cds_5y | 1 | 19.6079 | [4.5406; 43.7069] |
| production | ibc5_fx_cds_level_trend_p4 | cambio_usd | 2 | 0.0923 | [0.0012; 0.2226] |
| production | ibc5_fx_cds_level_trend_p4 | cds_5y | 2 | 12.2188 | [-3.4243; 34.2253] |
| production | ibc5_fx_cds_level_trend_p4 | cambio_usd | 3 | 0.0819 | [0.0024; 0.1853] |
| production | ibc5_fx_cds_level_trend_p4 | cds_5y | 3 | 20.1919 | [5.2725; 41.3134] |
| production | ibc5_fx_cds_level_trend_p4 | cambio_usd | 4 | 0.0981 | [0.0223; 0.2006] |
| production | ibc5_fx_cds_level_trend_p4 | cds_5y | 4 | 21.0260 | [6.4179; 41.4297] |


A fonte canônica dos pontos e conjuntos AR é `output/var/svar_iv_weak_robust.csv`.
