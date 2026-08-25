# ===================================================================
# The dynamic-factor dimension q at the production r = 5, full sample:
# the production cell (5,5) against q = 4, 3 and 2.
#
# THE DESIGN IS ALESSI-KERSSENFISCHER'S OWN. Their footnote 4 justifies
# q = r on evidence, not convenience:
#
#   "In principle, the DFM framework allows static factors F_t to have
#    reduced rank -- that is, to be spanned by q <= r 'dynamic' factors.
#    Given our external instrument identification scheme, however, results
#    are virtually identical whether or not q < r; thus we assume q = r
#    for simplicity."
#
# Figure A3 of their appendix is what backs it: the benchmark (p=6, r=8,
# q=8) carries point AND bands, and q = 5, 6, 7 are overlaid as POINT-ONLY
# lines. This script builds that figure for r = 5, plus the numbers the eye
# cannot read off it.
#
# Opened for the "fundamentar ou substituir o default operacional q=5" item
# of registro/pendencias.md, Tema E, which also requires the same full
# sample, the 800-replica gate and the mandatory impacts -- so those stay.
#
# q = 2 is in the grid because it is what the admissible (BLL) form of the
# Amengual-Watson criterion selects; dropping it would delete the evidence
# the pendency turns on. Fidelity of that criterion is a separate question,
# closed by script/validate_amengual_watson.R.
#
# THE READING RULE IS PRE-REGISTERED (registro/pendencias.md, Tema E, and
# the plan of 2026-08-18), fixed before the paths were looked at:
#   immaterial (AK's verdict) <=> share_in90 == 1 everywhere AND cor_path > 0.95
#   material                  <=> share_in90 < 1 away from h = 0, or a sign flip
# Anything between is reported variable by variable, not rounded to the
# convenient side.
#
# WHAT SEPARATES SHAPE FROM SCALE, and why it has to. Every IRF of a cell is
# divided by that cell's own pre-normalization impact of the policy variable,
# so a WEAKER cell prints LARGER responses for arithmetic reasons alone.
# denom_ratio carries that factor explicitly; cor_path is immune to it.
#
# asset_ibov is deliberately kept in every table and gets its own figure page:
# it is where the cells disagree most, and reporting the block without it
# would be exactly the cherry-picking the project forbids.
#
# Outputs: output/factors/q_selection.{csv,md}
#          output/factors/q_selection_paths.csv
#          output/factors/q_selection_containment.csv
#          output/factors/q_selection_paths.pdf
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")


# ---- Config --------------------------------------------------------

SPEC     <- production_spec()
Q_VALUES <- c(SPEC$q, 4L, 3L, 2L)

# Tables carry the five mandatory impacts plus cds_5y. The headline figure
# drops asset_ibov (author decision, 2026-08-18) and it returns on page 2.
BLOCK     <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd", "cds_5y",
               "asset_ibov")
FIG_VARS  <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd", "cds_5y")
FIG_EXTRA <- "asset_ibov"

H_FIG     <- 36L   # the horizon every paper figure stops at
H_SHORT   <- 12L   # the reportable window for the asset block
CHI2_1_95 <- qchisq(0.95, df = 1)
OUT_DIR   <- "output/factors"

Q_LAB     <- function(q) ifelse(q == SPEC$q, sprintf("q=%d (producao)", q),
                                sprintf("q=%d", q))
Q_PALETTE <- c("black", "firebrick", "darkgreen", "goldenrod3")
names(Q_PALETTE) <- Q_LAB(Q_VALUES)
Q_LINETYPE <- c("solid", "42", "22", "1343")
names(Q_LINETYPE) <- Q_LAB(Q_VALUES)

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

# Read before anything is overwritten: the non-regression test below compares
# against the version of this table that is on disk now.
prev_impacts <- readr::read_csv(file.path(OUT_DIR, "q_selection.csv"),
                                show_col_types = FALSE)


# ---- What the criterion says --------------------------------------

aw_bll   <- amengual_watson(data_mat, r = SPEC$r, p = SPEC$p, apply_bll = TRUE)
aw_level <- amengual_watson(data_mat, r = SPEC$r, p = SPEC$p, apply_bll = FALSE)

cat(sprintf("Amengual-Watson: BLL (admissivel) q = %d | niveis (fidelidade) q = %d\n",
            aw_bll$q_hat, aw_level$q_hat))


# ---- Cells ---------------------------------------------------------

