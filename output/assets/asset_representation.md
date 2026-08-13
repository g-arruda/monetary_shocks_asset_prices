# Ações em log-nível: a representação causa o resultado nulo?

*Gerado por `script/asset_representation.R` em 2026-08-13. **Corpo gerado: não escreva prosa aqui.** A leitura interpretativa vive em `notas/2026-07-31_acoes_representacao.md`.*

## A pergunta

As 8 séries da B3 entram no painel como **retorno mensal composto**, enquanto
as outras 98 entram em nível ou log-nível. O `cumsum` que recupera o nível é
aplicado à **IRF** (`impulse_responde.R:277`, tcode 2), não aos dados. Como o
BLL diferencia o painel para estimar `Λ` (`factor_estimation.R:300`), o bloco
acionário é estimado sobre a **segunda diferença** do log-preço. O paper
reporta **0 de 392** células sig90 nesse bloco — o tema do próprio título.

## Regra de leitura, fixada antes dos números

- **Mecânico** se, sob `loglevel`, houver ≥ 1 célula sig90 em h ≤ 12 **e**
  ξ_mp ≥ 3,84 (forma forte: ≥ 10).
- **Não confirmado** se o bloco seguir em 0 sig90 com as guardas de pé.
- **h = 0 é o teste limpo da representação**: único horizonte em que as duas
  medem o mesmo objeto e em que o `cumsum` é no-op.
- A inflação de banda é atribuída ao `cumsum` via `prod_nocum` — mesmo modelo,
  mesmo seed, só o transform muda. Afirmação **separada**.
- **Inconclusivo** se ξ_mp do painel log-nível cair abaixo de 3,84.

## Veredito: MECANICO CONFIRMADO — 37 celulas sig90 em h<=12 sob log-nivel

## As quatro representações

| variante | painel | tcode_asset | xi_mp | f_robust_mp | max_eig | n_sig90 | n_sig90_h12 | n_sig68 |
|---|---|---|---|---|---|---|---|---|
| prod | retorno mensal |     2 | 7.648 | 7.955 | 0.9747 |     2 |     2 |    24 |
| loglevel | log(cumprod(1+r)) |     4 | 7.948 | 10.07 | 0.9717 |    37 |    37 |    55 |
| level | cumprod(1+r) |     1 | 8.526 | 10.91 | 0.975 |    34 |    34 |    52 |
| prod_nocum | retorno mensal |     1 | 7.648 | 7.955 | 0.9747 |    NA |    NA |    NA |

Força do instrumento nas duas janelas:

| variante | amostra | n_obs | xi_mp | f_robust_mp | ar_bounded | bandas_convencionais |
|---|---|---|---|---|---|---|
| prod | full |   147 | 7.648 | 7.955 | TRUE | FALSE |
| prod | pre_covid |    78 | 11.53 | 6.264 | TRUE | TRUE |
| loglevel | full |   147 | 7.948 | 10.07 | TRUE | FALSE |
| loglevel | pre_covid |    78 | 4.474 | 1.822 | TRUE | FALSE |
| level | full |   147 | 8.526 | 10.91 | TRUE | FALSE |
| level | pre_covid |    78 |  6.44 | 3.836 | TRUE | FALSE |
| prod_nocum | full |   147 | 7.648 | 7.955 | TRUE | FALSE |
| prod_nocum | pre_covid |    78 | 11.53 | 6.264 | TRUE | TRUE |

## h = 0 — o teste limpo da representação

Resposta em % do nível do índice no mês do impacto, com IC90.

| var | point_prod | lo90_prod | hi90_prod | point_loglevel | lo90_loglevel | hi90_loglevel | sig90_loglevel | sig68_loglevel |
|---|---|---|---|---|---|---|---|---|
| asset_ibov | -2.407 | -13.08 |  4.78 | -4.587 | -10.82 | -0.7463 | TRUE | TRUE |
| asset_idiv |  -2.9 | -14.45 | 3.984 | -4.798 | -10.93 | -1.025 | TRUE | TRUE |
| asset_ifix | -2.175 | -6.666 | 0.6141 | -2.485 | -5.054 | -0.881 | TRUE | TRUE |
| asset_ifnc | -3.151 | -17.58 | 5.948 | -6.775 | -13.87 | -1.999 | TRUE | TRUE |
| asset_imat | -0.4555 | -8.014 | 5.187 | 1.147 | -4.388 | 5.014 | FALSE | FALSE |
| asset_imob | -3.787 | -15.91 | 4.521 | -8.359 | -16.47 | -3.499 | TRUE | TRUE |
| asset_mlcx | -2.478 | -13.14 |  4.35 | -4.422 | -10.47 | -0.6364 | TRUE | TRUE |
| asset_smll | -4.056 | -15.69 | 3.338 | -5.847 | -12.36 | -1.626 | TRUE | TRUE |

