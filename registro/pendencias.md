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
| Inferência | **conjuntos Anderson-Rubin por inversão de teste** (MOSW 2021), NW(0), níveis 68/90, h = 0-48, desde 2026-09-08. O wild bootstrap Gonçalves-Kilian (nboot = 800, seed 123, Kilian só no DGP) segue computável como comparação, não como régua. ⚠ `hac_dim < T` barra `(8,8)` em `p=4` e a janela pré-COVID inteira |
| Força | ξ_mp/F_rob,mp = **6,057014/9,625428** full e **8,643436/13,809985** pré-COVID; raiz máxima 0,970090 full e 0,993359 pré-COVID; ambas estáveis |
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

O paper, as figuras e `output/irf/irf_section.md` ainda usam a vintage DFM
anterior. A sincronização editorial ficou explicitamente para uma rodada
posterior. Grades
históricas de painel, `(r,q)` e instrumento condicionadas a `p=6` permanecem
evidência datada e não foram reestimadas. O benchmark VAR em níveis continua
separado, em `p=2`, com seus conjuntos AR/MOSW próprios.

---

## Índice de itens abertos

| Tema | Item | Observação |
|---|---|---|
| B | Avaliar `r=q=8` como especificação principal (com (5,2)/(7,5)/(8,8) como robustez) | sugestão 4/5; ⚠ conflita com a especificação corrente (`r=5,q=5`, Bai-Ng BLL) — decisão do autor pendente; ⚠ e desde 2026-09-08 `(8,8)` em `p=4` **não tem bandas AR** (`hac_dim` 336 ≥ 162); ⚠ a poda de 2026-09-10 deu veredito contrário à hipótese de subestimação que o e-mail usava como amarração |
| B | Verificar se `(5,5,4)` cruza o limiar mínimo de Anderson-Rubin e comunicar ao orientador | passo 1/4 do e-mail de 13-09; ⚠ a produção já responde isso (ξ_mp = 6,057014 > 3,84, 5.635 células `interval`) — falta formalizar e decidir se fecha o item acima |
| B | Reportar a poda no paper como robustez que não confirmou Boivin-Ng, com a ressalva de perda de N | passo 2/4 do e-mail de 13-09; depende da rodada editorial do Tema A |
| B | Implementar a correção de outliers de 2020 (Lenza-Primiceri 2022) e reavaliar a sensibilidade a `q` na amostra completa | passo 3/4 do e-mail de 13-09; ⚠ cálculo feito em 2026-09-14 (célula `cheia_p4_lp` de `q_truncation.R`, branch `feature/volatilidade-covid-lp`, desligada na produção); falta a leitura do autor, a olho e sem regra pré-registrada; se o tratamento entrar no paper, destrava o apêndice de equações do Tema A |
| B | Refazer a tabela de sensibilidade `q=2,...,5` (`r=5`) nas duas janelas, uma vez estabilizada a especificação | passo 4/4 do e-mail de 13-09; ⚠ perna da cheia tratada feita em 2026-09-14 (`q_narrative_r5p4_covid.*`), a pré-COVID já existia; falta a leitura do autor e o passo 1/4 |
| B | Bootstrap e correção de Kilian sob o tratamento de volatilidade COVID | aberto em 2026-09-14, ao fechar a inferência AR sob o tratamento; seguem em `stop()`; não bloqueia nada, porque o AR é a inferência operacional |
| A | Sincronizar paper, figuras e `irf_section.md` com a janela 2012-03 **e** com a inferência AR | aberto em 2026-09-08; `fig_section5.R` e `fig_weak_iv.R` estão congelados atrás de `--repaint-paper-figures` até essa rodada |
| A | Escrever o apêndice com as equações de MOSW que mudam na extensão AR ao DFM | aberto em 2026-09-10; entra na mesma rodada editorial da linha acima |
| A | Escrever o apêndice com as equações que o tratamento de volatilidade COVID (Lenza-Primiceri) muda no DFM | aberto em 2026-09-14; só vale se o tratamento entrar no paper, o que depende da leitura do autor no passo 3/4 (Tema B); mesma rodada editorial das duas linhas acima |
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

- [ ] **Sincronizar paper, figuras e `output/irf/irf_section.md` com a produção
  corrente** — duas defasagens de uma vez: a janela (2012-03--2025-12, contra a
  2013-01--2025-09 que o texto descreve) e a **inferência** (conjuntos
  Anderson-Rubin, contra o wild bootstrap que o texto, as legendas e a §5
  anunciam). `sec:weak_iv` é o caso mais agudo: seu contraste inteiro era
  bootstrap-no-DFM contra AR-no-VAR, e os dois lados são AR agora. Enquanto a
  rodada não acontece, `script/fig_section5.R` e `script/fig_weak_iv.R` abortam
  sem `--repaint-paper-figures`, de propósito. Depende da rodada de 2026-09-08
  fechada no Tema B.
