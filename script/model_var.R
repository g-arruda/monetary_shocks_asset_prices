# ===================================================================
# Observable SVAR-IV benchmark by the Montiel Olea et al. method.
#
# Linear path: levels -> common-sample AIC/BIC with linear trend -> RForm_VAR ->
# external-instrument impact -> AR test inversion.
#
# Outputs:
#   output/var/var_benchmark_lag_criteria.csv
#   output/var/svar_iv_weak_robust.csv
#   output/var/svar_iv_weak_robust_diag.csv
#   output/var/svar_iv_weak_robust.md
# ===================================================================

rm(list = ls())

source("R/modeling/production_spec.R")
source("R/modeling/var_proxy.R")
source("R/identification/weak_iv_ar.R")
source("R/reporting/markdown_report.R")

required_packages <- c("dplyr", "readr", "tidyr")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing packages: ", paste(missing_packages, collapse = ", "))
}

SPEC <- production_spec()
VAR_SPEC <- SPEC$var_benchmark
if (!"--reestimate-current-instrument" %in% commandArgs(trailingOnly = TRUE)) {
  stop(
    "The observable VAR outputs are frozen at the 2013-01--2025-09 vintage. ",
    "Use --reestimate-current-instrument only in its dedicated re-estimation round."
  )
}
DATA_PATH <- SPEC$data_path
INSTRUMENT_PATH <- SPEC$instrument_path
OUT_DIR <- "output/var"
P <- VAR_SPEC$p
H <- VAR_SPEC$ar_horizon
P_MAX <- VAR_SPEC$max_lag
AR_LEVELS <- VAR_SPEC$ar_levels
NW_LAGS <- VAR_SPEC$nw_lags
MP_VAR <- SPEC$mp_var
SCALE <- SPEC$normalize_value
if (
  !identical(VAR_SPEC$label, "ibc5_fx_cds_level_trend_p2") ||
    !identical(VAR_SPEC$deterministic, "trend") ||
    !identical(VAR_SPEC$lag_criterion, "aic") ||
    P != 2L || P_MAX != 12L || NW_LAGS != 0L ||
    !identical(AR_LEVELS, c(0.68, 0.90))
) {
  stop("The small-VAR specification no longer matches the declared design")
}


cat("=== Observable SVAR-IV by Montiel Olea et al. ===\n\n")

# 1. Load levels ---------------------------------------------------

cat("[1] Loading levels and the external instrument\n")

series_names <- VAR_SPEC$vars
panel <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |>
  dplyr::filter(
    ref.date >= VAR_SPEC$sample[1L],
    ref.date <= VAR_SPEC$sample[2L]
  ) |>
  dplyr::select(ref.date, dplyr::all_of(series_names))

if (
  nrow(panel) != VAR_SPEC$n_months || anyNA(panel) ||
    !identical(
      as.Date(panel$ref.date),
      seq(VAR_SPEC$sample[1L], VAR_SPEC$sample[2L], by = "month")
    )
) {
  stop("The level panel does not match the declared 2013-01--2025-09 sample")
}

levels <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
dates_level <- as.Date(panel$ref.date)

instrument <- readr::read_csv(INSTRUMENT_PATH, show_col_types = FALSE) |>
  dplyr::transmute(
    month = as.Date(month),
    shock = .data[[SPEC$instrument]]
  )
if (anyNA(instrument) || anyDuplicated(instrument$month)) {
  stop("The external instrument has missing or duplicated months")
}

cat(sprintf(
  "    %d months, %d declared series, instrument %s\n",
  nrow(levels),
  ncol(levels),
  SPEC$instrument
))


# 2. Lag-order criteria --------------------------------------------

cat("\n[2] AIC and BIC with constant and linear trend\n")

lag_criteria <- var_lag_criteria(
  levels,
  pmax = P_MAX,
  deterministic = VAR_SPEC$deterministic
) |>
  dplyr::mutate(cell_id = "production", cell = VAR_SPEC$label) |>
  dplyr::select(cell_id, cell, dplyr::everything())

aic_selected <- lag_criteria$p[which.min(lag_criteria$aic)]
bic_selected <- lag_criteria$p[which.min(lag_criteria$bic)]
cat(sprintf("    AIC selects p = %d; BIC selects p = %d\n", aic_selected, bic_selected))

stopifnot(
  aic_selected == P,
  all(lag_criteria$T_common == 141L),
  all(is.finite(levels))
)


# 5--7. Reduced form, SVAR-IV point, and AR sets -------------------

cat("\n[3--5] RForm_VAR, SVAR-IV impact, and AR inversion\n")

set_rows <- list()
diagnostic_rows <- list()
point_deviations <- numeric(1L)
impact_deviations <- numeric(1L)

