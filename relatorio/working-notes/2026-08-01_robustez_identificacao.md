# Robustez à forma de identificação — o que o histórico do projeto sustenta

**Data:** 2026-08-01
**Pergunta:** as IRFs da identificação por não-gaussianidade e por heterocedasticidade corroboram as da identificação por instrumento? Dá para escrever uma robustez afirmando que os achados independem da forma de identificação?
**Safra:** produção (r=7, q=6), 106 séries, 2013-01 a 2025-09, `z_jk_bs_purif`.

**Estado:** fechado. Os números do GMR vêm da reestimação de 2026-08-01 com
`nboot = 800` e `NG_STARTS = 200` sobre o painel corrente, que substituiu o
cache de 200 draws de 2026-07-27 (motivos na §5).

---

## 1. Resposta direta

**Não na forma pretendida.** A afirmação "os achados independem da forma de identificação" precisa de pelo menos duas identificações *diferentes* apontando para o mesmo lugar. O repositório tem três coisas, e a pergunta as junta numa só:

| rota | é identificação alternativa? | produziu IRF? | safra | serve? |
|---|---|---|---|---|
| het **primária** (`identification = "het"`) | **sim** | **nunca** | — | não |
| het como **instrumento** (`z_het*` no proxy) | **não** — mesmo proxy-SVAR | sim, 3 gerações | antiga | não responde a *esta* pergunta |
| **não-gaussiana** (GMR 2017) | **sim** | sim | atual | **só como "não contradiz"** |

A perna de het que *seria* uma identificação alternativa nunca gerou uma única IRF. A perna de het que gerou IRFs não é uma identificação alternativa. Sobra o GMR — e o teste de (ii) mostrou que ele **não contradiz** o proxy, mas que a concordância medida **não é distinguível da que qualquer direção arbitrária produziria**.

**O que dá para escrever:** que a identificação não-gaussiana **não contradiz** o proxy — a estimativa pontual do proxy cai dentro da banda de 90% do GMR em todas as 5.194 células — e que ela **rejeita o esquema recursivo** (Cholesky, ξ = 149,3) que a literatura de menor dimensão impõe sem testar.

**O que não dá:** afirmar que "outra identificação independente dá a mesma direção" como resultado estatístico. Sob 2.000 direções aleatórias normalizadas ao mesmo choque, a concordância mediana já é **0,786** e um quarto delas iguala a coluna rotulada (p = 0,179; §4.7). E a rotulagem ainda depende do instrumento: as regras que não usam `z` selecionam uma coluna que corrobora mal (§4.5).

---

## 2. A distinção que a pergunta esconde

Vale fixar porque ela já se perdeu uma vez no projeto e é a origem da confusão.

**Identificar** é escolher a matriz que mapeia inovações reduzidas em choques estruturais. O proxy-SVAR faz isso projetando as inovações fatoriais no instrumento: `H = (Z'η)/(Z'Z)`. Trocar `z_jk_bs_purif` por `z_het_jk` **não muda a identificação** — muda o insumo de uma identificação que continua sendo a mesma. É robustez à *construção do instrumento*, e o projeto já a tem em duas formas melhores: a varredura de 13 vértices de DI (`instrument_construction_sweep.R`, todas as IRFs dentro da banda de 68%) e a família GK inteira cruzando Stock-Yogo na janela pré-COVID.

**A het primária** seria outra coisa: identificar pela mudança de composição da variância entre regimes, dispensando `z` inteiramente. É essa que responderia à pergunta. É essa que está morta.

**A rota não-gaussiana** também dispensa `z` para identificar — o instrumento entra só para **rotular** qual coluna estimada é a monetária. É a única rota implementada que cruza a hipótese identificadora.

---

## 3. Heteroscedasticidade

### 3.1 Como identificação primária: nunca houve IRF

Implementada em 2026-07-16 e **reprovada no mesmo dia, nas duas variantes**. A motivação era boa e continua válida: o Copom anuncia ~18h30, depois do fechamento, e a janela Qua→Qui de ~24h fragiliza a restrição de exclusão do proxy (a crítica de Rigobon-Sack 2004 ao event-study).

O código não é o problema. `validate_het_primary_sim.R` passou em tudo: cos 0,994 na recuperação da direção, tamanho do teste J de 4,5%, poder de 85,5%.

O que reprovou foi a pré-condição, em duas frentes (`_instrucoes/historico_decisoes.md:185-186`):

