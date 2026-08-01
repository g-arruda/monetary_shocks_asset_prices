# ============================================================
# Labelling the GMR monetary column without the instrument.
#
# The corroboration in `nongaussian_corroboration.R` rests on one column of the
# estimated C being "the monetary one", and that name currently comes from
# |cor(eps_j, z)| — the instrument. The winner beats the runner-up by 0.046.
# This script replaces the rule with three that never touch z, reports what all
# six columns say, and tests whether the corroboration metric discriminates at
# all.
#
# THE RULES ARE FIXED BEFORE ANY AGREEMENT IS COMPUTED — see block 3, which runs
# before block 4. Choosing the rule after seeing which one maximizes agreement
# with the proxy would destroy the independence the exercise is selling.
#
# Run: Rscript script/nongaussian_labelling.R [path/to/gmr_cell.rds]
# Writes: output/nongaussian/labelling_{rules,columns_profile,null}.csv
#         output/nongaussian/labelling_overlay.pdf
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
})

source("R/modeling/factor_estimation.R")
source("R/identification/nongaussian_labelling.R")
source("R/identification/irf_coherence.R")

args     <- commandArgs(trailingOnly = TRUE)
CELL_RDS <- if (length(args) >= 1) args[1] else "output/nongaussian/gmr_cell.rds"
OUT_DIR  <- "output/nongaussian"
N_NULL   <- 2000L
NULL_SEED <- 20260801L
FEVD_H   <- 12L

cell <- readRDS(CELL_RDS)
vn   <- cell$var_names
Pp   <- cell$px$irf_point_matrix
Pg   <- cell$ng$irf_point_matrix
H    <- ncol(Pg) - 1L
q    <- cell$q
sp90 <- (cell$px$ci[["0.90"]]$lower > 0) | (cell$px$ci[["0.90"]]$upper < 0)
sp68 <- (cell$px$ci[["0.68"]]$lower > 0) | (cell$px$ci[["0.68"]]$upper < 0)

cat(sprintf("== labelling sem instrumento: %s (nboot = %d) ==\n", CELL_RDS, cell$nboot))

# ------------------------------------------------------------------
# 1. DFM and rawimp
# ------------------------------------------------------------------
raw   <- read_csv("data/processed/data_log_deseasonalized.csv",
                  show_col_types = FALSE) |> drop_na()
dates <- as.Date(raw$ref.date)
dat   <- raw |> select(-ref.date) |> as.matrix()
inst  <- read_csv("data/processed/instrument.csv", show_col_types = FALSE)
stopifnot(identical(colnames(dat), vn))

dfm    <- estimate_dfm(dat, cell$r, cell$q, cell$p, dates = dates,
                       instrument = inst, apply_kilian = TRUE)
rawimp <- ng_rawimp_from_dfm(dfm, H)

eta   <- dfm$var_residuals %*% dfm$dynamic_loadings %*% solve(dfm$dynamic_scaling)
eta_c <- sweep(eta, 2, colMeans(eta))
P     <- t(chol(stats::var(eta_c)))
C_hat <- cell$ng$ng_point$C

# ------------------------------------------------------------------
# 2. Self-tests
# ------------------------------------------------------------------
chk <- ng_irf_for_b(rawimp, cell$ng$b_point, cell$mpind, 0.005, cell$tcode,
                    orient = FALSE)$irf
cat(sprintf("[self-test] rebuild vs IRF em cache: max abs diff = %.2e\n",
            max(abs(chk - Pg))))
stopifnot(max(abs(chk - Pg)) < 1e-8)

# The FEVD denominator at h = 0 does not depend on the column: with C orthogonal,
# sum_j (v'P c_j)^2 = v' Var(eta) v. This is why R1 (max impact) and an
# h=0 variance share are the same rule, and it is the check that the shares are
# a decomposition rather than an arbitrary normalization.
v_mp  <- rawimp[cell$mpind, , 1]
lhs   <- sum(vapply(seq_len(q), function(j) (sum(v_mp * (P %*% C_hat[, j])))^2, 0))
rhs   <- drop(t(v_mp) %*% stats::var(eta_c) %*% v_mp)
cat(sprintf("[self-test] algebra da FEVD em h=0: |lhs - rhs| = %.2e\n", abs(lhs - rhs)))
stopifnot(abs(lhs - rhs) < 1e-10 * max(1, abs(rhs)))

