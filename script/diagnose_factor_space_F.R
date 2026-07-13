# ===================================================================
# Grid diagnostic: F (factor-space) and impact-response sign for
# every (q, instrument variant) combination on a fixed (r, p) panel.
# Resolves whether the weak F (factor-space) reported by model_alessi.R
# is structural to the (r, q, p) choice or to the instrument variant.
# ===================================================================

rm(list = ls())

library(readr)
library(dplyr)
library(tidyr)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")


# --- Data ------------------------------------------------------------
raw_data <- readr::read_csv("data/processed/data_log_deseasonalized.csv",
                            show_col_types = FALSE) |>
  tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- as.matrix(dplyr::select(raw_data, -ref.date))

mp_var <- "yield_6m"
mp_idx <- match(mp_var, colnames(data_mat))
if (is.na(mp_idx)) stop("mp_var not found in panel")


# --- Instrument variants --------------------------------------------
inst_panel <- readr::read_csv("data/processed/instrumentos_mensais.csv",
                              show_col_types = FALSE)
variants <- c("z_bruto", "z_bruto_purif", "z_jk", "z_jk_purif",
              "z_het", "z_het_jk", "z_het_3var", "z_het_jk_3var")


# --- Grid -----------------------------------------------------------
r_fixed  <- 7
p_fixed  <- 6
q_values <- c(2, 3, 4, 6)

cache_dfm <- list()  # one DFM per q (variant loop is cheap)

results <- list()
i <- 0
for (q_test in q_values) {
  cat(sprintf("\n>>> Estimating DFM with r=%d, q=%d, p=%d ...\n",
              r_fixed, q_test, p_fixed))
  t0 <- Sys.time()
  dfm <- estimate_dfm(data_mat, r = r_fixed, q = q_test, p = p_fixed,
                      dates = dates, apply_kilian = FALSE)
  cat(sprintf("    done in %.1fs\n", as.numeric(Sys.time() - t0, units = "secs")))
  cache_dfm[[as.character(q_test)]] <- dfm

  for (v in variants) {
    inst_df <- data.frame(month = as.Date(inst_panel$month),
                          shock = inst_panel[[v]])
    inst_df <- inst_df[!is.na(inst_df$shock), ]

    diag <- tryCatch(
      diagnose_instrument_in_factor_space(dfm, inst_df, dates, p_fixed, mp_idx),
      error = function(e) {
        list(f_factor = NA_real_, impact_mp = NA_real_, sign_mp = NA_real_,
             n_obs = NA_integer_, err = conditionMessage(e))
      }
    )

    i <- i + 1
    results[[i]] <- data.frame(
      q          = q_test,
      variant    = v,
      f_factor   = diag$f_factor,
      impact_mp  = diag$impact_mp,
      sign_mp    = diag$sign_mp,
      n_obs      = diag$n_obs,
      stringsAsFactors = FALSE
    )
  }
}

grid <- dplyr::bind_rows(results) |>
  dplyr::arrange(dplyr::desc(f_factor))


# --- Output ---------------------------------------------------------
cat("\n\n========== F (factor-space) GRID — sorted by F desc ==========\n")
print(grid, row.names = FALSE)

dir.create("output/instrument", showWarnings = FALSE, recursive = TRUE)
out_path <- "output/instrument/factor_space_F_grid.csv"
readr::write_csv(grid, out_path)
cat(sprintf("\nWrote %s\n", out_path))


# --- Highlights -----------------------------------------------------
top <- grid |>
  dplyr::filter(!is.na(f_factor)) |>
  dplyr::filter(sign_mp > 0) |>
  dplyr::slice_max(f_factor, n = 5)

cat("\n========== TOP 5 (positive impact + highest F) ==========\n")
print(top, row.names = FALSE)

cat("\nStock-Yogo weak-instrument threshold (single instrument):\n")
cat("  ~10 for size-distortion test; <5 indicates severely weak.\n")
cat("Variants with F (factor-space) >= 10 are candidates for re-running\n")
cat("model_alessi.R as the new DEFAULT_VARIANT.\n")
