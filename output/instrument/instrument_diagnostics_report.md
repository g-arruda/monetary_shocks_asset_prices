# Instrument Validity Diagnostics Report

**Date generated:** 2026-09-17
**DFM sample:** 2012-03-01 to 2025-12-01  
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
| z_bruto | 162 | 95 | 6.678 | 9.367 | +7.18e-05 | 2.35e-05 | 0.003 | +5.85e-05 | + | 1.036 | 0.404 |
| z_bruto_purif | 162 | 99 | 6.751 | 9.344 | +7.17e-05 | 2.35e-05 | 0.003 | +5.88e-05 | + | 1.042 | 0.401 |
| z_jk | 162 | 66 | 4.916 | 7.768 | +7.55e-05 | 2.71e-05 | 0.006 | +6.59e-05 | + | 1.048 | 0.397 |
| z_jk_purif | 162 | 67 | 4.982 | 7.759 | +7.52e-05 | 2.70e-05 | 0.006 | +6.60e-05 | + | 1.014 | 0.418 |
| z_jk_raw_purif | 162 | 57 | 6.651 | 12.472 | +1.00e-04 | 2.84e-05 | < 0.001 | +8.63e-05 | + | 1.097 | 0.367 |
| z_jk_raw | 162 | 57 | 6.666 | 12.549 | +9.95e-05 | 2.81e-05 | < 0.001 | +8.52e-05 | + | 1.141 | 0.341 |
| z_bs_purif | 162 | 99 | 6.160 | 7.895 | +6.74e-05 | 2.40e-05 | 0.006 | +5.58e-05 | + | 1.166 | 0.328 |
| z_jk_bs_purif | 162 | 65 | 6.848 | 11.765 | +1.02e-04 | 2.97e-05 | < 0.001 | +8.82e-05 | + | 1.212 | 0.303 |

---

## 2. Scatterplot — purified surprises on Copom days

Wrong-signed (information) share: **32.4%**.

![scatter](scatterplot_surpresas_copom.png)

Quadrants II & IV (green, negative co-movement) are classified as monetary shocks and kept in z_JK / z_JK_purif.  
Quadrants I & III (orange, positive co-movement) are classified as information shocks and zeroed out.

---

## 3. Variance F-test: Copom vs. non-Copom Thursdays

H0: equal variance.  Expect rejection for `e_DI` (news shock on Copom days), ideally NOT for `e_Ibov`.

| Series | Var(Copom) | Var(non-Copom) | n_C | n_NC | F | p-value |
|---|---|---|---|---|---|---|
| e_DI | 173.00 | 60.10 | 102 | 536 | 2.880 | 1.07e-14 |
| e_Ibov |   1.86 |  1.69 | 102 | 536 | 1.100 | 5.01e-01 |
| delta_DI (raw) | 174.00 | 60.40 | 102 | 536 | 2.880 | 9.77e-15 |
| delta_Ibov (raw) |   2.20 |  2.33 | 102 | 536 | 0.943 | 7.29e-01 |

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
