# Pendências

**Última revisão:** 2026-09-08 — **todos os itens abertos foram zerados por
decisão do autor**, para conter o acúmulo que vinha tomando o foco do
projeto. Nenhum foi marcado como feito: nenhum foi executado, testado ou
decidido. O texto de cada item, incluindo as ressalvas `⚠`, some deste
arquivo, mas continua recuperável no histórico do git (`git log -p --
registro/pendencias.md`) para quem quiser reabri-lo com desenho próprio.
Os blocos `Fechados (contexto)` de cada tema, que registram trabalho de fato
concluído, foram preservados. No mesmo dia, cinco itens novos entraram no
Tema B, transcritos em ordem das coordenadas do último email do orientador
(`email/email_professor_04-09_16h42.md`, 2026-09-04) — nenhum foi executado.
Itens abertos organizados por tema (A-E);
cada tema termina num bloco `### Fechados (contexto)` com o que já foi feito,
resumido a poucas linhas — o detalhe completo mora no working-note ou output
apontado ali, nunca duplicado aqui. Resultados negativos e decisões
revertidas ficam em [`historico_decisoes.md`](historico_decisoes.md) —
consulte antes de propor um caminho novo.

**Passada editorial em 2026-09-08:** todo bloco `Fechados (contexto)` (Temas
A-E) foi comprimido para a regra de 2-4 linhas que este arquivo já declarava
mas não seguia — nenhuma decisão, veredito ou número mudou, só a prosa
redundante com a nota/output já apontado saiu. As convenções de manutenção e
de branches, que não são pendência nem histórico, mudaram para
`.claude/rules/writing.md`. Texto integral pré-compressão recuperável em
`git log -p -- registro/pendencias.md`.

---

## Convenção de manutenção deste arquivo

Regras de manutenção e a convenção de branches movidas para
`.claude/rules/writing.md` (§"Maintaining `registro/pendencias.md`" e
§"Branch convention") em 2026-09-08, para tirar workflow estável de um
arquivo que deve conter só pendência viva. Consultar lá antes de abrir,
fechar ou comprimir um item.

---

## Especificação corrente

