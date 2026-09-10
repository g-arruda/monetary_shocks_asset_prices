# ===================================================================
# Alternative estimators of the number of static factors r, against the
# production Bai-Ng surface: Ahn & Horenstein (2013) ER/GR and Alessi,
# Barigozzi & Capasso (2010) ABC. Suggestion 1/5 of the advisor's e-mail of
# 2026-09-04 (item B1 of registro/pendencias.md).
#
# THE OBJECT is the BLL-standardized first differences `yy` of the production
# panel -- estimate_static_factors()$yy, built exactly like the X_std that
# bai_ng_criteria(apply_bll = TRUE) hands Bai-Ng in script/model_alessi.R. Self-
# test (b) proves it: log V(k) of this object plus the Bai-Ng penalties
# reproduces output/factors/production_bai_ng_bll_surface.csv. Same grid as that
# surface, k = 1..20. First differences are also what AH prescribe when factors
# are I(1) (sec. 2, citing Bai-Ng 2004).
#
# THE READING RULE IS PRE-REGISTERED (plan of 2026-09-10), fixed before any
# estimate was looked at. Primary statistics: ER and GR (Theorem 1, kmax = 20)
# and ABC with the IC*_1 penalty, against the production r = 5:
#   supports underestimation <=> all three > 5
#   does not support         <=> all three <= 5
#   mixed                    otherwise
# Corollary 1 (k >= 0), the kmax2 bound, the doubly demeaned panel, IC*_2 and
# the permutation distribution are reported and never enter the verdict.
#
# ABC CHOICES THE PAPER LEAVES OPEN, fixed here: nested cross-section subsamples
# n_j = floor(3N/4)..N, no time subsamples, c in (0, 5] by 0.01 -- the paper's
# simulation design (sec. 4). The nesting follows one random permutation of the
# columns (seed SPEC$bootstrap_seed), because the CSV groups series by block and
# its own order would drop whole blocks; 100 permutations give the sensitivity.
#
# THE factorselect PACKAGE IS NOT THE ESTIMATOR. Its GR and ABC diverge from the
# papers (audit in notas/2026-09-10_selecao_fatores_ah_abc.md); it runs here only
# as the audited comparator, pinned to the audited commit.
#
# Outputs: output/factors/factor_selection_alt.{csv,md,pdf}
#          output/factors/factor_selection_alt_abc.csv
#          output/factors/factor_selection_alt_summary.csv
# ===================================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/factor_selection.R")
source("R/modeling/production_spec.R")
source("R/identification/spec_sweep.R")

SPEC             <- production_spec()
KMAX             <- 20L   # the grid of the production Bai-Ng surface
N_PERM           <- 100L
FACTORSELECT_SHA <- "f0f08d5953488bf2c0db0aa8b341b16e5f28dc7c"
OUT_DIR          <- "output/factors"


# ---- Data and the BLL object -----------------------------------------

panel <- readr::read_csv(SPEC$data_path, show_col_types = FALSE) |>
  dplyr::filter(ref.date >= SPEC$sample[1], ref.date <= SPEC$sample[2]) |>
  dplyr::select(-ref.date) |>
  as.matrix()

bll <- estimate_static_factors(panel, r = SPEC$r)
yy  <- bll$yy
n_T <- nrow(yy)
N   <- ncol(yy)


# ---- Self-tests: this is the object behind the production surface -----

saved_bn <- readr::read_csv(SPEC$bai_ng_output, show_col_types = FALSE)
saved_ic <- as.matrix(saved_bn[, c("IC1", "IC2", "IC3")])

# (a) the production call still reproduces the saved surface
bn    <- bai_ng_criteria(panel, max_r = KMAX, apply_bll = TRUE)
dev_a <- max(abs(do.call(cbind, bn$criteria) - saved_ic))
stopifnot(dev_a < 1e-12, identical(unname(unlist(bn$r_hat)), c(5L, 5L, 20L)))

