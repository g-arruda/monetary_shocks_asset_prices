# ============================================================
# Validação da inversão Anderson-Rubin de R/identification/weak_iv_ar.R
# contra o código oficial de Montiel Olea-Stock-Watson
# (codigos_externos/codigo_olea/, github.com/jm4474/SVARIV), na
# aplicação do petróleo de Kilian (2009): VAR(24), n = 3, T = 356,
# norm = 1, scale = 1, NWlags = 0, horizons = 20.
#
# Com Load = Inner = I as três funções recaem no MOSW original, então
# esta validação exercita exatamente o código que roda no DFM: a
# convenção de vec(A), a recorrência de G_h, o Shat de
# CovAhat_Sigmahat_Gamma.m, a quadrática de MSWfunction.m e os quatro
# casedummy. O que ela NÃO cobre é a generalização em si (Load, Inner,
# d0 != e_nvar) — essa é conferida em script/ar_bands.R, onde o ponto
# reproduz output/irf/irf_coherence_h.csv e o coeficiente de lambda^2
# reproduz o xi_mp de output/instrument/mosw_strength_grid.csv.
#
# Fixture: output/validation/olea_oil_fixture.rds, extraído uma vez de
# codigos_externos/codigo_olea/Output/Oil/Mat/IRF_SVAR_p=24_OilData_{68,95}.mat
# (RForm + InferenceMSW + Plugin), porque codigo_olea/ é gitignorado e o
# .mat não pode ser assumido presente. Mesmo padrão de
# script/validate_hac_kernel.R. Procedência em
# notas/2026-08-10_bandas_anderson_rubin.md.
# ============================================================

source("R/identification/weak_iv_ar.R")

FIXTURE <- "output/validation/olea_oil_fixture.rds"
TOL     <- 1e-8

if (!file.exists(FIXTURE)) {
  cat("SKIPPED — fixture ausente:", FIXTURE, "\n")
  quit(save = "no", status = 0)
}

fx  <- readRDS(FIXTURE)
eta <- t(fx$eta)                       # MATLAB guarda n x T
X   <- fx$X                            # T x (1 + n*p), constante na 1a coluna
z   <- fx$z
n   <- fx$n
p   <- fx$p
hz  <- fx$horizons

cat(sprintf("Aplicação do petróleo: n = %d, p = %d, T = %d, horizontes = %d\n",
            n, p, nrow(eta), hz))


# ---- 1. Covariância assintótica de (vec(A), Gamma) -----------------

cv <- mosw_rform_cov(X, z, eta, p = p, nw_lags = fx$nw_lags)

dev_w <- max(abs(cv$WHat - fx$WHat)) / max(abs(fx$WHat))
cat(sprintf("1. WHat vs CovAhat_Sigmahat_Gamma.m      : %.3e (relativo)\n", dev_w))

Gamma <- drop(crossprod(eta, z)) / nrow(eta)
dev_g <- max(abs(Gamma - fx$Gamma))
cat(sprintf("   Gamma = eta z / T                     : %.3e\n", dev_g))

wald <- nrow(eta) * Gamma[fx$norm]^2 / cv$W2[fx$norm, fx$norm]
cat(sprintf("   Waldstat (alvo %.6f)               : %.6f\n", fx$Waldstat, wald))


# ---- 2. Respostas e derivadas --------------------------------------

I_n <- diag(n)
rd  <- mosw_response_derivatives(fx$AL, p = p, h = hz,
                                 Load = I_n, Inner = I_n, Gamma = Gamma)


# ---- 3. Limites AR e delta-method, nos dois níveis ------------------

cmp <- function(got, want, label) {
  ok  <- is.finite(got) & is.finite(want)
  dev <- max(abs(got[ok] - want[ok])) / max(1, max(abs(want[ok])))
  same_pattern <- all((is.finite(got) == is.finite(want)) & (is.nan(got) == is.nan(want)))
  cat(sprintf("   %-28s %.3e%s\n", label, dev,
              if (same_pattern) "" else "   [PADRÃO DE Inf/NaN DIFERE]"))
  c(dev = dev, pattern = as.numeric(same_pattern))
}

devs <- c()
for (lvl in c("68", "95")) {
  conf <- as.numeric(lvl) / 100
  cat(sprintf("\n%s. Nível %s%%\n", if (lvl == "68") "2" else "3", lvl))

  for (branch in c("", "cum")) {
    Cb  <- if (branch == "") rd$C  else rd$Ccum
    D1b <- if (branch == "") rd$D1 else rd$D1cum
    ar  <- mosw_ar_bounds(Cb, D1b, Gamma, cv, nvar = fx$norm,
                          scale = fx$scale, confidence = conf)

    sfx <- paste0(branch, "_", lvl)
    tag <- if (branch == "") "não-cum" else "cumulativa"
    cat(sprintf("  IRF %s\n", tag))

    devs <- c(devs,
      cmp(ar$point, fx[[paste0("plugin_irf", if (branch == "") "" else "cum")]],
          "Plugin.IRF")["dev"],
      cmp(ar$ahat,  fx[[paste0("ahat",  sfx)]], "ahat")["dev"],
      cmp(ar$bhat,  fx[[paste0("bhat",  sfx)]], "bhat")["dev"],
      cmp(ar$chat,  fx[[paste0("chat",  sfx)]], "chat")["dev"],
      cmp(ar$lo,    fx[[paste0("MSWlbound", sfx)]], "MSWlbound")["dev"],
      cmp(ar$hi,    fx[[paste0("MSWubound", sfx)]], "MSWubound")["dev"],
      cmp(ar$dm_lo, fx[[paste0("Dmethodlbound", sfx)]], "Dmethodlbound")["dev"],
      cmp(ar$dm_hi, fx[[paste0("Dmethodubound", sfx)]], "Dmethodubound")["dev"])

    # casedummy: a célula (norm, h = 0) é a normalização, onde Delta = 0
    # algebricamente e a classificação é ruído de ponto flutuante nos dois
    # códigos. Os limites ali são sobrescritos dos dois lados.
    cd_want <- fx[[paste0("casedummy", sfx)]]
    cd_got  <- ar$case
    cd_got[fx$norm, 1] <- cd_want[fx$norm, 1]
    n_bad <- sum(cd_got != cd_want)
    cat(sprintf("   %-28s %d célula(s) divergente(s) de %d\n",
                "casedummy", n_bad, length(cd_want)))
    devs <- c(devs, casedummy = n_bad)
  }
}


# ---- Veredito -------------------------------------------------------

cat("\n")
worst <- max(devs)
stopifnot(dev_w < TOL, dev_g < TOL, abs(wald - fx$Waldstat) < 1e-9, worst < TOL)
cat(sprintf(paste0("VALIDAÇÃO OK: WHat, Gamma, Waldstat, limites AR e ",
                   "delta-method reproduzem\no código oficial nos dois ramos e ",
                   "nos dois níveis; pior desvio %.1e.\n"), worst)
)
