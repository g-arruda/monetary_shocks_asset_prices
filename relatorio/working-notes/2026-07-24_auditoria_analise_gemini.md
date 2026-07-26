# Auditoria do relatório do Gemini sobre o instrumento de política monetária (2026-07-24)

> **⚠️ PREMISSA CORRIGIDA — banner de 2026-07-26.** A refutação técnica desta nota continua válida:
> as três críticas conceituais do Gemini são mecanicamente certas mas exageradas, a conclusão
> estatística ("F conjunta < 3 ⇒ inferência inválida") está **errada** (número certo, estatística
> errada — quem governa é ξ_mp, e MOSW alerta explicitamente contra filtrar pelo F), e as duas
> críticas de fidelidade já estavam corrigidas.
> **O que mudou:** a moldura de que "o instrumento foi de fato abandonado" e a recomendação P1
> ("escolher nova identificação primária — sign restrictions") **não valem**. Foram escritas às
> 09h24; a nota das 23h46 do mesmo dia e a produção corrente mantêm o **proxy-SVAR como primário**
> sob (7,6). Os ξ_mp citados são de (6,5) no vintage pré-refresh.


O arquivo `analise_gemini_instrumento.md` atribui o fracasso da identificação por instrumento externo a três fatores estruturais (janela de observação, filtro Jarociński-Karadi em economia emergente, purificação Bauer-Swanson) e a uma conclusão estatística (F conjunta inferior a 3, logo o instrumento reteve mais ruído que sinal e a inferência é inválida). Esta nota verifica cada afirmação contra o código, os artefatos de diagnóstico já gerados e os artigos originais. Nenhum script foi re-executado: toda evidência vem de arquivos existentes, citados por `arquivo:linha` ou por seção das notas de leitura em `artigos/`.

A leitura curta: o Gemini acerta o mecanismo das três críticas conceituais, mas erra a conclusão estatística (o número que ele cita existe, o significado que ele lhe dá está trocado) e desconhece três fatos do projeto que mudam o peso das críticas. As duas objeções de fidelidade de implementação (JK e BS) procedem historicamente e já foram corrigidas no código antes deste relatório existir.

## Sumário dos vereditos

| Afirmação | Veredito | Base |
|---|---|---|
| C1. Janela ~24h quebra a exogeneidade | Correto no mecanismo, exagerado em "destrói" | `di_surprise.R:24-43`, `pendencias.md:9`, teste-F de variância |
| C2. JK confunde risco fiscal com choque monetário | Correto em princípio, parcial na aplicação | notas JK §3-4, `2026-07-14_auditoria_fidelidade_jk_bs.md:79` |
| C3. BS não remove prêmio de risco contemporâneo (curva 5a > 6m em h=0) | Parcialmente correto, interpretação contestada | notas BS, `irf_coherence_report.md:56-60`, notas GRG §6 |
| Conclusão: F conjunta < 3 ⇒ inferência inválida | Incorreta (número certo, sentido errado) | `mosw_strength_grid.md:17-20, 60, 76` |
| Fidelidade da implementação de JK | Crítica procede sobre o insumo, já corrigida | `2026-07-14_auditoria_fidelidade_jk_bs.md:9-28` |
| Fidelidade da implementação de BS | Crítica procede, já corrigida (versão fiel construída) | `2026-07-14_auditoria_fidelidade_jk_bs.md:30-40` |

## Afirmação 1: a janela de observação e a exogeneidade

O fato material está certo. A surpresa de DI é medida do fechamento de quarta ao fechamento de quinta, `(r_thu - r_wed) * 10000` em `R/instrument/di_surprise.R:24-43`. É uma variação de aproximadamente 24 horas, não uma janela intradiária. Os três artigos de referência usam janela de 30 minutos ao redor do anúncio (notas de leitura JK §6, "10 min before to 20 min after", notas BS, "30-minute windows", e Gertler-Karadi da mesma forma). A janela larga capta, além da decisão do Copom, a sessão inteira de quinta-feira, com mercados globais e notícias domésticas.

O próprio autor já chegou a essa conclusão e agiu sobre ela. A justificativa registrada do pivô para heterocedasticidade é textual em `_instrucoes/pendencias.md:9`: "o Copom anuncia ~18h30, após o fechamento, e a janela Wed→Thu de ~24h fragiliza a exclusion restriction do proxy (crítica RS-2004 ao event-study)". A crítica do Gemini coincide com o diagnóstico interno.

