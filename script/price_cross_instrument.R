# ===================================================================
# Cross-instrument comparison of the PRICE BLOCK under the production
# production dimension (r,q,p) = (5,5,4), 111-series panel, both sample windows.
#
# Closes item D of registro/pendencias.md. The claim it has to settle:
# the short-run rise of consumer prices in the full sample is a property
# of the SAMPLE, not of how the instrument is built.
#
# THE LADDER. Not the 8-variant sweep of irf_spec_sweep.R — three NESTED
# constructions, each adding exactly one layer, the third being production
# (author decision, 2026-08-18). Mapped to R/instrument/build_variants.R:347-354:
#
#   z_bruto        delta_di  , no mask            -- raw DI surprise
#   z_bs_purif     e_di_bs   , no mask            -- + Bauer-Swanson eq. 7,
#                                                    RHS strictly predetermined
#   z_jk_bs_purif  e_di_bs   , jk_monetary_bs     -- + Jarocinski-Karadi sign filter
#
# Nesting is what buys the reading: the bruto->BS step isolates the VALUES
# layer and the BS->JK step isolates the SELECTION layer, which is the split
# the instrument round already measured (.claude/rules/instrument.md:
# "strength lives in the mask, not the purified values"). z_bruto_purif and
# z_jk_purif are deliberately OUT: they use e_di, the CONTEMPORANEOUS
# purification, whose RHS can absorb the shock itself.
#
# WHAT THIS DESIGN CANNOT SAY. The three rungs share the same Copom-day DI
# surprise by construction, so agreement across them says the pattern is not
# produced by the purification or by the sign filter. It does NOT say the
# pattern is common across identification SCHEMES — the het-identified
# instruments that used to carry that leg were abandoned on 2026-08-17 and
# are not citable (registro/historico_decisoes.md sec 0).
#
# Nothing in production is modified: point IRFs run off cached DFMs, the
# bootstrapped pre-COVID cell writes to this script's own .rds.
#
# Outputs: output/irf/price_cross_instrument.{csv,md}
#          output/irf/price_cross_instrument_pre_covid_bands.csv
#          output/irf/price_cross_instrument_pre_covid_cell.rds
#          output/irf/price_cross_instrument_paths.pdf
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")


# ---- Config --------------------------------------------------------

SPEC      <- production_spec()
R_FACTORS <- SPEC$r
Q_DYNAMIC <- SPEC$q
P_LAGS    <- SPEC$p
MP_VAR    <- SPEC$mp_var
HORIZON   <- SPEC$horizon
SHOCK_BPS <- SPEC$shock_bps
N_BOOT    <- SPEC$nboot
BOOT_SEED <- SPEC$bootstrap_seed
CI_LEVELS <- SPEC$ci_levels

# Ordered: each rung adds one layer to the one before it.
LADDER <- c("bruta"      = "z_bruto",
            "residual"   = "z_bs_purif",
            "residual+jk" = "z_jk_bs_purif")

SAMPLES <- list(full = SPEC$sample, pre_covid = SPEC$pre_covid_sample)

# The hump lives here (registro/pendencias.md, Tema D), not in the h12-h48
# window the coherence ruler scores.
HUMP_H <- 2:8

DATA_PATH <- SPEC$data_path
INST_PATH <- SPEC$instrument_path
OUT_DIR   <- "output/irf"

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data  <- readr::read_csv(DATA_PATH, show_col_types = FALSE) |> tidyr::drop_na()
dates     <- as.Date(raw_data$ref.date)
data_mat  <- raw_data |> dplyr::select(-ref.date) |> as.matrix()
var_names <- colnames(data_mat)
tcode     <- infer_tcode_from_varnames(var_names)

mpind <- match(MP_VAR, var_names)
if (is.na(mpind)) stop("mp_var '", MP_VAR, "' ausente do painel ", DATA_PATH)
norm_val <- norm_value_for(MP_VAR, SHOCK_BPS)

