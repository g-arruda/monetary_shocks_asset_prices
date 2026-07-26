# ===================================================================
# End-to-end pipeline orchestrator.
#
# Runs the ordered stages of the project, one OS process per stage. A
# separate process is mandatory, not cosmetic: most stage scripts start
# with `rm(list = ls())`, and the two downloader modules only execute
# their top-level block under `if (sys.nframe() == 0)`. Sourcing them in
# a shared session would either wipe the caller's environment or run
# nothing at all.
#
# Usage (always from the repository root):
#   Rscript script/run_all.R                     # full chain, network included
#   Rscript script/run_all.R --list              # stages, inputs, outputs, status
#   Rscript script/run_all.R --dry-run           # plan + preflight, runs nothing
#   Rscript script/run_all.R --from=clean        # from a stage to the end
#   Rscript script/run_all.R --to=instrument     # from the start to a stage
#   Rscript script/run_all.R --only=clean,instrument
#   Rscript script/run_all.R --skip=di,ibov
#   Rscript script/run_all.R --skip-existing     # skip stages whose outputs exist
#   Rscript script/run_all.R --continue-on-error
#
# NOTE on the yield curve — there is no fitting stage, on purpose.
# `data/yields/yields_dia.csv` is a FIXED EXTERNAL INPUT supplied by the
# advisor: it is the curve the panel is built on, `script/download.R`
# consumes it as given, and nothing here can regenerate it. The `download`
# stage declares it as a hard requirement so preflight aborts with a pointer
# if it ever goes missing. (`script/yield_curve.R`, an in-house Svensson fit
# on the DI contracts, was deleted on 2026-07-26 — it never produced good
# results and its output fed no stage; see `_instrucoes/historico_decisoes.md`
# section 4.)
# ===================================================================

RSCRIPT <- file.path(R.home("bin"), "Rscript")
LOG_DIR <- "output/logs"


# ---- Stage table ---------------------------------------------------
# requires: inputs with no producer inside the selected run (checked in
#           preflight); produces: outputs used by --skip-existing and by
#           the post-run report.

STAGES <- list(
  list(
    name     = "di",
    desc     = "DI futures panel from the pyield-data release (python)",
    interp   = "python3",
    file     = "R/data_download/download_di.py",
    network  = TRUE,
    requires = character(),
    produces = "data/di.csv"
  ),
  list(
    name     = "external_factors",
    desc     = "SP500 / VIX / Brent and BRL-USD daily closes (Yahoo)",
    interp   = "Rscript",
    file     = "R/data_download/external_factors.R",
    network  = TRUE,
    requires = character(),
    produces = c("data/investing/external_factors_daily.csv",
                 "data/processed/brl_usd_daily.csv")
  ),
  list(
    name     = "focus_fred",
    desc     = "Focus medians (BCB olinda) + UST 2y (FRED DGS2)",
    interp   = "Rscript",
    file     = "R/data_download/focus_fred.R",
    network  = TRUE,
    requires = character(),
    produces = c("data/processed/focus_daily.csv", "data/fred_dgs2.csv")
  ),
  list(
    name     = "ibov",
    desc     = "IBOV daily index from B3 (rb3 cache)",
    interp   = "Rscript",
    file     = "R/data_download/ibov_daily.R",
    network  = TRUE,
    requires = character(),
    produces = "data/processed/ibov_daily.csv"
  ),
  list(
    name     = "download",
    desc     = "Merge BCB / FX / yields / assets / risk / EPU into the raw panel",
    interp   = "Rscript",
    file     = "script/download.R",
    network  = TRUE,
    requires = c("data/yields/yields_dia.csv",
                 "data/banco_central_rep_dominicana/embi_brasil.csv",
                 "data/investing/cds5y.csv",
                 "data/investing/msci.csv",
                 "data/investing/sp500_vix.csv",
                 "data/epu/economic_policy_uncertainty.csv"),
    produces = "data/raw_data.csv"
  ),
  list(
    name     = "clean",
    desc     = "Log transforms + X-13 seasonal adjustment of the monthly panel",
    interp   = "Rscript",
    file     = "script/clean.R",
    network  = FALSE,
    requires = "data/raw_data.csv",
    produces = "data/processed/data_log_deseasonalized.csv"
  ),
  list(
    name     = "instrument",
    desc     = "Copom-day DI surprises to 10 monthly GK-family variants",
    interp   = "Rscript",
    file     = "script/instrument.R",
    network  = FALSE,
    requires = c("data/di.csv", "data/copom_historico.csv",
                 "data/processed/ibov_daily.csv",
                 "data/investing/external_factors_daily.csv",
                 "data/processed/brl_usd_daily.csv",
                 "data/processed/focus_daily.csv",
                 "data/fred_dgs2.csv"),
    produces = c("data/processed/instrument.csv",
                 "data/processed/instrumentos_mensais.csv")
  ),
  list(
    name     = "model",
    desc     = "Production DFM (r=7, q=6) + wild bootstrap IRFs",
    interp   = "Rscript",
    file     = "script/model_alessi.R",
    network  = FALSE,
    requires = c("data/processed/data_log_deseasonalized.csv",
                 "data/processed/instrument.csv"),
    produces = "output/irf/irf_model_alessi_r7q6.pdf"
  )
)

