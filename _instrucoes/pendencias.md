# Pendências — antes do paper writeup

Consolidado a partir do council (`relatorio/council_2026-05-05.md`), blindspot reports (`relatorio/working-notes/`) e relatórios de referee interno (`relatorio/correspondence/referee2/`). Itens marcados com fonte para rastreabilidade.

---

## PIVÔ 2026-07-16 — identificação por heterocedasticidade como PRIMÁRIA

> Decisão do autor (2026-07-16): o instrumento externo (surpresas GK/JK) deixa de ser a identificação principal — o Copom anuncia ~18h30, após o fechamento, e a janela Wed→Thu de ~24h fragiliza a exclusion restriction do proxy (crítica RS-2004 ao event-study). A identificação passa a ser **integralmente por heterocedasticidade, fiel a Rigobon (2003)**, na branch `identificacao-heterocedasticidade`. Plano completo (leitura + arquitetura + confronto svars + sequência de código): **`_instrucoes/plano_reimplementacao_het.md`**. Notas de leitura: `artigos/{rigobon, Rigobon-Sack, Stock e Watson}/*_notes.md`.

- [x] **Fase de código do pivô — núcleo** — *concluída 2026-07-16 com REGRA DE PARADA acionada*
  Implementados e validados: `R/identification/het_primary.R` (MD rank-1 identity≡eigen + GMM ótimo com J, `ident_het_regimes`, força/placebo/Fieller, produto cruzado eq. 7), ramo `identification = "het"` em `compute_irf_dfm` (labels fixos no bootstrap, diagnósticos por draw, ramo proxy byte-idêntico — diff 0 vs RDS de produção) e em `main_sdfm`; harness `script/validate_het_primary_sim.R` 100% (cos 0.994, J size 4.5%/power 85.5%). **Gates (`script/het_primary_feasibility.R`, 16 células): NENHUMA elegível** — p_perm 0.26-0.86 (placebo de permutação), proporcionalidade nunca rejeitada ⇒ A1/rank condition inexistentes na frequência mensal. Produção INALTERADA (proxy `z_jk_bs_purif`). Relatório: `output/het_primary/feasibility_report.md`.
- [ ] **DECISÃO DO AUTOR pendente:** fallback B (sistema diário RS-2004 como identificação declarada — `z_het` sem filtro JK — + ponte proxy explícita no texto) vs manter o desenho proxy atual. O re-escopo de sweep/validação e a reescrita do §5/tex ficam condicionados a essa escolha.
- **Itens abaixo re-escopados pelo pivô** (redigidos sob o primário `z_jk_bs_purif`, que passa a braço de robustez): "Reescrever §5 sob `z_jk_bs_purif`", "Bandas Anderson-Rubin para o primário", "Benchmark GRG sem a célula het", "Promoção de `z_jk_raw_purif`". Reavaliar os quatro após a fase de código: o §5 será reescrito sob o novo primário het, as bandas AR viram bandas weak-ID het (Magnusson-Mavroeidis/Nakamura-Steinsson), e a comparação GRG muda de natureza (mesma família de identificação, frequências diferentes).

---

## CRÍTICO — blockers de identificação / inconsistências no código

> **Status (2026-07-11):** diagnóstico de sinais invertidos **fechado em definitivo** pela varredura sistemática de especificações (item abaixo). **Status (2026-05-08):** +1 item crítico resolvido na sessão 2026-05-08 (instrumento fraco no espaço dos fatores). DEFAULT_VARIANT trocado de `z_het_jk_3var` → `z_jk_purif`. Os 6 itens críticos originais foram resolvidos nos commits `4e2192f` (1-3) e `a3af0e4` (4-6).

