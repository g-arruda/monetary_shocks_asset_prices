# ===================================================================
# End-to-end pipeline orchestrator.
#
# Runs the ordered stages of the project, one Rscript process per stage, so
# that no stage sees another stage's workspace.
#
# Usage (always from the repository root):
#   Rscript script/run_all.R                     # full chain, network included
#   Rscript script/run_all.R --list              # stages, inputs, outputs, status
#   Rscript script/run_all.R --dry-run           # plan + preflight, runs nothing
#   Rscript script/run_all.R --from=clean        # from a stage to the end
#   Rscript script/run_all.R --to=instrument     # from the start to a stage
#   Rscript script/run_all.R --only=clean,instrument
#   Rscript script/run_all.R --skip=download
#   Rscript script/run_all.R --skip-existing     # skip stages whose outputs exist
#   Rscript script/run_all.R --continue-on-error
#
# NOTE on the yield curve — there is no fitting stage, on purpose.
# `data/raw/yields/yields_dia.csv` is a FIXED EXTERNAL INPUT supplied by the
# advisor: it is the curve the panel is built on, `script/download.R`
# consumes it as given, and nothing here can regenerate it. The `download`
# stage declares it as a hard requirement so preflight aborts with a pointer
# if it ever goes missing (`registro/historico_decisoes.md` section 4).
# ===================================================================

HELP_LINES <- 24L   # the header above, printed by --help
RSCRIPT <- file.path(R.home("bin"), "Rscript")
LOG_DIR <- "output/logs"

# Canonical artefacts of the chain. `covid_volatility_theta.csv` has no
# stage: script/covid_volatility_theta.R estimates theta and the preflight
# reports it missing.
PANEL_BASE <- "data/processed/data_log_deseasonalized_base_106.csv"
PANEL      <- "data/processed/data_log_deseasonalized.csv"
INSTRUMENT <- "data/processed/instrument.csv"
THETA      <- "output/factors/covid_volatility_theta.csv"
MODEL_IRF  <- "output/irf/irf_model_alessi_r5q5.pdf"
BAI_NG     <- "output/factors/production_bai_ng_bll_surface.csv"

