# ===================================================================
# Are the 7 static factors I(1)? Are they cointegrated? And is the
# medium-run reversal in the IRFs economics or arithmetic?
#
# Council review of 2026-07-31 (relatorio/council_2026-07-31.md:74).
# The harsh referee's charge, in one line: the reversal of the curve,
# the Selic, CDS, EMBI and all seven credit cuts at h ~ 20-35 is
# exactly what a dominant complex eigenvalue pair with a ~60-month
# period produces MECHANICALLY, with no economic content. The
# methodologist arrives at the same place from a different angle and
# asks for ADF/KPSS/PP. BLL standardization fixes the scale of the
# PCA, not the stationarity of the factor VAR.
#
# WHAT ALREADY EXISTS, AND IS NOT REDONE HERE. Tarefa 5 of the
# 2026-07-28 audit round (diagnostics/05_persistencia_fatores.R,
# diagnostico_dfm.md:439-459) already reports the top-5 moduli of the
# 42x42 companion and already concludes, in prose, "a corcova e
# mecanica". This script is the completion of that, not a repeat:
#
#   (i)   unit roots on the FACTORS. t5_4 tests the 106 panel series,
#         not the 7 factors, and those are two different objects.
#   (ii)  Phillips-Perron. The repo has ADF and KPSS and nothing else.
#   (iii) COINTEGRATION. ca.jo / vars appear nowhere in the repo.
#   (iv)  the FULL 42-eigenvalue spectrum with arguments and implied
#         periods persisted to CSV. t5_1 saves 5 moduli; the period of
#         117.9 months is stated in the markdown and computed nowhere.
#
# READING RULE, FIXED BEFORE THE NUMBERS EXIST (house convention;
# cf. the vertex sweep and the sovereign-confound script):
#
#  R1. The medium-run reversal counts as economic content only if it
#      survives the mechanical benchmark. The benchmark is the quarter
#      cycle of the dominant complex pair (the peak of a damped
#      oscillation) and the half cycle (its first sign change). If the
#      reversal horizons measured in output/irf/irf_coherence_h.csv
#      fall within +/-25% of those marks, the reversal is NOT
#      independent evidence and section 4 has to say so.
#
#      ORDER OF LOOKING, DECLARED. Only block 5 was pre-registered.
#      It came out 10 of 14 — a coincidence of periods, which is
#      suggestive and nothing more. Blocks 6 and 7 were written AFTER
#      seeing that, to turn the coincidence into a test:
#        block 6 re-estimates at p in {1,4,6} and asks whether the
#          trough MOVES when the dominant pair moves;
#        block 7 deletes the dominant pair from B by spectral
#          decomposition, re-estimating nothing, and asks whether the
#          trough survives. This is the sharp one.
#      They disagree in an informative way, and the note says so.
#  R2. Cointegration with 0 < rank < 7 is the EXPECTED result and is
#      not a defect. Alessi-Kerssenfischer section 2.2 estimates "a
#      conventional VAR on the (nonstationary) static factors",
#      justified by Sims-Stock-Watson (1990) — the unrestricted levels
#      VAR is consistent under cointegration — and by BLL (2016b),
#      who show the levels VAR BEATS a VECM for SHORT-run impulse
#      responses. Both keys are already in references.bib.
#  R3. But that defence is about the short run, and that is where it
#      costs. The point estimate is consistent; the medium run
#      (h ~ 20-48) is where BLL's argument does not reach and where
#      the complex pair dominates. Do not soften this.
#
# Nothing in R/modeling/ or R/identification/ is modified. The DFM is
# re-estimated here (cheap, no bootstrap) because
# output/irf/irf_coherence_cell.rds stores the IRF object, not the DFM.
#
# Outputs: output/factors/factor_companion_spectrum.csv
#          output/factors/factor_unit_root.csv
#          output/factors/panel_unit_root_pp.csv
#          output/factors/factor_cointegration.csv
#          output/factors/factor_lag_sensitivity_irf.csv
#          output/factors/factor_irf_mode_decomposition.csv
#          output/factors/factor_stationarity.md
# ===================================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tidyr)
  library(urca)
})

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")

set.seed(20260731)


# ---- Config: production spec (script/irf_coherence_check.R) --------

R_FACTORS <- 7L
Q_DYNAMIC <- 6L
P_LAGS    <- 6L
INSTRUMENT <- "z_jk_bs_purif"
MP_VAR     <- "yield_6m"

P_GRID <- c(1L, 4L, 6L)   # BIC/HQ pick 1, AIC picks 4, production is 6
K_GRID <- c(2L, 4L, 6L)   # Johansen lag order; the rank is lag-sensitive

DATA_PATH <- "data/processed/data_log_deseasonalized.csv"
INST_PATH <- "data/processed/instrumentos_mensais.csv"
CELL_PATH <- "output/irf/irf_coherence_cell.rds"
T51_PATH  <- "diagnostics/output/t5_1_autovalores.csv"
T54_PATH  <- "diagnostics/output/t5_4_raiz_unitaria.csv"
HCSV_PATH <- "output/irf/irf_coherence_h.csv"
OUT_DIR   <- "output/factors"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

cat("=== Factor stationarity, cointegration and companion spectrum ===\n\n")


