# Blindspot Report — Validation Suite (z_het_jk + yield_6m)
**Source:** /blindspot from session 2026-04-26, monetary_shocks_asset_prices
**Output audited:** output/het_validation_*.csv|md|png + correspondence/referee2/2026-04-26_round2_report.md (T1 placebo, T2 random-mask, T3 sub-period, T4 correlação com z_jk_purif)
**Usage:** Five robustness items + four paper-positioning opportunities. Five must be addressed before paper writeup; four must NOT be buried.

---

## Headline ruling: CONDITIONAL

T1/T3/T4 fortes. T2 (random-mask) é o ponto frágil: F obs=21.29 sits at q99=21.5 — informativo mas no limite. Reescrever framing antes do paper.

---

## Vice 1: Unexplained Features

12 features listadas. Duas flagged.

- ⚠ **FLAG — T2 q99=21.5 ≈ F obs=21.29.** Empirical p=0.0105 com SE binomial ≈0.0023 → CI95 ≈ [0.006, 0.015]. O relatório referee2 diz "genuinely informative, p ≈ 0.01"; o número honesto é "1-in-100 random selections beat JK". Reescrever para "JK F sits at the 99th percentile of random masks — informative, but the gap is one percentile."
- ⚠ FLAG — T1 max=34.5 > F obs=21.29. UMA permutação produziu F maior que o observado. p=1/2000=0.0005 é dirigido por exatamente esse caso. Cauda direita gorda explicável por esparsidade (42 não-zeros em 156 meses gera alinhamentos por acaso) mas vale anotar.
- ✓ DONE — T2 mean nulo=5.73 vs T1 mean nulo=1.22. T2 preserva sinais/magnitudes diários (só permuta seleção); T1 destrói sinal. Diferença esperada.
- ✓ DONE — covid_post beta SOBE (0.00266→0.00363) mas SE EXPLODE (0.00043→0.00108). Transmissão não enfraquece; ruído aumenta.
- ✓ DONE — drop_covid n_eff=143 = full n_eff − 7 (meses dropados). AR(6) discount aplicado uma vez no full sample. Consistente com `residualize_target` post-fix.
- ✓ DONE — T4 cor(all)=cor(union_nonzero)=0.745 porque 85 meses zero-zero não alteram correlação.

## Vice 2: Convenient Absences

Seis itens faltantes, cinco materiais:

- ⚠ **AR-order sensitivity (p ∈ {3, 12})** — flagado em referee2 minor mas não executado. Tabela auxiliar com F e p-placebo deveria entrar no relatório.
- ⚠ **Placebo + random-mask para `z_het` puro (sem JK)** como benchmark. Comparamos F=21 (JK) vs F=8 (no JK) só do audit grid; falta distribuição nula pareada.
- ⚠ **Anti-JK mask** — zerar dias *puros monetários* (sign(ε̂)≠sign(ΔIBOV)), manter os "informacionais". Se F(anti-JK) ≈ 5 (random level), evidência forte de que critério é informativo. Custo: 5 minutos.
- ⚠ **Random-mask em outros k (20, 60, 80)** — curva F(k) distinguiria "JK escolhe os 42 certos" vs "qualquer 42 chega perto".
- ⚠ **Cor(z_het_jk, z_jk_purif) por sub-período.** A cor=0.93 nos 36 meses de overlap pode mascarar divergência durante COVID.
- Comparação direta `z_jk_purif + yield_6m` com mesmo AR(6) e HC0 — apples-to-apples ainda missing.

**Unexplained N changes:** Nenhum. n_eff segue exatamente AR(6) discount = 6 meses. ✓

## Virtue 1: Unasked Questions

Três oportunidades de pivot.

- ⭐ **Heterogeneidade pre/post-COVID é uma seção de paper, não nota de robustez.** Beta SOBE +37% (0.00266→0.00363), SE +151% (0.00043→0.00108), R² estável (0.27→0.17). Hipótese publicável: mudança de regime de comunicação BCB pós-2020 (forward guidance, RI) reduz componente *surpresa*. Transmissão pode estar mais forte; identificação fica ruidosa.
- ⭐ **Het-ID é SUBCONJUNTO ESTRITO de timing-ID.** z_jk_purif: 65 meses; z_het_jk: 42 meses; ambos: 36; só timing: 29; só het: 6. Het é mais conservador, NÃO complementar. Reframe: "het-ID identifica subconjunto puro do timing-ID; os 29 meses onde só timing dispara são candidatos a contaminação."
- **var(innov[covid_post]) vs var(innov[pre_covid])** — teste de uma linha que explicaria toda discrepância de F sub-período. Nunca rodado.

## Virtue 2: Unexploited Strengths

Quatro pontos undersold.

- ⭐ **drop_covid F (24.2) > full F (21.3).** Remover 7 meses MECANICAMENTE deveria reduzir F. Sobe → COVID-acute window CONTAMINA ATIVAMENTE. Texto atual diz "robustness check passes"; versão forte: "removing the COVID-acute window strengthens identification, indicating active contamination during 2020-Q2/Q3."
- ⭐ **Replicação R↔Python a 6 decimais** está enterrada em referee report. Para macro-finança aplicada isso é incomum. Methods footnote / cover letter mencionando "results verified to 6 decimal places by independent NumPy + statsmodels replication".
- **Methods note publicável: residualização full-sample para sub-period F-tests sob janelas não-contíguas.** Refit AR within window quebra em drop_covid. Está em referee2 round 2 como detalhe; pode virar uma seção curta.
- **Triple-language replication** (round 1 het core em Python + round 2 validações em Python + R original). Para early-career project é over-the-top — usar como sinal de qualidade em cover letter.

---

## Action checklist (antes do paper writeup)

1. **Reescrever T2 narrative** em `output/het_validation_report.md` e `_instrucoes/Heteroscedasticidade.md`: "JK F sits at q99 of random masks (p ≈ 0.01), informative but the gap is one percentile."
2. **Rodar AR(p) sensibility** para p ∈ {3, 12}.
3. **Rodar anti-JK mask** (zerar puros monetários).
4. **Rodar curva F(k_keep)** para k ∈ {20, 42, 60, 80}.
5. **Computar var(innov) por sub-período** + cor(z_het_jk, z_jk_purif) por sub-período.

## Paper writeup — não enterrar

1. **drop_covid F > full F** como medida quantitativa de contaminação COVID.
2. **Het-ID como subconjunto estrito de timing-ID** (não complementar).
3. **Heterogeneidade pre/post-COVID** como achado próprio.
4. **Cross-language replication discipline** (R + Python, 6 decimais).

## Termination

Status: CONDITIONAL. Não bloqueia o paper, mas T2 framing precisa ser corrigido em todos os docs antes do writeup. Os outros 4 robustness checks (anti-JK, k-curve, z_het placebo, sub-period cor) são desejáveis mas não-bloqueantes.
