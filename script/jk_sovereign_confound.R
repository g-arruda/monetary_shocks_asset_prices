# ===================================================================
# Does the Jarocinski-Karadi sign filter select SOVEREIGN RISK
# surprises instead of monetary policy shocks?
#
# Top item of the council review of 2026-07-31
# (relatorio/council_2026-07-31.md). The logic, in one line: the JK
# rule discards the BENIGN confound (central-bank information effect:
# rates up, stocks up) but a domestic fiscal/sovereign surprise has
# rates up, stocks DOWN, FX up — exactly the pattern the filter
# RETAINS as "policy". The placebo battery cannot discharge this,
# because a domestic fiscal shock also should not move the S&P 500.
#
# Four tests, all before or beside the DFM:
#
#  A. The decisive daily regression. Wed->Thu change in each daily
#     sovereign-risk proxy regressed on the surprise, over the 62
#     retained Copom days, over all 95 Copom days, and — the control
#     that gives the coefficient meaning — over the ~500 non-Copom
#     Thursdays. Contamination requires the retained days to carry
#     MORE risk news per unit of surprise than an ordinary day, which
#     is the interaction test, not the level of the coefficient.
#
#  B. Three-way classification. JK is two-way on sign(e_di_bs) vs
#     sign(e_ibov_bs). The third way uses FX and has the same form:
#     a tightening APPRECIATES the BRL (UIP), a sovereign surprise
#     DEPRECIATES it. Splits the 62 into policy / sovereign.
#
#  C. Risk-orthogonalized instrument. Residualize the surprise on the
#     contemporaneous risk changes. A LOWER BOUND: policy legitimately
#     moves sovereign spreads, so this over-strips.
#
#  D. Dated table of the 95 Copom days for the narrative audit.
#
# Nothing in R/instrument/, R/modeling/ or script/instrument.R is
# modified. The three-way variants are built IN MEMORY. Promoting one
# of them to production is a separate author decision.
#
# DATA GAP, DECLARED: there is no daily 5y CDS in this repository and
# no free programmatic source with 2013-2025 history (Ipeadata dropped
# EMBI+ in 2024-07 and never carried CDS; WorldGovernmentBonds has no
# CSV/API; MacroMicro publishes weekly; cbonds is paid). The only
# daily source is the Investing.com historical page — the same page
# data/investing/cds5y.csv (monthly) came from, and it needs a browser
# export. If data/investing/cds5y_daily.csv ever appears, this script
# picks it up automatically as a fourth risk proxy. EMBI+ Brasil daily
# is the primary test either way: it covers 95/95 Copom Thursdays and
# 94/95 preceding Wednesdays.
#
# Outputs: output/instrument/jk_sovereign_confound.csv
#          output/instrument/jk_sovereign_confound.md
#          output/instrument/jk_sovereign_days.csv
#          output/instrument/jk_sovereign_irf_overlay.pdf
# ===================================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tidyr)
  library(tibble)
  library(lubridate)
  library(purrr)
  library(ggplot2)
  library(patchwork)
  library(sandwich)
})

source("R/instrument/di_surprise.R")
source("R/instrument/build_variants.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")   # norm_value_for, run_stage2_cell,
                                          # plot_overlay_cells, md_table

set.seed(20260731)


# ---- Config --------------------------------------------------------

# Instrument construction: production values (script/instrument.R)
SAMPLE_START <- as.Date("2013-01-01")
SAMPLE_END   <- as.Date("2025-12-31")
LOAD_START   <- as.Date("2012-06-01")
TARGET_BD    <- 126
AGG_SCHEME   <- "sum"

# Estimation: production spec (script/irf_coherence_check.R)
R_FACTORS <- 7L
Q_DYNAMIC <- 6L
P_LAGS    <- 6L
MP_VAR    <- "yield_6m"
HORIZON   <- 48L
N_BOOT    <- 800L
BOOT_SEED <- 123L
SHOCK_BPS <- 50
CI_LEVELS <- c(0.68, 0.90)

SAMPLES <- list(
  full      = as.Date(c("2013-01-01", "2025-12-31")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-31"))
)

NBOOT_P <- 2000L   # wild-bootstrap draws for the daily regression p-values

DATA_PATH  <- "data/processed/data_log_deseasonalized.csv"
INST_PATH  <- "data/processed/instrumentos_mensais.csv"
EMBI_PATH  <- "data/banco_central_rep_dominicana/embi_brasil.csv"
CDS_D_PATH <- "data/investing/cds5y_daily.csv"   # optional, see header
EVENT_PATH <- "data/processed/copom_event_diagnostics.csv"
OUT_DIR    <- "output/instrument"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

cat("=== JK sovereign-risk confound ===\n\n")


# ===================================================================
# 1. Daily event panel
# ===================================================================
# Rebuilt rather than read from copom_event_diagnostics.csv, because
# that file carries neither `month` nor the pre-event predictors, and
# tests B and C need both.

cat("[1] rebuilding the daily event panel\n")

di_panel <- load_di_panel("data/di.csv", from = LOAD_START, to = SAMPLE_END + 30)

ibov_daily <- read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ibov = as.numeric(ibov)) |>
  filter(!is.na(ibov))

ext_daily <- read_csv("data/investing/external_factors_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), sp500 = as.numeric(sp500),
            vix = as.numeric(vix), brent = as.numeric(brent))

