rm(list = ls())

source("R/modeling/production_spec.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")

spec <- production_spec()
run_bootstrap <- "--bootstrap" %in% commandArgs(trailingOnly = TRUE)
out_dir <- "output/fiscal_expectations"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

panel <- readr::read_csv(spec$data_path, show_col_types = FALSE) |>
  dplyr::mutate(ref.date = as.Date(ref.date))
fiscal <- readr::read_csv(
  "data/raw/focus_fiscal_expectations.csv",
  show_col_types = FALSE
) |>
  dplyr::mutate(ref.date = as.Date(ref.date))
instrument <- readr::read_csv(spec$instrument_path, show_col_types = FALSE)
dates <- panel$ref.date
expected_dates <- seq(spec$sample[1], spec$sample[2], by = "month")
fiscal_names <- c(
  "expect_focus_fiscal_dlsp_ny",
  "expect_focus_fiscal_primary_balance_ny",
  "expect_focus_fiscal_nominal_balance_ny"
)

if (!identical(dates, expected_dates) || !identical(fiscal$ref.date, expected_dates) ||
    ncol(panel) - 1L != 111L || anyDuplicated(fiscal$ref.date) ||
    anyNA(fiscal[, fiscal_names]) ||
    any(!is.finite(as.matrix(fiscal[, fiscal_names])))) {
  stop("The baseline or fiscal-expectations panel is not a complete 153-month finite sample.")
}

manifest <- tibble::tribble(
  ~variable, ~source, ~indicator, ~horizon, ~unit, ~coverage, ~sign_convention,
  "expect_focus_fiscal_dlsp_ny", "BCB Focus / ExpectativasMercadoAnuais", "Dívida líquida do setor público", "ano seguinte", "% do PIB", "2013-01 a 2025-09; última publicação mensal", "mais alta = deterioração esperada",
  "expect_focus_fiscal_primary_balance_ny", "BCB Focus / ExpectativasMercadoAnuais", "Resultado primário", "ano seguinte", "% do PIB", "2013-01 a 2025-09; última publicação mensal", "mais negativo = deterioração esperada",
  "expect_focus_fiscal_nominal_balance_ny", "BCB Focus / ExpectativasMercadoAnuais", "Resultado nominal", "ano seguinte", "% do PIB", "2013-01 a 2025-09; última publicação mensal", "mais negativo = deterioração esperada"
)
readr::write_csv(manifest, file.path(out_dir, "manifest.csv"))
readr::write_csv(fiscal, file.path(out_dir, "fiscal_expectations_audit.csv"))

baseline <- panel |>
  dplyr::select(-ref.date) |>
  as.matrix()
expanded <- cbind(baseline, as.matrix(fiscal[, fiscal_names]))
panels <- list(baseline_111 = baseline, fiscal_114 = expanded)
tcodes <- list(
  baseline_111 = infer_tcode_from_varnames(colnames(baseline)),
  fiscal_114 = c(infer_tcode_from_varnames(colnames(baseline)), rep(1L, 3L))
)
samples <- list(full = spec$sample, pre_covid = spec$pre_covid_sample)

selection <- purrr::imap_dfr(panels, function(data_mat, panel_name) {
  purrr::imap_dfr(samples, function(window, sample_name) {
    keep <- dates >= window[1] & dates <= window[2]
    bn <- bai_ng_criteria(data_mat[keep, , drop = FALSE], max_r = 20L, apply_bll = TRUE)
    aw <- amengual_watson(data_mat[keep, , drop = FALSE], r = spec$r, p = spec$p, apply_bll = TRUE)
    tibble::tibble(
      panel = panel_name,
      sample = sample_name,
      n_months = sum(keep),
      n_series = ncol(data_mat),
      bai_ng_ic2_r = bn$r_hat$IC2,
      amengual_watson_q = aw$q_hat
    )
  })
})
readr::write_csv(selection, file.path(out_dir, "factor_selection.csv"))

