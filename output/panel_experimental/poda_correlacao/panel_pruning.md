# Poda do painel por correlação par a par

Gerado por `script/panel_pruning.R` em 2026-09-10.
**Corpo gerado — não escrever prosa aqui.** A leitura vive em `notas/2026-09-10_poda_correlacao_painel.md`.

## Objeto e regra

Painel de produção `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03-01 a 2025-12-01, 115 séries. Objeto: correlação das primeiras diferenças (T = 165), a mesma de `estimate_static_factors()$yy`, a matriz da qual a PCA de produção tira as cargas. A coluna pré-COVID usa 2012-03-01 a 2019-12-01.

Regra fixada antes de qualquer seleção de fatores no painel podado: ligação completa sobre `1 − |ρ|` no painel inteiro, corte em `1 − 0,90`, de modo que todo par dentro de um grupo tem |ρ| ≥ 0,90. Cada grupo mantém uma série: `yield_6m` se estiver no grupo; senão a primeira de `yield_2y, yield_5y, asset_ibov, cambio_usd, price_ipca`; senão a de maior |ρ| média contra o resto do seu bloco. `igual_dentro_do_bloco` compara com a mesma regra restrita a cada bloco, a versão literal do e-mail.

## Auto-testes

| teste | valor | criterio |
|---|---|---|
| (a) séries do painel de produção classificadas em blocos |  115 | = 115, nenhuma sem bloco |
| (b) cor(yy) de estimate_static_factors() contra cor(diff(X)), desvio máximo | 2.22e-16 | < 1e-12 |
| (c) folga mínima de |rho| sobre o limiar nos grupos de ligação completa | 0.00528 | >= 0 |
| (d) configurações em que yield_6m é descartada |    0 | = 0 |

## Configurações

A primeira linha é a principal; as demais são sensibilidade e não decidem nada.

| config | linkage | threshold | principal | grupos | grupos_entre_blocos | n_descartadas | n_series | igual_dentro_do_bloco | descartadas |
|---|---|---|---|---|---|---|---|---|---|
| completa_0.90 | complete |   0.9 | TRUE |     8 |     0 |     9 |   106 | TRUE | cambio_cny, cambio_inr, yield_3m, yield_1y, yield_10y, ind_bens_duraveis, ind_bens_nao_duraveis, asset_idiv, price_inpc |
| completa_0.80 | complete |   0.8 | FALSE |    13 |     0 |    18 |    97 | TRUE | cambio_eur, cambio_cny, cambio_inr, yield_3m, yield_1y, yield_10y, base_demand_deposit, ind_bens_duraveis, ind_bens_nao_duraveis, trab_employment_south, trab_employment_central_west, trab_pop_forca_trab, asset_idiv, asset_ifnc, asset_imob, embi_perc, price_ipc, price_inpc |
| completa_0.85 | complete |  0.85 | FALSE |    13 |     0 |    16 |    99 | TRUE | cambio_eur, cambio_cny, cambio_inr, yield_3m, yield_1y, yield_10y, base_demand_deposit, ind_bens_duraveis, ind_bens_nao_duraveis, trab_employment_south, trab_pop_forca_trab, asset_idiv, asset_ifnc, asset_imob, embi_perc, price_inpc |
| completa_0.95 | complete |  0.95 | FALSE |     1 |     0 |     1 |   114 | TRUE | yield_10y |
| simples_0.90 | single |   0.9 | FALSE |     6 |     0 |    12 |   103 | TRUE | cambio_cny, cambio_inr, yield_3m, yield_1y, yield_2y, yield_10y, ind_bens_consumo, ind_bens_duraveis, ind_bens_nao_duraveis, asset_idiv, asset_ifnc, price_inpc |

## Grupos na configuração principal (ligação completa, 0,90)

| group | blocos | mantida | motivo | descartadas | min_abs_rho | min_abs_rho_pre_covid |
|---|---|---|---|---|---|---|
|    1 | cambio | cambio_usd | prioridade | cambio_cny, cambio_inr | 0.916 | 0.896 |
|    2 | curva | yield_6m | prioridade | yield_3m | 0.921 |  0.9 |
|    3 | curva | yield_2y | prioridade | yield_1y | 0.925 | 0.926 |
|    4 | curva | yield_5y | prioridade | yield_10y | 0.958 | 0.955 |
|    5 | industria | ind_bens_consumo | medoide | ind_bens_nao_duraveis | 0.947 | 0.954 |
|    6 | industria | ind_transformacao | medoide | ind_bens_duraveis | 0.907 | 0.875 |
|    7 | acoes | asset_ibov | prioridade | asset_idiv | 0.938 | 0.935 |
|    8 | precos | price_ipca | prioridade | price_inpc | 0.945 | 0.907 |

## Grupos nas configurações de sensibilidade

| config | group | blocos | mantida | descartadas | min_abs_rho | min_abs_rho_pre_covid |
|---|---|---|---|---|---|---|
| completa_0.80 |    1 | cambio | cambio_usd | cambio_eur, cambio_cny, cambio_inr | 0.855 | 0.824 |
| completa_0.80 |    2 | curva | yield_6m | yield_3m | 0.921 |  0.9 |
| completa_0.80 |    3 | curva | yield_2y | yield_1y | 0.925 | 0.926 |
| completa_0.80 |    4 | curva | yield_5y | yield_10y | 0.958 | 0.955 |
| completa_0.80 |    5 | monetario | base_m1 | base_demand_deposit | 0.859 | 0.857 |
| completa_0.80 |    6 | industria | ind_bens_consumo | ind_bens_nao_duraveis | 0.947 | 0.954 |
| completa_0.80 |    7 | industria | ind_transformacao | ind_bens_duraveis | 0.907 | 0.875 |
| completa_0.80 |    8 | trabalho | trab_employment_southest | trab_employment_south, trab_employment_central_west | 0.824 | 0.604 |
| completa_0.80 |    9 | trabalho | trab_pop_ocupada | trab_pop_forca_trab | 0.894 | 0.421 |
| completa_0.80 |   10 | acoes | asset_ibov | asset_idiv, asset_ifnc | 0.866 | 0.852 |
| completa_0.80 |   11 | acoes | asset_smll | asset_imob | 0.879 | 0.848 |
| completa_0.80 |   12 | risco_externo | cds_5y | embi_perc | 0.884 | 0.903 |
| completa_0.80 |   13 | precos | price_ipca | price_ipc, price_inpc | 0.818 | 0.808 |
| completa_0.85 |    1 | cambio | cambio_usd | cambio_eur, cambio_cny, cambio_inr | 0.855 | 0.824 |
| completa_0.85 |    2 | curva | yield_6m | yield_3m | 0.921 |  0.9 |
| completa_0.85 |    3 | curva | yield_2y | yield_1y | 0.925 | 0.926 |
| completa_0.85 |    4 | curva | yield_5y | yield_10y | 0.958 | 0.955 |
| completa_0.85 |    5 | monetario | base_m1 | base_demand_deposit | 0.859 | 0.857 |
| completa_0.85 |    6 | industria | ind_bens_consumo | ind_bens_nao_duraveis | 0.947 | 0.954 |
| completa_0.85 |    7 | industria | ind_transformacao | ind_bens_duraveis | 0.907 | 0.875 |
| completa_0.85 |    8 | trabalho | trab_employment_southest | trab_employment_south | 0.897 | 0.664 |
| completa_0.85 |    9 | trabalho | trab_pop_ocupada | trab_pop_forca_trab | 0.894 | 0.421 |
| completa_0.85 |   10 | acoes | asset_ibov | asset_idiv, asset_ifnc | 0.866 | 0.852 |
| completa_0.85 |   11 | acoes | asset_smll | asset_imob | 0.879 | 0.848 |
| completa_0.85 |   12 | risco_externo | cds_5y | embi_perc | 0.884 | 0.903 |
| completa_0.85 |   13 | precos | price_ipca | price_inpc | 0.945 | 0.907 |
| completa_0.95 |    1 | curva | yield_5y | yield_10y | 0.958 | 0.955 |
| simples_0.90 |    1 | cambio | cambio_usd | cambio_cny, cambio_inr | 0.916 | 0.896 |
| simples_0.90 |    2 | curva | yield_6m | yield_3m, yield_1y, yield_2y | 0.561 | 0.543 |
| simples_0.90 |    3 | curva | yield_5y | yield_10y | 0.958 | 0.955 |
| simples_0.90 |    4 | industria | ind_transformacao | ind_bens_consumo, ind_bens_duraveis, ind_bens_nao_duraveis | 0.739 | 0.775 |
| simples_0.90 |    5 | acoes | asset_ibov | asset_idiv, asset_ifnc | 0.866 | 0.852 |
| simples_0.90 |    6 | precos | price_ipca | price_inpc | 0.945 | 0.907 |

## Pares com |ρ| > 0.80 no painel inteiro: 32 pares, 0 entre blocos

| serie_a | serie_b | bloco_a | bloco_b | rho | rho_pre_covid | mesmo_bloco |
|---|---|---|---|---|---|---|
| yield_5y | yield_10y | curva | curva | 0.958 | 0.955 | TRUE |
| ind_bens_consumo | ind_bens_nao_duraveis | industria | industria | 0.947 | 0.954 | TRUE |
| cambio_cny | cambio_usd | cambio | cambio | 0.947 | 0.955 | TRUE |
| price_ipca | price_inpc | precos | precos | 0.945 | 0.907 | TRUE |
| ind_bens_consumo | ind_transformacao | industria | industria | 0.942 | 0.953 | TRUE |
| asset_ibov | asset_idiv | acoes | acoes | 0.938 | 0.935 | TRUE |
| cambio_inr | cambio_usd | cambio | cambio | 0.938 | 0.909 | TRUE |
| yield_1y | yield_2y | curva | curva | 0.925 | 0.926 | TRUE |
| yield_6m | yield_1y | curva | curva | 0.925 | 0.912 | TRUE |
| yield_3m | yield_6m | curva | curva | 0.921 |  0.9 | TRUE |
| cambio_cny | cambio_inr | cambio | cambio | 0.916 | 0.896 | TRUE |
| asset_ibov | asset_ifnc | acoes | acoes | 0.913 | 0.912 | TRUE |
| ind_bens_duraveis | ind_transformacao | industria | industria | 0.907 | 0.875 | TRUE |
| trab_employment_southest | trab_employment_south | trabalho | trabalho | 0.897 | 0.664 | TRUE |
| cambio_eur | cambio_cny | cambio | cambio | 0.897 | 0.894 | TRUE |
| ind_bens_consumo | ind_bens_duraveis | industria | industria | 0.896 | 0.904 | TRUE |
| trab_pop_forca_trab | trab_pop_ocupada | trabalho | trabalho | 0.894 | 0.421 | TRUE |
| asset_ibov | asset_smll | acoes | acoes | 0.891 | 0.863 | TRUE |
| yield_2y | yield_5y | curva | curva | 0.888 | 0.89 | TRUE |
| embi_perc | cds_5y | risco_externo | risco_externo | 0.884 | 0.903 | TRUE |
| cambio_eur | cambio_usd | cambio | cambio | 0.88 | 0.899 | TRUE |
| asset_imob | asset_smll | acoes | acoes | 0.879 | 0.848 | TRUE |
| asset_idiv | asset_ifnc | acoes | acoes | 0.866 | 0.852 | TRUE |
| ind_bens_nao_duraveis | ind_transformacao | industria | industria | 0.865 | 0.92 | TRUE |
| base_demand_deposit | base_m1 | monetario | monetario | 0.859 | 0.857 | TRUE |
| trab_employment_southest | trab_employment_central_west | trabalho | trabalho | 0.858 | 0.604 | TRUE |
| cambio_eur | cambio_inr | cambio | cambio | 0.855 | 0.824 | TRUE |
| asset_idiv | asset_smll | acoes | acoes | 0.825 | 0.829 | TRUE |
| trab_employment_south | trab_employment_central_west | trabalho | trabalho | 0.824 | 0.678 | TRUE |
| price_ipca | price_ipc | precos | precos | 0.818 | 0.808 | TRUE |
| price_ipc | price_inpc | precos | precos | 0.818 | 0.843 | TRUE |
| asset_ifnc | asset_smll | acoes | acoes | 0.808 | 0.748 | TRUE |

Figura em `panel_pruning.pdf`.
