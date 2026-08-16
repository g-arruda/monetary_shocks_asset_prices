# Índice do projeto

Mapa de navegação do repositório: o que cada diretório/arquivo faz, em 1-3
frases. Isto **não substitui** o `CLAUDE.md` (que é a fonte de verdade
operacional — pipeline, comandos, decisões metodológicas e por que cada
coisa é como é) nem os READMEs locais mais detalhados; este índice aponta
para eles em vez de duplicá-los.

## Visão geral

Paper independente replicando Alessi & Kerssenfischer (2019) para o Brasil:
um DFM (Dynamic Factor Model) não-estacionário de larga escala, identificação
de choques de política monetária por instrumento externo (surpresas de DI
futuro em dia de Copom), e IRFs de preços de ativos brasileiros. Ver
`CLAUDE.md` para o pipeline completo e os comandos de cada estágio.

## Árvore de 1º nível

```
CLAUDE.md            — invariantes, entry points, proibições (fonte operacional)
HANDOFF.md           — estado corrente ao fim da última sessão
README.md            — este arquivo
registro/            — a memória do projeto: o decidido, o aberto, o morto
notas/               — registro probatório: nota datada por rodada, com vintage
progress_logs/       — continuidade de sessão (efêmero, descartável)
pareceres/           — o que foi recebido: /council, /referee2, /auditor-externo
R/                   — módulos reutilizáveis, source()ados por script/
script/              — pipeline ordenado + scripts de diagnóstico/robustez
diagnostics/         — a rodada de auditoria DFM-IV de 2026-07-28
data/                — raw/ e processed/ (gitignored)
output/              — artefatos de estimação, por domínio (git-tracked; logs/ não)
artigos/             — literatura citada (PDF + extração do /split-pdf-md)
paper/  slides/      — LaTeX (elsarticle, submissão ANPEC) e Beamer
codigos_externos/    — código de referência de outros autores (gitignored, read-only)
arquivo/             — código/docs fora do pipeline ativo; nada vivo lê ou escreve aqui
```

## Onde procurar o quê

| procuro... | está em |
|---|---|
| por que a especificação é essa | `registro/metodo.md` |
| o que falta fazer | `registro/pendencias.md` |
| se um caminho já foi tentado | `registro/historico_decisoes.md` |
| o número que sustenta uma frase do paper | `notas/_indice.md` → a nota datada |
| o que um revisor externo apontou | `pareceres/` |
| o que cada script faz | `script/README.md` |

## `script/`

O pipeline ordenado (download → clean → instrument → estimate) mais ~20
scripts de diagnóstico/robustez/sweep, orquestrado por `run_all.R`. 25
arquivos ativos, organizados em 7 grupos temáticos — ver
**[`script/README.md`](script/README.md)** para o catálogo completo, arquivo
por arquivo.

## `diagnostics/`

A rodada de auditoria DFM-IV de 2026-07-28: 7 scripts numerados (`01`-`07`)
compartilhando `_common.R`, um por tarefa (exogeneidade, unidades/sinal,
composição do painel, força do instrumento, persistência dos fatores, bloco
de ativos, dominância fiscal), escrevendo 57 CSVs em `diagnostics/output/`.
Ver **[`diagnostics/README.md`](diagnostics/README.md)** para o catálogo por
script e por tarefa, e `diagnostics/diagnostico_dfm.md` para o veredito.

## `R/` — módulos reutilizáveis

Nunca importado por `script/` na direção contrária (nada em `R/` faz
`source()` de `script/`).

- **`data_download/`** (9 arquivos) — os downloaders: `bcb.R` (séries SGS do
  Banco Central), `exchange.R` (câmbio), `external_factors.R` (SP500/VIX/Brent
  + BRL/USD diário), `ibov_daily.R`, `anbima_breakeven.R`, `focus_fred.R`
  (medianas do Focus + UST 2y do FRED), `fomc_dates.R` (datas de decisão do
  FOMC, raspadas das páginas de calendário do Fed — 2026-08-10),
  `download_di.py` (futuros de DI), e `panel_candidates.R` (inventário,
  metadados, coleta e validação isolada das candidatas de 2026-08-13).
- **`preprocessing/`** (2 arquivos) — `seasonality.R`, o wrapper de ajuste
  sazonal X-13, e `panel_candidates.R`, a preparação reutilizável das séries
  candidatas usada por `script/clean.R` e pelas auditorias históricas.
- **`modeling/`** (4 arquivos) — `production_spec.R`, a especificação única do
  painel de 111 séries `(5,5,6)`, e os motores `factor_estimation.R`
  (estimação BLL do DFM, seleção de r/q), `impulse_responde.R` (núcleo de
  IRF/identificação: `sel_ext_inst_sample`, `ident_ext_instr`,
  `compute_irf_dfm`, `compute_factor_space_wald`) e `var_proxy.R` (motor do
  benchmark VAR pequeno, extraído de `script/model_var.R`). O órfão
  `svensson_model.R` foi para `arquivo/R/modeling/` em 2026-08-05.