brl_daily <- read_csv("data/processed/brl_usd_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), brl = as.numeric(brl)) |>
  filter(!is.na(brl))

focus_daily <- read_csv("data/processed/focus_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date),
            focus_ipca12m  = as.numeric(focus_ipca12m),
            focus_selic_ny = as.numeric(focus_selic_ny))

dgs2_daily <- read_csv("data/fred_dgs2.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ust2y = as.numeric(ust2y))

copom_wed <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)

built <- build_instrument_variants(
  inputs = list(di_panel = di_panel, ibov_daily = ibov_daily,
                ext_daily = ext_daily, brl_daily = brl_daily,
                focus_daily = focus_daily, dgs2_daily = dgs2_daily,
                copom_wed = copom_wed, fomc_dates = as.Date(character(0))),
  target_bd = TARGET_BD, agg = AGG_SCHEME,
  sample_start = SAMPLE_START, sample_end = SAMPLE_END
)

valid <- built$daily

cat(sprintf("    %d valid Thursdays | %d Copom | jk_bs %d | jk %d | jk_raw %d | jk_us %d\n",
            built$diag$n_valid, built$diag$n_copom, built$diag$n_jk_bs,
            built$diag$n_jk, built$diag$n_jk_raw, built$diag$n_jk_us))

stopifnot(built$diag$n_copom == 95L, built$diag$n_jk_bs == 62L)

# Self-test: the rebuild must match the persisted event file exactly.
if (file.exists(EVENT_PATH)) {
  ev <- read_csv(EVENT_PATH, show_col_types = FALSE) |> mutate(date = as.Date(date))
  shared <- intersect(names(ev), names(valid))
  jn <- inner_join(ev |> select(all_of(shared)),
                   valid |> select(all_of(shared)), by = "date",
                   suffix = c(".disk", ".new"))
  num_cols <- setdiff(shared[vapply(ev[shared], is.numeric, logical(1))], "date")
  maxdiff <- max(vapply(num_cols, function(cc)
    max(abs(jn[[paste0(cc, ".disk")]] - jn[[paste0(cc, ".new")]]), na.rm = TRUE),
    numeric(1)))
  # Compare values, not attributes: the masks built from sign(residuals(lm))
  # carry a `names` attribute that the round-trip through CSV drops, so
  # identical() would fail on three columns whose values agree exactly.
  lgl_cols <- setdiff(shared[vapply(ev[shared], is.logical, logical(1))], "date")
  lgl_ok <- all(vapply(lgl_cols, function(cc)
    all(unname(jn[[paste0(cc, ".disk")]]) == unname(jn[[paste0(cc, ".new")]])),
    logical(1)))
  cat(sprintf("    self-test vs %s: n=%d, max |diff| = %.3g, masks identical = %s\n",
              basename(EVENT_PATH), nrow(jn), maxdiff, lgl_ok))
  stopifnot(nrow(jn) == nrow(ev), maxdiff < 1e-8, lgl_ok)
} else {
  cat("    (persisted event file absent — self-test skipped)\n")
}


# ===================================================================
# 2. Wed -> Thu changes in the daily risk proxies
# ===================================================================
# Explicit Wednesday lookup (`date - 1`), never dplyr::lag(): the EMBI
# follows the US calendar and a lag() would silently span a longer
# window whenever the US market was shut on the Wednesday.

cat("\n[2] Wed->Thu risk changes\n")

#' Exact-date lookup of `col` in a daily tibble.
on_date <- function(want, daily, col) daily[[col]][match(want, daily$date)]

#' Wed->Thu change of a daily series, optionally in logs, times `scale`.
wed_thu <- function(thu, daily, col, scale = 1, log_scale = FALSE) {
  a <- on_date(thu - 1, daily, col)
  b <- on_date(thu,     daily, col)
  if (log_scale) scale * (log(b) - log(a)) else scale * (b - a)
}

embi_daily <- read_csv(EMBI_PATH, show_col_types = FALSE) |>
  transmute(date = dmy(date), embi = as.numeric(embi_perc)) |>
  filter(!is.na(date), !is.na(embi)) |>
  arrange(date)

# DI curve slope (504bd - 63bd), same construction as build_variants.R:209-216.
# Hard-wired vertices, so it stays predetermined-free of TARGET_BD.
di_slope_daily <- di_panel |>
  group_by(date) |>
  summarise(slope = 100 * (close_rate[which.min(abs(bdays - 504))] -
                           close_rate[which.min(abs(bdays - 63))]),
            .groups = "drop") |>
  arrange(date)

# Long end of the DI curve (~10y) as an additional daily risk proxy.
di_long_daily <- di_panel |>
  group_by(date) |>
  summarise(long = 100 * close_rate[which.min(abs(bdays - 2520))], .groups = "drop") |>
  arrange(date)

thu <- valid$date

valid$d_embi_bp   <- wed_thu(thu, embi_daily, "embi", scale = 100)   # p.p. -> bp
valid$d_lbrl      <- wed_thu(thu, brl_daily,  "brl",  scale = 100, log_scale = TRUE)
valid$d_slope_bp  <- wed_thu(thu, di_slope_daily, "slope", scale = 100)
valid$d_di10y_bp  <- wed_thu(thu, di_long_daily,  "long",  scale = 100)

# Alignment diagnostic. The EMBI is a JP Morgan panel republished by the
# Dominican central bank, so a same-day close is not guaranteed a priori
# and the whole reading of test A depends on it. Correlating the daily
# EMBI change against market moves at t, t-1 and t+1 settles it: if the
# file were published with a one-day lag, the t-1 column would dominate.
align_src <- embi_daily |>
  filter(date >= SAMPLE_START, date <= SAMPLE_END) |>
  mutate(d_embi = embi - lag(embi)) |>
  left_join(brl_daily, by = "date") |>
  left_join(ext_daily, by = "date") |>
  left_join(ibov_daily, by = "date") |>
  mutate(r_brl = 100 * (log(brl) - log(lag(brl))),
         r_sp500 = 100 * (log(sp500) - log(lag(sp500))),
         d_vix = vix - lag(vix),
         r_ibov = 100 * (log(ibov) - log(lag(ibov)))) |>
  filter(!is.na(d_embi))

align_tbl <- map_dfr(c("r_brl", "r_sp500", "d_vix", "r_ibov"), function(v) {
  x <- align_src[[v]]
  tibble(serie = v,
         cor_t   = cor(align_src$d_embi, x, use = "pairwise"),
         cor_tm1 = cor(align_src$d_embi, lag(x), use = "pairwise"),
         cor_tp1 = cor(align_src$d_embi, lead(x), use = "pairwise"))
})
cat("    alinhamento do EMBI (cor de d_embi_t com o mercado em t / t-1 / t+1):\n")
for (i in seq_len(nrow(align_tbl))) {
  cat(sprintf("      %-8s t = %+.3f | t-1 = %+.3f | t+1 = %+.3f\n",
              align_tbl$serie[i], align_tbl$cor_t[i],
              align_tbl$cor_tm1[i], align_tbl$cor_tp1[i]))
}
embi_same_day <- with(align_tbl, all(abs(cor_t) > abs(cor_tm1)))
cat(sprintf("      -> arquivo alinhado no MESMO dia: %s\n", embi_same_day))

# Given same-day alignment, the Thu->Fri window below is NOT a corrected
# alignment: it is a genuine NEXT-DAY window, i.e. the delayed risk
# response to the surprise rather than risk news inside the event window.
next_sess <- function(d, daily) {
  idx <- findInterval(as.numeric(d), as.numeric(daily$date)) + 1L
  ifelse(idx <= nrow(daily), daily$date[pmin(idx, nrow(daily))], NA)
}
thu_next <- as.Date(next_sess(thu, embi_daily), origin = "1970-01-01")
valid$d_embi_bp_lag1 <- 100 * (on_date(thu_next, embi_daily, "embi") -
                               on_date(thu,      embi_daily, "embi"))

RISK_VARS <- c(d_embi_bp = "EMBI+ (bp, Qua->Qui)",
               d_embi_bp_lag1 = "EMBI+ (bp, Qui->Sex, janela do dia SEGUINTE)",
               d_lbrl = "BRL/USD (log x100, + = depreciacao)",
               d_slope_bp = "Slope DI 504-63bd (bp)",
               d_di10y_bp = "DI ~10a (bp)")

has_cds <- file.exists(CDS_D_PATH)
if (has_cds) {
  cds_daily <- read_csv(CDS_D_PATH, show_col_types = FALSE,
                        locale = locale(decimal_mark = ",", grouping_mark = ".")) |>
    janitor::clean_names() |>
    transmute(date = dmy(gsub("\\.", "/", data)), cds = as.numeric(ultimo)) |>
    filter(!is.na(date), !is.na(cds)) |> arrange(date)
  valid$d_cds_bp <- wed_thu(thu, cds_daily, "cds")
  RISK_VARS <- c(RISK_VARS, d_cds_bp = "CDS 5a (bp)")
  cat("    daily CDS found and loaded\n")
} else {
  cat("    daily CDS NOT available — see the header note; EMBI is the primary proxy\n")
}

# Coverage and data quality
cop <- valid$copom_day
n_embi_cop <- sum(!is.na(valid$d_embi_bp[cop]))
nz <- abs(valid$d_embi_bp[!is.na(valid$d_embi_bp)])
cat(sprintf("    EMBI: %d/%d Copom pairs | menor |delta| nao-nulo = %.3f bp | %.1f%% exatamente zero\n",
            n_embi_cop, sum(cop), min(nz[nz > 0]), 100 * mean(nz == 0)))
cat(sprintf("    EMBI cauda 2024-25: %d obs, sd(delta) = %.2f bp\n",
            sum(embi_daily$date >= as.Date("2024-01-01")),
            sd(valid$d_embi_bp[valid$date >= as.Date("2024-01-01")], na.rm = TRUE)))
stopifnot(n_embi_cop >= 94L)

quality_tbl <- tibble(
  proxy   = names(RISK_VARS),
  rotulo  = unname(RISK_VARS),
  n_copom = vapply(names(RISK_VARS), function(v) sum(!is.na(valid[[v]][cop])), integer(1)),
  n_valid = vapply(names(RISK_VARS), function(v) sum(!is.na(valid[[v]])), integer(1)),
  sd      = vapply(names(RISK_VARS), function(v) sd(valid[[v]], na.rm = TRUE), numeric(1))
)


# ===================================================================
# 3. TEST A — the decisive daily regression
# ===================================================================

cat("\n[3] Test A: daily regressions\n")

#' HC1 t-test on one coefficient, with a wild-bootstrap p-value under
#' the restricted null that the coefficient is zero.
#'
#' Generalizes `robust_joint_test()` (diagnostics/01_exogeneidade.R) from
#' "all slopes zero" to a single coefficient: the bootstrap DGP is the
#' RESTRICTED fit (target dropped) plus Rademacher-multiplied residuals,
#' which is the design that imposes H0 here. The wild multiplier is
#' needed because the surprise is zero-censored by the JK mask and the
#' daily heteroskedasticity is severe.
wild_coef_test <- function(fml, data, target, nboot = NBOOT_P) {
  mf <- model.frame(fml, data = data, na.action = na.omit)
  n  <- nrow(mf)
  fit <- lm(fml, data = mf)
  if (!(target %in% names(coef(fit))) || is.na(coef(fit)[target]) || n < 12) {
    return(tibble(n = n, coef = NA_real_, se_hc1 = NA_real_, t = NA_real_,
                  p_asym = NA_real_, p_boot = NA_real_, r2 = NA_real_))
  }
  b   <- unname(coef(fit)[target])
  V   <- sandwich::vcovHC(fit, type = "HC1")
  se  <- sqrt(V[target, target])
  tst <- b / se

  fml_r <- update(fml, paste(". ~ . -", target))
  fit_r <- lm(fml_r, data = mf)
  fitted_r <- fitted(fit_r); resid_r <- residuals(fit_r)
  yname <- all.vars(fml)[1]

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

  tibble(n = n, coef = b, se_hc1 = se, t = tst,
         p_asym = 2 * pt(abs(tst), df = n - length(coef(fit)), lower.tail = FALSE),
         p_boot = mean(abs(tb) >= abs(tst), na.rm = TRUE),
         r2 = summary(fit)$r.squared)
}

# Day sets. `x` is the surprise measure of the matching purification —
# BS-purified for the BS-mask sets, raw for the raw mask, contemporaneous
# for the contemporaneous masks.
DAY_SETS <- list(
  list(tag = "jk_bs (producao)",   x = "e_di_bs", sel = valid$jk_monetary_bs),
  list(tag = "copom (todos)",      x = "e_di_bs", sel = valid$copom_day),
  list(tag = "copom rejeitados",   x = "e_di_bs", sel = valid$copom_day & !valid$jk_monetary_bs),
  list(tag = "nao-copom (controle)", x = "e_di_bs", sel = !valid$copom_day),
  list(tag = "jk (contemporaneo)", x = "e_di",    sel = valid$jk_monetary),
  list(tag = "jk_raw",             x = "delta_di", sel = valid$jk_monetary_raw),
  list(tag = "jk_us",              x = "e_di_us",  sel = valid$jk_monetary_us)
)

rowsA <- list()
for (rv in names(RISK_VARS)) {
  for (ds in DAY_SETS) {
    d <- valid[ds$sel, c(rv, ds$x)]
    names(d) <- c("y", "x")
    res <- wild_coef_test(y ~ x, d, "x")
    rowsA[[length(rowsA) + 1]] <- bind_cols(
      tibble(teste = "A_nivel", proxy = rv, conjunto = ds$tag, x = ds$x), res)
  }
}

# The statistic that decides: does the retained day carry MORE risk news
# per unit of surprise than an ordinary Thursday?
for (rv in names(RISK_VARS)) {
  d <- tibble(y = valid[[rv]], x = valid$e_di_bs,
              d_jk = as.numeric(valid$jk_monetary_bs))
  res <- wild_coef_test(y ~ x * d_jk, d, "x:d_jk")
  rowsA[[length(rowsA) + 1]] <- bind_cols(
    tibble(teste = "A_interacao", proxy = rv,
           conjunto = "todas as quintas | x:1(jk_bs)", x = "e_di_bs"), res)
}

testA <- bind_rows(rowsA)

int_tbl <- testA |> filter(teste == "A_interacao")
cat("    interacao x:1(jk_bs) — a estatistica que decide\n")
for (i in seq_len(nrow(int_tbl))) {
  cat(sprintf("      %-16s coef = %8.4f  t = %6.2f  p_boot = %.3f\n",
              int_tbl$proxy[i], int_tbl$coef[i], int_tbl$t[i], int_tbl$p_boot[i]))
}

# Ex-ante reading rule, fixed before the numbers existed (same discipline
# as the vertex sweep, which fixed its 2.00 threshold ex ante).
embi_int <- int_tbl |> filter(proxy == "d_embi_bp")
verdict_A <- if (isTRUE(embi_int$coef > 0 && embi_int$p_boot < 0.10)) {
  "CONTAMINACAO CONFIRMADA"
} else {
  lvl <- testA |> filter(teste == "A_nivel", proxy == "d_embi_bp")
  a62 <- lvl |> filter(conjunto == "jk_bs (producao)")
  ctl <- lvl |> filter(conjunto == "nao-copom (controle)")
  if (isTRUE(a62$coef > 0 && a62$p_boot < 0.10 && ctl$p_boot >= 0.10)) {
    "SINAL FRACO DE CONTAMINACAO"
  } else {
    "CONFOUND NAO DETECTADO NA FREQUENCIA DIARIA"
  }
}
cat(sprintf("    >>> veredito A: %s\n", verdict_A))


# ===================================================================
# 4. TEST B — three-way classification
# ===================================================================
# Policy:    tightening APPRECIATES the BRL (UIP) -> signs differ
# Sovereign: fiscal surprise DEPRECIATES the BRL  -> signs agree
# Information: already removed by the original JK filter.
#
# The FX/EMBI legs are purified on the SAME Bauer-Swanson pre-event RHS
# as e_di_bs / e_ibov_bs (build_variants.R:308-311), so the added leg of
# the mask stays predetermined-consistent.

cat("\n[4] Test B: three-way classification\n")

bs_rhs <- ~ trend + pre_ibov + pre_sp500 + pre_vix + pre_brent + pre_brl +
            pre_slope + pre_focus_ipca + pre_focus_selic

valid$e_brl_bs  <- as.numeric(residuals(
  lm(update(bs_rhs, d_lbrl ~ .),    data = valid, na.action = na.exclude)))
valid$e_embi_bs <- as.numeric(residuals(
  lm(update(bs_rhs, d_embi_bp ~ .), data = valid, na.action = na.exclude)))

same_sign <- function(a, b) !is.na(a) & !is.na(b) & sign(a) != 0 & sign(b) != 0 & sign(a) == sign(b)
diff_sign <- function(a, b) !is.na(a) & !is.na(b) & sign(a) != 0 & sign(b) != 0 & sign(a) != sign(b)

valid$sov_fx   <- valid$jk_monetary_bs & same_sign(valid$e_di_bs, valid$e_brl_bs)
valid$pol_fx   <- valid$jk_monetary_bs & diff_sign(valid$e_di_bs, valid$e_brl_bs)
valid$sov_embi <- valid$jk_monetary_bs & same_sign(valid$e_di_bs, valid$e_embi_bs)
valid$pol_embi <- valid$jk_monetary_bs & diff_sign(valid$e_di_bs, valid$e_embi_bs)

n_unclass_fx   <- sum(valid$jk_monetary_bs) - sum(valid$sov_fx)   - sum(valid$pol_fx)
n_unclass_embi <- sum(valid$jk_monetary_bs) - sum(valid$sov_embi) - sum(valid$pol_embi)

cat(sprintf("    regra FX  : politica %d | soberano %d | nao classificado %d\n",
            sum(valid$pol_fx), sum(valid$sov_fx), n_unclass_fx))
cat(sprintf("    regra EMBI: politica %d | soberano %d | nao classificado %d\n",
            sum(valid$pol_embi), sum(valid$sov_embi), n_unclass_embi))

agree_tbl <- valid |>
  filter(jk_monetary_bs) |>
  mutate(fx   = ifelse(pol_fx, "politica", ifelse(sov_fx, "soberano", "n/c")),
         embi = ifelse(pol_embi, "politica", ifelse(sov_embi, "soberano", "n/c"))) |>
  count(fx, embi) |>
  pivot_wider(names_from = embi, values_from = n, values_fill = 0)


# ===================================================================
# 5. TEST C — risk-orthogonalized instrument
# ===================================================================

cat("\n[5] Test C: risk-orthogonalized instrument\n")

risk_rhs <- if (has_cds) ~ d_embi_bp + d_lbrl + d_cds_bp else ~ d_embi_bp + d_lbrl
fit_nr <- lm(update(risk_rhs, e_di_bs ~ .), data = valid, na.action = na.exclude)
valid$e_di_bs_norisk <- as.numeric(residuals(fit_nr))
cat(sprintf("    R2 da regressao de risco contemporaneo: %.4f (n = %d)\n",
            summary(fit_nr)$r.squared, nobs(fit_nr)))


# ===================================================================
# 6. Monthly aggregation of the in-memory variants
# ===================================================================

monthly_grid <- tibble(month = seq(floor_date(SAMPLE_START, "month"),
                                   floor_date(SAMPLE_END, "month"), by = "month"))

mk_z <- function(value_col, mask) {
  monthly_grid |>
    left_join(agg_monthly_sum(valid, value_col, mask, monthly_grid), by = "month") |>
    mutate(shock = replace_na(shock, 0)) |>
    pull(shock)
}

inst_wide <- monthly_grid |>
  mutate(
    z_jk_bs_purif   = mk_z("e_di_bs", valid$jk_monetary_bs),
    z_jk3_policy    = mk_z("e_di_bs", valid$pol_fx),
    z_jk3_sov       = mk_z("e_di_bs", valid$sov_fx),
    z_jk3_policy_em = mk_z("e_di_bs", valid$pol_embi),
    z_jk3_sov_em    = mk_z("e_di_bs", valid$sov_embi),
    z_jk_bs_norisk  = mk_z("e_di_bs_norisk", valid$jk_monetary_bs)
  )

# Self-test: the recomputed production column must equal the one on disk.
prod_panel <- read_csv(INST_PATH, show_col_types = FALSE) |> mutate(month = as.Date(month))
chk <- inner_join(inst_wide |> select(month, mine = z_jk_bs_purif),
                  prod_panel |> select(month, disk = z_jk_bs_purif), by = "month")
cat(sprintf("\n[6] z_jk_bs_purif reconstruido vs disco: n = %d, max |diff| = %.3g\n",
            nrow(chk), max(abs(chk$mine - chk$disk))))
stopifnot(nrow(chk) == nrow(prod_panel), max(abs(chk$mine - chk$disk)) < 1e-10)

Z_VARIANTS <- c("z_jk_bs_purif", "z_jk3_policy", "z_jk3_sov",
                "z_jk3_policy_em", "z_jk3_sov_em", "z_jk_bs_norisk")


# ===================================================================
# 7. xi_mp of each variant
# ===================================================================

cat("\n[7] xi_mp por variante e janela\n")

panel_raw <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
dates     <- as.Date(panel_raw$ref.date)
data_mat  <- panel_raw |> select(-ref.date) |> as.matrix()
var_names <- colnames(data_mat)
tcode     <- infer_tcode_from_varnames(var_names)
mp_idx    <- match(MP_VAR, var_names)
stopifnot(!is.na(mp_idx))

rowsX <- list()
for (sn in names(SAMPLES)) {
  win <- SAMPLES[[sn]]
  inw <- dates >= win[1] & dates <= win[2]
  dsub <- data_mat[inw, , drop = FALSE]; tsub <- dates[inw]

  dfm <- estimate_dfm(dsub, r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
                      dates = tsub, apply_kilian = FALSE)

  for (v in Z_VARIANTS) {
    idf <- data.frame(month = inst_wide$month, shock = inst_wide[[v]])
    idf <- idf[!is.na(idf$shock), ]
    dg  <- diagnose_instrument_in_factor_space(dfm, idf, tsub, P_LAGS, mp_idx)
    n_nz <- sum(inst_wide[[v]][inst_wide$month >= win[1] & inst_wide$month <= win[2]] != 0)
    rowsX[[length(rowsX) + 1]] <- tibble(
      teste = "xi_mp", amostra = sn, instrumento = v,
      meses_nao_nulos = n_nz, xi_mp = dg$wald_mp,
      wald_conjunta = dg$wald_joint, f_factor = dg$f_factor)
    cat(sprintf("    %-9s %-16s meses!=0 = %3d  xi_mp = %7.3f\n", sn, v, n_nz, dg$wald_mp))
  }
}
xi_tbl <- bind_rows(rowsX)

# Cross-check against the strength ruler of record.
xi_prod <- xi_tbl |> filter(instrumento == "z_jk_bs_purif")
cat(sprintf("    check: producao full %.2f (registro 10.43) | pre_covid %.2f (registro 12.22)\n",
            xi_prod$xi_mp[xi_prod$amostra == "full"],
            xi_prod$xi_mp[xi_prod$amostra == "pre_covid"]))


# ===================================================================
# 8. IRFs with the full production bootstrap
# ===================================================================

IRF_VARIANTS <- c("z_jk_bs_purif", "z_jk3_policy", "z_jk3_sov", "z_jk_bs_norisk")
HEADLINE <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd", "embi_perc",
              "cds_5y", "asset_ibov", "price_ipca", "price_ipp")