| item | valor |
|---|---|
| Identificação | proxy-SVAR (instrumento externo), `H = (Z'η)/(Z'Z)` |
| Instrumento | **`z_jk_bs_purif`** — surpresa DI Qua→Qui no vértice 126 du + ortogonalização Bauer-Swanson **pré-evento** + máscara JK em resíduos predeterminados |
| Variável de política | `yield_6m`, choque +50bp no impacto (+0,005 em proporção decimal) |
| Dimensão | **r = 5, q = 5**, VAR(p = 4) nos fatores; Bai--Ng BLL dá IC1=5, IC2=5 e IC3=20; `q=r=5`; `p=4` herdado, com nova checagem AIC/BIC separada em `T=154` |
| Painel | **115 séries**, variante `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03 a 2025-12 (166 observações alinhadas; 162 inovações fatoriais após p=4) |
| Inferência | **conjuntos Anderson-Rubin por inversão de teste** (MOSW 2021), NW(0), níveis 68/90, h = 0-48, desde 2026-09-08. O wild bootstrap Gonçalves-Kilian e a correção de Kilian saíram do código em 2026-09-18. ⚠ `hac_dim < T` barra `(8,8)` em `p=4` e a janela pré-COVID inteira |
| Força | ξ_mp/F_rob,mp = **6,848035/11,765564** full, sob a escala COVID de Lenza-Primiceri desde 2026-09-17 (θ̂ reestimado com `ndeps = 1e-6` em 2026-09-25; antes 6,847997/11,765250), e **8,643436/13,809985** pré-COVID; raiz máxima 0,983676 full e 0,993359 pré-COVID; ambas estáveis |
| Benchmark VAR do paper | `{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}` em nível, com constante e tendência linear; desde 2026-09-21 na **janela e no `p` do DFM** (2012-03--2025-12, `p=4`, `T_eff=162`), decisão de comparabilidade e **não** do AIC, que em `T=154` ainda escolhe `p=2` (BIC, `p=1`); respostas `C_h B_1`; `xi_var=7,258325`, raiz máxima `0,976522`; AR/MOSW 68%/90% com NW(0) |

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

Desde 2026-09-24 o paper inteiro, as figuras da §4 e `output/irf/irf_section.md`
estão na vintage de produção (`notas/2026-09-24_migracao_secao_4.md`). Grades
históricas de painel, `(r,q)` e instrumento condicionadas a `p=6` permanecem
evidência datada e não foram reestimadas. O benchmark VAR em níveis continua
separado, na janela e no `p=4` do DFM desde 2026-09-21, com seus conjuntos
AR/MOSW próprios.

---

## Índice de itens abertos

| Tema | Item | Observação |
|---|---|---|
| B | Reportar a poda no paper como robustez que não confirmou Boivin-Ng, com a ressalva de perda de N | passo 2/4 do e-mail de 13-09; destravado em 2026-09-24, quando a rodada editorial do Tema A fechou a §4 |
| A | Decidir se o resumo, a introdução e a conclusão absorvem a leitura da §4 migrada | aberto em 2026-09-24; a rodada da §4 só trocou números e datas fora dela, por decisão do autor; três frases de argumento ficaram enfraquecidas (horas "com defasagem", reversão "sincronizada" com curva e risco ainda no vale em h36, silêncio sobre atividade persistente e NFSP primária positiva em h18–h32) |
| A | Decidir o que a §2 diz sobre o CDS de `goncalves2025` | aberto em 2026-09-21; `paper_anpec.tex:184` diz que o CDS deles "não apresenta resposta sistemática", seguindo a prosa do artigo, mas a Tabela 5 traz um **fechamento** de −3/−5/−11 p.b. com o vértice de 12 meses distinto de zero, sobre o nosso −10,37; ⚠ a unidade do CDS não é declarada por eles e foi fixada por dois testes de escala; a correção **reforça** o contraste do artigo |
| D | Estimar o VAR mensal das tabelas de heterocedasticidade sob a escala LP e reportar sem e com o tratamento | aberto em 2026-09-24, decisão do autor; θ próprio por vértice, não o θ̂ do DFM; mesmo caminho da linha fatorial nas duas versões; ⚠ se rejeitar, `sec:identificacao` muda; a linha diária fica sem tratamento |
| D | Promover a ortogonalização BS só nas reuniões (Tabela 3 + S&P 500 e VIX) e migrar o paper | construção escolhida pelo autor em 2026-09-26 na branch `feature/bs-copom-surpresas-macro`; ξ_mp de produção 6,85 → 5,01 (pré-COVID 8,64 → 4,73), conjuntos todos `interval`; a promoção migra o paper inteiro |
| E | Decidir se a guarda do ponto AR em `compute_irf_dfm()` vira relativa | aberto em 2026-09-10; absoluta (1e-10), disparou em `(5,3)` com 1,16e-10; não afeta a produção |

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

- [ ] **Decidir se o resumo, a introdução e a conclusão absorvem a leitura da
  §4 migrada.** A rodada de 2026-09-24 reescreveu a §4 e, fora dela, só trocou
  números e datas, por decisão do autor. Três frases de argumento ficaram
  enfraquecidas pela leitura nova e não foram tocadas: "o mercado de trabalho
  responde com defasagem" na conclusão, quando as horas caem 1,23% já no impacto,
  com 90% excluindo zero; a reversão "altamente sincronizada" do resumo, porque os
  cruzamentos vão de h11 a h16, mas curva e risco soberano ainda estão no vale em
  h36; e o silêncio do resumo e da conclusão sobre a atividade negativa por 36
  meses (IBC-Br com 90% de h6 a h24) e sobre a NFSP primária positiva e
  significativa de h18 a h32. Duas frases da conclusão foram corrigidas só no
  fato: as ações ficaram "sem resposta de impacto significativa em nenhum dos sete
  índices", e a inflação com repasse passou a ser a "inflação ao produtor".
  Decisão editorial. Nota: `notas/2026-09-24_migracao_secao_4.md` §5.
- [x] **O que o resumo diz sobre frequência — RESOLVIDO em 2026-09-22.**
  O resumo deixou de explicar a divergência com `goncalves2025` pela frequência ou
  pela agregação e passou a situá-la na **condição de identificação**: ela vale nas
  três séries diárias e falha nas mesmas três séries no painel mensal. "As condições"
  virou "a condição de posto" nas duas línguas, que é o que Rigobon enuncia. Duas
  afirmações opostas foram **revertidas do registro** no mesmo dia: a de que a
  agregação temporal **vira o sinal**, que se apoiava na quarta vertente, e a de que
  ela **não é o obstáculo**, que se apoiava na linha da soma das janelas Qua→Qui
  dentro do mês — objeto retirado por decisão do autor. A única agregação mensal é a
  do painel, a última cotação do mês de referência.
  Nota: `2026-09-22_condicao_het_svars`.
- [x] **O que a §2 diz sobre o CDS de Gonçalves, Rodrigues e Genta — RESOLVIDO em
  2026-09-22.** `paper_anpec.tex` deixou de repetir "não apresenta resposta
  sistemática" e passa a reportar o fechamento de 3 a 11 p.b., com o vértice de doze
  meses distinto de zero, registrando que os autores o descrevem como ausente. A
  unidade inferida fica documentada em `het_rigobon/_common.R` e no relatório
  `01_daily_grg.md`, não no corpo do artigo. Isto **reforça** o contraste: o DFM dá
  +30,5 p.b. de alargamento onde o diário identificado dá fechamento.
- [ ] **Decidir se o resumo carrega as duas ressalvas da linha diária.**
  Desde 2026-09-22 os dois sistemas usam **as séries de GRG** — DI, câmbio e CDS de 5
  anos. ⚠ Antes disso o projeto chamava de "linha diária publicada" um conjunto com
  DI de 2 anos e Ibovespa, que **não são de GRG**; o erro foi corrigido e a
  `tab:het_frequency` refeita. Duas ressalvas ficaram na §5.1 e **não** no resumo: o
  **vértice** decide no diário (p 0,0033 / 0,0844 / 0,1474 em 3, 6 e 12 meses,
  acompanhando a queda da razão de variância do DI com a maturidade nos próprios GRG),
  e a **correção de curtose** do teste também (÷4,9; sem ela as três células diárias
  rejeitariam). O resumo fala da identificação diária sem qualificar nenhuma das duas.
  Decisão editorial.
  ⚠ Fica registrada uma **lacuna de dados**: a quarta série de GRG é o *breakeven* de
  inflação entre títulos indexados e nominais, que este painel não tem. A medida
  disponível é a do Focus, que é survey — eles dizem "market-based (not survey data)" —
  e cuja variação diária é exatamente zero em 23% dos dias. Construir o breakeven a
  partir de NTN-B e LTN é uma rodada de dados, não editorial.
  Nota: `2026-09-22_condicao_het_svars`.

### Fechados (contexto)

- [x] **`q = r` justificado na §3.1 e sensibilidade a `q` no Anexo C —
  2026-09-24.** Defesa em duas frases, ancorada em Stock-Watson (2016, §7.2) e AK,
  com Amengual-Watson citado (24 de 25 chaves; a entrada já estava no `.bib`, só
  não era citada). Por decisão do autor, o texto não cita números. ⚠ Em `q ≤ 3`
  câmbio, CDS e Ibovespa se ampliam (Ibovespa 8,6× em `q = 3`), e o modelo sem LP
  fica fora do paper. Nota: `2026-09-24_q_sensibilidade_anexo`.

- [x] **§4, suas oito figuras e `irf_section.md` migrados para a produção
  corrente, com a leitura das IRFs sob a escala LP — 2026-09-24.** Nada foi
  reestimado. `fig_section5.R` perdeu a trava, a legenda *wild bootstrap* saiu, e
  a contradição com a §5.2 some (BRL/USD 3,23%, CDS 30,5 p.b.). A leitura mudou:
  o IBC-Br não fica positivo em 36 meses, e o IPCA não fica positivo em nenhum
  horizonte. ⚠ A fase positiva das ações e a NFSP primária em h18–h32 são
  significativas a 90% e estão no texto. Nota: `2026-09-24_migracao_secao_4`.

- [x] **Resumo corrigido nas duas línguas — 2026-09-21.** Dizia que a importância
  do canal "pode depender da frequência dos dados e da estratégia de identificação";
  agora reporta que a frequência **não** explica a divergência com `goncalves2025`,
  porque as mesmas séries agregadas ao mês preservam as duas condições. ⚠ Fechou junto
  com a correção do mecanismo da §5.1: a condição de posto nunca falhou na coluna
  identificada (gap λ₁--λ₂ de 0,74 / 0,76 / 0,55), e o 0,10 antes publicado é o par
  (2,3). Nota: `2026-09-21_migracao_secao_5.md` §6.5.
  ⚠ **Superado em 2026-09-22**: o resumo não diz mais que a frequência não explica a
  divergência, e a linha das séries agregadas ao mês que sustentava a frase não existe
  mais. Ver o item `O que o resumo diz sobre frequência`, acima.

- [x] **`fomc_coincidence.R` marcado de vintage — ARQUIVADO em 2026-09-18**
  (autor), no lugar de reexecutado. **A §5.3 foi EXCLUÍDA do paper em 2026-09-21**
  (decisão do autor, `notas/2026-09-21_migracao_secao_5.md`), o que encerra a
  pergunta que a rodada editorial teria de decidir. Os números seguem em
  `output/instrument/fomc_coincidence.md` (janela 2013-01, 62 dias, commit
  `08ccff3`), e a ressalva de 2026-08-24 continua valendo no registro: a máscara
  global rederivada derruba `ξ_mp` para 3,671. Os p-valores que a §5.3 citava
  vinham do wild bootstrap das regressões diárias
  (`arquivo/R/instrument/event_tests.R`, arquivado junto); o bootstrap do DFM
  só entrava na seção de IRFs, que o paper não usa. As outras rodadas
  OLS deste item (`jk_sovereign_confound.R`, `fiscal_*`,
  `q_narrative_overlay.R`) foram arquivadas em 2026-09-17, e `ar_bands.R` em
  2026-09-18 (`arquivo/README.md`).
- [x] **Equações do tratamento de volatilidade COVID — sem apêndice, FEITO em
  2026-09-17.** Nenhuma equação de Lenza-Primiceri muda de forma no DFM: `F̂_t`
  ocupa o lugar de `y_t`, `r` o de `n`, e as (B1)-(B5) valem letra por letra.
  Pela decisão de 2026-09-16, isso é corpo mais nota de rodapé, não apêndice.
  A §3.1 ganhou `s_t` na eq. (5), a trajetória como eq. (5b) e a nota com a
  eq. (1) dos autores; a §3.6, as ressalvas de plug-in em θ̂ e do gate
  `hac_dim`. Nota: `notas/2026-09-17_volatilidade_covid_producao.md`.

- [x] **Apêndice das equações MOSW→DFM descartado, mapeamento no corpo —
  2026-09-16.** Decisão do autor: a extensão é troca de vetor, não derivação
  nova, e quem conhece MOSW reconstrói a adaptação sozinho. A §3.6 reporta em
  prosa que só mudam os vetores da razão identificada (`c_j' = sy_j·Λ_j'` e
  `c_mp'` no lugar dos coordenados), e a nota põe as duas equações lado a lado
  (`e_i'C_h(A)Γ/e_1'Γ` contra `δ·c_i'B_hΓ/c_mp'Γ`, com `KK'=I` porque `q=r`).
  Sem equação no corpo, também por decisão do autor: a razão é trivial para
  quem conhece IRF de DFM. Nota:
  `notas/2026-09-08_bandas_anderson_rubin_producao.md`.
