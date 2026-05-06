"""
Cross-language replication of the heteroskedasticity instrument validation
tests (R: R/identification/validation_tests.R, script/instrument_validation.R).

Recomputes in pure NumPy + statsmodels:
  T1 placebo permutation distribution and p-value
  T3 sub-period first-stage F (full, pre-COVID, COVID+post, drop-COVID-acute)
  T4 monthly correlation between z_het_jk and z_jk_purif

T2 (random-mask) is omitted because it requires the daily shock series, which
was already cross-validated in round1 (referee2_replicate_het_shock.py).

The objective is six-decimal agreement on observed F, sub-period F's, and
correlations; placebo p-values must agree to within Monte Carlo noise.

Run:
    python correspondence/referee2/replication/referee2_replicate_validation.py
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm

PROJECT_ROOT = Path(__file__).resolve().parents[3]
RAW_PATH    = PROJECT_ROOT / "data/raw_data.csv"
INSTR_PATH  = PROJECT_ROOT / "data/processed/instrumentos_mensais.csv"
OUT_DIR     = Path(__file__).resolve().parent

SAMPLE_START = pd.Timestamp("2013-01-01")
SAMPLE_END   = pd.Timestamp("2025-12-31")
N_LAGS       = 6
N_PERM       = 2000
SEED_PLACEBO = 20260426

WINDOWS = {
    "full":       (pd.Timestamp("2013-01-01"), pd.Timestamp("2025-12-01")),
    "pre_covid":  (pd.Timestamp("2013-01-01"), pd.Timestamp("2019-12-01")),
    "covid_post": (pd.Timestamp("2020-01-01"), pd.Timestamp("2025-12-01")),
    "drop_covid": (pd.Timestamp("2020-03-01"), pd.Timestamp("2020-09-01")),
}


def residualize_ar(target, n_lags=N_LAGS):
    """Fit y_t = c + sum phi_k y_{t-k} + e_t; return residuals at full length."""
    y = pd.Series(target)
    X = pd.concat([y.shift(k).rename(f"lag{k}") for k in range(1, n_lags + 1)], axis=1)
    X = sm.add_constant(X)
    keep = ~(y.isna() | X.isna().any(axis=1))
    fit = sm.OLS(y[keep], X[keep]).fit()
    innov = pd.Series(np.nan, index=y.index)
    innov.loc[keep] = fit.resid
    return innov.to_numpy()


def first_stage_F(z, innov):
    """Squared HC0 t on the slope of innov ~ z."""
    z = np.asarray(z, dtype=float)
    e = np.asarray(innov, dtype=float)
    ok = (~np.isnan(z)) & (~np.isnan(e))
    if ok.sum() < 3 or np.std(z[ok], ddof=1) == 0:
        return dict(F=np.nan, beta=np.nan, se=np.nan, n=int(ok.sum()), r2=np.nan)
    X = sm.add_constant(z[ok])
    fit = sm.OLS(e[ok], X).fit(cov_type="HC0")
    return dict(F=float(fit.tvalues[1] ** 2),
                beta=float(fit.params[1]),
                se=float(fit.bse[1]),
                n=int(ok.sum()),
                r2=float(fit.rsquared))


def placebo(z, innov, n_perm=N_PERM, seed=SEED_PLACEBO):
    """Permutation distribution of first-stage F under H0 of no relation."""
    rng = np.random.default_rng(seed)
    out = np.empty(n_perm)
    for b in range(n_perm):
        z_perm = rng.permutation(z)
        out[b] = first_stage_F(z_perm, innov)["F"]
    return out


def subperiod_F(z, innov, dates, windows):
    """Full-sample residuals subset by window — never refit AR within window."""
    rows = []
    dates = pd.to_datetime(dates)
    for name, (lo, hi) in windows.items():
        if name == "drop_covid":
            keep = ~((dates >= lo) & (dates <= hi))
        else:
            keep = (dates >= lo) & (dates <= hi)
        fs = first_stage_F(z[keep.to_numpy()], innov[keep.to_numpy()])
        rows.append(dict(window=name, n_months=int(keep.sum()), **fs))
    return pd.DataFrame(rows)


def correlation_subsets(z1, z2):
    """Pearson and Spearman over (all, union of nonzeros, both nonzero)."""
    z1 = np.asarray(z1, dtype=float)
    z2 = np.asarray(z2, dtype=float)
    subsets = {
        "all":           np.ones_like(z1, dtype=bool),
        "union_nonzero": (z1 != 0) | (z2 != 0),
        "both_nonzero":  (z1 != 0) & (z2 != 0),
    }
    rows = []
    for label, mask in subsets.items():
        a, b = z1[mask], z2[mask]
        if len(a) < 2:
            pearson = spearman = np.nan
        else:
            pearson  = float(np.corrcoef(a, b)[0, 1])
            ra = pd.Series(a).rank().to_numpy()
            rb = pd.Series(b).rank().to_numpy()
            spearman = float(np.corrcoef(ra, rb)[0, 1])
        rows.append(dict(subset=label, n=int(mask.sum()),
                         pearson=pearson, spearman=spearman))
    return pd.DataFrame(rows)


def main():
    raw = pd.read_csv(RAW_PATH, parse_dates=["ref.date"]).sort_values("ref.date")
    raw = raw[(raw["ref.date"] >= SAMPLE_START) & (raw["ref.date"] <= SAMPLE_END)].reset_index(drop=True)

    target_dates  = raw["ref.date"]
    target_series = raw["yield_6m"].to_numpy()

    mensais = pd.read_csv(INSTR_PATH, parse_dates=["month"])
    z_jk_map  = dict(zip(mensais["month"], mensais["z_het_jk"]))
    z_pur_map = dict(zip(mensais["month"], mensais["z_jk_purif"]))
    months_target = pd.to_datetime(target_dates).dt.to_period("M").dt.to_timestamp()
    z_het_jk   = months_target.map(z_jk_map).to_numpy(dtype=float)
    z_jk_purif = months_target.map(z_pur_map).to_numpy(dtype=float)

    innov = residualize_ar(target_series, n_lags=N_LAGS)

    obs = first_stage_F(z_het_jk, innov)
    print(f"[Python] Observed F = {obs['F']:.6f}  (n={obs['n']}, beta={obs['beta']:.6e}, "
          f"se={obs['se']:.6e}, r2={obs['r2']:.6f})")

    F_perm = placebo(z_het_jk, innov)
    p_placebo = float(np.mean(F_perm >= obs["F"]))
    placebo_summary = pd.DataFrame([{
        "test":       "placebo",
        "n_perm":     N_PERM,
        "observed_F": obs["F"],
        "mean_F":     float(np.nanmean(F_perm)),
        "median_F":   float(np.nanmedian(F_perm)),
        "q95_F":      float(np.nanquantile(F_perm, 0.95)),
        "q99_F":      float(np.nanquantile(F_perm, 0.99)),
        "max_F":      float(np.nanmax(F_perm)),
        "pvalue":     p_placebo,
    }])
    placebo_summary.to_csv(OUT_DIR / "referee2_validation_placebo.csv", index=False)
    print(f"[Python] Placebo p-value = {p_placebo:.4f}  (mean F = {placebo_summary['mean_F'].iloc[0]:.4f})")

    sub = subperiod_F(z_het_jk, innov, target_dates, WINDOWS)
    sub.to_csv(OUT_DIR / "referee2_validation_subperiod.csv", index=False)
    print("[Python] Sub-period F:")
    print(sub.to_string(index=False))

    cor = correlation_subsets(mensais["z_het_jk"].to_numpy(), mensais["z_jk_purif"].to_numpy())
    cor.to_csv(OUT_DIR / "referee2_validation_correlation.csv", index=False)
    print("[Python] Correlation:")
    print(cor.to_string(index=False))


if __name__ == "__main__":
    main()
