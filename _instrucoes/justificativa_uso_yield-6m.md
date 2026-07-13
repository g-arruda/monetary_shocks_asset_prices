Following Gertler and Karadi (2015), Bauer and Swanson (2023), and Gonçalves, Rodrigues and Genta (2025), we normalize the shock to a 50bp impact response of the 6-month yield rather than the overnight Selic. Brazilian institutional features make this choice particularly stark: Copom announcements occur after market close, so intra-day surprises are measured Wed-to-Thu on the DI futures curve, not on the overnight rate; aggregating those daily surprises to monthly and normalizing on the overnight Selic introduces a maturity mismatch that drives the first-stage F below 2 (Table X), while normalization at the 6-month yield yields F = 21.3.

## Caveat de unit scaling (resolvido 2026-05-07)

No painel `data/processed/data_log_deseasonalized.csv`, `yield_6m` é armazenado em **proporção decimal** (e.g., 0.0975 = 9.75%). A convenção anterior `normalize_value = SHOCK_BPS / 100 = 0.5` em `script/model_alessi.R` e em `script/irf_cross_instrument.R` forçava a IRF h=0 de `yield_6m` a +0.5 em **unidades nativas** — i.e., +0.5 em proporção = +50 percentage points = +5000bp, **não +50bp** como o nome do parâmetro sugeria. **Corrigido em 2026-05-07** (item LEVE 3): `normalize_value = SHOCK_BPS / 10000 = 0.005` em ambos os scripts. A IRF h=0 de `yield_6m` agora é +0.005 em proporção = +50bp como esperado.

Implicações:

- `script/build_grg_benchmark.R::scale_to_grg_units` foi simplificado: a divisão por 100 que existia para reconciliar com GRG sumiu — `raw_value` já está per-+50bp em unidades nativas. Apenas `cambio_usd` segue convertido para `%` via `raw_value / brl_usd_baseline * 100`.
- A leitura ECONÔMICA das IRFs (sinais, persistência, term-structure pass-through, comparação cross-instrument) é **idêntica**: todas as respostas escalam pelo mesmo fator. Apenas a magnitude absoluta cai em 100×.
- O default `normalize_value = 0.5` na função `ident_ext_instr` (`R/modeling/impulse_responde.R:35`) foi mantido para compatibilidade com `script/model_var.R`, que hard-coda `juros_selic` em escala percentual. O docstring documenta a convenção.

Audit reports anteriores ficam fora-de-escala em 100× nas magnitudes; comentário interpretativo permanece válido. Após regenerar `output/irf/irf_*.pdf` e `output/benchmark/grg_benchmark.csv`, confirmar visualmente: yield_6m IRF h=0 ≈ +0.005 (não +0.5) e os pontos de Δπ, Δ(BRL/USD), ΔCDS na tabela GRG benchmark devem permanecer numericamente idênticos aos anteriores (porque o velho caminho `raw/100` é algébricamente equivalente a `raw_new` per-+50bp).