# requires: inputs with no producer inside the selected run (checked in
#           preflight); produces: outputs used by --skip-existing and by
#           the post-run report.
STAGES <- list(
  download = list(
    name = "download",
    desc = "Download and merge every reproducible raw input",
    file = "script/download.R",
    network = TRUE,
    requires = c(
      "data/raw/yields/yields_dia.csv",
      "data/raw/banco_central_rep_dominicana/embi_brasil.csv",
      "data/raw/investing/cds5y.csv",
      "data/raw/investing/sp500_vix.csv",
      "data/raw/epu/economic_policy_uncertainty.xlsx"
    ),
    produces = c(
      "data/raw/raw_data.csv",
      "data/raw/focus_daily.csv",
      "data/raw/focus_fiscal_expectations.csv",
      "data/raw/ibov_daily.csv",
      "data/raw/brl_usd_daily.csv",
      "data/raw/investing/external_factors_daily.csv"
    )
  ),
  macro_news = list(
    name = "macro_news",
    desc = "Focus, SGS and IBGE first releases for the BS macro news block",
    file = "script/download_macro_news.R",
    network = TRUE,
    requires = character(),
    produces = c(
      "data/raw/focus_macro_expectations.csv",
      "data/raw/macro_released.csv"
    )
  ),
  focus_current_year = list(
    name = "focus_current_year",
    desc = "Current-year Focus medians for the fixed-horizon approximation",
    file = "script/download_focus_current_year.R",
    network = TRUE,
    requires = character(),
    produces = "data/raw/focus_current_year.csv"
  ),
  ptax = list(
    name = "ptax",
    desc = "Daily PTAX, the 13h clock of the Yahoo and CDS timing diagnostics",
    file = "script/download_ptax.R",
    network = TRUE,
    requires = character(),
    produces = "data/raw/ptax_daily.csv"
  ),
  yahoo_stamps = list(
    name = "yahoo_stamps",
    desc = "Yahoo BRL=X bars with the API's stamp, for the Copom-day timing",
    file = "script/download_yahoo_stamps.R",
    network = TRUE,
    requires = character(),
    produces = "data/raw/brl_usd_daily_stamps.csv"
  ),
  copom_atas = list(
    name = "copom_atas",
    desc = "Copom minutes, for the session times of each meeting",
    file = "script/download_copom_minutes.R",
    network = TRUE,
    requires = character(),
    produces = "data/raw/copom_atas.csv"
  ),
  msci = list(
    name = "msci",
    desc = "MSCI Emerging Markets index, end of month, the panel's msci",
    file = "script/download_msci.R",
    network = TRUE,
    requires = character(),
    produces = "data/raw/msci_em.csv"
  ),
  clean = list(
    name = "clean",
    desc = "Log transforms, Focus fixed horizon, X-13 of the monthly panel",
    file = "script/clean.R",
    network = FALSE,
    requires = c(
      "data/raw/raw_data.csv",
      "data/raw/focus_fiscal_expectations.csv",
      "data/raw/focus_current_year.csv",
      "data/raw/msci_em.csv",
      "data/raw/copom_historico.csv",
      "data/raw/DLSP/Evodlp.xlsx"
    ),
    produces = c(
      PANEL_BASE,
      PANEL,
      "output/panel/production_series_manifest.csv"
    )
  ),
  instrument = list(
    name = "instrument",
    desc = "Copom-day DI surprises to the three monthly instrument variants",
    file = "script/instrument.R",
    network = FALSE,
    requires = c(
      "data/raw/di.csv",
      "data/raw/copom_historico.csv",
      "data/raw/ibov_daily.csv",
      "data/raw/investing/external_factors_daily.csv",
      "data/raw/focus_macro_expectations.csv",
      "data/raw/macro_released.csv"
    ),
    produces = c(
      "data/processed/instrument.csv",
      "data/processed/instrumentos_mensais.csv",
      "output/instrument/bs_orthogonalization.csv"
    )
  ),
  model = list(
    name = "model",
    desc = "Production DFM (r=5, q=5) + Anderson-Rubin IRF sets",
    file = "script/model_alessi.R",
    network = FALSE,
    requires = c(PANEL, INSTRUMENT, THETA),
    produces = c(MODEL_IRF, BAI_NG)
  )
)

stage_names <- names(STAGES)

# Which stage produces a given file, if any — drives the preflight so that
# a requirement satisfied earlier in the same run is not reported missing.
producer_of <- purrr::map(unname(STAGES), function(stage) {
  purrr::set_names(rep(stage$name, length(stage$produces)), stage$produces)
}) |>
  purrr::list_c()


# ---- Argument parsing ----------------------------------------------

args <- commandArgs(trailingOnly = TRUE)

#' Whether a bare flag was passed on the command line
#'
#' @param x Flag, e.g. `"--list"`.
#'
#' @return `TRUE` if `x` is among the trailing arguments.
flag <- function(x) x %in% args

#' Value of a `--key=value` option, the last one if repeated
#'
#' @param key Option name without dashes, e.g. `"from"`.
#'
#' @return The value as a string, or `NULL` if the option was not passed.
opt <- function(key) {
  hit <- stringr::str_subset(args, sprintf("^--%s=", key))
  if (length(hit) == 0) {
    return(NULL)
  }
  stringr::str_remove(dplyr::last(hit), sprintf("^--%s=", key))
}