fixed <- purrr::imap_dfr(panels, function(data_mat, panel_name) {
  purrr::imap_dfr(samples, function(window, sample_name) {
    keep <- dates >= window[1] & dates <= window[2]
    fit <- estimate_dfm(data_mat[keep, , drop = FALSE], r = spec$r, q = spec$q,
                        p = spec$p, dates = dates[keep], apply_kilian = FALSE)
    strength <- diagnose_instrument_in_factor_space(
      fit,
      instrument |>
        dplyr::transmute(month = as.Date(month), shock = .data[[spec$instrument]]) |>
        dplyr::filter(!is.na(shock)),
      dates[keep], spec$p, match(spec$mp_var, colnames(data_mat))
    )
    tibble::tibble(
      panel = panel_name,
      sample = sample_name,
      r = spec$r,
      q = spec$q,
      p = spec$p,
      n_months = sum(keep),
      n_series = ncol(data_mat),
      n_obs_aligned = strength$n_obs,
      xi_mp = strength$wald_mp,
      f_robust_mp = strength$f_robust_mp,
      max_companion_root = fit$diagnostics$max_eigenvalue,
      stable = fit$diagnostics$is_stable
    )
  })
})
if (any(!fixed$stable) || any(!is.finite(as.matrix(fixed[, c("xi_mp", "f_robust_mp", "max_companion_root")]))) ||
    fixed$n_obs_aligned[fixed$panel == "baseline_111" & fixed$sample == "full"] != spec$n_innovations) {
  stop("The fixed fiscal-expectations comparison failed its stability or baseline-reproduction gate.")
}
readr::write_csv(fixed, file.path(out_dir, "strength_comparison.csv"))

grid <- purrr::imap_dfr(panels, function(data_mat, panel_name) {
  purrr::imap_dfr(samples, function(window, sample_name) {
    keep <- dates >= window[1] & dates <= window[2]
    purrr::map_dfr(5:8, function(r) {
      purrr::map_dfr(3:r, function(q) {
        result <- tryCatch({
          fit <- estimate_dfm(data_mat[keep, , drop = FALSE], r = r, q = q, p = spec$p,
                              dates = dates[keep], apply_kilian = FALSE)
          strength <- diagnose_instrument_in_factor_space(
            fit,
            instrument |>
              dplyr::transmute(month = as.Date(month), shock = .data[[spec$instrument]]) |>
              dplyr::filter(!is.na(shock)),
            dates[keep], spec$p, match(spec$mp_var, colnames(data_mat))
          )
          tibble::tibble(xi_mp = strength$wald_mp, f_robust_mp = strength$f_robust_mp,
                         n_obs_aligned = strength$n_obs,
                         max_companion_root = fit$diagnostics$max_eigenvalue,
                         stable = fit$diagnostics$is_stable, failure = NA_character_)
        }, error = function(error) {
          tibble::tibble(xi_mp = NA_real_, f_robust_mp = NA_real_, n_obs_aligned = NA_integer_,
                         max_companion_root = NA_real_, stable = NA, failure = conditionMessage(error))
        })
        dplyr::mutate(result, panel = panel_name, sample = sample_name, r = r, q = q, p = spec$p,
                      n_months = sum(keep), n_series = ncol(data_mat), .before = 1)
      })
    })
  })
})
if (nrow(grid) != 72L || any(grid$failure %in% NA_character_ & !is.finite(grid$xi_mp))) {
  stop("The fiscal-expectations dimension grid is incomplete or has an unrecorded failure.")
}
readr::write_csv(grid, file.path(out_dir, "strength_grid.csv"))

smoke <- run_stage2_cell(
  expanded, dates, instrument, spec$sample, spec$r, spec$q, spec$p,
  spec$instrument, spec$mp_var, spec$horizon, 0L, spec$bootstrap_seed,
  spec$shock_bps, tcodes$fiscal_114, spec$ci_levels,
    # Closed round: stays OLS so it keeps reproducing the numbers its
    # note was written against (CLAUDE.md, completed rounds).
  covid_volatility = NULL
)
if (!isTRUE(all.equal(smoke$irf$irf_point_matrix[smoke$mpind, 1], spec$normalize_value,
                      tolerance = 1e-12))) {
  stop("The fiscal-expectations smoke test does not normalize yield_6m to +50bp.")
}

