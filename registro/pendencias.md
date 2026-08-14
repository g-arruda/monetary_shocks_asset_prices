# Pendências

**Última revisão:** 2026-08-13. Itens abertos organizados por tema (A-E);
cada tema termina num bloco `### Fechados (contexto)` com o que já foi feito,
resumido a poucas linhas — o detalhe completo mora no working-note ou output
apontado ali, nunca duplicado aqui. Resultados negativos e decisões
revertidas ficam em [`historico_decisoes.md`](historico_decisoes.md) —
consulte antes de propor um caminho novo.

---

## Convenção de manutenção deste arquivo

- **Item novo** entra como `- [ ]` dentro do tema A-E correspondente — nunca
  solto no fim do arquivo. Se não couber em nenhum dos cinco, nasceu um tema
  novo: criar uma seção `F.`, `G.` etc., não forçar em "Código e higiene"
  como gaveta genérica.
- **Item fechado** muda de `[ ]` para `[x]` e **muda de lugar**: sai do topo
  da seção e vai para o bloco `### Fechados (contexto)` do mesmo tema,
  comprimido para **2-4 linhas** — o que foi feito, o veredito, os 1-3
  números que mais importam, e o pointer (`Nota:`/`output/...`) para quem tem
  o detalhe completo. Nunca deixar a narrativa longa no lugar do item aberto.
- **Ressalva `⚠` sem outro registro no repo** não pode ser cortada na
  compressão — vira uma das linhas do resumo, não uma nota perdida.
