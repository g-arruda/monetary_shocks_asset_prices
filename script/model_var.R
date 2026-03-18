# ===================================================================
# MODELO VAR DE ROBUSTEZ
# IDENTIFICAÇÃO VIA INSTRUMENTO EXTERNO (PROXY SVAR)
# Replicando Alessi & Kerssenfischer (2019) / Gertler & Karadi (2015)
# ===================================================================

rm(list = ls())

if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  vars,
  readr,
  dplyr,
  tidyr,
  ggplot2,
  patchwork,
  lubridate
)

# sel_ext_inst_sample e ident_ext_instr: mesmas funções usadas no DFM
source("R/modeling/impulse_responde.R")


# ===================================================================
# FUNÇÕES DE BAIXO NÍVEL: ESTIMAÇÃO E BOOTSTRAP
# ===================================================================


#' Correção de viés de Kilian (1998)
#' @description Tradução fiel de kiliancorr.m (Pope 1990)
kilian_correction <- function(A, SIGMA, T_total, N, p) {
  T_eff <- T_total - p
  Np <- N * p

  I_Np <- diag(Np)

  # Covariância incondicional: vec(Σ_Y) = (I − A⊗A)^{−1} vec(Σ)
  vecSIGMAY <- solve(diag(Np^2) - kronecker(A, A), as.vector(SIGMA))
  SIGMAY <- matrix(vecSIGMAY, Np, Np)

  B <- t(A)

  # Fórmula de Pope (1990): envolve autovalores do companion
  peigen <- eigen(A)$values
  sumeig <- matrix(0 + 0i, Np, Np)
  for (hh in seq_len(Np)) {
    sumeig <- sumeig + peigen[hh] * solve(I_Np - peigen[hh] * B)
  }

  bias <- SIGMA %*% (solve(I_Np - B) + B %*% solve(I_Np - B %*% B) + sumeig) %*%
    solve(SIGMAY)
  Abias <- -Re(bias) / T_eff

  # Reduz a correção progressivamente até garantir estacionariedade
  delta <- 1
  bcA <- A
  repeat {
    bcA <- A - delta * Abias
    if (all(abs(eigen(bcA)$values) < 1) || delta <= 0) break
    delta <- delta - 0.01
  }

  bcA
}


#' Estimação OLS de VAR reduzido
#' @description Tradução fiel de VARest.m (usada na re-estimação do bootstrap)
var_est_ols <- function(X, p, h) {
  T_total <- nrow(X)
  N <- ncol(X)

  RHS <- matrix(NA, T_total - p, N * p)
  for (i in seq_len(p)) {
    RHS[, ((i - 1) * N + 1):(i * N)] <- X[(p + 1 - i):(T_total - i), ]
  }
  LHS <- X[(p + 1):T_total, ]

  design <- cbind(RHS, 1)
  bet <- solve(crossprod(design), crossprod(design, LHS))
  u <- LHS - design %*% bet

  # Companion matrix
  Np <- N * p
  A <- matrix(0, Np, Np)
  A[1:N, ] <- t(bet[1:Np, ])
  if (p > 1) {
    A[(N + 1):Np, 1:((p - 1) * N)] <- diag((p - 1) * N)
  }

  # Coeficientes MA via potências do companion
  Bfull <- array(0, dim = c(Np, Np, h + 1))
  Bfull[, , 1] <- diag(Np)
  Bfull[, , 2] <- A
  for (i in 3:(h + 1)) Bfull[, , i] <- Bfull[, , i - 1] %*% A

  B <- array(0, dim = c(N, N, h + 1))
  for (i in seq_len(h + 1)) B[, , i] <- Bfull[1:N, 1:N, i]

  list(B = B, u = u, bet = bet, A = A)
}


