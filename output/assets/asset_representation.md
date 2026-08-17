# Ações em log-nível: a representação causa o resultado nulo?

*Gerado por `script/asset_representation.R` em 2026-08-17. **Corpo gerado: não escreva prosa aqui.** A leitura interpretativa vive em `notas/2026-07-31_acoes_representacao.md`.*

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
- A inflação de banda é atribuída ao `cumsum` via `prod_nocum` — mesmo modelo,
  mesmo seed, só o transform muda. Afirmação **separada**.
- **Inconclusivo** se ξ_mp do painel log-nível cair abaixo de 3,84.

## Veredito: MECANICO CONFIRMADO — 49 celulas sig90 em h<=12 sob log-nivel

## As quatro representações

| variante | painel | tcode_asset | xi_mp | f_robust_mp | max_eig | n_sig90 | n_sig90_h12 | n_sig68 |
|---|---|---|---|---|---|---|---|---|
| prod | retorno mensal |     2 | 6.271 | 10.12 | 0.9649 |     4 |     4 |    20 |
| loglevel | log(cumprod(1+r)) |     4 | 6.073 | 9.964 | 0.9729 |    49 |    49 |   105 |
| level | cumprod(1+r) |     1 | 7.012 | 12.18 | 0.973 |    37 |    37 |    86 |
| prod_nocum | retorno mensal |     1 | 6.271 | 10.12 | 0.9649 |    NA |    NA |    NA |

Força do instrumento nas duas janelas:

| variante | amostra | n_obs | xi_mp | f_robust_mp | ar_bounded | bandas_convencionais |
|---|---|---|---|---|---|---|
| prod | full |   147 | 6.271 | 10.12 | TRUE | FALSE |
| prod | pre_covid |    78 | 10.99 | 9.747 | TRUE | TRUE |
| loglevel | full |   147 | 6.073 | 9.964 | TRUE | FALSE |
| loglevel | pre_covid |    78 | 10.31 | 11.32 | TRUE | TRUE |
| level | full |   147 | 7.012 | 12.18 | TRUE | FALSE |
| level | pre_covid |    78 | 9.493 | 9.893 | TRUE | FALSE |
| prod_nocum | full |   147 | 6.271 | 10.12 | TRUE | FALSE |
| prod_nocum | pre_covid |    78 | 10.99 | 9.747 | TRUE | TRUE |

## h = 0 — o teste limpo da representação

Resposta em % do nível do índice no mês do impacto, com IC90.

| var | point_prod | lo90_prod | hi90_prod | point_loglevel | lo90_loglevel | hi90_loglevel | sig90_loglevel | sig68_loglevel |
|---|---|---|---|---|---|---|---|---|
| asset_ibov | -1.723 | -6.91 | 0.7747 | -2.796 | -6.712 | -1.269 | TRUE | TRUE |
| asset_idiv | -2.039 | -7.425 | 0.2763 | -2.805 | -6.535 | -1.436 | TRUE | TRUE |
| asset_ifix | -1.311 | -3.331 | -0.2344 | -1.713 | -3.268 | -1.164 | TRUE | TRUE |
| asset_ifnc | -2.701 | -9.131 | 0.4169 | -3.936 | -7.888 | -1.689 | TRUE | TRUE |
| asset_imat | -0.06907 | -4.08 | 2.056 | -0.02129 | -4.01 | 1.056 | FALSE | FALSE |
| asset_imob | -2.557 | -8.58 | 0.5677 | -5.214 | -9.554 | -3.008 | TRUE | TRUE |
| asset_smll | -2.611 | -7.976 | 0.1328 | -3.759 | -7.982 | -2.028 | TRUE | TRUE |

## Largura de banda h36/h0 por tcode

Réplica de `diagnostics/06_bloco_ativos.R` §6.2 em cada representação. A
comparação `prod` × `prod_nocum` isola o `cumsum`: mesmo painel, mesmo seed,
mesmo modelo — o ponto é idêntico após cumular (conferido a 1e-9), a banda não.

| variante | tcode | n | mediana | min | max |
|---|---|---|---|---|---|
| prod |     1 |    87 | 1.168 | 0.6801 | 17.37 |
| prod |     2 |     7 |  27.8 |  26.6 | 28.17 |
| prod |     4 |    16 | 2.661 | 0.8735 | 4.931 |
| prod_nocum |     1 |    94 | 1.112 | 0.6801 | 17.37 |
| prod_nocum |     4 |    16 | 2.661 | 0.8735 | 4.931 |
| loglevel |     1 |    87 | 1.387 | 0.7101 | 15.19 |
| loglevel |     4 |    23 | 2.233 | 0.8947 | 3.919 |
| level |     1 |    94 | 1.347 | 0.7186 | 15.46 |
| level |     4 |    16 | 2.557 | 1.324 | 4.032 |

A mesma razão só nos 7 índices — sob `loglevel` eles migram para tcode 4 e a
mediana do grupo acima passa a misturá-los com as 16 séries de crédito/base/PIB:

