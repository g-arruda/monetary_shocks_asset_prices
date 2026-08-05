# Plano: reescrita de estilo (`coding-style`) do projeto monetary_shocks_asset_prices

## Contexto

O projeto tem 57 arquivos ativos de código (56 `.R` + 1 `.py`, 18.534 linhas: `script/` 9.514, `R/` 6.710, `diagnostics/` 2.310) que precisam ser conformados à skill `coding-style`. Um levantamento (Explore agent) mostrou que o trabalho real não é uniforme:

- **Pipe nativo (`|>`)**: já 100% migrado, zero `%>%` no repo ativo — nenhum trabalho aqui.
- **Dead code / `_v2`/`_old`**: nenhum bloco de código morto genuíno encontrado; nenhum arquivo com sufixo de versionamento.
- **Namespacing (`dplyr::`, `tidyr::`)**: violado principalmente em `script/` e `diagnostics/` (20 dos 22 arquivos de `R/` já estão 100% namespaced). Requer cuidado: alguns verbos como `filter()` podem ser `stats::filter`/`signal::filter` neste domínio (séries temporais), não `dplyr::filter` — não é um find-replace cego.
- **Documentação roxygen2**: praticamente ausente em ~150+ funções — este é o maior item de volume.
- **Separação função/execução**: `R/data_download/focus_fred.R` mistura as duas; 7 scripts (`het_robustness.R`, `jk_sovereign_confound.R`, `factor_stationarity.R`, `asset_representation.R`, `model_var.R`, `validate_gmr_ica.R`, `instrument_construction_sweep.R`) e `diagnostics/07_dominancia_fiscal.R` (21 funções) definem lógica substancial inline — decisão do usuário: **extrair para `R/`**, seguindo o padrão que o projeto já usa (`var_proxy.R` extraído de `model_var.R` em 2026-07-31, `build_variants.R` extraído de `instrument.R` em 2026-07-27).
- **`R/modeling/svensson_model.R`** (601 linhas): órfão documentado no CLAUDE.md, sem consumidor desde 2026-07-26 — decisão do usuário: **deletar**.

Este é um pipeline de pesquisa validado numericamente com autotestes (`stopifnot`) espalhados e números publicados no CLAUDE.md (ex.: ξ_mp = 10.43, h0 do smoke test). A reescrita é **puramente de estilo — nenhuma mudança de lógica ou de output numérico é aceitável**. Dado o volume (18.5k linhas, ~30 arquivos que precisam edição real), o trabalho é dividido em **fases pequenas o suficiente para caber confortavelmente em uma sessão** cada, com um checklist de progresso para retomar entre sessões, e um protocolo de verificação que aproveita que `output/` e `diagnostics/output/` são **git-tracked** (qualquer mudança de comportamento aparece como diff nesses CSVs).

**Fora de escopo**: `arquivo/` (arquivado, não executado), `codigo_alessi-mark/`, `codigo_Jarocinski_e_Karadi/`, `codigo_bauer_swanson/`, `codigo_olea/` (referências read-only), `artigos/`, `texto_anpec/` (prosa, não código).

## Fase 0 — Baseline e branch (sessão curta, fazer primeiro)

1. O branch atual (`robustez-heterocedasticidade`) tem trabalho de pesquisa em andamento não commitado (`HANDOFF.md`, `R/identification/het_primary.R`, `R/modeling/impulse_responde.R`, `R/identification/het_tests.R` novo, `_instrucoes/historico_decisoes.md`, `texto_anpec/paper_anpec.tex`, `texto_anpec/references.bib`, `output/het/` novo, `script/het_robustness.R` novo, working-notes novos). **Commitar esse trabalho primeiro**, com mensagem descrevendo o achado (Rigobon re-testado e confirmado morto — ver memória do projeto), sem trailer `Co-Authored-By`.
2. Criar branch dedicado `coding-style-rewrite` a partir daí.
3. Criar `_instrucoes/coding_style_rewrite_progress.md` — checklist markdown com uma linha por fase (arquivo(s), status pendente/em progresso/feito, commit hash, observações/decisões de extração tomadas). Atualizar no início e no fim de cada sessão subsequente — é o que permite a uma sessão nova retomar sem reler todo o histórico.
4. Registrar baseline: confirmar `git status` limpo em `output/` e `diagnostics/output/` no branch novo (ponto de referência: nenhum diff nesses diretórios deve aparecer em nenhuma fase futura).
5. Anotar o comando de smoke test do `CLAUDE.md` (rápido, sem bootstrap) como checagem de regressão padrão para qualquer fase que toque `R/modeling/`, `R/identification/` ou `script/model_alessi.R`.

