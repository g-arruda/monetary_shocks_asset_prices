# Pendências

**Última revisão:** 2026-09-01 (abertas duas extensões de alta prioridade para
tratar a coincidência Copom--FOMC; paper integralmente sincronizado com a produção
DFM em `p=4`; benchmark VAR observável preservado em `p=2`; máscaras
rederivadas mantidas nos diagnósticos, mas omitidas da exposição do paper por
decisão editorial).
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
| Dimensão | **r = 5, q = 5**, VAR(p = 4) nos fatores; `r` por Bai--Ng IC2 BLL, `q` provisório; `p=4` pelo AIC com tendência em amostra comum (`T=141`), BIC seleciona `p=2` |
| Painel | **111 séries**, variante `drop_setor_externo__eua__credito__imoveis`, 2013-01 a 2025-09 (153 observações alinhadas; 149 inovações fatoriais após p=4) |
| Inferência | wild bootstrap Gonçalves-Kilian, Kilian (1998) só no DGP do bootstrap; nboot = 800, seed 123, bandas 68/90, h = 0-48 |
| Força | ξ_mp/F_rob,mp = **5,240158/10,060922** full e **7,478324/11,874945** pré-COVID; raiz máxima 0,968126 full e 0,992483 pré-COVID; ambas estáveis |
| Benchmark VAR do paper | `{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}` em nível, com constante e tendência linear; `p=2` pelo AIC em amostra comum de `T=141`; respostas `C_h B_1`; `xi_mp=6,797335`, raiz máxima `0,965424`; AR/MOSW 68%/90% com NW(0) |

Esta tabela combina a produção vigente do DFM com a produção corrente do
benchmark VAR do paper. O código, os artefatos em `output/var/`, a figura e a
subseção weak-IV foram migrados em 2026-08-22.
O painel-base de 106 séries continua em arquivo separado somente para reproduzir
as grades históricas. A recomendação intermediária de 123 séries `(4,3)` foi
superada pela decisão e migração de 2026-08-13.

Na reestimação dos diagnósticos de validade em `p=4`, as regressões diárias
continuam sem confirmar confundimento soberano ou do FOMC. Contudo, a máscara
global rederivada do exercício FOMC reduz `xi_mp` para **3,671**, abaixo de
3,84; pela regra pré-fixada, o veredito passou a **sinal fraco de contaminação
FOMC**. Esta ressalva permanece no registro e nos artefatos, mas o paper reporta
apenas os exercícios que mantêm fixa a máscara de produção, por decisão do
autor em 2026-08-25.

O paper e `output/irf/irf_section.md` usam a produção DFM `(5,5,4)`. Grades
históricas de painel, `(r,q)` e instrumento condicionadas a `p=6` permanecem
evidência datada e não foram reestimadas. O benchmark VAR em níveis continua
separado, em `p=2`, com seus conjuntos AR/MOSW próprios.

---

## Índice de itens abertos

| Tema | Item | Observação |
|---|---|---|
| B | Reavaliar o argumento de transmissão via prêmio de risco | prioridade alta; nenhuma decomposição UIP ou IRF derivada será executada sem desenho diretamente respaldado pela literatura e aprovação do autor |
| B | Purificar as duas pernas do filtro com surpresas intradiárias do FOMC | **prioridade alta**; mede diretamente o canal do Fed e rederiva a máscara JK; depende de localizar e validar fatores de alta frequência com timing compatível |
| B | Sensibilidade sem superquarta | **prioridade alta**; zera as 24 coincidências retidas, diagnostica força e IRFs e permanece variante de sensibilidade, não candidata automática à produção |
| B | Acrescentar um nível do S&P 500 à bateria de placebos | desmembrado em 2026-08-14; muda o painel de 111 para 112 e obriga a re-rodar a produção |
| B | Decompor a curva entre expectativa e prêmio (diário vs. mensal) | blindspot 2026-08-12, prioridade alta; depende da correção do Tema E |
| B | A amplificação 5a/6m é do choque ou de Λ? | blindspot 2026-08-12; teste discriminante do item acima |
| E | Decidir `q`: o critério admissível diz 2, a força diz que 2 não identifica | evidência completa em `notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md`; produção intocada |
| E | O estágio `di` não reproduz mais a vintage do repo | asset renomeado, schema mudou, histórico começa em 2018, releases podadas; `data/raw/di.csv` virou insumo insubstituível |
| E | Padronização do 2º estágio em `amengual_watson()` | única divergência de substância contra o MATLAB; mexer nela reescreve `q_hat` de 64 painéis × 2 amostras |
| E | `output/panel_experimental/irfs_required_long.csv` com `asset_ibov` sob o tcode antigo | rodada histórica de 106 séries `(7,6)`; re-rodar quebraria o que ela documenta |
| E | Remover o shim `scalar_dynamic_factor_compat.R` | o módulo já corrige `q=1<r`; espera a próxima re-rodada da auditoria congelada |
| B | Leave-one-out e leave-cluster-out sobre a IRF | **prioridade 2**; o LOO existente é só sobre ξ_mp. Reabre a tabela reunião-a-reunião cortada em 2026-08-10 |
| B | Tabela cross-instrumento do bloco-manchete | **prioridade 3**, quase pós-processamento: os pontos das 8 variantes já estão em `spec_sweep_irf_long.csv` |
| B | Preditor fiscal predeterminado na RHS de Bauer-Swanson | 9ª variante de diagnóstico, nunca troca de produção; depende de dado Focus que `focus_fred.R` ainda não baixa |
| E | Documentar o bootstrap e devolver a contagem de falhas | a suspeita de fatores fixos é falsa; o que sobra é `Idio` fixo e o fallback silencioso para o ponto |
| E | `paper_numbers.tex` gerado pela pipeline | higiene preventiva; o paper já foi sincronizado manualmente, mas continua sujeito a nova divergência numérica |
| E | Dois artefatos ainda documentam `asset_*` em tcode 2 | anteriores à correção de 2026-08-17; rótulo, não cálculo |

