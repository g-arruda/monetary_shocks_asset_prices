# ===================================================================
# Number of factors on the correlation-pruned panel: Bai-Ng, Ahn-Horenstein,
# Alessi-Barigozzi-Capasso and Amengual-Watson, current panel against pruned.
# Suggestion 3/5 of the advisor's e-mail of 2026-09-04 (item B3 of
# registro/pendencias.md): redo the (r, q) selection on the pruned panel and
# check whether the divergence from Bai-Ng shrinks. The author added whether
# the Amengual-Watson q moves too.
#
# THE PANELS come from output/panel_experimental/poda_correlacao/
# pruning_manifest.csv (script/panel_pruning.R): the production panel minus
# the series each configuration drops. The principal one is complete linkage
# at 0.90. Every estimator reads the BLL object production reads, exactly as
# arquivo/script/factor_selection_alt.R does; self-test (a) reproduces that
# round on the current panel.
#
# THE READING RULE IS PRE-REGISTERED (plan of 2026-09-10), fixed before any
# estimate on a pruned panel was looked at:
#   R1, divergence from Bai-Ng: D = |ER - IC2| + |GR - IC2| + |ABC_IC1 - IC2|;
#       pruned below current -> "diminui", equal -> "não muda", above ->
#       "aumenta";
#   R2, underestimation by within-block correlation: the moves of r_IC2 and
#       of q_AW(r = 5) from current to pruned. "inalterada" if both stay,
#       "consistente" if neither falls and one rises, "contrária" if neither
#       rises and one falls, "mista" otherwise.
# Only the principal pruned panel decides. IC1, IC3, ABC_IC2, the permutation
# distribution, Amengual-Watson at other r or with standardized residuals and
# the sensitivity panels are reported and decide nothing. No xi_mp and no
# IRF: the selection stays blind to instrument strength (author decision,
# after the advisor's specification-search caution).
#
# Outputs: output/factors/factor_selection_pruned.{md,pdf}
#          output/factors/factor_selection_pruned_summary.csv
#          output/factors/factor_selection_pruned_aw.csv
# ===================================================================

source("R/modeling/factor_estimation.R")
source("R/modeling/factor_selection.R")
source("R/identification/spec_sweep.R")

PANEL_PATH    <- "data/processed/data_log_deseasonalized.csv"
MANIFEST_PATH <- "output/panel_experimental/poda_correlacao/pruning_manifest.csv"
ALT_PATH      <- "output/factors/factor_selection_alt_summary.csv"
OUT_DIR       <- "output/factors"
SAMPLE        <- as.Date(c("2012-03-01", "2025-12-01"))
R_FACTORS     <- 5L    # the production r
P_LAGS        <- 4L
MP_VAR        <- "yield_6m"
KMAX          <- 20L   # the grid of the production Bai-Ng surface
N_PERM        <- 100L
PERM_SEED     <- 123L  # the seed stream of arquivo/script/factor_selection_alt.R
AW_R          <- 5L    # the production r, where the q comparison is read
AW_R_GRID     <- 4:8   # spans the (5,2), (7,5) and (8,8) cells of the e-mail
PRODUCTION_PANEL <-
  "drop_setor_externo__eua__credito__imoveis_fiscal_expectations"


# ---- Panels ------------------------------------------------------------

panel <- readr::read_csv(PANEL_PATH, show_col_types = FALSE) |>
  dplyr::filter(ref.date >= SAMPLE[1], ref.date <= SAMPLE[2]) |>
  dplyr::select(-ref.date) |>
  as.matrix()

manifest <- readr::read_csv(MANIFEST_PATH, show_col_types = FALSE)
configs <- manifest |>
  dplyr::distinct(config, principal) |>
  dplyr::arrange(dplyr::desc(principal), config)
principal_config <- configs$config[configs$principal]

panels <- c(
  list(atual = panel),
  purrr::map(purrr::set_names(configs$config), function(config_name) {
    rows <- dplyr::filter(manifest, config == config_name)
    panel[, rows$series[rows$kept], drop = FALSE]
  })
)

# (b) every configuration of the manifest describes this production panel
same_panel <- manifest |>
  dplyr::summarise(ok = identical(series, colnames(panel)), .by = config)
stopifnot(
  all(same_panel$ok),
  MP_VAR %in% colnames(panels[[principal_config]])
)


# ---- The battery, panel by panel ---------------------------------------

