# ============================================================
# Feasibility gates for the het-primary identification
# (architecture A: monthly Copom/non-Copom regimes on the
# factor-VAR innovations — _instrucoes/plano_reimplementacao_het.md).
# Grid: (r,q) x {full, pre_covid} x p in {6, 3}. Per cell:
#   G1  monthly A1 (variance shift in the policy direction; placebo
#       by permutation of month labels)
#   G2  rank (proportionality LR + Lanne-Lutkepohl rank-1 +
#       Rigobon 2003 eq. 7 cross-product, anchored on theta)
#   G3  A2 on the orthogonal complement of theta (rotated split)
#   G4  A3 stability of theta pre/post COVID (full cells)
#   G5  strength verdict (weak-ID screen)
#   G6  common global shocks across regimes (K > 0 flag + purged rerun)
#   spanning of yield_6m by the common component
#   IV regime-signed cross-check (SW 2016 eq. 46)
# Outputs: output/het_primary/feasibility_grid.csv, feasibility_report.md
# Run: Rscript script/het_primary_feasibility.R   (~minutes)
# ============================================================

rm(list = ls())

library(readr)
library(dplyr)
library(tidyr)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/het_shock_extraction.R")
source("R/identification/het_primary.R")


# ---- Config ---------------------------------------------------------

GRID_RQ  <- list(c(5L, 4L), c(6L, 5L), c(7L, 6L), c(8L, 8L))
SAMPLES  <- list(full      = as.Date(c("2013-01-01", "2025-12-31")),
                 pre_covid = as.Date(c("2013-01-01", "2019-12-31")))
P_GRID   <- c(6L, 3L)
MP_VAR   <- "yield_6m"
N_BOOT   <- 1000L
N_PERM   <- 1000L
SEED     <- 123L
GLOBALS  <- c("sp500_vix", "msci", "commodity_agro", "commodity_metal",
              "commodity_energia", "epu_us")
OUT_DIR  <- "output/het_primary"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data -----------------------------------------------------------

raw_data <- read_csv("data/processed/data_log_deseasonalized.csv",
                     show_col_types = FALSE) |> drop_na()
dates_all <- as.Date(raw_data$ref.date)
data_all  <- raw_data |> select(-ref.date) |> as.matrix()
globals   <- intersect(GLOBALS, colnames(data_all))

cat(sprintf("Panel: %d x %d | globals for G6: %s\n",
            nrow(data_all), ncol(data_all), paste(globals, collapse = ", ")))


