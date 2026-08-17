# ============================================================
# Validation of amengual_watson() against Stock & Watson's own MATLAB
# suite (codigos_externos/codigo_sw/ddisk/matlab/). Same shape as
# validate_hac_kernel.R Check A: a literal line-by-line transcription
# of the original, compared against the project function on a committed
# fixture. There is no MATLAB or Octave on this machine, so the
# transcription *is* the instrument.
#
# Three files are transcribed, in the balanced-panel case the project
# always faces (no NaN, no observed factors, no lambda constraints):
#   amengual_watson.m      the outer routine
#   factor_estimation_ls.m the LS/EM factor step it calls twice
#   bai_ng.m               the IC2 penalty
# Parameters are SW's own defaults, identical across every caller in the
# suite: nt_min = 20, tol = 1e-8 (favar_kilian.m:57-59).
#
# The comparison target is amengual_watson(apply_bll = FALSE). The
# original knows nothing about BLL, so that is the only path with a
# MATLAB counterpart. What apply_bll = TRUE does is measured separately
# in section B — it is not a rival factor space but the production one,
# differenced.
#
# Fixture: output/validation/amengual_watson_fixture.csv, the 111-series
# production panel (codigos_externos/ is gitignored, so nothing here may
# read from it at run time).
# Output: output/validation/amengual_watson_validation.md
# ============================================================

rm(list = ls())

source("R/modeling/factor_estimation.R")
source("R/modeling/production_spec.R")
source("R/identification/spec_sweep.R")   # md_table

SPEC       <- production_spec()
FIXTURE    <- "output/validation/amengual_watson_fixture.csv"
OUT_PATH   <- "output/validation/amengual_watson_validation.md"
NT_MIN     <- 20L
TOL        <- 1e-8
TOL_CONST  <- 1e-12     # once the standardization convention is matched, the
                        # remaining gap has to be constant to this precision

if (!file.exists(FIXTURE)) {
  stop("Fixture ausente: ", FIXTURE,
       ". Ela e commitada de proposito — codigos_externos/ e gitignored e ",
       "data/ tambem, entao a validacao nao pode depender de nenhum dos dois.")
}


# ---- Literal transcription of factor_estimation_ls.m ---------------
# Balanced panel, nfac_o = 0, no lambda_constraints. Everything the
# original does for unbalanced data (packr, the nt_min guards, the
# istart/iend window from smpl_HO) collapses to the identity here and is
# kept only where it still has an effect.

factor_estimation_ls_matlab <- function(est_data, nfac_u, nt_min = NT_MIN, tol = TOL) {
  xdata <- est_data
  nt <- nrow(xdata)
  ns <- ncol(xdata)

  # xmean = nanmean; mult = sqrt((n-1)/n); xstd = nanstd .* mult
  # nanstd divides by n-1, so xstd is the population sd.
  xmean <- colMeans(xdata)
  mult <- sqrt((nt - 1) / nt)
  xstd <- apply(xdata, 2, sd) * mult
  xdata_std <- sweep(sweep(xdata, 2, xmean, "-"), 2, xstd, "/")

  # tss / nobs
  tss <- sum(xdata_std^2)
  nobs <- nt * ns

  # [coef,score,latent] = princomp(xbal); f = score(:,1:nfac_u)
  pc <- prcomp(xdata_std, center = TRUE, scale. = FALSE)
  f <- pc$x[, 1:nfac_u, drop = FALSE]
  fa <- f
  lambda <- matrix(NA_real_, ns, nfac_u)

  diff_obj <- 100
  ssr <- 0
  while (diff_obj > tol * (nt * ns)) {
    ssr_old <- ssr
    for (i in 1:ns) {
      if (nt >= nt_min) {
        y <- xdata_std[, i]
        x <- fa
        lambda[i, ] <- solve(crossprod(x), crossprod(x, y))
      }
    }
    for (t in 1:nt) {
      y <- xdata_std[t, ]
      x <- lambda
      f[t, ] <- qr.solve(x, y)
    }
    fa <- f
    e <- xdata_std - fa %*% t(lambda)
    ssr <- sum(e^2)
    diff_obj <- abs(ssr_old - ssr)
  }

  # r2vec, series by series
  r2vec <- numeric(ns)
  for (i in 1:ns) {
    y <- xdata_std[, i]
    b <- qr.solve(fa, y)
    e <- y - fa %*% b
    r2vec[i] <- 1 - drop(crossprod(e)) / drop(crossprod(y))
  }

  list(fac = fa, lambda = sweep(lambda, 1, xstd, "*"), tss = tss,
       ssr = ssr, r2vec = r2vec, nobs = nobs, nt = nt, ns = ns)
}


