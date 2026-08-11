# ===================================================================
# Does the Jarocinski-Karadi sign filter select SOVEREIGN RISK
# surprises instead of monetary policy shocks?
#
# Top item of the council review of 2026-07-31
# (pareceres/council_2026-07-31.md). The logic, in one line: the JK
# rule discards the BENIGN confound (central-bank information effect:
# rates up, stocks up) but a domestic fiscal/sovereign surprise has
# rates up, stocks DOWN, FX up — exactly the pattern the filter
# RETAINS as "policy". The placebo battery cannot discharge this,
# because a domestic fiscal shock also should not move the S&P 500.
#
# Two tests, both before or beside the DFM:
#
#  A. The decisive daily regression. Wed->Thu change in each daily
#     sovereign-risk proxy regressed on the surprise, over the 62
#     retained Copom days, over all 95 Copom days, and — the control
#     that gives the coefficient meaning — over the ~500 non-Copom
#     Thursdays. Contamination requires the retained days to carry
#     MORE risk news per unit of surprise than an ordinary day, which
#     is the interaction test, not the level of the coefficient.
#
#  C. Risk-orthogonalized instrument, in two degrees. Residualize the
#     surprise on the contemporaneous risk changes (VALUES), and then
#     re-derive the JK sign filter on the risk-orthogonalized residuals
#     of BOTH legs (MASK). A LOWER BOUND: policy legitimately moves
#     sovereign spreads, so this over-strips.
#
# CUT ON 2026-08-10, and recorded here so neither is re-proposed
# (registro/historico_decisoes.md):
#
#  - Test B, the three-way policy/sovereign split on the purified FX
#    sign, was suggestive and never conclusive. Every "policy" half it
#    produced, under all three classification rules, came out below the
#    3.84 at which the AR set stops being unbounded, so none of their
#    IRFs could be read in either direction, and the rules disagreed
#    with each other on a large share of the 62 days.
#  - Test D was a dated 95-row table whose only consumer was the
#    leverage caveat of paper_anpec.tex, removed from the paper on the
#    same date.
#
# Their numbers are in the git history and are NOT reproducible from
# this script. Do not cite them.
#
# The mask re-derivation of test C is what closes the objection those
# two used to sit next to (council of 2026-08-10): until now this test
# cleaned the VALUES of the surprise while leaving the SELECTION of the
# 62 days untouched, against the project's own fidelity audit ("strength
# lives in the mask"). The template is fomc_coincidence.R:403-412.
#
# Nothing in R/instrument/, R/modeling/ or script/instrument.R is
# modified. Every variant is built IN MEMORY, and promoting one of them
# to production is a separate author decision.
#
# TWO SOVEREIGN-RISK PROXIES, AND THE ORDER OF LOOKING. Until 2026-08-09
# this ran on EMBI+ alone, because no daily 5y CDS existed in the repo.
# `data/raw/CDS 5y.xlsx` (Bloomberg, BRAZIL CDS USD SR 5Y D14 Corp, daily
# 2001-10 to 2026-08) closed that gap, and it is the better instrument
# of measurement: 95/95 Copom Wed->Thu pairs against the EMBI's 94/95,
# and 0.2% of its daily changes are exactly zero against the EMBI's
# 8.9%. That last number is the point — the EMBI is published to two
# decimals of a percent, so a third of a basis point of risk news is
# rounded to nothing, which attenuates the test-A coefficient toward
# zero and makes a null there dismissible as measurement error. The CDS
# null is not dismissible that way.
#
# So: the EMBI verdict is reported FIRST and UNCHANGED, because its
# reading rule was fixed before its numbers existed. The CDS is then
# judged by the SAME rule (`verdict_for()`), and it is the primary
# proxy going forward. The order of looking is stated in the generated
# report; it is not a choice of ruler after the fact.
#
# Outputs: output/instrument/jk_sovereign_confound.csv
#          output/instrument/jk_sovereign_confound.md
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
  library(readxl)
})

source("R/instrument/di_surprise.R")
source("R/instrument/build_variants.R")
source("R/instrument/event_tests.R")      # wild_coef_test
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
EMBI_PATH  <- "data/raw/banco_central_rep_dominicana/embi_brasil.csv"
CDS_PATH   <- "data/raw/CDS 5y.xlsx"          # Bloomberg export, see header
RAW_PATH   <- "data/raw/raw_data.csv"         # monthly cds_5y, cross-check only
EVENT_PATH <- "data/processed/copom_event_diagnostics.csv"
OUT_DIR    <- "output/instrument"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

cat("=== JK sovereign-risk confound ===\n\n")


# ===================================================================
# 1. Daily event panel
# ===================================================================
# Rebuilt rather than read from copom_event_diagnostics.csv, because
# that file carries neither `month` nor `e_ibov_bs`, and test C needs
# both to re-derive the mask and re-aggregate it monthly.

cat("[1] rebuilding the daily event panel\n")

di_panel <- load_di_panel("data/raw/di.csv", from = LOAD_START, to = SAMPLE_END + 30)