- [x] **Varredura sistemática de especificações IRF (instrumento × mp_var × (r,q) × amostra)** — *concluída 2026-07-11*
  Grid de 320 células (`script/irf_spec_sweep.R`: 8 instrumentos × mp_var ∈ {yield_3m, 6m, 1y, 2y, juros_selic} × (r,q) ∈ {(5,4) auto-IC, (6,5), (7,6), (8,8)} × {full, pre_covid}), Etapa 1 ponto-estimativa com cache de 8 DFMs + Etapa 2 (`script/irf_spec_stage2.R`) bootstrap nboot=800 nas 6 células vencedoras. **Resultado central: zero células `sign_puzzle` e zero `unstable_normalization` — toda inversão de sinal no grid é F (factor-space) < 10.** Sempre que F ≥ 10, os sinais hard (curva ↑, IBOV ↓) e de transmissão (IPCA ↓, PIB ↓, varejo ↓ em h=24) saem coerentes, em qualquer combinação. Descobertas adicionais: (i) a família JK cruza Stock-Yogo em (6,5)/(7,6)/(8,8) no full — "z_jk_purif único" era artefato do grid antigo com r fixo em 7; (ii) **pre_covid (r=6,q=5) é o pico do grid** — 5 instrumentos ≥ 10, incluindo as variantes het (a fraqueza delas é COVID-driven, não estrutural); (iii) `z_het_3var` pre_covid (6,5) é a única célula com apreciação cambial + ordenação amortecida (canal GRG standard), sem significância; (iv) auto-IC (5,4) é borderline-weak (9.20) no full; (v) magnitudes esclarecidas — `cds_5y` em escala ×100 (h0 ≈ +41bp), `cambio_usd` em nível BRL/USD (+0.24 ≈ +5% full, significante). Validação: reproduziu 10.17 / 9.20 / 55-vs-2.7 e o ponto exato do RDS de produção (seed 123). Outputs: `output/irf/spec_sweep_{cells,irf_long}.csv`, `spec_sweep_{report,stage2,conclusoes}.md`, `irf_spec_<tag>.{rds,pdf}`, `irf_spec_stage2_overlay.pdf`. Relatório didático: `relatorio/working-notes/2026-07-11_varredura_irf.md`.
  *Fonte: solicitação do usuário 2026-07-11 (IRFs inconsistentes com a teoria); plano em `~/.claude/plans/contexto-as-irfs-impulse-concurrent-penguin.md`.*

- [x] **F (factor-space) ≪ F (y6m AR) — instrumento fraco onde o proxy-SVAR projeta** — *concluído 2026-05-08*
  Após o fix de unit scaling em `yield_6m` (item LEVE 2026-05-07) expor as IRFs reais (sem o fator amplificador de +5000bp), as IRFs com `z_het_jk_3var` apresentaram sinais teoricamente invertidos (PIB ↑, núcleo ↑, BRL deprecia, sinais opostos entre `juros_selic` e `yield_6m`) com bandas largas. Diagnóstico instrumentado em `R/modeling/impulse_responde.R::ident_ext_instr` (gated por `getOption("dfm.irf.diagnose")`) revelou: F (factor-space, max sobre os q fatores dinâmicos) = **2.74** para `z_het_jk_3var`, vs F (y6m AR) reportado = 55.98. Grid (q ∈ {2,3,4,6}) × (8 variantes) em `script/diagnose_factor_space_F.R` mostra que **`z_jk_purif` é a única variante que cruza Stock-Yogo F (factor-sp) ≥ 10** (= 10.17). DEFAULT_VARIANT alterado em `script/instrument.R:25`. Re-run de `model_alessi.R` produz IRFs com sinais coerentes em todos os blocos macro (curva sobe, ações caem, atividade cai, risco soberano widens). `script/instrument_diagnostics.R` agora reporta F (factor-sp) lado-a-lado com F (DFM) e F (y6m AR), com flag WEAK-FACT (< 10). Helper `R/identification/factor_space_diagnostics.R::diagnose_instrument_in_factor_space`. **Lição:** F (y6m AR) mede relevância univariada Selic-equivalente, F (DFM) mede relevância contra o resíduo do *primeiro* fator do VAR; ambos podem ser altos mesmo quando F (factor-space) — o relevante para a projeção `H = (Z'η)/(Z'Z)` no espaço dos q fatores dinâmicos — é fraco.
  *Fonte: investigação 2026-05-08 a partir de relato de IRFs invertidas pelo usuário; plano em `~/.claude/plans/minhas-irfs-nao-estao-jiggly-umbrella.md`.*


- [x] **Corrigir mismatch `script/model_alessi.R:35`** — *concluído 2026-05-05*
  IRFs estavam sendo normalizados por `juros_selic` (F≈1.1), agora `mp_var = "yield_6m"` (F=21.3) tanto no default da função quanto na chamada (linhas 35, 117). Resultados empíricos voltam à escala correta.
  *Fonte: Methodologist (council Required 2), Round 1 major concern.*

- [x] **Variance ratio de DI_2y por regime com CI bootstrap 99%** — *concluído 2026-05-05*
  `script/instrument_het.R` agora classifica A2 por variável via `classify_a2_verdict` (coluna `a2_status` ∈ {`policy`, `pass`, `violated`}, com `a2_side` indicando o lado da violação) e emite warning explícito para cada não-policy var violada. Como robustez, é construído também um SVAR 3-var (DI_3m, IBOV, BRL) — gerado lado a lado pela mesma `build_het_instrument`, persistido em `instrument_z_het{,_jk}_3var.csv`, `het_variance_validation_3var.csv`, `het_b_1_3var.csv`. `instrument_diagnostics.R` exibe ambos os blocos lado a lado (§4.1) e compara o `b_1` 4-var × 3-var (§4.3).
  *Fonte: Harsh Referee + Methodologist (council Required 1), Round 1 (λ_2 anotado como minor, sem CI formal).*

