# Functions removed from R/identification/experimental_panel.R on 2026-09-17,
# in the audit of script/ and R/. Their only callers were the
# panel_composition* scripts, now in arquivo/script/, which need the 153-month
# 2013-01..2025-09 base panel and no longer run. Kept as written.


#' Construct one pre-specified panel variant in memory
#'
#' @param base_mat Canonical 106-series matrix.
#' @param experimental_inputs Output of `build_experimental_inputs()`.
#' @param variant Variant identifier.
#' @param mp_var Policy normalization variable required in each panel.
#'
#' @return List with panel matrix, tcode vector, block labels, and additions.
build_variant_panel <- function(base_mat, experimental_inputs, variant, mp_var) {
  additions <- switch(
    variant,
    baseline = character(),
    drop_near_duplicates = character(),
    add_fiscal = names(experimental_inputs$blocks)[experimental_inputs$blocks == "fiscal"],
    add_setor_externo = names(experimental_inputs$blocks)[experimental_inputs$blocks == "setor_externo"],
    add_expectativas = names(experimental_inputs$blocks)[experimental_inputs$blocks == "expectativas"],
    add_eua = names(experimental_inputs$blocks)[experimental_inputs$blocks == "eua"],
    add_credito = names(experimental_inputs$blocks)[experimental_inputs$blocks == "credito"],
    add_imoveis = names(experimental_inputs$blocks)[experimental_inputs$blocks == "imoveis"],
    add_conjunto = colnames(experimental_inputs$matrix),
    stop("Unknown experimental variant: ", variant, ".")
  )
  keep <- colnames(base_mat)
  if (variant == "drop_near_duplicates") {
    keep <- setdiff(keep, c("juros_cdi", "asset_mlcx"))
  }
  panel <- cbind(base_mat[, keep, drop = FALSE], experimental_inputs$matrix[, additions, drop = FALSE])
  if (!(mp_var %in% colnames(panel)) || anyDuplicated(colnames(panel)) || any(!is.finite(panel))) {
    stop("Invalid panel constructed for ", variant, ".")
  }

  tcodes <- c(
    stats::setNames(infer_tcode_from_varnames(keep), keep),
    experimental_inputs$tcodes[additions]
  )
  blocks <- c(base_block_taxonomy(keep), experimental_inputs$blocks[additions])
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
#' @return List with panels, experimental inputs, and variant manifest.
build_experimental_panels <- function(base_mat, expected_dates, mp_var) {
  variant_manifest <- experimental_variant_manifest()
  if (nrow(variant_manifest) != 9L) {
    stop("The experimental design must contain exactly nine variants.")
  }
  experimental_inputs <- build_experimental_inputs(expected_dates)
  panels <- stats::setNames(
    lapply(
      variant_manifest$variant,
      function(variant) build_variant_panel(base_mat, experimental_inputs, variant, mp_var)
    ),
    variant_manifest$variant
  )
  list(
    panels = panels,
    experimental_inputs = experimental_inputs,
    variant_manifest = variant_manifest
  )
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
