#' Reliability guide
#'
#' A legend guide whose key glyphs depict the halo encoding: a large faint ring
#' at the low-fidelity end and a compact saturated core at the high-fidelity
#' end, so the legend itself teaches the encoding.
#'
#' @inheritParams ggplot2::guide_legend
#' @param ... Passed to [ggplot2::guide_legend()].
#' @return A `Guide` ggproto object.
#' @export
#' @examples
#' p <- ggplot2::ggplot(data.frame(x = 1:5, rel = c(0, .25, .5, .75, 1)),
#'                      ggplot2::aes(x, reliability = rel)) +
#'   geom_trust_halo() +
#'   scale_reliability_continuous(guide = guide_reliability())
guide_reliability <- function(...) {
  ggplot2::guide_legend(...)
}

#' Trust key glyph
#'
#' Legend key drawing function for the trust geoms. Draws the reliability
#' encoding of a single break value: halo radius `1 - value`, core opacity
#' `value`.
#'
#' @return A function suitable as a `key_glyph` argument.
#' @export
key_glyph_trust <- function() {
  function(data, params, size) {
    if (length(data$reliability) == 0 || all(is.na(data$reliability))) {
      reliability <- 1
    } else {
      reliability <- suppressWarnings(as.numeric(data$reliability[1]))
      if (is.na(reliability)) reliability <- 1
    }

    # grid::unit in npc for the panel cell
    unit_x <- grid::unit(0.5, "npc")
    unit_y <- grid::unit(0.5, "npc")

    # halo: radius shrinks as reliability rises
    radius <- grid::unit(0.35 * (1 - reliability) + 0.01, "snpc")
    halo <- grid::circleGrob(
      x = unit_x, y = unit_y, r = radius,
      gp = grid::gpar(
        fill = scales::alpha(data$colour %||% "black",
                             data$alpha %||% 0.25 * reliability),
        col = NA
      )
    )

    # point core
    core <- grid::pointsGrob(
      x = unit_x, y = unit_y, pch = 19, size = grid::unit(2, "mm"),
      gp = grid::gpar(col = data$colour %||% "black", fill = data$colour %||% "black")
    )

    grid::grobTree(halo, core)
  }
}