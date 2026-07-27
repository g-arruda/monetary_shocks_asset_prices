# ============================================================
# End-to-end validation of the GMR (2017) PML-ICA translation in
# R/identification/nongaussian_gmr.R.
#
# Five blocks:
#   A. Analytic gradient vs numDeriv, and orthogonality of C, at n = 3 and 6.
#   B. Omega / A / V against IdSS (which is correct for these three at any n,
#      because they take C as an argument instead of building it).
#   C. The paper's own application (§3.2): US VAR(6) on inflation, activity and
#      the short rate, 1959:IV-2015:I, oil price as exogenous regressor.
#      Reproduces Table 4 and the SRR-scheme tests, and cross-checks the point
#      estimate against IdSS::estim.SVAR.ICA (valid only at n = 3, see below).
#   D. Simulation at n = 6 with a known C0: bias, coverage of the Prop. 4
#      intervals, and the same exercise with two Gaussian components — the
#      analogue of what this panel's factor innovations look like.
#   E. Guard test asserting the IdSS defects, so that an upstream fix is
#      noticed rather than silently diverging from this translation.
#
# THE IdSS DEFECTS (n >= 4 only; the published application is n = 3):
#   make.M and make.C both mis-order the upper triangle of the skew-symmetric
#   matrix, so C is not orthogonal; and the analytic gradient uses (I + A) where
#   the Cayley differential requires (I + C). Detail in the header of
#   R/identification/nongaussian_gmr.R.
#
# Run: Rscript script/validate_gmr_ica.R
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(numDeriv)
})

source("R/identification/nongaussian_gmr.R")

has_idss <- requireNamespace("IdSS", quietly = TRUE)
if (!has_idss)
  message("[!] IdSS not installed — blocks B, C-cross and E will be skipped.\n",
          "    remotes::install_github(\"jrenne/IdSS\")")

pass <- function(ok, label, detail = "") {
  cat(sprintf("  [%s] %-58s %s\n", if (ok) "OK" else "FAIL", label, detail))
  if (!ok) assign("N_FAIL", get0("N_FAIL", ifnotfound = 0) + 1, envir = .GlobalEnv)
  invisible(ok)
}
N_FAIL <- 0

# ------------------------------------------------------------------
# A. Gradient and orthogonality
# ------------------------------------------------------------------
cat("\n== A. Gradient and orthogonality ==\n")
set.seed(42)
for (n in c(3L, 6L)) {
  distri <- gmr_distri_mixtures(n)
  Yw <- matrix(rt(200 * n, df = 6) / sqrt(6 / 4), 200, n)
  Yw <- Yw %*% solve(t(chol(var(Yw))))
  a  <- rnorm(n * (n - 1) / 2, 0, 0.3)

  ga  <- pml_neg_grad(a, Yw, distri)
  gn  <- numDeriv::grad(function(z) pml_neg_loglik(z, Yw, distri), a)
  rel <- max(abs(ga - gn)) / max(abs(gn))
  pass(rel < 1e-5, sprintf("n=%d analytic gradient matches numDeriv", n),
       sprintf("rel err %.2e", rel))

  C <- cayley_C(a, n)
  err <- max(abs(crossprod(C) - diag(n)))
  pass(err < 1e-10, sprintf("n=%d Cayley map returns an orthogonal C", n),
       sprintf("max|C'C - I| %.2e", err))
}

# ------------------------------------------------------------------
# B. Prop. 4 machinery against IdSS
# ------------------------------------------------------------------
cat("\n== B. Omega / A / V against IdSS ==\n")
if (has_idss) {
  set.seed(7)
  for (n in c(3L, 6L)) {
    distri <- gmr_distri_mixtures(n)
    eps <- matrix(rt(300 * n, df = 7) / sqrt(7 / 5), 300, n)
    C   <- cayley_C(rnorm(n * (n - 1) / 2, 0, 0.3), n)
    d1 <- max(abs(gmr_omega(eps, distri)          - IdSS::make.Omega(eps, distri)))
    d2 <- max(abs(gmr_A_matrix(eps, distri, C)    - IdSS::make.A.matrix(eps, distri, C)))
    d3 <- max(abs(gmr_asympt_cov(eps, distri, C)$V -
                    IdSS::make.Asympt.Cov.delta(eps, distri, C)))
    pass(max(d1, d2, d3) < 1e-10, sprintf("n=%d Omega, A and V reproduce IdSS", n),
         sprintf("max diff %.2e", max(d1, d2, d3)))
  }

  # match_columns against the exhaustive n! 2^n enumeration
  set.seed(11); n <- 3L
  Cr <- cayley_C(rnorm(3, 0, 0.5), n)
  Cn <- cayley_C(rnorm(3, 0, 0.5), n)
  ours <- match_columns(Cr, Cn)$C
  theirs <- IdSS:::find.permut(Cr, Cn)$C.permut
  pass(max(abs(ours - theirs)) < 1e-10,
       "match_columns agrees with exhaustive find.permut (n=3)",
       sprintf("max diff %.2e", max(abs(ours - theirs))))
} else {
  cat("  [skip] IdSS unavailable\n")
}

