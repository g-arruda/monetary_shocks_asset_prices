# Inventário: o que já foi testado no instrumento (levantado em 2026-08-14)

*Log de sessão, descartável. O registro durável desta rodada é
`notas/2026-08-14_exogeneidade_lead_lag_e_invertibilidade.md`.*

Levantado ao responder "outros testes foram feitos no instrumento?". Serve para
não reabrir frente já coberta. Confirmado por `grep` que `granger`, `invertib` e
`fundamental` **não apareciam** em `R/`, `script/` nem `diagnostics/` antes desta
rodada (único hit era um comentário sobre inversão de matriz em
`het_primary.R:238`).

| frente | onde | veredito |
|---|---|---|
| Previsibilidade por bloco externo (níveis e retornos, L=3,6) | `01_exogeneidade.R` §1.1 | passa; `cambio_usd` único abaixo de 0,10 (`p_boot` 0,064) |
| Previsibilidade por fatores estimados (L=1,3,6) | §1.2 | passa, `p_boot` 0,40–0,62 |
| Previsibilidade por η defasado (L=3,6) | §1.2 | passa, 0,63 e 0,93 |
| Leads de η (L=3,6) | §1.2 | passa, 0,71 e 0,97 — **é teste de invertibilidade, não de exogeneidade** |
| **Granger: z → equações do VAR de fatores (L=3,6)** | §1.7, **novo em 2026-08-14** | não rejeita; menor `p_boot` 0,324 em L=6, todos Holm 1,000 |
| Autocorrelação de z (lags próprios, Ljung-Box, ACF) | §1.3 | sem MA(1); justifica NW(0) |
| Correlações cruzadas k=−6..+6 com placebos | §1.4/1.5 | — |
| Placebo commodity BRL vs USD | §1.6 | violação é denominação, não exogeneidade |
| Placebos na IRF (VIX, MSCI, EPU-US) | `irf_coherence_check.R` | 0/49 a 90%; 1/147 a 68% |
| Força: F 1º estágio, ξ_mp, MOSW | `instrument_diagnostics.R`, `mosw_strength_grid.R` | 6,27 / 10,12 |
| Robustez de ξ_mp: LOO (147) + HAC NW(0..6) | `xi_mp_robustness.R` | 0/147 abaixo de 3,84; 147/147 abaixo de 10 |
| Construção: vértice × agregação (260 células) | `instrument_construction_sweep.R` | vértice não decide |
| Confundidor soberano (EMBI+, CDS), valores + máscara | `jk_sovereign_confound.R` | não confirmado |
| Coincidência FOMC, testes 0–3, valores + máscara | `fomc_coincidence.R` | não detectado |
| Identificação sem z (GMR, Rigobon) | `nongaussian_*`, `het_robustness.R` | não discrimina / não identifica |

**Leitura:** antes de 2026-08-14 tudo interrogava **relevância** e
**exogeneidade**. Nada interrogava **invertibilidade** — a terceira condição, a
única que o SVAR-IV de fato exige além das duas contemporâneas, e que
`paper_anpec.tex:192` já admitia sem testar.

## Nota sobre `codigos_externos/codigo_SW`

Na primeira versão o diretório continha a réplica de **Fernald, Hall, Stock &
Watson (2017, BPEA)** — decomposição tendência-ciclo, zero código de
identificação. Foi substituída pela réplica correta do capítulo do *Handbook of
Macroeconomics* (`codigo_sw/ddisk/`, arquivos `hom_*`). Mesmo a correta **não tem
código de instrumento externo**: as aplicações identificam choques de petróleo por
esquema recursivo de Kilian e por exogeneidade do preço. `grep -ri
"instrument|proxy|granger|invertib|external"` sobre os 58 `.m` retorna zero linhas.

O que ela **tem** de aproveitável, e virou item aberto:
- `matlab/hom_var_approx.m` — correlações canônicas VAR pequeno × espaço de
  fatores (Tabela 5). Não existe no repo.
- `matlab/amengual_watson.m` — referência para validar a tradução já existente em
  `R/modeling/factor_estimation.R:168`, que hoje não tem `validate_*.R`.
