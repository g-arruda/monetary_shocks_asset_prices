# ============================================================
# Validation of the Newey-West option of compute_factor_space_wald
# against the authors' own MATLAB suite (codigo_olea/,
# github.com/jm4474/SVARIV). Two independent checks:
#
#   A. Kernel.  A literal line-by-line transcription of
#      functions/RForm/NW_hac_STATA.m, compared against the
#      accumulation built into compute_factor_space_wald, at lags
#      0..8 on synthetic data. Self-contained.
#
#   B. End-to-end, NWlags = 8.  The official tax application
#      (TaxSVARIV.m, p = 2, NWlags = 8, n = 9) ships a saved
#      reduced form, Data/Tax/Tax_RForm.mat, whose WHat carries the
#      Gamma block that CovAhat_Sigmahat_Gamma.m produced. We
#      rebuild that block from (eta, z, X) and check it matches.
#
#      B also tests something A cannot: the project applies the
#      Shat correction by residualizing z on the VAR regressors
#      (impulse_responde.R:197) instead of forming the official
#      -kron(Q2 Q1^-1, I) block. The two are equal because Shat is
#      a constant matrix and the NW form is bilinear, so
#      Shat*NW(M)*Shat' = NW(M Shat') — but that is an argument,
#      and B is the measurement. It is sharp: only lags = 8 matches.
#
# Fixture: output/validation/olea_tax_{eta,z,X,WHat_gamma}.csv,
# extracted once from Tax_RForm.mat (codigo_olea/ is gitignored, so
# the .mat is not assumed present). Provenance in the working note
# relatorio/working-notes/2026-07-27_robustez_xi_mp_e_construcao.md.
# ============================================================

source("R/modeling/impulse_responde.R")

TOL_KERNEL <- 1e-12
TOL_MATLAB <- 1e-8

# ---- Literal transcription of NW_hac_STATA.m ----------------

nw_hac_stata <- function(vars, lags) {
  Tn     <- nrow(vars)
  Sigma0 <- (1 / Tn) * (t(vars) %*% vars)
  Sigma_cov <- function(k) {
    (1 / Tn) * t(vars[1:(Tn - k), , drop = FALSE]) %*%
      vars[(1 + k):Tn, , drop = FALSE]
  }
  Sigma <- Sigma0
  for (n in seq_len(lags)) {
    Sigma <- Sigma + (1 - n / (lags + 1)) * (Sigma_cov(n) + t(Sigma_cov(n)))
  }
  Sigma
}

# Rebuild what compute_factor_space_wald does internally, so the
# comparison isolates the kernel.
wald_by_hand <- function(eta, Z, controls, lags) {
  Z_use <- as.numeric(qr.resid(qr(cbind(1, as.matrix(controls))), Z))
  G     <- Z_use * eta
  Gamma <- colMeans(G)
  V     <- sweep(G, 2, Gamma)
  W     <- nw_hac_stata(V, lags)
  list(wald_k     = nrow(eta) * Gamma^2 / diag(W),
       wald_joint = nrow(eta) * drop(t(Gamma) %*% solve(W, Gamma)))
}

# ---- A. Kernel check ----------------------------------------

set.seed(42)
T_sim <- 200L; q_sim <- 4L
eta_s  <- matrix(rnorm(T_sim * q_sim), T_sim, q_sim)
z_s    <- rnorm(T_sim)
ctrl_s <- matrix(rnorm(T_sim * 5L), T_sim, 5L)

cat("A. Kernel vs literal NW_hac_STATA.m transcription\n")
cat("   lag   max|dxi_k|    |dxi_joint|\n")
max_dev_a <- 0
for (L in 0:8) {
  got <- compute_factor_space_wald(eta_s, z_s, controls = ctrl_s, nw_lags = L)
  exp <- wald_by_hand(eta_s, z_s, ctrl_s, L)
  d_k <- max(abs(got$wald_k - exp$wald_k))
  d_j <- abs(got$wald_joint - exp$wald_joint)
  max_dev_a <- max(max_dev_a, d_k, d_j)
  cat(sprintf("   %3d   %.3e     %.3e\n", L, d_k, d_j))
}

# Bartlett weights agree with the standard implementation
w_ours <- 1 - (1:4) / 5
w_sand <- sandwich::kweights((1:4) / 5, "Bartlett")
stopifnot(max(abs(w_ours - w_sand)) < TOL_KERNEL)

# ---- B. End-to-end against the official tax WHat ------------

fix <- file.path("output/validation",
                 c("olea_tax_eta.csv", "olea_tax_z.csv",
                   "olea_tax_X.csv", "olea_tax_WHat_gamma.csv"))

cat("\nB. Official tax application (TaxSVARIV.m, n = 9, p = 2, NWlags = 8)\n")

if (!all(file.exists(fix))) {
  cat("   SKIPPED — fixture missing:",
      paste(basename(fix[!file.exists(fix)]), collapse = ", "), "\n")
  best_lag <- NA_integer_
} else {
  rd     <- function(f) as.matrix(read.csv(f, header = FALSE))
  eta_t  <- rd(fix[1])
  z_t    <- as.numeric(rd(fix[2]))
  X_t    <- rd(fix[3])
  Wg_off <- rd(fix[4])

  # X already carries the constant, so residualize on X as-is.
  z_res <- as.numeric(qr.resid(qr(X_t), z_t))
  G_t   <- z_res * eta_t
  V_t   <- sweep(G_t, 2, colMeans(G_t))

  cat("   lag   max rel. diff vs official WHat Gamma block\n")
  devs <- setNames(numeric(0), character(0))
  for (L in c(0L, 4L, 8L, 12L)) {
    W   <- nw_hac_stata(V_t, L)
    rel <- max(abs(W - Wg_off)) / max(abs(Wg_off))
    devs[as.character(L)] <- rel
    cat(sprintf("   %3d   %.3e%s\n", L, rel,
                if (L == 8L) "   <- TaxSVARIV.m:52" else ""))
  }
  best_lag <- as.integer(names(which.min(devs)))
}

# ---- Verdict -------------------------------------------------

ok_a <- max_dev_a < TOL_KERNEL
ok_b <- is.na(best_lag) || (best_lag == 8L && min(devs) < TOL_MATLAB)

cat("\n")
if (ok_a && ok_b) {
  if (is.na(best_lag)) {
    cat("VALIDATION PASSED (A only; B skipped for want of the fixture).\n")
  } else {
    cat(sprintf(paste0("VALIDATION PASSED: kernel exact to %.0e, and the tax ",
                       "Gamma block\nmatches at NWlags = 8 (rel. %.1e) and at ",
                       "no other lag.\n"), TOL_KERNEL, min(devs)))
  }
} else {
  stop("VALIDATION FAILED (A ok = ", ok_a, ", B ok = ", ok_b, ")")
}
