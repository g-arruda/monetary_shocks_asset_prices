# ===================================================================
# Why DBGG and the Focus GDP expectation depart from production in the
# pre-COVID window of fig:precovid_sensibilidade (advisor's e-mail of 30-09,
# item 3). Diagnostics only: nothing here is an alternative estimator. The
# production cell, (5,5,4), z_bs_purif, +50bp on yield_6m, and its pre-COVID
# counterpart, in four blocks:
#   - anatomy: communality of every series; January's share of the sum of
#     squares of each Focus series' monthly change (the "ano seguinte" series
#     of the panel switched target year every January, until the
#     fixed-horizon approximation of 2026-10-03); the months that weigh most in the
#     changes of DBGG and of the Focus GDP expectation; each month's share
#     of sum(z^2) over the residual months;
#   - co-movement of the changes of DBGG and of the 6-month DI by subperiod;
#   - leverage: the responses with the instrument zeroed in January 2016 and
#     2017, in every January, and in October 2014;
#   - loadings by subset of months: the cell's factors, VAR and shock held
#     fixed, each series' loading re-estimated over a subset of months.
# Output: output/irf/precovid_divergence.csv,
#         output/irf/precovid_divergence_anatomia.csv
# Note: notas/2026-10-01_precovid_dbgg_focus_pib.md
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/dfm_pipeline.R")
source("R/reporting/sensitivity.R")
source("R/identification/weak_iv_ar.R")

PANEL_PATH      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT_PATH <- "data/processed/instrumentos_mensais.csv"
THETA_PATH      <- "output/factors/covid_volatility_theta.csv"
COHERENCE_PATH  <- "output/irf/irf_coherence_h.csv"
PRE_COVID_PATH  <- "output/irf/precovid_sensitivity.csv"
RESPONSES_CSV   <- "output/irf/precovid_divergence.csv"
ANATOMY_CSV     <- "output/irf/precovid_divergence_anatomia.csv"
SAMPLE_START  <- as.Date("2012-03-01")
FULL_END      <- as.Date("2025-12-01")
PRE_COVID_END <- as.Date("2019-12-01")
COVID_START   <- as.Date("2020-03-01")
COVID_ERA_END <- as.Date("2022-12-01")
R_FACTORS  <- 5L
Q_FACTORS  <- 5L
P_LAGS     <- 4L
INSTRUMENT <- "z_bs_purif"
MP_VAR     <- "yield_6m"
HORIZON    <- 36L
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.80, 0.90)
AR_NW_LAGS <- 0L
PRODUCTION_LABEL <- "Produção"
PRE_COVID_LABEL  <- "Pré-COVID"
BASE_LABEL       <- "base"
ALL_MONTHS_LABEL <- "todos os meses"
# The eight series of every Anexo C figure
PAPER_SERIES <- c(
  "yield_6m", "yield_2y", "cambio_usd", "cds_5y", "expect_focus_pib_12m",
  "expect_focus_ipca12m", "expect_focus_selic_12m", "fiscal_dbgg"
)
TOP_MONTH_SERIES <- c("fiscal_dbgg", "expect_focus_pib_12m")
TOP_MONTHS <- 5L
COMOVEMENT_PAIR <- c("fiscal_dbgg", "yield_6m")
SUBPERIODS <- tibble::tibble(
  period = c("2012-04 a 2014-06", "2014-07 a 2016-12", "2017-01 a 2020-02",
             "2020-03 a 2022-12", "2023-01 a 2025-12"),
  start = as.Date(c("2012-04-01", "2014-07-01", "2017-01-01", "2020-03-01",
                    "2023-01-01")),
  end = as.Date(c("2014-06-01", "2016-12-01", "2020-02-01", "2022-12-01",
                  "2025-12-01"))
)

raw_data <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)
tcode <- infer_tcode_from_varnames(var_names)
focus_series <- stringr::str_subset(var_names, "^expect_focus_")

inst_panel <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::mutate(month = as.Date(month))

covid_volatility <- read_covid_volatility(THETA_PATH)

windows <- tibble::tibble(
  window = c(PRODUCTION_LABEL, PRE_COVID_LABEL),
  sample_end = c(FULL_END, PRE_COVID_END)
)
zeroed_months <- tibble::tibble(
  variant = c(BASE_LABEL, "sem jan/2016 e jan/2017", "sem janeiros",
              "sem out/2014"),
  months = list(
    as.Date(character()),
    as.Date(c("2016-01-01", "2017-01-01")),
    inst_panel$month[lubridate::month(inst_panel$month) == 1L],
    as.Date("2014-10-01")
  )
)
CELLS <- tidyr::expand_grid(windows, zeroed_months)

