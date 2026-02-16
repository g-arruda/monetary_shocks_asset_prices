#' Calculate Spot Rate Using Svensson Model
#'
#' This function implements the Svensson (1994) model to calculate spot interest rates.
#' The model extends Nelson-Siegel by adding a fourth term to better fit complex yield curves.
#'
#' @param t Numeric vector. Time to maturity in years.
#' @param beta0 Numeric. Long-term interest rate level parameter.
#' @param beta1 Numeric. Short-term component parameter.
#' @param beta2 Numeric. Medium-term component parameter.
#' @param beta3 Numeric. Second medium-term component parameter.
#' @param tau1 Numeric. First decay parameter (must be positive).
#' @param tau2 Numeric. Second decay parameter (must be positive).
#'
#' @return Numeric vector. The spot rate for the given maturities.
#'
#' @export
svensson_rate <- function(t, beta0, beta1, beta2, beta3, tau1, tau2) {
  # Avoid division by zero for t=0 or very small tau
  # Although t=0 implies rate = beta0 + beta1, formula yields 0/0.
  # We handle t=0 separately if needed, but assuming t > 0 for yield curves typically.
  
  # Term 1: Level
  term1 <- beta0
  
  # Pre-calculate exponentials for efficiency
  # Use vectorized operations
  exp_t_tau1 <- exp(-t / tau1)
  exp_t_tau2 <- exp(-t / tau2)
  
  # Term 2: Slope
  # Note: (1 - exp(-x))/x converges to 1 as x->0
  # For numerical stability with t close to 0, one might use expm1
  val_tau1 <- (1 - exp_t_tau1) / (t / tau1)
  
  term2 <- beta1 * val_tau1
  
  # Term 3: Curvature 1
  term3 <- beta2 * (val_tau1 - exp_t_tau1)
  
  # Term 4: Curvature 2
  val_tau2 <- (1 - exp_t_tau2) / (t / tau2)
  term4 <- beta3 * (val_tau2 - exp_t_tau2)
  
  return(term1 + term2 + term3 + term4)
}

