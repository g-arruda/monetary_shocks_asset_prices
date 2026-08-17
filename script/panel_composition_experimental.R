# Experimental panel-composition round. This script is intentionally isolated
# from production: it reads the canonical panel and candidate inputs, builds
# every variant in memory, and writes only to output/panel_experimental/.

rm(list = ls())

source("R/data_download/panel_candidates.R")
source("R/preprocessing/panel_candidates.R")
source("R/identification/experimental_panel.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")

R_FAC <- 7L
Q_FAC <- 6L
P_LAGS <- 6L
HORIZON <- 48L
NBOOT <- 800L
BOOTSTRAP_SEED <- 123L
MP_VAR <- "yield_6m"
VARIANT <- "z_jk_bs_purif"
SHOCK_BPS <- 50
CI_LEVELS <- c(0.68, 0.90)
OUT_DIR <- "output/panel_experimental"
EXPECTED_DATES <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
SAMPLES <- list(
  full = as.Date(c("2013-01-01", "2025-09-01")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-01"))
)
RESPONSE_VARS <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")


#' Describe block weights, shock participation, and commonality in one cell
#'
#' @param dfm Fitted DFM.
#' @param panel Panel matrix used to estimate `dfm`.
#' @param blocks Named fine-block vector aligned with panel columns.
#' @param diagnostic Factor-space instrument diagnostic.
#'
#' @return List with block composition and long squared-loading tables.
describe_panel_cell <- function(dfm, panel, blocks, diagnostic) {
  yy <- diff(panel)
  yy <- sweep(yy, 2, colMeans(yy), "-")
  yy <- sweep(yy, 2, apply(yy, 2, stats::sd), "/")
  if (any(!is.finite(yy))) {
    stop("BLL-standardized first differences are not finite.")
  }

  lambda <- dfm$static_loadings
  factor_names <- paste0("F", seq_len(ncol(lambda)))
  colnames(lambda) <- factor_names
  chi <- yy %*% lambda %*% t(lambda)
  comm_r2 <- colSums(chi^2) / colSums(yy^2)
  factor_share <- sapply(factor_names, function(factor_name) {
    tapply(lambda[, factor_name]^2, blocks, sum)
  })
  factor_share <- as.matrix(factor_share)
  factor_share[is.na(factor_share)] <- 0
  factor_share <- factor_share[sort(rownames(factor_share)), , drop = FALSE]

  g_static <- map_dynamic_direction_to_static(dfm, diagnostic$H)
  shock_weights <- abs(g_static) / sum(abs(g_static))
  shock_share <- drop(factor_share %*% shock_weights)
  unique_blocks <- rownames(factor_share)
  n_effective <- vapply(unique_blocks, function(block) {
    idx <- which(blocks == block)
    if (length(idx) == 1) return(1)
    eigenvalues <- eigen(stats::cor(yy[, idx, drop = FALSE]), only.values = TRUE)$values
    sum(eigenvalues)^2 / sum(eigenvalues^2)
  }, numeric(1))
  block_n <- table(factor(blocks, levels = unique_blocks)) |> as.numeric()
  info_share <- n_effective / sum(n_effective)
  composition <- tibble::tibble(
    block = unique_blocks,
    n_series = block_n,
    share_panel = block_n / ncol(panel),
    n_effective = n_effective,
    share_effective = info_share,
    overweight = (block_n / ncol(panel)) / info_share,
    shock_share = shock_share,
    commonality_mean = vapply(unique_blocks, function(block) mean(comm_r2[blocks == block]), numeric(1))
  )
  loadings <- as.data.frame(factor_share) |>
    tibble::rownames_to_column("block") |>
    tidyr::pivot_longer(-block, names_to = "factor", values_to = "squared_loading_share")
  list(composition = composition, loadings = loadings)
}


#' Convert required IRFs to a compact long table
#'
#' @param cell Full experimental cell object.
#' @param variant Variant identifier.
#' @param sample_name Sample identifier.
#'
#' @return Long tibble for the five pre-specified response variables.
extract_required_irfs <- function(cell, variant, sample_name) {
  indices <- match(RESPONSE_VARS, cell$var_names)
  if (anyNA(indices)) {
    stop("A required response is absent from ", variant, ".")
  }
  purrr::map_dfr(seq_along(RESPONSE_VARS), function(i) {
    index <- indices[i]
    tibble::tibble(
      variant = variant,
      sample = sample_name,
      response = RESPONSE_VARS[i],
      horizon = 0:HORIZON,
      point = cell$irfs$irf_point_matrix[index, ],
      lower_68 = cell$irfs$ci[["0.68"]]$lower[index, ],
      upper_68 = cell$irfs$ci[["0.68"]]$upper[index, ],
      lower_90 = cell$irfs$ci[["0.90"]]$lower[index, ],
      upper_90 = cell$irfs$ci[["0.90"]]$upper[index, ]
    )
  })
}


#' Draw a variant-versus-baseline IRF comparison for one sample
#'
#' @param irfs Long IRF table for all cells.
#' @param variant Non-baseline variant identifier.
#' @param sample_name Sample identifier.
#'
#' @return ggplot object with 68/90 percent bootstrap bands.
plot_variant_overlay <- function(irfs, variant, sample_name) {
  data <- irfs |>
    dplyr::filter(sample == sample_name, variant %in% c("baseline", variant)) |>
    dplyr::mutate(specification = dplyr::if_else(variant == "baseline", "baseline", variant))
  ggplot2::ggplot(data, ggplot2::aes(x = horizon, colour = specification, fill = specification)) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "grey55") +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower_90, ymax = upper_90), alpha = 0.08, colour = NA) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower_68, ymax = upper_68), alpha = 0.16, colour = NA) +
    ggplot2::geom_line(ggplot2::aes(y = point), linewidth = 0.55) +
    ggplot2::facet_wrap(~response, scales = "free_y", ncol = 2) +
    ggplot2::scale_colour_manual(values = stats::setNames(c("black", "#0072B2"), c("baseline", variant))) +
    ggplot2::scale_fill_manual(values = stats::setNames(c("black", "#0072B2"), c("baseline", variant))) +
    ggplot2::labs(
      title = paste("Experimental panel:", variant, "vs baseline"),
      subtitle = paste("Sample:", sample_name, "| shaded bands: 68% and 90% wild bootstrap"),
      x = "Months after the shock", y = NULL, colour = NULL, fill = NULL
    ) +
    ggplot2::theme_classic() +
    ggplot2::theme(legend.position = "bottom")
}


dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

base_data <- readr::read_csv("data/processed/data_log_deseasonalized_base_106.csv", show_col_types = FALSE)
if (!identical(as.Date(base_data$ref.date), EXPECTED_DATES) || anyNA(base_data) ||
    any(!is.finite(as.matrix(base_data[, -1])))) {
  stop("The canonical processed panel must contain exactly 153 complete finite months.")
}
base_dates <- as.Date(base_data$ref.date)
base_mat <- base_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
if (ncol(base_mat) != 106L) {
  stop("The experimental baseline must be the canonical 106-series panel, not ", ncol(base_mat), ".")
}

instrument_panel <- readr::read_csv("data/processed/instrumentos_mensais.csv", show_col_types = FALSE) |>
  dplyr::transmute(month = as.Date(month), shock = .data[[VARIANT]]) |>
  dplyr::filter(!is.na(shock))
if (anyDuplicated(instrument_panel$month) || any(!is.finite(instrument_panel$shock))) {
  stop("The selected instrument has invalid monthly observations.")
}

experimental <- build_experimental_panels(base_mat, EXPECTED_DATES, MP_VAR)
candidate_inputs <- experimental$candidate_inputs
variant_manifest <- experimental$variant_manifest
panels <- experimental$panels
manifest_detail <- purrr::imap_dfr(panels, function(panel, variant) {
  tibble::tibble(
    variant = variant,
    n_series = ncol(panel$matrix),
    added = paste(panel$additions, collapse = ";"),
    removed = paste(setdiff(colnames(base_mat), colnames(panel$matrix)), collapse = ";"),
    dates = length(base_dates),
    first_month = min(base_dates),
    last_month = max(base_dates)
  )
})
if (!all(manifest_detail$dates == 153L)) {
  stop("Every experimental panel must retain all 153 months.")
}

