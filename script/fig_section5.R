# ===================================================================
# Figures for the results section of the paper, one per subsection.
#
# Reads the cached production estimation object and the Task 7 tables.
# NOTHING is re-estimated here.
#
# Every IRF figure runs to h = 36 and carries both bands. Orange dots mark the
# horizons where the 90% band excludes zero; the 68% band is read off the darker
# ribbon. No shading.
#
# Output: tex/img/fig_*.pdf
# ===================================================================

rm(list = ls())

suppressMessages({
  library(ggplot2)
  library(patchwork)
  library(readr)
  library(dplyr)
})

CELL_RDS  <- "output/irf/irf_coherence_cell.rds"
PANEL_CSV <- "data/processed/data_log_deseasonalized.csv"
HCSV      <- "output/irf/irf_coherence_h.csv"
T7_CSV    <- "diagnostics/output/t7_2_irf_estado.csv"
IMG_DIR   <- "tex/img"

H_MAX <- 36L   # every IRF figure stops here

cell <- readRDS(CELL_RDS)
stopifnot(cell$instrument == "z_jk_bs_purif", cell$r == 7L, cell$q == 6L)

panel <- read_csv(PANEL_CSV, show_col_types = FALSE)
hcsv  <- read_csv(HCSV, show_col_types = FALSE)

point <- cell$irf$irf_point_matrix
ci68  <- cell$irf$ci[["0.68"]]
ci90  <- cell$irf$ci[["0.90"]]
vn    <- cell$var_names

dir.create(IMG_DIR, showWarnings = FALSE, recursive = TRUE)

# `scale` is a multiplicative constant, or "pct" to divide by the sample mean
# of the raw series and express the response in percent.
irf_panel <- function(v, lab, scale = 1) {
  i <- match(v, vn)
  stopifnot(!is.na(i))
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

  ggplot(df, aes(x = h)) +
    geom_ribbon(aes(ymin = lo90, ymax = hi90), fill = "steelblue", alpha = 0.18) +
    geom_ribbon(aes(ymin = lo68, ymax = hi68), fill = "steelblue", alpha = 0.36) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "red", linewidth = 0.35) +
    geom_line(aes(y = irf), colour = "black", linewidth = 0.8) +
    # marcadores nos horizontes em que a banda de 90% exclui zero
    geom_point(data = subset(df, sig), aes(y = irf), shape = 21,
               fill = "#d95f02", colour = "black", size = 1.9, stroke = 0.45) +
    scale_x_continuous(breaks = seq(0, H_MAX, 6), limits = c(0, H_MAX),
                       expand = c(0.01, 0)) +
    theme_classic(base_size = 11) +
    labs(y = lab, x = NULL) +
    theme(axis.title.y = element_text(size = rel(0.95)),
          axis.text    = element_text(size = rel(0.85)),
          plot.margin  = margin(3, 5, 1, 2))
}

save_fig <- function(file, plot, w, h) {
  ggsave(file.path(IMG_DIR, file), plot, width = w, height = h, device = cairo_pdf)
  cat("->", file.path(IMG_DIR, file), "\n")
}

grid_of <- function(specs, ncol) {
  wrap_plots(lapply(specs, function(s) irf_panel(s[[1]], s[[2]], s[[3]])), ncol = ncol)
}


# --- 1. estrutura a termo -------------------------------------------
save_fig("fig_curva.pdf", grid_of(list(
  list("yield_3m",  "DI 3 meses (p.b.)",  1e4),
  list("yield_6m",  "DI 6 meses (p.b.)",  1e4),
  list("yield_1y",  "DI 1 ano (p.b.)",    1e4),
  list("yield_2y",  "DI 2 anos (p.b.)",   1e4),
  list("yield_5y",  "DI 5 anos (p.b.)",   1e4),
  list("yield_10y", "DI 10 anos (p.b.)",  1e4),
  list("juros_selic", "Selic overnight (p.b.)", 100),
  list("juros_cdi",   "CDI overnight (p.b.)",   100)
), ncol = 4), 10.4, 5.8)


