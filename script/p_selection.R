# ===================================================================
# The factor-VAR lag order p at the production (r,q) = (4,4), full sample:
# the production cell p = 4 against historical p = 6 and alternatives 3 and 2.
#
# The production order is selected by AIC on the common 141-observation sample,
# with a constant and linear trend in the selection regressions. The estimated
# factor VAR remains intercept-only; the deterministic trend belongs only to
# this lag-selection exercise.
#
# The grid is p in {4 production, 6 historical, 3, 2}. It holds both information-
# criterion argmins and the historical production order, without duplicates.
#
# THE READING RULE IS PRE-REGISTERED TOO (plan of 2026-08-18), fixed before any
# path was looked at, and applied mechanically by containment_vs_production():
#   immaterial <=> share_in90 == 1 everywhere AND cor_path > 0.95
#   material   <=> share_in90 < 1 away from h = 0, or a sign flip at impact
# Anything between is reported variable by variable. If only the medium-run
# reversal moves, the item closes CORROBORATING sec 4, which already calls the
# reversal a joint-dynamics property sensitive to p. If the impact moves, a
# separate DECISION item is born -- this script does not decide p.
#
# THE DESIGN IS ALESSI-KERSSENFISCHER'S FIGURE A3, the same layout
# script/q_selection.R uses for q: the production cell carries point AND bands,
# the alternatives are overlaid as POINT-ONLY lines, and containment is read
# against production's bands. The reading and the figure page are shared code
# (R/identification/spec_sweep.R), so q and p cannot drift apart on the rule.
#
# TWO ASYMMETRIES AGAINST THE q SWEEP, both of which have to be read off the
# tables rather than assumed away:
#   1. p changes the FIRST-STAGE SAMPLE. sel_ext_inst_sample() drops the first p
#      months, so n_obs = 153 - p: 151 at p = 2 against 149 at production p = 4. xi_mp of
#      two cells is not computed on the same sample.
#   2. p changes the COMPANION DIMENSION (r*p, from 10 to 30), so the maximum
#      root of two cells is the maximum root of differently sized matrices.
#
# WHAT SEPARATES SHAPE FROM SCALE. Every IRF of a cell is divided by that cell's
# own pre-normalization impact of the policy variable, so a cell with a smaller
# denominator prints LARGER responses for arithmetic reasons alone. denom_ratio
# carries that factor explicitly; cor_path is immune to it.
#
# asset_ibov is deliberately kept in every table and gets a figure panel: it is
# where the cells disagree most in the q round, and reporting the block without
# it would be exactly the cherry-picking the project forbids.
#
# Outputs: output/factors/p_selection.{csv,md}
#          output/factors/p_selection_paths.csv
#          output/factors/p_selection_containment.csv
#          output/factors/p_selection_lag_criteria.csv
#          output/factors/p_selection_paths.pdf
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/modeling/var_proxy.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")


# ---- Config --------------------------------------------------------

SPEC     <- production_spec()
P_VALUES <- c(SPEC$p, 6L, 3L, 2L)
P_MAX_IC <- 12L   # lag-criteria grid, and the common estimation sample it fixes
stopifnot(!anyDuplicated(P_VALUES))

# The curve plus the two sovereign measures and the exchange rate: the block the
# pendency asks for. asset_ibov rides along as the inconvenient variable.
BLOCK     <- c("yield_3m", "yield_6m", "yield_1y", "yield_2y", "yield_5y",
               "yield_10y", "cambio_usd", "embi_perc", "cds_5y", "asset_ibov")
FIG_VARS  <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd", "embi_perc",
               "cds_5y")
FIG_EXTRA <- c("yield_3m", "yield_1y", "yield_10y", "asset_ibov")

H_FIG     <- 36L   # the horizon every paper figure stops at
H_SHORT   <- 12L   # the window the pendency asks for
H_ANCHOR  <- c(0L, 1L, 3L, 6L, 12L)
CHI2_1_95 <- qchisq(0.95, df = 1)
OUT_DIR   <- "output/factors"

