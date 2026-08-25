# Ações em log-nível: a representação causa o resultado nulo?

*Gerado por `script/asset_representation.R` em 2026-08-25. **Corpo gerado: não escreva prosa aqui.** A leitura interpretativa vive em `notas/2026-07-31_acoes_representacao.md`.*

## A pergunta

As 8 séries da B3 entram no painel como **retorno mensal composto**, enquanto
as outras 98 entram em nível ou log-nível. O `cumsum` que recupera o nível é
aplicado à **IRF** (`impulse_response.R:277`, tcode 2), não aos dados. Como o
BLL diferencia o painel para estimar `Λ` (`factor_estimation.R:300`), o bloco
acionário é estimado sobre a **segunda diferença** do log-preço. O paper
reporta **0 de 392** células sig90 nesse bloco — o tema do próprio título.

## Regra de leitura, fixada antes dos números

- **Mecânico** se, sob `loglevel`, houver ≥ 1 célula sig90 em h ≤ 12 **e**
  ξ_mp ≥ 3,84 (forma forte: ≥ 10).
- **Não confirmado** se o bloco seguir em 0 sig90 com as guardas de pé.
- **h = 0 é o teste limpo da representação**: único horizonte em que as duas
  medem o mesmo objeto e em que o `cumsum` é no-op.
- A inflação de banda é atribuída ao `cumsum` via `prod_cum` — mesmo modelo,
  mesmo seed, só o transform muda. Afirmação **separada**.
- **Inconclusivo** se ξ_mp do painel log-nível cair abaixo de 3,84.

## Veredito: MECANICO CONFIRMADO — 64 celulas sig90 em h<=12 sob log-nivel

## As quatro representações

| variante | painel | tcode_asset | xi_mp | f_robust_mp | max_eig | n_sig90 | n_sig90_h12 | n_sig68 |
|---|---|---|---|---|---|---|---|---|
| prod | retorno mensal |     6 |  5.24 | 10.06 | 0.9681 |     1 |     1 |    17 |
| loglevel | log(cumprod(1+r)) |     4 | 5.856 |  11.9 | 0.9732 |    64 |    64 |   156 |
| level | cumprod(1+r) |     1 |  6.44 | 13.45 | 0.9699 |    43 |    43 |    98 |
| prod_cum | retorno mensal |     2 |  5.24 | 10.06 | 0.9681 |    NA |    NA |    NA |

Força do instrumento nas duas janelas:

| variante | amostra | n_obs | xi_mp | f_robust_mp | ar_bounded | bandas_convencionais |
|---|---|---|---|---|---|---|
| prod | full |   149 |  5.24 | 10.06 | TRUE | FALSE |
| prod | pre_covid |    80 | 7.478 | 11.87 | TRUE | FALSE |
| loglevel | full |   149 | 5.856 |  11.9 | TRUE | FALSE |
| loglevel | pre_covid |    80 | 9.488 |  15.9 | TRUE | FALSE |
| level | full |   149 |  6.44 | 13.45 | TRUE | FALSE |
| level | pre_covid |    80 | 9.573 | 14.94 | TRUE | FALSE |
| prod_cum | full |   149 |  5.24 | 10.06 | TRUE | FALSE |
| prod_cum | pre_covid |    80 | 7.478 | 11.87 | TRUE | FALSE |

## h = 0 — o teste limpo da representação

Resposta em % do nível do índice no mês do impacto, com IC90.

| var | point_prod | lo90_prod | hi90_prod | point_loglevel | lo90_loglevel | hi90_loglevel | sig90_loglevel | sig68_loglevel |
|---|---|---|---|---|---|---|---|---|
| asset_ibov | -0.968 | -5.033 | 1.563 | -2.054 | -4.632 | -0.624 | TRUE | TRUE |
| asset_idiv | -1.301 | -5.366 |  1.13 | -2.102 | -4.68 | -0.8168 | TRUE | TRUE |
| asset_ifix | -1.041 | -2.607 | -0.02614 | -1.497 | -2.672 | -0.8942 | TRUE | TRUE |
| asset_ifnc | -1.781 | -6.603 | 1.296 | -3.145 | -5.845 | -1.232 | TRUE | TRUE |
| asset_imat | 0.4326 | -2.705 | 2.562 | 0.6441 | -2.579 | 1.962 | FALSE | FALSE |
| asset_imob | -1.659 | -6.506 |   1.5 | -4.415 | -7.562 | -2.392 | TRUE | TRUE |
| asset_smll | -1.79 | -6.133 | 1.045 | -3.01 | -5.97 | -1.48 | TRUE | TRUE |

