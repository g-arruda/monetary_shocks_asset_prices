# Ações em log-nível: a representação causa o resultado nulo?

*Gerado por `script/asset_representation.R` em 2026-08-01. **Corpo gerado: não escreva prosa aqui.** A leitura interpretativa vive em `relatorio/working-notes/2026-07-31_acoes_representacao.md`.*

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

## Veredito: MECANICO CONFIRMADO — 39 celulas sig90 em h<=12 sob log-nivel

## As quatro representações

| variante | painel | tcode_asset | xi_mp | wald_joint | max_eig | n_sig90 | n_sig90_h12 | n_sig68 |
|---|---|---|---|---|---|---|---|---|
| prod | retorno mensal |     2 | 10.43 | 13.99 | 0.9768 |     0 |     0 |    56 |
| loglevel | log(cumprod(1+r)) |     4 |  8.94 | 10.66 | 0.9682 |    39 |    39 |    54 |
| level | cumprod(1+r) |     1 | 10.23 | 11.87 | 0.9755 |    28 |    28 |    54 |
| prod_nocum | retorno mensal |     1 | 10.43 | 13.99 | 0.9768 |    NA |    NA |    NA |

Força do instrumento nas duas janelas:

| variante | amostra | n_obs | xi_mp | f_factor | ar_bounded | bandas_convencionais |
|---|---|---|---|---|---|---|
| prod | full |   147 | 10.43 | 6.313 | TRUE | TRUE |
| prod | pre_covid |    78 | 12.22 | 3.093 | TRUE | TRUE |
| loglevel | full |   147 |  8.94 | 6.415 | TRUE | FALSE |
| loglevel | pre_covid |    78 | 3.913 | 1.511 | TRUE | FALSE |
| level | full |   147 | 10.23 | 6.927 | TRUE | TRUE |
| level | pre_covid |    78 | 5.728 | 2.899 | TRUE | FALSE |
| prod_nocum | full |   147 | 10.43 | 6.313 | TRUE | TRUE |
| prod_nocum | pre_covid |    78 | 12.22 | 3.093 | TRUE | TRUE |

## h = 0 — o teste limpo da representação

Resposta em % do nível do índice no mês do impacto, com IC90.

| var | point_prod | lo90_prod | hi90_prod | point_loglevel | lo90_loglevel | hi90_loglevel | sig90_loglevel | sig68_loglevel |
|---|---|---|---|---|---|---|---|---|
| asset_ibov | -1.673 | -7.771 | 1.759 | -3.683 | -8.696 | -0.8644 | TRUE | TRUE |
| asset_idiv | -2.038 | -8.182 | 1.623 | -3.897 | -8.736 | -1.191 | TRUE | TRUE |
| asset_ifix | -1.034 | -3.592 | 0.5564 | -1.631 | -3.765 | -0.4089 | TRUE | TRUE |
| asset_ifnc | -1.975 | -9.718 | 2.512 | -5.284 | -11.15 | -1.824 | TRUE | TRUE |
| asset_imat | -0.3149 | -4.934 | 3.069 | 0.6302 | -3.384 | 3.508 | FALSE | FALSE |
| asset_imob | -2.895 | -10.3 | 1.468 | -6.518 | -12.52 | -2.941 | TRUE | TRUE |
| asset_mlcx | -1.736 | -7.819 | 1.609 | -3.564 | -8.415 | -0.8207 | TRUE | TRUE |
| asset_smll | -2.677 | -9.074 | 1.521 | -4.463 | -9.597 | -1.189 | TRUE | TRUE |

## Largura de banda h36/h0 por tcode

Réplica de `diagnostics/06_bloco_ativos.R` §6.2 em cada representação. A
comparação `prod` × `prod_nocum` isola o `cumsum`: mesmo painel, mesmo seed,
mesmo modelo — o ponto é idêntico após cumular (conferido a 1e-9), a banda não.

| variante | tcode | n | mediana | min | max |
|---|---|---|---|---|---|
| prod |     1 |    81 | 0.9435 | 0.4214 | 10.98 |
| prod |     2 |     8 | 10.46 | 8.104 | 14.53 |
| prod |     4 |    16 | 2.793 | 0.6497 | 7.339 |
| prod_nocum |     1 |    89 | 0.8619 | 0.3292 | 10.98 |
| prod_nocum |     4 |    16 | 2.793 | 0.6497 | 7.339 |
| loglevel |     1 |    81 | 0.8682 | 0.437 | 9.357 |
| loglevel |     4 |    24 | 1.729 | 0.5796 | 7.423 |
| level |     1 |    89 | 0.8712 | 0.4298 | 10.83 |
| level |     4 |    16 | 2.668 | 0.7612 | 8.317 |

A mesma razão só nos 8 índices — sob `loglevel` eles migram para tcode 4 e a
mediana do grupo acima passa a misturá-los com as 16 séries de crédito/base/PIB:

