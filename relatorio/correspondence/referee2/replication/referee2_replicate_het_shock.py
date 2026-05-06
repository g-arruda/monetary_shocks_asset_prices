"""
Cross-language replication of R/identification/het_shock_extraction.R.

Reads the daily changes table built by R (referee2_daily_changes.csv) and
implements Rigobon-Sack (2003) heteroskedasticity identification + the
Mertens-Ravn (2013) GLS shock recovery in pure NumPy. Writes a comparison CSV
that the R-side report cross-checks for numerical agreement.

Run:
    python code/replication/referee2_replicate_het_shock.py
"""

from pathlib import Path

import numpy as np
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[2]
INPUT_PATH   = PROJECT_ROOT / "code/replication/referee2_daily_changes.csv"
OUTPUT_DIR   = PROJECT_ROOT / "code/replication"

VARS = ["DI_3m", "DI_2y", "IBOV", "BRL"]


def load_changes():
    df = pd.read_csv(INPUT_PATH, parse_dates=["wed_date", "thu_date"])
    return df.dropna(subset=VARS).reset_index(drop=True)


def variance_split(df, n_boot=1000, alpha=0.01, seed=42):
    rng = np.random.default_rng(seed)
    rows = []
    for v in VARS:
        x = df[v].to_numpy()
        is_C = (df["regime"] == "C").to_numpy()
        xC, xNC = x[is_C], x[~is_C]
        v_C, v_NC = np.var(xC, ddof=1), np.var(xNC, ddof=1)

        boot = np.empty(n_boot)
        for b in range(n_boot):
            sC  = rng.choice(xC,  size=xC.size,  replace=True)
            sNC = rng.choice(xNC, size=xNC.size, replace=True)
            boot[b] = np.var(sC, ddof=1) / np.var(sNC, ddof=1)
        ci_low, ci_high = np.quantile(boot, [alpha / 2, 1 - alpha / 2])

        rows.append(dict(var=v, n_C=xC.size, n_NC=xNC.size,
                         var_C=v_C, var_NC=v_NC, ratio=v_C / v_NC,
                         ci_low=ci_low, ci_high=ci_high))
    return pd.DataFrame(rows)


def rigobon_sack(df, mp_var="DI_3m"):
    is_C = (df["regime"] == "C").to_numpy()
    X = df[VARS].to_numpy()

    XC  = X[is_C]
    XNC = X[~is_C]
    XC  = XC  - XC.mean(axis=0)
    XNC = XNC - XNC.mean(axis=0)

    Sigma_C  = (XC.T  @ XC)  / (XC.shape[0]  - 1)
    Sigma_NC = (XNC.T @ XNC) / (XNC.shape[0] - 1)
    dSigma   = Sigma_C - Sigma_NC

    # eigh returns eigenvalues in ASCENDING order; flip to match R's eigen()
    w, V = np.linalg.eigh(dSigma)
    w    = w[::-1]
    V    = V[:, ::-1]

    lambda_1 = w[0]
    v_1      = V[:, 0]
    b_1      = np.sqrt(abs(lambda_1)) * v_1

    mp_idx = VARS.index(mp_var)
    if b_1[mp_idx] < 0:
        b_1 = -b_1

    Sigma_C_inv = np.linalg.inv(Sigma_C)
    weight      = float(b_1 @ Sigma_C_inv @ b_1)
    shocks_C    = (XC @ Sigma_C_inv @ b_1) / weight

    return dict(
        b_1=b_1,
        lambda_all=w,
        eigenvalue_gap=abs(w[0]) / abs(w[1]),
        rank1_share=abs(w[0]) / np.sum(np.abs(w)),
        psd_min_eig=float(w.min()),
        shocks_C=shocks_C,
        shocks_C_dates=df.loc[is_C, "thu_date"].reset_index(drop=True),
        n_C=int(is_C.sum()),
        n_NC=int((~is_C).sum()),
    )


def aggregate_monthly(shocks, dates, sample_start, sample_end):
    months = pd.date_range(sample_start, sample_end, freq="MS")
    df = pd.DataFrame({"date": pd.to_datetime(dates), "shock": shocks})
    df["month"] = df["date"].values.astype("datetime64[M]")
    monthly = df.groupby("month")["shock"].sum().reindex(months, fill_value=0.0)
    return monthly.reset_index().rename(columns={"index": "month", "shock": "z_het"})


def main():
    df = load_changes()
    print(f"Loaded {len(df)} complete pairs (C={int((df.regime=='C').sum())}, "
          f"NC={int((df.regime=='NC').sum())})")

    val = variance_split(df)
    val.to_csv(OUTPUT_DIR / "referee2_py_variance.csv", index=False, float_format="%.6f")
    print("\nVariance split (Python):")
    print(val.to_string(index=False))

    ext = rigobon_sack(df)
    print(f"\nlambda_all     = {np.round(ext['lambda_all'], 4)}")
    print(f"rank1_share    = {ext['rank1_share']:.6f}")
    print(f"eigenvalue_gap = {ext['eigenvalue_gap']:.6f}")
    print(f"psd_min_eig    = {ext['psd_min_eig']:.6f}")
    print(f"b_1            = {dict(zip(VARS, np.round(ext['b_1'], 6)))}")

    pd.DataFrame({"variable": VARS, "b_1": ext["b_1"]}).to_csv(
        OUTPUT_DIR / "referee2_py_b1.csv", index=False, float_format="%.6f"
    )
    pd.DataFrame({"rank": np.arange(1, len(VARS) + 1),
                  "variable": VARS,
                  "lambda": ext["lambda_all"],
                  "abs_share": np.abs(ext["lambda_all"]) / np.sum(np.abs(ext["lambda_all"]))}
                 ).to_csv(OUTPUT_DIR / "referee2_py_eigenvalues.csv",
                          index=False, float_format="%.6f")

    monthly = aggregate_monthly(ext["shocks_C"], ext["shocks_C_dates"],
                                "2013-01-01", "2025-12-01")
    monthly.to_csv(OUTPUT_DIR / "referee2_py_z_het.csv", index=False, float_format="%.6f")
    print(f"\nMonthly z_het rows: {len(monthly)}, nonzero: {(monthly.z_het != 0).sum()}, "
          f"sd: {monthly.z_het.std():.4f}")


if __name__ == "__main__":
    main()
