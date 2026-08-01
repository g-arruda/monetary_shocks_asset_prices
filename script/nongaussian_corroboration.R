# ============================================================
# Does the non-Gaussian identification corroborate the proxy-SVAR?
#
# Post-processing over `output/nongaussian/gmr_cell.rds`, which already carries
# the 106 x 49 IRF matrices of BOTH identifications with 68/90 bands. Nothing is
# re-estimated except the DFM needed to rebuild `rawimp` for the runner-up
# column (block 4), and nothing in production is modified.
#
# WHY THIS EXISTS. `model_nongaussian.R` compares 8 hand-picked HEADLINE series
# and reports 8/8 sign agreement at impact. On the full 106-series panel that
# figure is 0.62. Neither number is the answer: the first is selected, the second
# scores series on which the proxy itself says nothing. The ruler that answers
# "does what I claim survive?" is sign agreement CONDITIONAL on the proxy being
# significant — reported here alongside both others so the effect of the
# selection is visible rather than hidden.
#
# Run: Rscript script/nongaussian_corroboration.R [path/to/gmr_cell.rds]
# Writes: output/nongaussian/corroboration_{summary,by_var,by_block,runnerup}.csv
#         output/nongaussian/corroboration_overlay.pdf
# ============================================================

rm(list = ls())

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
})

source("R/identification/irf_coherence.R")

args     <- commandArgs(trailingOnly = TRUE)
CELL_RDS <- if (length(args) >= 1) args[1] else "output/nongaussian/gmr_cell.rds"
OUT_DIR  <- "output/nongaussian"
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

HEADLINE <- c("yield_6m", "yield_2y", "yield_5y", "asset_ibov", "cambio_usd",
              "price_ipca", "embi_perc", "commodity_metal")

cell <- readRDS(CELL_RDS)
vn   <- cell$var_names
Pg   <- cell$ng$irf_point_matrix
Pp   <- cell$px$irf_point_matrix
H    <- ncol(Pg) - 1L

cat(sprintf("== corroboration: %s (nboot = %d, r = %d, q = %d) ==\n",
            CELL_RDS, cell$nboot, cell$r, cell$q))

sig_flags <- function(ci, level) {
  lo <- ci[[level]]$lower; hi <- ci[[level]]$upper
  (lo > 0) | (hi < 0)
}
sg90 <- sig_flags(cell$ng$ci, "0.90"); sp90 <- sig_flags(cell$px$ci, "0.90")
sg68 <- sig_flags(cell$ng$ci, "0.68"); sp68 <- sig_flags(cell$px$ci, "0.68")

# ------------------------------------------------------------------
# Guards
# ------------------------------------------------------------------
# Vintage: the proxy side of the cell must be the production point estimate.
# These are the CLAUDE.md smoke-test values; a re-estimation on a different
# panel would otherwise be compared silently against the wrong baseline.
prod_h0 <- c(yield_6m = 0.005, yield_2y = 0.009164, yield_5y = 0.009274,
             asset_ibov = -1.673, cambio_usd = 0.1498)
got_h0  <- Pp[match(names(prod_h0), vn), 1]
stopifnot(all(abs(got_h0 - prod_h0) < 5e-4))

stopifnot(identical(dim(Pg), dim(Pp)), length(vn) == nrow(Pg))

# ------------------------------------------------------------------
# 1. Sign agreement under three conditionings x three variable subsets
# ------------------------------------------------------------------
# `subset` selects WHICH SERIES are scored; `cond` selects WHICH CELLS within
# them. Crossing the two is the point: it shows that the headline 8/8 is a
# property of the selection, and that conditioning on proxy significance — not
# widening the panel — is what makes the comparison informative.
ruler   <- coherence_var_table()
subsets <- list(
  headline_8 = vn %in% HEADLINE,
  coherence_53 = vn %in% ruler$var,
  panel_106 = rep(TRUE, length(vn))
)

hwin <- list(h0 = 0L, h0_6 = 0:6, h0_12 = 0:12, h13_24 = 13:24, h25_48 = 25:48,
             all = 0:H)

cell_mask <- function(rows, hs) {
  m <- matrix(FALSE, nrow(Pg), ncol(Pg))
  m[rows, hs + 1L] <- TRUE
  m
}

conds <- list(
  incondicional = matrix(TRUE, nrow(Pg), ncol(Pg)),
  proxy_sig90   = sp90,
  proxy_sig68_only = sp68 & !sp90
)

