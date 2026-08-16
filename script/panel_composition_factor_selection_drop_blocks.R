# BLL Bai-Ng and Amengual-Watson factor selection for factorial block removals.
# This script writes only to the isolated experimental panel output directory.

rm(list = ls())

library(readr)
library(dplyr)

source("R/data_download/panel_candidates.R")
source("R/preprocessing/panel_candidates.R")
source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/experimental_panel.R")
source("R/identification/spec_sweep.R")

P_LAGS <- 6L
MAX_R <- 20L
MP_VAR <- "yield_6m"
OUT_DIR <- "output/panel_experimental/rq_grid_drop_blocks/factor_selection"
EXPECTED_DATES <- seq(as.Date("2013-01-01"), as.Date("2025-09-01"), by = "month")
SAMPLES <- list(
  full = as.Date(c("2013-01-01", "2025-09-01")),
  pre_covid = as.Date(c("2013-01-01", "2019-12-01"))
)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

base_data <- readr::read_csv("data/processed/data_log_deseasonalized_base_106.csv", show_col_types = FALSE)
if (!identical(as.Date(base_data$ref.date), EXPECTED_DATES) || anyNA(base_data) ||
    any(!is.finite(as.matrix(base_data[, -1])))) {
  stop("The canonical processed panel must contain exactly 153 complete finite months.")
}
base_dates <- as.Date(base_data$ref.date)
base_mat <- base_data |>
  dplyr::select(-ref.date) |>
  as.matrix()
if (ncol(base_mat) != 106L) {
  stop("The canonical panel must contain exactly 106 series, not ", ncol(base_mat), ".")
}

experimental <- build_factorial_drop_block_panels(base_mat, EXPECTED_DATES, MP_VAR)
panels <- experimental$panels
variant_manifest <- experimental$variant_manifest
if (nrow(variant_manifest) != 64L) {
  stop("The factorial block-removal design must contain exactly 64 panels.")
}

selection_rows <- list()
bai_ng_rows <- list()
aw_rows <- list()
row_index <- 0L
bai_ng_index <- 0L
aw_index <- 0L

