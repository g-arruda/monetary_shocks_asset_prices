# ===================================================================
# Bandas Anderson-Rubin (Montiel Olea-Stock-Watson 2021) para o DFM-IV
#
# A pergunta, do council review de 2026-07-31 e repetida em 2026-08-10:
# xi_mp = 10,43 raspa o limiar em que as bandas convencionais são só
# "aproximadamente válidas", e o leave-one-month-out mostra 24 de 147
# meses que, removidos um a um, derrubam xi_mp abaixo de 10. Publicar
# apenas Wald nessa margem é o que um parecerista pergunta primeiro.
#
# O que torna a inversão vantajosa aqui: nenhum dos 147 descartes derruba
# xi_mp abaixo de 3,84, então o conjunto AR é limitado em toda a
# vizinhança amostral — a inversão entrega um intervalo, não uma reta.
#
# O QUE JÁ EXISTIA. O projeto calculava xi_mp — a estatística que decide
# se o conjunto é limitado — desde 2026-07-26, mas nunca inverteu o AR.
# A tradução do método está em R/identification/weak_iv_ar.R e é validada
# contra o código oficial dos autores em script/validate_mosw_ar.R.
#
# REGRA DE LEITURA, FIXADA ANTES DOS NÚMEROS. O veredito não é "as bandas
# AR são mais largas ou mais estreitas". É quantas afirmações do §4
# sobrevivem à régua robusta a IV fraco. Vale o protocolo anti-screening
# de MOSW (nota 6): reportar xi, nunca filtrar pelo F.
#
# TRÊS RÉGUAS, E ELAS NÃO MEDEM A MESMA COISA:
#   AR          — robusta a IV fraco, assintótica, condiciona no espaço
#                 de fatores estimado (Lambda, K, M, sy entram como
#                 conhecidos);
#   delta       — Wald assintótica, mesma derivada, mesmo condicionamento;
#   bootstrap   — wild bootstrap do projeto, reestima o DFM por réplica.
# AR contra delta isola "robusto a IV fraco vs. Wald"; delta contra
# bootstrap isola "assintótico vs. reamostragem, com e sem incerteza de
# Lambda". Comparar AR direto com bootstrap mistura as duas coisas.
#
# Nada em produção é reestimado ou modificado. O DFM é reestimado aqui
# (barato, sem bootstrap) porque output/irf/irf_coherence_cell.rds guarda
# o objeto de IRF, não o DFM.
#
# Saídas: output/irf/ar_bands.csv
#         output/irf/ar_bands_summary.csv
#         output/irf/ar_bands.md          (corpo gerado, reescrito a cada run)
#         output/irf/ar_bands_overlay.pdf
# ===================================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readr)
  library(ggplot2)
  library(patchwork)
})

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")
source("R/identification/weak_iv_ar.R")


# ---- Config: spec de produção (script/irf_coherence_check.R) -------

R_FACTORS  <- 7L
Q_DYNAMIC  <- 6L
P_LAGS     <- 6L
INSTRUMENT <- "z_jk_bs_purif"
MP_VAR     <- "yield_6m"
HORIZON    <- 48L
SHOCK_BPS  <- 50
NW_LAGS    <- 0L
LEVELS     <- c(0.68, 0.90, 0.95)

WINDOWS <- list(
  full      = as.Date(c("2013-01-01", "2025-12-31")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-31"))
)

# Alvos publicados, para os auto-testes (output/instrument/mosw_strength_grid.csv)
XI_MP_TARGET <- c(full = 10.430830652608897, pre_covid = 12.223433503146001)

DATA_PATH <- "data/processed/data_log_deseasonalized.csv"
INST_PATH <- "data/processed/instrumentos_mensais.csv"
COH_PATH  <- "output/irf/irf_coherence_h.csv"
OUT_DIR   <- "output/irf"

HEADLINE <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd",
              "embi_perc", "cds_5y", "asset_ibov", "price_ipca")


# ---- Dados ---------------------------------------------------------

raw_data <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> select(-ref.date) |> as.matrix()
var_names <- colnames(data_mat)
tcode    <- infer_tcode_from_varnames(var_names)
mpind    <- match(MP_VAR, var_names)
norm_val <- norm_value_for(MP_VAR, SHOCK_BPS)

