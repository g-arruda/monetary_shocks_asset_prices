# Instrument Validity Diagnostics Report

**Date generated:** 2026-08-05  
**DFM sample:** 2013-01-01 to 2025-09-01  
**Identification:** proxy-SVAR with external instrument (Olea, Stock & Watson 2020).
**Instrument variants:** raw Copom-day ΔDI (3m), purified by global factors (SP500, VIX, Brent),
Jarociński-Karadi sign filter, and JK + purified.

---

## 1. First-stage comparison across variants

Three first-stage statistics are reported side by side:

- **F (DFM)** — partial F (= t²) of the instrument in the regression of the
  first-factor VAR residual on Z plus lagged factors, HC0 SE. This is the
  Olea-Stock-Watson statistic that governs weak-instrument bias inside the
  Alessi-Kerssenfischer proxy-SVAR; the relevant target is the DFM residual,
  not the policy rate.
- **F (y6m AR)** — partial F of the instrument against the AR(6) innovation
  of monthly `yield_6m` (univariate, HC0 SE). This is the audit statistic
  (`output/instrument/instrument_audit_report.md`, 2026-04-25): it measures relevance
  for the Selic-equivalent interpretation of the shock and feeds the
  normalization in `model_alessi.R` (`mp_var = yield_6m`).
- **F (factor-sp)** — max univariate F across the q dynamic factor
  innovations η = u K M⁻¹. This is the relevant weak-instrument metric
  for the proxy-SVAR projection H = (Z'η)/(Z'Z): if it is small, the
  IRFs become noise-dominated regardless of how strong Z is against any
  single reduced-form variable. **FS-Flag = WEAK-FACT when F (factor-sp) < 10.**
  Disagreement between F (factor-sp) and F (y6m AR) was the root cause
  of the 2026-05-08 IRF investigation (see _instrucoes/historico_decisoes.md).

The three answers can disagree by an order of magnitude. ξ₁ uses the
Olea-Stock-Watson convention; threshold = 3.84.

| Variant | n (DFM) | nonzero | β̂ | SE(HC0) | t | p | F (DFM) | ξ₁ | R² | n (y6m) | F (y6m AR) | R² y6m | F (factor-sp) | impact y6m | sign | Exog F | Exog p | Flag | FS-Flag |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| z_bruto | 147 | 87 | -0.054 | 0.026 | -2.062 | 0.042 | 4.253 | 3.453 | 0.032 | 150 | 20.362 | 0.163 | 2.564 | +4.27e-05 | + | 1.628 | 0.144 | WEAK | WEAK-FACT |
| z_bruto_purif | 147 | 90 | -0.059 | 0.027 | -2.223 | 0.029 | 4.940 | 4.051 | 0.038 | 150 | 17.052 | 0.150 | 3.126 | +4.07e-05 | + | 1.673 | 0.132 | OK | WEAK-FACT |
| z_jk | 147 | 61 | -0.061 | 0.031 | -1.972 | 0.051 | 3.888 | 3.738 | 0.030 | 150 | 13.397 | 0.130 | 8.558 | +5.95e-05 | + | 2.780 | 0.014 | WEAK | WEAK-FACT |
| z_jk_purif | 147 | 63 | -0.065 | 0.031 | -2.093 | 0.039 | 4.379 | 4.146 | 0.034 | 150 | 11.402 | 0.122 | 9.950 | +5.84e-05 | + | 2.846 | 0.012 | OK | WEAK-FACT |
| z_jk_raw_purif | 147 | 54 | -0.056 | 0.028 | -1.999 | 0.048 | 3.994 | 2.952 | 0.023 | 150 | 26.121 | 0.182 | 4.023 | +9.06e-05 | + | 2.298 | 0.038 | WEAK | WEAK-FACT |
| z_jk_raw | 147 | 54 | -0.052 | 0.028 | -1.879 | 0.063 | 3.529 | 2.576 | 0.020 | 150 | 26.625 | 0.185 | 3.885 | +8.78e-05 | + | 2.251 | 0.042 | WEAK | WEAK-FACT |
| z_bs_purif | 147 | 90 | -0.057 | 0.028 | -2.050 | 0.043 | 4.202 | 3.576 | 0.034 | 150 | 17.334 | 0.148 | 2.804 | +3.74e-05 | + | 1.747 | 0.115 | WEAK | WEAK-FACT |
| z_jk_bs_purif | 147 | 60 | -0.061 | 0.031 | -1.968 | 0.052 | 3.875 | 3.070 | 0.024 | 150 | 25.179 | 0.181 | 3.995 | +9.38e-05 | + | 2.285 | 0.039 | WEAK | WEAK-FACT |

### 1.1 Bloco Wald MOSW (leitura conservadora)

Estatísticas de Wald de Montiel Olea-Stock-Watson (2021, §4.2), validadas
contra o código oficial dos autores (`codigo_olea/`, MSWfunction.m e
CovAhat_Sigmahat_Gamma.m). Todas usam Eicker-White (Newey-West 0 lags) e
residualizam Z nos regressores do VAR de fatores (correção Shat), exceto a
coluna legada ξ₁:

- **ξ₁ (legado)** — T·Γ̂₁²/Ŵ₁₁ contra o resíduo do 1º fator, sem correção
  Shat (coluna mantida por comparabilidade).
