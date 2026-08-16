# Confound soberano no filtro JK — teste diario

*Gerado por `script/jk_sovereign_confound.R` em 2026-08-13. **Corpo gerado: nao escreva prosa aqui.** A leitura interpretativa vive em `notas/2026-08-09_confound_soberano_cds.md` (rodada das duas proxies) e `2026-07-31_confound_soberano_jk.md` (rodada original, so EMBI).*

## A pergunta

O filtro Jarocinski-Karadi descarta o confound benigno (efeito-informacao: juros sobem, acoes sobem) mas uma surpresa fiscal/soberana domestica tem juros para cima, acoes para baixo e cambio para cima — **exatamente o padrao que o filtro retem como "politica"**. Os placebos do paper nao descartam essa alternativa: um choque fiscal domestico tambem nao deveria mover o S&P 500.

## Regra de leitura, fixada antes de os numeros existirem

- Interacao `x:1(jk_bs)` positiva com `p_boot < 0,10` -> **contaminacao confirmada**.
- Interacao nula, mas efeito nos 62 dias significativo enquanto o controle nao-Copom e nulo -> **sinal fraco**; C decide.
- Ambos nulos -> **confound nao detectado na frequencia diaria**.

**Veredito em EMBI+ (pre-registrado): CONFOUND NAO DETECTADO NA FREQUENCIA DIARIA.**
**Veredito em CDS 5a (mesma regra, proxy principal): CONFOUND NAO DETECTADO NA FREQUENCIA DIARIA.**

Os dois vereditos coincidem.

## As duas proxies, e a ordem de olhar

Ate 2026-08-09 este teste rodava so em **EMBI+** porque nao havia CDS 5a diario no repositorio. `data/raw/CDS 5y.xlsx` (Bloomberg, `BRAZIL CDS USD SR 5Y D14 Corp`, diario 2001-10 a 2026-08) fechou a lacuna, e e o melhor instrumento de medida: cobre **95/95** pares Qua->Qui de Copom contra 94/95 do EMBI (o buraco e 2024-06-19, feriado americano), e **0.5%** das suas variacoes no painel de eventos sao exatamente zero contra **8.3%** do EMBI.

Esse ultimo numero e o que importa. O EMBI+ e publicado com duas casas em pontos percentuais, entao a menor variacao nao-nula que ele consegue exprimir e **1.000 bp**, contra **0.005 bp** do CDS: noticia de risco menor que isso e arredondada a nada. Isso **atenua o coeficiente do teste A em direcao a zero** e tornaria um nulo ali descartavel como erro de medida. O nulo do CDS nao e descartavel assim — e a tabela de alinhamento abaixo mostra o mesmo por outro lado, com o CDS correlacionando mais forte com o mercado no mesmo dia em todas as quatro series.

**A ordem de olhar, declarada:** o EMBI foi olhado primeiro e a regra de leitura acima foi fixada antes dos numeros dele. O CDS chegou depois e e julgado pela **mesma funcao** (`verdict_for()`), sem regra nova. O veredito do EMBI acima e exatamente o de 2026-07-31, inalterado.

## Qualidade das proxies diarias

| proxy | rotulo | n_copom | n_valid | sd | pct_zero |
|---|---|---|---|---|---|
| d_cds_bp | CDS 5a (bp, Qua->Qui) |    95 |   598 | 7.319 | 0.5017 |
| d_embi_bp | EMBI+ (bp, Qua->Qui) |    94 |   592 | 7.026 | 8.277 |
| d_cds_bp_lag1 | CDS 5a (bp, Qui->Sex, janela do dia SEGUINTE) |    95 |   598 | 5.795 |     0 |
| d_embi_bp_lag1 | EMBI+ (bp, Qui->Sex, janela do dia SEGUINTE) |    95 |   597 | 6.666 | 11.22 |
| d_lbrl | BRL/USD (log x100, + = depreciacao) |    94 |   596 | 1.026 | 0.1678 |
| d_slope_bp | Slope DI 504-63bd (bp) |    95 |   598 | 14.31 | 1.338 |
| d_di10y_bp | DI ~10a (bp) |    95 |   598 | 18.17 | 3.679 |

