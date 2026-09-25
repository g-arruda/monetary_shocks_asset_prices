# ===================================================================
# Identification through heteroskedasticity (Rigobon 2003): regime
# construction and the `svars` identification test.
#
# Rigobon states ONE identification condition, the rank condition,
# eq. (6) `det|Omega_2 - (w_11,2/w_11,1) Omega_1| != 0`, and says it fails
# if and only if the two covariance matrices are proportional. Its
# multivariate form is the distinctness of the eigenvalues of `Lambda` in
# `Sigma_1 = B B'`, `Sigma_2 = B Lambda B'` -- which is what `svars::id.cv()`
# estimates and tests.
#
# The estimator and the test come from `svars` and are not reimplemented
# here: `IdentifyVolatility()` is the package's C++ ML/GLS routine and
# `cv_ident_test()` its implementation of the sequential `Qr` test of
# Luetkepohl, Meitz, Netsunajev and Saikkonen (2021), which is what `id.cv()`
# reports with two regimes -- the pairwise Wald from the Fisher information
# is what it returns only for three. They are called directly rather than
# through `id.cv()` because that function cannot express a recurring
# calendar regime: see [fit_het_cv()] for the line that breaks and how it
# fails. What this file adds is the plumbing -- the regime indicator, the
# design matrix, the numerical conditioning, the guards, and the scalar
# form of eq. (6).
#
# No impulse response is built from this file: heteroskedasticity is not an
# identification scheme of the paper. The exploratory responses live in
# het_rigobon/, quarantined, and import this file read-only.
#
# Consumed by script/het_conditions.R and by het_rigobon/.
# ===================================================================


#' Build the monthly Copom / non-Copom regime table
#'
#' A month is regime `"C"` when it holds at least one Copom meeting,
#' ordinary or extraordinary, and `"NC"` otherwise. With eight meetings a
#' year roughly two thirds of the sample is `"C"`, which is the dilution the
#' monthly design suffers against the daily one.
#'
#' @param copom_csv Copom meetings file with an ISO-parsed meeting-date
#'   column `data_reuniao_parsed`.
#' @param month_range Length-2 Date vector bounding the monthly grid; any
#'   day inside the first and the last month.
#'
#' @return Tibble with `month` (first day of month) and `regime`.
build_monthly_regimes <- function(copom_csv = "data/raw/copom_historico.csv",
                                  month_range) {
  copom <- suppressWarnings(readr::read_csv(copom_csv, show_col_types = FALSE))
  meeting_months <- copom$data_reuniao_parsed |>
    as.Date() |>
    na.omit() |>
    lubridate::floor_date("month") |>
    unique()

  start <- lubridate::floor_date(as.Date(month_range[1]), "month")
  end <- lubridate::floor_date(as.Date(month_range[2]), "month")

  tibble::tibble(month = seq(start, end, by = "month")) |>
    dplyr::mutate(
      regime = dplyr::if_else(month %in% meeting_months, "C", "NC")
    )
}


#' Align monthly regime labels to the rows of the factor-VAR innovations
#'
#' The innovations drop the first `p` observations, so row `t` of `eta`
#' belongs to `dates[p + t]`.
#'
#' @param dates Date vector aligned with the panel rows.
#' @param p Factor-VAR lag order used in `estimate_dfm()`.
#' @param regimes Output of `build_monthly_regimes()`.
#'
#' @return Character vector of length `length(dates) - p`.
align_regimes_to_eta <- function(dates, p, regimes) {
  residual_months <- lubridate::floor_date(
    as.Date(dates)[(p + 1):length(dates)],
    "month"
  )
  labels <- regimes$regime[match(residual_months, regimes$month)]
  if (anyNA(labels)) {
    stop("Regime table does not cover all residual months: ",
         paste(unique(residual_months[is.na(labels)]), collapse = ", "))
  }
  labels
}