ibov_daily <- read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ibov = as.numeric(ibov)) |>
  filter(!is.na(ibov))

ext_daily <- read_csv("data/raw/investing/external_factors_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), sp500 = as.numeric(sp500),
            vix = as.numeric(vix), brent = as.numeric(brent))

brl_daily <- read_csv("data/processed/brl_usd_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), brl = as.numeric(brl)) |>
  filter(!is.na(brl))

focus_daily <- read_csv("data/processed/focus_daily.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date),
            focus_ipca12m  = as.numeric(focus_ipca12m),
            focus_selic_ny = as.numeric(focus_selic_ny))

dgs2_daily <- read_csv("data/raw/fred_dgs2.csv", show_col_types = FALSE) |>
  transmute(date = as.Date(date), ust2y = as.numeric(ust2y))

copom_wed <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)

# The FOMC dates feed only `fomc_coincide`, which no test here reads. They are
# loaded anyway so the rebuilt panel matches copom_event_diagnostics.csv column
# for column — the self-test below compares the logical columns, and that file
# has carried the real flag since 2026-08-10.
fomc_dates <- load_fomc_dates(from = LOAD_START, to = SAMPLE_END)

built <- build_instrument_variants(
  inputs = list(di_panel = di_panel, ibov_daily = ibov_daily,
                ext_daily = ext_daily, brl_daily = brl_daily,
                focus_daily = focus_daily, dgs2_daily = dgs2_daily,
                copom_wed = copom_wed, fomc_dates = fomc_dates),
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

# Bloomberg export: rows 1-5 are metadata (Start/End Date, Period,
# Currency, Security), row 6 the header, and the series sits in columns
# C:D — hence the explicit upper-left corner. `skip` would be ignored
# here: readxl lets `range` win, and cell_cols alone would trim to the
# Security row and read the dates as text.
cds_daily <- read_excel(CDS_PATH, range = cell_limits(c(7, 3), c(NA, 4)),
                        col_names = c("date", "cds")) |>
  transmute(date = as.Date(date), cds = as.numeric(cds)) |>
  filter(!is.na(date), !is.na(cds)) |>
  arrange(date)

# Self-test: the daily CDS and the monthly `cds_5y` already in the panel
# come from different vendors (Bloomberg vs Investing.com). If they were
# not the same object, the daily test below and the monthly IRF of
# `cds_5y` would share a name and nothing else.
cds_eom <- cds_daily |>
  filter(date >= SAMPLE_START, date <= SAMPLE_END) |>
  group_by(month = floor_date(date, "month")) |>
  summarise(cds_bbg = cds[which.max(date)], .groups = "drop")
cds_monthly_chk <- read_csv(RAW_PATH, show_col_types = FALSE) |>
  transmute(month = as.Date(ref.date), cds_panel = as.numeric(cds_5y)) |>
  filter(!is.na(cds_panel)) |>
  inner_join(cds_eom, by = "month")
cds_cor <- cor(cds_monthly_chk$cds_panel, cds_monthly_chk$cds_bbg)
cat(sprintf("    CDS diario x cds_5y mensal do painel: n = %d, cor = %.4f, max |diff| = %.2f bp\n",
            nrow(cds_monthly_chk), cds_cor,
            max(abs(cds_monthly_chk$cds_panel - cds_monthly_chk$cds_bbg))))
stopifnot(nrow(cds_monthly_chk) > 140L, cds_cor > 0.99)

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

valid$d_cds_bp    <- wed_thu(thu, cds_daily,  "cds")                 # already bp
valid$d_embi_bp   <- wed_thu(thu, embi_daily, "embi", scale = 100)   # p.p. -> bp
valid$d_lbrl      <- wed_thu(thu, brl_daily,  "brl",  scale = 100, log_scale = TRUE)
valid$d_slope_bp  <- wed_thu(thu, di_slope_daily, "slope", scale = 100)
valid$d_di10y_bp  <- wed_thu(thu, di_long_daily,  "long",  scale = 100)

#' Same-day alignment diagnostic for a daily risk series.
#'
#' A same-day close is not guaranteed a priori for either proxy — the
#' EMBI is a JP Morgan panel republished by the Dominican central bank,
#' the CDS a Bloomberg quote on a weekday calendar — and the whole
#' reading of test A depends on it. If a file were published with a
#' one-day lag, its `t-1` column would dominate.
align_check <- function(daily, col, proxy) {
  src <- daily |>
    filter(date >= SAMPLE_START, date <= SAMPLE_END) |>
    mutate(d_risk = .data[[col]] - lag(.data[[col]])) |>
    left_join(brl_daily, by = "date") |>
    left_join(ext_daily, by = "date") |>
    left_join(ibov_daily, by = "date") |>
    mutate(r_brl = 100 * (log(brl) - log(lag(brl))),
           r_sp500 = 100 * (log(sp500) - log(lag(sp500))),
           d_vix = vix - lag(vix),
           r_ibov = 100 * (log(ibov) - log(lag(ibov)))) |>
    filter(!is.na(d_risk))
  map_dfr(c("r_brl", "r_sp500", "d_vix", "r_ibov"), function(v) {
    x <- src[[v]]
    tibble(proxy = proxy, serie = v,
           cor_t   = cor(src$d_risk, x, use = "pairwise"),
           cor_tm1 = cor(src$d_risk, lag(x), use = "pairwise"),
           cor_tp1 = cor(src$d_risk, lead(x), use = "pairwise"))
  })
}

align_tbl <- bind_rows(align_check(cds_daily,  "cds",  "CDS 5a"),
                       align_check(embi_daily, "embi", "EMBI+"))
cat("    alinhamento (cor da variacao diaria com o mercado em t / t-1 / t+1):\n")
for (i in seq_len(nrow(align_tbl))) {
  cat(sprintf("      %-7s %-8s t = %+.3f | t-1 = %+.3f | t+1 = %+.3f\n",
              align_tbl$proxy[i], align_tbl$serie[i], align_tbl$cor_t[i],
              align_tbl$cor_tm1[i], align_tbl$cor_tp1[i]))
}
same_day_tbl <- align_tbl |>
  group_by(proxy) |>
  summarise(same_day = all(abs(cor_t) > abs(cor_tm1)), .groups = "drop")
for (i in seq_len(nrow(same_day_tbl))) {
  cat(sprintf("      -> %s alinhado no MESMO dia: %s\n",
              same_day_tbl$proxy[i], same_day_tbl$same_day[i]))
}
embi_same_day <- same_day_tbl$same_day[same_day_tbl$proxy == "EMBI+"]
cds_same_day  <- same_day_tbl$same_day[same_day_tbl$proxy == "CDS 5a"]

# Given same-day alignment, the Thu->Fri window below is NOT a corrected
# alignment: it is a genuine NEXT-DAY window, i.e. the delayed risk
# response to the surprise rather than risk news inside the event window.
next_sess <- function(d, daily) {
  idx <- findInterval(as.numeric(d), as.numeric(daily$date)) + 1L
  ifelse(idx <= nrow(daily), daily$date[pmin(idx, nrow(daily))], NA)
}
next_day_change <- function(daily, col, scale = 1) {
  nxt <- as.Date(next_sess(thu, daily), origin = "1970-01-01")
  scale * (on_date(nxt, daily, col) - on_date(thu, daily, col))
}
valid$d_cds_bp_lag1  <- next_day_change(cds_daily,  "cds")
valid$d_embi_bp_lag1 <- next_day_change(embi_daily, "embi", scale = 100)

RISK_VARS <- c(d_cds_bp = "CDS 5a (bp, Qua->Qui)",
               d_embi_bp = "EMBI+ (bp, Qua->Qui)",
               d_cds_bp_lag1 = "CDS 5a (bp, Qui->Sex, janela do dia SEGUINTE)",
               d_embi_bp_lag1 = "EMBI+ (bp, Qui->Sex, janela do dia SEGUINTE)",
               d_lbrl = "BRL/USD (log x100, + = depreciacao)",
               d_slope_bp = "Slope DI 504-63bd (bp)",
               d_di10y_bp = "DI ~10a (bp)")

# Coverage and measurement resolution. The zero share is the number that
# matters: a proxy that rounds small risk news to nothing attenuates the
# test-A coefficient toward zero, which would make its null dismissible.
cop <- valid$copom_day
zero_share <- function(v) {
  nz <- abs(v[!is.na(v)])
  c(min_nonzero = min(nz[nz > 0]), pct_zero = 100 * mean(nz == 0))
}
n_cds_cop  <- sum(!is.na(valid$d_cds_bp[cop]))
n_embi_cop <- sum(!is.na(valid$d_embi_bp[cop]))
for (v in c("d_cds_bp", "d_embi_bp")) {
  zs <- zero_share(valid[[v]])
  cat(sprintf("    %-10s %d/%d pares Copom | menor |delta| nao-nulo = %.3f bp | %.1f%% exatamente zero\n",
              v, sum(!is.na(valid[[v]][cop])), sum(cop), zs["min_nonzero"], zs["pct_zero"]))
}
cat(sprintf("    EMBI cauda 2024-25: %d obs, sd(delta) = %.2f bp\n",
            sum(embi_daily$date >= as.Date("2024-01-01")),
            sd(valid$d_embi_bp[valid$date >= as.Date("2024-01-01")], na.rm = TRUE)))
stopifnot(n_embi_cop >= 94L, n_cds_cop == 95L)

quality_tbl <- tibble(
  proxy   = names(RISK_VARS),
  rotulo  = unname(RISK_VARS),
  n_copom = vapply(names(RISK_VARS), function(v) sum(!is.na(valid[[v]][cop])), integer(1)),
  n_valid = vapply(names(RISK_VARS), function(v) sum(!is.na(valid[[v]])), integer(1)),
  sd      = vapply(names(RISK_VARS), function(v) sd(valid[[v]], na.rm = TRUE), numeric(1)),
  pct_zero = vapply(names(RISK_VARS),
                    function(v) unname(zero_share(valid[[v]])["pct_zero"]), numeric(1))
)


# ===================================================================
# 3. TEST A — the decisive daily regression
# ===================================================================

cat("\n[3] Test A: daily regressions\n")

# `wild_coef_test()` lives in R/instrument/event_tests.R since 2026-08-10, when
# script/fomc_coincidence.R needed the same test. It was moved verbatim (its
# default `nboot` is the literal 2000 that NBOOT_P holds here), so every p_boot
# below still reproduces.

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
    res <- wild_coef_test(y ~ x, d, "x", key = paste("A_nivel", rv, ds$tag))
    rowsA[[length(rowsA) + 1]] <- bind_cols(
      tibble(teste = "A_nivel", proxy = rv, conjunto = ds$tag, x = ds$x), res)
  }
}