stopifnot(!is.na(mpind), all(tcode %in% c(1L, 2L, 4L)))

inst_panel <- read_csv(INST_PATH, show_col_types = FALSE)
inst_df <- data.frame(month = as.Date(inst_panel$month),
                      shock = inst_panel[[INSTRUMENT]])
inst_df <- inst_df[!is.na(inst_df$shock), ]

cat(sprintf("Painel %d x %d, instrumento %s, spec (r=%d, q=%d, p=%d)\n",
            nrow(data_mat), ncol(data_mat), INSTRUMENT,
            R_FACTORS, Q_DYNAMIC, P_LAGS))


# ---- Bandas AR por janela ------------------------------------------

rows     <- list()
diag_win <- list()

for (win in names(WINDOWS)) {
  keep      <- dates >= WINDOWS[[win]][1] & dates <= WINDOWS[[win]][2]
  data_sub  <- data_mat[keep, , drop = FALSE]
  dates_sub <- dates[keep]

  dfm <- estimate_dfm(data_sub, r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
                      dates = dates_sub, instrument = inst_df,
                      apply_kilian = FALSE)

  Lambda <- dfm$static_loadings
  K      <- dfm$dynamic_loadings
  M      <- dfm$dynamic_scaling
  sy     <- dfm$data_sd
  u      <- dfm$var_residuals
  F_stat <- dfm$static_factors
  AL     <- dfm$companion_matrix[seq_len(R_FACTORS), , drop = FALSE]

  # Regressores do VAR de fatores, constante PRIMEIRO (ordem de RForm_VAR.m,
  # de que o Shat de CovAhat_Sigmahat_Gamma.m depende).
  T_f  <- nrow(F_stat)
  lags <- do.call(cbind, lapply(seq_len(P_LAGS), function(i)
    F_stat[(P_LAGS + 1 - i):(T_f - i), , drop = FALSE]))
  X_reg <- cbind(1, lags)

  align   <- sel_ext_inst_sample(dates_sub, P_LAGS, inst_df)
  sel     <- align$rsh_sel_ind
  z       <- align$inst_sel
  u_sel   <- u[sel, , drop = FALSE]
  X_sel   <- X_reg[sel, , drop = FALSE]
  T_eff   <- length(z)

  # Load = equação de medida (diag(sy) Lambda); Inner = K K', porque a IRF
  # do projeto é diag(sy) Lambda B_h K M H com H = (M^-1)' K' Gamma_u.
  Load  <- sweep(Lambda, 1, sy, "*")
  Inner <- K %*% t(K)
  Gamma <- drop(crossprod(u_sel, z)) / T_eff

  cv <- mosw_rform_cov(X_sel, z, u_sel, p = P_LAGS, nw_lags = NW_LAGS)
  rd <- mosw_response_derivatives(AL, p = P_LAGS, h = HORIZON,
                                  Load = Load, Inner = Inner, Gamma = Gamma)

  d0    <- rd$C[mpind, , 1]
  xi_mp <- T_eff * sum(d0 * Gamma)^2 / drop(t(d0) %*% cv$W2 %*% d0)

  # Réguas do projeto, recalculadas ao vivo para comparação (espaço eta, q = 6)
  diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates_sub,
                                                 P_LAGS, mpind, nw_lags = NW_LAGS)
  Minv  <- solve(M)
  W_eta <- Minv %*% t(K) %*% cv$W2 %*% K %*% Minv
  G_eta <- drop(Minv %*% t(K) %*% Gamma)
  wald_k_ours <- T_eff * G_eta^2 / diag(W_eta)

  diag_win[[win]] <- list(T_eff = T_eff, xi_mp = xi_mp,
                          xi_mp_live = diag_fs$wald_mp,
                          dev_wald_k = max(abs(wald_k_ours - diag_fs$wald_k)),
                          n_par = ncol(cv$WHat))

  cat(sprintf("  %-9s T = %3d   xi_mp = %8.4f (alvo %.4f)   W: %d x %d\n",
              win, T_eff, xi_mp, XI_MP_TARGET[[win]],
              ncol(cv$WHat), ncol(cv$WHat)))

  for (lvl in LEVELS) {
    nc <- mosw_ar_bounds(rd$C,    rd$D1,    Gamma, cv, mpind, norm_val, lvl)
    cu <- mosw_ar_bounds(rd$Ccum, rd$D1cum, Gamma, cv, mpind, norm_val, lvl)

    # tcode: mesmo mapa monótono de cumimp_transform, aplicado aos limites.
    # tcode 2 exige o RAMO cumulativo — acumular os limites de um AR
    # não-cumulativo seria erro, e é para isso que MOSW carregam Ccum/Gcum.
    pick <- function(field) {
      out <- nc[[field]]
      out[tcode == 2L, ] <- cu[[field]][tcode == 2L, , drop = FALSE] * 100
      out[tcode == 4L, ] <- (exp(nc[[field]][tcode == 4L, , drop = FALSE]) - 1) * 100
      out
    }

    rows[[length(rows) + 1]] <- tibble::tibble(
      sample = win,
      level  = lvl,
      var    = rep(var_names, times = HORIZON + 1),
      h      = rep(0:HORIZON, each = length(var_names)),
      tcode  = rep(tcode, times = HORIZON + 1),
      point  = as.vector(pick("point")),
      ar_lo  = as.vector(pick("lo")),
      ar_hi  = as.vector(pick("hi")),
      ar_case = as.vector(ifelse(tcode == 2L, cu$case, nc$case)),
      dm_lo  = as.vector(pick("dm_lo")),
      dm_hi  = as.vector(pick("dm_hi")),
      xi_mp  = xi_mp,
      critval = nc$critval
    )
  }
}

