# ===================================================================
# FUNÇÕES DE IMPULSO-RESPOSTA (IRF) PARA MODELO DFM
# IDENTIFICAÇÃO VIA INSTRUMENTO EXTERNO (PROXY SVAR)
# Seguindo Alessi & Kerssenfischer / Gertler & Karadi (2015)
# ===================================================================


#' Align the external instrument to the factor-VAR residuals
#'
#' Equivalent to MATLAB `selextinstsample.m`. The residuals start at `p + 1`,
#' so the instrument has to be matched against `data_dates[(p+1):T]` and not
#' against the raw panel dates — getting this offset wrong shifts the whole
#' identification by `p` months. Part of the identification contract; see
#' `.claude/rules/identification.md`.
#'
#' @param data_dates Date vector of the estimation panel.
#' @param p Factor-VAR lag order.
#' @param instrument_df Data.frame with columns `month` (Date) and `shock`.
#' @param rr Optional numeric weights applied to the selected instrument.
#'
#' @return List with `rsh_sel_ind` (logical index into the residuals) and
#'   `inst_sel` (the instrument on the common months).
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
#' decimal proportion. See `registro/justificativa_uso_yield-6m.md`.
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
#'   pre-normalization impact response, and the MOSW relevance statistics.
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
    c_mp       <- as.numeric(rawimp[mpind, , 1])
    eta_mp     <- as.numeric(rsh_mean0 %*% c_mp)
    xi_mp      <- compute_factor_space_wald(eta_mp, Z_mat)$wald_joint
    f_robust_mp <- compute_robust_first_stage_F(eta_mp, Z_mat)$f_statistic

    cat("\n========== ident_ext_instr DIAGNOSTIC ==========\n")
    cat(sprintf("H (factor-space loadings, length %d):\n", length(H)))
    cat(sprintf("  %s\n", paste(sprintf("%.4e", H), collapse = "  ")))
    cat(sprintf("irf_mp[mpind=%d, 1] (pre-norm) = %.4e   sign = %s\n",
                mpind, impact_pre,
                if (impact_pre > 0) "POSITIVE" else if (impact_pre < 0) "NEGATIVE" else "ZERO"))
    cat(sprintf("MOSW xi_mp in the normalization direction = %.3f\n", xi_mp))
    cat(sprintf("MOSW robust first-stage F_mp (HC1) = %.3f\n", f_robust_mp))
    cat("      [no lag controls here — instrument_diagnostics.R reports the\n")
    cat("      Shat-corrected version with factor-VAR lags residualized out]\n")
    if (xi_mp < 10 || f_robust_mp < 10) {
      cat("[!!!] WARNING: relevance in the normalization direction is below 10.\n")
      cat("      Conventional IRF bands require weak-instrument caution.\n")
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


#' Robust first-stage F in the policy-variable normalization direction
#'
#' Regresses the factor-implied innovation of the policy variable on the
#' external instrument and the factor-VAR controls. The statistic is the
#' squared robust t-statistic on the instrument. HC1 reproduces the finite-
#' sample convention behind the first-stage F reported by Montiel Olea, Stock
#' and Watson; positive `nw_lags` use a Bartlett Newey-West covariance.
#'
#' @param target_innovation Numeric vector `c_mp' eta_t` aligned with `Z`.
#' @param Z Instrument vector or one-column matrix.
#' @param controls Optional matrix/data.frame of factor-VAR regressors. A
#'   constant is added by the regression.
#' @param nw_lags Newey-West truncation lag. Zero uses HC1.
#'
#' @return List with `f_statistic`, `beta`, `se`, `p_value`, `n_obs`, and
#'   `nw_lags`.
compute_robust_first_stage_F <- function(target_innovation, Z,
                                         controls = NULL, nw_lags = 0L) {
  if (!requireNamespace("sandwich", quietly = TRUE)) {
    stop("Package 'sandwich' is required for the robust first-stage F")
  }

  y <- as.numeric(target_innovation)
  z <- as.numeric(Z)
  if (length(y) != length(z)) {
    stop("target_innovation and Z must have the same length")
  }
  if (any(!is.finite(y)) || any(!is.finite(z))) {
    stop("target_innovation and Z must contain only finite values")
  }
  if (sd(z) == 0) stop("Z must vary in the effective sample")

  nw_lags <- as.integer(nw_lags)
  if (is.na(nw_lags) || nw_lags < 0L || nw_lags >= length(z)) {
    stop("nw_lags must be a non-negative integer smaller than the sample size")
  }

  regression_data <- data.frame(y = y, z = z)
  if (!is.null(controls)) {
    controls <- as.matrix(controls)
    if (nrow(controls) != length(z) || any(!is.finite(controls))) {
      stop("controls must be finite and aligned with target_innovation and Z")
    }
    colnames(controls) <- paste0("control_", seq_len(ncol(controls)))
    regression_data <- cbind(regression_data, controls)
  }

  fit <- lm(y ~ ., data = regression_data)
  covariance <- if (nw_lags == 0L) {
    sandwich::vcovHC(fit, type = "HC1")
  } else {
    sandwich::NeweyWest(fit, lag = nw_lags, prewhite = FALSE, adjust = TRUE)
  }

  beta <- unname(coef(fit)["z"])
  se   <- sqrt(covariance["z", "z"])
  f_statistic <- (beta / se)^2

  list(
    f_statistic = f_statistic,
    beta        = beta,
    se          = se,
    p_value     = pf(f_statistic, df1 = 1, df2 = df.residual(fit),
                     lower.tail = FALSE),
    n_obs       = nobs(fit),
    nw_lags     = nw_lags
  )
}


#' Montiel Olea-Stock-Watson Wald statistics for instrument relevance in factor space
#'
#' Implements the relevance diagnostics of Montiel Olea, Stock & Watson
#' (2021, J. Econometrics, sec. 4.2) against the q factor innovations:
#'
#' The scalar case supplies `xi_mp`, the Wald statistic in the policy-variable
#' normalization direction used by Montiel Olea, Stock and Watson.
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
#' The vector-valued output remains available for internal validation and
#' HAC calculations, but the project's reported relevance diagnostics are
#' the scalar `xi_mp` and its matching robust first-stage F.
#'
#' @param eta Matrix of factor innovations (T x q).
#' @param Z Instrument vector or column matrix (T x 1), aligned to eta.
#' @param controls Optional matrix/data.frame of VAR regressors aligned to eta
#'   (lags of the factors; a constant is added internally).
#' @param nw_lags Newey-West truncation lag for W. The default 0 is the
#'   Eicker-White estimator and reproduces `NWlags = 0` of the oil application
#'   (`codigos_externos/codigo_olea/OilSVARIV.m:50`), which is what every existing caller and
#'   every published number in this project assume. Values > 0 apply the
#'   Bartlett kernel of `codigos_externos/codigo_olea/functions/RForm/NW_hac_STATA.m`. Only
#'   needed when the moment z_t eta_t is serially correlated — e.g. under a
#'   Gertler-Karadi position-weighted monthly aggregation, which splits each
#'   event surprise across t and t+1 and so induces an MA(1). The official
#'   suite uses `NWlags = 8` in the tax application (`TaxSVARIV.m:52`).
#'
#' @return List with `wald_k` (length-q vector), `wald_joint`, `q`, `T_eff`,
#'   and `nw_lags`. Vector-valued fields are internal inputs to scalar
#'   projections and validation checks, not reported strength diagnostics.
compute_factor_space_wald <- function(eta, Z, controls = NULL, nw_lags = 0L) {
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

  # Bartlett accumulation, transcribed from NW_hac_STATA.m: weight
  # 1 - n/(lags+1), divisor T (no degrees-of-freedom correction), and
  # lags = 0 collapses exactly to the Eicker-White W above.
  nw_lags <- as.integer(nw_lags)
  if (is.na(nw_lags) || nw_lags < 0L) {
    stop("nw_lags must be a non-negative integer")
  }
  if (nw_lags >= T_eff) {
    stop("nw_lags (", nw_lags, ") must be smaller than T_eff (", T_eff, ")")
  }
  for (l in seq_len(nw_lags)) {
    Gl <- crossprod(V[seq_len(T_eff - l), , drop = FALSE],
                    V[(1L + l):T_eff, , drop = FALSE]) / T_eff
    W  <- W + (1 - l / (nw_lags + 1)) * (Gl + t(Gl))
  }

  wald_k     <- T_eff * Gamma^2 / diag(W)
  wald_joint <- tryCatch(
    T_eff * drop(t(Gamma) %*% solve(W, Gamma)),
    error = function(e) NA_real_
  )

  list(
    wald_k     = wald_k,
    wald_joint = wald_joint,
    q          = q,
    T_eff      = T_eff,
    nw_lags    = nw_lags
  )
}


#' Put raw IRFs into economic units according to tcode
#'
#' Codes 1-5 are `cumimp.m`: 1 = level, 2 = first difference, 3 = second
#' difference, 4 = log-level, 5 = first log-difference. Code **6 has no
#' counterpart in AK** and is this project's: a monthly return put on the
#' percent scale (`x * 100`) **without** accumulating. It exists because the
#' asset block enters the panel as a monthly return and the `cumsum` of code 2
#' was integrating the sampling error along with the signal — see
#' `registro/pendencias.md`, Tema E.
#' Note that **tcode 1 does not multiply by 100** — a trap documented in
#' `.claude/rules/identification.md`.
#'
#' @param Imp Matrix of raw IRFs (vars x horizons).
#' @param tcode Integer vector of transformation codes, one per variable;
#'   defaults to all 1.
#'
#' @return Matrix of the same shape, in economic units.
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
  pctnocum <- which(tcode == 6)

  if (length(notransf) > 0) {
    CC[notransf, ] <- Imp[notransf, ]
  }
  if (length(pctnocum) > 0) {
    CC[pctnocum, ] <- Imp[pctnocum, , drop = FALSE] * 100
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
# - asset_*               -> tcode = 6 (retorno mensal em %, sem acumular)
# ===================================================================
#' Assign transformation codes from panel variable names
#'
#' @param var_names Character vector of panel column names.
#'
#' @return Integer vector of tcodes aligned to `var_names`.
infer_tcode_from_varnames <- function(var_names) {
  tcode <- rep(1L, length(var_names))

  loglevel_idx <- grepl("^base_", var_names) |
    grepl("^credit", var_names) |
    grepl("^credito_", var_names) |
    var_names %in% c("fin_inst_reserve_req", "pib")

  tcode[loglevel_idx] <- 4L

  # asset_* são retornos mensais (download.R: prod(1+r)-1), não níveis.
  # Até 2026-08-17 usavam tcode = 2, que acumula a IRF para recuperar a resposta
  # de NÍVEL de preço. O nível é o objeto teórico, mas o cumsum integrava o erro
  # de estimação junto com o sinal: a razão de largura de banda h36/h0 chegava a
  # 10,46 nos 8 índices e o Ibovespa ganhava um pico de +20,3% em h≈24 que é
  # ruído acumulado. O código 6 põe a resposta na escala percentual sem acumular.
  # Em h=0 o cumsum é no-op e o x100 é escalar positivo, de modo que ponto e
  # bandas no impacto são INVARIANTES à troca.
  tcode[grepl("^asset_", var_names)] <- 6L

  tcode
}


#' Impulse responses of the DFM, identified and with bootstrap bands
#'
#' The main entry point of the identification stage. Identification is by
#' external instrument (Gertler-Karadi / Alessi-Kerssenfischer) — the single
#' branch since the heteroskedasticity and non-Gaussian routes were abandoned on
#' 2026-08-17 (`arquivo/heterocedasticidade/`, `arquivo/nao_gaussiana/`).
#'
#' The point estimate uses the plain OLS companion; the wild bootstrap DGP uses
#' the Kilian-corrected one, with Rademacher multipliers (Gonçalves-Kilian 2004).
#'
#' @param dfm_results List returned by `estimate_dfm()`.
#' @param instrument Optional instrument data.frame; normally already embedded
#'   in `dfm_results` by the alignment stage.
#' @param h Maximum horizon.
#' @param nboot Number of bootstrap draws; 0 skips the band stage.
#' @param bootstrap_seed Optional integer seed.
#' @param mpind Column index of the monetary-policy variable used for
#'   normalization.
#' @param normalize_value Impact response imposed on the policy variable, in its
#'   native units (0.005 for a +50bp shock on a decimal-proportion yield).
#' @param data_dates Optional Date vector of the panel.
#' @param tcode Integer vector of transformation codes, one per variable.
#' @param ci_levels Confidence levels for the bootstrap bands.
#' @param diagnose When TRUE, attaches first-stage and factor-space diagnostics.
#' @param var_names Character vector of panel column names.
#' @param identification Identification branch; `"proxy"` is the only one.
#'
#' @return List with `irf_point_matrix` (vars x horizons), `ci` (one entry per
#'   level, each with `lower`/`upper`), the raw bootstrap array and diagnostics.
compute_irf_dfm <- function(dfm_results, instrument = NULL, h = 24, nboot = 300,
                            bootstrap_seed = NULL, mpind = NULL,
                            normalize_value = 0.5, data_dates = NULL,
                            tcode = NULL, ci_levels = c(0.90, 0.95),
                            diagnose = getOption("dfm.irf.diagnose", FALSE),
                            var_names = NULL,
                            identification = "proxy") {

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
  if (is.null(instrument) && !is.null(dfm_results$instrument)) {
    instrument <- dfm_results$instrument
  }
  if (is.null(instrument)) {
    stop("instrument deve ser fornecido diretamente ou via dfm_results$instrument")
  }

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

  # --- Parsear instrumento ---
  rsh_sel_ind <- NULL
  inst_sel    <- NULL
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
  eta_sel <- eta[rsh_sel_ind, , drop = FALSE]
  point_result <- ident_ext_instr(rawimp, eta_sel, inst_sel, h,
                                  mpind, normalize_value, tcode,
                                  diagnose = diagnose,
                                  var_names = var_names)
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

    for (b in seq_len(nboot)) {
      tryCatch({
        # Wild bootstrap Rademacher (Gonçalves-Kilian 2004).
        n_resid <- nrow(boot_resids)
        rr <- 1 - 2 * (runif(n_resid) > 0.5)
        resid_boot <- boot_resids * rr  # resíduos OLS * rr

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

        # Identificação bootstrapada — wild bootstrap do instrumento (mesmo rr)
        rr_sel <- rr[rsh_sel_ind]
        inst_boot <- inst_sel * rr_sel

        eta_boot_sel <- eta_boot[rsh_sel_ind, , drop = FALSE]
        boot_result <- ident_ext_instr(rawimp_boot, eta_boot_sel, inst_boot,
                                       h, mpind, normalize_value, tcode)
        irf_boot[, , b] <- boot_result$irf_mp

      }, error = function(e) {
        warning("Bootstrap iteracao ", b, " falhou: ", e$message)
        irf_boot[, , b] <<- irf_point
      })
    }

    # Validação do bootstrap: chamada pelo warning, o retorno não é consumido
    validate_bootstrap_results(irf_boot, irf_point)

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

  out
}


#' Plot IRFs with shaded bootstrap bands, paper style
#'
#' @param irf_results Full list returned by `compute_irf_dfm()`.
#' @param response_vars List of named variables (or indices) to draw.
#' @param shock Retained for signature compatibility; a single shock is drawn.
#' @param horizon Maximum horizon on the x axis.
#' @param cumulative Ignored — IRFs already arrive in economic units via
#'   `cumimp_transform()`; passing TRUE only raises a warning.
#' @param invert_shock When TRUE, flips the sign of the plotted response.
#' @param var_names Character vector of panel column names.
#' @param tcode Retained for signature compatibility; units come from
#'   `irf_results`, already transformed.
#' @param ci_to_plot Confidence levels to shade.
#'
#' @return A patchwork of ggplot2 panels.
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




#' Check that a fitted DFM carries every component the IRF stage needs
#'
#' Structural check only — it does not judge the estimates. The `q == r` branch
#' matters because the dynamic reduction degenerates to scalars there, and code
#' downstream that assumes matrices would fail silently.
#'
#' @param dfm_results List returned by `estimate_dfm()`.
#'
#' @return List of checks, including `missing_components`.
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


#' Warn when wild-bootstrap draws collapse onto the point estimate
#'
#' A draw that reproduces `irf_point` exactly means the replication failed and
#' fell back to the point IRF, so the bands it feeds are too narrow. Called for
#' its `warning()`; the returned stats are diagnostic.
#'
#' @param irf_boot Array (vars x horizons x draws) of bootstrap IRFs.
#' @param irf_point Matrix (vars x horizons) of the point IRF.
#'
#' @return List with total_iterations, failed_iterations, success_rate,
#'   mean_abs_irf and bootstrap_variance.
validate_bootstrap_results <- function(irf_boot, irf_point) {
  nboot <- dim(irf_boot)[3]

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
