# ===================================================================
# Figures for the results section of the paper, one per subsection.
#
# Reads the cached production estimation object and the Task 7 tables.
# NOTHING is re-estimated here.
#
# Every IRF figure runs to h = 36 and carries both bands. The eight figures in
# the results section omit significance markers; the placebo figure retains
# them. The script writes ten figures in total. The 68% band is read off the
# darker ribbon.
#
# Output: paper/fig_*.pdf — where paper_anpec.tex reads them (bare
# filenames, no subdirectory). Repointed 2026-08-05: this used to write into
# arquivo/tex/img/, so regenerating the figures never reached the canonical
# paper and the PDFs beside it were stale manual copies.
# ===================================================================

rm(list = ls())

source("R/modeling/production_spec.R")
SPEC <- production_spec()

CELL_RDS  <- SPEC$coherence_cell_path
PANEL_CSV <- SPEC$data_path
HCSV      <- "output/irf/irf_coherence_h.csv"
T7_CSV    <- "diagnostics/output/t7_2_irf_estado.csv"
IMG_DIR   <- "paper"

H_MAX <- 36L   # every IRF figure stops here

cell <- readRDS(CELL_RDS)
if (cell$instrument != SPEC$instrument || cell$r != SPEC$r || cell$q != SPEC$q) {
  stop("The cached IRF cell does not match the production instrument or factor dimensions.")
}

panel <- readr::read_csv(PANEL_CSV, show_col_types = FALSE)
hcsv  <- readr::read_csv(HCSV, show_col_types = FALSE)

point <- cell$irf$irf_point_matrix
ci68  <- cell$irf$ci[["0.68"]]
ci90  <- cell$irf$ci[["0.90"]]
vn    <- cell$var_names

dir.create(IMG_DIR, showWarnings = FALSE, recursive = TRUE)

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
    # arquivo cobre só as 53 séries escoradas, e a figura plota séries do painel
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

#' Save a paper figure
#'
#' @param file Output filename inside `paper/`.
#' @param plot Plot object to save.
#' @param w Width in inches.
#' @param h Height in inches.
#'
#' @return The path is written as a side effect; no value is used.
save_fig <- function(file, plot, w, h) {
  ggplot2::ggsave(file.path(IMG_DIR, file), plot, width = w, height = h, device = cairo_pdf)
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
save_fig("fig_curva.pdf", grid_of(list(
  list("yield_3m",  "DI 3 meses (p.b.)",  1e4),
  list("yield_6m",  "DI 6 meses (p.b.)",  1e4),
  list("yield_1y",  "DI 1 ano (p.b.)",    1e4),
  list("yield_2y",  "DI 2 anos (p.b.)",   1e4),
  list("yield_5y",  "DI 5 anos (p.b.)",   1e4),
  list("yield_10y", "DI 10 anos (p.b.)",  1e4),
  list("juros_selic", "Selic overnight (p.b.)", 100)
), ncol = 4, mark_sig90 = FALSE), 10.4, 5.8)


# --- 2. Exchange rates and sovereign risk ---------------------------
save_fig("fig_cambio_risco.pdf", grid_of(list(
  list("cambio_usd",      "Câmbio BRL/USD (%)",   "pct"),
  list("cambio_eur",      "Câmbio BRL/EUR (%)",   "pct"),
  list("embi_perc",       "EMBI+ Brasil (p.b.)",  100),
  list("cds_5y",          "CDS 5 anos (p.b.)",    1)
), ncol = 2, mark_sig90 = FALSE), 9.6, 5.8)


# --- 3. Fiscal variables --------------------------------------------
save_fig("fig_fiscal.pdf", grid_of(list(
  list("fiscal_dbgg", "DBGG (p.p. do PIB)", 1),
  list("fiscal_dlsp", "DLSP (p.p. do PIB)", 1),
  list("fiscal_primary_balance", "NFSP primária (R$ bi)", 1e-3),
  list("dlsp_exchange_adjustment", "Ajuste cambial (R$ bi)", 1e-3)
), ncol = 2, mark_sig90 = FALSE), 9.6, 5.8)


# --- 4. Focus expectations ------------------------------------------
save_fig("fig_expectativas.pdf", grid_of(list(
  list("expect_focus_ipca12m", "Focus IPCA 12 meses (p.p.)", 1),
  list("expect_focus_selic_ny", "Focus Selic (p.p.)", 1),
  list("expect_focus_pib_ny", "Focus PIB (p.p.)", 1),
  list("expect_focus_cambio_ny", "Focus câmbio (R$/US$)", 1),
  list("expect_focus_fiscal_dlsp_ny", "Focus DLSP (p.p. do PIB)", 1),
  list("expect_focus_fiscal_primary_balance_ny",
       "Focus primário (p.p. do PIB)", 1),
  list("expect_focus_fiscal_nominal_balance_ny",
       "Focus nominal (p.p. do PIB)", 1)
), ncol = 4, mark_sig90 = FALSE), 10.4, 5.8)


# --- 5. State dependence --------------------------------------------
# Da Tarefa 7 (LP-IV com interação completa), não do DFM. Horizonte próprio: a
# tabela vai até h = 24, e o sombreado em h > 8 marca a faixa estimada mas não
# testada, porque o regime de risco baixo cai a ~59 observações em h = 12. É o
# único uso de área cinza no paper.
H_T7 <- 24L
t7 <- readr::read_csv(T7_CSV, show_col_types = FALSE) |>
  dplyr::filter(var == "cambio_usd", h <= H_T7)

reg <- dplyr::bind_rows(
  data.frame(h = t7$h, b = t7$b_alto,  se = t7$se_alto,  reg = "Risco alto"),
  data.frame(h = t7$h, b = t7$b_baixo, se = t7$se_baixo, reg = "Risco baixo")
) |> dplyr::mutate(lo = b - 1.645 * se, hi = b + 1.645 * se)

p_reg <- ggplot2::ggplot(reg, ggplot2::aes(x = h, colour = reg, fill = reg)) +
  ggplot2::annotate("rect", xmin = 8.5, xmax = H_T7, ymin = -Inf, ymax = Inf,
           fill = "grey86", alpha = 0.5) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = lo, ymax = hi), alpha = 0.16, colour = NA) +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "red", linewidth = 0.35) +
  ggplot2::geom_line(ggplot2::aes(y = b), linewidth = 0.8) +
  ggplot2::scale_colour_manual(values = c("Risco alto" = "#b2182b", "Risco baixo" = "#2166ac")) +
  ggplot2::scale_fill_manual(values   = c("Risco alto" = "#b2182b", "Risco baixo" = "#2166ac")) +
  ggplot2::scale_x_continuous(breaks = seq(0, H_T7, 6), expand = c(0.01, 0)) +
  ggplot2::theme_classic(base_size = 11) +
  ggplot2::labs(y = "Câmbio BRL/USD, resposta em nível", x = NULL, colour = NULL, fill = NULL) +
  ggplot2::theme(legend.position = c(0.75, 0.88), legend.background = ggplot2::element_blank(),
        legend.key.size = ggplot2::unit(0.8, "lines"))

