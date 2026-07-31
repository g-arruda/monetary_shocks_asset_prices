# ===================================================================
# TAREFA 4 — Inferencia robusta a instrumento fraco
#
# Escopo desta rodada (decisao do autor, 2026-07-28): documentar o que a
# estatistica de forca E, onde ela cai, e o que ela permite afirmar. A
# INVERSAO Anderson-Rubin fica para rodada separada — sem ela a pergunta
# "o conjunto AR cobre zero em h=0-4?" nao tem resposta, e o script diz isso
# explicitamente em vez de improvisar substituto.
#
# Saida: diagnostics/output/t4_*.csv
# ===================================================================

source("diagnostics/_common.R")

cat("\n=== TAREFA 4 — forca do instrumento ===\n")


# ===================================================================
# 4.1 — Que estatistica e essa, exatamente
# ===================================================================
cat("\n[4.1] identificacao da estatistica\n")

t41 <- data.frame(
  regua = c("xi_mp", "wald_joint", "xi_k (min/max)", "f_factor", "f_reduced"),
  formula = c("T * (c'Gamma)^2 / (c'Wc), c = direcao de impacto de yield_6m",
              "T * Gamma' W^-1 Gamma  ~  chi2_q",
              "T * Gamma_k^2 / W_kk, por fator",
              "max_k F da regressao univariada eta_k ~ z (homocedastica)",
              "F parcial de z contra a inovacao AR(6) de yield_6m"),
  fonte = c("Montiel Olea-Stock-Watson (2021), sec. 4.2 — analogo exato do `Waldstat` oficial",
            "MSWfunction.m:389 (`WaldstatFull`)",
            "MOSW (2021), sec. 4.2",
            "regua LEGADA do projeto, nao e MOSW",
            "regua LEGADA de forma reduzida, nao e MOSW"),
  onde_no_codigo = c("impulse_responde.R:199-249 via diagnose_instrument_in_factor_space",
                     "impulse_responde.R:233-235",
                     "impulse_responde.R:232",
                     "impulse_responde.R:145-155",
                     "spec_sweep.R:142-145"),
  e_um_F_de_1o_estagio = c("NAO", "NAO", "NAO", "sim (mas homocedastico)", "sim"),
  stringsAsFactors = FALSE
)
print(as.data.frame(t41 |> select(regua, e_um_F_de_1o_estagio, onde_no_codigo)),
      row.names = FALSE)
diag_write(t41, "t4_1_reguas.csv")

cat("\n  W = Eicker-White da matriz de momentos z_t*eta_t, com a correcao Shat\n")
cat("  (z residualizado nos regressores do VAR de fatores). nw_lags = 0 por\n")
cat("  default — validado contra NW_hac_STATA.m em script/validate_hac_kernel.R.\n")
cat("  O bloco inteiro foi validado ponta a ponta contra os numeros publicados\n")
cat("  do petroleo de Kilian em script/validate_olea_kilian.R.\n")


# ===================================================================
# 4.2 — Onde o valor cai
# ===================================================================
cat("\n[4.2] valor observado contra os limiares que existem\n")

z_df <- inst_df(SPEC$instrument)
windows <- list(full = SPEC$window,
                # mesma janela de mosw_strength_grid.R:37 e irf_spec_sweep.R:43
                pre_covid = as.Date(c("2013-01-01", "2019-12-31")))

t42 <- lapply(names(windows), function(w) {
  win <- windows[[w]]
  k   <- DATES >= win[1] & DATES <= win[2]
  d   <- estimate_dfm(PANEL[k, , drop = FALSE], SPEC$r, SPEC$q, SPEC$p,
                      dates = DATES[k], instrument = z_df, apply_kilian = FALSE)
  fs  <- diagnose_instrument_in_factor_space(d, z_df, DATES[k], SPEC$p,
                                             match(SPEC$mp_var, VAR_NAMES))
  data.frame(janela = w, n_obs = fs$n_obs, xi_mp = fs$wald_mp,
             wald_joint = fs$wald_joint, F_joint = fs$wald_joint / SPEC$q,
             xi_min = fs$wald_min, f_factor_legado = fs$f_factor,
             AR_limitado = fs$wald_mp > 3.84,
             bandas_convencionais = fs$wald_mp >= 10)
}) |> bind_rows()
print(as.data.frame(t42), row.names = FALSE, digits = 4)
diag_write(t42, "t4_2_valores.csv")