## Largura de banda h36/h0 por tcode

Réplica de `diagnostics/06_bloco_ativos.R` §6.2 em cada representação. A
comparação `prod` × `prod_cum` isola o `cumsum`: mesmo painel, mesmo seed,
mesmo modelo — o ponto é idêntico após cumular (conferido a 1e-9), a banda não.

| variante | tcode | n | mediana | min | max |
|---|---|---|---|---|---|
| prod |     1 |    87 | 1.294 | 0.6505 | 15.07 |
| prod |     4 |    16 | 2.405 | 0.9354 | 3.794 |
| prod |     6 |     7 |  1.05 | 0.8631 | 1.143 |
| prod_cum |     1 |    87 | 1.294 | 0.6505 | 15.07 |
| prod_cum |     2 |     7 | 37.49 | 32.49 | 39.31 |
| prod_cum |     4 |    16 | 2.405 | 0.9354 | 3.794 |
| loglevel |     1 |    87 |  1.36 | 0.8481 | 11.55 |
| loglevel |     4 |    23 | 1.924 | 0.9418 | 4.058 |
| level |     1 |    94 | 1.317 | 0.8075 | 12.37 |
| level |     4 |    16 | 2.424 | 1.205 | 4.259 |

A mesma razão só nos 7 índices — sob `loglevel` eles migram para tcode 4 e a
mediana do grupo acima passa a misturá-los com as 16 séries de crédito/base/PIB:

| var | prod | prod_cum | loglevel | level |
|---|---|---|---|---|
| asset_ibov | 1.097 | 37.89 | 0.9418 | 0.8547 |
| asset_idiv | 1.122 | 39.31 |  1.03 | 0.9082 |
| asset_ifix | 0.8631 | 32.49 | 1.363 | 1.047 |
| asset_ifnc | 1.143 | 39.18 | 1.065 | 0.9682 |
| asset_imat | 1.047 |  36.4 | 1.151 | 1.247 |
| asset_imob |  1.05 | 36.79 | 1.445 | 1.017 |
| asset_smll | 1.042 | 37.49 | 1.045 | 0.8563 |

## Onde ficam as células sig90 do bloco

| variante | var | n | h_min | h_max | horizontes |
|---|---|---|---|---|---|
| level | asset_ibov |     8 |     0 |     7 | 0,1,2,3,4,5,6,7 |
| level | asset_idiv |     6 |     0 |     5 | 0,1,2,3,4,5 |
| level | asset_ifix |     8 |     0 |     7 | 0,1,2,3,4,5,6,7 |
| level | asset_ifnc |     6 |     0 |     5 | 0,1,2,3,4,5 |
| level | asset_imob |     7 |     0 |     6 | 0,1,2,3,4,5,6 |
| level | asset_smll |     8 |     0 |     7 | 0,1,2,3,4,5,6,7 |
| loglevel | asset_ibov |    10 |     0 |     9 | 0,1,2,3,4,5,6,7,8,9 |
| loglevel | asset_idiv |    10 |     0 |     9 | 0,1,2,3,4,5,6,7,8,9 |
| loglevel | asset_ifix |    11 |     0 |    10 | 0,1,2,3,4,5,6,7,8,9,10 |
| loglevel | asset_ifnc |     9 |     0 |     8 | 0,1,2,3,4,5,6,7,8 |
| loglevel | asset_imob |    11 |     0 |    10 | 0,1,2,3,4,5,6,7,8,9,10 |
| loglevel | asset_smll |    13 |     0 |    12 | 0,1,2,3,4,5,6,7,8,9,10,11,12 |
| prod | asset_ifix |     1 |     0 |     0 | 0 |

## A deriva de médio prazo do Ibovespa

O bloco comentado em `arquivo/tex/main.tex:445` (arquivado; paper canônico é `paper/paper_anpec.tex`) explica o pico de +20,3% em h≈24 como
erro de estimação acumulado. A comparação abaixo mostra que o diagnóstico
estava certo — e que a representação em nível remove o artefato na origem, em
vez de explicá-lo depois.

