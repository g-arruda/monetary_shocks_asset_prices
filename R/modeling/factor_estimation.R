#' Standardize a level panel as Barigozzi, Lippi & Luciani (2016)
#'
#' Takes first differences, centers them and divides each series by the
#' standard deviation of its differences. The static-factor PCA and the BLL
#' variants of the Bai-Ng and Amengual-Watson criteria all read this object,
#' never the levels, which are non-stationary by design.
#'
#' @param data Numeric matrix of the level panel (T x N).
#'
#' @return List with `yy`, the standardized first differences (T - 1 x N), and
#'   `sy`, the standard deviation of each series' first differences.
#'
#' @examples
#' yy <- standardize_bll(panel)$yy
standardize_bll <- function(data) {
  y <- diff(data)
  sy <- apply(y, 2, sd)

  list(yy = sweep(sweep(y, 2, colMeans(y), "-"), 2, sy, "/"), sy = sy)
}


#' Extract static factors under BLL standardization
#'
#' Removes a linear trend series by series, scales the detrended levels by the
#' `sy` of `standardize_bll()`, and projects them on the leading `r`
#' eigenvectors of the covariance of the standardized differences. SVD rather
#' than `eigen()`, and each eigenvector signed so that its largest entry is
#' positive, make the decomposition bit-reproducible.
#'
#' @param data Numeric matrix of the level panel (T x N).
#' @param r Number of static factors.
#'
#' @return List with `factors` (T x r), `loadings` (N x r), `sy` (standard
#'   deviations of the first differences) and `yy` (the standardized first
#'   differences whose covariance the loadings decompose).
#'
#' @examples
#' static <- estimate_static_factors(panel, r = 5L)
estimate_static_factors <- function(data, r) {
  standardized <- standardize_bll(data)

  trend <- cbind(1, seq_len(nrow(data)))
  beta <- solve(crossprod(trend)) %*% crossprod(trend, data)
  Z <- sweep(data - trend %*% beta, 2, standardized$sy, "/")

  lambda <- svd(cov(standardized$yy))$u[, 1:r, drop = FALSE]
  flip <- lambda[cbind(apply(abs(lambda), 2, which.max), seq_len(r))] < 0
  lambda <- sweep(lambda, 2, dplyr::if_else(flip, -1, 1), "*")

  list(
    factors = Z %*% lambda,
    loadings = lambda,
    sy = standardized$sy,
    yy = standardized$yy
  )
}


#' Common volatility scale of the Lenza-Primiceri (2022) COVID treatment
#'
#' Builds `s_t` of equation (1) in Lenza & Primiceri (2022, JAE): one before
#' `covid_start`, `s0`, `s1` and `s2` in its first three months, and
#' `1 + (s2 - 1) * rho^(j - 2)` from then on, `j` being calendar months since
#' `covid_start`. It is the rule of `invweights` in the authors'
#' `logMLVAR_formin_covid.m:35-40`. `theta` carries no bounds: the ones in
#' `setpriors_covid.m` belong to the authors' Bayesian optimizer, and choosing
#' `theta` is the author's decision.
#'
#' @param dates Date vector, one per residual row of the factor VAR.
#' @param covid_start First month of abnormal volatility (Date).
#' @param theta Named numeric vector with `s0`, `s1`, `s2` and `rho`.
#'
#' @return Numeric vector `s_t` aligned with `dates`.
#'
#' @examples
#' # Neutral theta: s_t = 1 at every date, whatever covid_start and rho.
#' s <- covid_volatility_path(dates, covid_start,
#'                            c(s0 = 1, s1 = 1, s2 = 1, rho = 0))
covid_volatility_path <- function(dates, covid_start, theta) {
  j <- 12L * (lubridate::year(dates) - lubridate::year(covid_start)) +
    lubridate::month(dates) - lubridate::month(covid_start)

  s <- rep(1, length(dates))
  s[j == 0] <- theta[["s0"]]
  s[j == 1] <- theta[["s1"]]
  s[j >= 2] <- 1 + (theta[["s2"]] - 1) * theta[["rho"]]^(j[j >= 2] - 2)
  s
}


