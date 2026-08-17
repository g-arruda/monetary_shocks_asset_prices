# ===================================================================
# Side-by-side comparison of the dynamic-factor dimension q at the
# production r = 5, on the full sample: the production cell (5,5)
# against the two cells the Amengual-Watson criterion points at in its
# admissible (BLL) form.
#
# Opened for the "fundamentar ou substituir o default operacional q=5"
# item of registro/pendencias.md, Tema E. The item requires the same
# full sample, the 800-replica gate and the five mandatory impacts, so
# that is exactly what this reports. It states no preference: the point
# is to put the three columns next to each other.
#
# Fidelity of the criterion itself is a separate question, closed by
# script/validate_amengual_watson.R.
#
# Outputs: output/factors/q_selection.csv
#          output/factors/q_selection.md
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")


# ---- Config --------------------------------------------------------

SPEC     <- production_spec()
Q_VALUES <- c(SPEC$q, 3L, 2L)
HEADLINE <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd")
CHI2_1_95 <- qchisq(0.95, df = 1)
OUT_DIR  <- "output/factors"

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
stopifnot(!is.na(mp_idx), all(HEADLINE %in% var_names))

inst_panel <- readr::read_csv(SPEC$instrument_path, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)
inst_df <- data.frame(month = inst_panel$month,
                      shock = inst_panel[[SPEC$instrument]])
inst_df <- inst_df[!is.na(inst_df$shock), ]

in_window <- dates >= SPEC$sample[1] & dates <= SPEC$sample[2]
data_sub  <- data_mat[in_window, , drop = FALSE]
dates_sub <- dates[in_window]


# ---- What the criterion says --------------------------------------

aw_bll   <- amengual_watson(data_mat, r = SPEC$r, p = SPEC$p, apply_bll = TRUE)
aw_level <- amengual_watson(data_mat, r = SPEC$r, p = SPEC$p, apply_bll = FALSE)

cat(sprintf("Amengual-Watson: BLL (admissivel) q = %d | niveis (fidelidade) q = %d\n",
            aw_bll$q_hat, aw_level$q_hat))


# ---- Cells ---------------------------------------------------------

rows <- list()

for (q in Q_VALUES) {
  cat(sprintf(">>> celula (r=%d, q=%d, p=%d), nboot=%d ...\n",
              SPEC$r, q, SPEC$p, SPEC$nboot))
  t0 <- Sys.time()

  dfm <- estimate_dfm(data_sub, r = SPEC$r, q = q, p = SPEC$p,
                      dates = dates_sub, apply_kilian = FALSE)
  diag_fs <- diagnose_instrument_in_factor_space(dfm, inst_df, dates_sub,
                                                 SPEC$p, mp_idx)

  cell <- run_stage2_cell(
    data_mat, dates, inst_panel,
    sample_window = SPEC$sample,
    r = SPEC$r, q = q, p = SPEC$p,
    instrument = SPEC$instrument, mp_var = SPEC$mp_var,
    h = SPEC$horizon, nboot = SPEC$nboot, seed = SPEC$bootstrap_seed,
    shock_bps = SPEC$shock_bps, tcode = tcode, ci_levels = SPEC$ci_levels
  )

  point <- cell$irf$irf_point_matrix
  ci68  <- cell$irf$ci[["0.68"]]
  ci90  <- cell$irf$ci[["0.90"]]
  for (v in HEADLINE) {
    i <- match(v, var_names)
    rows[[length(rows) + 1]] <- data.frame(
      r = SPEC$r, q = q, p = SPEC$p,
      variable = v,
      point = point[i, 1],
      lo68 = ci68$lower[i, 1], hi68 = ci68$upper[i, 1],
      lo90 = ci90$lower[i, 1], hi90 = ci90$upper[i, 1],
      xi_mp = diag_fs$wald_mp,
      f_robust_mp = diag_fs$f_robust_mp,
      ar_bounded = diag_fs$wald_mp > CHI2_1_95,
      bands_valid = diag_fs$wald_mp >= 10,
      # Pre-normalization impact of the policy variable: the denominator every
      # IRF of the cell is divided by, so a weaker cell prints LARGER responses.
      # Same field as jk_sovereign_confound.R; it has to sit next to xi_mp
      # rather than be inferred from it.
      impacto_mp_pre = diag_fs$impact_mp,
      max_companion_root = cell$dfm_max_eig,
      stringsAsFactors = FALSE
    )
  }
  cat(sprintf("    xi_mp = %.6f | raiz max = %.6f | %.1f s\n",
              diag_fs$wald_mp, cell$dfm_max_eig,
              as.numeric(Sys.time() - t0, units = "secs")))
}