results <- purrr::imap(panels, function(X, panel_name) {
  yy <- estimate_static_factors(X, r = R_FACTORS)$yy
  bai_ng <- bai_ng_criteria(X, max_r = KMAX, apply_bll = TRUE)
  ah_fit <- ahn_horenstein(yy, KMAX)

  # The first draw of that seed stream is the pre-registered primary nesting
  # order
  set.seed(PERM_SEED)
  permutations <- replicate(N_PERM, sample.int(ncol(X)), simplify = FALSE)
  abc_ic1 <- abc_criterion(yy, KMAX, "IC1", permutations[[1]])
  abc_ic2 <- abc_criterion(yy, KMAX, "IC2", permutations[[1]])

  # (c) log V(k) of `yy` plus the Bai-Ng penalties is this panel's Bai-Ng
  #     surface
  e_NT <- (ncol(yy) + nrow(yy)) / (ncol(yy) * nrow(yy))
  min_dim <- min(dim(yy))
  penalty <- c(e_NT * log(1 / e_NT), e_NT * log(min_dim), log(min_dim) / min_dim)
  surface_gap <- max(abs(
    log(ah_fit$surface$V[-1]) +
      outer(seq_len(KMAX), penalty) -
      do.call(cbind, bai_ng$criteria)
  ))

  aw <- tidyr::expand_grid(
    r = sort(unique(c(AW_R_GRID, bai_ng$r_hat$IC2))),
    standardize_resid = c(FALSE, TRUE)
  ) |>
    dplyr::mutate(
      fit = purrr::map2(r, standardize_resid, function(r, standardize) {
        amengual_watson(
          X,
          r = r,
          p = P_LAGS,
          apply_bll = TRUE,
          standardize_resid = standardize
        )
      }),
      q_hat = purrr::map_int(fit, "q_hat"),
      surface = purrr::map(fit, function(aw_fit) {
        tibble::tibble(q = seq_along(aw_fit$aw), aw_ic2 = aw_fit$aw)
      })
    ) |>
    dplyr::select(-fit) |>
    tidyr::unnest(surface) |>
    dplyr::mutate(painel = panel_name, escolhido = q == q_hat, .before = 1)

  q_aw5 <- aw$q_hat[aw$r == AW_R & !aw$standardize_resid][1]
  q_aw5_std <- aw$q_hat[aw$r == AW_R & aw$standardize_resid][1]
  q_awic2 <- aw$q_hat[aw$r == bai_ng$r_hat$IC2 & !aw$standardize_resid][1]

  estimates <- tibble::tibble(
    painel = panel_name,
    n_series = ncol(X),
    codigo = c(
      "IC1", "IC2", "IC3", "ER", "GR", "ABC1", "ABC2", "AW5", "AW5_std",
      "AWIC2"
    ),
    estimador = c(
      "Bai-Ng IC1",
      "Bai-Ng IC2",
      "Bai-Ng IC3",
      "AH ER",
      "AH GR",
      "ABC IC*1",
      "ABC IC*2",
      "Amengual-Watson q, r = 5",
      "Amengual-Watson q, r = 5, resíduos padronizados",
      "Amengual-Watson q, r = r̂_IC2"
    ),
    r_hat = c(
      bai_ng$r_hat$IC1,
      bai_ng$r_hat$IC2,
      bai_ng$r_hat$IC3,
      ah_fit$k_er,
      ah_fit$k_gr,
      abc_ic1$r_hat,
      abc_ic2$r_hat,
      q_aw5,
      q_aw5_std,
      q_awic2
    ),
    no_veredito = c(
      FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE
    )
  )

  permutation_counts <- if (panel_name %in% c("atual", principal_config)) {
    purrr::map(permutations, function(permutation) {
      tibble::tibble(
        IC1 = abc_criterion(yy, KMAX, "IC1", permutation)$r_hat,
        IC2 = abc_criterion(yy, KMAX, "IC2", permutation)$r_hat
      )
    }) |>
      dplyr::bind_rows() |>
      tidyr::pivot_longer(
        dplyr::everything(),
        names_to = "penalidade",
        values_to = "r_hat"
      ) |>
      dplyr::count(penalidade, r_hat) |>
      dplyr::mutate(painel = panel_name, .before = 1)
  }

  list(
    estimates = estimates,
    aw = aw,
    surface = tibble::tibble(
      painel = panel_name,
      k = seq_len(KMAX),
      ER = ah_fit$surface$ER[-1],
      GR = ah_fit$surface$GR[-1],
      IC1 = bai_ng$criteria$IC1,
      IC2 = bai_ng$criteria$IC2,
      IC3 = bai_ng$criteria$IC3
    ),
    abc_intervals = dplyr::bind_rows(
      `IC*1` = abc_ic1$intervals,
      `IC*2` = abc_ic2$intervals,
      .id = "penalidade"
    ) |>
      dplyr::mutate(painel = panel_name, .before = 1),
    permutation_counts = permutation_counts,
    surface_gap = surface_gap
  )
})