#' Abort on stage names that are not in the stage table
#'
#' @param x Stage names read from an option.
#' @param what Option the names came from, for the error message.
#'
#' @return `x`, unchanged, when every name is a known stage.
check_names <- function(x, what) {
  unknown_stages <- setdiff(x, stage_names)
  if (length(unknown_stages) > 0) {
    stop(
      sprintf(
        "%s: estagio desconhecido: %s\nEstagios validos: %s",
        what,
        paste(unknown_stages, collapse = ", "),
        paste(stage_names, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  x
}

known_flags <- c(
  "--list", "--dry-run", "--skip-existing", "--continue-on-error",
  "--help", "-h"
)
unknown_args <- args[
  !(args %in% known_flags) & !grepl("^--(from|to|only|skip)=", args)
]
if (length(unknown_args) > 0) {
  stop(
    "Argumento nao reconhecido: ", paste(unknown_args, collapse = ", "),
    "\nUse --help para a lista.",
    call. = FALSE
  )
}

if (flag("--help") || flag("-h")) {
  readLines("script/run_all.R", n = HELP_LINES) |>
    paste(collapse = "\n") |>
    cat("\n")
  quit(save = "no", status = 0)
}

do_list       <- flag("--list")
dry_run       <- flag("--dry-run")
skip_existing <- flag("--skip-existing")
keep_going    <- flag("--continue-on-error")

selected <- stage_names

if (!is.null(opt("only"))) {
  only <- check_names(
    trimws(strsplit(opt("only"), ",", fixed = TRUE)[[1]]),
    "--only"
  )
  selected <- stage_names[stage_names %in% only]
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
  skipped <- trimws(strsplit(opt("skip"), ",", fixed = TRUE)[[1]])
  selected <- setdiff(selected, check_names(skipped, "--skip"))
}

if (length(selected) == 0) {
  stop("Nenhum estagio selecionado.", call. = FALSE)
}


# ---- --list --------------------------------------------------------

#' Render a list of paths with their existence status for `--list`
#'
#' @param paths Character vector of file paths.
#'
#' @return One string: each path tagged `[ok]` or `[FALTA]`, or `"-"` if empty.
file_state <- function(paths) {
  if (length(paths) == 0) {
    return("-")
  }
  status <- dplyr::if_else(file.exists(paths), "[ok]", "[FALTA]")
  paste(paths, status, collapse = ", ")
}

if (do_list) {
  cat("\nEstagios do pipeline (ordem de execucao):\n\n")
  purrr::iwalk(unname(STAGES), function(stage, i) {
    cat(sprintf(
      "%d. %-17s %s%s\n",
      i,
      stage$name,
      stage$desc,
      if (stage$network) "  [rede]" else ""
    ))
    cat(sprintf("   cmd      : Rscript %s\n", stage$file))
    cat(sprintf("   requer   : %s\n", file_state(stage$requires)))
    cat(sprintf("   produz   : %s\n\n", file_state(stage$produces)))
  })
  cat("Selecao atual: ", paste(selected, collapse = " -> "), "\n\n", sep = "")
  quit(save = "no", status = 0)
}


# ---- Preflight -----------------------------------------------------
# A requirement counts as satisfied if the file exists OR an earlier
# selected stage produces it. Everything else aborts the run before any
# stage starts, so a 40-minute download never fails on a missing input at
# the end.

checks <- purrr::map(selected, function(name) {
  spec <- STAGES[[name]]
  tibble::tibble(
    stage = name,
    file = c(spec$requires, spec$file),
    producer = c(unname(producer_of[spec$requires]), NA_character_)
  )
}) |>
  purrr::list_rbind()
made_here <- !is.na(checks$producer) &
  checks$producer %in% selected &
  match(checks$producer, selected) < match(checks$stage, selected)
missing_inputs <- checks[!file.exists(checks$file) & !made_here, ]

if (nrow(missing_inputs) > 0) {
  cat("\n[ABORTADO] Preflight: entradas ausentes. Nada foi executado.\n\n")
  purrr::pwalk(missing_inputs, function(stage, file, producer) {
    cat(sprintf("  - estagio '%s' precisa de: %s\n", stage, file))
    if (!is.na(producer)) {
      cat(sprintf(
        "      produzido pelo estagio '%s' (inclua-o na selecao)\n",
        producer
      ))
    } else if (identical(file, "data/raw/yields/yields_dia.csv")) {
      cat("      INSUMO EXTERNO FIXO, fornecido pelo orientador. Nenhum script\n")
      cat("      deste repositorio escreve esse arquivo e nenhum deveria — e a\n")
      cat("      curva sobre a qual o painel e construido, e nao e reproduzivel\n")
      cat("      aqui. Recupere o arquivo original.\n")
    } else {
      cat("      entrada externa sem produtor no repositorio.\n")
    }
  })
  cat("\n")
  quit(save = "no", status = 1)
}


# ---- Plan ----------------------------------------------------------

network_stages <- selected[purrr::map_lgl(STAGES[selected], "network")]

cat("\n=== run_all.R ===\n")
cat(sprintf("Estagios: %s\n", paste(selected, collapse = " -> ")))
if (length(network_stages) > 0) {
  cat(sprintf(
    "[!] %d estagio(s) batem em rede (%s) — a cadeia pode levar dezenas de minutos.\n",
    length(network_stages),
    paste(network_stages, collapse = ", ")
  ))
}
if (skip_existing) cat("[i] --skip-existing ativo.\n")
if (keep_going) cat("[i] --continue-on-error ativo.\n")

if (dry_run) {
  cat("\n[--dry-run] Preflight passou. Comandos que seriam executados:\n\n")
  purrr::walk(STAGES[selected], function(stage) {
    outputs_exist <- length(stage$produces) > 0 &&
      all(file.exists(stage$produces))
    skip_tag <- if (skip_existing && outputs_exist) {
      "  [seria pulado: saidas existem]"
    } else {
      ""
    }
    cat(sprintf("  Rscript %s%s\n", stage$file, skip_tag))
  })
  cat("\n")
  quit(save = "no", status = 0)
}


# ---- Run -----------------------------------------------------------

dir.create(LOG_DIR, showWarnings = FALSE, recursive = TRUE)
stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")

# Stages run one after another and a failure stops the chain, so this stays a
# loop; each stage adds one row to `results`.
results <- tibble::tibble(
  stage = character(),
  status = character(),
  minutes = numeric(),
  log = character()
)

for (name in selected) {
  stage <- STAGES[[name]]
  outputs_exist <- length(stage$produces) > 0 &&
    all(file.exists(stage$produces))

  if (skip_existing && outputs_exist) {
    cat(sprintf(
      "\n--- [%s] pulado (--skip-existing, saidas presentes)\n",
      name
    ))
    results <- tibble::add_row(
      results,
      stage = name,
      status = "skipped",
      minutes = 0,
      log = "-"
    )
    next
  }

  log_file <- file.path(LOG_DIR, sprintf("run_all_%s_%s.log", stamp, name))
  cat(sprintf("\n--- [%s] Rscript %s\n", name, stage$file))
  cat(sprintf("    log: %s\n", log_file))

  started <- Sys.time()
  # stdout streams to the console AND to the log; stderr is merged in.
  exit_code <- system2("sh", c("-c", shQuote(sprintf(
    "%s %s 2>&1 | tee %s",
    shQuote(RSCRIPT),
    shQuote(stage$file),
    shQuote(log_file)
  ))))
  minutes <- as.numeric(Sys.time() - started, units = "mins")

  ok <- identical(exit_code, 0L)
  cat(sprintf(
    "--- [%s] %s em %.1f min\n",
    name,
    if (ok) "OK" else sprintf("FALHOU (exit %s)", exit_code),
    minutes
  ))

  results <- tibble::add_row(
    results,
    stage = name,
    status = if (ok) "ok" else sprintf("failed(%s)", exit_code),
    minutes = round(minutes, 2),
    log = log_file
  )

  if (!ok && !keep_going) {
    cat("\n=== RESUMO (interrompido) ===\n")
    print(as.data.frame(results), row.names = FALSE)
    cat(sprintf("\nEstagio '%s' falhou. Veja %s\n", name, log_file))
    cat("Retome com --from=", name, " apos corrigir.\n", sep = "")
    quit(save = "no", status = 1)
  }
}

cat("\n=== RESUMO ===\n")
print(as.data.frame(results), row.names = FALSE)
cat(sprintf("\nTotal: %.1f min\n", sum(results$minutes)))

failed <- results$stage[stringr::str_starts(results$status, "failed")]
if (length(failed) > 0) {
  cat(sprintf("Estagios com falha: %s\n", paste(failed, collapse = ", ")))
  quit(save = "no", status = 1)
}
