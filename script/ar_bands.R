# ===================================================================
# Conjuntos Anderson-Rubin (Montiel Olea-Stock-Watson 2021) do DFM-IV
#
# A rodada que documenta a troca de inferência decidida em 2026-09-08: os
# conjuntos AR passam a ser a inferência operacional do DFM, no lugar do
# wild bootstrap. Aqui as duas réguas rodam lado a lado na mesma célula,
# porque uma troca de inferência que não mostra o que muda não é auditável.
#
# TRÊS RÉGUAS, E ELAS NÃO MEDEM A MESMA COISA:
#   AR          — robusta a instrumento fraco, assintótica, condiciona no
#                 espaço de fatores estimado (Lambda, K, M, sy entram como
#                 conhecidos);
#   delta       — Wald assintótica, mesma derivada, mesmo condicionamento;
#   bootstrap   — wild bootstrap Gonçalves-Kilian, reestima o DFM por réplica.
# AR contra delta isola "robusto a IV fraco vs. Wald"; delta contra bootstrap
# isola "assintótico vs. reamostragem, com e sem incerteza de Lambda".
# Comparar AR direto com bootstrap mistura as duas coisas.
#
# A segunda célula, (r=5, q=2), é a coordenada 5/5 do orientador: mostrar
# visualmente por que aquela dimensão não serve. O coeficiente de lambda^2 da
# quadrática é `T*den^2 - kappa*d0'W2 d0`, logo o conjunto é limitado em todos
# os horizontes se e somente se xi_mp > kappa. Com xi_mp = 2,34 a célula (5,2)
# fica abaixo de 2,71 (90%) e de 3,84 (95%): os conjuntos saem ilimitados, e é
# isso que a figura mostra.
#
# Saídas: output/irf/ar_bands.csv
#         output/irf/ar_bands_summary.csv
#         output/irf/ar_bands.md          (corpo gerado, reescrito a cada run)
#         output/irf/ar_bands_overlay.pdf
# ===================================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readr)
  library(ggplot2)
  library(patchwork)
})

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_response.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")
source("R/identification/weak_iv_ar.R")


# ---- Config --------------------------------------------------------

SPEC       <- production_spec()
INSTRUMENT <- SPEC$instrument
MP_VAR     <- SPEC$mp_var
HORIZON    <- SPEC$horizon
SHOCK_BPS  <- SPEC$shock_bps
NW_LAGS    <- SPEC$ar_nw_lags
N_BOOT     <- SPEC$nboot
BOOT_SEED  <- SPEC$bootstrap_seed
LEVELS     <- c(0.68, 0.90, 0.95)
OUT_DIR    <- "output/irf"

# Só a janela cheia. A pré-COVID entra nas sondas abaixo: com T = 90 inovações
# ela não sustenta a covariância de MOSW em p = 4, e essa é uma restrição da
# rodada, não um detalhe de implementação.
WINDOW <- SPEC$sample

# `boot` marca as células em que o wild bootstrap também roda, para a
# comparação das réguas. A célula (5,2) não é candidata a produção: ali só
# interessa a topologia do conjunto AR.
CELLS <- list(
  list(id = "producao", r = SPEC$r, q = SPEC$q, p = SPEC$p, boot = TRUE),
  list(id = "r5q2",     r = 5L,     q = 2L,     p = SPEC$p, boot = FALSE)
)

# Sondas de viabilidade, não estimativas. A covariância de MOSW exige
# hac_dim = (1 + r*p + r + 1)*r < T, e nenhuma das duas cabe: (8,8) é a
# sugestão 4/5 do orientador na janela cheia, e a pré-COVID é a janela de
# robustez que o wild bootstrap cobria e o conjunto AR não cobre.
PROBES <- list(
  list(id = "r8q8/full",      r = 8L,     q = 8L,     p = SPEC$p,
       window = SPEC$sample),
  list(id = "producao/pre_covid", r = SPEC$r, q = SPEC$q, p = SPEC$p,
       window = SPEC$pre_covid_sample)
)

# Alvos publicados em output/instrument/mosw_strength_grid.csv
XI_MP_TARGET <- c(producao = 6.0570142714031245, r5q2 = 2.338951439606032)

HEADLINE <- c("yield_6m", "yield_2y", "yield_5y", "cambio_usd",
              "embi_perc", "cds_5y", "asset_ibov", "price_ipca")


# ---- Dados ---------------------------------------------------------

