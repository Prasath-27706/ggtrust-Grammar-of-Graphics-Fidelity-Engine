#' Trust theme
#'
#' A minimal, DR-friendly ggplot2 theme tuned for the trust geoms: no grid
#' lines, no axes (positions carry no independent meaning in DR projections),
#' light background, and generous margins so halos are not clipped at panel
#' edges.
#'
#' @inheritParams ggplot2::theme
#' @param base_size Base font size.
#' @param base_family Base font family.
#' @return A `theme` object.
#' @export
#' @examples
#' p <- ggplot2::ggplot(data.frame(x = 1:5, rel = seq(0, 1, length.out = 5)),
#'                      ggplot2::aes(x, x, reliability = rel)) +
#'   geom_trust_halo() + theme_trust()
theme_trust <- function(base_size = 11, base_family = "") {
  ggplot2::theme_bw(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "white", colour = NA),
      axis.ticks = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.title = ggplot2::element_text(size = rel(0.9)),
      legend.key = ggplot2::element_rect(fill = "white", colour = NA),
      legend.position = "right",
      plot.margin = ggplot2::margin(0.4, 0.4, 0.2, 0.2, "cm")
    )
}