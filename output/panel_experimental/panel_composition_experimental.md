# Rodada experimental: composição do painel e dependência da curva

> Gerado por `script/panel_composition_experimental.R` em 2026-08-13. Todos os artefatos desta rodada vivem em `output/panel_experimental/`; o painel canônico, a identificação e os outputs de produção não foram modificados.

## Desenho fixado

Nove variantes, duas amostras, `(r,q,p)=(7,6,6)`, `z_jk_bs_purif`, `yield_6m`, +50 bp, horizonte 0--48, 800 wild bootstraps com seed 123 e bandas de 68%/90%.
A retirada de `juros_cdi` e `asset_mlcx` é apenas diagnóstico de ponderação; não implica exclusão automática.

## Força e classificação MOSW

| variant | sample | n_series | n_months | n_obs_align | r | q | p | xi_mp | f_robust_mp | impact_mp_pre | mosw_class |
|---|---|---|---|---|---|---|---|---|---|---|---|
| baseline | full |   106 |   153 |   147 |     7 |     6 |     6 | 7.648 | 7.955 | 5.33e-05 | xi_mp_3.84_10 |
| baseline | pre_covid |   106 |    84 |    78 |     7 |     6 |     6 | 11.53 | 6.264 | 5.056e-05 | xi_mp_ge_10 |
| drop_near_duplicates | full |   104 |   153 |   147 |     7 |     6 |     6 | 7.942 | 8.017 | 5.598e-05 | xi_mp_3.84_10 |
| drop_near_duplicates | pre_covid |   104 |    84 |    78 |     7 |     6 |     6 |  9.69 | 5.806 | 4.822e-05 | xi_mp_3.84_10 |
| add_fiscal | full |   109 |   153 |   147 |     7 |     6 |     6 | 6.389 | 6.403 | 5.013e-05 | xi_mp_3.84_10 |
| add_fiscal | pre_covid |   109 |    84 |    78 |     7 |     6 |     6 | 13.73 | 7.497 | 5.406e-05 | xi_mp_ge_10 |
| add_setor_externo | full |   110 |   153 |   147 |     7 |     6 |     6 | 7.375 | 7.552 | 5.617e-05 | xi_mp_3.84_10 |
| add_setor_externo | pre_covid |   110 |    84 |    78 |     7 |     6 |     6 | 11.85 | 6.627 | 5.376e-05 | xi_mp_ge_10 |
| add_expectativas | full |   110 |   153 |   147 |     7 |     6 |     6 | 8.357 | 9.301 | 6.783e-05 | xi_mp_3.84_10 |
| add_expectativas | pre_covid |   110 |    84 |    78 |     7 |     6 |     6 | 16.28 | 9.099 | 6.678e-05 | xi_mp_ge_10 |
| add_eua | full |   111 |   153 |   147 |     7 |     6 |     6 | 5.963 | 5.915 | 4.755e-05 | xi_mp_3.84_10 |
| add_eua | pre_covid |   111 |    84 |    78 |     7 |     6 |     6 | 15.34 | 7.417 | 4.834e-05 | xi_mp_ge_10 |
| add_credito | full |   108 |   153 |   147 |     7 |     6 |     6 | 7.619 | 8.147 | 5.726e-05 | xi_mp_3.84_10 |
| add_credito | pre_covid |   108 |    84 |    78 |     7 |     6 |     6 | 7.205 | 3.406 | 3.553e-05 | xi_mp_3.84_10 |
| add_imoveis | full |   107 |   153 |   147 |     7 |     6 |     6 | 7.373 | 7.601 | 5.364e-05 | xi_mp_3.84_10 |
| add_imoveis | pre_covid |   107 |    84 |    78 |     7 |     6 |     6 | 12.32 | 6.873 | 4.896e-05 | xi_mp_ge_10 |
| add_conjunto | full |   125 |   153 |   147 |     7 |     6 |     6 | 4.671 | 4.661 | 5.394e-05 | xi_mp_3.84_10 |
| add_conjunto | pre_covid |   125 |    84 |    78 |     7 |     6 |     6 | 16.14 | 9.576 | 4.466e-05 | xi_mp_ge_10 |

## Baseline de referência

| sample | xi_mp | f_robust_mp | mosw_class |
|---|---|---|---|
| full | 7.648 | 7.955 | xi_mp_3.84_10 |
| pre_covid | 11.53 | 6.264 | xi_mp_ge_10 |

## Leitura delimitada

A comparação é descritiva: a conclusão depende da estabilidade conjunta de força, direção das cinco IRFs e bandas, não do maior `xi_mp`.
As séries fiscais são vintage corrente: não constituem um teste estrito de informação fiscal disponível em tempo real.
Mudanças entre variantes são mudanças de especificação/reponderação do painel; não são tratadas como mudanças no instrumento, na identificação ou no painel de produção.

## Arquivos

- `variant_manifest.csv`: variantes, inclusões, exclusões e cobertura.
- `candidate_treatments.csv`: fontes, transformações e ajuste sazonal por candidata.
- `block_composition.csv` e `block_squared_loadings.csv`: dimensão efetiva, sobrepeso, cargas, participação no choque e comunalidade.
- `strength_and_classification.csv`, `irfs_required_long.csv`, `cell_<variant>_<sample>.rds` e `irf_overlay_*.pdf`: resultados completos por célula.
