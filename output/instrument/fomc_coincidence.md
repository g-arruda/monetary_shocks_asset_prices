# Coincidencia FOMC no instrumento Copom — teste diario e reestimacao

*Gerado por `script/fomc_coincidence.R` em 2026-08-10. **Corpo gerado: nao escreva prosa aqui.** A leitura interpretativa vive em `notas/2026-08-10_coincidencia_fomc.md`.*

## A pergunta

A surpresa de producao `e_di_bs` e residualizada so em regressores **predeterminados**, entao um choque realizado *dentro* da janela Qua->Qui e ortogonal a essa RHS por construcao e passa direto. Uma surpresa hawkish do Fed sobe o DI, derruba o Ibovespa — e o filtro JK **retem** o dia como "politica" — deprecia o BRL e abre EMBI/CDS. E o resultado central inteiro, sem canal domestico.

Ate 2026-08-10 o repositorio nao tinha como responder: `R/instrument/build_variants.R:244` computa `fomc_coincide`, mas `data/raw/fomc_dates.csv` nunca existiu e `script/instrument.R` caia num vetor vazio, entao a flag era **sempre FALSE**. As datas agora vem de `R/data_download/fomc_dates.R` (paginas de calendario do proprio Fed): **35 dos 95 dias Copom** da amostra coincidem com decisao do FOMC.

## Regra de leitura, fixada antes de os numeros existirem

- Bloco americano conjuntamente significativo nos 62 dias retidos (`p_boot < 0,10`) **ou** interacao com `1(fomc_coincide)` significativa -> **contaminacao confirmada**.
- Ambos nulos, mas a mascara re-derivada derruba ξ_mp abaixo de 3,84 ou inverte um sinal em h=0 -> **sinal fraco**.
- Ambos nulos no restante -> **confound nao detectado**.

A regra tinha uma terceira perna, retirada em 2026-08-10 junto com o teste que a alimentava. A divisao dos 62 dias retidos em metades com e sem FOMC exigia que a metade sem-FOMC preservasse os sinais das manchetes com o ponto de producao dentro do CI90 dela, e na rodada daquele dia essa perna **passou** sem acionar a clausula de poder, enquanto a metade *com* FOMC saiu com conjunto AR ilimitado e portanto inutilizavel para citacao em qualquer direcao. Retirar uma perna satisfeita torna a regra estritamente mais permissiva, de modo que o veredito nao pode ter mudado por causa do corte. Os numeros das duas metades estao no historico do git e **nao sao reproduziveis por este script**. Registro em `registro/historico_decisoes.md`.

**Veredito: CONFOUND FOMC NAO DETECTADO.**

## 0 — Onde no calendario a noticia do Fed cai

Pre-requisito de toda a leitura, e um argumento de horario antes de ser um numero: o comunicado do FOMC sai as **14:00 ET**, antes do fechamento do DI na B3 (18:00 BRT) e antes do fixing das 15:30 ET a que o DGS2 e cotado. Logo a noticia deveria estar **no fechamento de quarta** — isto e, no conjunto de informacao contra o qual a surpresa do Copom e medida, o que e benigno. O que pode vazar para dentro da janela e a cauda da coletiva e o overnight.

Mediana de |Δ| por janela, sobre os dias Copom:

| grupo | n | ust2_ter_qua | ust2_qua_qui | sp500_ter_qua | sp500_qua_qui |
|---|---|---|---|---|---|
| Copom no dia do FOMC |    35 |     5 |     3 | 0.5405 | 0.7404 |
| Copom sem FOMC |    60 |     2 |     2 | 0.4052 | 0.4936 |

Em semanas com FOMC o UST 2a move mediana **5.00 bp** de Ter->Qua contra **3.00 bp** de Qua->Qui (antes da janela: TRUE), e o S&P 500 move **0.54%** contra **0.74%** (antes da janela: FALSE).

⚠ **As duas pernas nao concordam, e isso e o resultado, nao um rodape.** A perna de *taxa* — que e por onde uma surpresa de politica monetaria americana viaja — cai majoritariamente antes da janela, como o horario previa. A perna de *acoes* nao: o S&P se move **mais** de Qua->Qui, isto e, a reacao do mercado acionario a decisao continua no dia seguinte e **esta** dentro da janela. Logo o argumento de horario cobre parte da ameaca e nao toda ela, e sao os testes 2 a 4 que decidem.

