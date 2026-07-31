# Confound soberano no filtro JK — teste diario

*Gerado por `script/jk_sovereign_confound.R` em 2026-07-31. **Corpo gerado: nao escreva prosa aqui.** A leitura interpretativa vive em `relatorio/working-notes/2026-07-31_confound_soberano_jk.md`.*

## A pergunta

O filtro Jarocinski-Karadi descarta o confound benigno (efeito-informacao: juros sobem, acoes sobem) mas uma surpresa fiscal/soberana domestica tem juros para cima, acoes para baixo e cambio para cima — **exatamente o padrao que o filtro retem como "politica"**. Os placebos do paper nao descartam essa alternativa: um choque fiscal domestico tambem nao deveria mover o S&P 500.

## Regra de leitura, fixada antes de os numeros existirem

- Interacao `x:1(jk_bs)` positiva com `p_boot < 0,10` -> **contaminacao confirmada**.
- Interacao nula, mas efeito nos 62 dias significativo enquanto o controle nao-Copom e nulo -> **sinal fraco**; B e C decidem.
- Ambos nulos -> **confound nao detectado na frequencia diaria**.

**Veredito do teste A: CONFOUND NAO DETECTADO NA FREQUENCIA DIARIA.**

## Lacuna de dado declarada

**Nao ha CDS 5a diario** neste repositorio nem fonte programatica gratuita com historico 2013-2025 (Ipeadata encerrou o EMBI+ em 07/2024 e nunca teve CDS; WorldGovernmentBonds nao tem CSV/API; MacroMicro publica semanal; cbonds e pago). A unica fonte diaria e a pagina historica da Investing.com, via export de navegador. O **EMBI+ Brasil diario** e a proxy principal e cobre 95/95 quintas Copom e 94/95 quartas anteriores (o buraco e 2024-06-19, feriado americano).

## Qualidade das proxies diarias

| proxy | rotulo | n_copom | n_valid | sd |
|---|---|---|---|---|
| d_embi_bp | EMBI+ (bp, Qua->Qui) |    94 |   592 | 7.026 |
| d_embi_bp_lag1 | EMBI+ (bp, Qui->Sex, janela do dia SEGUINTE) |    95 |   597 | 6.666 |
| d_lbrl | BRL/USD (log x100, + = depreciacao) |    94 |   596 | 1.026 |
| d_slope_bp | Slope DI 504-63bd (bp) |    95 |   598 | 14.31 |
| d_di10y_bp | DI ~10a (bp) |    95 |   598 | 18.17 |

### Alinhamento do EMBI (pre-requisito de todo o teste A)

Correlacao da variacao diaria do EMBI com o movimento de mercado em `t`, `t-1` e `t+1`. Se o arquivo fosse publicado com um dia de defasagem, a coluna `t-1` dominaria.

| serie | cor_t | cor_tm1 | cor_tp1 |
|---|---|---|---|
| r_brl | 0.2254 | 0.08223 | 0.2103 |
| r_sp500 | -0.4977 | -0.04511 | 0.05986 |
| d_vix | 0.4132 | -0.007203 | -0.1093 |
| r_ibov | -0.5081 | -0.08816 | 0.01623 |

**Arquivo alinhado no mesmo dia: TRUE.** Logo a janela Qua->Qui e a medida correta, e a janela Qui->Sex **nao** e uma correcao de alinhamento: e uma janela do dia seguinte, ou seja a resposta *defasada* do risco a surpresa, e nao noticia de risco dentro da janela do evento.

## A — regressao diaria por conjunto de dias

`y ~ x`, HC1, `p_boot` por wild bootstrap sob a nula restrita. O conjunto **nao-Copom** e o controle: mede a comovimentacao diaria normal entre surpresa de juros e spread, que nao tem nada a ver com politica.

