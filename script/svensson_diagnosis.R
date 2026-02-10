rm(list = ls())

library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)

source("R/modeling/svensson_model.R")

# =============================================================================
# 1. PREPARAÇÃO DOS DADOS (idêntico ao yield_curve.R)
# =============================================================================

di_data <- read_csv("data/di.csv", show_col_types = FALSE)

meses_liquidos_antigo <- c("JAN", "FEV", "MAR", "ABR", "MAI", "JUN",
                           "JUL", "AGO", "SET", "OUT", "NOV", "DEZ")
meses_liquidos_novo   <- c("F", "G", "H", "J", "K", "M",
                           "N", "Q", "U", "V", "X", "Z")

dados_preparados <- di_data %>%
  mutate(
    ref_date = as.Date(TradeDate),
    matur_date = as.Date(ExpirationDate),
    maturity_years = BDaysToExp / 252,
    yield_bid = SettlementRate,
    ticker_suffix = substr(TickerSymbol, 4, nchar(TickerSymbol)),
    is_old_format = nchar(ticker_suffix) == 4,
    ticker_month = ifelse(is_old_format,
                          substr(ticker_suffix, 1, 3),
                          substr(ticker_suffix, 1, 1)),
    year = as.integer(format(ref_date, "%Y"))
  ) %>%
  filter(
    (is_old_format & ticker_month %in% meses_liquidos_antigo) |
      (!is_old_format & ticker_month %in% meses_liquidos_novo),
    !is.na(yield_bid),
    !is.na(maturity_years),
    maturity_years > 0,
    # FILTRO: apenas 2010 em diante para avaliação acadêmica
    year >= 2010
  ) %>%
  select(ref_date, matur_date, maturity_years, yield_bid) %>%
  arrange(ref_date, maturity_years)


# =============================================================================
# 2. FIT PARA TODAS AS DATAS (com diagnósticos)
# =============================================================================

cat("Preparando dados por data...\n")

datas_validas <- dados_preparados %>%
  group_by(ref_date) %>%
  summarise(n_obs = n(), .groups = "drop") %>%
  filter(n_obs >= 6)

cat(sprintf("Total de datas com >= 6 contratos: %d\n", nrow(datas_validas)))
cat("Ajustando Svensson para cada data... (pode levar alguns minutos)\n\n")

# Fit para cada data
resultados <- vector("list", nrow(datas_validas))

pb <- txtProgressBar(min = 0, max = nrow(datas_validas), style = 3)

for (i in seq_len(nrow(datas_validas))) {
  d <- datas_validas$ref_date[i]
  
  dados_d <- dados_preparados %>% filter(ref_date == d)
  
  fit <- fit_svensson(
    maturities = dados_d$maturity_years,
    rates = dados_d$yield_bid,
    return_diagnostics = TRUE
  )
  
  # Durbin-Watson para autocorrelação nos resíduos
  resid <- fit$residuals
  dw <- if (length(resid) > 1 && !any(is.na(resid))) {
    sum(diff(resid)^2) / sum(resid^2)
  } else {
    NA_real_
  }
  
  # Max absolute residual
  max_abs_resid <- if (!any(is.na(resid))) max(abs(resid)) else NA_real_
  
  resultados[[i]] <- tibble(
    ref_date     = d,
    n_obs        = nrow(dados_d),
    max_mat      = max(dados_d$maturity_years),
    rmse         = fit$rmse,
    mae          = fit$mae,
    r_squared    = fit$r_squared,
    max_resid    = max_abs_resid,
    convergence  = fit$convergence,
    iterations   = fit$iterations,
    beta0        = fit$params[1],
    beta1        = fit$params[2],
    beta2        = fit$params[3],
    beta3        = fit$params[4],
    tau1         = fit$params[5],
    tau2         = fit$params[6],
    dw_stat      = dw,
    level        = fit$level,
    slope        = fit$slope,
    curvature    = fit$curvature
  )
  
  setTxtProgressBar(pb, i)
}

close(pb)

diagnostics <- bind_rows(resultados)

# =============================================================================
# 3. RELATÓRIO DE DIAGNÓSTICO
# =============================================================================

cat("\n\n")
cat("==============================================================\n")
cat("  DIAGNÓSTICO MODELO SVENSSON (>= 2010) — AVALIAÇÃO ACADÊMICA\n")
cat("==============================================================\n")

cat(sprintf("\nPeríodo: %s a %s\n", min(diagnostics$ref_date), max(diagnostics$ref_date)))
cat(sprintf("Datas ajustadas: %d\n", nrow(diagnostics)))

