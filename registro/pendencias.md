# Pendências

**Última revisão:** 2026-08-17 (rodada que fechou sete itens do Tema E; ver o
bloco `Fechados` de lá e `notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md`).
Itens abertos organizados por tema (A-E);
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
2026-08-13.

**O paper está partido entre duas vintages desde 2026-08-14.** A §3, a §5 e a
`tab:lista_variaveis` já falam da produção de 111 séries `(5,5)`. A §1, a §2, a
§4 e a conclusão **não**, por recorte explícito de escopo, e ainda carregam 106
séries, `(7,6)`, `xi_mp=7,65`, 5,55%, 32,0/43,4/117,0 pb e o CDI. Enquanto essa
metade não for reescrita, o `.tex` se contradiz em público, e nenhuma das duas
metades deve ser usada para conferir a outra.

---

## Índice de itens abertos

| Tema | Item | Observação |
|---|---|---|
| A | Reescrever resumo, §1, §2, §4 e conclusão para a produção 111 `(5,5)` | §3, §5 e o apêndice já migrados em 2026-08-14; checklist abaixo |
| A | §5 Robustez tem 3 subseções — faltam construção do instrumento, especificação e Limitações | as 3 escritas já estão na vintage corrente; o que falta é composição, não número |
| A | Decidir se o diagnóstico de invertibilidade vira subseção própria da §5 | hoje é parágrafo dentro de `sec:exogeneidade`; decisão de composição, não de número |
| A | Assimetria da máscara re-derivada entre §5.2 e §5.3 | §5.3 reporta, §5.2 não; decisão editorial pendente |
| A | Ressalva §4 + Limitações sobre a reversão de médio prazo | raiz 0,964858; retirar a leitura antiga de “um modo quase unitário” |
| A | Documentar a mecânica do bootstrap no texto | — |
| A | Vertente de prêmio de risco cambial ausente do §2 | exige chave nova (regra das 25) |
| A | Corrigir leitura do IMAT em §4.6 | independente, sem citação nova |
| A | Conversão percentual do câmbio não é escala-livre; comparações usam bases diferentes | refazer com impacto corrente de 3,84% por 50 pb; a §5.1 já nomeia a base |
| A | Portar reconciliação com GRG (2025) para o corpo do §6 | decisão já tomada (Tema D), falta redação; réplica precisa rodar na vintage atual |
| A | Bandas Anderson-Rubin no `.tex` | adiadas sem prazo em 2026-08-12; linha que faltava no índice |
| A | Reescrever o papel da Selic em §4.1 | na produção corrente ela sobe e exclui zero a 90% em h=0--11; CDI saiu |
| A | Convenção de horizonte do §4 (impacto vs. pico em h=1) | blindspot 2026-08-12; casar com o item de base 100 pb |
| A | Reportar as cinco moedas no §4.2, não duas | blindspot 2026-08-12; dado já estimado, nada a rodar |
| A | Bloco de agregados monetários ausente do §4 | blindspot 2026-08-12; dado já estimado |
| A | Reportar os oito EPU no §5.1, não só o escolhido | blindspot 2026-08-12; recusado em 2026-08-14 por decisão do autor, não por falta de dado |
| A | §4.5 não diz que o price puzzle é de amostra cheia | blindspot 2026-08-12; bloqueado pelo item de IPCA cross-instrumento (Tema D) |
| B | Bandas simultâneas (Montiel Olea-Plagborg-Møller 2021) | exige referência nova |
| B | Validade do wild bootstrap (Jentsch-Lunsford) | mínimo aceitável: 1 parágrafo no §3 |
| B | LP-IV como robustez à especificação dinâmica | desejável, não bloqueante |
| B | Comunalidade baixa (`price_core_ipca_ex0`, `asset_ifix`) | — |
| B | Decomposição do wedge de UIP | prioridade alta, council 2026-08-10; só pós-processamento |
| B | Acrescentar um nível do S&P 500 à bateria de placebos | desmembrado em 2026-08-14; muda o painel de 111 para 112 e obriga a re-rodar a produção |
| B | Bandas Anderson-Rubin (implementação) | adiadas sem prazo em 2026-08-12; linha que faltava no índice |
| B | Decompor a curva entre expectativa e prêmio (diário vs. mensal) | blindspot 2026-08-12, prioridade alta; depende da correção do Tema E |
| B | A amplificação 5a/6m é do choque ou de Λ? | blindspot 2026-08-12; teste discriminante do item acima |
| B | Tratar a janela pré-COVID como diagnóstico de força/estabilidade | raiz 1,000202 impede usá-la como evidência dinâmica |
| B | Correlações canônicas VAR pequeno × espaço de fatores | sustentação direta de `:238`, hoje só indireta; não existe no repo |
| B | Pré-teste de relevância de Angelini-Cavaliere-Fanelli | robusto a proxy censurada em zero, que é o desenho da máscara JK; exige chave nova |
| A | Reescrever o bloco de ações do §4 e a nota da `fig:acoes` | aberto em 2026-08-17 ao fechar o `cumsum`; §4 ainda não migrou |
| D | Comparação cross-instrumento do IPCA sob (5,5) | dado já existe, falta rodar |
| D | Spread de concessões novas | desejável, não bloqueante |
| E | Decidir `q`: o critério admissível diz 2, a força diz que 2 não identifica | evidência completa em `notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md`; produção intocada |
| E | O estágio `di` não reproduz mais a vintage do repo | asset renomeado, schema mudou, histórico começa em 2018, releases podadas; `data/raw/di.csv` virou insumo insubstituível |
| E | Padronização do 2º estágio em `amengual_watson()` | única divergência de substância contra o MATLAB; mexer nela reescreve `q_hat` de 64 painéis × 2 amostras |
| E | `output/panel_experimental/irfs_required_long.csv` com `asset_ibov` sob o tcode antigo | rodada histórica de 106 séries `(7,6)`; re-rodar quebraria o que ela documenta |
| E | Remover o shim `scalar_dynamic_factor_compat.R` | o módulo já corrige `q=1<r`; espera a próxima re-rodada da auditoria congelada |

