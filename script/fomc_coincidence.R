# ===================================================================
# Does the JK sign filter select FOMC spillover instead of Copom
# policy shocks?
#
# Top item of the council review of 2026-08-10
# (pareceres/council_2026-08-10.md, Objection 1) and the only finding
# of that round prompted by no repository artifact: it was found by
# noticing that R/instrument/build_variants.R:244 computes a
# `fomc_coincide` flag whose input file, data/raw/fomc_dates.csv, had
# never existed. script/instrument.R fell back to an empty vector, so
# the flag was identically FALSE from the day it was written until
# 2026-08-10. registro/metodo.md Etapa 1.4 had specified that
# collection since the project was conceived.
#
# The threat, in one line: a hawkish Fed surprise inside the Wed->Thu
# window raises the DI, drops the Ibovespa (so the JK filter RETAINS
# the day as "policy"), depreciates the BRL and widens EMBI/CDS —
# the entire headline of the paper, with no domestic channel. The
# Bauer-Swanson layer cannot remove it: its RHS is predetermined by
# construction, so a shock realized INSIDE the window passes through
# untouched.
#
# Four tests, in the order the roadmap fixed
# (notas/2026-08-10_roadmap_pos_council.md, item 10):
#
#  0. TIMING. Where in the week does the Fed news land? The statement
#     is released at 14:00 ET, before the B3 DI close (18:00 BRT) and
#     before the 15:30 ET H.15 fixing that DGS2 is quoted at — so it
#     should sit in the WEDNESDAY close, i.e. in the information set
#     the Copom surprise is measured against, which is benign. What
#     can leak into the window is the tail of the press conference
#     and the overnight. Measured as |Delta| Tue->Wed against
#     |Delta| Wed->Thu, split by coincidence.
#
#  1. EXPOSURE. How much of the instrument sits on FOMC-coincident
#     days, by count and by share of Sigma|z|.
#
#  2. THE DECISIVE REGRESSION. `e_di_bs` on the contemporaneous US
#     block over the 62 retained days, with the non-Copom Thursdays
#     as the control, plus the two interactions that ask whether a
#     RETAINED day, or an FOMC-COINCIDENT one, carries more US news
#     per unit of surprise than an ordinary day.
#
#  3. RE-DERIVED MASK. Orthogonalizing the VALUES of the surprise to
#     the contemporaneous global block is what Test C of the sovereign
#     round did; it leaves the SELECTION of the 62 days untouched,
#     against this project's own fidelity audit ("strength lives in
#     the mask"). So both are built and reported separately: values
#     only, and values plus a mask re-derived on the double residuals.
#
# Nothing in R/instrument/, R/modeling/ or script/instrument.R is
# modified. Every variant is built IN MEMORY, and promoting one is a
# separate author decision that this script does not recommend.
#
# READING RULE, FIXED BEFORE THE NUMBERS EXISTED (same discipline as
# `verdict_for()` in script/jk_sovereign_confound.R):
#
#  - The US block jointly significant on the 62 retained days at
#    p_boot < 0.10, OR its interaction with 1(fomc_coincide) over the
#    95 Copom days significant at p_boot < 0.10
#      -> CONTAMINACAO FOMC CONFIRMADA.
#  - Both null, but the re-derived-mask variant drops xi_mp below 3.84
#    or flips the sign of any headline at h = 0
#      -> SINAL FRACO.
#  - Both null otherwise
#      -> CONFOUND FOMC NAO DETECTADO.
#
# THE RULE HAD A THIRD LEG, AND THIS IS THE RECORD OF ITS REMOVAL. Test
# 4 cut the 62 retained days by FOMC coincidence and re-estimated both
# halves, and the pre-registered rule required the non-FOMC half to
# preserve the headline signs with the production point inside its CI90,
# under a power clause that would qualify the verdict if that half came
# out below xi_mp 3.84. On the 2026-08-10 run the leg was SATISFIED and
# the power clause was NOT triggered, while the FOMC half came out with
# an unbounded AR set and could not be cited in either direction, which
# is why the split was dropped that day together with its two bootstrap
# cells. Removing a leg that PASSED makes the rule strictly more
# permissive, so the verdict cannot have changed because of the cut,
# and re-running confirmed max |diff| = 0 on every surviving row. The
# half-sample numbers are in the git history and are NOT reproducible
# from this script. Do not cite them.
# See registro/historico_decisoes.md.
#
# Outputs: output/instrument/fomc_coincidence.csv
#          output/instrument/fomc_coincidence.md
#          output/instrument/fomc_coincidence_days.csv
#          output/instrument/fomc_coincidence_irf_overlay.pdf
# ===================================================================

rm(list = ls())

source("R/instrument/di_surprise.R")
source("R/instrument/build_variants.R")
source("R/instrument/event_tests.R")       # wild_coef_test, wild_wald_test
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")    # norm_value_for, run_stage2_cell,
                                           # plot_overlay_cells, md_table

set.seed(20260810)


# ---- Config --------------------------------------------------------

# Instrument construction: production values (script/instrument.R)
SPEC         <- production_spec()
SAMPLE_START <- SPEC$event_sample[1]
SAMPLE_END   <- SPEC$event_sample[2]
LOAD_START   <- as.Date("2012-06-01")
TARGET_BD    <- 126
AGG_SCHEME   <- "sum"

