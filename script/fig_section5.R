# ===================================================================
# Figures for the results section of the paper, one per subsection.
#
# Reads the cached production estimation object. NOTHING is re-estimated here.
#
# Every IRF figure runs to h = 36 and carries the 68% and 90% Anderson-Rubin
# sets. The eight figures in the results section omit significance markers;
# the placebo figure retains them. The script writes nine figures in total.
# The 68% set is read off the darker ribbon.
#
# Output: paper/fig_*.pdf — where paper_anpec.tex reads them (bare
# filenames, no subdirectory). Repointed 2026-08-05: this used to write into
# arquivo/tex/img/, so regenerating the figures never reached the canonical
# paper and the PDFs beside it were stale manual copies.
# ===================================================================

rm(list = ls())

H_MAX <- 36L   # every IRF figure stops here

cell  <- readRDS("output/irf/irf_coherence_cell.rds")
panel <- readr::read_csv("data/processed/data_log_deseasonalized.csv",
                         show_col_types = FALSE)
hcsv  <- readr::read_csv("output/irf/irf_coherence_h.csv", show_col_types = FALSE)

point <- cell$irf$irf_point_matrix
ci68  <- cell$irf$ci[["0.68"]]
ci90  <- cell$irf$ci[["0.90"]]
vn    <- cell$var_names

#' Build one impulse-response panel
#'
#' @param v Variable name in the production cache.
#' @param lab Label for the vertical axis.
#' @param scale Multiplicative constant, or `"pct"` to divide by the sample mean.
#' @param mark_sig90 Whether to mark horizons whose 90% band excludes zero.
#'
#' @return A ggplot object.
irf_panel <- function(
  v,
  lab,
  scale = 1,
  mark_sig90 = TRUE
) {
  i <- match(v, vn)
  if (is.na(i)) {
    stop(sprintf("Variable '%s' is missing from the production IRF cache.", v))
  }
  k <- if (identical(scale, "pct")) 100 / mean(panel[[v]], na.rm = TRUE) else scale
  j <- 0:H_MAX + 1

  # Significância direto da banda de 90%, e não de irf_coherence_h.csv: aquele
  # arquivo cobre só as séries escoradas, e a figura plota séries do painel
  # que não entram na régua de coerência (commodity_agro, por exemplo).
  df <- data.frame(
    h    = 0:H_MAX,
    irf  = k * point[i, j],
    lo68 = k * ci68$lower[i, j], hi68 = k * ci68$upper[i, j],
    lo90 = k * ci90$lower[i, j], hi90 = k * ci90$upper[i, j],
    sig  = ci90$lower[i, j] > 0 | ci90$upper[i, j] < 0
  )

  sig_markers <- if (mark_sig90) {
    ggplot2::geom_point(
      data = subset(df, sig),
      ggplot2::aes(y = irf),
      shape = 21,
      fill = "#d95f02",
      colour = "black",
      size = 1.9,
      stroke = 0.45
    )
  }

  ggplot2::ggplot(df, ggplot2::aes(x = h)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lo90, ymax = hi90), fill = "steelblue", alpha = 0.18) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lo68, ymax = hi68), fill = "steelblue", alpha = 0.36) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "red", linewidth = 0.35) +
    ggplot2::geom_line(ggplot2::aes(y = irf), colour = "black", linewidth = 0.8) +
    sig_markers +
    ggplot2::scale_x_continuous(breaks = seq(0, H_MAX, 6), limits = c(0, H_MAX),
                                expand = c(0.01, 0)) +
    ggplot2::theme_classic(base_size = 11) +
    ggplot2::labs(y = lab, x = NULL) +
    ggplot2::theme(axis.title.y = ggplot2::element_text(size = ggplot2::rel(0.95)),
                   axis.text    = ggplot2::element_text(size = ggplot2::rel(0.85)),
                   plot.margin  = ggplot2::margin(3, 5, 1, 2))
}

#' Arrange impulse-response panels in a grid
#'
#' @param specs List of variable, label, and scale specifications.
#' @param ncol Number of columns.
#' @param mark_sig90 Whether panels should mark 90% exclusions of zero.
#'
#' @return A patchwork plot.
grid_of <- function(specs, ncol, mark_sig90 = TRUE) {
  panels <- purrr::map(
    specs,
    function(s) irf_panel(
      s[[1]],
      s[[2]],
      s[[3]],
      mark_sig90 = mark_sig90
    )
  )
  patchwork::wrap_plots(panels, ncol = ncol)
}