#' Calcular IRFs via Proxy SVAR para VAR reduzido
#'
#' @description
#' Encapsula IdentExtInstr.m + MAIN_VARloop.m + VARest_boot.m.
#' Aceita instrumento como argumento para análise de sensibilidade.
#'
#' Diferença central em relação ao DFM: aqui os resíduos projetados no
#' instrumento são os u_t da forma reduzida do VAR (N-dimensionais),
#' e não as inovações de fatores dinâmicos η_t = u·K·M⁻¹ (q-dimensionais).
#'
#' @param var_model Objeto VAR estimado (pacote vars)
#' @param instrument Data.frame com colunas 'month' e 'shock'
#' @param data_dates Vetor Date com datas da amostra de dados
#' @param h Horizonte de IRFs
#' @param impulse Nome da variável que gera o impulso (para normalização)
#' @param normalize_value Valor para normalizar a resposta no impacto (default 0.5 = 50bp)
#' @param nboot Número de iterações de bootstrap
#'
#' @return Lista com irf_point, irf_ci, H, var_names
compute_irf_var_proxy <- function(var_model, instrument, data_dates,
                                  h = 48, impulse = "selic",
                                  normalize_value = 0.5,
                                  nboot = 300) {

  # --- Componentes do VAR reduzido ---
  N <- ncol(residuals(var_model))
  p_var <- var_model$p
  var_names <- colnames(var_model$y)
  A_list <- vars::Acoef(var_model)
  u <- residuals(var_model)
  T_eff <- nrow(u)
  T_total <- T_eff + p_var

  # Converter nome do impulso para índice
  mpind <- which(var_names == impulse)
  if (length(mpind) == 0) {
    stop("Variável '", impulse, "' não encontrada no VAR. ",
         "Variáveis disponíveis: ", paste(var_names, collapse = ", "))
  }

  # --- Companion matrix (VARest.m) ---
  Np <- N * p_var
  A <- matrix(0, Np, Np)
  for (i in seq_len(p_var)) {
    A[1:N, ((i - 1) * N + 1):(i * N)] <- A_list[[i]]
  }
  if (p_var > 1) {
    A[(N + 1):Np, 1:((p_var - 1) * N)] <- diag((p_var - 1) * N)
  }

  # --- Coeficientes MA de forma reduzida (rawimp) ---
  Bfull <- array(0, dim = c(Np, Np, h + 1))
  Bfull[, , 1] <- diag(Np)
  Bfull[, , 2] <- A
  for (i in 3:(h + 1)) Bfull[, , i] <- Bfull[, , i - 1] %*% A

  rawimp <- array(0, dim = c(N, N, h + 1))
  for (i in seq_len(h + 1)) rawimp[, , i] <- Bfull[1:N, 1:N, i]

  # --- Alinhamento temporal: instrumento × resíduos do VAR ---
  align <- sel_ext_inst_sample(data_dates, p_var, instrument)
  rsh_sel_ind <- align$rsh_sel_ind
  rsh_sel <- u[rsh_sel_ind, , drop = FALSE]
  inst_sel <- align$inst_sel

  if (length(inst_sel) == 0 || nrow(rsh_sel) == 0) {
    stop("Nenhuma data comum entre instrumento e residuos do VAR")
  }

  # --- Identificação pontual via instrumento externo ---
  point_result <- ident_ext_instr(rawimp, rsh_sel, inst_sel, h,
                                  mpind, normalize_value)
  irf_point <- point_result$irf_mp

  # --- Wild Bootstrap (VARest_boot.m / MAIN_VARloop.m) ---
  if (nboot > 0) {
    X_orig <- as.matrix(var_model$y)

    # Coeficientes OLS em formato MATLAB: (Np+1) × N
    RHS_orig <- matrix(NA, T_eff, Np)
    for (i in seq_len(p_var)) {
      RHS_orig[, ((i - 1) * N + 1):(i * N)] <-
        X_orig[(p_var + 1 - i):(T_total - i), ]
    }
    LHS_orig <- X_orig[(p_var + 1):T_total, ]
    design_orig <- cbind(RHS_orig, 1)
    bet <- solve(crossprod(design_orig), crossprod(design_orig, LHS_orig))

    # Correção de Kilian (kiliancorr.m)
    SIGMA <- matrix(0, Np, Np)
    SIGMA[1:N, 1:N] <- crossprod(u) / (T_eff - p_var * N - 1)

    betbiasc <- bet
    tryCatch({
      biascorr <- kilian_correction(A, SIGMA, T_total, N, p_var)
      betbiasc <- rbind(t(biascorr[1:N, ]), bet[Np + 1, ])
    }, error = function(e) {
      warning("Kilian correction failed, using uncorrected coefficients: ",
              e$message)
    })

    # Resíduos centrados para o bootstrap
    res <- sweep(u, 2, colMeans(u))

    irf_boot <- array(NA, dim = c(N, h + 1, nboot))

    for (b in seq_len(nboot)) {
      tryCatch({
        # Rademacher draw: +1 ou −1 com probabilidade 0.5
        rr <- 1 - 2 * (runif(T_eff) > 0.5)
        resb <- res * rr

        # Simular dados bootstrap recursivamente (VARest_boot.m)
        X_boot <- matrix(0, T_total, N)
        X_boot[1:p_var, ] <- X_orig[1:p_var, ]

        for (t_idx in (p_var + 1):T_total) {
          lvars <- as.vector(t(X_boot[(t_idx - 1):(t_idx - p_var), ,
                                      drop = FALSE]))
          X_boot[t_idx, ] <- lvars %*% betbiasc[1:Np, ] +
            betbiasc[Np + 1, ] + resb[t_idx - p_var, ]
        }

        # Re-estimar VAR no bootstrap (VARest.m)
        boot_var <- var_est_ols(X_boot, p_var, h)

        # Wild bootstrap do instrumento: mesmo rr (selextinstsample.m)
        align_b <- sel_ext_inst_sample(data_dates, p_var, instrument, rr = rr)

        u_boot_sel <- boot_var$u[align_b$rsh_sel_ind, , drop = FALSE]
        inst_boot_sel <- align_b$inst_sel

        boot_result <- ident_ext_instr(boot_var$B, u_boot_sel,
                                       inst_boot_sel, h,
                                       mpind, normalize_value)
        irf_boot[, , b] <- boot_result$irf_mp
      }, error = function(e) {
        warning("Bootstrap iteracao ", b, " falhou: ", e$message)
        irf_boot[, , b] <<- irf_point
      })
    }

    # Intervalos de confiança: 5%, 10%, mediana, 90%, 95%
    irf_ci <- array(0, dim = c(N, h + 1, 5))
    irf_ci[, , 1] <- apply(irf_boot, c(1, 2), quantile,
                            probs = 0.05, na.rm = TRUE)
    irf_ci[, , 2] <- apply(irf_boot, c(1, 2), quantile,
                            probs = 0.10, na.rm = TRUE)
    irf_ci[, , 3] <- irf_point
    irf_ci[, , 4] <- apply(irf_boot, c(1, 2), quantile,
                            probs = 0.90, na.rm = TRUE)
    irf_ci[, , 5] <- apply(irf_boot, c(1, 2), quantile,
                            probs = 0.95, na.rm = TRUE)
  } else {
    irf_ci <- array(0, dim = c(N, h + 1, 5))
    for (k in 1:5) irf_ci[, , k] <- irf_point
  }

  list(irf_point = irf_point, irf_ci = irf_ci, H = point_result$H, var_names = var_names)
}