- **Trabalho que aparece só ao fechar um item** ("isso ainda fica em aberto:
  X") vira um `- [ ]` **próprio** no tema certo — nunca uma frase solta
  dentro do item fechado. Foi esse padrão que escondeu dois itens nesta
  reorganização (a reescrita de `arquivo/tex/main.tex:183` (archived draft) e a ressalva de §4 sobre a
  reversão de médio prazo, ambos pendurados dentro de itens já `[x]`).
- **Dependência entre itens** declara-se nos dois sentidos — o bloqueador diz
  o que destrava, o dependente diz do que depende — e aparece na tabela
  `Índice de itens abertos`.
- **Índice de itens abertos** atualiza a cada abertura/fechamento; é o único
  lugar que deve dar, de relance, a lista completa do que falta.
- `Especificação corrente` e `Rota metodológica decidida` são referência
  viva: **editar in place** quando mudam (troca de instrumento, de r/q,
  etc.), nunca duplicar um bloco novo ao lado do antigo.

---

## Especificação corrente

| item | valor |
|---|---|
| Identificação | proxy-SVAR (instrumento externo), `H = (Z'η)/(Z'Z)` |
| Instrumento | **`z_jk_bs_purif`** — surpresa DI Qua→Qui no vértice 126 du + ortogonalização Bauer-Swanson **pré-evento** + máscara JK em resíduos predeterminados |
| Variável de política | `yield_6m`, choque +50bp no impacto (+0,005 em proporção decimal) |
| Dimensão | **r = 5, q = 5**, VAR(p = 6) nos fatores; `r` por Bai--Ng IC2 BLL, `q` provisório |
| Painel | **111 séries**, variante `drop_setor_externo__eua__credito__imoveis`, 2013-01 a 2025-09 (153 observações alinhadas; 147 inovações fatoriais após p=6) |
| Inferência | wild bootstrap Gonçalves-Kilian, Kilian (1998) só no DGP do bootstrap; nboot = 800, seed 123, bandas 68/90, h = 0-48 |
| Força | ξ_mp/F_rob,mp = **6,27085/10,12054** full e **10,99268/9,74746** pré-COVID; raiz máxima 0,964858 full e 1,000202 pré-COVID |

Esta tabela descreve a produção vigente. O painel-base de 106 séries continua
em arquivo separado somente para reproduzir as grades históricas. A recomendação
intermediária de 123 séries `(4,3)` foi superada pela decisão e migração de
2026-08-13. O paper continua desatualizado por decisão explícita desta rodada:
nenhum arquivo `.tex` foi modificado.

---

## Índice de itens abertos

| Tema | Item | Observação |
|---|---|---|
| A | Reescrever `paper/paper_anpec.tex` para a produção 111 `(5,5)` | revisão extensa: resumo, método, resultados, robustez, conclusão, legendas e apêndice; checklist abaixo |
| A | §5 Robustez em `paper/` tem 3 subseções — faltam het/GRG-GMR, construção do instrumento, especificação e Limitações | destravado em 2026-08-09; números da vintage anterior não podem ser portados |
| A | Escrever a subseção de robustez sobre heterocedasticidade (Rigobon) | 288 células válidas/320 desenhadas, nenhuma identifica; entra depois de `sec:confound` |
| A | Ressalva §4 + Limitações sobre a reversão de médio prazo | raiz 0,964858; retirar a leitura antiga de “um modo quase unitário” |
| A | Documentar a mecânica do bootstrap no texto | — |
| A | Vertente de prêmio de risco cambial ausente do §2 | exige chave nova (regra das 25) |
| A | Corrigir leitura do IMAT em §4.6 | independente, sem citação nova |
| A | Conversão percentual do câmbio não é escala-livre; comparações usam bases diferentes | refazer com impacto corrente de 3,84% por 50 pb |
| A | Atribuição errada do limiar "≥10" a Montiel Olea-Stock-Watson | council 2026-08-10, sem citação nova |
| A | Portar reconciliação com GRG (2025) para o corpo do §6 | decisão já tomada (Tema D), falta redação; réplica precisa rodar na vintage atual |
| A | Bandas Anderson-Rubin no `.tex` | adiadas sem prazo em 2026-08-12; linha que faltava no índice |
| A | Reescrever o papel da Selic em §4.1 | na produção corrente ela sobe e exclui zero a 90% em h=0--11; CDI saiu |
| A | Convenção de horizonte do §4 (impacto vs. pico em h=1) | blindspot 2026-08-12; casar com o item de base 100 pb |
| A | Reportar as cinco moedas no §4.2, não duas | blindspot 2026-08-12; dado já estimado, nada a rodar |
| A | Bloco de agregados monetários ausente do §4 | blindspot 2026-08-12; dado já estimado |
| A | Reportar os oito EPU no §5.1, não só o escolhido | blindspot 2026-08-12; interage com o item do `sp500_vix` |
| A | §4.5 não diz que o price puzzle é de amostra cheia | blindspot 2026-08-12; bloqueado pelo item de IPCA cross-instrumento (Tema D) |
| B | Bandas simultâneas (Montiel Olea-Plagborg-Møller 2021) | exige referência nova |
| B | Validade do wild bootstrap (Jentsch-Lunsford) | mínimo aceitável: 1 parágrafo no §3 |
| B | LP-IV como robustez à especificação dinâmica | desejável, não bloqueante |
| B | Comunalidade baixa (`price_core_ipca_ex0`, `asset_ifix`) | — |
| B | Decomposição do wedge de UIP | prioridade alta, council 2026-08-10; só pós-processamento |
| B | Corrigir descrição do placebo `sp500_vix` (é só VIX, sem S&P 500) | council 2026-08-10, achado factual |
| B | Bandas Anderson-Rubin (implementação) | adiadas sem prazo em 2026-08-12; linha que faltava no índice |
| B | Decompor a curva entre expectativa e prêmio (diário vs. mensal) | blindspot 2026-08-12, prioridade alta; depende da correção do Tema E |
| B | A amplificação 5a/6m é do choque ou de Λ? | blindspot 2026-08-12; teste discriminante do item acima |
| B | Tratar a janela pré-COVID como diagnóstico de força/estabilidade | raiz 1,000202 impede usá-la como evidência dinâmica |
| C | Decidir enquadramento do GMR no paper | — |
| C | Construir um teste com poder | — |
| C | LMS (2017) como terceira leitura | desempate mais barato disponível |
| D | Comparação cross-instrumento do IPCA sob (5,5) | dado já existe, falta rodar |
| D | Spread de concessões novas | desejável, não bloqueante |
| E | Corrigir o `cumsum` do bloco acionário | só o transform, não o painel |
| E | Fundamentar ou substituir o default operacional `q=5` | `r=5` está decidido pelo Bai--Ng IC2; `q=5` permanece provisório |
| E | Corrigir o caso escalar `q=1<r` em `estimate_dynamic_factors()` | defeito exposto pela grade nova; produção `(5,5)` não é afetada |
| E | `kilian_correction`: determinante em matriz enorme | não mexer sem re-rodar smoke test |
| E | Cortar a `tab:first_stage` | relatório já regenerado em 2026-08-05; falta o `.tex` |
| E | Seleção da etapa 2 dominada pela janela pré-COVID | — |

---

## A. Texto do paper

- [ ] **Reescrever `paper/paper_anpec.tex` para a produção de 111 séries
  `(5,5)`** — *aberto em 2026-08-13 por separação deliberada de escopo.* Não é
  uma substituição mecânica de `106` por `111`: o resumo, a seleção de dimensão,
  quase toda a interpretação das IRFs, três exercícios de robustez, as legendas
  e a lista de variáveis ainda descrevem a produção `(7,6)` de 106 séries. As
  figuras e `output/irf/irf_section.md` já foram regenerados; nenhum `.tex` foi
  alterado. A rodada editorial deve cumprir, no mínimo, a checklist abaixo.

  - **Resumo, abstract, introdução e conclusão:** substituir em conjunto as
    quatro manchetes de impacto: BRL/USD **3,84%** (IC90 [2,24; 6,06]), EMBI+
    **26,2 pb** ([17,2; 47,3]), CDS 5 anos **32,5 pb** ([22,2; 53,8]) e DI 5
    anos **77,6 pb** ([57,9; 111,0]). Atualizar painel para 111 séries e
    `xi_mp` para **6,27085**. Preservar a formulação “compatível com transmissão
    via prêmio de risco”, mas retirar a atribuição causal a dominância fiscal e
    qualquer alegação de que o prêmio “domina” o diferencial sem a decomposição
    do wedge de UIP do Tema B. As versões portuguesa e inglesa precisam fechar
    exatamente nos mesmos números e qualificações.
  - **Base e proveniência:** declarar 153 meses, 111 séries e 147 inovações;
    registrar que saem `juros_cdi`, `asset_mlcx` e os quatro blocos candidatos
    excluídos, enquanto permanecem as três séries fiscais e quatro de
    expectativas. Corrigir a afirmação de que a curva foi ajustada no projeto
    por Svensson: `data/raw/yields/yields_dia.csv` é insumo externo fixo, sem
    produtor no repositório. Corrigir também a fonte do CDS para o arquivo fixo
    Bloomberg `data/raw/CDS 5y.xlsx`, não Investing.com. Não reivindicar
    reprodutibilidade desses dois insumos.
  - **Seleção e força:** reescrever integralmente a subseção de seleção de
    `(r,q)` e a `tab:rq_sweep`. `r=5` é decidido pelo Bai--Ng IC2 padronizado
    para BLL; `q=5` é default operacional **provisório**, não escolha pela célula
    de maior força. Reportar `p=6`, `xi_mp/F_rob,mp = 6,27085/10,12054` na
    amostra cheia e `10,99268/9,74746` pré-COVID. A janela pré-COVID tem raiz
    **1,000202** e não pode sustentar interpretação dinâmica; a cheia tem raiz
    **0,964858**. Revalidar, em vez de portar, a comparação Selic versus DI 6m.
    Fonte: `output/instrument/mosw_strength_grid.csv`,
    `output/validation/production_spec_diagnostics.csv` e
    `output/irf/irf_section.md`.
  - **Resultados e legendas:** reescrever as seis subseções e auditar cada
    legenda contra `output/irf/irf_coherence_h.csv` e
    `output/irf/irf_coherence_leitura.md`. No impacto, a curva 3m/1a/2a/5a/10a
    responde **38,7/63,3/74,3/77,6/70,3 pb**; a Selic responde, não é mais
    controle nulo, e o CDI não está no painel. Em atividade, somente indústria
    de transformação, duráveis, horas e IBC-Br caem no impacto com banda de
    90%; em crédito há cinco classificações incoerentes; IPP exclui zero a 90%
    em h=0--3 e IPCA cheio não; os sete índices acionários caem no ponto de
    impacto, mas somente IFIX exclui zero a 90% (quatro horizontes). Remover
    contagens, picos, vales e janelas herdados da vintage anterior. Banda de
    68% nunca deve ser chamada de significância.
  - **Reversão:** retirar a narrativa de que um único par quase unitário produz
    os vales. A raiz corrente é 0,964858, com período 65,8 meses, e apagar o par
    dominante não inverte nenhuma das 14 respostas examinadas; 13 de 14 vales
    sobrevivem. A formulação defensável é apenas que a reversão descreve a
    dinâmica conjunta estimada e não constitui confirmação independente do
    canal econômico. Fonte: `output/factors/factor_stationarity.md`.
  - **Robustez:** atualizar todos os valores de exogeneidade/placebos e o texto
    da `fig:placebos`; substituir o confound soberano antigo pelos resultados
    `6,271 -> 6,619 -> 7,576` quando só os valores são ortogonalizados e
    **4,264** quando a máscara é rederivada; substituir também a vintage FOMC
    pelos resultados de `output/instrument/fomc_coincidence.md`. Incorporar ou
    justificar a omissão do benchmark VAR corrente, do gate GMR e do exercício
    de heterocedasticidade. Não portar números de notas anteriores sem
    reconferência nos relatórios gerados em 2026-08-13.
  - **Apêndice:** reconstruir `tab:lista_variaveis` a partir da ordem canônica
    de `data/processed/data_log_deseasonalized.csv`, não por edição parcial.
    Excluir CDI e MLCX; incluir `fiscal_dbgg`, `fiscal_dlsp`,
    `fiscal_primary_balance`, `expect_focus_ipca12m`,
    `expect_focus_selic_ny`, `expect_focus_pib_ny` e
    `expect_focus_cambio_ny`, todos com código de transformação 1 e fontes
    conferidas em `output/panel/production_candidate_manifest.csv`. A tabela
    final deve conter exatamente 111 linhas de séries.
  - **Gate editorial:** buscar e eliminar referências ativas a 106, `(7,6)`,
    5,55%, 117,0 pb, 32,0 pb, 43,4 pb, `xi_mp=7,65`, CDI e MLCX; conferir que as
    sete figuras hoje incluídas têm texto e legenda compatíveis com a vintage
    corrente e decidir explicitamente se `fig_estado.pdf` entra como oitava;
    compilar sem referências/citações indefinidas; executar `git diff --check`;
    e confirmar que nenhum `.tex` além de `paper/paper_anpec.tex` foi tocado.

*Inclui os achados do council review de `arquivo/tex/main.tex` (archived draft; `paper/paper_anpec.tex` is now canonical) em 2026-07-31 —
revisão paralela de três críticos independentes (harsh-referee e
macro-theorist em Claude Opus, methodologist via Gemini 3.1 Pro como par
cross-vendor). Veredito da síntese: **Major Revision**, não Reject — os dois
problemas de aparência mais fatal (sem benchmark VAR, sem bandas AR) pareciam
trabalho não feito, não defeito estrutural. O benchmark VAR foi rodado (ver
"Fechados" abaixo); a tentativa AR de 2026-08-10 foi retirada em 2026-08-12 e
está adiada nas condições do Tema B. Relatório completo:
`pareceres/council_2026-07-31.md`.*

*Segundo council review, agora sobre `paper/paper_anpec.tex` diretamente
(não mais o draft arquivado), em 2026-08-10 — painel macro-paper de 4
críticos (methodologist, macro-theorist, skeptic, harsh-referee, todos Claude
Opus). Veredito: **Major Revision**, mesma classificação do round anterior,
mas por razão diferente: três das quatro alegações-manchete do paper
(reversão sincronizada de médio prazo, nulo do bloco de ações, reconciliação
com GRG) são contraditadas por evidência que já está no próprio repositório,
não por falha nova de identificação. **O fato central sobrevive** — câmbio +
EMBI+/CDS conjuntos, sig90 no impacto — só a atribuição de mecanismo
("domina o diferencial de juros", "dominância fiscal") não. Achado mais
grave: `data/raw/fomc_dates.csv` nunca existiu, então a flag `fomc_coincide` que
o código computa é sempre FALSE por default vazio — **fechado no mesmo dia**
(ver Fechados abaixo): a exposição era ainda maior do que o council estimou
(24 dos 62 dias retidos, 35,5% de Σ|z|, 8 dos 20 de maior alavancagem), mas
o teste **não encontra contaminação**. Segue aberto o item factual de que
`sp500_vix` é só o VIX (o painel não tem nenhuma série de nível do S&P 500).
Relatório completo, com as quatro críticas brutas e a síntese com Named
Dissents: `pareceres/council_2026-08-10.md`.*

- [ ] **A `§5 Robustez` de `paper/paper_anpec.tex` tem 3 subseções, mas as três
  ainda carregam números da produção anterior e faltam as demais frentes da
  composição recomendada.**
  Escritas: `sec:exogeneidade` (previsibilidade do instrumento mensal em cinco
  especificações com wild bootstrap, Ljung-Box justificando `nw_lags = 0`,
  teste `commodity_metal` em R$ contra US$ e `fig_placebos`), `sec:confound` e
  `sec:fomc`. Os números então incorporados — inclusive ξ_mp = 7,87 no teste de
  metais, 7,65 no baseline soberano e os valores da variante FOMC — **não são
  mais citáveis**; reescrever contra os relatórios gerados em 2026-08-13. A
  conclusão já é a §6 e as remissões a "Seção 5" estão repontadas.
  **O que falta, na ordem da composição recomendada:** identificação
  alternativa e divergência com GRG/GMR, heterocedasticidade mensal,
  construção do instrumento e dimensão do sistema (A3 + A4 + A2),
  especificação do modelo (A5 + A1 + A7 + LP-IV com o rótulo certo) e
  **Limitações**. A prosa antiga de `arquivo/tex/main.tex` pode servir de mapa de
  tópicos para Limitações e `sec:estado`, mas nenhum número dela deve ser
  portado.
  A nota da `fig:acoes` que promete uma discussão "no texto" continua sem
  contrapartida.
- [ ] **Escrever a subseção de robustez sobre identificação por
  heterocedasticidade.** Os números existem, estão conferidos e a leitura está
  redigida em `notas/2026-08-01_robustez_heterocedasticidade.md` §7
  ("o que pode e o que não pode ser escrito"); falta só a redação no `.tex`.
  **Nenhum `.tex` foi tocado nesta rodada — proibição do autor em 2026-08-01.**
  A dependência de a §5 existir foi resolvida em 2026-08-09.
  - **Onde:** como §5.3, depois de `sec:confound`, que é onde a composição
    recomendada a coloca — as três primeiras subseções defendem a
    identificação em ordem crescente de agressividade, da exogeneidade do
    instrumento à troca da hipótese identificadora. Label sugerido
    `sec:heterocedasticidade`.
  - **Chaves de bibliografia já existem** — `rigobon2003` e `goncalves2025`;
    **não** é preciso entrada nova. A condição de autovalores distintos é de
    Lanne-Lütkepohl (2008), que **não** está no `.bib`: ou se adiciona a entrada,
    ou se enuncia a condição sem atribuição específica (ela é parte do arcabouço
    de Rigobon).
  - **A ordem do argumento:** (i) todo o resto do §5 varia a receita do
    instrumento, não a identificação — Rigobon dispensa a restrição de exclusão e
    identifica por segundos momentos; (ii) a grade desenha 320 células e tem
    **288 com status `ok`** — o regime por episódio só existe na janela cheia —,
    **nenhuma identifica**, e não é severidade de correção (Holm interno ao
    desenho mantém zero nos cinco); (iii) **segunda condição necessária falha
    em separado** — autovalores generalizados não distintos (gap relativo
    mediano **0,137-0,188**) —, e por isso **nenhuma IRF é reportada**, o que precisa
    ser dito explicitamente para o leitor não procurar uma figura; (iv) o
    diagnóstico: o salto de volatilidade pós-2020 é **fator de escala comum**
    (`volatilidade_juros` põe 47,8% dos meses no regime alto contra 5,1% antes e
    mesmo assim não rejeita proporcionalidade em nenhuma célula); (v) a
    reconciliação com `goncalves2025`.
  - ⚠️ **Não escrever como corroboração.** Não há IRF, logo não há concordância
    de sinal a reportar. É *justificativa do desenho* e *reconciliação de
    frequência*.
  - ⚠️ **Incluir a variável inconveniente:** no mesmo sistema diário o IBOV
    responde **+2,83%** por 100bp (sinal errado), com participação espectral de
    0,0015 — ações não identificadas naquele desenho, e por isso a comparação de
    ações entre os dois exercícios não é possível.
- [ ] **Bandas Anderson-Rubin no `.tex` — ADIADAS SEM PRAZO e sem prioridade
  ativa em 2026-08-12.** A implementação plug-in foi retirada e seus números
  não são operacionais. Não escrever resultados AR no paper antes de existir
  fundamentação teórica ou procedimento que incorpore a estimação dos fatores
  e loadings. A menção genérica a Anderson-Rubin como alternativa para IV fraco
  permanece na §3.7; as bandas de 68%/90% do wild bootstrap são a única
  inferência reportável. Histórico em `historico_decisoes.md` §7.
- [ ] **Redigir a ressalva no §4 e o parágrafo em Limitações sobre a reversão
  de médio prazo — REFORMULADO após a produção `(5,5)`.** O diagnóstico antigo
  de um único par quase unitário, |λ| = 0,976794 e período 117,9 meses, foi
  superado. Na produção corrente, a raiz dominante é **0,964858**, complexa,
  com período **65,8 meses**. Apagar o par dominante não inverte o sinal de
  nenhuma das 14 respostas e preserva 13 dos 14 vales em escala comum; a razão
  mediana de magnitude é 1,041. Logo, o paper **não pode** dizer que a reversão
  é gerada por um único modo quase unitário nem tratar a remoção desse modo como
  teste que a derruba.

  A formulação defensável continua estreita: os vales e inversões são
  implicações da dinâmica conjunta estimada e **não são evidência independente**
  do canal econômico proposto. Reportar separadamente que a sensibilidade a
  `p` é grande (a mediana do horizonte do extremo de médio prazo muda de 42,5
  em p=1 para 29 em p=4 e 36 em p=6) e que a janela pré-COVID é marginalmente
  explosiva (raiz 1,000202). Fonte corrente:
  `output/factors/factor_stationarity.md`. A ressalva do §4 pode ser escrita já;
  a versão longa depende da subseção Limitações.
- [ ] **Documentar no texto a mecânica do bootstrap que o código já acerta.**
  O mesmo draw Rademacher é reusado para o instrumento e os resíduos
  (`R/modeling/impulse_responde.R:669-675`) e o DFM é reestimado dentro de cada
  réplica (`:600-610`) — ambos frequentemente errados na literatura aplicada e nenhum
  dos dois está afirmado no texto. Complementar com o número de réplicas
  falhas: **zero em 800** no gate corrente. Registrar também que, se uma réplica
  falhar, o código a substitui pelo ponto estimado (`:679-682`), o que estreitaria
  as bandas mecanicamente, embora esse caminho não tenha sido acionado; e uma nota
  sobre `Idio` ficar fixo entre réplicas (subestima a variabilidade amostral de
  Λ̂). Achados verificados no código pelo harsh-referee e re-conferidos na
  síntese, não só extraídos da prosa.
- [ ] **Vertente de prêmio de risco cambial ausente da revisão de literatura** —
  *aberto em 2026-08-02, a partir da leitura de Dalgic & Ozhan, "Dominant
  Currency Pricing and Currency Risk Premia", IMF WP/26/158, jul/2026 (antes
  circulado como "Global Shocks and Local Response: Currency Risk and Monetary
  Policy"). Fonte:
  `/mnt/storage/Documents/pdf_to_md_out/Dalgic, ozhan - Dominant Currency Pricing and Currency Risk Premia/`.*
  A introdução do `paper/paper_anpec.tex` abre na UIP e o resultado
  central é uma falha dela, mas as **46 chaves de `references.bib` não têm
  nenhuma referência de macro internacional / prêmio de risco cambial** — nem
  Lustig-Roussanov-Verdelhan, nem Kalemli-Özcan, nem Gopinath, nem
  Aoki-Benigno-Kiyotaki. Documenta-se uma falha da UIP sem citar a literatura
  que estuda por que a UIP falha sistematicamente em emergentes. O escopo é
  pequeno: **um parágrafo curto no §2 e uma ou duas frases na §4.2**, não uma
  seção.
  - **O fato citável, e é o único dado direto que o paper oferece:** o Brasil
    está na amostra de 25 países (2003:02-2018:11) e a §2.4 o nomeia — junto de
    Turquia, Chile e Peru — entre os de **correlação PIB-câmbio real mais
    negativa e maiores retornos excedentes médios** (Figura 2, R² = 0,172). Ou
    seja, na seção transversal o real se deprecia em recessão: ativo local é
    mau hedge e paga prêmio. É *background* independente para a afirmação de
    que no Brasil o câmbio é objeto macro-financeiro, não só preço relativo.
  - **A moldura conceitual que falta à §4.2**, hoje com uma única leitura
    (dominância fiscal, que o próprio texto diz não testar: linha 142): a §5.3
    deles formaliza o câmbio deixando de absorver choque e virando
    *macro-financial state variable* que precifica risco.
  - **Uso mais forte — eles são a alternativa concorrente, não um aliado.** O
    mecanismo deles é prêmio de risco **cambial privado** (passivo bancário em
    dólar × rigidez de preço de exportação em dólar); a evidência do §4.2 é
    risco de crédito **soberano** (EMBI+ e CDS 5a). As palavras *fiscal*,
    *sovereign*, *default*, *EMBI* e *CDS* não aparecem no corpo do paper deles
    — não há bloco fiscal no modelo. Citá-los como microfundamentação
    **não-fiscal** do mesmo co-movimento e argumentar que a resposta conjunta
    de EMBI+/CDS é objeto de crédito soberano que essa leitura não entrega é
    mais defensável do que a moldura única de hoje.
  - ⚠️ **Não escrever como corroboração do sinal cambial.** Todo o exercício
    quantitativo deles é choque de juro **externo** ($R^*$); a regra de Taylor
    doméstica tem um $\varepsilon_{R,t}$ (eq. 48) que **nunca é simulado** em
    lugar nenhum do paper. Não há previsão "aperto doméstico → depreciação".
  - ⚠️ **Não invocar o mecanismo estrutural para o Brasil.** Ele exige
    *interação*: invoicing alto **e** dívida em dólar alta; invoicing alto
    sozinho "generates only a modest premium" (§5.2). O Brasil tem faturação de
    exportação em dólar altíssima mas dolarização de passivo bancário e de
    dívida pública baixa para padrão emergente — cai na célula fraca do 2×2
    deles. Citar o fato empírico da §2.4, não a calibração ($\bar\phi = 0{,}25$,
    alavancagem ≈ 8). Antes de qualquer afirmação mais forte, conferir se o
    Brasil está sequer nas regressões da Tabela 4 (14-20 observações).
  - ⚠️ **Não usar a §5.4 no bloco de preços.** O resultado "prêmio cambial mais
    alto → juro neutro ajustado a risco mais alto → Taylor de intercepto fixo →
    inflação acima da meta" conversa em sinal com o §4.5 (toda resposta de
    preço sig90 é positiva, nenhuma desinflação significativa), mas é
    **comparação de estados estacionários estocásticos entre economias, não uma
    IRF a choque monetário**. Não pode virar "a teoria prevê meu resultado de
    preços".
  - **Apoio marginal aos preditores do instrumento** (§3.4): a Tabela 3 deles
    mostra o fator dólar carregando em retorno do S&P 500 (1,533***) e não no
    VIX, e o fator carry em Δlog(VIX) (−0,085***) e não no S&P 500 — os dois
    juntos varrem os fatores globais de retorno cambial, que é justamente o par
    usado na camada Bauer-Swanson. Uma linha, se couber.
  - **Custo:** 1-2 chaves novas no `.bib`, o que colide com a regra das 25
    chaves — decisão do autor. É *working paper* do FMI de jul/2026, ainda não
    publicado; citar como WP.