- [ ] **Abrir um apêndice com as equações de MOSW que mudam na extensão AR ao
  DFM.** A inferência sobre observáveis (`ar_dfm_bands()`) é uma substituição:
  o vetor canônico `e_i'` de MOSW dá lugar ao funcional linear estimado
  `c_j' = sy_j·Λ_j'` (e `c_mp'` na normalização). Ela toca a eq. (2.6), onde a
  resposta vira `λ(j,h) = c_j' C_h(A) Θ_{0,1}`; as eqs. (2.8)-(2.9), a
  normalização, com `λ(mp,0) = δ` constante em `Γ`; a eq. (4.1), a razão de que
  a estatística AR é construída; o gradiente de Kronecker, onde
  `G_DFM = c_j'·G_fatores` e portanto `Ω_DFM = c_j'[G W G']c_j` — quadrática
  nas loadings porque `H_T` é linear nelas; `Inner = K K'` quando `q < r`; e o
  mapa de `tcode` na saída. (4.2), (4.3) e `W` ficam inalterados. Entra na
  **mesma rodada editorial** do item acima.
- [ ] **Abrir no apêndice as equações que o tratamento de volatilidade COVID
  (Lenza-Primiceri 2022) muda no DFM.** O VAR dos fatores ganha a escala comum
  `s_t ε_t`, com a trajetória da eq. (1) de LP (θ = (s̄0, s̄1, s̄2, ρ),
  `t*` = 2020-03). O OLS dá lugar ao WLS (B2), que é o OLS da regressão
  transformada `ỹ_t = B'x̃_t + ε_t`, com `x̃_t = (1, lags_t)'/s_t`. K e M passam
  a ler a (B4), o segundo momento de `ε̃_t = u_t/s_t`; H = `Z'ε̃/Z'Z` e K saem
  sem centragem, o que só se afasta de AK (`IdentExtInstr.m`, `DFMest_BLL.m`)
  sob WLS. θ̂ vem da (B5), com o jacobiano `−n Σ_t log s_t` e o piso s̄ ≥ 1,
  ρ ∈ [0, 1], no lugar dos priors de LP (Pareto nos s̄, Beta em ρ). Na
  inferência de MOSW, a função de influência de Γ̂ troca X por X̃
  (`Q1 = X̃'X̃/T`, `Q2 = Z'X̃/T`), e o ξ_mp residualiza z em x̃ sem constante
  adicional. Ficam inalterados a extração estática (PCA e `sy`, e por isso o
  Bai-Ng), a forma da IRF, a normalização, `hac_dim` e `par_dim`; o texto tem
  de dizer que tudo condiciona em θ̂. Só vale se o tratamento entrar no paper,
  o que depende da leitura do autor no passo 3/4 (Tema B). Entra na **mesma
  rodada editorial** dos dois itens acima. Notas:
  `notas/2026-09-14_volatilidade_covid_lenza_primiceri.md` §2,
  `notas/2026-09-14_estimacao_theta_volatilidade_covid.md` §3 e §5 e
  `notas/2026-09-14_inferencia_volatilidade_covid_q.md` §2.1.

### Fechados (contexto)

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
e a 3/5, em 2026-09-10. As quatro estão fechadas abaixo, e só a 4/5 segue aberta. Os itens que estavam aqui antes da zeragem de
2026-09-08 (reavaliação do canal de prêmio de risco, purificação FOMC
intradiária, sensibilidade sem superquarta, placebo S&P 500, decomposição
diário-vs-mensal da curva, discriminação choque-vs-Λ, leave-one-out sobre a
IRF, tabela cross-instrumento do bloco-manchete, preditor fiscal em
Bauer-Swanson) não foram executados, testados nem decididos — apenas
removidos do registro. Recuperáveis no histórico do git.*

- [ ] **Avaliar `r=q=8` como especificação principal**, não por maximizar a
  força do instrumento mas porque é o valor de Alessi & Kerssenfischer
  (2019, nota de rodapé 4), o que permite comparação direta com o
  benchmark; reportar a tabela de sensibilidade `(5,2)`, `(7,5)`, `(8,8)`
  como confirmação de estabilidade de sinal (magnitude variando), não como
  processo de escolha da especificação; e reportar explicitamente que
  `(5,2)` fica abaixo do mínimo para as bandas Anderson-Rubin. Sugestão 4/5.
  ⚠ Conflita com a especificação corrente (`r=5, q=5`, Bai-Ng BLL) tabelada
  acima — não muda produção sem decisão do autor. Dependia da poda e da
  releitura de `(r,q)` para ter a leitura de divergência que o orientador pede
  como amarração. ⚠ **As duas fecharam em 2026-09-10 sem entregá-la:** no
  painel atual, AH/ABC dão veredito misto (ER = GR = 2, ABC-IC*₁ = 9
  instável); no podado, Bai-Ng cai de 5 para 3 e o veredito pré-registrado é
  *contrário* à subestimação. Amengual-Watson dá `q = 2` em `r = 8` (3 na
  convenção do MATLAB). Resta a justificativa por comparabilidade com AK.
  ⚠ **Desde 2026-09-10, `q = r` tem apoio próprio:** Stock-Watson (2016, §7.2)
  fixam `q = r` mesmo com Amengual-Watson indicando menos choques, e o
  truncamento `q < r` distorce na amostra cheia mas não na pré-COVID
  (`notas/2026-09-10_truncamento_q.md`).
  ⚠ **Restrição nova, medida em 2026-09-08:** a metade do pedido que
  trata de `(5,2)` foi entregue, mas `r=q=8` como principal é hoje incompatível
  com a inferência de produção — a covariância de MOSW exige `hac_dim < T` e em
  `(8,8)` com `p=4` dá 336 ≥ 162, sem pseudo-inversa nem fallback. Só cabe em
  `p=1` (144). Adotar `(8,8)` exige, junto, decidir a inferência daquela célula.