# ===================================================================
# FUNÇÕES DE ALTO NÍVEL: PREPARAÇÃO, ESTIMAÇÃO E VISUALIZAÇÃO
# ===================================================================


#' Carregar dados e instrumento
#'
#' @param data_path Caminho para o arquivo de dados
#' @param instrument_path Caminho para o arquivo do instrumento
#' @param start_date Data inicial da amostra
#' @param end_date Data final da amostra
#'
#' @return Lista com data e instrument
load_var_data <- function(data_path = "data/processed/data_log_deseasonalized.csv",
                          instrument_path = "data/processed/instrument.csv",
                          start_date = "2013-01-01",
                          end_date = "2024-12-31") {

  data <- readr::read_csv(data_path, show_col_types = FALSE) |>
    dplyr::filter(ref.date >= as.Date(start_date) & ref.date <= as.Date(end_date))

  instrument <- readr::read_csv(instrument_path, show_col_types = FALSE)

  list(data = data, instrument = instrument)
}


#' Preparar dados para estimação de um VAR específico
#'
#' @param data Data.frame com todos os dados
#' @param core_vars Vetor nomeado de variáveis core (atividade, inflação, selic)
#' @param asset_var Vetor nomeado de uma variável de ativo
#'
#' @return Lista com var_data (ts), data_dates (Date), var_names (character)
prepare_var_data <- function(data, core_vars, asset_var) {

  vars_to_select <- c("ref.date",
                      setNames(core_vars, names(core_vars)),
                      setNames(asset_var, names(asset_var)))

  var_df <- data |>
    dplyr::select(all_of(vars_to_select)) |>
    tidyr::drop_na()

  data_dates <- as.Date(var_df$ref.date)

  var_data <- var_df |>
    dplyr::select(-ref.date) |>
    ts(start = c(year(min(data_dates)), month(min(data_dates))), frequency = 12)

  var_names <- c(names(core_vars), names(asset_var))

  list(var_data = var_data, data_dates = data_dates, var_names = var_names)
}


