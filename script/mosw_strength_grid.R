# ===================================================================
# MOSW instrument-strength grid of Montiel Olea, Stock & Watson
# (2021, sec. 4.2) over (r,q) x sample x instrument.
# For each cell reports xi_mp and the robust first-stage F in the same
# yield_6m-impact direction.
# One estimate_dfm per (sample, r, q); instruments enter only the
# cheap projection/diagnostic step.
# Output: output/instrument/mosw_strength_grid.csv
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")


# ---- Config --------------------------------------------------------

SPEC <- production_spec()
P_LAGS <- 4L
MP_VAR <- SPEC$mp_var

# The three construction layers reported in the paper's first-stage table
# (tab:first_stage): raw DI surprise, + predetermined orthogonalization,
# + signal filter (production).
INSTRUMENTS <- c("z_bruto", "z_bs_purif", "z_jk_bs_purif")

SAMPLES <- list(
  full = SPEC$sample,
  pre_covid = SPEC$pre_covid_sample
)

# The full window runs the production Lenza-Primiceri scale, and under it the
# factor VAR is explosive from r = 7 up at every q (max root 1.001362 at r = 7,
# 1.001318 at r = 8, against 0.983677 at the production r = 5). Those cells
# cannot be reported, so the full window sweeps r = 4:6; the pre-COVID window
# has s_t = 1 in every month, is stable throughout, and keeps r = 4:8.
RQ_GRID_BY_SAMPLE <- list(
  full = dplyr::filter(tidyr::expand_grid(r = 4:6, q = 2:8), q <= r),
  pre_covid = dplyr::filter(tidyr::expand_grid(r = 4:8, q = 2:8), q <= r)
)

OUT_DIR <- "output/instrument"

CHI2_1_95 <- qchisq(0.95, df = 1)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
mp_idx <- match(MP_VAR, colnames(data_mat))
if (is.na(mp_idx)) {
  stop("Policy normalization variable is missing from the production panel")
}

inst_panel <- readr::read_csv(SPEC$instrument_path, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)


# ---- Grid ----------------------------------------------------------

grid <- purrr::map_dfr(names(SAMPLES), function(sample_name) {
  win <- SAMPLES[[sample_name]]
  in_window <- dates >= win[1] & dates <= win[2]
  data_sub <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]
  expected_n_obs <- nrow(data_sub) - P_LAGS

  purrr::pmap_dfr(RQ_GRID_BY_SAMPLE[[sample_name]], function(r, q) {
    dfm <- estimate_dfm(
      data_sub,
      r = r,
      q = q,
      p = P_LAGS,
      dates = dates_sub,
      # The full window runs the production Lenza-Primiceri scale, so xi_mp of
      # record is the one the published IRFs are built on. The pre-COVID
      # window has s_t = 1 in every month, so it is the same fit either way,
      # and estimate_dfm() rejects a covid_start outside its residual months.
      covid_volatility = if (sample_name == "full") SPEC$covid_volatility else NULL
    )

    if (!isTRUE(dfm$diagnostics$is_stable) ||
        !is.finite(dfm$diagnostics$max_eigenvalue)) {
      stop(sprintf("Numerically unstable DFM at (%s, r=%d, q=%d, p=%d)",
                   sample_name, r, q, P_LAGS))
    }

    purrr::map_dfr(INSTRUMENTS, function(instrument) {
      inst_df <- data.frame(
        month = inst_panel$month,
        shock = inst_panel[[instrument]]
      ) |>
        tidyr::drop_na(shock)

      diag_fs <- diagnose_instrument_in_factor_space(
        dfm,
        inst_df,
        dates_sub,
        P_LAGS,
        mp_idx
      )

      if (!all(is.finite(c(diag_fs$wald_mp, diag_fs$f_robust_mp))) ||
          diag_fs$n_obs != expected_n_obs) {
        stop(sprintf(
          "Invalid MOSW diagnostic at (%s, r=%d, q=%d, p=%d, %s): n_obs=%d",
          sample_name, r, q, P_LAGS, instrument, diag_fs$n_obs
        ))
      }

      data.frame(
        sample = sample_name,
        r = r,
        q = q,
        instrument = instrument,
        n_obs = diag_fs$n_obs,
        f_robust_mp = diag_fs$f_robust_mp,
        wald_mp = diag_fs$wald_mp,
        ar_bounded = diag_fs$wald_mp > CHI2_1_95,
        stringsAsFactors = FALSE
      )
    })
  })
})

readr::write_csv(grid, file.path(OUT_DIR, "mosw_strength_grid.csv"))
