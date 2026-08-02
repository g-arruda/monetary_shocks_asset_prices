# ===================================================================
# The small-scale VAR benchmark: is the DFM stronger and faster?
#
# Council review of 2026-07-31 (relatorio/council_2026-07-31.md:23,73),
# raised independently by the harsh referee and the macro theorist. The
# introduction of the archived paper draft (arquivo/tex/main.tex:183,
# tex/ before its 2026-08-02 archival) claims the asset-price responses
# are "mais fortes e rapidos do que a literatura baseada em modelos de
# menor dimensao tipicamente encontra". That is Alessi-Kerssenfischer's
# result, not one estimated here — and the equity block, where the
# comparison would be most visible, has zero sig90 cells in 392. The
# canonical paper, texto_anpec/paper_anpec.tex, never made this claim.
#
# This is the R translation of codigo_alessi-mark/MAIN_VARloop.m, which
# is what produces Figures 1-4 of the replicated paper. What the
# original code fixes, and this driver follows:
#
#  * 4-variable VARs, 3 core + 1 response, one VAR per response
#    (MAIN_VARloop.m:11-12).
#  * The core is {activity, prices, medium-term rate} and the rate is
#    ALSO the normalization target: RUN_MAIN_US.m:7-9 has
#    corevars = {INDPRO, CPIAUCSL, 2year_rate} with
#    opts.mpind = corevars(3); the euro-area file uses
#    {EKIPTOT.G, Z8ESA67UF, gov2y_DE}. AK never normalizes on an
#    overnight rate — which is a second, independent reason not to use
#    juros_selic here, on top of it being this project's documented
#    negative control (max reduced-form F = 2.49 across the grid).
#  * tcode is passed to the identification, SUBSET to the VAR's own
#    variables (MAIN_VARloop.m:28), and cumimp runs inside
#    IdentExtInstr, in the point estimate and in every replica.
#  * varlist is the paper's asset-price list, the union of three figure
#    groups (RUN_MAIN_US.m:3-5): credit spreads, bilateral exchange
#    rates, equities and producer prices. It carries no yield-curve
#    vertices — the four non-AK responses here are declared as this
#    project's extension.
#  * AK also keeps the CORE responses of every VAR (IRF_var_core,
#    MAIN_VARloop.m:6,22) and overlays them against the single DFM panel
#    (MAIN_plotfigs.m:49-71). Kept: it gives the yield_6m == 0.005
#    self-test for free and diagnoses whether the small VAR is stable.
#  * The comparison figure is two columns, VAR left and DFM right, with
#    linkaxes (MAIN_plotfigs.m:1-46). The shared y axis is the whole
#    point — it is what makes "stronger" and "narrower band" visible
#    instead of asserted. Hence coord_cartesian with a common ylim per
#    row, never scales = "free_y".
#
# ONE DELIBERATE DEVIATION, DECLARED: AK reports percentiles 5/10/90/95,
# i.e. 90% and 80% bands. Production here uses 68/90, so the benchmark
# uses 68/90 to match output/irf/irf_coherence_cell.rds.
#
# READING RULE, FIXED BEFORE THE NUMBERS EXIST:
#   "stronger" = |IRF_DFM(peak)| > |IRF_VAR(peak)|
#   "faster"   = peak_h_DFM < peak_h_VAR
# Counts are reported over all responses AND over the 8 asset_* alone,
# which is the block in the paper's title. The inconvenient variable
# goes in the table, not in a footnote. And what this does NOT show is
# declared: holding identification fixed, this tests "DFM vs small VAR",
# not "vs the literature", which uses recursive identification.
#
# The DFM side is READ from output/irf/irf_coherence_cell.rds. Nothing
# is re-estimated on that side.
#
# Outputs: output/var/var_benchmark_irf.csv
#          output/var/var_benchmark_core.csv
#          output/var/var_benchmark_compare.csv
#          output/var/var_benchmark.md
#          output/var/var_benchmark_{risco,cambio,acoes,core}.pdf
# ===================================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(patchwork)
})

source("R/modeling/factor_estimation.R")   # kilian_correction, infer_tcode
source("R/modeling/impulse_responde.R")    # sel_ext_inst_sample, ident_ext_instr
source("R/modeling/var_proxy.R")           # var_est_ols, compute_irf_var_proxy
source("R/identification/spec_sweep.R")    # norm_value_for


