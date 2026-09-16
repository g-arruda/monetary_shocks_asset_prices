# ===================================================================
# Does the q < r truncation drop the monetary shock? Sufficiency of the
# retained innovation space for the proxy, and the Alessi-Kerssenfischer
# invariance, window by window, at r = 5.
#
# WHY. Alessi-Kerssenfischer (2019, footnote 4) set q = r because their
# Figure A3 shows virtually identical IRFs for q < r. Stock-Watson (2016,
# sec. 7.2) set q = r although Amengual-Watson points to fewer dynamic
# factors, "to err on the side of over-specifying the space of innovations so
# that they span the space of the reduced number of shocks of interest". On
# this panel Amengual-Watson gives q = 2, and (5,2) and (5,3) carry
# xi_mp < 3.84. The round asks whether the truncation is harmless, as in AK,
# or whether it discards the directions the instrument identifies.
#
# FOUR WINDOW-CELLS, r = 5, q = 2..5:
#   cheia_p4     2012-03..2025-12, p = 4, Anderson-Rubin 68/90 on q = 5
#                (production);
#   pre_p4       2012-03..2019-12, p = 4, point only: the AR covariance is
#                blocked there (hac_dim 135 >= T = 90, output/irf/ar_bands.md);
#   pre_p2       2012-03..2019-12, p = 2, Anderson-Rubin 68/90 on q = 5
#                (hac_dim 85);
#   cheia_p4_lp  cheia_p4 with the Lenza-Primiceri (2022) COVID volatility in
#                the factor VAR, theta-hat by maximum likelihood under
#                production_spec()$covid_volatility_design (step 3/4 of the
#                advisor's 2026-09-13 e-mail); Anderson-Rubin 68/90 on q = 5,
#                on the transformed regression.
# Only the q = 5 reference gets AR sets: T2 reads only its bands, and an
# alternative's set is bounded at level kappa iff its xi_mp > kappa. Asking
# for the alternatives' sets also trips compute_irf_dfm()'s absolute 1e-10
# point guard at (5,3) (1.16e-10), whose responses are of order 10.
#
# T1, SUFFICIENCY. With q shocks and a valid proxy, z is orthogonal to the
# eigen-directions of cov(u) that the truncation discards
# (estimate_dynamic_factors keeps the leading q; under the COVID volatility it
# reads the uncentered second moment instead). Joint Wald of z on the
# discarded directions of the q = 5 innovations, chi2(5 - q), 5% level.
# T2, INVARIANCE. containment_vs_production() over the 115 series against the
# q = 5 cell of the same window, with its pre-registered rule, only where the
# reference carries AR sets (cheia_p4, pre_p2).
# JOINT READING. "Harmless before COVID, distorting after" holds iff
#   (i) T1 rejects at no q in either pre-COVID cell and at some q in cheia_p4;
#   (ii) at q = 3 and q = 4 most of the 115 series come out "imaterial" in
#        pre_p2 and not in cheia_p4.
# These rules were written AFTER an exploratory pass the same day
# (2026-09-10); notas/2026-09-10_truncamento_q.md says so. They read the three
# untreated cells only. cheia_p4_lp carries no verdict: the author reads its
# IRFs by eye (notas/2026-09-14_inferencia_volatilidade_covid_q.md).
#
# The showcase (md tables, figure) is yield_6m, yield_2y, cambio_usd, cds_5y,
# price_ipca and ibc_br, by author decision. asset_ibov stays in the paths CSV
# and in the containment counts: dropping it from those would be the
# cherry-picking script/q_selection.R forbids.
#
# Outputs: output/factors/q_truncation.{md,pdf}
#          output/factors/q_truncation_cells.csv
#          output/factors/q_truncation_directions.csv
#          output/factors/q_truncation_paths.csv
#          output/factors/q_truncation_containment.csv
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")
source("R/identification/weak_iv_ar.R")
source("R/identification/experimental_panel.R")

