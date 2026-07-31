# Pendências

**Última revisão:** 2026-07-31. Só o que está **aberto**. O que foi tentado,
fechado ou revertido está em [`historico_decisoes.md`](historico_decisoes.md) —
consulte antes de propor um caminho novo.

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
| Força | ξ_mp = **10,43** full / **12,22** pre-COVID; conjunto AR limitado nas duas |

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

## Aberto — bloqueante para o paper

- [x] **Gate de não-gaussianidade em η** (2026-07-27). `script/nongaussian_gate.R`
  → `output/nongaussian/gate.md`. Resultado: **3 de 6** componentes não rejeitam
  normalidade no full, **5 de 6** pré-COVID. A rota existe só no full sample e a
  identificação é **parcial**. Correção: o gate **não** pode reusar
  `output/irf/irf_coherence_cell.rds` — aquele arquivo guarda só
  `irf`/`var_names`/`tcode`/`mpind`/..., não o objeto DFM; o script re-estima
  (barato, sem bootstrap). Detalhes em `historico_decisoes.md` §0.2.
- [x] **Ramo `identification = "nongaussian"`** (2026-07-27), branch
  `identificacao-nao-gaussiana`. GMR (2017) PML-ICA **traduzido para o repo** em
  `R/identification/nongaussian_gmr.R` + adaptador em `nongaussian_branch.R`;
  cinco costuras em `compute_irf_dfm` (switch de 3 vias, parsing do instrumento
  para rotulagem, despacho do ponto, esquema de reamostragem por ramo, bloco
  `ng_point`/`ng_boot`). **Não** se usa `IdSS::estim.SVAR.ICA`: o pacote está
  quebrado para n ≥ 4 e q = 6 cai em cheio — ver `historico_decisoes.md` §0.1.
  Validação em `script/validate_gmr_ica.R` reproduz a aplicação publicada do
  artigo (§3.2). Smoke test do proxy inalterado.