- [ ] **Corrigir a leitura do IMAT em §4.6** (`paper/paper_anpec.tex:478`)
  — *aberto em 2026-08-02; atualizado para a produção de sete índices.* O
  texto explica o IMAT ser o único índice sem banda de 68% em h=1 dizendo que
  seus componentes são
  "exportadores **amortecidos pela depreciação** da mesma janela". Sob
  *dominant-currency pricing* esse é exatamente o canal que **não** funciona:
  preço de exportação rígido em dólar não baixa rápido para o comprador externo,
  e economias de invoicing alto ajustam o preço em dólar de forma mais lenta e
  mais fraca (Dalgic-Ozhan §5.3 e Figura 5). O amortecimento sobrevive, mas por
  outro motivo: para exportador de commodity a receita já é em dólar e o custo
  em real, então a depreciação eleva a receita em BRL por **translação
  imediata**, sem nenhum *expenditure switching*. O ponto corrente é próximo
  de zero (−0,07 em h=0 e +0,14 em h=1), sem banda de 68%; trocar “amortecidos pela
  depreciação" por algo como "amortecidos pela receita denominada em dólar"
  fecha a inconsistência e **alinha a frase com a §4.2**, que já usa exatamente
  essa leitura de denominação para o índice de commodities do BCB em reais.
- [ ] **A conversão percentual do câmbio não é grandeza escala-livre, e as
  comparações com a literatura usam bases diferentes** — *aberto em
  2026-08-10, council review; números atualizados em 2026-08-13.* O BRL/USD
  entra no painel em **nível** (Anexo A, código 1), e a conversão para
  percentual usa a média amostral de 4,1117. Assim, o impacto corrente de
  R$ 0,1579 vira **3,84% por 50 pb**, mas representa percentuais diferentes se
  avaliado nos níveis do início e do fim da amostra. Não apresentar 3,84% como
  medida escala-livre.

  As comparações com GRG, Ibovespa e Gertler--Karadi precisam ser colocadas na
  mesma base de choque e no mesmo objeto: por 100 pb, o número corrente do
  câmbio seria aproximadamente 7,68% sob simples reescala linear; a comparação
  de curva americana não é automaticamente uma comparação com curva DI
  soberana. Reportar sempre tamanho do choque, unidade, denominador da conversão
  e horizonte.
- [ ] **Atribuição errada do limiar "≥10" a Montiel Olea-Stock-Watson**
  (`:266`) — *aberto em 2026-08-10, council review (methodologist).*
  "Valores acima de 10 sustentam bandas convencionais" é a regra de bolso
  Staiger-Stock/Stock-Yogo para o **F de primeiro estágio homoscedástico do
  2SLS**, não um resultado de MOSW para a Wald χ²₁ robusta a
  heterocedasticidade usada aqui. Corrigir a atribuição — nomear o desenho
  para o qual o "10" foi derivado, ou trocar pelo valor crítico
  heterocedasticidade-robusto de Montiel Olea-Pflueger (2013), que é o
  análogo correto.
- [ ] **Portar a reconciliação com GRG (2025) para o corpo do §6** — *aberto
  em 2026-08-10, council review (skeptic + harsh-referee, convergência
  independente sobre o mesmo arquivo).* `:551` trata a divergência de sinal
  cambial com `goncalves2025` como "questão em aberto... que deixamos para
  pesquisa futura, possivelmente por meio de um desenho que combine ambas as
  frequências" — mas esse desenho já existe e já rodou: o item "Benchmark
  GRG (2025) sem a célula het" (Tema D) está **fechado** desde 2026-08-01
  com o resultado de que o estimador de Rigobon de GRG, rodado no painel
  diário deste próprio projeto, dá o BRL apreciando 4,53% por 100bp — dentro
  do IC95 publicado por GRG ([−6,57; −3,63]) — enquanto o mesmo teste de
  proporcionalidade que nunca rejeita no mensal rejeita fortemente no diário
  (LR = 135,1, p_boot = 0,005). O texto não capturou a decisão já tomada: a
  divergência é **frequência e propagação, não identificação**. Reportar com
  ressalva obrigatória junto — o mesmo `b_1` diário dá IBOV +2,83% (sinal
  errado, participação espectral 0,0015, ações não identificadas naquele
  sistema); reportar só a célula favorável (BRL) seria *cherry-picking*.
  Ver `historico_decisoes.md` §4 e `notas/2026-08-01_robustez_heterocedasticidade.md` para os números; a réplica arquivada
  (`arquivo/relatorio/correspondence/referee2/replication/referee2_py_b1.csv`)
  precisa de uma rodada na vintage atual antes de virar número citável no
  texto.

*Auditoria blindspot de `paper/paper_anpec.tex` em 2026-08-12 — auditoria de
percepção, não de código: o que a saída mostra e o texto não vê. Relatório
completo em `relatorio/blindspot_2026-08-12.md`, com os quatro quadrantes e a
distinção entre achado novo e item já registrado. Veredito: **HOLD**, por um
motivo estreito e concreto — o defeito de `slice_tail` na curva de juros (Tema E),
que atinge a variável de normalização. Os achados se espalham por quatro temas:
seis itens de redação abaixo, quatro de robustez no Tema B, uma perna já feita da
comparação do IPCA no Tema D e o bloqueador no Tema E. **Nada na auditoria
contradiz o fato central** — as cinco moedas, a janela pré-COVID e a constelação
dos placebos empurram câmbio + risco soberano na direção do paper.*

- [ ] **Reescrever o papel da Selic em §4.1.** A contradição antiga entre
  “controle negativo” e “resultado” foi resolvida pelos dados, não pelo `.tex`:
  na produção `(5,5)`, `juros_selic` sobe **23,8 pb no impacto**, exclui zero a
  90% de h=0 a h=11 e atinge 51,1 pb em h=6. Portanto, retirar da legenda e do
  corpo a leitura de controle nulo; CDI saiu do painel e não pode aparecer. A
  justificativa do DI 6m como normalização continua sendo a janela de surpresa,
  não uma alegação de que a Selic mensal seja inerte.
- [ ] **Fixar a convenção de horizonte do §4 — hoje ela muda de bloco para
  bloco.** Refazer a comparação com a vintage corrente e escolher uma regra
  única: impacto, ou pico acompanhado do horizonte. Para as manchetes, usar h=0
  facilita a comparação direta com a normalização e com a tabela corrente; se
  o texto preferir picos, deve declará-los em todos os blocos, não selecionar o
  horizonte favorável caso a caso. Casar esta edição com a conversão percentual
  e com a pendência do `cumsum` das ações.
- [ ] **Reportar as cinco moedas no §4.2, não duas.** Na produção corrente, as
  cinco depreciam o real no impacto e as cinco bandas de 90% excluem zero:
  USD **3,84%**, EUR **3,00%**, CNY **3,67%**, INR **3,28%** e ARS **4,48%**,
  após divisão pelas respectivas médias amostrais. CNY e INR ajudam a separar
  um resultado do real de uma história restrita ao dólar. Atualizar a figura ou,
  se ela permanecer com USD/EUR, reportar as cinco numa tabela/frase verificável.
- [ ] **Bloco de agregados monetários ausente do §4.** Os números antigos não
  sobreviveram à migração. No impacto corrente, base monetária, meios de
  pagamento, M1 e M3 caem **0,477/0,198/0,114/0,175%**, enquanto M2
  sobe 0,183; como o tcode 4 aplica `(exp(IRF)-1) x 100`, esses valores são
  variações percentuais aproximadas. Somente M3 exclui zero a 90%. Decidir explicitamente se o bloco
  entra no texto e, se entrar, abandonar a descrição antiga de queda homogênea.
- [ ] **Reportar os oito EPU no §5.1, não só o escolhido.** A direção mudou na
  produção corrente: no impacto, `epu_brazil`, `epu_chile` e `epu_germany`
  sobem; somente `epu_chile` exclui zero a 90%, enquanto `epu_us` e os demais
  não. O VIX também não exclui zero a 90% em nenhum dos horizontes h=0,1,2,6,12
  auditados. Refazer a contagem sobre h=0--48 antes de redigir e apresentar a
  família completa para evitar escolha ex post do placebo.
- [ ] **O §4.5 não diz que o *price puzzle* é de amostra cheia** — *bloqueado
  pela comparação cross-instrumento do Tema D.* Na célula corrente,
  `price_ipca` dá h6 **+0,089**, h12 **+0,031** e h24 **−0,169** na amostra
  cheia, contra **−0,092/−0,066/+0,112** pré-COVID. A subamostra, porém, é
  marginalmente explosiva e não autoriza leitura dinâmica por si só. O texto só
  pode chamar a corcova de fenômeno da amostra cheia depois do teste
  cross-instrumento e deve separar IPCA cheio (nenhum sig90) de IPP (sig90 em
  h=0--3).

### Fechados (contexto)

- [x] **Contradição literal entre resumo e §4.2 sobre a reversão cambial —
  SUPERADA pela redação ativa anterior à migração.** O resumo corrente no
  `.tex` já não chama a reversão cambial de sincronizada. A interpretação de
  médio prazo inteira ainda precisa ser refeita para `(5,5)` no item principal.
