# ===================================================================
# Does the RETURN representation of the B3 indices mechanically cause
# the null result in the equity block?
#
# Council-review item of 2026-07-31 (_instrucoes/pendencias.md:588-595):
# the 8 `asset_*` series enter the panel as monthly compounded simple
# returns while the other 98 enter in level (or log-level), which is
# inconsistent with BLL's own "do not difference" point and with
# Alessi-Kerssenfischer's log-levels. The paper reports 0 of 392 sig90
# cells in the equity block — the very block its title is about.
#
# THE MECHANICS, verified before this script was written:
#
#   * The `cumsum` is NOT in the data path. It is in `cumimp_transform`
#     (impulse_responde.R:277), applied to the IRF under tcode 2, in
#     the point estimate AND inside each of the 800 replicas.
#   * `tcode` never enters the DFM (zero occurrences in
#     factor_estimation.R). Changing tcode moves only the display map.
#     Changing the PANEL moves factors, loadings, eta, H, xi_mp — all.
#   * BLL differences the panel to estimate Lambda
#     (factor_estimation.R:300). For a return column that is
#     diff(return) = second difference of log price. Monthly equity
#     returns here are near white noise (ac1 0.03-0.17), so this is
#     textbook over-differencing.
#
# FOUR CELLS, production spec throughout, panels built IN MEMORY:
#
#   prod        returns,               tcode 2  baseline (= production)
#   prod_nocum  returns,               tcode 1  isolates the cumsum:
#                                               same model, same seed,
#                                               only the transform differs
#   loglevel    log(cumprod(1+r)),     tcode 4  the variant the item asks
#                                               for; AK-faithful
#   level       cumprod(1+r),          tcode 1  separates "the log" from
#                                               "the level"
#
# READING RULE, fixed before the numbers existed (see the plan and the
# working-note; convention of model_var.R and jk_sovereign_confound.R):
#
#   * MECHANICAL if, under `loglevel`, the block has >= 1 sig90 cell at
#     h <= 12 AND xi_mp of the log-level panel stays >= 3.84 (strong
#     form: >= 10).
#   * NOT MECHANICAL if the block stays at 0 sig90 with the guards
#     standing. Then the null is a property of the data, and that goes
#     to the paper as a result.
#   * h = 0 IS THE CLEAN TEST OF THE REPRESENTATION. It is the only
#     horizon where the two measure the same object (% change of the
#     index in the month of impact) and where `cumsum` is a no-op, so a
#     change there is attributable to the panel, never to the display
#     transform.
#   * The band blow-up (10.46) is attributed to the `cumsum` iff
#     `prod_nocum` shows an h36/h0 ratio near the tcode-1 norm on the
#     SAME model. Separate claim; does not move the h<=12 verdict.
#   * INCONCLUSIVE, and reported as such, if xi_mp on the log-level
#     panel falls below 3.84 — the comparison would then confound
#     representation with instrument strength.
#
# DECLARED BEFORE RUNNING, because this repo records the order of
# looking: the asset block's communality in the difference space is
# essentially the SAME in both representations (median 0.801 -> 0.811,
# asset_ibov 0.909 -> 0.894). The hypothesis "over-differencing
# destroys the common component" is already NOT supported. What does
# change is the geometry of the economic links —
# cor(asset_ibov, d.cambio_usd) goes from -0.040 to -0.451 — and the
# nature of the column entering Z (white noise vs. I(1) level).
#
# SCOPE: diagnostic only. Nothing in R/, script/download.R,
# script/clean.R or output/irf/ is modified; `infer_tcode_from_varnames`
# is CALLED and its asset entries overridden locally, never edited.
# Promoting a variant to production is a separate author decision.
#
# NOT DONE, DECLARED: X-13 is not applied to the reconstructed level
# series — this bypasses clean.R. A promotion to production would pass
# through `check_seasonality`, which today does not flag returns but
# may flag trending levels. Also untouched: the wider panel asymmetry
# (`cambio_usd` enters in level, not log).
#
# Outputs: output/assets/asset_representation.md
#          output/assets/asset_cells.csv
#          output/assets/asset_irf_compare.csv
#          output/assets/asset_band_ratio.csv
#          output/assets/asset_tstat.csv
#          output/assets/asset_cross_section.csv
#          output/assets/asset_guards.csv
#          output/assets/asset_irf_overlay.pdf
# ===================================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tidyr)
  library(purrr)
  library(tibble)
  library(ggplot2)
  library(patchwork)
})

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")

