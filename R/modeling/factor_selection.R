#' Bai and Ng (2002) information criteria for the number of static factors
#'
#' IC1, IC2 and IC3 over `r = 1..max_r`, from the residual variance `V(r)` of
#' the rank-`r` principal-components fit. With `apply_bll = TRUE` the panel is
#' first put in the Barigozzi-Lippi-Luciani form the production PCA reads:
#' first differences, centered and divided by their standard deviation.
#' Plain Bai-Ng on the levels would require stationarity.
#'
#' @param X Numeric matrix T x N.
#' @param max_r Largest number of factors considered.
#' @param standardize Center and scale the columns when `apply_bll = FALSE`.
#' @param apply_bll Use the BLL standardization of the first differences.
#'
#' @return List with `r_hat` (the argmin of each criterion), `criteria` (the
#'   three surfaces over `r = 1..max_r`) and `pca` (the `prcomp` object).
#'
#' @examples
#' bn <- bai_ng_criteria(panel, max_r = 20L, apply_bll = TRUE)
bai_ng_criteria <- function(X, max_r = 15, standardize = TRUE, apply_bll = FALSE) {
  X <- as.matrix(X)

  if (apply_bll) {
    y <- diff(X)
    sy <- apply(y, 2, sd)
    y_centered <- sweep(y, 2, colMeans(y), "-")
    X_std <- sweep(y_centered, 2, sy, "/")
  } else if (standardize) {
    X_std <- scale(X, center = TRUE, scale = TRUE)
  } else {
    X_std <- X
  }

  n_obs <- nrow(X_std)
  n_ser <- ncol(X_std)
  pca <- prcomp(X_std, scale. = FALSE, center = FALSE)

  V <- vapply(seq_len(max_r), function(r) {
    resid <- X_std - pca$x[, 1:r] %*% t(pca$rotation[, 1:r])
    sum(resid^2) / (n_ser * n_obs)
  }, numeric(1))

  r <- seq_len(max_r)
  e <- (n_ser + n_obs) / (n_ser * n_obs)
  m <- min(n_ser, n_obs)
  ic1 <- log(V) + r * e * log(1 / e)
  ic2 <- log(V) + r * e * log(m)
  ic3 <- log(V) + r * log(m) / m

  list(
    r_hat = list(IC1 = which.min(ic1), IC2 = which.min(ic2), IC3 = which.min(ic3)),
    criteria = list(IC1 = ic1, IC2 = ic2, IC3 = ic3),
    pca = pca
  )
}


#' Amengual and Watson (2007) estimate of the number of dynamic factors
#'
#' Extracts `r` static factors by principal components, regresses every series
#' on a constant and `p` lags of them, and applies the Bai-Ng IC2 to the
#' residuals: `q_hat` is its argmin over `q = 1..max_q`.
#'
#' @param X Numeric matrix T x N.
#' @param r Number of static factors.
#' @param p Lags of the factors in the filtering regression.
#' @param max_q Largest number of dynamic factors considered.
#' @param scale Center and scale the columns when `apply_bll = FALSE`.
#' @param apply_bll Use the BLL standardization of the first differences.
#' @param standardize_resid Standardize the residuals column by column before
#'   the second-stage Bai-Ng, as Stock-Watson's `factor_estimation_ls.m` does.
#'   `FALSE` keeps every recorded `q_hat`
#'   (notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md §2).
#'
#' @return List with `aw` (the IC2 surface over `q = 1..max_q`) and `q_hat`.
#'
#' @examples
#' aw <- amengual_watson(panel, r = 5L, p = 4L, apply_bll = TRUE)
amengual_watson <- function(X, r, p = 4, max_q = r, scale = TRUE, apply_bll = FALSE,
                            standardize_resid = FALSE) {
  X <- as.matrix(X)

  if (apply_bll) {
    y <- diff(X)
    sy <- apply(y, 2, sd)
    y_centered <- sweep(y, 2, colMeans(y), "-")
    X_std <- sweep(y_centered, 2, sy, "/")
  } else if (scale) {
    X_std <- scale(X, center = TRUE, scale = TRUE)
  } else {
    X_std <- X
  }

  F_hat <- prcomp(X_std, scale. = FALSE, center = FALSE)$x[, 1:r, drop = FALSE]
  n_obs <- nrow(X_std)
  Z <- cbind(1, stats::embed(F_hat, p + 1)[, -(1:r), drop = FALSE])

  # Series by series: one matrix solve for every column differs in the last
  # bits and would move the recorded surfaces
  resid_mat <- vapply(seq_len(ncol(X_std)), function(i) {
    y <- X_std[(p + 1):n_obs, i]
    drop(y - Z %*% solve(crossprod(Z), crossprod(Z, y)))
  }, numeric(n_obs - p))

  bn <- bai_ng_criteria(resid_mat, max_r = max_q, standardize = standardize_resid)

  list(aw = bn$criteria$IC2, q_hat = bn$r_hat$IC2)
}