- [x] **Diagnóstico de relevância simplificado e alinhado a MOSW — FEITO em
  2026-08-13.** O paper e os relatórios ativos agora apresentam somente ξ_mp e
  F_rob,mp (HC1), calculados na mesma direção de normalização. Na produção
  daquela rodada, os valores eram 7,65/7,95 full e 11,53/6,26 pré-COVID. A
  migração para 111 séries `(5,5)` os substituiu por 6,27/10,12 e 10,99/9,75;
  a antiga questão sobre a estatística conjunta saiu do texto. Fonte:
  `output/instrument/olea_alignment_audit.md`.
- [x] **Grade completa de $(r,q)$ incorporada ao paper — FEITO em
  2026-08-12.** A `tab:rq_sweep` agora contém as 14 dimensões e mostra o platô
  formado por (7,5), (7,6), (7,7), (8,5) e (8,6) nas duas amostras. Embora
  (7,7) tenha o maior ξ_mp na amostra completa, a decisão daquela rodada manteve
  (7,6), dimensão congelada antes da extensão da grade. Esse default foi
  superado em 2026-08-13 pela seleção conjunta de painel e dimensão, que adotou
  111 séries `(5,5)`. Fonte: `output/instrument/mosw_strength_grid.csv`.
- [x] **Coincidência FOMC redigida no paper — FEITO em 2026-08-12.** A
  subseção `sec:fomc` reporta exposição, timing, testes 0 a 3 e a decomposição
  entre valores e máscara, com veredito de confound não detectado e sem usar o
  teste 4 removido. Fonte: `notas/2026-08-10_coincidencia_fomc.md`.
- [x] **Quatro correções pontuais em §3 (§3.4-§3.6), herdadas do antigo
  `arquivo/_instrucoes/prompt.md` — auditadas e já aplicadas, 2026-07-26.** §3.4
  explicita a variante BS-predeterminado + JK; §3.5 removeu a frase obsoleta
  sobre (6,5) e trouxe a tabela `tab:rq_sweep` para (7,6); a frase sobre a
  correção de Kilian está correta (verificado: o ponto é sempre OLS puro,
  Kilian só no DGP do bootstrap); §3.6 comentou a validação de Olea et al. (só
  no repo, não no corpo).
- [x] **Abstract, Introdução e Conclusão — rewrite completo — FEITO,
  verificado em 2026-08-01** em `paper/paper_anpec.tex`. Após a atualização
  numérica de 2026-08-12, o resumo reporta depreciação de 5,55% (BRL/USD),
  EMBI+/CDS em alta e a curva até cinco anos; a conclusão trata a divergência com GRG
  (2025) como questão em aberto; `§3.2` corrigido de "≈110 séries" para "106
  séries"; discordância cambial com GRG está no resumo, não em rodapé.
  **Achado à parte, não corrigido:** `§3.2`/Anexo A ainda descrevem a curva de
  juros como ajustada por Svensson em código do projeto — `script/
  yield_curve.R` foi deletado em 2026-07-26 e `yields_dia.csv` é hoje insumo
  externo fixo do orientador; abrir item novo se for para corrigir.
- [x] **Revisão de literatura (§2) — reescrita inteira em 2026-07-28.** ~1.500
  palavras, 11 parágrafos, trilha não-fundamentalidade → FAVAR/DFM →
  Alessi-Kerssenfischer → Mertens-Ravn → Stock-Watson → Gertler-Karadi →
  Jarociński-Karadi+Bauer-Swanson → Montiel Olea-Stock-Watson → GRG (2025) →
  posicionamento. Duas chaves novas: `goncalves2025`, `bagliano1998` (atenção:
  a pasta `artigos/` grafa "baglio", o autor é Bagliano). Fora por decisão do
  autor: Bonomo-Martins e Blanchard (2004) seguem pendentes de escrita; o eixo
  sem instrumento (GMR/LMS/ACF) ficou fora de propósito. Compila limpo. A
  contradição que isso criou com o resumo está no item "Abstract, Introdução e
  Conclusão" acima.
- [x] **§5 Robustez escrita no tex — FEITO em 2026-07-29, revisada em
  2026-07-30 pelo item seguinte.** *Este item é sobre o `tex/main.tex` de
  então, hoje `arquivo/tex/main.tex`; a §5 do paper canônico
  `paper/paper_anpec.tex` só começou a existir em 2026-08-09 e está no
  item aberto do Tema A.* Primeira versão: sem tabelas (por instrução
  do autor, tudo em prosa com IC90), 9 figuras via `fig_section5.R`. Três
  erros descobertos ao promover blocos comentados para prosa, corrigidos e
  verificados: (i) a "cronologia de reversão câmbio/EMBI/CDS" **não inclui o
  câmbio** (`cambio_usd` não reverte); (ii) `trab_pop_ocupada` é sig68
  **positiva** no impacto, contra a previsão; (iii) `credito_construcao`
  (−0,32) e `credito_industria_total` (+0,19) têm sinais opostos no impacto.
  Erro de unidade corrigido: `commodity_metal` é +3,43% no impacto, não
  "+10,4%" (confundia pontos de índice com percentual). Detalhe:
  `irf_section.md` §5.7.
- [x] **Regra de dois níveis em §4/§5 — FEITO em 2026-07-30.** A regra de
  90%-só foi relaxada: 68% excluindo zero entra como **direção e magnitude**
  (nunca "significativo", reservado a 90%). Isso revelou 706 pares a 68%
  (contra 92 a 90%, todos h≤12) num U pelo horizonte — vale setorial em
  h11-12, contração de crédito h24-32, reversão da curva+Selic h25-44 — com o
  fato inconveniente declarado no corpo: o **IBC-Br não acompanha** o vale
  setorial (só h0 é sig68). PIB saiu do §4 em favor do IBC-Br (evitou erro de
  unidade de ~7×). `sec:alcance` foi eliminada; a razão
  |ponto|/meia-banda-68% (≈|t|) migrou para Limitações: 0,87 no impacto,
  mínimo 0,66 em h12, **pico 1,07 em h24**. Oito figuras, todas a h=36.
  Compila limpo, 25 chaves inalteradas.
- [x] **Confound soberano no filtro JK — TESTADO E NÃO CONFIRMADO em
  2026-07-31; refeito em CDS 5a diário em 2026-08-09 com o mesmo veredito**
  (números correntes no output gerado e na nota de 2026-08-12; a nota de
  2026-08-09 preserva a rodada anterior).
  `script/jk_sovereign_confound.R` →
  `output/instrument/jk_sovereign_confound.{csv,md}`. Nota:
  `notas/2026-07-31_confound_soberano_jk.md`. **O dado
  aponta ao contrário da acusação:** ΔEMBI carrega a surpresa com coef 0,326
  em dias comuns contra **0,099** nos 62 dias retidos
  pelo filtro; as interações `x:1(jk_bs)` são **negativas** nas quatro proxies
  de risco (BRL −0,036, p_boot 0,068). Na produção corrente, ortogonalizar ao
  EMBI e ao câmbio leva ξ_mp de 6,27 a 6,62; acrescentar o CDS o leva a 7,58.
  **⚠ Ressalvas que não somem:** o
  coeficiente nos 62 dias é positivo e marginal (p=0,097) — a afirmação é
  "menos risco que um dia comum", não "zero risco". *(Atualizado em 2026-08-09: o CDS 5a diário chegou
  — `data/raw/CDS 5y.xlsx` — e o teste roda nas duas proxies com o mesmo veredito;
  ver `2026-08-09_confound_soberano_cds.md` e as duas ressalvas endurecidas no
  item de redação acima.)* Consequência: a subseção foi escrita em 2026-08-09
  como §5.2 de `paper/paper_anpec.tex`, com as ressalvas no corpo.
- [x] ~~**Identificação: filtro JK pode estar selecionando risco soberano —
  item mais grave do council review.**~~ *(fechado acima em 2026-07-31; texto
  original preservado só por procedência.)* Os três críticos chegaram lá por
  ângulos diferentes — harsh-referee pela constelação de respostas (repasse
  1,85× na ponta longa, depreciação, abertura de CDS/EMBI), macro-theorist
  pelo ponto lógico (o filtro JK retém exatamente o padrão fiscal doméstico:
  juros↑, ações↓, câmbio↑), metodologista por comparação com GRG (2025). Ver o
  item acima para o teste e o veredito.
- [x] **Redação do confound soberano em `paper/` — FEITO em 2026-08-09,
  reescrito em 2026-08-10.** Escrito como §5.2, `sec:confound`, logo depois de
  `sec:exogeneidade`, com as três ressalvas do argumento (controle não-Copom,
  interação negativa, "não é zero risco, é menos risco") no corpo. **Fecha no
  mesmo dia a objeção do council de que "por completo" (`:538`) overstate o
  Teste C:** a máscara JK passou a ser re-derivada nos resíduos ortogonalizados
  de ambas as pernas (`z_jk_bs_norisk_mask`) — 50 dos 62 dias de produção
  sobrevivem, 13 entram, ξ_mp cai a 4,26 (contra 7,58 só nos valores), porque
  o bloco de risco explica 40,4% de `e_ibov_bs` contra 15,4% de `e_di_bs`;
  manchetes preservam sinal, mas `denom_vs_prod` 0,719 —
  abaixo de ξ_mp 10, sustenta direção, não intervalo. Sem figura própria
  (overlay de 9 painéis não cortado). Fonte:
  `notas/2026-08-09_confound_soberano_cds.md`.
- [x] **Introdução "DFM mais forte e mais rápido" — item moot, verificado em
  2026-08-02.** A frase problemática só existia em `arquivo/tex/main.tex:183`
  (draft arquivado); a introdução ativa de `paper/paper_anpec.tex` nunca
  fez essa afirmação — abre na falha da UIP e no canal de prêmio de risco, sem
  citar o benchmark VAR. Nada a reescrever. Se o benchmark entrar em §5 no
  futuro, usar a leitura correta: *mais forte* amplo (16/18, razão mediana
  2,32 no impacto), *mais rápido* só nas ações (7/8) — nunca "o DFM ganha da
  literatura" (identificação fixa compara DFM-contra-VAR-pequeno, não contra a
  literatura Cholesky). Redação proposta:
  `notas/2026-07-31_benchmark_var_vs_dfm.md`.
- [x] **Benchmark VAR pequeno — RODADO E REPORTADO em 2026-07-31.**
  `script/model_var.R` reescrito como driver sobre `R/modeling/var_proxy.R`
  (o antigo nunca rodava — 3 erros fatais na cola, as peças de baixo nível
  eram fiéis). Lendo `MAIN_VARloop.m`: o core de AK é
  `{atividade, preços, taxa de médio prazo}` com a **taxa como alvo de
  normalização** — AK nunca normaliza em overnight, o que fecha a favor de
  `yield_6m` sobre `juros_selic`. **Armadilha de régua corrigida**: o extremo
  global do DFM tem sinal oposto ao impacto em 8 das 18 respostas (as 8
  ações) — trocada "18 de 18" por razão de impacto + pico de mesmo sinal.
  **Veredito:** *mais forte* se sustenta, 16 de 18 (razão mediana 2,32 no
  impacto, 1,61 no pico); *mais rápido* só nas ações (7 de 8, contra 9 de 18
  no total). **O preço:** banda de 68% do DFM nunca é mais estreita (razão
  4,35), 37 sig90 no DFM contra 266 no VAR. **Achado mais forte pró-DFM:** o
  próprio diagnóstico de AK mostra as respostas *core* do VAR pequeno variando
  entre specs mais que sua própria magnitude, e o VAR com `ibc_br` é
  **explosivo** (max|λ|=1,008). Saídas em `output/var/var_benchmark.{md,...}`
  (3 CSV + 4 PDF). Nota:
  `notas/2026-07-31_benchmark_var_vs_dfm.md`. A
  consequência textual (reescrever a introdução) já era moot em
  `paper/paper_anpec.tex` — ver item fechado em "Texto do paper" acima.