#' VAR by weighted least squares
#'
#' `F_t = c + A(L) F_{t-1} + s_t eps_t`, `eps_t ~ N(0, Sigma)`: every row,
#' deterministic terms included, is divided by `s_t`, which is (B2) of Lenza &
#' Primiceri (2022, JAE, Appendix B). With `s = 1` this is OLS, the direct
#' equivalent of `DFMest_BLL.m` lines 29-50 for the factor VAR and of
#' `vars::VAR()` for any other. Nothing here chooses `s`.
#'
#' @param data Numeric matrix of the variables (T x K).
#' @param p Lag order.
#' @param type Deterministic terms, as in `vars::VAR()`: `"const"` (the factor
#'   VAR) or `"both"`, a constant and the trend `p + 1, ..., T`. No default:
#'   the deterministic terms are a modelling choice of each caller.
#' @param s Volatility scale: one positive value per residual row (length
#'   T - p) from `covid_volatility_path()`, or 1 for OLS.
#'
#' @return List with `coefficients` (lags first, then the constant and, with
#'   `"both"`, the trend), `residuals` `u_t = y_t - B'x_t`,
#'   `residuals_standardized` (`u_t / s_t`), `companion`, `covariance_matrix`
#'   (of `u_t / s_t`, degrees-of-freedom divisor), `sigma_mle` (B4, divisor
#'   T - p) and `loglik` (B5, constants included).
#'
#' @examples
#' ols <- estimate_var_wls(factors, p = 4L, type = "const")
#' wls <- estimate_var_wls(factors, p = 4L, type = "const",
#'                         s = covid_volatility_path(...))
estimate_var_wls <- function(data, p, type, s = 1) {
  K <- ncol(data)
  n_eff <- nrow(data) - p

  deterministic <- switch(
    match.arg(type, c("const", "both")),
    const = 1,
    both = cbind(1, seq(p + 1, nrow(data)))
  )
  RHS <- cbind(stats::embed(data, p + 1)[, -(1:K), drop = FALSE], deterministic)
  LHS <- data[(p + 1):nrow(data), , drop = FALSE]

  B <- solve(crossprod(RHS / s)) %*% crossprod(RHS / s, LHS / s)
  u <- LHS - RHS %*% B
  u_standardized <- u / s
  sigma_mle <- crossprod(u_standardized) / n_eff
  log_det_sigma <- as.numeric(
    determinant(sigma_mle, logarithm = TRUE)$modulus
  )

  list(
    coefficients = B,
    residuals = u,
    residuals_standardized = u_standardized,
    companion = rbind(
      t(B[1:(p * K), ]),
      cbind(diag((p - 1) * K), matrix(0, (p - 1) * K, K))
    ),
    covariance_matrix = crossprod(u_standardized) / (n_eff - ncol(RHS)),
    sigma_mle = sigma_mle,
    loglik = -n_eff * K / 2 * (1 + log(2 * pi)) - K * sum(log(s)) -
      n_eff / 2 * log_det_sigma
  )
}