raw_data  <- read_csv(SPEC$data_path, show_col_types = FALSE) |> drop_na()
dates     <- as.Date(raw_data$ref.date)
data_mat  <- raw_data |> select(-ref.date) |> as.matrix()
var_names <- colnames(data_mat)
tcode     <- infer_tcode_from_varnames(var_names)
mpind     <- match(MP_VAR, var_names)
norm_val  <- norm_value_for(MP_VAR, SHOCK_BPS)
stopifnot(!is.na(mpind))

inst_panel <- read_csv(SPEC$instrument_path, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)

cat(sprintf("Painel %d x %d, instrumento %s, choque +%gpb, NW(%d)\n",
            nrow(data_mat), ncol(data_mat), INSTRUMENT, SHOCK_BPS, NW_LAGS))


# ---- Conjuntos AR por célula e janela ------------------------------

rows      <- list()
diag_cell <- list()

for (cel in CELLS) {
  ar_cell <- run_stage2_cell(
    data_mat, dates, inst_panel, sample_window = WINDOW,
    r = cel$r, q = cel$q, p = cel$p,
    instrument = INSTRUMENT, mp_var = MP_VAR,
    h = HORIZON, nboot = 0L, seed = BOOT_SEED, shock_bps = SHOCK_BPS,
    tcode = tcode, ci_levels = LEVELS,
    inference = "ar", ar_nw_lags = NW_LAGS
  )
  ar <- ar_cell$irf$ar

  boot_ci <- NULL
  if (isTRUE(cel$boot)) {
    boot_cell <- run_stage2_cell(
      data_mat, dates, inst_panel, sample_window = WINDOW,
      r = cel$r, q = cel$q, p = cel$p,
      instrument = INSTRUMENT, mp_var = MP_VAR,
      h = HORIZON, nboot = N_BOOT, seed = BOOT_SEED, shock_bps = SHOCK_BPS,
      tcode = tcode, ci_levels = LEVELS,
      inference = "bootstrap"
    )
    # As duas réguas têm de sair da mesma estimativa pontual, senão não são
    # comparáveis célula a célula.
    dev <- max(abs(boot_cell$irf$irf_point_matrix - ar_cell$irf$irf_point_matrix))
    if (dev > 0) {
      stop("Ponto do bootstrap difere do ponto do AR em ", dev, " na célula ", cel$id)
    }
    boot_ci <- boot_cell$irf$ci
  }

  diag_cell[[cel$id]] <- list(
    cell = cel$id, r = cel$r, q = cel$q, p = cel$p,
    T_eff = ar$T_eff, hac_dim = ar$hac_dim, n_par = ar$n_par,
    xi_mp = ar$xi_den, max_eig = ar_cell$dfm_max_eig
  )

  cat(sprintf("  %-10s T = %3d  hac_dim = %3d  xi_mp = %8.4f  raiz = %.6f\n",
              cel$id, ar$T_eff, ar$hac_dim, ar$xi_den, ar_cell$dfm_max_eig))

  for (lvl in LEVELS) {
    nm <- sprintf("%.2f", lvl)
    b  <- ar$by_level[[nm]]
    rows[[length(rows) + 1L]] <- tibble::tibble(
      cell    = cel$id,
      var     = rep(var_names, times = HORIZON + 1L),
      h       = rep(0:HORIZON, each = length(var_names)),
      level   = lvl,
      tcode   = rep(tcode, times = HORIZON + 1L),
      point   = as.vector(b$point),
      ar_lo   = as.vector(b$lo),
      ar_hi   = as.vector(b$hi),
      set_type  = as.vector(b$set_type),
      casedummy = as.vector(b$casedummy),
      dm_lo   = as.vector(b$dm_lo),
      dm_hi   = as.vector(b$dm_hi),
      boot_lo = if (is.null(boot_ci)) NA_real_ else as.vector(boot_ci[[nm]]$lower),
      boot_hi = if (is.null(boot_ci)) NA_real_ else as.vector(boot_ci[[nm]]$upper),
      xi_mp   = ar$xi_den,
      critval = b$critval
    )
  }
}

ar_tbl <- bind_rows(rows) |>
  mutate(
    ar_width   = ar_hi - ar_lo,
    dm_width   = dm_hi - dm_lo,
    boot_width = boot_hi - boot_lo,
    ar_sig     = as.vector(ar_excludes_zero(matrix(set_type, ncol = 1),
                                            matrix(ar_lo, ncol = 1),
                                            matrix(ar_hi, ncol = 1))),
    dm_sig     = dm_lo > 0 | dm_hi < 0,
    boot_sig   = boot_lo > 0 | boot_hi < 0,
    # Assimetria em torno do ponto: é o conteúdo que uma banda de Wald,
    # simétrica por construção, não consegue mostrar.
    assimetria = (ar_hi - point) / (point - ar_lo)
  )


