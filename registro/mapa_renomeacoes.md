# Mapa de renomeações

**Para que serve.** `notas/` e `pareceres/` valem **verbatim**: uma nota datada
registra o que foi verificado naquele dia, e um parecer registra o que um revisor
externo afirmou ter checado — inclusive caminhos de arquivo e números de linha.
Reescrever um caminho dentro deles transformaria uma verificação datada numa
afirmação que ninguém fez (`.claude/rules/writing.md`). Então os caminhos antigos
**ficam lá**, e a tradução mora aqui.

**Como usar.** Ao ler qualquer documento do acervo anterior à data de um bloco
abaixo, aplique o mapa daquele bloco. Documentos vivos de `registro/` são
mantidos em lugar e já usam os caminhos correntes.

---

## 2026-08-17 — refactor de convenções (`coding-style`)

| antes | agora |
|---|---|
| `R/modeling/impulse_responde.R` | `R/modeling/impulse_response.R` |
| `R/data_download/fomc_dates.R` | `script/fomc_dates.R` |

O primeiro corrige um erro de grafia que sobreviveu desde o início do projeto; o
segundo move para `script/` um arquivo que nunca foi `source()`-ado por ninguém e
que, portanto, nunca foi módulo. **47 arquivos vivos** de código e documentação
foram repontuados na mesma passada. O acervo não foi tocado de propósito:

- **12 arquivos de `notas/`** citam `impulse_responde.R` ou
  `R/data_download/fomc_dates.R`;
- **4 arquivos de `pareceres/`** idem;
- **14 arquivos de `arquivo/`**, que é histórico e não se mexe.

⚠ **Números de linha do arquivo renomeado também envelheceram.** O refactor
moveu `main_sdfm` para `R/modeling/dfm_pipeline.R` e reordenou blocos, então uma
citação `impulse_responde.R:<linha>` do acervo aponta para o arquivo certo pelo
mapa acima, mas **não** necessariamente para a linha certa. Conferir antes de
reusar como referência.

## 2026-08-11 — adoção do esqueleto `/newproject`

Este mapa já existia dentro do blockquote de leitura de
`pareceres/council_2026-08-10.md`; fica aqui também para o acervo ter um lugar
único.

| antes | agora |
|---|---|
| `_instrucoes/` | `registro/` |
| `_instrucoes/Instrumento.md` | `registro/metodo.md` |
| `relatorio/working-notes/` | `notas/` |
| `relatorio/council_*` | `pareceres/` |
| `texto_anpec/` | `paper/` |
| `data/<x>` | `data/raw/<x>` (exceto `data/processed/`) |

## 2026-08-02 — arquivamento do draft

| antes | agora |
|---|---|
| `tex/main.tex` | `arquivo/tex/main.tex` |

O paper canônico passou a ser `paper/paper_anpec.tex`. As referências
`tex/main.tex:<linha>` nas notas continuam apontando para o mesmo conteúdo, só
que sob `arquivo/`.

## 2026-08-05 — módulo sem consumidor

| antes | agora |
|---|---|
| `R/modeling/svensson_model.R` | `arquivo/R/modeling/svensson_model.R` |

`script/yield_curve.R` foi apagado em 2026-07-26 e a curva do painel passou a ser
insumo externo fixo (`data/raw/yields/yields_dia.csv`).

---

## Arquivos cuja existência mudou

Casos em que o acervo afirma que um arquivo **não existia** e isso deixou de ser
verdade, ou o contrário. Não são renomes, e por isso não entram nas tabelas
acima.

- **`data/raw/fomc_dates.csv`** — o council de 2026-08-10 verificou que o arquivo
  **não existia**, e essa verificação está correta para a árvore daquele dia. Ele
  **passou a existir em 2026-08-10**, produzido pelo script hoje em
  `script/fomc_dates.R`.
- **`data/raw/di.csv`** — continua existindo localmente (vintage 2026-02-09) e é
  gitignored, mas **deixou de ser reprodutível a partir do upstream**: em
  2026-08-17 o `pyield-data` já não publica `b3_di.parquet`, mudou o schema e
  poda releases antigas. Ver `script/download_di.py` e o Tema E de
  `pendencias.md`.