estimates <- dplyr::bind_rows(purrr::map(results, "estimates"))
aw_tbl <- dplyr::bind_rows(purrr::map(results, "aw"))
surfaces <- dplyr::bind_rows(purrr::map(results, "surface"))
abc_intervals <- dplyr::bind_rows(purrr::map(results, "abc_intervals"))
permutation_counts <- dplyr::bind_rows(purrr::map(results, "permutation_counts"))
surface_gap <- max(purrr::map_dbl(results, "surface_gap"))


# ---- Self-tests --------------------------------------------------------

# (a) on the current panel the battery is the round of 2026-09-10
alt_round <- readr::read_csv(ALT_PATH, show_col_types = FALSE) |>
  dplyr::filter(
    variante %in% c("produção (BLL)", "Teorema 1", "permutação principal")
  ) |>
  dplyr::select(estimador, r_alt = r_hat)
check_a <- estimates |>
  dplyr::filter(painel == "atual") |>
  dplyr::inner_join(alt_round, by = "estimador")
stopifnot(
  nrow(check_a) == 7L,
  all(check_a$r_hat == check_a$r_alt),
  surface_gap < 1e-10
)

self_tests <- tibble::tibble(
  teste = c(
    paste(
      "(a) painel atual contra factor_selection_alt_summary.csv:",
      "estatísticas iguais"
    ),
    "(b) configurações do manifesto que descrevem este painel de produção",
    paste(
      "(c) log V(k) + penalidades contra bai_ng_criteria(apply_bll = TRUE),",
      "pior painel"
    )
  ),
  valor = c(sum(check_a$r_hat == check_a$r_alt), sum(same_panel$ok), surface_gap),
  criterio = c("= 7 de 7", sprintf("= %d", nrow(configs)), "< 1e-10")
)


# ---- The pre-registered reading ------------------------------------------

readings <- estimates |>
  dplyr::select(painel, n_series, codigo, r_hat) |>
  tidyr::pivot_wider(names_from = codigo, values_from = r_hat) |>
  dplyr::mutate(
    D = abs(ER - IC2) + abs(GR - IC2) + abs(ABC1 - IC2),
    d_r = IC2 - IC2[painel == "atual"],
    d_q = AW5 - AW5[painel == "atual"],
    R1 = dplyr::case_when(
      painel == "atual" ~ "referência",
      D < D[painel == "atual"] ~ "diminui",
      D == D[painel == "atual"] ~ "não muda",
      .default = "aumenta"
    ),
    R2 = dplyr::case_when(
      painel == "atual" ~ "referência",
      d_r == 0 & d_q == 0 ~ "inalterada",
      d_r >= 0 & d_q >= 0 ~ "consistente",
      d_r <= 0 & d_q <= 0 ~ "contrária",
      .default = "mista"
    ),
    decide = painel == principal_config
  )

current <- dplyr::filter(readings, painel == "atual")
verdict <- dplyr::filter(readings, decide)

readr::write_csv(
  readings,
  file.path(OUT_DIR, "factor_selection_pruned_summary.csv")
)
readr::write_csv(aw_tbl, file.path(OUT_DIR, "factor_selection_pruned_aw.csv"))


# ---- Report ----------------------------------------------------------

panels_tbl <- manifest |>
  dplyr::group_by(config, principal) |>
  dplyr::summarise(
    n_series = sum(kept),
    descartadas = paste(series[!kept], collapse = ", "),
    .groups = "drop"
  ) |>
  dplyr::arrange(dplyr::desc(principal), config)

