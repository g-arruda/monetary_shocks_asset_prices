# Experimental panel variants built from reusable preprocessed series.

#' Assign the production panel's fine block taxonomy
#'
#' Covers the 115-series production panel: the 104 base series plus the
#' fiscal block (`fiscal_*`, `dlsp_exchange_adjustment`) and the Focus
#' expectations block (`expect_focus_*`).
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
    grepl("^fiscal_|^dlsp_", var_names) ~ "fiscal",
    grepl("^expect_focus_", var_names) ~ "expectativas",
    TRUE ~ NA_character_
  )
  if (anyNA(block)) {
    stop("The production taxonomy does not classify: ", paste(var_names[is.na(block)], collapse = ", "), ".")
  }
  stats::setNames(block, var_names)
}


#' Keep one series per group of highly correlated series
#'
#' Groups come from a hierarchical clustering of the distance `1 - |rho|` cut
#' at height `1 - threshold`: under complete linkage every pair inside a group
#' has `|rho| >= threshold`, under single linkage the pairs only chain. A
#' correlation of either sign counts as redundancy. `within_blocks = TRUE`
#' forbids groups that span blocks, the advisor's within-block version of the
#' rule. Each group keeps the first series of `keep_priority` it contains,
#' otherwise the member with the highest mean `|rho|` against the rest of its
#' block, ties broken by column order.
#'
#' @param C Correlation matrix of the panel, series names as dimnames.
#' @param blocks Named character vector of block labels, as returned by
#'   `base_block_taxonomy()`.
#' @param threshold Correlation above which two series are redundant.
#' @param keep_priority Series kept whenever they sit in a group, in order of
#'   precedence.
#' @param linkage `"complete"` or `"single"`, passed to `hclust()`.
#' @param within_blocks Whether a group must stay inside one block.
#'
#' @return Tibble with one row per series, in the column order of `C`:
#'   `series`, `block`, `group` (`NA` outside any group, otherwise numbered by
#'   the column order of its first member), `group_size`, `kept` and `reason`
#'   (`"prioridade"`, `"medoide"`, `"descartada"` or `"sem_grupo"`).
#'
#' @examples
#' C <- cor(matrix(rnorm(400), 40, 10, dimnames = list(NULL, letters[1:10])))
#' prune_correlated_series(C, setNames(rep("x", 10), letters[1:10]), 0.9, "a")
prune_correlated_series <- function(C, blocks, threshold, keep_priority,
                                    linkage = "complete", within_blocks = FALSE) {
  blocks <- unname(blocks[colnames(C)])
  same_block <- outer(blocks, blocks, "==")

  distance <- 1 - abs(C)
  # A distance above the cut height can never be merged under either linkage
  if (within_blocks) distance[!same_block] <- 2
  cluster <- cutree(hclust(as.dist(distance), method = linkage), h = 1 - threshold)

  diag(same_block) <- FALSE
  block_score <- rowSums(abs(C) * same_block) / rowSums(same_block)

  tibble::tibble(
    series = colnames(C),
    block = blocks,
    cluster = cluster,
    priority = match(colnames(C), keep_priority, nomatch = length(keep_priority) + 1L),
    block_score = block_score,
    position = seq_along(blocks)
  ) |>
    dplyr::arrange(cluster, priority, dplyr::desc(block_score), position) |>
    dplyr::group_by(cluster) |>
    dplyr::mutate(group_size = dplyr::n(), kept = dplyr::row_number() == 1L) |>
    dplyr::ungroup() |>
    dplyr::arrange(position) |>
    dplyr::mutate(
      group = match(cluster, unique(cluster[group_size > 1L])),
      reason = dplyr::case_when(
        group_size == 1L ~ "sem_grupo",
        !kept ~ "descartada",
        priority <= length(keep_priority) ~ "prioridade",
        TRUE ~ "medoide"
      )
    ) |>
    dplyr::select(series, block, group, group_size, kept, reason)
}


#' Return the deterministic factorial block-removal design
#'
#' Every panel excludes the two near-duplicate production series. The six
#' pre-specified experimental blocks are then removed in every possible
#' combination from the 123-series complete experimental panel.
#'
#' @param experimental_inputs Output of `build_experimental_inputs()`.
#'
#' @return Tibble with one row per block-removal variant.
factorial_drop_block_manifest <- function(experimental_inputs) {
  block_names <- unique(unname(experimental_inputs$blocks))
  block_sizes <- vapply(
    block_names,
    function(block) sum(experimental_inputs$blocks == block),
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
    experimental_removed <- names(experimental_inputs$blocks)[
      experimental_inputs$blocks %in% selected
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
      removed_candidate_series = if (length(experimental_removed) == 0L) "none" else paste(experimental_removed, collapse = ";"),
      removed_near_duplicates = "juros_cdi;asset_mlcx",
      removed_series = paste(c("juros_cdi", "asset_mlcx", experimental_removed), collapse = ";"),
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


#' Build every factorial experimental-block-removal panel in memory
#'
#' @param base_mat Canonical complete 106-series matrix.
#' @param expected_dates Fixed monthly dates aligned with `base_mat`.
#' @param mp_var Policy normalization variable required in each panel.
#'
#' @return List with panels, experimental inputs, and the deterministic manifest.
build_factorial_drop_block_panels <- function(base_mat, expected_dates, mp_var) {
  if (!all(c("juros_cdi", "asset_mlcx") %in% colnames(base_mat))) {
    stop("The canonical panel must contain juros_cdi and asset_mlcx for the factorial removal design.")
  }

  experimental_inputs <- build_experimental_inputs(expected_dates)
  manifest <- factorial_drop_block_manifest(experimental_inputs)
  fixed_keep <- setdiff(colnames(base_mat), c("juros_cdi", "asset_mlcx"))
  if (length(fixed_keep) != 104L || any(fixed_keep %in% colnames(experimental_inputs$matrix))) {
    stop("The factorial panel base must contain 104 non-duplicate production series with no experimental-name overlap.")
  }

  panels <- stats::setNames(lapply(manifest$variant, function(variant) {
    experimental_removed <- strsplit(
      manifest$removed_candidate_series[manifest$variant == variant],
      ";",
      fixed = TRUE
    )[[1]]
    if (identical(experimental_removed, "none")) {
      experimental_removed <- character()
    }
    experimental_keep <- setdiff(colnames(experimental_inputs$matrix), experimental_removed)
    panel <- cbind(
      base_mat[, fixed_keep, drop = FALSE],
      experimental_inputs$matrix[, experimental_keep, drop = FALSE]
    )
    if (!(mp_var %in% colnames(panel)) || anyDuplicated(colnames(panel)) ||
        any(!is.finite(panel)) || any(c("juros_cdi", "asset_mlcx") %in% colnames(panel))) {
      stop("Invalid factorial panel constructed for ", variant, ".")
    }
    if (ncol(panel) != manifest$expected_n_series[manifest$variant == variant]) {
      stop("Unexpected series count in factorial panel ", variant, ".")
    }

    list(matrix = panel, experimental_removed = experimental_removed)
  }), manifest$variant)

  list(panels = panels, experimental_inputs = experimental_inputs, variant_manifest = manifest)
}
