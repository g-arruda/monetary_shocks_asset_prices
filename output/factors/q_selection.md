# Seleção de q em r = 5: a checagem da Figura A3 de Alessi-Kerssenfischer

Gerado por `script/q_selection.R` em 2026-08-25.
**Corpo gerado — não escrever prosa aqui.** A leitura vive na nota datada.

Amostra completa (2013-01-01 a 2025-09-01), `z_jk_bs_purif` × `yield_6m`, choque +50 pb, wild bootstrap nboot = 800, seed 123, bandas 68/90, h = 0..48.

## O desenho que está sendo replicado

A nota 4 de Alessi-Kerssenfischer justifica `q = r` por evidência, não por conveniência: *"Given our external instrument identification scheme, results are virtually identical whether or not q < r; thus we assume q = r for simplicity."* A Figura A3 do apêndice é o que sustenta isso — o benchmark `(p=6, r=8, q=8)` carrega ponto **e** bandas, e `q = 5, 6, 7` entram sobrepostos como linhas de **ponto apenas**. Esta rodada constrói a mesma figura para `r = 5`.

**Critério de leitura, pré-registrado antes de olhar as trajetórias:** *imaterial* é `share_in90 = 1` **e** `cor_path > 0,95`; *material* é `share_in90 < 1` fora de h = 0 ou inversão de sinal no impacto; o resto é *parcial*.

## O que o critério de Amengual-Watson seleciona

- Versão **BLL** (diferenças padronizadas), que é a admissível num painel não-estacionário: **q = 2**.
- Versão em **níveis**, que é o comparável de fidelidade ao MATLAB original: **q = 5**. Ver `output/validation/amengual_watson_validation.md`.
- Produção corrente: **q = 5**.

## Força e estabilidade por célula

| q | xi_mp | f_robust_mp | ar_bounded | bands_valid | impacto_mp_pre | max_companion_root | denom_ratio |
|---|---|---|---|---|---|---|---|
|     5 |  5.24 | 10.06 | TRUE | FALSE | 0.0001013 | 0.9681 |     1 |
|     4 | 4.357 | 7.298 | TRUE | FALSE | 6.977e-05 | 0.9681 | 0.6886 |
|     3 | 2.843 | 3.868 | FALSE | FALSE | 3.071e-05 | 0.9681 | 0.3031 |
|     2 | 3.586 | 5.356 | FALSE | FALSE | 3.317e-05 | 0.9681 | 0.3274 |

Réguas: `ar_bounded` é ξ_mp > 3,84, abaixo do qual o conjunto de Anderson-Rubin a 95% é ilimitado; `bands_valid` é ξ_mp ≥ 10, a referência convencional para bandas.

`impacto_mp_pre` é o impacto de `yield_6m` **antes** da normalização, o denominador pelo qual toda IRF da célula é dividida. É por isso que uma célula mais fraca imprime respostas **maiores**, e por isso ele aparece ao lado de ξ_mp em vez de ser inferido dele. `denom_ratio` é esse denominador relativo ao da produção: é o fator de escala que separa uma IRF maior de um resultado maior.

## A checagem da Figura A3, em número

`share_in68`/`share_in90` são a fração dos horizontes h = 0..36 em que o ponto da célula alternativa cai **dentro** da banda da produção — é o que o olho lê na figura. `cor_path` mede **forma** e é imune à escala; `rel_max_abs_dev` é o desvio máximo em unidades do maior ponto da produção. `first_out90_h` é o primeiro horizonte em que a alternativa sai da banda de 90%.

| q | variable | share_in68 | share_in90 | share_in90_h12 | first_out90_h | cor_path | max_abs_dev | max_abs_dev_h | rel_max_abs_dev | sign_flip_h0 | veredito |
|---|---|---|---|---|---|---|---|---|---|---|---|
|     4 | yield_6m | 0.4324 |     1 |     1 |    NA | 0.7042 | 0.01041 |    24 | 1.148 | FALSE | parcial |
|     4 | yield_2y | 0.1351 | 0.973 | 0.9231 |     0 | 0.8564 | 0.01176 |    21 | 1.082 | FALSE | material |
|     4 | yield_5y | 0.08108 | 0.973 | 0.9231 |     1 | 0.9006 | 0.009782 |    20 | 0.9914 | FALSE | material |
|     4 | cambio_usd | 0.4595 | 0.7838 | 0.3846 |     0 | 0.8977 | 0.1479 |    11 | 0.907 | FALSE | material |
|     4 | cds_5y | 0.2973 |     1 |     1 |    NA | 0.9459 |  23.1 |    17 | 0.7256 | FALSE | parcial |
|     4 | asset_ibov | 0.973 |     1 |     1 |    NA | 0.7255 | 3.523 |    26 | 1.833 | FALSE | parcial |
|     3 | yield_6m | 0.6216 | 0.8108 | 0.4615 |     1 | 0.4051 | 0.008734 |    23 | 0.9633 | FALSE | material |
|     3 | yield_2y | 0.6486 | 0.9189 | 0.7692 |     0 | 0.8175 | 0.01087 |    20 | 0.9999 | FALSE | material |
|     3 | yield_5y | 0.4054 | 0.8649 | 0.6154 |     0 | 0.884 | 0.01295 |     1 | 1.312 | FALSE | material |
|     3 | cambio_usd | 0.1892 | 0.4324 |     0 |     0 | 0.8611 | 0.5243 |     2 | 3.215 | FALSE | material |
|     3 | cds_5y | 0.2432 | 0.4324 |     0 |     0 | 0.9298 | 83.57 |     1 | 2.625 | FALSE | material |
|     3 | asset_ibov | 0.9189 | 0.9459 | 0.8462 |     0 | 0.3934 | 19.52 |     0 | 10.16 | FALSE | material |
|     2 | yield_6m | 0.5405 | 0.8649 | 0.6154 |     1 | 0.4534 | 0.009254 |    23 | 1.021 | FALSE | material |
|     2 | yield_2y | 0.5676 | 0.8919 | 0.6923 |     0 | 0.8305 | 0.01126 |    21 | 1.036 | FALSE | material |
|     2 | yield_5y | 0.4054 | 0.8649 | 0.6154 |     0 | 0.8905 | 0.01164 |     1 |  1.18 | FALSE | material |
|     2 | cambio_usd | 0.2432 | 0.4324 |     0 |     0 | 0.8572 | 0.4534 |     2 |  2.78 | FALSE | material |
|     2 | cds_5y | 0.2703 | 0.4595 |     0 |     0 | 0.9316 | 73.28 |     1 | 2.302 | FALSE | material |
|     2 | asset_ibov | 0.9189 | 0.9459 | 0.8462 |     0 | 0.3991 | 18.72 |     0 | 9.742 | FALSE | material |