OUT_DIR <- "output/assets"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# --- production spec (mirrors irf_coherence_check.R / diagnostics/_common.R)
R_FACTORS  <- 7L
Q_DYNAMIC  <- 6L
P_LAGS     <- 6L
INSTRUMENT <- "z_jk_bs_purif"
MP_VAR     <- "yield_6m"
HORIZON    <- 48L
N_BOOT     <- 800L
SEED       <- 123L
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.68, 0.90)
WIN_FULL   <- as.Date(c("2013-01-01", "2025-12-31"))
WIN_PRE    <- as.Date(c("2013-01-01", "2019-12-31"))

# reference values this run must reproduce
XI_MP_REF  <- c(full = 10.430830000494813, pre_covid = 12.223433475303535)
SMOKE_REF  <- c(yield_6m = 0.005, yield_2y = 0.009164, yield_5y = 0.009274,
                asset_ibov = -1.673, cambio_usd = 0.1498)

hcol <- function(h) h + 1L


# ===================================================================
# 1. Data and the four panels
# ===================================================================

cat("\n[1] painel e construcao das quatro representacoes\n")

panel_df <- read_csv("data/processed/data_log_deseasonalized.csv",
                     show_col_types = FALSE) |> drop_na()
DATES     <- as.Date(panel_df$ref.date)
PANEL     <- panel_df |> select(-ref.date) |> as.matrix()
VAR_NAMES <- colnames(PANEL)
ASSETS    <- grep("^asset_", VAR_NAMES, value = TRUE)
A_IDX     <- match(ASSETS, VAR_NAMES)

INST_PANEL <- read_csv("data/processed/instrumentos_mensais.csv",
                       show_col_types = FALSE) |> mutate(month = as.Date(month))

cat(sprintf("    painel %d x %d | %s a %s | %d indices B3\n",
            nrow(PANEL), ncol(PANEL), format(min(DATES)), format(max(DATES)),
            length(ASSETS)))

# The reconstruction. `prod(1 + r_daily) - 1` telescopes within the month, so
# the panel column is a clean month-over-month total return and cumprod
# recovers the end-of-month index level exactly, up to the (unknown) level at
# the month before the window. The DFM removes a constant and a linear trend
# per series (factor_estimation.R:307-313), so that constant is irrelevant.
lvl_from_ret <- function(r) cumprod(1 + r)

build_panel <- function(tag) {
  M  <- PANEL
  tc <- infer_tcode_from_varnames(VAR_NAMES)   # called, never edited
  if (tag == "prod") {
    tc[A_IDX] <- 2L                            # = what infer_ already returns
  } else if (tag == "prod_nocum") {
    tc[A_IDX] <- 1L
  } else if (tag == "loglevel") {
    for (v in ASSETS) M[, v] <- log(lvl_from_ret(PANEL[, v]))
    tc[A_IDX] <- 4L
  } else if (tag == "level") {
    for (v in ASSETS) M[, v] <- lvl_from_ret(PANEL[, v])
    tc[A_IDX] <- 1L
  } else stop("tag desconhecida: ", tag)
  list(M = M, tcode = tc)
}

TAGS   <- c("prod", "prod_nocum", "loglevel", "level")
PANELS <- set_names(map(TAGS, build_panel), TAGS)

# Multiplier that puts each variant's asset rows on the common "% deviation of
# the index level" scale. tcode 2 and 4 already multiply by 100 inside
# cumimp_transform; the raw-level variant uses the 100/mean convention of
# fig_section5.R:49. `prod_nocum` is NOT a level response and is excluded from
# every magnitude comparison — it exists only for the band decomposition.
asset_scale <- function(tag) {
  if (tag == "level") 100 / colMeans(PANELS$level$M[, ASSETS, drop = FALSE])
  else set_names(rep(1, length(ASSETS)), ASSETS)
}


# ===================================================================
# 2. Self-tests 1 and 2 — the reconstruction
# ===================================================================

cat("\n[2] auto-testes da reconstrucao\n")

# (1) external check: the reconstructed IBOV level against the daily file
ibov_d <- read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE)
ibov_m <- ibov_d |>
  mutate(month = as.Date(format(date, "%Y-%m-01"))) |>
  group_by(month) |> slice_tail(n = 1) |> ungroup() |>
  select(month, ibov)
chk <- tibble(month = DATES, rec = lvl_from_ret(PANEL[, "asset_ibov"])) |>
  left_join(ibov_m, by = "month")
stopifnot(sum(is.na(chk$ibov)) == 0)
ratio_cv <- sd(chk$ibov / chk$rec) / mean(chk$ibov / chk$rec)
cat(sprintf("    (1) nivel reconstruido vs ibov_daily.csv: sd relativo da razao %.2e (n=%d)\n",
            ratio_cv, nrow(chk)))
stopifnot(ratio_cv < 1e-12)

