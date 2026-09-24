# A §5 migrada para a produção corrente, com a §5.1 reestimada e a §5.3 excluída

> **SUPERADA EM PARTE — 2026-09-22.** A §5.1 desta nota foi reescrita: a bateria de
> cinco estatísticas que ela descreve (proporcionalidade de Mauchly, gap λ₁−λ₂,
> `ratio_dir`, `rank1_share`, placebo) foi **retirada**, e com ela todos os números que
> ela reporta para a `tab:het_frequency`. A condição de identificação passou a ser a de
> posto de Rigobon, testada pelo `Qr` do pacote `svars`. `script/het_proportionality.R`
> virou `script/het_conditions.R`. **A linha da agregação mensal do sistema diário — a soma
> das janelas Qua→Qui dentro do mês — saiu da tabela e do código no mesmo dia**, por decisão
> do autor: a única agregação mensal é a do painel, a última cotação do mês de referência.
> Tudo que esta nota diz sobre aquela linha, inclusive o `p_boot` de 0,0003 e a leitura de
> que a agregação preserva o deslocamento de covariância, é **descontinuado**. Ver
> `2026-09-22_condicao_het_svars`. O que esta nota registra sobre a §5.2, a
> `fig:weak_iv_main` e a exclusão da §5.3 segue valendo.
>
> **CURRENT — 2026-09-21.** Rodada editorial no `paper/paper_anpec.tex`, com **uma**
> reestimação: o teste de proporcionalidade da §5.1. Os números da §5.2 saem de artefatos
> já comitados; a figura foi repintada dos mesmos artefatos.
> - Painel de produção de 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, 162 inovações,
>   escala de volatilidade COVID de Lenza-Primiceri, conjuntos Anderson--Rubin.
> - **Fecha a metade §5** da sincronização aberta em 2026-09-08. §4 e a legenda da
>   `fig:curva` seguem uma vintage atrás, e a §4 passou a **contradizer** a §5 em dois
>   números — ver §5 desta nota.
> - **Segunda passada no mesmo dia** (§6): a `tab:het_frequency` ganhou a linha da
>   agregação mensal do sistema diário e perdeu a linha pré-COVID, e a §5.2 foi reescrita
>   por `como_escrever`.
> - **Terceira passada** (§6.4 e §6.5): entraram as duas estatísticas de magnitude, e a
>   §5.1 foi corrigida. ⚠ **O mecanismo que §6.1 propôs está errado**: a condição de posto
>   nunca falhou na coluna identificada, e o que falha é a proporcionalidade nas inovações
>   fatoriais. Ler §6.5 antes de citar §6.1.
> - Smoke test de produção bit a bit idêntico, e as seis checagens de
>   `script/validation/` passam.

## 1. O que a §5 era

Três subseções, todas na vintage `(4,4,4)` de 2013-01--2025-09:

| | subseção | defasagem |
|---|---|---|
| 5.1 | Frequência e identificação por heterocedasticidade | mensal estimado em `(4,4,4)`, sem a escala LP, família de 100 células |
| 5.2 | Benchmark VAR sob instrumento fraco | DFM `(4,4,4)`, VAR em `p=2`, cinco magnitudes e todos os horizontes de exclusão desatualizados; legenda anunciando *wild bootstrap* no DFM |
| 5.3 | O filtro de sinal seleciona notícias do FOMC? | janela 2013-01, 62 dias; script arquivado em 2026-09-18 sem reexecução |

**Três afirmações da §5.2 não estavam apenas desatualizadas, estavam falsas.** O IBC-Br
não voltava a ser positivo no segundo mês em nenhum dos dois modelos; o zero não
permanecia dentro das faixas de 90% do IPCA em nenhum dos dois; e o contraste de ordem de
defasagens havia **invertido** com a migração do VAR em 2026-09-21, que levou o benchmark
para a janela e o `p=4` do DFM.

## 2. A §5.1 reestimada

O código dedicado à heterocedasticidade saiu do repositório em 2026-09-01. A rodada o
trouxe de volta **apenas como diagnóstico**, em `R/identification/het_tests.R` e
`script/het_proportionality.R`, recuperados de `9c25fee^` e portados para a API corrente
(`production_spec()` morto, `apply_kilian` removido, `extract_dynamic_innovations()` no
lugar de `u K M^-1`). `ident_het_regimes()` e `het_shock_extraction.R` **não voltaram**: a
identificação por heterocedasticidade segue abandonada desde 2026-08-17 e nenhuma IRF pode
sair deste ramo.