## Protocolo de verificação (repetir em toda fase)

- **Antes de editar**: se a fase envolve `R/modeling/`, `R/identification/` ou o pipeline principal, rodar o smoke test do CLAUDE.md e registrar os valores h0 de referência (`yield_6m` 0.005, `yield_2y` 0.009164, `yield_5y` 0.009274, `asset_ibov` −1.673, `cambio_usd` 0.1498).
- **Depois de editar**: rodar o(s) script(s) afetado(s) (ou ao menos `Rscript -e "source('arquivo.R')"` para arquivos de função, que deve ser um no-op silencioso).
  - Para outputs **git-tracked** (`output/`, `diagnostics/output/`): `git diff --stat` deve ficar **vazio**.
  - Para outputs em `data/` (gitignored): comparar `md5sum` antes/depois, já que não há diff do git disponível.
  - Para scripts de bootstrap pesados (~15-25 min, `nboot=800`): não re-rodar por completo a cada sessão — usar o smoke test rápido + `source()` sem erro como checagem de rotina, e reservar a rodada completa para os marcos (fim da Fase 2, fim da Fase 4, e a Fase 6 final).
- `git diff` arquivo a arquivo antes de commitar, para confirmar visualmente que só há namespacing, comentários roxygen2 e código movido (não reescrito) — nenhuma linha de lógica mudou de comportamento.
- Commitar ao final de cada fase, mensagem referenciando o número da fase, sem `Co-Authored-By`.

## Fases de execução

Cada fase é dimensionada para uma sessão. Se sobrar contexto, dá para emendar a próxima fase na mesma sessão — não é uma regra rígida 1 fase = 1 sessão.

### Bloco R/ (base para tudo que vem depois — fazer antes de script/ e diagnostics/)

| Fase | Arquivos | Linhas | Trabalho |
|---|---|---|---|
| 1 | `R/data_download/*.R` (6), `R/preprocessing/seasonality.R`, `R/instrument/*.R` (2), `R/data_download/download_di.py` | ~1.037 | Namespacing + roxygen2/docstring. `focus_fred.R`: envolver a lógica de execução no guard `if (sys.nframe() == 0) { ... }`, igual a `external_factors.R`/`ibov_daily.R` (padrão já existente no projeto — mais seguro que mover o arquivo para `script/`, o que quebraria o comando documentado no CLAUDE.md). |
| 2 | `R/modeling/impulse_responde.R`, `factor_estimation.R`, `var_proxy.R`; **deletar** `svensson_model.R` | 1.950 (+601 deletado) | Namespacing + roxygen2 nas 3 funções ativas. Verificar smoke test exato antes/depois (arquivo mais sensível do repo — é o contrato de identificação). Registrar a remoção do órfão no CLAUDE.md. |
| 3a | `R/identification/het_primary.R`, `het_tests.R`, `nongaussian_gmr.R`, `nongaussian_branch.R` | 1.887 | Namespacing + roxygen2. Verificar via `script/het_robustness.R` (gate numbers do CLAUDE.md) e `script/validate_gmr_ica.R`/`nongaussian_gate.R`. |
| 3b | `R/identification/validation_tests.R`, `spec_sweep.R`, `nongaussian_labelling.R`, `factor_space_diagnostics.R`, `irf_coherence.R` | 1.243 | Namespacing + roxygen2. Verificar via `script/irf_spec_sweep.R` (stage 1, rápido) e `script/irf_coherence_check.R`. |

### Bloco script/ — núcleo do pipeline (namespacing só, baixo risco estrutural)

| Fase | Arquivos | Linhas | Trabalho |
|---|---|---|---|
| 4a | `download.R`, `clean.R`, `instrument.R`, `model_alessi.R`, `run_all.R` | 1.388 | Namespacing + roxygen2 nas poucas funções locais. Maior cautela: são os entry points do pipeline real. |

### Bloco script/ — extrações estruturais (uma por sessão, maior risco)