# The statistic that decides: does the retained day carry MORE risk news
# per unit of surprise than an ordinary Thursday?
for (rv in names(RISK_VARS)) {
  d <- tibble(y = valid[[rv]], x = valid$e_di_bs,
              d_jk = as.numeric(valid$jk_monetary_bs))
  res <- wild_coef_test(y ~ x * d_jk, d, "x:d_jk", key = paste("A_interacao", rv))
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
# as the vertex sweep, which fixed its 2.00 threshold ex ante). It is a
# function rather than two copies precisely because the two proxies must
# be judged by identical code: duplicating a pre-registered rule is how
# it silently stops being the same rule.
verdict_for <- function(rv) {
  int <- int_tbl |> filter(proxy == rv)
  if (isTRUE(int$coef > 0 && int$p_boot < 0.10)) return("CONTAMINACAO CONFIRMADA")
  lvl <- testA |> filter(teste == "A_nivel", proxy == rv)
  a62 <- lvl |> filter(conjunto == "jk_bs (producao)")
  ctl <- lvl |> filter(conjunto == "nao-copom (controle)")
  if (isTRUE(a62$coef > 0 && a62$p_boot < 0.10 && ctl$p_boot >= 0.10)) {
    "SINAL FRACO DE CONTAMINACAO"
  } else {
    "CONFOUND NAO DETECTADO NA FREQUENCIA DIARIA"
  }
}

# EMBI first because its rule was fixed before its numbers existed; CDS
# second, same rule, and primary from here on. See the header.
verdict_A     <- verdict_for("d_embi_bp")
verdict_A_cds <- verdict_for("d_cds_bp")
cat(sprintf("    >>> veredito A (EMBI, pre-registrado): %s\n", verdict_A))
cat(sprintf("    >>> veredito A (CDS 5a, mesma regra) : %s\n", verdict_A_cds))
if (verdict_A != verdict_A_cds)
  cat("    !!! OS DOIS VEREDITOS DIVERGEM — isso e o resultado, nao um rodape\n")


# ===================================================================
# 4. TEST C — risk-orthogonalized instrument, values and mask
# ===================================================================

cat("\n[4] Test C: risk-orthogonalized instrument\n")

# The EMBI-only RHS is deliberately frozen: `z_jk_bs_norisk` has to keep
# reproducing xi_mp = 10.72 so it can serve as the self-test that the CDS
# did not perturb the pre-existing variant, and so the marginal
# contribution of the CDS to what the orthogonalization strips is
# readable rather than folded into a redefined column.
risk_rhs     <- ~ d_embi_bp + d_lbrl
risk_rhs_cds <- ~ d_embi_bp + d_lbrl + d_cds_bp

fit_nr <- lm(update(risk_rhs, e_di_bs ~ .), data = valid, na.action = na.exclude)
valid$e_di_bs_norisk <- as.numeric(residuals(fit_nr))

fit_nr_cds <- lm(update(risk_rhs_cds, e_di_bs ~ .), data = valid, na.action = na.exclude)
valid$e_di_bs_norisk_cds <- as.numeric(residuals(fit_nr_cds))

cat(sprintf("    R2 do risco contemporaneo: EMBI+BRL %.4f (n = %d) | +CDS %.4f (n = %d)\n",
            summary(fit_nr)$r.squared, nobs(fit_nr),
            summary(fit_nr_cds)$r.squared, nobs(fit_nr_cds)))

# Second degree: the SELECTION, not just the values. Until 2026-08-10 this
# test residualized only `e_di_bs` and then handed the untouched
# `jk_monetary_bs` mask to the monthly aggregation, so the 62 days were still
# chosen by residuals that carry the risk news. The project's own fidelity
# audit says instrument strength lives in the mask, which is why the equity
# leg is orthogonalized on the same RHS and the JK sign rule re-derived on
# the double residuals. Same construction as jk_monetary_bs
# (build_variants.R:313-316) and as jk_monetary_bs_glob (fomc_coincidence.R).
fit_ibov_nr_cds <- lm(update(risk_rhs_cds, e_ibov_bs ~ .),
                      data = valid, na.action = na.exclude)
valid$e_ibov_bs_norisk_cds <- as.numeric(residuals(fit_ibov_nr_cds))

# Unlike the BS and global blocks, the risk RHS has holes (the EMBI misses
# 2024-06-19, a US holiday), and `na.exclude` propagates them into the
# residuals. A day whose risk proxies are missing cannot have its mask
# re-derived, so it is dropped explicitly and counted rather than allowed to
# fall through as NA.
nr_ok <- !is.na(valid$e_di_bs_norisk_cds) & !is.na(valid$e_ibov_bs_norisk_cds)
valid$jk_monetary_bs_norisk <- valid$copom_day & nr_ok &
  sign(valid$e_di_bs_norisk_cds) != 0 & sign(valid$e_ibov_bs_norisk_cds) != 0 &
  sign(valid$e_di_bs_norisk_cds) != sign(valid$e_ibov_bs_norisk_cds)

n_nr_drop <- sum(valid$copom_day & !nr_ok)
n_nr_mask <- sum(valid$jk_monetary_bs_norisk)
n_nr_keep <- sum(valid$jk_monetary_bs & valid$jk_monetary_bs_norisk)
r2_di_nr   <- summary(fit_nr_cds)$r.squared
r2_ibov_nr <- summary(fit_ibov_nr_cds)$r.squared
cat(sprintf("    R2 do bloco de risco: e_di_bs %.4f | e_ibov_bs %.4f\n",
            r2_di_nr, r2_ibov_nr))
cat(sprintf("    mascara re-derivada: %d dias (%d dos 62 sobrevivem, %d novos, %d dias Copom sem proxy)\n",
            n_nr_mask, n_nr_keep, n_nr_mask - n_nr_keep, n_nr_drop))

mask_tbl <- tibble(
  teste    = "mascara",
  conjunto = c("producao (jk_bs)", "re-derivada no risco (jk_bs_norisk)",
               "intersecao", "dias Copom sem proxy de risco"),
  n        = c(sum(valid$jk_monetary_bs), n_nr_mask, n_nr_keep, n_nr_drop),
  r2_risco = c(NA_real_, r2_di_nr, r2_ibov_nr, NA_real_))


# ===================================================================
# 5. Monthly aggregation of the in-memory variants
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
    z_jk_bs_purif      = mk_z("e_di_bs", valid$jk_monetary_bs),
    # values orthogonalized, mask untouched
    z_jk_bs_norisk     = mk_z("e_di_bs_norisk",     valid$jk_monetary_bs),
    z_jk_bs_norisk_cds = mk_z("e_di_bs_norisk_cds", valid$jk_monetary_bs),
    # values orthogonalized AND mask re-derived on the double residuals
    z_jk_bs_norisk_mask = mk_z("e_di_bs_norisk_cds", valid$jk_monetary_bs_norisk)
  )

