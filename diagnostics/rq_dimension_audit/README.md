# Auditoria das dimensões `(r,q)`

> **SUPERSEDED em 2026-08-13 pela auditoria conjunta em
> [`../rq_block_dimension_audit/`](../rq_block_dimension_audit/).** Esta pasta
> preserva o código e os artefatos da
> auditoria que sustenta
> [`notas/2026-08-13_parecer_dimensoes_rq.md`](../../notas/2026-08-13_parecer_dimensoes_rq.md).
> A amostra completa do painel canônico é o alvo da seleção. A janela
> pré-COVID é apenas robustez temporal. Os scripts escrevem somente em
> `diagnostics/rq_dimension_audit/output/` e não alteram a estimação nem os
> artefatos de produção. Seu veredito sobre o painel de 106 séries não deve ser
> usado como decisão corrente, mas a reprodução numérica permanece válida para
> aquele painel e vintage.

## Conteúdo

`scripts/` contém a reprodução BLL/AW em R, a implementação independente em
NumPy, as estimações de ponto, o bootstrap das dez células e as três etapas de
consolidação. `output/` preserva todos os 114 arquivos produzidos na rodada,
que ocupam cerca de 12 MB.

| caminho | conteúdo |
|---|---|
| `output/panels/` | 64 painéis exportados pelo R para a reprodução independente em NumPy |
| `output/bootstrap/` | dez RDS, dez CSVs de IRF e dez CSVs de metadados, um conjunto por candidata e amostra |
| `output/r_*` e `output/python_*` | superfícies, autovalores e seleções das duas implementações |
| `output/cross_language_comparison.csv` | tolerâncias e diferenças máximas entre R e NumPy |
| `output/aw_convention_sensitivity.csv` | comparação de `p=6/12` e `max_q=r/15` nas 128 células |
| `output/canonical_selection.csv` | seleção BLL/AW no painel canônico |
| `output/canonical_difference_stationarity.csv` | diagnósticos ADF e PP nas diferenças padronizadas |
| `output/candidate_point_*` | força, estabilidade e IRFs de ponto das cinco candidatas |
| `output/candidate_*summary.csv` | comparação final, janelas teóricas e estabilidade entre amostras |
| `output/production_point_reproduction.csv` | reprodução da célula canônica `(7,6)` contra o RDS vigente |

Os RDS preservam os objetos completos das 800 réplicas, enquanto os CSVs de
IRF guardam apenas `yield_6m`, `yield_2y`, `yield_5y`, `asset_ibov` e
`cambio_usd`. Os painéis comprimidos são intermediários deliberados porque a
reprodução NumPy lê exatamente a matriz que o R construiu. Eles não substituem
o painel processado nem constituem uma nova fonte de dados.

## Ordem de execução

Os comandos partem da raiz do repositório. A seleção fatorial em R deve
preceder a reprodução NumPy porque exporta os 64 painéis e as superfícies de
referência.

```bash
Rscript diagnostics/rq_dimension_audit/scripts/reproduce_factor_selection.R
python3 diagnostics/rq_dimension_audit/scripts/reproduce_factor_selection.py
Rscript diagnostics/rq_dimension_audit/scripts/estimate_candidate_points.R
```

O bootstrap requer uma chamada por célula. As candidatas são `(2,2)`, `(5,3)`,
`(5,4)`, `(7,6)` e `(7,7)`, estimadas na amostra completa e na pré-COVID.

```bash
for sample in full pre_covid; do
  for rq in 2:2 5:3 5:4 7:6 7:7; do
    r=${rq%:*}
    q=${rq#*:}
    Rscript diagnostics/rq_dimension_audit/scripts/estimate_candidate_bootstrap.R "$sample" "$r" "$q"
  done
done
```

As consolidações são executadas depois das dez células.

```bash
Rscript diagnostics/rq_dimension_audit/scripts/summarize_candidates.R
Rscript diagnostics/rq_dimension_audit/scripts/summarize_variable_stability.R
Rscript diagnostics/rq_dimension_audit/scripts/summarize_bands.R
```

## Invariantes e tolerâncias

A reprodução exige 153 meses e 106 séries finitas no painel canônico. Cada
painel experimental deve ter diferenças com escala positiva, e as 128 escolhas
em R devem coincidir com os artefatos experimentais já existentes. A comparação
R e NumPy usa

```text
abs(R - Python) <= 1e-10 + 1e-9 * max(abs(R), abs(Python)).
```

A célula `(7,6)` da amostra completa deve reproduzir os 245 pontos das cinco
IRFs no RDS corrente, além da raiz máxima da companion. Os resumos exigem dez
células, 800 réplicas por célula, estabilidade e zero falhas de bootstrap.

## Ambiente da rodada

A rodada foi executada com R 4.3.3 e Python 3.12.12. A reprodução NumPy usou
NumPy 2.4.2, pandas 2.2.3 e SciPy 1.17.0. Os testes ADF e PP dependem dos pacotes
R `tseries` e `urca`, além das dependências já usadas pelo projeto.

## Limites

A auditoria cruzada usa duas linguagens e compartilha as matrizes de painel
exportadas pelo R. Ela não constitui uma terceira reprodução independente da
construção dos painéis. A rodada também não refez a construção diária do
instrumento nem demonstrou validade uniforme das bandas sob instrumento fraco.