for (variant in variant_manifest$variant) {
  panel <- panels[[variant]]$matrix
  for (sample_name in names(SAMPLES)) {
    window <- SAMPLES[[sample_name]]
    in_window <- base_dates >= window[1] & base_dates <= window[2]
    data_sub <- panel[in_window, , drop = FALSE]
    dates_sub <- base_dates[in_window]
    if (nrow(data_sub) <= MAX_R || any(!is.finite(data_sub)) || anyDuplicated(dates_sub)) {
      stop("Invalid sample for factor selection: ", variant, " / ", sample_name, ".")
    }

    bai_ng <- bai_ng_criteria(data_sub, max_r = MAX_R, apply_bll = TRUE)
    r_ic2 <- bai_ng$r_hat$IC2
    aw <- amengual_watson(
      data_sub,
      r = r_ic2,
      p = P_LAGS,
      max_q = r_ic2,
      apply_bll = TRUE
    )
    if (aw$q_hat > r_ic2 || !is.finite(aw$q_hat)) {
      stop("Amengual-Watson selected an invalid q in ", variant, " / ", sample_name, ".")
    }

    row_index <- row_index + 1L
    selection_rows[[row_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      n_series = ncol(data_sub),
      n_months = nrow(data_sub),
      r_ic1 = bai_ng$r_hat$IC1,
      r_ic2 = r_ic2,
      r_ic3 = bai_ng$r_hat$IC3,
      r_ic3_at_upper_bound = bai_ng$r_hat$IC3 == MAX_R,
      q_aw_ic2 = aw$q_hat,
      p_aw = P_LAGS
    )

    bai_ng_index <- bai_ng_index + 1L
    bai_ng_rows[[bai_ng_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      r = seq_len(MAX_R),
      ic1 = bai_ng$criteria$IC1,
      ic2 = bai_ng$criteria$IC2,
      ic3 = bai_ng$criteria$IC3
    )
    aw_index <- aw_index + 1L
    aw_rows[[aw_index]] <- tibble::tibble(
      variant = variant,
      sample = sample_name,
      r_ic2 = r_ic2,
      q = seq_len(r_ic2),
      aw_ic2 = aw$aw
    )
  }
}

selection <- dplyr::bind_rows(selection_rows) |>
  dplyr::arrange(variant, sample)
bai_ng_grid <- dplyr::bind_rows(bai_ng_rows) |>
  dplyr::arrange(variant, sample, r)
aw_grid <- dplyr::bind_rows(aw_rows) |>
  dplyr::arrange(variant, sample, q)

if (nrow(selection) != 128L || anyNA(selection) || any(selection$q_aw_ic2 > selection$r_ic2) ||
    any(!is.finite(as.matrix(selection[, c("n_series", "n_months", "r_ic1", "r_ic2", "r_ic3", "q_aw_ic2", "p_aw")]))) ||
    anyDuplicated(selection[, c("variant", "sample")]) || nrow(bai_ng_grid) != 128L * MAX_R ||
    any(!is.finite(as.matrix(bai_ng_grid[, c("ic1", "ic2", "ic3")]))) ||
    any(!is.finite(aw_grid$aw_ic2))) {
  stop("Factor-selection outputs are incomplete or invalid.")
}

single_block <- selection |>
  dplyr::filter(variant %in% c(
    "conjunto_completo_sem_duplicatas", "drop_fiscal", "drop_setor_externo",
    "drop_expectativas", "drop_eua", "drop_credito", "drop_imoveis", "baseline"
  )) |>
  dplyr::left_join(
    variant_manifest |>
      dplyr::select(variant, removed_blocks, n_blocks_removed),
    by = "variant"
  ) |>
  dplyr::select(variant, removed_blocks, n_blocks_removed, dplyr::everything()) |>
  dplyr::arrange(sample, n_blocks_removed, variant)
summary <- selection |>
  dplyr::group_by(sample) |>
  dplyr::summarise(
    panels = dplyr::n(),
    r_ic1_min = min(r_ic1),
    r_ic1_max = max(r_ic1),
    r_ic2_min = min(r_ic2),
    r_ic2_max = max(r_ic2),
    r_ic3_at_upper_bound = sum(r_ic3_at_upper_bound),
    q_aw_min = min(q_aw_ic2),
    q_aw_max = max(q_aw_ic2),
    .groups = "drop"
  )

readr::write_csv(selection, file.path(OUT_DIR, "factor_selection_cells.csv"))
readr::write_csv(bai_ng_grid, file.path(OUT_DIR, "bai_ng_bll_criteria.csv"))
readr::write_csv(aw_grid, file.path(OUT_DIR, "amengual_watson_criteria.csv"))
readr::write_csv(single_block, file.path(OUT_DIR, "single_block_exclusions.csv"))

report <- c(
  "# Seleção BLL de fatores na grade fatorial de remoção de blocos",
  "",
  paste0(
    "> Gerado por `script/panel_composition_factor_selection_drop_blocks.R` em ", Sys.Date(),
    ". Rodada experimental isolada; não estima ξ_mp, bootstrap ou IRFs."
  ),
  "",
  "## Regra aplicada",
  "",
  "Para cada um dos 64 painéis sem `juros_cdi` e `asset_mlcx`, nas duas amostras, Bai--Ng é calculado na padronização BLL sobre primeiras diferenças, com `r ∈ {1,...,20}`. Reportam-se IC1, IC2 e IC3; por convenção do pipeline, `r_ic2` alimenta Amengual--Watson. Amengual--Watson usa o mesmo BLL, VAR com `p=6` e minimiza IC2 sobre `q ∈ {1,...,r_ic2}`. Logo o par automático reportado é `(r_ic2, q_aw_ic2)` e sempre respeita `q ≤ r`.",
  "",
  "IC3 é exibido, mas não é usado para selecionar porque bate no limite superior `r=20` em todas as células; esse é um resultado de fronteira, não uma recomendação de 20 fatores.",
  "",
  "## Cobertura",
  "",
  md_table(summary),
  "",
  "## Exclusões isoladas e extremos",
  "",
  md_table(single_block),
  "",
  "## Todas as combinações",
  "",
  "### Amostra cheia",
  "",
  md_table(dplyr::filter(selection, sample == "full")),
  "",
  "### Amostra pré-COVID",
  "",
  md_table(dplyr::filter(selection, sample == "pre_covid")),
  "",
  "## Leitura delimitada",
  "",
  "Os critérios descrevem a dimensão estatística que melhor equilibra ajuste e penalidade dentro de cada painel. Não escolhem a especificação de produção sozinhos: a escolha também precisa respeitar a estabilidade do VAR, a identificação proxy e a inferência. Em particular, não se deve substituir uma seleção BLL por uma célula de ξ_mp máximo.",
  "",
  "## Arquivos",
  "",
  "- `factor_selection_cells.csv`: uma seleção por painel e amostra.",
  "- `bai_ng_bll_criteria.csv`: as três superfícies Bai--Ng completas, `r=1,...,20`.",
  "- `amengual_watson_criteria.csv`: o IC2 de Amengual--Watson para cada `q` admissível.",
  "- `single_block_exclusions.csv`: recorte da união sem exclusões, das seis exclusões unitárias e do baseline."
)
writeLines(report, file.path(OUT_DIR, "factor_selection_report.md"), useBytes = TRUE)

message("Factor-selection report completed in ", OUT_DIR, ".")