aw_wide <- aw_tbl |>
  dplyr::distinct(painel, standardize_resid, r, q_hat) |>
  dplyr::mutate(
    convencao = dplyr::if_else(
      standardize_resid,
      "residuos_padronizados",
      "projeto"
    )
  ) |>
  tidyr::pivot_wider(
    id_cols = c(painel, convencao),
    names_from = r,
    values_from = q_hat,
    names_prefix = "r=",
    names_sort = TRUE
  ) |>
  dplyr::arrange(convencao != "projeto", match(painel, names(panels)))

aw_r5 <- aw_tbl |>
  dplyr::filter(
    r == AW_R,
    !standardize_resid,
    painel %in% c("atual", principal_config)
  ) |>
  tidyr::pivot_wider(id_cols = q, names_from = painel, values_from = aw_ic2)

surface_wide <- surfaces |>
  dplyr::filter(painel %in% c("atual", principal_config), k <= 10) |>
  dplyr::mutate(
    painel = dplyr::if_else(painel == "atual", "atual", "podado")
  ) |>
  tidyr::pivot_wider(
    id_cols = k,
    names_from = painel,
    values_from = c(ER, GR, IC2)
  )

permutation_wide <- permutation_counts |>
  tidyr::pivot_wider(names_from = painel, values_from = n, values_fill = 0L) |>
  dplyr::arrange(penalidade, r_hat)

sections <- c(
  paste(
    "# Número de fatores no painel podado por correlação: Bai-Ng,",
    "Ahn-Horenstein, ABC e Amengual-Watson"
  ),
  "",
  sprintf(
    "Gerado por `script/factor_selection_pruned.R` em %s.",
    format(Sys.Date(), "%Y-%m-%d")
  ),
  paste(
    "**Corpo gerado — não escrever prosa aqui.** A leitura vive em",
    "`notas/2026-09-10_poda_correlacao_painel.md`."
  ),
  "",
  "## Painéis",
  "",
  sprintf(
    paste(
      "Painel atual: produção `%s`, %s a %s, %d séries. Os podados saem de",
      "`%s` (`script/panel_pruning.R`). Todos os estimadores leem o objeto",
      "BLL da produção, primeiras diferenças padronizadas (T = %d). Grade",
      "k = 1..%d. ABC: c ∈ (0, 5] com passo 0,01 e subamostras aninhadas",
      "n_j = ⌊3N/4⌋..N numa permutação fixa (seed %d). Amengual-Watson BLL",
      "com p = %d."
    ),
    PRODUCTION_PANEL,
    SAMPLE[1],
    SAMPLE[2],
    ncol(panel),
    MANIFEST_PATH,
    nrow(panel) - 1,
    KMAX,
    PERM_SEED,
    P_LAGS
  ),
  "",
  md_table(as.data.frame(panels_tbl)),
  "",
  "## Auto-testes",
  "",
  md_table(as.data.frame(self_tests), digits = 3),
  "",
  "## Regra de leitura pré-registrada",
  "",
  paste(
    "**R1, divergência em relação a Bai-Ng:** D = |ER − IC2| + |GR − IC2| +",
    "|ABC-IC*1 − IC2|; podado abaixo do atual → *diminui*; igual → *não",
    "muda*; acima → *aumenta*."
  ),
  "",
  paste(
    "**R2, subestimação por correlação intra-bloco:** direção de r̂_IC2 e de",
    "q̂_AW(r = 5) do painel atual para o podado; *inalterada* se os dois",
    "ficam, *consistente* se nenhum cai e ao menos um sobe, *contrária* se",
    "nenhum sobe e ao menos um cai, *mista* no resto."
  ),
  "",
  sprintf(
    "Só o painel `%s` decide; os demais são sensibilidade.",
    principal_config
  ),
  "",
  "## Resultado",
  "",
  paste(
    "IC1-IC3: Bai-Ng BLL. ER, GR: Ahn-Horenstein, Teorema 1, kmax = 20.",
    "ABC1, ABC2: IC*1 e IC*2 na permutação principal. AW5: q̂ de",
    "Amengual-Watson em r = 5; AW5_std: o mesmo com os resíduos padronizados",
    "coluna a coluna (convenção do MATLAB de Stock-Watson); AWIC2: em",
    "r = r̂_IC2 do painel."
  ),
  "",
  md_table(as.data.frame(dplyr::select(readings, -decide))),
  "",
  sprintf(
    paste(
      "**Vereditos no painel principal `%s` (N = %d): R1 = %s** (D = %d",
      "contra %d no atual); **R2 = %s** (r̂_IC2 %d → %d; q̂_AW(r = 5)",
      "%d → %d)."
    ),
    principal_config,
    verdict$n_series,
    verdict$R1,
    verdict$D,
    current$D,
    verdict$R2,
    current$IC2,
    verdict$IC2,
    current$AW5,
    verdict$AW5
  ),
  "",
  "## Amengual-Watson: q̂ por r",
  "",
  paste(
    "`projeto` é o padrão de `amengual_watson()`; `residuos_padronizados`",
    "padroniza os resíduos do VAR coluna a coluna antes do Bai-Ng do 2º",
    "estágio, como `factor_estimation_ls.m`."
  ),
  "",
  md_table(as.data.frame(aw_wide)),
  "",
  sprintf(
    "### Critério IC2 de Amengual-Watson em r = %d, convenção do projeto",
    AW_R
  ),
  "",
  md_table(as.data.frame(aw_r5), digits = 6),
  "",
  "## ABC: intervalos de estabilidade",
  "",
  paste(
    "Intervalo = sequência de c consecutivos com S_c = 0 e o mesmo r̂ na",
    "amostra cheia; o escolhido é o primeiro com r̂ < 20. `n_grid` é o",
    "número de pontos da grade no intervalo."
  ),
  "",
  md_table(as.data.frame(
    dplyr::filter(abc_intervals, painel %in% c("atual", principal_config))
  )),
  "",
  sprintf(
    "### Sensibilidade à ordem das colunas: %d permutações do mesmo fluxo de seed",
    N_PERM
  ),
  "",
  md_table(as.data.frame(permutation_wide)),
  "",
  "## Superfícies ER, GR e IC2, k = 1..10",
  "",
  md_table(as.data.frame(surface_wide), digits = 5),
  "",
  "Figura em `factor_selection_pruned.pdf`."
)

