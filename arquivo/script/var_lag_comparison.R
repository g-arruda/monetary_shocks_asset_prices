# ===================================================================
# Sensitivity of the observable VAR to p = 2 versus p = 6.
#
# This script does not change the production benchmark. It compares the
# canonical VAR(2), a VAR(2) on the VAR(6) residual sample, and the VAR(6).
# ===================================================================

rm(list = ls())

source("R/modeling/production_spec.R")
source("R/modeling/var_proxy.R")
source("R/identification/weak_iv_ar.R")
source("R/reporting/markdown_report.R")

required_packages <- c("dplyr", "ggplot2", "readr", "tidyr")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing packages: ", paste(missing_packages, collapse = ", "))
}


#' Find the first zero crossing after impact
#'
#' A crossing occurs when adjacent point estimates have opposite signs or
#' when the later estimate is exactly zero. The impact horizon is not itself
#' classified as a crossing.
#'
#' @param point Numeric impulse-response path.
#' @param h Integer horizons corresponding to `point`.
#'
#' @return First crossing horizon, or `NA_integer_` if none occurs.
first_zero_crossing <- function(point, h) {
  if (length(point) != length(h) || length(point) < 2L) {
    stop("point and h must have equal lengths of at least two")
  }
  crossings <- which(
    point[-1L] == 0 | point[-length(point)] * point[-1L] < 0
  ) + 1L
  if (length(crossings)) as.integer(h[crossings[1L]]) else NA_integer_
}


SPEC <- production_spec()
VAR_SPEC <- SPEC$var_benchmark
OUT_DIR <- "output/var"
P2 <- VAR_SPEC$p
P6 <- SPEC$p
H <- VAR_SPEC$ar_horizon
MP_VAR <- SPEC$mp_var
SCALE <- SPEC$normalize_value

if (
  !identical(VAR_SPEC$label, "ibc5_fx_cds_level_trend_p2") ||
    !identical(VAR_SPEC$deterministic, "trend") ||
    P2 != 2L || P6 != 6L || H != 36L ||
    !identical(VAR_SPEC$vars, c(
      "ibc_br", "price_ipca", "yield_6m", "cambio_usd", "cds_5y"
    )) ||
    !identical(SPEC$instrument, "z_jk_bs_purif") ||
    !identical(MP_VAR, "yield_6m") || SCALE != 0.005
) {
  stop("The VAR or DFM specification no longer matches the comparison design")
}

cat("=== Sensitivity of the observable VAR to lag order ===\n\n")

panel <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |>
  dplyr::filter(
    ref.date >= VAR_SPEC$sample[1L],
    ref.date <= VAR_SPEC$sample[2L]
  ) |>
  dplyr::select(ref.date, dplyr::all_of(VAR_SPEC$vars))

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

instrument <- readr::read_csv(SPEC$instrument_path, show_col_types = FALSE) |>
  dplyr::transmute(
    month = as.Date(month),
    shock = .data[[SPEC$instrument]]
  )
if (anyNA(instrument) || anyDuplicated(instrument$month)) {
  stop("The external instrument has missing or duplicated months")
}

common_criteria <- var_lag_criteria(
  levels,
  pmax = P6,
  deterministic = VAR_SPEC$deterministic
) |>
  dplyr::filter(p %in% c(P2, P6))

cell_specs <- data.frame(
  cell_id = c("p2_canonical", "p2_common", "p6_common"),
  cell = c(
    "VAR(2) canônico, 151 resíduos",
    "VAR(2), amostra comum de 147 resíduos",
    "VAR(6), amostra comum de 147 resíduos"
  ),
  p = c(P2, P2, P6),
  first_row = c(1L, P6 - P2 + 1L, 1L),
  reference_cell = c(NA, "p2_canonical", "p2_common"),
  comparison = c(
    "referência canônica",
    "efeito de retirar os quatro primeiros resíduos",
    "efeito da ordem de defasagem na amostra comum"
  ),
  stringsAsFactors = FALSE
)

