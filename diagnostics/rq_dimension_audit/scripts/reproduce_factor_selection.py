from pathlib import Path

import numpy as np
import pandas as pd


out_dir = Path("diagnostics/rq_dimension_audit/output")
panel_dir = out_dir / "panels"
r_selection = pd.read_csv(out_dir / "r_selection.csv")
r_bai_ng = pd.read_csv(out_dir / "r_bai_ng_criteria.csv")
r_aw = pd.read_csv(out_dir / "r_aw_criteria.csv")
r_bai_eigen = pd.read_csv(out_dir / "r_bai_ng_eigenvalues.csv")
r_aw_eigen = pd.read_csv(out_dir / "r_aw_eigenvalues.csv")

selection_rows = []
bai_rows = []
aw_rows = []
bai_eigen_rows = []
aw_eigen_rows = []

for panel_path in sorted(panel_dir.glob("*.csv.gz")):
    variant = panel_path.name.removesuffix(".csv.gz")
    panel = pd.read_csv(panel_path, parse_dates=["ref.date"])
    dates = panel.pop("ref.date")
    assert panel.shape[0] == 153
    assert dates.is_monotonic_increasing and not dates.duplicated().any()
    assert np.isfinite(panel.to_numpy()).all()

    samples = {
        "full": panel.to_numpy(dtype=float),
        "pre_covid": panel.loc[dates <= "2019-12-01"].to_numpy(dtype=float),
    }
    for sample_name, data in samples.items():
        differences = np.diff(data, axis=0)
        standard_deviations = differences.std(axis=0, ddof=1)
        assert np.isfinite(standard_deviations).all()
        assert (standard_deviations > 0).all()
        standardized = (differences - differences.mean(axis=0)) / standard_deviations

        _, singular_values, right_vectors = np.linalg.svd(
            standardized,
            full_matrices=False,
        )
        n_periods, n_series = standardized.shape
        total_sum_squares = np.square(singular_values).sum()
        residual_variances = (
            total_sum_squares - np.cumsum(np.square(singular_values[:20]))
        ) / (n_periods * n_series)
        r_values = np.arange(1, 21)
        dimension_penalty = (n_series + n_periods) / (n_series * n_periods)
        ic1 = np.log(residual_variances) + r_values * dimension_penalty * np.log(
            1 / dimension_penalty
        )
        ic2 = np.log(residual_variances) + r_values * dimension_penalty * np.log(
            min(n_series, n_periods)
        )
        ic3 = np.log(residual_variances) + r_values * np.log(
            min(n_series, n_periods)
        ) / min(n_series, n_periods)
        r_ic1 = int(np.argmin(ic1) + 1)
        r_ic2 = int(np.argmin(ic2) + 1)
        r_ic3 = int(np.argmin(ic3) + 1)

        factor_scores = standardized @ right_vectors[:r_ic2].T
        lag_rows = []
        for index in range(6, n_periods):
            lag_rows.append(
                np.concatenate(
                    [factor_scores[index - lag] for lag in range(1, 7)]
                )
            )
        design = np.column_stack([np.ones(n_periods - 6), np.vstack(lag_rows)])
        dependent = standardized[6:]
        coefficients = np.linalg.solve(design.T @ design, design.T @ dependent)
        residuals = dependent - design @ coefficients
        _, aw_singular_values, _ = np.linalg.svd(residuals, full_matrices=False)
        aw_periods, aw_series = residuals.shape
        aw_total_sum_squares = np.square(aw_singular_values).sum()
        aw_residual_variances = (
            aw_total_sum_squares
            - np.cumsum(np.square(aw_singular_values[:r_ic2]))
        ) / (aw_periods * aw_series)
        q_values = np.arange(1, r_ic2 + 1)
        aw_dimension_penalty = (aw_series + aw_periods) / (aw_series * aw_periods)
        aw_ic2 = np.log(aw_residual_variances) + q_values * aw_dimension_penalty * np.log(
            min(aw_series, aw_periods)
        )
        q_hat = int(np.argmin(aw_ic2) + 1)

        selection_rows.append(
            {
                "variant": variant,
                "sample": sample_name,
                "n_series": n_series,
                "n_months": data.shape[0],
                "r_ic1": r_ic1,
                "r_ic2": r_ic2,
                "r_ic3": r_ic3,
                "q_aw_ic2": q_hat,
            }
        )
        for r_value in r_values:
            bai_rows.append(
                {
                    "variant": variant,
                    "sample": sample_name,
                    "r": r_value,
                    "ic1": ic1[r_value - 1],
                    "ic2": ic2[r_value - 1],
                    "ic3": ic3[r_value - 1],
                }
            )
            bai_eigen_rows.append(
                {
                    "variant": variant,
                    "sample": sample_name,
                    "component": r_value,
                    "eigenvalue": np.square(singular_values[r_value - 1])
                    / (n_periods - 1),
                }
            )
        for q_value in q_values:
            aw_rows.append(
                {
                    "variant": variant,
                    "sample": sample_name,
                    "q": q_value,
                    "aw_ic2": aw_ic2[q_value - 1],
                }
            )
            aw_eigen_rows.append(
                {
                    "variant": variant,
                    "sample": sample_name,
                    "component": q_value,
                    "eigenvalue": np.square(aw_singular_values[q_value - 1])
                    / (aw_periods - 1),
                }
            )