SPEC     <- production_spec()
Q_VALUES <- 5:2
H        <- SPEC$horizon
H_SHORT  <- 12L
ALPHA    <- 0.05
COVID    <- as.Date(c("2020-03-01", "2020-12-01"))
SHOWCASE <- c("yield_6m", "yield_2y", "cambio_usd", "cds_5y", "price_ipca", "ibc_br")
OUT_STEM <- "output/factors/q_truncation"

WINDOW_CELLS <- tibble::tribble(
  ~window_cell,  ~window,            ~p, ~ar_reference, ~covid,
  "cheia_p4",    "sample",           4L, TRUE,          FALSE,
  "pre_p4",      "pre_covid_sample", 4L, FALSE,         FALSE,
  "pre_p2",      "pre_covid_sample", 2L, TRUE,          FALSE,
  "cheia_p4_lp", "sample",           4L, TRUE,          TRUE
)

Q_LABEL    <- paste0("q=", Q_VALUES)
Q_PALETTE  <- c("q=5" = "black", "q=4" = "firebrick", "q=3" = "darkgreen", "q=2" = "steelblue")
Q_LINETYPE <- c("q=5" = "solid", "q=4" = "42", "q=3" = "22", "q=2" = "11")


# ---- Data ----------------------------------------------------------

raw_data <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |>
  tidyr::drop_na()
dates <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)
tcode <- infer_tcode_from_varnames(var_names)
mp_idx <- match(SPEC$mp_var, var_names)
blocks <- base_block_taxonomy(var_names)

inst_panel <- readr::read_csv(SPEC$instrument_path, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)
inst_df <- data.frame(month = inst_panel$month, shock = inst_panel[[SPEC$instrument]]) |>
  tidyr::drop_na(shock)


# ---- COVID volatility: theta-hat on the full-window factors ------------

# theta depends on the static factors and on p, not on q: one estimate serves
# every q of cheia_p4_lp
design <- SPEC$covid_volatility_design
in_full <- dates >= SPEC$sample[1] & dates <= SPEC$sample[2]
theta_fit <- estimate_covid_theta(
  estimate_static_factors(data_mat[in_full, ], SPEC$r)$factors, SPEC$p,
  dates[in_full][(SPEC$p + 1):sum(in_full)], design$covid_start,
  design$theta_lower, design$theta_upper
)
covid_lp <- list(covid_start = design$covid_start, theta = theta_fit$theta,
                 innovations = design$innovations)


# ---- Cells ---------------------------------------------------------

runs <- tidyr::expand_grid(WINDOW_CELLS, q = Q_VALUES) |>
  purrr::pmap(function(window_cell, window, p, ar_reference, covid, q) {
    win <- SPEC[[window]]
    in_win <- dates >= win[1] & dates <= win[2]
    covid_volatility <- if (covid) covid_lp else NULL
    dfm <- estimate_dfm(data_mat[in_win, ], r = SPEC$r, q = q, p = p, dates = dates[in_win],
                        covid_volatility = covid_volatility)
    diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates[in_win], p, mp_idx,
                                                   return_moment_inputs = TRUE)
    stage2 <- run_stage2_cell(
      data_mat, dates, inst_panel, sample_window = win,
      r = SPEC$r, q = q, p = p, instrument = SPEC$instrument, mp_var = SPEC$mp_var,
      h = H, nboot = 0L, seed = SPEC$bootstrap_seed, shock_bps = SPEC$shock_bps,
      tcode = tcode, ci_levels = SPEC$ar_levels,
      inference = if (ar_reference && q == SPEC$r) "ar" else "bootstrap",
      ar_nw_lags = SPEC$ar_nw_lags, covid_volatility = covid_volatility
    )
    list(window_cell = window_cell, p = p, q = q, dfm = dfm, diag = diag_fs,
         irf = stage2$irf, max_root = stage2$dfm_max_eig)
  })