| var | prod | prod_nocum | loglevel | level |
|---|---|---|---|---|
| asset_ibov |  27.8 | 0.9391 | 0.8947 | 0.7349 |
| asset_idiv | 28.17 | 0.9738 | 0.9346 | 0.7838 |
| asset_ifix |  26.6 | 0.8049 | 1.367 | 0.9606 |
| asset_ifnc | 28.14 | 0.9403 | 0.9364 | 0.7478 |
| asset_imat | 27.47 | 0.9464 | 1.181 | 1.342 |
| asset_imob |  27.9 | 0.9387 | 1.265 | 0.7891 |
| asset_smll | 26.93 | 0.8989 | 0.9878 | 0.7902 |

## Onde ficam as células sig90 do bloco

| variante | var | n | h_min | h_max | horizontes |
|---|---|---|---|---|---|
| level | asset_ibov |     6 |     0 |     5 | 0,1,2,3,4,5 |
| level | asset_idiv |     5 |     0 |     4 | 0,1,2,3,4 |
| level | asset_ifix |     7 |     0 |     6 | 0,1,2,3,4,5,6 |
| level | asset_ifnc |     6 |     0 |     5 | 0,1,2,3,4,5 |
| level | asset_imob |     6 |     0 |     5 | 0,1,2,3,4,5 |
| level | asset_smll |     7 |     0 |     6 | 0,1,2,3,4,5,6 |
| loglevel | asset_ibov |     8 |     0 |     7 | 0,1,2,3,4,5,6,7 |
| loglevel | asset_idiv |     7 |     0 |     6 | 0,1,2,3,4,5,6 |
| loglevel | asset_ifix |     9 |     0 |     8 | 0,1,2,3,4,5,6,7,8 |
| loglevel | asset_ifnc |     7 |     0 |     6 | 0,1,2,3,4,5,6 |
| loglevel | asset_imob |     8 |     0 |     7 | 0,1,2,3,4,5,6,7 |
| loglevel | asset_smll |    10 |     0 |     9 | 0,1,2,3,4,5,6,7,8,9 |
| prod | asset_ifix |     4 |     0 |     3 | 0,1,2,3 |

## A deriva de médio prazo do Ibovespa

O bloco comentado em `arquivo/tex/main.tex:445` (arquivado; paper canônico é `paper/paper_anpec.tex`) explica o pico de +20,3% em h≈24 como
erro de estimação acumulado. A comparação abaixo mostra que o diagnóstico
estava certo — e que a representação em nível remove o artefato na origem, em
vez de explicá-lo depois.

| h | lo68 | hi68 | sig90 | point_prod | point_loglevel | point_level | sig68_prod | sig68_loglevel | sig68_level |
|---|---|---|---|---|---|---|---|---|---|
|     0 | -5.042 | -0.6327 | FALSE | -1.723 |    NA |    NA | TRUE | NA | NA |
|     1 | -7.657 | -0.9403 | FALSE | -3.228 |    NA |    NA | TRUE | NA | NA |
|     6 | -11.56 | 8.314 | FALSE | -0.9125 |    NA |    NA | FALSE | NA | NA |
|    12 | -9.165 | 27.21 | FALSE | 10.26 |    NA |    NA | FALSE | NA | NA |
|    18 | -10.6 | 45.34 | FALSE | 16.95 |    NA |    NA | FALSE | NA | NA |
|    24 | -16.37 | 61.18 | FALSE | 16.83 |    NA |    NA | FALSE | NA | NA |
|    36 | -36.49 | 80.08 | FALSE | -0.8527 |    NA |    NA | FALSE | NA | NA |
|    48 | -64.67 | 85.02 | FALSE | -28.9 |    NA |    NA | FALSE | NA | NA |
|     0 | -5.357 | -2.058 | TRUE |    NA | -2.796 |    NA | NA | TRUE | NA |
|     1 | -7.488 | -3.807 | TRUE |    NA | -5.016 |    NA | NA | TRUE | NA |
|     6 | -5.855 | -1.799 | TRUE |    NA | -3.926 |    NA | NA | TRUE | NA |
|    12 | -3.68 | -0.1473 | FALSE |    NA | -1.519 |    NA | NA | TRUE | NA |
|    18 | -2.728 | 0.4176 | FALSE |    NA | -0.7405 |    NA | NA | FALSE | NA |
|    24 | -2.044 | 0.9889 | FALSE |    NA | -0.1054 |    NA | NA | FALSE | NA |
|    36 | -0.7045 | 1.753 | FALSE |    NA | 0.8191 |    NA | NA | FALSE | NA |
|    48 | -0.3474 | 1.798 | FALSE |    NA | 0.9058 |    NA | NA | FALSE | NA |
|     0 | -4.929 | -1.88 | TRUE |    NA |    NA | -2.371 | NA | NA | TRUE |
|     1 | -6.646 | -2.886 | TRUE |    NA |    NA | -3.896 | NA | NA | TRUE |
|     6 | -5.067 | -1.267 | FALSE |    NA |    NA | -2.91 | NA | NA | TRUE |
|    12 | -3.28 | 0.3048 | FALSE |    NA |    NA | -0.6076 | NA | NA | FALSE |
|    18 | -2.468 | 0.6279 | FALSE |    NA |    NA | -0.5568 | NA | NA | FALSE |
|    24 | -1.981 | 0.8748 | FALSE |    NA |    NA | -0.1961 | NA | NA | FALSE |
|    36 | -0.6944 |  1.37 | FALSE |    NA |    NA | 0.4605 | NA | NA | FALSE |
|    48 | -0.431 | 1.423 | FALSE |    NA |    NA | 0.4257 | NA | NA | FALSE |