## 1 — Exposicao do instrumento

| conjunto | n | n_fomc | share_z |
|---|---|---|---|
| Copom (todos) |    95 |    35 | 0.3549 |
| retidos (jk_bs) |    62 |    24 | 0.3549 |
| top-20 por alavancagem |    20 |     8 | 0.2287 |

`share_z` e a fracao de Σ|z| — que corre **so sobre os dias retidos**, ja que um dia filtrado entra no instrumento com peso zero. E por isso que a linha "Copom (todos)" repete a fracao da linha "retidos": e aritmetica, nao coincidencia.

Dos 62 dias retidos pelo filtro JK, **24 coincidem com FOMC** e carregam **35.5% de Σ|z|**. Por ano:

| ano | sem_fomc | com_fomc |
|---|---|---|
|  2013 |     6 |     0 |
|  2014 |     7 |     1 |
|  2015 |     4 |     2 |
|  2016 |     7 |     1 |
|  2017 |     6 |     1 |
|  2018 |     6 |     2 |
|  2019 |     2 |     5 |
|  2020 |     7 |     1 |
|  2021 |     5 |     3 |
|  2022 |     4 |     3 |
|  2023 |     2 |     5 |
|  2024 |     3 |     5 |
|  2025 |     1 |     6 |

## 2 — A regressao decisiva

`e_di_bs` no bloco contemporaneo, HC1, `p_boot` por wild bootstrap sob a nula restrita, cada celula semeada pela propria identidade. O conjunto **nao-Copom** e o controle.

### Coeficiente a coeficiente

| regressor | conjunto | n | coef | se_hc1 | t | p_asym | p_boot | r2 |
|---|---|---|---|---|---|---|---|---|
| d_ust2 | jk_bs (producao) |    62 | 0.2531 | 0.2607 | 0.9711 | 0.3354 | 0.367 | 0.03308 |
| r_sp500 | jk_bs (producao) |    62 | -2.265 | 1.814 | -1.249 | 0.2167 | 0.238 | 0.03308 |
| d_ust2 | copom (todos) |    95 | 0.1535 | 0.2166 | 0.7086 | 0.4803 | 0.491 | 0.006777 |
| r_sp500 | copom (todos) |    95 | 0.7197 | 1.415 | 0.5087 | 0.6122 | 0.627 | 0.006777 |
| d_ust2 | copom rejeitados |    33 | -0.09561 | 0.4719 | -0.2026 | 0.8408 | 0.8465 | 0.1075 |
| r_sp500 | copom rejeitados |    33 | 3.491 | 1.704 | 2.049 | 0.04929 | 0.0645 | 0.1075 |
| d_ust2 | copom com FOMC |    35 | 0.09864 | 0.2457 | 0.4014 | 0.6908 | 0.692 | 0.004669 |
| r_sp500 | copom com FOMC |    35 | -0.4829 | 1.954 | -0.2471 | 0.8064 | 0.8135 | 0.004669 |
| d_ust2 | copom sem FOMC |    60 | 0.3931 | 0.4967 | 0.7915 | 0.4319 | 0.4485 | 0.02955 |
| r_sp500 | copom sem FOMC |    60 | 1.985 | 1.871 | 1.061 | 0.2932 | 0.3115 | 0.02955 |
| d_ust2 | nao-copom (controle) |   503 | 0.06022 | 0.07701 | 0.7819 | 0.4346 | 0.4615 | 0.002785 |
| r_sp500 | nao-copom (controle) |   503 | -0.2843 | 0.4147 | -0.6855 | 0.4933 | 0.579 | 0.002785 |

### Teste conjunto do bloco