# ------------------------------------------------------------------
# 3. The rules. DECLARED AND EVALUATED BEFORE ANY PROXY AGREEMENT (block 4).
# ------------------------------------------------------------------
curve_idx <- grep("^yield_", vn)
mp_idx    <- cell$mpind
stopifnot(length(curve_idx) >= 4, mp_idx %in% curve_idx)

# R0 — the incumbent, the only one that uses z. Recomputed rather than read off
# the cell so that it is verified against `ng_point$label` below.
eps_hat <- (eta_c %*% solve(t(P))) %*% C_hat
align   <- sel_ext_inst_sample(as.Date(dfm$dates), cell$p, inst)
r0_stat <- abs(as.vector(stats::cor(eps_hat[align$rsh_sel_ind, , drop = FALSE],
                                    as.matrix(align$inst_sel))))

# R1 — |pre-normalization impact on the policy variable|.
r1_stat <- vapply(seq_len(q), function(j)
  abs(ng_irf_raw(rawimp, drop(P %*% C_hat[, j]))[mp_idx, 1]), 0)

# R2 — FEVD share of the policy variable through h = FEVD_H.
r2_stat <- ng_fevd_share(rawimp, C_hat, P, mp_idx, FEVD_H)$share

# R3 — FEVD share of the whole curve block, so the answer does not hinge on the
# choice of vertex. Anchoring instead on FX/CDS/EMBI would be circular: it would
# select the column that best explains the very block the paper then claims is
# corroborated.
r3_stat <- ng_fevd_share(rawimp, C_hat, P, curve_idx, FEVD_H)$share

rules <- list(
  `R0 |cor(eps,z)| (usa z)`            = r0_stat,
  `R1 impacto em yield_6m`             = r1_stat,
  `R2 FEVD yield_6m h0-12`             = r2_stat,
  `R3 FEVD bloco da curva h0-12`       = r3_stat
)
sel <- vapply(rules, which.max, 1L)
gap <- vapply(rules, function(s) { o <- sort(s, decreasing = TRUE); o[1] - o[2] }, 0)

cat("\n== regras de rotulagem ==\n")
rules_df <- do.call(rbind, lapply(names(rules), function(nm)
  data.frame(regra = nm, coluna = sel[[nm]], folga = gap[[nm]],
             t(setNames(rules[[nm]], paste0("col", seq_len(q)))))))
print(rules_df, row.names = FALSE, digits = 4)

# R0 must reproduce the cached labelling, or the alignment is wrong.
stopifnot(sel[["R0 |cor(eps,z)| (usa z)"]] == cell$ng$ng_point$col_mp)
cat(sprintf("[guard] R0 reproduz a coluna %d do cell (folga %.4f vs %.4f)\n",
            cell$ng$ng_point$col_mp, gap[["R0 |cor(eps,z)| (usa z)"]],
            cell$ng$ng_point$label$gap))

# ------------------------------------------------------------------
# 4. What every column says, scored against the proxy
# ------------------------------------------------------------------
irf_col <- lapply(seq_len(q), function(j)
  ng_irf_for_b(rawimp, drop(P %*% C_hat[, j]), mp_idx, 0.005, cell$tcode)$irf)

# Anti-degeneracy guard: after normalization every column is worth exactly
# 0.005 at the policy variable in h = 0. That is why selection had to happen on
# the pre-normalization response in block 3, and this proves it did.
h0_mp <- vapply(irf_col, function(m) m[mp_idx, 1], 0)
stopifnot(max(abs(h0_mp - 0.005)) < 1e-12)
cat(sprintf("[guard] as %d colunas normalizadas valem 0,005 em yield_6m h0 (max desvio %.1e)\n",
            q, max(abs(h0_mp - 0.005))))

ruler <- coherence_var_table()
agree <- function(M, mask) mean(sign(M[mask]) == sign(Pp[mask]))
mask_h <- function(hs) { m <- matrix(FALSE, nrow(Pp), ncol(Pp)); m[, hs + 1L] <- TRUE; m }