# ---- Sondas de viabilidade -----------------------------------------

probes <- lapply(PROBES, function(pr) {
  msg <- tryCatch({
    run_stage2_cell(
      data_mat, dates, inst_panel, sample_window = pr$window,
      r = pr$r, q = pr$q, p = pr$p,
      instrument = INSTRUMENT, mp_var = MP_VAR,
      h = HORIZON, nboot = 0L, seed = BOOT_SEED, shock_bps = SHOCK_BPS,
      tcode = tcode, ci_levels = LEVELS, inference = "ar", ar_nw_lags = NW_LAGS
    )
    "viável"
  }, error = function(e) conditionMessage(e))
  cat(sprintf("  %-10s %s\n", pr$id, msg))
  tibble::tibble(celula = pr$id, r = pr$r, q = pr$q, p = pr$p, resultado = msg)
})
probe_tbl <- bind_rows(probes)


# ---- Auto-testes ---------------------------------------------------

cat("\nAuto-testes:\n")

# 1. xi_mp reproduz output/instrument/mosw_strength_grid.csv na janela cheia.
#    A grade usa compute_factor_space_wald() com os lags residualizados; aqui o
#    mesmo número sai do bloco W2 da covariância de MOSW, por outro caminho.
dev_xi <- max(vapply(names(XI_MP_TARGET), function(cid)
  abs(diag_cell[[cid]]$xi_mp - XI_MP_TARGET[[cid]]), numeric(1)))
cat(sprintf("  1. xi_mp vs mosw_strength_grid.csv           : %.3e\n", dev_xi))

# 2. limitação do conjunto <=> xi_mp > critval
# `empty` (ahat > 0, Delta < 0) também é limitado: o predicado é sobre o sinal de
# `ahat`, não sobre o conjunto ter pontos.
bounded <- ar_tbl |>
  group_by(cell, level) |>
  summarise(todos_limitados = all(set_type %in% c("interval", "singleton",
                                                  "empty")),
            xi_mp = first(xi_mp), critval = first(critval), .groups = "drop") |>
  mutate(coerente = todos_limitados == (xi_mp > critval))
cat(sprintf("  2. limitado <=> xi_mp > critval              : %d de %d\n",
            sum(bounded$coerente), nrow(bounded)))

# 3. o ponto está sempre dentro do conjunto AR limitado
n_outside <- ar_tbl |>
  filter(set_type == "interval",
         point < ar_lo - 1e-9 | point > ar_hi + 1e-9) |>
  nrow()
cat(sprintf("  3. ponto fora do conjunto AR limitado        : %d\n", n_outside))

# 4. smoke test de impacto da produção (output/validation/production_spec_impact_smoke.csv)
smoke_want <- c(yield_6m = 0.005, yield_2y = 0.0070263642339699903,
                yield_5y = 0.0072457194488358932,
                asset_ibov = -0.99650483088005848,
                cambio_usd = 0.13424190947918324)
smoke_got <- ar_tbl |>
  filter(cell == "producao", level == 0.90, h == 0,
         var %in% names(smoke_want)) |>
  select(var, point) |> tibble::deframe()
dev_smoke <- max(abs(smoke_got[names(smoke_want)] - smoke_want))
cat(sprintf("  4. smoke test de impacto (5 séries)          : %.3e\n", dev_smoke))

# 5. (8,8) tem de continuar barrada pelo gate de hac_dim: é o motivo pelo qual
#    a sugestão 4/5 do orientador não é combinável com as bandas AR em p = 4.
probe_blocked <- all(grepl("HAC moment dimension", probe_tbl$resultado))
cat(sprintf("  5. sondas barradas pelo gate de hac_dim      : %d de %d\n",
            sum(grepl("HAC moment dimension", probe_tbl$resultado)), nrow(probe_tbl)))

