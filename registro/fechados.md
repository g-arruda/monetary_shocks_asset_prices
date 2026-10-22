# Fechados

Itens que saíram de [`pendencias.md`](pendencias.md), um bloco por tema e, dentro de cada bloco, o mais
recente no topo. Este arquivo não é lido no início da sessão; consulte-o quando precisar saber se algo já
foi feito ou decidido. O detalhe de cada rodada está na nota apontada no item, e o que morreu e por quê,
em [`historico_decisoes.md`](historico_decisoes.md).

Os blocos vieram de `pendencias.md` em 2026-10-19, sem edição. Referências como "acima", "abaixo" ou
"item aberto no Tema B" remetem à organização daquele arquivo na época.

## A. Texto do paper

- [x] **Placebos na §5.2 e `fig:placebos` — 2026-10-22.** E-mails de 08-10, de 12-10 (item 4) e de 19-10
  (item 5). Os placebos vão numa subseção própria, a §5.2, e o parágrafo da §3.3 saiu. Holm vai nos 18
  testes, com rodapé sobre o Wald por série, e não rejeita nada. Sem ajuste, o MSCI de emergentes cai e é
  significante em h0, h1, h3 e h6, como limitação, e o VIX em h6. O VIX em h0 vem com 46% de
  sobreposição. A `tab:placebos_holm` vai no Anexo D, e a figura fica sem marcadores. ⚠ Fora da família,
  o MSCI é significante a 90% em h35–h42, e isso não está no texto. Nota: `2026-10-22_placebos_secao_5`.
- [x] **Escrever o p do teste do EPU — 2026-10-22.** E-mails de 03-10 (passo 4) e de 12-10 (item 4). O
  0,54 era das 102 reuniões. Reestimado nas 111 pela parte C de `placebo_holm.R`, o p é 0,275 (coeficiente
  −0,051, EP HC1 0,047), e o 0,543 das 102 foi reproduzido. Uma frase na §5.2 lê o resultado como
  ausência de evidência de poder preditivo, sem validar a exogeneidade. Nota: `2026-10-22_placebos_secao_5`.
- [x] **Influência, extremos e surpresa bruta no texto — 2026-10-22.** E-mails de 12-10, item 1, e de
  19-10, item 5. A §5 passa a ter duas subseções, 5.1 Benchmark VAR e 5.2 com a `tab:influencia`, cuja prosa
  fala só de sinal e significância. Sem as 10 mais influentes, o resultado é inconclusivo (ξ_mp 2,36). Sem
  as 5 e sem os 14 extremos, o câmbio perde os 90% no impacto, e o CDS fica estável. As três maiores quedas
  individuais do câmbio são de reuniões do Brent. No Anexo E, uma frase diz que a surpresa bruta é
  significante a 90% e não a 95%. ⚠ O e-mail de 12-10 dizia "não significante a 90%". ⚠ As janelas de
  feriado na regra dos extremos ficam fora do texto. Nota: `2026-10-22_cds_janelas_influencia_extremos`.
- [x] **CDS estreito contra ampliado — 2026-10-22.** E-mail de 19-10, item 4. Entra no parágrafo do CDS do
  Anexo F como sensibilidade ao alinhamento temporal, com Wald de 90% por +50 p.b. de surpresa: −0,8 contra
  +7,7 [0,7; 14,7] nas 111, e a ampliada não é significante a 90% na de 104. Uma frase dá os 156 feriados
  dos EUA com cotação e diz que a de 28/11/2013 é inteira e fica. Nota:
  `2026-10-22_cds_janelas_influencia_extremos`.
- [x] **Leitura da trajetória diária — 2026-10-22.** E-mail de 19-10, item 1. Parágrafo sem números no fim
  do Anexo E, depois da `tab:ponte`: câmbio não significante a 90% até a 10ª cotação e significante a 95% na
  20ª, com limite inferior perto de zero; CDS a 95% na 10ª e só a 90% na 20ª; na agregação alternativa o
  câmbio não é significante a 90%. A §4.2 ganhou uma frase com a leitura do item 5 e o ponteiro (decisões
  do autor). Nota: `2026-10-22_conferir_e_trajetoria_diaria`.
- [x] **Reescrever as 22 frases marcadas `[conferir]` — 2026-10-22.** Reescritas no lugar, sem marcador. O
  IPCA do DFM sobe no impacto e fica positivo até h7, o VAR coincide em 4 de 5 sinais, a ortogonalização
  reduz ξ_mp e F_rob (F_rob sem número no texto), e a conclusão perdeu a cláusula da apreciação. Nota:
  `2026-10-22_conferir_e_trajetoria_diaria`.
- [x] **Atualizar os números do artigo para a base de 111 reuniões — 2026-10-21.** E-mail de 12-10, item 1.
  §3.4, §4, §5 e Anexo D na base de 111; resumo, introdução e conclusão só em números e datas. A §4.2
  ganhou os horizontes significantes a 90%, só a 80% e não significantes de BRL/USD, EMBI+ e CDS: a
  apreciação cambial é significante só a 80% (h26–h36), o CDS e o EMBI+ a 90% em h35–h36. Onde a
  afirmação virou (o IPCA do DFM sobe no impacto, +0,020), ficou um marcador, item aberto no Tema A.
  Nota: `2026-10-21_artigo_base_111`.