---

## A. Texto do paper


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

### Fechados (contexto)

- [x] **Expectativas fiscais Focus — teste isolado concluído em 2026-09-01.**
  Três previsões anuais para o ano seguinte (DLSP, resultado primário e
  nominal), em nível, ampliam experimentalmente o painel de 111 para 114
  séries sem alterar a produção. A célula fixa `(5,5,4)` permanece estável e
  ξ_mp sobe de 5,24 para 5,81 (pré-COVID: 7,48 para 8,12), mas continua abaixo
  de 10. DLSP esperada cai com banda de 90% sem zero em h=12, e o resultado
  nominal esperado cai em h=0--6; portanto não há evidência de deterioração
  fiscal esperada. Nota: `notas/2026-09-01_teste_expectativas_fiscais.md`;
  artefatos: `output/fiscal_expectations/`.

- [x] **Revisão integral do paper concluída em 2026-08-25.** Resumo, abstract,
  introdução, metodologia, resultados e conclusão usam 111 séries,
  `(r,q,p)=(5,5,4)` e as manchetes correntes de 3,74%, 24,5 pb, 30,7 pb e
  74,8 pb. A prosa defensiva e as alegações fortes sobre UIP ou dominância
  fiscal saíram; o título foi preservado enquanto a decomposição do wedge de
  UIP permanece aberta. Fonte: `paper/paper_anpec.tex` e `mudanca_texto.md`.

- [x] **Exposição dos diagnósticos de máscara condensada por decisão editorial
  em 2026-08-25.** As subseções sobre risco soberano e FOMC preservam os testes
  com a máscara de produção fixa e omitem sua rederivação. Os resultados
  completos continuam nos artefatos e no registro metodológico.

- [x] **Seções 3--5 sincronizadas com a produção DFM em `p=4` em
  2026-08-25.** Metodologia, resultados e robustez agora coincidem com o cache
  de coerência, os gates e os diagnósticos correntes. A rodada alterou apenas
  texto e criou `notas/2026-08-25_sincronizacao_secoes_3_5_p4.md`; não houve
  nova estimação.

- [x] **Aplicação dos diagnósticos MOSW ao DFM qualificada.** A introdução e a
  §3.6 agora tratam $\xi_{mp}$ como diagnóstico baseado em \cite{montielolea},
  com equivalência algébrica condicional e sem transferir cobertura AR ao DFM.
  Fontes: `paper/paper_anpec.tex`,
  `notas/2026-08-22_var_olea_estacionario.md`.
- [x] **Robustez weak-IV integrada à §5.** `sec:weak_iv` separa o DFM em
  `p=4` do benchmark observável em níveis, com constante e tendência linear,
  `p=2` pelo AIC, respostas `C_h B_1` e conjuntos AR/MOSW de 68%/90% sob
  NW(0). Fonte: `notas/2026-08-22_var_niveis_aic_tendencia.md`.