# 6. o CSV preserva Inf e NA nos conjuntos ilimitados
tmp <- tempfile(fileext = ".csv")
write_csv(ar_tbl |> select(set_type, ar_lo, ar_hi), tmp)
rt <- read_csv(tmp, show_col_types = FALSE)
dev_rt <- max(abs(rt$ar_lo - ar_tbl$ar_lo), abs(rt$ar_hi - ar_tbl$ar_hi), na.rm = TRUE)
same_inf <- identical(is.infinite(rt$ar_lo), is.infinite(ar_tbl$ar_lo)) &&
  identical(is.infinite(rt$ar_hi), is.infinite(ar_tbl$ar_hi)) &&
  identical(is.na(rt$ar_lo), is.na(ar_tbl$ar_lo))
unlink(tmp)
cat(sprintf("  6. round-trip CSV preserva Inf/NA            : %s (desvio %.3e)\n",
            same_inf, dev_rt))

stopifnot(dev_xi < 1e-9, all(bounded$coerente), n_outside == 0,
          dev_smoke < 1e-12, probe_blocked, same_inf, dev_rt < 1e-8)
cat("  todos passaram.\n")


# ---- Sumário -------------------------------------------------------

summary_var <- ar_tbl |>
  group_by(cell, level, var) |>
  summarise(n_h = n(),
            n_limitado = sum(set_type %in% c("interval", "singleton", "empty")),
            n_ar_sig   = sum(ar_sig, na.rm = TRUE),
            n_dm_sig   = sum(dm_sig, na.rm = TRUE),
            n_boot_sig = sum(boot_sig, na.rm = TRUE),
            razao_ar_boot = median(ar_width / boot_width, na.rm = TRUE),
            razao_ar_dm   = median(ar_width / dm_width,   na.rm = TRUE),
            .groups = "drop")

# Só os primitivos vão para o CSV: larguras, flags de significância e
# assimetria são funções dos limites, e a dezenas de milhares de linhas cada
# coluna derivada custa mais em disco do que vale. `xi_mp` e `critval` são
# constantes por (célula, janela, nível) e ficam no relatório.
write_csv(ar_tbl |>
            select(cell, var, h, level, tcode, point, ar_lo, ar_hi,
                   set_type, casedummy, dm_lo, dm_hi, boot_lo, boot_hi) |>
            mutate(across(where(is.double), ~ signif(.x, 8))),
          file.path(OUT_DIR, "ar_bands.csv"))
write_csv(summary_var |> mutate(across(where(is.double), ~ signif(.x, 6))),
          file.path(OUT_DIR, "ar_bands_summary.csv"))


# ---- Figura: AR sombreado, bootstrap pontilhado --------------------

plot_df <- ar_tbl |>
  filter(level == 0.90, var %in% HEADLINE, h <= 36) |>
  mutate(var = factor(var, levels = HEADLINE),
         cell = factor(cell, levels = c("producao", "r5q2")))

# Conjuntos ilimitados não têm faixa para sombrear. Recortá-los na escala do
# painel de produção é o que mostra que eles não delimitam nada.
ylim_by_var <- plot_df |>
  filter(cell == "producao") |>
  group_by(var) |>
  summarise(lo = min(ar_lo), hi = max(ar_hi), .groups = "drop") |>
  mutate(pad = 0.15 * (hi - lo), lo = lo - pad, hi = hi + pad)

panels <- lapply(HEADLINE, function(v) {
  d  <- plot_df |> filter(var == v)
  yl <- ylim_by_var |> filter(var == v)
  ggplot(d, aes(x = h)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
    geom_ribbon(aes(ymin = pmax(ar_lo, yl$lo), ymax = pmin(ar_hi, yl$hi),
                    fill = cell), alpha = 0.25) +
    geom_line(data = d |> filter(cell == "producao"),
              aes(y = boot_lo), linetype = "dotted", linewidth = 0.4) +
    geom_line(data = d |> filter(cell == "producao"),
              aes(y = boot_hi), linetype = "dotted", linewidth = 0.4) +
    geom_line(data = d |> filter(cell == "producao"),
              aes(y = point), linewidth = 0.7) +
    scale_fill_manual(values = c(producao = "grey25", r5q2 = "#B2182B"),
                      labels = c(producao = "(r=5, q=5)", r5q2 = "(r=5, q=2)"),
                      name = NULL) +
    coord_cartesian(ylim = c(yl$lo, yl$hi)) +
    labs(title = v, x = NULL, y = NULL) +
    theme_minimal(base_size = 8) +
    theme(legend.position = "none")
})

ggsave(
  file.path(OUT_DIR, "ar_bands_overlay.pdf"),
  wrap_plots(panels, ncol = 4) +
    plot_annotation(
      title = paste0("Conjuntos Anderson-Rubin a 90%: produção (cinza) vs. ",
                     "(r=5, q=2) (vermelho); wild bootstrap pontilhado"),
      subtitle = sprintf(paste0("%s x %s, p = %d, amostra cheia. Linha cheia: ",
                                "estimativa pontual da produção. Em (5,2) ",
                                "xi_mp = %.2f < %.2f e o conjunto é ilimitado — ",
                                "a faixa vermelha está recortada na escala do ",
                                "painel, não delimitada por ele."),
                        INSTRUMENT, MP_VAR, SPEC$p,
                        XI_MP_TARGET[["r5q2"]], qnorm(0.95)^2),
      theme = theme_minimal(base_size = 9)),
  width = 10.4, height = 5.6, device = cairo_pdf)


# ---- Relatório -----------------------------------------------------

fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)