#' Estimar VAR com identificação via proxy SVAR
#'
#' @param var_data Objeto ts com dados do VAR
#' @param data_dates Vetor Date com datas
#' @param instrument Data.frame com instrumento
#' @param p Ordem do VAR
#' @param h Horizonte de IRFs
#' @param impulse Nome da variável que gera o impulso
#' @param normalize_value Normalização do choque (default 0.5)
#' @param nboot Número de iterações de bootstrap
#'
#' @return Lista com var_model, irf_results, var_names
estimate_var_proxy <- function(var_data, data_dates, instrument,
                               p = 6, h = 48, impulse = "selic",
                               normalize_value = 0.5, nboot = 300) {

  # Estimação base do VAR reduzido para uso posterior (caso necessário)
  X_mat <- as.matrix(var_data)
  var_model_ols <- var_est_ols(X_mat, p, h)

  # Identificação por instrumento externo (proxy SVAR)
  irf_results <- compute_irf_var_proxy(
    var_data        = var_data,
    p_var           = p,
    instrument      = instrument,
    data_dates      = data_dates,
    h               = h,
    impulse         = impulse,
    normalize_value = normalize_value,
    nboot           = nboot
  )

  list(
    var_model = var_model_ols,
    irf_results = irf_results,
    var_names = colnames(var_data)
  )
}


#' Estimar múltiplos VARs (um para cada ativo)
#'
#' @param data Data.frame com todos os dados
#' @param instrument Data.frame com instrumento
#' @param core_vars Vetor nomeado de variáveis core
#' @param asset_vars Vetor nomeado de variáveis de ativos
#' @param p Ordem do VAR
#' @param h Horizonte de IRFs
#' @param impulse Nome da variável que gera o impulso
#' @param normalize_value Normalização do choque
#' @param nboot Número de iterações de bootstrap
#' @param verbose Mostrar progresso
#'
#' @return Lista nomeada com resultados para cada ativo
estimate_multiple_vars <- function(data, instrument, core_vars, asset_vars,
                                   p = 6, h = 48, impulse = "selic",
                                   normalize_value = 0.5, nboot = 300,
                                   verbose = TRUE) {

  all_results <- list()

  for (asset_name in names(asset_vars)) {

    if (verbose) cat("\nEstimating VAR for asset:", asset_name, "\n")

    asset_var <- setNames(asset_vars[asset_name], asset_name)

    # Preparar dados
    var_prep <- prepare_var_data(data, core_vars, asset_var)

    # Estimar VAR
    var_result <- estimate_var_proxy(
      var_data        = var_prep$var_data,
      data_dates      = var_prep$data_dates,
      instrument      = instrument,
      p               = p,
      h               = h,
      impulse         = impulse,
      normalize_value = normalize_value,
      nboot           = nboot
    )

    # Adicionar metadata
    var_result$asset_name <- asset_name
    var_result$var_names <- var_prep$var_names

    all_results[[asset_name]] <- var_result

    if (verbose) cat("Finished estimation for:", asset_name, "\n")
  }

  all_results
}