ar <- bind_rows(rows)


# ---- Junta as bandas de bootstrap da rodada de produção ------------

coh <- read_csv(COH_PATH, show_col_types = FALSE)

# A rodada de produção é da amostra cheia; `sample` entra na chave para que as
# células pre-COVID não casem com bandas da janela errada.
boot <- bind_rows(
  coh |> transmute(var, h, level = 0.68, boot_lo = lo68, boot_hi = hi68),
  coh |> transmute(var, h, level = 0.90, boot_lo = lo90, boot_hi = hi90)
) |>
  mutate(sample = "full")

ar <- ar |>
  left_join(boot, by = c("sample", "var", "h", "level")) |>
  mutate(ar_width   = ar_hi - ar_lo,
         dm_width   = dm_hi - dm_lo,
         boot_width = boot_hi - boot_lo,
         ar_sig     = ar_lo > 0 | ar_hi < 0,
         dm_sig     = dm_lo > 0 | dm_hi < 0,
         boot_sig   = boot_lo > 0 | boot_hi < 0,
         # Assimetria em torno do ponto: é o conteúdo que uma banda de Wald,
         # simétrica por construção, não consegue mostrar.
         assimetria = (ar_hi - point) / (point - ar_lo))


# ---- Auto-testes ---------------------------------------------------

cat("\nAuto-testes:\n")

# 1. O ponto reproduz a rodada de produção. O desvio é medido em escala
#    relativa por série: as unidades do painel vão de 1e-3 (juros em proporção)
#    a 1e4 (produção de automóveis), e um limite absoluto misturaria as duas.
chk_point <- ar |>
  filter(sample == "full", level == 0.90) |>
  inner_join(coh |> select(var, h, point_prod = point), by = c("var", "h")) |>
  group_by(var) |>
  summarise(rel = max(abs(point - point_prod)) / max(abs(point_prod)),
            .groups = "drop")
dev_point <- max(chk_point$rel)
cat(sprintf("  1. ponto vs irf_coherence_h.csv (%d séries)   : %.3e (relativo)\n",
            nrow(chk_point), dev_point))

# 2. xi_mp reproduz mosw_strength_grid.csv
dev_xi <- max(sapply(names(WINDOWS), function(w)
  abs(diag_win[[w]]$xi_mp - XI_MP_TARGET[[w]])))
cat(sprintf("  2. xi_mp vs mosw_strength_grid.csv           : %.3e\n", dev_xi))