# (b) log V(k) of `yy` plus the Bai-Ng penalties is that same surface
ah   <- ahn_horenstein(yy, KMAX)
e_NT <- (N + n_T) / (N * n_T)
bn_penalty <- c(IC1 = e_NT * log(1 / e_NT), IC2 = e_NT * log(min(N, n_T)),
                IC3 = log(min(N, n_T)) / min(N, n_T))
dev_b <- max(abs(log(ah$surface$V[-1]) + outer(seq_len(KMAX), bn_penalty) - saved_ic))
stopifnot(dev_b < 1e-10)

# (c) its spectrum is the one the production static factors are taken from
dev_c <- max(abs(ah$surface$mu[1 + seq_len(SPEC$r)] * N * n_T / (n_T - 1) /
                   bll$eigenvalues - 1))
stopifnot(dev_c < 1e-10)

# (d) the two forms of GR in AH sec. 2 agree
V     <- ah$surface$V
k_in  <- seq_len(KMAX - 1)
dev_d <- max(abs(log(V[k_in] / V[k_in + 1]) / log(V[k_in + 1] / V[k_in + 2]) -
                   ah$surface$GR[k_in + 1]))
stopifnot(dev_d < 1e-12)

# (f) the doubly demeaned panel AH recommend (sec. 2): `yy` is column-centred,
# so removing the time means is exact
yy_dd <- yy - rowMeans(yy)
dev_f <- max(abs(c(colMeans(yy_dd), rowMeans(yy_dd))))
stopifnot(dev_f < 1e-12)


# ---- Ahn-Horenstein --------------------------------------------------

ah_dd      <- ahn_horenstein(yy_dd, KMAX)
pos_kmax2  <- 1 + seq_len(ah$kmax2)
k_er_kmax2 <- which.max(ah$surface$ER[pos_kmax2])
k_gr_kmax2 <- which.max(ah$surface$GR[pos_kmax2])


# ---- Alessi-Barigozzi-Capasso ----------------------------------------

# One stream of permutations; its first draw is the pre-registered primary order
set.seed(SPEC$bootstrap_seed)
perms <- replicate(N_PERM, sample.int(N), simplify = FALSE)
abc1  <- abc_criterion(yy, KMAX, "IC1", perms[[1]])
abc2  <- abc_criterion(yy, KMAX, "IC2", perms[[1]])

# (e) the full-sample row of ABC at c = 1 is plain Bai-Ng IC1 over k = 0..KMAX
c_one <- which.min(abs(abc1$path$c - 1))
dev_e <- abs(abc1$path$r_full[c_one] -
               (which.min(log(ah$surface$V) + (0:KMAX) * bn_penalty["IC1"]) - 1))
stopifnot(dev_e == 0)

abc_perm <- purrr::map(perms, function(p) {
  tibble::tibble(IC1 = abc_criterion(yy, KMAX, "IC1", p)$r_hat,
                 IC2 = abc_criterion(yy, KMAX, "IC2", p)$r_hat)
}) |>
  dplyr::bind_rows()

perm_freq <- abc_perm |>
  tidyr::pivot_longer(dplyr::everything(), names_to = "penalidade", values_to = "r_hat") |>
  dplyr::count(penalidade, r_hat)


# ---- Numerical audit of factorselect, the comparator -------------------

stopifnot(packageDescription("factorselect")$RemoteSha == FACTORSELECT_SHA)
# On `yy` (column-centred, unit variance) the package's "individual" demeaning
# and its standardization are numerical no-ops: it reads the same object.
pkg <- factorselect::select_factors(yy, method = c("ahn_horenstein", "bai_ng", "abc"),
                                    kmax = KMAX, demean = "individual",
                                    standardize = TRUE)
pkg_ah <- pkg$details$ahn_horenstein
dev_er <- max(abs(pkg_ah$er / ah$surface$ER[-1] - 1))
dev_gr <- max(abs(pkg_ah$gr / ah$surface$GR[-1] - 1))