names(STAGES) <- vapply(STAGES, `[[`, character(1), "name")
STAGE_NAMES   <- names(STAGES)

# Which stage produces a given file, if any — drives the preflight so that
# a requirement satisfied earlier in the same run is not reported missing.
PRODUCER <- local({
  m <- character()
  for (s in STAGES) for (f in s$produces) m[f] <- s$name
  m
})


# ---- Argument parsing ----------------------------------------------

args <- commandArgs(trailingOnly = TRUE)

flag <- function(x) x %in% args
opt  <- function(key) {
  hit <- grep(sprintf("^--%s=", key), args, value = TRUE)
  if (length(hit) == 0) return(NULL)
  sub(sprintf("^--%s=", key), "", hit[length(hit)])
}
split_list <- function(x) trimws(strsplit(x, ",", fixed = TRUE)[[1]])

known <- c("--list", "--dry-run", "--skip-existing", "--continue-on-error",
           "--help", "-h")
unknown <- args[!(args %in% known) &
                  !grepl("^--(from|to|only|skip)=", args)]
if (length(unknown) > 0) {
  stop("Argumento nao reconhecido: ", paste(unknown, collapse = ", "),
       "\nUse --help para a lista.", call. = FALSE)
}

if (flag("--help") || flag("-h")) {
  cat(paste(readLines("script/run_all.R", n = 38), collapse = "\n"), "\n")
  quit(save = "no", status = 0)
}

do_list      <- flag("--list")
dry_run      <- flag("--dry-run")
skip_existing <- flag("--skip-existing")
keep_going   <- flag("--continue-on-error")

check_names <- function(x, what) {
  bad <- setdiff(x, STAGE_NAMES)
  if (length(bad) > 0) {
    stop(sprintf("%s: estagio desconhecido: %s\nEstagios validos: %s",
                 what, paste(bad, collapse = ", "),
                 paste(STAGE_NAMES, collapse = ", ")), call. = FALSE)
  }
  x
}

selected <- STAGE_NAMES

if (!is.null(opt("only"))) {
  only <- check_names(split_list(opt("only")), "--only")
  selected <- STAGE_NAMES[STAGE_NAMES %in% only]
} else {
  if (!is.null(opt("from"))) {
    from <- check_names(opt("from"), "--from")
    selected <- selected[match(from, selected):length(selected)]
  }
  if (!is.null(opt("to"))) {
    to <- check_names(opt("to"), "--to")
    if (!(to %in% selected)) {
      stop("--to=", to, " vem antes de --from; nada a rodar.", call. = FALSE)
    }
    selected <- selected[1:match(to, selected)]
  }
}

if (!is.null(opt("skip"))) {
  selected <- setdiff(selected, check_names(split_list(opt("skip")), "--skip"))
}

if (length(selected) == 0) stop("Nenhum estagio selecionado.", call. = FALSE)


# ---- --list --------------------------------------------------------

file_state <- function(paths) {
  if (length(paths) == 0) return("-")
  paste(vapply(paths, function(p) {
    if (file.exists(p)) sprintf("%s [ok]", p) else sprintf("%s [FALTA]", p)
  }, character(1)), collapse = ", ")
}

if (do_list) {
  cat("\nEstagios do pipeline (ordem de execucao):\n\n")
  for (i in seq_along(STAGE_NAMES)) {
    s <- STAGES[[i]]
    cat(sprintf("%d. %-17s %s%s\n", i, s$name, s$desc,
                if (s$network) "  [rede]" else ""))
    cat(sprintf("   cmd      : %s %s\n", s$interp, s$file))
    cat(sprintf("   requer   : %s\n", file_state(s$requires)))
    cat(sprintf("   produz   : %s\n\n", file_state(s$produces)))
  }
  cat("Selecao atual: ", paste(selected, collapse = " -> "), "\n\n", sep = "")
  quit(save = "no", status = 0)
}


# ---- Preflight -----------------------------------------------------
# A requirement counts as satisfied if the file exists OR an earlier
# selected stage produces it. Everything else aborts the run before any
# stage starts, so a 40-minute download never fails on a missing input at
# the end.

missing <- list()
for (nm in selected) {
  s <- STAGES[[nm]]
  for (req in s$requires) {
    producer <- PRODUCER[req]
    made_here <- !is.na(producer) &&
      producer %in% selected &&
      match(producer, selected) < match(nm, selected)
    if (!file.exists(req) && !made_here) {
      missing[[length(missing) + 1]] <- list(stage = nm, file = req,
                                             producer = unname(producer))
    }
  }
  if (!file.exists(s$file)) {
    missing[[length(missing) + 1]] <- list(stage = nm, file = s$file,
                                           producer = NA_character_)
  }
}