#' Wednesday-to-Thursday panel of changes, with the Copom regime
#'
#' One observation per week. The Copom announces after Wednesday's close, so
#' a Wednesday-to-Thursday window covers the announcement and regime `"C"` is
#' the week whose Wednesday is a meeting day — the design of Gonçalves,
#' Rodrigues and Genta (2025), and of Rigobon and Sack (2004) before them.
#'
#' DI changes hold the CONTRACT fixed between the two days, which is what
#' makes the difference a rate surprise rather than a maturity effect. Price
#' series are matched on the exact date and never carried forward: a week
#' without a quote on either day drops, so "no quote" never passes for "no
#' change". Units follow the published tables — 100 x log difference for the
#' exchange rate and the equity index, level difference for the CDS.
#'
#' Requires `R/instrument/di_surprise.R` to be sourced.
#'
#' @param from,to Bounds of the weekly grid.
#' @param di_vertices Named integer vector of DI maturities in business days.
#' @param prices Named list of two-column data frames (`date`, `valor`),
#'   already in the units the panel should carry.
#' @param copom_csv Copom meetings file.
#' @param di_csv Daily DI futures file read by `load_di_panel()`.
#'
#' @return Tibble with `wed_date`, `thu_date`, `regime` and one column per
#'   DI vertex and per price series.
build_weekly_changes <- function(from, to, di_vertices, prices,
                                 copom_csv = "data/raw/copom_historico.csv",
                                 di_csv = "data/raw/di.csv") {
  thursdays <- seq(
    lubridate::ceiling_date(as.Date(from), "week", week_start = 4),
    as.Date(to),
    by = "week"
  )
  copom_wednesdays <- load_copom_wednesdays(
    copom_csv,
    from = as.Date(from),
    to = as.Date(to)
  )
  weeks <- tibble::tibble(wed_date = thursdays - 1L, thu_date = thursdays) |>
    dplyr::mutate(
      regime = dplyr::if_else(wed_date %in% copom_wednesdays, "C", "NC")
    )

  # A meeting that is not a grid Wednesday would leave regime "C" unseen
  meetings_in_window <- sum(
    copom_wednesdays >= min(weeks$wed_date) &
      copom_wednesdays <= max(weeks$thu_date)
  )
  if (sum(weeks$regime == "C") != meetings_in_window) {
    stop(sprintf(
      paste0("The weekly grid loses meetings: %d Copom Wednesdays in the ",
             "window, %d labelled C"),
      meetings_in_window,
      sum(weeks$regime == "C")
    ))
  }

  di_panel <- load_di_panel(
    di_csv,
    from = as.Date(from) - 40L,
    to = as.Date(to)
  )
  di_changes <- di_vertices |>
    purrr::map(\(business_days) {
      build_thursday_surprises(
        di_panel,
        weeks$thu_date,
        target_bd = business_days,
        min_bd = 10
      )$delta_di
    }) |>
    tibble::as_tibble()

  price_changes <- prices |>
    purrr::map(\(series) {
      series$valor[match(weeks$thu_date, series$date)] -
        series$valor[match(weeks$wed_date, series$date)]
    }) |>
    tibble::as_tibble()

  dplyr::bind_cols(weeks, di_changes, price_changes)
}


#' Rigobon (2003) rank condition in scalar form
#'
#' Equation (6): scale the quiet-regime covariance by the policy variable's
#' own variance ratio, subtract, and require the result to be non-singular.
#' `det_ratio` divides by `det(Sigma_NC)`, which makes the number invariant
#' to the units of every series and to any diagonal rescaling — without it a
#' determinant measured on the monthly panel is not comparable to one
#' measured on weekly changes, and reading the two side by side would be an
#' artefact of scale. Exact proportionality sends both to zero.
#'
#' @param Sigma_C,Sigma_NC Regime covariance matrices, same dimension.
#' @param mp_index Row of the policy variable, the `w_11` of eq. (6).
#'
#' @return List with `a` (the variance ratio used to normalize), `Q`,
#'   `det_Q` and `det_ratio`.
rigobon_rank_stat <- function(Sigma_C, Sigma_NC, mp_index = 1L) {
  a <- Sigma_C[mp_index, mp_index] / Sigma_NC[mp_index, mp_index]
  Q <- Sigma_C - a * Sigma_NC
  det_Q <- det(Q)

  list(
    a = a,
    Q = Q,
    det_Q = det_Q,
    det_ratio = det_Q / det(Sigma_NC)
  )
}


