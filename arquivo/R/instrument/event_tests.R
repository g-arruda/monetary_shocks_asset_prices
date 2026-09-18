# ===================================================================
# Inference for daily event-window regressions on the Copom surprise.
#
# Extracted on 2026-08-10 from jk_sovereign_confound.R (in arquivo/script/
# since 2026-09-17), when script/fomc_coincidence.R needed the same tests:
# the surprise is zero-censored by the JK mask and the daily
# heteroskedasticity is severe, so asymptotic p-values over-reject and
# every published p-value in this project's daily tests is a
# wild-bootstrap one.
#
# `wild_coef_test` is the single-coefficient test and is moved here
# VERBATIM — the p_boot values in output/instrument/
# jk_sovereign_confound.csv have to keep reproducing.
# `wild_wald_test` is its joint analogue, needed when the question is
# about a BLOCK of regressors (the contemporaneous US block) rather
# than one of them.
# ===================================================================


#' HC1 t-test on one coefficient, with a wild-bootstrap p-value under the
#' restricted null that the coefficient is zero.
#'
#' Generalizes `robust_joint_test()` (diagnostics/01_exogeneidade.R) from
#' "all slopes zero" to a single coefficient: the bootstrap DGP is the
#' RESTRICTED fit (target dropped) plus Rademacher-multiplied residuals,
#' which is the design that imposes H0 here.
#'
#' `key` seeds each cell from its own identity instead of letting every
#' test draw from one shared stream. Without it, inserting a proxy shifts
#' the RNG state of every test that runs after it, so previously
#' published p_boot values stop reproducing for a reason that has nothing
#' to do with the data. The deterministic statistics (coef, HC1 se, t, R2)
#' never depended on this.
#'
#' @param fml Model formula.
#' @param data Data frame.
#' @param target Name of the coefficient tested.
#' @param key String identifying the cell; seeds its own RNG stream.
#' @param nboot Wild-bootstrap draws.
#'
#' @return One-row tibble: `n`, `coef`, `se_hc1`, `t`, `p_asym`, `p_boot`, `r2`.
wild_coef_test <- function(fml, data, target, key, nboot = 2000L) {
  kv <- utf8ToInt(key)
  set.seed(as.integer(20260731 + sum(kv * seq_along(kv)) %% 100000L))
  mf <- model.frame(fml, data = data, na.action = na.omit)
  n  <- nrow(mf)
  fit <- lm(fml, data = mf)
  if (!(target %in% names(coef(fit))) || is.na(coef(fit)[target]) || n < 12) {
    return(tibble::tibble(n = n, coef = NA_real_, se_hc1 = NA_real_, t = NA_real_,
                          p_asym = NA_real_, p_boot = NA_real_, r2 = NA_real_))
  }
  b   <- unname(coef(fit)[target])
  V   <- sandwich::vcovHC(fit, type = "HC1")
  se  <- sqrt(V[target, target])
  tst <- b / se

  fml_r <- update(fml, paste(". ~ . -", target))
  fit_r <- lm(fml_r, data = mf)
  fitted_r <- fitted(fit_r); resid_r <- residuals(fit_r)

  tb <- replicate(nboot, {
    mf$.ystar <- fitted_r + resid_r * (1 - 2 * (runif(n) > 0.5))
    fb <- lm(update(fml, .ystar ~ .), data = mf)
    bb <- coef(fb)[target]
    if (is.na(bb)) return(NA_real_)
    Vb <- tryCatch(sandwich::vcovHC(fb, type = "HC1"), error = function(e) NULL)
    if (is.null(Vb)) return(NA_real_)
    bb / sqrt(Vb[target, target])
  })
  mf$.ystar <- NULL

  tibble::tibble(n = n, coef = b, se_hc1 = se, t = tst,
                 p_asym = 2 * pt(abs(tst), df = n - length(coef(fit)), lower.tail = FALSE),
                 p_boot = mean(abs(tb) >= abs(tst), na.rm = TRUE),
                 r2 = summary(fit)$r.squared)
}


#' Joint HC1 Wald test on a block of coefficients, with a wild-bootstrap
#' p-value under the restricted null that the whole block is zero.
#'
#' Same DGP and same per-cell seeding as `wild_coef_test`, which is the
#' `length(targets) == 1` case up to the squaring of the statistic. The
#' statistic is reported as an F (Wald / #restrictions) so it is readable
#' next to the first-stage F rulers used elsewhere in the project.
#'
#' @param fml Model formula.
#' @param data Data frame.
#' @param targets Character vector of coefficient names tested jointly.
#' @param key String identifying the cell; seeds its own RNG stream.
#' @param nboot Wild-bootstrap draws.
#'
#' @return One-row tibble: `n`, `k`, `f_rob`, `p_asym`, `p_boot`, `r2`.
wild_wald_test <- function(fml, data, targets, key, nboot = 2000L) {
  kv <- utf8ToInt(key)
  set.seed(as.integer(20260731 + sum(kv * seq_along(kv)) %% 100000L))
  mf <- model.frame(fml, data = data, na.action = na.omit)
  n  <- nrow(mf)
  fit <- lm(fml, data = mf)
  have <- targets[targets %in% names(coef(fit))]
  have <- have[is.finite(coef(fit)[have])]
  if (length(have) == 0L || n < 12) {
    return(tibble::tibble(n = n, k = length(have), f_rob = NA_real_,
                          p_asym = NA_real_, p_boot = NA_real_, r2 = NA_real_))
  }

  wald <- function(m) {
    bb <- coef(m)[have]
    if (any(!is.finite(bb))) return(NA_real_)
    Vb <- tryCatch(sandwich::vcovHC(m, type = "HC1"), error = function(e) NULL)
    if (is.null(Vb)) return(NA_real_)
    tryCatch(drop(t(bb) %*% solve(Vb[have, have, drop = FALSE], bb)) / length(have),
             error = function(e) NA_real_)
  }

  fst <- wald(fit)
  fml_r <- update(fml, paste(". ~ . -", paste(have, collapse = " - ")))
  fit_r <- lm(fml_r, data = mf)
  fitted_r <- fitted(fit_r); resid_r <- residuals(fit_r)

  fb <- replicate(nboot, {
    mf$.ystar <- fitted_r + resid_r * (1 - 2 * (runif(n) > 0.5))
    wald(lm(update(fml, .ystar ~ .), data = mf))
  })
  mf$.ystar <- NULL

  tibble::tibble(n = n, k = length(have), f_rob = fst,
                 p_asym = pf(fst, length(have), n - length(coef(fit)), lower.tail = FALSE),
                 p_boot = mean(fb >= fst, na.rm = TRUE),
                 r2 = summary(fit)$r.squared)
}