- **`identification/`** — a máquina de identificação além do
  proxy-SVAR básico: `spec_sweep.R`, `validation_tests.R`,
  `factor_space_diagnostics.R`, `irf_coherence.R` (pontuação de coerência
  teórica) e o ramo não-gaussiano (`nongaussian_gmr.R`,
  `nongaussian_branch.R`, `nongaussian_labelling.R` — só diagnóstico, não usado
  no caminho de produção).
- **`instrument/`** (3 arquivos) — `build_variants.R` (a cadeia de construção
  das 8 variantes de instrumento GK/JK/BS; eram 10 até 2026-08-05),
  `di_surprise.R` (helper de surpresa de futuro de DI, mais os carregadores de
  datas de Copom e de FOMC) e `event_tests.R` (inferência das regressões
  diárias de janela de evento: `wild_coef_test` e `wild_wald_test`, ambos com
  wild bootstrap sob a nula restrita e semente por célula).

## `output/` — artefatos de estimação (git-tracked, ~3 MB)

Tudo aqui é da rodada de produção de 2026-08-13 em diante, salvo artefatos
explicitamente marcados como históricos. Ver "Data layout"
no `CLAUDE.md` para os nomes de arquivo exatos dentro de cada subpasta.

- **`irf/`** — a rodada de coerência (`irf_coherence_*`, fonte de todo número
  em `irf_section.md`/§5 do paper) e os artefatos do sweep de especificação
  (`spec_sweep_*`, `irf_spec_*`).
- **`instrument/`** — réguas de força do instrumento (`mosw_strength_grid`,
  `instrument_diagnostics_report`, `instrument_construction_sweep`,
  `jk_sovereign_confound`, `fomc_coincidence`).
- **`factors/`** — rodada de estacionariedade/cointegração/espectro da
  companion matrix dos fatores (2026-07-31).
- **`var/`** — o benchmark de VAR pequeno (2026-07-31).
- **`assets/`** — o teste de representação do bloco de ações (2026-07-31).
- **`nongaussian/`** — a identificação GMR (2017): gate, rodada de produção,
  corroboração contra o proxy, rotulagem da coluna monetária.
- **`validation/`** — artefatos de replicação Olea-Stock-Watson (Kilian-oil,
  aplicação de imposto), usados para validar o Wald ξ_mp e o kernel HAC. O
  `.rds` do petróleo existe porque `codigos_externos/` é gitignorado: sem ele
  `validate_olea_kilian.R` não rodaria num clone limpo.
- **`download/`** — inventário e relatório de proveniência das séries candidatas
  coletadas isoladamente; não é entrada da estimação.
- **`logs/`** (gitignored) — logs de execução por estágio do `run_all.R`.

## `data/` (gitignored)

Não versionados, dois níveis: **`raw/`** é o que sai do download, sem
tratamento e nunca editado à mão; **`processed/`** é o que entra na estimação
(séries limpas/derivadas, incl. as variantes de instrumento).

Em `raw/`: `raw_data.csv`, `raw_data_30.csv`, `di.csv` (DI futuro diário,
32 MB), `copom_historico.csv`, `fred_dgs2.csv`, `CDS 5y.xlsx` (CDS soberano
5a diário, export Bloomberg — entrada externa fixa, como a curva; lido por
`jk_sovereign_confound.R`), `fomc_dates.csv` (datas de decisão do FOMC;
**produzido** por `R/data_download/fomc_dates.R`, e requisito duro do estágio
`instrument` desde 2026-08-10); mais `yields/` (curva de juros fornecida pelo
orientador, `yields_dia.csv` — entrada externa fixa, sem produtor no
repositório) e `curva_juros/`, `investing/`, `epu/`,
`banco_central_rep_dominicana/` (downloads brutos por fonte), além de
`panel_candidates/` (17 séries mensais isoladas, nunca incorporadas a
`raw_data.csv`).

## `registro/` — a memória do projeto

Editado in place: quando a especificação muda, o corpo muda. O que morreu não
fica riscado aqui, vai para `historico_decisoes.md`.

- **`metodo.md`** — o desenho vivo: construção do instrumento externo
  (variante, vértice, esquema de agregação) e a cadeia de identificação.
- **`pendencias.md`** — só o que está aberto, organizado por tema A-E, cada
  um com um apêndice comprimido dos itens fechados.
- **`historico_decisoes.md`** — resultados negativos e decisões revertidas
  (ex.: a identificação por heterocedasticidade abandonada, os achados do
  GMR não-gaussiano) — ler antes de propor uma nova direção metodológica.
- **`justificativa_uso_yield-6m.md`** — nota curta justificando normalizar o
  choque no yield de 6 meses em vez da Selic.
- **`estrutura_paper_v2.md`** — roadmap seção-a-seção do paper, mapeando
  cada subseção ao artefato de `output/` que a alimenta.

## `notas/` — o registro probatório

~25 notas de pesquisa datadas, append-only: uma rodada por nota, com um
banner de veredito (CURRENT / superseded / contradicted) e a
especificação/vintage sob a qual foi escrita. É delas que o paper puxa
número — **confira o vintage antes de citar**. **Não catalogadas aqui uma a
uma** — ver `notas/_indice.md`, que é a lista viva.