- [x] **Reportar dois Fs distintos: AR-innovation vs DFM-factor** — *concluído 2026-05-05*
  `script/instrument_diagnostics.R` reporta lado a lado **F (DFM)** (resíduo do primeiro fator do VAR; governa viés de instrumento fraco na proxy-SVAR de Alessi-Kerssenfischer) e **F (y6m AR)** (inovação AR(6) de `yield_6m`; relevância para a interpretação Selic-equivalente). A tabela traz `n (DFM)` e `n (y6m)` para tornar explícita a diferença de tamanho amostral, e o relatório explica quando os dois discordam (e.g. `z_het` com F(DFM)≈1.5 vs F(y6m AR)≈7.6).
  *Fonte: Methodologist (council Required 2), Round 1 major concern.*

- [x] **Endereçar inconsistência lógica: JK triplicando F sobre choque já extraído por het-ID** — *concluído 2026-05-05*
  Adotada a opção (a): framing híbrido het+timing documentado em `_instrucoes/Heteroscedasticidade.md` (seção "Framing: instrumento híbrido het+timing"), com a exclusion restriction mensal `E[z_het_jk_m · η_t^j] = 0` derivada explicitamente (Stock-Watson 2018 §4.7). O instrumento é caracterizado como três camadas: het-extracted no diário, timing-restricted (Copom days), sign-restricted (JK). A condição operativa é a exclusion mensal — mais fraca que A1-A3 conjuntas e compartilhada com proxy-SVARs Gertler-Karadi.
  *Fonte: Macro Theorist (council Required 3) — não coberto por relatórios internos.*

- [x] **Rodar anti-JK mask** — *concluído 2026-05-05*
  T5 implementado em `R/identification/validation_tests.R::anti_jk_test()` e wired em `script/instrument_validation.R`. **Resultado:** F(anti-JK) = **0.194** (55 dias sign-equal "informacionais") vs JK F = 21.29 (42 dias sign-opposite "monetários") vs random-mask mean = 5.73 (qualquer 42 dias). O complemento sign-equal carrega ~0 sinal — evidência direta de que o filtro JK não é só esparsificação. Persistido em `output/het_validation_anti_jk.csv` e seção "T5" do relatório.
  *Fonte: Blindspot 04-26 action item 3, council Required 3.*

- [x] **Rodar curva F(k_keep) para k ∈ {20, 42, 60, 80}** — *concluído 2026-05-05*
  T6 implementado em `R/identification/validation_tests.R::random_mask_curve()` + `random_mask_curve_summary()` e wired em `script/instrument_validation.R`. **Resultado:** mean F roughly flat across k (5.5-6.9), q99 declining (32 → 21 → 19 → 17), p(F_random ≥ JK) = {0.034, 0.0095, 0.006, 0.000} para k = {20, 42, 60, 80}. JK F = 21.29 está exatamente em q99 do k=42; em k=80 nenhum random draw alcança o JK F. Persistido em `output/het_validation_f_curve{,_summary}.csv` e `output/het_validation_f_curve.png`; seção "T6" do relatório.
  *Fonte: Blindspot 04-26 action item 4, council Required 3.*

---

## MÉDIO — robustez importante, deve entrar no paper

> **Status (2026-07-15):** default trocado para `z_jk_bs_purif` e cadeia de estimação re-rodada (sweep 480 células, stage 2, `model_alessi.R`, coerência); decisão editorial de manter o het fora do paper. Abriu **3 itens novos** (abaixo). **Status (2026-07-11):** varredura de especificações abriu 3 itens. **Status (2026-05-06):** os 7 itens MÉDIO originais fechados. Os 6 itens menores (1-6) na sessão da manhã (commits `0cdc7e7`, `78452b9`, `78a9c0e`); o Item 7 (IRF + benchmark GRG) na sessão da tarde.

- [ ] **Reescrever §5 (`output/irf/irf_section.md`) sob o novo primário `z_jk_bs_purif`** *(novo 2026-07-15, troca de default)*
  A cadeia foi re-estimada mas o texto do §5 e as leituras interpretativas de 2026-07-12 (price puzzle, crédito/ativos, dentadas) descrevem a rodada `z_jk_purif`. História qualitativa igual, magnitudes ~30–45% menores (Ibov h0 −1.1% vs −8.9%; BRL +0.185 vs +0.245; EMBI +25bp vs +46bp; CDS +34bp vs +56bp em escala ×100). Vereditos da coerência que mudaram: crédito PJ e juros_cdi/selic melhoram (juros com share 100%), pib e desemprego caem para parcial, asset_idiv vira incoerente. Releitura ponto-a-ponto + re-append da seção manual do `irf_coherence_report.md` (nota de datação já inserida).
  *Fonte: re-estimação 2026-07-15; comparação old×new no scratchpad da sessão.*