# ===================================================================
# 0. Panel, instrument, DFM
# ===================================================================

panel_df <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
DATES <- as.Date(panel_df$ref.date)
PANEL <- panel_df |> select(-ref.date) |> as.matrix()
VAR_NAMES <- colnames(PANEL)
TCODE <- infer_tcode_from_varnames(VAR_NAMES)

inst_df <- read_csv(INST_PATH, show_col_types = FALSE) |>
  mutate(month = as.Date(month)) |>
  select(month, shock = all_of(INSTRUMENT)) |>
  filter(!is.na(shock))

cat(sprintf("[0] panel %d x %d | %s to %s | instrument %s\n",
            nrow(PANEL), ncol(PANEL),
            format(min(DATES)), format(max(DATES)), INSTRUMENT))

dfm <- estimate_dfm(PANEL, R_FACTORS, Q_DYNAMIC, P_LAGS,
                    dates = DATES, instrument = inst_df,
                    apply_kilian = TRUE)

Fh <- dfm$static_factors
colnames(Fh) <- paste0("F", seq_len(ncol(Fh)))
cat(sprintf("    factors %d x %d | max |eig| = %.6f\n",
            nrow(Fh), ncol(Fh), dfm$diagnostics$max_eigenvalue))


# ===================================================================
# 1. Full companion spectrum
# ===================================================================
cat("\n[1] companion spectrum\n")

#' Modulus, argument and implied cycle length of every eigenvalue
#'
#' A complex pair lambda = rho * exp(+/- i*theta) contributes
#' rho^h * cos(theta*h + phi) to the impulse response: the oscillation
#' peaks at a quarter cycle and first changes sign at a half cycle.
#' Those two horizons are the mechanical benchmark of reading rule R1.
spectrum_table <- function(A, label, p) {
  ev  <- eigen(A)$values
  ord <- order(Mod(ev), decreasing = TRUE)
  ev  <- ev[ord]
  mo  <- Mod(ev)
  ar  <- Arg(ev)
  per <- ifelse(abs(ar) < 1e-10, NA_real_, 2 * pi / abs(ar))
  data.frame(
    matriz = label, p = p, ordem = seq_along(ev),
    re = Re(ev), im = Im(ev), modulo = mo, arg = ar,
    complexo = abs(Im(ev)) > 1e-10,
    periodo_meses = per,
    quarto_ciclo = per / 4,
    meia_volta_ciclo = per / 2,
    meia_vida_meses = log(0.5) / log(pmin(mo, 1 - 1e-12))
  )
}

spec_rows <- list()
for (pp in P_GRID) {
  if (pp == P_LAGS) {
    A_ols <- dfm$companion_matrix
    A_kil <- dfm$companion_corrected
  } else {
    A_ols <- estimate_var_ols(Fh, pp)$companion
    A_kil <- estimate_corrected_var(Fh, pp)$companion
  }
  spec_rows[[length(spec_rows) + 1]] <- spectrum_table(A_ols, "OLS", pp)
  spec_rows[[length(spec_rows) + 1]] <- spectrum_table(A_kil, "Kilian", pp)
}
spec <- bind_rows(spec_rows)

prod_ols <- spec |> filter(matriz == "OLS", p == P_LAGS)
cat("    production (OLS, p = 6), five largest:\n")
print(as.data.frame(prod_ols |> slice(1:5) |>
        select(ordem, modulo, complexo, periodo_meses, quarto_ciclo,
               meia_volta_ciclo, meia_vida_meses)),
      row.names = FALSE, digits = 5)

DOM <- prod_ols |> slice(1)
cat(sprintf("\n    dominant root: |lambda| = %.6f, %s",
            DOM$modulo, ifelse(DOM$complexo, "COMPLEX", "real")))
if (DOM$complexo) {
  cat(sprintf(", period %.1f months -> quarter cycle %.1f, half cycle %.1f\n",
              DOM$periodo_meses, DOM$quarto_ciclo, DOM$meia_volta_ciclo))
} else cat("\n")

cat(sprintf("    |lambda| > 0.97: %d | > 0.90: %d | >= 1 (explosive): %d\n",
            sum(prod_ols$modulo > 0.97), sum(prod_ols$modulo > 0.90),
            sum(prod_ols$modulo >= 1)))

cat("\n    max |eig| by p and matrix:\n")
print(as.data.frame(spec |> group_by(matriz, p) |>
        summarise(max_mod = max(modulo),
                  n_complexo = sum(complexo),
                  per_dominante = periodo_meses[which.max(modulo)],
                  .groups = "drop")),
      row.names = FALSE, digits = 5)

write_csv(spec, file.path(OUT_DIR, "factor_companion_spectrum.csv"))
cat(sprintf("    -> %s/factor_companion_spectrum.csv (%d rows)\n",
            OUT_DIR, nrow(spec)))


# --- Self-test 1: the five largest moduli must match Tarefa 5 -------
if (file.exists(T51_PATH)) {
  t51 <- read_csv(T51_PATH, show_col_types = FALSE)
  mine_ols <- prod_ols$modulo[1:5]
  mine_kil <- (spec |> filter(matriz == "Kilian", p == P_LAGS))$modulo[1:5]
  d_ols <- max(abs(mine_ols - t51$modulo_OLS))
  d_kil <- max(abs(mine_kil - t51$modulo_Kilian))
  cat(sprintf("    self-test vs %s: max |diff| OLS %.3g, Kilian %.3g\n",
              T51_PATH, d_ols, d_kil))
  stopifnot(d_ols < 1e-10, d_kil < 1e-10)
} else {
  cat("    (t5_1_autovalores.csv absent - self-test skipped)\n")
}