# 3. bloco Gamma: xi_k no espaço eta contra compute_factor_space_wald
dev_wk <- max(sapply(names(WINDOWS), function(w) diag_win[[w]]$dev_wald_k))
cat(sprintf("  3. xi_k vs compute_factor_space_wald (q = %d) : %.3e\n",
            Q_DYNAMIC, dev_wk))

# 4. conjunto limitado <=> xi_mp > critval (o coeficiente de lambda^2 é
#    T*den^2 - critval*d0'W2 d0, que é a Wald na direção do denominador)
bounded <- ar |>
  group_by(sample, level) |>
  summarise(all_case1 = all(ar_case == 1L),
            xi_mp = first(xi_mp), critval = first(critval), .groups = "drop") |>
  mutate(coerente = all_case1 == (xi_mp > critval))
cat(sprintf("  4. caso 1 <=> xi_mp > critval                : %d de %d\n",
            sum(bounded$coerente), nrow(bounded)))

# 5. smoke test de h = 0
smoke_want <- c(yield_6m = 0.005, yield_2y = 0.009164, yield_5y = 0.009274,
                asset_ibov = -1.673, cambio_usd = 0.1498)
smoke_got <- ar |>
  filter(sample == "full", level == 0.90, h == 0, var %in% names(smoke_want)) |>
  select(var, point) |> tibble::deframe()
dev_smoke <- max(abs(smoke_got[names(smoke_want)] - smoke_want))
cat(sprintf("  5. smoke test h = 0 (5 séries)               : %.3e\n", dev_smoke))

# 6. o ponto está dentro do conjunto AR sempre que ele é limitado
n_outside <- ar |>
  filter(ar_case == 1L, point < ar_lo - 1e-9 | point > ar_hi + 1e-9) |> nrow()
cat(sprintf("  6. ponto fora do conjunto AR (caso 1)        : %d\n", n_outside))

stopifnot(dev_point < 1e-10, dev_xi < 1e-9, dev_wk < 1e-9,
          all(bounded$coerente), dev_smoke < 1e-3, n_outside == 0)
cat("  todos passaram.\n")


# ---- Sumário -------------------------------------------------------

summary_var <- ar |>
  group_by(sample, level, var) |>
  summarise(n_h = n(),
            n_bounded  = sum(ar_case == 1L),
            n_ar_sig   = sum(ar_sig, na.rm = TRUE),
            n_dm_sig   = sum(dm_sig, na.rm = TRUE),
            n_boot_sig = sum(boot_sig, na.rm = TRUE),
            razao_ar_boot = median(ar_width / boot_width, na.rm = TRUE),
            razao_ar_dm   = median(ar_width / dm_width,   na.rm = TRUE),
            .groups = "drop")

# Só os primitivos vão para o CSV: larguras, flags de significância e
# assimetria são funções dos limites, e a 31 mil linhas cada coluna derivada
# custa mais em disco do que vale. `xi_mp` e `critval` são constantes por
# (janela, nível) e ficam no relatório.
write_csv(ar |>
            select(sample, var, h, level, tcode, point,
                   ar_lo, ar_hi, ar_case, dm_lo, dm_hi, boot_lo, boot_hi) |>
            mutate(across(where(is.double), ~ signif(.x, 8))),
          file.path(OUT_DIR, "ar_bands.csv"))
write_csv(summary_var |> mutate(across(where(is.double), ~ signif(.x, 6))),
          file.path(OUT_DIR, "ar_bands_summary.csv"))


# ---- Figura: bootstrap pontilhada, AR sombreada --------------------

plot_df <- ar |>
  filter(sample == "full", level == 0.90, var %in% HEADLINE, h <= 36) |>
  mutate(var = factor(var, levels = HEADLINE))