cells_tbl <- purrr::map_dfr(runs, function(x) {
  ar <- x$irf$ar
  tibble::tibble(
    window_cell   = x$window_cell,
    p             = x$p,
    q             = x$q,
    T_eff         = x$diag$n_obs,
    xi_mp         = x$diag$wald_mp,
    xi_ar         = if (is.null(ar)) NA_real_ else ar$xi_den,
    ar_bounded_68 = x$diag$wald_mp > qchisq(0.68, df = 1),
    ar_bounded_90 = x$diag$wald_mp > qchisq(0.90, df = 1),
    ar_bounded_95 = x$diag$wald_mp > qchisq(0.95, df = 1),
    impact_mp_pre = x$diag$impact_mp,
    max_root      = x$max_root,
    hac_dim       = if (is.null(ar)) NA_real_ else ar$hac_dim,
    interval_68   = if (is.null(ar)) NA_real_ else mean(ar$by_level[["0.68"]]$set_type == "interval"),
    interval_90   = if (is.null(ar)) NA_real_ else mean(ar$by_level[["0.90"]]$set_type == "interval")
  )
})

paths <- purrr::map_dfr(runs, function(x) {
  cell_paths <- tibble::tibble(
    window_cell = x$window_cell,
    q           = x$q,
    variable    = rep(var_names, times = H + 1L),
    h           = rep(0:H, each = length(var_names)),
    point       = as.vector(x$irf$irf_point_matrix),
    lo68 = NA_real_, hi68 = NA_real_, lo90 = NA_real_, hi90 = NA_real_,
    set_type68 = NA_character_, set_type90 = NA_character_
  )
  if (is.null(x$irf$ar)) return(cell_paths)
  b68 <- x$irf$ar$by_level[["0.68"]]
  b90 <- x$irf$ar$by_level[["0.90"]]
  dplyr::mutate(cell_paths,
                lo68 = as.vector(b68$lo), hi68 = as.vector(b68$hi),
                lo90 = as.vector(b90$lo), hi90 = as.vector(b90$hi),
                set_type68 = as.vector(b68$set_type), set_type90 = as.vector(b90$set_type))
})


# ---- T1 and the mechanism, on the q = 5 innovations of each window --------

reference <- purrr::keep(runs, function(x) x$q == SPEC$r)

by_window <- purrr::map(reference, function(x) {
  mi  <- x$diag$moment_inputs
  u   <- x$dfm$var_residuals
  # The matrix whose eigenvectors K takes: cov(u) under OLS, the uncentered
  # second moment under the COVID volatility (estimate_dfm)
  sigma_u <- if (is.null(x$dfm$covid_volatility)) cov(u) else crossprod(u) / nrow(u)
  eig <- svd(sigma_u)
  V   <- eig$u
  # Shocks along each eigen-direction and the yield_6m innovation's weight on
  # each: eta_mp = S %*% a, and a truncation to q keeps S[, 1:q] %*% a[1:q].
  S <- mi$eta_sel %*% V
  a <- drop(crossprod(V, mi$c_mp))

  t1 <- purrr::map_dfr(2:(SPEC$r - 1L), function(q) {
    w <- compute_factor_space_wald(S[, (q + 1):SPEC$r, drop = FALSE], mi$Z_sel,
                                   controls = mi$ctrl_sel,
                                   intercept = mi$intercept)$wald_joint
    tibble::tibble(window_cell = x$window_cell, q = q, t1_wald = w, t1_df = SPEC$r - q,
                   t1_p = pchisq(w, df = SPEC$r - q, lower.tail = FALSE))
  })

  xi_top <- tibble::tibble(
    window_cell = x$window_cell,
    q = 2:SPEC$r,
    xi_top_q = purrr::map_dbl(2:SPEC$r, function(q) {
      compute_factor_space_wald(S[, 1:q, drop = FALSE] %*% a[1:q], mi$Z_sel,
                                controls = mi$ctrl_sel,
                                intercept = mi$intercept)$wald_joint
    })
  )

  ctrl <- if (mi$intercept) cbind(1, mi$ctrl_sel) else mi$ctrl_sel
  z_res <- qr.resid(qr(ctrl), as.numeric(mi$Z_sel))
  cov_mp <- colMeans(z_res * S) * a
  u_dates <- x$dfm$dates[(x$p + 1):length(x$dfm$dates)]
  in_covid <- u_dates >= COVID[1] & u_dates <= COVID[2]
  S_all <- u %*% V
  # Loadings are orthonormal, so each column of `impact` has unit norm and its
  # squared entries are the direction's footprint shares over the panel.
  impact <- x$dfm$static_loadings %*% V

  dirs <- tibble::tibble(
    window_cell    = x$window_cell,
    direction      = seq_len(SPEC$r),
    var_share      = eig$d / sum(eig$d),
    wald_z         = compute_factor_space_wald(S, mi$Z_sel, controls = mi$ctrl_sel,
                                               intercept = mi$intercept)$wald_k,
    cov_mp_share   = cov_mp / sum(cov_mp),
    var_mp_share   = eig$d * a^2 / sum(eig$d * a^2),
    covid_ss_share = if (any(in_covid)) colSums(S_all[in_covid, , drop = FALSE]^2) / colSums(S_all^2) else NA_real_,
    curva_share    = colSums(impact[blocks == "curva", , drop = FALSE]^2),
    top_blocks     = purrr::map_chr(seq_len(SPEC$r), function(k) {
      share <- sort(tapply(impact[, k]^2, blocks, sum), decreasing = TRUE)[1:3]
      paste(sprintf("%s %.2f", names(share), share), collapse = ", ")
    })
  )

  list(t1 = t1, xi_top = xi_top, dirs = dirs)
})

