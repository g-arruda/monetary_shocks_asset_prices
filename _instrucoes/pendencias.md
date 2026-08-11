# Pendências

**Última revisão:** 2026-08-11. Itens abertos organizados por tema (A-E);
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
| Dimensão | **r = 7, q = 6**, VAR(p = 6) nos fatores |
| Painel | 106 séries, 2013-01 a 2025-09 (147 meses alinhados) |
| Inferência | wild bootstrap Gonçalves-Kilian, Kilian (1998) só no DGP do bootstrap; nboot = 800, seed 123, bandas 68/90, h = 0-48 |
| Força | ξ_mp = **10,43** full / **12,22** pre-COVID; conjunto AR **invertido em 2026-08-10** e limitado em 31.164/31.164 células, com 87 das 91 sig90 sobrevivendo |

## Rota metodológica decidida (2026-07-24)

Manter o **primário frequentista** e blindar o proxy no limiar com duas camadas,
sem virar bayesiano. Fonte:
`relatorio/working-notes/2026-07-24_avaliacao_5_artigos_robustez.md`.

1. **Corroboração independente do instrumento** — identificação por
   **não-gaussianidade**: Lanne-Meitz-Saikkonen (2017, *JoE*, ML paramétrico) e
   Gouriéroux-Monfort-Renne (2017, *JoE*, pseudo-ML/ICA, imune ao chute de
   densidade). Identificam sem usar o proxy, que passa a **rotular** a coluna
   monetária — e a restrição do proxy vira **testável** (Wald/LR). Rota mais
   barata e a única que preserva o paradigma. Código em R para as duas:

   - **GMR (2017) literal** — ~~pacote `IdSS`~~ **traduzido para o repo em
     2026-07-27**: `R/identification/nongaussian_gmr.R`. O pacote do Renne
     (`remotes::install_github("jrenne/IdSS")`, commit `20c8ea6`) tem o caminho
     ICA **quebrado para n ≥ 4** — `make.M`, `make.C` e o gradiente, os três —
     e este projeto roda em q = 6. Ver `historico_decisoes.md` §0.1. O pacote
     segue instalado e é usado **só** como alvo de validação cruzada em
     `script/validate_gmr_ica.R` (`make.Omega`, `make.A.matrix`,
     `make.Asympt.Cov.delta` estão corretas em qualquer n, e o dataset
     `US3var` é o da aplicação publicada). Livro dos autores:
     <https://jrenne.github.io/IdentifStructShocks/NonGaussian.html>.
   - **LMS (2017)** — `svars::id.ngml` (ML paramétrico, Lange et al., *JSS* 2021).
   - **Atenção à atribuição:** `svars::id.dc` e `id.cvm` são **Matteson-Tsay
     (2017)** e **Herwartz-Plödt**, ICA baseada em dependência — do mesmo
     espírito semiparamétrico do GMR, mas **não** o PML do artigo. Citá-los como
     "GMR" seria erro de citação no paper; para GMR, use `IdSS`.
2. **Robustez a IV fraco dentro do paradigma** — Angelini-Cavaliere-Fanelli
   (2024, *JoE*): pré-teste de força por bootstrap robusto a heterocedasticidade
   condicional e a proxies *zero-censored* (é o caso da máscara JK), sem viés de
   pré-teste; conjuntos de confiança robustos por inversão de teste. **Sem
   replication package público** — codificar do zero.

Bayesiano (Braun-Brüggemann, Caldara-Herbst) fica como apêndice **opcional**.
Nenhum dos métodos é escrito para modelo de fatores: todos exigem a mesma
adaptação "identificar nas q inovações e propagar via Λ" que os ramos existentes
de `compute_irf_dfm` já implementam.

---

## Índice de itens abertos

| Tema | Item | Observação |
|---|---|---|
| A | §5 Robustez em `texto_anpec/` tem 2 das 6 subseções — faltam het/GRG, construção do instrumento, especificação e Limitações | destravado em 2026-08-09; deixou de ser bloqueador |
| A | Escrever a subseção de robustez sobre heterocedasticidade (Rigobon) | números prontos, redação pendente; entra como §5.3 depois de `sec:confound`; sem chave nova |
| A | Escrever as bandas Anderson-Rubin no `.tex` (§3.7 + subseção de §5 + apêndice) | destravado em 2026-08-10 pelo fechamento do item de Tema B; números prontos e validados, sem chave nova |
| A | Escrever a coincidência FOMC no `.tex` (subseção de §5) | destravado em 2026-08-10 pelo fechamento do item de Tema B; números prontos, sem chave nova |
| A | Ressalva §4 + Limitações (reversão = quase-raiz-unitária) | depende da subseção Limitações; framing invertido pelo council 2026-08-10 |
| A | Tabela `tab:rq_sweep`: 4 células → grid completo | dado já existe; regra como escrita seleciona (7,7), não (7,6) — council 2026-08-10 |
| A | Corrigir leitura da Wald conjunta em §3.7 | — |
| A | Documentar a mecânica do bootstrap no texto | — |
| A | Vertente de prêmio de risco cambial ausente do §2 | exige chave nova (regra das 25) |
| A | Corrigir leitura do IMAT em §4.6 | independente, sem citação nova |
| A | Resumo contradiz §4.2 sobre o câmbio na reversão de médio prazo | council 2026-08-10, verificado, sem citação nova |
| A | 3,64% não é escala-livre; comparações com GRG/Ibovespa/Gertler-Karadi em bases diferentes | council 2026-08-10, sem citação nova |
| A | Atribuição errada do limiar "≥10" a Montiel Olea-Stock-Watson | council 2026-08-10, sem citação nova |
| A | Portar reconciliação com GRG (2025) para o corpo do §6 | decisão já tomada (Tema D), falta redação; réplica precisa rodar na vintage atual |
| B | Bandas simultâneas (Montiel Olea-Plagborg-Møller 2021) | exige referência nova |
| B | Validade do wild bootstrap (Jentsch-Lunsford) | mínimo aceitável: 1 parágrafo no §3 |
| B | LP-IV como robustez à especificação dinâmica | desejável, não bloqueante |
| B | Comunalidade baixa (`price_core_ipca_ex0`, `asset_ifix`) | — |
| B | Decomposição do wedge de UIP | prioridade alta, council 2026-08-10; só pós-processamento |
| B | Corrigir descrição do placebo `sp500_vix` (é só VIX, sem S&P 500) | council 2026-08-10, achado factual |
| C | Decidir enquadramento do GMR no paper | — |
| C | Construir um teste com poder | — |
| C | LMS (2017) como terceira leitura | desempate mais barato disponível |
| D | Comparação cross-instrumento do IPCA sob (7,6) | dado já existe, falta rodar |
| D | Spread de concessões novas | desejável, não bloqueante |
| E | Corrigir o `cumsum` do bloco acionário | só o transform, não o painel |
| E | `kilian_correction`: determinante em matriz enorme | não mexer sem re-rodar smoke test |
| E | Cortar a `tab:first_stage` | relatório já regenerado em 2026-08-05; falta o `.tex` |
| E | Seleção da etapa 2 dominada pela janela pré-COVID | — |

