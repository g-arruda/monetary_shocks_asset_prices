# ============================================================
# Simulation harness for the het-primary identification module
# (R/identification/het_primary.R). Validates, on DGPs with a
# KNOWN impact matrix B:
#   T1  identity-weight MD == extract_shock_rigobon_sack (1e-10)
#   T2  recovery of the policy column with interleaved monthly-style
#       regimes (|cos| > 0.99 median across replications)
#   T3  population closed form: theta ratios == dSigma[1,j]/dSigma[1,1]
#       (Rigobon-Sack 2004 eq. 9-11 / SW 2016 eq. 45), N = 2
#   T4  GMM J: size under the rank-1 null, power under A2 violation
#   T5  Fieller interval: bounded and covering under strong den,
#       unbounded flag under weak den
#   T6  optional cross-check against svars::id.cv on a contiguous
#       break DGP (skipped if svars unavailable)
# Run: Rscript script/validate_het_primary_sim.R
# ============================================================

rm(list = ls())

library(dplyr)

source("R/identification/het_shock_extraction.R")
source("R/identification/het_primary.R")
source("R/modeling/impulse_responde.R")

set.seed(20260716)

failures <- character(0)
check <- function(name, ok, detail = "") {
  status <- if (ok) "PASS" else "FAIL"
  cat(sprintf("[%s] %s %s\n", status, name,
              if (nzchar(detail)) paste0("(", detail, ")") else ""))
  if (!ok) failures <<- c(failures, name)
}

cosine <- function(a, b) abs(sum(a * b)) / sqrt(sum(a^2) * sum(b^2))

#' Simulate eta = B eps with a two-regime variance shift on shock 1
#'
#' @param B Impact matrix (q x q).
#' @param labels Character vector ("C"/"NC"), one per observation.
#' @param var_C Policy-shock variance in regime C (1 in NC).
#' @param var_shift_2 Optional variance shift of shock 2 in C (A2 violation).
#'
#' @return Matrix length(labels) x q.
simulate_eta <- function(B, labels, var_C = 3, var_shift_2 = 1) {
  q   <- ncol(B)
  n   <- length(labels)
  sds <- matrix(1, n, q)
  sds[labels == "C", 1] <- sqrt(var_C)
  sds[labels == "C", 2] <- sqrt(var_shift_2)
  eps <- matrix(rnorm(n * q), n, q) * sds
  eps %*% t(B)
}

# Interleaved labels mimicking the Copom calendar: within each block of
# 3 "months", 2 are C and 1 is NC (104 C / 52 NC over T = 156).
make_labels <- function(T_len = 156) {
  rep(c("C", "C", "NC"), length.out = T_len)
}

q_dim  <- 4
B_true <- {
  set.seed(42)
  Q <- qr.Q(qr(matrix(rnorm(q_dim^2), q_dim)))
  Q %*% diag(c(1.5, 1.2, 1.0, 0.8))
}
labels <- make_labels()

# ---- T1: identity MD equals the daily-module eigen extraction ------
eta_1  <- simulate_eta(B_true, labels)
parts  <- split_by_regime(eta_1, labels)
md_id  <- fit_rank1_md(parts$Sigma_C, parts$Sigma_NC, weight = "identity")

regime_tbl <- tibble::tibble(regime = labels)
ext <- extract_shock_rigobon_sack(eta_1, regime_tbl, mp_var_idx = 1)

# extract_shock_rigobon_sack signs b_1 by its first entry; align signs
# before comparing magnitudes.
b_md  <- md_id$theta * sign(sum(md_id$theta * ext$b_1))
check("T1 identity-MD == extract_shock_rigobon_sack",
      max(abs(b_md - ext$b_1)) < 1e-10,
      sprintf("max abs diff = %.2e", max(abs(b_md - ext$b_1))))

# ---- T2: recovery across replications ------------------------------
n_rep <- 500
cos_rep   <- numeric(n_rep)
scale_rep <- numeric(n_rep)
for (r in seq_len(n_rep)) {
  eta_r   <- simulate_eta(B_true, labels)
  parts_r <- split_by_regime(eta_r, labels)
  th      <- fit_rank1_md(parts_r$Sigma_C, parts_r$Sigma_NC)$theta
  cos_rep[r]   <- cosine(th, B_true[, 1])
  # theta estimates sqrt(var_C - var_NC) * B[,1] = sqrt(2) * B[,1]
  scale_rep[r] <- sqrt(sum(th^2)) / (sqrt(2) * sqrt(sum(B_true[, 1]^2)))
}
check("T2 recovery: median |cos(theta, B[,1])| > 0.99",
      median(cos_rep) > 0.99, sprintf("median cos = %.4f", median(cos_rep)))
check("T2 recovery: median scale ratio in [0.9, 1.1]",
      abs(median(scale_rep) - 1) < 0.1,
      sprintf("median scale = %.4f", median(scale_rep)))

