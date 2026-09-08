# `arquivo/` — código e documentos fora do pipeline ativo

Criado em **2026-07-26**. Nada aqui é executado pelo pipeline de produção nem
citado pelo paper. O conteúdo foi preservado — em vez de apagado — porque
documenta **resultados negativos** e decisões revertidas que custaram trabalho e
que não estão registrados em nenhum outro lugar do repositório.

**Leia antes:** [`registro/historico_decisoes.md`](../registro/historico_decisoes.md)
explica *por que* cada bloco foi arquivado. Este README só diz *o que* está aqui.

> ⚠️ Nada aqui reproduz contra o painel atual. Todo este material é anterior ao
> **refresh de vintage de 2026-07-24** (106 séries) e/ou à **correção de tcode
> dos índices B3** da mesma data. Os artefatos de instrumento anteriores a
> 2026-05-07 também estão **100× fora de escala** por causa do bug de unit
> scaling do `yield_6m`. Trate os números como história, não como referência.

---

## `arquivo/script/` — scripts

### Track de heterocedasticidade (removido em 2026-09-01)

Os scripts e módulos exclusivamente dedicados à rota foram removidos depois da
reestimação final no painel de 115 séries. Os nomes e a função de cada arquivo
permanecem no histórico Git e em `arquivo/heterocedasticidade/README.md`; os
artefatos que sustentam o resultado negativo foram preservados.

### Órfãos (superados por scripts vivos)

| script | por que saiu |
|---|---|
| `instrument_grid.R` | Sweep vértice × amostra de purificação com só as 4 variantes legadas; anterior ao `z_jk_bs_purif` |

### Diagnóstico de contaminação de IRF (superado em 2026-07-24, arquivado em 2026-08-01)

Investigação de 2026-07-15/16 sobre por que um `ξ_mp > 0` ainda podia entregar
uma IRF contaminada. Ficou obsoleta com o refresh de vintage de 2026-07-24
(que resolveu o problema por uma causa não relacionada às hipóteses testadas
aqui) e não é citada em nenhum lugar do CLAUDE.md corrente. A nota-irmã já
estava marcada "superseded" em `notas/_indice.md`; dois
destes scripts citam `arquivo/_instrucoes/irf_consistentes.md`, que não existe mais.

| script | o que fazia |
|---|---|
| `irf_instrument_diag_sweep.R` | Grid de 6 instrumentos × 3 (r,q) × 2 amostras classificando contaminação de curva/núcleo/câmbio em cada célula contra a força MOSW |
| `irf_instrument_report.R` | Relatório por variável da resposta a 6 instrumentos × (r,q) × amostra, com bandas 68/90 |
| `irf_instrument_report_plots.R` | Regenerava os dois PDFs de `irf_instrument_report.R` a partir do CSV de caminhos em cache, sem re-bootstrap |
| `irf_rq_candidates.R` | Estimava 5 pares (r,q) candidatos e pontuava 10 variáveis-chave contra a tabela de coerência; recomendou (7,6), que virou produção por um motivo não relacionado (o refresh de vintage) |
| `irf_sample_diagnostic.R` | Testava se a contaminação vinha da janela COVID ou de rotação espectral, com 5 células fixas incl. o "benchmark exato dos autores" (r=q=8) |

### Régua legada `f_factor` (superada em 2026-07-26, arquivada em 2026-08-05)

| script | o que fazia | por que saiu |
|---|---|---|
| `diagnose_factor_space_F.R` | Grid do max-F univariado sobre as q inovações de fator, `r=7,p=6` fixos, `q∈{2,3,4,6}` × 8 variantes. Escrevia `factor_space_F_grid.csv` | O `f_factor` **deixou de decidir** em 2026-07-26, quando a taxonomia migrou para ξ_mp (`classify_sweep_cells`); sob a régua antiga o instrumento de produção pontuava 6,31 e nunca alcançava uma célula "elegível", enquanto `z_jk_purif` pontuava 11,08 com ξ_mp 5,77 — exatamente a inversão que motivou a troca. A triagem de 2026-08-05 confirmou que ele não é dependência nem do `paper/` nem de nenhum item da tier list de robustez |