- **ξ₁ (Shat)** — mesma estatística com Z residualizado em lags + constante,
  exatamente como `CovAhat_Sigmahat_Gamma.m` propaga o erro de estimação do VAR.
- **min/max ξ_k** — Wald robusta por inovação de fator, k = 1..q. O mínimo
  é a leitura conservadora por equação; o máximo compara com a coluna
  legada F (factor-sp), que é homocedástica e não robusta.
- **Wald conjunta** — ξ = T·Γ̂'Ŵ⁻¹Γ̂ ~ χ²_q sob irrelevância (o `WaldstatFull`
  dos autores, MSWfunction.m:389). Não faz cherry-pick da equação mais forte.
  **F conjunta = ξ/q** é a forma-F para leitura na régua Stock-Yogo.
- **ξ_mp** — Wald na direção c'Γ̂ com c = linha de `yield_6m` na matriz de
  impacto Λ·K·M: é o análogo exato do `Waldstat` oficial (Γ̂ da variável
  normalizadora) na nossa parametrização, e governa o denominador da
  normalização. **O conjunto AR 95% é intervalo limitado sse ξ_mp > 3.84**
  (Fieller/Anderson-Rubin, footnote 13 do paper).

| Variant | ξ₁ (legado) | ξ₁ (Shat) | min ξ_k | max ξ_k | Wald conj. | F conj. (ξ/q) | p (χ²_q) | ξ_mp | AR limitado? | MOSW-Flag |
|---|---|---|---|---|---|---|---|---|---|---|
| z_bruto | 3.453 | 4.590 | 0.028 | 4.590 | 12.708 | 1.588 | 0.122 | 6.756 | yes | WEAK (AR bounded) |
| z_bruto_purif | 4.051 | 5.346 | 0.016 | 5.346 | 12.568 | 1.571 | 0.128 | 5.752 | yes | WEAK (AR bounded) |
| z_jk | 3.738 | 3.424 | 0.002 | 9.668 | 14.297 | 1.787 | 0.074 | 5.187 | yes | WEAK (AR bounded) |
| z_jk_purif | 4.146 | 3.761 | 0.028 | 9.456 | 14.548 | 1.818 | 0.069 | 4.702 | yes | WEAK (AR bounded) |
| z_jk_raw_purif | 2.952 | 3.517 | 0.663 | 6.107 | 15.579 | 1.947 | 0.049 | 12.194 | yes | WEAK (AR bounded) |
| z_jk_raw | 2.576 | 3.163 | 0.566 | 6.074 | 15.511 | 1.939 | 0.050 | 12.284 | yes | WEAK (AR bounded) |
| z_bs_purif | 3.576 | 4.551 | 0.043 | 4.551 | 10.634 | 1.329 | 0.223 | 4.832 | yes | WEAK (AR bounded) |
| z_jk_bs_purif | 3.070 | 3.434 | 0.413 | 6.372 | 16.030 | 2.004 | 0.042 | 12.566 | yes | WEAK (AR bounded) |

---

## 2. Scatterplot — purified surprises on Copom days

Wrong-signed (information) share: **31.6%**.

![scatter](scatterplot_surpresas_copom.png)

Quadrants II & IV (green, negative co-movement) are classified as monetary shocks and kept in z_JK / z_JK_purif.  
Quadrants I & III (orange, positive co-movement) are classified as information shocks and zeroed out.

---

## 3. Variance F-test: Copom vs. non-Copom Thursdays

H0: equal variance.  Expect rejection for `e_DI` (news shock on Copom days), ideally NOT for `e_Ibov`.

| Series | Var(Copom) | Var(non-Copom) | n_C | n_NC | F | p-value |
|---|---|---|---|---|---|---|
| e_DI | 174.00 | 61.50 | 95 | 503 | 2.830 | 2.45e-13 |
| e_Ibov |   1.91 |  1.70 | 95 | 503 | 1.120 | 4.34e-01 |
| delta_DI (raw) | 175.00 | 61.80 | 95 | 503 | 2.830 | 2.34e-13 |
| delta_Ibov (raw) |   2.25 |  2.32 | 95 | 503 | 0.968 | 8.70e-01 |

---

## 4. Interpretation

- **F > 10 / ξ₁ > 10**: inference standard OK.  
- **F ∈ [5, 10]**: use Anderson-Rubin robust intervals.  
- **ξ₁ < 3.84**: instrument flagged as weak; AR CIs possibly unbounded.  
- **Leitura conservadora (§1.1)**: a decisão de força do instrumento deve
  usar a **F conjunta (ξ/q)** e a **ξ_mp**, não o máximo por equação. A regra
  F > 10 aplicada ao máximo de q regressões é anti-conservadora (viés de
  seleção da equação mais forte); a coluna F (factor-sp) permanece apenas
  por comparabilidade com o spec sweep de 2026-07-11. MOSW (§4.2, footnote 6)
  advertem ainda contra *screening* no F: reportar F/ξ e usar rotineiramente
  os conjuntos AR robustos, não condicionar a inferência no pré-teste.  
- Compare z_bruto vs. z_JK to assess whether the JK filter changes identification, and vs. their `_purif` counterparts for the role of global-factor contamination.