| proxy | conjunto | n | coef | se_hc1 | t | p_asym | p_boot | r2 |
|---|---|---|---|---|---|---|---|---|
| d_embi_bp | jk_bs (producao) |    61 | 0.09851 | 0.0565 | 1.744 | 0.08644 | 0.0965 | 0.03882 |
| d_embi_bp | copom (todos) |    94 | 0.06619 | 0.05002 | 1.323 | 0.189 | 0.1995 | 0.01651 |
| d_embi_bp | copom rejeitados |    33 | 0.01858 | 0.104 | 0.1787 | 0.8593 | 0.9075 | 0.001213 |
| d_embi_bp | nao-copom (controle) |   498 | 0.3264 | 0.08225 | 3.968 | 8.318e-05 | 0.0045 |  0.13 |
| d_embi_bp | jk (contemporaneo) |    64 | 0.07342 | 0.06343 | 1.158 | 0.2515 | 0.2645 | 0.01984 |
| d_embi_bp | jk_raw |    54 | 0.08676 | 0.05106 | 1.699 | 0.09528 | 0.1075 | 0.04138 |
| d_embi_bp | jk_us |    62 | 0.07936 | 0.06525 | 1.216 | 0.2287 | 0.2485 | 0.02458 |
| d_embi_bp_lag1 | jk_bs (producao) |    62 | 0.2192 | 0.07998 | 2.741 | 0.008056 | 0.0115 | 0.1425 |
| d_embi_bp_lag1 | copom (todos) |    95 | 0.1507 | 0.06328 | 2.381 | 0.0193 | 0.0275 | 0.07344 |
| d_embi_bp_lag1 | copom rejeitados |    33 | 0.01958 | 0.09135 | 0.2143 | 0.8317 | 0.819 | 0.001493 |
| d_embi_bp_lag1 | nao-copom (controle) |   502 | -0.0374 | 0.05739 | -0.6517 | 0.5149 | 0.6925 | 0.001972 |
| d_embi_bp_lag1 | jk (contemporaneo) |    65 | 0.1151 | 0.06275 | 1.834 | 0.07134 | 0.112 | 0.05232 |
| d_embi_bp_lag1 | jk_raw |    55 | 0.2095 | 0.0766 | 2.735 | 0.008456 | 0.014 | 0.1881 |
| d_embi_bp_lag1 | jk_us |    63 | 0.1108 | 0.06319 | 1.753 | 0.0846 | 0.121 | 0.05232 |
| d_lbrl | jk_bs (producao) |    61 | 0.004439 | 0.01111 | 0.3996 | 0.6909 | 0.7225 | 0.003051 |
| d_lbrl | copom (todos) |    94 | -0.004175 | 0.009441 | -0.4422 | 0.6594 | 0.6505 | 0.002608 |
| d_lbrl | copom rejeitados |    33 | -0.0189 | 0.01539 | -1.228 | 0.2285 | 0.2385 | 0.05119 |
| d_lbrl | nao-copom (controle) |   502 | 0.0506 | 0.01091 | 4.638 | 4.491e-06 | 0.005 | 0.1519 |
| d_lbrl | jk (contemporaneo) |    64 | 0.006255 | 0.01045 | 0.5984 | 0.5517 | 0.5875 | 0.006367 |
| d_lbrl | jk_raw |    55 | 0.002444 | 0.01074 | 0.2276 | 0.8208 | 0.8255 | 0.001149 |
| d_lbrl | jk_us |    62 | 0.006185 | 0.01042 | 0.5936 | 0.555 | 0.5685 | 0.006495 |
| d_slope_bp | jk_bs (producao) |    62 | 0.8015 | 0.2882 | 2.781 | 0.007226 | 0.001 | 0.3002 |
| d_slope_bp | copom (todos) |    95 | 0.6634 | 0.2249 |  2.95 | 0.004026 | 0.001 | 0.2383 |
| d_slope_bp | copom rejeitados |    33 | 0.3975 | 0.292 | 1.361 | 0.1832 | 0.186 | 0.122 |
| d_slope_bp | nao-copom (controle) |   503 | 1.138 | 0.09166 | 12.42 | 4.629e-31 |     0 | 0.4319 |
| d_slope_bp | jk (contemporaneo) |    65 | 0.8441 | 0.2685 | 3.143 | 0.002547 | 0.0005 | 0.3481 |
| d_slope_bp | jk_raw |    55 | 0.7601 | 0.2783 | 2.731 | 0.008556 | 0.0015 | 0.3132 |
| d_slope_bp | jk_us |    63 | 0.8454 | 0.2684 |  3.15 | 0.002529 | 0.0005 | 0.3542 |
| d_di10y_bp | jk_bs (producao) |    62 | 0.5728 | 0.2273 |  2.52 | 0.01443 | 0.019 | 0.1766 |
| d_di10y_bp | copom (todos) |    95 | 0.3179 | 0.1917 | 1.658 | 0.1006 | 0.1395 | 0.0617 |
| d_di10y_bp | copom rejeitados |    33 | -0.1573 | 0.2244 | -0.7009 | 0.4886 | 0.545 | 0.01992 |
| d_di10y_bp | nao-copom (controle) |   503 | 1.422 | 0.2168 | 6.558 | 1.359e-10 |     0 | 0.3687 |
| d_di10y_bp | jk (contemporaneo) |    65 | 0.5676 | 0.2099 | 2.704 | 0.008806 | 0.0165 | 0.192 |
| d_di10y_bp | jk_raw |    55 | 0.519 | 0.2189 | 2.371 | 0.02139 | 0.0325 | 0.1761 |
| d_di10y_bp | jk_us |    63 | 0.5669 | 0.2093 | 2.709 | 0.00875 | 0.015 | 0.1947 |