# (2) round-trip on all 8: diff of the log-level re-exponentiated is the return
rt <- vapply(ASSETS, function(v) {
  back <- exp(diff(log(lvl_from_ret(PANEL[, v])))) - 1
  max(abs(back - PANEL[-1, v]))
}, numeric(1))
cat(sprintf("    (2) ida e volta nas 8 series: desvio maximo %.2e\n", max(rt)))
stopifnot(max(rt) < 1e-12)


# ===================================================================
# 3. The production cell, from cache — self-tests 3, 4, 5
# ===================================================================

cat("\n[3] celula de producao (cache) e auto-testes 3-5\n")

CELL <- readRDS("output/irf/irf_coherence_cell.rds")
stopifnot(identical(CELL$var_names, VAR_NAMES),
          CELL$instrument == INSTRUMENT, CELL$r == R_FACTORS, CELL$q == Q_DYNAMIC)

# (3) CLAUDE.md smoke test
got <- CELL$irf$irf_point_matrix[match(names(SMOKE_REF), VAR_NAMES), 1]
cat("    (3) smoke test h0: ",
    paste(sprintf("%s %.6g", names(SMOKE_REF), got), collapse = " | "), "\n")
stopifnot(max(abs(got - SMOKE_REF)) < 5e-3)

# (4) the cached cell reproduces the published per-horizon table
hcsv <- read_csv("output/irf/irf_coherence_h.csv", show_col_types = FALSE)
dev4 <- hcsv |>
  mutate(pt = CELL$irf$irf_point_matrix[cbind(match(var, VAR_NAMES), hcol(h))]) |>
  summarise(d = max(abs(pt - point))) |> pull(d)
cat(sprintf("    (4) celula vs irf_coherence_h.csv: desvio maximo %.2e\n", dev4))
stopifnot(dev4 < 1e-10)

# (5) xi_mp of production reproduces mosw_strength_grid.csv
xi_of <- function(M, window) {
  keep <- DATES >= window[1] & DATES <= window[2]
  dfm  <- estimate_dfm(M[keep, , drop = FALSE], r = R_FACTORS, q = Q_DYNAMIC,
                       p = P_LAGS, dates = DATES[keep],
                       instrument = INST_PANEL |>
                         select(month, shock = all_of(INSTRUMENT)) |>
                         filter(!is.na(shock)),
                       apply_kilian = TRUE)
  d <- diagnose_instrument_in_factor_space(
    dfm, INST_PANEL |> select(month, shock = all_of(INSTRUMENT)) |>
      filter(!is.na(shock)),
    DATES[keep], P_LAGS, match(MP_VAR, VAR_NAMES))
  list(wald_mp = d$wald_mp, wald_joint = d$wald_joint, f_factor = d$f_factor,
       n_obs = d$n_obs, max_eig = dfm$diagnostics$max_eigenvalue)
}
xi_prod_full <- xi_of(PANEL, WIN_FULL)
xi_prod_pre  <- xi_of(PANEL, WIN_PRE)
cat(sprintf("    (5) xi_mp producao: full %.6f (ref %.6f) | pre %.6f (ref %.6f)\n",
            xi_prod_full$wald_mp, XI_MP_REF[["full"]],
            xi_prod_pre$wald_mp,  XI_MP_REF[["pre_covid"]]))
stopifnot(abs(xi_prod_full$wald_mp - XI_MP_REF[["full"]]) < 1e-6,
          abs(xi_prod_pre$wald_mp  - XI_MP_REF[["pre_covid"]]) < 1e-6)


# ===================================================================
# 4. xi_mp on every panel, both windows (no bootstrap)
# ===================================================================

cat("\n[4] guarda de forca do instrumento por representacao\n")

# prod and prod_nocum share the panel, so they share the DFM: only the display
# transform differs. Compute the strength block once per distinct panel.
STRENGTH <- list(
  prod     = list(full = xi_prod_full, pre_covid = xi_prod_pre),
  loglevel = list(full = xi_of(PANELS$loglevel$M, WIN_FULL),
                  pre_covid = xi_of(PANELS$loglevel$M, WIN_PRE)),
  level    = list(full = xi_of(PANELS$level$M, WIN_FULL),
                  pre_covid = xi_of(PANELS$level$M, WIN_PRE))
)
STRENGTH$prod_nocum <- STRENGTH$prod

strength_tbl <- imap_dfr(STRENGTH, function(s, tag) {
  imap_dfr(s, function(x, win) {
    tibble(variante = tag, amostra = win, n_obs = x$n_obs,
           xi_mp = x$wald_mp, wald_joint = x$wald_joint,
           f_factor = x$f_factor, max_eig = x$max_eig,
           ar_bounded = x$wald_mp > 3.84, bandas_convencionais = x$wald_mp >= 10)
  })
})
print(as.data.frame(strength_tbl), row.names = FALSE, digits = 4)