HEADLINE <- HEADLINE[HEADLINE %in% var_names]

cat(sprintf("\n[8] IRFs (nboot = %d) para %d variantes\n", N_BOOT, length(IRF_VARIANTS)))

cells <- list()
for (v in IRF_VARIANTS) {
  t0 <- Sys.time()
  cells[[v]] <- run_stage2_cell(
    data_mat, dates, as.data.frame(inst_wide),
    sample_window = SAMPLES$full,
    r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
    instrument = v, mp_var = MP_VAR,
    h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED,
    shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS)
  cat(sprintf("    %-16s %.1f min\n", v, as.numeric(Sys.time() - t0, units = "mins")))
}

# End-to-end self-test: the reference cell must reproduce the CLAUDE.md
# smoke-test values, which proves the alternative-instrument machinery is
# wired exactly like production.
Pref <- cells[["z_jk_bs_purif"]]$irf$irf_point_matrix
smoke <- c(yield_6m = 0.005, yield_2y = 0.009164, yield_5y = 0.009274,
           asset_ibov = -1.673, cambio_usd = 0.1498)
got <- Pref[match(names(smoke), var_names), 1]
cat("    smoke test h0: ")
cat(paste(sprintf("%s %.6g", names(smoke), got), collapse = " | "), "\n")
if (max(abs(got - smoke)) > 5e-3) warning("smoke test divergiu do registro do CLAUDE.md")

