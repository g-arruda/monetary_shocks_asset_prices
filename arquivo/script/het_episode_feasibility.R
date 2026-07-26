# ============================================================
# Feasibility of EPISODE-regime heteroskedasticity identification
# (architecture A-episodio, BPSS 2021 style): full-system
# identification Sigma_s = B Lambda_s B' on the monthly factor-VAR
# innovations, with multi-year volatility episodes as regimes and
# ex-post labeling of the monetary column. Replaces both the failed
# calendar-regime variant (output/het_primary/feasibility_report.md)
# and any instrument-based scheme (author decision 2026-07-16).
#
# Per (r,q) cell, p = 6, full sample:
#   S2 partition  pre-2020 vs 2020+ : proportionality LR (rank
#       condition), generalized-eigen system fit, eigenvalue
#       distinctness with bootstrap CIs, circular-rotation placebo
#   S4 partition  13-16 / 17-19 / 20-21 / 22-25 : pairwise LR matrix
#       and per-shock relative variance profile under the S2 B
#   Labeling      impact of each structural column on yield_6m, curve,
#       cambio, IBOV, IPCA; candidate = max |yield_6m| impact;
#       descriptive correlation with Copom-day surprise series
#       (NOT identification — instruments are abandoned)
# Outputs in output/het_primary/: episode_feasibility_grid.csv,
#   episode_labeling.csv, episode_lambda_profiles.csv,
#   episode_feasibility_report.md
# Run: Rscript script/het_episode_feasibility.R
# ============================================================

rm(list = ls())

library(readr)
library(dplyr)
library(tidyr)
library(purrr)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/het_shock_extraction.R")
source("R/identification/het_primary.R")


# ---- Config ---------------------------------------------------------

GRID_RQ <- list(c(5L, 4L), c(6L, 5L), c(7L, 6L), c(8L, 8L))
P_LAGS  <- 6L
MP_VAR  <- "yield_6m"
LABEL_VARS <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd",
                "asset_ibov", "price_ipca")
S2_BREAK <- as.Date("2020-01-01")
S4_BREAKS <- as.Date(c("2017-01-01", "2020-01-01", "2022-01-01"))
S4_NAMES  <- c("e2013_16", "e2017_19", "e2020_21", "e2022_25")
N_BOOT  <- 1000L
SEED    <- 123L
OUT_DIR <- "output/het_primary"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data -----------------------------------------------------------

raw_data <- read_csv("data/processed/data_log_deseasonalized.csv",
                     show_col_types = FALSE) |> drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> select(-ref.date) |> as.matrix()

inst_panel <- read_csv("data/processed/instrumentos_mensais.csv",
                       show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)


#' Mauchly proportionality LR between two demeaned groups
mauchly_lr <- function(X1, X2) {
  k <- ncol(X1)
  n_eff <- (nrow(X1) * nrow(X2)) / (nrow(X1) + nrow(X2))
  S1 <- crossprod(X1) / (nrow(X1) - 1L)
  S2 <- crossprod(X2) / (nrow(X2) - 1L)
  gamma <- abs(eigen(solve(S2, S1), only.values = TRUE)$values)
  -n_eff * log(prod(gamma) / mean(gamma)^k)
}

demean_within <- function(eta, mask) {
  sweep(eta[mask, , drop = FALSE], 2, colMeans(eta[mask, , drop = FALSE]))
}