impact_rows <- list()
path_rows   <- list()
cells       <- list()

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

  cells[[as.character(q)]] <- list(point = point, ci68 = ci68, ci90 = ci90,
                                   impacto_mp_pre = diag_fs$impact_mp)

  for (v in BLOCK) {
    i <- match(v, var_names)
    impact_rows[[length(impact_rows) + 1]] <- data.frame(
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

    j <- seq_len(SPEC$horizon + 1)
    path_rows[[length(path_rows) + 1]] <- data.frame(
      q = q, variable = v, h = 0:SPEC$horizon,
      point = point[i, j],
      lo68 = ci68$lower[i, j], hi68 = ci68$upper[i, j],
      lo90 = ci90$lower[i, j], hi90 = ci90$upper[i, j],
      stringsAsFactors = FALSE
    )
  }

  cat(sprintf("    xi_mp = %.6f | raiz max = %.6f | %.1f s\n",
              diag_fs$wald_mp, cell$dfm_max_eig,
              as.numeric(Sys.time() - t0, units = "secs")))
}

tbl   <- dplyr::bind_rows(impact_rows)
paths <- dplyr::bind_rows(path_rows)


# ---- Self-tests ------------------------------------------------------

cat("\n========== AUTO-TESTES ==========\n")

# 1. irf_coherence_check.R calls the same run_stage2_cell() with the same
#    SPEC nboot, seed and window, so the production cell must reproduce the
#    published table exactly -- bands included, not just the point.
coh <- readr::read_csv("output/irf/irf_coherence_h.csv", show_col_types = FALSE)
chk1 <- paths |>
  dplyr::filter(q == SPEC$q) |>
  dplyr::inner_join(coh |> dplyr::select(var, h, point_ref = point,
                                         lo68_ref = lo68, hi68_ref = hi68,
                                         lo90_ref = lo90, hi90_ref = hi90),
                    by = c("variable" = "var", "h"))
stopifnot(nrow(chk1) == length(BLOCK) * (SPEC$horizon + 1))
d1 <- max(abs(chk1$point - chk1$point_ref), abs(chk1$lo68 - chk1$lo68_ref),
          abs(chk1$hi68 - chk1$hi68_ref), abs(chk1$lo90 - chk1$lo90_ref),
          abs(chk1$hi90 - chk1$hi90_ref))
cat(sprintf("1. celula q=%d (ponto + bandas 68/90) vs irf_coherence_h.csv: %d pontos, desvio max %.3e\n",
            SPEC$q, nrow(chk1), d1))
stopifnot(d1 < 1e-10)

# 2. Strength must agree with the canonical grid, cell by cell.
grid <- readr::read_csv("output/instrument/mosw_strength_grid.csv",
                        show_col_types = FALSE) |>
  dplyr::filter(sample == "full", r == SPEC$r, instrument == SPEC$instrument,
                q %in% Q_VALUES) |>
  dplyr::select(q, xi_ref = wald_mp, f_ref = f_robust_mp)
chk2 <- tbl |>
  dplyr::distinct(q, xi_mp, f_robust_mp) |>
  dplyr::inner_join(grid, by = "q")
stopifnot(nrow(chk2) == length(Q_VALUES))
d2 <- max(abs(chk2$xi_mp - chk2$xi_ref), abs(chk2$f_robust_mp - chk2$f_ref))
cat(sprintf("2. xi_mp e F_rob vs mosw_strength_grid.csv: %d celulas, desvio max %.3e\n",
            nrow(chk2), d2))
stopifnot(d2 < 1e-8)

# 3. The normalization is not optional: every cell delivers exactly the shock.
mp_h0 <- tbl$point[tbl$variable == SPEC$mp_var]
cat(sprintf("3. %s em h=0 nas %d celulas: desvio max de %.4f = %.3e\n",
            SPEC$mp_var, length(mp_h0), SPEC$normalize_value,
            max(abs(mp_h0 - SPEC$normalize_value))))
stopifnot(max(abs(mp_h0 - SPEC$normalize_value)) < 1e-12)

# 4. Non-regression only applies within the same factor-VAR order. During an
# intentional p migration, the previous table is a historical comparison.
if ("p" %in% names(prev_impacts) && all(prev_impacts$p == SPEC$p)) {
  chk4 <- tbl |>
    dplyr::select(q, variable, point) |>
    dplyr::inner_join(
      prev_impacts |> dplyr::select(q, variable, point_prev = point),
      by = c("q", "variable")
    )
  d4 <- max(abs(chk4$point - chk4$point_prev))
  cat(sprintf("4. nao-regressao vs q_selection.csv anterior: %d celulas, desvio max %.3e\n",
              nrow(chk4), d4))
  stopifnot(nrow(chk4) > 0, d4 < 1e-10)
} else {
  cat(sprintf("4. nao-regressao nao aplicavel: artefato anterior usa p=%s, producao usa p=%d\n",
              paste(sort(unique(prev_impacts$p)), collapse = "/"), SPEC$p))
}

cat("Todos os auto-testes passaram.\n")