#' The kurtosis correction the `Qr` test applies, and the statistic without it
#'
#' `cv_ident_test()` scales every `Qr` by `c_tau2`, which divides by the
#' average excess kurtosis of the residuals in each regime. That is the point
#' of Lütkepohl, Meitz, Netšunajev and Saikkonen (2021): without it the
#' chi-square approximation is invalid under non-normality and the test
#' over-rejects. The package computes the uncorrected statistic at
#' `R/cv_ident_test.R:90` and then discards it.
#'
#' It is reported here because on daily financial data the two differ enough
#' to change the verdict, and a reader who sees only the corrected number
#' cannot tell a system with no covariance rotation from one whose tails cost
#' the test its power. The correction is the valid statistic; the uncorrected
#' one is what a test that ignored the tails would have said.
#'
#' The kurtosis moments reproduce `cv_ident_test()` to the digit, TB
#' convention included: the package splits at `TB = n - sum(SB) + 1` and uses
#' `TB` and `n - TB` where a count would read `n_NC` and `n_C`, so the
#' regime-NC denominators are `TB - 4` and `TB`. Using the counts instead
#' moves the third digit (kappa 12.6735/2.2525 against 12.6435/2.2949 on the
#' daily 3-month cell), which is why the package's own convention is copied
#' rather than "corrected". `qr_nk / factor` then equals the corrected `Qr`
#' exactly, the identity [script/validation/validate_het_cv.R] pins.
#'
#' @param u Residual matrix, rows aligned to `sb`.
#' @param sb Numeric regime indicator, `1` on `"C"`, as [fit_het_cv()] builds
#'   it.
#' @param lambda Estimated `Lambda` diagonal, any order.
#' @param p Lag order used in the fit, as `cv_ident_test()` takes it.
#' @param pair Which adjacent pair of sorted eigenvalues to test.
#'
#' @return List with `kappa` (excess kurtosis per regime, NC first),
#'   `factor` (how much the correction shrinks the statistic), `qr_nk` and
#'   `p_nk`.
qr_without_kurtosis <- function(u, sb, lambda, p, pair = 1:2) {
  k <- ncol(u)
  n <- nrow(u)
  tb <- n - sum(sb) + 1L

  kappa <- purrr::map_dbl(1:2, \(regime) {
    X <- u[if (regime == 1L) sb == 0 else sb == 1, , drop = FALSE]
    div_w <- if (regime == 1L) tb else n - tb
    den_z <- if (regime == 1L) tb - 4 else n - tb - 4
    S <- crossprod(X) / nrow(X)
    zm <- (colSums(sweep(X, 2, colMeans(X))^4) - 6 * diag(S)^2) / den_z
    wm <- (div_w / (div_w - 1)) * (diag(S)^2 - zm / div_w)
    sum(zm / wm) / (3 * k) - 1
  })

  tau <- tb / (n - p)
  c_tau2 <- 1 / ((1 + kappa[1]) / tau + (1 + kappa[2]) / (1 - tau))
  c_tau2_nk <- 1 / (1 / tau + 1 / (1 - tau))

  lam <- sort(lambda, decreasing = TRUE)[pair]
  r <- length(pair)
  core <- -(n - p) * sum(log(lam)) + (n - p) * r * log(mean(lam))
  df <- 0.5 * (r + 2) * (r - 1)

  list(
    kappa = kappa,
    factor = c_tau2_nk / c_tau2,
    qr_nk = c_tau2_nk * core,
    p_nk = pchisq(c_tau2_nk * core, df, lower.tail = FALSE)
  )
}


