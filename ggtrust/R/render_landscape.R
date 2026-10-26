#' Build the landscape (raster + contours + points) grob tree
#'
#' Smoothes the reliability field over the panel, renders it as a semitransparent
#' raster with optional contour lines, and overlays the points.
#'
#' @param data_panel Data with `x`, `y` in panel npc units plus `reliability`,
#'   `colour`, `size`, `alpha`.
#' @param grid_size Number of cells per axis.
#' @param smoothing Smoothing method (see [smooth_reliability_2d()]).
#' @param bandwidth Smoothing bandwidth.
#' @param idw_k Neighbors for idw smoothing.
#' @param raster_alpha Opacity of the raster fill.
#' @param contours Draw contour lines?
#' @param contour_bins Number of contour levels.
#' @param colourmap Colormap: string name, color vector, or function.
#' @return A grid gTree.
#' @noRd
build_landscape_grob <- function(data_panel, grid_size, smoothing, bandwidth,
                                 idw_k, raster_alpha, contours, contour_bins,
                                 colourmap) {
  if (nrow(data_panel) == 0) return(grid::gTree(children = grid::gList()))

  if (is.null(data_panel$reliability)) {
    cli::cli_abort(
      "geom_trust_landscape() requires a {.field reliability} aesthetic ",
      "(e.g. {.code aes(reliability = my_col)})."
    )
  }

  surf <- smooth_reliability_2d(
    x = data_panel$x,
    y = data_panel$y,
    reliability = data_panel$reliability,
    grid_size = grid_size,
    method = smoothing,
    bandwidth = bandwidth,
    idw_k = idw_k
  )

  col_fun <- resolve_colourmap(colourmap)
  z_img <- surf$z[nrow(surf$z):1, , drop = FALSE]      # row 1 = top
  z_clamp <- .clamp01(z_img)
  img <- matrix(col_fun(as.numeric(z_clamp)), nrow = nrow(z_img), ncol = ncol(z_img))

  children <- list(
    grid::rasterGrob(
      image = img,
      x = grid::unit(0.5, "npc"), y = grid::unit(0.5, "npc"),
      width = grid::unit(1, "npc"), height = grid::unit(1, "npc"),
      interpolate = TRUE,
      gp = grid::gpar(alpha = raster_alpha)
    )
  )

  if (isTRUE(contours) && contour_bins > 0) {
    z_range <- range(surf$z, na.rm = TRUE)
    if (is.finite(z_range[1]) && is.finite(z_range[2]) && diff(z_range) > 1e-10) {
      levels <- .contour_levels(surf$z, contour_bins)
      lines <- grDevices::contourLines(x = surf$gx, y = surf$gy, z = surf$z,
                                       levels = levels)
      for (ln in lines) {
        children[[length(children) + 1L]] <- grid::polylineGrob(
          x = grid::unit(ln$x, "npc"),
          y = grid::unit(ln$y, "npc"),
          gp = grid::gpar(col = "black", lwd = 0.5)
        )
      }
    }
  }

  # points on top
  children[[length(children) + 1L]] <- grid::pointsGrob(
    x = grid::unit(data_panel$x, "npc"),
    y = grid::unit(data_panel$y, "npc"),
    pch = 21,
    size = grid::unit(data_panel$size, "mm"),
    gp = grid::gpar(
      col = scales::alpha(data_panel$colour, data_panel$alpha),
      fill = scales::alpha(data_panel$colour, data_panel$alpha)
    )
  )

  grid::gTree(
    children = do.call(grid::gList, children),
    name = "ggtrust_landscape_layer",
    cl = "ggtrust_landscape_layer"
  )
}

#' Resolve the colourmap argument to a function in [0,1] -> color
#' @noRd
resolve_colourmap <- function(colourmap) {
  if (is.function(colourmap)) return(colourmap)
  if (is.character(colourmap) && length(colourmap) == 1) {
    if (colourmap %in% c("viridis", "magma", "inferno", "plasma", "cividis") &&
        requireNamespace("viridisLite", quietly = TRUE)) {
      pal <- switch(colourmap,
        viridis = viridisLite::viridis,
        magma = viridisLite::magma,
        inferno = viridisLite::inferno,
        plasma = viridisLite::plasma,
        cividis = viridisLite::cividis)
      # Return a function: numeric [0,1] -> hex color
      function(x) {
        n <- length(x)
        cols <- pal(max(n, 1L))
        # Map each x value to a palette index
        idx <- pmax(1L, pmin(n, as.integer(round(x * (n - 1L) + 1L))))
        cols[idx]
      }
    }
    return(scales::gradient_n_pal(c("grey20", "#21918c")))
  }
  if (is.character(colourmap)) {
    return(scales::gradient_n_pal(colourmap))
  }
  cli::cli_abort("`colourmap` must be a function, color vector, or palette name.")
}

#' Quantile-based contour levels
#' @noRd
.contour_levels <- function(z, bins) {
  qs <- stats::quantile(z, probs = seq(0, 1, length.out = bins + 2),
                        na.rm = TRUE)
  qs[is.finite(qs)]
}