t1_tbl   <- purrr::map_dfr(by_window, "t1")
xi_top   <- purrr::map_dfr(by_window, "xi_top")
dirs_tbl <- purrr::map_dfr(by_window, "dirs")


# ---- Self-tests ----------------------------------------------------

# (a) the production cell reproduces the published point and 68/90 AR sets
coh <- readr::read_csv("output/irf/irf_coherence_h.csv", show_col_types = FALSE)
chk_a <- paths |>
  dplyr::filter(window_cell == "cheia_p4", q == SPEC$q) |>
  dplyr::inner_join(coh, by = c("variable" = "var", "h"), suffix = c("", "_ref"))
stopifnot(
  nrow(chk_a) == nrow(coh),
  max(abs(c(chk_a$point - chk_a$point_ref, chk_a$lo68 - chk_a$lo68_ref,
            chk_a$hi68 - chk_a$hi68_ref, chk_a$lo90 - chk_a$lo90_ref,
            chk_a$hi90 - chk_a$hi90_ref))) < 1e-10
)

# (b) strength agrees with the canonical grid, and the AR path with the Wald
grid <- readr::read_csv("output/instrument/mosw_strength_grid.csv", show_col_types = FALSE) |>
  dplyr::filter(r == SPEC$r, instrument == SPEC$instrument, q %in% Q_VALUES) |>
  dplyr::mutate(window_cell = dplyr::if_else(sample == "full", "cheia_p4", "pre_p4")) |>
  dplyr::select(window_cell, q, xi_ref = wald_mp)
chk_b <- dplyr::inner_join(cells_tbl, grid, by = c("window_cell", "q"))
stopifnot(
  nrow(chk_b) == 2L * length(Q_VALUES),
  max(abs(chk_b$xi_mp - chk_b$xi_ref)) < 1e-8,
  max(abs(cells_tbl$xi_ar - cells_tbl$xi_mp), na.rm = TRUE) < 1e-6
)

# (c) T1 reads the very directions estimate_dynamic_factors() keeps: the
# leading-q reconstruction reproduces the strength of the estimated q cell
chk_c <- dplyr::inner_join(xi_top, cells_tbl, by = c("window_cell", "q"))
stopifnot(nrow(chk_c) == nrow(xi_top), max(abs(chk_c$xi_top_q - chk_c$xi_mp)) < 1e-8)