- [x] **Invertibilidade separada da exogeneidade na §5.** A subseção ancora
  definição, SVAR-IV versus LP-IV e interpretação de variáveis omitidas em
  \cite{stockwatson2018}. Na produção em `p=4`, as regressões sobre inovações
  futuras dão 0,771/0,550 e o menor `p_boot` do teste de Granger é 0,268; são
  condições necessárias, não prova de invertibilidade.
- [x] **Máscaras rederivadas preservadas como diagnóstico, não como exposição
  principal.** No exercício soberano, $\xi_{mp}$ vai de 5,24 a 5,80 e 6,49 nos
  valores e cai a 3,44 na máscara rederivada. No FOMC, passa a 5,33 nos valores
  e cai a 3,67 na máscara; o paper reporta somente as variantes com seleção
  fixa.
- [x] **Comparação cambial colocada na mesma base de choque.** O impacto é
  reportado apenas em percentual: 3,74% por 50 pb e 7,48% por 100 pb sob
  reescala linear, contra apreciação de 3,4% a 5,6% em
  \cite{goncalves2025}, com diferenças de desenho explicitadas.
- [x] **§4 migrada para 111 séries `(5,5,4)` e conferida em 2026-08-25.** As
  seis subseções e legendas usam estimativas de impacto do CSV e do cache
  correntes. As bandas permanecem como incerteza descritiva, com a cautela
  imposta por `xi_mp=5,24` na amostra completa.
- [x] **Selic, horizonte comum e cinco moedas incorporados à §4.** A Selic sobe
  24,1 pb no impacto e o CDI não aparece. As manchetes usam `h=0`, e USD, EUR,
  CNY, INR e ARS entram como percentuais das respectivas médias amostrais.
- [x] **Agregados monetários omitidos por decisão editorial.** O bloco é
  heterogêneo na produção corrente e não serve diretamente à contribuição sobre
  ativos, de modo que não ganhou parágrafo nem figura na §4.
- [x] **Reversão de médio prazo qualificada na passagem substantiva.** A §4
  trata a reversão como dinâmica conjunta sensível a `p`, sem atribuí-la a um
  modo quase unitário ou usá-la como confirmação independente de mecanismo.
  Fonte: `output/factors/factor_stationarity.md`.
- [x] **Preços reescritos sem antecipar a comparação cross-instrumento.** A §4
  separa a alta imediata do IPP das respostas posteriores dos preços ao
  consumidor e não classifica o padrão como *price puzzle*. A comparação
  cross-instrumento foi rodada em 2026-08-18 e a frase-marcador de §4.5 foi
  substituída pelo resultado — ver o item fechado do Tema D.
- [x] **Bloco acionário e IMAT reescritos.** Os sete índices são retornos
  mensais sem acumulação, com impactos entre −2,70% e −0,07%. O amortecimento do
  IMAT é associado à receita denominada em dólar, sem depender de ajuste rápido
  do preço de exportação.
- [x] **Não haverá parágrafo nem subseção de Limitações.** Decisão do autor em
  2026-08-18. As cautelas sobre instrumento fraco, reversão, preços, crédito e
  mecanismo cambial ficam nas passagens substantivas correspondentes, e
  Limitações sai da composição pendente da §5.
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
  médio prazo foi refeita para `(5,5)` na migração da §4 em 2026-08-18.
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
  |ponto|/meia-banda-68% (≈|t|) ficou no diagnóstico depois da decisão de não
  criar Limitações. Oito figuras, todas a h=36.
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
- [x] **Benchmark VAR pequeno substituído integralmente em 2026-08-22.** A
  rodada concluída traduz Olea com IPCA em nível, quatro séries em diferença,
  BIC selecionando `p=1`, pontos `C_h B_1` e AR 68%/90% com NW(0). A decisão
  posterior do autor no mesmo dia superou seu uso como benchmark do paper. A
  vintage permanece apenas em `notas/2026-08-22_var_producao_unica.md`.
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

- [ ] **Reavaliar o argumento de transmissão via prêmio de risco** — o co-movimento entre câmbio, CDS, EMBI+ e curva é compatível com o canal, mas não o identifica.
  Não construir prêmio UIP nem derivar IRFs. Procurar apenas um desenho publicado diretamente comparável.
  Sem esse desenho, manter “compatível com prêmio de risco” e reconsiderar o título do artigo.
