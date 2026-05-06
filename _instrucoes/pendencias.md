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

- [ ] **Corrigir framing de T2 nos documentos públicos**
  `output/het_validation_report.md` e `_instrucoes/Heteroscedasticidade.md` usam framing otimista ("genuinely informative, p≈0.01"). F_obs=21.29 está AT q99=21.5, não acima.
  Texto correto: *"JK F sits at the 99th percentile of equal-size random masks — informative, but the gap is one percentile."*
  *Fonte: Blindspot 04-26 action item 1.*

- [ ] **Rodar placebo + random-mask para z_het puro (sem JK) como benchmark pareado**
  Permite comparar as distribuições nulas de z_het e z_het_jk side-by-side.
  *Fonte: Blindspot 04-26 action item 2.*

- [ ] **Sensibilidade AR-order: p ∈ {3, 12}**
  AR(6) é hard-coded em `residualize_target`. Tabela auxiliar com F observado e p-placebo para p ∈ {3, 6, 12}.
  *Fonte: Round 2 minor concern, Blindspot 04-26 action item 2.*

- [ ] **Testar A3 (B_d constante): het-ID separado em 2013-19 vs 2020-25**
  Sub-period F cai de 38.1 para 11.2 — possível quebra de regime de comunicação do BCB pós-2020 (forward guidance, RI expandido).
  Ação: estimar het-ID por sub-período, comparar b_1 vectors; discutir estruturalmente se é contaminação ou regime change.
  *Fonte: Macro Theorist (council), Blindspot 04-26 virtue 1.*

- [ ] **Andrews (1993) QLR supF na equação de primeiro estágio**
  Teste formal de quebra estrutural no first-stage. Formaliza o que hoje é apenas observação de sub-period F.
  *Fonte: Methodologist (council optional 1).*

- [ ] **cor(z_het_jk, z_jk_purif) e var(innov) por sub-período**
  A cor=0.93 (n=36 meses both-nonzero) pode mascarar divergência durante COVID. Rodar separado por janela (pre-COVID / COVID+post).
  *Fonte: Blindspot 04-26 action item 5.*

- [ ] **Seção IRF completa + benchmark literatura brasileira**
  IRFs com 68/90% para z_het_jk e z_jk_purif; comparar com Minella (2003) e GRG (2025). Necessário para o paper ser uma contribuição empírica, não só metodológica.
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