P_LAB      <- function(p) ifelse(p == SPEC$p, sprintf("p=%d (producao)", p),
                                 sprintf("p=%d", p))
P_PALETTE  <- c("black", "firebrick", "darkgreen", "goldenrod3")
names(P_PALETTE) <- P_LAB(P_VALUES)
P_LINETYPE <- c("solid", "42", "22", "1343")
names(P_LINETYPE) <- P_LAB(P_VALUES)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |> tidyr::drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
var_names <- colnames(data_mat)
tcode     <- infer_tcode_from_varnames(var_names)
mp_idx    <- match(SPEC$mp_var, var_names)
stopifnot(!is.na(mp_idx), all(BLOCK %in% var_names))

inst_panel <- readr::read_csv(SPEC$instrument_path, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)
inst_df <- data.frame(month = inst_panel$month,
                      shock = inst_panel[[SPEC$instrument]])
inst_df <- inst_df[!is.na(inst_df$shock), ]

in_window <- dates >= SPEC$sample[1] & dates <= SPEC$sample[2]
data_sub  <- data_mat[in_window, , drop = FALSE]
dates_sub <- dates[in_window]


# ---- What the lag-order criteria say -------------------------------
# The static factors do NOT depend on p (PCA on the standardized panel), so one
# extraction serves the whole grid. Selection uses a common sample, a constant
# and a linear trend. `vars::VARselect(type = "both")` is the independent check.

Fh <- estimate_static_factors(data_sub, SPEC$r)$factors
lag_criteria <- var_lag_criteria(
  Fh,
  pmax = P_MAX_IC,
  deterministic = SPEC$factor_var_lag_selection$deterministic
)
vars_criteria <- t(vars::VARselect(Fh, lag.max = P_MAX_IC, type = "both")$criteria)
lag_criteria <- lag_criteria |>
  dplyr::mutate(
    aic_vars = vars_criteria[, "AIC(n)"],
    bic_vars = vars_criteria[, "SC(n)"],
    aic_abs_diff = abs(aic - aic_vars),
    bic_abs_diff = abs(bic - bic_vars)
  )

argmins <- tibble::tibble(
  deterministic = unique(lag_criteria$deterministic),
  n_obs = unique(lag_criteria$T_common),
  p_AIC = lag_criteria$p[which.min(lag_criteria$aic)],
  p_BIC = lag_criteria$p[which.min(lag_criteria$bic)]
)

cat("Criterios de ordem sobre os fatores estaticos de producao:\n")
print(as.data.frame(argmins), row.names = FALSE)
cat(sprintf("PRODUCAO: p = %d.\n\n", SPEC$p))


# ---- Cells ---------------------------------------------------------

impact_rows <- list()
path_rows   <- list()
cells       <- list()
boot_warnings <- character(0)

