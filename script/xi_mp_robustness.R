# ===================================================================
# Robustness of xi_mp itself — the statistic that carries the whole
# defence of conventional inference in section 5 (10.43 full sample,
# i.e. just over the threshold where conventional bands are only
# "approximately valid" per Montiel Olea, Stock & Watson 2021).
#
# Two exercises, both on the Wald block of compute_factor_space_wald.
# The DFM is estimated once per sample and held fixed: only the Gamma
# moment is recomputed. c_mp is a function of the DFM, so it is fixed
# too — this isolates influence running through the moment, not
# through factor estimation, which is the intended question.
#
#  1. Leave-one-month-out. Drop one aligned month at a time from the
#     triple (eta_sel, Z_sel, ctrl_sel) and recompute xi_mp. Reported
#     over all aligned months and, separately, over the months where
#     z != 0 — the mask zeroes most months, so that is where the
#     leverage lives. This is the right exercise in place of
#     winsorizing z, which would shrink exactly the large days that
#     *are* the identifying variation of a high-frequency instrument.
#
#  2. HAC. xi_mp under Newey-West lags 0..6. NW(0) is the convention
#     of the official applications (OilSVARIV.m:50) and is defensible
#     here — eta is a VAR innovation and the monthly aggregation is a
#     non-overlapping sum of Copom days, which induces no MA. NW > 0
#     matters for the Gertler-Karadi aggregation of the companion
#     sweep, which does induce an MA(1) by construction.
#
# Outputs: output/instrument/xi_mp_robustness.csv
#          output/instrument/xi_mp_robustness.md
# ===================================================================

rm(list = ls())

library(readr)
library(dplyr)
library(tidyr)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")   # md_table


# ---- Config --------------------------------------------------------

R_PROD  <- 7L
Q_PROD  <- 6L
P_LAGS  <- 6L
MP_VAR  <- "yield_6m"

SAMPLES <- list(
  full      = as.Date(c("2013-01-01", "2025-12-31")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-31"))
)

# Production instrument first; then the two other predetermined-mask
# variants, the contemporaneous-residual contrast, and the raw
# surprise with neither the JK filter nor the BS orthogonalization.
VARIANTS <- c("z_jk_bs_purif", "z_jk_raw", "z_jk_raw_purif",
              "z_jk_purif", "z_bruto")

NW_LAGS <- 0:6

DATA_PATH <- "data/processed/data_log_deseasonalized.csv"
INST_PATH <- "data/processed/instrumentos_mensais.csv"
OUT_DIR   <- "output/instrument"

CHI2_1_95 <- qchisq(0.95, df = 1)
XI_CONV   <- 10

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> select(-ref.date) |> as.matrix()
mp_idx   <- match(MP_VAR, colnames(data_mat))
stopifnot(!is.na(mp_idx))

inst_panel <- read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)


# ---- xi_mp on a subsample of the aligned moment ---------------------

#' Recompute xi_mp from the cached moment inputs, optionally dropping rows.
#'
#' @param mi `moment_inputs` from `diagnose_instrument_in_factor_space`.
#' @param drop Integer row indices to drop (none by default).
#' @param nw_lags Newey-West truncation lag.
xi_mp_from_moment <- function(mi, drop = integer(0), nw_lags = 0L) {
  keep <- setdiff(seq_len(nrow(mi$eta_sel)), drop)
  y    <- mi$eta_sel[keep, , drop = FALSE] %*% mi$c_mp
  compute_factor_space_wald(y,
                            mi$Z_sel[keep, , drop = FALSE],
                            controls = mi$ctrl_sel[keep, , drop = FALSE],
                            nw_lags  = nw_lags)$wald_joint
}


# ---- Grid ----------------------------------------------------------

rows <- list(); ir <- 0
add  <- function(...) {
  ir <<- ir + 1
  rows[[ir]] <<- data.frame(..., stringsAsFactors = FALSE)
}

