library(dplyr)
library(lubridate)
library(tibble)
library(purrr)
library(sandwich)
library(lmtest)
library(tidyr)

#' Residualize a monthly target by AR(p)
#'
#' Fits y_t = c + sum phi_k y_{t-k} + e_t with na.exclude so the residual
#' vector keeps the input length (NA in the first n_lags positions).
#' Estimating once on the full sample lets sub-period and random-mask tests
#' subset by index without spurious lag jumps across discontinuous windows.
#'
#' @param target Numeric monthly target vector.
#' @param n_lags AR order (default 6).
#'
#' @return Numeric vector aligned to target (NA where lag is undefined).
residualize_target <- function(target, n_lags = 6L) {
  innov_data <- data.frame(
    y = target,
    purrr::map_dfc(seq_len(n_lags),
                   \(k) tibble(!!paste0("lag", k) := dplyr::lag(target, k)))
  )
  innov_lm <- lm(y ~ ., data = innov_data, na.action = na.exclude)
  as.numeric(residuals(innov_lm))
}

#' First-stage F (partial t-squared) given pre-computed AR residuals
#'
#' Stock-Yogo critical value for one instrument is F > 10; this is the
#' Montiel Olea-Stock-Watson partial F. Returns NA_real_ when the instrument
#' is constant on the effective sample or fewer than 3 observations remain
#' after NA-exclusion (degenerate cases that arise in placebo / random-mask
#' simulations).
#'
#' @param z_aligned Numeric instrument vector aligned to innov by index.
#' @param innov Numeric vector of AR-residualized target (same length as z).
#'
#' @return List with F_partial, beta, se, n, r2.
first_stage_F <- function(z_aligned, innov) {
  ok <- !is.na(innov) & !is.na(z_aligned)
  na_result <- list(F_partial = NA_real_, beta = NA_real_, se = NA_real_,
                    n = sum(ok), r2 = NA_real_)
  if (sum(ok) < 3L) return(na_result)
  z_ok <- z_aligned[ok]
  if (stats::sd(z_ok) == 0) return(na_result)

  fs <- lm(y ~ z, data = data.frame(y = innov[ok], z = z_ok))
  ct <- coeftest(fs, vcov = vcovHC(fs, type = "HC0"))
  list(F_partial = unname(ct["z", "t value"])^2,
       beta = unname(ct["z", "Estimate"]),
       se   = unname(ct["z", "Std. Error"]),
       n    = sum(ok),
       r2   = summary(fs)$r.squared)
}

#' Placebo permutation test for first-stage F
#'
#' Permutes the monthly instrument B times, recomputes the first-stage F under
#' each permutation, and returns the empirical distribution under the null of
#' no relation between instrument and target. Under the null F_placebo
#' concentrates near 1 (mean of an F(1, df) is df/(df-2) ≈ 1 for large df).
#' A small empirical p-value (count of placebo F >= observed F) indicates the
#' observed F is not driven by chance alignment.
#'
#' @param z Monthly instrument vector (e.g., z_het_jk).
#' @param innov Pre-computed AR(p) residual vector aligned to z; produced once
#'   on the full sample by residualize_target() and reused across permutations.
#' @param n_perm Number of permutations (default 2000).
#' @param seed Optional integer seed.
#'
#' @return Tibble with one row per permutation: perm_id, F_partial, beta.
placebo_test <- function(z, innov, n_perm = 2000L, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  purrr::map_dfr(seq_len(n_perm), function(b) {
    z_perm <- sample(z)
    fs <- first_stage_F(z_perm, innov)
    tibble(perm_id = b, F_partial = fs$F_partial, beta = fs$beta)
  })
}

#' Random-mask test: random subsample vs Jarocinski-Karadi sign filter
#'
#' Tests whether the F-gain of z_het_jk over z_het is driven by the
#' INFORMATIVENESS of the JK sign criterion (true purification) or simply by
#' SPARSIFICATION (any reduction to k_keep days raises F). Each draw randomly
#' keeps k_keep Copom days out of n_total and zeros the rest, then aggregates
#' to monthly and computes F. The empirical distribution under random masking
#' is the appropriate null for the JK F.
#'
#' @param shocks_C Daily shock vector on Copom Wed-Thu pairs.
#' @param shock_dates Date vector aligned to shocks_C.
#' @param innov Pre-computed AR(p) residual vector for the monthly target,
#'   aligned to target_dates and produced once via residualize_target().
#' @param target_dates Month-start Date vector aligned to innov.
#' @param k_keep Number of Copom days to keep per draw (e.g., 42 to match JK).
#' @param month_range Length-2 Date vector bounding the monthly grid.
#' @param n_draws Number of random masks (default 2000).
#' @param seed Optional integer seed.
#'
#' @return Tibble with one row per draw: draw_id, F_partial, beta, n_kept.
random_mask_test <- function(shocks_C,
                             shock_dates,
                             innov,
                             target_dates,
                             k_keep,
                             month_range,
                             n_draws = 2000L,
                             seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  n_total <- length(shocks_C)
  start <- floor_date(month_range[1], "month")
  end   <- floor_date(month_range[2], "month")
  monthly_grid <- seq(start, end, by = "month")

  purrr::map_dfr(seq_len(n_draws), function(b) {
    keep_idx <- sample.int(n_total, size = k_keep)
    masked <- shocks_C
    masked[-keep_idx] <- 0

    z_monthly <- aggregate_to_monthly_grid(masked, shock_dates, monthly_grid)
    z_aligned <- align_z_to_target(z_monthly, monthly_grid, target_dates)

    fs <- first_stage_F(z_aligned, innov)
    tibble(draw_id = b, F_partial = fs$F_partial, beta = fs$beta, n_kept = k_keep)
  })
}