### Alinhamento (pre-requisito de todo o teste A)

Correlacao da variacao diaria de cada proxy com o movimento de mercado em `t`, `t-1` e `t+1`. Se um arquivo fosse publicado com um dia de defasagem, a coluna `t-1` dominaria — e a janela Qua->Qui deixaria de medir o que se pretende.

| proxy | serie | cor_t | cor_tm1 | cor_tp1 |
|---|---|---|---|---|
| CDS 5a | r_brl | 0.3025 | 0.06631 | 0.2576 |
| CDS 5a | r_sp500 | -0.5412 | -0.03995 | 0.06586 |
| CDS 5a | d_vix | 0.443 | -0.007147 | -0.11 |
| CDS 5a | r_ibov | -0.5797 | -0.08863 | 0.03404 |
| EMBI+ | r_brl | 0.2254 | 0.08223 | 0.2103 |
| EMBI+ | r_sp500 | -0.4977 | -0.04511 | 0.05986 |
| EMBI+ | d_vix | 0.4132 | -0.007203 | -0.1093 |
| EMBI+ | r_ibov | -0.5081 | -0.08816 | 0.01623 |

**Alinhados no mesmo dia: CDS TRUE, EMBI TRUE.** Logo a janela Qua->Qui e a medida correta, e a janela Qui->Sex **nao** e uma correcao de alinhamento: e uma janela do dia seguinte, ou seja a resposta *defasada* do risco a surpresa, e nao noticia de risco dentro da janela do evento.

## A — regressao diaria por conjunto de dias

`y ~ x`, HC1, `p_boot` por wild bootstrap sob a nula restrita. O conjunto **nao-Copom** e o controle: mede a comovimentacao diaria normal entre surpresa de juros e spread, que nao tem nada a ver com politica.

**Reprodutibilidade dos `p_boot`.** Desde 2026-08-09 cada celula e semeada pela propria identidade (`wild_coef_test(key = )`), entao acrescentar ou reordenar proxies nao move o `p_boot` de nenhuma outra. Antes disso todas compartilhavam um unico fluxo de RNG, e por isso os `p_boot` da nota de 07-31 diferem destes por ruido de Monte Carlo (erro-padrao ~0,007 com 2.000 sorteios). As estatisticas **deterministicas** — coeficiente, erro-padrao HC1, `t`, R² — reproduzem exatas, e sao elas que carregam o argumento: o que decide o veredito e o **sinal** da interacao.