for (sample_name in names(SAMPLES)) {
  win       <- SAMPLES[[sample_name]]
  in_window <- dates >= win[1] & dates <= win[2]
  data_sub  <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]

  cat(sprintf(">>> [%s] DFM r=%d q=%d p=%d (T=%d) ...\n",
              sample_name, R_PROD, Q_PROD, P_LAGS, nrow(data_sub)))
  dfm <- estimate_dfm(data_sub, r = R_PROD, q = Q_PROD, p = P_LAGS,
                      dates = dates_sub, apply_kilian = FALSE)

  for (v in VARIANTS) {
    inst_df <- data.frame(month = inst_panel$month, shock = inst_panel[[v]])
    inst_df <- inst_df[!is.na(inst_df$shock), ]

    diag_fs <- diagnose_instrument_in_factor_space(
      dfm, inst_df, dates_sub, P_LAGS, mp_idx,
      return_moment_inputs = TRUE)

    mi       <- diag_fs$moment_inputs
    n_al     <- nrow(mi$eta_sel)
    baseline <- diag_fs$wald_mp
    nz_idx   <- which(as.numeric(mi$Z_sel) != 0)

    cat(sprintf("    %-16s xi_mp = %6.3f  (n = %d, nonzero z = %d)\n",
                v, baseline, n_al, length(nz_idx)))

    add(sample = sample_name, instrument = v, exercise = "baseline",
        key = NA_character_, n_used = n_al, wald_mp = baseline)

    # 1. leave-one-month-out
    loo <- vapply(seq_len(n_al),
                  function(i) xi_mp_from_moment(mi, drop = i),
                  numeric(1))
    for (i in seq_len(n_al)) {
      add(sample = sample_name, instrument = v, exercise = "loo",
          key = format(mi$months[i], "%Y-%m"), n_used = n_al - 1L,
          wald_mp = loo[i])
    }

    # 2. HAC
    for (L in NW_LAGS) {
      add(sample = sample_name, instrument = v, exercise = "hac",
          key = as.character(L), n_used = n_al,
          wald_mp = xi_mp_from_moment(mi, nw_lags = L))
    }
  }
}

res <- bind_rows(rows)
write_csv(res, file.path(OUT_DIR, "xi_mp_robustness.csv"))
cat(sprintf("\nWrote %d rows to xi_mp_robustness.csv\n", nrow(res)))


# ---- Summaries -----------------------------------------------------

base_tbl <- res |> filter(exercise == "baseline") |>
  select(sample, instrument, n_obs = n_used, xi_mp = wald_mp)

loo_all <- res |> filter(exercise == "loo")

nz_months <- loo_all |>
  inner_join(
    inst_panel |>
      pivot_longer(-month, names_to = "instrument", values_to = "z") |>
      filter(z != 0) |>
      mutate(key = format(month, "%Y-%m")) |>
      select(instrument, key) |>
      distinct(),
    by = c("instrument", "key"))

loo_summary <- function(df, label) {
  df |>
    group_by(sample, instrument) |>
    summarise(
      n_drops   = n(),
      xi_min    = min(wald_mp),
      xi_median = median(wald_mp),
      xi_max    = max(wald_mp),
      n_below10 = sum(wald_mp < XI_CONV),
      n_below384 = sum(wald_mp < CHI2_1_95),
      .groups = "drop") |>
    left_join(base_tbl |> select(sample, instrument, xi_mp),
              by = c("sample", "instrument")) |>
    mutate(scope = label,
           swing_dn = xi_mp - xi_min,
           swing_up = xi_max - xi_mp) |>
    select(scope, sample, instrument, xi_mp, xi_min, xi_median, xi_max,
           swing_dn, swing_up, n_below10, n_below384, n_drops)
}

loo_tbl <- bind_rows(loo_summary(loo_all,  "todos os meses"),
                     loo_summary(nz_months, "meses com z != 0"))