---

## A. Texto do paper

- [ ] **Reescrever o resumo, a §1, a §2, a §4 e a conclusão de
  `paper/paper_anpec.tex` para a produção de 111 séries `(5,5)`** — *aberto em
  2026-08-13; metade cumprida em 2026-08-14.* A §3, as três subseções escritas
  da §5 e a `tab:lista_variaveis` já migraram. O que resta é a metade
  interpretativa, que ainda descreve a produção `(7,6)` de 106 séries e agora
  **contradiz a metade migrada dentro do mesmo arquivo**, o que torna a
  pendência mais grave do que era quando o `.tex` estava uniformemente
  desatualizado. A checklist abaixo marca o que caiu e o que sobrou.

  - **Resumo, abstract, introdução e conclusão:** substituir em conjunto as
    quatro manchetes de impacto: BRL/USD **3,84%** (IC90 [2,24; 6,06]), EMBI+
    **26,2 pb** ([17,2; 47,3]), CDS 5 anos **32,5 pb** ([22,2; 53,8]) e DI 5
    anos **77,6 pb** ([57,9; 111,0]). Atualizar painel para 111 séries e
    `xi_mp` para **6,27085**. Preservar a formulação “compatível com transmissão
    via prêmio de risco”, mas retirar a atribuição causal a dominância fiscal e
    qualquer alegação de que o prêmio “domina” o diferencial sem a decomposição
    do wedge de UIP do Tema B. As versões portuguesa e inglesa precisam fechar
    exatamente nos mesmos números e qualificações.
  - ✅ **Seleção e força — FEITO em 2026-08-14.** A §3.5 foi reescrita em torno
    do Bai--Ng IC2 BLL, com `q=5` declarado como escolha operacional em aberto,
    e a §3.6 passou a `6,27/10,12` cheia e `10,99/9,75` pré-COVID, com a raiz
    `1,000202` impressa ao lado. A `tab:rq_sweep` **saiu do paper por inteiro**,
    por decisão do autor, porque a dimensão deixou de ser justificada por
    varredura de força; com ela saíram as três remissões e a nota que definia as
    duas estatísticas, hoje no corpo da §3.6. Anderson-Rubin **não é mais
    mencionado em lugar nenhum** do `.tex`. A comparação Selic versus DI 6m foi
    revalidada e **corrigida**: o "não alcança em nenhuma dimensão" só vale na
    amostra cheia (5,20 contra 10,73), porque pré-COVID a Selic chega a 21,54.
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
  - ✅ **Robustez, as três subseções escritas — FEITO em 2026-08-14.**
    Exogeneidade passou a cinco fatores, `R²` de 0,044 a 0,263 e `p_boot` de
    0,199 a 0,749; o metal virou `+2,46%` da média amostral na produção e
    `+2,48%` contra `-0,91%` no painel aumentado, cujo `xi_mp` cai de 6,27 para
    5,77; os placebos passaram a **0 de 49 a 90%** e **1 de 147 a 68%**, o VIX em
    h=8. O confound soberano ficou `6,27 -> 6,62 -> 7,58`, com câmbio
    `0,155` contra `0,158` e CDS `29,7` contra `32,5` pb. O FOMC ficou
    `6,271 -> 6,312` nos valores e `4,175` na máscara rederivada. A frase de
    `0,76%` e `24,7%` de variância **saiu**, porque não reproduz no relatório
    regenerado. **A perna da máscara ficou só na §5.3**, por decisão do autor, e
    a assimetria com a §5.2 virou item próprio abaixo. A composição que falta
    (construção, especificação e Limitações) é o item seguinte.
  - ✅ **Apêndice — FEITO em 2026-08-14.** A `tab:lista_variaveis` tem exatamente
    111 linhas, conferidas por comparação de conjuntos contra as colunas de
    `data/processed/data_log_deseasonalized.csv`, e a distribuição de `tcode`
    da tabela (88/7/16) bate com `infer_tcode_from_varnames()` aplicada ao
    painel. Saíram CDI e MLCX; entraram as três fiscais e as quatro Focus, todas
    com código 1. A coluna Fonte da curva **mantém "Svensson/B3" por decisão do
    autor**, ainda que não exista estágio de ajuste neste repositório.
  - **Gate editorial, agora só sobre a metade não migrada:** buscar e eliminar
    referências ativas a 106, `(7,6)`, 5,55%, 117,0 pb, 32,0 pb, 43,4 pb,
    `xi_mp=7,65`, CDI e MLCX, hoje concentradas nas linhas 115, 142 e 154 da §1,
    283, 311, 318 e 420 da §4, e 545 e 547 da conclusão. Conferir que as sete
    figuras incluídas têm texto e legenda compatíveis com a vintage corrente e
    decidir explicitamente se `fig_estado.pdf` entra como oitava; compilar sem
    referências/citações indefinidas; executar `git diff --check`; e confirmar
    que nenhum `.tex` além de `paper/paper_anpec.tex` foi tocado.

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

