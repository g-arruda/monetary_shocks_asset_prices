# Block taxonomy and correlation pruning of the production panel.

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
