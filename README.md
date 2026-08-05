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
CLAUDE.md, HANDOFF.md, .gitignore, tex.zip     — arquivos soltos na raiz
README.md                                       — este arquivo
_instrucoes/        — docs vivos do projeto (o que está aberto, decisões)
R/                   — módulos reutilizáveis, source()ados por script/
script/              — pipeline ordenado + scripts de diagnóstico/robustez
diagnostics/         — a rodada de auditoria DFM-IV de 2026-07-28
output/              — artefatos de estimação (git-tracked)
data/                — dados brutos/processados (gitignored)
relatorio/           — roadmap do paper, council reviews, working-notes
texto_anpec/         — o paper canônico (LaTeX, elsarticle, submissão ANPEC)
artigos/             — literatura citada (PDF + extração)
codigos_externos/    — código de referência de outros autores (read-only)
arquivo/             — código/docs fora do pipeline ativo (histórico)
```

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

- **`data_download/`** (7 arquivos) — os downloaders: `bcb.R` (séries SGS do
  Banco Central), `exchange.R` (câmbio), `external_factors.R` (SP500/VIX/Brent
  + BRL/USD diário), `ibov_daily.R`, `anbima_breakeven.R`, `focus_fred.R`
  (medianas do Focus + UST 2y do FRED), `download_di.py` (futuros de DI).
- **`preprocessing/`** (1 arquivo) — `seasonality.R`, o wrapper de ajuste
  sazonal X-13 usado por `script/clean.R`.
- **`modeling/`** (3 arquivos) — os motores de estimação: `factor_estimation.R`
  (estimação BLL do DFM, seleção de r/q), `impulse_responde.R` (núcleo de
  IRF/identificação: `sel_ext_inst_sample`, `ident_ext_instr`,
  `compute_irf_dfm`, `compute_factor_space_wald`) e `var_proxy.R` (motor do
  benchmark VAR pequeno, extraído de `script/model_var.R`). O órfão
  `svensson_model.R` foi para `arquivo/R/modeling/` em 2026-08-05.
- **`identification/`** (7 arquivos) — a máquina de identificação além do
  proxy-SVAR básico: `spec_sweep.R`, `validation_tests.R`,
  `factor_space_diagnostics.R`, `irf_coherence.R` (pontuação de coerência
  teórica), e o ramo não-gaussiano (`nongaussian_gmr.R`, `nongaussian_branch.R`,
  `nongaussian_labelling.R` — só diagnóstico, não usado no caminho de
  produção).
- **`instrument/`** (2 arquivos) — `build_variants.R` (a cadeia de construção
  das 8 variantes de instrumento GK/JK/BS; eram 10 até 2026-08-05) e
  `di_surprise.R` (helper de surpresa de futuro de DI).

## `output/` — artefatos de estimação (git-tracked, ~3 MB)

Tudo aqui é da rodada de produção de 2026-07-24 em diante. Ver "Data layout"
no `CLAUDE.md` para os nomes de arquivo exatos dentro de cada subpasta.

- **`irf/`** — a rodada de coerência (`irf_coherence_*`, fonte de todo número
  em `irf_section.md`/§5 do paper) e os artefatos do sweep de especificação
  (`spec_sweep_*`, `irf_spec_*`).
- **`instrument/`** — réguas de força do instrumento (`mosw_strength_grid`,
  `instrument_diagnostics_report`, `instrument_construction_sweep`,
  `jk_sovereign_confound`).
- **`factors/`** — rodada de estacionariedade/cointegração/espectro da
  companion matrix dos fatores (2026-07-31).
- **`var/`** — o benchmark de VAR pequeno (2026-07-31).
- **`assets/`** — o teste de representação do bloco de ações (2026-07-31).
- **`nongaussian/`** — a identificação GMR (2017): gate, rodada de produção,
  corroboração contra o proxy, rotulagem da coluna monetária.
- **`validation/`** — artefatos de replicação Olea-Stock-Watson (Kilian-oil,
  aplicação de imposto), usados para validar o código do Wald ξ_mp.
- **`logs/`** (gitignored) — logs de execução por estágio do `run_all.R`.

## `data/` (gitignored)

Dados brutos/processados, não versionados. Um nível: `raw_data.csv`,
`raw_data_30.csv`, `di.csv` (DI futuro diário, 32 MB), `copom_historico.csv`,
`fred_dgs2.csv` na raiz; `processed/` (séries limpas/derivadas, incl. as
variantes de instrumento); `yields/` (curva de juros fornecida pelo
orientador, `yields_dia.csv` — entrada externa fixa, sem produtor no
repositório); `curva_juros/`, `investing/`, `epu/`,
`banco_central_rep_dominicana/` (downloads brutos por fonte).

## `_instrucoes/` — docs vivos do projeto

- **`Instrumento.md`** — design corrente da construção do instrumento
  externo (variante, vértice, esquema de agregação).
- **`pendencias.md`** — só o que está aberto, organizado por tema A-E, cada
  um com um apêndice comprimido dos itens fechados.
- **`historico_decisoes.md`** — resultados negativos e decisões revertidas
  (ex.: a identificação por heterocedasticidade abandonada, os achados do
  GMR não-gaussiano) — ler antes de propor uma nova direção metodológica.
- **`justificativa_uso_yield-6m.md`** — nota curta justificando normalizar o
  choque no yield de 6 meses em vez da Selic.

## `relatorio/`

- **`estrutura_paper_v2.md`** — roadmap seção-a-seção do paper, mapeando
  cada subseção ao artefato de `output/` que a alimenta.
- **`council_2026-07-31.md`** — revisão de 3 críticos externos ("council")
  sobre o então `tex/main.tex` (hoje `arquivo/tex/main.tex`), com cabeçalho
  de status indicando o que já foi resolvido.
- **`2026-07-15_relatorio_auditoria_fidelidade_instrumento.md`** — a auditoria
  de fidelidade do instrumento (filtro JK / purificação BS) que motivou a
  troca para `z_jk_bs_purif`.
- **`working-notes/`** — ~20 notas de pesquisa datadas; cada uma carrega um
  veredito (CURRENT / superseded / contradicted) e a especificação/vintage
  sob a qual foi escrita. **Não catalogadas aqui uma a uma** — ver
  `relatorio/working-notes/_indice.md`, que é a lista viva.

## `texto_anpec/`

O paper canônico desde **2026-08-02** (`paper_anpec.tex`, classe
`elsarticle`, submissão ANPEC, título "Uncovered Interest Parity,
Inverted..."). Abstract e §4 Resultados (seis subseções: estrutura a termo,
câmbio e risco soberano, atividade, crédito, preços, ações) estão correntes
com a rodada de produção. **Ainda não tem `§5 Robustez`** — essa seção só
existe no draft arquivado (ver abaixo) e precisa ser portada/reescrita aqui;
é o item aberto que fecha a diferença entre "canônico" e "completo". Desde
2026-08-05 `script/fig_section5.R` gera as **8** figuras direto aqui
(`texto_anpec/fig_*.pdf`, nomes nus, que é como o `.tex` as inclui): o §4 usa
6, e `fig_estado`/`fig_placebos` ficam prontas para o port do §5.

O draft abntex2 anterior (`main.tex`, "Choques monetários nos preços dos
ativos") foi **arquivado em `arquivo/tex/`** nessa mesma data — não por
vintage ou bug, o conteúdo era corrente, mas porque `texto_anpec/` passou a
ser o documento de trabalho. Preservado porque sua `§5 Robustez` é a prosa
mais completa de robustez que existe no repositório; ver
`arquivo/README.md`.

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