# --- 1. estrutura a termo -------------------------------------------
ggplot2::ggsave("paper/fig_curva.pdf", grid_of(list(
  list("yield_3m",  "DI 3 meses (p.b.)",  1e4),
  list("yield_6m",  "DI 6 meses (p.b.)",  1e4),
  list("yield_1y",  "DI 1 ano (p.b.)",    1e4),
  list("yield_2y",  "DI 2 anos (p.b.)",   1e4),
  list("yield_5y",  "DI 5 anos (p.b.)",   1e4),
  list("yield_10y", "DI 10 anos (p.b.)",  1e4),
  list("juros_selic", "Selic overnight (p.b.)", 100)
), ncol = 4, mark_sig90 = FALSE), width = 10.4, height = 5.8, device = cairo_pdf)


# --- 2. Exchange rates and sovereign risk ---------------------------
ggplot2::ggsave("paper/fig_cambio_risco.pdf", grid_of(list(
  list("cambio_usd",      "Câmbio BRL/USD (%)",   "pct"),
  list("cambio_eur",      "Câmbio BRL/EUR (%)",   "pct"),
  list("embi_perc",       "EMBI+ Brasil (p.b.)",  100),
  list("cds_5y",          "CDS 5 anos (p.b.)",    1)
), ncol = 2, mark_sig90 = FALSE), width = 9.6, height = 5.8, device = cairo_pdf)


# --- 3. Fiscal variables --------------------------------------------
ggplot2::ggsave("paper/fig_fiscal.pdf", grid_of(list(
  list("fiscal_dbgg", "DBGG (p.p. do PIB)", 1),
  list("fiscal_dlsp", "DLSP (p.p. do PIB)", 1),
  list("fiscal_primary_balance", "NFSP primária (R$ bi)", 1e-3),
  list("dlsp_exchange_adjustment", "Ajuste cambial (R$ bi)", 1e-3)
), ncol = 2, mark_sig90 = FALSE), width = 9.6, height = 5.8, device = cairo_pdf)


# --- 4. Focus expectations ------------------------------------------
ggplot2::ggsave("paper/fig_expectativas.pdf", grid_of(list(
  list("expect_focus_ipca12m", "Focus IPCA 12 meses (p.p.)", 1),
  list("expect_focus_selic_ny", "Focus Selic (p.p.)", 1),
  list("expect_focus_pib_ny", "Focus PIB (p.p.)", 1),
  list("expect_focus_cambio_ny", "Focus câmbio (R$/US$)", 1),
  list("expect_focus_fiscal_dlsp_ny", "Focus DLSP (p.p. do PIB)", 1),
  list("expect_focus_fiscal_primary_balance_ny",
       "Focus primário (p.p. do PIB)", 1),
  list("expect_focus_fiscal_nominal_balance_ny",
       "Focus nominal (p.p. do PIB)", 1)
), ncol = 4, mark_sig90 = FALSE), width = 10.4, height = 5.8, device = cairo_pdf)


# --- 6. Activity and labor ------------------------------------------
ggplot2::ggsave("paper/fig_atividade.pdf", grid_of(list(
  list("ibc_br",                         "IBC-Br (%)",             "pct"),
  list("ind_transformacao",              "Ind. transformação (%)", "pct"),
  list("ind_bens_duraveis",              "Bens duráveis (%)",      "pct"),
  list("ind_bens_capital",               "Bens de capital (%)",    "pct"),
  list("vendas_varejo",                  "Vendas no varejo (%)",   "pct"),
  list("vendas_servicos",                "Vendas de serviços (%)", "pct"),
  list("capacidade_instalada_industria", "Utiliz. capacidade (p.p.)", 1),
  list("trab_hrs_trabalhadas_industria", "Horas na indústria (%)", "pct")
), ncol = 4, mark_sig90 = FALSE), width = 10.4, height = 5.8, device = cairo_pdf)


# --- 7. Credit -------------------------------------------------------
ggplot2::ggsave("paper/fig_credito.pdf", grid_of(list(
  list("credit_outstanding",    "Saldo total (%)",          1),
  list("credito_agro",          "Crédito agropecuário (%)", 1),
  list("credito_transporte",    "Crédito transporte (%)",   1),
  list("credito_industria_total", "Crédito indústria (%)",  1),
  list("credito_comercio",      "Crédito comércio (%)",     1),
  list("credito_construcao",    "Crédito construção (%)",   1),
  list("credito_pessoa_fisica", "Crédito pessoa física (%)", 1)
), ncol = 4, mark_sig90 = FALSE), width = 10.4, height = 5.8, device = cairo_pdf)