- [x] **Amostra e construção do instrumento na §3.3 e na §3.4 — 2026-10-21.** E-mail de 19-10, item 3.
  Dois rodapés na §3.3: as 7 janelas de quarta a sexta, e a sensibilidade de 104 com z = 0 nos momentos
  (ξ_mp 6,55, câmbio 0,136, CDS 32,4). A §3.4 em relevância, força (equação de ξ_mp em rodapé) e
  limitação dos conjuntos. Decisão do autor: o 10 sem citar Staiger e Stock, e o F_rob da bruta (10,85)
  só na tabela. O rodapé do JK refeito com a célula reestimada: 67 de 111, pares significantes
  1390 → 1122. Nota: `2026-10-21_artigo_base_111`.
- [x] **Apêndice com as convenções temporais e as fontes — 2026-10-21.** E-mail de 19-10, item 4. Anexo F
  novo, depois do E: anúncio e margem de 30 minutos, DI, Yahoo e CDS, a `tab:horarios` e as fontes em três
  rodapés com URL. A §3.3 aponta para ele num rodapé. Decisões do autor: Anexo F, e não um rodapé único;
  Yahoo e CDS escritos como fato, sem "hipótese"; a margem só como regra. Nota:
  `2026-10-21_convencoes_temporais_feriados_cds`.
- [x] **Figura e tabela da ponte — 2026-10-20.** E-mail de 19-10, item 2. Anexo E novo, com parágrafo de
  abertura, `fig:ponte` (`script/fig_bridge.R`) e `tab:ponte`, só na base de 111 (110 reuniões na
  trajetória). Decisões do autor: 90% e 95% nos dois floats, inclusive no DFM; a forma reduzida como IV
  por +50 p.b. no DI de 6 meses; a agregação alternativa em linhas, com o câmbio de fim de mês não
  significante a 90%. A base de 104 entra numa frase (escolha delegada): só a 1ª cotação do câmbio muda,
  e passa a significante a 90%. Nota: `2026-10-18_conferencias_ponte`.
- [x] **Responder ao orientador com o prazo da versão integrada — 2026-10-19.** Prazo informado: 28/10.
  A resposta não está em `email/`.
- [x] **O que o resumo diz sobre frequência — 2026-09-22.** O resumo situa a divergência com
  `goncalves2025` na condição de identificação, não na frequência nem na agregação: ela vale nas três
  séries diárias e falha nas mesmas três no painel mensal; "as condições" virou "a condição de posto".
  As afirmações de que a agregação vira o sinal e de que não é o obstáculo foram revertidas. Movido dos
  abertos em 2026-10-19. Nota: `2026-09-22_condicao_het_svars`.
- [x] **O que a §2 diz sobre o CDS de Gonçalves, Rodrigues e Genta — 2026-09-22.** A §2 reporta o
  fechamento de 3 a 11 p.b., com o vértice de doze meses distinto de zero, e registra que os autores o
  descrevem como ausente; a unidade inferida fica em `het_rigobon/_common.R`. Reforça o contraste com os
  +30,5 p.b. do DFM daquela produção. Movido dos abertos em 2026-10-19.
- [x] **Frase do Anexo C sobre `fig:lp_sensibilidade` e ponteiro da §3.4 — 2026-10-17.** Branch
  `feature/focus-horizonte-fixo`, só texto. A nota de rodapé da §3.1, a que o orientador leu (e-mail de
  30-09, item 4), diz agora que a figura cruza o estimador (com a reescala e por mínimos quadrados
  ordinários) com `q` de 2 a 5. A legenda já dizia isso e ficou. A frase de `fig:precovid_sensibilidade`,
  partida em `b0a3a10` entre a §3.3 e a §3.4, voltou inteira ao fim do parágrafo de `tab:first_stage`.
- [x] **Figura de placebos no `.tex` conferida — 2026-10-13.** O orientador (e-mail de 30-09) dizia
  que `\autoref{fig:placebos}` não tinha figura nem rótulo. No `paper.tex`, `\includegraphics` e
  `\label{fig:placebos}` estão no Anexo D desde `1a150d0`, o PDF existe em `paper/img/`, o `paper.aux`
  resolve o rótulo (figura 15, p. 31) e o `paper.log` não tem referência indefinida. A versão que ele
  leu era anterior ao commit. ⚠ Conferência estática, sobre o log de 30-09; não recompilado.
- [x] **Rodapé sobre a saída do filtro Jarociński-Karadi — 2026-09-30.** Na §3.4: o filtro reduz
  ξ_mp de 7,02 para 5,01 (pré-COVID, 6,84 para 4,73) e F_rob de 8,62 para 7,59 (8,31 para 7,78),
  nenhum ponto sai do conjunto de 90% de produção (0/4255), e os pares significativos a 90% caem de
  1587 para 856. A §1 e os resumos, que `6e0bc00` tinha devolvido à descrição com o filtro, voltaram
  à de 26-09. ⚠ Com o filtro o impacto no Ibovespa exclui zero (−8,17%), em parte por construção, e
  o rodapé não o diz; o "3.64%" do resumo em inglês segue no item de resumo e conclusão acima.
  Branch `feature/robustez-pandemia`. Nota: `2026-09-30_nota_filtro_jk`.