#' Fit Svensson Model Parameters to Observed Rates
#'
#' Estimates the parameters of the Svensson model using numerical optimization.
#' Uses L-BFGS-B method to minimize the sum of squared errors between observed
#' and predicted rates.
#'
#' @param maturities Numeric vector. Time to maturity in years.
#' @param rates Numeric vector. Observed interest rates.
#' @param return_diagnostics Logical. If TRUE, returns a list with parameters and diagnostics.
#'                           If FALSE, returns only the parameter vector (backward compatible).
#'
#' @return If return_diagnostics=FALSE: Numeric vector of parameters (beta0, beta1, beta2, beta3, tau1, tau2) 
#'         or NA vector if estimation fails/insufficient data.
#'         If return_diagnostics=TRUE: List containing:
#'         - params: parameter vector
#'         - fitted_values: predicted rates
#'         - residuals: observed - predicted
#'         - rmse: root mean squared error
#'         - mae: mean absolute error
#'         - r_squared: coefficient of determination
#'         - convergence: convergence status (0 = success)
#'         - iterations: number of iterations
#'         - slope: yield curve slope (beta1)
#'         - level: yield curve level (beta0)
#'         - curvature: yield curve curvature (beta2 + beta3)
#'
#' @export
fit_svensson <- function(maturities, rates, return_diagnostics = FALSE) {
  # Check for sufficient data points
  # Svensson has 6 parameters, need at least 6 points for unique identification
  # allowing 4 (as in original) leads to overfitting/non-uniqueness
  if (length(maturities) < 6) {
    warning("Insufficient data points for Svensson model (need >= 6). returning NA.")
    if (return_diagnostics) {
      return(list(
        params = rep(NA_real_, 6),
        fitted_values = rep(NA_real_, length(rates)),
        residuals = rep(NA_real_, length(rates)),
        rmse = NA_real_,
        mae = NA_real_,
        r_squared = NA_real_,
        convergence = -1,
        iterations = 0,
        slope = NA_real_,
        level = NA_real_,
        curvature = NA_real_
      ))
    } else {
      return(rep(NA_real_, 6))
    }
  }
  
  # Sort by maturity ensuring head() is short-term and tail() is long-term
  ord <- order(maturities)
  maturities <- maturities[ord]
  rates <- rates[ord]

  objective <- function(params) {
    # Extract parameters for clarity
    b0 <- params[1]
    b1 <- params[2]
    b2 <- params[3]
    b3 <- params[4]
    t1 <- params[5]
    t2 <- params[6]
    
    # Vectorized prediction
    predicted <- svensson_rate(maturities, b0, b1, b2, b3, t1, t2)
    
    # Sum of Squared Errors + penalty for tau1 ≈ tau2 (identification)
    sse <- sum((rates - predicted)^2)
    
    # Soft penalty when tau1 and tau2 are too close (avoids degenerate solutions)
    tau_penalty <- 0.001 * exp(-5 * abs(t1 - t2))
    
    sse + tau_penalty
  }
  
  # Dynamic bounds based on observed rate range
  rate_range <- max(rates) - min(rates)
  rate_max <- max(abs(rates))
  beta_bound <- max(0.5, rate_max * 1.5)  # at least 0.5, or 1.5x the max rate
  
  lower <- c(-beta_bound, -beta_bound, -beta_bound, -beta_bound, 0.01, 0.01)
  upper <- c( beta_bound,  beta_bound,  beta_bound,  beta_bound, 30, 30)
  
  # Heuristic Initialization for better convergence
  # Beta0: Long run level -> approx last rate
  start_beta0 <- tail(rates, 1)
  # Beta1: Approx spread (Short - Long)
  start_beta1 <- head(rates, 1) - start_beta0
  
  # Multi-start grid: different tau pairs to avoid tau1 ≈ tau2 trap
  max_mat <- max(maturities)
  tau_starts <- list(
    c(0.5, 3.0),
    c(1.0, 5.0),
    c(0.3, 2.0),
    c(0.5, 8.0),
    c(2.0, 10.0),
    c(0.1, 1.0)
  )
  
  best_result <- NULL
  best_value <- Inf
  
  for (tau_pair in tau_starts) {
    start_par <- c(
      start_beta0,   # beta0
      start_beta1,   # beta1
      0.0,           # beta2
      0.0,           # beta3
      tau_pair[1],   # tau1
      tau_pair[2]    # tau2
    )
    
    # Safety check ensures start_par is within bounds
    start_par <- pmax(lower, pmin(start_par, upper))
  
    # Optimization with error handling
    tryCatch({
      result <- optim(
        par = start_par,
        fn = objective,
        method = "L-BFGS-B",
        lower = lower,
        upper = upper,
        control = list(maxit = 1000)
      )
      
      if (result$value < best_value) {
        best_value <- result$value
        best_result <- result
      }
    }, error = function(e) {
      # Skip this starting point if it fails
    })
  }  # end multi-start loop
  
  # If no starting point succeeded
  if (is.null(best_result)) {
    warning("All optimization starting points failed.")
    if (return_diagnostics) {
      return(list(
        params = rep(NA_real_, 6),
        fitted_values = rep(NA_real_, length(rates)),
        residuals = rep(NA_real_, length(rates)),
        rmse = NA_real_,
        mae = NA_real_,
        r_squared = NA_real_,
        convergence = -999,
        iterations = 0,
        slope = NA_real_,
        level = NA_real_,
        curvature = NA_real_
      ))
    } else {
      return(rep(NA_real_, 6))
    }
  }
  
  result <- best_result
  
  if (result$convergence != 0) {
    warning(paste("Optimization did not converge code:", result$convergence))
  }
  
  # If only parameters requested (backward compatible)
  if (!return_diagnostics) {
    return(result$par)
  }
  
  # Calculate fitted values and diagnostics
  fitted <- svensson_rate(
    maturities, 
    result$par[1], result$par[2], result$par[3], 
    result$par[4], result$par[5], result$par[6]
  )
  
  residuals <- rates - fitted
  rmse <- sqrt(mean(residuals^2))
  mae <- mean(abs(residuals))
  
  # R-squared
  ss_res <- sum(residuals^2)
  ss_tot <- sum((rates - mean(rates))^2)
  r_squared <- 1 - (ss_res / ss_tot)
  
  # Yield curve characteristics
  level <- result$par[1]  # beta0
  slope <- result$par[2]  # beta1
  curvature <- result$par[3] + result$par[4]  # beta2 + beta3
  
  return(list(
    params = result$par,
    fitted_values = fitted,
    residuals = residuals,
    rmse = rmse,
    mae = mae,
    r_squared = r_squared,
    convergence = result$convergence,
    iterations = result$counts[1],
    slope = slope,
    level = level,
    curvature = curvature
  ))
}