| variante | desenho | veredito |
|---|---|---|
| Calendário | meses com/sem Copom, 16 células (r,q) | placebo de permutação com **p entre 0,26 e 0,86**; proporcionalidade `Σ_C ∝ Σ_NC` **nunca rejeitada** ⇒ condição de posto inexistente |
| Episódio (BPSS) | pré/pós-2020 + partição fina, 4 células | volatilidade se move como **fator de escala comum**; gaps de autovalor generalizado de **0,04 a 0,19**; a coluna com o loading de `yield_6m` tem λ ≈ 1 |

A leitura registrada (`:188-190`):

> "a heterocedasticidade que identifica no diário (Rigobon-Sack) simplesmente não sobrevive à agregação mensal — a variância muda de **nível**, não de **composição**. Isso é um resultado sobre a frequência, não sobre o método."

**Sem sistema identificado não há IRF a computar.** Não existe nem existiu nenhuma IRF de het primária. Não é uma questão de desenterrar artefato: o objeto nunca foi produzido. E não é salvável na frequência mensal, por construção.

Isso importa por um motivo que vai além da het: **a het e a não-gaussianidade exploram os mesmos momentos de ordem superior**. A tabela de agregação registrada em `historico_decisoes.md:119-123` mostra o mecanismo comum — a fração de séries que rejeita normalidade cai de **88,7%** no painel bruto para **71,4%** nos resíduos do VAR de fatores e para **50,0%** em `eta`. As inovações mensais do DFM são o objeto mais gaussiano do pipeline. Qualquer método que identifique por momentos de ordem > 2 sobre `eta` vai bater na mesma parede.

### 3.2 Como instrumento: corrobora, mas não é a pergunta

Aqui houve IRFs, em três gerações (2026-05-08, 07-11, 07-15). Morreu por **relevância**, não por IRF implausível (`historico_decisoes.md:156-163`): sob a régua ξ_mp, `z_het_3var` marca 0,45 no full em (7,6) e `z_het` marca 1,95, contra 10,43 do `z_jk_bs_purif`.

O que as IRFs diziam, recuperado de `git show fc0ef58^:output/irf/spec_sweep_irf_long.csv` e conferido por mim (full, r=7, q=6, `yield_6m`, por +50bp):

| resposta em h=0 | `z_het_jk` | `z_het` | `z_het_3var` | `z_het_jk_3var` | produção `z_jk_bs_purif` |
|---|---:|---:|---:|---:|---:|
| yield_2y | +0,00846 | +0,0107 | +0,0124 | +0,00909 | **+0,00916** |
| yield_5y | +0,00801 | +0,0127 | +0,0158 | +0,00923 | **+0,00927** |
| cambio_usd | +0,1255 | +0,2921 | +0,5327 | +0,1669 | **+0,1498** |
| embi_perc | +0,1139 | +0,4561 | +0,5524 | +0,1928 | **+0,1995** |
| price_ipca | −0,1085 | −0,1316 | −0,9937 | −0,1749 | **−0,0703** |
| price_ipca em h=6 | +0,0623 | +0,1958 | +0,3966 | +0,1119 | **+0,0986** |

`z_het_jk` fica praticamente em cima da produção — mesmo sinal em tudo, e a corcova de preço em h=6 reproduzida. É um resultado bonito e **não serve para a afirmação que se quer fazer**, porque é o mesmo estimador com outro `z`. Some-se que a safra é anterior ao refresh de 2026-07-24 e à correção de tcode dos índices B3.

**Nota para decisão futura, não executada aqui.** Na safra **atual**, `output/instrument/mosw_strength_grid.csv` ainda pontua os quatro instrumentos het, e dois deles não são fracos: `z_het_jk` marca **ξ_mp 9,70** em (7,6) full, e `z_het_3var` / `z_het_jk_3var` marcam **12,86 / 12,80** pré-COVID (contra 10,43 / 12,22 da produção). Os CSVs dos instrumentos seguem em `data/processed/instrument_z_het*.csv` e os módulos em `arquivo/R/identification/`. Um re-run seria barato. Mas continuaria sendo robustez ao instrumento.

---

## 4. Não-gaussiana (GMR 2017) — a única que responde

### 4.1 O número publicado está selecionado

`output/nongaussian/results.md` compara **8 séries manchete** e mostra 8/8 de concordância de sinal no impacto. Essa lista é fixa em `model_nongaussian.R:46-47`.