- [x] **Sensibilidade a `q` com e sem a reescala de Lenza-Primiceri no Anexo C — 2026-09-30.**
  `script/pandemic_sensitivity.R` e `fig:lp_sensibilidade`: `q` de 2 a 5 em duas colunas, com a
  reescala e por MQO, uma linha de painéis por série, cada `q = 5` com os próprios conjuntos AR.
  Rodapé na frase de MQO da §3.1, nenhum número no corpo. Nas oito séries do anexo, 4, 26 e 26 de
  296 pontos de `q = 4`, 3 e 2 saem do conjunto de 90% com a reescala, contra 44, 132 e 154 sem
  ela (painel: 151/420/408 contra 589/1651/1805 de 4255). ⚠ Com a reescala as respostas não são
  insensíveis a `q`: em `q ≤ 3` o câmbio sai do conjunto de h0 a h9 e a DBGG de h0 a h7, e o
  impacto da DBGG troca de sinal. Em `q = 5` nenhum ponto de MQO sai do conjunto da produção
  (0/4255). Branch `feature/robustez-pandemia`. Nota: `2026-09-30_robustez_pandemia`.
- [x] **As oito séries das figuras do Anexo C — 2026-09-30.** Por decisão do autor, as cinco
  figuras desenham DI de 6 meses, DI de 2 anos, BRL/USD, CDS, Focus PIB, Focus IPCA 12 meses,
  Focus Selic e DBGG, no lugar de DI de 5 anos, IBC-Br, IPCA, Ibovespa e DLSP. Nada reestimado.
  ⚠ A figura pré-COVID deixa de mostrar atividade, preços e ações, que saem do conjunto em 12 a
  21 dos 37 horizontes. Nota: `2026-09-30_robustez_pandemia`, seção 6.
- [x] **Placebos na §3.3 e figura no Anexo D — 2026-09-30.** Desfecho "limitação reconhecida",
  em quatro linhas por decisão do autor: nos dois primeiros anos só o conjunto de 90% do EPU dos
  EUA exclui zero (h1–h3), e a resposta permanece com o EPU diário pré-reunião na ortogonalização
  (Tema D). `fig:placebos` foi para o Anexo D, depois da `tab:bs_ortogonalizacao`. As demais
  leituras (VIX e MSCI nulos no impacto, projeção local da série bruta) ficaram só na nota.
  Commit `1a150d0`. Nota (só na branch `feature/placebo-epu`): `2026-09-29_placebo_epu`.

- [x] **Paper migrado para a produção da branch — 2026-09-26, na branch, promovido
  para `main` no mesmo dia.**
  `z_bs_purif`, conjuntos de 80/90% e, por decisão do autor, o filtro JK fora do
  paper inteiro (§2, §3.3, linha 3 da `tab:first_stage`, coluna do Ibovespa da
  `tab:bs_ortogonalizacao`, camada JK da `fig:instrumento_camadas`). ξ_mp 7,02 / 6,84,
  BRL/USD 3,53%, CDS 34,0 p.b.; 143 + 20 números da §4 e da §5 conferidos contra o
  cache; sete passagens reescritas (ajuste cambial contém zero a 80%, IMAT
  negativo no impacto, câmbio de volta a 90% em h32–h36 na conclusão). Promovido
  para `main` no mesmo dia. Nota: `2026-09-26_migracao_paper_bs_purif`.

- [x] **Bandas das IRFs em 80/90%, como em AK, do lado do código — 2026-09-26,
  na branch.** `CI_LEVELS`, o default de `main_sdfm()`, as colunas `*80` de
  `irf_coherence_h.csv` e `instrument_layers_irf.csv`, as faixas das figuras e o
  benchmark VAR (`model_var.R`, `fig_weak_iv.R`) passaram a 80/90%;
  `validate_mosw_ar.R` fica em 68/95%, os níveis do oráculo. Todos os conjuntos
  seguem `interval` a 80 e 90% (2841 + o `singleton` da normalização). O lado do
  paper está no item de migração acima. Nota:
  `2026-09-26_producao_bs_purif_bandas_80_90`.

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
  defensiva sobre UIP/dominância fiscal removida. Fonte: `paper/paper.tex`.
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
  cruzada seria erro. `paper/paper.tex:335`.

## B. Robustez estatística

- [x] **Listar as cotações de CDS em feriados dos EUA — 2026-10-21.** E-mail de 19-10, item 4. A lista
  une os calendários da NYSE e do Fed: são 156 dias úteis de 2012-03 a 2025-12, e o CDS cota em todos. A
  única cotação inteira entre eles é a de 28/11/2013. Saída: `output/copom_timing/cds_us_holidays.csv`.
  Nota: `2026-10-21_convencoes_temporais_feriados_cds`.
- [x] **Rodar de novo na base de 111 as saídas que estavam na de 102 — 2026-10-20.** Branch
  `feature/auditoria-janelas-copom`. Rodaram a força, os diagnósticos, a precisão, o VAR, os anexos, as
  figuras de `paper/img/`, os placebos e a influência. Os extremos vão de quarta a sexta nas 9
  recuperadas (decisão do autor, `cb24156`), e o Juneteenth de 2024 vai de terça a quinta, como antes.
  - `tab:first_stage`: 7,28 / 9,34. ⚠ O F_rob da bruta é 10,85.
  - Holm não rejeita.
  - ⚠ O câmbio deixa de ser significante a 90% no impacto sem as 5 e sem os 14 extremos.
  - Nota: `2026-10-20_saidas_base_111`.
- [x] **Enviar ao orientador a resposta ao e-mail de 18-10 — 2026-10-18.** Enviada às 20h26
  (`email/email_meu_18-10_20h26.md`): as cinco conferências e a ponte nas bases de 111 e 104. O orientador
  respondeu em 19-10 e encerrou a auditoria. Nota: `2026-10-18_conferencias_ponte`.
