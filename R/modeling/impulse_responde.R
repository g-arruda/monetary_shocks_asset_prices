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
                            mpind = NULL, normalize_value = 0.5) {
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

  list(irf_mp = irf_mp, H = H)
}


# ===================================================================
# FUNÇÃO PRINCIPAL: IRFs COM IDENTIFICAÇÃO VIA INSTRUMENTO EXTERNO
# ===================================================================
compute_irf_dfm <- function(dfm_results, instrument = NULL, h = 24, nboot = 300,
                            bootstrap_seed = NULL, mpind = NULL,
                            normalize_value = 0.5, data_dates = NULL) {

  if (!is.null(bootstrap_seed)) set.seed(bootstrap_seed)

  # --- Extrair componentes do DFM ---
  Lambda <- dfm_results$static_loadings
  A      <- dfm_results$companion_matrix
  K      <- dfm_results$dynamic_loadings
  M      <- dfm_results$dynamic_scaling
  sy     <- dfm_results$data_sd
  p      <- dfm_results$p
  r      <- ncol(Lambda)
  q      <- dfm_results$q
  n_vars <- nrow(Lambda)
  rp     <- nrow(A)

  # --- Resolver instrumento: argumento direto ou embutido no dfm_results ---
  if (is.null(instrument) && !is.null(dfm_results$instrument)) {
    instrument <- dfm_results$instrument
  }
  if (is.null(instrument)) {
    stop("instrument deve ser fornecido diretamente ou via dfm_results$instrument")
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

  # --- Matrizes B de propagação (usando companion completa) ---
  Bfull <- array(0, dim = c(rp, rp, h + 1))
  Bfull[, , 1] <- diag(rp)
  Bfull[, , 2] <- A
  for (i in 3:(h + 1)) Bfull[, , i] <- Bfull[, , i - 1] %*% A

  B <- array(0, dim = c(r, r, h + 1))
  for (i in seq_len(h + 1)) B[, , i] <- Bfull[1:r, 1:r, i]

  # --- IRFs de forma reduzida (rawimp) ---
  # C(:,:,ii) = (lambda * B(:,:,ii) * K * M) .* repmat(sy',1,q)
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
  u <- dfm_results$var_residuals
  if (!is.matrix(K) && !is.matrix(M)) {
    eta <- u
  } else {
    eta <- u %*% K %*% solve(M)
  }

  # --- Identificação por instrumento externo (estimativa pontual) ---
  eta_sel <- eta[rsh_sel_ind, , drop = FALSE]
  point_result <- ident_ext_instr(rawimp, eta_sel, inst_sel, h,
                                  mpind, normalize_value)
  irf_point <- point_result$irf_mp

  # --- Wild Bootstrap (Gertler & Karadi 2015) ---
  if (nboot > 0) {
    irf_boot <- array(0, dim = c(n_vars, h + 1, nboot))

    for (b in seq_len(nboot)) {
      set.seed(bootstrap_seed + b)

      tryCatch({
        # Rademacher draw
        rr <- 1 - 2 * (runif(nrow(dfm_results$var_residuals)) > 0.5)
        resid_boot <- dfm_results$var_residuals * rr

        # Reconstruir fatores com resíduos bootstrapados
        F_boot <- matrix(0, nrow = nrow(dfm_results$static_factors), ncol = r)
        F_boot[1:p, ] <- dfm_results$static_factors[1:p, ]

        for (t in (p + 1):nrow(F_boot)) {
          lagged_vars <- as.vector(t(F_boot[(t - 1):(t - p), ]))
          F_boot[t, ] <- lagged_vars %*% dfm_results$var_coefficients +
            resid_boot[t - p, ]
        }

        # Re-estimar VAR nos fatores bootstrapados
        var_boot <- estimate_corrected_var_deterministic(
          F_boot, p, seed = bootstrap_seed + b
        )
        A_boot <- var_boot$companion

        # Re-estimar fatores dinâmicos
        dynamic_boot <- estimate_dynamic_factors_deterministic(
          var_boot$residuals, q, r, seed = bootstrap_seed + b
        )
        K_boot <- dynamic_boot$K
        M_boot <- dynamic_boot$M

        # Matrizes B bootstrapadas (companion completa)
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
            temp <- Re(Lambda %*% B_boot[, , i] * K_boot * M_boot)
          } else {
            temp <- Re(Lambda %*% B_boot[, , i] %*% K_boot %*% M_boot)
          }
          rawimp_boot[, , i] <- sweep(temp, 1, sy, "*")
        }

        # Resíduos de fatores dinâmicos bootstrapados
        u_boot <- var_boot$residuals
        if (!is.matrix(K_boot) && !is.matrix(M_boot)) {
          eta_boot <- u_boot
        } else {
          eta_boot <- u_boot %*% K_boot %*% solve(M_boot)
        }

        # Wild bootstrap do instrumento (mesmo rr aplicado ao instrumento)
        rr_sel <- rr[rsh_sel_ind]
        inst_boot <- inst_sel * rr_sel

        # Identificação bootstrapada
        eta_boot_sel <- eta_boot[rsh_sel_ind, , drop = FALSE]
        boot_result <- ident_ext_instr(rawimp_boot, eta_boot_sel, inst_boot,
                                       h, mpind, normalize_value)
        irf_boot[, , b] <- boot_result$irf_mp

      }, error = function(e) {
        warning("Bootstrap iteracao ", b, " falhou: ", e$message)
        irf_boot[, , b] <<- irf_point
      })
    }

    # Validação do bootstrap
    bootstrap_validation <- validate_bootstrap_results(irf_boot, irf_point)

    # Intervalos de confiança
    irf_ci <- array(0, dim = c(n_vars, h + 1, 5, 1))
    irf_ci[, , 1, 1] <- apply(irf_boot, c(1, 2), quantile,
                               probs = 0.05, na.rm = TRUE)
    irf_ci[, , 2, 1] <- apply(irf_boot, c(1, 2), quantile,
                               probs = 0.10, na.rm = TRUE)
    irf_ci[, , 3, 1] <- irf_point
    irf_ci[, , 4, 1] <- apply(irf_boot, c(1, 2), quantile,
                               probs = 0.90, na.rm = TRUE)
    irf_ci[, , 5, 1] <- apply(irf_boot, c(1, 2), quantile,
                               probs = 0.95, na.rm = TRUE)
  } else {
    irf_ci <- array(0, dim = c(n_vars, h + 1, 5, 1))
    for (k in 1:5) irf_ci[, , k, 1] <- irf_point
  }

  # Empacotar irf_point em array 3D para compatibilidade
  irf_point_3d <- array(0, dim = c(n_vars, h + 1, 1))
  irf_point_3d[, , 1] <- irf_point

  list(irf_point = irf_point_3d, irf_ci = irf_ci)
}