- [ ] **A `§5 Robustez` de `paper/paper_anpec.tex` tem 3 subseções e faltam as
  demais frentes da composição recomendada.** *A perna numérica foi fechada em
  2026-08-14:* `sec:exogeneidade`, `sec:confound` e `sec:fomc` estão reescritas
  contra os relatórios de 2026-08-13, e nenhum número da vintage de 106 séries
  sobrevive ali.
  **O que falta, na ordem da composição recomendada:** divergência com GRG,
  construção do instrumento e dimensão do sistema (A3 + A4 + A2),
  especificação do modelo (A5 + A1 + A7 + LP-IV com o rótulo certo) e
  **Limitações**. A prosa antiga de `arquivo/tex/main.tex` pode servir de mapa de
  tópicos para Limitações e `sec:estado`, mas nenhum número dela deve ser
  portado.
  A nota da `fig:acoes` que promete uma discussão "no texto" continua sem
  contrapartida.
  ⚠ **A subseção de construção do instrumento perdeu o peso extra** que herdara
  quando a `tab:rq_sweep` saiu do paper: a `tab:first_stage` entrou na §3.6 em
  2026-08-14 e já cobre as três camadas da construção nas duas janelas (Tema E,
  Fechados). O que a subseção ainda deve é a leitura do vértice e do esquema de
  agregação, não a tabela de força.
- [ ] **Decidir a assimetria da máscara re-derivada entre §5.2 e §5.3** —
  *aberto em 2026-08-14.* A §5.3 reporta as duas pernas do teste FOMC, valores
  (`6,271 -> 6,312`) e máscara rederivada (`4,175`), porque já as reportava antes
  e a rodada só atualizou números. A §5.2 reporta só a perna de valores
  (`6,27 -> 6,62 -> 7,58`), por decisão do autor, e por isso o texto diz
  explicitamente que a operação **não** toca a seleção dos 62 dias. O `4,264` da
  máscara soberana existe em `output/instrument/jk_sovereign_confound.md` e é o
  que fecha a objeção do council de 2026-08-10 sobre o "por completo". Duas
  saídas coerentes: reportar a máscara nas duas subseções, ou omiti-la nas duas
  e explicar em Limitações por que a seleção não é testada. A configuração atual
  não é nenhuma das duas.
- [ ] **Decidir se o diagnóstico de invertibilidade merece subseção própria na
  §5** — *aberto em 2026-08-14, ao fechar o item de exogeneidade lead-lag.* Hoje
  ele entra como os dois últimos parágrafos de `sec:exogeneidade`, rotulados
  como mudança de objeto. O argumento a favor de destacá-lo é que a
  invertibilidade é a **única hipótese mantida do estimador de produção**, e
  ficar dentro de uma subseção intitulada "Exogeneidade do instrumento" pede ao
  leitor que segure a distinção sozinho. O argumento contra é que a composição
  recomendada da §5 já tem fila (construção, especificação, Limitações) e o
  material é curto. É decisão de composição, não de número —
  nenhum resultado muda.
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
  Ver `historico_decisoes.md` §4 e `arquivo/heterocedasticidade/notas/2026-08-01_robustez_heterocedasticidade.md` para os números; a réplica arquivada
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
- [ ] **Reportar os oito EPU no §5.1, não só o escolhido** — *proposto e
  **recusado** pelo autor em 2026-08-14, sem que o dado faltasse; a §5.1 segue
  tratando só o `epu_us` como placebo externo.* A direção mudou na
  produção corrente: no impacto, `epu_brazil` sobe **23,9**, `epu_germany`
  **27,2** e `epu_chile` **18,5**, e somente `epu_chile` exclui zero a 90%, em
  **4 dos 49 horizontes**; os demais não excluem em horizonte nenhum. O VIX não
  exclui zero a 90% em **nenhum dos 49**. A contagem sobre h=0--48 está
  **feita** e a família inteira está medida, então o que resta é a decisão
  editorial de apresentá-la para evitar escolha ex post do placebo.
  ⚠ **A fonte não é `irf_coherence_h.csv`**, que só carrega `epu_us` entre os
  oito; os outros sete saem de `output/irf/irf_coherence_cell.rds`, que guarda as
  111 séries com bandas.
- [ ] **O §4.5 não diz que o *price puzzle* é de amostra cheia** — *bloqueado
  pela comparação cross-instrumento do Tema D.* Na célula corrente,
  `price_ipca` dá h6 **+0,089**, h12 **+0,031** e h24 **−0,169** na amostra
  cheia, contra **−0,092/−0,066/+0,112** pré-COVID. A subamostra, porém, é
  marginalmente explosiva e não autoriza leitura dinâmica por si só. O texto só
  pode chamar a corcova de fenômeno da amostra cheia depois do teste
  cross-instrumento e deve separar IPCA cheio (nenhum sig90) de IPP (sig90 em
  h=0--3).
