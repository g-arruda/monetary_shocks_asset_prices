"""Baixa o painel diario de futuros de DI da release pyield-data para data/raw/di.csv."""

from pathlib import Path

import polars as pl

# URL do release mais recente (Latest) — nao e uma vintage fixa.
BASE_URL = "https://github.com/crdcj/pyield-data/releases/latest/download"

OUT_PATH = Path("data/raw/di.csv")
OUT_PATH.parent.mkdir(parents=True, exist_ok=True)

df = pl.read_parquet(f"{BASE_URL}/b3_di.parquet")
df.write_csv(OUT_PATH)

print(f"Wrote {df.height} rows x {df.width} cols to {OUT_PATH}")