ar_str <- function(set_type, lo, hi) {
  ifelse(set_type == "interval",  sprintf("[%s; %s]", fmt(lo), fmt(hi)),
  ifelse(set_type == "singleton", sprintf("{%s}", fmt(lo)),
  ifelse(set_type == "two_rays",  sprintf("(-Inf; %s] U [%s; Inf)", fmt(lo), fmt(hi)),
  ifelse(set_type == "half_line_left",  sprintf("(-Inf; %s]", fmt(hi)),
  ifelse(set_type == "half_line_right", sprintf("[%s; Inf)", fmt(lo)),
  ifelse(set_type == "real_line", "(-Inf; Inf)", "vazio"))))))
}

diag_tbl <- bind_rows(lapply(diag_cell, as_tibble)) |>
  mutate(limitado_68 = xi_mp > qnorm(0.84)^2,
         limitado_90 = xi_mp > qnorm(0.95)^2,
         limitado_95 = xi_mp > qnorm(0.975)^2)

topologia <- ar_tbl |>
  count(cell, level, set_type, name = "n_celulas") |>
  mutate(level = sprintf("%.2f", level))

placar <- ar_tbl |>
  filter(cell == "producao", !is.na(boot_lo)) |>
  group_by(level = sprintf("%.2f", level)) |>
  summarise(celulas   = n(),
            n_boot    = sum(boot_sig, na.rm = TRUE),
            n_delta   = sum(dm_sig,   na.rm = TRUE),
            n_ar      = sum(ar_sig,   na.rm = TRUE),
            boot_no_ar  = sum(boot_sig & !ar_sig, na.rm = TRUE),
            ar_no_boot  = sum(ar_sig & !boot_sig, na.rm = TRUE),
            razao_ar_boot = median(ar_width / boot_width, na.rm = TRUE),
            razao_ar_dm   = median(ar_width / dm_width,   na.rm = TRUE),
            .groups = "drop")

# Onde as duas réguas divergem: por faixa de horizonte, largura relativa e
# quantas células cada uma declara significativas.
por_horizonte <- ar_tbl |>
  filter(cell == "producao", level == 0.90, !is.na(boot_lo),
         !(var == MP_VAR & h == 0L)) |>
  mutate(faixa = cut(h, c(-1, 0, 6, 12, 24, 36, 48),
                     labels = c("0", "1-6", "7-12", "13-24", "25-36", "37-48"))) |>
  group_by(faixa) |>
  summarise(celulas = n(),
            razao_ar_boot = median(ar_width / boot_width),
            n_boot = sum(boot_sig), n_ar = sum(ar_sig),
            ponto_fora_do_boot = sum(point < boot_lo | point > boot_hi),
            .groups = "drop")

premio <- ar_tbl |>
  filter(!(var == MP_VAR & h == 0L)) |>
  group_by(cell, level = sprintf("%.2f", level)) |>
  summarise(xi_mp = first(xi_mp), critval = first(critval),
            razao_mediana = median(ar_width / dm_width, na.rm = TRUE),
            razao_min = min(ar_width / dm_width, na.rm = TRUE),
            razao_max = max(ar_width / dm_width, na.rm = TRUE),
            .groups = "drop")

manchete <- ar_tbl |>
  filter(cell == "producao", level == 0.90, h == 0,
         var %in% HEADLINE) |>
  transmute(var, ponto = point,
            AR = ar_str(set_type, ar_lo, ar_hi),
            delta = sprintf("[%s; %s]", fmt(dm_lo), fmt(dm_hi)),
            bootstrap = sprintf("[%s; %s]", fmt(boot_lo), fmt(boot_hi)),
            assimetria = assimetria)