# ------------------------------------------------------------------
# C. The paper's application, §3.2 / Table 4
# ------------------------------------------------------------------
cat("\n== C. GMR (2017) §3.2 US application ==\n")

if (has_idss) {
  data(US3var, package = "IdSS")
  d <- US3var[US3var$Date >= "1959-04-01" & US3var$Date <= "2015-01-01", ]

  # The paper's pseudo-densities: three distinct asymmetric Gaussian mixtures.
  distri3 <- list(type = rep("mixt.gaussian", 3), df = rep(NaN, 3),
                  p = rep(0.5, 3), mu = rep(0.1, 3), sigma = c(0.5, 0.7, 1.3))

  run_case <- function(activity, label) {
    Y  <- as.matrix(d[, c("infl", activity, "r")])
    Tn <- nrow(Y); n <- ncol(Y); nb_lags <- 6

    X <- do.call(cbind, lapply(seq_len(nb_lags), function(i)
      rbind(matrix(NA, i, n), Y[1:(Tn - i), ])))
    X <- cbind(X, d$commo)                        # oil as exogenous regressor
    U <- sapply(seq_len(n), function(i) lm(Y[, i] ~ X)$residuals)

    Om12 <- t(chol(var(U)))                       # S, lower Cholesky
    Eps  <- U %*% t(solve(Om12))                  # prewhitened residuals

    fit <- estim_ica_pml(Eps, distri3, n_starts = 40L, seed = 1)
    cv  <- gmr_asympt_cov(fit$eps, distri3, fit$C)

    # Jarque-Bera on the reduced-form residuals: the paper reports non-normality
    # for all three, which is what opens the door to ICA.
    jb_p <- apply(U, 2, function(x) {
      m <- length(x); s <- mean((x - mean(x))^3) / sd(x)^3
      k <- mean((x - mean(x))^4) / sd(x)^4
      pchisq(m / 6 * (s^2 + (k - 3)^2 / 4), 2, lower.tail = FALSE)
    })

    # §2.5 test of H0: C in P(Id) — the recursive / short-run-restriction scheme.
    wald <- gmr_wald(fit$C, diag(n), cv$A, cv$Omega, T_eff = nrow(fit$eps))

    cat(sprintf("\n  -- %s --\n", label))
    cat(sprintf("  JB p-values on reduced-form residuals: %s\n",
                paste(sprintf("%.4f", jb_p), collapse = "  ")))
    cat("  C (PML) with asymptotic standard errors:\n")
    se <- matrix(sqrt(pmax(diag(cv$V), 0)), n, n)
    for (i in seq_len(n))
      cat(sprintf("    %s\n", paste(sprintf("%7.3f (%.3f)", fit$C[i, ], se[i, ]),
                                    collapse = "  ")))
    cat(sprintf("  cond(A) = %.3e ; multi-start spread = %.2e (%d/%d at best)\n",
                cv$cond_A, fit$spread, fit$n_at_best, fit$n_starts))
    cat(sprintf("  Wald H0: C in P(Id)  xi = %.3f  df = %d  p = %.4f\n",
                wald$xi, wald$df, wald$p_value))

    if (has_idss) {
      ref <- IdSS::estim.SVAR.ICA(as.matrix(d[, c("infl", activity, "r")]),
                                  distri = distri3, p = nb_lags)
      al  <- match_columns(fit$C, ref$C.PML)$C
      cat(sprintf("  vs IdSS::estim.SVAR.ICA (no exogenous commo): max|dC| = %.4f\n",
                  max(abs(al - fit$C))))
    }
    list(p = wald$p_value, jb = jb_p)
  }

  r_gap <- run_case("y.gdp.gap", "activity = output gap")
  r_u   <- run_case("y.u.gap",   "activity = unemployment gap")

  cat("\n  Paper's reported result (§3.2, p. 655-663): the SRR schemes are\n")
  cat("  rejected at 5% with the output gap, and cannot be rejected at 10%\n")
  cat("  with the unemployment gap.\n")
  pass(all(r_gap$jb < 0.05) || all(r_u$jb < 0.05),
       "Jarque-Bera rejects normality of the VAR residuals", "")
  pass(r_gap$p < 0.05, "output-gap VAR: SRR scheme rejected at 5%",
       sprintf("p = %.4f", r_gap$p))
  pass(r_u$p > 0.10, "unemployment-gap VAR: SRR not rejected at 10%",
       sprintf("p = %.4f", r_u$p))
} else {
  cat("  [skip] IdSS unavailable (US3var data ships with the package)\n")
}