## A — interacao (a estatistica que decide)

`y ~ x + 1(jk_bs) + x:1(jk_bs)` sobre todas as quintas validas. Contaminacao exige que o dia retido carregue **mais** noticia de risco por unidade de surpresa que um dia comum.

| proxy | n | coef | se_hc1 | t | p_asym | p_boot |
|---|---|---|---|---|---|---|
| d_embi_bp |   592 | -0.182 | 0.09377 | -1.941 | 0.05274 | 0.108 |
| d_embi_bp_lag1 |   597 | 0.2476 | 0.09489 | 2.609 | 0.009316 | 0.0245 |
| d_lbrl |   596 | -0.03591 | 0.01653 | -2.173 | 0.03017 | 0.066 |
| d_slope_bp |   598 | -0.2277 | 0.3018 | -0.7544 | 0.4509 |  0.52 |
| d_di10y_bp |   598 | -0.6157 | 0.3268 | -1.884 | 0.06002 | 0.1125 |

## B — classificacao de tres vias

Politica: aperto **aprecia** o BRL (UIP) -> sinais de `e_di_bs` e `e_brl_bs` diferem. Soberano: surpresa fiscal **deprecia** -> sinais iguais. As pernas de FX e EMBI sao purificadas na **mesma** RHS pre-evento do Bauer-Swanson, para a mascara continuar predeterminada.

- regra FX: **31 politica**, 30 soberano, 1 nao classificado (de 62 retidos)
- regra EMBI: **24 politica**, 37 soberano, 1 nao classificado

Concordancia entre as duas regras (linhas = FX, colunas = EMBI):

| fx | soberano | n/c | politica |
|---|---|---|---|
| n/c |     1 |     0 |     0 |
| politica |    15 |     1 |    15 |
| soberano |    21 |     0 |     9 |

**Ressalvas.** (i) Condicionar a mascara num movimento cambial *contemporaneo* e o tipo de selecao same-window que a camada BS existe para evitar; `e_brl_bs` mitiga, nao elimina. (ii) A classe politica e menor, entao xi_mp cai por razao mecanica de tamanho de amostra e **tem que ser lido junto com o numero de meses nao-nulos**.

## C — instrumento ortogonalizado ao risco

`e_di_bs` residualizado no risco contemporaneo (d_embi_bp + d_lbrl): R2 = 0.1267.

**E um limite inferior.** Politica legitimamente move spread soberano, entao ortogonalizar contra o risco contemporaneo super-remove. Sobreviver e descarte forte do confound; nao sobreviver e ambiguo.

## Forca: xi_mp por variante

| amostra | instrumento | meses_nao_nulos | xi_mp | wald_conjunta | f_factor |
|---|---|---|---|---|---|
| full | z_jk_bs_purif |    62 | 10.43 | 13.99 | 6.313 |
| full | z_jk3_policy |    31 | 3.515 | 4.864 | 1.797 |
| full | z_jk3_sov |    30 | 3.499 | 6.639 | 4.954 |
| full | z_jk3_policy_em |    24 | 0.8928 |  5.91 |  2.13 |
| full | z_jk3_sov_em |    37 |  7.77 | 11.34 | 6.949 |
| full | z_jk_bs_norisk |    60 | 10.72 | 14.59 | 6.476 |
| pre_covid | z_jk_bs_purif |    31 | 12.22 | 16.22 | 3.093 |
| pre_covid | z_jk3_policy |    11 | 2.821 | 6.548 | 3.477 |
| pre_covid | z_jk3_sov |    19 | 7.142 | 12.68 | 4.946 |
| pre_covid | z_jk3_policy_em |     7 | 2.765 | 7.828 |   1.1 |
| pre_covid | z_jk3_sov_em |    24 | 11.54 | 15.98 |  2.62 |
| pre_covid | z_jk_bs_norisk |    30 | 8.177 |  11.2 | 2.224 |

## IRFs no impacto (h = 0)