fits <- lapply(seq_len(nrow(cell_specs)), function(i) {
  spec <- cell_specs[i, ]
  rows <- spec$first_row:nrow(levels)
  series <- levels[rows, , drop = FALSE]
  dates <- dates_level[rows]
  fit <- olea_rform_var(
    series,
    spec$p,
    deterministic = VAR_SPEC$deterministic
  )

  residual_dates <- dates[(spec$p + 1L):length(dates)]
  instrument_index <- match(residual_dates, instrument$month)
  if (anyNA(instrument_index)) {
    stop("The instrument does not cover every residual month in ", spec$cell_id)
  }
  z <- instrument$shock[instrument_index]
  Gamma <- drop(fit$eta %*% z / length(z))
  mp_index <- match(MP_VAR, VAR_SPEC$vars)
  svar_iv <- mosw_svar_iv(
    fit$AL,
    fit$Sigma,
    Gamma,
    H,
    SCALE,
    mp_index
  )

  companion <- if (spec$p == 1L) fit$AL else {
    rbind(
      fit$AL,
      cbind(
        diag(length(VAR_SPEC$vars) * (spec$p - 1L)),
        matrix(
          0,
          length(VAR_SPEC$vars) * (spec$p - 1L),
          length(VAR_SPEC$vars)
        )
      )
    )
  }

  hac_dim <- (ncol(fit$X) + nrow(fit$eta) + 1L) * nrow(fit$eta)
  if (spec$p < P6) {
    covariance <- mosw_rform_cov(
      fit$X,
      z,
      fit$eta,
      spec$p,
      nw_lags = VAR_SPEC$nw_lags
    )
    if (max(abs(covariance$Gamma - Gamma)) >= 1e-15) {
      stop("Direct and MOSW covariance estimates differ in ", spec$cell_id)
    }
  } else if (hac_dim < length(z)) {
    stop("The declared VAR(6) HAC gate is no longer binding")
  }

  logdet <- determinant(fit$Sigma, logarithm = TRUE)
  if (logdet$sign <= 0L) {
    stop("Residual covariance is not positive definite in ", spec$cell_id)
  }

  list(
    fit = fit,
    residual_dates = residual_dates,
    z = z,
    Gamma = Gamma,
    svar_iv = svar_iv,
    hac_dim = hac_dim,
    max_root = max(Mod(eigen(companion)$values)),
    logdet = as.numeric(logdet$modulus)
  )
})
names(fits) <- cell_specs$cell_id

common_dates <- fits$p6_common$residual_dates
if (
  !identical(fits$p2_common$residual_dates, common_dates) ||
    !identical(fits$p2_common$z, fits$p6_common$z) ||
    length(common_dates) != SPEC$n_innovations ||
    sum(fits$p2_common$z != 0) != 60L ||
    sum(fits$p6_common$z != 0) != 60L
) {
  stop("The common-sample cells do not share 147 residual months and 60 events")
}

diagnostics <- dplyr::bind_rows(lapply(seq_len(nrow(cell_specs)), function(i) {
  spec <- cell_specs[i, ]
  result <- fits[[spec$cell_id]]
  T_eff <- ncol(result$fit$eta)
  n_parameters <- length(VAR_SPEC$vars)^2 * spec$p +
    length(VAR_SPEC$vars) * 2L
  criteria <- common_criteria |>
    dplyr::filter(p == spec$p)
  common_cell <- spec$cell_id %in% c("p2_common", "p6_common")

  data.frame(
    cell_id = spec$cell_id,
    cell = spec$cell,
    p = spec$p,
    n_parameters = n_parameters,
    T_eff = T_eff,
    residual_start = min(result$residual_dates),
    residual_end = max(result$residual_dates),
    n_inst_nonzero = sum(result$z != 0),
    gamma_yield = result$Gamma[match(MP_VAR, VAR_SPEC$vars)],
    max_root = result$max_root,
    stable = result$max_root < 1,
    hac_dim = result$hac_dim,
    inference_status = if (result$hac_dim < T_eff) {
      "WHat viável; AR não reestimado neste exercício"
    } else {
      "AR indisponível: dimensão HAC >= T"
    },
    common_logdet = if (common_cell) criteria$logdet else NA_real_,
    common_aic = if (common_cell) criteria$aic else NA_real_,
    common_bic = if (common_cell) criteria$bic else NA_real_,
    stringsAsFactors = FALSE
  )
}))