#' Generate Fixed Maturity Interest Rate Series Using Svensson Model
#'
#' Creates a time series of interest rates by fitting the model day-by-day.
#' Optimized for performance using dplyr.
#'
#' @param dados_tesouro Data frame with ref_date, matur_date, yield_bid
#' @param target_maturities Numeric vector of maturities to calculate (default: 0.25, 1, 2, 3, 5)
#' @param include_diagnostics Logical. If TRUE, includes quality metrics for each date.
#'
#' @return If include_diagnostics=FALSE: Data frame with ref_date and fitted rates for target maturities
#'         If include_diagnostics=TRUE: Data frame also including:
#'         - n_obs: number of observations used
#'         - rmse: root mean squared error
#'         - r_squared: coefficient of determination
#'         - convergence: optimization convergence status
#'         - slope: yield curve slope parameter
#'         - level: yield curve level parameter
#'         - curvature: yield curve curvature
#'
#' @importFrom dplyr mutate filter group_by summarize ungroup select across
#' @importFrom purrr map map_dbl
#' @importFrom tidyr unnest_wider
#'
#' @export
generate_fixed_maturity_series <- function(dados_tesouro, 
                                           target_maturities = c(0.25, 1, 2, 3, 5),
                                           include_diagnostics = FALSE) {
  
  # Compute maturity in years (prefer pre-computed maturity_years if available)
  if ("maturity_years" %in% names(dados_tesouro)) {
    dados_clean <- dados_tesouro |>
      dplyr::mutate(
        maturity = maturity_years,
        yield = yield_bid
      ) |>
      dplyr::filter(maturity > 0)
  } else {
    dados_clean <- dados_tesouro |>
      dplyr::mutate(
        maturity = as.numeric(matur_date - ref_date) / 252,
        yield = yield_bid
      ) |>
      dplyr::filter(maturity > 0)
  }
  
  # Function to apply fit and predict for a single group/date
  process_date <- function(mats, yields) {
    if (include_diagnostics) {
      fit_result <- fit_svensson(mats, yields, return_diagnostics = TRUE)
      
      if (any(is.na(fit_result$params))) {
        return(list(
          rates = rep(NA_real_, length(target_maturities)),
          n_obs = length(mats),
          rmse = NA_real_,
          r_squared = NA_real_,
          convergence = -1,
          slope = NA_real_,
          level = NA_real_,
          curvature = NA_real_
        ))
      }
      
      fitted_rates <- svensson_rate(
        target_maturities, 
        fit_result$params[1], fit_result$params[2], fit_result$params[3], 
        fit_result$params[4], fit_result$params[5], fit_result$params[6]
      )
      
      return(list(
        rates = fitted_rates,
        n_obs = length(mats),
        rmse = fit_result$rmse,
        r_squared = fit_result$r_squared,
        convergence = fit_result$convergence,
        slope = fit_result$slope,
        level = fit_result$level,
        curvature = fit_result$curvature
      ))
    } else {
      # Original behavior for backward compatibility
      params <- fit_svensson(mats, yields, return_diagnostics = FALSE)
      
      if (any(is.na(params))) {
        return(rep(NA_real_, length(target_maturities)))
      }
      
      svensson_rate(
        target_maturities, 
        params[1], params[2], params[3], params[4], params[5], params[6]
      )
    }
  }
  
  # Group by date and process
  # Using data.table would be faster for millions of rows, but dplyr is sufficient here
  result_df <- dados_clean |>
    dplyr::group_by(ref_date) |>
    # Filter dates with enough data upfront to save processing
    dplyr::filter(dplyr::n() >= 6) |>
    dplyr::summarise(
      result = list(process_date(maturity, yield)),
      .groups = "drop"
    )
  
  if (!include_diagnostics) {
    # Original behavior - only return rates
    col_names <- paste0("titulo_", gsub("\\.", "_", as.character(target_maturities)), "ano")
    
    result_expanded <- result_df |>
      dplyr::mutate(
        rates_matrix = do.call(rbind, result)
      )
    
    final_df <- cbind(
      result_expanded["ref_date"],
      as.data.frame(result_expanded$rates_matrix)
    )
    colnames(final_df) <- c("data", col_names)
    
    return(final_df)
  } else {
    # Extract diagnostics and rates
    col_names <- paste0("titulo_", gsub("\\.", "_", as.character(target_maturities)), "ano")
    
    # Extract each component
    final_df <- result_df |>
      dplyr::mutate(
        rates_matrix = lapply(result, function(x) x$rates),
        n_obs = sapply(result, function(x) x$n_obs),
        rmse = sapply(result, function(x) x$rmse),
        r_squared = sapply(result, function(x) x$r_squared),
        convergence = sapply(result, function(x) x$convergence),
        slope = sapply(result, function(x) x$slope),
        level = sapply(result, function(x) x$level),
        curvature = sapply(result, function(x) x$curvature)
      ) |>
      dplyr::select(-result)
    
    # Convert rates to columns
    rates_df <- as.data.frame(do.call(rbind, final_df$rates_matrix))
    colnames(rates_df) <- col_names
    
    # Combine everything
    final_df <- cbind(
      data.frame(data = final_df$ref_date),
      rates_df,
      data.frame(
        n_obs = final_df$n_obs,
        rmse = final_df$rmse,
        r_squared = final_df$r_squared,
        convergence = final_df$convergence,
        slope = final_df$slope,
        level = final_df$level,
        curvature = final_df$curvature
      )
    )
    
    return(final_df)
  }
}