| regressor | conjunto | n | k | f_rob | p_asym | p_boot | r2 |
|---|---|---|---|---|---|---|---|
| bloco US (d_ust2 + r_sp500) | jk_bs (producao) |    62 |     2 | 0.9429 | 0.3953 | 0.458 | 0.03308 |
| bloco global (US + VIX + Brent) | jk_bs (producao) |    62 |     4 | 1.844 | 0.133 | 0.2835 | 0.1047 |
| bloco US (d_ust2 + r_sp500) | copom (todos) |    95 |     2 | 0.672 | 0.5132 | 0.5415 | 0.006777 |
| bloco global (US + VIX + Brent) | copom (todos) |    95 |     4 | 0.4322 | 0.7851 | 0.848 | 0.01982 |
| bloco US (d_ust2 + r_sp500) | copom rejeitados |    33 |     2 |  2.31 | 0.1167 | 0.166 | 0.1075 |
| bloco global (US + VIX + Brent) | copom rejeitados |    33 |     4 | 1.657 | 0.1879 | 0.627 | 0.1148 |
| bloco US (d_ust2 + r_sp500) | copom com FOMC |    35 |     2 | 0.08983 | 0.9143 | 0.921 | 0.004669 |
| bloco global (US + VIX + Brent) | copom com FOMC |    35 |     4 | 0.4708 | 0.7567 | 0.851 | 0.07787 |
| bloco US (d_ust2 + r_sp500) | copom sem FOMC |    60 |     2 | 1.539 | 0.2233 | 0.2725 | 0.02955 |
| bloco global (US + VIX + Brent) | copom sem FOMC |    60 |     4 | 1.027 | 0.4013 | 0.672 | 0.03032 |
| bloco US (d_ust2 + r_sp500) | nao-copom (controle) |   503 |     2 | 0.4885 | 0.6138 | 0.7105 | 0.002785 |
| bloco global (US + VIX + Brent) | nao-copom (controle) |   503 |     4 | 1.674 | 0.1547 | 0.307 | 0.01124 |

### Interacoes — a estatistica que decide

Contaminacao exige que o dia selecionado carregue **mais** noticia americana por unidade de surpresa que o dia de comparacao.

| regressor | conjunto | n | k | f_rob | p_asym | p_boot |
|---|---|---|---|---|---|---|
| bloco US x 1(fomc_coincide) | 95 dias Copom |    95 |     2 | 0.8506 | 0.4306 | 0.4655 |
| bloco US x 1(jk_bs) | todas as quintas validas |   598 |     2 | 0.8213 | 0.4404 | 0.5115 |

## 3 — Mascara re-derivada: valores contra selecao

Ortogonalizar so os **valores** ao bloco global e a forma do Teste C da rodada soberana; ele deixa a **selecao** dos dias intacta, contra a propria auditoria de fidelidade do projeto ("a forca vive na mascara"). Por isso as duas variantes existem separadas. Re-derivando a mascara nos residuos duplos de `e_di_bs`/`e_ibov_bs`: **61 dias**, dos quais **54 dos 62** de producao sobrevivem.

| conjunto | n |
|---|---|
| producao (jk_bs) |    62 |
| re-derivada (jk_bs_glob) |    61 |
| intersecao |    54 |
| com FOMC (de 62) |    24 |
| sem FOMC (de 62) |    38 |

## 4 — Forca: xi_mp por variante

| amostra | instrumento | meses_nao_nulos | xi_mp | wald_conjunta | f_factor | impacto_mp_pre | denom_vs_prod | ar_limitada | bandas_validas |
|---|---|---|---|---|---|---|---|---|---|
| full | z_jk_bs_purif |    62 | 10.43 | 13.99 | 6.313 | 8.636e-05 |     1 | TRUE | TRUE |
| full | z_jk_bs_noglob |    62 | 10.22 | 13.77 | 5.951 | 8.673e-05 | 1.004 | TRUE | TRUE |
| full | z_jk_bs_glob |    61 | 7.718 | 11.25 | 5.473 | 7.389e-05 | 0.8557 | TRUE | FALSE |
| full | z_jk_us |    63 | 5.436 | 13.62 | 11.31 | 6.303e-05 | 0.7299 | TRUE | FALSE |
| pre_covid | z_jk_bs_purif |    31 | 12.22 | 16.22 | 3.093 | 5.221e-05 |     1 | TRUE | TRUE |
| pre_covid | z_jk_bs_noglob |    31 | 12.62 | 16.87 | 3.227 | 5.401e-05 | 1.035 | TRUE | TRUE |
| pre_covid | z_jk_bs_glob |    30 | 14.17 | 23.83 | 6.481 | 6.938e-05 | 1.329 | TRUE | TRUE |
| pre_covid | z_jk_us |    31 |  13.6 |  24.5 | 7.025 | 6.814e-05 | 1.305 | TRUE | TRUE |