# --- Self-test 2: max modulus against the DFM object and the cell ---
stopifnot(abs(max(prod_ols$modulo) - dfm$diagnostics$max_eigenvalue) < 1e-12)
if (file.exists(CELL_PATH)) {
  cell <- readRDS(CELL_PATH)
  stopifnot(cell$instrument == INSTRUMENT, cell$r == R_FACTORS,
            cell$q == Q_DYNAMIC, cell$p == P_LAGS)
  cat(sprintf("    self-test vs %s: max |eig| %.6f vs %.6f\n",
              CELL_PATH, max(prod_ols$modulo), cell$dfm_max_eig))
  stopifnot(abs(max(prod_ols$modulo) - cell$dfm_max_eig) < 1e-6)
} else {
  cell <- NULL
  cat("    (irf_coherence_cell.rds absent - self-test skipped)\n")
}


# ===================================================================
# 2. Unit roots on the 7 factors — ADF, PP, KPSS, level and difference
# ===================================================================
cat("\n[2] unit roots on the factors\n")

#' One (test, specification) applied to one series
#'
#' Returns the statistic, the 5% critical value and the decision in the
#' direction each test actually points: ADF and PP reject a unit root
#' when the statistic is BELOW the critical value, KPSS rejects
#' stationarity when it is ABOVE.
run_ur <- function(x, test, spec) {
  out <- tryCatch({
    if (test == "ADF") {
      s <- summary(ur.df(x, type = if (spec == "trend") "trend" else "drift",
                         selectlags = "AIC"))
      list(stat = as.numeric(s@teststat[1]), cv = as.numeric(s@cval[1, "5pct"]),
           h0 = "raiz unitaria", rejeita = as.numeric(s@teststat[1]) <
                                            as.numeric(s@cval[1, "5pct"]))
    } else if (test == "PP") {
      s <- ur.pp(x, type = "Z-tau",
                 model = if (spec == "trend") "trend" else "constant",
                 lags = "short")
      list(stat = as.numeric(s@teststat), cv = as.numeric(s@cval[1, "5pct"]),
           h0 = "raiz unitaria", rejeita = as.numeric(s@teststat) <
                                            as.numeric(s@cval[1, "5pct"]))
    } else {
      s <- ur.kpss(x, type = if (spec == "trend") "tau" else "mu",
                   lags = "short")
      list(stat = as.numeric(s@teststat), cv = as.numeric(s@cval[1, "5pct"]),
           h0 = "estacionaria", rejeita = as.numeric(s@teststat) >
                                            as.numeric(s@cval[1, "5pct"]))
    }
  }, error = function(e) list(stat = NA_real_, cv = NA_real_,
                              h0 = NA_character_, rejeita = NA))
  out
}

fac_rows <- list()
for (j in seq_len(ncol(Fh))) {
  for (tr in c("nivel", "diferenca")) {
    x <- if (tr == "nivel") Fh[, j] else diff(Fh[, j])
    for (tst in c("ADF", "PP", "KPSS")) {
      for (spc in c("drift", "trend")) {
        rr <- run_ur(x, tst, spc)
        fac_rows[[length(fac_rows) + 1]] <- data.frame(
          fator = colnames(Fh)[j], transf = tr, teste = tst,
          spec = spc, stat = rr$stat, cv5 = rr$cv, h0 = rr$h0,
          rejeita_h0_5pct = rr$rejeita
        )
      }
    }
  }
}
fac <- bind_rows(fac_rows)

# Verdict per factor and transformation, on the drift/mu specification
# (the one t5_4 uses), by ADF+KPSS agreement, with PP recorded beside.
ver <- fac |>
  filter(spec == "drift") |>
  select(fator, transf, teste, rejeita_h0_5pct) |>
  pivot_wider(names_from = teste, values_from = rejeita_h0_5pct) |>
  mutate(veredito = case_when(
    !ADF &  KPSS ~ "I(1) - ADF e KPSS concordam",
     ADF & !KPSS ~ "I(0) - ADF e KPSS concordam",
    TRUE ~ "ambiguo"),
    pp_concorda_adf = PP == ADF)

cat("    ADF/PP/KPSS at 5%, drift/mu specification:\n")
print(as.data.frame(ver), row.names = FALSE)

n_i1 <- sum(ver$veredito[ver$transf == "nivel"] == "I(1) - ADF e KPSS concordam")
n_d0 <- sum(ver$veredito[ver$transf == "diferenca"] == "I(0) - ADF e KPSS concordam")
cat(sprintf("\n    levels I(1): %d of %d | differences I(0): %d of %d\n",
            n_i1, ncol(Fh), n_d0, ncol(Fh)))
cat("    (I(1) in levels + I(0) in differences = I(1), which is the BLL design;\n")
cat("     a factor NOT I(0) in difference would be I(2) and would be a problem)\n")