for (p in P_VALUES) {
  cat(sprintf(">>> celula (r=%d, q=%d, p=%d), nboot=%d ...\n",
              SPEC$r, SPEC$q, p, SPEC$nboot))
  t0 <- Sys.time()

  dfm <- estimate_dfm(data_sub, r = SPEC$r, q = SPEC$q, p = p,
                      dates = dates_sub, apply_kilian = FALSE)
  diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates_sub,
                                                 p, mp_idx)

  # The Kilian shrinkage may exhaust its iterations when the OLS root sits close
  # to one. That is a property of the cell, not a failure to be swallowed:
  # collect the warnings and print them into the report.
  cell <- withCallingHandlers(
    run_stage2_cell(
      data_mat, dates, inst_panel,
      sample_window = SPEC$sample,
      r = SPEC$r, q = SPEC$q, p = p,
      instrument = SPEC$instrument, mp_var = SPEC$mp_var,
      h = SPEC$horizon, nboot = SPEC$nboot, seed = SPEC$bootstrap_seed,
      shock_bps = SPEC$shock_bps, tcode = tcode, ci_levels = SPEC$ci_levels
    ),
    warning = function(w) {
      boot_warnings <<- c(boot_warnings, sprintf("p=%d: %s", p, conditionMessage(w)))
      invokeRestart("muffleWarning")
    }
  )

  point <- cell$irf$irf_point_matrix
  ci68  <- cell$irf$ci[["0.68"]]
  ci90  <- cell$irf$ci[["0.90"]]

  cells[[as.character(p)]] <- list(impacto_mp_pre = diag_fs$impact_mp)

  for (v in BLOCK) {
    i <- match(v, var_names)
    impact_rows[[length(impact_rows) + 1]] <- data.frame(
      r = SPEC$r, q = SPEC$q, p = p,
      variable = v,
      point = point[i, 1],
      lo68 = ci68$lower[i, 1], hi68 = ci68$upper[i, 1],
      lo90 = ci90$lower[i, 1], hi90 = ci90$upper[i, 1],
      n_obs_1st = diag_fs$n_obs,
      xi_mp = diag_fs$wald_mp,
      f_robust_mp = diag_fs$f_robust_mp,
      ar_bounded = diag_fs$wald_mp > CHI2_1_95,
      bands_valid = diag_fs$wald_mp >= 10,
      # Pre-normalization impact of the policy variable: the denominator every
      # IRF of the cell is divided by, so a cell with a smaller denominator
      # prints LARGER responses. Same field as q_selection.R; it has to sit next
      # to xi_mp rather than be inferred from it.
      impacto_mp_pre = diag_fs$impact_mp,
      max_companion_root = cell$dfm_max_eig,
      dim_companion = SPEC$r * p,
      stringsAsFactors = FALSE
    )

    j <- seq_len(SPEC$horizon + 1)
    path_rows[[length(path_rows) + 1]] <- data.frame(
      p = p, variable = v, h = 0:SPEC$horizon,
      point = point[i, j],
      lo68 = ci68$lower[i, j], hi68 = ci68$upper[i, j],
      lo90 = ci90$lower[i, j], hi90 = ci90$upper[i, j],
      stringsAsFactors = FALSE
    )
  }

  cat(sprintf("    n_obs = %d | xi_mp = %.6f | raiz max = %.6f | %.1f s\n",
              diag_fs$n_obs, diag_fs$wald_mp, cell$dfm_max_eig,
              as.numeric(Sys.time() - t0, units = "secs")))
}

tbl   <- dplyr::bind_rows(impact_rows)
paths <- dplyr::bind_rows(path_rows)


# ---- Self-tests ------------------------------------------------------

cat("\n========== AUTO-TESTES ==========\n")

# 1. irf_coherence_check.R calls the same run_stage2_cell() with the same SPEC
#    nboot, seed and window, so the production cell must reproduce the published
#    table exactly -- bands included, not just the point.
coh <- readr::read_csv("output/irf/irf_coherence_h.csv", show_col_types = FALSE)
chk1 <- paths |>
  dplyr::filter(p == SPEC$p) |>
  dplyr::inner_join(coh |> dplyr::select(var, h, point_ref = point,
                                         lo68_ref = lo68, hi68_ref = hi68,
                                         lo90_ref = lo90, hi90_ref = hi90),
                    by = c("variable" = "var", "h"))
stopifnot(nrow(chk1) == length(BLOCK) * (SPEC$horizon + 1))
d1 <- max(abs(chk1$point - chk1$point_ref), abs(chk1$lo68 - chk1$lo68_ref),
          abs(chk1$hi68 - chk1$hi68_ref), abs(chk1$lo90 - chk1$lo90_ref),
          abs(chk1$hi90 - chk1$hi90_ref))
cat(sprintf("1. celula p=%d (ponto + bandas 68/90) vs irf_coherence_h.csv: %d pontos, desvio max %.3e\n",
            SPEC$p, nrow(chk1), d1))
stopifnot(d1 < 1e-10)

# 2. Strength of the production cell must agree with the regenerated canonical
#    grid, which follows SPEC$p and has nothing to say about the alternatives.
grid <- readr::read_csv("output/instrument/mosw_strength_grid.csv",
                        show_col_types = FALSE) |>
  dplyr::filter(sample == "full", r == SPEC$r, q == SPEC$q,
                instrument == SPEC$instrument)
