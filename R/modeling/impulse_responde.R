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
ident_ext_instr <- function(rawimp, rsh_sel, Z_sel, h,
                            mpind = NULL, normalize_value = 0.5,
                            tcode = NULL) {
  # Desmeanar choques de forma reduzida
  rsh_mean0 <- sweep(rsh_sel, 2, colMeans(rsh_sel))

  # Regressão OLS do instrumento nos choques: H = (Z \ rsh_mean0)'
  Z_mat <- as.matrix(Z_sel)
  H <- drop(crossprod(Z_mat, rsh_mean0)) / drop(crossprod(Z_mat))

  n_vars <- dim(rawimp)[1]
  irf_mp <- matrix(0, n_vars, h + 1)

  for (j in seq_len(h + 1)) {
    rawimp_j <- matrix(rawimp[, , j], nrow = n_vars)
    irf_mp[, j] <- rawimp_j %*% H
  }

  # Normalizar efeito impacto na variável de política monetária
  if (!is.null(mpind)) {
    irf_mp <- irf_mp / irf_mp[mpind, 1] * normalize_value
  }

  # Transformar IRFs para unidades econômicas (como em IdentExtInstr.m)
  irf_mp_transformed <- cumimp_transform(irf_mp, tcode)

  list(irf_mp = irf_mp_transformed, irf_mp_raw = irf_mp, H = H)
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
# Não-padrão (transformadas por log no clean):
# - base_*                -> tcode = 4 (log-level)
# - credit* / credito_*   -> tcode = 4 (log-level)
# - fin_inst_reserve_req  -> tcode = 4 (log-level)
# - pib                   -> tcode = 4 (log-level)
# ===================================================================
infer_tcode_from_varnames <- function(var_names) {
  tcode <- rep(1L, length(var_names))

  loglevel_idx <- grepl("^base_", var_names) |
    grepl("^credit", var_names) |
    grepl("^credito_", var_names) |
    var_names %in% c("fin_inst_reserve_req", "pib")

  tcode[loglevel_idx] <- 4L
  tcode
}


# ===================================================================
# FUNÇÃO PRINCIPAL: IRFs COM IDENTIFICAÇÃO VIA INSTRUMENTO EXTERNO
# ===================================================================
compute_irf_dfm <- function(dfm_results, instrument = NULL, h = 24, nboot = 300,
                            bootstrap_seed = NULL, mpind = NULL,
                            normalize_value = 0.5, data_dates = NULL,
                            tcode = NULL, ci_levels = c(0.90, 0.95)) {

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

  # --- Resolver instrumento ---
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

  # --- Identificação por instrumento externo (estimativa pontual) ---
  eta_sel <- eta[rsh_sel_ind, , drop = FALSE]
  point_result <- ident_ext_instr(rawimp, eta_sel, inst_sel, h,
                                  mpind, normalize_value, tcode)
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
        # Rademacher draw
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

        # Wild bootstrap do instrumento (mesmo rr)
        rr_sel <- rr[rsh_sel_ind]
        inst_boot <- inst_sel * rr_sel

        # Identificação bootstrapada
        eta_boot_sel <- eta_boot[rsh_sel_ind, , drop = FALSE]
        boot_result <- ident_ext_instr(rawimp_boot, eta_boot_sel, inst_boot,
                                       h, mpind, normalize_value, tcode)
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

  list(
    irf_point = irf_point_3d,
    irf_point_matrix = irf_point,
    ci = ci,
    ci_levels = ci_levels
  )
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