# (d) containment reads [lo, hi], which is the set for an interval and, at the
# normalization point, for the singleton {normalize_value} every cell has there
ar_cells <- WINDOW_CELLS$window_cell[WINDOW_CELLS$ar_reference]
ref_sets <- dplyr::filter(paths, window_cell %in% ar_cells, q == SPEC$q)
at_norm <- ref_sets$variable == SPEC$mp_var & ref_sets$h == 0
stopifnot(
  all(ref_sets$set_type68[!at_norm] == "interval"),
  all(ref_sets$set_type90[!at_norm] == "interval"),
  all(ref_sets$set_type68[at_norm] == "singleton"),
  all(ref_sets$set_type90[at_norm] == "singleton"),
  max(abs(c(ref_sets$lo90[at_norm], ref_sets$hi90[at_norm]) - SPEC$normalize_value)) < 1e-12
)

# (e) every cell delivers exactly the normalized shock
mp_h0 <- dplyr::filter(paths, variable == SPEC$mp_var, h == 0)$point
stopifnot(max(abs(mp_h0 - SPEC$normalize_value)) < 1e-12)

# (f) the treated cells run at the maximum-likelihood theta of
# script/covid_volatility_theta.R, and their factor VAR is the one it maximized
theta_ref <- readr::read_csv("output/factors/covid_volatility_theta.csv", show_col_types = FALSE)
treated_loglik <- purrr::keep(runs, function(x) x$window_cell == "cheia_p4_lp") |>
  purrr::map_dbl(function(x) x$dfm$var_loglik)
stopifnot(
  max(abs(theta_fit$theta / unlist(theta_ref[names(theta_fit$theta)]) - 1)) < 1e-8,
  max(abs(treated_loglik - theta_fit$loglik)) < 1e-10 * abs(theta_fit$loglik)
)


# ---- T2: the Alessi-Kerssenfischer containment ----------------------

containment <- purrr::map_dfr(ar_cells, function(wc) {
  denom <- dplyr::filter(cells_tbl, window_cell == wc)
  denom_ratio <- setNames(denom$impact_mp_pre / denom$impact_mp_pre[denom$q == SPEC$q], denom$q)
  paths |>
    dplyr::filter(window_cell == wc) |>
    dplyr::select(cell_key = q, variable, h, point, lo68, hi68, lo90, hi90) |>
    containment_vs_production(prod_key = SPEC$q, denom_ratio = denom_ratio,
                              h_max = H, h_short = H_SHORT, var_order = var_names) |>
    dplyr::rename(q = cell_key) |>
    dplyr::mutate(window_cell = wc, .before = 1)
})

verdict_counts <- containment |>
  dplyr::group_by(window_cell, q) |>
  dplyr::summarise(
    imaterial       = sum(veredito == "imaterial"),
    parcial         = sum(veredito == "parcial"),
    material        = sum(veredito == "material"),
    median_cor_path = median(cor_path),
    .groups = "drop"
  ) |>
  dplyr::arrange(dplyr::desc(window_cell), dplyr::desc(q))


# ---- Joint reading -------------------------------------------------

cond_i <- all(t1_tbl$t1_p[t1_tbl$window_cell %in% c("pre_p4", "pre_p2")] >= ALPHA) &&
  any(t1_tbl$t1_p[t1_tbl$window_cell == "cheia_p4"] < ALPHA)
share_imaterial <- verdict_counts |>
  dplyr::filter(q %in% 3:4) |>
  dplyr::mutate(share = imaterial / length(var_names))
cond_ii <- all(share_imaterial$share[share_imaterial$window_cell == "pre_p2"] > 0.5) &&
  all(share_imaterial$share[share_imaterial$window_cell == "cheia_p4"] <= 0.5)
joint_reading <- if (cond_i && cond_ii) "sustentada" else "não sustentada"


# ---- Outputs -------------------------------------------------------

