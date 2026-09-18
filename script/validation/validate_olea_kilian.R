# ============================================================
# End-to-end validation of the MOSW relevance statistics against
# the published numbers in Montiel Olea, Stock & Watson (2021,
# J. Econometrics, sec. 5): Kilian (2009) oil SVAR, VAR(24),
# instrument = Kilian (2008) exogenous oil supply shocks.
#
# Published targets:  xi_1 = 4.4   robust first-stage F = 9.4
#
# Runs off output/validation/olea_oil_fixture.rds — the authors' own
# reduced form (Y, X, eta, z, AL, Gamma), extracted once from
# codigos_externos/codigo_olea/Output/Oil/Mat/. The fixture exists
# because codigo_olea/ is gitignored: reading Data/Oil/Data.xls
# directly, as this script used to, made it unrunnable in a clean
# clone (and it had been silently broken since the reference code
# moved into codigos_externos/). Same fixture and same rationale as
# script/validation/validate_hac_kernel.R.
#
# The VAR is re-estimated here from the authors' Y rather than taken
# from the fixture, so the check still covers the estimation step:
# common sample 1973:2-2004:9 (380 obs, 356 after 24 lags), norm = 1
# (oil production), NWlags = 0.
# ============================================================

source("R/modeling/impulse_response.R")

FIXTURE <- "output/validation/olea_oil_fixture.rds"

if (!file.exists(FIXTURE)) {
  cat("SKIPPED — fixture ausente:", FIXTURE, "\n")
  quit(save = "no", status = 0)
}

fx <- readRDS(FIXTURE)
p  <- fx$p
Y  <- fx$Y                              # T x n, LHS do VAR (já sem as p defasagens)
X  <- fx$X                              # T x (1 + n*p), constante na 1a coluna
z  <- fx$z

# VAR(24) com constante, replicando RForm_VAR.m
B   <- solve(crossprod(X), crossprod(X, Y))
eta <- Y - X %*% B
T_eff <- nrow(eta)

X_lags <- X[, -1, drop = FALSE]

dev_eta <- max(abs(eta - t(fx$eta)))
dev_al  <- max(abs(t(B[-1, , drop = FALSE]) - fx$AL))

# xi_1 via our implementation (Shat correction = residualize z on X)
wald <- compute_factor_space_wald(eta, z, controls = X_lags)

# Robust first-stage F in the normalization direction. Regressing the VAR
# innovation on z and the VAR controls is numerically equivalent to the
# authors' regression of Y_1t on the same right-hand side.
first_stage <- compute_robust_first_stage_F(eta[, 1], z, controls = X_lags)
F_hc1 <- first_stage$f_statistic

cat(sprintf("T (effective)                 : %d   (paper: 356)\n", T_eff))
cat(sprintf("VAR re-estimated vs RForm     : eta %.2e, AL %.2e\n", dev_eta, dev_al))
cat(sprintf("xi_1 (ours, Shat-corrected)   : %.3f (paper: 4.4)\n", wald$wald_k[1]))
cat(sprintf("Robust first-stage F, HC1     : %.3f (paper: 9.4)\n", F_hc1))

stopifnot(dev_eta < 1e-10, dev_al < 1e-10,
          abs(wald$wald_k[1] - 4.4) < 0.15, abs(F_hc1 - 9.4) < 0.15)
cat("\nVALIDATION PASSED: both statistics match the published values.\n")