- [x] **Conferência 2/4: câmbio, PTAX e Yahoo — encerrada pelo orientador em 2026-10-19.** As janelas
  da PTAX e do Yahoo largo estão em `meetings.csv` desde 15-10. Os carimbos da API (18-10) mostram que a
  data da linha do Yahoo é a data UTC da meia-noite de Londres, e a janela larga pelas datas das linhas só
  foi explicada (decisão do autor de 18-10). A regressão do evento com a PTAX na janela ampla não rodou.
  O evento diário usa o Yahoo pela convenção do anúncio, e a série do DFM não mudou. ⚠ O horário do
  Yahoo é hipótese documentada, não janela estreita comprovada (e-mails de 14-10 e 19-10).
- [x] **Cotações intradiárias da Bloomberg — dispensadas em 2026-10-19.** As 8 datas foram enviadas em
  16-10, e nada chegou. O e-mail de 19-10 dispensa a busca por horários históricos. Nenhum código lê
  esses dados. ⚠ Se chegarem, a cotação no horário do anúncio sozinha não data a linha do Yahoo: casá-la
  com 20h, 21h ou 22h exige as cotações nessas horas.
- [x] **Passo 3/5, parte 2: a regra de extremos na variação de terça a quarta — encerrado sem rodar em
  2026-10-19.** Pela letra da regra de 10-12 (`2cad8bd`), a condição se cumpria no câmbio (impacto 0,145
  → 0,107, sem os 95%), mas nenhum e-mail desde 12-10 pede a verificação, e o de 19-10 pede que não se
  abra outra rodada. O desenho fica no histórico do git. Nota: `2026-10-12_exclusao_extremos`, seção 4.
- [x] **Passo 5/5: apêndice com surpresa bruta, ortogonalizada e filtro JK — encerrado sem rodar em
  2026-10-19.** Reverteria a saída do filtro do artigo (2026-09-26), e nem o e-mail de 12-10 nem o de
  19-10 o pedem; a surpresa bruta entra no texto pelo Tema A. ⚠ As linhas JK só existem no git
  (`3b9e402`); na base da `focus`, ξ_mp de `z_jk_bs_purif` cai de 5,01 para 4,83 na janela completa, então
  "já estimado" não valeria. Nota: `2026-09-30_nota_filtro_jk`.
- [x] **Conferência 3/4 (CDS estreito contra ampliado) e conferências do e-mail de 18-10 — 2026-10-18.**
  Branch `feature/auditoria-janelas-copom`. O passo 2 passou às 17h de NY: na produção, estreita −0,8 p.b.,
  ampliada +7,7 [0,7; 15,0], significante a 90%. Carimbos do Yahoo: a data da linha é a data UTC da
  meia-noite de Londres. Ponte em 111 e 104; ⚠ na produção a apreciação na 1ª cotação deixa de ser
  significante a 90% (p 0,107). Nota: `2026-10-18_conferencias_ponte`.
- [x] **Mandar ao orientador a tabela corrigida e a comparação das três bases — 2026-10-17.** Enviado às
  18h36 (`email/email_meu_17-10_18h36.md`); o orientador respondeu em 18-10. Nota:
  `2026-10-17_auditoria_janelas_copom`.
- [x] **Conferência 4/4: reuniões recuperadas, e auditoria das janelas — 2026-10-17.** Branch
  `feature/auditoria-janelas-copom`, pelo e-mail de 17-10.
  - O filtro de S&P 500, VIX e Brent saiu. A produção tem as 111, com a BS refeita: as 2 de Ação de
    Graças e as 7 de feriado no Brasil, de quarta a sexta. A sensibilidade sem as 7 é a de 104.
  - Câmbio e CDS em h0, significantes a 90% nas três bases: 0,145 / 0,136 / 0,125 e 33,5 / 32,4 / 30,6 p.b.
    ξ_mp 6,66 / 6,55 / 7,28.
  - Classificação pré, pós ou ambígua com margem de 30 min. Yahoo e CDS ficam como hipóteses. O DI1 fecha
    às 18h00 desde 2019, e antes vale o limite de 18h15.
  - O ξ_mp pré-COVID da produção é 4,87.
  - Nota: `2026-10-17_auditoria_janelas_copom`.
- [x] **Mandar ao orientador a conferência 1/4 e perguntar a janela ampliada do CDS — 2026-10-16.**
  `email/email_meu_16-10_12h53.md`, com a tabela das 9 em anexo (`output/copom_timing/excluded_meetings_advisor.csv`,
  só o que o e-mail de 14-10 pede). Diz que as 2 de Thanksgiving ficaram fora por erro e entram na amostra
  principal, e pergunta se a janela ampliada do CDS é de terça a quinta ou a estreita mais uma variação de
  cada lado; as duas leituras já estão em `meetings.csv`. Nota: `2026-10-16_janela_ampliada_cds_bloomberg`.
- [x] **Mandar ao orientador as datas para a cotação intradiária da Bloomberg — 2026-10-16.** No mesmo
  e-mail: 8 datas (maior |ΔDI| por regime do anúncio e horário europeu, 6 no inverno europeu) com os
  horários do anúncio; nas 3 anteriores a 2016-07, o fim da ata e a primeira matéria do G1 (7 a 10 minutos
  depois). ⚠ Na 174ª a faixa (19h56–20h06) cai sobre as 20h inferidas do Yahoo. ⚠ Conta exploratória de
  14-10, não versionada: só as 10 reuniões de 2024-11 a 2025-12 têm intradiário no Yahoo, e nelas o câmbio
  anda |R$ 0,005| do anúncio à cotação da noite e |R$ 0,027| dela até quinta às 12h. Nota: idem, seção 2.