No painel inteiro de 106 séries a concordância no impacto é **0,623**.

Nenhum dos dois é a resposta. O primeiro está selecionado; o segundo pontua séries sobre as quais o próprio proxy não afirma nada. A régua que responde "o que eu afirmo sobrevive?" é condicionar em **onde o proxy é significativo**:

| recorte de células | n | concordância de sinal |
|---|---:|---:|
| onde o proxy é **sig90** (todas em h ≤ 12) | 140 | **0,971** |
| onde o proxy é **sig90**, só em h = 0 | 35 | 0,914 |
| onde o proxy é **só sig68** — h ≤ 12 | 264 | 0,682 |
| onde o proxy é **só sig68** — h 13-24 | 248 | **0,246** |
| onde o proxy é **só sig68** — h 25-48 | 397 | **0,363** |
| incondicional, h = 0 | 106 | 0,660 |
| incondicional, h 13-24 | 1.272 | 0,338 |

Nas 140 células sig90 a razão de magnitude GMR/proxy tem mediana **1,11** (IQR 0,59-1,47). Não é só o sinal que bate: a ordem de grandeza também.

**A quebra por bloco é o quadro que interessa.** Onde o proxy afirma algo a 90%, a concordância é perfeita em todos os blocos do canal de prêmio de risco, e o único bloco que falha é atividade:

| bloco | células sig90 do proxy | concordância de sinal |
|---|---:|---:|
| curva de juros | 35 | **1,000** |
| câmbio e risco soberano | 16 | **1,000** |
| preços | 10 | **1,000** |
| preços ambíguos | 9 | **1,000** |
| crédito setorial | 6 | **1,000** |
| commodity doméstica | 5 | **1,000** |
| trabalho | 1 | 1,000 |
| placebos externos | 1 | 1,000 |
| **atividade** | **9** | **0,733** |
| fora do ruler de 53 | 48 | 0,963 |
| ações (6 + 2) e crédito agregado (4) | 0 | — (o proxy não afirma nada) |

### 4.2 O GMR não contradiz porque não determina

O ponto do proxy cai dentro do CI90 do GMR em **100,0% das 5.194 células**. E o GMR tem **exatamente 1 célula sig90 própria** contra 140 do proxy — e essa uma é `yield_6m` em h=0, que é a normalização, significativa por construção. Ou seja: **o GMR não tem nenhuma célula significativa substantiva.** Suas bandas de 90% são medianamente **5,4 vezes** mais largas que as do proxy.

Isso separa duas leituras que costumam ser confundidas: *"não contradiz"* aqui é quase vazio, porque as bandas do GMR contêm praticamente qualquer coisa. O que tem conteúdo é a concordância de **sinal e magnitude** condicionada, acima.

### 4.3 Onde discorda: o bloco de atividade no impacto

Das 140 células sig90 do proxy, **4 têm sinal invertido, e não estão espalhadas** — são todas atividade:

| variável | h | proxy | GMR |
|---|---:|---:|---:|
| ind_bens_duraveis | 0 | −5,473 | +0,408 |
| ind_bens_capital | 0 | −2,601 | +0,931 |
| trab_employment_northeast | 0 | −7.149,2 | +1.503,2 |
| ind_leves | 8 | −1.600,3 | +47,7 |

É exatamente a contração de atividade no impacto que a seção de resultados afirma. Curva, câmbio, risco soberano, crédito e núcleos de preço concordam sem exceção; atividade não. Qualquer texto de robustez tem de excluir esse bloco pelo nome.

(Sob o cache antigo de 200 draws eram 7 discordâncias, incluindo `ind_transformacao`, `trab_employment_south` e `trab_hrs_trabalhadas_industria`. As três passaram a concordar no ótimo melhor — a discordância encolheu, não mudou de natureza.)

### 4.4 O gate reprovado, e o que ele não invalida

A rota exige **no máximo uma** das q inovações gaussiana (Comon 1994; GMR Prop. 2a). O painel dá **3 de 6** no full sample e **5 de 6** pré-COVID.

Recomputei os momentos no painel atual e eles batem com `gate.md` até a 4ª casa (eta_1 assimetria 1,1553, JB 197,67; eta_5 p 0,5475; eta_6 p 0,8401) — ou seja, **a reprovação do gate não é artefato de safra**.

