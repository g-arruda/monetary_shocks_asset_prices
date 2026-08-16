# ===================================================================
# PIPELINE DO SDFM: painel -> fatores -> IRFs identificadas
# Encadeia estimate_dfm() (factor_estimation.R) e compute_irf_dfm()
# (impulse_response.R) sob a especificação de produção.
# Requer: R/modeling/factor_estimation.R, R/modeling/impulse_response.R,
#         R/modeling/production_spec.R e, no ramo nongaussian,
#         R/identification/nongaussian_branch.R.
# ===================================================================

#' Estimate the DFM and its impulse responses
#'
#' Reads the processed panel, infers transformation codes, resolves the
#' monetary-policy column, estimates the factor model and returns the
#' identified IRFs with wild-bootstrap bands.
#'
#' Only the `"proxy"` branch runs in production. The het branch was archived on
#' 2026-07-26 (empirically rejected 2026-07-16); to revive it, source
#' `arquivo/R/identification/het_{shock_extraction,primary}.R` first. The
#' non-Gaussian branch (GMR 2017 PML-ICA) is live — see
#' `script/model_nongaussian.R`.
#'
#' @param spec Production specification; defaults to `production_spec()` and
#'   supplies the default of every argument below.
#' @param data_path Processed panel CSV.
#' @param instrument_path Monthly production instrument CSV.
#' @param r Number of static factors.
#' @param q Number of dynamic shocks.
#' @param p Factor-VAR lag order.
#' @param h Maximum impulse-response horizon.
#' @param nboot Number of wild-bootstrap draws.
#' @param bootstrap_seed Bootstrap seed.
#' @param mp_var Monetary-policy normalization variable, as a column name or a
#'   column index.
#' @param shock_size_bps Impact normalization in basis points.
#' @param tcode Optional transformation-code vector; inferred from the column
#'   names when NULL.
#' @param ci_levels Confidence levels.
#' @param identification Identification branch.
#' @param het_weight Weighting scheme for the archived heteroskedastic branch.
#' @param ng_distri Non-Gaussian density specification.
#' @param ng_starts Number of non-Gaussian optimization starts.
#' @param ng_boot_starts Number of starts in each non-Gaussian bootstrap draw.
#'
#' @return List with the fitted DFM, IRFs, panel, transformations, and
#'   normalization.
#'
#' @examples
#' res <- main_sdfm(r = 5L, q = 5L, p = 6, shock_size_bps = 50,
#'                  mp_var = "yield_6m", nboot = 0)
main_sdfm <- function(spec = production_spec(),
                      data_path = spec$data_path,
                      instrument_path = spec$legacy_instrument_path,
                      r = spec$r, q = spec$q, p = spec$p,
                      h = spec$horizon, nboot = spec$nboot,
                      bootstrap_seed = spec$bootstrap_seed,
                      mp_var = spec$mp_var, shock_size_bps = spec$shock_bps,
                      tcode = NULL, ci_levels = spec$ci_levels,
                      identification = c("proxy", "het", "nongaussian"),
                      het_weight = "optimal",
                      ng_distri = NULL, ng_starts = 30L, ng_boot_starts = 3L) {

  # Ramo het (Rigobon 2003, regimes mensais Copom/nao-Copom sobre as
  # inovacoes do factor-VAR): implementado e validado, mas REPROVADO
  # pelos gates de viabilidade em todo o grid (2026-07-16) — o placebo
  # de permutacao nao distingue os labels do calendario (p_perm
  # 0.26-0.86) e a proporcionalidade Sigma_C ~ Sigma_NC nunca e
  # rejeitada, e o mesmo para regimes de episodio (BPSS 2021). Codigo e
  # artefatos arquivados em 2026-07-26; ver registro/historico_decisoes.md
  # secao 1.2. Producao segue "proxy" (z_jk_bs_purif).
  identification <- match.arg(identification)

  # Load and prepare data (preservar ref.date para alinhamento)
  raw_data <- readr::read_csv(data_path) |>
    tidyr::drop_na()

  dates <- as.Date(raw_data$ref.date)

  data <- raw_data |>
    dplyr::select(-ref.date) |>
    as.matrix()

  # Definir tcodes por nome de variável se não fornecido
  if (is.null(tcode)) {
    tcode <- infer_tcode_from_varnames(colnames(data))
  }

  # Definir variável de política monetária para normalização do choque
  if (is.character(mp_var)) {
    mpind <- match(mp_var, colnames(data))
    if (is.na(mpind)) {
      stop("Variavel de politica monetaria '", mp_var, "' nao encontrada nos dados")
    }
  } else if (is.numeric(mp_var) && length(mp_var) == 1) {
    mpind <- as.integer(mp_var)
    if (mpind < 1 || mpind > ncol(data)) {
      stop("Indice mp_var fora do intervalo de colunas do painel")
    }
  } else {
    stop("mp_var deve ser nome (character) ou indice (numeric) de coluna")
  }

  # `yield_6m` is stored in decimal proportion (0.0975 = 9.75%); a +50bp
  # shock in proportion is therefore 0.005, not 0.5. The earlier convention
  # (`/ 100`) implicitly normalized to +5000bp and was corrected on
  # 2026-05-07. See `registro/justificativa_uso_yield-6m.md`.
  normalize_value <- shock_size_bps / 10000

  # Instrumento so no ramo proxy; no ramo het o painel fica integral
  # (sem trimming de alinhamento) e a identificacao vem dos regimes.
  # No ramo nongaussian o instrumento entra apenas como ROTULADOR da coluna
  # monetária — a identificação vem da não-gaussianidade das inovações.
  instrument <- NULL
  if (identification %in% c("proxy", "nongaussian")) {
    instrument <- readr::read_csv(instrument_path)
  }

  # Estimate SDFM com datas e instrumento para alinhamento temporal
  # apply_kilian = TRUE: computa coeficientes corrigidos para o DGP do bootstrap
  # O ponto estimado usa VAR OLS (sem Kilian), fiel ao DFMest_BLL.m
  dfm_results <- estimate_dfm(data, r, q, p, dates = dates, instrument = instrument,
                              apply_kilian = TRUE)

  regime_labels <- NULL
  if (identification == "het") {
    regimes <- build_monthly_regimes(month_range = range(dates))
    regime_labels <- align_regimes_to_eta(dfm_results$dates, p, regimes)
  }

  # Validate results
  validation <- validate_dfm_results(dfm_results)
  if (length(validation$missing_components) > 0) {
    warning("Missing DFM components: ", paste(validation$missing_components, collapse = ", "))
  }

  # Compute IRFs with wild bootstrap (instrumento e datas já embutidos no dfm_results)
  irf_results <- compute_irf_dfm(
    dfm_results,
    h = h,
    nboot = nboot,
    bootstrap_seed = bootstrap_seed,
    mpind = mpind,
    normalize_value = normalize_value,
    tcode = tcode,
    ci_levels = ci_levels,
    var_names = colnames(data),
    identification = identification,
    regime_labels = regime_labels,
    het_weight = het_weight,
    ng_distri = ng_distri,
    ng_starts = ng_starts,
    ng_boot_starts = ng_boot_starts
  )

  list(
    model = dfm_results,
    irfs = irf_results,
    data = data,
    tcode = tcode,
    mpind = mpind,
    normalize_value = normalize_value,
    identification = identification
  )
}
