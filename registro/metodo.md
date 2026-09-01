# Método — construção do instrumento externo para o proxy-SVAR/DFM

> **Nota de leitura (2026-08-17).** As duas rotas alternativas de identificação
> foram abandonadas: heterocedasticidade (Rigobon) e momentos/não-gaussianidade
> (GMR). O projeto tem **uma** identificação, o proxy externo `z_jk_bs_purif`.
> Os blocos de *Status histórico* abaixo são registros datados e ficam
> **verbatim**, inclusive onde citam `z_het*`, `script/instrument_het.R`,
> `script/instrument_validation.R` e `script/irf_cross_instrument.R` — esses
> arquivos hoje estão em `arquivo/heterocedasticidade/script/`. Vereditos em
> `historico_decisoes.md` §0 e §1.
>
> Duas coisas que **não** foram abandonadas e usam a mesma palavra: a inferência
> robusta a heterocedasticidade (wild bootstrap de Gonçalves-Kilian, HAC do
> primeiro estágio) e a citação de `goncalves2025`, que é evidência alheia.

## Status (2026-08-24, produção DFM migrada para `p=4`)

> A produção usa o painel de 111 séries, 153 meses, `(r,q,p)=(5,5,4)`,
> `z_jk_bs_purif`, normalização de +50 pb em `yield_6m`, horizonte 0--48 e
> wild bootstrap de 800 réplicas com semente 123. A escolha de `p=4` vem do
> AIC mínimo, 8,073207, calculado para `p=1,...,12` em amostra comum de
> `T=141`, com constante e tendência linear; o BIC seleciona `p=2` e é
> reportado. A tendência pertence somente ao exercício de seleção: o VAR
> efetivamente estimado nos fatores conserva apenas intercepto.
>
> A amostra cheia produz 149 inovações, `xi_mp/F_rob,mp =
> 5,240158/10,060922` e raiz máxima 0,968126. A pré-COVID produz 80
> inovações, `7,478324/11,874945` e raiz 0,992483. As duas companions são
> estáveis. O gate de 800 réplicas teve zero falhas, bandas 68%/90% finitas e
> ordenadas e normalização exata em 0,005. Nota:
> `notas/2026-08-24_migracao_dfm_p4.md`.

## Status (2026-08-25, texto e diagnósticos sincronizados em `p=4`)

> As Seções 3--5 do paper e `output/irf/irf_section.md` foram conferidas contra
> `irf_coherence_h.csv`, os gates de produção e os diagnósticos regenerados. No
> impacto, a curva sobe 38,9, 50,0, 62,9, 72,8, 74,8 e 67,6 pb nos vértices de
> 3 meses, 6 meses, 1 ano, 2 anos, 5 anos e 10 anos, e a Selic sobe 24,1 pb.
> Câmbio, EMBI+ e CDS mantêm 3,74%, 24,5 pb e 30,7 pb; o Ibovespa cai 0,97%,
> enquanto apenas o IFIX exclui zero a 90% no impacto entre os índices.
>
> Os diagnósticos de validade também usam a célula corrente. No exercício
> soberano, `xi_mp` segue 5,24 -> 5,80 -> 6,49 quando apenas os valores são
> ortogonalizados e cai a 3,44 quando a máscara é rederivada. No exercício FOMC,
> a sequência é 5,24 -> 5,33 nos valores e 3,67 na máscara rederivada. O
> veredito corrente é sinal fraco de contaminação FOMC, e nenhum desses testes
> absolve a proxy. Por decisão editorial de 2026-08-25, o paper expõe somente
> as variantes que mantêm fixa a máscara de produção; os resultados de máscara
> rederivada permanecem neste registro e nos artefatos. A rodada foi
> exclusivamente textual e não reestimou modelos.

## Status (2026-08-22, benchmark VAR em níveis)

> O único benchmark VAR pequeno ativo é `ibc5_fx_cds_level_trend_p2`, com
> IBC-Br, IPCA, yield de 6 meses, câmbio e CDS em nível. Cada equação inclui
> constante e tendência linear. AIC e BIC são calculados para `p=1,...,12`
> sobre as mesmas `T=141` observações; o AIC seleciona `p=2`, enquanto o BIC
> seleciona `p=1`, e a produção segue o AIC. A forma reduzida estende
> `RForm_VAR.m` com o termo de tendência, o impacto é
> `B_1=0,005 Gamma/Gamma_yield` e cada ponto é `C_h B_1`, sem soma por
> horizonte. A única inferência do VAR observável são conjuntos
> Anderson--Rubin/MOSW de 68% e 90% com NW(0). Não há wild bootstrap, correção
> de Kilian ou fallback OLS nesse benchmark. A inferência do DFM permanece
> intocada. Nota: `notas/2026-08-22_var_niveis_aic_tendencia.md`.

## Status histórico (2026-08-13, produção migrada para 111 séries e `(5,5,6)`)

> A especificação daquela rodada foi centralizada em
> `R/modeling/production_spec.R`: painel
> `drop_setor_externo__eua__credito__imoveis` com 111 séries, 153 meses e 147
> inovações; `r=5`, `q=5`, `p=6`; `z_jk_bs_purif`; choque de +50 pb em
> `yield_6m`; 800 réplicas, semente 123, bandas 68%/90% e h=0--48. `r=5` é a
> escolha do Bai--Ng IC2 BLL. `q=5` é provisório e continua como pendência.
>
> Saem `juros_cdi`, `asset_mlcx` e os blocos experimentais setor externo, EUA,
> crédito e imóveis; permanecem as três séries fiscais e as quatro de
> expectativas. O painel-base de 106 séries é preservado em caminho separado
> apenas para auditorias fatoriais históricas.
>
> Na amostra completa, `xi_mp/F_rob,mp=6,27085/10,12054` e raiz máxima
> 0,9648577. Na pré-COVID, 10,99268/9,74746 e raiz 1,0002017: a janela é
> marginalmente instável. O gate de 800 réplicas teve zero falhas e
> normalização exata em 0,005. Nota:
> `notas/2026-08-13_migracao_producao_painel_111_r5q5.md`.

