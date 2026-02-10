import polars as pl

# URL fixa para o release mais recente (Latest)
BASE_URL = "https://github.com/crdcj/pyield-data/releases/latest/download"

# Para ler o arquivo de DI
df = pl.read_parquet(f"{BASE_URL}/b3_di.parquet")

df.write_csv("data/di.csv")