p_t <- ggplot2::ggplot(t7, ggplot2::aes(x = h, y = t_dif)) +
  ggplot2::annotate("rect", xmin = 8.5, xmax = H_T7, ymin = -Inf, ymax = Inf,
           fill = "grey86", alpha = 0.5) +
  ggplot2::geom_hline(yintercept = c(-1.96, 1.96), linetype = "dotted", linewidth = 0.35) +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "red", linewidth = 0.35) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::geom_point(data = subset(t7, abs(t_dif) > 1.96 & h <= 8), size = 1.5) +
  ggplot2::scale_x_continuous(breaks = seq(0, H_T7, 6), expand = c(0.01, 0)) +
  ggplot2::theme_classic(base_size = 11) +
  ggplot2::labs(y = "t da diferença entre regimes", x = NULL)

save_fig("fig_estado.pdf", p_reg + p_t + patchwork::plot_layout(ncol = 2), 8.2, 3.4)


# --- 6. Activity and labor ------------------------------------------
save_fig("fig_atividade.pdf", grid_of(list(
  list("ibc_br",                         "IBC-Br (%)",             "pct"),
  list("ind_transformacao",              "Ind. transformação (%)", "pct"),
  list("ind_bens_duraveis",              "Bens duráveis (%)",      "pct"),
  list("ind_bens_capital",               "Bens de capital (%)",    "pct"),
  list("vendas_varejo",                  "Vendas no varejo (%)",   "pct"),
  list("vendas_servicos",                "Vendas de serviços (%)", "pct"),
  list("capacidade_instalada_industria", "Utiliz. capacidade (p.p.)", 1),
  list("trab_hrs_trabalhadas_industria", "Horas na indústria (%)", "pct")
), ncol = 4, mark_sig90 = FALSE), 10.4, 5.8)


# --- 7. Credit -------------------------------------------------------
save_fig("fig_credito.pdf", grid_of(list(
  list("credit_outstanding",    "Saldo total (%)",          1),
  list("credito_agro",          "Crédito agropecuário (%)", 1),
  list("credito_transporte",    "Crédito transporte (%)",   1),
  list("credito_industria_total", "Crédito indústria (%)",  1),
  list("credito_comercio",      "Crédito comércio (%)",     1),
  list("credito_construcao",    "Crédito construção (%)",   1),
  list("credito_pessoa_fisica", "Crédito pessoa física (%)", 1)
), ncol = 4, mark_sig90 = FALSE), 10.4, 5.8)


# --- 8. Prices -------------------------------------------------------
save_fig("fig_precos.pdf", grid_of(list(
  list("price_ipp",           "IPP (p.p. ao mês)",        1),
  list("price_igp_m",         "IGP-M (p.p. ao mês)",      1),
  list("price_ipca",          "IPCA cheio (p.p. ao mês)", 1),
  list("price_core_ipca_ex0", "Núcleo EX0 (p.p.)",        1),
  list("price_core_ipca_dw",  "Núcleo médias aparadas (p.p.)", 1),
  list("price_core_ipca_ex1", "Núcleo EX1 (p.p.)",        1),
  list("price_ipca_difusao",  "Difusão do IPCA (p.p.)",   1),
  list("price_inpc",          "INPC (p.p. ao mês)",       1)
), ncol = 4, mark_sig90 = FALSE), 10.4, 5.8)


# --- 9. Equity indexes ----------------------------------------------
save_fig("fig_acoes.pdf", grid_of(list(
  list("asset_ibov", "Ibovespa (%)",        1),
  list("asset_smll", "SMLL, small caps (%)", 1),
  list("asset_idiv", "IDIV, dividendos (%)", 1),
  list("asset_imob", "IMOB, incorporadoras (%)", 1),
  list("asset_ifnc", "IFNC, bancos (%)",    1),
  list("asset_imat", "IMAT, materiais (%)", 1),
  list("asset_ifix", "IFIX, renda imob. (%)", 1)
), ncol = 4, mark_sig90 = FALSE), 10.4, 5.8)


# --- 10. Placebos ----------------------------------------------------
save_fig("fig_placebos.pdf", grid_of(list(
  list("sp500_vix", "VIX",                     1),
  list("msci",      "MSCI emergentes",         1),
  list("epu_us",    "EPU Estados Unidos",      1)
), ncol = 3), 9.6, 3.1)


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