# ---- Config: matched to script/irf_coherence_check.R ---------------

P_LAGS     <- 6L
HORIZON    <- 48L
N_BOOT     <- 800L
BOOT_SEED  <- 123L
SHOCK_BPS  <- 50
CI_LEVELS  <- c(0.68, 0.90)
INSTRUMENT <- "z_jk_bs_purif"
MP_VAR     <- "yield_6m"
WINDOW     <- as.Date(c("2013-01-01", "2025-12-31"))

# AK's corevars: activity, prices, medium-term rate (the last one is mpind)
CORE_VARS <- c("ind_transformacao", "price_ipca", "yield_6m")

# AK's varlist, by figure group. The `extensao` group has no counterpart
# in RUN_MAIN_US.m and is declared as this project's addition.
VARLIST <- list(
  risco     = c("embi_perc", "cds_5y", "spread_icc_fisica",
                "spread_icc_juridica"),
  cambio    = c("cambio_usd"),
  acoes     = c("asset_ibov", "asset_idiv", "asset_ifix", "asset_ifnc",
                "asset_imat", "asset_imob", "asset_mlcx", "asset_smll",
                "price_ipp"),
  extensao  = c("yield_2y", "yield_10y", "ibc_br", "price_core_ipca_ex0")
)

DATA_PATH <- "data/processed/data_log_deseasonalized.csv"
INST_PATH <- "data/processed/instrumentos_mensais.csv"
CELL_PATH <- "output/irf/irf_coherence_cell.rds"
HCSV_PATH <- "output/irf/irf_coherence_h.csv"
OUT_DIR   <- "output/var"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