irf <- dplyr::bind_rows(lapply(seq_len(nrow(cell_specs)), function(i) {
  spec <- cell_specs[i, ]
  point <- fits[[spec$cell_id]]$svar_iv$point
  data.frame(
    cell_id = spec$cell_id,
    cell = spec$cell,
    reference_cell = spec$reference_cell,
    comparison = spec$comparison,
    var = rep(VAR_SPEC$vars, times = H + 1L),
    h = rep(0:H, each = length(VAR_SPEC$vars)),
    point = as.vector(point),
    stringsAsFactors = FALSE
  )
})) |>
  dplyr::group_by(cell_id) |>
  dplyr::mutate(
    reference_point = if (is.na(dplyr::first(reference_cell))) {
      NA_real_
    } else {
      reference <- dplyr::first(reference_cell)
      irf_reference <- fits[[reference]]$svar_iv$point
      as.vector(irf_reference)
    },
    difference_vs_reference = point - reference_point
  ) |>
  dplyr::ungroup()

canonical <- readr::read_csv(
  file.path(OUT_DIR, "svar_iv_weak_robust.csv"),
  show_col_types = FALSE
) |>
  dplyr::filter(level == 0.90) |>
  dplyr::select(var, h, canonical_point = point)
canonical_check <- irf |>
  dplyr::filter(cell_id == "p2_canonical") |>
  dplyr::left_join(canonical, by = c("var", "h"))
if (
  nrow(canonical_check) != length(VAR_SPEC$vars) * (H + 1L) ||
    anyNA(canonical_check$canonical_point) ||
    max(abs(canonical_check$point - canonical_check$canonical_point)) >= 1e-12
) {
  stop("The canonical VAR(2) IRFs do not reproduce the production artifact")
}

impact_deviation <- max(vapply(fits, function(result) {
  max(vapply(seq_len(H + 1L), function(horizon) {
    max(abs(
      result$svar_iv$point[, horizon] -
        result$svar_iv$C[, , horizon] %*% result$svar_iv$B1
    ))
  }, numeric(1)))
}, numeric(1)))

normalisation <- irf |>
  dplyr::filter(var == MP_VAR, h == 0L)
if (
  nrow(irf) != 3L * length(VAR_SPEC$vars) * (H + 1L) ||
    any(!is.finite(irf$point)) ||
    nrow(normalisation) != 3L ||
    any(normalisation$point != SCALE) ||
    impact_deviation >= 1e-12 ||
    fits$p6_common$hac_dim != 190L ||
    fits$p6_common$hac_dim < length(fits$p6_common$z)
) {
  stop("A numerical or coverage gate failed")
}

path_summary <- irf |>
  dplyr::group_by(cell_id, cell, reference_cell, comparison, var) |>
  dplyr::summarise(
    first_zero_crossing = first_zero_crossing(point, h),
    reference_first_zero_crossing = if (all(is.na(reference_point))) {
      NA_integer_
    } else {
      first_zero_crossing(reference_point, h)
    },
    path_correlation = if (all(is.na(reference_point))) {
      NA_real_
    } else if (sd(point) == 0 || sd(reference_point) == 0) {
      as.numeric(isTRUE(all.equal(point, reference_point)))
    } else {
      cor(point, reference_point)
    },
    max_abs_difference = if (all(is.na(difference_vs_reference))) {
      NA_real_
    } else {
      max(abs(difference_vs_reference))
    },
    mean_abs_difference = if (all(is.na(difference_vs_reference))) {
      NA_real_
    } else {
      mean(abs(difference_vs_reference))
    },
    .groups = "drop"
  ) |>
  dplyr::left_join(
    diagnostics,
    by = c("cell_id", "cell")
  ) |>
  dplyr::select(
    cell_id, cell, reference_cell, comparison, var,
    first_zero_crossing, reference_first_zero_crossing, path_correlation,
    max_abs_difference, mean_abs_difference, dplyr::everything()
  )

selected_horizons <- c(0L, 1L, 4L, 12L, 24L, 36L)
response_table <- irf |>
  dplyr::filter(h %in% selected_horizons) |>
  dplyr::select(var, h, cell_id, point) |>
  tidyr::pivot_wider(names_from = cell_id, values_from = point) |>
  dplyr::arrange(match(var, VAR_SPEC$vars), h)