Consequências: (i) `C` fica identificada só a menos de uma rotação dentro de um bloco gaussiano de dimensão 3 — a não-identificação é **parcial**, e 66% da direção monetária do proxy vive no subespaço identificado; (ii) **pré-COVID a rota não existe**, e é justamente a janela onde o proxy é mais forte (ξ_mp 12,22), então não há comparação por janela.

### 4.5 A rotulagem frágil não é o problema que parecia

A coluna monetária é nomeada por `|cor(ε_j, z)|`, e no ótimo novo a vencedora (coluna 2, cor 0,200) bate a segunda (coluna 3, cor 0,154) por **0,046** — melhor que os 0,012 do ótimo antigo, mas ainda apertado. Enquanto o rótulo vier de `z`, a "identificação independente" continua precisando do instrumento para saber *qual* choque é o monetário.

Testei três regras que não usam `z`, **fixadas antes de calcular qualquer concordância** (`script/nongaussian_labelling.R`). O resultado é o cenário ruim: **as regras discordam.**

| regra | usa `z`? | coluna | folga | estatística por coluna (1→6) |
|---|---|---:|---:|---|
| R0 `\|cor(ε_j, z)\|` | sim | **2** | 0,046 | 0,148 · **0,200** · 0,154 · 0,015 · 0,096 · 0,095 |
| R1 impacto em `yield_6m` | não | **1** | 0,0003 | **0,0019** · 0,0016 · 0,0006 · 0,0002 · 0,0005 · 0,0002 |
| R2 FEVD de `yield_6m`, h 0-12 | não | **1** | 0,214 | **0,466** · 0,252 · 0,070 · 0,049 · 0,094 · 0,068 |
| R3 FEVD do bloco da curva, h 0-12 | não | **2** | 0,108 | 0,296 · **0,404** · 0,126 · 0,034 · 0,058 · 0,083 |

E o perfil das seis colunas contra o proxy mostra por que isso importa:

| coluna | concord. sig90 | concord. global | razão de magnitude |
|---:|---:|---:|---:|
| 1 — a que R1 e R2 escolhem | **0,600** | 0,816 | **0,20** |
| 2 — a que R0 e R3 escolhem | 0,971 | 0,484 | **1,11** |
| 3 — que ninguém escolhe | **1,000** | **0,907** | 2,17 |
| 4 | 0,536 | 0,684 | 0,12 |
| 5 | 0,457 | 0,260 | −0,20 |
| 6 | 0,571 | 0,668 | 0,33 |

**As duas regras ancoradas na variável de política — as mais naturais — selecionam a coluna 1, que corrobora mal**: concorda em 60% e responde com um quinto da magnitude do proxy. A coluna que melhor corrobora é a 3, e nenhuma das quatro regras a escolhe.

A leitura honesta: **a coluna monetária não é bem definida sem o instrumento neste painel**, e a corroboração do §4.1 é sensível à regra de rotulagem. O que a antecipa é a §4.7 — sob o nulo correto, nenhuma dessas diferenças é estatisticamente distinguível de ruído, o que reordena todo o peso a dar a este quadro.

### 4.7 O teste que faltava: a métrica não discrimina

A concordância de sinal de 0,971 só é evidência se uma direção *arbitrária* não a alcançar. Isso não tinha sido testado. Sorteei **2.000 direções unitárias** uniformes em ℝ⁶, cada uma normalizada a +50bp em `yield_6m` e pontuada exatamente como as colunas:

| estatística | nulo q05 | **nulo mediana** | nulo q95 | coluna 2 | p |
|---|---:|---:|---:|---:|---:|
| concordância nas sig90 | 0,257 | **0,786** | 1,000 | 0,971 | **0,179** |
| idem, só bloco da curva | 0,400 | **1,000** | 1,000 | 1,000 | — |
| idem, excluindo a curva | 0,161 | **0,733** | 1,000 | 0,962 | 0,203 |
| \|log\| da razão de magnitude | 0,037 | 0,591 | 2,917 | **0,101** | 0,125 |
| cos com a direção do proxy | 0,023 | 0,315 | 0,763 | 0,620 | 0,134 |

**Nada é significativo.** Uma direção aleatória já concorda em 78,6% das células sig90 na mediana, e **um quarto delas iguala ou supera a coluna rotulada**. No bloco da curva o nulo tem mediana **exatamente 1,000**: normalizar a +50bp em `yield_6m` força a curva inteira a subir, então a concordância ali é **mecânica**, e a curva é 35 das 140 células.