# Estimation: production spec (script/irf_coherence_check.R)
R_FACTORS <- SPEC$r
Q_DYNAMIC <- SPEC$q
P_LAGS    <- SPEC$p
MP_VAR    <- SPEC$mp_var
HORIZON   <- SPEC$horizon
N_BOOT    <- SPEC$nboot
BOOT_SEED <- SPEC$bootstrap_seed
SHOCK_BPS <- SPEC$shock_bps
CI_LEVELS <- SPEC$ci_levels

SAMPLES <- list(
  full = SPEC$sample,
  pre_covid = SPEC$pre_covid_sample
)

NBOOT_P <- 2000L   # wild-bootstrap draws for the daily regressions

# The contemporaneous global block. `d_ust2` and `r_sp500` are the two the
# council named; `d_vix` and `r_brent` complete the block that the legacy
# contemporaneous purification already used, so the re-derived mask is a
# strict superset of both.
US_BLOCK     <- c("d_ust2", "r_sp500")
GLOBAL_BLOCK <- c("d_ust2", "r_sp500", "d_vix", "r_brent")

DATA_PATH  <- SPEC$data_path
INST_PATH  <- SPEC$instrument_path
EVENT_PATH <- "data/processed/copom_event_diagnostics.csv"
OUT_DIR    <- "output/instrument"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

cat("=== Coincidencia FOMC ===\n\n")


# ===================================================================
# 1. Daily event panel, now with a populated fomc_coincide
# ===================================================================

cat("[1] painel diario de quintas-feiras\n")

di_panel <- load_di_panel("data/raw/di.csv", from = LOAD_START, to = SAMPLE_END + 30)