cells_out <- dplyr::left_join(cells_tbl, t1_tbl, by = c("window_cell", "q"))
readr::write_csv(cells_out, paste0(OUT_STEM, "_cells.csv"))
readr::write_csv(dirs_tbl, paste0(OUT_STEM, "_directions.csv"))
# Paths only for the showcase and asset_ibov: the 115-series comparison lives
# in the containment CSV, and the full path cube would be ~11 MB of tracked output.
readr::write_csv(dplyr::filter(paths, variable %in% c(SHOWCASE, "asset_ibov")),
                 paste0(OUT_STEM, "_paths.csv"))
readr::write_csv(containment, paste0(OUT_STEM, "_containment.csv"))

showcase_tbl <- paths |>
  dplyr::filter(variable %in% SHOWCASE, h %in% c(0L, 12L, 24L)) |>
  dplyr::select(window_cell, variable, h, q, point) |>
  tidyr::pivot_wider(names_from = q, values_from = point, names_prefix = "q=") |>
  dplyr::arrange(match(window_cell, WINDOW_CELLS$window_cell), match(variable, SHOWCASE), h)

writeLines(c(
  "# Truncamento `q < r`: suficiência do subespaço retido e invariância à la Alessi-Kerssenfischer",
  "",
  sprintf("Gerado por `script/q_truncation.R` em %s.", Sys.Date()),
  paste("**Corpo gerado — não escrever prosa aqui.** A leitura vive em `notas/2026-09-10_truncamento_q.md`;",
        "a da célula `cheia_p4_lp`, em `notas/2026-09-14_inferencia_volatilidade_covid_q.md`."),
  "",
  "## Células",
  "",
  paste("Painel de produção (115 séries), `r = 5`, instrumento `z_jk_bs_purif`, choque de +50 pb",
        "em `yield_6m`. `cheia_p4`: 2012-03 a 2025-12, `p = 4`, conjuntos Anderson-Rubin 68/90.",
        "`pre_p4`: 2012-03 a 2019-12, `p = 4`, só pontual — o AR é bloqueado ali",
        "(`hac_dim` 135 >= T = 90, `output/irf/ar_bands.md`). `pre_p2`: mesma janela, `p = 2`, AR 68/90.",
        "`cheia_p4_lp`: a `cheia_p4` com a volatilidade COVID de Lenza-Primiceri (2022) no VAR dos",
        "fatores, AR 68/90 na regressão transformada (seção própria abaixo).",
        "Os conjuntos AR são construídos só na referência `q = 5`; `ar_bounded_κ` vem de ξ_mp > κ,",
        "a condição exata de limitação. `interval_68`/`interval_90`: fração dos conjuntos da",
        "referência (115 séries × 49 horizontes) que são intervalos; o único outro tipo é o singleton",
        "{0,005} da `yield_6m` em h = 0, que a normalização impõe."),
  "",
  md_table(dplyr::select(cells_tbl, -xi_ar)),
  "",
  "## T1 — o instrumento é ortogonal às direções que o truncamento descarta?",
  "",
  paste("Wald conjunto de z contra as direções `q+1..5` dos autovetores de `cov(u)` da célula `q = 5`",
        "(na `cheia_p4_lp`, do segundo momento não centrado de `u_t/s_t`, que é o que K lê ali),",
        sprintf("χ²(5 − q), nível %.0f%%. Com `q` choques e instrumento válido, a ortogonalidade vale.", 100 * ALPHA)),
  "",
  md_table(t1_tbl),
  "",
  "## T2 — invariância pela regra de `containment_vs_production()` (115 séries, h = 0..48)",
  "",
  paste("Referência: a célula `q = 5` da mesma janela, com seus conjuntos AR de 90%.",
        "*imaterial*: dentro da banda em todo h e `cor_path` > 0,95; *material*: sai da banda ou troca o sinal em h = 0.",
        "`asset_ibov` está nas contagens; ver `q_truncation_containment.csv`."),
  "",
  md_table(verdict_counts),
  "",
  "## Destaque: resposta pontual em h = 0, 12 e 24",
  "",
  md_table(showcase_tbl),
  "",
  "## Mecanismo: direções de `cov(u)` na célula `q = 5`",
  "",
  paste("`var_share`: participação na variância das inovações. `wald_z`: Wald de z na direção.",
        "`cov_mp_share` e `var_mp_share`: participação em cov(z, inovação da `yield_6m`) e em sua variância.",
        "`covid_ss_share`: fração da soma de quadrados vinda de 2020-03 a 2020-12 (10 de 162 meses na cheia).",
        "`curva_share` e `top_blocks`: pegada da direção no painel padronizado.",
        "Na `cheia_p4_lp`, direções e somas de quadrados são as de `u_t/s_t`."),
  "",
  md_table(dirs_tbl),
  "",
  "## Passo 3/4: a cheia com a volatilidade COVID (`cheia_p4_lp`)",
  "",
  paste("As linhas `cheia_p4_lp` das tabelas acima são a `cheia_p4` com a escala `s_t` de",
        "Lenza-Primiceri (2022) no VAR dos fatores: mínimos quadrados ponderados, K e H lidos",
        "sobre `u_t/s_t` sem centragem, T1 nas direções do segundo momento não centrado e AR na",
        "regressão transformada, com θ̂ tratado como conhecido.",
        chartr(".", ",", sprintf("θ̂ = (s̄0 %.3f; s̄1 %.3f; s̄2 %.3f; ρ %.4f)",
                                 theta_fit$theta[["s0"]], theta_fit$theta[["s1"]],
                                 theta_fit$theta[["s2"]], theta_fit$theta[["rho"]])),
        "por máxima verossimilhança, o de `script/covid_volatility_theta.R`.",
        "Sem regra de leitura: o autor lê as IRFs a olho (última página do PDF)."),
  "",
  "## Leitura conjunta",
  "",
  "Só as três células sem tratamento entram nesta leitura.",
  "",
  sprintf("- (i) T1 não rejeita em nenhum `q` nas duas células pré-COVID e rejeita em algum `q` na cheia: **%s**.",
          if (cond_i) "cumprida" else "não cumprida"),
  sprintf("- (ii) em `q` = 3 e 4, a maioria das 115 séries sai *imaterial* em `pre_p2` e não em `cheia_p4`: **%s**.",
          if (cond_ii) "cumprida" else "não cumprida"),
  "",
  sprintf("**\"O truncamento é inofensivo antes da COVID e distorce depois\": %s.**", joint_reading),
  "",
  "As regras foram escritas depois da passada exploratória do mesmo dia; a nota registra isso."
), paste0(OUT_STEM, ".md"))