#' Maximum-likelihood estimate of the Lenza-Primiceri COVID volatility scale
#'
#' Maximizes the concentrated log-likelihood (B5) of Lenza & Primiceri (2022,
#' JAE, Appendix B) over `theta = (s0, s1, s2, rho)` by L-BFGS-B inside the box
#' `[lower, upper]`. The floor is not cosmetic: with any scale free to approach
#' zero, the WLS fits that month exactly and (B5) grows as `-n log s`, so the
#' unrestricted maximum does not exist. The starting values are the authors'
#' rule (`bvarGLP_covid.m:60-68`) on the data: the cross-series mean absolute
#' change into `covid_start` and the two months after it, over the same mean
#' before `covid_start`, and `rho = 0.8`, projected on the box. The rule reads
#' the series in their own units; theta-hat does not, being invariant to any
#' rescaling of the columns.
#'
#' One start does not settle the maximum: (B5) has three local maxima on the
#' production factors (notas/2026-09-24_otimo_global_theta.md), so every
#' estimate goes through [verify_covid_theta()].
#'
#' @param data Numeric matrix of the VAR's variables (T x K).
#' @param p Lag order of the VAR.
#' @param type Deterministic terms of the VAR, as in [estimate_var_wls()].
#' @param residual_dates Date vector of the T - p residual months.
#' @param covid_start First month of abnormal volatility (Date), one of
#'   `residual_dates`.
#' @param lower,upper Named vectors (`s0`, `s1`, `s2`, `rho`) bounding theta.
#'
#' @return List with `theta`, the maximized `loglik`, the `start` vector,
#'   `optim`'s `convergence` code and `message`, and the path `s_t` at `theta`.
#'
#' @examples
#' fit <- estimate_covid_theta(factors, 4L, "const", residual_dates,
#'                             as.Date("2020-03-01"), lower, upper)
estimate_covid_theta <- function(data, p, type, residual_dates, covid_start,
                                 lower, upper) {
  loglik_at <- function(theta) {
    s <- covid_volatility_path(residual_dates, covid_start, theta)
    estimate_var_wls(data, p, type = type, s = s)$loglik
  }

  # Row i of abs_change is the change into residual month i + 1, on the VAR's
  # left-hand side as in bvarGLP_covid.m
  abs_change <- data[(p + 1):nrow(data), , drop = FALSE] |>
    diff() |>
    abs() |>
    rowMeans()
  t_star <- match(covid_start, residual_dates)
  start <- c(
    abs_change[t_star - 1 + 0:2] / mean(abs_change[1:(t_star - 2)]),
    0.8
  ) |>
    purrr::set_names(c("s0", "s1", "s2", "rho"))
  lower <- lower[names(start)]
  upper <- upper[names(start)]
  start <- pmin(pmax(start, lower), upper)

  # factr = 1e3: the default 1e7 stops while the first-order conditions of s0
  # and s1 are still 1e-3 away from closing in simulated data. ndeps = 1e-6:
  # with the default finite-difference step of 1e-3 the numerical gradient
  # vanishes before the true one, and at p = 5 of the production panel the
  # optimizer stopped with those conditions 1e-3 away (2026-09-25)
  fit <- optim(
    start,
    loglik_at,
    method = "L-BFGS-B",
    lower = lower,
    upper = upper,
    control = list(fnscale = -1, factr = 1e3, ndeps = rep(1e-6, 4))
  )

  list(
    theta = fit$par,
    loglik = fit$value,
    start = start,
    convergence = fit$convergence,
    message = fit$message,
    path = covid_volatility_path(residual_dates, covid_start, fit$par)
  )
}