for (i in 1L) {
  cell_id <- "production"
  variables <- VAR_SPEC$vars
  label <- VAR_SPEC$label
  data_cell <- levels[, variables, drop = FALSE]
  mp_index <- match(MP_VAR, variables)
  fit <- olea_rform_var(
    data_cell,
    P,
    deterministic = VAR_SPEC$deterministic
  )

  residual_dates <- dates_level[(P + 1L):length(dates_level)]
  instrument_index <- match(residual_dates, instrument$month)
  if (anyNA(instrument_index)) {
    stop("The instrument does not cover every residual month in ", label)
  }
  z <- instrument$shock[instrument_index]

  covariance <- mosw_rform_cov(
    fit$X,
    z,
    fit$eta,
    P,
    nw_lags = NW_LAGS
  )
  svar_iv <- mosw_svar_iv(
    fit$AL,
    fit$Sigma,
    covariance$Gamma,
    H,
    SCALE,
    mp_index
  )
  derivatives <- mosw_response_derivatives(
    fit$AL,
    P,
    H,
    covariance$Gamma
  )

  companion <- if (P == 1L) fit$AL else {
    rbind(
      fit$AL,
      cbind(diag(length(variables) * (P - 1L)),
            matrix(0, length(variables) * (P - 1L), length(variables)))
    )
  }
  max_root <- max(Mod(eigen(companion)$values))

  cell_ar <- lapply(AR_LEVELS, function(level) {
    mosw_ar_bounds(
      derivatives,
      covariance,
      nvar = mp_index,
      scale = SCALE,
      confidence = level
    )
  })
  names(cell_ar) <- sprintf("%.2f", AR_LEVELS)

  point_deviations[i] <- max(vapply(
    cell_ar,
    function(ar) max(abs(ar$point - svar_iv$point)),
    numeric(1)
  ))
  impact_deviations[i] <- max(vapply(
    seq_len(H + 1L),
    function(horizon) {
      max(abs(
        svar_iv$point[, horizon] -
          derivatives$C[, , horizon] %*% svar_iv$B1
      ))
    },
    numeric(1)
  ))

  for (level_key in names(cell_ar)) {
    ar <- cell_ar[[level_key]]
    set_rows[[length(set_rows) + 1L]] <- data.frame(
      cell_id = cell_id,
      cell = label,
      var = rep(variables, times = H + 1L),
      h = rep(0:H, each = length(variables)),
      level = as.numeric(level_key),
      point = as.vector(ar$point),
      lo = as.vector(ar$lo),
      hi = as.vector(ar$hi),
      set_type = as.vector(ar$set_type),
      casedummy = as.vector(ar$casedummy),
      ahat = as.vector(ar$ahat),
      bhat = as.vector(ar$bhat),
      chat = as.vector(ar$chat),
      delta = as.vector(ar$Delta),
      stringsAsFactors = FALSE
    )
  }

  ar90 <- cell_ar[["0.90"]]
  diagnostic_rows[[length(diagnostic_rows) + 1L]] <- data.frame(
    cell_id = cell_id,
    cell = label,
    n = length(variables),
    p = P,
    T_eff = covariance$T_eff,
    hac_dim = covariance$hac_dim,
    lag_common_T = 141L,
    aic_selected = aic_selected,
    bic_selected = bic_selected,
    xi_var = ar90$xi_den,
    ar_bounded_90 = ar90$ahat[1L, 1L] > 0,
    max_eig = max_root,
    gamma_yield = covariance$Gamma[mp_index],
    n_inst = length(z),
    n_inst_nonzero = sum(z != 0),
    stringsAsFactors = FALSE
  )

  cat(sprintf(
    "    %-10s n=%d T=%d xi=%6.3f max|lambda|=%.4f\n",
    cell_id,
    length(variables),
    covariance$T_eff,
    ar90$xi_den,
    max_root
  ))
}

sets <- dplyr::bind_rows(set_rows)
diagnostics <- dplyr::bind_rows(diagnostic_rows)


# Numerical and serialization gates --------------------------------

cat("\n[6] Numerical gates\n")

known_types <- c(
  "interval", "two_rays", "empty", "real_line", "singleton",
  "half_line_left", "half_line_right"
)
bounded_both <- sets$set_type %in% c("interval", "two_rays", "singleton")
left_infinite <- sets$set_type %in% c("real_line", "half_line_left")
right_infinite <- sets$set_type %in% c("real_line", "half_line_right")
empty <- sets$set_type == "empty"

normalisation <- sets |>
  dplyr::filter(var == MP_VAR, h == 0L)