if (length(missing) > 0) {
  cat("\n[ABORTADO] Preflight: entradas ausentes. Nada foi executado.\n\n")
  for (m in missing) {
    cat(sprintf("  - estagio '%s' precisa de: %s\n", m$stage, m$file))
    if (!is.na(m$producer)) {
      cat(sprintf("      produzido pelo estagio '%s' (inclua-o na selecao)\n",
                  m$producer))
    } else if (identical(m$file, "data/yields/yields_dia.csv")) {
      cat("      INSUMO EXTERNO FIXO, fornecido pelo orientador. Nenhum script\n")
      cat("      deste repositorio escreve esse arquivo e nenhum deveria — e a\n")
      cat("      curva sobre a qual o painel e construido, e nao e reproduzivel\n")
      cat("      aqui. Recupere o arquivo original.\n")
    } else {
      cat("      entrada externa sem produtor no repositorio.\n")
    }
  }
  cat("\n")
  quit(save = "no", status = 1)
}


# ---- Plan ----------------------------------------------------------

net_stages <- selected[vapply(selected, function(n) STAGES[[n]]$network, logical(1))]

cat("\n=== run_all.R ===\n")
cat(sprintf("Estagios: %s\n", paste(selected, collapse = " -> ")))
if (length(net_stages) > 0) {
  cat(sprintf("[!] %d estagio(s) batem em rede (%s) — a cadeia pode levar dezenas de minutos.\n",
              length(net_stages), paste(net_stages, collapse = ", ")))
}
if (skip_existing) cat("[i] --skip-existing ativo.\n")
if (keep_going)    cat("[i] --continue-on-error ativo.\n")

if (dry_run) {
  cat("\n[--dry-run] Preflight passou. Comandos que seriam executados:\n\n")
  for (nm in selected) {
    s <- STAGES[[nm]]
    tag <- if (skip_existing && length(s$produces) > 0 &&
               all(file.exists(s$produces))) "  [seria pulado: saidas existem]" else ""
    cat(sprintf("  %s %s%s\n", s$interp, s$file, tag))
  }
  cat("\n")
  quit(save = "no", status = 0)
}


# ---- Run -----------------------------------------------------------

dir.create(LOG_DIR, showWarnings = FALSE, recursive = TRUE)
stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")

results <- data.frame(stage = character(), status = character(),
                      minutes = numeric(), log = character(),
                      stringsAsFactors = FALSE)

for (nm in selected) {
  s <- STAGES[[nm]]

  if (skip_existing && length(s$produces) > 0 && all(file.exists(s$produces))) {
    cat(sprintf("\n--- [%s] pulado (--skip-existing, saidas presentes)\n", nm))
    results <- rbind(results, data.frame(stage = nm, status = "skipped",
                                         minutes = 0, log = "-",
                                         stringsAsFactors = FALSE))
    next
  }

  log_file <- file.path(LOG_DIR, sprintf("run_all_%s_%s.log", stamp, nm))
  cat(sprintf("\n--- [%s] %s %s\n", nm, s$interp, s$file))
  cat(sprintf("    log: %s\n", log_file))

  cmd <- if (identical(s$interp, "Rscript")) RSCRIPT else s$interp
  t0  <- Sys.time()
  # stdout streams to the console AND to the log; stderr is merged in.
  code <- system2("sh", c("-c", shQuote(sprintf("%s %s 2>&1 | tee %s",
                                                shQuote(cmd), shQuote(s$file),
                                                shQuote(log_file)))))
  mins <- as.numeric(Sys.time() - t0, units = "mins")

  ok <- identical(code, 0L)
  cat(sprintf("--- [%s] %s em %.1f min\n", nm,
              if (ok) "OK" else sprintf("FALHOU (exit %s)", code), mins))

  results <- rbind(results, data.frame(
    stage = nm, status = if (ok) "ok" else sprintf("failed(%s)", code),
    minutes = round(mins, 2), log = log_file, stringsAsFactors = FALSE))

  if (!ok && !keep_going) {
    cat("\n=== RESUMO (interrompido) ===\n")
    print(results, row.names = FALSE)
    cat(sprintf("\nEstagio '%s' falhou. Veja %s\n", nm, log_file))
    cat("Retome com --from=", nm, " apos corrigir.\n", sep = "")
    quit(save = "no", status = 1)
  }
}

cat("\n=== RESUMO ===\n")
print(results, row.names = FALSE)
cat(sprintf("\nTotal: %.1f min\n", sum(results$minutes)))

failed <- results$stage[grepl("^failed", results$status)]
if (length(failed) > 0) {
  cat(sprintf("Estagios com falha: %s\n", paste(failed, collapse = ", ")))
  quit(save = "no", status = 1)
}