# The package's GR is exactly mu_k / V_trunc(k - 2): V summed only up to
# kmax + 1 and prefixed with V(0) twice (ahn_horenstein.R:57-59 @ f0f08d5)
e_pkg       <- pkg$eigenvalues
V_trunc     <- rev(cumsum(rev(e_pkg)))
mu_star_pkg <- e_pkg / V_trunc[pmax(seq_along(e_pkg) - 1, 1)]
dev_gr_bug  <- max(abs(log1p(mu_star_pkg[-(KMAX + 1)]) / log1p(mu_star_pkg[-1]) -
                         pkg_ah$gr))
dev_ic_pkg  <- max(abs(do.call(cbind, pkg$details$bai_ng[c("ic1", "ic2", "ic3")])[-1, ] -
                         saved_ic))
stopifnot(dev_er < 1e-10, dev_gr_bug < 1e-12, dev_ic_pkg < 1e-10)


# ---- The pre-registered reading ---------------------------------------

primary <- c(ER = ah$k_er, GR = ah$k_gr, ABC_IC1 = abc1$r_hat)
verdict <- if (all(primary > SPEC$r)) {
  "apoia subestimação"
} else if (all(primary <= SPEC$r)) {
  "não apoia subestimação"
} else {
  "misto"
}


# ---- Tables ----------------------------------------------------------

surface <- ah$surface |>
  dplyr::mutate(ER_dd = ah_dd$surface$ER, GR_dd = ah_dd$surface$GR,
                ER_pkg = c(NA, pkg_ah$er), GR_pkg = c(NA, pkg_ah$gr)) |>
  dplyr::left_join(dplyr::rename(saved_bn, k = r), by = "k")

abc_path <- dplyr::bind_rows(IC1 = abc1$path, IC2 = abc2$path, .id = "penalty")

kmax2_lab <- sprintf("kmax2 = %d", ah$kmax2)
summary_tbl <- tibble::tribble(
  ~estimador,                       ~variante,                      ~k_grade, ~r_hat,                    ~no_veredito,
  "Bai-Ng IC1",                     "produção (BLL)",               "1..20",  bn$r_hat$IC1,              FALSE,
  "Bai-Ng IC2",                     "produção (BLL)",               "1..20",  bn$r_hat$IC2,              FALSE,
  "Bai-Ng IC3",                     "produção (BLL)",               "1..20",  bn$r_hat$IC3,              FALSE,
  "AH ER",                          "Teorema 1",                    "1..20",  ah$k_er,                   TRUE,
  "AH GR",                          "Teorema 1",                    "1..20",  ah$k_gr,                   TRUE,
  "ABC IC*1",                       "permutação principal",         "0..20",  abc1$r_hat,                TRUE,
  "ABC IC*2",                       "permutação principal",         "0..20",  abc2$r_hat,                FALSE,
  "AH ER",                          "Corolário 1 (k = 0 admitido)", "0..20",  ah$k_er0,                  FALSE,
  "AH GR",                          "Corolário 1 (k = 0 admitido)", "0..20",  ah$k_gr0,                  FALSE,
  "AH ER",                          kmax2_lab,                      kmax2_lab, k_er_kmax2,               FALSE,
  "AH GR",                          kmax2_lab,                      kmax2_lab, k_gr_kmax2,               FALSE,
  "AH ER",                          "duplamente centrado",          "1..20",  ah_dd$k_er,                FALSE,
  "AH GR",                          "duplamente centrado",          "1..20",  ah_dd$k_gr,                FALSE,
  "factorselect 'ahn_horenstein'",  "pacote: é o GR divergente",    "1..20",  pkg$k[["ahn_horenstein"]], FALSE,
  "factorselect ER",                "pacote",                       "1..20",  pkg_ah$k_er,               FALSE,
  "factorselect 'abc' (abc1)",      "pacote: moda sobre c em [0,1]", "0..20", pkg$k[["abc"]],            FALSE,
  "factorselect abc2",              "pacote: moda sobre c em [0,1]", "0..20", pkg$details$abc$k_abc2,    FALSE,
  "factorselect 'bai_ng' (IC1)",    "pacote",                       "0..20",  pkg$k[["bai_ng"]],         FALSE
)