| instrumento | variavel | ponto | lo68 | hi68 | lo90 | hi90 | sig90 |
|---|---|---|---|---|---|---|---|
| z_jk_bs_purif | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk_bs_purif | yield_2y | 0.009164 | 0.007811 | 0.01158 | 0.00713 | 0.01312 | TRUE |
| z_jk_bs_purif | yield_5y | 0.009274 | 0.007785 | 0.01278 | 0.006864 | 0.01499 | TRUE |
| z_jk_bs_purif | cambio_usd | 0.1498 | 0.1072 | 0.2292 | 0.07881 | 0.2971 | TRUE |
| z_jk_bs_purif | embi_perc | 0.1995 | 0.1372 | 0.3814 | 0.07767 | 0.5089 | TRUE |
| z_jk_bs_purif | cds_5y | 29.07 |  22.3 | 48.16 | 16.52 | 62.51 | TRUE |
| z_jk_bs_purif | asset_ibov | -1.673 | -5.429 | 0.3111 | -7.771 | 1.759 | FALSE |
| z_jk_bs_purif | price_ipca | -0.07025 | -0.2237 | 0.06013 | -0.3708 | 0.1428 | FALSE |
| z_jk_bs_purif | price_ipp | 0.5859 | 0.3746 | 0.9366 | 0.2099 | 1.172 | TRUE |
| z_jk3_policy | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk3_policy | yield_2y | 0.008519 | 0.006863 | 0.01098 | 0.005805 | 0.01315 | TRUE |
| z_jk3_policy | yield_5y | 0.007935 | 0.005821 | 0.01171 | 0.0042 | 0.01503 | TRUE |
| z_jk3_policy | cambio_usd | 0.1289 | 0.04758 | 0.2403 | -0.009624 | 0.4033 | FALSE |
| z_jk3_policy | embi_perc | 0.1028 | -0.007987 | 0.328 | -0.1602 | 0.5111 | FALSE |
| z_jk3_policy | cds_5y | 18.94 | 6.645 | 42.34 | -6.527 | 61.21 | FALSE |
| z_jk3_policy | asset_ibov | 1.524 | -4.462 |  5.63 | -8.747 |  11.8 | FALSE |
| z_jk3_policy | price_ipca | -0.1126 | -0.446 | 0.09922 | -0.9939 | 0.2563 | FALSE |
| z_jk3_policy | price_ipp | 0.3817 | -0.0433 | 0.8572 | -0.4368 |  1.29 | FALSE |
| z_jk3_sov | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk3_sov | yield_2y | 0.009635 | 0.008218 | 0.01241 | 0.007355 | 0.01549 | TRUE |
| z_jk3_sov | yield_5y | 0.01025 | 0.008615 | 0.01434 | 0.007438 | 0.01898 | TRUE |
| z_jk3_sov | cambio_usd | 0.1649 | 0.1153 | 0.2738 | 0.08084 | 0.3923 | TRUE |
| z_jk3_sov | embi_perc | 0.2701 | 0.1947 | 0.5167 | 0.1179 | 0.7287 | TRUE |
| z_jk3_sov | cds_5y | 36.45 | 28.37 | 63.07 | 21.33 |  85.5 | TRUE |
| z_jk3_sov | asset_ibov | -4.004 | -8.397 | -1.889 | -12.6 | 0.04504 | FALSE |
| z_jk3_sov | price_ipca | -0.03937 | -0.2194 | 0.1281 | -0.3777 | 0.237 | FALSE |
| z_jk3_sov | price_ipp | 0.7348 | 0.505 | 1.195 | 0.3126 | 1.664 | TRUE |
| z_jk_bs_norisk | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk_bs_norisk | yield_2y | 0.008906 | 0.007584 | 0.01126 | 0.006899 | 0.01258 | TRUE |
| z_jk_bs_norisk | yield_5y | 0.008786 | 0.007308 | 0.01213 | 0.006462 | 0.01431 | TRUE |
| z_jk_bs_norisk | cambio_usd | 0.1453 | 0.1022 | 0.2244 | 0.07555 | 0.2936 | TRUE |
| z_jk_bs_norisk | embi_perc | 0.1624 | 0.1066 | 0.3431 | 0.0489 | 0.4575 | TRUE |
| z_jk_bs_norisk | cds_5y | 25.56 | 19.27 | 44.37 | 13.49 | 57.84 | TRUE |
| z_jk_bs_norisk | asset_ibov | -0.3634 | -4.143 | 1.643 | -6.119 | 3.642 | FALSE |
| z_jk_bs_norisk | price_ipca | -0.07776 | -0.2246 | 0.05953 | -0.3944 | 0.1441 | FALSE |
| z_jk_bs_norisk | price_ipp | 0.5436 | 0.3246 | 0.8981 | 0.1617 | 1.143 | TRUE |

Trajetorias completas em `jk_sovereign_irf_overlay.pdf`; celulas em `jk_sovereign_confound.csv`.

## D — auditoria narrativa

`jk_sovereign_days.csv`: 95 dias Copom com surpresa, residuos, variacao de risco Qua->Qui, classe de tres vias e peso no |z| do mes e da amostra, ordenados por alavancagem. A coluna `nota_evento` esta vazia para anotacao.