| Fase | Arquivo | Linhas / funções inline | Destino sugerido |
|---|---|---|---|
| 4b | `model_var.R` | 611 / 7 | Estender `R/modeling/var_proxy.R` (extração já existe parcialmente — completar o padrão). |
| 4d | `instrument_construction_sweep.R` | 519 / 6 | Novo arquivo em `R/instrument/` (ex. helpers de varredura de vértice/agregação). |
| 4f | `jk_sovereign_confound.R` | 785 / 9 | Novo arquivo em `R/identification/` — checar antes se alguma função já existe em `het_primary.R`/`het_tests.R` (reuse-before-writing). |
| 4g | `factor_stationarity.R` | 839 / 9 | Novo arquivo (companion spectrum / unit-root / cointegration helpers) — domínio próprio, provavelmente `R/identification/` ou `R/modeling/`. |
| 4h | `asset_representation.R` | 704 / 9 | Novo arquivo em `R/identification/` ou `R/modeling/` (painel de representação de ativos). |
| 4i | `het_robustness.R` | 788 / 10 | Novo arquivo — **checar sobreposição com `het_tests.R`** (foi parcialmente extraído de lá em 2026-08-01; não duplicar). |

Para cada uma dessas 6 fases: extrair função por função (não reescrever a lógica), criar o novo arquivo em `R/` com roxygen2 já no ato da extração, adicionar `source()` no script, rodar o script completo e comparar output (git-tracked quando aplicável) antes/depois. Atualizar a narrativa do `CLAUDE.md` (o padrão já usado para `var_proxy.R`/`build_variants.R`) e `script/README.md` com o novo arquivo.

### Bloco script/ — resto (namespacing só)

| Fase | Arquivos | Linhas |
|---|---|---|
| 4c | `instrument_diagnostics.R`, `mosw_strength_grid.R`, `xi_mp_robustness.R`, `diagnose_factor_space_F.R` | 1.065 |
| 4e | `irf_spec_sweep.R`, `irf_spec_stage2.R`, `irf_coherence_check.R` | 777 |
| 4j | `validate_gmr_ica.R` (266/6 funções — extração pequena, mesma sessão), `nongaussian_gate.R`, `model_nongaussian.R`, `nongaussian_corroboration.R`, `nongaussian_labelling.R` | 1.590 |
| 4k | `validate_hac_kernel.R`, `validate_olea_kilian.R`, `fig_section5.R` | 448 |

### Bloco diagnostics/

| Fase | Arquivos | Linhas | Trabalho |
|---|---|---|---|
| 5a | `_common.R`, `01_exogeneidade.R`, `02_unidades_sinal.R`, `03_composicao_painel.R`, `04_forca_instrumento.R` | 958 | Namespacing + roxygen2. |
| 5b | `05_persistencia_fatores.R`, `06_bloco_ativos.R` | 490 | Namespacing + roxygen2. |
| 5c | `07_dominancia_fiscal.R` | 862 / 21 funções | Extração estrutural — a maior do projeto. Já tem autoteste custom (sandwich IV) documentado no CLAUDE.md; verificar esse `stopifnot` continua passando após a extração. |

### Fase 6 — Varredura final e sincronização de documentação

1. Grep repo-wide: nenhum verbo dplyr/tidyr bare restante (exceto `stats::`/`signal::` legítimos verificados um a um), zero `%>%`, zero `library()`/`require()` no topo de arquivos `R/`, nenhum arquivo `_v2`/`_old`.
2. Atualizar `CLAUDE.md`: remover referências a `svensson_model.R`; documentar cada novo arquivo `R/` criado pelas extrações (seguindo o estilo de "extraído em <data>" já usado).
3. Atualizar `script/README.md` e `diagnostics/README.md` com os arquivos novos/movidos.
4. Rodar a suíte de scripts de validação completos (`validate_olea_kilian.R`, `validate_hac_kernel.R`, `validate_gmr_ica.R`, `het_robustness.R`, smoke test) como checagem final.
5. `git diff --stat` de `output/` e `diagnostics/output/` entre `main` e `coding-style-rewrite` — deve ficar vazio.

## Verificação end-to-end

- Cada fase: protocolo acima (smoke test / `git diff --stat` em outputs tracked / `md5sum` em outputs gitignored).
- Marcos com rodada completa (bootstrap `nboot=800`): fim da Fase 2 (`model_alessi.R`), fim do bloco 4 (pipeline completo via `run_all.R --from=clean`), Fase 6 final.
- Checklist de progresso (`_instrucoes/coding_style_rewrite_progress.md`) é a fonte de verdade entre sessões — cada sessão nova começa lendo esse arquivo antes de tocar em código.