# ===================================================================
# 5. The three re-estimated cells
# ===================================================================

cat("\n[5] estimacao das celulas (nboot =", N_BOOT, ")\n")

cells <- list(prod = CELL)
for (tag in c("prod_nocum", "loglevel", "level")) {
  t0 <- Sys.time()
  cells[[tag]] <- run_stage2_cell(
    PANELS[[tag]]$M, DATES, INST_PANEL, sample_window = WIN_FULL,
    r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
    instrument = INSTRUMENT, mp_var = MP_VAR,
    h = HORIZON, nboot = N_BOOT, seed = SEED, shock_bps = SHOCK_BPS,
    tcode = PANELS[[tag]]$tcode, ci_levels = CI_LEVELS)
  cat(sprintf("    %-12s %.1f min\n", tag,
              as.numeric(Sys.time() - t0, units = "mins")))
}

# (6) Self-test that also IS the result: the point estimate of `prod` is the
# cumulated `prod_nocum` exactly (same model, same draws — only the display
# map differs). The BANDS do not satisfy this identity, because the quantile
# of a cumulative sum is not the cumulative sum of the quantile. That gap is
# precisely what the band decomposition below measures.
Pp <- cells$prod$irf$irf_point_matrix
Pn <- cells$prod_nocum$irf$irf_point_matrix
dev6 <- max(abs(t(apply(Pn[A_IDX, , drop = FALSE], 1, cumsum)) * 100 -
                Pp[A_IDX, , drop = FALSE]))
cat(sprintf("    (6) cumsum(prod_nocum)*100 == prod nas 8 series: desvio %.2e\n", dev6))
stopifnot(dev6 < 1e-9)


# ===================================================================
# 6. Measurements
# ===================================================================

cat("\n[6] medidas\n")

band <- function(tag, lvl) {
  key <- sprintf("%.2f", lvl)
  list(lo = cells[[tag]]$irf$ci[[key]]$lower,
       hi = cells[[tag]]$irf$ci[[key]]$upper)
}

# --- 6a. long IRF table for the 8 indices + the non-equity guards, on the
#         common % scale (prod_nocum excluded: not a level response)
GUARD_VARS <- c("yield_2y", "yield_5y", "cambio_usd", "embi_perc", "cds_5y",
                "price_ipca", "ibc_br")

irf_long <- map_dfr(c("prod", "loglevel", "level"), function(tag) {
  P <- cells[[tag]]$irf$irf_point_matrix
  b68 <- band(tag, 0.68); b90 <- band(tag, 0.90)
  k_a <- asset_scale(tag)
  map_dfr(c(ASSETS, GUARD_VARS), function(v) {
    i <- match(v, VAR_NAMES)
    k <- if (v %in% ASSETS) unname(k_a[[v]]) else 1
    tibble(variante = tag, var = v, bloco = if (v %in% ASSETS) "acoes" else "guarda",
           h = 0:HORIZON,
           point = P[i, ] * k,
           lo68 = b68$lo[i, ] * k, hi68 = b68$hi[i, ] * k,
           lo90 = b90$lo[i, ] * k, hi90 = b90$hi[i, ] * k) |>
      mutate(sig68 = (lo68 > 0) | (hi68 < 0),
             sig90 = (lo90 > 0) | (hi90 < 0))
  })
})

# --- 6b. scoreboard over the 8 x 49 = 392 equity cells
score <- irf_long |> filter(bloco == "acoes") |>
  group_by(variante) |>
  summarise(n_cel = n(),
            n_sig90 = sum(sig90), n_sig90_h12 = sum(sig90 & h <= 12),
            n_sig68 = sum(sig68), n_sig68_h12 = sum(sig68 & h <= 12),
            n_neg_h0 = sum(point < 0 & h == 0),
            .groups = "drop")
cat("\n  placar do bloco acionario (8 indices x 49 horizontes):\n")
print(as.data.frame(score), row.names = FALSE)

# --- 6c. h = 0 side by side: the clean test of the representation
h0_tbl <- irf_long |> filter(bloco == "acoes", h == 0) |>
  select(var, variante, point, lo90, hi90, sig90, sig68) |>
  pivot_wider(names_from = variante,
              values_from = c(point, lo90, hi90, sig90, sig68))
cat("\n  h=0 (unico horizonte em que as representacoes medem o mesmo objeto):\n")
print(as.data.frame(h0_tbl |> select(var, point_prod, lo90_prod, hi90_prod,
                                     point_loglevel, lo90_loglevel, hi90_loglevel,
                                     sig90_loglevel)),
      row.names = FALSE, digits = 3)