inst_panel <- readr::read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

missing_inst <- setdiff(unname(LADDER), names(inst_panel))
if (length(missing_inst) > 0) {
  stop("Colunas de instrumento ausentes em ", INST_PATH, ": ",
       paste(missing_inst, collapse = ", "),
       " — rode script/instrument.R")
}

# Price block inherited from the coherence table, so theory_sign and the
# scoring window come from one place only.
price_tbl <- coherence_var_table() |>
  dplyr::filter(group %in% c("precos", "precos_ambiguos"))

missing_price <- setdiff(price_tbl$var, var_names)
if (length(missing_price) > 0) {
  stop("Series de preco ausentes do painel: ", paste(missing_price, collapse = ", "))
}

cat(sprintf("Escada de %d degraus x %d janelas x %d series de preco, (r,q,p)=(%d,%d,%d)\n",
            length(LADDER), length(SAMPLES), nrow(price_tbl),
            R_FACTORS, Q_DYNAMIC, P_LAGS))


# ---- Point IRFs: one DFM per window, three cheap projections each ----

point_rows    <- list()
strength_rows <- list()
ic <- 0

for (sample_name in names(SAMPLES)) {
  win       <- SAMPLES[[sample_name]]
  in_window <- dates >= win[1] & dates <= win[2]
  data_sub  <- data_mat[in_window, , drop = FALSE]
  dates_sub <- dates[in_window]

  cat(sprintf("\n>>> [%s] estimando DFM (T=%d) ...\n", sample_name, nrow(data_sub)))
  t0  <- Sys.time()
  # Full window under the production Lenza-Primiceri scale; the pre-COVID window
  # has s_t = 1 in every month, so the weighted fit is the unweighted one.
  dfm <- estimate_dfm(data_sub, r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
                      dates = dates_sub, apply_kilian = FALSE,
                      covid_volatility = if (sample_name == "full")
                        SPEC$covid_volatility else NULL)
  cat(sprintf("    %.1fs, raiz maxima = %.6f\n",
              as.numeric(Sys.time() - t0, units = "secs"),
              dfm$diagnostics$max_eigenvalue))

  for (k in seq_along(LADDER)) {
    variant <- unname(LADDER[k])
    rung    <- names(LADDER)[k]

    inst_df <- data.frame(month = inst_panel$month, shock = inst_panel[[variant]])
    inst_df <- inst_df[!is.na(inst_df$shock), ]

    diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates_sub,
                                                   P_LAGS, mpind)

    irf <- compute_irf_dfm(dfm, instrument = inst_df, h = HORIZON, nboot = 0,
                           mpind = mpind, normalize_value = norm_val,
                           data_dates = dates_sub, tcode = tcode,
                           diagnose = FALSE)
    irf_mat <- irf$irf_point_matrix

    ic <- ic + 1
    strength_rows[[ic]] <- data.frame(
      sample = sample_name, rung = rung, instrument = variant, degrau = k,
      n_obs = diag_fs$n_obs, xi_mp = diag_fs$wald_mp,
      f_robust_mp = diag_fs$f_robust_mp, impact_mp_pre = diag_fs$impact_mp,
      max_eig = dfm$diagnostics$max_eigenvalue,
      stringsAsFactors = FALSE
    )

    point_rows[[ic]] <- do.call(rbind, lapply(price_tbl$var, function(v) {
      data.frame(sample = sample_name, rung = rung, instrument = variant,
                 degrau = k, var = v, h = 0:HORIZON,
                 point = irf_mat[match(v, var_names), ],
                 stringsAsFactors = FALSE)
    }))

    cat(sprintf("    %-14s xi_mp = %8.4f   IPCA h6 = %+8.5f\n", variant,
                diag_fs$wald_mp,
                irf_mat[match("price_ipca", var_names), 7]))
  }
}

strength <- dplyr::bind_rows(strength_rows)
paths    <- dplyr::bind_rows(point_rows)