#' Run all feasibility gates on one (r, q, p, sample) cell
#'
#' @param data_mat Panel matrix restricted to the sample window.
#' @param dates Date vector aligned to data_mat rows.
#' @param r,q,p DFM dimensions and VAR lag order.
#' @param sample_name Label for the report ("full" / "pre_covid").
#'
#' @return One-row tibble with every gate statistic.
run_feasibility_cell <- function(data_mat, dates, r, q, p, sample_name) {
  mpind <- match(MP_VAR, colnames(data_mat))

  dfm <- estimate_dfm(data_mat, r, q, p, dates = dates, apply_kilian = FALSE)

  K <- dfm$dynamic_loadings
  M <- dfm$dynamic_scaling
  u <- dfm$var_residuals
  eta <- if (!is.matrix(K) && !is.matrix(M)) u else u %*% K %*% solve(M)

  regimes <- build_monthly_regimes(month_range = range(dates))
  labels  <- align_regimes_to_eta(dates, p, regimes)

  parts <- split_by_regime(eta, labels)
  theta <- fit_rank1_md(parts$Sigma_C, parts$Sigma_NC)$theta

  # Impact matrix at h = 0 (Lambda K M, rescaled) anchors sign and spanning.
  Lambda <- dfm$static_loadings
  sy     <- dfm$data_sd
  rawimp_0 <- if (!is.matrix(K) && !is.matrix(M)) Lambda * K * M
              else Lambda %*% K %*% M
  rawimp_0 <- sweep(rawimp_0, 1, sy, "*")
  impact <- as.numeric(rawimp_0 %*% theta)
  if (impact[mpind] < 0) {
    theta  <- -theta
    impact <- -impact
  }

  # G1 + G5: strength along the estimated direction and permutation placebo.
  strength <- het_strength_stats(eta, labels, n_boot = N_BOOT,
                                 n_perm = N_PERM, seed = SEED)

  # G2: formal rank battery + eq. 7 cross-product anchored on theta.
  battery <- formal_rank_test_battery(parts$X_C, parts$X_NC,
                                      n_boot = 500L, seed = SEED)
  crossp  <- rigobon_crossprod_test(eta, labels, theta,
                                    n_boot = N_BOOT, seed = SEED)

  # G3: A2 on the rotated system [theta_unit | orthogonal complement].
  theta_unit <- theta / sqrt(sum(theta^2))
  Q_rot <- qr.Q(qr(cbind(theta_unit, diag(q))))[, 1:q, drop = FALSE]
  eta_rot <- eta %*% Q_rot
  colnames(eta_rot) <- c("policy_dir", paste0("orth_", seq_len(q - 1)))
  split_rot <- validate_variance_split(eta_rot,
                                       tibble::tibble(regime = labels),
                                       alpha = 0.01, n_boot = N_BOOT,
                                       seed = SEED)
  a2_rot <- classify_a2_verdict(split_rot, mp_var = "policy_dir")
  n_a2_violated <- sum(a2_rot$a2_status == "violated")

  # G4: A3 stability of theta across the COVID break (full cells only).
  a3_cos <- NA_real_
  a3_norm_ratio <- NA_real_
  if (sample_name == "full") {
    resid_dates <- dates[(p + 1):length(dates)]
    pre  <- resid_dates < as.Date("2020-01-01")
    both_regimes <- function(m) length(unique(labels[m])) == 2L
    if (both_regimes(pre) && both_regimes(!pre)) {
      th_pre  <- fit_rank1_md(split_by_regime(eta[pre, , drop = FALSE],
                                              labels[pre])$Sigma_C,
                              split_by_regime(eta[pre, , drop = FALSE],
                                              labels[pre])$Sigma_NC)$theta
      th_post <- fit_rank1_md(split_by_regime(eta[!pre, , drop = FALSE],
                                              labels[!pre])$Sigma_C,
                              split_by_regime(eta[!pre, , drop = FALSE],
                                              labels[!pre])$Sigma_NC)$theta
      a3_cos <- abs(sum(th_pre * th_post)) /
        sqrt(sum(th_pre^2) * sum(th_post^2))
      a3_norm_ratio <- sqrt(sum(th_post^2)) / sqrt(sum(th_pre^2))
    }
  }

  # G6: do global factors also shift variance across Copom regimes?
  resid_idx <- (p + 1):length(dates)
  d_globals <- diff(data_mat[, globals, drop = FALSE])[resid_idx - 1, ,
                                                       drop = FALSE]
  split_glob <- validate_variance_split(d_globals,
                                        tibble::tibble(regime = labels),
                                        alpha = 0.01, n_boot = N_BOOT,
                                        seed = SEED)
  k_flag <- sum(split_glob$ci_low > 1 | split_glob$ci_high < 1)

  # Purged rerun: first-stage regression of eta on the global changes
  # (Rigobon's EMBI treatment of the common shock), then G1 again.
  eta_purged <- stats::lm.fit(cbind(1, d_globals), eta)$residuals
  strength_purged <- het_strength_stats(eta_purged, labels,
                                        n_boot = 200L, n_perm = N_PERM,
                                        seed = SEED)

  # Spanning of the policy variable by the common component.
  Chi <- sweep(dfm$static_factors %*% t(Lambda), 2, sy, "*")
  spanning_r2 <- 1 - stats::var(dfm$detrended_data[, mpind] - Chi[, mpind]) /
    stats::var(dfm$detrended_data[, mpind])

  # IV regime-signed cross-check (SW 2016 eq. 46) through the proxy code.
  s_mp <- drop(eta %*% rawimp_0[mpind, ])
  D    <- ifelse(labels == "C", 1 / parts$n_C, -1 / parts$n_NC)
  Z_iv <- D * s_mp
  eta_c <- sweep(eta, 2, colMeans(eta))
  H_iv  <- drop(crossprod(as.matrix(Z_iv), eta_c)) / drop(crossprod(as.matrix(Z_iv)))
  iv_cos <- abs(sum(H_iv * theta)) / sqrt(sum(H_iv^2) * sum(theta^2))

  tibble::tibble(
    sample        = sample_name,
    r             = r,
    q             = q,
    p             = p,
    n_C           = parts$n_C,
    n_NC          = parts$n_NC,
    lambda_1      = strength$lambda_1,
    lambda_1_lo   = strength$lambda_1_ci[1],
    lambda_1_hi   = strength$lambda_1_ci[2],
    rank1_share   = strength$rank1_share,
    ratio_dir     = strength$ratio_dir,
    ratio_dir_lo  = strength$ratio_dir_ci[1],
    ratio_dir_hi  = strength$ratio_dir_ci[2],
    p_perm        = strength$p_perm,
    prop_p_boot   = battery$prop_test$p_boot,
    rank1_p_boot  = battery$rank1_test$p_boot,
    share_lo      = battery$share_ci$share_lo,
    share_hi      = battery$share_ci$share_hi,
    crossp_n_rej  = sum(crossp$rejects_zero),
    a2_n_violated = n_a2_violated,
    a3_cos        = a3_cos,
    a3_norm_ratio = a3_norm_ratio,
    k_flag        = k_flag,
    p_perm_purged = strength_purged$p_perm,
    ratio_purged  = strength_purged$ratio_dir,
    spanning_r2   = spanning_r2,
    iv_cos        = iv_cos,
    impact_mp     = impact[mpind]
  )
}