summary_rows <- list()
for (sn in names(subsets)) {
  for (cn in names(conds)) {
    for (hn in names(hwin)) {
      m <- cell_mask(which(subsets[[sn]]), hwin[[hn]]) & conds[[cn]]
      n <- sum(m)
      if (n == 0) {
        summary_rows[[length(summary_rows) + 1]] <- data.frame(
          subset = sn, cond = cn, hwin = hn, n = 0L,
          sign_agree = NA_real_, coverage90 = NA_real_,
          median_ratio = NA_real_, iqr_lo = NA_real_, iqr_hi = NA_real_)
        next
      }
      g <- Pg[m]; p <- Pp[m]
      inside <- (p >= cell$ng$ci[["0.90"]]$lower[m]) &
        (p <= cell$ng$ci[["0.90"]]$upper[m])
      # Ratio only where the proxy point is not numerically zero, otherwise the
      # quotient is meaningless rather than large.
      ok_r <- abs(p) > .Machine$double.eps^0.5
      ratio <- if (any(ok_r)) g[ok_r] / p[ok_r] else NA_real_
      summary_rows[[length(summary_rows) + 1]] <- data.frame(
        subset = sn, cond = cn, hwin = hn, n = n,
        sign_agree = mean(sign(g) == sign(p)),
        coverage90 = mean(inside),
        median_ratio = stats::median(ratio, na.rm = TRUE),
        iqr_lo = unname(stats::quantile(ratio, 0.25, na.rm = TRUE)),
        iqr_hi = unname(stats::quantile(ratio, 0.75, na.rm = TRUE)))
    }
  }
}
summary_df <- bind_rows(summary_rows)

# Non-selection guard: both stylized facts must come out of the same run, or
# the metric is wrong. 8/8 at impact on the headline, ~0.62 on the panel.
g_head <- subset(summary_df, subset == "headline_8" & cond == "incondicional" &
                   hwin == "h0")$sign_agree
g_panel <- subset(summary_df, subset == "panel_106" & cond == "incondicional" &
                    hwin == "h0")$sign_agree
stopifnot(g_head == 1, g_panel > 0.55, g_panel < 0.70)
cat(sprintf("[guard] impacto: manchete %.3f vs painel %.3f\n", g_head, g_panel))

# ------------------------------------------------------------------
# 2. Per-variable and per-block
# ------------------------------------------------------------------
per_var <- lapply(seq_along(vn), function(i) {
  g <- Pg[i, ]; p <- Pp[i, ]
  n90 <- sum(sp90[i, ]); n68 <- sum(sp68[i, ])
  agree90 <- if (n90 > 0) mean(sign(g[sp90[i, ]]) == sign(p[sp90[i, ]])) else NA_real_
  data.frame(
    var = vn[i],
    sig90_proxy = n90, sig90_gmr = sum(sg90[i, ]),
    sig68_proxy = n68, sig68_gmr = sum(sg68[i, ]),
    sign_agree_all = mean(sign(g) == sign(p)),
    sign_agree_h0_12 = mean(sign(g[1:13]) == sign(p[1:13])),
    sign_agree_sig90 = agree90,
    cor_path = stats::cor(g, p),
    coverage90 = mean(p >= cell$ng$ci[["0.90"]]$lower[i, ] &
                        p <= cell$ng$ci[["0.90"]]$upper[i, ]),
    band_ratio90 = stats::median((cell$ng$ci[["0.90"]]$upper[i, ] -
                                    cell$ng$ci[["0.90"]]$lower[i, ]) /
                                   (cell$px$ci[["0.90"]]$upper[i, ] -
                                      cell$px$ci[["0.90"]]$lower[i, ]))
  )
}) |> bind_rows()
per_var <- left_join(per_var, ruler[, c("var", "group", "tier")], by = "var")
per_var$group[is.na(per_var$group)] <- "fora_do_ruler"

per_block <- per_var |>
  group_by(group) |>
  summarise(n_var = n(),
            sig90_proxy = sum(sig90_proxy), sig90_gmr = sum(sig90_gmr),
            sign_agree_h0_12 = mean(sign_agree_h0_12),
            sign_agree_sig90 = mean(sign_agree_sig90, na.rm = TRUE),
            median_cor_path = stats::median(cor_path),
            median_band_ratio90 = stats::median(band_ratio90),
            .groups = "drop") |>
  arrange(desc(sig90_proxy))

# The cells where the proxy is significant and the GMR points the other way.
# These belong in the report, not in a footnote: if they cluster in one block,
# the corroboration claim has to exclude that block by name.
w <- which(sp90 & (sign(Pg) != sign(Pp)), arr.ind = TRUE)
disagree <- if (nrow(w) > 0) data.frame(
  var = vn[w[, 1]], h = w[, 2] - 1L,
  proxy = Pp[sp90 & sign(Pg) != sign(Pp)],
  gmr = Pg[sp90 & sign(Pg) != sign(Pp)]) |>
  left_join(ruler[, c("var", "group")], by = "var") |>
  mutate(group = ifelse(is.na(group), "fora_do_ruler", group)) |>
  arrange(h, var) else data.frame()