- [x] **Expectativas fiscais Focus — teste isolado, 2026-09-01.** DLSP e
  resultado primário/nominal em nível ampliam o painel para 114 séries sem
  tocar produção; ξ_mp sobe de 5,24 a 5,81 (ainda < 10); DLSP e nominal
  esperados caem, sem sinal de deterioração fiscal esperada. Nota:
  `notas/2026-09-01_teste_expectativas_fiscais.md`.
- [x] **Revisão integral do paper — 2026-08-25.** Resumo a conclusão migrados
  para 111 séries `(5,5,4)`; manchetes 3,74%/24,5pb/30,7pb/74,8pb; prosa
  defensiva sobre UIP/dominância fiscal removida. Fonte: `paper/paper_anpec.tex`.
- [x] **Diagnósticos de máscara condensados na exposição — 2026-08-25.**
  Risco soberano e FOMC mostram só a máscara fixa; rederivação fica nos
  artefatos e no registro metodológico.
- [x] **§3-5 sincronizadas com a produção `p=4` — 2026-08-25.** Texto apenas,
  sem nova estimação. Nota: `notas/2026-08-25_sincronizacao_secoes_3_5_p4.md`.
- [x] **Diagnóstico MOSW qualificado como diagnóstico, não inferência —
  concluído.** Introdução e §3.6 tratam ξ_mp via \cite{montielolea} sem
  transferir cobertura AR ao DFM. Nota: `notas/2026-08-22_var_olea_estacionario.md`.
- [x] **Robustez weak-IV integrada à §5 (`sec:weak_iv`) — concluído.** DFM
  `p=4` separado do benchmark em níveis (`p=2` AIC, AR/MOSW 68/90% NW(0)).
  Nota: `notas/2026-08-22_var_niveis_aic_tendencia.md`.
- [x] **Invertibilidade separada da exogeneidade na §5 — concluído.** Ancorada
  em \cite{stockwatson2018}; regressões sobre inovações futuras dão
  0,771/0,550, Granger `p_boot` mínimo 0,268 — necessário, não suficiente.
- [x] **Máscaras rederivadas mantidas como diagnóstico, não exposição
  principal.** Soberano: ξ_mp 5,80→3,44 rederivado. FOMC: 5,33→3,67. Paper
  reporta só a seleção fixa.
- [x] **Comparação cambial na mesma base de choque — concluído.** 3,74%/50pb
  e 7,48%/100pb contra 3,4-5,6% de \cite{goncalves2025}, diferenças de desenho
  explicitadas.
- [x] **§4 migrada para 111 séries `(5,5,4)` — conferida 2026-08-25.** Seis
  subseções e legendas do CSV/cache correntes; cautela de `xi_mp=5,24`
  mantida.
- [x] **Selic, horizonte comum, cinco moedas em §4 — concluído.** Selic +24,1pb
  no impacto, CDI fora; manchetes em `h=0`; USD/EUR/CNY/INR/ARS em % da média.
- [x] **Agregados monetários omitidos — decisão editorial.** Bloco heterogêneo
  na produção corrente, sem parágrafo ou figura na §4.
- [x] **Reversão de médio prazo qualificada — concluído.** §4 trata como
  dinâmica conjunta sensível a `p`, não como modo quase unitário isolado nem
  confirmação de mecanismo. Fonte: `output/factors/factor_stationarity.md`.
- [x] **Preços reescritos sem antecipar a comparação cross-instrumento —
  concluído.** IPP imediato separado dos preços ao consumidor, sem rotular
  *price puzzle*; frase-marcador substituída pelo resultado do Tema D.
- [x] **Bloco acionário e IMAT reescritos.** Sete índices em retorno mensal
  sem acumulação, impactos entre −2,70% e −0,07%; amortecimento do IMAT
  associado a receita em dólar.
- [x] **Sem parágrafo/subseção de Limitações — decisão do autor, 2026-08-18.**
  Cautelas (instrumento fraco, reversão, preços, crédito, câmbio) ficam nas
  passagens substantivas correspondentes.
- [x] **Exogeneidade lead-lag: procedência resolvida, condição testada —
  2026-08-14.** É a Condição LP-IV (iii) de \cite{stockwatson2018}
  (*lead-lag exogeneity*), não Braun-Brüggemann; não é exigida pelo SVAR-IV
  (paga em invertibilidade). Teste canônico implementado (`01_exogeneidade.R`
  §1.7): **não rejeita**, `p_boot` mínimo 0,324 em `L=6`. ⚠ Condição só
  necessária, potência baixa (n=147); ⚠ `cambio_usd` defasado em `p_boot`
  0,064, único do bloco externo abaixo de 0,10 e fora dos preditores BS. Nota:
  `notas/2026-08-14_exogeneidade_lead_lag_e_invertibilidade.md`.
- [x] **Limiar "≥10" reatribuído — não é Montiel Olea-Stock-Watson —
  2026-08-14.** §3.6 chama de referência convencional do F de primeiro
  estágio 2SLS, não valor crítico MOSW da Wald robusta.
- [x] **Placebo `sp500_vix` corrigido na prosa — 2026-08-14.** §5.1 não cita
  mais S&P 500 (painel só tem VIX); acrescentar um nível do S&P 500 é item
  aberto no Tema B.
- [x] **Contradição resumo/§4.2 sobre reversão cambial — superada.** Resumo já
  não chama a reversão de sincronizada; interpretação refeita para `(5,5)` na
  migração da §4.
- [x] **Diagnóstico de relevância simplificado, alinhado a MOSW —
  2026-08-13.** Só ξ_mp e F_rob,mp (HC1) na mesma direção de normalização;
  migração para `(5,5)` deu 6,27/10,12 e 10,99/9,75. Fonte:
  `output/instrument/olea_alignment_audit.md`.
- [x] **Grade de $(r,q)$ incorporada — 2026-08-12, superada em 2026-08-13.**
  `tab:rq_sweep` mostrou platô em (7,5)-(8,6); (7,6) ficou congelado até a
  seleção conjunta adotar 111 séries `(5,5)`. Fonte:
  `output/instrument/mosw_strength_grid.csv`.
- [x] **Coincidência FOMC redigida no paper — 2026-08-12.** `sec:fomc` reporta
  exposição, timing, testes 0-3, confound não detectado. Fonte:
  `notas/2026-08-10_coincidencia_fomc.md`.
- [x] **Quatro correções pontuais em §3.4-§3.6 — auditadas e aplicadas,
  2026-07-26.** Variante BS-predeterminado + JK explicitada; frase obsoleta de
  (6,5) removida; correção de Kilian confirmada correta; validação de Olea
  comentada.
- [x] **Abstract, Introdução e Conclusão — rewrite, 2026-08-01.** Resumo:
  depreciação 5,55% BRL/USD, EMBI+/CDS em alta, curva até 5 anos; conclusão
  trata divergência com GRG (2025) como aberta. **Achado à parte, não
  corrigido:** §3.2/Anexo A ainda descrevem a curva como ajustada por Svensson
  em código do projeto — `script/yield_curve.R` foi deletado em 2026-07-26 e
  `yields_dia.csv` é hoje insumo externo fixo do orientador.
- [x] **Revisão de literatura §2 — reescrita, 2026-07-28.** Trilha
  não-fundamentalidade → FAVAR/DFM → AK → Mertens-Ravn → Stock-Watson →
  Gertler-Karadi → JK+BS → MOSW → GRG (2025). Chaves novas: `goncalves2025`,
  `bagliano1998`. Fora por decisão do autor: Bonomo-Martins, Blanchard (2004).
- [x] **§5 Robustez escrita no `tex/main.tex` — 2026-07-29/30.** Prosa com
  IC90, 9 figuras. Três erros corrigidos ao promover blocos comentados: a
  cronologia de reversão câmbio/EMBI/CDS **não inclui o câmbio**;
  `trab_pop_ocupada` sig68 positiva contra a previsão; `commodity_metal`
  corrigido para +3,43% (era erro de unidade). Detalhe: `irf_section.md` §5.7.