- [x] **Terceira passada: regra de dois níveis em §4 e §5** (2026-07-30).
  Por instrução do autor, a regra de 90% foi relaxada para a banda de 68%, "sem
  perder a honestidade quanto a afirmações de significância". A regra escrita e
  aplicada: 90% excluindo zero é resultado estatístico e recebe o adjetivo
  *significativo*; 68% excluindo zero entra como **direção e magnitude**,
  rotulada, e nunca é chamada de significativa; o resto é trajetória pontual com
  ressalva. Como o adjetivo ficou reservado, "significativo" sem qualificação
  sempre significa 90%. **Auditado**: as 15 ocorrências de "significativ" em
  §4-§5 estão todas em contexto de 90%.
  - **Por que a regra anterior era severa demais.** Ela escondia a cadeia de
    transmissão do próprio paper. São 92 pares a 90%, todos em h ≤ 12, contra
    **706 a 68%, distribuídos em U por todo o horizonte**: 32 no impacto,
    mínimo de 7 em h=13, segundo pico de 20-21 séries entre h=26 e h=32. Esse
    segundo pico é um bloco coerente, não ruído disperso.
  - **O que o §4 passou a dizer**, tudo rotulado como 68%: vale da atividade
    setorial em h=11-12 nas **seis** séries (1,5 a 2× o impacto), contração dos
    **sete** recortes de crédito entre h=24 e h=32 (construção −2,44% em h=29 é
    o vale mais profundo), desemprego +0,33 pp em h=35, população ocupada
    −0,69% em h=39, serviços −1,22% em h=31, e a reversão da curva **junto com
    a própria Selic mensal** (68%, h=25-44, vale −77,8 pb em h=34), com a
    ressalva de que a Selic é o controle negativo do desenho e o que ela mostra
    é a trajetória de política do modelo, não relevância do instrumento.
  - **⚠ O fato inconveniente foi escrito, não omitido:** o **IBC-Br não
    acompanha** o vale setorial. Seu mínimo é −0,50% em h=11 e o impacto é seu
    único horizonte com banda de 68%. O texto diz que o vale de transmissão
    está nas séries setoriais e não no agregado mensal.
  - **PIB saiu do §4** (instrução do autor: "na atividade econômica, fale do
    IBC-br e não o PIB"). É interpolado de dado trimestral e tem o menor
    `share_correct` do bloco (0,818 contra 0,955 do IBC-Br). Continua no painel
    de 106 séries e na tabela do anexo. **Isso evitou um erro de unidade:**
    `pib` é tcode 4 e volta de `impulse_responde.R:287` já em percentual, então
    a convenção `100/mean` usada para séries em nível o teria escalado errado
    por fator de ~7.
  - **`sec:alcance` foi eliminada.** Ela existia para justificar a parada em
    h=12, que a nova regra dispensa. Os dois fatos que carregava foram para
    Limitações, e o segundo mudou de papel: a razão mediana
    |ponto|/(meia-banda de 68%), que aproxima |t|, vale 0,87 no impacto, cai a
    0,66 em h=12 e **atinge o máximo de 1,07 em h=24** (1,00 em h=36), contra
    os 1,645 que uma banda de 90% exigiria. O médio prazo não é sinal que some,
    é sinal cujo |t| trava em torno de 1. O diagnóstico passou de proibir o
    médio prazo a licenciá-lo. `fig_significancia.pdf` foi removida junto.
  - **Placebos agora reportam as duas barras** (90%: 1/49, 0/49, 0/49; 68%: 3,
    0, 2 = 5 de 147 contra os ~47 de um nível nominal de 32%). Reportar só a
    barra em que passam com folga seria escolher a régua.
  - **Figuras: oito, todas até h = 36, sem área cinza.** `fig_section5.R` teve
    `H_MAX` 24 → 36 (o material de 68% que o texto cita agora é visível), o
    `annotate("rect")` de h > 12 removido, e duas grades recompostas para que
    toda série citada tenha painel: `fig_atividade` ganhou `ibc_br` e
    `vendas_servicos` (8 painéis, 4×2), `fig_credito` ganhou
    `credito_construcao` (7 painéis). Marcadores laranja continuam só para 90%.
    **Única área cinza que sobrou** é a de `fig_estado.pdf`, que mantém eixo
    próprio 0-24 (`H_T7`) e sombreado em h > 8 marcando a faixa estimada mas
    não testada. Auto-teste agora cobre h = 0..36 em 47 de 48 séries plotadas.
  - Compila limpo: 28 páginas, zero `Citation undefined`, zero
    `Reference undefined`, **zero overfull/underfull hbox**, 25 chaves citadas
    (inalterado).

- [x] **Converter o §5 para o tex** (2026-07-29). A `\section{Resultados}` de
  `tex/main.tex` foi escrita, com **9 figuras, uma por subseção, todas até
  h = 24**, hoje repartidas entre §4 Resultados (6, uma por subseção) e §5
  Robustez (3: significância, estado e placebos). Compila limpo, zero `Citation undefined`, zero
  `Reference undefined`, 29 páginas.
  **Nenhuma referência nova:** o conjunto de chaves citadas é idêntico ao de
  antes da edição (25), por instrução do autor.
  - **Sem tabelas, por instrução do autor.** A primeira versão usava 6 tabelas;
    elas foram substituídas por figuras e toda magnitude passou para a prosa,
    sempre com o intervalo de 90%. As figuras saem de `script/fig_section5.R`,
    que lê `irf_coherence_cell.rds` e **não reestima nada**, marca em laranja os
    horizontes com banda de 90% excluindo zero e sombreia h > 12. Legenda no
    padrão ABNT: título curto em cima (`\caption`), nota longa embaixo
    (`\nota`).
  - **Auto-teste do script:** reconstrói as flags de sig90 a partir das matrizes
    `ci90` e verifica contra `irf_coherence_h.csv` em h = 0..24, ponto a ponto,
    nas 44 séries escoradas que plota. A 45ª (`commodity_agro`) está no painel
    de 106 mas fora da régua de 53, e é por isso que a flag é reconstruída em
    vez de lida do CSV.
  - **`H_EST` da Tarefa 7 subiu de 12 para 24** só para alimentar a figura de
    dependência de estado. `H_TEST` continua em 8 e o bootstrap conjunto roda
    sobre `HS = 0:8`, então **nenhum p-valor mudou** — conferido: W = 53,85 e
    p_boot = 0,0456 idênticos antes e depois. A figura sombreia h > 8 como
    faixa estimada e não testada.
  - **⚠ O critério de entrada mudou o conteúdo, não só o formato.** Por
    instrução do autor, entra no corpo só o que exclui zero a 90%. São **92 de
    2.597** pares variável-horizonte (3,5%), e **todos em h ≤ 12** — 87 em
    h ≤ 8, **zero** nos 1.908 pares com h > 12. O §5 cobre h=0 a h=12 e declara
    isso como resultado, não como ressalva.
  - **Segunda passada, 2026-07-29 (quatro mudanças pedidas pelo autor):**
    1. **Intervalos de confiança saíram da prosa.** As figuras já carregam as
       duas bandas. Sobrou **um** intervalo no texto, o do Ibovespa, porque ali
       a imprecisão é o resultado, e o texto diz isso explicitamente.
    2. **Nova `\section{Robustez}` (§5, `sec:robustez`)** com cinco subseções:
       `sec:alcance` (alcance estatístico), `sec:exogeneidade`, `sec:estado`
       (dependência de estado), Placebos e Limitações. O §4 Resultados ficou com
       seis subseções: curva, câmbio, atividade, crédito, preços, ações.
       Escolhi seção de robustez em vez de anexo porque o `anexosenv` do
       abntex2 é `\chapter`-level e está reservado à tabela de variáveis, e
       porque a dependência de estado é resultado, não apêndice.
    3. **O parágrafo de exogeneidade saiu do §4.2** e virou `sec:exogeneidade`.
       Os dois painéis de commodity ficaram na `fig:cambio` com uma frase curta
       apontando para lá.
    4. **Os 8 blocos comentados `% [NÃO SIGNIFICATIVO]` foram promovidos** para
       frases rotuladas "Na banda de 68%, ...", 7 deles. O oitavo (leitura de
       Bonomo-Martins sobre crédito direcionado) foi descartado por não ter
       citação disponível no texto. Não restou nenhum bloco comentado no `.tex`.
  - **⚠ Três erros dos blocos comentados descobertos na promoção**, todos
    corrigidos no texto e verificados em `irf_coherence_h.csv`:
    (i) a "cronologia de reversão de câmbio/EMBI/CDS" **não inclui o câmbio** —
    `cambio_usd` tem sig68 só em h=0-5 e nenhuma reversão significativa; EMBI
    (h18-32) e CDS (h18-31) revertem, o câmbio não;
    (ii) `trab_pop_ocupada` é **sig68 positiva no impacto** (+91,9), contra a
    previsão, fato que o bloco comentado omitia;
    (iii) `credito_construcao` (−0,32) e `credito_industria_total` (+0,19) são
    ambos sig68 no impacto, com sinais opostos — a indústria expande junto com
    agro e transporte, a construção já contrai.
  - **O que entrou como 68% rotulado:** reversão da curva (vale −78,8 pb em h=32
    no vértice de 3m, −61,1 em h=26 no de 2a, −41,7 em h=22 no de 10a);
    reversão de EMBI e CDS; IBC-Br e serviços no impacto, desemprego (+0,33 pp
    em h=35), população ocupada e PIB; contração agregada do crédito nos cinco
    saldos e as duas fases do spread ICC; a desinflação do núcleo ex1 (h21-h22)
    com a ressalva de que a difusão **não** alcança 68% na queda; e o bloco de
    ações em h=1, onde **7 dos 8 índices** separam de zero (só o IMAT não).
    Ficou de fora `ind_automoveis`, série estreita demais para o corte.
  - **Cinco afirmações do `irf_section.md` que não sobreviveram**, todas
    verificadas em `irf_coherence_h.csv`: (i) "a desinflação vive no núcleo ex1 e
    no índice de difusão" — ex1 tem **0** células sig90 (3 sig68) e difusão tem
    **0** (1 sig68, e ele está em h=5, na corcova, não na desinflação); **nenhuma
    medida de preço tem resposta negativa significativa em horizonte nenhum**;
    (ii) bloco de ações — **0 de 392** células sig90; (iii) contração agregada do
    crédito — **0** células sig90 no saldo total, PF, comércio, construção,
    indústria e nos dois spreads ICC, restando só as expansões de agro (h0-h3) e
    transporte (h0-h1); (iv) toda a cronologia de reversão pós-h≈17 é CI68;
    (v) desemprego, PIB, IBC-Br, serviços e automóveis, todos sem célula sig90.
  - **O que ficou mais forte:** a cadeia câmbio → IPP → núcleos é inteiramente
    sig90 e em ordem temporal correta (câmbio h0-h4, IPP h0-h4, consumidor
    h4-h8). Reenquadra a corcova como repasse cambial por custo em vez de
    anomalia pura de VAR, e é um argumento que só aparece ao olhar apenas o que
    tem banda.
  - **Substituições de citação** forçadas pela regra de não acrescentar
    referências: Kuttner/Gürkaynak-Sack-Swanson → `gertler2015` + `alessi`;
    Blanchard (2004) → `goncalves2025`, que enuncia e rejeita a hipótese;
    Gertler-Gilchrist/Bernanke-Gertler/Bonomo-Martins → `Cooley` + `gertler2015`;
    Sims/Ramey/Minella → `jarocinski2020`. O mecanismo de saque de linhas
    pré-aprovadas ficou **sem atribuição**, declarado como interpretação.
    A ressalva de Jentsch-Lunsford **não entra no §5** por exigir referência
    nova; segue no item próprio, destinada ao §3.
  - **Erro de unidade corrigido na passagem:** o `irf_section.md` reporta
    `commodity_metal` como "+10,4% no impacto". São **+10,41 pontos de índice**
    sobre média de 303,3, ou **+3,43%**. O `diagnostico_dfm.md` dá +3,98% porque
    mede no painel aumentado com nboot=200, que é estimação diferente. O §5 usa
    os dois com procedência declarada e não os mistura na mesma tabela.
- [ ] **Abstract, Introdução e Conclusão** — rewrite completo. Os sinais e
  magnitudes são da era Cholesky e a Conclusão promete "instrumento de alta
  frequência como pesquisa futura", que hoje é o coração do paper. Roteiro:
  §5.7 do `irf_section.md`.
- [x] **Revisão de literatura — eixo de identificação** (2026-07-28). A §2 do
  `tex/main.tex` foi **reescrita inteira** (não acrescentada): abre pelos dois
  problemas que separam as estimativas (conjunto de informação e identificação
  do choque) e percorre não-fundamentalidade → FAVAR/DFM → Alessi-Kerssenfischer
  → Mertens-Ravn (2013) → Stock-Watson (2018) → Gertler-Karadi (2015) →
  Jarociński-Karadi (2020) + Bauer-Swanson (2023) → Montiel Olea-Stock-Watson
  (2021) → GRG (2025) → posicionamento. ~1.500 palavras, 11 parágrafos. O bloco
  comentado que duplicava a seção antiga (antigas linhas 189-205) foi apagado.
  Duas entradas novas no `references.bib`: `goncalves2025` (IMF WP/25/48,
  fev/2025) e `bagliano1998` (*EER* 42, 1069-1112 — atenção, a pasta em
  `artigos/` grafa "baglio", o autor é **Bagliano**). Compila limpo, zero
  `Citation undefined`.
  - **Fora por decisão do autor:** Bonomo-Martins (2016) para crédito
    direcionado e Blanchard (2004) para dominância fiscal seguem pendentes de
    escrita. O eixo sem instrumento (GMR 2017, LMS 2017,
    Angelini-Cavaliere-Fanelli 2024) ficou de fora **de propósito**, esperando a
    decisão de enquadramento do GMR registrada na seção acima.
  - **⚠️ Contradição interna criada:** a §2 afirma, corretamente, que a
    estimativa deste trabalho **diverge de GRG no sinal do câmbio**, enquanto o
    resumo (linha 163) ainda diz "apreciação de 8%", da era Cholesky. Os dois
    não podem coexistir na versão compilada. Resolve-se no item de rewrite do
    resumo abaixo.

### Estado do `main.tex` (§3 já migrado)

Auditado contra a working tree em 2026-07-26. As quatro correções herdadas do
antigo `_instrucoes/prompt.md` (arquivado na mesma data) **já estão aplicadas** —
o `prompt.md` descrevia o tex do `HEAD`, não o do disco:

- [x] **§3.4** — a frase sobre preditores predeterminados foi expandida e agora
  explicita que é a variante fiel às duas metodologias de origem (BS predeterminado
  + regra de sinal JK com agregação por soma).
- [x] **§3.5** — a frase "(6,5) é o único acima de 10 na janela pré-COVID, com
  12,49" **foi removida**. O texto atual traz $(7,6)$ com **10,43 full / 12,22
  pré-COVID** e a tabela `tab:rq_sweep` foi reescrita com as três estatísticas
  MOSW (ξ_mp, Wald conjunta, forma-F) × duas janelas.
- [x] **§3.5** — a frase sobre a correção de Kilian está **correta**, pode ficar.
  Verificado no código em 2026-07-26: `factor_estimation.R:759` estima o ponto
  sempre por VAR OLS puro (fiel a `DFMest_BLL.m`) e só calcula os coeficientes
  corrigidos quando `apply_kilian = TRUE`, usados apenas no DGP do bootstrap
  (`impulse_responde.R:436`); cada réplica do bootstrap re-estima com
  `apply_kilian = FALSE`.
- [x] **§3.6** — o segundo parágrafo e a frase sobre reproduzir os números
  publicados de Olea et al. (2021) para o choque de petróleo de Kilian foram
  comentados. (A validação continua no repositório em
  `script/validate_olea_kilian.R`; só não vai ao corpo do texto.)

O que **continua aberto** no tex (o §5 saiu desta lista em 2026-07-29):

- [ ] **§3.2** diz "cerca de 110 séries"; o painel tem **106** desde o refresh de
  vintage de 2026-07-24. Trocar pelo número exato.
- [ ] **Resumo, introdução e conclusão** seguem da era Cholesky — ver o item de
  rewrite acima. A revisão de literatura foi reescrita em 2026-07-28.
- [ ] **⚠ O resumo agora contradiz o §5, e não só a §2.** Com a seção de
  resultados escrita, a versão compilada afirma três coisas incompatíveis entre
  si. O resumo (linha 163 do `main.tex`) diz "apreciação de 8\%" e "queda
  imediata de aproximadamente 3\% no mercado acionário"; a §2 e o §5 reportam
  **depreciação** de 3,64% com banda de 90%; e o §5 mostra que **nenhum** dos
  oito índices de ações separa de zero a 90% em horizonte nenhum, com impacto do
  Ibovespa de −1,67% e IC90 [−7,77; +1,76]. Há um bloco `% TODO` no `.tex`
  imediatamente acima do resumo registrando os dois pontos. **Resolver antes de
  qualquer circulação do PDF** — é o item mais visível da lista.

## Aberto — achados do council review de `tex/main.tex` (2026-07-31)

Revisão paralela de três críticos independentes (harsh-referee e macro-theorist
em Claude Opus, methodologist via Gemini 3.1 Pro como par cross-vendor) sobre o
estado atual — **não commitado**, ver `git diff tex/main.tex` — do texto.
Veredito da síntese: **Major Revision**, não Reject: os dois problemas de
aparência mais fatal (sem benchmark VAR, sem bandas AR) são trabalho não feito
com ferramenta já pronta no repo, não defeito estrutural. Relatório completo,
com as três críticas cruas, em `relatorio/council_2026-07-31.md`.

- [x] **Identificação: o filtro JK pode estar selecionando risco soberano —
  TESTADO E NÃO CONFIRMADO em 2026-07-31.** `script/jk_sovereign_confound.R` →
  `output/instrument/jk_sovereign_confound.{csv,md}`, `jk_sovereign_days.csv`,
  `jk_sovereign_irf_overlay.pdf`. Nota:
  `relatorio/working-notes/2026-07-31_confound_soberano_jk.md`. **Nada de
  produção foi modificado** — as variantes de três vias são construídas em
  memória; três auto-testes (painel reconstruído, ξ_mp 10,43/12,22, smoke test
  h0 do `CLAUDE.md`) passam exatos.
  - **A acusação aponta ao contrário do dado.** Regra de leitura fixada *antes*
    dos números: contaminação exige que o dia retido carregue **mais** risco por
    unidade de surpresa que um dia comum. Num dia comum (498 quintas não-Copom)
    ΔEMBI carrega a surpresa com coef **0,326** (t = 3,97, R² 0,13); nos **62
    dias retidos** cai para **0,099** (t = 1,74, R² 0,04); no câmbio o controle é
    0,051 (t = 4,64) e os retidos 0,004 (t = 0,40). As interações
    `x:1(jk_bs)` são **negativas** nas quatro proxies da janela do evento — EMBI
    −0,182 (p_boot 0,108), **BRL −0,036 (p_boot 0,066**, apreciação relativa =
    assinatura de UIP), slope −0,228, DI 10a −0,616. A camada BS + máscara JK
    **empobrece** o conteúdo de risco.
  - **⚠ Pré-requisito que quase virou armadilha: o alinhamento do EMBI.** O
    arquivo é painel JP Morgan republicado pelo BC dominicano. Correlação de
    Δ EMBI com o mercado em t / t−1 / t+1: S&P −0,498 / −0,045 / +0,060; VIX
    +0,413 / −0,007 / −0,109; Ibov −0,508 / −0,088 / +0,016. **É do mesmo dia.**
    Logo a janela Qui→Sex (interação **+0,248, p_boot 0,025**) não é correção de
    alinhamento: é a resposta **defasada** do risco à surpresa, que é o que a IRF
    mensal já reporta. Sem esse diagnóstico o resultado teria sido lido como
    contaminação.
  - **Classificação de três vias (política/soberano/informação):** terceira via
    pelo sinal do câmbio purificado na mesma RHS pré-evento do BS. Os 62 partem
    em **31 política / 30 soberano / 1 n/c** (regra FX; 24/37/1 pela do EMBI).
    ξ_mp cai a 3,52 e 3,50 — queda mecânica, meses não-nulos vão de 62 para ~30.
    **Nenhum sinal inverte.** A metade soberana tem respostas maiores de risco e
    câmbio, a política menores (h=0: `embi_perc` 0,270 vs 0,103; `cds_5y` 36,5 vs
    18,9; `cambio_usd` 0,165 vs 0,129), mas a metade política perde sig90 com n
    pela metade, indistinguível de perda de potência.
  - **O achado mais forte.** Os 31 dias "política" foram selecionados por terem,
    **no dia do evento, apreciação do BRL**. A IRF mensal desses mesmos dias
    ainda dá **depreciação** (+0,129, 86% da magnitude da produção). A
    depreciação do §4 **não é herdada da janela do evento** — é propagação
    mensal, não seleção de dias. O desenho tornava isso falsificável.
  - **Ortogonalização ao risco diário** (limite inferior, pois política move
    spread legitimamente): ξ_mp **10,72** full (acima dos 10,43 da produção),
    8,18 pré-COVID; todas as manchetes seguem sig90, atenuação de 15-20% no bloco
    de risco e ~nenhuma no câmbio.
  - **⚠ A ressalva que fica, e deve ir ao paper.** Concentração alta: os 5 dias
    de maior alavancagem valem **28,6%** de Σ|z|, e o **maior deles (6,6%) é
    2021-10-27 — a semana da PEC dos Precatórios**, com o BRL depreciando 1,97%
    apesar de alta de 150 pb, classificado "soberano". O teste agregado não
    detecta enriquecimento sistemático, mas o dia individualmente mais influente
    é exatamente o tipo que o parecerista temia.
  - **O que NÃO foi mostrado:** que o instrumento é livre de risco soberano. A
    afirmação defensável é mais estreita — *o filtro JK não seleciona risco
    soberano para dentro; seleciona menos risco que um dia comum.*
  - **Lacuna declarada:** não há CDS 5a **diário** no repo nem fonte
    programática gratuita com histórico 2013-2025 (Ipeadata encerrou o EMBI+ em
    07/2024 e nunca teve CDS; WorldGovernmentBonds sem CSV/API; MacroMicro é
    semanal; cbonds é pago). Única fonte diária: página histórica da
    Investing.com, export por navegador. O script detecta
    `data/investing/cds5y_daily.csv` sozinho se o arquivo aparecer.
  - **Aberto daqui:** a redação da subseção de robustez, que virou **item próprio
    logo abaixo**. Promover a classificação de três vias à produção **não** é
    recomendado: custa metade da amostra e não muda sinal nenhum.

- [x] ~~**Identificação: o filtro JK pode estar selecionando risco soberano, não
  choque de política monetária — item mais grave do review.**~~ *(fechado acima
  em 2026-07-31; texto original preservado para procedência.)* Os três críticos
  chegaram lá por ângulos diferentes. O harsh-referee lê a constelação de
  respostas (repasse de 1,85x na ponta longa, depreciação de 3,64%, abertura de
  CDS e EMBI, inflação de núcleo positiva) como assinatura de prêmio de risco
  soberano, não de política monetária. O macro-theorist faz o ponto lógico mais
  afiado: o filtro JK descarta o confound benigno (efeito-informação do BC:
  juros para cima, ações para cima) mas uma surpresa fiscal/soberana doméstica
  tem juros para cima, ações para baixo, câmbio para cima — **exatamente o
  padrão que o filtro retém como "política"**. O metodologista chega pelo dado:
  GRG (2025) encontra apreciação e CDS estagnado em alta frequência, sinal
  oposto ao deste trabalho. Os placebos não descartam essa hipótese específica
  (um choque fiscal doméstico também não deveria mover o S&P 500). E o próprio
  §5 comentado (`sec:estado`, item "Dominância fiscal" abaixo, já rodado)
  mostra evidência **contra** a leitura de dominância fiscal que o texto ativo
  assume: o câmbio no impacto não é dependente de estado de risco soberano em
  nenhum dos 7 indicadores testados (t ≤ 1,14 em módulo) — essa ressalva nunca
  foi lida em conjunto com este risco de identificação. **Teste barato e
  decisivo:** regredir a variação Qua→Qui do CDS de 5 anos e do EMBI no
  instrumento, restrita aos ~62 dias retidos pelo filtro JK. Coeficiente
  significativo = contaminação na frequência diária, antes de qualquer DFM.
  Complementar com auditoria narrativa dos 62 dias contra notícia
  fiscal/política (teto de gastos, arcabouço fiscal, PEC da guerra) e
  considerar uma classificação de três vias (política / risco soberano /
  informação) em vez de duas.
- [ ] **Escrever a subseção de robustez sobre o confound soberano** — *aberto em
  2026-07-31, consequência direta do item fechado acima.* Os números existem e
  estão conferidos; falta só a redação. **Depende do item "§5 Robustez está
  inteira comentada" abaixo**: hoje a `\section{Robustez}` inteira está comentada
  em `tex/main.tex:447-500` com quatro subseções (`sec:exogeneidade`,
  `sec:estado`, Placebos, Limitações), então esta entra como **quinta**, e ou
  sobe junto quando a seção for reativada, ou fica comentada com as outras.
  - **Onde:** depois de `sec:exogeneidade` e antes de `sec:estado` — é
    exogeneidade do instrumento em frequência diária, e `sec:estado` já pressupõe
    que a leitura de risco soberano foi endereçada. Label sugerido
    `sec:confound`.
  - **A ordem do argumento, que não pode ser embaralhada:** (i) enuncia a
    acusação — o filtro JK descarta o efeito-informação (juros ↑, ações ↑) mas a
    assinatura fiscal doméstica (juros ↑, ações ↓, câmbio ↑) é a que ele retém, e
    os placebos não a descartam porque um choque fiscal doméstico também não move
    o S&P 500; (ii) o **controle não-Copom**, que é o que dá sentido ao
    coeficiente; (iii) a **interação negativa**; (iv) a concentração em
    2021-10-27.
  - **Números a usar** (fonte: `output/instrument/jk_sovereign_confound.csv`;
    leitura em `relatorio/working-notes/2026-07-31_confound_soberano_jk.md`):
    ΔEMBI sobre a surpresa dá **0,326** (t = 3,97, R² 0,13) nas 498 quintas
    não-Copom contra **0,099** (t = 1,74, R² 0,04) nos 62 dias retidos; câmbio
    0,051 (t = 4,64) contra 0,004 (t = 0,40). Interação `x:1(jk_bs)`: EMBI
    −0,182 (p_boot 0,108), **BRL −0,036 (p_boot 0,066)**, slope −0,228, DI 10a
    −0,616. Três vias: **31 política / 30 soberano**, nenhum sinal inverte,
    `cambio_usd` h0 = 0,129 na metade política contra 0,150 da produção.
    Ortogonalização ao risco diário: ξ_mp **10,72** contra 10,43, manchetes
    todas sig90.
  - **A frase que carrega a subseção:** os 31 dias "política" foram selecionados
    por terem **apreciação do BRL no dia do evento**, e ainda assim a IRF mensal
    deles dá **depreciação** — a depreciação do §4 é propagação mensal, não
    seleção de dias. É falsificável por construção e não inverteu.
  - **As duas ressalvas são obrigatórias no corpo**, não em nota: o coeficiente
    nos 62 dias é positivo e marginal (p = 0,097), então a afirmação é "menos
    risco que um dia comum", **não** "zero risco"; e os 5 dias de maior
    alavancagem valem **28,6%** de Σ|z|, sendo o maior (6,6%) **2021-10-27, a
    semana da PEC dos Precatórios** — BRL depreciando 1,97% apesar de alta de
    150 pb.
  - **Declarar a lacuna do CDS diário** em uma frase: o teste roda em EMBI+
    diário porque não há CDS 5a diário disponível, e dizer que a proxy é o EMBI.
  - **Figura.** `output/instrument/jk_sovereign_irf_overlay.pdf` tem 9 painéis —
    demais para o corpo. Cortar para **quatro** (`cambio_usd`, `embi_perc`,
    `cds_5y`, `yield_2y`) e gerar em `tex/img/` seguindo a convenção das outras:
    ou um bloco novo em `script/fig_section5.R`, ou um `fig_confound.R` irmão.
    Legenda ABNT — `\caption` curto em cima, `\nota` longo embaixo.
  - **Sem referência nova.** A regra de 25 chaves se mantém: bastam
    `jarocinski2020` e `bauer2023`, já citadas.

- [x] **Benchmark VAR RODADO E REPORTADO em 2026-07-31 — e a frase da introdução
  fica metade sustentada, metade refutada.** `script/model_var.R` reescrito como
  driver, motor extraído para `R/modeling/var_proxy.R`, saídas em
  `output/var/var_benchmark.{md,...}` (3 CSV + 4 PDF). Nota:
  `relatorio/working-notes/2026-07-31_benchmark_var_vs_dfm.md`.
  - **⚠ "A ferramenta já está pronta no repo" era falso.** O `model_var.R` do
    disco (commit `9d8fa3d`, 2026-03-18) **não rodava**: `compute_irf_var_proxy`
    chamada com `var_data=`/`p_var=` ausentes da assinatura; corpo esperando
    `vars::VAR` e recebendo a lista de `var_est_ols`; e `producao_transformacao`,
    que não existe no painel. Mais: normalizava em `juros_selic`, truncava em
    2024-12, passava `tcode = NULL` e não gravava nada. **As peças de baixo nível
    eram tradução fiel e ficaram intactas** — quebrou só a cola.
  - **Ler `codigo_alessi-mark/MAIN_VARloop.m` antes mudou o desenho.** O core de
    AK é `{atividade, preços, taxa de médio prazo}` com **a taxa como alvo de
    normalização** (`RUN_MAIN_US.m:7-9`, `opts.mpind = corevars(3)`); AK **nunca**
    normaliza em overnight, o que fecha a questão do `juros_selic` por fidelidade
    e não só por força. `tcode` vai subsetado à identificação (`:28`); a `varlist`
    é a lista de ativos, **sem vértices de curva**; e a figura é VAR à esquerda /
    DFM à direita com **`linkaxes`** (`MAIN_plotfigs.m:1-46`) — o eixo y comum é o
    que torna a comparação visível em vez de afirmada.
  - **⚠ A régua inicial estava errada, e foi a figura que denunciou.** O extremo
    global do DFM tem sinal **oposto** ao do impacto em **8 das 18** respostas —
    exatamente as 8 ações, que viram positivas por volta de h=5 e chegam a +20 em
    h≈24 enquanto o VAR pequeno segue negativo. "18 de 18 mais forte, razão 2,51"
    comparava alta de médio prazo com queda. Trocada por **razão de impacto** (o
    mesmo objeto, sinal concordante em 18/18) + **pico de mesmo sinal**.
  - **Veredito com a régua corrigida.** *Mais forte* **se sustenta**: 16 de 18,
    razão mediana **2,32** no impacto e **1,61** no pico de mesmo sinal — fator de
    1,6 a 2,3, não ordem de grandeza. Exceções na tabela: `asset_imat` (0,487) e
    `price_core_ipca_ex0` (0,562). *Mais rápido* **só nas ações**: 7 de 8 (pico do
    DFM em h=1 contra h=3-9 do VAR), contra **9 de 18** no conjunto — moeda ao ar.
  - **O preço, que o texto tem de assumir:** a banda de 68% do DFM **nunca** é
    mais estreita no impacto (0 de 18, razão mediana **4,35**), e o placar de
    significância é o inverso da palavra "stronger": **37 células sig90 no DFM
    contra 266 no VAR**; nas ações, **0 contra 132**. O resultado nulo do bloco
    acionário é do modelo **grande**.
  - **O argumento mais forte pró-DFM não é nenhum dos dois** — é o diagnóstico do
    próprio AK (`MAIN_plotfigs.m:49-71`): as respostas **core** do VAR pequeno
    variam entre especificações **mais do que a própria magnitude**
    (`ind_transformacao` em h=0 tem amplitude 0,952 contra mediana −0,746;
    `price_ipca` **inverte de sinal**; `yield_6m` em h=12 varia 63% da mediana). E
    o VAR que carrega `ibc_br` é **explosivo** (max |λ| = 1,008), 25 parâmetros
    por equação em 147 observações.
  - **O que NÃO foi mostrado:** que o DFM ganha "da literatura". Com a
    identificação fixa nos dois lados isto compara **DFM contra VAR pequeno**; a
    literatura de menor dimensão usa Cholesky. Sustentar `tex/main.tex:183` como
    está exigiria uma variante recursiva — decisão do autor foi não fazer.
  - **Aberto daqui: reescrever `tex/main.tex:183`.** Redação proposta na nota.
    Bloqueado pelo item "§5 Robustez está inteira comentada".
- [ ] **§5 Robustez está inteira comentada no working tree, e duas passagens
  ativas ficaram penduradas.** A linha 365 (ativa) afirma que o índice de
  commodities metálicas do BCB sobe 3,43% com banda de 90% até h=4, mas a frase
  que descarta a leitura de falha de exogeneidade — a versão em dólar não
  responde em horizonte nenhum, já testado em `diagnostics/01_exogeneidade.R`
  §1.6 — está comentada na mesma linha. Como compilado, isso lê como falha de
  exogeneidade sem resposta. A nota da `fig:acoes` (linha 436) promete uma
  discussão "no texto" que também está comentada. As referências
  `\autoref{sec:exogeneidade}` e `\autoref{sec:estado}` **não estão quebradas**
  — todo uso e a própria `\label` estão comentados juntos, então não há erro de
  compilação (checado via `grep`, corrigindo um sub-achado do metodologista que
  afirmava o contrário) — mas o conteúdo de defesa que o corpo ativo pressupõe
  existir não está visível para quem lê o PDF. Reativar a seção (o conteúdo já
  está escrito) ou reescrever as duas passagens ativas para não depender dela.
  **A subseção nova do confound soberano (item acima) depende deste:** ela entra
  como quinta subseção e não faz sentido escrevê-la numa seção comentada.
- [x] **Raiz unitária, cointegração e espectro da companion — FEITO em
  2026-07-31, e o referee está certo no que importa.**
  `script/factor_stationarity.R` → `output/factors/` (5 CSV + `.md`). Nota:
  `relatorio/working-notes/2026-07-31_estacionariedade_fatores.md`.
  - **Metade já existia e ninguém tinha juntado com a outra.** A Tarefa 5 de
    07-28 (`t5_1_autovalores.csv`, `diagnostico_dfm.md:439-459`) já reportava os
    cinco maiores módulos e já concluía "a corcova é mecânica". Faltava: testes
    **nos fatores** (o `t5_4` testa as 106 séries do painel), **PP**,
    **cointegração**, e o espectro completo com argumento e período em CSV.
  - **Fatores:** 4 de 7 I(1) em nível (F2, F4, F5, F6), 2 I(0) (F1, F7), 1
    ambíguo (F3). **Nenhum é I(2)** — ADF *e* PP rejeitam a raiz unitária nas
    sete primeiras diferenças; os três "ambíguos" em diferença são só o KPSS
    rejeitando junto, comportamento conhecido dele em T=150. **PP concorda com
    ADF em 14 de 14.** No painel, PP rejeita em 38 de 106 e os três testes
    concordam em I(1) em **56 séries**. Painel misto é o desenho (AK §2.1).
  - **Cointegração existe, o posto não é identificado:** traço dá **2** em K=6, 1
    em K=4, **4** em K=2; sob Reinsel-Ahn `(T−nK)/T = 0,714` vai a **0**. **Sob
    qualquer um deles o VAR em nível é consistente** — Sims-Stock-Watson (1990),
    que é literalmente a defesa escrita na §2.2 de AK, mais BLL (2016b), que
    mostram o VAR em nível **superando** o VECM em IRF de curto prazo. Chaves já
    citadas (`barigozzi2016non`, `alessi`): **nenhuma referência nova**.
    **VECM não será estimado** (decisão do autor, e a evidência reforça: o posto
    não é preciso o bastante para escolher a restrição).
  - **Espectro:** par dominante **complexo**, |λ| = **0,976794**, período
    **117,9 meses** → quarto de ciclo 29,47, meia-volta 58,95, meia-vida 29,52.
    Duas raízes > 0,97, seis > 0,90, **nenhuma explosiva**. **A quase-raiz
    unitária não vem de `p`:** em p=1 o módulo máximo é **maior** (0,982).
  - **⚠ O achado que muda o §4, e a ordem em que foi obtido está declarada.** Só
    o teste de coincidência era pré-registrado (R1): deu **10 de 14** extremos de
    médio prazo dentro de ±25% do quarto de ciclo — sugestivo e nada mais. Os
    dois testes seguintes foram escritos **depois**. (i) Reestimar em p ∈ {1,4,6}
    **absolveria**: o vale existe nos três, inclusive em p=1 onde a dominante é
    real, e a mediana do horizonte (30,5 → 29,5 → 26,0) anda na direção
    **oposta** ao quarto de ciclo. (ii) **A decomposição espectral condena**:
    escrevendo `Aʰ = Σₖ λₖʰ vₖwₖ'` e apagando o par dominante de `B` — sem
    reestimar nada, com a reconstrução completa batendo a produção a **5,2e-13** —
    **o vale inverte de sinal em 12 de 14 séries** e sobra ~37% da magnitude; o
    horizonte do extremo colapsa para o limite da janela. Apagar o **segundo**
    par não muda nada (razão mediana **1,009**, contra **0,366** do primeiro).
  - **⚠ Armadilha de escala, testada com `stopifnot`.** Apagar modos muda o
    denominador da normalização — `B₀` só é a identidade com todos os modos
    (`Σₖ vₖwₖ' = I`) —, e sem o par dominante o impacto pré-normalização de
    `yield_6m` cai a **0,313** do original, reescalando o contrafactual por
    ~3,2×. **Sinal e horizonte são imunes**; a magnitude não, e tem de ser lida
    em **escala comum** (a leitura de decomposição, porque a IRF é linear em `Bₕ`
    e os modos só somam antes da renormalização). A primeira versão desta nota
    reportou as razões renormalizadas (1,170 / 0,977) como se fossem
    decomposição — corrigido.
  - **O `cambio_usd` é a exceção e importa:** é a **única** das 14 cuja reversão
    sobrevive inteira (razão 1,004). O que o §4 diz sobre persistência cambial —
    incluindo a dependência de estado da Tarefa 7, em h=6-8 — **não** é atingido.
  - **A afirmação defensável, mais estreita que a acusação:** a reversão de médio
    prazo e a persistência quase-unitária do VAR de fatores são **o mesmo
    objeto**. O paper pode reportar a reversão como o que o modelo implica; **não
    pode citá-la como evidência separada** da dinâmica que a produz. O tier de
    68% do §4 (vale setorial, contração do crédito em h=24-32, reversão da curva
    e da Selic) ganha uma ressalva de uma frase, **no corpo, não em rodapé**.
  - **Aberto daqui:** redigir a ressalva no §4 e o parágrafo em Limitações
    (bloqueado pelo item da §5 comentada); e **bandas simultâneas**
    (Montiel Olea-Plagborg-Møller 2021), pedidas pelo metodologista no mesmo
    review — com a reversão dominada por um único modo, banda pontual horizonte a
    horizonte é especialmente enganosa ao longo do caminho. Item novo.
- [ ] **Tabela `tab:rq_sweep` mostra 4 células selecionadas do grid, não o grid
  completo.** `mosw_strength_grid.csv` já tem (7,5), (7,7), (8,5) e (8,6)
  também cruzando ξ_mp ≥ 10 nas duas janelas — a produção (7,6) é um platô, não
  uma borda de faca, mas o texto atual não deixa isso visível e expõe a escolha
  a uma crítica de specification-hunting (metodologista: "invalida a teoria de
  distribuição padrão"). Trocar a tabela de 4 linhas pelo grid completo (14
  células) resolve com o dado que já existe.
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
- [ ] **Ações entram como retorno mensal acumulado enquanto o resto do painel
  entra em nível — possível causa mecânica do resultado nulo no bloco de
  ações**, que é o próprio tema do título do paper. Inconsistente com o próprio
  ponto do BLL (não diferenciar) e com Alessi-Kerssenfischer (log-nível). A
  razão de largura de banda em h=36 contra o impacto é 10,46 nos 8 índices
  contra 0,944 nas séries em nível — diagnóstico já calculado (comentado,
  linha 445). Reestimar com os índices da B3 em log-nível e checar se o bloco
  de ações continua nulo a 90%.
- [ ] **Camada de citação estrutural — três correções pontuais**
  (macro-theorist): o acelerador financeiro é Bernanke-Gertler-Gilchrist
  (1999), não Gertler-Karadi (2015), que é o paper empírico de medição, não a
  teoria; Cooley-Quadrini tem como dimensão de heterogeneidade o patrimônio
  líquido e porte da firma, não "setor" — o resultado de crédito setorial
  confunde isso com uma margem ortogonal (crédito direcionado vs. livre, ex.
  Plano Safra no agro), separável nos dados do BCB; e reposicionar
  Castelnuovo-Nisticò como argumento de identificação (a regra de política
  estimada responde a preços de ativos, exatamente o que a camada
  Bauer-Swanson precisa purgar) em vez de só motivação.
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
- [ ] **`juros_selic` e `juros_cdi` são quase idênticas (divergem só no
  terceiro dígito significativo) — não citar como duas evidências
  independentes.** Linha 345 cita "os dois" revertendo junto com a curva como
  se fossem confirmação cruzada; são a mesma série para qualquer propósito
  econômico.

Já cobertos por itens existentes, com corroboração independente do council: a
lacuna de bandas Anderson-Rubin (ver "Bandas Anderson-Rubin" abaixo — os três
críticos pediram o mesmo remédio, dois por ângulos independentes do LOO já
documentado, reforçando a prioridade elevada já registrada); "cerca de 110
séries" vs. 106 em §3.2 (já listado); e o TODO do resumo/introdução/conclusão
(já listado — o macro-theorist acrescenta que o resumo deveria garantir que a
discordância de sinal com GRG (2025) seja lida como puzzle central do paper,
não nota de rodapé).

## Aberto — decisão sobre a rota não-gaussiana (2026-07-27)

O ramo GMR está implementado e validado, e produziu um resultado que **não** é
o que a rota foi buscar. Registro completo em
`relatorio/working-notes/2026-07-27_identificacao_nao_gaussiana_gmr.md`.

- [ ] **Decidir o enquadramento do GMR no paper.** O autor optou por
  "identificação de manchete" em 2026-07-27, antes de os números existirem. O
  que eles dizem: **o estimador não tem poder neste painel.** As bandas de 90%
  no impacto **contêm zero em todas as variáveis** exceto a normalizada —
  `asset_ibov` é −10,7 com CI90 **[−49,5, +80,8]**, contra −1,67 com
  [−7,6, +1,8] do proxy. O bootstrap (200 draws i.i.d.) dá cosseno mediano 0,703
  entre a direção do draw e a do ponto, com 49% dos draws abaixo de 0,7. A
  rejeição assintótica da restrição do proxy (ξ = 117,3, p < 0,0001) é
  **provavelmente espúria**: a simulação mostra a Prop. 4 cobrindo 0,79 contra
  0,95 nominal em T = 150, n = 6. Não há contradição entre as duas
  identificações a resolver — há um estimador que não determina nada.
  **Recomendação:** usar o GMR como **teste** (ele rejeita o esquema recursivo,
  que é o que o artigo original faz) e não como estimativa concorrente.
  Argumentado na working-note.
- [ ] **Inspecionar a IRF da segunda coluna mais correlacionada com `z`.** A
  rotulagem escolhe por |cor| = 0,20 contra 0,17 — folga pequena demais para
  sustentar sozinha o nome "monetária". Barato: o objeto está em
  `output/nongaussian/gmr_cell.rds`.
- [ ] **LMS (2017) como terceira leitura** — `svars::id.ngml`, ML paramétrico
  sobre a mesma premissa de não-gaussianidade. Se LMS concordar com GMR, a
  discordância é do proxy; se ficar no meio, é do método. É o desempate mais
  barato disponível.

## Aberto — robustez e conteúdo

- [x] **Dominância fiscal: o IMPACTO não é dependente de estado, a PERSISTÊNCIA
  é — 2026-07-28; baseline migrado para CDS e virou subseção do §5 em
  2026-07-29** (Tarefa 7, `diagnostics/07_dominancia_fiscal.R`). LP-IV com
  interação completa, regime = MA12 defasada do indicador de risco cortada na
  mediana.
  - **As duas decisões que estavam abertas foram tomadas pelo autor em
    2026-07-29.** (i) Vira **subseção do §5** (`\ref{sec:estado}` em
    `tex/main.tex`), com CDS, EMBI e ΔDBGG lado a lado e as quatro ressalvas
    declaradas no próprio corpo. (ii) O **baseline migra de EMBI para CDS**:
    `07_dominancia_fiscal.R` ganhou `BASELINE`/`BASELINE_ALT`/`BASELINE_SER` no
    topo, os papéis da §7.4d se inverteram e todas as `t7_*.csv` foram
    regeneradas. Números da re-rodada em `diagnostico_dfm.md`, seção 7.
  - **O que a re-rodada mudou:** p_boot conjunto do câmbio 0,044 → **0,0456**;
    t_dif do impacto sob CDS 0,87 (máx 1,13 sobre os 7 indicadores, era 1,14);
    razões do LP-IV agregado 0,61-0,72 → **0,55-0,74**, porque o bloco de
    controle passou a usar defasagens de `cds_5y`. **Nenhuma conclusão mudou.**
  - **Achado novo da re-rodada:** sob CDS, **4 dos 63** testes horizonte a
    horizonte sobrevivem a Holm-bootstrap, contra 1 sob EMBI. Dois deles são
    `asset_ifnc` (h=7) e `rel_ifnc_ibov` (h=6). **Não promover isso**: as duas
    variáveis **não** rejeitam no teste conjunto (p_boot 0,222 e 0,257), que é o
    teste apropriado para "existe dependência de estado nesta variável". A
    conclusão de que o IFNC não discrimina se mantém.
  - **⚠ A conclusão depende do indicador de risco, e isso é o achado.** EMBI e
    CDS têm correlação de 0,933 nas MA12 mas os **regimes discordam em 24 dos
    141 meses** (κ = 0,660). Sob EMBI não se detecta dependência de estado em
    lugar nenhum; sob **CDS** e sob **ΔDBGG** ela aparece — e nítida.
  - **Impacto (h=0-4): NÃO é dependente de estado.** Robusto: nos **sete**
    indicadores testados, o \|t_dif\| do câmbio em h=0 nunca passa de **1,14**.
    Aqui o negativo é sólido e publicável.
  - **Persistência (h=6-8): É dependente de estado.** Sob CDS alto a depreciação
    **persiste** (+0,059 / +0,112 / +0,054 em h=6/7/8); sob risco baixo já
    **reverteu para apreciação** (−0,129 / −0,083 / −0,138). t_dif = 2,81 / 3,60
    / 3,15, primeiro estágio 13,3-13,5. Confirmado por `dbgg_d12` (t = 2,46 em
    h=7, F = 33,8) — medida fiscal conceitualmente independente — e estável em
    L ∈ {2,3}. **O EMBI não vê nada** (t = 0,32).
  - **É exatamente a hipótese do prompt**, que levanta a dependência de estado
    por causa da reversão pós-h≈10. Ela está lá, mas na reversão, não no impacto.
  - **Ressalvas obrigatórias:** p_boot conjunto de 0,044 é marginal; há
    multiplicidade (2 indicadores × 7 variáveis × 9 horizontes); o achado foi
    encontrado **após** olhar os dados, não pré-registrado; e o EMBI, medida mais
    convencional em emergentes, não reproduz. Merece subseção com as três
    especificações lado a lado, não afirmação central.
  - **Hipótese para a falha do EMBI** (não testada, vale um teste barato): os
    meses de discordância se concentram em 2020-21, quando o spread de bonds foi
    dominado pelo colapso global de prêmio a termo e não por risco de crédito
    brasileiro — o que embaralharia o regime no período mais informativo.
  - **O IFNC não discrimina.** O gap aparente em h=0 (−0,17 alto vs −7,17
    baixo) é **de mercado**: `asset_ibov` faz −0,20 vs −5,21, praticamente o
    mesmo t_dif. O relativo `ifnc − ibov` dá p_boot = 0,55 no conjunto; só há
    subperformance específica de banco em h=6 (t = −2,03), que morre no teste
    conjunto.
  - **Consequência para o §5:** o **impacto** deve ser apresentado como
    característica média da amostra — que já é como o §5 o apresenta. A
    **reversão pós-h≈10**, ao contrário, *tem* base para ser lida como
    dependente do estado fiscal, desde que com as três especificações
    (CDS / ΔDBGG / EMBI) lado a lado e a discordância do EMBI declarada.
  - ~~**Aberto:** decidir se isso vira subseção do §5 ou nota de robustez, e se
    o baseline da Tarefa 7 migra de EMBI para CDS.~~ **Fechado em 2026-07-29:
    vira subseção do §5 e o baseline migra para CDS.** Ver o topo deste item.
  - **⚠ Achado metodológico reutilizável:** o χ²(9) assintótico **super-rejeita
    catastroficamente** nesta amostra — `qchisq(0,95; 9) = 16,9` contra um q95
    de nula bootstrap de **38,9 a 89,1 (2,3× a 5,3×)**. Pelo assintótico, 6 de 7
    variáveis teriam dependência de estado; pelo bootstrap, 1 de 7. Horizonte a
    horizonte, 63 testes: 11 rejeições assintóticas, 3 sob Holm-assintótico, mas
    **1 sob Holm-bootstrap**. Qualquer comparação futura entre subamostras neste
    painel precisa de wild block bootstrap sob H0, não de p assintótico.
  - **Armadilha documentada:** interação **parcial** (só do tratamento) dá F de
    primeiro estágio 3,4-5,9 nos dois regimes, porque `x·(1−I)` é mecanicamente
    zero em metade da amostra. Sob interação completa, 10,6-29,0. Concluir "o
    regime baixo não é identificado" dali seria erro de especificação.
    Tabela em `diagnostics/output/t7_3b_artefato_interacao.csv`.
  - **DBGG/PIB em nível não serve como indicador de risco:** concordância de
    **0,433** com o EMBI-MA12 e κ = **−0,134**, pior que o acaso — a dívida sobe
    monotonicamente, então o corte na mediana rotula a crise de 2015-17 como
    "dívida baixa". F_baixo 1,9-2,6 = não identificado. `Δ12m` da DBGG é o corte
    fiscal defensável (concordância 0,586, F_baixo 8,9-9,7).
- [x] **Bloco de ativos: janela reportável h ≤ 12 — RESOLVIDO em 2026-07-28**
  (Tarefa 6, `diagnostics/06_bloco_ativos.R`). A hipótese H2 do relatório
  ("o horizonte longo é oscilação amortecida, não economia") foi **testada e
  confirmada** nos três eixos:
  - **Seção cruzada:** 8 de 8 índices negativos em h=0 (amplitude 2,58pp), 1 de
    8 em h=12, 3 de 8 em h=48 (amplitude 78,4pp) — **crescimento de 30,4×**.
  - **Ordenação econômica:** a correlação entre a sensibilidade medida a juros
    (β de `Δyield_2y`, HC1) e a resposta é **+0,903 em h=0** e **−0,672 em
    h=48** — a ordenação **inverte**. `asset_imob` e `asset_ifix` ficam nas
    posições **1 e 7 de 8**, respondendo literalmente à pergunta do prompt.
  - **Bandas:** razão mediana h36/h0 de **10,46** nos 8 `asset_*` contra
    **0,944** nas 81 séries de tcode 1 — exclusivo do `cumsum`.
  - **Nenhum dos 8 índices é sig90 em nenhum dos 49 horizontes**, e os 19
    horizontes sig68 do bloco estão todos em h ≤ 12.
  - **Sobre a hipótese de duration do IFIX:** ficou **sem teste** — o item 6.3
    é não executável (o cache `rb3` não tem `b3-reference-rates`, e as colunas
    `breakeven_*` de `raw_data.csv` são 100% NA). Mas o β de juros medido do
    IFIX é o **segundo menor** dos 8 e nem é significativo (t = −1,18), o que
    contraria a leitura de duration. Para fechar: rodar
    `rb3::fetch_marketdata("b3-reference-rates", ...)` sobre ~3.200 dias úteis.
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
- [x] **Placebo `commodity_metal` violado — RESOLVIDO em 2026-07-28.** Não é
  falha de exogeneidade: **o IC-Br do BCB é denominado em R$**, e o índice herda
  mecanicamente a resposta cambial. Teste decisivo em
  `diagnostics/01_exogeneidade.R` §1.6 (painel aumentado com
  `commodity_{metal,agro,energia}_usd = índice / cambio_usd`, nboot = 200):
  os três índices **em R$** violam (metal +12,07, sig90 em 4 de 5 horizontes
  h0-h4) e os três **em US$** passam limpo (metal +0,42, CI90 [−1,44; 1,88],
  **0 de 25** horizontes significativos). A resposta percentual em R$ (+3,98%)
  é essencialmente a do câmbio (+3,27%); `cor(dlog metal_BRL, dlog câmbio)` =
  +0,450 contra −0,409 para o índice em dólar. Isso explica de uma vez por que
  a identificação não-gaussiana, **que não usa `z`**, violava o mesmo placebo:
  a violação nunca foi do instrumento. **A hipótese "o instrumento retém
  componente global de commodity" está refutada** — se fosse fator global, o
  índice em dólar responderia. **Deixa de ser caveat de exogeneidade no §5.**
  - **Correção aplicada no mesmo dia (B3).** `commodity_metal` saiu do tier
    `placebo` e foi para `ambiguous`, grupo `commodity_domestica`
    (`R/identification/irf_coherence.R`). O tier `placebo` fica com as três
    genuinamente externas — `sp500_vix`, `msci`, `epu_us` — e **todas passam**.
    Após re-rodar `irf_coherence_check.R` (nboot=800), o placar é 22
    `coerente_forte` / 5 / 11 / 1 / 7 `ambigua` / 4 soft / 3 `placebo_ok` e
    **zero `placebo_viola`**. `commodity_metal` foi a única variável cujo
    veredito mudou. Prosa à mão atualizada em `irf_coherence_leitura.md`
    (com retratação explícita) e em `CLAUDE.md`.
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
- [ ] **Benchmark GRG (2025) sem a célula het** — a reconciliação do sinal do
  câmbio usava `z_het_3var` × pre-COVID, que saiu do paper. Decidir como
  discutir o desacordo (frequência diária × mensal GE, janela amostral, regime
  de dominância fiscal 2020-25). Ver §5.3 do `irf_section.md`.
- [ ] **Bandas simultâneas ao longo do caminho** (Montiel Olea-Plagborg-Møller
  2021) — *aberto em 2026-07-31.* Pedido pelo metodologista no council review, e
  o resultado da decomposição espectral do mesmo dia **eleva a prioridade**: se a
  reversão de médio prazo é dominada por **um único modo** da companion, os
  horizontes h≈20-40 são quase perfeitamente correlacionados entre si, e uma
  banda pontual horizonte a horizonte é especialmente enganosa para qualquer
  afirmação sobre a **trajetória** — que é exatamente o que o tier de 68% do §4
  faz (vale setorial, contração do crédito em h=24-32, reversão da curva).
  Distinto do item de AR abaixo: aquele trata de IV fraco no impacto, este de
  multiplicidade ao longo do horizonte. **Exige referência nova**, o que colide
  com a regra das 25 chaves — decisão do autor.
- [ ] **Bandas Anderson-Rubin** — *reclassificado de "opcional" para
  **fazer** em 2026-07-27; **prioridade elevada no mesmo dia** pelo resultado do
  leave-one-month-out; corroborado de forma independente pelos três críticos do
  council review de 2026-07-31 (`relatorio/council_2026-07-31.md`) — dois deles
  chegaram lá sem conhecer o LOO já documentado abaixo.* O ξ_mp = **10,43** na
  amostra full raspa o limiar em que as bandas convencionais são só
  "aproximadamente válidas"; publicar apenas Wald nessa margem é o que um
  parecerista vai perguntar primeiro. O projeto calcula ξ_mp — a estatística
  que diz se o conjunto AR é **limitado** — mas **nunca inverteu o AR** para
  produzir bandas.
  - **Razão empírica nova (2026-07-27):** o LOO mostra que **24 de 147** meses,
    removidos um a um, derrubam ξ_mp abaixo de 10 — a validade das bandas
    convencionais não sobrevive à remoção de um único mês. Em compensação
    **nenhum** dos 147 descartes derruba abaixo de 3,84, então o conjunto AR é
    limitado em toda a vizinhança amostral e a inversão **vale a pena**: ela
    entrega um intervalo, não uma reta. Ver
    `relatorio/working-notes/2026-07-27_robustez_xi_mp_e_construcao.md` §2.
  - **Alvo de tradução já no repo:** `codigo_olea/MSWfunction.m` produz o grid
    AR. É o mesmo exercício que já foi feito e validado ponta a ponta para o
    bloco Wald (`script/validate_olea_kilian.R`, números publicados do petróleo
    de Kilian).
  - **Custo não trivial:** o AR de MOSW é sobre a IRF de um VAR em observáveis;
    aqui a IRF é `Λ·B·K·M·H`, razão da mesma forma (linear em Γ sobre `c'Γ`), então
    a lógica de Fieller carrega, mas exige a mesma adaptação "identifica nas q
    inovações e propaga por Λ" que todo método do roadmap exige.
  - **Apresentação:** plotar as duas bandas no mesmo gráfico — Wald pontilhada,
    AR sombreada. A assimetria/expansão do AR *é* o conteúdo informativo.
  - Segue valendo o protocolo anti-screening de MOSW (footnote 6): reportar ξ,
    não filtrar pelo F.
- [x] **Robustez do próprio ξ_mp** (2026-07-27). `script/xi_mp_robustness.R` →
  `output/instrument/xi_mp_robustness.{csv,md}`. Nota:
  `relatorio/working-notes/2026-07-27_robustez_xi_mp_e_construcao.md`.
  - **Leave-one-month-out** (DFM fixo, só Γ recomputado). Produção, full:
    ξ_mp 10,43 → min 8,43 / máx 12,21. **0 de 147** descartes derrubam abaixo de
    3,84, então o **conjunto AR continua limitado sob qualquer amostra a menos de
    um mês**; mas **24 de 147** derrubam abaixo de 10, então a afirmação "bandas
    convencionais valem" *é* marginal. Nenhum dos 10 meses mais influentes é da
    COVID (o maior é 2024-12, −2,00). Pré-COVID: 12,22, só 4 de 78 abaixo de 10.
    O contraste confirma a máscara: `z_jk_purif` tem 147/147 abaixo de 10.
  - **HAC.** `compute_factor_space_wald` ganhou `nw_lags` (default 0, portanto
    nada mudou). Produção cruza 10 em **todas** as defasagens nas duas janelas, e
    ξ_mp é **crescente** em NW no full (10,43 → 15,64 em NW(6)) — NW(0) é a
    escolha **conservadora**, não uma conveniência.
  - **Validação** (`script/validate_hac_kernel.R`): kernel exato contra a
    transcrição literal de `NW_hac_STATA.m` em lags 0-8, e ponta a ponta contra a
    aplicação oficial de impostos (`TaxSVARIV.m`, NWlags = 8) — bloco Γ de `WHat`
    reproduzido a 2,6e-10 **e só em lag 8**. Isso também mede o que antes era só
    argumento: residualizar `z` nos regressores equivale ao bloco
    `−kron(Q₂Q₁⁻¹, I)` em **qualquer** defasagem.
  - **Consequência para as bandas AR:** o item de AR abaixo **sobe de
    prioridade** — agora tem razão empírica (24/147), não só de limiar.
  - **Não feito, e por quê:** F efetivo de Montiel Olea-Pflueger (razão abaixo,
    inalterada) e winsorização de `z` (encolheria exatamente os dias grandes, que
    *são* a variação identificadora; o LOO é a resposta certa no lugar dela).
- [x] **Robustez da construção do instrumento: vértice e esquema de agregação**
  (2026-07-27). `script/instrument_construction_sweep.R` → 260 células em
  `output/instrument/instrument_construction_sweep.{csv,md}` +
  `vertex_irf_overlay.pdf`. A cadeia de construção foi extraída para
  `R/instrument/build_variants.R` (regenera `instrumentos_mensais.csv`
  **bit-idêntico**; smoke test 5/5).
  - **Correção de registro:** o grid de vértice **existe**, arquivado em
    `arquivo/output/instrument_grid.{csv,md}` (2026-04-12), e é a procedência do
    comentário `# best F in grid search`. Estava obsoleto em três eixos (vintage
    pré-refresh, régua F legada com vencedor 4,30 = "menos ruim", e só as 4
    variantes legadas — `z_jk_bs_purif` não existia), mas não era inexistente.
  - **Vértice.** 13 alvos de 21 a 504 du. **126 du não é o argmax em nenhuma
    janela** (84 e 147 o superam no full; 42 domina pré-COVID), mas a maior
    margem de um desafiante elegível é **1,16**, contra o limiar de **2,00**
    fixado *ex ante* como a dispersão LOO do próprio ξ_mp. **A regra não dispara:
    produção fica em 126 du.** A leitura é que o vértice **não é identificado com
    precisão suficiente para escolher**, e a escolha herdada está dentro do
    conjunto indistinguível do melhor.
  - **O resultado que mais importa:** os 13 vértices dão **essencialmente a mesma
    IRF**, dentro da banda de 68% em quase todo horizonte — `vertex_irf_overlay.pdf`,
    o análogo da Figura A4 de Alessi-Kerssenfischer que faltava (eles rodam A1
    `p`, A2 `r`, A3 `q`, A4 instrumento). O vértice move ξ_mp e **não move as
    IRFs**.
  - **Agregação.** O esquema GK (nota 11) **colapsa** ξ_mp para 0,30 no vértice
    de produção contra 10,43 da soma, e não cruza 3,84 em nenhum vértice no full.
    Previsto **antes de rodar**: a nota 11 condiciona a ponderação a um indicador
    de **média mensal**, e `yield_6m` aqui é de **fim de mês**
    (`download.R:49-53`, `slice_tail(n = 1)`). Implementação conferida contra
    caso calculado à mão. Converte o "desvio documentado" do `CLAUDE.md` em
    escolha justificada. (Sob GK os meses sem reunião deixam de ser zero, e o
    MA(1) induzido invalidaria `NWlags = 0` para essas células.)
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
- [ ] **Spread de concessões novas** como complemento ao ICC — deve abrir já no
  curto prazo, ao contrário do ICC (taxa da carteira, reprecifica devagar).
  Desejável, não bloqueante.

## Aberto — código e higiene

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
- [ ] **Regenerar `instrument_diagnostics_report.md` e cortar a `tab:first_stage`** —
  *aberto em 2026-07-27.* O corpo está stale (gerado em 2026-07-15, pré-refresh
  de vintage, ainda com as variantes `z_het` arquivadas) sob banner. Re-rodar
  `Rscript script/instrument_diagnostics.R` regenera em 106 séries e sem a §4.
  O conteúdo da tabela de primeiro estágio que o §3 precisa **já existe** ali
  (§1: β̂, SE(HC0), t, p, F, ξ₁, R²; §1.1: bloco MOSW completo com ξ_mp) — falta
  regenerar e cortar como tabela de paper. `mosw_strength_grid.md` está corrente
  mas é grid `(r,q) × amostra × instrumento`, não tabela de 1º estágio. **Sem**
  os valores críticos de MOP (razão no item de robustez do ξ_mp).
- [ ] **Seleção da etapa 2 é dominada pela janela pre-COVID** (aberto em
  2026-07-26). Com a taxonomia migrada, 23 células ficam `ok` em `yield_6m` e
  **todas empatam** em `score_hard_frac = 1` e `score_ext = 3`, então o
  desempate é só ξ_mp — que é sistematicamente maior pre-COVID. Resultado: o
  top-5 é inteiramente `pre_covid`, e o baseline de produção (full, 7, 6) entra
  pelo force-append. A comparação da etapa 2 acaba confundindo escolha de
  instrumento com escolha de janela. Considerar um teto por amostra análogo ao
  `MAX_PER_INSTRUMENT`, ou desempatar por `f_reduced`.
- [ ] **`R/modeling/svensson_model.R` ficou sem consumidor** (aberto em
  2026-07-26). Era o motor do `script/yield_curve.R`, apagado na mesma data — a
  curva do painel é o insumo fixo do orientador (`data/yields/yields_dia.csv`).
  O `source()` no `download.R` era chamada morta e foi removido; nenhuma das 7
  funções do módulo é chamada em lugar nenhum. São ~600 linhas de código de
  modelagem reutilizável, então **não apaguei**. Decidir: apagar, mover para
  `arquivo/` (convenção do repo para código não executado e não citado pelo
  paper), ou manter como utilitário. Ver `historico_decisoes.md` §4.
- [x] **Taxonomia do `irf_spec_sweep.R` migrada para ξ_mp** (2026-07-26).
  `classify_sweep_cells` agora classifica por `wald_mp` com os limiares MOSW
  (`weak_xi_mp_severe` < 3,84 — conjunto AR ilimitado; `weak_xi_mp` < 10), e as
  ordenações da etapa 1 e da etapa 2 desempatam por ξ_mp. `f_factor` continua
  reportado por célula e ganhou tabela própria sob o rótulo "régua legada", mas
  não decide mais. Artefatos regerados: 320 células, 8 instrumentos, coluna
  `wald_mp` conferida contra `mosw_strength_grid.csv`. O instrumento de produção
  agora é `ok` em (7,6) full — o force-append da etapa 2 virou rede de
  segurança (ver o item de seleção acima).
- [x] **Prosa do coherence separada do corpo gerado** (2026-07-26). A leitura
  interpretativa vive em `output/irf/irf_coherence_leitura.md`, escrita à mão e
  não tocada por script; `irf_coherence_report.md` continua sendo o corpo
  gerado, agora com aviso e ponteiro no cabeçalho. A leitura foi **reescrita sob
  (7,6)** a partir do `irf_coherence_h.csv` corrente — a versão perdida no
  `fc0ef58` era de 2026-07-12 sob `z_jk_purif` × (6,5) e não foi restaurada.
- [x] **`irf_mp_raw` renomeado para `irf_mp_pre_tcode`** (2026-07-26) em
  `ident_ext_instr` (`R/modeling/impulse_responde.R`). Não havia consumidor do
  campo em lugar nenhum; o docblock agora explicita que é pós-normalização e
  pré-tcode. Zero mudança de output (smoke test 5/5). A ocorrência em
  `arquivo/R/identification/het_primary.R` ficou congelada de propósito.
- [x] **`script/run_all.R`** (2026-07-26) — orquestrador de 8 estágios
  (`di → external_factors → focus_fred → ibov → download → clean → instrument
  → model`), **um processo `Rscript` por estágio**, porque os
  scripts começam com `rm(list = ls())` e os dois downloaders só executam sob
  `if (sys.nframe() == 0)`. Flags: `--list`, `--dry-run`, `--from`, `--to`,
  `--only`, `--skip`, `--skip-existing`, `--continue-on-error`. Preflight aborta
  antes de rodar qualquer coisa se faltar insumo; log por estágio em
  `output/logs/` (gitignored).
- [x] **Branches consolidadas** (2026-07-26). As cinco branches locais eram uma
  cadeia linear sem divergência; todas foram merged em `main` por fast-forward e
  apagadas. `codigo_olea/` (87 MB de referência MATLAB, commitado por engano no
  `4f39ad9`) foi removido da história não-enviada e entrou no `.gitignore`, junto
  dos três `codigo_*` irmãos.

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
  "falhar", e só toca `tex/`.
- **Higiene e re-runs de diagnóstico vão direto na `main`**: o bloco de higiene
  de 2026-07-26 (`run_all.R`, renomear `irf_mp_raw`, taxonomia por ξ_mp,
  separar a leitura do coherence) foi feito assim. Segue valendo para o placebo
  `commodity_metal` e a comparação cross-instrumento do IPCA.