# ---- Bootstrapped pre-COVID anchor at the production dimension -------
# The full-sample production cell is already bootstrapped in
# irf_coherence_h.csv; the pre-COVID (5,5) companion never was — stage 2
# only ever ran pre-COVID at (7,6) and (6,5).

cat(sprintf("\n>>> bootstrap pre-COVID %s x (%d,%d), nboot=%d ...\n",
            SPEC$instrument, R_FACTORS, Q_DYNAMIC, N_BOOT))
t0 <- Sys.time()
# The pre-COVID companion is marginally unstable (OLS root just above 1), so the
# Kilian shrinkage may exhaust its iterations without reaching stability. That is
# a property of the window, not a failure to be swallowed: collect the warnings
# and print them into the report instead of letting them scroll past.
boot_warnings <- character(0)
pre_cell <- withCallingHandlers(
  run_stage2_cell(
    data_mat, dates, inst_panel,
    sample_window = SPEC$pre_covid_sample,
    r = R_FACTORS, q = Q_DYNAMIC, p = P_LAGS,
    instrument = SPEC$instrument, mp_var = MP_VAR,
    h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED,
    shock_bps = SHOCK_BPS, tcode = tcode, ci_levels = CI_LEVELS,
    # Full window under the production Lenza-Primiceri scale: this script
    # self-tests its production cell against output/irf/irf_coherence_h.csv,
    # so it has to run the estimator production runs.
    covid_volatility = SPEC$covid_volatility
  ),
  warning = function(w) {
    boot_warnings <<- c(boot_warnings, conditionMessage(w))
    invokeRestart("muffleWarning")
  }
)
cat(sprintf("    %.1f min, raiz maxima = %.6f\n",
            as.numeric(Sys.time() - t0, units = "mins"), pre_cell$dfm_max_eig))
if (length(boot_warnings) > 0) {
  boot_warn_tbl <- as.data.frame(table(boot_warnings), stringsAsFactors = FALSE)
  names(boot_warn_tbl) <- c("aviso", "n")
  cat("    avisos do bootstrap:\n")
  print(boot_warn_tbl, row.names = FALSE)
} else {
  boot_warn_tbl <- data.frame(aviso = character(0), n = integer(0))
}
saveRDS(pre_cell, file.path(OUT_DIR, "price_cross_instrument_pre_covid_cell.rds"))

pre_point <- pre_cell$irf$irf_point_matrix
pre_ci68  <- pre_cell$irf$ci[["0.68"]]
pre_ci90  <- pre_cell$irf$ci[["0.90"]]

pre_bands <- dplyr::bind_rows(lapply(seq_len(nrow(price_tbl)), function(i) {
  spec <- price_tbl[i, ]
  idx  <- match(spec$var, var_names)
  evaluate_irf_path(pre_point[idx, ], pre_ci68$lower[idx, ], pre_ci68$upper[idx, ],
                    pre_ci90$lower[idx, ], pre_ci90$upper[idx, ], spec)$perh
}))

pre_summary <- dplyr::bind_rows(lapply(seq_len(nrow(price_tbl)), function(i) {
  spec <- price_tbl[i, ]
  idx  <- match(spec$var, var_names)
  evaluate_irf_path(pre_point[idx, ], pre_ci68$lower[idx, ], pre_ci68$upper[idx, ],
                    pre_ci90$lower[idx, ], pre_ci90$upper[idx, ], spec)$summary
}))


# ---- Self-tests ------------------------------------------------------

cat("\n========== AUTO-TESTES ==========\n")

# 1. The full-sample production rung must reproduce the published production
#    path exactly: the point estimate is plain OLS, so apply_kilian = FALSE
#    here and TRUE in irf_coherence_check.R cannot separate them.
coh <- readr::read_csv(file.path(OUT_DIR, "irf_coherence_h.csv"),
                       show_col_types = FALSE)