- [ ] **Bandas Anderson-Rubin para o primário na amostra completa** *(novo 2026-07-15; herda o escopo do item AR de 2026-07-14)*
  `z_jk_bs_purif` (6,5) full: ξ_mp = 6.94 < 10 (AR limitado, > 3.84) — bandas AR obrigatórias para os resultados full-sample; pre-COVID (6,5) dispensa (12.49). Protocolo anti-screening de MOSW (footnote 6): reportar ξ e usar AR, não filtrar pelo F.
  *Fonte: grid MOSW; `output/instrument/mosw_strength_grid.md`.*

- [ ] **Benchmark GRG (2025) sem a célula het** *(novo 2026-07-15, het fora do paper)*
  A reconciliação do sinal do câmbio usava a célula `z_het_3var` × pre-COVID × (6,5), que saiu do paper. Decidir como discutir o desacordo com GRG (frequência diária vs mensal GE, janela amostral, regime de dominância fiscal 2020-25) sem essa célula.
  *Fonte: decisão editorial 2026-07-15; `relatorio/estrutura_paper_v2.md` §5.3 e pendência 6.6.*

- [x] **Aplicar (r,q) = (6,5) como override explícito em `script/model_alessi.R`** — *concluído 2026-07-11 (mesma sessão, após relato do usuário de câmbio ↑ / IPCA em corcova / núcleo ↑ no auto-IC)*
  Override `r = 6L, q = 5L` na chamada `main_sdfm()` com comentário citando a varredura; auto-IC mantido como referência impressa; `ggsave` novo para `output/irf/irf_model_alessi_r6q5.pdf`. **Re-run confirma a previsão da varredura:** pib agora negativo em todo o horizonte (antes: +0.42 em h24 no auto-IC (5,4)); corcova do IPCA encolhe e vira desinflação em h12-h30; curva e varejo com sinais corretos e CI apertados; câmbio +0.3 BRL no impacto revertendo (dominância fiscal, não defeito). **Núcleo ex0 permanece positivo (~+0.05-0.10, bandas contêm 0) em (5,4), (6,5) e (7,6)** — diagnóstico barato via `compute_irf_dfm(nboot=0)` mostrou que NÃO é artefato do grid: é a limitação conhecida do canal de desinflação do `z_jk_purif` (irf_section.md); os núcleos ex1 e dw viram negativos em h12-h24 nos grids fortes.
  *Fonte: varredura 2026-07-11, `output/irf/spec_sweep_conclusoes.md` §4; fecha o item aberto do HANDOFF 2026-05-08.*

- [x] **Adicionar robustez pre_covid (6,5) cross-instrumento ao §5** — *concluído 2026-07-12 (rewrite completo do §5)*
  Na janela 2013-2019 com (r=6, q=5), cinco instrumentos cruzam Stock-Yogo (z_jk_purif 15.4, z_jk 15.2, z_het_jk_3var 11.1, z_het_3var 10.8, z_bruto_purif 10.4) com sinais hard e de transmissão coerentes — dois esquemas de identificação independentes concordando. Incorporado como §5.6.1 do novo `output/irf/irf_section.md` (rewrite 2026-07-12: z_jk_purif primário × (6,5), ex1 como preço primário, price puzzle decomposto, crédito BG95, spreads duas fases, curva como prêmio fiscal, reconciliação GRG via z_het_3var pre_covid).
  *Fonte: varredura 2026-07-11.*

- [ ] **Decidir promoção de `z_jk_raw_purif` a robustez full-sample no paper** *(novo 2026-07-14, ordem purificação ↔ JK)*
  A variante com máscara JK nos sinais brutos (ordem "JK → purificação"; `script/instrument.R`) supera `z_jk_purif` em ξ_mp em **13/14 células full** do grid MOSW (única GK ≥ 10 em células full: (7,7) e todo r=8; em (6,5) full é o mais forte dos 10 instrumentos, 6.61) — a máscara bruta exclui 2020-03-19 (pânico COVID que a máscara residual classifica como monetário). No pre_covid (6,5) fica ≥ 10 mas abaixo do default (10.80 vs 13.25) — default inalterado. Falta: rodar `irf_spec_sweep.R` Etapa 1 com a variante para checar coerência de sinais nas células fortes antes de citá-la no texto; `z_jk_raw_purif_local` já foi descartada (dominada em 26/28 células). Detalhes: `relatorio/working-notes/2026-07-14_ordem_purificacao_jk.md`.
  *(2026-07-15)* A Etapa 1 foi rodada com as 4 variantes da auditoria (grid de 480 células, zero `sign_puzzle`); o default mudou para `z_jk_bs_purif`, que carrega máscara predeterminada equivalente. Resta só a decisão editorial de citar `z_jk_raw_purif`/`z_jk_raw` como robustez de máscara no §5.6.
  *Fonte: pedido do usuário 2026-07-14; grid MOSW 280 células.*