t42b <- data.frame(
  limiar = c("xi_mp > 3.84", "xi_mp >= 10"),
  origem = c("qchisq(0.95, 1) — MOSW: o conjunto AR de 95% e um INTERVALO LIMITADO",
             "convencao Staiger-Stock / Stock-Yogo herdada, NAO tabelada por MOSW"),
  producao_full = c(t42$xi_mp[t42$janela == "full"] > 3.84,
                    t42$xi_mp[t42$janela == "full"] >= 10),
  producao_pre = c(t42$xi_mp[t42$janela == "pre_covid"] > 3.84,
                   t42$xi_mp[t42$janela == "pre_covid"] >= 10),
  stringsAsFactors = FALSE
)
print(as.data.frame(t42b), row.names = FALSE)
diag_write(t42b, "t4_2b_limiares.csv")

cat("\n  IMPORTANTE — o item 4.2 do prompt pede 'os valores criticos apropriados de\n")
cat("  MOSW para distorcao de cobertura de 10%, 15% e 20%'. Essa tabela NAO EXISTE:\n")
cat("  o objeto tabelado nesses termos e o F efetivo de Montiel Olea-Pflueger, que e\n")
cat("  outro estimador. MOSW (2021) fornecem DOIS limiares, os da tabela acima. O\n")
cat("  item foi respondido com o que existe e a lacuna esta declarada.\n")


# ===================================================================
# 4.3 — Robustez ja medida (leave-one-month-out + HAC)
# ===================================================================
cat("\n[4.3] robustez do proprio xi_mp (rodado em 2026-07-27)\n")

rob_path <- "output/instrument/xi_mp_robustness.csv"
if (file.exists(rob_path)) {
  rob <- read_csv(rob_path, show_col_types = FALSE)
  cat("  colunas:", paste(names(rob), collapse = ", "), "\n")
  loo <- rob |> filter(if ("tipo" %in% names(rob)) tipo == "loo" else TRUE)
  print(utils::head(as.data.frame(rob), 8), row.names = FALSE, digits = 4)
} else {
  cat("  ARQUIVO AUSENTE — nao reproduzido nesta rodada.\n")
}

t43 <- data.frame(
  fato = c("leave-one-month-out, full: min xi_mp",
           "leave-one-month-out, full: meses que derrubam abaixo de 3.84",
           "leave-one-month-out, full: meses que derrubam abaixo de 10",
           "leave-one-month-out, pre-COVID: meses abaixo de 10",
           "HAC: xi_mp em NW(6), full"),
  valor = c("8.43", "0 de 147", "24 de 147", "4 de 78", "15.64 (crescente em NW)"),
  consequencia = c("conjunto AR limitado em toda a vizinhanca amostral",
                   "a afirmacao 'AR e limitado' e ROBUSTA",
                   "a afirmacao 'bandas convencionais valem' e MARGINAL",
                   "pre-COVID e materialmente mais forte",
                   "NW(0) e a escolha conservadora, nao a conveniente"),
  stringsAsFactors = FALSE
)
print(as.data.frame(t43), row.names = FALSE)
diag_write(t43, "t4_3_robustez.csv")


# ===================================================================
# 4.4 — O que NAO foi respondido
# ===================================================================
cat("\n[4.4] lacuna declarada\n")

t44 <- data.frame(
  pergunta = "O conjunto AR cobre zero em h=0-4 para cambio_usd, embi_perc, cds_5y, price_ipp, ...?",
  status = "NAO RESPONDIDA — exige inverter o teste AR, nunca implementado neste repo",
  por_que_importa = paste("xi_mp = 10.43 raspa o limiar; 24 de 147 meses o derrubam",
                          "abaixo de 10. As bandas percentil do wild bootstrap nao sao",
                          "validas nessa margem, e toda a cadeia cambio->risco->precos",
                          "depende de 4-6 horizontes significativos a 90%."),
  alvo_de_traducao = paste("codigo_olea/functions/StructuralIRF/ARTestStatistic.m;",
                           "codigo_olea/functions/Inference/GasydistbootsAR.m;",
                           "codigo_olea/functions/Inference/MSWfunction.m"),
  adaptacao_necessaria = paste("a IRF aqui e Lambda*B*K*M*H, razao da mesma forma",
                               "(linear em Gamma sobre c'Gamma), entao a logica de",
                               "Fieller carrega — mas exige a adaptacao 'identifica nas",
                               "q inovacoes e propaga por Lambda'."),
  stringsAsFactors = FALSE
)
cat("  ", t44$status, "\n")
diag_write(t44, "t4_4_lacuna_AR.csv")

cat("\n=== TAREFA 4 concluida ===\n")