# ---- The pre-registered reading --------------------------------------
# Containment is read against the PRODUCTION bands, because it is production
# that carries a band -- exactly the asymmetry of Alessi-Kerssenfischer's
# Figure A3. cor_path is scale-free and denom_ratio names the scale factor,
# so a gap can be attributed instead of merely observed. The rule itself lives
# in containment_vs_production(); script/p_selection.R reads p through it too.

denom <- vapply(cells, function(x) x$impacto_mp_pre, numeric(1))
denom_ratio <- denom / denom[as.character(SPEC$q)]

verdict <- paths |>
  dplyr::rename(cell_key = q) |>
  containment_vs_production(prod_key = SPEC$q, denom_ratio = denom_ratio,
                            h_max = H_FIG, h_short = H_SHORT,
                            var_order = BLOCK) |>
  dplyr::rename(q = cell_key)


readr::write_csv(tbl, file.path(OUT_DIR, "q_selection.csv"))
readr::write_csv(paths, file.path(OUT_DIR, "q_selection_paths.csv"))
readr::write_csv(verdict, file.path(OUT_DIR, "q_selection_containment.csv"))


# ---- Report --------------------------------------------------------

sig <- function(lo, hi) ifelse(lo * hi > 0, "sim", "nao")
tbl$sig90 <- sig(tbl$lo90, tbl$hi90)
tbl$sig68 <- sig(tbl$lo68, tbl$hi68)

by_cell <- tbl |>
  dplyr::distinct(q, xi_mp, f_robust_mp, ar_bounded, bands_valid,
                  impacto_mp_pre, max_companion_root) |>
  dplyr::mutate(denom_ratio = unname(denom_ratio[as.character(q)]))

impact_wide <- tbl |>
  dplyr::select(variable, q, point) |>
  tidyr::pivot_wider(names_from = q, values_from = point,
                     names_prefix = "q=")

sig_wide <- tbl |>
  dplyr::select(variable, q, sig90) |>
  tidyr::pivot_wider(names_from = q, values_from = sig90,
                     names_prefix = "q=")

n_imaterial <- sum(verdict$veredito == "imaterial")
n_material  <- sum(verdict$veredito == "material")

sections <- c(
  "# Seleção de q em r = 5: a checagem da Figura A3 de Alessi-Kerssenfischer",
  "",
  sprintf("Gerado por `script/q_selection.R` em %s.", format(Sys.Date(), "%Y-%m-%d")),
  "**Corpo gerado — não escrever prosa aqui.** A leitura vive na nota datada.",
  "",
  sprintf(paste("Amostra completa (%s a %s), `%s` × `%s`, choque +%d pb,",
                "wild bootstrap nboot = %d, seed %d, bandas 68/90, h = 0..%d."),
          SPEC$sample[1], SPEC$sample[2], SPEC$instrument, SPEC$mp_var,
          SPEC$shock_bps, SPEC$nboot, SPEC$bootstrap_seed, SPEC$horizon),
  "",
  "## O desenho que está sendo replicado",
  "",
  paste("A nota 4 de Alessi-Kerssenfischer justifica `q = r` por evidência, não",
        "por conveniência: *\"Given our external instrument identification scheme,",
        "results are virtually identical whether or not q < r; thus we assume",
        "q = r for simplicity.\"* A Figura A3 do apêndice é o que sustenta isso —",
        "o benchmark `(p=6, r=8, q=8)` carrega ponto **e** bandas, e `q = 5, 6, 7`",
        "entram sobrepostos como linhas de **ponto apenas**. Esta rodada constrói",
        "a mesma figura para `r = 5`."),
  "",
  paste("**Critério de leitura, pré-registrado antes de olhar as trajetórias:**",
        "*imaterial* é `share_in90 = 1` **e** `cor_path > 0,95`; *material* é",
        "`share_in90 < 1` fora de h = 0 ou inversão de sinal no impacto; o resto",
        "é *parcial*."),
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
        "aparece ao lado de ξ_mp em vez de ser inferido dele. `denom_ratio` é",
        "esse denominador relativo ao da produção: é o fator de escala que",
        "separa uma IRF maior de um resultado maior."),
  "",
  "## A checagem da Figura A3, em número",
  "",
  paste0("`share_in68`/`share_in90` são a fração dos horizontes h = 0..", H_FIG,
         " em que o ponto da célula alternativa cai **dentro** da banda da ",
         "produção — é o que o olho lê na figura. `cor_path` mede **forma** e é ",
         "imune à escala; `rel_max_abs_dev` é o desvio máximo em unidades do ",
         "maior ponto da produção. `first_out90_h` é o primeiro horizonte em que ",
         "a alternativa sai da banda de 90%."),
  "",
  md_table(as.data.frame(verdict |>
                           dplyr::select(q, variable, share_in68, share_in90,
                                         share_in90_h12, first_out90_h, cor_path,
                                         max_abs_dev, max_abs_dev_h,
                                         rel_max_abs_dev, sign_flip_h0,
                                         veredito))),
  "",
  sprintf(paste("Contagem: **%d de %d** pares (variável × q) saem *imateriais*",
                "e **%d** saem *materiais*."),
          n_imaterial, nrow(verdict), n_material),
  "",
  "## Decomposição do gap: denominador ou coluna estimada?",
  "",
  paste("⚠ **Achado pós-hoc, encontrado depois de olhar as trajetórias, e",
        "deliberadamente fora da regra de veredito acima** — nenhuma destas",
        "colunas entra no `case_when` que classifica os pares, justamente para",
        "que olhar para elas não possa virar um veredito fixado antes."),
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
                "toda célula. Essa linha não é achado, é a identidade que fixa",
                "a normalização."), SPEC$mp_var),
  "",
  md_table(as.data.frame(verdict |>
                           dplyr::select(q, variable, denom_ratio, ratio_h0,
                                         resto_coluna_h0, share_in90,
                                         share_in90_resc))),
  "",
  sprintf("## Impacto (h = 0) no bloco de %d variáveis", length(BLOCK)),
  "",
  paste("As cinco obrigatórias mais `cds_5y`. `asset_ibov` fica na tabela ainda",
        "que tenha saído da figura-manchete: é onde as células mais discordam."),
  "",
  md_table(as.data.frame(impact_wide), digits = 8),
  "",
  "### Exclui zero a 90% no impacto",
  "",
  md_table(as.data.frame(sig_wide)),
  "",
  "Trajetórias completas em `q_selection_paths.csv`; figura em",
  "`q_selection_paths.pdf`.",
  ""
)