- [ ] **Investigar compressão dos spreads ICC pós-choque (sinal oposto ao prior)** *(novo 2026-07-11, coerência h)*
  `spread_icc_juridica` cai com CI90 em h0-h6 (share correto = 0%) e `spread_icc_fisica` idem (23%) — oposto ao prior financial-accelerator (+). Hipótese: ICC é taxa média da *carteira*; captação reprecifica mais rápido que a carteira na alta da Selic → compressão mecânica de curto prazo. Reavaliar o prior ou trocar a medida (spread de concessões novas) antes de tratar como falha. Ver `output/irf/irf_coherence_report.md` §Leitura.
  *(2026-07-12)* **Substancialmente resolvido pela análise h-a-h completa** (`relatorio/working-notes/2026-07-12_irf_credito_ativos_financeiros.md`): os spreads têm resposta em DUAS fases — compressão significativa h0-h7 (reprecificação carteira-vs-captação, mecânica) seguida de **abertura com CI68 em h19-h30** (juridica pico +0.08 em h25; fisica +0.13 em h25) — o financial accelerator (BG95, GZ12, GK15) aparece com defasagem. O prior não estava errado; a janela h0-12 da régua estava. Resta (não-bloqueante): testar spread de concessões novas, que deve abrir já no curto prazo.
  *Fonte: checagem de coerência ponto a ponto 2026-07-11; análise crédito/ativos 2026-07-12.*

- [ ] **`commodity_metal` responde ao choque (placebo externa violada)** *(novo 2026-07-11, coerência h)*
  contain0 = 0.64 (regra: ≥ 0.90); +14 a +19 pts com CI90 excluindo zero em h0-h8. Metais não entram na purificação Bauer-Swanson (SP500/VIX/Brent). Testar purificação incluindo índice de metais; se persistir, documentar como caveat de exogeneidade. Demais placebos (sp500_vix, msci, epu_us) ok.
  *(2026-07-15)* Persiste na rodada com `z_jk_bs_purif` (único `placebo_viola` da coerência). A ortogonalização pré-evento usa Brent mas não metais; testar preditor de metais 65d ou documentar como caveat.
  *Fonte: checagem de coerência ponto a ponto 2026-07-11; re-rodada 2026-07-15.*

- [x] **Núcleo do paper: preferir ex1 (ou reportar ex0/ex1/dw com leitura)** — *concluído 2026-07-12 (§5.5 do rewrite adota ex1 como medida primária, difusão como corroboração, ex0/dw com leitura)*
  ex1 é coerente_forte (share 84%, desinflação significativa de h≈15); ex0 (0%) e dw (49%) concentram a limitação de desinflação do z_jk_purif.
  *(2026-07-12)* Diagnóstico do headline **fechado** (`relatorio/working-notes/2026-07-12_price_puzzle_ipca.md`): a corcova positiva do IPCA (h0-h12) é n.s. (CI90 sempre contém 0; CI68 só h4-h8), universal entre os 8 instrumentos em (6,5) full, e desaparece pre-COVID com a mesma identificação (IPCA < 0 em todo h; F = 15.4 > full 10.1) → price puzzle amostral (COVID 2021-22), **não** erro de identificação. Framing §5: headline com corcova n.s. + robustez pre-COVID; ex1 primária.
  *Fonte: checagem de coerência ponto a ponto 2026-07-11.*

- [x] **Mencionar `z_het_3var` pre_covid como robustez qualitativa do canal de apreciação** — *concluído 2026-07-12 (§5.3 e §5.6.2 do rewrite: célula usada como reconciliação com GRG 2025 — o desacordo de sinal do câmbio é regime-driven, não method-driven; condicionada a bandas Anderson-Rubin se promovida além de robustez qualitativa)*
  Única célula do grid com apreciação cambial + desinflação + ordenação amortecida da curva (canal GRG 2025 standard); ponto coerente mas CI90 largos (F = 10.8 borderline). Nuance importante: a leitura de dominância fiscal (44/48 células elegíveis) não é universal.
  *Fonte: varredura 2026-07-11, `spec_sweep_conclusoes.md` §3.*