# ===================================================================
# PLOT DE IRFs
# ===================================================================
plot_irf <- function(irf_results, response_vars, shock = 1, horizon = 20,
                     cumulative = TRUE, invert_shock = FALSE) {

  plot_list <- list()

  # Códigos de transformação (seguindo implementação MATLAB)
  # 1 = levels, 2 = first differences, 5 = log differences
  var_tcodes <- c(
    39, 2,
    55, 1,
    56, 1,
    33, 5,
    38, 5,
    64, 5,
    68, 5,
    54, 1,
    50, 1,
    53, 1
  )

  tcode_lookup <- setNames(
    var_tcodes[seq(2, length(var_tcodes), 2)],
    var_tcodes[seq(1, length(var_tcodes), 2)]
  )

  if (invert_shock) {
    irf_results[, , , shock] <- -irf_results[, , , shock]
  }

  for (i in seq_along(response_vars)) {
    var_index <- as.numeric(response_vars[[i]])
    var_name  <- names(response_vars[[i]])

    tcode <- tcode_lookup[as.character(var_index)]
    if (is.na(tcode)) tcode <- 1

    irf_raw    <- irf_results[var_index, seq_len(horizon + 1), 3, shock]
    ic_05_raw  <- irf_results[var_index, seq_len(horizon + 1), 1, shock]
    ic_10_raw  <- irf_results[var_index, seq_len(horizon + 1), 2, shock]
    ic_90_raw  <- irf_results[var_index, seq_len(horizon + 1), 4, shock]
    ic_95_raw  <- irf_results[var_index, seq_len(horizon + 1), 5, shock]

    if (cumulative && tcode == 1) {
      irf_cum    <- irf_raw
      ic_05_cum  <- ic_05_raw
      ic_10_cum  <- ic_10_raw
      ic_90_cum  <- ic_90_raw
      ic_95_cum  <- ic_95_raw
    } else if (cumulative && tcode == 2) {
      irf_cum    <- cumsum(irf_raw) * 100
      ic_05_cum  <- cumsum(ic_05_raw) * 100
      ic_10_cum  <- cumsum(ic_10_raw) * 100
      ic_90_cum  <- cumsum(ic_90_raw) * 100
      ic_95_cum  <- cumsum(ic_95_raw) * 100
    } else if (cumulative && tcode == 5) {
      irf_cum    <- (exp(cumsum(irf_raw)) - 1) * 100
      ic_05_cum  <- (exp(cumsum(ic_05_raw)) - 1) * 100
      ic_10_cum  <- (exp(cumsum(ic_10_raw)) - 1) * 100
      ic_90_cum  <- (exp(cumsum(ic_90_raw)) - 1) * 100
      ic_95_cum  <- (exp(cumsum(ic_95_raw)) - 1) * 100
    } else {
      irf_cum    <- irf_raw
      ic_05_cum  <- ic_05_raw
      ic_10_cum  <- ic_10_raw
      ic_90_cum  <- ic_90_raw
      ic_95_cum  <- ic_95_raw
    }

    df_plot <- data.frame(
      tempo  = seq_len(horizon + 1) - 1,
      irf    = irf_cum,
      ic_05  = ic_05_cum,
      ic_10  = ic_10_cum,
      ic_90  = ic_90_cum,
      ic_95  = ic_95_cum
    )

    plot_list[[i]] <- ggplot2::ggplot(df_plot, ggplot2::aes(x = tempo)) +
      ggplot2::geom_ribbon(
        ggplot2::aes(ymin = ic_05, ymax = ic_95),
        fill = "grey90", alpha = 0.5
      ) +
      ggplot2::geom_ribbon(
        ggplot2::aes(ymin = ic_10, ymax = ic_90),
        fill = "grey70", alpha = 0.5
      ) +
      ggplot2::geom_line(
        ggplot2::aes(y = irf),
        color = "black",
        linewidth = 1
      ) +
      ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      ggplot2::theme_classic() +
      ggplot2::labs(y = var_name) +
      ggplot2::theme(
        axis.title.x = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_text(size = ggplot2::rel(1.4)),
        axis.text     = ggplot2::element_text(size = ggplot2::rel(1.2)),
        plot.title    = ggplot2::element_blank()
      ) +
      ggplot2::annotate(
        "text",
        x     = Inf,
        y     = mean(range(df_plot$ic_95, df_plot$ic_05)),
        label = var_name,
        hjust = 0,
        vjust = 0.5
      )
  }

  patchwork::wrap_plots(plot_list, ncol = 2)
}


# ===================================================================
# FUNÇÕES AUXILIARES
# ===================================================================

get_q_from_K <- function(K) {
  if (is.matrix(K)) ncol(K) else 1
}


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
