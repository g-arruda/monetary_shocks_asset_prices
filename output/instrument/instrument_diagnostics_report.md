# Instrument Validity Diagnostics Report

**Date generated:** 2026-08-25
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
| z_bruto | 149 | 87 | 4.255 | 5.485 | +7.34e-05 | 3.14e-05 | 0.021 | +5.70e-05 | + | 2.586 | 0.021 |
| z_bruto_purif | 149 | 90 | 4.105 | 5.172 | +7.18e-05 | 3.16e-05 | 0.025 | +5.62e-05 | + | 2.625 | 0.019 |
| z_jk | 149 | 61 | 3.503 | 5.431 | +8.73e-05 | 3.75e-05 | 0.021 | +7.22e-05 | + | 2.577 | 0.021 |
| z_jk_purif | 149 | 63 | 3.404 | 5.085 | +8.56e-05 | 3.80e-05 | 0.026 | +7.11e-05 | + | 2.622 | 0.019 |
| z_jk_raw_purif | 149 | 54 | 5.285 | 11.022 | +1.21e-04 | 3.64e-05 | 0.001 | +9.86e-05 | + | 2.536 | 0.023 |
| z_jk_raw | 149 | 54 | 5.384 | 11.276 | +1.20e-04 | 3.58e-05 | 0.001 | +9.74e-05 | + | 2.481 | 0.026 |
| z_bs_purif | 149 | 90 | 3.563 | 4.169 | +6.65e-05 | 3.26e-05 | 0.043 | +5.27e-05 | + | 2.969 | 0.009 |
| z_jk_bs_purif | 149 | 60 | 5.240 | 10.061 | +1.24e-04 | 3.90e-05 | 0.002 | +1.01e-04 | + | 2.861 | 0.012 |

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
