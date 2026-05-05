library(dplyr)
library(lubridate)

#' Build the C/NC regime table over Wednesday-to-next-trading-day pairs
#'
#' For each Wednesday in the panel of trading days, finds the next available
#' trading day (Thursday on regular weeks, Friday after a holiday). Tags the
#' pair as C if the Wednesday is a Copom announcement day, NC otherwise.
#' Pairs whose Wed-to-next-trading-day gap exceeds max_gap_days are dropped
#' to prevent long holiday weekends from contaminating the variance split.
#'
#' @param panel_dates Date vector of available trading days.
#' @param copom_wednesdays Date vector of Copom announcement Wednesdays.
#' @param max_gap_days Maximum allowed calendar-day gap between Wed and the
#'   next trading day (default 3: covers Thu, Fri after Thu holiday, and Mon
#'   after a Thu+Fri holiday; rejects week-long holidays such as Carnaval).
#'
#' @return Tibble with columns wed_date, thu_date, regime ("C" or "NC").
build_daily_regimes <- function(panel_dates,
                                copom_wednesdays,
                                max_gap_days = 3L) {
  panel <- sort(unique(as.Date(panel_dates)))
  weds  <- panel[lubridate::wday(panel) == 4]

  match_idx <- match(weds, panel)
  next_idx  <- match_idx + 1L
  valid     <- next_idx <= length(panel)

  weds <- weds[valid]
  thus <- panel[next_idx[valid]]

  gap_ok <- as.numeric(thus - weds) <= max_gap_days
  weds   <- weds[gap_ok]
  thus   <- thus[gap_ok]

  copom <- as.Date(copom_wednesdays)

  tibble::tibble(
    wed_date = weds,
    thu_date = thus,
    regime   = ifelse(weds %in% copom, "C", "NC")
  )
}

#' Compute Wed-to-Thu DI surprises at a target maturity for a regime table
#'
#' Uses surprise_wed_to_thu (R/instrument/di_surprise.R) per row, picking the
#' contract closest to target_bd business days to expiry. NA when neither leg
#' has a trade for the matched contract.
#'
#' @param di_panel DI panel from load_di_panel().
#' @param regime_table Output of build_daily_regimes().
#' @param target_bd Target business days to expiry (e.g., 63 ≈ 3m, 504 ≈ 2y).
#' @param min_bd Minimum business days to expiry.
#'
#' @return Numeric vector aligned to regime_table rows, in basis points.
extract_di_change <- function(di_panel, regime_table, target_bd, min_bd = 10) {
  purrr::map2_dbl(
    regime_table$wed_date, regime_table$thu_date,
    ~ surprise_wed_to_thu(di_panel, .x, .y,
                          target_bd = target_bd, min_bd = min_bd)
  )
}

#' Compute Wed-to-Thu changes for a generic daily price series
#'
#' Maps the regime table's Wed and Thu dates to the daily series and returns
#' the requested transformation. log_diff suits indices and exchange rates;
#' bps_diff suits CDS or yield-spread series already expressed in percent.
#'
#' @param daily_series Tibble (or data.frame) with a Date column and a numeric
#'   value column. Column names are ignored: position 1 must be Date, position
#'   2 the value.
#' @param regime_table Output of build_daily_regimes().
#' @param transform "log_diff" (returns log(thu) - log(wed)) or "bps_diff"
#'   (returns (thu - wed) * 100; assumes source in percent).
#'
#' @return Numeric vector aligned to regime_table rows.
extract_price_change <- function(daily_series,
                                 regime_table,
                                 transform = c("log_diff", "bps_diff")) {
  transform <- match.arg(transform)

  ds <- daily_series |>
    dplyr::transmute(date = as.Date(.data[[names(daily_series)[1]]]),
                     value = as.numeric(.data[[names(daily_series)[2]]]))

  lookup <- setNames(ds$value, as.character(ds$date))

  v_wed <- lookup[as.character(regime_table$wed_date)]
  v_thu <- lookup[as.character(regime_table$thu_date)]

  if (transform == "log_diff") {
    log(v_thu) - log(v_wed)
  } else {
    (v_thu - v_wed) * 100
  }
}