writeLines(sections, file.path(OUT_DIR, "factor_selection_pruned.md"))


# ---- Figure ----------------------------------------------------------

panel_label <- purrr::set_names(
  c(
    sprintf("atual (N = %d)", ncol(panel)),
    sprintf(
      "podado, %s (N = %d)",
      principal_config,
      ncol(panels[[principal_config]])
    )
  ),
  c("atual", principal_config)
)

criteria_long <- surfaces |>
  dplyr::filter(painel %in% names(panel_label)) |>
  dplyr::select(painel, k, ER, GR, IC2) |>
  tidyr::pivot_longer(
    c(ER, GR, IC2),
    names_to = "criterio",
    values_to = "valor"
  ) |>
  dplyr::mutate(
    painel = factor(panel_label[painel], levels = panel_label),
    criterio = factor(
      criterio,
      levels = c("ER", "GR", "IC2"),
      labels = c("ER(k): maximo", "GR(k): maximo", "Bai-Ng IC2 BLL: minimo")
    )
  )

chosen_k <- criteria_long |>
  dplyr::filter(
    dplyr::if_else(
      criterio == "Bai-Ng IC2 BLL: minimo",
      valor == min(valor),
      valor == max(valor)
    ),
    .by = c(painel, criterio)
  )

criteria_plot <- ggplot2::ggplot(
  criteria_long,
  ggplot2::aes(k, valor, colour = painel)
) +
  ggplot2::geom_vline(
    xintercept = R_FACTORS,
    linetype = "dotted",
    colour = "grey50"
  ) +
  ggplot2::geom_line() +
  ggplot2::geom_point(data = chosen_k, size = 2.5) +
  ggplot2::facet_wrap(~criterio, scales = "free_y") +
  ggplot2::scale_colour_manual(values = c("black", "firebrick")) +
  ggplot2::scale_x_continuous(breaks = c(1, 5, 10, 15, 20)) +
  ggplot2::labs(
    title = "Numero de fatores: painel atual contra o podado por correlacao",
    subtitle = sprintf(
      paste(
        "Primeiras diferencas padronizadas BLL, T = %d; pontos marcam o k",
        "escolhido; pontilhado em r = %d (producao)"
      ),
      nrow(panel) - 1,
      R_FACTORS
    ),
    x = "numero de fatores k",
    y = NULL,
    colour = NULL
  ) +
  ggplot2::theme_classic(base_size = 10) +
  ggplot2::theme(legend.position = "bottom")

ggplot2::ggsave(
  file.path(OUT_DIR, "factor_selection_pruned.pdf"),
  criteria_plot,
  width = 10,
  height = 4.5
)