profile <- lapply(seq_len(q), function(j) {
  M <- irf_col[[j]]
  ok <- sp90 & abs(Pp) > .Machine$double.eps^0.5
  data.frame(
    coluna = j,
    cor_z = r0_stat[j], impacto_mp = r1_stat[j],
    fevd_mp = r2_stat[j], fevd_curva = r3_stat[j],
    agree_sig90 = agree(M, sp90),
    agree_sig68_only = agree(M, sp68 & !sp90),
    agree_h0_12 = agree(M, mask_h(0:12)),
    agree_global = mean(sign(M) == sign(Pp)),
    razao_mediana_sig90 = stats::median(M[ok] / Pp[ok]))
}) |> bind_rows()

cat("\n== o que cada coluna diz contra o proxy ==\n")
print(profile, row.names = FALSE, digits = 3)

# Per-block agreement for each column, so the activity exception is visible
# column by column rather than only for the labelled one.
blocks <- lapply(seq_len(q), function(j) {
  M <- irf_col[[j]]
  do.call(rbind, lapply(split(ruler, ruler$group), function(g) {
    idx <- match(g$var, vn); idx <- idx[!is.na(idx)]
    m <- matrix(FALSE, nrow(Pp), ncol(Pp)); m[idx, ] <- TRUE; m <- m & sp90
    data.frame(coluna = j, group = g$group[1], n_sig90 = sum(m),
               agree = if (sum(m)) agree(M, m) else NA_real_)
  }))
}) |> bind_rows()

# ------------------------------------------------------------------
# 5. Does the metric discriminate? Random-direction null.
# ------------------------------------------------------------------
# If an arbitrary direction in R^q already agrees with the proxy on its sig90
# cells, then 0.97 is not evidence of corroboration — it is evidence that those
# cells co-move under any shock, and the headline of (i) has to come down.
# Four statistics, because the coarse one may not discriminate: any direction
# renormalized to +50bp on yield_6m moves the whole curve up, and the curve is
# a quarter of the sig90 cells. `sem_curva` removes that mechanical part, and
# the magnitude ratio asks a question sign agreement cannot — whether the
# response is the right SIZE, where an arbitrary direction has no reason to be.
curve_cells <- matrix(FALSE, nrow(Pp), ncol(Pp)); curve_cells[curve_idx, ] <- TRUE
mask_curva  <- sp90 & curve_cells
mask_semc   <- sp90 & !curve_cells
ok_ratio    <- sp90 & abs(Pp) > .Machine$double.eps^0.5

# The sharpest statistic available, and the one the Wald test is really about:
# the angle between the candidate impact direction and the proxy's own,
# H = (Z'eta)/(Z'Z), both in eta-space. It does not go through the 140-cell
# counting that saturates, and its null is known to be diffuse in R^q.
H_proxy <- drop(crossprod(as.matrix(align$inst_sel),
                          eta_c[align$rsh_sel_ind, , drop = FALSE])) /
  drop(crossprod(as.matrix(align$inst_sel)))
H_unit  <- H_proxy / sqrt(sum(H_proxy^2))

stat_for <- function(M, b) c(
  sig90       = agree(M, sp90),
  curva       = if (sum(mask_curva)) agree(M, mask_curva) else NA_real_,
  sem_curva   = if (sum(mask_semc)) agree(M, mask_semc) else NA_real_,
  log_razao   = abs(log(abs(stats::median(M[ok_ratio] / Pp[ok_ratio])))),
  cos_proxy   = abs(sum(b / sqrt(sum(b^2)) * H_unit)))

set.seed(NULL_SEED)
nms <- c("sig90", "curva", "sem_curva", "log_razao", "cos_proxy")
null_mat <- matrix(NA_real_, N_NULL, length(nms), dimnames = list(NULL, nms))
for (b in seq_len(N_NULL)) {
  u <- rnorm(q); u <- u / sqrt(sum(u^2))
  bb <- drop(P %*% u)
  null_mat[b, ] <- stat_for(ng_irf_for_b(rawimp, bb, mp_idx, 0.005, cell$tcode)$irf, bb)
}
col_stats <- t(vapply(seq_len(q), function(j)
  stat_for(irf_col[[j]], drop(P %*% C_hat[, j])), numeric(length(nms))))