#' Calculate Forward Rates from Svensson Parameters
#'
#' Computes forward rates using the Svensson model parameters.
#' Forward rate f(t1, t2) is the rate agreed today for borrowing
#' from time t1 to time t2.
#'
#' @param t Numeric vector. Time to maturity in years.
#' @param beta0 Numeric. Long-term interest rate level parameter.
#' @param beta1 Numeric. Short-term component parameter.
#' @param beta2 Numeric. Medium-term component parameter.
#' @param beta3 Numeric. Second medium-term component parameter.
#' @param tau1 Numeric. First decay parameter (must be positive).
#' @param tau2 Numeric. Second decay parameter (must be positive).
#'
#' @return Numeric vector. The forward rate for the given maturities.
#'
#' @export
svensson_forward_rate <- function(t, beta0, beta1, beta2, beta3, tau1, tau2) {
  # Instantaneous forward rate is the derivative of the spot rate times t
  # f(t) = beta0 + beta1*exp(-t/tau1) + 
  #        beta2*(t/tau1)*exp(-t/tau1) + 
  #        beta3*(t/tau2)*exp(-t/tau2)
  
  exp_t_tau1 <- exp(-t / tau1)
  exp_t_tau2 <- exp(-t / tau2)
  
  forward <- beta0 + 
             beta1 * exp_t_tau1 + 
             beta2 * (t / tau1) * exp_t_tau1 + 
             beta3 * (t / tau2) * exp_t_tau2
  
  return(forward)
}

