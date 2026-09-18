# Validate finalist bootstraps and finalize the joint audited decision.

source("R/identification/spec_sweep.R")

out_dir <- "diagnostics/rq_block_dimension_audit/output"
bootstrap_dir <- file.path(out_dir, "bootstrap")
finalists <- readr::read_csv(file.path(out_dir, "bootstrap_finalists.csv"), show_col_types = FALSE)
joint <- readr::read_csv(file.path(out_dir, "joint_decision.csv"), show_col_types = FALSE)
ranking <- readr::read_csv(file.path(out_dir, "panel_dimension_ranking.csv"), show_col_types = FALSE)
panel_decisions <- readr::read_csv(file.path(out_dir, "panel_dimension_decisions.csv"), show_col_types = FALSE)
block_decisions <- readr::read_csv(file.path(out_dir, "block_decisions.csv"), show_col_types = FALSE)
contrasts <- readr::read_csv(file.path(out_dir, "block_contrasts.csv"), show_col_types = FALSE)

irf_files <- list.files(bootstrap_dir, pattern = "_irf\\.csv$", full.names = TRUE)
metadata_files <- list.files(bootstrap_dir, pattern = "_metadata\\.csv$", full.names = TRUE)
rds_files <- list.files(bootstrap_dir, pattern = "\\.rds$", full.names = TRUE)
if (length(irf_files) != nrow(finalists) || length(metadata_files) != nrow(finalists) ||
    length(rds_files) != nrow(finalists)) {
  stop("Every deduplicated finalist must have one IRF CSV, metadata CSV, and RDS.")
}

irfs <- dplyr::bind_rows(lapply(irf_files, readr::read_csv, show_col_types = FALSE))
metadata <- dplyr::bind_rows(lapply(metadata_files, readr::read_csv, show_col_types = FALSE))
if (nrow(metadata) != nrow(finalists) || anyDuplicated(metadata[c("variant", "r", "q")]) ||
    nrow(irfs) != nrow(finalists) * 5L * 49L ||
    anyDuplicated(irfs[c("variant", "r", "q", "variable", "h")]) ||
    any(metadata$nboot != 800L) || any(metadata$bootstrap_seed != 123L) ||
    any(metadata$bootstrap_failures != 0L) || any(!metadata$stable) ||
    any(metadata$max_companion_root >= 1) ||
    any(!is.finite(as.matrix(irfs[c("point", "lo68", "hi68", "lo90", "hi90")]))) ||
    any(irfs$lo68 > irfs$hi68) || any(irfs$lo90 > irfs$hi90)) {
  stop("The finalist bootstrap coverage, stability, failure, or band invariants did not pass.")
}

normalization <- irfs |>
  dplyr::filter(variable == "yield_6m", h == 0L)
if (nrow(normalization) != nrow(finalists) ||
    any(abs(normalization$point - 0.005) > 1e-12) ||
    any(abs(normalization$lo68 - 0.005) > 1e-12) ||
    any(abs(normalization$hi68 - 0.005) > 1e-12) ||
    any(abs(normalization$lo90 - 0.005) > 1e-12) ||
    any(abs(normalization$hi90 - 0.005) > 1e-12)) {
  stop("The finalist bootstraps do not preserve the +50 bp impact normalization.")
}

sign_rules <- tibble::tribble(
  ~variable, ~expected_sign,
  "yield_6m", 1,
  "yield_2y", 1,
  "yield_5y", 1,
  "asset_ibov", -1
)
bootstrap_gate <- irfs |>
  dplyr::filter(h <= 6L) |>
  dplyr::inner_join(sign_rules, by = "variable") |>
  dplyr::mutate(
    wrong_direction_90 = (expected_sign > 0 & hi90 < 0) |
      (expected_sign < 0 & lo90 > 0)
  ) |>
  dplyr::group_by(variant, r, q) |>
  dplyr::summarise(
    wrong_direction_90 = sum(wrong_direction_90),
    bootstrap_gate_pass = wrong_direction_90 == 0L,
    .groups = "drop"
  ) |>
  dplyr::left_join(
    metadata |>
      dplyr::select(variant, r, q, bootstrap_failures),
    by = c("variant", "r", "q")
  ) |>
  dplyr::mutate(bootstrap_gate_pass = bootstrap_gate_pass & bootstrap_failures == 0L)

