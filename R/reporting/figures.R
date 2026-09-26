# ===================================================================
# Figure layouts shared by more than one page or output. Consumed by
# script/q_sensitivity.R, script/p_sensitivity.R and
# script/instrument_layers_irf.R.
# ===================================================================


#' One page of the Figure A3 layout: production with bands, alternatives in
#' point
#'
#' Production carries both ribbons and a solid line; the alternatives are
#' point-only dashed lines. A band around a cell whose strength sits below the
#' project's own ruler would suggest an inference that ruler does not license,
#' which is why only `band_df` is ribboned.
#'
#' @param df Long data.frame with `variable`, `h`, `point` and the factor
#'   `cell` used for colour and linetype.
#' @param band_df Same shape restricted to the production cell, plus `lo80`,
#'   `hi80`, `lo90`, `hi90`.
#' @param vars Variables to draw, one panel each, in this order.
#' @param palette,linetypes Named vectors keyed by the levels of `cell`.
#' @param h_max Last horizon on the x axis (breaks every 6 months).
#' @param ncol Panels per row.
#' @param title,subtitle Page annotation.
#'
#' @return Patchwork object.
plot_dimension_overlay <- function(df, band_df, vars, palette, linetypes,
                                   h_max, ncol, title, subtitle) {
  panels <- purrr::map(vars, \(v) {
    bands <- dplyr::filter(band_df, variable == v)
    ggplot2::ggplot(dplyr::filter(df, variable == v), ggplot2::aes(x = h)) +
      ggplot2::geom_ribbon(
        data = bands,
        ggplot2::aes(ymin = lo90, ymax = hi90),
        fill = "steelblue",
        alpha = 0.18
      ) +
      ggplot2::geom_ribbon(
        data = bands,
        ggplot2::aes(ymin = lo80, ymax = hi80),
        fill = "steelblue",
        alpha = 0.36
      ) +
      ggplot2::geom_hline(
        yintercept = 0,
        linetype = "dashed",
        colour = "red",
        linewidth = 0.35
      ) +
      ggplot2::geom_line(
        ggplot2::aes(y = point, colour = cell, linetype = cell),
        linewidth = 0.7
      ) +
      ggplot2::scale_colour_manual(values = palette) +
      ggplot2::scale_linetype_manual(values = linetypes) +
      ggplot2::scale_x_continuous(
        breaks = seq(0, h_max, 6),
        expand = c(0.01, 0)
      ) +
      ggplot2::labs(
        title = v,
        x = NULL,
        y = NULL,
        colour = NULL,
        linetype = NULL
      ) +
      ggplot2::theme_classic(base_size = 10) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(size = 10, face = "bold")
      )
  })

  patchwork::wrap_plots(panels, ncol = ncol, guides = "collect") +
    patchwork::plot_annotation(title = title, subtitle = subtitle) &
    ggplot2::theme(legend.position = "bottom")
}
