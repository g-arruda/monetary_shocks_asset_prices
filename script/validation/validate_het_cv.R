# ============================================================
# Validation of fit_het_cv() against svars::id.cv() itself.
#
# The Copom regime repeats every month, so the estimator has to take a
# full-length 0/1 indicator. The public path of svars::id.cv() for that
# shape is broken -- R/id.cv.R splits with `u[SB, ]`, which indexes by
# position when SB is numeric -- and fit_het_cv() therefore calls
# IdentifyVolatility() the way id.cv() calls it internally, with the
# 0-based row indices id.cv() builds and the regime covariances
# supplied. This script is the measurement that the workaround is
# faithful: on a contiguous break, where the public path DOES work, the
# two agree to the digit.
#
#   H1  Lambda, the Qr table, and B B' (sign/permutation invariant) of
#       id.cv() on standardized data with a contiguous break are
#       reproduced by fit_het_cv() exactly.
#   H2  the same fit on raw units collapses id.cv() to Lambda = I, the
#       conditioning failure that forces the standardization inside
#       fit_het_cv(). svars 1.3.12 behavior, pinned.
#   H3  qr_nk / kurt_factor reconstructs the corrected Qr to floating
#       point, i.e. qr_without_kurtosis() carries the package's own
#       kappa formula and TB convention (not the counts).
# Silent on success; stops at the first failed check.
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(vars)
  library(svars)
})

source("R/identification/het_tests.R")

PANEL_PATH <- "data/processed/data_log_deseasonalized.csv"
P_LAGS     <- 4L
N_NC       <- 93L        # residual months before 2020-03, out of 162
TOL        <- 1e-10

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |> tidyr::drop_na()
y  <- as.matrix(panel[, c("yield_3m", "cds_5y", "cambio_usd")])
sb <- c(rep(0L, N_NC), rep(1L, nrow(y) - P_LAGS - N_NC))

# ---- H1 and H3: standardized units, where id.cv() works -----

sc <- apply(resid(vars::VAR(y, p = P_LAGS, type = "both")), 2, sd)
yz <- sweep(y, 2, sc, "/")

ref <- svars::id.cv(vars::VAR(yz, p = P_LAGS, type = "both"),
                    SB = P_LAGS + N_NC + 1L)
h <- fit_het_cv(y, p = P_LAGS, type = "both",
                regime_labels = ifelse(sb == 1L, "C", "NC"))

qr_ref <- as.matrix(ref$wald_statistic)
qr_h   <- as.matrix(h$qr_test)

dev_lambda <- max(abs(sort(diag(ref$Lambda), decreasing = TRUE) -
                      sort(h$Lambda, decreasing = TRUE)))
dev_qr     <- if (identical(dimnames(qr_ref), dimnames(qr_h))) {
  max(abs(qr_ref - qr_h))
} else {
  Inf
}
B_ref <- diag(sc, nrow = ncol(y)) %*% ref$B
dev_B <- max(abs(h$B %*% t(h$B) - B_ref %*% t(B_ref))) /
  max(abs(B_ref %*% t(B_ref)))
qr_12  <- h$qr_test["lambda_ 1 =lambda_2", "Test statistic"]
dev_nk <- abs(h$qr_12_nk / h$kurt_factor - qr_12)

if (dev_lambda > TOL || dev_qr > TOL || dev_B > 1e-8 || dev_nk > TOL) {
  stop("H1/H3 FAILED: fit_het_cv does not reproduce id.cv() on the ",
       "contiguous break (standardized units)")
}

# ---- H2: raw units, the collapse the scaling avoids --------

raw <- svars::id.cv(vars::VAR(y, p = P_LAGS, type = "both"),
                    SB = P_LAGS + N_NC + 1L)
dev_raw <- max(abs(sort(diag(raw$Lambda), decreasing = TRUE) - 1))

if (dev_raw > 1e-6) {
  stop("H2 FAILED: id.cv() no longer collapses on raw units -- revisit the ",
       "standardization rationale inside fit_het_cv()")
}
