# Experimental panel variants built from reusable preprocessed candidates.

#' Assign the production panel's fine block taxonomy
#'
#' @param var_names Production panel variable names.
#'
#' @return Named character vector of block labels.
base_block_taxonomy <- function(var_names) {
  block <- dplyr::case_when(
    grepl("^cambio_", var_names) ~ "cambio",
    grepl("^juros_", var_names) ~ "politica",
    grepl("^yield_", var_names) ~ "curva",
    grepl("^base_", var_names) ~ "monetario",
    grepl("^credito_|^spread_|^credit_|^fin_inst_", var_names) ~ "credito_existente",
    grepl("^consumo_", var_names) ~ "combustiveis",
    grepl("^ind_|^capacidade_", var_names) ~ "industria",
    grepl("^energia_", var_names) ~ "energia",
    grepl("^vendas_", var_names) ~ "vendas",
    var_names %in% c("pib", "ibc_br") ~ "atividade_agregada",
    var_names %in% c("icc", "ics") ~ "confianca",
    grepl("^trab_", var_names) ~ "trabalho",
    grepl("^price_", var_names) ~ "precos",
    grepl("^commodity_", var_names) ~ "commodities",
    grepl("^asset_", var_names) ~ "acoes",
    var_names %in% c("embi_perc", "cds_5y", "msci", "sp500_vix") ~ "risco_externo",
    grepl("^epu_", var_names) ~ "epu",
    TRUE ~ NA_character_
  )
  if (anyNA(block)) {
    stop("The production taxonomy does not classify: ", paste(var_names[is.na(block)], collapse = ", "), ".")
  }
  stats::setNames(block, var_names)
}


#' Construct one pre-specified panel variant in memory
#'
#' @param base_mat Canonical 106-series matrix.
#' @param candidate_inputs Output of `build_candidate_inputs()`.
#' @param variant Variant identifier.
#' @param mp_var Policy normalization variable required in each panel.
#'
#' @return List with panel matrix, tcode vector, block labels, and additions.
build_variant_panel <- function(base_mat, candidate_inputs, variant, mp_var) {
  additions <- switch(
    variant,
    baseline = character(),
    drop_near_duplicates = character(),
    add_fiscal = names(candidate_inputs$blocks)[candidate_inputs$blocks == "fiscal"],
    add_setor_externo = names(candidate_inputs$blocks)[candidate_inputs$blocks == "setor_externo"],
    add_expectativas = names(candidate_inputs$blocks)[candidate_inputs$blocks == "expectativas"],
    add_eua = names(candidate_inputs$blocks)[candidate_inputs$blocks == "eua"],
    add_credito = names(candidate_inputs$blocks)[candidate_inputs$blocks == "credito"],
    add_imoveis = names(candidate_inputs$blocks)[candidate_inputs$blocks == "imoveis"],
    add_conjunto = colnames(candidate_inputs$matrix),
    stop("Unknown experimental variant: ", variant, ".")
  )
  keep <- colnames(base_mat)
  if (variant == "drop_near_duplicates") {
    keep <- setdiff(keep, c("juros_cdi", "asset_mlcx"))
  }
  panel <- cbind(base_mat[, keep, drop = FALSE], candidate_inputs$matrix[, additions, drop = FALSE])
  if (!(mp_var %in% colnames(panel)) || anyDuplicated(colnames(panel)) || any(!is.finite(panel))) {
    stop("Invalid panel constructed for ", variant, ".")
  }

  tcodes <- c(
    stats::setNames(infer_tcode_from_varnames(keep), keep),
    candidate_inputs$tcodes[additions]
  )
  blocks <- c(base_block_taxonomy(keep), candidate_inputs$blocks[additions])
  list(matrix = panel, tcodes = as.integer(tcodes), blocks = blocks, additions = additions)
}


#' Return the fixed nine-variant experimental design
#'
#' @return Tibble with variant identifiers and descriptions.
experimental_variant_manifest <- function() {
  tibble::tribble(
    ~variant, ~description,
    "baseline", "Canonical 106-series production panel.",
    "drop_near_duplicates", "Diagnostic only: remove juros_cdi and asset_mlcx.",
    "add_fiscal", "Add the pre-specified fiscal block.",
    "add_setor_externo", "Add the pre-specified external-sector block.",
    "add_expectativas", "Add the four month-end Focus expectations.",
    "add_eua", "Add US rates, dollar index, and Yahoo S&P 500 log return.",
    "add_credito", "Add aggregate default and lending-rate measures.",
    "add_imoveis", "Add IVG-R.",
    "add_conjunto", "Exact union of all six pre-specified blocks."
  )
}


#' Build all pre-specified experimental panels in memory
#'
#' @param base_mat Canonical complete panel matrix.
#' @param expected_dates Fixed monthly dates aligned with `base_mat`.
#' @param mp_var Policy normalization variable.
#'
#' @return List with panels, candidate inputs, and variant manifest.
build_experimental_panels <- function(base_mat, expected_dates, mp_var) {
  variant_manifest <- experimental_variant_manifest()
  if (nrow(variant_manifest) != 9L) {
    stop("The experimental design must contain exactly nine variants.")
  }
  candidate_inputs <- build_candidate_inputs(expected_dates)
  panels <- stats::setNames(
    lapply(
      variant_manifest$variant,
      function(variant) build_variant_panel(base_mat, candidate_inputs, variant, mp_var)
    ),
    variant_manifest$variant
  )
  list(
    panels = panels,
    candidate_inputs = candidate_inputs,
    variant_manifest = variant_manifest
  )
}