#' Check that an estimate of the COVID volatility scale is the global maximum
#'
#' Three guards on the output of [estimate_covid_theta()], each a `stop()`:
#'
#' 1. First-order conditions. At an interior maximum the envelope condition
#'    sets the squared Mahalanobis size per dimension of the standardized WLS
#'    residuals, against (B4), to one in `covid_start` and the month after,
#'    the two months that `s0` and `s1` govern alone.
#' 2. Profile in `rho`. With `(s0, s1, s2)` re-maximized at each point of a
#'    0.01 grid, no point may exceed the free maximum.
#' 3. Multi-start over the box. From every combination of `start_s` (for each
#'    of `s0`, `s1`, `s2`) and `start_rho`, no start may end above the free
#'    maximum, and none may end level with it more than 5% away from
#'    theta-hat, or theta-hat is not the unique global maximum.
#'
#' The optimizer settings are those of [estimate_covid_theta()], so that the
#' guards run the same optimizer as the estimate.
#'
#' @param data,p,type,residual_dates,covid_start,lower,upper As passed to
#'   [estimate_covid_theta()].
#' @param fit Its return value.
#' @param start_s,start_rho Starting values of each scale and of `rho`.
#'
#' @return Tibble with one row per start: the starting values, the end point,
#'   its `loglik` and `convergence`, `loglik_gap` to the free maximum and
#'   `distance_to_hat`, the largest relative gap across the four components.
#'
#' @examples
#' multistart <- verify_covid_theta(factors, 4L, "const", residual_dates,
#'                                  covid_start, lower, upper, fit,
#'                                  exp(seq(0, log(40), length.out = 5)),
#'                                  seq(0, 1, by = 0.2))
verify_covid_theta <- function(data, p, type, residual_dates, covid_start,
                               lower, upper, fit, start_s, start_rho) {
  loglik_at <- function(theta) {
    path <- covid_volatility_path(residual_dates, covid_start, theta)
    estimate_var_wls(data, p, type = type, s = path)$loglik
  }

  wls <- estimate_var_wls(data, p, type = type, s = fit$path)
  standardized <- wls$residuals_standardized
  mahalanobis_per_dim <- rowSums(
    (standardized %*% solve(wls$sigma_mle)) * standardized
  ) / ncol(data)

  t_star <- match(covid_start, residual_dates)
  single_month <- c(s0 = t_star, s1 = t_star + 1L)
  interior <- fit$theta[names(single_month)] > lower[names(single_month)]
  foc_gap <- abs(mahalanobis_per_dim[single_month] - 1)
  if (fit$convergence != 0 || any(interior & foc_gap > 1e-4)) {
    stop(
      "estimate_covid_theta did not reach the maximum: convergence ",
      fit$convergence,
      ", |m - 1| at t* and t* + 1 = ",
      paste(signif(foc_gap, 3), collapse = ", ")
    )
  }

  loglik_tol <- 1e-6 * abs(fit$loglik)

  profile_loglik <- purrr::map_dbl(seq(0, 1, by = 0.01), function(rho) {
    optim(
      fit$theta[c("s0", "s1", "s2")],
      function(s) loglik_at(c(s, rho = rho)),
      method = "L-BFGS-B",
      lower = lower[c("s0", "s1", "s2")],
      upper = upper[c("s0", "s1", "s2")],
      control = list(fnscale = -1, factr = 1e3, ndeps = rep(1e-6, 3))
    )$value
  })
  if (max(profile_loglik) > fit$loglik + loglik_tol) {
    stop(
      "The rho profile reaches ", max(profile_loglik), ", above the free ",
      "maximum ", fit$loglik, ": estimate_covid_theta stopped at a local peak"
    )
  }

  multistart <- tidyr::expand_grid(
    start_s0 = start_s,
    start_s1 = start_s,
    start_s2 = start_s,
    start_rho = start_rho
  ) |>
    purrr::pmap(function(start_s0, start_s1, start_s2, start_rho) {
      end <- optim(
        c(s0 = start_s0, s1 = start_s1, s2 = start_s2, rho = start_rho),
        loglik_at,
        method = "L-BFGS-B",
        lower = lower,
        upper = upper,
        control = list(fnscale = -1, factr = 1e3, ndeps = rep(1e-6, 4))
      )
      tibble::tibble(
        start_s0,
        start_s1,
        start_s2,
        start_rho,
        s0 = end$par[["s0"]],
        s1 = end$par[["s1"]],
        s2 = end$par[["s2"]],
        rho = end$par[["rho"]],
        loglik = end$value,
        convergence = end$convergence
      )
    }) |>
    purrr::list_rbind() |>
    dplyr::mutate(
      loglik_gap = loglik - fit$loglik,
      distance_to_hat = pmax(
        abs(s0 / fit$theta[["s0"]] - 1),
        abs(s1 / fit$theta[["s1"]] - 1),
        abs(s2 / fit$theta[["s2"]] - 1),
        abs(rho / fit$theta[["rho"]] - 1)
      )
    )

  best_start <- dplyr::slice_max(multistart, loglik, n = 1, with_ties = FALSE)
  if (best_start$loglik > fit$loglik + loglik_tol) {
    stop(
      "A multi-start ends at ", best_start$loglik, ", above the free maximum ",
      fit$loglik, ", at (s0, s1, s2, rho) = (",
      paste(
        signif(unlist(best_start[c("s0", "s1", "s2", "rho")]), 7),
        collapse = ", "
      ),
      "): theta-hat is not the global maximum"
    )
  }
  level_elsewhere <- multistart$loglik >= fit$loglik - loglik_tol &
    multistart$distance_to_hat > 0.05
  if (any(level_elsewhere)) {
    stop(
      sum(level_elsewhere), " multi-starts end level with the free maximum ",
      "more than 5% away from theta-hat: the maximum is not unique"
    )
  }

  multistart
}


