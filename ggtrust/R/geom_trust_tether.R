#' Topological Neighbor Tether geom
#'
#' Draws line segments (tethers) connecting low-fidelity points to their true
#' nearest neighbors in the original high-dimensional space. When a dimensionality
#' reduction algorithm (e.g. t-SNE or UMAP) tears a cluster or displaces points,
#' these tethers stretch across the plotting canvas, visually revealing topological
#' distortion and false neighborhood structures.
#'
#' @inheritParams geom_trust_halo
#' @param original_data Matrix or data.frame of high-dimensional feature coordinates
#'   matching the plotted rows. If NULL, uses the dataset's high-D space when provided.
#' @param k_tether Number of true original-space nearest neighbors to connect to (default 3).
#' @param fidelity_threshold Only points with reliability below this threshold
#'   will emit neighbor tethers (default 0.75).
#' @param max_alpha Maximum opacity of the tether lines (default 0.4).
#' @param line_color Color of the tether lines (default "#ef4444" / red).
#' @return A `Layer` object.
#' @export
#' @examples
#' set.seed(42)
#' x <- matrix(rnorm(100), ncol = 5)
#' emb <- x[, 1:2] + rnorm(40, sd = 0.2)
#' df <- data.frame(x = emb[, 1], y = emb[, 2], rel = runif(20))
#' p <- ggplot2::ggplot(df, ggplot2::aes(x, y, reliability = rel)) +
#'   geom_trust_tether(original_data = x)
geom_trust_tether <- function(mapping = NULL, data = NULL,
                             original_data = NULL,
                             k_tether = 3L,
                             fidelity_threshold = 0.75,
                             max_alpha = 0.4,
                             line_color = "#ef4444",
                             na.rm = FALSE,
                             show.legend = NA,
                             inherit.aes = TRUE,
                             ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = "identity",
    geom = GeomTrustTether,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      original_data = original_data,
      k_tether = as.integer(k_tether),
      fidelity_threshold = as.numeric(fidelity_threshold),
      max_alpha = as.numeric(max_alpha),
      line_color = line_color,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_trust_tether
#' @format NULL
#' @usage NULL
#' @export
GeomTrustTether <- ggplot2::ggproto(
  "GeomTrustTether", ggplot2::GeomPoint,
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  default_aes = ggplot2::aes(
    reliability = 1,
    colour = "grey30",
    size = 1.5,
    alpha = 1
  ),
  extra_params = c("original_data", "k_tether", "fidelity_threshold", "max_alpha", "line_color", "na.rm"),
  parameters = function(self, extra = FALSE) {
    args <- c("original_data", "k_tether", "fidelity_threshold", "max_alpha", "line_color")
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
                        original_data = NULL, k_tether = 3L,
                        fidelity_threshold = 0.75, max_alpha = 0.4,
                        line_color = "#ef4444", na.rm = FALSE) {
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

    # If original_data is provided, calculate true high-D neighbors
    if (!is.null(original_data) && nrow(original_data) == n) {
      nn_res <- find_knn(as.matrix(original_data), k = min(k_tether, n - 1L))
      nn_idx <- nn_res$index

      for (i in seq_len(n)) {
        rel_i <- data_npc$reliability[i]
        if (is.na(rel_i) || rel_i > fidelity_threshold) next

        tension <- (1 - rel_i)
        seg_alpha <- max_alpha * tension

        for (k_col in seq_len(ncol(nn_idx))) {
          j <- nn_idx[i, k_col]
          if (is.na(j) || j == i) next

          # Draw segment from point i to high-D neighbor j
          children[[length(children) + 1L]] <- grid::segmentsGrob(
            x0 = grid::unit(data_npc$x[i], "npc"),
            y0 = grid::unit(data_npc$y[i], "npc"),
            x1 = grid::unit(data_npc$x[j], "npc"),
            y1 = grid::unit(data_npc$y[j], "npc"),
            gp = grid::gpar(
              col = scales::alpha(line_color, seg_alpha),
              lwd = 0.8 * tension + 0.2,
              lty = "dashed"
            )
          )
        }
      }
    }

    # Overlay points
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
      name = "ggtrust_tether_layer",
      cl = "ggtrust_tether_layer"
    )
  },
  draw_key = function(data, params, size) {
    key_glyph_trust()(data, params, size)
  }
)

