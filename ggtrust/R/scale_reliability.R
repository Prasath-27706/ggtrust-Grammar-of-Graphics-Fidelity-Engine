#' Reliability scales
#'
#' Scales for the `reliability` aesthetic. Reliability is a `[0, 1]` value;
#' both scales clamp the domain to `[0, 1]` rather than erroring on out-of-range
#' input. The default palette runs from a muted dark grey (unreliable) to a
#' saturated teal (reliable).
#'
#' @inheritParams ggplot2::continuous_scale
#' @inheritDotParams ggplot2::continuous_scale
#' @param range Two-element color vector for the low/high endpoints.
#' @param guide Guide function or object; defaults to [guide_reliability()].
#' @export
#' @examples
#' p <- ggplot2::ggplot(data.frame(x = 1:10, rel = seq(0, 1, length.out = 10)),
#'                      ggplot2::aes(x, reliability = rel)) +
#'   geom_trust_halo()
#' p + scale_reliability_continuous()
scale_reliability_continuous <- function(..., range = c("grey20", "#21918c"),
                                         guide = guide_reliability()) {
  ggplot2::continuous_scale(
    aesthetics = "reliability",
    palette = scales::gradient_n_pal(range),
    limits = c(0, 1),
    na.value = "grey50",
    guide = guide,
    ...
  )
}

#' @rdname scale_reliability_continuous
#' @param n_bins Number of bins for [scale_reliability_binned()].
#' @param right When `TRUE`, bins are right-closed.
#' @export
scale_reliability_binned <- function(..., n_bins = 5,
                                     range = c("grey20", "#21918c"),
                                     guide = guide_reliability()) {
  ggplot2::binned_scale(
    aesthetics = "reliability",
    palette = scales::gradient_n_pal(range),
    limits = c(0, 1),
    breaks = waiver(),
    n.breaks = n_bins,
    na.value = "grey50",
    guide = guide,
    ...
  )
}