Contagem: **0 de 18** pares (variável × q) saem *imateriais* e **15** saem *materiais*.

## Decomposição do gap: denominador ou coluna estimada?

⚠ **Achado pós-hoc, encontrado depois de olhar as trajetórias, e deliberadamente fora da regra de veredito acima** — nenhuma destas colunas entra no `case_when` que classifica os pares, justamente para que olhar para elas não possa virar um veredito fixado antes.

`ratio_h0` é o impacto da alternativa dividido pelo da produção. `resto_coluna_h0` é esse mesmo quociente **multiplicado por** `denom_ratio`, isto é, o que sobra do gap depois de remover o denominador de normalização: **1 significa que a coluna estimada não mudou e todo o gap era escala**. `share_in90_resc` repete a contenção com a trajetória inteira reescalada pelo denominador da produção.

⚠ Na linha de `yield_6m` o `resto_coluna_h0` é **tautologicamente** igual a `denom_ratio`: o impacto bruto da variável de política *é* o denominador, então `ratio_h0` vale 1 por construção em toda célula. Essa linha não é achado, é a identidade que fixa a normalização.

| q | variable | denom_ratio | ratio_h0 | resto_coluna_h0 | share_in90 | share_in90_resc |
|---|---|---|---|---|---|---|
|     4 | yield_6m | 0.6886 |     1 | 0.6886 |     1 | 0.8919 |
|     4 | yield_2y | 0.6886 | 1.218 | 0.839 | 0.973 |     1 |
|     4 | yield_5y | 0.6886 | 1.303 | 0.8971 | 0.973 |     1 |
|     4 | cambio_usd | 0.6886 | 1.689 | 1.163 | 0.7838 |     1 |
|     4 | cds_5y | 0.6886 | 1.415 | 0.9742 |     1 |     1 |
|     4 | asset_ibov | 0.6886 | 1.406 | 0.9682 |     1 |     1 |
|     3 | yield_6m | 0.3031 |     1 | 0.3031 | 0.8108 | 0.6486 |
|     3 | yield_2y | 0.3031 | 1.968 | 0.5967 | 0.9189 | 0.7027 |
|     3 | yield_5y | 0.3031 | 2.587 | 0.7841 | 0.8649 | 0.8378 |
|     3 | cambio_usd | 0.3031 | 3.003 | 0.9103 | 0.4324 |     1 |
|     3 | cds_5y | 0.3031 | 3.417 | 1.036 | 0.4324 |     1 |
|     3 | asset_ibov | 0.3031 | 21.17 | 6.417 | 0.9459 | 0.973 |
|     2 | yield_6m | 0.3274 |     1 | 0.3274 | 0.8649 | 0.6486 |
|     2 | yield_2y | 0.3274 | 1.881 | 0.616 | 0.8919 | 0.7297 |
|     2 | yield_5y | 0.3274 |  2.44 | 0.799 | 0.8649 | 0.8649 |
|     2 | cambio_usd | 0.3274 | 2.454 | 0.8035 | 0.4324 |     1 |
|     2 | cds_5y | 0.3274 | 3.111 | 1.019 | 0.4595 |     1 |
|     2 | asset_ibov | 0.3274 | 20.34 |  6.66 | 0.9459 | 0.973 |

## Impacto (h = 0) no bloco de 6 variáveis

As cinco obrigatórias mais `cds_5y`. `asset_ibov` fica na tabela ainda que tenha saído da figura-manchete: é onde as células mais discordam.

| variable | q=5 | q=4 | q=3 | q=2 |
|---|---|---|---|---|
| yield_6m |     0.005 |     0.005 |     0.005 |     0.005 |
| yield_2y | 0.0072818769 | 0.0088719521 | 0.014333939 | 0.013700159 |
| yield_5y | 0.0074830927 | 0.0097489156 | 0.019357594 | 0.018261555 |
| cambio_usd | 0.15385505 | 0.25989345 | 0.46205542 | 0.37755745 |
| cds_5y | 30.704019 |  43.43917 | 104.92741 | 95.525403 |
| asset_ibov | -0.96798489 | -1.3609298 | -20.491577 | -19.688267 |

### Exclui zero a 90% no impacto

| variable | q=5 | q=4 | q=3 | q=2 |
|---|---|---|---|---|
| yield_6m | sim | sim | sim | sim |
| yield_2y | sim | sim | sim | sim |
| yield_5y | sim | sim | sim | sim |
| cambio_usd | sim | sim | sim | sim |
| cds_5y | sim | sim | sim | sim |
| asset_ibov | nao | nao | sim | sim |

Trajetórias completas em `q_selection_paths.csv`; figura em
`q_selection_paths.pdf`.