run_benchmark <- function() {

cat("=== VAR benchmark against the DFM ===\n\n")


# ===================================================================
# 1. Panel, instrument, cached DFM
# ===================================================================
cat("[1] loading\n")

panel_df <- read_csv(DATA_PATH, show_col_types = FALSE) |>
  filter(ref.date >= WINDOW[1], ref.date <= WINDOW[2]) |>
  drop_na()
DATES <- as.Date(panel_df$ref.date)
PANEL <- panel_df |> select(-ref.date) |> as.matrix()
VAR_NAMES <- colnames(PANEL)
TCODE <- infer_tcode_from_varnames(VAR_NAMES)

inst_df <- read_csv(INST_PATH, show_col_types = FALSE) |>
  mutate(month = as.Date(month)) |>
  select(month, shock = all_of(INSTRUMENT)) |>
  filter(!is.na(shock))

cell <- readRDS(CELL_PATH)
stopifnot(cell$instrument == INSTRUMENT, cell$r == 7L, cell$q == 6L,
          cell$p == P_LAGS, cell$mp_var == MP_VAR)

RESPONSES <- unlist(VARLIST, use.names = FALSE)
missing <- setdiff(c(CORE_VARS, RESPONSES), VAR_NAMES)
if (length(missing)) stop("ausentes no painel: ", paste(missing, collapse = ", "))

MPIND <- match(MP_VAR, CORE_VARS)
NORM_V <- norm_value_for(MP_VAR, SHOCK_BPS)

cat(sprintf("    panel %d x %d | %s a %s\n", nrow(PANEL), ncol(PANEL),
            format(min(DATES)), format(max(DATES))))
cat(sprintf("    core: %s | mpind = %d (%s), norm = %g\n",
            paste(CORE_VARS, collapse = ", "), MPIND, MP_VAR, NORM_V))
cat(sprintf("    %d responses, %d bootstrap draws each\n",
            length(RESPONSES), N_BOOT))


# ===================================================================
# 2. One 4-variable VAR per response (MAIN_VARloop.m)
# ===================================================================
cat("\n[2] estimating\n")

t0 <- Sys.time()
fits <- lapply(seq_along(RESPONSES), function(i) {
  v <- RESPONSES[i]
  varsel <- c(CORE_VARS, v)
  idx <- match(varsel, VAR_NAMES)
  res <- compute_irf_var_proxy(
    X_mat = PANEL[, idx, drop = FALSE], p = P_LAGS, instrument = inst_df,
    data_dates = DATES, h = HORIZON, mpind = MPIND,
    normalize_value = NORM_V, tcode = TCODE[idx], nboot = N_BOOT,
    ci_levels = CI_LEVELS, seed = BOOT_SEED)
  cat(sprintf("    %2d/%2d %-24s max|eig| %.3f  n_inst %d  falhas %d\n",
              i, length(RESPONSES), v, res$max_eig, res$n_inst, res$n_failed))
  list(var = v, varsel = varsel, res = res)
})
names(fits) <- RESPONSES
cat(sprintf("    tempo: %.1f min\n",
            as.numeric(difftime(Sys.time(), t0, units = "mins"))))


# ===================================================================
# 3. Long IRF table, both models
# ===================================================================
cat("\n[3] assembling the IRF table\n")

j <- 0:HORIZON + 1

var_long <- lapply(fits, function(f) {
  k <- 4L   # the response is always the 4th column
  data.frame(model = "VAR", var = f$var, h = 0:HORIZON,
             point = f$res$irf_point[k, j],
             lo68 = f$res$ci[["0.68"]]$lower[k, j],
             hi68 = f$res$ci[["0.68"]]$upper[k, j],
             lo90 = f$res$ci[["0.90"]]$lower[k, j],
             hi90 = f$res$ci[["0.90"]]$upper[k, j])
}) |> bind_rows()

dfm_long <- lapply(RESPONSES, function(v) {
  i <- match(v, cell$var_names)
  data.frame(model = "DFM", var = v, h = 0:HORIZON,
             point = cell$irf$irf_point_matrix[i, j],
             lo68 = cell$irf$ci[["0.68"]]$lower[i, j],
             hi68 = cell$irf$ci[["0.68"]]$upper[i, j],
             lo90 = cell$irf$ci[["0.90"]]$lower[i, j],
             hi90 = cell$irf$ci[["0.90"]]$upper[i, j])
}) |> bind_rows()

irf_long <- bind_rows(var_long, dfm_long) |>
  mutate(sig68 = lo68 > 0 | hi68 < 0,
         sig90 = lo90 > 0 | hi90 < 0,
         grupo = rep(NA_character_, n()))
for (g in names(VARLIST)) irf_long$grupo[irf_long$var %in% VARLIST[[g]]] <- g

write_csv(irf_long, file.path(OUT_DIR, "var_benchmark_irf.csv"))
cat(sprintf("    -> %s/var_benchmark_irf.csv (%d rows)\n",
            OUT_DIR, nrow(irf_long)))

# Core responses of every VAR (IRF_var_core)
core_long <- lapply(fits, function(f) {
  lapply(seq_along(CORE_VARS), function(k) {
    data.frame(var_do_var = f$var, core = CORE_VARS[k], h = 0:HORIZON,
               point = f$res$irf_point[k, j])
  }) |> bind_rows()
}) |> bind_rows()
write_csv(core_long, file.path(OUT_DIR, "var_benchmark_core.csv"))
cat(sprintf("    -> %s/var_benchmark_core.csv (%d rows)\n",
            OUT_DIR, nrow(core_long)))


# ===================================================================
# 4. Self-tests
# ===================================================================
cat("\n[4] self-tests\n")

# 4.1 the VAR normalizes yield_6m to exactly 0.005 on impact, in all VARs
h0_mp <- core_long |> filter(core == MP_VAR, h == 0)
cat(sprintf("    (1) %s h0 in every VAR: max |dev| from %g = %.3g\n",
            MP_VAR, NORM_V, max(abs(h0_mp$point - NORM_V))))
stopifnot(nrow(h0_mp) == length(RESPONSES),
          max(abs(h0_mp$point - NORM_V)) < 1e-12)

# 4.2 the DFM side read from the .rds reproduces irf_coherence_h.csv
hcsv <- read_csv(HCSV_PATH, show_col_types = FALSE)
scored <- intersect(RESPONSES, unique(hcsv$var))
unscored <- setdiff(RESPONSES, scored)
chk <- dfm_long |> filter(var %in% scored) |>
  inner_join(hcsv |> select(var, h, point_csv = point, lo90_csv = lo90,
                            hi90_csv = hi90),
             by = c("var", "h"))
d1 <- max(abs(chk$point - chk$point_csv))
d2 <- max(abs(chk$lo90 - chk$lo90_csv), abs(chk$hi90 - chk$hi90_csv))
cat(sprintf("    (2) DFM vs irf_coherence_h.csv on %d of %d responses, %d rows: point %.3g, band %.3g\n",
            length(scored), length(RESPONSES), nrow(chk), d1, d2))
if (length(unscored))
  cat(sprintf("        fora da regua de 53 (esperado): %s\n",
              paste(unscored, collapse = ", ")))
stopifnot(d1 < 1e-10, d2 < 1e-10)

# 4.3 var_est_ols reproduces VARest.m on a fixed small case
set.seed(42)
Xt <- matrix(rnorm(80 * 3), 80, 3)
mt <- var_est_ols(Xt, 2L, 5L)
RHSt <- cbind(Xt[2:79, ], Xt[1:78, ], 1)
bett <- solve(crossprod(RHSt), crossprod(RHSt, Xt[3:80, ]))
At <- rbind(t(bett[1:6, ]), cbind(diag(3), matrix(0, 3, 3)))
cat(sprintf("    (3) var_est_ols vs a hand-built VAR(2): bet %.3g, A %.3g, B2 %.3g\n",
            max(abs(mt$bet - bett)), max(abs(mt$A - At)),
            max(abs(mt$B[, , 3] - (At %*% At)[1:3, 1:3]))))
stopifnot(max(abs(mt$bet - bett)) < 1e-12, max(abs(mt$A - At)) < 1e-12,
          max(abs(mt$B[, , 3] - (At %*% At)[1:3, 1:3])) < 1e-12)


# ===================================================================
# 5. Comparison table
# ===================================================================
cat("\n[5] comparison\n")

# THE PEAK HAS TO BE SIGN-DISCIPLINED, and the first version of this
# script got it wrong. The raw global extremum has the OPPOSITE sign to
# the impact in 8 of 18 DFM responses — precisely the 8 equity indices,
# whose IRF turns positive around h = 5 and peaks at +20 near h = 24
# while the small VAR stays negative throughout. Comparing |extremum|
# then scores a positive medium-run overshoot against a negative
# contraction and calls the DFM "stronger". It is not the same object.
#
# So three measures, and the headline is the first two:
#   razao_impacto — |h0_DFM| / |h0_VAR|. Same object, and the sign
#     agrees in 18 of 18, so it is unambiguous.
#   peak_ss       — extremum over the INITIAL CONTIGUOUS RUN in which
#     the response keeps its impact sign, i.e. how deep the
#     contractionary response gets before it reverts. Same-signed by
#     construction.
#   peak          — the raw global extremum, kept with an explicit flag
#     for whether its sign matches the impact.
#
# The h <= 12 restriction is also not cosmetic: script/factor_stationarity.R
# (2026-07-31) shows the DFM's medium-run extremum IS the damped
# oscillation of the dominant complex pair — delete the pair and the
# trough inverts in 12 of 14 series. Scoring the DFM on a peak at
# h = 23-48 would score it exactly where that analysis says there is no
# independent evidence.

#' Extremum over the initial run that keeps the impact sign
peak_same_sign <- function(h, y) {
  s0 <- sign(y[1])
  if (s0 == 0) s0 <- sign(y[which(y != 0)[1]])
  flip <- which(sign(y) == -s0)
  last <- if (length(flip)) flip[1] - 1L else length(y)
  i <- which.max(abs(y[1:last]))
  list(h = h[i], val = y[i], n = last)
}

summ <- irf_long |> group_by(model, var, grupo) |>
  summarise(
    h0 = point[h == 0], h3 = point[h == 3], h6 = point[h == 6],
    h12 = point[h == 12], h24 = point[h == 24],
    peak_h = h[which.max(abs(point))],
    peak_val = point[which.max(abs(point))],
    peak_sinal_igual_h0 = sign(point[which.max(abs(point))]) == sign(point[h == 0]),
    peak_ss_h = peak_same_sign(h, point)$h,
    peak_ss_val = peak_same_sign(h, point)$val,
    h_inversao = peak_same_sign(h, point)$n,
    peak_h_cp = h[h <= 12][which.max(abs(point[h <= 12]))],
    peak_val_cp = point[h <= 12][which.max(abs(point[h <= 12]))],
    larg68_h0 = hi68[h == 0] - lo68[h == 0],
    larg68_h12 = hi68[h == 12] - lo68[h == 12],
    n_sig68 = sum(sig68), n_sig90 = sum(sig90),
    n_sig90_cp = sum(sig90[h <= 12]),
    .groups = "drop")

cmp <- summ |>
  select(var, grupo, model, h0, h6, h12, peak_h, peak_val,
         peak_sinal_igual_h0, peak_ss_h, peak_ss_val, h_inversao, peak_h_cp,
         peak_val_cp, larg68_h0, larg68_h12, n_sig68, n_sig90, n_sig90_cp) |>
  pivot_wider(names_from = model,
              values_from = c(h0, h6, h12, peak_h, peak_val,
                              peak_sinal_igual_h0, peak_ss_h, peak_ss_val,
                              h_inversao, peak_h_cp, peak_val_cp, larg68_h0,
                              larg68_h12, n_sig68, n_sig90, n_sig90_cp)) |>
  left_join(data.frame(var = RESPONSES,
                       var_max_eig = vapply(fits, function(f) f$res$max_eig,
                                            numeric(1))),
            by = "var") |>
  mutate(
    razao_impacto  = abs(h0_DFM) / abs(h0_VAR),
    razao_pico_ss  = abs(peak_ss_val_DFM) / abs(peak_ss_val_VAR),
    razao_pico     = abs(peak_val_DFM) / abs(peak_val_VAR),
    razao_pico_cp  = abs(peak_val_cp_DFM) / abs(peak_val_cp_VAR),
    razao_banda_h0 = larg68_h0_DFM / larg68_h0_VAR,
    dfm_mais_forte_h0 = abs(h0_DFM) > abs(h0_VAR),
    dfm_mais_forte_ss = abs(peak_ss_val_DFM) > abs(peak_ss_val_VAR),
    dfm_mais_forte = abs(peak_val_DFM) > abs(peak_val_VAR),
    dfm_mais_forte_cp = abs(peak_val_cp_DFM) > abs(peak_val_cp_VAR),
    dfm_mais_rapido_ss = peak_ss_h_DFM < peak_ss_h_VAR,
    dfm_mais_rapido = peak_h_DFM < peak_h_VAR,
    mesmo_sinal_h0 = sign(h0_DFM) == sign(h0_VAR),
    var_explosivo = var_max_eig >= 1)

print(as.data.frame(cmp |>
        select(var, grupo, h0_DFM, h0_VAR, razao_impacto, peak_ss_h_DFM,
               peak_ss_h_VAR, razao_pico_ss, razao_banda_h0,
               dfm_mais_forte_ss, dfm_mais_rapido_ss)),
      row.names = FALSE, digits = 3)

acoes8 <- grep("^asset_", RESPONSES, value = TRUE)
tally <- function(d, lab) {
  cat(sprintf("\n    %s (n = %d):\n", lab, nrow(d)))
  cat(sprintf("      MAIS FORTE no impacto:            %d de %d (razao mediana %.2f)\n",
              sum(d$dfm_mais_forte_h0), nrow(d), median(d$razao_impacto)))
  cat(sprintf("      MAIS FORTE no pico de mesmo sinal: %d de %d (razao mediana %.2f)\n",
              sum(d$dfm_mais_forte_ss), nrow(d), median(d$razao_pico_ss)))
  cat(sprintf("      MAIS RAPIDO (pico de mesmo sinal): %d de %d\n",
              sum(d$dfm_mais_rapido_ss), nrow(d)))
  cat(sprintf("      [pico bruto, contaminado: forte %d de %d, rapido %d de %d;\n",
              sum(d$dfm_mais_forte), nrow(d), sum(d$dfm_mais_rapido), nrow(d)))
  cat(sprintf("       pico do DFM com sinal OPOSTO ao impacto em %d de %d]\n",
              sum(!d$peak_sinal_igual_h0_DFM), nrow(d)))
  cat(sprintf("      banda de 68%% do DFM mais estreita no impacto: %d de %d (razao mediana %.2f)\n",
              sum(d$razao_banda_h0 < 1), nrow(d), median(d$razao_banda_h0)))
  cat(sprintf("      mesmo sinal no impacto: %d de %d | sig90: DFM %d, VAR %d (h<=12: %d, %d)\n",
              sum(d$mesmo_sinal_h0), nrow(d), sum(d$n_sig90_DFM),
              sum(d$n_sig90_VAR), sum(d$n_sig90_cp_DFM),
              sum(d$n_sig90_cp_VAR)))
}
tally(cmp, "TODAS as respostas")
tally(cmp |> filter(var %in% acoes8), "bloco de ACOES (8 indices)")

expl <- cmp |> filter(var_explosivo)
if (nrow(expl)) {
  cat(sprintf("\n    ATENCAO — %d VAR(s) com companion EXPLOSIVA (max|eig| >= 1): %s\n",
              nrow(expl), paste(sprintf("%s (%.3f)", expl$var,
                                        expl$var_max_eig), collapse = ", ")))
  cat("      4 variaveis x 6 defasagens = 25 parametros por equacao em 147 obs.\n")
  cat("      A correcao de Kilian nao encontra delta que estabilize e avisa.\n")
}

write_csv(cmp, file.path(OUT_DIR, "var_benchmark_compare.csv"))
cat(sprintf("\n    -> %s/var_benchmark_compare.csv (%d rows)\n",
            OUT_DIR, nrow(cmp)))


# ===================================================================
# 6. Figures — VAR left, DFM right, shared y axis (linkaxes)
# ===================================================================
cat("\n[6] figures\n")

pal <- c(VAR = "#7f7f7f", DFM = "steelblue")

one_panel <- function(v, mdl, ylim) {
  d <- irf_long |> filter(var == v, model == mdl)
  ggplot(d, aes(h, point)) +
    geom_ribbon(aes(ymin = lo90, ymax = hi90), fill = pal[[mdl]], alpha = 0.18) +
    geom_ribbon(aes(ymin = lo68, ymax = hi68), fill = pal[[mdl]], alpha = 0.36) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "red",
               linewidth = 0.3) +
    geom_line(linewidth = 0.8) +
    geom_point(data = d |> filter(sig90), size = 1.9, shape = 21,
               fill = "#d95f02", colour = "black", stroke = 0.45) +
    coord_cartesian(ylim = ylim) +      # the linkaxes of MAIN_plotfigs.m
    labs(x = NULL, y = NULL, title = if (mdl == "VAR") v else NULL,
         subtitle = NULL) +
    theme_minimal(base_size = 8) +
    theme(plot.title = element_text(size = 8, hjust = 0))
}