- [ ] **Purificar as duas pernas do filtro com surpresas intradiárias do FOMC** —
  *aberto em 2026-08-28; **prioridade alta**.* Substituir as proxies diárias
  ruidosas (`d_ust2`, `r_sp500`) por fatores de surpresa do FOMC medidos em
  janela estreita e com timestamp compatível com o fechamento da quarta-feira:
  no mínimo, surpresa de taxa e componente de *path/forward guidance*;
  idealmente, uma decomposição que também separe choque monetário de notícia do
  Fed. Primeiro documentar fonte, cobertura, timezone, janela, reuniões
  agendadas/não agendadas e casamento exato com os 95 dias Copom; ausência ou
  incompatibilidade temporal deve abortar, nunca virar zero.
  **Entrega:** residualizar separadamente `e_di_bs` e `e_ibov_bs` nos fatores
  intradiários, rederivar a máscara JK sobre os dois resíduos e construir uma
  variante mensal exclusivamente diagnóstica. Comparar com
  `z_jk_bs_purif`: dias que entram/saem, coincidências FOMC preservadas,
  `xi_mp`, `F_robust_mp`, impacto não normalizado em `yield_6m`,
  `denom_vs_prod` e IRFs de `yield_2y`, `yield_5y`, `cambio_usd`,
  `asset_ibov`, `embi_perc` e `cds_5y`, nas amostras cheia e pré-COVID.
  - ⚠ O objeto decisivo é a **seleção da máscara**, não apenas a correlação da
    surpresa de DI com retornos americanos. Não basta acrescentar controles à
    regressão diária mantendo `jk_bs` fixo.
  - ⚠ A variante é diagnóstico até que fonte, timing, força e estabilidade
    das IRFs sejam validados. Não alterar `DEFAULT_VARIANT` nem interpretar uma
    IRF maior quando `denom_vs_prod` cai como efeito econômico maior.
  - **Relação com o item seguinte:** este é o teste mais informativo sobre o
    mecanismo de contaminação; a sensibilidade sem superquarta pode ser rodada
    antes, mas não o substitui.
- [ ] **Construir uma sensibilidade sem superquarta** — *aberto em 2026-08-28;
  **prioridade alta**.* Criar uma variante diagnóstica que zere os dias retidos
  em que Copom e FOMC coincidem e reestimar o DFM sem alterar o instrumento de
  produção. O corte remove hoje **24 dos 62 dias retidos** e **35,5% de
  `sum(abs(z))`**; em 2025, sete das oito reuniões coincidem, de modo que a
  leitura deve separar contaminação, perda de força e mudança de composição
  temporal.
  **Entrega:** registrar datas e peso removidos; reportar meses não nulos,
  `xi_mp`, `F_robust_mp`, impacto não normalizado em `yield_6m` e
  `denom_vs_prod`; comparar pontos e bandas de `yield_2y`, `yield_5y`,
  `cambio_usd`, `asset_ibov`, `embi_perc` e `cds_5y` em `h=0--48`, com destaque
  para impacto, sinal e persistência. Rodar primeiro pontos e diagnósticos de
  força; só então decidir se o custo do bootstrap completo é informativo.
  - ⚠ É análise de sensibilidade, **não** candidato automático a instrumento
    de produção: excluir superquartas pode selecionar um regime histórico
    distinto e enfraquecer severamente a proxy.
  - ⚠ Não restaurar nem citar o antigo Teste 4 dividido em metades, removido em
    2026-08-10. Este é um exercício novo, pré-especificado, com artefatos e
    diagnósticos próprios; não usar Anderson--Rubin do VAR para inferência do
    DFM.
  - **Relação com o item anterior:** pode funcionar como triagem de baixo custo
    e indicar se vale adquirir os fatores intradiários, mas um resultado estável
    não absolve o instrumento de contaminação pelo FOMC.
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