## Status histórico (2026-08-13, diagnóstico de relevância alinhado a MOSW)

> Os arquivos ativos agora reportam somente as duas estatísticas de relevância
> na direção que normaliza o choque: ξ_mp e o primeiro estágio robusto
> F_rob,mp (HC1). As regressões usam a inovação de `yield_6m` implícita nos
> fatores e os mesmos lags do VAR como controles. A implementação reproduz a
> aplicação de Kilian de Montiel Olea, Stock e Watson: ξ_1 = 4,399 e
> F_rob = 9,438, contra 4,4 e 9,4 publicados. Na célula de produção (r=7,
> q=6), `z_jk_bs_purif` entrega ξ_mp/F_rob,mp = **7,65/7,95** na amostra
> completa e **11,53/6,26** no pré-COVID. A leitura pré-COVID é, portanto,
> mista e não autoriza selecionar a especificação por pré-teste.

## Status histórico (2026-08-12, fechamento mensal corrigido e rodada canônica reconstruída)

> A curva de juros, o EMBI+ e a curva ANBIMA agora selecionam explicitamente a
> maior data disponível de cada mês com `slice_max(..., with_ties = FALSE)`.
> Datas inválidas e meses duplicados abortam a execução. O insumo externo
> `data/raw/yields/yields_dia.csv` permaneceu intocado. A auditoria encontrou 25
> meses afetados no arquivo completo e 23 entre 2013-01 e 2025-09.
>
> O painel canônico mantém 106 séries e 153 observações entre 2013-01 e
> 2025-09, que geram 147 inovações fatoriais após o VAR(6). A especificação
> continua em r = 7, q = 6, com `z_jk_bs_purif` e normalização de 50 pontos-base
> em `yield_6m`. O ξ_mp corrente é 7,65 na amostra completa e 11,53 pré-COVID.
> Os números de status anteriores abaixo são históricos e não devem ser usados
> como vintage corrente. Nota de proveniência:
> `notas/2026-08-12_correcao_fim_mes_curva.md`.

## Status histórico (2026-08-10, coincidência FOMC testada — Etapa 1.4 finalmente executada, máscara absolvida)

> **A Etapa 1.4 abaixo foi executada, treze anos de calendário depois de ter sido especificada, e o teste que ela viabiliza não encontra contaminação.** Achado mais grave do segundo council review sobre `paper/paper_anpec.tex` (4 críticos; relatório em `pareceres/council_2026-08-10.md`), **aberto e fechado no mesmo dia**. Código: `R/data_download/fomc.R`, `script/download.R`, `R/instrument/event_tests.R`, `script/fomc_coincidence.R` → `output/instrument/fomc_coincidence.{csv,md}` + `fomc_coincidence_days.csv` + overlay; leitura em `notas/2026-08-10_coincidencia_fomc.md`. **Nada aqui mudou** — `DEFAULT_VARIANT`, vértice, esquema de agregação e a cadeia de `build_variants.R` seguem intocados, e as 8 colunas `z_*` saíram **bit-idênticas** depois de repopular a flag.
> 1. **O defeito era um `else`, não o FOMC.** `data/raw/fomc_dates.csv` nunca existiu e `script/instrument.R` caía silenciosamente num vetor de datas vazio, então `fomc_coincide` era **identicamente FALSE desde que a flag foi escrita** — um fallback que torna "a coleta não foi feita" indistinguível de "a coleta deu vazio". Agora `load_fomc_dates()` (`R/instrument/di_surprise.R`) **aborta** com ponteiro para o downloader, e `script/run_all.R` declara o arquivo como requisito duro do estágio `instrument`.
> 2. **A exposição era maior do que a crítica estimou.** Não 7 dos top-20 e ≈19% de Σ|z|, mas **8 dos top-20 (22,9%)** e **24 dos 62 dias retidos (38,7%), carregando 35,5% de Σ|z|**; 35 dos 95 dias Copom coincidem, e em 2025 foram 7 de 8 reuniões. A camada Bauer-Swanson de fato não remove um choque realizado *dentro* da janela Qua→Qui — isso continua verdade por construção.
> 3. **Veredito: confound FOMC não detectado**, pela regra fixada antes dos números. O bloco americano contemporâneo (`d_ust2`, `r_sp500`) não explica a surpresa nos 62 dias retidos (F_rob 0,94, p_boot 0,458) e as duas interações são nulas (0,466 com `1(fomc_coincide)`, 0,511 com `1(jk_bs)`). **Os dois números que invertem o sinal da suspeita:** nos **35 dias em que Copom e FOMC caem no mesmo dia** o R² é **0,005**, o *menor* da tabela — se a coincidência injetasse notícia do Fed na surpresa seria o maior; e o maior (**0,108**) está nos **33 dias que o filtro rejeita**, ou seja o filtro descarta preferencialmente o dia carregado de notícia americana. É o mesmo padrão que o CDS mostrou em 08-09, agora com o regime nomeado.
> 4. **A distinção máscara-vs-valores do item anterior agora tem número.** Ortogonalizar só os *valores* ao bloco global custa **0,21** de ξ_mp (10,43 → 10,22); acrescentar a **re-derivação da máscara** custa outros **2,50** (→ 7,72), doze vezes mais — porque o bloco global explica 0,76% da variância de `e_di_bs` mas **24,7%** da de `e_ibov_bs`. A leitura correta do Teste C do §5.2 continua sendo "ortogonaliza a surpresa ao risco contemporâneo", não "remove por completo".
> 5. **⚠ A ressalva que sobrevive.** O argumento de horário (comunicado às 14:00 ET, antes do fechamento do DI na B3 e do fixing de 15:30 ET do DGS2) vale para a perna de **taxa** — UST 2a move 5,00 bp Ter→Qua contra 3,00 Qua→Qui — e **não** para a de ações, onde o S&P move **mais** dentro da janela (0,74% contra 0,54%). ⚠ A divisão em metades com e sem FOMC saiu do script em 2026-08-10 e nada do que ela produziu é reproduzível ou citável (`historico_decisoes.md` §2.4).
> 6. **Segue aberto, e é redação:** o placebo `sp500_vix` do §5.1 é só o índice **VIX** (`data/raw/investing/sp500_vix.csv`, média 18,58, min 9,51, max 53,54) — o painel **não contém nenhuma série de nível do S&P 500**, apesar de a **Etapa 1.3** abaixo prever uma. A descrição em `:501`/`:509` do paper está errada e o argumento de `:519` depende dela.