- [x] **Conferência 1/4: tabela das reuniões afetadas — 2026-10-15.** Branch
  `feature/focus-horizonte-fixo`, nada reestimado. As 9 fora das 102, com horários, feriado, motivo e
  janelas de DI, PTAX, Yahoo (convenção e larga) e CDS às 17h de NY. 7 caem pela quinta feriado no
  Brasil (DI e PTAX de quarta a sexta, um pregão, mesmo contrato); 2 só pelo filtro de S&P 500, VIX e
  Brent no Thanksgiving. ⚠ CDS ampliado fora (item acima). Nota: `2026-10-15_conferencia_reunioes_fora`.
- [x] **Evento diário e ponte (a): a janela do câmbio do Yahoo — respondido pelo orientador em
  2026-10-14.** Ponto 1 de `email_meu_14-10_10h55.md`. Resposta: o fuso da API não confirma a hora da
  cotação. Preferir câmbio à vista com horário documentado e, sem ele, a PTAX de venda como diagnóstico
  numa janela diária mais ampla. Manter o Yahoo para comparação, da véspera da reunião ao primeiro dia
  útil posterior, sem apresentá-lo como janela estreita. Não trocar agora a série do DFM. Abriu a
  conferência 2/4 e o item das datas para a Bloomberg, que leva a conta exploratória intradiária de
  14-10 (acima). Em 15-10 o autor seguiu o orientador e reverteu a decisão de 14-10 de nunca usar a PTAX.
- [x] **Decidir se as 9 reuniões fora das 102 entram no instrumento — respondido pelo orientador em
  2026-10-14.** Ponto 3 do mesmo e-mail. Resposta: nenhuma fica com z = 0 automaticamente; as 2 de
  Thanksgiving têm DI válido e não caem pela falta de um controle; as 7 de feriado no Brasil entram como
  sensibilidade, da última à primeira observação válida; surpresa indisponível é ausente, fora dos
  momentos de Γ e da regressão mensal. Abriu as conferências 1/4 e 4/4 (acima). Na ponte (b), tirar os 9
  meses não muda sinal nem significância. Nota: `2026-10-13_ponte_horarios_copom`, seção 6.
- [x] **Ponte (b): forma reduzida mensal sem os fatores — 2026-10-14.** Branch
  `feature/focus-horizonte-fixo`. Regra commitada antes de rodar (`e19a754`), em
  `script/monthly_reduced_form.R`.
  - Desenho: as 162 inovações do DFM, h = 0 e 1, surpresas ortogonalizada e bruta. Séries do painel
    (câmbio média, CDS fim de mês) e a outra agregação dos diários (câmbio de fim de mês alinhado, CDS
    média do Bloomberg).
  - Na linha de referência (painel, ortogonalizada), por +50 p.b. de surpresa: o real deprecia R$ 0,145
    no mês e R$ 0,293 até o seguinte, e o CDS alarga 41,3 e 43,0 p.b., tudo significante a 95%. Pela
    regra, caso (i): a depreciação aparece no mensal sem fatores.
  - Fim de mês contra média e meses sem reunião estão documentados na nota (seções 2 e 3). As três
    amostras (zero, sem os 9 meses de reunião fora, só reuniões) não mudam sinal nem significância.
  - ⚠ Com o câmbio de fim de mês, +0,115 e +0,158, não significante a 90%.
  - ⚠ Por +50 p.b. de `yield_6m`, o primeiro estágio tem F 9,30. O câmbio dá 0,078/0,158 e o CDS
    22,3/23,2, contra 0,145/0,179 e 33,5/36,9 do DFM.
  - ⚠ O CDS do painel pode estar desalinhado em 2016-11 e 2024-01, porque o horário do Investing não é
    conhecido.

  Nota: `2026-10-14_ponte_mensal_forma_reduzida`.
- [x] **Ponte (a): trajetória acumulada após o evento — 2026-10-14.** Branch
  `feature/focus-horizonte-fixo`. Regra commitada antes de rodar (`0b08071`), em
  `script/event_trajectory.R`.
  - Desenho: da última cotação antes do anúncio à 1ª, 5ª, 10ª e 20ª depois, contadas no próprio
    mercado. Câmbio Yahoo e CDS às 17h de NY. 101 reuniões, porque falta a 20ª cotação de 2025-12-10.
    Forma reduzida na surpresa ortogonalizada, HC1.
  - Por +50 p.b., o real aprecia R$ 0,029 na 1ª cotação (significante a 90%) e deprecia R$ 0,122 até a
    20ª (significante a 95%; 2,40%, significante a 90%). O CDS alarga 16,5 p.b. até a 10ª (significante
    a 95%).
  - Pela regra, a troca de sinal do câmbio já aparece na trajetória diária. ⚠ k = 5 e 10 do câmbio não
    são significantes a 90%, e a troca não fica datada.
  - ⚠ Conta exploratória fora da regra, não versionada: sem a reunião de 2020-03-18, o CDS é
    significante a 95% em k = 5, 10 e 20, e o câmbio em k = 20 fica em 0,117.
  - ⚠ k = 1 do CDS às 17h de NY difere do passo 2, que usa quarta a quinta (item acima).

  Nota: `2026-10-14_ponte_trajetoria_evento`.