## `arquivo/R/modeling/` — módulos

| módulo | conteúdo | por que saiu |
|---|---|---|
| `svensson_model.R` | Ajuste de curva de Svensson (1994): `svensson_rate`, `fit_svensson`, `generate_fixed_maturity_series`, `svensson_forward_rate`, `summarize_svensson_fit`, `plot_svensson_fit`, `calculate_yield_spreads` (~600 linhas) | Órfão desde a deleção de `script/yield_curve.R` em 2026-07-26 — a curva de juros é insumo externo fixo do orientador (`data/raw/yields/yields_dia.csv`), não há estágio de ajuste no repositório. Zero consumidores em `script/`, `R/` ou `diagnostics/`. **Arquivado, não apagado**, porque é código de modelagem reutilizável: se a curva algum dia voltar a ser ajustada in-house, comece daqui. Fecha a pendência E5, que pedia exatamente esta decisão |

## `arquivo/R/identification/` — módulos

Os três módulos de heterocedasticidade foram removidos em 2026-09-01. Nenhum
caminho ativo fazia `source()` deles. O núcleo DFM permanece com o ramo único
`identification = "proxy"`.

## `arquivo/relatorio/` — notas e correspondência

| item | o que é |
|---|---|
| `2026-04-25_blindspot_het_instrument.md` | Ruling condicional sobre `z_het_jk`; chegou a propor reposicionar o paper em torno de identificação por variância |
| `2026-04-26_blindspot_validation.md` | Auditoria da suíte T1-T4; apontou que a F do JK fica *no* percentil 99 das máscaras aleatórias, não acima |
| `council_2026-05-05.md` | Painel de três críticos sobre o corpus `registro/` da época (*Major Revision*). Todo o veredito é sobre `z_het_jk`: falha de A2 em DI_2y, rank-1 imposto por asserção, e o F=21,3 medido contra a inovação AR(6) e não contra o primeiro estágio estrutural. As três exigências foram superadas pelos eventos — a het saiu do paper e a régua virou ξ_mp |
| `correspondence/referee2/` | Dois rounds de referee interno sobre o bloco het (round 1 *Minor Revisions*, round 2 *Accept*) + `replication/`, a réplica NumPy que batia em 6+ casas decimais |

O único achado **não-het** desse material já foi extraído para
`historico_decisoes.md` §4: janelas não-contíguas exigem residualização AR
full-sample **antes** do subset, senão outubro/2020 é regredido em
fevereiro/2020 sem que nada acuse o erro.

*Nota:* `correspondence/referee2/replication/referee2_replicate_het_shock.py`
tem um caminho quebrado desde que foi movido (`parents[2]` aponta para um
diretório inexistente). Não foi corrigido — o script não roda mais de qualquer
forma, já que os CSVs het de entrada foram apagados.

## `arquivo/output/`

| item | o que é |
|---|---|
| `irf_section_2026-07-12.md` | Versão anterior do §5, sob `z_jk_purif` × (6,5) e vintage antigo. É o único registro escrito daquela rodada. **Várias afirmações foram invertidas** pela rodada (7,6) — comparação em `historico_decisoes.md` §6 |
| `instrument_audit_report.md`, `instrument_audit_grid.csv` | Saídas históricas da auditoria de 2026-04-26, anteriores ao fix de unit scaling |
| `instrument_grid_report.md`, `instrument_grid.csv` | Saídas de `instrument_grid.R` (2026-04-26), só variantes legadas |
| `factor_space_F_grid.csv` | Saída de `diagnose_factor_space_F.R`, arquivada junto com ele em 2026-08-05. 8 variantes × q ∈ {2,3,4,6}, sendo 4 delas `z_het*` — régua legada, e metade do grid mede instrumentos que já não existem |

