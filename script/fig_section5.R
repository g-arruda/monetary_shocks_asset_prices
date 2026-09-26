# ===================================================================
# Figures for the results section of the paper, one per subsection.
#
# Reads the cached production estimation object. NOTHING is re-estimated here.
#
# Every IRF figure runs to h = 36 and carries the 80% and 90% Anderson-Rubin
# sets. The eight figures in the results section omit significance markers;
# the placebo figure retains them. The 80% set is the darker ribbon.
#
# Output: paper/fig_*.pdf, where paper_anpec.tex reads them (bare filenames,
# no subdirectory).
# ===================================================================

CELL_PATH  <- "output/irf/irf_coherence_cell.rds"
PANEL_PATH <- "data/processed/data_log_deseasonalized.csv"
H_MAX <- 36L   # every IRF figure stops here

# One figure per row, written to paper/fig_<figure>.pdf
FIGURES <- tibble::tribble(
  ~figure,         ~ncol, ~width, ~height, ~mark_sig90,
  "curva",         4,     10.4,   5.8,     FALSE,
  "cambio_risco",  2,     9.6,    5.8,     FALSE,
  "fiscal",        2,     9.6,    5.8,     FALSE,
  "expectativas",  4,     10.4,   5.8,     FALSE,
  "atividade",     4,     10.4,   5.8,     FALSE,
  "credito",       4,     10.4,   5.8,     FALSE,
  "precos",        4,     10.4,   5.8,     FALSE,
  "acoes",         4,     10.4,   5.8,     FALSE,
  "placebos",      3,     9.6,    3.1,     TRUE
)

# The panels of each figure, in plotting order. The response is multiplied by
# `scale`; an NA scale is the response as a percentage of the sample mean.
PANELS <- list(
  curva = tibble::tribble(
    ~variable,     ~label,                   ~scale,
    "yield_3m",    "DI 3 meses (p.b.)",      1e4,
    "yield_6m",    "DI 6 meses (p.b.)",      1e4,
    "yield_1y",    "DI 1 ano (p.b.)",        1e4,
    "yield_2y",    "DI 2 anos (p.b.)",       1e4,
    "yield_5y",    "DI 5 anos (p.b.)",       1e4,
    "yield_10y",   "DI 10 anos (p.b.)",      1e4,
    "juros_selic", "Selic overnight (p.b.)", 100
  ),
  cambio_risco = tibble::tribble(
    ~variable,    ~label,                ~scale,
    "cambio_usd", "Câmbio BRL/USD (%)",  NA,
    "cambio_eur", "Câmbio BRL/EUR (%)",  NA,
    "embi_perc",  "EMBI+ Brasil (p.b.)", 100,
    "cds_5y",     "CDS 5 anos (p.b.)",   1
  ),
  fiscal = tibble::tribble(
    ~variable,                  ~label,                   ~scale,
    "fiscal_dbgg",              "DBGG (p.p. do PIB)",     1,
    "fiscal_dlsp",              "DLSP (p.p. do PIB)",     1,
    "fiscal_primary_balance",   "NFSP primária (R$ bi)",  1e-3,
    "dlsp_exchange_adjustment", "Ajuste cambial (R$ bi)", 1e-3
  ),
  expectativas = tibble::tribble(
    ~variable,                                ~label,                         ~scale,
    "expect_focus_ipca12m",                   "Focus IPCA 12 meses (p.p.)",   1,
    "expect_focus_selic_ny",                  "Focus Selic (p.p.)",           1,
    "expect_focus_pib_ny",                    "Focus PIB (p.p.)",             1,
    "expect_focus_cambio_ny",                 "Focus câmbio (R$/US$)",        1,
    "expect_focus_fiscal_dlsp_ny",            "Focus DLSP (p.p. do PIB)",     1,
    "expect_focus_fiscal_primary_balance_ny", "Focus primário (p.p. do PIB)", 1,
    "expect_focus_fiscal_nominal_balance_ny", "Focus nominal (p.p. do PIB)",  1
  ),
  atividade = tibble::tribble(
    ~variable,                        ~label,                      ~scale,
    "ibc_br",                         "IBC-Br (%)",                NA,
    "ind_transformacao",              "Ind. transformação (%)",    NA,
    "ind_bens_duraveis",              "Bens duráveis (%)",         NA,
    "ind_bens_capital",               "Bens de capital (%)",       NA,
    "vendas_varejo",                  "Vendas no varejo (%)",      NA,
    "vendas_servicos",                "Vendas de serviços (%)",    NA,
    "capacidade_instalada_industria", "Utiliz. capacidade (p.p.)", 1,
    "trab_hrs_trabalhadas_industria", "Horas na indústria (%)",    NA
  ),
  credito = tibble::tribble(
    ~variable,                 ~label,                      ~scale,
    "credit_outstanding",      "Saldo total (%)",           1,
    "credito_agro",            "Crédito agropecuário (%)",  1,
    "credito_transporte",      "Crédito transporte (%)",    1,
    "credito_industria_total", "Crédito indústria (%)",     1,
    "credito_comercio",        "Crédito comércio (%)",      1,
    "credito_construcao",      "Crédito construção (%)",    1,
    "credito_pessoa_fisica",   "Crédito pessoa física (%)", 1
  ),
  precos = tibble::tribble(
    ~variable,             ~label,                          ~scale,
    "price_ipp",           "IPP (p.p. ao mês)",             1,
    "price_igp_m",         "IGP-M (p.p. ao mês)",           1,
    "price_ipca",          "IPCA cheio (p.p. ao mês)",      1,
    "price_core_ipca_ex0", "Núcleo EX0 (p.p.)",             1,
    "price_core_ipca_dw",  "Núcleo médias aparadas (p.p.)", 1,
    "price_core_ipca_ex1", "Núcleo EX1 (p.p.)",             1,
    "price_ipca_difusao",  "Difusão do IPCA (p.p.)",        1,
    "price_inpc",          "INPC (p.p. ao mês)",            1
  ),
  acoes = tibble::tribble(
    ~variable,    ~label,                    ~scale,
    "asset_ibov", "Ibovespa (%)",            1,
    "asset_smll", "SMLL, small caps (%)",    1,
    "asset_idiv", "IDIV, dividendos (%)",    1,
    "asset_imob", "IMOB, incorporadoras (%)", 1,
    "asset_ifnc", "IFNC, bancos (%)",        1,
    "asset_imat", "IMAT, materiais (%)",     1,
    "asset_ifix", "IFIX, renda imob. (%)",   1
  ),
  placebos = tibble::tribble(
    ~variable,   ~label,               ~scale,
    "sp500_vix", "VIX",                1,
    "msci",      "MSCI emergentes",    1,
    "epu_us",    "EPU Estados Unidos", 1
  )
)