Duas leituras, e é preciso não confundi-las. A métrica **satura** — com 140 células e um critério binário, o teste tem pouquíssimo poder, e o q95 do nulo bate no teto em três das cinco estatísticas. Isso não prova que o GMR *não* corrobora; prova que **a concordância de sinal, sozinha, não é evidência de que corrobora**.

O que sobrevive como sugestivo, nunca como significativo: a coluna 2 é a melhor de todas as seis na **razão de magnitude** (|log| 0,101, contra 0,776 da segunda melhor — responde com 1,11× a magnitude do proxy quando uma direção típica erra por 1,8×) e tem o maior cosseno com a direção do proxy (0,620 contra mediana 0,315 do nulo). Em todas as cinco estatísticas ela fica entre os 12% e 20% melhores do nulo. É consistente, e nunca cruza 10%.

### 4.6 O Wald assintótico rejeita o proxy, e a rejeição é provavelmente espúria

`results.md` reporta ξ = **122,9** (gl 5, p < 0,0001) contra a restrição do proxy, e ξ = **149,3** (gl 15) contra o esquema recursivo, com cos(b_GMR, H_proxy) = 0,620. Mas a inferência da Prop. 4 é mal calibrada nesta dimensão: a simulação do bloco D de `validate_gmr_ica.R` (T = 150, n = 6, 200 réplicas — conferi o desenho) põe a cobertura de um intervalo nominal de 95% em **0,79**. Com sub-cobertura dessa ordem, a rejeição não sustenta peso.

O que sobrevive dos testes é o mais modesto e o mais útil: **o esquema recursivo (Cholesky) é rejeitado** — que é a restrição que a literatura de menor dimensão impõe sem testar, e é o uso que o próprio artigo do GMR faz do estimador.

---

## 5. Achados de processo encontrados no caminho

Três coisas que não estavam registradas em lugar nenhum e afetam quem for reusar este material. **As duas primeiras foram corrigidas pela reestimação de 2026-08-01**; ficam registradas porque explicam por que os números mudaram.

### 5.1 O cache do GMR estava numa safra anterior à do painel

`output/nongaussian/gmr_cell.rds` é de **2026-07-27 12:56**; `data/processed/data_log_deseasonalized.csv` foi regerado em **2026-07-28 12:53** (fix de locale B1). Exatamente **3 séries** divergem, todas por um fator estável de **100,0000** nos 49 horizontes: `cds_5y`, `msci`, `sp500_vix`.

**Não contaminava as conclusões.** A padronização BLL absorve reescala pura, então os fatores eram idênticos e as outras 103 séries reproduziam a 1,4e-07. Sinal, cobertura e razões GMR/proxy são invariantes a escala. O que estava errado eram as **unidades reportadas** dessas 3 séries no `results.md` antigo — e duas delas são placebos. No cell reestimado o auto-teste de reconstrução dá diferença **exatamente zero** em todas as 106 séries.

### 5.2 O run de produção do GMR não achava o ótimo do gate

| run | partidas | logLik | coluna rotulada | folga de rotulagem |
|---|---:|---:|---:|---:|
| `nongaussian_gate.R` | 100 | −1209,30 | 1 | 0,039 |
| `model_nongaussian.R` (antigo) | 60 | **−1209,61** | 6 | 0,012 |
| `model_nongaussian.R` (2026-08-01) | 200 | **−1208,60** | 2 | **0,046** |

Os vetores de correlação não eram permutação um do outro: eram ótimos locais diferentes. O déficit do run antigo (0,31) **excedia o próprio gap best→2nd do gate (0,2189)**, com `n_at_best = 1` de 60. Com 200 partidas o run passa a **bater o ótimo do gate**, e o script agora reporta essa reconciliação a cada execução.

O índice da coluna muda entre ótimos (6 → 2) mas **a direção estimada praticamente não muda**: os impactos se movem na terceira casa (`asset_ibov` −10,72 → −10,60; `cambio_usd` 0,238 → 0,235; `embi_perc` 0,442 → 0,446). O índice é rótulo de permutação, não conteúdo.

### 5.3 O que a reestimação entregou — e o que não

Rodou em 22,8 min, não nas ~2h estimadas. Fechou 5.1 e 5.2 e melhorou todas as métricas de corroboração (concordância nas sig90 de 0,951 → **0,971**; discordâncias de 7 → **4**).

