# Índice do projeto

Mapa de navegação do repositório: o que cada diretório/arquivo faz, em 1-3
frases. Isto **não substitui** o `AGENTS.md` (acordos de trabalho e
invariantes), o `CLAUDE.md` (pipeline e comandos) nem os READMEs locais mais
detalhados; este índice aponta para eles em vez de duplicá-los.

## Visão geral

Paper independente replicando Alessi & Kerssenfischer (2019) para o Brasil:
um DFM (Dynamic Factor Model) não-estacionário de larga escala, identificação
de choques de política monetária por instrumento externo (surpresas de DI
futuro em dia de Copom), e IRFs de preços de ativos brasileiros. Ver
`CLAUDE.md` para o pipeline completo e os comandos de cada estágio.

## Árvore de 1º nível

```
AGENTS.md            — regras de trabalho, limites do repositório e invariantes
CLAUDE.md            — invariantes, entry points, proibições (fonte operacional)
HANDOFF.md           — estado corrente ao fim da última sessão
README.md            — este arquivo
registro/            — a memória do projeto: o decidido, o aberto, o morto
notas/               — registro probatório: nota datada por rodada, com vintage
progress_logs/       — continuidade de sessão (efêmero, descartável)
pareceres/           — o que foi recebido: /council, /referee2, /auditor-externo
email/               — troca de email com o orientador sobre o projeto
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
| quais regras seguir ao alterar o repositório | `AGENTS.md` |
| por que a especificação é essa | `registro/metodo.md` |
| o que falta fazer | `registro/pendencias.md` |
| se um caminho já foi tentado | `registro/historico_decisoes.md` |
| o número que sustenta uma frase do paper | `notas/_indice.md` → a nota datada |
| o que um revisor externo apontou | `pareceres/` |
| o que foi discutido por email com o orientador | `email/` |
| o que cada script faz | `script/README.md` |

## `script/`

O pipeline ordenado (download → clean → instrument → model) mais os
scripts de diagnóstico e robustez, orquestrado por `run_all.R`. São 16
scripts R ativos, mais 6 travas de validação em `script/validation/` — ver
**[`script/README.md`](script/README.md)** para o catálogo completo, arquivo
por arquivo.

## `diagnostics/`

A rodada de auditoria DFM-IV de 2026-07-28: 7 scripts numerados (`01`-`07`)
compartilhando `_common.R`, um por tarefa (exogeneidade, unidades/sinal,
composição do painel, força do instrumento, persistência dos fatores, bloco
de ativos, dominância fiscal), escrevendo 58 CSVs em `diagnostics/output/`.
Ver **[`diagnostics/README.md`](diagnostics/README.md)** para o catálogo por
script e por tarefa, e `diagnostics/diagnostico_dfm.md` para o veredito.

## `R/` — módulos reutilizáveis

Nunca importado por `script/` na direção contrária (nada em `R/` faz
`source()` de `script/`).

- **`data_download/`** (8 arquivos) — funções sem execução automática:
  `bcb.R` (SGS), `exchange.R` (câmbio), `external_factors.R` (Yahoo),
  `focus.R` (Focus/Olinda), `fred.R` (FRED), `b3.R` (índices B3), `fomc.R`
  (calendário do Fed) e `ipea.R` (Ipeadata). O único entry point que chama
  essas funções e grava dados é `script/download.R`.
- **`preprocessing/`** (2 arquivos) — `seasonality.R`, o wrapper de ajuste
  sazonal X-13, e `experimental_extensions.R`, que reconstrói os painéis
  experimentais históricos a partir das sete séries já processadas e de 12
  extensões locais que não pertencem ao download de produção.
- **`modeling/`** (6 arquivos) — `production_spec.R`, a especificação única do
  painel de 115 séries `(5,5,4)`, 2012-03--2025-12; `dfm_pipeline.R`, a
  composição do fluxo
  estimativo; e os motores `factor_estimation.R`
  (estimação BLL do DFM, seleção de r/q), `factor_selection.R` (ER/GR de
  Ahn-Horenstein e ABC, estimadores alternativos de r usados só como
  diagnóstico), `impulse_response.R` (núcleo de
  IRF/identificação: `sel_ext_inst_sample`, `ident_ext_instr`,
  `compute_irf_dfm`, `compute_factor_space_wald`) e `var_proxy.R` (motor do
  benchmark VAR pequeno observável, com as traduções de `RForm_VAR.m` e
  `bicaic.m` de Montiel Olea et al.). O órfão
  `svensson_model.R` foi para `arquivo/R/modeling/` em 2026-08-05.
- **`identification/`** — a máquina de diagnóstico em torno do proxy-SVAR:
  `spec_sweep.R`, `factor_space_diagnostics.R`,
  `irf_coherence.R` (pontuação de coerência teórica), `experimental_panel.R` e
  `weak_iv_ar.R` (MA, SVAR-IV, covariância e inversão AR, somente para VAR de
  observáveis).
  Os ramos het e não-gaussiano saíram do código ativo em 2026-08-17. O código
  dedicado à heterocedasticidade foi removido em 2026-09-01; seus artefatos e
  vereditos permanecem em `arquivo/heterocedasticidade/`. Em 2026-09-17,
  `validation_tests.R`, que não tinha chamador, e as funções que só scripts
  arquivados usavam foram para `arquivo/R/`. Em 2026-09-18 o wild bootstrap e
  a correção de Kilian saíram de `modeling/`: a inferência do DFM são os
  conjuntos Anderson-Rubin de `identification/weak_iv_ar.R`.
- **`instrument/`** (2 arquivos) — `build_variants.R` (a cadeia de construção
  das 8 variantes de instrumento GK/JK/BS; eram 10 até 2026-08-05) e
  `di_surprise.R` (helper de surpresa de futuro de DI, mais os carregadores de
  datas de Copom e de FOMC). `event_tests.R`, a inferência das regressões
  diárias de evento, foi para `arquivo/R/instrument/` em 2026-09-18 com seu
  último consumidor, `fomc_coincidence.R`.
- **`reporting/`** (1 arquivo) — `markdown_report.R`, com formatação estável
  para tabelas e números dos relatórios Markdown gerados.

## `output/` — artefatos de estimação versionados

Tudo aqui é da rodada de produção de 2026-08-13 em diante, salvo artefatos
explicitamente marcados como históricos. Ver "Data layout"
no `CLAUDE.md` para os nomes de arquivo exatos dentro de cada subpasta.

- **`irf/`** — a rodada de coerência (`irf_coherence_*`, fonte de todo número
  em §5 do paper), a rodada de inferência (`ar_bands_*`, que documenta a troca
  de 2026-09-08 do wild bootstrap pelos conjuntos Anderson-Rubin; o script está
  em `arquivo/script/` desde 2026-09-18) e os
  artefatos do sweep de especificação (`spec_sweep_*`, `irf_spec_*`).
  `irf_section.md` é anterior à troca e carrega banner dizendo isso.
- **`instrument/`** — réguas de força do instrumento (`mosw_strength_grid`,
  `instrument_diagnostics_report`, `instrument_construction_sweep`,
  `jk_sovereign_confound`, `fomc_coincidence`).
- **`factors/`** — estacionariedade, cointegração e espectro da companion
  matrix dos fatores (2026-07-31); as varreduras de `p` e de `q` e as
  narrativas `q_narrative_*`; a seleção de `r` por estimadores alternativos
  e no painel podado e o truncamento `q < r` (`q_truncation_*`), de
  2026-09-10; e a volatilidade COVID de Lenza-Primiceri (2026-09-14): θ̂ e a
  trajetória de `s_t` (`covid_volatility_*`), a célula `cheia_p4_lp` dentro
  de `q_truncation_*` e a narrativa tratada `q_narrative_r5p4_covid.*`.
- **`var/`** — o benchmark VAR em níveis e sua inferência AR corrente
  (2026-08-22): cinco séries, constante e tendência linear, AIC e BIC em
  amostra comum, `p=2` pelo AIC, NW(0) e respostas `C_h B_1`.
- **`assets/`** — o teste de representação do bloco de ações (2026-07-31).
- **`panel/`** — censo e diagnósticos de composição, além do manifesto das
  sete séries adicionadas ao painel de produção.
- **`panel_experimental/`** — artefatos históricos das extensões, das grades
  `(r,q)` e das remoções fatoriais de blocos; não alimenta a produção.
- **`validation/`** — artefatos de replicação Olea-Stock-Watson (Kilian-oil,
  aplicação de imposto), usados para validar o Wald ξ_mp e o kernel HAC. O
  `.rds` do petróleo existe porque `codigos_externos/` é gitignorado: sem ele
  `script/validation/validate_olea_kilian.R` não rodaria num clone limpo.
- **`download/`** — inventário e relatório histórico da coleta isolada de
  séries feita em 2026-08-13; não é entrada da estimação corrente.
- **`logs/`** (gitignored) — logs de execução por estágio do `run_all.R`.

## `data/` (gitignored)

Não versionados, dois níveis: **`raw/`** é o que sai do download, sem
tratamento e nunca editado à mão; **`processed/`** é o que entra na estimação
(séries limpas/derivadas, incl. as variantes de instrumento).

Em `raw/`: `raw_data.csv` (106 séries históricas mais as sete adições de
produção), `raw_data_30.csv`, `di.csv` (DI futuro
diário, entrada externa fixa de 32 MB), `copom_historico.csv`,
`focus_daily.csv`, `ibov_daily.csv`, `brl_usd_daily.csv`, `fred_dgs2.csv`,
`CDS 5y.xlsx` (CDS soberano
5a diário, export Bloomberg — entrada externa fixa, como a curva; lido por
`arquivo/script/jk_sovereign_confound.R`, sem consumidor vivo desde 2026-09-17), `fomc_dates.csv` (datas de decisão do FOMC;
**produzido** por `script/download.R`, e requisito duro do estágio
`instrument` desde 2026-08-10); mais `yields/` (curva de juros fornecida pelo
orientador, `yields_dia.csv` — entrada externa fixa, sem produtor no
repositório) e `curva_juros/`, `investing/`, `epu/`,
`banco_central_rep_dominicana/` (downloads brutos por fonte). O painel
processado retém 115 séries porque `clean.R` remove `juros_cdi` e
`asset_mlcx`. As extensões
rejeitadas que sustentam diagnósticos antigos vivem, quando disponíveis,
em `experimental_extensions/`; o download de produção não as cria.

## `registro/` — a memória do projeto

Editado in place: quando a especificação muda, o corpo muda. O que morreu não
fica riscado aqui, vai para `historico_decisoes.md`.

- **`metodo.md`** — o desenho vivo: construção do instrumento externo
  (variante, vértice, esquema de agregação) e a cadeia de identificação.
- **`pendencias.md`** — só o que está aberto, organizado por tema A-E, cada
  um com um apêndice comprimido dos itens fechados.
- **`historico_decisoes.md`** — resultados negativos e decisões revertidas
  (ex.: as duas identificações abandonadas — heterocedasticidade e
  momentos/GMR) — ler antes de propor uma nova direção metodológica.
- **`justificativa_uso_yield-6m.md`** — nota curta justificando normalizar o
  choque no yield de 6 meses em vez da Selic.
- **`estrutura_paper_v2.md`** — roadmap seção-a-seção do paper, mapeando
  cada subseção ao artefato de `output/` que a alimenta.

## `notas/` — o registro probatório

64 notas de pesquisa datadas, append-only: uma rodada por nota, com um
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

## `email/` — troca com o orientador

A correspondência por email com o orientador sobre o projeto, mantida como
chegou/foi enviada. Nome: `email_{meu,professor}_DD-MM_HHhMM.md`, um arquivo
por mensagem, em ordem cronológica pelo nome do arquivo. Diferente de
`pareceres/` (revisão formal e pontual), aqui é a discussão corrente —
dúvidas, decisões de especificação e justificativas trocadas com o
orientador ao longo da pesquisa.

## `paper/`

O paper canônico desde **2026-08-02** (`paper_anpec.tex`, classe
`elsarticle`, submissão ANPEC, título "Uncovered Interest Parity,
Inverted...").

O arquivo foi integralmente sincronizado em 2026-08-25 com a produção de 111
séries `(r,q,p)=(5,5,4)`: resumo, introdução, metodologia, resultados,
robustez, conclusão e apêndice usam a mesma vintage. A `tab:rq_sweep` foi
removida. Anderson--Rubin aparece somente para o VAR observável, nunca para o
DFM; o título permanece enquanto a decomposição do wedge de UIP está aberta.

A **`§5 Robustez` tem cinco subseções** — `sec:exogeneidade`
(previsibilidade do instrumento mensal, Ljung-Box e placebos globais nas duas
bandas), `sec:invertibilidade` (diagnóstico de
invertibilidade fundamentado em Stock e Watson, 2018), `sec:weak_iv`
(conjuntos Anderson--Rubin no VAR de observáveis sob instrumento fraco),
`sec:confound` (o filtro de sinal seleciona risco soberano?, nas duas proxies
diárias e com a seleção de produção fixa) e `sec:fomc` (coincidência com
decisões do FOMC, também condicionada à seleção de produção). Por decisão
editorial, as duas últimas omitem a rederivação da máscara, preservada apenas
nos diagnósticos e registros. A conclusão
passou a ser a §6. Desde 2026-08-05
`script/fig_section5.R` gera as **10** figuras direto aqui
(`paper/fig_*.pdf`, nomes nus, que é como o `.tex` as inclui): o §4 usa
8, a §5 usa `fig_placebos`, e `fig_estado` segue sem consumidor.

O draft abntex2 anterior (`main.tex`, "Choques monetários nos preços dos
ativos") foi **arquivado em `arquivo/tex/`** nessa mesma data — não por
vintage ou bug, mas porque `paper/` passou a ser o documento de trabalho. É
apenas fonte histórica de prosa; nenhum caminho ativo o consome. Ver
`arquivo/README.md`.

## `artigos/` — literatura citada

37 subpastas, uma por referência ou conjunto de materiais (Alessi-Kerssenfischer,
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

Nada aqui é executado pelo pipeline de produção. As evidências das duas
estratégias abandonadas vivem em
**[`arquivo/heterocedasticidade/`](arquivo/heterocedasticidade/README.md)** e
**[`arquivo/nao_gaussiana/`](arquivo/nao_gaussiana/README.md)**. Na primeira,
o código dedicado foi removido em 2026-09-01 depois que o resultado negativo
entrou no paper; os CSVs, a nota e o veredito foram preservados. O resto — scripts órfãos superados, a investigação de
contaminação de IRF de 2026-07-15/16, os 25 scripts de rodadas fechadas
arquivados em 2026-09-17, o draft anterior em `tex/` — está no
inventário de **[`arquivo/README.md`](arquivo/README.md)**. As saídas desses
scripts continuam em `output/`.

## Arquivos soltos na raiz

- **`AGENTS.md`** — acordos de trabalho, invariantes da especificação e
  limites entre código, dados, registros e artefatos.
- **`CLAUDE.md`** — a fonte de verdade operacional: pipeline, comandos,
  núcleo de identificação, convenções, layout de dados.
- **`HANDOFF.md`** (privado) — log de handoff entre sessões.
- **`.gitignore`** — exclui `data/`, `output/logs/`, os 4 diretórios
  `codigo_*`/`codigos_externos/`, artefatos de build do LaTeX, e `tex.zip`.
- **`tex.zip`** (gitignored) — snapshot de build do então `tex/` (hoje
  `arquivo/tex/`) de 2026-07-28, derivado e stale.
