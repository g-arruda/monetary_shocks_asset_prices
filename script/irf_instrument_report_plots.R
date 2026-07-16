# Re-gera os PDFs por variável a partir de output/irf/inst_report_paths.csv
# (sem re-rodar o bootstrap), com títulos ASCII limpos.
rm(list = ls())
library(readr); library(dplyr); library(ggplot2)

REPORT <- tibble::tribble(
  ~var,                    ~lab,                    ~esign,
  "asset_ibov",            "IBOV (acoes)",           "-",
  "cambio_usd",            "Cambio BRL/USD",         "-",
  "yield_6m",              "Yield 6m (politica)",    "+",
  "yield_5y",              "Yield 5y",               "+",
  "spread_icc_juridica",   "Spread ICC PJ",          "+",
  "spread_icc_fisica",     "Spread ICC PF",          "+",
  "credit_outstanding",    "Credito total",          "-",
  "credito_pessoa_fisica", "Credito PF",             "-",
  "price_ipca",            "IPCA cheio",             "-",
  "price_core_ipca_ex0",   "Nucleo IPCA (ex0)",      "-",
  "cds_5y",                "CDS 5y",                 "-")
INSTRUMENTS <- c("z_jk_bs_purif","z_jk_purif","z_jk_raw_purif","z_bruto","z_jk","z_het_jk_3var")
DEFAULT_INST <- "z_jk_bs_purif"
cfg_levels <- c("r6q5.full","r7q6.full","r8q8.full","r6q5.pre_covid","r7q6.pre_covid","r8q8.pre_covid")

d <- read_csv("output/irf/inst_report_paths.csv", show_col_types = FALSE)
d$cfg <- gsub("·", ".", d$cfg)                       # substitui middot por ponto
d$cfg <- factor(d$cfg, levels = cfg_levels)
d$instrument <- factor(d$instrument, levels = INSTRUMENTS)
pal <- setNames(c("#1b9e77","#d95f02","#7570b3","#e7298a","#66a61e","#e6ab02"), INSTRUMENTS)

pdf("output/irf/inst_report_by_variable_instruments.pdf", width = 12, height = 7.5)
for (i in seq_len(nrow(REPORT))) {
  df <- filter(d, var == REPORT$var[i])
  print(ggplot(df, aes(h, point, colour = instrument)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey65") +
    geom_line(linewidth = 0.65) +
    facet_wrap(~ cfg, ncol = 3, scales = "free_y") +
    scale_colour_manual(values = pal) +
    labs(title = sprintf("%s  |  resposta a +50bp por instrumento x config  (sinal esperado: %s)",
                         REPORT$lab[i], REPORT$esign[i]),
         subtitle = "linhas = instrumentos; paineis = (r,q).amostra; ponto-estimativa (sem bandas)",
         x = "horizonte (meses)", y = NULL) +
    theme_minimal(base_size = 10) + theme(legend.position = "bottom"))
}
dev.off()

pdf("output/irf/inst_report_by_variable_bands.pdf", width = 12, height = 7.5)
for (i in seq_len(nrow(REPORT))) {
  df <- filter(d, var == REPORT$var[i], instrument == DEFAULT_INST)
  print(ggplot(df, aes(h)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey65") +
    geom_ribbon(aes(ymin = lo90, ymax = hi90), alpha = 0.15, fill = "#2166ac") +
    geom_ribbon(aes(ymin = lo68, ymax = hi68), alpha = 0.25, fill = "#2166ac") +
    geom_line(aes(y = point), colour = "#08306b", linewidth = 0.7) +
    facet_wrap(~ cfg, ncol = 3, scales = "free_y") +
    labs(title = sprintf("%s  |  %s (default), bandas 68/90  (sinal esperado: %s)",
                         REPORT$lab[i], DEFAULT_INST, REPORT$esign[i]),
         x = "horizonte (meses)", y = NULL) +
    theme_minimal(base_size = 10))
}
dev.off()
cat("PDFs regenerados com titulos limpos.\n")