python_selection = pd.DataFrame(selection_rows).sort_values(["variant", "sample"])
python_bai = pd.DataFrame(bai_rows).sort_values(["variant", "sample", "r"])
python_aw = pd.DataFrame(aw_rows).sort_values(["variant", "sample", "q"])
python_bai_eigen = pd.DataFrame(bai_eigen_rows).sort_values(
    ["variant", "sample", "component"]
)
python_aw_eigen = pd.DataFrame(aw_eigen_rows).sort_values(
    ["variant", "sample", "component"]
)

assert python_selection.reset_index(drop=True).equals(
    r_selection.sort_values(["variant", "sample"]).reset_index(drop=True)
)

comparisons = {
    "bai_ng_criteria": (
        python_bai[["ic1", "ic2", "ic3"]].to_numpy(),
        r_bai_ng.sort_values(["variant", "sample", "r"])[
            ["ic1", "ic2", "ic3"]
        ].to_numpy(),
    ),
    "aw_criteria": (
        python_aw[["aw_ic2"]].to_numpy(),
        r_aw.sort_values(["variant", "sample", "q"])[["aw_ic2"]].to_numpy(),
    ),
    "bai_ng_eigenvalues": (
        python_bai_eigen[["eigenvalue"]].to_numpy(),
        r_bai_eigen.sort_values(["variant", "sample", "component"])[
            ["eigenvalue"]
        ].to_numpy(),
    ),
    "aw_eigenvalues": (
        python_aw_eigen[["eigenvalue"]].to_numpy(),
        r_aw_eigen.sort_values(["variant", "sample", "component"])[
            ["eigenvalue"]
        ].to_numpy(),
    ),
}

comparison_rows = []
for quantity, (python_values, r_values) in comparisons.items():
    absolute_difference = np.abs(python_values - r_values)
    tolerance = 1e-10 + 1e-9 * np.maximum(np.abs(python_values), np.abs(r_values))
    comparison_rows.append(
        {
            "quantity": quantity,
            "n_values": python_values.size,
            "max_absolute_difference": absolute_difference.max(),
            "max_tolerance_ratio": np.max(absolute_difference / tolerance),
            "passed": bool(np.all(absolute_difference <= tolerance)),
        }
    )

comparison = pd.DataFrame(comparison_rows)
assert comparison["passed"].all()
comparison.to_csv(out_dir / "cross_language_comparison.csv", index=False)
python_selection.to_csv(out_dir / "python_selection.csv", index=False)
python_bai.to_csv(out_dir / "python_bai_ng_criteria.csv", index=False)
python_aw.to_csv(out_dir / "python_aw_criteria.csv", index=False)
print(comparison.to_string(index=False))
