# Sensibilidade do VAR observável à ordem de defasagem

> Gerado por `script/var_lag_comparison.R`; reescrito a cada execução.
> Este exercício não altera o benchmark oficial `p=2` nem a inferência do DFM.

As três células mantêm as cinco séries em nível, constante e tendência linear, o instrumento `z_jk_bs_purif`, a normalização de +50 pb em `yield_6m` e `h=0,...,36`. A comparação principal usa os mesmos 147 resíduos em `p2_common` e `p6_common`; o `p2_canonical`, com 151 resíduos, aparece somente como referência.

## Diagnósticos

| cell_id | p | n_parameters | T_eff | residual_start | residual_end | n_inst_nonzero | gamma_yield | max_root | stable | hac_dim | inference_status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| p2_canonical | 2 | 60 | 151 | 2013-03-01 | 2025-09-01 | 61 | 0.012380 | 0.965424 | TRUE | 90 | WHat viável; AR não reestimado neste exercício |
| p2_common | 2 | 60 | 147 | 2013-07-01 | 2025-09-01 | 60 | 0.012962 | 0.963438 | TRUE | 90 | WHat viável; AR não reestimado neste exercício |
| p6_common | 6 | 160 | 147 | 2013-07-01 | 2025-09-01 | 60 | 0.010094 | 0.970104 | TRUE | 190 | AR indisponível: dimensão HAC >= T |


## Ajuste na amostra comum

| cell_id | p | T_eff | common_logdet | common_aic | common_bic |
|---|---|---|---|---|---|
| p2_common | 2 | 147 | -11.75495 | -10.93862 | -9.718038 |
| p6_common | 6 | 147 | -12.98092 | -10.80405 | -7.549157 |


O log-determinante, o AIC e o BIC desta tabela são comparáveis porque as duas células usam exatamente os mesmos 147 resíduos. O VAR(2) tem 60 parâmetros no sistema e o VAR(6), 160.

## Efeito de retirar os quatro primeiros resíduos

| comparison | var | path_correlation | max_abs_difference | reference_first_zero_crossing | first_zero_crossing |
|---|---|---|---|---|---|
| efeito de retirar os quatro primeiros resíduos | cambio_usd | 0.999171 | 0.017440 | 12 | 11 |
| efeito de retirar os quatro primeiros resíduos | cds_5y | 0.996965 | 4.170883 | 29 | 28 |
| efeito de retirar os quatro primeiros resíduos | ibc_br | 0.949311 | 0.251091 | NA | 4 |
| efeito de retirar os quatro primeiros resíduos | price_ipca | 0.997839 | 0.008081 | 1 | 1 |
| efeito de retirar os quatro primeiros resíduos | yield_6m | 0.995757 | 0.001047 | 32 | 35 |


Esta seção compara `p2_canonical` e `p2_common` e, portanto, isola apenas o alinhamento amostral. Não envolve mudança da ordem de defasagem.

## Efeito da ordem de defasagem

| comparison | var | path_correlation | max_abs_difference | reference_first_zero_crossing | first_zero_crossing |
|---|---|---|---|---|---|
| efeito da ordem de defasagem na amostra comum | cambio_usd | 0.992090 | 0.032775 | 11 | 12 |
| efeito da ordem de defasagem na amostra comum | cds_5y | 0.959589 | 5.591977 | 28 | 26 |
| efeito da ordem de defasagem na amostra comum | ibc_br | 0.350021 | 0.314912 | 4 | 2 |
| efeito da ordem de defasagem na amostra comum | price_ipca | 0.872973 | 0.105754 | 1 | 9 |
| efeito da ordem de defasagem na amostra comum | yield_6m | 0.995249 | 0.003533 | 35 | 28 |


Esta seção compara `p2_common` e `p6_common`, com meses residuais e vetor instrumental idênticos. Correlações e diferenças descrevem trajetórias pontuais; não são testes de igualdade.

## Respostas em horizontes selecionados