#' The same impact matrix in closed form, for bootstrap loops
#'
#' With two regimes and no restrictions the ML solution of
#' `Sigma_NC = B B'`, `Sigma_C = B Lambda B'` is the simultaneous
#' diagonalizer of the pair, which the generalized eigendecomposition gives
#' in one step: `B = Sigma_NC^(1/2) V` and `Lambda` the eigenvalues of
#' `Sigma_NC^(-1/2) Sigma_C Sigma_NC^(-1/2)`, with `V` its eigenvectors.
#' [fit_het_cv()] verifies that the package's iterative estimator lands on
#' it, so inside a resampling loop — where the reduced form is held fixed and
#' only the regime covariances move, as in Rigobon's own bootstrap — this
#' returns the same answer without re-running the GLS.
#'
#' @param Sigma_C,Sigma_NC Regime covariance matrices.
#'
#' @return List with `B` (columns ordered by decreasing `Lambda`) and
#'   `Lambda`.
het_column_closed_form <- function(Sigma_C, Sigma_NC) {
  # Both roots of Sigma_NC from one spectral decomposition. Negative
  # eigenvalues (numerical noise) are clipped at zero for the root and
  # floored at 1e-12 for the inverse root, to keep both real.
  spectrum <- eigen(Sigma_NC, symmetric = TRUE)
  n_eigen <- length(spectrum$values)
  root <- spectrum$vectors %*%
    diag(sqrt(pmax(spectrum$values, 0)), nrow = n_eigen) %*%
    t(spectrum$vectors)
  inverse_root <- spectrum$vectors %*%
    diag(1 / sqrt(pmax(spectrum$values, 1e-12)), nrow = n_eigen) %*%
    t(spectrum$vectors)

  generalized <- eigen(inverse_root %*% Sigma_C %*% inverse_root,
                       symmetric = TRUE)
  list(B = root %*% generalized$vectors, Lambda = generalized$values)
}