chk1 <- paths |>
  dplyr::filter(sample == "full", instrument == SPEC$instrument) |>
  dplyr::inner_join(coh |> dplyr::select(var, h, point_ref = point),
                    by = c("var", "h"))
stopifnot(nrow(chk1) == nrow(price_tbl) * (HORIZON + 1))
d1 <- max(abs(chk1$point - chk1$point_ref))
cat(sprintf("1. trajetoria full x %s vs irf_coherence_h.csv: %d pontos, desvio max %.3e\n",
            SPEC$instrument, nrow(chk1), d1))
stopifnot(d1 < 1e-10)

# 2. price_ipca at h0/h6/h12/h24 reproduces stage 1 when that artifact carries
#    the current p. A historical sweep at another p is not a regression target.
sweep_long <- readr::read_csv(file.path(OUT_DIR, "spec_sweep_irf_long.csv"),
                              show_col_types = FALSE)
if (all(sweep_long$p == P_LAGS)) {
  sweep_long <- sweep_long |>
  dplyr::filter(r == R_FACTORS, q == Q_DYNAMIC, mp_var == MP_VAR,
                response_var == "price_ipca", instrument %in% unname(LADDER)) |>
  dplyr::select(sample, instrument, h0, h6, h12, h24) |>
  tidyr::pivot_longer(c(h0, h6, h12, h24), names_to = "h", values_to = "point_ref") |>
  dplyr::mutate(h = as.integer(sub("^h", "", h)))
chk2 <- paths |>
  dplyr::filter(var == "price_ipca") |>
  dplyr::inner_join(sweep_long, by = c("sample", "instrument", "h"))
stopifnot(nrow(chk2) == length(LADDER) * length(SAMPLES) * 4L)
d2 <- max(abs(chk2$point - chk2$point_ref))
cat(sprintf("2. price_ipca h0/h6/h12/h24 vs spec_sweep_irf_long.csv: %d celulas, desvio max %.3e\n",
            nrow(chk2), d2))
stopifnot(d2 < 1e-10)
} else {
  cat(sprintf("2. comparacao com spec_sweep_irf_long.csv nao aplicavel: artefato historico usa p=%s, producao usa p=%d\n",
              paste(sort(unique(sweep_long$p)), collapse = "/"), P_LAGS))
}

# 3. Strength must agree with the canonical grid, cell by cell.
grid <- readr::read_csv("output/instrument/mosw_strength_grid.csv",
                        show_col_types = FALSE) |>
  dplyr::filter(r == R_FACTORS, q == Q_DYNAMIC, instrument %in% unname(LADDER)) |>
  dplyr::select(sample, instrument, xi_ref = wald_mp, f_ref = f_robust_mp,
                n_ref = n_obs)
chk3 <- strength |> dplyr::inner_join(grid, by = c("sample", "instrument"))
stopifnot(nrow(chk3) == length(LADDER) * length(SAMPLES))
d3 <- max(abs(chk3$xi_mp - chk3$xi_ref), abs(chk3$f_robust_mp - chk3$f_ref))
cat(sprintf("3. xi_mp e F_rob vs mosw_strength_grid.csv: %d celulas, desvio max %.3e\n",
            nrow(chk3), d3))
stopifnot(d3 < 1e-8, all(chk3$n_obs == chk3$n_ref))

# 4. The bootstrapped cell must deliver exactly the normalized shock.
pre_mp_h0 <- pre_point[mpind, 1]
cat(sprintf("4. %s h0 da celula bootstrapada = %.10f (alvo %.10f)\n",
            MP_VAR, pre_mp_h0, norm_val))
stopifnot(abs(pre_mp_h0 - norm_val) < 1e-12)

cat("Todos os auto-testes passaram.\n")


# ---- Derived reading tables ------------------------------------------