irf_rows <- imap_dfr(cells, function(cell, tag) {
  p <- cell$irf$irf_point_matrix
  lo68 <- cell$irf$ci[["0.68"]]$lower; hi68 <- cell$irf$ci[["0.68"]]$upper
  lo90 <- cell$irf$ci[["0.90"]]$lower; hi90 <- cell$irf$ci[["0.90"]]$upper
  map_dfr(HEADLINE, function(vn) {
    i <- match(vn, var_names)
    tibble(teste = "IRF", instrumento = tag, variavel = vn, h = 0:HORIZON,
           ponto = p[i, ], lo68 = lo68[i, ], hi68 = hi68[i, ],
           lo90 = lo90[i, ], hi90 = hi90[i, ]) |>
      mutate(sig68 = (lo68 > 0) | (hi68 < 0), sig90 = (lo90 > 0) | (hi90 < 0))
  })
})

irf_h0 <- irf_rows |> filter(h == 0) |>
  select(instrumento, variavel, ponto, lo90, hi90, sig90) |>
  pivot_wider(names_from = instrumento, values_from = c(ponto, lo90, hi90, sig90))

pal <- c(z_jk_bs_purif = "#1b1b1b", z_jk3_policy = "#0072B2",
         z_jk3_sov = "#D55E00", z_jk_bs_norisk = "#009E73")
