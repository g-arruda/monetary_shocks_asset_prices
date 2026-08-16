# ===================================================================
# RENDERIZAÇÃO DE NÚMEROS PARA OS RELATÓRIOS .md GERADOS
# Não confundir `md_tbl()` com `md_table()` de R/identification/spec_sweep.R:
# aquele arredonda (`round`) e devolve um vetor de linhas; este usa
# `formatC(signif(...))` e devolve uma string única. Os dígitos impressos
# diferem, então trocar um pelo outro re-renderiza artefatos já commitados.
# ===================================================================

#' Render a data.frame as markdown table lines
#'
#' Numeric columns are rounded to `digits` (not signif) and formatted with
#' `trim = TRUE` so the column does not carry padding into the markdown.
#'
#' @param df Data.frame or tibble to render.
#' @param digits Decimal places for numeric columns.
#'
#' @return Character vector: header, separator, one line per row, and a
#'   trailing empty string so the caller can `c()` sections together.
md_tbl <- function(df, digits = 4) {
  df <- as.data.frame(df)
  num <- vapply(df, is.numeric, logical(1))
  df[num] <- lapply(df[num], function(x) format(round(x, digits), trim = TRUE))
  hdr <- paste0("| ", paste(names(df), collapse = " | "), " |")
  sep <- paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|")
  body <- apply(df, 1, function(r) paste0("| ", paste(r, collapse = " | "), " |"))
  c(hdr, sep, body, "")
}

#' Format a number for inline use in a generated report
#'
#' @param x Numeric vector.
#' @param d Decimal places.
#'
#' @return Character vector in fixed notation.
fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)