- [x] **Ponte (a), antes de rodar: a janela do CDS — decidida pelo autor em 2026-10-14.** O CDS fecha
  sempre às 17h de Nova York: em 27 das 102 reuniões, a janela vai da cotação anterior à quarta até a
  de quarta.
  - ⚠ Decisão sobre um horário que nem o arquivo nem os dados fixam: o teste da regra `5048a09` deu
    inconclusivo (nota `2026-10-13_ponte_horarios_copom`, seção 5).
  - O orientador respondeu em 14-10 sem indicar horário: o corpo do e-mail não tem o item 2, e a entrega
    3 pede a janela ampliada, com as duas mudanças adjacentes (conferência 3/4, acima). O autor manteve
    as 17h de NY em 15-10.
  - Abriu o item do passo 2 e do Anexo B (acima).
- [x] **Ponte, conferência: o que é exatamente o dia do Copom — 2026-10-13.** Branch
  `feature/focus-horizonte-fixo`; nada reestimado, instrumento intocado. Anúncio reunião a reunião pelas
  atas do BCB (estágio `copom_atas`): 19h19–20h55 até jun/2016, 18h00–18h20 até out/2020, 18h30–19h12
  depois. As janelas do DI (fechamento a fechamento) e da PTAX (13h a 13h) cumprem a convenção nas 102.
  - ⚠ A janela do CDS de quarta a quinta só cumpre a convenção com fechamento em Londres; com Nova York
    falha em 27 (17h) a 77 (18h) das 102. O teste fixado antes (`5048a09`) é inconclusivo. Abriu o item
    da janela do CDS na ponte (a).
  - ⚠ 9 das 111 reuniões ficam fora (7 quintas de feriado no Brasil, 2 de Thanksgiving), e seus meses
    entram com z = 0. Abriu o item de decisão (acima).
  - **Câmbio refeito no mesmo dia** com o Yahoo pela convenção (decisão do autor): a janela vai da
    noite de terça à de quarta em 96 das 102. Nota `2026-10-13_cambio_yahoo_convencao`.

  Nota: `2026-10-13_ponte_horarios_copom`.
- [x] **Responder ao orientador sobre o plano de 03-10 — superado em 2026-10-13.** Os passos 0 a 4
  rodaram e foram reportados em `email/email_meu_12-10_17h22.md`, e ele respondeu em
  `email/email_professor_12-10_19h40.md`. Pré-COVID: aceitou os conjuntos em `p = 2`, sem apresentá-los
  como a mesma especificação. "Excluir uma reunião" e a avaliação conjunta dos placebos: respondidos em
  10-08, com Holm aprovado em 12-10. O filtro JK segue no passo 5/5. ⚠ `email/` não tem resposta do
  autor ao plano entre 03-10 e 08-10.
- [x] **Passo 3/5, parte 2: exclusão por movimentos extremos de VIX, S&P 500 ou Brent — 2026-10-12.**
  Regra fixada e commitada antes de rodar (`2cad8bd`): sai a reunião em que a variação log de quarta a
  quinta de alguma das três passa, em módulo, do percentil 95 da série nos pregões de 2012-03 a
  2025-12. Célula `sem_extremos` de `script/meeting_influence.R`, só em Γ. Marcadas 11 reuniões, 5 por
  série, três entre as dez mais influentes. ξ_mp 6,66 → 5,67. O CDS fica estável (32,0 contra 33,5
  p.b. no impacto), significante a 95% em h0, h1 e h3, e nenhum ponto do painel sai do conjunto de 90%
  de produção.
  - ⚠ O câmbio cai 26% no impacto (0,145 → 0,107), perde os 95% em todo horizonte e segue significante
    a 90% em h0–h4. A queda vem mais das reuniões marcadas pelo Brent, no sentido oposto ao da leitura
    registrada. Abriu o item da janela de terça a quarta (acima).
  - ⚠ O `BZ=F` não separa salto de troca de vencimento de variação de preço. Nenhuma das cinco datas
    marcadas pelo Brent é último dia útil do mês.

  Nota: `2026-10-12_exclusao_extremos`.
- [x] **Passo 4/5, placebos com Holm — 2026-10-09.** Desenho do e-mail de 08-10, na branch
  `feature/focus-horizonte-fixo` sobre a base do passo 0. Nada reestimado: são os p-valores AR em zero da
  tabela do passo 1, conferida contra o cache. Se a base mudar, rerodar `script/ar_precision.R` e
  `script/placebo_holm.R`.
  - Holm nos 18 testes (VIX, `msci` e EPU dos EUA em h = 0, 1, 3, 6, 12, 24) não rejeita nada a 10%,
    com menor p ajustado 0,983. Sem ajuste, rejeitam a 10% a `msci` em h3 e h6 (p 0,055) e o VIX em
    h6 (p 0,088).
  - Só o VIX entra na ortogonalização, como tendência de 65 pregões até a quarta, com coeficiente
    −0,025 (p 0,92). ⚠ Em h0 o mês do VIX se sobrepõe à janela, e o teste não é de todo independente.
  - **Rerodado em 10-12** com a `msci` sendo o índice de emergentes (até então era a ação da MSCI Inc.).
    Holm nos 18 testes segue sem rejeitar a 10% (menor p ajustado 0,575). Sem ajuste, rejeitam a 10% o
    índice em h0, h1 e h3 e o VIX em h6. ⚠ O índice cai 27,5 pontos no impacto e 27,3 em h1, e h1
    rejeita a 5% (p 0,032). A família de 12 saiu do script.

  Notas: `2026-10-09_placebos_holm` (desenho), `2026-10-12_msci_emergentes` (números correntes).