tbl <- dplyr::bind_rows(rows)
readr::write_csv(tbl, file.path(OUT_DIR, "q_selection.csv"))


# ---- Report --------------------------------------------------------

sig <- function(lo, hi) ifelse(lo * hi > 0, "sim", "nao")
tbl$sig90 <- sig(tbl$lo90, tbl$hi90)
tbl$sig68 <- sig(tbl$lo68, tbl$hi68)

by_cell <- tbl |>
  dplyr::distinct(q, xi_mp, f_robust_mp, ar_bounded, bands_valid,
                  impacto_mp_pre, max_companion_root)

impact_wide <- tbl |>
  dplyr::select(variable, q, point) |>
  tidyr::pivot_wider(names_from = q, values_from = point,
                     names_prefix = "q=")

sig_wide <- tbl |>
  dplyr::select(variable, q, sig90) |>
  tidyr::pivot_wider(names_from = q, values_from = sig90,
                     names_prefix = "q=")

sections <- c(
  "# Seleção de q em r = 5: as três células lado a lado",
  "",
  sprintf("Gerado por `script/q_selection.R` em %s.", format(Sys.Date(), "%Y-%m-%d")),
  "**Corpo gerado — não escrever prosa aqui.** A leitura vive na nota datada.",
  "",
  sprintf(paste("Amostra completa (%s a %s), `%s` × `%s`, choque +%d pb,",
                "wild bootstrap nboot = %d, seed %d, bandas 68/90."),
          SPEC$sample[1], SPEC$sample[2], SPEC$instrument, SPEC$mp_var,
          SPEC$shock_bps, SPEC$nboot, SPEC$bootstrap_seed),
  "",
  "## O que o critério de Amengual-Watson seleciona",
  "",
  sprintf(paste("- Versão **BLL** (diferenças padronizadas), que é a admissível",
                "num painel não-estacionário: **q = %d**."), aw_bll$q_hat),
  sprintf(paste("- Versão em **níveis**, que é o comparável de fidelidade ao",
                "MATLAB original: **q = %d**. Ver",
                "`output/validation/amengual_watson_validation.md`."),
          aw_level$q_hat),
  sprintf("- Produção corrente: **q = %d**.", SPEC$q),
  "",
  "## Força e estabilidade por célula",
  "",
  md_table(as.data.frame(by_cell)),
  "",
  paste("Réguas: `ar_bounded` é ξ_mp > 3,84, abaixo do qual o conjunto de",
        "Anderson-Rubin a 95% é ilimitado; `bands_valid` é ξ_mp ≥ 10, a",
        "referência convencional para bandas."),
  "",
  paste("`impacto_mp_pre` é o impacto de `yield_6m` **antes** da normalização,",
        "o denominador pelo qual toda IRF da célula é dividida. É por isso que",
        "uma célula mais fraca imprime respostas **maiores**, e por isso ele",
        "aparece ao lado de ξ_mp em vez de ser inferido dele."),
  "",
  "## Impacto (h = 0) nas cinco variáveis obrigatórias",
  "",
  md_table(as.data.frame(impact_wide), digits = 8),
  "",
  "### Exclui zero a 90% no impacto",
  "",
  md_table(as.data.frame(sig_wide)),
  ""
)

writeLines(sections, file.path(OUT_DIR, "q_selection.md"))
cat("Escrito: output/factors/q_selection.{csv,md}\n")