- [ ] **Leave-one-out e leave-cluster-out sobre a IRF, não só sobre ξ_mp** —
  *aberto em 2026-08-18; procedência `checklist_problemas_sdfm_weak_iv.md`
  §5.1-5.2; **prioridade 2**.* O leave-one-out que existe
  (`script/xi_mp_robustness.R`) recomputa **apenas** `wald_joint` e mantém o
  DFM fixo, de modo que ninguém sabe se uma reunião determina o impacto sobre
  câmbio, CDS ou EMBI. Os números de força já estão medidos e não bastam:
  full 6,271 com mínimo 4,888, **0 de 147** descartes abaixo de 3,84 e
  **147 de 147** abaixo de 10. **Entrega:** distribuição do impacto `h=0` de
  `cambio_usd`, `cds_5y` e `embi_perc` sob descarte de uma reunião por vez, e
  sob descarte de blocos — COVID, ciclo eleitoral, transições de governo,
  mudança de arcabouço fiscal —, que é mais informativo que “pré-COVID contra
  amostra cheia”.
  - **Reabre a tabela reunião-a-reunião cortada em 2026-08-10** (Teste D),
    por decisão do autor em 2026-08-18. O corte foi por **falta de consumidor**
    — a ressalva de concentração saiu do paper na mesma data — e não por
    defeito; este item é o consumidor novo. O caminho barato é
    `output/instrument/fomc_coincidence_days.csv`, que já traz as 95 reuniões
    com surpresa, resíduo BS, máscara, perna de ações e bloco americano:
    faltam as colunas de câmbio, EMBI e CDS.
  - ⚠ **`CLAUDE.md` e `historico_decisoes.md` §2.4 declaram o Teste D
    não-citável.** Enquanto a tabela nova não existir e não for validada, essa
    proibição continua valendo; quando existir, os dois arquivos mudam **junto**
    com a entrega, e a tabela nova é outra tabela, não a restauração daquela.
  - ⚠ O `xi_mp_robustness.R` mantém o DFM fixo de propósito. Um LOO sobre a IRF
    exige decidir se reestima o DFM a cada descarte, e o custo muda de segundos
    para horas se reestimar com bootstrap. Rodar o ponto primeiro.

- [ ] **Tabela cross-instrumento do bloco-manchete** — *aberto em 2026-08-18;
  procedência `checklist_problemas_sdfm_weak_iv.md` §19; **prioridade 3**, e é
  quase pós-processamento.* A escada de instrumentos foi feita para o bloco de
  **preços** em 2026-08-18 (Tema D, fechado) e a `tab:first_stage` mostra as
  três camadas em **força**, mas o resultado-manchete nunca foi mostrado por
  variante. Os pontos já estão em `output/irf/spec_sweep_irf_long.csv`, e o que
  eles dizem é favorável: na célula de produção (cheia, `r5q5`, `yield_6m`),
  **as 8 variantes dão câmbio, CDS e EMBI positivos no impacto**, com a
  produção sendo a **menor das oito** (0,158 / 32,5 / 0,262, contra 0,256 /
  61,4 / 0,535 em `z_jk_purif`). **Entrega:** tabela de `h=0` por variante para
  `cambio_usd`, `cds_5y`, `embi_perc` e os vértices, escrita na §5.
  - ⚠ **O número inconveniente entra junto.** Nas células pré-COVID
    bootstrapadas da etapa 2 (`output/irf/spec_sweep_stage2.md`), câmbio, CDS e
    EMBI **não são sig90 em variante nenhuma**. A janela que tem força é a que
    não tem significância — o mesmo padrão que a escada de preços encontrou.
  - ⚠ As 8 são variantes da **mesma** surpresa de DI em dia de Copom. Isso
    discrimina a construção do instrumento, **não** o esquema de identificação,
    e a §4.5 já usa exatamente essa qualificação.
  - ⚠ Comparar magnitudes entre variantes carrega o denominador da normalização
    (`denom_vs_prod`): parte de uma resposta maior é aritmética, não economia.

- [ ] **Preditor fiscal predeterminado na ortogonalização Bauer-Swanson** —
  *aberto em 2026-08-18; procedência `checklist_problemas_sdfm_weak_iv.md`
  §5.3.* A bateria de confundimento que existe
  (`script/jk_sovereign_confound.R`) testa **realizações de preço de risco
  soberano** na janela do evento, e absolve a máscara. Nenhum teste toca
  notícia fiscal como tal, e a razão é de dado: `R/data_download/focus_fred.R`
  baixa exatamente três séries — Focus IPCA 12 meses, Focus Selic ano seguinte
  e FRED `DGS2` — de modo que a RHS pré-evento de `build_variants.R:301-307`
  **não tem preditor fiscal nenhum**. As três séries fiscais do painel
  (`fiscal_dbgg`, `fiscal_dlsp`, `fiscal_primary_balance`) são mensais e de
  vintage corrente, e `script/panel_composition_experimental.R:331` já registra
  que elas não constituem teste de informação disponível em tempo real.
  **Entrega:** revisão do resultado Focus de resultado primário/dívida (mesmo
  endpoint Olinda `ExpectativasMercadoAnuais` que já traz a Selic) entrando na
  RHS pré-evento como **9ª variante de diagnóstico**, com ξ_mp e o impacto das
  três manchetes ao lado da produção.
  - ⚠ **Variante de diagnóstico, nunca troca de produção.**
    `.claude/rules/identification.md` proíbe re-arquitetar o núcleo em silêncio,
    e a produção se justifica por fidelidade a Bauer-Swanson + Jarociński-Karadi,
    não por força — como a §3.6 já diz.
  - ⚠ **A regra que governa é a do §5.3 do checklist:** só informação
    **predeterminada** até o fechamento da quarta entra como controle. Notícia
    fiscal que ocorre na quinta, depois do Copom, é pós-tratamento e não pode
    ser “controlada” — ali a saída é estreitar janela, excluir evento ou fazer
    análise narrativa, que é o item do leave-one-out acima.
  - ⚠ Este item e o do SVAR-IV respondem a **referees diferentes** (§40): um à
    acusação de proxy fraca, o outro à de proxy fiscal. Nenhum substitui o
    outro.