- [x] **Estacionariedade dos fatores, cointegração e espectro da companion —
  FEITO em 2026-07-31.** `script/factor_stationarity.R` →
  `output/factors/factor_stationarity.md`. Fatores: **4 de 7 I(1)**, 2 I(0), 1
  ambíguo, **nenhum I(2)** (PP concorda com ADF em 14 de 14). Cointegração
  existe mas o **posto não é identificado** (2 a 0 dependendo da correção) —
  **VECM não será estimado**, o VAR em nível é consistente sob qualquer posto
  (Sims-Stock-Watson 1990). Espectro: par dominante **complexo**, |λ| =
  0,976794, período 117,9 meses — a quase-raiz-unitária **não vem de `p`**
  (módulo maior em p=1: 0,982). **⚠ Achado que condena, não absolve:** apagar
  o par dominante (sem reestimar nada) **inverte o sinal do vale de médio
  prazo em 12 de 14 séries**; isso também muda o denominador da normalização
  (impacto pré-normalização de `yield_6m` cai a 0,313×) — sinal e horizonte
  são imunes, magnitude não. **`cambio_usd` é a única exceção** cuja reversão
  sobrevive intacta (razão 1,004). Nota:
  `notas/2026-07-31_estacionariedade_fatores.md`.
  Consequência: redigir a ressalva no §4/Limitações (item acima).
- [x] **Camada de citação estrutural — três correções — FEITO em 2026-08-01**
  (macro-theorist). Aplicado em `paper/paper_anpec.tex`: acelerador
  financeiro já citava `BERNANKE19991341` corretamente; a frase de
  Cooley-Quadrini (linha 419) foi reescrita para não atribuir a heterogeneidade
  setorial do crédito à dimensão patrimônio líquido/porte dos autores,
  nomeando-a margem distinta (crédito direcionado vs. livre); Castelnuovo-Nisticò
  reposicionado (linha 258) como argumento de identificação para incluir o
  Ibovespa entre os preditores predeterminados Bauer-Swanson. Compila limpo.
- [x] **`juros_selic` e `juros_cdi` não são evidências independentes — FEITO
  em 2026-08-01.** Divergem só no terceiro dígito significativo; citá-las
  revertendo juntas como confirmação cruzada seria erro. Aplicado em
  `paper/paper_anpec.tex:335`.

---

## B. Robustez estatística a fazer

- [ ] **Bandas simultâneas ao longo do caminho** (Montiel Olea-Plagborg-Møller
  2021) — *aberto em 2026-07-31; motivação atualizada em 2026-08-13.* A
  decomposição corrente **não** sustenta mais que um único modo domine a
  reversão: apagar o par dominante preserva 13 de 14 vales. A pendência, porém,
  permanece porque bandas pontuais horizonte a horizonte não autorizam uma
  afirmação sobre a trajetória inteira, justamente o que o tier de 68% do §4
  fazia ao descrever vales setoriais, contração do crédito e reversão da curva.
  Distinto do item de AR acima: aquele trata de IV fraco no impacto, este de
  multiplicidade ao longo do horizonte. **Exige referência nova**, o que colide
  com a regra das 25 chaves — decisão do autor.
- [ ] **Validade do wild bootstrap no proxy-SVAR (Jentsch-Lunsford)** — *aberto em
  2026-07-27; não estava registrado em lugar nenhum do repo.* O bootstrap
  multiplica o instrumento pelo **mesmo** draw Rademacher dos resíduos
  (`impulse_responde.R:608-610`, `inst_boot <- inst_sel * rr_sel`) — é o esquema
  Mertens-Ravn, e é exatamente o que Jentsch-Lunsford (2019, *AER* comment;
  2022, *JBES*) mostram ser **inválido para proxy-SVAR independentemente da
  força do instrumento**: o multiplicador destrói a dependência entre `z_t` e
  `u_t` de que a variância assintótica depende. É problema de **validade**, não
  de IV fraco — atinge todas as bandas do §5, inclusive as pré-COVID onde
  ξ_mp = 10,99. O próprio MOSW (nota 21) diz que o bootstrap deles "could be
  replaced by any other bootstrap procedure, such as the block bootstrap for
  proxy SVARs proposed by Jentsch and Lunsford".
  - **Contrapesos antes de trocar nada:** (i) Alessi-Kerssenfischer usam wild
    bootstrap (`DFMest_BLL_Boot.m`) e este projeto é replicação fiel — desviar é
    escolha metodológica deliberada, não conserto de bug; (ii) Mertens-Ravn
    responderam e o debate não fechou; (iii) a camada DFM muda o objeto — aqui se
    reamostra o resíduo do VAR **de fatores** e se re-estima o DFM inteiro por
    draw, desenho que JL não analisam.
  - **Mínimo aceitável:** um parágrafo no §3 declarando a escolha e citando o
    debate. Um parecerista atento a método enxerga `inst_sel * rr_sel` de
    imediato. Implementar MBB é caro e fica como decisão separada.
- [ ] **LP-IV como robustez à especificação dinâmica** — *desejável, não
  bloqueante; o autor quer tentar se houver tempo (2026-07-26).* Local
  Projections com o mesmo instrumento: `IdSS::make.LPIV.irf` (uma regressão IV
  por horizonte, controles opcionais de defasagens de `Y` e `Z`, erro-padrão HAC
  via `tsls` com Newey-West em `h + 1`). O pacote já entra no projeto pela rota
  não-gaussiana, então o custo marginal é baixo.
  - **Por que vale:** é um **estimador diferente da mesma identificação**. Não
    inverte o polinômio autorregressivo nem propaga por potências da companion,
    logo **nada nele depende de `p = 6`** nem da forma funcional do VAR. E roda
    nativamente em observáveis, dispensando a adaptação ao espaço de fatores que
    todos os outros métodos do roadmap exigem. Rodar em `yield_6m`,
    `asset_ibov`, `cambio_usd` e nas demais manchetes do §5 contra
    `z_jk_bs_purif`, comparando com `output/irf/irf_coherence_h.csv`.
  - **Cuidado na leitura:** LP-IV em observáveis crus **descarta o DFM**, então
    uma divergência pode ser a especificação dinâmica *ou* a perda da estrutura
    de fatores (variável omitida / notícia). Para isolar a primeira, incluir os
    fatores estimados como controles. E a precisão de LP degrada nos horizontes
    longos — com T = 147 a comparação em h próximo de 48 é frágil.
  - **Detalhe de implementação:** `make.LPIV.irf` normaliza para efeito unitário
    na **primeira coluna de `Y`** — ordenar `yield_6m` primeiro.
  - **Ressalva:** continua dependendo de `z_jk_bs_purif` ser relevante e exógeno.
    **Não** responde ao ξ_mp no limiar nem ao placebo `commodity_metal` — só a
    rota não-gaussiana faz isso, porque só ela identifica sem `z`.
- [ ] **Comunalidade baixa em `price_core_ipca_ex0` e `asset_ifix`** — *aberto em
  2026-07-28 (auditoria do DFM-IV); **item rebaixado no mesmo dia**, ver o
  registro de erro abaixo.* Pela comunalidade no espaço das diferenças (R²_dif,
  a régua correta, porque é onde `Λ` é estimado e onde o modelo é linear em `Λ`):
  `price_core_ipca_ex0` = **0,315** e `asset_ifix` = **0,453**, contra mediana de
  painel 0,529. São exatamente o único veredito `incoerente` e o outlier de −33%
  do bloco de ativos. Não é defeito do modelo — é razão sinal-ruído pior.
  - **Teste discriminante:** local projection direto sobre o choque identificado,
    sem passar por `Λ`, para essas duas séries, comparado à IRF do DFM em h=0-12.
    Se convergirem, a leitura atual se sustenta; se divergirem, elas não devem
    sustentar afirmação no §5.
  - **⚠ Registro de erro (não repetir).** A primeira versão deste item afirmava
    que "o `Λ` do BLL não descreve o bloco I(0)" e que o método seria inadequado
    a um painel misto. **Está errado.** (i) `ΔY = ΛΔF + Δξ` e `Y = ΛF + ξ`
    compartilham o **mesmo** `Λ`, então estimá-lo por PCA nas diferenças e
    aplicá-lo ao nível é o estimador publicado, não um desalinhamento —
    Alessi-Kerssenfischer §2.2. (ii) A premissa do arcabouço é *"the factors are
    I(1) and the idiosyncratic components are either I(0) or I(1)"* (§2.1), com
    *"all series are kept either in levels or log-levels"* (§2.3): **painel misto
    é admitido por construção.** (iii) O R²_chi negativo em 31 séries **não é
    sintoma**: `Chi = Zλλ'` é projeção ortogonal na *seção cruzada* (limita
    `Σᵢ` a cada `t`, não série a série no tempo), e a padronização BLL torna
    `var(Z)` heterogêneo por desenho — de 0,48 a 308,8, com
    `cor(log var(Z), R²_chi)` = **+0,727**. Para uma série I(0),
    `var(Z) ≈ 1/(2(1−ρ)) ≈ 0,5`, que é onde os `asset_*` estão (0,551). O ajuste
    agregado do painel é **0,708**. (iv) Ordenar as anomalias pelo gap
    R²_ols − R²_chi comparava regressão de série temporal com projeção de seção
    cruzada; pela régua certa `asset_ibov` tem a **maior** comunalidade do painel
    (0,909) e `cds_5y` (0,676), `embi_perc` (0,561) e `cambio_usd` (0,859) estão
    bem — todos foram acusados por engano.
- [ ] **Decomposição do wedge de UIP** — *aberto em 2026-08-10, prioridade
  alta; todas as contas da vintage `(7,6)` estão superadas.* O paper afirma
  que o prêmio soberano “domina” o diferencial de juros sem computar o wedge.
  Refazer do zero com as IRFs e os 800 draws correntes; até lá, a palavra
  “domina” deve sair do resumo, corpo e conclusão. **Entrega:** tabela de
  decomposição com colunas T ∈ {6, 12, 24, 48}, linhas {Δs_T, −ΣΔi/12,
  +ΣΔrp/12 (CDS e EMBI), resíduo}, bandas tiradas dos 800 draws já salvos em
  `irf_coherence_cell.rds` — só pós-processamento, nada reestimado.
  - **Conta de impacto corrente em espaço de curva:** o excesso do vértice de
    5 anos sobre a normalização é **27,6 pb** (77,6 − 50,0) e o CDS de 5 anos
    abre **32,5 pb**. É comparação de magnitude na mesma maturidade, não
    identidade contábil nem prova de causalidade.
    ⚠ CDS é denominado em dólar e a curva DI em real: é comparação de magnitude,
    **não** identidade contábil.
    ⚠ `epu_brazil` agora sobe no ponto de impacto, mas não exclui zero a 90%; não
    usá-lo como confirmação do mecanismo fiscal.
- [ ] **Decompor o repasse da curva entre expectativa e prêmio pela diferença
  diário-vs-mensal** — *aberto em 2026-08-12, auditoria blindspot; **prioridade
  alta**, é o item com maior razão valor/custo do relatório.* Estudo de evento
  diário nos **mesmos 62 dias retidos**, com a **mesma surpresa ortogonalizada**
  (`e_di_bs`) e sobre a **mesma curva que alimenta o painel**
  (`data/raw/yields/yields_dia.csv`, n=60 após casar datas), normalizado a 1 no
  vértice de 6 meses:

  | vértice | DFM mensal h=0 | evento diário | razão |
  |---|---|---|---|
  | 3m  | 0,774 | 0,654 (t 14,4) | 1,2 |
  | 1a  | 1,267 | 1,206 (t 17,0) | 1,1 |
  | 2a  | 1,486 | 1,091 (t 9,6)  | 1,4 |
  | 5a  | 1,552 | 0,631 (t 4,6)  | **2,5** |
  | 10a | 1,406 | 0,375 (t 2,6)  | **3,7** |

  A coluna mensal foi atualizada para `(5,5)`; a coluna diária ainda é cálculo
  de auditoria não versionado. Não chamar nenhum dos arquivos de curva de
  “ajuste Svensson do próprio projeto”: os yields são insumos externos fixos.
  **A ponta curta bate entre as duas frequências;
  a ponta longa não.** No dia do anúncio o repasse é corcova com pico em 1 ano e
  **decai** — o padrão dos desenvolvidos com que o paper se compara. A monotonia
  até 5 anos é fenômeno do mensal, e o excedente se acumula **ao longo do mês**,
  o mesmo mês em que CDS e EMBI+ abrem com banda de 90%. Isso substitui a
  comparação de `:334` com Gertler-Karadi — objetos diferentes (repasse a crédito
  corporativo americano vs. amplificação de curva soberana) e bases diferentes
  (50 pb vs. 100 pb), as duas já abertas no Tema A — por uma medição interna:
  mesmo instrumento, mesma curva, sem dado novo e sem chave nova.
  - ⚠ **A perna diária é de auditoria, não de script versionado.** Antes de
    virar texto precisa de um `script/` próprio, validação de datas e
    proveniência explícita do insumo externo.
