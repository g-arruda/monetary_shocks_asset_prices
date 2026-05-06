# ============================================================
# Build the GRG (2025) numerical benchmark for the IRF section.
#
# Reads the saved IRF results (irf_results_*.rds) produced by
# script/irf_cross_instrument.R and assembles a side-by-side
# comparison against Tables 4 and 5 of GRG (extracted into
# artigos/.../*_notes.md).
#
# Normalization: GRG reports per +100bp; our DFM normalizes to
# +50bp (yield_6m). Both sides are scaled to per +50bp in the
# benchmark CSV (GRG values divided by 2; ours unchanged).
#
# Caveat: GRG's Tab 4 dependent variable is break-even inflation
# expectations; our panel only has realized inflation
# (price_ipca). The Tab 4 row is included as a "narrative
# benchmark" rather than a numerical equality test.
# ============================================================

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tibble)
})

# ---- Load our IRFs ------------------------------------------
# RDS now bundles var_names alongside the irf object (commit after
# Gemini P2 review). Backwards-compatible loader handles either schema.

load_irf_bundle <- function(path) {
  obj <- readRDS(path)
  if (!is.null(obj$irf) && !is.null(obj$var_names)) {
    return(obj)  # new schema
  }
  # legacy: bare irf object; recover var_names from the panel header.
  warning("Legacy RDS schema detected at ", path,
          " — falling back to panel header for var_names.")
  panel_header <- read_csv("data/processed/data_log_deseasonalized.csv",
                           n_max = 1, show_col_types = FALSE) |>
    dplyr::select(-ref.date) |>
    colnames()
  list(irf = obj, var_names = panel_header, tcode = NULL,
       label = NA_character_, mp_var = NA_character_)
}

bundle_zhetjk3var <- load_irf_bundle("output/irf_results_zhetjk3var.rds")
bundle_zjkpurif   <- load_irf_bundle("output/irf_results_zjkpurif.rds")

# Helper: pull (point, lo90, hi90, lo68, hi68) at horizon h for a
# response variable identified by name.
get_h <- function(bundle, var_name, h = 0L) {
  idx <- match(var_name, bundle$var_names)
  if (is.na(idx)) stop("variable not found: ", var_name)
  level90 <- sprintf("%.2f", 0.90)
  level68 <- sprintf("%.2f", 0.68)
  list(
    point = bundle$irf$irf_point_matrix[idx, h + 1L],
    lo90  = bundle$irf$ci[[level90]]$lower[idx, h + 1L],
    hi90  = bundle$irf$ci[[level90]]$upper[idx, h + 1L],
    lo68  = bundle$irf$ci[[level68]]$lower[idx, h + 1L],
    hi68  = bundle$irf$ci[[level68]]$upper[idx, h + 1L]
  )
}

# Sample-mean baseline for level-to-percent conversion of cambio_usd
# (Gemini P1 #2: GRG reports % change; our panel has BRL/USD level).
panel <- read_csv("data/processed/data_log_deseasonalized.csv",
                  show_col_types = FALSE) |> tidyr::drop_na()
brl_usd_baseline <- mean(panel$cambio_usd, na.rm = TRUE)

# ---- GRG values per +100bp Δi (3-month maturity row) ---------
# Sourced from GRG (2025) Tabs 4 and 5; see notes file in artigos/.
# We use the Δi(3m) row because our z_het_jk_3var identifies on DI_3m.
# Scale to per-50bp by dividing by 2.

grg_per_50bp <- tribble(
  ~target_grg,             ~grg_point_100, ~grg_se_100, ~table,
  "Δπᵉ 1y (break-even)",   -0.26,           0.07,        "GRG_Tab4",
  "Δπᵉ 2y (break-even)",   -0.60,           0.06,        "GRG_Tab4",
  "Δπᵉ 5y (break-even)",   -0.69,           0.07,        "GRG_Tab4",
  "Δ(BRL/USD) %",          -5.10,           0.75,        "GRG_Tab5",
  "Δ CDS_5y",              -0.03,           0.05,        "GRG_Tab5"
) |> mutate(
  grg_point_50 = grg_point_100 / 2,
  grg_se_50    = grg_se_100    / 2
)

# ---- Map GRG targets to our panel variables ------------------
# Panel does NOT have inflation expectations; Δπᵉ rows compared
# against price_ipca (realized) — caveat documented in report.
# IBOV not in GRG; left out of benchmark CSV.