fig_group <- function(vars, file, titulo) {
  rows <- lapply(vars, function(v) {
    d <- irf_long |> filter(var == v)
    yl <- range(c(d$lo90, d$hi90), na.rm = TRUE)
    one_panel(v, "VAR", yl) | one_panel(v, "DFM", yl)
  })
  p <- Reduce(`/`, rows) +
    plot_annotation(title = titulo,
                    subtitle = "esquerda: VAR pequeno (4 variaveis)   |   direita: DFM (r=7, q=6) — mesmo eixo y por linha",
                    theme = theme_minimal(base_size = 9))
  ggsave(file.path(OUT_DIR, file), p, width = 7.5,
         height = 1.5 * length(vars) + 0.8, device = cairo_pdf)
  cat(sprintf("    -> %s/%s\n", OUT_DIR, file))
}

fig_group(VARLIST$risco, "var_benchmark_risco.pdf",
          "Risco soberano e spreads de credito")
fig_group(c(VARLIST$cambio, VARLIST$extensao), "var_benchmark_cambio.pdf",
          "Cambio, curva e atividade")
fig_group(acoes8, "var_benchmark_acoes.pdf", "Indices de acoes da B3")

# Core responses across all VARs against the single DFM panel
core_plot <- lapply(CORE_VARS, function(cv) {
  dv <- core_long |> filter(core == cv)
  i <- match(cv, cell$var_names)
  dd <- data.frame(h = 0:HORIZON, point = cell$irf$irf_point_matrix[i, j],
                   lo68 = cell$irf$ci[["0.68"]]$lower[i, j],
                   hi68 = cell$irf$ci[["0.68"]]$upper[i, j],
                   lo90 = cell$irf$ci[["0.90"]]$lower[i, j],
                   hi90 = cell$irf$ci[["0.90"]]$upper[i, j])
  yl <- range(c(dv$point, dd$lo90, dd$hi90), na.rm = TRUE)
  pv <- ggplot(dv, aes(h, point, group = var_do_var)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "red",
               linewidth = 0.3) +
    geom_line(alpha = 0.5, linewidth = 0.4, colour = "#7f7f7f") +
    coord_cartesian(ylim = yl) +
    labs(x = NULL, y = NULL, title = cv) +
    theme_minimal(base_size = 8)
  pd <- ggplot(dd, aes(h, point)) +
    geom_ribbon(aes(ymin = lo90, ymax = hi90), fill = "steelblue", alpha = 0.18) +
    geom_ribbon(aes(ymin = lo68, ymax = hi68), fill = "steelblue", alpha = 0.36) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "red",
               linewidth = 0.3) +
    geom_line(linewidth = 0.8) + coord_cartesian(ylim = yl) +
    labs(x = NULL, y = NULL) + theme_minimal(base_size = 8)
  pv | pd
})
pc <- Reduce(`/`, core_plot) +
  plot_annotation(title = "Respostas das variaveis core",
                  subtitle = sprintf("esquerda: as %d estimativas do VAR pequeno sobrepostas   |   direita: DFM",
                                     length(RESPONSES)),
                  theme = theme_minimal(base_size = 9))
