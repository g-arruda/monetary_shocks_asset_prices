# Pendências — antes do paper writeup

Consolidado a partir do council (`relatorio/council_2026-05-05.md`), blindspot reports (`relatorio/working-notes/`) e relatórios de referee interno (`relatorio/correspondence/referee2/`). Itens marcados com fonte para rastreabilidade.

---

## CRÍTICO — blockers de identificação / inconsistências no código

> **Status (2026-05-05): seção fechada.** Os 6 itens críticos foram resolvidos nos commits `4e2192f` (1-3) e `a3af0e4` (4-6 + DEFAULT_VARIANT). Próximo bloco lógico é a seção MÉDIO antes do paper writeup.


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

> **Status (2026-05-06):** 6 dos 7 itens fechados na sessão de hoje (commits a serem criados após este update). O item IRF + benchmark literatura brasileira fica pendente para sessão dedicada.

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

- [ ] **Seção IRF completa + benchmark literatura brasileira**
  IRFs com 68/90% para z_het_jk e z_jk_purif; comparar com Minella (2003) e GRG (2025). Necessário para o paper ser uma contribuição empírica, não só metodológica. **Fora de escopo da sessão 2026-05-06; sessão dedicada.**
  *Fonte: Harsh Referee (council optional 3).*

---

## LEVE — qualidade de código e documentação, opcional

- [ ] **Teste formal de rank para ΔΣ**
  Substituir o gate informal `rank1_share > 0.6` por Cragg-Donald (1997) LR rank test ou Rigobon (2003) GMM distance statistic.
  Arquivo: `R/identification/het_shock_extraction.R`.
  *Fonte: Methodologist (council), Blindspot 04-25.*

- [ ] **Bootstrap propagando incerteza de b_1 (Piffer-Podstawski 2018, JEEA)**
  Nested bootstrap: re-amostrar pares Wed→Thu dentro de C e NC, re-extrair b_1, re-computar z_het, e então rodar o wild bootstrap mensal da DFM. As bandas atuais subestimam incerteza.
  *Fonte: Round 1 minor concern, Methodologist (council optional 2).*

- [ ] **Identificar v_2 (segundo autovetor de ΔΣ) explicitamente**
  λ_2=41.1 não é ruído — provavelmente choque de forward guidance/curva média. Reportar loadings de v_2; potencial segundo instrumento z_het².
  *Fonte: Blindspot 04-25 virtue 1.*

- [ ] **Guard sign-flip em `R/identification/het_shock_extraction.R:208`**
  Se `b_1[mp_var_idx] == 0`, o sinal é indefinido. Adicionar guard ou documentar precondição.
  *Fonte: Round 1 minor concern.*

- [ ] **Alinhar NA handling entre `validate_variance_split` e `extract_shock_rigobon_sack`**
  `validate_variance_split` usa filtragem por coluna (n_C=104); `extract_shock_rigobon_sack` usa complete.cases (n_C=97). Documentar assimetria ou alinhar os dois.
  *Fonte: Round 1 minor concern.*

- [ ] **Script mestre `script/run_all.R`**
  Orquestra o pipeline end-to-end: `download.R → clean.R → instrument*.R → validation.R → model_*.R`.
  *Fonte: Round 2 recommendation.*

- [ ] **Documentar MAX_GAP_DAYS rationale em `script/instrument_het.R`**
  Atualmente explicado apenas no docstring interno de `build_daily_regimes`. Adicionar comentário no nível do script.
  *Fonte: Round 1 trivial.*
