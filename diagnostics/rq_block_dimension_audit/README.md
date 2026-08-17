# Auditoria conjunta de painel e dimensões `(r,q)`

> **CURRENT, 2026-08-13.** Esta auditoria substitui a decisão dimensional
> isolada em [`../rq_dimension_audit/`](../rq_dimension_audit/), porque o painel
> canônico de 106 séries deixou de ser o universo metodologicamente admissível.
> A rodada escreve apenas em `diagnostics/rq_block_dimension_audit/output/` e
> não migra a produção nem altera o paper.

## Desenho

Os 64 painéis excluem `juros_cdi` e `asset_mlcx` e percorrem todas as
combinações de presença dos seis blocos candidatos. Em cada painel, a amostra
completa é estimada nos 36 pares `r=1,...,8`, `q=1,...,r`. Células não finitas,
instáveis ou com `xi_mp<=3,84` são inadmissíveis. As demais são ordenadas pela
distância Manhattan ao mínimo BLL/AW full do painel, raiz da companion,
coerência de sinal em `h=0,...,6`, `r` e `q`.

A pré-COVID reestima apenas a dimensão escolhida na amostra completa. Os seis
blocos são decididos por 32 contrastes pareados cada, usando distância BLL/AW,
raiz, relevância pré-COVID, RMSE normalizado das cinco IRFs, erros de sinal e
parcimônia. O câmbio é preservado como canal `soft`: entra no RMSE, mas não
gera erro de sinal.

O arquivo `scripts/scalar_dynamic_factor_compat.R` corrigia apenas dentro desta
auditoria a construção de `M` quando `q=1<r`: `diag(x)` interpretava o escalar
como dimensão, em vez de valor diagonal. As trajetórias `q>1` e `q=r` chamam
diretamente o helper do projeto, e nenhum módulo de produção é alterado.

**O defeito foi corrigido no módulo em 2026-08-17** (`diag(sqrt(eigenvals),
nrow = q)`). O override sobrevive só porque divide por `M[1, 1]` enquanto o
módulo multiplica por `solve(M)`, e as duas formas diferem na última casa
(4,4e-16); esta auditoria está congelada e seus CSVs são citados, então a
remoção espera a próxima re-rodada da grade.

## Ordem de execução

Os comandos partem da raiz. A grade pode ser dividida em qualquer número de
shards; quatro são usados abaixo apenas para reduzir o tempo de parede.

```bash
for shard in 1 2 3 4; do
  Rscript diagnostics/rq_block_dimension_audit/scripts/01_estimate_full_grid.R "$shard" 4 &
done
wait
Rscript diagnostics/rq_block_dimension_audit/scripts/02_select_panels_and_dimensions.R
```

`output/bootstrap_finalists.csv` determina as células distintas. Cada linha é
passada ao bootstrap:

```bash
tail -n +2 diagnostics/rq_block_dimension_audit/output/bootstrap_finalists.csv |
while IFS=, read -r variant r q role; do
  Rscript diagnostics/rq_block_dimension_audit/scripts/03_bootstrap_finalist.R "$variant" "$r" "$q"
done
Rscript diagnostics/rq_block_dimension_audit/scripts/04_finalize_audit.R
Rscript diagnostics/rq_block_dimension_audit/scripts/05_validate_audit.R
```

## Artefatos principais

- `full_grid_cells.csv`, `full_grid_irfs.csv` e `full_grid_failures.csv`: 2.304
  células full, as cinco IRFs de ponto em `h=0,...,6` e falhas explícitas.
- `panel_manifest.csv`: composição e N dos 64 painéis.
- `prior_grid_reproduction.csv`: reprodução das 1.152 células na interseção
  com a grade anterior.
- `panel_dimension_ranking.csv` e `panel_dimension_decisions.csv`: ranking
  completo e uma escolha por painel.
- `selected_pre_covid_*`: 64 reestimações diagnósticas.
- `block_contrasts.csv` e `block_decisions.csv`: 192 contrastes e seis
  vereditos de bloco.
- `bootstrap/`, `bootstrap_gate.csv` e `final_decision.csv`: finalistas com
  800 réplicas, semente 123 e o veredito após o gate de bandas.
- `audit_report.md`: relatório legível da rodada.

## Limite

O resultado é uma decisão pronta para migração posterior. Até essa migração,
os scripts e artefatos canônicos continuam usando o painel de 106 séries e
`(7,6)`; esta pasta não deve ser lida como se a produção já tivesse mudado.