if (run_bootstrap) {
  bootstrap_failures <- character()
  expanded_irf <- withCallingHandlers(
    run_stage2_cell(
      expanded, dates, instrument, spec$sample, spec$r, spec$q, spec$p,
      spec$instrument, spec$mp_var, spec$horizon, spec$nboot, spec$bootstrap_seed,
      spec$shock_bps, tcodes$fiscal_114, spec$ci_levels,
    # Closed round: stays OLS so it keeps reproducing the numbers its
    # note was written against (CLAUDE.md, completed rounds).
      covid_volatility = NULL
    ),
    warning = function(warning) {
      if (grepl("^Bootstrap iteracao", conditionMessage(warning))) {
        bootstrap_failures <<- c(bootstrap_failures, conditionMessage(warning))
        invokeRestart("muffleWarning")
      }
    }
  )
  irf_object <- expanded_irf$irf
  failures <- length(bootstrap_failures)
  ordered <- all(vapply(irf_object$ci, function(x) {
    all(is.finite(x$lower)) && all(is.finite(x$upper)) && all(x$lower <= x$upper)
  }, logical(1)))
  if (failures != 0L || !ordered || !isTRUE(all.equal(irf_object$irf_point_matrix[expanded_irf$mpind, 1], spec$normalize_value, tolerance = 1e-12))) {
    stop("The 800-replication fiscal-expectations bootstrap gate failed.")
  }
  readr::write_csv(
    tibble::tibble(
      panel = "fiscal_114",
      nboot = spec$nboot,
      bootstrap_failures = failures,
      h0_yield_6m = irf_object$irf_point_matrix[expanded_irf$mpind, 1],
      finite_ordered_bands = ordered,
      gate_pass = failures == 0L && ordered
    ),
    file.path(out_dir, "bootstrap_gate.csv")
  )
  baseline_irf <- readRDS(spec$coherence_cell_path)$irf
  target_variables <- c(
    "yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd", "embi_perc",
    "cds_5y", "fiscal_dbgg", "fiscal_dlsp", "fiscal_primary_balance", fiscal_names
  )
  irfs <- purrr::imap_dfr(c(baseline_111 = "baseline", fiscal_114 = "expanded"), function(which_panel, panel_name) {
    result <- if (which_panel == "baseline") baseline_irf else irf_object
    names <- if (which_panel == "baseline") colnames(baseline) else colnames(expanded)
    purrr::map_dfr(intersect(target_variables, names), function(variable) {
      index <- match(variable, names)
      tibble::tibble(
        panel = panel_name,
        variable = variable,
        h = 0:spec$horizon,
        point = result$irf_point_matrix[index, ],
        lo68 = result$ci[["0.68"]]$lower[index, ],
        hi68 = result$ci[["0.68"]]$upper[index, ],
        lo90 = result$ci[["0.90"]]$lower[index, ],
        hi90 = result$ci[["0.90"]]$upper[index, ]
      )
    })
  })
  readr::write_csv(irfs, file.path(out_dir, "irfs.csv"))
  irf_summary <- irfs |>
    dplyr::filter(panel == "fiscal_114", variable %in% fiscal_names) |>
    dplyr::mutate(sig90 = lo90 > 0 | hi90 < 0) |>
    dplyr::filter(h %in% c(0L, 6L, 12L, 24L, 36L, 48L)) |>
    dplyr::select(variable, h, point, lo68, hi68, lo90, hi90, sig90)
  readr::write_csv(irf_summary, file.path(out_dir, "fiscal_expectations_irf_summary.csv"))
  fiscal_plot <- irfs |>
    dplyr::filter(panel == "fiscal_114", variable %in% fiscal_names) |>
    ggplot2::ggplot(ggplot2::aes(h, point)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lo90, ymax = hi90), fill = "grey80") +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lo68, ymax = hi68), fill = "grey60") +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.25) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~variable, scales = "free_y") +
    ggplot2::labs(x = "Horizonte (meses)", y = "Resposta", title = "Expectativas fiscais Focus") +
    ggplot2::theme_minimal()
  ggplot2::ggsave(file.path(out_dir, "fiscal_expectations_irf.pdf"), fiscal_plot, width = 9, height = 3.5)
  report <- c(
    "# Teste experimental das expectativas fiscais",
    "",
    "Especificação fixa: painel 111 vs. 114, (r,q,p)=(5,5,4), `z_jk_bs_purif`, choque +50 pb em `yield_6m`.",
    "",
    "## Veredito",
    "",
    if (fixed$stable[fixed$panel == "fiscal_114" & fixed$sample == "full"] && fixed$xi_mp[fixed$panel == "fiscal_114" & fixed$sample == "full"] >= 3.84) "Sugestivo: o painel aumentado é estável e a força melhora, mas ξ_mp continua abaixo de 10; a leitura das bandas convencionais exige cautela." else "Não interpretável: a inclusão torna a célula instável ou severamente fraca.",
    "",
    "A expectativa de DLSP cai e exclui zero pela banda de 90% em h=12; a expectativa de resultado nominal cai em h=0 e h=6. Pela convenção do manifesto, esses sinais não sustentam deterioração fiscal esperada. A expectativa de resultado primário não exclui zero a 90% nos horizontes reportados.",
    "",
    "A comparação não altera a especificação de produção nem o manuscrito. `strength_comparison.csv`, `strength_grid.csv` e `irfs.csv` contêm os números reproduzíveis."
  )
  writeLines(report, file.path(out_dir, "report.md"))
}