#' Validate the variance split between C and NC regimes
#'
#' Replicates GRG (2025) Table 1: per-variable variance under each regime,
#' ratio var_C / var_NC, and a bootstrap confidence interval for the ratio.
#' Identification requires var_C / var_NC > 1 (with CI excluding 1) for the
#' policy variable, and CIs including 1 for the remaining variables.
#'
#' @param changes_matrix Numeric matrix N_pairs x k_d of Wed-to-Thu changes.
#' @param regime_table Output of build_daily_regimes() aligned to changes.
#' @param alpha Significance level for the bootstrap CI (default 0.01).
#' @param n_boot Number of bootstrap replications (default 1000).
#' @param seed Optional integer seed for reproducibility.
#'
#' @details
#' NA handling is per-column (not row-wise): n_C and n_NC may differ across
#' variables. extract_shock_rigobon_sack() instead drops rows with any NA, so
#' its sample is a subset of what the variance test sees.
#'
#' @return Tibble with one row per variable: var, n_C, n_NC, var_C, var_NC,
#'   ratio, ci_low, ci_high.
validate_variance_split <- function(changes_matrix,
                                    regime_table,
                                    alpha = 0.01,
                                    n_boot = 1000L,
                                    seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  is_C <- regime_table$regime == "C"

  vars <- colnames(changes_matrix)
  if (is.null(vars)) vars <- paste0("V", seq_len(ncol(changes_matrix)))

  purrr::map_dfr(seq_along(vars), function(j) {
    x   <- changes_matrix[, j]
    xC  <- x[is_C]
    xNC <- x[!is_C]
    xC  <- xC[!is.na(xC)]
    xNC <- xNC[!is.na(xNC)]

    v_C  <- var(xC)
    v_NC <- var(xNC)

    boot <- replicate(n_boot, {
      var(sample(xC,  replace = TRUE)) /
      var(sample(xNC, replace = TRUE))
    })
    ci <- stats::quantile(boot, probs = c(alpha / 2, 1 - alpha / 2), na.rm = TRUE)

    tibble::tibble(
      var     = vars[j],
      n_C     = length(xC),
      n_NC    = length(xNC),
      var_C   = v_C,
      var_NC  = v_NC,
      ratio   = v_C / v_NC,
      ci_low  = unname(ci[1]),
      ci_high = unname(ci[2])
    )
  })
}