Escolhas do autor nesta rodada: as inovações que entram no teste são as **padronizadas**
(`u_t/s_t`), o mesmo objeto de que saem `K`, `M`, `η`, `ξ_mp` e os conjuntos AR; a família
de Holm cobre a célula de produção **e** a grade do desenho de calendário.

Grade: desenho `calendario` apenas, `p=4`, e o `(r,q)` por janela de
`script/mosw_strength_grid.R` — `r=4:6` na cheia, porque sob a escala o VAR de fatores é
explosivo de `r=7` em diante, e `r=4:8` na pré-COVID. São **37 células**, contra as 100 da
vintage antiga, que varria `p=5:8`.

O `p_boot` publicado vem de **10.000 réplicas**, não das 500 da rodada anterior: no ponto
de produção 500 réplicas dão `0,0499` e 10.000 dão `0,0508`, e a diferença atravessa o
nível de 5%.

| frequência | janela | n_C/n_NC | g.l. | LR | p_chi2 | p_boot |
|---|---|---|---|---|---|---|
| diária | 2013--2025 | 97/524 | 9 | 135,1290 | ~0 | 0,0001 |
| mensal | cheia | 108/54 | 14 | 30,9071 | 0,0057 | **0,0508** |
| mensal | pré-COVID | 60/30 | 14 | 12,9942 | 0,5270 | 0,6632 |

**O veredito não mudou: nenhuma das 37 células sobrevive a Holm**, em nenhum dos dois
gates, e `p_boot < 0,05` em zero células nas duas janelas. Mas o número de produção é
**marginal** — `0,0508` contra os `0,0559` da vintage `(4,4,4)` — e o valor-$p$ assintótico
da mesma estatística, `0,0057`, rejeitaria. O paper reporta os dois e diz qual é lido.

Duas coisas que a rodada apurou de passagem:

- **O regime C não é o COVID disfarçado.** A participação de C é exatamente 2/3 antes e
  depois de 2020 (60/30 e 48/24), então a diluição do desenho de calendário é estrutural,
  não um artefato da janela.
- **A linha diária virou reproduzível.** Ela era citada de uma linha de prosa em
  `arquivo/heterocedasticidade/output/het/het_robustness.md`, e o caminho que
  `notas/2026-09-01_heterocedasticidade_frequencia.md` dava para ela
  (`hetero_results.json`) **não existe no disco**. A fixture Qua→Qui do referee2 foi
  copiada para `output/validation/het_daily_changes_referee2.csv` e o script a recomputa
  com o mesmo bootstrap das linhas mensais: `LR = 135,1290`, `p_boot = 0,0001`. O `0,005`
  antigo era o piso de resolução de um bootstrap de 200 réplicas.

## 3. A §5.2 migrada

Fontes: `output/irf/irf_coherence_h.csv` (DFM, 2026-09-17) e
`output/var/svar_iv_weak_robust.csv` (VAR, célula `ibc5_fx_cds_level_trend_p4`,
2026-09-21). `output/irf/irf_section.md` **não** foi usado: carrega banner próprio e está
três vintages atrás.

Impactos em `h=0`:

| série | DFM antes | DFM agora | VAR antes | VAR agora |
|---|---|---|---|---|
| IBC-Br | −0,45% | **−0,66%** | −0,70% | **−0,73%** |
| IPCA | −0,055 p.p. | **−0,045 p.p.** | −0,019 p.p. | **−0,0004 p.p.** |
| DI 6m | 50 p.b. | 50 p.b. | 50 p.b. | 50 p.b. |
| BRL/USD | +3,74% | **+3,23%** | +1,96% | **+2,02%** |
| CDS 5 anos | +30,7 p.b. | **+30,5 p.b.** | +18,9 p.b. | **+15,7 p.b.** |

O parágrafo de defasagens foi **invertido**: os dois sistemas agora usam 2012:03--2025:12
com 162 observações efetivas e quatro defasagens, e o `p=4` do VAR é escolha de
comparabilidade, não do AIC, que seleciona duas (−11,106 contra −11,006) enquanto o BIC
seleciona uma. Com janela e dinâmica comuns, o contraste deixa de misturar amostra e
defasagens — mas continua sem isolar o conjunto informacional, porque cinco fatores de 115
séries não são cinco observáveis.

