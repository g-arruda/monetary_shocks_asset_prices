# ===================================================================
# Carga compartilhada da rodada de auditoria (prompt_auditoria_dfm_iv.md).
# NAO altera nada em R/modeling/ nem R/identification/ — esta rodada e de
# diagnostico. Todo script 0X_*.R deste diretorio comeca por
#   source("diagnostics/_common.R")
# e grava suas tabelas em diagnostics/output/.
# ===================================================================

suppressMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
})

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")
source("R/identification/irf_coherence.R")

DIAG_OUT <- "diagnostics/output"
dir.create(DIAG_OUT, showWarnings = FALSE, recursive = TRUE)

# ---- Especificacao de producao (espelha irf_coherence_check.R) -----
SPEC <- list(
  r = 7L, q = 6L, p = 6L,
  instrument = "z_jk_bs_purif",
  mp_var = "yield_6m",
  h = 48L, nboot = 800L, seed = 123L, shock_bps = 50,
  ci_levels = c(0.68, 0.90),
  window = as.Date(c("2013-01-01", "2025-12-31"))
)

# ---- Painel -------------------------------------------------------
PANEL_RAW <- read_csv("data/raw_data.csv", show_col_types = FALSE)
panel_df  <- read_csv("data/processed/data_log_deseasonalized.csv",
                      show_col_types = FALSE) |> drop_na()
DATES     <- as.Date(panel_df$ref.date)
PANEL     <- panel_df |> select(-ref.date) |> as.matrix()
VAR_NAMES <- colnames(PANEL)
TCODE     <- infer_tcode_from_varnames(VAR_NAMES)

# ---- Instrumento --------------------------------------------------
INST_PANEL <- read_csv("data/processed/instrumentos_mensais.csv",
                       show_col_types = FALSE) |>
  mutate(month = as.Date(month))

#' Instrumento de producao alinhado ao painel, como data.frame month/shock
inst_df <- function(variant = SPEC$instrument) {
  INST_PANEL |>
    select(month, shock = all_of(variant)) |>
    filter(!is.na(shock))
}

# ---- Celula de producao ja estimada -------------------------------
CELL_PATH <- "output/irf/irf_coherence_cell.rds"
CELL <- if (file.exists(CELL_PATH)) readRDS(CELL_PATH) else NULL


# ---- Unidades declaradas por serie --------------------------------
# Levantadas por inspecao de download.R + clean.R. `escala_bp` converte a
# unidade nativa para pontos-base, e so faz sentido no bloco de juros.
unit_table <- function() {
  rbind(
    data.frame(var = c("yield_3m", "yield_6m", "yield_1y", "yield_2y",
                       "yield_5y", "yield_10y"),
               unidade = "proporcao decimal (0.0975 = 9.75% a.a.)",
               escala_bp = 10000),
    data.frame(var = c("juros_selic", "juros_cdi"),
               unidade = "ponto percentual a.a. (9.75 = 9.75%)",
               escala_bp = 100),
    data.frame(var = "embi_perc", unidade = "ponto percentual (2.73 = 273bp)",
               escala_bp = 100),
    data.frame(var = "cds_5y", unidade = "ponto-base (208 = 208bp)",
               escala_bp = 1),
    data.frame(var = c("cambio_usd", "cambio_eur", "cambio_cny",
                       "cambio_ars", "cambio_inr"),
               unidade = "nivel BRL por unidade de moeda", escala_bp = NA),
    data.frame(var = grep("^price_", VAR_NAMES, value = TRUE),
               unidade = "taxa MENSAL em % (0.47 = 0.47% no mes)",
               escala_bp = NA),
    data.frame(var = grep("^asset_", VAR_NAMES, value = TRUE),
               unidade = "retorno mensal decimal (tcode 2 -> cumsum x100 = %)",
               escala_bp = NA),
    data.frame(var = grep("^base_|^credit|^credito_", VAR_NAMES, value = TRUE),
               unidade = "log-nivel (tcode 4 -> (exp-1)x100 = %)",
               escala_bp = NA),
    data.frame(var = c("pib", "fin_inst_reserve_req"),
               unidade = "log-nivel (tcode 4 -> (exp-1)x100 = %)",
               escala_bp = NA)
  )
}


# ---- Grupos do painel ---------------------------------------------
GROUP_PATTERNS <- c(
  juros      = "^juros_|^yield_",
  cambio     = "^cambio_",
  base       = "^base_",
  credito    = "^credit|^spread_icc",
  consumo    = "^consumo_|^vendas_",
  industria  = "^ind_|^capacidade",
  energia    = "^energia_",
  trabalho   = "^trab_|^employment|^min_wage|^pop_",
  precos     = "^price_",
  commodity  = "^commodity_",
  ativos     = "^asset_",
  incerteza  = "^epu_",
  risco_ext  = "^embi|^cds_5y$|^msci$|^sp500_vix$",
  atividade  = "^pib$|^ibc_br$|^icc$|^ics$"
)

var_group <- function(v = VAR_NAMES) {
  g <- rep(NA_character_, length(v))
  for (nm in names(GROUP_PATTERNS)) {
    hit <- grepl(GROUP_PATTERNS[[nm]], v) & is.na(g)
    g[hit] <- nm
  }
  g[is.na(g)] <- "outros"
  g
}


# ---- Utilitarios --------------------------------------------------

#' Tabela markdown simples (mesma convencao dos relatorios do repo)
md_tbl <- function(df, digits = 4) {
  df <- as.data.frame(df)
  num <- vapply(df, is.numeric, logical(1))
  df[num] <- lapply(df[num], function(x) format(round(x, digits), trim = TRUE))
  hdr <- paste0("| ", paste(names(df), collapse = " | "), " |")
  sep <- paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|")
  body <- apply(df, 1, function(r) paste0("| ", paste(r, collapse = " | "), " |"))
  c(hdr, sep, body)
}

#' Grava csv em diagnostics/output/ e ecoa o caminho
diag_write <- function(df, file) {
  path <- file.path(DIAG_OUT, file)
  write_csv(df, path)
  cat(sprintf("  -> %s (%d linhas)\n", path, nrow(df)))
  invisible(path)
}

#' Matriz de defasagens de x (lags 1..L), alinhada a x[(L+1):T]
lag_matrix <- function(x, L, prefix = "x") {
  x <- as.matrix(x)
  T <- nrow(x)
  out <- lapply(seq_len(L), function(l) {
    m <- x[(L + 1 - l):(T - l), , drop = FALSE]
    colnames(m) <- paste0(prefix, "_", colnames(x), "_l", l)
    m
  })
  do.call(cbind, out)
}

cat(sprintf("[_common] painel %d x %d | %s a %s | instrumento %s\n",
            nrow(PANEL), ncol(PANEL),
            format(min(DATES)), format(max(DATES)), SPEC$instrument))