## Largura de banda h36/h0 por tcode

Réplica de `diagnostics/06_bloco_ativos.R` §6.2 em cada representação. A
comparação `prod` × `prod_nocum` isola o `cumsum`: mesmo painel, mesmo seed,
mesmo modelo — o ponto é idêntico após cumular (conferido a 1e-9), a banda não.

| variante | tcode | n | mediana | min | max |
|---|---|---|---|---|---|
| prod |     1 |    81 | 0.8306 | 0.3337 | 20.84 |
| prod |     2 |     8 | 8.569 | 6.896 | 12.75 |
| prod |     4 |    16 | 2.799 | 0.6208 | 6.876 |
| prod_nocum |     1 |    89 | 0.7226 | 0.2456 | 20.84 |
| prod_nocum |     4 |    16 | 2.799 | 0.6208 | 6.876 |
| loglevel |     1 |    81 | 0.8324 | 0.366 | 17.68 |
| loglevel |     4 |    24 | 1.708 | 0.5697 | 7.604 |
| level |     1 |    89 |  0.81 | 0.3521 | 19.48 |
| level |     4 |    16 | 2.469 | 0.7222 | 9.421 |

A mesma razão só nos 8 índices — sob `loglevel` eles migram para tcode 4 e a
mediana do grupo acima passa a misturá-los com as 16 séries de crédito/base/PIB:

| var | prod | prod_nocum | loglevel | level |
|---|---|---|---|---|
| asset_ibov | 7.213 | 0.2536 | 0.6694 | 0.4049 |
| asset_idiv | 8.946 | 0.3106 | 0.6875 | 0.3782 |
| asset_ifix | 12.75 | 0.4837 | 1.241 | 0.9023 |
| asset_ifnc | 10.38 | 0.3411 | 0.5906 | 0.4016 |
| asset_imat | 11.99 | 0.4162 | 1.295 | 1.049 |
| asset_imob | 8.191 | 0.281 | 0.8278 | 0.5704 |
| asset_mlcx | 6.896 | 0.2456 | 0.5697 | 0.3521 |
| asset_smll | 6.991 | 0.2692 | 0.9244 | 0.6691 |

## Onde ficam as células sig90 do bloco

| variante | var | n | h_min | h_max | horizontes |
|---|---|---|---|---|---|
| level | asset_ibov |     5 |     0 |     4 | 0,1,2,3,4 |
| level | asset_idiv |     4 |     0 |     3 | 0,1,2,3 |
| level | asset_ifix |     5 |     0 |     4 | 0,1,2,3,4 |
| level | asset_ifnc |     5 |     0 |     4 | 0,1,2,3,4 |
| level | asset_imob |     5 |     0 |     4 | 0,1,2,3,4 |
| level | asset_mlcx |     5 |     0 |     4 | 0,1,2,3,4 |
| level | asset_smll |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_ibov |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_idiv |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_ifix |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_ifnc |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_imob |     6 |     0 |     5 | 0,1,2,3,4,5 |
| loglevel | asset_mlcx |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_smll |     6 |     0 |     5 | 0,1,2,3,4,5 |
| prod | asset_ifix |     2 |     1 |     2 | 1,2 |

## A deriva de médio prazo do Ibovespa

O bloco comentado em `arquivo/tex/main.tex:445` (arquivado; paper canônico é `paper/paper_anpec.tex`) explica o pico de +20,3% em h≈24 como
erro de estimação acumulado. A comparação abaixo mostra que o diagnóstico
estava certo — e que a representação em nível remove o artefato na origem, em
vez de explicá-lo depois.

