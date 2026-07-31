# Rationale — rodada 2026-07-27 a 2026-07-30

Recorte: os 4 commits ainda não enviados a `origin/main` (`c8e2b9c`..`ba081a8`,
27/07 — sweep do vértice de DI, robustez de ξ_mp, kernel HAC, extração do
`build_variants.R`) mais todo o working tree não commitado (28/07 a 30/07 —
rodada de auditoria DFM-IV e reescrita de `tex/main.tex`). Ficam de fora,
por não pertencerem a este trabalho: as notas de leitura em `artigos/`
(Gafarov-Meier-Olea, Mertens-Ravn, Stock-Watson e outras, de uma sessão de
leitura de referências em 27-28/07) e `tex.zip`.

## Objetivo da rodada

Dois objetivos concatenados, na ordem em que aconteceram:

1. **Responder a `prompt_auditoria_dfm_iv.md`** — um pedido de auditoria
   própria (não deste mecanismo) cobrindo 8 tarefas sobre o DFM-IV de
   produção: mapa do pipeline, exogeneidade do instrumento, unidades/sinal,
   composição do painel, inferência robusta a IV fraco, persistência dos
   fatores, o bloco de ativos e dependência de estado na dominância fiscal.
   Resultado em `diagnostics/diagnostico_dfm.md`.
2. **Levar os resultados da auditoria e da rodada (7,6) para o corpo do
   `tex/main.tex`** — escrever `\section{Resultados}` e `\section{Robustez}`,
   que não existiam (a seção da era Cholesky tinha sido apagada em commits
   anteriores), e corrigir no texto o que a auditoria encontrou de errado.

O segundo objetivo mudou de forma **duas vezes** dentro da própria rodada,
por instrução do autor: primeiro a regra de entrada no corpo do texto era
"só banda de 90% excluindo zero" (29/07); depois foi relaxada para a regra
de dois níveis — 90% continua sendo o único nível chamado de
"significativo", mas 68% entra rotulado como "direção e magnitude" (30/07).
Isso não foi uma reformulação estética: mudou quais afirmações o texto faz.

## O que a auditoria (`diagnostics/`) encontrou e o que foi feito com cada achado

- **B1 — locale dos CSVs da investing.com** (`download.R:222-243`): três
  séries (`cds_5y`, `msci`, `sp500_vix`) liam separador decimal errado e
  entravam 100× infladas. Corrigido. Não é achado de metodologia — é bug de
  parsing — mas mudou o CDS de "145× o EMBI" para "comparável ao EMBI"
  (+29,07bp vs +19,95bp), o que por sua vez tornou o CDS um candidato
  plausível a indicador de risco baseline para a Tarefa 7 (ver abaixo).
- **B2 — `yield_6m` ausente de `coherence_var_table()`**: a variável de
  normalização do choque não estava na tabela que sustenta `irf_section.md`
  e o §5, tornando o +50bp não auditável a partir dos artefatos publicados.
  Incluída, com a ressalva registrada de que seu h0 é mecânico (toda
  reamostragem do bootstrap é normalizada ao mesmo ponto).
- **B3 — `commodity_metal` classificado como placebo violado**: era, antes
  desta rodada, o caveat mais concreto contra a validade do instrumento,
  citado em quatro documentos diferentes. A Tarefa 1.6 mostrou que o índice
  do BCB é denominado em R$ e herda o câmbio mecanicamente; a contraparte em
  US$ passa limpo (0/25 horizontes significativos). Reclassificado de
  `placebo` para `ambiguous`. **Decisão explícita de não estender**: a
  ortogonalização cambial não foi generalizada para outras séries com o
  mesmo problema potencial, porque `commodity_metal` era o único caso
  identificado e generalizar sem mais evidência seria engenharia especulativa.
- **B4 — `yield_ordering_ok` e `magnitude_flag`**: computados em
  `spec_sweep_cells.csv`, nunca lidos por `classify_sweep_cells`. Decisão do
  autor: documentar como régua reportada, não promover a critério de seleção.
  Motivo prático — `yield_ordering_ok` é FALSE na própria célula de produção
  (58 de 68 células `ok`), porque o pico da curva no impacto está em 2-5 anos,
  não no vértice de política; promovê-la reprovaria a produção pelo próprio
  critério que a rodada estava validando.
- **Achado metodológico reutilizável 1** — o χ² assintótico super-rejeita
  2,3×-5,3× nesta amostra (Tarefa 7): comparações de subamostra passaram a
  usar wild block bootstrap sob H0 em vez do quantil assintótico.
- **Achado metodológico reutilizável 2** — `sandwich::NeweyWest` sobre um
  `lm` de segundo estágio usa a *meat* errada para IV (`estfun.lm` monta o
  score com o resíduo da regressão de segundo estágio, não o estrutural).
  `07_dominancia_fiscal.R` passou a montar o sanduíche IV analítico à mão,
  com autoteste `stopifnot()` contra `sandwich::lrvar`.
- **Tarefa 7 — dependência de estado**: o veredito inicial (rodando sob EMBI)
  era "nem impacto nem persistência dependem de estado" — um negativo limpo.
  Rodar os mesmos testes sob os outros 6 indicadores de risco mostrou que
  EMBI é o único dos 7 que não vê nada; sob CDS e sob ΔDBGG a persistência em
  h=6-8 *é* dependente de estado (t = 2,0 a 3,6, primeiro estágio forte em
  ambos os regimes). **Decisão do autor**: migrar o baseline de EMBI para
  CDS e reportar os três indicadores lado a lado no texto, em vez de escolher
  um silenciosamente. A subseção nasce com a ressalva de que a conclusão
  depende do indicador (EMBI e CDS correlacionam 0,933 em MA12 e ainda assim
  discordam de regime em 24 de 141 meses).