- [x] **Corrigir framing de T2 nos documentos públicos** — *concluído 2026-05-06*
  `output/het_validation_report.md` (seção T2) reescrito com leitura honesta: "The JK F sits *at* the 99th percentile of equal-size random masks ... the gap is one percentile". Inclui binomial SE 0.0023 e 95% CI [0.006, 0.015]. `_instrucoes/Heteroscedasticidade.md` já tinha framing honesto desde 2026-05-05 (verificado).
  *Fonte: Blindspot 04-26 action item 1.*

- [x] **Rodar placebo + random-mask para z_het puro (sem JK) como benchmark pareado** — *concluído 2026-05-06*
  T2b implementado em `script/instrument_validation.R` chamando `placebo_test()` paralelo em `mensais$z_het`. **Resultado:** F obs (z_het) = 7.61 vs F obs (z_het_jk) = 21.29; placebo p-value 0.008 vs 0.0005; nenhum dos dois rejeita por data-snooping, mas as Fs observadas diferem por ~3×, isolando a contribuição informativa do filtro JK no nível diário. Random-mask para z_het puro é degenerado (k=k_total=97), documentado no relatório. Outputs: `het_validation_placebo_zhet.{csv,png}`. Seção T2b do report.
  *Fonte: Blindspot 04-26 action item 2.*

- [x] **Sensibilidade AR-order: p ∈ {3, 12}** — *concluído 2026-05-06*
  T7 implementado em `script/instrument_validation.R`: loop sobre p ∈ {3, 6, 12} chamando `residualize_target(target_series, n_lags=p)` e `subperiod_F`. **Resultado:** F (full) = 20.7 / 21.3 / 22.4 para p={3,6,12}; F (pre_covid) = 13.1 / 38.1 / 33.4; F (covid_post) = 17.8 / 11.2 / 11.2. F observado é estável em ±10% para AR≥6. AR(3) sub-estima por sub-residualização (38→13 no pre_covid). Output: `het_validation_ar_sensitivity.csv`. Seção T7 do report.
  *Fonte: Round 2 minor concern, Blindspot 04-26 action item 2.*

- [x] **Testar A3 (B_d constante): het-ID separado em 2013-19 vs 2020-25** — *concluído 2026-05-06*
  Wrapper `run_het_window()` adicionado a `script/instrument_het.R` filtra `regime_tbl` + `changes_3var` por janela diária e chama `build_het_instrument` + `validate_variance_split`. **Resultado:** cosine(b_1_pre, b_1_post) = 1.000; norm_ratio = 0.687; rank-1 share 0.987 (pre) / 0.975 (post). **Veredito: "A3 sustained"** — direção do impact column é estável; magnitude no `b_1[DI_3m]` cai 31% (9.79 → 6.72), consistente com a leitura de "regime change na função de reação BCB pós-2020 mas sem violação estrutural". Outputs: `het_a3_b_1_pre_vs_post.csv`, `het_a3_summary.csv`, `het_b_1_{pre_covid,covid_post}.csv`, `het_eigenvalues_*.csv`, `het_variance_validation_*.csv`.
  *Fonte: Macro Theorist (council), Blindspot 04-26 virtue 1.*

- [x] **Andrews (1993) QLR supF na equação de primeiro estágio** — *concluído 2026-05-06*
  Função `qlr_supF()` adicionada a `R/identification/validation_tests.R`: para cada τ ∈ [0.15·n, 0.85·n], regressão `innov ~ z + D_τ + z·D_τ` com Wald HC0 sobre o termo de interação (m=1, k=1 restriction). **Resultado:** sup F = 6.88 em τ* = 2015-08-01 (NÃO 2020 como esperado pelo sub-period drop). Critical values Andrews (1993) Tab. 1, m=1, π_0=0.15: cv5=8.85, cv1=12.16. **Veredito: "fail to reject"** — não há evidência formal de quebra estrutural no slope do first-stage, contra a conjectura inicial de regime change pós-COVID. O drop F no sub-period (38.1 → 11.2) é melhor explicado por aumento de var(innov) pós-COVID (T4 var-by-window: 8.6e-6 → 3.1e-5 = 3.6× maior), não por mudança de β. Output: `het_validation_qlr.csv`, `het_validation_qlr_curve.csv`. Seção T8 do report.
  *Fonte: Methodologist (council optional 1).*