#' Generate Summary Statistics for Fitted Svensson Model
#'
#' Provides comprehensive diagnostic summary for model quality assessment.
#'
#' @param fit_result List returned by fit_svensson with return_diagnostics=TRUE
#'
#' @return List with summary statistics and interpretation
#'
#' @export
summarize_svensson_fit <- function(fit_result) {
  if (!"params" %in% names(fit_result)) {
    stop("fit_result must be output from fit_svensson with return_diagnostics=TRUE")
  }
  
  # Parameter names
  param_names <- c("beta0 (Level)", "beta1 (Slope)", "beta2 (Curvature1)", 
                   "beta3 (Curvature2)", "tau1 (Decay1)", "tau2 (Decay2)")
  
  # Create parameter table
  param_df <- data.frame(
    Parameter = param_names,
    Value = round(fit_result$params, 6)
  )
  
  # Quality metrics
  quality <- data.frame(
    Metric = c("RMSE", "MAE", "R-squared", "Convergence"),
    Value = c(
      round(fit_result$rmse, 6),
      round(fit_result$mae, 6),
      round(fit_result$r_squared, 4),
      fit_result$convergence
    ),
    Interpretation = c(
      ifelse(fit_result$rmse < 0.001, "Excellent", 
             ifelse(fit_result$rmse < 0.01, "Good", "Poor")),
      ifelse(fit_result$mae < 0.001, "Excellent",
             ifelse(fit_result$mae < 0.01, "Good", "Poor")),
      ifelse(fit_result$r_squared > 0.99, "Excellent",
             ifelse(fit_result$r_squared > 0.95, "Good", "Poor")),
      ifelse(fit_result$convergence == 0, "Success", "Failed")
    )
  )
  
  # Curve characteristics
  curve_char <- data.frame(
    Characteristic = c("Level (Long-term rate)", "Slope (Short-Long spread)", 
                      "Curvature", "Shape"),
    Value = c(
      round(fit_result$level, 4),
      round(fit_result$slope, 4),
      round(fit_result$curvature, 4),
      ifelse(fit_result$slope > 0, "Normal (Upward)",
             ifelse(fit_result$slope < -0.01, "Inverted", "Flat"))
    )
  )
  
  return(list(
    parameters = param_df,
    quality_metrics = quality,
    curve_characteristics = curve_char,
    residuals_summary = summary(fit_result$residuals)
  ))
}

#' Plot Svensson Model Fit
#'
#' Creates diagnostic plots for visual assessment of model quality.
#' Requires ggplot2 package.
#'
#' @param maturities Numeric vector. Observed maturities.
#' @param rates Numeric vector. Observed rates.
#' @param fit_result List returned by fit_svensson with return_diagnostics=TRUE
#'
#' @return ggplot object or NULL if ggplot2 not available
#'
#' @export
plot_svensson_fit <- function(maturities, rates, fit_result) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    warning("ggplot2 package required for plotting. Returning NULL.")
    return(NULL)
  }
  
  # Sort data
  ord <- order(maturities)
  maturities <- maturities[ord]
  rates <- rates[ord]
  fitted <- fit_result$fitted_values[ord]
  
  # Create data frame for plotting
  plot_data <- data.frame(
    Maturity = maturities,
    Observed = rates,
    Fitted = fitted
  )
  
  # Create plot
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = Maturity)) +
    ggplot2::geom_point(ggplot2::aes(y = Observed, color = "Observed"), size = 3) +
    ggplot2::geom_line(ggplot2::aes(y = Fitted, color = "Fitted"), size = 1) +
    ggplot2::labs(
      title = "Svensson Model Fit",
      subtitle = sprintf("R² = %.4f, RMSE = %.6f", 
                         fit_result$r_squared, fit_result$rmse),
      x = "Maturity (years)",
      y = "Yield",
      color = ""
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "top",
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
      plot.subtitle = ggplot2::element_text(hjust = 0.5)
    )
  
  return(p)
}

#' Calculate Yield Curve Spreads
#'
#' Computes common yield curve spreads used in economic analysis.
#'
#' @param rates_df Data frame with yield curve data from generate_fixed_maturity_series
#' @param short_maturity Character. Column name for short-term rate (default: "titulo_0_25ano")
#' @param long_maturity Character. Column name for long-term rate (default: "titulo_5ano")
#'
#' @return Data frame with date and spread columns
#'
#' @export
calculate_yield_spreads <- function(rates_df, 
                                   short_maturity = "titulo_0_25ano",
                                   long_maturity = "titulo_5ano") {
  
  if (!all(c("data", short_maturity, long_maturity) %in% names(rates_df))) {
    stop("Required columns not found in rates_df")
  }
  
  result <- data.frame(
    data = rates_df$data,
    spread = rates_df[[long_maturity]] - rates_df[[short_maturity]],
    short_rate = rates_df[[short_maturity]],
    long_rate = rates_df[[long_maturity]]
  )
  
  # Add interpretation
  result$shape <- ifelse(result$spread > 0.02, "Steep",
                        ifelse(result$spread > -0.01, "Normal",
                              ifelse(result$spread < -0.01, "Inverted", "Flat")))
  
  return(result)
}