#' Plotar IRFs de um único VAR
#'
#' @param irf_ci Array 3D (N x h+1 x 5) com IRFs e intervalos de confiança
#' @param var_names Vetor de nomes das variáveis
#' @param response Nome ou vetor de nomes das variáveis a plotar (NULL = todas)
#' @param h Horizonte plotado
#' @param title Título do gráfico
#'
#' @return Objeto ggplot
plot_var_irfs <- function(irf_ci, var_names, response = NULL, h = 48, title = NULL) {

  # Filtrar variáveis se response for especificado
  if (!is.null(response)) {
    response_idx <- which(var_names %in% response)
    if (length(response_idx) == 0) {
      warning("Nenhuma variável de 'response' encontrada. ",
              "Variáveis disponíveis: ", paste(var_names, collapse = ", "),
              ". Plotando todas as variáveis.")
      # Não fazer nada, manter todas as variáveis
    } else {
      # Filtrar apenas as variáveis encontradas
      irf_ci <- irf_ci[response_idx, , , drop = FALSE]
      var_names <- var_names[response_idx]
    }
  }

  N_var <- dim(irf_ci)[1]
  horizons <- 0:h

  plots <- list()

  for (v in seq_len(N_var)) {

    df_plot <- data.frame(
      horizon = horizons,
      irf     = irf_ci[v, , 3],
      ci_05   = irf_ci[v, , 1],
      ci_10   = irf_ci[v, , 2],
      ci_90   = irf_ci[v, , 4],
      ci_95   = irf_ci[v, , 5]
    )

    p <- ggplot2::ggplot(df_plot, ggplot2::aes(x = horizon)) +
      ggplot2::geom_ribbon(
        ggplot2::aes(ymin = ci_05, ymax = ci_95),
        fill = "grey90", alpha = 0.5
      ) +
      ggplot2::geom_ribbon(
        ggplot2::aes(ymin = ci_10, ymax = ci_90),
        fill = "grey70", alpha = 0.5
      ) +
      ggplot2::geom_line(
        ggplot2::aes(y = irf),
        color = "black",
        linewidth = 1
      ) +
      ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      ggplot2::theme_classic() +
      ggplot2::labs(
        title = var_names[v],
        x     = "Meses",
        y     = NULL
      ) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(size = 12, face = "bold", hjust = 0.5),
        axis.title = ggplot2::element_text(size = 10),
        axis.text  = ggplot2::element_text(size = 9)
      )

    plots[[v]] <- p
  }

  combined_plot <- patchwork::wrap_plots(plots, ncol = 2)

  if (!is.null(title)) {
    combined_plot <- combined_plot +
      patchwork::plot_annotation(
        title = title,
        theme = ggplot2::theme(plot.title = ggplot2::element_text(size = 14, face = "bold"))
      )
  }

  combined_plot
}


