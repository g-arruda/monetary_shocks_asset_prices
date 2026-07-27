# ===================================================================
# FUNÇÕES DE IMPULSO-RESPOSTA (IRF) PARA MODELO DFM
# IDENTIFICAÇÃO VIA INSTRUMENTO EXTERNO (PROXY SVAR)
# Seguindo Alessi & Kerssenfischer / Gertler & Karadi (2015)
# ===================================================================


# ===================================================================
# ALINHAMENTO TEMPORAL: INSTRUMENTO × RESÍDUOS
# Equivalente a selextinstsample.m
# ===================================================================
sel_ext_inst_sample <- function(data_dates, p, instrument_df, rr = NULL) {
  inst_dates <- as.Date(instrument_df$month)
  inst_data  <- instrument_df$shock

  residual_dates <- data_dates[(p + 1):length(data_dates)]

  rsh_sel_ind <- residual_dates %in% inst_dates
  inst_sel    <- inst_data[inst_dates %in% residual_dates]

  if (!is.null(rr)) {
    rr_sel   <- rr[rsh_sel_ind]
    inst_sel <- inst_sel * rr_sel
  }

  list(rsh_sel_ind = rsh_sel_ind, inst_sel = inst_sel)
}


# ===================================================================
# IDENTIFICAÇÃO POR INSTRUMENTO EXTERNO
# Equivalente a IdentExtInstr.m
# ===================================================================
#' Identification via external instrument (equivalent to IdentExtInstr.m)
#'
#' `normalize_value` is in the policy variable's *native units*. For the
#' default DFM where the policy variable is `yield_6m` (decimal proportion,
#' 0.05 = 5%), a +50bp shock corresponds to `normalize_value = 0.005`.
#' The historical default of 0.5 (kept for backward compatibility with
#' calls that target a percent-scale policy variable, such as
#' `juros_selic` in `script/model_var.R`) implicitly normalises to +5000bp
#' on a decimal-proportion variable. Callers should set
#' `normalize_value = shock_bps / 10000` when the policy variable is in
#' decimal proportion. See `_instrucoes/justificativa_uso_yield-6m.md`.
#'
#' @param rawimp Reduced-form IRF array (n_vars x q x h+1).
#' @param rsh_sel Reduced-form factor innovations aligned with the instrument.
#' @param Z_sel Instrument vector aligned with `rsh_sel`.
#' @param h Horizon of the IRF (excluding impact).
#' @param mpind Index of the policy variable in `rawimp[, , 1]`. If NULL, no
#'   impact normalization is applied.
#' @param normalize_value Target value of `irf_mp[mpind, 1]` after normalization,
#'   in native units of the policy variable.
#' @param tcode Vector of transformation codes for `cumimp_transform`.
#' @param diagnose If TRUE, print diagnostic information about `H`, the
#'   pre-normalization impact response, and the factor-space first-stage F.
#'   Use only on the point estimate; never inside bootstrap loops.
#' @param var_names Optional column names for printing the impact vector when
#'   `diagnose` is TRUE.
#'
#' @return List with `irf_mp` (normalized + tcode-transformed IRFs),
#'   `irf_mp_pre_tcode` (normalized but before `cumimp_transform`; the
#'   normalization at line 122 happens before this field is filled, so it is
#'   not a raw IRF), and `H` (factor-space loadings).
ident_ext_instr <- function(rawimp, rsh_sel, Z_sel, h,
                            mpind = NULL, normalize_value = 0.5,
                            tcode = NULL, diagnose = FALSE,
                            var_names = NULL) {
  rsh_mean0 <- sweep(rsh_sel, 2, colMeans(rsh_sel))

  # Proxy-SVAR loadings: H = (Z' eta) / (Z'Z) — Stock-Watson (2018) eq. 4
  Z_mat <- as.matrix(Z_sel)
  H <- drop(crossprod(Z_mat, rsh_mean0)) / drop(crossprod(Z_mat))

  n_vars <- dim(rawimp)[1]
  irf_mp <- matrix(0, n_vars, h + 1)

  for (j in seq_len(h + 1)) {
    rawimp_j <- matrix(rawimp[, , j], nrow = n_vars)
    irf_mp[, j] <- rawimp_j %*% H
  }

  if (isTRUE(diagnose) && !is.null(mpind)) {
    impact_pre <- irf_mp[mpind, 1]
    f_factor   <- compute_factor_space_F(rsh_mean0, Z_mat)
    wald_fs    <- compute_factor_space_wald(rsh_mean0, Z_mat)

    cat("\n========== ident_ext_instr DIAGNOSTIC ==========\n")
    cat(sprintf("H (factor-space loadings, length %d):\n", length(H)))
    cat(sprintf("  %s\n", paste(sprintf("%.4e", H), collapse = "  ")))
    cat(sprintf("irf_mp[mpind=%d, 1] (pre-norm) = %.4e   sign = %s\n",
                mpind, impact_pre,
                if (impact_pre > 0) "POSITIVE" else if (impact_pre < 0) "NEGATIVE" else "ZERO"))
    cat(sprintf("F (factor-space, max across q factors, homosk. legacy) = %.3f\n",
                f_factor))
    cat(sprintf("MOSW Wald per factor xi_k: min = %.3f  max = %.3f\n",
                wald_fs$wald_min, wald_fs$wald_max))
    cat(sprintf("MOSW joint Wald = %.3f  (F_joint = %.3f, chi2_%d p = %.4f)\n",
                wald_fs$wald_joint, wald_fs$F_joint, wald_fs$q, wald_fs$p_joint))
    cat("      [no lag controls here — instrument_diagnostics.R reports the\n")
    cat("      Shat-corrected version with factor-VAR lags residualized out]\n")
    if (f_factor < 10 || wald_fs$F_joint < 10) {
      cat("[!!!] WARNING: factor-space relevance < 10 — instrument is WEAK in the\n")
      cat("      space where the proxy-SVAR projects. F (y6m AR) reported in\n")
      cat("      instrument_diagnostics.R measures relevance against a single\n")
      cat("      reduced-form variable, not the factor space. Wide IRF bands\n")
      cat("      and unstable signs are mechanical consequences of weak F here.\n")
    }
    cat("Impact (raw, pre-norm) per variable:\n")
    impact_vec <- irf_mp[, 1]
    if (!is.null(var_names) && length(var_names) == length(impact_vec)) {
      names(impact_vec) <- var_names
    }
    print(impact_vec)
    if (impact_pre < 0) {
      cat("\n[!!!] WARNING: impact_pre < 0 — normalization will FLIP ALL IRF SIGNS.\n")
      cat("      Likely root cause: sign of H or of dynamic-factor rotation K\n")
      cat("      is not aligned with instrument's sign convention.\n")
    }
    cat("================================================\n\n")
  }

  if (!is.null(mpind)) {
    irf_mp <- irf_mp / irf_mp[mpind, 1] * normalize_value
  }

  irf_mp_transformed <- cumimp_transform(irf_mp, tcode)

  list(irf_mp = irf_mp_transformed, irf_mp_pre_tcode = irf_mp, H = H)
}