writeLines(sections, file.path(OUT_DIR, "q_selection.md"))


# ---- Figure: the Figure A3 layout ------------------------------------
# Production carries both ribbons and a solid black line; the alternatives
# are point-only dashed lines. The asymmetry is the design, not an omission:
# a band around a cell whose xi_mp sits below 3.84 would suggest an
# inference the project's own strength ruler does not license.

fig_df <- paths |>
  dplyr::filter(h <= H_FIG) |>
  dplyr::mutate(cell = factor(Q_LAB(q), levels = Q_LAB(Q_VALUES)))

# Same paths with the normalization held at production's denominator. Page 3
# only; it is the post-hoc decomposition drawn, and is labelled as such.
resc_df <- fig_df |>
  dplyr::mutate(point = point * unname(denom_ratio[as.character(q)]))

band_df <- fig_df |> dplyr::filter(q == SPEC$q)

irf_page <- function(vars, ncol, subtitle, df = fig_df, title = title_main) {
  plot_dimension_overlay(df, band_df, vars, Q_PALETTE, Q_LINETYPE,
                         H_FIG, ncol, title, subtitle)
}

title_main <- sprintf("Fatores dinamicos q em r = %d: producao com bandas, alternativas em ponto",
                      SPEC$r)

sub_common <- sprintf("%s x %s, +%dbp, amostra completa; bandas 68/90 sao da producao (q=%d), nboot=%d",
                      SPEC$instrument, SPEC$mp_var, SPEC$shock_bps, SPEC$q, SPEC$nboot)

pdf(file.path(OUT_DIR, "q_selection_paths.pdf"), width = 11, height = 7)
print(irf_page(FIG_VARS, ncol = 3, sub_common))
print(irf_page(FIG_EXTRA, ncol = 1,
               sprintf("%s x %s, +%dbp; bandas 68/90 da producao (q=%d)",
                       SPEC$instrument, SPEC$mp_var, SPEC$shock_bps, SPEC$q),
               title = "O bloco inconveniente: onde as celulas de q mais discordam"))
print(irf_page(c(FIG_VARS, FIG_EXTRA), ncol = 3,
               sprintf(paste("Alternativas multiplicadas por denom_ratio (%s / %s / %s em q=4/3/2);",
                             "as bandas continuam sendo as da producao"),
                       formatC(denom_ratio["4"], format = "f", digits = 3),
                       formatC(denom_ratio["3"], format = "f", digits = 3),
                       formatC(denom_ratio["2"], format = "f", digits = 3)),
               df = resc_df,
               title = "POS-HOC, nao pre-registrado: as mesmas trajetorias com a normalizacao mantida fixa"))
dev.off()

cat(sprintf("\nEscrito: %s/q_selection.{csv,md}, q_selection_paths.{csv,pdf}, q_selection_containment.csv\n",
            OUT_DIR))
cat("\n========== VEREDITO PRE-REGISTRADO ==========\n")
print(as.data.frame(verdict |>
                      dplyr::select(q, variable, share_in90, cor_path,
                                    rel_max_abs_dev, denom_ratio, veredito)),
      row.names = FALSE)