| proxy | conjunto | n | coef | se_hc1 | t | p_asym | p_boot | r2 |
|---|---|---|---|---|---|---|---|---|
| d_cds_bp | jk_bs (producao) |    62 | 0.1403 | 0.04898 | 2.864 | 0.005757 | 0.0025 | 0.1037 |
| d_cds_bp | copom (todos) |    95 | -0.004141 | 0.06505 | -0.06366 | 0.9494 | 0.963 | 5.439e-05 |
| d_cds_bp | copom rejeitados |    33 | -0.2846 | 0.1628 | -1.748 | 0.09043 | 0.0095 | 0.1511 |
| d_cds_bp | nao-copom (controle) |   503 | 0.4358 | 0.1001 | 4.353 | 1.629e-05 |     0 | 0.2176 |
| d_cds_bp | jk (contemporaneo) |    65 | 0.002681 | 0.09038 | 0.02966 | 0.9764 | 0.986 | 1.824e-05 |
| d_cds_bp | jk_raw |    55 | 0.1303 | 0.0443 |  2.94 | 0.004856 | 0.0005 | 0.1056 |
| d_cds_bp | jk_us |    63 | -0.002374 | 0.09454 | -0.02511 |  0.98 | 0.994 | 1.437e-05 |
| d_embi_bp | jk_bs (producao) |    61 | 0.09851 | 0.0565 | 1.744 | 0.08644 | 0.1085 | 0.03882 |
| d_embi_bp | copom (todos) |    94 | 0.06619 | 0.05002 | 1.323 | 0.189 | 0.1775 | 0.01651 |
| d_embi_bp | copom rejeitados |    33 | 0.01858 | 0.104 | 0.1787 | 0.8593 | 0.8985 | 0.001213 |
| d_embi_bp | nao-copom (controle) |   498 | 0.3264 | 0.08225 | 3.968 | 8.318e-05 | 0.003 |  0.13 |
| d_embi_bp | jk (contemporaneo) |    64 | 0.07342 | 0.06343 | 1.158 | 0.2515 | 0.2415 | 0.01984 |
| d_embi_bp | jk_raw |    54 | 0.08676 | 0.05106 | 1.699 | 0.09528 | 0.1195 | 0.04138 |
| d_embi_bp | jk_us |    62 | 0.07936 | 0.06525 | 1.216 | 0.2287 | 0.233 | 0.02458 |
| d_cds_bp_lag1 | jk_bs (producao) |    62 | 0.131 | 0.06074 | 2.157 | 0.03499 | 0.061 | 0.08416 |
| d_cds_bp_lag1 | copom (todos) |    95 | 0.07652 | 0.04681 | 1.635 | 0.1055 | 0.135 | 0.03198 |
| d_cds_bp_lag1 | copom rejeitados |    33 | -0.02983 | 0.07265 | -0.4106 | 0.6842 | 0.6925 | 0.006248 |
| d_cds_bp_lag1 | nao-copom (controle) |   503 | -0.06448 | 0.06064 | -1.063 | 0.2882 | 0.4505 | 0.007505 |
| d_cds_bp_lag1 | jk (contemporaneo) |    65 | 0.07894 | 0.05184 | 1.523 | 0.1328 | 0.1875 | 0.03663 |
| d_cds_bp_lag1 | jk_raw |    55 | 0.1219 | 0.05787 | 2.107 | 0.03984 | 0.077 | 0.09407 |
| d_cds_bp_lag1 | jk_us |    63 | 0.07795 | 0.05213 | 1.495 |  0.14 | 0.1705 | 0.0356 |
| d_embi_bp_lag1 | jk_bs (producao) |    62 | 0.2192 | 0.07998 | 2.741 | 0.008056 | 0.019 | 0.1425 |
| d_embi_bp_lag1 | copom (todos) |    95 | 0.1507 | 0.06328 | 2.381 | 0.0193 | 0.026 | 0.07344 |
| d_embi_bp_lag1 | copom rejeitados |    33 | 0.01958 | 0.09135 | 0.2143 | 0.8317 | 0.8425 | 0.001493 |
| d_embi_bp_lag1 | nao-copom (controle) |   502 | -0.0374 | 0.05739 | -0.6517 | 0.5149 | 0.679 | 0.001972 |
| d_embi_bp_lag1 | jk (contemporaneo) |    65 | 0.1151 | 0.06275 | 1.834 | 0.07134 | 0.1125 | 0.05232 |
| d_embi_bp_lag1 | jk_raw |    55 | 0.2095 | 0.0766 | 2.735 | 0.008456 | 0.012 | 0.1881 |
| d_embi_bp_lag1 | jk_us |    63 | 0.1108 | 0.06319 | 1.753 | 0.0846 | 0.115 | 0.05232 |
| d_lbrl | jk_bs (producao) |    61 | 0.004439 | 0.01111 | 0.3996 | 0.6909 | 0.722 | 0.003051 |
| d_lbrl | copom (todos) |    94 | -0.004175 | 0.009441 | -0.4422 | 0.6594 |  0.68 | 0.002608 |
| d_lbrl | copom rejeitados |    33 | -0.0189 | 0.01539 | -1.228 | 0.2285 | 0.2355 | 0.05119 |
| d_lbrl | nao-copom (controle) |   502 | 0.0506 | 0.01091 | 4.638 | 4.491e-06 | 0.0055 | 0.1519 |
| d_lbrl | jk (contemporaneo) |    64 | 0.006255 | 0.01045 | 0.5984 | 0.5517 | 0.5905 | 0.006367 |
| d_lbrl | jk_raw |    55 | 0.002444 | 0.01074 | 0.2276 | 0.8208 | 0.8435 | 0.001149 |
| d_lbrl | jk_us |    62 | 0.006185 | 0.01042 | 0.5936 | 0.555 | 0.5765 | 0.006495 |
| d_slope_bp | jk_bs (producao) |    62 | 0.8015 | 0.2882 | 2.781 | 0.007226 | 0.0025 | 0.3002 |
| d_slope_bp | copom (todos) |    95 | 0.6634 | 0.2249 |  2.95 | 0.004026 | 0.001 | 0.2383 |
| d_slope_bp | copom rejeitados |    33 | 0.3975 | 0.292 | 1.361 | 0.1832 | 0.198 | 0.122 |
| d_slope_bp | nao-copom (controle) |   503 | 1.138 | 0.09166 | 12.42 | 4.629e-31 |     0 | 0.4319 |
| d_slope_bp | jk (contemporaneo) |    65 | 0.8441 | 0.2685 | 3.143 | 0.002547 |     0 | 0.3481 |
| d_slope_bp | jk_raw |    55 | 0.7601 | 0.2783 | 2.731 | 0.008556 | 0.0005 | 0.3132 |
| d_slope_bp | jk_us |    63 | 0.8454 | 0.2684 |  3.15 | 0.002529 |     0 | 0.3542 |
| d_di10y_bp | jk_bs (producao) |    62 | 0.5728 | 0.2273 |  2.52 | 0.01443 | 0.0195 | 0.1766 |
| d_di10y_bp | copom (todos) |    95 | 0.3179 | 0.1917 | 1.658 | 0.1006 | 0.1405 | 0.0617 |
| d_di10y_bp | copom rejeitados |    33 | -0.1573 | 0.2244 | -0.7009 | 0.4886 | 0.541 | 0.01992 |
| d_di10y_bp | nao-copom (controle) |   503 | 1.422 | 0.2168 | 6.558 | 1.359e-10 |     0 | 0.3687 |
| d_di10y_bp | jk (contemporaneo) |    65 | 0.5676 | 0.2099 | 2.704 | 0.008806 | 0.0105 | 0.192 |
| d_di10y_bp | jk_raw |    55 | 0.519 | 0.2189 | 2.371 | 0.02139 | 0.0315 | 0.1761 |
| d_di10y_bp | jk_us |    63 | 0.5669 | 0.2093 | 2.709 | 0.00875 | 0.0095 | 0.1947 |