- [x] **Passo 3/5, influência das reuniões — 2026-10-08.** Desenho do e-mail de 08-10, na branch
  `feature/focus-horizonte-fixo` sobre a base do passo 0: fatores, VAR e inovações fixos, a reunião sai
  só do momento Γ, e T = 162 e o calendário ficam intactos. Ordem por max_k |ΔΓ_k|/EP_k nas 99 reuniões
  que entram em Γ. Se a base mudar, rerodar `script/meeting_influence.R`.
  - Nenhuma exclusão individual muda sinal ou força: câmbio h0 0,126–0,175, CDS 28,9–42,0, ξ_mp
    5,52–7,61.
  - Juntas, as 5 mais influentes levam ξ_mp a 3,59 e as 10 a 2,01 (81% do momento de normalização).
    Câmbio e CDS perdem os 95% sem as 5 e os 90% sem as 10, com ponto do mesmo sinal.
  - ⚠ A significância depende de poucas reuniões, em parte por construção da ordem.
  - ⚠ Três reuniões de 2012 caem antes da primeira inovação e não entram em Γ.
  - **Rerodado em 10-12** sobre a base com o índice de emergentes. As 5 e as 10 mais influentes são as
    mesmas. Sem as 5, ξ_mp vai a 3,54; sem as 10, a 1,82. ⚠ O câmbio sem as 5 é significante a 90% até
    h4, antes h5.

  Notas: `2026-10-08_influencia_reunioes` (desenho), `2026-10-12_msci_emergentes` (números correntes).
- [x] **Passo 2/5: evento diário — 2026-10-05.** Rodado na branch `feature/focus-horizonte-fixo` sobre
  a base do passo 0, com a PTAX como câmbio diário (estágio `ptax`) e as 102 reuniões como amostra
  comum. Se a base mudar, rerodar `script/daily_event.R`; só o lado do DFM depende dela.
  - No dia do Copom, +50 p.b. de surpresa vem com o real apreciando R$ 0,048 (1,04%), significante a
    95% com a surpresa bruta e com a ortogonalizada (p 0,019 e 0,021). O CDS não é significante a 90%.
  - O primeiro estágio é a identidade na bruta e tem F 656 na ortogonalizada.
  - O câmbio só troca de sinal no DFM mensal (+0,099 com a bruta, +0,146 na produção). A divergência
    surge na passagem do diário ao DFM, que muda frequência, janela, normalização, medida e modelo
    juntos, sem decomposição.
  - ⚠ No CDS o ponto troca de sinal já na ortogonalização (+0,9 → −0,5 p.b.), e nenhum dos dois é
    significante a 90%.
  - **Rerodado em 10-12.** As regressões diárias saíram byte-idênticas. No DFM, o câmbio vai a +0,096
    com a bruta e a +0,145 na produção.
  - **Câmbio refeito em 10-13** com o Yahoo pela convenção, por decisão do autor: −R$ 0,037 (0,80%, p
    0,012) na bruta e −R$ 0,029 (0,66%, p 0,088) na ortogonalizada. ⚠ A ortogonalizada perde os 95%. CDS
    e DFM não mudam. Nota `2026-10-13_cambio_yahoo_convencao`.

  Notas: `2026-10-05_evento_diario` (desenho), `2026-10-12_msci_emergentes` (números correntes).
- [x] **Passo 1/5: precisão — 2026-10-05.** Rodado na branch `feature/focus-horizonte-fixo` sobre a
  base do passo 0, ainda não congelada. Se a base mudar, rerodar `script/ar_precision.R`.
  - Câmbio e CDS são significantes a 95% no impacto (p 0,013 e 0,015), até h3 e h4.
  - Pré-COVID só em `p = 2` (ξ_mp 5,64; significantes a 95% em h0–h11), porque `p = 4` é barrado.
  - Os momentos de ξ_mp e dos testes de câmbio e CDS não têm autocorrelação até h12.
  - NW 1–3 não muda o impacto. NW 4–12 estreita os conjuntos, e ξ_mp chega a 10,01.
  - ⚠ O ponto pré-COVID de `p = 4` sai do conjunto de `p = 2` em h10–h22.
  - ⚠ Com a base nova, o impacto pré-COVID do câmbio em `p = 4` vai de 0,056 a 0,121.
  - **Rerodado em 10-12** sobre a base com o índice de emergentes. No impacto, câmbio e CDS seguem
    significantes a 95% (p 0,015 e 0,017). O pré-COVID `p = 2` tem ξ_mp 5,87. ⚠ O CDS deixa de ser
    significante a 95% em h2 (p 0,051), e ξ_mp com NW(12) fica em 9,79, abaixo de 10.

  Notas: `2026-10-05_precisao_ar` (desenho), `2026-10-12_msci_emergentes` (números correntes).