self_tests <- tibble::tribble(
  ~teste,                                                                      ~desvio_max, ~tolerancia,
  "(a) bai_ng_criteria(apply_bll = TRUE) contra a superfície salva",          dev_a,       1e-12,
  "(b) log V(k) de yy + penalidades Bai-Ng contra a superfície salva",         dev_b,       1e-10,
  "(c) mu_k·NT/(T-1) contra os autovalores de estimate_static_factors (k = 1..5), relativo", dev_c, 1e-10,
  "(d) GR via mu* contra ln[V(k-1)/V(k)] / ln[V(k)/V(k+1)]",                  dev_d,       1e-12,
  "(e) ABC, amostra cheia, c = 1, contra o argmin de IC1 em k = 0..20",       dev_e,       0,
  "(f) médias de linha e de coluna do painel duplamente centrado",           dev_f,       1e-12
)

audit_tbl <- tibble::tribble(
  ~quantidade,                                                  ~pacote,                 ~paper,       ~desvio_max,
  "ER(k), k = 1..20: desvio relativo",                          NA,                      NA,           dev_er,
  "GR(k), k = 1..20: desvio relativo",                          NA,                      NA,           dev_gr,
  "argmax de ER",                                               pkg_ah$k_er,             ah$k_er,      NA,
  "argmax de GR",                                               pkg_ah$k_gr,             ah$k_gr,      NA,
  "GR do pacote contra mu_k / V_trunc(k - 2)",                  NA,                      NA,           dev_gr_bug,
  "IC1-IC3 do pacote contra a superfície de produção",          NA,                      NA,           dev_ic_pkg,
  "ABC com IC1: moda sobre c em [0,1] contra 2º intervalo",     pkg$details$abc$k_abc1,  abc1$r_hat,   NA,
  "ABC com IC2: moda sobre c em [0,1] contra 2º intervalo",     pkg$details$abc$k_abc2,  abc2$r_hat,   NA
)

intervals_tbl <- dplyr::bind_rows(`IC*1` = abc1$intervals, `IC*2` = abc2$intervals,
                                  .id = "penalidade")

readr::write_csv(surface, file.path(OUT_DIR, "factor_selection_alt.csv"))
readr::write_csv(abc_path, file.path(OUT_DIR, "factor_selection_alt_abc.csv"))
readr::write_csv(summary_tbl, file.path(OUT_DIR, "factor_selection_alt_summary.csv"))


# ---- Report ----------------------------------------------------------

abc_line <- function(abc, label) {
  sprintf(paste("%s: r̂ = %d no intervalo c ∈ [%.2f, %.2f]; primeiro intervalo em",
                "r_max = %d: %s; r̂ na amostra cheia em c = %.2f: %d."),
          label, abc$r_hat, abc$c_interval[1], abc$c_interval[2], KMAX,
          ifelse(abc$first_at_kmax, "sim", "NÃO"), max(abc$path$c),
          abc$path$r_full[nrow(abc$path)])
}

