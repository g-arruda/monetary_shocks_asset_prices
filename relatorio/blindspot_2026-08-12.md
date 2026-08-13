# Blindspot Report

**Output:** `paper/paper_anpec.tex` e a saída de produção que ele interpreta —
`output/irf/irf_coherence_h.csv` (53 séries × h = 0-48, bandas 68/90),
`output/irf/spec_sweep_irf_long.csv` (8 instrumentos × 4 dimensões × 2 janelas),
`diagnostics/output/t2_1_irf_todas_variaveis.csv` (as 106 séries do painel).
**Date:** 2026-08-12

**Regra de leitura deste relatório.** Marco cada achado como **[NOVO]** ou
**[JÁ REGISTRADO]**. Os `[JÁ REGISTRADO]` estão em `registro/pendencias.md` como
item aberto — repito só o que confirmei numericamente, para não devolver notícia
velha. Tudo o que segue foi conferido contra os artefatos; nenhum número aqui é
citado de memória ou de nota.

---

### Vice 1: The Unexplained Feature

- **Objeto e unidade de variação:** painel de funções impulso-resposta mensais de
  um SDFM identificado por instrumento externo. A unidade primária é o
  **horizonte** (h = 0-48); as unidades secundárias, que o paper quase não
  percorre, são a **série** (106 no painel, 53 pontuadas, 20 reportadas), a
  **janela amostral** (cheia vs. pré-COVID) e a **frequência** (o mesmo choque
  existe em diário e em mensal).

- **Feature mais difícil de explicar, enunciada como feature:** *a taxa básica de
  juros nunca sobe.* `juros_selic` (meta em % a.a. — média 9,67, mín 1,90, máx
  14,90 no painel) responde **−4,7 pb no impacto**, −5,9 pb em h = 1, cruza para
  positivo em h = 2, atinge o **máximo de +12,9 pb em h = 7** e **não exclui zero
  nem na banda de 68% em nenhum horizonte positivo**. Depois disso vira negativa
  e chega a −77,8 pb em h = 34, aí sim com banda de 68%. O CDI é idêntico no
  terceiro dígito.