## Status histórico (2026-07-31, confound de risco soberano testado — máscara absolvida)

> **A máscara JK não seleciona risco soberano para dentro; ela seleciona *menos* risco que um dia comum.** Item de topo do council review de 07-31, testado em `script/jk_sovereign_confound.R` → `output/instrument/jk_sovereign_confound.{csv,md}` + `jk_sovereign_irf_overlay.pdf`; leitura em `notas/2026-07-31_confound_soberano_jk.md`. ⚠ Em 2026-08-10 os testes B (três vias) e D (tabela datada) saíram do script, `jk_sovereign_days.csv` foi apagado, e o teste C ganhou a máscara re-derivada nos resíduos ortogonalizados das duas pernas — ver `historico_decisoes.md` §2.4. **Nada aqui mudou** — `DEFAULT_VARIANT`, vértice, esquema de agregação e a cadeia de `build_variants.R` seguem intocados.
> 1. **A acusação.** O filtro JK descarta o efeito-informação (juros ↑, ações ↑), mas a assinatura fiscal doméstica (juros ↑, ações ↓, câmbio ↑) é **a que ele retém**. Os placebos não a descartam: um choque fiscal doméstico também não move o S&P 500.
> 2. **O dado aponta ao contrário.** Regra de leitura fixada *antes* dos números: contaminação exige que o dia retido carregue **mais** risco por unidade de surpresa que um dia comum. Nas 498 quintas **não-Copom** ΔEMBI carrega a surpresa com coef **0,326** (t = 3,97, R² 0,13); nos **62 dias retidos**, **0,099** (t = 1,74, R² 0,04). No câmbio, 0,051 (t = 4,64) contra 0,004 (t = 0,40). Em ΔCDS, que mede melhor: **0,436** (t = 4,35, R² 0,22) contra **0,140** (t = 2,86) — mesma razão de ~3×, mas o coeficiente dos retidos é **significativo** (p_boot 0,003), e os dias **rejeitados** pelo filtro carregam risco com sinal **negativo** (−0,285, p 0,010). As interações `x:1(jk_bs)` são **negativas** nas **cinco** proxies da janela do evento — CDS −0,191 (p_boot 0,170), EMBI −0,182 (p_boot 0,092), **BRL −0,036 (p_boot 0,068**, apreciação relativa = assinatura de UIP), slope DI −0,228, DI 10a −0,616. (Os `p_boot` foram resorteados em 08-09 com semeadura por célula; coeficientes e `t` são os mesmos.) A camada BS + máscara **empobrece** o conteúdo de risco.
> 3. **⚠ Pré-requisito que quase inverteu o veredito: o alinhamento.** O arquivo do EMBI (`data/raw/banco_central_rep_dominicana/embi_brasil.csv`) é painel JP Morgan republicado pelo BC dominicano. Correlação de ΔEMBI com o mercado em t / t−1: S&P −0,498 / −0,045; VIX +0,413 / −0,007; Ibov −0,508 / −0,088. **É do mesmo dia** — e o CDS também (S&P −0,541 / −0,040; Ibov −0,580 / −0,089, correlações contemporâneas mais fortes nas quatro séries). Logo a janela Qui→Sex (interação **+0,248, p_boot 0,025**) **não** é correção de defasagem — é a resposta *defasada* do risco, que a IRF mensal já reporta. Não re-derivar isso.
> 4. **Ortogonalizar `e_di_bs` ao risco diário** é um **limite inferior**, pois política move spread legitimamente. Com ΔEMBI + Δlog BRL (R² 0,127): ξ_mp **10,72** full (acima dos 10,43), 8,18 pré-COVID. **Acrescentando ΔCDS** (R² 0,154): ξ_mp **12,68** full, 9,93 pré-COVID, câmbio 0,139 contra 0,150 — o limite inferior mais severo é **o instrumento mais forte da rodada**. Todas as manchetes sig90 nas duas. Sobreviveu com folga.
> 5. **⚠ A ressalva que fica:** o coeficiente nos 62 dias retidos é positivo e, no CDS, significativo, então a afirmação sustentada é a de **menos risco que um dia comum**, não a de ausência de risco. ⚠ Os testes B (três vias) e D (tabela datada) saíram do script em 2026-08-10 e nada do que produziram é reproduzível ou citável (`historico_decisoes.md` §2.4); em troca, o teste C ganhou a máscara re-derivada nos resíduos ortogonalizados das duas pernas.
> 6. **A lacuna foi fechada em 2026-08-09** (`data/raw/CDS 5y.xlsx`, Bloomberg `BRAZIL CDS USD SR 5Y D14 Corp`; nota [`2026-08-09_confound_soberano_cds`](../notas/2026-08-09_confound_soberano_cds.md)). O teste roda nas **duas** proxies e o **veredito não muda** (interação CDS −0,191, p_boot 0,170). O CDS é medida estritamente melhor — 95/95 pares Copom contra 94/95, **0,5%** de variações exatamente zero contra 8,3%, menor variação exprimível 0,005 pb contra 1,000 pb — o que **mata a objeção de que o nulo era atenuação por arredondamento**. **⚠ Duas coisas que endurecem, não aliviam:** nos 62 dias retidos o coeficiente do CDS é claramente **não-nulo** (0,140, p_boot **0,003**), então "menos risco que um dia comum, **não** zero risco" virou fato medido; e as três metades "política" do teste de três vias têm ξ_mp **3,52 (FX) / 0,89 (EMBI) / 0,35 (CDS)**, **nenhuma cruzando 3,84** — a do CDS inverte o sinal do câmbio, mas com 1 célula sig90 em 441 e IC90 que contém o ponto de produção, então é ausência de evidência, e o teste B é **sugestivo, não conclusivo**. **O melhor resultado:** ortogonalizar ao risco diário **incluindo CDS** dá ξ_mp **12,68** full (contra 10,72 só-EMBI e 10,43 da produção) — o limite inferior mais severo é o instrumento mais forte.