sections <- c(
  "# Número de fatores `r`: Ahn-Horenstein (ER/GR) e Alessi-Barigozzi-Capasso contra Bai-Ng",
  "",
  sprintf("Gerado por `script/factor_selection_alt.R` em %s.", format(Sys.Date(), "%Y-%m-%d")),
  paste("**Corpo gerado — não escrever prosa aqui.** A leitura e a auditoria do",
        "pacote `factorselect` vivem em `notas/2026-09-10_selecao_fatores_ah_abc.md`."),
  "",
  "## Objeto e grade",
  "",
  sprintf(paste("Painel de produção `%s`, %s a %s, %d séries. Objeto: primeiras diferenças",
                "padronizadas BLL (`estimate_static_factors()$yy`, o mesmo `X_std` de",
                "`bai_ng_criteria(apply_bll = TRUE)`), com T = %d, N = %d e m = min(N, T) = %d.",
                "Grade k = 1..%d, a da superfície Bai-Ng de produção."),
          SPEC$panel_name, SPEC$sample[1], SPEC$sample[2], N, n_T, N, min(N, n_T), KMAX),
  "",
  "## Auto-testes",
  "",
  md_table(as.data.frame(self_tests), digits = 3),
  "",
  "## Resultado e veredito pré-registrado",
  "",
  paste("Regra fixada antes de olhar as estimativas: ER, GR (Teorema 1, kmax = 20) e",
        "ABC-IC*1 todos > 5 → *apoia subestimação*; todos ≤ 5 → *não apoia*; o resto é",
        "*misto*. Linhas com `no_veredito = FALSE` são reportadas e não decidem."),
  "",
  md_table(as.data.frame(summary_tbl)),
  "",
  sprintf(paste("**Veredito: %s** (ER = %d, GR = %d, ABC-IC*1 = %d; Bai-Ng de produção",
                "IC1 = %d, IC2 = %d, IC3 = %d)."),
          verdict, ah$k_er, ah$k_gr, abc1$r_hat, bn$r_hat$IC1, bn$r_hat$IC2, bn$r_hat$IC3),
  "",
  "## Superfície por k",
  "",
  paste("`mu` é ψ_k[X'X/(NT)] — em k = 0, o autovalor fictício V(0)/ln m da eq. (4) de",
        "AH; `V` é V(k) = Σ_{j>k} mu_j sobre o espectro inteiro. `_dd` é o painel",
        "duplamente centrado; `ER_pkg`/`GR_pkg` são os do `factorselect`, para",
        "comparação. IC1-IC3 são a superfície de produção, que não tem k = 0."),
  "",
  md_table(as.data.frame(surface |>
                           dplyr::select(k, mu, V, ER, GR, ER_dd, GR_dd, GR_pkg,
                                         IC1, IC2, IC3)), digits = 5),
  "",
  "## ABC: intervalos de estabilidade",
  "",
  sprintf(paste("Subamostras aninhadas n_j = %d..%d (J = %d) numa permutação fixa das",
                "colunas (seed %d), sem subamostra temporal; c ∈ (0, 5] com passo 0,01.",
                "Intervalo de estabilidade é uma sequência de c consecutivos com S_c = 0",
                "e o mesmo r̂ na amostra cheia; o escolhido é o primeiro com r̂ < %d.",
                "`n_grid` é o número de pontos da grade no intervalo; o paper não fixa",
                "duração mínima."),
          floor(3 * N / 4), N, nrow(abc1$r_by_sub), SPEC$bootstrap_seed, KMAX),
  "",
  md_table(as.data.frame(intervals_tbl)),
  "",
  abc_line(abc1, "IC*1"),
  "",
  abc_line(abc2, "IC*2"),
  "",
  sprintf("### Sensibilidade à ordem das colunas: %d permutações do mesmo fluxo de seed", N_PERM),
  "",
  md_table(as.data.frame(perm_freq)),
  "",
  "## Auditoria numérica do `factorselect`",
  "",
  sprintf(paste("Pacote instalado @ `%s`, conferido por `packageDescription()`, rodado",
                "sobre o mesmo `yy` com `demean = \"individual\"` e `standardize = TRUE`",
                "(neutros sobre `yy`) e kmax = %d. É comparador, não estimativa."),
          FACTORSELECT_SHA, KMAX),
  "",
  md_table(as.data.frame(audit_tbl), digits = 4),
  "",
  "Figura em `factor_selection_alt.pdf`."
)

writeLines(sections, file.path(OUT_DIR, "factor_selection_alt.md"))


# ---- Figure ----------------------------------------------------------

fig_k <- surface |>
  dplyr::filter(k >= 1) |>
  dplyr::select(k, ER, GR, GR_pkg, IC1, IC2, IC3) |>
  tidyr::pivot_longer(-k, names_to = "criterio", values_to = "valor") |>
  dplyr::mutate(
    painel = dplyr::case_when(
      criterio == "ER" ~ "ER(k): maximo",
      criterio %in% c("GR", "GR_pkg") ~ "GR(k): maximo",
      TRUE ~ "Bai-Ng BLL de producao: minimo"
    ),
    criterio = dplyr::recode(criterio, GR_pkg = "GR factorselect (divergente)")
  )