panels <- lapply(HEADLINE, function(v) {
  d <- plot_df |> filter(var == v)
  ggplot(d, aes(x = h)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
    geom_ribbon(aes(ymin = ar_lo, ymax = ar_hi), fill = "grey30", alpha = 0.22) +
    geom_line(aes(y = boot_lo), linetype = "dotted", linewidth = 0.5) +
    geom_line(aes(y = boot_hi), linetype = "dotted", linewidth = 0.5) +
    geom_line(aes(y = point), linewidth = 0.7) +
    labs(title = v, x = NULL, y = NULL) +
    theme_minimal(base_size = 8)
})

ggsave(file.path(OUT_DIR, "ar_bands_overlay.pdf"),
       wrap_plots(panels, ncol = 4) +
         plot_annotation(
           title = "Conjunto Anderson-Rubin (sombreado) vs. wild bootstrap (pontilhado), 90%",
           subtitle = sprintf(paste0("%s x %s, r = %d, q = %d, p = %d, amostra cheia. ",
                                     "Linha cheia: estimativa pontual. As duas bandas ",
                                     "não medem a mesma coisa — ver output/irf/ar_bands.md §3."),
                              INSTRUMENT, MP_VAR, R_FACTORS, Q_DYNAMIC, P_LAGS),
           theme = theme_minimal(base_size = 9)),
       width = 10.4, height = 5.6, device = cairo_pdf)


# ---- Relatório -----------------------------------------------------

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)

md_tbl <- function(df, d = 3) {
  df <- df |> mutate(across(where(is.double), ~ fmt(.x, d)))
  c(paste0("| ", paste(names(df), collapse = " | "), " |"),
    paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"),
    apply(df, 1, function(r) paste0("| ", paste(r, collapse = " | "), " |")))
}

placar <- ar |>
  filter(sample == "full", !is.na(boot_lo)) |>
  group_by(level) |>
  summarise(celulas   = n(),
            n_boot    = sum(boot_sig, na.rm = TRUE),
            n_delta   = sum(dm_sig,   na.rm = TRUE),
            n_ar      = sum(ar_sig,   na.rm = TRUE),
            boot_no_ar  = sum(boot_sig & !ar_sig, na.rm = TRUE),
            delta_no_ar = sum(dm_sig   & !ar_sig, na.rm = TRUE),
            razao_ar_boot = median(ar_width / boot_width, na.rm = TRUE),
            razao_ar_dm   = median(ar_width / dm_width,   na.rm = TRUE),
            .groups = "drop")

# Prêmio de IV fraco: quanto a inversão alarga a banda de Wald com o mesmo
# condicionamento. Não usa o bootstrap, logo existe nas duas janelas.
# A célula de normalização (mp, h = 0) fica fora: ali as duas larguras são
# zero por construção e a razão é 0/0, com o sinal do resíduo de ponto
# flutuante decidindo se sai NaN ou 0.
premio <- ar |>
  filter(!(var == MP_VAR & h == 0L)) |>
  group_by(sample, level) |>
  summarise(xi_mp = first(xi_mp), critval = first(critval),
            razao_mediana = median(ar_width / dm_width, na.rm = TRUE),
            razao_min = min(ar_width / dm_width, na.rm = TRUE),
            razao_max = max(ar_width / dm_width, na.rm = TRUE),
            .groups = "drop")

manchete <- ar |>
  filter(sample == "full", level == 0.90, h == 0, var %in% HEADLINE) |>
  transmute(var, ponto = point,
            AR = sprintf("[%s, %s]", fmt(ar_lo), fmt(ar_hi)),
            delta = sprintf("[%s, %s]", fmt(dm_lo), fmt(dm_hi)),
            bootstrap = sprintf("[%s, %s]", fmt(boot_lo), fmt(boot_hi)),
            assimetria = assimetria)

