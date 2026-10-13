# ===================================================================
# Copom minutes, meetings 165 to 275 (2012-03-07 to 2025-12-10), for the
# announcement time of script/copom_timing.R. Each minute states when every
# session started and ended, and the statement is released after the
# second day's last session. The BCB API returns the minute as HTML
# (textoAta), except for meetings 200 to 231, published only as PDF; those
# are converted with pdftotext, as script/download_macro_news.R does with
# the IBGE releases. A stage of its own so that it runs without
# re-downloading the production panel of script/download.R.
# Output: data/raw/copom_atas.csv
# ===================================================================

ATAS_URL <- "https://www.bcb.gov.br/api/servico/sitebcb/copom/atas_detalhes"
MEETINGS <- 165:275

atas <- purrr::map(MEETINGS, \(meeting) {
  jsonlite::fromJSON(sprintf("%s?nro_reuniao=%d", ATAS_URL, meeting))$conteudo
}) |>
  purrr::list_rbind() |>
  dplyr::transmute(
    meeting = nroReuniao,
    meeting_date = as.Date(dataReferencia),
    published = as.Date(dataPublicacao),
    pdf_url = urlPdfAta,
    format = dplyr::if_else(is.na(textoAta), "pdf", "html"),
    text = textoAta
  )

pdf_rows <- atas$format == "pdf"
atas$text[pdf_rows] <- purrr::map_chr(atas$pdf_url[pdf_rows], \(url) {
  pdf_path <- tempfile(fileext = ".pdf")
  download.file(url, pdf_path, mode = "wb", quiet = TRUE)
  system2("pdftotext", c("-layout", pdf_path, "-"), stdout = TRUE) |>
    paste(collapse = "\n")
})

readr::write_csv(atas, "data/raw/copom_atas.csv")
