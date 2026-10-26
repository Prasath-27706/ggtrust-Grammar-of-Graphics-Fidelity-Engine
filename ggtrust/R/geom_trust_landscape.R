#' Landscape geom
#'
#' Smoothes per-point reliability into a continuous fidelity surface over the
#' panel, rendered as a semitransparent raster with optional contour lines and
#' the points overlaid. Suited to large point counts where per-point halos
#' would overplot.
#'
#' @inheritParams geom_trust_halo
#' @param grid_size Number of raster cells per axis (resolution of the surface).
#' @param smoothing Smoothing method: `"gam"`, `"loess"`, or `"idw"`.
#' @param bandwidth Smoothing bandwidth. For `"loess"` the `span`; for `"idw"`
#'   the distance-exponent `p`. `NULL` uses the default.
#' @param idw_k Number of nearest neighbors for `"idw"` smoothing.
#' @param raster_alpha Opacity of the raster fill (0–1).
#' @param contours Draw contour lines on the fidelity surface?
#' @param contour_bins Number of contour levels.
#' @param colourmap Colormap for the fidelity surface: a palette name
#'   (`"viridis"`, ...), a color vector, or a function from `[0,1]` to colors.
#' @return A `Layer` object.
#' @export
#' @examples
#' p <- ggplot2::ggplot(data.frame(x = rnorm(100), y = rnorm(100),
#'                                 rel = runif(100)),
#'                      ggplot2::aes(x, y, reliability = rel)) +
#'   geom_trust_landscape()
geom_trust_landscape <- function(mapping = NULL, data = NULL,
                                 grid_size = NULL,
                                 smoothing = NULL,
                                 bandwidth = NULL,
                                 idw_k = NULL,
                                 raster_alpha = NULL,
                                 contours = NULL,
                                 contour_bins = NULL,
                                 colourmap = NULL,
                                 na.rm = FALSE,
                                 show.legend = NA,
                                 inherit.aes = TRUE,
                                 ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = "identity",
    geom = GeomTrustLandscape,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      grid_size = as.integer(grid_size %||% trust_default("landscape.grid")),
      smoothing = smoothing %||% trust_default("landscape.smoothing"),
      bandwidth = bandwidth %||% trust_default("landscape.bandwidth"),
      idw_k = as.integer(idw_k %||% trust_default("landscape.idw_k")),
      raster_alpha = raster_alpha %||% trust_default("landscape.raster_alpha"),
      contours = contours %||% trust_default("landscape.contours"),
      contour_bins = as.integer(contour_bins %||% trust_default("landscape.contour_bins")),
      colourmap = colourmap %||% trust_default("landscape.colourmap"),
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_trust_landscape
#' @format NULL
#' @usage NULL
#' @export
GeomTrustLandscape <- ggplot2::ggproto(
  "GeomTrustLandscape", ggplot2::GeomPoint,
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  default_aes = ggplot2::aes(
    reliability = 1,
    colour = "grey30",
    size = 1.5,
    alpha = 1
  ),
  extra_params = c("grid_size", "smoothing", "bandwidth", "idw_k",
                    "raster_alpha", "contours", "contour_bins",
                    "colourmap", "na.rm"),
  parameters = function(self, extra = FALSE) {
    args <- c("grid_size", "smoothing", "bandwidth", "idw_k",
              "raster_alpha", "contours", "contour_bins", "colourmap")
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
                        grid_size = NULL, smoothing = NULL, bandwidth = NULL,
                        idw_k = NULL, raster_alpha = NULL, contours = NULL,
                        contour_bins = NULL, colourmap = NULL, na.rm = FALSE) {
    rel_raw <- .clamp01(data[[".rel_raw"]])
    if (is.null(rel_raw) || length(rel_raw) == 0) {
      rel_raw <- .clamp01(as.numeric(data[["reliability"]]))
    }
    if (is.null(rel_raw) || length(rel_raw) == 0) rel_raw <- rep(1, nrow(data))
    data$reliability <- rel_raw

    data_npc <- coord$transform(data, panel_params)
    data_npc$alpha <- ifelse(is.na(data_npc$alpha), 1, data_npc$alpha)

    build_landscape_grob(
      data_panel = data_npc,
      grid_size = as.integer(grid_size %||% trust_default("landscape.grid")),
      smoothing = smoothing %||% trust_default("landscape.smoothing"),
      bandwidth = bandwidth %||% trust_default("landscape.bandwidth"),
      idw_k = as.integer(idw_k %||% trust_default("landscape.idw_k")),
      raster_alpha = raster_alpha %||% trust_default("landscape.raster_alpha"),
      contours = contours %||% trust_default("landscape.contours"),
      contour_bins = as.integer(contour_bins %||% trust_default("landscape.contour_bins")),
      colourmap = colourmap %||% trust_default("landscape.colourmap")
    )
  },

  draw_key = function(data, params, size) {
    key_glyph_trust()(data, params, size)
  }
)