fac <- fac |> left_join(ver |> select(fator, transf, veredito),
                        by = c("fator", "transf"))
write_csv(fac, file.path(OUT_DIR, "factor_unit_root.csv"))
cat(sprintf("    -> %s/factor_unit_root.csv (%d rows)\n", OUT_DIR, nrow(fac)))


# ===================================================================
# 3. Phillips-Perron on the 106 panel series
# ===================================================================
# Completes the methodologist's explicit ADF/KPSS/PP request. ADF and
# KPSS are READ from t5_4 rather than recomputed, and the self-test
# below is what makes that safe.
cat("\n[3] Phillips-Perron on the panel\n")

pp_panel <- lapply(seq_along(VAR_NAMES), function(i) {
  rr <- run_ur(PANEL[, i], "PP", "drift")
  data.frame(var = VAR_NAMES[i], tcode = TCODE[i],
             pp_stat = rr$stat, pp_cv5 = rr$cv,
             pp_rejeita_RU_5pct = rr$rejeita)
}) |> bind_rows()

if (file.exists(T54_PATH)) {
  t54 <- read_csv(T54_PATH, show_col_types = FALSE)

  # Self-test 3: re-run ADF and KPSS on a sample and check t5_4 reproduces
  chk_idx <- sort(sample(seq_along(VAR_NAMES), min(20L, length(VAR_NAMES))))
  chk <- lapply(chk_idx, function(i) {
    a <- run_ur(PANEL[, i], "ADF", "drift")
    data.frame(var = VAR_NAMES[i], adf_mine = a$rejeita)
  }) |> bind_rows() |>
    left_join(t54 |> select(var, adf_disk = adf_rejeita_RU_5pct), by = "var")
  ok <- all(chk$adf_mine == chk$adf_disk, na.rm = TRUE)
  cat(sprintf("    self-test vs %s: ADF agrees on %d of %d sampled series\n",
              T54_PATH, sum(chk$adf_mine == chk$adf_disk, na.rm = TRUE),
              nrow(chk)))
  stopifnot(ok)

  pp_panel <- t54 |>
    select(var, grupo, tcode, adf_rejeita_RU_5pct, kpss_p,
           kpss_rejeita_estac_5pct, veredito_adf_kpss = veredito) |>
    left_join(pp_panel |> select(-tcode), by = "var") |>
    mutate(tres_concordam = !adf_rejeita_RU_5pct & !pp_rejeita_RU_5pct &
             kpss_rejeita_estac_5pct)
} else {
  cat("    (t5_4_raiz_unitaria.csv absent - ADF/KPSS columns not joined)\n")
}

cat(sprintf("    PP rejects the unit root at 5%% in %d of %d series\n",
            sum(pp_panel$pp_rejeita_RU_5pct, na.rm = TRUE), nrow(pp_panel)))
if ("veredito_adf_kpss" %in% names(pp_panel)) {
  cat("\n    PP against the ADF+KPSS verdict:\n")
  print(as.data.frame(pp_panel |>
          count(veredito_adf_kpss, pp_rejeita_RU_5pct)), row.names = FALSE)
  cat(sprintf("\n    all three agree on I(1) in %d series\n",
              sum(pp_panel$tres_concordam, na.rm = TRUE)))
}
write_csv(pp_panel, file.path(OUT_DIR, "panel_unit_root_pp.csv"))
cat(sprintf("    -> %s/panel_unit_root_pp.csv (%d rows)\n",
            OUT_DIR, nrow(pp_panel)))


# ===================================================================
# 4. Johansen cointegration among the 7 factors
# ===================================================================
# The rank estimate is notoriously lag-sensitive, so K is swept. And
# with n=7, K=6 and T=147 effective this is ~300 parameters: the
# asymptotic statistic over-rejects, exactly the distortion already
# documented for this sample in diagnostico_dfm.md section 7.4 (the
# asymptotic chi2 over-rejects by 2.3x-5.3x there). The Reinsel-Ahn
# small-sample factor (T - n*K)/T is reported beside the raw statistic.
cat("\n[4] Johansen cointegration on the factors\n")

joh_rows <- list()
for (KK in K_GRID) {
  for (ty in c("trace", "eigen")) {
    jo <- ca.jo(Fh, type = ty, ecdet = "const", K = KK, spec = "transitory")
    st <- jo@teststat
    cv <- jo@cval
    n  <- ncol(Fh)
    Tef <- nrow(Fh) - KK
    ra_factor <- (Tef - n * KK) / Tef
    # ca.jo orders r <= n-1 first; relabel to r0 = 0..n-1 ascending
    r0 <- rev(seq_len(length(st)) - 1L)
    joh_rows[[length(joh_rows) + 1]] <- data.frame(
      K = KK, tipo = ty, r0 = r0, stat = as.numeric(st),
      cv10 = cv[, "10pct"], cv5 = cv[, "5pct"], cv1 = cv[, "1pct"],
      rejeita_5pct = as.numeric(st) > cv[, "5pct"],
      stat_reinsel_ahn = as.numeric(st) * ra_factor,
      rejeita_5pct_ra = as.numeric(st) * ra_factor > cv[, "5pct"]
    )
  }
}
joh <- bind_rows(joh_rows) |> arrange(K, tipo, r0)