# --- 2. câmbio e risco soberano -------------------------------------
save_fig("fig_cambio_risco.pdf", grid_of(list(
  list("cambio_usd",      "Câmbio BRL/USD (%)",   "pct"),
  list("cambio_eur",      "Câmbio BRL/EUR (%)",   "pct"),
  list("embi_perc",       "EMBI+ Brasil (p.b.)",  100),
  list("cds_5y",          "CDS 5 anos (p.b.)",    1),
  list("commodity_metal", "Commodities metal, R$ (%)", "pct"),
  list("commodity_agro",  "Commodities agro, R$ (%)",  "pct")
), ncol = 3), 9.6, 5.8)


# --- 3. dependência de estado ---------------------------------------
# Da Tarefa 7 (LP-IV com interação completa), não do DFM. Horizonte próprio: a
# tabela vai até h = 24, e o sombreado em h > 8 marca a faixa estimada mas não
# testada, porque o regime de risco baixo cai a ~59 observações em h = 12. É o
# único uso de área cinza no paper.
H_T7 <- 24L
t7 <- read_csv(T7_CSV, show_col_types = FALSE) |>
  filter(var == "cambio_usd", h <= H_T7)

reg <- bind_rows(
  data.frame(h = t7$h, b = t7$b_alto,  se = t7$se_alto,  reg = "Risco alto"),
  data.frame(h = t7$h, b = t7$b_baixo, se = t7$se_baixo, reg = "Risco baixo")
) |> mutate(lo = b - 1.645 * se, hi = b + 1.645 * se)

p_reg <- ggplot(reg, aes(x = h, colour = reg, fill = reg)) +
  annotate("rect", xmin = 8.5, xmax = H_T7, ymin = -Inf, ymax = Inf,
           fill = "grey86", alpha = 0.5) +
  geom_ribbon(aes(ymin = lo, ymax = hi), alpha = 0.16, colour = NA) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "red", linewidth = 0.35) +
  geom_line(aes(y = b), linewidth = 0.8) +
  scale_colour_manual(values = c("Risco alto" = "#b2182b", "Risco baixo" = "#2166ac")) +
  scale_fill_manual(values   = c("Risco alto" = "#b2182b", "Risco baixo" = "#2166ac")) +
  scale_x_continuous(breaks = seq(0, H_T7, 6), expand = c(0.01, 0)) +
  theme_classic(base_size = 11) +
  labs(y = "Câmbio BRL/USD, resposta em nível", x = NULL, colour = NULL, fill = NULL) +
  theme(legend.position = c(0.75, 0.88), legend.background = element_blank(),
        legend.key.size = unit(0.8, "lines"))

p_t <- ggplot(t7, aes(x = h, y = t_dif)) +
  annotate("rect", xmin = 8.5, xmax = H_T7, ymin = -Inf, ymax = Inf,
           fill = "grey86", alpha = 0.5) +
  geom_hline(yintercept = c(-1.96, 1.96), linetype = "dotted", linewidth = 0.35) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "red", linewidth = 0.35) +
  geom_line(linewidth = 0.8) +
  geom_point(data = subset(t7, abs(t_dif) > 1.96 & h <= 8), size = 1.5) +
  scale_x_continuous(breaks = seq(0, H_T7, 6), expand = c(0.01, 0)) +
  theme_classic(base_size = 11) +
  labs(y = "t da diferença entre regimes", x = NULL)

save_fig("fig_estado.pdf", p_reg + p_t + plot_layout(ncol = 2), 8.2, 3.4)


# --- 4. atividade e trabalho ----------------------------------------
save_fig("fig_atividade.pdf", grid_of(list(
  list("ibc_br",                         "IBC-Br (%)",             "pct"),
  list("ind_transformacao",              "Ind. transformação (%)", "pct"),
  list("ind_bens_duraveis",              "Bens duráveis (%)",      "pct"),
  list("ind_bens_capital",               "Bens de capital (%)",    "pct"),
  list("vendas_varejo",                  "Vendas no varejo (%)",   "pct"),
  list("vendas_servicos",                "Vendas de serviços (%)", "pct"),
  list("capacidade_instalada_industria", "Utiliz. capacidade (p.p.)", 1),
  list("trab_hrs_trabalhadas_industria", "Horas na indústria (%)", "pct")
), ncol = 4), 10.4, 5.8)


# --- 5. crédito ------------------------------------------------------
save_fig("fig_credito.pdf", grid_of(list(
  list("credit_outstanding",    "Saldo total (%)",          1),
  list("credito_agro",          "Crédito agropecuário (%)", 1),
  list("credito_transporte",    "Crédito transporte (%)",   1),
  list("credito_industria_total", "Crédito indústria (%)",  1),
  list("credito_comercio",      "Crédito comércio (%)",     1),
  list("credito_construcao",    "Crédito construção (%)",   1),
  list("credito_pessoa_fisica", "Crédito pessoa física (%)", 1)
), ncol = 4), 10.4, 5.8)