# ------------------------------------------------------------------
# D. Simulation at n = 6 with a known C0
# ------------------------------------------------------------------
cat("\n== D. Simulation, n = 6, T = 150 ==\n")

simulate_case <- function(n_gauss, n_rep = 200L, Tn = 150L, n = 6L, seed = 2026) {
  set.seed(seed)
  distri <- gmr_distri_mixtures(n)
  C0 <- cayley_C(rnorm(n * (n - 1) / 2, 0, 0.4), n)

  draw_eps <- function() {
    E <- matrix(0, Tn, n)
    for (i in seq_len(n)) {
      E[, i] <- if (i <= n - n_gauss) {
        x <- rt(Tn, df = 6) / sqrt(6 / 4)          # non-Gaussian, fat-tailed
        x + 0.6 * (x^2 - mean(x^2)) / sd(x^2)      # plus asymmetry (A.5)
      } else rnorm(Tn)
      E[, i] <- (E[, i] - mean(E[, i])) / sd(E[, i])
    }
    E
  }

  errs <- matrix(NA_real_, n_rep, 2)
  cov1 <- numeric(n_rep)
  for (b in seq_len(n_rep)) {
    Y <- draw_eps() %*% t(C0)
    Y <- Y %*% solve(t(chol(var(Y))))
    fit <- tryCatch(estim_ica_pml(Y, distri, n_starts = 6L, maxit = 800L),
                    error = function(e) NULL)
    if (is.null(fit)) next
    Cm <- match_columns(C0, fit$C)$C
    errs[b, 1] <- max(abs(Cm[, 1] - C0[, 1]))               # a non-Gaussian column
    errs[b, 2] <- max(abs(Cm[, n] - C0[, n]))               # the last column
    cv <- tryCatch(gmr_asympt_cov(fit$eps, distri, fit$C), error = function(e) NULL)
    if (!is.null(cv)) {
      se <- sqrt(pmax(diag(cv$V), 0))[1]
      cov1[b] <- as.numeric(abs(Cm[1, 1] - C0[1, 1]) <= 1.96 * se)
    }
  }
  list(err_nong = mean(errs[, 1], na.rm = TRUE),
       err_last = mean(errs[, 2], na.rm = TRUE),
       coverage = mean(cov1, na.rm = TRUE),
       n_ok = sum(!is.na(errs[, 1])))
}

s0 <- simulate_case(n_gauss = 0L)
cat(sprintf("  0 Gaussian components: mean max|dC| col1 = %.4f, col6 = %.4f,",
            s0$err_nong, s0$err_last))
cat(sprintf(" 95%% coverage of C[1,1] = %.3f  (%d reps)\n", s0$coverage, s0$n_ok))
pass(s0$err_nong < 0.25, "identification recovers C0 when no component is Gaussian",
     sprintf("mean max|dC| = %.3f", s0$err_nong))

s2 <- simulate_case(n_gauss = 2L)
cat(sprintf("  2 Gaussian components: mean max|dC| col1 = %.4f, col6 = %.4f\n",
            s2$err_nong, s2$err_last))
cat("  (col6 is inside the Gaussian block and is NOT identified; col1 is.\n")
cat("   This is the direct analogue of the (7,6) panel — see output/nongaussian/gate.md.)\n")
pass(s2$err_last > s2$err_nong,
     "with 2 Gaussian sources the Gaussian block degrades, the rest survives",
     sprintf("%.3f vs %.3f", s2$err_last, s2$err_nong))

# ------------------------------------------------------------------
# E. Guard test on the IdSS defects
# ------------------------------------------------------------------
cat("\n== E. Guard test: IdSS defects at n >= 4 ==\n")
if (has_idss) {
  still_broken <- FALSE
  for (n in 4:6) {
    a <- rnorm(n * (n - 1) / 2, 0, 0.3)
    A_id <- matrix(IdSS::make.M(n) %*% a, n, n)
    if (!isTRUE(all.equal(A_id, -t(A_id)))) still_broken <- TRUE
  }
  if (still_broken) {
    cat("  [OK] IdSS::make.M is still non-skew for n >= 4 — the in-repo Cayley\n")
    cat("       map remains necessary. No action needed.\n")
  } else {
    cat("  [!!] IdSS::make.M now returns a skew-symmetric matrix. Upstream may\n")
    cat("       have been fixed: re-check the header of nongaussian_gmr.R and\n")
    cat("       consider re-validating against estim.SVAR.ICA at n = 6.\n")
  }
} else {
  cat("  [skip] IdSS unavailable\n")
}

cat(sprintf("\n===== %s =====\n",
            if (N_FAIL == 0) "ALL CHECKS PASSED" else
              sprintf("%d CHECK(S) FAILED", N_FAIL)))