- [ ] **Reescrever o bloco de ações do §4 e a nota da `fig:acoes`** — *aberto em
  2026-08-17 ao fechar o `cumsum` do bloco acionário (Tema E, Fechados).* A
  correção do transform mudou a trajetória dos 7 índices em todo h ≥ 1, e o §4
  ainda não migrou para a produção `(5,5)`, então esta reescrita entra junto com
  a do item principal deste tema, não antes.
  - ⚠ **Há uma contradição literal em aberto desde 2026-08-17, e ela é
    consequência direta da correção.** `fig_acoes.pdf` foi regenerado sem
    acumulação, mas a legenda da figura (`paper_anpec.tex:485`) ainda diz que "a
    resposta é acumulada para recuperar o nível de preço", e `:491` ainda promete
    reinterpretar o bloco "quando a pendência específica do \texttt{cumsum} for
    resolvida" — pendência que está resolvida. Os dois trechos ficaram **de
    propósito** sem edição, porque a prosa em volta ainda carrega os números da
    vintage de 106 séries (2,41% no impacto, faixa −0,46% a −4,06%, IFIX 2,18%) e
    consertar a legenda isolada deixaria uma figura correta sob um parágrafo
    errado. Tratar como bloco único.
  - **O que o texto pode dizer quando for reescrito:** o pico de médio prazo do
    Ibovespa caiu de **+17,71% em h=21** para **+2,01% em h=8**, e a razão de
    largura de banda h36/h0 nos índices caiu de **27,573 para 0,920**. A resposta
    passou a ser de **retorno mensal em %**, não de nível de preço acumulado — a
    legenda e a unidade do eixo têm de dizer isso.
  - ⚠ **O que o texto NÃO pode dizer.** A proibição do `CLAUDE.md` continua
    valendo e agora está medida: **nenhum texto pode creditar ao `cumsum` a
    recuperação do bloco acionário.** Em h = 0 a significância é invariante ao
    tcode, e o bloco **piorou** nos outros horizontes — sig90 total caiu de 4
    para 2 e o tier de 68% em h ≤ 12 ficou parado em 20.
  - ⚠ **Quatro índices caíram de `coerente_forte` para `parcial`**
    (`asset_ibov`, `asset_smll`, `asset_idiv`, `asset_imob`), consequência
    conhecida de manter a janela de coerência em h0-6 sobre uma resposta de
    retorno. Se o §5 citar a contagem de vereditos, tem de citar esta.
  - A nota da `fig:acoes` que promete uma discussão "no texto" continua sem
    contrapartida (mesma pendência listada no item da §5).

### Fechados (contexto)

- [x] **Exogeneidade lead-lag: procedência resolvida e condição testada — FEITO em
  2026-08-14.** A condição é a **Condição LP-IV (iii) de \cite{stockwatson2018}**,
  que a nomeia *lead-lag exogeneity*; Braun-Brüggemann é bayesiano (Bayes factor
  Savage-Dickey sobre exclusão contemporânea) e **não** é a fonte. O achado que
  mudou o item: a lead-lag **não é exigida pelo SVAR-IV**, que paga em
  invertibilidade — logo a perna de leads testa invertibilidade, não exogeneidade.
  O teste canônico dessa hipótese (SW §3/Tabela 2, Forni-Gambetti) **não existia
  no repo**, foi implementado como `01_exogeneidade.R` §1.7 e **não rejeita**:
  em `L=6` o menor `p_boot` das cinco equações é `0,324`, todos os Holm dão
  `1,000`. §3.3 e §5.1 reescritas, sem chave nova (25). Nota:
  `notas/2026-08-14_exogeneidade_lead_lag_e_invertibilidade.md`; saída:
  `diagnostics/output/t1_7_invertibilidade_granger.csv`.
  ⚠ Condição só **necessária** e potência baixa (30 regressores livres, 6
  testados, n=147); nenhuma simulação de tamanho foi rodada. ⚠ `cambio_usd`
  defasado segue em `p_boot` **0,064**, o único do bloco externo abaixo de 0,10,
  e não está entre os preditores predeterminados de Bauer-Swanson.
- [x] **Atribuição errada do limiar "≥10" a Montiel Olea-Stock-Watson — FEITO em
  2026-08-14.** A §3.6 agora chama o 10 de referência convencional para o F de
  primeiro estágio homoscedástico do 2SLS e nega explicitamente que seja valor
  crítico de MOSW para a Wald robusta. A rota alternativa, citar Montiel
  Olea-Pflueger (2013), foi descartada porque custaria a 26ª chave.
- [x] **Descrição do placebo `sp500_vix` corrigida na prosa — FEITO em
  2026-08-14.** O rodapé da §5.1 e o argumento de confundidor doméstico não
  citam mais o S&P 500, que não está no painel. O rótulo do painel dentro da
  figura foi corrigido no mesmo dia (Tema B, Fechados); o que sobrou é a opção
  de acrescentar um nível do S&P 500 ao painel, item aberto no Tema B.
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
  via `tsls` com Newey-West em `h + 1`). ⚠ **`IdSS` deixou de entrar no projeto**
  quando a rota não-gaussiana foi arquivada (2026-08-17): a dependência agora é
  nova, e o custo marginal deixou de ser baixo.
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
    **Não** responde ao ξ_mp no limiar nem ao placebo `commodity_metal`. Desde
    2026-08-17 **não há mais nenhuma rota que identifique sem `z`** no
    repositório — as duas que havia foram abandonadas (Tema C).
  - **[2026-08-14] O que destrava, e é mais do que robustez de especificação.** A
    LP-IV exige a condição lead-lag, que a rodada de 2026-08-14 testou e não
    rejeitou (Tema A, Fechados), então a pré-condição está satisfeita. E o prêmio
    é maior do que "outro estimador da mesma identificação": rodada a LP-IV, a
    comparação **LP-IV × SVAR-IV é o teste de Hausman de invertibilidade** da §3
    de \cite{stockwatson2018}, com estatística `ξ` e distribuição χ² sob a nula.
    É mais forte que o teste de Granger já implementado, porque incide sobre a
    IRF — o estimando de interesse — e não sobre poder preditivo. Ataca a única
    hipótese mantida do proxy-DFM. ⚠ SW registram que robustecer esse teste a
    instrumento fraco é questão em aberto, e aqui ξ_mp é 6,27.

- [ ] **Correlações canônicas entre um VAR pequeno e o espaço de fatores** —
  *aberto em 2026-08-14, a partir do código de replicação do capítulo de
  Stock-Watson no Handbook of Macroeconomics.* `paper_anpec.tex:238` afirma que
  um VAR de pequena dimensão raramente contém a informação relevante e que o
  SDFM recupera choques fundamentais. Hoje isso é sustentado **só indiretamente**,
  pela comparação de IRFs do `model_var.R`. SW medem a mesma coisa diretamente na
  Tabela 5 do capítulo (`codigos_externos/codigo_sw/ddisk/matlab/hom_var_approx.m`):
  correlações canônicas entre os fatores estimados e as variáveis do VAR pequeno,
  **em nível e em resíduos**. A versão em resíduos é a que interessa, porque
  pergunta se as inovações do VAR pequeno geram o espaço das inovações fatoriais.
  Barato: os dois objetos já existem no repositório, e `cancor()` é base R.
  **Complementar ao teste de Granger de §1.7, não substituto** — a correlação
  canônica pergunta se o VAR pequeno gera o espaço dos fatores; o Granger
  pergunta se `z` traz informação que o passado do VAR de fatores não tem.