cat(sprintf("\n== nulo de direcao aleatoria (%d sorteios) ==\n", N_NULL))
nq <- apply(null_mat, 2, stats::quantile, c(0.05, 0.5, 0.95), na.rm = TRUE)
print(round(nq, 4))
cat("\n(log_razao = |log| da razao mediana de magnitude; 0 = magnitude identica ao proxy)\n")

# For sign agreement the null is one-sided above; for log_razao, below.
pval <- function(j) c(
  sig90     = mean(null_mat[, "sig90"]     >= col_stats[j, "sig90"], na.rm = TRUE),
  curva     = mean(null_mat[, "curva"]     >= col_stats[j, "curva"], na.rm = TRUE),
  sem_curva = mean(null_mat[, "sem_curva"] >= col_stats[j, "sem_curva"], na.rm = TRUE),
  log_razao = mean(null_mat[, "log_razao"] <= col_stats[j, "log_razao"], na.rm = TRUE),
  cos_proxy = mean(null_mat[, "cos_proxy"] >= col_stats[j, "cos_proxy"], na.rm = TRUE))
pv <- t(vapply(seq_len(q), pval, numeric(length(nms))))

cat("\n== estatisticas por coluna e p contra o nulo ==\n")
print(data.frame(coluna = seq_len(q), round(col_stats, 3),
                 p_sig90 = round(pv[, "sig90"], 4),
                 p_semcurva = round(pv[, "sem_curva"], 4),
                 p_razao = round(pv[, "log_razao"], 4),
                 p_cos = round(pv[, "cos_proxy"], 4)), row.names = FALSE)

# `nq` is 3 x n_stats (quantiles down the rows) while `col_stats` and `pv` are
# q x n_stats, so each block is melted on its own rather than with a shared
# recycling rule.
melt_mat <- function(M, tipo, rowlab) data.frame(
  tipo = tipo, estatistica = rep(colnames(M), each = nrow(M)),
  linha = rep(rowlab, times = ncol(M)), valor = as.vector(M))

null_df <- bind_rows(
  melt_mat(nq, "nulo", rownames(nq)),
  melt_mat(col_stats, "coluna", paste0("col", seq_len(q))),
  melt_mat(pv, "p_valor", paste0("col", seq_len(q))))

# ------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------
write_csv(rules_df, file.path(OUT_DIR, "labelling_rules.csv"))
write_csv(profile,  file.path(OUT_DIR, "labelling_columns_profile.csv"))
write_csv(blocks,   file.path(OUT_DIR, "labelling_by_block.csv"))
write_csv(null_df,  file.path(OUT_DIR, "labelling_null.csv"))

plot_vars <- intersect(c("yield_6m", "yield_2y", "yield_5y", "cambio_usd",
                         "cds_5y", "embi_perc", "price_ipca", "ind_transformacao",
                         "asset_ibov"), vn)
long <- bind_rows(lapply(seq_len(q), function(j) {
  data.frame(var = rep(vn, H + 1), h = rep(0:H, each = length(vn)),
             serie = sprintf("coluna %d", j), point = as.vector(irf_col[[j]]))
}))
long <- bind_rows(long, data.frame(
  var = rep(vn, H + 1), h = rep(0:H, each = length(vn)),
  serie = "proxy-SVAR", point = as.vector(Pp)))
long <- filter(long, var %in% plot_vars)

pal <- c(setNames(grDevices::hcl.colors(q, "Set 2"), sprintf("coluna %d", seq_len(q))),
         `proxy-SVAR` = "black")
p <- ggplot(long, aes(h, point, colour = serie)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey50") +
  geom_line(aes(linewidth = serie == "proxy-SVAR")) +
  scale_linewidth_manual(values = c(`FALSE` = 0.45, `TRUE` = 1.0), guide = "none") +
  scale_colour_manual(values = pal) +
  facet_wrap(~var, scales = "free_y", ncol = 3) +
  labs(x = "horizonte (meses)", y = NULL, colour = NULL,
       title = "As seis colunas do ICA contra o proxy-SVAR",
       subtitle = sprintf("estimativas pontuais; regra vigente seleciona a coluna %d",
                          cell$ng$ng_point$col_mp)) +
  theme_bw(base_size = 9) + theme(legend.position = "top")
ggsave(file.path(OUT_DIR, "labelling_overlay.pdf"), p, width = 9.5, height = 7.5)

cat("\nescrito em", OUT_DIR, "\n")
