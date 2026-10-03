# ===================================================================
# Step 0/5 of the advisor's plan of 2026-10-03: how much the six Focus annual
# series of the panel change when the next-year medians become the
# fixed-horizon approximation of Dovern, Fritsche and Slacalek (2012), and
# how much the production cell changes with them. The baseline is main at
# BASELINE_COMMIT, read from git: the panel with the "ano seguinte" series.
# The new cell is this branch's production, as written by
# script/covid_volatility_theta.R, script/model_alessi.R,
# script/irf_coherence_check.R, script/instrument_diagnostics.R and
# script/validation/validate_production_spec.R, which must run first.
# Nothing is estimated here.
# Output: output/focus_fixed_horizon/
#   series.csv, january_share.csv   the six series, old and new
#   model.csv                       theta, roots, strength, r and p selectors
#   irf_table.csv                   eight series at the horizons below
#   irf_outside.csv                 by series: new points outside the old
#                                   90% set, horizons whose sets exclude zero
#   irf_significance_by_h.csv       the same counts by horizon, every series
#   series.pdf, irf.pdf
# Note: notas/2026-10-03_focus_horizonte_fixo.md
# ===================================================================

source("R/reporting/figures.R")
source("R/reporting/sensitivity.R")

# Last commit of main before the fixed-horizon panel
BASELINE_COMMIT <- "d9ac7f0"
OUT_DIR <- "output/focus_fixed_horizon"
FOCUS_SERIES <- c(
  "expect_focus_selic",
  "expect_focus_pib",
  "expect_focus_cambio",
  "expect_focus_fiscal_dlsp",
  "expect_focus_fiscal_primary_balance",
  "expect_focus_fiscal_nominal_balance"
)
SERIES_LABELS <- c(
  expect_focus_selic = "Selic (%)",
  expect_focus_pib = "PIB (%)",
  expect_focus_cambio = "Câmbio (R$/US$)",
  expect_focus_fiscal_dlsp = "DLSP (% do PIB)",
  expect_focus_fiscal_primary_balance = "Resultado primário (% do PIB)",
  expect_focus_fiscal_nominal_balance = "Resultado nominal (% do PIB)"
)
PRE_COVID_END <- as.Date("2019-12-01")
# The horizons step 1/5 fixes before looking at the results, plus the end of
# the window section 4 reads
H_TABLE <- c(0L, 1L, 3L, 6L, 12L, 24L, 36L)
H_MAX <- 36L
OLD_LABEL <- "ano seguinte (main)"
NEW_LABEL <- "horizonte fixo"
# Labels and scales of script/fig_section5.R, the eight series of Anexo C
PAPER_PANELS <- tibble::tribble(
  ~variable,                ~label,                       ~scale,
  "yield_6m",               "DI 6 meses (p.b.)",          1e4,
  "yield_2y",               "DI 2 anos (p.b.)",           1e4,
  "cambio_usd",             "Câmbio BRL/USD (R$/US$)",    1,
  "cds_5y",                 "CDS 5 anos (p.b.)",          1,
  "expect_focus_pib_12m",   "Focus PIB (p.p.)",           1,
  "expect_focus_ipca12m",   "Focus IPCA 12 meses (p.p.)", 1,
  "expect_focus_selic_12m", "Focus Selic (p.p.)",         1,
  "fiscal_dbgg",            "DBGG (p.p. do PIB)",         1
)

#' Copy a file as it stands at BASELINE_COMMIT to a temporary path
#'
#' `output/` is tracked, so main's production outputs are read from git
#' rather than kept as copies beside this branch's.
#'
#' @param path Path in the repository.
#'
#' @return Path of the temporary copy.
#'
#' @examples
#' old_theta <- readr::read_csv(baseline_file("output/factors/covid_volatility_theta.csv"))
baseline_file <- function(path) {
  copy <- tempfile(fileext = paste0(".", tools::file_ext(path)))
  system2(
    "git",
    c("show", paste0(BASELINE_COMMIT, ":", path)),
    stdout = copy
  )
  copy
}

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# Series ----

panel <- readr::read_csv(
  "data/processed/data_log_deseasonalized.csv",
  show_col_types = FALSE
)
next_year <- readr::read_csv("data/raw/raw_data.csv", show_col_types = FALSE) |>
  dplyr::left_join(
    readr::read_csv(
      "data/raw/focus_fiscal_expectations.csv",
      show_col_types = FALSE
    ),
    by = "ref.date"
  ) |>
  dplyr::select(ref.date, dplyr::all_of(paste0(FOCUS_SERIES, "_ny")))

series <- panel |>
  dplyr::select(ref.date, dplyr::all_of(paste0(FOCUS_SERIES, "_12m"))) |>
  dplyr::left_join(next_year, by = "ref.date") |>
  tidyr::pivot_longer(
    -ref.date,
    names_to = c("series", "version"),
    names_pattern = "(.*)_(ny|12m)"
  ) |>
  tidyr::pivot_wider(names_from = version, values_from = value) |>
  dplyr::rename(next_year = ny, fixed_horizon = `12m`) |>
  dplyr::arrange(series, ref.date)