## Status histórico (2026-07-15, troca de default + het fora do paper)

> **`DEFAULT_VARIANT = z_jk_bs_purif`** (decisão do autor, fechando a questão aberta na auditoria de 2026-07-14 abaixo): ortogonalização Bauer-Swanson fiel (preditores pré-evento predeterminados) + filtro JK nos sinais dos resíduos pré-evento. ξ_mp na produção (7,6): 10.43 full / 12.22 pre-COVID, ≥ 10 nas duas janelas (bandas padrão) — vintage 2026-07-24; a produção migrou de (6,5) → (7,6) nessa data (em (6,5) caiu para 6.36 full / 11.00 pre-COVID). Os corpos dos relatórios stage-2/coerência estão stale até re-rodar. Cadeia re-estimada na mesma data (sweep 480 células com as 4 variantes da auditoria, stage 2 com baseline (6,5) full, `model_alessi.R`, coerência nboot=800): história qualitativa preservada (curva ↑, BRL deprecia, EMBI/CDS abrem, corcova n.s. do IPCA), magnitudes ~30–45% menores que na rodada `z_jk_purif` (Ibov h0 −1.1% vs −8.9%; BRL +0.185 vs +0.245; EMBI +25bp vs +46bp); crédito e juros_cdi/selic melhoram de veredito na coerência. **Decisão editorial: o instrumento het (z_het\*) fica fora do paper** — pipeline mantido como diagnóstico interno; `registro/estrutura_paper_v2.md` atualizado. *(O pipeline deixou de existir em 2026-08-17: rota abandonada, ver `arquivo/heterocedasticidade/`.)* Pendências novas: bandas AR para o full, rewrite do §5/`irf_section.md` sob o novo primário.

## Status histórico (2026-07-14, auditoria de fidelidade JK/BS)

> Auditoria contra os artigos e códigos originais (`notas/2026-07-14_auditoria_fidelidade_jk_bs.md`) concluiu:
> 1. **JK**: regra zero-out e agregação por soma mensal fiéis; mas o poor man's original classifica e agrega valores **brutos** — o default `z_jk_purif` usa resíduos em ambos. Adicionada a variante literal **`z_jk_raw`** (máscara bruta + valores brutos), completando a matriz 2×2 máscara × valores.
> 2. **"Purificação Bauer-Swanson"**: o nome está impreciso — BS (2023, eq. 7/Table 3) regridem a surpresa em notícias **pré-anúncio** (releases macro + tendências financeiras de 13 semanas + trend), não em variações contemporâneas da janela. A regressão contemporânea SP500/VIX/Brent do projeto é uma limpeza de fator global (válida por exogeneidade de economia pequena, mas outro procedimento). Versão fiel adicionada: **`z_bs_purif`** / **`z_jk_bs_purif`** (preditores pré-evento: Δ65d de Ibov/SP500/VIX/Brent/BRL/inclinação DI + Δ20d Focus IPCA-12m e Selic + tendência; novos dados via `R/data_download/focus.R` e `R/data_download/fred.R`, orquestrados por `script/download.R`). Também testado `z_jk_purif_us` (contemporânea + UST 2y) — **inócuo** (cor 0.999 com o default), removido em 2026-08-05.
> 3. **Força (ξ_mp, grid 392 células)**: a força vem da **máscara**, não dos valores purificados (cor ≥ 0.986 entre variantes de mesma máscara). Máscaras predeterminadas (bruta ou BS-pré-evento) excluem `2020-03-19` e dominam o default na amostra full em 14/14 células — full (6,5): `z_jk_raw` 7.05, `z_jk_bs_purif` 6.94 vs `z_jk_purif` 5.20; ambas cruzam ξ_mp ≥ 10 em 6/14 células full (default: 0). No pre_covid (6,5) o default segue líder (13.25; `z_jk_bs_purif` 12.49). **Default inalterado**; `z_jk_bs_purif` é o candidato metodologicamente mais limpo (BS fiel + máscara predeterminada + força competitiva nas duas amostras) — decisão de troca em aberto. *(Fechada em 2026-07-15: default trocado para `z_jk_bs_purif`, ver status acima.)*

## Status histórico (2026-07-11, pós-varredura de especificações)

> A varredura sistemática (320 células: 8 instrumentos × 5 mp_vars × 4 grids (r,q) × 2 amostras; `script/irf_spec_sweep.R` + `script/irf_spec_stage2.R`) **confirma `z_jk_purif` como default** e refina três pontos do status 2026-05-08 abaixo:
> 1. "Único que cruza Stock-Yogo" era artefato do grid antigo (r fixo = 7): `z_jk_purif` cruza F (factor-sp) ≥ 10 no full em (6,5)/(7,6)/(8,8) — 10.08/10.17/11.76 — e `z_jk` cruza em (8,8). Na janela **pre_covid (2013-19) com (r=6, q=5), cinco instrumentos cruzam** (z_jk_purif 15.4, z_jk 15.2, z_het_jk_3var 11.1, z_het_3var 10.8, z_bruto_purif 10.4).
> 2. O auto-IC (r=5, q=4) usado por `model_alessi.R` é **borderline-weak** (9.20) — pendência aberta para migrar o caso base para (6,5) ou (7,6).
> 3. Zero células `sign_puzzle` no grid inteiro: F (factor-sp) ≥ 10 ⇒ sinais teoricamente coerentes, sem exceção. O diagnóstico de sinais invertidos está **fechado** — é weak-IV no espaço dos fatores, e nada mais.
>
> Detalhes: `output/irf/spec_sweep_conclusoes.md`, `notas/2026-07-11_varredura_irf.md`.