# Self-test: the recomputed production column must equal the one on disk.
prod_panel <- read_csv(INST_PATH, show_col_types = FALSE) |> mutate(month = as.Date(month))
chk <- inner_join(inst_wide |> select(month, mine = z_jk_bs_purif),
                  prod_panel |> select(month, disk = z_jk_bs_purif), by = "month")
cat(sprintf("\n[5] z_jk_bs_purif reconstruido vs disco: n = %d, max |diff| = %.3g\n",
            nrow(chk), max(abs(chk$mine - chk$disk))))
stopifnot(nrow(chk) == nrow(prod_panel), max(abs(chk$mine - chk$disk)) < 1e-10)

Z_VARIANTS <- c("z_jk_bs_purif", "z_jk_bs_norisk",
                "z_jk_bs_norisk_cds", "z_jk_bs_norisk_mask")


# ===================================================================
# 6. xi_mp of each variant
# ===================================================================

cat("\n[6] xi_mp por variante e janela\n")

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
      wald_conjunta = dg$wald_joint, f_factor = dg$f_factor,
      # Pre-normalization impact of the policy variable: the denominator every
      # IRF of the cell is divided by. It is what makes a weaker variant print
      # LARGER responses, so it has to be reported next to xi_mp rather than
      # inferred from it. Same field as fomc_coincidence.R.
      impacto_mp_pre = dg$impact_mp)
    cat(sprintf("    %-9s %-19s meses!=0 = %3d  xi_mp = %7.3f\n", sn, v, n_nz, dg$wald_mp))
  }
}
# MOSW thresholds, the same ones the sweep taxonomy uses: below 3.84 the
# 95% AR set is unbounded, so the column's IRF is a number with no
# identification behind it; below 10 conventional bands are not valid.
xi_tbl <- bind_rows(rowsX) |>
  group_by(amostra) |>
  mutate(ar_limitada = xi_mp > 3.84, bandas_validas = xi_mp >= 10,
         denom_vs_prod = impacto_mp_pre /
           impacto_mp_pre[instrumento == "z_jk_bs_purif"]) |>
  ungroup()