#' Plotar IRFs de múltiplos VARs (comparação entre ativos)
#'
#' @param all_results Lista com resultados de estimate_multiple_vars
#' @param response Nome da variável a plotar (ex: "cambio", "ibrx100")
#' @param h Horizonte plotado
#' @param title Título do gráfico
#'
#' @return Objeto ggplot
plot_multiple_var_irfs <- function(all_results, response, h = 48, title = NULL) {

  df_list <- list()

  for (asset_name in names(all_results)) {
    result <- all_results[[asset_name]]
    irf_ci <- result$irf_results$irf_ci
    var_names <- result$irf_results$var_names

    # Encontrar índice da variável response
    var_idx <- which(var_names == response)
    if (length(var_idx) == 0) {
      warning("Variável '", response, "' não encontrada no VAR de '", asset_name, "'. Ignorando.")
      next
    }

    df_list[[asset_name]] <- data.frame(
      horizon    = 0:h,
      asset      = asset_name,
      irf        = irf_ci[var_idx, , 3],
      ci_05      = irf_ci[var_idx, , 1],
      ci_10      = irf_ci[var_idx, , 2],
      ci_90      = irf_ci[var_idx, , 4],
      ci_95      = irf_ci[var_idx, , 5]
    )
  }

  if (length(df_list) == 0) {
    stop("Nenhum resultado válido encontrado para a variável '", response, "'")
  }

  df_combined <- dplyr::bind_rows(df_list)

  p <- ggplot2::ggplot(df_combined, ggplot2::aes(x = horizon, color = asset, fill = asset)) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = ci_10, ymax = ci_90),
      alpha = 0.2, color = NA
    ) +
    ggplot2::geom_line(ggplot2::aes(y = irf), linewidth = 1) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "gray30") +
    ggplot2::theme_classic() +
    ggplot2::labs(
      title = if (is.null(title)) paste("Resposta de", response, "ao choque monetário") else title,
      x     = "Meses",
      y     = NULL,
      color = "Ativo",
      fill  = "Ativo"
    ) +
    ggplot2::theme(
      plot.title  = ggplot2::element_text(size = 14, face = "bold", hjust = 0.5),
      legend.position = "bottom"
    )

  p
}


# ===================================================================
# EXECUÇÃO PRINCIPAL
# ===================================================================


