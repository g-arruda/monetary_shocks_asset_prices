# ===================================================================
# Number rendering for the generated .md reports.
# Two table renderers live here and are not interchangeable: md_tbl()
# rounds (`round`) and returns a vector of lines; md_table() uses
# `formatC(signif(...))` and returns a single string. The printed digits
# differ, so swapping one for the other re-renders committed artefacts.
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

#' Render a data.frame as a GitHub-flavored markdown table
#'
#' Numeric columns are rounded to `digits` significant figures.
#'
#' @param df Data.frame to render.
#' @param digits Significant digits for numeric columns.
#'
#' @return Character scalar with the markdown table.
md_table <- function(df, digits = 4) {
  cells <- purrr::map(df, \(column) {
    if (is.numeric(column)) {
      formatC(signif(column, digits), format = "g", digits = digits)
    } else {
      as.character(column)
    }
  })
  header <- paste0("| ", paste(names(df), collapse = " | "), " |")
  separator <- paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|")
  rows <- purrr::pmap_chr(unname(cells), \(...) {
    paste0("| ", paste(c(...), collapse = " | "), " |")
  })
  paste(c(header, separator, rows), collapse = "\n")
}

#' Format a number for inline use in a generated report
#'
#' @param x Numeric vector.
#' @param d Decimal places.
#'
#' @return Character vector in fixed notation.
fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)