# ---- Anatomy -------------------------------------------------------------

statics <- purrr::map(windows$sample_end, function(sample_end) {
  estimate_static_factors(
    data_mat[dates >= SAMPLE_START & dates <= sample_end, ],
    R_FACTORS
  )
})
# The standardized changes yy have one row per month from the window's second
change_months <- purrr::map(windows$sample_end, function(sample_end) {
  dates[dates > SAMPLE_START & dates <= sample_end]
})

anatomy <- purrr::pmap(
  list(windows$window, windows$sample_end, statics, change_months),
  function(window, sample_end, static, months) {
    yy <- static$yy
    common_part <- yy %*% static$loadings %*% t(static$loadings)
    is_january <- lubridate::month(months) == 1L

    communality <- tibble::tibble(
      measure = "comunalidade",
      variable = var_names,
      period = NA_character_,
      value = colSums(common_part^2) / colSums(yy^2)
    )
    january_share <- tibble::tibble(
      measure = "participacao_janeiro",
      variable = focus_series,
      period = NA_character_,
      value = colSums(yy[is_january, focus_series]^2) /
        colSums(yy[, focus_series]^2)
    )
    month_share <- purrr::map(TOP_MONTH_SERIES, function(variable) {
      share <- yy[, variable]^2 / sum(yy[, variable]^2)
      top <- order(share, decreasing = TRUE)[seq_len(TOP_MONTHS)]
      tibble::tibble(
        measure = "participacao_mes",
        variable = variable,
        period = format(months[top]),
        value = share[top]
      )
    }) |>
      purrr::list_rbind()
    # H reads the instrument on the factor-VAR residual months only
    residual_months <- dates[dates >= SAMPLE_START & dates <= sample_end][
      -seq_len(P_LAGS)
    ]
    instrument_share <- inst_panel |>
      dplyr::filter(month %in% residual_months, .data[[INSTRUMENT]] != 0) |>
      dplyr::transmute(
        measure = "participacao_z2",
        variable = INSTRUMENT,
        period = format(month),
        value = .data[[INSTRUMENT]]^2 / sum(.data[[INSTRUMENT]]^2)
      ) |>
      dplyr::arrange(dplyr::desc(value))

    dplyr::bind_rows(
      communality,
      january_share,
      month_share,
      instrument_share
    ) |>
      dplyr::mutate(window = window, .before = 1)
  }
) |>
  purrr::list_rbind()

# Co-movement of the two changes over the production window: correlation
# within each subperiod, and each subperiod's share of the full-window
# covariance, both demeaned over the full window
production_yy <- statics[[1]]$yy[, COMOVEMENT_PAIR]
cross_product <- production_yy[, 1] * production_yy[, 2]
comovement <- purrr::pmap(SUBPERIODS, function(period, start, end) {
  in_period <- change_months[[1]] >= start & change_months[[1]] <= end
  tibble::tibble(
    window = PRODUCTION_LABEL,
    measure = c("correlacao_dbgg_di6m", "fracao_cov_dbgg_di6m"),
    variable = paste(COMOVEMENT_PAIR, collapse = " x "),
    period = period,
    value = c(
      cor(production_yy[in_period, 1], production_yy[in_period, 2]),
      sum(cross_product[in_period]) / sum(cross_product)
    )
  )
}) |>
  purrr::list_rbind()

readr::write_csv(dplyr::bind_rows(anatomy, comovement), ANATOMY_CSV)

# ---- Leverage: the instrument zeroed in chosen months --------------------

cells <- purrr::pmap(CELLS, function(window, sample_end, variant, months) {
  is_production <- sample_end == FULL_END
  zeroed_panel <- inst_panel |>
    dplyr::mutate(
      !!INSTRUMENT := dplyr::if_else(month %in% months, 0, .data[[INSTRUMENT]])
    )
  run_stage2_cell(
    data_mat,
    dates,
    zeroed_panel,
    sample_window = c(SAMPLE_START, sample_end),
    r = R_FACTORS,
    q = Q_FACTORS,
    p = P_LAGS,
    instrument = INSTRUMENT,
    mp_var = MP_VAR,
    h = HORIZON,
    shock_bps = SHOCK_BPS,
    tcode = tcode,
    ci_levels = CI_LEVELS,
    inference = if (is_production && variant == BASE_LABEL) "ar" else "none",
    ar_nw_lags = AR_NW_LAGS,
    # The pre-COVID window has s_t = 1 throughout and estimate_dfm() rejects
    # the scale there: ordinary least squares is the treated fit
    covid_volatility = if (is_production) covid_volatility else NULL
  )
})