# ------------------------------------------------------------------
# 3. Where the GMR itself is significant
# ------------------------------------------------------------------
wg <- which(sg90, arr.ind = TRUE)
gmr_sig <- if (nrow(wg) > 0) data.frame(
  var = vn[wg[, 1]], h = wg[, 2] - 1L,
  gmr = Pg[sg90], proxy = Pp[sg90]) |> arrange(h, var) else data.frame()

# ------------------------------------------------------------------
# 4. The runner-up column (pendencias.md: labelling gap is 0.012)
# ------------------------------------------------------------------
# The monetary column is named by |cor(eps_j, z)|, and the winner beats the
# runner-up by a hair. If both columns give the same IRF the fragility is
# harmless; if they do not, the whole GMR reading is unstable. `rawimp` is not
# in the cell object, so the DFM is re-estimated (deterministic, no bootstrap)
# and the rebuild is checked against the cached IRF before being used.
runnerup <- data.frame()
cor_abs  <- cell$ng$ng_point$label$cor_abs
if (!is.null(cor_abs)) {
  suppressPackageStartupMessages({
    source("R/modeling/factor_estimation.R")
    source("R/identification/nongaussian_labelling.R")
  })
  raw <- read_csv("data/processed/data_log_deseasonalized.csv",
                  show_col_types = FALSE) |> drop_na()
  dates <- as.Date(raw$ref.date)
  dat   <- raw |> select(-ref.date) |> as.matrix()
  inst  <- read_csv("data/processed/instrument.csv", show_col_types = FALSE)
  stopifnot(identical(colnames(dat), vn))

  dfm <- estimate_dfm(dat, cell$r, cell$q, cell$p, dates = dates,
                      instrument = inst, apply_kilian = TRUE)

  K <- dfm$dynamic_loadings; M <- dfm$dynamic_scaling
  rawimp <- ng_rawimp_from_dfm(dfm, H)

  # `orient = FALSE` on the cached b_point, which ident_nongaussian already
  # oriented; the runner-up column below is oriented by the module.
  irf_from_b <- function(b, orient = TRUE)
    ng_irf_for_b(rawimp, b, cell$mpind, 0.005, cell$tcode, orient = orient)$irf

  # Self-test: the rebuilt rawimp with the cached b must reproduce the cached
  # IRF. Without this the runner-up numbers would be uninterpretable.
  #
  # It tolerates exactly one thing: a per-variable factor of 100. The cell of
  # 2026-07-27 predates the B1 locale fix of 2026-07-28, which rescaled cds_5y,
  # msci and sp500_vix by 100 in `data_log_deseasonalized.csv`. BLL standardizes
  # the panel, so a pure scale change on a few series leaves the factors — and
  # therefore all 103 other responses — bit-identical; only those series' units
  # move. Sign agreement, coverage and GMR/proxy ratios are scale-invariant, so
  # the corroboration metrics are unaffected. Any OTHER mismatch is a real bug.
  # The factor is read as the median over the 49 horizons, not at h = 0: a
  # near-zero impact response makes the pointwise quotient numerically useless
  # (msci is 1.5e-3 at h = 0) while the factor is stable to 1e-6 elsewhere.
  chk   <- irf_from_b(cell$ng$b_point, orient = FALSE)
  fac   <- apply(Pg / chk, 1, stats::median)
  stale <- which(abs(fac - 1) > 1e-4)
  cat(sprintf("[self-test] rawimp rebuild vs cache: max abs diff = %.2e em %d series\n",
              max(abs(chk - Pg)), length(stale)))
  if (length(stale)) {
    cat(sprintf("[self-test] escala por serie (safra do cache != painel atual): %s\n",
                paste(sprintf("%s x%.4f", vn[stale], fac[stale]), collapse = ", ")))
    stopifnot(all(abs(fac[stale] - 100) < 1e-2))
  }
  # Error normalized by each series' own scale, not pointwise-relative: several
  # responses cross zero, and a quotient against a near-zero point inflates to
  # 1e-3 on a rebuild that is otherwise exact to floating point.
  # Logical, not negative-integer: `x[-integer(0), ]` drops every row.
  keep <- rep(TRUE, nrow(chk)); keep[stale] <- FALSE
  err  <- apply(abs(chk - Pg), 1, max) / apply(abs(Pg), 1, max)
  cat(sprintf("[self-test] erro normalizado pela escala da serie: mediana %.2e, max %.2e\n",
              stats::median(err[keep]), max(err[keep])))
  stopifnot(max(err[keep]) < 1e-5)

  C_hat  <- cell$ng$ng_point$C
  col_mp <- cell$ng$ng_point$col_mp
  col_up <- order(cor_abs, decreasing = TRUE)[2]
  eta <- dfm$var_residuals %*% K %*% solve(M)
  Pw  <- t(chol(stats::var(sweep(eta, 2, colMeans(eta)))))
  irf_up <- irf_from_b(drop(Pw %*% C_hat[, col_up]))

  runnerup <- data.frame(
    var = rep(vn, H + 1), h = rep(0:H, each = length(vn)),
    winner = as.vector(Pg), runnerup = as.vector(irf_up)) |>
    arrange(var, h)
  attr(runnerup, "col_mp") <- col_mp; attr(runnerup, "col_up") <- col_up

  cat(sprintf("[runner-up] coluna %d vs %d | cor(|z|) %.3f vs %.3f\n",
              col_up, col_mp, cor_abs[col_up], cor_abs[col_mp]))
  cat(sprintf("[runner-up] vs coluna vencedora: %.3f global, %.3f nas sig90 do proxy\n",
              mean(sign(irf_up) == sign(Pg)),
              mean(sign(irf_up[sp90]) == sign(Pg[sp90]))))
  # The quantity that decides whether the labelling gap matters for the paper:
  # if the runner-up corroborates the proxy as well as the winner does, the
  # fragile name is not carrying the corroboration claim.
  cat(sprintf("[runner-up] vs proxy:            %.3f global, %.3f nas sig90 do proxy\n",
              mean(sign(irf_up) == sign(Pp)),
              mean(sign(irf_up[sp90]) == sign(Pp[sp90]))))
}