- [x] **Regra de dois níveis em §4/§5 — 2026-07-30.** 68% excluindo zero vira
  *direção e magnitude* (nunca "significativo"); 706 pares a 68% contra 92 a
  90%, todos h≤12. Fato inconveniente no corpo: IBC-Br não acompanha o vale
  setorial (só h0 sig68).
- [x] **Confound soberano no filtro JK — não confirmado, 2026-07-31, repetido
  em CDS diário 2026-08-09 com mesmo veredito.** ΔEMBI carrega a surpresa com
  coef 0,326 em dias comuns contra 0,099 nos 62 dias retidos; interações
  `x:1(jk_bs)` negativas nas quatro proxies de risco. ⚠ Coeficiente nos 62
  dias é positivo e marginal (p=0,097) — "menos risco", não "zero risco".
  Nota: `notas/2026-07-31_confound_soberano_jk.md`,
  `2026-08-09_confound_soberano_cds.md`.
- [x] **Redação do confound soberano em `paper/` — 2026-08-09, reescrito
  2026-08-10.** §5.2 `sec:confound` com as três ressalvas no corpo. Máscara
  JK re-derivada nos resíduos ortogonalizados (`z_jk_bs_norisk_mask`): 50/62
  dias sobrevivem, ξ_mp cai a 4,26 (produção 7,58 só nos valores) — sustenta
  direção, não intervalo. Fonte: `notas/2026-08-09_confound_soberano_cds.md`.
- [x] **Benchmark VAR pequeno substituído integralmente — 2026-08-22.** IPCA
  em nível, BIC `p=1`, `C_h B_1`, AR 68/90% NW(0); superado no mesmo dia como
  benchmark do paper. Nota: `notas/2026-08-22_var_producao_unica.md`.
- [x] **Estacionariedade dos fatores, cointegração e espectro — 2026-07-31.**
  4/7 fatores I(1), nenhum I(2); posto de cointegração não identificado → VAR
  em nível mantido (Sims-Stock-Watson 1990). Par dominante complexo, |λ|=0,977.
  ⚠ Apagar esse par inverte o sinal do vale de médio prazo em 12/14 séries
  (`cambio_usd` é a exceção que sobrevive). Nota:
  `notas/2026-07-31_estacionariedade_fatores.md`.
- [x] **Camada de citação estrutural — três correções, 2026-08-01.**
  Cooley-Quadrini reescrito para não atribuir heterogeneidade setorial a
  patrimônio/porte; Castelnuovo-Nisticò reposicionado como argumento para
  incluir o Ibovespa entre os preditores BS predeterminados.
- [x] **`juros_selic`/`juros_cdi` não são evidências independentes —
  2026-08-01.** Divergem só no 3º dígito; citar as duas como confirmação
  cruzada seria erro. `paper/paper_anpec.tex:335`.

---

## B. Robustez estatística a fazer

*Cinco itens transcritos em 2026-09-08 em ordem do último email do
orientador (`email/email_professor_04-09_16h42.md`), que fundamenta a
hipótese de que correlação intra-bloco subestima `r` e `q` em Boivin & Ng
(2006, JE 132(1), 169-194). A sugestão 5/5 foi feita no mesmo dia; a 1/5, a 2/5
e a 3/5, em 2026-09-10. As quatro estão fechadas abaixo. A 4/5 (`r=q=8` como
especificação principal) foi removida em 2026-09-24 por decisão do autor, sem
ser executada. Os itens que estavam aqui antes da zeragem de
2026-09-08 (reavaliação do canal de prêmio de risco, purificação FOMC
intradiária, sensibilidade sem superquarta, placebo S&P 500, decomposição
diário-vs-mensal da curva, discriminação choque-vs-Λ, leave-one-out sobre a
IRF, tabela cross-instrumento do bloco-manchete, preditor fiscal em
Bauer-Swanson) não foram executados, testados nem decididos — apenas
removidos do registro. Recuperáveis no histórico do git.*

*O item abaixo transcreve o passo 2/4 dos "próximos passos coordenados" do
e-mail do orientador de 2026-09-13 (`email/email_professor_13-09_10h45.md`),
resposta às sugestões 1/5, 2/5 e 3/5 acima (fechadas em 2026-09-10). Os passos
3/4 e 4/4 estão fechados abaixo; o 1/4 foi removido em 2026-09-24 por decisão
do autor, sem ser executado.*

- [ ] **Reportar o exercício de poda no paper como robustez que não
  confirmou a hipótese de Boivin-Ng**, com a ressalva de que a queda do
  Bai-Ng para `r=3` pode refletir perda de potência por N menor, não
  confirmação do mecanismo. Passo 2/4. Destravado em 2026-09-24, quando a
  rodada editorial do Tema A sincronizou a §4.

### Fechados (contexto)

- [x] **IRFs por camada do instrumento e tabela de Bauer-Swanson no Anexo D — 2026-09-25.**
  `instrument_layers_irf.R` e `fig:instrumento_camadas`: nenhum ponto de `z_bruto` ou
  `z_bs_purif` sai do conjunto de 90% da produção (0/4255 cada), e o filtro JK amplia câmbio,
  CDS e juros longos em 12% a 36%. ⚠ O impacto do Ibovespa troca de sinal com o filtro
  (+0,19/+0,27% → −1,50%), por construção. `tab:bs_ortogonalizacao`, análoga à Tabela 3 de BS,
  tem Wald conjunta p 0,131 (DI) e 0,326 (Ibovespa). Nota: `2026-09-25_anexo_d_instrumento`.
- [x] **Sensibilidade a `p` no Anexo C; θ̂ reestimado com gradiente mais fino — 2026-09-25.**
  `p = 2..6`, θ reestimado em cada `p`, e todos os pontos dentro do conjunto de 90% de `p = 4`.
  A trava da condição de primeira ordem barrou `p = 5` com o `ndeps` padrão do `optim`, e o
  autor escolheu `ndeps = 1e-6` em todo `p`. ξ_mp 6,847997 → 6,848035, IRFs ≤ 8e-5 da escala,
  nenhum número do paper mudou. Nota: `2026-09-25_p_sensibilidade_anexo`.

- [x] **Ótimo global de θ̂ confirmado — 2026-09-24.** Multi-start de 750 inícios na
  caixa inteira, virou trava de `covid_volatility_theta.R`. Nenhum início passa de θ̂
  (+3,8e-7 log-ponto, precisão do otimizador), e há três máximos: θ̂ (137 inícios),
  ρ = 0 (−2,62) e uma crista nova no piso s̄2 = 1 (−4,79). θ̂ sai byte-idêntico.
  ⚠ Nenhum início com ρ0 ≤ 0,4 chega a θ̂: o de produção dependia do ρ0 = 0,8 de LP.
  Nota: `2026-09-24_otimo_global_theta`; `output/factors/covid_volatility_multistart.csv`.

- [x] **Figura de sensibilidade `q = 2,…,5` (`r = 5`) no Anexo C — FEITA em
  2026-09-24.** Passo 4/4. `q_sensitivity.R --window=cheia` escreve
  `paper/fig_q_sensibilidade.pdf`: oito séries até h36, com `q = 5` guardado contra
  `irf_coherence_h.csv` a 1e-10. Em h ≤ 36, 16, 5 e 4 das 20 séries ficam inteiras
  na banda de 90% (as mesmas contagens de 0–48). As pernas sem tratamento e
  pré-COVID ficam no registro. Nota: `2026-09-24_q_sensibilidade_anexo`.

