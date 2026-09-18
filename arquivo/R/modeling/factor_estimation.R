# Function removed from R/modeling/factor_estimation.R on 2026-09-17, in the
# audit of script/ and R/. Its only callers were panel_composition.R and
# panel_composition_experimental.R, now in arquivo/script/. Kept as written.


#' Map a dynamic-shock direction into the static-factor space
#'
#' @param dfm_results Fitted DFM returned by `estimate_dfm()`.
#' @param direction Numeric direction in the dynamic innovation space.
#'
#' @return Numeric vector in the static-factor space.
map_dynamic_direction_to_static <- function(dfm_results, direction) {
  K <- dfm_results$dynamic_loadings
  M <- dfm_results$dynamic_scaling
  if (!is.matrix(K) && !is.matrix(M)) {
    return(as.numeric(direction))
  }
  drop(K %*% M %*% direction)
}