# --- 8. Prices -------------------------------------------------------
ggplot2::ggsave("paper/fig_precos.pdf", grid_of(list(
  list("price_ipp",           "IPP (p.p. ao mês)",        1),
  list("price_igp_m",         "IGP-M (p.p. ao mês)",      1),
  list("price_ipca",          "IPCA cheio (p.p. ao mês)", 1),
  list("price_core_ipca_ex0", "Núcleo EX0 (p.p.)",        1),
  list("price_core_ipca_dw",  "Núcleo médias aparadas (p.p.)", 1),
  list("price_core_ipca_ex1", "Núcleo EX1 (p.p.)",        1),
  list("price_ipca_difusao",  "Difusão do IPCA (p.p.)",   1),
  list("price_inpc",          "INPC (p.p. ao mês)",       1)
), ncol = 4, mark_sig90 = FALSE), width = 10.4, height = 5.8, device = cairo_pdf)


# --- 9. Equity indexes ----------------------------------------------
ggplot2::ggsave("paper/fig_acoes.pdf", grid_of(list(
  list("asset_ibov", "Ibovespa (%)",        1),
  list("asset_smll", "SMLL, small caps (%)", 1),
  list("asset_idiv", "IDIV, dividendos (%)", 1),
  list("asset_imob", "IMOB, incorporadoras (%)", 1),
  list("asset_ifnc", "IFNC, bancos (%)",    1),
  list("asset_imat", "IMAT, materiais (%)", 1),
  list("asset_ifix", "IFIX, renda imob. (%)", 1)
), ncol = 4, mark_sig90 = FALSE), width = 10.4, height = 5.8, device = cairo_pdf)


# --- 10. Placebos ----------------------------------------------------
ggplot2::ggsave("paper/fig_placebos.pdf", grid_of(list(
  list("sp500_vix", "VIX",                     1),
  list("msci",      "MSCI emergentes",         1),
  list("epu_us",    "EPU Estados Unidos",      1)
), ncol = 3), width = 9.6, height = 3.1, device = cairo_pdf)


# --- Validation -----------------------------------------------------
# Every scored plotted value and interval must match irf_coherence_h.csv.
plotted <- c("yield_3m","yield_6m","yield_1y","yield_2y","yield_5y","yield_10y",
             "juros_selic","cambio_usd","cambio_eur","embi_perc",
             "cds_5y","fiscal_dbgg","fiscal_dlsp","fiscal_primary_balance",
             "expect_focus_ipca12m","expect_focus_selic_ny",
             "expect_focus_pib_ny","expect_focus_cambio_ny","ind_transformacao",
             "ind_bens_duraveis","ind_bens_capital","vendas_varejo",
             "capacidade_instalada_industria","trab_hrs_trabalhadas_industria",
             "ibc_br","vendas_servicos",
             "credito_agro","credito_transporte","credito_industria_total",
             "credit_outstanding","credito_pessoa_fisica","credito_comercio",
             "credito_construcao",
             "price_ipp","price_igp_m","price_ipca","price_core_ipca_ex0",
             "price_core_ipca_dw","price_core_ipca_ex1","price_ipca_difusao",
             "price_inpc","asset_ibov","asset_smll","asset_idiv",
             "asset_imob","asset_ifnc","asset_imat","asset_ifix",
             "sp500_vix","msci","epu_us")
for (v in plotted) {
  i <- match(v, vn)
  if (is.na(i)) {
    stop(sprintf("Plotted variable '%s' is missing from the production IRF cache.", v))
  }
  d <- hcsv[hcsv$var == v & hcsv$h <= H_MAX, ]
  if (!nrow(d)) {
    next
  }
  j <- d$h + 1
  cached <- data.frame(
    point = point[i, j],
    lo68 = ci68$lower[i, j],
    hi68 = ci68$upper[i, j],
    lo90 = ci90$lower[i, j],
    hi90 = ci90$upper[i, j]
  )
  if (max(abs(as.matrix(cached) - as.matrix(d[names(cached)]))) >= 1e-10) {
    stop(sprintf("IRF points or bands for '%s' do not match irf_coherence_h.csv.", v))
  }
  sig68 <- as.logical(ci68$lower[i, j] > 0 | ci68$upper[i, j] < 0)
  if (!identical(sig68, as.logical(d$sig68))) {
    stop(sprintf("The 68%% significance flags for '%s' do not match irf_coherence_h.csv.", v))
  }
  sig90 <- as.logical(ci90$lower[i, j] > 0 | ci90$upper[i, j] < 0)
  if (!identical(sig90, as.logical(d$sig90))) {
    stop(sprintf("The 90%% significance flags for '%s' do not match irf_coherence_h.csv.", v))
  }
}