- [ ] **Pré-teste de relevância de Angelini, Cavaliere & Fanelli (2024)** —
  *aberto em 2026-08-14, ao conferir lastro para a perna de leads; o paper não
  serve para exogeneidade, mas serve para força.* A régua corrente (ξ_mp,
  `F_rob`) pressupõe ausência de censura, e `z_jk_bs_purif` é **censurado em
  zero por desenho** — a máscara JK zera 33 das 95 reuniões e o instrumento vale
  zero nos meses sem Copom, restando 60 meses não-nulos em 153. O pré-teste deles
  contorna isso: o estimador MBB-CMD de força é assintoticamente gaussiano sob
  proxy forte e não-gaussiano sob proxy fraca à Staiger-Stock, então **testa-se
  normalidade** (Doornik-Hansen) sobre `N = [T^{1/2}]` réplicas de bootstrap.
  Robusto a heterocedasticidade condicional **e** a censura em zero, e livre de
  viés de pré-teste (Prop. 7), ao contrário do rastreio por `F` de primeiro
  estágio. Veredito mais apropriado para um instrumento a `6,27`.
  ⚠ **Custo:** exige chave nova, colidindo com a regra das 25 — decisão do autor.
  ⚠ **Sem pacote público** (código sob solicitação aos autores, conferido em
  2026-07-24), então teria de ser escrito do zero, mais a adaptação ao espaço de
  fatores. ⚠ A pasta em `artigos/` grafa "panelli"; o autor é **Fanelli**.
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
- [ ] **Acrescentar uma série de nível do S&P 500 à bateria de placebos** —
  *desmembrado em 2026-08-14 do item do rótulo, que fechou no mesmo dia; a
  origem é o council de 2026-08-10 (skeptic).* A bateria tem VIX, MSCI de
  emergentes e EPU americano, e **nenhum nível do S&P 500**. A série diária
  existe em `data/raw/investing/external_factors_daily.csv` de 2012-01 a
  2026-01, então é questão de agregação, não de download. Vale a pena porque é
  aí que o item de coincidência FOMC morde: um choque do Fed move o VIX
  intraday, mas o VIX reverte à média e um pico de um dia se dissipa antes do
  fim do mês, enquanto um movimento do BRL em um dia não.
  ⚠ **Não é pós-processamento.** O placebo é lido da IRF de uma série do
  painel, de modo que acrescentá-la leva a produção de 111 para 112 séries e
  obriga a re-rodar a estimação — decisão de painel, não de figura.
- [ ] **Bandas Anderson-Rubin — ADIADAS SEM PRAZO e sem prioridade ativa.** A
  implementação de 2026-08-10 foi retirada em 2026-08-12. Embora reproduzisse
  o código MOSW no VAR observável, ela condicionava em fatores e loadings
  estimados sem teoria de cobertura para esses objetos gerados e tinha defeito
  demonstrado na classificação de casos degenerados. Reabrir somente com uma
  derivação que incorpore a estimação fatorial ou com um procedimento que a
  reproduza. A nota `notas/2026-08-10_bandas_anderson_rubin.md` permanece
  preservada e marcada como `SUPERSEDED`; o parecer externo permanece verbatim.

### Fechados (contexto)

- [x] **Rótulo "S&P 500 / VIX" corrigido dentro da figura — FEITO em
  2026-08-14.** `script/fig_section5.R:213` passou a escrever `"VIX"`, e as oito
  figuras foram regeradas do `.rds` cacheado, com o auto-teste contra
  `irf_coherence_h.csv` passando em 45 das 46 séries plotadas (`commodity_agro`
  está fora da régua de coerência, por desenho do script). Figura, prosa e
  legenda da §5.1 agora dizem a mesma coisa. A opção mais forte, acrescentar um
  nível do S&P 500 ao painel, virou item aberto próprio acima.
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

## C. Identificação por momentos e por heterocedasticidade — ENCERRADO

**Ambas as rotas foram abandonadas em 2026-08-17, por decisão do autor.** Não há
item aberto neste tema. O código, os artefatos, as notas e os vereditos vivem em
`arquivo/nao_gaussiana/` e `arquivo/heterocedasticidade/`, cada um com README
próprio; o resumo está em `historico_decisoes.md` §0 e §1.

O núcleo de identificação foi colapsado para o ramo único `proxy` na mesma data
(`R/modeling/{dfm_pipeline,impulse_response}.R`), com o smoke test de produção
bit-idêntico como guard.

### Fechados (contexto)

- [x] **Enquadramento do GMR no paper — ENCERRADO SEM ENTRAR (2026-08-17).** A
  recomendação viva era usar o GMR como *teste*, não como estimativa concorrente,
  apoiada em duas afirmações de não-discriminação: o ponto do proxy cai dentro do
  CI90 do GMR em 100% das 5.439 células, e o esquema recursivo é rejeitado
  (ξ = 73,81). Nada disso entra no paper.
- [x] **Construir um teste com poder — ENCERRADO (2026-08-17).** O gargalo era a
  régua, não o estimador: a concordância de sinal satura contra o nulo (p=0,149)
  e a razão de magnitude nunca rejeitou a 5% (p=0,087).