---

## A. Texto do paper

*Inclui os achados do council review de `arquivo/tex/main.tex` (archived draft; `texto_anpec/paper_anpec.tex` is now canonical) em 2026-07-31 —
revisão paralela de três críticos independentes (harsh-referee e
macro-theorist em Claude Opus, methodologist via Gemini 3.1 Pro como par
cross-vendor). Veredito da síntese: **Major Revision**, não Reject — os dois
problemas de aparência mais fatal (sem benchmark VAR, sem bandas AR) eram
trabalho não feito com ferramenta já pronta no repo, não defeito estrutural:
o benchmark VAR já foi rodado (ver "Fechados" abaixo) e as bandas AR foram
rodadas em 2026-08-10 (Tema B, fechado) — do segundo problema resta só a
redação, item aberto neste tema. Relatório completo: `relatorio/council_2026-07-31.md`.*

*Segundo council review, agora sobre `texto_anpec/paper_anpec.tex` diretamente
(não mais o draft arquivado), em 2026-08-10 — painel macro-paper de 4
críticos (methodologist, macro-theorist, skeptic, harsh-referee, todos Claude
Opus). Veredito: **Major Revision**, mesma classificação do round anterior,
mas por razão diferente: três das quatro alegações-manchete do paper
(reversão sincronizada de médio prazo, nulo do bloco de ações, reconciliação
com GRG) são contraditadas por evidência que já está no próprio repositório,
não por falha nova de identificação. **O fato central sobrevive** — câmbio +
EMBI+/CDS conjuntos, sig90 no impacto — só a atribuição de mecanismo
("domina o diferencial de juros", "dominância fiscal") não. Achado mais
grave: `data/fomc_dates.csv` nunca existiu, então a flag `fomc_coincide` que
o código computa é sempre FALSE por default vazio — **fechado no mesmo dia**
(ver Fechados abaixo): a exposição era ainda maior do que o council estimou
(24 dos 62 dias retidos, 35,5% de Σ|z|, 8 dos 20 de maior alavancagem), mas
o teste **não encontra contaminação**. Segue aberto o item factual de que
`sp500_vix` é só o VIX (o painel não tem nenhuma série de nível do S&P 500).
Relatório completo, com as quatro críticas brutas e a síntese com Named
Dissents: `relatorio/council_2026-08-10.md`.*

- [ ] **A `§5 Robustez` de `texto_anpec/paper_anpec.tex` existe desde
  2026-08-09 com 2 das 6 subseções da composição recomendada
  (`working-notes/2026-08-01_tier_list_robustez.md` §7) — faltam 4.**
  Escritas: `sec:exogeneidade` (previsibilidade do instrumento mensal em cinco
  especificações com wild bootstrap, Ljung-Box justificando `nw_lags = 0`, o
  teste `commodity_metal` em R$ contra US$ com a queda de ξ_mp para 7,87
  declarada, e os placebos nas duas barras com a `fig_placebos`) e
  `sec:confound` (item seguinte, fechado). A conclusão passou a ser a **§6** e
  as duas remissões a "Seção 5" foram repontadas. Compila limpo, 27 páginas,
  nenhuma citação ou referência indefinida, **nenhuma chave nova**.
  **O que falta, na ordem da composição recomendada:** identificação
  alternativa e divergência com GRG (item abaixo), construção do instrumento e
  dimensão do sistema (A3 + A4 + A2), especificação do modelo (A5 + A1 + A7 +
  LP-IV com o rótulo certo) e **Limitações**, que é a que bloqueia o item da
  reversão de médio prazo mais abaixo. A prosa antiga de `arquivo/tex/main.tex`
  segue sendo a fonte para Limitações e `sec:estado`; a de exogeneidade e
  placebos foi **reescrita**, não portada, contra os CSVs de origem, e por isso
  já traz a resposta ao `commodity_metal` que a versão antiga pressupunha.
  A nota da `fig:acoes` que promete uma discussão "no texto" continua sem
  contrapartida.