| h | lo68 | hi68 | sig90 | point_prod | point_loglevel | point_level | sig68_prod | sig68_loglevel | sig68_level |
|---|---|---|---|---|---|---|---|---|---|
|     0 | -3.41 | 0.3081 | FALSE | -0.968 |    NA |    NA | FALSE | NA | NA |
|     1 | -2.647 | 0.7154 | FALSE | -1.378 |    NA |    NA | FALSE | NA | NA |
|     6 | -0.295 | 3.277 | FALSE | 1.191 |    NA |    NA | FALSE | NA | NA |
|    12 | -0.1687 | 4.031 | FALSE | 1.889 |    NA |    NA | FALSE | NA | NA |
|    18 | -0.6541 | 3.992 | FALSE | 0.8771 |    NA |    NA | FALSE | NA | NA |
|    24 | -1.437 | 3.123 | FALSE | -0.4361 |    NA |    NA | FALSE | NA | NA |
|    36 | -2.505 | 1.413 | FALSE | -1.922 |    NA |    NA | FALSE | NA | NA |
|    48 | -2.058 | 0.6663 | FALSE | -1.634 |    NA |    NA | FALSE | NA | NA |
|     0 | -3.826 | -1.283 | TRUE |    NA | -2.054 |    NA | NA | TRUE | NA |
|     1 | -5.866 | -2.854 | TRUE |    NA | -4.038 |    NA | NA | TRUE | NA |
|     6 | -4.922 | -1.778 | TRUE |    NA | -2.947 |    NA | NA | TRUE | NA |
|    12 | -3.752 | -0.6775 | FALSE |    NA | -1.301 |    NA | NA | TRUE | NA |
|    18 | -2.966 | -0.02067 | FALSE |    NA | -0.7291 |    NA | NA | TRUE | NA |
|    24 | -1.969 | 0.6479 | FALSE |    NA | -0.08987 |    NA | NA | FALSE | NA |
|    36 | -0.4333 | 1.606 | FALSE |    NA | 0.9347 |    NA | NA | FALSE | NA |
|    48 | -0.07922 | 1.794 | FALSE |    NA |   0.9 |    NA | NA | FALSE | NA |
|     0 | -3.947 | -1.335 | TRUE |    NA |    NA | -1.985 | NA | NA | TRUE |
|     1 | -5.503 | -2.175 | TRUE |    NA |    NA | -3.289 | NA | NA | TRUE |
|     6 | -4.352 | -1.083 | TRUE |    NA |    NA | -1.762 | NA | NA | TRUE |
|    12 | -3.179 | -0.138 | FALSE |    NA |    NA | -0.4939 | NA | NA | TRUE |
|    18 | -2.736 | 0.2754 | FALSE |    NA |    NA | -0.568 | NA | NA | FALSE |
|    24 | -2.011 | 0.7716 | FALSE |    NA |    NA | -0.09227 | NA | NA | FALSE |
|    36 | -0.6155 |  1.26 | FALSE |    NA |    NA | 0.4954 | NA | NA | FALSE |
|    48 | -0.2982 | 1.212 | FALSE |    NA |    NA | 0.4339 | NA | NA | FALSE |

## Proxy de |t| no bloco (|ponto| / meia-banda de 68%)

| h | level | loglevel | prod |
|---|---|---|---|
|     0 | 1.809 | 2.143 | 0.7298 |
|     1 | 2.156 | 2.901 | 0.9805 |
|     3 | 2.054 | 2.666 | 0.268 |
|     6 | 1.044 | 1.891 | 0.6538 |
|    12 | 0.2018 | 0.6797 | 0.8014 |
|    18 | 0.3514 | 0.1654 | 0.3651 |
|    24 | 0.4184 | 0.4341 | 0.181 |
|    36 | 0.6682 | 1.135 | 0.9464 |
|    48 | 0.3894 | 0.8477 | 1.157 |

## Seção cruzada

Correlação (n = 8) entre a sensibilidade a juros medida fora do modelo
(β sobre Δ`yield_2y`, HC1, sempre nos retornos) e a resposta da IRF.