#' Extract the impact column and shock series via Rigobon-Sack heteroskedasticity
#'
#' Implements Rigobon & Sack (2003, QJE) §III in a daily SVAR with no lags:
#' Sigma_C - Sigma_NC = (sigma2_1,C - sigma2_1,NC) b_1 b_1' under the
#' assumption that only the policy shock variance differs across regimes.
#' b_1 is recovered from the leading eigenvector of dSigma. The shock series
#' on Copom days follows the Mertens-Ravn (2013) GLS projection.
#'
#' @param changes_matrix Numeric matrix N_pairs x k_d of Wed-to-Thu changes
#'   (no NAs; caller drops incomplete rows beforehand).
#' @param regime_table Output of build_daily_regimes() aligned to changes_matrix.
#' @param mp_var_idx Column index of the policy variable. Sign of b_1 is
#'   flipped so b_1[mp_var_idx] >= 0 (a contractionary shock raises DI).
#'
#' @return List with:
#'   b_1 (impact column, k_d-vector);
#'   lambda_all (eigenvalues of dSigma);
#'   eigenvalue_gap (lambda_1 / |lambda_2|);
#'   rank1_share (|lambda_1| / sum(|lambda_j|));
#'   psd_min_eig (min eigenvalue, ~0 expected);
#'   shocks_C (extracted shock on Copom Wed-Thu pairs);
#'   shocks_C_dates (the Thu dates of the Copom pairs);
#'   sigma_C, sigma_NC, dSigma; n_C, n_NC; mp_var_idx.
extract_shock_rigobon_sack <- function(changes_matrix,
                                       regime_table,
                                       mp_var_idx) {
  complete <- stats::complete.cases(changes_matrix)
  X        <- changes_matrix[complete, , drop = FALSE]
  reg      <- regime_table[complete, ]
  is_C     <- reg$regime == "C"

  X_C  <- X[is_C,  , drop = FALSE]
  X_NC <- X[!is_C, , drop = FALSE]

  # Demean within each regime: estimates capture the second-moment shift
  # and not differences in unconditional means.
  X_C  <- sweep(X_C,  2, colMeans(X_C))
  X_NC <- sweep(X_NC, 2, colMeans(X_NC))

  Sigma_C  <- crossprod(X_C)  / (nrow(X_C)  - 1L)
  Sigma_NC <- crossprod(X_NC) / (nrow(X_NC) - 1L)
  dSigma   <- Sigma_C - Sigma_NC

  eig      <- eigen(dSigma, symmetric = TRUE)
  lambda_1 <- eig$values[1]
  v_1      <- eig$vectors[, 1]

  # eig$values are returned in decreasing order: lambda_1 is the most positive.
  # The rank-1 PSD assumption (only policy variance shifts) requires the
  # smallest eigenvalue to be near zero relative to lambda_1. A large negative
  # eigenvalue indicates that some non-policy shock has *higher* variance in
  # NC than in C, violating identification.
  lambda_min <- min(eig$values)
  if (lambda_1 <= 0) {
    warning("dSigma has no positive eigenvalue: A1 (Var_C > Var_NC for the policy shock) is violated.")
  } else if (abs(lambda_min) > 0.3 * lambda_1) {
    warning(sprintf(
      "Large negative eigenvalue (%.3g) relative to leading eigenvalue (%.3g): the rank-1 PSD assumption is suspect.",
      lambda_min, lambda_1
    ))
  }

  b_1 <- sqrt(abs(lambda_1)) * v_1
  # Sign normalization. b_1[mp_var_idx] == 0 means the policy variable does
  # not load on the leading eigenvector at all -- A1 is then violated and
  # the sign is undefined; fall through with the eigen-decomposition's sign.
  if (b_1[mp_var_idx] < 0) b_1 <- -b_1

  # GLS projection of u_t onto b_1 in regime C (Mertens-Ravn 2013, §II.B).
  Sigma_C_inv <- solve(Sigma_C)
  weight      <- as.numeric(t(b_1) %*% Sigma_C_inv %*% b_1)
  shocks_C    <- as.numeric(X_C %*% Sigma_C_inv %*% b_1) / weight

  list(
    b_1            = b_1,
    lambda_all     = eig$values,
    eigenvalue_gap = abs(eig$values[1]) / abs(eig$values[2]),
    rank1_share    = abs(eig$values[1]) / sum(abs(eig$values)),
    psd_min_eig    = min(eig$values),
    shocks_C       = shocks_C,
    shocks_C_dates = reg$thu_date[is_C],
    sigma_C        = Sigma_C,
    sigma_NC       = Sigma_NC,
    dSigma         = dSigma,
    n_C            = nrow(X_C),
    n_NC           = nrow(X_NC),
    mp_var_idx     = mp_var_idx
  )
}

#' Aggregate the daily shock series to a monthly instrument
#'
#' Sums the extracted shocks within each calendar month. Months without any
#' Copom announcement receive z_het = 0 (consistent with z_bruto in
#' script/instrument.R).
#'
#' @param shocks Numeric vector of daily shocks.
#' @param shock_dates Date vector aligned to shocks (the Thu of each pair).
#' @param month_range Optional length-2 Date vector (start, end) bounding the
#'   monthly grid; defaults to the range of shock_dates.
#'
#' @return Tibble with columns month (first day of month, Date) and z_het.
aggregate_shock_to_monthly <- function(shocks,
                                       shock_dates,
                                       month_range = NULL) {
  if (is.null(month_range)) {
    month_range <- range(shock_dates)
  }

  start <- lubridate::floor_date(month_range[1], "month")
  end   <- lubridate::floor_date(month_range[2], "month")
  grid  <- tibble::tibble(month = seq(start, end, by = "month"))

  observed <- tibble::tibble(date = shock_dates, shock = shocks) |>
    dplyr::mutate(month = lubridate::floor_date(date, "month")) |>
    dplyr::group_by(month) |>
    dplyr::summarise(z_het = sum(shock, na.rm = TRUE), .groups = "drop")

  grid |>
    dplyr::left_join(observed, by = "month") |>
    dplyr::mutate(z_het = tidyr::replace_na(z_het, 0))
}