- [x] **Sistema mensal de quatro observáveis identificado por heterocedasticidade —
  autorizado em 2026-09-21, reavaliado com o teste do `svars` em 2026-09-22.**
  Veredito: **a premissa estava errada**. O VAR mensal nas quatro observáveis do painel
  **não** identifica — o teste `Qr` de Lütkepohl et al. (2021) não rejeita `λ₁ = λ₂`
  em nenhum vértice (p 0,917 a 0,988), com os dois maiores autovalores praticamente
  coincidindo —, e as cinco inovações fatoriais também não a 5% (p 0,0761). Quem
  identifica é o sistema **diário** nas mesmas três séries de `goncalves2025`, no
  vértice de 3 meses (p 0,0033), e ali o aperto de 50 p.b. **fecha** o CDS 4,2 p.b. e
  **aprecia** o real 1,53% — o sinal deles, não o do DFM. ⚠ O que separa as duas
  linhas — a frequência, ou a troca da janela de anúncio pela variação de calendário —
  **não está medido**: a linha que somava as janelas Qua→Qui dentro do mês foi
  retirada por decisão do autor, e a única agregação mensal é a do painel. A rota het
  segue abandonada para o artigo. Pasta: `het_rigobon/`; nota: `2026-09-22_condicao_het_svars`.

- [x] **Bootstrap e correção de Kilian sob o tratamento de volatilidade
  COVID — ENCERRADO em 2026-09-18** (autor), sem ser derivado: o wild
  bootstrap e a correção de Kilian saíram do código, porque os conjuntos
  Anderson--Rubin os substituíram como inferência do DFM. A última versão com
  eles é `main` em `07b1cbd` (`arquivo/README.md`).
- [x] **Correção de outliers de 2020 (Lenza-Primiceri) — LIGADA EM PRODUÇÃO
  em 2026-09-17.** Passo 3/4. Virou o estimador do VAR dos fatores, descrito
  na §3.1. ξ_mp sobe de 6,057014 para 6,847997 na cheia, F_rob de 9,625428
  para 11,765250, e os conjuntos da §5 seguem `interval` a 68/90%; a pré-COVID
  não se move, porque nela `s_t = 1` em todo mês. Sob a escala, `r >= 7` é
  explosivo na cheia. Nota:
  `notas/2026-09-17_volatilidade_covid_producao.md`.

- [x] **Inferência AR e ξ_mp sob o tratamento de volatilidade COVID — FEITA
  em 2026-09-14.** Com `"standardized"`, o WLS é o OLS da regressão
  transformada, e `CovAhat_Sigmahat_Gamma.m` vale nela ao pé da letra, com θ̂
  tratado como conhecido; `"raw"` segue em `stop()`. Em θ neutro, reproduz o
  AR de produção a 1,5e-13; ξ_mp tratado de 6,848 em `(5,5,4)`. Bootstrap e
  Kilian viraram item próprio. Nota:
  `notas/2026-09-14_inferencia_volatilidade_covid_q.md`.
- [x] **Parametrização da volatilidade COVID — DECIDIDA em 2026-09-14**
  (autor): `t*` = 2020-03; θ por máxima verossimilhança (B5) com s̄ ≥ 1 e
  ρ ∈ [0,1]; `innovations = "standardized"`; sem centragem sob WLS em H e K;
  extração estática não estendida. θ̂ = (6,61; 12,47; 1,76; 0,944), com um
  máximo local em ρ = 0 2,6 log-pontos abaixo. Nota:
  `notas/2026-09-14_estimacao_theta_volatilidade_covid.md`.
- [x] **Truncamento `q < r` testado — FEITO em 2026-09-10** (pedido do autor,
  ligado à 4/5). Pré-COVID `p=2`: 115/115 séries *imateriais* em `q` = 3 e 4;
  cheia: 0/115, e o instrumento está nas direções descartadas (T1 p 0,051 /
  0,039 / 0,015). ⚠ Regras escritas depois da passada exploratória; bandas
  pré-COVID só em `p = 2`. Nota: `notas/2026-09-10_truncamento_q.md`.
- [x] **Poda por correlação — FEITA em 2026-09-10** (sugestão 2/5). Ligação
  completa em |ρ| ≥ 0,90 nas primeiras diferenças: saem 9 de 115 séries, e
  nenhum par entre blocos passa de 0,80. ⚠ Na pré-COVID, 3 dos 8 grupos não
  passam inteiros. Nota: `notas/2026-09-10_poda_correlacao_painel.md`.
- [x] **`(r,q)` no painel podado — FEITO em 2026-09-10** (sugestão 3/5). IC2
  5 → 3, AH 2 → 1, ABC 9 → 11 (instável), AW `q = 2` em todo `r`. A divergência
  **aumenta** (D 10 → 12) e a hipótese de subestimação sai **contrária**. ⚠ D cai
  a 6 em 0,80/0,85. Nota: idem.

- [x] **`r` por Ahn-Horenstein e Alessi-Barigozzi-Capasso — FEITO em
  2026-09-10** (sugestão 1/5). Base BLL, `k=1..20`: ER = GR = 2, ABC-IC*₁ = 9,
  veredito pré-registrado **misto**. ⚠ O 9 vem de um intervalo de 2 pontos da
  grade e dá 5 em 39/100 permutações; ⚠ o `factorselect` diverge no GR e no
  ABC (reimplementado). Nota: `notas/2026-09-10_selecao_fatores_ah_abc.md`.

- [x] **Bandas Anderson-Rubin do DFM — FEITAS em 2026-09-08, e promovidas a
  inferência operacional no lugar do wild bootstrap** (sugestão 5/5; decisão do
  autor reverte a retirada de 2026-08-12 sem cumprir a condição de reabertura
  registrada). Produção `(5,5,4)`: ξ_mp = 6,057014 pelo bloco `W2` de MOSW,
  5.635/5.635 células limitadas a 68/90/95%, prêmio de IV fraco de 1,38× sobre
  o delta-method a 90%. `(5,2)`: ξ_mp = 2,339, limitado só a 68% — a 90% saem
  2.205 retas e 3.429 pares de semirretas, que é a demonstração pedida. ⚠ `(8,8)`
  em `p=4` e a **janela pré-COVID inteira** não rodam (`hac_dim ≥ T`). ⚠ A troca
  move a contagem de significância: nas 58 séries pontuadas, sig90 em h≤12 cai
  de 256 para 159 e sig68 sobe de 1.021 para 1.897. Nota:
  `notas/2026-09-08_bandas_anderson_rubin_producao.md`.

- [x] **Benchmark VAR migrado para níveis, AIC e tendência linear —
  2026-08-22.** Cinco séries em nível, `p=2` AIC comum (`T=141`),
  `xi_mp=6,797335`, raiz máxima 0,965424; valida contra `vars::VARselect` a
  2,31e-14. Nota: `notas/2026-08-22_var_niveis_aic_tendencia.md`.
- [x] **Benchmark estacionário e weak-IV, concluído e superado no mesmo dia
  — 2026-08-22.** IBC-Br/IPCA em nível, resto em diferença; BIC `p=1`, AR
  68/90% NW(0). ⚠ Nenhum exercício testa validade da proxy. Nota:
  `notas/2026-08-22_var_producao_unica.md`.
- [x] **Varredura de `p` no impacto — FEITA em 2026-08-18.** Grade
  `p ∈ {2,3,4,6}`, 800 réplicas cada. Impacto invariante (`share_in90=1` em
  h≤36); reversão de médio prazo se move (h=22 sob p=6, h=15 sob p=2) —
  corrobora §4. ⚠ BIC/HQ selecionam `p=2` (não `p=1` como a ressalva antiga
  dizia); ⚠ `p=6` é a célula mais forte (ξ_mp 6,27) mas não justifica escolha
  por força. Nota: `notas/2026-08-18_varredura_p`.
- [x] **Rótulo "S&P 500 / VIX" corrigido na figura — 2026-08-14.**
  `fig_section5.R:213` agora escreve "VIX"; auto-teste passa em 45/46 séries.
  Acrescentar um nível do S&P 500 ao painel virou item aberto no Tema B.
- [x] **Pico uniforme em h=1 — hipótese superada pela produção `(5,5)`.**
  Curva pico em h=3, Selic em h=5; sem regularidade uniforme do bloco
  financeiro.