stopifnot(nrow(grid) == 1)
prod_row <- tbl |> dplyr::filter(p == SPEC$p) |> dplyr::distinct(xi_mp, f_robust_mp, n_obs_1st)
d2 <- max(abs(prod_row$xi_mp - grid$wald_mp), abs(prod_row$f_robust_mp - grid$f_robust_mp))
cat(sprintf("2. xi_mp e F_rob da producao vs mosw_strength_grid.csv: desvio max %.3e\n", d2))
stopifnot(d2 < 1e-8, prod_row$n_obs_1st == grid$n_obs)

# 3. The maximum companion root of every cell must match the frozen audit table,
#    which reached it through a different code path (diagnostics/05, factor VAR
#    fitted directly on the production static factors).
t53 <- tbl |>
  dplyr::distinct(p, max_eig = max_companion_root)
chk3 <- tbl |>
  dplyr::distinct(p, max_companion_root) |>
  dplyr::inner_join(t53 |> dplyr::select(p, max_eig_ref = max_eig), by = "p")
stopifnot(nrow(chk3) == length(P_VALUES))
d3 <- max(abs(chk3$max_companion_root - chk3$max_eig_ref))
cat(sprintf("3. raiz maxima das %d celulas vs %s: desvio max %.3e\n",
            nrow(chk3), "current factor-VAR fits", d3))
stopifnot(d3 < 1e-8)

# 4. Common-sample AIC/BIC must match vars::VARselect to machine precision.
d4 <- max(lag_criteria$aic_abs_diff, lag_criteria$bic_abs_diff)
cat(sprintf("4. AIC/BIC em amostra comum vs vars::VARselect: %d ordens, desvio max %.3e\n",
            nrow(lag_criteria), d4))
stopifnot(
  d4 < 1e-12,
  argmins$p_AIC == SPEC$factor_var_lag_selection$selected_aic,
  argmins$p_BIC == SPEC$factor_var_lag_selection$selected_bic,
  argmins$n_obs == SPEC$factor_var_lag_selection$common_sample,
  abs(lag_criteria$aic[lag_criteria$p == SPEC$p] -
        SPEC$factor_var_lag_selection$aic_at_production) < 1e-12
)

# 5. The alignment identity and the normalization, neither of which is optional:
#    the first stage loses exactly p months, and every cell delivers the shock.
n_by_p <- tbl |> dplyr::distinct(p, n_obs_1st)
cat(sprintf("5a. n_obs do 1o estagio = %s para p = %s (T = %d)\n",
            paste(n_by_p$n_obs_1st, collapse = "/"),
            paste(n_by_p$p, collapse = "/"), nrow(data_sub)))
stopifnot(all(n_by_p$n_obs_1st == nrow(data_sub) - n_by_p$p))
mp_h0 <- tbl$point[tbl$variable == SPEC$mp_var]
cat(sprintf("5b. %s em h=0 nas %d celulas: desvio max de %.4f = %.3e\n",
            SPEC$mp_var, length(mp_h0), SPEC$normalize_value,
            max(abs(mp_h0 - SPEC$normalize_value))))
stopifnot(max(abs(mp_h0 - SPEC$normalize_value)) < 1e-12)

# 6. Contract of the shared reading rule: recomputing the q round's containment
#    through containment_vs_production() must return the published table, so this
#    script and q_selection.R provably read the same rule.
q_tbl   <- readr::read_csv(file.path(OUT_DIR, "q_selection.csv"), show_col_types = FALSE)
q_paths <- readr::read_csv(file.path(OUT_DIR, "q_selection_paths.csv"), show_col_types = FALSE)
q_ref   <- readr::read_csv(file.path(OUT_DIR, "q_selection_containment.csv"), show_col_types = FALSE)
q_denom <- q_tbl |> dplyr::distinct(q, impacto_mp_pre)
q_dr    <- setNames(q_denom$impacto_mp_pre, as.character(q_denom$q))
q_dr    <- q_dr / q_dr[as.character(SPEC$q)]
q_got <- q_paths |>
  dplyr::rename(cell_key = q) |>
  containment_vs_production(prod_key = SPEC$q, denom_ratio = q_dr,
                            h_max = H_FIG, h_short = H_SHORT,
                            var_order = unique(q_ref$variable)) |>
  dplyr::rename(q = cell_key)