`progress_logs/` é a outra metade da distinção: continuidade de sessão,
efêmero, descartável. Nada durável entra ali, e nenhum log de sessão entra em
`notas/`.

## `pareceres/` — o que foi recebido

Documentos de fora, mantidos como chegaram:

- **`council_2026-07-31.md`** e **`council_2026-08-10.md`** — revisões de
  críticos externos ("council"), com cabeçalho de status indicando o que já
  foi resolvido.
- **`2026-07-15_auditoria_fidelidade_instrumento.md`** — a auditoria
  de fidelidade do instrumento (filtro JK / purificação BS) que motivou a
  troca para `z_jk_bs_purif`.

## `paper/`

O paper canônico desde **2026-08-02** (`paper_anpec.tex`, classe
`elsarticle`, submissão ANPEC, título "Uncovered Interest Parity,
Inverted...").

⚠ **O arquivo está partido entre duas vintages desde 2026-08-14.** A §3, a §5 e
a `tab:lista_variaveis` do apêndice falam da produção de 111 séries `(5,5)`; o
resumo, a §1, a §2, a §4 (seis subseções: estrutura a termo, câmbio e risco
soberano, atividade, crédito, preços, ações) e a conclusão ainda falam de 106
séries em `(7,6)`. A `tab:rq_sweep` foi removida e Anderson-Rubin não é mais
mencionado. Checklist do que falta em `registro/pendencias.md`, Tema A.

A **`§5 Robustez` existe desde 2026-08-09 com três
subseções** — `sec:exogeneidade` (previsibilidade do instrumento mensal,
Ljung-Box, `commodity_metal` em R$ contra US$, placebos nas duas barras) e
`sec:confound` (o filtro de sinal seleciona risco soberano?, nas duas proxies
diárias, com as três ressalvas no corpo), além de `sec:fomc` (coincidência com
decisões do FOMC e decomposição entre valores e máscara). Faltam as quatro
subseções da composição recomendada em
`notas/2026-08-01_tier_list_robustez.md` §7, entre elas
Limitações; a conclusão passou a ser a §6. Desde 2026-08-05
`script/fig_section5.R` gera as **8** figuras direto aqui
(`paper/fig_*.pdf`, nomes nus, que é como o `.tex` as inclui): o §4 usa
6, a §5 usa `fig_placebos`, e `fig_estado` segue sem consumidor.

O draft abntex2 anterior (`main.tex`, "Choques monetários nos preços dos
ativos") foi **arquivado em `arquivo/tex/`** nessa mesma data — não por
vintage ou bug, o conteúdo era corrente, mas porque `paper/` passou a
ser o documento de trabalho. Preservado porque sua `§5 Robustez` ainda é a
fonte de prosa para as subseções que `paper/` não tem — Limitações e
dependência de estado; exogeneidade e placebos já subiram, reescritos, em
2026-08-09. Ver `arquivo/README.md`.

## `artigos/` — literatura citada

24 subpastas, uma por referência citada (Alessi-Kerssenfischer,
Jarociński-Karadi, Bauer-Swanson, Montiel Olea-Stock-Watson, Gonçalves-Kilian
etc.). Cada uma tem o PDF original e uma extração em `.md` via `marker`, mais
figuras extraídas por página. Não catalogadas individualmente aqui.

## `codigos_externos/` — código de referência (read-only)

Não é código do projeto — tratado como referência para tradução, nunca
editado.

- **`codigo_alessi-mark/`** — o MATLAB original de Alessi-Kerssenfischer
  (DFM, VAR pequeno, identificação por instrumento externo).
- **`codigo_Jarocinski_e_Karadi/`** — o código do filtro de sinal "poor man's"
  que a máscara JK deste projeto traduz.
- **`codigo_bauer_swanson/`** — a ortogonalização pré-evento usada em
  `z_bs_purif`/`z_jk_bs_purif`.
- **`codigo_olea/`** — a suíte SVARIV oficial de Montiel Olea-Stock-Watson,
  alvo de validação do bloco Wald ξ_mp.

## `arquivo/` — código e docs fora do pipeline ativo

Nada aqui é executado pelo pipeline de produção nem citado pelo paper —
preservado em vez de apagado porque documenta resultados negativos e
decisões revertidas (o track de heterocedasticidade abandonado, scripts
órfãos superados, uma investigação de contaminação de IRF de 2026-07-15/16).
Ver **[`arquivo/README.md`](arquivo/README.md)** para o inventário completo.

## Arquivos soltos na raiz

- **`CLAUDE.md`** — a fonte de verdade operacional: pipeline, comandos,
  núcleo de identificação, convenções, layout de dados.
- **`HANDOFF.md`** (privado) — log de handoff entre sessões.
- **`.gitignore`** — exclui `data/`, `output/logs/`, os 4 diretórios
  `codigo_*`/`codigos_externos/`, artefatos de build do LaTeX, e `tex.zip`.
- **`tex.zip`** (gitignored) — snapshot de build do então `tex/` (hoje
  `arquivo/tex/`) de 2026-07-28, derivado e stale.
