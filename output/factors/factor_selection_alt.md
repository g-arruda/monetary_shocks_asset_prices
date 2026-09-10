# Número de fatores `r`: Ahn-Horenstein (ER/GR) e Alessi-Barigozzi-Capasso contra Bai-Ng

Gerado por `script/factor_selection_alt.R` em 2026-09-10.
**Corpo gerado — não escrever prosa aqui.** A leitura e a auditoria do pacote `factorselect` vivem em `notas/2026-09-10_selecao_fatores_ah_abc.md`.

## Objeto e grade

Painel de produção `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03-01 a 2025-12-01, 115 séries. Objeto: primeiras diferenças padronizadas BLL (`estimate_static_factors()$yy`, o mesmo `X_std` de `bai_ng_criteria(apply_bll = TRUE)`), com T = 165, N = 115 e m = min(N, T) = 115. Grade k = 1..20, a da superfície Bai-Ng de produção.

## Auto-testes

| teste | desvio_max | tolerancia |
|---|---|---|
| (a) bai_ng_criteria(apply_bll = TRUE) contra a superfície salva | 5.55e-17 | 1e-12 |
| (b) log V(k) de yy + penalidades Bai-Ng contra a superfície salva | 4.44e-16 | 1e-10 |
| (c) mu_k·NT/(T-1) contra os autovalores de estimate_static_factors (k = 1..5), relativo | 1.55e-15 | 1e-10 |
| (d) GR via mu* contra ln[V(k-1)/V(k)] / ln[V(k)/V(k+1)] | 6.88e-15 | 1e-12 |
| (e) ABC, amostra cheia, c = 1, contra o argmin de IC1 em k = 0..20 |    0 |    0 |
| (f) médias de linha e de coluna do painel duplamente centrado | 1.21e-16 | 1e-12 |

## Resultado e veredito pré-registrado

Regra fixada antes de olhar as estimativas: ER, GR (Teorema 1, kmax = 20) e ABC-IC*1 todos > 5 → *apoia subestimação*; todos ≤ 5 → *não apoia*; o resto é *misto*. Linhas com `no_veredito = FALSE` são reportadas e não decidem.

| estimador | variante | k_grade | r_hat | no_veredito |
|---|---|---|---|---|
| Bai-Ng IC1 | produção (BLL) | 1..20 |     5 | FALSE |
| Bai-Ng IC2 | produção (BLL) | 1..20 |     5 | FALSE |
| Bai-Ng IC3 | produção (BLL) | 1..20 |    20 | FALSE |
| AH ER | Teorema 1 | 1..20 |     2 | TRUE |
| AH GR | Teorema 1 | 1..20 |     2 | TRUE |
| ABC IC*1 | permutação principal | 0..20 |     9 | TRUE |
| ABC IC*2 | permutação principal | 0..20 |     9 | FALSE |
| AH ER | Corolário 1 (k = 0 admitido) | 0..20 |     2 | FALSE |
| AH GR | Corolário 1 (k = 0 admitido) | 0..20 |     2 | FALSE |
| AH ER | kmax2 = 11 | kmax2 = 11 |     2 | FALSE |
| AH GR | kmax2 = 11 | kmax2 = 11 |     2 | FALSE |
| AH ER | duplamente centrado | 1..20 |     2 | FALSE |
| AH GR | duplamente centrado | 1..20 |     2 | FALSE |
| factorselect 'ahn_horenstein' | pacote: é o GR divergente | 1..20 |     1 | FALSE |
| factorselect ER | pacote | 1..20 |     2 | FALSE |
| factorselect 'abc' (abc1) | pacote: moda sobre c em [0,1] | 0..20 |    20 | FALSE |
| factorselect abc2 | pacote: moda sobre c em [0,1] | 0..20 |    20 | FALSE |
| factorselect 'bai_ng' (IC1) | pacote | 0..20 |     5 | FALSE |

**Veredito: misto** (ER = 2, GR = 2, ABC-IC*1 = 9; Bai-Ng de produção IC1 = 5, IC2 = 5, IC3 = 20).

## Superfície por k

`mu` é ψ_k[X'X/(NT)] — em k = 0, o autovalor fictício V(0)/ln m da eq. (4) de AH; `V` é V(k) = Σ_{j>k} mu_j sobre o espectro inteiro. `_dd` é o painel duplamente centrado; `ER_pkg`/`GR_pkg` são os do `factorselect`, para comparação. IC1-IC3 são a superfície de produção, que não tem k = 0.

| k | mu | V | ER | GR | ER_dd | GR_dd | GR_pkg | IC1 | IC2 | IC3 |
|---|---|---|---|---|---|---|---|---|---|---|
|      0 | 0.20947 | 0.99394 | 1.4675 | 1.2335 | 1.5138 | 1.2757 |     NA |     NA |     NA |     NA |
|      1 | 0.14275 | 0.85119 | 1.4498 | 1.2612 | 1.4217 | 1.2413 | 1.4107 | -0.098903 | -0.091099 | -0.11986 |
|      2 | 0.098458 | 0.75273 |  1.474 | 1.3229 |  1.482 |  1.333 | 1.1665 | -0.15961 | -0.14401 | -0.20152 |
|      3 | 0.066795 | 0.68594 | 1.3117 | 1.2046 | 1.3544 | 1.2481 | 1.0794 | -0.19032 | -0.16691 | -0.25318 |
|      4 | 0.050924 | 0.63502 | 1.1463 | 1.0636 | 1.2739 | 1.1916 | 0.98375 | -0.20525 | -0.17404 | -0.28907 |
|      5 | 0.044425 | 0.59059 | 1.3457 | 1.2609 | 1.1044 | 1.0403 | 1.1662 | -0.21556 | -0.17655 | -0.32033 |
|      6 | 0.033013 | 0.55758 | 1.0907 | 1.0306 | 1.1065 | 1.0448 | 0.95466 | -0.21087 | -0.16405 | -0.33659 |
|      7 | 0.030268 | 0.52731 | 1.1226 | 1.0634 | 1.1182 | 1.0589 | 1.0016 | -0.20447 | -0.14985 | -0.35115 |
|      8 | 0.026962 | 0.50035 | 1.0589 | 1.0049 | 1.0803 | 1.0252 | 0.94438 | -0.19474 | -0.13231 | -0.36237 |
|      9 | 0.025461 | 0.47489 |  1.225 |  1.167 | 1.2078 | 1.1508 | 1.0849 | -0.18476 | -0.11453 | -0.37334 |
|     10 | 0.020785 | 0.4541 | 1.0375 | 0.99196 | 1.0612 |  1.015 | 0.91912 | -0.1673 | -0.089263 | -0.37684 |
|     11 | 0.020033 | 0.43407 | 1.1114 | 1.0638 | 1.0662 | 1.0206 | 0.99074 | -0.15021 | -0.064365 | -0.38069 |
|     12 | 0.018025 | 0.41604 |  1.005 | 0.96248 | 1.0043 | 0.96085 | 0.89206 | -0.13041 | -0.036761 | -0.38185 |
|     13 | 0.017936 | 0.39811 | 1.0311 | 0.98632 | 1.1004 | 1.0531 | 0.91215 | -0.11226 | -0.01081 | -0.38465 |
|     14 | 0.017395 | 0.38071 |  1.124 | 1.0766 | 1.0649 | 1.0207 | 0.97291 | -0.094724 | 0.014528 | -0.38807 |
|     15 | 0.015476 | 0.36524 | 1.0482 | 1.0057 |  1.038 | 0.99531 | 0.89503 | -0.074009 | 0.043047 | -0.38831 |
|     16 | 0.014764 | 0.35047 | 1.0456 | 1.0034 | 1.0507 | 1.0075 | 0.8863 | -0.053057 | 0.071803 | -0.38831 |
|     17 | 0.01412 | 0.33635 | 1.0095 | 0.96823 | 1.0467 | 1.0039 | 0.83895 | -0.031965 | 0.1007 | -0.38817 |
|     18 | 0.013986 | 0.32237 | 1.0484 | 1.0049 | 1.0261 | 0.98394 | 0.84083 | -0.012222 | 0.12825 | -0.38938 |
|     19 | 0.013341 | 0.30903 | 1.0592 | 1.0157 |  1.038 | 0.99486 | 0.79895 | 0.0077269 |  0.156 | -0.39039 |
|     20 | 0.012595 | 0.29643 | 1.0249 | 0.98276 | 1.0265 | 0.98342 | 0.7096 | 0.028329 | 0.1844 | -0.39074 |

## ABC: intervalos de estabilidade

Subamostras aninhadas n_j = 86..115 (J = 30) numa permutação fixa das colunas (seed 123), sem subamostra temporal; c ∈ (0, 5] com passo 0,01. Intervalo de estabilidade é uma sequência de c consecutivos com S_c = 0 e o mesmo r̂ na amostra cheia; o escolhido é o primeiro com r̂ < 20. `n_grid` é o número de pontos da grade no intervalo; o paper não fixa duração mínima.

| penalidade | r | c_lo | c_hi | n_grid |
|---|---|---|---|---|
| IC*1 |    20 |  0.01 |  0.66 |    66 |
| IC*1 |     9 |  0.74 |  0.75 |     2 |
| IC*1 |     5 |  0.93 |  1.03 |    11 |
| IC*1 |     0 |  2.57 |     5 |   244 |
| IC*2 |    20 |  0.01 |  0.59 |    59 |
| IC*2 |     9 |  0.66 |  0.68 |     3 |
| IC*2 |     5 |  0.83 |  0.93 |    11 |
| IC*2 |     0 |  2.29 |     5 |   272 |

IC*1: r̂ = 9 no intervalo c ∈ [0.74, 0.75]; primeiro intervalo em r_max = 20: sim; r̂ na amostra cheia em c = 5.00: 0.

IC*2: r̂ = 9 no intervalo c ∈ [0.66, 0.68]; primeiro intervalo em r_max = 20: sim; r̂ na amostra cheia em c = 5.00: 0.

### Sensibilidade à ordem das colunas: 100 permutações do mesmo fluxo de seed

| penalidade | r_hat | n |
|---|---|---|
| IC1 |     3 |     7 |
| IC1 |     4 |     1 |
| IC1 |     5 |    39 |
| IC1 |     6 |     1 |
| IC1 |     7 |     4 |
| IC1 |     8 |     2 |
| IC1 |     9 |    45 |
| IC1 |    11 |     1 |
| IC2 |     3 |     5 |
| IC2 |     4 |     2 |
| IC2 |     5 |    39 |
| IC2 |     6 |     4 |
| IC2 |     7 |     5 |
| IC2 |     9 |    45 |

## Auditoria numérica do `factorselect`

Pacote instalado @ `f0f08d5953488bf2c0db0aa8b341b16e5f28dc7c`, conferido por `packageDescription()`, rodado sobre o mesmo `yy` com `demean = "individual"` e `standardize = TRUE` (neutros sobre `yy`) e kmax = 20. É comparador, não estimativa.

| quantidade | pacote | paper | desvio_max |
|---|---|---|---|
| ER(k), k = 1..20: desvio relativo |    NA |    NA | 3.997e-15 |
| GR(k), k = 1..20: desvio relativo |    NA |    NA | 0.278 |
| argmax de ER |     2 |     2 |    NA |
| argmax de GR |     1 |     2 |    NA |
| GR do pacote contra mu_k / V_trunc(k - 2) |    NA |    NA | 1.998e-15 |
| IC1-IC3 do pacote contra a superfície de produção |    NA |    NA | 1.776e-15 |
| ABC com IC1: moda sobre c em [0,1] contra 2º intervalo |    20 |     9 |    NA |
| ABC com IC2: moda sobre c em [0,1] contra 2º intervalo |    20 |     9 |    NA |

Figura em `factor_selection_alt.pdf`.