## A — interacao (a estatistica que decide)

`y ~ x + 1(jk_bs) + x:1(jk_bs)` sobre todas as quintas validas. Contaminacao exige que o dia retido carregue **mais** noticia de risco por unidade de surpresa que um dia comum.

| proxy | n | coef | se_hc1 | t | p_asym | p_boot |
|---|---|---|---|---|---|---|
| d_cds_bp |   598 | -0.1912 | 0.1144 | -1.672 | 0.09508 |  0.17 |
| d_embi_bp |   592 | -0.182 | 0.09377 | -1.941 | 0.05274 | 0.092 |
| d_cds_bp_lag1 |   598 | 0.1904 | 0.08073 | 2.359 | 0.01864 | 0.0475 |
| d_embi_bp_lag1 |   597 | 0.2476 | 0.09489 | 2.609 | 0.009316 | 0.025 |
| d_lbrl |   596 | -0.03591 | 0.01653 | -2.173 | 0.03017 | 0.0675 |
| d_slope_bp |   598 | -0.2277 | 0.3018 | -0.7544 | 0.4509 | 0.492 |
| d_di10y_bp |   598 | -0.6157 | 0.3268 | -1.884 | 0.06002 | 0.119 |

## C — instrumento ortogonalizado ao risco

`e_di_bs` residualizado no risco contemporaneo, em tres degraus de severidade. `z_jk_bs_norisk` usa d_embi_bp + d_lbrl (R2 = 0.1267) e esta congelada como estava em 2026-07-31 para servir de self-test. `z_jk_bs_norisk_cds` acrescenta o CDS (d_embi_bp + d_lbrl + d_cds_bp, R2 = 0.1537) e e o limite inferior mais forte sobre os **valores**. `z_jk_bs_norisk_mask` re-deriva tambem a **mascara**.

**E um limite inferior.** Politica legitimamente move spread soberano, entao ortogonalizar contra o risco contemporaneo super-remove. Sobreviver e descarte forte do confound; nao sobreviver e ambiguo.