- [ ] **Escrever a subseção de robustez sobre identificação por
  heterocedasticidade.** Os números existem, estão conferidos e a leitura está
  redigida em `working-notes/2026-08-01_robustez_heterocedasticidade.md` §7
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
    identifica por segundos momentos; (ii) 252 especificações × 5 definições de
    regime, **nenhuma identifica**, e não é severidade de correção (Holm interno
    ao desenho mantém zero nos cinco); (iii) **segunda condição necessária falha
    em separado** — autovalores generalizados não distintos (separação relativa
    mediana 0,11-0,17) —, e por isso **nenhuma IRF é reportada**, o que precisa
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
- [ ] **Escrever as bandas Anderson-Rubin no `.tex`** — *aberto em 2026-08-10,
  ao fechar o item de Tema B. Os números existem, estão validados contra o
  código oficial e a leitura está redigida em
  `relatorio/working-notes/2026-08-10_bandas_anderson_rubin.md` §9 ("o que pode
  e o que não pode ser escrito"); falta só a redação. **Nenhum `.tex` foi tocado
  na rodada da implementação, por decisão do autor.***
  - **Onde, em dois lugares distintos.** (i) Uma frase em `§3.7`, junto do ξ_mp,
    dizendo que o conjunto AR de 95% é **um intervalo limitado em todos os
    horizontes** porque ξ_mp > 3,84 — e que essa não é uma coincidência
    numérica, o coeficiente de λ0² da quadrática **é** ξ_mp. (ii) Uma subseção
    de `§5` (a composição recomendada a põe no bloco de especificação/inferência)
    com o placar e o prêmio de IV fraco. **Label sugerido `sec:ar`.**
  - **Apêndice metodológico é obrigatório na entrega** — é a resposta pronta
    para a banca ("como você implementou isto se nenhuma literatura cobre o
    método?"), e a resposta correta é *MOSW (2021) é agnóstico à origem do VAR
    reduzido; um DFM estático é, na parte dinâmica, um VAR nos r fatores com uma
    equação de medida linear acoplada*. A nota §§1-4 já está no formato de
    apêndice e só precisa de tradução para LaTeX.
  - **Números a usar:** conjunto limitado em **31.164 de 31.164** células;
    **87 das 91** afirmações sig90 sobrevivem; prêmio de IV fraco **1,164** a
    90% (1,052 a 68%; 1,134 pré-COVID, onde ξ_mp é 12,22); `cambio_usd` no
    impacto AR90 **[0,081; 0,246]** contra ponto 0,1498 e bootstrap
    [0,079; 0,297].
  - ⚠️ **Duas ressalvas obrigatórias no corpo, não em nota.** (i) As 4 células
    perdidas são **3 impactos do bloco de atividade** (`ind_bens_duraveis`,
    `ind_bens_capital`, `ind_transformacao` em h=0) mais `cambio_eur` h3 —
    é afirmação da `§4.3`, e `ind_bens_duraveis` erra por **0,034** num
    intervalo de largura 12,7. (ii) A banda AR sai **mais estreita** que a de
    bootstrap (0,646) porque **condiciona no espaço de fatores estimado**,
    enquanto o bootstrap reestima o DFM por réplica; escrever isso como
    "confirma" ou "estreita o resultado" seria comparar objetos diferentes. A
    comparação limpa é AR contra delta-method.
  - **Sem referência nova.** `montieolea2021` (ou a chave equivalente já usada
    em `§3.7`) basta. Não citar Staiger-Stock — ver o item de atribuição do
    limiar "≥10", que é independente deste.
- [ ] **Escrever a coincidência FOMC no `.tex`** — *aberto em 2026-08-10, ao
  fechar o teste de coincidência FOMC (Tema B, Fechados). Os números existem e
  estão conferidos; falta só a redação.*
  - **Onde:** uma subseção de `§5`, ao lado de `sec:confound` — mesmo tipo de
    teste (confound no filtro JK), agora contra o calendário do Fed em vez do
    risco soberano.
  - **A ordem do argumento:** (i) a exposição é maior do que o council estimou
    — 24 dos 62 dias retidos coincidem com decisão do FOMC (38,7%, 35,5% de
    Σ|z|, 8 dos 20 dias de maior alavancagem, 7 de 8 reuniões em 2025);
    (ii) o bloco americano contemporâneo explica só **0,5%** da variância da
    surpresa nos 35 dias em que Copom e FOMC caem no mesmo dia — a **menor**
    R² da tabela —, contra **10,8%** nos 33 dias que o filtro rejeita;
    (iii) o argumento de horário (comunicado às 14h ET, antes do fechamento
    da B3 e do fixing das 15h30 ET) vale para a perna de **taxa** (UST 2a:
    5,00pb Ter→Qua contra 3,00pb Qua→Qui) e **falha** para a de **ações**
    (S&P 0,54% contra 0,74%, a reação continua na quinta); (iv) o corte de
    ξ_mp entre limpar valores e re-derivar a máscara — 0,21 contra 2,50 —
    porque o bloco global explica 0,76% de `e_di_bs` mas 24,7% de
    `e_ibov_bs`.
  - **Veredito a reportar:** confound **não detectado**, por regra fixada
    antes dos números. Bloco americano nos 62 dias retidos: p_boot 0,458;
    interação com `1(fomc_coincide)`: 0,466; com `1(jk_bs)`: 0,511.
  - ⚠ **Escrever só sobre os testes 0-3.** O teste 4 (divisão FOMC/não-FOMC) e
    a terceira perna da regra de veredito que ele alimentava saíram do script
    no mesmo dia — nada do que produziram é reproduzível ou citável
    (`historico_decisoes.md` §2.4).
  - **Sem referência nova.**
- [ ] **Redigir a ressalva no §4 e o parágrafo em Limitações sobre a reversão
  de médio prazo.** *Extraído em 2026-08-01 de dentro do item fechado de
  estacionariedade dos fatores — mesmo padrão do item acima.* A afirmação
  defensável, mais estreita que uma acusação de artefato: a reversão de médio
  prazo do §4 (vale setorial, contração do crédito em h=24-32, reversão da
  curva e da Selic) e a persistência quase-unitária do VAR de fatores são **o
  mesmo objeto** — o par dominante da companion, |λ| = 0,976794, período 117,9
  meses. O paper pode reportar a reversão como o que o modelo implica, mas
  **não pode citá-la como evidência separada** da dinâmica que a produz. Uma
  frase no corpo (não em rodapé) para cada um dos dois lugares. Detalhe:
  `output/factors/factor_stationarity.md`,
  `relatorio/working-notes/2026-07-31_estacionariedade_fatores.md`.
  **Bloqueado pela subseção Limitações**, que é a única das seis da composição
  recomendada que ainda não existe em `texto_anpec/` e é onde o parágrafo
  entra; a ressalva do §4 é independente e pode ser escrita já.
  - **Framing mais afiado, council 2026-08-10 (harsh-referee, achado que
    inverte a leitura ingênua do próprio paper).** O texto (`:369`) já diz
    que o câmbio **não** acompanha a reversão — e é exatamente `cambio_usd`
    que sobrevive intacto (razão 1,004) à remoção do par dominante em
    `factor_stationarity.md:160`. Ou seja: **as séries que o paper cita como
    "revertendo de forma sincronizada" são as mecânicas, e a série citada
    como exceção é a única com reversão não-mecânica** — a evidência do
    paper está invertida em relação à alegação que ele faz dela. Achado
    novo que fecha o argumento: o mesmo modo dominante também produz o vale
    de médio prazo nos seis agregados de crédito e em `juros_selic` — séries
    que o §4.4/§4.1 atribuem a um canal inteiramente diferente (acelerador
    financeiro, afrouxamento da política) — o que torna o modo um mecanismo
    de **persistência geral** do painel, não algo específico de prêmio de
    risco. Reportar a participação de variância do par dominante **por
    bloco** (curva/risco vs. crédito vs. atividade): se concentrada no bloco
    câmbio/risco/curva, a leitura de "mesmo prêmio revertendo" ainda tem uma
    versão defensável; se distribuída igualmente entre os blocos, a frase
    "evidência adicional de um mecanismo comum de transmissão" (`:115`,
    `:142`) não sobrevive em nenhuma forma e deve sair.
- [ ] **Tabela `tab:rq_sweep` mostra 4 células selecionadas do grid, não o grid
  completo — e a regra como está escrita no texto seleciona (7,7), não
  (7,6).** `mosw_strength_grid.csv` já tem (7,5), (7,7), (8,5) e (8,6)
  também cruzando ξ_mp ≥ 10 nas duas janelas — a produção (7,6) é um platô, não
  uma borda de faca, mas o texto atual não deixa isso visível e expõe a escolha
  a uma crítica de specification-hunting (metodologista: "invalida a teoria de
  distribuição padrão"). **Achado mais afiado, council 2026-08-10
  (methodologist):** a frase em `:264-266`/`:292` — "(7,6)... por ser a única
  dimensão da varredura que cruza o limiar... nas duas janelas" — não é
  verdadeira sob o grid completo: (7,7) cruza 10 nas duas (ξ_mp 12,90 full /
  12,27 pre-COVID), e é o **maior** ξ_mp full-sample das 14 células. Sob a
  regra como está escrita, (7,7) seria selecionada, não (7,6). A correção não
  é mais só "mostrar as 14 células" — é **mostrar as 14 e declarar o
  tie-break ex-ante** (por que (7,6) e não (7,7): parcimônia? critério de
  informação como piso?), ou, opção que o council recomenda como mais forte,
  **sobrepor as IRFs de manchete nas 5 células do platô e afirmar
  invariância** — um platô é argumento bem mais forte que uma borda de faca.
- [ ] **Corrigir a leitura da Wald conjunta em §3.7 (Relevância do
  instrumento).** O texto lê a forma-F baixa (2,33 / 2,70) como "padrão
  esperado sob exogeneidade". É o oposto: sob relevância e exogeneidade, um
  choque de política que carrega em mais de uma inovação fatorial deveria
  produzir uma Wald conjunta **grande**; uma Wald de 13,99 em 6 g.l. (p≈0,03) é
  evidência fraca de relevância, não prova de exogeneidade. Reescrever o
  parágrafo. (Discordância registrada no council: o macro-theorist elogiou o
  mesmo trecho; a síntese ficou do lado do harsh-referee na leitura
  econométrica, mas preservou o ponto de fundo do theorist — escolher (r,q)
  pela relevância nas duas janelas amostrais, em vez de por critério de
  informação, é prática defensável.)
- [ ] **Documentar no texto a mecânica do bootstrap que o código já acerta.**
  O mesmo draw Rademacher é reusado para o instrumento e os resíduos
  (`impulse_responde.R:636-637`) e o DFM é reestimado dentro de cada réplica
  (linha 568) — ambos frequentemente errados na literatura aplicada e nenhum
  dos dois está afirmado no texto. Complementar com o número de réplicas
  falhas em 800 (substituídas silenciosamente pelo ponto estimado, o que
  estreita as bandas mecanicamente — `impulse_responde.R:645-647`) e uma nota
  sobre `Idio` ficar fixo entre réplicas (subestima a variabilidade amostral de
  Λ̂). Achados verificados no código pelo harsh-referee e re-conferidos na
  síntese, não só extraídos da prosa.
- [ ] **Vertente de prêmio de risco cambial ausente da revisão de literatura** —
  *aberto em 2026-08-02, a partir da leitura de Dalgic & Ozhan, "Dominant
  Currency Pricing and Currency Risk Premia", IMF WP/26/158, jul/2026 (antes
  circulado como "Global Shocks and Local Response: Currency Risk and Monetary
  Policy"). Fonte:
  `/mnt/storage/Documents/pdf_to_md_out/Dalgic, ozhan - Dominant Currency Pricing and Currency Risk Premia/`.*
  A introdução do `texto_anpec/paper_anpec.tex` abre na UIP e o resultado
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
- [ ] **Corrigir a leitura do IMAT em §4.6** (`texto_anpec/paper_anpec.tex:478`)
  — *aberto em 2026-08-02, mesma leitura do item acima; é independente dele e
  não depende de citar ninguém.* O texto explica o IMAT ser o único dos oito
  índices sem banda de 68% em h=1 dizendo que seus componentes são
  "exportadores **amortecidos pela depreciação** da mesma janela". Sob
  *dominant-currency pricing* esse é exatamente o canal que **não** funciona:
  preço de exportação rígido em dólar não baixa rápido para o comprador externo,
  e economias de invoicing alto ajustam o preço em dólar de forma mais lenta e
  mais fraca (Dalgic-Ozhan §5.3 e Figura 5). O amortecimento sobrevive, mas por
  outro motivo: para exportador de commodity a receita já é em dólar e o custo
  em real, então a depreciação eleva a receita em BRL por **translação
  imediata**, sem nenhum *expenditure switching*. Trocar "amortecidos pela
  depreciação" por algo como "amortecidos pela receita denominada em dólar"
  fecha a inconsistência e **alinha a frase com a §4.2**, que já usa exatamente
  essa leitura de denominação para o índice de commodities do BCB em reais.
- [ ] **Resumo contradiz §4.2 sobre o câmbio na reversão de médio prazo** —
  *aberto em 2026-08-10, council review, achado independente de 3 dos 4
  críticos (verificado linha a linha na síntese).* O resumo (`:115`, também
  `:117` na versão em inglês) lista "a taxa de câmbio" entre as séries com
  "reversão altamente sincronizada, oferecendo evidência adicional de um
  mecanismo comum". A `§4.2` (`:369`) diz o oposto: "O câmbio, por sua vez,
  não acompanha essa reversão... a partir de h=10 a estimativa pontual
  reverte de sinal sem que essa reversão se torne estatisticamente
  significativa em nenhum horizonte." A conclusão (`:545`) concorda com a
  §4.2, não com o resumo. Corrigir o resumo removendo "a taxa de câmbio" da
  frase — e considerar promover o fato descartado: `cambio_usd` é a única
  série cuja reversão sobrevive intacta (razão 1,004) à remoção do par de
  autovalor dominante da companion (ver item de médio prazo abaixo), i.e. a
  única reversão não-mecânica do modelo.
- [ ] **3,64% não é grandeza escala-livre, e as comparações com a literatura
  usam bases diferentes** — *aberto em 2026-08-10, council review
  (methodologist + harsh-referee, achado independente).* O câmbio USD/BRL
  entra no painel em **nível** (Anexo A, código 1), e a conversão para
  percentual usa a média amostral (`:351`, divisor implícito 4,11) — não é
  log-diferença, e o mesmo choque em reais vale 6,8% no nível de 2013 e 2,7%
  no de 2025. Duas consequências: (i) a comparação em `:357` com GRG
  ("3,4% a 5,6% por 100 pontos-base") mistura 50bp com 100bp — em base
  equivalente este paper reporta **7,3% por 100bp**, maior em módulo que a
  literatura que ele contradiz, não dentro da faixa dela; (ii) o mesmo erro
  de base aparece no Ibovespa (`:491`: −1,67%/50bp ≈ −3,3%/100bp contra a
  faixa citada de "1% a 2% por 100 pontos-base", sem citação própria) e na
  comparação de `:324` com o repasse de crédito corporativo americano de
  Gertler-Karadi (20bp→15bp), que não é o mesmo objeto que amplificação de
  curva soberana — o comparável correto é a própria curva de
  Alessi-Kerssenfischer, sob o mesmo desenho. Reportar toda comparação por
  100bp e contra o mesmo objeto, ou reportar R$/USD nos três pontos do
  período (início, média, fim de amostra) além do percentual.
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
  Ver `historico_decisoes.md` §4 e `working-notes/2026-08-01_robustez_
  heterocedasticidade.md` para os números; a réplica arquivada
  (`arquivo/relatorio/correspondence/referee2/replication/referee2_py_b1.csv`)
  precisa de uma rodada na vintage atual antes de virar número citável no
  texto.

### Fechados (contexto)

- [x] **Quatro correções pontuais em §3 (§3.4-§3.6), herdadas do antigo
  `_instrucoes/prompt.md` — auditadas e já aplicadas, 2026-07-26.** §3.4
  explicita a variante BS-predeterminado + JK; §3.5 removeu a frase obsoleta
  sobre (6,5) e trouxe a tabela `tab:rq_sweep` para (7,6); a frase sobre a
  correção de Kilian está correta (verificado: o ponto é sempre OLS puro,
  Kilian só no DGP do bootstrap); §3.6 comentou a validação de Olea et al. (só
  no repo, não no corpo).
- [x] **Abstract, Introdução e Conclusão — rewrite completo — FEITO,
  verificado em 2026-08-01** em `texto_anpec/paper_anpec.tex`. Resumo reporta
  depreciação de 3,64% (BRL/USD) com EMBI+/CDS em alta e nenhum dos oito
  índices de ações significativo; conclusão trata a divergência com GRG
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
  `texto_anpec/paper_anpec.tex` só começou a existir em 2026-08-09 e está no
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
  (números correntes no item de redação acima e em
  `relatorio/working-notes/2026-08-09_confound_soberano_cds.md`; os `p_boot`
  citados abaixo são da rodada antiga, antes da semeadura por célula).
  `script/jk_sovereign_confound.R` →
  `output/instrument/jk_sovereign_confound.{csv,md}`. Nota:
  `relatorio/working-notes/2026-07-31_confound_soberano_jk.md`. **O dado
  aponta ao contrário da acusação:** ΔEMBI carrega a surpresa com coef 0,326
  em dias comuns (498 quintas não-Copom) contra **0,099** nos 62 dias retidos
  pelo filtro; as interações `x:1(jk_bs)` são **negativas** nas quatro proxies
  de risco (BRL −0,036, p_boot 0,066). Ortogonalizar ao risco diário
  **melhora** ξ_mp (10,72 vs 10,43). **⚠ Ressalvas que não somem:** o
  coeficiente nos 62 dias é positivo e marginal (p=0,097) — a afirmação é
  "menos risco que um dia comum", não "zero risco". *(Atualizado em 2026-08-09: o CDS 5a diário chegou
  — `data/CDS 5y.xlsx` — e o teste roda nas duas proxies com o mesmo veredito;
  ver `2026-08-09_confound_soberano_cds.md` e as duas ressalvas endurecidas no
  item de redação acima.)* Consequência: a subseção foi escrita em 2026-08-09
  como §5.2 de `texto_anpec/paper_anpec.tex`, com as ressalvas no corpo.
- [x] ~~**Identificação: filtro JK pode estar selecionando risco soberano —
  item mais grave do council review.**~~ *(fechado acima em 2026-07-31; texto
  original preservado só por procedência.)* Os três críticos chegaram lá por
  ângulos diferentes — harsh-referee pela constelação de respostas (repasse
  1,85× na ponta longa, depreciação, abertura de CDS/EMBI), macro-theorist
  pelo ponto lógico (o filtro JK retém exatamente o padrão fiscal doméstico:
  juros↑, ações↓, câmbio↑), metodologista por comparação com GRG (2025). Ver o
  item acima para o teste e o veredito.
- [x] **Redação do confound soberano em `texto_anpec/` — FEITO em 2026-08-09,
  reescrito em 2026-08-10.** Escrito como §5.2, `sec:confound`, logo depois de
  `sec:exogeneidade`, com as três ressalvas do argumento (controle não-Copom,
  interação negativa, "não é zero risco, é menos risco") no corpo. **Fecha no
  mesmo dia a objeção do council de que "por completo" (`:538`) overstate o
  Teste C:** a máscara JK passou a ser re-derivada nos resíduos ortogonalizados
  de ambas as pernas (`z_jk_bs_norisk_mask`) — 50 dos 62 dias de produção
  sobrevivem, 13 entram, ξ_mp cai a 5,57 (contra 12,68 só nos valores), porque
  o bloco de risco explica 40,4% de `e_ibov_bs` contra 15,4% de `e_di_bs`;
  manchetes preservam sinal e ganham sig90, mas `denom_vs_prod` 0,726 —
  abaixo de ξ_mp 10, sustenta direção, não intervalo. Sem figura própria
  (overlay de 9 painéis não cortado). Fonte:
  `relatorio/working-notes/2026-08-09_confound_soberano_cds.md`.
- [x] **Introdução "DFM mais forte e mais rápido" — item moot, verificado em
  2026-08-02.** A frase problemática só existia em `arquivo/tex/main.tex:183`
  (draft arquivado); a introdução ativa de `texto_anpec/paper_anpec.tex` nunca
  fez essa afirmação — abre na falha da UIP e no canal de prêmio de risco, sem
  citar o benchmark VAR. Nada a reescrever. Se o benchmark entrar em §5 no
  futuro, usar a leitura correta: *mais forte* amplo (16/18, razão mediana
  2,32 no impacto), *mais rápido* só nas ações (7/8) — nunca "o DFM ganha da
  literatura" (identificação fixa compara DFM-contra-VAR-pequeno, não contra a
  literatura Cholesky). Redação proposta:
  `relatorio/working-notes/2026-07-31_benchmark_var_vs_dfm.md`.
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
  `relatorio/working-notes/2026-07-31_benchmark_var_vs_dfm.md`. A
  consequência textual (reescrever a introdução) já era moot em
  `texto_anpec/paper_anpec.tex` — ver item fechado em "Texto do paper" acima.
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
  `relatorio/working-notes/2026-07-31_estacionariedade_fatores.md`.
  Consequência: redigir a ressalva no §4/Limitações (item acima).
- [x] **Camada de citação estrutural — três correções — FEITO em 2026-08-01**
  (macro-theorist). Aplicado em `texto_anpec/paper_anpec.tex`: acelerador
  financeiro já citava `BERNANKE19991341` corretamente; a frase de
  Cooley-Quadrini (linha 419) foi reescrita para não atribuir a heterogeneidade
  setorial do crédito à dimensão patrimônio líquido/porte dos autores,
  nomeando-a margem distinta (crédito direcionado vs. livre); Castelnuovo-Nisticò
  reposicionado (linha 258) como argumento de identificação para incluir o
  Ibovespa entre os preditores predeterminados Bauer-Swanson. Compila limpo.
- [x] **`juros_selic` e `juros_cdi` não são evidências independentes — FEITO
  em 2026-08-01.** Divergem só no terceiro dígito significativo; citá-las
  revertendo juntas como confirmação cruzada seria erro. Aplicado em
  `texto_anpec/paper_anpec.tex:335`.

---

## B. Robustez estatística a fazer

- [ ] **Bandas simultâneas ao longo do caminho** (Montiel Olea-Plagborg-Møller
  2021) — *aberto em 2026-07-31.* Pedido pelo metodologista no council review, e
  o resultado da decomposição espectral do mesmo dia **eleva a prioridade**: se a
  reversão de médio prazo é dominada por **um único modo** da companion, os
  horizontes h≈20-40 são quase perfeitamente correlacionados entre si, e uma
  banda pontual horizonte a horizonte é especialmente enganosa para qualquer
  afirmação sobre a **trajetória** — que é exatamente o que o tier de 68% do §4
  faz (vale setorial, contração do crédito em h=24-32, reversão da curva).
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
  ξ_mp = 12,22. O próprio MOSW (nota 21) diz que o bootstrap deles "could be
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
- [ ] **Decomposição do wedge de UIP** — *aberto em 2026-08-10, council review
  (macro-theorist), **prioridade alta**: ataca diretamente a frase-manchete
  do resumo.* O paper afirma que o prêmio de risco soberano "domina o efeito
  convencional do diferencial de juros" (`:115`, `:344`, `:543`) sem nunca
  computar o wedge de UIP. Fazendo a conta com a própria IRF do paper
  (`output/irf/irf_coherence_h.csv`, T=48): Σ Δ(yield_6m)/12 ≈ −1,39pp
  (a trajetória de juros do próprio modelo vira negativa a partir de h≈22 e
  fica assim até o fim do horizonte); Δs₄₈ ≈ +1,19% (o câmbio não retorna à
  base, overshoot); Σ Δ(CDS)/12 ≈ −0,20pp. Sob a acumulação completa até
  h=48, o diferencial de juros contribui **depreciação**, não apreciação, e
  o prêmio soberano medido contribui **apreciação** — o oposto do sinal que
  o resumo atribui a cada termo. Truncando em h=7 (onde a resposta de juros
  ainda é positiva) restaura a leitura do paper, mas aí o CDS acumulado
  cobre só 1/31 do wedge necessário (≈3,9pp). Em qualquer dos dois recortes
  a palavra "domina" não se sustenta como está. **Correção:** tabela de
  decomposição com colunas T ∈ {6, 12, 24, 48}, linhas {Δs_T, −ΣΔi/12,
  +ΣΔrp/12 (CDS e EMBI), resíduo}, bandas tiradas dos 800 draws já salvos em
  `irf_coherence_cell.rds` — só pós-processamento, nada reestimado.
- [ ] **Corrigir a descrição do placebo `sp500_vix`** — *aberto em
  2026-08-10, council review (skeptic), achado factual rápido, mas que
  esvazia parte do argumento de §5.1.* O texto (`:501`, `:509`) descreve
  essa série como "o retorno do S&P 500 combinado à variação do VIX". Não
  é: `data/investing/sp500_vix.csv` é só o índice **VIX** (média 18,58, min
  9,51, max 53,54) — o painel **não contém nenhuma série de nível do S&P
  500**. Isso enfraquece o argumento de `:519` de que "uma surpresa fiscal
  brasileira também deixaria o S&P 500 parado" (não há S&P 500 para checar)
  e é exatamente onde o item de coincidência FOMC acima morde: um choque do
  Fed move o VIX intraday, mas o VIX é uma série que reverte à média — um
  pico de um dia se dissipa antes do fim do mês, enquanto um movimento do
  BRL em um dia não. Corrigir a descrição do placebo e, se possível,
  adicionar uma série de nível do S&P 500 ao teste ou remover o argumento
  de `:519` que depende dela.

### Fechados (contexto)

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
  item de máscara: os valores custam **0,21** de ξ_mp, a máscara re-derivada
  outros **2,50**. ⚠ O argumento de horário (comunicado às 14:00 ET, antes dos dois fechamentos)
  vale para a perna de **taxa** e **não** para a de ações. Nada em produção
  alterado — as 8 colunas `z_*` saíram bit-idênticas. Leitura completa em
  `relatorio/working-notes/2026-08-10_coincidencia_fomc.md`. Redação no paper:
  item aberto no Tema A.
  **⚠ O teste 4 (a divisão) saiu do script no mesmo dia**, junto com a terceira
  perna da regra de veredito, que ele alimentava. A perna **havia passado** e a
  cláusula de poder não foi acionada, de modo que retirá-la torna a regra
  estritamente mais permissiva e o veredito não pode ter mudado por causa do
  corte, o que foi conferido rodando o script antes e depois com `max |dif| = 0`
  em toda linha sobrevivente. **Nada do que esse teste produziu é reproduzível
  ou citável**, e a subseção de §5 do FOMC deve ser escrita sobre os testes 0 a
  3. Ver `historico_decisoes.md` §2.4 e o cabeçalho de
  `script/fomc_coincidence.R`.
- [x] **Bandas Anderson-Rubin — FEITAS em 2026-08-10.**
  `R/identification/weak_iv_ar.R` (a metade de `MSWfunction.m` que faltava; a do
  Wald pontual já era `compute_factor_space_wald`), `script/ar_bands.R` →
  `output/irf/ar_bands.{csv,md}` + `ar_bands_summary.csv` + overlay,
  `script/validate_mosw_ar.R` (limites vs. o código oficial: ≤ 9,5e-12,
  `casedummy` 0/63). **Conjunto limitado em 31.164 de 31.164 células** — é
  propriedade, não sorte: o coeficiente de λ0² **é** ξ_mp. **87 das 91 sig90
  sobrevivem**; prêmio de IV fraco = fator de escala comum **1,164** a 90%.
  ⚠ **As 4 perdas são 3 impactos do bloco de atividade** (§4.3) mais
  `cambio_eur` h3, e ⚠ **a banda AR é mais estreita que a de bootstrap (0,646)
  por condicionar em `Λ̂`** — não é resultado a favor. Apêndice metodológico
  completo (equação por equação vs. `codigos_externos/codigo_olea`) em
  `relatorio/working-notes/2026-08-10_bandas_anderson_rubin.md`. Redação no
  paper: item aberto no Tema A.
- [x] **Robustez do próprio ξ_mp — FEITO em 2026-07-27.**
  `script/xi_mp_robustness.R` → `output/instrument/xi_mp_robustness.{csv,md}`.
  **Leave-one-month-out** (DFM fixo): full ξ_mp 10,43 → min 8,43/máx 12,21;
  **0 de 147** descartes abaixo de 3,84 (conjunto AR sempre limitado), mas
  **24 de 147** abaixo de 10 (bandas convencionais são marginais). Contraste
  confirma a máscara: `z_jk_purif` fica 147/147 abaixo de 10. **HAC**: ξ_mp é
  **crescente** em NW no full (10,43 → 15,64 em NW(6)) — NW(0), o default, é a
  escolha conservadora. Validado em `script/validate_hac_kernel.R` contra
  `NW_hac_STATA.m` (exato) e `TaxSVARIV.m` (2,6e-10 em lag 8). Não feito: F
  efetivo de Montiel
  Olea-Pflueger e winsorização de `z` (encolheria a variação identificadora).
  Consequência: o item de Bandas Anderson-Rubin subiu de prioridade — e foi fechado em 2026-08-10 (item acima).
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

*(2026-07-27, revisto em 2026-08-01.)* O ramo GMR está implementado e
validado, e produziu um resultado que **não** é o que a rota foi buscar.
Registro completo em
`relatorio/working-notes/2026-08-01_robustez_identificacao.md` (a nota de
07-27, `relatorio/working-notes/2026-07-27_identificacao_nao_gaussiana_gmr.md`,
descreve a corrida antiga e carrega banner).

- [ ] **Decidir o enquadramento do GMR no paper.** O que sobrevive, e é o que a
  recomendação de 07-27 já dizia: usar o GMR como **teste**, não como estimativa
  concorrente. Duas afirmações são defensáveis porque nenhuma é de
  discriminação: (i) **não contradiz** — o ponto do proxy cai dentro do CI90 do
  GMR em **100% das 5.194 células**; (ii) **rejeita o esquema recursivo**
  (ξ = 149,3), que é a restrição que a literatura de menor dimensão impõe sem
  testar e conversa com o argumento anti-VAR-pequeno do paper. **Não** é
  defensável escrever "outra identificação independente dá a mesma direção" sem
  a ressalva do nulo. O estimador segue sem poder próprio: **1 célula sig90 em
  5.194**, e essa uma é a normalização; bandas ~5,4× mais largas que as do proxy.
  A rejeição assintótica da restrição do proxy (ξ = 122,9) continua
  **provavelmente espúria** — Prop. 4 cobre 0,79 contra 0,95 nominal em
  T = 150, n = 6.
- [ ] **Construir um teste com poder.** O gargalo agora é a régua, não o
  estimador: com 140 células e critério binário o q95 do nulo bate no teto em 3
  das 5 estatísticas. O fio mais promissor é a **razão de magnitude**, onde a
  coluna rotulada mais se separa (|log| 0,101 contra 0,776 da segunda melhor,
  p = 0,125). Um teste sobre o perfil de magnitude, e não sobre contagem de
  sinais, pode ter poder onde este não tem.
- [ ] **LMS (2017) como terceira leitura** — `svars::id.ngml`, ML paramétrico
  sobre a mesma premissa de não-gaussianidade. Se LMS concordar com GMR, a
  discordância é do proxy; se ficar no meio, é do método. É o desempate mais
  barato disponível.

### Fechados (contexto)

- [x] **Gate de não-gaussianidade em η — FEITO em 2026-07-27.**
  `script/nongaussian_gate.R` → `output/nongaussian/gate.md`. **3 de 6**
  componentes não rejeitam normalidade no full, **5 de 6** pré-COVID — a rota
  existe só no full sample e a identificação é **parcial**. **⚠ Armadilha:** o
  gate não pode reusar `output/irf/irf_coherence_cell.rds` — guarda só
  `irf`/`var_names`/`tcode`/`mpind`, não o objeto DFM; o script re-estima
  (barato, sem bootstrap). Detalhe: `historico_decisoes.md` §0.2.
- [x] **Ramo `identification = "nongaussian"` implementado — FEITO em
  2026-07-27**, branch `identificacao-nao-gaussiana`. GMR (2017) PML-ICA
  **traduzido para o repo** em `R/identification/nongaussian_gmr.R` (não usa
  `IdSS::estim.SVAR.ICA`, quebrado para n≥4 — `historico_decisoes.md` §0.1).
  Validação em `script/validate_gmr_ica.R` reproduz a aplicação publicada.
  Smoke test do proxy inalterado.
- [x] **Corroboração medida e testada contra nulo — FEITO em 2026-08-01.** GMR
  reestimado (`nboot=800`, `NG_STARTS=200`). Sob a coluna rotulada, sinal
  coincide em **0,971** das 140 células sig90 do proxy (**1,000** em
  curva/câmbio/preços; atividade é o único bloco abaixo, 0,733). **⚠ O nulo
  derruba isso como afirmação estatística:** 2.000 direções aleatórias dão
  concordância mediana **0,786** nas mesmas células, e 1/4 delas iguala a
  coluna rotulada (p=0,179) — no bloco da curva o nulo já é 1,000 por
  construção (normalizar em `yield_6m` força a curva a co-mover).
  **Concordância de sinal não é evidência de corroboração.** Nota:
  `relatorio/working-notes/2026-08-01_robustez_identificacao.md`.
- [x] **Coluna vice-líder inspecionada — resposta negativa — FEITO em
  2026-08-01.** Quatro regras de rotulagem que não usam `z`: R1/R2 escolhem a
  coluna 1 (concorda só 0,600, magnitude 1/5); R0/R3 escolhem a coluna 2. A
  coluna que melhor corrobora (3: 1,000 nas sig90) **nenhuma regra escolhe** —
  **a coluna monetária não é bem definida sem o instrumento neste painel.**
- [x] **Descartado por decisão do autor (2026-08-01): rodar o GMR num VAR
  pequeno.** Seria a rota com melhor chance de passar o gate (resíduos de
  observáveis quase não sofrem média cruzada), mas contradiria o argumento
  central do paper contra modelos VAR pequenos por maldição da
  dimensionalidade.

---

## D. Diagnósticos e comparações pendentes

- [ ] **Comparação cross-instrumento do IPCA sob (7,6)** — *destravado em
  2026-07-26; falta só a análise.* O argumento "a corcova é universal entre
  instrumentos e some pre-COVID" fecha o diagnóstico do price puzzle, mas foi
  construído no vintage e instrumento antigos e não reproduzia. A fonte
  (`output/irf/spec_sweep_irf_long.csv`) **já foi regenerada** junto com a
  migração da taxonomia — 320 células, 8 instrumentos, (7,6) e as duas janelas
  inclusos. Falta rodar a comparação e escrever o resultado; sem ele o §5.5 não
  pode afirmar que a corcova é amostral. Contexto novo do
  `irf_coherence_leitura.md`: a corcova vive em **h2-h8** e é o pedaço
  significativo (`price_ipca` sig90 em h5; `ex0` em h2 e h4-h8; `dw` em h4/h5/h7),
  **fora** da janela escorada h12-h48 — então o veredito `incoerente` do
  `price_core_ipca_ex0` é outra coisa (ele nunca volta a negativo no médio
  prazo), e a comparação tem que olhar h2-h8, não a janela da régua.
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
  p_boot = 0,005** no diário contra **nenhuma rejeição** em 252 células mensais.
  ⚠ O argumento (iii) da versão anterior deste item vinha do teste de três
  vias, **removido do script em 2026-08-10** (`historico_decisoes.md` §2.4), e
  não é mais citável. (i) e (ii) sustentam a reconciliação sozinhos.
  Ao escrever, **incluir a variável inconveniente**: o mesmo `b_1` diário dá IBOV
  +2,83% por 100bp, participação espectral 0,0015 — ações não identificadas
  naquele sistema. Fonte:
  `working-notes/2026-08-01_robustez_heterocedasticidade.md` §6.
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
  `relatorio/working-notes/2026-07-31_acoes_representacao.md`.

---

## E. Código e higiene

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
  2026-08-05.* ✅ **A regeneração foi feita**: `instrument_diagnostics_report.md`
  foi re-rodado em 2026-08-05 sobre as 106 séries e as 8 variantes vivas — zero
  linhas `z_het`, corpo corrente. ❌ **Falta o corte como tabela de paper.** O
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

- [x] **FECHADO em 2026-08-05 — `R/modeling/svensson_model.R` ficou sem
  consumidor** (aberto em 2026-07-26). Era o motor do `script/yield_curve.R`,
  apagado na mesma data — a curva do painel é o insumo fixo do orientador
  (`data/yields/yields_dia.csv`). O `source()` no `download.R` era chamada morta
  e foi removido; nenhuma das 7 funções do módulo é chamada em lugar nenhum.
  **Decisão: movido para `arquivo/R/modeling/svensson_model.R`** — a opção da
  convenção do repo para código não executado e não citado pelo paper. As ~600
  linhas continuam recuperáveis se a curva voltar a ser ajustada in-house. Ver
  `historico_decisoes.md` §4 e a entrada em `arquivo/README.md`.
- [x] **Taxonomia do `irf_spec_sweep.R` migrada para ξ_mp — FEITO em
  2026-07-26.** `classify_sweep_cells` classifica por `wald_mp` (limiares MOSW:
  `weak_xi_mp_severe`<3,84, `weak_xi_mp`<10); `f_factor` reportado mas não
  decide mais. 320 células regeradas, `wald_mp` conferido contra
  `mosw_strength_grid.csv`. Produção agora é `ok` em (7,6) full — o
  force-append da etapa 2 virou rede de segurança (ver item de seleção acima).
- [x] **Prosa do coherence separada do corpo gerado — FEITO em 2026-07-26.**
  Leitura interpretativa em `output/irf/irf_coherence_leitura.md` (manual, não
  tocada por script); `irf_coherence_report.md` é o corpo gerado, com aviso e
  ponteiro. Reescrita sob (7,6) — a versão de 2026-07-12 perdida no `fc0ef58`
  não foi restaurada.
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
  "falhar", e só toca `texto_anpec/` (o antigo `tex/` está arquivado em
  `arquivo/tex/` desde 2026-08-02 e não recebe mais escrita).
- **Higiene e re-runs de diagnóstico vão direto na `main`**: o bloco de higiene
  de 2026-07-26 (`run_all.R`, renomear `irf_mp_raw`, taxonomia por ξ_mp,
  separar a leitura do coherence) foi feito assim. Segue valendo para o placebo
  `commodity_metal` e a comparação cross-instrumento do IPCA.