comparison_table <- path_summary |>
  dplyr::filter(cell_id != "p2_canonical") |>
  dplyr::select(
    comparison, var, path_correlation, max_abs_difference,
    reference_first_zero_crossing, first_zero_crossing
  )

diagnostic_table <- diagnostics |>
  dplyr::select(
    cell_id, p, n_parameters, T_eff, residual_start, residual_end,
    n_inst_nonzero, gamma_yield, max_root, stable, hac_dim,
    inference_status
  )

fit_table <- diagnostics |>
  dplyr::filter(cell_id %in% c("p2_common", "p6_common")) |>
  dplyr::select(cell_id, p, T_eff, common_logdet, common_aic, common_bic)

variable_labels <- c(
  ibc_br = "IBC-Br",
  price_ipca = "IPCA",
  yield_6m = "Yield de 6 meses",
  cambio_usd = "Câmbio R$/US$",
  cds_5y = "CDS de 5 anos"
)
cell_labels <- c(
  p2_canonical = "VAR(2) canônico",
  p2_common = "VAR(2), amostra comum",
  p6_common = "VAR(6), amostra comum"
)

plot_data <- irf |>
  dplyr::mutate(
    var_label = factor(variable_labels[var], levels = variable_labels),
    cell_label = factor(cell_labels[cell_id], levels = cell_labels)
  )

path_plot <- ggplot2::ggplot(
  plot_data,
  ggplot2::aes(x = h, y = point, colour = cell_label, linetype = cell_label)
) +
  ggplot2::geom_hline(yintercept = 0, colour = "grey70", linewidth = 0.35) +
  ggplot2::geom_line(linewidth = 0.75) +
  ggplot2::facet_wrap(ggplot2::vars(var_label), scales = "free_y", ncol = 2) +
  ggplot2::scale_colour_manual(values = c("#1B4F72", "#D68910", "#922B21")) +
  ggplot2::scale_linetype_manual(values = c("solid", "dashed", "dotdash")) +
  ggplot2::labs(
    x = "Horizonte (meses)",
    y = "Resposta",
    colour = NULL,
    linetype = NULL
  ) +
  ggplot2::theme_minimal(base_size = 10) +
  ggplot2::theme(
    legend.position = "bottom",
    panel.grid.minor = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(face = "bold")
  )

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
readr::write_csv(path_summary, file.path(OUT_DIR, "var_lag_comparison_summary.csv"))
readr::write_csv(irf, file.path(OUT_DIR, "var_lag_comparison_irf.csv"))
ggplot2::ggsave(
  file.path(OUT_DIR, "var_lag_comparison_paths.pdf"),
  path_plot,
  width = 10,
  height = 7.5,
  device = grDevices::cairo_pdf
)

p2_common_diag <- diagnostics |>
  dplyr::filter(cell_id == "p2_common")
p6_common_diag <- diagnostics |>
  dplyr::filter(cell_id == "p6_common")
lag_effect <- path_summary |>
  dplyr::filter(cell_id == "p6_common")