max_roots <- purrr::map_dbl(cells, "dfm_max_eig")
stopifnot(all(max_roots < 1))

is_base <- CELLS$variant == BASE_LABEL
base_cells <- cells[is_base]

# The production base cell is section 4's line, the pre-COVID one the
# dashed line of fig:precovid_sensibilidade
stack_cell_paths(
  base_cells[1],
  PRODUCTION_LABEL,
  PRODUCTION_LABEL,
  PAPER_SERIES
) |>
  stop_unless_matches_cache(COHERENCE_PATH, PAPER_SERIES, HORIZON)
published_pre_covid <- readr::read_csv(PRE_COVID_PATH, show_col_types = FALSE) |>
  dplyr::filter(cell == PRE_COVID_LABEL)
pre_covid_point <- base_cells[[2]]$irf$irf_point_matrix[
  cbind(
    match(published_pre_covid$variable, var_names),
    published_pre_covid$h + 1L
  )
]
stopifnot(max(abs(pre_covid_point - published_pre_covid$point)) < 1e-10)

zeroed_responses <- purrr::map(windows$window, function(window) {
  in_window <- CELLS$window == window
  stack_cell_paths(
    cells[in_window],
    CELLS$variant[in_window],
    BASE_LABEL,
    PAPER_SERIES
  ) |>
    dplyr::transmute(
      exercise = "instrumento_zerado",
      window = window,
      variant = as.character(cell),
      variable,
      h,
      point
    )
}) |>
  purrr::list_rbind()

# ---- Loadings by subset of months ----------------------------------------

loading_responses <- purrr::pmap(
  list(windows$window, statics, change_months, base_cells),
  function(window, static, months, cell) {
    point <- cell$irf$irf_point_matrix
    level_rows <- tcode == 1L

    # Every response is sy_i lambda_i' f_h (DFMest_BLL.m), f_h the static
    # factors' response; on the untransformed level rows least squares gives
    # f_h back exactly
    factor_responses <- qr.solve(
      static$loadings[level_rows, ],
      point[level_rows, ] / static$sy[level_rows]
    )
    stopifnot(
      max(abs(
        static$sy[level_rows] * static$loadings[level_rows, ] %*%
          factor_responses - point[level_rows, ]
      )) < 1e-10
    )

    # The factors' changes are yy Lambda, so regressing a series' change on
    # them over every month returns its loading; over a subset of months it
    # returns the loading that subset alone would give
    factor_changes <- static$yy %*% static$loadings
    in_covid_era <- months >= COVID_START & months <= COVID_ERA_END
    subsets <- list(
      rep(TRUE, length(months)),
      lubridate::month(months) != 1L,
      months < COVID_START,
      in_covid_era,
      !in_covid_era
    ) |>
      purrr::set_names(c(
        ALL_MONTHS_LABEL, "sem janeiros", "meses pré-COVID", "2020-03 a 2022-12",
        "sem 2020-03 a 2022-12"
      ))
    # In the pre-COVID window the last three are empty or every month
    if (window == PRE_COVID_LABEL) {
      subsets <- subsets[c(ALL_MONTHS_LABEL, "sem janeiros")]
    }

    responses <- purrr::imap(subsets, function(in_subset, subset) {
      loadings <- qr.solve(
        factor_changes[in_subset, ],
        static$yy[in_subset, PAPER_SERIES]
      )
      response <- static$sy[PAPER_SERIES] * t(loadings) %*% factor_responses
      tibble::tibble(
        exercise = "carga_por_subconjunto",
        window = window,
        variant = subset,
        variable = rep(PAPER_SERIES, times = ncol(response)),
        h = rep(seq_len(ncol(response)) - 1L, each = nrow(response)),
        point = as.vector(response)
      )
    }) |>
      purrr::list_rbind()

    every_month <- dplyr::filter(responses, variant == ALL_MONTHS_LABEL)
    stopifnot(
      max(abs(
        every_month$point -
          point[cbind(match(every_month$variable, var_names), every_month$h + 1L)]
      )) < 1e-10
    )
    responses
  }
) |>
  purrr::list_rbind()

readr::write_csv(
  dplyr::bind_rows(zeroed_responses, loading_responses),
  RESPONSES_CSV
)
