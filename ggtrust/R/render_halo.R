#' Build the halo + point grob tree
#'
#' Renders per-point concentric Gaussian halos behind the points. Halos are
#' constructed in panel (npc) coordinates so they are circular on screen
#' regardless of the axis scales.
#'
#' @param data_panel Data frame with `x`, `y` in panel (npc) units plus
#'   `reliability`, `colour`, `size`, `alpha`.
#' @param max_radius Maximum halo radius as a fraction of the panel (snpc).
#' @param n_layers Number of concentric rings.
#' @param falloff Gaussian sigma of the ring weight falloff.
#' @param base_intensity Opacity factor at reliability = 1.
#' @param expansion Minimum radius so reliability = 1 still draws a core ring.
#' @return A grid gTree.
#' @noRd
build_halo_grob <- function(data_panel, max_radius, n_layers, falloff,
                            base_intensity, expansion) {
  n <- nrow(data_panel)
  if (n == 0) return(grid::gTree(children = grid::gList()))

  reliability <- data_panel$reliability
  reliability[is.na(reliability)] <- 1

  children <- list()

  for (i in seq_len(n)) {
    r_i <- reliability[i]
    extent <- max_radius * (1 - r_i) + expansion
    if (extent <= 0) next

    colour <- data_panel$colour[i]
    base_alpha <- data_panel$alpha[i]
    if (is.na(base_alpha)) base_alpha <- 1

    for (l in seq_len(n_layers)) {
      t <- l / n_layers
      radius <- extent * t
      weight <- exp(-0.5 * ((1 - t) / falloff) ^ 2)
      alpha_layer <- base_intensity * r_i * weight * base_alpha
      if (alpha_layer <= 0) next
      children[[length(children) + 1L]] <- grid::circleGrob(
        x = grid::unit(data_panel$x[i], "npc"),
        y = grid::unit(data_panel$y[i], "npc"),
        r = grid::unit(radius, "snpc"),
        gp = grid::gpar(fill = scales::alpha(colour, alpha_layer), col = NA)
      )
    }
  }

  # points on top
  point_grob <- grid::pointsGrob(
    x = grid::unit(data_panel$x, "npc"),
    y = grid::unit(data_panel$y, "npc"),
    pch = 21,
    size = grid::unit(data_panel$size, "mm"),
    gp = grid::gpar(
      col = scales::alpha(data_panel$colour, data_panel$alpha),
      fill = scales::alpha(data_panel$colour, data_panel$alpha)
    )
  )
  children[[length(children) + 1L]] <- point_grob

  grid::gTree(
    children = do.call(grid::gList, children),
    name = "ggtrust_halo_layer",
    cl = "ggtrust_halo_layer"
  )
}