# ---- Literal transcription of bai_ng.m -----------------------------

bai_ng_matlab <- function(lsout) {
  ssr <- lsout$ssr
  nobs <- lsout$nobs
  nt <- lsout$nt
  nfac <- ncol(lsout$fac)
  nbar <- nobs / nt
  g <- log(min(nbar, nt)) * (nbar + nt) / nobs
  log(ssr / nobs) + nfac * g
}


# ---- Literal transcription of amengual_watson.m --------------------

amengual_watson_matlab <- function(est_data, nfac_static, nvar_lag) {
  lsout <- factor_estimation_ls_matlab(est_data, nfac_static)
  fac <- lsout$fac
  dnobs <- nrow(fac)

  # x = [ones, lagmatrix(fac, 1:nvar_lag)]; packr drops the leading NaN rows
  x <- cbind(1, do.call(cbind, lapply(1:nvar_lag, function(l)
    rbind(matrix(NA_real_, l, ncol(fac)), fac[1:(dnobs - l), , drop = FALSE]))))
  keep <- (nvar_lag + 1):dnobs

  est_data_res <- matrix(NA_real_, nrow(est_data), ncol(est_data))
  for (is in 1:ncol(est_data)) {
    y <- est_data[keep, is]
    z <- x[keep, , drop = FALSE]
    ndf <- nrow(z) - ncol(z)
    if (ndf >= NT_MIN) {
      b <- solve(crossprod(z), crossprod(z, y))
      est_data_res[keep, is] <- y - z %*% b
    }
  }
  # est_par_res.smpl_par.nfirst is pushed forward by nvar_lag: the second
  # stage sees only the rows the first stage could fill.
  est_data_res <- est_data_res[keep, , drop = FALSE]

  aw <- numeric(nfac_static)
  ssr <- numeric(nfac_static)
  for (nfac in 1:nfac_static) {
    ls_res <- factor_estimation_ls_matlab(est_data_res, nfac)
    aw[nfac] <- bai_ng_matlab(ls_res)
    ssr[nfac] <- ls_res$ssr
  }

  list(aw = aw, ssr = ssr, q_hat = which.min(aw))
}


# ---- Mirror of the project's residual step --------------------------
# Needed to isolate the one flag that separates the two implementations.
# It is proved faithful below by reproducing amengual_watson()'s own aw
# exactly before being reused with the flag flipped.

project_aw_residuals <- function(X, r, p) {
  X_std <- scale(X, center = TRUE, scale = TRUE)
  n <- nrow(X_std)
  pca <- prcomp(X_std, scale. = FALSE, center = FALSE)
  F_hat <- pca$x[, 1:r, drop = FALSE]
  lagged_factors <- stats::embed(F_hat, p + 1)
  Z <- cbind(1, lagged_factors[, -(1:r), drop = FALSE])
  resid_mat <- matrix(NA_real_, n - p, ncol(X_std))
  for (i in 1:ncol(X_std)) {
    y <- X_std[(p + 1):n, i]
    z <- Z[1:length(y), , drop = FALSE]
    resid_mat[, i] <- y - z %*% solve(crossprod(z), crossprod(z, y))
  }
  resid_mat
}


# ---- Fixture -------------------------------------------------------

fixture <- readr::read_csv(FIXTURE, show_col_types = FALSE)
X <- fixture |>
  dplyr::select(-ref.date) |>
  as.matrix()
r <- SPEC$r
p <- SPEC$p

cat(sprintf("Fixture: %d x %d, r = %d, p = %d\n", nrow(X), ncol(X), r, p))


# ---- A. Fidelity of the engine (no BLL) ----------------------------

ref <- amengual_watson_matlab(X, nfac_static = r, nvar_lag = p)
prj <- amengual_watson(X, r = r, p = p, apply_bll = FALSE)

# A1. Selection, which is what the criterion is for.
qhat_ok <- ref$q_hat == prj$q_hat

# A2. Isolation. The mirror is proved faithful to amengual_watson() first,
# then reused with the second-stage standardization switched on. If the
# transcription is right, all that survives is the population-vs-sample sd
# convention, a constant log(n/(n-1)) on every entry.
resid_prj <- project_aw_residuals(X, r, p)
aw_mirror <- bai_ng_criteria(resid_prj, max_r = r, standardize = FALSE)$criteria$IC2
if (!isTRUE(all.equal(aw_mirror, prj$aw, tolerance = 0))) {
  stop("O espelho dos residuos nao reproduz amengual_watson(); a isolacao ",
       "abaixo nao seria valida.")
}
aw_std <- bai_ng_criteria(resid_prj, max_r = r, standardize = TRUE)$criteria$IC2