| h | lo68 | hi68 | sig90 | point_prod | point_loglevel | point_level | sig68_prod | sig68_loglevel | sig68_level |
|---|---|---|---|---|---|---|---|---|---|
|     0 | -8.353 | 1.276 | FALSE | -2.407 |    NA |    NA | FALSE | NA | NA |
|     1 | -12.32 | 0.9812 | FALSE | -4.459 |    NA |    NA | FALSE | NA | NA |
|     6 | -7.673 | 18.07 | FALSE | 5.135 |    NA |    NA | FALSE | NA | NA |
|    12 | -2.945 | 37.74 | FALSE | 19.16 |    NA |    NA | FALSE | NA | NA |
|    18 | -0.1062 | 51.86 | FALSE | 28.82 |    NA |    NA | FALSE | NA | NA |
|    24 | 0.2121 | 58.88 | FALSE | 31.82 |    NA |    NA | TRUE | NA | NA |
|    36 | -4.283 | 62.12 | FALSE | 25.49 |    NA |    NA | FALSE | NA | NA |
|    48 | -12.89 | 53.22 | FALSE | 13.86 |    NA |    NA | FALSE | NA | NA |
|     0 | -8.114 | -2.295 | TRUE |    NA | -4.587 |    NA | NA | TRUE | NA |
|     1 | -11.35 | -4.882 | TRUE |    NA | -7.555 |    NA | NA | TRUE | NA |
|     6 | -5.876 | -0.6855 | FALSE |    NA | -4.104 |    NA | NA | TRUE | NA |
|    12 | -2.272 |  2.21 | FALSE |    NA | -0.4024 |    NA | NA | FALSE | NA |
|    18 | -1.368 | 2.475 | FALSE |    NA | 0.6849 |    NA | NA | FALSE | NA |
|    24 | -0.9529 | 2.571 | FALSE |    NA | 1.537 |    NA | NA | FALSE | NA |
|    36 | -0.4801 | 2.927 | FALSE |    NA | 2.029 |    NA | NA | FALSE | NA |
|    48 | -0.479 |  2.25 | FALSE |    NA |  1.75 |    NA | NA | FALSE | NA |
|     0 | -10.43 | -3.663 | TRUE |    NA |    NA | -6.074 | NA | NA | TRUE |
|     1 | -12.22 | -5.323 | TRUE |    NA |    NA | -7.958 | NA | NA | TRUE |
|     6 | -5.044 | -0.2353 | FALSE |    NA |    NA | -2.97 | NA | NA | TRUE |
|    12 | -1.685 | 2.176 | FALSE |    NA |    NA | 0.0188 | NA | NA | FALSE |
|    18 | -1.099 | 1.966 | FALSE |    NA |    NA | 0.1891 | NA | NA | FALSE |
|    24 | -0.8197 | 1.881 | FALSE |    NA |    NA | 0.7719 | NA | NA | FALSE |
|    36 | -0.309 | 2.524 | FALSE |    NA |    NA | 1.457 | NA | NA | FALSE |
|    48 | -0.4656 | 1.886 | FALSE |    NA |    NA | 0.9585 | NA | NA | FALSE |

## Proxy de |t| no bloco (|ponto| / meia-banda de 68%)

| h | level | loglevel | prod |
|---|---|---|---|
|     0 | 1.845 | 1.784 | 0.5566 |
|     1 |   2.3 | 2.485 | 0.7227 |
|     3 | 1.894 | 2.452 | 0.2183 |
|     6 | 1.194 | 1.611 | 0.3958 |
|    12 | 0.2225 | 0.1465 | 0.8671 |
|    18 | 0.4689 | 0.4411 | 1.029 |
|    24 | 0.6754 | 0.9253 | 1.016 |
|    36 | 0.9938 | 1.159 | 0.7918 |
|    48 | 0.7068 | 1.137 | 0.6434 |

## Seção cruzada

Correlação (n = 8) entre a sensibilidade a juros medida fora do modelo
(β sobre Δ`yield_2y`, HC1, sempre nos retornos) e a resposta da IRF.