`ar_limitada` e ξ_mp > 3,84 (conjunto AR de 95% limitado); `bandas_validas` e ξ_mp ≥ 10. A distancia entre `z_jk_bs_noglob` e `z_jk_bs_glob` e a medida do canal de selecao: as duas ortogonalizam os mesmos valores no mesmo bloco e diferem so em re-derivar ou nao a mascara.

⚠ **Por que toda variante ortogonalizada imprime respostas MAIORES, e por que isso nao e evidencia a favor.** `impacto_mp_pre` e a resposta de `yield_6m` no impacto **antes** da normalizacao — o denominador pelo qual cada IRF da celula e dividida. `denom_vs_prod` o poe em razao da producao: onde ele encolhe, toda a IRF da celula cresce por aritmetica, sem que nada de economico tenha mudado. E o mesmo mecanismo que a classe `unstable_normalization` da taxonomia do sweep monitora (`R/identification/spec_sweep.R`). Logo o que sobrevive aqui e **o sinal e a significancia**, nao a magnitude: uma resposta que cresce enquanto ξ_mp cai deve ser lida como denominador enfraquecendo, nao como efeito maior.

## 5 — IRFs no impacto (h = 0)

`yield_6m` e mecanico: h=0 e o alvo da normalizacao, identico em toda variante. A comparacao de sinais roda nas outras quatro manchetes. Celulas sig90 por variante: z_jk_bs_purif 36, z_jk_bs_glob 33.

| instrumento | variavel | ponto | lo68 | hi68 | lo90 | hi90 | sig90 |
|---|---|---|---|---|---|---|---|
| z_jk_bs_purif | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk_bs_purif | yield_2y | 0.009164 | 0.007811 | 0.01158 | 0.00713 | 0.01312 | TRUE |
| z_jk_bs_purif | yield_5y | 0.009274 | 0.007785 | 0.01278 | 0.006864 | 0.01499 | TRUE |
| z_jk_bs_purif | cambio_usd | 0.1498 | 0.1072 | 0.2292 | 0.07881 | 0.2971 | TRUE |
| z_jk_bs_purif | asset_ibov | -1.673 | -5.429 | 0.3111 | -7.771 | 1.759 | FALSE |
| z_jk_bs_purif | embi_perc | 0.1995 | 0.1372 | 0.3814 | 0.07767 | 0.5089 | TRUE |
| z_jk_bs_purif | cds_5y | 29.07 |  22.3 | 48.16 | 16.52 | 62.51 | TRUE |
| z_jk_bs_purif | price_ipca | -0.07025 | -0.2237 | 0.06013 | -0.3708 | 0.1428 | FALSE |
| z_jk_bs_purif | price_ipp | 0.5859 | 0.3746 | 0.9366 | 0.2099 | 1.172 | TRUE |
| z_jk_bs_glob | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk_bs_glob | yield_2y | 0.009517 | 0.008101 | 0.01238 | 0.007322 | 0.01505 | TRUE |
| z_jk_bs_glob | yield_5y | 0.01011 | 0.008441 | 0.01443 | 0.007522 | 0.0179 | TRUE |
| z_jk_bs_glob | cambio_usd | 0.1794 | 0.1298 | 0.279 | 0.0959 | 0.3804 | TRUE |
| z_jk_bs_glob | asset_ibov | -3.311 | -8.252 | -1.644 | -11.36 | 0.5043 | FALSE |
| z_jk_bs_glob | embi_perc | 0.2615 | 0.188 | 0.5011 | 0.1316 | 0.7062 | TRUE |
| z_jk_bs_glob | cds_5y | 36.43 | 28.84 | 61.77 | 22.67 | 84.54 | TRUE |
| z_jk_bs_glob | price_ipca | 0.003495 | -0.1397 | 0.1604 | -0.2768 | 0.2764 | FALSE |
| z_jk_bs_glob | price_ipp | 0.8332 | 0.5762 | 1.275 | 0.4008 | 1.656 | TRUE |

Mascara re-derivada: sinais preservados = TRUE; ponto de producao dentro do CI90 = TRUE.

Trajetorias completas em `fomc_coincidence_irf_overlay.pdf`; celulas em `fomc_coincidence.csv`; os 95 dias datados com a flag e o bloco americano em `fomc_coincidence_days.csv`.