## Alternativas consideradas e por que foram descartadas

- **Regra de 90% pura para o corpo do texto (29/07).** Aplicada primeiro,
  depois revertida no dia seguinte por instrução do autor: "sem perder a
  honestidade quanto a afirmações de significância" — ou seja, a objeção não
  era ao rigor de 90%, era ao fato de a regra esconder a cadeia de
  transmissão inteira do próprio paper (92 pares a 90%, todos em h≤12, contra
  706 a 68% distribuídos num U por todo o horizonte, com um segundo pico em
  h=26-32). A alternativa escolhida — dois níveis, com o rótulo carregando
  o peso epistêmico — preserva a honestidade (68% nunca é chamado de
  "significativo") sem apagar o que só aparece no médio prazo.
- **Seção de estado como anexo vs. seção de corpo.** Descartado o anexo:
  o `anexosenv` do `abntex2` usado neste documento é `\chapter`-level e já
  está reservado à tabela de 106 variáveis; além disso, a dependência de
  estado é um resultado da rodada, não material suplementar, e teria sido
  incoerente classificá-la como apêndice ao lado de um achado (B3) que virou
  corpo do texto.
- **EMBI como baseline de risco (mantido até 28/07).** Descartado a favor de
  CDS em 29/07 porque EMBI é o único dos 7 indicadores testados que não
  detecta a dependência de estado que os outros 6 (incluindo o quase-colinear
  CDS, correlação 0,933) detectam — manter EMBI como baseline teria reportado
  um negativo que não generaliza, sem dizer isso.
- **Promover as 4 rejeições sobreviventes de Holm-bootstrap no IFNC (achado
  da re-rodada sob CDS) a evidência de dependência de estado.** Descartado:
  o teste apropriado para "esta variável depende de estado" é o teste
  conjunto por variável, não o teste horizonte a horizonte, e o IFNC não
  rejeita no teste conjunto (p_boot 0,222 e 0,257) sob nenhum dos dois
  indicadores. Promover teria sido p-hacking por multiplicidade não corrigida.
- **Generalizar a correção de denominação (B3) para outras séries em R$.**
  Descartado por falta de evidência — `commodity_metal` foi o único caso em
  que a contraparte em outra moeda estava disponível e discordava
  qualitativamente; não há como saber se o mesmo mecanismo afeta outras
  séries sem o mesmo tipo de contraparte, que não existe no painel.
- **Manter `sec:alcance` (o "alcance estatístico do exercício") como seção
  própria.** Descartado: sua única função — justificar por que o texto parava
  em h=12 — deixou de existir quando a regra de dois níveis passou a cobrir
  todo o horizonte. Os dois fatos que carregava (contagem 92/706 e a razão
  |ponto|/meia-banda) foram realocados para Limitações, e o segundo mudou de
  papel: de argumento para parar em h=12 para evidência de que o médio prazo
  tem |t| perto de 1, não de que é ruído.

## O que ficou deliberadamente de fora

- **Abstract, introdução e conclusão** — continuam da era Cholesky e
  contradizem o §2 e o §5 recém-escritos (resumo diz "apreciação de 8%" e
  "queda de 3% em ações"; a estimativa medida é depreciação de 3,64% e o
  bloco de ações tem zero células sig90). Há um `% TODO` no `.tex` registrando
  isso. Não foi escrito nesta rodada porque a prioridade foi fechar §4/§5
  primeiro, mas fica como o item mais visível e mais urgente da lista —
  qualquer circulação do PDF antes de resolver isso expõe a contradição.
- **Inversão de Anderson-Rubin** — a Tarefa 4 (inferência robusta a IV fraco)
  ficou INCONCLUSIVA por depender dela; segue adiada, é o item #1 de
  `pendencias.md`.
- **Tarefa 6.3 (juro real / NTN-B)** — declarada NÃO EXECUTÁVEL, não
  contornada: a cache do `rb3` não tem `b3-reference-rates` e as colunas
  `breakeven_*` em `raw_data.csv` são 100% NA.
- **Tarefa 8 (sensibilidade a r,q)** — não foi pedida no prompt de auditoria
  original e não entrou por escopo, não por esquecimento.
- **Parágrafo de Jentsch-Lunsford** — não entrou no §5 por exigir uma
  referência bibliográfica nova, contra a restrição desta rodada de não
  acrescentar citações fora das 25 já presentes (a §2 já havia acrescentado
  duas: `goncalves2025` e `bagliano1998`, e não se quis abrir uma terceira
  exceção na mesma rodada). Fica registrado como destinado ao §3.
- **Bonomo-Martins (crédito direcionado) e Blanchard (dominância fiscal)** —
  a leitura de crédito direcionado foi escrita e depois descartada da
  promoção dos blocos comentados por não ter citação disponível no texto sob
  a mesma restrição de não acrescentar referências.
- **Enquadramento do GMR (identificação não-gaussiana)** — decisão de
  manchete-vs-teste explicitamente deixada em aberto para o autor; esta
  rodada não tentou resolvê-la nem silenciosamente assumiu uma posição no
  texto.
- **`§3.2` ("cerca de 110 séries")** — não corrigido para o número exato (106);
  ficou registrado como pendência, não uma correção esquecida sem registro.

## Como verificar

O achado mais fácil de checar por número: `commodity_metal` deveria mostrar
+3,43% (não +10,4%, que é um erro de unidade do documento antigo) em
`output/irf/irf_coherence_h.csv`, e 0/25 horizontes significativos na
contraparte em US$ descrita em `diagnostics/01_exogeneidade.R` §1.6. A regra
de dois níveis deveria produzir exatamente 15 ocorrências de "significativ"
em `tex/main.tex`, todas em contexto de banda de 90% — nenhuma associada a
68%.