#' Return the deterministic factorial block-removal design
#'
#' Every panel excludes the two near-duplicate production series. The six
#' pre-specified candidate blocks are then removed in every possible
#' combination from the 123-series complete experimental panel.
#'
#' @param candidate_inputs Output of `build_candidate_inputs()`.
#'
#' @return Tibble with one row per block-removal variant.
factorial_drop_block_manifest <- function(candidate_inputs) {
  block_names <- unique(unname(candidate_inputs$blocks))
  block_sizes <- vapply(
    block_names,
    function(block) sum(candidate_inputs$blocks == block),
    integer(1)
  )
  combinations <- expand.grid(
    rep(list(c(FALSE, TRUE)), length(block_names)),
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )
  names(combinations) <- block_names

  manifest <- lapply(seq_len(nrow(combinations)), function(i) {
    selected <- block_names[as.logical(unlist(combinations[i, ], use.names = FALSE))]
    candidate_removed <- names(candidate_inputs$blocks)[
      candidate_inputs$blocks %in% selected
    ]
    variant <- if (length(selected) == 0L) {
      "conjunto_completo_sem_duplicatas"
    } else if (length(selected) == length(block_names)) {
      "baseline"
    } else {
      paste0("drop_", paste(selected, collapse = "__"))
    }

    tibble::tibble(
      variant = variant,
      removed_blocks = if (length(selected) == 0L) "none" else paste(selected, collapse = ";"),
      n_blocks_removed = length(selected),
      removed_candidate_series = if (length(candidate_removed) == 0L) "none" else paste(candidate_removed, collapse = ";"),
      removed_near_duplicates = "juros_cdi;asset_mlcx",
      removed_series = paste(c("juros_cdi", "asset_mlcx", candidate_removed), collapse = ";"),
      near_duplicates_absent = TRUE,
      expected_n_series = 123L - sum(block_sizes[names(block_sizes) %in% selected])
    )
  }) |>
    dplyr::bind_rows()

  if (nrow(manifest) != 64L || anyDuplicated(manifest$variant) ||
      any(manifest$expected_n_series < 104L) || any(manifest$expected_n_series > 123L)) {
    stop("The factorial block-removal design must contain 64 unique panels from N=123 to N=104.")
  }

  manifest
}


#' Build every factorial candidate-block-removal panel in memory
#'
#' @param base_mat Canonical complete 106-series matrix.
#' @param expected_dates Fixed monthly dates aligned with `base_mat`.
#' @param mp_var Policy normalization variable required in each panel.
#'
#' @return List with panels, candidate inputs, and the deterministic manifest.
build_factorial_drop_block_panels <- function(base_mat, expected_dates, mp_var) {
  if (!all(c("juros_cdi", "asset_mlcx") %in% colnames(base_mat))) {
    stop("The canonical panel must contain juros_cdi and asset_mlcx for the factorial removal design.")
  }

  candidate_inputs <- build_candidate_inputs(expected_dates)
  manifest <- factorial_drop_block_manifest(candidate_inputs)
  fixed_keep <- setdiff(colnames(base_mat), c("juros_cdi", "asset_mlcx"))
  if (length(fixed_keep) != 104L || any(fixed_keep %in% colnames(candidate_inputs$matrix))) {
    stop("The factorial panel base must contain 104 non-duplicate production series with no candidate-name overlap.")
  }

  panels <- stats::setNames(lapply(manifest$variant, function(variant) {
    candidate_removed <- strsplit(
      manifest$removed_candidate_series[manifest$variant == variant],
      ";",
      fixed = TRUE
    )[[1]]
    if (identical(candidate_removed, "none")) {
      candidate_removed <- character()
    }
    candidate_keep <- setdiff(colnames(candidate_inputs$matrix), candidate_removed)
    panel <- cbind(
      base_mat[, fixed_keep, drop = FALSE],
      candidate_inputs$matrix[, candidate_keep, drop = FALSE]
    )
    if (!(mp_var %in% colnames(panel)) || anyDuplicated(colnames(panel)) ||
        any(!is.finite(panel)) || any(c("juros_cdi", "asset_mlcx") %in% colnames(panel))) {
      stop("Invalid factorial panel constructed for ", variant, ".")
    }
    if (ncol(panel) != manifest$expected_n_series[manifest$variant == variant]) {
      stop("Unexpected series count in factorial panel ", variant, ".")
    }

    list(matrix = panel, candidate_removed = candidate_removed)
  }), manifest$variant)

  list(panels = panels, candidate_inputs = candidate_inputs, variant_manifest = manifest)
}


#' Classify a MOSW statistic for descriptive reporting
#'
#' @param xi_mp Scalar MOSW statistic in the normalization direction.
#'
#' @return Character classification.
classify_mosw <- function(xi_mp) {
  dplyr::case_when(
    xi_mp <= 3.84 ~ "xi_mp_le_3.84",
    xi_mp < 10 ~ "xi_mp_3.84_10",
    TRUE ~ "xi_mp_ge_10"
  )
}
