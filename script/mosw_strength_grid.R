# ===================================================================
# MOSW instrument-strength grid of Montiel Olea, Stock & Watson
# (2021, sec. 4.2) over (r,q) x sample x instrument.
# For each cell reports xi_mp and the robust first-stage F in the same
# yield_6m-impact direction.
# One estimate_dfm per (sample, r, q); instruments enter only the
# cheap projection/diagnostic step.
# Output: output/instrument/mosw_strength_grid.csv
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
OUT_DIR         <- "output/instrument"
P_LAGS <- 4L
MP_VAR <- "yield_6m"

# The three construction layers reported in the paper's first-stage table
# (tab:first_stage): raw DI surprise, + predetermined orthogonalization,
# + signal filter (production).
INSTRUMENTS <- c("z_bruto", "z_bs_purif", "z_jk_bs_purif")

SAMPLES <- list(
  full = as.Date(c("2012-03-01", "2025-12-01")),
  pre_covid = as.Date(c("2012-03-01", "2019-12-01"))
)

# The full window runs the production Lenza-Primiceri scale, and under it the
# factor VAR is explosive from r = 7 up at every q (max root 1.001362 at r = 7,
# 1.001318 at r = 8, against 0.983676 at the production r = 5). Those cells
# cannot be reported, so the full window sweeps r = 4:6; the pre-COVID window
# has s_t = 1 in every month, is stable throughout, and keeps r = 4:8.
RQ_GRID_BY_SAMPLE <- list(
  full = dplyr::filter(tidyr::expand_grid(r = 4:6, q = 2:8), q <= r),
  pre_covid = dplyr::filter(tidyr::expand_grid(r = 4:8, q = 2:8), q <= r)
)

CHI2_1_95 <- qchisq(0.95, df = 1)

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
mp_index <- match(MP_VAR, colnames(data_mat))
if (is.na(mp_index)) {
  stop("Policy normalization variable is missing from the production panel")
}

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))

# The full window runs the production Lenza-Primiceri scale, so the xi_mp of
# record is the one the published IRFs are built on. The pre-COVID window has
# s_t = 1 in every month, so it is the same fit either way, and estimate_dfm()
# rejects a covid_start outside its residual months.
covid_volatility_by_sample <- list(
  full = read_covid_volatility(THETA_PATH),
  pre_covid = NULL
)

grid <- purrr::map(names(SAMPLES), function(sample_name) {
  sample_window <- SAMPLES[[sample_name]]
  in_window <- dates >= sample_window[1] & dates <= sample_window[2]
  data_sub <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]

  purrr::pmap(RQ_GRID_BY_SAMPLE[[sample_name]], function(r, q) {
    dfm <- estimate_dfm(
      data_sub,
      r = r,
      q = q,
      p = P_LAGS,
      dates = dates_sub,
      covid_volatility = covid_volatility_by_sample[[sample_name]]
    )

    if (!isTRUE(dfm$diagnostics$is_stable) ||
        !is.finite(dfm$diagnostics$max_eigenvalue)) {
      stop(sprintf(
        "Numerically unstable DFM at (%s, r=%d, q=%d, p=%d)",
        sample_name, r, q, P_LAGS
      ))
    }

    purrr::map(INSTRUMENTS, function(instrument) {
      inst_df <- inst_panel |>
        dplyr::transmute(month, shock = .data[[instrument]]) |>
        tidyr::drop_na(shock)

      first_stage <- diagnose_instrument_in_factor_space(
        dfm,
        inst_df,
        dates_sub,
        P_LAGS,
        mp_index
      )

      tibble::tibble(
        sample = sample_name,
        r = r,
        q = q,
        instrument = instrument,
        n_obs = first_stage$n_obs,
        f_robust_mp = first_stage$f_robust_mp,
        wald_mp = first_stage$wald_mp,
        ar_bounded = first_stage$wald_mp > CHI2_1_95
      )
    }) |>
      purrr::list_rbind()
  }) |>
    purrr::list_rbind()
}) |>
  purrr::list_rbind()

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
readr::write_csv(grid, file.path(OUT_DIR, "mosw_strength_grid.csv"))
