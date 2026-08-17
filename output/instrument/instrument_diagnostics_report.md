# Instrument Validity Diagnostics Report

**Date generated:** 2026-08-17
**DFM sample:** 2013-01-01 to 2025-09-01  
**Identification:** proxy-SVAR with external instrument (Montiel Olea, Stock & Watson 2021).
**Instrument variants:** raw Copom-day ΔDI (3m), purified by global factors (SP500, VIX, Brent),
Jarociński-Karadi sign filter, and JK + purified.

---

## 1. Força do instrumento por variante

As duas estatísticas seguem a §4.2 de Montiel Olea-Stock-Watson (2021).
**ξ_mp** é a Wald na direção c'Γ̂ com c = linha de `yield_6m` na matriz de
  impacto Λ·K·M: é o análogo exato do `Waldstat` oficial (Γ̂ da variável
normalizadora). **F robusto_mp** é o t² HC1 do instrumento na regressão
de c_mp'η_t sobre o instrumento e as defasagens dos fatores. Ambos usam a
mesma direção; o código reproduz ξ₁=4,4 e F=9,4 da aplicação dos autores.

| Variant | n | nonzero | ξ_mp | F robusto_mp | β̂_mp | SE(HC1) | p_mp | impacto y6m | sinal | Exog F | Exog p |
|---|---|---|---|---|---|---|---|---|---|---|---|
| z_bruto | 147 | 87 | 5.271 | 5.611 | +6.81e-05 | 2.87e-05 | 0.020 | +4.66e-05 | + | 2.300 | 0.038 |
| z_bruto_purif | 147 | 90 | 5.067 | 5.278 | +6.60e-05 | 2.87e-05 | 0.023 | +4.59e-05 | + | 2.310 | 0.037 |
| z_jk | 147 | 61 | 4.084 | 5.772 | +8.40e-05 | 3.49e-05 | 0.018 | +6.25e-05 | + | 1.847 | 0.095 |
| z_jk_purif | 147 | 63 | 3.980 | 5.446 | +8.22e-05 | 3.52e-05 | 0.021 | +6.18e-05 | + | 1.887 | 0.087 |
| z_jk_raw_purif | 147 | 54 | 6.343 | 10.987 | +1.13e-04 | 3.40e-05 | 0.001 | +8.11e-05 | + | 2.010 | 0.069 |
| z_jk_raw | 147 | 54 | 6.494 | 11.267 | +1.12e-04 | 3.35e-05 | 0.001 | +8.02e-05 | + | 1.972 | 0.074 |
| z_bs_purif | 147 | 90 | 4.368 | 4.322 | +6.12e-05 | 2.95e-05 | 0.040 | +4.32e-05 | + | 2.518 | 0.024 |
| z_jk_bs_purif | 147 | 60 | 6.271 | 10.121 | +1.15e-04 | 3.61e-05 | 0.002 | +8.43e-05 | + | 2.174 | 0.049 |

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

- O valor 10 é uma referência convencional, não um valor crítico fornecido por MOSW.
- Se ξ_mp e F robusto_mp divergirem, a evidência de força é mista.
- Abaixo de 10, qualificar o bootstrap; a inferência AR do DFM está adiada.
- **ξ_mp abaixo de 3,84**: um futuro conjunto AR de 95% pode ser ilimitado.
- MOSW (§4.2, footnote 6)
  advertem ainda contra *screening* no F: reportar F/ξ e usar rotineiramente
  os conjuntos AR robustos, não condicionar a inferência no pré-teste.  
- Compare z_bruto vs. z_JK to assess whether the JK filter changes identification, and vs. their `_purif` counterparts for the role of global-factor contamination.