# --- Convergência ---
conv_ok <- sum(diagnostics$convergence == 0, na.rm = TRUE)
cat(sprintf("\n=== CONVERGÊNCIA ===\n"))
cat(sprintf("  Sucesso (conv=0): %d / %d  (%.1f%%)\n", 
    conv_ok, nrow(diagnostics), 100 * conv_ok / nrow(diagnostics)))

# --- RMSE (em basis points) ---
rmse_bps <- diagnostics$rmse * 10000
cat(sprintf("\n=== RMSE (basis points) ===\n"))
cat(sprintf("  Média:    %6.2f bps\n", mean(rmse_bps, na.rm = TRUE)))
cat(sprintf("  Mediana:  %6.2f bps\n", median(rmse_bps, na.rm = TRUE)))
cat(sprintf("  P5:       %6.2f bps\n", quantile(rmse_bps, 0.05, na.rm = TRUE)))
cat(sprintf("  P25:      %6.2f bps\n", quantile(rmse_bps, 0.25, na.rm = TRUE)))
cat(sprintf("  P75:      %6.2f bps\n", quantile(rmse_bps, 0.75, na.rm = TRUE)))
cat(sprintf("  P95:      %6.2f bps\n", quantile(rmse_bps, 0.95, na.rm = TRUE)))
cat(sprintf("  Max:      %6.2f bps\n", max(rmse_bps, na.rm = TRUE)))

# Benchmark  
pct_under_5  <- mean(rmse_bps < 5, na.rm = TRUE) * 100
pct_under_10 <- mean(rmse_bps < 10, na.rm = TRUE) * 100
pct_under_20 <- mean(rmse_bps < 20, na.rm = TRUE) * 100
cat(sprintf("\n  Benchmark B3/DI:\n"))
cat(sprintf("    RMSE < 5 bps:  %.1f%%  (excelente)\n", pct_under_5))
cat(sprintf("    RMSE < 10 bps: %.1f%%  (bom)\n", pct_under_10))
cat(sprintf("    RMSE < 20 bps: %.1f%%  (aceitável)\n", pct_under_20))

# --- MAE ---
mae_bps <- diagnostics$mae * 10000
cat(sprintf("\n=== MAE (basis points) ===\n"))
cat(sprintf("  Média:    %6.2f bps\n", mean(mae_bps, na.rm = TRUE)))
cat(sprintf("  Mediana:  %6.2f bps\n", median(mae_bps, na.rm = TRUE)))

# --- R² ---
cat(sprintf("\n=== R² ===\n"))
cat(sprintf("  Média:    %.4f\n", mean(diagnostics$r_squared, na.rm = TRUE)))
cat(sprintf("  Mediana:  %.4f\n", median(diagnostics$r_squared, na.rm = TRUE)))
cat(sprintf("  P5:       %.4f\n", quantile(diagnostics$r_squared, 0.05, na.rm = TRUE)))
cat(sprintf("  Min:      %.4f\n", min(diagnostics$r_squared, na.rm = TRUE)))

pct_r2_99 <- mean(diagnostics$r_squared > 0.99, na.rm = TRUE) * 100
pct_r2_95 <- mean(diagnostics$r_squared > 0.95, na.rm = TRUE) * 100
cat(sprintf("\n  Benchmark:\n"))
cat(sprintf("    R² > 0.99: %.1f%%\n", pct_r2_99))
cat(sprintf("    R² > 0.95: %.1f%%\n", pct_r2_95))

# --- Max absolute residual ---
max_resid_bps <- diagnostics$max_resid * 10000
cat(sprintf("\n=== MAX |RESÍDUO| (basis points) ===\n"))
cat(sprintf("  Média:    %6.2f bps\n", mean(max_resid_bps, na.rm = TRUE)))
cat(sprintf("  P95:      %6.2f bps\n", quantile(max_resid_bps, 0.95, na.rm = TRUE)))

# --- Durbin-Watson ---
cat(sprintf("\n=== DURBIN-WATSON (autocorrelação dos resíduos) ===\n"))
cat(sprintf("  Média:    %.4f  (2.0 = sem autocorrelação)\n", mean(diagnostics$dw_stat, na.rm = TRUE)))
cat(sprintf("  Mediana:  %.4f\n", median(diagnostics$dw_stat, na.rm = TRUE)))
cat("  Nota: DW baixo é esperado — Svensson é parcimonioso (6 params).\n")
cat("  A autocorrelação residual não invalida o modelo para interpolação.\n")

# --- Identificação tau1 vs tau2 ---
tau_ratio <- pmin(diagnostics$tau1, diagnostics$tau2) / pmax(diagnostics$tau1, diagnostics$tau2)
cat(sprintf("\n=== IDENTIFICAÇÃO tau1 vs tau2 ===\n"))
cat(sprintf("  Razão min(tau)/max(tau) — média: %.4f (< 0.8 = boa separação)\n", mean(tau_ratio, na.rm = TRUE)))
cat(sprintf("  %% com razão > 0.9 (quase-degenerado): %.1f%%\n", 
    mean(tau_ratio > 0.9, na.rm = TRUE) * 100))

