# ===================================================================
# Panel composition diagnostics: is the cross-section balanced, does any
# block dominate the factor space, and how much of xi_mp depends on it.
#
# Five stages, all at the centralized production cell:
#   1. census      — block sizes and within-block redundancy
#   2. attribution — who builds each static factor, and the mp direction
#   3. LOBO        — leave-one-block-out xi_mp (fine blocks and domains)
#   4. LOSO        — leave-one-series-out xi_mp
#   5. balanced    — capped-per-block panels
#
# Outputs: output/panel/panel_composition_{census,lobo,loso,balanced}.csv
#          output/panel/panel_composition.md
# ===================================================================

rm(list = ls())

library(readr)
library(dplyr)
library(tidyr)

source("R/modeling/factor_estimation.R")
source("R/modeling/impulse_responde.R")
source("R/modeling/production_spec.R")
source("R/identification/factor_space_diagnostics.R")
source("R/identification/spec_sweep.R")   # md_table


# ---- Config --------------------------------------------------------

SPEC <- production_spec()
R_FAC  <- SPEC$r
Q_FAC  <- SPEC$q
P_LAGS <- SPEC$p
MP_VAR <- SPEC$mp_var
VARIANT <- SPEC$instrument

SAMPLES <- list(
  full = SPEC$sample,
  pre_covid = SPEC$pre_covid_sample
)

DATA_PATH <- SPEC$data_path
INST_PATH <- SPEC$instrument_path
OUT_DIR   <- "output/panel"

CHI2_1_95 <- qchisq(0.95, df = 1)

dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)


# ---- Data ----------------------------------------------------------

raw_data <- read_csv(DATA_PATH, show_col_types = FALSE) |> drop_na()
dates    <- as.Date(raw_data$ref.date)
data_mat <- raw_data |> select(-ref.date) |> as.matrix()
varnames <- colnames(data_mat)
stopifnot(MP_VAR %in% varnames)

inst_panel <- read_csv(INST_PATH, show_col_types = FALSE)
inst_panel$month <- as.Date(inst_panel$month)
inst_df <- data.frame(month = inst_panel$month, shock = inst_panel[[VARIANT]])
inst_df <- inst_df[!is.na(inst_df$shock), ]


# ---- Block taxonomy ------------------------------------------------
# Fine blocks: the smallest grouping a reader would call "a set of variables".
# Domains: the six macro compartments the paper's section 4 speaks in.

block <- dplyr::case_when(
  grepl("^cambio_", varnames)                          ~ "cambio",
  grepl("^juros_", varnames)                           ~ "politica",
  grepl("^yield_", varnames)                           ~ "curva",
  grepl("^base_", varnames)                            ~ "monetario",
  grepl("^credito_|^spread_|^credit_|^fin_inst_", varnames) ~ "credito",
  grepl("^consumo_", varnames)                         ~ "combustiveis",
  grepl("^ind_|^capacidade_", varnames)                ~ "industria",
  grepl("^energia_", varnames)                         ~ "energia",
  grepl("^vendas_", varnames)                          ~ "vendas",
  varnames %in% c("pib", "ibc_br")                     ~ "atividade_agregada",
  varnames %in% c("icc", "ics")                        ~ "confianca",
  grepl("^trab_", varnames)                            ~ "trabalho",
  grepl("^price_", varnames)                           ~ "precos",
  grepl("^commodity_", varnames)                       ~ "commodities",
  grepl("^asset_", varnames)                           ~ "acoes",
  varnames %in% c("embi_perc", "cds_5y", "msci", "sp500_vix") ~ "risco_externo",
  grepl("^epu_", varnames)                             ~ "epu",
  grepl("^fiscal_", varnames)                          ~ "fiscal",
  grepl("^expect_", varnames)                          ~ "expectativas"
)
stopifnot(!any(is.na(block)))

domain <- dplyr::case_when(
  block %in% c("combustiveis", "industria", "energia", "vendas",
               "atividade_agregada", "confianca")      ~ "atividade_real",
  block == "trabalho"                                  ~ "trabalho",
  block == "precos"                                    ~ "precos",
  block %in% c("monetario", "credito")                 ~ "credito_moeda",
  block %in% c("cambio", "politica", "curva", "acoes") ~ "financeiro_domestico",
  block %in% c("commodities", "risco_externo", "epu")  ~ "externo_risco",
  block == "fiscal"                                   ~ "fiscal",
  block == "expectativas"                             ~ "expectativas"
)
stopifnot(!any(is.na(domain)))


# ---- 1. Census and within-block redundancy -------------------------
# Redundancy is measured on the BLL object: standardized first differences.
# Participation ratio of the block correlation eigenvalues gives the
# effective number of independent series in the block — n if orthogonal,
# 1 if the block is one series repeated.