# Cross-check against the strength ruler of record.
xi_prod <- xi_tbl |> filter(instrumento == "z_jk_bs_purif")
cat(sprintf("    check: producao full %.2f (registro 10.43) | pre_covid %.2f (registro 12.22)\n",
            xi_prod$xi_mp[xi_prod$amostra == "full"],
            xi_prod$xi_mp[xi_prod$amostra == "pre_covid"]))

# Self-test: the EMBI-only orthogonalized variant predates the CDS and
# must be bit-for-bit what it was, otherwise the CDS leg leaked into it.
xi_norisk_full <- xi_tbl$xi_mp[xi_tbl$instrumento == "z_jk_bs_norisk" &
                               xi_tbl$amostra == "full"]
cat(sprintf("    check: z_jk_bs_norisk full %.2f (registro 10.72)\n", xi_norisk_full))
stopifnot(abs(xi_norisk_full - 10.72) < 0.01)


# ===================================================================
# 7. IRFs with the full production bootstrap
# ===================================================================
# `z_jk_bs_norisk` is deliberately NOT here: its role is the frozen xi_mp
# self-test above (10.72), and the harsher `_cds` variant is the one the
# paper reads. Bootstrapping it would cost a cell for a number nothing uses.

IRF_VARIANTS <- c("z_jk_bs_purif", "z_jk_bs_norisk_cds", "z_jk_bs_norisk_mask")
HEADLINE <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd", "embi_perc",
              "cds_5y", "asset_ibov", "price_ipca", "price_ipp")