#' Aggregate a daily shock series to a fixed monthly grid by simple sum
#'
#' Helper for random_mask_test. Months without contributing days receive 0.
#'
#' @param shocks Numeric daily vector.
#' @param dates Date vector aligned to shocks.
#' @param monthly_grid Date vector of month-starts.
#'
#' @return Numeric vector aligned to monthly_grid.
aggregate_to_monthly_grid <- function(shocks, dates, monthly_grid) {
  obs <- tibble(date = dates, s = shocks) |>
    mutate(month = floor_date(date, "month")) |>
    group_by(month) |>
    summarise(z = sum(s, na.rm = TRUE), .groups = "drop")
  tibble(month = monthly_grid) |>
    left_join(obs, by = "month") |>
    mutate(z = replace_na(z, 0)) |>
    pull(z)
}

#' Reindex a monthly instrument to the target's month sequence
#'
#' Both instrument and target are at monthly frequency but their date
#' conventions may differ (month-start vs month-end). This helper joins on
#' month-start and returns the instrument aligned to the target's row order.
#'
#' @param z_vec Numeric instrument vector.
#' @param z_dates Date vector for z_vec.
#' @param target_dates Date vector for the target series.
#'
#' @return Numeric vector aligned to target_dates.
align_z_to_target <- function(z_vec, z_dates, target_dates) {
  z_tbl <- tibble(month = floor_date(z_dates, "month"), z = z_vec)
  tibble(month = floor_date(target_dates, "month")) |>
    left_join(z_tbl, by = "month") |>
    pull(z)
}

#' Sub-period first-stage F for stability assessment
#'
#' Subsets pre-computed full-sample residuals and the instrument by window,
#' then recomputes F. Residualizing once on the full contiguous sample (and
#' subsetting the residuals afterwards) avoids two issues that arise when the
#' AR(p) is refit per window: (i) the drop_covid window is non-contiguous in
#' time, so refitting AR within it would lag October 2020 on February 2020;
#' (ii) refitting per window would discard the first n_lags observations of
#' every window, distorting effective sample sizes.
#'
#' @param z Monthly instrument vector aligned to innov.
#' @param innov Full-sample AR(p) residual vector from residualize_target().
#' @param target_dates Month-start Date vector aligned to z and innov.
#' @param windows Named list of length-2 Date vectors c(start, end). The
#'   special entry "drop_covid" excludes 2020-03..2020-09 from the full sample.
#'
#' @return Tibble with one row per window: window, n_months, F_partial,
#'   beta, se, r2, n_eff (effective sample after NA-exclusion).
subperiod_F <- function(z, innov, target_dates, windows) {
  target_dates <- floor_date(target_dates, "month")

  purrr::imap_dfr(windows, function(spec, name) {
    if (name == "drop_covid") {
      keep <- !(target_dates >= spec[1] & target_dates <= spec[2])
    } else {
      keep <- target_dates >= spec[1] & target_dates <= spec[2]
    }
    fs <- first_stage_F(z[keep], innov[keep])
    tibble(
      window    = name,
      n_months  = sum(keep),
      F_partial = fs$F_partial,
      beta      = fs$beta,
      se        = fs$se,
      r2        = fs$r2,
      n_eff     = fs$n
    )
  })
}

#' Pearson and Spearman correlation between two monthly instruments
#'
#' Computes correlation over (i) all months, (ii) the union of months where
#' either instrument is nonzero, and (iii) the intersection (both nonzero).
#' Convergence between heteroskedasticity-based and timing-based identification
#' should manifest mainly on the intersection.
#'
#' @param z1 First monthly instrument vector.
#' @param z2 Second monthly instrument vector aligned to z1.
#' @param name1,name2 Labels for the report.
#'
#' @return Tibble with one row per subset: subset, n, pearson, spearman.
monthly_correlation <- function(z1, z2, name1 = "z1", name2 = "z2") {
  subsets <- list(
    all          = rep(TRUE, length(z1)),
    union_nonzero = (z1 != 0) | (z2 != 0),
    both_nonzero  = (z1 != 0) & (z2 != 0)
  )

  purrr::imap_dfr(subsets, function(mask, label) {
    a <- z1[mask]
    b <- z2[mask]
    tibble(
      pair     = sprintf("%s ~ %s", name1, name2),
      subset   = label,
      n        = length(a),
      pearson  = if (length(a) > 1) cor(a, b, method = "pearson")  else NA_real_,
      spearman = if (length(a) > 1) cor(a, b, method = "spearman") else NA_real_
    )
  })
}
