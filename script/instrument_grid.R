# ============================================================
# Grid over (DI vertex) x (purification sample) x (variant).
# Estimates the DFM once and computes first-stage F / xi_1 for
# every cell. Output: output/instrument_grid_report.md.
# ============================================================

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(readr); library(purrr)
  library(tibble); library(lubridate); library(sandwich); library(lmtest)
})

source("R/instrument/di_surprise.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")

SAMPLE_START <- as.Date("2013-01-01")
SAMPLE_END   <- as.Date("2025-12-31")
LOAD_START   <- as.Date("2012-06-01")

VERTICES <- list(
  "DI 3m"  = 63,
  "DI 6m"  = 126,
  "DI 12m" = 252,
  "DI 24m" = 504
)
PURIF_SAMPLES <- c("all_thu", "non_copom")

# ---- Load raw data once ------------------------------------

di_panel <- load_di_panel("data/di.csv", from = LOAD_START, to = SAMPLE_END + 30)

ibov_daily <- read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ibov = as.numeric(ibov)) |> filter(!is.na(ibov))

ext_daily <- read_csv("data/investing/external_factors_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), sp500 = as.numeric(sp500),
            vix = as.numeric(vix), brent = as.numeric(brent))

copom <- read_csv("data/copom_historico.csv", show_col_types = FALSE)[-1] |>
  transmute(meeting_date = dmy(data_reuniao)) |>
  filter(!is.na(meeting_date), meeting_date >= LOAD_START, meeting_date <= SAMPLE_END) |>
  distinct(meeting_date)
copom_wed <- copom |> filter(wday(meeting_date) == 4) |> pull(meeting_date)

all_thursdays <- seq(SAMPLE_START, SAMPLE_END, by = "day")
all_thursdays <- all_thursdays[wday(all_thursdays) == 5]

log_ret_100 <- function(x) 100 * (log(x) - log(dplyr::lag(x)))

ibov_d <- ibov_daily |> arrange(date) |>
  mutate(r_ibov = log_ret_100(ibov)) |> select(date, r_ibov)
ext_d <- ext_daily |> arrange(date) |>
  mutate(r_sp500 = log_ret_100(sp500),
         d_vix   = vix - dplyr::lag(vix),
         r_brent = log_ret_100(brent)) |>
  select(date, r_sp500, d_vix, r_brent)

# ---- Estimate DFM once (instrument-agnostic residual) ------

raw_data <- read_csv("data/processed/data_log_deseasonalized.csv",
                     show_col_types = FALSE) |> drop_na()
dates <- as.Date(raw_data$ref.date)
X     <- raw_data |> select(-ref.date) |> as.matrix()

seed_inst <- read_csv("data/processed/instrument_bruto.csv", show_col_types = FALSE)

message("Estimating DFM (r=8, q=8, p=6) ...")
dfm <- estimate_dfm(X, r = 8, q = 8, p = 6, dates = dates,
                    instrument = seed_inst, apply_kilian = FALSE)

policy_residual <- dfm$var_residuals[, 1]
p_lag  <- dfm$p
F_mat  <- dfm$static_factors
T_f    <- nrow(F_mat); r_fac <- ncol(F_mat)
RHS_lags <- matrix(NA, T_f - p_lag, r_fac * p_lag)
for (i in seq_len(p_lag)) {
  cols <- ((i - 1) * r_fac + 1):(i * r_fac)
  RHS_lags[, cols] <- F_mat[(p_lag + 1 - i):(T_f - i), ]
}
colnames(RHS_lags) <- paste0("ctrl", seq_len(ncol(RHS_lags)))

# ---- Build Thursday panel for a given vertex ---------------

build_thu_panel <- function(target_bd) {
  di_s <- build_thursday_surprises(di_panel, all_thursdays,
                                   target_bd = target_bd, min_bd = 10)
  tibble(date = all_thursdays) |>
    left_join(di_s, by = "date") |>
    left_join(ibov_d, by = "date") |>
    left_join(ext_d,  by = "date") |>
    mutate(copom_day = (date - 1) %in% copom_wed) |>
    filter(!is.na(delta_di), !is.na(r_ibov),
           !is.na(r_sp500), !is.na(d_vix), !is.na(r_brent))
}

# ---- Build 4 monthly variants for a given panel + purif ----

build_variants <- function(thu_panel, purif_sample) {
  fit_sample <- if (purif_sample == "all_thu") thu_panel else
                 thu_panel |> filter(!copom_day)

  lm_di   <- lm(delta_di ~ r_sp500 + d_vix + r_brent, data = fit_sample)
  lm_ibov <- lm(r_ibov   ~ r_sp500 + d_vix + r_brent, data = fit_sample)

  thu_panel$e_di   <- thu_panel$delta_di - predict(lm_di,   newdata = thu_panel)
  thu_panel$e_ibov <- thu_panel$r_ibov   - predict(lm_ibov, newdata = thu_panel)

  thu_panel <- thu_panel |>
    mutate(jk_mon = copom_day &
                    sign(e_di) != 0 & sign(e_ibov) != 0 &
                    sign(e_di) != sign(e_ibov),
           month  = floor_date(date, "month"))

  grid <- tibble(month = seq(floor_date(SAMPLE_START, "month"),
                             floor_date(SAMPLE_END,   "month"), by = "month"))

  agg <- function(value_col, mask_col) {
    thu_panel |>
      mutate(val = ifelse(.data[[mask_col]], .data[[value_col]], 0)) |>
      group_by(month) |>
      summarise(shock = sum(val, na.rm = TRUE), .groups = "drop")
  }
  thu_panel$copom_mask <- thu_panel$copom_day

  z1 <- agg("delta_di", "copom_mask")  # z_bruto
  z2 <- agg("e_di",     "copom_mask")  # z_bruto_purif
  z3 <- agg("delta_di", "jk_mon")      # z_jk
  z4 <- agg("e_di",     "jk_mon")      # z_jk_purif

  grid |>
    left_join(z1 |> rename(z_bruto       = shock), by = "month") |>
    left_join(z2 |> rename(z_bruto_purif = shock), by = "month") |>
    left_join(z3 |> rename(z_jk          = shock), by = "month") |>
    left_join(z4 |> rename(z_jk_purif    = shock), by = "month") |>
    mutate(across(starts_with("z_"), ~ replace_na(.x, 0)))
}