hump <- paths |>
  dplyr::filter(h %in% HUMP_H) |>
  dplyr::group_by(sample, degrau, rung, instrument, var) |>
  dplyr::summarise(
    hump_max   = point[which.max(abs(point))],
    hump_max_h = h[which.max(abs(point))],
    n_pos      = sum(point > 0),
    .groups = "drop"
  )

anchors <- paths |>
  dplyr::filter(h %in% c(0L, 6L, 12L, 24L)) |>
  dplyr::mutate(h = paste0("h", h)) |>
  tidyr::pivot_wider(id_cols = c(sample, degrau, rung, instrument, var),
                     names_from = h, values_from = point)

# Sign share over the coherence window (h12-h48), so the medium-run read is
# on the same window irf_coherence_check.R scores.
share <- paths |>
  dplyr::inner_join(price_tbl |> dplyr::select(var, theory_sign, w_lo, w_hi),
                    by = "var") |>
  dplyr::filter(h >= w_lo, h <= w_hi, !is.na(theory_sign)) |>
  dplyr::group_by(sample, degrau, rung, instrument, var) |>
  dplyr::summarise(share_correct = mean(sign(point) == theory_sign), .groups = "drop")

block <- hump |>
  dplyr::left_join(anchors, by = c("sample", "degrau", "rung", "instrument", "var")) |>
  dplyr::left_join(share,   by = c("sample", "degrau", "rung", "instrument", "var")) |>
  dplyr::arrange(sample, var, degrau)

# The nested design's payload: what each added layer does to the hump.
deltas <- hump |>
  dplyr::select(sample, var, degrau, hump_max) |>
  tidyr::pivot_wider(names_from = degrau, values_from = hump_max,
                     names_prefix = "d") |>
  dplyr::mutate(delta_valores = d2 - d1, delta_selecao = d3 - d2,
                delta_total   = d3 - d1)

readr::write_csv(paths, file.path(OUT_DIR, "price_cross_instrument.csv"))
readr::write_csv(pre_bands,
                 file.path(OUT_DIR, "price_cross_instrument_pre_covid_bands.csv"))
cat(sprintf("\n-> %s/price_cross_instrument.csv (%d linhas)\n", OUT_DIR, nrow(paths)))


# ---- Report ----------------------------------------------------------

ipca_hump <- paths |>
  dplyr::filter(var == "price_ipca", h %in% HUMP_H) |>
  dplyr::mutate(h = paste0("h", h)) |>
  tidyr::pivot_wider(id_cols = c(sample, degrau, rung, instrument),
                     names_from = h, values_from = point) |>
  dplyr::arrange(sample, degrau)

strength_tbl <- strength |>
  dplyr::mutate(ar_limitada = xi_mp > 3.84, bandas_validas = xi_mp >= 10) |>
  dplyr::select(sample, degrau, rung, instrument, n_obs, xi_mp, f_robust_mp,
                impact_mp_pre, ar_limitada, bandas_validas) |>
  dplyr::arrange(sample, degrau)

n_pos_full <- block |>
  dplyr::filter(sample == "full") |>
  dplyr::group_by(var) |>
  dplyr::summarise(n_degraus_pos = sum(hump_max > 0), .groups = "drop")
n_pos_pre <- block |>
  dplyr::filter(sample == "pre_covid") |>
  dplyr::group_by(var) |>
  dplyr::summarise(n_degraus_pos = sum(hump_max > 0), .groups = "drop")
concordancia <- n_pos_full |>
  dplyr::rename(full_positivos = n_degraus_pos) |>
  dplyr::left_join(n_pos_pre |> dplyr::rename(pre_covid_positivos = n_degraus_pos),
                   by = "var")