- [x] **LMS (2017) como terceira leitura — ENCERRADO SEM TENTAR (2026-08-17).**
  `svars::id.ngml` era o desempate mais barato disponível; `svars` nunca foi
  instalado.
- [x] **Heterocedasticidade *condicional* (GARCH-SVAR) — ENCERRADA SEM TENTAR
  (2026-08-17).** Era a ponta solta declarada da rota het, a única com chance de
  produzir IRF mensal por dispensar datas de regime.
- [x] **Subseção de robustez sobre heterocedasticidade — NÃO SERÁ ESCRITA
  (2026-08-17).** Os números existiam e estavam conferidos (288 células válidas
  de 320, nenhuma identifica), mas a §5 não recebe a subseção.

> Os itens fechados anteriores deste tema — gate em η, implementação do ramo,
> corroboração contra nulo, coluna vice-líder, descarte do VAR pequeno — estão
> em `arquivo/nao_gaussiana/README.md` e em `historico_decisoes_secao0.md`.

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
  `arquivo/heterocedasticidade/notas/2026-08-01_robustez_heterocedasticidade.md` §6.
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

- [ ] **Decidir `q`: o critério admissível seleciona 2, e em 2 o instrumento não
  identifica** — *aberto em 2026-08-13; reformulado em 2026-08-17, quando a
  premissa que o sustentava caiu.* O item nasceu dizendo que a fidelidade da
  tradução de `amengual_watson()` decidiria a discordância. **Não decide**, e a
  razão é o inverso do que parecia: `apply_bll = TRUE` não é uma variante caseira
  — é o espaço fatorial da produção **diferenciado**, que é o objeto estacionário
  que Amengual-Watson exige. Medido: os autovetores de `cov(yy)` **são** o
  `lambda` da produção (desvio 2,165e-15) e `cor(PC_k(yy), diff(F_prod)_k)` =
  1,000000 nos cinco fatores.
  - **Portanto `q = 2` vem do caminho admissível e discorda da produção**, e o
    `q = 5` do caminho em níveis não conta a favor: ele roda Bai-Ng num painel
    não-estacionário, que `.claude/rules/identification.md` exclui.
  - **Mas `(5,2)` e `(5,3)` têm ξ_mp 3,809 e 3,149 na amostra completa, abaixo de
    3,84** — conjunto de Anderson-Rubin ilimitado. Pela régua de força do próprio
    projeto, a IRF dessas células é um número sem identificação atrás.
  - ⚠ **O número inconveniente:** essas células dão impactos **maiores** e
    **recuperam o bloco acionário a 90%**, que é o nulo que o paper hoje precisa
    qualificar. É assinatura de instrumento fraco: o denominador de normalização
    cai de 8,426e-05 para 2,471e-05, e `asset_ibov` vai de −1,72 a −22,43. Não
    usar isso como argumento a favor de migrar, nem omiti-lo.
  - **Saídas coerentes, e a escolha é do autor:** manter `q = 5` e declarar a
    discordância como limitação na §3.5; migrar para `(5,2)` assumindo uma célula
    que não passa na régua de força; ou procurar um critério de `q` que não
    dependa de diferenciar o painel. A §3.5 hoje diz que `q = 5` é escolha
    operacional e que a fundamentação segue aberta — o que continua **exato**.
  - Números e as três células lado a lado:
    `notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md`,
    `output/factors/q_selection.{csv,md}`, `output/instrument/mosw_strength_grid.csv`
    (a grade agora cobre `q = 2:r`).
- [ ] **O estágio `di` não reproduz mais a vintage do repo** — *aberto em
  2026-08-17 ao fechar o item de `download_di.py`.* Verificado contra a API do
  GitHub nessa data, o upstream `crdcj/pyield-data` mudou em quatro frentes, e
  nenhuma se resolve editando o script: (i) o asset `b3_di.parquet` **não
  existe mais** — a release publica `b3_futures.parquet`; (ii) o schema passou
  aos nomes crus da B3 (`TradDt`, `TckrSymb`, `AdjstdQtTax`) e as colunas
  `ExpirationDate`, `BDaysToExp` e `CloseRate`, que eram **derivadas**, sumiram;
  (iii) o histórico do asset novo começa em **2018-01-02**, enquanto
  `load_di_panel()` pede desde 2012-06-01, de modo que baixar hoje truncaria
  metade da amostra de Copom; (iv) só as ~30 releases mais recentes são mantidas,
  então `data-2026-02-10`, a vintage que produziu o `di.csv` local, já responde
  404.
  - ⚠ **Consequência que não pode ficar implícita:** `data/raw/di.csv`
    (2026-02-09, **gitignored**) é hoje um insumo **insubstituível**, e dele saem
    as 8 variantes do instrumento. Deve ser tratado como dado de arquivo, com
    cópia fora do repo.
  - **Caminho para fechar:** reconstruir as três colunas derivadas pelo pacote
    `pyield` (instalado, 0.43.1), que traz o calendário de dias úteis da B3, e
    achar fonte para 2012-2017. Antes de adotar, conferir a reconstrução contra o
    `di.csv` atual no período em que se sobrepõem. É decisão de pesquisa.
- [ ] **A padronização do 2º estágio de `amengual_watson()` diverge do original**
  — *aberto em 2026-08-17 pela validação.* `factor_estimation_ls.m` padroniza a
  matriz de resíduos coluna a coluna antes do PCA e do `ssr`; a versão do projeto
  chama `bai_ng_criteria(resid_mat, standardize = FALSE)` e trabalha sobre os
  resíduos crus. É a **única** divergência de substância que a validação
  encontrou — casada a convenção, as duas implementações concordam a 4,163e-16.
  Como é reescala **por coluna**, e não por constante comum, ela **pode** mover o
  `argmin` em outro painel; neste não move.
  - **Por que não foi corrigida junto:** ligar a flag reescreveria os `q_hat`
    registrados em `notas/2026-08-13_selecao_fatores_blocos_fatoriais.md` para 64
    painéis × 2 amostras. É mudança de critério, não de estilo.
  - Fonte: `output/validation/amengual_watson_validation.md` §A3.
