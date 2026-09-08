# Seleção de q em r = 4: a checagem da Figura A3 de Alessi-Kerssenfischer

Gerado por `script/q_selection.R` em 2026-09-01.
**Corpo gerado — não escrever prosa aqui.** A leitura vive na nota datada.

Amostra completa (2013-01-01 a 2025-09-01), `z_jk_bs_purif` × `yield_6m`, choque +50 pb, wild bootstrap nboot = 800, seed 123, bandas 68/90, h = 0..48.

## O desenho que está sendo replicado

A nota 4 de Alessi-Kerssenfischer justifica `q = r` por evidência, não por conveniência: *"Given our external instrument identification scheme, results are virtually identical whether or not q < r; thus we assume q = r for simplicity."* A Figura A3 do apêndice é o que sustenta isso — o benchmark `(p=6, r=8, q=8)` carrega ponto **e** bandas, e `q = 5, 6, 7` entram sobrepostos como linhas de **ponto apenas**. Esta rodada constrói a mesma figura para `r = 4`.

**Critério de leitura, pré-registrado antes de olhar as trajetórias:** *imaterial* é `share_in90 = 1` **e** `cor_path > 0,95`; *material* é `share_in90 < 1` fora de h = 0 ou inversão de sinal no impacto; o resto é *parcial*.

## O que o critério de Amengual-Watson seleciona

- Versão **BLL** (diferenças padronizadas), que é a admissível num painel não-estacionário: **q = 2**.
- Versão em **níveis**, que é o comparável de fidelidade ao MATLAB original: **q = 4**. Ver `output/validation/amengual_watson_validation.md`.
- Produção corrente: **q = 4**.

## Força e estabilidade por célula

| q | xi_mp | f_robust_mp | ar_bounded | bands_valid | impacto_mp_pre | max_companion_root | denom_ratio |
|---|---|---|---|---|---|---|---|
|     4 | 6.384 | 14.16 | TRUE | FALSE | 0.0001141 | 0.9721 |     1 |
|     3 | 5.553 | 11.16 | TRUE | FALSE | 9.289e-05 | 0.9721 | 0.8141 |
|     2 | 4.132 | 6.698 | TRUE | FALSE | 4.199e-05 | 0.9721 | 0.368 |
|     1 | 4.762 | 7.249 | TRUE | FALSE | 2.784e-05 | 0.9721 | 0.244 |

Réguas: `ar_bounded` é ξ_mp > 3,84, abaixo do qual o conjunto de Anderson-Rubin a 95% é ilimitado; `bands_valid` é ξ_mp ≥ 10, a referência convencional para bandas.

`impacto_mp_pre` é o impacto de `yield_6m` **antes** da normalização, o denominador pelo qual toda IRF da célula é dividida. É por isso que uma célula mais fraca imprime respostas **maiores**, e por isso ele aparece ao lado de ξ_mp em vez de ser inferido dele. `denom_ratio` é esse denominador relativo ao da produção: é o fator de escala que separa uma IRF maior de um resultado maior.

## A checagem da Figura A3, em número

`share_in68`/`share_in90` são a fração dos horizontes h = 0..36 em que o ponto da célula alternativa cai **dentro** da banda da produção — é o que o olho lê na figura. `cor_path` mede **forma** e é imune à escala; `rel_max_abs_dev` é o desvio máximo em unidades do maior ponto da produção. `first_out90_h` é o primeiro horizonte em que a alternativa sai da banda de 90%.

| q | variable | share_in68 | share_in90 | share_in90_h12 | first_out90_h | cor_path | max_abs_dev | max_abs_dev_h | rel_max_abs_dev | sign_flip_h0 | veredito |
|---|---|---|---|---|---|---|---|---|---|---|---|
|     3 | yield_6m | 0.4054 |     1 |     1 |    NA | 0.8037 | 0.006039 |    24 | 0.8185 | FALSE | parcial |
|     3 | yield_2y | 0.2973 |     1 |     1 |    NA | 0.9007 | 0.007201 |    21 | 0.7819 | FALSE | parcial |
|     3 | yield_5y | 0.3514 |     1 |     1 |    NA | 0.9233 | 0.006251 |    20 | 0.7488 | FALSE | parcial |
|     3 | cambio_usd | 0.3243 |     1 |     1 |    NA | 0.945 | 0.1266 |    14 | 0.8084 | FALSE | parcial |
|     3 | cds_5y | 0.5405 |     1 |     1 |    NA | 0.9449 | 18.78 |    17 | 0.6468 | FALSE | parcial |
|     3 | asset_ibov | 0.7027 |     1 |     1 |    NA | 0.739 | 1.436 |     2 | 0.8584 | FALSE | parcial |
|     2 | yield_6m | 0.3243 | 0.5676 | 0.9231 |     1 | 0.4403 | 0.009025 |    22 | 1.223 | FALSE | material |
|     2 | yield_2y | 0.1081 | 0.4595 | 0.6154 |     0 | 0.8366 | 0.01137 |    19 | 1.235 | FALSE | material |
|     2 | yield_5y | 0.1351 | 0.2973 |     0 |     0 | 0.9065 | 0.01053 |    17 | 1.261 | FALSE | material |
|     2 | cambio_usd | 0.2703 | 0.4324 |     0 |     0 | 0.9171 | 0.3337 |     3 | 2.131 | FALSE | material |
|     2 | cds_5y | 0.2162 | 0.3514 |     0 |     0 | 0.9513 | 51.55 |     1 | 1.776 | FALSE | material |
|     2 | asset_ibov | 0.4595 | 0.9459 | 0.8462 |     0 | 0.472 | 15.19 |     0 | 9.083 | FALSE | material |
|     1 | yield_6m | 0.2703 | 0.4595 | 0.6154 |     3 | 0.1571 | 0.01058 |    21 | 1.434 | FALSE | material |
|     1 | yield_2y | 0.2432 | 0.4595 | 0.5385 |     0 | 0.7553 | 0.01393 |    18 | 1.513 | FALSE | material |
|     1 | yield_5y | 0.1622 | 0.2703 |     0 |     0 | 0.8689 | 0.01385 |     1 | 1.659 | FALSE | material |
|     1 | cambio_usd | 0.1622 | 0.3243 |     0 |     0 | 0.9134 | 0.5379 |     3 | 3.436 | FALSE | material |
|     1 | cds_5y | 0.1892 | 0.3243 |     0 |     0 | 0.9395 | 88.95 |     1 | 3.064 | FALSE | material |
|     1 | asset_ibov | 0.3514 | 0.8108 | 0.7692 |     0 | 0.442 | 20.01 |     0 | 11.96 | FALSE | material |