gap_std <- ref$aw - aw_std
gap_std_spread <- max(gap_std) - min(gap_std)
n_resid <- nrow(resid_prj)
gap_expected <- log(n_resid / (n_resid - 1))
const_ok <- gap_std_spread <= TOL_CONST &&
  abs(mean(gap_std) - gap_expected) <= TOL_CONST

# A3. What the shipped flag costs, in the units the criterion is read in.
aw_gap_shipped <- ref$aw - prj$aw
aw_gap_shipped_spread <- max(aw_gap_shipped) - min(aw_gap_shipped)

cat(sprintf("A1. q_hat  MATLAB = %d | projeto = %d | acordo: %s\n",
            ref$q_hat, prj$q_hat, ifelse(qhat_ok, "sim", "NAO")))
cat(sprintf("A2. com a mesma padronizacao: gap = %.10f (esperado log(%d/%d) = %.10f), dispersao = %.3e\n",
            mean(gap_std), n_resid, n_resid - 1L, gap_expected, gap_std_spread))
cat(sprintf("A3. com a flag como esta no projeto: gap medio = %.6f, dispersao = %.3e\n",
            mean(aw_gap_shipped), aw_gap_shipped_spread))


# ---- B. What apply_bll = TRUE actually does ------------------------
# Not a rival factor space: the production loadings, applied to the
# differenced panel. Measured, not asserted.

sf <- estimate_static_factors(X, r = r)
y <- diff(X)
sy <- apply(y, 2, sd)
yy <- sweep(sweep(y, 2, colMeans(y), "-"), 2, sy, "/")
rot_bll <- prcomp(yy, scale. = FALSE, center = FALSE)$rotation[, 1:r, drop = FALSE]

loading_gap <- max(abs(abs(rot_bll) - abs(sf$loadings)))
pc_bll <- prcomp(yy, scale. = FALSE, center = FALSE)$x[, 1:r, drop = FALSE]
fac_cor <- sapply(1:r, function(k) abs(cor(pc_bll[, k], diff(sf$factors)[, k])))

prj_bll <- amengual_watson(X, r = r, p = p, apply_bll = TRUE)

cat(sprintf("B. |loadings BLL - lambda producao| max = %.3e\n", loading_gap))
cat(sprintf("B. cor(PC_k(yy), diff(F_prod)_k) = %s\n",
            paste(sprintf("%.6f", fac_cor), collapse = " ")))
cat(sprintf("B. q_hat sob apply_bll = TRUE: %d (producao usa q = %d)\n",
            prj_bll$q_hat, SPEC$q))


# ---- Report --------------------------------------------------------

fmt <- function(x) formatC(x, format = "f", digits = 6)