#' Executar análise completa de VAR com proxy SVAR
#'
#' @param data_path Caminho para dados
#' @param instrument_path Caminho para instrumento
#' @param core_vars Vetor nomeado de variáveis core
#' @param asset_vars Vetor nomeado de variáveis de ativos
#' @param p Ordem do VAR
#' @param h Horizonte de IRFs
#' @param impulse Nome da variável que gera o impulso
#' @param response Nome ou vetor de nomes das variáveis de resposta a plotar (NULL = todas)
#' @param normalize_value Normalização do choque
#' @param nboot Número de iterações de bootstrap
#' @param start_date Data inicial
#' @param end_date Data final
#' @param plot_individual Plotar IRFs individuais
#' @param plot_comparison Plotar comparação entre ativos (requer response único)
#'
#' @return Lista com loaded_data, all_results, plots
run_var_analysis <- function(data_path = "data/processed/data_log_deseasonalized.csv",
                             instrument_path = "data/processed/instrument.csv",
                             core_vars = c(
                               "producao_transformacao" = "producao_transformacao",
                               "ipca" = "price_ipca",
                               "selic" = "juros_selic"
                             ),
                             asset_vars = c(
                               "cambio" = "cambio_usd",
                               "ibrx100" = "asset_ibov",
                               "spread_credito" = "spread_icc_fisica"
                             ),
                             p = 6,
                             h = 48,
                             impulse = "selic",
                             response = NULL,
                             normalize_value = 0.5,
                             nboot = 300,
                             start_date = "2013-01-01",
                             end_date = "2024-12-31",
                             plot_individual = TRUE,
                             plot_comparison = TRUE) {

  cat("=== VAR Analysis with Proxy SVAR ===\n")

  # 1. Carregar dados
  cat("\n1. Loading data...\n")
  loaded_data <- load_var_data(data_path, instrument_path, start_date, end_date)

  # 2. Estimar VARs
  cat("\n2. Estimating VARs...\n")
  all_results <- estimate_multiple_vars(
    data            = loaded_data$data,
    instrument      = loaded_data$instrument,
    core_vars       = core_vars,
    asset_vars      = asset_vars,
    p               = p,
    h               = h,
    impulse         = impulse,
    normalize_value = normalize_value,
    nboot           = nboot,
    verbose         = TRUE
  )

  # 3. Plotar resultados
  plots <- list()

  if (plot_individual) {
    cat("\n3. Generating individual plots...\n")
    for (asset_name in names(all_results)) {
      result <- all_results[[asset_name]]
      plots[[asset_name]] <- plot_var_irfs(
        irf_ci    = result$irf_results$irf_ci,
        var_names = result$var_names,
        response  = response,
        h         = h,
        title     = paste("IRFs - VAR with", asset_name)
      )
    }
  }

  if (plot_comparison) {
    cat("\n4. Generating comparison plot...\n")

    # Para comparação, usa automaticamente o nome do asset (última variável do VAR)
    # Cada VAR tem sua própria variável de ativo, então comparamos os assets entre si
    if (!is.null(response) && length(response) == 1) {
      # Se response foi especificado e é único, usar ele
      response_comp <- response
    } else {
      # Caso contrário, criar plot comparando os próprios assets
      # (cada VAR já tem sua variável de ativo específica)
      cat("Creating comparison of asset variables across VARs...\n")

      df_list <- list()
      for (asset_name in names(all_results)) {
        result <- all_results[[asset_name]]
        irf_ci <- result$irf_results$irf_ci
        var_names <- result$irf_results$var_names

        # A variável de ativo é a última no VAR (4ª posição)
        asset_idx <- length(var_names)

        df_list[[asset_name]] <- data.frame(
          horizon = 0:h,
          asset   = asset_name,
          irf     = irf_ci[asset_idx, , 3],
          ci_05   = irf_ci[asset_idx, , 1],
          ci_10   = irf_ci[asset_idx, , 2],
          ci_90   = irf_ci[asset_idx, , 4],
          ci_95   = irf_ci[asset_idx, , 5]
        )
      }

      df_combined <- dplyr::bind_rows(df_list)

      plots$comparison <- ggplot2::ggplot(df_combined, ggplot2::aes(x = horizon, color = asset, fill = asset)) +
        ggplot2::geom_ribbon(
          ggplot2::aes(ymin = ci_10, ymax = ci_90),
          alpha = 0.2, color = NA
        ) +
        ggplot2::geom_line(ggplot2::aes(y = irf), linewidth = 1) +
        ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "gray30") +
        ggplot2::theme_classic() +
        ggplot2::labs(
          title = "Comparison: Asset Price Responses to Monetary Shock",
          x     = "Meses",
          y     = NULL,
          color = "Ativo",
          fill  = "Ativo"
        ) +
        ggplot2::theme(
          plot.title  = ggplot2::element_text(size = 14, face = "bold", hjust = 0.5),
          legend.position = "bottom"
        )

      response_comp <- NULL  # Flag para não usar plot_multiple_var_irfs
    }

    # Usar plot_multiple_var_irfs apenas se response foi especificado
    if (!is.null(response_comp)) {
      plots$comparison <- plot_multiple_var_irfs(
        all_results = all_results,
        response    = response_comp,
        h           = h,
        title       = NULL
      )
    }
  }

  cat("\n=== Analysis complete ===\n")

  list(
    loaded_data = loaded_data,
    all_results = all_results,
    plots       = plots
  )
}


# ===================================================================
# EXEMPLO DE USO
# ===================================================================

# Executar análise completa (plotar todas as variáveis)
results <- run_var_analysis(
  impulse = "selic",
  response = NULL,  # NULL = plotar todas
  nboot = 300,
  plot_individual = TRUE,
  plot_comparison = TRUE
)

# Plotar apenas variáveis core (que existem em todos os VARs)
results_core <- run_var_analysis(
  impulse = "selic",
  response = c("ipca"),  # Plotar apenas inflação e taxa de juros
  nboot = 300,
  plot_comparison = FALSE  # Desativar comparação (só faz sentido para 1 variável)
)

# Comparar apenas a resposta de ipca entre os diferentes VARs
results_ipca <- run_var_analysis(
  impulse = "juros_selic",
  response = "ipca",  # Uma única variável
  nboot = 300,
  plot_comparison = TRUE  # Compara ipca nos 3 VARs
)
#
# # Acessar resultados individuais
results_core$all_results$cambio$irf_results
results$all_results$ibrx100$var_model
#