ibov_daily <- readr::read_csv("data/processed/ibov_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), ibov = as.numeric(ibov)) |>
  dplyr::filter(!is.na(ibov))

ext_daily <- readr::read_csv("data/raw/investing/external_factors_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), sp500 = as.numeric(sp500),
            vix = as.numeric(vix), brent = as.numeric(brent))

brl_daily <- readr::read_csv("data/processed/brl_usd_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), brl = as.numeric(brl)) |>
  dplyr::filter(!is.na(brl))

focus_daily <- readr::read_csv("data/processed/focus_daily.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date),
            focus_ipca12m  = as.numeric(focus_ipca12m),
            focus_selic_ny = as.numeric(focus_selic_ny))

dgs2_daily <- readr::read_csv("data/raw/fred_dgs2.csv", show_col_types = FALSE) |>
  dplyr::transmute(date = as.Date(date), ust2y = as.numeric(ust2y))

copom_wed  <- load_copom_wednesdays(from = LOAD_START, to = SAMPLE_END)
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

cat(sprintf("    %d quintas validas | %d Copom | jk_bs %d | FOMC-coincidentes %d (retidos: %d)\n",
            built$diag$n_valid, built$diag$n_copom, built$diag$n_jk_bs,
            sum(valid$fomc_coincide), sum(valid$fomc_coincide & valid$jk_monetary_bs)))

stopifnot(built$diag$n_copom == 95L, built$diag$n_jk_bs == 62L,
          sum(valid$fomc_coincide) > 0L)

# Self-test: the rebuild must match the persisted event file exactly. Compare
# values, not identical(): masks built from sign(residuals(lm)) carry a `names`
# attribute that the round-trip through CSV drops.
ev <- readr::read_csv(EVENT_PATH, show_col_types = FALSE) |> dplyr::mutate(date = as.Date(date))
shared <- intersect(names(ev), names(valid))
jn <- dplyr::inner_join(ev |> dplyr::select(dplyr::all_of(shared)), valid |> dplyr::select(dplyr::all_of(shared)),
                 by = "date", suffix = c(".disk", ".new"))
num_cols <- setdiff(shared[vapply(ev[shared], is.numeric, logical(1))], "date")
maxdiff <- max(vapply(num_cols, function(cc)
  max(abs(jn[[paste0(cc, ".disk")]] - jn[[paste0(cc, ".new")]]), na.rm = TRUE), numeric(1)))
lgl_cols <- shared[vapply(ev[shared], is.logical, logical(1))]
lgl_ok <- all(vapply(lgl_cols, function(cc)
  all(unname(jn[[paste0(cc, ".disk")]]) == unname(jn[[paste0(cc, ".new")]])), logical(1)))
cat(sprintf("    self-test vs %s: n = %d, max |dif| = %.3g, mascaras iguais = %s\n",
            basename(EVENT_PATH), nrow(jn), maxdiff, lgl_ok))
stopifnot(nrow(jn) == nrow(ev), maxdiff < 1e-8, lgl_ok)


# ===================================================================
# 2. TEST 0 — where in the week does the Fed news land?
# ===================================================================
# Explicit date lookup (`date - 1`, `date - 2`), never dplyr::lag(): the UST
# and S&P calendars have their own holidays, and a lag() would silently span
# a longer window whenever one of them was shut.

cat("\n[0] timing: Ter->Qua (janela do FOMC) vs Qua->Qui (janela do instrumento)\n")

sp500_daily <- ext_daily |> dplyr::select(date, sp500) |> dplyr::filter(!is.na(sp500)) |> dplyr::arrange(date)
ust_daily   <- dgs2_daily |> dplyr::arrange(date)

thu <- valid$date
timing <- tibble::tibble(
  date          = thu,
  copom_day     = valid$copom_day,
  fomc_coincide = valid$fomc_coincide,
  ust2_ter_qua  = 100 * (on_date(thu - 1, ust_daily, "ust2y") -
                         on_date(thu - 2, ust_daily, "ust2y")),
  ust2_qua_qui  = 100 * (on_date(thu,     ust_daily, "ust2y") -
                         on_date(thu - 1, ust_daily, "ust2y")),
  sp500_ter_qua = 100 * (log(on_date(thu - 1, sp500_daily, "sp500")) -
                         log(on_date(thu - 2, sp500_daily, "sp500"))),
  sp500_qua_qui = 100 * (log(on_date(thu,     sp500_daily, "sp500")) -
                         log(on_date(thu - 1, sp500_daily, "sp500")))
)

timing_tbl <- timing |>
  dplyr::filter(copom_day) |>
  dplyr::mutate(grupo = ifelse(fomc_coincide, "Copom no dia do FOMC", "Copom sem FOMC")) |>
  dplyr::group_by(grupo, fomc_coincide) |>
  dplyr::summarise(
    n              = dplyr::n(),
    ust2_ter_qua   = median(abs(ust2_ter_qua),  na.rm = TRUE),
    ust2_qua_qui   = median(abs(ust2_qua_qui),  na.rm = TRUE),
    sp500_ter_qua  = median(abs(sp500_ter_qua), na.rm = TRUE),
    sp500_qua_qui  = median(abs(sp500_qua_qui), na.rm = TRUE),
    sd_ust2_ter_qua = sd(ust2_ter_qua,  na.rm = TRUE),
    sd_ust2_qua_qui = sd(ust2_qua_qui,  na.rm = TRUE),
    .groups = "drop") |>
  dplyr::mutate(teste = "timing")

for (i in seq_len(nrow(timing_tbl))) {
  cat(sprintf("    %-22s n = %2d | UST2y mediana |d| Ter->Qua %.2f bp vs Qua->Qui %.2f bp | S&P %.2f%% vs %.2f%%\n",
              timing_tbl$grupo[i], timing_tbl$n[i],
              timing_tbl$ust2_ter_qua[i], timing_tbl$ust2_qua_qui[i],
              timing_tbl$sp500_ter_qua[i], timing_tbl$sp500_qua_qui[i]))
}
fomc_row <- timing_tbl |> dplyr::filter(fomc_coincide)
ust_before <- fomc_row$ust2_ter_qua  > fomc_row$ust2_qua_qui
sp_before  <- fomc_row$sp500_ter_qua > fomc_row$sp500_qua_qui
cat(sprintf("    -> noticia do Fed ANTES da janela: taxa americana %s | acoes americanas %s\n",
            ust_before, sp_before))


# ===================================================================
# 3. TEST 1 — exposure accounting
# ===================================================================

cat("\n[1] exposicao do instrumento a dias com FOMC\n")

days <- valid |>
  dplyr::filter(copom_day) |>
  dplyr::mutate(w = ifelse(jk_monetary_bs, abs(unname(e_di_bs)), 0),
         share_sample = w / sum(w),
         ano = lubridate::year(date))

retained <- days |> dplyr::filter(jk_monetary_bs)
n_ret_fomc  <- sum(retained$fomc_coincide)
sh_ret_fomc <- sum(retained$share_sample[retained$fomc_coincide])

top20 <- days |> dplyr::arrange(dplyr::desc(share_sample)) |> dplyr::slice_head(n = 20)

exposure_tbl <- tibble::tibble(
  teste    = "exposicao",
  conjunto = c("Copom (todos)", "retidos (jk_bs)", "top-20 por alavancagem"),
  n        = c(nrow(days), nrow(retained), nrow(top20)),
  n_fomc   = c(sum(days$fomc_coincide), n_ret_fomc, sum(top20$fomc_coincide)),
  share_z  = c(sum(days$share_sample[days$fomc_coincide]), sh_ret_fomc,
               sum(top20$share_sample[top20$fomc_coincide])))

for (i in seq_len(nrow(exposure_tbl))) {
  cat(sprintf("    %-24s %2d de %2d coincidem | %.1f%% de Sigma|z|\n",
              exposure_tbl$conjunto[i], exposure_tbl$n_fomc[i],
              exposure_tbl$n[i], 100 * exposure_tbl$share_z[i]))
}

by_year_tbl <- days |>
  dplyr::count(ano, fomc_coincide) |>
  tidyr::pivot_wider(names_from = fomc_coincide, values_from = n, values_fill = 0,
              names_prefix = "fomc_") |>
  dplyr::rename(sem_fomc = fomc_FALSE, com_fomc = fomc_TRUE) |>
  dplyr::mutate(teste = "exposicao_ano")


# ===================================================================
# 4. TEST 2 — the decisive daily regression
# ===================================================================

cat("\n[2] regressao decisiva: e_di_bs no bloco americano contemporaneo\n")

DAY_SETS <- list(
  list(tag = "jk_bs (producao)",      sel = valid$jk_monetary_bs),
  list(tag = "copom (todos)",         sel = valid$copom_day),
  list(tag = "copom rejeitados",      sel = valid$copom_day & !valid$jk_monetary_bs),
  list(tag = "copom com FOMC",        sel = valid$copom_day & valid$fomc_coincide),
  list(tag = "copom sem FOMC",        sel = valid$copom_day & !valid$fomc_coincide),
  list(tag = "nao-copom (controle)",  sel = !valid$copom_day)
)

rows_lvl <- list()
for (ds in DAY_SETS) {
  d <- valid[ds$sel, c("e_di_bs", GLOBAL_BLOCK)]
  for (rv in US_BLOCK) {
    res <- wild_coef_test(as.formula(paste("e_di_bs ~", paste(US_BLOCK, collapse = " + "))),
                          d, rv, key = paste("nivel", rv, ds$tag), nboot = NBOOT_P)
    rows_lvl[[length(rows_lvl) + 1]] <- dplyr::bind_cols(
      tibble::tibble(teste = "regressao_nivel", regressor = rv, conjunto = ds$tag), res)
  }
}
testR <- dplyr::bind_rows(rows_lvl)

rows_j <- list()
for (ds in DAY_SETS) {
  d <- valid[ds$sel, c("e_di_bs", GLOBAL_BLOCK)]
  for (blk in list(list(nm = "bloco US (d_ust2 + r_sp500)", v = US_BLOCK),
                   list(nm = "bloco global (US + VIX + Brent)", v = GLOBAL_BLOCK))) {
    res <- wild_wald_test(as.formula(paste("e_di_bs ~", paste(blk$v, collapse = " + "))),
                          d, blk$v, key = paste("conjunto", blk$nm, ds$tag), nboot = NBOOT_P)
    rows_j[[length(rows_j) + 1]] <- dplyr::bind_cols(
      tibble::tibble(teste = "regressao_conjunta", regressor = blk$nm, conjunto = ds$tag), res)
  }
}
testJ <- dplyr::bind_rows(rows_j)

for (i in seq_len(nrow(testJ))) {
  cat(sprintf("    %-32s %-22s n = %3d  F_rob = %6.2f  p_boot = %.3f  R2 = %.4f\n",
              testJ$regressor[i], testJ$conjunto[i], testJ$n[i],
              testJ$f_rob[i], testJ$p_boot[i], testJ$r2[i]))
}

# The two interactions. Contamination requires the selected day to carry MORE
# US news per unit of surprise than the comparison day — that is the
# interaction, not the level of the coefficient. Same design as the
# `x:1(jk_bs)` statistic that decides the sovereign test.
int_us <- c("d_ust2:sel", "r_sp500:sel")
fml_int <- as.formula(paste("e_di_bs ~ (", paste(US_BLOCK, collapse = " + "), ") * sel"))

d_int_fomc <- valid |> dplyr::filter(copom_day) |>
  dplyr::transmute(e_di_bs, d_ust2, r_sp500, sel = as.numeric(fomc_coincide))
int_fomc <- wild_wald_test(fml_int, d_int_fomc, int_us,
                           key = "interacao_fomc", nboot = NBOOT_P)

d_int_jk <- valid |> dplyr::transmute(e_di_bs, d_ust2, r_sp500,
                               sel = as.numeric(jk_monetary_bs))
int_jk <- wild_wald_test(fml_int, d_int_jk, int_us,
                         key = "interacao_jk", nboot = NBOOT_P)

testI <- dplyr::bind_rows(
  dplyr::bind_cols(tibble::tibble(teste = "interacao", regressor = "bloco US x 1(fomc_coincide)",
                   conjunto = "95 dias Copom"), int_fomc),
  dplyr::bind_cols(tibble::tibble(teste = "interacao", regressor = "bloco US x 1(jk_bs)",
                   conjunto = "todas as quintas validas"), int_jk))

cat("    interacoes (a estatistica que decide):\n")
for (i in seq_len(nrow(testI))) {
  cat(sprintf("      %-30s n = %3d  F_rob = %6.2f  p_boot = %.3f\n",
              testI$regressor[i], testI$n[i], testI$f_rob[i], testI$p_boot[i]))
}

joint_62 <- testJ |> dplyr::filter(conjunto == "jk_bs (producao)",
                            regressor == "bloco US (d_ust2 + r_sp500)")


# ===================================================================
# 5. TEST 3 — orthogonalized values and re-derived mask
# ===================================================================

cat("\n[3] mascara re-derivada\n")

glob_rhs <- as.formula(paste("~", paste(GLOBAL_BLOCK, collapse = " + ")))
fit_di_g   <- lm(update(glob_rhs, e_di_bs   ~ .), data = valid, na.action = na.exclude)
fit_ibov_g <- lm(update(glob_rhs, e_ibov_bs ~ .), data = valid, na.action = na.exclude)

valid$e_di_bs_glob   <- as.numeric(residuals(fit_di_g))
valid$e_ibov_bs_glob <- as.numeric(residuals(fit_ibov_g))

valid$jk_monetary_bs_glob <- valid$copom_day &
  sign(valid$e_di_bs_glob) != 0 & sign(valid$e_ibov_bs_glob) != 0 &
  sign(valid$e_di_bs_glob) != sign(valid$e_ibov_bs_glob)

n_glob    <- sum(valid$jk_monetary_bs_glob)
n_survive <- sum(valid$jk_monetary_bs & valid$jk_monetary_bs_glob)
cat(sprintf("    R2 do bloco global: e_di_bs %.4f | e_ibov_bs %.4f\n",
            summary(fit_di_g)$r.squared, summary(fit_ibov_g)$r.squared))
cat(sprintf("    mascara re-derivada: %d dias (%d dos 62 de producao sobrevivem, %d novos)\n",
            n_glob, n_survive, n_glob - n_survive))

mask_tbl <- tibble::tibble(
  teste     = "mascara",
  conjunto  = c("producao (jk_bs)", "re-derivada (jk_bs_glob)",
                "intersecao", "com FOMC (de 62)", "sem FOMC (de 62)"),
  n         = c(sum(valid$jk_monetary_bs), n_glob, n_survive,
                n_ret_fomc, sum(valid$jk_monetary_bs) - n_ret_fomc))

monthly_grid <- tibble::tibble(month = seq(lubridate::floor_date(SAMPLE_START, "month"),
                                   lubridate::floor_date(SAMPLE_END, "month"), by = "month"))

inst_wide <- monthly_grid |>
  dplyr::mutate(
    z_jk_bs_purif  = build_monthly_z("e_di_bs", valid$jk_monetary_bs, valid, monthly_grid),
    # values orthogonalized, mask untouched — the Test C form of the
    # sovereign round, kept separate so the mask channel is readable
    z_jk_bs_noglob = build_monthly_z("e_di_bs_glob", valid$jk_monetary_bs, valid, monthly_grid),
    # values orthogonalized AND mask re-derived on the double residuals
    z_jk_bs_glob   = build_monthly_z("e_di_bs_glob", valid$jk_monetary_bs_glob, valid, monthly_grid),
    # the purely contemporaneous sibling, free: e_di_us / jk_monetary_us
    # already include d_ust2 (build_variants.R:324-335)
    z_jk_us        = build_monthly_z("e_di_us", valid$jk_monetary_us, valid, monthly_grid)
  )

# Self-test: the recomputed production column must equal the one on disk.
prod_panel <- readr::read_csv(INST_PATH, show_col_types = FALSE) |> dplyr::mutate(month = as.Date(month))
chk <- dplyr::inner_join(inst_wide |> dplyr::select(month, mine = z_jk_bs_purif),
                  prod_panel |> dplyr::select(month, disk = z_jk_bs_purif), by = "month")
cat(sprintf("    z_jk_bs_purif reconstruido vs disco: n = %d, max |dif| = %.3g\n",
            nrow(chk), max(abs(chk$mine - chk$disk))))
stopifnot(nrow(chk) == nrow(prod_panel), max(abs(chk$mine - chk$disk)) < 1e-10)

Z_VARIANTS <- c("z_jk_bs_purif", "z_jk_bs_noglob", "z_jk_bs_glob", "z_jk_us")


# ===================================================================
# 6. xi_mp of each variant
# ===================================================================

cat("\n[4] xi_mp por variante e janela\n")

panel_raw <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |> tidyr::drop_na()
dates     <- as.Date(panel_raw$ref.date)
data_mat  <- panel_raw |> dplyr::select(-ref.date) |> as.matrix()
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
    rowsX[[length(rowsX) + 1]] <- tibble::tibble(
      teste = "xi_mp", amostra = sn, instrumento = v,
      meses_nao_nulos = n_nz, xi_mp = dg$wald_mp,
      f_robust_mp = dg$f_robust_mp,
      # Pre-normalization impact of the policy variable: the denominator every
      # IRF of the cell is divided by. It is what makes a weaker variant print
      # LARGER responses, so it has to be reported next to xi_mp rather than
      # inferred from it.
      impacto_mp_pre = dg$impact_mp)
    cat(sprintf("    %-9s %-15s meses!=0 = %3d  xi_mp = %7.3f\n", sn, v, n_nz, dg$wald_mp))
  }
}
xi_tbl <- dplyr::bind_rows(rowsX) |>
  dplyr::group_by(amostra) |>
  dplyr::mutate(ar_limitada = xi_mp > 3.84, bandas_validas = xi_mp >= 10,
         denom_vs_prod = impacto_mp_pre /
           impacto_mp_pre[instrumento == "z_jk_bs_purif"]) |>
  dplyr::ungroup()