resp_idx <- setNames(as.list(match(HEADLINE, var_names)), HEADLINE)

pdf(file.path(OUT_DIR, "jk_sovereign_irf_overlay.pdf"), width = 12, height = 10)
print(
  plot_overlay_cells(cells, resp_idx, horizon = 36, palette = pal,
                     subtitle = "") +
    patchwork::plot_annotation(
      title = "Confound soberano: JK de duas vias vs. classificacao de tres vias",
      subtitle = sprintf(
        "r=%d q=%d p=%d | %s | +%dbp | nboot=%d | bandas 68/90 | amostra cheia",
        R_FACTORS, Q_DYNAMIC, P_LAGS, MP_VAR, SHOCK_BPS, N_BOOT))
)
dev.off()
cat(sprintf("    -> %s/jk_sovereign_irf_overlay.pdf\n", OUT_DIR))


# ===================================================================
# 9. TEST D — dated table for the narrative audit
# ===================================================================

cat("\n[9] Test D: tabela datada dos dias Copom\n")

days_tbl <- valid |>
  filter(copom_day) |>
  mutate(
    reuniao   = date - 1,
    quinta    = date,
    jk3_class = case_when(pol_fx ~ "politica", sov_fx ~ "soberano",
                          jk_monetary_bs ~ "nao classificado", TRUE ~ "filtrado (JK)"),
    jk3_embi  = case_when(pol_embi ~ "politica", sov_embi ~ "soberano",
                          jk_monetary_bs ~ "nao classificado", TRUE ~ "filtrado (JK)"),
    w         = ifelse(jk_monetary_bs, abs(unname(e_di_bs)), 0)
  ) |>
  # NB: `if (sum(w) > 0) ... else ...`, never ifelse() — the condition is a
  # scalar and ifelse() would recycle the first element over every row.
  group_by(month) |>
  mutate(share_month = if (sum(w) > 0) w / sum(w) else w * 0) |>
  ungroup() |>
  mutate(share_sample = if (sum(w) > 0) w / sum(w) else w * 0) |>
  arrange(desc(share_sample)) |>
  select(reuniao, quinta, delta_di, e_di_bs, r_ibov, e_ibov_bs,
         d_embi_bp, d_lbrl, d_slope_bp, e_brl_bs, e_embi_bs,
         jk_monetary_bs, jk3_class, jk3_embi, share_month, share_sample) |>
  mutate(nota_evento = NA_character_)