### Valores contra selecao

Ortogonalizar so os **valores** deixa a **selecao** dos 62 dias intacta, contra a propria auditoria de fidelidade do projeto ("a forca vive na mascara"). Por isso a perna de acoes tambem e ortogonalizada na mesma RHS e a regra de sinal do JK e re-derivada nos residuos duplos: o bloco de risco explica **0.1537** de `e_di_bs` e **0.4040** de `e_ibov_bs`, e a mascara re-derivada retem **63 dias**, dos quais **50 dos 62** de producao sobrevivem e **13** entram.

| conjunto | n | r2_risco |
|---|---|---|
| producao (jk_bs) |    62 |    NA |
| re-derivada no risco (jk_bs_norisk) |    63 | 0.1537 |
| intersecao |    50 | 0.404 |
| dias Copom sem proxy de risco |     2 |    NA |

## Forca: xi_mp por variante

| amostra | instrumento | meses_nao_nulos | xi_mp | f_robust_mp | impacto_mp_pre | denom_vs_prod | ar_limitada | bandas_validas |
|---|---|---|---|---|---|---|---|---|
| full | z_jk_bs_purif |    62 | 6.271 | 10.12 | 8.426e-05 |     1 | TRUE | FALSE |
| full | z_jk_bs_norisk |    60 | 6.619 | 10.29 | 8.302e-05 | 0.9853 | TRUE | FALSE |
| full | z_jk_bs_norisk_cds |    60 | 7.576 |  13.1 | 9.231e-05 | 1.096 | TRUE | FALSE |
| full | z_jk_bs_norisk_mask |    62 | 4.264 | 4.859 | 6.057e-05 | 0.7188 | TRUE | FALSE |
| pre_covid | z_jk_bs_purif |    31 | 10.99 | 9.747 | 8.054e-05 |     1 | TRUE | TRUE |
| pre_covid | z_jk_bs_norisk |    30 | 7.758 | 6.675 | 7.287e-05 | 0.9048 | TRUE | FALSE |
| pre_covid | z_jk_bs_norisk_cds |    30 | 8.897 |  8.69 | 7.937e-05 | 0.9855 | TRUE | FALSE |
| pre_covid | z_jk_bs_norisk_mask |    30 | 6.686 | 7.232 | 7.111e-05 | 0.8828 | TRUE | FALSE |

`ar_limitada` e ξ_mp > 3,84 (conjunto AR de 95% limitado); `bandas_validas` e ξ_mp ≥ 10.

**Valores e selecao afetam a forca por canais distintos.** Ortogonalizar os **valores** ao risco contemporaneo leva ξ_mp de 6,27 na producao para 6,62 com EMBI e cambio e 7,58 com o CDS. Re-derivar a **mascara** sobre os mesmos residuos leva a estatistica para 4,26 na amostra cheia, uma queda de 2,01 contra a producao, porque o bloco de risco explica 15.4% de `e_di_bs` e 40.4% de `e_ibov_bs`, que e a outra perna da regra de sinal. O conjunto AR continua limitado, mas abaixo de 10 as bandas convencionais deixam de valer, entao a variante de mascara sustenta sinal e direcao, nao intervalo.

Na janela pre-COVID a variante de mascara fica em 6,69 contra 10,99 da producao. Pela referencia convencional de 10, somente a producao sustenta bandas convencionais.

⚠ **Por que uma variante ortogonalizada pode imprimir respostas MAIORES, e por que isso nao e evidencia a favor.** `impacto_mp_pre` e a resposta de `yield_6m` no impacto **antes** da normalizacao, isto e o denominador pelo qual cada IRF da celula e dividida, e `denom_vs_prod` o poe em razao da producao. Onde ele encolhe, toda a IRF da celula cresce por aritmetica, sem que nada de economico tenha mudado. E o mesmo mecanismo que a classe `unstable_normalization` da taxonomia do sweep monitora (`R/identification/spec_sweep.R`), e por isso a leitura de magnitude entre variantes so vale com essa coluna ao lado.

## IRFs no impacto (h = 0)

Celulas sig90 por variante: z_jk_bs_norisk_mask 65, z_jk_bs_norisk_cds 61, z_jk_bs_purif 61.