O exagero está na palavra "destrói". Três evidências limitam o alcance da crítica. Primeiro, o precedente brasileiro direto, Goncalves, Rodrigues e Genta (2025, IMF WP), usa exatamente a mesma janela Wed→Thu (notas GRG §4) e é um trabalho publicável. A solução deles não é encurtar a janela, é abandonar a zero-restriction do event-study e identificar por heterocedasticidade. Segundo, o projeto atenua a contaminação global com duas purificações, a contemporânea por SP500/VIX/Brent (`script/instrument.R:218`) e a pré-evento estilo Bauer-Swanson (`script/instrument.R:257-273`). Terceiro, o teste-F de razão de variâncias em `output/instrument/instrument_diagnostics_report.md` §3 mostra Var(e_DI) em dias de Copom igual a 174 contra 61,5 nos demais dias, uma razão de 2,83 com p = 2,4e-13, enquanto a variância do Ibovespa residual não difere entre os dois grupos (razão 1,12, p = 0,43). A janela larga ainda isola um sinal de política concentrado nos dias de Copom. Não é ruído puro.

Veredito: correto que a janela enfraquece a exclusion restriction, que é a razão do abandono do proxy como identificação primária. Incorreto que ela destrua a exogeneidade a ponto de tornar o sinal inaproveitável.

## Afirmação 2: o filtro JK em economia emergente

O mecanismo apontado está certo. O filtro de Jarociński e Karadi separa dois choques, e apenas dois: o choque monetário puro (co-movimento negativo entre juros e bolsa) e o choque de informação do banco central (co-movimento positivo). As notas de leitura JK §3-4 e a implementação Bayesiana em §4 deixam explícito que não existe uma terceira categoria de "risco" ou "fiscal". Um choque de risco soberano que faz a curva abrir e a bolsa cair produz co-movimento negativo, a mesma assinatura do aperto monetário, e por isso é classificado como monetário pela regra JK. A objeção é uma limitação real de JK aplicado a um emergente com prêmio de risco volátil.

A aplicação ao projeto é parcial por dois motivos. O caso de contaminação que o projeto de fato encontrou tem micro-mecanismo diferente do que o Gemini descreve. O dia 2020-03-19 (pânico da COVID, Ibovespa bruto +2,13%, co-movimento positivo, logo informacional pela regra crua) foi classificado como monetário pela máscara residual, porque a purificação contemporânea inverteu o sinal do Ibovespa residual, não porque um choque de risco fiscal tenha imitado a assinatura monetária. O diagnóstico está em `relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md:79`. As máscaras predeterminadas (`z_jk_raw` e `z_jk_bs_purif`) excluem esse dia e ganham força, com ξ_mp subindo de 5,20 para 6,94 na amostra completa em (r=6, q=5), conforme `output/instrument/mosw_strength_grid.md:60, 102`. O projeto já diagnosticou e corrigiu uma contaminação de pânico, mas por uma via distinta da que o Gemini imagina.

Há também contra-evidência de que o instrumento não é "pânico rotulado como política monetária". As IRFs de produção têm o bloco de atividade coerente em 9 de 9 variáveis e a curva inteira coerente_forte (`output/irf/irf_coherence_report.md:56-60, 95-103`), o que seria improvável se o instrumento fosse dominado por um choque de risco. Os testes anti-JK (F = 0,194 sobre os dias de co-movimento igual) e de máscara aleatória (T5 e T6, `_instrucoes/pendencias.md:50-56`) mostram que a máscara carrega sinal, não é só esparsificação.

Veredito: a crítica está certa como limitação de método (JK não separa risco fiscal de choque monetário em emergente), mas parcial como diagnóstico do projeto, porque a contaminação dominante teve outra origem e já foi tratada, e porque as IRFs coerentes de atividade contrariam a leitura de "instrumento igual a pânico".

## Afirmação 3: a purificação Bauer-Swanson

A descrição de BS está certa. Bauer e Swanson ortogonalizam a surpresa contra notícias pré-anúncio, releases macro e tendências financeiras das 13 semanas anteriores, nunca contra variações contemporâneas da janela (notas BS, lista de preditores, equação 7). Por construção, a purificação BS não remove prêmio de risco que entra na própria janela.