- [ ] **`output/panel_experimental/irfs_required_long.csv` traz `asset_ibov` sob o
  tcode antigo** — *aberto em 2026-08-17 ao fechar o `cumsum`.* A rodada é
  histórica e reproduz de propósito a vintage de 106 séries `(7,6)` (o validador
  confere ξ/F 7,65/11,53), então **re-rodar quebraria o que ela documenta**. As
  linhas de `asset_ibov` em h ≥ 1 seguem cumuladas. Decidir entre congelar com
  banner, re-rodar aceitando que a rodada passa a ser de outra vintage, ou
  remover a coluna acionária do artefato.
- [ ] **Remover o shim `scalar_dynamic_factor_compat.R`** — *aberto em 2026-08-17
  ao fechar o `q=1<r`.* O módulo de produção já constrói `M` conforme, e o
  override devolve os mesmos fatores. Ele sobrevive só porque divide por
  `M[1, 1]` enquanto o módulo multiplica por `solve(M)`, e as duas formas diferem
  na última casa (**4,4e-16**); a auditoria `rq_block_dimension_audit` está
  congelada e seus CSVs são citados, então a remoção espera a próxima re-rodada
  da grade. O docblock e o `README` da auditoria já dizem isso.

### Fechados (contexto)

- [x] **`cumsum` do bloco acionário corrigido — FEITO em 2026-08-17.** Entrou o
  **tcode 6** (`x * 100` sem acumular, extensão do projeto sobre o `cumimp.m` de
  AK) e `infer_tcode_from_varnames()` passou as 7 séries `asset_*` de `2L` para
  `6L`. **h = 0 é invariante** — o `cumsum` é no-op e o ×100 é escalar positivo —,
  então o smoke test do `CLAUDE.md` saiu **bit-idêntico** e os três guards de
  `asset_ibov = -1,7226766564462794` continuam válidos. Entregou o que prometia
  em banda e trajetória: razão de largura h36/h0 **27,573 → 0,920** e o pico falso
  do Ibovespa **+17,71% em h=21 → +2,01% em h=8**.
  ⚠ **Duas previsões do item não se confirmaram, e as duas importam.** O tier de
  68% **não melhorou** (sig68 em h ≤ 12 ficou em **20 → 20**, contra os "19 → 35"
  previstos sob a vintage de 106 séries) e o sig90 total do bloco **caiu de 4
  para 2**. E os vereditos `incoerente` **não voltaram**: o conjunto é o mesmo de
  9 séries, nenhuma delas de ações. O custo real de manter a janela h0-6 (decisão
  do autor) foi **quatro índices caírem de `coerente_forte` para `parcial`** —
  `asset_ibov`, `asset_smll`, `asset_idiv`, `asset_imob`.
  Regenerados e conferidos: `irf_coherence_*`, `fig_acoes.pdf` (as outras 7
  figuras saíram **pixel-idênticas**), `spec_sweep_*`, `asset_representation`,
  `var_benchmark`, `jk_sovereign_confound`, `fomc_coincidence`, `model_alessi`,
  `model_nongaussian`. Nenhuma série não-`asset_*` mudou de ponto.
- [x] **`kilian_correction`: teste de singularidade trocado — FEITO em
  2026-08-17.** O `det(M) < 1e-12` virou `rcond()` em `solve_or_pseudo()`, com
  limiar `.Machine$double.eps^(2/3)`. O diagnóstico do item se confirma e vai
  além dele: no DFM `(5,5)` a Lyapunov 900×900 tem `det` **6,29e-19** contra
  `rcond` **1,7e-06** — o ramo do `ginv` era tomado sempre —, e o mesmo defeito
  estava em **SIGMAY** (`det` 1,14e-66, `rcond` 3,85e-05), onde o efeito era o
  oposto: pseudo-inversa numa matriz perfeitamente invertível.
  ⚠ **A afirmação do item de que o aviso "Usando pseudo-inversa para SIGMAY" sai
  em toda rodada NÃO reproduz** em `(5,5)`, e o ganho de tempo previsto também
  não: 0,198 → 0,190 min no gate de produção.
  ⚠ **Um `tryCatch(solve(...))` seria errado e chegou a regredir o benchmark
  VAR**: LAPACK só erra em pivô exatamente zero, então numa Lyapunov de `rcond`
  7,3e-17 o `solve()` retorna em silêncio e o lixo propaga até bandas NA. Onde a
  Lyapunov é numericamente singular a correção **aborta** — SIGMAY não está
  definida ali —, e `var_proxy.R:156` já cai para coeficientes não corrigidos,
  que é a resposta honesta. Efeito medido: ponto do DFM **bit-idêntico**, bandas
  do DFM ≤ **1,65e-06**; no VAR pequeno os pontos não mudam e as bandas se movem
  até 0,076, porque os 17 VARs agora recusam explicitamente a correção em vez de
  metade rodá-la sobre uma pseudo-inversa.
- [x] **`estimate_dynamic_factors()` com `q = 1 < r` corrigido — FEITO em
  2026-08-17.** `M <- diag(sqrt(eigenvals), nrow = q)`; o ramo especial `q == 1`
  foi apagado, porque `solve(M)` passou a cobrir todos os `q`. Confere com o shim
  de auditoria (`all.equal` TRUE). Produção usa `q == r` e não toca este caminho;
  smoke test bit-idêntico e as 224 linhas antigas de `mosw_strength_grid.csv`
  reproduzidas com desvio **0**. A remoção do shim virou item próprio acima.