| instrumento | variavel | ponto | lo68 | hi68 | lo90 | hi90 | sig90 |
|---|---|---|---|---|---|---|---|
| z_jk_bs_purif | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk_bs_purif | yield_2y | 0.00743 | 0.006551 | 0.008595 | 0.006076 | 0.009482 | TRUE |
| z_jk_bs_purif | yield_5y | 0.007761 | 0.00663 | 0.009619 | 0.005791 | 0.01113 | TRUE |
| z_jk_bs_purif | cambio_usd | 0.1579 | 0.1123 | 0.2033 | 0.09207 | 0.2493 | TRUE |
| z_jk_bs_purif | embi_perc | 0.262 | 0.2074 | 0.3791 | 0.1719 | 0.473 | TRUE |
| z_jk_bs_purif | cds_5y | 32.54 | 26.32 | 44.35 | 22.15 | 53.84 | TRUE |
| z_jk_bs_purif | asset_ibov | -1.723 | -5.042 | -0.6327 | -6.91 | 0.7747 | FALSE |
| z_jk_bs_purif | price_ipca | -0.06179 | -0.1831 | 0.04684 | -0.2758 | 0.117 | FALSE |
| z_jk_bs_purif | price_ipp | 0.4677 | 0.3075 | 0.704 | 0.1856 | 0.8838 | TRUE |
| z_jk_bs_norisk_cds | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk_bs_norisk_cds | yield_2y | 0.007223 | 0.00641 | 0.008332 | 0.005922 | 0.009082 | TRUE |
| z_jk_bs_norisk_cds | yield_5y | 0.007345 | 0.006372 | 0.009206 | 0.005608 | 0.01048 | TRUE |
| z_jk_bs_norisk_cds | cambio_usd | 0.1554 | 0.1131 | 0.1946 | 0.09195 | 0.2346 | TRUE |
| z_jk_bs_norisk_cds | embi_perc | 0.2326 | 0.1869 | 0.3504 | 0.1508 | 0.4234 | TRUE |
| z_jk_bs_norisk_cds | cds_5y |  29.7 | 24.23 | 41.19 | 20.31 | 48.24 | TRUE |
| z_jk_bs_norisk_cds | asset_ibov | -0.8056 | -4.088 | 0.009612 | -5.925 |  1.37 | FALSE |
| z_jk_bs_norisk_cds | price_ipca | -0.07836 | -0.1814 | 0.03136 | -0.2851 | 0.09384 | FALSE |
| z_jk_bs_norisk_cds | price_ipp | 0.4314 | 0.2781 | 0.6553 | 0.1671 | 0.8226 | TRUE |
| z_jk_bs_norisk_mask | yield_6m | 0.005 | 0.005 | 0.005 | 0.005 | 0.005 | TRUE |
| z_jk_bs_norisk_mask | yield_2y | 0.01082 | 0.009555 | 0.01364 | 0.008762 | 0.01746 | TRUE |
| z_jk_bs_norisk_mask | yield_5y | 0.0136 | 0.01177 | 0.01845 | 0.01045 | 0.02647 | TRUE |
| z_jk_bs_norisk_mask | cambio_usd | 0.2646 | 0.1955 | 0.3801 | 0.169 | 0.5796 | TRUE |
| z_jk_bs_norisk_mask | embi_perc | 0.6075 | 0.4826 | 0.9498 | 0.409 |  1.49 | TRUE |
| z_jk_bs_norisk_mask | cds_5y | 68.29 |  55.7 | 103.4 | 47.99 | 152.3 | TRUE |
| z_jk_bs_norisk_mask | asset_ibov | -11.8 | -19.45 | -10.02 | -30.12 | -8.286 | TRUE |
| z_jk_bs_norisk_mask | price_ipca | 0.08462 | -0.05508 | 0.2371 | -0.1666 | 0.3546 | FALSE |
| z_jk_bs_norisk_mask | price_ipp | 1.177 | 0.907 | 1.746 | 0.7376 |  2.56 | TRUE |

Trajetorias completas em `jk_sovereign_irf_overlay.pdf`; celulas em `jk_sovereign_confound.csv`.