**A expectativa que se confirmou:** mais draws **não estreitaram as bandas**. As bandas do GMR seguem ~5,4× mais largas que as do proxy, e as células sig90 próprias do GMR *caíram* de 4 para 1. A largura vem da instabilidade da própria direção monetária entre reamostragens, não de ruído de Monte Carlo — quadruplicar os draws mede essa instabilidade melhor, não a remove.

---

## 6. A afirmação que o material sustenta

**Defensável, com as qualificações no próprio texto:**

> A identificação não-gaussiana de Gouriéroux-Monfort-Renne (2017) — em que o instrumento apenas rotula a coluna monetária e não participa da identificação — **não contradiz** o proxy-SVAR: a estimativa pontual do proxy cai dentro da banda de 90% do estimador não-gaussiano em todas as 5.194 células. Sob a coluna rotulada, o sinal das respostas de curto prazo coincide em 97% das células em que o proxy é significativo a 90%, com razão de magnitude de 1,11.

**A ressalva que tem de vir junto, no mesmo parágrafo** (§4.7): essa concordância de sinal **não é distinguível da que uma direção arbitrária produziria**. Sob 2.000 direções aleatórias normalizadas ao mesmo choque de política, a concordância mediana já é 0,786 e um quarto delas iguala a coluna rotulada (p = 0,179). Omitir isso e reportar só os 97% seria escolher a régua depois de ver o resultado.

**Não sustentado, e cada um por um motivo distinto:**

1. **"Uma identificação independente dá a mesma direção", como afirmação estatística.** A métrica satura e o teste não tem poder (§4.7). Sobrevive o **não-contradiz**, que é mais fraco e continua verdadeiro.
2. **A rotulagem dispensar o instrumento.** As duas regras ancoradas na variável de política selecionam a coluna 1, que concorda em 60% e responde com um quinto da magnitude (§4.5).
3. **O médio prazo.** Concordância cai a 0,246 em h 13-24 e 0,363 em h 25-48 nas células só-sig68 — que é o tier onde vive boa parte da leitura de médio prazo.
4. **A contração de atividade no impacto.** É o único bloco com concordância abaixo de 1,000 (0,733), e as 4 discordâncias de sinal do painel inteiro estão nele (§4.3).
5. **A janela pré-COVID.** A rota não existe ali (5 de 6 inovações gaussianas).
6. **"O GMR confirma as magnitudes."** Ele não rejeita nada porque não determina nada — **1 célula sig90 contra 140**, e essa uma é a normalização.
7. **"Duas identificações independentes concordam."** O gate reprova; a identificação é **parcial**.

## 7. O que faltaria para a afirmação forte

| rota | custo | o que entrega |
|---|---|---|
| **Um teste com poder** | baixo, mas incerto | O gargalo agora não é o estimador, é a **régua**: com 140 células e critério binário o nulo satura (q95 = 1,000 em 3 das 5 estatísticas). A mais promissora é a **razão de magnitude** — é onde a coluna rotulada mais se separa (p = 0,125, e |log| 0,101 contra 0,776 da segunda melhor). Um teste construído sobre o perfil de magnitude, e não sobre contagem de sinais, pode ter poder onde este não tem |
| **LMS (2017)** via `svars::id.ngml` | baixo — pacote pronto | O desempate mais barato: se LMS concordar com GMR, a discordância é do proxy; se ficar no meio, é do método. Aberto em `pendencias.md:755-758`. ⚠ `svars::id.dc`/`id.cvm` são Matteson-Tsay e Herwartz-Plödt, **não** GMR — citá-los como GMR seria erro de citação |
| **Bandas Anderson-Rubin** | médio — tradução de `codigo_olea/MSWfunction.m` | Não é identificação alternativa, mas é o que os três críticos do council pediram e ataca o mesmo flanco (ξ_mp no limiar) |
| **Identificação de ordem > 2 em frequência diária** | alto | A única saída real do beco: sobre observáveis diários, não sobre `eta` mensal, onde a agregação já destruiu os momentos (§3.1) |

---

*Fontes: `output/nongaussian/{gate.md,results.md,gmr_cell.rds}`, `output/nongaussian/corroboration_*.csv` (gerados por `script/nongaussian_corroboration.R`), `_instrucoes/historico_decisoes.md` §0 e §1, `_instrucoes/pendencias.md:731-758`, `output/instrument/mosw_strength_grid.csv`, e `git show fc0ef58^:output/irf/spec_sweep_irf_long.csv` para as IRFs de het arquivadas.*