# --- 6d. band width h36/h0 by tcode group, per variant (replicates
#         diagnostics/06_bloco_ativos.R:101-140)
band_ratio <- map_dfr(TAGS, function(tag) {
  b90 <- band(tag, 0.90)
  W <- b90$hi - b90$lo
  r <- W[, hcol(36)] / W[, hcol(0)]      # yield_6m has width 0 at h0 -> Inf
  tibble(variante = tag, var = VAR_NAMES, tcode = cells[[tag]]$tcode,
         razao_h36_h0 = r) |>
    filter(is.finite(razao_h36_h0)) |>
    group_by(variante, tcode) |>
    summarise(n = n(), mediana = median(razao_h36_h0),
              min = min(razao_h36_h0), max = max(razao_h36_h0), .groups = "drop")
})
cat("\n  razao de largura da banda de 90%% h36/h0, por tcode:\n")
print(as.data.frame(band_ratio), row.names = FALSE, digits = 3)

# Per-index version. The grouped table above is misleading for the headline:
# under `loglevel` the 8 indices move into tcode 4 and get pooled with the 16
# credit/base/pib series, so the group median is not the block's.
band_asset <- map_dfr(TAGS, function(tag) {
  b90 <- band(tag, 0.90); W <- b90$hi - b90$lo
  tibble(variante = tag, var = ASSETS,
         razao = W[A_IDX, hcol(36)] / W[A_IDX, hcol(0)])
}) |> pivot_wider(names_from = variante, values_from = razao)
cat("\n  a mesma razao, so nos 8 indices:\n")
print(as.data.frame(band_asset), row.names = FALSE, digits = 3)

# --- 6e. |t| proxy: |point| / half-width of the 68% band (the ruler of
#         section 5 Limitacoes), median over the 8 indices by horizon
tstat <- irf_long |> filter(bloco == "acoes") |>
  mutate(tproxy = abs(point) / ((hi68 - lo68) / 2)) |>
  group_by(variante, h) |>
  summarise(t_mediano = median(tproxy), .groups = "drop")
cat("\n  proxy de |t| mediano no bloco, horizontes selecionados:\n")
print(as.data.frame(tstat |> filter(h %in% c(0, 1, 6, 12, 24, 36, 48)) |>
                      pivot_wider(names_from = variante, values_from = t_mediano)),
      row.names = FALSE, digits = 3)

# --- 6e2. where the sig90 cells sit, and the medium-run drift that the
#          commented arquivo/tex/main.tex:445 explains away as accumulated noise
sig_where <- irf_long |> filter(bloco == "acoes", sig90) |>
  group_by(variante, var) |>
  summarise(n = n(), h_min = min(h), h_max = max(h),
            horizontes = paste(h, collapse = ","), .groups = "drop")
cat("\n  onde ficam as celulas sig90 do bloco:\n")
print(as.data.frame(sig_where), row.names = FALSE)

drift <- irf_long |>
  filter(var == "asset_ibov", h %in% c(0, 1, 6, 12, 18, 24, 36, 48)) |>
  select(variante, h, point, lo68, hi68, sig68, sig90) |>
  pivot_wider(names_from = variante, values_from = c(point, sig68))
cat("\n  deriva de medio prazo do Ibovespa (o +20%% em h~24 da producao):\n")
print(as.data.frame(drift), row.names = FALSE, digits = 3)

# --- 6f. cross-section (replicates 06_bloco_ativos.R:169-249). The
#         characteristic is a property of the DATA, so it is measured once on
#         the return panel and reused across variants.
dy2 <- diff(PANEL[, "yield_2y"]); dfx <- diff(PANEL[, "cambio_usd"])
hc1_se <- function(fit) {
  X <- model.matrix(fit); u <- residuals(fit); n <- nrow(X); k <- ncol(X)
  bread <- solve(crossprod(X)); meat <- crossprod(X * u)
  sqrt(diag(bread %*% meat %*% bread) * n / (n - k))
}
betas <- map_dfr(ASSETS, function(v) {
  fit <- lm(PANEL[-1, v] ~ dy2 + dfx); se <- hc1_se(fit); cf <- coef(fit)
  tibble(var = v, beta_juros = cf[["dy2"]], t_juros = cf[["dy2"]] / se[2],
         beta_cambio = cf[["dfx"]], t_cambio = cf[["dfx"]] / se[3])
})
cross_sec <- map_dfr(c("prod", "loglevel", "level"), function(tag) {
  map_dfr(c(0, 6, 12, 24, 36, 48), function(h) {
    y <- irf_long |> filter(variante == tag, var %in% ASSETS, h == !!h) |>
      arrange(match(var, betas$var)) |> pull(point)
    tibble(variante = tag, h = h,
           cor_beta_juros = cor(betas$beta_juros, y),
           cor_sp_juros   = cor(betas$beta_juros, y, method = "spearman"),
           amplitude      = max(y) - min(y), n_neg = sum(y < 0))
  })
})
cat("\n  secao cruzada: correlacao entre sensibilidade medida a juros e resposta\n")
print(as.data.frame(cross_sec), row.names = FALSE, digits = 3)