# Cross-check against the strength ruler of record.
xi_prod <- xi_tbl |> dplyr::filter(instrumento == "z_jk_bs_purif")
xi_prod_full <- xi_prod$xi_mp[xi_prod$amostra == "full"]
xi_prod_pre  <- xi_prod$xi_mp[xi_prod$amostra == "pre_covid"]
strength_grid <- readr::read_csv("output/instrument/mosw_strength_grid.csv", show_col_types = FALSE) |>
  dplyr::filter(r == R_FACTORS, q == Q_DYNAMIC, instrument == "z_jk_bs_purif")
grid_full <- strength_grid$wald_mp[strength_grid$sample == "full"]
grid_pre <- strength_grid$wald_mp[strength_grid$sample == "pre_covid"]
cat(sprintf("    check: producao full %.2f (grid %.2f) | pre_covid %.2f (grid %.2f)\n",
            xi_prod_full, grid_full, xi_prod_pre, grid_pre))
stopifnot(length(grid_full) == 1L, length(grid_pre) == 1L,
          abs(xi_prod_full - grid_full) < 1e-8,
          abs(xi_prod_pre - grid_pre) < 1e-8)

xi_of <- function(v, sn = "full") {
  xi_tbl$xi_mp[xi_tbl$instrumento == v & xi_tbl$amostra == sn]
}


