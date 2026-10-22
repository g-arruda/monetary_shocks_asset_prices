# ===================================================================
# Figures for the results section of the paper, one per subsection.
#
# Reads the cached production estimation object. NOTHING is re-estimated here.
#
# Every IRF figure runs to h = 36 and carries the 80% and 90% Anderson-Rubin
# sets, with no significance markers. The 80% set is the darker ribbon.
#
# Output: paper/img/fig_*.pdf, where paper.tex reads them as img/fig_*.pdf.
# ===================================================================

CELL_PATH <- "output/irf/irf_coherence_cell.rds"
H_MAX <- 36L   # every IRF figure stops here

# One figure per row, written to paper/img/fig_<figure>.pdf
FIGURES <- tibble::tribble(
  ~figure,         ~ncol, ~width, ~height,
  "curva",         4,     10.4,   5.8,
  "cambio_risco",  2,     9.6,    5.8,
  "fiscal",        2,     9.6,    5.8,
  "expectativas",  4,     10.4,   5.8,
  "atividade",     4,     10.4,   5.8,
  "credito",       4,     10.4,   5.8,
  "precos",        4,     10.4,   5.8,
  "acoes",         4,     10.4,   5.8,
  "placebos",      3,     9.6,    3.1
)

# The panels of each figure, in plotting order. The response is multiplied by
# `scale`; the level series (tcode 1) keep their own units, scale 1.
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
    ~variable,    ~label,                    ~scale,
    "cambio_usd", "Câmbio BRL/USD (R$/US$)", 1,
    "cambio_eur", "Câmbio BRL/EUR (R$/€)",   1,
    "embi_perc",  "EMBI+ Brasil (p.b.)",     100,
    "cds_5y",     "CDS 5 anos (p.b.)",       1
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
    "expect_focus_selic_12m",                  "Focus Selic (p.p.)",           1,
    "expect_focus_pib_12m",                    "Focus PIB (p.p.)",             1,
    "expect_focus_cambio_12m",                 "Focus câmbio (R$/US$)",        1,
    "expect_focus_fiscal_dlsp_12m",            "Focus DLSP (p.p. do PIB)",     1,
    "expect_focus_fiscal_primary_balance_12m", "Focus primário (p.p. do PIB)", 1,
    "expect_focus_fiscal_nominal_balance_12m", "Focus nominal (p.p. do PIB)",  1
  ),
  atividade = tibble::tribble(
    ~variable,                        ~label,                        ~scale,
    "ibc_br",                         "IBC-Br (pontos)",             1,
    "ind_transformacao",              "Ind. transformação (pontos)", 1,
    "ind_bens_duraveis",              "Bens duráveis (pontos)",      1,
    "ind_bens_capital",               "Bens de capital (pontos)",    1,
    "vendas_varejo",                  "Vendas no varejo (pontos)",   1,
    "vendas_servicos",                "Vendas de serviços (pontos)", 1,
    "capacidade_instalada_industria", "Utiliz. capacidade (p.p.)",   1,
    "trab_hrs_trabalhadas_industria", "Horas na indústria (pontos)", 1
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

point <- cell$irf$irf_point_matrix
ci80 <- cell$irf$ci[["0.80"]]
ci90 <- cell$irf$ci[["0.90"]]
var_names <- cell$var_names

#' Build one impulse-response panel
#'
#' @param variable Variable name in the production cache.
#' @param label Label for the vertical axis.
#' @param scale Multiplicative constant that puts the response in the units of
#'   the label.
#'
#' @return A ggplot object with the point response and the 80%/90% sets.
irf_panel <- function(variable, label, scale) {
  row <- match(variable, var_names)
  if (is.na(row)) {
    stop(sprintf(
      "Variable '%s' is missing from the production IRF cache.",
      variable
    ))
  }
  columns <- 0:H_MAX + 1

  responses <- tibble::tibble(
    h = 0:H_MAX,
    irf = scale * point[row, columns],
    lo80 = scale * ci80$lower[row, columns],
    hi80 = scale * ci80$upper[row, columns],
    lo90 = scale * ci90$lower[row, columns],
    hi90 = scale * ci90$upper[row, columns]
  )

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

purrr::pwalk(FIGURES, function(figure, ncol, width, height) {
  plots <- purrr::pmap(PANELS[[figure]], function(variable, label, scale) {
    irf_panel(variable, label, scale)
  })
  ggplot2::ggsave(
    paste0("paper/img/fig_", figure, ".pdf"),
    patchwork::wrap_plots(plots, ncol = ncol),
    width = width,
    height = height,
    device = cairo_pdf
  )
})