# ---- Grid loop -------------------------------------------------------

grid_rows <- list()
for (sample_name in names(SAMPLES)) {
  win <- SAMPLES[[sample_name]]
  in_win <- dates_all >= win[1] & dates_all <= win[2]
  data_w  <- data_all[in_win, , drop = FALSE]
  dates_w <- dates_all[in_win]

  for (rq in GRID_RQ) {
    for (p in P_GRID) {
      tag <- sprintf("%s r=%d q=%d p=%d", sample_name, rq[1], rq[2], p)
      cat("Cell:", tag, "... ")
      t0 <- Sys.time()
      row <- tryCatch(
        run_feasibility_cell(data_w, dates_w, rq[1], rq[2], p, sample_name),
        error = function(e) {
          cat("ERROR:", conditionMessage(e), "\n")
          NULL
        }
      )
      if (!is.null(row)) {
        grid_rows[[tag]] <- row
        cat(sprintf("done (%.1fs) p_perm=%.3f ratio=%.2f\n",
                    as.numeric(Sys.time() - t0, units = "secs"),
                    row$p_perm, row$ratio_dir))
      }
    }
  }
}

grid <- dplyr::bind_rows(grid_rows)
readr::write_csv(grid, file.path(OUT_DIR, "feasibility_grid.csv"))


# ---- Eligibility and report -----------------------------------------

# Eligible: A1 evidence (placebo p < 0.05 and directional ratio CI above 1),
# rank gate satisfied (proportionality rejected), positive leading
# eigenvalue with CI excluding 0, and yield_6m reasonably spanned.
grid <- grid |>
  dplyr::mutate(
    g1_pass = p_perm < 0.05 & ratio_dir_lo > 1,
    g2_pass = prop_p_boot < 0.05,
    g5_verdict = dplyr::case_when(
      p_perm < 0.01 & ratio_dir_lo > 1 ~ "strong",
      p_perm < 0.05                    ~ "marginal",
      TRUE                             ~ "weak"
    ),
    eligible = g1_pass & g2_pass & lambda_1_lo > 0 & spanning_r2 > 0.5
  )

winner <- grid |>
  dplyr::filter(eligible) |>
  dplyr::arrange(dplyr::desc(p == 6L), dplyr::desc(sample == "full"),
                 p_perm, dplyr::desc(ratio_dir))