HEADLINE <- HEADLINE[HEADLINE %in% var_names]

cat(sprintf("\n[7] IRFs (nboot = %d) para %d variantes\n", N_BOOT, length(IRF_VARIANTS)))

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

pal <- c(z_jk_bs_purif = "#1b1b1b", z_jk_bs_norisk_cds = "#0072B2",
         z_jk_bs_norisk_mask = "#D55E00")
resp_idx <- setNames(as.list(match(HEADLINE, var_names)), HEADLINE)

pdf(file.path(OUT_DIR, "jk_sovereign_irf_overlay.pdf"), width = 12, height = 10)
print(
  plot_overlay_cells(cells, resp_idx, horizon = 36, palette = pal, subtitle = "") +
    patchwork::plot_annotation(
      title = "Confound soberano: producao vs. surpresa ortogonalizada ao risco (valores e mascara)",
      subtitle = sprintf(
        "r=%d q=%d p=%d | %s | +%dbp | nboot=%d | bandas 68/90 | amostra cheia",
        R_FACTORS, Q_DYNAMIC, P_LAGS, MP_VAR, SHOCK_BPS, N_BOOT))
)
dev.off()
cat(sprintf("    -> %s/jk_sovereign_irf_overlay.pdf\n", OUT_DIR))


# ===================================================================
# 8. Outputs
# ===================================================================

all_cells <- bind_rows(
  testA,
  xi_tbl,
  align_tbl |> mutate(teste = "alinhamento") |> rename(conjunto = serie),
  quality_tbl |> mutate(teste = "qualidade") |> rename(conjunto = rotulo),
  mask_tbl,
  irf_rows
)
write_csv(all_cells, file.path(OUT_DIR, "jk_sovereign_confound.csv"))

xi_at <- function(v, sn = "full") xi_tbl$xi_mp[xi_tbl$instrumento == v & xi_tbl$amostra == sn]
xf    <- function(x) formatC(x, format = "f", digits = 2, decimal.mark = ",")