md <- c(
  "# Bloco de precos atraves da escada de instrumentos",
  "",
  sprintf("Gerado por `script/price_cross_instrument.R` em %s.", format(Sys.Date())),
  "",
  sprintf(paste0("Painel de %d series, `(r,q,p)=(%d,%d,%d)`, `mp_var = %s`, choque ",
                 "+%dbp, h = 0..%d, duas janelas amostrais. Estimativas de **ponto** ",
                 "(`nboot = 0`) para os tres degraus; a celula pre-COVID de producao ",
                 "recebeu bootstrap de %d replicas com semente %d."),
          length(var_names), R_FACTORS, Q_DYNAMIC, P_LAGS, MP_VAR,
          SHOCK_BPS, HORIZON, N_BOOT, BOOT_SEED),
  "",
  "## A escada",
  "",
  paste0("Tres construcoes **aninhadas**, cada uma acrescentando exatamente uma ",
         "camada, a terceira sendo a producao. O que o desenho aninhado permite ler ",
         "e a decomposicao entre a camada de **valores** (degrau 1 -> 2) e a de ",
         "**selecao** (degrau 2 -> 3)."),
  "",
  md_table(data.frame(
    degrau = seq_along(LADDER),
    rotulo = names(LADDER),
    coluna = unname(LADDER),
    valores = c("delta_di", "e_di_bs", "e_di_bs"),
    mascara = c("nenhuma", "nenhuma", "jk_monetary_bs"),
    stringsAsFactors = FALSE
  )),
  "",
  paste0("`z_bruto_purif` e `z_jk_purif` ficam fora de proposito: usam `e_di`, a ",
         "purificacao **contemporanea**, cujo lado direito pode absorver o proprio ",
         "choque. Os tres degraus partem da mesma surpresa de DI em dia de Copom, ",
         "de modo que a concordancia entre eles diz que o padrao **nao e produzido ",
         "pela purificacao nem pelo filtro de sinal**; ela nao diz que o padrao e ",
         "comum entre **esquemas** de identificacao."),
  "",
  "## Forca por degrau",
  "",
  paste0("`ar_limitada` e xi_mp > 3,84 (conjunto AR de 95% limitado); ",
         "`bandas_validas` e xi_mp >= 10 (referencia convencional de Staiger-Stock). ",
         "`impact_mp_pre` e a resposta de `", MP_VAR, "` no impacto **antes** da ",
         "normalizacao, isto e o denominador pelo qual cada IRF da celula e dividida."),
  "",
  md_table(strength_tbl),
  "",
  "## IPCA cheio em h2-h8",
  "",
  "Onde vive a corcova. Pontos em pontos percentuais da taxa mensal.",
  "",
  md_table(ipca_hump),
  "",
  "## Bloco completo: corcova, ancoras e sinal de medio prazo",
  "",
  paste0("`hump_max` e o ponto de maior modulo em h2-h8 e `hump_max_h` o horizonte ",
         "onde ele ocorre; `n_pos` conta quantos dos ", length(HUMP_H),
         " horizontes da janela tem ponto positivo. `share_correct` e a fracao de ",
         "horizontes com sinal igual ao teorico dentro da janela da regua de ",
         "coerencia (h12-h48 para as seis medidas pontuadas), `NA` para as duas ",
         "ambiguas."),
  "",
  md_table(block |> dplyr::select(sample, var, degrau, rung, hump_max, hump_max_h,
                                  n_pos, h0, h6, h12, h24, share_correct)),
  "",
  "## O que cada camada acrescenta a corcova",
  "",
  paste0("`delta_valores` = degrau 2 menos degrau 1 (efeito da residualizacao sobre ",
         "informacao predeterminada); `delta_selecao` = degrau 3 menos degrau 2 ",
         "(efeito do filtro de sinal). Ambos sobre `hump_max`."),
  "",
  md_table(deltas |> dplyr::select(sample, var, d1, d2, d3,
                                   delta_valores, delta_selecao, delta_total)),
  "",
  "## Concordancia entre degraus",
  "",
  sprintf("Numero de degraus (de %d) com `hump_max` positivo em cada janela.",
          length(LADDER)),
  "",
  md_table(concordancia),
  "",
  "## Celula pre-COVID de producao, com bandas",
  "",
  sprintf(paste0("`%s` x `(%d,%d)` na janela pre-COVID, wild bootstrap de %d ",
                 "replicas. Raiz maxima da companion = %s: a janela e marginalmente ",
                 "instavel, entao a leitura fica em h <= 12 e as bandas longas nao ",
                 "sao confiaveis."),
          SPEC$instrument, R_FACTORS, Q_DYNAMIC, N_BOOT,
          formatC(pre_cell$dfm_max_eig, format = "f", digits = 6)),
  "",
  if (nrow(boot_warn_tbl) > 0) {
    c(paste0("Avisos emitidos durante o bootstrap desta celula, registrados em vez ",
             "de suprimidos:"),
      "",
      md_table(boot_warn_tbl),
      "",
      paste0("A correcao de Kilian encolhe o vies do DGP do bootstrap ate a ",
             "companion ficar estavel; nesta janela a raiz OLS ja esta acima de 1, ",
             "entao o encolhimento esgota as iteracoes. O ponto e OLS puro e nao ",
             "e afetado; as **bandas** desta celula sao o objeto afetado."),
      "")
  } else {
    c("Nenhum aviso durante o bootstrap desta celula.", "")
  },
  md_table(pre_bands |>
             dplyr::filter(h %in% c(0L, HUMP_H, 12L, 24L)) |>
             dplyr::select(var, h, point, lo68, hi68, lo90, hi90, sig68, sig90)),
  "",
  "### Veredito da regua sobre a celula pre-COVID",
  "",
  md_table(pre_summary |>
             dplyr::select(var, tier, theory_sign, h0, h6, h12, h24,
                           share_correct, first_correct_h, right_sig90,
                           wrong_sig90, verdict)),
  "",
  "Trajetorias completas em `price_cross_instrument.csv`; figura em",
  "`price_cross_instrument_paths.pdf`."
)