# ---- T3: population closed form (N = 2, SW eq. 45) ------------------
B2 <- matrix(c(1.0, 0.7, 0.3, 1.0), 2, 2)
D_C  <- diag(c(3, 1))
D_NC <- diag(c(1, 1))
Sig_C_pop  <- B2 %*% D_C  %*% t(B2)
Sig_NC_pop <- B2 %*% D_NC %*% t(B2)
th_pop <- fit_rank1_md(Sig_C_pop, Sig_NC_pop)$theta
dS_pop <- Sig_C_pop - Sig_NC_pop
check("T3 population: cos(theta, B[,1]) == 1",
      cosine(th_pop, B2[, 1]) > 1 - 1e-12,
      sprintf("1 - cos = %.2e", 1 - cosine(th_pop, B2[, 1])))
check("T3 population: theta_2/theta_1 == dSigma[1,2]/dSigma[1,1]",
      abs(th_pop[2] / th_pop[1] - dS_pop[1, 2] / dS_pop[1, 1]) < 1e-12,
      sprintf("diff = %.2e", abs(th_pop[2] / th_pop[1] - dS_pop[1, 2] / dS_pop[1, 1])))

# ---- T4: GMM J size and power ---------------------------------------
n_rep_j <- 200
p_null  <- numeric(n_rep_j)
p_alt   <- numeric(n_rep_j)
for (r in seq_len(n_rep_j)) {
  eta_n   <- simulate_eta(B_true, labels)
  parts_n <- split_by_regime(eta_n, labels)
  p_null[r] <- fit_rank1_md(parts_n$Sigma_C, parts_n$Sigma_NC,
                            weight = "optimal",
                            X_C = parts_n$X_C, X_NC = parts_n$X_NC,
                            n_boot_w = 200L)$p_chi2

  eta_a   <- simulate_eta(B_true, labels, var_shift_2 = 3)
  parts_a <- split_by_regime(eta_a, labels)
  p_alt[r] <- fit_rank1_md(parts_a$Sigma_C, parts_a$Sigma_NC,
                           weight = "optimal",
                           X_C = parts_a$X_C, X_NC = parts_a$X_NC,
                           n_boot_w = 200L)$p_chi2
}
size_5  <- mean(p_null < 0.05)
power_5 <- mean(p_alt < 0.05)
check("T4 J size at 5% within [0.01, 0.15]",
      size_5 >= 0.01 && size_5 <= 0.15, sprintf("size = %.3f", size_5))
check("T4 J power > size under A2 violation",
      power_5 > size_5 + 0.10,
      sprintf("power = %.3f vs size = %.3f", power_5, size_5))

# ---- T5: Fieller interval behavior ----------------------------------
den_strong <- rnorm(2000, mean = 5, sd = 0.5)
num_strong <- 2 * den_strong + rnorm(2000, sd = 0.5)
fi_strong  <- fieller_ratio_ci(num_strong, den_strong, level = 0.90)
check("T5 Fieller bounded and covers true ratio (strong den)",
      fi_strong$bounded && fi_strong$lower < 2 && fi_strong$upper > 2,
      sprintf("[%.3f, %.3f]", fi_strong$lower, fi_strong$upper))

den_weak <- rnorm(2000, mean = 0.05, sd = 1)
num_weak <- rnorm(2000, mean = 1, sd = 1)
fi_weak  <- fieller_ratio_ci(num_weak, den_weak, level = 0.90)
check("T5 Fieller unbounded under weak den", !fi_weak$bounded, "")

# ---- T6: optional svars::id.cv cross-check (contiguous break) --------
if (requireNamespace("svars", quietly = TRUE) &&
    requireNamespace("vars", quietly = TRUE)) {
  set.seed(7)
  T_half <- 250
  labels_cont <- rep(c("NC", "C"), each = T_half)
  eta_cont <- simulate_eta(B_true, labels_cont, var_C = 4)
  # id.cv works on a fitted VAR; wrap eta in a VAR(1) with ~zero dynamics.
  y <- as.data.frame(eta_cont)
  var_fit <- vars::VAR(y, p = 1, type = "const")
  cv_fit  <- svars::id.cv(var_fit, SB = T_half + 1)
  # id.cv's B columns are unordered/unsigned; find the best match to theta.
  parts_c <- split_by_regime(eta_cont[-1, ], labels_cont[-1])
  th_c    <- fit_rank1_md(parts_c$Sigma_C, parts_c$Sigma_NC)$theta
  cos_best <- max(apply(cv_fit$B, 2, cosine, b = th_c))
  check("T6 svars::id.cv best-column cosine > 0.95 vs theta",
        cos_best > 0.95, sprintf("best cos = %.4f", cos_best))
} else {
  cat("[SKIP] T6 svars/vars not installed — contiguous-break cross-check skipped.\n")
}

# ---- Summary ---------------------------------------------------------
cat("\n============================================\n")
if (length(failures) == 0) {
  cat("HARNESS: all checks passed.\n")
} else {
  cat("HARNESS: FAILURES —", paste(failures, collapse = "; "), "\n")
}
cat("============================================\n")
if (length(failures) > 0) quit(status = 1)