- [x] **Decisão conjunta de painel e dimensões — etapa intermediária superada
  em 2026-08-13.** Grade de 2.304 células recomendou 123 séries `(4,3)`
  (ξ_mp=5,05); substituída pela decisão final de 111 séries `(5,5)`. Nota:
  `notas/2026-08-13_decisao_conjunta_painel_dimensoes.md`.
- [x] **Composição experimental do painel, seis blocos candidatos — FEITO em
  2026-08-13, veredito superado pela decisão conjunta acima.** Nove variantes
  pré-especificadas, sem promoção conjunta sustentada pelas bandas. Nota:
  `notas/2026-08-13_teste_experimental_composicao_painel.md`.
- [x] **Teste de coincidência FOMC — FEITO em 2026-08-10.** Causa raiz: um
  `else` fazia "coleta não feita" indistinguível de "coleta vazia";
  `load_fomc_dates()` agora aborta. **Veredito: confound FOMC não
  detectado** — exposição maior que o council estimou (24/62 dias, 35,5% de
  Σ|z|), mas F_rob 0,94/`p_boot` 0,458 no bloco americano. ⚠ O teste 4 (a
  divisão) saiu do script no mesmo dia — não é reproduzível nem citável; a
  perna havia passado e sua remoção só torna a regra mais permissiva
  (`max|dif|=0` conferido). Nota: `notas/2026-08-10_coincidencia_fomc.md`;
  ver `historico_decisoes.md` §2.4.
- [x] **Robustez do próprio ξ_mp — REFEITA em 2026-08-13.** Leave-one-month-out:
  full ξ_mp 6,27 (min 4,89/máx 6,96), 0/147 descartes abaixo de 3,84 mas
  147/147 abaixo de 10. HAC: ξ_mp chega a 8,05 em NW(6). Validado contra
  `NW_hac_STATA.m`/`TaxSVARIV.m`. Nota: `output/instrument/xi_mp_robustness.md`.
- [x] **Robustez da construção do instrumento: vértice e agregação — FEITO em
  2026-07-27.** 260 células; vértice 126 du não é argmax mas a margem do
  desafiante (1,16) fica abaixo do limiar (2,00) — produção mantida. GK
  colapsa ξ_mp a 0,30 no vértice de produção (previsto pela nota 11 de GK).
  Nota: `output/instrument/instrument_construction_sweep.md`.
- [x] **Placebo `commodity_metal` violado — RESOLVIDO em 2026-07-28.** Não era
  exogeneidade: IC-Br do BCB é denominado em R$ e herda a resposta cambial
  (R$: +12,07 sig90 4/5h; US$: +0,42, 0/25h). Reclassificado de `placebo` para
  `ambiguous`. Fonte: `diagnostics/01_exogeneidade.R` §1.6.

---

## C. Identificação por momentos e por heterocedasticidade — ENCERRADO

**Ambas as rotas foram abandonadas em 2026-08-17, por decisão do autor.** Não há
item aberto neste tema. O código dedicado à heterocedasticidade foi removido em
2026-09-01; seus artefatos, nota e veredito permanecem em
`arquivo/heterocedasticidade/`. A rota não-gaussiana continua arquivada em
`arquivo/nao_gaussiana/`; o resumo está em `historico_decisoes.md` §0 e §1.

O núcleo de identificação foi colapsado para o ramo único `proxy` na mesma data
(`R/modeling/{dfm_pipeline,impulse_response}.R`), com o smoke test de produção
bit-idêntico como guard.

**Em 2026-09-21 o autor autorizou uma rodada exploratória que constrói IRFs pela
coluna rank-1.** Ela vive inteira em `het_rigobon/`, em quarentena: importa `R/` em
modo leitura, escreve só na própria pasta e **não** acrescentou ramo
`identification = "het"` a `compute_irf_dfm()`. A identificação segue abandonada para
o artigo, e o veredito da rodada está em `het_rigobon/README.md`. Os dois itens que
ela abriu são **editoriais** e estão no Tema A.

### Fechados (contexto)

- [x] **Resultado negativo da het incorporado ao paper — 2026-09-01,
  REESTIMADO em 2026-09-21.** §5.1 reporta o teste de proporcionalidade no
  diário e no mensal. A vintage de 2026-09-01 rodava `(4,4,4)` sem a escala LP,
  com 450 células válidas e família de 100 no desenho de calendário; a de
  2026-09-21 roda a produção `(5,5,4)` sob a escala, com inovações padronizadas
  e família de 37. **O veredito não mudou** — 0 de 37 sobrevivem a Holm — mas o
  `p_boot` de produção é marginal, 0,0508, contra 0,0559 antes, e o assintótico
  da mesma estatística, 0,0057, rejeitaria.
  ⚠ **O código dedicado voltou, como diagnóstico:** `R/identification/het_tests.R`
  e `script/het_conditions.R`. `ident_het_regimes()` e `het_shock_extraction.R`
  seguem removidos, e nenhuma IRF sai deste ramo em código vivo — a identificação
  por heterocedasticidade continua abandonada desde 2026-08-17.
  ⚠⚠ **A ESTATÍSTICA MUDOU EM 2026-09-22, e com ela todos os números acima.** Por
  decisão do autor a bateria foi reduzida ao teste do pacote `svars` — o `Qr`
  sequencial de Lütkepohl et al. (2021) sobre a distinção dos autovalores de `Λ` —,
  que é a forma multivariada da condição de posto de Rigobon. O teste de
  proporcionalidade de Mauchly, o gap λ₁−λ₂, `ratio_dir`, `rank1_share` e o placebo
  de permutação **saíram**, e os valores-p deste item (0,0508, 0,0559, 0,0003, 0,0057)
  são **descontinuados**. Os dois sistemas passaram a usar **as séries de GRG** — DI,
  câmbio BRL/USD e CDS de 5 anos; o conjunto que o projeto chamava de linha diária
  publicada usava DI de 2 anos e Ibovespa, que **não são deles**. Sob o teste novo: o
  diário rejeita no vértice de 3 meses (p 0,0033), o VAR mensal **nas mesmas três
  séries** não rejeita em nenhum vértice (0,917 a 0,988, com λ₁ ≈ λ₂ e determinante de
  eq. (6) em −0,03), e as inovações fatoriais não a 5% (0,0761). ⚠ **As duas
  diferenças entre as linhas não estão separadas** e nenhuma afirmação pode atribuir a
  queda a uma delas: o objeto que somava as janelas Qua→Qui dentro do mês foi retirado
  por decisão do autor no fim da rodada, com todos os seus números, e a única agregação
  mensal é a do painel — a última cotação do mês de referência nos vértices do DI e no
  CDS, a média mensal no câmbio. Tanto a afirmação de que a agregação vira o sinal
  quanto a de que ela destrói a separação dos autovalores foram **revertidas**.
  Fontes: `notas/2026-09-22_condicao_het_svars.md`,
  `output/het/het_conditions.md`, `arquivo/heterocedasticidade/README.md`.

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