readr::write_csv(series, file.path(OUT_DIR, "series.csv"))

# Share of January in the sum of squares of the monthly changes, the measure
# of notas/2026-10-01_precovid_dbgg_focus_pib.md (1/12 without concentration)
january_share <- series |>
  tidyr::pivot_longer(
    c(next_year, fixed_horizon),
    names_to = "version",
    values_to = "value"
  ) |>
  dplyr::group_by(series, version) |>
  dplyr::mutate(change = value - dplyr::lag(value)) |>
  dplyr::filter(!is.na(change)) |>
  dplyr::mutate(january = lubridate::month(ref.date) == 1L) |>
  dplyr::summarise(
    full = sum(change[january]^2) / sum(change^2),
    pre_covid = sum(change[january & ref.date <= PRE_COVID_END]^2) /
      sum(change[ref.date <= PRE_COVID_END]^2),
    .groups = "drop"
  ) |>
  tidyr::pivot_wider(
    names_from = version,
    values_from = c(full, pre_covid)
  ) |>
  dplyr::left_join(
    series |>
      dplyr::group_by(series) |>
      dplyr::summarise(
        cor_level = cor(next_year, fixed_horizon),
        cor_change = cor(diff(next_year), diff(fixed_horizon))
      ),
    by = "series"
  )
readr::write_csv(january_share, file.path(OUT_DIR, "january_share.csv"))

series_plot <- series |>
  tidyr::pivot_longer(
    c(next_year, fixed_horizon),
    names_to = "version",
    values_to = "value"
  ) |>
  dplyr::mutate(
    series = factor(SERIES_LABELS[series], levels = SERIES_LABELS),
    version = factor(
      dplyr::if_else(version == "next_year", OLD_LABEL, NEW_LABEL),
      levels = c(OLD_LABEL, NEW_LABEL)
    )
  ) |>
  ggplot2::ggplot(ggplot2::aes(x = ref.date, y = value, colour = version)) +
  ggplot2::geom_line(linewidth = 0.5) +
  ggplot2::facet_wrap(ggplot2::vars(series), ncol = 2, scales = "free_y") +
  ggplot2::scale_colour_manual(values = c("grey55", "black")) +
  ggplot2::labs(x = NULL, y = NULL, colour = NULL) +
  ggplot2::theme_classic(base_size = 10) +
  ggplot2::theme(
    legend.position = "bottom",
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(face = "bold")
  )
ggplot2::ggsave(
  file.path(OUT_DIR, "series.pdf"),
  series_plot,
  width = 8,
  height = 7,
  device = cairo_pdf
)

# Model ----

model_files <- c(
  theta = "output/factors/covid_volatility_theta.csv",
  diagnostics = "output/validation/production_spec_diagnostics.csv",
  bai_ng = "output/factors/production_bai_ng_bll_surface.csv",
  lag_criteria = "output/validation/production_factor_lag_criteria.csv",
  instrument = "output/instrument/instrument_diagnostics.csv"
)
model_tables <- purrr::map(model_files, function(path) {
  list(
    old = readr::read_csv(baseline_file(path), show_col_types = FALSE),
    new = readr::read_csv(path, show_col_types = FALSE)
  )
})

model <- purrr::map(c("old", "new"), function(version) {
  theta <- model_tables$theta[[version]]
  diagnostics <- model_tables$diagnostics[[version]]
  bai_ng <- model_tables$bai_ng[[version]]
  lag_criteria <- model_tables$lag_criteria[[version]]
  instrument <- model_tables$instrument[[version]]
  dplyr::bind_rows(
    tibble::tibble(
      quantity = c("s0", "s1", "s2", "rho", "loglik"),
      window = "full",
      value = c(theta$s0, theta$s1, theta$s2, theta$rho, theta$loglik)
    ),
    tibble::tibble(
      quantity = rep(c("xi_mp", "f_robust_mp", "max_companion_root"), each = 2),
      window = rep(diagnostics$sample, 3),
      value = c(
        diagnostics$xi_mp,
        diagnostics$f_robust_mp,
        diagnostics$max_companion_root
      )
    ),
    tibble::tibble(
      quantity = paste0("bai_ng_", c("IC1", "IC2", "IC3")),
      window = "full",
      value = c(
        bai_ng$r[which.min(bai_ng$IC1)],
        bai_ng$r[which.min(bai_ng$IC2)],
        bai_ng$r[which.min(bai_ng$IC3)]
      )
    ),
    tibble::tibble(
      quantity = c("p_aic", "p_bic"),
      window = "full",
      value = c(
        lag_criteria$p[which.min(lag_criteria$aic)],
        lag_criteria$p[which.min(lag_criteria$bic)]
      )
    ),
    tibble::tibble(
      quantity = c(
        paste0("xi_mp_", instrument$variant),
        paste0("f_robust_mp_", instrument$variant)
      ),
      window = "full",
      value = c(instrument$xi_mp, instrument$f_robust_mp)
    )
  ) |>
    dplyr::mutate(version = version)
}) |>
  purrr::list_rbind() |>
  tidyr::pivot_wider(names_from = version, values_from = value)