Os parágrafos de trajetória e de persistência foram reescritos. **Os conjuntos de 90% não
são blocos contíguos**, e escrever "exclui zero até o mês X" seria falso:

| série | DFM (h ≤ 36) | VAR (h ≤ 36) |
|---|---|---|
| IBC-Br | {0}, {3}, 6–24 | {0} |
| IPCA | 20–34, ramo negativo | {2}, {4}, ramo **positivo** |
| DI 6m | 0–6 e 30–36 | 0–8 |
| BRL/USD | 0–4 | 0–7 |
| CDS 5 anos | 0–6 e 31–36 | 0–14, lacuna em h=2 |

**O número inconveniente que entrou no paper:** o VAR tem *price puzzle* a 90% — o IPCA
exclui zero no segundo e no quarto mês com sinal positivo — e o DFM não. O IPCA do DFM é
negativo em todo o horizonte. As células longas novas sob a régua AR (yield e CDS a partir
de h=30, IPCA de h=20) são reportadas como horizontes e **não** como evidência separada da
reversão de médio prazo, conforme `2026-09-08_bandas_anderson_rubin_producao`.

`paper/fig_weak_iv_main.pdf` foi repintada com `--repaint-paper-figures` e a legenda passou
a anunciar conjuntos Anderson--Rubin **nos dois modelos**. Some com isso uma das duas
legendas que diziam *wild bootstrap*; a da `fig:curva`, na §4, fica.

## 4. A §5.3 excluída

Saiu inteira, com `eq:fomc-contamination` e o `\label{sec:fomc}`, por decisão do autor.
Reportava a janela 2013-01 com 62 dias retidos, contra os 65 meses da produção corrente, e
seu script (`fomc_coincidence.R`) foi arquivado em 2026-09-18 sem reexecução porque
abortava contra a produção. Nenhuma `\cite` morreu com ela — o orçamento segue em 21 chaves
das 25 — e a única referência cruzada a `sec:fomc` estava num parágrafo já comentado, que
saiu junto.

A ressalva que a exclusão **não** apaga continua no registro: a máscara global rederivada
do exercício FOMC derruba `ξ_mp` para 3,671, abaixo de 3,84, e o veredito de 2026-08-24 é
**sinal fraco de contaminação FOMC**. O paper nunca reportou isso, por decisão de
2026-08-25, e segue não reportando.

## 5. O que fica aberto

**A §4 agora contradiz a §5 em dois números.** A §4 diz que o BRL/USD sobe 3,74% e o CDS
30,7 p.b. no impacto; a §5.2 diz 3,23% e 30,5 p.b. para as mesmas séries no mesmo modelo.
A §4 é a errada — está na vintage anterior —, e a rodada editorial que a migra continua não
agendada. Enquanto isso, `script/fig_section5.R` segue atrás de `--repaint-paper-figures`.

Também segue aberta a leitura econômica das IRFs sob a escala LP, que é o que a §4 precisa
antes de ser reescrita.


## 6. Segunda passada: a tabela da §5.1 e a reescrita da §5.2

Duas mudanças pedidas pelo autor depois de fechada a rodada acima.

### 6.1 A linha que faltava, e o que ela derruba

> ⚠⚠ **A segunda metade desta subseção está errada e foi corrigida em §6.5.** A leitura de
> que "a agregação destrói a segunda condição" lê o par de autovalores errado. Vale o que
> está dito aqui sobre a linha nova e sobre a rejeição de proporcionalidade no mensal
> agregado (`p_boot` 0,0003). Não vale nada do que atribui à agregação uma perda de posto.

A `tab:het_frequency` perdeu a linha pré-COVID e ganhou **a agregação mensal das mesmas
quatro séries do sistema diário**. Com o conjunto de variáveis fixo, a diferença entre as
duas primeiras linhas isola a frequência, que era exatamente o que a versão anterior da
tabela não conseguia fazer e dizia não conseguir.