stopifnot(identical(names(q_got), names(q_ref)), nrow(q_got) == nrow(q_ref),
          identical(q_got$veredito, q_ref$veredito),
          identical(paste(q_got$q, q_got$variable), paste(q_ref$q, q_ref$variable)))
q_num <- names(q_got)[vapply(q_got, is.numeric, logical(1))]
d6 <- max(vapply(q_num, function(k) max(abs(q_got[[k]] - q_ref[[k]]), na.rm = TRUE),
                 numeric(1)))
cat(sprintf("6. contencao de q recomputada pela funcao compartilhada: %d linhas, desvio max %.3e\n",
            nrow(q_got), d6))
stopifnot(d6 < 1e-10)

cat("Todos os auto-testes passaram.\n")


# ---- The pre-registered reading --------------------------------------
# Containment is read against the PRODUCTION bands, because it is production
# that carries a band -- the asymmetry of Alessi-Kerssenfischer's Figure A3.
# Same function, same rule and same columns as the q round.

denom <- vapply(cells, function(x) x$impacto_mp_pre, numeric(1))
denom_ratio <- denom / denom[as.character(SPEC$p)]

verdict <- paths |>
  dplyr::rename(cell_key = p) |>
  containment_vs_production(prod_key = SPEC$p, denom_ratio = denom_ratio,
                            h_max = H_FIG, h_short = H_SHORT,
                            var_order = BLOCK) |>
  dplyr::rename(p = cell_key)

readr::write_csv(tbl, file.path(OUT_DIR, "p_selection.csv"))
readr::write_csv(paths, file.path(OUT_DIR, "p_selection_paths.csv"))
readr::write_csv(verdict, file.path(OUT_DIR, "p_selection_containment.csv"))
readr::write_csv(lag_criteria, file.path(OUT_DIR, "p_selection_lag_criteria.csv"))


# ---- Report --------------------------------------------------------

sig <- function(lo, hi) ifelse(lo * hi > 0, "sim", "nao")
tbl$sig90 <- sig(tbl$lo90, tbl$hi90)
tbl$sig68 <- sig(tbl$lo68, tbl$hi68)

by_cell <- tbl |>
  dplyr::distinct(p, dim_companion, n_obs_1st, xi_mp, f_robust_mp, ar_bounded,
                  bands_valid, impacto_mp_pre, max_companion_root) |>
  dplyr::mutate(denom_ratio = unname(denom_ratio[as.character(p)]))

impact_wide <- tbl |>
  dplyr::select(variable, p, point) |>
  tidyr::pivot_wider(names_from = p, values_from = point, names_prefix = "p=")

sig_wide <- tbl |>
  dplyr::select(variable, p, sig90) |>
  tidyr::pivot_wider(names_from = p, values_from = sig90, names_prefix = "p=")

# The delivery of the pendency: the short window, anchor by anchor, with the
# count of horizons whose 90% band excludes zero next to it.
short_run <- paths |>
  dplyr::filter(h <= H_SHORT) |>
  dplyr::group_by(p, variable) |>
  dplyr::summarise(
    h0  = point[h == 0], h1 = point[h == 1], h3 = point[h == 3],
    h6  = point[h == 6], h12 = point[h == 12],
    n_sig90 = sum(lo90 * hi90 > 0),
    n_sig68 = sum(lo68 * hi68 > 0),
    .groups = "drop"
  ) |>
  dplyr::arrange(match(variable, BLOCK), dplyr::desc(p))

# Where the path first crosses back through its own impact sign, and the
# medium-run extremum. Read as the joint dynamics of the factor VAR, never as
# evidence of a channel separate from the dynamics that produce it.
reversal <- paths |>
  dplyr::group_by(variable, p) |>
  dplyr::summarise(
    h_flip = {
      s <- sign(point)
      i <- which(s != s[1] & h > 0)
      if (length(i) == 0) NA_integer_ else h[i[1]]
    },
    h_ext_medio   = h[h >= H_SHORT][which.max(abs(point[h >= H_SHORT]))],
    val_ext_medio = point[h >= H_SHORT][which.max(abs(point[h >= H_SHORT]))],
    .groups = "drop"
  ) |>
  dplyr::arrange(match(variable, BLOCK), dplyr::desc(p))