A crítica é incompleta em dois pontos. O projeto também roda uma purificação contemporânea (SP500/VIX/Brent da mesma janela, `script/instrument.R:218`), que remove parte do prêmio de risco global contemporâneo. O Gemini ignora essa segunda regressão e critica BS por não fazer algo que outra etapa do pipeline faz. O que nenhuma purificação remove é o prêmio de risco doméstico contemporâneo (EMBI, câmbio, curva de DI dentro da janela), e não pode remover: incluir essas variáveis seria bad control, porque elas respondem ao próprio choque (`2026-07-14_auditoria_fidelidade_jk_bs.md:39`). O núcleo da crítica, que o resíduo retém risco doméstico contemporâneo, procede e é estrutural, mas a saída implícita do Gemini, purificar mais, é inviável sem introduzir viés.

O fato empírico que o Gemini usa como prova é real. Em h=0 a curva sobe mais na ponta longa que na curta: yield_3m +32bp, yield_2y +84bp, yield_5y +87bp, yield_10y +78bp, com o normalizador yield_6m fixado em +50bp (`output/irf/irf_coherence_report.md:56-60`). A ponta de 5 anos sobe mais que a de 6 meses, como o Gemini afirma.

A interpretação é o ponto contestado. O projeto lê esse padrão como transmissão de dominância fiscal coerente para o Brasil (Blanchard 2004, GRG 2025): a curva é coerente_forte, o câmbio deprecia (+0,185 no impacto), o EMBI abre +25bp e o CDS abre +34bp (`irf_coherence_report.md:56-60, 164-167`). Vale a qualificação de que, na rodada de produção com `z_jk_bs_purif`, esses três canais de risco e câmbio não são significantes a 90% no impacto (coluna `right_sig90 = FALSE` em `irf_coherence_report.md:164-167`). A significância a 90% que aparece na leitura interpretativa do arquivo vem da rodada antiga com `z_jk_purif`, marcada como desatualizada. A memória `project-shock-contamination-diagnosis` registra a mesma leitura de sinal: assinatura coerente para o Brasil, não invertida. O problema é que o benchmark direto, GRG (2025), encontra o oposto no diário identificado por heterocedasticidade: o CDS não responde e o Real aprecia (notas GRG §6, Tabela 5), e os autores rejeitam a dominância fiscal pura. A divergência está registrada em `_instrucoes/pendencias.md:135`. A leitura de contaminação do Gemini não é implausível, porque o único benchmark brasileiro comparável discorda justamente na dimensão risco-câmbio. Ao mesmo tempo, a não-significância dos canais de risco na rodada de produção enfraquece tanto a leitura forte de dominância fiscal quanto a de contaminação: o dado é o sinal do ponto, não uma resposta significante. O paper precisa tratar essa divergência de frente, não descartá-la.

Veredito: parcialmente correto. A observação sobre BS é válida mas incompleta, e o remédio implícito é inviável. O fato da curva é real, e a interpretação como anomalia de contaminação continua em disputa aberta com a leitura de dominância fiscal, com o benchmark GRG dando alguma sustentação ao Gemini.

## A conclusão estatística: F conjunta inferior a 3

O número que o Gemini cita existe. A F conjunta (ξ/q) de `z_jk_bs_purif` na amostra completa em (6,5) é 1,747 (`output/instrument/mosw_strength_grid.md:60`), e fica na faixa 1,5 a 2,4 para quase todas as variantes. A afirmação "F conjunta inferior a 3" é literalmente verdadeira para essa estatística.

O significado atribuído está trocado. A F conjunta divide a não-centralidade da estatística de Wald por q graus de liberdade, e o próprio relatório de força explica a leitura em `mosw_strength_grid.md:17-20`: um valor baixo de F conjunta acompanhado de ξ_mp alto indica relevância concentrada na direção certa, que é o padrão esperado sob exogeneidade, não sinal de ruído. A estatística que governa a inferência na direção da normalização é ξ_mp, o análogo do `Waldstat` oficial de Montiel Olea, Stock e Watson na direção de impacto de yield_6m. Para `z_jk_bs_purif`, ξ_mp é 6,94 na amostra completa e 12,49 na janela pré-COVID em (6,5) (`mosw_strength_grid.md:60, 76`). Os dois valores estão acima de 3,84, o limiar em que o conjunto de Anderson-Rubin passa a ser um intervalo limitado (notas OSW §4.2, "bounded iff ξ_1 > 3.84"). O conjunto AR limitado significa inferência válida, fraca na amostra completa e forte na janela pré-COVID.