#' Factor-space first-stage F statistic
#'
#' Reports the maximum F-statistic across q univariate regressions of each
#' factor innovation on the instrument. A small max-F (<10) indicates the
#' instrument is weak in factor space — even if it is strong against a
#' reduced-form variable like `yield_6m`. This is the relevant weak-instrument
#' diagnostic for the proxy-SVAR projection through factors.
#'
#' @param eta Matrix of factor innovations (T x q), already demeaned.
#' @param Z Instrument vector or column matrix (T x 1).
#'
#' @return Scalar: max F-stat across the q factor regressions.
compute_factor_space_F <- function(eta, Z) {
  Z <- as.numeric(Z)
  q <- ncol(eta)
  fs <- numeric(q)
  for (k in seq_len(q)) {
    fit <- lm(eta[, k] ~ Z)
    s <- summary(fit)
    fs[k] <- if (is.null(s$fstatistic)) NA_real_ else s$fstatistic[["value"]]
  }
  max(fs, na.rm = TRUE)
}


#' Montiel Olea-Stock-Watson Wald statistics for instrument relevance in factor space
#'
#' Implements the relevance diagnostics of Montiel Olea, Stock & Watson
#' (2021, J. Econometrics, sec. 4.2) against the q factor innovations:
#'
#' - per-factor Wald  xi_k = T * Gamma_k^2 / W_kk        (paper's xi_1, eq. in sec. 4.2)
#' - joint Wald       xi_joint = T * Gamma' W^{-1} Gamma (the authors' `WaldstatFull`,
#'   MSWfunction.m:389, chi^2_q under the null of irrelevance)
#'
#' with Gamma = (1/T) sum_t z_t eta_t and W the Eicker-White covariance of the
#' moment z_t eta_t (Newey-West with 0 lags, matching NWlags = 0 in the
#' authors' applications). When `controls` is supplied (the factor-VAR
#' regressors: lags + constant), z is residualized on them first — this
#' reproduces the Shat correction of CovAhat_Sigmahat_Gamma.m, which
#' propagates the VAR estimation error into W. Without controls, z is only
#' demeaned (the constant-only version of the same correction; Gamma is
#' unchanged either way because the VAR residuals are orthogonal to the
#' regressors in-sample).
#'
#' The per-factor xi_k is heteroskedasticity-robust by construction. The
#' joint statistic is the conservative headline: it does not cherry-pick the
#' strongest factor equation (unlike `compute_factor_space_F`, kept as the
#' legacy metric for comparability with the 2026-07-11 spec sweep).
#'
#' @param eta Matrix of factor innovations (T x q).
#' @param Z Instrument vector or column matrix (T x 1), aligned to eta.
#' @param controls Optional matrix/data.frame of VAR regressors aligned to eta
#'   (lags of the factors; a constant is added internally).
#'
#' @return List: `wald_k` (length-q vector), `wald_min`, `wald_max`,
#'   `wald_joint`, `F_joint` (= wald_joint / q), `p_joint` (chi^2_q),
#'   `q`, `T_eff`.
compute_factor_space_wald <- function(eta, Z, controls = NULL) {
  eta <- as.matrix(eta)
  Z   <- as.numeric(Z)
  T_eff <- length(Z)
  q     <- ncol(eta)

  if (!is.null(controls)) {
    Z_use <- as.numeric(qr.resid(qr(cbind(1, as.matrix(controls))), Z))
  } else {
    Z_use <- Z - mean(Z)
  }

  G_mat <- Z_use * eta                       # T x q, rows z_t * eta_t'
  Gamma <- colMeans(G_mat)
  V     <- sweep(G_mat, 2, Gamma)
  W     <- crossprod(V) / T_eff              # Eicker-White (NW lags = 0)

  wald_k     <- T_eff * Gamma^2 / diag(W)
  wald_joint <- tryCatch(
    T_eff * drop(t(Gamma) %*% solve(W, Gamma)),
    error = function(e) NA_real_
  )

  list(
    wald_k     = wald_k,
    wald_min   = min(wald_k),
    wald_max   = max(wald_k),
    wald_joint = wald_joint,
    F_joint    = wald_joint / q,
    p_joint    = pchisq(wald_joint, df = q, lower.tail = FALSE),
    q          = q,
    T_eff      = T_eff
  )
}