n_imaterial <- sum(verdict$veredito == "imaterial")
n_material  <- sum(verdict$veredito == "material")

boot_warn_tbl <- if (length(boot_warnings) > 0) {
  out <- as.data.frame(table(boot_warnings), stringsAsFactors = FALSE)
  names(out) <- c("aviso", "n")
  out
} else {
  data.frame(aviso = character(0), n = integer(0))
}

sections <- c(
    "# Ordem de defasagens `p` em `(r,q) = (4,4)`: a varredura no impacto, com bandas",
  "",
  sprintf("Gerado por `script/p_selection.R` em %s.", format(Sys.Date(), "%Y-%m-%d")),
  "**Corpo gerado — não escrever prosa aqui.** A leitura vive na nota datada.",
  "",
  sprintf(paste("Amostra completa (%s a %s), `%s` × `%s`, choque +%d pb,",
                "wild bootstrap nboot = %d, seed %d, bandas 68/90, h = 0..%d.",
                "Grade `p` pré-registrada em `registro/pendencias.md`: %s."),
          SPEC$sample[1], SPEC$sample[2], SPEC$instrument, SPEC$mp_var,
          SPEC$shock_bps, SPEC$nboot, SPEC$bootstrap_seed, SPEC$horizon,
          paste(sort(P_VALUES), collapse = ", ")),
  "",
  "## A pergunta e o desenho",
  "",
  paste("`p = 4` é a ordem de produção selecionada pelo AIC. Esta rodada põe",
        "a produção, o `p = 6` histórico e as alternativas `p = 3,2` lado a",
        "lado no desenho da Figura A3 de",
        "Alessi-Kerssenfischer — produção com ponto **e** bandas, alternativas em",
        "**ponto apenas** — e lê contenção contra as bandas da produção."),
  "",
  paste("**Critério de leitura, pré-registrado antes de olhar as trajetórias:**",
        "*imaterial* é `share_in90 = 1` **e** `cor_path > 0,95`; *material* é",
        "`share_in90 < 1` fora de h = 0 ou inversão de sinal no impacto; o resto",
        "é *parcial*. É o mesmo `containment_vs_production()` que a rodada de `q`",
        "usa, de modo que as duas não podem divergir na regra."),
  "",
  paste("A escolha usa somente o AIC; a força do instrumento e as trajetórias",
        "são diagnósticos consequentes, não critérios de seleção."),
  "",
  "## O que os critérios de ordem selecionam",
  "",
  paste("A seleção fixa todas as ordens nas últimas `T - 12 = 141` observações",
        "e inclui constante e tendência linear, como `vars::VARselect(type =",
        "\"both\")`. AIC e BIC são reproduzidos por `var_lag_criteria()` e pelo",
        "pacote `vars`, com desvio máximo inferior a `1e-12`. A tendência existe",
        "somente neste exercício: as células de IRF continuam estimando o VAR",
        "fatorial com intercepto apenas."),
  "",
  md_table(as.data.frame(argmins)),
  "",
  sprintf("Produção: `p = %d`.", SPEC$p),
  "",
  md_table(as.data.frame(lag_criteria)),
  "",
  "## Força e estabilidade por célula",
  "",
  paste("Réguas: `ar_bounded` é ξ_mp > 3,84, abaixo do qual o conjunto de",
        "Anderson-Rubin a 95% é ilimitado; `bands_valid` é ξ_mp ≥ 10, a",
        "referência convencional para bandas."),
  "",
  paste("**Duas assimetrias contra a varredura de `q`.** `n_obs_1st` é o tamanho",
        "do primeiro estágio, que `sel_ext_inst_sample()` reduz em exatamente `p`",
        "meses: ξ_mp de duas células **não está na mesma amostra**.",
        "`dim_companion` é `r·p`: a raiz máxima de duas células é o máximo de",
        "matrizes de tamanhos diferentes."),
  "",
  paste("`impacto_mp_pre` é o impacto de `yield_6m` **antes** da normalização, o",
        "denominador pelo qual toda IRF da célula é dividida. `denom_ratio` é esse",
        "denominador relativo ao da produção: é o fator de escala que separa uma",
        "IRF maior de um resultado maior."),
  "",
  md_table(as.data.frame(by_cell)),
  "",
  if (nrow(boot_warn_tbl) > 0) {
    c(paste("Avisos emitidos durante os bootstraps, registrados em vez de",
            "suprimidos. A correção de Kilian encolhe o viés do DGP até a",
            "companion ficar estável; onde a raiz OLS já está perto de 1 o",
            "encolhimento esgota as iterações. O ponto é OLS puro e não é",
            "afetado; as **bandas** da célula são o objeto afetado."),
      "",
      md_table(boot_warn_tbl),
      "")
  } else {
    c("Nenhum aviso durante os quatro bootstraps.", "")
  },
  "## A checagem da Figura A3, em número",
  "",
  paste0("`share_in68`/`share_in90` são a fração dos horizontes h = 0..", H_FIG,
         " em que o ponto da célula alternativa cai **dentro** da banda da ",
         "produção — é o que o olho lê na figura. `share_in90_h12` repete a ",
         "conta na janela curta que a pendência pede. `cor_path` mede **forma** ",
         "e é imune à escala; `rel_max_abs_dev` é o desvio máximo em unidades do ",
         "maior ponto da produção. `first_out90_h` é o primeiro horizonte em que ",
         "a alternativa sai da banda de 90%."),
  "",
  md_table(as.data.frame(verdict |>
                           dplyr::select(p, variable, share_in68, share_in90,
                                         share_in90_h12, first_out90_h, cor_path,
                                         max_abs_dev, max_abs_dev_h,
                                         rel_max_abs_dev, sign_flip_h0,
                                         veredito))),
  "",
  sprintf(paste("Contagem: **%d de %d** pares (variável × `p`) saem *imateriais*",
                "e **%d** saem *materiais*."),
          n_imaterial, nrow(verdict), n_material),
  "",
  "## Decomposição do gap: denominador ou coluna estimada?",
  "",
  paste("⚠ **Achado pós-hoc, deliberadamente fora da regra de veredito acima** —",
        "nenhuma destas colunas entra no `case_when` que classifica os pares,",
        "justamente para que olhar para elas não possa virar um veredito fixado",
        "antes."),
  "",
  paste("`ratio_h0` é o impacto da alternativa dividido pelo da produção.",
        "`resto_coluna_h0` é esse mesmo quociente **multiplicado por**",
        "`denom_ratio`, isto é, o que sobra do gap depois de remover o",
        "denominador de normalização: **1 significa que a coluna estimada não",
        "mudou e todo o gap era escala**. `share_in90_resc` repete a contenção",
        "com a trajetória inteira reescalada pelo denominador da produção."),
  "",
  sprintf(paste("⚠ Na linha de `%s` o `resto_coluna_h0` é **tautologicamente**",
                "igual a `denom_ratio`: o impacto bruto da variável de política",
                "*é* o denominador, então `ratio_h0` vale 1 por construção em",
                "toda célula. Essa linha não é achado, é a identidade que fixa a",
                "normalização."), SPEC$mp_var),
  "",
  md_table(as.data.frame(verdict |>
                           dplyr::select(p, variable, denom_ratio, ratio_h0,
                                         resto_coluna_h0, share_in90,
                                         share_in90_resc))),
  "",
  sprintf("## Impacto (h = 0) no bloco de %d variáveis", length(BLOCK)),
  "",
  paste("A curva inteira, o câmbio e as duas medidas soberanas, que é o bloco",
        "que a pendência pede. `asset_ibov` fica na tabela por ser onde as",
        "células mais discordaram na varredura de `q`."),
  "",
  md_table(as.data.frame(impact_wide), digits = 8),
  "",
  "### Exclui zero a 90% no impacto",
  "",
  md_table(as.data.frame(sig_wide)),
  "",
  sprintf("## A entrega: `h = 0..%d` por célula", H_SHORT),
  "",
  sprintf(paste("Âncoras em h = %s. `n_sig90` e `n_sig68` contam quantos dos %d",
                "horizontes da janela têm banda excluindo zero. Trajetórias",
                "completas até h = %d, com as quatro bandas, em",
                "`p_selection_paths.csv`."),
          paste(H_ANCHOR, collapse = ", "), H_SHORT + 1L, SPEC$horizon),
  "",
  md_table(as.data.frame(short_run), digits = 6),
  "",
  "## Reversão de médio prazo por célula",
  "",
  paste("`h_flip` é o primeiro horizonte em que a trajetória cruza de volta o",
        "sinal do próprio impacto; `h_ext_medio` e `val_ext_medio` são o extremo",
        "em h ≥ 12. ⚠ Esta tabela descreve a **dinâmica conjunta** do VAR dos",
        "fatores sob cada `p` — ela não constitui evidência separada da dinâmica",
        "que a produz, e é nessa qualidade que a §4 já a lê."),
  "",
  md_table(as.data.frame(reversal), digits = 6),
  "",
  "Figura em `p_selection_paths.pdf`."
)