| variante | h | cor_beta_juros | cor_sp_juros | amplitude | n_neg |
|---|---|---|---|---|---|
| prod |     0 | 0.8674 | 0.881 | 3.601 |     8 |
| prod |     6 | -0.06914 | 0.1905 | 20.51 |     2 |
| prod |    12 | -0.3625 | -0.1905 | 43.23 |     1 |
| prod |    24 | -0.6032 |  -0.5 | 76.19 |     1 |
| prod |    36 | -0.6583 |  -0.5 | 98.26 |     2 |
| prod |    48 | -0.6656 | -0.619 | 107.4 |     3 |
| loglevel |     0 | 0.9504 | 0.9048 | 9.505 |     7 |
| loglevel |     6 | 0.9723 | 0.9524 | 5.983 |     8 |
| loglevel |    12 | 0.1036 | 0.04762 | 0.6993 |     7 |
| loglevel |    24 | -0.8994 | -0.8333 | 3.154 |     0 |
| loglevel |    36 | -0.2306 | -0.2381 | 1.863 |     0 |
| loglevel |    48 | 0.2594 | -0.1667 | 2.792 |     0 |
| level |     0 | 0.9752 | 0.9762 | 10.05 |     8 |
| level |     6 | 0.9774 | 0.9762 | 4.907 |     8 |
| level |    12 | -0.8092 | -0.5476 | 2.532 |     2 |
| level |    24 | -0.8735 | -0.8333 | 3.841 |     1 |
| level |    36 | -0.2329 | -0.4286 | 2.507 |     0 |
| level |    48 | 0.3418 | -0.04762 | 2.921 |     0 |

## Guardas sobre o resto do modelo

Sem isto a comparação não vale nada: mudar o painel re-estima tudo.

| conjunto | n_sig90_prod | n_sig90_loglevel | sobrevivem_loglevel | n_sig90_level | sobrevivem_level |
|---|---|---|---|---|---|
| 53 series escoradas |    84 |   139 |    78 |   126 |    77 |
| 45 nao-acionarias |    82 |   102 |    76 |    92 |    75 |

| var | point_prod | point_loglevel | point_level | sig90_prod | sig90_loglevel | sig90_level |
|---|---|---|---|---|---|---|
| yield_2y | 0.0108 | 0.01021 | 0.01067 | TRUE | TRUE | TRUE |
| yield_5y | 0.0117 | 0.01108 | 0.01189 | TRUE | TRUE | TRUE |
| cambio_usd | 0.2281 | 0.2269 | 0.2517 | TRUE | TRUE | TRUE |
| embi_perc | 0.3204 | 0.2911 | 0.341 | TRUE | TRUE | TRUE |
| cds_5y | 43.44 | 40.46 | 45.68 | TRUE | TRUE | TRUE |
| price_ipca | -0.1678 | 0.01075 | -0.009397 | FALSE | FALSE | FALSE |
| ibc_br | -0.7673 | -0.7279 | -0.6866 | TRUE | TRUE | TRUE |

## O que não foi feito, declarado

- **Nada de produção foi modificado.** Os painéis são construídos em memória;
  `infer_tcode_from_varnames` é chamada e sobrescrita localmente, nunca editada.
- **X-13 não é aplicado** às séries de nível reconstruídas — o diagnóstico
  contorna o `clean.R`. Uma promoção à produção passaria pelo
  `check_seasonality`, que hoje não marca retornos mas pode marcar níveis com
  tendência.
- **(r,q) não é re-selecionado.** ξ_mp no painel log-nível é reportado acima;
  se (7,6) ficar fraco lá, isso é achado, não decisão.
- **A assimetria mais ampla do painel não é tocada**: `cambio_usd` entra em
  nível, não em log.

## Auto-testes que travaram a rodada

1. Nível reconstruído vs `ibov_daily.csv`: sd relativo da razão 1.41e-15 (< 1e-12).
2. Ida e volta nas 8 séries: desvio máximo 2.36e-16 (< 1e-12).
3. Smoke test do `CLAUDE.md` na célula de produção.
4. Célula de produção vs `irf_coherence_h.csv`: desvio 4.55e-13 (< 1e-10).
5. ξ_mp de produção vs `mosw_strength_grid.csv`: 7.647790 full, 11.534897 pré-COVID.
6. `cumsum(prod_nocum)×100 == prod` nas 8 séries: desvio 0.00e+00 (< 1e-9).