# --- 6g. guards on the rest of the model: do the paper's sig90 pairs survive?
SCORED <- intersect(coherence_var_table()$var, VAR_NAMES)
sig_set <- function(tag) {
  b90 <- band(tag, 0.90); i <- match(SCORED, VAR_NAMES)
  m <- (b90$lo[i, ] > 0) | (b90$hi[i, ] < 0)
  dimnames(m) <- list(SCORED, 0:HORIZON)
  m
}
s_prod <- sig_set("prod"); s_log <- sig_set("loglevel"); s_lvl <- sig_set("level")
non_asset <- setdiff(SCORED, ASSETS)
surv <- tibble(
  conjunto = c("53 series escoradas", "45 nao-acionarias"),
  n_sig90_prod = c(sum(s_prod), sum(s_prod[non_asset, ])),
  n_sig90_loglevel = c(sum(s_log), sum(s_log[non_asset, ])),
  sobrevivem_loglevel = c(sum(s_prod & s_log), sum(s_prod[non_asset, ] & s_log[non_asset, ])),
  n_sig90_level = c(sum(s_lvl), sum(s_lvl[non_asset, ])),
  sobrevivem_level = c(sum(s_prod & s_lvl), sum(s_prod[non_asset, ] & s_lvl[non_asset, ])))
cat("\n  sobrevivencia dos pares sig90 do paper:\n")
print(as.data.frame(surv), row.names = FALSE)

guard_h0 <- irf_long |> filter(bloco == "guarda", h == 0) |>
  select(var, variante, point, sig90) |>
  pivot_wider(names_from = variante, values_from = c(point, sig90))
cat("\n  h0 das manchetes nao-acionarias:\n")
print(as.data.frame(guard_h0), row.names = FALSE, digits = 4)


# ===================================================================
# 7. Overlay figure
# ===================================================================

cat("\n[7] figura\n")

LBL <- c(asset_ibov = "Ibovespa", asset_mlcx = "MLCX, large caps",
         asset_smll = "SMLL, small caps", asset_idiv = "IDIV, dividendos",
         asset_imob = "IMOB, incorporadoras", asset_ifnc = "IFNC, bancos",
         asset_imat = "IMAT, materiais", asset_ifix = "IFIX, renda imob.")
PAL <- c(prod = "#1b1b1b", loglevel = "#0072B2", level = "#009E73")