# ===================================================================
# TRANSFORMAÇÃO DE IRFS SEGUNDO TCODE (equivalente a cumimp.m)
# 1 = level, 2 = first difference, 3 = second difference,
# 4 = log-level, 5 = first log-difference
# ===================================================================
cumimp_transform <- function(Imp, tcode = NULL) {
  if (is.null(tcode)) {
    tcode <- rep(1L, nrow(Imp))
  }
  if (length(tcode) != nrow(Imp)) {
    stop("tcode deve ter comprimento igual ao numero de variaveis (", nrow(Imp), ")")
  }

  CC <- Imp * 0

  notransf <- which(tcode == 1)
  firstdiff <- which(tcode == 2)
  seconddiff <- which(tcode == 3)
  loglevel <- which(tcode == 4)
  firstlogdiff <- which(tcode == 5)

  if (length(notransf) > 0) {
    CC[notransf, ] <- Imp[notransf, ]
  }
  if (length(firstdiff) > 0) {
    CC[firstdiff, ] <- t(apply(Imp[firstdiff, , drop = FALSE], 1, cumsum)) * 100
  }
  if (length(firstlogdiff) > 0) {
    CC[firstlogdiff, ] <- (exp(t(apply(Imp[firstlogdiff, , drop = FALSE], 1, cumsum))) - 1) * 100
  }
  if (length(seconddiff) > 0) {
    first_cum <- t(apply(Imp[seconddiff, , drop = FALSE], 1, cumsum))
    CC[seconddiff, ] <- t(apply(first_cum, 1, cumsum))
  }
  if (length(loglevel) > 0) {
    CC[loglevel, ] <- (exp(Imp[loglevel, , drop = FALSE]) - 1) * 100
  }

  CC
}


# ===================================================================
# DICIONÁRIO DE TCODES COM BASE NAS TRANSFORMAÇÕES DO CLEAN
# Padrão: tcode = 1 (nível)
# Não-padrão:
# - base_*                -> tcode = 4 (log-level)
# - credit* / credito_*   -> tcode = 4 (log-level)
# - fin_inst_reserve_req  -> tcode = 4 (log-level)
# - pib                   -> tcode = 4 (log-level)
# - asset_*               -> tcode = 2 (retorno mensal; IRF cumulada p/ nível)
# ===================================================================
infer_tcode_from_varnames <- function(var_names) {
  tcode <- rep(1L, length(var_names))

  loglevel_idx <- grepl("^base_", var_names) |
    grepl("^credit", var_names) |
    grepl("^credito_", var_names) |
    var_names %in% c("fin_inst_reserve_req", "pib")

  tcode[loglevel_idx] <- 4L

  # asset_* são retornos mensais (download.R: prod(1+r)-1), não níveis.
  # tcode = 2 acumula a IRF (cumsum) para recuperar a resposta de nível de preço,
  # que é o objeto teórico ("o mercado cai X%") e o que a janela de coerência pontua.
  tcode[grepl("^asset_", var_names)] <- 2L

  tcode
}


