# Seleção de q em r = 5: as três células lado a lado

Gerado por `script/q_selection.R` em 2026-08-17.
**Corpo gerado — não escrever prosa aqui.** A leitura vive na nota datada.

Amostra completa (2013-01-01 a 2025-09-01), `z_jk_bs_purif` × `yield_6m`, choque +50 pb, wild bootstrap nboot = 800, seed 123, bandas 68/90.

## O que o critério de Amengual-Watson seleciona

- Versão **BLL** (diferenças padronizadas), que é a admissível num painel não-estacionário: **q = 2**.
- Versão em **níveis**, que é o comparável de fidelidade ao MATLAB original: **q = 5**. Ver `output/validation/amengual_watson_validation.md`.
- Produção corrente: **q = 5**.

## Força e estabilidade por célula

| q | xi_mp | f_robust_mp | ar_bounded | bands_valid | impacto_mp_pre | max_companion_root |
|---|---|---|---|---|---|---|
|     5 | 6.271 | 10.12 | TRUE | FALSE | 8.426e-05 | 0.9649 |
|     3 | 3.149 |  3.66 | FALSE | FALSE | 2.471e-05 | 0.9649 |
|     2 | 3.809 | 4.824 | FALSE | FALSE | 2.69e-05 | 0.9649 |

Réguas: `ar_bounded` é ξ_mp > 3,84, abaixo do qual o conjunto de Anderson-Rubin a 95% é ilimitado; `bands_valid` é ξ_mp ≥ 10, a referência convencional para bandas.

`impacto_mp_pre` é o impacto de `yield_6m` **antes** da normalização, o denominador pelo qual toda IRF da célula é dividida. É por isso que uma célula mais fraca imprime respostas **maiores**, e por isso ele aparece ao lado de ξ_mp em vez de ser inferido dele.

## Impacto (h = 0) nas cinco variáveis obrigatórias

| variable | q=5 | q=3 | q=2 |
|---|---|---|---|
| yield_6m |     0.005 |     0.005 |     0.005 |
| yield_2y | 0.0074300592 | 0.014972104 | 0.014146462 |
| yield_5y | 0.0077611464 | 0.020505246 | 0.019086023 |
| asset_ibov | -1.7226767 | -22.425902 | -21.771082 |
| cambio_usd | 0.15792807 | 0.50029182 | 0.37155046 |

### Exclui zero a 90% no impacto

| variable | q=5 | q=3 | q=2 |
|---|---|---|---|
| yield_6m | sim | sim | sim |
| yield_2y | sim | sim | sim |
| yield_5y | sim | sim | sim |
| asset_ibov | nao | sim | sim |
| cambio_usd | sim | sim | sim |