writeLines(md, file.path(OUT_DIR, "price_cross_instrument.md"))
cat(sprintf("-> %s/price_cross_instrument.md\n", OUT_DIR))


# ---- Figure ----------------------------------------------------------

pdf(file.path(OUT_DIR, "price_cross_instrument_paths.pdf"), width = 11, height = 8)
for (sample_name in names(SAMPLES)) {
  df <- paths |>
    dplyr::filter(sample == sample_name, h <= 24) |>
    dplyr::mutate(rung = factor(rung, levels = names(LADDER)),
                  var  = factor(var, levels = price_tbl$var))

  p <- ggplot2::ggplot(df, ggplot2::aes(x = h, y = point, colour = rung)) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
    ggplot2::geom_line(linewidth = 0.7) +
    ggplot2::facet_wrap(~var, ncol = 4, scales = "free_y") +
    ggplot2::scale_colour_manual(values = c("bruta" = "grey40",
                                            "residual" = "steelblue",
                                            "residual+jk" = "firebrick")) +
    ggplot2::labs(
      title = sprintf("Bloco de precos por degrau da escada - amostra %s", sample_name),
      subtitle = sprintf("(r,q,p)=(%d,%d,%d), %s +%dbp; estimativas de ponto, sem bandas",
                         R_FACTORS, Q_DYNAMIC, P_LAGS, MP_VAR, SHOCK_BPS),
      x = "horizonte (meses)", y = NULL, colour = NULL) +
    ggplot2::theme_minimal(base_size = 10) +
    ggplot2::theme(legend.position = "bottom")
  print(p)
}
dev.off()
cat(sprintf("-> %s/price_cross_instrument_paths.pdf\n", OUT_DIR))


# ---- Console summary -------------------------------------------------

cat("\n========== FORCA ==========\n")
print(as.data.frame(strength_tbl), row.names = FALSE)
cat("\n========== IPCA h2-h8 ==========\n")
print(as.data.frame(ipca_hump), row.names = FALSE)
cat("\n========== DELTAS POR CAMADA ==========\n")
print(as.data.frame(deltas), row.names = FALSE)
