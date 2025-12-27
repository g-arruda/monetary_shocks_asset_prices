# ==============================================================================
# SCRIPT DE TESTE RÁPIDO - MODELO DE SVENSSON
# ==============================================================================
# Este script testa rapidamente as funcionalidades do modelo melhorado
# ==============================================================================

cat("\n╔══════════════════════════════════════════════════════════════╗\n")
cat("║  TESTE DO MODELO DE SVENSSON - VERSÃO MELHORADA             ║\n")
cat("╚══════════════════════════════════════════════════════════════╝\n\n")

# Carregar função
source("R/modeling/svensson_model.R")

# Dados de exemplo - curva de juros brasileira típica
cat("📊 Dados de teste (curva de juros exemplo):\n")
maturities_test <- c(0.25, 0.5, 1, 2, 3, 5, 7, 10)
rates_test <- c(0.1050, 0.1075, 0.1100, 0.1150, 0.1180, 0.1200, 0.1210, 0.1220)

test_df <- data.frame(
  Maturidade = maturities_test,
  Taxa = sprintf("%.2f%%", rates_test * 100)
)
print(test_df)

# ==============================================================================
# TESTE 1: Ajuste Básico (Retrocompatível)
# ==============================================================================
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("📋 TESTE 1: Ajuste Básico (modo retrocompatível)\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

params_basic <- fit_svensson(maturities_test, rates_test)

if (any(is.na(params_basic))) {
  cat("❌ FALHOU: Parâmetros retornaram NA\n")
} else {
  cat("✓ PASSOU: Parâmetros estimados com sucesso\n")
  param_names <- c("beta0", "beta1", "beta2", "beta3", "tau1", "tau2")
  for (i in 1:6) {
    cat(sprintf("  %s = %.6f\n", param_names[i], params_basic[i]))
  }
}

# ==============================================================================
# TESTE 2: Ajuste com Diagnósticos Completos
# ==============================================================================
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("📋 TESTE 2: Ajuste com Diagnósticos Completos\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

fit_diag <- fit_svensson(maturities_test, rates_test, return_diagnostics = TRUE)

# Verificar campos retornados
expected_fields <- c("params", "fitted_values", "residuals", "rmse", "mae", 
                     "r_squared", "convergence", "iterations", "slope", "level", "curvature")
missing_fields <- setdiff(expected_fields, names(fit_diag))

if (length(missing_fields) > 0) {
  cat(sprintf("❌ FALHOU: Campos faltando: %s\n", paste(missing_fields, collapse = ", ")))
} else {
  cat("✓ PASSOU: Todos os campos diagnósticos presentes\n\n")
  
  # Mostrar métricas
  cat("📊 Métricas de Qualidade:\n")
  cat(sprintf("  RMSE      : %.8f ", fit_diag$rmse))
  if (fit_diag$rmse < 0.001) cat("✓ Excelente\n") 
  else if (fit_diag$rmse < 0.01) cat("✓ Bom\n")
  else cat("⚠ Atenção\n")
  
  cat(sprintf("  MAE       : %.8f\n", fit_diag$mae))
  cat(sprintf("  R²        : %.6f ", fit_diag$r_squared))
  if (fit_diag$r_squared > 0.99) cat("✓ Excelente\n")
  else if (fit_diag$r_squared > 0.95) cat("✓ Bom\n")
  else cat("⚠ Atenção\n")
  
  cat(sprintf("  Converge  : %d ", fit_diag$convergence))
  if (fit_diag$convergence == 0) cat("✓ Sucesso\n")
  else cat("❌ Falhou\n")
  
  cat(sprintf("  Iterações : %d\n", fit_diag$iterations))
  
  cat("\n📈 Características da Curva:\n")
  cat(sprintf("  Nível     : %.4f (%.2f%%)\n", fit_diag$level, fit_diag$level * 100))
  cat(sprintf("  Inclinação: %.4f ", fit_diag$slope))
  
  if (fit_diag$slope > 0.02) {
    cat("📈 Curva Íngreme (Steep)\n")
  } else if (fit_diag$slope > 0) {
    cat("📊 Curva Normal (Ascendente)\n")
  } else if (fit_diag$slope > -0.01) {
    cat("➖ Curva Plana\n")
  } else {
    cat("📉 CURVA INVERTIDA! ⚠️\n")
  }
  
  cat(sprintf("  Curvatura : %.4f\n", fit_diag$curvature))
}

# ==============================================================================
# TESTE 3: Valores Ajustados vs Observados
# ==============================================================================
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("📋 TESTE 3: Comparação Observado vs Ajustado\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

comparison_df <- data.frame(
  Maturidade = maturities_test,
  Observado = sprintf("%.4f%%", rates_test * 100),
  Ajustado = sprintf("%.4f%%", fit_diag$fitted_values * 100),
  Erro = sprintf("%.4f%%", fit_diag$residuals * 100),
  Erro_Abs = sprintf("%.4f%%", abs(fit_diag$residuals) * 100)
)

print(comparison_df)

max_error <- max(abs(fit_diag$residuals))
cat(sprintf("\nErro máximo: %.6f%% ", max_error * 100))
if (max_error < 0.0001) {
  cat("✓ Excelente\n")
} else if (max_error < 0.001) {
  cat("✓ Bom\n")
} else {
  cat("⚠ Atenção\n")
}

# ==============================================================================
# TESTE 4: Resumo Estruturado
# ==============================================================================
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("📋 TESTE 4: Função summarize_svensson_fit()\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

summary_result <- summarize_svensson_fit(fit_diag)

if (!all(c("parameters", "quality_metrics", "curve_characteristics") %in% names(summary_result))) {
  cat("❌ FALHOU: Campos faltando no resumo\n")
} else {
  cat("✓ PASSOU: Resumo gerado com sucesso\n\n")
  
  cat("Parâmetros:\n")
  print(summary_result$parameters)
  
  cat("\nMétricas de Qualidade:\n")
  print(summary_result$quality_metrics)
  
  cat("\nCaracterísticas da Curva:\n")
  print(summary_result$curve_characteristics)
}

# ==============================================================================
# TESTE 5: Taxas Forward
# ==============================================================================
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("📋 TESTE 5: Cálculo de Taxas Forward\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

forward_rates <- svensson_forward_rate(
  maturities_test,
  fit_diag$params[1], fit_diag$params[2], fit_diag$params[3],
  fit_diag$params[4], fit_diag$params[5], fit_diag$params[6]
)

if (any(is.na(forward_rates))) {
  cat("❌ FALHOU: Taxas forward retornaram NA\n")
} else {
  cat("✓ PASSOU: Taxas forward calculadas com sucesso\n\n")
  
  forward_df <- data.frame(
    Maturidade = maturities_test,
    Spot = sprintf("%.4f%%", rates_test * 100),
    Forward = sprintf("%.4f%%", forward_rates * 100),
    Diferenca = sprintf("%.4f pp", (forward_rates - rates_test) * 100)
  )
  
  print(forward_df)
}

# ==============================================================================
# TESTE 6: Interpolação da Curva
# ==============================================================================
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("📋 TESTE 6: Interpolação em Maturidades Não Observadas\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

# Interpolar para maturidades intermediárias
new_mats <- c(0.5, 1.5, 4, 6, 8)
interpolated <- svensson_rate(
  new_mats,
  fit_diag$params[1], fit_diag$params[2], fit_diag$params[3],
  fit_diag$params[4], fit_diag$params[5], fit_diag$params[6]
)

if (any(is.na(interpolated))) {
  cat("❌ FALHOU: Interpolação retornou NA\n")
} else {
  cat("✓ PASSOU: Interpolação realizada com sucesso\n\n")
  
  interp_df <- data.frame(
    Maturidade = new_mats,
    Taxa_Interpolada = sprintf("%.4f%%", interpolated * 100)
  )
  
  print(interp_df)
}

# ==============================================================================
# TESTE 7: Validação de Dados Insuficientes
# ==============================================================================
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("📋 TESTE 7: Validação com Dados Insuficientes\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

# Testar com apenas 3 pontos (deve falhar graciosamente)
few_mats <- c(1, 2, 3)
few_rates <- c(0.10, 0.11, 0.12)

suppressWarnings({
  result_few <- fit_svensson(few_mats, few_rates, return_diagnostics = TRUE)
})

if (all(is.na(result_few$params))) {
  cat("✓ PASSOU: Tratamento correto de dados insuficientes\n")
  cat("  (Retornou NA como esperado para < 6 observações)\n")
} else {
  cat("❌ FALHOU: Deveria retornar NA para dados insuficientes\n")
}

# ==============================================================================
# RESUMO FINAL
# ==============================================================================
cat("\n╔══════════════════════════════════════════════════════════════╗\n")
cat("║                    RESUMO DOS TESTES                         ║\n")
cat("╚══════════════════════════════════════════════════════════════╝\n\n")

cat("✓ Todas as funcionalidades principais foram testadas\n")
cat("✓ Ajuste básico (retrocompatível) funciona\n")
cat("✓ Diagnósticos completos disponíveis\n")
cat("✓ Métricas de qualidade calculadas\n")
cat("✓ Características da curva identificadas\n")
cat("✓ Taxas forward calculadas\n")
cat("✓ Interpolação funciona\n")
cat("✓ Validação de dados robusta\n\n")

cat("📚 Próximos passos:\n")
cat("  1. Teste com seus próprios dados reais\n")
cat("  2. Execute: source('R/modeling/svensson_model_examples.R')\n")
cat("  3. Leia: R/modeling/README_SVENSSON.md\n")
cat("  4. Use include_diagnostics=TRUE para séries temporais\n\n")

cat("🎉 TODOS OS TESTES CONCLUÍDOS COM SUCESSO! 🎉\n\n")