#' Read the estimated COVID volatility scale of the factor VAR
#'
#' Returns the `covid_volatility` list that `estimate_dfm()` expects, with
#' `covid_start` and theta read from the CSV that
#' `script/covid_volatility_theta.R` writes. Theta is an estimate, not a
#' decision, so it is never typed as a literal: `readr` writes doubles at
#' shortest-round-trip precision, so the four values come back bit-identical
#' to the maximizer of (B5). `innovations` is an author decision and is not in
#' the CSV.
#'
#' @param path CSV written by `script/covid_volatility_theta.R`, with columns
#'   `covid_start`, `s0`, `s1`, `s2` and `rho`. No default: every call site
#'   writes the path it reads.
#' @param innovations `"standardized"` (`u_t / s_t`, production) or `"raw"`.
#'
#' @return List with `covid_start` (Date), `theta` (named `s0`, `s1`, `s2`,
#'   `rho`) and `innovations`.
#'
#' @examples
#' cv <- read_covid_volatility("output/factors/covid_volatility_theta.csv")
read_covid_volatility <- function(path, innovations = "standardized") {
  if (!file.exists(path)) {
    stop(
      "COVID volatility scale not found at '", path,
      "'. Run script/covid_volatility_theta.R, which estimates theta by ",
      "maximum likelihood and writes it."
    )
  }
  fit <- readr::read_csv(path, show_col_types = FALSE)

  list(
    covid_start = as.Date(fit$covid_start),
    theta = c(s0 = fit$s0, s1 = fit$s1, s2 = fit$s2, rho = fit$rho),
    innovations = innovations
  )
}


#' Reduce the factor-VAR innovations to q dynamic shocks
#'
#' Takes the leading `q` eigenvectors `K` of `sigma_u`, each signed so that its
#' largest entry is positive, and `M = diag(sqrt(eigenvalues))`, so the `r`
#' innovations are spanned by the `q` dynamic shocks `eta = u K M^-1`. When
#' `q == r` the reduction is the identity: `K = M = I_r` and `eta = u`.
#'
#' @param var_residuals Matrix of factor-VAR innovations (T - p x r).
#' @param q Number of dynamic factors.
#' @param sigma_u Second-moment matrix whose leading eigenvectors give `K`.
#'
#' @return List with `factors` (eta), `K` and `M`.
#'
#' @examples
#' dyn <- estimate_dynamic_factors(u, q = 3L, sigma_u = cov(u))
estimate_dynamic_factors <- function(var_residuals, q, sigma_u) {
  r <- ncol(var_residuals)
  if (q == r) {
    return(list(factors = var_residuals, K = diag(r), M = diag(r)))
  }

  svd_u <- svd(sigma_u)
  K <- svd_u$u[, 1:q, drop = FALSE]
  flip <- K[cbind(apply(abs(K), 2, which.max), seq_len(q))] < 0
  K <- sweep(K, 2, dplyr::if_else(flip, -1, 1), "*")
  # nrow = q: with q = 1, diag() would read the scalar as a dimension
  M <- diag(sqrt(svd_u$d[1:q]), nrow = q)

  list(factors = var_residuals %*% K %*% solve(M), K = K, M = M)
}


