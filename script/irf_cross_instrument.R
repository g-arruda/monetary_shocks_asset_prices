# ============================================================
# Cross-instrument IRFs for the paper (MÉDIO 7).
#
# Runs the same DFM specification twice -once with z_het_jk_3var
# (recommended hybrid het+timing+sign instrument) and once with
# z_jk_purif (legacy timing-ID with Bauer-Swanson purification) —
# and produces three PDFs:
#
#   output/irf_zhetjk3var.pdf      -main spec, 9-panel grid
#   output/irf_zjkpurif.pdf        -robustness spec, 9-panel grid
#   output/irf_comparison.pdf      -overlay (firebrick = z_het_jk_3var,
#                                            steelblue = z_jk_purif)
#
# Plus two RDS objects with the full irf_results so the downstream
# benchmark + report scripts can consume without re-bootstrapping:
#
#   output/irf_results_zhetjk3var.rds
#   output/irf_results_zjkpurif.rds
#
# Bands: 68% and 90% concentric. Bootstrap: nboot = 800 (wild
# recursive Goncalves-Kilian 2004) with Kilian (1998) bias correction
# inside the bootstrap DGP only.
#
# Pre-requisites (idempotent if already run today):
#   Rscript script/instrument.R         # produces instrument_jk_purif.csv
#   Rscript script/instrument_het.R     # produces instrument_z_het_jk_3var.csv
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(patchwork)
})

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")

# ---- Config ------------------------------------------------

DATA_PATH       <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENTS     <- list(
  zhetjk3var = list(
    label = "z_het_jk_3var",
    path  = "data/processed/instrument_z_het_jk_3var.csv",
    color = "firebrick"
  ),
  zjkpurif   = list(
    label = "z_jk_purif",
    path  = "data/processed/instrument_jk_purif.csv",
    color = "steelblue"
  )
)
N_BOOT          <- 800L
HORIZON         <- 50L
SHOCK_BPS       <- 50
MP_VAR          <- "yield_6m"
CI_LEVELS       <- c(0.68, 0.90)
R_FACTORS       <- 8L
Q_DYNAMIC       <- 8L
P_LAGS          <- 6L
BOOT_SEED       <- 123L

# Variable names → human labels for the plot panels (3x3 grid).
RESPONSE_VARS <- list(
  c("yield 6m"           = "yield_6m"),
  c("yield 2y"           = "yield_2y"),
  c("yield 5y"           = "yield_5y"),
  c("BRL/USD"            = "cambio_usd"),
  c("IBOV"               = "asset_ibov"),
  c("CDS 5y"             = "cds_5y"),
  c("EMBI"               = "embi_perc"),
  c("IPCA (realized)"    = "price_ipca"),
  c("ICC spread juridica" = "spread_icc_juridica")
)

dir.create("output", showWarnings = FALSE)

# ---- Run a single specification -----------------------------

run_spec <- function(label, path) {
  message(sprintf("\n>>> Running DFM with instrument: %s (%s)", label, path))
  raw_data <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
  dates    <- as.Date(raw_data$ref.date)
  data_mat <- raw_data |> select(-ref.date) |> as.matrix()

  tcode <- infer_tcode_from_varnames(colnames(data_mat))
  mpind <- match(MP_VAR, colnames(data_mat))
  if (is.na(mpind)) stop("mp_var '", MP_VAR, "' not found")

  instrument <- read_csv(path, show_col_types = FALSE)

  dfm <- estimate_dfm(data_mat, R_FACTORS, Q_DYNAMIC, P_LAGS,
                      dates = dates, instrument = instrument,
                      apply_kilian = TRUE)

  irf <- compute_irf_dfm(
    dfm,
    h = HORIZON,
    nboot = N_BOOT,
    bootstrap_seed = BOOT_SEED,
    mpind = mpind,
    normalize_value = SHOCK_BPS / 100,
    tcode = tcode,
    ci_levels = CI_LEVELS
  )

  list(label = label, dfm = dfm, irf = irf,
       data = data_mat, tcode = tcode, mpind = mpind,
       normalize_value = SHOCK_BPS / 100,
       var_names = colnames(data_mat))
}

# ---- Resolve response_vars to indices once ------------------
# Reads colnames from the panel and maps each (label = name) to its index.

build_response_index <- function(var_names) {
  purrr::map(RESPONSE_VARS, function(entry) {
    nm  <- names(entry)
    col <- as.character(entry)
    idx <- match(col, var_names)
    if (is.na(idx)) {
      stop(sprintf("Response variable '%s' not in panel", col))
    }
    setNames(idx, nm)
  })
}

# ---- Plot helpers -------------------------------------------

plot_one <- function(spec, response_idx, title_suffix) {
  p <- plot_irf(
    spec$irf,
    response_vars = response_idx,
    shock = 1,
    horizon = HORIZON,
    cumulative = FALSE,
    var_names = spec$var_names,
    tcode = spec$tcode,
    ci_to_plot = CI_LEVELS
  )
  p + patchwork::plot_annotation(
    title = sprintf("Cross-instrument IRFs -%s", title_suffix),
    subtitle = sprintf("Shock = +%dbp on %s | wild bootstrap nboot = %d | bands 68/90",
                       SHOCK_BPS, MP_VAR, N_BOOT)
  )
}