yy <- diff(data_mat)
yy <- sweep(sweep(yy, 2, colMeans(yy), "-"), 2, apply(yy, 2, sd), "/")

census <- lapply(sort(unique(block)), function(b) {
  idx <- which(block == b)
  ev  <- eigen(cor(yy[, idx, drop = FALSE]), only.values = TRUE)$values
  ev  <- pmax(ev, 0)
  data.frame(
    block       = b,
    domain      = unique(domain[idx]),
    n_series    = length(idx),
    share_pct   = 100 * length(idx) / length(varnames),
    pc1_share   = ev[1] / sum(ev),
    n_effective = sum(ev)^2 / sum(ev^2),
    mean_abs_cor = mean(abs(cor(yy[, idx, drop = FALSE])[
      upper.tri(diag(length(idx)))]))
  )
}) |> bind_rows()


# ---- Baseline fit and factor attribution ---------------------------

fit_full <- estimate_dfm(data_mat, r = R_FAC, q = Q_FAC, p = P_LAGS,
                         dates = dates, apply_kilian = FALSE)

lambda <- fit_full$static_loadings     # N x r, orthonormal columns
mp_idx <- match(MP_VAR, varnames)

diag_base <- diagnose_instrument_in_factor_space(fit_full, inst_df, dates,
                                                 P_LAGS, mp_idx)

# Common-component share of each series (projection of yy on the r-space)
chi     <- yy %*% lambda %*% t(lambda)
comm_r2 <- colSums(chi^2) / colSums(yy^2)

# Block share of each static factor: columns of lambda are unit-norm, so
# the squared loadings partition each factor across the cross-section.
fac_share <- sapply(seq_len(R_FAC), function(k)
  tapply(lambda[, k]^2, block, sum))

# Weight of each static factor in the shock. H is the loading of the
# structural shock on the q dynamic innovations; K %*% M carries those into
# the r static factors, so g is how much each factor moves on impact.
g_static <- map_dynamic_direction_to_static(fit_full, diag_base$H)
mp_weight <- abs(g_static) / sum(abs(g_static))

# Block contribution to the mp direction: factor shares weighted by how
# much each factor carries the shock.
mp_block <- drop(fac_share %*% mp_weight)

comm_by_block <- tapply(comm_r2, block, mean)

attribution <- census |>
  mutate(
    comm_r2_mean = as.numeric(comm_by_block[census$block]),
    mp_share_pct = 100 * as.numeric(mp_block[census$block])
  ) |>
  arrange(desc(share_pct))

fac_share_tbl <- as.data.frame(fac_share) |>
  setNames(paste0("F", seq_len(R_FAC))) |>
  tibble::rownames_to_column("block") |>
  mutate(across(where(is.numeric), ~ 100 * .x))


# ---- 2. Leave-one-block-out and leave-one-series-out ----------------
# One helper call per candidate panel; yield_6m can never be dropped, so
# the curva and financeiro_domestico legs keep it and drop the rest.

score_panel <- function(keep_idx, sample_name) {
  win <- SAMPLES[[sample_name]]
  in_window <- dates >= win[1] & dates <= win[2]
  sub   <- data_mat[in_window, keep_idx, drop = FALSE]
  dsub  <- dates[in_window]
  idx   <- match(MP_VAR, colnames(sub))

  fit <- tryCatch(estimate_dfm(sub, r = R_FAC, q = Q_FAC, p = P_LAGS,
                               dates = dsub, apply_kilian = FALSE),
                  error = function(e) e)
  if (inherits(fit, "error")) return(NULL)

  d <- tryCatch(diagnose_instrument_in_factor_space(fit, inst_df, dsub,
                                                    P_LAGS, idx),
                error = function(e) e)
  if (inherits(d, "error")) return(NULL)

  data.frame(sample = sample_name, n_series = length(keep_idx),
             xi_mp = d$wald_mp, f_robust_mp = d$f_robust_mp,
             impact_mp = d$impact_mp,
             ar_bounded = d$wald_mp > CHI2_1_95)
}

lobo_rows <- list()
il <- 0
for (sname in names(SAMPLES)) {
  il <- il + 1
  lobo_rows[[il]] <- cbind(level = "baseline", dropped = "(nenhum)",
                           n_dropped = 0L, score_panel(seq_along(varnames), sname))

  for (b in sort(unique(block))) {
    drop_idx <- setdiff(which(block == b), mp_idx)
    keep     <- setdiff(seq_along(varnames), drop_idx)
    res <- score_panel(keep, sname)
    if (is.null(res)) next
    il <- il + 1
    lobo_rows[[il]] <- cbind(level = "bloco", dropped = b,
                             n_dropped = length(drop_idx), res)
  }

  for (dm in sort(unique(domain))) {
    drop_idx <- setdiff(which(domain == dm), mp_idx)
    keep     <- setdiff(seq_along(varnames), drop_idx)
    res <- score_panel(keep, sname)
    if (is.null(res)) next
    il <- il + 1
    lobo_rows[[il]] <- cbind(level = "dominio", dropped = dm,
                             n_dropped = length(drop_idx), res)
  }
}
lobo <- bind_rows(lobo_rows)