contraste <- ar_tbl |>
  filter(level == 0.90, h == 0, var %in% HEADLINE) |>
  select(cell, var, set_type, ar_lo, ar_hi) |>
  mutate(conjunto = ar_str(set_type, ar_lo, ar_hi)) |>
  select(cell, var, conjunto) |>
  pivot_wider(names_from = cell, values_from = conjunto)

md <- c(
  "# Conjuntos Anderson-Rubin do DFM — inversão do teste de Montiel Olea-Stock-Watson",
  "",
  "> Corpo **gerado** por `script/ar_bands.R`; reescrito por inteiro a cada",
  "> execução. Nunca escreva prosa aqui — a leitura interpretativa mora em",
  "> `notas/2026-09-08_bandas_anderson_rubin_producao.md`.",
  "",
  sprintf(paste0("Spec: `%s` × `%s`, p = %d, h = 0-%d, choque +%g pb, NW(%d), ",
                 "wild bootstrap de comparação com nboot = %d (seed %d)."),
          INSTRUMENT, MP_VAR, SPEC$p, HORIZON, SHOCK_BPS, NW_LAGS,
          N_BOOT, BOOT_SEED),
  "",
  "## 1. Força do instrumento e limitação do conjunto",
  "",
  md_table(diag_tbl, 4),
  "",
  paste0("O coeficiente de λ² da quadrática é `T·den² − κ·d0'W₂d0`, logo o ",
         "conjunto é limitado em **todos** os horizontes se e somente se ",
         "ξ_mp > κ, com κ = 0,989 (68%), 2,706 (90%) e 3,841 (95%). Nenhum ",
         "passo usa `W⁻¹`: a quadrática só toca `W` por formas `d'Wd`."),
  "",
  "### Células que não rodam",
  "",
  md_table(probe_tbl, 2),
  "",
  paste0("`r8q8/full` é a sugestão 4/5 do orientador; `producao/pre_covid` é a ",
         "janela de robustez que o wild bootstrap cobria. As duas esbarram no ",
         "mesmo gate, `hac_dim < T`, e o script não tenta pseudo-inversa, ",
         "bootstrap substituto ou qualquer fallback."),
  "",
  "## 2. Topologia dos conjuntos",
  "",
  md_table(topologia, 6),
  "",
  "## 3. Prêmio de instrumento fraco: quanto a inversão alarga a banda de Wald",
  "",
  md_table(premio, 4),
  "",
  paste0("Razão de larguras AR / delta-method. As duas bandas compartilham ",
         "derivada, `W` e condicionamento, então a razão isola a correção de ",
         "instrumento fraco. Ela é quase constante entre séries porque a ",
         "fraqueza mora no **denominador comum** da normalização (`d0'Γ`), ",
         "não no numerador específico de cada série."),
  "",
  "## 4. Placar das três réguas na produção (amostra cheia, 115 séries × 49 horizontes)",
  "",
  md_table(placar, 6),
  "",
  "## 5. Onde AR e bootstrap divergem, por faixa de horizonte (90%)",
  "",
  md_table(por_horizonte, 6),
  "",
  paste0("`ponto_fora_do_boot` conta as células em que a estimativa pontual ",
         "cai fora da própria banda de bootstrap. O conjunto AR contém o ponto ",
         "por construção; a banda percentil do bootstrap não."),
  "",
  "## 6. Manchetes no impacto (h = 0, 90%, produção)",
  "",
  md_table(manchete, 4),
  "",
  paste0("`assimetria` = (limite superior − ponto) / (ponto − limite inferior). ",
         "Uma banda de Wald vale 1 por construção; o afastamento de 1 é o que a ",
         "inversão acrescenta."),
  "",
  "## 7. Produção contra (r=5, q=2) no impacto (h = 0, 90%)",
  "",
  md_table(contraste, 4),
  "",
  "## 8. Onde a correção de instrumento fraco morde mais (produção, 90%, razão AR/delta)",
  "",
  md_table(summary_var |>
             filter(cell == "producao", level == 0.90) |>
             arrange(desc(razao_ar_dm)) |>
             select(var, n_limitado, n_boot_sig, n_dm_sig, n_ar_sig,
                    razao_ar_dm, razao_ar_boot) |>
             head(15), 3),
  "")

writeLines(md, file.path(OUT_DIR, "ar_bands.md"))

cat(sprintf("\n-> %s/ar_bands.{csv,md}, ar_bands_summary.csv, ar_bands_overlay.pdf\n",
            OUT_DIR))
cat("\n=== done ===\n")
