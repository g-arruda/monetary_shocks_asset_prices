# `diagnostics/` — o que cada arquivo faz

> ⚠ **Desde 2026-09-18 estes scripts não rodam contra o `R/` corrente.** O wild
> bootstrap e a correção de Kilian saíram do código, e os scripts `01`-`05` e as
> duas auditorias `rq_*` ainda passam `apply_kilian`, `nboot` ou
> `bootstrap_seed`, ou leem `companion_corrected`. Por decisão do autor, ficam
> sem edição, como registro do que rodou: a versão de `R/` com que rodaram é
> `main` em `07b1cbd`. Já estavam na vintage de 111 séries antes disso. As saídas
> em `output/` e os `.md` valem como o registro datado da rodada.

A rodada de auditoria DFM-IV de 2026-07-28. Sete scripts numerados (`01`-`07`)
compartilhando `_common.R`, um por tarefa, escrevendo para `diagnostics/output/`
como `t<tarefa>_<item>_*.csv`. Já existem dois documentos de leitura corrida
que este README **não substitui**: `00_pipeline_map.md` (linhagem de dados,
bruto → gráfico) e `diagnostico_dfm.md` (o veredito por tarefa, é o
entregável). O que falta é um catálogo de "o que cada script faz" — é isso
que este arquivo cobre.

## Scripts

| script | tarefa | o que faz |
|---|---|---|
| `_common.R` | infraestrutura | Carregado por todo `0X_*.R`: importa 5 módulos de produção de `R/`, lê `data/raw/raw_data.csv` e o painel deseasonalizado em `PANEL`, lê `data/processed/instrumentos_mensais.csv`, e carrega o cache `output/irf/irf_coherence_cell.rds` em `CELL` (se existir). Define `SPEC` (a especificação de produção) e os helpers `diag_write()`/`md_tbl()` usados por todos os scripts abaixo. |
| `01_exogeneidade.R` | 1 | Testa exogeneidade do instrumento: regressões de previsibilidade global/por-fator, autocorrelação, correlações cruzadas com placebos, e o teste decisivo de que `commodity_metal` é artefato de denominação (BRL), não falha de exogeneidade. |
| `02_unidades_sinal.R` | 2 | Checa unidades/normalização/sinal: reconstrói a tabela de IRF completa das 111 variáveis e compara IRF em h0 com correlações contemporâneas cruas no bloco de juros. |
| `03_composicao_painel.R` | 3 | Audita a composição do painel: `juros_selic` vs. `juros_cdi`, pares quase-duplicados (\|cor\|>0,98), tamanho de bloco/colinearidade interna, e reestima o DFM sem os duplicados para checar sensibilidade de IRF/força do instrumento. |
| `04_forca_instrumento.R` | 4 | Documenta a inferência sob instrumento fraco: o que é o "Wald=12", onde cai contra os limiares de bolso, checagens de robustez anteriores, e sinaliza explicitamente que a inversão Anderson-Rubin **fica fora do escopo** desta rodada (adiada, não improvisada). |
| `05_persistencia_fatores.R` | 5 | Examina dinâmica/persistência dos fatores: autovalores da companion matrix, decaimento/largura de banda, seleção de ordem de defasagem, testes de raiz unitária (ADF/KPSS), R² de componente comum por série. Reestima o DFM (não lê `CELL`). |
| `06_bloco_ativos.R` | 6 | Testa a hipótese H2 do bloco de ativos: trunca IRFs em h=12 para checar se a incoerência de longo horizonte na seção cruzada desaparece (desaparece). Só usa o cache `CELL`, sem reestimar. Documenta o item 6.3 (juro real/NTN-B) como não-executável; as colunas vazias e o downloader ANBIMA saíram do fluxo ativo. |
| `07_dominancia_fiscal.R` | 7 | Testa dominância fiscal estado-dependente via LP-IV com interação completa (Ramey-Zubairy 2018) — fora do DFM, não toca código de estimação nem inicia download. A DBGG vem do painel de produção; o script valida o baseline, constrói regimes, estima IRFs estado-dependentes, executa testes h-a-h e conjuntos com bootstrap e compara EMBI a CDS. |

## `diagnostics/output/` por tarefa

58 CSVs no total, flat (sem subpastas — decisão de 2026-08-01: a Tarefa 7
sozinha teria 22 arquivos, mas o prefixo `t<N>_` já filtra bem por
glob/grep).

| tarefa | nº arquivos | tema |
|---|---|---|
| t1 | 8 | Exogeneidade do instrumento |
| t2 | 4 | Unidades/sinal |
| t3 | 6 | Composição do painel |
| t4 | 5 | Estatísticas de instrumento fraco |
| t5 | 6 | Dinâmica/persistência dos fatores |
| t6 | 7 | Bloco de ativos (H2) |
| t7 | 22 | Dominância fiscal / dependência de estado |

Não existem arquivos `t0_*` (a Tarefa 0 é só o `00_pipeline_map.md`, sem
saída tabular) nem `t8_*` (a sensibilidade de r,q não foi pedida nesta
rodada — ver `diagnostico_dfm.md`).

## Leitura corrida

- `00_pipeline_map.md` — rastreia dado bruto → gráfico em 8 seções.
- `diagnostico_dfm.md` — o entregável: veredito por tarefa, hipóteses de
  causa-raiz, e o que sobrevive para o paper hoje.
- `rq_block_dimension_audit/` — auditoria conjunta histórica de 2026-08-13:
  64 painéis, 2.304 células full, uma decisão dimensional por painel, 192
  contrastes de bloco e quatro finalistas com 800 bootstraps. A recomendação de
  123 séries em `(4,3)` foi superada pela produção de 111 séries `(5,5)`.
- `rq_dimension_audit/` — auditoria dimensional anterior, agora superada como
  decisão. Sua reprodução R/NumPy e os dez bootstraps continuam sendo
  proveniência válida para o painel de 106 séries.