# ---- First-stage diagnostics for a monthly instrument -----

first_stage <- function(monthly_inst, varname) {
  inst_df <- monthly_inst |> transmute(month, shock = .data[[varname]])
  align   <- sel_ext_inst_sample(dfm$dates, p_lag, inst_df)
  Z_t     <- align$inst_sel
  res_al  <- policy_residual[align$rsh_sel_ind]
  ctrl_al <- RHS_lags[align$rsh_sel_ind, , drop = FALSE]

  fs <- lm(res ~ ., data = data.frame(res = res_al, Z = Z_t, ctrl_al))
  ct <- coeftest(fs, vcov = vcovHC(fs, type = "HC0"))
  beta <- ct["Z","Estimate"]; se <- ct["Z","Std. Error"]
  tval <- ct["Z","t value"];  pval <- ct["Z","Pr(>|t|)"]

  T_eff <- length(Z_t)
  gamma <- mean(Z_t * res_al)
  W11   <- mean((Z_t * res_al - gamma)^2)
  xi1   <- T_eff * gamma^2 / W11

  list(beta = beta, se = se, t = tval, p = pval,
       f_part = tval^2, xi1 = xi1,
       nonzero = sum(Z_t != 0), n = T_eff)
}

# ---- Grid ------------------------------------------------

VARIANTS <- c("z_bruto", "z_bruto_purif", "z_jk", "z_jk_purif")

rows <- list()
for (vname in names(VERTICES)) {
  tbd <- VERTICES[[vname]]
  message(sprintf("Building Thursday panel for %s (target_bd=%d)...", vname, tbd))
  thu <- build_thu_panel(tbd)
  message(sprintf("  valid=%d, copom=%d", nrow(thu), sum(thu$copom_day)))

  for (ps in PURIF_SAMPLES) {
    inst_m <- build_variants(thu, ps)
    for (var in VARIANTS) {
      s <- first_stage(inst_m, var)
      rows[[length(rows) + 1]] <- tibble(
        vertex   = vname,
        purif    = ps,
        variant  = var,
        n        = s$n,
        nonzero  = s$nonzero,
        beta     = s$beta,
        t        = s$t,
        p        = s$p,
        f_part   = s$f_part,
        xi1      = s$xi1
      )
    }
  }
}

grid_df <- bind_rows(rows)
print(grid_df |> mutate(across(where(is.numeric), ~ round(.x, 3))), n = Inf)

# ---- Report ------------------------------------------------

fmt_p <- function(p) if (is.na(p)) "NA" else if (p < 0.001) "<0.001" else sprintf("%.3f", p)

make_section <- function(purif_label) {
  sub <- grid_df |> filter(purif == purif_label)
  mat <- sub |>
    mutate(cell = sprintf("F=%.2f  ξ₁=%.2f  β=%.3f (p=%s)",
                          f_part, xi1, beta, map_chr(p, fmt_p))) |>
    select(vertex, variant, cell) |>
    pivot_wider(names_from = variant, values_from = cell)

  hdr <- paste("| Vertex |", paste(VARIANTS, collapse = " | "), "|")
  sep <- paste(rep("|---", length(VARIANTS) + 1), collapse = ""); sep <- paste0(sep, "|")
  body <- apply(mat, 1, function(r)
    paste("|", r["vertex"], "|",
          r["z_bruto"], "|", r["z_bruto_purif"], "|",
          r["z_jk"],    "|", r["z_jk_purif"],    "|"))
  paste(c(hdr, sep, body), collapse = "\n")
}

best <- grid_df |> arrange(desc(f_part)) |> head(5)

report <- paste(c(
  "# Instrument grid — vertex × purification",
  "",
  sprintf("Generated: %s. DFM aligned sample: %d months. First-stage = HC0 t² = partial F; ξ₁ follows OSW (threshold 3.84 for bounded AR CIs; 10 for conventional inference).",
          Sys.Date(), length(policy_residual) - 0),
  "",
  "## A. Purification fit on all Thursdays",
  "",
  make_section("all_thu"),
  "",
  "## B. Purification fit on non-Copom Thursdays only",
  "",
  make_section("non_copom"),
  "",
  "## Top 5 configurations by partial F",
  "",
  "| Vertex | Purif | Variant | n | nonzero | β | t | p | Partial F | ξ₁ |",
  "|---|---|---|---|---|---|---|---|---|---|",
  apply(best, 1, function(r)
    sprintf("| %s | %s | %s | %s | %s | %.3f | %.2f | %s | %.2f | %.2f |",
            r[["vertex"]], r[["purif"]], r[["variant"]],
            r[["n"]], r[["nonzero"]],
            as.numeric(r[["beta"]]), as.numeric(r[["t"]]),
            fmt_p(as.numeric(r[["p"]])),
            as.numeric(r[["f_part"]]), as.numeric(r[["xi1"]])))
), collapse = "\n")

writeLines(report, "output/instrument_grid_report.md")
write_csv(grid_df, "output/instrument_grid.csv")
message("Wrote output/instrument_grid_report.md and output/instrument_grid.csv")