#' Estimated rank: the first r0 (ascending) whose H0 is NOT rejected
first_nonreject <- function(d) {
  d <- d |> arrange(r0)
  i <- which(!d$rejeita_5pct)
  if (length(i) == 0) max(d$r0) + 1L else d$r0[i[1]]
}
first_nonreject_ra <- function(d) {
  d <- d |> arrange(r0)
  i <- which(!d$rejeita_5pct_ra)
  if (length(i) == 0) max(d$r0) + 1L else d$r0[i[1]]
}

rank_tbl <- joh |> group_by(K, tipo) |>
  summarise(posto_5pct = first_nonreject(pick(everything())),
            posto_5pct_ra = first_nonreject_ra(pick(everything())),
            .groups = "drop")

cat("    estimated cointegration rank (n = 7):\n")
print(as.data.frame(rank_tbl), row.names = FALSE)

POSTO_PROD <- (rank_tbl |> filter(K == P_LAGS, tipo == "trace"))$posto_5pct
POSTO_PROD_RA <- (rank_tbl |> filter(K == P_LAGS, tipo == "trace"))$posto_5pct_ra
cat(sprintf("\n    production lag (K = %d), trace: rank = %d (%d with Reinsel-Ahn)\n",
            P_LAGS, POSTO_PROD, POSTO_PROD_RA))
cat(sprintf("    -> %d common trends, %d cointegrating relations\n",
            ncol(Fh) - POSTO_PROD, POSTO_PROD))

joh <- joh |> left_join(rank_tbl, by = c("K", "tipo"))
write_csv(joh, file.path(OUT_DIR, "factor_cointegration.csv"))
cat(sprintf("    -> %s/factor_cointegration.csv (%d rows)\n",
            OUT_DIR, nrow(joh)))


# ===================================================================
# 5. Reading rule R1 — the mechanical benchmark against the IRFs
# ===================================================================
cat("\n[5] observed reversal horizons against the mechanical benchmark\n")

rev_tbl <- NULL
if (file.exists(HCSV_PATH) && DOM$complexo) {
  hcsv <- read_csv(HCSV_PATH, show_col_types = FALSE)
  REV_VARS <- c("yield_3m", "yield_6m", "yield_2y", "yield_10y",
                "juros_selic", "cds_5y", "embi_perc", "cambio_usd",
                "credit_outstanding", "credito_pessoa_fisica",
                "credito_comercio", "credito_construcao",
                "credito_industria_total", "credito_agro")
  # Three horizons per series, because they answer different questions:
  #  h_inversao  — first sign flip relative to impact (the half cycle mark)
  #  h_extremo   — global extremum, which for the risk block is the impact
  #                itself and therefore says nothing about the medium run
  #  h_extremo_mp— extremum restricted to h >= 13, which IS the trough that
  #                section 4 tells (the quarter cycle mark)
  rev_tbl <- lapply(intersect(REV_VARS, unique(hcsv$var)), function(v) {
    d <- hcsv |> filter(var == v) |> arrange(h)
    s0 <- sign(d$point[1])
    i <- which(sign(d$point) == -s0 & d$h > 0)
    dm <- d |> filter(h >= 13)
    jm <- which.max(abs(dm$point))
    data.frame(var = v, sinal_h0 = s0,
               h_inversao = if (length(i)) d$h[i[1]] else NA_integer_,
               h_extremo = d$h[which.max(abs(d$point))],
               val_extremo = d$point[which.max(abs(d$point))],
               h_extremo_mp = dm$h[jm], val_extremo_mp = dm$point[jm])
  }) |> bind_rows() |>
    mutate(
      quarto_ciclo = DOM$quarto_ciclo,
      meia_volta = DOM$meia_volta_ciclo,
      dentro_25pct_meia_volta = !is.na(h_inversao) &
        abs(h_inversao - DOM$meia_volta_ciclo) <= 0.25 * DOM$meia_volta_ciclo,
      dentro_25pct_quarto = abs(h_extremo - DOM$quarto_ciclo) <=
        0.25 * DOM$quarto_ciclo,
      dentro_25pct_quarto_mp = abs(h_extremo_mp - DOM$quarto_ciclo) <=
        0.25 * DOM$quarto_ciclo)

  print(as.data.frame(rev_tbl |>
          select(var, h_inversao, meia_volta, dentro_25pct_meia_volta,
                 h_extremo, h_extremo_mp, quarto_ciclo,
                 dentro_25pct_quarto_mp)),
        row.names = FALSE, digits = 4)

  cat(sprintf("\n    R1: sign inversion within +/-25%% of the half cycle (%.1f mo): %d of %d\n",
              DOM$meia_volta_ciclo, sum(rev_tbl$dentro_25pct_meia_volta,
                                        na.rm = TRUE), nrow(rev_tbl)))
  cat(sprintf("    R1: GLOBAL extremum within +/-25%% of the quarter cycle (%.1f mo): %d of %d\n",
              DOM$quarto_ciclo, sum(rev_tbl$dentro_25pct_quarto, na.rm = TRUE),
              nrow(rev_tbl)))
  cat(sprintf("    R1: MEDIUM-RUN extremum (h >= 13) within +/-25%% of the quarter cycle: %d of %d\n",
              sum(rev_tbl$dentro_25pct_quarto_mp, na.rm = TRUE), nrow(rev_tbl)))
} else {
  cat("    (skipped: irf_coherence_h.csv absent or dominant root is real)\n")
}