# --- 6. preços -------------------------------------------------------
save_fig("fig_precos.pdf", grid_of(list(
  list("price_ipp",           "IPP (p.p. ao mês)",        1),
  list("price_igp_m",         "IGP-M (p.p. ao mês)",      1),
  list("price_ipca",          "IPCA cheio (p.p. ao mês)", 1),
  list("price_core_ipca_ex0", "Núcleo EX0 (p.p.)",        1),
  list("price_core_ipca_dw",  "Núcleo médias aparadas (p.p.)", 1),
  list("price_core_ipca_ex1", "Núcleo EX1 (p.p.)",        1),
  list("price_ipca_difusao",  "Difusão do IPCA (p.p.)",   1),
  list("price_inpc",          "INPC (p.p. ao mês)",       1)
), ncol = 4), 10.4, 5.8)


# --- 7. ações --------------------------------------------------------
save_fig("fig_acoes.pdf", grid_of(list(
  list("asset_ibov", "Ibovespa (%)",        1),
  list("asset_mlcx", "MLCX, large caps (%)", 1),
  list("asset_smll", "SMLL, small caps (%)", 1),
  list("asset_idiv", "IDIV, dividendos (%)", 1),
  list("asset_imob", "IMOB, incorporadoras (%)", 1),
  list("asset_ifnc", "IFNC, bancos (%)",    1),
  list("asset_imat", "IMAT, materiais (%)", 1),
  list("asset_ifix", "IFIX, renda imob. (%)", 1)
), ncol = 4), 10.4, 5.8)


# --- 8. placebos ------------------------------------------------------
save_fig("fig_placebos.pdf", grid_of(list(
  list("sp500_vix", "S&P 500 / VIX",           1),
  list("msci",      "MSCI emergentes",         1),
  list("epu_us",    "EPU Estados Unidos",      1)
), ncol = 3), 9.6, 3.1)


# --- auto-teste ------------------------------------------------------
# Todo valor plotado em h=0 tem que bater com irf_coherence_h.csv.
plotted <- c("yield_3m","yield_6m","yield_1y","yield_2y","yield_5y","yield_10y",
             "juros_selic","juros_cdi","cambio_usd","cambio_eur","embi_perc",
             "cds_5y","commodity_metal","commodity_agro","ind_transformacao",
             "ind_bens_duraveis","ind_bens_capital","vendas_varejo",
             "capacidade_instalada_industria","trab_hrs_trabalhadas_industria",
             "ibc_br","vendas_servicos",
             "credito_agro","credito_transporte","credito_industria_total",
             "credit_outstanding","credito_pessoa_fisica","credito_comercio",
             "credito_construcao",
             "price_ipp","price_igp_m","price_ipca","price_core_ipca_ex0",
             "price_core_ipca_dw","price_core_ipca_ex1","price_ipca_difusao",
             "price_inpc","asset_ibov","asset_mlcx","asset_smll","asset_idiv",
             "asset_imob","asset_ifnc","asset_imat","asset_ifix",
             "sp500_vix","msci","epu_us")
n_chk <- 0L
for (v in plotted) {
  i <- match(v, vn)
  stopifnot(!is.na(i))
  d <- hcsv[hcsv$var == v & hcsv$h <= H_MAX, ]
  if (!nrow(d)) next                       # série do painel fora da régua de coerência
  n_chk <- n_chk + 1L
  j <- d$h + 1
  # ponto e flag de significância reconstruída batem com o CSV publicado
  stopifnot(max(abs(point[i, j] - d$point)) < 1e-10)
  stopifnot(identical(as.logical(ci90$lower[i, j] > 0 | ci90$upper[i, j] < 0),
                      as.logical(d$sig90)))
}
cat(sprintf("auto-teste contra irf_coherence_h.csv (ponto + sig90, h=0..%d): OK em %d de %d séries plotadas\n",
            H_MAX, n_chk, length(plotted)))
cat("sig90 em h>12 no painel escorado:", sum(hcsv$sig90[hcsv$h > 12]),
    "| sig68 total:", sum(hcsv$sig68), "\n")