#' Eigenvalues of X'X/(NT), the spectrum Ahn-Horenstein and ABC both read
#'
#' Ahn & Horenstein (2013, sec. 2) define `mu_k = psi_k[X'X/(NT)]`; the Bai-Ng
#' residual variance that Alessi, Barigozzi & Capasso (2010, eq. 2) inherit is
#' the tail sum of the same spectrum. All `min(N, T)` eigenvalues are returned,
#' because `V(k)` sums up to `m`, not up to `kmax + 1`.
#'
#' @param X Numeric matrix T x N, already transformed and standardized.
#'
#' @return Numeric vector of the `min(N, T)` eigenvalues in decreasing order.
#'
#' @examples
#' mu <- panel_eigenvalues(matrix(rnorm(200), 20, 10))
panel_eigenvalues <- function(X) {
  svd(X, nu = 0, nv = 0)$d^2 / (nrow(X) * ncol(X))
}


#' Ahn & Horenstein (2013) eigenvalue-ratio and growth-ratio estimators
#'
#' `ER(k) = mu_k / mu_{k+1}` and `GR(k) = ln(1 + mu*_k) / ln(1 + mu*_{k+1})`,
#' where `V(k) = sum_{j>k} mu_j` runs over the whole spectrum and
#' `mu*_k = mu_k / V(k)` (sec. 2). Row `k = 0` carries the mock eigenvalue
#' `mu_0 = V(0) / ln(m)` of eq. (4), which admits zero factors (Corollary 1).
#' `k_er`/`k_gr` maximize over `k = 1..kmax` (Theorem 1), `k_er0`/`k_gr0` over
#' `k = 0..kmax` (Corollary 1). `kmax2` is the paper's data-driven bound
#' `min(#{k : mu_k >= V(0)/m}, 0.1 m)`.
#'
#' @param X Numeric matrix T x N, already transformed and standardized.
#' @param kmax Largest number of factors considered.
#'
#' @return List with `surface` (tibble with `k`, `mu`, `V`, `mu_star`, `ER`,
#'   `GR` for `k = 0..kmax`), `k_er`, `k_gr`, `k_er0`, `k_gr0` and `kmax2`.
#'
#' @examples
#' ah <- ahn_horenstein(matrix(rnorm(2000), 100, 20), kmax = 8)
ahn_horenstein <- function(X, kmax) {
  mu <- panel_eigenvalues(X)
  m <- length(mu)

  V <- rev(cumsum(rev(mu)))[seq_len(kmax + 2)]     # V(0), ..., V(kmax + 1)
  mu_k <- c(V[1] / log(m), mu[seq_len(kmax + 1)])  # mu_0 (eq. 4), mu_1, ..., mu_{kmax+1}
  mu_star <- mu_k / V
  pos <- seq_len(kmax + 1)                          # positions of k = 0..kmax
  ER <- mu_k[pos] / mu_k[pos + 1]
  GR <- log1p(mu_star[pos]) / log1p(mu_star[pos + 1])

  list(
    surface = tibble::tibble(k = 0:kmax, mu = mu_k[pos], V = V[pos],
                             mu_star = mu_star[pos], ER = ER, GR = GR),
    k_er = which.max(ER[-1]),
    k_gr = which.max(GR[-1]),
    k_er0 = which.max(ER) - 1L,
    k_gr0 = which.max(GR) - 1L,
    kmax2 = as.integer(min(sum(mu >= V[1] / m), floor(0.1 * m)))
  )
}


