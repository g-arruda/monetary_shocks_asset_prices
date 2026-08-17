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
  regua = c("xi_mp", "f_robust_mp"),
  formula = c("T * (c'Gamma)^2 / (c'Wc), c = direcao de impacto de yield_6m",
              "t_HC1^2 de z na regressao c'eta ~ z + defasagens dos fatores"),
  fonte = c("Montiel Olea-Stock-Watson (2021), sec. 4.2 — analogo exato do `Waldstat` oficial",
            "Montiel Olea-Stock-Watson (2021), sec. 4.2 — F robusto do primeiro estagio"),
  onde_no_codigo = c("compute_factor_space_wald via diagnose_instrument_in_factor_space",
                     "compute_robust_first_stage_F via diagnose_instrument_in_factor_space"),
  e_um_F_de_1o_estagio = c("NAO", "SIM"),
  stringsAsFactors = FALSE
)
print(as.data.frame(t41 |> dplyr::select(regua, e_um_F_de_1o_estagio, onde_no_codigo)),
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
windows <- list(full = SPEC$window, pre_covid = SPEC$pre_covid_sample)

t42 <- lapply(names(windows), function(w) {
  win <- windows[[w]]
  k   <- DATES >= win[1] & DATES <= win[2]
  d   <- estimate_dfm(PANEL[k, , drop = FALSE], SPEC$r, SPEC$q, SPEC$p,
                      dates = DATES[k], instrument = z_df, apply_kilian = FALSE)
  fs  <- diagnose_instrument_in_factor_space(d, z_df, DATES[k], SPEC$p,
                                             match(SPEC$mp_var, VAR_NAMES))
  data.frame(janela = w, n_obs = fs$n_obs, xi_mp = fs$wald_mp,
             f_robust_mp = fs$f_robust_mp,
             AR_limitado = fs$wald_mp > 3.84,
             xi_mp_ge10 = fs$wald_mp >= 10,
             f_robust_mp_ge10 = fs$f_robust_mp >= 10)
}) |> dplyr::bind_rows()
print(as.data.frame(t42), row.names = FALSE, digits = 4)
diag_write(t42, "t4_2_valores.csv")

t42b <- data.frame(
  limiar = c("xi_mp > 3.84", "xi_mp >= 10", "f_robust_mp >= 10"),
  origem = c("qchisq(0.95, 1) — MOSW: o conjunto AR de 95% e um INTERVALO LIMITADO",
             "referencia convencional, NAO tabelada por MOSW",
             "referencia convencional, NAO tabelada por MOSW"),
  producao_full = c(t42$xi_mp[t42$janela == "full"] > 3.84,
                    t42$xi_mp[t42$janela == "full"] >= 10,
                    t42$f_robust_mp[t42$janela == "full"] >= 10),
  producao_pre = c(t42$xi_mp[t42$janela == "pre_covid"] > 3.84,
                   t42$xi_mp[t42$janela == "pre_covid"] >= 10,
                   t42$f_robust_mp[t42$janela == "pre_covid"] >= 10),
  stringsAsFactors = FALSE
)
print(as.data.frame(t42b), row.names = FALSE)
diag_write(t42b, "t4_2b_limiares.csv")

cat("\n  IMPORTANTE — o item 4.2 do prompt pede 'os valores criticos apropriados de\n")
cat("  MOSW para distorcao de cobertura de 10%, 15% e 20%'. Essa tabela NAO EXISTE:\n")
cat("  o objeto tabelado nesses termos e o F efetivo de Montiel Olea-Pflueger, que e\n")
cat("  outro estimador. A tabela separa o resultado formal sobre xi_mp da referencia\n")
cat("  convencional de 10, que nao e um valor critico fornecido por MOSW.\n")


# ===================================================================
# 4.3 — Robustez ja medida (leave-one-month-out + HAC)
# ===================================================================
cat("\n[4.3] robustez do proprio xi_mp\n")

rob_path <- "output/instrument/xi_mp_robustness.csv"
if (file.exists(rob_path)) {
  rob <- readr::read_csv(rob_path, show_col_types = FALSE)
  cat("  colunas:", paste(names(rob), collapse = ", "), "\n")
  loo <- rob |>
    dplyr::filter(exercise == "loo", instrument == SPEC$instrument)
  hac <- rob |>
    dplyr::filter(exercise == "hac", instrument == SPEC$instrument)
  print(utils::head(as.data.frame(rob), 8), row.names = FALSE, digits = 4)
} else {
  stop("Missing required robustness artifact: ", rob_path)
}

loo_full <- loo |> dplyr::filter(sample == "full")
loo_pre <- loo |> dplyr::filter(sample == "pre_covid")
hac_full_nw6 <- hac |>
  dplyr::filter(sample == "full", key == "6") |>
  dplyr::pull(wald_mp)

stopifnot(nrow(loo_full) == t42$n_obs[t42$janela == "full"],
          nrow(loo_pre) == t42$n_obs[t42$janela == "pre_covid"],
          length(hac_full_nw6) == 1L)

t43 <- data.frame(
  fato = c("leave-one-month-out, full: min xi_mp",
           "leave-one-month-out, full: meses que derrubam abaixo de 3.84",
           "leave-one-month-out, full: meses que derrubam abaixo de 10",
           "leave-one-month-out, pre-COVID: meses abaixo de 10",
           "HAC: xi_mp em NW(6), full"),
  valor = c(
    sprintf("%.2f", min(loo_full$wald_mp)),
    sprintf("%d de %d", sum(loo_full$wald_mp < 3.84), nrow(loo_full)),
    sprintf("%d de %d", sum(loo_full$wald_mp < 10), nrow(loo_full)),
    sprintf("%d de %d", sum(loo_pre$wald_mp < 10), nrow(loo_pre)),
    sprintf("%.2f", hac_full_nw6)
  ),
  consequencia = c("conjunto AR limitado em toda a vizinhanca amostral",
                   "a afirmacao 'AR e limitado' e ROBUSTA",
                   "o limiar convencional nao vale na amostra cheia",
                   "pre-COVID e materialmente mais forte",
                   "a correcao HAC eleva xi_mp, mas nao o leva a 10"),
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
  por_que_importa = sprintf(
    paste("xi_mp = %.2f fica abaixo de 10 na amostra cheia; %d de %d exclusoes",
          "leave-one-month-out permanecem abaixo de 10. As bandas percentil do wild",
          "bootstrap sao a inferencia operacional, mas a fragilidade de relevancia",
          "precisa ser declarada na leitura dos resultados."),
    t42$xi_mp[t42$janela == "full"],
    sum(loo_full$wald_mp < 10),
    nrow(loo_full)
  ),
  alvo_de_traducao = paste("codigos_externos/codigo_olea/functions/StructuralIRF/ARTestStatistic.m;",
                           "codigos_externos/codigo_olea/functions/Inference/GasydistbootsAR.m;",
                           "codigos_externos/codigo_olea/functions/Inference/MSWfunction.m"),
  adaptacao_necessaria = paste("a IRF aqui e Lambda*B*K*M*H, razao da mesma forma",
                               "(linear em Gamma sobre c'Gamma), entao a logica de",
                               "Fieller carrega — mas exige a adaptacao 'identifica nas",
                               "q inovacoes e propaga por Lambda'."),
  stringsAsFactors = FALSE
)
cat("  ", t44$status, "\n")
diag_write(t44, "t4_4_lacuna_AR.csv")

cat("\n=== TAREFA 4 concluida ===\n")