---

## `arquivo/tex/` — o paper (abntex2, arquivado 2026-08-02)

O draft abntex2 (`main.tex`, "Choques monetários nos preços dos ativos") que
foi o paper canônico até 2026-08-02, quando o autor decidiu que o rascunho
ANPEC (`paper/paper_anpec.tex`, classe `elsarticle`) passa a ser o
documento corrente. **Não superado por vintage ou por bug** — o conteúdo era
o corrente: §3 (Metodologia) em (7,6) e §4/§5 (Resultados/Robustez)
reescritas em 2026-07-30 sob a regra de leitura em duas camadas (90% =
*significativo*, 68% = direção e magnitude). Preservado porque **`§5
Robustez` não tem contrapartida ainda em `paper/`** — é a fonte de
prosa a reaproveitar até essa seção ser escrita no rascunho corrente, não um
alvo de edição ativo. `img/` guarda as 8 figuras citadas pelo texto, agora
como **registro histórico congelado**: em 2026-08-05 `script/fig_section5.R`
foi repontado para `paper/`, de modo que **nenhum código vivo escreve
mais dentro de `arquivo/`** — a invariante que o resto deste README já exigia
para `source()` agora vale também para escrita. Ver a entrada `arquivo/tex/`
em `CLAUDE.md` para o que cada seção chegou a cobrir.

## O que foi apagado (recuperável pelo git)

Não está aqui porque é **regenerável** pelos scripts acima ou porque não
reproduz mais no painel atual. Tudo estava versionado; use
`git log --diff-filter=D -- <caminho>` para achar o commit e `git show` para
recuperar.

- `output/validation/` (18 arquivos, suíte T1-T8 het)
- `output/het_primary/` (7 arquivos, gates de viabilidade)
- `output/instrument/het_*` (24 CSVs + `het_eigenvalues.png`)
- `output/benchmark/grg_benchmark.csv` (construído de bundles het)
- `output/irf/` do vintage antigo: bundles de 2026-05-08, `inst_diag_*`,
  `inst_report_*`, `irf_sample_diag_*`, `irf_rq_*`, `irf_spec_*` de julho/11 e
  julho/15, `irf_model_alessi_r6q5.pdf` — ~12 MB que não reproduzem contra as
  106 séries.
- Em 2026-09-01, os nove arquivos sob
  `arquivo/heterocedasticidade/{R/identification,script}/` e os três órfãos
  `arquivo/script/{instrument_audit,irf_cross_instrument,build_grg_benchmark}.R`.
  Todos eram exclusivos da rota `z_het*` ou dependiam de bundles dessa rota já
  apagados; nenhum tinha consumidor no pipeline ativo.

- `paper/img/` (6 PDFs, 2026-08-05): duplicata byte-idêntica das figuras
  na raiz de `paper/`. O `paper_anpec.fls` mostra que o compile sempre
  leu da raiz; só linhas `\includegraphics` comentadas apontavam para `img/`.
  Regenerável por `script/fig_section5.R` ⇒ apagada, não arquivada.

Os arquivos `data/processed/instrument_z_het*.csv` (6) tinham sido **mantidos**
em 2026-07-26 sob o argumento de que `data/` é gitignored e regenerá-los
exigiria rodar um script arquivado. **Foram apagados em 2026-08-05**: eram os
últimos vestígios vivos das variantes `z_het`, e o argumento de conveniência não
supera o de higiene — o registro do que eram e por que morreram está em
`historico_decisoes.md` §1.1, que é onde ele tem de estar. Na mesma passagem
saíram `instrument_jk_raw_purif_local.csv` e `instrument_jk_purif_us.csv`, órfãos
depois do corte de 10 → 8 variantes. As colunas `z_het*` já não existiam em
`instrumentos_mensais.csv`.