- [ ] **Estimar o VAR mensal das tabelas de heterocedasticidade sob a escala
  COVID de Lenza-Primiceri e reportar a linha sem e com o tratamento.** Aberto
  em 2026-09-24, por decisão do autor. Hoje o Sistema 2 de
  `script/het_conditions.R` (DI, câmbio e CDS no painel mensal) é MQO, `p=4`,
  com constante e tendência, enquanto a linha das inovações fatoriais já lê as
  inovações padronizadas `u_t/s_t` do DFM de produção. As duas linhas mensais
  do Anexo B diferem, portanto, também no tratamento da COVID. Desenho:
  - θ **próprio** de cada VAR, um por vértice (3, 6 e 12 meses), por
    verossimilhança concentrada, com `t*` = 2020-03 — não o θ̂ de
    `output/factors/covid_volatility_theta.csv`, que é do VAR fatorial;
  - `Qr` sobre os resíduos padronizados `u_t/s_t`, pelo mesmo caminho da linha
    fatorial (`p = 1`, `inert_lag = TRUE`);
  - as duas versões lado a lado, nos três vértices. Mudam as linhas do VAR em
    `tab:het_variance` e em `tab:het_frequency`, inclusive a razão `a` do DI,
    porque todas saem das mesmas `Σ_C`/`Σ_NC`.

  ⚠ O motivo é amostral, não teórico: a escala é proporcional
  (`Σ_t = s_t² Σ`) e não identifica nada, mas se concentra em poucos meses que
  caem em regimes definidos — março/2020 (Copom em 18/03) em C e abril/2020 em
  NC, com variância ≈ 44× e ≈ 155× pelo θ̂ do DFM, numa amostra NC de 54 meses.
  ⚠ O efeito não tem sinal previsto. Se o VAR tratado rejeitar `λ₁ = λ₂` em
  algum vértice, o parágrafo e a nota de rodapé de `sec:identificacao` mudam, e
  o número entra no texto.
  ⚠ Para que a diferença seja só o tratamento, a versão sem tratamento deve
  passar pelo mesmo caminho com `s = 1`: o caminho da linha fatorial perde uma
  observação pela defasagem formal (161, não 162). Conferir quanto isso move a
  linha publicada hoje e declarar.
  ⚠ Cada θ por vértice precisa do multi-start que trava o θ̂ do DFM desde
  2026-09-24. No VAR fatorial, (B5) tem três máximos, e o L-BFGS-B de um início
  só chega ao global apenas com ρ0 ≥ 0,6 (`2026-09-24_otimo_global_theta` §4).
  ⚠ `estimate_var_wls()` e `estimate_covid_theta()`
  (`R/modeling/factor_estimation.R`) só têm constante; o VAR da tabela tem
  constante **e** tendência. Estender, não escrever uma segunda
  implementação, e manter bit-idênticos o smoke test e
  `script/validation/validate_covid_volatility.R`.
  ⚠ O benchmark `ibc5_fx_cds_level_trend_p4` segue sem escala; o Sistema 2, que
  herdava dele janela, `p` e determinísticos, passa a divergir nesse ponto.
  A linha diária **não** recebe o tratamento: não há dinâmica a filtrar, as
  variações Qua→Qui já são inovações (autocorrelação de primeira ordem entre
  janelas abaixo de 0,1 em módulo), e Lenza-Primiceri não tem versão diária.

- [ ] **Promover a ortogonalização Bauer-Swanson só nas reuniões, com a lista da
  Tabela 3 mais S&P 500 e VIX, e migrar o paper.** Aberto em 2026-09-25 na
  branch `feature/bs-copom-surpresas-macro`. Em 2026-09-26 o autor escolheu a
  construção:
  - 102 reuniões, só constante;
  - tendências de 65 pregões de Ibovespa, inclinação do DI, Brent, S&P 500 e VIX;
  - surpresas de IPCA e PIB, aceleração do núcleo e IPCA esperado.

  As revisões Focus, que eram da Tabela 2, e o câmbio saíram. A variante com a
  revisão da Selic não vai para o paper, por decisão do autor.
  - ξ_mp de produção vai de 6,85 para **5,01** na cheia e de 8,64 para 4,73 na
    pré-COVID.
  - Todos os conjuntos de 68 e 90% seguem `interval`, e nenhum ponto das oito
    séries da §4 sai do conjunto de 90% de `main`.
  - Três leituras da §4 mudam: o IPCA perde a significância, o Ibovespa passa a
    ser significativo e negativo no impacto, e o resultado primário deixa de ser
    significativo em h18–h32.

  A promoção migra:
  - §3.3, `tab:first_stage`, `tab:bs_ortogonalizacao` e §3.4;
  - a §4 e suas oito figuras, com resumo, introdução e conclusão;
  - os Anexos C e D;
  - o benchmark VAR e `fig:weak_iv_main`;
  - os pins de `validate_production_spec.R` e do N2 de
    `validate_covid_volatility.R`, o smoke test e o `CLAUDE.md`.

  Nota: `2026-09-26_bs_lista_tabela3_externas` §5.
  ⚠ Até a migração, a legenda de `tab:bs_ortogonalizacao` em `main` diz "como na
  Tabela 3" de BS sobre uma regressão com tendência nas 638 quintas, que a
  Tabela 3 não é.
  ⚠ Quatro divulgações (PIB de 4T2013, 4T2015 e 1T2017; IPCA de 01/2018) caem
  na própria quinta do Copom, dentro da janela do evento. É contaminação
  contemporânea, que nenhuma camada trata.
  ⚠ `data/processed/` não troca com a branch: rodar `script/instrument.R` ao
  voltar para `main`.

### Fechados (contexto)

- [x] **Ortogonalização Bauer-Swanson só nas reuniões do Copom, sem tendência —
  2026-09-25, na branch.** Segue a Tabela 3 (`table_3.m`: só constante, um mês
  com FOMC por observação), com 102 reuniões em vez de 638 quintas. A surpresa
  do Copom é previsível (Wald p 0,005, `R²` 0,227, revisão Focus da Selic com
  t 4,3). ξ_mp de produção cai de 6,85 para 2,43 (pré-COVID, de 8,64 para 1,89),
  e 20 reuniões trocam de classe. A tendência não era de BS, e a atribuição foi
  corrigida em `metodo.md`. Nota: `2026-09-25_bs_copom_surpresas_macro` §2.
- [x] **Bloco de surpresas macro na ortogonalização Bauer-Swanson — 2026-09-25,
  na branch.** Entram:
  - a surpresa do IPCA e a do PIB (primeira divulgação, lida nos cadernos do
    IBGE), cada uma menos a mediana Focus da última pesquisa e somada desde o
    Copom anterior, com a divulgação da própria quarta incluída;
  - a aceleração do núcleo EX0;
  - o IPCA esperado.

  Emprego e BBK ficam como lacunas. O bloco não é significativo em conjunto
  (p 0,159; PIB com t 1,95). ξ_mp de produção fica em 1,78 na cheia e 3,22 na
  pré-COVID. Insumos de `script/download_macro_news.R`. Nota: idem, §3–4.

- [x] **Comparação cross-instrumento do bloco de preços sob (5,5) — FECHADA em
  2026-08-18.** Escada `z_bruto` → `z_bs_purif` → `z_jk_bs_purif`: corcova de
  h2-h8 positiva nos três degraus (8/8 séries); BS amplifica (16/16), filtro de
  sinal atenua (8/8) — contradiz a nota de 07-12. Nenhum degrau alcança ξ_mp
  10 na cheia. ⚠ Pré-COVID troca a corcova por falha de médio prazo. Nota:
  `notas/2026-08-18_precos_cross_instrumento.md`.
- [x] **Benchmark GRG (2025) sem célula het — FECHADO em 2026-08-01.**
  Desacordo cambial é de frequência/propagação, não identificação: (i) réplica
  diária em Python dá real apreciando 4,53%/100bp, dentro do IC95% do GRG;
  (ii) proporcionalidade LR=135,1 no diário contra nenhuma identificação nas
  288 células mensais válidas. Inconveniente a incluir: IBOV +2,83%/100bp no
  mesmo `b_1` diário, não identificado naquele sistema. Fonte:
  `arquivo/heterocedasticidade/notas/2026-08-01_robustez_heterocedasticidade.md` §6.
- [x] **Dominância fiscal: impacto não depende de estado, persistência sim —
  FEITO em 2026-07-28/29, virou `sec:estado`, baseline CDS.** Impacto (h=0-4)
  robusto nos 7 indicadores; persistência (h=6-8) sob CDS alto (t_dif
  2,81-3,60). ⚠ Depende do indicador: EMBI não detecta nada (t=0,32). ⚠ χ²(9)
  assintótico super-rejeita nesta amostra — exige wild block bootstrap.
  Fonte: `diagnostics/diagnostico_dfm.md` seção 7.
- [x] **Bloco de ativos: janela reportável h≤12 — RESOLVIDO em 2026-07-28**
  (`diagnostics/06_bloco_ativos.R`). Seção cruzada 8/8 negativos em h=0 → 1/8
  em h=12 (amplitude 30,4×); ordenação por sensibilidade a juros se inverte.
  Nenhum dos 8 índices é sig90 em horizonte nenhum.