- [ ] **A amplificação 5a/6m é do choque ou de Λ?** — *aberto em 2026-08-12,
  auditoria blindspot; é o teste discriminante do item acima e **não** foi
  rodado.* Recalcular a IRF de impacto para direções alternativas no espaço das
  q inovações, todas renormalizadas a +50 pb em `yield_6m`, e ver se a razão
  5a/6m corrente, **1,55**, sobrevive. Se qualquer direção que levante o
  vértice de 6 meses levantar o de 5 anos em aproximadamente a mesma proporção,
  a amplificação é propriedade da estrutura de
  fatores e não do choque identificado, e a §4.1 não pode lê-la como evidência de
  transmissão. **Sinal preliminar disponível sem reestimar nada:** na célula
  corrente `(5,5)`, amostra cheia, os 8 instrumentos de
  `spec_sweep_irf_long.csv` dão 1,52 a 2,48 — inclusive a surpresa **bruta**,
  sem ortogonalização e sem máscara, que dá **1,73**, acima da produção (1,55).
  Corta nos dois sentidos: é robustez do
  resultado e é ausência de poder discriminante da receita do instrumento. Os 8
  são variantes da mesma surpresa, então isso **não** é o teste de invariância —
  é o motivo de rodá-lo.
  - ⚠ Toca o caminho de identificação: ler `.claude/rules/identification.md`
    antes, e rodar como diagnóstico, sem alterar `model_alessi.R`.
- [ ] **Tratar a janela pré-COVID como diagnóstico de força e estabilidade,
  não como evidência dinâmica.** Ela entrega `xi_mp=10,99268`, mas
  `F_rob,mp=9,74746` e raiz máxima **1,000202**. Os pontos de IRF disponíveis
  podem ser usados para mostrar sensibilidade, sempre em bloco e sem escolher
  respostas favoráveis, mas não para narrar propagação ou comparar picos/vales.
  Se o paper mantiver a coluna pré-COVID na `tab:rq_sweep`, deve imprimir a
  instabilidade ao lado e explicar por que as IRFs não entram.
- [ ] **Corrigir a descrição do placebo `sp500_vix`** — *aberto em
  2026-08-10, council review (skeptic), achado factual rápido, mas que
  esvazia parte do argumento de §5.1.* O texto (`:501`, `:509`) descreve
  essa série como "o retorno do S&P 500 combinado à variação do VIX". Não
  é: `data/raw/investing/sp500_vix.csv` é só o índice **VIX** (média 18,58, min
  9,51, max 53,54) — o painel **não contém nenhuma série de nível do S&P
  500**. Isso enfraquece o argumento de `:519` de que "uma surpresa fiscal
  brasileira também deixaria o S&P 500 parado" (não há S&P 500 para checar)
  e é exatamente onde o item de coincidência FOMC acima morde: um choque do
  Fed move o VIX intraday, mas o VIX é uma série que reverte à média — um
  pico de um dia se dissipa antes do fim do mês, enquanto um movimento do
  BRL em um dia não. Corrigir a descrição do placebo e, se possível,
  adicionar uma série de nível do S&P 500 ao teste ou remover o argumento
  de `:519` que depende dela.
- [ ] **Bandas Anderson-Rubin — ADIADAS SEM PRAZO e sem prioridade ativa.** A
  implementação de 2026-08-10 foi retirada em 2026-08-12. Embora reproduzisse
  o código MOSW no VAR observável, ela condicionava em fatores e loadings
  estimados sem teoria de cobertura para esses objetos gerados e tinha defeito
  demonstrado na classificação de casos degenerados. Reabrir somente com uma
  derivação que incorpore a estimação fatorial ou com um procedimento que a
  reproduza. A nota `notas/2026-08-10_bandas_anderson_rubin.md` permanece
  preservada e marcada como `SUPERSEDED`; o parecer externo permanece verbatim.

### Fechados (contexto)

- [x] **Pico uniforme em h=1 — HIPÓTESE SUPERADA pela produção `(5,5)`.** A
  curva agora atinge o pico em h=3 e a Selic em h=5; câmbio e ações podem ter
  pico em h=1, mas não há mais regularidade uniforme do bloco financeiro. A
  convenção editorial de horizonte continua aberta no Tema A.
- [x] **Decisão conjunta de painel e dimensões — ETAPA INTERMEDIÁRIA SUPERADA em
  2026-08-13.** Nos 64
  painéis sem `juros_cdi`/`asset_mlcx`, a grade full de 2.304 células escolhe
  uma dimensão por painel; 64 células pré-COVID apenas qualificam confiança.
  Nenhum bloco atingiu 24 vitórias de exclusão e a etapa recomendou a união de 123
  séries em `(4,3)` (`xi_mp=5,05`, raiz 0,9626; pré-COVID 10,78/0,9927). Os
  quatro finalistas completaram 800 réplicas sem falhas. Essa recomendação foi
  substituída pela decisão final de 111 séries `(5,5)`, já migrada. Nota:
  `notas/2026-08-13_decisao_conjunta_painel_dimensoes.md`; auditoria:
  `diagnostics/rq_block_dimension_audit/`.

- [x] **Composição experimental do painel e seis blocos candidatos — FEITO em
  2026-08-13; veredito isolado SUPERADO pela decisão conjunta acima.** As nove
  variantes pré-especificadas foram estimadas nas duas
  amostras com IRFs h=0--48 e 800 réplicas, sem alterar produção. A união dos
  blocos move `xi_mp` de 7,65 para 4,67 no full e para 16,14 no pré-COVID, mas
  as bandas daquela rodada não sustentavam uma promoção conjunta. A conclusão
  de manter 106 séries caiu quando composição e dimensão passaram a ser
  escolhidas conjuntamente. ⚠ Fiscal é vintage corrente, não
  informação disponível em tempo real. Nota:
  `notas/2026-08-13_teste_experimental_composicao_painel.md`; outputs:
  `output/panel_experimental/`.

- [x] **Teste de coincidência FOMC — FEITO em 2026-08-10, no mesmo dia em que
  foi aberto.** `R/data_download/fomc_dates.R` (raspa as páginas de calendário
  do Fed, **enumerando** os anos de arquivo a partir de
  `fomc_historical_year.htm` em vez de hard-codá-los; 110 datas em 2013-2025, 4
  `stopifnot`), `R/instrument/event_tests.R` (`wild_coef_test` extraído verbatim
  de `jk_sovereign_confound.R` — reproduz `p_boot` com diferença **exatamente
  0** — mais o `wild_wald_test` conjunto), `script/fomc_coincidence.R` →
  `output/instrument/fomc_coincidence.{csv,md}` + `_days.csv` + overlay.
  **A causa raiz era um `else`:** o fallback silencioso para vetor vazio
  tornava "a coleta não foi feita" indistinguível de "a coleta deu vazio".
  `load_fomc_dates()` agora **aborta**, e `run_all.R` declara o arquivo
  requisito duro do estágio `instrument`. **Veredito: confound FOMC não
  detectado**, pela regra fixada antes dos números. A exposição é **maior** do
  que o council estimou — 24 dos 62 dias retidos (38,7%), **35,5% de Σ|z|**,
  **8** dos top-20 (não 7), 7 de 8 reuniões em 2025 — o que torna o nulo mais
  informativo. Bloco americano nos 62 retidos: F_rob 0,94, **p_boot 0,458**;
  interação com `1(fomc_coincide)`: 0,466; com `1(jk_bs)`: 0,511. **Os dois
  números que invertem o sinal da suspeita:** nos 35 dias em que Copom e FOMC
  caem no mesmo dia o R² é **0,005** (o menor da tabela), e o maior (**0,108**)
  está nos 33 dias que o filtro **rejeita**. Quantifica também a distinção do
  item de máscara: alterar só os valores eleva ξ_mp em **0,04**, enquanto
  re-derivar a máscara o reduz em **2,14** contra a variante de mesmos valores.
  ⚠ O argumento de horário (comunicado às 14:00 ET, antes dos dois fechamentos)
  vale para a perna de **taxa** e **não** para a de ações. Nada em produção
  alterado — as 8 colunas `z_*` saíram bit-idênticas. Leitura completa em
  `notas/2026-08-10_coincidencia_fomc.md`. A redação foi incorporada ao paper
  como `sec:fomc` em 2026-08-12.
  **⚠ O teste 4 (a divisão) saiu do script no mesmo dia**, junto com a terceira
  perna da regra de veredito, que ele alimentava. A perna **havia passado** e a
  cláusula de poder não foi acionada, de modo que retirá-la torna a regra
  estritamente mais permissiva e o veredito não pode ter mudado por causa do
  corte, o que foi conferido rodando o script antes e depois com `max |dif| = 0`
  em toda linha sobrevivente. **Nada do que esse teste produziu é reproduzível
  ou citável**, e a subseção de §5 do FOMC foi escrita apenas sobre os testes 0
  a 3. Ver `historico_decisoes.md` §2.4 e o cabeçalho de
  `script/fomc_coincidence.R`.
- [x] **Robustez do próprio ξ_mp — REFEITA em 2026-08-13.**
  `script/xi_mp_robustness.R` → `output/instrument/xi_mp_robustness.{csv,md}`.
  **Leave-one-month-out** (DFM fixo): full ξ_mp 6,27 → min 4,89/máx 6,96;
  **0 de 147** descartes abaixo de 3,84 (conjunto AR sempre limitado), mas
  **147 de 147** abaixo de 10 (bandas convencionais são frágeis). Na pré-COVID,
  14 de 78 descartes levam a estatística abaixo de 10. **HAC**: ξ_mp chega a
  **8,05** em NW(6) no full, ainda abaixo de 10. Validado em
  `script/validate_hac_kernel.R` contra
  `NW_hac_STATA.m` (exato) e `TaxSVARIV.m` (2,6e-10 em lag 8). Não feito: F
  efetivo de Montiel
  Olea-Pflueger e winsorização de `z` (encolheria a variação identificadora).
  A tentativa Anderson-Rubin posterior foi retirada em 2026-08-12; o item está
  adiado nas condições descritas acima.
- [x] **Robustez da construção do instrumento: vértice e agregação — FEITO em
  2026-07-27.** `script/instrument_construction_sweep.R` → 260 células em
  `output/instrument/instrument_construction_sweep.{csv,md}`; cadeia extraída
  para `R/instrument/build_variants.R` (bit-idêntica, smoke test 5/5).
  **Vértice:** 126 du não é o argmax em nenhuma janela, mas a maior margem de
  um desafiante elegível (1,16) fica abaixo do limiar pré-registrado (2,00) —
  a regra não dispara, produção fica em 126 du. **Os 13 vértices dão
  essencialmente a mesma IRF** (o análogo da Figura A4 de AK que faltava).
  **Agregação:** o esquema GK **colapsa ξ_mp para 0,30** no vértice de
  produção — previsto antes de rodar, porque a nota 11 de GK condiciona a
  ponderação a um indicador de média mensal e `yield_6m` aqui é de fim de mês.
- [x] **Placebo `commodity_metal` violado — RESOLVIDO em 2026-07-28.** Não era
  falha de exogeneidade: o IC-Br do BCB é **denominado em R$** e herda
  mecanicamente a resposta cambial. Teste decisivo
  (`diagnostics/01_exogeneidade.R` §1.6): os três índices em R$ violam (metal
  +12,07, sig90 em 4/5 horizontes) e os três em US$ passam limpo (metal +0,42,
  **0 de 25** horizontes sig). Isso explica de uma vez por que a identificação
  não-gaussiana (que não usa `z`) violava o mesmo placebo — nunca foi do
  instrumento. Retierado de `placebo` para `ambiguous`; o tier `placebo` fica
  só com as três genuinamente externas (`sp500_vix`, `msci`, `epu_us`), todas
  aprovadas.

---

## C. Identificação não-gaussiana — decisões em aberto

*(2026-07-27, reestimado na produção `(5,5)` em 2026-08-13.)* O ramo GMR está
implementado, validado e foi reestimado com 800 réplicas e zero falhas.
Registro histórico em
`notas/2026-08-01_robustez_identificacao.md` (a nota de
07-27, `notas/2026-07-27_identificacao_nao_gaussiana_gmr.md`,
descreve a corrida antiga e carrega banner).