report <- c(
  "# Sensibilidade do VAR observável à ordem de defasagem",
  "",
  "> Gerado por `script/var_lag_comparison.R`; reescrito a cada execução.",
  "> Este exercício não altera o benchmark oficial `p=2` nem a inferência do DFM.",
  "",
  paste0(
    "As três células mantêm as cinco séries em nível, constante e tendência ",
    "linear, o instrumento `", SPEC$instrument, "`, a normalização de +50 pb ",
    "em `yield_6m` e `h=0,...,36`. A comparação principal usa os mesmos 147 ",
    "resíduos em `p2_common` e `p6_common`; o `p2_canonical`, com 151 resíduos, ",
    "aparece somente como referência."
  ),
  "",
  "## Diagnósticos",
  "",
  md_tbl(diagnostic_table, digits = 6),
  "",
  "## Ajuste na amostra comum",
  "",
  md_tbl(fit_table, digits = 6),
  "",
  paste0(
    "O log-determinante, o AIC e o BIC desta tabela são comparáveis porque as ",
    "duas células usam exatamente os mesmos 147 resíduos. O VAR(2) tem ",
    p2_common_diag$n_parameters, " parâmetros no sistema e o VAR(6), ",
    p6_common_diag$n_parameters, "."
  ),
  "",
  "## Efeito de retirar os quatro primeiros resíduos",
  "",
  md_tbl(
    comparison_table |>
      dplyr::filter(comparison == "efeito de retirar os quatro primeiros resíduos"),
    digits = 6
  ),
  "",
  paste0(
    "Esta seção compara `p2_canonical` e `p2_common` e, portanto, isola apenas ",
    "o alinhamento amostral. Não envolve mudança da ordem de defasagem."
  ),
  "",
  "## Efeito da ordem de defasagem",
  "",
  md_tbl(
    comparison_table |>
      dplyr::filter(comparison == "efeito da ordem de defasagem na amostra comum"),
    digits = 6
  ),
  "",
  paste0(
    "Esta seção compara `p2_common` e `p6_common`, com meses residuais e vetor ",
    "instrumental idênticos. Correlações e diferenças descrevem trajetórias ",
    "pontuais; não são testes de igualdade."
  ),
  "",
  "## Respostas em horizontes selecionados",
  "",
  md_tbl(response_table, digits = 6),
  "",
  "As trajetórias completas estão em `var_lag_comparison_irf.csv` e na figura `var_lag_comparison_paths.pdf`.",
  "",
  "## Limitação de inferência",
  "",
  paste0(
    "No VAR(6), o vetor de momentos HAC tem dimensão ",
    p6_common_diag$hac_dim, " para T=", p6_common_diag$T_eff,
    ". Como a dimensão é maior ou igual a T, `WHat` é singular e os conjuntos ",
    "Anderson--Rubin/MOSW são indisponíveis. O script não tenta pseudoinversa, ",
    "bootstrap substituto ou qualquer fallback. A inferência AR canônica do ",
    "VAR(2) permanece em `output/var/svar_iv_weak_robust.csv`."
  ),
  "",
  "## Conclusões",
  "",
  paste0(
    "**Ajuste.** Na amostra comum, o VAR(6) reduz o log-determinante de ",
    fmt(p2_common_diag$common_logdet, 4), " para ",
    fmt(p6_common_diag$common_logdet, 4), ", mas paga pela expansão de ",
    p2_common_diag$n_parameters, " para ", p6_common_diag$n_parameters,
    " parâmetros. AIC e BIC permanecem critérios descritivos desta comparação; ",
    "a seleção canônica em `p=1,...,12` continua escolhendo `p=2` pelo AIC."
  ),
  "",
  paste0(
    "**Estabilidade.** As maiores raízes são ",
    fmt(p2_common_diag$max_root, 6), " no VAR(2) comum e ",
    fmt(p6_common_diag$max_root, 6), " no VAR(6). O status de estabilidade é ",
    "reportado como resultado, sem ter sido imposto pelo script."
  ),
  "",
  paste0(
    "**Dinâmica.** Na amostra comum, as correlações VAR(2)--VAR(6) são ",
    fmt(lag_effect$path_correlation[lag_effect$var == "yield_6m"], 3),
    " para o yield de 6 meses, ",
    fmt(lag_effect$path_correlation[lag_effect$var == "cambio_usd"], 3),
    " para o câmbio e ",
    fmt(lag_effect$path_correlation[lag_effect$var == "cds_5y"], 3),
    " para o CDS. A sensibilidade de forma é maior no IPCA (correlação ",
    fmt(lag_effect$path_correlation[lag_effect$var == "price_ipca"], 3),
    ") e sobretudo no IBC-Br (",
    fmt(lag_effect$path_correlation[lag_effect$var == "ibc_br"], 3),
    "). Essas diferenças são pontuais: sem inferência comparável para o VAR(6), ",
    "nenhuma é descrita como estatisticamente significativa."
  ),
  "",
  paste0(
    "O exercício não promove o VAR(6), não muda a escolha AIC do VAR(2), não ",
    "altera `production_spec()`, `script/model_var.R` ou seus artefatos e não ",
    "muda a inferência do DFM."
  )
)
writeLines(report, file.path(OUT_DIR, "var_lag_comparison.md"))

cat("Written:\n")
cat("  output/var/var_lag_comparison_summary.csv\n")
cat("  output/var/var_lag_comparison_irf.csv\n")
cat("  output/var/var_lag_comparison.md\n")
cat("  output/var/var_lag_comparison_paths.pdf\n")