readr::write_csv(model, file.path(OUT_DIR, "model.csv"))

# Impulse responses ----

old_cell <- readRDS(baseline_file("output/irf/irf_coherence_cell.rds"))
# The old Focus rows are the "ano seguinte" series: they take the new names
# so that the rows line up, and the comparison of those rows is between two
# different series
old_cell$var_names <- stringr::str_replace(old_cell$var_names, "_ny$", "_12m")
new_cell <- readRDS("output/irf/irf_coherence_cell.rds")
stop_unless_interval_sets(old_cell, old_cell$var_names)
stop_unless_interval_sets(new_cell, new_cell$var_names)

paths <- dplyr::bind_rows(
  stack_cell_paths(list(old_cell), OLD_LABEL, OLD_LABEL, old_cell$var_names),
  stack_cell_paths(list(new_cell), NEW_LABEL, NEW_LABEL, new_cell$var_names)
) |>
  dplyr::filter(h <= H_MAX) |>
  dplyr::mutate(cell = factor(cell, levels = c(OLD_LABEL, NEW_LABEL)))

paper_paths <- rescale_to_paper_units(paths, PAPER_PANELS, H_MAX) |>
  dplyr::mutate(variable = factor(variable, levels = PAPER_PANELS$label))
paper_paths |>
  dplyr::filter(h %in% H_TABLE) |>
  dplyr::mutate(
    cell = dplyr::if_else(cell == OLD_LABEL, "old", "new"),
    sig90 = lo90 > 0 | hi90 < 0
  ) |>
  dplyr::select(variable, h, cell, point, lo80, hi80, lo90, hi90, sig90) |>
  tidyr::pivot_wider(
    names_from = cell,
    values_from = c(point, lo80, hi80, lo90, hi90, sig90)
  ) |>
  dplyr::arrange(variable, h) |>
  readr::write_csv(file.path(OUT_DIR, "irf_table.csv"))

# Every series, h0-h36: is the new point outside the old 90% set, and does
# each set exclude zero. The width ratio leaves out the singleton of the
# normalization, which has zero width in both cells.
paired_paths <- paths |>
  dplyr::mutate(cell = dplyr::if_else(cell == OLD_LABEL, "old", "new")) |>
  tidyr::pivot_wider(
    names_from = cell,
    values_from = c(point, lo80, hi80, lo90, hi90)
  ) |>
  dplyr::mutate(
    outside_old90 = point_new < lo90_old | point_new > hi90_old,
    sig80_old = lo80_old > 0 | hi80_old < 0,
    sig80_new = lo80_new > 0 | hi80_new < 0,
    sig90_old = lo90_old > 0 | hi90_old < 0,
    sig90_new = lo90_new > 0 | hi90_new < 0,
    width90_ratio = dplyr::if_else(
      hi90_old > lo90_old,
      (hi90_new - lo90_new) / (hi90_old - lo90_old),
      NA_real_
    )
  )

paired_paths |>
  dplyr::group_by(variable) |>
  dplyr::summarise(
    horizons_outside = paste(h[outside_old90], collapse = " "),
    outside_old90 = sum(outside_old90),
    sig90_old = sum(sig90_old),
    sig90_new = sum(sig90_new),
    width90_ratio = median(width90_ratio, na.rm = TRUE)
  ) |>
  dplyr::arrange(dplyr::desc(outside_old90)) |>
  readr::write_csv(file.path(OUT_DIR, "irf_outside.csv"))

paired_paths |>
  dplyr::group_by(h) |>
  dplyr::summarise(
    sig90_lost = sum(sig90_old & !sig90_new),
    sig90_gained = sum(!sig90_old & sig90_new),
    sig80_old = sum(sig80_old),
    sig80_new = sum(sig80_new),
    sig90_old = sum(sig90_old),
    sig90_new = sum(sig90_new),
    width90_ratio = median(width90_ratio, na.rm = TRUE)
  ) |>
  readr::write_csv(file.path(OUT_DIR, "irf_significance_by_h.csv"))

ggplot2::ggsave(
  file.path(OUT_DIR, "irf.pdf"),
  plot_dimension_overlay(
    paper_paths,
    dplyr::filter(paper_paths, cell == OLD_LABEL),
    PAPER_PANELS$label,
    palette = setNames(c("black", "firebrick"), c(OLD_LABEL, NEW_LABEL)),
    linetypes = setNames(c("solid", "42"), c(OLD_LABEL, NEW_LABEL)),
    h_max = H_MAX,
    ncol = 4,
    title = NULL,
    subtitle = NULL
  ),
  width = 10.4,
  height = 5.8,
  device = cairo_pdf
)