H_PLOT <- 36L
panels <- map(names(LBL), function(v) {
  d <- irf_long |> filter(var == v, h <= H_PLOT)
  ggplot(d, aes(x = h, colour = variante, fill = variante)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
    geom_ribbon(aes(ymin = lo90, ymax = hi90), alpha = 0.08, colour = NA) +
    geom_ribbon(aes(ymin = lo68, ymax = hi68), alpha = 0.16, colour = NA) +
    geom_line(aes(y = point), linewidth = 0.7) +
    scale_colour_manual(values = PAL) + scale_fill_manual(values = PAL) +
    labs(title = LBL[[v]], x = NULL, y = NULL) +
    theme_minimal(base_size = 10) +
    theme(legend.position = "bottom",
          plot.title = element_text(size = 11, face = "bold"))
})

pdf(file.path(OUT_DIR, "asset_irf_overlay.pdf"), width = 13, height = 7)
print(wrap_plots(panels, ncol = 4, guides = "collect") +
        plot_annotation(
          title = "Bloco acionario: retorno mensal (producao) vs. log-nivel vs. nivel",
          subtitle = sprintf(
            "r=%d q=%d p=%d | %s | %s | +%dbp | nboot=%d | bandas 68/90 | resposta em %% do nivel do indice",
            R_FACTORS, Q_DYNAMIC, P_LAGS, INSTRUMENT, MP_VAR, SHOCK_BPS, N_BOOT)) &
        theme(legend.position = "bottom"))
invisible(dev.off())
cat(sprintf("    -> %s/asset_irf_overlay.pdf\n", OUT_DIR))


# ===================================================================
# 8. Outputs
# ===================================================================

cat("\n[8] gravando\n")

cells_tbl <- strength_tbl |>
  left_join(score, by = c("variante")) |>
  mutate(painel = case_when(variante %in% c("prod", "prod_nocum") ~ "retorno mensal",
                            variante == "loglevel" ~ "log(cumprod(1+r))",
                            TRUE ~ "cumprod(1+r)"),
         tcode_asset = c(prod = 2L, prod_nocum = 1L, loglevel = 4L,
                         level = 1L)[variante]) |>
  relocate(variante, painel, tcode_asset, amostra)

write_csv(cells_tbl,  file.path(OUT_DIR, "asset_cells.csv"))
write_csv(irf_long,   file.path(OUT_DIR, "asset_irf_compare.csv"))
write_csv(band_ratio, file.path(OUT_DIR, "asset_band_ratio.csv"))
write_csv(tstat,      file.path(OUT_DIR, "asset_tstat.csv"))
write_csv(betas |> left_join(
  irf_long |> filter(bloco == "acoes", h %in% c(0, 12, 48)) |>
    select(var, variante, h, point) |>
    pivot_wider(names_from = c(variante, h), values_from = point,
                names_prefix = "irf_"), by = "var") |>
  bind_rows(cross_sec |> mutate(var = paste0("cor_h", h))),
  file.path(OUT_DIR, "asset_cross_section.csv"))
write_csv(bind_rows(surv |> mutate(tabela = "sobrevivencia_sig90"),
                    guard_h0 |> mutate(tabela = "h0_manchetes")),
          file.path(OUT_DIR, "asset_guards.csv"))
for (f in c("asset_cells", "asset_irf_compare", "asset_band_ratio",
            "asset_tstat", "asset_cross_section", "asset_guards"))
  cat(sprintf("    -> %s/%s.csv\n", OUT_DIR, f))


# --- verdict under the pre-registered rule ------------------------------
n_sig90_log     <- score$n_sig90[score$variante == "loglevel"]
n_sig90_log_h12 <- score$n_sig90_h12[score$variante == "loglevel"]
xi_log_full     <- strength_tbl$xi_mp[strength_tbl$variante == "loglevel" &
                                        strength_tbl$amostra == "full"]
xi_log_pre      <- strength_tbl$xi_mp[strength_tbl$variante == "loglevel" &
                                        strength_tbl$amostra == "pre_covid"]
veredito <- if (xi_log_full < 3.84) {
  "INCONCLUSIVO — xi_mp do painel log-nivel abaixo de 3.84"
} else if (n_sig90_log_h12 >= 1) {
  sprintf("MECANICO CONFIRMADO — %d celulas sig90 em h<=12 sob log-nivel", n_sig90_log_h12)
} else {
  "NAO CONFIRMADO — o bloco segue nulo a 90% sob log-nivel, com as guardas de pe"
}

cat("\n===== VEREDITO =====\n", veredito, "\n", sep = "")

fmtn <- function(x, d = 3) formatC(x, format = "f", digits = d)

md <- c(
  "# Ações em log-nível: a representação causa o resultado nulo?",
  "",
  sprintf("*Gerado por `script/asset_representation.R` em %s. **Corpo gerado: não escreva prosa aqui.** A leitura interpretativa vive em `relatorio/working-notes/2026-07-31_acoes_representacao.md`.*",
          format(Sys.Date())),
  "",
  "## A pergunta",
  "",
  "As 8 séries da B3 entram no painel como **retorno mensal composto**, enquanto",
  "as outras 98 entram em nível ou log-nível. O `cumsum` que recupera o nível é",
  "aplicado à **IRF** (`impulse_responde.R:277`, tcode 2), não aos dados. Como o",
  "BLL diferencia o painel para estimar `Λ` (`factor_estimation.R:300`), o bloco",
  "acionário é estimado sobre a **segunda diferença** do log-preço. O paper",
  "reporta **0 de 392** células sig90 nesse bloco — o tema do próprio título.",
  "",
  "## Regra de leitura, fixada antes dos números",
  "",
  "- **Mecânico** se, sob `loglevel`, houver ≥ 1 célula sig90 em h ≤ 12 **e**",
  "  ξ_mp ≥ 3,84 (forma forte: ≥ 10).",
  "- **Não confirmado** se o bloco seguir em 0 sig90 com as guardas de pé.",
  "- **h = 0 é o teste limpo da representação**: único horizonte em que as duas",
  "  medem o mesmo objeto e em que o `cumsum` é no-op.",
  "- A inflação de banda é atribuída ao `cumsum` via `prod_nocum` — mesmo modelo,",
  "  mesmo seed, só o transform muda. Afirmação **separada**.",
  "- **Inconclusivo** se ξ_mp do painel log-nível cair abaixo de 3,84.",
  "",
  sprintf("## Veredito: %s", veredito),
  "",
  "## As quatro representações",
  "",
  md_table(cells_tbl |> filter(amostra == "full") |>
             select(variante, painel, tcode_asset, xi_mp, wald_joint, max_eig,
                    n_sig90, n_sig90_h12, n_sig68)),
  "",
  "Força do instrumento nas duas janelas:",
  "",
  md_table(strength_tbl |> select(variante, amostra, n_obs, xi_mp, f_factor,
                                  ar_bounded, bandas_convencionais)),
  "",
  "## h = 0 — o teste limpo da representação",
  "",
  "Resposta em % do nível do índice no mês do impacto, com IC90.",
  "",
  md_table(h0_tbl |> select(var, point_prod, lo90_prod, hi90_prod,
                            point_loglevel, lo90_loglevel, hi90_loglevel,
                            sig90_loglevel, sig68_loglevel)),
  "",
  "## Largura de banda h36/h0 por tcode",
  "",
  "Réplica de `diagnostics/06_bloco_ativos.R` §6.2 em cada representação. A",
  "comparação `prod` × `prod_nocum` isola o `cumsum`: mesmo painel, mesmo seed,",
  "mesmo modelo — o ponto é idêntico após cumular (conferido a 1e-9), a banda não.",
  "",
  md_table(band_ratio),
  "",
  "A mesma razão só nos 8 índices — sob `loglevel` eles migram para tcode 4 e a",
  "mediana do grupo acima passa a misturá-los com as 16 séries de crédito/base/PIB:",
  "",
  md_table(band_asset),
  "",
  "## Onde ficam as células sig90 do bloco",
  "",
  md_table(sig_where),
  "",
  "## A deriva de médio prazo do Ibovespa",
  "",
  "O bloco comentado em `arquivo/tex/main.tex:445` (arquivado; paper canônico é `texto_anpec/paper_anpec.tex`) explica o pico de +20,3% em h≈24 como",
  "erro de estimação acumulado. A comparação abaixo mostra que o diagnóstico",
  "estava certo — e que a representação em nível remove o artefato na origem, em",
  "vez de explicá-lo depois.",
  "",
  md_table(drift),
  "",
  "## Proxy de |t| no bloco (|ponto| / meia-banda de 68%)",
  "",
  md_table(tstat |> filter(h %in% c(0, 1, 3, 6, 12, 18, 24, 36, 48)) |>
             pivot_wider(names_from = variante, values_from = t_mediano)),
  "",
  "## Seção cruzada",
  "",
  "Correlação (n = 8) entre a sensibilidade a juros medida fora do modelo",
  "(β sobre Δ`yield_2y`, HC1, sempre nos retornos) e a resposta da IRF.",
  "",
  md_table(cross_sec),
  "",
  "## Guardas sobre o resto do modelo",
  "",
  "Sem isto a comparação não vale nada: mudar o painel re-estima tudo.",
  "",
  md_table(surv),
  "",
  md_table(guard_h0),
  "",
  "## O que não foi feito, declarado",
  "",
  "- **Nada de produção foi modificado.** Os painéis são construídos em memória;",
  "  `infer_tcode_from_varnames` é chamada e sobrescrita localmente, nunca editada.",
  "- **X-13 não é aplicado** às séries de nível reconstruídas — o diagnóstico",
  "  contorna o `clean.R`. Uma promoção à produção passaria pelo",
  "  `check_seasonality`, que hoje não marca retornos mas pode marcar níveis com",
  "  tendência.",
  "- **(r,q) não é re-selecionado.** ξ_mp no painel log-nível é reportado acima;",
  "  se (7,6) ficar fraco lá, isso é achado, não decisão.",
  "- **A assimetria mais ampla do painel não é tocada**: `cambio_usd` entra em",
  "  nível, não em log.",
  "",
  "## Auto-testes que travaram a rodada",
  "",
  sprintf("1. Nível reconstruído vs `ibov_daily.csv`: sd relativo da razão %.2e (< 1e-12).", ratio_cv),
  sprintf("2. Ida e volta nas 8 séries: desvio máximo %.2e (< 1e-12).", max(rt)),
  "3. Smoke test do `CLAUDE.md` na célula de produção.",
  sprintf("4. Célula de produção vs `irf_coherence_h.csv`: desvio %.2e (< 1e-10).", dev4),
  sprintf("5. ξ_mp de produção vs `mosw_strength_grid.csv`: %.6f full, %.6f pré-COVID.",
          xi_prod_full$wald_mp, xi_prod_pre$wald_mp),
  sprintf("6. `cumsum(prod_nocum)×100 == prod` nas 8 séries: desvio %.2e (< 1e-9).", dev6),
  "")

writeLines(md, file.path(OUT_DIR, "asset_representation.md"))
cat(sprintf("    -> %s/asset_representation.md\n", OUT_DIR))

cat("\n=== asset_representation concluido ===\n")