- **Explicação tentada:** o paper e o registro têm uma explicação, e ela cobre
  **apenas h = 0** — a nota da `fig:curva` (`:339`) diz que a Selic mensal é
  *overnight* acumulada e "não incorpora uma surpresa de 6 meses medida em um
  único pregão", e `irf_section.md:131` repete a mesma leitura de descasamento de
  maturidade. Isso justifica o impacto. **Não justifica h = 3, h = 6, h = 12**,
  onde o próprio modelo diz que o mercado precificou +73,5 pb no vértice de 1 ano
  e +91,6 pb no de 2 anos: se essa trajetória esperada se realizasse, a meta teria
  de subir dentro do ano, e ela sobe no máximo 12,9 pb, sem banda.
  O problema não é o número em si — é que **o mesmo texto usa a série nas duas
  direções**. A §4.1 (`:347`) lê o ramo negativo como resultado substantivo ("A
  própria taxa de política acompanha essa reversão... indicando afrouxamento"),
  enquanto a nota da figura lê a mesma série como controle negativo incapaz de
  registrar o choque. Uma série não pode ser cega ao aperto e sensível ao
  afrouxamento. As duas leituras não coexistem.

- **Resolved?** **FLAG.** Resolve-se com uma frase, não com uma rodada: ou a Selic
  é controle negativo em todo horizonte — e então o parágrafo de reversão da §4.1
  perde a Selic e o CDI e fica só com os cinco vértices —, ou ela é informativa —
  e então a ausência de alta é um fato do resultado e precisa ser reportada.
  **[NOVO]** — o registro documenta o −4,8 pb do impacto (`irf_section.md:131`) e
  documenta a reversão (`pendencias.md:246`), mas em nenhum lugar os dois estão na
  mesma frase.

- **Findings:**

  1. **[NOVO] Todo o bloco financeiro tem pico em h = 1, não no impacto — e as
     explicações mundanas foram testadas e falham.** Não é uma série: são as 19.
     Razão h1/h0: vértices 1,14-1,17; `cambio_usd` 1,29; `cambio_eur` 1,32;
     `cds_5y` 1,10; `embi_perc` 1,01; ações 1,54-2,61 (nas ações é em parte
     mecânico, tcode 2 acumulado — nas demais, todas em nível, não é).
     Testei as três causas triviais: (i) *média intramensal* — não se aplica, os
     yields entram por observação de fim de mês (`script/download.R:51-52`);
     (ii) *desalinhamento de mês do instrumento* — não existe, 62 meses com
     instrumento não-nulo e 62 quintas-feiras retidas, interseção perfeita;
     (iii) *reuniões concentradas no fim do mês* — não, os 62 dias se distribuem
     23/20/19 pelos terços do mês, e só 9 caem nos últimos 5 dias corridos.
     Sobra a dinâmica estimada do VAR de fatores. **Consequência prática
     imediata:** o número-manchete do paper, os 3,64% de depreciação, é o valor de
     **h = 0**; o pico do próprio câmbio é **4,71% em h = 1** (0,1937/4,112). O
     paper reporta h = 0 no câmbio e h = 1 nas ações — a convenção de horizonte
     muda de bloco para bloco, e em cada bloco calha de ser a que o texto quer.

  2. **[NOVO] A amplificação da ponta longa não aparece na pegada diária do
     próprio choque.** A §4.1 e o resumo afirmam repasse crescente com a
     maturidade até 5 anos, "superior à documentada em economias desenvolvidas".
     Rodei o estudo de evento diário nos **mesmos 62 dias retidos**, com a
     **mesma surpresa ortogonalizada** (`e_di_bs`), sobre a **mesma curva de
     Svensson que alimenta o painel** (`data/raw/yields/yields_dia.csv`, n = 60
     após casar datas):

     | vértice | DFM mensal h = 0 (norm. 6m = 1) | evento diário (norm. 6m = 1) | razão |
     |---|---|---|---|
     | 3m  | 0,558 | 0,654 (t 14,4) | 0,9 |
     | 1a  | 1,471 | 1,206 (t 17,0) | 1,2 |
     | 2a  | 1,833 | 1,091 (t  9,6) | 1,7 |
     | 5a  | 1,855 | 0,631 (t  4,6) | **2,9** |
     | 10a | 1,617 | 0,375 (t  2,6) | **4,3** |

     Repeti sobre o ajuste Svensson do próprio projeto
     (`data/raw/curva_juros/series_maturidades_fixas.csv`): 0,606 / 1,203 / 1,129
     / 0,763 / 0,433 — mesmo formato. **A ponta curta bate quase exatamente entre
     as duas frequências; a ponta longa não bate em nada.** No dia do anúncio o
     repasse é corcova com pico em 1 ano e **decai** — o padrão de todo mundo,
     inclusive dos desenvolvidos com que o paper se compara. A monotonia até 5
     anos é fenômeno do mensal. Isso não é fatal, e pode ser a melhor coisa do
     paper: ver Virtue 1.

  3. **[NOVO — e este é um defeito de dado, não de percepção] O arquivo diário
     de yields não está ordenado, e `slice_tail(n = 1)` está pegando o dia
     errado do mês em 23 dos 153 meses da amostra.** `script/download.R:51-52`
     agrupa por mês e toma a última **linha** do grupo, sem `arrange(data)`;
     `data/raw/yields/yields_dia.csv` tem 28 quebras de ordenação a partir de
     2023. Resultado: em 2023-01 a 2023-11, 2024-01 a 2024-03 e 2025-01 a
     2025-09 a "observação de fim de mês" é o dia 4 a 12. O erro de medida é da
     ordem do efeito estimado: **|erro| médio de 84 a 99 pb por vértice, máximo
     de 310 pb** (2023-01 entra com a curva do dia 12, que estava 290 pb abaixo
     da do dia 31 no vértice de 6 meses).
     Três razões para isso não ser detalhe:
     - atinge **`yield_6m`, a variável de normalização** — todo número de
       magnitude do paper é dividido por ela;
     - atinge os 15% mais recentes da amostra, incluindo 2025 inteiro;
     - **8 reuniões do Copom, 6 delas entre as 62 retidas** (2023-03-23,
       2023-06-22, 2024-03-21, 2025-01-30, 2025-03-20, 2025-09-18), caem em meses
       cuja observação de curva **é anterior à reunião**. Nesses meses o "impacto"
       do bloco de juros é medido antes do choque, o que atenua h = 0 e desloca
       resposta para h = 1 — exatamente o Finding 1, ao menos no bloco de juros.
     E há um custo metodológico além do numérico: `R/instrument/build_variants.R:28-38`
     justifica a agregação por **soma** (em vez do esquema Gertler-Karadi de
     dividir entre t e t+1) precisamente sobre a premissa de que "`yield_6m` é uma
     observação de FIM DE MÊS, para a qual uma surpresa em qualquer ponto do mês t
     já está plenamente refletida". Em 23 meses a premissa é falsa e em 6 deles é
     falsa na direção que importa.
     Correção: uma linha (`dplyr::arrange(data)` antes do `group_by`, ou trocar
     `slice_tail(n = 1)` por `slice_max(data, n = 1)`). **Não re-rodei o pipeline
     — não sei de quanto as IRFs se movem.** O DFM extrai fatores comuns de 106
     séries e pode absorver bem 6 séries com ruído em 15% dos meses; mas isso é
     uma conjectura, não um resultado, e a variável de normalização não é uma
     série qualquer.

  4. **[NOVO] Os dois agregados de atividade do painel discordam de sinal no
     impacto:** `ibc_br` −0,39% (sig68) e `pib` **+0,16%** (não significativo). Há
     explicação mundana e provavelmente ela basta — "PIB acumulado no ano" (BCB
     4381) é acumulado móvel e sua resposta de impacto não é comparável —, e o
     registro já conta que o PIB saiu da §4 por erro de unidade de ~7×. Mas se o
     PIB algum dia voltar ao texto, o sinal precisa vir com a explicação junto.
     **Resolvido, com ressalva.**

  5. **[NOVO] A magnitude dos placebos não é lida, só contada.** O `epu_us` cai
     **18,1% da média amostral no impacto** com banda de 68%, e a série
     `sp500_vix` cai **10,7% em h = 2 com banda de 90%**. A contagem de
     horizontes passa (1 rejeição a 90% em 49, contra ~5 esperadas), e o texto
     está certo na contagem — mas um choque monetário brasileiro que derruba a
     incerteza de política dos EUA em 18% não é um resultado que se descreve só
     por contagem. Ver Virtue 1 para o que essa constelação de fato oferece.

---

### Vice 2: The Convenient Absence

- **Missing checks identified:**
  - **[NOVO] Nenhuma IRF em subamostra, em lugar nenhum do paper.** A janela
    pré-COVID aparece uma vez, na `tab:rq_sweep`, **só para ξ_mp**. Os pontos
    pré-COVID já existem em `output/irf/spec_sweep_irf_long.csv` (etapa 1, sem
    bandas) para a célula de produção, e não são neutros — ver Virtue 2 para os
    que ajudam e a lista abaixo para o que muda de leitura.
  - **[NOVO] A §4.5 nunca diz que o *price puzzle* é da amostra cheia.** Célula
    (7,6) × `z_jk_bs_purif`, `price_ipca`: cheia h6 **+0,099**, h12 −0,077;
    pré-COVID h6 **−0,281**, h12 **−0,203**, h24 −0,121. Na janela pré-COVID o
    sinal é o de manual, e a §4.5 — que hoje abre com "toda resposta de preço que
    exclui zero a 90% é positiva" e chama a desinflação de "evidência mais fraca
    de toda a seção" — está descrevendo um fenômeno de amostra cheia sem dizer
    que ele é de amostra cheia. O projeto sabe disso
    (`notas/2026-07-12_price_puzzle_ipca.md`, e a memória de sessão registra
    "price puzzle full-sample (COVID)"). **O paper não sabe.**
  - **[NOVO] Nenhuma variação de estimador.** As três subseções da §5 variam a
    receita do instrumento (exogeneidade, confundidor soberano, FOMC). Nenhuma
    varia amostra, dimensão (a tabela varia (r,q) só para ξ_mp, não para IRF) ou
    estimador. LP-IV está aberto no Tema B há semanas.
  - **[JÁ REGISTRADO] `sp500_vix` é só o VIX** — confirmado: média 17,87, sd
    6,47 no painel processado. A §5.1 (`:518`, `:530`) descreve "o retorno do
    S&P 500 combinado à variação do VIX" e o painel não tem nenhuma série de
    nível do S&P 500.

- **Missing subgroups (traduzido para a unidade de variação deste output — a
  série e a janela, já que não há grupos de tratamento):**
  - **[NOVO] 53 das 106 séries do painel nunca são pontuadas**, e blocos inteiros
    não aparecem em lugar nenhum da §4: **agregados monetários** (7 séries),
    **três das cinco taxas de câmbio**, **sete dos oito índices EPU**, commodities
    agro e energia, consumo de energia e combustíveis (10), emprego formal
    regional (5), IPC/IPC-núcleo/INCC. Duas dessas ausências não são inócuas —
    ver Virtue 2 (câmbio) e o item seguinte (EPU).
  - **[NOVO] Dos 8 índices EPU do painel, exatamente 1 é usado como placebo, e é
    um que passa.** Os outros sete estão estimados e disponíveis em
    `diagnostics/output/t2_1_irf_todas_variaveis.csv`. O `epu_canada` responde
    **−18,25% no impacto com a banda de 90% excluindo zero** — uma rejeição de
    placebo. Pela régua de contagem do próprio paper (~5 rejeições esperadas por
    série a 10% nominal) uma rejeição isolada é ruído, e é assim que deve ser
    reportada; o problema não é a rejeição, é que **a série de placebo foi
    escolhida depois de as IRFs existirem, entre oito candidatas, e só a escolhida
    aparece**. Mostrar as oito custa uma frase e fecha a porta.

- **Unexplained N changes:** nenhuma encontrada nas comparações que o paper faz.
  As duas variações de amostra declaradas estão declaradas: o painel aumentado da
  §5.1 roda com 200 réplicas em vez de 800 e com ξ_mp caindo a 7,87, e o texto diz
  as duas coisas. A diferença 156 vs. 147 meses (`:518` vs. `:242`) é calendário
  vs. alinhamento e o texto qualifica ("do calendário"). Nada a apontar aqui.

- **Findings:** a §5 é honesta dentro do que escolhe testar, e o que ela escolhe
  testar é sempre **o instrumento**. Nenhuma linha do paper pergunta se o
  resultado sobrevive a mudar a amostra. Isso é notável porque a resposta, nos
  artefatos que já existem, é majoritariamente **sim** — e em duas dimensões é
  *melhor* que na amostra cheia. Ver Virtue 2.

---

### Virtue 1: The Unasked Question

- **Heterogeneity opportunities:**
  - **[NOVO] A diferença diário-vs-mensal na curva não é um problema: é o
    mecanismo, e é mensurável.** No dia do anúncio, o repasse aos 5 anos é 0,63-0,76
    do repasse aos 6 meses e aos 10 anos é 0,38-0,43 — expectativa pura, curva que
    decai. No fim do mês, os mesmos vértices estão em 1,86 e 1,62. **A
    amplificação da ponta longa não acontece na janela do anúncio; ela se acumula
    ao longo do mês** — o mesmo mês em que o CDS abre 29,1 pb e o EMBI+ 20,0 pb
    com banda de 90%. Isso é exatamente a tese do paper, e hoje ela é sustentada
    por uma comparação com Gertler-Karadi que compara objetos diferentes (repasse
    a crédito corporativo americano vs. amplificação de curva soberana) e em bases
    diferentes (50 pb vs. 100 pb) — as duas coisas já apontadas no council de
    2026-08-10 e abertas em `pendencias.md`. A decomposição interna substitui uma
    comparação frágil por uma medição própria, com o mesmo instrumento, na mesma
    curva, sem dado novo e sem chave nova no `.bib`. **É o achado com maior razão
    valor/custo deste relatório.**
  - **[NOVO] Há um paper dentro do paper na assimetria de janela do bloco
    acionário.** Célula de produção, `asset_ibov` no impacto: **−1,67% na amostra
    cheia e −6,64% na pré-COVID** (ponto). O nulo acionário que o resumo e a §6
    reportam como característica do resultado é um nulo *de amostra cheia*, na
    janela em que o instrumento é mais fraco (ξ_mp 10,43 contra 12,22). O registro
    já concluiu que o nulo é mecânico (representação, `historico_decisoes.md` §3.1)
    e a proibição do CLAUDE.md sobre o `cumsum` continua valendo — nada disso é
    contrariado por reportar que o ponto quadruplica fora da COVID.

- **Mechanism evidence:**
  - **[NOVO] A ponte quantitativa entre "amplificação" e "prêmio de risco" está
    nos números e não é feita.** O excesso do vértice de 5 anos sobre a
    normalização é **42,7 pb** (92,7 − 50,0) e o CDS soberano de 5 anos abre
    **29,1 pb** no mesmo horizonte — mesma maturidade, mesmo choque. Hoje a §4.1
    diz "esse prêmio carrega no vencimento longo" sem nenhum número ao lado.
    Ressalva obrigatória se for escrito: o CDS é denominado em dólar e a curva DI
    em real, então isso é comparação de magnitude, **não identidade contábil** —
    é a versão em espaço de curva do item "Decomposição do *wedge* de UIP"
    (`pendencias.md` Tema B, prioridade alta).
  - **[NOVO] O número inconveniente que acompanha, e que precisa ir junto:**
    `epu_brazil` **não sobe**. −3,39% no impacto, +4,4% em h = 1, banda de 68% em
    um único horizonte (h = 4), nunca 90%. Se o canal é notícia de
    sustentabilidade fiscal, a incerteza de política doméstica é a variável de
    mecanismo mais óbvia do painel e ela está muda. Isso não derruba o resultado
    — EMBI+ e CDS são preço, EPU é contagem de notícia —, mas escrever a ponte do
    item anterior sem esta linha seria o *cherry-picking* que o próprio projeto
    proíbe.

- **Secondary findings:** os agregados monetários (Virtue 2) e as cinco moedas
  (Virtue 2) são, os dois, resultados de primeira ordem escondidos em séries não
  pontuadas.

- **Findings:** o paper está contando a segunda história mais interessante da
  sua própria saída. A mais interessante é que **a expectativa e o prêmio se
  separam por frequência dentro do mesmo instrumento** — e o dado para mostrar
  isso está em disco.

---

### Virtue 2: The Unexploited Strength

- **Undersold design features:**
  - **[NOVO] O painel tem cinco taxas de câmbio e o paper reporta duas.** No
    impacto, todas as cinco depreciam o real com a **banda de 90% excluindo
    zero**, e a magnitude é praticamente a mesma:

    | par | impacto | sig90 |
    |---|---|---|
    | BRL/USD | **+3,64%** | h = 0-4 |
    | BRL/EUR | +3,10% | h = 0-3 |
    | BRL/CNY | **+3,55%** | h = 0-4 |
    | BRL/INR | **+3,36%** | h = 0-4 |
    | BRL/ARS | +4,07% | h = 0-4 |

    O EUR sozinho é um controle fraco — EUR/USD comovem. **CNY e INR são o par
    discriminante:** nenhuma história de "fortalecimento do dólar" produz o real
    depreciando 3,4-3,6% contra o yuan e a rupia ao mesmo tempo. O resultado
    central do paper é, no dado, **um resultado do real e não do dólar**, e o
    paper não diz isso. Custo: uma frase na §4.2 e uma coluna na figura. É a
    melhoria mais barata disponível para a alegação-manchete.
  - **[NOVO] A janela pré-COVID favorece o bloco de risco e o paper não usa.**
    Célula de produção, pontos: `cds_5y` **34,10 pb pré-COVID contra 29,07**
    cheia; `embi_perc` **0,376 contra 0,200** (quase o dobro); `cambio_usd` 0,102
    contra 0,150 (mesmo sinal, ~2/3). A janela em que o instrumento é mais forte
    (ξ_mp 12,22) é a janela em que o risco soberano responde mais. Reportar exige
    honestidade nos dois outros itens da mesma comparação: a amplificação de
    curva cai de 1,86 para **1,29** e a resposta acionária quadruplica em módulo.
    Os três juntos, ou nenhum.
  - **[NOVO] Um bloco inteiro com o sinal certo está fora do paper.** Agregados
    monetários no impacto: base monetária **−1,72%**, M1 −1,44%, M2 −1,02%,
    **M3 −1,02% com banda de 90% (h = 0-1, e 68% até h = 13)**, meios de pagamento
    −0,63%. Todos negativos, como manda o efeito liquidez. Um paper que dedica
    uma subseção ao crédito sustentada em banda de 68% está deixando de fora o
    bloco onde a previsão teórica é menos ambígua e onde há um sig90.

- **Unused falsification tests:**
  - **[NOVO] A constelação dos placebos responde à objeção que a §5.1 deixa
    aberta em pé, e o texto só a conta.** O parágrafo final da §5.1 admite: "O que
    os placebos não descartam é um confundidor doméstico". Mas o padrão conjunto
    descarta o confundidor **global**, que é a ameaça maior: o risco global
    *melhora* (VIX −10,7% em h = 2, MSCI-EM **+1,5%**) enquanto o risco brasileiro
    *piora* (CDS +29,1 pb, EMBI+ +20,0 pb, sig90) e o real deprecia contra cinco
    moedas. Nenhum fator global de aversão a risco produz esse sinal cruzado. Hoje
    os placebos são lidos como contagem de rejeições; lidos como constelação, são
    um argumento de identificação.
  - **[NOVO] Os outros seis EPU são seis placebos adicionais** (Chile, China,
    Alemanha, Índia, Rússia, Canadá), já estimados. Reportar os oito, incluindo a
    rejeição do Canadá em h = 0, é mais forte que reportar o único escolhido — e
    remove a suspeita de escolha *ex post*.
  - **[NOVO] O teste discriminante que fecharia o Vice 1 Finding 2** e que **não**
    rodei: recalcular a IRF de impacto para direções alternativas no espaço das q
    inovações, todas renormalizadas a +50 pb em `yield_6m`, e ver se a razão
    5a/6m ≈ 1,85 sobrevive. Se qualquer direção que levante o vértice de 6 meses
    também levanta o de 5 anos em ~1,85, a "amplificação" é propriedade de Λ e não
    do choque identificado. O sinal preliminar que **consegui** extrair sem
    re-estimar nada é que a razão é notavelmente insensível ao instrumento: na
    célula (7,6), amostra cheia, os 8 instrumentos do sweep dão 1,82 a 2,53 —
    inclusive a surpresa **bruta**, sem ortogonalização e sem máscara, que dá 2,08,
    *acima* da de produção. Isso corta nos dois sentidos: é robustez do resultado e
    é ausência de poder discriminante da receita do instrumento. Os 8 instrumentos
    são variantes da mesma surpresa, então não é o teste de invariância — é o
    motivo para rodá-lo.

- **Positioning opportunities:** o resultado, na versão que a saída sustenta, é
  mais estreito e mais forte do que o resumo diz. Mais estreito: a alegação de
  "mecanismo comum" via reversão sincronizada já está proibida pelo CLAUDE.md e o
  câmbio já está fora dela (item aberto). Mais forte: depreciação **contra cinco
  moedas**, com risco soberano abrindo, com risco global recuando, com prêmio que
  **não** está na janela do anúncio e **está** no mês. Essa é uma alegação sobre
  *onde* o prêmio se forma, e ninguém mais a fez para o Brasil.

---

### Itens do council já abertos que este relatório apenas confirma

Não repito o argumento; registro que conferi e bate, para que não sejam
redescobertos numa terceira passada: `sp500_vix` é só o VIX (confirmado pela
média 17,87); o resumo (`:115`) ainda lista o câmbio entre as séries que
revertem de forma sincronizada e a §4.2 (`:379`) diz o contrário; o 3,64% é a
50 pb e a faixa de GRG é a 100 pb; "valores acima de 10 sustentam bandas
convencionais" (`:266`) é Staiger-Stock, não Montiel Olea-Stock-Watson; a §6
(`:593`) trata a divergência com GRG como pesquisa futura quando o exercício já
rodou. Todos em `registro/pendencias.md`, Tema A.

---

### Ruling

- [ ] CLEAR
- [ ] CONDITIONAL
- [x] **HOLD** — e o motivo é estreito e concreto, não uma dúvida geral sobre o
      paper.

**O que segura:** `script/download.R:51-52` está lendo a curva de juros no dia
errado do mês em 23 dos 153 meses da amostra, com erro médio de 84-99 pb por
vértice, porque `slice_tail(n = 1)` opera sobre um arquivo não ordenado. Uma das
seis séries afetadas é **`yield_6m`, a variável de normalização** — o
denominador de *todas* as magnitudes do paper, os 3,64% e os 92,7 pb inclusive.
Os números não podem ser publicados antes de o pipeline rodar com o arquivo
ordenado. A correção é de uma linha; o custo é o tempo de re-estimação e a
conferência do *smoke test* do CLAUDE.md.

**O que não segura.** Nada aqui contradiz o fato central. Ao contrário: as cinco
moedas, a janela pré-COVID e a constelação dos placebos empurram o resultado de
câmbio + risco soberano na direção do paper, não contra ele. A expectativa
razoável é que a re-estimação mova magnitudes e não sinais — mas *expectativa
razoável* não é o que se publica.

**Antes de voltar a interpretar, na ordem:**
1. `arrange(data)` no `download.R`, re-rodar o pipeline, conferir o *smoke test*.
2. Resolver a leitura dupla da Selic na §4.1 (uma frase, independe do item 1).
3. Decidir a convenção de horizonte — h = 0 ou o pico — e aplicá-la a todos os
   blocos.
4. Depois disso, e só depois, os três itens de Virtue 2 que estão de graça: as
   cinco moedas, os agregados monetários, os oito EPU.
