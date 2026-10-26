#' Trust point geom (encoding dispatcher)
#'
#' A convenience layer that renders reliability using either the halo or the
#' landscape encoding depending on `encoding`:
#'
#' * `"auto"` (default): dispatch on point count via [select_encoding()].
#' * `"halo"`: force [geom_trust_halo()].
#' * `"landscape"`: force [geom_trust_landscape()].
#'
#' @inheritParams geom_trust_halo
#' @param encoding One of `"auto"`, `"halo"`, `"landscape"`.
#' @param ... Passed down to the selected geom (e.g. `max_radius`,
#'   `grid_size`, `colourmap`).
#' @return A `Layer` object.
#' @export
#' @examples
#' p <- ggplot2::ggplot(data.frame(x = 1:10, rel = seq(0, 1, length.out = 10)),
#'                      ggplot2::aes(x, reliability = rel)) +
#'   geom_trust_point()
geom_trust_point <- function(mapping = NULL, data = NULL,
                             encoding = c("auto", "halo", "landscape"),
                             na.rm = FALSE,
                             show.legend = NA,
                             inherit.aes = TRUE,
                             ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = "identity",
    geom = GeomTrustPoint,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      encoding = match.arg(encoding),
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_trust_point
#' @format NULL
#' @usage NULL
#' @export
GeomTrustPoint <- ggplot2::ggproto(
  "GeomTrustPoint", ggplot2::Geom,
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  default_aes = ggplot2::aes(
    reliability = 1,
    colour = "grey30",
    size = 1.5,
    alpha = 1
  ),
  extra_params = c("encoding", "na.rm"),
  parameters = function(self, extra = FALSE) {
    args <- c("encoding")
    if (extra) args <- union(args, self$extra_params)
    args
  },
  setup_data = function(data, params) {
    if ("reliability" %in% names(data)) {
      data[[".rel_raw"]] <- as.numeric(data[["reliability"]])
    }
    data
  },
  draw_panel = function(data, panel_params, coord, encoding = "auto", na.rm = FALSE) {
    if (nrow(data) == 0) return(grid::gTree(children = grid::gList()))

    resolved <- select_encoding(nrow(data))
    target <- if (identical(encoding, "auto")) resolved else encoding

    # Restore raw numeric reliability (scale may have replaced it with colors)
    rel_raw <- .clamp01(data[[".rel_raw"]])
    if (is.null(rel_raw) || length(rel_raw) == 0) {
      rel_raw <- .clamp01(as.numeric(data[["reliability"]]))
    }
    if (!is.null(rel_raw) && length(rel_raw) > 0) data$reliability <- rel_raw

    data_npc <- coord$transform(data, panel_params)
    data_npc$alpha <- ifelse(is.na(data_npc$alpha), 1, data_npc$alpha)

    if (identical(target, "halo")) {
      build_halo_grob(
        data_panel = data_npc,
        max_radius = trust_default("halo.max_radius"),
        n_layers = as.integer(trust_default("halo.n_layers")),
        falloff = trust_default("halo.falloff"),
        base_intensity = trust_default("halo.base_intensity"),
        expansion = trust_default("halo.expansion")
      )
    } else {
      build_landscape_grob(
        data_panel = data_npc,
        grid_size = as.integer(trust_default("landscape.grid")),
        smoothing = trust_default("landscape.smoothing"),
        bandwidth = trust_default("landscape.bandwidth"),
        idw_k = as.integer(trust_default("landscape.idw_k")),
        raster_alpha = trust_default("landscape.raster_alpha"),
        contours = trust_default("landscape.contours"),
        contour_bins = as.integer(trust_default("landscape.contour_bins")),
        colourmap = trust_default("landscape.colourmap")
      )
    }
  },

  draw_key = function(data, params, size) {
    key_glyph_trust()(data, params, size)
  }
)