| var | prod | prod_nocum | loglevel | level |
|---|---|---|---|---|
| asset_ibov | 8.844 | 0.3456 | 0.6714 | 0.4831 |
| asset_idiv | 11.49 | 0.4137 | 0.7503 | 0.4759 |
| asset_ifix | 14.53 | 0.5642 |  1.18 | 0.9738 |
| asset_ifnc |  13.2 | 0.4516 | 0.5806 | 0.4554 |
| asset_imat | 12.91 | 0.4258 | 1.459 | 1.335 |
| asset_imob | 9.426 | 0.3513 | 0.9266 | 0.6435 |
| asset_mlcx | 8.186 | 0.3292 | 0.5796 | 0.4298 |
| asset_smll | 8.104 | 0.3333 | 0.9469 | 0.8414 |

## Onde ficam as células sig90 do bloco

| variante | var | n | h_min | h_max | horizontes |
|---|---|---|---|---|---|
| level | asset_ibov |     4 |     0 |     3 | 0,1,2,3 |
| level | asset_idiv |     4 |     0 |     3 | 0,1,2,3 |
| level | asset_ifix |     4 |     0 |     3 | 0,1,2,3 |
| level | asset_ifnc |     4 |     0 |     3 | 0,1,2,3 |
| level | asset_imob |     4 |     0 |     3 | 0,1,2,3 |
| level | asset_mlcx |     4 |     0 |     3 | 0,1,2,3 |
| level | asset_smll |     4 |     0 |     3 | 0,1,2,3 |
| loglevel | asset_ibov |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_idiv |     6 |     0 |     5 | 0,1,2,3,4,5 |
| loglevel | asset_ifix |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_ifnc |     6 |     0 |     5 | 0,1,2,3,4,5 |
| loglevel | asset_imob |     6 |     0 |     5 | 0,1,2,3,4,5 |
| loglevel | asset_mlcx |     5 |     0 |     4 | 0,1,2,3,4 |
| loglevel | asset_smll |     6 |     0 |     5 | 0,1,2,3,4,5 |

## A deriva de médio prazo do Ibovespa

O bloco comentado em `arquivo/tex/main.tex:445` (arquivado em 2026-08-02;
paper canônico é `texto_anpec/paper_anpec.tex`) explica o pico de +20,3% em h≈24 como
erro de estimação acumulado. A comparação abaixo mostra que o diagnóstico
estava certo — e que a representação em nível remove o artefato na origem, em
vez de explicá-lo depois.

| h | lo68 | hi68 | sig90 | point_prod | point_loglevel | point_level | sig68_prod | sig68_loglevel | sig68_level |
|---|---|---|---|---|---|---|---|---|---|
|     0 | -5.429 | 0.3111 | FALSE | -1.673 |    NA |    NA | FALSE | NA | NA |
|     1 | -8.082 | -0.5995 | FALSE | -3.109 |    NA |    NA | TRUE | NA | NA |
|     6 | -5.305 | 9.566 | FALSE |  2.36 |    NA |    NA | FALSE | NA | NA |
|    12 | -1.038 | 25.17 | FALSE | 11.52 |    NA |    NA | FALSE | NA | NA |
|    18 | 0.8326 | 34.57 | FALSE |  18.2 |    NA |    NA | TRUE | NA | NA |
|    24 | 1.194 | 40.55 | FALSE | 20.26 |    NA |    NA | TRUE | NA | NA |
|    36 | -2.064 | 42.29 | FALSE | 16.37 |    NA |    NA | FALSE | NA | NA |
|    48 | -11.67 | 39.91 | FALSE | 7.916 |    NA |    NA | FALSE | NA | NA |
|     0 | -6.257 | -2.069 | TRUE |    NA | -3.683 |    NA | NA | TRUE | NA |
|     1 | -8.932 | -4.087 | TRUE |    NA | -5.851 |    NA | NA | TRUE | NA |
|     6 | -4.948 | -0.6696 | FALSE |    NA | -3.17 |    NA | NA | TRUE | NA |
|    12 | -1.604 | 1.796 | FALSE |    NA | -0.1953 |    NA | NA | FALSE | NA |
|    18 | -0.9653 | 2.018 | FALSE |    NA | 0.7598 |    NA | NA | FALSE | NA |
|    24 | -0.5828 | 2.356 | FALSE |    NA | 1.397 |    NA | NA | FALSE | NA |
|    36 | -0.3821 | 2.449 | FALSE |    NA | 1.633 |    NA | NA | FALSE | NA |
|    48 | -0.514 | 1.817 | FALSE |    NA | 1.275 |    NA | NA | FALSE | NA |
|     0 | -7.299 | -2.753 | TRUE |    NA |    NA | -4.257 | NA | NA | TRUE |
|     1 | -8.761 | -4.037 | TRUE |    NA |    NA | -5.581 | NA | NA | TRUE |
|     6 | -4.002 | -0.2741 | FALSE |    NA |    NA | -2.142 | NA | NA | TRUE |
|    12 | -1.332 | 1.555 | FALSE |    NA |    NA | -0.08553 | NA | NA | FALSE |
|    18 | -0.8811 |  1.42 | FALSE |    NA |    NA | 0.376 | NA | NA | FALSE |
|    24 | -0.4718 | 1.702 | FALSE |    NA |    NA | 0.9554 | NA | NA | FALSE |
|    36 | -0.07248 |  2.01 | FALSE |    NA |    NA |  1.18 | NA | NA | FALSE |
|    48 | -0.3478 | 1.621 | FALSE |    NA |    NA | 0.7115 | NA | NA | FALSE |