- [x] **`amengual_watson()` validado contra o MATLAB de SW — FEITO em
  2026-08-17.** `script/validate_amengual_watson.R` transcreve literalmente
  `amengual_watson.m`, `factor_estimation_ls.m` e `bai_ng.m` e roda contra
  `output/validation/amengual_watson_fixture.csv` (o painel de produção), no
  padrão Check A de `validate_hac_kernel.R` — não há MATLAB nem Octave aqui.
  **Veredito: tradução fiel.** `q_hat` 5 contra 5, e casada a padronização do 2º
  estágio o gap é a constante `log(147/146)` = **0,0068259651** com dispersão
  **4,163e-16**, que é só desvio padrão populacional contra amostral. A
  divergência restante virou item próprio acima. Fonte:
  `output/validation/amengual_watson_validation.md`.
- [x] **`download_di.py`: gate de sanidade posto, vintage impossível de fixar —
  FEITO em 2026-08-17.** O script agora resolve a release pela API (com override
  por `DI_RELEASE_TAG`), grava a tag em `data/raw/di_release_tag.txt`, e aborta
  alto se faltar coluna obrigatória, se houver menos de 100 mil linhas, se
  `CloseRate` for todo nulo ou se a cobertura não abraçar 2012-06-01 a 2026-02-01.
  A perna de vintage **não fecha por código**: o upstream apagou o asset, mudou o
  schema, truncou o histórico em 2018 e poda releases. Com o upstream atual o
  script aborta com o diagnóstico correto em vez de gravar painel truncado, e o
  `di.csv` local fica intacto. O resto virou item próprio acima.
- [x] **Remoção do `install.packages()` de `instrument_diagnostics.R` confirmada
  pelo autor — 2026-08-17.** O laço instalava pacotes no momento do `source()`,
  contra a regra "fail loud" do `CLAUDE.md`. Num clone limpo o script agora
  aborta com erro de pacote ausente; `broom` e `lmtest` nem eram usados ali.
  Ergonomia de máquina nova pertence a um `README`/`renv`, não a um script de
  diagnóstico.
- [x] **Renomes registrados no acervo — FEITO em 2026-08-17.**
  `registro/mapa_renomeacoes.md` passou a ser o lugar único do mapa, cobrindo
  2026-08-17 (`impulse_responde.R` → `impulse_response.R`,
  `R/data_download/fomc_dates.R` → `script/fomc_dates.R`), 2026-08-11, 2026-08-02
  e 2026-08-05, mais os arquivos cuja **existência** mudou. Os 12 arquivos de
  `notas/` e 4 de `pareceres/` ficam **verbatim** e são lidos por ele. Editados em
  lugar, por serem documentos vivos: `metodo.md`, `estrutura_paper_v2.md`,
  `justificativa_uso_yield-6m.md` e `output/instrument/olea_alignment_audit.md`
  (que não é corpo gerado — `mosw_strength_grid.R` só o cita).
  ⚠ O blockquote de leitura de `pareceres/council_2026-08-10.md` era
  project-authored e estava **stale**; foi atualizado, e o corpo do parecer não
  foi tocado. Em `historico_decisoes.md` §4.1 entrou nota de leitura em vez de
  edição cirúrgica, porque os **números de linha** citados ali também
  envelheceram e não foram re-verificados.

- [x] **`tab:first_stage` cortada para o `.tex` — FEITO em 2026-08-14**, com o
  que o paper volta a ter uma tabela de força depois da saída da `tab:rq_sweep`.
  A §3.6 ganhou a Tabela 1: três linhas — surpresa bruta do DI → + ortogonalização
  predeterminada → + filtro de sinal, a variante de produção — × duas janelas,
  com β̂/EP(HC1)/p só na amostra completa, que é o que a fonte carrega. Números
  transcritos de `output/instrument/instrument_diagnostics_report.md` §1 e de
  `output/instrument/mosw_strength_grid.csv` (`sample=pre_covid, r=5, q=5`),
  ambos de 2026-08-13, com um comentário no `.tex` apontando para os dois. O
  parágrafo novo da §3.6 reporta o número inconveniente: **na janela pré-COVID a
  surpresa bruta é a mais forte das três** (ξ_mp 14,86 contra 10,99 da produção),
  de modo que a variante de produção se justifica pela fidelidade a
  Bauer-Swanson + Jarociński-Karadi, não pela estatística de força. Compila
  limpo, 25 chaves, sem AR e sem a régua de 3,84.
- [x] **Documentos de governança ressincronizados com a produção corrente —
  FEITO em 2026-08-14.** A migração de 2026-08-13 deixou quatro `.md` de regra
  falando da vintage de 106 séries, e todos foram corrigidos contra o output:
  o smoke test de `CLAUDE.md` (rodava `(7,6)` e o corte `src[1:153]` já nem
  compilava; agora é `(5,5)`, `src[1:156]`, e os cinco impactos foram
  **re-rodados**, batendo `irf_coherence_h.csv` dígito a dígito); a contagem de
  células Rigobon em nível bruto (**21/17 -> 24/15**); o gate não-gaussiano em
  `.claude/rules/identification.md` (**3 de 6 e 5 de 6 -> 0 de 5 e 2 de 5**, e
  `q=6 -> q=5`); e `.claude/rules/data.md`, que dizia 106 séries e tratava a
  Selic como controle nulo com `F` máximo de 2,49. **Lição de manutenção:** os
  números colados nesses arquivos envelhecem em silêncio porque nada os
  reexecuta, então cada um agora aponta para o artefato que o produz.
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