report <- c(
  "# Gates de viabilidade — het-ID primária (arquitetura A, regimes mensais)",
  "",
  sprintf("Gerado por `script/het_primary_feasibility.R` em %s. Grid: (r,q) em {(5,4),(6,5),(7,6),(8,8)} x {full, pre_covid} x p em {6,3}; mp_var = `%s`; n_boot = %d, n_perm = %d, seed = %d.",
          format(Sys.Date()), MP_VAR, N_BOOT, N_PERM, SEED),
  "",
  "Regimes mensais: C = mes com reuniao do Copom, NC = sem. G1 exige salto de variancia na direcao de politica (placebo por permutacao de labels + CI 99% do ratio); G2 exige nao-proporcionalidade (LR Rigobon Prop. 1) — juntos sao a rank condition. G5 e a triagem weak-ID; G6 conta variaveis globais com salto de variancia proprio (K > 0) e reporta o rerun com eta purgado. Spanning e o R2 do componente comum de yield_6m (SW 2016 §7.5.1: named-factor quebra se fraco). iv_cos e o cross-check IV regime-signed (SW eq. 46).",
  "",
  "## Grid completo",
  "",
  paste0("| ", paste(c("sample", "r", "q", "p", "n_C/n_NC", "lambda_1 [CI]",
                       "rank1", "ratio_dir [CI]", "p_perm", "prop p",
                       "crossp", "A2 viol", "A3 cos", "K flag",
                       "p_perm purg", "span R2", "iv_cos", "G5"),
                     collapse = " | "), " |"),
  paste0("|", paste(rep("---", 18), collapse = "|"), "|"),
  apply(grid, 1, function(x) {
    sprintf("| %s | %s | %s | %s | %s/%s | %.2f [%.2f, %.2f] | %.2f | %.2f [%.2f, %.2f] | %.3f | %.3f | %s/%s | %s | %s | %s | %.3f | %.2f | %.2f | %s |",
            x[["sample"]], x[["r"]], x[["q"]], x[["p"]],
            x[["n_C"]], x[["n_NC"]],
            as.numeric(x[["lambda_1"]]), as.numeric(x[["lambda_1_lo"]]),
            as.numeric(x[["lambda_1_hi"]]),
            as.numeric(x[["rank1_share"]]),
            as.numeric(x[["ratio_dir"]]), as.numeric(x[["ratio_dir_lo"]]),
            as.numeric(x[["ratio_dir_hi"]]),
            as.numeric(x[["p_perm"]]), as.numeric(x[["prop_p_boot"]]),
            x[["crossp_n_rej"]], x[["q"]],
            x[["a2_n_violated"]],
            ifelse(is.na(x[["a3_cos"]]), "-", sprintf("%.2f", as.numeric(x[["a3_cos"]]))),
            x[["k_flag"]],
            as.numeric(x[["p_perm_purged"]]),
            as.numeric(x[["spanning_r2"]]),
            as.numeric(x[["iv_cos"]]),
            x[["g5_verdict"]])
  }),
  "",
  "## Elegibilidade e veredito",
  ""
)

if (nrow(winner) > 0) {
  w <- winner[1, ]
  report <- c(report,
    sprintf("**%d celula(s) elegivel(is).** Vencedora pela regra (p=6 > full > menor p_perm > maior ratio): **%s (r=%d, q=%d, p=%d)** — p_perm = %.3f, ratio_dir = %.2f [%.2f, %.2f], spanning R2 = %.2f.",
            nrow(winner), w$sample, w$r, w$q, w$p, w$p_perm,
            w$ratio_dir, w$ratio_dir_lo, w$ratio_dir_hi, w$spanning_r2),
    "",
    "Celulas elegiveis, em ordem:",
    "",
    apply(winner, 1, function(x) {
      sprintf("- %s (r=%s, q=%s, p=%s): p_perm = %.3f, ratio_dir = %.2f, G5 = %s",
              x[["sample"]], x[["r"]], x[["q"]], x[["p"]],
              as.numeric(x[["p_perm"]]), as.numeric(x[["ratio_dir"]]),
              x[["g5_verdict"]])
    })
  )
} else {
  report <- c(report,
    "**NENHUMA celula elegivel.** Regra de parada do plano: a arquitetura A (regimes mensais) nao encontra salto de variancia identificavel nas inovacoes do factor-VAR em nenhuma celula do grid. NAO alterar a producao — decisao entre fallback B (sistema diario RS-2004 + ponte proxy explicita) e manter proxy volta ao autor.")
}

writeLines(report, file.path(OUT_DIR, "feasibility_report.md"))
cat("\nWrote", file.path(OUT_DIR, "feasibility_grid.csv"), "and feasibility_report.md\n")
if (nrow(winner) > 0) {
  cat(sprintf("WINNER: %s r=%d q=%d p=%d\n",
              winner$sample[1], winner$r[1], winner$q[1], winner$p[1]))
} else {
  cat("STOP RULE: no eligible cell.\n")
}