# ===================================================================
# FUNÇÃO PRINCIPAL: IRFs COM IDENTIFICAÇÃO VIA INSTRUMENTO EXTERNO
# ===================================================================
compute_irf_dfm <- function(dfm_results, instrument = NULL, h = 24, nboot = 300,
                            bootstrap_seed = NULL, mpind = NULL,
                            normalize_value = 0.5, data_dates = NULL,
                            tcode = NULL, ci_levels = c(0.90, 0.95),
                            diagnose = getOption("dfm.irf.diagnose", FALSE),
                            var_names = NULL,
                            identification = c("proxy", "het", "nongaussian"),
                            regime_labels = NULL, het_weight = "identity",
                            ng_distri = NULL, ng_starts = 20L,
                            ng_boot_starts = 3L) {

  identification <- match.arg(identification)
  if (!is.null(bootstrap_seed)) set.seed(bootstrap_seed)

  # --- Extrair componentes do DFM (OLS, sem Kilian — para ponto estimado) ---
  Lambda <- dfm_results$static_loadings
  A      <- dfm_results$companion_matrix  # companion OLS (sem Kilian)
  K      <- dfm_results$dynamic_loadings
  M      <- dfm_results$dynamic_scaling
  sy     <- dfm_results$data_sd
  p      <- dfm_results$p
  r      <- ncol(Lambda)
  q      <- dfm_results$q
  n_vars <- nrow(Lambda)
  rp     <- nrow(A)

  # --- Resolver identificação ---
  # Switch explícito de 3 vias: o antigo `else` era catch-all e um valor novo
  # cairia silenciosamente no ramo proxy.
  switch(identification,
    "het" = {
      if (!exists("ident_het_regimes")) {
        stop("identification = 'het' requer source('arquivo/R/identification/het_primary.R') (modulo arquivado em 2026-07-26)")
      }
      n_resid <- nrow(dfm_results$var_residuals)
      if (is.null(regime_labels) || length(regime_labels) != n_resid) {
        stop("regime_labels deve ter comprimento ", n_resid,
             " (linhas dos residuos do VAR); use build_monthly_regimes + align_regimes_to_eta")
      }
    },
    "nongaussian" = {
      if (!exists("ident_nongaussian")) {
        stop("identification = 'nongaussian' requer source('R/identification/nongaussian_branch.R')")
      }
      # O instrumento aqui NÃO identifica: só rotula a coluna monetária. Ainda
      # assim é obrigatório, porque sem ele não há como nomear a coluna.
      if (is.null(instrument) && !is.null(dfm_results$instrument)) {
        instrument <- dfm_results$instrument
      }
      if (is.null(instrument)) {
        stop("identification = 'nongaussian' precisa do instrumento para ROTULAR ",
             "a coluna monetaria (a identificacao vem da nao-gaussianidade)")
      }
    },
    "proxy" = {
      if (is.null(instrument) && !is.null(dfm_results$instrument)) {
        instrument <- dfm_results$instrument
      }
      if (is.null(instrument)) {
        stop("instrument deve ser fornecido diretamente ou via dfm_results$instrument")
      }
    },
    stop("identification desconhecida: ", identification)
  )

  ci_levels <- sort(unique(as.numeric(ci_levels)))
  if (length(ci_levels) == 0 || any(is.na(ci_levels)) ||
      any(ci_levels <= 0) || any(ci_levels >= 1)) {
    stop("ci_levels deve conter niveis entre 0 e 1 (ex: c(0.90, 0.95))")
  }

  if (is.null(tcode) && !is.null(dfm_results$tcode)) {
    tcode <- dfm_results$tcode
  }
  if (is.null(tcode)) {
    tcode <- rep(1L, n_vars)
  }

  # --- Parsear instrumento (ramo proxy, e nongaussian para rotulagem) ---
  rsh_sel_ind <- NULL
  inst_sel    <- NULL
  if (identification %in% c("proxy", "nongaussian")) {
    if (is.data.frame(instrument)) {
      if (!all(c("month", "shock") %in% names(instrument)))
        stop("Instrument data.frame deve conter colunas 'month' e 'shock'")

      dates_vec <- data_dates
      if (is.null(dates_vec) && !is.null(dfm_results$dates))
        dates_vec <- dfm_results$dates
      if (is.null(dates_vec))
        stop("data_dates ou dfm_results$dates necessario para alinhamento temporal")

      dates_vec <- as.Date(dates_vec)
      align     <- sel_ext_inst_sample(dates_vec, p, instrument)
      rsh_sel_ind <- align$rsh_sel_ind
      inst_sel    <- align$inst_sel

      if (sum(rsh_sel_ind) == 0)
        stop("Nenhuma data comum entre instrumento e residuos do VAR")
    } else if (is.numeric(instrument)) {
      n_resid <- nrow(dfm_results$var_residuals)
      if (length(instrument) != n_resid)
        stop("Vetor de instrumento (", length(instrument),
             ") deve ter mesmo comprimento que residuos do VAR (", n_resid, ")")
      rsh_sel_ind <- rep(TRUE, n_resid)
      inst_sel    <- instrument
    } else {
      stop("instrument deve ser vetor numerico ou data.frame com colunas 'month' e 'shock'")
    }
  }

  # --- Matrizes B de propagação (companion OLS, sem Kilian) ---
  Bfull <- array(0, dim = c(rp, rp, h + 1))
  Bfull[, , 1] <- diag(rp)
  Bfull[, , 2] <- A
  for (i in 3:(h + 1)) Bfull[, , i] <- Bfull[, , i - 1] %*% A

  B <- array(0, dim = c(r, r, h + 1))
  for (i in seq_len(h + 1)) B[, , i] <- Bfull[1:r, 1:r, i]

  # --- IRFs de forma reduzida (rawimp) ---
  rawimp <- array(0, dim = c(n_vars, q, h + 1))
  for (i in seq_len(h + 1)) {
    if (!is.matrix(K) && !is.matrix(M)) {
      temp <- Re(Lambda %*% B[, , i] * K * M)
    } else {
      temp <- Re(Lambda %*% B[, , i] %*% K %*% M)
    }
    rawimp[, , i] <- sweep(temp, 1, sy, "*")
  }

  # --- Resíduos de fatores dinâmicos: eta = u * K / M ---
  u <- dfm_results$var_residuals  # resíduos OLS (sem Kilian)
  if (!is.matrix(K) && !is.matrix(M)) {
    eta <- u
  } else {
    eta <- u %*% K %*% solve(M)
  }

  # --- Identificação (estimativa pontual) ---
  if (identification == "het") {
    point_result <- ident_het_regimes(rawimp, eta, regime_labels, h,
                                      mpind, normalize_value, tcode,
                                      weight = het_weight,
                                      diagnose = diagnose,
                                      var_names = var_names)
    b_point <- point_result$b
  } else if (identification == "nongaussian") {
    # A identificação usa TODAS as linhas de eta (a não-gaussianidade é a fonte);
    # rsh_sel_ind só seleciona as linhas que casam com o instrumento, e serve
    # apenas para rotular a coluna.
    point_result <- ident_nongaussian(rawimp, eta, h,
                                      mpind = mpind,
                                      normalize_value = normalize_value,
                                      tcode = tcode,
                                      z = inst_sel, sel = rsh_sel_ind,
                                      distri = ng_distri,
                                      n_starts = ng_starts,
                                      diagnose = diagnose,
                                      var_names = var_names)
    b_point  <- point_result$b
    C_point  <- point_result$C
    a_point  <- point_result$a
    col_mp   <- point_result$col_mp
  } else {
    eta_sel <- eta[rsh_sel_ind, , drop = FALSE]
    point_result <- ident_ext_instr(rawimp, eta_sel, inst_sel, h,
                                    mpind, normalize_value, tcode,
                                    diagnose = diagnose,
                                    var_names = var_names)
  }
  irf_point <- point_result$irf_mp

  # --- Wild Bootstrap (Gertler & Karadi 2015 / DFMest_BLL_Boot.m) ---
  if (nboot > 0) {
    # Componentes para bootstrap DGP (Kilian-corrigidos, se disponíveis)
    # Seguindo DFMest_BLL_Boot.m: DGP usa coeficientes corrigidos + resíduos OLS
    boot_coeffs <- dfm_results$var_coefficients_corrected
    if (is.null(boot_coeffs)) {
      boot_coeffs <- dfm_results$var_coefficients
    }
    # Resíduos OLS originais para wild bootstrap (DFMest_BLL_Boot.m linha 57)
    boot_resids <- dfm_results$var_residuals_original
    if (is.null(boot_resids)) {
      boot_resids <- dfm_results$var_residuals
    }

    # Calcular Idio (componente idiossincrático)
    Chi <- sweep(dfm_results$static_factors %*% t(dfm_results$static_loadings), 2, sy, "*")
    Idio <- dfm_results$detrended_data - Chi

    irf_boot <- array(0, dim = c(n_vars, h + 1, nboot))

    # Diagnósticos por draw do ramo het (sinal/identidade do choque):
    # impacto pré-normalização na variável de política (denominador da
    # normalização) e |cos| entre o b do draw e o b do ponto (label
    # switching por cruzamento de autovalores). Ver plano het-primária.
    het_boot_impact <- if (identification == "het") rep(NA_real_, nboot) else NULL
    het_boot_cos    <- if (identification == "het") rep(NA_real_, nboot) else NULL
    ng_boot_cos     <- if (identification == "nongaussian") rep(NA_real_, nboot) else NULL
    ng_boot_switch  <- if (identification == "nongaussian") rep(NA, nboot) else NULL

    for (b in seq_len(nboot)) {
      tryCatch({
        # Esquema de reamostragem por ramo.
        #
        # proxy/het: wild bootstrap Rademacher (Gonçalves-Kilian 2004).
        #
        # nongaussian: NÃO pode usar Rademacher. O multiplicador ±1 zera todos
        # os terceiros momentos (E[u³r³] = E[u³]E[r³] = 0), e a assimetria é
        # exatamente o que a Assumption A.5 do GMR exige para o máximo global
        # ser único — o DGP do bootstrap viraria um mundo simetrizado onde o
        # ICA é muito menos identificado. Usa-se reamostragem i.i.d. com
        # reposição, que preserva a distribuição marginal dos resíduos; é o que
        # o apêndice online do próprio GMR (§E) e `IdSS::nonparam.bootstrap`
        # fazem.
        n_resid <- nrow(boot_resids)
        if (identification == "nongaussian") {
          idx_boot   <- sample.int(n_resid, n_resid, replace = TRUE)
          resid_boot <- boot_resids[idx_boot, , drop = FALSE]
          rr <- NULL
        } else {
          rr <- 1 - 2 * (runif(n_resid) > 0.5)
          resid_boot <- boot_resids * rr  # resíduos OLS * rr
        }

        # Reconstruir fatores com coeficientes corrigidos e resíduos OLS
        F_boot <- matrix(0, nrow = nrow(dfm_results$static_factors), ncol = r)
        F_boot[1:p, ] <- dfm_results$static_factors[1:p, ]

        for (tt in (p + 1):nrow(F_boot)) {
          lagged_vars <- as.vector(t(F_boot[(tt - 1):(tt - p), ]))
          F_boot[tt, ] <- c(lagged_vars, 1) %*% boot_coeffs +
            resid_boot[tt - p, ]
        }

        # Reconstruir X_boot
        Chi_boot <- sweep(F_boot %*% t(Lambda), 2, sy, "*")
        X_boot <- Chi_boot + Idio

        # Re-estimar SEM Kilian (fiel a DFMest_BLL.m chamado em DFMest_BLL_Boot.m:69)
        suppressWarnings({
          dfm_boot <- estimate_dfm(X_boot, r, q, p, apply_kilian = FALSE)
        })

        Lambda_boot <- dfm_boot$static_loadings
        A_boot <- dfm_boot$companion_matrix  # OLS, sem Kilian
        K_boot <- dfm_boot$dynamic_loadings
        M_boot <- dfm_boot$dynamic_scaling
        sy_boot <- dfm_boot$data_sd
        u_boot <- dfm_boot$var_residuals  # OLS, sem Kilian

        # Matrizes B bootstrapadas
        rp_boot <- nrow(A_boot)
        Bfull_b <- array(0, dim = c(rp_boot, rp_boot, h + 1))
        Bfull_b[, , 1] <- diag(rp_boot)
        if (h >= 1) Bfull_b[, , 2] <- A_boot
        for (i in 3:(h + 1))
          Bfull_b[, , i] <- Bfull_b[, , i - 1] %*% A_boot

        B_boot <- array(0, dim = c(r, r, h + 1))
        for (i in seq_len(h + 1))
          B_boot[, , i] <- Bfull_b[1:r, 1:r, i]

        # IRFs de forma reduzida bootstrapadas
        rawimp_boot <- array(0, dim = c(n_vars, q, h + 1))
        for (i in seq_len(h + 1)) {
          if (!is.matrix(K_boot) && !is.matrix(M_boot)) {
            temp <- Re(Lambda_boot %*% B_boot[, , i] * K_boot * M_boot)
          } else {
            temp <- Re(Lambda_boot %*% B_boot[, , i] %*% K_boot %*% M_boot)
          }
          rawimp_boot[, , i] <- sweep(temp, 1, sy_boot, "*")
        }

        # Resíduos de fatores dinâmicos bootstrapados
        if (!is.matrix(K_boot) && !is.matrix(M_boot)) {
          eta_boot <- u_boot
        } else {
          eta_boot <- u_boot %*% K_boot %*% solve(M_boot)
        }

        # Identificação bootstrapada
        if (identification == "het") {
          # Labels de regime fixos (calendário exógeno); o multiplicador
          # Rademacher preserva os segundos momentos por observação, então
          # a estrutura de covariância por regime sobrevive ao draw.
          boot_result <- ident_het_regimes(rawimp_boot, eta_boot,
                                           regime_labels, h,
                                           mpind, normalize_value, tcode)
          het_boot_impact[b] <- boot_result$impact_pre
          het_boot_cos[b] <- abs(sum(boot_result$b * b_point)) /
            sqrt(sum(boot_result$b^2) * sum(b_point^2))
        } else if (identification == "nongaussian") {
          # Warm start no ponto estimado: mantém o draw na mesma bacia do
          # ótimo (o objetivo tem muitos ótimos locais) e barateia a busca.
          # `C_ref` + `col_mp` fixam o rótulo, resolvendo o label switching.
          boot_result <- ident_nongaussian(rawimp_boot, eta_boot, h,
                                           mpind = mpind,
                                           normalize_value = normalize_value,
                                           tcode = tcode,
                                           C_ref = C_point, col_mp = col_mp,
                                           distri = ng_distri,
                                           n_starts = ng_boot_starts,
                                           a_init = a_point)
          ng_boot_cos[b] <- abs(sum(boot_result$b * b_point)) /
            sqrt(sum(boot_result$b^2) * sum(b_point^2))
          ng_boot_switch[b] <- boot_result$col_mp != col_mp
        } else {
          # Wild bootstrap do instrumento (mesmo rr)
          rr_sel <- rr[rsh_sel_ind]
          inst_boot <- inst_sel * rr_sel

          eta_boot_sel <- eta_boot[rsh_sel_ind, , drop = FALSE]
          boot_result <- ident_ext_instr(rawimp_boot, eta_boot_sel, inst_boot,
                                         h, mpind, normalize_value, tcode)
        }
        irf_boot[, , b] <- boot_result$irf_mp

      }, error = function(e) {
        warning("Bootstrap iteracao ", b, " falhou: ", e$message)
        irf_boot[, , b] <<- irf_point
      })
    }

    # Validação do bootstrap
    bootstrap_validation <- validate_bootstrap_results(irf_boot, irf_point)

    # Intervalos de confianca
    ci <- list()
    for (lvl in ci_levels) {
      alpha <- (1 - lvl) / 2
      name <- sprintf("%.2f", lvl)
      ci[[name]] <- list(
        level = lvl,
        lower = apply(irf_boot, c(1, 2), quantile, probs = alpha, na.rm = TRUE),
        upper = apply(irf_boot, c(1, 2), quantile, probs = 1 - alpha, na.rm = TRUE)
      )
    }
  } else {
    ci <- list()
    for (lvl in ci_levels) {
      name <- sprintf("%.2f", lvl)
      ci[[name]] <- list(
        level = lvl,
        lower = irf_point,
        upper = irf_point
      )
    }
  }

  irf_point_3d <- array(0, dim = c(n_vars, h + 1, 1))
  irf_point_3d[, , 1] <- irf_point

  out <- list(
    irf_point = irf_point_3d,
    irf_point_matrix = irf_point,
    ci = ci,
    ci_levels = ci_levels,
    identification = identification
  )

  if (identification == "nongaussian") {
    out$b_point  <- point_result$b
    out$ng_point <- list(
      C          = point_result$C,
      a          = point_result$a,
      col_mp     = point_result$col_mp,
      impact_pre = point_result$impact_pre,
      eps        = point_result$eps,
      label      = point_result$label,
      logLik     = point_result$fit$logLik,
      n_at_best  = point_result$fit$n_at_best,
      converged  = point_result$fit$converged,
      all_C      = point_result$fit$all_C,
      obj_by_start = point_result$fit$obj_by_start
    )
    if (nboot > 0) {
      out$ng_boot <- list(
        cos_theta      = ng_boot_cos,
        label_switched = ng_boot_switch,
        frac_low_cos   = mean(ng_boot_cos < 0.7, na.rm = TRUE),
        median_cos     = stats::median(ng_boot_cos, na.rm = TRUE)
      )
    }
  }

  if (identification == "het") {
    out$b_point     <- point_result$b
    out$het_point   <- point_result[c("lambda_all", "rank1_share",
                                      "impact_pre", "n_C", "n_NC", "md_fit")]
    if (nboot > 0) {
      out$het_boot <- list(
        impact_pre      = het_boot_impact,
        cos_theta       = het_boot_cos,
        frac_small_den  = mean(abs(het_boot_impact) <
                                 0.1 * abs(point_result$impact_pre),
                               na.rm = TRUE),
        frac_low_cos    = mean(het_boot_cos < 0.7, na.rm = TRUE)
      )
    }
  }

  out
}


