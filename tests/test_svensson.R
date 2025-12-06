
# Test suite for Svensson Model Implementation (svensson_model.R) using Base R

message("Running Svensson Model Tests...")

# Load the helper function source
source("R/modeling/svensson_model.R")

# Test 1: svensson_rate calculation
message("Test 1: Check svensson_rate calculation...")
rate_t0 <- svensson_rate(t = 0.0001, 2, 3, 4, 5, 1, 1)
if (abs(rate_t0 - 5) > 0.01) stop(paste("Test 1 Failed: Expected approx 5, got", rate_t0))

t_vec <- c(1, 2, 3)
rates <- svensson_rate(t_vec, 0.05, -0.02, -0.01, 0.01, 1.5, 2.0)
if (length(rates) != 3) stop("Test 1 Failed: Vectorization length mismatch")

# Test 2: fit_svensson optimization
message("Test 2: Check optimization recovery...")
true_params <- c(0.05, -0.02, 0.02, 0.01, 2.0, 5.0)
maturities <- seq(0.5, 10, by = 0.5)
rates_clean <- svensson_rate(maturities, true_params[1], true_params[2], 
                       true_params[3], true_params[4], true_params[5], true_params[6])

fitted_params <- fit_svensson(maturities, rates_clean)
fitted_rates <- svensson_rate(maturities, fitted_params[1], fitted_params[2],
                              fitted_params[3], fitted_params[4], fitted_params[5], fitted_params[6])
mse <- mean((fitted_rates - rates_clean)^2)
if (mse > 1e-5) stop(paste("Test 2 Failed: MSE too high:", mse))

# Test 3: Insufficient data
message("Test 3: Check insufficient data handling...")
tryCatch({
  res_na <- suppressWarnings(fit_svensson(c(1, 2), c(0.05, 0.06)))
  if (!all(is.na(res_na))) stop("Test 3 Failed: Should return NAs for small N")
}, error = function(e) stop(paste("Test 3 Failed with error:", e)))

# Test 4: Batch processing
message("Test 4: Check batch processing (generate_fixed_maturity_series)...")
dates <- as.Date("2023-01-01")
df_list <- list()
for (i in 1:10) {
  df_list[[i]] <- data.frame(
    ref_date = dates,
    matur_date = dates + i * 365,
    yield_bid = 0.05 + 0.001 * i
  )
}
dados_tesouro <- do.call(rbind, df_list)
res <- generate_fixed_maturity_series(dados_tesouro)

if (nrow(res) != 1) stop("Test 4 Failed: Expected 1 row result")
if (any(is.na(res[, 2:6]))) stop("Test 4 Failed: NAs found in result columns")

message("All tests passed successfully!")

