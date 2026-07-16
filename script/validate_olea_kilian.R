# ============================================================
# End-to-end validation of the MOSW relevance statistics against
# the published numbers in Montiel Olea, Stock & Watson (2021,
# J. Econometrics, sec. 5): Kilian (2009) oil SVAR, VAR(24),
# instrument = Kilian (2008) exogenous oil supply shocks.
#
# Published targets:  xi_1 = 4.4   robust first-stage F = 9.4
#
# Data and conventions from the authors' own suite (codigo_olea/,
# github.com/jm4474/SVARIV): Data.xls is the common sample
# 1973:2-2004:9 (380 obs), norm = 1 (oil production), NWlags = 0.
# ============================================================

suppressPackageStartupMessages({
  library(readxl)
  library(sandwich)
  library(lmtest)
})

source("R/modeling/impulse_responde.R")

p <- 24L

Y <- as.matrix(read_excel("codigo_olea/Data/Oil/Data.xls", col_names = FALSE))
z <- as.numeric(read.table("codigo_olea/Data/Oil/ExternalIV.txt")[[1]])
stopifnot(nrow(Y) == length(z))

T_full <- nrow(Y)
n      <- ncol(Y)

# VAR(24) with constant, replicating RForm_VAR.m (X = [1, Y_{t-1}, ..., Y_{t-p}])
X_lags <- do.call(cbind, lapply(seq_len(p), function(k)
  Y[(p + 1 - k):(T_full - k), , drop = FALSE]))
Y_lhs  <- Y[(p + 1):T_full, , drop = FALSE]
X_full <- cbind(1, X_lags)
B      <- solve(crossprod(X_full), crossprod(X_full, Y_lhs))
eta    <- Y_lhs - X_full %*% B          # T x n VAR residuals
Z_al   <- z[(p + 1):T_full]
T_eff  <- nrow(eta)

# xi_1 via our implementation (Shat correction = residualize z on X)
wald <- compute_factor_space_wald(eta, Z_al, controls = X_lags)

# Robust first-stage F: Y_1t on z_t with VAR lags as controls. The published
# 9.4 matches HC1 (the Stata-default degrees-of-freedom correction), not HC0.
fs     <- lm(Y_lhs[, 1] ~ Z_al + X_lags)
F_hc0  <- unname(coeftest(fs, vcov = vcovHC(fs, type = "HC0"))["Z_al", "t value"])^2
F_hc1  <- unname(coeftest(fs, vcov = vcovHC(fs, type = "HC1"))["Z_al", "t value"])^2

cat(sprintf("T (effective)                 : %d   (paper: 356)\n", T_eff))
cat(sprintf("xi_1 (ours, Shat-corrected)   : %.3f (paper: 4.4)\n", wald$wald_k[1]))
cat(sprintf("Robust first-stage F, HC1     : %.3f (paper: 9.4)\n", F_hc1))
cat(sprintf("Robust first-stage F, HC0     : %.3f (anti-conservative vs HC1)\n", F_hc0))
cat(sprintf("Joint Wald T G'W^-1 G (chi2_%d): %.3f (p = %.4f)  [WaldstatFull]\n",
            wald$q, wald$wald_joint, wald$p_joint))
cat(sprintf("xi_k per equation             : %s\n",
            paste(sprintf("%.3f", wald$wald_k), collapse = "  ")))

stopifnot(abs(wald$wald_k[1] - 4.4) < 0.15, abs(F_hc1 - 9.4) < 0.15)
cat("\nVALIDATION PASSED: both statistics match the published values.\n")