- [x] **Ações em retorno acumulado: bloco acionário nulo é mecânico — TESTADO
  E CONFIRMADO em 2026-07-31.** `diff()` do BLL estima a segunda diferença do
  log-preço; em nível o bloco vai de 0 para 39 células sig90. ⚠ Custa força de
  instrumento (ξ_mp 10,43→8,94 em log-nível). **Decisão do autor: mudança de
  painel fica de lado** (`historico_decisoes.md` §3.1); só o `cumsum` foi
  corrigido (Tema E). Nota: `notas/2026-07-31_acoes_representacao.md`.

---

## E. Código e higiene

- [ ] **Decidir se a guarda do ponto AR em `compute_irf_dfm()` vira relativa.**
  A checagem é absoluta (1e-10, `R/modeling/impulse_response.R`) e disparou em
  `(5,3)` com desvio de 1,16e-10, numa célula cujas respostas são da ordem de
  10 (relativo de cerca de 1e-11). Não afeta a produção, e mudar exige o smoke
  test bit-idêntico. Achado em `script/q_truncation.R`, que por isso só
  constrói conjuntos AR nas referências `q = 5`.

*Zerado em 2026-09-08 (ver nota de revisão no topo do arquivo); o item acima
abriu em 2026-09-10. Os itens que estavam aqui antes (seleção de `q`, reprodutibilidade do
estágio `di`, padronização do 2º estágio de `amengual_watson()`, o tcode
antigo em `irfs_required_long.csv`, o shim `scalar_dynamic_factor_compat.R`,
documentação do bootstrap, `paper_numbers.tex` gerado, o rótulo de tcode em
dois artefatos) não foram executados, testados nem decididos — apenas
removidos do registro. Recuperáveis no histórico do git.*

### Fechados (contexto)

- [x] **Auditoria de `script/` e `R/` — FEITO em 2026-09-17.** Foram 25 scripts de
  rodadas fechadas para `arquivo/script/`, com 10 funções e `validation_tests.R`
  para `arquivo/R/`. As 6 travas foram para `script/validation/`, e as duas
  narrativas `q` viraram `q_sensitivity.R --window=`. Os autotestes (a) e (b) de
  `q_truncation.R` passaram a conferir a `cheia_p4_lp`. Smoke, as travas e os CSVs
  regerados saíram idênticos ao HEAD. Mapa: `registro/mapa_renomeacoes.md`;
  motivos: `arquivo/README.md`.
- [x] **`cumsum` do bloco acionário corrigido — FEITO em 2026-08-17.** Tcode 6
  (`x*100` sem acumular) para os 7 `asset_*`; h=0 invariante, smoke test
  bit-idêntico. Largura h36/h0 27,573→0,920, pico falso do Ibovespa
  +17,71%(h=21)→+2,01%(h=8). ⚠ sig68 em h≤12 não melhorou (20→20) e sig90 do
  bloco caiu de 4 para 2 — ver Prohibitions em `CLAUDE.md`.
- [x] **`kilian_correction`: teste de singularidade trocado — FEITO em
  2026-08-17.** `det(M)<1e-12` virou `rcond()`; no DFM `(5,5)` a Lyapunov
  900×900 tinha `det` 6,29e-19 mas `rcond` 1,7e-06 — o ramo `ginv` era sempre
  tomado, e SIGMAY tinha o defeito oposto. ⚠ O aviso "Usando pseudo-inversa
  para SIGMAY" que o item previa sair em toda rodada **não reproduz** em
  `(5,5)` (`det(SIGMAY)` 2,9e+24); ganho de tempo previsto também não se
  confirmou (0,198→0,190 min).
- [x] **`estimate_dynamic_factors()` com `q=1<r` corrigido — FEITO em
  2026-08-17.** `M <- diag(sqrt(eigenvals), nrow=q)` cobre todos os `q`;
  smoke test bit-idêntico, `mosw_strength_grid.csv` reproduzido com desvio 0.
- [x] **`amengual_watson()` validado contra o MATLAB de SW — FEITO em
  2026-08-17.** Tradução fiel: `q_hat` 5 contra 5; gap remanescente é a
  constante `log(147/146)`, população vs. amostra. Fonte:
  `output/validation/amengual_watson_validation.md`.
- [x] **`download_di.py`: gate de sanidade posto — FEITO em 2026-08-17.**
  Resolve release pela API, aborta se faltar coluna, <100k linhas ou
  cobertura incompleta. Vintage não fecha por código: upstream trunca/poda
  releases; script aborta com diagnóstico correto em vez de gravar painel
  truncado.
- [x] **`install.packages()` removido de `instrument_diagnostics.R` —
  2026-08-17.** Contra a regra "fail loud"; `broom`/`lmtest` nem eram usados.
- [x] **Renomes registrados no acervo — FEITO em 2026-08-17.**
  `registro/mapa_renomeacoes.md` é o mapa único (2026-07-26 a 2026-08-17).
  `notas/`/`pareceres/` ficam verbatim; `metodo.md` e afins são editados in
  place por serem documentos vivos.
- [x] **`tab:first_stage` cortada para o `.tex` — FEITO em 2026-08-14.** §3.6
  ganhou a Tabela 1 (surpresa bruta → +BS → +JK, duas janelas). Número
  inconveniente reportado: pré-COVID a surpresa bruta é mais forte (ξ_mp 14,86
  contra 10,99 da produção) — produção se justifica por fidelidade, não força.
- [x] **Documentos de governança ressincronizados com a produção —
  2026-08-14.** Quatro `.md` de regra que ainda falavam de 106 séries
  corrigidos contra o output corrente (smoke test, contagem Rigobon, gate
  não-gaussiano). Lição: cada um agora aponta para o artefato que o produz.
- [x] **Produção migrada para 111 séries `(5,5)` — 2026-08-13.** Painel
  `drop_setor_externo__eua__credito__imoveis`; 800 réplicas, zero falhas,
  impacto exato +50pb. Nota:
  `notas/2026-08-13_migracao_producao_painel_111_r5q5.md`.
- [x] **Seleção de fim de mês corrigida — 2026-08-12.** Curva/EMBI+/ANBIMA
  usam a maior data mensal; 25 meses corrigidos. ξ_mp daquela rodada
  7,65/11,53, superada pela migração de 2026-08-13. Nota:
  `notas/2026-08-12_correcao_fim_mes_curva.md`.
- [x] **`R/modeling/svensson_model.R` sem consumidor — FECHADO em
  2026-08-05.** Motor do `script/yield_curve.R` (deletado); curva do painel é
  insumo fixo do orientador. Movido para `arquivo/R/modeling/svensson_model.R`.
- [x] **Taxonomia do `irf_spec_sweep.R` migrada para ξ_mp — FEITO em
  2026-07-26.** `classify_sweep_cells` usa limiares MOSW (3,84/10); 320
  células regeneradas e conferidas contra `mosw_strength_grid.csv`.
- [x] **Prosa do coherence separada do corpo gerado — FEITO em 2026-07-26.**
  `irf_coherence_leitura.md` (manual) vs. `irf_coherence_report.md` (gerado).
- [x] **`irf_mp_raw` renomeado para `irf_mp_pre_tcode` — FEITO em
  2026-07-26.** Nenhum consumidor do campo; zero mudança de output.
- [x] **`script/run_all.R` — FEITO em 2026-07-26.** Orquestrador de 8 estágios,
  um `Rscript` por estágio; flags `--list/--dry-run/--from/--to/--only/--skip`.
- [x] **Branches consolidadas — FEITO em 2026-07-26.** Cinco branches locais
  merged em `main`; `codigo_olea/` (87MB, commitado por engano) removido e
  ignorado.

---

## Convenção de branches

Movida para `.claude/rules/writing.md` (§"Branch convention") em 2026-09-08.