# ===================================================================
# 6. The decisive test — does the trough move with the lag order?
# ===================================================================
# Coincidence of periods is suggestive, not proof. If the medium-run
# trough is the damped oscillation of the dominant complex pair, it has
# to MOVE when the pair moves. At p = 1 the dominant root is real (see
# block 1: n_complexo = 4 of 7, dominant period NA), so a pure
# oscillation cannot exist there; at p = 4 the dominant period is 94.4
# months against 117.9 at p = 6, so the quarter cycle shifts from 29.5
# to 23.6. Point estimates only, no bootstrap.
cat("\n[6] does the medium-run trough follow the lag order?\n")

lag_rows <- NULL
if (!is.null(rev_tbl)) {
  mpind <- match(MP_VAR, VAR_NAMES)
  norm_v <- 50 / 10000
  lag_rows <- lapply(P_GRID, function(pp) {
    d <- if (pp == P_LAGS) dfm else
      estimate_dfm(PANEL, R_FACTORS, Q_DYNAMIC, pp, dates = DATES,
                   instrument = inst_df, apply_kilian = FALSE)
    ir <- compute_irf_dfm(d, h = 48L, nboot = 0, mpind = mpind,
                          normalize_value = norm_v, tcode = TCODE,
                          var_names = VAR_NAMES)$irf_point_matrix
    sp <- spectrum_table(d$companion_matrix, "OLS", pp) |> slice(1)
    lapply(rev_tbl$var, function(v) {
      i <- match(v, VAR_NAMES)
      y <- ir[i, ]
      jm <- which.max(abs(y[14:49])) + 13L
      data.frame(p = pp, var = v, h_extremo_mp = jm - 1L,
                 val_extremo_mp = y[jm],
                 dominante_complexa = sp$complexo,
                 quarto_ciclo = sp$quarto_ciclo)
    }) |> bind_rows()
  }) |> bind_rows()

  wide <- lag_rows |> select(p, var, h_extremo_mp) |>
    pivot_wider(names_from = p, values_from = h_extremo_mp,
                names_prefix = "h_mp_p")
  print(as.data.frame(wide), row.names = FALSE)

  qc <- lag_rows |> group_by(p) |>
    summarise(dominante_complexa = first(dominante_complexa),
              quarto_ciclo = first(quarto_ciclo),
              mediana_h_extremo_mp = median(h_extremo_mp), .groups = "drop")
  cat("\n    median medium-run trough against the quarter cycle, by p:\n")
  print(as.data.frame(qc), row.names = FALSE, digits = 4)

  write_csv(lag_rows, file.path(OUT_DIR, "factor_lag_sensitivity_irf.csv"))
  cat(sprintf("    -> %s/factor_lag_sensitivity_irf.csv (%d rows)\n",
              OUT_DIR, nrow(lag_rows)))
} else {
  cat("    (skipped: block 5 produced nothing)\n")
}


# ===================================================================
# 7. The exact test — spectral decomposition of the IRF
# ===================================================================
# Block 6 re-estimates, so it confounds "the pair moved" with "the whole
# model changed". This one does not re-estimate anything. Write
# A = V diag(lambda) W with W = V^-1; then A^h = sum_k lambda_k^h v_k w_k',
# and since the IRF is Lambda B_h K M H with B_h = (A^h)[1:r,1:r], it is
# LINEAR in B_h. So the dominant pair can be deleted from B_h exactly and
# the counterfactual IRF pushed through the same identification and tcode
# pipeline that production uses. If the medium-run trough is the pair's
# damped oscillation, deleting the pair deletes the trough.
cat("\n[7] spectral decomposition — delete the dominant pair from B\n")