- [x] **cor(z_het_jk, z_jk_purif) e var(innov) por sub-período** — *concluído 2026-05-06*
  Extensão T4 em `script/instrument_validation.R`: `monthly_correlation()` rodado em 3 janelas (full / pre_covid / covid_post) + `var(innov)` por janela. **Resultado:** cor (both_nonzero) = 0.95 (pre, n=12) / 0.93 (post, n=24) / 0.93 (full, n=36) — convergência het-ID × timing-ID estável; o cor=0.93 do full **não mascara** divergência. var(innov) cresce ~3.6× pós-COVID (8.6e-6 → 3.1e-5), explicando mecanicamente o sub-period F drop sem precisar invocar regime change. Outputs: `het_validation_correlation_by_window.csv`, `het_validation_var_innov_by_window.csv`. Sub-tabelas T4 do report.
  *Fonte: Blindspot 04-26 action item 5.*

- [x] **Seção IRF completa + benchmark GRG (2025)** — *concluído 2026-05-06 (sessão tarde)*
  IRFs cross-instrument (`z_het_jk_3var` vs `z_jk_purif`) com bandas 68/90 e nboot=800 implementadas em `script/irf_cross_instrument.R`; benchmark numérico per-50bp contra GRG Tabs 4 e 5 em `script/build_grg_benchmark.R`. **Decisão do usuário: drop Minella (2003) — só GRG.**
  Outputs: `output/irf_zhetjk3var.pdf`, `output/irf_zjkpurif.pdf`, `output/irf_comparison.pdf`, `output/irf_results_{zhetjk3var,zjkpurif}.rds`, `output/grg_benchmark.csv`, `output/irf_section.md` (§5 standalone do paper).
  **Findings principais:** (i) `z_het_jk_3var` recupera o canal de desinflação de GRG (Δipca = -0.10 pp ≈ GRG -0.13 pp); `z_jk_purif` falha (Δipca ≈ 0). (ii) Ambos os instrumentos mostram BRL depreciation e CDS widening na contração (sinal oposto a GRG no diário) — interpretado como sinal de fiscal-dominance no horizonte mensal. (iii) Term-structure tight (todas maturidades sobem com bandas claras). (iv) Phase 2 (VAR overlay) deferida — `model_var.R` hard-coda `juros_selic`, fora-de-amostra Stock-Yogo com `z_het_jk`.
  *Fonte: Harsh Referee (council optional 3).*

---

## LEVE — qualidade de código e documentação, opcional

- [x] **Teste formal de rank para ΔΣ** — *concluído 2026-05-07*
  Implementado em `R/identification/het_shock_extraction.R`: (i) `rigobon_proportionality_test()` testa H₀: Σ_C = a Σ_NC (Rigobon 2003 Proposição 1) via Mauchly LR + wild-bootstrap-calibrado (n_boot=1000); (ii) `rank1_lr_test()` testa H₀: rank(ΔΣ)=1 (Lanne-Lütkepohl 2008 Wilks LR `(n/2) Σ (logλ + 1/λ − 1)`, λ = generalized eigenvalues de (Σ_C, Σ_NC)) com bootstrap sob H₀ rank-1; (iii) `bootstrap_rank1_share_ci()` produz CI 95% sobre rank-1 share. **Resultado:** Rigobon Prop 1 rejeita proporcionalidade fortemente em todos os blocos (p_boot ≤ 0.011) — gate de identificação satisfeito. L-L rank-1: 4-var p_boot=0.137, 3-var p_boot=0.298, pre_covid p_boot=0.174, covid_post p_boot=0.287 — todos fail-to-reject rank-1 sob a estatística canônica, refletindo limitação de poder com n_C ≈ 50. Bootstrap rank-1 share 95% CI: 4-var [0.666, 0.930], 3-var [0.948, 0.995] — o 3-var fica muito mais próximo de 1, descritor que continua discriminando os dois blocos. Hansen J indisponível em R=2 (Rigobon 2003 Prop 2: df=0). Outputs: `output/instrument/het_rank_test{,_3var,_pre_covid,_covid_post}.csv` + diagnostics report §4.2.
  *Fonte: Methodologist (council), Blindspot 04-25.*


- [x] **Identificar v_2 (segundo autovetor de ΔΣ) explicitamente** — *concluído 2026-05-07*
  `extract_shock_rigobon_sack` agora retorna `b_2`, `v_2`, `shocks2_C` (projeção GLS Mertens-Ravn paralela a ε̂_1). Persistido em `output/instrument/het_b_2{,_3var}.csv` e `data/processed/instrument_z_het2{,_3var}.csv`. Diagnostics §4.4. **Resultado:** 4-var b_2 carrega DI_3m=+5.85, DI_2y=−2.62, IBOV=−0.14, BRL=−0.17 — perfil "tilt" (curto sobe, longo cai), consistente com choque de forward guidance / belly-of-curve quando A2 falha em DI_2y; 3-var b_2 é ruído (rank-1 share=0.987 ⇒ λ_2≈0). Documentado como descritor — não usado como segundo instrumento sob A1-A3.
  *Fonte: Blindspot 04-25 virtue 1.*