# ===================================================================
# 7. IRFs with the full production bootstrap
# ===================================================================

# Only the two the verdict reads. `z_jk_bs_noglob` and `z_jk_us` stay in the
# xi_mp table, where their whole content is: the first measures what
# orthogonalizing the VALUES alone costs, and neither enters any leg of the
# reading rule, so bootstrapping them would spend a cell on nothing.
IRF_VARIANTS <- c("z_jk_bs_purif", "z_jk_bs_glob")
FIVE <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd", "asset_ibov")
HEADLINE <- c(FIVE, "embi_perc", "cds_5y", "price_ipca", "price_ipp")
HEADLINE <- HEADLINE[HEADLINE %in% var_names]

cat(sprintf("\n[5] IRFs (nboot = %d) para %d variantes\n", N_BOOT, length(IRF_VARIANTS)))

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
  cat(sprintf("    %-15s %.1f min\n", v, as.numeric(Sys.time() - t0, units = "mins")))
}

# End-to-end self-test against the independently gated 111-series production cell.
Pref <- cells[["z_jk_bs_purif"]]$irf$irf_point_matrix
smoke <- c(yield_6m = 0.005,
           yield_2y = 0.00728187686052304,
           yield_5y = 0.00748309266828703,
           asset_ibov = -0.967984890593469,
           cambio_usd = 0.153855051208318)