### Fechados (contexto)

- [x] **Benchmark VAR migrado para níveis, AIC e tendência linear em
  2026-08-22.** Código, inferência, figura, paper e memória usam as cinco séries
  em nível, constante e tendência, `p=2` pelo AIC comum (`T=141`), 151 resíduos,
  `xi_mp=6,797335` e raiz máxima `0,965424`. A validação coincide com
  `vars::VARselect` a `2,31e-14` e preserva o fixture oficial. Nota:
  `notas/2026-08-22_var_niveis_aic_tendencia.md`.

- [x] **Benchmark estacionário e inferência weak-IV, concluídos em 2026-08-22
  e superados como produção do paper no mesmo dia.** A rodada usa IBC-Br, IPCA
  em nível e IBC-Br/yield/câmbio/CDS em diferença. O BIC literal seleciona
  `p=1`, e a inferência é AR 68%/90% com NW(0). Essa vintage não é mais
  produção. ⚠ Nenhum dos exercícios testa a validade da proxy. Nota:
  `notas/2026-08-22_var_producao_unica.md`.

- [x] **Varredura de `p` no impacto, com bandas — FEITA em 2026-08-18.** Grade
  pré-registrada `p ∈ {2,3,4,6}`, quatro células com 800 réplicas na amostra
  completa. **O impacto não se move:** `share_in90 = 1` nos 30 pares
  (variável × `p`) em `h ≤ 36` e em `h ≤ 12`, **0 material**, e a curva, o
  câmbio, o EMBI+ e o CDS excluem zero a 90% no impacto nas quatro células. **A
  reversão de médio prazo se move** (`yield_6m` cruza em `h = 22` sob `p = 6` e
  `h = 15` sob `p = 2`), de modo que o item **fecha corroborando a §4**.
  ⚠ **A ressalva que este item carregava estava errada:** BIC e HQ selecionam
  `p = 2`, não `p = 1` — AIC segue em `p = 4` e `p = 6` não é argmin de nenhum
  dos três. Corrigido também em `script/factor_stationarity.R:100`.
  ⚠ **Números inconvenientes:** `p = 6` é a célula **mais forte** da grade
  (ξ_mp 6,27 contra 5,16-5,77), fato reportado e não justificativa, porque a
  §3.5 proíbe escolher dimensão por força; nenhuma célula alcança ξ_mp ≥ 10; e
  `asset_ibov` perde até 80% do impacto sem sair da banda. A reescrita da
  justificativa de `p = 6` na §3.4 virou item próprio do Tema A.
  Nota: `notas/2026-08-18_varredura_p`; saídas em `output/factors/p_selection.*`.
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

*Nenhum item aberto neste tema.*

### Fechados (contexto)