- [ ] **Guard sign-flip em `R/identification/het_shock_extraction.R:208`**
  Se `b_1[mp_var_idx] == 0`, o sinal é indefinido. Adicionar guard ou documentar precondição.
  *Fonte: Round 1 minor concern.*

- [ ] **`irf_mp_raw` em `R/modeling/impulse_responde.R::ident_ext_instr` retorna IRF normalizado** (gemini review 2026-05-08, P1 #3)
  O retorno `irf_mp_raw = irf_mp` ocorre **após** `irf_mp <- irf_mp / irf_mp[mpind, 1] * normalize_value`, então `irf_mp_raw` é normalized-pre-tcode, não truly-raw. Renomear para `irf_mp_pre_tcode` ou adicionar um campo `irf_mp_pre_norm` separado. Não altera nenhum output de produção (só o nome no list de retorno).
  *Fonte: gemini-review 2026-05-08 sobre `impulse_responde.R`.*

- [ ] **Alinhar NA handling entre `validate_variance_split` e `extract_shock_rigobon_sack`**
  `validate_variance_split` usa filtragem por coluna (n_C=104); `extract_shock_rigobon_sack` usa complete.cases (n_C=97). Documentar assimetria ou alinhar os dois.
  *Fonte: Round 1 minor concern.*

- [ ] **Script mestre `script/run_all.R`**
  Orquestra o pipeline end-to-end: `download.R → clean.R → instrument*.R → validation.R → model_*.R`.
  *Fonte: Round 2 recommendation.*

- [ ] **Documentar MAX_GAP_DAYS rationale em `script/instrument_het.R`**
  Atualmente explicado apenas no docstring interno de `build_daily_regimes`. Adicionar comentário no nível do script.
  *Fonte: Round 1 trivial.*

- [x] **Corrigir convenção de unit scaling em `yield_6m`** — *concluído 2026-05-07*
  `normalize_value = SHOCK_BPS / 10000 = 0.005` em `script/model_alessi.R:69-72` e `script/irf_cross_instrument.R::run_spec` (a IRF h=0 de `yield_6m` agora é +0.005 em proporção = +50bp, não +5000bp). `script/build_grg_benchmark.R::scale_to_grg_units` foi simplificado: a divisão por 100 sumiu — `raw_value` já está per-+50bp. Apenas `cambio_usd` segue convertido para `%` via `raw_value / brl_usd_baseline * 100`. O default `normalize_value = 0.5` em `R/modeling/impulse_responde.R::ident_ext_instr` foi mantido (compat com `script/model_var.R` que hard-coda `juros_selic` em escala percentual); docstring documenta a convenção. **Audit reports anteriores ficam fora-de-escala em 100× nas magnitudes; sinais e formas inalterados.** Após regenerar `output/irf/irf_*.pdf` e `output/benchmark/grg_benchmark.csv`, conferir: `our_point_50bp` numericamente idêntico ao anterior (porque `raw_old / 100 = raw_new`); IRF h=0 de yield_6m agora exibido como +0.005 (não +0.5).
  *Fonte: Gemini review P1 #1 de `script/irf_cross_instrument.R` (sessão 2026-05-06 tarde).*

- [x] **Adicionar break-even inflation (ANBIMA NTNB-LTN) ao painel mensal** — *infraestrutura concluída 2026-05-07; download diferido*
  Função `download_breakeven_curve()` + helper `fetch_anbima_reference_rates()` em `R/data_download/anbima_breakeven.R` usam `rb3::yc_brl_get` / `rb3::yc_ipca_get` (cache em `~/rb3-cache`), interpolam para 252/504/1260 du via spline cúbica (mesmo protocolo Svensson) e retornam `breakeven_{1y,2y,5y}` mensal. Wired em `script/download.R` (linha após `monthly_yield_curve`); retorna tibble vazio com warning quando o cache rb3 não está populado, sem quebrar o pipeline. `script/build_grg_benchmark.R::mapping` foi reescrito para auto-detectar `breakeven_*` no painel: usa break-even quando presente (DIRECT, sem caveat) e cai em `price_ipca` com nota PROXY caso contrário. **Pendente:** popular o cache rb3 chamando `fetch_anbima_reference_rates(from='2010-01-01', to='2026-12-31')` antes de rodar `download.R` (a depuração da fetch_marketdata da B3 ficou para o usuário).
  *Fonte: HANDOFF.md sessão 2026-05-06 tarde (Next Steps item 3); GRG 2025 Tab 4 benchmark.*