ggsave(file.path(OUT_DIR, "var_benchmark_core.pdf"), pc, width = 7.5,
       height = 5.5, device = cairo_pdf)
cat(sprintf("    -> %s/var_benchmark_core.pdf\n", OUT_DIR))

# Stability of the core responses across the VARs
core_disp <- core_long |> filter(h %in% c(0, 6, 12, 24)) |>
  group_by(core, h) |>
  summarise(min = min(point), mediana = median(point), max = max(point),
            amplitude = max(point) - min(point), .groups = "drop")
cat("\n    dispersion of the core responses across the VARs:\n")
print(as.data.frame(core_disp), row.names = FALSE, digits = 3)


# ===================================================================
# 7. Report
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

tally_md <- function(d, lab) {
  c(sprintf("**%s** (n = %d)", lab, nrow(d)), "",
    sprintf("- *mais forte no impacto*: **%d de %d** (razão mediana **%.2f**).",
            sum(d$dfm_mais_forte_h0), nrow(d), median(d$razao_impacto)),
    sprintf("- *mais forte no pico de mesmo sinal*: **%d de %d** (razão mediana **%.2f**).",
            sum(d$dfm_mais_forte_ss), nrow(d), median(d$razao_pico_ss)),
    sprintf("- *mais rápido* (pico de mesmo sinal): **%d de %d**.",
            sum(d$dfm_mais_rapido_ss), nrow(d)),
    sprintf("- banda de 68%% do DFM mais **estreita** no impacto: %d de %d (razão mediana **%.2f**).",
            sum(d$razao_banda_h0 < 1), nrow(d), median(d$razao_banda_h0)),
    sprintf("- mesmo sinal no impacto: %d de %d. Células sig90: DFM **%d**, VAR **%d** (em h ≤ 12: %d e %d).",
            sum(d$mesmo_sinal_h0), nrow(d), sum(d$n_sig90_DFM),
            sum(d$n_sig90_VAR), sum(d$n_sig90_cp_DFM), sum(d$n_sig90_cp_VAR)),
    sprintf("- *(pico bruto, a régua contaminada: forte %d de %d, rápido %d de %d — mas o pico do DFM tem sinal **oposto** ao do impacto em %d de %d)*",
            sum(d$dfm_mais_forte), nrow(d), sum(d$dfm_mais_rapido), nrow(d),
            sum(!d$peak_sinal_igual_h0_DFM), nrow(d)),
    "")
}