## Status histórico (2026-05-08, pós-investigação F factor-space)

> **Default revertido para `z_jk_purif` (GK timing-ID + Bauer-Swanson + JK).** A auditoria de 2026-04-25 havia recomendado `z_het_jk_3var` por um diagnóstico univariado legado. A sessão 2026-05-08 reabriu a decisão: após o fix de unit scaling em `yield_6m` (LEVE 2026-05-07) expor as IRFs reais, ficou claro que aquela régua não media a direção que normaliza o proxy-SVAR/DFM. O grid então usado levou à volta de `z_jk_purif` como default. Essa justificativa foi posteriormente superada pela estatística ξ_mp e, em 2026-08-13, pelo par ξ_mp/F_rob,mp. Documentação histórica completa: `arquivo/_instrucoes/Heteroscedasticidade.md` e `registro/historico_decisoes.md`.
>
> **Validação completa (T1-T8, 2026-05-06):** `script/instrument_validation.R` executa oito robustezes:
> - **T1 placebo** (n=2000): F=21.3 não é data-snooping (p=0.0005);
> - **T2 random-mask k=42** (n=2000): JK F sits at q99 (p=0.0105 — gap de um percentil);
> - **T2b paired benchmark z_het puro**: F=7.61 (placebo p=0.008); ambos passam, gap reflete identificação no diário, não data-snooping;
> - **T3 sub-period**: F estável (10–38) em pre-COVID / COVID+post / drop_covid;
> - **T4 correlação com z_jk_purif** (n=36 both-nonzero): pearson 0.93, spearman 0.94 — het-ID e timing-ID convergem; cor estável 0.93–0.95 por sub-período (não mascara COVID);
> - **T5 anti-JK mask**: F = **0.194** sobre os 55 dias sign-equal "informacionais" — evidência direta de que JK não é só esparsificação;
> - **T6 F(k_keep) curva** k ∈ {20, 42, 60, 80}: p(F_random ≥ JK) = {0.034, 0.0095, 0.006, 0.000}; em k=80 nenhum random draw alcança JK F;
> - **T7 AR-order sensitivity** p ∈ {3, 6, 12}: F (full) = 20.7 / 21.3 / 22.4 — estável; AR(3) sub-residualiza no pre_covid;
> - **T8 Andrews (1993) QLR sup-F**: sup F = 6.88 em 2015-08, **fail to reject** vs cv5=8.85 — o drop F sub-period é mecânico (var(innov) cresce 3.6× pós-COVID), não quebra estrutural.
>
> Replicação cross-language R↔Python (T1-T4) bate a 6 decimais. Relatório referee2 round 2: **Accept**. Os 6 itens CRÍTICOS de `registro/pendencias.md` foram fechados nos commits `4e2192f` (críticos 1-3) e `a3af0e4` (críticos 4-6 + DEFAULT_VARIANT).
>
> **Validação IRF (2026-05-06 tarde, commit `26d9dce`):** `script/irf_cross_instrument.R` roda `main_sdfm` 2× (z_het_jk_3var, z_jk_purif), nboot=800, bandas 68/90, 9-painel grid 3×3. Findings discriminantes: (i) `z_het_jk_3var` recupera Δπ desinflação de GRG (-0.10 pp ≈ GRG -0.13); `z_jk_purif` falha. (ii) BRL e CDS divergem em sinal vs GRG — fiscal-dominance leitura no mensal vs daily IV. Detalhamento: `output/irf_section.md` + `output/grg_benchmark.csv`. **Item 7 de pendências fechado — toda a seção MÉDIO está completa.**
>
> **Framing operativo (council Required 3):** o instrumento `z_het_jk_3var` é uma **identificação híbrida** het+timing+sign — não het-ID puro. A condição operativa no proxy-SVAR mensal é a *exclusion restriction* `E[z_het_jk_m · η_t^j] = 0` (Stock-Watson 2018 §4.7), não A1-A3 conjuntas (que falham pelos 57% wrong-sign no diário).
>
> Este documento permanece como referência para as 4 variantes GK legacy (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`), que continuam sendo construídas por `script/instrument.R` e usadas como benchmark na comparação cross-instrument do diagnostics.

## Objetivo

Construir um instrumento externo baseado em surpresas de DI futuro nos dias pós-Copom para identificação de choques monetários no proxy-SVAR do DFM. O pipeline de estimação (painel → fatores → VAR nos fatores → identificação por instrumento externo → IRFs) **já existe e não deve ser alterado**. Este documento trata exclusivamente da construção do instrumento $z_t$ que alimenta o primeiro estágio.

O produto desta linha são **oito variantes** do instrumento mensal, mantidas como benchmark:

1. **$z^{bruto}_t$** — surpresa de DI pós-Copom agregada mensalmente (sem filtro)
2. **$z^{purif}_t$** — surpresa de DI purificada por SP500/VIX/Brent (Bauer-Swanson)
3. **$z^{JK}_t$** — surpresa de DI apenas nos dias com co-movimento negativo DI×Ibovespa (filtro Jarociński-Karadi)
4. **$z^{JK,purif}_t$** — combinação dos dois filtros (a classificação JK usa os sinais dos *resíduos* — ordem "purificação → JK")
5. **`z_jk_raw_purif`** *(2026-07-14)* — máscara JK nos sinais **brutos** (`delta_di` × `r_ibov`), valores purificados — ordem inversa "JK → purificação"
6. **`z_jk_raw`** *(2026-07-14, auditoria)* — JK **literal**: máscara bruta + valores brutos, sem purificação
7. **`z_bs_purif`** *(2026-07-14, auditoria)* — resíduo da regressão pré-evento fiel a BS (sem filtro JK)
8. **`z_jk_bs_purif`** *(2026-07-14, auditoria)* — máscara JK nos sinais dos resíduos pré-evento + valores pré-evento — **produção**

> **2026-08-05 — removidas duas variantes.** `z_jk_raw_purif_local` (purificação
> re-estimada só nos ~55 dias selecionados; dominada por `z_jk_raw_purif` em
> 26/28 células) e `z_jk_purif_us` (contemporânea + Δ UST 2y; cor 0,999 com
> `z_jk_purif` e não corrige a má-classificação de 2020-03-19). Ambas já
> constavam como descartadas em `historico_decisoes.md` §2 e nenhuma varredura
> viva as consumia — `irf_spec_sweep.R` já rodava só as oito. A maquinaria
> **diária** do ramo `_us` (`e_di_us`, `jk_monetary_us`) permanece em
> `build_variants.R` porque `script/jk_sovereign_confound.R` usa o conjunto de
> dias `jk_us` como uma de suas sete máscaras de diagnóstico.

---

## Etapa 1 — Coleta de Dados

### 1.1 Surpresas de alta frequência (diário, preço de fechamento)

- **DI futuro — vértice curto (~3 meses):** Swap DI×Pré 90 dias da B3.
  - `data/raw/di.csv` (verificar se é o mesmo)
  - Unidade: taxa em % a.a. (252 d.u.)

- **Ibovespa (IBOV):** índice de fechamento diário.
  - Esta dentro da base: `data/raw/raw_data.csv`, verificar se teve transformaçao em: `script/download.R`
  - Unidade necessaria: retorno percentual diário

### 1.2 Calendário do Copom

- `data/raw/copom_historico.csv`
- Extrair todas as datas de decisão do Copom (quarta-feira)
- Janela de evento: **quarta (fechamento) → quinta (fechamento)**
- Criar dummy: `copom_day = 1` para as quintas-feiras pós-Copom

### 1.3 Fatores externos (para purificação)

Séries diárias, mesmo período, variação quarta → quinta:

- **S&P 500:** Yahoo Finance (`^GSPC`)
- **VIX:** Yahoo Finance (`^VIX`)
- **Petróleo Brent:** Yahoo Finance (`BZ=F`)

### 1.4 Datas FOMC

**Executada em 2026-08-10** (`script/download.R`, via `R/data_download/fomc.R`, → `data/raw/fomc_dates.csv`).

- Coletar datas de decisão do FOMC no período
- Criar dummy `fomc_coincide = 1` para semanas com Copom e FOMC simultâneos (~32 ocorrências)

Realizado: **110 datas em 2013-2025** (8 agendadas por ano, exceto 2020 com 7 —
a reunião de 17-18 de março foi cancelada e substituída pela não-agendada de 15
de março — mais 7 não-agendadas), raspadas das páginas de calendário do próprio
Fed. A estimativa de "~32 ocorrências" ficou perto: são **35** dos 95 dias
Copom, e **24** dos 62 dias retidos pelo filtro JK.

---

## Etapa 2 — Surpresas Brutas

Para **toda quinta-feira** da amostra:

```
ΔDI_t   = DI_fecha(quinta) - DI_fecha(quarta)                          [pontos-base]
ΔIbov_t = 100 × [ln(Ibov_fecha(quinta)) - ln(Ibov_fecha(quarta))]      [log-retorno %]
```

Salvar dataframe: `date`, `delta_di`, `delta_ibov`, `copom_day`, `fomc_coincide`.

---

## Etapa 3 — Purificação por Fatores Externos

Estimar na **amostra completa** (todas as quintas-feiras):

```
ΔDI_t   = a0 + a1·ΔSP500_t + a2·ΔVIX_t + a3·ΔBrent_t + e_DI_t
ΔIbov_t = b0 + b1·ΔSP500_t + b2·ΔVIX_t + b3·ΔBrent_t + e_Ibov_t
```

Produto: resíduos `e_DI_t` e `e_Ibov_t` — surpresas purificadas.

> **2026-07-14 (auditoria):** esta regressão usa variações **contemporâneas** da mesma janela qua→qui — é uma limpeza de fator global (justificada pela exogeneidade de economia pequena), **não** a ortogonalização de Bauer-Swanson, que usa apenas preditores **pré-anúncio**. A versão fiel a BS (Δ65d financeiro + Δ20d Focus + tendência, tudo predeterminado na quarta) está implementada em `script/instrument.R` como `e_di_bs`/`e_ibov_bs` (variantes `z_bs_purif`, `z_jk_bs_purif`; insumos brutos produzidos por `script/download.R`). Nunca incluir variáveis domésticas contemporâneas (BRL, EMBI, curva DI da janela) — bad control.

---

## Etapa 4 — Diagnóstico

### 4.1 Scatterplot

Plotar `e_DI_t` (eixo x) vs. `e_Ibov_t` (eixo y) **apenas nos dias Copom**.

Quadrantes:
- **II e IV** (co-movimento negativo): consistente com choque monetário puro
- **I e III** (co-movimento positivo, "wrong-signed"): evidência de choque informacional do BCB

Reportar proporção de wrong-signed:
- \>25%: filtro JK fortemente motivado
- 15-25%: filtro JK defensável
- <10%: filtro JK provavelmente desnecessário, usar surpresa bruta

**Resultado observado (2013-01–2025-12):** ~31.6% wrong-signed nos resíduos purificados — filtro JK fortemente motivado. Isso explica em parte o ganho dramático ao aplicar JK também sobre o instrumento por heterocedasticidade (`z_het_jk` triplica o F sobre `yield_6m` vs `z_het` puro).

Salvar figura: `output/scatterplot_surpresas_copom.png`

### 4.2 Testes de variância

Testar (teste F, razão de variâncias, IC 99%):

| Variável | H0 | Esperado |
|---|---|---|
| `e_DI` | Var(Copom) = Var(não-Copom) | **Rejeitar** — variância maior em dias Copom |
| `e_Ibov` | Var(Copom) = Var(não-Copom) | Idealmente não rejeitar |

Formato de reporte: replicar Tabela 1 de Gonçalves, Rodrigues & Genta (2025).

---

## Etapa 5 — Construção dos Instrumentos

### 5.1 Instrumento bruto (sem filtro JK)

Para cada mês $t$:

```
z_bruto_t = Σ ΔDI_τ     para todo τ ∈ {dias Copom do mês t}
z_bruto_t = 0            se não houve Copom no mês t
```

Variante purificada: usar `e_DI_τ` em vez de `ΔDI_τ`.

### 5.2 Instrumento JK (com filtro por co-movimento)

Classificar cada dia Copom:

```
Se (e_DI > 0 e e_Ibov < 0) ou (e_DI < 0 e e_Ibov > 0):
    → classificar como "choque monetário"
    → manter e_DI_τ

Se (e_DI > 0 e e_Ibov > 0) ou (e_DI < 0 e e_Ibov < 0):
    → classificar como "choque informacional"
    → zerar: e_DI_τ = 0
```

Agregar mensalmente:

```
z_JK_t = Σ e_DI_τ     para todo τ ∈ {dias Copom monetários do mês t}
z_JK_t = 0            se não houve Copom monetário no mês t
```

### 5.2b Por que soma, e não a ponderação de Gertler-Karadi (2026-07-27)

A soma dentro do mês é o esquema de **Jarociński-Karadi** (2020, §II.A: "*To
construct m_t we add up the intraday surprises occurring in month t on the days
with FOMC announcements*"), e é também o que o código do **Bauer-Swanson** faz.
O **Gertler-Karadi** (2015, nota 11) usa outro: cumular as surpresas num nível
diário → média mensal → primeira diferença, o que pondera por posição no mês.

O GK enuncia a própria motivação **de forma condicional**: a ponderação existe
porque o indicador de política deles é uma **média mensal** ("*as we use monthly
average rates (not end of the month rates) for our monetary policy
indicators…*”). Aqui `yield_6m` é observação de **fim de mês**
(`script/download.R`, seleção pela maior data mensal), caso em que uma surpresa em
qualquer dia de `t` já está integralmente refletida no valor de `t` — que é
exatamente o que a soma assume.

Reestimado em 2026-08-12 (`script/instrument_construction_sweep.R`): sob GK o ξ_mp
cai de **7,65 para 0,11** no vértice de produção e não cruza 3,84 em nenhum
vértice na amostra completa. Além disso, sob GK os meses sem reunião **deixam de
ser zero** (a propriedade que JK e BS assumem) e o esquema induz **MA(1)**, o que
invalidaria `NWlags = 0` no bloco Wald. **A soma fica.**

### 5.3 Output final

Salvar `data/processed/instrumentos_mensais.csv` com as **oito** colunas
produzidas por `script/instrument.R` (estado desde 2026-08-05):

| month | z_bruto | z_bruto_purif | z_jk | z_jk_purif | z_jk_raw_purif | z_jk_raw | z_bs_purif | z_jk_bs_purif |
|---|---|---|---|---|---|---|---|---|

Qualquer uma pode ser plugada no proxy-SVAR via `DEFAULT_VARIANT` em
`script/instrument.R` (produção: `z_jk_bs_purif`).

Duas variantes saíram em 2026-08-05, ambas já declaradas mortas em
`historico_decisoes.md` §2 e sem consumidor em nenhuma varredura viva:
`z_jk_raw_purif_local` (dominada) e `z_jk_purif_us` (redundante, cor 0,999 com
`z_jk_purif`). As quatro variantes por heterocedasticidade (`z_het*`) nunca
foram produzidas por este script; foram arquivadas em 2026-07-26 e a rota inteira
foi abandonada em 2026-08-17 — `arquivo/heterocedasticidade/`, resumo em
`historico_decisoes.md` §1.

> **2026-07-14 — ordem purificação ↔ JK:** constatou-se que o pipeline acima já é "purificação → JK" (a classificação da §5.2 usa os sinais dos *resíduos*). Duas variantes com a ordem inversa (máscara JK nos **sinais brutos** `delta_di` × `r_ibov`, purificação depois) foram adicionadas a `script/instrument.R`: `z_jk_raw_purif` (valores = `e_di` da regressão de painel completo) e `z_jk_raw_purif_local` (regressão re-estimada só nos dias selecionados). No grid MOSW, `z_jk_raw_purif` domina `z_jk_purif` em ξ_mp na amostra **full** (13/14 células; único GK a cruzar 10 em células full) — a máscara bruta exclui `2020-03-19` (pânico COVID classificado como monetário pela máscara residual) — mas perde no pre_covid (6,5) (10.80 vs 13.25); default inalterado, `z_jk_raw_purif` vira robustez full-sample e a `_local` foi descartada (dominada — e removida do código em 2026-08-05). Detalhes: `notas/2026-07-14_ordem_purificacao_jk.md`.

---

## Etapa 6 — Teste de Força do Instrumento

Para cada variante de $z_t$:

- Plugar no proxy-SVAR/DFM existente como instrumento externo
- construir a inovação de `yield_6m` implícita nos fatores, na mesma direção
  usada para normalizar o choque;
- reportar ξ_mp e o primeiro estágio robusto F_rob,mp (HC1), ambos com os lags
  do VAR de fatores como controles;
- implementação: `diagnose_instrument_in_factor_space()` e
  `compute_robust_first_stage_F()`; validação externa em
  `script/validate_olea_kilian.R`.

O valor 10 é uma referência convencional de força, não um valor crítico
fornecido por MOSW. Não se condiciona a apresentação das IRFs à aprovação de
uma das estatísticas: o artigo reporta ambas e qualifica a inferência quando
elas divergem ou ficam abaixo da referência.

> **2026-08-12 — a implementação Anderson-Rubin de 2026-08-10 foi retirada.**
> A régua de força corrente continua sendo ξ_mp, não o F acima, mas as bandas de
> 68% e 90% do wild bootstrap voltam a ser a única inferência operacional do
> DFM. A adaptação plug-in condicionava em fatores e loadings estimados sem uma
> teoria de cobertura para esses objetos gerados e classificava incorretamente
> casos degenerados. O tema fica adiado sem prazo e sem prioridade ativa, até
> existir uma fundamentação teórica ou um procedimento que incorpore a estimação
> fatorial. A rodada retirada permanece documentada como evidência histórica
> superada em `notas/2026-08-10_bandas_anderson_rubin.md`; decisão em
> `historico_decisoes.md` §7.

**Resultados correntes:** em `output/instrument/mosw_strength_grid.{csv,md}`
(8 variantes × 14 células (r,q) × 2 janelas), a produção
`z_jk_bs_purif` dá ξ_mp/F_rob,mp = **7,65/7,95 full** e
**11,53/6,26 pré-COVID** em (7,6). A tabela por variante em uma especificação
DFM comum está em `output/instrument/instrument_diagnostics_report.md` §1.

O grid e o produtor das antigas réguas foram arquivados em 2026-08-05
(`arquivo/output/`, `arquivo/script/`), sem consumidor vivo.

---

## Etapa 7 — Comparação de IRFs

Estimar IRFs no DFM usando cada variante do instrumento. A comparação central é:

1. **$z^{bruto}_t$** vs. **$z^{JK}_t$**: o filtro JK muda as IRFs? Se sim, a decomposição importa — essa é a contribuição empírica principal.
2. **Sem purificação** vs. **com purificação por fatores externos**: a limpeza do componente global importa?

Variáveis de resposta: taxa de câmbio (BRL/USD), Ibovespa, spreads corporativos, CDS Brasil, curva de juros (DI longo), break-even inflation.

Horizonte: 0 a 24 meses. Bandas: 68% e 90%.

---

## Etapa 8 — Robustez

1. ~~**Vértice do DI:** substituir DI 3m por DI 6m e DI 12m~~ — **feito em
   2026-07-27**, e mais amplo do que o prescrito: 13 vértices de 21 a 504 du ×
   2 esquemas de agregação × 5 variantes × 2 janelas, sob **ξ_mp** (a régua
   corrente; o item foi escrito na era em que o baseline era 3m e a régua era o
   F legado). `script/instrument_construction_sweep.R` →
   `output/instrument/instrument_construction_sweep.{csv,md}`.
   **Resultado:** 126 du (produção) **não** é o argmax em nenhuma janela, mas
   nenhum desafiante vence por margem maior que a dispersão leave-one-month-out
   do próprio ξ_mp (maior margem 1,16 contra limiar 2,00), então o vértice **não
   é identificado com precisão suficiente para escolher** e a produção fica.
   E, o que importa mais: **os 13 vértices dão essencialmente a mesma IRF**,
   dentro da banda de 68% em quase todo horizonte
   (`output/instrument/vertex_irf_overlay.pdf`, análogo da Figura A4 de
   Alessi-Kerssenfischer). Ver a §5.2b acima para o eixo de agregação.
2. **Excluir datas FOMC coincidentes** (dropar observações com `fomc_coincide = 1`)
3. **Subamostras temporais:** janelas móveis de 10 anos (2009-2019, ..., 2014-2024)
4. **Threshold de classificação:** excluir dias Copom com surpresas próximas de zero (dentro de ±1 d.p. de um dia não-Copom típico) para reduzir ruído na classificação JK

---

## Escreva um relatório em .md

---

## Referências para implementação

- **Instrumento base (surpresas de DI):** Gertler & Karadi (2015, AEJ:Macro) — lógica do proxy-SVAR com surpresas de futuros
- **Filtro JK:** Jarociński & Karadi (2020, AEJ:Macro) — classificação por co-movimento, restrições de sinal
- **Purificação:** Bauer & Swanson (2023, AER) — controle por fatores pré-anúncio
- **Recuperação do choque por GLS:** Mertens & Ravn (2013, *AER*) §II.B
- **Contexto brasileiro:** Gonçalves, Rodrigues & Genta (2025, IMF WP/25/48) — janela Wed→Thu, dados de DI, testes de Rigobon. É a evidência *alheia* com que o paper dialoga; a rota het **deste** projeto foi abandonada (`arquivo/heterocedasticidade/`)
- **Teste de instrumento fraco:** Montiel Olea, Stock & Watson (2021, *JoE*) — estatística F robusta
- **DFM + proxy-SVAR:** Alessi & Kerssenfischer (2019) — "The Response of Asset Prices to Monetary Policy Shocks: Stronger than Thought" — pipeline de estimação replicado neste projeto
- **Wild bootstrap sob heterocedasticidade MD:** Gonçalves & Kilian (2004)

---

## Informaçoes importantes:

- Todos os artigos de referencia podem ser encontrados em: `artigos/`
- o trabalho de JK ja tem o script original dos autores, mas em matlab em: `codigo_Jarocinski_e_Karadi`
- Os testes do artigo de Montiel Olea, Stock & Watson, ja foram implementados em: `script/instrument_diagnostics.R`
- Código original dos autores Bauer & Swanson em: `codigo_bauer_swanson/`