got <- Pref[match(names(smoke), var_names), 1]
cat("    smoke test h0: ")
cat(paste(sprintf("%s %.6g", names(smoke), got), collapse = " | "), "\n")
stopifnot(max(abs(got - smoke)) < 5e-6)

irf_rows <- purrr::imap_dfr(cells, function(cell, tag) {
  p <- cell$irf$irf_point_matrix
  lo68 <- cell$irf$ci[["0.68"]]$lower; hi68 <- cell$irf$ci[["0.68"]]$upper
  lo90 <- cell$irf$ci[["0.90"]]$lower; hi90 <- cell$irf$ci[["0.90"]]$upper
  purrr::map_dfr(HEADLINE, function(vn) {
    i <- match(vn, var_names)
    tibble::tibble(teste = "IRF", instrumento = tag, variavel = vn, h = 0:HORIZON,
           ponto = p[i, ], lo68 = lo68[i, ], hi68 = hi68[i, ],
           lo90 = lo90[i, ], hi90 = hi90[i, ]) |>
      dplyr::mutate(sig68 = (lo68 > 0) | (hi68 < 0), sig90 = (lo90 > 0) | (hi90 < 0))
  })
})

h0 <- irf_rows |> dplyr::filter(h == 0)
prod_h0 <- h0 |> dplyr::filter(instrumento == "z_jk_bs_purif") |>
  dplyr::select(variavel, ponto_prod = ponto)

# yield_6m is excluded from the sign comparison: its h = 0 is the normalization
# target, identical in every variant by construction.
sign_check <- function(v) {
  cmp <- h0 |> dplyr::filter(instrumento == v, variavel %in% setdiff(FIVE, MP_VAR)) |>
    dplyr::inner_join(prod_h0, by = "variavel")
  list(sinais_ok = all(sign(cmp$ponto) == sign(cmp$ponto_prod)),
       prod_no_ci90 = all(cmp$ponto_prod >= cmp$lo90 & cmp$ponto_prod <= cmp$hi90))
}
chk_glob <- sign_check("z_jk_bs_glob")


# ===================================================================
# 8. The verdict, by the rule fixed in the header
# ===================================================================

leg_confirm <- isTRUE(joint_62$p_boot < 0.10) ||
               isTRUE(int_fomc$p_boot < 0.10)
leg_weak    <- xi_of("z_jk_bs_glob") <= 3.84 || !chk_glob$sinais_ok

verdict <- if (leg_confirm) {
  "CONTAMINACAO FOMC CONFIRMADA"
} else if (leg_weak) {
  "SINAL FRACO DE CONTAMINACAO FOMC"
} else {
  "CONFOUND FOMC NAO DETECTADO"
}

cat(sprintf("\n    >>> VEREDITO: %s\n", verdict))


# ===================================================================
# 9. Outputs
# ===================================================================

pal <- c(z_jk_bs_purif = "#1b1b1b", z_jk_bs_glob = "#0072B2")
resp_idx <- setNames(as.list(match(HEADLINE, var_names)), HEADLINE)

pdf(file.path(OUT_DIR, "fomc_coincidence_irf_overlay.pdf"), width = 12, height = 10)
print(
  plot_overlay_cells(cells, resp_idx, horizon = 36, palette = pal, subtitle = "") +
    patchwork::plot_annotation(
      title = "Coincidencia FOMC: producao vs. mascara re-derivada no bloco global",
      subtitle = sprintf(
        "r=%d q=%d p=%d | %s | +%dbp | nboot=%d | bandas 68/90 | amostra cheia",
        R_FACTORS, Q_DYNAMIC, P_LAGS, MP_VAR, SHOCK_BPS, N_BOOT))
)
dev.off()
cat(sprintf("\n-> %s/fomc_coincidence_irf_overlay.pdf\n", OUT_DIR))

# Rebuilt from `valid` rather than from `days`, which was cut in section [1],
# before the orthogonalized columns of section [3] existed.
days_tbl <- valid |>
  dplyr::filter(copom_day) |>
  dplyr::left_join(days |> dplyr::select(date, share_sample), by = "date") |>
  dplyr::transmute(reuniao = date - 1, quinta = date, fomc_coincide,
            delta_di, e_di_bs = unname(e_di_bs), r_ibov, e_ibov_bs = unname(e_ibov_bs),
            d_ust2, r_sp500, d_vix, r_brent,
            e_di_bs_glob, e_ibov_bs_glob,
            jk_monetary_bs, jk_monetary_bs_glob, share_sample) |>
  dplyr::arrange(dplyr::desc(share_sample))
