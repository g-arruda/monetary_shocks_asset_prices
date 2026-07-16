# ===================================================================
# Relatório por variável: como cada variável reage a cada instrumento
# e configuração (r,q)×amostra. Complementa
# script/irf_instrument_diag_sweep.R extraindo o conjunto de variáveis
# pedido, ponto-a-ponto (h=0..40) com bandas 68/90.
#
# Mesma grade e settings de produção (nboot=800, seed=123 => idêntico
# ao sweep). Reusa run_stage2_cell; nenhum script de produção alterado.
#
# Saídas em output/irf/:
#   inst_report_paths.csv                 (tidy: point + bandas 68/90)
#   inst_report_summary.csv               (h0/h6/h12/h24/pico + sig por célula×var)
#   inst_report_by_variable_instruments.pdf (1 pág/var: 6 instrumentos, facet config)
#   inst_report_by_variable_bands.pdf       (1 pág/var: instrumento default c/ bandas)
# ===================================================================

rm(list = ls())

library(readr); library(dplyr); library(tidyr); library(ggplot2)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/validation_tests.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")


# ---- Config (idêntica ao sweep) -----------------------------------

INSTRUMENTS <- c("z_jk_bs_purif", "z_jk_purif", "z_jk_raw_purif",
                 "z_bruto", "z_jk", "z_het_jk_3var")
DEFAULT_INST <- "z_jk_bs_purif"
RQ <- list(c(6L, 5L), c(7L, 6L), c(8L, 8L))
SAMPLES <- c("full", "pre_covid")
WINDOWS <- list(full      = as.Date(c("2013-01-01", "2025-12-31")),
                pre_covid = as.Date(c("2013-01-01", "2019-12-31")))

P_LAGS <- 6L; MP_VAR <- "yield_6m"; HORIZON <- 48L; READ_H <- 40L
N_BOOT <- 800L; BOOT_SEED <- 123L; SHOCK_BPS <- 50; CI_LEVELS <- c(0.68, 0.90)

# variáveis pedidas (rótulo + sinal teórico esperado p/ aperto contracionista)
REPORT <- tibble::tribble(
  ~var,                    ~lab,                          ~esign,
  "asset_ibov",            "IBOV (ações)",                 -1,
  "cambio_usd",            "Câmbio BRL/USD",               -1,
  "yield_6m",              "Yield 6m (política)",           1,
  "yield_5y",              "Yield 5y",                      1,
  "spread_icc_juridica",   "Spread ICC PJ",                 1,
  "spread_icc_fisica",     "Spread ICC PF",                 1,
  "credit_outstanding",    "Crédito total",                -1,
  "credito_pessoa_fisica", "Crédito PF",                   -1,
  "price_ipca",            "IPCA cheio",                   -1,
  "price_core_ipca_ex0",   "Núcleo IPCA (ex0)",            -1,
  "cds_5y",                "CDS 5y",                       -1
)
REPORT_VARS <- REPORT$var

OUT_DIR <- "output/irf"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Dados --------------------------------------------------------

