#' ggtrust: Visualize spatialization fidelity in DR-derived scatterplots
#'
#' A grammar-of-graphics extension for [ggplot2::ggplot2()] that marks how
#' trustworthy each point's position is in a dimension-reduction scatterplot
#' (t-SNE, UMAP, PCA, MDS).
#'
#' @section Encodings:
#' Two fidelity encodings ship with v0.1:
#' \itemize{
#'   \item `geom_trust_halo()`: per-point concentric Gaussian halos. Radius
#'     grows with `1 - reliability` (flagging), opacity grows with reliability
#'     (assessment). Halos are drawn behind the points.
#'   \item `geom_trust_landscape()`: a smoothed fidelity surface (raster +
#'     contours) with points overlaid.
#' }
#' `geom_trust_point()` dispatches between them automatically by point count.
#'
#' @section Fidelity vs. uncertainty:
#' Spatialization fidelity is the extent to which a point's low-dimensional
#' position reflects its original-space neighborhood. It is *not* statistical
#' uncertainty about a measured value, and applying it to non-DR plots is
#' conceptually unsupported.
#'
#' @seealso [geom_trust_halo()], [geom_trust_landscape()], [geom_trust_point()],
#'   [stat_trust_dr()], [stat_trust_manual()], [scale_reliability_continuous()],
#'   [theme_trust()]
#'
#' @keywords internal
"_PACKAGE"