run_episode_cell <- function(r, q) {
  set.seed(SEED)
  mpind <- match(MP_VAR, colnames(data_mat))

  dfm <- estimate_dfm(data_mat, r, q, P_LAGS, dates = dates,
                      apply_kilian = FALSE)
  K <- dfm$dynamic_loadings
  M <- dfm$dynamic_scaling
  u <- dfm$var_residuals
  eta <- if (!is.matrix(K) && !is.matrix(M)) u else u %*% K %*% solve(M)
  resid_dates <- dates[(P_LAGS + 1):length(dates)]

  # ---- S2: pre-2020 vs 2020+ ----------------------------------------
  pre <- resid_dates < S2_BREAK
  X1  <- demean_within(eta, pre)
  X2  <- demean_within(eta, !pre)

  prop <- rigobon_proportionality_test(X2, X1, n_boot = N_BOOT, seed = SEED)

  Sig_1 <- crossprod(X1) / (nrow(X1) - 1L)
  Sig_2 <- crossprod(X2) / (nrow(X2) - 1L)
  sys   <- fit_two_regime_system(Sig_1, Sig_2)

  # Bootstrap: eigenvalue paths and min relative gap.
  boot_gap    <- numeric(N_BOOT)
  boot_lambda <- matrix(NA_real_, N_BOOT, q)
  for (b in seq_len(N_BOOT)) {
    i1 <- sample.int(nrow(X1), nrow(X1), replace = TRUE)
    i2 <- sample.int(nrow(X2), nrow(X2), replace = TRUE)
    S1b <- crossprod(X1[i1, , drop = FALSE]) / (nrow(X1) - 1L)
    S2b <- crossprod(X2[i2, , drop = FALSE]) / (nrow(X2) - 1L)
    sb  <- fit_two_regime_system(S1b, S2b)
    boot_gap[b]     <- sb$min_rel_gap
    boot_lambda[b, ] <- sb$lambda
  }
  gap_ci <- unname(quantile(boot_gap, c(0.025, 0.975)))

  # Circular-rotation placebo: shift the episode partition around the
  # sample, preserving block lengths and persistence.
  T_eff   <- nrow(eta)
  offsets <- setdiff(6:(T_eff - 6), 0)
  lr_rot <- vapply(offsets, function(k) {
    pre_rot <- pre[((seq_len(T_eff) - 1 + k) %% T_eff) + 1]
    mauchly_lr(demean_within(eta, !pre_rot), demean_within(eta, pre_rot))
  }, numeric(1))
  p_rot <- (sum(lr_rot >= prop$statistic) + 1L) / (length(lr_rot) + 1L)

  # ---- Labeling table -------------------------------------------------
  Lambda_load <- dfm$static_loadings
  sy <- dfm$data_sd
  rawimp_0 <- if (!is.matrix(K) && !is.matrix(M)) Lambda_load * K * M
              else Lambda_load %*% K %*% M
  rawimp_0 <- sweep(rawimp_0, 1, sy, "*")

  impacts <- rawimp_0 %*% sys$B
  sgn <- ifelse(impacts[mpind, ] < 0, -1, 1)
  B_signed <- sweep(sys$B, 2, sgn, "*")
  impacts  <- sweep(impacts, 2, sgn, "*")

  label_idx <- which(LABEL_VARS %in% colnames(data_mat))
  label_tbl <- purrr::map_dfr(seq_len(q), function(j) {
    tibble::tibble(
      r = r, q = q, shock = j,
      lambda_covid = sys$lambda[j],
      !!!setNames(as.list(impacts[match(LABEL_VARS, colnames(data_mat)), j]),
                  LABEL_VARS)
    )
  })
  candidate <- which.max(abs(impacts[mpind, ]))

  # Descriptive correlation of the candidate structural shock with the
  # Copom-day surprise series — labeling evidence only, NOT identification.
  eps <- eta %*% t(solve(B_signed))
  eps_cand <- eps[, candidate]
  months <- lubridate::floor_date(resid_dates, "month")
  z <- inst_panel$z_jk_bs_purif[match(months, inst_panel$month)]
  nz <- !is.na(z) & z != 0
  cor_copom <- suppressWarnings(cor(eps_cand[nz], z[nz]))

  # ---- S4: pairwise LR matrix + variance profile ----------------------
  ep4 <- cut(resid_dates,
             breaks = c(as.Date("1900-01-01"), S4_BREAKS, as.Date("2100-01-01")),
             labels = S4_NAMES)
  pairs <- combn(S4_NAMES, 2, simplify = FALSE)
  pair_lr <- purrr::map_dfr(pairs, function(pr) {
    Xa <- demean_within(eta, ep4 == pr[1])
    Xb <- demean_within(eta, ep4 == pr[2])
    pt <- rigobon_proportionality_test(Xb, Xa, n_boot = 300L, seed = SEED)
    tibble::tibble(r = r, q = q, pair = paste(pr, collapse = " vs "),
                   lr = pt$statistic, p_boot = pt$p_boot)
  })

  profile <- episode_variance_profile(eta, as.character(ep4), B_signed) |>
    dplyr::mutate(r = r, q = q, .before = 1)

  list(
    summary = tibble::tibble(
      r = r, q = q, p = P_LAGS,
      n_pre = sum(pre), n_post = sum(!pre),
      prop_lr = prop$statistic, prop_p_boot = prop$p_boot,
      p_rot = p_rot,
      min_rel_gap = sys$min_rel_gap,
      gap_ci_lo = gap_ci[1], gap_ci_hi = gap_ci[2],
      lambda_max = max(sys$lambda), lambda_min = min(sys$lambda),
      candidate_shock = candidate,
      cand_lambda = sys$lambda[candidate],
      cand_impact_y6m = impacts[mpind, candidate],
      cor_copom_cand = cor_copom,
      s4_pairs_rejecting = sum(pair_lr$p_boot < 0.05),
      offdiag_share_max = max(profile$offdiag_share)
    ),
    label_tbl = label_tbl |> dplyr::mutate(is_candidate = shock == candidate),
    pair_lr = pair_lr,
    profile = profile
  )
}


# ---- Grid loop -------------------------------------------------------