- [ ] **Decidir o enquadramento do GMR no paper.** O que sobrevive, e é o que a
  recomendação de 07-27 já dizia: usar o GMR como **teste**, não como estimativa
  concorrente. Duas afirmações são defensáveis porque nenhuma é de
  discriminação: (i) **não contradiz** — o ponto do proxy cai dentro do CI90 do
  GMR em **100% das 5.439 células**; (ii) **rejeita o esquema recursivo**
  (ξ = 73,81), que é a restrição que a literatura de menor dimensão impõe sem
  testar e conversa com o argumento anti-VAR-pequeno do paper. **Não** é
  defensável escrever "outra identificação independente dá a mesma direção" sem
  a ressalva do nulo. O estimador segue sem poder próprio: **6 células sig90 em
  5.439**. A rejeição assintótica da restrição do proxy (ξ = 33,37; 4 gl)
  continua
  **provavelmente espúria** — Prop. 4 cobre 0,79 contra 0,95 nominal em
  T = 150, n = 6, enquanto o bootstrap move substancialmente a direção e produz
  bandas muito largas. Fonte corrente: `output/nongaussian/results.md`.
- [ ] **Construir um teste com poder.** O gargalo agora é a régua, não o
  estimador. A coluna rotulada concorda com o proxy em 0,963 das 353 células em
  que o proxy é sig90, mas direções aleatórias tornam essa contagem pouco
  discriminante (`p=0,149`). A razão de magnitude é mais promissora
  (`p=0,087`), ainda sem rejeitar a 5%. Um teste sobre o perfil de magnitude,
  e não sobre contagem de sinais, pode ter poder onde este não tem.
- [ ] **LMS (2017) como terceira leitura** — `svars::id.ngml`, ML paramétrico
  sobre a mesma premissa de não-gaussianidade. Se LMS concordar com GMR, a
  discordância é do proxy; se ficar no meio, é do método. É o desempate mais
  barato disponível.

### Fechados (contexto)

- [x] **Gate de não-gaussianidade em η — REFEITO em 2026-08-13.**
  `script/nongaussian_gate.R` → `output/nongaussian/gate.md`. **0 de 5**
  componentes deixam de rejeitar normalidade no full, contra **2 de 5**
  pré-COVID — a rota existe só no full sample; a janela pré-COVID viola o
  limite de no máximo um componente gaussiano. **⚠ Armadilha:** o
  gate não pode reusar `output/irf/irf_coherence_cell.rds` — guarda só
  `irf`/`var_names`/`tcode`/`mpind`, não o objeto DFM; o script re-estima
  (barato, sem bootstrap). Detalhe: `historico_decisoes.md` §0.2.
- [x] **Ramo `identification = "nongaussian"` implementado — FEITO em
  2026-07-27**, branch `identificacao-nao-gaussiana`. GMR (2017) PML-ICA
  **traduzido para o repo** em `R/identification/nongaussian_gmr.R` (não usa
  `IdSS::estim.SVAR.ICA`, quebrado para n≥4 — `historico_decisoes.md` §0.1).
  Validação em `script/validate_gmr_ica.R` reproduz a aplicação publicada.
  Smoke test do proxy inalterado.
- [x] **Corroboração medida e testada contra nulo — REFEITA em 2026-08-13.** GMR
  reestimado (`nboot=800`, `NG_STARTS=200`). Sob a coluna rotulada, o sinal
  coincide em **0,963** das 353 células sig90 do proxy e em **1,000** das 54
  células sig90 entre as oito manchetes. **⚠ O nulo derruba isso como afirmação
  estatística:** 2.000 direções aleatórias dão `p=0,149` para a concordância e
  `p=0,087` para a razão de magnitude. No bloco da curva o nulo é especialmente
  permissivo porque normalizar em `yield_6m` força co-movimento.
  **Concordância de sinal não é evidência de corroboração.** Nota:
  `notas/2026-08-01_robustez_identificacao.md`.
- [x] **Coluna vice-líder inspecionada — REFEITO em 2026-08-13.** A regra com
  `z` e as três regras estruturais sem instrumento — impacto e FEVD de
  `yield_6m`, e FEVD do bloco da curva — escolhem todas a **coluna 1**. A
  vice-líder pela correlação é a coluna 4; concorda com o proxy em 0,841 das
  células sig90, contra 0,963 da vencedora. A rotulagem está mais coerente que
  na rodada `(7,6)`, embora a folga de correlação permaneça pequena (0,044).
- [x] **Descartado por decisão do autor (2026-08-01): rodar o GMR num VAR
  pequeno.** Seria a rota com melhor chance de passar o gate (resíduos de
  observáveis quase não sofrem média cruzada), mas contradiria o argumento
  central do paper contra modelos VAR pequenos por maldição da
  dimensionalidade.

---

## D. Diagnósticos e comparações pendentes

- [ ] **Comparação cross-instrumento do IPCA sob (5,5)** — *destravado em
  2026-07-26; falta só a análise.* O argumento "a corcova é universal entre
  instrumentos e some pre-COVID" fecha o diagnóstico do price puzzle, mas foi
  construído no vintage e instrumento antigos e não reproduzia. A fonte
  (`output/irf/spec_sweep_irf_long.csv`) **já foi regenerada** junto com a
  migração da taxonomia — 320 células, 8 instrumentos, a célula corrente `(5,5)`
  e as duas janelas inclusas. Falta rodar a comparação e escrever o resultado;
  sem ele o §5.5 não
  pode afirmar que a corcova é amostral. Contexto novo do
  `irf_coherence_leitura.md`: a corcova vive em **h2-h8** e é o pedaço
  significativo (`price_ipca` sig90 em h5; `ex0` em h2 e h4-h8; `dw` em h4/h5/h7),
  **fora** da janela escorada h12-h48 — então o veredito `incoerente` do
  `price_core_ipca_ex0` é outra coisa (ele nunca volta a negativo no médio
  prazo), e a comparação tem que olhar h2-h8, não a janela da régua.
  - **[2026-08-13] Metade da conta foi refeita na produção corrente:** na célula
    `(5,5)` × `z_jk_bs_purif`, `price_ipca` dá h6 **+0,089** / h12 **+0,031** /
    h24 **−0,169** na amostra cheia contra h6 **−0,092** / h12 **−0,066** /
    h24 **+0,112** pré-COVID. Falta a perna cross-instrumento (o eixo
    "universal entre instrumentos") e a leitura em h2-h8. **Destrava** o item
    do §4.5 no Tema A.
- [ ] **Spread de concessões novas** como complemento ao ICC — deve abrir já no
  curto prazo, ao contrário do ICC (taxa da carteira, reprecifica devagar).
  Desejável, não bloqueante.

### Fechados (contexto)

- [x] **Benchmark GRG (2025) sem a célula het — FECHADO em 2026-08-01.** A
  reconciliação não precisa de célula het nem de estimação nova: o desacordo de
  sinal do câmbio é de **frequência e propagação**, não de identificação.
  (i) A réplica em Python do referee2 sobre os **nossos** dados diários
  (`arquivo/relatorio/correspondence/referee2/replication/referee2_py_b1.csv`)
  dá o real **apreciando 4,53% por 100bp**, **dentro do IC 95% do GRG**
  ([−6,57; −3,63] em torno de −5,10) — a identificação diária replica o GRG na
  nossa amostra. (ii) O teste de proporcionalidade dá **LR = 135,1,
  p_boot = 0,005** no diário contra **nenhuma identificação** nas 288 células
  mensais válidas da grade corrente (320 desenhadas).
  ⚠ O argumento (iii) da versão anterior deste item vinha do teste de três
  vias, **removido do script em 2026-08-10** (`historico_decisoes.md` §2.4), e
  não é mais citável. (i) e (ii) sustentam a reconciliação sozinhos.
  Ao escrever, **incluir a variável inconveniente**: o mesmo `b_1` diário dá IBOV
  +2,83% por 100bp, participação espectral 0,0015 — ações não identificadas
  naquele sistema. Fonte:
  `notas/2026-08-01_robustez_heterocedasticidade.md` §6.
- [x] **Dominância fiscal: IMPACTO não é dependente de estado, PERSISTÊNCIA é
  — FEITO em 2026-07-28/29; virou subseção `sec:estado` do §5, baseline
  migrado de EMBI para CDS.** `diagnostics/07_dominancia_fiscal.R`, LP-IV com
  interação completa, regime = MA12 do indicador de risco cortada na mediana.
  **Impacto (h=0-4): não é dependente de estado** — robusto nos 7 indicadores
  testados, |t_dif| do câmbio nunca passa de 1,14. **Persistência (h=6-8): é**
  — sob CDS alto a depreciação persiste (+0,059/+0,112/+0,054 em h=6/7/8)
  contra reversão para apreciação sob risco baixo, t_dif 2,81-3,60, confirmado
  por `dbgg_d12`. **⚠ A conclusão depende do indicador**: EMBI e CDS
  correlacionam 0,933 em MA12 mas os regimes discordam em 24 de 141 meses —
  sob **EMBI não se detecta nada** (t=0,32), só sob CDS/ΔDBGG. Ressalvas
  obrigatórias: p_boot conjunto 0,044 é marginal, achado pós-hoc, não
  pré-registrado. IFNC não discrimina (o gap é de mercado inteiro, não de
  banco). **Achado metodológico reutilizável:** o χ²(9) assintótico
  super-rejeita nesta amostra (q95 bootstrap 38,9-89,1 contra 16,9 nominal,
  2,3-5,3×) — qualquer comparação de subamostra neste painel precisa de wild
  block bootstrap, não de p assintótico. **⚠ Armadilha documentada:** interação
  **parcial** (só do tratamento) dá F de primeiro estágio artificialmente baixo
  (3,4-5,9) porque `x·(1−I)` é mecanicamente zero em metade da amostra — sob
  interação completa sobe a 10,6-29,0; concluir "o regime baixo não é
  identificado" da interação parcial seria erro de especificação. Tabela em
  `diagnostics/output/t7_3b_artefato_interacao.csv`. Números re-rodados em
  `diagnostico_dfm.md` seção 7.