#' Identification through changes in volatility, with the `svars` estimator
#'
#' `Sigma_1 = B B'` in the quiet regime and `Sigma_2 = B Lambda B'` in the
#' meeting regime, estimated by the package's ML/GLS routine. `Lambda` is the
#' meeting-over-quiet variance ratio of each structural shock, and the
#' monetary column is the one with the largest entry. Naming it is legitimate
#' only when that eigenvalue is separated from the rest, which is what the
#' `lambda_1 = lambda_2` row of `qr_test` decides.
#'
#' Two departures from calling `svars::id.cv()`, both forced and both
#' verified:
#'
#' 1. The estimator is called as `id.cv()` calls it internally, because the
#'    public indicator path is broken. `id.cv()` has a code path for a
#'    full-length indicator instead of a break date, which is what a
#'    recurring calendar regime needs, but `R/id.cv.R:177` selects the
#'    meeting rows with `u[SB, ]`, and reaching the path at all requires `SB`
#'    to be numeric (`:149`), so a 0/1 vector indexes by position and the
#'    meeting covariance comes back as the first row repeated. The estimate
#'    then collapses to `Lambda = I` without any warning. This function
#'    passes the 0-based regime indices `id.cv.R:277-278` builds and supplies
#'    the meeting covariance itself. Everything downstream is the package's:
#'    `IdentifyVolatility()` is its C++ ML routine and `cv_ident_test()` its
#'    implementation of the sequential `Qr` test of Lütkepohl, Meitz,
#'    Netsunajev and Saikkonen (2021).
#' 2. Columns are divided by the standard deviation of their reduced-form
#'    residual before estimation and `B` is multiplied back afterwards. With
#'    this panel's raw units the residual scales span four orders of
#'    magnitude (yields in decimals against a CDS in basis points) and the
#'    GLS iteration diverges, returning `Lambda = I`. `Lambda` is invariant
#'    to any diagonal rescaling, so the conditioning changes no reported
#'    statistic.
#'
#' Two guards, both resting on the same fact: in the unrestricted two-regime
#' case the ML solution is the simultaneous diagonalizer of the pair, so
#' `Lambda` must equal the generalized eigenvalues of `(Sigma_C, Sigma_NC)`
#' ([het_column_closed_form()]) and `B` must satisfy `B B' = Sigma_NC`,
#' `B Lambda B' = Sigma_C`. A misread regime split or a diverged GLS misses
#' both by orders of magnitude -- the collapse to `Lambda = I` that the
#' broken `id.cv()` path produces leaves `recon_dev` around 0.6.
#' `lambda_dev` is the tight one, because the eigenvalues are pinned far more
#' sharply than the matrix `B` that carries them; `recon_dev` only has to
#' catch a gross failure.
#'
#' `Lambda` comes back in the estimator's own column order; `mp_col` points
#' at its largest entry. `qr_test` labels its rows over `Lambda` SORTED
#' DESCENDING, so its `lambda_1` is `mp_col` whatever position that occupies.
#'
#' @param y Matrix of observations, one column per variable.
#' @param p Lag order. `1` on already-whitened innovations, where the lag has
#'   to be inert — pass `inert_lag = TRUE` to make that a guard. The test
#'   rebuilds residuals through `YLagCr` and cannot take `p = 0`.
#' @param type Deterministic term, as in `vars::VAR()`.
#' @param regime_labels Character vector (`"C"`/`"NC"`) for the `T - p`
#'   residual periods, in the order the residuals come out, as
#'   [align_regimes_to_eta()] or a weekly grid's `regime` column builds it.
#' @param n_min Floor on the size of each regime.
#' @param crit,max_iter GLS convergence criterion and iteration cap, the
#'   defaults of `svars::id.cv()`.
#' @param recon_tol Relative tolerance of the `B` reconstruction guard.
#' @param inert_lag When `TRUE`, also require the GLS residuals to reproduce
#'   the input series column by column, which is what makes the lag a
#'   formality rather than a filter. `resid_fidelity` is reported either
#'   way, so the reader sees how close it is rather than only that it passed.
#' @param fidelity_min Floor for that correlation.
#' @param lambda_tol Relative tolerance of the eigenvalue guard.
#'
#' @return List with `B`, `B_SE` (original units), `Lambda`, `Lambda_SE`,
#'   `mp_col`, `qr_test`, `Sigma_C`, `Sigma_NC`, `u` (GLS residuals, original
#'   units), `A_hat` and its lag block `AL` (standardized units, for
#'   propagation), `scale`, `n_C`, `n_NC`, the kurtosis diagnostics of
#'   [qr_without_kurtosis()], `recon_dev`, `lambda_dev`, `resid_fidelity` and
#'   `iteration`.
fit_het_cv <- function(y, p, type, regime_labels, n_min = 30L,
                       crit = 0.001, max_iter = 50L, recon_tol = 1e-3,
                       inert_lag = FALSE, fidelity_min = 0.98,
                       lambda_tol = 1e-4) {
  y <- as.matrix(y)
  k <- ncol(y)
  if (p < 1L) {
    stop("cv_ident_test() rebuilds residuals through YLagCr and needs p >= 1")
  }
  # A label vector of the wrong length would be recycled over the residuals
  if (nrow(y) - p != length(regime_labels)) {
    stop(sprintf(
      paste0("Regime labels and residuals misaligned: %d rows minus %d lags ",
             "is %d, labels are %d"),
      nrow(y), p, nrow(y) - p, length(regime_labels)
    ))
  }

  # Numeric, not logical: both which(SB == 0) and cv_ident_test()'s
  # x$SB == 1 expect it
  sb <- as.numeric(regime_labels == "C")
  if (sum(sb) < n_min || sum(sb == 0) < n_min) {
    stop(sprintf("Regime below the %d-observation floor: %d C / %d NC",
                 n_min, sum(sb), sum(sb == 0)))
  }

  residual_sd <- apply(resid(vars::VAR(y, p = p, type = type)), 2, sd)
  y_standardized <- sweep(y, 2, residual_sd, "/")

  u <- resid(vars::VAR(y_standardized, p = p, type = type))
  Tob <- nrow(u)
  TB <- Tob - sum(sb) + 1L

  # The design matrix id.cv() builds: deterministics first, then the lags.
  yl <- t(embed(y_standardized, p + 1L)[, -seq_len(k), drop = FALSE])
  Zt <- rbind(
    if (type %in% c("const", "both")) rep(1, Tob),
    if (type %in% c("trend", "both")) seq(p + 1L, nrow(y_standardized)),
    yl
  )
  yt <- t(y_standardized)[, -seq_len(p), drop = FALSE]

  est <- svars:::IdentifyVolatility(
    crit = crit,
    u = u,
    TB = TB,
    Regime1 = which(sb == 0) - 1L,
    Regime2 = which(sb == 1) - 1L,
    p = p,
    k = k,
    RestrictionMatrix = matrix(NA_real_, k, k),
    type = type,
    restrictions = 0L,
    Tob = Tob,
    SigmaHat1 = crossprod(u[sb == 0, , drop = FALSE]) / (TB - 1L),
    SigmaHat2 = crossprod(u[sb == 1, , drop = FALSE]) / (Tob - TB + 1L),
    Zt = Zt,
    y = yt,
    maxIter = max_iter
  )

  qr_test <- svars:::cv_ident_test(list(
    y = y_standardized, p = p, type = type, Lambda = est$Lambda,
    SB = sb, n = Tob, K = k, A_hat = est$A_hat
  ))

  u_gls <- t(yt) - t(est$A_hat %*% Zt)
  Sigma_NC <- crossprod(u_gls[sb == 0, , drop = FALSE]) / sum(sb == 0)
  Sigma_C <- crossprod(u_gls[sb == 1, , drop = FALSE]) / sum(sb == 1)

  lambda <- diag(est$Lambda)
  recon_dev <- max(
    abs(tcrossprod(est$B) - Sigma_NC),
    abs(est$B %*% diag(lambda, nrow = k) %*% t(est$B) - Sigma_C)
  ) / max(abs(Sigma_NC))
  if (!is.finite(recon_dev) || recon_dev > recon_tol) {
    stop(sprintf(
      paste0("B and Lambda do not reproduce the regime covariances ",
             "(relative deviation %.3g): the GLS did not converge or the ",
             "regime split was misread"),
      recon_dev
    ))
  }

  generalized_eigenvalues <- het_column_closed_form(Sigma_C, Sigma_NC)$Lambda
  lambda_dev <- max(
    abs(sort(lambda, decreasing = TRUE) - generalized_eigenvalues) /
      abs(generalized_eigenvalues)
  )
  if (!is.finite(lambda_dev) || lambda_dev > lambda_tol) {
    stop(sprintf(
      paste0("Lambda is not the generalized eigenvalue spectrum of ",
             "(Sigma_C, Sigma_NC) (relative deviation %.3g): the estimate ",
             "did not converge"),
      lambda_dev
    ))
  }

  # On already-whitened innovations the lag exists only because the test
  # rebuilds residuals through YLagCr and cannot take p = 0. It has to be a
  # formality: what the estimator sees must still be the input series.
  n_det <- sum(type %in% c("const", "both"), type %in% c("trend", "both"))
  input <- y_standardized[(p + 1L):nrow(y_standardized), , drop = FALSE]
  resid_fidelity <- min(diag(cor(u_gls, input)))
  if (inert_lag && resid_fidelity < fidelity_min) {
    stop(sprintf(
      paste0("The lag was supposed to be a formality on whitened ",
             "innovations, but the GLS residuals depart from the input: ",
             "lowest column correlation %.4f"),
      resid_fidelity
    ))
  }

  kurtosis <- qr_without_kurtosis(u_gls, sb, lambda, p)
  unscale <- diag(residual_sd, nrow = k)

  list(
    B = unscale %*% est$B,
    B_SE = unscale %*% est$B_SE,
    Lambda = lambda,
    Lambda_SE = diag(est$Lambda_SE),
    mp_col = which.max(lambda),
    qr_test = qr_test,
    Sigma_C = unscale %*% Sigma_C %*% unscale,
    Sigma_NC = unscale %*% Sigma_NC %*% unscale,
    u = sweep(u_gls, 2, residual_sd, "*"),
    n_C = sum(sb),
    n_NC = sum(sb == 0),
    A_hat = est$A_hat,
    AL = est$A_hat[, -seq_len(n_det), drop = FALSE],
    scale = residual_sd,
    kappa = kurtosis$kappa,
    qr_12_nk = kurtosis$qr_nk,
    qr_12_nk_p = kurtosis$p_nk,
    kurt_factor = kurtosis$factor,
    recon_dev = recon_dev,
    lambda_dev = lambda_dev,
    resid_fidelity = resid_fidelity,
    iteration = est$iteration
  )
}