final_panel_ranking <- ranking |>
  dplyr::filter(variant == joint$final_variant, admissible_full) |>
  dplyr::arrange(admissible_rank) |>
  dplyr::left_join(bootstrap_gate, by = c("variant", "r", "q"))
accepted <- final_panel_ranking |>
  dplyr::filter(!is.na(bootstrap_gate_pass), bootstrap_gate_pass) |>
  dplyr::slice(1)
if (nrow(accepted) != 1L) {
  next_required <- final_panel_ranking |>
    dplyr::filter(is.na(bootstrap_gate_pass)) |>
    dplyr::slice(1) |>
    dplyr::select(variant, r, q)
  readr::write_csv(next_required, file.path(out_dir, "additional_bootstrap_required.csv"))
  stop("No bootstrapped dimension of the final panel passed the finalist gate; run the next ranked cell.")
}

final_decision <- joint |>
  dplyr::mutate(
    point_selected_r = final_r,
    point_selected_q = final_q,
    accepted_r = accepted$r,
    accepted_q = accepted$q,
    bootstrap_fallback_used = accepted$r != final_r | accepted$q != final_q,
    accepted_rank = accepted$admissible_rank
  )
readr::write_csv(irfs, file.path(out_dir, "bootstrap_irfs.csv"))
readr::write_csv(metadata, file.path(out_dir, "bootstrap_metadata.csv"))
readr::write_csv(bootstrap_gate, file.path(out_dir, "bootstrap_gate.csv"))
readr::write_csv(final_decision, file.path(out_dir, "final_decision.csv"))

report <- c(
  "# Auditoria conjunta de painel e dimensões `(r,q)`",
  "",
  paste0("> Gerado em ", Sys.Date(), ". Rodada experimental isolada; não migra a produção nem altera o paper."),
  "",
  "## Decisão conjunta",
  "",
  md_table(final_decision),
  "",
  "A amostra completa decide. A janela pré-COVID apenas qualifica relevância, raiz e estabilidade das cinco IRFs curtas. O câmbio permanece canal `soft` e não é contado como erro de sinal.",
  "",
  "## Decisões dos blocos",
  "",
  md_table(block_decisions),
  "",
  "Cada bloco tem 32 contrastes pareados. A exclusão só vence um contraste se melhora ao menos quatro dos seis critérios e piora no máximo um; um bloco só é removido com pelo menos 24 vitórias da exclusão e no máximo oito da inclusão.",
  "",
  "## Células escolhidas por painel",
  "",
  md_table(panel_decisions |>
    dplyr::select(
      variant, removed_blocks, n_series, r, q, bll_r, bll_q,
      bll_distance_full, xi_mp, max_companion_root, correct_signs_full,
      xi_mp_pre_covid, max_companion_root_pre_covid, normalized_rmse
    ), digits = 4),
  "",
  "## Bootstrap finalista",
  "",
  md_table(metadata |>
    dplyr::left_join(bootstrap_gate, by = c("variant", "r", "q", "bootstrap_failures")), digits = 4),
  "",
  "Os finalistas usam 800 réplicas, semente 123 e bandas de 68%/90%. O gate exige zero falhas, raiz menor que um, normalização exata em +50 pb e nenhuma banda de 90% inteiramente no sentido oposto ao previsto para as três taxas e o Ibovespa em `h=0,...,6`.",
  "",
  "## Cobertura",
  "",
  paste0("- 64 painéis; 2.304 células full; 64 diagnósticos pré-COVID selecionados; ", nrow(contrasts), " contrastes pareados."),
  paste0("- ", nrow(finalists), " finalistas distintos, todos com 800 réplicas e zero falhas."),
  "- As 1.152 células na interseção com a grade anterior reproduzem `xi_mp` a `1e-10`.",
  "- Nenhum arquivo de produção ou do paper é produzido por estes scripts."
)
writeLines(report, file.path(out_dir, "audit_report.md"), useBytes = TRUE)
message(
  "Final audited decision: ", final_decision$final_variant, " (",
  final_decision$accepted_r, ",", final_decision$accepted_q, ")."
)