md <- c(
  "# Benchmark VAR pequeno contra o DFM",
  "",
  "> **Corpo gerado por `script/model_var.R`. Reescrito por inteiro a cada**",
  "> **execução — não escrever prosa aqui.** A leitura interpretativa fica em",
  "> `relatorio/working-notes/2026-07-31_benchmark_var_vs_dfm.md`.",
  "",
  sprintf("Tradução de `codigo_alessi-mark/MAIN_VARloop.m`. Core `{%s}`, `mp_var = %s` (a terceira core, como em `RUN_MAIN_US.m:9`), %d VARs de 4 variáveis, p = %d, h = %d, nboot = %d, seed = %d, bandas %s, instrumento `%s`, painel %d x %d (%s a %s).",
          paste(CORE_VARS, collapse = ", "), MP_VAR, length(RESPONSES),
          P_LAGS, HORIZON, N_BOOT, BOOT_SEED,
          paste0(CI_LEVELS * 100, "%", collapse = "/"), INSTRUMENT,
          nrow(PANEL), ncol(PANEL), format(min(DATES)), format(max(DATES))),
  "",
  "AK reporta percentis 5/10/90/95 (bandas de 90% e 80%); aqui são 68/90, para casar com `irf_coherence_cell.rds`.",
  "",
  "## Regra de leitura, fixada antes dos números",
  "",
  "- *mais forte* = |IRF_DFM(pico)| > |IRF_VAR(pico)|;",
  "- *mais rápido* = h do pico do DFM < h do pico do VAR.",
  "",
  "**Correção da régua, aplicada depois de olhar a figura de ações e antes de",
  "escrever o veredito.** O extremo global do DFM tem sinal **oposto** ao do",
  "impacto nas 8 séries de ações: a IRF vira positiva por volta de h = 5 e chega",
  "a +20 em h ≈ 24, enquanto o VAR pequeno segue negativo. Comparar |extremo|",
  "põe uma alta de médio prazo contra uma queda e chama isso de \"mais forte\".",
  "Passa a valer o **pico de mesmo sinal do impacto** — o extremo dentro do",
  "primeiro trecho contíguo em que a resposta conserva o sinal de h = 0 — e a",
  "**razão de impacto**, que é o mesmo objeto nos dois modelos e concorda em",
  "sinal em 18 de 18. O pico bruto continua tabelado, com a bandeira de sinal.",
  "",
  "Com a identificação mantida fixa, isto testa **DFM contra VAR pequeno**, não",
  "\"contra a literatura\", que identifica por Cholesky.",
  "",
  "## Placar",
  "",
  tally_md(cmp, "Todas as respostas"),
  tally_md(cmp |> filter(var %in% acoes8), "Bloco de ações (8 índices)"),
  "E há uma segunda razão para desconfiar do pico bruto: a nota de 2026-07-31",
  "sobre o espectro da companion mostra que o extremo de médio prazo do DFM *é*",
  "a oscilação amortecida do par complexo dominante — apagar o par inverte o",
  "vale em 12 de 14 séries. Pontuar o DFM por um pico em h = 23-48 seria",
  "pontuá-lo justamente onde aquela análise diz não haver evidência independente.",
  "",
  "## Comparação por resposta",
  "",
  md_tbl(cmp |> select(var, grupo, h0_DFM, h0_VAR, razao_impacto,
                       peak_ss_h_DFM, peak_ss_val_DFM, peak_ss_h_VAR,
                       peak_ss_val_VAR, razao_pico_ss, razao_banda_h0,
                       n_sig90_DFM, n_sig90_VAR), 4),
  "Pico bruto (o extremo global), com a bandeira de sinal:",
  "",
  md_tbl(cmp |> select(var, peak_h_DFM, peak_val_DFM, peak_sinal_igual_h0_DFM,
                       peak_h_VAR, peak_val_VAR, peak_sinal_igual_h0_VAR,
                       razao_pico), 4),
  "## Estabilidade das respostas core entre os VARs",
  "",
  sprintf("Se o VAR pequeno fosse instável, a mesma variável core teria respostas muito diferentes conforme a quarta variável. Amplitude entre os %d VARs:",
          length(RESPONSES)),
  "",
  md_tbl(core_disp, 4),
  "## Diagnóstico da estimação",
  "",
  md_tbl(data.frame(
    var = RESPONSES,
    max_eig = vapply(fits, function(f) f$res$max_eig, numeric(1)),
    explosivo = vapply(fits, function(f) f$res$max_eig >= 1, logical(1)),
    n_inst = vapply(fits, function(f) f$res$n_inst, integer(1)),
    replicas_falhas = vapply(fits, function(f) f$res$n_failed, integer(1))), 4),
  if (nrow(expl))
    sprintf("⚠ **%d VAR(s) com companion explosiva** (max |λ| ≥ 1): %s. São 4 variáveis × 6 defasagens = 25 parâmetros por equação em 147 observações; a correção de Kilian não encontra `delta` que estabilize e emite aviso. É o custo de dimensionalidade do VAR pequeno, medido.",
            nrow(expl), paste(sprintf("`%s` (%.3f)", expl$var,
                                      expl$var_max_eig), collapse = ", "))
  else "Nenhum VAR com companion explosiva."
)

writeLines(md, file.path(OUT_DIR, "var_benchmark.md"))
cat(sprintf("\n-> %s/var_benchmark.md\n", OUT_DIR))
cat("\n=== done ===\n")

invisible(list(fits = fits, irf_long = irf_long, cmp = cmp))
}

if (sys.nframe() == 0) run_benchmark()