- [x] **Bloco de ativos: janela reportável h≤12 — RESOLVIDO em 2026-07-28**
  (Tarefa 6, `diagnostics/06_bloco_ativos.R`). H2 ("horizonte longo é
  oscilação amortecida, não economia") confirmada em três eixos: seção
  cruzada 8/8 negativos em h=0 → 1/8 em h=12 → 3/8 em h=48 (amplitude cresce
  **30,4×**); ordenação econômica por sensibilidade a juros **inverte**
  (+0,903 em h=0 → −0,672 em h=48, `asset_imob`/`asset_ifix` trocam de posição
  1↔7); banda h36/h0 razão mediana **10,46** nos `asset_*` contra **0,944**
  nas 81 séries tcode 1 — exclusivo do `cumsum`. Nenhum dos 8 índices é sig90
  em horizonte nenhum. Hipótese de duration do IFIX fica sem teste (cache
  `rb3` incompleto), mas seu β de juros medido é o 2º menor e não significativo
  — contraria a leitura de duration.
- [x] **Ações em retorno acumulado: bloco acionário nulo é MECÂNICO — TESTADO E
  CONFIRMADO em 2026-07-31.** `script/asset_representation.R` →
  `output/assets/`. As 8 ações entram como retorno composto mensal enquanto o
  resto do painel entra em nível — o `diff()` do BLL estima o loading na
  **segunda** diferença do log-preço. Sob representação em **nível**, o
  bloco vai de **0 para 39 células sig90** (h=0-5, 7 de 8 índices), pontos
  dobram e bandas encolhem (Ibovespa −1,67→−3,68); o pico falso de **+20,3% em
  h≈24** desaparece (era erro acumulado do `cumsum`, não economia); 79 de 92
  pares sig90 sobrevivem. **⚠ O preço:** custa força de instrumento — ξ_mp
  full 10,43 → **8,94** em log-nível (pré-COVID quebra, 3,91), mas o nível
  simples mantém ξ_mp em **10,23**. **Decisão do autor (2026-07-31): a
  mudança de painel fica de lado** (`historico_decisoes.md` §3.1) — só o
  transform de exibição (`cumsum`) será corrigido, ver Tema E. **Distinção
  que não pode se perder:** é a representação do *painel* que recupera o
  bloco; o conserto do `cumsum` (Tema E) não recupera nada sozinho. Nota:
  `notas/2026-07-31_acoes_representacao.md`.

---

## E. Código e higiene

- [ ] **Fundamentar ou substituir o default operacional `q=5`** — *aberto em
  2026-08-13 na migração do painel de 111 séries.* `r=5` está decidido pelo
  Bai--Ng IC2 padronizado para BLL. `q=5` foi promovido provisoriamente para
  preservar a direção dinâmica da célula escolhida, mas a seleção de choques
  comuns não está fechada. Qualquer mudança deve ser comparada na mesma amostra
  completa e repetir o gate de 800 réplicas e os cinco impactos obrigatórios.
- [ ] **Corrigir `estimate_dynamic_factors()` quando `q=1<r`** — *aberto em
  2026-08-13 pela grade expandida.* `diag(sqrt(eigenvals))` interpreta o único
  autovalor como dimensão da matriz, produzindo `M` não conforme. A auditoria
  usa uma matriz 1×1 em compatibilidade local, sem tocar produção. A correção
  do módulo deve reproduzir todas as células `q>1` e o smoke test vigente antes
  de substituir a compatibilidade experimental.
- [ ] **Corrigir o `cumsum` do bloco acionário — e SÓ isso** — *aberto em
  2026-07-31, consequência do item "Ações em retorno acumulado" (Tema D,
  Fechados, acima).* **Decisão do autor (2026-07-31): a entrada do painel em
  log-nível fica de lado**; ver `historico_decisoes.md` §3.1 para o teste e o
  porquê, e não reabrir sem evidência nova. O que entra é o conserto do
  transform de exibição.
  - **⚠ Saiba o que isto entrega antes de escrever qualquer frase sobre ele.**
    Medido em 2026-07-31 com a spec de produção e nboot=800: o bloco continua
    **nulo a 90% — 1 célula de 392** (só `asset_ifix` em h=1), e **0 de 8 em
    h=0**. Isso é **matemática, não amostra**: em h=0 o `cumsum` é no-op e o
    ×100 é escalar positivo, logo **a significância em h=0 é invariante ao
    tcode**. Quem recupera o bloco acionário é a representação do painel, e só
    ela. **Nenhum texto pode atribuir a recuperação do bloco a esta correção.**
  - **O que ela entrega de fato, e não é pouco:** a razão de largura h36/h0 cai
    de **10,46 para 0,38** nos 8 índices; o pico falso de **+20,3% do Ibovespa
    em h≈24** desaparece; e o tier de 68% **melhora onde importa** — sig68 em
    h ≤ 12 sobe de **19 para 35**, porque as células de médio prazo que eram
    ruído acumulado deixam de existir e o sinal de curto prazo fica visível.
    Some também a armadilha de pontuação do benchmark VAR (extremo global com
    sinal oposto ao do impacto nas 8 ações).
  - **⚠ Duas armadilhas de implementação — não é `tcode 2 → 1`.**
    (i) **tcode 1 não multiplica por 100** (`impulse_responde.R:273-274`), então
    a troca crua devolve as ações a decimais e recria exatamente o estado
    pré-2026-07-24 que o `historico_decisoes.md` §3 marca como "fora de escala".
    É preciso um código que faça `x * 100` **sem** acumular.
    (ii) **A janela de coerência tem de ser retunada junto.** `coherence_var_table()`
    (`R/identification/irf_coherence.R:31-33`) pede sinal negativo **sustentado**
    em h0-6, que é propriedade de um *nível* de preço; uma resposta de retorno
    mensal cai no impacto e volta a ~0. Foi exatamente isso que motivou a
    migração 1 → 2 em 2026-07-24 (`incoerente` caiu de 5 para 1). Sem retunar a
    janela, os vereditos `incoerente` de Ibov/IDIV/IMOB/MLCX voltam.
  - **A jusante:** re-rodar `irf_coherence_check.R` e `fig_section5.R`, atualizar
    a constante `asset_ibov -1.673` fixada no smoke test do `CLAUDE.md` e em
    `script/jk_sovereign_confound.R:603`, e reescrever o bloco de ações do §4 e
    a nota da `fig:acoes`. O comentário de `arquivo/tex/main.tex:445` (archived draft), que explica o pico
    de médio prazo como erro acumulado, **fica sem objeto** e deve sair.
- [ ] **`kilian_correction` testa singularidade por determinante de matriz enorme**
  — *aberto em 2026-07-31, encontrado ao rodar o benchmark VAR; **não corrigido
  de propósito**, porque mexe no caminho de produção.*
  `R/modeling/factor_estimation.R:385` decide entre `solve` e `MASS::ginv` para a
  equação de Lyapunov por `Mod(det(Re(lyapunov_matrix))) < 1e-12`. A matriz é
  `(N·p)²  ×  (N·p)²`: **576×576** no VAR pequeno e **1764×1764** no DFM. O
  determinante de uma matriz desse porte subborda para ~0 mesmo perfeitamente
  bem-condicionada (é o produto de centenas de fatores `1 − λᵢλⱼ`, todos < 1), de
  modo que o ramo do `ginv` é **sempre** tomado e o aviso
  "Usando pseudo-inversa para SIGMAY" sai em toda rodada.
  - **Não é bug de resultado:** `ginv` coincide com a inversa quando a matriz é
    não-singular. Conferido de duas formas em 2026-07-31 — a implementação de
    `factor_estimation.R` bate a cópia (agora apagada) de `model_var.R` a
    **5,6e-17**, e o smoke test do `CLAUDE.md` continua exato.
  - **Custo real:** tempo (pseudo-inversa de 1764×1764 por réplica de bootstrap) e
    ruído no log que mascara avisos de verdade.
  - **Correção certa:** trocar o teste por `rcond()` ou `kappa()`, ou tentar
    `solve()` dentro de `tryCatch` e só cair no `ginv` se falhar. **Mudar isso
    altera o caminho numérico da produção** — exige re-rodar o smoke test e
    conferir `irf_coherence_h.csv` ponto a ponto antes de commitar.
- [ ] **Cortar a `tab:first_stage`** — *aberto em 2026-07-27; metade fechada em
  2026-08-05.* ✅ **A regeneração foi refeita em 2026-08-13**:
  `instrument_diagnostics_report.md` usa o painel corrente de 111 séries e as 8
  variantes vivas — zero linhas `z_het`. ❌ **Falta o corte como tabela de
  paper.** O
  conteúdo que o §3 precisa está ali (§1: β̂, SE(HC0), t, p, F, ξ₁, R²; §1.1:
  bloco MOSW completo com ξ_mp) — falta transpor para o `.tex`.
  `mosw_strength_grid.md` está corrente mas é grid `(r,q) × amostra ×
  instrumento`, não tabela de 1º estágio. **Sem** os valores críticos de MOP
  (razão no item de robustez do ξ_mp, Tema B).
- [ ] **Seleção da etapa 2 é dominada pela janela pre-COVID** (aberto em
  2026-07-26). Com a taxonomia migrada, 23 células ficam `ok` em `yield_6m` e
  **todas empatam** em `score_hard_frac = 1` e `score_ext = 3`, então o
  desempate é só ξ_mp — que é sistematicamente maior pre-COVID. Resultado: o
  top-5 é inteiramente `pre_covid`, e o baseline de produção (full, 7, 6) entra
  pelo force-append. A comparação da etapa 2 acaba confundindo escolha de
  instrumento com escolha de janela. Considerar um teto por amostra análogo ao
  `MAX_PER_INSTRUMENT`, ou desempatar por `f_reduced`.

### Fechados (contexto)

- [x] **Produção migrada para 111 séries em `(5,5)` em 2026-08-13.** O painel
  `drop_setor_externo__eua__credito__imoveis` remove as duas quase-duplicatas e
  mantém fiscal + expectativas; a produção foi centralizada, regenerada e
  validada com 800 réplicas, zero falhas e impacto exato de +50 pb. A recomendação
  intermediária de 123 séries `(4,3)` foi superada. Nota:
  `notas/2026-08-13_migracao_producao_painel_111_r5q5.md`.

- [x] **Seleção de fim de mês corrigida e rodada canônica reconstruída em
  2026-08-12.** Curva, EMBI+ e ANBIMA usam a maior data mensal, com validação de
  datas e unicidade. Foram corrigidos 25 meses no arquivo completo e 23 na
  amostra. Na produção daquela rodada, o painel tinha 106 séries, 153 observações
  e 147 inovações; ξ_mp passou a 7,65 full / 11,53 pré-COVID. Essa produção foi
  superada pela migração de 2026-08-13. Nota:
  `notas/2026-08-12_correcao_fim_mes_curva.md`.
- [x] **FECHADO em 2026-08-05 — `R/modeling/svensson_model.R` ficou sem
  consumidor** (aberto em 2026-07-26). Era o motor do `script/yield_curve.R`,
  apagado na mesma data — a curva do painel é o insumo fixo do orientador
  (`data/raw/yields/yields_dia.csv`). O `source()` no `download.R` era chamada morta
  e foi removido; nenhuma das 7 funções do módulo é chamada em lugar nenhum.
  **Decisão: movido para `arquivo/R/modeling/svensson_model.R`** — a opção da
  convenção do repo para código não executado e não citado pelo paper. As ~600
  linhas continuam recuperáveis se a curva voltar a ser ajustada in-house. Ver
  `historico_decisoes.md` §4 e a entrada em `arquivo/README.md`.
- [x] **Taxonomia do `irf_spec_sweep.R` migrada para ξ_mp — FEITO em
  2026-07-26.** `classify_sweep_cells` classifica por `wald_mp` (limiares MOSW:
  `weak_xi_mp_severe`<3,84, `weak_xi_mp`<10). Em 2026-08-13, o relatório
  passou a apresentar ξ_mp e F_rob,mp na mesma direção. As 320 células foram
  regeneradas, e `wald_mp` foi conferido contra
  `mosw_strength_grid.csv`. A célula corrente `(5,5)` full é anexada
  explicitamente à etapa 2 como rede de segurança (ver item de seleção acima).
- [x] **Prosa do coherence separada do corpo gerado — FEITO em 2026-07-26.**
  Leitura interpretativa em `output/irf/irf_coherence_leitura.md` (manual, não
  tocada por script); `irf_coherence_report.md` é o corpo gerado, com aviso e
  ponteiro. A redação sob `(7,6)` foi posteriormente substituída pela leitura da
  produção `(5,5)`; a versão de 2026-07-12 perdida no `fc0ef58` não foi
  restaurada.
- [x] **`irf_mp_raw` renomeado para `irf_mp_pre_tcode` — FEITO em 2026-07-26**
  em `ident_ext_instr` (`R/modeling/impulse_responde.R`) — nenhum consumidor
  do campo, docblock agora explicita pós-normalização/pré-tcode. Zero mudança
  de output (smoke test 5/5).
- [x] **`script/run_all.R` — FEITO em 2026-07-26.** Orquestrador de 8 estágios,
  um processo `Rscript` por estágio (os scripts fazem `rm(list=ls())`). Flags:
  `--list`, `--dry-run`, `--from`, `--to`, `--only`, `--skip`,
  `--skip-existing`, `--continue-on-error`. Preflight aborta se faltar insumo;
  log por estágio em `output/logs/`.
- [x] **Branches consolidadas — FEITO em 2026-07-26.** Cinco branches locais
  (cadeia linear) merged em `main` por fast-forward e apagadas. `codigo_olea/`
  (87MB, commitado por engano) removido da história não-enviada e entrou no
  `.gitignore` junto dos três `codigo_*` irmãos.

---

## Convenção de branches

**`main` é o estado sempre reproduzível** — o smoke test de `CLAUDE.md` tem que
passar em qualquer commit dela.

- **Uma branch por aposta metodológica que pode ser rejeitada.** Foi o caso da
  het: se estivesse isolada, teria sido descartada inteira em vez de deixar
  resíduo espalhado por seis scripts. A próxima é
  **`identificacao-nao-gaussiana`** (gate em η + ramo
  `identification = "nongaussian"`).
- **Escrita vai direto na `main`**, em commits pequenos: §5 para o tex, resumo,
  introdução, conclusão, revisão de literatura. Não é experimento, não pode
  "falhar", e só toca `paper/` (o antigo `tex/` está arquivado em
  `arquivo/tex/` desde 2026-08-02 e não recebe mais escrita).
- **Higiene e re-runs de diagnóstico vão direto na `main`**: o bloco de higiene
  de 2026-07-26 (`run_all.R`, renomear `irf_mp_raw`, taxonomia por ξ_mp,
  separar a leitura do coherence) foi feito assim. Segue valendo para o placebo
  `commodity_metal` e a comparação cross-instrumento do IPCA.