#' Estimate the structural dynamic factor model end to end
#'
#' Chains static factors (BLL standardization), the factor VAR and the
#' dynamic factors, following Alessi & Kerssenfischer over the BLL
#' methodology. With an `instrument`, the panel and the instrument are first
#' trimmed to their common months, so the residuals are aligned to the proxy.
#'
#' @param data Numeric matrix T x N (no date column).
#' @param r Number of static factors.
#' @param q Number of dynamic factors.
#' @param p Factor-VAR lag order.
#' @param dates Date vector with T elements; required with `instrument` or
#'   `covid_volatility`.
#' @param instrument Optional data.frame with columns `month` (Date) and
#'   `shock` (numeric).
#' @param covid_volatility NULL, or a list that turns on the COVID volatility
#'   scale of Lenza & Primiceri (2022) in the factor VAR: `covid_start` (Date,
#'   one of the residual months), `theta` (named `s0`, `s1`, `s2`, `rho`) and
#'   `innovations` — `"raw"`, the residuals `u_t`, or `"standardized"`,
#'   `u_t / s_t` — which decides what K, M and eta read downstream. Every
#'   field is required, because each is an author decision;
#'   `read_covid_volatility()` builds the production one.
#'
#' @return List with the static factors and loadings, `data_sd`, the factor
#'   VAR (`var_coefficients`, `var_residuals` — the innovations the switch
#'   selected — and `companion_matrix`), the dynamic factors and their `K`
#'   (`dynamic_loadings`) and `M` (`dynamic_scaling`), `p`, `r`, `q`, the
#'   aligned `dates` and `instrument`, `covid_volatility`, `volatility_path`
#'   (`s_t`, or 1) and `diagnostics` (largest companion root and stability).
#'
#' @examples
#' dfm <- estimate_dfm(panel, 5L, 5L, 4L, dates = dates,
#'                     covid_volatility = read_covid_volatility(theta_path))
estimate_dfm <- function(data, r, q, p, dates = NULL, instrument = NULL,
                         covid_volatility = NULL) {
  if (!is.null(instrument)) {
    keep <- dates %in% instrument$month
    data <- data[keep, , drop = FALSE]
    dates <- dates[keep]
    # Base subsetting, not dplyr::filter(): a data.frame instrument keeps its
    # row names, and the cached estimation cells carry them
    instrument <- instrument[instrument$month %in% dates, ]
    instrument <- instrument[order(instrument$month), ]
  }

  # Lenza-Primiceri (2022, Appendix B): every field is an author decision
  volatility_path <- 1
  if (!is.null(covid_volatility)) {
    missing_fields <- c(
      setdiff(
        c("covid_start", "theta", "innovations"),
        names(covid_volatility)
      ),
      setdiff(c("s0", "s1", "s2", "rho"), names(covid_volatility$theta))
    )
    if (length(missing_fields) > 0) {
      stop(
        "covid_volatility sem ", paste(missing_fields, collapse = ", "),
        ": escolhas do autor, sem default ",
        "(notas/2026-09-14_volatilidade_covid_lenza_primiceri.md)"
      )
    }
    if (!isTRUE(covid_volatility$innovations %in% c("raw", "standardized"))) {
      stop(
        "covid_volatility$innovations deve ser 'raw' (u_t) ou ",
        "'standardized' (u_t/s_t)"
      )
    }
    residual_dates <- dates[(p + 1):length(dates)]
    if (!isTRUE(covid_volatility$covid_start %in% residual_dates)) {
      stop(
        "covid_start (", format(covid_volatility$covid_start),
        ") nao e um mes dos residuos do VAR (", format(residual_dates[1]),
        " a ", format(residual_dates[length(residual_dates)]), ")"
      )
    }
    volatility_path <- covid_volatility_path(
      residual_dates,
      covid_volatility$covid_start,
      covid_volatility$theta
    )
  }

  static <- estimate_static_factors(data, r)
  var_fit <- estimate_var_wls(
    static$factors,
    p,
    type = "const",
    s = volatility_path
  )

  # K, M, eta and the proxy's H assume a constant variance and read these
  # innovations. Under the treatment nothing is centred: K reads the uncentred
  # second moment, which is (B4) for "standardized".
  innovations <- if (identical(covid_volatility$innovations, "standardized")) {
    var_fit$residuals_standardized
  } else {
    var_fit$residuals
  }
  sigma_u <- if (is.null(covid_volatility)) {
    cov(innovations)
  } else {
    crossprod(innovations) / nrow(innovations)
  }
  dynamic <- estimate_dynamic_factors(innovations, q, sigma_u)

  max_eigenvalue <- max(abs(eigen(var_fit$companion)$values))

  list(
    static_factors = static$factors,
    static_loadings = static$loadings,
    data_sd = static$sy,
    var_coefficients = var_fit$coefficients,
    var_residuals = innovations,
    companion_matrix = var_fit$companion,
    dynamic_factors = dynamic$factors,
    dynamic_loadings = dynamic$K,
    dynamic_scaling = dynamic$M,
    p = p,
    r = r,
    q = q,
    dates = dates,
    instrument = instrument,
    covid_volatility = covid_volatility,
    volatility_path = volatility_path,
    diagnostics = list(
      max_eigenvalue = max_eigenvalue,
      is_stable = max_eigenvalue < 1
    )
  )
}


#' Recover the dynamic-factor innovations `eta = u K M^-1` of a fitted DFM
#'
#' @param dfm_results Fitted DFM returned by `estimate_dfm()`.
#'
#' @return Numeric matrix with one dynamic innovation per column.
#'
#' @examples
#' eta <- extract_dynamic_innovations(dfm)
extract_dynamic_innovations <- function(dfm_results) {
  dfm_results$var_residuals %*%
    dfm_results$dynamic_loadings %*%
    solve(dfm_results$dynamic_scaling)
}