spec_rows7 <- NULL
if (!is.null(rev_tbl)) {
  A  <- dfm$companion_matrix
  Lm <- dfm$static_loadings
  Kd <- dfm$dynamic_loadings
  Md <- dfm$dynamic_scaling
  sy <- dfm$data_sd
  rr <- ncol(Lm); rp <- nrow(A); H_MAX <- 48L
  mpind <- match(MP_VAR, VAR_NAMES)
  norm_v <- 50 / 10000

  eg <- eigen(A)
  V  <- eg$vectors
  W  <- solve(V)
  lam <- eg$values
  ord <- order(Mod(lam), decreasing = TRUE)
  lam <- lam[ord]; V <- V[, ord, drop = FALSE]; W <- W[ord, , drop = FALSE]

  # eta and the instrument alignment, exactly as compute_irf_dfm does
  eta <- dfm$var_residuals %*% Kd %*% solve(Md)
  al  <- sel_ext_inst_sample(DATES, P_LAGS, inst_df)
  eta_sel <- eta[al$rsh_sel_ind, , drop = FALSE]

  #' IRF built from B_h with the eigenvalues in `drop_k` removed
  irf_from_modes <- function(drop_k = integer(0)) {
    keep <- setdiff(seq_len(rp), drop_k)
    rawimp <- array(0, dim = c(nrow(Lm), ncol(Kd), H_MAX + 1))
    for (j in 0:H_MAX) {
      Ah <- matrix(0 + 0i, rp, rp)
      for (k in keep) Ah <- Ah + lam[k]^j * (V[, k, drop = FALSE] %*% W[k, , drop = FALSE])
      Bh <- Re(Ah[1:rr, 1:rr, drop = FALSE])
      rawimp[, , j + 1] <- sweep(Re(Lm %*% Bh %*% Kd %*% Md), 1, sy, "*")
    }
    ident_ext_instr(rawimp, eta_sel, al$inst_sel, H_MAX,
                    mpind, norm_v, TCODE)$irf_mp
  }

  irf_all  <- irf_from_modes()
  irf_nod  <- irf_from_modes(1:2)   # drop the dominant conjugate pair
  irf_no34 <- irf_from_modes(3:4)   # drop the second pair, as a control

  # Self-test: the full reconstruction must equal the production IRF
  d_prod <- max(abs(irf_all[match(rev_tbl$var, VAR_NAMES), 1:49] -
                    as.matrix(cell$irf$irf_point_matrix[
                      match(rev_tbl$var, VAR_NAMES), 1:49])))
  cat(sprintf("    self-test: reconstructed IRF vs production, max |diff| = %.3g\n",
              d_prod))
  stopifnot(d_prod < 1e-8)

  hmp <- function(M, v) {
    y <- M[match(v, VAR_NAMES), ]
    which.max(abs(y[14:49])) + 12L    # horizon (0-indexed) of the h>=13 extremum
  }
  vmp <- function(M, v) {
    y <- M[match(v, VAR_NAMES), ]
    y[which.max(abs(y[14:49])) + 13L]
  }

  spec_rows7 <- lapply(rev_tbl$var, function(v) {
    data.frame(var = v,
               h_mp_completo = hmp(irf_all, v),  val_mp_completo = vmp(irf_all, v),
               h_mp_sem_par1 = hmp(irf_nod, v),  val_mp_sem_par1 = vmp(irf_nod, v),
               h_mp_sem_par2 = hmp(irf_no34, v), val_mp_sem_par2 = vmp(irf_no34, v))
  }) |> bind_rows() |>
    mutate(razao_sem_par1 = val_mp_sem_par1 / val_mp_completo,
           razao_sem_par2 = val_mp_sem_par2 / val_mp_completo,
           vale_sobrevive_sem_par1 = abs(razao_sem_par1) > 0.5 &
             sign(val_mp_sem_par1) == sign(val_mp_completo))

  print(as.data.frame(spec_rows7 |>
          select(var, h_mp_completo, val_mp_completo, h_mp_sem_par1,
                 val_mp_sem_par1, razao_sem_par1, vale_sobrevive_sem_par1)),
        row.names = FALSE, digits = 3)

  cat(sprintf("\n    trough survives deletion of the DOMINANT pair (same sign, >50%% of magnitude): %d of %d\n",
              sum(spec_rows7$vale_sobrevive_sem_par1), nrow(spec_rows7)))
  cat(sprintf("    median |ratio| without pair 1: %.3f | without pair 2: %.3f\n",
              median(abs(spec_rows7$razao_sem_par1)),
              median(abs(spec_rows7$razao_sem_par2))))

  write_csv(spec_rows7, file.path(OUT_DIR, "factor_irf_mode_decomposition.csv"))
  cat(sprintf("    -> %s/factor_irf_mode_decomposition.csv (%d rows)\n",
              OUT_DIR, nrow(spec_rows7)))
} else {
  cat("    (skipped: block 5 produced nothing)\n")
}


# ===================================================================
# 8. Report
# ===================================================================

md_tbl <- function(df, digits = 4) {
  df <- as.data.frame(df)
  num <- vapply(df, is.numeric, logical(1))
  df[num] <- lapply(df[num], function(x) format(round(x, digits), trim = TRUE))
  hdr <- paste0("| ", paste(names(df), collapse = " | "), " |")
  sep <- paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|")
  body <- apply(df, 1, function(r) paste0("| ", paste(r, collapse = " | "), " |"))
  c(hdr, sep, body, "")
}

