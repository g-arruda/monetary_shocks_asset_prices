# Factor-grid sensitivity across every candidate-block-removal panel.
# This script estimates point DFMs only and writes exclusively to rq_grid_drop_blocks/.

rm(list = ls())

library(readr)
library(dplyr)
library(tidyr)

source("R/data_download/panel_candidates.R")
source("R/preprocessing/panel_candidates.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/identification/experimental_panel.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")

P_LAGS <- 6L
MP_VAR <- "yield_6m"
VARIANT <- "z_jk_bs_purif"
OUT_DIR <- "output/panel_experimental/rq_grid_drop_blocks"
EXPECTED_DATES <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
SAMPLES <- list(
  full = as.Date(c("2013-01-01", "2025-09-01")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-01"))
)
RQ_GRID <- dplyr::bind_rows(lapply(5:8, function(r) {
  tibble::tibble(r = r, q = 3:r)
}))

if (nrow(RQ_GRID) != 18L || any(RQ_GRID$q > RQ_GRID$r) ||
    any(RQ_GRID$q < 3L) || any(RQ_GRID$q > 8L)) {
  stop("The r-q grid must contain exactly the 18 admissible pairs with q <= r.")
}


#' Render one xi_mp surface with r in rows and q in columns
#'
#' @param cells Long result table for one variant and sample.
#'
#' @return Character vector containing a GitHub-flavored markdown table.
rq_surface_table <- function(cells) {
  surface <- tidyr::complete(cells, r = 5:8, q = 3:8) |>
    dplyr::mutate(
      xi_mp = dplyr::if_else(is.na(xi_mp), NA_character_, sprintf("%.2f", xi_mp)),
      mosw_class = dplyr::if_else(is.na(mosw_class), NA_character_, mosw_class)
    ) |>
    dplyr::select(r, q, xi_mp, mosw_class) |>
    tidyr::pivot_wider(
      names_from = q,
      values_from = c(xi_mp, mosw_class),
      names_glue = "{.value}_q{q}"
    ) |>
    dplyr::arrange(r)
  md_table(surface, digits = 4)
}


dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)
dir.create(file.path(OUT_DIR, "tables"), showWarnings = FALSE, recursive = TRUE)

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
  stop("The canonical panel must contain exactly 106 series, not ", ncol(base_mat), ".")
}

instrument_panel <- readr::read_csv("data/processed/instrumentos_mensais.csv", show_col_types = FALSE) |>
  dplyr::transmute(month = as.Date(month), shock = .data[[VARIANT]]) |>
  dplyr::filter(!is.na(shock))
if (anyDuplicated(instrument_panel$month) || any(!is.finite(instrument_panel$shock))) {
  stop("The selected instrument has invalid monthly observations.")
}

experimental <- build_factorial_drop_block_panels(base_mat, EXPECTED_DATES, MP_VAR)
panels <- experimental$panels
variant_manifest <- experimental$variant_manifest
manifest_detail <- lapply(variant_manifest$variant, function(variant) {
  panel <- panels[[variant]]
  near_duplicates_in_panel <- intersect(c("juros_cdi", "asset_mlcx"), colnames(panel$matrix))
  tibble::tibble(
    variant = variant,
    n_series = ncol(panel$matrix),
    n_months = nrow(panel$matrix),
    first_month = min(base_dates),
    last_month = max(base_dates),
    near_duplicates_in_panel = if (length(near_duplicates_in_panel) == 0L) {
      "none"
    } else {
      paste(near_duplicates_in_panel, collapse = ";")
    }
  )
}) |>
  dplyr::bind_rows()
variant_manifest <- dplyr::left_join(variant_manifest, manifest_detail, by = "variant")
if (nrow(variant_manifest) != 64L || any(variant_manifest$n_series != variant_manifest$expected_n_series) ||
    any(variant_manifest$n_months != 153L) || any(variant_manifest$near_duplicates_in_panel != "none")) {
  stop("The factorial panel manifest is incomplete or contains a near-duplicate series.")
}
readr::write_csv(variant_manifest, file.path(OUT_DIR, "variant_manifest.csv"))

rows <- list()
failures <- tibble::tibble(
  variant = character(), sample = character(), r = integer(), q = integer(),
  p = integer(), failure = character()
)
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
    if (is.na(mpind)) {
      stop("The normalization variable is absent from ", variant, ".")
    }
    message(sprintf(
      ">>> [%s / %s] 18 DFM cells (p=%d, N=%d, T=%d)",
      variant, sample_name, P_LAGS, ncol(data_sub), nrow(data_sub)
    ))

    for (grid_index in seq_len(nrow(RQ_GRID))) {
      r <- RQ_GRID$r[grid_index]
      q <- RQ_GRID$q[grid_index]
      result <- tryCatch({
        dfm <- estimate_dfm(
          data_sub, r = r, q = q, p = P_LAGS, dates = dates_sub,
          apply_kilian = FALSE
        )
        diagnostic <- diagnose_instrument_in_factor_space(
          dfm, instrument_panel, dates_sub, P_LAGS, mpind
        )
        if (!is.finite(diagnostic$wald_mp)) {
          stop("xi_mp is not finite.")
        }
        tibble::tibble(
          variant = variant,
          sample = sample_name,
          r = r,
          q = q,
          p = P_LAGS,
          n_series = ncol(data_sub),
          n_months = nrow(data_sub),
          n_obs_align = diagnostic$n_obs,
          xi_mp = diagnostic$wald_mp,
          mosw_class = classify_mosw(diagnostic$wald_mp)
        )
      }, error = function(e) e)

      if (inherits(result, "error")) {
        failures <- dplyr::bind_rows(
          failures,
          tibble::tibble(
            variant = variant, sample = sample_name, r = r, q = q,
            p = P_LAGS, failure = conditionMessage(result)
          )
        )
      } else {
        row_index <- row_index + 1L
        rows[[row_index]] <- result
      }
    }
  }
}