| var | h | p2_canonical | p2_common | p6_common |
|---|---|---|---|---|
| ibc_br | 0 | -0.697746 | -0.529322 | -0.395455 |
| ibc_br | 1 | -0.478450 | -0.252294 | -0.043785 |
| ibc_br | 4 | -0.203784 | 0.039459 | 0.215985 |
| ibc_br | 12 | -0.054714 | 0.137063 | -0.107898 |
| ibc_br | 24 | -0.015694 | 0.131911 | -0.054616 |
| ibc_br | 36 | -0.027238 | 0.060894 | -0.078481 |
| price_ipca | 0 | -0.018708 | -0.021771 | 0.025745 |
| price_ipca | 1 | 0.025561 | 0.033642 | 0.080291 |
| price_ipca | 4 | 0.049430 | 0.049663 | 0.113830 |
| price_ipca | 12 | 0.004602 | 0.003162 | -0.013389 |
| price_ipca | 24 | -0.022347 | -0.025672 | -0.041029 |
| price_ipca | 36 | -0.018188 | -0.021998 | -0.022251 |
| yield_6m | 0 | 0.005000 | 0.005000 | 0.005000 |
| yield_6m | 1 | 0.006330 | 0.006469 | 0.005916 |
| yield_6m | 4 | 0.007172 | 0.007659 | 0.008692 |
| yield_6m | 12 | 0.006632 | 0.007570 | 0.009538 |
| yield_6m | 24 | 0.002556 | 0.003556 | 0.002350 |
| yield_6m | 36 | -0.000894 | -0.000251 | -0.003784 |
| cambio_usd | 0 | 0.080508 | 0.073851 | 0.080417 |
| cambio_usd | 1 | 0.118705 | 0.102235 | 0.124320 |
| cambio_usd | 4 | 0.073476 | 0.059271 | 0.092046 |
| cambio_usd | 12 | -0.004851 | -0.013970 | -0.006476 |
| cambio_usd | 24 | -0.040213 | -0.051751 | -0.063294 |
| cambio_usd | 36 | -0.025734 | -0.036333 | -0.025202 |
| cds_5y | 0 | 18.858497 | 15.079591 | 18.071576 |
| cds_5y | 1 | 21.965561 | 17.794677 | 18.672146 |
| cds_5y | 4 | 17.442663 | 14.488883 | 17.917093 |
| cds_5y | 12 | 9.792235 | 8.867393 | 13.571716 |
| cds_5y | 24 | 2.155573 | 1.685706 | 1.196831 |
| cds_5y | 36 | -1.923789 | -2.362755 | -5.442792 |


As trajetórias completas estão em `var_lag_comparison_irf.csv` e na figura `var_lag_comparison_paths.pdf`.

## Limitação de inferência

No VAR(6), o vetor de momentos HAC tem dimensão 190 para T=147. Como a dimensão é maior ou igual a T, `WHat` é singular e os conjuntos Anderson--Rubin/MOSW são indisponíveis. O script não tenta pseudoinversa, bootstrap substituto ou qualquer fallback. A inferência AR canônica do VAR(2) permanece em `output/var/svar_iv_weak_robust.csv`.

## Conclusões

**Ajuste.** Na amostra comum, o VAR(6) reduz o log-determinante de -11.7549 para -12.9809, mas paga pela expansão de 60 para 160 parâmetros. AIC e BIC permanecem critérios descritivos desta comparação; a seleção canônica em `p=1,...,12` continua escolhendo `p=2` pelo AIC.

**Estabilidade.** As maiores raízes são 0.963438 no VAR(2) comum e 0.970104 no VAR(6). O status de estabilidade é reportado como resultado, sem ter sido imposto pelo script.

**Dinâmica.** Na amostra comum, as correlações VAR(2)--VAR(6) são 0.995 para o yield de 6 meses, 0.992 para o câmbio e 0.960 para o CDS. A sensibilidade de forma é maior no IPCA (correlação 0.873) e sobretudo no IBC-Br (0.350). Essas diferenças são pontuais: sem inferência comparável para o VAR(6), nenhuma é descrita como estatisticamente significativa.

O exercício não promove o VAR(6), não muda a escolha AIC do VAR(2), não altera `production_spec()`, `script/model_var.R` ou seus artefatos e não muda a inferência do DFM.