writeLines(sections, file.path(OUT_DIR, "p_selection.md"))


# ---- Figure: the Figure A3 layout ------------------------------------

fig_df <- paths |>
  dplyr::filter(h <= H_FIG) |>
  dplyr::mutate(cell = factor(P_LAB(p), levels = P_LAB(P_VALUES)))

# Same paths with the normalization held at production's denominator. Last page
# only; it is the post-hoc decomposition drawn, and is labelled as such.
resc_df <- fig_df |>
  dplyr::mutate(point = point * unname(denom_ratio[as.character(p)]))

band_df <- fig_df |> dplyr::filter(p == SPEC$p)

title_main <- sprintf("Ordem de defasagens p em (r,q) = (%d,%d): producao com bandas, alternativas em ponto",
                      SPEC$r, SPEC$q)

sub_common <- sprintf("%s x %s, +%dbp, amostra completa; bandas 68/90 sao da producao (p=%d), nboot=%d",
                      SPEC$instrument, SPEC$mp_var, SPEC$shock_bps, SPEC$p, SPEC$nboot)

irf_page <- function(vars, ncol, subtitle, df = fig_df, title = title_main) {
  plot_dimension_overlay(df, band_df, vars, P_PALETTE, P_LINETYPE,
                         H_FIG, ncol, title, subtitle)
}