- [x] **Comparação cross-instrumento do bloco de preços sob (5,5) — FECHADA em
  2026-08-18.** Desenho executado: **escada de três instrumentos aninhados**
  (`z_bruto` → `z_bs_purif` → `z_jk_bs_purif`), por decisão do autor, e não a
  varredura das oito variantes. Na amostra cheia a corcova de h2-h8 é positiva
  nos três degraus em 8 de 8 séries de preço; a residualização Bauer-Swanson a
  **amplifica** (16/16 células) e o filtro de sinal a **atenua** (8/8 na cheia,
  −34% no headline), o que **contradiz** o ponto 2 da nota de 07-12. Nenhum
  degrau alcança ξ_mp 10 na cheia (5,271/4,368/6,271) e os três passam de 10 no
  pré-COVID (14,862/13,982/10,993). ⚠ O pré-COVID troca a corcova por uma falha
  de médio prazo: as seis medidas pontuadas saem `incoerente` na célula
  bootstrapada nova, e o único sig90 do bloco lá é `price_ipp` em h1-h2.
  Nota: `notas/2026-08-18_precos_cross_instrumento.md`; script
  `script/price_cross_instrument.R`.

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
  - **Rodada de 2026-08-18 — a checagem no desenho do próprio AK, que faltava.**
    A nota 4 de Alessi-Kerssenfischer justifica `q = r` por evidência ("results
    are virtually identical whether or not `q < r`"), e a Figura A3 é o que a
    sustenta: benchmark com bandas, alternativas em ponto. `script/q_selection.R`
    passou a construir essa figura para `r = 5`, com `q = 5, 4, 3, 2` e regra de
    leitura pré-registrada. **A afirmação não replica na escala normalizada:**
    0 de 18 pares (variável × `q`) saem imateriais, 13 saem materiais.
    - **Mas a razão está medida, e é o denominador.** `denom_ratio` cai para
      0,646/0,293/0,319 em `q = 4/3/2`; mantida a normalização fixa no
      denominador da produção, o resto do gap no impacto fica entre 0,59 e 1,17
      em `yield_2y`, `yield_5y`, `cambio_usd` e `cds_5y`, e `cambio_usd` e
      `cds_5y` voltam a `share_in90_resc` = 1,000 nas seis células. **As duas
      células materiais em todas as variáveis são exatamente `q=3` e `q=2`, as
      duas com ξ_mp abaixo de 3,84.** `q = 4` fica dentro da banda de 90% em
      todos os 37 horizontes em 5 das 6 variáveis.
    - ⚠ **Números inconvenientes:** `cambio_usd`, a variável-manchete da §4, sai
      da banda já em `h = 0` mesmo sob `q = 4` (0,28481 contra
      [0,09207 ; 0,24927]); e `asset_ibov` é a única variável cuja **coluna
      estimada** muda de verdade, fator 3,8×/4,0× depois de descontado o
      denominador. **E o contra-número:** esse fator de 4 reescalado ainda cabe
      na banda de impacto da produção (−6,577 contra piso −6,910), porque a
      banda do bloco acionário é ~4× o ponto.
    - **O que isso muda na decisão:** a saída "manter `q = 5` e declarar" segue
      viva, mas **não** pode ser escrita invocando AK — não se pode dizer que os
      resultados são virtualmente idênticos, porque não são na escala
      normalizada. O que se pode dizer é que as células alternativas divergem por
      **força de instrumento** e que as duas que mais divergem não passam na
      régua de AR. Nota: `notas/2026-08-18_q_checagem_figura_a3.md`.
  - Números e as células lado a lado:
    `notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md`,
    `notas/2026-08-18_q_checagem_figura_a3.md`,
    `output/factors/q_selection.{csv,md}`, `q_selection_paths.{csv,pdf}`,
    `q_selection_containment.csv`, `output/instrument/mosw_strength_grid.csv`
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

- [ ] **Documentar o algoritmo do bootstrap e devolver a contagem de falhas** —
  *aberto em 2026-08-18; procedência `relatorio/checklist_problemas_sdfm_weak_iv.md`
  §22.* A suspeita do checklist — de que fatores e loadings ficariam fixos e as
  bandas seriam *conditional-on-estimated-factors* — **não procede, e o
  contrário é que precisa ser escrito**. `R/modeling/impulse_response.R:534-630`
  reestima por réplica: PCA/BLL sobre `X_boot` (`:577`), `Lambda_boot`,
  `sy_boot`, `K_boot`, `M_boot`, o VAR dos fatores, a identificação
  `H = (Z'η)/(Z'Z)` com o instrumento também wild-bootstrapado pelo mesmo `rr`
  (`:617-623`), e a normalização de +50 pb pelo denominador **da própria
  réplica** (`:129-133`). É o *full re-estimation bootstrap* que o checklist
  pede como ideal, e o paper não diz isso em lugar nenhum.
  - ⚠ **O que de fato fica fixo é o idiossincrático.** `X_boot = Chi_boot + Idio`
    com o mesmo `Idio` em todas as réplicas (`:549-550`). É fiel ao
    `DFMest_BLL_Boot.m` de Alessi-Kerssenfischer, mas significa que a incerteza
    idiossincrática **não está nas bandas** — declarar, não corrigir.
    `r`, `q` e `p` também são fixos por réplica, sem reseleção.
  - ⚠ **Réplica que falha vira a estimativa pontual em silêncio** (`:628`,
    `irf_boot[, , b] <<- irf_point`), o que concentra massa no ponto e
    **estreita** as bandas. `validate_bootstrap_results()` (`:863-885`) conta as
    falhas e avisa acima de 10%, mas **o retorno é descartado** (`:633`, com
    comentário no código dizendo exatamente isso). A célula de **produção está
    protegida** — `script/validate_production_spec.R` captura os warnings e
    exige `failure_count == 0` (`:135`, `:152`) —, então isto é higiene, não
    defeito de manchete. O risco vive nas células **não-gated**: pré-COVID,
    `irf_spec_stage2`, `q_selection` e os painéis experimentais.
  - **Entrega:** a contagem devolvida no objeto de resultado e impressa nos
    relatórios gerados, mais o parágrafo de algoritmo na §3 do paper. O
    `var_proxy.R:147/193/210` já conta falhas e devolve `n_failed` — é o padrão a copiar, não a inventar.

- [ ] **`paper_numbers.tex` gerado pela pipeline** — *aberto em 2026-08-18;
  procedência `relatorio/checklist_problemas_sdfm_weak_iv.md` §28.* Não existe
  **nenhum** `\newcommand` numérico em `paper/paper_anpec.tex`: os dois que há
  são de layout (`\m`, `\mat`). Todo número do texto continua digitado à mão.
  A revisão integral de 2026-08-25 eliminou a divergência então existente, mas
  não eliminou sua causa mecânica. **Entrega:** um script de pós-processamento
  que leia `output/irf/irf_coherence_h.csv` e os gates correntes de produção,
  escreva os `\newcommand` das manchetes, do painel e da força e substitua as
  transcrições manuais no `.tex`.
  - **Estado da dependência:** o paper já está sincronizado e oferece os
    primeiros consumidores. O item agora é higiene preventiva contra a próxima
    migração, não bloqueador da redação corrente.
  - ⚠ Só entram números que **vêm da estimação**. Contagens editoriais e valores
    citados de terceiros (\cite{goncalves2025}, por exemplo) continuam
    digitados, e misturar os dois anula a garantia.
  - ⚠ O gerador escreve um arquivo **novo**; não pode editar `paper_anpec.tex`,
    que é escrito à mão. Vale aqui a regra de `.claude/rules/writing.md` sobre
    corpo gerado contra corpo manual.

- [ ] **Dois artefatos ainda documentam `asset_*` sob o tcode antigo** — *aberto
  em 2026-08-18; procedência `relatorio/checklist_problemas_sdfm_weak_iv.md`
  §26, achado na auditoria de escala que ele motivou.* A correção de 2026-08-17
  moveu as 7 séries `asset_*` de tcode 2 para tcode 6 em
  `infer_tcode_from_varnames()`, mas dois lugares ficaram para trás:
  `diagnostics/_common.R:75-77`, cujo `unit_table()` ainda rotula o bloco como
  `"retorno mensal decimal (tcode 2 -> cumsum x100 = %)"`, e
  `output/factors/panel_unit_root_pp.csv`, que registra a distribuição 88/7/16
  como tcode 1/2/4. **Entrega:** rótulo corrigido no `_common.R`; para o CSV,
  decidir entre re-rodar e congelar com banner, como no item irmão de
  `output/panel_experimental/irfs_required_long.csv`.
  - ⚠ **É rótulo, não cálculo.** O `escala_bp` do bloco `asset_*` é `NA` e não
    entra em conta nenhuma; a auditoria de unidades que importa
    (`diagnostics/02_unidades_sinal.R`, `t2_2_unidades_juros.csv`) está certa e
    cobre o bloco de juros, que é onde a escala decide.
  - ⚠ `diagnostics/` audita e **não modifica código de estimação** — corrigir o
    rótulo do `_common.R` respeita essa fronteira; mexer no
    `infer_tcode_from_varnames()` não, e não é o que o item pede.

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
  ⚠ **Um `tryCatch(solve(...))` seria errado:** LAPACK só erra em pivô
  exatamente zero, então uma Lyapunov numericamente singular pode propagar
  lixo até bandas não finitas. A vintage então corrente do VAR pequeno emitiu
  aviso e usou coeficientes OLS não corrigidos no DGP do bootstrap; essa
  especificação foi superada e o benchmark Olea não usa Kilian nem bootstrap.
  Fonte histórica: `notas/2026-08-22_var_estacionario.md`.
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
