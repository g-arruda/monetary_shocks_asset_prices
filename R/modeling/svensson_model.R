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
#'
#' @return Numeric vector of parameters (beta0, beta1, beta2, beta3, tau1, tau2) 
#'         or NA vector if estimation fails/insufficient data.
#'
#' @export
fit_svensson <- function(maturities, rates) {
  # Check for sufficient data points
  # Svensson has 6 parameters, need at least 6 points for unique identification
  # allowing 4 (as in original) leads to overfitting/non-uniqueness
  if (length(maturities) < 6) {
    warning("Insufficient data points for Svensson model (need >= 6). returning NA.")
    return(rep(NA_real_, 6))
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
    
    # Sum of Squared Errors
    sum((rates - predicted)^2)
  }
  
  # Bounds
  # Tau must be strictly positive to avoid division by zero
  # Betas constrained to [-0.5, 0.5] (assuming rates are decimals, e.g. 0.05)
  lower <- c(-0.5, -0.5, -0.5, -0.5, 0.1, 0.1)
  upper <- c(0.5, 0.5, 0.5, 0.5, 10, 10)
  
  # Heuristic Initialization for better convergence
  # Beta0: Long run level -> approx last rate
  start_beta0 <- tail(rates, 1)
  # Beta1: Approx spread (Short - Long)
  start_beta1 <- head(rates, 1) - start_beta0
  
  # Initial values
  start_par <- c(
    start_beta0, # beta0
    start_beta1, # beta1
    0.0,         # beta2 (curvature starts at 0)
    0.0,         # beta3
    1.0,         # tau1
    1.0          # tau2
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
    
    if (result$convergence != 0) {
      warning(paste("Optimization did not converge code:", result$convergence))
    }
    
    return(result$par)
  }, error = function(e) {
    warning(paste("Optimization failed:", e$message))
    return(rep(NA_real_, 6))
  })
}

#' Generate Fixed Maturity Interest Rate Series Using Svensson Model
#'
#' Creates a time series of interest rates by fitting the model day-by-day.
#' Optimized for performance using dplyr.
#'
#' @param dados_tesouro Data frame with ref_date, matur_date, yield_bid
#' @param target_maturities Numeric vector of maturities to calculate (default: 0.25, 1, 2, 3, 5)
#'
#' @importFrom dplyr mutate filter group_by summarize ungroup select across
#' @importFrom purrr map map_dbl
#' @importFrom tidyr unnest_wider
#'
#' @export
generate_fixed_maturity_series <- function(dados_tesouro, 
                                           target_maturities = c(0.25, 1, 2, 3, 5)) {
  
  # Compute maturity in years
  dados_clean <- dados_tesouro |>
    dplyr::mutate(
      maturity = as.numeric(matur_date - ref_date) / 365,
      yield = yield_bid
    ) |>
    dplyr::filter(maturity > 0)
  
  # Function to apply fit and predict for a single group/date
  process_date <- function(mats, yields) {
    params <- fit_svensson(mats, yields)
    
    if (any(is.na(params))) {
      return(rep(NA_real_, length(target_maturities)))
    }
    
    svensson_rate(
      target_maturities, 
      params[1], params[2], params[3], params[4], params[5], params[6]
    )
  }
  
  # Group by date and process
  # Using data.table would be faster for millions of rows, but dplyr is sufficient here
  result_df <- dados_clean |>
    dplyr::group_by(ref_date) |>
    # Filter dates with enough data upfront to save processing
    dplyr::filter(dplyr::n() >= 6) |>
    dplyr::summarise(
      rates = list(process_date(maturity, yield)),
      .groups = "drop"
    )
  
  # Expand the list column into separate columns
  # Create column names
  col_names <- paste0("titulo_", gsub("\\.", "_", as.character(target_maturities)), "ano")
  
  # Unpack the list column
  result_expanded <- result_df |>
    dplyr::mutate(
      rates_matrix = do.call(rbind, rates)
    )
  
  # Bind specific columns
  # A bit manual to ensure clean data frame structure
  final_df <- cbind(
    result_expanded["ref_date"],
    as.data.frame(result_expanded$rates_matrix)
  )
  colnames(final_df) <- c("data", col_names)
  
  return(final_df)
}
