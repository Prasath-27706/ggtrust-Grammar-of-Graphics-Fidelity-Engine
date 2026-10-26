#' Uncertainty Crosshair Glyphs geom
#'
#' Draws directional error crosshairs centered on each data point whose arm lengths
#' scale inversely with spatialization fidelity (1 - fidelity). High-fidelity points
#' have compact or invisible crosshairs, while low-fidelity points have large,
#' prominent crosshairs representing a wide margin of positional error.
#'
#' @inheritParams geom_trust_halo
#' @param max_length Maximum crosshair arm length as a fraction of panel size (default 0.03 npc).
#' @param line_width Crosshair stroke width (default 0.6).
#' @param cross_color Color of the crosshairs (default "grey40").
#' @return A `Layer` object.
#' @export
#' @examples
#' df <- data.frame(x = 1:5, y = 1:5, rel = c(1, 0.8, 0.6, 0.4, 0.1))
#' ggplot2::ggplot(df, ggplot2::aes(x, y, reliability = rel)) +
#'   geom_trust_crosshair()
geom_trust_crosshair <- function(mapping = NULL, data = NULL,
                                max_length = 0.03,
                                line_width = 0.6,
                                cross_color = NULL,
                                na.rm = FALSE,
                                show.legend = NA,
                                inherit.aes = TRUE,
                                ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = "identity",
    geom = GeomTrustCrosshair,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      max_length = as.numeric(max_length),
      line_width = as.numeric(line_width),
      cross_color = cross_color,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_trust_crosshair
#' @format NULL
#' @usage NULL
#' @export
GeomTrustCrosshair <- ggplot2::ggproto(
  "GeomTrustCrosshair", ggplot2::GeomPoint,
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  default_aes = ggplot2::aes(
    reliability = 1,
    colour = "grey30",
    size = 1.5,
    alpha = 1
  ),
  extra_params = c("max_length", "line_width", "cross_color", "na.rm"),
  parameters = function(self, extra = FALSE) {
    args <- c("max_length", "line_width", "cross_color")
    if (extra) args <- union(args, self$extra_params)
    args
  },
  setup_data = function(data, params) {
    if ("reliability" %in% names(data)) {
      data[[".rel_raw"]] <- as.numeric(data[["reliability"]])
    }
    data
  },
  draw_panel = function(data, panel_params, coord,
                        max_length = 0.03, line_width = 0.6,
                        cross_color = NULL, na.rm = FALSE) {
    rel_raw <- .clamp01(data[[".rel_raw"]])
    if (is.null(rel_raw) || length(rel_raw) == 0) {
      rel_raw <- .clamp01(as.numeric(data[["reliability"]]))
    }
    if (is.null(rel_raw) || length(rel_raw) == 0) rel_raw <- rep(1, nrow(data))
    data$reliability <- rel_raw

    data_npc <- coord$transform(data, panel_params)
    n <- nrow(data_npc)
    if (n == 0) return(grid::gTree(children = grid::gList()))

    children <- list()

    for (i in seq_len(n)) {
      rel_i <- data_npc$reliability[i]
      arm <- max_length * (1 - rel_i)
      if (arm <= 0.001) next

      col_i <- cross_color %||% data_npc$colour[i]
      alpha_i <- 0.3 + 0.5 * (1 - rel_i)

      # Horizontal segment
      children[[length(children) + 1L]] <- grid::segmentsGrob(
        x0 = grid::unit(data_npc$x[i] - arm, "npc"),
        y0 = grid::unit(data_npc$y[i], "npc"),
        x1 = grid::unit(data_npc$x[i] + arm, "npc"),
        y1 = grid::unit(data_npc$y[i], "npc"),
        gp = grid::gpar(
          col = scales::alpha(col_i, alpha_i),
          lwd = line_width
        )
      )

      # Vertical segment
      children[[length(children) + 1L]] <- grid::segmentsGrob(
        x0 = grid::unit(data_npc$x[i], "npc"),
        y0 = grid::unit(data_npc$y[i] - arm, "npc"),
        x1 = grid::unit(data_npc$x[i], "npc"),
        y1 = grid::unit(data_npc$y[i] + arm, "npc"),
        gp = grid::gpar(
          col = scales::alpha(col_i, alpha_i),
          lwd = line_width
        )
      )
    }

    # Overlay points on top
    point_grob <- grid::pointsGrob(
      x = grid::unit(data_npc$x, "npc"),
      y = grid::unit(data_npc$y, "npc"),
      pch = 21,
      size = grid::unit(data_npc$size, "mm"),
      gp = grid::gpar(
        col = scales::alpha(data_npc$colour, data_npc$alpha),
        fill = scales::alpha(data_npc$colour, data_npc$alpha)
      )
    )
    children[[length(children) + 1L]] <- point_grob

    grid::gTree(
      children = do.call(grid::gList, children),
      name = "ggtrust_crosshair_layer",
      cl = "ggtrust_crosshair_layer"
    )
  },
  draw_key = function(data, params, size) {
    key_glyph_trust()(data, params, size)
  }
)