- [x] **Robustez à pandemia: respostas pré-COVID no Anexo C — 2026-09-30.** Sugestão do
  orientador de 28-09. `fig:precovid_sensibilidade`, em ponto (`hac_dim` 135 ≥ 90 barra a banda),
  com uma frase na §3.4 e nenhum número no corpo. Curva e risco ficam dentro do conjunto de 90%
  da produção (DI de 6 meses a 10 anos, CDS e EMBI+, 0/37 cada). ⚠ O câmbio sai no impacto
  (R$ 0,056 contra 0,141, abaixo do limite de R$ 0,069), a DBGG tem o sinal oposto ao da produção
  e sai em 22 dos 37 horizontes, e no painel 1407 de 4255 pontos saem, em 103 das 115 séries:
  IBC-Br, IPCA, Ibovespa e DLSP, fora da figura, em 12 a 21 dos 37 horizontes. ⚠ Ponto contra
  conjunto da amostra completa não é teste de igualdade. Branch `feature/robustez-pandemia`. Nota:
  `2026-09-30_robustez_pandemia`.
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
  `paper/img/fig_q_sensibilidade.pdf`: oito séries até h36, com `q = 5` guardado contra
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

## C. Identificação por momentos e por heterocedasticidade — encerrado

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

## D. Diagnósticos e comparações

- [x] **Câmbio diário do Yahoo: hora da cotação e janela pela convenção — 2026-10-13, na branch
  `feature/focus-horizonte-fixo`.**
  - Por decisão do autor, todo o câmbio diário passa ao Yahoo pela convenção: o passo 2, a conferência
    e a linha diária do Anexo B.
  - A linha datada d traz a cotação da noite (20h–22h em Brasília). Na quarta, ela vem depois do
    anúncio em 96 das 102 reuniões.
  - ⚠ A leitura de 10-05 ("45 de inverno deslocadas") estava errada: a janela pelas datas perde o
    anúncio nas 51 de verão.
  - Evento diário: −R$ 0,037 (p 0,012) na bruta e −R$ 0,029 (p 0,088) na ortogonalizada, que perde os
    95%.
  - Anexo B diário: `Qr` p 0,002, 0,064 e 0,081 nos três vértices. ⚠ A razão de variância do câmbio
    vai de 1,04 a 0,69. `het_rigobon/` segue com as datas, em quarentena.

  Nota: `2026-10-13_cambio_yahoo_convencao`.

- [x] **A série `msci` era a ação da MSCI Inc.; vira o índice MSCI de emergentes — 2026-10-12, na
  branch `feature/focus-horizonte-fixo`.** Achado no passo 4/5 (nota `2026-10-09_placebos_holm`,
  seção 4). O índice (MSCI 891800, preço em USD, fim de mês) vem da própria MSCI pelo estágio `msci`
  e entra em `clean.R` na coluna e na posição da `msci`. As outras 114 séries ficaram bit-idênticas,
  e os passos 0 a 4 rodaram de novo. Câmbio e CDS não mudam (0,145 e 33,5 p.b. no impacto). ⚠ Sem
  ajuste, o placebo do índice cai no impacto e em h1. ⚠ `main` segue com a ação até a promoção.
  Nota: `2026-10-12_msci_emergentes`.

- [x] **Placebo EPU dos EUA e o EPU como controle da ortogonalização — 2026-09-30, na branch
  `feature/placebo-epu`.** O controle pedido pelo orientador não absorve: a tendência de 13
  semanas do EPU diário antes da reunião não prevê a surpresa (p 0,543; a do mensal, t 0,0002), e
  o EPU segue `placebo_viola` em h1–h3 (h1 +11,52, 90% [0,66; 31,31]); a violação não existe na
  surpresa bruta nem com um bloco isolado da regressão BS, e zerar 2020-03 devolve zero ao
  conjunto. O autor seguiu com a limitação reconhecida: produção de `main` intocada, branch aberta
  e sem merge. ⚠ A branch leva o controle no código de produção e não pode entrar em `main` como
  está. Nota (só na branch): `2026-09-29_placebo_epu`.

- [x] **VAR mensal do Anexo B sob a escala COVID de Lenza-Primiceri — 2026-09-27.** Duas versões
  do VAR de DI, câmbio e CDS, MQO e MQP com θ próprio por vértice (máximo único em 750 inícios),
  ambas pelo caminho da linha fatorial (161 meses). O tratado não rejeita `λ₁ = λ₂` (p 0,965 /
  0,824 / 0,966), as três variâncias seguem subindo juntas, e a §3.3 não muda. O paper traz
  só o VAR tratado (lado a lado recusado pelo autor), e as duas tabelas do Anexo B viraram
  `tab:het_frequency`. ⚠ A linha sem tratamento se deslocou pela troca de caminho (p 0,988 /
  0,917 / 0,931 → 0,948 / 0,881 / 0,970), e o benchmark VAR segue sem escala. Nota:
  `2026-09-27_het_var_escala_covid`.

- [x] **Produção da branch promovida para `main` — 2026-09-26.** Fast-forward de
  `feature/bs-copom-surpresas-macro` (`63eea36..20a5f42`, 14 commits), a pedido do autor, antes
  de resolver o placebo EPU. Em `main`, `instrument.R` reproduz `instrument.csv` byte a byte e os
  sete validadores passam. Produção: `z_bs_purif`, conjuntos de 80/90%, ξ_mp 7,02 / 6,84, paper já
  migrado. ⚠ Quatro divulgações macro caem na própria quinta do Copom, contaminação contemporânea
  que nenhuma camada trata (`2026-09-25_bs_copom_surpresas_macro` §3.2). Notas:
  `2026-09-26_producao_bs_purif_bandas_80_90`, `2026-09-26_migracao_paper_bs_purif`.

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

## E. Código e higiene

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
