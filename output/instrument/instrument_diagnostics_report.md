# Instrument Validity Diagnostics Report

**Date generated:** 2026-08-13
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
| z_bruto | 147 | 87 | 8.039 | 5.986 | +6.95e-05 | 2.84e-05 | 0.016 | +3.74e-05 | + | 3.059 | 0.008 |
| z_bruto_purif | 147 | 90 | 7.492 | 5.487 | +6.77e-05 | 2.89e-05 | 0.021 | +3.71e-05 | + | 3.043 | 0.008 |
| z_jk | 147 | 61 | 5.137 | 4.888 | +8.13e-05 | 3.68e-05 | 0.029 | +4.62e-05 | + | 3.085 | 0.007 |
| z_jk_purif | 147 | 63 | 4.864 | 4.461 | +7.94e-05 | 3.76e-05 | 0.037 | +4.61e-05 | + | 3.117 | 0.007 |
| z_jk_raw_purif | 147 | 54 | 11.268 | 13.289 | +1.23e-04 | 3.38e-05 | < 0.001 | +6.81e-05 | + | 2.757 | 0.015 |
| z_jk_raw | 147 | 54 | 11.111 | 12.805 | +1.21e-04 | 3.38e-05 | < 0.001 | +6.56e-05 | + | 2.689 | 0.017 |
| z_bs_purif | 147 | 90 | 5.972 | 4.285 | +5.99e-05 | 2.89e-05 | 0.041 | +3.36e-05 | + | 3.425 | 0.004 |
| z_jk_bs_purif | 147 | 60 | 11.616 | 12.437 | +1.28e-04 | 3.62e-05 | < 0.001 | +7.10e-05 | + | 2.871 | 0.012 |

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