Contagem: **0 de 18** pares (variável × q) saem *imateriais* e **12** saem *materiais*.

## Decomposição do gap: denominador ou coluna estimada?

⚠ **Achado pós-hoc, encontrado depois de olhar as trajetórias, e deliberadamente fora da regra de veredito acima** — nenhuma destas colunas entra no `case_when` que classifica os pares, justamente para que olhar para elas não possa virar um veredito fixado antes.

`ratio_h0` é o impacto da alternativa dividido pelo da produção. `resto_coluna_h0` é esse mesmo quociente **multiplicado por** `denom_ratio`, isto é, o que sobra do gap depois de remover o denominador de normalização: **1 significa que a coluna estimada não mudou e todo o gap era escala**. `share_in90_resc` repete a contenção com a trajetória inteira reescalada pelo denominador da produção.

⚠ Na linha de `yield_6m` o `resto_coluna_h0` é **tautologicamente** igual a `denom_ratio`: o impacto bruto da variável de política *é* o denominador, então `ratio_h0` vale 1 por construção em toda célula. Essa linha não é achado, é a identidade que fixa a normalização.

| q | variable | denom_ratio | ratio_h0 | resto_coluna_h0 | share_in90 | share_in90_resc |
|---|---|---|---|---|---|---|
|     3 | yield_6m | 0.8141 |     1 | 0.8141 |     1 | 0.9459 |
|     3 | yield_2y | 0.8141 | 1.122 | 0.9133 |     1 |     1 |
|     3 | yield_5y | 0.8141 | 1.156 | 0.941 |     1 |     1 |
|     3 | cambio_usd | 0.8141 |  1.41 | 1.148 |     1 |     1 |
|     3 | cds_5y | 0.8141 | 1.191 | 0.9693 |     1 |     1 |
|     3 | asset_ibov | 0.8141 | 0.687 | 0.5593 |     1 |     1 |
|     2 | yield_6m | 0.368 |     1 | 0.368 | 0.5676 | 0.7297 |
|     2 | yield_2y | 0.368 | 1.681 | 0.6185 | 0.4595 | 0.8378 |
|     2 | yield_5y | 0.368 | 2.133 | 0.7851 | 0.2973 |     1 |
|     2 | cambio_usd | 0.368 | 2.057 | 0.757 | 0.4324 |     1 |
|     2 | cds_5y | 0.368 | 2.655 | 0.9771 | 0.3514 |     1 |
|     2 | asset_ibov | 0.368 | 14.01 | 5.154 | 0.9459 | 0.973 |
|     1 | yield_6m | 0.244 |     1 | 0.244 | 0.4595 | 0.6757 |
|     1 | yield_2y | 0.244 | 2.023 | 0.4936 | 0.4595 | 0.7568 |
|     1 | yield_5y | 0.244 | 2.779 | 0.678 | 0.2703 | 0.8108 |
|     1 | cambio_usd | 0.244 | 2.911 | 0.7103 | 0.3243 |     1 |
|     1 | cds_5y | 0.244 | 3.827 | 0.9338 | 0.3243 |     1 |
|     1 | asset_ibov | 0.244 | 18.13 | 4.424 | 0.8108 | 0.973 |

## Impacto (h = 0) no bloco de 6 variáveis

As cinco obrigatórias mais `cds_5y`. `asset_ibov` fica na tabela ainda que tenha saído da figura-manchete: é onde as células mais discordam.

| variable | q=4 | q=3 | q=2 | q=1 |
|---|---|---|---|---|
| yield_6m |     0.005 |     0.005 |     0.005 |     0.005 |
| yield_2y | 0.0070840086 | 0.0079466305 | 0.01190557 | 0.014329468 |
| yield_5y | 0.0070606166 | 0.0081606985 | 0.015061977 | 0.019619931 |
| cambio_usd | 0.13548108 | 0.19096402 | 0.27870045 | 0.39441696 |
| cds_5y | 27.606099 | 32.868693 | 73.299943 | 105.65341 |
| asset_ibov | -1.1679944 | -0.80240197 | -16.359458 | -21.177677 |

### Exclui zero a 90% no impacto

| variable | q=4 | q=3 | q=2 | q=1 |
|---|---|---|---|---|
| yield_6m | sim | sim | sim | sim |
| yield_2y | sim | sim | sim | nao |
| yield_5y | sim | sim | sim | nao |
| cambio_usd | sim | sim | sim | nao |
| cds_5y | sim | sim | sim | nao |
| asset_ibov | nao | nao | sim | nao |

Trajetórias completas em `q_selection_paths.csv`; figura em
`q_selection_paths.pdf`.