# Overlay plot: extracts irf_point + ci for a given level from each spec
# and builds a single ribbon-plus-line per panel. Cleaner than calling
# plot_irf twice and patchworking.
plot_overlay <- function(specs, response_idx) {
  level_key  <- sprintf("%.2f", 0.90)
  level_key2 <- sprintf("%.2f", 0.68)

  panels <- purrr::imap(response_idx, function(entry, i) {
    var_idx <- as.integer(entry)
    var_lbl <- names(entry)

    df <- purrr::map_dfr(specs, function(s) {
      tibble(
        h     = 0:HORIZON,
        point = s$irf$irf_point_matrix[var_idx, ],
        lo90  = s$irf$ci[[level_key]]$lower[var_idx, ],
        hi90  = s$irf$ci[[level_key]]$upper[var_idx, ],
        lo68  = s$irf$ci[[level_key2]]$lower[var_idx, ],
        hi68  = s$irf$ci[[level_key2]]$upper[var_idx, ],
        instrument = s$label
      )
    })

    ggplot(df, aes(x = h, colour = instrument, fill = instrument)) +
      geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
      geom_ribbon(aes(ymin = lo90, ymax = hi90), alpha = 0.12, colour = NA) +
      geom_ribbon(aes(ymin = lo68, ymax = hi68), alpha = 0.22, colour = NA) +
      geom_line(aes(y = point), linewidth = 0.7) +
      scale_colour_manual(values = c(z_het_jk_3var = "firebrick",
                                     z_jk_purif    = "steelblue")) +
      scale_fill_manual(values   = c(z_het_jk_3var = "firebrick",
                                     z_jk_purif    = "steelblue")) +
      labs(title = var_lbl, x = NULL, y = NULL) +
      theme_minimal(base_size = 10) +
      theme(legend.position = "bottom",
            plot.title = element_text(size = 11, face = "bold"))
  })

  patchwork::wrap_plots(panels, ncol = 3, guides = "collect") +
    patchwork::plot_annotation(
      title = "Cross-instrument IRF comparison",
      subtitle = sprintf("Shock = +%dbp on %s | wild bootstrap nboot = %d | bands 68 (dark) / 90 (light)",
                         SHOCK_BPS, MP_VAR, N_BOOT)
    ) &
    theme(legend.position = "bottom")
}

# ---- Execute ------------------------------------------------

set.seed(BOOT_SEED)
specs <- purrr::imap(INSTRUMENTS, function(meta, key) {
  out <- run_spec(meta$label, meta$path)
  # Persist irf together with var_names + tcode so downstream readers
  # do not depend on re-reading the panel header (which can drift if
  # the panel column order changes between runs).
  saveRDS(
    list(irf = out$irf, var_names = out$var_names, tcode = out$tcode,
         label = out$label, mp_var = MP_VAR,
         shock_size_bps = SHOCK_BPS,
         normalize_value = out$normalize_value),
    sprintf("output/irf_results_%s.rds", key)
  )
  out
})

response_idx <- build_response_index(specs[[1]]$var_names)

# Per-instrument 9-panel PDFs
ggsave("output/irf_zhetjk3var.pdf",
       plot_one(specs$zhetjk3var, response_idx, "z_het_jk_3var (recommended)"),
       width = 11, height = 9, dpi = 200)
ggsave("output/irf_zjkpurif.pdf",
       plot_one(specs$zjkpurif, response_idx, "z_jk_purif (legacy timing-ID)"),
       width = 11, height = 9, dpi = 200)

# Cross-instrument overlay
ggsave("output/irf_comparison.pdf",
       plot_overlay(specs, response_idx),
       width = 11, height = 9, dpi = 200)

# ---- Console summary ----------------------------------------

cat("\n========== CROSS-INSTRUMENT IRF SUMMARY ==========\n")
for (key in names(specs)) {
  s <- specs[[key]]
  cat(sprintf("\n%s (%s):\n", key, s$label))
  level_key <- sprintf("%.2f", 0.90)
  for (entry in response_idx) {
    var_idx <- as.integer(entry)
    var_lbl <- names(entry)
    p0  <- s$irf$irf_point_matrix[var_idx, 1]
    lo  <- s$irf$ci[[level_key]]$lower[var_idx, 1]
    hi  <- s$irf$ci[[level_key]]$upper[var_idx, 1]
    cat(sprintf("  h=0  %-22s  point=%+8.4f  CI90=[%+8.4f, %+8.4f]\n",
                var_lbl, p0, lo, hi))
  }
}
cat("\nWrote:\n")
cat("  output/irf_zhetjk3var.pdf\n")
cat("  output/irf_zjkpurif.pdf\n")
cat("  output/irf_comparison.pdf\n")
cat("  output/irf_results_zhetjk3var.rds\n")
cat("  output/irf_results_zjkpurif.rds\n")
cat("==================================================\n\n")