loso_rows <- list()
is_ <- 0
for (sname in names(SAMPLES)) {
  for (j in seq_along(varnames)) {
    if (j == mp_idx) next
    res <- score_panel(setdiff(seq_along(varnames), j), sname)
    if (is.null(res)) next
    is_ <- is_ + 1
    loso_rows[[is_]] <- cbind(dropped = varnames[j], block = block[j], res)
  }
}
loso <- bind_rows(loso_rows)


# ---- 3. Block-balanced panels --------------------------------------
# Cap every block at k series, keeping the k most representative — largest
# absolute loading on the block's own first principal component.

rep_rank <- unlist(lapply(sort(unique(block)), function(b) {
  idx <- which(block == b)
  pc1 <- eigen(cor(yy[, idx, drop = FALSE]))$vectors[, 1]
  setNames(rank(-abs(pc1), ties.method = "first"), varnames[idx])
}))
rep_rank <- rep_rank[varnames]

balanced_rows <- list()
ib <- 0
for (k in c(2L, 3L, 4L, 6L, 8L)) {
  keep <- sort(union(which(rep_rank <= k), mp_idx))
  for (sname in names(SAMPLES)) {
    res <- score_panel(keep, sname)
    if (is.null(res)) next
    ib <- ib + 1
    balanced_rows[[ib]] <- cbind(cap = k, res)
  }
}
balanced <- bind_rows(balanced_rows)


# ---- Write ---------------------------------------------------------

write_csv(attribution, file.path(OUT_DIR, "panel_composition_census.csv"))
write_csv(fac_share_tbl, file.path(OUT_DIR, "panel_composition_factors.csv"))
write_csv(lobo,     file.path(OUT_DIR, "panel_composition_lobo.csv"))
write_csv(loso,     file.path(OUT_DIR, "panel_composition_loso.csv"))
write_csv(balanced, file.path(OUT_DIR, "panel_composition_balanced.csv"))

base_full <- lobo |> filter(level == "baseline", sample == "full")
base_pre  <- lobo |> filter(level == "baseline", sample == "pre_covid")

lobo_wide <- lobo |>
  filter(level != "baseline") |>
  select(level, dropped, n_dropped, sample, xi_mp) |>
  pivot_wider(names_from = sample, values_from = xi_mp,
              names_prefix = "xi_") |>
  mutate(delta_full = xi_full - base_full$xi_mp,
         delta_pre  = xi_pre_covid - base_pre$xi_mp) |>
  arrange(delta_full)

loso_top <- loso |>
  filter(sample == "full") |>
  mutate(delta = xi_mp - base_full$xi_mp) |>
  arrange(delta) |>
  select(dropped, block, xi_mp, delta, f_robust_mp, impact_mp)

md <- c(
  "# Composição do painel: dominância, redundância e sensibilidade de ξ_mp",
  "",
  sprintf("Gerado por `script/panel_composition.R` em %s.", Sys.Date()),
  sprintf("Célula: r=%d, q=%d, p=%d, `%s`, instrumento `%s`.",
          R_FAC, Q_FAC, P_LAGS, MP_VAR, VARIANT),
  sprintf("Baseline ξ_mp: **%.2f** full / **%.2f** pré-COVID.",
          base_full$xi_mp, base_pre$xi_mp),
  "",
  "## 1. Censo e redundância interna",
  "",
  paste("`n_effective` é a razão de participação dos autovalores da correlação",
        "das primeiras diferenças padronizadas: n se o bloco fosse ortogonal,",
        "1 se fosse uma série repetida. `mp_share_pct` é a participação do bloco",
        "nos fatores, ponderada pelo peso de cada fator no choque."),
  "",
  md_table(attribution, digits = 3),
  "",
  "## 2. Participação de cada bloco em cada fator estático (%)",
  "",
  md_table(fac_share_tbl, digits = 3),
  "",
  "## 3. Leave-one-block-out sobre ξ_mp",
  "",
  md_table(lobo_wide, digits = 3),
  "",
  "## 4. Leave-one-series-out: as 15 séries mais nocivas quando removidas",
  "",
  md_table(head(loso_top, 15), digits = 3),
  "",
  "### As 15 séries que mais elevam ξ_mp quando removidas",
  "",
  md_table(tail(loso_top, 15) |> arrange(desc(delta)), digits = 3),
  "",
  "## 5. Painéis balanceados (teto de k séries por bloco)",
  "",
  md_table(balanced, digits = 3)
)

writeLines(md, file.path(OUT_DIR, "panel_composition.md"))
cat("Escrito em", OUT_DIR, "\n")