| variante | h | cor_beta_juros | cor_sp_juros | amplitude | n_neg |
|---|---|---|---|---|---|
| prod |     0 | 0.8017 | 0.7857 | 2.222 |     6 |
| prod |     6 | -0.1848 |     0 |  1.57 |     1 |
| prod |    12 | -0.6071 | -0.3571 | 2.025 |     0 |
| prod |    24 | 0.09879 | 0.03571 | 0.8467 |     7 |
| prod |    36 | 0.6103 | 0.6429 | 2.035 |     7 |
| prod |    48 | 0.658 |   0.5 | 1.713 |     7 |
| loglevel |     0 | 0.9621 | 0.9286 | 5.059 |     6 |
| loglevel |     6 | 0.9915 |     1 | 4.832 |     7 |
| loglevel |    12 | 0.5666 | 0.6071 | 1.295 |     7 |
| loglevel |    24 | -0.7811 | -0.6786 | 4.045 |     2 |
| loglevel |    36 | -0.9223 | -0.8929 | 4.294 |     1 |
| loglevel |    48 | -0.9714 | -0.9643 | 1.789 |     0 |
| level |     0 | 0.9767 |     1 |  4.34 |     6 |
| level |     6 | 0.9434 |     1 | 2.161 |     7 |
| level |    12 | -0.634 | -0.5357 | 2.734 |     3 |
| level |    24 | -0.782 | -0.6786 | 3.982 |     2 |
| level |    36 | -0.8837 | -0.8929 |  2.33 |     1 |
| level |    48 | -0.2604 | -0.3214 | 0.763 |     1 |

## Guardas sobre o resto do modelo

Sem isto a comparação não vale nada: mudar o painel re-estima tudo.

| conjunto | n_sig90_prod | n_sig90_loglevel | sobrevivem_loglevel | n_sig90_level | sobrevivem_level |
|---|---|---|---|---|---|
| 58 series escoradas |   446 |   558 |   431 |   531 |   422 |
| 51 nao-acionarias |   445 |   494 |   430 |   488 |   421 |

| var | point_prod | point_loglevel | point_level | sig90_prod | sig90_loglevel | sig90_level |
|---|---|---|---|---|---|---|
| yield_2y | 0.007282 | 0.006826 | 0.006705 | TRUE | TRUE | TRUE |
| yield_5y | 0.007483 | 0.006331 | 0.006194 | TRUE | TRUE | TRUE |
| cambio_usd | 0.1539 | 0.1202 | 0.1174 | TRUE | TRUE | TRUE |
| embi_perc | 0.2448 | 0.1431 | 0.1431 | TRUE | TRUE | TRUE |
| cds_5y |  30.7 | 20.42 | 20.12 | TRUE | TRUE | TRUE |
| price_ipca | -0.0549 | -0.07214 | -0.08672 | FALSE | FALSE | FALSE |
| ibc_br | -0.4432 | -0.2645 | -0.1847 | TRUE | FALSE | FALSE |

## O que não foi feito, declarado

- **Nada de produção foi modificado.** Os painéis são construídos em memória;
  `infer_tcode_from_varnames` é chamada e sobrescrita localmente, nunca editada.
- **X-13 não é aplicado** às séries de nível reconstruídas — o diagnóstico
  contorna o `clean.R`. Uma promoção à produção passaria pelo
  `check_seasonality`, que hoje não marca retornos mas pode marcar níveis com
  tendência.
- **(r,q) não é re-selecionado.** ξ_mp no painel log-nível é reportado acima;
  se (5,5) ficar fraco lá, isso é achado, não decisão.
- **A assimetria mais ampla do painel não é tocada**: `cambio_usd` entra em
  nível, não em log.

## Auto-testes que travaram a rodada

1. Nível reconstruído vs `ibov_daily.csv`: sd relativo da razão 1.41e-15 (< 1e-12).
2. Ida e volta nas 8 séries: desvio máximo 2.36e-16 (< 1e-12).
3. Smoke test do `CLAUDE.md` na célula de produção.
4. Célula de produção vs `irf_coherence_h.csv`: desvio 4.55e-13 (< 1e-10).
5. ξ_mp de produção vs `mosw_strength_grid.csv`: 5.240158 full, 7.478324 pré-COVID.
6. `cumsum(prod) == prod_cum` nas 7 séries: desvio 3.55e-15 (< 1e-9).