md <- c(
  "# Estacionariedade, cointegração e espectro da companion",
  "",
  "> **Corpo gerado por `script/factor_stationarity.R`. Reescrito por inteiro a**",
  "> **cada execução — não escrever prosa aqui.** A leitura interpretativa fica em",
  "> `relatorio/working-notes/2026-07-31_estacionariedade_fatores.md`.",
  "",
  sprintf("Spec: r = %d, q = %d, p = %d, instrumento `%s`, painel %d x %d (%s a %s).",
          R_FACTORS, Q_DYNAMIC, P_LAGS, INSTRUMENT, nrow(PANEL), ncol(PANEL),
          format(min(DATES)), format(max(DATES))),
  "",
  "## 1. Espectro da companion (produção: OLS, p = 6)",
  "",
  md_tbl(prod_ols |> slice(1:8) |>
           select(ordem, modulo, complexo, periodo_meses, quarto_ciclo,
                  meia_volta_ciclo, meia_vida_meses), 4),
  sprintf("Raiz dominante: |λ| = %.6f, %s%s", DOM$modulo,
          ifelse(DOM$complexo, "**complexa**", "real"),
          if (DOM$complexo) sprintf(", período %.1f meses (quarto de ciclo %.1f, meia-volta %.1f).",
                                    DOM$periodo_meses, DOM$quarto_ciclo,
                                    DOM$meia_volta_ciclo) else "."),
  "",
  sprintf("Raízes com |λ| > 0,97: %d. Com |λ| > 0,90: %d. Explosivas (|λ| ≥ 1): %d.",
          sum(prod_ols$modulo > 0.97), sum(prod_ols$modulo > 0.90),
          sum(prod_ols$modulo >= 1)),
  "",
  "### Sensibilidade à ordem de defasagem",
  "",
  md_tbl(spec |> group_by(matriz, p) |>
           summarise(max_mod = max(modulo), n_complexo = sum(complexo),
                     per_dominante = periodo_meses[which.max(modulo)],
                     .groups = "drop"), 4),
  "## 2. Raiz unitária nos 7 fatores (ADF / PP / KPSS, 5%, spec drift-mu)",
  "",
  md_tbl(ver |> select(fator, transf, ADF, PP, KPSS, veredito), 4),
  sprintf("Fatores I(1) em nível: **%d de %d**. I(0) em primeira diferença: **%d de %d**.",
          n_i1, ncol(Fh), n_d0, ncol(Fh)),
  "",
  "## 3. Phillips-Perron nas 106 séries do painel",
  "",
  sprintf("PP rejeita a raiz unitária a 5%% em **%d de %d** séries.",
          sum(pp_panel$pp_rejeita_RU_5pct, na.rm = TRUE), nrow(pp_panel)),
  "",
  if ("veredito_adf_kpss" %in% names(pp_panel))
    md_tbl(pp_panel |> count(veredito_adf_kpss, pp_rejeita_RU_5pct)) else "",
  "## 4. Cointegração de Johansen (n = 7)",
  "",
  md_tbl(rank_tbl, 0),
  sprintf("Na defasagem de produção (K = %d), traço: posto **%d** (%d com Reinsel-Ahn) — %d tendências comuns.",
          P_LAGS, POSTO_PROD, POSTO_PROD_RA, ncol(Fh) - POSTO_PROD),
  "",
  md_tbl(joh |> filter(K == P_LAGS) |>
           select(tipo, r0, stat, cv5, rejeita_5pct, stat_reinsel_ahn,
                  rejeita_5pct_ra), 3),
  "## 5. Regra R1 — reversão observada contra o marco mecânico",
  ""
)

if (!is.null(rev_tbl)) {
  md <- c(md,
    md_tbl(rev_tbl |> select(var, h_inversao, meia_volta,
                             dentro_25pct_meia_volta, h_extremo, h_extremo_mp,
                             quarto_ciclo, dentro_25pct_quarto_mp), 2),
    sprintf("Inversão de sinal dentro de ±25%% da meia-volta (%.1f meses): **%d de %d**.",
            DOM$meia_volta_ciclo, sum(rev_tbl$dentro_25pct_meia_volta, na.rm = TRUE),
            nrow(rev_tbl)),
    sprintf("Extremo **global** dentro de ±25%% do quarto de ciclo (%.1f meses): **%d de %d**.",
            DOM$quarto_ciclo, sum(rev_tbl$dentro_25pct_quarto, na.rm = TRUE),
            nrow(rev_tbl)),
    sprintf("Extremo de **médio prazo** (h ≥ 13) dentro de ±25%% do quarto de ciclo: **%d de %d**.",
            sum(rev_tbl$dentro_25pct_quarto_mp, na.rm = TRUE), nrow(rev_tbl)),
    "")
}

if (!is.null(lag_rows)) {
  md <- c(md,
    "## 6. O vale de médio prazo acompanha a ordem de defasagem?",
    "",
    md_tbl(lag_rows |> group_by(p) |>
             summarise(dominante_complexa = first(dominante_complexa),
                       quarto_ciclo = first(quarto_ciclo),
                       mediana_h_extremo_mp = median(h_extremo_mp),
                       .groups = "drop"), 2),
    md_tbl(lag_rows |> select(p, var, h_extremo_mp) |>
             pivot_wider(names_from = p, values_from = h_extremo_mp,
                         names_prefix = "h_mp_p"), 0))
}

if (!is.null(spec_rows7)) {
  md <- c(md,
    "## 7. Decomposição espectral — apagar o par dominante de `B`",
    "",
    md_tbl(spec_rows7 |> select(var, h_mp_completo, val_mp_completo,
                                h_mp_sem_par1, val_mp_sem_par1,
                                razao_sem_par1, vale_sobrevive_sem_par1), 3),
    sprintf("Vale sobrevive à remoção do **par dominante** (mesmo sinal, > 50%% da magnitude): **%d de %d**.",
            sum(spec_rows7$vale_sobrevive_sem_par1), nrow(spec_rows7)),
    sprintf("Razão mediana |sem par 1| / completo: **%.3f**. Sem par 2: %.3f.",
            median(abs(spec_rows7$razao_sem_par1)),
            median(abs(spec_rows7$razao_sem_par2))),
    "")
}

writeLines(md, file.path(OUT_DIR, "factor_stationarity.md"))
cat(sprintf("\n-> %s/factor_stationarity.md\n", OUT_DIR))
cat("\n=== done ===\n")