readr::write_csv(days_tbl, file.path(OUT_DIR, "fomc_coincidence_days.csv"))
cat(sprintf("-> %s/fomc_coincidence_days.csv (%d linhas)\n", OUT_DIR, nrow(days_tbl)))

all_cells <- dplyr::bind_rows(
  testR, testJ, testI, xi_tbl, irf_rows,
  timing_tbl, exposure_tbl, by_year_tbl, mask_tbl)
readr::write_csv(all_cells, file.path(OUT_DIR, "fomc_coincidence.csv"))

fmt <- function(x, d = 2) formatC(x, format = "f", digits = d)

md <- c(
  "# Coincidencia FOMC no instrumento Copom — teste diario e reestimacao",
  "",
  sprintf("*Gerado por `script/fomc_coincidence.R` em %s. **Corpo gerado: nao escreva prosa aqui.** A leitura interpretativa vive em `notas/2026-08-10_coincidencia_fomc.md`.*",
          format(Sys.Date())),
  "",
  "## A pergunta",
  "",
  "A surpresa de producao `e_di_bs` e residualizada so em regressores **predeterminados**, entao um choque realizado *dentro* da janela Qua->Qui e ortogonal a essa RHS por construcao e passa direto. Uma surpresa hawkish do Fed sobe o DI, derruba o Ibovespa — e o filtro JK **retem** o dia como \"politica\" — deprecia o BRL e abre EMBI/CDS. E o resultado central inteiro, sem canal domestico.",
  "",
  sprintf("Ate 2026-08-10 o repositorio nao tinha como responder: `R/instrument/build_variants.R:244` computa `fomc_coincide`, mas `data/raw/fomc_dates.csv` nunca existiu e `script/instrument.R` caia num vetor vazio, entao a flag era **sempre FALSE**. As datas agora vem de `script/fomc_dates.R` (paginas de calendario do proprio Fed): **%d dos %d dias Copom** da amostra coincidem com decisao do FOMC.",
          sum(days$fomc_coincide), nrow(days)),
  "",
  "## Regra de leitura, fixada antes de os numeros existirem",
  "",
  "- Bloco americano conjuntamente significativo nos 62 dias retidos (`p_boot < 0,10`) **ou** interacao com `1(fomc_coincide)` significativa -> **contaminacao confirmada**.",
  "- Ambos nulos, mas a mascara re-derivada derruba ξ_mp abaixo de 3,84 ou inverte um sinal em h=0 -> **sinal fraco**.",
  "- Ambos nulos no restante -> **confound nao detectado**.",
  "",
  "A regra tinha uma terceira perna, retirada em 2026-08-10 junto com o teste que a alimentava. A divisao dos 62 dias retidos em metades com e sem FOMC exigia que a metade sem-FOMC preservasse os sinais das manchetes com o ponto de producao dentro do CI90 dela, e na rodada daquele dia essa perna **passou** sem acionar a clausula de poder, enquanto a metade *com* FOMC saiu com conjunto AR ilimitado e portanto inutilizavel para citacao em qualquer direcao. Retirar uma perna satisfeita torna a regra estritamente mais permissiva, de modo que o veredito nao pode ter mudado por causa do corte. Os numeros das duas metades estao no historico do git e **nao sao reproduziveis por este script**. Registro em `registro/historico_decisoes.md`.",
  "",
  sprintf("**Veredito: %s.**", verdict),
  "",
  "## 0 — Onde no calendario a noticia do Fed cai",
  "",
  "Pre-requisito de toda a leitura, e um argumento de horario antes de ser um numero: o comunicado do FOMC sai as **14:00 ET**, antes do fechamento do DI na B3 (18:00 BRT) e antes do fixing das 15:30 ET a que o DGS2 e cotado. Logo a noticia deveria estar **no fechamento de quarta** — isto e, no conjunto de informacao contra o qual a surpresa do Copom e medida, o que e benigno. O que pode vazar para dentro da janela e a cauda da coletiva e o overnight.",
  "",
  "Mediana de |Δ| por janela, sobre os dias Copom:",
  "",
  md_table(timing_tbl |> dplyr::select(grupo, n, ust2_ter_qua, ust2_qua_qui,
                                sp500_ter_qua, sp500_qua_qui)),
  "",
  sprintf("Em semanas com FOMC o UST 2a move mediana **%s bp** de Ter->Qua contra **%s bp** de Qua->Qui (antes da janela: %s), e o S&P 500 move **%s%%** contra **%s%%** (antes da janela: %s).",
          fmt(fomc_row$ust2_ter_qua), fmt(fomc_row$ust2_qua_qui), ust_before,
          fmt(fomc_row$sp500_ter_qua), fmt(fomc_row$sp500_qua_qui), sp_before),
  "",
  "⚠ **As duas pernas nao concordam, e isso e o resultado, nao um rodape.** A perna de *taxa* — que e por onde uma surpresa de politica monetaria americana viaja — cai majoritariamente antes da janela, como o horario previa. A perna de *acoes* nao: o S&P se move **mais** de Qua->Qui, isto e, a reacao do mercado acionario a decisao continua no dia seguinte e **esta** dentro da janela. Logo o argumento de horario cobre parte da ameaca e nao toda ela, e sao os testes 2 a 4 que decidem.",
  "",
  "## 1 — Exposicao do instrumento",
  "",
  md_table(exposure_tbl |> dplyr::select(conjunto, n, n_fomc, share_z)),
  "",
  "`share_z` e a fracao de Σ|z| — que corre **so sobre os dias retidos**, ja que um dia filtrado entra no instrumento com peso zero. E por isso que a linha \"Copom (todos)\" repete a fracao da linha \"retidos\": e aritmetica, nao coincidencia.",
  "",
  sprintf("Dos %d dias retidos pelo filtro JK, **%d coincidem com FOMC** e carregam **%.1f%% de Σ|z|**. Por ano:",
          nrow(retained), n_ret_fomc, 100 * sh_ret_fomc),
  "",
  md_table(by_year_tbl |> dplyr::select(ano, sem_fomc, com_fomc)),
  "",
  "## 2 — A regressao decisiva",
  "",
  "`e_di_bs` no bloco contemporaneo, HC1, `p_boot` por wild bootstrap sob a nula restrita, cada celula semeada pela propria identidade. O conjunto **nao-Copom** e o controle.",
  "",
  "### Coeficiente a coeficiente",
  "",
  md_table(testR |> dplyr::select(regressor, conjunto, n, coef, se_hc1, t, p_asym, p_boot, r2)),
  "",
  "### Teste conjunto do bloco",
  "",
  md_table(testJ |> dplyr::select(regressor, conjunto, n, k, f_rob, p_asym, p_boot, r2)),
  "",
  "### Interacoes — a estatistica que decide",
  "",
  "Contaminacao exige que o dia selecionado carregue **mais** noticia americana por unidade de surpresa que o dia de comparacao.",
  "",
  md_table(testI |> dplyr::select(regressor, conjunto, n, k, f_rob, p_asym, p_boot)),
  "",
  "## 3 — Mascara re-derivada: valores contra selecao",
  "",
  sprintf("Ortogonalizar so os **valores** ao bloco global e a forma do Teste C da rodada soberana; ele deixa a **selecao** dos dias intacta, contra a propria auditoria de fidelidade do projeto (\"a forca vive na mascara\"). Por isso as duas variantes existem separadas. Re-derivando a mascara nos residuos duplos de `e_di_bs`/`e_ibov_bs`: **%d dias**, dos quais **%d dos 62** de producao sobrevivem.",
          n_glob, n_survive),
  "",
  md_table(mask_tbl |> dplyr::select(conjunto, n)),
  "",
  "## 4 — Forca: xi_mp por variante",
  "",
  md_table(xi_tbl |> dplyr::select(amostra, instrumento, meses_nao_nulos, xi_mp,
                            f_robust_mp, impacto_mp_pre,
                            denom_vs_prod, ar_limitada, bandas_validas)),
  "",
  "`ar_limitada` e ξ_mp > 3,84 (conjunto AR de 95% limitado); `bandas_validas` e ξ_mp ≥ 10. A distancia entre `z_jk_bs_noglob` e `z_jk_bs_glob` e a medida do canal de selecao: as duas ortogonalizam os mesmos valores no mesmo bloco e diferem so em re-derivar ou nao a mascara.",
  "",
  "⚠ **Por que toda variante ortogonalizada imprime respostas MAIORES, e por que isso nao e evidencia a favor.** `impacto_mp_pre` e a resposta de `yield_6m` no impacto **antes** da normalizacao — o denominador pelo qual cada IRF da celula e dividida. `denom_vs_prod` o poe em razao da producao: onde ele encolhe, toda a IRF da celula cresce por aritmetica, sem que nada de economico tenha mudado. E o mesmo mecanismo que a classe `unstable_normalization` da taxonomia do sweep monitora (`R/identification/spec_sweep.R`). Logo o que sobrevive aqui e **o sinal e a significancia**, nao a magnitude: uma resposta que cresce enquanto ξ_mp cai deve ser lida como denominador enfraquecendo, nao como efeito maior.",
  "",
  "## 5 — IRFs no impacto (h = 0)",
  "",
  sprintf("`yield_6m` e mecanico: h=0 e o alvo da normalizacao, identico em toda variante. A comparacao de sinais roda nas outras quatro manchetes. Celulas sig90 por variante: %s.",
          paste(sprintf("%s %d", names(sort(tapply(irf_rows$sig90, irf_rows$instrumento, sum), decreasing = TRUE)),
                        sort(tapply(irf_rows$sig90, irf_rows$instrumento, sum), decreasing = TRUE)),
                collapse = ", ")),
  "",
  md_table(h0 |> dplyr::select(instrumento, variavel, ponto, lo68, hi68, lo90, hi90, sig90)),
  "",
  sprintf("Mascara re-derivada: sinais preservados = %s; ponto de producao dentro do CI90 = %s.",
          chk_glob$sinais_ok, chk_glob$prod_no_ci90),
  "",
  "Trajetorias completas em `fomc_coincidence_irf_overlay.pdf`; celulas em `fomc_coincidence.csv`; os 95 dias datados com a flag e o bloco americano em `fomc_coincidence_days.csv`.",
  ""
)

writeLines(md, file.path(OUT_DIR, "fomc_coincidence.md"))
cat(sprintf("-> %s/fomc_coincidence.{csv,md}\n", OUT_DIR))
cat(sprintf("\n=== VEREDITO: %s ===\n", verdict))