raw_data  <- read_csv("data/processed/data_log_deseasonalized.csv", show_col_types = FALSE) |> drop_na()
dates     <- as.Date(raw_data$ref.date)
data_mat  <- raw_data |> select(-ref.date) |> as.matrix()
tcode     <- infer_tcode_from_varnames(colnames(data_mat))
var_names <- colnames(data_mat)
inst_panel <- read_csv("data/processed/instrumentos_mensais.csv", show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

grid <- read_csv("output/instrument/mosw_strength_grid.csv", show_col_types = FALSE) |>
  select(sample, r, q, instrument, f_factor, wald_mp)

stopifnot(all(REPORT_VARS %in% var_names))


# ---- Loop da grade ------------------------------------------------

path_rows <- list(); summ_rows <- list()

for (inst in INSTRUMENTS) for (rq in RQ) for (smp in SAMPLES) {
  r <- rq[1]; q <- rq[2]
  cfg <- sprintf("r%dq%d·%s", r, q, smp)
  cat(sprintf("=== %s | %s ===\n", inst, cfg))
  gsel <- grid |> filter(sample == smp, r == !!r, q == !!q, instrument == inst)
  cell <- tryCatch(
    run_stage2_cell(data_mat, dates, inst_panel, sample_window = WINDOWS[[smp]],
                    r = r, q = q, p = P_LAGS, instrument = inst, mp_var = MP_VAR,
                    h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED,
                    shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS),
    error = function(e) { cat("  ERRO:", conditionMessage(e), "\n"); NULL })
  if (is.null(cell)) next
  point <- cell$irf$irf_point_matrix
  ci68  <- cell$irf$ci[["0.68"]]; ci90 <- cell$irf$ci[["0.90"]]

  for (v in REPORT_VARS) {
    idx <- match(v, var_names)
    p    <- point[idx, 1:(READ_H + 1)]
    lo68 <- ci68$lower[idx, 1:(READ_H + 1)]; hi68 <- ci68$upper[idx, 1:(READ_H + 1)]
    lo90 <- ci90$lower[idx, 1:(READ_H + 1)]; hi90 <- ci90$upper[idx, 1:(READ_H + 1)]
    sig90 <- lo90 > 0 | hi90 < 0
    path_rows[[length(path_rows) + 1]] <- tibble::tibble(
      instrument = inst, r = r, q = q, sample = smp, cfg = cfg, var = v,
      h = 0:READ_H, point = p, lo68 = lo68, hi68 = hi68, lo90 = lo90, hi90 = hi90, sig90 = sig90)
    kv <- function(hh) p[hh + 1]
    esign <- REPORT$esign[REPORT$var == v]
    win <- 0:READ_H  # janela de sinal simples p/ resumo
    summ_rows[[length(summ_rows) + 1]] <- tibble::tibble(
      instrument = inst, r = r, q = q, sample = smp, cfg = cfg, var = v, esign = esign,
      f_factor = if (nrow(gsel)) gsel$f_factor[1] else NA_real_,
      wald_mp = if (nrow(gsel)) gsel$wald_mp[1] else NA_real_,
      h0 = kv(0), h6 = kv(6), h12 = kv(12), h24 = kv(24),
      peak_h = which.max(abs(p)) - 1, peak_val = p[which.max(abs(p))],
      sign_h0 = sign(p[1]), sign_ok_h0 = sign(p[1]) == esign,
      share_sign_ok = mean(sign(p) == esign), n_sig90 = sum(sig90))
  }
}

path_all <- bind_rows(path_rows)
summ_all <- bind_rows(summ_rows)

# ordena facetas: full (3) em cima, pre_covid (3) embaixo
cfg_levels <- c("r6q5·full","r7q6·full","r8q8·full","r6q5·pre_covid","r7q6·pre_covid","r8q8·pre_covid")
path_all$cfg <- factor(path_all$cfg, levels = cfg_levels)
summ_all$cfg <- factor(summ_all$cfg, levels = cfg_levels)
path_all$instrument <- factor(path_all$instrument, levels = INSTRUMENTS)

write_csv(path_all, file.path(OUT_DIR, "inst_report_paths.csv"))
write_csv(summ_all, file.path(OUT_DIR, "inst_report_summary.csv"))


# ---- Plot A: 1 página por variável, 6 instrumentos, facet config --

pal <- setNames(c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e", "#e6ab02"), INSTRUMENTS)

pdf(file.path(OUT_DIR, "inst_report_by_variable_instruments.pdf"), width = 12, height = 7.5)
for (i in seq_len(nrow(REPORT))) {
  v <- REPORT$var[i]; lab <- REPORT$lab[i]; es <- REPORT$esign[i]
  df <- path_all |> filter(var == v)
  p <- ggplot(df, aes(h, point, colour = instrument)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey65") +
    geom_line(linewidth = 0.65) +
    facet_wrap(~ cfg, ncol = 3, scales = "free_y") +
    scale_colour_manual(values = pal) +
    labs(title = sprintf("%s  —  resposta a +50bp por instrumento × config (sinal teórico esperado: %s)",
                         lab, ifelse(es > 0, "+", "−")),
         subtitle = "linhas = instrumentos; painéis = (r,q)·amostra; ponto-estimativa (sem bandas)",
         x = "horizonte (meses)", y = NULL) +
    theme_minimal(base_size = 10) + theme(legend.position = "bottom")
  print(p)
}
dev.off()


# ---- Plot B: 1 página por variável, instrumento default, c/ bandas -

pdf(file.path(OUT_DIR, "inst_report_by_variable_bands.pdf"), width = 12, height = 7.5)
for (i in seq_len(nrow(REPORT))) {
  v <- REPORT$var[i]; lab <- REPORT$lab[i]; es <- REPORT$esign[i]
  df <- path_all |> filter(var == v, instrument == DEFAULT_INST)
  p <- ggplot(df, aes(h)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey65") +
    geom_ribbon(aes(ymin = lo90, ymax = hi90), alpha = 0.15, fill = "#2166ac") +
    geom_ribbon(aes(ymin = lo68, ymax = hi68), alpha = 0.25, fill = "#2166ac") +
    geom_line(aes(y = point), colour = "#08306b", linewidth = 0.7) +
    facet_wrap(~ cfg, ncol = 3, scales = "free_y") +
    labs(title = sprintf("%s  —  %s (default), bandas 68/90 (sinal esperado: %s)",
                         lab, DEFAULT_INST, ifelse(es > 0, "+", "−")),
         x = "horizonte (meses)", y = NULL) +
    theme_minimal(base_size = 10)
  print(p)
}
dev.off()

cat(sprintf("\nGravado: %d linhas ponto-a-ponto, %d de resumo, 2 PDFs.\n",
            nrow(path_all), nrow(summ_all)))
cat("Concluido.\n")