cell <- readRDS(CELL_PATH)
panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE)

point <- cell$irf$irf_point_matrix
ci80 <- cell$irf$ci[["0.80"]]
ci90 <- cell$irf$ci[["0.90"]]
var_names <- cell$var_names

#' Build one impulse-response panel
#'
#' @param variable Variable name in the production cache.
#' @param label Label for the vertical axis.
#' @param scale Multiplicative constant, or `NA` to express the response as a
#'   percentage of the variable's sample mean.
#' @param mark_sig90 Whether to mark horizons whose 90% set excludes zero.
#'
#' @return A ggplot object with the point response and the 80%/90% sets.
irf_panel <- function(variable, label, scale, mark_sig90) {
  row <- match(variable, var_names)
  if (is.na(row)) {
    stop(sprintf(
      "Variable '%s' is missing from the production IRF cache.",
      variable
    ))
  }
  multiplier <- dplyr::coalesce(
    scale,
    100 / mean(panel[[variable]], na.rm = TRUE)
  )
  columns <- 0:H_MAX + 1

  # Significance comes from the 90% set itself: irf_coherence_h.csv covers
  # only the scored series, and the figures also plot series outside it.
  responses <- tibble::tibble(
    h = 0:H_MAX,
    irf = multiplier * point[row, columns],
    lo80 = multiplier * ci80$lower[row, columns],
    hi80 = multiplier * ci80$upper[row, columns],
    lo90 = multiplier * ci90$lower[row, columns],
    hi90 = multiplier * ci90$upper[row, columns],
    sig = ci90$lower[row, columns] > 0 | ci90$upper[row, columns] < 0
  )

  sig_markers <- if (mark_sig90) {
    ggplot2::geom_point(
      data = dplyr::filter(responses, sig),
      ggplot2::aes(y = irf),
      shape = 21,
      fill = "#d95f02",
      colour = "black",
      size = 1.9,
      stroke = 0.45
    )
  }

  ggplot2::ggplot(responses, ggplot2::aes(x = h)) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = lo90, ymax = hi90),
      fill = "steelblue",
      alpha = 0.18
    ) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = lo80, ymax = hi80),
      fill = "steelblue",
      alpha = 0.36
    ) +
    ggplot2::geom_hline(
      yintercept = 0,
      linetype = "dashed",
      colour = "red",
      linewidth = 0.35
    ) +
    ggplot2::geom_line(
      ggplot2::aes(y = irf),
      colour = "black",
      linewidth = 0.8
    ) +
    sig_markers +
    ggplot2::scale_x_continuous(
      breaks = seq(0, H_MAX, 6),
      limits = c(0, H_MAX),
      expand = c(0.01, 0)
    ) +
    ggplot2::theme_classic(base_size = 11) +
    ggplot2::labs(y = label, x = NULL) +
    ggplot2::theme(
      axis.title.y = ggplot2::element_text(size = ggplot2::rel(0.95)),
      axis.text = ggplot2::element_text(size = ggplot2::rel(0.85)),
      plot.margin = ggplot2::margin(3, 5, 1, 2)
    )
}

purrr::pwalk(FIGURES, function(figure, ncol, width, height, mark_sig90) {
  plots <- purrr::pmap(PANELS[[figure]], function(variable, label, scale) {
    irf_panel(variable, label, scale, mark_sig90)
  })
  ggplot2::ggsave(
    paste0("paper/fig_", figure, ".pdf"),
    patchwork::wrap_plots(plots, ncol = ncol),
    width = width,
    height = height,
    device = cairo_pdf
  )
})