# ===================================================================
# PLOT DE IRFs
# ===================================================================
plot_irf <- function(irf_results, response_vars, shock = 1, horizon = 20,
                     cumulative = FALSE, invert_shock = FALSE,
                     var_names = NULL, tcode = NULL,
                     ci_to_plot = c(0.90, 0.95)) {

  if (isTRUE(cumulative)) {
    warning("IRFs ja estao em unidades economicas via tcode (cumimp). 'cumulative' sera ignorado.")
  }

  if (!is.list(irf_results) || is.null(irf_results$irf_point_matrix)) {
    stop("plot_irf agora espera o objeto completo retornado por compute_irf_dfm (lista com irf_point_matrix e ci)")
  }

  point <- irf_results$irf_point_matrix
  ci_obj <- irf_results$ci
  n_vars <- nrow(point)
  max_h <- ncol(point) - 1
  horizon <- min(horizon, max_h)

  if (is.null(var_names)) {
    var_names <- as.character(seq_len(n_vars))
  }

  if (invert_shock) {
    point <- -point
    for (nm in names(ci_obj)) {
      lo <- ci_obj[[nm]]$lower
      hi <- ci_obj[[nm]]$upper
      ci_obj[[nm]]$lower <- -hi
      ci_obj[[nm]]$upper <- -lo
    }
  }

  ci_to_plot <- sort(unique(as.numeric(ci_to_plot)), decreasing = TRUE)
  ci_keys <- sprintf("%.2f", ci_to_plot)
  missing_ci <- setdiff(ci_keys, names(ci_obj))
  if (length(missing_ci) > 0) {
    stop("Niveis de IC solicitados nao encontrados no objeto irf_results$ci: ",
         paste(missing_ci, collapse = ", "))
  }

  fill_palette <- c("grey90", "grey80", "grey70", "grey60")
  alpha_palette <- c(0.5, 0.45, 0.4, 0.35)

  plot_list <- list()

  for (i in seq_along(response_vars)) {
    var_spec <- response_vars[[i]]
    var_label <- names(var_spec)

    if (is.numeric(var_spec)) {
      var_index <- as.integer(var_spec)
    } else if (is.character(var_spec)) {
      var_index <- match(var_spec, var_names)
      if (is.na(var_index)) {
        stop("Variavel '", var_spec, "' nao encontrada em var_names")
      }
      if (length(var_label) == 0 || is.null(var_label)) {
        var_label <- var_spec
      }
    } else {
      stop("Cada item de response_vars deve ser numerico (indice) ou character (nome)")
    }

    if (var_index < 1 || var_index > n_vars) {
      stop("Indice de variavel fora do limite: ", var_index, " (1..", n_vars, ")")
    }

    if (length(var_label) == 0 || is.null(var_label) || identical(var_label, "")) {
      var_label <- var_names[var_index]
    }

    df_point <- data.frame(
      tempo = seq_len(horizon + 1) - 1,
      irf = point[var_index, seq_len(horizon + 1)]
    )

    p <- ggplot2::ggplot(df_point, ggplot2::aes(x = tempo))

    for (k in seq_along(ci_keys)) {
      key <- ci_keys[k]
      ci_k <- ci_obj[[key]]
      df_ci <- data.frame(
        tempo = seq_len(horizon + 1) - 1,
        lower = ci_k$lower[var_index, seq_len(horizon + 1)],
        upper = ci_k$upper[var_index, seq_len(horizon + 1)]
      )

      p <- p + ggplot2::geom_ribbon(
        data = df_ci,
        ggplot2::aes(ymin = lower, ymax = upper),
        fill = fill_palette[min(k, length(fill_palette))],
        alpha = alpha_palette[min(k, length(alpha_palette))]
      )
    }

    p <- p +
      ggplot2::geom_line(ggplot2::aes(y = irf), color = "black", linewidth = 1) +
      ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      ggplot2::theme_classic() +
      ggplot2::labs(y = var_label) +
      ggplot2::theme(
        axis.title.x = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_text(size = ggplot2::rel(1.4)),
        axis.text = ggplot2::element_text(size = ggplot2::rel(1.2)),
        plot.title = ggplot2::element_blank()
      )

    plot_list[[i]] <- p
  }

  patchwork::wrap_plots(plot_list, ncol = 2)
}