Montiel Olea, Stock e Watson advertem explicitamente contra a operação que o Gemini faz. A recomendação do artigo (notas OSW §4.2, footnote 6) é reportar o F e usar rotineiramente os conjuntos AR robustos, não condicionar a inferência a um pré-teste no F, porque o screening no F distorce o tamanho do teste. Declarar a inferência inválida a partir da F conjunta baixa é o oposto do que o método prescreve. A caracterização correta é: instrumento fraco na amostra completa, exigindo bandas Anderson-Rubin, e forte na janela pré-COVID.

Uma ressalva de justiça: as variantes identificadas por heterocedasticidade (z_het, z_het_3var) têm ξ_mp inferior a 3,84 na amostra completa, com conjunto AR possivelmente ilimitado (`mosw_strength_grid.md:71-72`). Se a frase do Gemini se referisse a essas variantes, estaria correta. Mas elas não são o instrumento de produção.

Veredito: incorreta. O instrumento de produção é fraco mas utilizável com bandas AR na amostra completa, e forte na janela pré-COVID. Não houve colapso estatístico.

## Fidelidade da implementação de JK e BS

Este é o ponto que o autor pediu para verificar diretamente. A fonte é a auditoria interna do projeto contra os artigos e o código original dos autores, em `relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md`, conferida contra as notas de leitura.

Sobre JK, a regra é fiel e o insumo era infiel à época em que o Gemini escreveu. A regra de zerar dias de co-movimento positivo e a agregação por soma mensal reproduzem o poor man's original (notas JK §5, `script/instrument.R:228-233, 299-309`). O poor man's de JK, porém, classifica e agrega valores brutos da surpresa, enquanto o default histórico `z_jk_purif` classificava e agregava resíduos da purificação contemporânea (`2026-07-14_auditoria_fidelidade_jk_bs.md:9-28`). A objeção de fidelidade sobre o insumo procede. Ela já foi endereçada: a variante literal `z_jk_raw` (máscara bruta e valores brutos) foi construída, e o default de produção mudou para `z_jk_bs_purif` em 2026-07-15, que carrega máscara predeterminada.

Sobre BS, o nome estava errado, e o procedimento hoje está certo. A regressão que o projeto chamava de "purificação Bauer-Swanson" usava SP500/VIX/Brent contemporâneos da mesma janela, o que é uma limpeza de fator global, não a ortogonalização de BS, que usa apenas preditores pré-anúncio (`2026-07-14_auditoria_fidelidade_jk_bs.md:30-40`, notas BS). A crítica de que aquilo não era BS procede. Ela também já foi endereçada: a versão fiel foi construída em `script/instrument.R:257-273`, com tendências financeiras de 65 dias, revisões do Focus de 20 dias e tendência linear, tudo predeterminado na quarta-feira, gerando `z_bs_purif` e `z_jk_bs_purif`. O default de produção é a versão fiel a BS.

Há uma nuance que o Gemini erra. BS e a limpeza global contemporânea tratam contaminações diferentes: BS ataca a previsibilidade ex-ante da surpresa (a reação do banco central a notícias já publicadas, que viola a exogeneidade), e a limpeza contemporânea ataca o choque global que entra na janela larga (que violaria a zero-restriction do HFI). O Gemini funde as duas e cobra de BS a remoção de algo que BS nunca se propôs a remover.

Veredito sobre implementação: as duas críticas de fidelidade estavam certas quando apontadas e já foram corrigidas no código, com as variantes fiéis construídas e promovidas a default. O que resta em aberto não é fidelidade de implementação, é a limitação conceitual dos dois métodos em economia emergente, discutida nas afirmações 2 e 3.

## O que o Gemini acertou, superestimou e ignorou

O que acertou. A janela larga enfraquece a exclusion restriction (C1), coincidindo com o diagnóstico do autor. O filtro JK não separa risco fiscal de choque monetário em emergente (C2), como limitação de método. A purificação pré-evento não remove risco contemporâneo (C3), no conceito. As duas objeções de fidelidade de implementação também procedem.

