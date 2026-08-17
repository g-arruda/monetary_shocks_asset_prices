# Handoff — 2026-08-17 (abandono e arquivamento das duas identificações alternativas)
SESSLOG:[2026-08-17]
*Project: monetary_shocks_asset_prices*

## Session Topic
Abandono, por decisão do autor, das estratégias de identificação por
**heterocedasticidade** (Rigobon 2003) e por **momentos / não-gaussianidade**
(GMR 2017 PML-ICA). Código, artefatos, notas e registro movidos para
`arquivo/`, separados por estratégia. Nada commitado.

## Active Decisions
- **O projeto tem uma identificação: o proxy externo `z_jk_bs_purif`.** As duas
  rotas alternativas não entram no paper, nem como robustez, nem como
  corroboração.
- **Destino:** `arquivo/heterocedasticidade/` e `arquivo/nao_gaussiana/`, cada
  uma com README próprio (veredito, índice, armadilhas). Consolidado no acervo
  `arquivo/` que já existia — não num `arquivos/` novo — porque a regra de
  fronteira "no live path sources from `arquivo/`" já o cobre. O material het
  arquivado em 2026-07-26 migrou para o subfolder.
- **O núcleo de identificação foi colapsado para ramo único.** O `switch` de 3
  vias saiu de `R/modeling/{dfm_pipeline,impulse_response}.R`. O parâmetro
  `identification` **ficou** (domínio `"proxy"`, via `match.arg`): seis
  chamadores vivos o passam explicitamente, cinco deles sob `diagnostics/`, que
  não é editável.
- **`historico_decisoes.md` §0 e §1 viraram stub + ponteiro.** O corpo integral
  está em `arquivo/*/registro/historico_decisoes_secao{0,1}.md`. A função
  anti-retrabalho fica no lugar; o detalhe morto sai do registro vivo.
- **Três notas saíram de `notas/`** para as pastas de arquivo, com os links do
  `_indice.md` repontados e marcados `(arquivada)`.
- **O paper não foi tocado, e não precisa ser.** As menções a heterocedasticidade
  em `paper_anpec.tex:156,209,589` citam `goncalves2025` — evidência alheia com
  que o artigo dialoga, não a rota deste projeto.
- **Não confundir com o que ficou:** inferência robusta a heterocedasticidade
  (wild bootstrap Gonçalves-Kilian, HAC do primeiro estágio) é produção e está
  intocada. `R/identification/validation_tests.R` também fica — a suíte T1-T8 foi
  escrita para `z_het_jk` mas é agnóstica ao instrumento.

## Key Files
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/arquivo/heterocedasticidade/README.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/arquivo/nao_gaussiana/README.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/R/modeling/impulse_response.R
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/R/modeling/dfm_pipeline.R
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/registro/historico_decisoes.md
- /mnt/storage/Github/Modelo/monetary_shocks_asset_prices/registro/pendencias.md

## Next Steps
- [ ] Revisar o diff e commitar (três commits: moves, cirurgia, limpeza dos `.md`)
- [ ] Reescrever o bloco de ações do §4 e a legenda da `fig:acoes` — contradição
      viva em `paper_anpec.tex:485` e `:491`
- [ ] Decidir `q` com os números de `output/factors/q_selection.md`
- [ ] Backup de `data/raw/di.csv` fora do repo — insumo insubstituível e gitignored
- [ ] A §5 perdeu duas pernas prometidas; decidir a composição que sobra
      (construção do instrumento, especificação, Limitações)

## Working Artifacts
- `arquivo/*/registro/historico_decisoes_secao{0,1}.md` — corpos integrais das
  duas seções, extraídos do registro vivo

## Context
Escopo executado: 11 arquivos `.R` movidos (4.336 linhas), 27 artefatos de
`output/`, 3 notas, e limpeza cirúrgica de `registro/` (5 arquivos), `CLAUDE.md`,
`README.md`, `script/README.md`, `.claude/rules/{identification,writing}.md` e
`notas/_indice.md`. O guard da cirurgia foi o smoke test de produção, que
reproduz **bit-a-bit** antes e depois (`-1.7226766564462794` etc.); a ordem de
consumo do RNG no bootstrap foi preservada, então as bandas também não se movem.
`run_all.R --list` intacto, 33 scripts em `script/`.