res <- list()
for (rq in GRID_RQ) {
  tag <- sprintf("r=%d q=%d", rq[1], rq[2])
  cat("Cell:", tag, "... ")
  t0 <- Sys.time()
  res[[tag]] <- run_episode_cell(rq[1], rq[2])
  cat(sprintf("done (%.1fs) prop_p=%.3f p_rot=%.3f gap=%.2f\n",
              as.numeric(Sys.time() - t0, units = "secs"),
              res[[tag]]$summary$prop_p_boot,
              res[[tag]]$summary$p_rot,
              res[[tag]]$summary$min_rel_gap))
}

grid    <- purrr::map_dfr(res, "summary")
labels  <- purrr::map_dfr(res, "label_tbl")
pairs   <- purrr::map_dfr(res, "pair_lr")
profile <- purrr::map_dfr(res, "profile")

write_csv(grid,    file.path(OUT_DIR, "episode_feasibility_grid.csv"))
write_csv(labels,  file.path(OUT_DIR, "episode_labeling.csv"))
write_csv(pairs,   file.path(OUT_DIR, "episode_pairwise_lr.csv"))
write_csv(profile, file.path(OUT_DIR, "episode_lambda_profiles.csv"))


# ---- Report ----------------------------------------------------------

fmt <- function(x, d = 2) sprintf(paste0("%.", d, "f"), x)

report <- c(
  "# Viabilidade — het de EPISÓDIO (arquitetura A-episódio, BPSS 2021)",
  "",
  sprintf("Gerado por `script/het_episode_feasibility.R` em %s. Sistema completo Σ_s = B Λ_s B′ nas inovações do factor-VAR mensal; S2 = pré-2020 vs 2020+; S4 = 2013-16 / 2017-19 / 2020-21 / 2022-25; p = %d; n_boot = %d; seed = %d. Instrumentos abandonados por decisão do autor — a correlação com surpresas Copom reportada abaixo é evidência DESCRITIVA de rotulagem, não identificação.",
          format(Sys.Date()), P_LAGS, N_BOOT, SEED),
  "",
  "## S2: rank condition, distinctness e placebo",
  "",
  "| r | q | n_pre/n_post | LR prop | p_boot | p_rot (placebo circular) | min gap rel [CI] | λ range | shock candidato | λ_cand | impacto y6m | cor(ε_cand, surpresa Copom) | S4 pares rejeitando | offdiag máx |",
  paste0("|", paste(rep("---", 14), collapse = "|"), "|"),
  apply(grid, 1, function(x) {
    sprintf("| %s | %s | %s/%s | %s | %s | %s | %s [%s, %s] | [%s, %s] | %s | %s | %s | %s | %s/6 | %s |",
            x[["r"]], x[["q"]], x[["n_pre"]], x[["n_post"]],
            fmt(as.numeric(x[["prop_lr"]]), 1), fmt(as.numeric(x[["prop_p_boot"]]), 3),
            fmt(as.numeric(x[["p_rot"]]), 3),
            fmt(as.numeric(x[["min_rel_gap"]])), fmt(as.numeric(x[["gap_ci_lo"]])),
            fmt(as.numeric(x[["gap_ci_hi"]])),
            fmt(as.numeric(x[["lambda_min"]])), fmt(as.numeric(x[["lambda_max"]])),
            x[["candidate_shock"]], fmt(as.numeric(x[["cand_lambda"]])),
            fmt(as.numeric(x[["cand_impact_y6m"]]), 4),
            fmt(as.numeric(x[["cor_copom_cand"]])),
            x[["s4_pairs_rejecting"]],
            fmt(as.numeric(x[["offdiag_share_max"]])))
  }),
  "",
  "Colunas: `LR prop`/`p_boot` = teste de proporcionalidade Rigobon Prop. 1 entre os dois episódios (rejeitar = rank condition satisfeita); `p_rot` = placebo por rotação circular das fronteiras (preserva tamanhos e persistência); `min gap rel` = menor gap relativo entre autovalores generalizados adjacentes (distinctness ⇒ identificação ponto a ponto do B, a menos de sinal/permutação); `λ range` = variâncias relativas 2020+/pré-2020 por choque; `impacto y6m` = impacto do choque candidato (1 s.d. pré-2020) sobre yield_6m; `offdiag máx` = massa fora da diagonal de B⁻¹Σ_sB⁻¹′ nos episódios finos (constância de B).",
  "",
  "## Rotulagem (impactos por coluna estrutural, 1 s.d. pré-2020)",
  "",
  "Ver `episode_labeling.csv` (todas as células) e `episode_lambda_profiles.csv` (caminho de variância por episódio). Candidato = coluna com maior |impacto| em yield_6m.",
  ""
)

writeLines(report, file.path(OUT_DIR, "episode_feasibility_report.md"))
cat("\nWrote episode_feasibility_{grid,labeling,pairwise_lr,lambda_profiles}.csv and episode_feasibility_report.md in", OUT_DIR, "\n")
