# Auditoria de alinhamento — relevância em Montiel Olea, Stock e Watson

**Atualização:** 2026-08-13
**Referência:** Montiel Olea, Stock e Watson, seção 4.2, aplicação de Kilian e
código oficial dos autores.

## Estatísticas reportadas

O projeto reporta duas estatísticas na mesma direção que normaliza o choque de
política monetária:

1. **ξ_mp:** Wald robusta MOSW para o momento entre o instrumento e a inovação
   de `yield_6m` implícita nos fatores. A variância residualiza o instrumento
   nos lags do VAR de fatores e incorpora a correção correspondente à estimação
   dos coeficientes reduzidos.
2. **F_rob,mp:** primeiro estágio da mesma inovação em `z_t`, com os mesmos
   lags do VAR como controles e matriz HC1. Para um único instrumento, é o
   quadrado do t robusto do coeficiente de `z_t`.

O valor 10 é uma referência convencional, não um valor crítico fornecido por
MOSW. As estatísticas são apresentadas como diagnóstico e não como regra de
pré-seleção das IRFs.

## Validação externa

`script/validate_olea_kilian.R` reproduz a aplicação publicada:

| estatística | projeto | publicado |
|---|---:|---:|
| ξ_1 | 4,399 | 4,4 |
| F robusto HC1 | 9,438 | 9,4 |

A validação falha ruidosamente se uma alteração futura afastar esses números
além da tolerância definida no script.

## Produção brasileira

Para `z_jk_bs_purif`, r=7, q=6 e p=6:

| amostra | ξ_mp | F_rob,mp |
|---|---:|---:|
| completa | 7,65 | 7,95 |
| pré-COVID | 11,53 | 6,26 |

Na amostra completa, as duas estatísticas apontam relevância abaixo da
referência convencional de 10. No pré-COVID, elas divergem: ξ_mp fica acima de
10, mas F_rob,mp não. A leitura correta é evidência mista, com cautela na
inferência em ambas as janelas. A diferença pré-COVID é ampliada pela correção
HC1 numa regressão curta: 78 observações efetivas e 42 controles de lags dos
fatores.

## Implementação e consumidores

- `R/modeling/impulse_responde.R` contém
  `compute_robust_first_stage_F()` e a rotina da Wald MOSW.
- `R/identification/factor_space_diagnostics.R` constrói a direção de
  `yield_6m` e devolve `wald_mp` e `f_robust_mp`.
- `script/instrument_diagnostics.R`, `script/mosw_strength_grid.R` e as
  varreduras de especificação propagam somente essas duas estatísticas de
  relevância para os relatórios ativos.