#' Alessi, Barigozzi & Capasso (2010) tuned Bai-Ng criterion
#'
#' For each nested cross-section subsample -- the first `n_j` columns of
#' `X[, col_order]` -- and each tuning constant `c`, `r_hat(c, j)` minimizes
#' `IC*(k) = log V(k) + c k g(n_j, T)` over `k = 0..kmax` (eq. 3, sec. 3). `S_c`
#' is the variance of `r_hat(c, .)` across the subsamples; a stability interval
#' is a run of consecutive grid values with `S_c = 0` and the same full-sample
#' `r_hat`. The first interval sits at `r_max` and is not admissible, so the
#' estimate is the first interval with `r_hat < kmax` -- the paper's "second
#' stability interval". Subsamples run over the cross-section only and no
#' minimum interval length is imposed, as in the paper's simulations (sec. 4).
#'
#' `IC2` reads the paper's `log(min{sqrt(n), sqrt(T)})^2` as
#' `log C_nT^2 = log min(n, T)`, the Bai-Ng IC_p2 penalty that ABC rescale.
#'
#' @param X Numeric matrix T x N, already transformed and standardized.
#' @param kmax `r_max`, the largest number of factors considered.
#' @param penalty `"IC1"` or `"IC2"`.
#' @param col_order Permutation of the columns fixing the nesting. The paper
#'   leaves the order open, so the caller has to choose it.
#' @param c_grid Tuning constants; the paper's `(0, 5]` by 0.01 (sec. 4).
#' @param n_sub Increasing subsample sizes ending at `N`; the paper's
#'   `floor(3N/4), ..., N` (sec. 4).
#'
#' @return List with `r_hat`, `c_interval` (bounds of the selected interval),
#'   `first_at_kmax` (whether the first interval sits at `kmax`, as the paper
#'   asserts), `intervals` (every stability interval), `path` (tibble with `c`,
#'   the full-sample `r_full`, `S_c` and the range of `r_hat` across the
#'   subsamples) and `r_by_sub` (matrix, subsamples x grid).
#'
#' @examples
#' X <- matrix(rnorm(4000), 100, 40)
#' abc <- abc_criterion(X, kmax = 8, penalty = "IC1", col_order = sample.int(40))
abc_criterion <- function(X, kmax, penalty, col_order,
                          c_grid = seq(0.01, 5, by = 0.01),
                          n_sub = floor(3 * ncol(X) / 4):ncol(X)) {
  n_T <- nrow(X)

  r_by_sub <- t(vapply(n_sub, function(n) {
    V <- rev(cumsum(rev(panel_eigenvalues(X[, col_order[seq_len(n)]]))))[seq_len(kmax + 1)]
    e <- (n + n_T) / (n * n_T)
    g <- switch(penalty, IC1 = e * log(1 / e), IC2 = e * log(min(n, n_T)))
    ic <- log(V) + outer(0:kmax, c_grid) * g
    apply(ic, 2, which.min) - 1L
  }, integer(length(c_grid))))

  S_c <- colMeans(sweep(r_by_sub, 2, colMeans(r_by_sub))^2)
  r_full <- r_by_sub[length(n_sub), ]
  stable <- S_c == 0
  run <- cumsum(c(TRUE, diff(stable) != 0 | diff(r_full) != 0))

  intervals <- tibble::tibble(c = c_grid, r = r_full, stable = stable, run = run) |>
    dplyr::filter(stable) |>
    dplyr::group_by(run) |>
    dplyr::summarise(r = dplyr::first(r), c_lo = min(c), c_hi = max(c),
                     n_grid = dplyr::n(), .groups = "drop") |>
    dplyr::select(-run)
  admissible <- intervals |>
    dplyr::filter(r < kmax)
  if (nrow(admissible) == 0) {
    stop("No admissible stability interval of ABC-", penalty, " in the c grid.")
  }

  list(
    r_hat = admissible$r[1],
    c_interval = c(admissible$c_lo[1], admissible$c_hi[1]),
    first_at_kmax = intervals$r[1] == kmax,
    intervals = intervals,
    path = tibble::tibble(c = c_grid, r_full = r_full, S_c = S_c,
                          r_min = apply(r_by_sub, 2, min),
                          r_max = apply(r_by_sub, 2, max)),
    r_by_sub = r_by_sub
  )
}