mapping <- tribble(
  ~target_grg,               ~our_var,         ~our_label,             ~note,
  "Δπᵉ 1y (break-even)",     "price_ipca",     "IPCA realized",        "PROXY: GRG uses break-even expectation; our panel has only realized IPCA",
  "Δπᵉ 2y (break-even)",     "price_ipca",     "IPCA realized",        "PROXY: same caveat",
  "Δπᵉ 5y (break-even)",     "price_ipca",     "IPCA realized",        "PROXY: same caveat (longer horizon mismatch)",
  "Δ(BRL/USD) %",            "cambio_usd",     "BRL/USD",              "DIRECT: same currency pair, sign convention checked",
  "Δ CDS_5y",                "cds_5y",         "CDS 5y",               "DIRECT: same maturity"
)

# ---- Build the benchmark table ------------------------------

# Project convention: normalize_value = 0.5 forces yield_6m IRF h=0
# to equal +0.5 in the variable's native units. yield_6m is stored
# as a decimal proportion (0.05 = 5%), so a "+50bp" label corresponds
# to +0.5 in proportion = +50pp = +5000bp at face value (a known
# project-wide scaling convention -- see Gemini review P1 #1).
# The numerical comparison with GRG (per +100bp) requires dividing
# our IRF magnitudes by 100 to express them per +50bp:
#
#   our_per_50bp = irf_value / 100
#
# For cambio_usd, GRG reports % change in BRL/USD; our IRF is in
# raw BRL units. Convert: pct_change = (irf / baseline) * 100.
# Combined: our_pct_per_50bp = (irf / 100) / baseline * 100 = irf / baseline.

scale_to_grg_units <- function(var_name, raw_value) {
  # raw_value is the IRF in our convention (yield_6m IRF h=0 = +0.5).
  per_50bp <- raw_value / 100
  if (var_name == "cambio_usd") {
    # convert per-50bp BRL change to percent change of BRL/USD
    return(per_50bp / brl_usd_baseline * 100)
  }
  # cds_5y, price_ipca, etc.: report in native unit per +50bp.
  per_50bp
}

build_row <- function(grg_target, bundle, irf_label) {
  m <- mapping[mapping$target_grg == grg_target, ]
  v <- get_h(bundle, m$our_var, h = 0L)
  g <- grg_per_50bp[grg_per_50bp$target_grg == grg_target, ]

  tibble(
    target_grg     = grg_target,
    our_var        = m$our_var,
    our_label      = m$our_label,
    instrument     = irf_label,
    horizon        = 0L,
    our_point_raw  = v$point,
    our_point_50bp = scale_to_grg_units(m$our_var, v$point),
    our_lo90_50bp  = scale_to_grg_units(m$our_var, v$lo90),
    our_hi90_50bp  = scale_to_grg_units(m$our_var, v$hi90),
    grg_point_50bp = g$grg_point_50,
    grg_se_50bp    = g$grg_se_50,
    sign_match     = sign(scale_to_grg_units(m$our_var, v$point)) == sign(g$grg_point_50),
    grg_table      = g$table,
    note           = m$note
  )
}

bench <- bind_rows(
  purrr::map_dfr(grg_per_50bp$target_grg, build_row,
                 bundle = bundle_zhetjk3var, irf_label = "z_het_jk_3var"),
  purrr::map_dfr(grg_per_50bp$target_grg, build_row,
                 bundle = bundle_zjkpurif,   irf_label = "z_jk_purif")
)

dir.create("output", showWarnings = FALSE)
write_csv(bench, "output/grg_benchmark.csv")

# ---- Console summary ----------------------------------------

cat("\n========== GRG (2025) BENCHMARK (impact, per +50bp) ==========\n")
fmt_ci <- function(p, l, u) sprintf("%+8.4f [%+8.4f, %+8.4f]", p, l, u)

bench |>
  mutate(
    ours = fmt_ci(our_point_50bp, our_lo90_50bp, our_hi90_50bp),
    grg  = sprintf("%+8.4f (SE %.4f)", grg_point_50bp, grg_se_50bp),
    match = ifelse(sign_match, "sign agrees", "sign DISAGREES")
  ) |>
  select(target_grg, instrument, ours, grg, match) |>
  print(n = 100, width = 200)

cat("\nWrote output/grg_benchmark.csv\n\n")