# --- Parâmetros por ano ---
cat(sprintf("\n=== MÉTRICAS POR ANO ===\n"))
por_ano <- diagnostics %>%
  mutate(ano = format(ref_date, "%Y")) %>%
  group_by(ano) %>%
  summarise(
    n_datas    = n(),
    rmse_bps   = round(median(rmse * 10000, na.rm = TRUE), 2),
    r2_med     = round(median(r_squared, na.rm = TRUE), 4),
    n_obs_med  = round(median(n_obs), 0),
    conv_pct   = round(mean(convergence == 0, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  )

print(as.data.frame(por_ano), row.names = FALSE)


# =============================================================================
# 4. GRÁFICOS DE DIAGNÓSTICO
# =============================================================================

cat("\n\nGerando gráficos...\n")

# --- 4.1 RMSE ao longo do tempo ---
p_rmse <- ggplot(diagnostics, aes(x = ref_date, y = rmse * 10000)) +
  geom_line(alpha = 0.4, color = "steelblue") +
  geom_smooth(method = "loess", span = 0.1, color = "darkred", se = FALSE) +
  geom_hline(yintercept = 10, linetype = "dashed", color = "red", alpha = 0.6) +
  annotate("text", x = min(diagnostics$ref_date) + 365, y = 11, 
           label = "10 bps", color = "red", size = 3) +
  labs(
    title = "RMSE do Modelo Svensson ao Longo do Tempo",
    subtitle = "Curva DI Futuro — B3",
    x = "Data", y = "RMSE (basis points)"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("data/curva_juros/diag_rmse_temporal.png", p_rmse, width = 12, height = 5, dpi = 150)

# --- 4.2 R² ao longo do tempo ---
p_r2 <- ggplot(diagnostics, aes(x = ref_date, y = r_squared)) +
  geom_line(alpha = 0.4, color = "steelblue") +
  geom_smooth(method = "loess", span = 0.1, color = "darkred", se = FALSE) +
  geom_hline(yintercept = 0.99, linetype = "dashed", color = "green4", alpha = 0.6) +
  labs(
    title = "R² do Modelo Svensson ao Longo do Tempo",
    x = "Data", y = "R²"
  ) +
  coord_cartesian(ylim = c(min(0.85, min(diagnostics$r_squared, na.rm = TRUE)), 1)) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("data/curva_juros/diag_r2_temporal.png", p_r2, width = 12, height = 5, dpi = 150)

# --- 4.3 Distribuição do RMSE ---
p_rmse_hist <- ggplot(diagnostics, aes(x = rmse * 10000)) +
  geom_histogram(bins = 60, fill = "steelblue", color = "white", alpha = 0.8) +
  geom_vline(xintercept = median(rmse_bps, na.rm = TRUE), 
             linetype = "dashed", color = "red", linewidth = 1) +
  annotate("text", x = median(rmse_bps, na.rm = TRUE) + 1, 
           y = Inf, vjust = 2,
           label = sprintf("Mediana: %.1f bps", median(rmse_bps, na.rm = TRUE)),
           color = "red", size = 3.5) +
  labs(
    title = "Distribuição do RMSE",
    x = "RMSE (basis points)", y = "Frequência"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("data/curva_juros/diag_rmse_hist.png", p_rmse_hist, width = 8, height = 5, dpi = 150)

# --- 4.4 N° de observações vs RMSE ---
p_nobs_rmse <- ggplot(diagnostics, aes(x = n_obs, y = rmse * 10000)) +
  geom_point(alpha = 0.15, color = "steelblue", size = 0.8) +
  geom_smooth(method = "loess", color = "darkred", se = TRUE) +
  labs(
    title = "Número de Contratos vs RMSE",
    subtitle = "Mais contratos tendem a melhorar o ajuste?",
    x = "N de contratos DI no dia", y = "RMSE (basis points)"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("data/curva_juros/diag_nobs_rmse.png", p_nobs_rmse, width = 8, height = 5, dpi = 150)

# --- 4.5 Parâmetros ao longo do tempo ---
params_long <- diagnostics %>%
  select(ref_date, beta0, beta1, tau1, tau2) %>%
  pivot_longer(cols = -ref_date, names_to = "param", values_to = "value")

p_params <- ggplot(params_long, aes(x = ref_date, y = value)) +
  geom_line(alpha = 0.5, color = "steelblue") +
  facet_wrap(~param, scales = "free_y", ncol = 2) +
  labs(
    title = "Evolução dos Parâmetros Svensson",
    x = "Data", y = "Valor"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("data/curva_juros/diag_params.png", p_params, width = 12, height = 8, dpi = 150)

# --- 4.6 Datas com pior ajuste ---
cat("\n=== TOP 10 PIORES AJUSTES ===\n")
worst <- diagnostics %>%
  arrange(desc(rmse)) %>%
  head(10) %>%
  select(ref_date, n_obs, rmse, r_squared, max_resid, convergence) %>%
  mutate(
    rmse_bps = round(rmse * 10000, 2),
    max_resid_bps = round(max_resid * 10000, 2),
    r_squared = round(r_squared, 4)
  ) %>%
  select(ref_date, n_obs, rmse_bps, r_squared, max_resid_bps, convergence)

print(as.data.frame(worst), row.names = FALSE)


# =============================================================================
# 5. CONCLUSÃO
# =============================================================================

cat("\n")
cat("==============================================================\n")
cat("  AVALIAÇÃO PARA USO ACADÊMICO (critérios conservadores)\n")
cat("==============================================================\n")

med_rmse <- median(rmse_bps, na.rm = TRUE)
med_r2 <- median(diagnostics$r_squared, na.rm = TRUE)
p95_rmse <- quantile(rmse_bps, 0.95, na.rm = TRUE)
p5_r2 <- quantile(diagnostics$r_squared, 0.05, na.rm = TRUE)

# Critérios conservadores para uso acadêmico
criterios <- list(
  conv_rate = 100 * conv_ok / nrow(diagnostics),
  med_rmse = med_rmse,
  p95_rmse = p95_rmse,
  med_r2 = med_r2,
  p5_r2 = p5_r2,
  pct_r99 = mean(diagnostics$r_squared > 0.99, na.rm = TRUE) * 100,
  pct_rmse10 = mean(rmse_bps < 10, na.rm = TRUE) * 100
)

# Checklist conservador
checks <- c(
  criterios$conv_rate >= 99,           # Convergência
  criterios$med_rmse < 10,             # RMSE mediano
  criterios$p95_rmse < 30,             # RMSE P95
  criterios$med_r2 > 0.99,             # R² mediano
  criterios$p5_r2 > 0.95,              # R² no P5
  criterios$pct_r99 > 60,              # % dias com R²>0.99
  criterios$pct_rmse10 > 70            # % dias com RMSE<10bps
)

cat(sprintf("\n  Checklist (7 critérios conservadores):\n"))
cat(sprintf("    [%s] Conv. >= 99%%:          %.1f%%\n", 
    ifelse(checks[1], "✓", "✗"), criterios$conv_rate))
cat(sprintf("    [%s] RMSE med. < 10 bps:    %.1f bps\n", 
    ifelse(checks[2], "✓", "✗"), criterios$med_rmse))
cat(sprintf("    [%s] RMSE P95 < 30 bps:     %.1f bps\n", 
    ifelse(checks[3], "✓", "✗"), criterios$p95_rmse))
cat(sprintf("    [%s] R² med. > 0.99:        %.4f\n", 
    ifelse(checks[4], "✓", "✗"), criterios$med_r2))
cat(sprintf("    [%s] R² P5 > 0.95:          %.4f\n", 
    ifelse(checks[5], "✓", "✗"), criterios$p5_r2))
cat(sprintf("    [%s] R²>0.99 em >60%% dias: %.1f%%\n", 
    ifelse(checks[6], "✓", "✗"), criterios$pct_r99))
cat(sprintf("    [%s] RMSE<10 em >70%% dias: %.1f%%\n", 
    ifelse(checks[7], "✓", "✗"), criterios$pct_rmse10))

cat(sprintf("\n  Score: %d / 7 critérios atendidos\n", sum(checks)))

if (sum(checks) == 7) {
  cat("\n  CONCLUSÃO: MODELO ROBUSTO para uso em artigo acadêmico.\n")
  cat("  Qualidade de ajuste comparável à literatura internacional.\n")
} else if (sum(checks) >= 5) {
  cat("\n  CONCLUSÃO: MODELO ACEITÁVEL com ressalvas.\n")
  cat("  Recomenda-se discutir limitações no paper.\n")
} else {
  cat("\n  CONCLUSÃO: MODELO NÃO RECOMENDADO para publicação.\n")
  cat("  Ajuste insuficiente para padrões acadêmicos.\n")
}

cat("\n  Benchmark literatura:\n")
cat("    - Diebold-Li (2006): R² ~ 0.96-0.99 para US Treasuries\n")
cat("    - Svensson (1994): RMSE < 5 bps para Swedish gov bonds\n")
cat("    - Anbima/BCB: RMSE < 10 bps para DI futuro (aceitável)\n")
cat("==============================================================\n")

cat("\nGráficos salvos em data/curva_juros/diag_*.png\n")