# Most influential months for the production instrument
infl <- loo_all |>
  inner_join(base_tbl |> select(sample, instrument, xi_mp),
             by = c("sample", "instrument")) |>
  filter(instrument == "z_jk_bs_purif") |>
  mutate(delta = wald_mp - xi_mp) |>
  group_by(sample) |>
  slice_max(abs(delta), n = 10) |>
  arrange(sample, delta) |>
  ungroup() |>
  select(sample, mes = key, xi_mp_sem_o_mes = wald_mp, delta)

hac_tbl <- res |> filter(exercise == "hac") |>
  mutate(nw = paste0("NW(", key, ")")) |>
  select(sample, instrument, nw, wald_mp) |>
  mutate(wald_mp = round(wald_mp, 2)) |>
  pivot_wider(names_from = nw, values_from = wald_mp)


# ---- Report --------------------------------------------------------

fmt <- function(df) md_table(df |> mutate(across(where(is.numeric),
                                                 ~ round(.x, 3))))

prod_full <- base_tbl |> filter(sample == "full",
                                instrument == "z_jk_bs_purif") |> pull(xi_mp)
prod_loo  <- loo_tbl |> filter(scope == "todos os meses", sample == "full",
                               instrument == "z_jk_bs_purif")

sections <- c(
  "# Robustez do ξ_mp — leave-one-month-out e HAC",
  "",
  sprintf("Gerado por `script/xi_mp_robustness.R` em %s.", format(Sys.Date())),
  "",
  sprintf(paste0("Especificação de produção: r = %d, q = %d, p = %d, ",
                 "direção de normalização = `%s`. %d instrumentos × %d amostras."),
          R_PROD, Q_PROD, P_LAGS, MP_VAR, length(VARIANTS), length(SAMPLES)),
  "",
  paste0("O DFM entra **uma vez por amostra** e fica fixo; só o momento Γ é ",
         "recomputado. `c_mp` também vem do DFM, então o exercício isola a ",
         "influência que passa pelo **momento**, não pela estimação de fatores."),
  "",
  "Régua MOSW: ξ_mp ≥ 10 sustenta bandas convencionais; 3,84 < ξ_mp < 10 é",
  "instrumento fraco com conjunto AR limitado; ξ_mp ≤ 3,84, conjunto AR",
  "possivelmente ilimitado.",
  "",
  "## 1. Baseline",
  "",
  fmt(base_tbl),
  "",
  "## 2. Leave-one-month-out",
  "",
  paste0("`swing_dn` é quanto o ξ_mp cai no pior mês descartado; `swing_up`, ",
         "quanto sobe no melhor. `n_below10` conta quantos descartes ",
         "individuais derrubam o ξ_mp abaixo de 10."),
  "",
  fmt(loo_tbl),
  "",
  "### Meses mais influentes — instrumento de produção `z_jk_bs_purif`",
  "",
  "`delta` = ξ_mp sem o mês − ξ_mp cheio. Negativo: o mês *sustenta* a força.",
  "",
  fmt(infl),
  "",
  "## 3. HAC — ξ_mp por defasagem de Newey-West",
  "",
  paste0("NW(0) é Eicker-White, a convenção das aplicações oficiais ",
         "(`OilSVARIV.m:50`). O kernel de Bartlett para NW > 0 é a ",
         "transcrição de `NW_hac_STATA.m`, validada em ",
         "`script/validate_hac_kernel.R` contra a aplicação oficial de ",
         "impostos (`TaxSVARIV.m`, NWlags = 8, diferença relativa 2,6e-10)."),
  "",
  fmt(hac_tbl),
  ""
)

writeLines(sections, file.path(OUT_DIR, "xi_mp_robustness.md"))
cat(sprintf("Wrote %s\n", file.path(OUT_DIR, "xi_mp_robustness.md")))

cat("\n========== LEAVE-ONE-MONTH-OUT (todos os meses) ==========\n")
print(as.data.frame(loo_tbl |> filter(scope == "todos os meses") |>
                    mutate(across(where(is.numeric), ~ round(.x, 2)))),
      row.names = FALSE)
cat("\n========== HAC ==========\n")
print(as.data.frame(hac_tbl), row.names = FALSE)