| sistema | frequência | n_C/n_NC | g.l. | LR | p_boot | separação |
|---|---|---|---|---|---|---|
| quatro observáveis financeiras | diária | 97/524 | 9 | 135,1290 | 0,0001 | **0,3523** |
| quatro observáveis financeiras | mensal | 104/52 | 9 | **48,9275** | **0,0003** | **0,1022** |
| cinco inovações fatoriais | mensal | 108/54 | 14 | 30,9071 | 0,0508 | 0,2329 |

**O resultado inverte a explicação que a §5.1 dava.** A prosa anterior atribuía a perda da
condição de posto à agregação temporal diluir o deslocamento de covariância. Ela não dilui:
agregadas ao mês, as mesmas quatro séries **continuam rejeitando** proporcionalidade com
`p_boot = 0,0003`. O que a agregação destrói é a **segunda** condição necessária, a
distinção dos autovalores generalizados, cuja separação mínima cai de 0,3523 para 0,1022,
contra o critério de 0,20 do projeto.

A leitura correta, agora escrita no paper, é que **cada rota mensal falha em uma condição
diferente**: a agregada preserva o deslocamento e perde a separação, a fatorial recupera a
separação (0,2329) e perde o deslocamento (`p_boot = 0,0508`). O veredito de identificação
não muda, e a rota het segue abandonada, mas o motivo mudou.

Construção da linha nova, em `script/het_proportionality.R`: cada variação Qua→Qui é um
retorno de quinta-feira e é **somada dentro do mês de `thu_date`**, e o regime é o mês da
reunião do Copom, a mesma definição das linhas fatoriais. É a soma das variações de um dia
dentro do mês, **não** a variação mensal das séries.

**A convenção de fronteira importa e está registrada.** Dezessete das 621 semanas cruzam a
virada do mês, e as quatro combinações de chave de soma e de rótulo não concordam. Três
rejeitam com folga e uma não rejeita, e a que não rejeita é justamente a que abandona a
definição de regime do paper:

| soma em | rótulo | n_C/n_NC | LR | p_boot |
|---|---|---|---|---|
| `thu_date` | reunião do Copom (publicada) | 104/52 | 48,9275 | 0,0003 |
| `thu_date` | semana C | 97/59 | 30,1097 | 0,1265 |
| `wed_date` | reunião do Copom | 104/52 | 61,8701 | 0,0001 |
| `wed_date` | semana C | 97/59 | 69,8532 | 0,0002 |

A tabela está em `output/het/het_proportionality_aggregation.csv` e é regravada a cada
execução. Um *leave-one-month-out* na variante `wed_date` derruba a LR de 61,87 para no
mínimo 55,1, então o resultado não é de um mês só.

### 6.2 A §5.2 reescrita

Reescrita por `como_escrever`, cortando o que a §3 já explica. Saiu inteiro o parágrafo que
reexplicava os conjuntos Anderson--Rubin (inversão de teste, cobertura sob instrumento
fraco, NW(0), conjuntos ilimitados preservados), tudo já na §3.4. Sobreviveu dele a única
parte que é da §5.2, a ressalva de que os dois modelos usam o **mesmo** instrumento, de
modo que a coincidência não testa exogeneidade. Saiu também a frase que declarava não
haver teste formal de igualdade entre os pontos, que defendia o método em vez de reportar.
Nenhum número mudou, e os 14 valores e as 10 listas de horizontes foram reconferidos
contra os dois CSVs.

### 6.3 Um efeito colateral no fecho

O fecho do artigo afirmava que "a condição de posto presente no diário desaparece na
frequência mensal", que a linha nova refuta. A frase foi corrigida para a leitura das duas
condições. **A linha 115 do resumo não foi tocada** e ainda diz que a importância do canal
pode depender "da frequência dos dados e da estratégia de identificação adotada" — meia
verdade, agora que a frequência sozinha não explica nada. Fica como pendência editorial.

### 6.4 Estatísticas de magnitude: `ratio_dir` e `rank1_share` nas três linhas

> ⚠ Vale inteira, **menos** a frase "o sistema com o maior deslocamento de variância da
> tabela é justamente o que não separa os autovalores" e a leitura de que isso reforça a
> §5.1 pela via do posto. O mensal agregado separa os autovalores. Ver §6.5.