#' Classify A2 (non-policy homoskedasticity) verdict from a variance-split table
#'
#' Adds an `a2_status` column to the output of `validate_variance_split`:
#' "policy"   for the policy variable (A1, not A2);
#' "violated" if the bootstrap CI for var_C / var_NC excludes 1 from either side;
#' "pass"     otherwise.
#'
#' Identification by heteroskedasticity (Rigobon-Sack 2003) requires CIs that
#' include 1 for every non-policy variable. Violation by the high side ("upper")
#' indicates that some non-policy shock has higher variance on Copom days too,
#' so the leading eigenvector of dSigma is contaminated by a second shock.
#'
#' @param val_tbl Tibble returned by `validate_variance_split`.
#' @param mp_var  Name of the policy variable (matched against val_tbl$var).
#'
#' @return val_tbl with two extra columns: a2_status, a2_side
#'   (a2_side: NA for policy/pass; "upper" if ci_low > 1; "lower" if ci_high < 1).
classify_a2_verdict <- function(val_tbl, mp_var) {
  val_tbl |>
    dplyr::mutate(
      a2_status = dplyr::case_when(
        var == mp_var            ~ "policy",
        ci_low > 1 | ci_high < 1 ~ "violated",
        TRUE                     ~ "pass"
      ),
      a2_side = dplyr::case_when(
        a2_status != "violated" ~ NA_character_,
        ci_low > 1              ~ "upper",
        ci_high < 1             ~ "lower"
      )
    )
}

#' Build the heteroskedasticity-identified monthly instrument for a SVAR block
#'
#' Wraps `extract_shock_rigobon_sack`, the daily Jarocinski-Karadi sign filter,
#' and `aggregate_shock_to_monthly`. Used to run the same identification on the
#' 4-variable production block (DI_3m, DI_2y, IBOV, BRL) and on the 3-variable
#' robustness block (DI_3m, IBOV, BRL) without duplicating pipeline code.
#'
#' Requires an "IBOV" column in `changes_matrix` because the JK sign filter
#' compares sign(daily shock) to sign(IBOV daily change) on Copom days.
#'
#' @param changes_matrix Numeric matrix N_pairs x k_d of Wed-to-Thu changes.
#' @param regime_table   Output of `build_daily_regimes` aligned to changes.
#' @param mp_var         Name of the policy variable (column of changes_matrix).
#' @param month_range    Length-2 Date vector bounding the monthly grid.
#'
#' @return List with z_het and z_het_jk (tibbles of month and z), ext (raw
#'   `extract_shock_rigobon_sack` result), jk_mask (logical, daily on Copom
#'   pairs), n_jk_kept, and mp_var_idx.
build_het_instrument <- function(changes_matrix,
                                 regime_table,
                                 mp_var,
                                 month_range) {
  if (!"IBOV" %in% colnames(changes_matrix)) {
    stop("changes_matrix must contain an 'IBOV' column for the JK sign filter")
  }
  mp_idx <- which(colnames(changes_matrix) == mp_var)
  if (length(mp_idx) != 1L) {
    stop("Policy variable '", mp_var, "' not found in changes_matrix columns")
  }

  ext <- extract_shock_rigobon_sack(changes_matrix, regime_table,
                                    mp_var_idx = mp_idx)

  complete      <- stats::complete.cases(changes_matrix)
  reg_complete  <- regime_table[complete, ]
  ibov_complete <- changes_matrix[complete, "IBOV"]
  ibov_C        <- ibov_complete[reg_complete$regime == "C"]

  jk_mask <- sign(ext$shocks_C) != 0 & sign(ibov_C) != 0 &
             sign(ext$shocks_C) != sign(ibov_C)

  z_het <- aggregate_shock_to_monthly(
    ext$shocks_C, ext$shocks_C_dates, month_range = month_range
  )
  z_het_jk <- aggregate_shock_to_monthly(
    ext$shocks_C * jk_mask, ext$shocks_C_dates, month_range = month_range
  ) |> dplyr::rename(z_het_jk = z_het)

  list(
    z_het      = z_het,
    z_het_jk   = z_het_jk,
    ext        = ext,
    jk_mask    = jk_mask,
    n_jk_kept  = sum(jk_mask),
    mp_var_idx = mp_idx
  )
}