# ------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------
write_csv(summary_df, file.path(OUT_DIR, "corroboration_summary.csv"))
write_csv(per_var,    file.path(OUT_DIR, "corroboration_by_var.csv"))
write_csv(per_block,  file.path(OUT_DIR, "corroboration_by_block.csv"))
if (nrow(disagree)) write_csv(disagree, file.path(OUT_DIR, "corroboration_disagreements.csv"))
if (nrow(gmr_sig))  write_csv(gmr_sig,  file.path(OUT_DIR, "corroboration_gmr_sig90.csv"))
if (nrow(runnerup)) write_csv(runnerup, file.path(OUT_DIR, "corroboration_runnerup.csv"))

plot_vars <- intersect(c(HEADLINE, "ind_transformacao", "credito_agro",
                         "price_core_ipca_ex0", "cds_5y"), vn)
long <- bind_rows(
  data.frame(var = rep(vn, H + 1), h = rep(0:H, each = length(vn)),
             ident = "GMR", point = as.vector(Pg),
             lo = as.vector(cell$ng$ci[["0.90"]]$lower),
             hi = as.vector(cell$ng$ci[["0.90"]]$upper)),
  data.frame(var = rep(vn, H + 1), h = rep(0:H, each = length(vn)),
             ident = "proxy", point = as.vector(Pp),
             lo = as.vector(cell$px$ci[["0.90"]]$lower),
             hi = as.vector(cell$px$ci[["0.90"]]$upper))
) |> filter(var %in% plot_vars)

p <- ggplot(long, aes(h, point, colour = ident, fill = ident)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey40") +
  geom_ribbon(aes(ymin = lo, ymax = hi), alpha = 0.15, colour = NA) +
  geom_line(linewidth = 0.6) +
  facet_wrap(~var, scales = "free_y", ncol = 3) +
  scale_colour_manual(values = c(GMR = "#b2182b", proxy = "#2166ac")) +
  scale_fill_manual(values = c(GMR = "#b2182b", proxy = "#2166ac")) +
  labs(x = "horizonte (meses)", y = NULL, colour = NULL, fill = NULL,
       title = "GMR nao-gaussiano vs proxy-SVAR, bandas de 90%",
       subtitle = sprintf("r = %d, q = %d, nboot = %d", cell$r, cell$q, cell$nboot)) +
  theme_bw(base_size = 9) + theme(legend.position = "top")
ggsave(file.path(OUT_DIR, "corroboration_overlay.pdf"), p,
       width = 9, height = 8)

# ------------------------------------------------------------------
cat("\n== concordancia de sinal por recorte (h0 / h0-12 / h13-48) ==\n")
show <- summary_df |>
  filter(hwin %in% c("h0", "h0_12", "h13_24", "h25_48")) |>
  select(subset, cond, hwin, n, sign_agree, coverage90) |>
  as.data.frame()
print(show, row.names = FALSE, digits = 3)

cat(sprintf("\ncelulas sig90: proxy %d | GMR %d (de %d)\n",
            sum(sp90), sum(sg90), length(sp90)))
cat(sprintf("cobertura do ponto do proxy no CI90 do GMR: %.4f\n",
            mean(Pp >= cell$ng$ci[["0.90"]]$lower & Pp <= cell$ng$ci[["0.90"]]$upper)))
if (nrow(disagree)) {
  cat(sprintf("\n== %d discordancias de sinal onde o proxy e sig90 ==\n", nrow(disagree)))
  print(disagree, row.names = FALSE, digits = 4)
}
cat("\nescrito em", OUT_DIR, "\n")