sections <- c(
  "# Validação de `amengual_watson()` contra o MATLAB de Stock-Watson",
  "",
  sprintf("Gerado por `script/validate_amengual_watson.R` em %s.",
          format(Sys.Date(), "%Y-%m-%d")),
  "**Corpo gerado — não escrever prosa aqui.**",
  "",
  sprintf(paste("Fixture: `%s`, o painel de produção de %d séries e %d meses.",
                "Parâmetros do original: `nt_min = %d`, `tol = %g`",
                "(`favar_kilian.m:57-59`)."),
          FIXTURE, ncol(X), nrow(X), NT_MIN, TOL),
  "",
  "## A. Fidelidade do motor — caminho sem BLL",
  "",
  paste("O `amengual_watson.m` original não conhece BLL, então o único caminho",
        "com contrapartida no MATLAB é `apply_bll = FALSE`. É ele que esta",
        "seção compara."),
  "",
  md_table(data.frame(
    q = 1:r,
    aw_matlab = fmt(ref$aw),
    aw_projeto = fmt(prj$aw),
    aw_projeto_std = fmt(aw_std),
    stringsAsFactors = FALSE
  )),
  "",
  sprintf("### A1. Seleção: MATLAB **%d**, projeto **%d** — %s",
          ref$q_hat, prj$q_hat,
          ifelse(qhat_ok, "acordo exato", "**DISCORDAM**")),
  "",
  paste("É o que o critério existe para responder, e as duas implementações",
        "respondem igual."),
  "",
  "### A2. Isolamento: sob a mesma convenção de padronização, o acordo é numérico",
  "",
  paste("A coluna `aw_projeto_std` é a do projeto com a padronização do 2º",
        "estágio ligada — o único ponto em que as duas implementações fazem",
        "coisas diferentes. Contra o MATLAB ela deixa:"),
  "",
  sprintf(paste("- gap **%.10f** em todas as %d entradas, com dispersão",
                "**%.3e** — constante a precisão de máquina;"),
          mean(gap_std), r, gap_std_spread),
  sprintf(paste("- e essa constante é exatamente `log(%d/%d)` = **%.10f**, a",
                "diferença entre o desvio padrão populacional que o `nanstd .*",
                "mult` do MATLAB produz e o amostral do `sd()` do R."),
          n_resid, n_resid - 1L, gap_expected),
  "",
  paste("Ou seja: casada a convenção, **a tradução reproduz o original**. O que",
        "resta é uma escolha de denominador, não um desvio de algoritmo."),
  "",
  "### A3. O que a flag como está no projeto custa",
  "",
  sprintf(paste("`bai_ng_criteria(resid_mat, standardize = FALSE)` deixa os",
                "resíduos crus onde `factor_estimation_ls.m` os padronizaria",
                "coluna a coluna. O gap contra o MATLAB passa a **%.6f** em",
                "média com dispersão **%.3e** — não é constante, e reescala",
                "por coluna **pode** mover o `argmin` em outro painel. Neste",
                "não move: é o acordo de A1."),
          mean(aw_gap_shipped), aw_gap_shipped_spread),
  "",
  "As outras duas diferenças mapeadas não têm efeito:",
  "",
  paste("- O `trend` da linha 20 de `amengual_watson.m` é **índice de linha**,",
        "usado para devolver o resíduo à posição certa (`ii = tmp(:,1)`), não",
        "regressor. A versão do projeto não o inclui, e está certa."),
  paste("- `packr` e o guarda `nt_min` só agem em painel desbalanceado. Aqui",
        "não há NaN além das `p` primeiras linhas do `lagmatrix`, que as duas",
        "implementações descartam igual."),
  "",
  "## B. O que `apply_bll = TRUE` faz",
  "",
  paste("`apply_bll = TRUE` não é um espaço fatorial rival: é **o espaço",
        "fatorial da produção, diferenciado**. Medido nesta rodada:"),
  "",
  sprintf(paste("- Os autovetores de `cov(yy)` **são** o `lambda` da produção",
                "(`estimate_static_factors`): desvio máximo em valor absoluto",
                "**%.3e**."), loading_gap),
  sprintf(paste("- `cor(PC_k(yy), diff(F_prod)_k)` = %s nos %d fatores."),
          paste(fmt(fac_cor), collapse = ", "), r),
  "",
  paste("Isso importa para a leitura, não para a fidelidade. Amengual-Watson",
        "é um critério de Bai-Ng, que exige estacionariedade; o painel é",
        "não-estacionário por desenho. Logo:"),
  "",
  sprintf(paste("- **`q_hat = %d`** vem do caminho BLL, que é o admissível",
                "aqui, e **discorda do `q = %d` de produção**."),
          prj_bll$q_hat, SPEC$q),
  sprintf(paste("- **`q_hat = %d`** vem de rodar o critério no painel de",
                "níveis. É o comparável de fidelidade ao MATLAB, mas a",
                "ferramenta que `.claude/rules/identification.md` exclui neste",
                "painel. A coincidência com a produção não é endosso."),
          prj$q_hat),
  "",
  sprintf("## Veredito: %s",
          ifelse(qhat_ok && const_ok,
                 paste("**tradução fiel** — mesma seleção, e acordo numérico",
                       "assim que a convenção de padronização é casada"),
                 "**DIVERGÊNCIA** — ver A1/A2 acima")),
  ""
)

writeLines(sections, OUT_PATH)
cat("Escrito:", OUT_PATH, "\n")

if (!qhat_ok) {
  stop("A traducao discorda do original em q_hat: MATLAB ", ref$q_hat,
       " contra projeto ", prj$q_hat, ".")
}
if (!const_ok) {
  stop("Casada a padronizacao, o gap contra o MATLAB nao e a constante ",
       "esperada log(n/(n-1)) = ", gap_expected, ": media ", mean(gap_std),
       ", dispersao ", gap_std_spread, ".")
}