md <- c(
  "# Bandas Anderson-Rubin — inversão do teste de Montiel Olea-Stock-Watson",
  "",
  "> Corpo **gerado** por `script/ar_bands.R`; reescrito por inteiro a cada",
  "> execução. Nunca escreva prosa aqui — a leitura interpretativa mora em",
  "> `notas/2026-08-10_bandas_anderson_rubin.md`.",
  "",
  sprintf("Spec: `%s` × `%s`, r = %d, q = %d, p = %d, h = 0-%d, choque +%g pb, NW(%d).",
          INSTRUMENT, MP_VAR, R_FACTORS, Q_DYNAMIC, P_LAGS, HORIZON, SHOCK_BPS, NW_LAGS),
  "",
  "## 1. Força do instrumento e limitação do conjunto",
  "",
  md_tbl(tibble::tibble(
    janela = names(diag_win),
    T_eff  = sapply(diag_win, `[[`, "T_eff"),
    xi_mp  = sapply(diag_win, `[[`, "xi_mp"),
    dim_W  = sapply(diag_win, `[[`, "n_par"),
    limitado_68 = sapply(diag_win, function(d) d$xi_mp > qnorm(0.84)^2),
    limitado_90 = sapply(diag_win, function(d) d$xi_mp > qnorm(0.95)^2),
    limitado_95 = sapply(diag_win, function(d) d$xi_mp > qnorm(0.975)^2)), 3),
  "",
  sprintf(paste0("O coeficiente de λ² da quadrática é `T·den² − κ·d0'W₂d0`, ",
                 "logo o conjunto é limitado em **todos** os horizontes se e ",
                 "somente se ξ_mp > κ. `W` é %d × %d estimada com T = %d: ",
                 "posto deficiente, como na própria aplicação do petróleo de ",
                 "MOSW (398 > 356). A quadrática só usa formas quadráticas ",
                 "`d'Wd`, nunca `W⁻¹`."),
          diag_win$full$n_par, diag_win$full$n_par, diag_win$full$T_eff),
  "",
  "## 2. Prêmio de IV fraco: quanto a inversão alarga a banda de Wald",
  "",
  md_tbl(premio, 3),
  "",
  paste0("Razão de larguras AR / delta-method sobre as 106 séries × 49 ",
         "horizontes. As duas bandas compartilham derivada, `W` e ",
         "condicionamento, então a razão isola a correção de IV fraco. Ela é ",
         "quase constante entre séries porque a fraqueza mora no **denominador ",
         "comum** da normalização (`d0'Γ`), não no numerador específico de cada ",
         "série."),
  "",
  "## 3. Placar das três réguas (amostra cheia, 53 séries × 49 horizontes)",
  "",
  md_tbl(placar, 3),
  "",
  paste0("A comparação **limpa** é `razao_ar_dm`: AR e delta-method partem da ",
         "mesma derivada, da mesma `W` e do mesmo condicionamento no espaço de ",
         "fatores, e diferem **só** por o AR não dividir pelo denominador ",
         "estimado. `razao_ar_boot` mistura duas coisas — a correção de IV ",
         "fraco e o fato de o bootstrap reestimar o DFM a cada réplica, ",
         "incerteza que nenhuma das duas bandas assintóticas carrega."),
  "",
  "## 4. Manchetes no impacto (h = 0, 90%)",
  "",
  md_tbl(manchete, 4),
  "",
  paste0("`assimetria` = (limite superior − ponto) / (ponto − limite inferior). ",
         "Uma banda de Wald vale 1 por construção; o afastamento de 1 é o que a ",
         "inversão acrescenta."),
  "",
  "## 5. Onde a correção de IV fraco morde mais (90%, razão AR/delta)",
  "",
  md_tbl(summary_var |>
           filter(sample == "full", level == 0.90) |>
           arrange(desc(razao_ar_dm)) |>
           select(var, n_bounded, n_boot_sig, n_dm_sig, n_ar_sig,
                  razao_ar_dm, razao_ar_boot) |>
           head(15), 3),
  "",
  "## 6. Células sig90 que não sobrevivem ao AR",
  "",
  "Contra o bootstrap:",
  "",
  md_tbl(ar |>
           filter(sample == "full", level == 0.90, boot_sig, !ar_sig) |>
           transmute(var, h, ponto = point,
                     AR = sprintf("[%s, %s]", fmt(ar_lo), fmt(ar_hi))) |>
           arrange(var, h), 4),
  "",
  "Contra o delta-method (a comparação que isola a correção de IV fraco):",
  "",
  md_tbl(ar |>
           filter(sample == "full", level == 0.90, dm_sig, !ar_sig) |>
           count(var, name = "celulas_perdidas") |>
           arrange(desc(celulas_perdidas)) |>
           head(20), 0),
  "")

writeLines(md, file.path(OUT_DIR, "ar_bands.md"))

cat(sprintf("\n-> %s/ar_bands.{csv,md}, ar_bands_summary.csv, ar_bands_overlay.pdf\n",
            OUT_DIR))
cat("\n=== done ===\n")