*Os quatro itens abaixo transcrevem, na ordem, os "próximos passos
coordenados" do e-mail do orientador de 2026-09-13
(`email/email_professor_13-09_10h45.md`), resposta às sugestões 1/5, 2/5 e
3/5 acima (fechadas em 2026-09-10).*

- [ ] **Verificar se a especificação `(5,5,4)` cruza o limiar mínimo de
  Anderson-Rubin e comunicar ao orientador**, com a citação de Stock-Watson
  (2016, §7.2) como justificativa pré-especificada de fixar `q = r` no teto
  viável. Passo 1/4. ⚠ A produção já responde a pergunta central: ξ_mp =
  6,057014 > 3,84, e as 5.635 células de produção saem `interval` a
  68/90/95% (`notas/2026-09-08_bandas_anderson_rubin_producao.md`). Falta
  formalizar essa resposta e decidir — **decisão do autor, não decidida
  aqui** — se isso fecha o item `r=q=8` acima em favor de `(5,5,4)` como
  especificação principal.
- [ ] **Reportar o exercício de poda no paper como robustez que não
  confirmou a hipótese de Boivin-Ng**, com a ressalva de que a queda do
  Bai-Ng para `r=3` pode refletir perda de potência por N menor, não
  confirmação do mecanismo. Passo 2/4. Depende da rodada editorial do
  Tema A (paper ainda não sincronizado).
- [ ] **Implementar a correção de outliers de 2020 na linha de
  Lenza-Primiceri (2022, *Journal of Applied Econometrics*, 37(4), 688-699)
  e reavaliar se a sensibilidade a `q` na amostra completa diminui.**
  Passo 3/4; artigo salvo em
  `artigos/Lenza - How to estimate a vector autoregression after March 2020/`.
  Testa se a divergência entre amostra completa (sensível a `q`) e pré-COVID
  (robusta, `notas/2026-09-10_truncamento_q.md`) é outlier de 2020, não
  fragilidade do método. ⚠ **Implementação, parametrização, inferência e
  cálculo feitos em 2026-09-14** (branch `feature/volatilidade-covid-lp`):
  escala `s_t` de LP no VAR dos fatores, θ̂ por máxima verossimilhança, e T1
  e T2 na célula `cheia_p4_lp` de `script/q_truncation.R`. O tratamento fica
  desligado na produção, cujo objeto sai `identical()` ao de `main`. **Falta
  a leitura do autor**, que decidiu ler as IRFs a olho, sem regra
  pré-registrada. Se o tratamento entrar no paper, destrava o apêndice de
  equações do Tema A. Notas:
  `notas/2026-09-14_volatilidade_covid_lenza_primiceri.md`,
  `notas/2026-09-14_estimacao_theta_volatilidade_covid.md` e
  `notas/2026-09-14_inferencia_volatilidade_covid_q.md`.
- [ ] **Refazer a tabela de sensibilidade `q = 2,...,5` (`r = 5` fixo) nas
  duas janelas — completa ajustada e pré-COVID — uma vez estabilizada a
  especificação principal.** Passo 4/4. ⚠ A perna da cheia ajustada foi
  calculada em 2026-09-14 (`script/q_narrative_overlay_covid.R`,
  `output/factors/q_narrative_r5p4_covid.*`); a pré-COVID já existia
  (`output/factors/q_narrative_r5p2_precovid.*`, em `p = 2`). Falta a
  leitura do autor e a especificação principal (passo 1/4). Nota:
  `notas/2026-09-14_inferencia_volatilidade_covid_q.md`.
- [ ] **Bootstrap e correção de Kilian sob o tratamento de volatilidade
  COVID.** Seguem em `stop()`: o DGP do wild bootstrap, a reestimação por
  réplica e a fórmula de Pope/Kilian supõem OLS com Σ constante. Surgiu ao
  fechar a inferência AR sob o tratamento (Fechados, abaixo). Não bloqueia
  nada, porque o AR é a inferência operacional. Nota:
  `notas/2026-09-14_inferencia_volatilidade_covid_q.md`.

### Fechados (contexto)

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

### Fechados (contexto)

- [x] **Resultado negativo da het incorporado ao paper — 2026-09-01.** §5
  reporta o teste de proporcionalidade no diário e no mensal corrente; nenhuma
  das 450 células válidas (115 séries) identifica. Código dedicado removido.
  Fonte: `arquivo/heterocedasticidade/README.md`.

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
