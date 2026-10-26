#' Halo geom
#'
#' Draws a concentric Gaussian halo behind each point that encodes its
#' spatialization fidelity. A point with high reliability gets a small, opaque
#' halo; a point with low reliability gets a large, faint halo. The encoding
#' therefore resolves the interpretation paradox: unreliable points are *flagged*
#' (large extent) yet *de-emphasized* (low opacity).
#'
#' @inheritParams ggplot2::geom_point
#' @param max_radius Maximum halo radius as a fraction of the panel (snpc
#'   units). Points with reliability 0 reach this extent, a proxy for "position
#'   carries no neighborhood information".
#' @param n_layers Number of concentric rings per point.
#' @param falloff Gaussian sigma controlling how quickly ring weight decays from
#'   the core.
#' @param base_intensity Base opacity factor at reliability = 1.
#' @param na.rm If `FALSE` (default), missing values are removed with a
#'   warning. Set to `TRUE` for silent removal.
#' @return A `Layer` object.
#' @export
#' @examples
#' p <- ggplot2::ggplot(data.frame(x = 1:10, rel = seq(0, 1, length.out = 10)),
#'                      ggplot2::aes(x, reliability = rel)) +
#'   geom_trust_halo()
geom_trust_halo <- function(mapping = NULL, data = NULL,
                            max_radius = NULL,
                            n_layers = NULL,
                            falloff = NULL,
                            base_intensity = NULL,
                            na.rm = FALSE,
                            show.legend = NA,
                            inherit.aes = TRUE,
                            ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = "identity",
    geom = GeomTrustHalo,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      max_radius = max_radius %||% trust_default("halo.max_radius"),
      n_layers = n_layers %||% trust_default("halo.n_layers"),
      falloff = falloff %||% trust_default("halo.falloff"),
      base_intensity = base_intensity %||% trust_default("halo.base_intensity"),
      expansion = trust_default("halo.expansion"),
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_trust_halo
#' @format NULL
#' @usage NULL
#' @export
GeomTrustHalo <- ggplot2::ggproto(
  "GeomTrustHalo", ggplot2::GeomPoint,
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  default_aes = ggplot2::aes(
    reliability = 1,
    colour = "grey30",
    size = 1.5,
    alpha = 1
  ),
  extra_params = c("max_radius", "n_layers", "falloff",
                    "base_intensity", "expansion", "na.rm"),
  parameters = function(self, extra = FALSE) {
    args <- c("max_radius", "n_layers", "falloff", "base_intensity", "expansion")
    if (extra) args <- union(args, self$extra_params)
    args
  },
  setup_data = function(data, params) {
    # Preserve raw numeric reliability before any scale replaces it with colors
    if ("reliability" %in% names(data)) {
      data[[".rel_raw"]] <- as.numeric(data[["reliability"]])
    }
    data
  },
  draw_panel = function(data, panel_params, coord,
                        max_radius = NULL, n_layers = NULL, falloff = NULL,
                        base_intensity = NULL, expansion = NULL, na.rm = FALSE) {
    rel_raw <- .clamp01(data[[".rel_raw"]])
    if (is.null(rel_raw) || length(rel_raw) == 0) {
      rel_raw <- .clamp01(as.numeric(data[["reliability"]]))
    }
    if (is.null(rel_raw) || length(rel_raw) == 0) rel_raw <- rep(1, nrow(data))
    data$reliability <- rel_raw

    data_npc <- coord$transform(data, panel_params)
    data_npc$alpha <- ifelse(is.na(data_npc$alpha), 1, data_npc$alpha)

    build_halo_grob(
      data_panel = data_npc,
      max_radius = max_radius %||% trust_default("halo.max_radius"),
      n_layers = as.integer(n_layers %||% trust_default("halo.n_layers")),
      falloff = falloff %||% trust_default("halo.falloff"),
      base_intensity = base_intensity %||% trust_default("halo.base_intensity"),
      expansion = expansion %||% trust_default("halo.expansion")
    )
  },
  draw_key = function(data, params, size) {
    key_glyph_trust()(data, params, size)
  }
)