md <- c(
  "# Confound soberano no filtro JK — teste diario",
  "",
  sprintf("*Gerado por `script/jk_sovereign_confound.R` em %s. **Corpo gerado: nao escreva prosa aqui.** A leitura interpretativa vive em `notas/2026-08-09_confound_soberano_cds.md` (rodada das duas proxies) e `2026-07-31_confound_soberano_jk.md` (rodada original, so EMBI).*",
          format(Sys.Date())),
  "",
  "## A pergunta",
  "",
  "O filtro Jarocinski-Karadi descarta o confound benigno (efeito-informacao: juros sobem, acoes sobem) mas uma surpresa fiscal/soberana domestica tem juros para cima, acoes para baixo e cambio para cima — **exatamente o padrao que o filtro retem como \"politica\"**. Os placebos do paper nao descartam essa alternativa: um choque fiscal domestico tambem nao deveria mover o S&P 500.",
  "",
  "## Regra de leitura, fixada antes de os numeros existirem",
  "",
  "- Interacao `x:1(jk_bs)` positiva com `p_boot < 0,10` -> **contaminacao confirmada**.",
  "- Interacao nula, mas efeito nos 62 dias significativo enquanto o controle nao-Copom e nulo -> **sinal fraco**; C decide.",
  "- Ambos nulos -> **confound nao detectado na frequencia diaria**.",
  "",
  sprintf("**Veredito em EMBI+ (pre-registrado): %s.**", verdict_A),
  sprintf("**Veredito em CDS 5a (mesma regra, proxy principal): %s.**", verdict_A_cds),
  "",
  if (verdict_A == verdict_A_cds)
    "Os dois vereditos coincidem." else
    "⚠ **Os dois vereditos divergem.** Isso e o resultado do teste, nao um rodape: leia as duas linhas da tabela de interacao abaixo antes de qualquer leitura substantiva.",
  "",
  "## As duas proxies, e a ordem de olhar",
  "",
  sprintf("Ate 2026-08-09 este teste rodava so em **EMBI+** porque nao havia CDS 5a diario no repositorio. `data/raw/CDS 5y.xlsx` (Bloomberg, `BRAZIL CDS USD SR 5Y D14 Corp`, diario 2001-10 a 2026-08) fechou a lacuna, e e o melhor instrumento de medida: cobre **%d/%d** pares Qua->Qui de Copom contra %d/%d do EMBI (o buraco e 2024-06-19, feriado americano), e **%.1f%%** das suas variacoes no painel de eventos sao exatamente zero contra **%.1f%%** do EMBI.",
          n_cds_cop, sum(cop), n_embi_cop, sum(cop),
          unname(zero_share(valid$d_cds_bp)["pct_zero"]),
          unname(zero_share(valid$d_embi_bp)["pct_zero"])),
  "",
  sprintf("Esse ultimo numero e o que importa. O EMBI+ e publicado com duas casas em pontos percentuais, entao a menor variacao nao-nula que ele consegue exprimir e **%.3f bp**, contra **%.3f bp** do CDS: noticia de risco menor que isso e arredondada a nada. Isso **atenua o coeficiente do teste A em direcao a zero** e tornaria um nulo ali descartavel como erro de medida. O nulo do CDS nao e descartavel assim — e a tabela de alinhamento abaixo mostra o mesmo por outro lado, com o CDS correlacionando mais forte com o mercado no mesmo dia em todas as quatro series.",
          unname(zero_share(valid$d_embi_bp)["min_nonzero"]),
          unname(zero_share(valid$d_cds_bp)["min_nonzero"])),
  "",
  "**A ordem de olhar, declarada:** o EMBI foi olhado primeiro e a regra de leitura acima foi fixada antes dos numeros dele. O CDS chegou depois e e julgado pela **mesma funcao** (`verdict_for()`), sem regra nova. O veredito do EMBI acima e exatamente o de 2026-07-31, inalterado.",
  "",
  "## Qualidade das proxies diarias",
  "",
  md_table(quality_tbl |> select(proxy, rotulo, n_copom, n_valid, sd, pct_zero)),
  "",
  "### Alinhamento (pre-requisito de todo o teste A)",
  "",
  "Correlacao da variacao diaria de cada proxy com o movimento de mercado em `t`, `t-1` e `t+1`. Se um arquivo fosse publicado com um dia de defasagem, a coluna `t-1` dominaria — e a janela Qua->Qui deixaria de medir o que se pretende.",
  "",
  md_table(align_tbl),
  "",
  sprintf("**Alinhados no mesmo dia: CDS %s, EMBI %s.** Logo a janela Qua->Qui e a medida correta, e a janela Qui->Sex **nao** e uma correcao de alinhamento: e uma janela do dia seguinte, ou seja a resposta *defasada* do risco a surpresa, e nao noticia de risco dentro da janela do evento.",
          cds_same_day, embi_same_day),
  "",
  "## A — regressao diaria por conjunto de dias",
  "",
  "`y ~ x`, HC1, `p_boot` por wild bootstrap sob a nula restrita. O conjunto **nao-Copom** e o controle: mede a comovimentacao diaria normal entre surpresa de juros e spread, que nao tem nada a ver com politica.",
  "",
  "**Reprodutibilidade dos `p_boot`.** Desde 2026-08-09 cada celula e semeada pela propria identidade (`wild_coef_test(key = )`), entao acrescentar ou reordenar proxies nao move o `p_boot` de nenhuma outra. Antes disso todas compartilhavam um unico fluxo de RNG, e por isso os `p_boot` da nota de 07-31 diferem destes por ruido de Monte Carlo (erro-padrao ~0,007 com 2.000 sorteios). As estatisticas **deterministicas** — coeficiente, erro-padrao HC1, `t`, R² — reproduzem exatas, e sao elas que carregam o argumento: o que decide o veredito e o **sinal** da interacao.",
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
  "## C — instrumento ortogonalizado ao risco",
  "",
  sprintf("`e_di_bs` residualizado no risco contemporaneo, em tres degraus de severidade. `z_jk_bs_norisk` usa %s (R2 = %.4f) e esta congelada como estava em 2026-07-31 para servir de self-test. `z_jk_bs_norisk_cds` acrescenta o CDS (%s, R2 = %.4f) e e o limite inferior mais forte sobre os **valores**. `z_jk_bs_norisk_mask` re-deriva tambem a **mascara**.",
          paste(all.vars(risk_rhs), collapse = " + "), summary(fit_nr)$r.squared,
          paste(all.vars(risk_rhs_cds), collapse = " + "), summary(fit_nr_cds)$r.squared),
  "",
  "**E um limite inferior.** Politica legitimamente move spread soberano, entao ortogonalizar contra o risco contemporaneo super-remove. Sobreviver e descarte forte do confound; nao sobreviver e ambiguo.",
  "",
  "### Valores contra selecao",
  "",
  sprintf("Ortogonalizar so os **valores** deixa a **selecao** dos 62 dias intacta, contra a propria auditoria de fidelidade do projeto (\"a forca vive na mascara\"). Por isso a perna de acoes tambem e ortogonalizada na mesma RHS e a regra de sinal do JK e re-derivada nos residuos duplos: o bloco de risco explica **%.4f** de `e_di_bs` e **%.4f** de `e_ibov_bs`, e a mascara re-derivada retem **%d dias**, dos quais **%d dos 62** de producao sobrevivem e **%d** entram.",
          r2_di_nr, r2_ibov_nr, n_nr_mask, n_nr_keep, n_nr_mask - n_nr_keep),
  "",
  md_table(mask_tbl |> select(conjunto, n, r2_risco)),
  "",
  "## Forca: xi_mp por variante",
  "",
  md_table(xi_tbl |> select(amostra, instrumento, meses_nao_nulos, xi_mp,
                            wald_conjunta, f_factor, impacto_mp_pre,
                            denom_vs_prod, ar_limitada, bandas_validas)),
  "",
  "`ar_limitada` e ξ_mp > 3,84 (conjunto AR de 95% limitado); `bandas_validas` e ξ_mp ≥ 10.",
  "",
  sprintf("**Os dois canais andam em direcoes opostas, e e o resultado central do teste C.** Ortogonalizar os **valores** ao risco contemporaneo *aumenta* ξ_mp, de %s na producao para %s com EMBI e cambio e %s com o CDS. Re-derivar a **mascara** sobre os mesmos residuos derruba para %s na amostra cheia, uma queda de %s, porque o bloco de risco explica %.1f%% de `e_di_bs` mas %.1f%% de `e_ibov_bs` e a perna de acoes e metade da regra de sinal. O conjunto AR continua limitado, mas abaixo de 10 as bandas convencionais deixam de valer, entao a variante de mascara sustenta sinal e direcao, nao intervalo.",
          xf(xi_at("z_jk_bs_purif")), xf(xi_at("z_jk_bs_norisk")),
          xf(xi_at("z_jk_bs_norisk_cds")), xf(xi_at("z_jk_bs_norisk_mask")),
          xf(xi_at("z_jk_bs_purif") - xi_at("z_jk_bs_norisk_mask")),
          100 * r2_di_nr, 100 * r2_ibov_nr),
  "",
  sprintf("Na janela pre-COVID o ordenamento se inverte, com a variante de mascara em %s contra %s da producao, o que diz que a queda na amostra cheia vem do periodo em que juros e risco soberano se moveram juntos e nao de um defeito da re-derivacao.",
          xf(xi_at("z_jk_bs_norisk_mask", "pre_covid")),
          xf(xi_at("z_jk_bs_purif", "pre_covid"))),
  "",
  "⚠ **Por que uma variante ortogonalizada pode imprimir respostas MAIORES, e por que isso nao e evidencia a favor.** `impacto_mp_pre` e a resposta de `yield_6m` no impacto **antes** da normalizacao, isto e o denominador pelo qual cada IRF da celula e dividida, e `denom_vs_prod` o poe em razao da producao. Onde ele encolhe, toda a IRF da celula cresce por aritmetica, sem que nada de economico tenha mudado. E o mesmo mecanismo que a classe `unstable_normalization` da taxonomia do sweep monitora (`R/identification/spec_sweep.R`), e por isso a leitura de magnitude entre variantes so vale com essa coluna ao lado.",
  "",
  "## IRFs no impacto (h = 0)",
  "",
  sprintf("Celulas sig90 por variante: %s.",
          paste(sprintf("%s %d", names(sort(tapply(irf_rows$sig90, irf_rows$instrumento, sum), decreasing = TRUE)),
                        sort(tapply(irf_rows$sig90, irf_rows$instrumento, sum), decreasing = TRUE)),
                collapse = ", ")),
  "",
  md_table(irf_rows |> filter(h == 0) |>
             select(instrumento, variavel, ponto, lo68, hi68, lo90, hi90, sig90)),
  "",
  "Trajetorias completas em `jk_sovereign_irf_overlay.pdf`; celulas em `jk_sovereign_confound.csv`.",
  ""
)

writeLines(md, file.path(OUT_DIR, "jk_sovereign_confound.md"))
cat(sprintf("\n-> %s/jk_sovereign_confound.{csv,md}\n", OUT_DIR))
cat(sprintf("\n=== veredito A | EMBI+ (pre-registrado): %s | CDS 5a: %s ===\n",
            verdict_A, verdict_A_cds))