readr::write_csv(variant_manifest |> dplyr::left_join(manifest_detail, by = "variant"), file.path(OUT_DIR, "variant_manifest.csv"))
readr::write_csv(candidate_inputs$treatments, file.path(OUT_DIR, "candidate_treatments.csv"))

strength_rows <- list()
composition_rows <- list()
loading_rows <- list()
irf_rows <- list()
cells <- list()
row_index <- 0L

for (variant in variant_manifest$variant) {
  panel <- panels[[variant]]
  for (sample_name in names(SAMPLES)) {
    window <- SAMPLES[[sample_name]]
    in_window <- base_dates >= window[1] & base_dates <= window[2]
    data_sub <- panel$matrix[in_window, , drop = FALSE]
    dates_sub <- base_dates[in_window]
    if (any(!is.finite(data_sub)) || anyDuplicated(dates_sub)) {
      stop("Invalid data in cell ", variant, " / ", sample_name, ".")
    }
    mpind <- match(MP_VAR, colnames(data_sub))
    dfm_point <- estimate_dfm(data_sub, r = R_FAC, q = Q_FAC, p = P_LAGS,
                              dates = dates_sub, apply_kilian = FALSE)
    diagnostic <- diagnose_instrument_in_factor_space(
      dfm_point, instrument_panel, dates_sub, P_LAGS, mpind
    )
    description <- describe_panel_cell(dfm_point, data_sub, panel$blocks, diagnostic)

    warning_log <- character()
    cell <- withCallingHandlers({
      dfm_boot <- estimate_dfm(data_sub, r = R_FAC, q = Q_FAC, p = P_LAGS,
                               dates = dates_sub, instrument = instrument_panel,
                               apply_kilian = TRUE)
      irfs <- compute_irf_dfm(
        dfm_boot,
        h = HORIZON,
        nboot = NBOOT,
        bootstrap_seed = BOOTSTRAP_SEED,
        mpind = mpind,
        normalize_value = norm_value_for(MP_VAR, SHOCK_BPS),
        tcode = panel$tcodes,
        ci_levels = CI_LEVELS,
        var_names = colnames(data_sub)
      )
      list(
        model = dfm_boot,
        irfs = irfs,
        var_names = colnames(data_sub),
        tcode = panel$tcodes,
        block = panel$blocks,
        diagnostic = diagnostic,
        composition = description$composition,
        loadings = description$loadings,
        variant = variant,
        sample = sample_name,
        dates = dates_sub,
        settings = list(r = R_FAC, q = Q_FAC, p = P_LAGS, h = HORIZON,
                        nboot = NBOOT, seed = BOOTSTRAP_SEED, mp_var = MP_VAR,
                        shock_bps = SHOCK_BPS, ci_levels = CI_LEVELS)
      )
    }, warning = function(w) {
      warning_log <<- c(warning_log, conditionMessage(w))
      invokeRestart("muffleWarning")
    })
    bootstrap_failures <- grep("Bootstrap iteracao", warning_log, value = TRUE)
    if (length(bootstrap_failures) > 0) {
      stop("Bootstrap failed in ", variant, " / ", sample_name, ": ",
           paste(unique(bootstrap_failures), collapse = " | "))
    }

    cell_path <- file.path(OUT_DIR, paste0("cell_", variant, "_", sample_name, ".rds"))
    saveRDS(cell, cell_path)
    cells[[paste(variant, sample_name, sep = "__")]] <- cell
    row_index <- row_index + 1L
    strength_rows[[row_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      n_series = ncol(data_sub),
      n_months = nrow(data_sub),
      n_obs_align = diagnostic$n_obs,
      r = R_FAC,
      q = Q_FAC,
      p = P_LAGS,
      xi_mp = diagnostic$wald_mp,
      f_robust_mp = diagnostic$f_robust_mp,
      impact_mp_pre = diagnostic$impact_mp,
      mosw_class = classify_mosw(diagnostic$wald_mp)
    )
    composition_rows[[row_index]] <- description$composition |>
      dplyr::mutate(variant = variant, sample = sample_name, .before = 1)
    loading_rows[[row_index]] <- description$loadings |>
      dplyr::mutate(variant = variant, sample = sample_name, .before = 1)
    irf_rows[[row_index]] <- extract_required_irfs(cell, variant, sample_name)
  }
}

strength <- dplyr::bind_rows(strength_rows)
composition <- dplyr::bind_rows(composition_rows)
loadings <- dplyr::bind_rows(loading_rows)
irf_long <- dplyr::bind_rows(irf_rows)
readr::write_csv(strength, file.path(OUT_DIR, "strength_and_classification.csv"))
readr::write_csv(composition, file.path(OUT_DIR, "block_composition.csv"))
readr::write_csv(loadings, file.path(OUT_DIR, "block_squared_loadings.csv"))
readr::write_csv(irf_long, file.path(OUT_DIR, "irfs_required_long.csv"))

for (variant in setdiff(variant_manifest$variant, "baseline")) {
  for (sample_name in names(SAMPLES)) {
    plot <- plot_variant_overlay(irf_long, variant, sample_name)
    ggplot2::ggsave(
      file.path(OUT_DIR, paste0("irf_overlay_", variant, "_", sample_name, ".pdf")),
      plot, width = 11, height = 8, dpi = 200
    )
  }
}

baseline_strength <- strength |>
  dplyr::filter(variant == "baseline") |>
  dplyr::select(sample, xi_mp, f_robust_mp, mosw_class)
report <- c(
  "# Rodada experimental: composição do painel e dependência da curva",
  "",
  paste0("> Gerado por `script/panel_composition_experimental.R` em ", Sys.Date(),
         ". Todos os artefatos desta rodada vivem em `output/panel_experimental/`; ",
         "o painel canônico, a identificação e os outputs de produção não foram modificados."),
  "",
  "## Desenho fixado",
  "",
  "Nove variantes, duas amostras, `(r,q,p)=(7,6,6)`, `z_jk_bs_purif`, `yield_6m`, +50 bp, horizonte 0--48, 800 wild bootstraps com seed 123 e bandas de 68%/90%.",
  "A retirada de `juros_cdi` e `asset_mlcx` é apenas diagnóstico de ponderação; não implica exclusão automática.",
  "",
  "## Força e classificação MOSW",
  "",
  md_table(strength, digits = 4),
  "",
  "## Baseline de referência",
  "",
  md_table(baseline_strength, digits = 4),
  "",
  "## Leitura delimitada",
  "",
  "A comparação é descritiva: a conclusão depende da estabilidade conjunta de força, direção das cinco IRFs e bandas, não do maior `xi_mp`.",
  "As séries fiscais são vintage corrente: não constituem um teste estrito de informação fiscal disponível em tempo real.",
  "Mudanças entre variantes são mudanças de especificação/reponderação do painel; não são tratadas como mudanças no instrumento, na identificação ou no painel de produção.",
  "",
  "## Arquivos",
  "",
  "- `variant_manifest.csv`: variantes, inclusões, exclusões e cobertura.",
  "- `candidate_treatments.csv`: fontes, transformações e ajuste sazonal por candidata.",
  "- `block_composition.csv` e `block_squared_loadings.csv`: dimensão efetiva, sobrepeso, cargas, participação no choque e comunalidade.",
  "- `strength_and_classification.csv`, `irfs_required_long.csv`, `cell_<variant>_<sample>.rds` e `irf_overlay_*.pdf`: resultados completos por célula."
)
writeLines(report, file.path(OUT_DIR, "panel_composition_experimental.md"), useBytes = TRUE)

message("Experimental panel-composition round completed in ", OUT_DIR, ".")
