# ===================================================================
# Figure of Anexo E: the daily trajectory of the bridge, the cumulative
# response of the exchange rate and of the 5-year CDS from the last quote
# before the Copom announcement to the 1st, 5th, 10th and 20th quote after
# it, per +50bp of orthogonalized surprise (e-mail of 2026-10-19, item 2).
#
# Reads output/event_trajectory/regressions.csv, written by
# script/event_trajectory.R. NOTHING is re-estimated here.
#
# Production base (111 meetings), common sample of 110: the Yahoo file ends
# on 2025-12-31, so the meeting of 2025-12-10 has no 20th quote. The 90%
# and 95% intervals are per horizon, with no multiple-horizon correction;
# the 90% interval is the darker ribbon. The line joins the four estimated
# quotes, marked by points.
#
# Output: paper/img/fig_ponte.pdf
# Notes: notas/2026-10-14_ponte_trajetoria_evento.md,
#   notas/2026-10-18_conferencias_ponte.md
# ===================================================================

PANEL_LABELS <- c(
  cambio_brl_usd = "Câmbio BRL/USD (R$/US$)",
  cds_5y         = "CDS 5 anos (p.b.)"
)

trajectory <- readr::read_csv(
  "output/event_trajectory/regressions.csv",
  show_col_types = FALSE
) |>
  dplyr::filter(
    base == "producao_111",
    sample == "comum",
    response %in% names(PANEL_LABELS)
  ) |>
  dplyr::mutate(
    panel = factor(PANEL_LABELS[response], levels = PANEL_LABELS)
  )

figure <- ggplot2::ggplot(trajectory, ggplot2::aes(x = k)) +
  ggplot2::geom_ribbon(
    ggplot2::aes(ymin = lo_95, ymax = hi_95),
    fill = "steelblue",
    alpha = 0.18
  ) +
  ggplot2::geom_ribbon(
    ggplot2::aes(ymin = lo_90, ymax = hi_90),
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
    ggplot2::aes(y = coef),
    colour = "black",
    linewidth = 0.8
  ) +
  ggplot2::geom_point(
    ggplot2::aes(y = coef),
    colour = "black",
    size = 1.6
  ) +
  ggplot2::facet_wrap(
    ggplot2::vars(panel),
    scales = "free_y",
    strip.position = "left"
  ) +
  ggplot2::scale_x_continuous(
    breaks = c(1, 5, 10, 20),
    expand = c(0.02, 0)
  ) +
  ggplot2::theme_classic(base_size = 11) +
  ggplot2::labs(x = "Cotações após o anúncio", y = NULL) +
  ggplot2::theme(
    strip.placement = "outside",
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(size = ggplot2::rel(0.95)),
    axis.title.x = ggplot2::element_text(size = ggplot2::rel(0.95)),
    axis.text = ggplot2::element_text(size = ggplot2::rel(0.85)),
    plot.margin = ggplot2::margin(3, 5, 1, 2)
  )

ggplot2::ggsave(
  "paper/img/fig_ponte.pdf",
  figure,
  width = 9.6,
  height = 3.1,
  device = cairo_pdf
)