grid <- dplyr::bind_rows(rows) |>
  dplyr::arrange(variant, sample, r, q)
readr::write_csv(grid, file.path(OUT_DIR, "rq_grid_drop_blocks_cells.csv"))
readr::write_csv(failures, file.path(OUT_DIR, "rq_grid_drop_blocks_failures.csv"))

for (variant in variant_manifest$variant) {
  for (sample_name in names(SAMPLES)) {
    cells <- grid |>
      dplyr::filter(variant == .env$variant, sample == .env$sample_name)
    table_path <- file.path(OUT_DIR, "tables", paste0("xi_mp_", variant, "_", sample_name, ".md"))
    writeLines(c(
      paste0("# ξ_mp — ", variant, " / ", sample_name),
      "",
      "Linhas: r. Colunas: q. Células vazias são pares inadmissíveis (q > r).",
      "",
      rq_surface_table(cells)
    ), table_path, useBytes = TRUE)
  }
}

expected_cells <- nrow(variant_manifest) * length(SAMPLES) * nrow(RQ_GRID)
completed_cells <- nrow(grid)
baseline_reference <- grid |>
  dplyr::filter(variant == "baseline", r == 7L, q == 6L) |>
  dplyr::select(sample, xi_mp, mosw_class)
report <- c(
  "# Grade fatorial experimental de fatores (r,q), removendo blocos",
  "",
  paste0(
    "> Gerado por `script/panel_composition_rq_grid_drop_blocks.R` em ", Sys.Date(),
    ". Esta rodada só estima DFM de ponto e ξ_mp; não roda bootstrap, IRFs, figuras ou RDS de células."
  ),
  "",
  "## Desenho fixado",
  "",
  "Todos os painéis removem `juros_cdi` e `asset_mlcx`. Partindo das 123 séries restantes da união completa, a rodada remove cada combinação dos seis blocos candidatos (fiscal, setor externo, expectativas, EUA, crédito e imóveis): 64 variantes, de N=123 a N=104. Mantém amostras cheia e pré-COVID, 18 pares `(r,q)` com `q ≤ r`, `p=6`, instrumento `z_jk_bs_purif` e direção `yield_6m`.",
  "",
  "## Cobertura",
  "",
  md_table(tibble::tibble(
    variants = nrow(variant_manifest), samples = length(SAMPLES), rq_pairs = nrow(RQ_GRID),
    expected_cells = expected_cells, completed_cells = completed_cells,
    failed_cells = nrow(failures)
  )),
  "",
  "## Manifesto dos painéis",
  "",
  md_table(variant_manifest),
  "",
  "## Referência baseline (r=7, q=6, p=6)",
  "",
  md_table(baseline_reference, digits = 4),
  "",
  "## Falhas",
  "",
  if (nrow(failures) == 0L) "Nenhuma." else md_table(failures),
  "",
  "## Leitura delimitada",
  "",
  "A grade descreve somente a sensibilidade de ξ_mp à dimensão fatorial e à remoção de blocos já pré-especificados. Ela não seleciona uma especificação pelo maior ξ_mp e não altera painel canônico, instrumento, identificação ou inferência por bandas.",
  "",
  "## Arquivos",
  "",
  "- `rq_grid_drop_blocks_cells.csv`: tabela longa com todas as células completas.",
  "- `rq_grid_drop_blocks_failures.csv`: falhas explícitas por variante, amostra e par (r,q).",
  "- `tables/xi_mp_<variante>_<amostra>.md`: 128 superfícies ξ_mp e classificação MOSW.",
  "- `variant_manifest.csv`: blocos e séries removidos, N resultante e confirmação de exclusão das quase-duplicatas."
)
writeLines(report, file.path(OUT_DIR, "rq_grid_drop_blocks_report.md"), useBytes = TRUE)

if (nrow(failures) > 0L) {
  stop(
    "The factorial r-q grid has ", nrow(failures), " failed cells; see ",
    file.path(OUT_DIR, "rq_grid_drop_blocks_failures.csv"), " and rq_grid_drop_blocks_report.md."
  )
}
if (completed_cells != expected_cells) {
  stop("The factorial r-q grid is incomplete: expected ", expected_cells, " cells and wrote ", completed_cells, ".")
}

message("Factorial experimental r-q grid completed in ", OUT_DIR, ".")