## Proxy de |t| no bloco (|ponto| / meia-banda de 68%)

| h | level | loglevel | prod |
|---|---|---|---|
|     0 | 1.907 | 1.826 | 0.6761 |
|     1 | 2.377 |  2.45 | 0.904 |
|     3 | 1.719 | 2.375 | 0.2686 |
|     6 | 1.064 | 1.513 | 0.3128 |
|    12 | 0.1923 | 0.1072 | 0.8096 |
|    18 | 0.5581 | 0.5525 | 1.005 |
|    24 | 0.9174 | 0.958 | 0.9875 |
|    36 | 1.062 | 1.109 | 0.7811 |
|    48 | 0.5933 | 0.9463 | 0.6348 |

## Seção cruzada

Correlação (n = 8) entre a sensibilidade a juros medida fora do modelo
(β sobre Δ`yield_2y`, HC1, sempre nos retornos) e a resposta da IRF.

| variante | h | cor_beta_juros | cor_sp_juros | amplitude | n_neg |
|---|---|---|---|---|---|
| prod |     0 | 0.9031 | 0.7857 |  2.58 |     8 |
| prod |     6 | -0.1078 | 0.04762 | 13.21 |     3 |
| prod |    12 | -0.4699 | -0.3333 | 29.36 |     1 |
| prod |    24 | -0.6554 | -0.619 | 54.92 |     2 |
| prod |    36 | -0.678 | -0.619 | 72.36 |     2 |
| prod |    48 | -0.6718 | -0.619 |  78.4 |     3 |
| loglevel |     0 | 0.9329 | 0.9286 | 7.148 |     7 |
| loglevel |     6 | 0.9634 | 0.9286 | 4.367 |     8 |
| loglevel |    12 | -0.2859 | -0.2381 | 0.7246 |     6 |
| loglevel |    24 | -0.865 | -0.9048 | 1.908 |     0 |
| loglevel |    36 | -0.1842 | -0.2143 | 1.664 |     0 |
| loglevel |    48 | 0.1687 | -0.04762 | 2.084 |     0 |
| level |     0 | 0.9612 |     1 | 6.501 |     8 |
| level |     6 | 0.9603 |     1 | 2.742 |     8 |
| level |    12 | -0.7094 | -0.619 | 2.482 |     3 |
| level |    24 | -0.8516 | -0.8095 | 2.586 |     0 |
| level |    36 | -0.1954 | -0.119 | 1.778 |     0 |
| level |    48 | 0.2904 | 0.09524 | 2.127 |     0 |

## Guardas sobre o resto do modelo

Sem isto a comparação não vale nada: mudar o painel re-estima tudo.

| conjunto | n_sig90_prod | n_sig90_loglevel | sobrevivem_loglevel | n_sig90_level | sobrevivem_level |
|---|---|---|---|---|---|
| 53 series escoradas |    92 |   139 |    79 |   115 |    75 |
| 45 nao-acionarias |    92 |   100 |    79 |    87 |    75 |

| var | point_prod | point_loglevel | point_level | sig90_prod | sig90_loglevel | sig90_level |
|---|---|---|---|---|---|---|
| yield_2y | 0.009164 | 0.009067 | 0.009343 | TRUE | TRUE | TRUE |
| yield_5y | 0.009274 | 0.009303 | 0.009707 | TRUE | TRUE | TRUE |
| cambio_usd | 0.1498 | 0.1618 | 0.1686 | TRUE | TRUE | TRUE |
| embi_perc | 0.1995 | 0.2209 | 0.2435 | TRUE | TRUE | TRUE |
| cds_5y | 29.07 | 31.37 | 33.52 | TRUE | TRUE | TRUE |
| price_ipca | -0.07025 | 0.05898 | 0.03196 | FALSE | FALSE | FALSE |
| ibc_br | -0.393 | -0.4385 | -0.3864 | FALSE | TRUE | TRUE |

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
5. ξ_mp de produção vs `mosw_strength_grid.csv`: 10.430831 full, 12.223434 pré-COVID.
6. `cumsum(prod_nocum)×100 == prod` nas 8 séries: desvio 0.00e+00 (< 1e-9).

