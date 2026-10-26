#' Dimension-reduction fidelity stat
#'
#' Computes per-point trustworthiness \eqn{T(k, i)} and continuity
#' \eqn{C(k, i)} between the plotted embedding (`x`, `y`) and the original
#' space (`original_data`), then folds them into a single `[0, 1]`
#' `reliability` value attached to each point. Combine with
#' [geom_trust_halo()] / [geom_trust_landscape()] / [geom_trust_point()].
#'
#' @section Aggregation:
#' The two metrics are folded with `aggregation`:
#' * `"min"` (default): reliability = min(T, C) — the point is as trustworthy as
#'   its weakest neighborhood aspect.
#' * `"prod"`: reliability = T * C.
#' * `"avg"`: reliability = (T + C) / 2.
#'
#' @inheritParams stat_trust_manual
#' @param geom Which trust geom to draw.
#' @param original_data Data.frame or matrix of the original feature space
#'   (rows = points, matching the plotted embedding rows).
#' @param k Neighborhood size for T/C.
#' @param aggregation How to fold T and C into one reliability.
#' @return A `Layer` object.
#' @export
#' @examples
#' set.seed(1)
#' x <- matrix(rnorm(300), ncol = 3)
#' emb <- x[, 1:2] + rnorm(300, sd = 0.1)
#' d <- data.frame(x = emb[, 1], y = emb[, 2])
#' ggplot2::ggplot(d, ggplot2::aes(x, y)) +
#'   stat_trust_dr(original_data = x, k = 5)
stat_trust_dr <- function(mapping = NULL, data = NULL,
                          geom = "trust_point",
                          original_data,
                          k = 10,
                          aggregation = c("min", "prod", "avg"),
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE,
                          ...) {
  aggregation <- match.arg(aggregation)
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatTrustDR,
    geom = geom,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      original_data = original_data,
      k = k,
      aggregation = aggregation,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname stat_trust_dr
#' @format NULL
#' @usage NULL
#' @export
StatTrustDR <- ggplot2::ggproto(
  "StatTrustDR", ggplot2::Stat,
  required_aes = c("x", "y"),
  optional_aes = c("reliability"),
  compute_group = function(data, scales, original_data, k, aggregation,
                           na.rm = FALSE, ...) {
    emb <- as.matrix(data[, c("x", "y"), drop = FALSE])
    fc <- compute_fidelity(original_data, emb, k = k)
    reliability <- .fold_fidelity(fc$trustworthiness, fc$continuity, aggregation)
    data$reliability <- .clamp01(reliability)
    data
  }
)

#' Fold trustworthiness and continuity into one reliability value
#' @noRd
.fold_fidelity <- function(T, C, aggregation) {
  switch(aggregation,
    min  = pmin(T, C),
    prod = T * C,
    avg  = (T + C) / 2
  )
}