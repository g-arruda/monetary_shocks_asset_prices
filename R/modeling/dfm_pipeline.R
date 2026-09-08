# ===================================================================
# PIPELINE DO SDFM: painel -> fatores -> IRFs identificadas
# Encadeia estimate_dfm() (factor_estimation.R) e compute_irf_dfm()
# (impulse_response.R) sob a especificação de produção.
# Requer: R/modeling/factor_estimation.R, R/modeling/impulse_response.R,
#         R/modeling/production_spec.R.
# ===================================================================

#' Estimate the DFM and its impulse responses
#'
#' Reads the processed panel, infers transformation codes, resolves the
#' monetary-policy column, estimates the factor model and returns the
#' identified IRFs with wild-bootstrap bands.
#'
#' `"proxy"` (external instrument) is the only identification branch. The
#' heteroskedasticity and non-Gaussian branches were abandoned on 2026-08-17.
#' Their negative results remain documented under `arquivo/`.
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
#' @param identification Identification branch; `"proxy"` is the only one.
#'
#' @return List with the fitted DFM, IRFs, panel, transformations, and
#'   normalization.
#'
#' @examples
#' res <- main_sdfm(r = 5L, q = 5L, p = 4, shock_size_bps = 50,
#'                  mp_var = "yield_6m", nboot = 0)
main_sdfm <- function(spec = production_spec(),
                      data_path = spec$data_path,
                      instrument_path = spec$legacy_instrument_path,
                      r = spec$r, q = spec$q, p = spec$p,
                      h = spec$horizon, nboot = spec$nboot,
                      bootstrap_seed = spec$bootstrap_seed,
                      mp_var = spec$mp_var, shock_size_bps = spec$shock_bps,
                      tcode = NULL, ci_levels = spec$ci_levels,
                      identification = "proxy") {

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

  instrument <- readr::read_csv(instrument_path)

  # Estimate SDFM com datas e instrumento para alinhamento temporal
  # apply_kilian = TRUE: computa coeficientes corrigidos para o DGP do bootstrap
  # O ponto estimado usa VAR OLS (sem Kilian), fiel ao DFMest_BLL.m
  dfm_results <- estimate_dfm(data, r, q, p, dates = dates, instrument = instrument,
                              apply_kilian = TRUE)

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
    identification = identification
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