`het_strength_stats()` já computava a magnitude do deslocamento de variância, mas só para as
células fatoriais mensais, de modo que `1,74` não tinha contra o que ser lido. Passou a ser
computada também para a linha diária e para a mensal agregada, e as duas estatísticas entraram
em `tab:het_frequency` no lugar da coluna `Rejeita H₀`, redundante com `p_boot`.

| sistema | razão | rank-1 | rank-1 sob H₀ | excesso | gap | placebo |
|---|---|---|---|---|---|---|
| diária (4 observáveis) | 1,9630 | 0,8405 | 0,9609 | **−0,1204** | 0,3523 | 0,09895 |
| mensal agregada (mesmas 4) | **3,7323** | 0,9695 | 0,9195 | +0,0500 | 0,1022 | 0,00350 |
| mensal (inovações fatoriais) | 1,7422 | 0,5655 | 0,4106 | +0,1549 | 0,2329 | 0,13543 |

**O resultado contraria a expectativa com que a rodada começou.** A razão de variâncias não cai
com a agregação, ela **sobe**: `3,73` no mensal agregado contra `1,96` no diário. O sistema com o
maior deslocamento de variância da tabela é justamente o que não separa os autovalores. Isso
**reforça** o argumento da §5.1 em vez de enfraquecê-lo, porque exibe magnitude grande e
identificação nula na mesma linha, e torna impossível atribuir a falha da agregação a escassez de
movimento na variância. Os intervalos de bootstrap das razões se sobrepõem (diária
[1,3614; 3,4659], agregada [2,0350; 8,0477]), então a ordem entre elas é de pontos, não
estabelecida, e a direção é estimada em amostra, o que enviesa as três para cima e mais as
mensais (156 observações) que a diária (621). O viés é conservador para a leitura publicada.

**Convenção do benchmark de `rank1_share`.** A estatística é livre de escala mas não de dimensão:
sob proporcionalidade exata `dSigma = (a−1) Sigma_NC`, logo ela iguala a participação do maior
autovalor de `Sigma_NC`, não zero. Esse valor passou a ser computado por linha
(`rank1_share_h0`, coluna nova em `het_proportionality_cells.csv`) e reportado na nota da tabela,
porque sem ele 0,566 seria lido contra zero. Lido contra o benchmark, o excesso é pequeno em toda
a tabela e **negativo no diário**, onde a mudança de covariância é menos concentrada que a
covariância de base. A premissa de choque único de variância, da variante de estudo de evento da
rota het, não é condição do teste de proporcionalidade e não é exibida por nenhum dos três
sistemas.

**O placebo de permutação não ordena os sistemas como as demais estatísticas** e é reportado só
no `.md`, nunca no paper: 0,0035 no mensal agregado, 0,0990 no diário e 0,1354 nas inovações
fatoriais. Em frequência diária a distribuição de permutação de `lambda_1` é dominada por dias de
cauda, que qualquer subconjunto aleatório de 97 dias captura, então o teste tem pouca potência
ali; a soma mensal aproxima as observações da normalidade e estreita a distribuição. A leitura é
sobre a potência da estatística em cada frequência, não sobre identificação, e o placebo segue
decidindo apenas dentro da família mensal, onde as células são comparáveis. ⚠ O `0,0990` do
diário fica registrado: a §5.1 não usa o placebo como gate para aquela linha, e não passou a usar.

**Reprodutibilidade.** Toda chamada que consome RNG no script passa `seed` explicitamente, então
as chamadas novas não deslocaram sorteio algum. Verificado, não assumido: todas as colunas
pré-existentes de `het_proportionality_cells.csv` saíram bit-idênticas, `het_proportionality_aggregation.csv`
e `het_proportionality_regimes.csv` inalterados, as seis checagens de `script/validation/` passam,
o smoke test de produção é bit-idêntico nos cinco impactos, e o paper compila em 25 páginas sem
referência indefinida nem `Overfull \hbox` na tabela de nove colunas. Nenhum número anterior da
§5.1 mudou, e o fecho do artigo não precisou de correção porque descreve o mecanismo, não a
magnitude.

### 6.5 Correção: a condição de posto nunca falhou na coluna identificada

**O critério de gap mínimo de 0,20 é uma condição do sistema inteiro e foi lido no par
errado.** A condição de Rigobon para nomear **uma** coluna `j` é que `lambda_j` seja distinto
dos demais, não que os `K` autovalores sejam mutuamente distintos. Os autovalores
generalizados de `Sigma_C Sigma_NC^-1`, em ordem decrescente, com o gap relativo de cada par:

| sistema | λ₁ | λ₂ | λ₃ | λ₄ | λ₅ | gap (1,2) | mínimo do sistema |
|---|---|---|---|---|---|---|---|
| diária | **8,4912** | 2,1950 | 1,4217 | 0,7804 | — | **0,7415** | 0,3523 no par (2,3) |
| mensal agregada | **7,2368** | 1,7369 | 1,5595 | 0,8021 | — | **0,7600** | 0,1022 no par (2,3) |
| mensal fatorial | **3,6040** | 1,6351 | 1,2084 | 0,9269 | 0,7091 | **0,5463** | 0,2329 no par (3,4) |

**Em nenhum dos três sistemas a degenerescência está no par que envolve λ₁.** O 0,1022 que a
§5.1 publicava como "a separação colapsa" é entre λ₂ e λ₃, duas colunas do meio. A coluna de
maior aumento de variância tem gap de 0,76 no mensal agregado contra 0,74 no diário, e ambos
passam com folga o critério de 0,20 do próprio projeto.

O autovetor dessa coluna é de juros nos dois sistemas de observáveis. Normalizado pelo maior
carregamento, no mensal agregado carrega DI 2 anos 1,000 e DI 3 meses 0,453, com Ibovespa
−0,063 e câmbio 0,027; no diário, DI 3 meses 1,000 e DI 2 anos 0,667. Os ICs de bootstrap
confirmam onde está a separação robusta: λ₁ [4,38; 15,38] não toca λ₂ [1,38; 3,85], enquanto
λ₂ e λ₃ [0,87; 2,09] se sobrepõem fortemente.

⚠ **Não existe teste de igualdade par a par aqui, e não deve ser fabricado um.** A diferença
entre autovalores **ordenados** é positiva por construção, então o bootstrap não cobre zero e
qualquer valor-`p` daí é artefato, a mesma armadilha do IC de `lambda_1` registrada em §6.4. O
teste correto é o de Lütkepohl, Meitz, Netšunajev e Saikkonen (2021), que trata a assintótica
não padrão sob autovalores coincidentes. Não está implementado.

**A história corrigida é mais simples que a anterior.** A condição 2 vale nos três sistemas e
não discrimina nada. A condição 1 é rejeitada com folga nos dois sistemas de observáveis
(0,0001 diário, 0,0003 mensal agregado) e não é rejeitada nas inovações fatoriais (0,0508).
**A frequência não é o obstáculo, a representação fatorial é.** Isso coincide com o que o
fecho do artigo e o parágrafo sobre `goncalves2025` já diziam pela via do conjunto de
variáveis.

**Consequência que o registro precisa carregar:** um sistema mensal de quatro observáveis
financeiras **satisfaria as duas condições**. Het não está "rejeitada em ambas as
frequências", está rejeitada nas inovações deste modelo. Usá-la significaria abandonar a
representação fatorial, que é o objeto do artigo. A proibição de IRF pelo ramo het segue
valendo e nenhuma IRF saiu dele; a decisão de rodar um sistema de quatro variáveis
identificado por heterocedasticidade foi colocada ao autor e **não** foi autorizada nesta
rodada.

**O que foi reescrito.** Na §5.1, o parágrafo 2 virou dois (a condição 2 vale nos três
sistemas; a condição 1 falha só na fatorial), a primeira frase do parágrafo de magnitude, o
parágrafo de fecho da subseção, e a coluna `Separação` da tabela, que passou a reportar o gap
de λ₁ (0,74 / 0,76 / 0,55) com os mínimos do sistema e os pares onde recaem na nota. Fora da
§5.1, o parágrafo het do `Concluding remarks` e **o resumo nas duas línguas**, que dizia que a
importância do canal "pode depender da frequência dos dados" e agora reporta que a frequência
não explica a divergência. Com isso o resumo deixa de contradizer a §5.1 e a pendência
editorial que a §6.3 havia aberto está fechada.

Nenhum número de estimação mudou, nenhum artefato de `output/` foi regerado, e o paper passou
de 25 para 26 páginas por causa da quebra de parágrafo e da nota mais longa. Não há limite de
páginas registrado no projeto.