chosen_k <- fig_k |>
  dplyr::group_by(criterio) |>
  dplyr::filter(dplyr::if_else(criterio %in% c("IC1", "IC2", "IC3"),
                               valor == min(valor), valor == max(valor))) |>
  dplyr::ungroup()

p_k <- ggplot2::ggplot(fig_k, ggplot2::aes(k, valor, colour = criterio)) +
  ggplot2::geom_vline(xintercept = SPEC$r, linetype = "dotted", colour = "grey50") +
  ggplot2::geom_line() +
  ggplot2::geom_point(data = chosen_k, size = 2.5) +
  ggplot2::facet_wrap(~painel, scales = "free_y") +
  ggplot2::scale_x_continuous(breaks = c(1, 5, 10, 15, 20)) +
  ggplot2::labs(
    title = "Numero de fatores: Ahn-Horenstein contra a superficie Bai-Ng de producao",
    subtitle = sprintf(paste("Primeiras diferencas padronizadas BLL, T = %d, N = %d;",
                             "pontos marcam o k escolhido; pontilhado em r = %d (producao)"),
                       n_T, N, SPEC$r),
    x = "numero de fatores k", y = NULL, colour = NULL
  ) +
  ggplot2::theme_classic(base_size = 10) +
  ggplot2::theme(legend.position = "bottom")

fig_abc <- abc_path |>
  dplyr::select(penalty, c, r_full, S_c) |>
  tidyr::pivot_longer(c(r_full, S_c), names_to = "serie", values_to = "valor") |>
  dplyr::mutate(serie = dplyr::recode(serie, r_full = "r_hat na amostra cheia",
                                      S_c = "S_c (variancia entre subamostras)"))

chosen_c <- tibble::tibble(
  penalty = c("IC1", "IC2"),
  c_lo = c(abc1$c_interval[1], abc2$c_interval[1]),
  c_hi = c(abc1$c_interval[2], abc2$c_interval[2]),
  r_hat = c(abc1$r_hat, abc2$r_hat)
)

p_abc <- ggplot2::ggplot(fig_abc, ggplot2::aes(c, valor, linetype = serie)) +
  ggplot2::geom_rect(data = chosen_c,
                     ggplot2::aes(xmin = c_lo, xmax = c_hi, ymin = -Inf, ymax = Inf),
                     inherit.aes = FALSE, fill = "grey85") +
  ggplot2::geom_step() +
  ggplot2::geom_text(data = chosen_c,
                     ggplot2::aes(x = c_hi + 0.08, y = r_hat + 1.5,
                                  label = paste("r_hat =", r_hat)),
                     inherit.aes = FALSE, size = 3.2, hjust = 0) +
  ggplot2::facet_wrap(~penalty, ncol = 1,
                      labeller = ggplot2::as_labeller(c(IC1 = "ABC com IC*1 (principal)",
                                                        IC2 = "ABC com IC*2"))) +
  ggplot2::labs(
    title = "Alessi-Barigozzi-Capasso: estabilidade de r_hat na constante de ajuste c",
    subtitle = sprintf(paste("Subamostras aninhadas n_j = %d..%d em permutacao fixa (seed %d);",
                             "sombreado = intervalo escolhido (primeiro com r_hat < %d)"),
                       floor(3 * N / 4), N, SPEC$bootstrap_seed, KMAX),
    x = "constante de ajuste c", y = NULL, linetype = NULL
  ) +
  ggplot2::theme_classic(base_size = 10) +
  ggplot2::theme(legend.position = "bottom")

pdf(file.path(OUT_DIR, "factor_selection_alt.pdf"), width = 10, height = 6)
print(p_k)
print(p_abc)
invisible(dev.off())