stopifnot(
  max(point_deviations) < 1e-12,
  max(impact_deviations) < 1e-12,
  all(diagnostics$max_eig < 1),
  nrow(normalisation) == 2L,
  all(normalisation$point == SCALE),
  all(normalisation$set_type == "singleton"),
  all(normalisation$lo == SCALE),
  all(normalisation$hi == SCALE),
  all(sets$set_type %in% known_types),
  all(is.finite(sets$lo[bounded_both])),
  all(is.finite(sets$hi[bounded_both])),
  all(is.infinite(sets$lo[left_infinite]) & sets$lo[left_infinite] < 0),
  all(is.infinite(sets$hi[right_infinite]) & sets$hi[right_infinite] > 0),
  all(is.na(sets$lo[empty])),
  all(is.na(sets$hi[empty]))
)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
readr::write_csv(lag_criteria, file.path(OUT_DIR, "var_benchmark_lag_criteria.csv"))
readr::write_csv(sets, file.path(OUT_DIR, "svar_iv_weak_robust.csv"))
readr::write_csv(diagnostics, file.path(OUT_DIR, "svar_iv_weak_robust_diag.csv"))

sets_roundtrip <- readr::read_csv(
  file.path(OUT_DIR, "svar_iv_weak_robust.csv"),
  show_col_types = FALSE
)
stopifnot(
  identical(sets_roundtrip$set_type, sets$set_type),
  identical(is.infinite(sets_roundtrip$lo), is.infinite(sets$lo)),
  identical(is.infinite(sets_roundtrip$hi), is.infinite(sets$hi)),
  identical(is.na(sets_roundtrip$lo), is.na(sets$lo)),
  identical(is.na(sets_roundtrip$hi), is.na(sets$hi)),
  all(
    sign(sets_roundtrip$lo[is.infinite(sets$lo)]) ==
      sign(sets$lo[is.infinite(sets$lo)])
  ),
  all(
    sign(sets_roundtrip$hi[is.infinite(sets$hi)]) ==
      sign(sets$hi[is.infinite(sets$hi)])
  )
)

topology <- sets |>
  dplyr::count(level, set_type, name = "n_sets") |>
  dplyr::arrange(level, set_type)
print(topology, row.names = FALSE)

headline <- sets |>
  dplyr::filter(
    level == 0.90,
    h <= 4L,
    var %in% c("cambio_usd", "cds_5y")
  ) |>
  dplyr::mutate(
    ar_set = dplyr::case_when(
      set_type == "interval" ~ sprintf("[%s; %s]", fmt(lo, 4), fmt(hi, 4)),
      set_type == "singleton" ~ sprintf("{%s}", fmt(lo, 4)),
      set_type == "two_rays" ~ sprintf(
        "(-Inf; %s] U [%s; Inf)", fmt(lo, 4), fmt(hi, 4)
      ),
      set_type == "half_line_left" ~ sprintf("(-Inf; %s]", fmt(hi, 4)),
      set_type == "half_line_right" ~ sprintf("[%s; Inf)", fmt(lo, 4)),
      set_type == "real_line" ~ "(-Inf; Inf)",
      set_type == "empty" ~ "empty"
    )
  ) |>
  dplyr::select(cell_id, cell, var, h, point, ar_set)

report <- c(
  "# SVAR-IV de observáveis pelo método de Montiel Olea et al.",
  "",
  "> Gerado por `script/model_var.R`; reescrito a cada execução.",
  "",
  paste0(
    "A célula de produção usa `{ibc_br, price_ipca, yield_6m, cambio_usd, ",
    "cds_5y}` em nível, o instrumento externo `", SPEC$instrument, "` e ",
    "normalização de +50 pb no impacto em `yield_6m`. Cada equação inclui ",
    "constante e tendência linear. As respostas são os valores `C_h B_1` ",
    "de cada horizonte."
  ),
  "",
  "## AIC, BIC e diagnósticos numéricos",
  "",
  md_tbl(lag_criteria, digits = 5),
  "",
  md_tbl(diagnostics, digits = 5),
  "",
  paste0(
    "AIC e BIC usam as mesmas T = 141 observações para p = 1,...,12. ",
    "O AIC seleciona p = ", aic_selected, " e o BIC seleciona p = ",
    bic_selected, ". A produção segue o AIC. `NWlags = 0`."
  ),
  "",
  "## Topologias dos conjuntos Anderson--Rubin",
  "",
  md_tbl(topology, digits = 2),
  "",
  paste0(
    "O CSV preserva intervalos, conjuntos vazios, singletons, semirretas, ",
    "duas semirretas e a reta inteira sem substituir limites infinitos."
  ),
  "",
  "## Respostas de manchete até h = 4, AR 90%",
  "",
  md_tbl(headline, digits = 4),
  "",
  paste0(
    "A fonte canônica dos pontos e conjuntos AR é ",
    "`output/var/svar_iv_weak_robust.csv`."
  )
)
writeLines(report, file.path(OUT_DIR, "svar_iv_weak_robust.md"))

cat("\nWritten:\n")
cat("  output/var/var_benchmark_lag_criteria.csv\n")
cat("  output/var/svar_iv_weak_robust.csv\n")
cat("  output/var/svar_iv_weak_robust_diag.csv\n")
cat("  output/var/svar_iv_weak_robust.md\n")