## Proxy de |t| no bloco (|ponto| / meia-banda de 68%)

| h | level | loglevel | prod |
|---|---|---|---|
|     0 | 1.719 | 2.093 | 0.9677 |
|     1 | 2.167 | 2.947 | 1.095 |
|     3 | 2.138 | 2.935 | 0.6745 |
|     6 | 1.531 | 2.004 | 0.4133 |
|    12 | 0.05899 | 0.7344 | 0.4521 |
|    18 | 0.3597 | 0.1562 | 0.5041 |
|    24 | 0.4156 | 0.4222 | 0.3439 |
|    36 | 0.7423 | 1.017 | 0.1094 |
|    48 | 0.2792 | 0.818 | 0.4238 |

## Seção cruzada

Correlação (n = 8) entre a sensibilidade a juros medida fora do modelo
(β sobre Δ`yield_2y`, HC1, sempre nos retornos) e a resposta da IRF.

| variante | h | cor_beta_juros | cor_sp_juros | amplitude | n_neg |
|---|---|---|---|---|---|
| prod |     0 | 0.8634 | 0.8214 | 2.632 |     7 |
| prod |     6 | 0.6283 | 0.5357 | 13.15 |     6 |
| prod |    12 | 0.1572 | 0.3214 | 18.49 |     1 |
| prod |    24 | -0.1882 | 0.03571 | 21.02 |     1 |
| prod |    36 | 0.4537 | 0.3929 | 11.33 |     7 |
| prod |    48 | 0.8089 | 0.8929 | 29.53 |     7 |
| loglevel |     0 | 0.9782 | 0.9286 | 5.193 |     7 |
| loglevel |     6 | 0.9888 | 0.9643 |  5.56 |     7 |
| loglevel |    12 | 0.7847 | 0.8929 |  1.58 |     7 |
| loglevel |    24 | -0.7776 | -0.6786 | 4.292 |     2 |
| loglevel |    36 | -0.9064 | -0.8929 | 4.643 |     1 |
| loglevel |    48 | -0.9656 | -0.9643 | 2.031 |     1 |
| level |     0 | 0.9848 |     1 | 4.526 |     7 |
| level |     6 | 0.9735 |     1 | 3.678 |     7 |
| level |    12 | -0.5704 | -0.4643 | 2.305 |     4 |
| level |    24 | -0.7701 | -0.6786 | 4.573 |     3 |
| level |    36 | -0.8628 | -0.8929 | 2.968 |     2 |
| level |    48 | -0.338 | -0.6429 | 0.961 |     1 |

## Guardas sobre o resto do modelo

Sem isto a comparação não vale nada: mudar o painel re-estima tudo.

| conjunto | n_sig90_prod | n_sig90_loglevel | sobrevivem_loglevel | n_sig90_level | sobrevivem_level |
|---|---|---|---|---|---|
| 58 series escoradas |   255 |   333 |   241 |   350 |   239 |
| 51 nao-acionarias |   251 |   284 |   237 |   313 |   235 |

| var | point_prod | point_loglevel | point_level | sig90_prod | sig90_loglevel | sig90_level |
|---|---|---|---|---|---|---|
| yield_2y | 0.00743 | 0.006994 | 0.006811 | TRUE | TRUE | TRUE |
| yield_5y | 0.007761 | 0.006697 | 0.006409 | TRUE | TRUE | TRUE |
| cambio_usd | 0.1579 | 0.1168 | 0.1146 | TRUE | TRUE | TRUE |
| embi_perc | 0.262 | 0.172 | 0.1586 | TRUE | TRUE | TRUE |
| cds_5y | 32.54 | 22.72 | 21.36 | TRUE | TRUE | TRUE |
| price_ipca | -0.06179 | -0.01642 | -0.0484 | FALSE | FALSE | FALSE |
| ibc_br | -0.4605 | -0.3047 | -0.211 | TRUE | FALSE | FALSE |

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
5. ξ_mp de produção vs `mosw_strength_grid.csv`: 6.270850 full, 10.992677 pré-COVID.
6. `cumsum(prod_nocum)×100 == prod` nas 8 séries: desvio 0.00e+00 (< 1e-9).