write_csv(days_tbl, file.path(OUT_DIR, "jk_sovereign_days.csv"))
cat(sprintf("    -> %s/jk_sovereign_days.csv (%d linhas)\n", OUT_DIR, nrow(days_tbl)))


# ===================================================================
# 10. Outputs
# ===================================================================

all_cells <- bind_rows(
  testA,
  xi_tbl,
  align_tbl |> mutate(teste = "alinhamento_embi") |> rename(conjunto = serie),
  quality_tbl |> mutate(teste = "qualidade") |> rename(conjunto = rotulo),
  irf_rows
)
write_csv(all_cells, file.path(OUT_DIR, "jk_sovereign_confound.csv"))

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)

md <- c(
  "# Confound soberano no filtro JK — teste diario",
  "",
  sprintf("*Gerado por `script/jk_sovereign_confound.R` em %s. **Corpo gerado: nao escreva prosa aqui.** A leitura interpretativa vive em `relatorio/working-notes/2026-07-31_confound_soberano_jk.md`.*",
          format(Sys.Date())),
  "",
  "## A pergunta",
  "",
  "O filtro Jarocinski-Karadi descarta o confound benigno (efeito-informacao: juros sobem, acoes sobem) mas uma surpresa fiscal/soberana domestica tem juros para cima, acoes para baixo e cambio para cima — **exatamente o padrao que o filtro retem como \"politica\"**. Os placebos do paper nao descartam essa alternativa: um choque fiscal domestico tambem nao deveria mover o S&P 500.",
  "",
  "## Regra de leitura, fixada antes de os numeros existirem",
  "",
  "- Interacao `x:1(jk_bs)` positiva com `p_boot < 0,10` -> **contaminacao confirmada**.",
  "- Interacao nula, mas efeito nos 62 dias significativo enquanto o controle nao-Copom e nulo -> **sinal fraco**; B e C decidem.",
  "- Ambos nulos -> **confound nao detectado na frequencia diaria**.",
  "",
  sprintf("**Veredito do teste A: %s.**", verdict_A),
  "",
  "## Lacuna de dado declarada",
  "",
  if (has_cds) "CDS 5a diario disponivel e incluido." else
    "**Nao ha CDS 5a diario** neste repositorio nem fonte programatica gratuita com historico 2013-2025 (Ipeadata encerrou o EMBI+ em 07/2024 e nunca teve CDS; WorldGovernmentBonds nao tem CSV/API; MacroMicro publica semanal; cbonds e pago). A unica fonte diaria e a pagina historica da Investing.com, via export de navegador. O **EMBI+ Brasil diario** e a proxy principal e cobre 95/95 quintas Copom e 94/95 quartas anteriores (o buraco e 2024-06-19, feriado americano).",
  "",
  "## Qualidade das proxies diarias",
  "",
  md_table(quality_tbl |> select(proxy, rotulo, n_copom, n_valid, sd)),
  "",
  "### Alinhamento do EMBI (pre-requisito de todo o teste A)",
  "",
  "Correlacao da variacao diaria do EMBI com o movimento de mercado em `t`, `t-1` e `t+1`. Se o arquivo fosse publicado com um dia de defasagem, a coluna `t-1` dominaria.",
  "",
  md_table(align_tbl),
  "",
  sprintf("**Arquivo alinhado no mesmo dia: %s.** Logo a janela Qua->Qui e a medida correta, e a janela Qui->Sex **nao** e uma correcao de alinhamento: e uma janela do dia seguinte, ou seja a resposta *defasada* do risco a surpresa, e nao noticia de risco dentro da janela do evento.",
          embi_same_day),
  "",
  "## A — regressao diaria por conjunto de dias",
  "",
  "`y ~ x`, HC1, `p_boot` por wild bootstrap sob a nula restrita. O conjunto **nao-Copom** e o controle: mede a comovimentacao diaria normal entre surpresa de juros e spread, que nao tem nada a ver com politica.",
  "",
  md_table(testA |> filter(teste == "A_nivel") |>
             select(proxy, conjunto, n, coef, se_hc1, t, p_asym, p_boot, r2)),
  "",
  "## A — interacao (a estatistica que decide)",
  "",
  "`y ~ x + 1(jk_bs) + x:1(jk_bs)` sobre todas as quintas validas. Contaminacao exige que o dia retido carregue **mais** noticia de risco por unidade de surpresa que um dia comum.",
  "",
  md_table(int_tbl |> select(proxy, n, coef, se_hc1, t, p_asym, p_boot)),
  "",
  "## B — classificacao de tres vias",
  "",
  "Politica: aperto **aprecia** o BRL (UIP) -> sinais de `e_di_bs` e `e_brl_bs` diferem. Soberano: surpresa fiscal **deprecia** -> sinais iguais. As pernas de FX e EMBI sao purificadas na **mesma** RHS pre-evento do Bauer-Swanson, para a mascara continuar predeterminada.",
  "",
  sprintf("- regra FX: **%d politica**, %d soberano, %d nao classificado (de %d retidos)",
          sum(valid$pol_fx), sum(valid$sov_fx), n_unclass_fx, sum(valid$jk_monetary_bs)),
  sprintf("- regra EMBI: **%d politica**, %d soberano, %d nao classificado",
          sum(valid$pol_embi), sum(valid$sov_embi), n_unclass_embi),
  "",
  "Concordancia entre as duas regras (linhas = FX, colunas = EMBI):",
  "",
  md_table(agree_tbl),
  "",
  "**Ressalvas.** (i) Condicionar a mascara num movimento cambial *contemporaneo* e o tipo de selecao same-window que a camada BS existe para evitar; `e_brl_bs` mitiga, nao elimina. (ii) A classe politica e menor, entao xi_mp cai por razao mecanica de tamanho de amostra e **tem que ser lido junto com o numero de meses nao-nulos**.",
  "",
  "## C — instrumento ortogonalizado ao risco",
  "",
  sprintf("`e_di_bs` residualizado no risco contemporaneo (%s): R2 = %.4f.",
          paste(all.vars(risk_rhs), collapse = " + "), summary(fit_nr)$r.squared),
  "",
  "**E um limite inferior.** Politica legitimamente move spread soberano, entao ortogonalizar contra o risco contemporaneo super-remove. Sobreviver e descarte forte do confound; nao sobreviver e ambiguo.",
  "",
  "## Forca: xi_mp por variante",
  "",
  md_table(xi_tbl |> select(amostra, instrumento, meses_nao_nulos, xi_mp,
                            wald_conjunta, f_factor)),
  "",
  "## IRFs no impacto (h = 0)",
  "",
  md_table(irf_rows |> filter(h == 0) |>
             select(instrumento, variavel, ponto, lo68, hi68, lo90, hi90, sig90)),
  "",
  "Trajetorias completas em `jk_sovereign_irf_overlay.pdf`; celulas em `jk_sovereign_confound.csv`.",
  "",
  "## D — auditoria narrativa",
  "",
  sprintf("`jk_sovereign_days.csv`: %d dias Copom com surpresa, residuos, variacao de risco Qua->Qui, classe de tres vias e peso no |z| do mes e da amostra, ordenados por alavancagem. A coluna `nota_evento` esta vazia para anotacao.",
          nrow(days_tbl)),
  ""
)

writeLines(md, file.path(OUT_DIR, "jk_sovereign_confound.md"))
cat(sprintf("\n-> %s/jk_sovereign_confound.{csv,md}\n", OUT_DIR))
cat(sprintf("\n=== veredito A: %s ===\n", verdict_A))
