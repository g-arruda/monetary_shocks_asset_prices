"""Baixa o painel diario de futuros de DI da release pyield-data para data/raw/di.csv.

ESTADO EM 2026-08-17: ESTE ESTAGIO NAO REPRODUZ MAIS A VINTAGE DO REPO.
Verificado contra a API do GitHub nesta data, o upstream mudou em quatro
frentes, e nenhuma delas se resolve editando este arquivo:

  1. O asset `b3_di.parquet` **nao existe mais**. A release publica
     `b3_futures.parquet`, `anbima_tpf.parquet` e `vna_ntnb.parquet`.
  2. O schema mudou para os nomes crus da B3 (`TradDt`, `TckrSymb`,
     `AdjstdQtTax`). As colunas `ExpirationDate`, `BDaysToExp` e `CloseRate`
     eram **derivadas** e sairam — reconstrui-las exige o calendario de dias
     uteis da B3, que o pacote `pyield` (instalado, 0.43.1) fornece.
  3. O historico do asset novo comeca em **2018-01-02**, enquanto
     `load_di_panel()` (R/instrument/di_surprise.R:12) pede desde 2012-06-01.
     Baixar hoje truncaria em silencio 2012-2017, que e metade da amostra de
     Copom.
  4. So as ~30 releases mais recentes sao mantidas: `data-2026-02-10`, a
     vintage que produziu o `data/raw/di.csv` deste repo, ja responde 404.

Consequencia pratica: `data/raw/di.csv` (2026-02-09, gitignored) e hoje um
**insumo insubstituivel** e deve ser tratado como tal. Este script mantem o
caminho vivo e, com o upstream atual, **aborta alto em vez de gravar um painel
truncado**. Fechar isso de verdade e decisao de pesquisa, nao de estilo: ver o
item correspondente em registro/pendencias.md, Tema E.

Vintage: nao da para fixar uma tag antiga que sera apagada, entao a disciplina e
resolver a tag no download e **grava-la** ao lado do CSV. Para repetir uma
vintage especifica enquanto ela existir, defina DI_RELEASE_TAG.
"""

import json
import os
import urllib.request
from datetime import date
from pathlib import Path

import polars as pl

REPO = "crdcj/pyield-data"
ASSET = "b3_di.parquet"
OUT_PATH = Path("data/raw/di.csv")
TAG_PATH = OUT_PATH.with_name("di_release_tag.txt")

# Janela exigida por load_di_panel(): from = 2012-06-01, to = 2026-02-01.
REQUIRED_FROM = date(2012, 6, 1)
REQUIRED_THROUGH = date(2026, 2, 1)
REQUIRED_COLUMNS = {"TradeDate", "ExpirationDate", "BDaysToExp", "CloseRate"}
MIN_ROWS = 100_000

tag = os.environ.get("DI_RELEASE_TAG")
endpoint = "latest" if tag is None else f"tags/{tag}"
with urllib.request.urlopen(
    f"https://api.github.com/repos/{REPO}/releases/{endpoint}", timeout=60
) as response:
    release = json.load(response)
tag = release["tag_name"]
print(f"Release: {tag}")

assets = {a["name"]: a["browser_download_url"] for a in release["assets"]}
if ASSET not in assets:
    raise SystemExit(
        f"A release {tag} nao publica {ASSET}. Assets disponiveis: "
        f"{sorted(assets)}. O upstream renomeou o arquivo e mudou o schema; "
        "ver o cabecalho deste script antes de apontar para outro asset."
    )

df = pl.read_parquet(assets[ASSET])

# Gate de sanidade: aborta alto. Uma mudanca de schema entraria por
# load_di_panel() -> build_thursday_surprises() -> as 8 variantes do
# instrumento, e so apareceria como xi_mp estranho muitos passos depois.
missing = REQUIRED_COLUMNS - set(df.columns)
if missing:
    raise SystemExit(
        f"{ASSET} de {tag} nao tem as colunas {sorted(missing)}; "
        f"tem {sorted(df.columns)}"
    )
if df.height < MIN_ROWS:
    raise SystemExit(f"{ASSET} de {tag} tem {df.height} linhas, menos que {MIN_ROWS}")

first_date, last_date = df["TradeDate"].min(), df["TradeDate"].max()
if first_date > REQUIRED_FROM:
    raise SystemExit(
        f"{ASSET} de {tag} comeca em {first_date}, depois de {REQUIRED_FROM} "
        "exigido por load_di_panel(): gravar truncaria a amostra de Copom"
    )
if last_date < REQUIRED_THROUGH:
    raise SystemExit(
        f"{ASSET} de {tag} termina em {last_date}, antes de {REQUIRED_THROUGH} "
        "exigido por load_di_panel()"
    )
if df["CloseRate"].is_null().all():
    raise SystemExit(f"{ASSET} de {tag} tem CloseRate inteiramente nulo")

OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
df.write_csv(OUT_PATH)
TAG_PATH.write_text(f"{tag}\t{date.today().isoformat()}\n")

print(f"Wrote {df.height} rows x {df.width} cols to {OUT_PATH}")
print(f"Cobertura {first_date} a {last_date}; vintage registrada em {TAG_PATH}")