# ===================================================================
# FUNÇÕES AUXILIARES
# ===================================================================




validate_dfm_results <- function(dfm_results) {
  checks <- list()

  required_components <- c(
    "static_loadings", "companion_matrix",
    "dynamic_loadings", "dynamic_scaling",
    "data_sd", "p", "r", "q"
  )
  checks$missing_components <- setdiff(required_components, names(dfm_results))

  q <- dfm_results$q
  r <- dfm_results$r
  K <- dfm_results$dynamic_loadings
  M <- dfm_results$dynamic_scaling

  if (q == r) {
    checks$qr_case_K_scalar <- !is.matrix(K) && length(K) == 1
    checks$qr_case_M_scalar <- !is.matrix(M) && length(M) == 1
    checks$qr_case_K_equals_1 <- K == 1
    checks$qr_case_M_equals_1 <- M == 1
  } else {
    checks$qr_case_K_matrix <- is.matrix(K) && ncol(K) == q
    checks$qr_case_M_matrix <- is.matrix(M) && ncol(M) == q
  }

  eigenvals <- eigen(dfm_results$companion_matrix)$values
  checks$companion_stable <- all(abs(eigenvals) < 1)
  checks$max_eigenvalue   <- max(abs(eigenvals))

  checks
}


validate_bootstrap_results <- function(irf_boot, irf_point) {
  n_vars <- dim(irf_boot)[1]
  h      <- dim(irf_boot)[2] - 1
  nboot  <- dim(irf_boot)[3]

  failed_iterations <- 0
  for (b in seq_len(nboot)) {
    if (all(irf_boot[, , b] == irf_point)) {
      failed_iterations <- failed_iterations + 1
    }
  }

  bootstrap_stats <- list(
    total_iterations   = nboot,
    failed_iterations  = failed_iterations,
    success_rate       = (nboot - failed_iterations) / nboot,
    mean_abs_irf       = mean(abs(irf_boot), na.rm = TRUE),
    bootstrap_variance = var(as.vector(irf_boot), na.rm = TRUE)
  )

  if (failed_iterations > nboot * 0.1) {
    warning("Mais de 10% das iteracoes do bootstrap falharam. Considere ajustar os parametros.")
  }

  bootstrap_stats
}