pdf(file.path(OUT_DIR, "p_selection_paths.pdf"), width = 11, height = 7)
print(irf_page(FIG_VARS, ncol = 3, sub_common))
print(irf_page(FIG_EXTRA, ncol = 2, sub_common,
               title = "Resto da curva e o bloco inconveniente"))
print(irf_page(c(FIG_VARS, FIG_EXTRA), ncol = 3,
               sprintf(paste("Alternativas multiplicadas por denom_ratio (%s em p=6/3/2);",
                             "as bandas continuam sendo as da producao"),
                       paste(formatC(denom_ratio[c("6", "3", "2")],
                                     format = "f", digits = 3), collapse = " / ")),
               df = resc_df,
               title = "POS-HOC, nao pre-registrado: as mesmas trajetorias com a normalizacao mantida fixa"))
dev.off()

cat(sprintf("\nEscrito: %s/p_selection.{csv,md}, p_selection_paths.{csv,pdf}, p_selection_containment.csv, p_selection_lag_criteria.csv\n",
            OUT_DIR))
cat("\n========== VEREDITO PRE-REGISTRADO ==========\n")
print(as.data.frame(verdict |>
                      dplyr::select(p, variable, share_in90, share_in90_h12,
                                    cor_path, rel_max_abs_dev, denom_ratio,
                                    veredito)),
      row.names = FALSE)
cat("\n========== IMPACTO ==========\n")
print(as.data.frame(impact_wide), row.names = FALSE)