plot_df <- paths |>
  dplyr::filter(variable %in% SHOWCASE) |>
  dplyr::mutate(cell = factor(paste0("q=", q), levels = Q_LABEL))

PAGES <- tibble::tribble(
  ~window_cell, ~title,
  "cheia_p4",   "Amostra cheia (2012-03 a 2025-12), p = 4: bandas AR 68/90% de q = 5",
  "pre_p2",     "Pré-COVID (2012-03 a 2019-12), p = 2: bandas AR 68/90% de q = 5",
  "pre_p4",     "Pré-COVID (2012-03 a 2019-12), p = 4: só pontual, AR bloqueado (hac_dim 135 >= T = 90)",
  "cheia_p4_lp", "Amostra cheia com a volatilidade COVID de Lenza-Primiceri, p = 4: bandas AR 68/90% de q = 5"
)

pdf(paste0(OUT_STEM, ".pdf"), width = 11, height = 7.5)
purrr::pwalk(PAGES, function(window_cell, title) {
  df <- plot_df[plot_df$window_cell == window_cell, ]
  print(plot_dimension_overlay(
    df, df[df$q == SPEC$q & !is.na(df$lo90), ], SHOWCASE, Q_PALETTE, Q_LINETYPE,
    H, 3, title, "z_jk_bs_purif × yield_6m, choque de +50 pb; r = 5; q = 2, 3 e 4 só pontuais"
  ))
})
invisible(dev.off())