O que superestimou. Chamou a janela de destruidora da exogeneidade quando o sinal Copom sobrevive com razão de variância 2,83. Concluiu inferência inválida a partir da F conjunta, que é a estatística errada para essa leitura.

O que ignorou. O instrumento de produção alcança ξ_mp 12,49 na janela pré-COVID, faixa de instrumento forte. O projeto já diagnosticou e corrigiu a contaminação de pânico de 2020-03-19. Existe uma purificação contemporânea além da BS. O padrão de curva é o resultado de dominância fiscal pretendido, em disputa aberta com GRG, não uma anomalia autoevidente. E o instrumento não foi abandonado por colapso estatístico.

## Contexto: por que o instrumento foi de fato abandonado

O instrumento não caiu por fraqueza estatística. Ele foi retirado da identificação primária por julgamento do autor sobre a exclusion restriction (a janela de 24 horas, a mesma crítica C1) somado à reprovação empírica da heterocedasticidade como identificação primária na frequência mensal. Os testes de viabilidade em `_instrucoes/pendencias.md:11-14` mostram que a proporcionalidade Σ_C ∝ Σ_NC nunca é rejeitada em regimes de calendário nem em regimes de episódio, o que remove a condição de posto da identificação mensal por heterocedasticidade.

O estado atual é uma decisão em aberto sobre a nova identificação primária (`pendencias.md:16`), com o menu de sign restrictions, recursiva ou não-gaussianidade, sem instrumento e sem heterocedasticidade. As soluções abaixo partem desse estado.

## Soluções priorizadas

P1. Escolher a nova identificação primária, o item que destrava o paper. A recomendação é sign restrictions como identificação principal, combinada com o SDFM (Uhlig 2005 ou Arias, Rubio-Ramírez e Waggoner 2018, ou a versão frequentista de Gafarov, Meier e Montiel Olea). O ganho direto contra C2: as sign restrictions deixam o sinal de câmbio e risco irrestrito e restringem apenas juros para cima, atividade para baixo e preços para baixo, sem pré-julgar dias de risco fiscal como monetários, que é a exata patologia do filtro JK em emergente. Passo barato antes de decidir: rodar o diagnóstico de não-gaussianidade sobre as inovações de fator η (testes de normalidade de Lanne, Meitz e Saikkonen), que é quase gratuito a T = 147 e indica se ICA é viável.

P2. Salvar o proxy como robustez com a inferência certa, respondendo à conclusão de F baixa. Reportar bandas Anderson-Rubin para o proxy na amostra completa, onde ξ_mp = 6,94 fica abaixo de 10 (já é pendência aberta em `pendencias.md:68-70`), e liderar com a janela pré-COVID, onde ξ_mp ≥ 12 dispensa a correção. O protocolo anti-screening de Montiel Olea, Stock e Watson (reportar ξ_mp e usar AR, nunca condicionar no F) neutraliza documentalmente a alegação de inferência inválida.

P3. Fortalecer contra C2. Manter a máscara predeterminada (`z_jk_bs_purif` ou `z_jk_raw`), que exclui o pior dia de pânico (2020-03-19) e domina o default antigo na amostra completa, e citar os testes anti-JK (F = 0,194) e de máscara aleatória (T5 e T6) como evidência de que a máscara carrega sinal. Documentar de forma explícita que JK não separa risco fiscal de choque monetário, o que é a razão de a identificação primária de P1 não depender do sinal isolado de juros contra bolsa.

P4. Enfrentar C3 de frente, sem esconder a curva. Apresentar o padrão de ponta longa acima da curta somado à depreciação e à abertura do CDS como resultado de dominância fiscal, com o contraste GRG (apreciação e CDS estável) como discussão central. Testar se a divergência vem da frequência (mensal em equilíbrio geral contra diário), da amostra (regime fiscal 2020-2025) ou de contaminação, usando a robustez pré-COVID como árbitro. Ajuste menor conexo: incluir um preditor de metais na purificação, dado que o placebo `commodity_metal` está violado (`pendencias.md:94-97`).

P5. Registrar a limitação de dados como caveat honesto sobre C1. A janela intradiária de DI resolveria C1 na origem, mas os dados de tick de DI não estão disponíveis. Documentar isso como limitação e justificar a escolha de uma identificação (sign restrictions ou heterocedasticidade) que não depende da zero-restriction de 30 minutos, que é o que GRG faz para o Brasil.
